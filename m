Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B03016C6B0
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 06:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723184904; cv=none; b=KRXUGMDuFI2w+DkgMvxdlTOEPgioT4Tq8Pw+CjmgJ5Hu6Xduot8Uho7FPrKiYXASBtPdmwE62Ty1CCelCSjOVO3TQ9QS+HATFMlN8BlmRhKd/D6LjCTmKXGMkQ2xxJuQ0RD72PeOGCP98CvgVegw9aglN8ZQy1gPmbJHyANHMtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723184904; c=relaxed/simple;
	bh=k36dnBFZIeLBvQIBC1qpxq5W5ItsDC7kxBApVOMKWso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYd7ljhlEkJZJJzzVH9vErVsXYrFJpvroSt008DvCPL6HHI38moUbxxyCS443a1YraLHGGSc1KBvCMDpvK472EszcUyExMUcEsDJg63ikNCfDPhCaxZZhcYOhDmAB2UmEkqOaEuudYhG8BeAEG6qQGJSpo9FngU/FLDIIy1G1xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hqeZ2Mz3; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hqeZ2Mz3"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fc491f9b55so14703095ad.3
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2024 23:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723184902; x=1723789702; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZIb81mdm3Y+W7n5dTfDQvbXoixCEejMCmdPndqcOSy0=;
        b=hqeZ2Mz3DfKSYDydAsR4B6seyUMoFqP3cbAXx4rMfgBRQz/X11fIFajqvUzSA27OVY
         qfudlnKoGCqDMWbSWn/g3EFQaREnA+T4XodpImsh2xqZjpAe6ho29hzT4myXIZbqeN/p
         L9XY/cS6uw44d6nxZfCy9TNhPQB6VcPgcMv5N+brkGnVFdfJFt1U/ANnnqLNpburbjYU
         9lww+yFlJjfbLbJyNlvkWz6lhelFxQJg8x4nSN57uiypJ2H4Bo3gpoCnrjLwTyKvHQTX
         4e6dO5V4TZXcaL3wcc9JwQdDhHOugrTzen3KcLHcV/23RZQ8fCoFr8e9XId0VTx7u4Yt
         0JXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723184902; x=1723789702;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIb81mdm3Y+W7n5dTfDQvbXoixCEejMCmdPndqcOSy0=;
        b=mEH3hsl7HCNisGmShWkAUXGjZF1ErfWubGJOw+toO7ZLiHiLITV4H8nCj+mhHiDUMf
         4NSuYdqT3Ha+8zJ3IAGcrjsylEdKbfTKvBb/136Ezwo6Xcw41ileD8ZVKPTUs+XX77jb
         69ntQuq6rs8pf1fUL/NUdroJIpKSs8eN+kUldk9hn/oFcDqh+VFbMcwC1HhBSe1KnTWY
         kn7wg0DWoPUeX4EyqhnqBLhubnFKZXiDLUsMJ7YKdJBcHJVgufUgNVIC+ld07RqwK+9Q
         0g9mxb5lUa19BRH8TETsMRHQVeQS3rG1EyoHZCKkultkGQ8ZBVzuRkZcq28uj2hhgSYz
         RYdA==
X-Forwarded-Encrypted: i=1; AJvYcCWRw2NvCvSDPJnahxamM/4FJcT97kTXh8YB8tt8WC/E574zgzqgDoBYZ6UPRP4jz1jD3kAUdIR0SAVRGYIor+p9nV3sMTs8KCMJGA==
X-Gm-Message-State: AOJu0Yx22WRlSQOyUtXTGsZvopqgHUcj5E09RXOMWsj6sqK8Q1A/T8Tc
	gLjBl072mF90EhFjYmpgxy8Tl9VoUDC4xay5ZCJbJbiI5NsVvnFzJnhS+AfxeQ==
X-Google-Smtp-Source: AGHT+IGsasHpV/b0wZ6hW5jBeHdTPZmWl2BTJu2ASUcJUsUFz15Ge+CsJmrwMOugSuJO5MJnkscfGQ==
X-Received: by 2002:a17:902:f68c:b0:1fb:6e06:a099 with SMTP id d9443c01a7336-200ae5ce2c7mr5006435ad.40.1723184901711;
        Thu, 08 Aug 2024 23:28:21 -0700 (PDT)
Received: from thinkpad ([117.213.100.70])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff5916eaffsm134860975ad.194.2024.08.08.23.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 23:28:21 -0700 (PDT)
Date: Fri, 9 Aug 2024 11:58:13 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>,
	linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/3] scsi: ufs: rockchip: init support for UFS
