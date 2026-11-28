Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795827020;
	b=jcukAv76KBDgbblGM0QrX9QSvuAsiSxxQkVhxOpWEy07Tv0W4HFh4WrPX2A5BZTHn9d0
	 vJIqswIdc93eQ7mPOtRUGR1UgSmBeDpAi67zEM/HlXAouJi2iBN+Qy1/SLMaSojEJtE7e
	 0Y9UF1tO7yrQOrm4c0RY9hBzpKa8B90EqhIJMcu09nwojkrdXcYv+d3ok7eVFk3HqMPch
	 HvC2RRfE9dMsAF45IGITodYJmdei8WxZK8KXCKReldm2HPw3fSTQiR8AtovOZz1zVWygw
	 OMyTUYK7OQD6bpr5XyxWzwZZxk9cyA96SrLwVBYuck/bEvxkH2gl2lKWb3J9zGbOAvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795827020;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=SD72Bw/UiaB/37pJFefASFr8Y/os2trRieTTXu+q3Qk=;
	b=McIuUDztFJKHz5WplwG8+ii+SGOydRd7+8G/vtMDkica5CGqOUUEglxu36BIv03ihdJB
	 64scm3cf2hqTkJsT7AK8svgCJ6WQp0Eie5NUxeR6Jt9OWtw0qUpZWD7s6OBd/nIZocsFQ
	 e0CfVpAwjA1025tP2EcF1VwAv/I7wsDZKo8qNW0rxlApYB6zc3mgEIkKldlM/OOK/mpQT
	 9DK/NhmxbGtJR+0debQfTgr+GEuBmrZkYiYBoJy2KNyu6XcV8YsVLVGUyW6P99XM2dJ/2
	 KUlyYD3Q44Fzq0xx2Fiv1LXS9PqNEv9F3jnjL75Xu8IC6MXG2rq36nP6Uz/ENqU2D8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MpVrJQMF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC89606A31E;
	Sat, 28 Nov 2026 00:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MpVrJQMF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C281F00893;
	Sat, 28 Nov 2026 00:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795827020;
	bh=SD72Bw/UiaB/37pJFefASFr8Y/os2trRieTTXu+q3Qk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MpVrJQMFqjLzpUs2KbHC0E4616qqAWFl3iQETO3EftQrUHHRT+KRS6Llp6mAJlL3e
	 q31R2eeptq6OS8Xx5X6WX1aHfr70Lbbf9y+8B2oAaGnEvPFM/cMQ7iQgnQGDFAFx4d
	 AySlYaLtQb687JFYNdwxvdG1K/p7RaTbMBWq0vTjvhFaSO7nqQ0124sg/ufstVAWNC
	 LYG1rt/Qa5z/EKOL39NHGNMeGHP2dwUQpLapPAAqhx2LC3e+7HURdfbiR8bgyhJrnJ
	 /UMooPkhqrFhywKf0clR0XZieokci6u0he4/0Uygg3aUOVJn+/pYWw4IvWJfymD0nZ
	 PyEVeT4huifAg==
