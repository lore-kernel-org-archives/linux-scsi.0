Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 610DFC10DCE
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 00:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3427820663
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 00:36:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Vu6opKF5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgCYAgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 20:36:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58232 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727099AbgCYAgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Mar 2020 20:36:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02P0U3cj011041;
        Tue, 24 Mar 2020 17:36:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=date : from : to :
 cc : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=pfpt0818; bh=tSXZQ7d20mD/11aDdrZwZo0oJizAzMinKfwlMhFtC9o=;
 b=Vu6opKF5vr0F90yGZC3I6rUCtOACrPC+oxxLEjhI8LOzCOxx8Q3S8qYS2b4CdzLDwCPv
 wXRJlvRnyBu4u3tHdSPZwMLgxkxuT6GKw8qA28qXTnrq9K38U3/k0vslGJImSKjEvUOe
 DSRhDc4vEgi+mMSy0NOBPfu/ZRlAcMM8Yho0EJFBkw/Y1VLoBC+k8kpvzWwNeAXCHKXD
 thAWS5Lv8xJq7exsyInHUnZlgbhRHv64qOEh6jyx2AluM0B4m6F3x8+oQVph3Bhwv2rg
 rYA7ztAdz49tYUgW6TU7fjADP7X7XnbTBXxQ2jx8yiP2zen0nb9CS/ouZSZ5VENGYJ+C cw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9np39m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 24 Mar 2020 17:36:44 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 24 Mar
 2020 17:36:43 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 24 Mar 2020 17:36:43 -0700
Received: from irv1user01.caveonetworks.com (unknown [10.104.116.179])
        by maili.marvell.com (Postfix) with ESMTP id 151E33F7040;
        Tue, 24 Mar 2020 17:36:43 -0700 (PDT)
Received: from localhost (aeasi@localhost)
        by irv1user01.caveonetworks.com (8.14.4/8.14.4/Submit) with ESMTP id 02P0agZJ011243;
        Tue, 24 Mar 2020 17:36:42 -0700
X-Authentication-Warning: irv1user01.caveonetworks.com: aeasi owned process doing -bs
Date:   Tue, 24 Mar 2020 17:36:42 -0700
From:   Arun Easi <aeasi@marvell.com>
X-X-Sender: aeasi@irv1user01.caveonetworks.com
To:     Martin Wilck <mwilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "Hannes Reinecke" <hare@suse.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        "Daniel Wagner" <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] scsi: qla2xxx: don't shut down firmware before
 closing sessions
In-Reply-To: <20200205214422.3657-3-mwilck@suse.com>
Message-ID: <alpine.LRH.2.21.9999.2003241732470.12727@irv1user01.caveonetworks.com>
References: <20200205214422.3657-1-mwilck@suse.com>
 <20200205214422.3657-3-mwilck@suse.com>
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
> Since 45235022da99, the firmware is shut down early in the controller
> shutdown process. This causes commands sent to the firmware (such as LOGO)
> to hang forever. Eventually one or more timeouts will be triggered.
> Move the stopping of the firmware until after sessions have terminated.
> 
> Fixes: 45235022da99 ("scsi: qla2xxx: Fix driver unload by shutting down chip")
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 2dafb46..e81080d 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3720,6 +3720,16 @@ qla2x00_remove_one(struct pci_dev *pdev)
>  	}
>  	qla2x00_wait_for_hba_ready(base_vha);
>  
> +	qla2x00_wait_for_sess_deletion(base_vha);
> +
> +	/*
> +	 * if UNLOAD flag is already set, then continue unload,
> +	 * where it was set first.
> +	 */
> +	if (test_bit(UNLOADING, &base_vha->dpc_flags))
> +		return;
> +
> +	set_bit(UNLOADING, &base_vha->dpc_flags);
>  	if (IS_QLA25XX(ha) || IS_QLA2031(ha) || IS_QLA27XX(ha) ||
>  	    IS_QLA28XX(ha)) {
>  		if (ha->flags.fw_started)
> @@ -3736,17 +3746,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
>  		qla2x00_try_to_stop_firmware(base_vha);
>  	}
>  
> -	qla2x00_wait_for_sess_deletion(base_vha);
> -
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
> 

NAK.

The fcport deletion was done after chip reset to minimize interference and 
further action on fcports. We should not be sending out logouts during 
unload (driver just implicitly logs out). If you experience any hangs, 
please let us know.

Regards,
-Arun
