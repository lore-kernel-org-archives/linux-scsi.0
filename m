Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6A34EB45
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2024 08:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727167881; cv=fail; b=u1EzbnSzfQqJUdsaEmLT6TZIL/zBzg6AYgzqzSTqx+RC95YOA26gRuQTSmQfEILz9imNooTQ/B1j2CGcFLi2nqM1qa3iWxefOh/FKXVtMW92HOLM/YmLvobKeTrf0FIuIHDBkbszvFWsib+F/0JcrcaacLHO2ipxcFg9z5qCSkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727167881; c=relaxed/simple;
	bh=Y1EgogbtyCX+ZyWK7l9QCZ/Quwo5P+zPAxz9VcsUWZc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AAznB47kUUov1wnYuP8y6DI/SaLi6FhWiDlybunjtGHDEIWCvBgTCEzDousYv249aZ3Xzl8zhdbTRkUWfwtb8PcP3B5ld0Q/omcSGEjxtao6jlhifppj7sb1XWyyB6N8hhu0cjQrFbcp+eJZRp8NpsaGMyi49JWZhGCplcMs1mM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZjS7mPBR; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=PN/nQxOh; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZjS7mPBR";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="PN/nQxOh"
X-UUID: 27cab8247a5211ef8b96093e013ec31c-20240924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Y1EgogbtyCX+ZyWK7l9QCZ/Quwo5P+zPAxz9VcsUWZc=;
	b=ZjS7mPBRGsx1uWLcKOQXzt0JlwfHheMoeOv2XE6YK9GTOAPDVOesfXuGFOaMxqCDvpZXOJqn5VLrLZeg019pnVeyMeayBXnCoR+YYB5e3ca4QVsuZLkc4OFIQafmHHbmtCVCtTj2wBK82ex+r0hSKzd9S783vbmbUUsF3u6Nzwk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:2c8acf28-4d76-4672-b2f0-f9da0fdf99a6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:25077a9e-8e9a-4ac1-b510-390a86b53c0a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: 27cab8247a5211ef8b96093e013ec31c-20240924
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1994940218; Tue, 24 Sep 2024 16:51:14 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 24 Sep 2024 01:51:13 -0700
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 24 Sep 2024 16:51:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yBK+Dr7hiVWlx6yh4KIryB9NavG06Bj2J7+A9lHCbUSMJdJcs9+K15v0wxR1cDZ+IlI/7qrYR9ngpq3+ReV/LJ99L+6zAPnxLsmIOty5E5q7pJYsW3zKItopKBv84PphajxeNxl6t96/OW+G749CsD1v+hz/oZ+5CzTzsdcBX8eusOOa29m3E9rAXxM/eFnh1NsvpunlhrWntPKnenAYNEMOg60fICOjVqiSfgM9nWCIMezDKLkpJZHuG1XI+4Cex4w7a8bG2uB2WgdnQLiO8UmCVSgG5I0Zdct/dfaShyqn0tGV5Xd6ObScOE+Osq8K+3Jr6U/4wvJze/HjZLVR/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1EgogbtyCX+ZyWK7l9QCZ/Quwo5P+zPAxz9VcsUWZc=;
 b=Uzw0RNuIFo8086GPSX9Xci8+r5ViRxjksr9UB2yq9/jITnkGmXL1rn5OrrJXlq64jvzemsUs2uCtc+k4OT7LJPM+nvpWCKVavLU9SB0LArNVVkgpZRew9bX+5K9lX5pCVjCYN5HmpPVrNZu4cwIK4qV7lnQlBX5PNQfmeHM3CiR0PCzEHOm6Aaf/ccUMavqRtDrzdgMXZB9Pp2klNeTvwjgKb/zDA+82sPEhvGLuZTJGgzXedwGFJWCJm5pTq549/iHLOg0UyrUK1kMh2esNEZotKgV8/M6izqmVDsO73k+MJ98rF2j9sTxKbSXk0Ph6gIjQ9XR0mLDhWv5tOLkE+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1EgogbtyCX+ZyWK7l9QCZ/Quwo5P+zPAxz9VcsUWZc=;
 b=PN/nQxOh2befZT2Rvpe7pccQZDjTlycQZNBZjj8/kz36En8ZKWw4Zh6jYfkC7cGhHrVKszHxUfHsi3ILQiul+u6BeFqBttUQ7iCUffOBgc+SsxPv76Fe7FvDaD45Ew09hP1j9tgF5+PrFFJ70RqHD5IO7CObxLGTadBBeulzD0w=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7083.apcprd03.prod.outlook.com (2603:1096:400:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Tue, 24 Sep
 2024 08:51:11 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 08:51:10 +0000
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
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v8 3/3] ufs: core: add a quirk for MediaTek SDB mode
 aborted
