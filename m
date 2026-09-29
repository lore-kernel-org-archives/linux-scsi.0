Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012049.outbound.protection.outlook.com [40.107.209.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B34F4FD266;
	Tue, 29 Sep 2026 09:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790675174; cv=fail; b=OO4QcvOecsi06CwvT5Aj+B+2ClOg6TCw4ymcBzpbfl4X8PIxnAdUeekTSOjTmYiqYOjdp5xCuhNNpbqA6nF5jhgNHfwRvoG+DNcpg8mqKIhHzrDIQvR73bOYrvbMTeTPGg/tT5fzQmwTY4o8UAeWI88zE1IkKLul1ss34oEorTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790675174; c=relaxed/simple;
	bh=YvBjtQpKm5hFuV7MI6SjZHl8DJWxia46EP/a0/+z2ek=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=aynlsAlv9c0pfrhrauQkCVwOKDUtOQyNXF7x7a3ptiY0bAfPGquxsKgZuHy8N1LYCxNM0CcYIubBd2EY3fh3FmClp6KAQlppReIG7QHhgOJ4HwP4e0Kb5uymRZxfng8yrAslmHN6y54oQw3b4jXDrHV2fZAAzD94bvdsnuucV7M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NrCyDrsL; arc=fail smtp.client-ip=40.107.209.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NrCyDrsL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s4tVsPtbSIbt9486q8rA5OLo5C7X2w+DIJsJuBCVZXHEFDcxm7eBdV6DP8QMubxt92m46scmvWjHcfsgM8fDV9wjbd5LHw3lG4eghFl57YkRU/XpUTaKWobPCRiDY1o2YmOGRfukdmZnWNxQcSvquOpmLgWqU3CKQ0vemWm+RtefIQQL5aNGC7uZN6DVh9NiHXr201dqEXVnazfHNiA3Ne1IiBnFod84aB1XVn7kpvKTujNq9rm3I4xjndfnhuTdBMOYRkLL6mnPmE0eQWptz7N3LqNVToivGGgrC2LkDMvBePu/zv8FedbVb1O76umrtSHJmqnnf9A9OK7BdeoypA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUJXRH+zi7fsqjCPKNqrSqmR2a+g5Zxjxb6T+mmtT8k=;
 b=XhvrmAqPsVEMIQtwRwFWu822ew+4DoeDSWVXF3fzQNrAFs4rdnS81K16jMBGBijM7ec7uscYj4rCbjeIdNwk31iYZtZ3qB2o56PtMcJnwpPezPSswfWnnMYayVb9zKoVWe7b56bmh2JxALT6HahTkYQjX0X9Mb+LRZYn1VjyCpveXDvGpC5TzGeW6/2nvYGeziLSqJpc+f6SSVDopPg23iFkGh/F1p1EoiEl48JieFZaj4xBMWO3ROc5Z/0wCEITWRWLQ+Tz1P+WAqOj1fTSE0k9gECkzWjM9Vamezv5EKyTJfeBq9OCE2EVaaew6V46r40lQ2gO6LAkgx4Ra/2dww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUJXRH+zi7fsqjCPKNqrSqmR2a+g5Zxjxb6T+mmtT8k=;
 b=NrCyDrsLKjC/wWkY6n1rpEwLBetO7OkLPnfRfEL5Zjkcpy7YfAmiPi5Q8FKdVPnFFc2HUzxM9cWf3UQtTqy7UtPGnhc2uYvP8VfntNSrAlMYfJtbCl87XvYvON5BNLFgVv7uEfHWAPjbnmVY/KEahCBZWhUbovQWVIFHxxC7av+GVAxTL44AJXDajAMCi9b1Y9/haocl7lRjt6E9T8kPX9zZUdgRu/aN9lTD0zKzTrtKdrAdRaEj90FlZBqjvGU5uZD3klATRZ7Uv7fiJEuNdjMD6/WngnTwdlP9nPxoGXUlaTvQFJDNhBI/MvJNyGNWQQa2DN+W8dxoNzMF0stA/w==
Received: from BY5PR04CA0011.namprd04.prod.outlook.com (2603:10b6:a03:1d0::21)
 by CH2PR12MB9459.namprd12.prod.outlook.com (2603:10b6:610:27d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 09:46:04 +0000
Received: from CO1PEPF000075F3.namprd03.prod.outlook.com
 (2603:10b6:a03:1d0:cafe::c) by BY5PR04CA0011.outlook.office365.com
 (2603:10b6:a03:1d0::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.24 via Frontend Transport; Tue,
 29 Sep 2026 09:46:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075F3.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Tue, 29 Sep 2026 09:46:03 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 29 Sep
 2026 02:45:42 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 29 Sep
 2026 02:45:42 -0700
Received: from [127.0.1.1] (10.127.8.13) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Tue, 29 Sep
 2026 02:45:38 -0700
From: Kartik Rajput <kkartik@nvidia.com>
Date: Tue, 29 Sep 2026 15:15:09 +0530
Subject: [PATCH v2 3/4] scsi: ufs: hisi: Use VS_DEBUGSAVECONFIGTIME instead
 of a literal address
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260929-tegra264-ufs-v2-3-f0467b9c503e@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790675122; l=1550;
 i=kkartik@nvidia.com; s=20260909; h=from:subject:message-id;
 bh=YvBjtQpKm5hFuV7MI6SjZHl8DJWxia46EP/a0/+z2ek=;
 b=nVrH/O+ZwBlpsYReX8J76eSSeIpskLKPbxPmLdaXm0vQL82WAeaTAQGpZ5zcG45NjlNVTzV5y
 nOeH2atIIYlCfnOyN8DJSAc49AQ+ekcEb7XqCZeysKbcujS2UTGGrpT
X-Developer-Key: i=kkartik@nvidia.com; a=ed25519;
 pk=V+1YkJqxCruxUVxLXtAG3f5k8O5skT0X4/QIB75KZ64=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F3:EE_|CH2PR12MB9459:EE_
X-MS-Office365-Filtering-Correlation-Id: c24f1ae1-ffb6-42c5-2336-08df1e0e7a29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|7416014|11063799006|10067099003|22082099003|18002099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	BivUD08iS3JqomQWnCeijDcl8hAjtZAexqIGhfS5wV60V38mH5eS1tlwI3WOVuikvuZTQt/clwbUv7680CSwHu76YipimzZfDw+fvFao4xmoJE/6+jz1ChoWFup4IGfuqO+He3MAeCVslP/YfuADJ+K9NwlAMkzDl4B3iI88f7NqBZZtl8RpZXdbn0DhCuXEw9tQSKbnNpPBP/mocWtkR0zfeAFvohEJAsgtCzdZnkEIUH7zYTva6nJDNvsbBzSr4qM+XmMwq7KTuTfz1Qden+554fDaWsglKfZ/AFt5ptopPugQvDGXmNvMPkKZ0LUllJkmqBKlzemwt/0VkROT/K9QC6LIuQ8dc1kCIszMMKyy0FT4NtQheiTx891nmD/tw97oKj9QJUeMjjMagw4eW5fuEmFO0sJNbRKzKGczIX17AfPRuZsTkyA1g7bbjqT+OLf5B/qD9qU0y7kryeGB4Mb19wY/Y2nilzaz62oUqOMJlTqFutJ6xmpyPc+fQF5CGinNZp9ZOSjyFcKoLvAkPZ93iin+5z1nEcScPiF+/6F/wSHwoF5C05lmMns20xMTCWqoYtwU/kfqFEuJZ+Ef6gh7HfXjRzX6QME/2cBsm6XuOtMr2DGz4HeA+QtbUed/UFQjLPIY0OhLmnDD5p4MAWT6cy+Jk4PQQfTy37Fkw+5oLX99PjsFOOf76XXtiGV5UQHHFHZ0gzMV2q8iClYBX1zROWrvNUETdKtlWONv87rE8ryhWmCoqXWyrXyQXEKs
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(7416014)(11063799006)(10067099003)(22082099003)(18002099003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+12ovVukuBk2z1YwpKXmkW3+eFZtWenAd1EYzl9HKHL9YaaD8QWr2V7GR8LjhZKt9ACHjeYd972j99lt5OxJVSVEmNllEU0JpCe7qLamdiGvmpaVgC/lzF6TYSElXAu3R2XuFpXbXXSv6lGf/sUWbRGXcHqckKdmKRMPZ3wfK+Qz+M2DEJ4AiADspj7wo0T//Bl02Hh340rQ4fdw2QfwXSIvwVewpU16mFIb5KIOEzPsktgHitTLNcRatStjtYnua5YwoHdbRVz5ipYTDo1pg67I5Ez0dVx0gjvNM4bmO26ue/uRwJMopoC71KVgFhPkOQHTe6mcS/CUTs2LeOsTjcZd+vaD1tfSbzS3RTRXt0jPt+yYtvLu0GoYA9WhuvLpbTN+N7eYPq9aamNTGdzklMQfy9zBOmAw9VjMiv6508Ddu5NgQDQ4/aVGqtILhPAy
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 09:46:03.6331
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c24f1ae1-ffb6-42c5-2336-08df1e0e7a29
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB9459

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

