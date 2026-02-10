Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57507B665
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 03:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770694870; cv=fail; b=EjM83ERUmrD2Uoe/pBgx2QedUo21BhR674TcI0lWpMHhrXyWpkirFOu1r2oirtM1Jxi0al6FoWaEsvaRYChX5O1AKdWJN4KAdnEpAls+eB7Iaw1kkVuudJgIJofEuNuzGKcZ4dfMfzc/5JHNryyyQa7RC81QguXa42Cdbb/NmJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770694870; c=relaxed/simple;
	bh=G8J6hkShxUxUkJPE5UrU23ZgDOP4/K5grFzD4HdVdDo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Kxn27WV4Fn6S2CNT0h9juGvvKJ9oxmSFpidrkU9wpi/rwL/oQf9YgBPxV5GYjV2lKdJ4cZe3T7Sz/NAFV/cBKTsJ1i8ZvxiWk06ZlUSBVVqVLQSh2YEhVsPp36Sht4PqR5u1WrTlcToXHcRyB2RC6WrhAMe3Aa/xRAEQF0PutfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gJtLC9qr; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=voj+2s5X; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gJtLC9qr";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="voj+2s5X"
X-UUID: 51e59986063211f185319dbc3099e8fb-20260210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=G8J6hkShxUxUkJPE5UrU23ZgDOP4/K5grFzD4HdVdDo=;
	b=gJtLC9qrnxoA+MHr5GcJixH72OvMCHreEL8VQBEvG0sY3NduKepHGYaQG73rgKS5N9q+RsHyUFxM1tkinIef6j8755fAVF/dpCHSGGBil6PFGoZNooLEvM5IPY9RYMuHhaEYUtanIk7iohmjFDLotm+SqrSCFzSANAeVXqFIUfQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:b8a8f4e4-7b14-42e5-a491-99f2127f818a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:eb11c87a-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 51e59986063211f185319dbc3099e8fb-20260210
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1154439252; Tue, 10 Feb 2026 11:41:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Feb 2026 11:41:00 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 10 Feb 2026 11:41:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbY5npECPise9BG3Bx0+xnOrl3hzzWs4r7Xj+lmcDgVHaJjIT/Y+BAQoObP0JX9HTDc9rY4xZ5EgddO4sAa+TR49XDpUnVNBaylDhfXpOUmiOMoecLMolEcePULAZSp5KFF5K0m/t2Uw88ATWYFm+GK8lMj/2c+J/qeym6AZpBzxxt+L5JM2C/jRCmuUlLavtB4jvuRLw2Se/EBHaLd+BZMmZ1MojcoPxz6Q3+TdO7xe164spFUVyE0oRvYxolFEqQFWC755su/bwxO9FJrxBimOZuFflFMGoI2lJvjtMi2h9LsOK6YfiZyhpQsQDiW1+QEcNjr+VIh7+hV2mQp+bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8J6hkShxUxUkJPE5UrU23ZgDOP4/K5grFzD4HdVdDo=;
 b=YNAGKgNAWSfBGyLbfHUdZK5JOHtzDbhxj8jWJLYFHy3ObQSbF4kGveL0CQbz2o2jxKzyhMB/ueTUXPt/EicejX4dNRvOLM+jX+YrQ1gMZkVpNL8Uw/UaZUeN2PsMYDpLI9evvB47oBdWZNMNwKx0pm+X1YG+4JDM8Xl4ZC4wa94c/CLTD/q2KjFRKghtb64Np1KFrK5wDKm7BDLCz3E3oli5QtoRP3CPrmzKrnLGBd21VnKOM6L/zby8lAaO30XQlQhGw2JvdUx9JPiPvU09mKvGvw7iz+YcIzEFfqS5/VbyTs7S6vms2+yuCUP+spOn6/eS8x6muPcMwoOHcMkiew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8J6hkShxUxUkJPE5UrU23ZgDOP4/K5grFzD4HdVdDo=;
 b=voj+2s5XPDAwYpNQaH77Oq2mvyMzLk2OG7PvdS+OVNsM4ZCVG4rxR2OJARNuq7lstqF+CGGCv8rSJPtVsGdcKse3Q2018qC0rH/65ujqC1h7F6k9HAgLF4e36//QCwZqYzjasbtQHEZFbF+yD7cK1JGCCZ0a6DdXFbjPQHyfqPo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KUXPR03MB9643.apcprd03.prod.outlook.com (2603:1096:d10:5f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 10 Feb
 2026 03:40:58 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9587.016; Tue, 10 Feb 2026
 03:40:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1 1/2] ufs: core: add debug log for uic commnad timoeut
