Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC12189
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 01:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758849967; cv=fail; b=OhlIFlflDn8gz4B1CziKkBpwMnc3LGvik5M82FWTDdZ9juklFbv89HAjGD20Wd3jdCToyIJM/WLrLAVlbgE+fXI9qwZp8j2UuD+WrHV5B9JLE7Pi7Lx5aStE0ynNFmvGvx2Nowi9YW8uQfxoui2aLAcCeo4R5cV9whQ+CkQDn/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758849967; c=relaxed/simple;
	bh=ahyrLowUCG3rWETMvOKBM297GmkZnr+VOsA35r+uyAA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kO5xutn25I5E5N4ivBgdEU3JLZi2sinTtoC76ITYeep78xrXjI0n2Syp56Fq5Rbc1NhAI6fgjLw1bmLtQbmeLBZDsu/jQJvqFxFBXD0hKXR9kaTpY9fRQEqf6eI+0lGP/pYkU1i4wQzjRihoO2DstAFBwdg7a2ZxV/U1b7HQt/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=b4rWpMk6; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=LqDX/1ZX; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="b4rWpMk6";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="LqDX/1ZX"
X-UUID: c2cbb9229a7711f08d9e1119e76e3a28-20250926
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ahyrLowUCG3rWETMvOKBM297GmkZnr+VOsA35r+uyAA=;
	b=b4rWpMk6frtKYM2xJtW3e9lLpfuvhI/sBe6gsVp2e+Zkb1tmDt0pjaRG37BcAN2aYkNHtqhAiDbBEZUMkLW7p2ywpqae+o4pwyY+vrp0o7DNtloaqlzJNCRSZpzQkYZZ3UDvB3cEJmnD3IbX2+CMe0YNWlTc/J8MmbOp55JaQwU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:a31ffcde-5cd5-4cd4-853e-11a20292affc,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:e19ef46c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c2cbb9229a7711f08d9e1119e76e3a28-20250926
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 740202068; Fri, 26 Sep 2025 09:26:00 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 26 Sep 2025 09:25:58 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 26 Sep 2025 09:25:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AozsipaT7wnQIo2MgMeNn41lBhJtb41TAFKVvSfyWMW6L9bCIlaFOgT5+vwX1xA179Yj5GKyOv2xAmyc/TayBZ3JZmnhZky3ddBoKNoqk2ZzoYOseSPkK1lP5GKnkZgbsimFLZ+NddGonq+3uIfOHQ1JcCt2xOJSu8iDHkfjBZEI/y80nE2PHlmdSR/Qw1FpftFgU6Nzj2U5lG0Be51zWEBJ8WKjJ7Tym8g3hu3zDA+KYgaCzzxw1QQcaJv2mELtba7fnSYglD8TN5siN9IQkMFynM349H0KxbSlApjI0HuQnce3xqlWX3CPhpFw+YzyiEFOCuq4pDsw28+anSo3Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahyrLowUCG3rWETMvOKBM297GmkZnr+VOsA35r+uyAA=;
 b=phZgumW9J1niuckmf8+O19KqRiIpCcyraD3OkBQ8v3hqJXqOv5EwscSypsiBDX+Tlhz5e/xBufAxOCO+/thopWz649nEngI+IkHpB1NQrWpTDdU92qE4KC0sH0LsWnORfXYsRrpIPhqfL3uOGflNCMORNGYus4UQiKyljAHeVRPQdN7HiLUARMz4CL11wXFPGCpDeRu9lUQhSdBhZjbUqW6cs96WUByxHK+hFjBCSffynl1gXXsdVRgz/3aU8et67RIe418oB1rt7N+j5w2yfqX99MhW4aGtMos0JZmKBiUvhNjxDlgTKEcdscCzwAlKNQap90s/dwTMSPG1IRE69Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahyrLowUCG3rWETMvOKBM297GmkZnr+VOsA35r+uyAA=;
 b=LqDX/1ZXpPy+cUEpzxnyVlAz0iclviCB3Lsp1xw/tnQRGDRpBFNcepU16Eijif7XXQlOMkqzV378u+V80ff6JZVUraYlYxnQVcXvFD0lBYpVDrTQkwwOlrADgWzB40X/hek9DcijVYQci8X+AM/pKXCenmRQsggMjJDntxOBYnA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB7375.apcprd03.prod.outlook.com (2603:1096:101:10d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.11; Fri, 26 Sep
 2025 01:25:56 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 01:25:56 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v2] ufs: core: Fix runtime suspend error deadlock
