Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2A879CC
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 01:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724722811; cv=fail; b=cXc0kV11Dj7zlco5lxWjzqXa+VBdSX4X9a0B/uGbl/jY0XN+ORZLylIaNKTSRsNZfeQ6lw1z2+R9aacjQLAGGxypMaHb/ijYZqtYOe2MT/neJbZcwoX2GzpDkgypRdKbz+ScUvqk6dL3Xv4UsrRFQb3TThMcQJKtYkZv23b5K6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724722811; c=relaxed/simple;
	bh=dMceCU7LDJ+1Lkyhyg8Dr1fElV9limpGdFllEZSQXRs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DVzUy/CizpnFHlZfMjNUkbE+pVgJ/FWX71V9bU87RBrlm3sbf+L3xumKE2UQS5gRRg7TjBbKWSAhCbvf9Bl2R7ig/c7WnR357TUe8jASE2BoEBoRNTeQGpT8sYS9L7BTDPfy19M0pLtv6DtzvNAwx6vDoyMAXzcmP7pj5CuEsHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=UiyuDC/K; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=EYzmzOMQ; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="UiyuDC/K";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="EYzmzOMQ"
X-UUID: 46c31c24641511ef8b96093e013ec31c-20240827
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=dMceCU7LDJ+1Lkyhyg8Dr1fElV9limpGdFllEZSQXRs=;
	b=UiyuDC/KC2AP4Wyex3i5UL8JJL+1pUHDpflIhfdw6TtlyS0CMMQIsEsHhoC/RabBhuyxXrzbFIhSvhuP4y6xOaFFcV61PLhvgiEYbZrf1ONtJa8rr1y5RFrHjHLiN56aOFWpwTLScdnNa7i9HVQ1JQoR32gPwkcTURr9Hu7SnSE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:527c4042-c805-4669-b028-bac9c7a73937,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:89ce37cf-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 46c31c24641511ef8b96093e013ec31c-20240827
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1276873481; Tue, 27 Aug 2024 09:40:01 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 27 Aug 2024 09:40:01 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 27 Aug 2024 09:40:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s0aK3ViukkF6tHUUD0EIcQ9BMfe+UkKIN27k51d3wiuIAk1xp5gSCWJxjX2qCUkVNY2OdSjJOjtDJoCB2VE1/nzPtSkhr9XCLKGN5wxmkqhLD9G/sqV+MyM8vD7qcVd8XADspZoaL31el5MhpU1Sc4ksXYsysR3YdE8s8ZJZ6V+BUESOX/2sRTdC6mut54wdM3lTXvDcPmEvLCg611aaTdy89At1LAihrlIJtfH0XzzT4rWTaUVxaPQaI7drqfbESrttT94+FQjs1J3Xk50dbr3MGWyE++xFOvtvlmtrctrWlzvxqeMw9i5MNSKXqTJ5+v6/Z0aBrsQ0G7Es3zUHVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMceCU7LDJ+1Lkyhyg8Dr1fElV9limpGdFllEZSQXRs=;
 b=HyWCJ9v/tM64O4ly3FZWk/XNcvHACm12bdTcQIFMpLTPpsD+Pu9K7D6b5x4DG4cHjquVa7dB7sG+CVhSRLGMg2IuRsmcQY13Nwp4Bdo3S/HyHpUQBnYsEF6MPFWsY+BMhcdmCrAyyYORFA3K3kQRQyVZSnk3ZOjDQQL2+//cAieAzTEcqBH+y38XScJMI/4ClrtSuvjayfhWh7JAeB8ffyMlPUsUeToV408ND5x8zoaEOckTQFNcDjstzFNZBwAgNtH0+Cy1Qm2GFABj+8bs/lSuRfm4E3YKS5cm8Ewbu3EGkNT2FQ9lwgfPBLh/Wxm0w9Rr3ufouObrSdPg4XXPAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMceCU7LDJ+1Lkyhyg8Dr1fElV9limpGdFllEZSQXRs=;
 b=EYzmzOMQURFmDQT55jYsEKOrfIM13HlOc3owj2SfYarRFMViGffpAoGbIj9b59r5oxsq2U4hcaI9vpO4+5q8OnLtWevhcZ/pxhL6Wsi+5UgWZj2WVx6DjTnHi3+qlNbYQDo+rLUgA2qhuIHA18dcQ7EZDrXk5WLB0WQWEE1x7Ec=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB6957.apcprd03.prod.outlook.com (2603:1096:101:a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Tue, 27 Aug
 2024 01:39:59 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 01:39:58 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "ahalaney@redhat.com"
	<ahalaney@redhat.com>, "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Thread-Topic: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Thread-Index: AQHa8/g1O9xCFCXi4kKybU2KvbfJOrIz76mAgAAqm4CAAA4hgIABJXwAgAPJKoCAAMcMAIAAfgUA
Date: Tue, 27 Aug 2024 01:39:58 +0000
Message-ID: <37fc6433d70483b7a889ff804e56023b1081b7b6.camel@mediatek.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-3-bvanassche@acm.org>
	 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
	 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
	 <471e5a037f5fcc996e36b6112dc011731e75b66d.camel@mediatek.com>
	 <63b82e64-e968-4704-85b8-fad919994432@acm.org>
	 <b7b0395a59e275c5e43cb282b827b39416a5b4ad.camel@mediatek.com>
	 <082b7053-e7f4-4dd9-9d84-c8d9c7d75faf@acm.org>
In-Reply-To: <082b7053-e7f4-4dd9-9d84-c8d9c7d75faf@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB6957:EE_
x-ms-office365-filtering-correlation-id: b2b82fed-1a5b-4c29-bba3-08dcc6392952
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?R0Z2MUIzMXNiMmZMNkZTQmZUMnk4Zk94S0hVTHB1d1p2Rk9ZampYa3dKMHRB?=
 =?utf-8?B?RG1wcFBjdGtJRWNPU0JERFR6TEZLY3JqSDhxQnFYaGFvRTI4cmwrMnBCcHZ0?=
 =?utf-8?B?bWtnTE42UkYzVHNXTStJUFFtNEs4bTJnLzJxK0NISHdnaXZrVmZnWStSNXFi?=
 =?utf-8?B?V01YbUc0SWllVWhiaUdiOHcvUGQrajhXNGxROTMrdnU1aHZMaE12TkFyYmtK?=
 =?utf-8?B?YktVQnFFNHZrb2ZhQ3pPMUFoQ3hXQU9kaHkrelpQTTA5bGV6eVFtY0IxVnE3?=
 =?utf-8?B?ZHBEYUUvU0ZqV09uT29lanhXeE5GczMwTlN6ZmZTMDdlTWNqRkNCazZBRjRO?=
 =?utf-8?B?R2F5T0NCcFFsU3Bud09DSmcvRWN5USt4S1dVaEFqbTZlLzd3MGowL0pqVXBs?=
 =?utf-8?B?VndwL2RBTTFJQmQxQ3hZU3YwUWpzenIvcWRPNTQrQy9UQnIxL1VkS0dTVm81?=
 =?utf-8?B?RTBtcFJxSkgyYjkwZDZOdWpsbkVTVFA4SDltVVljZ0E1TCsrTUxPaFN3L2FM?=
 =?utf-8?B?dEg4SVJ6OHNGUmNadGZPR0tQa09hcUVWeXhWeTNxMlloSEhTOXhMOHR2cXU2?=
 =?utf-8?B?U1M3OFNJOTAwQ3RFNGFObU9ENzUrV0tvYjFtdVJ4THR0YlNpZkVzaEFaNU9v?=
 =?utf-8?B?SjlJeTJlbnVlRFZtMnQweEhEaTZCbTlWdElkUC94aXB6M3VSaUo5WHpaSjhN?=
 =?utf-8?B?SE1BMFhNVHZqRDNNKzFwQTNuZlM4RjVIVzlvdjRhRngxYWRraTZBcDFzcHNu?=
 =?utf-8?B?T2tTdGVZQm9tRXhGMW9OR1E1eE5GL1hSNHhtQnV5d2FXY2oyN3BtakZ3NC9C?=
 =?utf-8?B?Nm50RGNaNUlObVY5aWlJcDlYVDBvRkpBbXlIL1dqUXBVc2xTS0VIeFUzVWxo?=
 =?utf-8?B?aHp3NU52cFZWb3pNa3lJbU8zRkxmd0lwV09rNWZGUGxKWkdkTkUrcGdGSk54?=
 =?utf-8?B?Q21kZVEwUmxGelR3RFIzOXJ6RGpNWjRnTjl0RDVqTVVZcXV1K0lySW51WjZh?=
 =?utf-8?B?WDN2dXdLSkNZZG5VVFYvVkZnQmorN3k3WGRFY0FFTnJZL3VqZFpCaUZDWmp1?=
 =?utf-8?B?WFIvSm5kWUloQXFhWDZmU25PdXVDZjIzNWhJbTVjVE8vK1lKeU9DVW5rOWtr?=
 =?utf-8?B?c1J2cDlRZlVjZVZ4cHQvcVJtUlhobEhaS0pOUW9taGYyVzd3U0VmVW1iai9P?=
 =?utf-8?B?VzFMbmU0N3hONG5uNUhUdlROa25JMGd3dkNTeHFWaTM3SUY0UXp2clpscElZ?=
 =?utf-8?B?cis4WkpOSE8vbWlkOEFaaGc2M1JqSUxFdXpjTVhRN201V2VJUEFUR01DS29o?=
 =?utf-8?B?a0JSZTFHSGF4Yk5qQnkrajNqVVhFNmswQk9lai9EVHVZNURPVUtwcHBtT3VM?=
 =?utf-8?B?ZktONTRQWVpXTXlZeXc2SmU3aC95dTRjaU12THNCd2tYell4QWhZNDM1NzlE?=
 =?utf-8?B?UmVaOVNjeFp6NVdqdkxzeUc4KzkzOHBNNXU1a1B6NzNiR0ZjVDBiY2YwSlUv?=
 =?utf-8?B?SW5ERENiYUY1RXpzSmR1QjY2K2xGK0tSVEZ2RVZ1YjF3dWRtbGRjV3ExY3ls?=
 =?utf-8?B?TUJUQmFNTmJTZEhWUnoxd3FsWlV5VVQwNEVzNndYK0o5Q3crM2JZdXo0QzE1?=
 =?utf-8?B?RDR4YXpTR0VrN0NtSnk2N0RtNUs2TUN2ZWNmK0xkVVpIZ1dpWmx0MTQxQ0VZ?=
 =?utf-8?B?cTJjOEsrSEdMVXJYV1AyZWNHeUJzVkoyemo4MWNlUXFJWUVCVzlCVlNtUEpD?=
 =?utf-8?B?UXFjMGF1d1BIY2J6QzQwRGhBMUg4TlBGQTY1NTZEbzM4ZFJ4MU8xd2ZMdmNO?=
 =?utf-8?B?dStLSk5GZUgrS05EL2pJVkVQdXR5Sm00dzhURGljbkk2ak1DTDVMbmtJYUpF?=
 =?utf-8?B?SDZlS2ZVaXR4ZFh4SEx0YUJqcmZPSjdIcGpjUVcxSE9hUlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDRDTXRORnAxb3FIbVNNeHZRNlFjTTdha0xOZUQ4R2M4dXVPUHhKcDdNQzFT?=
 =?utf-8?B?dWRwK3VodFdFSENqemErM3N4SmlmUFBGRFM4QUxjcmprU2FEcEFqQ0JRYnJ6?=
 =?utf-8?B?SmhaV0ZvbjYyN0RUL0ZraHkrLzZEZHVId3BhU25xVnN4ajljZmx1em4yVzRL?=
 =?utf-8?B?dGREK212d0puMzBHT0pPcGhvRCtKZnQvU1hMWG5HRGJlK0tMWDFqZHhidW5t?=
 =?utf-8?B?TEZGR0FmcTZjR3VLZmdXbmUzbElNMEpnN0JTMlNMMWdBek1kU1liRmlUbW80?=
 =?utf-8?B?MW1mSDNYRmFKdWRaeTUrdjc3R2d2NEZVUHBBRnRjTXNlMTlySkRZMlhjYkEr?=
 =?utf-8?B?OTdzQm13YnJrNytQeVI4L3ZmT0RtY2I4WG43Z1NjU3lIZWlFL0JRUlVVbys1?=
 =?utf-8?B?SXBHb20xZXJLQkZpTUs0YU80M01lbkN0TlptVklLQzVLb3FRcWJXNG1XS3Nv?=
 =?utf-8?B?TmtJTGdZSlhhWWIySUNrSkI3LzBYSm8vUUdDNnpwaFdMM1N6bWxWODlodFlR?=
 =?utf-8?B?cUI0MVd1cDlMOS9FUHlDYythbHRVT0pFdElwb05aVlZSazVhUmoyWmxHNm1M?=
 =?utf-8?B?eGZPRGE0eHFzMVZIMDZPbnc5MEpEeDhZcktJQXA0N3RVWjE2d0lMOCtHZm15?=
 =?utf-8?B?d1Zob2RzQ0ZVTW0vWU5YNWkvbjQ5WEhENWxoeExvKy9VTTdvcmlObFhnSC9y?=
 =?utf-8?B?RGdqSjBWUTZHV2JiQVJVU01DQXNPVG4xL0N0bTY2YlFaRUdlWFhRd1lIdlJ0?=
 =?utf-8?B?d2xZc2R6U3ZXMGJOTEFlcXJnYVJVNnpLNHVqM1hrQ3cxYUd0NlhON0ZLeGdW?=
 =?utf-8?B?ak0xZkZBeVR0bWxMSmh4YjJZRWdxU205TjVXQXpITUVYd2hVbzk0L045UXdF?=
 =?utf-8?B?QVF2eXVwb1M1amR2SVRtN0VNVjdRdS9PSHhBcE9EZTZtRkxCcW5uWkt2Qzh2?=
 =?utf-8?B?QllaVGRGRnFiVXNQZkRjRWQxSDBrcTRZQngvTm0vQmQyNlREOUZaOFB2aUUx?=
 =?utf-8?B?Qy8wdEpvOHYvZ3I5SzdTRDBNVDVpZWtpdEVkTUpBU2Nwdk1lWVp4TTEydHpT?=
 =?utf-8?B?eVRUTEt3cUpjSWM0eSt1SUhVQVVSWkhQQ1QrSjRqWU50VFd6bzgrdW92M1Rl?=
 =?utf-8?B?K3NVLzl2L3VuYldPdVNFRWZYWnFseWt3TmIvamcxdVlyY1ZNV01VOFkwUThE?=
 =?utf-8?B?amNSRTdLcW9JNFlHQWpYS1hZTlc2TmVpWXN2L1FoQ2prOFNTcXBISHN5d3Q1?=
 =?utf-8?B?OWhjQ3pkdkJZanlGL2NHN3VmTmVDc2FnZzRPQjRCcURRMDN3TTBwUFVxS2Ry?=
 =?utf-8?B?Wkp0NTl2S2dzY2QrQ2JlOHEwbUxMdjhSSEdhczUrbkdhcFR0SU02bzhKS3cz?=
 =?utf-8?B?WUJLK0RIRmNkQkwwSEpyN2NvenNMak5UMExaOTE5VUYxay9BcUpTK2lDY2Vi?=
 =?utf-8?B?ZFkyMGxGZlBCS2FJUXlBZVByM0NBZjNGc3RTL3ljcXk2eTRmb204UlJSTnFF?=
 =?utf-8?B?RkJEWVZFYjBvZXh6Z1FqdlhwYU5MWU4wY256MWRhUzhZU3UySmZXa1dYNWpK?=
 =?utf-8?B?WVYrZUJqdlpUbXNKNExBSnpwQlJXaVlsTk9MejVucmxpdDlaSGpHaFhFazhj?=
 =?utf-8?B?cE9GZUhmVjZlNmNFeWRGNEwvNFlDRThIbzdXRHN1TmdpbG5qWllMVHltaW1T?=
 =?utf-8?B?ZktBblBsQ1ozMVFYWmhvZWVPSXVhSGpEd012VUVCdDR4VENwOFlmZTh3U0Zx?=
 =?utf-8?B?Uk9ZNjVpR0pNQlFEOURDMkQxTm9XRlpvZ1R3M3duS1FKenA2djVnQTB1cVB3?=
 =?utf-8?B?STF1SEF0dEpvQnN6UnJ1SUpxNnVnQUFqamdPZXo5SjU0aEVHZHZIU0lzdGd2?=
 =?utf-8?B?Um42RGxyMlFCaDJxQTMvRG05dlhvTkhCSXJ6Mm84QzNseHJmY1hoczhVemlF?=
 =?utf-8?B?Y1JKUDA3NFhRSmZIdGUzWG5vaW5Gd0xvU1UvQUc5anZOQW1QT3JDL3RtMExG?=
 =?utf-8?B?eW1YdnNuRTMvRXpaSTAvRDgyK0dMUVBaTXczcTFVeEZXRlg5QmJhSTZYeGx6?=
 =?utf-8?B?UUV2ZnoyMllibTZhMjlBbFBIRFFHeElHSm1XY2dtSUM4UVJrVGhoVFQyT1F2?=
 =?utf-8?B?U3UzNXJsTDJ6amx6SStzTkhCR2RxTEk1YWM5OS8vK1Brb3V3SXA0TElSbFk1?=
 =?utf-8?B?QWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <34ED65DADAB4FE48894A7B46C1D255B5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b82fed-1a5b-4c29-bba3-08dcc6392952
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2024 01:39:58.8394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bGXs12L9voVJLpvRBWhqni7lGaSeUX3CyHdFOfXjuAY44BE4KClF1taDesJ+CMzb8+/X2uOvTqCDrZPAX2YuJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6957
X-MTK: N

T24gTW9uLCAyMDI0LTA4LTI2IGF0IDExOjA4IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOC8yNS8yNCAxMToxNiBQTSwgUGV0ZXIgV2FuZyAo546L5L+h
5Y+LKSB3cm90ZToNCj4gPiBJbiB0aGlzIGNhc2UsIEkgc3VnZ2VzdCB1c2UgYSB2ZW5kb3IgaG9v
a3MNCj4gdWZzaGNkX3ZvcHNfaGliZXJuOF9ub3RpZnkuDQo+ID4gV2hlbiBoaWJlcm5hdGUgZW50
ZXIgcHJlLWNoYW5nZSwgZGlzYWJsZSBVSUNfQ09NTUFORF9DT01QTA0KPiBpbnRlcnJ1cHQNCj4g
PiB0byBwcmV2ZW50IGVuYWJsZSBVSUNfQ09NTUFORF9DT01QTCBhZnRlciBoaWJlcm5hdGUgZW50
ZXIuDQo+ID4gV2hlbiBoaWJlcm5hdGUgZXhpdCBwb3N0LWNoYW5nZSwgZW5hYmxlIFVJQ19DT01N
QU5EX0NPTVBMDQo+IGludGVycnVwdC4NCj4gPiANCj4gPiBJZiBpdCB3b3JrcywgaXQgd29uJ3Qg
bW9kaWZ5IHRoZSBuYXRpdmUga2VybmVsIGNvZGUsIG5vciB3aWxsIGl0DQo+ID4gcmVxdWlyZSBh
ZGRpbmcgYSBxdWlyay4gSXQgd291bGQgc2ltcGx5IHVzZSBhIHZlbmRvciBob29rIGFzIGENCj4g
PiB3b3JrYXJvdW5kLCB3aXRob3V0IHZpb2xhdGluZyBHS0ksIHJpZ2h0Pw0KPiANCj4gSG1tIC4u
LiBkb2VzIHRoaXMgbWVhbiBpbnRyb2R1Y2luZyBhIG5ldyB2ZW5kb3IgaG9vayB3aXRob3V0DQo+
IGludHJvZHVjaW5nDQo+IGFueSBob3N0IGRyaXZlciBjb2RlIHRoYXQgaW1wbGVtZW50cyB0aGF0
IGhvb2s/IEkgZG9uJ3QgdGhpbmsgdGhpcyBpcw0KPiBhbGxvd2VkLg0KPiANCg0KSGkgQmFydCwN
Cg0KSXQgaXMgbm90IGEgbmV3IHZlbmRvciBob29rLCB1ZnNoY2Rfdm9wc19oaWJlcm44X25vdGlm
eSBpcyBleGlzdCANCmluIGN1cnJlbnQga2VybmVsLg0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCj4g
SG93IGFib3V0IGludHJvZHVjaW5nIGEgcXVpcmsgdGhhdCBzZWxlY3RzIHRoZSBjdXJyZW50IGJl
aGF2aW9yIGlmDQo+IHNldA0KPiAoZGlzYWJsZSBVSUMgY29tcGxldGlvbiBpbnRlcnJ1cHQgYXJv
dW5kIGhpYmVybmF0aW9uKSBhbmQgbm90DQo+IHRvdWNoaW5nDQo+IHRoZSBVSUMgY29tcGxldGlv
biBpbnRlcnJ1cHQgaWYgdGhhdCBxdWlyayBpcyBub3Qgc2V0Pw0KPiANCj4gVGhhbmtzLA0KPiAN
Cj4gQmFydC4NCg==
