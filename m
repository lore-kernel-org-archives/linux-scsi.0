Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0F1101EE
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 03:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727322314; cv=fail; b=s0XJAmG7ZcIS+5TfUl1apqf7LBVk6mUhGVV2eKHO1MB4HaCv28Dn6kz6Kt91bIwsDm1/27H4pbtt9P/nctKNlQInq/VujElr4HDGeox9XewN5at0Ay96kNjUlvRqDpBHF1/67+dLkHMo2dbTkhGev6pjH4wugWYOMsd2HoTyFoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727322314; c=relaxed/simple;
	bh=oF3G74pyeAZowzlEaZhlvChl/Cuspj3+xNdtGzMZBRU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k624vvQYLQLDUneGnw34DsdlPjBEpmmKHXwgifEI30pDODTLQ8VqDSqgK/082gWrKUkz0GPr5bDQ84mGMITiUHszczX+wc1WjdxczTAep0bnKeMWcPhA024M8pzKaODvPch5m7gQ+bzw5sjGGMUGTQ2EkyoPUT1B77pcZqUK8Ks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=K+oImX0+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=mA4Z//9T; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="K+oImX0+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="mA4Z//9T"
X-UUID: b74f8e1c7bb911efb66947d174671e26-20240926
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=oF3G74pyeAZowzlEaZhlvChl/Cuspj3+xNdtGzMZBRU=;
	b=K+oImX0+EZ4N/p4yE+EdyzZCoyH9MU5TVSQNX8fUjiSDfHLjSdx+RVGI+qqlPU1jWQHPouTSD3B1fvBY6jpfcFHxlwS/yhmQMkSZ+YnwOQu0ZEbeO9qAWjdqJxWCpvpLdDvCgP+UytDLYLOMxwsjGlfcYpoTwC18pGahh2V2E9A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:205407e4-1bb7-4bc4-b7d0-2985de92a8ea,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:10344518-b42d-49a6-94d2-a75fa0df01d2,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: b74f8e1c7bb911efb66947d174671e26-20240926
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2024154585; Thu, 26 Sep 2024 11:45:04 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 26 Sep 2024 11:45:03 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 26 Sep 2024 11:45:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OKO1MtFa3/ATQdv+IwPpHtamEGwboNNkrVsEBtpWgRHDyFwFeMYd93UwbXRhE95UasxUHnvrqczcdRTqLt4B8YB3pLZNDdGw3nyFg6zv4zYa8re14elD2yh+o13nu3VuTrXnek3KE/TtTRSN9zLy4DvrCvJ+ivKOMUpiThqJR1ldOzQPbeA0fyhD6ljWpGvlnynekBsWHFtiuUGojCFqAihSH/S7FXx53HN+OW161YBtTiUlLYNo0KLu+UolH5uKUV0rgyg0Jk/b6b8kFyiZWVePkKXgaecW6FI3WHb1gNGFcZQLGahQa1uN+Ftci6S1ovWSys7exuKUAIk+re4Fdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oF3G74pyeAZowzlEaZhlvChl/Cuspj3+xNdtGzMZBRU=;
 b=yziri9bSV/VeWxWckg+nSvywnArMGY8QNze5NPsonI2yayoQjNW9f4fONsXZUIGz3aUihoY4e6XnnHiMbP/sFbfHNj65A4KlAMm2hTIZL6Tp2v9k/0U3vykfRAlt0ghqeHk66YulADfz80T3NqInu3z6TMThdf6J38BXHndtUcrf68uFz5gSc563nl1Vd5kjM+FFZw0rkefcX1fYY7k6TmOoRn+1TGNC/GFAPcZYgDEVMhnOfu/k+WBeKJapX3rF8kXVEfvkg5+7+beprpQbGSoNZgZVTIkE2rgoWNZgu7lqCc+fUTnaO8soIvHRMXbHpLFQQrEmun2QSKwxauIRsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oF3G74pyeAZowzlEaZhlvChl/Cuspj3+xNdtGzMZBRU=;
 b=mA4Z//9TEb2fToKTl1p0GbrFhQv/hALfgm8th94QgoYoT/TE7nUL5Hp9y9+lFr6yXSjL9NZQelGfCjxrXXu/I9PgcdNCtL/d4MYYHcCofK2I81xvHuK//p4fSmX7pF2rDnYf568LFtoKBosMhapFmBFWgyzKatFabmEGmp67n8U=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB7778.apcprd03.prod.outlook.com (2603:1096:101:13f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Thu, 26 Sep
 2024 03:45:01 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8005.017; Thu, 26 Sep 2024
 03:45:01 +0000
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
Subject: Re: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ abort
Thread-Topic: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ
 abort
