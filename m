Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F681F0992
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2025 08:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748421168; cv=fail; b=hYGSazQLCyx2QzM/keSkxUjqZM+YmBlcCmGK6aHRZcdDn0Q34RkS6TW3TFnwrup6aQ0gjZKU1ZRGCM+kDA/ue462JS4bt3TgAT5R1tjPfxipE4bqVpiuS7/rKlfM1IzNslgRW0KQG/oWt+zSBFM+atuvCAoCvpDPntiulydPU2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748421168; c=relaxed/simple;
	bh=Jy5sdDFqvC58eTyzHtDEb3ll+95K4yQdQyWNbnzDgek=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LlcbzV3gcCD2ZKggS9xdbUUBoZPcoMo4DwPvmsCoYvCd6KeW3Ibj8YKyT/dKyaIwIhcNW5IsntSXi4961aAYmHbmMzMEct5TqKrO5Sr9HC1EzwI5eiDUOihRjnoRfMtSdT1R7JbrJqzwHRGVDx7VcKRj2Rafz1eDTbhIbOFROg4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ArE6TxNT; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=tei4hNar; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ArE6TxNT";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="tei4hNar"
X-UUID: 50a771203b9e11f082f7f7ac98dee637-20250528
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Jy5sdDFqvC58eTyzHtDEb3ll+95K4yQdQyWNbnzDgek=;
	b=ArE6TxNTywRy++SdM0pI869/w8CCN+OERBQNe/VVliztE9ghx8zuLjNJJpfE1AagZo13pG2f+41rHtVVPpm6sfT+AQkt33RW4lswdrnlkuSamLhmwziYXjowji6BtTEnXs4DSrAqXMdqZBGGi7Vo/VKWXV0ImI5jKqT/pWsCUsk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:419cba93-4f38-4cdc-9363-40e5221ead30,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:0d5ed147-ee4f-4716-aedb-66601021a588,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-UUID: 50a771203b9e11f082f7f7ac98dee637-20250528
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 970822932; Wed, 28 May 2025 16:32:39 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 28 May 2025 16:32:37 +0800
Received: from OS8PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 28 May 2025 16:32:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D3asROn3adfUbXH+SlPPKQxuHsJU6iZu0F+TtVcR64D7jtjrLO6lTgQlytHuKijbA0OrbPKMAcnQpwZAwYBZgwh7LBhDb3Y/7IoCF1jtwz+59ET9Rvkvln+vFyHNTxzFvwJY60ctEkF3cDCdDbbrogDzdg3bB4ENTrbrd0pqTmLWwNPEGgdc1BA9mnpHydlcRUmPbQxi4pKfTyDI+BoUIJ3gQWwD6zwLAc9fb39ZGRIGzW5SH8t2cEoOARhxK0DGKAM7wdBgkdFJCA94e5yo2xYGSuVC10QjJh67JgX+EADn0Dy4eJTRNex1MI4Kmbb9uwwLfroaBBr0iP1X6JPwwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jy5sdDFqvC58eTyzHtDEb3ll+95K4yQdQyWNbnzDgek=;
 b=ifJXVtZr7nFaYonVq91h5ZvL/VUqo/vhT33BpVBcFqHzoyrkiaJUruWgS+yOIA8YNtkNw+MxsITM6h8YAxhrofV4heXG716WQ/Qo8ywM53SxNo13zWPUnmTMxlJHUofaGV/6qXRK71h7KVuZOoNaV+CQg2WbCsaNZdONcV5ThaWxh+cRTDTnyNnId+sW1gtwn6+FR8OWjXJI9XQF3SNJ7z2n6WhrqdmQv9R7MCFaQF4WJ0jPKRENbXU9GCdC7A5O1Al4kacaZyWzqV5K3o2NAMfLlQMwhYEBHlsDXKRcqOYwWqjWtvgg0oSFHdFvtybnhzT55MFcrx4y45emzswBqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jy5sdDFqvC58eTyzHtDEb3ll+95K4yQdQyWNbnzDgek=;
 b=tei4hNargnHyQD+mPAGX2Jf1ftARYPgXBKHcgnpJk3ntX2guqBG116XVFqlLFCdIgfYYF5+ljzmkjp3JyCK1agK5zf9YI/gI6XZntPeTxYfVBtS8lKeqq5GhczlOONlCVR+qATuCMomcXTBwF5NbcUqne0kb3+/M7N7/Vh/qhkI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB7943.apcprd03.prod.outlook.com (2603:1096:400:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.25; Wed, 28 May
 2025 08:32:32 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8769.025; Wed, 28 May 2025
 08:32:32 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "avri.altman@wdc.com" <avri.altman@wdc.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, Sanjeev Y <Sanjeev.Y@mediatek.com>,
	"santoshsy@gmail.com" <santoshsy@gmail.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: core: ufs: Fix a hang in the error handler
Thread-Topic: [PATCH] scsi: core: ufs: Fix a hang in the error handler
Thread-Index: AQHbzB9auVPXGDRIzkKd3VohNkQZa7Pk6deAgAIj2ACAALAsAA==
Date: Wed, 28 May 2025 08:32:32 +0000
Message-ID: <32f45a00d5c1cdf26f91bde4821fe73d5b06dadc.camel@mediatek.com>
References: <20250523201409.1676055-1-bvanassche@acm.org>
	 <2ab0ae98fd101d893d4f20112771cdb623fbca67.camel@mediatek.com>
	 <ecfd1748-d257-48ae-808e-c672ac2f1536@acm.org>
In-Reply-To: <ecfd1748-d257-48ae-808e-c672ac2f1536@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB7943:EE_
x-ms-office365-filtering-correlation-id: 8e54612e-5b64-46f4-a37e-08dd9dc2309d
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?M2lBN0lienF5bVJoaENHRTZnQ0ptTTdUU1dNSGlPaGQ4K3pqb2dISXhwbmt5?=
 =?utf-8?B?U3ZjVDN5Vk80Yk5PSWE4N3V2TVNVRHpwTHNHeStyNnJEOHBJZUhTa3c1SjNV?=
 =?utf-8?B?NG52REY4K285emJvekc1VzlHOTdSTURKRmF0eEwyUjhuNjFQeWJBSVV0Mmht?=
 =?utf-8?B?ZFpGV2dpWVNlR1BOOC9CMEdYTWczaFVPb2NMQnkxZTN6bGlrQ2JVMllFV044?=
 =?utf-8?B?MkNwY3BYQUM0VFBGdjVMSTFWUGZVeE9nSHN1Mk1HZ3Azd0NIM2Z4T0pEYmRs?=
 =?utf-8?B?bW9BQ0EvVldlek9qT08rZWVVRUtiTjZrcndXUkdTZXZOR3ByMlJMWTgrSWFV?=
 =?utf-8?B?UWJzVmU0QjB0WVVYb1lsemo5Q2FmTnRNSWFsdGcwdFRWS21Cd0hHUGsyNEpj?=
 =?utf-8?B?dVVSaWFMbnpzc1F0MFFoTTRlTkhTM2VHQkdiME1WWkFYTk5zMVFyQXpDRmdw?=
 =?utf-8?B?c0YwZThqMGg3d2dIKzdRL0ZYRmg5ZkQrejlsZkRJUytTZkg2ekx3Ryt3WTNL?=
 =?utf-8?B?dWtaV29XVUdhZWZwVlRKTWdvQ041N3UzRnBFQkpYQ1V4N0dtM2JTZ09mTFJ1?=
 =?utf-8?B?MmhNNlVNcXpLWGVWcmtRbHppdEt0TUtSU0dvYlJ3WWtQS1FOZ3dhWXdxbGlh?=
 =?utf-8?B?cHI4STdlajIrVU5GT1dxWE1TbVRMNWRsRS9ZRi9HV2o1TXV1aXh2NDZ1V0RW?=
 =?utf-8?B?WEtVVGF1aHdmZ0V1OWhkNlJoeVJYbG9aRW56Rm1UL0lQZUdpVjVZT3ZWbm1D?=
 =?utf-8?B?b0J1VU1CelRrS2J2eWZ6a1NBMTlGQzdta3VKekNlSzFsMGdSYy9hbnhhZ0hu?=
 =?utf-8?B?WndjUEI3REhXQ0ZSNmY4MEhFUk5CRkhNSW0rWlBGQWtGekx0SmVJRDlqamNK?=
 =?utf-8?B?dDl3b2xxY2tnUXpWT21WYXFvKzJySnV3SjZrZkFRUjZLZzRSaGRRMmFXSitl?=
 =?utf-8?B?K2hIUjN5bEZvbEU4R2xMaU9maUFNSHorb1V5RnU4aFdCKzF6am9PbGdTeU5Y?=
 =?utf-8?B?SFJROHFoU3dWSWNPZHlLeC9ydFphNTFrRlBEMkJLMC8vTEhtNUdOUEN3aDZ2?=
 =?utf-8?B?bU93M2VaWXQ1dnFLMWc2RXdobTNEVjE2NHVZV29mQU5Lbk5hSFhnNHljWVpL?=
 =?utf-8?B?Z3ExNUNZc2hxZkdkQkJlU1lLVkdtMUlvNWNNWW1ydk1BL0pYek9TL0ZBZXdJ?=
 =?utf-8?B?VWN0NXJLT1JiQ2xVdnBmby9mZzRBRzRLdmU1bGVHdEd4WkY4SmZRSkY2SXVG?=
 =?utf-8?B?aGtaRUZBc2Z1MnljYkZpS21lcXI4Q0RJVGxJMmdPdGd3RzdmYyt6cUdZdElJ?=
 =?utf-8?B?SlppUGF1L1pFdXY3WjBub011dTd1U0ZEL3k5MmJ2RW9hRU1uQzlHTCtPLytV?=
 =?utf-8?B?dkJBalJkK2p3MDE4VmQ4K2pzTCtUd2k2WDNBZFZRT01ybHcrWG01d1NUNjkr?=
 =?utf-8?B?MTJ2TjQ4dDhUR2RPNmNFeGoxM0dxVDFIZGttOERIOWlwSXJHNGltSnpLY2dC?=
 =?utf-8?B?RTRvVUNLbTRsUEk0KzhrOGNiQXVaRHhsbHZBSkd5aFQ1MjE0WmFnL2tTVEJy?=
 =?utf-8?B?Z0ZaUkdYU1JEWmkwbEswdmRnVW1EZEk0K3UzWWIrZW1UMkp6NWcwNDNjWlhx?=
 =?utf-8?B?dHhZbW12NUpwdGU1dTJBVnRrM21Nd1VGU1p3a1hGRU5UeTNBK0JybVJoaE53?=
 =?utf-8?B?TTUxMW92RHJqWWNIc2xaWDRXeGxINTdCeXFTcHNuTHlHTldGZlk1OEN3Z1dC?=
 =?utf-8?B?N3p2UHgzNGU1QmthVUZrMzN0NEFRLzhnVTc4djRvdzR6OWRSY01BT2hMcmZv?=
 =?utf-8?B?QkxOMHVaejRESkpiUmpjdXVLZDlpRW5SVGkrSGE4clJXdXI4YW41V3lTdUU1?=
 =?utf-8?B?bkpWSFR4ZDhzbWg1TEN2Q2tDcmNmeGwvamUwOWswN1M3eFVyTmtGcndsb0ho?=
 =?utf-8?B?WFJRMDhndHc3YVZCNFFGdjN2aEtRc0xKNXIyODR3eFRYSVlDVGRuMFdXKzEw?=
 =?utf-8?Q?gw9S0SzM3aMYZIIZ7RGgKKwi9lPVW8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFpxb1B1Z3lNNStpcng1Y29YU0RyekNNZ0ZpbEpwemJkdmRDR25oaDRCc3Ro?=
 =?utf-8?B?UG5OQiszbmpoY2tiVDVGSVY2TUxnQnd0Nk12KzJ6RnZNUE8vWHJrSGhDM0RD?=
 =?utf-8?B?QTFMNlU3aFJ0c2RQNzZlMEh1d2w5eU5NdXJFZ2Y5NGdubERHcW0vaFg0cmY0?=
 =?utf-8?B?bHB4WmRhK2hXbWE1ellIU2UvWTM1MVJvSU9Ea3IrWElsVjExb1l4MzUraWsz?=
 =?utf-8?B?YTAxNnp1dFdOK2ovWmpvUjRyS1RuaWhvNmxjVEhXVElESU4waXcybkwvT1Qv?=
 =?utf-8?B?QVN4SGREcDhqRFpEUndWMmFyeENzYVVVOTBhalpkWFl1ZXlyOW02eHFrUXhT?=
 =?utf-8?B?Z09WMGF2cmhWbVVJNTViRWZ3YXltM3gvMVcvUVM4VUoydzl1MDNjZ0R3dWVW?=
 =?utf-8?B?WHRPOGR0UEpsVXRVTlpQeU4yNnhBWURKcm1zVExHd2Rub0krTjZYWXJBcjlp?=
 =?utf-8?B?bjVzT1ozNWZIb2kwZk91SDM0UXYydmFPTTBidXQ3MlNVOEU2SUdqOXU2cUd6?=
 =?utf-8?B?NDJQYnJxZ0p1anNEcnVuTERVcUJpZHMwZ0VGVlpQVWpXS3UvMURGY2lxRmhl?=
 =?utf-8?B?UDRiTjdlK0pPbGQzbnYzeStHdVpmcm81SE9Vd1JBZXlMY0JjNzQybkdyN1dm?=
 =?utf-8?B?QVJzREhmdEFaeXY0LzN3ZFFzK0h4OW5sNGFjenlaS09EdCs3U292bDNiMXhF?=
 =?utf-8?B?TGFULzhJcFRQS1c0Ry80ejFuQmU3bGtUYU1MSjRBbmhWNkE4ZDUzT1JTcXBR?=
 =?utf-8?B?eVVtLzlFcXZNUzR3MlllZ0E3Q3EyT3dWcUR3V0NzQmZOV0x4VGJsVTc1enp5?=
 =?utf-8?B?dm9CQXBQSnRSNkVML0s1WUY4WTdsSmN5T1F2aXBoV1BINHNwKzVaR2ZSeGJT?=
 =?utf-8?B?c01pY3NiYlZzeS9ObmwzQU01czNaekhJTnkwZlQwd2l3bUI5N3dRMFJPL0tK?=
 =?utf-8?B?KzBjSmpJK3g4Q1kwNHRqOEFxQ29UK1NvVEk5VTlaT0lRbXFtRXc2NXR0dWx3?=
 =?utf-8?B?VTBraTJ5b3JEYjFzQnBOV1hmNm9YeGh4anBhYkE0dlZOUUhDaStuZmlVZTVR?=
 =?utf-8?B?N3U4ZWM1V3QrWHJMS2ZEWks0MHc5bWkzc2NLWDlWZzlwam1XVlJaQnJrSnAz?=
 =?utf-8?B?Ym5VUHFqQkgxa2tXRkVZYWdZZVJSWGZQYzNxdXpwc3RnSHlseXlsazNCYUg2?=
 =?utf-8?B?MERvVWFIcTRRcGdYTFFwSTF6dGh2OUhSWnhnQnNlcnBBU0ZNSlhQSVI0VzA2?=
 =?utf-8?B?YndmYk9INGdMcHFmVUd5dmlNMVl1NVpTZlhyYTgreGF6VkE2ZzRCOGZrRVB0?=
 =?utf-8?B?T0F1TEFxdGFjNUxQNkU4UWlpOFQ5NXJiSm9FNGcwN2FZazNLSEtZczFwTlJ0?=
 =?utf-8?B?Y1RJYVVSQ0dMbXNhSHd0ZmgxdkFBVmdINzE5SjM1TldHZVpHaGxlRjV6SUxL?=
 =?utf-8?B?KzRKR3pjMjJpZll1dFFiNU1FNWh2RGxwSEdzdVBTZVFCbFRZRDgyTURDcmhk?=
 =?utf-8?B?TXhUTVAyYmZENldoY3d2bThZenpUNEs3STlFczlUTjBKUUpReUZtRzVHTkNF?=
 =?utf-8?B?Q2RhcEhpTGJaK0tzVDBveTFGQ24vRzRJQTMzbkQ4NXBiOTBxSUM0bFNhUzhh?=
 =?utf-8?B?ekplV040ZWZoeXNGMGt3NStHN0w1WmE3KzhEaEh6T1J3MjBHc1Z2Tk1JVkhL?=
 =?utf-8?B?emFKMmU3M2V5RHJKV2FPRERNbDBzenBaNllCeXBlRWU0M1JuS0x3ZXhqZ0NQ?=
 =?utf-8?B?Y3ozS3ZZeDJZOUtpTEpEZi83VFNhdU1JQzhaZ1oyL2x6RlM5aUhUL0RkNDJp?=
 =?utf-8?B?ZXVzQUhuMVhja2RoWmFuZGlwZnJTMDg5RUcrdXQ4Zk1iOEZHRHA3NFluckVO?=
 =?utf-8?B?SmpLd0FpZm1CaldycXFrMDV1a0ZUT1JsNitEbmY3RDlTUzBIQlo2NjdVeFU1?=
 =?utf-8?B?VCt2Q3NhWVFzTk1IUzNpLzAzNzYwRklWQlN3OGRuVHZKRGgvN2I5aUw4a1pQ?=
 =?utf-8?B?czZwK1RCSmNQZnJKQ0tqczlhbE5jQ3ZXZE00V2o4ZTRqSWUxNlZMM3hWM01E?=
 =?utf-8?B?ZGNidDNZcHFaSGhQdStsZU5xR2RVUUY0eG1la0xMdGo3cmt5aHJlMDVMUXFl?=
 =?utf-8?B?Y2QzaXFvazJya2w0eDFvOUNDcG5IUUpEU256OUJDTzVKUW0rVXBERlZUZEpO?=
 =?utf-8?B?enc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <506A36FBA34BD442B5D412B130CBA62B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e54612e-5b64-46f4-a37e-08dd9dc2309d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2025 08:32:32.1289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qddBl+tLafExKIKP6wNSiH2G8DmFSZ3wvk3kWh0sUXxDF58/XnjpYxnwTQnMISjCVmEwxoaTJRQbDTm47KOk8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7943

T24gVHVlLCAyMDI1LTA1LTI3IGF0IDE1OjAxIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiANCj4gSGkgUGV0ZXIsDQo+IA0KPiBJIGhhdmUgbm90IHlldCB0cmllZCB0byBwZXJm
b3JtIGEgZnVsbCByb290LWNhdXNlIGFuYWx5c2lzLiBJIGRlY2lkZWQNCj4gdG8gc2hhcmUgdGhp
cyBwYXRjaCBzaW5jZSB0aGlzIGlzc3VlIGhhcyBiZWVuIG9ic2VydmVkIG5vdCBvbmx5IGJ5DQo+
IHRoZQ0KPiBhdXRob3Igb2YgdGhlIGFib3ZlIHBhdGNoIGJ1dCBhbHNvIGJ5IG15IGNvbGxlYWd1
ZXMuDQo+IA0KPiBSZWdhcmRpbmcgeW91ciBxdWVzdGlvbiwgYXJlIHlvdSByZWZlcnJpbmcgdG8g
dGhlDQo+IHVmc2hjZF9saW5rX3JlY292ZXJ5KCkNCj4gY2FsbCBpbiB1ZnNoY2RfZWhfaG9zdF9y
ZXNldF9oYW5kbGVyKCk/DQo+IHVmc2hjZF9laF9ob3N0X3Jlc2V0X2hhbmRsZXIoKQ0KPiBpcyBu
b3QgdGhlIG9ubHkgZnVuY3Rpb24gdGhhdCBjYW4gdHJpZ2dlciB0aGUgVUZTIGVycm9yIGhhbmRs
ZXIuDQo+IFRoZXJlDQo+IGFyZSBzZXZlcmFsIHVmc2hjZF9zY2hlZHVsZV9laF93b3JrKCkgY2Fs
bHMgb3V0c2lkZSB0aGUNCj4gdWZzaGNkX2VoX2hvc3RfcmVzZXRfaGFuZGxlcigpIGZ1bmN0aW9u
Lg0KPiANCj4gQmFydC4NCg0KDQpIaSBCYXJ0LA0KDQoNClllcywgaW4gbXkgb3BpbmlvbiwgaWYg
YW4gZXJyb3Igb2NjdXJzIGR1cmluZyBydW50aW1lIHN1c3BlbmQsDQppdCBjYW4gdHJpZ2dlciB1
ZnNoY2RfZXJyX2hhbmRsZXIgYW5kIHRoZW4gZGlyZWN0bHkgcmV0dXJuIGJ1c3kgDQp0byBicmVh
ayB0aGlzIHN1c3BlbmQgYXR0ZW1wdC4NCkJ1dCBmb3IgYSBydW50aW1lIHJlc3VtZSBlcnJvciwg
Y2FuIG9ubHkgdXNlIHVmc2hjZF9saW5rX3JlY292ZXJ5OyANCm90aGVyd2lzZSwgdWZzaGNkX2Vy
cl9oYW5kbGVyIHdpbGwgc3RpbGwgZ2V0IHN0dWNrIHdhaXRpbmcgDQpmb3IgcnVudGltZSBQTSB0
byBiZWNvbWUgYWN0aXZlLg0KVGhlIHByZXZpb3VzIHBhdGNoIHdhcyBzcGVjaWZpY2FsbHkgZm9y
IHRoaXMgcmVzdW1lIGNhc2UuDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3Qv
bGludXgtc2NzaS9wYXRjaC8yMDIzMDkyNzAzMzU1Ny4xMzgwMS0xLXBldGVyLndhbmdAbWVkaWF0
ZWsuY29tLw0KDQpBbmQgZm9yIHRoaXMgcGF0Y2gsIEkgZmVlbCB0aGF0IGl0J3MgbGlrZSB3aGF0
IHlvdSBtZW50aW9uZWQsIG90aGVyIA0KZnVuY3Rpb25zIHRyaWdnZXJlZCB0aGUgVUZTIGVycm9y
IGhhbmRsZXIsIHN1Y2ggYXMgYSBVSUMgZXJyb3IuIA0KU2luY2UgdGhlIFNTVSBjYW4gYmUgc2Vu
dCBub3JtYWxseSwgaXQgbWVhbnMgaXQncyBhbiBlcnJvciB0aGF0IA0KdGhlIGhhcmR3YXJlIGNh
biByZWNvdmVyIGZyb20gYXV0b21hdGljYWxseS4gQWZ0ZXIgdGhlIGhhcmR3YXJlIA0KYXV0b21h
dGljYWxseSByZWNvdmVycywgdGhlcmUncyBubyBpc3N1ZSBkdXJpbmcgdGhlIHJ1bnRpbWUgDQpz
dXNwZW5kIHByb2Nlc3MsIGFuZCB0aGUgc3VzcGVuZCBpc24ndCBicmVhay4NCk9yLCBpZiB0aGVy
ZSdzIG5vIGlzc3VlIGR1cmluZyB0aGUgcnVudGltZSByZXN1bWUgcHJvY2VzcywgDQp1ZnNoY2Rf
bGlua19yZWNvdmVyeSBpc24ndCB1c2VkIGRpcmVjdGx5IGVpdGhlci4NCg0KQnV0IHRoaXMga2lu
ZCBvZiBwYXRjaCBhc3N1bWVzIHRoYXQgdGhlIGhhcmR3YXJlIGNhbiByZWNvdmVyIA0KYXV0b21h
dGljYWxseS4gSWYgdGhlIGhhcmR3YXJlIGNhbid0IHJlY292ZXIsIHVmc2hjZF9lcnJfaGFuZGxl
ciANCm1pZ2h0IHN0aWxsIGdldCBzdHVjayB3YWl0aW5nIGZvciBQTSByZXN1bWUuDQpJbiBvdGhl
ciB3b3JkcywgdGhpcyBwYXRjaCBzb2x2ZXMgcGFydCBvZiB0aGUgcHJvYmxlbSwgYnV0IGl0IG1h
eSANCm5vdCBiZSBhYmxlIHRvIGFkZHJlc3MgYWxsIGlzc3VlcyB0aGF0IG9jY3VyIGR1cmluZyBz
dXNwZW5kL3Jlc3VtZS4NCkhvd2V2ZXIsIGJlZm9yZSB3ZSBjYW4gaWRlbnRpZnkgdGhlIHJvb3Qg
Y2F1c2UsIGl0IHNlZW1zIHRoZXJlIA0KaXNuJ3QgYSBiZXR0ZXIgc29sdXRpb24gZm9yIG5vdy4g
V2hhdCBkbyB5b3UgdGhpbms/DQoNClRoYW5rcy4NClBldGVyDQoNCg==
