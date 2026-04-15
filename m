Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F2330F7F7
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 02:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776220676; cv=fail; b=WoM8SnIPuQiMgICPbb0hTDSJTO4GgsFQ4zGNjuqTe1giwIv5fzshzBHFAh/U09uwIuW6t+DOE1Ou2B8pinnHmBpXpmvYZJ5Y/mfhcArKe4dNWvtXbuws26hTx4Ocw7brwrp7ydRISzHSIi54h/UbxepMsPIDX4HKZnNMpI4OWnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776220676; c=relaxed/simple;
	bh=hfpVAGG0GqaRvR/IaJyUMB8PLUnrExrEigstkiJa2TA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e4Wu91USpVKRzxlGezfRLExNCFyAIdhq+4bguu0NHkdAC/XnArpHp4e+FxGbIBRmrRSwqVnJFcaeWAo85ZWPGBivyAy3+iGY3TGOQuvsWIkXr0zh0dYTIOAAmP/uR1EAO2kbcuy+hMUduDdLmmKjrlCRPclQGqGCtJPanS+MsxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Ni1M0O+D; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ZNcGPASI; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ni1M0O+D";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ZNcGPASI"
X-UUID: 139d9d6c387411f19a16598d5ca7f8ec-20260415
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=hfpVAGG0GqaRvR/IaJyUMB8PLUnrExrEigstkiJa2TA=;
	b=Ni1M0O+D00kCECyGr5LBKVWW/K8UBdMWNpm6pLET6JtJE6XUrarn+pPTka0tjiT9EWASMEa+PENeB1K8eoc+v0UhzjfjF7AwPlQhZcA+8qkxz1ILMCkx9pE0fQUhyfUyzkdHH/TpneXdj5QB2Uu9Ki2wHbVb2WLQnBKvI69Iquo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:03b02470-aea4-4adc-a7ef-80a630ccc245,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:9ee9ded5-060f-4ecc-9ee0-121eeeb4a682,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 139d9d6c387411f19a16598d5ca7f8ec-20260415
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 884172361; Wed, 15 Apr 2026 10:37:42 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 15 Apr 2026 10:37:40 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 15 Apr 2026 10:37:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ul+VRiO8wghiFO0npF/QQC4YlPElC8125lJ8130/OI4baRu3EhVTAOhoR7U5vUdn0pB1d0eeIgDUE0IQ7QiBiQ47N/hWyu1zmAkLtIGNT1RWtnIzEHWOib7t0ZJa0tMgusF+tGpGqVgSDJ2k1yskhOmgM/CjK7pX1jYzybrGwoovQlX0yhP2YRyVIkU8VS5gtfCiQHwLYHx6tw7L2PB4OgMZTDMbhTX5x+qnTdCu2ijRRrTvKlSwD3AFgbmA5jiWoeh6Q558mGjCMIqpiY3hB6dDXncuEQ8ok6QycX54piF0kZGpSKHnvxunNEI2pu+NNbdZQ6NU62aVe0jxc3lrZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hfpVAGG0GqaRvR/IaJyUMB8PLUnrExrEigstkiJa2TA=;
 b=YXiGEhCOcSv6eCeI2HWM/D2xTwQn6Owf5edTpcgwmrSc8agwksrJn7OLiUBb+nHnIJBb1Szwa/jtF/3fxzX4h9+xp1rWx5c2VXjBJTELCrLcMmTBbdRsh6KEMKNO+pXMSWfDmWMhIOEO1tFPuGCMzqhJNsVSQOyvvJrD58YCYlBTTVey51GThu4ThRXrV1P62e1pQv4J5I7ObSuVOA9u+Jh7mKpieQQTDexRuIJSS3c2DHPzDCFMHFqaBcUlrWuf7BILL4ZH/oF5VeeCyl8LTy9poM1eS/XMJRHWgUdeuP9K+pWW9UiwgXdGY3f6cthZ2IS9gdK4+S9V1UuAllCyCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfpVAGG0GqaRvR/IaJyUMB8PLUnrExrEigstkiJa2TA=;
 b=ZNcGPASIDKo8V+NC/M5gfoRwjNEp/bRLZT2gKzpRzVhqafBEO/2h4Md2s/wkfbuEiEumtkdyV/qdVR+LVCSgovAhhhs5Y3GQHKv7Mm/jPP/IiU5fOmYiWRYNtYhb5MRetb3nFtFa6us8S5bDAzLQ8BvqwYRHa1ntJ74oJq+gJ1s=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE2PPFDCEB9F38F.apcprd03.prod.outlook.com (2603:1096:108:1::4ab) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 02:37:37 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 02:37:37 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "wangshuaiwei1@xiaomi.com" <wangshuaiwei1@xiaomi.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "wanghui33@xiaomi.com"
	<wanghui33@xiaomi.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix bRefClkFreq write failure in HS-LSS
 mode
