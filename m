From: amit daniel kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH 08/10] scsi: ufs: make ufshcd_config_pwr_mode of
 non-static func
Date: Wed, 26 Aug 2015 11:53:15 +0530
Message-ID: <CADGdYn7CVbscTR8WF=rZberQp7GF8H4k0YDx8XOnQwKHnMe8gA@mail.gmail.com>
References: <1440149281-26336-1-git-send-email-alim.akhtar@samsung.com>
	<1440149281-26336-9-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440149281-26336-9-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, vinholikatti@gmail.com, JBottomley@odin.com, Seungwon Jeon <tgih.jun@samsung.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 21, 2015 at 2:57 PM, Alim Akhtar <alim.akhtar@samsung.com> wrote:
> From: Seungwon Jeon <tgih.jun@samsung.com>
>
> It can be used in the vendor's driver for the specific purpose.
more description of this log will be useful.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |    5 ++---
>  drivers/scsi/ufs/ufshcd.h |    2 ++
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index d425ea1..8982da9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -185,8 +185,6 @@ static int ufshcd_uic_hibern8_ctrl(struct ufs_hba *hba, bool en);
>  static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
>  static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
>  static irqreturn_t ufshcd_intr(int irq, void *__hba);
> -static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
> -               struct ufs_pa_layer_attr *desired_pwr_mode);
>  static int ufshcd_change_power_mode(struct ufs_hba *hba,
>                              struct ufs_pa_layer_attr *pwr_mode);
>
> @@ -2597,7 +2595,7 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
>   * @hba: per-adapter instance
>   * @desired_pwr_mode: desired power configuration
>   */
> -static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
> +int ufshcd_config_pwr_mode(struct ufs_hba *hba,
>                 struct ufs_pa_layer_attr *desired_pwr_mode)
>  {
>         struct ufs_pa_layer_attr final_params = { 0 };
> @@ -2613,6 +2611,7 @@ static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
>
>         return ret;
>  }
> +EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
>
>  /**
>   * ufshcd_complete_dev_init() - checks device readiness
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 045968e..13368e1 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -636,6 +636,8 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
>                                u8 attr_set, u32 mib_val, u8 peer);
>  extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
>                                u32 *mib_val, u8 peer);
> +extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
> +                       struct ufs_pa_layer_attr *desired_pwr_mode);
>
>  /* UIC command interfaces for DME primitives */
>  #define DME_LOCAL      0
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
