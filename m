Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010034.outbound.protection.outlook.com [52.101.193.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903FC525A8C;
	Wed,  9 Sep 2026 10:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788950531; cv=fail; b=LyE1hjtV6GElM8m9AEGI3YuRGe1DLl2odhiiL92OY65kSqneXOh8TcgjjE/P3JqsowD4UuCVvf/DF4bA2F/b2zhzhWwJCdWOiG8Jwy5DEJcm1UV1KGA1TTSSNz0jdHWdMqXbzJh7bFxoeBcVAxz7p0skImEc2MNt82iaZbMz6yI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788950531; c=relaxed/simple;
	bh=LGq+kJMw6i/aE08zof2Y+AoMUY3QlWImKBYMNpy/jn4=;
	h=From:Subject:Date:Message-ID:MIME-Version:Content-Type:To:CC; b=oG0WtGhQ/ZbZFD+CJ8QmfGOA09EEK4D0L/hItPI2VSEPHEL/quOkuSnWwOmPocDyuZXagLWa2raqM6jnuILRnecX0xgFisBQhBjwcPPofnCzntuOa53UN80cdxtQ9NSkfg0Fmhji98tmb/JwKr0LkulnEX884s/mQHdxsiLhvdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kkn8OWtS; arc=fail smtp.client-ip=52.101.193.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kkn8OWtS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AXcCz/nYflXjpz9xKPcpf7JG3O8j+hxrarjleeOzSnN20ob51+9XoWDfSrSP/rDQ62qobHE7iWT85BYcJ/7DJj5B3ItqRNemLnIYkmMSEQKlL4UcW9gFeeGpOyJGF4rDWXEI6OB0AFyPxpPxoMRLPWUOPr/X9MO25Svek48is48X8k7RlP2MMcAr8uZJ7iUOz4GgYYgJCdqVqsxkIBhHLy+NvUJs0gRuJcqDFw3Gjn5WqzGfmsOj8+vWrK7KP8PY6KnFYVVUbmNwdwL6h5HzgvhIGLF3Kg4fkWJ/IToVihmGfAfJz89VgBt5ZKhvZC41hnqknaY44f6bZDRmy7pNug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=diOfMsAwkecgVqa2yrOHQzeaKxmFkyYDjIS2G0cYs58=;
 b=yaVNbtrtNpkcFIiPK1pFQi+DZdu9ezZfATY/RZF6hTwYYsms6mFcndHV3edEdsRpIa71raIIhMkZl7YT00peWVV5sgDbRJXhx7TeoKy5HaFJNaYzs/JAPcmViQp9neeDayyCK8VZTvp3ygajHKZcYl4Q8TOqvSujeCJ280FuF+IADSpI8WpFaFZfNUA2q61QvhFmbB4CM0OswTQwSeLcTo4SxoUMZYZXNC2/p8PvjRl9l2wzFy+9BOqk/FPpk5KmJVanbbOsyuAgOJhFXRPGtkexmJdHICttlWSKvMqXoP3dRzeggLgIX6FhT6Y6Jrxdzk0iww3bKt/czLtg3/G2KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=diOfMsAwkecgVqa2yrOHQzeaKxmFkyYDjIS2G0cYs58=;
 b=kkn8OWtShrnS7LzxNmt3zDyv67BswGnMdG626RFZOZimiD3QKZjzBsUlusTZ+Sxp5mjry59cyBjQ4vuftUrwmhkQmWPenQ8iZmjXkBMf334M9dOWyNfdCIheuusGlGCLQ1z57TJQXhGaWB8oul8HslNyn+9KwwJqbA05izIQ+WX92Pe7eTp+XlC7NW2Y2USATWuii3O9vBQ/b3PcfY4JAx69p1GhixogAKwP2Yek73ZM7Sxm0W+SVs2SeopteUn1RMtVjv7BqMfHEKPCxQ+HjmOnVsc2pL4CSXRunCcSSzpwDy2P7vZMNoPl1heG8vTxiUQnnI/zDcHDpKQnsJ2DVw==
Received: from CH5P223CA0018.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::25)
 by MN0PR12MB6077.namprd12.prod.outlook.com (2603:10b6:208:3cb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 10:41:59 +0000
Received: from CH2PEPF00000144.namprd02.prod.outlook.com
 (2603:10b6:610:1f3:cafe::49) by CH5P223CA0018.outlook.office365.com
 (2603:10b6:610:1f3::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Wed, 9
 Sep 2026 10:41:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF00000144.mail.protection.outlook.com (10.167.244.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Wed, 9 Sep 2026 10:41:58 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 9 Sep
 2026 03:41:47 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 9 Sep
 2026 03:41:46 -0700
Received: from [127.0.1.1] (10.127.8.13) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026
 03:41:41 -0700
From: Kartik Rajput <kkartik@nvidia.com>
Subject: [PATCH 0/4] Add UFS host controller support for NVIDIA Tegra264
Date: Wed, 9 Sep 2026 16:11:18 +0530
Message-ID: <20260909-tegra264-ufs-v1-0-e4a9831702a0@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAM43oWoC/2WNTQ6DIBgFr2JYlwQRULxK44KfD6WJ2gKaNsa7F
 2uTLrqc5L2ZDUUIHiJqiw0FWH3085ShvBTIDGrqAXubGVFCBZFE4gR9UFQwvLiIJQVrFa9NzRX
 Kl3sA558f3bU7OS76BiYdju8iwGPJnXTOfpm2+I+M9+GFXQXWCadYRct2LQ+NVhGwmcfRp7ZQ0
 tYGbMNkI8EQroFIzXTDaFNzCU4QxokiDnX7/gZeWoQu8QAAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788950501; l=1556;
 i=kkartik@nvidia.com; s=20260909; h=from:subject:message-id;
 bh=LGq+kJMw6i/aE08zof2Y+AoMUY3QlWImKBYMNpy/jn4=;
 b=4DkUn87Ay+LoGMDKElaFPbPudpt/z7NC1GtFjBuj+K81LRiN1dPr42yO7QlylNMp/Loi2dXnE
 ZDP6X0Pa+diDcZKYnCW82vdwHgRluOYCY9K7OIg8dyA7qo2wYbPxKHr
X-Developer-Key: i=kkartik@nvidia.com; a=ed25519;
 pk=V+1YkJqxCruxUVxLXtAG3f5k8O5skT0X4/QIB75KZ64=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000144:EE_|MN0PR12MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: 8895bd09-7d8a-49d2-4d2c-08df0e5ef9d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|376014|7416014|1800799024|921020|10067099003|56012099006|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	DeYcEhgtDn4sWe4iFUgjfU7w3ZDyfJ/Ono9J3eJAq30jpND0V6W0O2/cEsqga4REvsSoAg23uH0hTUhmU4lHa2+TZI2k06/88ETD6O+HD0Btrkdq82C7uIcBv2Zz5M7mto//1XfzN1BQy7VYGaVDuW1/V2V7j30F8/vvVKJ3JO419AJlcgo5U4pPamVZg9k2CWNaXMt596Aun+HgVw2h3wuieVPKiF/oaw9nc5APmSIGZ64qQzYu3Wnk6EbFfdE+WWfaySJjK7L/pMeXJiScHjhopNmC0G4Shb9N/rChpBS8rcj+2SKiCYNFrU6XW43yaqMXD1/M+Q3v+kh9biBym/zeRycmkak0sXZi96tYFbp93lJl1MNuPM0lvrxe+y6imW+1x1dO+YvGRsQsAQ/IhTU+SA0AFjYQiLFGdCTJFrz1aeOQQIxJJl6eSJ3joU9t0ScDCgN2mG6LvWl6PKwitPBYjjNnGeCfhcTxLRSij8KkBDXhrk3YzxDQ+dJa+3K6ecT9iVJ9HTDLchTa0cZ4pwz+EC9TDKor7C8Q2zXZlmA3PcCZztuP2JxfVXC/aBabHWaoN+2i3DTeSDe0KMy/9QeWJYTuyrM71WtQT9lCC1FKmAtuougCACcOr9KN1KAom163fSLC1dkfcSjvdbfiTgAgjXs6pMdV+cG6KkgGJlBUokZdECkUnSaV8qya83tLFAJkl8khCCYORanSGVt70CRLyJ/HcAVkGi0f74cq51MgmhRwj9bSyhj15hKaLB0r
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(376014)(7416014)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tx4wZDj7RBPswugpcXCjUULOLeKcaQO84D9q5oEWhY7lyQepFeXczqqk7Ih5E13V8oOy8xTVcbWabwTHIrpci3O740BXCLz3Ghp/6zu2HWBrh8bkDZXXdFI6rzGLtbGoqyMAFavMvGlzU2QifJ8GgdNh28pyzURrMdM0OP/9gyMMgbhIZ7MjVTdVjaTwlSbaqjhqdjQtdZ8KS/09cz7y1RiiwHYvnziPtRBbj9E9puEJ2nBYD1Lw2xlBUG53rYHqrZq2Pmn/P2nhctLEKyLVXtg+e2JpaeNsHV9ANUoRwqgYElr/NeKFQJPCg5NVfjz98WaD/Q0vY5rRA+Z3BADpY9GuoxVd5pOhW/gKfoOvANDQRu1un3+3mbSF153Mis6sQlj5KeBP7TXaczXxkbfGe5zXvNKRdTDUeWCm5Wl7Al6udSu/NBv4CMQufZeHgRd1
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 10:41:58.9757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8895bd09-7d8a-49d2-4d2c-08df0e5ef9d8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000144.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6077

Add UFS host controller support for NVIDIA Tegra264 SoCs. The controller
supports UFS 3.1 up to HS-G4B on two data lanes.

This series depends on the Tegra264 M-PHY series: the binding example
uses include/dt-bindings/phy/nvidia,tegra264-mphy.h, and
drivers/ufs/host/Kconfig selects PHY_TEGRA_MPHY. The driver itself has
no build dependency on the M-PHY driver; it consumes the generic PHY
API.

Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
---
Kartik Rajput (4):
      dt-bindings: ufs: Add nvidia,tegra264-ufs
      scsi: ufs: Add UIC DEBUGSAVECONFIGTIME attribute and its field masks
      scsi: ufs: hisi: Use VS_DEBUGSAVECONFIGTIME instead of a literal address
      scsi: ufs: tegra: Add Tegra264 UFS host controller driver

 .../bindings/ufs/nvidia,tegra264-ufs.yaml          | 124 ++++
 drivers/ufs/host/Kconfig                           |  13 +
 drivers/ufs/host/Makefile                          |   1 +
 drivers/ufs/host/ufs-hisi.c                        |   6 +-
 drivers/ufs/host/ufs-tegra.c                       | 687 +++++++++++++++++++++
 include/ufs/unipro.h                               |   6 +
 6 files changed, 833 insertions(+), 4 deletions(-)
---
base-commit: a9d7ced84989ec05be09b4b8428759ef60450a0f
change-id: 20260909-tegra264-ufs-92edda57c75a
prerequisite-change-id: 20260909-tegra264-mphy-f3edf6fa4321:v1
prerequisite-patch-id: 1c46e1bce9f6106dbabf81e50cd366d3d2da01fc
prerequisite-patch-id: d367971b99f7308cef032b436c054d005b94eded

Best regards,
--  
Kartik Rajput <kkartik@nvidia.com>