From: Yixun Lan <dlan@kernel.org>
Date: Sat, 28 Nov 2026 00:49:52 +0000
Subject: [PATCH v9 2/2] scsi: ufs: spacemit: k3: Add UFS Host Controller
 driver
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261128-08-k3-ufs-support-v9-2-d27deb096d1e@kernel.org>
References: <20261128-08-k3-ufs-support-v9-0-d27deb096d1e@kernel.org>
In-Reply-To: <20261128-08-k3-ufs-support-v9-0-d27deb096d1e@kernel.org>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Cc: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>, 
 Aurelien Jarno <aurelien@aurel32.net>, 
 Jennifer Berringer <jberring@redhat.com>, 
 Trevor Gamblin <tgamblin@baylibre.com>, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-riscv@lists.infradead.org, 
 spacemit@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Yixun Lan <dlan@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=23969; i=dlan@kernel.org;
 h=from:subject:message-id; bh=cVepAx2bTczN6GHXRYGAtupP5+S6GAiEcdGBwnUba7k=;
 b=owEB6QIW/ZANAwAKATGq6kdZTbvtAcsmYgBrCiU3zqzATPSCbneF1KJsf+z1ZxHe06e4aDgOl
 e/uBUdSW0iJAq8EAAEKAJkWIQS1urjJwxtxFWcCI9wxqupHWU277QUCawolNxsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDJfFIAAAAAALgAoaXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5
 maWZ0aGhvcnNlbWFuLm5ldEI1QkFCOEM5QzMxQjcxMTU2NzAyMjNEQzMxQUFFQTQ3NTk0REJCRU
 QACgkQMarqR1lNu+3aqQ/9HGPW7fyQLFR5HG27VxwgASadwVShadZsLHqgGvL/GLT9q/p6g9I+T
 W8IYV0wz+6afPM7TOfo3xaqMPGXSJOa4NGm28Vv34XLMdUlLhsS9Y3modOQtRHjaskLDcXsvxfn
 5+MF3QKyfhtBxje6nSPu14BconyjPsqfTBmPvoDL9VBu4BS1GDMPNJv9MmtQjYtO8SGotl1ajbX
 w7D5hV3RhYCj91ldnHdNguscrlgf5dmKe3M6lVEryVQ58iJHw9VWDJ4F7X1HLT1fwOiCs4Kb7XD
 lFFCiy0UtJc4K3lCjTyZVD/tovlqRtAGY/kZIvXaP+20+/FTdvM2B/hdvOEvdo9vXkoW0Qso6xQ
 QHLSNLoCCGcQkHMvuZmOldWYnS7CUkRvIPcl709lxYJ5XWzO4/c5rtPGAhEoQsVZ+5mwj+1fCES
 rIwU3mqxM8o5DFkRbuHrYCnV6SCeqq6vReE1hyCkvJUXq2IE8CirK0KhR8LFfawRzwKMtfyjpnM
 LqH7+TjxZ2G/OqlElcPsgw+KMfaionb8FSeOsHoNdqfil0iUOpGvCOiE1Xi90A0+59Y/sMRBqgq
 UI+ndEGdezXxKQu7s1N03sO5SHMO3Z7ss/ByzSZi33wbz9ITAhxTc7WAVIDhJL8PQkHrP3gFMOr
 fnWhVDPS027xoLJYIpX4IBpdS5gQVo=
X-Developer-Key: i=dlan@kernel.org; a=openpgp;
 fpr=50B03A1A5CBCD33576EF8CD7920C0DBCAABEFD55

SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
M-PHY v3.0 standard.

Tested-by: Aurelien Jarno <aurelien@aurel32.net>
Tested-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Tested-by: Trevor Gamblin <tgamblin@baylibre.com>
Tested-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Yixun Lan <dlan@kernel.org>
---
 drivers/ufs/host/Kconfig        |  12 +
 drivers/ufs/host/Makefile       |   1 +
 drivers/ufs/host/ufs-spacemit.c | 619 ++++++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-spacemit.h |  81 ++++++
 4 files changed, 713 insertions(+)

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index ff170c0b6da0..6146872fcecc 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -132,6 +132,18 @@ config SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
 	bool
 	default y if SCSI_UFS_EXYNOS && SCSI_UFS_CRYPTO
 
+config SCSI_UFS_SPACEMIT
+	tristate "SpacemiT UFS controller driver"
+	depends on SCSI_UFSHCD_PLATFORM && (ARCH_SPACEMIT || COMPILE_TEST)
+	help
+	  This selects the SpacemiT specific additions to UFSHCD platform driver.
+	  UFS host on SpacemiT needs some vendor specific configuration before
+	  accessing the hardware which includes PHY configuration and vendor
+	  specific registers.
+
+	  Select this if you have UFS controller on SpacemiT chipset.
+	  If unsure, say N.
+
 config SCSI_UFS_SPRD
 	tristate "Unisoc specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && (ARCH_SPRD || COMPILE_TEST)
diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
index 7d8db67eb23c..a3c447b8fc21 100644
--- a/drivers/ufs/host/Makefile
+++ b/drivers/ufs/host/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_SCSI_UFS_HISI) += ufs-hisi.o
 obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
 obj-$(CONFIG_SCSI_UFS_RENESAS) += ufs-renesas.o
 obj-$(CONFIG_SCSI_UFS_ROCKCHIP) += ufs-rockchip.o
+obj-$(CONFIG_SCSI_UFS_SPACEMIT) += ufs-spacemit.o
 obj-$(CONFIG_SCSI_UFS_SPRD) += ufs-sprd.o
 obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
 obj-$(CONFIG_SCSI_UFS_AMD_VERSAL2) += ufs-amd-versal2.o ufshcd-dwc.o
diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-spacemit.c
new file mode 100644
index 000000000000..8024b2c1f438
--- /dev/null
+++ b/drivers/ufs/host/ufs-spacemit.c
@@ -0,0 +1,619 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2026 SpacemiT (Hangzhou) Technology Co. Ltd
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/iopoll.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+#include <linux/slab.h>
+
+#include <ufs/ufshcd.h>
+#include <ufs/ufshci.h>
+#include <ufs/ufs_quirks.h>
+#include <ufs/unipro.h>
+
+#include "ufshcd-pltfrm.h"
+#include "ufs-spacemit.h"
+
+static int ufs_spacemit_dme_set(struct ufs_hba *hba,
+				const struct ufshcd_dme_attr_val *v, int n)
+{
+	int ret = 0;
+	int attr_node = 0;
+
+	for (attr_node = 0; attr_node < n; attr_node++) {
+		ret = ufshcd_dme_set(hba, v[attr_node].attr_sel,
+				     v[attr_node].mib_val);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int ufs_spacemit_check_hibern8(struct ufs_hba *hba)
+{
+	u32 tx_fsm_val_0 = 0;
+	u32 tx_fsm_val_1 = 0;
+	int retries = DIV_ROUND_UP(HBRN8_POLL_TOUT_MS * 1000, 100);
+	int err = 0;
+
+	do {
+		err = ufshcd_dme_get(hba,
+				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),
+				     &tx_fsm_val_0);
+		if (err)
+			break;
+
+		err = ufshcd_dme_get(hba,
+				     UIC_ARG_MIB_SEL(MPHY_TX_FSM_STATE,
+						     UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)),
+				     &tx_fsm_val_1);
+		if (err || (tx_fsm_val_0 == TX_FSM_HIBERN8 &&
+			    tx_fsm_val_1 == TX_FSM_HIBERN8))
+			break;
+
+		usleep_range(100, 200);
+	} while (--retries > 0);
+
+	if (err) {
+		dev_err(hba->dev, "%s: unable to get TX_FSM_STATE, err %d\n",
+			__func__, err);
+	} else if (tx_fsm_val_0 != TX_FSM_HIBERN8 ||
+		   tx_fsm_val_1 != TX_FSM_HIBERN8) {
+		err = -ETIMEDOUT;
+		dev_err(hba->dev,
+			"%s: invalid TX_FSM_STATE, lane0 = %u, lane1 = %u\n",
+			__func__, tx_fsm_val_0, tx_fsm_val_1);
+	}
+
+	return err;
+}
+
+static u32 ufs_spacemit_get_sys1clk_1us(struct ufs_hba *hba)
+{
+	struct ufs_clk_info *clki, *clka = NULL;
+	struct list_head *head = &hba->clk_list_head;
+	unsigned long rate_hz = 0;
+
+	if (list_empty(head))
+		return 0;
+
+	list_for_each_entry(clki, head, list) {
+		if (clki->name && !strcmp(clki->name, "axi") && clki->clk) {
+			clka = clki;
+			break;
+		}
+	}
+
+	if (clka && clka->clk)
+		rate_hz = clk_get_rate(clka->clk);
+
+	if (!rate_hz)
+		return 0;
+
+	return DIV_ROUND_CLOSEST(rate_hz, 1000000);
+}
+
+static int ufs_spacemit_wait_mphy_pll_lock(struct ufs_hba *hba)
+{
+	u32 val;
+	int err;
+
+	err = read_poll_timeout(ufshcd_readl, val, val & MPHY_PLL_LOCK_BIT,
+				10, MPHY_PLL_LOCK_TIMEOUT_US, false, hba,
+				UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
+
+	if (err)
+		dev_err(hba->dev, "M-PHY PLL lock timeout\n");
+
+	return err;
+}
+
+/**
+ * ufs_spacemit_mphy_init
+ * @hba: host controller instance
+ */
+static int ufs_spacemit_mphy_init(struct ufs_hba *hba)
+{
+	int ret;
+
+	/* reset all mphy logical */
+	ufshcd_writel(hba, 0x003, UFS_PHY_MNG_BASE + UFS_MPHY_RST_CTRL);
+
+	/* power up all */
+	ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
+
+	/* asserted ana_rx_hb8_reset */
+	ufshcd_writel(hba, MPHY_PU_WITH_HB8_RESET,
+		      UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
+	fsleep(500);
+
+	/* deasserted ana_rx_hb8_reset */
+	ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
+
+	/* Enable reference clock & deassert ufs device reset */
+	ufshcd_writel(hba, MPHY_DEVICE_REFCLK_OE | MPHY_DEVICE_HW_RESET,
+		      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
+
+	fsleep(1000);
+
+	ret = ufs_spacemit_wait_mphy_pll_lock(hba);
+	if (ret < 0)
+		return ret;
+
+	dev_dbg(hba->dev, "M-PHY PLL locked successfully\n");
+
+	ufshcd_writel(hba, 0x1, UFS_PHY_MNG_BASE + UFS_MPHY_BKDR_CTRL);
+
+	ufshcd_writel(hba, 0x40, UFS_ATOP_BASE + (0xC2 << 2));
+
+	ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_BKDR_CTRL);
+
+	fsleep(2000);
+
+	dev_dbg(hba->dev, "M-PHY init completed\n");
+
+	return 0;
+}
+
+static int ufs_spacemit_uniprov1p6_init(struct ufs_hba *hba)
+{
+	static const struct ufshcd_dme_attr_val setup_attrs[] = {
+		{ UIC_ARG_MIB(PA_TXHSG1SYNCLENGTH), 0x4f },
+		{ UIC_ARG_MIB(0x1553), 0xf }, /* PA_TXHSG1PREPARELENGTH */
+		{ UIC_ARG_MIB(PA_TXHSG2SYNCLENGTH), 0x4f },
+		{ UIC_ARG_MIB(0x1555), 0xf }, /* PA_TXHSG2PREPARELENGTH */
+		{ UIC_ARG_MIB(PA_TXHSG3SYNCLENGTH), 0x4f },
+		{ UIC_ARG_MIB(0x1557), 0xf }, /* PA_TXHSG3PREPARELENGTH */
+		{ UIC_ARG_MIB(0x155A), 0x0 }, /* PA_TXMK2EXTENSION */
+		{ UIC_ARG_MIB(0x155B), 0x1}, /* PA_PEERSCRAMBLING */
+		{ UIC_ARG_MIB(0x155C), 0x1 }, /* PA_TXSKIP */
+		{ UIC_ARG_MIB(0x155D), 250 }, /* PA_TXSKIPPERIOD */
+		{ UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0x0 },
+		{ UIC_ARG_MIB(0x155F), 0x0 }, /* PA_PEER_TX_LCC_ENABLE */
+		{ UIC_ARG_MIB(0x1585), 0x1 }, /* PA_SCRAMBLING */
+		{ UIC_ARG_MIB(PA_GRANULARITY), 0x1 },
+		{ UIC_ARG_MIB(0x15AB), 0x0 }, /* PA_MK2EXTENSIONGUARDBAND */
+		{ UIC_ARG_MIB(PA_STALLNOCONFIGTIME), 15 },
+		{ UIC_ARG_MIB(0x15A8), 0x64 }, /* PA_TACTIVATE */
+		{ UIC_ARG_MIB(0x1564), 0x64 },	/* PA_TXTRAILINGCLOCKS */
+		{ UIC_ARG_MIB_SEL(0x008D, 4), 0x0B }, /* RX_LS_PREPARELEN_TIME RX0 */
+		{ UIC_ARG_MIB_SEL(0x008D, 5), 0x0B }, /* RX_LS_PREPARELEN_TIME RX1 */
+
+		/* RX_HIBERNATE_BKEN RX0 */
+		{ UIC_ARG_MIB_SEL(0x00F4, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x9F },
+		/* RX_HIBERNATE_BKEN RX1 */
+		{ UIC_ARG_MIB_SEL(0x00F4, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x9F },
+		/* PWM_BURST_closure_length */
+		{ UIC_ARG_MIB_SEL(0x008E, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)),   15 },
+		{ UIC_ARG_MIB_SEL(0x008E, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)),   15 },
+		/* min_stall_not_config_time */
+		{ UIC_ARG_MIB_SEL(0x0088, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0xFF },
+		{ UIC_ARG_MIB_SEL(0x0088, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0xFF },
+		/* TX HB8_TIME CAP */
+		{ UIC_ARG_MIB_SEL(0x000F, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x64 },
+		{ UIC_ARG_MIB_SEL(0x000F, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)), 0x64 },
+		/* RX HB8_TIME CAP */
+		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x64 },
+		{ UIC_ARG_MIB_SEL(0x0092, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x64 },
+		/* TX EQ 3DB */
+		{ UIC_ARG_MIB_SEL(0x00CD, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)),  0x5 },
+		/* RX garbage cnt = 32 SI */
+		{ UIC_ARG_MIB_SEL(0x00F2, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x9F },
+		{ UIC_ARG_MIB_SEL(0x00F2, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x9F },
+	};
+
+	return ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
+}
+
+static int ufs_spacemit_link_startup_pre_change(struct ufs_hba *hba)
+{
+	u32 value, sys1clk_1us;
+	int err;
+
+	err = ufs_spacemit_mphy_init(hba);
+	if (err < 0)
+		return err;
+
+	err = ufs_spacemit_uniprov1p6_init(hba);
+	if (err < 0)
+		return err;
+
+	/* config sysclk and tx symbol clk before link startup */
+	value = UFS_MAX_LINKSTARTUP_TIMER;
+
+	/* clear bit0~bit3, select b0 design */
+	value &= ~0xf;
+
+	ufshcd_writel(hba, value, UFS_PA_LINK_STARTUP_TIMER);
+
+	sys1clk_1us = ufs_spacemit_get_sys1clk_1us(hba);
+	if (!sys1clk_1us)
+		sys1clk_1us = DIV_ROUND_CLOSEST(UFS_AXI_CLK_LOW_FREQ_HZ, 1000000);
+	ufshcd_writel(hba, sys1clk_1us, UFS_SYS1CLK_1US);
+	ufshcd_writel(hba, UFS_TX_SYMBO_CLK, UFS_TX_SYMBOL_CLK_NS_US);
+
+	dev_dbg(hba->dev, "REG_UFS_SYS1CLK_1US: 0x%x\n",
+		ufshcd_readl(hba, UFS_SYS1CLK_1US));
+	dev_dbg(hba->dev, "REG_UFS_TX_SYMBOL_CLK_NS_US: 0x%x\n",
+		ufshcd_readl(hba, UFS_TX_SYMBOL_CLK_NS_US));
+
+	return 0;
+}
+
+static int ufs_spacemit_link_startup_post_change(struct ufs_hba *hba)
+{
+	/* Add 0xe8 make UFS2.1 run GEAR3 + 2Lane@409M */
+	static const struct ufshcd_dme_attr_val setup_attrs[] = {
+		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x97 },
+		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0xd7 },
+		{ UIC_ARG_MIB_SEL(0xe8, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x17 },
+		{ UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), UFS_DL_AFC0REQTIMEOUTVAL_MAX },
+	};
+
+	return ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
+}
+
+static int ufs_spacemit_link_startup_notify(struct ufs_hba *hba,
+					    enum ufs_notify_change_status status)
+{
+	int err = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		err = ufs_spacemit_link_startup_pre_change(hba);
+		break;
+	case POST_CHANGE:
+		err = ufs_spacemit_link_startup_post_change(hba);
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static int ufs_spacemit_negotiate_pwr_mode(struct ufs_hba *hba,
+					   const struct ufs_pa_layer_attr *dev_max_params,
+					   struct ufs_pa_layer_attr *dev_req_params)
+{
+	struct ufs_host_params host_params;
+	int ret;
+
+	ufshcd_init_host_params(&host_params);
+	ret = ufshcd_negotiate_pwr_params(&host_params, dev_max_params,
+					  dev_req_params);
+	if (ret) {
+		dev_err(hba->dev, "Failed to negotiate power params: %d\n", ret);
+		return ret;
+	}
+
+	dev_dbg(hba->dev,
+		"Power mode config - gear_rx:%d, gear_tx:%d, lane_rx:%d, lane_tx:%d, pwr_rx:%d, pwr_tx:%d, hs_rate:%d\n",
+		dev_req_params->gear_rx, dev_req_params->gear_tx, dev_req_params->lane_rx,
+		dev_req_params->lane_tx, dev_req_params->pwr_rx, dev_req_params->pwr_tx,
+		dev_req_params->hs_rate);
+
+	return ret;
+}
+
+static int ufs_spacemit_pwr_change_notify(struct ufs_hba *hba,
+					  enum ufs_notify_change_status status,
+					  struct ufs_pa_layer_attr *dev_req_params)
+{
+	int ret = 0;
+
+	if (!dev_req_params) {
+		dev_err(hba->dev, "Invalid Parameters\n");
+		return -EINVAL;
+	}
+
+	switch (status) {
+	case PRE_CHANGE:
+		break;
+	case POST_CHANGE:
+		ret = ufs_spacemit_wait_mphy_pll_lock(hba);
+		if (ret < 0)
+			return ret;
+
+		dev_dbg(hba->dev, "M-PHY PLL locked after power mode change\n");
+		/* Set ANA_HSGEAR_CTRL_ATTR back to default value */
+		ufshcd_dme_set(hba, UIC_ARG_MIB(ANA_HSGEAR_CTRL_ATTR), 0x00);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+static int ufs_spacemit_quirk_host_pa_saveconfigtime(struct ufs_hba *hba)
+{
+	int err;
+	u32 pa_vs_config_reg1;
+
+	err = ufshcd_dme_get(hba, UIC_ARG_MIB(UFS_PA_VS_CONFIG_REG1), &pa_vs_config_reg1);
+	if (err)
+		return err;
+
+	/* Allow extension of MSB bits of PA_SaveConfigTime attribute */
+	return ufshcd_dme_set(hba, UIC_ARG_MIB(UFS_PA_VS_CONFIG_REG1),
+			      (pa_vs_config_reg1 | (1 << 12)));
+}
+
+static int ufs_spacemit_apply_dev_quirks(struct ufs_hba *hba)
+{
+	static const struct ufshcd_dme_attr_val setup_attrs[] = {
+		/* LCC_DISABLE */
+		{ UIC_ARG_MIB_SEL(TX_LCC_ENABLE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0 },
+		{ UIC_ARG_MIB_SEL(TX_LCC_ENABLE, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)), 0 },
+		/* TX_Min_ActivateTime */
+		{ UIC_ARG_MIB_SEL(TX_MIN_ACTIVATETIME, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(0)), 0x0 },
+		{ UIC_ARG_MIB_SEL(TX_MIN_ACTIVATETIME, UIC_ARG_MPHY_TX_GEN_SEL_INDEX(1)), 0x0 },
+		{ UIC_ARG_MIB(ANA_HSGEAR_CTRL_ATTR), 0x25 },
+	};
+	int err;
+
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME) {
+		err = ufs_spacemit_quirk_host_pa_saveconfigtime(hba);
+		if (err < 0)
+			return err;
+	}
+
+	if (hba->dev_info.wmanufacturerid == UFS_VENDOR_WDC)
+		hba->dev_quirks |= UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE;
+
+	err = ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
+	if (err)
+		return err;
+
+	return ufs_spacemit_wait_mphy_pll_lock(hba);
+}
+
+/**
+ * ufs_spacemit_advertise_quirks - advertise the known Spacemit UFS controller quirks
+ * @hba: host controller instance
+ *
+ * Spacemit UFS host controller might have some non standard behaviours (quirks)
+ * than what is specified by UFSHCI specification. Advertise all such
+ * quirks to standard UFS host controller driver so standard takes them into
+ * account.
+ */
+static void ufs_spacemit_advertise_quirks(struct ufs_hba *hba)
+{
+	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
+}
+
+/**
+ * ufs_spacemit_init - init phy and prepare clk
+ * @hba: host controller instance
+ */
+static int ufs_spacemit_init(struct ufs_hba *hba)
+{
+	struct device *dev = hba->dev;
+	struct ufs_spacemit_host *host;
+	struct reset_control *rst;
+
+	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+
+	rst = devm_reset_control_get_exclusive_deasserted(dev, NULL);
+	if (IS_ERR(rst))
+		return dev_err_probe(dev, PTR_ERR(rst), "Failed to get reset control\n");
+
+	host->hba = hba;
+	ufshcd_set_variant(hba, host);
+	ufs_spacemit_advertise_quirks(hba);
+
+	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
+	hba->caps |= UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND;
+
+	return 0;
+}
+
+/**
+ * ufs_spacemit_device_reset - Toggle device reset line
+ * @hba: per-adapter instance
+ *
+ * Toggles the reset line to reset the attached UFS device.
+ *
+ * Returns: 0 on success
+ */
+static int ufs_spacemit_device_reset(struct ufs_hba *hba)
+{
+	u32 val;
+	/* Disable reference clock & asserted ufs device reset */
+	ufshcd_writel(hba, 0x000, UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
+	fsleep(10);
+
+	/* Enable reference clock */
+	val = MPHY_DEVICE_REFCLK_OE;
+	ufshcd_writel(hba, val, UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
+	fsleep(10);
+
+	/* Deassert ufs device reset */
+	val |= MPHY_DEVICE_HW_RESET;
+	ufshcd_writel(hba, val, UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
+	fsleep(10);
+
+	return 0;
+}
+
+/**
+ * ufs_spacemit_event_notify - Handle UFS error events
+ * @hba: host controller instance
+ * @evt: event type
+ * @data: event-specific data
+ *
+ * Handles error events from UFS core, print warning messages
+ */
+static void ufs_spacemit_event_notify(struct ufs_hba *hba, enum ufs_event_type evt, void *data)
+{
+	switch (evt) {
+	case UFS_EVT_PA_ERR:
+		if (data)
+			dev_warn(hba->dev, "PA error event, INT errors:0x%x, PA_ERR_CODE:0x%x\n",
+				 hba->errors, *(u32 *)data);
+
+		break;
+	case UFS_EVT_DL_ERR:
+		if (data)
+			dev_warn(hba->dev, "DL error event, INT errors:0x%x, DL_ERR:0x%x\n",
+				 hba->errors, *(u32 *)data);
+
+		break;
+	case UFS_EVT_ABORT:
+		dev_warn(hba->dev, "Abort event, INT errors:0x%x\n",
+			 hba->saved_err);
+		break;
+	default:
+		break;
+	}
+}
+
+static void ufs_spacemit_pre_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
+{
+	static const struct ufshcd_dme_attr_val setup_attrs[] = {
+		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x84 },
+		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x84 },
+		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x85 },
+		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x85 },
+	};
+	int ret;
+
+	if (cmd == UIC_CMD_DME_HIBER_EXIT) {
+		/* Enable reference clock & deassert ufs device reset */
+		ufshcd_writel(hba, MPHY_DEVICE_REFCLK_OE | MPHY_DEVICE_HW_RESET,
+			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
+
+		/* Power up all */
+		ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
+
+		/* Assert ana_rx_hb8_reset */
+		ufshcd_writel(hba, MPHY_PU_WITH_HB8_RESET,
+			      UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
+		fsleep(500);
+
+		/* Deassert ana_rx_hb8_reset */
+		ufshcd_writel(hba, MPHY_PU_ALL, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
+
+		ret = ufs_spacemit_wait_mphy_pll_lock(hba);
+		if (ret < 0)
+			return;
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB(0xdd), 0x57);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(0xe8), 0x57);
+	}
+
+	if (cmd == UIC_CMD_DME_HIBER_ENTER)
+		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
+}
+
+static void ufs_spacemit_post_hibern8(struct ufs_hba *hba, enum uic_cmd_dme cmd)
+{
+	static const struct ufshcd_dme_attr_val setup_attrs[] = {
+		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x84 },
+		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x84 },
+		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x80 },
+		{ UIC_ARG_MIB_SEL(0xf1, UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x80 },
+		{ UIC_ARG_MIB(0xdd), 0x57 },
+		{ UIC_ARG_MIB(0xdd), 0xd7 },
+		{ UIC_ARG_MIB(0xe8), 0x57 },
+		{ UIC_ARG_MIB(0xe8), 0xd7 },
+	};
+	int err;
+
+	if (cmd == UIC_CMD_DME_HIBER_ENTER) {
+		err = ufs_spacemit_check_hibern8(hba);
+		if (err)
+			dev_err(hba->dev, "ufs_spacemit_check_hibern8 error\n");
+
+		ufs_spacemit_dme_set(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
+
+		/* Power down M-PHY */
+		ufshcd_writel(hba, 0x0, UFS_PHY_MNG_BASE + UFS_MPHY_PU_CTRL);
+
+		fsleep(hba->dev_info.clk_gating_wait_us);
+
+		/* Disable reference clock, keep device reset deasserted */
+		ufshcd_writel(hba, MPHY_DEVICE_HW_RESET,
+			      UFS_PHY_MNG_BASE + UFS_DEVICE_IO_CTRL);
+	}
+}
+
+/**
+ * ufs_spacemit_hibern8_notify - Handle hibernate enter/exit
+ * @hba: host controller instance
+ * @cmd: UIC command (HIBER_ENTER or HIBER_EXIT)
+ * @status: notification status
+ *
+ * Manages M-PHY power state during hibernate transitions.
+ */
+static void ufs_spacemit_hibern8_notify(struct ufs_hba *hba, enum uic_cmd_dme cmd,
+					enum ufs_notify_change_status status)
+{
+	if (status == PRE_CHANGE)
+		ufs_spacemit_pre_hibern8(hba, cmd);
+
+	if (status == POST_CHANGE)
+		ufs_spacemit_post_hibern8(hba, cmd);
+}
+
+static const struct ufs_hba_variant_ops ufs_hba_spacemit_vops = {
+	.name = "ufshcd-spacemit",
+	.init = ufs_spacemit_init,
+	.link_startup_notify = ufs_spacemit_link_startup_notify,
+	.negotiate_pwr_mode = ufs_spacemit_negotiate_pwr_mode,
+	.pwr_change_notify = ufs_spacemit_pwr_change_notify,
+	.device_reset = ufs_spacemit_device_reset,
+	.event_notify = ufs_spacemit_event_notify,
+	.apply_dev_quirks = ufs_spacemit_apply_dev_quirks,
+	.hibern8_notify = ufs_spacemit_hibern8_notify,
+};
+
+static const struct of_device_id __maybe_unused ufs_spacemit_of_match[] = {
+	{ .compatible = "spacemit,k3-ufshc" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ufs_spacemit_of_match);
+
+static int ufs_spacemit_probe(struct platform_device *pdev)
+{
+	return ufshcd_pltfrm_init(pdev, &ufs_hba_spacemit_vops);
+}
+
+static void ufs_spacemit_remove(struct platform_device *pdev)
+{
+	ufshcd_pltfrm_remove(pdev);
+}
+
+static const struct dev_pm_ops ufs_spacemit_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
+	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+	.prepare	 = ufshcd_suspend_prepare,
+	.complete	 = ufshcd_resume_complete,
+};
+
+static struct platform_driver ufs_spacemit_pltform = {
+	.probe	= ufs_spacemit_probe,
+	.remove	= ufs_spacemit_remove,
+	.driver	= {
+		.name	= "ufshcd-spacemit",
+		.of_match_table = of_match_ptr(ufs_spacemit_of_match),
+		.pm	= &ufs_spacemit_pm_ops,
+	},
+};
+module_platform_driver(ufs_spacemit_pltform);
+
+MODULE_DESCRIPTION("SpacemiT UFS Host Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/ufs/host/ufs-spacemit.h b/drivers/ufs/host/ufs-spacemit.h
new file mode 100644
index 000000000000..96fbb66e6284
--- /dev/null
+++ b/drivers/ufs/host/ufs-spacemit.h
@@ -0,0 +1,81 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * SpacemiT UFS Host Controller driver
+ *
+ * Copyright (c) 2026 SpacemiT (Hangzhou) Technology Co. Ltd
+ */
+
+#ifndef _UFS_SPACEMIT_H_
+#define _UFS_SPACEMIT_H_
+
+#include <linux/regulator/consumer.h>
+#include <linux/pm_qos.h>
+#include <linux/workqueue.h>
+
+/* Spacemit K3 UFS host controller vendor specific registers */
+#define UFS_SYS1CLK_1US			0xC0
+#define UFS_TX_SYMBOL_CLK_NS_US		0xC4
+#define UFS_LOCAL_PORT_ID_REG		0xC8
+#define UFS_PA_ERR_CODE			0xCC
+#define UFS_RETRY_TIMER_REG		0xD0
+#define UFS_PA_LINK_STARTUP_TIMER	0xD8
+#define UFS_CFG1			0xDC
+
+/* MPHY control registers */
+#define UFS_PHY_MNG_BASE		0x1B00
+#define UFS_MPHY_RST_CTRL		0x0
+#define UFS_MPHY_PU_CTRL		0x4
+#define UFS_MPHY_BKDR_CTRL		0x8
+#define UFS_DEVICE_IO_CTRL		0xC
+
+/* ATOP base*/
+#define UFS_ATOP_BASE			0x1C00
+
+#define UFS_TX_SYMBO_CLK		0x800
+#define UFS_MAX_LINKSTARTUP_TIMER	0xFFFFFFFF
+#define UFS_DL_AFC0REQTIMEOUTVAL_MAX	0xFFFF
+
+#define TX_FSM_HIBERN8			0x1
+#define HBRN8_POLL_TOUT_MS		100
+#define DEFAULT_CLK_RATE_HZ		1000000
+#define BUS_VECTOR_NAME_LEN		32
+
+#define UFS_HW_VER_MAJOR_SHFT		28
+#define UFS_HW_VER_MAJOR_MASK		(0x000F << UFS_HW_VER_MAJOR_SHFT)
+#define UFS_HW_VER_MINOR_SHFT		16
+#define UFS_HW_VER_MINOR_MASK		(0x0FFF << UFS_HW_VER_MINOR_SHFT)
+#define UFS_HW_VER_STEP_SHFT		0
+#define UFS_HW_VER_STEP_MASK		(0xFFFF << UFS_HW_VER_STEP_SHFT)
+
+#define UFS_PA_VS_CONFIG_REG1			0x9000
+#define UFS_DME_VS_CORE_CLK_CTRL		0xD002
+
+#define UFS_HCLKDIV_REG 0xFC
+
+/* Special analog register */
+#define ANA_HSGEAR_CTRL_ATTR		0x00C1
+
+#define UFS_AXI_CLK_LOW_FREQ_HZ		409600000UL
+
+/* PHY register magic values */
+#define MPHY_PU_ALL			0x87f
+#define MPHY_PU_WITH_HB8_RESET		0xb7f
+#define MPHY_DEVICE_REFCLK_OE		BIT(8)
+#define MPHY_DEVICE_HW_RESET		BIT(0)
+
+#define MPHY_PLL_LOCK_BIT		BIT(31)
+#define MPHY_PLL_LOCK_TIMEOUT_US	10000
+
+/* M-PHY FSM states */
+#define MPHY_RX_FSM_STATE	0xC1
+#define MPHY_TX_FSM_STATE	0x41
+
+struct ufs_spacemit_host {
+	struct ufs_hba *hba;
+};
+
+struct ufshcd_dme_attr_val {
+	u32 attr_sel;
+	u32 mib_val;
+};
+#endif /* _UFS_SPACEMIT_H_ */

-- 
2.56.0

