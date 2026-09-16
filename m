Received: from hall.aurel32.net (hall.aurel32.net [195.154.119.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A523E51C346;
	Wed, 16 Sep 2026 16:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.154.119.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576011; cv=none; b=RKMs7uo1Tx5do/W6YvhnwnyuDjnWWYwyxJSHptk1CojYnBwRVh97OcCf6x4EePbn+xPvLZYLm94o1b6Plxolut3nOJ3b/WmSNTBK8vxuF0JuQLn5xgtGigExDiEwxEdYYA7ezOseGhU4W1zCO5njW9Q3MQB7brtKaOGlVe+HYsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576011; c=relaxed/simple;
	bh=bQmq8/4nlMdLauAhTzUH5s0o+HDsPJ1FRtZT/0Avn6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GuQbjCiTLR9L5URUEoWbOe66S72uS4kftFvBEAWrSQ9/8swbOVENhoxiu7byWlEoiPlRKb3AT+wEXyhsSQGFRNTjf9wCB6Et9pGLkXQWWnu4Dhco1/XKW7g6+Uj6aw8JqOQ872UZUJrSYL113ayQRaIPXbw9rHb4VCDJBuc/1d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net; spf=pass smtp.mailfrom=aurel32.net; dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b=JNyglAw6; arc=none smtp.client-ip=195.154.119.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurel32.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b="JNyglAw6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
	; s=202004.hall; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Content-Transfer-Encoding:From:Reply-To:
	Subject:Content-ID:Content-Description:X-Debbugs-Cc;
	bh=yoAeTRTh0GroYZP/sXmvaOQSkoa3dgKrLu2uFbFrXCA=; b=JNyglAw6hJJA6CBUPLi/mrxM0l
	rdDH3hKaTjUDvoJS/4sTPH/B5i4E+u5nf05r9TNc9rpfjHgw+2PH3ZSq3F1oEE5pR/+toQGrYmOtP
	d1t6nuOugXZCVLehFxAdBhaSHpDE6lCZDYFf3dqr/Mq+faIeKUIcUEg8FdQYXn0AvlTHZRwmys/a6
	P/iWd5yuvUKuocOahpLyrMHfS2x4Qt97xrUxNSDIn7CxaF3I9f3BnebSp+M0YIz7PenYxpbexwcbq
	2QraS9bXI20zZgfLwhJe0aUCi2De7x4O0Xp+i+OfxBKTq20tQg9aZTezRNRQnsmbBF8njtxUwuDQP
	8zhyNQOQ==;
Received: from authenticated user
	by hall.aurel32.net with esmtpsa  (TLS1.3)  tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <aurelien@aurel32.net>)
	id 1x6sSn-0000000FfA5-3Vzq;
	Wed, 16 Sep 2026 18:26:25 +0200
Date: Wed, 16 Sep 2026 18:26:25 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Yixun Lan <dlan@kernel.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Jennifer Berringer <jberring@redhat.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/3] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
Message-ID: <aqrDMVMMtTfVVu8X@aurel32.net>
Mail-Followup-To: Yixun Lan <dlan@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>,
	Jennifer Berringer <jberring@redhat.com>,
	linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
	linux-riscv@lists.infradead.org, spacemit@lists.linux.dev,
	linux-kernel@vger.kernel.org
References: <20260916-08-k3-ufs-support-v5-0-1f5d71f1027d@kernel.org>
 <20260916-08-k3-ufs-support-v5-2-1f5d71f1027d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916-08-k3-ufs-support-v5-2-1f5d71f1027d@kernel.org>
User-Agent: Mutt/2.4.1 (2026-07-04)

Hi Yixun,

