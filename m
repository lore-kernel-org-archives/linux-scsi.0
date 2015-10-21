From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3 09/15] scsi: ufs: add retries for hibern8 enter
Date: Wed, 21 Oct 2015 23:54:18 +0900
Message-ID: <CAC5umygAA0Q-8pCFi2GbC8Tn5XxMPSGauSsV-FJQihXAi+xbTA@mail.gmail.com>
References: <1441188795-4600-1-git-send-email-ygardi@codeaurora.org>
	<1441188795-4600-10-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1441188795-4600-10-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-09-02 19:13 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
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
> index 8d5bdf0..5800b08 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -75,6 +75,9 @@
>  /* maximum number of link-startup retries */
>  #define DME_LINKSTARTUP_RETRIES 3
>
> +/* Maximum retries for Hibern8 enter */
> +#define UIC_HIBERN8_ENTER_RETRIES 3
> +
>  /* maximum number of reset retries before giving up */
>  #define MAX_HOST_RESET_RETRIES 5
>
> @@ -2389,13 +2392,32 @@ out:
>         return ret;
>  }
>
> -static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
> +static int __ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
>  {
> +       int ret;
>         struct uic_command uic_cmd = {0};
>
>         uic_cmd.command = UIC_CMD_DME_HIBER_ENTER;
> +       ret = ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
> +
> +       if (ret)
> +               dev_err(hba->dev, "%s: hibern8 enter failed. ret = %d",
> +                       __func__, ret);

This format string is not terminated with '\n'.
(I found several same issues in ufshcd.c)

> +
> +       return ret;
> +}
> +
> +static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba)
> +{
> +       int ret = 0, retries;
>

'ret' will soon be initialized in the loop anyway, so it is unnecessary
to initialized here.

> -       return ufshcd_uic_pwr_ctrl(hba, &uic_cmd);
> +       for (retries = UIC_HIBERN8_ENTER_RETRIES; retries > 0; retries--) {
> +               ret = __ufshcd_uic_hibern8_enter(hba);
> +               if (!ret || ret == -ENOLINK)
> +                       goto out;
> +       }
> +out:
> +       return ret;
>  }
>
>  static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
