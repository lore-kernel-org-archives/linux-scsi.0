Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012027.outbound.protection.outlook.com [52.101.43.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B244FB9C4;
	Tue, 29 Sep 2026 09:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790675159; cv=fail; b=jDY9k3qEl/4B4jdml4ud74IjWd6cZyRN7OR+qXW8uabgVd36vW0uIVXP08UpQaZbWgHW3fHg8Zy1VcY2m8F1SPl3HmewVlrzXZ7GtVK7uUiqCknbxUaLus59m5Jn+Iq+re5aXHJfnuDPZ3YLgTrd5IJoO94D31atAukK2mQ2qb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790675159; c=relaxed/simple;
	bh=HtnnPlQX/u6rPuey3j2r7Wi0FUF4l5qVVVzQBEuCXls=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=VD9cDM0MOCAe/Mg/OZMWu2LAtStcgC/R0alQRG9zIBaehuPpt2qLiGJcQQQFUnRdWrofI7EhoVFMHdB4pOHzj3oaBcP2bMQ3SGHEydXNlib04yNF+umJkVk0xx5sAnVRhjtF2Jzwa1Fr1FsCtW6J52tO6EZDGofhv0jyIVUomt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rA/l2hiz; arc=fail smtp.client-ip=52.101.43.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rA/l2hiz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iYrYJsEQRBo2k15CriQh9HhZIA/EgtCU6QUPpk/JiazRDyD1cVLyJwFNjfynJsm827N9ROGk3xZLgy+DA71EtEyIldaldw2BHbvNm2FaVKpEHB0jqZmZ7aZK/0vyWT/fDgwJj8hAFJrEm1QJ8vKVdKM9O95X6lrkCCykU2/EkDnh1cBOm/kBqfzCMOaeA1M824s0fajR6cOigyGtj5/xehg85AY7o1TF54Bjf9SAy8o1EgETvHM7EywNDeI+9Ne8wjH33LmEem/TvkP1A/hB6tVao5ihbwoigjJ6VeAG53y17Vyfu4RQT01tPIMt5sr+AcYcTDFk6rBVyBrE/ajjqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZDDd1xX69wm+G54ddTZ/xrD3R6pogn8c8eXpA0vBoc=;
 b=DZ0sh2aG8FrBieLUBbVGzAVSLOxgMEBwFDV3SV6asjTVCLiYoqxUByDKvlPR5Z9jd4PElCb2/chSlwTw6MqP3ZoIK8mvKnwPWiuHw6fPk9iI5WaZ0pA1eMite8wttwF3OOIDgiRjrUq4zPhhVS1dMFrJIQgWHi/Untf9PbaK/nqQu95bKlUM/t/P+GCqhK95y2R+IvSL4VAxManJNRrQxBoffarH5qg+ncjoQWa8Hfljam3gBvwy2NaFMT6ehMjilWuZQ0Z8uzH7j21vdwg5VEI4bM7CWlWKjVAULJQkMyQIH81ugmM52g8KW3hIyYbVEkBrwn03vVs+Xuq4z4LfYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZDDd1xX69wm+G54ddTZ/xrD3R6pogn8c8eXpA0vBoc=;
 b=rA/l2hizhRg2WOAoO9YyuMKHUtccLzNFr7kcSMpb4Yu9e9NOVqy3HKXEM0zX9M+IHzkXWWt1zkTo3a5iWRNhaPruFGf/SurH28keiG10uVm/pRHcexIVO/kl4+bw+c33Dltn3USBd8KtuIm5uNnDk9G+xgIE2Yd9VVZhB8UBY+mvznlGmdlpflfloAPHDiqULI4y0yr/fvn0ZAibyDxe/M7eonWmIgMZqc6u4iie9Vovgkh4EE+ij+PJGi3ZtlYhIUSwZ7vRo3qRMbjF1SG8R45yH1NMiQwUvKCFpq7Oody/6EYxjicbfSumqnW2CKPvx+gTjbZ9AC4fAt77OtTY0g==
Received: from BY1P220CA0040.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59e::16)
 by DS5PPF7856D51FE.namprd12.prod.outlook.com (2603:10b6:f:fc00::654) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 09:45:49 +0000
