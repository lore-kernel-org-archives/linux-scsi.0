From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] scsi: ufs: add Exynos-specific driver
Date: Tue, 28 Nov 2017 06:24:39 -0800
Message-ID: <20171128142439.GA5765@infradead.org>
References: <CGME20171128053631epcas1p389908b55511552b79b4083109dddc515@epcas1p3.samsung.com>
 <002a01d3680a$d8817200$89845600$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49011 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750829AbdK1OYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Nov 2017 09:24:40 -0500
Content-Disposition: inline
In-Reply-To: <002a01d3680a$d8817200$89845600$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?utf-8?B?6rmA6riw7JuF?= <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>, =?utf-8?B?6rmA67aA7KeE?= <boojin.kim@samsung.com>, YOUNGEUN PARK <youngeun.park@samsung.com>

On Tue, Nov 28, 2017 at 02:36:31PM +0900, 김기웅 wrote:
> This driver is to use UFS devices on Exynos SoC and
> has been already used for many years for commercial products.

So why do you only submit it only now?

> +/* Helper for UFS CAL interface */
> +static inline int ufs_init_cal(struct exynos_ufs *ufs, int idx,
> +					struct platform_device *pdev)
> +{
> +	return 0;
> +}
> +
> +static inline int ufs_pre_link(struct exynos_ufs *ufs)
> +{
> +	return 0;
> +}
> +
> +static inline int ufs_post_link(struct exynos_ufs *ufs)
> +{
> +	return 0;
> +}
> +
> +static inline int ufs_pre_gear_change(struct exynos_ufs *ufs,
> +				struct uic_pwr_mode *pmd)
> +{
> +	return 0;
> +}
> +
> +static inline int ufs_post_gear_change(struct exynos_ufs *ufs)
> +{
> +	return 0;
> +}
> +
> +static inline int ufs_post_h8_enter(struct exynos_ufs *ufs)
> +{
> +	return 0;
> +}
> +
> +static inline int ufs_pre_h8_exit(struct exynos_ufs *ufs)
> +{
> +	return 0;
> +}

These are all dummys, please rmeove them.

> +#ifndef __EXYNOS_UFS_VS_DEBUG__

Please don't have ifdef code that isn't Kconfig selectable.

> +#ifndef __EXYNOS_UFS_MMIO_FUNC__
> +#define __EXYNOS_UFS_MMIO_FUNC__
> +#define EXYNOS_UFS_MMIO_FUNC(name)						\
> +static inline void name##_writel(struct exynos_ufs *ufs, u32 val, u32 reg)	\
> +{										\
> +	writel(val, ufs->reg_##name + reg);					\
> +}										\
> +										\
> +static inline u32 name##_readl(struct exynos_ufs *ufs, u32 reg)			\
> +{										\
> +	return readl(ufs->reg_##name + reg);					\
> +}
> +
> +EXYNOS_UFS_MMIO_FUNC(hci);
> +EXYNOS_UFS_MMIO_FUNC(unipro);

Please remove this macro magic.

> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 1332e544da92..1afd5ac9707c 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -308,6 +308,7 @@ struct ufs_hba_variant_ops {
>  	int	(*setup_clocks)(struct ufs_hba *, bool,
>  				enum ufs_notify_change_status);
>  	int     (*setup_regulators)(struct ufs_hba *, bool);
> +	void    (*host_reset)(struct ufs_hba *);
>  	int	(*hce_enable_notify)(struct ufs_hba *,
>  				     enum ufs_notify_change_status);
>  	int	(*link_startup_notify)(struct ufs_hba *,

New ufs core methods should be added in a separate patch with 
a good description, and also with actual callers using them.
