Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754A21F3BA4
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 13:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765372462; cv=fail; b=kN3zQwYFb48gnfpVq31xyR8z8MbeWBzT94tyLIqJ9fNgeb/dEWWJctikGFyjHUQcR93UWq4y6rdC/7UclwbpWR31x7p4n2G1WLZLoAa+5PxTDhjGQgfUlt7yVzwYjwKkeGXu+Eek4gsrUcgmswqqd+o+k8hQaiUtlgEYaYUO+OE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765372462; c=relaxed/simple;
	bh=qbYkm8TBG7Enj9TPBxMLqQYYoC6e9u4tY6Wj177m6Zo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J0SM9GgwPW5sRZ8Rm2AOUWX7uK9wrs5rhYL14zOcsCayVBPm5t/FUupmYLj3bcT+dtjwRcFtB315BE50GYqGmq2I3RyDR1XF9VvO2YM89x7Y9cyXsTphUMF2pb2Du7EIba6MSHm1aTS+pyPt/KxsdF8kb+GqXw7UzmBUc/c03qk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=aVVmdTjx; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=BV+M9tPU; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aVVmdTjx";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="BV+M9tPU"
X-UUID: 1fd6b5c6d5ca11f0b2bf0b349165d6e0-20251210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=qbYkm8TBG7Enj9TPBxMLqQYYoC6e9u4tY6Wj177m6Zo=;
	b=aVVmdTjx9nThqA94LwbfAxI1vAbXLnsy7QknD53yYBlf67eoJoJnVsRieoVwku+fGWpe1XvTxJt8tMJr4cJ9F83CK4yx4KIqCcOKjsMgXpp7Ka82yxzxYYfhF9jcIeB5Pn5x+izXQJjnBTE1htraCU3tUf3AYzUEQg6mHVU+4xM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:cf1424be-9000-44da-bd95-c59395019f57,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:9f324ac6-8a73-4871-aac2-7b886d064f36,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1fd6b5c6d5ca11f0b2bf0b349165d6e0-20251210
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1910641580; Wed, 10 Dec 2025 21:14:14 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 10 Dec 2025 21:14:13 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Wed, 10 Dec 2025 21:14:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sP2mSCy+hkpgEDn23roOFxoL3gvPZH2VJ0Ovte1ku0w44SO03rqGfVtAO8dVawKedmCD5U3QivxuC3ErcdoKIivt0IuOrK/dkN4/XGtFH4H3ZUeu+VyjB35PFVCkeJsiOkLvHRcfp5FDgk/8xLa03/ZY/AqDygy4W4aREGED9FYQl7DW0DQGHCf5AT0nvOXowsbpIp2WlcT6CFguve/RE/dY3BU8bFV3mrdB2D3jLg2fGvkTbDCwz6YLQ8+jlwfm0Cr3PPeNlUw0oaJIo146t3tVLWKLyhd3pnxIVSnxwkir4oCvMp5QKTaYQ9OedsSsOqa1B6Bz8BJO0fxEIijlqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qbYkm8TBG7Enj9TPBxMLqQYYoC6e9u4tY6Wj177m6Zo=;
 b=snrw0IpnLjwDpUl85xi8FCjOrm4iB5Ry6l17itnXwRyGDx8mxWO4SnTv7TpD0yttpwrqKI+0vN52dGvmonJ2pq2WTNblXMaJTPdSexglt+D3QP0SQRhciCKptFsnnOH0XfqXonOlWkT61DRlnDFm+ghOVJDMsyXV7MO/l4onrwGLcf5pf+6UwNbNnoPTB3S2WYJz/nOQiwu9kDuR8Vm4xqH+CUKXWC617KiVgIOkWS9qV9+cYKPxbuOgs5vKDzao+tFWp4w6PcSCwnCxu6Nk8I5nXMDTXITeGovH47azmfomUdu63e/udP8nxnv0ycc09/VE7wj8HXGQqNKeUC5fBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbYkm8TBG7Enj9TPBxMLqQYYoC6e9u4tY6Wj177m6Zo=;
 b=BV+M9tPU746H5owVHATwOnk2jZjE9+QvJW//byDVdfPRB/SdSIOmkUX5oDQH4liTVheLnC0ryt8aC848KdIEIBgts3dKGAd1HsEEn5vbOxNpl3OGXsKkzboesxdPMqowj+WhDZP4wfB78pnjPlyl+V6DSTNv3iXPkymjMafJeGM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6599.apcprd03.prod.outlook.com (2603:1096:400:1fd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Wed, 10 Dec
 2025 13:14:10 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 13:14:09 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: Uwe Kleine <u.kleine-koenig@baylibre.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "Kai.Makisara@kolumbus.fi" <Kai.Makisara@kolumbus.fi>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, "mani@kernel.org"
	<mani@kernel.org>
