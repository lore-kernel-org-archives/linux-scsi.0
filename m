Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012008.outbound.protection.outlook.com [52.101.43.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9EF52BE2E;
	Wed,  9 Sep 2026 10:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788950542; cv=fail; b=J3yJw4dfCFrh6ByuIjza8s1ZWuy8UP10Mg23OL6TxjvD5VjS7m158kDaL0XsXEE377pimYl9oN2T+SedCBN0ENjrKgX9OVLf+NX7DcCv35rDtxr+455j4h9D62v008zSwuH3Wp0kgsODCbQ+DOdM9D6VLVZj6m6aHvMSf2iFjS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788950542; c=relaxed/simple;
	bh=E7H+llcHhG57oqmNTC4OPep7Os9a8YtnhBGzki8X/dc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=sNDoDwSGXHdFPBfTNhgpSdYTsX+tWdkkjE2grjTy9Duy/r2T5R4uYl9FDSbIoB+LUOKlUkZs+hWkzw73OOafg9Md35HciZBXSZppFsWG8jPM623sfFPpmqbu33Ayblay5IuLy82gPwS3zo/O7Rt7KGTHhIHEnv9Q0LI3LH3xJoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nF22Zxv2; arc=fail smtp.client-ip=52.101.43.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nF22Zxv2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GAwNDXHlm0dFy3uzWci87ewO+zufRa7twPkYRaZKHs/VQOuqsySOwBBLhLjaQZ4X4Pp+ikBdKGKryCplQHhFHhOOQ8sVzYok/iISGgWbJZNtpzoGcaRp+3au1fDjR6DeWdcMtKRIY0cwup4AfClOfFvc75qkX1aUFsalA0nk4DmXmHlW5y8185a6MSVFegWYmX/JmaZCJaYPHrQwJeI+qZuMTnne70LkP+Z2gjuZ43zd3JyVDJ/gP8Bc7HjpQt7ymy1kNtYqVqZayUzWSYzgZtrx+mz05p1h9Q3TZjDgJM5A+4W3ILd71LJgFRUI/WRXGArKd2XyjSTCk1osl+MYtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLsL/ABhwmQIXr14ja8L3DyQfYcIsPEeYqKpVo6lwqo=;
 b=KkWclfWHjfveqWkZbIxDD2ks9UMvfjKNLEAqbHiaafYUQLR6/2NV1vF9ufPRhAQ0JclrCNnSwu0AcuPnzJ2Kk+ZGn0pnpkItdQ1IXCkE31vCvZfgLlf84kwVNxjeDX5kGSn45kFbYXgrEFm8Hwvf9xxBxEGAjl9vNp/q/IZEbts3Is4QpiIWNCZnCNRDys35X9BerQJ0Q67Rf7fT4LzWnmAU/2fO8dja8vmKk+xQHxL2eU7kLtVliGOtm1a+3TuW+8pSSWVCT0R+7jQ6oFHcmTOH3rsGOB1xiQrczcjak2yW5Yso9LJOeHa+WA80o8os/1dnNl1l827UpOaS9AVn5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLsL/ABhwmQIXr14ja8L3DyQfYcIsPEeYqKpVo6lwqo=;
 b=nF22Zxv2iGSgbdLcvnnFTlRhk2jJ9ZhEYumn1IhSPDeKm3wQ6+owGFeLVt7GzVdjnrBhyOmADjBGsZge0IzInpDsUsNit7rphHXW9zoSgwwSFYobDDj8WwT8Mur2s/gyeAIqHR/Zhj7Ohc4GztcPZRfI5WBkB8/UKT+Nq8e8nhwe7QXmyopGpHPjG3lULID8K07nL8TwPwds8lY1+/j52sP5leVtRfop3VA8llwJYQVVNrGzwFmOBox8b1KRhYI9FeQu5KB0ozeg4RIi3+2uuDLaaHy3LwH398YScrdWgOF9Q6ubI4ubwDNWxCTJegcxoVPxAEf5nTI3eD6TbLcehA==
Received: from BN9PR03CA0722.namprd03.prod.outlook.com (2603:10b6:408:110::7)
 by IA0PR12MB8748.namprd12.prod.outlook.com (2603:10b6:208:482::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Wed, 9 Sep
 2026 10:42:16 +0000
Received: from BN2PEPF0000A893.namprd04.prod.outlook.com
 (2603:10b6:408:110:cafe::7d) by BN9PR03CA0722.outlook.office365.com
 (2603:10b6:408:110::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.13 via Frontend Transport; Wed, 9
 Sep 2026 10:42:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF0000A893.mail.protection.outlook.com (10.167.248.185) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Wed, 9 Sep 2026 10:42:16 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 9 Sep
 2026 03:41:58 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 9 Sep
 2026 03:41:58 -0700
Received: from [127.0.1.1] (10.127.8.13) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026
 03:41:53 -0700
From: Kartik Rajput <kkartik@nvidia.com>
Date: Wed, 9 Sep 2026 16:11:20 +0530
Subject: [PATCH 2/4] scsi: ufs: Add UIC DEBUGSAVECONFIGTIME attribute and
 its field masks
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260909-tegra264-ufs-v1-2-e4a9831702a0@nvidia.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788950501; l=1338;
 i=kkartik@nvidia.com; s=20260909; h=from:subject:message-id;
 bh=E7H+llcHhG57oqmNTC4OPep7Os9a8YtnhBGzki8X/dc=;
 b=WXvVH6YE7r6LuQUUkMTelzFSFyhomKY1CQ2dVVBfMqyQ7Y0gJBOKEahFnyKb6L3XkKR8tQpHB
 YU0bGIfKKZzCSyxqFIPr0RqzKqYvNHRUEjZ30gq9NBsYtAPT/D4FQvw
X-Developer-Key: i=kkartik@nvidia.com; a=ed25519;
 pk=V+1YkJqxCruxUVxLXtAG3f5k8O5skT0X4/QIB75KZ64=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A893:EE_|IA0PR12MB8748:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a850a06-f844-4af0-44bb-08df0e5f046a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|23010399003|7416014|376014|10067099003|6133799003|22082099003|18002099003|11063799006|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	yqFGKAFzo+usNxrEaaVkvU5uxACsHa0VMdlYL3WGUZhbUH/yANo52NirGJNLt+/Tjk+dP8jlztp4XVRJUpjSUjFQq5B9lZlx+35AiK0WyWrB1/J4hnNVQuddsmIpE1ItrB8jU85JzSk799fEAhhh+ihUoDfYeL60TmY+dDqbrSYrxtHobfvEo+1adM5zbpk62y9PX42CDV2P2jdTcPeTJlxJGgX4mBSo4q3dSieBWwe0xeQwcp2yWZQAzmjMoaBDAU75as0Hs4IvI9hdX+rStu3D+BuKaNW2mkO47gw9jrD6nSF2m/thZ0xlS1EQKmfCMrXMw/hRQR20qENMJBSao7/VMklJS7jNGE6JelLDfMKIYshH+AttDzi45wkUBrvUevq1bUscGZq/Y36CWyxi+OEXNEQ4AKbetBmY0oaWVt/KYT8aCjnRc0cq2x7N7jvJVcOCIX7otxX+YL4iUlwwYl1s/J5mWO2x7syWHlyCm9Z1Xmf3bzCm8yTSoEhV8Zbk8CoS8pBlmxnDyqumpwQlKhx/iHxaGi5Ss/nIUsWtKkeT1Eg369pmGJSgYg8D29lRMeWC4TFlMo0Hv/O9OXiFBsJArP0Eot4MqKpRmumBB6gYZZgG8bkYnFDtorZke18mzyJiMrMt7/F9opA9iVjjQ8ESyVHgLMXgcMBrYUhSO0rTStt95WPOSMIxXA1MVcXIAnGpfISJfILod0Ihi1UGbpoEdTJYPg1UowMDnEC8HpmjHj0n5tSrtHclGi7NX46y
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(23010399003)(7416014)(376014)(10067099003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vB9qv3FGKLs1BA1qOh8WOhL1Nq/oK3dLVixXsK6F5KRbsnDOhq7aL+0kcWnqS/QAzt6itXQ/gGwXqEID14vLmXr/y6Ogdpmwv2pFY5hfoLUZ3A+WdYwSUgzdfNwcmjYgIiAy5IbJBARt1RXNANnMHyhX40W32kE13V8jFgldX2KezojUcmr4j72m0dqiFmbd8Q8Rr8YuhBSSbO8JC1F7bCbBUkrugzqIqZKIsHcrkXjDiQNvFqBO4LEd1aV1M8reyJkoOlV8AzuQIv/8LFUm2PbiVQEh6M5wQOCC2QPoZBezEm89b+2XBk32qwZ3MLVs5T3nv8FR1JPJonh11JV87h063VrpGXY6jpgV4vqOFyniCR6HHXSCO0nVYM28fdnSHUr/xZ3oSEZkxacSlwijmIwcAe62NJHH6EriB2MjOSmcR4vJPIk0fcK+zbUq2ZAg
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 10:42:16.6873
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a850a06-f844-4af0-44bb-08df0e5f046a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A893.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8748

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