Thread-Topic: [PATCH v2] ufs: core: Fix runtime suspend error deadlock
Thread-Index: AQHcLgaQI3fMwvPV+EmfY5G9HqWaM7SkC7YAgAChPoA=
Date: Fri, 26 Sep 2025 01:25:56 +0000
Message-ID: <791715730bfa01ed94720c08e531d02cceaddafb.camel@mediatek.com>
References: <20250925102420.3553715-1-peter.wang@mediatek.com>
	 <81e6af29-eb75-4149-8fbc-7e726fdd2acc@acm.org>
In-Reply-To: <81e6af29-eb75-4149-8fbc-7e726fdd2acc@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB7375:EE_
x-ms-office365-filtering-correlation-id: 3412cd40-abca-4776-06fe-08ddfc9ba448
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dXRjdzMvcjdaTW5uVU5oSS8yMWRTZVdCSnFHL2Y5QWh3dDFrcVhrU241TkNW?=
 =?utf-8?B?ajNFL00yd3NZZ3VmWlhreFdLNnpVdUZ4eUZYZ1hNazZqd2ZMRWhrMnVSeVdB?=
 =?utf-8?B?ak5ORG1vQ1VmUWg1TEhMNmVQbWJlTUQ1QnI0cTBmZUtiY2oxd2lDdFdNZWkv?=
 =?utf-8?B?S2JFVmZVZ0UzQVk1THV1TFdaWmErd3B2czNRU3piTXRyYzNubmNVWms5SEUx?=
 =?utf-8?B?QTRXMzdlQko5WDNuRnNyWFVyS1dVY3lzc1E2T0dtaXFZQURNMVkzd0JEVHRa?=
 =?utf-8?B?ZmJCWUxEL2xOOW1ad0F2RUtjUzBNSndaT2p5Um41YU9RZnR0YVYwdHpWeE95?=
 =?utf-8?B?dmVBSTFEeVJCUktTckZYb0s3SGJ1VGg4aWU0QzlaR2JvcndkcWJkWkRGenRp?=
 =?utf-8?B?YzkwZVl3ZGFVc09UY2VoTkpkUWl5WEluZmhIQnlZUnpVMWhuMlhDUFE1dkRl?=
 =?utf-8?B?aVVtNDB5SzdoK2ROeUU0QVBTbjl4enZ3ZmNLMDVkd0FCQ2JLQVJJUVFRbzN3?=
 =?utf-8?B?U3BPaFVib0krK2pYNGd5dHdVcHdheElaMmRJSjJGVmtLdUdURWE1NzFrWi96?=
 =?utf-8?B?dmRXT1pmcUpaQlRLc2lObnB0emIvSU9ISG9CQTA4WHkveEwrS1hnMUJFT0tw?=
 =?utf-8?B?NTNqV0EyRERxOHVLbXRBeVJaRFJPRUd2Z256TVg5KzV4Q29FYjJvcE5rQ1pK?=
 =?utf-8?B?d1RKcHZqTzNhUUJZd0sxNU8wcWdUT1QrUkFSeThSWm1KODBFbHR0Z0hoWTZm?=
 =?utf-8?B?TXNzV0NVY3BYL2dLd3I0UllsYjZMcGVCUkJYaGNObFJhMXd1SW5vdHJLUGIv?=
 =?utf-8?B?WW9ZSFY1M1pvRDh5YWJDZnJrcStPTkhJZ3hBaU9jamJVeVlyQnpKRURFVHdi?=
 =?utf-8?B?YzlMRFR0aENCdDRnNFErU1pwMkNCNFM1cnRUZjUybE9kUWtwa2htWDZCaHAw?=
 =?utf-8?B?RnREZ3JVOVlDcGNGZ0xndlR3eUYzRzVJRndjbm9ZTXp2WmFSdkk5c2lwMGZn?=
 =?utf-8?B?VEZ6VlV5Q2pCNFNwNDBxM2J3N1VrbWtoNk02elFjbElvNUIySlE2YUxOWEIw?=
 =?utf-8?B?R09LbmlnM0lxVTB1ZjFLU3kvSnpVVXRNTXloM3V3L1hLWkNaMEpPRktuT0FU?=
 =?utf-8?B?UkkxdVJkRlVsZ3NQSGNiTDBLTEdoZVdzTGlMVzhpQXNXZmlYRCtMcHJvaVlk?=
 =?utf-8?B?UVdMMEdnVTdiZmZKWkRGMTNJUFhKeEozaUNMQ1NZUzk4NENOTXE0MC9EU3FJ?=
 =?utf-8?B?VC9taE9US0M5KzlobW9FMDU4c2dtdXVBQXNwOU4vSVliK1pqd3lhQTNzSXVO?=
 =?utf-8?B?QURoSmJCUXhmTnpNNzFBVEZwVElaVCtYU1gxelVCb1psK2JtQlVEK2NFN3hD?=
 =?utf-8?B?SmRsaXdJaUtUN0xtWHhOQlFBL24yUVhUQjNjd0Z2RzVFcHBYMktrb3RRNXNO?=
 =?utf-8?B?amFrV3dNT0hLTlI3N1VpRDlQU3ljanRTK2l5OURxNVcrRUVuVHJrM1JYS1pN?=
 =?utf-8?B?QzlFc2ZSaDc2Z0dHc1VmRlZrL08xZkZQZkg0K0lXOUJoVk9TZUhJZFphSkJB?=
 =?utf-8?B?YzZ3MTlnNk1wQW01QlN3OVJqT3JiVDhhT1dlSTJINTJ0QVllaHlUNGlJVXMv?=
 =?utf-8?B?R3R0WlFHVDAzUlFqU2dpcGtHKzA4UjhzS05CU093azBZMnFLYTNBNHNDZ3pm?=
 =?utf-8?B?dHdUdlBNbjZrbkdpMS9aT2pKUloyQ3R1Uy93TVdta1AyZW92ZmpreVdrVE1C?=
 =?utf-8?B?Rjl4Z2MvNFJMTHlJSEFYTUNYREVJSis4c29MMXpzY0lUeFM2WTlWTTRQbklQ?=
 =?utf-8?B?NzRxVWdVUTJ5eVRzd1dmcjVaMFpVWk0wMTd1TXd4MWI4dExjTTJnaG5uR3k4?=
 =?utf-8?B?M0VoSks5MHJyVTlvT0N1dzJ3Mk9JZ0haaElJc00vYVNBR3hpajdNOWZQWURC?=
 =?utf-8?B?dVRMY1RZc3VXM3U2aU8xQzVUc2R3NktLR3R1bTMwMXZibmtQUmV2c2RBYi9h?=
 =?utf-8?B?WkdLYjl0S1ZsMXdGM1crZ2xaOVl2NzFlNThEY09GTFhTV25yRDdSbGY3dnA0?=
 =?utf-8?Q?DZx5da?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2l4VitSZVRIcTB0dVVZWTZ6a0wxUHlWbEpmWUhFdldFdFV4aUltUmlyZFBQ?=
 =?utf-8?B?VGNLZVM0UW5oM21FYll6SVI0STQwVm1Od2JnclNZM2NuN3pZZWszVmZMdkVV?=
 =?utf-8?B?N2twaVZMeFJtOEZwV1IzZlJ1UmFnZFE2NGxoOWxzRFNWY01LT2lUeWFTcWo4?=
 =?utf-8?B?b3ZVem5weHpLOURzMFJ4UHhMSEFaUldTOGVmYjZQdGx2OFUrQXlqT01keXhB?=
 =?utf-8?B?YmRxWFEydzNOMlRGbUVLYXRRQVJvR1dQTTBIK1AvTUFrMFZZNjBCN0Y2dnc3?=
 =?utf-8?B?SHdkZnFyek94aEFLY0ZTVXVZNnFKNHM5VmVLbXZkcXpkWGhEem5sbzhaajNa?=
 =?utf-8?B?VllPbGFMc1B2dTNSZzZHQjE2elB4Nm1ld2I2MGNFWkN0eXZLR01wVEt4c1k1?=
 =?utf-8?B?WDErS3J4T1NHZ0wwTzBRY0xsNDdxcDhZQ0NiQ1E3OVJyVWUwZU5meEZoZDYw?=
 =?utf-8?B?Yi9XZ2I3THdpYWRqOGptU0IrNnVNSkJLT0kyZS9KM3FXUFZUMmpIcVFjU01P?=
 =?utf-8?B?VkRtcFFDZnkyUTgvcHdteUc3Wnk5a1NPeDEweVh5Z0U4ZzRFUU85Nm5GOGgx?=
 =?utf-8?B?dFNxQkpUUHN2WVY4WDVWZnpiRzBkY3RXUTg2T25PWlZuLzNRa3A3THU5ZGRu?=
 =?utf-8?B?RVhJR3BKcHhSSTN3eW5IWGFJZTJlRURmMFp4bFo5a3pHalY4b2xiYmp3clNP?=
 =?utf-8?B?OWFSbndFRENpL1JzTU1mM2JHUHdNelRHTlg0Y0xmbGpQSmtXeDVqOU9nZmdk?=
 =?utf-8?B?RDI4MDdNbVhLN3BNQlRjK1JPVGVyTkFIMjcvYnM1SzJOQVJybXN6QnV6aFBs?=
 =?utf-8?B?THdKVklKNU95aUZZUHdxNnB5Mm1xTGVIMmFQc1BjejFEYUdlZWhKTGgvN3NU?=
 =?utf-8?B?YkxpbjJIZ1BUcy9YOHRFSFg0OTVzbVl5MExOME4yaTJaa2dJRElXNDYrcnR0?=
 =?utf-8?B?OEdCRGdDUXZnQ3RmbmtRdjdtbVpxUXhlV05hY0UrQmtYb3FRbVZZL3l0ZjlF?=
 =?utf-8?B?RTBUVENaR2lJdGtnK0pvTUNxZG5teFVpeWEvQVVBWDJSNXR1QWo5T2VSa0R6?=
 =?utf-8?B?L2RuVVdpYXJwQTVGdC9YT0dqc0kwZ1NkUk0rNlRJMzRIZXVyem9YNmdPZlVy?=
 =?utf-8?B?RUd0bUY2RDhIcE5rWmEvWjVoQjJyZXFCV1ZEQ1JqSWJuYXZGSktNMDVqT0lH?=
 =?utf-8?B?OENaVThtc2JwSXAvT2U1NlRBVEE0VGFzRFNtN0xsb2Q5M09XZVYwL0dyWWpq?=
 =?utf-8?B?RUQxYlY3ekxCcDNiTFdWUmtSMGh6Tlk2d28vc211RTdkYnRGYWxnMTBxYmp2?=
 =?utf-8?B?M2g0R0dXb2lxSTdtYnpXU2ZWdnBaOFk1ZHdkUU5yZTFOSkdoQVRmL2VzQVZs?=
 =?utf-8?B?a0owRlliODRUczkwS2MreEdKbmt0VGMxVlMzUjV6bzAxQjNIUVl6NG9BTTlo?=
 =?utf-8?B?VkZMMmRncmhYNFdTaFk5S0tZTWtrTjBXKzAxL1ZBaGdGUEJKdjRmbFYrQlA0?=
 =?utf-8?B?M0FSQ1l3MTcwQzJnMWRjS2J4dXUyd1FidnJNME9YNGNKUDJ1azVvM0RFVkdN?=
 =?utf-8?B?NFdpUWpUZ3FtSnovS05mN2trU3FZZ25Db1RXSnhUa3ltTjNBN21NZEgzZ0F5?=
 =?utf-8?B?UlJqaTVkbjJ4U2dGbjVCbUx0NG5wREZ5MFlaZGYvTUNnMWdiUTY5c2hXNXFq?=
 =?utf-8?B?SGg0V3ozV290STM3cFNwSm1pVmYzd015UjhuRGMvMnR1NlZJejB3c2d4SU9q?=
 =?utf-8?B?YzhleEpJV2grbytHdHhubForaitocUY4TUtVdTBPTmVBcmozOGp3TzQzOXBC?=
 =?utf-8?B?c250cU9SMnBMN3hpUnBoYXJ1MVZTQTBJODNHUU1objVFek12ejRzLzZhdHhw?=
 =?utf-8?B?QnZ2dkl4dy92OVlKNDUvSnFHcWM3MUpaYWdsNlNOYWJxVXRMalYrdnoxL0gr?=
 =?utf-8?B?ZG83R09iK1VSRkl4TnRrRUhYazNpY29FejRJR3N6cWdVT2trM08vOFN4VFc2?=
 =?utf-8?B?dDdSbitQUkNYb1kzZW1tWUFrQXBlNXYwRFlTOGNpb1pSandRSDdaYnRrN3RU?=
 =?utf-8?B?d21QemN3UE1FNithdVF2RXFmNHcwTEVLTXgzcGdlRnhTdFhQaHpTM3N3QkpV?=
 =?utf-8?B?UzRsNUlZcStkd0dpc3JYTm12RTMyOXRSR1d2b3B3eFd2TXUvTkJlb05jZk5y?=
 =?utf-8?B?dnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A355CA8EB3292E4EA20967720211B8B1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3412cd40-abca-4776-06fe-08ddfc9ba448
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 01:25:56.2669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YfexCHmaVRS4V8LQ2e/aMm9GfGFj1FKYrDyqnR3uU2eiwCkAF+YxZNQKvcNoryrND3uDVSzZYu7xtd9/QHAG+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB7375

T24gVGh1LCAyMDI1LTA5LTI1IGF0IDA4OjQ4IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDkvMjUvMjUgMzoyMiBBTSwgcGV0ZXIud2FuZ0BtZWRp
YXRlay5jb23CoHdyb3RlOg0KPiA+IFRlc3RlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNz
Y2hlQGFjbS5vcmc+DQo+IA0KPiBEaWQgSSBldmVyIGNsYWltIHRoYXQgSSB0ZXN0ZWQgdGhpcyBw
YXRjaD8gSSB0aGluayB0aGUgVGVzdGVkLWJ5IHRhZw0KPiBzaG91bGQgYmUgcmVtb3ZlZC4NCj4g
DQo+IEFueXdheSwgc2luY2UgdGhpcyBwYXRjaCBsb29rcyBnb29kIHRvIG1lOg0KPiANCj4gUmV2
aWV3ZWQtYnk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KDQpIaSBCYXJ0
LA0KDQpTb3JyeSwgSSBtaXNyZWFkIHByZXZpb3VzIG1haWwuDQpJIHdpbGwgY29ycmVjdCBjb21t
aXQgbWVzc2FnZSBhZ2luZy4NCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo=
