Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3513E26463B
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 08:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758269765; cv=fail; b=bLMC1QnuCkTymD1+/OIh3VtFS6CPGKe9wlNaFSnPsNm06c7/GKf4E82zsAWEIJJWyYfKEOHTPyhqo03qmBXyiM8o1EaXdABZS7d6eRhv3izQUr2gp9X3vtIVZP8xEBDL15kGSkBEfG2SdE9Ji2YoF7cKY0O5t6ab6JEEOlOFL0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758269765; c=relaxed/simple;
	bh=XvjjdFCUCUFnJiyZTr/1/9s1SIur37d46IxuTufSirg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=F/GZhNDxWdQXV2fYbqkEUCaGVqmFMhOn4et7ET6I0rJABbgnqMqxuGejQmUK2rdvgO/XMbjDmrC9ndnXPqhtVE5jURez/UvDBoFdvhwZNrDyj5Z9rT21VjAbKvJEx3hjJ0gCXDFfpl18z3caxZAqoVPJPiOEFZ6k0F4ai/uXASs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EDZNoKoc; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ikRgLh0c; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EDZNoKoc";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ikRgLh0c"
X-UUID: dd93ae8c953011f0b33aeb1e7f16c2b6-20250919
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XvjjdFCUCUFnJiyZTr/1/9s1SIur37d46IxuTufSirg=;
	b=EDZNoKocSmIYo7QY5m2fwKBSzvul+QoT/vm+m9rlD4yLNmp8hyCorPslKA4U2oECRRMusnrQVWagbwAb9C0G+WFUCCMciDadtTpI7kIfBi0jz/nu7llPMXsKI5rSCEO2CFk4pLkoAt7qalJJLfRROr4Dd6av5DYRTekGZbKjAHo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:8c089847-2c5f-4680-a3ad-1dceace4aa7f,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:cc23bb6c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dd93ae8c953011f0b33aeb1e7f16c2b6-20250919
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2056793275; Fri, 19 Sep 2025 16:15:55 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 19 Sep 2025 16:15:55 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 19 Sep 2025 16:15:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=McYwJogVB+E0JnNRkPNxmsP5ag98UOPJdMzaF8VbL/sO/uPFeQwDGN7fMdn0iZEUi3ngfdjCcCVjnAjpJvia4tJjV1N0YM1RYRTK2ZMwRHpvLgS87FX7eDVa09eFWB6iJCOl77s/kJCuGICX8c+RnYiP2XKDgquieTn+wKV9wDq5C01+mBW56U9FdpoGlg8SVWyNjvIdenS2h3x9ixe22mDIAP3hErVWacilYqRi7i9iGGDs5I+OxTfrSHoJRmf5cDUVGtHcMJnONVIbRhPnz0riKO/ed3JtvG+aK/Y9bjxshqo74TQ3LU6MAQrPzv0pJOsoeMthY6pUwHAIb5DI8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XvjjdFCUCUFnJiyZTr/1/9s1SIur37d46IxuTufSirg=;
 b=NkALQwzLeWZoR4hCz2VfuSDMVjjm8a1OVKq48qf1KYQRgsy8G36J+SSubMpZHS86oWp1FCadX1XsFhAyr19JLaF5oJadpoYg+ZA7tmtu8ohiuhOe5C7Tyik1okHVe2IhX90Izz6VFr3RBZWVabEJYxZeMGWQRbCD3dxayHwzBEYBiyXd5MBeYZQrf3e0PH1m0Qaklfw+cdDGYu5EGN+k7euVwk3awAO4YQVA2Iax/2xE+Xq1lI031TQMucEbbUIZSwTTgSWJ5SY1oebQbbg4r/H5k+CLUlu9u8NFogbN+dsRq1r7Flg5sqje5oi83FUPijJkiIVp03N3OWTxTypqgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvjjdFCUCUFnJiyZTr/1/9s1SIur37d46IxuTufSirg=;
 b=ikRgLh0cL3pMbw+cvgU783jeUX+timvZ+jMhz/MvW4+M6gq3oNIKFCVvPOhbcG1sul3NvJ6wvy8/ae/aDjizSiMGWxSQYvbmOLHeOVBLaALh9IYyonlm5RSn1KMo0gKt1vxiRvcEGAqXuEEjNk15FTR1xlfhbduegYIk64idgJE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB6440.apcprd03.prod.outlook.com (2603:1096:4:1a3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 08:15:52 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 08:15:52 +0000
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
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1 07/10] ufs: host: mediatek: Fix shutdown/suspend race
 condition
