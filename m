Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FD5525A73;
	Wed,  9 Sep 2026 10:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788950538; cv=fail; b=sCz14fXrJOiWzlYk2bv52q6IwTvIbpHIXwwttwJ+xqQL6jsJs/2b6wE0ln+Mirto6DJwGFhlL/MuYNJVjTmbeNEtbGutPzgCUf6DAcsyl68YAb14aZo/CmbqcS8SPY2ByaQkPo9vLgCAjrk4i+kT0QyH+y9WDFOQ68wVqAg1Oes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788950538; c=relaxed/simple;
	bh=jfmrEDlLe8dwwm4KqaOudeSbvnnNCIlLTiMUEly5UJI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=pj3DZYKedzzJFoS/IFy/fNHy6tmoif677oFogAfGK5Xx4GPNHzh+BwLNrkXQDdMhOm8NQx3Zx6wUpqwXQfsE3e8EWQ9xthNWiSxLSUeP+mS+nSUTlXij1FHoxans+g6ogIKfbVP3Ai+I9fu5KI24G3Q4lxR81hyWzimsdVT2chU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e0eEaYid; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e0eEaYid"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jUcf6n3WpTLXaiOID5/H14IGF87DEKwCydO7IWWsflJyD0ryOSd8xfbBCIrf9VgY2g8WPU5H0LfC36ut45Dv3zVlBmZMSQuBereAmo9VxuMToIKzQWo+FSe2aQjGI8NaW4IgVblAfzPVekMcKvRHAb/cidEZ0xYJ39Ee96FkYOYk/4fNrQAdxWv81drECI4u3rvCfTSB/6SsILkkwtlLpaLLWDUzPFFastVa4TFASQdNhFQHxWHtKADwav3DfCG+RRW1oZtCETc1CgO2Ctx4Xt2ZE/QtBf5t7GqssAnwPk6etkxHglUvWTSoRMEMJY2B6QXLy9MKUgT3OW0Bm5O5lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0ze9W3Pfi7GendXs7/339lP8Or1Ua0t4xBfTGakL3w=;
 b=GjFrpkfRCBNjPj56z7Mq/vjMO76Wd/XuUCkHeVH1mYVvGnvMLfYhZmgtRlUGUEedo3ZiUjrG/79SSmScXM+Noz4Ix/Atq2PW42FDU5V9+YGpoFrt6fgHE9YydK0r4SHBCnJHuZnPRqhIGTAyCFv6i3xf8gUuQKdNOrF27pRe0oExA1f+U9n+8YYKNn/Eoe0AXhFh6MpA9HxYCvim5i9xfFdggIOFjfQ6ThybVmMDJ+IgDlHgABKl9g0kgkMqg82SozACPTo2fao0IZkC60tjUOe1xwpFsWfNfN3eYRLq6S2RN8evqrBA9lggWI6o5hwojFg7N1cBAo03HPKp6eW+tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0ze9W3Pfi7GendXs7/339lP8Or1Ua0t4xBfTGakL3w=;
 b=e0eEaYidRwN8nxwomTgVTyLU/yrgC7lg3KlMGQio2YudazeudvF3cUh8PCY3fQT6Hg2CK7wbSNLBEmCOq4UhNEY0kbWxs/4i767dlvAl0YpWEkdRn70TyV7pBWW2zRto1qLBPNBd1vYrFsPgeCvvFN4iFB661xvkvUeVZHy8u6b24698jbO1z4jbmSeeXdAO28F4I33veba5uFcXXeSGUtNHU1xbL5Sv6D64HDdqfF1ExiBLgrVDpmYNVxnZGDugCqt/ayQT0yVqarnGr8+r2heIYmQVj40/qUrxbAySyBaMAXMkyWzFirDXpqTUq5xzLxKpxUTBP8n3hsCH6hLBJQ==
