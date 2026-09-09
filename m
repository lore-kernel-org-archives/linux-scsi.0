Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012038.outbound.protection.outlook.com [40.93.195.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0251526ABF;
	Wed,  9 Sep 2026 10:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788950559; cv=fail; b=hqbESszWkYRTavuW488zfx1KcmNRQAkPj7LAQvBqGxH8Fns5fh/78PgFsog1+jfvMlgmVucjIOD7W73uGTjIK5p2ActNCeFtIJAEHgCn7zAib0X4mkNsDd5gCqF7wEj+MydTDcPPJrVn1BurjtizaGw0Iiss0QicYQqL+YXnAbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788950559; c=relaxed/simple;
	bh=6pXddh1gf2VZ/Qgwi25kI9xoIc9q4i4lNz3wR056/FM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=B+EDWHRaaMT4QijJZsKi4t6Vsyxw0mseaEpmzS5UuYr7tVbATg92vAyxq/shey/umVuJ6o5YaKpt74Epn4mEEFaIK7uOK2fJLzqdDYgqKLwR0KJrpY7DPYKBFrhXFvdgFRSiYw4PlyFuSmHZcLNO42FiFwrgYG4V9DZdyVwnCi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YFZcal3x; arc=fail smtp.client-ip=40.93.195.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YFZcal3x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LsGn6FePxHylQgtHjQZcF9CAqBu2Hcx2K7Tjw6ujavFXxXAYXBQeSSsLSanagQSnZpIASNfyS8xDIZju0qE6130vc5OXR+RMmFRCc6cpCoFAiRCE2EGaSAdV/B9+7FfKVPkbecfNlTuxdV5FEUZS/o/jAbJIWi/4WMcB9uhRzGSotAz/JPPfvsKOsRbZX2RVV4UsK7u4n0DS2MzOIcL9OLxqGg5V+SqIs1cBB80PEOxSgQP9pZObzbA6yF9zmXqYrG2U3Aabr6/nP2TW2BG19MyXkv27/rY33e7/hiRsgly9Gd+IcttJBeNWI4PU5zjvkBKiwboYrzWIHb13XtiHYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DWbOOgaDdhhlbCmYDT8a5gyVSy6gDiW+oW2sw3tx58o=;
 b=nYSkNgTmvq8SsdnaJqsfry0OFz8w76vLbuYY2Xhp15eX+9w3CvvdUO/MYNMFiiv4W39C9ncBXoXRbnNWovRUVLnMxUI2cCqcR8CqMOPMf/O3T2xdKPBbOY0+vP+M1/hv9OJaWdo/rnAAZyBFhUaDOEErPQNGxCTYxKuCkcu3mFHVsw5ItdSK4801IY3zPRozMiTC3hcfXoBaK/6qyDnS0A1poncSDVlmZp7e7xBpZ/LTXHFxtziEqyTwUoL9dR7nh4Qgvkc+hq6tC4iY5ZnXpEW3VOaPx22VMxv155cen9PfksBzaRl6C93IKkgnJc20nANJ0yjvOxM8O9oaIxMX9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DWbOOgaDdhhlbCmYDT8a5gyVSy6gDiW+oW2sw3tx58o=;
 b=YFZcal3xnpQHi0FsSo+kH1apzxvBWM1Dwc5IrmiKdmR0VbfUFrX/OYaOvl9tqyoUgunWuEaQfXY56OFTPVvEXkl+tMW6liZG8yzxh0QEu8L5QzD/S+bS9VrPojMY9oI/7PEVYijhWgnG8pvHTOSXRjMDXxowQqC59ztDSlUIbeDQtnTeDKH4PCZXF9ZjOK3GC5HhC0CEt83yhAvfP9HXj64F1sO4aAXPmS3w5k26G6XuyHHsGdqjnToE/Hhk6hD1nGw2riQybYMy2Tisu8NdG3MMMwe3Sxn3kHz74etvFfC45yEPLIeqYIFaP19bV2Y/7jslTMUp4u3M7UbSiPecpw==
Received: from BN9P220CA0020.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::25)
 by DS0PR12MB9324.namprd12.prod.outlook.com (2603:10b6:8:1b6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Wed, 9 Sep 2026
 10:42:27 +0000
Received: from BN2PEPF0000A894.namprd04.prod.outlook.com
 (2603:10b6:408:13e:cafe::18) by BN9P220CA0020.outlook.office365.com
 (2603:10b6:408:13e::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.8 via Frontend Transport; Wed, 9
 Sep 2026 10:42:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF0000A894.mail.protection.outlook.com (10.167.248.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Wed, 9 Sep 2026 10:42:26 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 9 Sep
 2026 03:42:10 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 9 Sep
 2026 03:42:09 -0700
Received: from [127.0.1.1] (10.127.8.13) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026
 03:42:04 -0700
From: Kartik Rajput <kkartik@nvidia.com>
Date: Wed, 9 Sep 2026 16:11:22 +0530
Subject: [PATCH 4/4] scsi: ufs: tegra: Add Tegra264 UFS host controller
 driver
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260909-tegra264-ufs-v1-4-e4a9831702a0@nvidia.com>
References: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
In-Reply-To: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
	<avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
	<conor+dt@kernel.org>, Thierry Reding <thierry.reding@kernel.org>, "Jonathan
 Hunter" <jonathanh@nvidia.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
	<mkp@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>
CC: Thierry Reding <treding@nvidia.com>, <linux-scsi@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kartik Rajput <kkartik@nvidia.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788950501; l=19800;
 i=kkartik@nvidia.com; s=20260909; h=from:subject:message-id;
 bh=6pXddh1gf2VZ/Qgwi25kI9xoIc9q4i4lNz3wR056/FM=;
 b=IdQG+v/X7seHDAuVwRMXQt+Adea/5aYuDduts4ur9CGsblzGWtRCVEzPidWNcRxogfu9TFiWP
 +1KZdk5m+8NB0FulxYjYeAgd8qqXVPNEq8mhN//IqD36LK8XMaF6DAJ
X-Developer-Key: i=kkartik@nvidia.com; a=ed25519;
 pk=V+1YkJqxCruxUVxLXtAG3f5k8O5skT0X4/QIB75KZ64=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A894:EE_|DS0PR12MB9324:EE_
X-MS-Office365-Filtering-Correlation-Id: bcf861ac-53c4-45ce-4496-08df0e5f0a54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|23010399003|7416014|6133799003|22082099003|18002099003|56012099006|10067099003|921020|11063799006;
X-Microsoft-Antispam-Message-Info:
	vOqGxMyPfkesGbcfnXB0Gneouy10ytgCxTTZ5mZXgCXs5E0OB6KhFN1hc642fVmkj5RO9lzEcdU0Es+R/mNixPVBKYfq3An2v+R12N5mdS8BPcE8Fp1o6A6Q5s96t4p4qlyf/eNRLaTctzrWYpU7KTdVHEM2OC/PUNB4z0KuSKPzWk38jJy2pTN4qisR2+HadFgHl8gVDNwRSZE91xuopa/RdS1KqXRUoR0Q9Bpr+MjILSNojg/0IsJ+VjSLO5I5Mw6pAspDK7qwUgFxovU0Fb/2+qOGiK65qbgzSXgQBmP8IHmQNaBAmYhIrNJxE/K3tEP5HwxVUH44pxII63HWSFc7mVsxxbgrmt+ODw99FFSvrKmEFMpJ4nGme+xv5qFzg+/1By9HDqGc9sDLK8BQpLDn/3h3L7k/Zcm/FarW4C1SQaTWGaEs3h3m8oX4KBk4L6fdCJSXgHA0GxNeBupbYfJuDM3+hCA9vg6nZP6ByMsKAFa24+6NnQYnHR9pUvt/WWcxz2Md4MEPDw4Pp374fu1VmhJUeL7Cv6OUFGsMHCSPl/t/9ANca4/qU0+iotmQXHBuUhVJfjW7SzYHfnUmGLaUE69yaj/Tv2/Wd7wmYOYCof3MPO3yJbKWFxomMAiSgTsJXJp/1MpAYcylr1jQ+ZL1r4Bpf9afQ/EXoY06SqAobeyb3Y0vWVQ7H2V3HL5ZP0WDu6lTI+3+6ohxyLKji86B2Ik1iYNsCogFRTEsafoZiXtTFMo8wAkj0u6SSOD/
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(23010399003)(7416014)(6133799003)(22082099003)(18002099003)(56012099006)(10067099003)(921020)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	sFjDU+FZUtQlko87mKYZATqIR0WEinRuhCoXCvvm87Er3ISNMSOmrDp246wkLs6E9rY+UUzuhuqCtJMUcSbf7y1HCI4UrQvA0AbHsu63Rg+aws7gLx5xCx0Nx7PwQIpHt2aFocKRYjLT/w4ERy9wymrdzLVMZ8kKHFXzAJx7A2FnXYVg9y05q40mhbksKBXFOo2xS8QIjNjl9GaHF+FTwxaU4Bk92MrIFmFtoaCXrA2gJrZjCUieQglmmWWvIDicmcFcuAnVUryZVQtrwPUSAnFmw1fBWamCjDVZkE/7Qac3CD61Oa9eRmOk0MiUx8jGjxRMMU3xG80T2HXTPCcsuLwod3lXxLIG5XWt5I2pDhRPTV4MLvQjtfCw0BlcaZfqFRrpMYDgSU/bj9wSqsFZ60+gPZPfaRasrvsvIvMnck0tUyhDOyyIQRKaZrct6r1J
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 10:42:26.6091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcf861ac-53c4-45ce-4496-08df0e5f0a54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A894.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9324

Add a driver for the UFS host controller found on NVIDIA Tegra264 SoCs.
The controller has Tegra-specific auxiliary registers, clocks and resets,
and it drives the four M-PHY lane directions exposed by the Tegra264
M-PHY driver.

Co-developed-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
---
 drivers/ufs/host/Kconfig     |  13 +
 drivers/ufs/host/Makefile    |   1 +
 drivers/ufs/host/ufs-tegra.c | 687 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 701 insertions(+)

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index ff170c0b6da0..e4c565fce53c 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -168,3 +168,16 @@ config SCSI_UFS_AMD_VERSAL2
 
 	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
 	  If unsure, say N.
+
+config SCSI_UFS_TEGRA
+	tristate "NVIDIA Tegra264 UFS controller platform driver"
+	depends on SCSI_UFSHCD_PLATFORM && (ARCH_TEGRA_264_SOC || COMPILE_TEST)
+	select PHY_TEGRA_MPHY
+	help
+	  Enable support for the UFS host controller on NVIDIA Tegra264
+	  SoCs. The driver relies on the Tegra264 M-PHY driver
+	  (PHY_TEGRA_MPHY) for the two data lanes and implements the
+	  vendor register programming required for HS-mode transitions
+	  and system suspend/resume.
+
+	  If unsure, say N.
diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
index 7d8db67eb23c..1459a081cc9d 100644
--- a/drivers/ufs/host/Makefile
+++ b/drivers/ufs/host/Makefile
@@ -14,5 +14,6 @@ obj-$(CONFIG_SCSI_UFS_MEDIATEK) += ufs-mediatek.o
 obj-$(CONFIG_SCSI_UFS_RENESAS) += ufs-renesas.o
 obj-$(CONFIG_SCSI_UFS_ROCKCHIP) += ufs-rockchip.o
 obj-$(CONFIG_SCSI_UFS_SPRD) += ufs-sprd.o
+obj-$(CONFIG_SCSI_UFS_TEGRA) += ufs-tegra.o ufshcd-dwc.o
 obj-$(CONFIG_SCSI_UFS_TI_J721E) += ti-j721e-ufs.o
 obj-$(CONFIG_SCSI_UFS_AMD_VERSAL2) += ufs-amd-versal2.o ufshcd-dwc.o
diff --git a/drivers/ufs/host/ufs-tegra.c b/drivers/ufs/host/ufs-tegra.c
new file mode 100644
index 000000000000..859fe0af66e5
--- /dev/null
+++ b/drivers/ufs/host/ufs-tegra.c
@@ -0,0 +1,687 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+// NVIDIA Tegra264 UFS host controller driver.
+
+#include <linux/bitfield.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/mod_devicetable.h>
+#include <linux/of.h>
+#include <linux/phy/phy.h>
+#include <linux/platform_device.h>
+#include <linux/reset.h>
+
+#include <ufs/ufshcd.h>
+#include <ufs/ufshci.h>
+#include <ufs/unipro.h>
+
+#include "ufshcd-dwc.h"
+#include "ufshcd-pltfrm.h"
+#include "ufshci-dwc.h"
+
+#define UFSHC_DWC_BLOCK_BUSTHRTL		0xc0
+#define MBL(x)					(((x) & 0x7) << 13)
+#define MBL_MASK				(0x7 << 13)
+
+#define HCLKDIV(x)				((x) & 0xff)
+
+#define UFSHC_AUX_SW_EN_CLK_SLCG		0x08
+#define CLK_OVR_ON				BIT(0)
+
+#define UFSHC_AUX_DEV_CTRL			0x14
+#define DEV_CTRL_CLK_EN				BIT(0)
+#define DEV_CTRL_RESET				BIT(1)
+
+#define UFS_TEGRA_PHY_CLK_HS_RATE_HZ		5840000000UL
+
+/* DWC UFSHC BUSTHRTL max AXI burst length. */
+#define UFS_TEGRA_MBL_MAX			0x5
+
+/* DWC UniPro save-config-time reference and value fields. */
+#define UFS_TEGRA_SAVECONFIGTIME_TREF		0x6
+#define UFS_TEGRA_SAVECONFIGTIME_SCT		0x3
+
+/* HS G1..G4 sync burst length advertised to the peer. */
+#define UFS_TEGRA_HSG_SYNC_LEN			0x4f
+
+/* Local UniPro DME timeout values sent to the peer via PA_PWRMODEUSERDATA. */
+#define UFS_TEGRA_FC0_TIMEOUT			0x1fff
+#define UFS_TEGRA_TC0_TIMEOUT			0xffff
+#define UFS_TEGRA_AFC0_TIMEOUT			0x7fff
+
+struct ufs_tegra {
+	void __iomem *aux;
+
+	struct reset_control_bulk_data *resets;
+	unsigned int num_resets;
+
+	struct clk *ufs_clk;
+	struct clk *phy_clk;
+
+	struct phy *mphy_l0_rx;
+	struct phy *mphy_l0_tx;
+	struct phy *mphy_l1_rx;
+	struct phy *mphy_l1_tx;
+
+	bool mphy_on;
+
+	struct ufs_host_params host_params;
+};
+
+static int ufs_tegra_init_resources(struct ufs_hba *hba)
+{
+	struct platform_device *pdev = to_platform_device(hba->dev);
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+
+	ufs->aux = devm_platform_ioremap_resource_byname(pdev, "aux");
+	if (IS_ERR(ufs->aux))
+		return PTR_ERR(ufs->aux);
+
+	return 0;
+}
+
+static const struct reset_control_bulk_data ufs_tegra_resets[] = {
+	{ .id = "ufs" },
+	{ .id = "axi" },
+	{ .id = "lp" },
+};
+
+static int ufs_tegra_parse_reset_info(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+
+	ufs->num_resets = ARRAY_SIZE(ufs_tegra_resets);
+
+	ufs->resets = devm_kmemdup(dev, ufs_tegra_resets, sizeof(ufs_tegra_resets), GFP_KERNEL);
+	if (!ufs->resets)
+		return -ENOMEM;
+
+	return devm_reset_control_bulk_get_exclusive(dev, ufs->num_resets, ufs->resets);
+}
+
+static int ufs_tegra_parse_clock_info(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	struct ufs_clk_info *clki;
+
+	list_for_each_entry(clki, &hba->clk_list_head, list) {
+		if (!strcmp(clki->name, "ufs"))
+			ufs->ufs_clk = clki->clk;
+
+		if (!strcmp(clki->name, "phy"))
+			ufs->phy_clk = clki->clk;
+	}
+
+	if (!ufs->ufs_clk || !ufs->phy_clk)
+		return -ENODEV;
+
+	return 0;
+}
+
+static int ufs_tegra_parse_phy_info(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	struct device *dev = hba->dev;
+
+	ufs->mphy_l0_rx = devm_phy_get(dev, "mphy-l0-rx");
+	if (IS_ERR(ufs->mphy_l0_rx))
+		return PTR_ERR(ufs->mphy_l0_rx);
+
+	ufs->mphy_l0_tx = devm_phy_get(dev, "mphy-l0-tx");
+	if (IS_ERR(ufs->mphy_l0_tx))
+		return PTR_ERR(ufs->mphy_l0_tx);
+
+	ufs->mphy_l1_rx = devm_phy_get(dev, "mphy-l1-rx");
+	if (IS_ERR(ufs->mphy_l1_rx))
+		return PTR_ERR(ufs->mphy_l1_rx);
+
+	ufs->mphy_l1_tx = devm_phy_get(dev, "mphy-l1-tx");
+	if (IS_ERR(ufs->mphy_l1_tx))
+		return PTR_ERR(ufs->mphy_l1_tx);
+
+	return 0;
+}
+
+static void ufs_tegra_set_caps(struct ufs_hba *hba)
+{
+	hba->caps |= UFSHCD_CAP_INTR_AGGR;
+	hba->caps |= UFSHCD_CAP_WB_EN;
+
+	hba->spm_lvl = UFS_PM_LVL_5;
+}
+
+static void ufs_tegra_configure_aux(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	u32 value;
+
+	value = readl(ufs->aux + UFSHC_AUX_DEV_CTRL);
+	value |= DEV_CTRL_CLK_EN;
+	writel(value, ufs->aux + UFSHC_AUX_DEV_CTRL);
+
+	/* Let the reference clock stabilise before deasserting device reset. */
+	usleep_range(1000, 2000);
+
+	value |= DEV_CTRL_RESET;
+	writel(value, ufs->aux + UFSHC_AUX_DEV_CTRL);
+}
+
+static void ufs_tegra_aux_init(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	u32 value;
+
+	value = readl(ufs->aux + UFSHC_AUX_DEV_CTRL);
+	value &= ~(DEV_CTRL_CLK_EN | DEV_CTRL_RESET);
+	writel(value, ufs->aux + UFSHC_AUX_DEV_CTRL);
+
+	/* Ensure the clear is observed before we re-enable. */
+	usleep_range(100, 200);
+
+	ufs_tegra_configure_aux(hba);
+}
+
+static void ufs_tegra_update_hclk_div(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	u32 ufs_clk_mhz;
+
+	ufs_clk_mhz = clk_get_rate(ufs->ufs_clk) / USEC_PER_SEC;
+	ufshcd_writel(hba, HCLKDIV(ufs_clk_mhz), DWC_UFS_REG_HCLKDIV);
+}
+
+static int ufs_tegra_init(struct ufs_hba *hba)
+{
+	struct platform_device *pdev = to_platform_device(hba->dev);
+	struct device *dev = &pdev->dev;
+	struct ufs_tegra *ufs;
+	int err;
+
+	ufs = devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
+	if (!ufs)
+		return -ENOMEM;
+
+	ufshcd_set_variant(hba, ufs);
+
+	err = ufs_tegra_init_resources(hba);
+	if (err)
+		return err;
+
+	err = ufs_tegra_parse_clock_info(hba);
+	if (err)
+		return err;
+
+	err = ufs_tegra_parse_reset_info(hba);
+	if (err)
+		return err;
+
+	err = ufs_tegra_parse_phy_info(hba);
+	if (err)
+		return err;
+
+	ufs_tegra_set_caps(hba);
+
+	ufshcd_init_host_params(&ufs->host_params);
+	ufs->host_params.hs_rx_gear = UFS_HS_G4;
+	ufs->host_params.hs_tx_gear = UFS_HS_G4;
+
+	err = reset_control_bulk_deassert(ufs->num_resets, ufs->resets);
+	if (err)
+		return err;
+
+	ufs_tegra_aux_init(hba);
+	ufs_tegra_update_hclk_div(hba);
+
+	return 0;
+}
+
+static int ufs_tegra_mphy_init(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	int err;
+
+	err = phy_init(ufs->mphy_l0_rx);
+	if (err) {
+		dev_err(hba->dev, "failed to initialize mphy-l0-rx\n");
+		return err;
+	}
+
+	err = phy_init(ufs->mphy_l0_tx);
+	if (err) {
+		dev_err(hba->dev, "failed to initialize mphy-l0-tx\n");
+		goto out_exit_l0_rx;
+	}
+
+	err = phy_init(ufs->mphy_l1_rx);
+	if (err) {
+		dev_err(hba->dev, "failed to initialize mphy-l1-rx\n");
+		goto out_exit_l0_tx;
+	}
+
+	err = phy_init(ufs->mphy_l1_tx);
+	if (err) {
+		dev_err(hba->dev, "failed to initialize mphy-l1-tx\n");
+		goto out_exit_l1_rx;
+	}
+
+	return 0;
+
+out_exit_l1_rx:
+	phy_exit(ufs->mphy_l1_rx);
+out_exit_l0_tx:
+	phy_exit(ufs->mphy_l0_tx);
+out_exit_l0_rx:
+	phy_exit(ufs->mphy_l0_rx);
+
+	return err;
+}
+
+static void ufs_tegra_mphy_exit(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+
+	phy_exit(ufs->mphy_l0_rx);
+	phy_exit(ufs->mphy_l0_tx);
+	phy_exit(ufs->mphy_l1_rx);
+	phy_exit(ufs->mphy_l1_tx);
+}
+
+static int ufs_tegra_mphy_power_on(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	int err;
+
+	err = phy_power_on(ufs->mphy_l0_rx);
+	if (err) {
+		dev_err(hba->dev, "failed to power on mphy-l0-rx\n");
+		return err;
+	}
+
+	err = phy_power_on(ufs->mphy_l0_tx);
+	if (err) {
+		dev_err(hba->dev, "failed to power on mphy-l0-tx\n");
+		goto out_power_off_l0_rx;
+	}
+
+	err = phy_power_on(ufs->mphy_l1_rx);
+	if (err) {
+		dev_err(hba->dev, "failed to power on mphy-l1-rx\n");
+		goto out_power_off_l0_tx;
+	}
+
+	err = phy_power_on(ufs->mphy_l1_tx);
+	if (err) {
+		dev_err(hba->dev, "failed to power on mphy-l1-tx\n");
+		goto out_power_off_l1_rx;
+	}
+
+	return 0;
+
+out_power_off_l1_rx:
+	phy_power_off(ufs->mphy_l1_rx);
+out_power_off_l0_tx:
+	phy_power_off(ufs->mphy_l0_tx);
+out_power_off_l0_rx:
+	phy_power_off(ufs->mphy_l0_rx);
+
+	return err;
+}
+
+static void ufs_tegra_mphy_power_off(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+
+	phy_power_off(ufs->mphy_l0_rx);
+	phy_power_off(ufs->mphy_l0_tx);
+	phy_power_off(ufs->mphy_l1_rx);
+	phy_power_off(ufs->mphy_l1_tx);
+}
+
+static int ufs_tegra_mphy_enable(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	int err;
+
+	if (ufs->mphy_on)
+		return 0;
+
+	err = ufs_tegra_mphy_init(hba);
+	if (err)
+		return err;
+
+	err = ufs_tegra_mphy_power_on(hba);
+	if (err) {
+		ufs_tegra_mphy_exit(hba);
+		return err;
+	}
+
+	ufs->mphy_on = true;
+
+	/* Allow M-PHY to settle after power-on. */
+	usleep_range(500, 600);
+
+	return 0;
+}
+
+static void ufs_tegra_mphy_disable(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+
+	if (!ufs->mphy_on)
+		return;
+
+	ufs_tegra_mphy_power_off(hba);
+	ufs_tegra_mphy_exit(hba);
+
+	ufs->mphy_on = false;
+}
+
+static int ufs_tegra_mphy_configure_tx(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	int err;
+
+	err = phy_configure(ufs->mphy_l0_tx, NULL);
+	if (err)
+		return err;
+
+	return phy_configure(ufs->mphy_l1_tx, NULL);
+}
+
+static int ufs_tegra_mphy_calibrate_tx(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	int err;
+
+	err = phy_calibrate(ufs->mphy_l0_tx);
+	if (err)
+		return err;
+
+	return phy_calibrate(ufs->mphy_l1_tx);
+}
+
+static int ufs_tegra_mphy_calibrate_rx(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	int err;
+
+	err = phy_configure(ufs->mphy_l1_rx, NULL);
+	if (err)
+		return err;
+
+	err = phy_configure(ufs->mphy_l0_rx, NULL);
+	if (err)
+		return err;
+
+	err = phy_calibrate(ufs->mphy_l1_rx);
+	if (err)
+		return err;
+
+	return phy_calibrate(ufs->mphy_l0_rx);
+}
+
+static void ufs_tegra_exit(struct ufs_hba *hba)
+{
+	ufs_tegra_mphy_disable(hba);
+}
+
+static int ufs_tegra_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
+			     enum ufs_notify_change_status status)
+{
+	if (status == PRE_CHANGE)
+		return 0;
+
+	/* Runtime H8 park keeps the M-PHY powered; only tear it down
+	 * on the full-teardown paths (system suspend, shutdown, or
+	 * runtime PM with LINK_OFF).
+	 */
+	if (pm_op == UFS_RUNTIME_PM && !ufshcd_is_link_off(hba))
+		return 0;
+
+	ufs_tegra_mphy_disable(hba);
+
+	if (pm_op != UFS_RUNTIME_PM)
+		ufshcd_set_link_off(hba);
+
+	return 0;
+}
+
+static int ufs_tegra_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
+{
+	/* Skip when the M-PHY was left powered by the suspend path. */
+	if (ufshcd_is_link_active(hba) || ufshcd_is_link_hibern8(hba))
+		return 0;
+
+	return ufs_tegra_mphy_enable(hba);
+}
+
+static int ufs_tegra_reset(struct ufs_tegra *ufs)
+{
+	int err;
+
+	err = reset_control_bulk_assert(ufs->num_resets, ufs->resets);
+	if (err)
+		return err;
+
+	usleep_range(100, 200);
+
+	err = reset_control_bulk_deassert(ufs->num_resets, ufs->resets);
+	if (err)
+		return err;
+
+	usleep_range(500, 600);
+
+	return 0;
+}
+
+static int ufs_tegra_power_up_sequence(struct ufs_hba *hba)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	int err;
+
+	err = ufs_tegra_reset(ufs);
+	if (err)
+		return err;
+
+	return ufs_tegra_mphy_enable(hba);
+}
+
+static void ufs_tegra_setup(struct ufs_hba *hba)
+{
+	ufs_tegra_configure_aux(hba);
+	ufs_tegra_update_hclk_div(hba);
+	ufshcd_rmwl(hba, MBL_MASK, MBL(UFS_TEGRA_MBL_MAX), UFSHC_DWC_BLOCK_BUSTHRTL);
+}
+
+static int ufs_tegra_hce_enable_notify(struct ufs_hba *hba, enum ufs_notify_change_status status)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	u32 value;
+	int err;
+
+	switch (status) {
+	case PRE_CHANGE:
+		err = ufs_tegra_power_up_sequence(hba);
+		if (err)
+			return err;
+
+		/* Assert device reset; POST_CHANGE releases it via
+		 * ufs_tegra_configure_aux() so the HCE toggle pulses it.
+		 */
+		value = readl(ufs->aux + UFSHC_AUX_DEV_CTRL);
+		value &= ~DEV_CTRL_RESET;
+		writel(value, ufs->aux + UFSHC_AUX_DEV_CTRL);
+		break;
+	case POST_CHANGE:
+		value = readl(ufs->aux + UFSHC_AUX_SW_EN_CLK_SLCG);
+		value &= ~CLK_OVR_ON;
+		writel(value, ufs->aux + UFSHC_AUX_SW_EN_CLK_SLCG);
+
+		ufs_tegra_setup(hba);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ufs_tegra_link_startup_notify(struct ufs_hba *hba, enum ufs_notify_change_status status)
+{
+	static const struct ufshcd_dme_attr_val post_change_attrs[] = {
+		{ UIC_ARG_MIB(T_CONNECTIONSTATE), 0x1, DME_LOCAL },
+		{ UIC_ARG_MIB(PA_TXHSG1SYNCLENGTH), UFS_TEGRA_HSG_SYNC_LEN, DME_LOCAL },
+		{ UIC_ARG_MIB(PA_TXHSG2SYNCLENGTH), UFS_TEGRA_HSG_SYNC_LEN, DME_LOCAL },
+		{ UIC_ARG_MIB(PA_TXHSG3SYNCLENGTH), UFS_TEGRA_HSG_SYNC_LEN, DME_LOCAL },
+		{ UIC_ARG_MIB(PA_TXHSG4SYNCLENGTH), UFS_TEGRA_HSG_SYNC_LEN, DME_LOCAL },
+		{ UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal), UFS_TEGRA_FC0_TIMEOUT, DME_LOCAL },
+		{ UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal), UFS_TEGRA_TC0_TIMEOUT, DME_LOCAL },
+		{ UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal), UFS_TEGRA_AFC0_TIMEOUT, DME_LOCAL },
+		{ UIC_ARG_MIB(PA_PWRMODEUSERDATA0), UFS_TEGRA_FC0_TIMEOUT, DME_LOCAL },
+		{ UIC_ARG_MIB(PA_PWRMODEUSERDATA1), UFS_TEGRA_TC0_TIMEOUT, DME_LOCAL },
+		{ UIC_ARG_MIB(PA_PWRMODEUSERDATA2), UFS_TEGRA_AFC0_TIMEOUT, DME_LOCAL },
+	};
+	int err;
+
+	switch (status) {
+	case PRE_CHANGE:
+		/* Arm TX calibration; RX capabilities are advertised in
+		 * tegra_mphy_rx_power_on().
+		 */
+		err = ufs_tegra_mphy_configure_tx(hba);
+		if (err)
+			return err;
+		break;
+
+	case POST_CHANGE:
+		err = ufs_tegra_mphy_calibrate_tx(hba);
+		if (err)
+			return err;
+
+		err = ufshcd_dwc_dme_set_attrs(hba, post_change_attrs,
+					       ARRAY_SIZE(post_change_attrs));
+		if (err)
+			return err;
+
+		err = ufs_tegra_mphy_calibrate_rx(hba);
+		if (err)
+			return err;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ufs_tegra_negotiate_pwr_mode(struct ufs_hba *hba,
+					const struct ufs_pa_layer_attr *dev_max_params,
+					struct ufs_pa_layer_attr *dev_req_params)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+
+	return ufshcd_negotiate_pwr_params(&ufs->host_params, dev_max_params, dev_req_params);
+}
+
+static int ufs_tegra_pwr_change_notify(struct ufs_hba *hba,
+				       enum ufs_notify_change_status status,
+				       struct ufs_pa_layer_attr *dev_req_params)
+{
+	struct ufs_tegra *ufs = ufshcd_get_variant(hba);
+	u32 value;
+	int err;
+
+	if (status != PRE_CHANGE)
+		return 0;
+
+	err = ufshcd_dme_get(hba, UIC_ARG_MIB(VS_DEBUGSAVECONFIGTIME), &value);
+	if (err)
+		return err;
+
+	value &= ~VS_DEBUGSAVECONFIGTIME_TREF;
+	value |= FIELD_PREP(VS_DEBUGSAVECONFIGTIME_TREF, UFS_TEGRA_SAVECONFIGTIME_TREF);
+	value &= ~VS_DEBUGSAVECONFIGTIME_SCT;
+	value |= FIELD_PREP(VS_DEBUGSAVECONFIGTIME_SCT, UFS_TEGRA_SAVECONFIGTIME_SCT);
+
+	err = ufshcd_dme_set(hba, UIC_ARG_MIB(VS_DEBUGSAVECONFIGTIME), value);
+	if (err)
+		return err;
+
+	if (dev_req_params->hs_rate == PA_HS_MODE_A ||
+	    dev_req_params->hs_rate == PA_HS_MODE_B) {
+		err = clk_set_rate(ufs->phy_clk, UFS_TEGRA_PHY_CLK_HS_RATE_HZ);
+		if (err)
+			return err;
+	}
+
+	err = ufshcd_dme_configure_adapt(hba, dev_req_params->gear_tx, PA_INITIAL_ADAPT);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int ufs_tegra_set_dma_mask(struct ufs_hba *hba)
+{
+	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
+}
+
+static const struct ufs_hba_variant_ops ufs_tegra_vops = {
+	.name = "ufs-tegra",
+	.init = ufs_tegra_init,
+	.exit = ufs_tegra_exit,
+	.suspend = ufs_tegra_suspend,
+	.resume = ufs_tegra_resume,
+	.hce_enable_notify = ufs_tegra_hce_enable_notify,
+	.negotiate_pwr_mode = ufs_tegra_negotiate_pwr_mode,
+	.pwr_change_notify = ufs_tegra_pwr_change_notify,
+	.link_startup_notify = ufs_tegra_link_startup_notify,
+	.set_dma_mask = ufs_tegra_set_dma_mask,
+};
+
+static int ufs_tegra_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	int err;
+
+	err = ufshcd_pltfrm_init(pdev, &ufs_tegra_vops);
+	if (err)
+		return dev_err_probe(dev, err, "ufshcd platform init failed\n");
+
+	return 0;
+}
+
+static void ufs_tegra_remove(struct platform_device *pdev)
+{
+	ufshcd_pltfrm_remove(pdev);
+}
+
+static const struct dev_pm_ops ufs_tegra_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend, ufshcd_system_resume)
+	SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend, ufshcd_runtime_resume, NULL)
+};
+
+static const struct of_device_id ufs_tegra_of_match[] = {
+	{ .compatible = "nvidia,tegra264-ufs", },
+	{}
+};
+MODULE_DEVICE_TABLE(of, ufs_tegra_of_match);
+
+static struct platform_driver ufs_tegra_driver = {
+	.probe = ufs_tegra_probe,
+	.remove = ufs_tegra_remove,
+	.driver = {
+		.name = "ufs-tegra",
+		.pm = &ufs_tegra_pm_ops,
+		.of_match_table = ufs_tegra_of_match,
+	},
+};
+module_platform_driver(ufs_tegra_driver);
+
+MODULE_AUTHOR("Thierry Reding <treding@nvidia.com>");
+MODULE_AUTHOR("Kartik Rajput <kkartik@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA Tegra UFS host controller driver");
+MODULE_LICENSE("GPL");

-- 
2.43.0

