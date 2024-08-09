Received: from mail-m3277.qiye.163.com (mail-m3277.qiye.163.com [220.197.32.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF64193064;
	Fri,  9 Aug 2024 11:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723204512; cv=none; b=E1mX0lUnFGuVog2d/Q3RAjm6BnByOeZS5JMgq8JFe9YDKJ5eTLFvd7W57tLj5FUKc/Qik/igtaMTyOI4OirzlMjrk87PfZK/p91fsq0cgvIVuY6gCFWJ9dgz+EFSPXSURpwL/xXSVy5MAU20jPCpQ2P5Vb2A4s/QCHwHCj2Iaw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723204512; c=relaxed/simple;
	bh=Pp72qnjj4nUr1BpJBnd5XddALQYXt2ZPErAi00si+K4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QhVSLp9W3gLosmB8hY9mwZ36CSaLeDn22Og6PU6jdSnggSHmO37HWlUy20qgSNkRBqp5uubTSAuXOz8FxZzGDLiyv8r2W1Leb+Uk0FzS73GdCbjAMKLhrqkKIaKSQMSD8X/NqVzSNa/1AbAlP2TR3EnKyvg8WbwCqHzOdcZrIKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=G60rWaM1; arc=none smtp.client-ip=220.197.32.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="G60rWaM1"
DKIM-Signature: a=rsa-sha256;
	b=G60rWaM1FeFUABTIzk/3JC1VcNw/rvY9scjfs0OqvT02HGstOKsf2kq8flQWRnop529GHs6X+PvcKtQsW1f7YKKSR8HNeSnNR7pcllt9tYd1j+QSAAD8QyykV3/+t4DGhPa6rdvLhzOKals6FM5685VrFH8goRmb+MEDj8sFxA0=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=+4lU7weacAbAcla6+btR1q1HDUNuPSWxc4GTP2p+mJA=;
	h=date:mime-version:subject:message-id:from;
Received: from [172.16.12.69] (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTPA id 98B564604DF;
	Fri,  9 Aug 2024 16:16:41 +0800 (CST)
Message-ID: <421d48b7-4aa7-4202-8b5f-9c60916f6ef6@rock-chips.com>
Date: Fri, 9 Aug 2024 16:16:41 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: shawn.lin@rock-chips.com, Rob Herring <robh+dt@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 Bart Van Assche <bvanassche@acm.org>, YiFeng Zhao <zyf@rock-chips.com>,
 Liang Chen <cl@rock-chips.com>, linux-scsi@vger.kernel.org,
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
 devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/3] scsi: ufs: rockchip: init support for UFS
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
References: <1723089163-28983-1-git-send-email-shawn.lin@rock-chips.com>
 <1723089163-28983-4-git-send-email-shawn.lin@rock-chips.com>
 <20240809062813.GC2826@thinkpad>
Content-Language: en-GB
From: Shawn Lin <shawn.lin@rock-chips.com>
In-Reply-To: <20240809062813.GC2826@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1ktWUFJV1kPCRoVCBIfWUFZGUtLGlZPGUgdSBpISksZQk9WFRQJFh
	oXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0tIVUpLSUhCSE
	NVSktLVUpCS0tZBg++
X-HM-Tid: 0a91363620c903aekunm98b564604df
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OQg6OCo6TzI3Dw88H0shCg8*
	IhgKCzFVSlVKTElISkJKT0tISEJOVTMWGhIXVQgTGgwVVRcSFTsJFBgQVhgTEgsIVRgUFkVZV1kS
	C1lBWU5DVUlJVUxVSkpPWVdZCAFZQUpCSENMNwY+

Hi Mani

Thanks for the comments.

在 2024/8/9 14:28, Manivannan Sadhasivam 写道:
> On Thu, Aug 08, 2024 at 11:52:43AM +0800, Shawn Lin wrote:
>> RK3576 contains a UFS controller, add init support fot it.
>>
> 
> This description is very simple. Please add more info like the UFSHCD version,
> lane config, quirks and any other vendor specific difference.
> 

Will improve.

>> Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
>>
>> ---
>>
>> Changes in v2:
>> - use dev_probe_err
>> - remove ufs-phy-config-mode as it's not used
>> - drop of_match_ptr
>>
>>   drivers/ufs/host/Kconfig        |  12 ++
>>   drivers/ufs/host/Makefile       |   1 +
>>   drivers/ufs/host/ufs-rockchip.c | 438 ++++++++++++++++++++++++++++++++++++++++
>>   drivers/ufs/host/ufs-rockchip.h |  51 +++++
>>   4 files changed, 502 insertions(+)
>>   create mode 100644 drivers/ufs/host/ufs-rockchip.c
>>   create mode 100644 drivers/ufs/host/ufs-rockchip.h
>>
>> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
>> index 580c8d0..fafaa33 100644
>> --- a/drivers/ufs/host/Kconfig
>> +++ b/drivers/ufs/host/Kconfig
>> @@ -142,3 +142,15 @@ config SCSI_UFS_SPRD
>>   
>>   	  Select this if you have UFS controller on Unisoc chipset.
>>   	  If unsure, say N.
>> +
>> +config SCSI_UFS_ROCKCHIP
>> +	tristate "Rockchip specific hooks to UFS controller platform driver"
>> +	depends on SCSI_UFSHCD_PLATFORM && (ARCH_ROCKCHIP || COMPILE_TEST)
>> +	help
>> +	  This selects the Rockchip specific additions to UFSHCD platform driver.
>> +	  UFS host on Rockchip needs some vendor specific configuration before
>> +	  accessing the hardware which includes PHY configuration and vendor
>> +	  specific registers.
>> +
>> +	  Select this if you have UFS controller on Rockchip chipset.
>> +	  If unsure, say N.
>> diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
>> index 4573aea..2f97feb 100644
>> --- a/drivers/ufs/host/Makefile
>> +++ b/drivers/ufs/host/Makefile
>> @@ -10,5 +10,6 @@ obj-$(CONFIG_SCSI_UFSHCD_PLATFORM) += ufshcd-pltfrm.o
>>   obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
>>   obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
>>   obj-$(CONFIG_SCSI_UFS_RENESAS) += ufs-renesas.o
>> +obj-$(CONFIG_SCSI_UFS_ROCKCHIP) += ufs-rockchip.o
>>   obj-$(CONFIG_SCSI_UFS_SPRD) += ufs-sprd.o
>>   obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
>> diff --git a/drivers/ufs/host/ufs-rockchip.c b/drivers/ufs/host/ufs-rockchip.c
>> new file mode 100644
>> index 0000000..46c90d6
>> --- /dev/null
>> +++ b/drivers/ufs/host/ufs-rockchip.c
>> @@ -0,0 +1,438 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Rockchip UFS Host Controller driver
>> + *
>> + * Copyright (C) 2024 Rockchip Electronics Co.Ltd.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/gpio.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regmap.h>
>> +#include <linux/reset.h>
>> +
>> +#include <ufs/ufshcd.h>
>> +#include <ufs/unipro.h>
>> +#include "ufshcd-pltfrm.h"
>> +#include "ufshcd-dwc.h"
>> +#include "ufs-rockchip.h"
>> +
>> +static inline bool ufshcd_is_device_present(struct ufs_hba *hba)
> 
> No inline in .c file please.

ok.

> 
>> +{
>> +	return ufshcd_readl(hba, REG_CONTROLLER_STATUS) & DEVICE_PRESENT;
>> +}
>> +
>> +static int ufs_rockchip_hce_enable_notify(struct ufs_hba *hba,
>> +					 enum ufs_notify_change_status status)
>> +{
>> +	int err = 0;
>> +
>> +	if (status == PRE_CHANGE) {
>> +		int retry_outer = 3;
>> +		int retry_inner;
>> +start:
>> +		if (ufshcd_is_hba_active(hba))
>> +			/* change controller state to "reset state" */
>> +			ufshcd_hba_stop(hba);
>> +
>> +		/* UniPro link is disabled at this point */
>> +		ufshcd_set_link_off(hba);
>> +
>> +		/* start controller initialization sequence */
>> +		ufshcd_writel(hba, CONTROLLER_ENABLE, REG_CONTROLLER_ENABLE);
>> +
>> +		usleep_range(100, 200);
>> +
>> +		/* wait for the host controller to complete initialization */
>> +		retry_inner = 50;
>> +		while (!ufshcd_is_hba_active(hba)) {
>> +			if (retry_inner) {
>> +				retry_inner--;
>> +			} else {
>> +				dev_err(hba->dev,
>> +					"Controller enable failed\n");
>> +				if (retry_outer) {
>> +					retry_outer--;
>> +					goto start;
>> +				}
>> +				return -EIO;
>> +			}
>> +			usleep_range(1000, 1100);
>> +		}
> 
> You just duplicated ufshcd_hba_execute_hce() here. Why? This doesn't make sense.

Since we set UFSHCI_QUIRK_BROKEN_HCE, and we also need to do someting
which is very similar to ufshcd_hba_execute_hce(), before calling
ufshcd_dme_reset(). Similar but not totally the same. I'll try to see if
we can export ufshcd_hba_execute_hce() to make full use of it.

> 
>> +	} else { /* POST_CHANGE */
>> +		err = ufshcd_vops_phy_initialization(hba);
>> +	}
>> +
>> +	return err;
>> +}
>> +
>> +static void ufs_rockchip_set_pm_lvl(struct ufs_hba *hba)
>> +{
>> +	hba->rpm_lvl = UFS_PM_LVL_1;
>> +	hba->spm_lvl = UFS_PM_LVL_3;
>> +}
>> +
>> +static int ufs_rockchip_rk3576_phy_init(struct ufs_hba *hba)
>> +{
>> +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
>> +
>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(PA_LOCAL_TX_LCC_ENABLE, 0x0), 0x0);
>> +	/* enable the mphy DME_SET cfg */
>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x200, 0x0), 0x40);
>> +	for (int i = 0; i < 2; i++) {
>> +		/* Configuration M-TX */
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xaa, SEL_TX_LANE0 + i), 0x06);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xa9, SEL_TX_LANE0 + i), 0x02);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xad, SEL_TX_LANE0 + i), 0x44);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xac, SEL_TX_LANE0 + i), 0xe6);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xab, SEL_TX_LANE0 + i), 0x07);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x94, SEL_TX_LANE0 + i), 0x93);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x93, SEL_TX_LANE0 + i), 0xc9);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x7f, SEL_TX_LANE0 + i), 0x00);
>> +		/* Configuration M-RX */
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x12, SEL_RX_LANE0 + i), 0x06);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x11, SEL_RX_LANE0 + i), 0x00);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, SEL_RX_LANE0 + i), 0x58);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, SEL_RX_LANE0 + i), 0x8c);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, SEL_RX_LANE0 + i), 0x02);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x25, SEL_RX_LANE0 + i), 0xf6);
>> +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x2f, SEL_RX_LANE0 + i), 0x69);
>> +	}
>> +	/* disable the mphy DME_SET cfg */
>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x200, 0x0), 0x00);
>> +
>> +	ufs_sys_writel(host->mphy_base, 0x80, 0x08C);
>> +	ufs_sys_writel(host->mphy_base, 0xB5, 0x110);
>> +	ufs_sys_writel(host->mphy_base, 0xB5, 0x250);
>> +
> 
> Why can't you do these settings in a PHY driver?

