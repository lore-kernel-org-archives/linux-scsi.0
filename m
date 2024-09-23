Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867A9F9D4
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2024 07:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727075255; cv=fail; b=Vgedjn9ABm0NuSDlHnW9SX0PedqoajFeTqNgLNs+9DEXbyzI37un04pTmoPGD7uwNAwjHAu6r1ckphPGvVletqIy88O/uvyT0V54VvHvCZAjVUdhcLfeQgdyg4x1jIwn8gt/2TgUIut1lqlY2i966LHB+tNA98tk3TCrde97rOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727075255; c=relaxed/simple;
	bh=JTY3kgv3DssNl9PuArtoYOiL2EYE+Aq5fXV/i1ickDg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=otCi1psHmatOMCVjX/VLjuKCsW8zwG2zhUOiZQgrbS1I71jIjKulB7GWo4P3y+gCE2+XycqJC7k5WRj8AX7szJ2Ro44HisN+30TPuUpQSKbWhAGX5692UTkt5k1Vrh5pllncnvZ823HXl406D0OTStT4sZzb4TyxDJr6Ja6WqVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=HSqYxSVP; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=k5LS4kMW; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HSqYxSVP";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="k5LS4kMW"
X-UUID: 7f0d066a797a11ef8b96093e013ec31c-20240923
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=JTY3kgv3DssNl9PuArtoYOiL2EYE+Aq5fXV/i1ickDg=;
	b=HSqYxSVPlwOT9H+SoM1+G9k5VSbQQXR2wyTqSM5otGnaVvWOxj6fWlIyP/Yr7ctOVLSXU8w4R0jXCu+/KZYmV1GD9QT7G2zYGYGrZMLYBausIA4JvxW4mLuWmpNwWxb7UdO3TmqjaTsPDsNXvUZcIstFLrOHHIIeJA/qyzicQNM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:be344d18-5b65-44e3-98e0-3b33a3d3f265,IP:0,U
	RL:0,TC:0,Content:1,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:1