Received: from SJ1PEPF000023D6.namprd21.prod.outlook.com
 (2603:10b6:a03:59e:cafe::77) by BY1P220CA0040.outlook.office365.com
 (2603:10b6:a03:59e::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Tue,
 29 Sep 2026 09:45:49 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF000023D6.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.3 via Frontend Transport; Tue, 29 Sep 2026 09:45:49 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 29 Sep
 2026 02:45:32 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 29 Sep
 2026 02:45:32 -0700
Received: from [127.0.1.1] (10.127.8.13) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Tue, 29 Sep
 2026 02:45:27 -0700
From: Kartik Rajput <kkartik@nvidia.com>
Date: Tue, 29 Sep 2026 15:15:07 +0530
Subject: [PATCH v2 1/4] dt-bindings: ufs: Add nvidia,tegra264-ufs
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260929-tegra264-ufs-v2-1-f0467b9c503e@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790675122; l=3896;
 i=kkartik@nvidia.com; s=20260909; h=from:subject:message-id;
 bh=HtnnPlQX/u6rPuey3j2r7Wi0FUF4l5qVVVzQBEuCXls=;
 b=MgYCzDdai7f76GE59uVGJ9uJBRLTuRsUy/2DMDnGMwm8Kq+6Q0UwkDfytpEVdJ/Fz0T/B3IUO
 p5TEfR9epq0AAEbIZEsYZzyNsxzfHHbLRaJ3D8gR3kRJYTq054DPql8
X-Developer-Key: i=kkartik@nvidia.com; a=ed25519;
 pk=V+1YkJqxCruxUVxLXtAG3f5k8O5skT0X4/QIB75KZ64=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D6:EE_|DS5PPF7856D51FE:EE_
X-MS-Office365-Filtering-Correlation-Id: 22aeabd3-6a5b-46ff-c289-08df1e0e71c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700016|23010399003|1800799024|10067099003|3023799007|11063799006|56012099006|22082099003|18002099003|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	csjHQ7nqVrka0DRQoU7rKL7GzyxeZDe8J9A3IUbdJl/LA1XbhIxx24xUSOi3qZmhLNrv9DLfEq8E910ElOTvV9FOB5RRle/enIP9eV6+AAAHN+D/Nb3HL0xPyltZ9phLVMlB2E+y2ibxZK9fi7d5qKnW7+V5jWPRy85fManNJcU4/Vcfi1PqsK/hN8qXcDgTNnwj/ePYMmOjsPA+MxVlFUd9S2KKUpQrHdTLE6HdleajyvMQb8FAvMvI53eS7XEpwlh/RZ1npyFCPOj7uETjjc9568qzqdmh+bDA1B+iO5n65f5RpMOO8hczmh56uqls4A401o6kGI+tp6VpUArh3HMqgU8ylUZSeTzqzOChzpinNJkXig5qgG+UXZklf9QNAtVZegl4ATI2xQSgZaEHMpMck+7qZfU8fTK7Nj2RJNIWIa+oB4wFaImR/oDKWFc5YGr+xNy1xaGJ4DgWeGXx1C94oQ9t4/5/cFAjF4yjOKjeu61G4yWSFB32GYrQr6N5i7RSi0BzuPPLLXDapzNXFvrg5CXX2CPKGN/lCS9WZ6xQ4100hjJF5k4Awy30hCT7sQmKTcCKTy7WXJEtdTY2JCf2/lVE1bCjG44X9KtDayjMAdr8grsmaHqtGbsaCyQsLkqttP47ct68I6jatBau1CNCHDkvXfnuVbzGPjdFQUZrTetGSYwK611Tzq8EnXMu3fmWikLWWS9dNNcDEJfPkpY/oYUnVgbqN6oBuFo3zuEs9CUmskqSljnhvqqm7a1y
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700016)(23010399003)(1800799024)(10067099003)(3023799007)(11063799006)(56012099006)(22082099003)(18002099003)(921020)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dFc4clHso5YmiforrkJB22eo3CDsbxuVzmr4B5+LiXDZBEvU5vw2hyIAZUxG6tFJrBmAAftFjgmrpnwsJ80m9GKKnkdGvzeaTHJeUVgmoGT755E5jo2wb6KK6DwwOY2PvCZYk7gf6qfRi1iBnImO6viNkBWuLLE91Bkqb8y++lRqhK6HLMDTxGajVLGRDgjTftSLp9Rr9l2Xm8FzcLq1J3QFpKjeUylj/Z/ChbNBPevlogc23GeVGmJwV/XBxVnVjJrjPiIjzjTUJpDSNgDLlQOgbouhrbcLwkHmtadkHKXuEYXKqmfOVYCxpwsSDF4RhQYSXC3ADMud7FBssktjbznT4ZB+z3iwbYd3AOpiIF/Ne5NKun+CgTksgbFZDMpteufMtUtR9IRpRMSUxc5otCtWUK4pk7gRk4hhPDx0rLPge9imLLVU642LHfMXIrGt
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 09:45:49.6605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22aeabd3-6a5b-46ff-c289-08df1e0e71c5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF7856D51FE

Add binding for the UFS host controller on NVIDIA Tegra264 SoCs. The
controller supports UFS 3.1 up to HS-G4B on two data lanes.

Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
---
 .../bindings/ufs/nvidia,tegra264-ufs.yaml          | 120 +++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/nvidia,tegra264-ufs.yaml b/Documentation/devicetree/bindings/ufs/nvidia,tegra264-ufs.yaml
new file mode 100644
index 000000000000..a6f3abd10c0b
--- /dev/null
+++ b/Documentation/devicetree/bindings/ufs/nvidia,tegra264-ufs.yaml
@@ -0,0 +1,120 @@
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
+      - description: UFS host controller core clock
+      - description: UFS host controller divider clock
+      - description: UFS reference clock (PLLREFUFS output)
+      - description: UFS device-side reference clock
+      - description: UFS high-speed link clock (UPHY0 PLL4 digital output)
+
+  clock-names:
+    items:
+      - const: core
+      - const: div
+      - const: ref
+      - const: ref-dev
+      - const: hs
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
+        clock-names = "core", "div", "ref", "ref-dev", "hs";
+        resets = <&bpmp TEGRA264_RESET_UFSHC>,
+                 <&bpmp TEGRA264_RESET_UFSHC_AXI_M>,
+                 <&bpmp TEGRA264_RESET_UFSHC_LP_SEQ>;
+        reset-names = "ufs", "axi", "lp";
+        phys = <&mphy 0>, <&mphy 1>, <&mphy 2>, <&mphy 3>;
+        phy-names = "mphy-l0-tx", "mphy-l0-rx",
+                    "mphy-l1-tx", "mphy-l1-rx";
+        iommus = <&smmu 0x20>;
+        dma-coherent;
+    };
+...

-- 
2.43.0

