From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 1/5] scsi: ufs: move the ufshcd_hba_stop to ufshcd.c
Date: Tue, 30 Apr 2013 16:47:31 +0530
Message-ID: <517FA84B.2070009@codeaurora.org>
References: <1366812872-26331-1-git-send-email-sthumma@codeaurora.org> <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16917 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760241Ab3D3LRh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Apr 2013 07:17:37 -0400
In-Reply-To: <001e01ce4105$ab4e2430$01ea6c90$%jun@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>


Looks good. Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

On 4/24/2013 9:36 PM, Seungwon Jeon wrote:
> Move the ufshcd_hba_stop from header file.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |    9 +++++++++
>  drivers/scsi/ufs/ufshcd.h |    9 ---------
>  2 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 60fd40c..41b9639 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -285,6 +285,15 @@ static inline void ufshcd_hba_start(struct ufs_hba *hba)
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
> index 6b99a42..1680394 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -190,13 +190,4 @@ int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
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

