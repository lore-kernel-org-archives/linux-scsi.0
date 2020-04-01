Return-Path: <SRS0=ctNG=5R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6CB6C43331
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 17:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98C342071A
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Apr 2020 17:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Re4pU/Gr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732920AbgDARCV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Apr 2020 13:02:21 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32832 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732717AbgDARCU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Apr 2020 13:02:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 031Goc6v029912;
        Wed, 1 Apr 2020 10:02:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=vrsUKMi7DUiSHBZM6Ecy+E9G9dUqbTbuLvhcMVd1pto=;
 b=Re4pU/Grk8RePmnj5c3+ACOcVJ6qY+Sgk9geyVkMC7ufOdYs1c9wzPHRxg+amDQFePk/
 EOMXvvWNXMZ58bRgA1lXSxHAWoRlCPTuOdvnjOZUPy/4pckNK3NbuBAsiwBJfZ8IJSEH
 MTfQlPKyWTmVecaMzTEbE9hFxX9yZlgrgRxjC3f1pETIlUvU+8Gf5VItNeXn6jl5p7h6
 qdTc0dUqiwzxFjuZOacvIlV7ZJZ+Q6AyGyQDq6oN4gmseCcNc/F+pJ5nkIeASR1+iaxK
 1BNnexr+1swyhEG3MfO5uBSmo2o9gtKRfEeIVuMubtNNgmSa5AJXnwyksCLN01XwTlMi 9w== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3046h5xcr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 Apr 2020 10:02:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Apr
 2020 10:02:08 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Apr
 2020 10:02:08 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 1 Apr 2020 10:02:07 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id BAB813F703F;
        Wed,  1 Apr 2020 10:02:07 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 031H26pr011063;
        Wed, 1 Apr 2020 10:02:06 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Wed, 1 Apr 2020 10:02:06 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Martin Wilck <mwilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Roman Bolshakov" <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>,
        "Bart Van Assche" <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.de>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] scsi: qla2xxx: set UNLOADING before waiting for
 session deletion
In-Reply-To: <20200327164711.5358-2-mwilck@suse.com>
Message-ID: <alpine.LRH.2.21.9999.2004011002000.12727@irv1user01.caveonetworks.com>
References: <20200327164711.5358-1-mwilck@suse.com>
 <20200327164711.5358-2-mwilck@suse.com>
User-Agent: Alpine 2.21.9999 (LRH 334 2019-03-29)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-01_03:2020-03-31,2020-04-01 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 27 Mar 2020, 9:47am, mwilck@suse.com wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> The purpose of the UNLOADING flag is to avoid port login procedures
> to continue when a controller is in the process of shutting down.
> It makes sense to set this flag before starting session teardown.
> 
> Furthermore, use atomic test_and_set_bit() to avoid the shutdown
> being run multiple times in parallel. In qla2x00_disable_board_on_pci_error(),
> the test for UNLOADING is postponed until after the check for an already
> disabled PCI board.
> 
> Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 32 ++++++++++++++------------------
>  1 file changed, 14 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d9072ea..ce0dabb 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3732,6 +3732,13 @@ qla2x00_remove_one(struct pci_dev *pdev)
>  	}
>  	qla2x00_wait_for_hba_ready(base_vha);
>  
> +	/*
> +	 * if UNLOADING flag is already set, then continue unload,
> +	 * where it was set first.
> +	 */
> +	if (test_and_set_bit(UNLOADING, &base_vha->dpc_flags))
> +		return;
> +
>  	if (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
>  	    IS_QLA28XX(ha)) {
>  		if (ha->flags.fw_started)
> @@ -3750,15 +3757,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
>  
>  	qla2x00_wait_for_sess_deletion(base_vha);
>  
> -	/*
> -	 * if UNLOAD flag is already set, then continue unload,
> -	 * where it was set first.
> -	 */
> -	if (test_bit(UNLOADING, &base_vha->dpc_flags))
> -		return;
> -
> -	set_bit(UNLOADING, &base_vha->dpc_flags);
> -
>  	qla_nvme_delete(base_vha);
>  
>  	dma_free_coherent(&ha->pdev->dev,
> @@ -6628,13 +6626,6 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
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
> @@ -6645,9 +6636,14 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
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

Reviewed-by: Arun Easi <aeasi@marvell.com>
