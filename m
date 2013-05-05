From: merez@codeaurora.org
Subject: Re: [PATCH v2 1/7] scsi: ufs: move the ufshcd_hba_stop to ufshcd.c
Date: Sun, 5 May 2013 04:22:53 -0700
Message-ID: <3081f2d4913dc74ded32bff2b8a68cd4.squirrel@www.codeaurora.org>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org>
    <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
    <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40879 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab3EELWx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 May 2013 07:22:53 -0400
In-Reply-To: <000b01ce48a3$ad7072e0$085158a0$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <jbottomley@parallels.com>

Hi,

ufshcd_pci_shutdown (in ufshcd_pci.c) is using ufshcd_hba_stop so it
cannot be moved to ufshcd.c.
Sorry for missing it last time I tested, I returned ufshcd_hba_stop to
ufshcd.h by mistake when I resolved conflicts of the next patch so I
didn't hit the compilation errors.

Thanks,
Maya
> Move the ufshcd_hba_stop from header file.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
> Tested-by: Maya Erez <merez@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c |    9 +++++++++
>  drivers/scsi/ufs/ufshcd.h |    9 ---------
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index f244812..d932239 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -280,6 +280,15 @@ static inline void ufshcd_hba_start(struct ufs_hba
> *hba)
>  }
>
>  /**
> + * ufshcd_hba_stop - Send controller to reset state
> + * @hba: per adapter instance
> + */
> +static inline void ufshcd_hba_stop(struct ufs_hba *hba)
> +{
> +	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
> +}
> +
> +/**
>   * ufshcd_is_hba_active - Get controller state
>   * @hba: per adapter instance
>   *
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 336980b..3a1052d 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -208,13 +208,4 @@ int ufshcd_init(struct device *, struct ufs_hba ** ,
> void __iomem * ,
>  			unsigned int);
>  void ufshcd_remove(struct ufs_hba *);
>
> -/**
> - * ufshcd_hba_stop - Send controller to reset state
> - * @hba: per adapter instance
> - */
> -static inline void ufshcd_hba_stop(struct ufs_hba *hba)
> -{
> -	writel(CONTROLLER_DISABLE, (hba->mmio_base + REG_CONTROLLER_ENABLE));
> -}
> -
>  #endif /* End of Header */
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