Thread-Index: AQHbDzNnjCHDHRi190OQQBukK2Coj7Jot2cAgAC3HYA=
Date: Thu, 26 Sep 2024 03:45:00 +0000
Message-ID: <4bc08986190aecb394f07997b2ad31e301567496.camel@mediatek.com>
References: <20240925095546.19492-1-peter.wang@mediatek.com>
	 <20240925095546.19492-3-peter.wang@mediatek.com>
	 <949fb86d-6b61-4a1a-bc04-c05bb30522b9@acm.org>
In-Reply-To: <949fb86d-6b61-4a1a-bc04-c05bb30522b9@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB7778:EE_
x-ms-office365-filtering-correlation-id: 1d3c89cf-2595-4d4e-a6cc-08dcdddd995b
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bUhUMUlWemxRenQvd0RmUlRLRFN6RDNhcVltak81KzhDbit3eCtNalJrdDh3?=
 =?utf-8?B?cjdINzdUMzIwaktRR3NYS2Q0Z2VWVnBpQUFqeGxsTUdoeFdVTDg3NGJCS25O?=
 =?utf-8?B?bTZpRks3VXByWEZCVTh2SDlJYllWMERuRDZydXFsRlNCSTZIblh6RElDM25r?=
 =?utf-8?B?UjdlZyt4UHdQaTZNMGpSbXNPNlJzZDBab0VPNFYyRzJEZDVDamdwbFBJUDFy?=
 =?utf-8?B?eDRFZmJCV1AwRlVQbDdRMmtad25sTG85UjI4WExvSnYyL0ozN2NkTmZKS3Z1?=
 =?utf-8?B?SHAweElJSU9LVGJ0bUpVVUsyUkpzRUpNUDBGMS9iZk5LU1MxYmFPRC9IQmxF?=
 =?utf-8?B?RWhhUURBOXA2bzdGN2M0ZlYrTHkzazltUGpTWWFPZWhIQmMyTmFjVFpReG1o?=
 =?utf-8?B?Q0VNZzQwRWJXeGUzOHozNVVsMTRkdGVGQUpDYjBLMW9LNnlDaHg0MG9UTU5j?=
 =?utf-8?B?YUV5MnI3Y0dUT285RWE2WDdlbkl0ZXlrcTJabWwyY0hjdnhKY1VkR2oyWEti?=
 =?utf-8?B?cHhDMnZweC9EL3poV0RDMlBJUzkyT3Fad2NKUEE0RXRpZzRQMWdpNFFsNG1E?=
 =?utf-8?B?d0VWN3I1dHJqN2ZXN1ZMOFZoSWlyTCsreDBKVlB4cUZXWVVUdEcxcFdjcStB?=
 =?utf-8?B?UlJyYXZFcXJMZ1ZPcXJlM2E1S1kxOTdhZUtHakxZZ0NjbzA4a2JoUjlNU0Jl?=
 =?utf-8?B?bnBabWRGT3RyUXJPMEtLSExWVy9CaE9QQjE1L2hsNDQwTkU2ZkdFTGcxczZx?=
 =?utf-8?B?RnJZN3BncW4yS2FYeWl2WDdrT3JlRit2N2NBVWFDb0UwT0ZBMGY3MzZRQ0NB?=
 =?utf-8?B?cEkwQWpqeHRKalFMUDlLZU45cjJjSlR0aDE1K0lwbDdNT2ZCTnJXUDN6amtr?=
 =?utf-8?B?SzF2b24vMWtwbDRieVozUFkzV09jeHplV0NkMERQU3dpMDllRTdCVTBvMjdw?=
 =?utf-8?B?Q0k1dC9FK1puK0JGSHhVZXJJUElGNDV4WmVLUmRRSDlQYmlmdzBERUdBdXgy?=
 =?utf-8?B?elUyWVQrQmZGckNJNU52ZnRvbzhUS1JVb2s3clozYWRmVXQ2TTVha3hRcnNP?=
 =?utf-8?B?YTBtOGxodURLaXI1dlIwT0NXbnQ5S0FQdlFLQVB5eFlnV2dUTXFqUnM2azh0?=
 =?utf-8?B?OHZBRVdLR1RDWHY3YUlnQ0NpanhwVXhqaUNDZ1dWak1HbGFsT1k1eHd4Q1pt?=
 =?utf-8?B?Mkk4bTV2RVloVE5IQldMSmVSZmNDdGw1eW5pR3lwRFlIRFlnRnEvK1FFRSsr?=
 =?utf-8?B?a29JRzNRWDI1RGdJSFFEQ2pxRzRTVXU3cTFwQ1EzcU5kdlRsaGVsL051VGFN?=
 =?utf-8?B?T2U0NUFubVpxa0NkTWRRbnU4b2ZoTnNqUVVBczRXM29mb1FoaUpKYTFuOXJq?=
 =?utf-8?B?VlMxN3JESW01TEMvcDlCVXZ4emFQamQ4TmVFMjNUOUFXZDlCS2Z1UTJNc1Uv?=
 =?utf-8?B?clNWSFpQaDBLaVRWM0RiakZyVTJlSkY2SDFIdStkY3VVcitlUnZoMkN5akd1?=
 =?utf-8?B?Y1R5R2hxb0dFQnRsekZHZEJMNHhEeXBnT1YzOWNaaERhYW1MeWxyVmJSL2RM?=
 =?utf-8?B?ejVpWHRlMlJTdWhJODVxV1p5YkFvK2s5a2pmbGppTDEwMUU1MVI5MW04c3l0?=
 =?utf-8?B?b3M3dEM0NEthZWl5WWNnWGFzWEsvblpTdFJ4emlnNzFJaytLZDRteEZPMWxs?=
 =?utf-8?B?cTJiSVNzdUJKSFNhL3MyOFRnRDgySU1Ucjc1Vy80SWhsV3RvTVdiR3ZUeGgr?=
 =?utf-8?B?YW5oY0tNVWNUVWlpS0NFNHkzejhvWnU1TkZ4V3pBTGhMOFM4R1hBLzQ1SDJV?=
 =?utf-8?B?aWtmL2ExcFRCeEYzS2xYdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTBQRW16RG5CTnk0M1Qrc255Y0M0bVFPbnBzMVJGK3B5bkZVWUhoa3JkbXRG?=
 =?utf-8?B?VzhPUmVDVUtYVkNzMlEyVlh1Y012WmM3MlNjQVhQcTVWdXdlaWpzU05NU1Yz?=
 =?utf-8?B?bkd6YWo0a2Y3MEl2ZEorR1ovdGREajFSdlpDNkJLSEpYbFBia3VUbFVJNzE1?=
 =?utf-8?B?cHg1dWNVTHBqb0lvcTJqREw5SzVWOUxZMTZWNEtzaXBGYnU5bjdtRWRuMW42?=
 =?utf-8?B?dmJhZSt2YnFnUm8xTEtuQ2wvcXYwOVpzaUxvcTFMMzB0Z2JWS1dyN1V6OVd1?=
 =?utf-8?B?VW96K3l5WEZmaWJ5UE1vMFA0QzRkcXlEeWh5MTRNTlJsbk4zY3IvcjRTWk5R?=
 =?utf-8?B?QXNVck9MRWVPbWhra0Nub2tjcjNyOHBjY1F3S1FQLzNURUtSemhXdlFZalRh?=
 =?utf-8?B?Rm5zY3NON2M5N1lUclhTcVI0UnRjRGErcXFEdHpKKzdQMzFKelQ3cnVFcTRo?=
 =?utf-8?B?OTMydVIxMUV5aXJ1ejlsUy9XZ2xRQXp2RlVvV2g1c3Q0WFpYYy8zZ3lPVXQ2?=
 =?utf-8?B?UTNXN2Z1S0lsdUJ2NStSOHVlQ0ZNakRsbXN2TUFrZVBMQmp0aFNXY3gzUEw5?=
 =?utf-8?B?YnluLy9JSnJzcUdhRUtnVFNRclB6c2NIemxqWGZUNXhNNXcwb2xzajl2dWph?=
 =?utf-8?B?UlZBOFA2aUVpZmpqZjBDT01HVDVyaTRPZ25ldk96NENBYjlKMW9lbnFmNExG?=
 =?utf-8?B?K1lsbFptS3g3WWJGb0VmamNhWldYVkJBQUVaTnl0T0daWktxdk9ZOGxKbUQ5?=
 =?utf-8?B?ak5reE56S1dIZFpHZ2Rrakc5bXRnbjFaUXp5RWM2cHc0QXdhUlNvZlErUUl4?=
 =?utf-8?B?cjlnWmNNRVkwSHltNWN3UzM5d2V1SkF1b2N3bXJkbDErUUJ2SmZqcFJPS245?=
 =?utf-8?B?L2Z0dmNzOVp5SVJXOCtnVUphWDh0L2VTNFovejlTN3Zpb2ZDMy9aa1dRS1hH?=
 =?utf-8?B?VlVnWUxaTjQ1L1l3NFFlc0tFcFJTN0lnVGR6TmtsT0pYMHB4YTFBNW1rcFhG?=
 =?utf-8?B?TTgxWGZKZkxrck5XUDJJVEoyaytBZGhRUnlpRElVY2xyczh3c0NuUXhyY1Ro?=
 =?utf-8?B?dVc3LzBPbld5MFQxR2RKWm1VR3A1R3FoeUlYc1lTUFlTYkU5WWc2Qk9RMEhP?=
 =?utf-8?B?ZHBlTmpVdnNoTm1qT3pla1Vlc0Mvb25GcThGVTJXUkxzdDNWNXpoR0VaQmNJ?=
 =?utf-8?B?UHFoYkpjcXZBQytoR3NWMENPcUZvbHRuNnNWUUk0YnI0WnNmMjBpMC9BQ3cw?=
 =?utf-8?B?QTNpLzVldEV2R3FpajVNOFRzTHhuQUwyU1N2dXJLRjcrQVJpWm9WR2cyaGRw?=
 =?utf-8?B?UE1keGhPa2VNaHcwRnlud0JqUW4venpQd3g5V1ErbHE4K2ZHYUtzcTVGZDYx?=
 =?utf-8?B?T1dpQUp1amlpclR1UlF0RW4zMCt5LzAvdUZVVVhyVmpRdlNjb3FqZm5DaGZC?=
 =?utf-8?B?YW8vUi9BeTNlZUxQMUt3dEhSam9JM3FRVlpIekhOQmNNVWpkcHdsSmliZGdw?=
 =?utf-8?B?ZWtDOS9aNTBJWFM1MDRWcjY4eEc5V1p4dUo5cjJmSjQ2NVQ1Vk9Eb0FHME5G?=
 =?utf-8?B?YXhmUE1iMXhZS0l4ci96WGN0OXVZcEhEdUFkNW81V0grTkF1L3dRVThWUi9Y?=
 =?utf-8?B?Z3FjSUJIc1lySTUxWEp2MDlTMlFOQjdMcHlNOE1kV0JTMGhmM1IrdHNxQXl0?=
 =?utf-8?B?Q3VlajdFUmNLNUJhN29NOHYxYVk5cXQwQ3N5dU45S1BERC9CSTZLWFhWRXNj?=
 =?utf-8?B?UFBkNXdWY1cvKzBiY01INnNOd1JTYVdldE14MkZPWGE3QTdNQXJxL0pMLzd2?=
 =?utf-8?B?Y3NLN1B6d3dqbFh3Tm5WNEpFNUh1VTcrN3FHR3lpbEIya2NQVnNQYWFPZDNQ?=
 =?utf-8?B?MGtMQ3hrZzlkZU5Ed0xsVTU0alBkMk9KNitlajloaWhveWUyRWF2cnRGenN1?=
 =?utf-8?B?cWNEMUpxSnA3L2dIeDlQaFUwdnEwQWdYVEdmOTNZVmp6TGRqUGErMzRMd0kz?=
 =?utf-8?B?TmUyNFAvRWtaZmo0QWJ6WG5QT3NMeFphRmdFVVBTM0NNWmdIeWNlL3BrRXZz?=
 =?utf-8?B?RkNVNHdGaDBHdkQrazR2eW9CYW9YVFNOVXJjQ3lVWUVpVEdmd21oYUhQNkJX?=
 =?utf-8?B?QnNKL3hLYjhNOE8xTHV5eTNtZUFSMGQ1V1Jndms3eWpOeGVpVFk3aDBuZzFN?=
 =?utf-8?B?TVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9812003BAC72F64A85F12B8BEF7B0074@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d3c89cf-2595-4d4e-a6cc-08dcdddd995b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2024 03:45:00.9784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Om3f6EcoOA+xAOk4ypTlZ9uQDH+HQXPioEw/b7+9eOAmcP3Wr7ZINS3spUBWgOskrQdM3t3ZPDtjuaEWx10Hig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB7778
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--26.164300-8.000000
X-TMASE-MatchedRID: WTos3XtpXXHUL3YCMmnG4qCGZWnaP2nJjLOy13Cgb4/n0eNPmPPe5KWz
	WoIRiV9DM/Se/q/gEyf5MiS7M8c1eGmXMi7Ntyo2h6L+ZkJhXC75VvfCjIxlu5722hDqHosThbV
	Mkp0EYS2Swven6SLadWT0vgE7/EjyifsNgXDdrIZc/msUC5wFQbWTdtEh1dU0Yz65TQfoDKuekU
	e/IaaTe9NMgpwiCdrBpdP/fMo9biogNXYDo2rRhgQltCwQIo7q0i/hFXziUdMLBZEuqIL9Sm4hp
	sElq5SAQXN53Bmxd465SH5OKXgi84ROGxV+hioHhsE+u3nnCfBMkOX0UoduuRBVEcLcHoVg+1By
	sa1PtqTxvq34rGhiN7mo6TBV+X4XSBPgTBB64OtlI0vGyCjKv5hkkqJeFHotmyiLZetSf8n5kvm
	j69FXvEl4W8WVUOR/joczmuoPCq2UTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--26.164300-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	C584EED433A3866B20C755C7D2CF25C55D74192D3AFEF07EE833A0F8D2510D7A2000:8