Message-ID: <20240809062813.GC2826@thinkpad>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>

On Thu, Aug 08, 2024 at 11:52:43AM +0800, Shawn Lin wrote:
> RK3576 contains a UFS controller, add init support fot it.
> 

This description is very simple. Please add more info like the UFSHCD version,
lane config, quirks and any other vendor specific difference.

> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
> 
> ---
> 
> Changes in v2:
> - use dev_probe_err
> - remove ufs-phy-config-mode as it's not used
> - drop of_match_ptr
> 
>  drivers/ufs/host/Kconfig        |  12 ++
>  drivers/ufs/host/Makefile       |   1 +
>  drivers/ufs/host/ufs-rockchip.c | 438 ++++++++++++++++++++++++++++++++++++++++
>  drivers/ufs/host/ufs-rockchip.h |  51 +++++
>  4 files changed, 502 insertions(+)
>  create mode 100644 drivers/ufs/host/ufs-rockchip.c
>  create mode 100644 drivers/ufs/host/ufs-rockchip.h
> 
> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> index 580c8d0..fafaa33 100644
> --- a/drivers/ufs/host/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -142,3 +142,15 @@ config SCSI_UFS_SPRD
>  
>  	  Select this if you have UFS controller on Unisoc chipset.
>  	  If unsure, say N.
> +
> +config SCSI_UFS_ROCKCHIP
> +	tristate "Rockchip specific hooks to UFS controller platform driver"
> +	depends on SCSI_UFSHCD_PLATFORM && (ARCH_ROCKCHIP || COMPILE_TEST)
> +	help
> +	  This selects the Rockchip specific additions to UFSHCD platform driver.
> +	  UFS host on Rockchip needs some vendor specific configuration before
> +	  accessing the hardware which includes PHY configuration and vendor
> +	  specific registers.
> +
> +	  Select this if you have UFS controller on Rockchip chipset.
> +	  If unsure, say N.
> diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
> index 4573aea..2f97feb 100644
> --- a/drivers/ufs/host/Makefile
> +++ b/drivers/ufs/host/Makefile
> @@ -10,5 +10,6 @@ obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
>  obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
>  obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
>  obj-$(CONFIG_SCSI_UFS_RENESAS) += ufs-renesas.o
> +obj-$(CONFIG_SCSI_UFS_ROCKCHIP) += ufs-rockchip.o
>  obj-$(CONFIG_SCSI_UFS_SPRD) += ufs-sprd.o
>  obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
> diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
> new file mode 100644
> index 0000000..46c90d6
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-rockchip.c
> @@ -0,0 +1,438 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Rockchip UFS Host Controller driver
> + *
> + * Copyright (C) 2024 Rockchip Electronics Co.Ltd.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/gpio.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/reset.h>
> +
> +#include <ufs/ufshcd.h>
> +#include <ufs/unipro.h>
> +#include "ufshcd-pltfrm.h"
> +#include "ufshcd-dwc.h"
> +#include "ufs-rockchip.h"
> +
> +static inline bool ufshcd_is_device_present(struct ufs_hba *hba)

No inline in .c file please.