Received: from LV3P220CA0005.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:234::26)
 by PH0PR12MB5648.namprd12.prod.outlook.com (2603:10b6:510:14b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 10:42:11 +0000
Received: from BN2PEPF0000A88F.namprd04.prod.outlook.com
 (2603:10b6:408:234:cafe::55) by LV3P220CA0005.outlook.office365.com
 (2603:10b6:408:234::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.15 via Frontend Transport; Wed, 9
 Sep 2026 10:42:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF0000A88F.mail.protection.outlook.com (10.167.248.181) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Wed, 9 Sep 2026 10:42:10 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 9 Sep
 2026 03:41:53 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 9 Sep
 2026 03:41:52 -0700
Received: from [127.0.1.1] (10.127.8.13) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026
 03:41:47 -0700
From: Kartik Rajput <kkartik@nvidia.com>
Date: Wed, 9 Sep 2026 16:11:19 +0530
Subject: [PATCH 1/4] dt-bindings: ufs: Add nvidia,tegra264-ufs
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260909-tegra264-ufs-v1-1-e4a9831702a0@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788950501; l=4065;
 i=kkartik@nvidia.com; s=20260909; h=from:subject:message-id;
 bh=jfmrEDlLe8dwwm4KqaOudeSbvnnNCIlLTiMUEly5UJI=;
 b=XM/E+2YIdcVt/rqgJHL/DIDGLy9GGMYCofq/PudVimnP0IcXSnSqxrCQAw3XCbzyttBczbiM9
 sVIgMTSGpgSDeDCsciMgvY+Is2I9FiyRaJLpNvv9vNJhRcRCjIhefwD
X-Developer-Key: i=kkartik@nvidia.com; a=ed25519;
 pk=V+1YkJqxCruxUVxLXtAG3f5k8O5skT0X4/QIB75KZ64=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A88F:EE_|PH0PR12MB5648:EE_
X-MS-Office365-Filtering-Correlation-Id: aba08e74-fe07-465a-9823-08df0e5f00fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|376014|7416014|10067099003|3023799007|18002099003|22082099003|11063799006|56012099006|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	lC7HswqTu37pbt6znSXn8czNQFZ2x860t5jk/5NDUx89IPq/OTQSrRwFE3R/HA7Guzmm7hnP3k4DirGwb0V6QWZHczDqInEqhb5Of7WrPetvMu5FkU50/W+BmZ6Gb0i/hKq1PFL0DJwyXXmSZqeAUTQVfvlxaUTdf/tGa+wQzH3LEeFWSFNybJEkjw/DPUfup71vHI1h397lDx36hNYv2g6uGc+dTtfSLGteiuGL0QEph7DySNElbe3O8p8VD45TEn3nV9N7BG7fr5QQtexLhAgvkhrYAO8I3xpDlnPTZNIsczeHes8kcC7hI2AxCKW7LUL+oIi25eyGK2Dvsf6CwX+A7VZg++arv0s2EAyeULy2d1x/dBFH+qlZMpH2qbmNyT8ibssttI4EYYmm82W6xSBmaN0EWvv6ysTyOCUjilMN2sdsGA74fZ74zABBDY3g2bwVpBZFKe6ZvYXgzzCpW3Mfbs4xAv8g27lhPSfNHyNp9ZgE4NUkrpA9s4nC7OQChXl25ZVrtC6ZkO6NFL26hkakPvAhOJLVxdufgrxdhyg6043uhYJqQanIbnPg8wDKIoNnxaCEuFhiQo/ZLY95z3eKPfzLcS1DWGT/sgNbuPfvNutfGSY35w53585xjPfsQCD9pXpHx4BTWwYMi7k9XHb6x2R914F52HG77u1vD5aiatwLGr2ItPmrcZgfFEN8RSFJhzWYzL7mW3WTvFGPc4RpqDRZFkY0aCgVx5jsXdqDEp0Tmymn9sF8KAPK0HWY
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(376014)(7416014)(10067099003)(3023799007)(18002099003)(22082099003)(11063799006)(56012099006)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mFQMLkBXc7ckh7YtUODvd1pIgmz3RyBicWZUJ5leIxJjttvGSdMMoL9kpYZ4ofz9JW6Yhj6uh4bjO7O4p5k80iXNEXOJUTRHSp4t1fWPrB8wRR5Tc73K8wVDhawVnWkhzKoJu5gd5tufxI4opxCkHrECq4a8uKSpajBotmuSmo8l0rhfnIrx+hYoB/Ic2d5CW44inA/zg+hyt4VR7KP4k94CsEyQSlKVfLjAN7ZmvUlqk6p3aKz8/ErCsI7zgk/R7Pf6Qnh5FM4MfBAjHlnCXjb8CKGvgv1UixObtFAcKeIp8LtwaSmZV+hH44RA2jJJvFtC2voJM8VXBuuNvgSapI34SDgietUhxwaSVazsMPUj0b6wrgI3MbmAo2wJy1hAEpYFUEvUqCI9rqGBnXODlvxpNQOS0a74ms7e7KDL0hs9s336udW1oPi3+je+X5y5
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 10:42:10.9357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aba08e74-fe07-465a-9823-08df0e5f00fc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A88F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5648

Add binding for the UFS host controller on NVIDIA Tegra264 SoCs. The
controller supports UFS 3.1 up to HS-G4B on two data lanes.

Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
---
 .../bindings/ufs/nvidia,tegra264-ufs.yaml          | 124 +++++++++++++++++++++
 1 file changed, 124 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/nvidia,tegra264-ufs.yaml b/Documentation/devicetree/bindings/ufs/nvidia,tegra264-ufs.yaml
new file mode 100644
index 000000000000..5a9837cb43dd
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/nvidia,tegra264-ufs.yaml
@@ -0,0 +1,124 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/ufs/nvidia,tegra264-ufs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NVIDIA Tegra264 UFS Host Controller
+
+maintainers:
+  - Kartik Rajput <kkartik@nvidia.com>
+  - Thierry Reding <treding@nvidia.com>
+
+properties:
+  compatible:
+    const: nvidia,tegra264-ufs
+
+  reg:
+    items:
+      - description: UFS Host Controller registers
+      - description: UFS auxiliary registers
+
+  reg-names:
+    items:
+      - const: ufs
+      - const: aux
+
+  clocks:
+    items:
+      - description: UFS host controller functional clock
+      - description: UFS host controller divider clock
+      - description: UFS reference clock (PLLREFUFS output)
+      - description: UFS device-side reference clock
+      - description: M-PHY reference clock (UPHY0 PLL4 digital output)
+
+  clock-names:
+    items:
+      - const: ufs
+      - const: div
+      - const: ref
+      - const: ref-dev
+      - const: phy
+
+  resets:
+    items:
+      - description: UFS host controller reset
+      - description: UFS host controller AXI-master reset
+      - description: UFS host controller low-power sequencer reset
+
+  reset-names:
+    items:
+      - const: ufs
+      - const: axi
+      - const: lp
+
+  phys:
+    items:
+      - description: M-PHY lane 0 transmit
+      - description: M-PHY lane 0 receive
+      - description: M-PHY lane 1 transmit
+      - description: M-PHY lane 1 receive
+
+  phy-names:
+    items:
+      - const: mphy-l0-tx
+      - const: mphy-l0-rx
+      - const: mphy-l1-tx
+      - const: mphy-l1-rx
+
+  iommus:
+    maxItems: 1
+
+  dma-coherent: true
+
+required:
+  - compatible
+  - reg
+  - reg-names
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - phys
+  - phy-names
+  - iommus
+  - dma-coherent
+
+allOf:
+  - $ref: ufs-common.yaml
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/nvidia,tegra264.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/phy/nvidia,tegra264-mphy.h>
+    #include <dt-bindings/reset/nvidia,tegra264.h>
+
+    ufs@b8d0000 {
+        compatible = "nvidia,tegra264-ufs";
+        reg = <0xb8d0000 0x10000>,
+              <0xb8e0000 0x8000>;
+        reg-names = "ufs", "aux";
+        interrupts = <GIC_SPI 951 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&bpmp TEGRA264_CLK_UFSHC_CG_SYS>,
+                 <&bpmp TEGRA264_CLK_UFSHC_CG_SYS_DIV>,
+                 <&bpmp TEGRA264_CLK_PLLREFUFS_CLKOUT624>,
+                 <&bpmp TEGRA264_CLK_PLLREFUFS_UFSDEV_REFCLKOUT>,
+                 <&bpmp TEGRA264_CLK_UPHY0_PLL4_XDIG>;
+        clock-names = "ufs", "div", "ref", "ref-dev", "phy";
+        resets = <&bpmp TEGRA264_RESET_UFSHC>,
+                 <&bpmp TEGRA264_RESET_UFSHC_AXI_M>,
+                 <&bpmp TEGRA264_RESET_UFSHC_LP_SEQ>;
+        reset-names = "ufs", "axi", "lp";
+        phys = <&mphy TEGRA_MPHY_L0_TX>,
+               <&mphy TEGRA_MPHY_L0_RX>,
+               <&mphy TEGRA_MPHY_L1_TX>,
+               <&mphy TEGRA_MPHY_L1_RX>;
+        phy-names = "mphy-l0-tx", "mphy-l0-rx",
+                    "mphy-l1-tx", "mphy-l1-rx";
+        iommus = <&smmu 0x20>;
+        dma-coherent;
+    };
+...

-- 
2.43.0

