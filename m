Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833A33BBEA
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jul 2024 08:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719997092; cv=fail; b=JozBIYG33WlhQpi+5Z/XmRabL2RLBXKnwLJbC1PyXnFLu/hUu7ESlzKzOYHkF7pTzWwqWU/DqiM/0h8WqUeMuyPrZqGJ5sbVZ1QY0UgvWfyVJ1m9OpkKYOAwiq41PQT8igqt/MCDk2pnnS8obs1r+BTekiSK00HrJHBe8A9oSy4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719997092; c=relaxed/simple;
	bh=Nb7srutFftAPy9VLfroLNo542dkmNCx67dtD324rwvM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hlwbWhsN4gmn9pl6RxAVdptrk8JtkNJeMs5M7pqdWWUTP7WxAcF0Pb4nCEaSYPVkGCQ5mdWZVccJZ+ltuMe9HUT/rXnl0xNhV1ZLqSwZTukAvmE+1v3ejBLn9y6hLdhDqV9DsE1P5yCKFsX2mGLgnokh22k2Y38lQbmH3haTFvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hhBe6cjH; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=YM+gd0XH; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hhBe6cjH";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="YM+gd0XH"
X-UUID: 5c3a48dc391a11ef99dc3f8fac2c3230-20240703
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Nb7srutFftAPy9VLfroLNo542dkmNCx67dtD324rwvM=;
	b=hhBe6cjH6fvmZZnrgJKF9JUq0XUkgQC8gJ8+W0T1KiNq1ogOhegpHsdN8Lr3QDEArhaVVj1Cw/LBRAhh16JsUMrJQyan8ofGXhi7OTOGJzam2j9M1TB4TQwlpaZUMC4aPa2MwolZvCN5Jy8czKD6OpYBnBEehGYm7ZNHs03ihdY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:0dd66628-cdd8-46a0-b083-67fe2c55e0e4,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:3c62db44-a117-4f46-a956-71ffeac67bfa,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: 5c3a48dc391a11ef99dc3f8fac2c3230-20240703
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 884715270; Wed, 03 Jul 2024 16:58:05 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 3 Jul 2024 16:58:03 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 3 Jul 2024 16:58:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/uc3Q54GAZumMHvmPhi5s8j8fgt6P0vM2lGqr8oxm71CuYcPgbR64Erv5Pj9uJ9PsU94RRORyo6+6TrJoEkEq8ceIZT0vi0DAWtKpcbk4bTzoTcH38gm82aPZ8xkLHKvyxiDZHz03+CINwO2LBHKI87jCIJXJLIubs3I7bnRm5ZtJjrFSOIeosa1k4LXbaUlUEKON01l+YoYCaIJu5UDrxz04PC4tT0PFrJhUaiAxv1sn2+2diyfDinsUq5K4LOxvqXqzS3GJUw528wOqVC0d9lNntPDnSSL+jdgcxiJyf6yr8llG2ZoZ7ASyZ0MQusuCZWxRKrfPmb8zDeIt93eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nb7srutFftAPy9VLfroLNo542dkmNCx67dtD324rwvM=;
 b=J+E7ftUdlDqdxkqUErSiD5cG+ZEpfUZukRHR7gNv6fn/7RmtSntspyAfRUTWJLJIqBXTOGjbTCslPKRLIvi+AYscp8rwwzBTeqLsvudkkYHY7Eh5i8r+G7bdFpZGlVyLZgrxNVjZ8KxZjiOSA1SmYNaXGuB5tz1BZwnbTD+0pfM0e4pmBgiyOIuKBkyCIhmMxvY/qURR6L8hei7t3z/ODPVwhtrGKdaV6TQ8NX6318Jz3sgZ95DIvZNocsEl+Ah4OcEXZNNLIajIe9ZXxJGfp+rTw3o0frEKHSXgPRmOxiS9wIZwzAqh9m6q0h5d6QJ+FFlhPkxwS4Q4d/VC+QGVuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nb7srutFftAPy9VLfroLNo542dkmNCx67dtD324rwvM=;
 b=YM+gd0XHR/KwoCXqsNLfvl25qkBR4nQc98s2kSsPPdGWlIpMPrZ0A5/yTnBFDi4FI8UxU3TKo+KwgQC17S+JM5n5C0UG4UsdVzcTTrjww5QH9KsdWDqPj5fJ/k5CLvjv+ufoSgYi3VprOympdw8LIMBDd+z8h9nJl49RLQ7FxXU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7200.apcprd03.prod.outlook.com (2603:1096:820:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.33; Wed, 3 Jul
 2024 08:58:01 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.029; Wed, 3 Jul 2024
 08:58:01 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ahalaney@redhat.com" <ahalaney@redhat.com>, "quic_mnaresh@quicinc.com"
	<quic_mnaresh@quicinc.com>, "akinobu.mita@gmail.com"
	<akinobu.mita@gmail.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 6/9] scsi: ufs: Inline is_mcq_enabled()
