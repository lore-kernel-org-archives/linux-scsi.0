From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid_sas: fix missing { }, nullify kbuff_arr[i] only
 when necessary
Date: Tue, 22 Mar 2016 17:12:21 +0530
Message-ID: <a89c886c57f99c3141e69bc3f1f1ea9b@mail.gmail.com>
References: <1458493412-17103-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:33885 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758758AbcCVLmY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2016 07:42:24 -0400
Received: by mail-lb0-f175.google.com with SMTP id k12so157338079lbb.1
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2016 04:42:23 -0700 (PDT)
In-Reply-To: <1458493412-17103-1-git-send-email-colin.king@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, James Bottomley <jbottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Colin King [mailto:colin.king@canonical.com]
> Sent: Sunday, March 20, 2016 10:34 PM
> To: Kashyap Desai; Sumit Saxena; James Bottomley; Martin K . Petersen;
> megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Subject: [PATCH] megaraid_sas: fix missing { }, nullify kbuff_arr[i]
only when
> necessary
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Fix missing { } on if statement, this change will nullify kbuff_arr[i]
only where
> necessary as the code intended.
>
> detected using static analysis with smatch
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 69d375b..e6ebc7a 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -6656,12 +6656,13 @@ out:
>  	}
>
>  	for (i = 0; i < ioc->sge_count; i++) {
> -		if (kbuff_arr[i])
> +		if (kbuff_arr[i]) {
>  			dma_free_coherent(&instance->pdev->dev,
>
le32_to_cpu(kern_sge32[i].length),
>  					  kbuff_arr[i],
>
> le32_to_cpu(kern_sge32[i].phys_addr));
>  			kbuff_arr[i] = NULL;
> +		}
>  	}
>
>  	megasas_return_cmd(instance, cmd);

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> --
> 2.7.3
