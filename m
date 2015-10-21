From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 16/17] scsi: ufs: add delay before putting UFS rails in
 low power modes
Date: Thu, 22 Oct 2015 01:11:39 +0900
Message-ID: <CAC5umyj+gQYuLR1v73Dq78vx0NEreMDkmWe0Tk9UBuv8uc5AQw@mail.gmail.com>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
	<1442155977-7686-17-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442155977-7686-17-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-09-13 23:52 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> We put the UFS device in sleep state & UFS link in hibern8 state during
> runtime suspaned. After this we put all the UFS rails in low power
> modes immediately but it seems some devices may still draw more than
> sleep current from UFS rails (especially from VCCQ rail) atleast for
> 500us.
> To avoid this situation, this change adds 2ms delay before putting
> these UFS rails in LPM mode.
>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 20b4c0e..786df28 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5694,6 +5694,15 @@ out:
>  static void ufshcd_vreg_set_lpm(struct ufs_hba *hba)
>  {
>         /*
> +        * It seems some UFS devices may keep drawing more than sleep current
> +        * (atleast for 500us) from UFS rails (especially from VCCQ rail).
> +        * To avoid this situation, add 2ms delay before putting these UFS
> +        * rails in LPM mode.
> +        */
> +       if (!ufshcd_is_link_active(hba))
> +               usleep_range(2000, 2100);
> +

Shouldn't we define dev_quirks for this?

> +       /*
>          * If UFS device is either in UFS_Sleep turn off VCC rail to save some
>          * power.
>          *
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
