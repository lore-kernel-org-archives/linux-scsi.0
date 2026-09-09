Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012025.outbound.protection.outlook.com [52.101.43.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C246524B07;
	Wed,  9 Sep 2026 10:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788950559; cv=fail; b=ltTVlPmgB31VZnA3uWOy/UNzoaOkC7LCVe4X09SoY4/6irXaT0Ix2KrJ8jM+MbIv2EDX4WMRFc0N8krxIV66aa1J4FeoNXWAInTggH3UA/io05/jIjEGic2vhhxoQ+DQuTI7K9y6BMho/3s8cKEx0m1apfF6eSnYGAh57XuLcAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788950559; c=relaxed/simple;
	bh=YvBjtQpKm5hFuV7MI6SjZHl8DJWxia46EP/a0/+z2ek=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=qj8wu1nx2rcSYpektQHhaSRT2EtL9pJUZ4AtKktMxXGlPNeNNA/ZztkmE19g0Toz5iZE6fB2Fd4PhvMGKciqaYK1SFZ0HqtNamxe6YRoJachdDZ9ipy1JXNs9SRSahvwG/OOC0rF0Gd82sCj5muV3+sRlDxU5FnLUNIhByx0dHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G8jtoWju; arc=fail smtp.client-ip=52.101.43.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G8jtoWju"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ksr5dnhAyKjzcrt9Ge1UzZOpeLkzGkTL1SRe+ytYeUaTlPTWxIh5WNlSa9DaL9RV8/gle6ktDqyyoEsbozHpaGLM771zcTZBbA99uWHbmbwyxL6gozMf17ik6vofPS7nZ9oaehWOC7jfQsyVLNtmq42PeGR4g02S9g3EXqMGG6eIHyUXzRDSViS0Jbe/xlbIEBFRIKmc9DW7+lp5D3bZExpThUPOUJUNeVTqlTlCu0DdL8IRB/DS1cbqznYhCKwA1+ZH1/El2jnrHBv62C7Aa4fOa7GmAgeuqn6DkPx1JdmalzwgQgpxoAAr+8vqE1LOtyUFOw7nvKHTbymIOji4ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUJXRH+zi7fsqjCPKNqrSqmR2a+g5Zxjxb6T+mmtT8k=;
 b=ikSUdjLckndjJqkNpyWA9H8FksT1xsnj+BtgjHDGJwz+8DzAbrqxhQVZYTFD17VbsCHZUh7ljI6GaBN7SI3spi5H6NBMNQYMvcMjDJpcWWPCygprzkDw+S6u3LG4UcAy1hfbGf7l+pVpLJ7KmCwu7zHUzDPEMnZ48ZUteRL33/SQILPTK9IQtFf9MO+uSz9hVuDqbP7XGhnVWzA6qyGMt7uehCuZM+zpQm4RFI1pfeRfSa/xVDKxg70ngM5eCypSoLupnJPyOzGBgbYD9nGiLg/gUPa+euBX7+UGqQ05jSW+RsrcHT8G5a5U5d1yoSbEOWPwV8lUWVss7hNjtNkOgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUJXRH+zi7fsqjCPKNqrSqmR2a+g5Zxjxb6T+mmtT8k=;
 b=G8jtoWju9baMR5Ge9HZ7e/tPia/8+58zZhbH4e+AocNNzUGFg+SxvkiMqXOctp3L2Wbo97blHLKzM5Np6xbhj145+fY+JAXUJNAJxHE3chayP12YfvPMHmCZNo5p/9xRsmK00KylL6c6aSuq9q3FMmOfaAMcpsc0P9Ro4DlRZJf4ANDj59BqIatfu0+C2wXXiWY/d/qBpl7JJd+nF2odDG2qIPhiSm8QT4TqdFsOWN3smiy+XRD4AinAOHrXtXLJxlIwptjU2eo0ODTsKtwR2Em/jjKzjsIrPYHO5S4BRKHCijHVXpNeTPyCFAYrDtDwDeccbk7UQwV9kPnaB6lM5Q==
Received: from BN9P220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::22)
 by SA1PR12MB8887.namprd12.prod.outlook.com (2603:10b6:806:386::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.11; Wed, 9 Sep
 2026 10:42:24 +0000
Received: from BN2PEPF0000A894.namprd04.prod.outlook.com
 (2603:10b6:408:13e:cafe::8f) by BN9P220CA0017.outlook.office365.com
 (2603:10b6:408:13e::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.8 via Frontend Transport; Wed, 9
 Sep 2026 10:42:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF0000A894.mail.protection.outlook.com (10.167.248.186) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Wed, 9 Sep 2026 10:42:23 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 9 Sep
 2026 03:42:04 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 9 Sep
 2026 03:42:03 -0700
Received: from [127.0.1.1] (10.127.8.13) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026
 03:41:58 -0700
From: Kartik Rajput <kkartik@nvidia.com>
Date: Wed, 9 Sep 2026 16:11:21 +0530
Subject: [PATCH 3/4] scsi: ufs: hisi: Use VS_DEBUGSAVECONFIGTIME instead of
 a literal address
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260909-tegra264-ufs-v1-3-e4a9831702a0@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788950501; l=1550;
 i=kkartik@nvidia.com; s=20260909; h=from:subject:message-id;
 bh=YvBjtQpKm5hFuV7MI6SjZHl8DJWxia46EP/a0/+z2ek=;
 b=FciAtJ2xniuBD1TWeVTskTwggBx1WtD3ZEvTTz4HC2xzjkN5/9X3hkwz+P8jPxVhHVthpQma1
 Cu0rTla1qn9BsXKOEVMvz/r3tPX5NuAXxuQvWo0335BIHD12a//YEJL
X-Developer-Key: i=kkartik@nvidia.com; a=ed25519;
 pk=V+1YkJqxCruxUVxLXtAG3f5k8O5skT0X4/QIB75KZ64=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A894:EE_|SA1PR12MB8887:EE_
X-MS-Office365-Filtering-Correlation-Id: 295f7b33-7665-4744-8f02-08df0e5f0883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|1800799024|7416014|376014|921020|18002099003|22082099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	wJw50BezoqJFSzIfyKGa9uyvLxqGBfi46Gtec0wads2iEq/pCoTAjTbotzO8UTylRmlYhvVIbXissMJI0eznvubtZ1wrSIGZ706Ajdw6vnBx+pYKtU63xc7nMi9aWQz8c86Eiz5Nl2us+ujSKutlFcTCUtT4fC6YdoWWdY3LVVhlUeMtShDT/fuhyJ7RcT8SINu1+WnBlFrUtqPhGMa2NrV+4+aU87GGC91CAk6x1CzrtPaHgnQAZvOZTFtcXvj0Y20CuAV9zvEkYZ3pjViwxvoPzZPtgJwysEtGCNU3TWXkdw2Rsk63rBlBJLU3n0G4HFmVF3ye4CqqcbhVpJHdwUd/sFmHa0OFuUDbPKh1qsPjs4LqTWE7zyBK8tD/Ytxrpw5D+TlgBKEyV+LdklNdMMmCXdoHE7mid4Ge0B9Nr9bmlYr/utcnBwpZXVju3zT9ILB0esPmLc3DDgosyS+RgD4gtZSeZ6Gdxx+AlUke3VnHh7+V17tOvkGywt92EUur0QIwTsLe1bDniNJCFreiphcwjD+b7nbI7w/fMba865o0C87LZjd2juStOpST5cFJALKRw9keJ6A/1LXTghCOOmi7lgYzfbbbOhiJy7foXn2iQ7OO4uhdBjb9B2orPaY5tJuHfpKMMPLa3/u4nkGJVUuEAm431E6IkjvcDgj9a7GDnvSSPL/VVmjpsT+RBM6DJtE3POn0zkgJbhjnVTAwQV6CJW0Sph/nfJeyy8oH786bcF8XGjOqKa53QDR84mg6
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(1800799024)(7416014)(376014)(921020)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FnEOQ+QjVcU2XS/y3YQDpDMey7CeDsRcvFt0oM1pT+fo6SIv1YFHaRtEFYd/6mSP0dqRPsnJ9GIbsC4/LdbBcDKuiTdM8cB0MVLXT2d6me7KEt9gwkKDBjWbkhvcq9Nsw97kGqZvDC8usfN7nxhsONb9347u4k/eGz6dqO12mCE5JWa5lcbQkt7se55L4pPyMWIsFO3Ofmf/xAitXe3H0xYbstNjCzRz0qeqTXCV0/EK/BOoxX1e/ktxcHF1yPlxCofed/55XpcFuLWX+PLzgdxypS4L5VS6sXaXJCGX32co13TJhYhifxazo10PyYfAOyvZtUBvqEiM3xLSgxz3/GzWpLziN25aSFh/wFbKBo8J9kcvYa00Sw4B1/T3Xp5c0hNVCGlo/hUpxc4AImKUUbSMGJ8onEA9F/LHvS56X1TYmsbu99R98ZAScrcPB4cW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 10:42:23.5644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 295f7b33-7665-4744-8f02-08df0e5f0883
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A894.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8887

ufs-hisi writes the VS_DebugSaveConfigTime UIC attribute twice by its
literal address, with a comment naming it each time. The attribute now
has a name in the shared UniPro header, so use it and drop the comments
and the redundant (u32) cast.

No functional change.

Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
---
 drivers/ufs/host/ufs-hisi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-hisi.c b/drivers/ufs/host/ufs-hisi.c
index 993e20ac211d..79417c16c627 100644
--- a/drivers/ufs/host/ufs-hisi.c
+++ b/drivers/ufs/host/ufs-hisi.c
@@ -318,8 +318,7 @@ static void ufs_hisi_pwr_change_pre_change(struct ufs_hba *hba)
 		 * Boston platform need to set SaveConfigTime to 0x13,
 		 * and change sync length to maximum value
 		 */
-		/* VS_DebugSaveConfigTime */
-		ufshcd_dme_set(hba, UIC_ARG_MIB((u32)0xD0A0), 0x13);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(VS_DEBUGSAVECONFIGTIME), 0x13);
 		/* g1 sync length */
 		ufshcd_dme_set(hba, UIC_ARG_MIB((u32)0x1552), 0x4f);
 		/* g2 sync length */
@@ -335,8 +334,7 @@ static void ufs_hisi_pwr_change_pre_change(struct ufs_hba *hba)
 
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME) {
 		pr_info("ufs flash device must set VS_DebugSaveConfigTime 0x10\n");
-		/* VS_DebugSaveConfigTime */
-		ufshcd_dme_set(hba, UIC_ARG_MIB(0xD0A0), 0x10);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(VS_DEBUGSAVECONFIGTIME), 0x10);
 		/* sync length */
 		ufshcd_dme_set(hba, UIC_ARG_MIB(0x1556), 0x48);
 	}

-- 
2.43.0

