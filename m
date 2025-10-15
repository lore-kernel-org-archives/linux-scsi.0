Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AE0302CC8
	for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2025 05:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760507912; cv=fail; b=h+nU352DtimUo03yOmz4WMh2TwME78S648uHShWKFlDCnyzkmzPFafYNMA+d35JrggF4Sesk7gQSIIBKNtAwSVmdUwE/p4DI0D/rcVCWK+DwOvPKcRHs8SynHc9pjz4jLQHves2cqxjoYtwgugOfFpQGz8edZATXWirbjNL/PrQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760507912; c=relaxed/simple;
	bh=6gpc9vNinlNewajFkJGXkiwknfsdeUHUdC+HZSfeXEk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pe+wMU/CAXxGiyRvadft1AW+KTH5WSYdk5Y+JQmAO97IUdDIXJ7galXclDlh2vikL8Ae03aAXSfipj5H5Zyaxc5RdJybZzOgz+Yfx/9vtCeZNPq/Yl758DZTvfWFGVVPA+QVmiVNcI7wbZkW5bB5+Glsz7D6Ngi4H92J1irhfcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=jOeYNW1X; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Ize9Utb8; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jOeYNW1X";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Ize9Utb8"
X-UUID: f6e4d00ea98b11f0b33aeb1e7f16c2b6-20251015
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=6gpc9vNinlNewajFkJGXkiwknfsdeUHUdC+HZSfeXEk=;
	b=jOeYNW1XPaOMS1ZIyZtdVxRSuI7aGLQvRfVAN5xRolKqMBQ1F2zC7pnA7EyY0KrFCmf9YLudSZqarTgIthEMzXq5esC2YFJeA41PKj6cXaC2OEnBuRNkHOPrv4gffx1KNup1DdZKBaO+SzU0MHxh1YUdw8B4AGBcP1gJi481Ux8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:3c76b886-0a6a-4a34-88ab-1bcc5f27e64f,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:e20f1351-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f6e4d00ea98b11f0b33aeb1e7f16c2b6-20251015
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1137722309; Wed, 15 Oct 2025 13:58:25 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 15 Oct 2025 13:58:23 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 15 Oct 2025 13:58:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=STdaiD/NZEbdGJGpNMtLTJasaNATuKNBHg2SmLkoWBAdLkS1q0QBlp8vBBkVnUsmd65umhB+UTYuau6Dkv5OjkejEjYA1nCU0ccMJFEw/73DUj4IEgv236wJ0DQqRtDIg/+vnWVdu5R48wRe9OvoruK1mufXpsfUm+nm7PPzZlb5Lm1eXDt6pcMkWUPT60ZlvYRehV4/KKy6tSZrqnfrvUB37bW/Z6haVjM+8wFdLbU6ZWJVDisYnCtTiiRRO/aq3THvdzFLj9Olf8uTeEq3zyAJNkAoEVYi+wOia/HKa0/gS3Fx9E3JbZ8MNFimIOiGjMbPKrQzzbEeCCee/hoQsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6gpc9vNinlNewajFkJGXkiwknfsdeUHUdC+HZSfeXEk=;
 b=IX/rJwlZlEq/eALQWKdMCOEozAKq7lX2pkhQqaNoIyLunl2SaSxP0IGh7SGxNfMoixlRASBhLhr4QD5dC8CDYl++by9Pii2C0aLNp/v5jGZIIXjpjbB9vETGO41s+Ljdj+AImXW6EYppb8p85WEd2JuK0rz9p+je4/ES9J53wAD76607TqT8/YgW1Aez5IiYZVLL4H7VLaCUaLwqdC2MSv1bywnu2ht+vAdMK5465Zbvv2N4MKG6M4y+VqMrx9+Glay4b19rHII1DdQNSvikd3Z9Srw4NyX7yeKWY/BF2O7tl/4eeJtB8b4ZOYx4Slo3d1p/iyA0gN3bHnutITDNRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6gpc9vNinlNewajFkJGXkiwknfsdeUHUdC+HZSfeXEk=;
 b=Ize9Utb8O3WwwLWnGC5yJL3MICLmo3YVQDn9qf8tcjn3irdnGPKegjz0Ofifn2CZIC0kPPeuqiCjFP9kSUgFugQAJIfuz5JIm8FIKxVErW1ElG0HgW0sBKIe5sPZ0/Xc8CErZ5be2OHrjv6/pInoV5447QKhgMTgAUXLRYP8v8Y=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB8114.apcprd03.prod.outlook.com (2603:1096:990:3a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.11; Wed, 15 Oct
 2025 05:58:20 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9203.007; Wed, 15 Oct 2025
 05:58:20 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
Subject: Re: [PATCH v1 1/2] ufs: core: update CQ Entry to UFS 4.1 format
Thread-Topic: [PATCH v1 1/2] ufs: core: update CQ Entry to UFS 4.1 format
Thread-Index: AQHcPQ0B9BnX/WnSKUmyEQfYZed7rbTByK4AgADuoAA=
Date: Wed, 15 Oct 2025 05:58:20 +0000
Message-ID: <c28a8d71126141a7659e8757951153c7b10680bf.camel@mediatek.com>
References: <20251014131758.270324-1-peter.wang@mediatek.com>
	 <20251014131758.270324-2-peter.wang@mediatek.com>
	 <ef1ede40-3ff9-4ff3-9752-1037a55cc516@acm.org>
In-Reply-To: <ef1ede40-3ff9-4ff3-9752-1037a55cc516@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB8114:EE_
x-ms-office365-filtering-correlation-id: 15dbe13b-5e31-42cd-c745-08de0bafd7f0
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?R2ZaNFFIYlBqZmMzNkNQMENIQWY2SUczalJmRmNhcGFGN3hBTGlJUFUzWHUy?=
 =?utf-8?B?TVU5cmlWZmw5cXJWQkUwQ3IrZ1JzUjg5WTNXeEo4c1pkbUtIc1BLRUdJek1k?=
 =?utf-8?B?ZkhBRTZ5aFRIWG5xNHRtT2xodElvcVFyTlZvTkt2dndBazBnTk56OGI0MDZR?=
 =?utf-8?B?V29velY1QkFubktPcDB1ZzZtVVgyVlpYOXBNc3R4K1FyK0hsYmg2RjV5dmc1?=
 =?utf-8?B?L0dnNGZBbDF6ckE0ZXNiTEtabmJkaUN1djl1cmNhUkE2aFRNbXRqdHZYYUQr?=
 =?utf-8?B?ZmZMdkNQOW5LaVBjdlRhc3RJT3N1bnlHdWNXS0V1ZlFQTjFjQ0FrMDV5OS9w?=
 =?utf-8?B?bTJ6dFptK3hVQkZxZkVYL0Z1VVNNWU1qczg0enZITHpxSU9sZFdvL3N1MWlr?=
 =?utf-8?B?cUl6alZ1eHA0eTMxRzZPSWU2bmNGWTZNUzFVenpwQmFVczFXT0VpeGxPTFVo?=
 =?utf-8?B?OVplZVMzY2lCSm9HNGxpMjQwK2EveFhTQnFsYi81K3FEdE8xN1dIUzFqUkNx?=
 =?utf-8?B?K2p6SGN2dDdJYlh5ejdEa1hJa0N6ZytZYmZCaGZaQSszZmZlYkNLMTZmRGIr?=
 =?utf-8?B?UUVUTlRFaUE0aU55bmNBTHF3aHpLczA2VFBnZkxqZE8vSDF6d24zU08rbk43?=
 =?utf-8?B?UU44ZGc1TXpRMy9vMnVmRm5WckVPelQvZG1PbnQrckhkTUhHY2RjekY3TTZz?=
 =?utf-8?B?Z2RURmZDUkpxV2FtejN3c3Vuc0hFY1RMQzBzNjloaWdyMVI4clVjVjE0Zk9k?=
 =?utf-8?B?M2I3WERvV3I4QmxkaVFQQ1RjS0JBS2hIaWxLQ2FZNk5oa1NUeDJwNkFsT0NZ?=
 =?utf-8?B?a29qMkJDbkRGVGVUQXk5SG9YcmEwSk5hbSsrZEhkTEh2WnJPRXVnd29pdkxC?=
 =?utf-8?B?RDdGSkMyYmMyMW9QNVdZUjFLYjF1MG85SlUzWUtVUE5NZlQ2MFVBbWJDelFp?=
 =?utf-8?B?VXE3Y3FrRnE0K3NudlpLS0NZeVRJVUk5d3JHMmExSnBNVjFBNk5WMGdkRnV5?=
 =?utf-8?B?SWFWazNXTy9VVlRkd1MySDVuMFEzNjFiT1BnWjhmRGZ6dTlTVkUvVWNkeTd3?=
 =?utf-8?B?OUdQOW93UGJVZEtpeEFWNHpEWm1QMnd3OTlUZVdNaUJyVmZTTHV0azRFNW10?=
 =?utf-8?B?Tzd0YlQzRjJLVktuUUpQYitVQ3RMeUIrM0NRZC9QcTlETVlMTjZtNERLcEVC?=
 =?utf-8?B?Wm8xUks0Q3dVU2dvMWhFbjRYbmRwc2tXbFFkNmNkZm5UdDNVN1NVQ2UzL0t0?=
 =?utf-8?B?WFlSZ0RRMkdPYVp2RFlXSWlSaHdrSGFwMXQzNjV6TWJsNTd3aUNYU1grTVBP?=
 =?utf-8?B?Q2YyeFJNendaRjN0b1lBR3Z4Q2RJSjdHaVBUK2JobFNNWldtZlArcGlIU0dt?=
 =?utf-8?B?eDIyODl1aWlSaVloa2p4a3lMbjJ0Y3p6Q2lMeG5jcGlUZ01lZHBWdVlacThM?=
 =?utf-8?B?Q0FVTmRxV1NnUk5Hc2dqWS9WcnJmaklGS3grQ2FpY0tWMGM3ZkFtS003R1p0?=
 =?utf-8?B?Sk5FNVJFaWxxQTFQTVpaR0tacWdMT3lvbzIzSUJlQ1NFcEF4N2tBSktOcEdi?=
 =?utf-8?B?Z1EyVENxL3FFMStwYVlzc09UemtzdzU1Vi9UckwrMUR6Y2NvRlQrTWxjOFZs?=
 =?utf-8?B?UkZ3cVJ6Zm04c2NzSVNHWVhyK2lkOWRYc3cyMndOUnBxTFoyb1lvYklBMS9k?=
 =?utf-8?B?YTdOTDhUVHhsa2hsWFA2TjlobVJCQVpqN1lNUSt4Tk1oUmdBUmtmM2owY21G?=
 =?utf-8?B?UktJL1doN1NwSTBLMlVVb013c2pxNU53T0hhOXA0a3AzYkZucHkwRzNLOTg0?=
 =?utf-8?B?N1Bwb3BiaU1FdTZ6aVI3WFM5N1ZQL2NKQzZ1emsrM1ZEMTJTM1I4eGE4b1N3?=
 =?utf-8?B?T3dNYURMZ3BIRXVTSG1HL3V5Mm1SdW5xV3B6MWYwTDkwRXEzOGVidERGVU02?=
 =?utf-8?B?M3BSN2tBQW5GaUlHN0huVDFEV1ZtTUZTcVVOb1c0emhnZHdpeU52K3ordkUz?=
 =?utf-8?B?MlNiVDJ0Mkt4c1RxS1FrQTNzMUZ1Ym93ZmI2cDhFcUtHWGQrQWQxZHRqbTJp?=
 =?utf-8?Q?tK8v0Z?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGM1T05OK21JUHFwblY2LzVMTWI0Uk5nOE1icHlaeWJVbHpaSWR3eXFQVklw?=
 =?utf-8?B?OHZkYWtob085bWcvOXM1SEE2cTQ4emxRSFEvWDc0V3prenZud1d1N3ZWbGRL?=
 =?utf-8?B?Z1VmSE54dWloVXJhZVNJMitaRjJyMWhKUDNDS2JEWUVFb21DZ3NkVTVBNUV5?=
 =?utf-8?B?UW9OZjhzV3dtNnRkOVV0Wm5hZnhnNnlGcTZtK1F2c3M3QTFXaFp5QjN3eWJE?=
 =?utf-8?B?VU96SXhDa1dCR3l6S3RXbzlGUUVPU2RYOElabzVTRkJtc0JnN1dYM2VUOGtR?=
 =?utf-8?B?ckhoaWhEWE9kSGVIZGV3K2dyYzVqeWZLQnFOVXdCS3E0UDhWZEhtemp5UTlG?=
 =?utf-8?B?NFNUVXNOSm0zMEhlN2IyQ2pMQUZxMjJWcU9FbVpTZ1ltd1lCWFZ4VDBleXFs?=
 =?utf-8?B?Rm0xWjZaMjV6TmtTcXY3ekZoQXFENlpNdWJZTUttTE1UTDJmS0o5eXR3QUZh?=
 =?utf-8?B?bFFuS1RoeDVtYld5c3RvUWZyMXBEUDRaQ3hqTFJRMllrbHB2UGoxUEgyMFV4?=
 =?utf-8?B?NXFwUnhSdEZnWlpjVHplTDN2Um5naUY3WkM2aXdSWi9TeFk3MitSdGRrWlQv?=
 =?utf-8?B?cUV1c3hmYlhpaUltMXNEWmlobk9YZTZCNFZVcFdmWUh5RHpiTC9jTUgwd2tm?=
 =?utf-8?B?ZUZPV3pqTWVXbnE0UmdtejQxTlE2ZjQ4Nmd4RXM4Zk1abUZMTlNRVVpUa3JE?=
 =?utf-8?B?a210aVcvV3lCR1UvQ1l5TFhiQzFJQVcxbEoySWhpV3I1a1BGR3ZFbFJDWjN2?=
 =?utf-8?B?MXVBOTNHamIyQ3hUTDdzWVN6MHR0eStpajZSZGViR0NQRUIwMHdGcGIxMGI4?=
 =?utf-8?B?WGpDb20vaEdWeDJ0MW1rRll0U2Exa0dIRHRrblJLdG43bXVQdStJa0hMOGFo?=
 =?utf-8?B?T0d1Wm1iS1R1NnFoZWJiMEppMVloU0YvRnBkSUdERlk3R2lCZENicDk2U2JV?=
 =?utf-8?B?MUhSTFFQdHk2d29mSHJzMzhsZS9mWWQxYzVsN0dTWEFGYW5VV0c1b0tVbGRP?=
 =?utf-8?B?MG5FV052bE54ZktvQXhqakNhTlc2U1NsNThqVkRMSkZCWUdSQVJiSExjT3dY?=
 =?utf-8?B?V2hOaEdlZ0xwMFhuUThDc0QvNTlvYXM2SzR2WmNNNWI2QllzT2dWTzVpT05m?=
 =?utf-8?B?UlpydGJIbXlWUVlkKzBHVERmUFZxandwNmZnbFVXS2tHYUxGb2RFT0JXMTBu?=
 =?utf-8?B?dmNkK2xHNk5FVHFRaksyK2x4aFFzSndrMUlCb1RYTHRTS3c2UG8zcWM0bW5Q?=
 =?utf-8?B?NWwrVyt4Tyt6b3hDZVlxU3FFbW1WZDR2VEJwWHg4aENmbGMrVmlEcFplenE2?=
 =?utf-8?B?Q05sbzMrbXhjR3VFb3FVRDRSdXVUOXZBdEI0WEVCMVJjSkcvSGhZZjY2MUFW?=
 =?utf-8?B?d2RRTE1EMHF5RFlSVHhUNGdXamN2QXgzY0pJaFJaYU5PRjd2cDJVY1JBZGxj?=
 =?utf-8?B?VEZPT2ZCeTJVYlJYckhBQmplMWJ1NlZTTFMxaE9md0VDbDVOdzJKTjdRTW9x?=
 =?utf-8?B?R013bEI1dzRTSEt5dkl4eExSeE9VeEdMUi9hTHRSRllDMGlKc1VTNmpFRGE5?=
 =?utf-8?B?dksxWUxRd1lCRWxoYS9xdjRlQ0VwMzRtcmNTY2ZnSTgzTzlTV1hMNUtnVE9t?=
 =?utf-8?B?VVMzcTlSWEVhQkVXalJrRlJ1b05JWlRLUFJITkM3cWtrTm5aSDhSakxibmlM?=
 =?utf-8?B?YlFPOE1Sc2Mzem1aUTkzb0c4Rnh2cklSYUJsZEpWTTJhNldzcE5uU3pRUllp?=
 =?utf-8?B?ZFVHYkN3YUlEUWtJbXZEMVNvTkRnek9pUnVNU0JQc0hnNitPVDlXYVVTU1ll?=
 =?utf-8?B?OVd5Sm9IdTVKcStxbzlMWEV5Zy83NGVEOUhFcmpDQWw3d2xaWm1sRTBHeEhV?=
 =?utf-8?B?M0lWalg4TGtvWHZhazEzUnk4ejRhUStETHFyb2dZS3EzRG5vVVpBZVZkZ2l3?=
 =?utf-8?B?VVFlSFVCUkIzQWIyV0VUZzFtZmJNN3JJUDFKUGRUOHFHNE1sWFdQNFl1ck0w?=
 =?utf-8?B?UFJobmhXSlprTVcwMExqNnNQMTR6N2FUUWRBUnd2K1RPa0RjNlpweEMrUEtR?=
 =?utf-8?B?aWpVWTRQWlR1ckpXR3ExMFNycHpYZG9VN3hwbjBTREN3clAwSCtzVFpacWxG?=
 =?utf-8?B?S3ptSXZXMDI2di9QSmhxN1VabG4vQ3N4WmdiWnhGcUZRY05Edkl4Rjd1K0Ux?=
 =?utf-8?B?d3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <31316C13CDC2A7488F5D7914866A6A3C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15dbe13b-5e31-42cd-c745-08de0bafd7f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2025 05:58:20.2992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tPUKFh0kYcQAkatRiGCzKf9AKKKnCdsovwssV83RnzfjeSz+cBzoa0d63Jpf19On8I7vp8YGP1D86nAhqp5MfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB8114

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDA4OjQ0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFRoZSBhYm92ZSBkZWZpbml0aW9uIGlzIG9ubHkgY29ycmVjdCBmb3IgbGl0dGxlIGVuZGlh
biBDUFVzLiBJZiB5b3UNCj4gcmVhbGx5IHdhbnQgdG8gdXNlIGJpdGZpZWxkcywgcGxlYXNlIHRh
a2UgYSBsb29rIGF0IHN0cnVjdA0KPiByZXF1ZXN0X2Rlc2NfaGVhZGVyIGZvciBtYWtpbmcgYml0
ZmllbGQgZGVmaW5pdGlvbnMgd29yayBmb3IgYm90aA0KPiBsaXR0bGUNCj4gYW5kIGJpZyBlbmRp
YW4gQ1BVcy4NCj4gDQo+IEJhcnQuDQoNCkhpIEJhcnQsDQoNCk9rYXksIEkgd2lsbCBhZGQgYmln
LWVuZGlhbiBzdXBwb3J0IGluIHRoZSBuZXh0IHZlcnNpb24uDQoNClRoYW5rcw0KUGV0ZXINCg==
