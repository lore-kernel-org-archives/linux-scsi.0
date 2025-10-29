Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2FC72F60BC
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 12:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761741193; cv=fail; b=bqmw9Lp4NBVQTzyXz2zcemmXBIHdrtH3wtlcJfR2VZ0IX88AwmKM8kXfp+XWOext7sJyr75d6exa7a5nq8OD9ZLHXm23g6av7MZ9Tc5KPltHKlOkpnzwwj3NDUtmxD9lOvLjSztXDq3OFOPMfTK/NfF2Szaq13xNct8MaCsZAsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761741193; c=relaxed/simple;
	bh=YGtPUG9HemPNyrE1O/fITMvHZzVh3Qagwy94xV3PH4s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DcpZdp9vrevJ+YfMdFMVPLT6I4I/QlfkDO7mZ/13SHiS9SxqrjmzzmQ7L7fVdahwu46v7/nZ9sTtCqayXjUxgusmeEupK8YPKSTNLmwRsIqReN5dPgplLY5cT6Ec5unNRrhanx+lgLuvnREdyCdp9p864OtBn32LfPNBn32cj84=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=flMl9hKb; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=sPEZ7+Sd; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="flMl9hKb";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="sPEZ7+Sd"
X-UUID: 6b02f4bab4c311f0ae1e63ff8927bad3-20251029
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=YGtPUG9HemPNyrE1O/fITMvHZzVh3Qagwy94xV3PH4s=;
	b=flMl9hKbWEi54A0TuFsqjexRqPxNRMfSvUiK0cR3v7j3iDGZxNm2UgpMFyAHz/cVUZlkKhCFMPPcfaMv87o9KyEhE3THsbpdRPnMZIbhIXUs4qJOUtoLC04OxVCkaTlx4MDTofrjfDunb73PTVIopZGnZ7BhrFrzhmGMkp0JYsY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:29f62e38-0f69-4f6c-b3f0-065dedeb7f1e,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:87746326-cfd6-4a1d-a1a8-72ac3fdb69c4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6b02f4bab4c311f0ae1e63ff8927bad3-20251029
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1928118315; Wed, 29 Oct 2025 20:33:05 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 29 Oct 2025 20:33:03 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 29 Oct 2025 20:33:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UnID1tVIbUs73fVBBY84OODYmaR1oABASy+G7NE0yqikxI5+vWGSmh4Qz8m+FeT03rfX7BlAm83UtDMrJg8YPtK3ieLCxmznGPFPMDLiVe9ITZWJ95z/hFSlGT8GyQbcroa/mL6P4UFheMZ32m+/1grJmOxOCCO2O1ak1aSfdGT29qy7EklhAYfF0oegx+CQIYk1MDyLDEKfQD8SYlI/BTY5CKdbDW5uLKNtOmvX35M7jhm65MuD3ccGHS/xzJWJ630s1c16neTulF5VE1/EtVkF6GiId4KoNo7oP0CpmrxXAB3vaC5RoPUUY2vn+4yawI+RZE0w1zeKuzM+CxGowA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YGtPUG9HemPNyrE1O/fITMvHZzVh3Qagwy94xV3PH4s=;
 b=kGM52exWzQeEcACVCALe7GbOVLFR3rJ+GUGp57V6cKGJFLw0w7nJWHXDYij5vMedydiKnNOVrAyr/oVo7fq6Sbk1cmhJd0KN9Ytj+jdk4moNDVuEwNLTukDUCImZv9zxTzHipJeP7BKsjeNDAekMhIjMw7vSFWUDoBhr6ZPyTB/bSb93nQZdyBRa96uBqrf41qTjI/56OdzlA1vtB2+KNlpR5HgAdhHs7JXIdnVavEsdyF/hxqfy0VeTtBoqzAZIa9nrcf4eQRt42/g5aLwbsvO1BOCL+pEgW1l7GEws3M1XpDFiZSSms753MybxFzb2YjxsCyZXyFjMhEbVW9+VJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGtPUG9HemPNyrE1O/fITMvHZzVh3Qagwy94xV3PH4s=;
 b=sPEZ7+SdxzmNAicfWsWLQlIlWKDfFZGXz8sOS2ssNOBL83VArWG0qUTPUQG8JobhW5qrcb/hX5k6R5wjXy+o+wtK/DvQM2B5FwbpAiTvy2DWS3cEkZ505z7zW/AsV4kPP2wNfpD+5rYjbiJSUvh3AdNODE9bR/AQyQBxe38JGAM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7551.apcprd03.prod.outlook.com (2603:1096:820:e6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 12:33:01 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 12:33:01 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "zhongqiu.han@oss.qualcomm.com" <zhongqiu.han@oss.qualcomm.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "chullee@google.com"
	<chullee@google.com>, "tanghuan@vivo.com" <tanghuan@vivo.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, "andersson@kernel.org"
	<andersson@kernel.org>, "gwendal@chromium.org" <gwendal@chromium.org>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, "huobean@gmail.com"
	<huobean@gmail.com>, "mani@kernel.org" <mani@kernel.org>,
	"neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "liu.song13@zte.com.cn"
	<liu.song13@zte.com.cn>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>
Subject: Re: [PATCH] ufs: core: Revert "Make HID attributes visible"
Thread-Topic: [PATCH] ufs: core: Revert "Make HID attributes visible"
Thread-Index: AQHcSFnHH6m8dAd12UuxHiOZsl2XSrTZD58A
Date: Wed, 29 Oct 2025 12:33:01 +0000
Message-ID: <8e0c82c6d390edbf5eb34138fcc52732e7014100.camel@mediatek.com>
References: <20251028222433.1108299-1-bvanassche@acm.org>
In-Reply-To: <20251028222433.1108299-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7551:EE_
x-ms-office365-filtering-correlation-id: 354a4f56-6348-442c-6c9d-08de16e74cd9
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?M3MyNkFFQ2liQUxkOFNVUGt4WWtCbGRYUDdFWm9lSWVhT1FSdC9JMHVqalB2?=
 =?utf-8?B?WUZ5UkttT0JGZ3QxRzQvbzRZS0NuSk1IcXY0Y3lIWVlJT3YrclBZa0MxR2Zk?=
 =?utf-8?B?TDJjRHpGdVJBTXlqbHJtb2FEK2VKWTlWdWF2a0NvZzBReXpXOE9BV1hFbU5p?=
 =?utf-8?B?enFNZ3l6QUorallWNEF3SHZvVWxDZHEwQit4bTVlRmVpMVFyMVFkUlBzdEZv?=
 =?utf-8?B?VWxnSkNvemcrSmJZTlMrNUdxRStsbzFKMk1CeVVOMW9XZXJJNXJ2Qng1UFd5?=
 =?utf-8?B?Qk1qSjVrS2E2c2xXa3FWeUZtblVIdml3THV3Zko3dmJlYXdlNXhtOC9Sd1lj?=
 =?utf-8?B?eFBCY0VMY0U5ZkR2MFdWNUc5QTJYU1JMcSs4Q2R5LzVUdldEWjRiZ2xkM2Ni?=
 =?utf-8?B?V09pTFloSkZkSk9TaSs1elp0eGpERXZsRzc2cndlNTFRQ1RzeXh2cDV4alZT?=
 =?utf-8?B?alp6L2JqaDdoNWJmenRVN1Vla1ZIcHhIdlIvRlRHVjFBSktVeVlpd2VUMnNO?=
 =?utf-8?B?UDRlRGo2TmRhbzNPRnRlVXB1eUQvOW9mM1dNOUJqUk51Skk0RzBIaHpxM05t?=
 =?utf-8?B?U3JScVVzNDEvRGRMOU1TNEdnYWpGRk1TRXdNVFF4TmRhZHRDNGlQamdFelhS?=
 =?utf-8?B?UDBKSlY0Vm1WMzVWdUQvSDNhYUxIL3VlQVVXRXVyL2EveXc1a0tncmRrNkJ6?=
 =?utf-8?B?OFprQ1VhNFdnTkQvQjVVUkljb2tSZVMxWndva3JKODk2QXZGNE95Ym1GTUx5?=
 =?utf-8?B?QnVKOHhOQjljZ0JJNjhYejYwQVVkRkFGdmgxV3NNNEh5aGZEZzNCczBSQWtj?=
 =?utf-8?B?cXlrQWI4UWc2WjdwakZyMkVkUnUxWXYzNVpFNVFpMVZZbTBVazRGTEY0M3pz?=
 =?utf-8?B?U0l4QkhnMzl2eWtOQjVXdVRTcDUxb1RWWWRxWU15NjFkb0JhMzQrU2N4SDY1?=
 =?utf-8?B?c0pMd3YzNWYvdEwvYjZMVkZkQWM1c3Vjb0xKNE4xellrelVhZUJkUWNuOWhk?=
 =?utf-8?B?VW9xdTdVejFZUE44QlF4QUhFTWxIVFh5d0JPcjcvdytkdW1vWG9tUUQrbjZR?=
 =?utf-8?B?T3JlRFdQWTI4cDRtNUpST1JUQVZYeUt6c0JHMzEzTWRlUGNJSmRSL0Q1Kzlm?=
 =?utf-8?B?NzFETzduRlFqTWlQcnp6SzRROGFMNkdMdU5QR0k0a0FpVmdXdHRHYXc1WWlZ?=
 =?utf-8?B?K1lIc05IZW14VmRWVXQxeWdGTFhVejBqWjJCM0hwdklLQUxUVElMRlhNMUJm?=
 =?utf-8?B?QmJ4MDErbFhZOTdqdi9JNU0vd0hRNytTam5jWUJEL2cxR0FDVGI1QnluRDNh?=
 =?utf-8?B?Z0VMVWlrVlpZU3Y0dHNjWjkwTU1lVzhzZWMxS1FFTDRiZW9yYTYvcVhtbGZt?=
 =?utf-8?B?c0xRZFBpeUtPZ0FGZk5TWFRXMlplaTIycVZmVi9HRnJxNlhTOTBXcm16Y3R3?=
 =?utf-8?B?Q25Kb0NGVWZEMW9VclRiVW5aMXpVbkRtQ3NzTUFTblRUQ0lNZmQzaGF5bEdC?=
 =?utf-8?B?dEM2NGxFa293bC9jcERsS2tNV1NWRlpUN2NEY043RmFqNkRabFZzdWxOZk5a?=
 =?utf-8?B?dTBKeEpDTE5POFhJRFFZcElxNElGQjlNdzhlblhGNDhqc01MMWZ0V1lCSjJH?=
 =?utf-8?B?WmxKdFd6N1R6Q2ova05JOFRRZFhIUmJBUEE1MndYR2RyK2cxbGc4Sjg4UDlK?=
 =?utf-8?B?cGlBb1luOEZIeXprWmFQaCt4ekN6b0Q5Z1ZweitBd0loQkU1aW4vay9jRWwx?=
 =?utf-8?B?YkI4cTNBZzROVXBMd1VPOTFMTU9RZk43N2J6S0hPV2Vvb2d3cUYxZDdFRzRp?=
 =?utf-8?B?S2ZrYnVQWkRlK3VtVjJtQm5QWXBPNzVuRU5xUElSckNSK0d6TDJneXlmWm84?=
 =?utf-8?B?QkVSb2llQm8xSVhNRzluaUhrSWtDeld0SnFPTkFHbmcycnJFNWh4dkNWRkta?=
 =?utf-8?B?TGkrbVB0VlhuaWxVVlZYckhhOUlPOEJRaDVsNWhIZndITmtIWDN6RmpDMHVW?=
 =?utf-8?B?OUc0MERBTWdyd1JBc0JETTJTMGRtYUFQdEdLaXlzOUFMcmR1VmtxZVY0ZFkv?=
 =?utf-8?Q?kvtIok?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wnl1ZEg3VHNlK1ZTQjcrcGJHMzhDL1I3UEFWWXVDd2RPSDRFQXRzVzh0Y3lO?=
 =?utf-8?B?eXljSndzQ2p5d1ZSaENuaEJFQVJadUxyVzJxRFJXNWZhQmMza3RoY0RyUVRV?=
 =?utf-8?B?bjNEOVBiSXdOSmpkTlRJdlNjYkpsQ0RHd2RnZ1dWcmc0Y040N1hRL0IrOUtU?=
 =?utf-8?B?enA2dmNNM1Y0YzZBc05XcFM3UmhLVXlxcXdsMkFGeEo0SkphMGptUm5NWDIv?=
 =?utf-8?B?ZnUrKy9paHhYR2xUR1FoQ2c3WjdFV245eTVHYmI1U0IraGxZTXhHeXRVZXYr?=
 =?utf-8?B?YlRCSGE3NXJoREZiVFFNKzhXZHdFU3F6aHBKOU9NVkc5UnJlUk9Zd1cwWnpu?=
 =?utf-8?B?dzZTZ0orL2QvTUc1QXU1aEVaVUs1YjNDV1ZUdEUvcFJ0aFRoNFRYY0JycVhB?=
 =?utf-8?B?VysvT2wyMXFPQ0dncFhseng0VFBDSE1GMzN4OS9nUDhMNnVBWkVydHdjRFhZ?=
 =?utf-8?B?cm1IcVNtb1lEcTZMcDdoNXk4QUZ3NnZvMFlZN2tRT29ES0VIM3lzSFRJN0dm?=
 =?utf-8?B?SU5WRTJxek9wcEM3QXN5bVpMSnRuRXJ2M0lnSk14QW83V3RXQ0tlcVNUbVcv?=
 =?utf-8?B?VGxxUEcvTmJOYzhaeHRCUW5yNGpiZEY2aE9LWlBJbGlBTFhMa1hja3BIQ2RF?=
 =?utf-8?B?MlVkUnJhOGEyWlY4U1JPM1lPR1JmdGVpQUZhb1ZzUXpXTmQ0UTRwdzFBem1K?=
 =?utf-8?B?b0JlUkllZ0UzbFVTMVQyYnFTREgxdER2L2tDdUYwc3htRWJneHhhTHVrMmpO?=
 =?utf-8?B?bEVoVS81bEN6SDVZd2puNm5Hbktmbk9KdWZ1bXpaYlN0Ly9BSmxROHNVQnZ6?=
 =?utf-8?B?Qk1EMjRyQUJVeDc1cFljbm9oaFhpVk42MnNISVEvelhna2ZuTEhxVFFSMzhX?=
 =?utf-8?B?Y2IwdWdTeDBFejN3V244cm9PWE5JdllnTEdvTWZHS0JZenRST2dLUVJaYlZV?=
 =?utf-8?B?WjNFVVlpREI3TGpjVXpTZ0M3Tm1iSm9OMUw1cnZidVZ6Z05UWVBHbnV6Ym0y?=
 =?utf-8?B?WkE1eGRRRXd5SVpHYitqcHYxeGJqbDN1WDdXcndUZHhtcFNBU1M1OENaVk5P?=
 =?utf-8?B?Uktta3dNSkFHRUJoL1M3dy8zWEdYWEpYcHhIZ3Z4dGVGd2VRaXIrMlJWaGhQ?=
 =?utf-8?B?TGd5OGk1UGdmRlM1YXcvRWVpV2FFaC9sN09HSFowcGdIWXgvcElXUFhDWUlj?=
 =?utf-8?B?SW9wb3BPeGdoRlNmK3Q2THFlZnBWK0dUaG9OM0RqK1VTbXhZek94WTh5ejJ6?=
 =?utf-8?B?bys4MU1DaWhJV3FYTzdlbm9XS0ZnOTdodnlIdDRucVNvei9WZnJlYW90RHVL?=
 =?utf-8?B?VDEvQTJpd29MY20reGRKUWo5NlNzUWNYZFp1cThqMWdSVG9YMmp3b3E5c1Vu?=
 =?utf-8?B?WDg4eFpkeFhjT3NURHVrSFZMSlNaZFFjeTg3QVUrUVlRU3AvWTVScDZaUTYv?=
 =?utf-8?B?TmpHOWJKMjhra2VHclljcGJVeXV2V3pacXlSaHJYRm1BNzJlOUJ6bVRsN2Ey?=
 =?utf-8?B?U1NHbWlPR21Lc1BEeGlRLzU3MDNEMEx2b1doRzBvWWRHME9SaUVpWkpOVFB6?=
 =?utf-8?B?ZkVqOGdMNTQyTXpOK1R1NkNKU01uYzdIV2N0NTh3TTJaSUJIR29XQktZeUxl?=
 =?utf-8?B?UENjYVZJbVBNa2tvbi9SR3RleGFWcktkVFBzWmljd2dobEo3MkVPRENlZVI5?=
 =?utf-8?B?LzVGSzVMMDlSZERnRVZyTGZ4cFg0Q3oyazZraUZxYjZBV0MvWXdHNVpIcktk?=
 =?utf-8?B?cDU0bnRBam8wemt3VGhCcFlscFpONHg1QmkxNUNVWlM3Y254dy8veXQ1K0do?=
 =?utf-8?B?NWhPcjhMZnVPdFhZRUpqNGhZUVh5U2k1WGJXM0M2T3JISk1xMjRYUWw3UzZD?=
 =?utf-8?B?ODNCb2NWdThXOWphQ2hrRFZualJOQjVQSEZzTU1jVGdnM2J5NS9ySWwwN0RI?=
 =?utf-8?B?SlNtdUJtc2xWMEZUdmNhajBrVHlpRks1V0hYdGx4MHNVWXlPY012ZW5UZUo1?=
 =?utf-8?B?M0hzMWhFQ1lTZCtyajA5YnRXZkp5Mi9raEtjc1VUWjk3Z3c4bzZSdDlBSHlF?=
 =?utf-8?B?TkhkdFhHeGtWY2RsY3A4TEV0Z2ozVFJSNVdKUlRrbW14NjNtUm53cVN0eG8v?=
 =?utf-8?B?Z0VJa3owTGV3UG1KWGwxd3ZsSWJlZUNaSnpBMXdxUjBDc3doNW9odnMvTllj?=
 =?utf-8?B?UlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAE1629EBF61B748A7BFD4ED26D4A1CE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 354a4f56-6348-442c-6c9d-08de16e74cd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 12:33:01.5425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dPFsME5rNec9jG1ZO4rbe2nFe7g+5HdNn97V28KS0rAjZAElRzd8HYujAH+IgvymsxKPRO+3rxTywXBZ+hfZYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7551

T24gVHVlLCAyMDI1LTEwLTI4IGF0IDE1OjI0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFBhdGNoICJNYWtlIEhJRCBhdHRyaWJ1dGVzIHZpc2libGUiIGlzIG5lZWRlZCBmb3Igb2xk
ZXIga2VybmVsDQo+IHZlcnNpb25zDQo+IChlLmcuIDYuMTIpIHdoZXJlIHVmc19nZXRfZGV2aWNl
X2Rlc2MoKSBpcyBjYWxsZWQgZnJvbQ0KPiB1ZnNoY2RfcHJvYmVfaGJhKCkuDQo+IEluIHRoZXNl
IG9sZGVyIGtlcm5lbCB2ZXJzaW9ucyB1ZnNoY2RfZ2V0X2RldmljZV9kZXNjKCkgbWF5IGJlIGNh
bGxlZA0KPiBhZnRlciB0aGUgc3lzZnMgYXR0cmlidXRlcyBoYXZlIGJlZW4gYWRkZWQuIEluIHRo
ZSB1cHN0cmVhbSBrZXJuZWwNCj4gaG93ZXZlcg0KPiB1ZnNoY2RfZ2V0X2RldmljZV9kZXNjKCkg
aXMgY2FsbGVkIGJlZm9yZSB1ZnNfc3lzZnNfYWRkX25vZGVzKCkuIFNlZQ0KPiBhbHNvDQo+IHRo
ZSB1ZnNoY2RfZGV2aWNlX3BhcmFtc19pbml0KCkgY2FsbCBmcm9tIHVmc2hjZF9pbml0KCkuIEhl
bmNlLA0KPiBjYWxsaW5nDQo+IHN5c2ZzX3VwZGF0ZV9ncm91cCgpIGlzIG5vdCBuZWNlc3Nhcnku
DQo+IA0KPiBTZWUgYWxzbyBjb21taXQgNjlmNWViNzhkNGIwICgic2NzaTogdWZzOiBjb3JlOiBN
b3ZlIHRoZQ0KPiB1ZnNoY2RfZGV2aWNlX2luaXQoaGJhLCB0cnVlKSBjYWxsIikgaW4ga2VybmVs
IHY2LjEzLg0KPiANCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0
ZWsuY29tPg0KDQo=
