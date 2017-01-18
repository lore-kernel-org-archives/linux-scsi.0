From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH -next] scsi: be2iscsi: Use GFP_ATOMIC under spin lock
Date: Wed, 18 Jan 2017 10:36:25 +0530
Message-ID: <5d5887c7afd4a02f2af25f293b1d95a8@mail.gmail.com>
References: <20170112142132.14552-1-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:36296 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdARFG0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2017 00:06:26 -0500
Received: by mail-ua0-f175.google.com with SMTP id 96so1716879uaq.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2017 21:06:25 -0800 (PST)
In-Reply-To: <20170112142132.14552-1-weiyj.lk@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>, Subramanian Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> Sent: Thursday, January 12, 2017 7:52 PM
> To: Subbu Seetharaman; Ketan Mukadam; Jitendra Bhivare; James E.J.
> Bottomley; Martin K. Petersen
> Cc: Wei Yongjun; linux-scsi@vger.kernel.org
> Subject: [PATCH -next] scsi: be2iscsi: Use GFP_ATOMIC under spin lock
>
> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> A spin lock is taken here so we should use GFP_ATOMIC.
>
> Fixes: 987132167f4b ("scsi: be2iscsi: Fix for crash in
beiscsi_eh_device_reset")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c
b/drivers/scsi/be2iscsi/be_main.c
> index 6372613..c9b9daa 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -294,7 +294,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd
> *sc)
>  	beiscsi_conn = conn->dd_data;
>  	phba = beiscsi_conn->phba;
>
> -	inv_tbl = kzalloc(sizeof(*inv_tbl), GFP_KERNEL);
> +	inv_tbl = kzalloc(sizeof(*inv_tbl), GFP_ATOMIC);
>  	if (!inv_tbl) {
>  		spin_unlock_bh(&session->frwd_lock);
>  		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_EH,

Reviewed-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
