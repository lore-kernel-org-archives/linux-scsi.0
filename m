From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/1] scsi: ufs-qcom: Add support for platforms booting ACPI
Date: Tue, 18 Jun 2019 18:46:29 +0200
Message-ID: <CAKv+Gu_qd9KrXHVSVHCoM42D8ACjU5onzFGJPTTBGOsVJpeayg@mail.gmail.com>
References: <20190617115454.3226-1-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617115454.3226-1-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Jones <lee.jones@linaro.org>
Cc: agross@kernel.org, David Brown <david.brown@linaro.org>, alim.akhtar@samsung.com, avri.altman@wdc.com, pedrom.sousa@synopsys.com, jejb@linux.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jlhugo@gmail.com>, Bjorn Andersson <bjorn.andersson@linaro.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 17 Jun 2019 at 13:55, Lee Jones <lee.jones@linaro.org> wrote:
>
> New Qualcomm AArch64 based laptops are now available which use UFS
> as their primary data storage medium.  These devices are supplied
> with ACPI support out of the box.  This patch ensures the Qualcomm
> UFS driver will be bound when the "QCOM24A5" H/W device is
> advertised as present.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/scsi/ufs/ufs-qcom.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 3aeadb14aae1..364af6a63e35 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -12,6 +12,7 @@
>   *
>   */
>
> +#include <linux/acpi.h>
>  #include <linux/time.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> @@ -164,6 +165,9 @@ static int ufs_qcom_init_lane_clks(struct ufs_qcom_host *host)
>         int err = 0;
>         struct device *dev = host->hba->dev;
>
> +       if (has_acpi_companion(dev))
> +               return 0;
> +
>         err = ufs_qcom_host_clk_get(dev, "rx_lane0_sync_clk",
>                                         &host->rx_l0_sync_clk, false);
>         if (err)
> @@ -1208,9 +1212,13 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>                         __func__, err);
>                 goto out_variant_clear;
>         } else if (IS_ERR(host->generic_phy)) {
> -               err = PTR_ERR(host->generic_phy);
> -               dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
> -               goto out_variant_clear;
> +               if (has_acpi_companion(dev)) {
> +                       host->generic_phy = NULL;
> +               } else {
> +                       err = PTR_ERR(host->generic_phy);
> +                       dev_err(dev, "%s: PHY get failed %d\n", __func__, err);
> +                       goto out_variant_clear;
> +               }
>         }
>
>         err = ufs_qcom_bus_register(host);
> @@ -1680,6 +1688,14 @@ static const struct of_device_id ufs_qcom_of_match[] = {
>  };
>  MODULE_DEVICE_TABLE(of, ufs_qcom_of_match);
>
> +#ifdef CONFIG_ACPI
> +static const struct acpi_device_id ufs_qcom_acpi_match[] = {
> +       { "QCOM24A5" },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(acpi, ufs_qcom_acpi_match);
> +#endif
> +
>  static const struct dev_pm_ops ufs_qcom_pm_ops = {
>         .suspend        = ufshcd_pltfrm_suspend,
>         .resume         = ufshcd_pltfrm_resume,
> @@ -1696,6 +1712,7 @@ static struct platform_driver ufs_qcom_pltform = {
>                 .name   = "ufshcd-qcom",
>                 .pm     = &ufs_qcom_pm_ops,
>                 .of_match_table = of_match_ptr(ufs_qcom_of_match),
> +               .acpi_match_table = ACPI_PTR(ufs_qcom_acpi_match),
>         },
>  };
>  module_platform_driver(ufs_qcom_pltform);
> --
> 2.17.1
>