> +{
> +	return ufshcd_readl(hba, REG_CONTROLLER_STATUS) & DEVICE_PRESENT;
> +}
> +
> +static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
> +					 enum ufs_notify_change_status status)
> +{
> +	int err = 0;
> +
> +	if (status == PRE_CHANGE) {
> +		int retry_outer = 3;
> +		int retry_inner;
> +start:
> +		if (ufshcd_is_hba_active(hba))
> +			/* change controller state to "reset state" */
> +			ufshcd_hba_stop(hba);
> +
> +		/* UniPro link is disabled at this point */
> +		ufshcd_set_link_off(hba);
> +
> +		/* start controller initialization sequence */
> +		ufshcd_writel(hba, CONTROLLER_ENABLE, REG_CONTROLLER_ENABLE);
> +
> +		usleep_range(100, 200);
> +
> +		/* wait for the host controller to complete initialization */
> +		retry_inner = 50;
> +		while (!ufshcd_is_hba_active(hba)) {
> +			if (retry_inner) {
> +				retry_inner--;
> +			} else {
> +				dev_err(hba->dev,
> +					"Controller enable failed\n");
> +				if (retry_outer) {
> +					retry_outer--;
> +					goto start;
> +				}
> +				return -EIO;
> +			}
> +			usleep_range(1000, 1100);
> +		}

You just duplicated ufshcd_hba_execute_hce() here. Why? This doesn't make sense.

> +	} else { /* POST_CHANGE */
> +		err = ufshcd_vops_phy_initialization(hba);
> +	}
> +
> +	return err;
> +}
> +
> +static void ufs_rockchip_set_pm_lvl(struct ufs_hba *hba)
> +{
> +	hba->rpm_lvl = UFS_PM_LVL_1;
> +	hba->spm_lvl = UFS_PM_LVL_3;
> +}
> +
> +static int ufs_rockchip_rk3576_phy_init(struct ufs_hba *hba)
> +{
> +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> +
> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(PA_LOCAL_TX_LCC_ENABLE, 0x0), 0x0);
> +	/* enable the mphy DME_SET cfg */
> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x200, 0x0), 0x40);
> +	for (int i = 0; i < 2; i++) {
> +		/* Configuration M-TX */
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xaa, SEL_TX_LANE0 + i), 0x06);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xa9, SEL_TX_LANE0 + i), 0x02);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xad, SEL_TX_LANE0 + i), 0x44);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xac, SEL_TX_LANE0 + i), 0xe6);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xab, SEL_TX_LANE0 + i), 0x07);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x94, SEL_TX_LANE0 + i), 0x93);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x93, SEL_TX_LANE0 + i), 0xc9);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x7f, SEL_TX_LANE0 + i), 0x00);
> +		/* Configuration M-RX */
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x12, SEL_RX_LANE0 + i), 0x06);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x11, SEL_RX_LANE0 + i), 0x00);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, SEL_RX_LANE0 + i), 0x58);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, SEL_RX_LANE0 + i), 0x8c);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, SEL_RX_LANE0 + i), 0x02);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x25, SEL_RX_LANE0 + i), 0xf6);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x2f, SEL_RX_LANE0 + i), 0x69);
> +	}
> +	/* disable the mphy DME_SET cfg */
> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x200, 0x0), 0x00);
> +
> +	ufs_sys_writel(host->mphy_base, 0x80, 0x08C);
> +	ufs_sys_writel(host->mphy_base, 0xB5, 0x110);
> +	ufs_sys_writel(host->mphy_base, 0xB5, 0x250);
> +

Why can't you do these settings in a PHY driver?