As we have ->phy_initialization in struct ufs_hba_variant_ops,
which asks the host driver to use it to initialize phys. It doesn't
seem to need to create a whole new file to just add some smalls fixed
parameters. :)


> 
>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x134);
>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x274);
>> +
>> +	ufs_sys_writel(host->mphy_base, 0x38, 0x0E0);
>> +	ufs_sys_writel(host->mphy_base, 0x38, 0x220);
>> +
>> +	ufs_sys_writel(host->mphy_base, 0x50, 0x164);
>> +	ufs_sys_writel(host->mphy_base, 0x50, 0x2A4);
>> +
>> +	ufs_sys_writel(host->mphy_base, 0x80, 0x178);
>> +	ufs_sys_writel(host->mphy_base, 0x80, 0x2B8);
>> +
>> +	ufs_sys_writel(host->mphy_base, 0x18, 0x1B0);
>> +	ufs_sys_writel(host->mphy_base, 0x18, 0x2F0);
>> +
>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x128);
>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x268);
>> +
>> +	ufs_sys_writel(host->mphy_base, 0x20, 0x12C);
>> +	ufs_sys_writel(host->mphy_base, 0x20, 0x26C);
>> +
>> +	ufs_sys_writel(host->mphy_base, 0xC0, 0x120);
>> +	ufs_sys_writel(host->mphy_base, 0xC0, 0x260);
>> +
>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x094);
>> +
>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x1B4);
>> +	ufs_sys_writel(host->mphy_base, 0x03, 0x2F4);
>> +
>> +	ufs_sys_writel(host->mphy_base, 0xC0, 0x08C);
>> +	udelay(1);
>> +	ufs_sys_writel(host->mphy_base, 0x00, 0x08C);
>> +
>> +	udelay(200);
>> +	/* start link up */
>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(MIB_T_DBG_CPORT_TX_ENDIAN, 0), 0x0);
>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(MIB_T_DBG_CPORT_RX_ENDIAN, 0), 0x0);
>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID, 0), 0x0);
>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(N_DEVICEID_VALID, 0), 0x1);
>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(T_PEERDEVICEID, 0), 0x1);
>> +	ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(T_CONNECTIONSTATE, 0), 0x1);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ufs_rockchip_common_init(struct ufs_hba *hba)
>> +{
>> +	struct device *dev = hba->dev;
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct ufs_rockchip_host *host;
>> +	int err = 0;
>> +
>> +	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
>> +	if (!host)
>> +		return -ENOMEM;
>> +
>> +	/* system control register for hci */
>> +	host->ufs_sys_ctrl = devm_platform_ioremap_resource_byname(pdev, "hci_grf");
>> +	if (IS_ERR(host->ufs_sys_ctrl))
>> +		return dev_err_probe(dev, PTR_ERR(host->ufs_sys_ctrl),
>> +					"cannot ioremap for hci system control register\n");
>> +
>> +	/* system control register for mphy */
>> +	host->ufs_phy_ctrl = devm_platform_ioremap_resource_byname(pdev, "mphy_grf");
>> +	if (IS_ERR(host->ufs_phy_ctrl))
>> +		return dev_err_probe(dev, PTR_ERR(host->ufs_phy_ctrl),
>> +				"cannot ioremap for mphy system control register\n");
>> +
>> +	/* mphy base register */
>> +	host->mphy_base = devm_platform_ioremap_resource_byname(pdev, "mphy");
>> +	if (IS_ERR(host->mphy_base))
>> +		return dev_err_probe(dev, PTR_ERR(host->mphy_base),
>> +					"cannot ioremap for mphy base register\n");
>> +
>> +	host->rst = devm_reset_control_array_get_exclusive(dev);
>> +	if (IS_ERR(host->rst))
>> +		return dev_err_probe(dev, PTR_ERR(host->rst), "failed to get reset control\n");
>> +
>> +	reset_control_assert(host->rst);
>> +	udelay(1);
>> +	reset_control_deassert(host->rst);
>> +
>> +	host->ref_out_clk = devm_clk_get(dev, "ref_out");
>> +	if (IS_ERR(host->ref_out_clk))
>> +		return dev_err_probe(dev, PTR_ERR(host->ref_out_clk), "ciu-drive not available\n");
> 
> What is 'ciu-drive'?

Will fix.

> 
>> +
>> +	err = clk_prepare_enable(host->ref_out_clk);
>> +	if (err)
>> +		return dev_err_probe(dev, err, "failed to enable ref out clock\n");
>> +
>> +	host->rst_gpio = devm_gpiod_get(&pdev->dev, "reset", GPIOD_OUT_LOW);
>> +	if (IS_ERR(host->rst_gpio)) {
>> +		dev_err_probe(&pdev->dev, PTR_ERR(host->rst_gpio),
>> +				"invalid reset-gpios property in node\n");
>> +		err = PTR_ERR(host->rst_gpio);
> 
> Krzysztof already pointed out this.
> 
>> +		goto out;
>> +	}
>> +	udelay(20);
>> +	gpiod_set_value_cansleep(host->rst_gpio, 1);
> 
> Why do you need to assert device reset here? ufshcd driver will do it anyway.
> 

Yes, I see ufshcd_init（）will do that now. Will improve.

>> +
>> +	host->clks[0].id = "core";
>> +	host->clks[1].id = "pclk";
>> +	host->clks[2].id = "pclk_mphy";
>> +	err = devm_clk_bulk_get_optional(dev, UFS_MAX_CLKS, host->clks);
>> +	if (err) {
>> +		dev_err_probe(dev, err, "failed to get clocks\n");
>> +		goto out;
>> +	}
>> +
>> +	err = clk_bulk_prepare_enable(UFS_MAX_CLKS, host->clks);
>> +	if (err) {
>> +		dev_err_probe(dev, err, "failed to enable clocks\n");
>> +		goto out;
>> +	}
>> +
>> +	pm_runtime_set_active(&pdev->dev);
> 
> This is already called in ufshcd_pltfrm_init().

Ok.

> 
>> +
>> +	host->hba = hba;
>> +	ufs_rockchip_set_pm_lvl(hba);
>> +
>> +	ufshcd_set_variant(hba, host);
>> +
>> +	return 0;
>> +out:
> 
> s/out/disable_ref_clk

Will fix.

> 
>> +	clk_disable_unprepare(host->ref_out_clk);
>> +	return err;
>> +}
>> +
>> +static int ufs_rockchip_rk3576_init(struct ufs_hba *hba)
>> +{
>> +	int ret = 0;
> 
> Initialization not needed.
> 
>> +	struct device *dev = hba->dev;
>> +
> 
> Also reverse Xmas order for local variables please.

Will improve, as blow the same.

> 
>> +	hba->quirks = UFSHCI_QUIRK_BROKEN_HCE | UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING;
>> +
>> +	/* Enable BKOPS when suspend */
>> +	hba->caps |= UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
>> +	/* Enable putting device into deep sleep */
>> +	hba->caps |= UFSHCD_CAP_DEEPSLEEP;
>> +	/* Enable devfreq of UFS */
>> +	hba->caps |= UFSHCD_CAP_CLK_SCALING;
>> +	/* Enable WriteBooster */
>> +	hba->caps |= UFSHCD_CAP_WB_EN;
>> +
>> +	ret = ufs_rockchip_common_init(hba);
>> +	if (ret)
>> +		return dev_err_probe(dev, ret, "ufs common init fail\n");
>> +
>> +	return 0;
>> +}
>> +
>> +static int ufs_rockchip_device_reset(struct ufs_hba *hba)
>> +{
>> +	struct ufs_rockchip_host *host = ufshcd_get_variant(hba);
>> +
>> +	if (!host->rst_gpio)
>> +		return -EOPNOTSUPP;
> 
> Is it possible to hit this condition?
> 

No. We ask the BSP to provide reset pin as a must one. Will remove.

>> +
>> +	gpiod_set_value_cansleep(host->rst_gpio, 0);
>> +	udelay(20);
>> +
>> +	gpiod_set_value_cansleep(host->rst_gpio, 1);
>> +	udelay(20);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct ufs_hba_variant_ops ufs_hba_rk3576_vops = {
>> +	.name = "rk3576",
>> +	.init = ufs_rockchip_rk3576_init,
>> +	.device_reset = ufs_rockchip_device_reset,
>> +	.hce_enable_notify = ufs_rockchip_hce_enable_notify,
>> +	.phy_initialization = ufs_rockchip_rk3576_phy_init,
>> +};
>> +
>> +static const struct of_device_id ufs_rockchip_of_match[] = {
>> +	{ .compatible = "rockchip,rk3576-ufs", .data = &ufs_hba_rk3576_vops},
> 
> Use 'rockchip,rk3576-ufshc'.

ok.

> 
>> +	{},
>> +};
>> +MODULE_DEVICE_TABLE(of, ufs_rockchip_of_match);
>> +
>> +static int ufs_rockchip_probe(struct platform_device *pdev)
>> +{
>> +	int err = 0;
> 
> Again no init needed and use reverse Xmas order (everywhere).
> 
>> +	struct device *dev = &pdev->dev;
>> +	const struct ufs_hba_variant_ops *vops;
>> +
>> +	vops = device_get_match_data(dev);
> 
> Is it OK if vops is NULL?

Will check.

> 
>> +	err = ufshcd_pltfrm_init(pdev, vops);
>> +	if (err)
>> +		dev_err_probe(dev, err, "ufshcd_pltfrm_init failed\n");
> 
> Return err here and return 0 below.
> 

Ok.

>> +
>> +	return err;
>> +}
>> +
> 
> [...]
> 
>> +static const struct dev_pm_ops ufs_rockchip_pm_ops = {
>> +	SET_SYSTEM_SLEEP_PM_OPS(ufs_rockchip_suspend, ufs_rockchip_resume)
>> +	SET_RUNTIME_PM_OPS(ufs_rockchip_runtime_suspend, ufs_rockchip_runtime_resume, NULL)
> 
> Why can't you use ufshcd PM ops as like other vendor drivers?

It doesn't work from the test. We have many use case to power down the
controller and device, so there is no flow to recovery the link. Only
when the first accessing to UFS fails, the ufshcd error handle recovery 
the link. This is not what we expect.


> 
>> +	.prepare	 = ufshcd_suspend_prepare,
>> +	.complete	 = ufshcd_resume_complete,
>> +};
>> +
>> +static struct platform_driver ufs_rockchip_pltform = {
>> +	.probe = ufs_rockchip_probe,
>> +	.remove = ufs_rockchip_remove,
>> +	.driver = {
>> +		.name = "ufshcd-rockchip",
>> +		.pm = &ufs_rockchip_pm_ops,
>> +		.of_match_table = ufs_rockchip_of_match,
>> +	},
>> +};
>> +module_platform_driver(ufs_rockchip_pltform);
>> +
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("Rockchip UFS Host Driver");
>> diff --git a/drivers/ufs/host/ufs-rockchip.h b/drivers/ufs/host/ufs-rockchip.h
>> new file mode 100644
>> index 0000000..9eb80e8
>> --- /dev/null
>> +++ b/drivers/ufs/host/ufs-rockchip.h
>> @@ -0,0 +1,51 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Rockchip UFS Host Controller driver
>> + *
>> + * Copyright (C) 2024 Rockchip Electronics Co.Ltd.
>> + */
>> +
>> +#ifndef _UFS_ROCKCHIP_H_
>> +#define _UFS_ROCKCHIP_H_
>> +
>> +#define UFS_MAX_CLKS 3
>> +
>> +#define SEL_TX_LANE0 0x0
>> +#define SEL_TX_LANE1 0x1
>> +#define SEL_TX_LANE2 0x2
>> +#define SEL_TX_LANE3 0x3
>> +#define SEL_RX_LANE0 0x4
>> +#define SEL_RX_LANE1 0x5
>> +#define SEL_RX_LANE2 0x6
>> +#define SEL_RX_LANE3 0x7
>> +
>> +#define MIB_T_DBG_CPORT_TX_ENDIAN	0xc022
>> +#define MIB_T_DBG_CPORT_RX_ENDIAN	0xc023
>> +
>> +struct ufs_rockchip_host {
>> +	struct ufs_hba *hba;
>> +	void __iomem *ufs_phy_ctrl;
>> +	void __iomem *ufs_sys_ctrl;
>> +	void __iomem *mphy_base;
>> +	struct gpio_desc *rst_gpio;
>> +	struct reset_control *rst;
>> +	struct clk *ref_out_clk;
>> +	struct clk_bulk_data clks[UFS_MAX_CLKS];
>> +	uint64_t caps;
>> +	bool in_suspend;
> 
> Move bool to the end to avoid holes.
> 
> - Mani
> 