Thread-Topic: [PATCH v1 07/10] ufs: host: mediatek: Fix shutdown/suspend race
 condition
Thread-Index: AQHcKIi0fb0ij1VmZUigL+1A4NaUvrSZRfwAgADkK4A=
Date: Fri, 19 Sep 2025 08:15:52 +0000
Message-ID: <e91b0fc0894eb249b853e149f2f889668c3d2e9f.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-8-peter.wang@mediatek.com>
	 <6f4f954d-64fe-461e-9c65-6630b0409710@acm.org>
In-Reply-To: <6f4f954d-64fe-461e-9c65-6630b0409710@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB6440:EE_
x-ms-office365-filtering-correlation-id: 5d6f3901-151a-4872-053c-08ddf754bfe2
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OERUZ3Zyd3FrdTJQTzdSS1hmSkQ0ZG54OHRyZklOV01rUU9UUHFqUHZRTWRD?=
 =?utf-8?B?elZTZHl2QzBTUEZrZ29UUTJPMUoyWGpsRk5MUG45UVVNOVFKWlJaMks3RkxE?=
 =?utf-8?B?dXlFU3MrR2lLbzlZM1h5NFdiRWJrQW4zaWMvNW43Vk1VdmdFQ1UvZU84WFdt?=
 =?utf-8?B?VTJOYkdwcWtSR2IvcEJnZXN2K1BaNHNBd1o0U3V4UmZqNTdhNlozUE5qMG1p?=
 =?utf-8?B?a3F6UzU0THdKeU5jeVcycEhjZXdmdHEvUHNTSVV0WnE5TVRKamdPdGs2VUZi?=
 =?utf-8?B?S3VJU3g5TnJkUjFqMWlTTkNrcUt5Zmd4ZnhFeWVpMVFHUDhvenk2djBvRnFQ?=
 =?utf-8?B?ZUlUNFk5S1lwZnJBQmdQU2ZrOWx1eDR6RXJiMmQrelYwK1pVSHRNWHRMWFM4?=
 =?utf-8?B?OVRaeE9keXI4QmZUdCtqNFVqbjFZdDVJbTEyL3djU3pmVXZLazlyWld3a0tM?=
 =?utf-8?B?WEJqQ216c3BsQmcwZ3RMRU16aTgzdll4T1FBNDBUN1RPZE9rdjFIRGpuMERr?=
 =?utf-8?B?K1NoM2JsSlVyQ1FmeHlMNytiWmpla1dqRzd3QXhycmJGQzhKMlI4by9HajVU?=
 =?utf-8?B?RjNTMkpubUh2c0svazFHQ2dibFhaNklKeFRncGIzTFdlZFoyUWRGOWp0NXdh?=
 =?utf-8?B?akl2YnhtSnZXdEExUUEwRk43UWs4Z0dJVWlHTkZSTVg5a1B3cGhOaVNHWXRC?=
 =?utf-8?B?RWZ4ZGdHK3NMOVZDektOSFl5M3FweC8vWnM4WkZZMkRPUFZ5RENrR3JBZ3BK?=
 =?utf-8?B?VnBtaWlxRGtvK2ZURDEvMmx0K0JNYVE1MUJQRkpqUVhmbGZ5cS9KeCsxeHdN?=
 =?utf-8?B?VlRSaFBXR2ZDSS9KYnhLbXEyN2lodkJGTGVacXc2T250cUFBNS9adjduMjhC?=
 =?utf-8?B?eWZDOXU5d09rYkhVTGlRMStIdGd3RkE3em5WYTJhSjhQOWFhTDY1V1F6UHl2?=
 =?utf-8?B?N1AwNXRZSEw3azFLMko5YmYxdURJTVJLcVN4T3R3YVVwN0VlT2FacFFXZUQ3?=
 =?utf-8?B?RXIyZjhlcmdQU2VML0N0WkM3djBsVjV4RjJCNHBCVFJPZmx0Wit5Z040K1Rp?=
 =?utf-8?B?L3JYUEd1NmMyWUpnUFB0alR1d0pQSHJhL1lLdTdkSHQ2QSs3bE1rNk9sSTI0?=
 =?utf-8?B?TnlFelo5cC9kbFl6VE5UeExudGhRd2x5ZVZpbU5RZTBWcWNqZHEycFNPU1U5?=
 =?utf-8?B?ZTBDQUNOWTg2UTY0Smd1N1Flc1FLbUFXclpPN1NrZXNzYXpmWS9uQzVmMG5t?=
 =?utf-8?B?aDJWMnNGMVkxSEN4dDAwWnBQanZwUDZMaW84K2FqN0pOMUNBdGdJRDBMYlJU?=
 =?utf-8?B?NllFZll2cTFzb3lwVmxFR2FQLzVKbHA2Uk0yZVV5U3dEd1JoZk02NGI2Nnpm?=
 =?utf-8?B?VjVoRm1TSy93VldjK1E0YkNrS2lNMndJQ3ROZ0NVZFJlaFpDQ01EeG85ZC9s?=
 =?utf-8?B?UjBNSnZ2RnZQWXQxMEZvMjg2SGZHc3ZvL0hEZXVxK0hVZGNSNkZLd3E4Y2FY?=
 =?utf-8?B?Zi8xZDlVMzVSZFVPcWl1d2QzUHFHWGs1Z3NHaVNUQklDdk1UdGRyNUpmM2lH?=
 =?utf-8?B?a0xpVXNpcDZHYTg0ek5NQU5DRnRtOEIzNVhqQUsyK0dqQ1Rqb2ZuY3RLUm5P?=
 =?utf-8?B?dk8xT1luR0NzVGNiTGVvTTdSbHd6eGpUdkJ3djFXMUxVMHNBMHNNK3FxRjdZ?=
 =?utf-8?B?TGs5elZ6N1AyaDd4aTFmd3BHSS9JWVhUNXoweVhySFJtSHdvVFc1VmVrRTcr?=
 =?utf-8?B?QzN4VmZnYWFDdnZ2cC9LckN3UmZSNVJlSkhCcDdrWlR2Z0VuYVNYdk1UM1Rm?=
 =?utf-8?B?bWJJTTk4Q1lrZVhVLzh0TWY1bE5DNU9jRkN6NmdMNElmQTV4c2dlSHVLYy95?=
 =?utf-8?B?ZlNzVjRpblVWTTZkcnFEQWhQZXhzZGZOZk1VRlN6Z3FPYlZsajduZnpSTlF2?=
 =?utf-8?B?ZUFhaDNHS2dEdWpnaFI3cXhia1ZKemE2ejFkY2JKM1lydkhFcVQxWXozek12?=
 =?utf-8?B?N1BXTGJkaXVnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QlB3ak0vYnY3Z01GZyswNlladndxRzRjVkV1N3VxS3ZIQ1pnZmNmMjBHS05p?=
 =?utf-8?B?Z2VHaGc0NUZITnRFZXJ0eWJUN3ZIbW9QZDZTeFgwMWNwM2NDcFd0eTkwTmN4?=
 =?utf-8?B?dFhJYVk5NTVkUWx2NnkveDlzTlhGMnozWHZ3VHpRcUFnWnZKUmlLSEMzUW1Z?=
 =?utf-8?B?aTl3ald0M0pySHVGck1GUUhRUTZCYTVvaXBLbkdXN3FMSUtVdWhseHl6K1FP?=
 =?utf-8?B?NFRob3lITU56R0dzUmdpTXprb0VQVGNkTFovS0VqZVJ2NWd6dWpPMXRlWGwy?=
 =?utf-8?B?N25xNUhCRUw4OTJRczFZT21Fak51Q3h2bmpma3FiV1YvYUpoZU5zWU1nODJq?=
 =?utf-8?B?c2lNTTVRcUU4MVBXSFJod2FUN2VQWDdzaFlaQjVtaWo1a0hNQkp4TDJWTzZi?=
 =?utf-8?B?UHlFVGxiWXZaYU9kRFE4anlMSW11aXZjaW9NdytvRFdIaXBLRUJoK3h1ekFu?=
 =?utf-8?B?Z2RXS3U2emh3Zis3S1JYbXo0WnR4Zmxvd1pXSzN0U0hFRWt6YjhOc1FVbWpi?=
 =?utf-8?B?a01CckpaMkIyOUltWEtjbEoxVzE1SjhOaDVUNm9IMEcxOStnajBNUExIYnNE?=
 =?utf-8?B?dWRCdTUxZUs3azAwbnlHS213V0Q1MVRwTmdQRVBGcldDTERLVzFUZy82VHE1?=
 =?utf-8?B?aVJjbEpSYzVGTGZpa1FYdmlac2JrL1J4b21YYVRBQU5GNXRVNXlMSER1Sk1u?=
 =?utf-8?B?SCtMTEE3ek5oaFNtZExtcDBoYUQyMFIzd2hxTEV4UGtURXJmSTNnemppeUow?=
 =?utf-8?B?ajhQN3JYaHgzMG1KbzZZWTR1WVZaNEdiSHplVEo5MHBSQkY0ckFQSnozQ3NE?=
 =?utf-8?B?ekZZTE9KNjFOQ0lFOEMzTlFrSlRCTGM2TUNPNm5HckR0YS9CTTBHUERmSlFq?=
 =?utf-8?B?dndxNTlaS0pQeDB0M29tbUh1QWVnUktyQkdURlBuN0RjNVBtOXlZRFNDZDVB?=
 =?utf-8?B?TFZUaWxrY2ZCQmNFUGNkcXZ1a1pKSnJZci9MVzhUWnowZXMxVjNwYzU1cWgr?=
 =?utf-8?B?T3RyZkx5N3dKRFNBRUIvSFBRZC9obks5VlJhSSsvVUFnUlpqekU3cjhRVjRr?=
 =?utf-8?B?K0hCOXNHS1E2OXdtbHJwUHFLVlFxZjVsTkQ3bG9wbWNGVVQ4bGNzaVpMUGxQ?=
 =?utf-8?B?aS91YVpvcDV1MmJ1SFc1L2Zzd2NGNGJ6L2IwYW8yMlJPeE9tVmRzSGd6bW1r?=
 =?utf-8?B?Mmc4dGJGcGY4VC9XQkxIMnUwUUMxaDJ1alpETXk1MWVFT0ZkTi9mWVUrNjc3?=
 =?utf-8?B?VUtIamp4dU5xSzUxTWkvMWdFRk4yOTZXT3NOdWU3QThQU0dFQkg0S2RnWGFP?=
 =?utf-8?B?N1VHS0Rocm1YK3F1V0l0Wjd3ZjM5Zmw5a1RGTVFOMjVmWURrTWNDUWllSTJ3?=
 =?utf-8?B?VkFyRVV4RlNjeFVLbVdDbFc4UDRzS3ArRVN3WDlvQWtiUDgraHhXbHVyMWpa?=
 =?utf-8?B?Rmd4RFNucW1sdzFXWnpBY3QvaVR5aHluZWkvSHFDVXRTaDVYSHo5NzVsS1ZW?=
 =?utf-8?B?dkhkY3NhbGkvb0JIREhMMU1nemtVUFFuUldaa0dvNzNFZWlic0hzSDRhUVJy?=
 =?utf-8?B?bGxjV0R6N2hGN2dXM1VaekY0WVowRE9BUGNIbVpLTWtoR05mbVA2eFZaTXNL?=
 =?utf-8?B?d0syb3VxenBvblRETDljY2tXWTJ5emZma3FtdHNOeUxIT2hxMEs5Z1MxTzYx?=
 =?utf-8?B?UTZNNGxrbHp0NHF4V1lNdlNQbVg0dHZobC9BN0s3VnZwR1NaUEVrYkNseG1G?=
 =?utf-8?B?VzFKMk9QR0gwZVpUaFpST3dQc1hta24xSGYwd2ZvK3E3dnUvS0NDMWtpN1lY?=
 =?utf-8?B?Q1RpNGN3QWFWUkd6OTQ4YUpUc3A5MEN0c1Bhekk4dGNrMUszOHlNcDlyb0dI?=
 =?utf-8?B?RlFlTkJjMGFldFRQSno1UmJPeGZTRmQyTTVIdzBRY2UvOEpHbkRFQ3RMRXJ5?=
 =?utf-8?B?VTVkWDZ2amdlMHZ6WkwzdldjcnJOWEl0UEUxbHRKSzdtUXI5ay8wZUlvdFR3?=
 =?utf-8?B?V1czNERWUXp1MjJjRlh2c2Q2NU9VQTNLQmVFYnB6cm51Q2pPZS9uaVhObXFW?=
 =?utf-8?B?MUIwWDNiU2RHSjhua2J6SDZtMGVYMllmZGZSZHd3TFhJaGtUVUlzejFxNk51?=
 =?utf-8?B?clZZVEpHdE1rUnlsdnR3Z3ZEQWpNb0EwNXIvUGlvVWVMTTR1Uk8rR3J1VTVa?=
 =?utf-8?B?bGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3B8DC709629C441AC6DCFA2C5DC1731@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d6f3901-151a-4872-053c-08ddf754bfe2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 08:15:52.4741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8YxUq64gS/zgNiK/MqZPqWZg5SCoaLOVRyw0P7AIESyiWpQWHAkjYi7Hei6BlPOJBLF1VzYAWywSyzcJoUEUPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6440

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDExOjM5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDkvMTgvMjUgMzozNiBBTSwgcGV0ZXIud2FuZ0BtZWRpYXRlay5jb23CoHdyb3RlOg0K
PiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL3Vmcy91ZnNoY2QuaCBiL2luY2x1ZGUvdWZzL3Vmc2hj
ZC5oDQo+ID4gaW5kZXggMTA5Y2JiMzZjMDJkLi43ZGY0NzVlYmQwNmQgMTAwNjQ0DQo+ID4gLS0t
IGEvaW5jbHVkZS91ZnMvdWZzaGNkLmgNCj4gPiArKysgYi9pbmNsdWRlL3Vmcy91ZnNoY2QuaA0K
PiA+IEBAIC0xNDM2LDYgKzE0MzYsMTEgQEAgc3RhdGljIGlubGluZSBpbnQNCj4gPiB1ZnNoY2Rf
ZGlzYWJsZV9ob3N0X3R4X2xjYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiA+IMKgwqDCoMKgwqAg
cmV0dXJuIHVmc2hjZF9kbWVfc2V0KGhiYSwNCj4gPiBVSUNfQVJHX01JQihQQV9MT0NBTF9UWF9M
Q0NfRU5BQkxFKSwgMCk7DQo+ID4gwqAgfQ0KPiA+IA0KPiA+ICtzdGF0aWMgaW5saW5lIGJvb2wg
dWZzaGNkX2lzX3VzZXJfYWNjZXNzX2FsbG93ZWQoc3RydWN0IHVmc19oYmENCj4gPiAqaGJhKQ0K
PiA+ICt7DQo+ID4gK8KgwqDCoMKgIHJldHVybiAhaGJhLT5zaHV0dGluZ19kb3duOw0KPiA+ICt9
DQo+ID4gKw0KPiANCj4gUGxlYXNlIGRvIG5vdCBtb3ZlIHRoZSB1ZnNoY2RfaXNfdXNlcl9hY2Nl
c3NfYWxsb3dlZCgpIGRlZmluaXRpb24gLQ0KPiBJJ2QNCj4gbGlrZSB0byByZW1vdmUgdGhpcyBm
dW5jdGlvbi4gUGxlYXNlIGVpdGhlciB1c2UgaGJhLT5zaHV0dGluZ19kb3duDQo+IGRpcmVjdGx5
IG9yIGFkZCBhIC5zaHV0ZG93biBjYWxsYmFjayBpbiB1ZnNfbXRrX3BsdGZvcm0uDQo+IA0KPiBU
aGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpPa2F5LCBJIHdpbGwgdXNlIGhiYS0+
c2h1dHRpbmdfZG93biBkaXJlY3RseS4NCkJ5IHRoZSB3YXksIGNvdWxkIEkga25vdyB0aGUgcmVh
c29uIHdoeSB5b3Ugd2FudCB0bw0KcmVtb3ZlIHVmc2hjZF9pc191c2VyX2FjY2Vzc19hbGxvd2Vk
Pw0KDQpUaGFua3MuDQpQZXRlcg0KDQo=
