From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 08/17] scsi: ufs: split broken LCC quirk
Date: Thu, 22 Oct 2015 01:00:55 +0900
Message-ID: <CAC5umyjDpDZz77fOrxmudXiPsPEsN1pxvTL-r_9hAE3h3jaAGw@mail.gmail.com>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
	<1442155977-7686-9-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442155977-7686-9-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-09-13 23:52 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> Currently when UFSHCD_BROKEN_LCC quirk is defined, LCC is getting
> disabled on both host and device side but there could be a need
> where we don't want to disable the LCC on both side hence this change
> splits the quirk in 2 parts one for host and one for device.
>
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 0803a89..411ec17 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3048,6 +3048,11 @@ static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
>         return err;
>  }
>
> +static inline int ufshcd_disable_host_tx_lcc(struct ufs_hba *hba)
> +{
> +       return ufshcd_disable_tx_lcc(hba, false);
> +}
> +
>  static inline int ufshcd_disable_device_tx_lcc(struct ufs_hba *hba)
>  {
>         return ufshcd_disable_tx_lcc(hba, true);
> @@ -3095,6 +3100,12 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
>                         goto out;
>         }
>
> +       if (hba->dev_quirks & UFS_DEVICE_QUIRK_BROKEN_LCC) {
> +               ret = ufshcd_disable_host_tx_lcc(hba);
> +               if (ret)
> +                       goto out;
> +       }
> +

This dev_quirks is checked just after link startup.  But dev_quirk is
determined after ufshcd_complete_dev_init().  Is this quirk correctly
be applied?

>         /* Include any host controller configuration via UIC commands */
>         ret = ufshcd_vops_link_startup_notify(hba, POST_CHANGE);
>         if (ret)
> --
> 1.8.5.2
>
> --
> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
