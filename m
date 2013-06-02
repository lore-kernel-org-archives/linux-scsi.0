From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH] [SCSI] ufs: fix register address in UIC error interrupt handling
Date: Sun, 2 Jun 2013 12:01:53 +0530
Message-ID: <CALMYJDtn=vaD290Oxkej3n=nW0FUu_k5+CyHF32raJcMj9x-sA@mail.gmail.com>
References: <1370145860-16336-1-git-send-email-mita@fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:64483 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3FBGcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jun 2013 02:32:15 -0400
Received: by mail-bk0-f49.google.com with SMTP id 6so1356442bkj.36
        for <linux-scsi@vger.kernel.org>; Sat, 01 Jun 2013 23:32:14 -0700 (PDT)
In-Reply-To: <1370145860-16336-1-git-send-email-mita@fixstars.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <mita@fixstars.com>
Cc: linux-scsi@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

On Sun, Jun 2, 2013 at 9:34 AM, Akinobu Mita <mita@fixstars.com> wrote:
> In UIC error interrupt handling, it checks if UIC data link layer error
> code indicates PA_INIT_ERROR in order to determine whether a fatal error
> handling is needed or not.
>
> But the code tries to read UIC data link layer error code from wrong
> REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER, it should be
> REG_UIC_ERROR_CODE_DATA_LINK_LAYER.
>
> Signed-off-by: Akinobu Mita <mita@fixstars.com>
> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: Santosh Y <santoshsy@gmail.com>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index c32a478..492f2b7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1246,7 +1246,7 @@ static void ufshcd_err_handler(struct ufs_hba *hba)
>         if (hba->errors & UIC_ERROR) {
>
>                 reg = readl(hba->mmio_base +
> -                           REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER);
> +                           REG_UIC_ERROR_CODE_DATA_LINK_LAYER);
>                 if (reg & UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
>                         goto fatal_eh;
>         }
> --
> 1.8.1.4
>

Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh
