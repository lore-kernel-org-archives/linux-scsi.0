Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1A5C10DCE
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 00:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51789206F8
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 00:38:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Qs99+noL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgCYAif (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 20:38:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55262 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727099AbgCYAif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Mar 2020 20:38:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02P0aio3004908;
        Tue, 24 Mar 2020 17:38:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=iRg3R4byPUV8Esxqg/nN5c0n5bZwit3VO1LSWrmsl/o=;
 b=Qs99+noLxuygQ4zr+djSx/nHQZ9dzI/yWFIGw9RrnZHtFYRgwR/2u30RxjUTvZ9ohh1u
 AiNMki7dpKRb4zmOY9bZ/IrMjNm5FW1Q5DGHY0U1lGjEJ6rBsjFS39tU4IJ5TrBdSolS
 3zQaE4hiMYBeJnpmolyS+zGvWAAggCTCdxmBIsWfqbUFDX2YHjIqhH1L10rs4L8ch6eQ
 /tmzqNamNxmP5KhFCTAQdstp734jUMWDbJDGStkRhUls1KZxY4+Z2gGXw797K7ZsPdNG
 bsDfKX2/rvmb8lHzlkMOtiUsqwRRrgWpOjoEGBsEZ/kyDBOV4fHPzLOTebRbaTGvR0Wu pQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ywvkqv7pk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 17:38:28 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Mar
 2020 17:38:26 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Mar
 2020 17:38:25 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 24 Mar 2020 17:38:24 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id E53053F7040;
        Tue, 24 Mar 2020 17:38:24 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 02P0cOnl019954;
        Tue, 24 Mar 2020 17:38:24 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Tue, 24 Mar 2020 17:38:24 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Martin Wilck <mwilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Daniel Wagner <dwagner@suse.de>,
        "James Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] scsi: qla2xxx: set UNLOADING before waiting for
 session deletion
In-Reply-To: <20200205214422.3657-4-mwilck@suse.com>
Message-ID: <alpine.LRH.2.21.9999.2003241737170.12727@irv1user01.caveonetworks.com>
References: <20200205214422.3657-1-mwilck@suse.com>
 <20200205214422.3657-4-mwilck@suse.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-24_10:2020-03-23,2020-03-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 5 Feb 2020, 1:44pm, mwilck@suse.com wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> The purpose of the UNLOADING flag is to avoid port login procedures
> to continue when a controller is in the process of shutting down.
> It makes sense to set this flag before starting session teardown.
> The only operations that must be able to continue are LOGO, PRLO,
> and the like.
> 
> Furthermore, use atomic test_and_set_bit() to avoid the shutdown
> being run multiple times in parallel. In qla2x00_disable_board_on_pci_error(),
> the test for UNLOADING is postponed until after the check for an already
> disabled PCI board.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 25 +++++++++++--------------
>  1 file changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index e81080d..8329f95 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3720,16 +3720,15 @@ qla2x00_remove_one(struct pci_dev *pdev)
>  	}
>  	qla2x00_wait_for_hba_ready(base_vha);
>  
> -	qla2x00_wait_for_sess_deletion(base_vha);
> -
>  	/*
> -	 * if UNLOAD flag is already set, then continue unload,
> +	 * if UNLOADING flag is already set, then continue unload,
>  	 * where it was set first.
>  	 */
> -	if (test_bit(UNLOADING, &base_vha->dpc_flags))
> +	if (test_and_set_bit(UNLOADING, &base_vha->dpc_flags))
>  		return;
>  
> -	set_bit(UNLOADING, &base_vha->dpc_flags);
> +	qla2x00_wait_for_sess_deletion(base_vha);
> +
>  	if (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
>  	    IS_QLA28XX(ha)) {
>  		if (ha->flags.fw_started)
> @@ -6046,13 +6045,6 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
>  	struct pci_dev *pdev = ha->pdev;
>  	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
>  
> -	/*
> -	 * if UNLOAD flag is already set, then continue unload,
> -	 * where it was set first.
> -	 */
> -	if (test_bit(UNLOADING, &base_vha->dpc_flags))
> -		return;
> -
>  	ql_log(ql_log_warn, base_vha, 0x015b,
>  	    "Disabling adapter.\n");
>  
> @@ -6063,9 +6055,14 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
>  		return;
>  	}
>  
> -	qla2x00_wait_for_sess_deletion(base_vha);
> +	/*
> +	 * if UNLOADING flag is already set, then continue unload,
> +	 * where it was set first.
> +	 */
> +	if (test_and_set_bit(UNLOADING, &base_vha->dpc_flags))
> +		return;
>  
> -	set_bit(UNLOADING, &base_vha->dpc_flags);
> +	qla2x00_wait_for_sess_deletion(base_vha);
>  
>  	qla2x00_delete_all_vps(ha, base_vha);
>  
> 

This was done on top of PATCH 2/3, please resend dropping 2. The 
test_and_set_bit() part looks ok.

Regards,
-Arun
