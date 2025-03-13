Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA312AE77
	for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2025 05:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843754; cv=fail; b=fy22LJqXQFIVF9io394xG20aWVznNK3NtEIieU88YdAsmfjUnVe20Wg5HwZ9krDqnHIxIOKuuuTCiK9RMjuwkua/UiXHvfYqz3vQwfu6Dy1U/LDCf57/aRhvrh257/ySerOZA4KPw47alQaUpX64Gxvcs62r9IcsySSsM710HVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843754; c=relaxed/simple;
	bh=cHua9qyREyYOGp3CsIQZNNykGubhgug85FEpHUH8o80=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P8EfYlFnObiq8KSZRpmLLJ1SqJQy5+YQA0NuNRPCJujV+xgOTz1tNQq3eLFym6tAdhuzP7DbWh0Mg048AvBGEBGQAa5BGVgnl5bnc8FnMnusvb1vUuKlMX5PsWwqOAGTQjyo3z2eGOAqbjJnyq93ybiZ2nxZhdNkaVq5xXrzzfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Nxbuzj8D; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=EmNtuMNV; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Nxbuzj8D";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="EmNtuMNV"
X-UUID: 111e4492ffcc11efaae1fd9735fae912-20250313
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=cHua9qyREyYOGp3CsIQZNNykGubhgug85FEpHUH8o80=;
	b=Nxbuzj8DBwHkO/ILwtHhOM80q666ZmjA99IHUuo5EB95QUpWmT1M4X8p9KyJHG9UpX3g14oluDaW28bXiTbPTZWV2Z2mpgp+k+rqvwKAkyskKyVbFiMRS/gOKha2A44oZ0t//N+72D3R6iWCFlXBOsfa6ROHKdR6qTmyRn5Amh8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:157b7d66-1ae0-4fe3-aad9-ec0fda64375b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:ff2261ce-23b9-4c94-add0-e827a7999e28,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: 111e4492ffcc11efaae1fd9735fae912-20250313
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1242095988; Thu, 13 Mar 2025 13:28:59 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Thu, 13 Mar 2025 13:28:58 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Thu, 13 Mar 2025 13:28:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J844xBPER6/hZazPOLosatOmHBEev+v9U4XeRYRSTuoeoTfFMIjKdfRPLq8kGeEGeg+DJJBDBCETVjr2EsRT5Kg98J7H46rlq7/rKuMZxuanzuslqywgm9hRmT909wR1eHgomEn/45eH4L9dsuwdFYC3YL9ypTt2d9flD/6sc4HZfsAomDZ3YgrBjcL5WivFAe2HdYec0cHI1o1jdPzXelDCR1B8qBON9NER0pzo9Aa/FIlon6VSz59J3inMjDOr9zsug6DFzzwGSGFp/4TuJ2DMGcD7ucmZDpsGCh1rjd7NBNapKv6VAg3JbWhk8GK1K2ij4HSoqwDOCYnatyQblw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHua9qyREyYOGp3CsIQZNNykGubhgug85FEpHUH8o80=;
 b=JzX3Rh9vhov+Cy8TvieBPkln1Tyc+VJ2LK5vwJS+oTwdO6r2/0OVk93eir6lR449gf/GujwyBZfLAlgcVt4Co99V4XdDtsyRUELJLxbfcAtsJoPJ5Uy4q1sszivvS+aU/OkKAwOak25hsfdxrAq72IXKEmZBNA3g8MQFwLdQM4RHVcmq2mNDqQSbZBA45amNNqSocuk7gmNYphqpDzGTAVc0clw3xKqAkMHCWXRRZ/rvmOheePnh8ubjnXD9lXHqsB+PkeDmMml4XncsdxLMuq6AZve2MCZa/dNe+zH9DiG0AxNrAZ5ykbrSMQsohagl3Tui/pwxCf7JPKBjaesH/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHua9qyREyYOGp3CsIQZNNykGubhgug85FEpHUH8o80=;
 b=EmNtuMNVKRzWWnr5I0c6AHqioCorgcTMOUPKl3tbI5m1tmvrwpPc0w1w0YFO5PyKErnrSvTM9RaO+Ef8xI4yB/sT/PapAR9KIedczxCVdl9DcMYq3K1VpKTLwwYO2rw8QhoIYSrqb0b3CoTlmoWSNukLk1Gb6NZDWLjTT1Mg3kQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PUZPR03MB7113.apcprd03.prod.outlook.com (2603:1096:301:11a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.25; Thu, 13 Mar
 2025 05:28:56 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:28:56 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "avri.altman@wdc.com" <avri.altman@wdc.com>, "ebiggers@google.com"
	<ebiggers@google.com>, "santoshsy@gmail.com" <santoshsy@gmail.com>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: core: Fix a race condition related to device
 commands
Thread-Topic: [PATCH] scsi: ufs: core: Fix a race condition related to device
 commands
Thread-Index: AQHbkr93pEGS8YZmHkC6xyj/wGdwgrNvHo0AgABxHYCAAPx3gA==
Date: Thu, 13 Mar 2025 05:28:56 +0000
Message-ID: <7f1fc8a38fb60e560c9363d16729bc10cfb885c5.camel@mediatek.com>
References: <20250311195340.2358368-1-bvanassche@acm.org>
	 <4a09a365e5724c3262b5622b679449a0d18f22c0.camel@mediatek.com>
	 <d0d80bb3-5421-4d97-aa5d-0ed006e80c64@acm.org>
In-Reply-To: <d0d80bb3-5421-4d97-aa5d-0ed006e80c64@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PUZPR03MB7113:EE_
x-ms-office365-filtering-correlation-id: 755be2df-eb40-4492-c3e3-08dd61eff377
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NzhhTjYzS2o0MzZSTWY2Y0g4bWZFZzErRFdmbXE0WDdjbW9ad2UzaitNeFps?=
 =?utf-8?B?N0grdVVOSHprQnBXTjFCRHpsdmQyRlU5clM0UVNpSHJub3k4MHowRWdzU1ND?=
 =?utf-8?B?UE5HUWJjak1qQ2ZtNkFLSGFpbm9GbFA1RjhQclA4WHkxTThNOFNrZ0V3dWlt?=
 =?utf-8?B?b2JnSmtwdmRsZWVsSzdHTlBFL1o5SjVXanRFT0QycUhJb3ZBY2ZwV3hzdWpZ?=
 =?utf-8?B?WHNFb2ROU0kzM0I4cmhXS0pGTFpsV2RpQlVHVEwyc1FNcmc1WTVSYXozbXJu?=
 =?utf-8?B?Q2JzMDJaQlN5d096VS9IUUZMM0NMK1R2WVJFTDJZWjFMU3k5bDRnQVZnWHBl?=
 =?utf-8?B?TnJXN3FpK3JDbnpab3lmUzVRaFk0QmFUSHpZekdjWWp1Zk96NjBubVdwSmJu?=
 =?utf-8?B?aHh6QVBaOGs2aC9OWDI1K2hlN3YrUUxuL3BJejFBNDdKYlE5NUg1UzBRUXNT?=
 =?utf-8?B?cEVjcDV6VW1HWHFDWDd2OFdrdzhjbGp5WGZiMFhwMVhSU1BFQzlrZUtnNVVI?=
 =?utf-8?B?akRnTytXdFkrK0g1TWl1WGk2b01GRnVjNi9GcHljdnRyTXNuS1BvOWFHN0Za?=
 =?utf-8?B?RGs1L1BOZ05zYTVxMUxKc3ZTWGF6ejQyaSs2OWdJYzYvZTRnNVNaR2pGckpn?=
 =?utf-8?B?eURaWW1KWnBqbkhYa3N0c21mU25GS1Qwdlo3QlZtbjU0ZytJM2FHakQzVjg4?=
 =?utf-8?B?ZDZEc0oxUFlyNUpoV1hVWG42OFpXZUErdXBxT0ZKWDAxakxOM1RMMGYwLzVl?=
 =?utf-8?B?TEdEOEtTc1FIOGlpTnBCc292bE9SZlU4eWU0aXZDZVpUbXo4MWFXemVhVHJL?=
 =?utf-8?B?S0hEYUxqN0lkb3oxUXo3aXZtaytCQ0JmajdqUWZ6clpwTWNWaHh4d1hZK0p3?=
 =?utf-8?B?ZW5rR2hEdjQzTFhmRGZHT1VzZWlBS2dFSndXK1pWTERuaENkMjNBV0dDN2dR?=
 =?utf-8?B?TTQ1bTU1RllYSXV5dllJckF3NzJNWkhnZ1ZMVWMxaWROekN6akswU0VCbk15?=
 =?utf-8?B?TzcrVWM0WGVseHpEbkFTSjVCQzhvRVhjMWdOZXZxU2xOejAyZXUwMDFPb3px?=
 =?utf-8?B?bUVHRXRIT3dvd3Z6dHRBZ29KYlQ1a1V5NTFSTFVER0hqQVpGbFBSZzBwdnEv?=
 =?utf-8?B?aUpoamJDNUprOE05bEV5elRpSm9yUGNBOGN2OGs3VFpaUzY0aXFqS05JMVZ6?=
 =?utf-8?B?dEF0elpPd2xFcmhiUUZMZ1VLdlZGY1RwczdYSGxqZGlkalE2TUpoOG1QUWVY?=
 =?utf-8?B?ZlI2UnBRK3VaSEEwRlY4YjI1clpvb3o4cnV6OUdwNXB3cDFYcVEzRW94c1NB?=
 =?utf-8?B?WHRrNENpanlhZE0rcnVrdUp6Wmh6aVA2M05ibVI0emk3bkcyZ1NLcXhPZCtX?=
 =?utf-8?B?ekJzMytmelRJN2kwOVJ2NUdHd3N0UWYvWm5sRGhicEZYQ002UnB5NXFtZCs5?=
 =?utf-8?B?eHNyejNIempiZ2N6ckk5SFlFWXFtNWFTVUxDTVdBc0c0K3E5dzlERDViM0pR?=
 =?utf-8?B?RUY0bERLVnMvcnBzZkpKRExtVFM3SkwvQ1VrUXhGWjhEQTFWVG9PSFkvcTcv?=
 =?utf-8?B?T3JaQ1pkelB2dSsvRHhUdE9kV2JPNWF4d29BT21WS09uODJ2aWNWSkxQY3Fw?=
 =?utf-8?B?RzV1RkFadXBranhVOElHQ0N0ejloWDJlWGFXeWtYZTlOQ2Q4RXdaN1Y1Rzlk?=
 =?utf-8?B?cXFza3RpN3pHQzNzUVA5N1pZRWM3Uk9qdE1rSGdySEtPazVaSmR5NTNZeEdn?=
 =?utf-8?B?VnRPOEVTdVBKUjBPbmgrejEveUZtZTZRd1VKMUQ2UnVManJTaEZObG9lR0E2?=
 =?utf-8?B?SW50cG1VbGJ2WTBGV01LZGRweGYxKzEvWWI2bC9iNUFLK0NEMWpldmVCVlQ4?=
 =?utf-8?Q?XxyploZbk03Ah?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDN3aUFOaFpEVmVaM0FmcTVpMTZ5a1M1TkhZTWpqMm1qaGg1cTJFUTVLNm12?=
 =?utf-8?B?eXNmVVE0Nm8xQlpTNG5SVWVrZGFJUFJKSmxOYmFWeFk4dGRRMk9XQWRqRXV4?=
 =?utf-8?B?YTNrSE5xeXVtMFZFQUNZY3B0TjBKc0oxcS9MdVlkb0dkSnh0LzN1OUQ0M2FP?=
 =?utf-8?B?Smhmd2QzZEoxU3Z3WDJvMlNYTGYrV2JkdXB1K0NkMXBMZ2ZaOTlRODZrTjdl?=
 =?utf-8?B?MmdkOUdQYTNXcTFHV2RYRk10aVB5U1ZLaldxS2wyb29rdzdWelFQMUJLNzgx?=
 =?utf-8?B?cE8raHI3ZXM0R043eE9VdGRhclQ2cjhVY0hOcmVIbTlxcjMvVVpuSFVOblpU?=
 =?utf-8?B?UjBOTGgxbzllZlA3Mm1IdmJSVFJzWk5WK1VOY0xRV2R2OXNMRFYvM0VOcUhX?=
 =?utf-8?B?K2tNZU9sSGxkRTJ0OTNLUkc1WEZiUG01a3lCMUQzZGdwLzUyRXIwZ0E1dnRY?=
 =?utf-8?B?ZmwrQ1hPNlIwaVc5bVpNWFU3UVlpWW4xSDg0T0VmSDhVNE80K2VTeUhlVXhp?=
 =?utf-8?B?M2Rjd1lDQmZoSjBpdWIzTzM5VVQwL2lmemNSL3VzbHlQclh2eWxBNzVreUtk?=
 =?utf-8?B?N1dMUk04WWUzc3FBOGJzTis1ZVB6WFJWUkRSam95OHNMdHltb1pld2srclNT?=
 =?utf-8?B?RnlMSm94RVdEVHlrYy9xT2NRcllXNjBsMmp5UXc2MGo2QkhmM2R4MkN2elRv?=
 =?utf-8?B?YlJ1UVhMN0FDWTMyVUpGa21qYk54U0QxanAxTFhsNjBVck9BUFFOcWVLcnlh?=
 =?utf-8?B?amJUWmV2WGl2N0dKNkQ0U1g4b0c5Wi8rOC9nOTlzU1dKV3dVRVBjZjMwK1l5?=
 =?utf-8?B?RzBYazhmTWthdktFNjBORklLbFlySDZ2NVpSamowVnl2TktDQ1A4QzdiNG9j?=
 =?utf-8?B?a2paWlRRbGw4cW5KT0Z2YlE5ZFNhbWxDZmtvT2ViblV1cGRmZXRRMGMxeXEx?=
 =?utf-8?B?V1UwWmhZY1lxNkdmelhERTBrSmFZZjRJcW5xUGV1SS9rRERqY2dKYVkzQjVn?=
 =?utf-8?B?cHFJbGRHKytIZzNvZWQ1UlQrbVh5Tm1ZTjByS2Y5b0lOZ3VUM1VUcTlmbE1w?=
 =?utf-8?B?Nk9EUlZGSk5IRE5ZT2FVcFZyRWU4Nm5xamovZHl4VHZmeWY4d2Zkd3VKbFo3?=
 =?utf-8?B?YXgzUHp5ZUpYamhYY3V3aEhJMEgxdzZGR1l0azQ0SFR6UkxPN29sZ0JCdDdF?=
 =?utf-8?B?blBqRlJLeXdmMzhlNTZaQjdQLy9FekhXZkkvcGZyQnBxVUxBWGlLdy9aK1Aw?=
 =?utf-8?B?Y2d0NEo1ZmU2TUtEbjF2SFByYU9LRnVFWUVFNWkwdjlDc0pTem1tY3dhWWdI?=
 =?utf-8?B?aERRQ3IyYUluamt3ZzJIYmlYQXNOb2wwa2loRmtPV3FGcm50aEpIRGNGbUNt?=
 =?utf-8?B?OWZIM2NOckNicElRTFEwZ2FEb1p6dUQ0S2VnNlFmRkxJN2huSHhBbDZoY3Z6?=
 =?utf-8?B?NGxxZGdwSkVuNnIzQWptM3JnNzcwVTNMRll4aHViQXd3VER0VkNpOGtybWVZ?=
 =?utf-8?B?aGxRRllRbFdGV2pxU0liYmVBeEVWR3VybUdUTkU5cXpqY2M3dkp2U1AxZUFk?=
 =?utf-8?B?QjBnWDdtRE55akVOeUNtZHFOcWV4VitMb0FSOFMrR09oWlZtVGttb3pzYXpF?=
 =?utf-8?B?L2w2bU1qZ09HcitrR2JidUoraTZKcmhYeDdrVll1Y1dTVHM0Wm5mYm9QRjd1?=
 =?utf-8?B?YUgvcmRSTmJtZEtteUZDMmtsSnVaL1R6L09nK0hRVmRMNlpzaktxMmk5UU5T?=
 =?utf-8?B?Z09PTE43bERlbldkMGtETGFCVXZpbU1yOHZDUHkreHQ1WmRWWU1uTWtlQjk0?=
 =?utf-8?B?UmIxQTR3V1dYNlJkeDJaODRpSHVybWUrVUVJcXVZVVhjcWRpZUczUkxIeGJp?=
 =?utf-8?B?aTl4STlVdC9xNUxRQ3p5Zm4ycXJlM1hWT2pvMTlKVGdFS3BVanpMTEMvTGJN?=
 =?utf-8?B?WTBBTDgzNmRDdE9Mb0NvYzJRRHdsT1hwWmxjcFNZSkwxelJhMEkrQTliUDNu?=
 =?utf-8?B?OEJTNmFDS05FS2h0cDN0d3UvbWFOcE5QSjNOK1ovS29YUjJTb0JDeUF2eUZa?=
 =?utf-8?B?YXgzNkVvRTJvWGx3OW9VQ0dsaFFabFA3WGNSSVpJQzdhem5OcGFsMUYxbkFm?=
 =?utf-8?B?Y2h6eGxZUzlORGZ0ZVRhUmtCWEp1VzAxMHdLWE5XdjBQaHRRWXBJTXUvL056?=
 =?utf-8?B?bUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4F164B990B64944B9624F302A440E8E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 755be2df-eb40-4492-c3e3-08dd61eff377
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2025 05:28:56.5773
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iogh4hFM2lF/ecIf4ka4C7ww1qintzqu+MfmGWxlaeePyqQE2UdBgzkmomyZFJ1baPoMY2cmuvYxsJSUBQXdmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB7113

T24gV2VkLCAyMDI1LTAzLTEyIGF0IDA3OjI1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gPiAKPiA+IEhpIEJhcnQsCj4gPiAKPiA+IFRoaXMgY291bGQgY2FsbGluZyBpbml0X2NvbXBs
ZXRpb24gb24gdGhlIHNhbWUgY29tcGxldGlvbiB0d2ljZT8KPiAKPiBIaSBQZXRlciwKPiAKPiBN
eSBwYXRjaCB3aWxsIGNhdXNlIGluaXRfY29tcGxldGlvbigpIHRvIGJlIGNhbGxlZCBhcyBtYW55
IHRpbWVzIGFzCj4gZGV2aWNlIG1hbmFnZW1lbnQgY29tbWFuZHMgYXJlIHN1Ym1pdHRlZC4gQXMg
ZmFyIGFzIEkga25vdyB0aGUKPiBmb2xsb3dpbmcKPiBzZXF1ZW5jZSBpcyBhbGxvd2VkIGFuZCBk
b2VzIG5vdCB0cmlnZ2VyIGFueSByYWNlIGNvbmRpdGlvbnM6Cj4gCj4gVGhyZWFkIDHCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgVGhyZWFkIDIKPiAtLS0tLS0tLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtLS0tLS0tLQo+IGluaXRfY29tcGxldGlv
bigpCj4gd2FpdF9mb3JfY29tcGxldGlvbl90aW1lb3V0KCkgaXMgY2FsbGVkCj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGNvbXBsZXRlKCkKPiB3YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVv
dXQoKSByZXR1cm5zCj4gCj4gaW5pdF9jb21wbGV0aW9uKCkKPiB3YWl0X2Zvcl9jb21wbGV0aW9u
X3RpbWVvdXQoKSBpcyBjYWxsZWQKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29tcGxl
dGUoKQo+IHdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgpIHJldHVybnMKPiAKPiBbIC4uLiBd
Cj4gCj4gVGhhbmtzLAo+IAo+IEJhcnQuCgpIaSBCYXJ0LAoKaHR0cHM6Ly93d3cua2VybmVsLm9y
Zy9kb2MvRG9jdW1lbnRhdGlvbi9zY2hlZHVsZXIvY29tcGxldGlvbi50eHQKQ2FsbGluZyBpbml0
X2NvbXBsZXRpb24oKSBvbiB0aGUgc2FtZSBjb21wbGV0aW9uIG9iamVjdCB0d2ljZSBpcwptb3N0
IGxpa2VseSBhIGJ1ZyBhcyBpdCByZS1pbml0aWFsaXplcyB0aGUgcXVldWUgdG8gYW4gZW1wdHkg
cXVldWUgYW5kCmVucXVldWVkIHRhc2tzIGNvdWxkIGdldCAibG9zdCIgLSB1c2UgcmVpbml0X2Nv
bXBsZXRpb24oKSBpbiB0aGF0IGNhc2UsCmJ1dCBiZSBhd2FyZSBvZiBvdGhlciByYWNlcy4KCkkg
dW5kZXJzdGFuZCB0aGF0IGl0IHNob3VsZCBiZSBwcm90ZWN0ZWQgZnJvbSByYWNpbmcgaXNzdWVz
IGJ5IHRoZSAKZGV2X2NtZC5sb2NrLCBidXQgaXQncyBwcm9iYWJseSBiZXN0IG5vdCB0byB1c2Ug
aXQgaW4gdGhpcyB3YXkuIApVc2luZyByZWluaXRfY29tcGxldGlvbiBtaWdodCBiZSBhIGJldHRl
ciBhcHByb2FjaC4KClRoYW5rcy4KUGV0ZXIKCgo=