On 2026-09-16 02:59, Yixun Lan wrote:
> SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> M-PHY v3.0 standard.
> 
> Tested-by: Aurelien Jarno <aurelien@aurel32.net>
> Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  drivers/ufs/host/Kconfig        |  12 +
>  drivers/ufs/host/Makefile       |   1 +
>  drivers/ufs/host/ufs-spacemit.c | 688 ++++++++++++++++++++++++++++++++++++++++
>  drivers/ufs/host/ufs-spacemit.h |  79 +++++
>  4 files changed, 780 insertions(+)
> 
> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> index ff170c0b6da0..6146872fcecc 100644
> --- a/drivers/ufs/host/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -132,6 +132,18 @@ config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
>  	bool
>  	default y if SCSI_UFS_EXYNOS && SCSI_UFS_CRYPTO
>  
> +config SCSI_UFS_SPACEMIT
> +	tristate "SpacemiT UFS controller driver"
> +	depends on SCSI_UFSHCD_PLATFORM && (ARCH_SPACEMIT || COMPILE_TEST)
> +	help
> +	  This selects the SpacemiT specific additions to UFSHCD platform driver.
> +	  UFS host on SpacemiT needs some vendor specific configuration before
> +	  accessing the hardware which includes PHY configuration and vendor
> +	  specific registers.
> +
> +	  Select this if you have UFS controller on SpacemiT chipset.
> +	  If unsure, say N.
> +
>  config SCSI_UFS_SPRD
>  	tristate "Unisoc specific hooks to UFS controller platform driver"
>  	depends on SCSI_UFSHCD_PLATFORM && (ARCH_SPRD || COMPILE_TEST)
> diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
> index 7d8db67eb23c..a3c447b8fc21 100644
> --- a/drivers/ufs/host/Makefile
> +++ b/drivers/ufs/host/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
>  obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
>  obj-$(CONFIG_SCSI_UFS_RENESAS) += ufs-renesas.o
>  obj-$(CONFIG_SCSI_UFS_ROCKCHIP) += ufs-rockchip.o
> +obj-$(CONFIG_SCSI_UFS_SPACEMIT) += ufs-spacemit.o
>  obj-$(CONFIG_SCSI_UFS_SPRD) += ufs-sprd.o
>  obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
>  obj-$(CONFIG_SCSI_UFS_AMD_VERSAL2) += ufs-amd-versal2.o ufshcd-dwc.o
> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-spacemit.c
> new file mode 100644
> index 000000000000..179e6edb2ac2
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c
> @@ -0,0 +1,688 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2026 SpacemiT (Hangzhou) Technology Co. Ltd
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>
> +#include <linux/slab.h>
> +
> +#include <ufs/ufshcd.h>
> +#include <ufs/ufshci.h>
> +#include <ufs/ufs_quirks.h>
> +#include <ufs/unipro.h>
> +
> +#include "ufshcd-pltfrm.h"
> +#include "ufs-spacemit.h"
> +
> +/* PA Layer Gettable and settable M-PHY Specific Attributes */
> +#define PA_TXHSG1SYNCLENGTH		0x1552
> +#define PA_TXHSG1PREPARELENGTH		0x1553
> +#define PA_TXHSG2SYNCLENGTH		0x1554
> +#define PA_TXHSG2PREPARELENGTH		0x1555
> +#define PA_TXHSG3SYNCLENGTH		0x1556
> +#define PA_TXHSG3PREPARELENGTH		0x1557
> +#define PA_TXMK2EXTENSION		0x155A
> +#define PA_PEERSCRAMBLING		0x155B
> +#define PA_TXSKIP			0x155C
> +#define PA_TXSKIPPERIOD			0x155D
> +#define PA_PEER_TX_LCC_ENABLE		0x155F
> +
> +#define PA_SCRAMBLING			0x1585
> +#define PA_MK2EXTENSIONGUARDBAND	0x15AB
> +
> +/* Special TX/RX Configuration Attributes */
> +#define RX_LS_PRE_LEN_CAP		0x008D
> +#define RX_LANE_HB8_BKDOOR_ATTR		0x00F4
> +#define RX_PWRM_CLOSURE_LEN_CAP		0x008E
> +#define RX_MIN_STALL_CAP		0x0088
> +#define RX_LANE_SOF_BKDOOR_ATT		0x00F2
> +#define RX_GARBAGE_COUNT_OFFSET		0x00F2
> +
> +/* Special analog register */
> +#define ANA_EQ_CTRL_REG_ATTR		0x00CD
> +#define ANA_HSGEAR_CTRL_ATTR		0x00C1
> +
> +/*
> + * Keep UFS ACLK at a lower parent rate (409.6MHz) for stable init.
> + * This mirrors the "ufs-low-aclk-freq" change from the other environment.
> + */
> +#define UFS_ACLK_LOW_FREQ_HZ		409600000UL