X-MTK: N

T24gV2VkLCAyMDI0LTA5LTI1IGF0IDA5OjQ5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8yNS8yNCAyOjU1IEFNLCBwZXRlci53YW5nQG1lZGlhdGVr
LmNvbSB3cm90ZToNCj4gPiAgIGNhc2UgT0NTX0lOVkFMSURfQ09NTUFORF9TVEFUVVM6DQo+ID4g
ICByZXN1bHQgfD0gRElEX1JFUVVFVUUgPDwgMTY7DQo+ID4gK2Rldl93YXJuKGhiYS0+ZGV2LA0K
PiA+ICsiT0NTIGludmFpbGQgZnJvbSBjb250cm9sbGVyIGZvciB0YWcgJWRcbiIsDQo+ID4gK2xy
YnAtPnRhc2tfdGFnKTsNCj4gDQo+IFBsZWFzZSBjaGFuZ2UgImludmFpbGQiIGludG8gImludmFs
aWQiLiBPbmNlIHRoYXQgY2hhbmdlIGhhcyBiZWVuDQo+IG1hZGUsDQo+IGZlZWwgZnJlZSB0byBh
ZGQ6DQo+IA0KPiBSZXZpZXdlZC1ieTogQmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5v
cmc+DQoNCg0KSGkgQmFydCwNCg0KU29ycnksIHRoaXMgdHlwbyB3YXNuJ3QgY29ycmVjdGVkLg0K
DQpIb3dldmVyLCBJIHN0aWxsIGZlZWwgdGhhdCB0aGlzIHBhdGNoIGlzIG5vdCBxdWl0ZSByZWFz
b25hYmxlLg0KVGhlIHJlYXNvbiBpcyB0aGF0IGluIHRoZSBmaXJzdCBwYXRjaCwNCiJ1ZnM6IGNv
cmU6IGZpeCB0aGUgaXNzdWUgb2YgSUNVIGZhaWx1cmUiDQp3ZSBjb3JyZWN0ZWQgdGhlIElDVSBw
cm9ibGVtLCBhbGxvd2luZyB0aGUgU1EgdG8gY2xlYW4gdXAgDQpjb3JyZWN0bHksIHdoaWxlIHRo
ZSBDUSB3aWxsIGhhdmUgYSBjb3JyZXNwb25kaW5nIHJlc3BvbnNlLiANCkJ1dCB0aGUgc2Vjb25k
IHBhdGNoIGRpcmVjdGx5IGlnbm9yZXMgdGhlIENRJ3MgcmVzcG9uc2UgYW5kIA0KY29udGludWVz
IHRvIHVzZSBhIHdvcmthcm91bmQgdG8gcmVsZWFzZSB0aGUgY29tbWFuZCByaWdodCANCmFmdGVy
IHVmc2hjZF90cnlfdG9fYWJvcnRfdGFzay4gDQpUaGUgTGVnYWN5IFNEQiBtb2RlJ3MgYXBwcm9h
Y2ggd291bGQgbm90IHJlbGVhc2UgdGhlIA0KY29tbWFuZCBhZnRlciB1ZnNoY2RfdHJ5X3RvX2Fi
b3J0X3Rhc2suIA0KSW5zdGVhZCwgaXQgcmVsZWFzZXMgYWZ0ZXIgdGhlIERCUiBpcyBjbGVhcmVk
Lg0KDQpUaGVyZWZvcmUsIGFzIEkgcHJldmlvdXNseSBzdWdnZXN0ZWQsIGl0IHdvdWxkIHByb2Jh
Ymx5IA0KYmUgbW9yZSByZWFzb25hYmxlIHRvIGRpcmVjdGx5IHJlcXVldWUgdGhlIEFCT1JURUQg
Y29tbWFuZHMgDQphcyBzaG93biBpbiB0aGUgcGF0Y2ggYmVsb3cuDQoNCi0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
LS0tDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYyBiL2RyaXZlcnMvdWZz
L2NvcmUvdWZzaGNkLmMNCmluZGV4IDI0YTMyZTJmZDc1ZS4uMDZhYTRlZDFhOWU2IDEwMDY0NA0K
LS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KKysrIGIvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYw0KQEAgLTU0MTcsMTAgKzU0MTcsMTIgQEAgdWZzaGNkX3RyYW5zZmVyX3JzcF9zdGF0
dXMoc3RydWN0IHVmc19oYmEgKmhiYSwNCnN0cnVjdCB1ZnNoY2RfbHJiICpscmJwLA0KIAkJfQ0K
IAkJYnJlYWs7DQogCWNhc2UgT0NTX0FCT1JURUQ6DQotCQlyZXN1bHQgfD0gRElEX0FCT1JUIDw8
IDE2Ow0KLQkJYnJlYWs7DQogCWNhc2UgT0NTX0lOVkFMSURfQ09NTUFORF9TVEFUVVM6DQogCQly
ZXN1bHQgfD0gRElEX1JFUVVFVUUgPDwgMTY7DQorCQlkZXZfd2FybihoYmEtPmRldiwNCisJCQkJ
Ik9DUyAlcyBmcm9tIGNvbnRyb2xsZXIgZm9yIHRhZyAlZFxuIiwNCisJCQkJKG9jcyA9PSBPQ1Nf
QUJPUlRFRD8gImFib3J0ZWQiIDoNCiJpbnZhbGlkIiksDQorCQkJCWxyYnAtPnRhc2tfdGFnKTsN
CiAJCWJyZWFrOw0KIAljYXNlIE9DU19JTlZBTElEX0NNRF9UQUJMRV9BVFRSOg0KIAljYXNlIE9D
U19JTlZBTElEX1BSRFRfQVRUUjoNCkBAIC02NDY2LDI2ICs2NDY4LDEyIEBAIHN0YXRpYyBib29s
IHVmc2hjZF9hYm9ydF9vbmUoc3RydWN0IHJlcXVlc3QNCipycSwgdm9pZCAqcHJpdikNCiAJc3Ry
dWN0IHNjc2lfZGV2aWNlICpzZGV2ID0gY21kLT5kZXZpY2U7DQogCXN0cnVjdCBTY3NpX0hvc3Qg
KnNob3N0ID0gc2Rldi0+aG9zdDsNCiAJc3RydWN0IHVmc19oYmEgKmhiYSA9IHNob3N0X3ByaXYo
c2hvc3QpOw0KLQlzdHJ1Y3QgdWZzaGNkX2xyYiAqbHJicCA9ICZoYmEtPmxyYlt0YWddOw0KLQlz
dHJ1Y3QgdWZzX2h3X3F1ZXVlICpod3E7DQotCXVuc2lnbmVkIGxvbmcgZmxhZ3M7DQogDQogCSpy
ZXQgPSB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soaGJhLCB0YWcpOw0KIAlkZXZfZXJyKGhiYS0+
ZGV2LCAiQWJvcnRpbmcgdGFnICVkIC8gQ0RCICUjMDJ4ICVzXG4iLCB0YWcsDQogCQloYmEtPmxy
Ylt0YWddLmNtZCA/IGhiYS0+bHJiW3RhZ10uY21kLT5jbW5kWzBdIDogLTEsDQogCQkqcmV0ID8g
ImZhaWxlZCIgOiAic3VjY2VlZGVkIik7DQogDQotCS8qIFJlbGVhc2UgY21kIGluIE1DUSBtb2Rl
IGlmIGFib3J0IHN1Y2NlZWRzICovDQotCWlmIChoYmEtPm1jcV9lbmFibGVkICYmICgqcmV0ID09
IDApKSB7DQotCQlod3EgPSB1ZnNoY2RfbWNxX3JlcV90b19od3EoaGJhLCBzY3NpX2NtZF90b19y
cShscmJwLQ0KPmNtZCkpOw0KLQkJaWYgKCFod3EpDQotCQkJcmV0dXJuIDA7DQotCQlzcGluX2xv
Y2tfaXJxc2F2ZSgmaHdxLT5jcV9sb2NrLCBmbGFncyk7DQotCQlpZiAodWZzaGNkX2NtZF9pbmZs
aWdodChscmJwLT5jbWQpKQ0KLQkJCXVmc2hjZF9yZWxlYXNlX3Njc2lfY21kKGhiYSwgbHJicCk7
DQotCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZod3EtPmNxX2xvY2ssIGZsYWdzKTsNCi0JfQ0K
LQ0KIAlyZXR1cm4gKnJldCA9PSAwOw0KIH0NCiANCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KLS0tDQoNCg0KVGhp
cyBwYXRjaCBoYXMgc2V2ZXJhbCBhZHZhbnRhZ2VzOg0KDQoxLiBJdCBtYWtlcyB0aGUgcGF0Y2gg
J3VmczogY29yZTogZml4IHRoZSBpc3N1ZSBvZiBJQ1UgZmFpbHVyZScgDQogICBzZWVtIHZhbHVh
YmxlLg0KMi4gVGhlIHBhdGNoIGlzIG1vcmUgY29uY2lzZS4NCjMuIFRoZXJlIGlzIG5vIG5lZWQg
dG8gZmV0Y2ggT0NTIHRvIGRldGVybWluZSBPQ1M6IEFCT1JURUQgDQogICBvbiBldmVyeSBDUSBj
b21wbGV0aW9uLCB3aGljaCBpbmNyZWFzZXMgSVNSIHRpbWUuDQo0LiBUaGUgZXJyX2hhbmRsZXIg
ZmxvdyBmb3IgU0RCIGFuZCBNQ1Egd291bGQgYmUgY29uc2lzdGVudC4NCjUuIFRoZXJlIGlzIG5v
IG5lZWQgZm9yIHRoZSBNZWRpYVRlayBTREIgcXVpcmsuDQoNCg0KV2hhdCBkbyB5b3UgdGhpbms/
Ig0K