Thread-Topic: [PATCH] scsi: ufs: core: Fix bRefClkFreq write failure in HS-LSS
 mode
Thread-Index: AQHcy7VOZiE/9Rd8/UmyMJP6gMkUMrXeCcKAgAAS+ICAACIwgIAAIqwAgAEIoYA=
Date: Wed, 15 Apr 2026 02:37:36 +0000
Message-ID: <bde1df352216412a544113667693f8492324e021.camel@mediatek.com>
References: <60e9a9f1a06692b0a4741058c2b9827c6bb98096.camel@mediatek.com>
	 <1776219068311998.16.seg@mailgw02.mediatek.com>
In-Reply-To: <1776219068311998.16.seg@mailgw02.mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE2PPFDCEB9F38F:EE_
x-ms-office365-filtering-correlation-id: 95867968-45bc-4b35-b7e8-08de9a97f4a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info: 8otIe2V8xDZPaBVNnaeUEJxi2XKWKmJdS2/EP+db1RtTlun1vE5SYiTeMHGRifnRpKLnYDDGywQgd/v8LzP5XIVw8AZcsJv/xKpVmwD9ObAvvV7ZBqeR3w3KZhcKh5WFOWnOILLCGrB0HaP6T/eYGNiO6fqSxf2G4/FPx3nAOPjONQPY+SPKSRUJRv/9Y7AZr5m8+ETKzEsnoaVt4QZRzDzi7IUhhwLJjWWmAnplt5WDxce97FLdy+jdhBaAxUELK5JBjkkMu6SqLqByQx+XtjJ3b/CosEuQlZDHnzuLfKiHaXkhdycKnk23b+EmBSC4eFPZ7wUcBK4pP5/eHZX/kX9bkgX5bg5E6kRkjKWdcjs4GvTTjbYQJbd3ysRRmPdzcszT1lzdd38M3U589CtXmV+XCLtjQ0GNd0Qgt05rOw/FeXn5f7xWpO2KT6Lmx1q6sQNn68czRp2nI0DEm2/ud7Mz61LjjQwsO49uNTIHGzu/ZtsXTDsKmybKt894ZS7TZe80F28hPZo8HwRuMZF3z9a/q54uC5go+rRA21u6QSHNWVs30LCeWx0KspPXlJd5S4//68y6Mumc8/dgPZW0pEoscIl96mj/IUNcazbbdLZSkHOUZdojwMsOiM3t3062E8rznosq7eJmmVKKeM1J+1tm9EQaOsi7mgmHmqtg4vY1Rka4eYuZX6ZXDYp13Pid7u2FQcOtO8hBU8WpsfpdPBZlu7TqIp1kdbSyh9s3U3Vuc2foZDFLbnuTq9ONnvgrl+1/CXfKrxC2kAPUOK6PEDEijilA0nR9fcpjQbu7UXo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2h1bVV2SGl4SWpLa2xucjR4dDNPaVVaaDFsZXZQVVJLdGlqUURZQ1BUTXV1?=
 =?utf-8?B?T2t4MjJ2UTJ4eW1SSlUwOEk0NTRaV0NTUS82WE1MOGJJLytXd0srZlZBSHUw?=
 =?utf-8?B?R3ppSy9TakZYTmRySW8rZEFpYnAzc0tHdXVaOVQ1TWtHbWRyaUMrQ2xSRXZP?=
 =?utf-8?B?WER5SkRGK2kxTW8wTzU1aGRCN245OEl3SEZwMTdWUndyV2lYaEV3bnNLWStj?=
 =?utf-8?B?QlZQdVpYb2d5Y3g5ZDhabURCdWxTcThDOHZiSE1vVjFmaklVODd4NHlicWhu?=
 =?utf-8?B?Wm4zaHU0ZHZkdm1WNmJuM3NNUERyS050S0FLcVpPSTRScnJFamtFVTZITFhQ?=
 =?utf-8?B?Q0xPZWxSL0NCOFp4ejFJajdudy9KdUJESlIwMVRwZGl2WnVJTitqL0s5bzFH?=
 =?utf-8?B?aWhPT2J4alZaZW1SVDhhZ2VoRzdJd1hnYVVwbnVPdWdYdmY4OHBQT0svK3BN?=
 =?utf-8?B?VDV0YzViT2RuVXVCZm5wNVZyU1ZBa05UQk52aFROUi94K1JySTdxbjk4OTI1?=
 =?utf-8?B?czBpTDlEU041Mm1CRTI4QlZ0MlVwWHFGYjZjSE1WTEFuUjRyTEpTQTY3QXox?=
 =?utf-8?B?TzlObnBTSkswOVVCWTRZKzljRy9RU0RzRHdLL0hXci9NTTRwZTdiL2xmcStE?=
 =?utf-8?B?elNmRCtaNEhmSnhhKzZub1E0Qm5ucy9LYktIWTdERjJVSlA1RWt0ZVFkek90?=
 =?utf-8?B?dUlZQnBWWXoyNkphVDgwMUNwcnIzRmFVQ1NsYUFEVVEvNU13TGppV1I2dUtl?=
 =?utf-8?B?STA3SGo2cTlqaGpiZGRiYkpXY3BrVTFEeFovSXhkMFdwNy9oYTJRbkwvd3c1?=
 =?utf-8?B?Qm56TmNQQ0RZZm1Yc0F4cXVQRFBrU2c0emVTUU93Q2lzRkpKa2xvcWhxZkhS?=
 =?utf-8?B?WWFwY3FNMW1PWVRSbDJWbWMyQWQvZFdVUlZESVJ6SEFFSXQ2dlpXMlRnVUhF?=
 =?utf-8?B?TmVDZ1VxN2lBRFQ3aTdxWXpKY2pyYURNcjA4NlJOTjNtcmZKNXBwVGxWSG9J?=
 =?utf-8?B?Ymh3T0pMcjBtOW1YUnZvWXhxdzZaR2tZYTR5YWlrZ2syWDA4bUl6T1B3Yk45?=
 =?utf-8?B?MVQ3MElYa0VFeVlJb1VadlhVc0RWZXROKzNxSEZ6VGdlYldRSGFndEdkV2sy?=
 =?utf-8?B?NFFiWDRZcnhpVEExVDB5R2IzdFlhUGxEK3lQVGQ5Q1dYOGdhem1Ma2dGbE5M?=
 =?utf-8?B?ZEJYWjdpMFF4clZyN1JJOVVxaGdITnc0ZEtQdG5Bc3Z0Qllvc09IWkRBNEs4?=
 =?utf-8?B?Q0pHWEdvME5OQmdvUUIzYzdKZWVPaWRqRWVRK2tnV2NwOURyZXEyMHB4Rlhz?=
 =?utf-8?B?bHh3MDJrTE5PZGtjN2VGaE8xSlM2TVlFZFdIUEN3cnlCOVFUSVFkdUt2enk2?=
 =?utf-8?B?RjJvbE5BeW9jbTNtYkpzTkV3Wis1R1JOb1JPY0tldWNiMHp1UndHakg1Rkkr?=
 =?utf-8?B?SGo1RmFtang0L1hndmRsM1FIek1VZkd1VEZOdHhnWDdSR1dqcWJqNlAwNkVk?=
 =?utf-8?B?cDZWa3U1Y2N1NUtQZFMzc0J6c1FSNHNIWi8wblJDLzVNbjVkVXdVWFZHQlgz?=
 =?utf-8?B?NXYwc2FOd1Z0SC9lbGF6UWZVbjNRTFNjSW9TQTA5ZHVOMHAxVk93RXNlOUc4?=
 =?utf-8?B?cERxdWpLT0FpcG1oQ2ExOE1ReklOaXJ0cXZXSWpidFQrTnJrMlJodzNyOXRx?=
 =?utf-8?B?aWdlV0I4ZG5lTENXTmhWRGlNUExXeW95V0tUbmZJN2k5bDNzY2FrTlJLcFNF?=
 =?utf-8?B?cGs2YWxlVGpGcUpMamNwR292NlBHSWU0cldiUjE3N3lDQ0JwNHlteE5BeUF1?=
 =?utf-8?B?dnBiUjN0T1pJQnFTSTErSWdReXpPakFLb3pINFNjbDE3bmpqemZlV0wxa0FX?=
 =?utf-8?B?akZmYzI4SXRhVUZpREgyd0RpM1o3YWgwd2pTTk1uQzBNeG5wM3U0ZTY2N2ZI?=
 =?utf-8?B?cU1jQktKWGR2a0hOa3JITVAwYXdEQ1lVUitMcEF6aTdWMjZZQVJQV0NHM1FR?=
 =?utf-8?B?Z1ErUkd2SDIwY29KbE1DaGQ2U1ZUNlczYXJvYS92aUJiUXhyNlA3dlpZV3Fp?=
 =?utf-8?B?RXl5cWtVTWhQdVRWaEU4OEpMZW94VXpVVEtOK2pEaHJhYmZsZ284MGhHK0xt?=
 =?utf-8?B?QTVxa1h3YS8rREszbFAwR0JCbVBKNWVtSzZHRHlWYjY4bzcyaDFzaWtUVUQv?=
 =?utf-8?B?dlEwM1IxREFiTzZoSG1Hdm1JaU9MYUF0Vm1BMTUzS3IrS29oMVlpeGc2K2Ja?=
 =?utf-8?B?bnlEY2lrQXo4dm5XUUc3V2t1bThBVTl6VHRBd1Z2UE9CaHpJRFo1enY3Y0hM?=
 =?utf-8?B?N0g1MElMOGtWK29pam05UWp5WXUvRTdEbHRxYmpxeDZ5UTFYSlU5elIxeXk1?=
 =?utf-8?Q?oXxOEXEo7ozD/X/U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84AF15DCA32AAB419BFA3BA365F74053@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: UQyslUYR+qDk5DM+4nJ3MdDh99sCPusXYU6WPaDeZD+D2OTIJuku4iTIYtXoqb10AMuPgCE0XmwzkxEj6+ws4t6nKh2D1S457xabGJbklKX6h4MCWud/wzgL+4sFf8lnOhmlrQ3KI+iJr4YFVgtUNnHNerKMMVKn5Zvw251IAQCvfZod+dMlUpzhJGCSwNI6e3LxxvaVAxaLhOYVc2k+UQ2aZD/IPIMW9BkbUoXU+W//vtF69QNgstZKPhg9waLOxSOHnSb7Kq7HSpZE8f7/APNRNsozuXX0gA4NhNkdQMbLOlM9Ohnc2jG43nKTY6ldQxd5mC/LviYrSpv8cKStQw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95867968-45bc-4b35-b7e8-08de9a97f4a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2026 02:37:36.8074
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BxrehXklbnTICTgOJCB199KojQFu1kKjDZaAypg5rpICynrQvWugIoklLxlOUpX2U6J/WN9sS8URcQSW4+XJuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE2PPFDCEB9F38F
X-MTK: N

