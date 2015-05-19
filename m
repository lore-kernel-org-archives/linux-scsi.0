From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v1 07/10] scsi: ufs: introduce UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE
 quirk
Date: Tue, 19 May 2015 23:33:47 +0900
Message-ID: <CAC5umyjaWpbMxnnaofUOJ3=GSZt1bTP0-cGbEdr_K04MAJy0Nw@mail.gmail.com>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
	<1431878106-30579-8-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-8-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, dovl@codeaurora.org, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-05-18 0:55 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> Some UFS host controllers may only allow accessing the peer DME attribute
> in AUTO mode (FAST AUTO or SLOW AUTO) hence we had added a quirk for
> switching to AUTO power mode before accessing the peer DME attribute.
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 31 +++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.h |  7 +++++++
>  2 files changed, 38 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index a274df9..014f1c0 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -188,6 +188,8 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
>  static irqreturn_t ufshcd_intr(int irq, void *__hba);
>  static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
>                 struct ufs_pa_layer_attr *desired_pwr_mode);
> +static int ufshcd_change_power_mode(struct ufs_hba *hba,
> +                            struct ufs_pa_layer_attr *pwr_mode);
>
>  static inline int ufshcd_enable_irq(struct ufs_hba *hba)
>  {
> @@ -2156,6 +2158,31 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>         };
>         const char *get = action[!!peer];
>         int ret;
> +       struct ufs_pa_layer_attr orig_pwr_info;
> +       struct ufs_pa_layer_attr temp_pwr_info;
> +       bool pwr_mode_change = false;
> +
> +       if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)) {
> +               orig_pwr_info = hba->pwr_info;
> +               temp_pwr_info = orig_pwr_info;
> +
> +               if (orig_pwr_info.pwr_tx == FAST_MODE ||
> +                   orig_pwr_info.pwr_rx == FAST_MODE) {
> +                       temp_pwr_info.pwr_tx = FASTAUTO_MODE;
> +                       temp_pwr_info.pwr_rx = FASTAUTO_MODE;
> +                       pwr_mode_change = true;
> +               } else if (orig_pwr_info.pwr_tx == SLOW_MODE ||
> +                   orig_pwr_info.pwr_rx == SLOW_MODE) {
> +                       temp_pwr_info.pwr_tx = SLOWAUTO_MODE;
> +                       temp_pwr_info.pwr_rx = SLOWAUTO_MODE;
> +                       pwr_mode_change = true;
> +               }

What happens if tx and rx have different power mode (although it is
strange setting) ?

For example, if the current power mode is pwr_tx=FAST_MODE, gear_tx=3
and pwr_rx=SLOW_MODE, gear_rx=4, the temporary power mode will be
pwr_tx=FASTAUTO_MODE, gear_tx=3 and pwr_rx=FASTAUTO_MODE, gear_rx=4.
But HS-G4 is invalid.

> +               if (pwr_mode_change) {
> +                       ret = ufshcd_change_power_mode(hba, &temp_pwr_info);
> +                       if (ret)
> +                               goto out;
> +               }
> +       }
