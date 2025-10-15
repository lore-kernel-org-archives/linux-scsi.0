Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06FD221555
	for <linux-scsi@vger.kernel.org>; Wed, 15 Oct 2025 06:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760508913; cv=fail; b=NWPXVtXhxV3DIQZ9BgHkDj4DfKWVITMMvfAuyfcI4T5m010sZIH17Zf+KoAQbYQEUzLF3y/INjYMqALeOltFtpgHOHfGVTnfIAVnCgtW+174XmsCzh/VeoVE1oEcNbm7hFGh4t8NJtovYCWYyCGZIhJb2wQrmDcde6xcWZISbPs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760508913; c=relaxed/simple;
	bh=yRBv25Vzg7+tNcJGbTSLM/iIosaxtHvG3qcpV/zQ3Hc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r2BKV79lh7Ol/H7On2FXHDIT0aCKCuY60awX7NNhg6FPoKLEvJZxlQ1UEOgthTDSl08ASot+zdxEk5Qfw+RPl/w6HPG9X5fl/FCm/ADwdz/iDERwoYt3rFubW0PNhTJCOfuPAiskT3MjPm8HHO+cMwuEmC2TntthD+C+BKU+GmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=u1YLSHSi; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=rvdZiqrc; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="u1YLSHSi";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="rvdZiqrc"
