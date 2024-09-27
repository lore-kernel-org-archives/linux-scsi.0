Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CF21422D2
	for <linux-scsi@vger.kernel.org>; Fri, 27 Sep 2024 07:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727423526; cv=fail; b=TVxeQApfdiBGZZoPKz54O+AldBhtOftu+6jS+PPBiwcSMS0mj8a7jNik0gqdRtm/jiY5KK8SnDHSD1iWaN7NnGtIIAAJ1OAqzcgPZXewKXHM9eOpAFqS1e4O7ZSCrsIsr7ewwc1kl9MG/MLBTiGM/MOuwXnKo1rMMCIKp9SBMjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727423526; c=relaxed/simple;
	bh=M6bTUahCa8gK9JUq5l3GDen84wK0p7xNy5jrxJXhpmw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bRCIjRUB3fcN92aRr65goHg7aSxFz2f4Cy/+6YBQLPoQWwyymjvenKihn+zu5QNBXi8OhOEMkd18HGy6s4GD97FuLP5pqzL4uyaiW5vwM8jfrGho0CybcGx0efOWZfAMl9GFDVsMocydKwbk+bVEYiTO1QXURu8aq6bErd5Trwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=F8cX4f2s; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=YmbE9A8N; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="F8cX4f2s";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="YmbE9A8N"
