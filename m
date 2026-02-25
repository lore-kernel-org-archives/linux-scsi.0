Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4422E541F
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 05:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771998846; cv=fail; b=T5lO6tReckvNig/HM4S9LZmZIr/fJ7xSgoI4VHMLDZ76IS1I1g1AY1+au2o3NSA6lj7JwUG17iLqdVaPphPpvlHelTsmXBDF6JNUQasqssNYXEnsmDu5XTRcPz+80e9KH9FYQakJKOOIiCfkzK2N5+WbI6Ob+rGr8jwDjLcws9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771998846; c=relaxed/simple;
	bh=+D4CLbTk24ncCYCoRVrOpyqiQfwp2gtBo2bb4RNjcUg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hbVYXfTz5xr2VFJaYTVqj3ySHqZoHpywOaP7ZWAnu2AD4gMMfLHS89E52n9NJnbWze62nsUl7v4nWRYd+uuU4VR25CaiEc4gfAaiUR8+an3kXN1CDZO/OXLlwM2kNHjn68pPkBt/7lwX9cqjC76KJWFlMzD5hi2R88dCgZ7mv6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=JPYG06B3; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=nmGsBq+2; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JPYG06B3";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="nmGsBq+2"
X-UUID: 5f7a24f8120e11f1bcd7499a721e883d-20260225
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+D4CLbTk24ncCYCoRVrOpyqiQfwp2gtBo2bb4RNjcUg=;
	b=JPYG06B32Xwe3iJF8YiGO4x1RlgKZYDwKs1r9+TAGi8929gShXI8sXVs3DVM3sQ91taDLbiYrhbfbR3Z3SlxxZTUyNCGzcuONAv9cME422ydtWEsd39lKmEtKC/3yyRbl0d/+7OnFo+p2PJ3rwe2NtEYl0yimgvQbYcNAlXls/w=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:bfbbee3d-2fb1-4d1d-94ca-803a59e7d198,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:cc533e7b-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5f7a24f8120e11f1bcd7499a721e883d-20260225
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1031972842; Wed, 25 Feb 2026 13:53:56 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 25 Feb 2026 13:53:55 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 25 Feb 2026 13:53:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BAQfYN9/+ROAq7sRGIvUiCmEZqVzSp0TkjI2Ii/9/EbFfD/mICkHhHcKMGAnHEveW9ZB61dlEu3sumS4k/fQAZ5iwxaENWa2R6/DxlsCISXeuQNDVSP5vtrfyIVWQT+WmfkvNgBepbK585j44jiLmRQbNhN7O9r+I9EIOsE6hX95chNw2S/pxJqV8ztmjqV8AJcJAfE+OGSFN1nz9yaMq6anhDOst1BxiZfvUfyT97Myy/3cE1oj1fXZ8TELsY1FBpE1a/hdV0539QUJdHi3XUXNlbK5S58J17nZ/nsOfbKtgN8rMq1A/yyB7iFfhcLprRxNE58rMdJq0gfrJtGEhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+D4CLbTk24ncCYCoRVrOpyqiQfwp2gtBo2bb4RNjcUg=;
 b=uTUYHggtoMr0wMMRjoOMEWRaFoZPINWLoHiycJDzV0NGPnwN72fdQ7Uo3bCL9C8dJ5LHvDdAF8qtABFJpXFkFAK+HeDaEEgNJOaiG2vLbdl44L/R6vgatVw9HuYYBZWdeoQ2c8J7MmfSW8+7ihrfj6EAtumgj6keDNsd+PDXS9EoRod9wMfq0CuLbEiaNfW+VCxvrdZY0kxnwTyCR1yPm+XZzoU6QHpQtyr/E3zS3vob/oYVpUMMnYqkrm6uw11YPrdmk0ut4YGxVSU2LA18812odEX6L7zzTQOJCy/8Ipc/WCAFCTwBMHzDQKVVbHzwSJkVYH4tnUCAOgDCPRNZ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+D4CLbTk24ncCYCoRVrOpyqiQfwp2gtBo2bb4RNjcUg=;
 b=nmGsBq+20oY1dlTU2x25tiIUTHDEFGLk5eXPaueMhiDQwEpeG2WAXWJSNS8W9UauMqj49RVCwoP8c84u6X7UoEAlpT5oc1MBaXN4//cn108DftVoxIyFUJT2/hbWWEx8o2S6IoVz20N3RNrSh7tpUW/4nywDm/FcNkllGvVDaY8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYQPR03MB9556.apcprd03.prod.outlook.com (2603:1096:405:376::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Wed, 25 Feb
 2026 05:53:53 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 05:53:53 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v1] ufs: core: Fix possible NULL pointer dereference in
 ufshcd_add_command_trace()
