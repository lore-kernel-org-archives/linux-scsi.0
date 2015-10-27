From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v5 09/15] scsi: ufs: add retries for hibern8 enter
Date: Tue, 27 Oct 2015 14:59:03 -0000
Message-ID: <cda88f83b6088de3fbc96de4f2f8a0df.squirrel@www.codeaurora.org>
References: <1445942657-6293-1-git-send-email-ygardi@codeaurora.org>
    <1445942657-6293-10-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445942657-6293-10-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: robherring2@gmail.com, james.bottomley@hansenpartnership.com, pebolle@tiscali.nl, hch@infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>

> If hibern8 enter command fails then UFS link state may be unknown which
> may result into timeout of all the commands issued after failure.
>
> This change does 2 things (for pre-defined number of retry counts) after
> hibern8 enter failure:
> 1. Recovers the UFS link to active state
> 2. If link is recovered to active state, tries to put the UFS link in
>    hibern8 enter again until retry count expires.
>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 5005d12..ed134d6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -76,6 +76,9 @@
>  /* maximum number of link-startup retries */
>  #define DME_LINKSTARTUP_RETRIES 3
>
> +/* Maximum retries for Hibern8 enter */
> +#define UIC_HIBERN8_ENTER_RETRIES 3
> +
>  /* maximum number of reset retries before giving up */
>  #define MAX_HOST_RESET_RETRIES 5
>
> @@ -2390,13 +2393,32 @@ out:
>  	return ret;
>  }
>
> -static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
> +static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
>  {
> +	int ret;
>  	struct uic_command uic_cmd = {0};
>
>  	uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
> +	ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
> +
> +	if (ret)
> +		dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d\n",
> +			__func__, ret);
> +
> +	return ret;
> +}
> +
> +static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
> +{
> +	int ret = 0, retries;
>
> -	return ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
> +	for (retries = UIC_HIBERN8_ENTER_RETRIES; retries > 0; retries--) {
> +		ret = __ufshcd_uic_hibern8_enter(hba);
> +		if (!ret || ret == -ENOLINK)
> +			goto out;
> +	}
> +out:
> +	return ret;
>  }
>
>  static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