Thread-Topic: [PATCH v4 6/9] scsi: ufs: Inline is_mcq_enabled()
Thread-Index: AQHazMBLiJMwlqlSG0GzLdz2mNSbi7HktLUA
Date: Wed, 3 Jul 2024 08:58:01 +0000
Message-ID: <b367b53462c4a356dee9f63f11d06a7e0ca59a2e.camel@mediatek.com>
References: <20240702204020.2489324-1-bvanassche@acm.org>
	 <20240702204020.2489324-7-bvanassche@acm.org>
In-Reply-To: <20240702204020.2489324-7-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7200:EE_
x-ms-office365-filtering-correlation-id: 9ab62955-d613-47ee-7583-08dc9b3e3e71
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SjNsREN2ZExEOFNoRGhpNFNUQUJSS24rNzkwdGVndVVYdDVTU0FJVk5XQWlq?=
 =?utf-8?B?NjBFRzNMR3Jta1pkbEdUem9DaXBLdkFIWGZhVlBDK01pSE5YNVRRQW5KSlcv?=
 =?utf-8?B?bUtFMWJrSEdsclV1U2U3Q1FiUXJwQUF6Q0RKblUyUlBmTkRqdjR3UHJ2VGdG?=
 =?utf-8?B?eGVDK2FmeHlreVBHU09OV2xRZFFidVU3NWxZNVBjZWNvY0pxMmFEZUFwVEJm?=
 =?utf-8?B?YnJibkI4ellaMzRsa2gybzI0ekgxaDZEeWpHY1U3NG5CcmJLUXI3M0FOeVV3?=
 =?utf-8?B?TzRzV0lwNE5pMmRYU29ER1pkUUxyMFNORHhKSVYxWGVDRmlHV0QxaVk2OXZ6?=
 =?utf-8?B?S0syRnVld2ZENWNmSE92dUs1MHJmeW12L2VmQzZ1RmptNi85cU9HbkxKVGFD?=
 =?utf-8?B?bEhUUWJXY1pCZUpNTm9jejdBR3d2REFMMzJmK2RFZTI2ZjZrRVBFQWRwb2FK?=
 =?utf-8?B?OGthMG13cDh4QVl3WDE5TUR6T2Roc2FMM1kwN3Z0NTRqWVJkZFNvRm9jdmRl?=
 =?utf-8?B?c2J3WmU3YzBWZGF5eHlPbTdvblMvWXk0ODh0eUx5bHFiTldvMDRqMEVQbEtm?=
 =?utf-8?B?M3lDQ3kyU2VaL1FuVTBIeW5LaEhkWTVJWDBXZGVJKzNWOWdOOGg2aTNQWXZS?=
 =?utf-8?B?RjBkQ1IzOTFaTkYyb0c4amdEckZZTzJIWDlNOVNMcWsyL25zcms0UURWa2xR?=
 =?utf-8?B?dHE3d3NzUnpNY0RIL2dBcXNGcC9MQWYyR3J4WCtvTmYvNE9MWFBXeEN2NGMy?=
 =?utf-8?B?RlcxSVdNY3ovYnFvcWloOWxKZ0R0VzcrM1pQUWJEUzFOZEFPbFR1OElIYnRD?=
 =?utf-8?B?c200Y1ZRMStCRnh2QW1RTkJ5d1V4U3BkbU9yYWlRRlRlVUVZKzMrUDhsd0xU?=
 =?utf-8?B?YWFGY1FUSG45eU1FODFMY1RWQzhYSlNyakVWSHhSdVc3dzZxbmM3WFIrU2c0?=
 =?utf-8?B?SXduYnlnMjR3MW1seW1SeTF4VWl1aEhNMU96MEozb0dpelgyRVM0K0R1WmRp?=
 =?utf-8?B?TmwyZ0w5SndHdm4wbC9wM21QOFlnSXNLQ0s0Z2JXdWNId3d2TTU1Tm9rdzF1?=
 =?utf-8?B?MjU2V3lXK08zc2lkYU5UcVd0S2VUL0RmOVQreDRrTk10TklMMXF3RGRyTk1o?=
 =?utf-8?B?czhiSjlWVHJuRDRnQlZHSmc2YzlPVmMwYzhBTmFVZXRTSHhHQ01BZm1GZUVq?=
 =?utf-8?B?VWFWQnhqV21vQTFzeGF5YzJHUVdIbmovYUFMbmx3citYMHRzU2RVeWZTZmJo?=
 =?utf-8?B?cXRLT0JrQmJRQ1RjZDZBNWtGMUVDNy9wZXZNMWtWSDRVV3daWVdVUkhtV3pz?=
 =?utf-8?B?bDdaempaNTZ1NU00QkZ4U1NTamp5OHBPZm10QkNSNCtBaWUxc1h0NE1TbGxr?=
 =?utf-8?B?TERnR0c0QXJIZ2NNdUNDWnBrMVJTT2lOa0J4eWFsMVBZeklMV1pFdTB3YlFY?=
 =?utf-8?B?Z203MVB0N1Q5aVRSOVV6a1hJVVZjTERvQWdNc3cwcjZyQ3JjMU5WL0RpN1pQ?=
 =?utf-8?B?aTk3Z3Raa1gzVUk0TWd2cjJrSVVHUnVpTXRRV25yVFNvM05ER1VZLzBYaXpM?=
 =?utf-8?B?c3VJVFJsOVE4aUF5RFl1dDAzOWlTc25nODRZbGk5aGwzVWF3WVp1WDdCNzdZ?=
 =?utf-8?B?ZWhvYjQ5ZVdMdnVVNkpxWmxTcjdnQWgzY0E4Y2xsazdMdDVhL05QN2dZbExp?=
 =?utf-8?B?ZVYyeXN5M1pxV1JRcyttenJBNU1TLzE4NnR2L0c1Q0oyclNudytxdDVrV2ZC?=
 =?utf-8?B?L1BkbDVNREhCQmpFU0VncFlZTVRLd0xxdTh5ellrcnpHVzFUS1Yvcm10RUxj?=
 =?utf-8?B?Vy9QUllUUXZqNEtPZjN4WHJxRnF1U3ZGRWdvZW9tOE91MC9DNTBoRnRpT0hS?=
 =?utf-8?B?ZVkzL2RjZXE1bjhkdmxpNmxsanVZY0FXSm9mdUMrU1Azb2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUw4RTkyZFRuYWxVRU44NVBtdiswVUQybGRZNk9UVkFUdkgrMGp1djI0YWtG?=
 =?utf-8?B?VDdhRDhYVzQwVWhETm9KTlV1QmV6RmM4SHNndmN3Y1QzYW9hdWZ5V243cmVT?=
 =?utf-8?B?VGZaZkxmZ21sVmZjaHl5cGNtaXFXMFdaeWkxNVhhUENVOU84dEptT3JFYzBy?=
 =?utf-8?B?anpIaVUzTExaQzUwV1ZyN2lEOXh4b1FEVmZzYzZzSk9OR3JjNDVkTW9yVkNC?=
 =?utf-8?B?WHBuQXFMeWtwSG9lTWlEengwcFJGUElhTUFZb2ZJRGdiRnZ3bkp6Y2lkUW5o?=
 =?utf-8?B?M2I5OGRXeWNRdzl1N1lYN2tZVGpxU3hTUlNKU0lvZzc1bndlZlBKQUxjK09U?=
 =?utf-8?B?Q29PNDBTOVcyaVN3REM5YnAyTHo5MCtoNUFXM1RpYVV4ZW41cXlXQjNwMFBs?=
 =?utf-8?B?T0lyMi9oR2dQYmE4QjZlWDVaU1hRcXNhOGdTNGZQVVBCOUJrNHAwaEdLVXhL?=
 =?utf-8?B?YWFWTU13WW1GUFp2alpLSlVsMEF4OURQbmdrMW1PTUh2OTZaNEhnS0t1VGo3?=
 =?utf-8?B?SXF4VnpZUmc0bnBsZnZpTjUybmhVMWI2NVREUy9qQk9hYlN5b0ZObzNUZDZB?=
 =?utf-8?B?V3NHdWFiWDk4S2RheGZZbkxadU1tNFR3KzFHT2diUjVsRW5uc0xhazhWMWta?=
 =?utf-8?B?T05ncHZtR090V3lwaTRUd2lrcTlrUlhSanlVdkd3UWU5NlNMSzhEMndPRm1R?=
 =?utf-8?B?cGtCNVQ1bDA4Zy9peHVTK3ZQR1VTMmczaSsxVkZSdmhPNEZicUtxaHkwTVpZ?=
 =?utf-8?B?SERYU3dpVlptZ2JrRkRHWDJTYklQOUNUKzhSdlU5eWNFSXNrQUc1VDNxQkYx?=
 =?utf-8?B?SUJmaS9nQVpCS0YyaVlnRm1VemYvemhwUEdmejlVK000b0c3TEVNQmFVTUw5?=
 =?utf-8?B?WFNWV1RaeURQc2RzNDRvQWFwcStRVENPdGVJNmNCN0oycnF4RjBmcURjYzJk?=
 =?utf-8?B?UU9lWEE3TTg5RVdzVDdBMk5JeGJPZ2E3U2c5QlNtdmxJb05JTWFnUm9XVXRD?=
 =?utf-8?B?Q1hkV2xDLzZ3QVZESHVKVndSUEFwOURBcnB2L1dnV3JQZ20rQmQ0RDRQdVNG?=
 =?utf-8?B?RmxRMTJFTE1kUC9KdUNWS1N4SHBUbk9nenNBVGJxOUxKcjdGYUNzVFZUcjJr?=
 =?utf-8?B?NkdnMXUyallkVGlUM3NyV09PT0YzNmwwbkR2ZGx2Z2hiN2M4ZFN4REpmYTdz?=
 =?utf-8?B?T0ptaVZtRitBaWNLZnV1dVVVMkYzMkNYY2lkV3V6bkxxRHZlWkE4UDRvSVpa?=
 =?utf-8?B?RmV0eE1pVTdGVnZkdThMTHd3UlZTZkpwVDl6TXdxL1FRRjNLaTBEc0N0elNS?=
 =?utf-8?B?NC90czA2V2FrSkMrM1IrSkMxM1I0QTM4U21Dbnczb09QUFFtRjdSeERDM0h1?=
 =?utf-8?B?WkF4amlpaGd4VVBQQmhJRVdhaUJSVjhhQUJ1QURXZWFoZFBnOHNNTkZicFVS?=
 =?utf-8?B?REJBalU0WGVKWXczVllsc00ydHgyTFY2RFdFZ1U0cVllNWdkRStubGhWWURl?=
 =?utf-8?B?WVlUYkVDUWkvQ1UreXdZQVBWUkdpM1UxVTV2RlROd2YyV09VMm5WVWxaMzNL?=
 =?utf-8?B?MlM1Zkl3NzVsT1oweUgzYTYzWmloL2xXSG0zYmpianArYU1Ga1c1cENQd2Nv?=
 =?utf-8?B?dFRVUzVCQlpueUVqWDhUZlNPRHBHZjFhQVRod0hpSEFVTnNQdExxdTZGZUk2?=
 =?utf-8?B?bkR6T3V3enRxV1ZIazE1MnNaVTZLM05NY2pSeTh1YUw0cW44TlE1ZW9sai9S?=
 =?utf-8?B?aW5CQ1NFcyt2M0poYmxKS0VUYlJtNWc3Rk9iVmY5eG5HU2x1bDVkem9xNjBG?=
 =?utf-8?B?aHp2aEd2TnVsQm9uUDMzRmxieWFtczRVNi9lZUE1YUNLY0dTVHZkNGQvL2c3?=
 =?utf-8?B?ZW5PSTJnS2pIT3d0NWRCU2hFNVUybHhNc3BDV0VYZDA5a1crekNPVU1qMWlN?=
 =?utf-8?B?WS9oVmwyMFYyd1RmSmdYR3lMQVdFcXVrMlUzcEowbjhNZWJSUWFrbmo4S05t?=
 =?utf-8?B?QUNYY1doQ1R0Ty9Pd3hXR3ZML2lrYkl5d2JVT041bmxCOXdHQnZjazl1SURq?=
 =?utf-8?B?UUpVa05EdndtcmUzZDNJblJFZ3d5Yy81YVdMY3QxZjYrMnd1cnpDcCs2cnJM?=
 =?utf-8?B?aUo2OVI0ZS9tMzlwY21QZlZvcnI4dDBZTndvU0RXeEdQNVIvL1JpNnFGUG1n?=
 =?utf-8?B?ZWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <07010A8738418D46A095469422844C2E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ab62955-d613-47ee-7583-08dc9b3e3e71
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2024 08:58:01.7463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IjPaoR76wTHV+tyZsWc+rSLzRn8YVjSoz7WePRELTJLTEPlbyvacKGdPiR/RP1zx7KY7JgsY7YqNYt+SKdG2fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7200
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--27.887400-8.000000
X-TMASE-MatchedRID: UWn79NfEZzbUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2aK+MsTwM+1lKPIx+MJF9o99RlPzeVuQQPJ0
	5UREtjOVzY42c5lAKir7jz+C1cUy8XZXnjooQdchAKD7bjg/G2jQAp53S718Hu6qThyrnanOHzS
	+w/xzBDt99DE9fMabxdECnoH48yMURXrSqR8jJuVu4M/xm4KZegYy8y+HaPlbIvQIyugvKdVUnQ
	AOplXiG3wRvo7D+BFnNQ/3yXFTAAGMAzi+7d0chuTj+fYYamkiXOVo0UPe9FHhOa4C/aON5rhOh
	ST9pKbUbTjFqSkJMGUoy5WLoLWsKQv21zJNl0CyDGx/OQ1GV8rHlqZYrZqdI+gtHj7OwNO0CpgE
	TeT0ynA==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--27.887400-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	24A314C60A9059B0D470C174B0682A732D54E832D34EF38CA20689AD4ABCD3432000:8
