Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sg2apc01on2087.outbound.protection.outlook.com [40.107.215.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937E52980A7
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 09:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.215.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744363781; cv=fail; b=EMSopodquJXPOep2iTAl5K6RxsPDcEcAKA04/STh9oApFRk0aVTmYUi97D3Wgbhip+8iYGMFi3awS8qic5ASxnnUvhu8S1FVB4+kYrV0F1QDkrGbdT0b9Jq+r3eqJIfFLVTjs1qhlg2L+bdeQRZYFJNG7wBq+uCYocjYSYlBrR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744363781; c=relaxed/simple;
	bh=mjBSqMWMM165jt73uelChfIVQBDwozYa9UvdoKGwOxw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LQbXcSEq/AP/xu2PaD8+CnQVfxT6A8dpwhh5haogtSjPwhXw+RqdzJl3A9MCTUiw+/0LCpP7ZEJX03yzCjRPDP+veY33gp040nmaVFyZnxhTKyi3fjJI72aex/UBdv3IF7kgYpanZFlopmEYXRkYhkd8Y61JVY8Czxl0Qv8RPLc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=BR70z/H7; arc=fail smtp.client-ip=40.107.215.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="BR70z/H7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qqh9QLOnfx+uwp6aRd+WK9VG8U4+GEUSCpmHvFs25wbULOtqjVuYmMuMOlvRHFvSy/1+ZwYYsm8J7zjs9mbJHaUi6hx+rzKS1FnQCUIKZKaTx/OiKTPcUob59OrpeksqnDoi4iOtZ2FxwCFVISRu5f7jpnHRREZJdteQ0NavfbivZqU8xZzqFAlHCWFHMZZVHggjD+JWLEF+PuNMXpN0/selHOptpMIh3lDGUoxsbiVaxXGfF1kF51kIvcbPJuWLmamTMT6QBLa3uOrOPI70xWhBVVZkMz0AL3ZUtM86QfzvRBuHB+TleqbjmK8I7R+ucc11IuZg0Fk5fHkZ3HLrsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ks623Tv5ftvj2GbNQ3xtIcQqsEDXImWf7ss9mbwr5go=;
 b=F6ekbhjpctT+o3F41CxC5ogUA/L6/W27oCKMaeyokSUuGnkqge32/9l7f33/Tz41WOF9gyeLm9eDd/+KHP0zc6lLA43tBkOlUvZDYvknSUq8YlV/9zFF7HGSKZ77SXtjmwlFtfK9dMWuMyaNvseZPZH7iuvZw5Kq15oAtdaWClZ5dfr79D0eeAKcSBFsxBZtYOb6qZrSYcEIW+KDFn498wCraES3GCJU8MRyZMIiaMDqO30CQzSB51SptOeLeGZ3UpXlGrpY1zWYhc5FqfQJWrgKGeqI024Oqs3mynzTRugvnWCHxWe//TCmIisPll/V33xNWe+FvgkmHU1eGCay/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ks623Tv5ftvj2GbNQ3xtIcQqsEDXImWf7ss9mbwr5go=;
 b=BR70z/H7mYyWPbWT4CLuQw8hs+yLvVcksSQlTp4K2nmvD/6rswKRqXFZgmSbSXbE2blYFnbaLHFEyrn2S0H0msHamNYY4FWvQWlNWbN7eeaDieqDH+DuQVnWNwMMOypS8dSjWlaU3wiS4iZTdHFWDX92kpzXYBwgxI5c9t99cXZL4OTb4ym3OYjtP3gjUDQ9Id5SKh6wFVwmJAN7ick6MvIJ95G6uy/0+sNbHgfZa030C4t6JBZTLrNlDtCNHXXmqmFoD2zuCoa0kWmtx/qDSHuGv1AgnaemBu4GiFZ+bKkH+Zs2fcDOomQllY+wBiXxqHycuULGfzj/yu+JtJxeRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com (2603:1096:820:ec::10)
 by SI2PR06MB5042.apcprd06.prod.outlook.com (2603:1096:4:1a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.27; Fri, 11 Apr
 2025 09:29:34 +0000
Received: from KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09]) by KL1PR06MB6273.apcprd06.prod.outlook.com
 ([fe80::9d21:d819:94e4:d09%3]) with mapi id 15.20.8606.040; Fri, 11 Apr 2025
 09:29:34 +0000
