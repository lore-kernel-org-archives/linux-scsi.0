Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793629360;
	b=iRpZ/qScxLSy0KRqXNISlk7wh2d+E7rsTn+2M1DASTzMF0qQTMz73ZFqmOFc/uNFDwYK
	 5qsYTQjD0ByBMzqcmHxlWvE83PIMTycYA1F+45t22erHgc+QeI+DKQxvokD9NQdCUtIoU
	 uLVdQaawlGKefI2ARK2MDbz3TL3OGiMjedk9h8CCuKKF0aGq7dfk8DsA8frNkIqf5wi1J
	 P90dfD/3oQMEo8j5MkyH69T1ult5I+EIAb6seCWLdzWjyy0hYSzFncdFD0xUkYvhmV2Qk
	 U1A4OaMTsrXr8mAQReAEmROlEoRTsU9zVI9arw/1eVFbJ1sS3ulEEwju6Bk8i3dfqLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793629360;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:To:From:Subject:X-Mailer:References:In-Reply-To;
	bh=ul5zAT5XA1IgDpSrbBJ3ibIOhSt8X7JWBFKnGAIgGGo=;
	b=sSbc+xR1IfHS0tTcyYDz3UCOEcVuMDq5/ddXfzbhvZoQyyUGkehjh9aBvlV5GQ6mP+wl
	 pSyJQIspEcT3C3ym4oKgSpfSXMimaVGP1dcW4x5Wt3yDhJ8g/c6yi3Ccz0vryeXSniJVE
	 0DEy19wQ7QOJ4hJx1ggtjxGyZFXMy6Xl7Nxg/5jYg1A1/uEYZhCD4D7cn4I/rBDIo98mf
	 762Zla9Hjyt362bhuEBuVnBVgwXb/SYxKpVc/7/xe/Reh6uSotI173J0NMg2GvpAYEboh
	 2nO9cLdDlRXRN+k+UrDB8JorzqPBSypphdgGtjAHHOTlIE2ieyznfUZAj1BP2K7pi3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=baylibre.com;
	spf=pass smtp.mailfrom=baylibre.com;
	dkim=pass header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=fKr+ZQdS;
	arc=none smtp.remote-ip=209.85.161.45
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26C9606A33D
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 14:22:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A26C9606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=baylibre.com header.i=@baylibre.com header.a=rsa-sha256 header.s=google header.b=fKr+ZQdS
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-70bf1671c21so1803214eaf.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2026 06:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1793629357; x=1794234157; darn=vger.kernel.org;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ul5zAT5XA1IgDpSrbBJ3ibIOhSt8X7JWBFKnGAIgGGo=;
        b=fKr+ZQdSLvPlOvCWzLZZBFmYTu99yddRuL2A22+BUihTi90kl2blAO70ByWhPVMgWo
         JJzVR95aDJ8P/Hj5aQZ0alBDZWfoqzFoWE8pXt2rvnPhtj12ED+M1BmZWMEZv79qzqwv
         6IEsPfxqcqQVBhFMfp52DQ3+Db/oPhN+0QgbIVlJHhEmuST1J4mRUPbrUJsRr3fgQ2DW
         3z7US7iP1R+pEkGDaOBD7No2Iy4glls1TZ0ADvxwmc3CfJd5bZmsOT8Iioc3XOxAG+7t
         z1SeERe5EGuJUQ9/R2cCC28KVXaBUb3/rCJYhjxDqXw1ElbtkqrBIb0Orx/zLK2MsgaQ
         OXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793629357; x=1794234157;
        h=in-reply-to:references:subject:from:to:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ul5zAT5XA1IgDpSrbBJ3ibIOhSt8X7JWBFKnGAIgGGo=;
        b=YFCJWTMr2dNOJ2fQTEn6Y5dozPfJfYRijPgDdKx/oZbtnH9s2xo+bJ7pZWKJTHy4OA
         ClhIEBj/pQS6XJJYlPhXrM+1ctUc5WQ7hDhs5kHus9OnbU/2IiggLUBUQJ/gwi6Yyn27
         CgxsiBAsgFdhS+2A5Eis8+EjdwnwsAvJSLIw3TyoIMcikB7zHXsl6IMrgn+SrhmicJGk
         Kww0yZFJaOKvpszwDtli+e8x6dcJP9gD7QbwRWvYI7B+9cFQfqeM3QJRCzJhXdknpQAf
         Vq6ThRdX46BGzSGzdMCqhm9kLn/h6RVzwRPdBgzc4LwUTq0pV3CI7hDrZe4Tmmspq/ZD
         QKpw==
X-Forwarded-Encrypted: i=1; AKwUvBwvGPPDb/n9VxAgYYglbfrXQW3paqlMqaf3S86FD7ZxFVR6yi82TorHqhdshPRP9A1m1xGGAoInHs9u@vger.kernel.org
X-Gm-Message-State: AFq9FYKlXzVNjo7igbpx5o+BnYTX8Uu3FV2s7zPQHgaIk8PhQxk12wFQ
	KlrtQ0UC7Mn/rlPPW+umH8/Bk7qmHLbndiJAac9lD6vdwicmpdFQIJkvHyxX+kl6Jv0=
