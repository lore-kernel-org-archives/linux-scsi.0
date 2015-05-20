From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v1 2/3] scsi: ufs-qcom: fix compilation warning if
 compiled as a module
Date: Wed, 20 May 2015 10:29:52 +0200
Message-ID: <1432110592.21715.50.camel@x220>
References: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
	 <1432043231-31102-3-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1432043231-31102-3-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, kishon@ti.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, dovl@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-05-19 at 16:47 +0300, Yaniv Gardi wrote:
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -885,7 +885,7 @@ out:
>  
>  #define	ANDROID_BOOT_DEV_MAX	30
>  static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
> -static int get_android_boot_dev(char *str)
> +static int __maybe_unused get_android_boot_dev(char *str)
>  {
>  	strlcpy(android_boot_dev, str, ANDROID_BOOT_DEV_MAX);
>  	return 1;

Wouldn't it be clearer to wrap these few lines (until after the
__setup() macro) with #ifndef MODULE?

And I think get_android_boot_dev() could be marked __init. Because if
it's built-in it will never be called after the kernel has finished
booting, right?


Paul Bolle