> +	ufs_sys_writel(host->mphy_base, 0x03, 0x134);
> +	ufs_sys_writel(host->mphy_base, 0x03, 0x274);
> +
> +	ufs_sys_writel(host->mphy_base, 0x38, 0x0E0);
> +	ufs_sys_writel(host->mphy_base, 0x38, 0x220);
> +
> +	ufs_sys_writel(host->mphy_base, 0x50, 0x164);
> +	ufs_sys_writel(host->mphy_base, 0x50, 0x2A4);
> +
> +	ufs_sys_writel(host->mphy_base, 0x80, 0x178);
> +	ufs_sys_writel(host->mphy_base, 0x80, 0x2B8);
> +
> +	ufs_sys_writel(host->mphy_base, 0x18, 0x1B0);
> +	ufs_sys_writel(host->mphy_base, 0x18, 0x2F0);
> +
> +	ufs_sys_writel(host->mphy_base, 0x03, 0x128);
> +	ufs_sys_writel(host->mphy_base, 0x03, 0x268);
> +
> +	ufs_sys_writel(host->mphy_base, 0x20, 0x12C);
> +	ufs_sys_writel(host->mphy_base, 0x20, 0x26C);
> +
> +	ufs_sys_writel(host->mphy_base, 0xC0, 0x120);
> +	ufs_sys_writel(host->mphy_base, 0xC0, 0x260);
> +
> +	ufs_sys_writel(host->mphy_base, 0x03, 0x094);
> +
> +	ufs_sys_writel(host->mphy_base, 0x03, 0x1B4);
> +	ufs_sys_writel(host->mphy_base, 0x03, 0x2F4);
> +
> +	ufs_sys_writel(host->mphy_base, 0xC0, 0x08C);
> +	udelay(1);
> +	ufs_sys_writel(host->mphy_base, 0x00, 0x08C);
> +
> +	udelay(200);
> +	/* start link up */
> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(MIB_T_DBG_CPORT_TX_ENDIAN, 0), 0x0);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(MIB_T_DBG_CPORT_RX_ENDIAN, 0), 0x0);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID_VALID, 0), 0x1);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(T_PEERDEVICEID, 0), 0x1);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, 0), 0x1);
> +
> +	return 0;
> +}
> +
> +static int ufs_rockchip_common_init(struct ufs_hba *hba)
> +{
> +	struct device *dev = hba->dev;
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct ufs_rockchip_host *host;
> +	int err = 0;
> +
> +	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +	if (!host)
> +		return -ENOMEM;
> +
> +	/* system control register for hci */
> +	host->ufs_sys_ctrl = devm_platform_ioremap_resource_byname(pdev, "hci_grf");
> +	if (IS_ERR(host->ufs_sys_ctrl))
> +		return dev_err_probe(dev, PTR_ERR(host->ufs_sys_ctrl),
> +					"cannot ioremap for hci system control register\n");
> +
> +	/* system control register for mphy */
> +	host->ufs_phy_ctrl = devm_platform_ioremap_resource_byname(pdev, "mphy_grf");
> +	if (IS_ERR(host->ufs_phy_ctrl))
> +		return dev_err_probe(dev, PTR_ERR(host->ufs_phy_ctrl),
> +				"cannot ioremap for mphy system control register\n");
> +
> +	/* mphy base register */
> +	host->mphy_base = devm_platform_ioremap_resource_byname(pdev, "mphy");
> +	if (IS_ERR(host->mphy_base))
> +		return dev_err_probe(dev, PTR_ERR(host->mphy_base),
> +					"cannot ioremap for mphy base register\n");
> +
> +	host->rst = devm_reset_control_array_get_exclusive(dev);
> +	if (IS_ERR(host->rst))
> +		return dev_err_probe(dev, PTR_ERR(host->rst), "failed to get reset control\n");
> +
> +	reset_control_assert(host->rst);
> +	udelay(1);
> +	reset_control_deassert(host->rst);
> +
> +	host->ref_out_clk = devm_clk_get(dev, "ref_out");
> +	if (IS_ERR(host->ref_out_clk))
> +		return dev_err_probe(dev, PTR_ERR(host->ref_out_clk), "ciu-drive not available\n");

What is 'ciu-drive'?

> +
> +	err = clk_prepare_enable(host->ref_out_clk);
> +	if (err)
> +		return dev_err_probe(dev, err, "failed to enable ref out clock\n");
> +
> +	host->rst_gpio = devm_gpiod_get(&pdev->dev, "reset", GPIOD_OUT_LOW);
> +	if (IS_ERR(host->rst_gpio)) {
> +		dev_err_probe(&pdev->dev, PTR_ERR(host->rst_gpio),
> +				"invalid reset-gpios property in node\n");
> +		err = PTR_ERR(host->rst_gpio);

Krzysztof already pointed out this.

> +		goto out;
> +	}
> +	udelay(20);
> +	gpiod_set_value_cansleep(host->rst_gpio, 1);

Why do you need to assert device reset here? ufshcd driver will do it anyway.

> +
> +	host->clks[0].id = "core";
> +	host->clks[1].id = "pclk";
> +	host->clks[2].id = "pclk_mphy";
> +	err = devm_clk_bulk_get_optional(dev, UFS_MAX_CLKS, host->clks);
> +	if (err) {
> +		dev_err_probe(dev, err, "failed to get clocks\n");
> +		goto out;
> +	}
> +
> +	err = clk_bulk_prepare_enable(UFS_MAX_CLKS, host->clks);
> +	if (err) {
> +		dev_err_probe(dev, err, "failed to enable clocks\n");
> +		goto out;
> +	}
> +
> +	pm_runtime_set_active(&pdev->dev);

This is already called in ufshcd_pltfrm_init().

> +
> +	host->hba = hba;
> +	ufs_rockchip_set_pm_lvl(hba);
> +
> +	ufshcd_set_variant(hba, host);
> +
> +	return 0;
> +out:

s/out/disable_ref_clk

> +	clk_disable_unprepare(host->ref_out_clk);
> +	return err;
> +}
> +
> +static int ufs_rockchip_rk3576_init(struct ufs_hba *hba)
> +{
> +	int ret = 0;

Initialization not needed.

> +	struct device *dev = hba->dev;
> +

Also reverse Xmas order for local variables please.

> +	hba->quirks = UFSHCI_QUIRK_BROKEN_HCE | UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING;
> +
> +	/* Enable BKOPS when suspend */
> +	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
> +	/* Enable putting device into deep sleep */
> +	hba->caps |= UFSHCD_CAP_DEEPSLEEP;
> +	/* Enable devfreq of UFS */
> +	hba->caps |= UFSHCD_CAP_CLK_SCALING;
> +	/* Enable WriteBooster */
> +	hba->caps |= UFSHCD_CAP_WB_EN;
> +
> +	ret = ufs_rockchip_common_init(hba);
> +	if (ret)
> +		return dev_err_probe(dev, ret, "ufs common init fail\n");
> +
> +	return 0;
> +}
> +
> +static int ufs_rockchip_device_reset(struct ufs_hba *hba)
> +{
> +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
> +
> +	if (!host->rst_gpio)
> +		return -EOPNOTSUPP;

Is it possible to hit this condition?

> +
> +	gpiod_set_value_cansleep(host->rst_gpio, 0);
> +	udelay(20);
> +
> +	gpiod_set_value_cansleep(host->rst_gpio, 1);
> +	udelay(20);
> +
> +	return 0;
> +}
> +
> +static const struct ufs_hba_variant_ops ufs_hba_rk3576_vops = {
> +	.name = "rk3576",
> +	.init = ufs_rockchip_rk3576_init,
> +	.device_reset = ufs_rockchip_device_reset,
> +	.hce_enable_notify = ufs_rockchip_hce_enable_notify,
> +	.phy_initialization = ufs_rockchip_rk3576_phy_init,
> +};
> +
> +static const struct of_device_id ufs_rockchip_of_match[] = {
> +	{ .compatible = "rockchip,rk3576-ufs", .data = &ufs_hba_rk3576_vops},

Use 'rockchip,rk3576-ufshc'.

> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, ufs_rockchip_of_match);
> +
> +static int ufs_rockchip_probe(struct platform_device *pdev)
> +{
> +	int err = 0;

Again no init needed and use reverse Xmas order (everywhere).

> +	struct device *dev = &pdev->dev;
> +	const struct ufs_hba_variant_ops *vops;
> +
> +	vops = device_get_match_data(dev);

Is it OK if vops is NULL?

> +	err = ufshcd_pltfrm_init(pdev, vops);
> +	if (err)
> +		dev_err_probe(dev, err, "ufshcd_pltfrm_init failed\n");

Return err here and return 0 below.

> +
> +	return err;
> +}
> +

