Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010028.outbound.protection.outlook.com [40.93.198.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52784FC8C6;
	Tue, 29 Sep 2026 09:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790675158; cv=fail; b=PIq4AiPo3sMEPoXo6CCrcy8rZNyoBY1oTmSoEu9pbxPgo65NUlvJ434DJ7GxLG6ARqySApNqO23K91WrKWj5A0h0GwORdXx9e+Rt6bs1H4NkZw7hQeDSzmzqmYOMJovUYv+13995/dLoow1jqBoQjQoFwnnV7CCEZQ/4WpBZaKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790675158; c=relaxed/simple;
	bh=sigcM6tY9rKCP2HPdYtybY1i6lG8v8CnuhFkp9LYsTc=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=RApzgkucsWK21QrChnnp5Uu3rMnvR8a7QRkIxkDMjN8cZftOQTPU6WHaG5fJQMtov+USB+Lwh6nBikTgPSX346l4GEX4CMevH+valr6a7GUf0yLbPRaJaSmFoVTis0THLaqCPOq+LuzIU/Echanxk4lqTEhYrbhGy92rZDkq2/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aqrIgUdZ; arc=fail smtp.client-ip=40.93.198.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aqrIgUdZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wXUmhzrSA7gzCiUsx6sFONcmmlWPx7Rv0xcmNnuhMebbrjL3BRynYU9jYf6vTw/KiFn2ps5WXFNeJ7yTdfZ0cB7BY5GFd9OpHzYmELvF9QfThlRqlMmM33LME2pTxvfOw3VNYRhFoIGeLsWHVnK1QfBDXYLQM7znWAhkwLnr0nysMavXU6mrixAliEl7FK3JL1IYepWiflfR/YBy0Ot3jmxdOPKxMYvNP2WUtNpHKaHaRLDs5jKToXs2iScE1WvfctYjJOzGLZBV+C1gS2mdTHR8pWaDKjk8ZRwEZwEgFYYkdAi47Da4duEG+KgTVZ5fLXWatzRSv/uDOuL74ltVgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uu8AFH0UVOOPITwSCS4OUztLAtqkHVvJIRiA+/641yc=;
 b=Fv3FiB/XQm3ymneEMJ0bYXPFm7o1ybJ/WsL6a0U6GpuFxZt8t7BS99IYFxmqN53i/2G2lGxLJKlLrdwraD9KNrRvN6moyADmiVAyVjZq4L73S8ywlJa1UESWuLuMIapPAjTm2MVE9xyQx7hpu2gLWn5tE6ZkOi46jTCqhwtXvVMYR5TJVkEcU1YHDip6fS2wvuf0NtlOiD4Rm3Vg5seh2qhudXcOlq3pAmmXaiJiZaFkEtPYI+b8naX+uW4u9sqCmqHMxgiuHJe3jb9nTVS2b2Fq8lbOmeqcH639ONRubG7Ii+MR+CBlpxcctE4x2sv0q1IB2bzL8dHfTanROJZY4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uu8AFH0UVOOPITwSCS4OUztLAtqkHVvJIRiA+/641yc=;
 b=aqrIgUdZAuOdfTvXyuFbXhabx5iFYTelVL+EFYmsPX47RfJwb26vPHrOSLdVUepybmd+IlveC0sSAtUPKhx367i8ndZB3sfqVNWvIVio0qG9dYiRaOrtHTRx3+ItgHbnnQqcFj+HJjNd1XiTrgcNQYZNg6PzTEtFyJcCmLBLYlwzTXU7iGpLmGSdxUGhTj2LMnNZa4hSBOdpkdvRtfzacUHOlPZ1EgHUw31g/acA0j3Aavn2EqG4oLRdXmjtoetcx1UkxUtLCfOL/Al32+GmL9swAen3geC/XtnNaYA8m95nESizirr3+GAg9q7vQN8pRNnv+vjGvKuVFzYnZv/6lQ==
Received: from BY5PR04CA0021.namprd04.prod.outlook.com (2603:10b6:a03:1d0::31)
 by CH2PR12MB9457.namprd12.prod.outlook.com (2603:10b6:610:27c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 09:45:50 +0000
Received: from CO1PEPF000075F3.namprd03.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::3) by BY5PR04CA0021.outlook.office365.com
 (2603:10b6:a03:1d0::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Tue,
 29 Sep 2026 09:45:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075F3.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Tue, 29 Sep 2026 09:45:50 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 29 Sep
 2026 02:45:27 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 29 Sep
 2026 02:45:27 -0700
Received: from [127.0.1.1] (10.127.8.13) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Tue, 29 Sep
 2026 02:45:22 -0700
From: Kartik Rajput <kkartik@nvidia.com>
Subject: [PATCH v2 0/4] Add UFS host controller support for NVIDIA Tegra264
Date: Tue, 29 Sep 2026 15:15:06 +0530
Message-ID: <20260929-tegra264-ufs-v2-0-f0467b9c503e@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKKIu2oC/2WOyWrDMBRFf8W8dQUaLLnyr5QsnqWrRAVnkOzQE
 PLvUYZFoMsDdzhXqigZlcbuSgXnXPNh30B/dRR2vN9C5NiYtNROeunFgm1h7Xqxpiq8RoxshzB
 YplY5FqT895z72by4rtMvwvLYeCcKTmv7WV4xmrhChMM852XsnBksnApSwRsYCwwcojGO3bfno
 BKjn6z09OnXdP/ZzcfdRSSDmFzi3mg1nhVtbrc7ZkMca/EAAAA=
X-Change-ID: 20260909-tegra264-ufs-92edda57c75a
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790675122; l=2141;
 i=kkartik@nvidia.com; s=20260909; h=from:subject:message-id;
 bh=sigcM6tY9rKCP2HPdYtybY1i6lG8v8CnuhFkp9LYsTc=;
 b=u2vhbQiiBaniUR6NqiB6FKnq2wBOdW7dwIapB0NBMXTtMCbrLbmdk7t8v8AT1yPCXqnKL0Rgq
 j4H+8mMBQc3Cn+FEvBSqrKFX5rV4akG1D36quA5riaW3OuZ8y1neVmp
X-Developer-Key: i=kkartik@nvidia.com; a=ed25519;
 pk=V+1YkJqxCruxUVxLXtAG3f5k8O5skT0X4/QIB75KZ64=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F3:EE_|CH2PR12MB9457:EE_
X-MS-Office365-Filtering-Correlation-Id: 3182cf23-7b3a-47b6-e416-08df1e0e7240
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|36860700016|82310400026|13003099007|6133799003|10067099003|11063799006|921020|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	LmhJyPywliVh3eaUp1NA3ZEoV13WHfEptK9bU+kGd6mb146cYD/ift8twozka8wxr10NZmuj46lWWjqwcoJSvS0mE7zjJGMF0YwlbVoncG3ZbOaC0dLfJ+2Erg5++BZ0ihJ8I6ULmgTjZcH/59UcoCwoQShJxlx+kCGU2fVa3GASPCjpgSaX0pGwjBy0ssMQlVMT6HmYgBujlVSollmxGIFnzow3J+ssR8gnHfvOOmdx8QwXy3lver+J1xYr3K39WLP/eGyT4nOt+ITWTEeuUbBKUHSkg4u8rScX4+s7RGPmsOXqi/JN8ZAbAdWCyBKyIhOdk5t9MoBn2TpXIl0p0wVp58ROb1yJh71qbHx000DrbR5pRC35XKrbMamKyk0jwqJvcuYgrPYf3WaP5cL+G6JNeJyQNId+5QCKCPHeyGTLY6QPgYIc7Pdk1i7TsYYV+FeACE4l+5LJ+afwCJ7dtSTCHFTVPiC0Xn5mrpnpMl3FTg79eAKijHxX9qNaQ6oAESwNwYLIt87doabAqqHVAryKc3E9JzrbtK1gnF464FsKKg0ZPtW9OY1EJCXcsU6cKw9OoK5wdiTxTtiZVdRBbFyUvPupo9CuM1NW4udCkXXTLB6gQeKWmum1Hg+T2pChxU3wSuYo20DVAbv9CWZaE8zekF/CRCtFB7Loyz/82TI3N3CluanUqGVqkvZmBcyqEeCZSS68on2H3tDM7Z30ZPNjq701NRk6MBTMyNigV0jB/sfgpkcXlZ4ailUGAGtM
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(36860700016)(82310400026)(13003099007)(6133799003)(10067099003)(11063799006)(921020)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qQz9eROQlTinKLnZEte7MFITcUTYh4IVP76hY8XpWzcfSppieb9YSxFde9bExIbdVIXKOCk3cX1WnzhiiumnXHmti/3vlLEjrCVUaRp1odkbf5Fjsfh0RXwRAf9A2/qYfwQEMsyZokWeI5zjHg5L/G6CpJ4c6nipknh+eTSq7FbRccbfEQn9qsJUNZvMFQmsc8Zd0Li/5XAq/Jzf52UertJSvgXcwI/f+lwi+bC0wkTDIMd610L1hsx1A17BVYOWZEVJaiUchs+7vZuQ5WbbQum5m1WSQ2R65gJaYTENXEj3NoOEpQsJnr6xa7b/2TP3vSGHdR/mG3VSfjwd9pagfTGQqzPbSOgIyc51iFwGJIp7PCsYJESx+VsYOxEyLTiKQ8ioEOLka5pEXN3y248MUitDTY7mfxXeE3k6QRrbMte4xSIFhg0z5foTttCuhtBC
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 09:45:50.3606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3182cf23-7b3a-47b6-e416-08df1e0e7240
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9457

Add UFS host controller support for NVIDIA Tegra264 SoCs. The controller
supports UFS 3.1 up to HS-G4B on two data lanes.

This series depends on the Tegra264 M-PHY series: the binding references
the M-PHY provider, and drivers/ufs/host/Kconfig selects PHY_TEGRA_MPHY.
The driver consumes the M-PHY through the generic PHY API.

Changes in v2:
- Rename the UFS functional clock to "core" and the host-consumed UPHY
  PLL clock to "hs" in the binding and driver.
- Use raw M-PHY cell values in the binding example so it can be checked
  independently of the prerequisite series.
- Drop the unnecessary mod_devicetable.h include and clean up the OF
  match table initializers.
- Limit compile testing to 64-bit architectures because the high-speed
  link clock rate exceeds the range of unsigned long on 32-bit systems.
- Tear down the M-PHY lanes in reverse initialization order.
- Link to v1: https://lore.kernel.org/r/20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com

Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
---
Kartik Rajput (4):
      dt-bindings: ufs: Add nvidia,tegra264-ufs
      scsi: ufs: Add UIC DEBUGSAVECONFIGTIME attribute and its field masks
      scsi: ufs: hisi: Use VS_DEBUGSAVECONFIGTIME instead of a literal address
      scsi: ufs: tegra: Add Tegra264 UFS host controller driver

 .../bindings/ufs/nvidia,tegra264-ufs.yaml          | 120 ++++
 drivers/ufs/host/Kconfig                           |  14 +
 drivers/ufs/host/Makefile                          |   1 +
 drivers/ufs/host/ufs-hisi.c                        |   6 +-
 drivers/ufs/host/ufs-tegra.c                       | 686 +++++++++++++++++++++
 include/ufs/unipro.h                               |   6 +
 6 files changed, 829 insertions(+), 4 deletions(-)
---
base-commit: 6375e61c01e93e35ee7acd336a689ac1fae4b509
change-id: 20260909-tegra264-ufs-92edda57c75a
prerequisite-change-id: 20260909-tegra264-mphy-f3edf6fa4321:v1
prerequisite-patch-id: 1c46e1bce9f6106dbabf81e50cd366d3d2da01fc
prerequisite-patch-id: d367971b99f7308cef032b436c054d005b94eded

Best regards,
--  
Kartik Rajput <kkartik@nvidia.com>