From: Huan Tang <tanghuan@vivo.com>
To: bvanassche@acm.org
Cc: huobean@gmail.com,
	cang@qti.qualcomm.com,
	linux-scsi@vger.kernel.org,
	opensource.kernel@vivo.com,
	richardp@quicinc.com,
	tanghuan@vivo.com,
	luhongfei@vivo.com
Subject: [PATCH v11] ufs: core: Add WB buffer resize support
Date: Fri, 11 Apr 2025 17:29:24 +0800
Message-Id: <20250411092924.1116-1-tanghuan@vivo.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <5588fc82-888e-4be8-b28a-5ab2a69d2ce9@acm.org>
References: <5588fc82-888e-4be8-b28a-5ab2a69d2ce9@acm.org>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:4:197::10) To KL1PR06MB6273.apcprd06.prod.outlook.com
 (2603:1096:820:ec::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6273:EE_|SI2PR06MB5042:EE_
X-MS-Office365-Filtering-Correlation-Id: 67e58fec-4537-4e0f-49a0-08dd78db5ed7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|376014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MCVg619IPeyfY2km2nCcHsdSbPyw1/RahtT7jtCZTAzh4J52WBFS2vtmubKV?=
 =?us-ascii?Q?ZdaGd+9q3nA8rs6UL8ugYYgxiIIgcTXzqW9ixFUluR+TLxEHpFrpzVAH8PKT?=
 =?us-ascii?Q?Aa1M8eoKEOJFWAehf2XjvZ7tHcqb4t8uDUkYCqxF/hhRxcFRr0ggipFLdGLf?=
 =?us-ascii?Q?TuWzeXDmSei1MtSSeYsVjA2LShug/SQWPjtesTx4VthVi8oeVm7u3A0TeWGR?=
 =?us-ascii?Q?4TKetyGZa/XzzB3hqCeDO1dMGk5o3aggUvBEes9rvFOQP4giYxZbn3JVBxJP?=
 =?us-ascii?Q?LUXlLVB1iiGrAr6wTtTwUuoE591XFqhjSusu6YlKzUk66A3iQpSFL3YUkqrY?=
 =?us-ascii?Q?FHPt8HvqHwZPcjXbJeZF18vRN/SeRWDm1pGhGm1/n57azgcNxJTZ0qzuSvuD?=
 =?us-ascii?Q?cqzDqM62sQNFwUGDIOvtcI67nypJtGwCniLvdF+DyaJILvZsvy1F4LAs4kix?=
 =?us-ascii?Q?iLTJad3i7CThLwHQY9/sDmOOwqde3RtdgQ/7MNVtkhuo0LovCuFc++3hxy65?=
 =?us-ascii?Q?KDT/f39jiXpzGE66A1mE/aNbAGLat0DBK0dYE+GOX4wj9JP9B6GFs/r8A2rj?=
 =?us-ascii?Q?eakIFd30+6XCkIXGNZ1IGbFX9bIErmZ0KDsqwO9+NIOFhRkKyEPqh2JfIhSl?=
 =?us-ascii?Q?D/sXhIsmJUTzSRChzBmN+e7SGr5gaEgyGucSQuPx+2m/p10AYclbZFB8VFim?=
 =?us-ascii?Q?2Pm+UlH3n7rlLnsOYXfMmjt7TCettjhhK62O5jgII3E/GZBMt/Mp1bO/CU1H?=
 =?us-ascii?Q?cZqL1v+m2RnJtO9MzsT3Ik8Fg0mEpk1KINJqz4eMKANxhsrBDcVcJRDd8xXA?=
 =?us-ascii?Q?aukYTJD2AUqdvrHl5FhliSNmMXIKZwxJcHsiddMgkYwc3Cdpf58nqWj5cVpk?=
 =?us-ascii?Q?J14AqCo2GPqctvsuJ0qpnbv/qb63kwzXdmxG0dPiKP+Mdq9TCd3WcMoR15Zm?=
 =?us-ascii?Q?KLN9r4UaIHowzYN+qnzqyDntBroyrT7oulQ0X4jF8GO5+Gw9xTPDSnyEsQy0?=
 =?us-ascii?Q?KGe+KAWg9zJjMTOkt1fSShzRN1agmxFFbCApU20Hp+qznRWF1X4ntt7AO/wO?=
 =?us-ascii?Q?+Onmuiwcil06QbNg3OZgHUKOkGiO6NC7h85XBK0sPG7W7n1+0Fb2lXSo2jks?=
 =?us-ascii?Q?7CrC8yIZYTG0vVJIvdV6+zHpdJ8AlwgR4jx0e+EO5yBi88fp7NCvWPIjXVdL?=
 =?us-ascii?Q?hdLqCkaxnnDRUEgyoyIbchRTbJIRY+myKXc5IIXxKppYSzbnMqgNpuYnXQJA?=
 =?us-ascii?Q?ZMBYRPx+pqwiF578S+eNkGaK/DsktDeozTxFqKZf1yFpVzxo68bGJSaPwO26?=
 =?us-ascii?Q?eVE1lm9hmfnsOkZ/hdiUSOlHSdBOrmn/kA8zHF5tgThdbpCkewLpIJyr+0AU?=
 =?us-ascii?Q?crc+W+qQrBsSC/Z0HhnmfZknQBboE9WzE5fzRTIPoc9ZLzzu5VteoRrWIfcV?=
 =?us-ascii?Q?N6diTCKYdMphGu5NKU7ruB7ZmEW0woKi84F6MAsnvCZNrB8/+XMDyH8rcP3t?=
 =?us-ascii?Q?G5mwTASO1cxdCug=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6273.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(376014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aJVQBu4DT2DRHqkM2i7Azp/DOzP/tY4WqVsVtUjVzGIzAGKxm19pvP5cD8MP?=
 =?us-ascii?Q?TX8zCdBCtkTbODaG9TccB73zijfW7dOVMc4wtQe4sNWvzH1kSsLlXu7DPR10?=
 =?us-ascii?Q?+z7HQr3vwpbZVXkJAZHewidr/Nmublnk7sop0VfRfJIFKypz6u+Pwy7d0eZZ?=
 =?us-ascii?Q?qszGokN+E6wWEATWQljU0RU2UuV4q7U8V7DclGbvZtRBtYfudB6SRDnbPQLR?=
 =?us-ascii?Q?YTWN9U6iqT31XMb6v47MbzdkqrcvMsgr+mANRtogFc4HKrgXJcaft50z2D/m?=
 =?us-ascii?Q?QlHb7Kl2Yp9p+rRaXx1vMAVtzN/kIXXvo0hupG/RVxwlMUCbTZQKJqv2H0w9?=
 =?us-ascii?Q?wq9qDaI1RElYHISGXsO73FdLNfplZMBGmUCd0DTATf9qKMKNAn5WkwJdOc8t?=
 =?us-ascii?Q?IgKm/vdOgQO8oWf8zSygFi4ZaaTDI4EDtHFTbtyUBrsLKU4Mv9xCdBmFNsDC?=
 =?us-ascii?Q?GtTfyZpoJBG71IV+GXby9sy7I4YcUxsQb9PGfaNhrKBE0fCPiSZ3BX4bAPdT?=
 =?us-ascii?Q?LefXXY8fMJSrcyEsGjkQB2NAjdWQjzSykExLh9IKzn9R8C0EV2dYle0pdqqO?=
 =?us-ascii?Q?/0LHKW8nEKyytuOkrfH3l3DxT/UqGgQfQYDiUHpeL1pgg+Pc4tK7i0mD0Erf?=
 =?us-ascii?Q?HfGGxdWHID3wiuO3uTIcdcmwdtUHRCrUqAlp04xmoXPiro2ZT0aLnkPZXHvm?=
 =?us-ascii?Q?dRKSAtVTSffUoMolC9EEUOD4dYtrgCpvz0sd/Vek+arHwtfL5SkOKNJgp6/o?=
 =?us-ascii?Q?Bnw01NrZbUlYvLFK9nE4FeBZt1ctDBjEtI3xr1WhvFsFfXU50YHpr4wCg+lN?=
 =?us-ascii?Q?Gg0dAr91rBlyWFqVVcKpEvjcuYC1H9ev/GbvgWIzkpTPsX3mgLWuB8kpZu6O?=
 =?us-ascii?Q?JtzVJCP6Zv8IWDhbHB39w642KbIm7pnjPs1VTydKthK6YEvreHa+xsxkrsZc?=
 =?us-ascii?Q?Iz7AkDWpabAh33gouPBjY1zgKbWTxALNV7JkscyCrg9Vzqv5fEi1CBIJubtx?=
 =?us-ascii?Q?tameOaM2vXmjQJEoJFaanOfizbtCl/ovkDq8+QeMHQACa8+XHfUFg4IqRxTs?=
 =?us-ascii?Q?9Z6gmKnJrQRqlBuMkC2Z5ttEVRXINkOOhKZEwqLLb53w7Wf/PyLdEnZyFmQ8?=
 =?us-ascii?Q?8qWJ4Hmshnhw/mIaBRpYRWSykjmo6Uah1nWb5mBoJsaZpWh53htjI4xbMZkJ?=
 =?us-ascii?Q?tLoZNO6Zxn944QxvJxtpj/THOFmpjUbf8cgkYnhTgGqrTwa2NOFQ4+3eYQtP?=
 =?us-ascii?Q?ncAqgQR/iTOOQxoPH59gfk4XoTCXsW6q1VEm1fsnSaCOzU0l5PQps8dogX6L?=
 =?us-ascii?Q?CwaRItMkHFuV50WXnh/KlxzR1pi9oATjjnSL/cEhAlNZGCGx1wGKHbI06NMl?=
 =?us-ascii?Q?nRI0sx34X6R3oj6o4FhAARdZUXgkUFLn6VjthPdYJ0OWjZXj4pNN6feUVPRg?=
 =?us-ascii?Q?cso+1FrFWfw11rQ6xgfu4dJCkw5WxaSmAXMx4wrzvCHJ3TQmjN3Y2Pm4UKxg?=
 =?us-ascii?Q?CojIIefnkjsB1rxX4qJreYbN0riNBipTKJsaK+FCQ+jwR79oD28T2L6eOTMx?=
 =?us-ascii?Q?gUVO+5wL5JAel0Vu3zi1nkpE4U8sCe5C/Wu2QmYa?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67e58fec-4537-4e0f-49a0-08dd78db5ed7
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6273.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 09:29:34.2582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgLbfZLZgsVNiiSkBrFbEGOei5RLKeie0Ta0dECrXhZAa/oV5V77zCRZ7FaKlmjkWB+vtVodEEOuWE7ezSuJOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR06MB5042

Follow JESD220G, Support WB buffer resize function through sysfs,
the host can obtain resize hint and resize status, and enable the
resize operation. To achieve this goals, three sysfs nodes have
been added:
	1. wb_resize_enable
	2. wb_resize_hint
	3. wb_resize_status
The detailed definition of the three nodes can be found in the sysfs
documentation.

Changelog
===
v10 - > v11:
	1.change "fail" to "failure", change "FAIL" to "FAILURE"
	2.fix coding style issue in "wb_resize_hint_show"
	and "wb_resize_status_show"
	3.remove ext_wb_sup sysfs node
	4.only use one tab in front of "="

v9 - > v10:
	fix commit message error:remove "^M"

v8 - > v9:
	1.Add "ext_wb_sup" node
	2.Fix some coding errors,for example: "gerneral" ->"general"
	3.Add a check bit0 of ext_wb_sup
	4.Following Bean's advice: use enum in ufshcd_wb_set_resize_en

v7 - > v8:
	1.Optimized the description in the sysfs-driver-ufs file
	2.Replace uppercase with lowercase, for example: "KEEP"-> "keep"
	3.Fix coding style issues with switch/case statements

v6 - > v7:
	1.Use "xxxx_to_string" for string convert
	2.Use uppercase characters, for example: "keep" -> "KEEP"
	3.Resize enable mode support "IDLE"

v5 - > v6:
	1.Fix mistake: obtain the return value of "sysfs_emit"

v4 - > v5:
	1.For the three new attributes: use words in sysfs instead of numbers

v3 - > v4:
	1.modify three attributes name and description in document
	2.add enum wb_resize_en in ufs.h
	3.modify function name and parameters in ufs-sysfs.c, ufshcd.h, ufshcd.c

v2 - > v3:
	Remove needless code:
	drivers/ufs/core/ufs-sysfs.c:441:2:
	index =	ufshcd_wb_get_query_index(hba)

v1 - > v2:
	Remove unused variable "u8 index",
	drivers/ufs/core/ufs-sysfs.c:419:12: warning: variable 'index'
	set but not used.

v1
	https://lore.kernel.org/all/20241025085924.4855-1-tanghuan@vivo.com/
v2
	https://lore.kernel.org/all/20241026004423.135-1-tanghuan@vivo.com/
v3
	https://lore.kernel.org/all/20241028135205.188-1-tanghuan@vivo.com/
v4
	https://lore.kernel.org/all/20241101093318.825-1-tanghuan@vivo.com/
v5
	https://lore.kernel.org/all/20241104134612.178-1-tanghuan@vivo.com/
v6
	https://lore.kernel.org/all/20241104142437.234-1-tanghuan@vivo.com/
v7
	https://lore.kernel.org/all/20250402014536.162-1-tanghuan@vivo.com/
v8
	https://lore.kernel.org/all/20250402075710.224-1-tanghuan@vivo.com/
v9
	https://lore.kernel.org/all/20250407085143.173-1-tanghuan@vivo.com/
v10
	https://lore.kernel.org/all/20250407090920.431-1-tanghuan@vivo.com/

Signed-off-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Lu Hongfei <luhongfei@vivo.com>
---
 Documentation/ABI/testing/sysfs-driver-ufs |  49 ++++++++
 drivers/ufs/core/ufs-sysfs.c               | 133 +++++++++++++++++++++
 drivers/ufs/core/ufshcd.c                  |  18 +++
 include/ufs/ufs.h                          |  34 +++++-
 include/ufs/ufshcd.h                       |   1 +
 5 files changed, 234 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/ABI/testing/sysfs-driver-ufs
index ae0191295d29..e7b49bc894f5 100644
--- a/Documentation/ABI/testing/sysfs-driver-ufs
+++ b/Documentation/ABI/testing/sysfs-driver-ufs
@@ -1604,3 +1604,52 @@ Description:
 		prevent the UFS from frequently performing clock gating/ungating.
 
 		The attribute is read/write.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/wb_resize_enable
+What:		/sys/bus/platform/devices/*.ufs/wb_resize_enable
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can enable the WriteBooster buffer resize by setting this
+		attribute.
+
+		========  ======================================
+		idle      There is no resize operation
+		decrease  Decrease WriteBooster buffer size
+		increase  Increase WriteBooster buffer size
+		========  ======================================
+
+		The file is write only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_hint
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_hint
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		wb_resize_hint indicates hint information about which type of resize
+		for WriteBooster buffer is recommended by the device.
+
+		=========  ======================================
+		keep       Recommend keep the buffer size
+		decrease   Recommend to decrease the buffer size
+		increase   Recommend to increase the buffer size
+		=========  ======================================
+
+		The file is read only.
+
+What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_resize_status
+What:		/sys/bus/platform/devices/*.ufs/attributes/wb_resize_status
+Date:		April 2025
+Contact:	Huan Tang <tanghuan@vivo.com>
+Description:
+		The host can check the resize operation status of the WriteBooster
+		buffer by reading this attribute.
+
+		================  ========================================
+		idle              Resize operation is not issued
+		in_progress       Resize operation in progress
+		complete_success  Resize operation completed successfully
+		general_failure   Resize operation general failure
+		================  ========================================
+
+		The file is read only.
diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 90b5ab60f5ae..a27a3980480e 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -57,6 +57,36 @@ static const char *ufs_hs_gear_to_string(enum ufs_hs_gear_tag gear)
 	}
 }
 
+static const char *ufs_wb_resize_hint_to_string(enum wb_resize_hint hint)
+{
+	switch (hint) {
+	case WB_RESIZE_HINT_KEEP:
+		return "keep";
+	case WB_RESIZE_HINT_DECREASE:
+		return "decrease";
+	case WB_RESIZE_HINT_INCREASE:
+		return "increase";
+	default:
+		return "unknown";
+	}
+}
+
+static const char *ufs_wb_resize_status_to_string(enum wb_resize_status status)
+{
+	switch (status) {
+	case WB_RESIZE_STATUS_IDLE:
+		return "idle";
+	case WB_RESIZE_STATUS_IN_PROGRESS:
+		return "in_progress";
+	case WB_RESIZE_STATUS_COMPLETE_SUCCESS:
+		return "complete_success";
+	case WB_RESIZE_STATUS_GENERAL_FAILURE:
+		return "general_failure";
+	default:
+		return "unknown";
+	}
+}
+
 static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
@@ -411,6 +441,44 @@ static ssize_t wb_flush_threshold_store(struct device *dev,
 	return count;
 }
 
+static const char * const wb_resize_en_mode[] = {
+	[WB_RESIZE_EN_IDLE]	= "idle",
+	[WB_RESIZE_EN_DECREASE]	= "decrease",
+	[WB_RESIZE_EN_INCREASE]	= "increase",
+};
+
+static ssize_t wb_resize_enable_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int mode;
+	ssize_t res;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled
+		|| !hba->dev_info.b_presrv_uspc_en
+		|| !(hba->dev_info.ext_wb_sup & UFS_DEV_WB_BUF_RESIZE))
+		return -EOPNOTSUPP;
+
+	mode = sysfs_match_string(wb_resize_en_mode, buf);
+	if (mode < 0)
+		return -EINVAL;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		res = -EBUSY;
+		goto out;
+	}
+
+	ufshcd_rpm_get_sync(hba);
+	res = ufshcd_wb_set_resize_en(hba, mode);
+	ufshcd_rpm_put_sync(hba);
+
+out:
+	up(&hba->host_sem);
+	return res < 0 ? res : count;
+}
+
 /**
  * pm_qos_enable_show - sysfs handler to show pm qos enable value
  * @dev: device associated with the UFS controller
@@ -476,6 +544,7 @@ static DEVICE_ATTR_RW(auto_hibern8);
 static DEVICE_ATTR_RW(wb_on);
 static DEVICE_ATTR_RW(enable_wb_buf_flush);
 static DEVICE_ATTR_RW(wb_flush_threshold);
+static DEVICE_ATTR_WO(wb_resize_enable);
 static DEVICE_ATTR_RW(rtc_update_ms);
 static DEVICE_ATTR_RW(pm_qos_enable);
 static DEVICE_ATTR_RO(critical_health);
@@ -491,6 +560,7 @@ static struct attribute *ufs_sysfs_ufshcd_attrs[] = {
 	&dev_attr_wb_on.attr,
 	&dev_attr_enable_wb_buf_flush.attr,
 	&dev_attr_wb_flush_threshold.attr,
+	&dev_attr_wb_resize_enable.attr,
 	&dev_attr_rtc_update_ms.attr,
 	&dev_attr_pm_qos_enable.attr,
 	&dev_attr_critical_health.attr,
@@ -1495,6 +1565,67 @@ static inline bool ufshcd_is_wb_attrs(enum attr_idn idn)
 		idn <= QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE;
 }
 
+static int wb_read_resize_attrs(struct ufs_hba *hba,
+			enum attr_idn idn, u32 *attr_val)
+{
+	u8 index = 0;
+	int ret;
+
+	if (!ufshcd_is_wb_allowed(hba) || !hba->dev_info.wb_enabled
+		|| !hba->dev_info.b_presrv_uspc_en
+		|| !(hba->dev_info.ext_wb_sup & UFS_DEV_WB_BUF_RESIZE))
+		return -EOPNOTSUPP;
+
+	down(&hba->host_sem);
+	if (!ufshcd_is_user_access_allowed(hba)) {
+		up(&hba->host_sem);
+		return -EBUSY;
+	}
+
+	index = ufshcd_wb_get_query_index(hba);
+	ufshcd_rpm_get_sync(hba);
+	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+			idn, index, 0, attr_val);
+	ufshcd_rpm_put_sync(hba);
+
+	up(&hba->host_sem);
+	return ret;
+}
+
+static ssize_t wb_resize_hint_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret = wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%s\n", ufs_wb_resize_hint_to_string(value));
+}
+
+static DEVICE_ATTR_RO(wb_resize_hint);
+
+static ssize_t wb_resize_status_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct ufs_hba *hba = dev_get_drvdata(dev);
+	int ret;
+	u32 value;
+
+	ret = wb_read_resize_attrs(hba,
+			QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS, &value);
+	if (ret)
+		return ret;
+
+	return sysfs_emit(buf, "%s\n", ufs_wb_resize_status_to_string(value));
+}
+
+static DEVICE_ATTR_RO(wb_resize_status);
+
 #define UFS_ATTRIBUTE(_name, _uname)					\
 static ssize_t _name##_show(struct device *dev,				\
 	struct device_attribute *attr, char *buf)			\
@@ -1568,6 +1699,8 @@ static struct attribute *ufs_sysfs_attributes[] = {
 	&dev_attr_wb_avail_buf.attr,
 	&dev_attr_wb_life_time_est.attr,
 	&dev_attr_wb_cur_buf.attr,
+	&dev_attr_wb_resize_hint.attr,
+	&dev_attr_wb_resize_status.attr,
 	NULL,
 };
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 83b092cbb864..a73838062ddf 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6068,6 +6068,21 @@ int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable)
 	return ret;
 }
 
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, enum wb_resize_en en_mode)
+{
+	int ret;
+	u8 index;
+
+	index = ufshcd_wb_get_query_index(hba);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+				QUERY_ATTR_IDN_WB_BUF_RESIZE_EN, index, 0, &en_mode);
+	if (ret)
+		dev_err(hba->dev, "%s: Enable WB buf resize operation failed %d\n",
+			__func__, ret);
+
+	return ret;
+}
+
 static bool ufshcd_wb_presrv_usrspc_keep_vcc_on(struct ufs_hba *hba,
 						u32 avail_buf)
 {
@@ -8067,6 +8082,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, const u8 *desc_buf)
 	 */
 	dev_info->wb_buffer_type = desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
 
+	dev_info->ext_wb_sup =  get_unaligned_be16(desc_buf +
+						DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
+
 	dev_info->b_presrv_uspc_en =
 		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
 
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 8a24ed59ec46..3f2b1772f9fd 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -180,7 +180,10 @@ enum attr_idn {
 	QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE       = 0x1D,
 	QUERY_ATTR_IDN_WB_BUFF_LIFE_TIME_EST    = 0x1E,
 	QUERY_ATTR_IDN_CURR_WB_BUFF_SIZE        = 0x1F,
-	QUERY_ATTR_IDN_TIMESTAMP		= 0x30
+	QUERY_ATTR_IDN_TIMESTAMP		= 0x30,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_HINT	= 0x3C,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_EN		= 0x3D,
+	QUERY_ATTR_IDN_WB_BUF_RESIZE_STATUS	= 0x3E,
 };
 
 /* Descriptor idn for Query requests */
@@ -289,6 +292,7 @@ enum device_desc_param {
 	DEVICE_DESC_PARAM_PRDCT_REV		= 0x2A,
 	DEVICE_DESC_PARAM_HPB_VER		= 0x40,
 	DEVICE_DESC_PARAM_HPB_CONTROL		= 0x42,
+	DEVICE_DESC_PARAM_EXT_WB_SUP		= 0x4D,
 	DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP	= 0x4F,
 	DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN	= 0x53,
 	DEVICE_DESC_PARAM_WB_TYPE		= 0x54,
@@ -383,6 +387,11 @@ enum {
 	UFSHCD_AMP		= 3,
 };
 
+/* Possible values for wExtendedWriteBoosterSupport */
+enum {
+	UFS_DEV_WB_BUF_RESIZE	= BIT(0),
+};
+
 /* Possible values for dExtendedUFSFeaturesSupport */
 enum {
 	UFS_DEV_HIGH_TEMP_NOTIF		= BIT(4),
@@ -454,6 +463,28 @@ enum ufs_ref_clk_freq {
 	REF_CLK_FREQ_INVAL	= -1,
 };
 
+/* bWriteBoosterBufferResizeEn attribute */
+enum wb_resize_en {
+	WB_RESIZE_EN_IDLE	= 0,
+	WB_RESIZE_EN_DECREASE	= 1,
+	WB_RESIZE_EN_INCREASE	= 2,
+};
+
+/* bWriteBoosterBufferResizeHint attribute */
+enum wb_resize_hint {
+	WB_RESIZE_HINT_KEEP	= 0,
+	WB_RESIZE_HINT_DECREASE	= 1,
+	WB_RESIZE_HINT_INCREASE	= 2,
+};
+
+/* bWriteBoosterBufferResizeStatus attribute */
+enum wb_resize_status {
+	WB_RESIZE_STATUS_IDLE	= 0,
+	WB_RESIZE_STATUS_IN_PROGRESS	= 1,
+	WB_RESIZE_STATUS_COMPLETE_SUCCESS	= 2,
+	WB_RESIZE_STATUS_GENERAL_FAILURE	= 3,
+};
+
 /* Query response result code */
 enum {
 	QUERY_RESULT_SUCCESS                    = 0x00,
@@ -578,6 +609,7 @@ struct ufs_dev_info {
 	bool    wb_buf_flush_enabled;
 	u8	wb_dedicated_lu;
 	u8      wb_buffer_type;
+	u16	ext_wb_sup;
 
 	bool	b_rpm_dev_flush_capable;
 	u8	b_presrv_uspc_en;
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index f56050ce9445..722307182630 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1471,6 +1471,7 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 				     struct scatterlist *sg_list, enum dma_data_direction dir);
 int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable);
 int ufshcd_wb_toggle_buf_flush(struct ufs_hba *hba, bool enable);
+int ufshcd_wb_set_resize_en(struct ufs_hba *hba, enum wb_resize_en en_mode);
 int ufshcd_suspend_prepare(struct device *dev);
 int __ufshcd_suspend_prepare(struct device *dev, bool rpm_ok_for_spm);
 void ufshcd_resume_complete(struct device *dev);
-- 
2.39.0