[...]

> +static const struct dev_pm_ops ufs_rockchip_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(ufs_rockchip_suspend, ufs_rockchip_resume)
> +	SET_RUNTIME_PM_OPS(ufs_rockchip_runtime_suspend, ufs_rockchip_runtime_resume, NULL)

Why can't you use ufshcd PM ops as like other vendor drivers?

> +	.prepare	 = ufshcd_suspend_prepare,
> +	.complete	 = ufshcd_resume_complete,
> +};
> +
> +static struct platform_driver ufs_rockchip_pltform = {
> +	.probe = ufs_rockchip_probe,
> +	.remove = ufs_rockchip_remove,
> +	.driver = {
> +		.name = "ufshcd-rockchip",
> +		.pm = &ufs_rockchip_pm_ops,
> +		.of_match_table = ufs_rockchip_of_match,
> +	},
> +};
> +module_platform_driver(ufs_rockchip_pltform);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Rockchip UFS Host Driver");
> diff --git a/drivers/ufs/host/ufs-rockchip.h b/drivers/ufs/host/ufs-rockchip.h
> new file mode 100644
> index 0000000..9eb80e8
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-rockchip.h
> @@ -0,0 +1,51 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Rockchip UFS Host Controller driver
> + *
> + * Copyright (C) 2024 Rockchip Electronics Co.Ltd.
> + */
> +
> +#ifndef _UFS_ROCKCHIP_H_
> +#define _UFS_ROCKCHIP_H_
> +
> +#define UFS_MAX_CLKS 3
> +
> +#define SEL_TX_LANE0 0x0
> +#define SEL_TX_LANE1 0x1
> +#define SEL_TX_LANE2 0x2
> +#define SEL_TX_LANE3 0x3
> +#define SEL_RX_LANE0 0x4
> +#define SEL_RX_LANE1 0x5
> +#define SEL_RX_LANE2 0x6
> +#define SEL_RX_LANE3 0x7
> +
> +#define MIB_T_DBG_CPORT_TX_ENDIAN	0xc022
> +#define MIB_T_DBG_CPORT_RX_ENDIAN	0xc023
> +
> +struct ufs_rockchip_host {
> +	struct ufs_hba *hba;
> +	void __iomem *ufs_phy_ctrl;
> +	void __iomem *ufs_sys_ctrl;
> +	void __iomem *mphy_base;
> +	struct gpio_desc *rst_gpio;
> +	struct reset_control *rst;
> +	struct clk *ref_out_clk;
> +	struct clk_bulk_data clks[UFS_MAX_CLKS];
> +	uint64_t caps;
> +	bool in_suspend;

Move bool to the end to avoid holes.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
