Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A835C3A5A2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 14:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED8B820828
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 14:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbfICOtb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:49:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727667AbfICOtb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Sep 2019 10:49:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4FD0C8AC6FD;
        Tue,  3 Sep 2019 14:49:31 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7A2F5D6B2;
        Tue,  3 Sep 2019 14:49:30 +0000 (UTC)
Message-ID: <a41e1293ee3c50d21e1700cfeeca4329e7551a01.camel@redhat.com>
Subject: Re: [PATCH 3/6] qla2xxx: Fix driver reload for ISP82xx
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 03 Sep 2019 10:49:30 -0400
In-Reply-To: <20190830222402.23688-4-hmadhani@marvell.com>
References: <20190830222402.23688-1-hmadhani@marvell.com>
         <20190830222402.23688-4-hmadhani@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Tue, 03 Sep 2019 14:49:31 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2019-08-30 at 15:23 -0700, Himanshu Madhani wrote:
> HINT_MBX_INT_PENDING is not guaranteed to be cleared by
> firmware. Remove check that prevent driver load with ISP82XX.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 16 ++--------------
>  drivers/scsi/qla2xxx/qla_nx.c  |  3 ++-
>  2 files changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index a82b6db2fa9d..4c858e2d0ea8 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -253,21 +253,9 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
>  	if ((!abort_active && io_lock_on) || IS_NOPOLLING_TYPE(ha)) {
>  		set_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
>  
> -		if (IS_P3P_TYPE(ha)) {
> -			if (RD_REG_DWORD(&reg->isp82.hint) &
> -				HINT_MBX_INT_PENDING) {
> -				ha->flags.mbox_busy = 0;
> -				spin_unlock_irqrestore(&ha->hardware_lock,
> -					flags);
> -
> -				atomic_dec(&ha->num_pend_mbx_stage2);
> -				ql_dbg(ql_dbg_mbx, vha, 0x1010,
> -				    "Pending mailbox timeout, exiting.\n");
> -				rval = QLA_FUNCTION_TIMEOUT;
> -				goto premature_exit;
> -			}
> +		if (IS_P3P_TYPE(ha))
>  			WRT_REG_DWORD(&reg->isp82.hint, HINT_MBX_INT_PENDING);
> -		} else if (IS_FWI2_CAPABLE(ha))
> +		else if (IS_FWI2_CAPABLE(ha))
>  			WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_SET_HOST_INT);
>  		else
>  			WRT_REG_WORD(&reg->isp.hccr, HCCR_SET_HOST_INT);
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
> index a79f8da38abe..2b2028f2383e 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -2287,7 +2287,8 @@ qla82xx_disable_intrs(struct qla_hw_data *ha)
>  {
>  	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
>  
> -	qla82xx_mbx_intr_disable(vha);
> +	if (ha->interrupts_on)
> +		qla82xx_mbx_intr_disable(vha);
>  
>  	spin_lock_irq(&ha->hardware_lock);
>  	if (IS_QLA8044(ha))

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