T24gVHVlLCAyMDI2LTA0LTE0IGF0IDE4OjUwICswODAwLCBXYW5nIFNodWFpd2VpIHdyb3RlDQo+
IA0KPiBIaSBQZXRlciwNCj4gDQo+IEl0J3Mgbm90IGFib3V0IHNldHRpbmcgYSB3cm9uZyBoYmEt
PmRldl9yZWZfY2xrX2ZyZXEgdmFsdWUuIFJhdGhlciwNCj4gaXQncw0KPiB0aGF0IHRoZSBVRlMg
ZGV2aWNlJ3MgZGVmYXVsdCBiUmVmQ2xrRnJlcSB2YWx1ZSAod2hpY2ggbWF5IGRpZmZlcg0KPiBh
Y3Jvc3MNCj4gZGlmZmVyZW50IG1hbnVmYWN0dXJlcnMpIGlzIGRpZmZlcmVudCBmcm9tIHRoZSBh
Y3R1YWwgcmVmX2Nsaw0KPiBmcmVxdWVuY3kNCj4gYmVpbmcgdXNlZC4NCj4gDQo+IEFkZGl0aW9u
YWxseSwgSSBuZWVkIHRvIHN1cHBvcnQgYm90aCBIUy1MU1MgYW5kIExTLUxTUyBtb2RlcywNCj4g
aGJhLT5kZXZfcmVmX2Nsa19mcmVxIG5lZWRzIHRvIGJlIHNldCB0byB0aGUgYWN0dWFsIHJlZl9j
bGsgZnJlcXVlbmN5DQo+IGFuZA0KPiBjYW5ub3Qgc2ltcGx5IGlnbm9yZSB0aGUgaGJhLT5kZXZf
cmVmX2Nsa19mcmVxIHNldHRpbmcuDQo+IA0KPiBUaGFua3MsDQo+IFdhbmcgU2h1YWl3ZWkNCj4g
DQoNCkhpIFNodWFpd2VpLA0KDQpUaGFuayB5b3UgZm9yIHlvdXIgZGV0YWlsZWQgZXhwbGFuYXRp
b24uDQoNCkJlc3QgcmVnYXJkcywgIA0KUGV0ZXINCg==
