Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D5C8C3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 14:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B8FE20882
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 14:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbfICOvB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:51:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42465 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728679AbfICOvA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Sep 2019 10:51:00 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1141B106E292;
        Tue,  3 Sep 2019 14:51:00 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 862175DD63;
        Tue,  3 Sep 2019 14:50:59 +0000 (UTC)
Message-ID: <ce437da8e9f8fe3852225c1a55a871ca45e1abeb.camel@redhat.com>
Subject: Re: [PATCH 4/6] qla2xxx: Fix stuck login session
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 03 Sep 2019 10:50:59 -0400
In-Reply-To: <20190830222402.23688-5-hmadhani@marvell.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
         <20190830222402.23688-5-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Tue, 03 Sep 2019 14:51:00 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2019-08-30 at 15:24 -0700, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Login session was stucked on cable pull. When FW is in the middle
> PRLI PENDING + driver is in Initiator mode, driver fail to
> check back with FW to see if the PRLI has completed. This patch
> would re-check with FW again to make sure PRLI would complete before
> pushing forward with relogin.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 8161f08f3a4d..2bbadcf60295 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -808,6 +808,15 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
>  			fcport->fw_login_state = current_login_state;
>  			fcport->d_id = id;
>  			switch (current_login_state) {
> +			case DSC_LS_PRLI_PEND:
> +				/*
> +				 * In the middle of PRLI. Let it finish.
> +				 * Allow relogin code to recheck state again
> +				 * with GNL. Push disc_state back to DELETED
> +				 * so GNL can go out again
> +				 */
> +				fcport->disc_state = DSC_DELETED;
> +				break;
>  			case DSC_LS_PRLI_COMP:
>  				if ((e->prli_svc_param_word_3[0] & BIT_4) == 0)
>  					fcport->port_type = FCT_INITIATOR;
> @@ -1474,7 +1483,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
>  	u64 wwn;
>  	u16 sec;
>  
> -	ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x20d8,
> +	ql_dbg(ql_dbg_disc, vha, 0x20d8,
>  	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d lid %d scan %d\n",
>  	    __func__, fcport->port_name, fcport->disc_state,
>  	    fcport->fw_login_state, fcport->login_pause, fcport->flags,
> @@ -1485,6 +1494,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
>  		return 0;
>  
>  	if ((fcport->loop_id != FC_NO_LOOP_ID) &&
> +	    qla_dual_mode_enabled(vha) &&
>  	    ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
>  	     (fcport->fw_login_state == DSC_LS_PRLI_PEND)))
>  		return 0;
> @@ -1674,17 +1684,6 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
>  	    fcport->last_login_gen, fcport->login_gen,
>  	    fcport->flags);
>  
> -	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
> -	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
> -		return;
> -
> -	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
> -		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline)) {
> -			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
> -			return;
> -		}
> -	}
> -
>  	if (fcport->last_rscn_gen != fcport->rscn_gen) {
>  		ql_dbg(ql_dbg_disc, vha, 0x20e9, "%s %d %8phC post gnl\n",
>  		    __func__, __LINE__, fcport->port_name);

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