X-MTK: N

T24gVHVlLCAyMDI0LTA3LTAyIGF0IDEzOjM5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgSW1wcm92ZSBjb2RlIHJlYWRhYmlsaXR5IGJ5IGlubGluaW5nIGlz
X21jcV9lbmFibGVkKCkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2
YW5hc3NjaGVAYWNtLm9yZz4NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIHwg
MjggKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLQ0KPiAgaW5jbHVkZS91ZnMvdWZzaGNkLmgg
ICAgICB8ICA1IC0tLS0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDE5
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNk
LmMgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IGluZGV4IDE3OGIwYWJhZWIzMC4uNGMx
MzhmNDJhODAyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ICsr
KyBiL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gQEAgLTQ1Myw3ICs0NTMsNyBAQCBzdGF0
aWMgdm9pZCB1ZnNoY2RfYWRkX2NvbW1hbmRfdHJhY2Uoc3RydWN0DQo+IHVmc19oYmEgKmhiYSwg
dW5zaWduZWQgaW50IHRhZywNCj4gIA0KPiAgCWludHIgPSB1ZnNoY2RfcmVhZGwoaGJhLCBSRUdf
SU5URVJSVVBUX1NUQVRVUyk7DQo+ICANCj4gLQlpZiAoaXNfbWNxX2VuYWJsZWQoaGJhKSkgew0K
PiArCWlmIChoYmEtPm1jcV9lbmFibGVkKSB7DQo+ICAJCXN0cnVjdCB1ZnNfaHdfcXVldWUgKmh3
cSA9IHVmc2hjZF9tY3FfcmVxX3RvX2h3cShoYmEsDQo+IHJxKTsNCj4gIA0KPiAgCQlod3FfaWQg
PSBod3EtPmlkOw0KPiBAQCAtMjMwMSw3ICsyMzAxLDcgQEAgdm9pZCB1ZnNoY2Rfc2VuZF9jb21t
YW5kKHN0cnVjdCB1ZnNfaGJhICpoYmEsDQo+IHVuc2lnbmVkIGludCB0YXNrX3RhZywNCj4gIAlp
ZiAodW5saWtlbHkodWZzaGNkX3Nob3VsZF9pbmZvcm1fbW9uaXRvcihoYmEsIGxyYnApKSkNCj4g
IAkJdWZzaGNkX3N0YXJ0X21vbml0b3IoaGJhLCBscmJwKTsNCj4gIA0KPiAtCWlmIChpc19tY3Ff
ZW5hYmxlZChoYmEpKSB7DQo+ICsJaWYgKGhiYS0+bWNxX2VuYWJsZWQpIHsNCj4gIAkJaW50IHV0
cmRfc2l6ZSA9IHNpemVvZihzdHJ1Y3QgdXRwX3RyYW5zZmVyX3JlcV9kZXNjKTsNCj4gIAkJc3Ry
dWN0IHV0cF90cmFuc2Zlcl9yZXFfZGVzYyAqc3JjID0gbHJicC0NCj4gPnV0cl9kZXNjcmlwdG9y
X3B0cjsNCj4gIAkJc3RydWN0IHV0cF90cmFuc2Zlcl9yZXFfZGVzYyAqZGVzdDsNCj4gQEAgLTMw
MDAsNyArMzAwMCw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3F1ZXVlY29tbWFuZChzdHJ1Y3QgU2Nz
aV9Ib3N0DQo+ICpob3N0LCBzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQpDQo+ICAJCWdvdG8gb3V0Ow0K
PiAgCX0NCj4gIA0KPiAtCWlmIChpc19tY3FfZW5hYmxlZChoYmEpKQ0KPiArCWlmIChoYmEtPm1j
cV9lbmFibGVkKQ0KPiAgCQlod3EgPSB1ZnNoY2RfbWNxX3JlcV90b19od3EoaGJhLCBzY3NpX2Nt
ZF90b19ycShjbWQpKTsNCj4gIA0KPiAgCXVmc2hjZF9zZW5kX2NvbW1hbmQoaGJhLCB0YWcsIGh3
cSk7DQo+IEBAIC0zMDU5LDcgKzMwNTksNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9jbGVhcl9jbWQo
c3RydWN0IHVmc19oYmENCj4gKmhiYSwgdTMyIHRhc2tfdGFnKQ0KPiAgCXVuc2lnbmVkIGxvbmcg
ZmxhZ3M7DQo+ICAJaW50IGVycjsNCj4gIA0KPiAtCWlmIChpc19tY3FfZW5hYmxlZChoYmEpKSB7
DQo+ICsJaWYgKGhiYS0+bWNxX2VuYWJsZWQpIHsNCj4gIAkJLyoNCj4gIAkJICogTUNRIG1vZGUu
IENsZWFuIHVwIHRoZSBNQ1EgcmVzb3VyY2VzIHNpbWlsYXIgdG8NCj4gIAkJICogd2hhdCB0aGUg
dWZzaGNkX3V0cmxfY2xlYXIoKSBkb2VzIGZvciBTREIgbW9kZS4NCj4gQEAgLTMxNjksNyArMzE2
OSw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3dhaXRfZm9yX2Rldl9jbWQoc3RydWN0DQo+IHVmc19o
YmEgKmhiYSwNCj4gIAkJCV9fZnVuY19fLCBscmJwLT50YXNrX3RhZyk7DQo+ICANCj4gIAkJLyog
TUNRIG1vZGUgKi8NCj4gLQkJaWYgKGlzX21jcV9lbmFibGVkKGhiYSkpIHsNCj4gKwkJaWYgKGhi
YS0+bWNxX2VuYWJsZWQpIHsNCj4gIAkJCS8qIHN1Y2Nlc3NmdWxseSBjbGVhcmVkIHRoZSBjb21t
YW5kLCByZXRyeSBpZg0KPiBuZWVkZWQgKi8NCj4gIAkJCWlmICh1ZnNoY2RfY2xlYXJfY21kKGhi
YSwgbHJicC0+dGFza190YWcpID09IDApDQo+ICAJCQkJZXJyID0gLUVBR0FJTjsNCj4gQEAgLTU1
NjAsNyArNTU2MCw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX3BvbGwoc3RydWN0IFNjc2lfSG9zdCAq
c2hvc3QsDQo+IHVuc2lnbmVkIGludCBxdWV1ZV9udW0pDQo+ICAJdTMyIHRyX2Rvb3JiZWxsOw0K
PiAgCXN0cnVjdCB1ZnNfaHdfcXVldWUgKmh3cTsNCj4gIA0KPiAtCWlmIChpc19tY3FfZW5hYmxl
ZChoYmEpKSB7DQo+ICsJaWYgKGhiYS0+bWNxX2VuYWJsZWQpIHsNCj4gIAkJaHdxID0gJmhiYS0+
dWhxW3F1ZXVlX251bV07DQo+ICANCj4gIAkJcmV0dXJuIHVmc2hjZF9tY3FfcG9sbF9jcWVfbG9j
ayhoYmEsIGh3cSk7DQo+IEBAIC02MjAxLDcgKzYyMDEsNyBAQCBzdGF0aWMgdm9pZA0KPiB1ZnNo
Y2RfZXhjZXB0aW9uX2V2ZW50X2hhbmRsZXIoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQ0KPiAg
LyogQ29tcGxldGUgcmVxdWVzdHMgdGhhdCBoYXZlIGRvb3ItYmVsbCBjbGVhcmVkICovDQo+ICBz
dGF0aWMgdm9pZCB1ZnNoY2RfY29tcGxldGVfcmVxdWVzdHMoc3RydWN0IHVmc19oYmEgKmhiYSwg
Ym9vbA0KPiBmb3JjZV9jb21wbCkNCj4gIHsNCj4gLQlpZiAoaXNfbWNxX2VuYWJsZWQoaGJhKSkN
Cj4gKwlpZiAoaGJhLT5tY3FfZW5hYmxlZCkNCj4gIAkJdWZzaGNkX21jcV9jb21wbF9wZW5kaW5n
X3RyYW5zZmVyKGhiYSwgZm9yY2VfY29tcGwpOw0KPiAgCWVsc2UNCj4gIAkJdWZzaGNkX3RyYW5z
ZmVyX3JlcV9jb21wbChoYmEpOw0KPiBAQCAtNjQ1OCw3ICs2NDU4LDcgQEAgc3RhdGljIGJvb2wg
dWZzaGNkX2Fib3J0X29uZShzdHJ1Y3QgcmVxdWVzdA0KPiAqcnEsIHZvaWQgKnByaXYpDQo+ICAJ
CSpyZXQgPyAiZmFpbGVkIiA6ICJzdWNjZWVkZWQiKTsNCj4gIA0KPiAgCS8qIFJlbGVhc2UgY21k
IGluIE1DUSBtb2RlIGlmIGFib3J0IHN1Y2NlZWRzICovDQo+IC0JaWYgKGlzX21jcV9lbmFibGVk
KGhiYSkgJiYgKCpyZXQgPT0gMCkpIHsNCj4gKwlpZiAoaGJhLT5tY3FfZW5hYmxlZCAmJiAoKnJl
dCA9PSAwKSkgew0KPiAgCQlod3EgPSB1ZnNoY2RfbWNxX3JlcV90b19od3EoaGJhLCBzY3NpX2Nt
ZF90b19ycShscmJwLQ0KPiA+Y21kKSk7DQo+ICAJCXNwaW5fbG9ja19pcnFzYXZlKCZod3EtPmNx
X2xvY2ssIGZsYWdzKTsNCj4gIAkJaWYgKHVmc2hjZF9jbWRfaW5mbGlnaHQobHJicC0+Y21kKSkN
Cj4gQEAgLTczODksNyArNzM4OSw3IEBAIHN0YXRpYyBpbnQNCj4gdWZzaGNkX2VoX2RldmljZV9y
ZXNldF9oYW5kbGVyKHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4gIAkJZ290byBvdXQ7DQo+ICAJ
fQ0KPiAgDQo+IC0JaWYgKGlzX21jcV9lbmFibGVkKGhiYSkpIHsNCj4gKwlpZiAoaGJhLT5tY3Ff
ZW5hYmxlZCkgew0KPiAgCQlmb3IgKHBvcyA9IDA7IHBvcyA8IGhiYS0+bnV0cnM7IHBvcysrKSB7
DQo+ICAJCQlscmJwID0gJmhiYS0+bHJiW3Bvc107DQo+ICAJCQlpZiAodWZzaGNkX2NtZF9pbmZs
aWdodChscmJwLT5jbWQpICYmDQo+IEBAIC03NDg1LDcgKzc0ODUsNyBAQCBpbnQgdWZzaGNkX3Ry
eV90b19hYm9ydF90YXNrKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsIGludCB0YWcpDQo+ICAJCQkg
Ki8NCj4gIAkJCWRldl9lcnIoaGJhLT5kZXYsICIlczogY21kIGF0IHRhZyAlZCBub3QNCj4gcGVu
ZGluZyBpbiB0aGUgZGV2aWNlLlxuIiwNCj4gIAkJCQlfX2Z1bmNfXywgdGFnKTsNCj4gLQkJCWlm
IChpc19tY3FfZW5hYmxlZChoYmEpKSB7DQo+ICsJCQlpZiAoaGJhLT5tY3FfZW5hYmxlZCkgew0K
PiAgCQkJCS8qIE1DUSBtb2RlICovDQo+ICAJCQkJaWYgKHVmc2hjZF9jbWRfaW5mbGlnaHQobHJi
cC0+Y21kKSkgew0KPiAgCQkJCQkvKiBzbGVlcCBmb3IgbWF4LiAyMDB1cyBzYW1lDQo+IGRlbGF5
IGFzIGluIFNEQiBtb2RlICovDQo+IEBAIC03NTYzLDcgKzc1NjMsNyBAQCBzdGF0aWMgaW50IHVm
c2hjZF9hYm9ydChzdHJ1Y3Qgc2NzaV9jbW5kICpjbWQpDQo+ICANCj4gIAl1ZnNoY2RfaG9sZCho
YmEpOw0KPiAgDQo+IC0JaWYgKCFpc19tY3FfZW5hYmxlZChoYmEpKSB7DQo+ICsJaWYgKCFoYmEt
Pm1jcV9lbmFibGVkKSB7DQo+ICAJCXJlZyA9IHVmc2hjZF9yZWFkbChoYmEsDQo+IFJFR19VVFBf
VFJBTlNGRVJfUkVRX0RPT1JfQkVMTCk7DQo+ICAJCWlmICghdGVzdF9iaXQodGFnLCAmaGJhLT5v
dXRzdGFuZGluZ19yZXFzKSkgew0KPiAgCQkJLyogSWYgY29tbWFuZCBpcyBhbHJlYWR5IGFib3J0
ZWQvY29tcGxldGVkLA0KPiByZXR1cm4gRkFJTEVELiAqLw0KPiBAQCAtNzU5Niw3ICs3NTk2LDcg
QEAgc3RhdGljIGludCB1ZnNoY2RfYWJvcnQoc3RydWN0IHNjc2lfY21uZCAqY21kKQ0KPiAgCX0N
Cj4gIAloYmEtPnJlcV9hYm9ydF9jb3VudCsrOw0KPiAgDQo+IC0JaWYgKCFpc19tY3FfZW5hYmxl
ZChoYmEpICYmICEocmVnICYgKDEgPDwgdGFnKSkpIHsNCj4gKwlpZiAoIWhiYS0+bWNxX2VuYWJs
ZWQgJiYgIShyZWcgJiAoMSA8PCB0YWcpKSkgew0KPiAgCQkvKiBvbmx5IGV4ZWN1dGUgdGhpcyBj
b2RlIGluIHNpbmdsZSBkb29yYmVsbCBtb2RlICovDQo+ICAJCWRldl9lcnIoaGJhLT5kZXYsDQo+
ICAJCSIlczogY21kIHdhcyBjb21wbGV0ZWQsIGJ1dCB3aXRob3V0IGEgbm90aWZ5aW5nIGludHIs
DQo+IHRhZyA9ICVkIiwNCj4gQEAgLTc2MjMsNyArNzYyMyw3IEBAIHN0YXRpYyBpbnQgdWZzaGNk
X2Fib3J0KHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4gIAkJZ290byByZWxlYXNlOw0KPiAgCX0N
Cj4gIA0KPiAtCWlmIChpc19tY3FfZW5hYmxlZChoYmEpKSB7DQo+ICsJaWYgKGhiYS0+bWNxX2Vu
YWJsZWQpIHsNCj4gIAkJLyogTUNRIG1vZGUuIEJyYW5jaCBvZmYgdG8gaGFuZGxlIGFib3J0IGZv
ciBtY3EgbW9kZSAqLw0KPiAgCQllcnIgPSB1ZnNoY2RfbWNxX2Fib3J0KGNtZCk7DQo+ICAJCWdv
dG8gcmVsZWFzZTsNCj4gQEAgLTg3MzIsNyArODczMiw3IEBAIHN0YXRpYyBpbnQgdWZzaGNkX2Rl
dmljZV9pbml0KHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsIGJvb2wgaW5pdF9kZXZfcGFyYW1zKQ0K
PiAgCXVmc2hjZF9zZXRfbGlua19hY3RpdmUoaGJhKTsNCj4gIA0KPiAgCS8qIFJlY29uZmlndXJl
IE1DUSB1cG9uIHJlc2V0ICovDQo+IC0JaWYgKGlzX21jcV9lbmFibGVkKGhiYSkgJiYgIWluaXRf
ZGV2X3BhcmFtcykNCj4gKwlpZiAoaGJhLT5tY3FfZW5hYmxlZCAmJiAhaW5pdF9kZXZfcGFyYW1z
KQ0KPiAgCQl1ZnNoY2RfY29uZmlnX21jcShoYmEpOw0KPiAgDQo+ICAJLyogVmVyaWZ5IGRldmlj
ZSBpbml0aWFsaXphdGlvbiBieSBzZW5kaW5nIE5PUCBPVVQgVVBJVSAqLw0KPiBkaWZmIC0tZ2l0
IGEvaW5jbHVkZS91ZnMvdWZzaGNkLmggYi9pbmNsdWRlL3Vmcy91ZnNoY2QuaA0KPiBpbmRleCBk
NGQ2MzUwN2QwOTAuLmMwZTI4YTUxMmIzYyAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS91ZnMvdWZz
aGNkLmgNCj4gKysrIGIvaW5jbHVkZS91ZnMvdWZzaGNkLmgNCj4gQEAgLTExMzIsMTEgKzExMzIs
NiBAQCBzdHJ1Y3QgdWZzX2h3X3F1ZXVlIHsNCj4gIA0KPiAgI2RlZmluZSBNQ1FfUUNGR19TSVpF
CQkweDQwDQo+ICANCj4gLXN0YXRpYyBpbmxpbmUgYm9vbCBpc19tY3FfZW5hYmxlZChzdHJ1Y3Qg
dWZzX2hiYSAqaGJhKQ0KPiAtew0KPiAtCXJldHVybiBoYmEtPm1jcV9lbmFibGVkOw0KPiAtfQ0K
PiAtDQo+ICBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCB1ZnNoY2RfbWNxX29wcl9vZmZzZXQo
c3RydWN0IHVmc19oYmENCj4gKmhiYSwNCj4gIAkJZW51bSB1ZnNoY2RfbWNxX29wciBvcHIsIGlu
dCBpZHgpDQo+ICB7DQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5nQG1lZGlh
dGVrLmNvbT4NCg0K