X-CID-META: VersionHash:6dc6a47,CLOUDID:e96d9cd0-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:4|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 7f0d066a797a11ef8b96093e013ec31c-20240923
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 281125236; Mon, 23 Sep 2024 15:07:29 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 23 Sep 2024 15:07:28 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 23 Sep 2024 15:07:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IrlT5+0/bGQ4JSqZan60Vi2TxZ08E8vfdB8Uz5eaPEE2/RcgvSHaR0JMI/eEqHxug7yg6NDW0jDSQ4/kuMovtRnjDTtxDwfdpxnUsaaBoFUvoiIGqmkqAiKqF8O7u7X2fksbXN94X+EZDlJdLCdk/0j/mOsUXd6d75iXF2RYHMOjRCon87wIRTJYDMTDYTkd/i9q97dlCNoaAaXXXPqi7L1xKAbAzcgav2MbI3bmj6WfKa6qYCIsMr5KKm8aoCPVlB+epb+YSkK+r+7Jtop1Su5eB0OSqKpt70aDThg3dJorw3D6Qg/ehrH2A+IovX5ktLG1HZuZOZ4v5yvHoTqRvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JTY3kgv3DssNl9PuArtoYOiL2EYE+Aq5fXV/i1ickDg=;
 b=bIiofdNC1opX29zgK1A+QNCPZ1VgfeutCuiq7xaynsk3yfcVYMqmEZl7pZwO9MkBpDlg0ABVJB6Z/zJPZKIt/sZ/ZFrMyi9Gk18GdOvaWR1YBm/xK34gJu/mJuCJ2nkweoXnVNnLSUjuj4LhVRQ/YYfvyZfdrt7O0kUSlyj4ATvGxwW/9m7d8Ycx9wKezrgvOFPiObxqO0+SydzjuKHcwPbtizqC1qmvqBdzKdazf9C/ScycXFDjy4Jf3hE1kdAxqDOVaHantmgHjHan3GkjShNFuxS2LRVRiOU/zrOzKKl/WMH6Y7mErkAdoUnQse3GBVtygdqLKbOFaqEGpMsKhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JTY3kgv3DssNl9PuArtoYOiL2EYE+Aq5fXV/i1ickDg=;
 b=k5LS4kMWR+sayBFzYqp0z5P1CUqLdbW592Cq+GqvAah8PWmy5qJeXaY3emA0cZQDCxQHWQkcqfQdeWNrJOlQyySnddg2P12rUWsyEQy5N2aUHMvAoxUDgoPt+zdNYhtQRcy4I1UwxLOADvrG84F+bp4UJ4FYg12o9eSNUyezrwE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI2PR03MB7264.apcprd03.prod.outlook.com (2603:1096:4:1e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 07:07:25 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 07:07:25 +0000
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
Subject: Re: [PATCH v7 0/4] fix abort defect
Thread-Topic: [PATCH v7 0/4] fix abort defect
Thread-Index: AQHbCzxtCx7mW/hOMEOh8TQ8rtuFyrJhEjaAgAPlzAA=
Date: Mon, 23 Sep 2024 07:07:25 +0000
Message-ID: <5cf7513b18e36522f3de38c6acb44b09c9e369da.camel@mediatek.com>
References: <20240920090643.3566-1-peter.wang@mediatek.com>
	 <56d48010-13d8-4bfe-8b71-85699c1b45ef@acm.org>
In-Reply-To: <56d48010-13d8-4bfe-8b71-85699c1b45ef@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI2PR03MB7264:EE_
x-ms-office365-filtering-correlation-id: 5c3bb369-3f19-47ab-4229-08dcdb9e60f1
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YWZ0RDNhWmFseXEwYTVLd1F0ZWMxQWE1T2ZwWGhHZ2pWaHpHZTdNNW5GZUdp?=
 =?utf-8?B?WFZoeUVNRm5lZWtwZ3hWanJMbVF0My82aSs3SlpNcG1UQldsZUF3MC8wZGZB?=
 =?utf-8?B?VnVHZk9BalR1VElEa3doTmRMdXFFZnpjVDY2aWI1NWlDWFNhcXFvaHBoaktK?=
 =?utf-8?B?Q3pyWGtTcFJiN2MyVy9HN2t4d1FuVzFmNm5pWHRUMDNCOVRIUW5NZzBvRStB?=
 =?utf-8?B?V2Q5VytxUXZKQ1pYR0Vza05pUHZwNW1WSEw4bDBHREZyV2RNa3Z6aWVvWWdw?=
 =?utf-8?B?djNJbk5hblpmQWNUVXdVVVU4MjBTc1Q2V1BXQlNrTWVZQmxzd1p4RWw0aWNq?=
 =?utf-8?B?K2pyQXJuVDdEOTdWeENrMWswK0hzbVFja3pYRnlLYVM4aEFGWE83U0VHeGty?=
 =?utf-8?B?VWRvSlhyRFI4MUlNSUovQ3doY3lETDN4M2VubUxqUXBiTUtrU05VWU5LN3hv?=
 =?utf-8?B?QzdvZEdUWmVLaTJ2R3VhWkgyR1lDS0pRL3JSNExEN2JsRk9scUluVlh2bXJJ?=
 =?utf-8?B?c1JPZS9GUG44LzkxVTcxcGVKUldWTHlxcTVUanEvR0JwUEN3dzNFSkJtdzlO?=
 =?utf-8?B?UTdRc1BMbDE2RHlOSHYyM2VLMWlZWDQ3ZUxab1htblNFNWdTVU8zZTc5VXhZ?=
 =?utf-8?B?Zmx5aFNaN0VBby9ya3BXU3h3RlZBY0tBamNKSWgwWkQ5MFhIVEtqbFE0THBJ?=
 =?utf-8?B?ZFV6cXl2eVVqT0F3T1lEd0ErREZtQzhHd1JGMUJ4ZkhHdFNRS3JBVzlMdkFm?=
 =?utf-8?B?TlViS2U1UktVbSswTVhLODNDVkZjdVlpZGtKU0JMR0UvVyttNkVsSXlzQnBY?=
 =?utf-8?B?VmdnVG93UmhUOXhDRXAwc3hCTFNTeWpLYWhwbE9kM1FrZ2NjeFpRSHoyZHc3?=
 =?utf-8?B?QVJDN1RiM3NZSlVieTRJaGRjbjBkMmxCRTI4ZXFadlhJTVVLRFZTWHVkY3lq?=
 =?utf-8?B?T284SWdBajNtYWdIdlZGTUprR0tNV2dSR1hvbDZ0QVhiNUxwdElqVGVrazJs?=
 =?utf-8?B?Q0QrR2tUTnVSVFhpNGphRW1KSG9SV1gzaDNOQUU0dkZIeWFHQ3B2WEE3eDYy?=
 =?utf-8?B?enlva1I1Rk55clhjNisvdk9Ia2lpd3RqcmxCWVYrZXJ1bjJlTjNTbE9kRFp2?=
 =?utf-8?B?ZVVRQzZmVTcrY1ZGR3NLRWRhWVUxNldJWVM2VFZqYys2REw5Z3l5OGRnWUVl?=
 =?utf-8?B?Vkp1QW5kbXBNQ05lUEdXaCtXT3BtbURXaDVyYWlQMnhDaWRRR0NHWVZmYVBs?=
 =?utf-8?B?NUNyNTNDMFB5S0tsQW1JM2dsVzFMcStNV1FqV3lIdmJybEZMMEltMy9iZFNJ?=
 =?utf-8?B?eS8vZXVFL1MzaWdPRms3bjQ4cmlXdU92V05ZSm9WWUtXN2NIRlpod1FuRUZ4?=
 =?utf-8?B?dUErZjhETE94Mlp0YlBKT3NLa0ZqcGZIM3hMQ3NoRytDRnpKU2Q2YUFjS01x?=
 =?utf-8?B?eEJIYXBhNTVQRFlxTjZ2czBmVWJKYVpUbmo0eUdKVERkR1BQam42bkpEYzd4?=
 =?utf-8?B?cUlmd0l1c1NqOTZ5NHNPTmlIeWtBcGNDRyt5Vm9kYmpIVXBFUGd3QUl1STJQ?=
 =?utf-8?B?SlRBTktWT3lpbzFTRURsa2l4cG4wcjZYekp2OTlBTzBwWkVla01iZVhPOXVH?=
 =?utf-8?B?VEZycWdsVWhCRGdDMy8zcEpjMGJjZWU4eklUU3RJUWQ4VEE2VG5LWW9yeS9p?=
 =?utf-8?B?Mm1YdWZWdlFFbnhZVjJLSHNOeDlSWlJUcENwY3Znb2xUTXQvVWt6blpJcktm?=
 =?utf-8?B?RXVUQ2RST3dqZjBRalpHeGZ3NnBCMkhKUTd1QzBJaUMxSTE3c1lSZ1pvQnRm?=
 =?utf-8?B?Q3VMQjJ4RGNlUUg0Sk51UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUE0cDltOWZEaWhkV1Z0MTJ2YjZjcERoYkdwVmt5ZVl0OHQ3ajhzVnU4RFY1?=
 =?utf-8?B?U0NrWlZDWFAybksyeEdqeVpQS01WaHNkK2VSRGMvRVFwZmJGcXBUek5UamUy?=
 =?utf-8?B?ME5OcmJFZnA3d295eGZNTnU5Y1djdkZqS1hhcHIwSzJ2RlZnQm4yTWV6dlNE?=
 =?utf-8?B?TkZCcGhqU3NPdEJ3V0JhZmpObC9KRE94VUh2Rk9JTWdDK1NzQlFCMHlZVXl6?=
 =?utf-8?B?OFcwdWJmaHB3VjNCRi9vWW5haWRsZXFVMWNLWGtjTGdlcXhTdHRPYzduRENp?=
 =?utf-8?B?WVZCS1dRajZxNUVzd0FwWU0rQmZaRVVnQVlRMXFIb2FtRjkxWGZVRnJlZkhu?=
 =?utf-8?B?M24rNHp0Y3U4alNqaFZBQ284V1lBdjc4UW1OaDZKaEtHRVFsNGRtby9VUmY3?=
 =?utf-8?B?R1NpbTRwUVI3TU5qUXFjV2hsWmtlK2VVTk56SnpFTGIzNURxK1hZTVFNR04w?=
 =?utf-8?B?aVFENmZTTTg4UytLakg1anhiOTVZanZNZ1M1aXZTKzRjQjVpWDZObHh5OUt2?=
 =?utf-8?B?cUQwVWY2OVZGdGlucktOMmFiT2FHMjlwaHNqbFpZU2I2SkdDOGkvQmhXRDZZ?=
 =?utf-8?B?YmVReFRyZ1owZWVyU3FUd1E1TStseHFwY2phK3F2QkZRSFh2bHNtRjZpRXNM?=
 =?utf-8?B?TUROUGJuU2huR1ZWR29LRWRuZmU1VFhxaStkL0JwU2YyV0k0cHFqemZLOW5K?=
 =?utf-8?B?aDYvejVmcWJ4ZnhRMEV4RXMrdmNrY3BtdGNNVjFZNVBuY25qdmJYbkU4N1JI?=
 =?utf-8?B?RkVXR0twbE50STRNbDdyUEsxSCtzeVBraXZQNGpyYnVDSWR0Z3pTS1lmZnpF?=
 =?utf-8?B?ZGZZNXlQYVUxMWdsUmVScDBwV1R2Vy9ua2w0R2JoUVY3cnRaRkR3RnltK3Z6?=
 =?utf-8?B?V1RYeUllNVQ5ZXlZR001bDMzZ0oyeEREUHVkTmVyMFAxRVFqdTdBejRJQUln?=
 =?utf-8?B?SExVRmpvSmU1VlJXOUp4WHUyRDZUR0R4cTRBRHNPVzdoajlra3dlZ3UxenAw?=
 =?utf-8?B?MDVaK3l6VXkzWEpQcFRqQzhwRWxxNEpWNFRIdzhpNnA3NWY4QjdvbmN0TENh?=
 =?utf-8?B?Rk1sOE5YUGJtZmZ4OC9LU1JhcldZeDFmTHJaeHIwOVhEUWU3L2dRalY5bHRD?=
 =?utf-8?B?L1hzQUZUbjh5b05sM0dzWnV6TG1CNVRDV3NJanFmZnNGd0NKRzEyM2dza216?=
 =?utf-8?B?VTkvU3pra1pSbUNBdWloSTh4Q0c5eUFUVWliM2NUZE1Uay9ycW5laFlEcDhr?=
 =?utf-8?B?RXpHR3N5QjBaSHFCRzg2eG9QK0ZNY1IvK1BSVUdScnVWaEVQWkZKNGV2SnlJ?=
 =?utf-8?B?RlJPMEtXVldLNTFJV0NyQ3FLbkpBcTkzZXZodk95QTBlUW1hUW01a2lJdER4?=
 =?utf-8?B?RXIyOWVwNGppMWVEVThYb0hjQnRBcGpvSmVKMXdDWVIzTEJCcEJJUG9zUHZh?=
 =?utf-8?B?a0lzNCtZaUR5U0J5Zk1HZVprdElJd1o5Y1lBZVp1VnJ5S1RWRGt6OXdIcjdP?=
 =?utf-8?B?QUNDU3RrelZnS05uK252dnFYcm9aTGk1KzRob3dib1VnaTh5aDEwT0xLOWZO?=
 =?utf-8?B?SGNYMnR6TFk0NXdJZDkwbW04TCtCYzR5M1QvRHFTdklxZmN0dlpLSkJ1bXJD?=
 =?utf-8?B?OGJJaXBGRThPTk4vdDVQTkVNSS9VS3JNNHdBVTJPcEFJRjc3cE9FVW5DaEZo?=
 =?utf-8?B?NlBnaFlUVkJaVzBnU3FtRmVmOWNWZUFjWXgyWUtrUjBNYy9LYnBqcjFFUHdU?=
 =?utf-8?B?QXFnWEZtYVIzTE94SGlkRlRqNGVHdC9vM3dVTGxhL0FweHRWUkE5eElFMU4r?=
 =?utf-8?B?U1plTVppa2ZsS2orbisxbVpkZnNxais3ZS8yR2E4am5oSFBCLzd0WXhtS0c4?=
 =?utf-8?B?ejUwcDdTcDRpRGcxV0RxS2xtaW83eVpMN3RtYUxzRHpyUjRMU1IyQlpiVC9n?=
 =?utf-8?B?QjR4UStOeHlIang2WVlBQmJoaXVxSUkvbWs2NXY4QWNjTmRVU0xMK1ptQXZi?=
 =?utf-8?B?bEtnTzBRM0YzZGtmRHJ6UFhKUUo1R2h2RTFiVnFNMlUya0g3NG9mVzI3ODZQ?=
 =?utf-8?B?aUlKb1kzMk81UzRZRHJsUThONXpPcVMxbzl5Nmk1YnUvMlA2VmZpVnRHN2VB?=
 =?utf-8?B?ZVVYc2RpK1FxZVNoSFJTYk9TZlhobmpzUTk3U3VzcjJKL0xtSlFYMElibmNn?=
 =?utf-8?B?Smc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A54EC2B1524F74EAA227A96A6F54EE1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3bb369-3f19-47ab-4229-08dcdb9e60f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2024 07:07:25.6879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L7q1dIFbaxkwrf6XPjRy0ueaFz1167RmpJAgvP21u2Bh+M7TnmGh23KUUwnH/FmDCGuElGblTCMeIof2vcBkKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB7264
X-MTK: N

T24gRnJpLCAyMDI0LTA5LTIwIGF0IDEyOjM2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8yMC8yNCAyOjA2IEFNLCBwZXRlci53YW5nQG1lZGlhdGVr
LmNvbSB3cm90ZToNCj4gPiBUaGlzIHNlcmllcyBmaXhlcyBNQ1EgYW5kIFNEQiBhYm9ydCBkZWZl
Y3QuDQo+IA0KPiBIaSBQZXRlciwNCj4gDQo+IFBhdGNoZXMgMiwgMyBhbmQgNCBpbiB0aGlzIHNl
cmllcyBpbnRyb2R1Y2UgYSBzaWduaWZpY2FudCBhbW91bnQgb2YNCj4gY29tcGxleGl0eS4gQWRk
aXRpb25hbGx5LCBjb2RlIHBhdGhzIGFyZSBpbnRyb2R1Y2VkIHRoYXQgY2FuIG9ubHkgYmUNCj4g
dHJpZ2dlcmVkIGJ5IFVGUyBjb250cm9sbGVycyB0aGF0IChpbmNvcnJlY3RseSkgZ2VuZXJhdGUg
YSBjb21wbGV0aW9uDQo+IGludGVycnVwdCBmb3IgYWJvcnRlZCBjb21tYW5kcy4gSSdtIGNvbmNl
cm5lZCB0aGF0IHRoZXNlIHBhdGNoZXMgd2lsbA0KPiBtYWtlIHRoZSBVRlMgaG9zdCBjb250cm9s
bGVyIGRyaXZlciBoYXJkZXIgdG8gbWFpbnRhaW4gdGhhbg0KPiBuZWNlc3NhcnkuDQo+IFBsZWFz
ZSB0YWtlIGFub3RoZXIgbG9vayBhdCB0aGUgYXBwcm9hY2ggSSBwcm9wb3NlZCwgbmFtZWx5IG1h
a2luZw0KPiB1ZnNoY2RfY29tcGxfb25lX2NxZSgpIGlnbm9yZSBjb21tYW5kcyB3aXRoIGNvbXBs
ZXRpb24gc3RhdHVzDQo+IE9DU19BQk9SVEVELiBJIHRoaW5rIHRoaXMgYXBwcm9hY2ggd2lsbCBy
ZXN1bHQgaW4gYSBzaW1wbGVyDQo+IGltcGxlbWVudGF0aW9uLCBkb2VzIG5vdCByZXF1aXJlIGEg
bmV3IHF1aXJrIGFuZCBtaW5pbWl6ZXMgdGhlIGNvZGUNCj4gcGF0aHMgdGhhdCBhcmUgb25seSB0
cmlnZ2VyZWQgYnkgVUZTIGhvc3QgY29udHJvbGxlcnMgdGhhdCB0cmlnZ2VyIGENCj4gY29tcGxl
dGlvbiBpbnRlcnJ1cHQgZm9yIGFib3J0ZWQgY29tbWFuZHMuDQo+IA0KPiBUaGFua3MsDQo+IA0K
PiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpCZWNhdXNlIEkgZmVlbCBpdCdzIGEgYml0IHdlaXJkIHRv
IGludGVudGlvbmFsbHkgaWdub3JlIGEgQ1EgDQpzbG90IGluIE1DUSBtb2RlIGFuZCBkaXJlY3Rs
eSByZXF1ZXVlLCBidXQgSSB3aWxsIHRyeSB0byBtYWtlIA0KY2hhbmdlcyBhY2NvcmRpbmcgdG8g
eW91ciBpZGVhLg0KDQpUaGFua3MuDQpQZXRlcg0KDQo=
