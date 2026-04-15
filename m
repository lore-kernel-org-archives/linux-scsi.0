Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0DA320CD1
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 02:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776220824; cv=fail; b=ivSZ2jinYjSVenH5kJN61gC7qqmQJQ3PJsyl2r4u1cCfwESYAdRl20wJCY1DT2zWsnfiLe7EKUtCTA45SRu+P5FKbLW1G669VPYuXjx33eYxu/G4WpIX7qLmy4C+UL6Fy8tWqakvWEEhCBqjA3zOxCiIFRFxe3oEg9cP4re2UJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776220824; c=relaxed/simple;
	bh=N98dDN6ZjIlz6xzIMDRqMLM2N1XI/ZSIMzViikWgXxw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZnVdQLim7ZjSWdzjcL8BTEFBmHx8XyuVb1LVYZaS8yd9FztM9BtwoBnLoljgoxmkoyLg0GAdGyq/QNUtDh4xIv8/4/ULHa7a9O3dSZP1bUcYvo3FJ5HWYQihrtw5V4gnOGgRhT9vs1wqsSxNZ+z6HFdTAPLhM+HtJmSVVftmsgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=eytJmDIX; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=mdsmwZsU; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="eytJmDIX";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="mdsmwZsU"
X-UUID: 6fcde1c8387411f19a16598d5ca7f8ec-20260415
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=N98dDN6ZjIlz6xzIMDRqMLM2N1XI/ZSIMzViikWgXxw=;
	b=eytJmDIXb+Fqk/CmJPi7EYmSMG/wDKld5vmyuBJ9AUMRQUnmh59MSOVzM+O1EdCL6p8tUv+wUfOqRBnF121BZphitcxqcOlVuF5Wxb3KY3tGtzFRUkEt5jNMOkwiT0trdh1C4jqeOcwjGTewkTrLKa8fWtL/oH8nXJcQI9ecLWw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:fdb9d6c0-145e-4f4b-9afe-08b29172b56b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:4148f294-f8ef-4ca8-bea0-143568f9ca1d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6fcde1c8387411f19a16598d5ca7f8ec-20260415
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 18686060; Wed, 15 Apr 2026 10:40:16 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 15 Apr 2026 10:40:15 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 15 Apr 2026 10:40:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sUiu3+CdinLvbqKESLvNzuEN7gy+AULAYcJs9Tvh5Ede4FcXQP5tzAFHbg6OHHYTDFTdCFols9qp8ipJJffvg88f4y8VuG+XRREWnDWC4rEf8Etu2l71CQldvmEsrNDgnhTra5cW+Rw7uJ3KrHS/Y0HWLfOeMDXrYZlMInGVM3SacDM74jAajcpEqgj+JUmTn9Zsj+4y7yF5h+Q56FHNQlRmNBeKvHgvOkSdBCYXWQoN6qPiy2JLQiKRqnnLAGfFwlAXouWgMyN5qH1BAVO2vFJarxPAuuLhNKboXRfXDAlYSrrAZPnF/HqcBL+RPvSeCX8FYHvkUF99lRsWuZ7wIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N98dDN6ZjIlz6xzIMDRqMLM2N1XI/ZSIMzViikWgXxw=;
 b=nMBIhoWwZYBAoWcP6i9JoxeKF0HYW6gJzept3Ya+Rk+QyWxjX+5uFCq0OokXtcCmlGG4WIYInNvRA0lkKM/NYyQKYB8sv48aNuOKMYexDW+sBoqCn0+ABUOgibDJw9d0vHb1Z5s6HVDp9zv/+XakXA0Yp4RASc9byD7RQGcVDkqTGgCcrErEAnsHNo6PdJco1ZGcOkQMNk7o1hoeBuIJcOdHoCzvXmHZNEp6AH21gJjffQm+wrVzPLLYrvEfXHhp1iCfrycmmaeu+HWMGHO2aRMdDEsxThLrTvqqQFzSTJ06cvsUIgagom33hhCzfNSqcePykxj/uXaDESznuv9axQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N98dDN6ZjIlz6xzIMDRqMLM2N1XI/ZSIMzViikWgXxw=;
 b=mdsmwZsUJdF6lWPKJhk/5fn3UiWgonctKuIcix6Lkti8L4GRKIjanw0HLC/Av5WEYCqTShw7UJrsSJzHQuF4L6bhkfmcIWnWzPwTTPBqxAVbug0roWDd6RnjlIdHM2aHMW6E0aPUIeksqGFwx/gQgb+npXuFm5bhccxdN0tLah8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB8320.apcprd03.prod.outlook.com (2603:1096:820:10e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.48; Wed, 15 Apr
 2026 02:40:12 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.20.9769.046; Wed, 15 Apr 2026
 02:40:11 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "avri.altman@wdc.com" <avri.altman@wdc.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "wangshuaiwei1@xiaomi.com" <wangshuaiwei1@xiaomi.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"wanghui33@xiaomi.com" <wanghui33@xiaomi.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Fix bRefClkFreq write failure in
 HS-LSS mode
Thread-Topic: [PATCH v2] scsi: ufs: core: Fix bRefClkFreq write failure in
 HS-LSS mode
Thread-Index: AQHcy+UeJLKkISj7AUetrem9wS2kJLXfapAA
Date: Wed, 15 Apr 2026 02:40:11 +0000
Message-ID: <d72f1e542e1a3fa4cea13cf0a9fd5fcd73cbad58.camel@mediatek.com>
References: <1776153767068194.12.seg@mailgw02.mediatek.com>
In-Reply-To: <1776153767068194.12.seg@mailgw02.mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB8320:EE_
x-ms-office365-filtering-correlation-id: 1d446564-7487-43b4-9706-08de9a985116
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|38070700021|22082099003|56012099003;
x-microsoft-antispam-message-info: Lnn1e0gayLW3ZLA8Vvpvhhrvv7TskECL+huO8Z2wluSCQObFnwbXw//Nwm+1WVmDSvt8XOc1iFyZAY4MB1DduBLuO2t/9juN869kM5gqjcUzjYgp0zEOg1KYg/VTuA+Sj4FlLzilE1+OfgSUgBQJOb/QccseXGTlVQkRtSNlkjP1M3vpfCUiPt9nZRZOXcnAvZjkMXoPDzKc0fnu1mgy8mkGJLgEGYit/zbcN6pJ2tw67ResulZbszkzWa+9h8g7jAfbRFLgvXYCSjoSS1/+afbvs97/p/4eVziw42/WLWU7g+mjnIcTM1+8D/vuHA4EPLUrrWLmMxm9Lg/di70Qgo1QCcjjSoyGbhCjPGOdfiZDapePPjJ2Inj8kAVWpnsy5YaBV3Gvtn9vVj6OSFL02MCxj/aT/I0D0I7OLpL5guVulsJylI/dSjkpmQxdCQImjFSbKrr95x8kRumkaQcCXHfYEcS38e1H83+xys8VOJn0MiTwQ244gyerJ21ujwmjtEF5malkVP5F1vLdpAlfk6PiGPK/jct3sr8bf85/u572M4WgI6HOaVmIRuSjYHOlMC0AesBvcgDAIjQfXWaEVGGrN7VXC5DQ0bS9LbGwWPQwnazX3mxQa2wp4M+ANW88h7Cz0NysoqIcH4VNJqj6osLoSCOndV9uZ1ogV0p+GrbqHRW+ZV3To/4V06PRw58FoPLhLOesL7ale7RF1qjxazhDrvjs4ef9E/XJDg88eu7hEzwdr7vWhE74u2N6b7BZGUmoEUy4sVGanSPy2/eE9wDWLJSeTRPuuTIw9VXfjrU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(38070700021)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXVMNE82bjMvS3hUSVN2QUpLbUxiQXJKQXpqczFuaVNZZXBWWm9xZHRhWmFT?=
 =?utf-8?B?NytCaGlEczN2SmJ3WXZhYjdWWkdmLzVLYTllWGF5V1ZRZ0liUXdNcXNNUWRF?=
 =?utf-8?B?bW8zTTQrMFVzR2VXSHRlbmxGZDdJTm9qK0JDamxKQ0NtNVVkRlE5SEcxd3I3?=
 =?utf-8?B?S3JrdEk1TzgwTm9IZmZJN2NYOUYzQWdsYlNIc2NWdGEydHFVS1ZRK2ZNNE1F?=
 =?utf-8?B?d3VMR2xhdG1yUWNCZ3FUSzFWRHVOcVR1WjhCQzBKT3RKRnR0REtUT0pkV1Zv?=
 =?utf-8?B?ckU3aHBPL2dkc2tZdVNsd2NOSGVSOW5kVXh0d0gyWkRSbDRxNGZkL3JHdVlQ?=
 =?utf-8?B?SDFIY3Jxbzd3bEF4cnRPdzJNQklicVoyNHQ2bW1DN0pkMW5VSE1SeFVRTzV5?=
 =?utf-8?B?WlFsa0RxUlExeG1ZbXdlMmx6OWdqK2pCbVJiMm43WUVjam1RVEtydHp0ZW90?=
 =?utf-8?B?dUZVdFp5NXRMbHU3VlBqTU5iZmdnckdsVDZvMm5LQzVvYzhjbXZqdzdQSmZX?=
 =?utf-8?B?YWRDUmNKUElYU25SdFl1VVBBc0xWSUVhRzIzanVhMGFSM1NLbVZXMXRmYnM4?=
 =?utf-8?B?UTIzZXFGdDdIMGVKRFNITUg4OUVNZi8xNDBkWkNROEdhYjIwZ0Q3Tmc4TE1y?=
 =?utf-8?B?RmhBdW0xelRlZm5qK25xbVhRQmIxZ3RmK2pTWXFsNjFabVcxQnU0K1pqc3oy?=
 =?utf-8?B?WnBpUFFFRlFvc2xVcWNGdnNNUmM0eHZzclIxczd1QnFSR1d3c1h4b0ZLOEFq?=
 =?utf-8?B?S1kxOUJUSGpYN2xWdWlEb3piU0RuYnpFRGtnTjB3OXM0WGFNN0N1WVZ1T3gv?=
 =?utf-8?B?UC9KUE1Gd3c4V2J1a1BjaFNmSjZzTWRHUEtzNTFCV1FZVDdLU1VNek85ekVj?=
 =?utf-8?B?a1d1UU5CQzJQejZsSVJUQmI2RXpQb2Iwb1Zabi9xMGhMZVBvWDlQQmwyZE5Q?=
 =?utf-8?B?dlBIbXlabDR5RmZpMkFQaER0YjlHWStkWUlVWUJiaUdpbU1YOHhaaGZPQ3Nu?=
 =?utf-8?B?S1JKWkJpM1JoV1hWeTVFYytBVnZEcThGTzRVNHdLbTUyQWI0UldTdHdNc1Az?=
 =?utf-8?B?SkNlVWFnWEQ4Q3dpK09nR25qMmlhNGtJMlJRbnJLZmVnRitZaHYzS21Wanp1?=
 =?utf-8?B?bFBNV3pBRlo4ZnF5WDYzbGg4cEYwaDJPT0lDWFZlMFUrbzExTkExK3dXYys0?=
 =?utf-8?B?SkpVbExPVmN1YWJ1VUpHdmR3dHc2TkFKNjV0OFU1QWNQL0RnSmphMmpTQWZn?=
 =?utf-8?B?amRqeWlUTHhvM1MvdDRtTHVqVHQ1azZpSFp1a3Q0Tkt6WEEyQzhHcmlkUTRj?=
 =?utf-8?B?M2Y3NWdVQ2lMWlAyMWI3Tk5taHBFQmgxeUJLd2dMQkF0VEoyc0ovYmU2RGg4?=
 =?utf-8?B?WWdNN25kUUtyOXpUL01xejNFY0ZIVmdDQ2dleEE2YUI3WmRUS0Zzb1YySFZZ?=
 =?utf-8?B?ZXV5ZzdXYUljK3R3cloydDZ5SUJ3UWV1TDliWHBPbGM5MVl4a0RYNDRnRDI4?=
 =?utf-8?B?Y0tnK0FQY2tpK3pqeFdhMnZNSWs2N0tvMEt2VlNNMkxUREkwUnVQeStpRnRo?=
 =?utf-8?B?MnJ0dGJaLy96RnFzbkNTbmlkWjYybUZpUEZEVHpibFE5aUpFWGtSbmVUSFFB?=
 =?utf-8?B?aC9velZCQkNIT2xJNnMwRFZSZ3g1MWprUzZ5UDYySXY0U1RHQzg0a1ZkQmxh?=
 =?utf-8?B?UHUzRmZGazhlUnBmTFZjK3kvL3NnbUNxU2JOcFpDbTNCc0VsY0RBRGlPbW9m?=
 =?utf-8?B?bDdrM3JORzhvYmRJSFFRclYrZngraFFrSHpwV1ZJd1JrTEVia2dEb3V0MEFq?=
 =?utf-8?B?ekRZZzlDOFQ3N1VXeDZTbkFOaU0zaXRBd3QvYmtyd3YwYUdhUFJSSzFoUXUy?=
 =?utf-8?B?ckh4UVluUzZJaW5kY1pVZXJNZUdEbjk2TndDUzkrMzE2dGJSc0dCL2RPM0NS?=
 =?utf-8?B?TmxPVmlMTTlrZUw3NVFUb3Q3QTJETzBPRmphOTYwUmdkSExrTUlVMXNhaHdn?=
 =?utf-8?B?c2Rhby81eFppTGNGYmRteVBjSUY5NkUwV0Y3R0EzQ1VoTHdFSEhMZWlkT2Fu?=
 =?utf-8?B?dnlmc0RkWlNVZjVTVGdvZUFNeUVSTTJWUDBOQWFQR1BJMmJBTThZVHFGOEZF?=
 =?utf-8?B?cWhwS09TVHBaRmwweC9XcHQyVWI4bHpJQmpEbXlJT2o3M3puMW9YVUkya3Br?=
 =?utf-8?B?VGtNR2JyWDA3SXVJbG9tTnM3bjg3YTVud0hDc1VCYnlMdkJ6WXJkY1B4cVNN?=
 =?utf-8?B?VC81MjE5QkdibjAzdUltV1c4N2RmMW9HcktLM2R5dkQyM1dpaUJRZUJwWUFX?=
 =?utf-8?B?OXUrNnF3ZFZMMG1yUjc4N0t2WnYrRkNwMFNjMGNibC9lNXhBSmhMdUJMVFNJ?=
 =?utf-8?Q?dPqvQF6P1yg0f3EE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC5C9823E777D94EA4EAAD029FB9B626@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Vnk18xDbR2QZpS5rpNK/ZRthOUlSGdG0XW2CmbduR+DXrRdCNeTJge9n2YUwYpcmLGRnv9GHUVfBt4QkONMlsdbs0WyRY0JpxhoVLP25Y+cAwx9tQLIYQ6Usv60Ee0MLDj4hggkQve4ZPNmrXwqwqP74srHGfHoELobs+xkkt8VkYONIYaILfydFry8oxqVzL68sATpir2wLFv+Ez44AWc68b4Ldsnh3D1il/U1xC8APlk//nNFQurdfmXhpcJBfo75tmey4XBW8vTzUyM7MCU6x7CSd2aUqMPN4poJL633q76qkzCcE5KQikcyNGEkqVrQXgpkrqrpRhnqqXnnfsw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d446564-7487-43b4-9706-08de9a985116
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2026 02:40:11.8968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R74sZ2wrJSlwNy9yCEU1DKCi7pDgp6/yHxqYGyxMBwHkOOLVxp3Dp2IEIZUUD8H4sOLAm9L9z39Mfs2MBZGPGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB8320
X-MTK: N

T24gVHVlLCAyMDI2LTA0LTE0IGF0IDExOjM3ICswODAwLCBXYW5nIFNodWFpd2VpIHdyb3RlOg0K
PiBBY2NvcmRpbmcgdG8gdGhlIFVGUyBzcGVjLCB0aGUgYlJlZkNsa0ZyZXEgYXR0cmlidXRlIGNh
biBvbmx5IGJlDQo+IHdyaXR0ZW4NCj4gd2hlbiBib3RoIHN1Yi1saW5rcyBhcmUgaW4gTFMtTU9E
RS4gSG93ZXZlciwgaW4gSFMgTFNTIG1vZGUgd2l0aA0KPiByZXNldG1vZGUgPSBIU19NT0RFLCBp
ZiB0aGUgVUZTIGRldmljZSdzIGRlZmF1bHQgYlJlZkNsa0ZyZXEgdmFsdWUNCj4gZGlmZmVycyBm
cm9tIHRoZSBob3N0IGNvbnRyb2xsZXIncyBkZXZfcmVmX2Nsa19mcmVxIHNldHRpbmcsIHRoZQ0K
PiB3cml0ZSBvcGVyYXRpb24gd2lsbCBmYWlsLg0KPiANCj4gVG8gZml4IHRoaXMgaXNzdWUsIGlu
dHJvZHVjZSB1ZnNoY2RfZ2V0X29wX21vZGUoKSBmdW5jdGlvbiB0byBkZXRlY3QNCj4gdGhlIGN1
cnJlbnQgbGluayBvcGVyYXRpb25hbCBtb2RlLiBDYWxsIHVmc2hjZF9zZXRfZGV2X3JlZl9jbGso
KSBvbmx5DQo+IHdoZW4gYm90aCBzdWItbGlua3MgYXJlIGluIExTLU1PREUgdG8gZW5zdXJlIHRo
ZSBhdHRyaWJ1dGUgY2FuIGJlDQo+IHdyaXR0ZW4gc3VjY2Vzc2Z1bGx5Lg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogV2FuZyBTaHVhaXdlaSA8d2FuZ3NodWFpd2VpMUB4aWFvbWkuY29tPg0KDQpSZXZp
ZXdlZC1ieTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