Thread-Topic: [PATCH v1] ufs: core: Fix possible NULL pointer dereference in
 ufshcd_add_command_trace()
Thread-Index: AQHcpJGdyX5pkVn0gEmR1tR/eLThzbWQhk2AgADNrICAAL3UAIAA20wA
Date: Wed, 25 Feb 2026 05:53:52 +0000
Message-ID: <066c65061be16076e60d5fd4a57a773c391a189f.camel@mediatek.com>
References: <20260223065657.2432447-1-peter.wang@mediatek.com>
	 <5017b907-16de-4d7f-a7c6-dbc504ffd1eb@acm.org>
	 <399765bade9b7adcca89a94313e71635d1336172.camel@mediatek.com>
	 <72757f9f-20de-4fb8-b5eb-507dbcdbe22a@acm.org>
In-Reply-To: <72757f9f-20de-4fb8-b5eb-507dbcdbe22a@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYQPR03MB9556:EE_
x-ms-office365-filtering-correlation-id: 0d7fd704-55b7-40c5-3a30-08de74324195
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eEhReDBSZFhuQW1RbmlNSFRsOXVtMzVaQlFkZlhhOGQ5bEp6QkQ5S2N2MXBF?=
 =?utf-8?B?d2JKNUlwQWROaHVmRjFldnRQNjNnZGtkMlpyY2MyRkVJeFFaTEJwOWdFOUhh?=
 =?utf-8?B?ekZWdmNYVXNrVjM1bzZQWG9kZExYbktjVTNOVFMxMHRKRnhqU3dBWTZwYmR3?=
 =?utf-8?B?ZVlnQXJjMWVic2pLRVpRZnVIcDdSMitUdVROa0I4andxWGx6RUlOVldsaHc1?=
 =?utf-8?B?TVdNVW12NExSZXpCd093NmliY1Q5dzlYQTFCV3RvS3RQMjQyZ1JOdDc3WE0v?=
 =?utf-8?B?ek9kZm50Qmp4KzNyTHBWalhqcjRDdzZQMVdsY3dobWEza1YrY1pCdUNBUVU4?=
 =?utf-8?B?aE1JcExkd1lBOU96WFFvVjFCZHUxZGt1MXh2TjF1eFZKdXEzQ1dzQXArWU1u?=
 =?utf-8?B?dmFQWmxNRFpNZE9kaytEOUxsei90WWZJYnB2MTlOcTYvQU9GN1JrWCtzaVhp?=
 =?utf-8?B?c25LZ3Q1TklZSTZkQUdlUys2ejd2bHZzWTFRaVhTREorUzBXOUtCV1ZrWGdT?=
 =?utf-8?B?cXI2bmVJVUQvYjJZUkkreWQvNzRyTWJyWG9LOXZvbFNSQm1ieVpEREVZaFFX?=
 =?utf-8?B?M2Nmd3ZhcG9EQ1ZkeUI5R3Z4RGVHOW0zYUZDa0VBdnp6OXFlUXo1cjFkdjMx?=
 =?utf-8?B?bjMrMzNJdkxvZzlJSml4VlJ4Nm9jRkw2Vk9mWFpmaHJ5WC9yU1RvQVhYS2hD?=
 =?utf-8?B?MmlCckdxK1laeElJckhNLy9ub1lUd0MxUEFLU3BxSzVNQkdmMVFVNzEwdVdt?=
 =?utf-8?B?UjN2dHcwVVlubWNLMUZ0UDB5elpGRnRnYlE2MEVub05pWFBYNDhrSTZOREUv?=
 =?utf-8?B?OG85TVJWSEVCNUwrZlAxRVVUbUFNbTRiU3JSQStQUmx6eGh2UWlZc1AyRnpD?=
 =?utf-8?B?R0xCbUR6OGtUazc3T1BlaTBVaTJBZlE1cTZFek15YUZWRVU0SmJoWEJCZ2xw?=
 =?utf-8?B?TUlhcU9BVWJlUktKZFdEcFBTRFdRMjFQQ2JhSElEZDhCU2NYdzY4bG42MlRz?=
 =?utf-8?B?d3NjbFZ2MXlEbVl5NE9wOGVLMGR5VCtRaU9GTXJ2aitZL0hLR1g0TU93aFRI?=
 =?utf-8?B?L2tlWjVzb2c3R0ZOZUZSeGFqUDlSbkVwMnN3aTBuamh2ZWd3MEo0bDNyS2s5?=
 =?utf-8?B?TityN1hjd0YwSC90UElSbmRiV1RzekFTMDgyTmJ1cDBLNmdtRy9EeWREc3NT?=
 =?utf-8?B?RjZMTDJpV2FrZDR0SXFPeUNmNFhrc2xYSmRQakh6cXA2amRBcUN5cyt4VlZO?=
 =?utf-8?B?TkdnRzZGRjA4TU5mNVE4RThJaWxrV052bzd2NzNsdi96Y0FRcjdrTFo2S0pI?=
 =?utf-8?B?d3BOaDBGWkowRmtlZEJGdlpYWk0rVlVFTXdLc1lTT0RVS3NobVNCaTRqTW51?=
 =?utf-8?B?WlVOOVpVcTBqMzBDaUNMamdaOFRsb3hNbFc5cThSZy8wMGFJa1FYQ2ExeGRs?=
 =?utf-8?B?eW1UQjYxYVFUU3RVcFRsUFpxMTBpYlRtdFh5MkRUUWhpeDNuSkRTVG0zL0R1?=
 =?utf-8?B?RzgxbHZDUmlzTTAvZzByOXdISzdKb3Q0SExyVmlWZEFUanFBZ2dnMnJ1RmE3?=
 =?utf-8?B?TDB6Y1RwUzNyQWFWK0RNOVdlVG90RDl6L1g4MFEzSmk4bk9BZklCVmZGR1Ex?=
 =?utf-8?B?QjJPQkEvSW5WWjJxRW1hUUVVUEhRamh3aGVBQmlzcHNZOVBvVU9pbzFuTk96?=
 =?utf-8?B?a1FCT0pNcU1SMHJWK1kremtuQjNmdVdwcUgyUWlIVGMzb2ZWanFQVkpoNW01?=
 =?utf-8?B?ajBySGQ3UGZjOTRUOHV0NWpQL0p5Q3RLVE5Lazc3UUFnY05ra1VsdzROWUc4?=
 =?utf-8?B?amU0N0hMQkRWVlV0ZCszeElra082YWJZUWZwR1VDSHF5ZE9VUnE5TVlPWFhm?=
 =?utf-8?B?bHVIaWR3UWNxN0NZcXI2OEVGbGpIVkluMUxHeHJ2eVRTV3plbXBKbVgyZG84?=
 =?utf-8?B?VW1yOVN2T0hIN25QcjArQnY4RDd5bVpqVWZhZExnRnJzemF4Y1BEZjRtSWlr?=
 =?utf-8?B?RmpwcG1TY293Z2xtY0I5YVJCV2hiSS9tRTVoZ3czN0tJTytmK01lU0hSV04r?=
 =?utf-8?B?RloycWdjYVcxSVJrQzA4bjRRY1MxL0lOZWpHcXgzNi9XeVY5NWppdjVTdkF1?=
 =?utf-8?B?TCs1TDB0Zy92K3dPNDZiU2x3Y0FLeGx2ekpYUVdmZ1d5R3IyNG1rQ0ZST2Y2?=
 =?utf-8?Q?w4FbYeNkoEi5OG1rL1Qj4P8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHVpYVNDZmlyeko3OWNKOHhnc0JlYXp5dWdvRHU3ZlFoeXRnczFRa0RrNDZX?=
 =?utf-8?B?UHJmYUlwd3lSTUd4NVQxdW9INGo0S2xQRkZqNVMzWnNWSHpmZmVuMUdFdHZR?=
 =?utf-8?B?TGJkcUxwSXloUk52a0FUdUtVUDVoUW9QMnpocU14a2NZNjdxZE5KOERJOFE4?=
 =?utf-8?B?SThnaDZZS2Q3NTM4VTE0L3ZsYW81bGFoMXFlVUNYOXQ1Sm1yck12dklLV0Vo?=
 =?utf-8?B?UTFGdm5DTnNsOFFKNWRoU1FoRlVYeWo4azJIc0F3SEdzNk9SblJiUnRlcGlx?=
 =?utf-8?B?UXFNWTFDQ0FUZ3FROVFyL1oveVpBTGhmYUpUTkdYbitJbU13UXpFNlgyYzVo?=
 =?utf-8?B?Wk12WVZqMzR5c28yK0duNVBvOXhISjQwSWpXY3VxWkdyam0xZk90VkpuOTJj?=
 =?utf-8?B?eTZJWmkyR0Erd0pubmVCK2Q0MUo5TFZKWnczNkpSSTFwUWk1c05aa0J1NWp3?=
 =?utf-8?B?R3diVWs2aS9CSjZjUVhFYzkvZnFxSDlwdzJ2cExHYW51cUJqV21tMTRqWlhY?=
 =?utf-8?B?dXV6WHlkOTdLWEtLemxTRTloRWRZdXBsUllyTlkwZHhkZE5ySlllajBDc2d2?=
 =?utf-8?B?bGVCWlc4MVkyeE5ROFVVVmk3VWFkT3AyMXFRMzU2RlNocms3ck9DbmhwVFhp?=
 =?utf-8?B?RkZkN003SGNOcktBWlJDNkhkcWhhMFlSODc3cGVHb20xSTN0UjBzRFlCRXQy?=
 =?utf-8?B?M0VBSUNuaGtQN291L20ycDhlZkg2NzJSKzRlV2VZNjVuVU5NNGRtMzdlTjdX?=
 =?utf-8?B?ZkFYdFBJZWFnNHB0dmZYZWRjVEwrMVJEUCtpdXV4amZVZmNuVnVsVnFlZVBr?=
 =?utf-8?B?L1Nxa2ZVZ21NNHEvRnp6NUFuYkNJR1pxUUorZ0ZOejY3S21oM1RMRU1pb0l4?=
 =?utf-8?B?bmdyc2FpYlBYRWRIdlZ3TDA1a1NULzViS0dxTEo2dkhUaGJGak1xU1JFY09q?=
 =?utf-8?B?YWRrUTdSa09ESW11K1pjelN0ZXZMK2ZQN2tQSlpTSVhjbTFsbmFROWw0eU03?=
 =?utf-8?B?c2hMNU9WYXR0bGlTQk90ZXZWWGV2ZzVZUTN0N2VWOXpHOW9HNTlPWWtZdjEz?=
 =?utf-8?B?bTVaSEdLVExuT3RoTWFHcUlvdFcwMHh6bFNyQTROSGJsMFRJOCthQkxORHRv?=
 =?utf-8?B?QnZmVlQ3bElYRmg3T1VXWGNrWXJ6YTBzZjluRHZLUUVoRFVaVk1ickF2dTZE?=
 =?utf-8?B?YnM4czRGSnczVXJ5ZXB1QTRxYXlxSC8yZFpSU0FncEtTNlFlYUlhU1d3Mitn?=
 =?utf-8?B?dExLalhRQkV1QWpzL3UvY1ZGQUJ2bDE3SXZrZWNwZ1hSRS9JanZuQlRpWENp?=
 =?utf-8?B?aU5wWnd3Z1doQmN4SFNEUDc3Mm1uSFU3eStYdEtMWk1nZ3U3bW5nWGZqRTV3?=
 =?utf-8?B?YmpwQndrZzJvdStZY2lPNk0yY3Y0bDJRTXJ1OFJPNHRyMGg0dWl5cmk5QktE?=
 =?utf-8?B?aTBoay9ZUCt5cS85NlFVVjQ1NlU2MENtMTlXRHAxb3FrL0ZvQzF3S1VDZ2g1?=
 =?utf-8?B?V3ZXc3hiSEJVM2drQ09Ub3d4WWcxQ0crRDd2Qm9uMU1ML3NRSmloZmtKRUFr?=
 =?utf-8?B?STFqZitpTjNxWHhubnNIZnVjdDhtYzB0YWxCeVVuOHBnTlFLUHk3TmZIeWtr?=
 =?utf-8?B?WHAyOVdjTHFuOUR0Q1FoekdnRDZNOXZ2N0FDZ3Z4c3ZWc3NmTkRRblNoMGVB?=
 =?utf-8?B?NWhJVFo0SklyMUJjVmJYTmtpK2s0cGx4b0FHRGxXKzZyUUdZUGdFT1hMcllC?=
 =?utf-8?B?VWhodmMrNkRsNUNXRENwNE9xTFNvNzd6aFBoT1pjYWd5YUxRVUtBYUsrTjhD?=
 =?utf-8?B?YnFaYk9FYm1vSHhmUVJwd3dSMjhmdnhXb2lRWUE0Rkt4b2hHMlR6QktjSmxh?=
 =?utf-8?B?bzZEVGlaWGVyRUF3VUFoUFMwaHhSd016Sk82WktnSklKOUk1UEpkRzB2NUF3?=
 =?utf-8?B?MzdsQXhwK0E0RlM2OENjK0pmdDh5VElwb2FiNHhvOFpOMnpqL2N3SHZYd3gx?=
 =?utf-8?B?QTgxS0M3VjZMQXB6S1lHU0hRNCtkd0pHcTZ4VnRPVDEweGI5NGNZTlFYWTdq?=
 =?utf-8?B?YzBWTU5qNTBmUW9oOXVKNWtEQWgxaGJCYXNoV1NaSW1ERDNBZFFWcE1HUzNL?=
 =?utf-8?B?dXo3WWlTSng3QmU1Q3N0UFh2ZzFuSUJ4ZHNPK3YxRzR1Q1EyeW5GcmN1K0R4?=
 =?utf-8?B?ZS80bVdkRHMrMVA3WHIvVXFvVk1UNm9kSlNEKzlZdmFlOGpnV0xwZUxwK3F5?=
 =?utf-8?B?ZHdwekxOeStNcWtNbytydnFESHhtZnJETXlhbEU1NWRPenc5NmRjVHFyYWtD?=
 =?utf-8?B?WXVuS3JnMk80L1djcEVMRHNVY1NZRWJXSStnd3BKcVhGMnM0enJHSXMxZUNN?=
 =?utf-8?Q?Ru/YX2ksHxozI3ss=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7EDA888BAF5DE41BF806EE91B349EBC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: brgh9okDH6clIhyKS4gJfsqM8+nhoiw0GMlj7z25KW/6wPqE96rtyDm7yhMQulx+Fl1mrMTVBYXOxA8MxPARwgkBAsH/ibAtOIf4maATx7vW6wJrDLesKVeF/IZwmWD/gZLtzHl9cyiAY7DhaH8y140zmP2RJBcZPveHphOh0vR1l5RSfcljwBr/8DO3utPuZwEJ/R40m7oQPM+uLLnFH7srmQJO4wVhhWHoAOIlP8P+ogl1NiCdGuU/HgGojz78F4honf89E6zWqDwKqUI7V7L5pQKEhTaQv6E5mTYd8eX6zsPndIuIXQq19MkLhjvcgsSJlPox6ySMOqzeCb8EVQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d7fd704-55b7-40c5-3a30-08de74324195
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2026 05:53:53.0113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QWe6tYeN/IwClnr/1azaceaxrn/s6+FsCKe9ZlqP7uI7I9uZz50zTobUHku4Pi78hyOMvd87Q6HDOwJ72Mlqow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYQPR03MB9556
X-MTK: N

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDA4OjQ4IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEhpIFBldGVyLA0KPiANCj4gVGhhdCdzIG5vdCB3aGF0IEkgcHJvcG9zZWQuIFdoZW4gaWdu
b3JpbmcgdGhlIE5VTEwgdGVzdCwgdGhpcyBpcyB3aGF0DQo+IHRoZSBjdXJyZW50IHVmc2hjZF9h
ZGRfY29tbWFuZF90cmFjZSgpIGltcGxlbWVudGF0aW9uIGRvZXM6DQo+IA0KPiDCoMKgwqDCoMKg
wqDCoCBod3FfaWQgPSBoYmEtPnVocVtSRUFEX09OQ0UocmVxLT5tcV9oY3R4KS0+cXVldWVfbnVt
XS5pZDsNCj4gDQo+IFRoYXQncyBtb3JlIGNvbXBsaWNhdGVkIHRoYW4gbmVjZXNzYXJ5LiBUaGlz
IHNob3VsZCBiZSBzdWZmaWNpZW50DQo+IChhZ2FpbiBpZ25vcmluZyB0aGUgTlVMTCB0ZXN0KToN
Cj4gDQo+IMKgwqDCoMKgwqDCoMKgIGh3cV9pZCA9IFJFQURfT05DRShyZXEtPm1xX2hjdHgpLT5x
dWV1ZV9udW07DQo+IA0KPiBBbnl3YXksIHNpbmNlIHRoZSBwcm9wb3NlZCBjaGFuZ2UgcHJvYmFi
bHkgb25seSByZXN1bHRzIGluIGEgc21hbGwNCj4gcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQsIGxl
dCdzIHByb2NlZWQgd2l0aCB0aGUgY3VycmVudCBwYXRjaC4NCj4gDQo+IEJhcnQuDQoNCkhpIEJh
cnQsDQoNCk9LLCBJIHVuZGVyc3RhbmQgeW91ciBwb2ludC4gSG93ZXZlciwgdGhlcmUgcmVhbGx5
IHNob3VsZG7igJl0DQpiZSBhIHNpZ25pZmljYW50IHBlcmZvcm1hbmNlIGRpZmZlcmVuY2UuDQpB
cyBmb3IgdGhlIHBhdGNoIHdpdGggdGhlIGZpeGVzIHRhZywgSSBkb27igJl0IHRoaW5rIGl04oCZ
cyANCm5lY2Vzc2FyaWx5IGFuIGJ1ZyBpbiB0aGF0IHBhdGNoLiBJdCBzZWVtcyBtb3JlIGxpa2Ug
YSBjb3JuZXINCmNhc2UgdGhhdCBvbmx5IG9jY3VycyBhZnRlciBlcnJvcnMgaGFwcGVuIGNvbnNl
Y3V0aXZlbHkuDQpBbHNvLCBzaW5jZSBNYXJ0aW4gaGFzIGFscmVhZHkgYXBwbGllZCBpdCwgSSB3
b27igJl0IGFkZCB0aGUgZml4ZXMNCnRhZyBmb3Igbm93Lg0KDQpUaGFua3MgZm9yIHRoZSByZXZp
ZXcuDQpQZXRlcg0K
