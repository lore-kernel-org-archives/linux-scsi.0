From: subhashj@codeaurora.org
Subject: Re: [PATCH v7 2/8] scsi: ufs-qcom: fix compilation warning if
 compiled as a module
Date: Thu, 22 Oct 2015 06:53:11 -0000
Message-ID: <c770aa163c4118f4bd4a2cad24b0d3c5.squirrel@codeaurora.org>
References: <1441205138-12664-1-git-send-email-ygardi@codeaurora.org>
    <1441205138-12664-3-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441205138-12664-3-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>


> This change fixes a compilation warning that happens if SCSI_UFS_QCOM
> is compiled as a module.
> Also this patch fixes an error happens when insmod the module:
> "ufs_qcom: module license 'unspecified' taints kernel."
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 4cdffa4..6c23bbf 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -917,12 +917,15 @@ out:
>
>  #define	ANDROID_BOOT_DEV_MAX	30
>  static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
> -static int get_android_boot_dev(char *str)
> +
> +#ifndef MODULE
> +static int __init get_android_boot_dev(char *str)
>  {
>  	strlcpy(android_boot_dev, str, ANDROID_BOOT_DEV_MAX);
>  	return 1;
>  }
>  __setup("androidboot.bootdevice=", get_android_boot_dev);
> +#endif
>
>  /**
>   * ufs_qcom_init - bind phy with controller
> @@ -1047,3 +1050,5 @@ static const struct ufs_hba_variant_ops
> ufs_hba_qcom_vops = {
>  	.resume			= ufs_qcom_resume,
>  };
>  EXPORT_SYMBOL(ufs_hba_qcom_vops);
> +
> +MODULE_LICENSE("GPL v2");
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
>
