Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0F52877D9
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 08:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758530505; cv=fail; b=qR3+AbDvSGm1zo1fJt/PMS84tch4Mp2FK11SXNerMVBKXDW8LqCak1rIppQMpk62TLu/mmb2WEf77mciXpI9QBUJ/JAMdGOaqmxa6DD0W4sP7iP5H73/+PnGfgT9MdIl5L4S+G09iuznpoNVGY2RlUp4q6EOStHpWABcLNU5Leg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758530505; c=relaxed/simple;
	bh=L4Y6Q7Z4Og6lKv0NodrW6hWrKvBAp82Ps5EZc+MYric=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XRmkKno1wMt/uri+O5XBBKM9+MmxlwCL4JHXc6MTMTZA7gwe8YVp3YmlCO3P8xsw4qashrcoD+I0eM7fiemCUPAoj93rnK98OrMLIhYtwFtw7eDVDhumhWV4hmWRoqx7+8orqyGDxxl1f4g2l0LDGzCzB9SXHgF4cSYoHtVanmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EavLmHtJ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=gLRiSUL9; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EavLmHtJ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="gLRiSUL9"
X-UUID: f485d4a6978f11f0b33aeb1e7f16c2b6-20250922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=L4Y6Q7Z4Og6lKv0NodrW6hWrKvBAp82Ps5EZc+MYric=;
	b=EavLmHtJ2s+6GBKzer9dqyhRro6hE7G9h9lIo7BOrVGD7ctNEP6b1zRe18GGtVXheS/+3+QuPC7aRdeg3y4lyb5L3Vnq7m449Mk+ekAG1Cwbfm+znOIz+1V5mbN9QYbKh9pa+tG8tLFSMD3X5BHxns2nCIs85j20O4fzhGig0Qc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:9721e1c0-bd13-4cb0-ae54-5f1f8ead99e3,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:fa02d06c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f485d4a6978f11f0b33aeb1e7f16c2b6-20250922
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 171675860; Mon, 22 Sep 2025 16:41:38 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 22 Sep 2025 16:41:36 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Mon, 22 Sep 2025 16:41:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R7FAb5ueXaNtunPppH86L7suwIkySRmeuODwoA1ZjCxXal/ZhhFTEMz/Reo6o1atN3yeIOTP1EygkDikYYNcn8QJTVuE/ZSGp7orWAVxVrXuSnVKT4a5jW9TtZBGmRejfjXaQTLA6V4eBxsWrY21WK0wdP0P8dyMHKE4q3ED8V5cgDglKd4tcN+zhuQTz4tkMQtwO6mPLnrK7wCmMIyVJJAHW4lYuDyZJwbRpnrbiQKAc+tlU53/XwpdVe1V/NkYqLK5hfmBlEUXLay6nyI4Cux8+GAsyaFzonqqsNLBsgyBNtxNT76rCQWP9upnKdSxXa7GnyWj2S/nBzaYjrBFHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L4Y6Q7Z4Og6lKv0NodrW6hWrKvBAp82Ps5EZc+MYric=;
 b=jXfLWSYQn3q3hY7i6DPSa1X+JCXLzrCd2twFgz12Eb8qytJKdKgYSeNg7REETYqWgNvksEwPJ1YufPs/uYEFLKKAqN0TS8NKEaxCJnT0ujCAMeWpN0AGMyUDpM66nrn49C+KbfiTqt8oMvAtaN45Ojdw5qhY2jD00pltstYx7vfMIERgQExFdaltACiSe+i7Bm6e4OUhFqQKl2EP6LTvRVs5DZaZd//umVvJkRNpW9jdjqGK39GSu/Z96KqmpK/tevy2FnBbsV7yZQY46UOBRFeyDa5hpBg5r1lv2lNtZ0R38T+XymNFwOUmXEZT2bOs39Ji7j6GLYwAx9aWJA5V4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L4Y6Q7Z4Og6lKv0NodrW6hWrKvBAp82Ps5EZc+MYric=;
 b=gLRiSUL9j027WtlHfPHvBwd/vkMzd7JkBtCakuTeYxzIHdWyy1Tgagh1GNpICej0oh333KmRpsLh3Q0XdrblL2gRwXKLvJ/vQcbJKismGNouMDFu1xBoMZpTKRzlMxGjB1RYGSJImI+IRDL4jtt8ve8+YF1kBV5CsnYcV6dHI/8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6883.apcprd03.prod.outlook.com (2603:1096:400:266::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 08:41:34 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.015; Mon, 22 Sep 2025
 08:41:34 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
Subject: Re: [PATCH v1 06/10] ufs: host: mediatek: Enable interrupts for MCQ
 mode
Thread-Topic: [PATCH v1 06/10] ufs: host: mediatek: Enable interrupts for MCQ
 mode
Thread-Index: AQHcKIiyg6scP6qY1kauuFd5GClYQbSZRI8AgADlVACAANhogIAD5gmA
Date: Mon, 22 Sep 2025 08:41:34 +0000
Message-ID: <9b09e799df468f2fe33bd9acab6d2487d0539e7e.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-7-peter.wang@mediatek.com>
	 <5ae6134f-6e41-4453-b11f-4e3eb92a1c04@acm.org>
	 <beda693842394d162c95d5523eb90373fd975d3c.camel@mediatek.com>
	 <3d2a98e0-03d3-4b7b-816c-581d77551598@acm.org>
In-Reply-To: <3d2a98e0-03d3-4b7b-816c-581d77551598@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6883:EE_
x-ms-office365-filtering-correlation-id: 11b110c8-e911-442b-e3e2-08ddf9b3d611
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eG9iL25DSWRGU0lYbkZPMWhTWEM5ZUZ3d3ZtSGFJT0krZlFpMVJ2ZWxvOEZi?=
 =?utf-8?B?QXZMSlVxWW1SZWN0T1BxczdxcUNVYytuNnNYdzVmdFlFQ3NTNFp5cDBrS3Fs?=
 =?utf-8?B?Wll5NDVsREtnQXNNWXIweUdRNmI5cnpGZVZvdnJDQkJxa0Vpa05uTHMrQ1RJ?=
 =?utf-8?B?eXBxcEdYcDRJdE4rRFkxT1JnN0J5aU05MzBsK25kcnFtWjNITVl6SEllYTZH?=
 =?utf-8?B?V0RxU2tNbVRPOEtnSy9yVHhUTVpmNlhKNDluWXV4a0tNQ2RsVUxTUXp2S080?=
 =?utf-8?B?UWVUQzRQZEd0MWFxemlnRjM5eTB3M1g5YVdGS2lDQU5uRXVVVFB6N2RsUmp1?=
 =?utf-8?B?bnhhNXdIRWpVM016VkovQ0pOK1M5Z1FoZmlsTnQ4aGExRWJsSmRRcVVIaWJR?=
 =?utf-8?B?U3RuYTFhU2tsQlNDaCt4MWNpcTNDeFc3TytHZkxha0hXWFVsUUxCVTYrZytw?=
 =?utf-8?B?NnhzS2txakUyQ0VCTzZaRjc4T1FjY1JoVFJPdDVvUnVyZHQzSDVuR2phRlhC?=
 =?utf-8?B?OTJ2azU1OHdNdzJBNkRhNi9aMTF1MDhZYll6NkZCN3IvajB1VklIWTA1eHRz?=
 =?utf-8?B?a2NUMnYvaHJmK2luUDdpYkhKUzFuWHF4TENtZ1BNd0IxOS9GcVVUSFNReFNQ?=
 =?utf-8?B?Smg2TnRYWUkrU3N2WFhRbmZlV0tQRzlWREhKSDVZWlhOQ2NxV1FvRkluTTJh?=
 =?utf-8?B?WXZ6WWdORS9YTG9HNkF5TXNZSVpLVTZsaTJoTkhYV1ZsL29zbUJoa1BqZXh1?=
 =?utf-8?B?T3QrT05lRyt5cm5iMzIwR1B5cGtSZTh3OHdUNjVXWCtKeUFoWEtOdWZ2cDQw?=
 =?utf-8?B?UlVYYUtGU0l2M3hZeHdFTThlRCtYWU5IRCsyY0JRSVRjK3R0S0lzc2lFVUxt?=
 =?utf-8?B?aDZKVkhUMVRWYWk4clRpWTJYQTAxMUNUbGZrN0ZjUHZnOG5KMVl0VmIrNXZO?=
 =?utf-8?B?ajVQV3d4RXkzakhOY3NJTitSQys2VS9aVGZ4cm84clZsMU1FbDJmSlpTdUhI?=
 =?utf-8?B?K2o4d0l2TmNiT002bEJteWxSaDYzS2d4ZEQ3Vm80Yk4zT3M3cytiTHF2VXR5?=
 =?utf-8?B?T2Nrd0ZyME5MK0xqNVZJSDFpUm4vR1JzZEl6a2NpOHdTcVhHOTRIYWRwV0ND?=
 =?utf-8?B?ckF0ZDBCVVpjTm4yNHVscGJNdWh3a1RuSzBuY09IOW9TNWFWTXdUelpQck5O?=
 =?utf-8?B?VStHUHVsa3doVkZpZjhiWVZHd0VuSEZtdElTd3NTZWFlVW5LdEZVNkpPdDZj?=
 =?utf-8?B?ZkNQS0cyeVEzNzdZQmZadmV1QU4vWUVINmNnRlFLQjhiMTB6VFlCRlN6aWFn?=
 =?utf-8?B?emlxbjJUTHRkTUJpTU1vNFdxVUR6UzVaZ0R1dm5pUWk4SmV4anRNQmRsZS8x?=
 =?utf-8?B?SU5BcXJlYjJWVnpvWUl3NXgvQnJBWkV5Y2wxVFE3UUNvUDdGVmtYQmpsYVlv?=
 =?utf-8?B?M2g5bFRYQXpLR3g5TzJyT1UyV0tXY3BRL3lQdWlRdytURTlsa0xWQmRldmF4?=
 =?utf-8?B?SFV6OEY5R3BiN3BSMXh4aFpuaU0vN09JaktRRHZ1VDF4QlBLVXo3a3IvSFoz?=
 =?utf-8?B?dlpjS204aG43RkZ0K2c5c2NJNTUvZlFDUVNTT3dZR0kvemxVRmt4U1RBNTk5?=
 =?utf-8?B?L3RMTHhIVFFYUGtaRFJ5MzFNbmtMM3lvOGdvQTBBaGxYQ0E4c2xVdFU3bFNT?=
 =?utf-8?B?NkxyeFpoOUtSV1A2MUNaT29rdEkwelQxYmtPTzRka2dZWXE5WGdEZ1hRQi9m?=
 =?utf-8?B?dzdjbE05Q0RLYzBrRVFkajRTZDJIMGxTUHp1TGE5QlQ3eVVwUVM2T0hRSWtR?=
 =?utf-8?B?WWhrL0NuSDhCQnZRRDBLMWtLQ0hBVXI0S3dRUksxa2VLTmwvamFRbEJVcnQw?=
 =?utf-8?B?VXJzbDJXbUxVSTV2Q0Z5aThoU3lZdlB5NUhxUTNTZm5yNGpmNHZnbHY5Nk9N?=
 =?utf-8?B?WU5pemIzZmRMaUdTZmt0TGdKajREbXovMUdCeGpjL0htd2NSelJ5cDVqQnBE?=
 =?utf-8?Q?dT+eA7NceKag41LGfw/4zAR6yGIHyE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzFpYnVuTitHcTArOFhwVzI5bEJDQ1pWRWVEbDN6UVFoaTlIcmlPMXZOcHov?=
 =?utf-8?B?L2hRRjZPcDNmZEo3bXNUelZaSE1XOTlXbHQ4UHMxSkdqWWhZUHZMeVQreHhv?=
 =?utf-8?B?MnZHNVppMWx6aTNES1lmajN3S1FVK2JOTVhndHZOWHdoWnRHdWMvZERwZmVm?=
 =?utf-8?B?bG9INURHSzlZM1Q2OFVFUVdqQTlVdXhwV1Z5S1BmdklDV01VNWxCRi9Famxt?=
 =?utf-8?B?Z3ZWdTNhZFVwNVJWbFlpMDcwaUdwcEt3YzJCbFEwNmVBNjFEV3VaMm5JdFlU?=
 =?utf-8?B?MC8vRDJJVUJuTllMTWo0bHpVbzF3WTUrbG1IMHNvelpVRi9FWHM0WFdkekVw?=
 =?utf-8?B?YUdKVjExbGorcE1rOWkrbDc5N2JtdjNaSHBEaCtOSm8wRmliYmpKbHFXSnJN?=
 =?utf-8?B?bWY5RUM5RVpzM1hHSlFwWXd6ZFBScnk1Y1U5T3JkZlBXQkxXdWMyVGgwSDRE?=
 =?utf-8?B?bEhLQ09DS29jSWdha3pNQnJSTGp6ekV6U0ZoQlRWRi94ZnJYUmRCajJXelBz?=
 =?utf-8?B?S0lmemFmZXJNOFJjYnNIMUlPRVFUVDN1eDVlOWRFN1dGbUN2QzFXMFZIelVS?=
 =?utf-8?B?OEpTSjYxNzltKzMxa2Irb0hNb0hpakI0OE5razl4b0o1UW1YN3ZNWDUrWkox?=
 =?utf-8?B?SHY3QThTcm1QRmtFV0czRFVkdExYQ2NCZUdKeXAwRHljMTFhb1JXdDJmZ1Zn?=
 =?utf-8?B?WGNKczVxdHZQVHdEWXNWbUt1ditmM2RJQjJhekdiUFE5d1h6TTduQ3RYbGpG?=
 =?utf-8?B?c1JPc2E1alllUDU5aDVUWjRJSkw3b0F1Skd6MGdIZVcyang4K0krL1BlekN5?=
 =?utf-8?B?VVp2VFJyTkFqa3hMQkRNL0EvemNaZGdnTUZEL3pMM3p2MEdUT3NndkcrajVG?=
 =?utf-8?B?cytOUjhrSzVnV2tDSjkrclVmUC9oWTdlaElrWDA1WnYzUDVxV2krdmlZM1h5?=
 =?utf-8?B?N05meWFYTmlWWEY3N0ZrYVl2MUUyTUpPRUI1cnZBU0J0dURuWDVzUmxtME00?=
 =?utf-8?B?OUV1SHhDbWVmc1AxNGlEcVozMVgyVTlmUkwzNjdTaVQrOXk1T25uT3NhOEFv?=
 =?utf-8?B?ZkoweFpMUXVURzBEYTFyZ0RPZzFvRWdGYXJCL0JpTjV2WlVxOW5RbW5oc3Er?=
 =?utf-8?B?MEduMU90d0Nyd1Q2MWhJcHcvNVFVWjBWUG5pbDJYb2VDL284MUVtVEgzdjl5?=
 =?utf-8?B?clY4RWw3WWxXSW1XSTdRSDZ5dlFUWlk1eFpMVCtwUGFKMzZ6WVg3S0tOWkZs?=
 =?utf-8?B?R2xLQnQvVmI3bFhXVWtzTmMxdEtlcXR2YkpNZTJrVnQxMm9IbCtRYVZpUlAr?=
 =?utf-8?B?STNvTkkwcFBxT2o2MDBBWHQwZWZLdHViR3VZcFhmSHY2d2FLTGhBU2I4L29k?=
 =?utf-8?B?K1ZybXp1KzVpdHpUOGh6Vlp3cW92QmZDVUtmY0lhbUx5OUgycVh0TGFzWmZu?=
 =?utf-8?B?b28xeFp5ZFNjWFc2ZUt4enQ2YnFLYkoxMk5ZNGlkTkZ1NnF5Wkl5a3lLdHJO?=
 =?utf-8?B?aUhqVjZpSG9qTE82MWhyczkxcUs3dzhFRE5xWU1Pb3lDYlZvNS9VOGJUS0Z0?=
 =?utf-8?B?KzJYdmgvYVFBZ2FXd2tzaTJWczg0R0E1WFJ0Y3dicSt2WXpCckRBaXRLdHpX?=
 =?utf-8?B?dlRTdHVTeGJSVXRUNWFrTHdsNXpsUGVzUzZvSUFkQ011VDRjQVJmT21aUlFG?=
 =?utf-8?B?TEVBRVRDbFRzMU5SZzRGQzQ1TjRpVDhBZzByQVFsOTF1THRqV2dMUTNxS1pC?=
 =?utf-8?B?K2dzVVRzemVWREUvWE9PQTZvSHcxampqMTlRakFuZ0RiNHRkSkU5RzJqVUVp?=
 =?utf-8?B?QVM0U2ZKT1dzdzNVTDQ5dVpHQTN4ZGNWMTJCNlZlVU5KWDBkckpWM3I5S1NE?=
 =?utf-8?B?cDJIRXg4bnVsV2ZFNlJJcWZMb3ZoMjBuMGtvUnY2ZUVlaTgza0FrbFV5Mmdu?=
 =?utf-8?B?NnVnZ3ltTnJySHAzUGZyaWxOc2diRlNsUGkyQjlRK1g5RkRzVkFDVEFtbFlx?=
 =?utf-8?B?NjFoYTVNVmlnM2tsWVMwQ2FuM25LRlFiWWdtSnRTU2dSaHZ5eE8vTHo3NDlm?=
 =?utf-8?B?YWZzT3dDMHlJMG5LMENnYzBtTzFSUnNodlFNVWlmUGZyQmxaTVFvT2QrMWRE?=
 =?utf-8?B?YnZMdlBUOXp5aG8vMmNlOXJpQ0ZEUUtBYjNSdkVGMFNTOStraVVOK1lENklu?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFF24A83DDC5C742B95F46AB3461E31B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b110c8-e911-442b-e3e2-08ddf9b3d611
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2025 08:41:34.2047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: temnkSJ7zRFv9oH2qlKxgHjbDIR6tdDekh8y2QFXaV6zec7MBpq2l9eDbm9kUjUSkbHXPWZO9QzYtWOCVKZ+AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6883

T24gRnJpLCAyMDI1LTA5LTE5IGF0IDE0OjA5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBIYXZpbmcgdGFrZW4gYSBjbG9zZXIgbG9vayBhdCB0aGlzIHBhdGNoLCB0aGUgb25s
eSByZWFzb24gSSBjYW4gdGhpbmsNCj4gb2YNCj4gd2h5IGludGVycnVwdHMgYXJlIHJlLWVuYWJs
ZWQgZnJvbSBhIC5yZXN1bWUgY2FsbGJhY2sgaXMgYSB3b3JrYXJvdW5kDQo+IGZvciBhIGNvbnRy
b2xsZXIgYnVnLiBQbGVhc2UgY29uc2lkZXIgYWRkaW5nIGEgcXVpcmsgYW5kIG1vdmluZyB0aGUN
Cj4gY29kZQ0KPiB0aGF0IHJlZW5hYmxlcyBpbnRlcnJ1cHRzIGludG8gdGhlIFVGU0hDSSBjb3Jl
IGluc3RlYWQgb2YgZXhwb3J0aW5nDQo+IHRoZQ0KPiB1ZnNoY2RfZW5hYmxlX2ludHIoKSBmdW5j
dGlvbi4gSSdtIGNvbmNlcm5lZCB0aGF0IGV4cG9ydGluZw0KPiB1ZnNoY2RfZW5hYmxlX2ludHIo
KSB3b3VsZCBtYWtlIHRoZSBVRlNIQ0kgZHJpdmVyIG11Y2ggaGFyZGVyIHRvDQo+IG1haW50YWlu
IHRoYW4gbmVjZXNzYXJ5LCBlc3BlY2lhbGx5IGlmIHRoaXMgd291bGQgbGVhZCB0byBjb25jdXJy
ZW50DQo+IHdyaXRlcyB0byB0aGUgUkVHX0lOVEVSUlVQVF9FTkFCTEUgcmVnaXN0ZXIuDQo+IA0K
PiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpJZiBpdCB3ZXJlIGEgYnVnLCBJ
IHdvdWxkIHNheSBpdOKAmXMgYSBNZWRpYVRlayBTb0MgbGltaXRhdGlvbiA6KQ0KQnV0IGl04oCZ
cyBkZWZpbml0ZWx5IG5vdCBhIGJ1ZyBvciBhIGxpbWl0YXRpb24uDQpIb25lc3RseSwgaXTigJlz
IG91ciBsb3cgcG93ZXIgdGVjaG5vbG9neSwgd2hpY2ggcmVxdWlyZXMgYSANCnNvZnR3YXJlIGZs
b3cgdG8gcmUtZW5hYmxlIElSUSBhZnRlciByZXN1bWUuDQoNClNvLCBtYXliZSByZS1lbmFibGlu
ZyBNQ1EgSVJRcyB0aGUgc2FtZSB3YXkgYXMgbGVnYWN5IElSUXMgDQppbiB1ZnNoY2RfbWFrZV9o
YmFfb3BlcmF0aW9uYWwgd291bGQgYmUgYmV0dGVyLg0KV2hhdCBkbyB5b3UgdGhpbms/IGxpa2Ug
YmVsb3cgcGF0Y2gNCg0KQEAgLTM1NSw5ICszNTUsMTUgQEAgRVhQT1JUX1NZTUJPTF9HUEwodWZz
aGNkX21jcV9wb2xsX2NxZV9sb2NrKTsNCiB2b2lkIHVmc2hjZF9tY3FfbWFrZV9xdWV1ZXNfb3Bl
cmF0aW9uYWwoc3RydWN0IHVmc19oYmEgKmhiYSkNCiB7DQogICAgICAgIHN0cnVjdCB1ZnNfaHdf
cXVldWUgKmh3cTsNCisgICAgICAgdTMyIGludHJzOw0KICAgICAgICB1MTYgcXNpemU7DQogICAg
ICAgIGludCBpOw0KDQorICAgICAgIGludHJzID0gVUZTSENEX0VOQUJMRV9NQ1FfSU5UUlM7DQor
ICAgICAgIGlmIChoYmEtPnF1aXJrcyAmIFVGU0hDRF9RVUlSS19NQ1FfQlJPS0VOX0lOVFIpDQor
ICAgICAgICAgICAgICAgaW50cnMgJj0gfk1DUV9DUV9FVkVOVF9TVEFUVVM7DQorICAgICAgIHVm
c2hjZF9lbmFibGVfaW50cihoYmEsIGludHJzKTsNCisNCiAgICAgICAgZm9yIChpID0gMDsgaSA8
IGhiYS0+bnJfaHdfcXVldWVzOyBpKyspIHsNCg0KVGhhbnNrLg0KUGV0ZXINCg0KDQoNCg0K
