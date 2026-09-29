Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010006.outbound.protection.outlook.com [52.101.201.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C644FD271;
	Tue, 29 Sep 2026 09:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790675167; cv=fail; b=d/nD49jE6cABBIPYhhCfKcelygnif8ef5r1Q5oRePhi5zkHBb1d8KFVaN3O4l7/v8ZsDEdbwzdhUA9fQ5BAlINdcLnIid1jRoSiy0Vfa0fB2sxkAyoxLBMODtV9n9hNXRLEGEvMvCW6+uhRxYOwVwXrnHOGnjEXAO1h4qxfNBuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790675167; c=relaxed/simple;
	bh=E7H+llcHhG57oqmNTC4OPep7Os9a8YtnhBGzki8X/dc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=ImE2h2p2bjSFrD3ZP2dgTwGvztD83KWRRHJuMsPMdhyA8U4ZSo9LZM89EYzZNSgvhEiV4l5+q40gMF5wlv1uFha/9AhVi3c4gjxu/G19EkvIo+HBLuzCUNBpsJkuBP7GHk91BsXwaQV0f5RguPhHQ20KrLX69kyyWNMfgqIB6Mk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UdkLMXQd; arc=fail smtp.client-ip=52.101.201.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UdkLMXQd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f36R57qkQiiMzwGloV/ld9r0idcaE+rDErTQa3BwuS7QlefPIua2tw9NzSV+dTmbhmD8fBKMx2rJRze1ZLctKmmskxX1yx2aBLlezKFgD1lgO80PXQg1dgEee7gk+i1l5r4xtfgSpY85UnBlwHR9a1U0zf2vwAmJWkeKIbhKYJKx1BVhhS4drmcYLimFazB5P2aHeE5PoW3z3Yfhezkla6STZ6mook4Ug/Yls5krnHyAIXCJXhFuGMMYjSsmBzqoZ7LmSgd805vghWIpUDkumV7JRQqvz5WHg7cv201HQ/lQ3Ye7/yAthcLgPHVoI4iB9Dl8jtNaod7gXxttgR7g0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLsL/ABhwmQIXr14ja8L3DyQfYcIsPEeYqKpVo6lwqo=;
 b=WBfP3lvtuYhzOpgXUWprCADOI8nlmEbPsjm/jwX74gJ1txtA6MMAjCtRUXaHYHCDLlVdyflxQN/BjkbMsLVXFv39cOKkOs0a9ayXoXtHBD9e9JfsIJSeKAyWx13tuN7A9NZT3K4LiGQd3SC0cXlIYnO2EymwD1vGn+R+MBsUvdUoFxFUc1vWQUrlIFPSfWbp4og65D1APZ+v3y+t/LnFE+N1OTfcUmW6DIBrAIDNQHu2Pl2g1U6XXqePJeDEyPhi4iXNtVymgFL0CuLhlkJktgn1EtvCUMacb3oBYeD7cD5JtMnBRQksLsNCF/linogyY36TqAyvKCPoa6dKkwpCIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLsL/ABhwmQIXr14ja8L3DyQfYcIsPEeYqKpVo6lwqo=;
 b=UdkLMXQdZjR8mwE3fQTUTFf3WAc02NN2bWTd6rLNedUd4flHSvmp4uxYxdPWpodVcOdxP2puAakpFzPFBxmiobYYwtnpzpNuIMxcysBGPmRB5Y0SUxnKNu311tU4ztOelxQSmkqheiZ2FuxpYoroEYgo91Po6lnQFcZOdPzJiQdPJhcIFXp95P1xSCx3WZXu4+/SK2Kt7PWDbjbwW62dnmia6/01QHoDMxUveMfR5ZyTqhkFe2I0ZTb7GsyI4Is90wfc5TVfArPVaCM7LiddyCeV0e/sQ/QV9J/bpaITIsqAcV9EDUnf7Kfgk+0umwan7vEqTJ24JT2sVaDFV7PP/g==
Received: from MW3PR05CA0002.namprd05.prod.outlook.com (2603:10b6:303:2b::7)
 by LY0PR12MB770130.namprd12.prod.outlook.com (2603:10b6:404:211::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 09:45:59 +0000
Received: from CO1PEPF000075EF.namprd03.prod.outlook.com
 (2603:10b6:303:2b:cafe::92) by MW3PR05CA0002.outlook.office365.com
 (2603:10b6:303:2b::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Tue,
 29 Sep 2026 09:45:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075EF.mail.protection.outlook.com (10.167.249.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Tue, 29 Sep 2026 09:45:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 29 Sep
 2026 02:45:37 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Tue, 29 Sep
 2026 02:45:37 -0700
Received: from [127.0.1.1] (10.127.8.13) by mail.nvidia.com (10.129.68.6) with
 Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Tue, 29 Sep
 2026 02:45:32 -0700
From: Kartik Rajput <kkartik@nvidia.com>
Date: Tue, 29 Sep 2026 15:15:08 +0530
Subject: [PATCH v2 2/4] scsi: ufs: Add UIC DEBUGSAVECONFIGTIME attribute
 and its field masks
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260929-tegra264-ufs-v2-2-f0467b9c503e@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790675122; l=1338;
 i=kkartik@nvidia.com; s=20260909; h=from:subject:message-id;
 bh=E7H+llcHhG57oqmNTC4OPep7Os9a8YtnhBGzki8X/dc=;
 b=G8BlmOtUucOFIIxmVZ2EaToLzt0EuG3OYcue6NFfq6SFNMUngmmE7Mi3mN8HIjYLhMYpBu4n1
 wnc4mVyUWH3C+N3cqly/BeY2TYhJhNsa+drrbmPrQGg52xiDyxThXYf
X-Developer-Key: i=kkartik@nvidia.com; a=ed25519;
 pk=V+1YkJqxCruxUVxLXtAG3f5k8O5skT0X4/QIB75KZ64=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075EF:EE_|LY0PR12MB770130:EE_
X-MS-Office365-Filtering-Correlation-Id: 66fa944d-d026-4685-5d30-08df1e0e7777
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|376014|1800799024|23010399003|10067099003|56012099006|11063799006|921020|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	RD3tnHZsi+LKuWMMoDWEStItCVTnmHAuQiBmXHvpKcB2avyoyDHvWHzbo1nF5LnWaSRmNpnwdviKH8QOUj7P8ybZ1CgXDuIMJVQnUyzIwcQgCLMajwzjHvelyib2e/iLiXmX9YxVWEIjNx1gkw7vlV3SwOJ2YWZEM9AKW5YV2G9pM9WQ9sonroTM5sePKbdV8ELBOi2mvzDsXB8tioftxePNYE9PPxM9jZFzBcdkNi4LK3efQz4G3x+x4XEb4/TGxQL+E40KjEM2OegVaOsQ4qekjyNj+jdPUiX/nyPR9Tz6X1TR7389aXFYjJT5FRjFtth92mVZDK8OiK+r2sHtAMsqQz5rPn/vV+HluU5xX1Cw2M6U3kSF4eLweXXVw18q7SYdsc0PPmASm8p1O3gL39aLKRT4ZRkNWr4TFkCId2iIJp5ulYVMSBdVNCEAgKuRq4/AlZw3nhoL+ip6HoX3x/CsmKPa4GaYQGDS8iM2p8hDgIs+wwGnhsOYg7es784P9egsLHgcXVD5bGtYwe7GLLMNukfZ5opgMWEfsteQpC+1zrB5Wfjx3+3/O1N9Ro1Hqh+mrRWRCAUGcI+ZDJDL5RcBE9KehKL2ZIwYp2uRRNmGv8TordoLSt141rC1KUqV4/I12ckHkNWHUjQpHEQmShD9mXgijhew7FTItYhhqKFAvtbuPUOjfEyi8wPATXTmKYv25X8GQqsQmPgaSJSxNUtkbWJWECHr/79XNB5mOpx+aigKDXwl7vjNmj+VcCJ2
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(376014)(1800799024)(23010399003)(10067099003)(56012099006)(11063799006)(921020)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dpoaeHiQigBEXtwd6l00yP2N4qRJzCLj8lu6G8fwFTgGnS7nqTvZoh7tooAbdAW5gFTePJrdzNqgPatWTlCkGKxvGEYEoBb9vG8hGCfIMy9zet8OqCb7463qgoyo/JIQhDjU4aWjn0us7AqejVK3HTTV9j+RIsWTgxl1qV20aqGNSpy4vDcFjg4HlcagoUMj7RBJ4j1R2tS40BOCA+OVG1GxO6N6ule9UFLZTTp7V1CmkD/qIrwB7NALlBql6Q6D4r8STWzg9iYJE5BAv/TM+gReGqeWMmiXHfQigRs0MpRzKPw2cmC8fkZ5bZUILL046XsI+uiBR5u5GHVUbR7h9CuWXTmrFCbH70WInBClhrG/ZNlTFc8X+ap5JzJyLRV/6XXFrwu+dSrTV9vcHAyeBX8Qp1UsrnlGqSCe6m35E+012/snbuU5RQ55LdBOUSp2
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 09:45:59.1078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66fa944d-d026-4685-5d30-08df1e0e7777
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075EF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR12MB770130

Add the UniPro vendor-specific save-config-time attribute and masks for
the two fields within it:

  VS_DEBUGSAVECONFIGTIME       Save-config-time attribute (0xD0A0)
  VS_DEBUGSAVECONFIGTIME_TREF  Field masks within that attribute, for
  VS_DEBUGSAVECONFIGTIME_SCT   use with FIELD_PREP()

ufs-hisi already writes this attribute by its literal address, so name
it in the shared header rather than in the driver. Add it here in
preparation for the Tegra264 UFS host controller driver, which also
programs the two fields.

Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
---
 include/ufs/unipro.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 9c168703b104..f6d83878f2a6 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -6,6 +6,8 @@
 #ifndef _UNIPRO_H_
 #define _UNIPRO_H_
 
+#include <linux/bits.h>
+
 /*
  * M-TX Configuration Attributes
  */
@@ -232,8 +234,12 @@
 #define VS_POWERSTATE		0xD083
 #define VS_MPHYCFGUPDT		0xD085
 #define VS_DEBUGOMC		0xD09E
+#define VS_DEBUGSAVECONFIGTIME	0xD0A0
 #define VS_MPHYDISABLE		0xD0C1
 
+#define VS_DEBUGSAVECONFIGTIME_TREF	GENMASK(4, 2)
+#define VS_DEBUGSAVECONFIGTIME_SCT	GENMASK(1, 0)
+
 #define PA_GRANULARITY_MIN_VAL	1
 #define PA_GRANULARITY_MAX_VAL	6
 

-- 
2.43.0