Subject: Re: [PATCH 1/8] scsi: Pass a struct scsi_driver to
 scsi_{,un}register_driver()
Thread-Topic: [PATCH 1/8] scsi: Pass a struct scsi_driver to
 scsi_{,un}register_driver()
Thread-Index: AQHcaUzYIqkdI53Ajkyy5ul5TwYID7Ua2yEA
Date: Wed, 10 Dec 2025 13:14:09 +0000
Message-ID: <0d170b964dd7e7e3096819e0015942cc6a35d805.camel@mediatek.com>
References: <cover.1765312062.git.u.kleine-koenig@baylibre.com>
	 <a63b9f2a4f03499a9350ab19ded785e9da226752.1765312062.git.u.kleine-koenig@baylibre.com>
In-Reply-To: <a63b9f2a4f03499a9350ab19ded785e9da226752.1765312062.git.u.kleine-koenig@baylibre.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6599:EE_
x-ms-office365-filtering-correlation-id: 8d016e9b-7163-4ff1-5f09-08de37ee0128
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NWJlNDNCdmE0OXpQZzdhV0FVUjRjd05XcXI1dXp6RnNuSFJ5SUxvYWdDUnVE?=
 =?utf-8?B?RUlFbk0xYUxlUkFFbENnVTNqMFpYUzBtZVdJWVRGcXdYeVVGK3Y3V1FJYW9t?=
 =?utf-8?B?MWZGVU5VdnVuWlZrU3YvaVhWOUVVSTVNWk9yaUhJbmIwZnMyMnNxZTM2c1V0?=
 =?utf-8?B?UWlnTkZ0clNxMHl2TktScDg3WVQ5ZnY3KzRZdHNWc1p5T29PWmxQS21tU0U3?=
 =?utf-8?B?L2FnQTFRQnlta2haOFpXS2pPMHp1aFgwK3I3aEowNU8xeWhEenAyQ3Bsd3h1?=
 =?utf-8?B?T0tZUmJyTUNUR0hiT2E2WkVRcWJsYW80K09wUFhDUkpOVUN2YlprbFRtR0dm?=
 =?utf-8?B?R3EzcW5PbEZxWFFQTVYvb25VR2tFdHkwYjZibnpYZkxBM2NhMWxhbm05OGpH?=
 =?utf-8?B?ZGhMZy9TUFkxZ21BVHZiSm5GR2haOFNQTENBWEo0UWxBZVVUQ09ESlAxY3pu?=
 =?utf-8?B?NWV1VW5lb1RkaHV0cXgxbHZQVUEwSVpBQW1Pc3BLaXEwNjkxck53anZOQzZ4?=
 =?utf-8?B?amVwRFZXMTFCeDdzaGduRENLVHo1eHdDY0ZOZER4YndEWVhhR2x2b1hFelcv?=
 =?utf-8?B?VEJnZHlUdWdTWjlnNjhPdDdOQUphVTVNQWFsT044SnZqaDkza0VGaVM5WjVN?=
 =?utf-8?B?cnBlS1A3YmozVHFxeXlCWnVFMFhnUktBSVJBYVBFQ09NcStXRTZKbWZDRkJP?=
 =?utf-8?B?aXNKN0M5ZW41YlowdG5IUERxbGUrc09VT3gyTHlud3RUeXZmbytTenlGM0FQ?=
 =?utf-8?B?YlRRU3QyVkJPYUNSSFZiTk5hVVZmeERvblQ4M0tHTUNzYWlha0VXMEpxeW5Y?=
 =?utf-8?B?eTl2NyttSkhON0xqdHJsendKZjF3YUQybWZpNW5oV2hXN0NTaU5IU2gwSVho?=
 =?utf-8?B?TWFoYjM0SWxpUGF2L2hKTEVNVk8vOVFhYWgzVnNrS3JyUStwUlFKL2pTaDFa?=
 =?utf-8?B?Y3g0cTZHOGNYNlZkZmtzanpQVEp2VzFpZDJPSVNZVlpieEZzUWZkNWVXTDVh?=
 =?utf-8?B?S0F6UWVqS2J4Z0pzVENQKy9XdUJTemFRVE1Oam82Rzdzdm11Y1VudU9kSG1R?=
 =?utf-8?B?ZCtoblFzMVdvQjUvYVBCRzNKeEk0RWZCbWVTbWE4Wng0aDRCb2xLTXBIZzZE?=
 =?utf-8?B?am5PTHFxWUpsQVBFdE1IK003RkYyV2wvaDFNbEVLRlRINmZuL2VZVmYxMW96?=
 =?utf-8?B?OGFNRUNacXRCUVJjTFNIK1d0SVlKdkVrWGtzaWhaYUFPd1ZobjhCRTBwVTVn?=
 =?utf-8?B?Z2laOHBPWTgvbFpKVytndUhtNHBaemMrc2xtZTNDRGVYb3VaR3JHdkJkREtZ?=
 =?utf-8?B?bm9Ya0tXRUVlUFlodktzbm9TRjZWYWJRdklpOGtTU2tITFN2VXEraVVTaGMx?=
 =?utf-8?B?MFF0VVJmVExrUVFCOWFIcDRNZTk2bkV4ZVVSdG9vUmwzWGxNQ0pHQXd4OHRo?=
 =?utf-8?B?cThYMmRwYjJZQ0kzbXpqeE0yOFJwMTBwZ1dSOWVaRHJCTUIvVVk3UzFmTWZ3?=
 =?utf-8?B?UC9aazRZcW45TGxOUFR4RzQxdXVIL3Y1bFZIeVlzZ2o0L1JrL3VGNDliVjVi?=
 =?utf-8?B?R3hHZWxza0l0N042YkErejV6cnhYNExjaDdjb290a3R3Q3M0TU5QS1BLRzZx?=
 =?utf-8?B?MjJMb1pzbGZKeTBMKzVDOHl1dTB3R2w2empDRkhsdjZGNVp5alI5dXc2eEVU?=
 =?utf-8?B?OGhFa2NEQzNWVGxrQ1czZm02UTUxdjlVNjRCbDJITTNMekRkK3dmOG9BUnVk?=
 =?utf-8?B?NHl3aW9wMTB4c2xLcjdhOUlrTXFCRUkvbmVqTlowQ1lDVU1aRzk3NmFFZmR2?=
 =?utf-8?B?MEphN1AvbCtoNXZ1WXMzeVN6Z045UkhOT2JSbHVCazM2VTkrbVJLczNibUVI?=
 =?utf-8?B?RjhrdnprNFA0TUJNWlFHOGpPU29IMC9sT096VVdhZENPQ21XRWlneDYzeSsz?=
 =?utf-8?B?YmlMT3pmVjB2SmZRbkNHenRxYUtqa3AvcTVwM3ZaclhRQUl2OWtzMVljQVRB?=
 =?utf-8?B?anZWWGh1NVFBMCtXTW95Q2xHSWk3U3AxcGVZeDloNjdIUy9sN0k1Mmx3MEFh?=
 =?utf-8?Q?zcwZBn?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajZjT2Iwd01QSzloeE9vdmxYd2RXOXAvTnlxc2VmaTZtK05Yb0grRXk3a2hh?=
 =?utf-8?B?bkRIUzBDWm9tM2xxQVdnSHZoRC8zbDNPNHRyZHZNS3BhVUlUN1hPVWF6T1Bq?=
 =?utf-8?B?MEo0b1JLbnFUdTlmQUpsRkN5NmpIWENhQzZPR200UXNrVTdIcm80ZmxCOUNx?=
 =?utf-8?B?dVZFODltTkY1cGZWTGYzaE16Z1hDMStJempEVCtMZnJZUGxMdnA4WmVVS29X?=
 =?utf-8?B?ZjFWOUVkNFJNR25kT2V2NWpraUVoaHBxcDVSbjFGL0k1YVFEVTd5Y05Vakt6?=
 =?utf-8?B?eFU5WHhzNy95S1NxMTZjWSswVjMvdzFDdXhmSDE0TUdyN3ZXVVVqRmo3ZjVR?=
 =?utf-8?B?ZVZpdW1wNVdKbiswTkJiV0RiOXUwQzhiellJTDRJcysyNGhTeHRtWEVFQXU1?=
 =?utf-8?B?OE9RQVM0MElySHlON0hhalRXR09DSUJmYXFuajNmUWhjcWpzZ0ZaelhTY1dH?=
 =?utf-8?B?OXhYZWpDaGJNVFovUFF3eGUyb291cUtwc21oZlVsbWNuTm5FaVdyVXM3LzZm?=
 =?utf-8?B?Tmx0U21oNG9aeTBzdlRaelp0Znh6QkR0dlJFdFFYRzNsYW4rdWtYaHZVQ1VK?=
 =?utf-8?B?V1RYUHl3ZnFtU292aXZHd05mTE5JNWRKUktLYWV1a2pNMzJnWUk0Ulg3OTJ4?=
 =?utf-8?B?NlFmNkY4cGxETjhxS0xLbVorSUxhc20vL0xjblhaaDVhcVlTMkIyZzVNVk8z?=
 =?utf-8?B?QVo1aHkvYkFZOW5JS0NvR0E0MWgrUkhqNDJabGtEdVp3bUdHUHVPUGJmTzFI?=
 =?utf-8?B?SjhXd0hnVWJkNE5VVUEzQWF3bnJ5R3NPMUlCbDJSdXkrOU4yUXQ5U25CNWdh?=
 =?utf-8?B?R29rM2hLb0diK2R0b21nU1QxaGZveU81U2NtTEhZK3VhTVoxMDMrWnk5RlhF?=
 =?utf-8?B?YXRtWDNnNWJyVTRIN0F4aE1tenVIeGJLamI4V29CNmFOWmErdEtlSmYrMTBm?=
 =?utf-8?B?dXR0aWZybVdUcVBYcFVkZGRya2dNSWxkU1pCdHZRM3p6QkkzNzczZkh5QXdI?=
 =?utf-8?B?YkkvMUpFQ1crNTM2L1BjTDFtVHJMSzJZQ0g0T0ZXbG5oMVI4d28wZlcyNGdw?=
 =?utf-8?B?NGQ0WGFoc3M4cVJRYitVcmtKN3BtMHJmZTBPd0M4VDdBMVZ6WTBoOStEUmJv?=
 =?utf-8?B?Q0Rqdk5mSWdQQW5LbXljcFdOMWx6ZnkrZTk0OE9YTk03YWp3bFJkSWY3anZ0?=
 =?utf-8?B?NE5ZSUtTdjVNdkxkT1pPTUVoVW5Fb1RvUDhnbEdaQy9LTGgyaytiUDhhL3dt?=
 =?utf-8?B?bCtpUE5sOGU1cWxsWGNIL0pDd0xqN0pTN2cyZEFONmMwZjRZY0lKT2pzMm9a?=
 =?utf-8?B?MUJVQ3FhWTNqYkJJckxHVW9UK3JlMTZpOTQ0UWJCRUttYlJlc0Roa25WUGE3?=
 =?utf-8?B?U2ZncmMxblpBdnliZ1FpQlBQRmk5Nk9sODRQYVA1dzJVak9iR3UySW1WQ3NJ?=
 =?utf-8?B?bS90SVQwT1lDZC9LZnZoVElVQjZSMUw5ZVlSZkl1Z2tNTmhvQzhoNDhVTjNs?=
 =?utf-8?B?UnMrU2VaRWtUWEtPcDBpNTFJSTlVMEg1dXc4SWxRL3lRL3NNUHNCK1VMQWxo?=
 =?utf-8?B?dWF2UEcvcE5iZ1JlSGdNeWsxMXBlUTNGbFRPWU94b1NxeHpzQUF3OWNFT1BQ?=
 =?utf-8?B?aytXcWNPcFppeVRQeitHcmtVK3NJK0tVVmlvMTlNaE5wQWZhdCtHKzN0YlVr?=
 =?utf-8?B?UWpvcmFyMHlDOEMwS3JWeUxxMTM4dExlbXhxaHVlUDFPbUt1cFlwWWV5d2R5?=
 =?utf-8?B?OHFxdzRFR29ZSGlRWndVNVdHQlZVaEpMTmZGUDBqV2MybmtISEIxdTBKK1c2?=
 =?utf-8?B?R1phdDZ0VDhuaU44TmNSZ1NiOXkyVHNuK0YrbndXbi8wSk1IS1hGbW5pSDND?=
 =?utf-8?B?V0Y4TzhWdkxoZTd2WVQxNWdzdWlLdkwxNlNrTVVrWndydFBncWx2cVFMcDRv?=
 =?utf-8?B?d3l2VmxQcGVpRDVLbVhZTTllWjZ3bFVDdFRZTDlHV2ZlL3Y1c3NTdjFrQkFx?=
 =?utf-8?B?dmNwK2hpYUIyYUh2Sm10dGt0Yk1jd2VpdnZuaEV2dGh2UFFqby9kYkNUWElS?=
 =?utf-8?B?QUQxbGRTYVZsWTFHTmU0Z28zdW1YbFRwWldNZHZWZDJmUXJ6UE1pSVp0eWd0?=
 =?utf-8?B?blVRQk5ld1FWZjFpSk1sU0k2ditvaG9JTXp6OGlFUUc0OFZkMjd2dHU0QTY3?=
 =?utf-8?B?Q1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E5A40F515CDF748A63D0E27A0193C59@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d016e9b-7163-4ff1-5f09-08de37ee0128
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2025 13:14:09.4046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BOq2EbYjU8AL0NSEV9jAC0WzsHMmiRpGg1yCTZ2iuhKs+xtK4lWX1j1Tb/rb4Fa9wyJL4n38tuetc9roe+mhvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6599

T24gVHVlLCAyMDI1LTEyLTA5IGF0IDIxOjQ1ICswMTAwLCBVd2UgS2xlaW5lLUvDtm5pZyB3cm90
ZToNCj4gVGhpcyBhbGlnbnMgd2l0aCB3aGF0IG90aGVyIHN1YnN5c3RlbXMgZG8sIHJlZHVjZXMg
Ym9pbGVycGxhdGUgYSBiaXQNCj4gZm9yDQo+IGRldmljZSBkcml2ZXJzIGFuZCBpcyBsZXNzIGVy
cm9yIHByb25lLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVXdlIEtsZWluZS1Lw7ZuaWcgPHUua2xl
aW5lLWtvZW5pZ0BiYXlsaWJyZS5jb20+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2Fu
ZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
