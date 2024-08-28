Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10CC1CA94
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 13:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724852829; cv=fail; b=WsCRBh2auGnODT3VV4nMHIhRh5kJHPQ4YOUvQUUaPcZGYn7qvNh7Q+w+WG3hzhNe9I/4qz0NbXiuH23H1nKY449pmpfts26YhnvaO6hVQj121AAhWjqIDSDixd1FVWiCY5IczE/DnAb1K2afw7wnSgUatNuv8RcaNnrwVsTjaLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724852829; c=relaxed/simple;
	bh=3QxZDOaF+8+z0ThLPx2YUw0TpuUEXawtT5CX2dLTgGk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UCQgoZJZVHlKJBZuGf27ppTINas0v/jPgTW1WpgZ5rs4QHrw8dRWko/gkA45J3X/9gOFgO1yQsrFaI5LNo7vfbCjanPhD4JMt0p9AKf7DYBWdBRpSGMLskMrqqRuiW9Y2tXOr/CTjL17BZYtAWHGeXxTjD4r2tbwN5i21NJEbYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=WSqhu6Pf; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=jWK6a+SV; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WSqhu6Pf";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="jWK6a+SV"
X-UUID: ff341eaa654311ef8b96093e013ec31c-20240828
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=3QxZDOaF+8+z0ThLPx2YUw0TpuUEXawtT5CX2dLTgGk=;
	b=WSqhu6PfdXy3HlyQDRwmZ8fqCHa7xrBucSAGvKnsP1KM/vI8SjrpqtzU3hANS6cHbB50A5hfCE187UC7qjpPVNeUCul0IjS70R4ldT0Muq8ikB0GevflxFo4qnLQe1O1m0ZtdV2OKYXI+RX+B6Kx7cIGEaiYNy+yGkvDKpBsgQM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:0d85c37f-2087-47a9-81a8-4cef8d0ecd75,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:244651cf-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: ff341eaa654311ef8b96093e013ec31c-20240828
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 667100012; Wed, 28 Aug 2024 21:46:59 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 28 Aug 2024 21:46:59 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 28 Aug 2024 21:46:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rQXs5BB/JK54LQgEQmlCYOTyMOQi6tYh+9PFUthpm2HL3HXmCelajV6JxhBNdOdBXQ29Pt9DqVFT3cZMkDKcPUw2P2LkiSVH+8wJEcBMrqQkjrEggqmFHz8MWgINrhLCy75pEA28I2eHmXdWjMmZzypyTvQK3b+HkCeaOoWio3HI1KIYcWIEklgPKV8AeLfqCM5RrMDvnEAmiimKHhMI5Qj7/U2ybpUdJEX7HIDBFLpSpBlKJ0RsGJyJHG72ZTJ40Z1b7vyjXoo9k7cq31AH03dxjrFfin1jnEAIEtuu6H78KG5Hxx8nKqdSSJEjrQTgpzlmfJjX01SOaNC4u/Wo9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QxZDOaF+8+z0ThLPx2YUw0TpuUEXawtT5CX2dLTgGk=;
 b=sMs/dnVoBIpf06GkkFD/WtQ2uCcFrejSpxJrFTXr0TxU3YKduN0uYQrsb7sZ85eiEYLAqjQCTr7+e9SrLD/CB3ydsUcfsCUhOmr+p314Mf/VQCh11YwsBPTvGJorzIXHk5/zPJBQOTEuwuOxvCe7YZHfb+k9UQuFCfxZxdjTrirXKiYCIGg4KQpLdJJeaUlpY+gAk9jZiP8xIL5VOwikDRTygLocPwidgHiMCz+DE4NB9uIyn+CvihxZS1KI+cyYn++mDTxhUl5OWgFB2CWMjeAp0E3QKV1Vv0KgfXoetVY6yynpZm+skt/zwlpPP/ve2YfYUvyvBB2DRaojwbFZGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QxZDOaF+8+z0ThLPx2YUw0TpuUEXawtT5CX2dLTgGk=;
 b=jWK6a+SVMlcX3VSeAVhrr1iR6rnHmlkbhJ4qSSFi2Q5Nndf2ELuq6WmPvf0sSxFEhk7u2WhYKq+pPEOLPQcVxAn18dc5Jk+L+1j99Xsh0MSZWLZrilIIpaJfZkAC/b4OLB8WhL8Q0jk042RMeRwmp1/A24n/v9Ep64jexq7qZaE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7800.apcprd03.prod.outlook.com (2603:1096:820:f6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Wed, 28 Aug
 2024 13:46:57 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 13:46:57 +0000
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
Thread-Index: AQHa8/g1O9xCFCXi4kKybU2KvbfJOrIz76mAgAAqm4CAAA4hgIABJXwAgAPJKoCAAMcMAIAAfgUAgADrb4CAAPSJgIAAU+yAgAApjQA=
Date: Wed, 28 Aug 2024 13:46:57 +0000
Message-ID: <1f0274b239c4a2484a65c28c5678aac4d4040a00.camel@mediatek.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-3-bvanassche@acm.org>
	 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
	 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
	 <471e5a037f5fcc996e36b6112dc011731e75b66d.camel@mediatek.com>
	 <63b82e64-e968-4704-85b8-fad919994432@acm.org>
	 <b7b0395a59e275c5e43cb282b827b39416a5b4ad.camel@mediatek.com>
	 <082b7053-e7f4-4dd9-9d84-c8d9c7d75faf@acm.org>
	 <37fc6433d70483b7a889ff804e56023b1081b7b6.camel@mediatek.com>
	 <f7f0ca00-a8ce-4841-8483-5ad886da82ad@acm.org>
	 <0476168b16b4ba6a2b52cad23714206c6e386d80.camel@mediatek.com>
	 <71de72f4-2cb0-44ea-aac7-0f2a5c8fa492@acm.org>
In-Reply-To: <71de72f4-2cb0-44ea-aac7-0f2a5c8fa492@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7800:EE_
x-ms-office365-filtering-correlation-id: e1fb1bc3-7cd7-4cce-8e2e-08dcc767e2a0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Umt4L2Vpd3FzVk9wOG41Q2JqSS9DR3l4TkFVNFFuSjN6SkpTYVBidzZib0xU?=
 =?utf-8?B?Wlk1czNtVnB3a1o2YVV0RjNjWU5QU0NRMXo4SXduQjAzcm1CVk5pMTFQRW1y?=
 =?utf-8?B?UjUzcDV6YW5OVjRZaEdFNWc5N2o3T0tkT2JiTWkwZDB3cDExaU1GYVhFRFA0?=
 =?utf-8?B?VUU0U1pqWUhTdmlqbkg3VmtBY3V4QTBoVTdjN1l0SDhSYWN2MTJYcG8xd3NS?=
 =?utf-8?B?WHYvekdjeXcyd1JrbjB6SjRCUytvUjZWbTRyMHl2amgvUmV5THlicFloNFYx?=
 =?utf-8?B?MG8wbkRscTlsdUVwODcwNGpkQ0EwTjYwU2lWT1Fodnc0NlJjVlVNSktqdEw2?=
 =?utf-8?B?aGZvQ1RDWVJVVFBmcFlIU3NTc1IwODNYK3Z1UnR3ZnhYL1Qra2VrNkRoeExR?=
 =?utf-8?B?dnNPdXl4R0d5aHJ6d2lvVkFpNmFDVzRFV0VXcHhVdk1DR2lJaTFDL3BJWE52?=
 =?utf-8?B?dVRLVW1uL0VRa0tsM3ZWd3M4NnJ1WVlDTGVWL3p4aEVjcHAwbnZ3Qm5IZmhw?=
 =?utf-8?B?U0NlS1ZlcDdOZm81SlhRZTg3UzJYS3VnUFpMRFlqK1pKdjRkQW9JaEdvTyto?=
 =?utf-8?B?MVE2TU9tT05DWXFUUFQ5Q0FlSkhyY2x0V3RyajM4dENicVNlT3pQYWE4Si9Y?=
 =?utf-8?B?VUhZRXRDRk1MNSs5MmdoWmtTcTYvV3RKS3dsUHcvamtJdDUzMHJHaEs0MzlT?=
 =?utf-8?B?K1Zmb0xGSVBVSXpUd2k0ME5JcmlmalZidXZScExOUDFRRWwybTYvdGgwODMw?=
 =?utf-8?B?TzdtOFh4YVAvYVNqZkNlM3N5T3V1YWpvR05LaUlWaS9PYm94dFFHQWZLWHFF?=
 =?utf-8?B?NVpQODR5anY1bGRraHIra3hRbUhhWW9UdFJvWXhIY3ovdWQvWStxSU5XYVBO?=
 =?utf-8?B?VWlXU1VTUXF4QmIrVnFienFSUjRMOGpGODB5WklYWlpvYi8yaDEwRUZNSkMw?=
 =?utf-8?B?bXUvN2ppY05mTTg1d1dkdW54emo2akVmRGhxRy9VUWh2QWNVMWNSQmNRYlV4?=
 =?utf-8?B?TWxZUDZVeURnUjJNbml5TXdGdE5IWUF3SXcxZ0VCODFtd1ppeWFqUFFYSUtz?=
 =?utf-8?B?Q3Jpd2lwWS9TMnRHcVhPUXZrK1Bqb3IzZFZzRkRFSFpDVGNPYzU5eHA5MGpo?=
 =?utf-8?B?YWUyZjlmNnhEd0owOVJ6SHZwVC9BYkJtSjVrRnJqcHpheWtnTnlaQy9UMEVl?=
 =?utf-8?B?RE44eEp0MTRuVTBvTHBUNVhUVENPSzJKdzJmVCtKejdBUmJDZ3dtWVdvbU9T?=
 =?utf-8?B?TWVwZ1k1QTZIU2Z1Vk5rKzJLMEcvdFhCZGZudmZlOU9XSzBCejQ2a2krdHVR?=
 =?utf-8?B?d0M0U2lDanBnTzZzdEU3UlZpUC9TbXVTbFoxSEtsYTJyUUdnNWprMWcxU0Nl?=
 =?utf-8?B?NlJ3Nk1QbURVd2hDbVVRdmhEU0s1WWQ2c1M0MnB3MUVmZEJiWWlWdVdjWHhk?=
 =?utf-8?B?Vy8raXAzUnE3RFRPS2hDVHdlbXZUMUFodVcxY0JIaHJyQXRKdDZ0QWx0Z25m?=
 =?utf-8?B?YzBIRTRqK3J0U3VMN2dDejVqdUF2VjdqYm5DTFdwRlB3bGh0T0hDVjFWZlI2?=
 =?utf-8?B?WTFtaTZPOERSaFQzc0JqZ1k2NzRKZFFjSjJnTEpEY3diTWdiSlVaamRGaVc0?=
 =?utf-8?B?VDJwMXh6TXBNMzhlRWlDL3N2MUdYNXhnd3VzZTVDbFZ4S0lJSXVYaDZQWFQ3?=
 =?utf-8?B?cE1za1pJclJCRTFkVEpZU3NMOTEyajBwNWdNdnRvZmV6SkR4d3lQMGgvWllZ?=
 =?utf-8?B?cHBDcjNFa2xqYnI0ZmFOZ3BoU0JQekY1NmlwZlJLb1ZhRExoYXpWLzQ5UWhj?=
 =?utf-8?B?dklCTDRmbGtsOVloM2h1T0NZdzVXR0dyMzJHNmI0RjBRV3pjK1RzNWRZcXk0?=
 =?utf-8?B?TTduN2lQZ0R6VGdpcXAzdkt4WVQ0aEhLd0FXamROR1pHQWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZjBRS010ZlhUTzVYMXZodDhTL2NJK2N5S1RYRHFKNUM5WGpJTklzQ2g0Q0tF?=
 =?utf-8?B?TlNyYUlrUjMxejBERm5ESjEzd243SmdibGl4Vk5qMy82eDRTY09OaXJrRmhC?=
 =?utf-8?B?MloxbHZQd1hnTkEzcVk1ZUFnK2Z5aXU2VWtBYS9zZWpsSkh6dE1QVHg5aHVR?=
 =?utf-8?B?OCtsMVFYd3NlYlVxM0p0RmJtMWJOSDR1T3NxRnZxOVI3YkoyOFR4VW52MmpT?=
 =?utf-8?B?Zko1bFJpUXpYV0t0WDF4Q25XZ0dWMU5YdXNuTVVseXFHSnVMUyt3OGR5RGt0?=
 =?utf-8?B?Um54K1BGZHg0QjBDa0hBODhBL1JRTTBFUWJURW9nOGszOWlES3hzNFplTEQ2?=
 =?utf-8?B?dkQ0RTh4ZllvK09ORWV5QnN4QWdlTUJZSklTR3JZcjRFNXUzcVJWWE9JUEZp?=
 =?utf-8?B?eFhSNWIxbXh2a3FQTlNRemEvVE5uc2dhblRTY3BEN1JwbWVNUC83cUVCR3RK?=
 =?utf-8?B?Y2ZNdlhKTnV1SEhxS3dXaXpEOWZndW1IdVBoRzladm11eXdTZHdzRXZ3OHk2?=
 =?utf-8?B?dk83RHpaSWx6c2R1RnYyblNiY3MyditlYVV1SXZvbUdXdFVUTDcyTUd6UDFX?=
 =?utf-8?B?T2dBck83UjAxTXRSMnJqNVM4K1p3UVYwdWFCSHFLckpEWmVaaGpaaGdaYm5F?=
 =?utf-8?B?U3dpMDA5K1pSajNRMW4relYydlZZMEZxc0R3dHdmQlI1N2xMMkRySFpMMXR4?=
 =?utf-8?B?blRHVERWTXE5V2c1RG9nN2dlS0o1d1dEUm41TExKMmRSenpKMTBscXlNZmoy?=
 =?utf-8?B?T3Rvb005RU9rd245VFZwUDI2WWFFdXh2T21GUkdJVWpiekJ3T1UwNTRBcXIy?=
 =?utf-8?B?Mkozb1I5cDlHSzJ0bUNkMS9XRWloK2xhRmVRMHR1SWNRM3p5VDBIaUhaS1V4?=
 =?utf-8?B?cWo0RkVYZGp3SUxlbGFkUjNtbk9sZnkvUWU0eFlzMDEyM0NoOG1hdUY3R3l1?=
 =?utf-8?B?bTRiS1NLOVU2VXRPVkkwYUx5aEtBQ1RGL01Cb21EeUZXVGJpWnM5a0x6QjV1?=
 =?utf-8?B?WXBpRS9Ed2s4MlB3cDNwQWtBZy9lemc4dzl5SVhsQm01ckVzdktiSUZWd1lY?=
 =?utf-8?B?VVBFeTJrVmlvZnJwckE2TWxPV0VmVFJnR0JMNVFxSFNqZ2ttb3RYUFQzZEc3?=
 =?utf-8?B?MVdrekdrVllwc3JrVmFHc0ZWRkJKMGhoeGlVTGp4Tnc2ZS9BZ1FsWXUxcVpI?=
 =?utf-8?B?dzZybU9pb0xRTHFnQ2wzVnFPUHYyeWhuWVl6OFlydDZIclQ4MmxVb1dleW1Q?=
 =?utf-8?B?OTVIcGVoNEVoSEtvaU9TdVRrTjYvVDF6NVFJQm51TC9iLzVHNWhjTVVzYytF?=
 =?utf-8?B?MzFwZ0ZHK3FnNUxQakE0TGFWUTlxdFJKYUk0QkFKQnNEQy9IVDZYNUVpK1pv?=
 =?utf-8?B?T3NvOUZyNnJ5UnozZ3NQMVVzZk9vTGNoSXRqZHNsVjQvYmFMSmNJWXd5U3Mx?=
 =?utf-8?B?ZWc0WkJxSHFsOVZtVGdST3UvblE5d013YXIzdU9hNW1IcnY3UUFNVVRwNCsw?=
 =?utf-8?B?RjYvRXRjcklqUkxRTVIzVkhBNlJDR0lQaXJEenVXbGwvNjU5TWhvb0x2MWY5?=
 =?utf-8?B?Y05taEt6OVJIcE9tcnFkV1hKUUg0aENETTFTN3FRNklSR2liaGk1b014bGE1?=
 =?utf-8?B?TzZBY1IvODhlSXBZSGt5Mm81LzRvamRKc0RsLy9QS3BHb2JUSXdMR2ZaOHpJ?=
 =?utf-8?B?SFdmN3FEcnJvanlaR21sd1hURytNNWVzYjcwY09JRGpFOEc3eVd4TUZ2dStL?=
 =?utf-8?B?aUsyc0pxNkg3WHhoVVFpMUNCYmZIZXM5dmZac2t3ZXZUMEZDNXdRb2l5M3RD?=
 =?utf-8?B?SE00TlRBYmppSFJ5TmNOM2RuM0UvdWpWdUJMM0hwOTZvdTlXUUxZZWQ1YlVl?=
 =?utf-8?B?UzVDUEcwL2FyQ3hiV1JWbFJCeWh3TjRjenJ5bDVvVzFtWGh3dFhPMlAvcWgr?=
 =?utf-8?B?eWJZSUpLdW84eUluYmNHaW5IR1cvS3VvMTFIMUwvOEYrd2wxL0V5cFlqa2NG?=
 =?utf-8?B?Nm42WUwzWlVnOFZsbGptdnkxa3VzL2ZYNkc4VnE2UlFpczJQRlRuUTJwdVkw?=
 =?utf-8?B?YTlBNkJuSEZJZTBzN0dNY1ZsM3g1bmU3UDVsT0hxK0NEdE10aXRwdDMrTjFn?=
 =?utf-8?B?cVplL1BlbmFHcXJsV1pVWENhTW9mQzdNaVRhSWJWVzAwVmp0NXpzVXVVY3VI?=
 =?utf-8?B?a3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5406726B9B0D848B90DA37D074A7C5F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1fb1bc3-7cd7-4cce-8e2e-08dcc767e2a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2024 13:46:57.7030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: grO9p/4JMYd9YUShzYWUjCkQv4h/h0s8J1q3bXMW53ztyIbbPQxfI+YSeJq0ZYSF6Gx/PK/aV1lUTehFt3kw4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7800
X-MTK: N

T24gV2VkLCAyMDI0LTA4LTI4IGF0IDA3OjE4IC0wNDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOC8yOC8yNCAyOjE3IEFNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IE5vLCBJIG1lYW5zIHlvdSBjYW4gcmVmZXJlbmNlIHVmcy1zcHJkLmMg
ZHJpdmVyLiB3aGljaCBtYXkgaGF2ZSB0aGUNCj4gPiBzYW1lIGlzc3VlPw0KPiA+IA0KPiA+IC8q
DQo+ID4gICogRGlzYWJsZSBVSUMgQ09NUEwgSU5UUiB0byBwcmV2ZW50IGFjY2VzcyB0bw0KPiA+
IFVGU0hDSSBhZnRlcg0KPiA+ICAqIGNoZWNraW5nIEhDUy5VUE1DUlMNCj4gPiAgKi8NCj4gPiB1
ZnNfc3ByZF9jdHJsX3VpY19jb21wbChoYmEsIGZhbHNlKTsNCj4gPiANCj4gPiBUaGVuIGFmdGVy
IGVudGVyIGhpYmVybnRlLCB5b3UgY2FuIHByZXZlbnQgYWNjZXNzIHRvIFVGU0hDSS4NCj4gPiBB
ZnRlciBleGl0IGhpYmVybmF0ZSwgZW5hYmxlIHVpYyBjb21wbGV0ZSBpbnRlcnJ1cHQgYWdhaW4g
Zm9yDQo+ID4gd29ya2Fyb3VuZC4NCj4gSGkgUGV0ZXIsDQo+IA0KPiBNeSBvcGluaW9uIGFib3V0
IHRoaXMgaXMgYXMgZm9sbG93czoNCj4gKiBIb3N0IGRyaXZlcnMgc2hvdWxkIG5vdCBkaXNhYmxl
IG9yIGVuYWJsZSB0aGUgVUlDIGNvbXBsZXRpb24NCj4gICAgaW50ZXJydXB0LiBPbmx5IHRoZSBV
RlMgY29udHJvbGxlciBjb3JlIGRyaXZlciBzaG91bGQgZG8gdGhpcy4NCj4gKiBUaGUgYmVoYXZp
b3IgSSdtIG9ic2VydmluZyBpcyB0aGF0IG1vZGlmeWluZyB0aGUNCj4gUkVHX0lOVEVSUlVQVF9F
TkFCTEUNCj4gICAgcmVnaXN0ZXIgaXMgc3VmZmljaWVudCB0byBjYXVzZSB0aGUgVW5pUHJvIGxp
bmsgdG8gZXhpdCB0aGUNCj4gICAgaGliZXJuYXRpb24gc3RhdGUuIEF2b2lkaW5nIHRoaXMgY2Fu
bm90IGJlIGFjaGlldmVkIGluIGEgY2xlYW4gd2F5DQo+ICAgIHdpdGhvdXQgbW9kaWZ5aW5nIHRo
ZSBVRlMgY29udHJvbGxlciBjb3JlIGRyaXZlci4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQu
DQoNCkhpIEJhcnQsDQoNCkkgYW0gY29uZnVzaW5nLA0KDQoxLiBJZiBvbmx5IFVGUyBjb250cm9s
bGVyIGNvcmUgZHJpdmVyIHNob3VsZCBkbyB0aGlzLCANCiAgIFdoYXQgYWJvdXQgcmVnaXN0ZXJz
IHRoYXQgYXJlIG5vdCBSRUdfSU5URVJSVVBUX0VOQUJMRT8NCiAgIFNpbmNlIHVmc2hjZF93cml0
ZWwgaGFzIGJlZW4gZXhwb3J0ZWQsIHNob3VsZG4ndCB0aGUgaG9zdCANCiAgIGRyaXZlciBoYXZl
IHRoZSBhdXRob3JpdHkgdG8gY29udHJvbCBhbGwgSG9zdCBSRUdzPw0KMi4gU2V0IFJFR19JTlRF
UlJVUFRfRU5BQkxFIG9ubHkgd2hlbiBoaWJlcm5hdGUgZXhpdD8gDQogICBJZiBjYXVzZSB0aGUg
VW5pUHJvIGxpbmsgdG8gZXhpdCwgdGhlbiBpdCBzaG91bGQgc3RpbGwgYmUgY29ycmVjdCwgDQog
ICBqdXN0IGV4aXRpbmcgaGliZXJuYXRlIGVhcmx5Pw0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCg==