Thread-Topic: [PATCH v8 3/3] ufs: core: add a quirk for MediaTek SDB mode
 aborted
Thread-Index: AQHbDY8/Q5BIR9JF0U2fs4d8wWNPObJlrgQAgAD0qYA=
Date: Tue, 24 Sep 2024 08:51:10 +0000
Message-ID: <e0cb5defb8894ea8fb058c617e9de3d3cfa9763f.camel@mediatek.com>
References: <20240923080344.19084-1-peter.wang@mediatek.com>
	 <20240923080344.19084-4-peter.wang@mediatek.com>
	 <ce42d310-2a23-453f-bd14-71eeaf9f5664@acm.org>
In-Reply-To: <ce42d310-2a23-453f-bd14-71eeaf9f5664@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7083:EE_
x-ms-office365-filtering-correlation-id: 289398d7-d5d2-4847-7d9c-08dcdc7609d5
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bllTM2JLcW1ETzJBZU5oc0dua1ZzZEpLWjVPNm9oaEMyakRmS2tkSmtxNW01?=
 =?utf-8?B?d0hUUnRvbnJsVkx0UU9Yc2xoMjB0WW1nT0Y4VEVFQThGWXQwUk1KbEU1K2Ey?=
 =?utf-8?B?akhTSmh2cDBySU0vMEpsOGtsbVZWNjVKODVnTm1vQUllS3lqaFFSSjJwVzZq?=
 =?utf-8?B?R3hKY3Izd0hXREprdlJuZ0pYYS90YzJJRG16Skk1cjN0dGcya3FDRTVsN1pW?=
 =?utf-8?B?MUx4c3B4V0xMMk1UNDRvZXFiNEJ2QTlkM0hRZWJlOEE4WnE2LzRoOG5jS01O?=
 =?utf-8?B?OXlaZ1lvbUlBczcybitSbDY4UVg1RHZIM29jMmZtdi9CcnFQMEVlejQxaXJW?=
 =?utf-8?B?MEIxYlNNblNFenczZFJ5WEN3RU5xMXQ4UE1zdytPSlRIVS9TZk90SWpBZjlk?=
 =?utf-8?B?Z29uV0Q5YkFwYmRrNU9PemU5QlBDczFkMmVTZGo5RGlZY2hxRVlISzJKeGtS?=
 =?utf-8?B?cGZTaDkxeXpVTWpya3JkYmRQbEtXbCtTVVJvYnB2anlPdWpZbTNQc3c1N3Ev?=
 =?utf-8?B?MG1tQ0NPOVdUKzkrQUlxUUlrcHdBSXVuSkkvSDQ5UUVsLytlVTlYcWE3R1VF?=
 =?utf-8?B?L1hOb0QxZmxYOVNvcUwzTFNKN21IZHIwc0g1NVRpQklCeWYwL1dtajhIVGl3?=
 =?utf-8?B?UDFGMnQxSkpYbUZQYVZZTC9PYVNoQ2RlTEp5ckdPR0NqSUxtUTMxYWxiWnhq?=
 =?utf-8?B?bllUZlp5SmUzRHpwVkVzTUdzdnNBT01ySHE0Q2tCTHVSNDUrWmoxREthN1pL?=
 =?utf-8?B?YWYvU3pXTFA2NUZzQzhkaVVhTGRqTE1WZWFSNlFYYjFMMVg1UGdmT1JrYitN?=
 =?utf-8?B?MXZkRkRDSTJ2NFpiWDR3aHBRNUozMXRKMHN2OEJnbWJnTzE2bXpmM1JnOEJH?=
 =?utf-8?B?K0FnUm5HSkdKUzhUNFh0U2tBcEVucVFtNHVUMi95QUMvZmFnWVRvTmNvMWZp?=
 =?utf-8?B?ZHdxTHlQVUtFNk0yMlpMbStKTUp1R2ZUYlJ4YzdzcHRPbUdQVjcxV2g5REYv?=
 =?utf-8?B?MEVFbTlUNTJnQnU4VTlwUzdlV1RYQm5QY2dydW9kdkFZZ1dBdlo4eDdlUnNG?=
 =?utf-8?B?bnU5MmlWNTA1NTBtOE13NGRhNitvTHFOUnFsK1p6eDdmKzlrTDY5b0VxNTVs?=
 =?utf-8?B?RWJONmhva3FCZGVlZ3N4d3B1cjRkVzVENFB5b0Q4a0trMFlLRTd3VjRPV2xr?=
 =?utf-8?B?TTBvdm5vb3RHcWxIRGpvejVra3dJK2JoM1d2bGwyOGlORzVESVBmWUQ0NnZL?=
 =?utf-8?B?SzNTM3grTWlVb2Z2WnV3dmVnaUo3RnhVQ2JGVS9NemZodkFuV2tVTHFRNHRl?=
 =?utf-8?B?RzhmSUk2RzVFT2xWS3JrTjc1MmFoWDN2YWdGWks3bFB1cUhDMWtpMFhtbCsy?=
 =?utf-8?B?RHpNTjg4TGEwdmphMmxpMjZQcmp5cHdXcFVCSkhBWlVnb1UwQlpGQ2FVTmZl?=
 =?utf-8?B?VE5mZEZZdll3OTRsdDQvam1haUthOFJEcitYcjN1UTNQUHU4T1ZUeWU5QlpH?=
 =?utf-8?B?NEpZWWR5eWJvZ09USmR0dENvU1VOd2c2dGxDWlhvU2tDckY5aTFOZ2RmWm9Y?=
 =?utf-8?B?VCtURklMOGlCdG9jMDZkR0tWNzJmV0NBWC80WU0yT1c0aDYwWWlpVU4vTFJa?=
 =?utf-8?B?V0VMUFZCUmNMTkNxOWRETVR6WTcwRnQ5ckpaL1ZXcTFKVS9adTNob2puc0RS?=
 =?utf-8?B?djRHbkxHS2hmcUprYXVnWEQ5bG1jc05qU2dKakNFZjhMN2k1cmcycDB5SEZ2?=
 =?utf-8?B?Mm5PK2JKem8yYXdpbWJ1KzRoS2h5RDFnS3AyblVvcEgybFl3cWZJTkUyL2FF?=
 =?utf-8?B?LytrY1lEa1h2T1ZhWEdNdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzkxMVlvdzdVRnh5UldwVTIrUmpIeTZyLzBMekVHdGZuQkc3YVI2akVITlpn?=
 =?utf-8?B?bmRWSzIvRExuYzVGU1ppYmVhTjJUSDBiQ05MWG8wK09kSXAzbzVkOFFiTXFh?=
 =?utf-8?B?cVBkdk4vdkQzc3RuTU9YU1FieTVrdmFTWndxcmJCUkxRN1dNQkhCM3dVaEVD?=
 =?utf-8?B?VElTYWpEVVhDVi9seHhlZWJiQ0QvUmdOUGs1Rk5YRytwa3locVppSXBxb2o0?=
 =?utf-8?B?R3BRRGJLSVhpNTVCM0FXSGYvWFRMblg4dzJGYlF1NGlPbUhIRXBPKzlobkRI?=
 =?utf-8?B?LzNEUkZIN3RyK3RHZ0c0TytDcXJyUjRCdW1GeC9JQ1R1TGRzNnFSSHZPN1R5?=
 =?utf-8?B?ZTVDem95a3hRbnZIQ05YekJ6Q0pNTXI4TFpsUERodE9lUzArZTl1eWVCbVh1?=
 =?utf-8?B?WWsvRHpDbGJOMlFuMFhtMVFkd1psZVVhYVhnRjIyckFvTFRnRDE1Y0gwYStH?=
 =?utf-8?B?SGJYbnJNN2RhUk13Zy9Ydm5UN0owdkNGWGRUVXlnQ1BlK010MFRTUTNlWjU1?=
 =?utf-8?B?UVpYSWRSZm5FbldJUndMVUhWUG9DbjNiL1NncXZEUFlZMUZCN0pzcEFFYVVV?=
 =?utf-8?B?aW1TT09jaE5MZVN3ZGFDRFM0Q0doMXlqeExEQTZQTDdFNHVZM24zbHZlY29V?=
 =?utf-8?B?UE9ILzZ3cUFhQ3dET1VEUFNuWUpZWWtnWGpSeU4rdlFRZ2x1TUNGTGtOdGtG?=
 =?utf-8?B?SWVvRkluTVhqTURBekxaNGhjSUtMTHFtcGc2U21JUU4rU3ZkWEF4UzZxWkdt?=
 =?utf-8?B?TUNGZ29la2x1VGVRR05McHlaQUVsa3JFVkN3RFIxRzYrK0ZvN0FUV0ljRWhX?=
 =?utf-8?B?Z3VtY2U0SmNvcmxkSWlFU05hRzhLRnZFVUtwU1I5QU5RRWl5UUdEcHNYV3ZF?=
 =?utf-8?B?VGxRcHFuTXhrN2lIbUpoMUpURHZsMGQyVnRVM3hxN29ORFU5bU5tVkZoQWFh?=
 =?utf-8?B?QTVIOGdOWjJaRGEzcEUxTGw1MDlFaVhZZWN6aHVVc3FtRTA3enZ5QUxjSE9S?=
 =?utf-8?B?cnJLK3kzdVpoTFJ4QVIzL1hIK1VTSnRMcUxyYzduZVFXYUE0TFk0L0xWMy93?=
 =?utf-8?B?UlpPMDhocjJjNXNlMkFKdkdjRWZ3VGhncXNUMFlXbjd1N01tVzN2MEVCbC9H?=
 =?utf-8?B?eG56Tkw4ZVFvUjJiSENscVpNdm1RL1F1cDhUWktOYzJNb2ora1hUdVA3YkJP?=
 =?utf-8?B?d3ZvVEFBYkhvK0tLMHorYlBNbU9vTjllL1BTbktiRXVtNUduejlxeTJ4NFNS?=
 =?utf-8?B?aEpCM010cHJtL3NyR2N6RkdpcnFyOXVhUnhyV25NNS82VENxZ00yTGFyWndS?=
 =?utf-8?B?OXEvMGNMUDdiZ2RQeEMxcFRRWTJnUlRMczJvUWlqcW1HVzVqZENyYWl2Uk5z?=
 =?utf-8?B?N0dWMUZRNjd6U3NhOTVPQjFtOHJ2d0dyRU1PWHNlL2t5Vm83dW5xQUV2Smpw?=
 =?utf-8?B?QnNwbmZhWG4vSm5WMExVOFN3dGQwM2piYkM3N0NqekdLc0prMWcyckxIdkU3?=
 =?utf-8?B?YVBNNG5nQWY3MkdTcGJVSlVTakxNQzR1TnNmdnliekNiWmxoZGliUkJ4czZh?=
 =?utf-8?B?QnJwVmRaS1BMQmN6VWRGeDlHUVlMbVZmREQ4alR0RTh0TTRVRWdqaFd5NlVo?=
 =?utf-8?B?NkFLbnlCeWxmVnN4ZE9RQmtVY0d5aFUzZ3RaOElIL2s1aDBYUzZRWG5ZcHM5?=
 =?utf-8?B?cUlKMENEenJQNXpYakNXZjIwNWxCeWVNNkgrZm83anFIUStPc2xtKzc3a1dn?=
 =?utf-8?B?VEkwN08rcG15cExzNXJBK0RRN3RNK1BQTGxwbDhTU3pDRml3dk9PdXFMSUQr?=
 =?utf-8?B?YVFaa3A3QVcvUGg0dzY4OEN6bmNzWXpJNjZjTWZYazI0MkkwRHc4N01xbjV3?=
 =?utf-8?B?SlZ0andtbGlYaWkzdm1vbDdDL1ozZkRTM1BKUnJFYml0cG8rcFgza01nZ1Er?=
 =?utf-8?B?U082SHdFOUpCTzFuc2JKTjFBYTJiNnpFYmhQNlNobWhTWk04ZGRMYmhndVJa?=
 =?utf-8?B?Z1FOWWFUOXFiYXF2aHIxdzNJNWtLVFRnNlhHZjFhaWlIZTgzOE41OW95U0VQ?=
 =?utf-8?B?N3dBbHAyK1p0SkdaVTVCTmxTZXNzTlBGdHhuR2lMZTZ0c2wzNDdNajJ0OEJ0?=
 =?utf-8?B?cHBjdzFMNFhKWUJSSHV3UnA3YjZrU3ZnaVgzNURuMC9XVEc5MlZzRzJNcFhx?=
 =?utf-8?B?NUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60D01853A8ECA248821E33ABFE96975D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 289398d7-d5d2-4847-7d9c-08dcdc7609d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2024 08:51:10.8574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NHEvQp16Qx9zqP7CXlX2hyZOBp8oooCYsp+cy+pMXe9fScGUz92h8L8/c8jxx9+r1QuiXgBHIKvRAWuguR99Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7083
