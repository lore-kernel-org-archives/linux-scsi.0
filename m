Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010042.outbound.protection.outlook.com [52.101.193.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6B94FD794;
	Tue, 29 Sep 2026 09:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790675187; cv=fail; b=EkzQIxw1/T9jW+gd32k/VDqTRDA0j1Ztxm3Y3fQwP2PEbs1eT80E0NGei4/UU+rzqpO5mpCMrtFzZNmorWyEfrpp8GKj3X17HRmLfqnPoQwsAk7Bdqz+Erewx6mpE9hqIdcHAM79+tFWUPs79tlzOwpLLH6ZwRuSa0VmWLc4350=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790675187; c=relaxed/simple;
	bh=TCSJ6lf10207htVmKClNeLK5rJhdIMb5wBD+KlgRMPg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=B1AS4ZkoCglSV1ACD+aWfXc6fzMTnwatVPIDqzT3QD3osZ8nu17QOClYga8F2KR11x5OrU5Pf9otp6Q9Gk58jz2BqbnTsqKeF5l8bMPoje6ddPm3e36gZ+Gma/llYilczb2RqVfqo/Flk7uq0CeuoL6aGK860jfYWSoohTptNeU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Apq9aMy7; arc=fail smtp.client-ip=52.101.193.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Apq9aMy7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lROZ+QPGnRjsw+WhcuyWnPgA3jfc2CCvMhMtClU6b9D6WJ+fFBfdMsIRwdsdskK2GEoCmPHdMiUfAPEhMmoowSl68XohNztNBAi4qWwvsG11EwrCFuljTHIzLA1gczHDRTFAlvm6odWY3a+HQUySGekgYdWQ0kb1a1bRqXoxxlsB+ttz0DcJ7u2m60sQF29my80ZkPQY+0WPaPRljsF/rInY8n3I6gxyApyT3Ns7fo7hWnxWX2XCZoCN+LMIUDM3j5Zi4m33EsqHBp2+eWUwF4ltq8O1UwAsZnweTlseDMXjB/vk59jKhET6LfxsbdPIPg0gNMIxtuuq0yYzVD//lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gKdqtwKrjXRAb7cEExJQWHV12k8PW3Q1C+mymHzdOKc=;
 b=SVn6jZymJQEoVSxtSSfgVyhi9vyZbUTArrWBD9ZzE+NCII3BqUULstFSTngLakOArBx7m3a1P/MoLDjNafkF5rbuHeSr9u7yCB9wuWSF5N275erVi7yaK4oos1hd1mgu8aqM0GXmc6GlwBqr8Flr6tDWEJa/KaaWJ6rJAO/W6MMqPfszvmgObeUfPcLPom7Bj+NKlNg/dWQliZQQau4x2YnbEEjGpDeyqSuLr2ihueou94iXfqgELCQ/CFDlxhraO6uS1wrcZwf1NmDQda43Qq9M0D4KK5WlEDn4I/n9+ClKN8wTBONFqy7nCqBwMathNwviQP1v/reeZ1qWRYxOuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gKdqtwKrjXRAb7cEExJQWHV12k8PW3Q1C+mymHzdOKc=;
 b=Apq9aMy7XCDXTT4hcpy5abDa1ettYhOp+F8XcHzBXpcMXMyPCxvwEQIi4Uk6jHueBgCIcSBCxOSxu8rmb06WaESBrq7AfkQp/H3YZu/HSYCUqPdCuvO89t0+tWAQsTmIu32Le2qvqUqbGcM4TnwUloMVe2ulk+mBzjEQh1jW7jsENPLjVhnS5cghf1ju7zMsWzlH9MUfgHJ3epRVsRKqwMVFCHzJqN2F1U9P07nnHYMW7SBnHZn89ZTEDfBgPAXWsdCuIYlNWQIbLyV1SMGciSCAjGTSdZ705tSsriHM/rxDj67YraGlEY6nQDm3gW2V/BiIggGe9d99/n4jduTGig==
Received: from MW4PR04CA0390.namprd04.prod.outlook.com (2603:10b6:303:81::35)
 by PH0PR12MB8006.namprd12.prod.outlook.com (2603:10b6:510:28d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.23; Tue, 29 Sep
 2026 09:46:10 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:303:81:cafe::4b) by MW4PR04CA0390.outlook.office365.com
 (2603:10b6:303:81::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Tue,
 29 Sep 2026 09:46:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Tue, 29 Sep 2026 09:46:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 29 Sep
 2026 02:45:48 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 29 Sep
 2026 02:45:47 -0700
Received: from [127.0.1.1] (10.127.8.13) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Tue, 29 Sep
 2026 02:45:43 -0700
From: Kartik Rajput <kkartik@nvidia.com>
Date: Tue, 29 Sep 2026 15:15:10 +0530
Subject: [PATCH v2 4/4] scsi: ufs: tegra: Add Tegra264 UFS host controller
 driver
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260929-tegra264-ufs-v2-4-f0467b9c503e@nvidia.com>
References: <20260929-tegra264-ufs-v2-0-f0467b9c503e@nvidia.com>
In-Reply-To: <20260929-tegra264-ufs-v2-0-f0467b9c503e@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790675122; l=19778;
 i=kkartik@nvidia.com; s=20260909; h=from:subject:message-id;
 bh=TCSJ6lf10207htVmKClNeLK5rJhdIMb5wBD+KlgRMPg=;
 b=kQZOcA9YM2PBRT9xtRP5teACbvbqKFAqvg3aCeVwubQoj0R2Y0JDjY36u5j3uSIHlleZg5Hqk
 +vUUKUTC2RwCLT4p67DsebHozRogN27kh8u3SQhAs3IPG8ZrQxSgJRG
X-Developer-Key: i=kkartik@nvidia.com; a=ed25519;
 pk=V+1YkJqxCruxUVxLXtAG3f5k8O5skT0X4/QIB75KZ64=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|PH0PR12MB8006:EE_
X-MS-Office365-Filtering-Correlation-Id: a2bb77a6-1db1-485a-fbd7-08df1e0e7dc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|7416014|376014|36860700016|1800799024|18002099003|22082099003|921020|10067099003|260925021911599003|260925021311599003|260925022911599003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	K743LyJM+QU/LAWYS+lipXfjraJEPtK+rCyqn6ae3kN5I+YgcS9gR6Ac5SQSxQH20ekfAeuPDDkKnfY5PC9dPhu0P92GfkW1Lh/TdVIxh/rAirclmVleCvS0lC/2+xLHSO2VabHWvQ6aJ4qPDf85ZzpI+Ov9EcZ3ybwzHzh4QK0Kv2HhDV7K87aeXeOJlsACnAc0GFAKUeVvhctTMmSzhOV2scQ9bWUoqsgsCG5QpqBcUq8bWYyxPVSkPZN56p8iFABYCt3uX6wrn/+96DyIvezXtJPYq+JfjZqJURofBVFxSdInGtdb9p0uGhua1WQCqQoQIaEWlTGpUsvmguBzns/0iplsUIRGSA8gFHPjFghK96cspox6j+bSAwNMe5eEa1d1EF0OS7DIqDo1kIlmlNnglEoCwCsklXxtgBa3QTGd5Lnv5ZLxIC+RzMLIATSl3EOsgL1gJ58//WKwt3Ih3FXVbEinrvOrnSQ5vOj3sKu+vLsRq+N+7WlxeF/rJi0zoajbODDbeIkIphmtGtgon5m+FlUY5KuY6uTmfWd/xR6amKyhaSx6tXKXWLjK4kWNxikaumzupaEvc7kO+rTNYoxi56yvw1Hj93RYwV6ja8JqKHcH6gAsk6hYZwF9kDi5ykR9aR8M/ZiIMlXR6v7pSN6opmNRcFBe0Q1Eh7b0oH2CKCJBLPctK8x6pLn+MX3h5XxVmlX7eU7poSO3lYj1tN8eLsomgYeBNszJ4ZMgjnDB8HQvc8+5xE/ED4Yzt0Ga
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(7416014)(376014)(36860700016)(1800799024)(18002099003)(22082099003)(921020)(10067099003)(260925021911599003)(260925021311599003)(260925022911599003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TVuYHa/VgJFgoifOdwR7osGX2PQbsVKZOzvimVWsPjDnHn9eL3/B8IBAVAkg1lUrj+H+pRX6UNRA+KM/AX2t9Okuja8ACtviB8pCK22YrkAhMseJNZ8cQvcaL3ag+q7SXekvCnpyRieL8uAyyEP/w84XfB6UPE8xfHezuNda7vc8wKKxzroZutqotz4NpsxeIh/2xbNA3xpx5I1HdBQPxlHVj7mNeMuvJB2/uWHdXtyr1DIZSVflFYd1qL/ebhwQWEw1nR9hMaE9zzIhf6NIEjJVyvnILFDihc0rcjppdBeeNprWojhf7IbfsI8q/gSF2FS2KyUmFNZBi6jKTVoXBXkvvhtw9Q17zXjDeJGd2/X6i6aJ4DIQkNft3yCA1nYOL5TjFnWM6HrrgWV/fsb+zilPKEz+93GSzfqxaIAVVx1f28gdACEsyycWVtCkBkA8
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 09:46:09.7021
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2bb77a6-1db1-485a-fbd7-08df1e0e7dc7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8006

Add a driver for the UFS host controller found on NVIDIA Tegra264 SoCs.
The controller has Tegra-specific auxiliary registers, clocks and resets,
and it drives the four M-PHY lane directions exposed by the Tegra264
M-PHY driver.

Co-developed-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
---
 drivers/ufs/host/Kconfig     |  14 +
 drivers/ufs/host/Makefile    |   1 +
 drivers/ufs/host/ufs-tegra.c | 686 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 701 insertions(+)

diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig
index ff170c0b6da0..7ca317d25251 100644
--- a/drivers/ufs/host/Kconfig
+++ b/drivers/ufs/host/Kconfig
@@ -168,3 +168,17 @@ config SCSI_UFS_AMD_VERSAL2
 
 	  Select this if you have UFS controller on AMD Versal Gen 2 SoC.
 	  If unsure, say N.
+
+config SCSI_UFS_TEGRA
+	tristate "NVIDIA Tegra264 UFS controller platform driver"
+	depends on SCSI_UFSHCD_PLATFORM
+	depends on ARCH_TEGRA_264_SOC || (COMPILE_TEST && 64BIT)
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
index 000000000000..f12265432592
--- /dev/null
+++ b/drivers/ufs/host/ufs-tegra.c
@@ -0,0 +1,686 @@
+// SPDX-License-Identifier: GPL-2.0-only
+// Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
+// NVIDIA Tegra264 UFS host controller driver.
+
+#include <linux/bitfield.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
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
+#define UFS_TEGRA_HS_CLK_RATE_HZ		5840000000UL
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
+	struct clk *core_clk;
+	struct clk *hs_clk;
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
+		if (!strcmp(clki->name, "core"))
+			ufs->core_clk = clki->clk;
+
+		if (!strcmp(clki->name, "hs"))
+			ufs->hs_clk = clki->clk;
+	}
+
+	if (!ufs->core_clk || !ufs->hs_clk)
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
+	u32 core_clk_mhz;
+
+	core_clk_mhz = clk_get_rate(ufs->core_clk) / USEC_PER_SEC;
+	ufshcd_writel(hba, HCLKDIV(core_clk_mhz), DWC_UFS_REG_HCLKDIV);
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
+	phy_exit(ufs->mphy_l1_tx);
+	phy_exit(ufs->mphy_l1_rx);
+	phy_exit(ufs->mphy_l0_tx);
+	phy_exit(ufs->mphy_l0_rx);
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
+	phy_power_off(ufs->mphy_l1_tx);
+	phy_power_off(ufs->mphy_l1_rx);
+	phy_power_off(ufs->mphy_l0_tx);
+	phy_power_off(ufs->mphy_l0_rx);
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
+		err = clk_set_rate(ufs->hs_clk, UFS_TEGRA_HS_CLK_RATE_HZ);
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
+	{ .compatible = "nvidia,tegra264-ufs" },
+	{ }
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