Thread-Topic: [PATCH v1 1/2] ufs: core: add debug log for uic commnad timoeut
Thread-Index: AQHcmZ5+/A6mUIR89kqipbvJkdrcqLV6lv2AgACz5YA=
Date: Tue, 10 Feb 2026 03:40:57 +0000
Message-ID: <e423a3546c68262ca9163b57f7cb7f298322f4a5.camel@mediatek.com>
References: <20260209083053.1467647-1-peter.wang@mediatek.com>
	 <20260209083053.1467647-2-peter.wang@mediatek.com>
	 <6241685f-fc24-49aa-96f9-c2a69a4cee75@acm.org>
In-Reply-To: <6241685f-fc24-49aa-96f9-c2a69a4cee75@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KUXPR03MB9643:EE_
x-ms-office365-filtering-correlation-id: c135aaf7-c3a0-454e-ccc0-08de685633ad
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UTJTdC9vTUhKb2NhZUJjVmpyTkVrR1hESk5wNkh1b21VTUFFSjJwazl3Y2FP?=
 =?utf-8?B?S0lKSUhKY0tIN1M4VmwvNlhOSVNob3JkckhibG02R05sN2ZiUGhoT3NZS2Rw?=
 =?utf-8?B?by9WUGNLeVhNY1dEV2o5Qy9qSUZoUzR6Sy83dkQ2UXk5SGhLakxlK3RGekdv?=
 =?utf-8?B?Ti9EY0FoZDBBLzJjY0ZHY04wb3MxOFhUZ2p4T3Y3NENoNnNacHUzQUVaK1A4?=
 =?utf-8?B?Z1VYR2pMUTZMRDFLR3hKTldxYm9kRjRXRDFoV3RTTEpKVUxkMlRROFd6eC9L?=
 =?utf-8?B?eUZidWpsRVF4MkI3VlpPQmFRdkYyemtwV2tFTDM0WHM0RVhybE9nUkNEdGVE?=
 =?utf-8?B?aW0yVTMvVDF6dlFWMFlZZW9kYkp5bFo1YzFobGJ1ajRnYS82VTNnQVQ0bFRi?=
 =?utf-8?B?eWcvYWh0RENhUXpvV000aS9hUUduczZwSG5QdGRRb3lMeTJ6eDRiVVY5aHJO?=
 =?utf-8?B?RzVhVlk2KzRReTIyaVhvT2JhOXV3bWgxcE5qV2E0NVlUenZKeDFJRlRqMWxu?=
 =?utf-8?B?Wk5ObEIyZ3EvQTBPeHFTbEpuYlBmNHpzcEx4N3FINGN6UDJBVnFoRHA5RmQ2?=
 =?utf-8?B?NTc3eUJmTnVTdHdxSkpjOXlTYmtIdTRQOHlmc2lxR3oyZVU2UExIOFNvQk0w?=
 =?utf-8?B?N01qRStFOFVtKzI0MkZSNkt6SXhzY0hDamZ5dlQ5czBvMklYSjNKN05FOE1u?=
 =?utf-8?B?YnJkOElqRjBoSzdjb2gzc2ZiTjlVTTQveURvSUR1SzhJZWlMaXg3ODFSZ21l?=
 =?utf-8?B?QjFYc0JkNFp0blphZ0R1QmdSVWlOOWxGeW5mV29qRmxoZEttdnlNbFIrQ0Fh?=
 =?utf-8?B?b3EwekNxd0wxTndxdTVJM2pvVUdFdEhwR2xzaHEvaW9zTEprV1h6ZTRGbXMw?=
 =?utf-8?B?QUluQ2xaMm5SaUVxTUNOLzc4bCs3R1Q4WGd1MjhTeHhXR2lhSHc3SDU0WFJO?=
 =?utf-8?B?dTMweHBhUGkydXE1Z3BoVEpVUDMyN3RKODBoQnNkMUFUZEwwQm5SNnl6WXRi?=
 =?utf-8?B?MDNuWm9pYTlEMWpONG9DZ2ZMdHZGSGhvM2ErdGM1dVBDL3N4V0VlUTMwRWV3?=
 =?utf-8?B?dkhoZmd2SmNEVG11dkZkRXJ0dnN4SEtkZEVqOU8wazEwaEpETHAzdkVSMHJs?=
 =?utf-8?B?cnVUN2p0R3FFSnNSOFFya2piZzdxU1cxYzlyZ3hoMGlJcGtvS3lCSWNPdUh1?=
 =?utf-8?B?RHFQSnpyVFA4OXJRNXlLZ3J4V1V6cy9TVjQzd01Lb0U5M1JieWViSE05bmdN?=
 =?utf-8?B?elU2V252RmRmMFQrMDdzSXg1a04rUVNyc3V6UmgwN2dkNHFqbENBdm9Bd1BH?=
 =?utf-8?B?QmtwVXlkOEJtMWhWbHNnQXdGY2lSNjZBaEJlR3ZUb2loam10ZWdkd3ZzNFFQ?=
 =?utf-8?B?ekdhNjdNUGx3ODJsbm1wR1d3anpDdGdhNElZTGNiOEU4eTVLM2tGUFZHWUFj?=
 =?utf-8?B?c2IwTWV3SUFoZ3M4Nnc5YlpUbGd5Si9XT3N5MndUQWJjbmdLT0I0dWpFL2lF?=
 =?utf-8?B?RFl4M1VWZG8zeE16RDdXekdTaWtXYWRKTXhvZExzQnM2RktMWVk5Y1QvdXAx?=
 =?utf-8?B?QXhIaTR1UFVYVHNlVzQ0R1FwNVVJVForZGdSc3MwOGdmQW1aL05tTXZPL25V?=
 =?utf-8?B?czlWSlJIbXpTY2RYUXIyc2Y2WkZSZ1lsbVNqSjJpTGxpRUNUU0taTTJhbVRE?=
 =?utf-8?B?YzdnbG9zZ3d2ZXh6cWp5ZmlYOUFPWXRxS045cFYxM01vVnY2akFBaEo5OFgw?=
 =?utf-8?B?Q2hwbHZKVlhmSTFyV1lOT2tuejEvd3ZoTng0dlF0akxWdGxlT1BYcjZGS1lB?=
 =?utf-8?B?b0xDY3k5OXNWZDFid2I0WXRqT3hwOFllQTllR3Z6WTFhZTUzcE01R0dJZ0ZK?=
 =?utf-8?B?QlppSDJkRk9ZN0ttdEFXK0FNd0d5SE1lclFOQXhLbVo1V0kxU25obG9mVFd1?=
 =?utf-8?B?Mm9qbkcxMG5uR2owUC9tOEh4R240dTRHQm9RRklSTUFiNnl6TmhmK0tYSUsv?=
 =?utf-8?B?aFVUUXRxM2xDQ3E0Q3g3VnlCN1hseEh1UE9IMVV6cUFlY1p6RVk0ZGgwSU5x?=
 =?utf-8?B?TFRZaENycVNNZVVBczlzcFgwZ0RjUTg4QkUvWXM5N24wVDV3bUdYUXBKWk02?=
 =?utf-8?B?aTZDNXBUQ0tYNEZaZ2crVnRtNjdPMjlidlhBWGF6L3E3cnpuYmptNFg0dm9J?=
 =?utf-8?Q?nO7iEa4UxT1MxCqIxj/e7IA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGt0YXYvQ1dqUmwzeHdlRUVhY3A1bkxOK2d4R1lCUUFQUytLU0htYkRIUG5t?=
 =?utf-8?B?eUNFYklGL202ODYwemJraGljNWpCTEJsMXUrRmkrdXdXUXBDWlNMZEgwd2lT?=
 =?utf-8?B?ekdoaVBIZ3ZEeE9RUDM1Y29RdDBzN0ZZZG9sZmlzblFwbXZtUG5QLzNGcHFF?=
 =?utf-8?B?TEIrR2FTbUd4L3pkNHZnUlVnSjZVU1o1N0RYd0VDMjlsVHRBa2dvOEVsZUtJ?=
 =?utf-8?B?K09Yb3pEZDBiSHBsK0NENlJhY25oUlptRXNPcFRaaGNNY3RGM09QUjNPZ2dF?=
 =?utf-8?B?RXZVNjVUYktjLzFxL2l4amZ2dVl3TUlMRzRGZDd0RFJZdndzcEF0NnVxM0NN?=
 =?utf-8?B?dEdUNFY3aUkvRmNpU0hLZjhHc0taLzJXLysweS9MTm9ibU9HNndibnloQlhB?=
 =?utf-8?B?Q0FzUTJscUc5a0FPdysxS1ZQZGxkU0hUU1UyZDdzRHBxQUNuOXhtRzh4UFBW?=
 =?utf-8?B?ZXAzeGZ3bnNiRzgwQTJLcldwVFFWSjJDSEtzK280bkhVWk1MRHMzZXJSZ3pQ?=
 =?utf-8?B?M1M2ZlNBYmF4YVZ3cmlRcmh5Tk1VWll2MWRXR01YbVVsSE84eHcwelAyQSt1?=
 =?utf-8?B?dDVoZlppbnlTREtCVGxvV1pJNTUvZEN0LzZCVlZXZlAxOGlsWlB3UHYxbWYz?=
 =?utf-8?B?cUZlTTd4SnVTa0ZxTERZZW1IWUdkaHk2TG9Zb0JVTWU3Z1FEVUZPOHBGNDVw?=
 =?utf-8?B?bTBsMnh5Qi8vWjNuNnZBdjl6eWFFbjZQVG92TkV0bmZWOVF6SnZhNlZ0dFlJ?=
 =?utf-8?B?SEtVMExpbEZkQ2QrZ2lRaTFaeEZMTWJ3dmFBWXB6Qm55YnFpUzU1UFM3OG0r?=
 =?utf-8?B?VGlJU3BpTm5ja0h1SEIyUU12WS96VVgvV3hyS205WGQ5TVNMZS96emFDOUdm?=
 =?utf-8?B?bUdkL25EOXk5UDFkdElRZG9xSWQyTHQ0dTNRK3ZZeDVTcDVKd2hpOWZVMXVa?=
 =?utf-8?B?dGhtZm5tU2pZQlMrdEIrc3c4TVNjS0JlSXNEcG9peTR0VHVXZHh4cm4yUXFC?=
 =?utf-8?B?Z2tDU1JyZHNLU0NsQTFYNHgyN3hlcEVWb0lINjJFR1VEOFp3enA4b3kzNGJN?=
 =?utf-8?B?a201REp6VndCWlA5MGtKNFEyUnRJSGlXZ0tLS0pmNytiRGx5aUVHaXBhSHFH?=
 =?utf-8?B?S1ZEakxyK2FMa2NsN2N3T1ZXQVNmTVNPamVXUk14bktPREUrbW1JNjY4UmFD?=
 =?utf-8?B?ZkNFU21Vc0l4c0duQnJibU0rZHZVUGlsMUo2NFg4UlNIRUxHQU5VTG01RGI4?=
 =?utf-8?B?T1E5YVpoaE9peVAzS09LaWhiSU9UMmFKZmJsaElaYWRIUE9mWGpORlZPWDZx?=
 =?utf-8?B?V2wyakFwWE9SNHg3NkplUGs0VHk0c01OQ0ZPa0tpUVovYlZrRzNST0dQSXNj?=
 =?utf-8?B?RW9zVlI5MWZBdUY1blpqQmc3a0tjR3dqekJwd2FUNDB2cng1UzVVM1J2bDd5?=
 =?utf-8?B?RlBoZWFHbm9BVjhYNk96aEVxdGZqd1kzT0VmZHNQSTg0ZzV0WHY3OWl3NG5N?=
 =?utf-8?B?bm1scElubFRBL2dLUEpHdmRyN0RSK2trVU1ydG9lRE9pUTNyU090ZmZIYlNV?=
 =?utf-8?B?dlhaa2wwSWtxUVJQY1o4RUdtbjYxeW0wS3RzUVJzdTM2RG9heEgwQXhWWWJQ?=
 =?utf-8?B?a212L0E2K1JOeDJnK0hrYjR6SkNSN0EzcDVDUnRXMzZxV1FDcmwwc2d5bytO?=
 =?utf-8?B?MnRCdzg4R1VTUmU3cWRLeDZzU0ttc0JGL0txWGtzZk5ZdnVaRUg0dlZ5Y2Nr?=
 =?utf-8?B?SWFmeXRVdkFORmVmWG5PT0g2MTl6QU5FbmgrNG8wNXVEV0FRN2lnQjd5NkJl?=
 =?utf-8?B?b1kvRTNYRmc3T1RSVmRoMDZ0ZWdpQ0x5dkFpbmsrZkovR2FoRTRZWlFMVXZB?=
 =?utf-8?B?ZFFlcWNGT29OeFE4K2JMWkljK2hxVXhDQUwxS0dURW1hbXlTTzI3U2orNEk3?=
 =?utf-8?B?MEpxbU12bHREb1dHRGhZZTJ6TzFmNmJ3elI3WlByZEdxaTVFdGdubVNzZlJO?=
 =?utf-8?B?elMzVjMyWWZLYnd4TW9uSDZMQnRTNFQ2Z1o2N2dNemZTT0MvR1g4SG51cXE0?=
 =?utf-8?B?RFdPZlA1ekE4M2dRazUzR2FlbWhibWNCVDRJOUpPWWVmRm5qSXlVUXRJRWU3?=
 =?utf-8?B?NTdPZGY3UWprZlRGYXl5VlRFYmhmUmhoUnNlbzVkVS9nNjN6cllrQVEzaFBB?=
 =?utf-8?B?YnhGa1JPdlBUMGtubHZiM2Q1Nm1sVkNyOUFmdmFnVnIyNUhrV05seTJFQloy?=
 =?utf-8?B?RmhiTTBvQ3puRnhYc1grUldFNmNUb2VVRG1GUzNZZnd3NlJaNnBrcnFyajYw?=
 =?utf-8?B?eUNKc0VVVW5aeHdVamNRRGVBVGcwQlB5VEtQSXBtWEI4R0JDSlY4c3RERmdt?=
 =?utf-8?Q?FjvIoVJMQz9gyJeM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D01AD3885847514183DBFDFEB99AAB57@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c135aaf7-c3a0-454e-ccc0-08de685633ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2026 03:40:57.6296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KErRh73pd7WK4uRAGUQRV5VVTv3WqcTak5yxnjzXiHr4PRWDmXxYLzVkvRH5GHlM2e91cElOf8p3WYv6BsmcDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUXPR03MB9643
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTA5IGF0IDA4OjU3IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDIvOS8yNiAxMjoyOCBBTSwgcGV0ZXIud2FuZ0BtZWRpYXRlay5jb23CoHdyb3RlOg0K
PiDCoD4gWyAuLi4gXQ0KPiANCj4gUGxlYXNlIGNoYW5nZSAiY29tbW5hZCIgaW50byAiY29tbWFu
ZCIgaW4gdGhlIGNvdmVyIGxldHRlciBvZiB0aGlzDQo+IHBhdGNoDQo+IHNlcmllcyBhbmQgYWxz
byBpbiB0aGUgc3ViamVjdCBvZiB0aGlzIHBhdGNoLg0KDQpUaGFuayB5b3UuIEkgd2lsbCBjb3Jy
ZWN0IHRoaXMgdHlwby4NCg0KPiANCj4gPiArwqDCoMKgwqAgaWYgKCFjbWQpIHsNCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldl9lcnIoaGJhLT5kZXYsDQo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIk5vIGFjdGl2ZV91aWNfY21kLCBtYXkgdGlt
ZW91dCBhbmQgYmUNCj4gPiBjbGVhcmVkLlxuIik7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgcmV0dXJuIHJldHZhbDsNCj4gPiArwqDCoMKgwqAgfQ0KPiANCj4gVGhlIG5ldyBtZXNz
YWdlIGlzIGluY29tcHJlaGVuc2libGUgdG8gbWUuIFBsZWFzZSBtYWtlIGl0IG1vcmUgY2xlYXIu
DQo+IElzDQo+IHRoaXMgcGVyaGFwcyB3aGF0IHlvdSB3YW50IHRvIGJlIHJlcG9ydGVkPw0KPiAN
Cj4gIk5vIGFjdGl2ZSBVSUMgY29tbWFuZC4gTWF5YmUgYSB0aW1lb3V0IG9jY3VycmVkPyINCj4g
DQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNClllcywgdGhpcyBpcyB3aGF0IEkgbWVhbi4NCklm
IHRoaXMgbG9nIGlzIGZvbGxvd2VkIGJ5IGEgdGltZW91dCBsb2csIHdlIGNhbiBiZSBzdXJlIGl0
IHdhcyANCmNsZWFyZWQgYnkgdGhlIHRpbWVvdXQuDQpJZiBub3QsIHRoZW4gc29tZXRoaW5nIG1p
Z2h0IGJlIHdyb25nLg0KDQpUaGFua3MuDQpQZXRlcg0KDQo=