X-MTK: N

T24gTW9uLCAyMDI0LTA5LTIzIGF0IDExOjE1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8yMy8yNCAxOjAzIEFNLCBwZXRlci53YW5nQG1lZGlhdGVr
LmNvbSB3cm90ZToNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBi
L2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiBpbmRleCBiNWM3YmM1MGEyN2UuLmI0MjA3
OWMzZDYzNCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4g
KysrIGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+IEBAIC01NDA0LDcgKzU0MDQsMTAg
QEAgdWZzaGNkX3RyYW5zZmVyX3JzcF9zdGF0dXMoc3RydWN0IHVmc19oYmENCj4gKmhiYSwgc3Ry
dWN0IHVmc2hjZF9scmIgKmxyYnAsDQo+ID4gICB9DQo+ID4gICBicmVhazsNCj4gPiAgIGNhc2Ug
T0NTX0FCT1JURUQ6DQo+ID4gLXJlc3VsdCB8PSBESURfQUJPUlQgPDwgMTY7DQo+ID4gK2lmICho
YmEtPnF1aXJrcyAmIFVGU0hDRF9RVUlSS19PQ1NfQUJPUlRFRCkNCj4gPiArcmVzdWx0IHw9IERJ
RF9SRVFVRVVFIDw8IDE2Ow0KPiA+ICtlbHNlDQo+ID4gK3Jlc3VsdCB8PSBESURfQUJPUlQgPDwg
MTY7DQo+ID4gICBkZXZfd2FybihoYmEtPmRldiwNCj4gPiAgICJPQ1MgYWJvcnRlZCBmcm9tIGNv
bnRyb2xsZXIgPSAleCBmb3IgdGFnICVkXG4iLA0KPiA+ICAgb2NzLCBscmJwLT50YXNrX3RhZyk7
DQo+IA0KPiBJIHRoaW5rIHRoZSBhcHByb2FjaCBvZiB0aGlzIHBhdGNoIGlzIHJhY3k6IHRoZSBj
bWQtPnJlc3VsdA0KPiBhc3NpZ25tZW50DQo+IGJ5IHVmc2hjZF90cmFuc2Zlcl9yc3Bfc3RhdHVz
KCkgcmFjZXMgd2l0aCB0aGUgY21kLT5yZXN1bHQgYXNzaWdubWVudA0KPiBieQ0KPiB1ZnNoY2Rf
YWJvcnRfb25lKCkuIEhvdyBhYm91dCBhZGRyZXNzaW5nIHRoaXMgcmFjZSBhcyBmb2xsb3dzPw0K
PiAqIEluIHVmc2hjZF9jb21wbF9vbmVfY3FlKCksIGlmIHRoZSBPQ1NfQUJPUlRFRCBzdGF0dXMg
aXMNCj4gZW5jb3VudGVyZWQsDQo+ICAgIHNldCBhIGNvbXBsZXRpb24uDQo+ICogSW4gdGhlIGNv
ZGUgdGhhdCBhYm9ydHMgU0NTSSBjb21tYW5kcywgZm9yIE1lZGlhVGVrIGNvbnRyb2xsZXJzDQo+
IG9ubHksDQo+ICAgIHdhaXQgZm9yIHRoYXQgY29tcGxldGlvbiAoYmFzZWQgb24gYSBxdWlyayku
DQo+ICogSW5zdGVhZCBvZiBpbnRyb2R1Y2luZyBhbiBpZi1zdGF0ZW1lbnQgaW4NCj4gICAgdWZz
aGNkX3RyYW5zZmVyX3JzcF9zdGF0dXMoKSwgcmVseSBvbiB0aGUgY21kLT5yZXN1bHQgdmFsdWUN
Cj4gYXNzaWduZWQNCj4gICAgYnkgdWZzaGNkX2Fib3J0X29uZSgpLg0KPiANCj4gVGhhbmtzLA0K
PiANCj4gQmFydC4NCg0KSGkgQmFydCwNCg0KU29ycnksIEkgbWlnaHQgbm90IGhhdmUgdW5kZXJz
dG9vZCB0aGUgcG90ZW50aWFsIHJhY2luZyBpc3N1ZSBoZXJlLg0KDQpUaGUgU0NTSSBhYm9ydCBj
b21tYW5kIGRvZXNuJ3QgbmVlZCB0byB3YWl0IGZvciBjb21wbGV0aW9uIGJlY2F1c2UgDQpTQ1NJ
IGRvZXNuJ3QgY2FyZSBhYm91dCBjbWQtPnJlc3VsdCwgcmlnaHQ/DQoNClRoZSBlcnJvciBoYW5k
bGVyIGFib3J0IGFsc28gZG9lc24ndCBuZWVkIHRvIHdhaXQgZm9yIGNvbXBsZXRpb24sIA0KYmVj
YXVzZSBpdCBzaG91bGQgaGF2ZSBhIGd1YXJhbnRlZWQgb3JkZXI/DQpGaXJzdGx5LCB1ZnNoY2Rf
YWJvcnRfb25lIGlzIG9ubHkgbGlrZWx5IHRvIGJlIGZpbGxlZCANCmJhY2sgd2l0aCBPQ1M6IEFC
T1JURUQgYnkgTWVkaWFUZWsgVUZTIGNvbnRyb2xsZXIgYWZ0ZXIgDQp1ZnNoY2RfdHJ5X3RvX2Fi
b3J0X3Rhc2ssIGFuZCB0aGUgc2VxdWVuY2UgaXMgYXMgZm9sbG93cy4NCg0KdWZzaGNkX2Vycl9o
YW5kbGVyKCkNCiAgdWZzaGNkX2Fib3J0X2FsbCgpDQogICAgdWZzaGNkX2Fib3J0X29uZSgpDQog
ICAgICB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soKQkvLyB0cmlnZ2VyIG1lZGlhdGVrIGNvbnRy
b2xsZXINCmZpbGwgT0NTOiBBQk9SVEVEDQogICAgdWZzaGNkX2NvbXBsZXRlX3JlcXVlc3RzKCkN
CiAgICAgIHVmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKQ0KICAgICAgICB1ZnNoY2RfcG9sbCgp
DQogICAgICAgICAgZ2V0IG91dHN0YW5kaW5nX2xvY2sNCiAgICAgICAgICBjbGVhciBvdXRzdGFu
ZGluZ19yZXFzIHRhZw0KICAgICAgICAgIHJlbGVhc2Ugb3V0c3RhbmRpbmdfbG9jawkNCiAgICAg
ICAgICBfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKQ0KICAgICAgICAgICAgdWZzaGNkX2Nv
bXBsX29uZV9jcWUoKQ0KICAgICAgICAgICAgICBjbWQtPnJlc3VsdCA9IERJRF9SRVFVRVVFIC8v
IG1lZGlhdGVrIG1heSBuZWVkIHF1aXJrDQpjaGFuZ2UgRElEX0FCT1JUIHRvIERJRF9SRVFVRVVF
DQoNCg0KSW4gYWRkaXRpb24sIHRoZSBJU1Igd2lsbCB1c2UgdGhlIG91dHN0YW5kaW5nX2xvY2sg
d2l0aCANCnVmc2hjZF9lcnJfaGFuZGxlciB0byBwcm92aWRlIHByb3RlY3Rpb24sIHNvIHRoZXJl
IHdvbid0IGJlIGFueSANCnJhY2luZyB0aGF0IGNhdXNlcyB0aGUgY29tbWFuZCB0byBiZSByZWxl
YXNlZCByZXBlYXRlZGx5LiANClRoZSBvbmx5IHBvc3NpYmxlIGlzc3VlIG1pZ2h0IGJlIHRoYXQg
YWZ0ZXIgdWZzaGNkX2Fib3J0X29uZSwgDQp0aGUgTWVkaWFUZWsgVUZTIGNvbnRyb2xsZXIgaGFz
IG5vdCB5ZXQgZmlsbGVkIGluIE9DUzogQUJPUlRFRCANCmFuZCBoYXMgZW50ZXJlZCB1ZnNoY2Rf
dHJhbnNmZXJfcnNwX3N0YXR1cyBmb3IgY2hlY2tpbmcuIA0KQnV0IHRoaXMgZG9lc24ndCBtYXR0
ZXIsIGJlY2F1c2UgaXQgd2lsbCBqdXN0IGJlIHRyZWF0ZWQgDQphcyBPQ1NfSU5WQUxJRF9DT01N
QU5EX1NUQVRVUy4NCg0KSXMgdGhlcmUgYW55IGNvcm5lciBjYXNlIHRoYXQgSSBtaWdodCBoYXZl
IG92ZXJsb29rZWQ/DQoNCg0KVGhhbmtzLg0KUGV0ZXINCg0KDQoNCj4gDQo=