You probably want to rename that to AXI, although here it's not that 
important.

> +
> +/* PHY register magic values */
> +#define MPHY_PU_ALL			0x87f
> +#define MPHY_PU_WITH_HB8_RESET		0xb7f
> +#define MPHY_DEVICE_REFCLK_OE		BIT(8)
> +#define MPHY_DEVICE_HW_RESET		BIT(0)
> +
> +#define MPHY_PLL_LOCK_BIT		BIT(31)
> +#define MPHY_PLL_LOCK_TIMEOUT_US	10000
> +
> +/* FSM states */
> +#define FSM_STATE_HIBERN8		0x1
> +#define FSM_STATE_ACTIVE		0x3
> +#define FSM_STATE_LS_BURST		0x5
> +
> +#define VENDOR_DUMP_BUF_SIZE		2048
> +#define VENDOR_MAX_OFFSET		0xE0
> +
> +/* M-PHY FSM states */
> +#define MPHY_RX_FSM_STATE	0xC1
> +#define MPHY_TX_FSM_STATE	0x41
> +
> +static int ufs_spacemit_dme_set(struct ufs_hba *hba,
> +				const struct ufshcd_dme_attr_val *v, int n)
> +{
> +	int ret = 0;
> +	int attr_node = 0;
> +
> +	for (attr_node = 0; attr_node < n; attr_node++) {
> +		ret = ufshcd_dme_set(hba, v[attr_node].attr_sel,
> +				     v[attr_node].mib_val);
> +
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int ufs_spacemit_check_hibern8(struct ufs_hba *hba)
> +{
> +	u32 tx_fsm_val_0 = 0;
> +	u32 tx_fsm_val_1 = 0;
> +	int retries = DIV_ROUND_UP(HBRN8_POLL_TOUT_MS * 1000, 100);
> +	int err = 0;
> +
> +	do {
> +		err = ufshcd_dme_get(hba,
> +				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> +				     &tx_fsm_val_0);
> +		if (err)
> +			break;
> +
> +		err = ufshcd_dme_get(hba,
> +				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)),
> +				     &tx_fsm_val_1);
> +		if (err || (tx_fsm_val_0 == TX_FSM_HIBERN8 &&
> +			    tx_fsm_val_1 == TX_FSM_HIBERN8))
> +			break;
> +
> +		usleep_range(100, 200);
> +	} while (--retries > 0);
> +
> +	if (err) {
> +		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
> +			__func__, err);
> +	} else if (tx_fsm_val_0 != TX_FSM_HIBERN8 ||
> +		   tx_fsm_val_1 != TX_FSM_HIBERN8) {
> +		err = -ETIMEDOUT;
> +		dev_err(hba->dev,
> +			"%s: invalid TX_FSM_STATE, lane0 = %u, lane1 = %u\n",
> +			__func__, tx_fsm_val_0, tx_fsm_val_1);
> +	}
> +
> +	return err;
> +}
> +
> +static u32 ufs_spacemit_get_sys1clk_1us(struct ufs_hba *hba)
> +{
> +	struct ufs_clk_info *clki, *ufs_aclk = NULL;
> +	struct list_head *head = &hba->clk_list_head;
> +	unsigned long rate_hz = 0;
> +
> +	if (!list_empty(head)) {
> +		list_for_each_entry(clki, head, list) {
> +			if (clki->name && !strcmp(clki->name, "aclk") && clki->clk) {

On the other hand, you definitely want to rename this one to "axi" to 
match the device tree change. Right now the whole patchset just doesn't 
work.

> +				ufs_aclk = clki;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (ufs_aclk && ufs_aclk->clk)
> +		rate_hz = clk_get_rate(ufs_aclk->clk);
> +
> +	if (!rate_hz)
> +		return 0;
> +
> +	return DIV_ROUND_CLOSEST(rate_hz, 1000000);
> +}

Regards
Aurelien

-- 
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
