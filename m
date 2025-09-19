Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36D0304BDA
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 08:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758269528; cv=fail; b=HNj7i0O36d/0jtuvZOXRUSAiGjpui2ILOOeIFlbab7l29kUdb1LUCRsUlrM6AWNVXyzAxCT3NdJvdrRmi3bZqt5DB8gAzRdvT13+GOTz2sj22ZvoZQtiielX/MT0+u5/upBUsc2A4yLHKW3xAbKpsp8GpQ8QUCXq2/r+1kGOuQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758269528; c=relaxed/simple;
	bh=+EgeFEJixrMPizQCwk8f6SLhhcEDv9bb1SlwtZzMSs8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PVRi7uhnEmJ8XexAmcYSQyi5n0HfOb3gtsO571M/PBCWmraxpX+Ijl1OcAHoVBbJ/04cY1KgF8H7t38aRPgj1W7IJRNxrSwEiPihY7ezXHT2lekYVq11h91+RCAHBv80fVBCt5036elkIn6LACO9lkGe+LzmzUP3gQ6/VIO5nJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=YWvQIFG/; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=kZi22tEn; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YWvQIFG/";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="kZi22tEn"
X-UUID: 515c6472953011f0b33aeb1e7f16c2b6-20250919
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+EgeFEJixrMPizQCwk8f6SLhhcEDv9bb1SlwtZzMSs8=;
	b=YWvQIFG/ptOe+UBxn6hmHzQXKwoPfTjEqjErWW4zZJNVPQVBG5/Th8ye91IIHbwmSC8Pu0vaQQUzJRo76NFixlUTOfVTWIb75OOVjU8cXK5hwag5R+gfXz++J4pVPyn2dbGQ/nCmuYLjfYZxBjURe8A7t0qnkA4cNw1K2TbuAHM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:3a4fc520-aba7-4188-afb1-9ac32d4ed34e,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:74b279f8-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 515c6472953011f0b33aeb1e7f16c2b6-20250919
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 118674587; Fri, 19 Sep 2025 16:12:00 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 19 Sep 2025 16:11:59 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 19 Sep 2025 16:11:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qNXgfYY9e9NC5XvtdkAFGSu8vd80ZbP5SKhs2DzOm5APWiF9fTICoFKyBW1PTgsziieicjdfZdtT1xxcKrlpQVwSGqtnxf5FttbeFPNv6csRSsopUjv9aupGkf4am26zLlXaxxj6TIZhRcEoOy1to9nmFs2XQwRXAjCJABVfCkg2ZjZW8dBf1AyuO69QM1KqcTFh1Lw8UuDiz7wYb7eqY7pFaY4B3QImm5eOFjarWi97sCarjfPNdMrZx+msPbGSAUvnd5NZcV2fr2DLSkK675Goe8/Yvmy2idIKGqTVBlW2Dk9F7wlvmvDN9Mal0RcnUkQA9PWKfRVOBc49c/9hHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+EgeFEJixrMPizQCwk8f6SLhhcEDv9bb1SlwtZzMSs8=;
 b=woWt0rcggO4WFiUPfLjrTJ6CW5IWjgrQSuEo+xBctJFaHWdtcvAt4MX07/aH18LxWrK+9ztgpQqibHFZrZlQWWDEJ/2CT1duclGny0t/qwMuugRcoUjIjUKqimQjt3VJo7vHDQcmEQha4hH0xuozHp26He1MPdocbS6BDKac7a8dKwGOgvW9UzOrE7sQs3HezxbrK6MH/l44L1vzkZVLSMbty3ots373j+w72nYdMLqlMup6wr2JNTOHruC6bhnFAfjtmmeE3PKYsGjFoIsInLkPlC7W28ifPNBNcJjmSpsCGly4fR/zrkG0PEzhMnRbbS6G3W419jvUOvcbMwE6SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+EgeFEJixrMPizQCwk8f6SLhhcEDv9bb1SlwtZzMSs8=;
 b=kZi22tEnMJd/t/G9xdmyKgzdV/z68/uHweuAv7JC3NEJC33HVOH0ftFr5vtiSuSLe21Ryv1+DF3tspAZtYXW/ZOi78VxqVMgA0ZWUpigOTEwhDuMRWL8t9NkBjcuf6p9mBTYqwkWZQ1jQTS+wav331i2u77W6g6RafIK8vtpw+g=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7996.apcprd03.prod.outlook.com (2603:1096:400:44c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 08:11:56 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 08:11:56 +0000
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
Subject: Re: [PATCH v1 02/10] ufs: host: mediatek: Correct clock scaling with
 PM QoS flow
Thread-Topic: [PATCH v1 02/10] ufs: host: mediatek: Correct clock scaling with
 PM QoS flow
Thread-Index: AQHcKIi68y1ScQQmRECt8lruVe3TV7SZQ3oAgADllQA=
Date: Fri, 19 Sep 2025 08:11:56 +0000
Message-ID: <21a451c752709cd9c1a3e18568c18f384bb77a05.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-3-peter.wang@mediatek.com>
	 <02338932-b3e9-458a-ac24-41b4f29eb514@acm.org>
In-Reply-To: <02338932-b3e9-458a-ac24-41b4f29eb514@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7996:EE_
x-ms-office365-filtering-correlation-id: 580a76b4-ba59-4714-ed2c-08ddf7543355
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aGZQYyt4enY4S1h4N3NIMmFUUFl5bG1RVW5DWElFcGZSWUpSZWJxYTJZZXI3?=
 =?utf-8?B?WjlEOURDZ2w2bXEwK0pGbE14Qkk1Y1owb3dFRmhVR0JhZ0ZvaFdUVndzT085?=
 =?utf-8?B?bHJYZk4zcjRSSWhCYU43dTZDK00wdzhtZDhLRmxIM2FJV2Q3UDV4bWxEOFdr?=
 =?utf-8?B?cndzY29qY0JlL0Rmb21WandSMFplYTRyMVVzS3UxeHBCazUxdk9lTzQ5clpU?=
 =?utf-8?B?RkJPaHJ6OERuOUVWb3FPOC9TOHppc0todjVjbE0xY3pJWTJCcXQrb1BvSjRl?=
 =?utf-8?B?TEx6R0llOXdraDYwWTh0TjNWU3lpYkZ1UUI1UGNQTGU0dlIvcjNuWHd5NEFS?=
 =?utf-8?B?M0I1bkdiMWh5M2c0dWtMR0tGZlhhQlVvbzhvc2NiSW1sWFh3c3plY3M5Z2FK?=
 =?utf-8?B?NStuWllQR1M0QWF6OFZkQy9RTVYvcVlzRmFndGFBVVVhQUt2eHQ3N1pEWjN3?=
 =?utf-8?B?ZmxONDNBSHMwelhha3BXN0U0QzJmWjcvZXB5dHlOVmxnODZzYzlMZWlqMURT?=
 =?utf-8?B?QUIzY0trSXBJT3k5aFZjMzZWTFROQUtObEFxZnMzNzNwTzZqdkw1MExGeWsz?=
 =?utf-8?B?anpmS3NCTWJIdVplU0xOY3BvU1BUckg4bnplUDhNallDLzZpNG5Rc1NLYUxw?=
 =?utf-8?B?cGpmeTF4dW9zT1lCcVVoMDBhaUxRWnNGWmlYMUFRL1lDY0JkUzV4eFVlb0ls?=
 =?utf-8?B?UVFRZWJla24rQ1FyaHBLU21iZk83c2RoRzJzVzc4eFNzZkt0M21SdEhkUWll?=
 =?utf-8?B?N1ZRWGI5dlBRV2NiZXNEa0Z5bkpLdDZ4Yk5CM3VNL0JYbS9kWjN4L1hNcHZH?=
 =?utf-8?B?cjdlSE0za3Bta1FYcndmSzkrQnE0b1Joc3B1YkQ4Q1p0VXd6M0hlMXhtcmVC?=
 =?utf-8?B?bkNNZWVFU3ZuZjZuQ0huMkJ6c0ZZVVQrQjJpcW0rbDQwNXBBSERCRUhDQmRo?=
 =?utf-8?B?NGpPM3ZVSS8vWVRKTFlrMTVldVZqTTNQcjg2aitub1pHeFhFQ1MzY2dmRG5u?=
 =?utf-8?B?cytBczJBY3NBekRnd3k1UG1jK1BDaHJZaXJmZVhvY0o3MFZmREU3WXZ4Zysx?=
 =?utf-8?B?ZDE0MWlwV0NYMnpoM1dqTU1VczlEdFBlUTR1WVJJR0RLdmp1OXJTbnlzWkVq?=
 =?utf-8?B?ZnE2Q2pQVktPRFdTbE1yYVB4VUhVMUJzNjJPeWg2NUhtTEtwU0JDa3JySHds?=
 =?utf-8?B?MmpyVStCYzloOGlSbkR3SkZIdmdhNDMzRm1sTFFnbDBYeS9jWnNrTExwMHE5?=
 =?utf-8?B?UjgvSXRIRTVuSmJyYzk1U083TW9pZVhMa2g5VEQrNTFNaS9yVmE1OUtud01M?=
 =?utf-8?B?am9Zd2p6bHRuWWNiNUJnUFZWV29jTWRSZVpkd3FPZmtsVElPcDFPS1h5VlU5?=
 =?utf-8?B?NzA1eUhFRWp5dTFqUm16SHlLSU1aMWRQbVpyelcvUnpGVEVqdlZSSmFvUlJR?=
 =?utf-8?B?b2VpUmo2WFB3ZGlpZ3ZzKzE3TEkrVXNtL1NKY2N5TDcvcXRuczhVa0RYMjJI?=
 =?utf-8?B?U0tNMlo3OEFlb3U5REgwcFpTQVVLUkIrTWtxVjBvbEZRaUV5R3d1aVlDS2JF?=
 =?utf-8?B?VTRwc0ZheHlUa2tHYkp1UXdGaTlST3k1NURJdVEzb3UrU0t5disyZ3M5VzAy?=
 =?utf-8?B?d1dIaVcxSDd1RDdZaVhydlR1UWVGMXZraGYvMndlc3dmSzE3UWNGcDdEY1Vh?=
 =?utf-8?B?R3F0d1FoYlBucjhxZnZITjNGMVNTcUlPUHVQcVE4YWZHWnRwRHFyYVVCbC83?=
 =?utf-8?B?L1VqQjhiMGxWVnloT1ZmdTlDOVdQcVRhYnhpMEJpeUhhdU5reVJSek1uWUNi?=
 =?utf-8?B?N1RqMzY1VDRhQk5yRDNnZGhBb2p3bDBDVEQ0c0RUVVlLS05oa3FwN0I0M1Bq?=
 =?utf-8?B?SHRvZklQaVVPTG90RFU3RU5qa0FGMzdRTGZQNGlnQTMwZ1Nhb3JTNmttcjl4?=
 =?utf-8?B?aFFmSnZGZUlOTWV2V1prTFJrRmRxMHVSNnUxWHBwQkdGRjQ0Y0NnNmhoVHp5?=
 =?utf-8?B?bXNoajk5aERnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TE9JQlhnR2N4SkVEVTRVemxGSlUrL0xpbEJHd3R1UUJ5U2RoRmc4VzZvQXp4?=
 =?utf-8?B?UTVBMzhIT3RCT2pqcGVXLzR4YU5WN0wwZE9BR044M2V6QnFnblk0dkdrQm1h?=
 =?utf-8?B?cTVVaXdjSDFVT0VDZkZnakdwTGNOd2MzejVBNUVDeTBBNHhnM1U4MXRJTlBQ?=
 =?utf-8?B?VHRhRjNFSHZ2RlV1SXJkb1gyOWFJSHAzMngyVlJTamVnT3FKSzhHb0ROTWZp?=
 =?utf-8?B?dW1aMDJZSXNHTGt4ZTNVcEVsTituL1FrQmRYeE1mK255MlRuR0hYVnY2T05E?=
 =?utf-8?B?enZRMWZNNHFSTjVnV0dJRlFPaVFob2pEZG9WTmZMUldxcmtxbUVCL1NsOFhT?=
 =?utf-8?B?NloyV2g5K1J1R2hodUU4UWR6RVFpeGZQWW1VMU5MVFVtME45S2dScjdPQVlB?=
 =?utf-8?B?VEo3RzRlWWpDb1ZSbGRtalgvMm40Lys4TjdKUmFRL0swUmppVENQUDZxQ0N5?=
 =?utf-8?B?dkxzZzYyNk8xRDJuUFFVTk52SzR6aVkxY3NDQ0pNTFVIMVJEd3FaZDU1ZUUy?=
 =?utf-8?B?RWRMWUtDRkVNT1hYK2xnbVQvTmNoVnpTL1VVNmI5RlhxUkZPaHU3K2RVM1hl?=
 =?utf-8?B?MWY3WDFsb0FmMSt4a2ZzVlVEckU0dlJpUXhUSVVTdHRUOEt0Vy9qRjBOQXR1?=
 =?utf-8?B?dngycndUcGVGVTlVa09PL2RaWXlabWswUnhBS0xGT25VQnU2c0MrVEYzSkg1?=
 =?utf-8?B?cDJQbjlpcDFRcWlnWFRnNVNQMzRob244UDJ4TXhsWnN6T3NpUnYrY1ZaeU9n?=
 =?utf-8?B?VFRpQ1JVNXc5bTZ1NU5GN3lHZGo0K2tiVWhQbFh5ZzlHUTZIdEo0UldjT3p3?=
 =?utf-8?B?cEdOR2tSZjYwU3FlT2FPbGZ2eVpGaHlLTjRpOFBFL0hTTk5wVDhIR1g5UG1y?=
 =?utf-8?B?RmM5SnJER0cwdEJhM2w1VHZxRDJHYjRxQm5CNnhVMDBqcS9yQnI1Qk9lbTVp?=
 =?utf-8?B?Sit0QWp1YTIrMkR2OWJ6NDBEZHZ2VkxkUUgwdXR4SzZtRFRrTUlQWS8xem1K?=
 =?utf-8?B?WExNL3Q2bnQ4VTVNWWFyZDUrMjVjOUM0OEhNYWFYUHdkdC9ST00zTU5iSW5O?=
 =?utf-8?B?cFJQNk5INXJTL2QrSGZRa2p2L0hLaDN3WXcxbTA1eGxQWnlzMzhpdWxmVmlT?=
 =?utf-8?B?TzYyRENiTUVjejRTOU5WWHd1eTBpR3lCQnRUYlBDSHdycUVrVmJNWHpYWDho?=
 =?utf-8?B?cUN6ZWlvWm8ySHpiMVpKbVNyakxEWHB0alRHOTBxUk5ya1lSZzBpL0hWV2Rn?=
 =?utf-8?B?S0o4WksvOVFxWHpUbStORi83anlpdWlCS1Y0MzNaQTNnbDJLTlFQRHhYaVd4?=
 =?utf-8?B?QTBiZ2dPK1UxdVZRMTdsb0YyTnlHOEtrQjhQRUc1S1RZbHNEVjRFVmphaHVD?=
 =?utf-8?B?SS9MV2w1bVZEamRNR1UwZDJxSUEzd0pFYVhBZy96S0d5NGhpMEQzVmpPaFpU?=
 =?utf-8?B?b1JFZEtXUHVFUHU4WlpwSC8wd1VWOW9HaGx1aE5PejJScERIRTZrM1JWQXY2?=
 =?utf-8?B?U1NYb2U3aXNkRHFnV0poZlMydFI1b1pCMmNEa3dMOVBRVElaZ0dJTU5wWG1S?=
 =?utf-8?B?bGJtcXcvbzBnc3RpOWxENnIybkVsRWJnS2N5b0VDNzhTaHdsYXowMit5Nlpj?=
 =?utf-8?B?TnozaE1ESUkrKzlqUlVhT1F4TlgwN3ZXZXRRT3plZWhSNHp2ZndFQkZVOUp1?=
 =?utf-8?B?QU9TSmV6ZHJCWXZvNStSMXF4UjRoUno3SGxUMzQxYTlyWmFvMjdaVk5sRXBY?=
 =?utf-8?B?bHNpK0xBdWR6ZjJ2ZytsZndpK1UyNlprdHdYWUVNaWhwakdZSG5rSjg0cGZa?=
 =?utf-8?B?OExDdyswcXhQVUFlYU5DTjZzbXZjcG5USEtRb3ZGakJWTEluOFBYeHMxZDZ5?=
 =?utf-8?B?aW9aVjVzQTZ4dUhES080RlZGbEVkckY0RnNYQjZEaWliWUhjRVBSbzM4WVQ3?=
 =?utf-8?B?UklLeE15WkQwQ0FyQVVSRzNhZm1EcDkvTVB6Y2tMdWg3NFRXRFg2WjhZMGU0?=
 =?utf-8?B?T1pvK25wWGkzbU9OOERLMDcvRE01OElnTVJqdHRaN3pJMUE0anVBcmx2ajB2?=
 =?utf-8?B?TzRxK3BnRS9FVU5BdEZDcmsrT0RGem9nOC95TUpFcUF0ZzRRVUg0SVM1M3A3?=
 =?utf-8?B?NmhiTVg3TTAwQWpqNGUxUnNRSGY2OHcrY3p3N2ZwYXlDSE41cnNpbnJaMkgw?=
 =?utf-8?B?TVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5ACCE9515269324EBBC9F5BD78DE41E2@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 580a76b4-ba59-4714-ed2c-08ddf7543355
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 08:11:56.6997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VTxsn4J9m4SAAgzVexRrlkJL/iZNrVXLRY1erXyTQ+t+heNDPmPhJRcIJMFzp/RbdrOxUZsGQkp8jpgkCOTN9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7996

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDExOjMwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDkvMTgvMjUgMzozNiBBTSwgcGV0ZXIud2FuZ0BtZWRpYXRlay5jb23CoHdyb3RlOg0K
PiA+IENvcnJlY3QgY2xvY2sgc2NhbGluZyB3aXRoIFBNIFFvUyBkdXJpbmcgc3VzcGVuZCBhbmQg
cmVzdW1lLg0KPiA+IEVuc3VyZSBQTSBRb1MgaXMgcmVsZWFzZWQgZHVyaW5nIHN1c3BlbmQgaWYg
c2NhbGluZyB1cCBhbmQNCj4gPiByZS1hcHBsaWVkIGFmdGVyIHJlc3VtZS4gVGhpcyBwcmV2ZW50
cyBwZXJmb3JtYW5jZSBpc3N1ZXMNCj4gPiBhbmQgbWFpbnRhaW5zIHByb3BlciBwb3dlciBtYW5h
Z2VtZW50Lg0KPiANCj4gSXMgdGhpcyBpc3N1ZSByZWxhdGVkIGluIGFueSB3YXkgdG8gdGhlIE1l
ZGlhVGVrIFVGUyBob3N0IGRyaXZlcj8gSWYNCj4gbm90LCBwbGVhc2UgY2hhbmdlIHRoaXMgcGF0
Y2ggaW50byBhIHBhdGNoIGZvciB0aGUgVUZTIGNvcmUgZHJpdmVyDQo+IHN1Y2gNCj4gdGhhdCB0
aGlzIGlzc3VlIGlzIGZpeGVkIGZvciBhbGwgVUZTIGhvc3QgZHJpdmVycyBhdCBvbmNlLg0KPiAN
Cj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KDQpIaSBCYXJ0LA0KDQpZZXMsIHRoaXMgaXMgYSBN
ZWRpYVRlay1zcGVjaWZpYyB0ZXN0IHdoaWNoIGRpc2FibGVzIGNsb2NrIHNjYWxpbmcNCmFuZCBr
ZWVwcyB0aGUgcG93ZXIgbW9kZSBpbiBoaWdoIGdlYXIuDQpTbywgSSBkb24ndCB0aGluayB0aGlz
IHBhdGNoIHNob3VsZCBiZSBhcHBsaWVkIHRvIHRoZSB1ZnNoY2QgY29yZS4NCg0KVGhhbmtzLg0K
UGV0ZXINCg==