X-Gm-Gg: AYBFou0McFg8TbEq2V/N4Ynb/bX6MtSFHdQ2qz+0bx5V/HF0sc1l3wN8+S0VZCNNUvw
	+a7SszYePlS070EenQ1FQO73BGNiwuuLj7Tvsx1jsKGN8WviB84JLbd8zV4thhHDUTD7pFcF/Fw
	aTdOUqP/Dy6R5Lx1cRFiG/9eScVFZ6d9zLbzf/sclziFDHgd32Q00nzMx25on3yQJSJmeV/DiCf
	O81nAI5ospMr0erPXM32aTrsj5Sd6XEatFQ1yt4afJFLp6+7DpEhkW+XUFz4Z5VeIVWtlv8fHdW
	fOo3jskjJnwd2s066NfPsr4WE5yUxq/H4v2Xw5Os6xpSYtrPCv6NYL0UvxXKE2GXETAnBRs5tp0
	VtGnTyzXnHXOyfSguSPMHBZcTb9rp5LaXaB5sBGhmdPGw1LXps7oH6OenSpJs7o3nPWHq4ykVK8
	90XbD4l9TK/k9AG0+t1mlEtNF9LcLRQYVfjvBckzIgEinz8c3nwOF/Cusd8dxcmvKGlRAW5+D0W
	Xf+qfcfnqc/4ivVhAMl2AULN7jThqOrV5yctwDMKBjmTDDL8/rCFKfSJnUSLqlSy1M7YptEBPah
	dppVXp9o8fvsrP/fM4act8/w+bwjC6+VKzgrfFe2coL1ud8tZcFQFQ3XlWcNlrMS
X-Received: by 2002:a05:6820:858a:20b0:6f4:5794:bf8c with SMTP id 006d021491bc7-714f290e6c8mr3860949eaf.17.1793629356802;
        Mon, 02 Nov 2026 06:22:36 -0800 (PST)
Received: from localhost ([2001:1970:3847:e000:1977:be2f:4a71:2892])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-714f2e500d0sm8367464eaf.10.2026.11.02.06.22.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 06:22:35 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 02 Nov 2026 09:22:31 -0500
Message-Id: <DMKSJGTLCYII.3IM8GY1R9M653@baylibre.com>
Cc: "Anirudh Srinivasan" <asrinivasan@oss.tenstorrent.com>, "Aurelien Jarno"
 <aurelien@aurel32.net>, "Jennifer Berringer" <jberring@redhat.com>,
 <linux-scsi@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-riscv@lists.infradead.org>, <spacemit@lists.linux.dev>,
 <linux-kernel@vger.kernel.org>, "linux-riscv"
 <linux-riscv-bounces@lists.infradead.org>
To: "Yixun Lan" <dlan@kernel.org>, "Alim Akhtar" <alim.akhtar@samsung.com>,
 "Avri Altman" <avri.altman@sandisk.com>, "Bart Van Assche"
 <bvanassche@acm.org>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Philipp
 Zabel" <p.zabel@pengutronix.de>, "Paul Walmsley" <pjw@kernel.org>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Alexandre Ghiti" <alex@ghiti.fr>, "Martin K. Petersen" <mkp@kernel.org>