X-UUID: 4bc5f5e2a98e11f0b33aeb1e7f16c2b6-20251015
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=yRBv25Vzg7+tNcJGbTSLM/iIosaxtHvG3qcpV/zQ3Hc=;
	b=u1YLSHSiDz+5+0ipE6+xDrkQ5+Fktnxov6mtnyeNNlviQcrCnRp8XXRUBO+upiFvyIqPxhtFEfUW/Ab9liAAe7KJdLjRfohGAR6zYSuUb2Y796GITSTjdymgpwcLr9OFNl3Ff9hS2qQAxQua7mu6tMYjaUmq1SI4wfrUnl9c8mc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:5a481773-7c90-48e3-82a3-5c57e79e977a,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:efbf6702-eaf8-4c8c-94de-0bc39887e077,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4bc5f5e2a98e11f0b33aeb1e7f16c2b6-20251015
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 80288195; Wed, 15 Oct 2025 14:15:07 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 15 Oct 2025 14:15:05 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 15 Oct 2025 14:15:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XcZnypCW7SiU7J+FgA6EdlCWfPs1LPobB3pTKd4Wb0yjR8vzCQGUwl2gch8E8yVnvxS/8yfKTOegJaHE6tHoXoc6AmzVrcgzMgUsByZr8eBUzLLa6NgIgF4WpVFH2A5iRdHWndXk5hwP7ftOi5/93PD9L4aixw20lIMEqUei41Ej789Rb87+VGR9UuFwUobMhWx18a4nluBTf++C9xJoCOg3W3FRhVapfdyCfQa5z2ouupcNVNAxrltg/OaTRLyKQyWxYHh0yBTtHmh116wrpsnn65jkFMrXVuzSzAptgxX1XJuhDQl0tdi7jgjrF6nJLJO/tdPm5mEneycOEyrmrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRBv25Vzg7+tNcJGbTSLM/iIosaxtHvG3qcpV/zQ3Hc=;
 b=IXPWvNI5qGZABc5j7ihknboNomVGAsQdmpURBrdQ6/uGqysx2s2XLY6TRh7XKHl/CpdoOSz0W1s+lTzS3FhJLaxwNM8n32Ndhf4w3btjWYgpw+CRYHMmeYCfr8CCMBT5nSKigNCuBCKw5PzTB5vGf241MSBxv0lxhe7Vt1PEKctBsJ6z5950TMZg2EKd1g7kPsnoY/+4DdeQsXDcnjih205eDRKTsoBdpjiGbRxI4ni+QMtLrE8gR+zoa8OCdcPY1C1YAXmOWCzD3xwrdcP/83VL//dB6q68iHfJcNQaVvnQinOu1K6eLy+GjvkmECsVTuxXCgAPBzM0il+f0Aw1ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRBv25Vzg7+tNcJGbTSLM/iIosaxtHvG3qcpV/zQ3Hc=;
 b=rvdZiqrcFvCXDcsxVjNVuUFgNFyX3Mebn6qWe/W/gEtIB/4R6jO2gHSLGhgp6NVQCRRRQGYnK9JoxnOlSxrgaM+CxB66LVJ2N4nyNX8+TJkKElZGBTDZXcc9lbmegYohIpdEBxyUM5xk2hP9lMYks1wKTL15fdOmGL4jdILaPh8=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE1PPF994939445.apcprd03.prod.outlook.com (2603:1096:108:1::85c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.11; Wed, 15 Oct
 2025 06:15:00 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9203.007; Wed, 15 Oct 2025
 06:14:58 +0000
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
Subject: Re: [PATCH v1 2/2] ufs: core: support dumping CQ entry in MCQ Mode
Thread-Topic: [PATCH v1 2/2] ufs: core: support dumping CQ entry in MCQ Mode
Thread-Index: AQHcPQ0IivSyUnOet0KA3J6Dhj8HJLTByVoAgADym4A=
Date: Wed, 15 Oct 2025 06:14:58 +0000
Message-ID: <b9a9157e09cde6ea17f9a0f36a4ad11fcbcf0b0b.camel@mediatek.com>
References: <20251014131758.270324-1-peter.wang@mediatek.com>
	 <20251014131758.270324-3-peter.wang@mediatek.com>
	 <4c47f800-0536-452a-b64b-d177fa306418@acm.org>
In-Reply-To: <4c47f800-0536-452a-b64b-d177fa306418@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE1PPF994939445:EE_
x-ms-office365-filtering-correlation-id: d5a07131-65e1-448c-1227-08de0bb22b08
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dGRLRm5LV1ROd2RpU0p2NitWQjM1K01IMHA0ZTRSVWRETE5CWHN4RFlTdHov?=
 =?utf-8?B?eDN4VEVXWGNrRkE0L2poYkJ0S29rd2IrL2tVcC9JWHhGMmN5dkpTYWlJaHBP?=
 =?utf-8?B?WS85bEdMMzVQUlZjT1RZdzg1NlRURi8zcVN3VThIa0xBbFl0K05KdzFrWTd6?=
 =?utf-8?B?cGFrQmkzRENoQ1ZmaGx1Q2NXZW5rbVNvRFNyTFFRZW1qbWNhYmVkblVuSmdC?=
 =?utf-8?B?c2F2RmRnZlErWEV3RFJoUlRydHp2MnQ5eTR6RU9WQlhYVXhZa2Q2VVh0OUhx?=
 =?utf-8?B?OVdDSkpVL0M2QjVRU0ZpYUsxL21vaS90Z25NNHZMcGEwVG8vTHNFdTJTelor?=
 =?utf-8?B?Z05HclA4TExGQ3d3bDZVV09yNEoveUtWb0k0VWxaTC9PaXRMTkdDSi9JTEhh?=
 =?utf-8?B?VFB3MEdOVzFtdFN1U3hKclZ1aThCNnl4a2lhOThwcHRsOERYZU50NXRXYTF3?=
 =?utf-8?B?MFI1dTltREJZVXNObU1KUVVUZmI3MXNkTmlLVnZFUDJKMzNyNzB0TWV4REtw?=
 =?utf-8?B?Nmlocmxza0FvMm1Kbzl6WDBVVGdVbGoxYVNIRDhETjhMYkNrZUtzSXNjMXlS?=
 =?utf-8?B?VWp2SFdGWXhNNXBZNjdNS0orYUVzcWduZFNaek14Umtlb0xieGhwWGpWclAr?=
 =?utf-8?B?RUkxWU83aURxT3czdk8yaENndUczeFRlQmtxRVl5K1FyREIvd3RxVmxmZWc5?=
 =?utf-8?B?WlNSNllMSndlOVRlMlE1bzIxeUZqVS9HTzlpME5vNmZkUWx4UElMdTJ5QlNo?=
 =?utf-8?B?RWpMdktyYkFialJuUm1GUm1WbVZEYThGK0FyeU9QQy95ZS81OUpUQytUdmUr?=
 =?utf-8?B?K0FYbjFFeUl2d3JZZ0pCWmdldjZLV29MajNwa0ZlN3pGU2U4NFBPYXBKdytQ?=
 =?utf-8?B?WENpU0sxem1KZGU1bWN1VndNb3dDUEVWTkhKczIyZTlMdkVPRmNXTjRPdDF4?=
 =?utf-8?B?YjlNTlZEbG5BWUtSWmpSOVM0ZWprbVdqNTFOblN4dURvUDJQUm5kVHdVQTlI?=
 =?utf-8?B?LzBWTlBmOTFscUQ4c3dDRkNRREVpSTlDcFlIbzJXcEtUeE1MY09ZU3dJaVhE?=
 =?utf-8?B?ankxdkZYbDJIUVZJM0YrRGZSZlhlZXI1ZlFiTnRzb0thMXJYczVzK2dDNExm?=
 =?utf-8?B?bFF4TkU4TzNaSkRvd2Fqa2xodDdnQkpLaGJaUW82WVVhV0t0WDZiSGlESytP?=
 =?utf-8?B?TENuZVZSSGNGZ1JlZmt2VEkzdW1hc3AySzlZNXI2VkZrVW1FVzRhNExWN0pE?=
 =?utf-8?B?a3lXYVNIREdVeWFmZG4xNkpnMC9DSnMzZWpzbFRrN2ZpT1haNTQxRnpINXEv?=
 =?utf-8?B?VXBxbHlWQlRHSnlCWHl3eUd1SWJhNFZCYUdlSDBqQy82YW1wN21FOHdLa29X?=
 =?utf-8?B?ZVphSHNyVmJzY0NLN2Z3cThDSXJ4VzdCZnZRZUNrREI3ZDhIbit5NkM4VnR3?=
 =?utf-8?B?RUgvQzkzRGxLL1dlR2hNRTFBdFRoa2lhQndLTlFpK2lpdXE3ZUJLdVNNQlg5?=
 =?utf-8?B?KzFPQk9hanpBb09XSVNvRFZyeXJHemNFNWdYRlo0N2tkWmlYMVhLNmlnT1NI?=
 =?utf-8?B?T0NOeVBRbDJjenpJWjhHR1NMQzRYSXliaENKUXFyWGIyZUJXMERiWUNuRG5N?=
 =?utf-8?B?TUR4QjkwSnpCV0FMU2FXKzY4Um9tSkxYWXFETWF6Qkg1MWM4bTVlNk9DZ0xH?=
 =?utf-8?B?VEQzalhDYVlyeXBYUVI3WGo2ZkhPcno4RlNJVGJPVlVzbE92MU9CYlR3dm9L?=
 =?utf-8?B?Ym1UNGVBemNLakhpQ3BQYXdmWU9QaFlLd2ZxS1JhRHBYbEJDa3pERGY2dEN3?=
 =?utf-8?B?OW10OUZsSU94R0ZPTzJGSURsUXE1N0hVd3J5Qm9aMStXRlNERHFtK244WmZO?=
 =?utf-8?B?TmRmQzBEUkZpU01OckhoR2ErVjZkTndsYjBkNDJ5U2VXOU9IQXE2ODFxWHdQ?=
 =?utf-8?B?MHBPOUlPWnE0OHc4UDNvL00vS3hldU1WU0w0eGdZeXZhZWZDMVp0UUp5R1NL?=
 =?utf-8?B?L2gydG93NmRlcXF6MUFWZE9aRUsrbUtQdUd6RmZBK201dHZEZVRnNEw2TDBi?=
 =?utf-8?Q?w+9zEb?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2Z0SHk0SndOQjZMV092Y1pNeFNXNEZrbXB3NFZuaVY3dFpDeHh2Y2lQeHQr?=
 =?utf-8?B?UFB2clA0QkN2aHlFVm9IRm4zR0ZFeERYQ3ZNKytpSnNHMyttbm53eUFIOTlF?=
 =?utf-8?B?ZkRUVHpWT1RocVhQYUY2RHdzUWxhbVFFRVJoRzdLVTE1L2tKUVN1MlpHSk9O?=
 =?utf-8?B?R29PL1VzNEgyYkVZMUVuZnhNWEQ4WW9VbmEvYTFxMCtHRHlRbmtsckdHYktZ?=
 =?utf-8?B?YS90ays2anNuSDUrTWh4RGtra0dKeW5FMFRUd0VSRDFqcVgwRndDbU00aWJs?=
 =?utf-8?B?NjkzUTNMN3hqTjhvZzBmZzBVZ0MxdEJlM053SEhqQ3ZFRXl2RVNRdXJFUE15?=
 =?utf-8?B?NVpKVGFZbGxhVEhTWEU4VnoyaTBYQ2piZHZMNjBwRUlxcmJjb2tkZFJsYUIr?=
 =?utf-8?B?NEQ5K3l3akFIeW1VdDVsM2k5ZlZWS0owV1JWUDNoUE1zOEpXMVZQRVVLVlYv?=
 =?utf-8?B?VzlpUTdBN3VYM0tIRkcrYjE2YkxhMjFNMGIwOFM2RHdHdW05Q2gzNlZhWlZn?=
 =?utf-8?B?cmhEQWNNeEtCcHByMWs4cDBKOGVBMUNQVGViS2w1NnIrdkdZQU4wVHpPQjNR?=
 =?utf-8?B?ZmdhK0ZoOVJHSUJpTUdrcXhHbitzSjNGdVY5STZvMTBraVlqWmVJeVUzclFm?=
 =?utf-8?B?VWhOQkZEb3QxU205ZUIrZzk2Y0xtcmg4MlU5MGJ2NmpQeXVpR3RqdDZtbmlr?=
 =?utf-8?B?SlRKNjhGVHUyUDVONzlhZnlRMkYzS2g5bE1xc29nV3pVSEZJWjJjVlU5UENh?=
 =?utf-8?B?bDV1OTZXS2NialltMkw0MFFMR1VtbUFNVFF6emw2NS8yNFNJVmRXR0NEbUlD?=
 =?utf-8?B?K0lMa3NJUThZL0pORG5LZHZqK2wrZ2xNTjJXQnpuTE9JbzhYYTZBbE1pUldC?=
 =?utf-8?B?YjVRZW1IUThZcm9Lc0UzeXRkRkdhYmU3RUZOZTE0OG1FLzRFdkZidzNkSUNH?=
 =?utf-8?B?NngwUkxmWFR3ams5eVZPSGltMDhTcTVlanAxQzJhRmJvK2kvelBqRG9SZ0lW?=
 =?utf-8?B?WmF1T3RIVjdKRGlqSUhKREswT2VzS3BMNnRFSVFwYk4wVXVSUWlaYVVtUWd5?=
 =?utf-8?B?YkdEMWZxWjkvVHhjOW92Q3FpNHVqeDdiWFRWSlNiRW1kaXFTUG81YzRjVXEr?=
 =?utf-8?B?VUFISXhrbVJuZWNkTFBYVDFreG5kRTZZMlFnczlOWFh6RE9ZT3VBOE1uNTBM?=
 =?utf-8?B?ZDhuYVpJcGNsZEFwNVp6cWkvM3FIT090ZGNQM2szNGNGNEZqbjh5czVhY1N4?=
 =?utf-8?B?MTRQQ2ZUSkQweFBWc3ordnRxaWF2b1JuQ3NOZ3pVRXhaYUZNV1dTVVVpT1gx?=
 =?utf-8?B?cFB4K1dwOVUyRDZZK1hIWWM0cG9aRzdFNjBtTTNMZXFnc2ZqcWlOT2xKd2dm?=
 =?utf-8?B?dUZtak9qYXB1Z1d1UEFjR0ZScUdROWgvbmxYbllJVzNYb1NMNFRweWZxaVB6?=
 =?utf-8?B?YjZnMTV0Q0RPQmZlMStTT1dnVDAraVZwYy8zdnRxNGJCUUN3NFBZYUFoSlJa?=
 =?utf-8?B?YTErdWxSWmh6aUttbUh3Q2t1ek9KMUsrZEtEUG9VWm1ISTY5NFpRVUREKzFi?=
 =?utf-8?B?ZnhLdWZZNUhtWE1GOXRiVDBveGpSR0ZGYmdQV3dwRExjTGpGL3FjUHEvaGhy?=
 =?utf-8?B?YmZmRTZJYUtvNkZhMllwMm04ZUNGUmtlcTE3ZnFMd1oxTWhVcDFQOERwZFc1?=
 =?utf-8?B?NGFYb3dMSS9MbXk1ZGdnSkk0bUNIRWlDcVkvTlgyaU51UzlENjFsSGg4V3Ex?=
 =?utf-8?B?STJyUDM3OURkTVVOTCtUeDBSNDAxZ1I3MzAvUHJxLzA4K2VNYTFHNEs0K09j?=
 =?utf-8?B?bWIyUkpYeEhKaUdDUFV3WldMNWcveE5ZeW43WDVmeEwwUlNwMVNnajNmcmFT?=
 =?utf-8?B?ZXhIb0xOU1g2Ym9YaDRYcWhxK1hPdTVtenhWcjAxdjVkdUNPVTZGVjZCWVZF?=
 =?utf-8?B?dEREVXZxVGV6VXIrQmtmV0xYR1hLamIxYmpiTk1YYkh2aUI0K3FkTEo0bFZs?=
 =?utf-8?B?TlNQd2I1d1ZtSGV6L09tYWNyV1BiNVBORzh5dWFjZmc2eldGVFlVM2haYmdo?=
 =?utf-8?B?WU5qUE9zeWZuVWxyb1BXRTNseDArMjBFNG5wa2dwMVdtZWZHS3I4cVNhUkJT?=
 =?utf-8?B?Nk83ckp3WTJ3c3V4cGljNGs4a2pPMHEzdGRMaC8rWW5WT0c3dWRCdWlqalhF?=
 =?utf-8?B?RXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <102A43E4530CFB4495E9FA965328793B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a07131-65e1-448c-1227-08de0bb22b08
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2025 06:14:58.7109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qoIFBHh1VUQ4iobb/re4e5hUDTigwvPpWt7/vFnPlbHD8sv3hT9xEW2Nxuw1KrpqAhb6axY6lBgrQs+U9oH2hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE1PPF994939445

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDA4OjQ2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFNvIHRoZXJlIGFyZSBmb3VyIGNhbGxlcnMgb2YgdWZzaGNkX3ByaW50X3RyKCkgYW5kIG9u
bHkgb25lIGNhbGxlcg0KPiBkdW1wcw0KPiB0aGUgQ1FFPyBXb3VsZG4ndCBpdCBiZSBiZXR0ZXIg
bm90IHRvIGFkZCBhbnkgYXJndW1lbnRzIHRvDQo+IHVmc2hjZF9wcmludF90cigpIGFuZCBpbnN0
ZWFkIGFkZCB0aGUgY29kZSBmb3IgZHVtcGluZyB0aGUgQ1FFDQo+IGRpcmVjdGx5DQo+IGluIHRo
ZSBvbmx5IGZ1bmN0aW9uIHRoYXQgbmVlZHMgdGhpcyBmdW5jdGlvbmFsaXR5Pw0KPiANCj4gVGhh
bmtzLA0KPiANCj4gQmFydC4NCj4gDQo+IA0KDQpIaSBCYXJ0LA0KDQpUaGUgQ1FFIHBvaW50ZXIg
aXMgZ2VuZXJhdGVkIGJ5IHRoZSBoYXJkd2FyZSBhZnRlciByZWNlaXZpbmcNCnRoZSBVRlMgZGV2
aWNlIHJlc3BvbnNlLiBTbywgaWYgd2UgZG9uJ3QgYWRkIHRoZSBDUUUgYXJndW1lbnQsDQpJJ20g
bm90IHN1cmUgaG93IHdlIGNvdWxkIG9idGFpbiB0aGlzIHBvaW50ZXIgaW4gdWZzaGNkX3ByaW50
X3RyLg0KT3IgYXJlIHlvdSBzdWdnZXN0aW5nIHRoYXQgd2UgZHVtcCB0aGUgQ1FFIGRpcmVjdGx5
IGluIA0KdWZzaGNkX3RyYW5zZmVyX3JzcF9zdGF0dXM/DQoNClRoYW5rcw0KUGV0ZXINCg0K