X-UUID: 5f0f74b47ca511efb66947d174671e26-20240927
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=M6bTUahCa8gK9JUq5l3GDen84wK0p7xNy5jrxJXhpmw=;
	b=F8cX4f2saV1eYveUjzW7ooV/4l9D9jMrx7AD1FJDl8gS3spoevlrCYqry1OxalNsRD8wiqmo15TvF4txRL8G43NB72MpJFZy+hnyD2BrZB7aMU0CZFG2OIr+TSq+VOdar2m0X31kC9hZz5rnz7KJD+ycQV2lfp9BSY3U+V8i/W0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:28ff2ae8-f3a8-4f7f-89a3-ee2ff3303cb4,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:ce6c5818-b42d-49a6-94d2-a75fa0df01d2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 5f0f74b47ca511efb66947d174671e26-20240927
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 341514166; Fri, 27 Sep 2024 15:51:57 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 27 Sep 2024 15:51:56 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 27 Sep 2024 15:51:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uzTbCyXbNmUIX10Mt4FQzdNmOAjpZ0WtscE2ksv71Rnt+3L/etsO56InuKsspLxxOj7UYuolitgHE4MpNhkzw7DnZrdGu+/fXgESom4sE6V5jEmak00IZ/6h8W/B2ta0uGUitYd3NLqdjRd0Wi8quuOEZXywq32arCZmBgKmBSiMimhUNtx6REtqueqI1r9ibjBZWz5gIqjdtuFLBkXp9To3I4xzL1GQPGVuH4/k0eIhvvhuJ7dgLWzzjgrXU+xBJ8sP0cpIKqReyhQQsUCeTvcaAmqNdAm6G+gPL944MmFRM0MElEnoom3DKNbXErVGnk8Nw3LtgvW1F4MyrG+qIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M6bTUahCa8gK9JUq5l3GDen84wK0p7xNy5jrxJXhpmw=;
 b=Stv2GxKDB5KLshSMQYrjxHV4y0+UBOrqB8Hrt8WmhGfhNaQRdhIWETdz/brjyQyvYWQZMzM6AQPMPp5DygktJsgqMr+dKPfOWRowh4XwoDfEcsjOGoPOBK7IKvWMTFU2sPtR9IS41i0z9iQfofDh3mbqyyhpMqUpgMUmFc3kgmYVXxu9KQyrzYBgoV02Z7dBA64qCznzQ+6ZQjIEndlairswcAAqhB1FAsIae4II3p4ULb4n3teXv29z/jftDmnWuVQJnAxW3pvcUHHp3VrYYShsiubOKJlllI7btJCP7/hBDuNykiOorhWX54/kM4nBUrMIOBQ3FWhJAskc3q/7yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M6bTUahCa8gK9JUq5l3GDen84wK0p7xNy5jrxJXhpmw=;
 b=YmbE9A8N0POcq3BQ1y7QAk5DwYoyavBijzHLnqcU/tehe7e4XAEjZz9qA2wO0jZaQl4viuKRsoKID0thLKlPDU2yNPJQr++/AV84u6XF2ADt/lBvDEySKDM42ilO/Mp12hFpq9Pwd7NX/lgv+zs8bXf14aj75h6+q07Yncjwk/I=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PUZPR03MB7211.apcprd03.prod.outlook.com (2603:1096:301:11c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.22; Fri, 27 Sep
 2024 07:51:54 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8005.017; Fri, 27 Sep 2024
 07:51:53 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ abort
Thread-Topic: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ
 abort
Thread-Index: AQHbDzNnjCHDHRi190OQQBukK2Coj7Jot2cAgAC3HYCAAPZCAIAA4Q0A
Date: Fri, 27 Sep 2024 07:51:53 +0000
Message-ID: <134227055619610a781d5e46fb14e689f874b7d4.camel@mediatek.com>
References: <20240925095546.19492-1-peter.wang@mediatek.com>
	 <20240925095546.19492-3-peter.wang@mediatek.com>
	 <949fb86d-6b61-4a1a-bc04-c05bb30522b9@acm.org>
	 <4bc08986190aecb394f07997b2ad31e301567496.camel@mediatek.com>
	 <108a707e-1118-42f4-8cc9-c1bda9fab451@acm.org>
In-Reply-To: <108a707e-1118-42f4-8cc9-c1bda9fab451@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PUZPR03MB7211:EE_
x-ms-office365-filtering-correlation-id: f40154f2-c2e8-4669-8b1d-08dcdec940d8
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WUdtWTBHeUkrY1RNdkpLa0o4SllyZnJqVklMZlJycVNVSFl2NTc2ZWNpUStI?=
 =?utf-8?B?SUdjc1ZzbEJKbWJyd0FvSDd5SGUzb3ZucWh2WXd4WU01RDFlbUlqV0RaVTdv?=
 =?utf-8?B?ZDJUL3pqeGpzdXJmdktHNnFDUi82b25ENUF1bllJejVXc1pYMWl5YUJEdDQr?=
 =?utf-8?B?NUp2Qm1TaU5LcDlzWDcvakRZZ01ydEJUQ0V5YUQzZ2kzL3RiTVEvQXRoQllz?=
 =?utf-8?B?anpTQTlqS0lwbS9yL3JGYnJRTDUvaXVNM2NRV0hZSjk5THFVanlnSHlsUUt3?=
 =?utf-8?B?RGViWWxBNkt0QzU2VUE0bVVUZTNuaVBhQTl1K0RYNjVaRWg1UUVVQmorY3p1?=
 =?utf-8?B?Zlk2WlUyNCtpV2xvcExZa05oYjRwRHovOVZDK09BcmxuUDhWZDJTQ0tma0oz?=
 =?utf-8?B?SWdQRnZnOXQraUgyYXBWU1ZMS05vazljOWR4VGJmQWF0bHFKajlsQk9jdmlO?=
 =?utf-8?B?V3IwYnV0K3JJcnEvZms2eEMyOWIwaHlURGRYeEVCNWJ6N1lLSENoaDB3RzRG?=
 =?utf-8?B?UjdMa1pIT1h6REdjQVZQcXBpT0NxV29WYkk0Znl0YUdyNEVoLzFtaHc2TUFX?=
 =?utf-8?B?TlNxRFBWU0lVSUwzQ0JwZTlYQnowanh1bTMzRVpsVFk0ckZBem9wWmw2Znk3?=
 =?utf-8?B?MEIwZ2JKK1VNc0V5Q2p0QzdBZUdjZlhRbnY5VjUvM3RtTVJqTW8xcXBFR1BH?=
 =?utf-8?B?ejh3S3BQN2EzV2FPeWI4eVAyeHlkNnl3TXR5eGNqcG11cnNmVzAwZXBHRzg3?=
 =?utf-8?B?Z3l6b3BId0tPN3lVUXJuSUxiOGovY0tBMk1RM2JFNEFLblF4RjRjY1dTcGts?=
 =?utf-8?B?NFhzTFVnaW4vWFhTZ0kzcDJHczY0QTdFWEJrQStnZ256Wm9Rd25IMFNXWWZq?=
 =?utf-8?B?REg5NXFEZDYzL1huQkIyTUYxQldYdm83eTNBVVM0R2xaSktLNjdKcFJhMVAy?=
 =?utf-8?B?V2hNTHUrVnUrQ29waFVGMitkR2JEM29HZnZ1ZDEremRONWpTSGRRV0Q0ZnNq?=
 =?utf-8?B?QmlIMHFQbm5PdEZiQVc0K1VJT2pyUG9yM1l2YVFpcS9wWUZ4TEMxemFtRmJI?=
 =?utf-8?B?YzdLcEszUkVhVVdidHlXaTlKZTBwRy9uUlk0eXlWVUdHaGttYXBKOUhwUXZV?=
 =?utf-8?B?S0VjYi9QTkZZVC9COW8vS21EejRmU2xPYWVpT1RRK1Z0VzJ3S1pDcHpLSXEr?=
 =?utf-8?B?MDQ1T2ZxaDI4R0NZWVBZdFlRMFowUDFZNzR0bUNjUHNlM3lxOUdudXlSMWZ0?=
 =?utf-8?B?elRGeENUSWkyK3VhRDc1MUE1OEpvVlBweDM1ajNzMWxwMHZXOVRDUU9qSmNN?=
 =?utf-8?B?NUJwdmk2cUczWDJDTUNHTTQ2Qnc4QlRkU2ltMWVYL1FMdFVhUnNQMG9uM29N?=
 =?utf-8?B?WUl1VTBtcTJnYlVRanc0MkRhZ2FXNXExVklTbTgwQjFndFhqOFlFUVVTV1FN?=
 =?utf-8?B?TEVMREhVUzBsc1pHdTVnSU1hS01WWStWME1BQ0F1M3h5UzcvRHZieGJtSTlh?=
 =?utf-8?B?NG5kdWlRdSt0TnF6dVlUS0VWelN3YStUWEE2UFZoVFZBUE42RUN1Vmg3SmJr?=
 =?utf-8?B?clM0OUxRZFZaM3pRcENsYlliNHNxVzk3V1hpWi9UV0VGM0Z1Q3JaMjhvQXRS?=
 =?utf-8?B?aEc2c1RDU3ppZGVjNHI5VDQ5OEIwT1VUSnp6eXFPVzZTN2VSdVJNL1NPK2FN?=
 =?utf-8?B?djVIRm9VTnVlQ2Y0ZXVON3BabVVvMUxDcTdrSG1wYUpnMEdBYmpickoreldJ?=
 =?utf-8?B?REprYTFHUVM3NWM3UFozbHVqTjJnc0JXMWtya1VsRVlLYmlkZXljUFZPbTdq?=
 =?utf-8?B?a2d1RmIzcVp6YlIxdHFxUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHJLUmVaazFqOXNqcnZBb2xVMFM0c3c1Q3NldmI5U3lyTTJUTjNsOWE4S0dF?=
 =?utf-8?B?Q2pSSVhrZ1RLQlUxcWJENFRueWtzOGxiV2lmaDBXRkhWV29QZmIyQm1nVTVt?=
 =?utf-8?B?MDU3MEV3YzU0SGFFK3k3OFZHb09ORGxlNllrUGNwY1g3R3NpR2tleWZ4OFd3?=
 =?utf-8?B?Sk1YSzI3N3c4MVRiSVRwdGlQUUsrVFFXL004dFNyVW1BaC9xVGVQTmp4UkNL?=
 =?utf-8?B?YjdCcTZvenc5SUxNVUpPTXpoQXFzd0tGVG03cE9BOFUrQ3BPU1RBY3hpWGNH?=
 =?utf-8?B?WmJScW1VUWdEQjVjWkplOTVxZzAvOWdqbGNKVHNaZm45Y2thcnRaNE5Xcll6?=
 =?utf-8?B?NDRxYk1ESXR5bWxDeDJoclE0cWV2SFhqNFpRdE5lWG9SVjlSVGVWOXRob0JO?=
 =?utf-8?B?U1FINyttbzg4T1FkRHQ0eHdkcEsxeUpJRytKWWVObTNzWDEzY0pUZ1IwZEFJ?=
 =?utf-8?B?STFiT0dqNnAzV1R1SDNoNGxrVUwrMklBaWJiRXR0NDQza0xJcUQycnhmNjNZ?=
 =?utf-8?B?V1l0L2syUzN5UTIvQjhVdS9uRmxGTFV5cG5qcnlJWUtkMmw3Z3dWWkJpRk9n?=
 =?utf-8?B?b21JblIyOVd5eGFiWWpBd0JRUVBqM2VLVVo1SmFETUhmLzIwUnBtLzdIczZ0?=
 =?utf-8?B?Vld5eVNWbVpxVHdhempDMWovZFBMdnZjS1hHaDhML0pDcXZyWEhPd24xMmRX?=
 =?utf-8?B?V1NaSHZmaFB5TFI4aDV2OXlKdzVSeURmV1Z1UU5Gbm8rSkFQUjQyY25HMUlL?=
 =?utf-8?B?Szg4dVNoZ3kzZmFmVGlrVG1maE9CZmI4M3JsREVweERIU2xCREdTeHY1Z1JO?=
 =?utf-8?B?WFJIVTQyWjQ5YnA5ZmtMb3BmT2FUMmNXOUF0TzdYMDRRbEFkRk82emt0YU5J?=
 =?utf-8?B?c1hGaURyNEV1TFRiTkx3czBtbXZQRXRIUVNsRnAyWjdrc2ZjcnJYaUkvSS9C?=
 =?utf-8?B?anlqS21RZy9kRVBSOWdON0tDMjdseU4ySWFhR0RUa01mL3owYXZXMjM1bysx?=
 =?utf-8?B?R1lGNXFRMTUrbStzY0tJeXZja3VDSC9ZN2dSRnZKc1JSanRXWmhiRFM3VHNK?=
 =?utf-8?B?RU1tQ21aYzNvS2QveERKWGpmNkJwbFdGVGZZSFZ1VWVHNWxtY0Zsb2ZyZk01?=
 =?utf-8?B?MlJZcWcvT293S2FpcFQvTkhHNEpIN1dnMkx6eVFZSEhreHVRNjE2NUNVNmUr?=
 =?utf-8?B?SnlHRFNqMURmRUxnT1ZJZDZjemFpSG0yZnV1ck16U1A4ZGtMNDdnV2JUUGNk?=
 =?utf-8?B?VWhLME15WUZyQ0s3TG9MU3dXYzJVckJFVm5pSVc4V1Uxalg4NSs4bjloYlp4?=
 =?utf-8?B?SWRWUGxQRmdqT2RCNXd2K1BseHhzUVJJZlpEMVlRUHNMR24xRHFuWnl1RUY1?=
 =?utf-8?B?dDRuTHVJRDIvZnJWZ0tYYi9oZkV0M00xNVpZdzRJYkNmdzNqR09EWXRoOS8y?=
 =?utf-8?B?S210VVNFQkZaMmR4SjNuUXlSODdTQTFxMTk3SjhaUlFwR3hycGRJbnJiZ2FV?=
 =?utf-8?B?RjRHUXlYSVZUM1N5dGszNlFaUG14cmpLSTQ0VkNLMmJqLzRvY3M4enZjY3Ro?=
 =?utf-8?B?eVN2V202dVdpK3UzY2M2RDNnMWphYlRCYlN0dFNFN21tQ0tsaHA2UjhjTFFy?=
 =?utf-8?B?Ym1aZ29ITDI4bWpyTno0cWQ1WnNEdHNwNlUyU2lzdTkwNnI2aHpNSFZDU2Rz?=
 =?utf-8?B?QVFPbEpGVG1oKzN5c1BLSTRaWE9SMmEwOStEcEtOd3hLemxiUXVnM1ZpNXo5?=
 =?utf-8?B?ZVU2OGxSQndreC8zNTMyRFZ6ZmcyUWtNU1BTQXZyOXh1dlV2dWU1R1dRSTgx?=
 =?utf-8?B?R05za3pPNE4xQTFRRXNoLytxcGZhRTU1bWI0NGErUUlaQlg0YUp6LzhuSmV5?=
 =?utf-8?B?b2tvRE04bWwvZlFoZ2ltNkxIQ1NHNUtKWWdSZXVGRXR4SVZMaTRzdTRlcTMr?=
 =?utf-8?B?RHMxMHc4dllDaFN3ampkQ2x6aFZhM1RYaXdZT2NySFBLL0puUDNiK0F1eDhz?=
 =?utf-8?B?cExxUGtyMmpkWnZFMy8rcThUM1k1N2NXYm4vb1ZUWkFoL1FSQjZBRkNldktw?=
 =?utf-8?B?cGZQR3Q2YkRCTi8wTmtLRnFQOGpTK1d5cVljU1VlYStvSGVrSzB0RWNlVjJI?=
 =?utf-8?B?NytuMFB1cHZYcEZ2aFdJTFFrRThaUm9zZExySTFxQkpZSS9OQ3BYNE1iS0N1?=
 =?utf-8?B?bmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BC4C1EAFB062C41990719871F9ABCFC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f40154f2-c2e8-4669-8b1d-08dcdec940d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2024 07:51:53.7374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iNWhivahG5zmNdA9yxXtCoWfR0y/nhaOvf0y7yW/uEQLTfsfAEujxxAoj184AJQ6I6yVqvEwj8bRjdpnAy2Tww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB7211
X-MTK: N

T24gVGh1LCAyMDI0LTA5LTI2IGF0IDExOjI2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8yNS8yNCA4OjQ1IFBNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIv
ZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+IGluZGV4IDI0YTMyZTJmZDc1ZS4uMDZhYTRl
ZDFhOWU2IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiAr
KysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4gQEAgLTU0MTcsMTAgKzU0MTcsMTIg
QEAgdWZzaGNkX3RyYW5zZmVyX3JzcF9zdGF0dXMoc3RydWN0IHVmc19oYmENCj4gKmhiYSwNCj4g
PiBzdHJ1Y3QgdWZzaGNkX2xyYiAqbHJicCwNCj4gPiAgIH0NCj4gPiAgIGJyZWFrOw0KPiA+ICAg
Y2FzZSBPQ1NfQUJPUlRFRDoNCj4gPiAtcmVzdWx0IHw9IERJRF9BQk9SVCA8PCAxNjsNCj4gPiAt
YnJlYWs7DQo+ID4gICBjYXNlIE9DU19JTlZBTElEX0NPTU1BTkRfU1RBVFVTOg0KPiA+ICAgcmVz
dWx0IHw9IERJRF9SRVFVRVVFIDw8IDE2Ow0KPiA+ICtkZXZfd2FybihoYmEtPmRldiwNCj4gPiAr
Ik9DUyAlcyBmcm9tIGNvbnRyb2xsZXIgZm9yIHRhZyAlZFxuIiwNCj4gPiArKG9jcyA9PSBPQ1Nf
QUJPUlRFRD8gImFib3J0ZWQiIDoNCj4gPiAiaW52YWxpZCIpLA0KPiA+ICtscmJwLT50YXNrX3Rh
Zyk7DQo+ID4gICBicmVhazsNCj4gPiAgIGNhc2UgT0NTX0lOVkFMSURfQ01EX1RBQkxFX0FUVFI6
DQo+ID4gICBjYXNlIE9DU19JTlZBTElEX1BSRFRfQVRUUjoNCj4gPiBAQCAtNjQ2NiwyNiArNjQ2
OCwxMiBAQCBzdGF0aWMgYm9vbCB1ZnNoY2RfYWJvcnRfb25lKHN0cnVjdCByZXF1ZXN0DQo+ID4g
KnJxLCB2b2lkICpwcml2KQ0KPiA+ICAgc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2ID0gY21kLT5k
ZXZpY2U7DQo+ID4gICBzdHJ1Y3QgU2NzaV9Ib3N0ICpzaG9zdCA9IHNkZXYtPmhvc3Q7DQo+ID4g
ICBzdHJ1Y3QgdWZzX2hiYSAqaGJhID0gc2hvc3RfcHJpdihzaG9zdCk7DQo+ID4gLXN0cnVjdCB1
ZnNoY2RfbHJiICpscmJwID0gJmhiYS0+bHJiW3RhZ107DQo+ID4gLXN0cnVjdCB1ZnNfaHdfcXVl
dWUgKmh3cTsNCj4gPiAtdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPiAgIA0KPiA+ICAgKnJldCA9
IHVmc2hjZF90cnlfdG9fYWJvcnRfdGFzayhoYmEsIHRhZyk7DQo+ID4gICBkZXZfZXJyKGhiYS0+
ZGV2LCAiQWJvcnRpbmcgdGFnICVkIC8gQ0RCICUjMDJ4ICVzXG4iLCB0YWcsDQo+ID4gICBoYmEt
PmxyYlt0YWddLmNtZCA/IGhiYS0+bHJiW3RhZ10uY21kLT5jbW5kWzBdIDogLTEsDQo+ID4gICAq
cmV0ID8gImZhaWxlZCIgOiAic3VjY2VlZGVkIik7DQo+ID4gICANCj4gPiAtLyogUmVsZWFzZSBj
bWQgaW4gTUNRIG1vZGUgaWYgYWJvcnQgc3VjY2VlZHMgKi8NCj4gPiAtaWYgKGhiYS0+bWNxX2Vu
YWJsZWQgJiYgKCpyZXQgPT0gMCkpIHsNCj4gPiAtaHdxID0gdWZzaGNkX21jcV9yZXFfdG9faHdx
KGhiYSwgc2NzaV9jbWRfdG9fcnEobHJicC0NCj4gPj4gY21kKSk7DQo+ID4gLWlmICghaHdxKQ0K
PiA+IC1yZXR1cm4gMDsNCj4gPiAtc3Bpbl9sb2NrX2lycXNhdmUoJmh3cS0+Y3FfbG9jaywgZmxh
Z3MpOw0KPiA+IC1pZiAodWZzaGNkX2NtZF9pbmZsaWdodChscmJwLT5jbWQpKQ0KPiA+IC11ZnNo
Y2RfcmVsZWFzZV9zY3NpX2NtZChoYmEsIGxyYnApOw0KPiA+IC1zcGluX3VubG9ja19pcnFyZXN0
b3JlKCZod3EtPmNxX2xvY2ssIGZsYWdzKTsNCj4gPiAtfQ0KPiA+IC0NCj4gPiAgIHJldHVybiAq
cmV0ID09IDA7DQo+ID4gICB9DQo+ID4gICANCj4gPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAtLS0tDQo+ID4gDQo+
ID4gDQo+ID4gVGhpcyBwYXRjaCBoYXMgc2V2ZXJhbCBhZHZhbnRhZ2VzOg0KPiA+IA0KPiA+IDEu
IEl0IG1ha2VzIHRoZSBwYXRjaCAndWZzOiBjb3JlOiBmaXggdGhlIGlzc3VlIG9mIElDVSBmYWls
dXJlJw0KPiA+ICAgICBzZWVtIHZhbHVhYmxlLg0KPiA+IDIuIFRoZSBwYXRjaCBpcyBtb3JlIGNv
bmNpc2UuDQo+ID4gMy4gVGhlcmUgaXMgbm8gbmVlZCB0byBmZXRjaCBPQ1MgdG8gZGV0ZXJtaW5l
IE9DUzogQUJPUlRFRA0KPiA+ICAgICBvbiBldmVyeSBDUSBjb21wbGV0aW9uLCB3aGljaCBpbmNy
ZWFzZXMgSVNSIHRpbWUuDQo+ID4gNC4gVGhlIGVycl9oYW5kbGVyIGZsb3cgZm9yIFNEQiBhbmQg
TUNRIHdvdWxkIGJlIGNvbnNpc3RlbnQuDQo+ID4gNS4gVGhlcmUgaXMgbm8gbmVlZCBmb3IgdGhl
IE1lZGlhVGVrIFNEQiBxdWlyay4NCj4gPiANCj4gPiANCj4gPiBXaGF0IGRvIHlvdSB0aGluaz8i
DQo+IA0KPiBIaSBQZXRlciwNCj4gDQo+IElzIHRoZSBhYm92ZSBwYXRjaCBzdWZmaWNpZW50PyBJ
biBNQ1EgbW9kZSwgYWJvcnRpbmcgYSBjb21tYW5kDQo+IGhhcHBlbnMNCj4gYXMgZm9sbG93cyAo
c2ltcGxpZmllZCk6DQo+ICgxKSBTZW5kIHRoZSBBQk9SVCBUQVNLIFRNRi4gSWYgdGhpcyBUTUYg
c3VjY2VlZHMsIG5vIFNRRSB3aWxsIGJlDQo+ICAgICAgZ2VuZXJhdGVkLiBJZiB0aGlzIFRNRiBz
dWNjZWVkcyBpdCBtZWFucyB0aGF0IHRoZSBTQ1NJIGNvbW1hbmQNCj4gaGFzDQo+ICAgICAgcmVh
Y2hlZCB0aGUgVUZTIGRldmljZSBhbmQgaGVuY2UgaXMgbm8gbG9uZ2VyIHByZXNlbnQgaW4gYW55
DQo+ICAgICAgc3VibWlzc2lvbiBxdWV1ZSAoU1EpLg0KPiAoMikgSWYgdGhlIGNvbW1hbmQgaXMg
c3RpbGwgaW4gYSBzdWJtaXNzaW9uIHF1ZXVlLCBudWxsaWZ5IHRoZSBTUUUuDQo+IEluDQo+ICAg
ICAgdGhpcyBjYXNlIGEgQ1FFIHdpbGwgYmUgZ2VuZXJhdGVkIHdpdGggc3RhdHVzIEFCT1JURUQu
DQo+IA0KPiBJdCBzZWVtcyB0byBtZSB0aGF0IHRoZSBhYm92ZSBwYXRjaCBoYW5kbGVzICgyKSBi
dXQgbm90ICgxKT8NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCkhpIEJhcnQsDQoNClJl
Z2FyZGluZyB5b3VyIGRlc2NyaXB0aW9uIG9mICdBQk9SVCBUTUYgc3VjY2VzcycgYW5kICdTUUUn
IA0KSSB0aGluayB0aGVyZSBtaWdodCBiZSBzb21lIG1pc3VuZGVyc3RhbmRpbmcuDQoNCkluIHRo
aXMgc2VjdGlvbiBvZiB0aGUgVUZTSENJIDQuMCBzcGVjaWZpY2F0aW9uLiANCjQuNC42IChJbmZv
cm1hdGl2ZSkgUHJvY2Vzc2luZyBBYm9ydCBpbiBNQ1EgbW9kZTogQW4gSW1wbGVtZW50YXRpb24N
CkV4YW1wbGUNClRoZXJlIGFyZSB0aHJlZSBjYXNlIGZvciBNQ1EgYWJvcnQ6DQoNCjEuIFdoZW4g
dGhlIGhvc3QgY29udHJvbGxlciBoYXMgYWxyZWFkeSBzZW50IG91dCB0aGUgU1FFIA0KICAgYW5k
IHRoZSBVRlMgZGV2aWNlIGhhcyBhbHJlYWR5IHJlc3BvbmRlZCB3aXRoIHRoZSANCiAgIGNvcnJl
c3BvbmRpbmcgcmVzcG9uc2UsIHRoZSBDUSBFbnRyeSB3aWxsIGF1dG9tYXRpY2FsbHkgDQogICBp
bmNyZW1lbnQgYnkgMS4gVGhpcyBjYXNlIGlzIHRoZSBzaW1wbGVzdCwgdGhlIFNRRSANCiAgIHdp
bGwgaGF2ZSBhIGNvcnJlc3BvbmRpbmcgQ1FFIGZvciB0aGUgaG9zdCB0byBjbGVhbnVwIA0KICAg
cmVzb3VyY2VzLg0KDQoyLiBXaGVuIHRoZSBob3N0IGNvbnRyb2xsZXIgaGFzIG5vdCB5ZXQgc2Vu
dCBvdXQgdGhpcyBTUUUgDQogIChTUSBpcyBub3QgZW1wdHkpLCB0aGUgc29mdHdhcmUgY2FuIGZp
bGwgaW4gJ251bGxpZnknIHRvIA0KICBub3RpZnkgdGhlIGhvc3QgY29udHJvbGxlciB0aGF0IHRo
ZXJlIGlzIG5vIG5lZWQgdG8gc2VuZCANCiAgaXQsIGFuZCBkaXJlY3RseSBmaWxsIHRoZSBjb3Jy
ZXNwb25kaW5nIHJlc3BvbnNlIGludG8gdGhlIA0KICBDUSB3aXRoIE9DUzogQUJPUlRFRC4gVGhp
cyBzY2VuYXJpbyBpcyBhbHNvIHN0cmFpZ2h0Zm9yd2FyZCwgDQogIHRoZSBVRlMgZGV2aWNlIHdv
bid0IGJlIGF3YXJlLCBhbmQgb25seSB0aGUgaG9zdCBjb250cm9sbGVyIA0KICBuZWVkcyB0byBj
bGVhbiB1cCB0aGUgcmVsYXRlZCByZXNvdXJjZXMuDQoNCjMuIFdoZW4gdGhlIGhvc3QgY29udHJv
bGxlciBoYXMgYWxyZWFkeSBzZW50IG91dCB0aGUgU1FFIA0KICAgYW5kIGlzIHdhaXRpbmcgZm9y
IHRoZSByZXNwb25zZSBmcm9tIHRoZSBVRlMgZGV2aWNlIChDUUUpLCANCiAgIHRoZSBzb2Z0d2Fy
ZSBjYW4gaW5pdGlhdGUgY2xlYW51cCB0byBub3RpZnkgdGhlIGhvc3QgDQogICBjb250cm9sbGVy
IHRoYXQgdGhlcmUgaXMgbm8gbmVlZCB0byB3YWl0LCBhbmQgZGlyZWN0bHkgZmlsbCANCiAgIHRo
ZSBjb3JyZXNwb25kaW5nIHJlc3BvbnNlIGludG8gdGhlIENRIHdpdGggT0NTOiBBQk9SVEVELg0K
DQpUaGVyZWZvcmUsIHdoZW4gYSBUTUYgaXMgc3VjY2Vzc2Z1bGx5IGV4ZWN1dGVkLCBmb3IgZXhh
bXBsZSwgDQp0YWcgMCBoYXMgYmVlbiBhYm9ydGVkLCB0aGUgc29mdHdhcmUgd2lsbCBrbm93IHRo
YXQgdGhlIFVGUyANCmRldmljZSB3aWxsIG5vIGxvbmdlciByZXR1cm4gYSByZXNwb25zZSBmb3Ig
dGFnIDAuIA0KVGh1cywgdGhlIGhvc3QgY29udHJvbGxlciBuZWVkcyB0byBpbml0aWF0ZSBjbGVh
bnVwLCANCmFsbG93aW5nIHRoZSBDUUUgY29ycmVzcG9uZGluZyB0byB0aGlzIFNRRSB0byByZXR1
cm4sIA0Kd2hpbGUgYWxzbyBjbGVhbmluZyB0aGUgcmVzb3VyY2VzIGZvciB0YWcgMC4NCg0KSW4g
Ym90aCB0aGUgc2Vjb25kIGFuZCB0aGlyZCBjYXNlcywgbm8gbWF0dGVyIHdoaWNoIG9uZSBvY2N1
cnMsIA0KdGhleSB3aWxsIHJlc3VsdCBpbiB0aGUgQ1FFIGNvcnJlc3BvbmRpbmcgdG8gdGhlIFNR
RSBiZWluZyANCmZpbGxlZCB3aXRoIE9DUzogQUJPUlRFRC4gU28sIGFzIGxvbmcgYXMgd2UgZGly
ZWN0bHkgDQpyZXF1ZXVlIHdoZW4gT0NTOiBBQk9SVEVELCBpdCB3aWxsIHNhdGlzZnkgYm90aCBv
ZiB0aGVzZSANCnNpdHVhdGlvbnMuDQoNClRoYW5rcw0KUGV0ZXINCg0KDQo=