From: "Trevor Gamblin" <tgamblin@baylibre.com>
Subject: Re: [PATCH v7 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
X-Mailer: aerc 0.22.0
References: <20261002-08-k3-ufs-support-v7-0-bb39007ff9ae@kernel.org>
 <20261002-08-k3-ufs-support-v7-2-bb39007ff9ae@kernel.org>
In-Reply-To: <20261002-08-k3-ufs-support-v7-2-bb39007ff9ae@kernel.org>

On Thu Oct 1, 2026 at 11:10 PM EDT, Yixun Lan wrote:
> SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
> which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
> M-PHY v3.0 standard.

Hi,

I've been testing this using a v7.3 kernel in Yocto's meta-riscv layer. It'=
s
been working well on a K3 Pico-ITX with fastboot flash in our nightly CI. A=
n
example:

https://forgejo.baylibre.com/tgamblin/boardgarden/actions/runs/827/jobs/9/a=
ttempt/1

Tested-by: Trevor Gamblin <tgamblin@baylibre.com>

> Tested-by: Aurelien Jarno <aurelien@aurel32.net>
> Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
> Signed-off-by: Yixun Lan <dlan@kernel.org>
> ---
>  drivers/ufs/host/Kconfig        |  12 +
>  drivers/ufs/host/Makefile       |   1 +
>  drivers/ufs/host/ufs-spacemit.c | 652 ++++++++++++++++++++++++++++++++++=
++++++
>  drivers/ufs/host/ufs-spacemit.h |  77 +++++
>  4 files changed, 742 insertions(+)
>
> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
> index ff170c0b6da0..6146872fcecc 100644
> --- a/drivers/ufs/host/Kconfig
> +++ b/drivers/ufs/host/Kconfig
> @@ -132,6 +132,18 @@ config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
>  	bool
>  	default y if SCSI_UFS_EXYNOS && SCSI_UFS_CRYPTO
> =20
> +config SCSI_UFS_SPACEMIT
> +	tristate "SpacemiT UFS controller driver"
> +	depends on SCSI_UFSHCD_PLATFORM && (ARCH_SPACEMIT || COMPILE_TEST)
> +	help
> +	  This selects the SpacemiT specific additions to UFSHCD platform drive=
r.
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
> @@ -13,6 +13,7 @@ obj-$(CONFIG_SCSI_UFS_HISI) +=3D ufs-hisi.o
>  obj-$(CONFIG_SCSI_UFS_MEDIATEK) +=3D ufs-mediatek.o
>  obj-$(CONFIG_SCSI_UFS_RENESAS) +=3D ufs-renesas.o
>  obj-$(CONFIG_SCSI_UFS_ROCKCHIP) +=3D ufs-rockchip.o
> +obj-$(CONFIG_SCSI_UFS_SPACEMIT) +=3D ufs-spacemit.o
>  obj-$(CONFIG_SCSI_UFS_SPRD) +=3D ufs-sprd.o
>  obj-$(CONFIG_SCSI_UFS_TI_J721E) +=3D ti-j721e-ufs.o
>  obj-$(CONFIG_SCSI_UFS_AMD_VERSAL2) +=3D ufs-amd-versal2.o ufshcd-dwc.o
> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
> index 000000000000..65aeba393b0f
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c
> @@ -0,0 +1,652 @@
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
> +/* Special analog register */
> +#define ANA_EQ_CTRL_REG_ATTR		0x00CD
> +#define ANA_HSGEAR_CTRL_ATTR		0x00C1
> +
> +#define UFS_AXI_CLK_LOW_FREQ_HZ		409600000UL
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
> +/* M-PHY FSM states */
> +#define MPHY_RX_FSM_STATE	0xC1
> +#define MPHY_TX_FSM_STATE	0x41
> +
> +static int ufs_spacemit_dme_set(struct ufs_hba *hba,
> +				const struct ufshcd_dme_attr_val *v, int n)
> +{
> +	int ret =3D 0;
> +	int attr_node =3D 0;
> +
> +	for (attr_node =3D 0; attr_node < n; attr_node++) {
> +		ret =3D ufshcd_dme_set(hba, v[attr_node].attr_sel,
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
> +	u32 tx_fsm_val_0 =3D 0;
> +	u32 tx_fsm_val_1 =3D 0;
> +	int retries =3D DIV_ROUND_UP(HBRN8_POLL_TOUT_MS * 1000, 100);
> +	int err =3D 0;
> +
> +	do {
> +		err =3D ufshcd_dme_get(hba,
> +				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
> +				     &tx_fsm_val_0);
> +		if (err)
> +			break;
> +
> +		err =3D ufshcd_dme_get(hba,
> +				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
> +						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)),
> +				     &tx_fsm_val_1);
> +		if (err || (tx_fsm_val_0 =3D=3D TX_FSM_HIBERN8 &&
> +			    tx_fsm_val_1 =3D=3D TX_FSM_HIBERN8))
> +			break;
> +
> +		usleep_range(100, 200);
> +	} while (--retries > 0);
> +
> +	if (err) {
> +		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
> +			__func__, err);
> +	} else if (tx_fsm_val_0 !=3D TX_FSM_HIBERN8 ||
> +		   tx_fsm_val_1 !=3D TX_FSM_HIBERN8) {
> +		err =3D -ETIMEDOUT;
> +		dev_err(hba->dev,
> +			"%s: invalid TX_FSM_STATE, lane0 =3D %u, lane1 =3D %u\n",
> +			__func__, tx_fsm_val_0, tx_fsm_val_1);
> +	}
> +
> +	return err;
> +}
> +
> +static u32 ufs_spacemit_get_sys1clk_1us(struct ufs_hba *hba)
> +{
> +	struct ufs_clk_info *clki, *clka =3D NULL;
> +	struct list_head *head =3D &hba->clk_list_head;
> +	unsigned long rate_hz =3D 0;
> +
> +	if (!list_empty(head)) {
> +		list_for_each_entry(clki, head, list) {
> +			if (clki->name && !strcmp(clki->name, "axi") && clki->clk) {
> +				clka =3D clki;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (clka && clka->clk)
> +		rate_hz =3D clk_get_rate(clka->clk);
> +
> +	if (!rate_hz)
> +		return 0;
> +
> +	return DIV_ROUND_CLOSEST(rate_hz, 1000000);
> +}
> +
> +static int ufs_spacemit_wait_mphy_pll_lock(struct ufs_hba *hba)
> +{
> +	u32 val;
> +	int err;
> +
> +	err =3D read_poll_timeout(ufshcd_readl, val, val & MPHY_PLL_LOCK_BIT,
> +				10, MPHY_PLL_LOCK_TIMEOUT_US, false, hba,
> +				UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +
> +	if (err)
> +		dev_err(hba->dev, "M-PHY PLL lock timeout\n");
> +
> +	return err;
> +}
> +
> +/**
> + * ufs_spacemit_mphy_init
> + * @hba: host controller instance
> + */
> +static int ufs_spacemit_mphy_init(struct ufs_hba *hba)
> +{
> +	int ret;
> +
> +	/* reset all mphy logical */
> +	ufshcd_writel(hba, 0x003, UFS_PHY_MNG_BASE + UFS_MPHY_RST_CTRL);
> +
> +	/* power up all */
> +	ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +
> +	/* asserted ana_rx_hb8_reset */
> +	ufshcd_writel(hba, 0xb7f, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +	fsleep(500);
> +
> +	/* deasserted ana_rx_hb8_reset */
> +	ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +
> +	/* Enable reference clock & deassert ufs device reset */
> +	ufshcd_writel(hba, MPHY_DEVICE_REFCLK_OE | MPHY_DEVICE_HW_RESET,
> +		      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> +
> +	fsleep(1000);
> +
> +	ret =3D ufs_spacemit_wait_mphy_pll_lock(hba);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(hba->dev, "M-PHY PLL locked successfully\n");
> +
> +	ufshcd_writel(hba, 0x1, UFS_PHY_MNG_BASE + UFS_MPHY_BKDR_CTRL);
> +
> +	ufshcd_writel(hba, 0x40, UFS_ATOP_BASE + (0xC2 << 2));
> +
> +	ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_BKDR_CTRL);
> +
> +	fsleep(2000);
> +
> +	dev_dbg(hba->dev, "M-PHY init completed\n");
> +
> +	return 0;
> +}
> +
> +static int ufs_spacemit_uniprov1p6_init(struct ufs_hba *hba)
> +{
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		{ UIC_ARG_MIB(PA_TXHSG1SYNCLENGTH), 0x4f },
> +		{ UIC_ARG_MIB(0x1553), 0xf }, /* PA_TXHSG1PREPARELENGTH */
> +		{ UIC_ARG_MIB(PA_TXHSG2SYNCLENGTH), 0x4f },
> +		{ UIC_ARG_MIB(0x1555), 0xf }, /* PA_TXHSG2PREPARELENGTH */
> +		{ UIC_ARG_MIB(PA_TXHSG3SYNCLENGTH), 0x4f },
> +		{ UIC_ARG_MIB(0x1557), 0xf }, /* PA_TXHSG3PREPARELENGTH */
> +		{ UIC_ARG_MIB(0x155A), 0x0 }, /* PA_TXMK2EXTENSION */
> +		{ UIC_ARG_MIB(0x155B), 0x1}, /* PA_PEERSCRAMBLING */
> +		{ UIC_ARG_MIB(0x155C), 0x1 }, /* PA_TXSKIP */
> +		{ UIC_ARG_MIB(0x155D), 250 }, /* PA_TXSKIPPERIOD */
> +		{ UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0x0 },
> +		{ UIC_ARG_MIB(0x155F), 0x0 }, /* PA_PEER_TX_LCC_ENABLE */
> +		{ UIC_ARG_MIB(0x1585), 0x1 }, /* PA_SCRAMBLING */
> +		{ UIC_ARG_MIB(PA_GRANULARITY), 0x1 },
> +		{ UIC_ARG_MIB(0x15AB), 0x0 }, /* PA_MK2EXTENSIONGUARDBAND */
> +		{ UIC_ARG_MIB(PA_STALLNOCONFIGTIME), 15 },
> +		{ UIC_ARG_MIB(0x15A8), 0x64 }, /* PA_TACTIVATE */
> +		{ UIC_ARG_MIB(0x1564), 0x64 },	/* PA_TXTRAILINGCLOCKS */
> +		{ UIC_ARG_MIB_SEL(0x008D, 4), 0x0B }, /* RX_LS_PREPARELEN_TIME RX0 */
> +		{ UIC_ARG_MIB_SEL(0x008D, 5), 0x0B }, /* RX_LS_PREPARELEN_TIME RX1 */
> +
> +		/* RX_HIBERNATE_BKEN RX0 */
> +		{ UIC_ARG_MIB_SEL(0x00F4, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x9F },
> +		/* RX_HIBERNATE_BKEN RX1 */
> +		{ UIC_ARG_MIB_SEL(0x00F4, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x9F },
> +		/* PWM_BURST_closure_length */
> +		{ UIC_ARG_MIB_SEL(0x008E, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)),   15 },
> +		{ UIC_ARG_MIB_SEL(0x008E, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)),   15 },
> +		/* min_stall_not_config_time */
> +		{ UIC_ARG_MIB_SEL(0x0088, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0xFF },
> +		{ UIC_ARG_MIB_SEL(0x0088, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0xFF },
> +		/* TX HB8_TIME CAP */
> +		{ UIC_ARG_MIB_SEL(0x000F, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x64 },
> +		{ UIC_ARG_MIB_SEL(0x000F, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)), 0x64 },
> +		/* RX HB8_TIME CAP */
> +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x64 },
> +		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x64 },
> +		/* TX EQ 3DB */
> +		{ UIC_ARG_MIB_SEL(0x00CD, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),  0x5 },
> +		/* RX garbage cnt =3D 32 SI */
> +		{ UIC_ARG_MIB_SEL(0x00F2, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x9F },
> +		{ UIC_ARG_MIB_SEL(0x00F2, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x9F },
> +	};
> +
> +	return ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> +}
> +
> +static void ufs_spacemit_set_dev_cap(struct ufs_host_params *host_params=
, u32 pwr_hs)
> +{
> +	if (!host_params)
> +		return;
> +
> +	memset(host_params, 0, sizeof(struct ufs_host_params));
> +	host_params->tx_lanes =3D UFS_SPACEMIT_K3_LIMIT_NUM_LANES_TX;
> +	host_params->rx_lanes =3D UFS_SPACEMIT_K3_LIMIT_NUM_LANES_RX;
> +	host_params->hs_rx_gear =3D UFS_SPACEMIT_K3_LIMIT_HSGEAR_RX;
> +	host_params->hs_tx_gear =3D UFS_SPACEMIT_K3_LIMIT_HSGEAR_TX;
> +	host_params->pwm_rx_gear =3D UFS_SPACEMIT_K3_LIMIT_PWMGEAR_RX;
> +	host_params->pwm_tx_gear =3D UFS_SPACEMIT_K3_LIMIT_PWMGEAR_TX;
> +	host_params->rx_pwr_pwm =3D UFS_SPACEMIT_K3_LIMIT_RX_PWR_PWM;
> +	host_params->tx_pwr_pwm =3D UFS_SPACEMIT_K3_LIMIT_TX_PWR_PWM;
> +	host_params->rx_pwr_hs =3D pwr_hs;
> +	host_params->tx_pwr_hs =3D pwr_hs;
> +	host_params->hs_rate =3D UFS_SPACEMIT_K3_LIMIT_HS_RATE;
> +	host_params->desired_working_mode =3D UFS_HS_MODE;
> +}
> +
> +static int ufs_spacemit_link_startup_pre_change(struct ufs_hba *hba)
> +{
> +	u32 value, sys1clk_1us;
> +	int err;
> +
> +	err =3D ufs_spacemit_mphy_init(hba);
> +	if (err < 0)
> +		return err;
> +
> +	err =3D ufs_spacemit_uniprov1p6_init(hba);
> +	if (err < 0)
> +		return err;
> +
> +	/* config sysclk and tx symbol clk before link startup */
> +	value =3D UFS_MAX_LINKSTARTUP_TIMER;
> +
> +	/* clear bit0~bit3, select b0 design */
> +	value &=3D ~0xf;
> +
> +	ufshcd_writel(hba, value, UFS_PA_LINK_STARTUP_TIMER);
> +
> +	sys1clk_1us =3D ufs_spacemit_get_sys1clk_1us(hba);
> +	if (!sys1clk_1us)
> +		sys1clk_1us =3D DIV_ROUND_CLOSEST(UFS_AXI_CLK_LOW_FREQ_HZ, 1000000);
> +	ufshcd_writel(hba, sys1clk_1us, UFS_SYS1CLK_1US);
> +	ufshcd_writel(hba, UFS_TX_SYMBO_CLK, UFS_TX_SYMBOL_CLK_NS_US);
> +
> +	dev_dbg(hba->dev, "REG_UFS_SYS1CLK_1US: 0x%x\n",
> +		ufshcd_readl(hba, UFS_SYS1CLK_1US));
> +	dev_dbg(hba->dev, "REG_UFS_TX_SYMBOL_CLK_NS_US: 0x%x\n",
> +		ufshcd_readl(hba, UFS_TX_SYMBOL_CLK_NS_US));
> +
> +	return 0;
> +}
> +
> +static int ufs_spacemit_link_startup_post_change(struct ufs_hba *hba)
> +{
> +	/* Add 0xe8 make UFS2.1 run GEAR3 + 2Lane@409M */
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x97 },
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0xd7 },
> +		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x17 },
> +		{ UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), UFS_DL_AFC0REQTIMEOUTVAL_MAX },
> +	};
> +
> +	return ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> +}
> +
> +static int ufs_spacemit_link_startup_notify(struct ufs_hba *hba,
> +					    enum ufs_notify_change_status status)
> +{
> +	int err =3D 0;
> +
> +	switch (status) {
> +	case PRE_CHANGE:
> +		err =3D ufs_spacemit_link_startup_pre_change(hba);
> +		break;
> +	case POST_CHANGE:
> +		err =3D ufs_spacemit_link_startup_post_change(hba);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return err;
> +}
> +
> +static int ufs_spacemit_negotiate_pwr_mode(struct ufs_hba *hba,
> +					   const struct ufs_pa_layer_attr *dev_max_params,
> +					   struct ufs_pa_layer_attr *dev_req_params)
> +{
> +	struct ufs_host_params host_params;
> +	int ret;
> +
> +	ufs_spacemit_set_dev_cap(&host_params, FAST_MODE);
> +	ret =3D ufshcd_negotiate_pwr_params(&host_params, dev_max_params,
> +					  dev_req_params);
> +	if (ret) {
> +		dev_err(hba->dev, "Failed to negotiate power params: %d\n", ret);
> +		return ret;
> +	}
> +
> +	dev_dbg(hba->dev,
> +		"Power mode config - gear_rx:%d, gear_tx:%d, lane_rx:%d, lane_tx:%d, p=
wr_rx:%d, pwr_tx:%d, hs_rate:%d\n",
> +		dev_req_params->gear_rx, dev_req_params->gear_tx, dev_req_params->lane=
_rx,
> +		dev_req_params->lane_tx, dev_req_params->pwr_rx, dev_req_params->pwr_t=
x,
> +		dev_req_params->hs_rate);
> +
> +	return ret;
> +}
> +
> +static int ufs_spacemit_pwr_change_notify(struct ufs_hba *hba,
> +					  enum ufs_notify_change_status status,
> +					  struct ufs_pa_layer_attr *dev_req_params)
> +{
> +	int ret =3D 0;
> +
> +	if (!dev_req_params) {
> +		dev_err(hba->dev, "Invalid Parameters\n");
> +		return -EINVAL;
> +	}
> +
> +	switch (status) {
> +	case PRE_CHANGE:
> +		break;
> +	case POST_CHANGE:
> +		ret =3D ufs_spacemit_wait_mphy_pll_lock(hba);
> +		if (ret < 0)
> +			return ret;
> +
> +		dev_dbg(hba->dev, "M-PHY PLL locked after power mode change\n");
> +		/* Set ANA_HSGEAR_CTRL_ATTR back to default value */
> +		ufshcd_dme_set(hba, UIC_ARG_MIB(ANA_HSGEAR_CTRL_ATTR), 0x00);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static int ufs_spacemit_quirk_host_pa_saveconfigtime(struct ufs_hba *hba=
)
> +{
> +	int err;
> +	u32 pa_vs_config_reg1;
> +
> +	err =3D ufshcd_dme_get(hba, UIC_ARG_MIB(UFS_PA_VS_CONFIG_REG1), &pa_vs_=
config_reg1);
> +	if (err)
> +		return err;
> +
> +	/* Allow extension of MSB bits of PA_SaveConfigTime attribute */
> +	return ufshcd_dme_set(hba, UIC_ARG_MIB(UFS_PA_VS_CONFIG_REG1),
> +			      (pa_vs_config_reg1 | (1 << 12)));
> +}
> +
> +static int ufs_spacemit_apply_dev_quirks(struct ufs_hba *hba)
> +{
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		/* LCC_DISABLE */
> +		{ UIC_ARG_MIB_SEL(TX_LCC_ENABLE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0 =
},
> +		{ UIC_ARG_MIB_SEL(TX_LCC_ENABLE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)), 0 =
},
> +		/* TX_Min_ActivateTime */
> +		{ UIC_ARG_MIB_SEL(TX_MIN_ACTIVATETIME, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0=
)), 0x0 },
> +		{ UIC_ARG_MIB_SEL(TX_MIN_ACTIVATETIME, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1=
)), 0x0 },
> +		{ UIC_ARG_MIB(ANA_HSGEAR_CTRL_ATTR), 0x25 },
> +	};
> +	int err;
> +
> +	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME) {
> +		err =3D ufs_spacemit_quirk_host_pa_saveconfigtime(hba);
> +		if (err < 0)
> +			return err;
> +	}
> +
> +	if (hba->dev_info.wmanufacturerid =3D=3D UFS_VENDOR_WDC)
> +		hba->dev_quirks |=3D UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE;
> +
> +	err =3D ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs))=
;
> +	if (err < 0)
> +		return err;
> +
> +	return ufs_spacemit_wait_mphy_pll_lock(hba);
> +}
> +
> +/**
> + * ufs_spacemit_advertise_quirks - advertise the known Spacemit UFS cont=
roller quirks
> + * @hba: host controller instance
> + *
> + * Spacemit UFS host controller might have some non standard behaviours =
(quirks)
> + * than what is specified by UFSHCI specification. Advertise all such
> + * quirks to standard UFS host controller driver so standard takes them =
into
> + * account.
> + */
> +static void ufs_spacemit_advertise_quirks(struct ufs_hba *hba)
> +{
> +	hba->quirks |=3D UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
> +}
> +
> +/**
> + * ufs_spacemit_init - init phy and prepare clk
> + * @hba: host controller instance
> + */
> +static int ufs_spacemit_init(struct ufs_hba *hba)
> +{
> +	struct device *dev =3D hba->dev;
> +	struct ufs_spacemit_host *host;
> +	struct reset_control *rst;
> +
> +	host =3D devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
> +	if (!host)
> +		return -ENOMEM;
> +
> +	rst =3D devm_reset_control_get_exclusive_deasserted(dev, NULL);
> +	if (IS_ERR(rst))
> +		return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset control\n=
");
> +
> +	host->hba =3D hba;
> +	ufshcd_set_variant(hba, host);
> +	ufs_spacemit_advertise_quirks(hba);
> +
> +	hba->caps |=3D UFSHCD_CAP_RPM_AUTOSUSPEND;
> +
> +	return 0;
> +}
> +
> +/**
> + * ufs_spacemit_device_reset - Toggle device reset line
> + * @hba: per-adapter instance
> + *
> + * Toggles the reset line to reset the attached UFS device.
> + *
> + * Returns: 0 on success
> + */
> +static int ufs_spacemit_device_reset(struct ufs_hba *hba)
> +{
> +	/* Disable reference clock & asserted ufs device reset */
> +	ufshcd_writel(hba, 0x000, UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> +	usleep_range(10, 15);
> +
> +	/* Enable reference clock & deassert ufs device reset */
> +	ufshcd_writel(hba, MPHY_DEVICE_REFCLK_OE | MPHY_DEVICE_HW_RESET,
> +		      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> +	usleep_range(10, 15);
> +
> +	return 0;
> +}
> +
> +/**
> + * ufs_spacemit_event_notify - Handle UFS error events
> + * @hba: host controller instance
> + * @evt: event type
> + * @data: event-specific data
> + *
> + * Handles error events from UFS core, print warning messages
> + */
> +static void ufs_spacemit_event_notify(struct ufs_hba *hba, enum ufs_even=
t_type evt, void *data)
> +{
> +	switch (evt) {
> +	case UFS_EVT_PA_ERR:
> +		if (data)
> +			dev_warn(hba->dev, "PA error event, INT errors:0x%x, PA_ERR_CODE:0x%x=
\n",
> +				 hba->errors, *(u32 *)data);
> +
> +		break;
> +	case UFS_EVT_DL_ERR:
> +		if (data)
> +			dev_warn(hba->dev, "DL error event, INT errors:0x%x, DL_ERR:0x%x\n",
> +				 hba->errors, *(u32 *)data);
> +
> +		break;
> +	case UFS_EVT_ABORT:
> +		dev_warn(hba->dev, "Abort event, INT errors:0x%x\n", hba->errors);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static void ufs_spacemit_pre_hibern8(struct ufs_hba *hba, enum uic_cmd_d=
me cmd)
> +{
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x84 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x84 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x85 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x85 },
> +	};
> +	int ret;
> +
> +	if (cmd =3D=3D UIC_CMD_DME_HIBER_EXIT) {
> +		/* Enable reference clock & deassert ufs device reset */
> +		ufshcd_writel(hba, MPHY_DEVICE_REFCLK_OE | MPHY_DEVICE_HW_RESET,
> +			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> +
> +		/* Power up all */
> +		ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +
> +		/* Assert ana_rx_hb8_reset */
> +		ufshcd_writel(hba, MPHY_PU_WITH_HB8_RESET,
> +			      UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +		fsleep(500);
> +
> +		/* Deassert ana_rx_hb8_reset */
> +		ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +
> +		ret =3D ufs_spacemit_wait_mphy_pll_lock(hba);
> +		if (ret < 0)
> +			return;
> +
> +		ufshcd_dme_set(hba, UIC_ARG_MIB(0xdd), 0x57);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB(0xe8), 0x57);
> +	}
> +
> +	if (cmd =3D=3D UIC_CMD_DME_HIBER_ENTER)
> +		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> +}
> +
> +static void ufs_spacemit_post_hibern8(struct ufs_hba *hba, enum uic_cmd_=
dme cmd)
> +{
> +	static const struct ufshcd_dme_attr_val setup_attrs[] =3D {
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x84 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x84 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x80 },
> +		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x80 },
> +		{ UIC_ARG_MIB(0xdd), 0x57 },
> +		{ UIC_ARG_MIB(0xdd), 0xd7 },
> +		{ UIC_ARG_MIB(0xe8), 0x57 },
> +		{ UIC_ARG_MIB(0xe8), 0xd7 },
> +	};
> +	int err;
> +
> +	if (cmd =3D=3D UIC_CMD_DME_HIBER_ENTER) {
> +		err =3D ufs_spacemit_check_hibern8(hba);
> +		if (err)
> +			dev_err(hba->dev, "ufs_spacemit_check_hibern8 error\n");
> +
> +		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
> +
> +		/* Power down M-PHY */
> +		ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
> +
> +		/* Disable reference clock, keep device reset deasserted */
> +		ufshcd_writel(hba, MPHY_DEVICE_HW_RESET,
> +			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
> +	}
> +}
> +
> +/**
> + * ufs_spacemit_hibern8_notify - Handle hibernate enter/exit
> + * @hba: host controller instance
> + * @cmd: UIC command (HIBER_ENTER or HIBER_EXIT)
> + * @status: notification status
> + *
> + * Manages M-PHY power state during hibernate transitions.
> + */
> +static void ufs_spacemit_hibern8_notify(struct ufs_hba *hba, enum uic_cm=
d_dme cmd,
> +					enum ufs_notify_change_status status)
> +{
> +	if (status =3D=3D PRE_CHANGE)
> +		ufs_spacemit_pre_hibern8(hba, cmd);
> +
> +	if (status =3D=3D POST_CHANGE)
> +		ufs_spacemit_post_hibern8(hba, cmd);
> +}
> +
> +/**
> + * struct ufs_hba_spacemit_vops - UFS Spacemit specific variant operatio=
ns
> + *
> + * The variant operations configure the necessary controller and PHY
> + * handshake during initialization.
> + */
> +static const struct ufs_hba_variant_ops ufs_hba_spacemit_vops =3D {
> +	.name =3D "ufshcd-spacemit",
> +	.init =3D ufs_spacemit_init,
> +	.link_startup_notify =3D ufs_spacemit_link_startup_notify,
> +	.negotiate_pwr_mode =3D ufs_spacemit_negotiate_pwr_mode,
> +	.pwr_change_notify =3D ufs_spacemit_pwr_change_notify,
> +	.device_reset =3D ufs_spacemit_device_reset,
> +	.event_notify =3D ufs_spacemit_event_notify,
> +	.apply_dev_quirks =3D ufs_spacemit_apply_dev_quirks,
> +	.hibern8_notify =3D ufs_spacemit_hibern8_notify,
> +};
> +
> +static const struct of_device_id __maybe_unused ufs_spacemit_of_match[] =
=3D {
> +	{ .compatible =3D "spacemit,k3-ufshc" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, ufs_spacemit_of_match);
> +
> +static int ufs_spacemit_probe(struct platform_device *pdev)
> +{
> +	return ufshcd_pltfrm_init(pdev, &ufs_hba_spacemit_vops);
> +}
> +
> +static void ufs_spacemit_remove(struct platform_device *pdev)
> +{
> +	ufshcd_pltfrm_remove(pdev);
> +}
> +
> +static const struct dev_pm_ops ufs_spacemit_pm_ops =3D {
> +	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
> +	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
> +	.prepare	 =3D ufshcd_suspend_prepare,
> +	.complete	 =3D ufshcd_resume_complete,
> +};
> +
> +static struct platform_driver ufs_spacemit_pltform =3D {
> +	.probe	=3D ufs_spacemit_probe,
> +	.remove	=3D ufs_spacemit_remove,
> +	.driver	=3D {
> +		.name	=3D "ufshcd-spacemit",
> +		.of_match_table =3D of_match_ptr(ufs_spacemit_of_match),
> +		.pm	=3D &ufs_spacemit_pm_ops,
> +	},
> +};
> +module_platform_driver(ufs_spacemit_pltform);
> +
> +MODULE_DESCRIPTION("SpacemiT UFS Host Driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/ufs/host/ufs-spacemit.h b/drivers/ufs/host/ufs-space=
mit.h
> new file mode 100644
> index 000000000000..1415db85edd5
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.h
> @@ -0,0 +1,77 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * SpacemiT UFS Host Controller driver
> + *
> + * Copyright (c) 2026 SpacemiT (Hangzhou) Technology Co. Ltd
> + */
> +
> +#ifndef _UFS_SPACEMIT_H_
> +#define _UFS_SPACEMIT_H_
> +
> +#include <linux/regulator/consumer.h>
> +#include <linux/pm_qos.h>
> +#include <linux/workqueue.h>
> +
> +/* Spacemit K3 UFS host controller vendor specific registers */
> +#define UFS_SYS1CLK_1US			0xC0
> +#define UFS_TX_SYMBOL_CLK_NS_US		0xC4
> +#define UFS_LOCAL_PORT_ID_REG		0xC8
> +#define UFS_PA_ERR_CODE			0xCC
> +#define UFS_RETRY_TIMER_REG		0xD0
> +#define UFS_PA_LINK_STARTUP_TIMER	0xD8
> +#define UFS_CFG1			0xDC
> +
> +/* MPHY control registers */
> +#define UFS_PHY_MNG_BASE		0x1B00
> +#define UFS_MPHY_RST_CTRL		0x0
> +#define UFS_MPHY_PU_CTRL		0x4
> +#define UFS_MPHY_BKDR_CTRL		0x8
> +#define UFS_DEVICE_IO_CTRL		0xC
> +
> +/* ATOP base*/
> +#define UFS_ATOP_BASE			0x1C00
> +
> +#define UFS_TX_SYMBO_CLK		0x800
> +#define UFS_MAX_LINKSTARTUP_TIMER	0xFFFFFFFF
> +#define UFS_DL_AFC0REQTIMEOUTVAL_MAX	0xFFFF
> +
> +#define MPHY_TX_FSM_STATE		0x41
> +#define TX_FSM_HIBERN8			0x1
> +#define HBRN8_POLL_TOUT_MS		100
> +#define DEFAULT_CLK_RATE_HZ		1000000
> +#define BUS_VECTOR_NAME_LEN		32
> +
> +#define UFS_HW_VER_MAJOR_SHFT		28
> +#define UFS_HW_VER_MAJOR_MASK		(0x000F << UFS_HW_VER_MAJOR_SHFT)
> +#define UFS_HW_VER_MINOR_SHFT		16
> +#define UFS_HW_VER_MINOR_MASK		(0x0FFF << UFS_HW_VER_MINOR_SHFT)
> +#define UFS_HW_VER_STEP_SHFT		0
> +#define UFS_HW_VER_STEP_MASK		(0xFFFF << UFS_HW_VER_STEP_SHFT)
> +
> +#define UFS_SPACEMIT_K3_LIMIT_NUM_LANES_RX	2
> +#define UFS_SPACEMIT_K3_LIMIT_NUM_LANES_TX	2
> +#define UFS_SPACEMIT_K3_LIMIT_HSGEAR_RX		UFS_HS_G3
> +#define UFS_SPACEMIT_K3_LIMIT_HSGEAR_TX		UFS_HS_G3
> +#define UFS_SPACEMIT_K3_LIMIT_PWMGEAR_RX	UFS_PWM_G4
> +#define UFS_SPACEMIT_K3_LIMIT_PWMGEAR_TX	UFS_PWM_G4
> +#define UFS_SPACEMIT_K3_LIMIT_RX_PWR_PWM	SLOW_MODE
> +#define UFS_SPACEMIT_K3_LIMIT_TX_PWR_PWM	SLOW_MODE
> +#define UFS_SPACEMIT_K3_LIMIT_RX_PWR_HS		FAST_MODE
> +#define UFS_SPACEMIT_K3_LIMIT_TX_PWR_HS		FAST_MODE
> +#define UFS_SPACEMIT_K3_LIMIT_HS_RATE		PA_HS_MODE_B
> +#define UFS_SPACEMIT_K3_LIMIT_DESIRED_MODE	2
> +
> +#define UFS_PA_VS_CONFIG_REG1			0x9000
> +#define UFS_DME_VS_CORE_CLK_CTRL		0xD002
> +
> +#define UFS_HCLKDIV_REG 0xFC
> +
> +struct ufs_spacemit_host {
> +	struct ufs_hba *hba;
> +};
> +
> +struct ufshcd_dme_attr_val {
> +	u32 attr_sel;
> +	u32 mib_val;
> +};
> +#endif /* _UFS_SPACEMIT_H_ */


