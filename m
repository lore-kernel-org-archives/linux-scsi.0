From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v5 11/11] scsi: ufs-exynos: add UFS host support for Exynos SoCs
Date: Tue, 17 Nov 2015 09:50:17 +0100
Message-ID: <6882472.V6ODslsXkd@wuerfel>
References: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com> <1447046787-480-12-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447046787-480-12-git-send-email-alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBottomley-wo1vFcy6AUs@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, gautam.vivek-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kishon-l0cyMroinI0@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Monday 09 November 2015 10:56:27 Alim Akhtar wrote:
> From: Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> This patch introduces Exynos UFS host controller driver,
> which mainly handles vendor-specific operations including
> link startup, power mode change and hibernation/unhibernation.
> 
> Signed-off-by: Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

I had looked at earlier versions of this and the new version looks
much better. Just a few things I noticed:

>  drivers/scsi/ufs/Kconfig         |   12 +
>  drivers/scsi/ufs/Makefile        |    1 +
>  drivers/scsi/ufs/ufs-exynos-hw.c |  131 ++++
>  drivers/scsi/ufs/ufs-exynos-hw.h |   43 ++
>  drivers/scsi/ufs/ufs-exynos.c    | 1304 ++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-exynos.h    |  247 ++++++++
>  drivers/scsi/ufs/ufshci.h        |   26 +-
>  drivers/scsi/ufs/unipro.h        |   47 ++

It looks like an arbitrary split to separate out ufs-exynos-hw.{c,h} from
ufs-exynos.{c,h}, it would become simpler if you just put the four files
into one.

> 
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 5f4530744e0a..bc602be94458 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -83,3 +83,15 @@ config SCSI_UFS_QCOM
>  
>  	  Select this if you have UFS controller on QCOM chipset.
>  	  If unsure, say N.
> +
> +config SCSI_UFS_EXYNOS
> +	bool "EXYNOS specific hooks to UFS controller platform driver"
> +	depends on SCSI_UFSHCD_PLATFORM && ARCH_EXYNOS || COMPILE_TEST

Maybe use

	depends on SCSI_UFSHCD_PLATFORM && (ARCH_EXYNOS || COMPILE_TEST)

for clarity? nobody can remember the order in which this gets evaluated. ;-)

> +	select PHY_EXYNOS_UFS
> +	help
> +	  This selects the EXYNOS specific additions to UFSHCD platform driver.
> +	  UFS host on EXYNOS includes HCI and UNIPRO layer, and associates with
> +	  UFS-PHY driver.

Is it allowed to select PHY_EXYNOS_UFS without having a dependency on other
symbols?

> +static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
> +{
> +	struct ufs_hba *hba = ufs->hba;
> +	u32 val = ufs->drv_data->uic_attr->pa_dbg_option_suite;
> +	int i;
> +
> +	exynos_ufs_enable_ov_tm(hba);
> +	for_each_ufs_tx_lane(ufs, i)
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x297, i), 0x17);
> +	for_each_ufs_rx_lane(ufs, i) {
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x362, i), 0xff);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x363, i), 0x00);
> +	}
> +	exynos_ufs_disable_ov_tm(hba);
> +
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE_DYN), 0xf);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE_DYN), 0xf);
> +	for_each_ufs_tx_lane(ufs, i)
> +		ufshcd_dme_set(hba,
> +			UIC_ARG_MIB_SEL(TX_HIBERN8_CONTROL, i), 0x0);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_TXPHY_CFGUPDT), 0x1);
> +	udelay(1);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE), val | (1 << 12));
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_SKIP_RESET_PHY), 0x1);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_SKIP_LINE_RESET), 0x1);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_LINE_RESET_REQ), 0x1);
> +	udelay(1600);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE), val);

1.6 ms is a long time to block the CPU for. Are you allowed to call
msleep() or uleep_range() in this function instead?

> +struct exynos_ufs_drv_data exynos_ufs_drvs[] = {
> +{
> +	.compatible		= "samsung,exynos7-ufs",
> +	.uic_attr		= &exynos7_uic_attr,
> +	.quirks			= UFSHCI_QUIRK_BYTE_ALIGN_UTRD |
> +				  UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR |
> +				  UFSHCI_QUIRK_BROKEN_HCE |
> +				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR,
> +	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
> +				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
> +				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
> +	.drv_init		= exynos7_ufs_drv_init,
> +	.pre_link		= exynos7_ufs_pre_link,
> +	.post_link		= exynos7_ufs_post_link,
> +	.pre_pwr_change		= exynos7_ufs_pre_pwr_change,
> +	.post_pwr_change	= exynos7_ufs_post_pwr_change,
> +}, {
> +}, };

An array like this is probably not the ideal way to express it,
in particular when there is only one entry. More on that below.

> +static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
> +{
> +	struct device_node *np = dev->of_node;
> +	struct exynos_ufs_drv_data *drv_data = exynos_ufs_drvs;
> +	struct exynos_ufs_uic_attr *attr;
> +	u32 freq[2];
> +	int ret;
> +
> +	while (drv_data->compatible) {
> +		if (of_device_is_compatible(np, drv_data->compatible)) {
> +			ufs->drv_data = drv_data;
> +			break;
> +		}
> +		drv_data++;
> +	}

Here you loop over the array, but you actually match the compatible list
already in the platform driver subsystem.

> +static const struct of_device_id exynos_ufs_of_match[] = {
> +	{ .compatible = "samsung,exynos7-ufs"},
> +	{},
> +};

So just put a pointer to the right data into the .data member of of_device_id.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
