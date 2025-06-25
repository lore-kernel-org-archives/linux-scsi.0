Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E25D19D092
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2025 01:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750816121; cv=fail; b=iDujb4rMMbE+sU6xHRgz7iWKczrk9UxwGlRmG2+xEIiendwTGqLlCA6HjqtcfGjCsuGKUmstmmftDxWXe7z6jsOXSMs0XkXXEm4goUFLikAhtFqlxcFR+3ZntZrmjN9O4rktQbgIVSCFfoHGQWhn5/Lpu1DjPV8v42OSfacZvNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750816121; c=relaxed/simple;
	bh=ndlzr6HM2e+o9fQwTqLwyqZMakOX6922RKMo2UC7xGg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lXnmtAJRb9cGPQoHe7dIWxLD/1axAUT+nRIdSuOsiDe9azyOtMMqkuEOTDu7Ti/5ZeD76R366vTCfST8nL3YK9qk4BhX4FgkoDcbqNhCXVBpgy6u96i0gpyyOtuf/Xb+tZDWP8Zc6hCbChQ8qGnp2dew5C48Ug75aPNZIKi9oI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=P/3i/pGS; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=l/4HC22j; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="P/3i/pGS";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="l/4HC22j"
X-UUID: 7ee7c070516611f0b910cdf5d4d8066a-20250625
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=ndlzr6HM2e+o9fQwTqLwyqZMakOX6922RKMo2UC7xGg=;
	b=P/3i/pGS6JayIo2cEhPDjiPyWWhEOG0FbB0R73Zlmh5ZJwSqnsRvnlFEtvayT28z6r3xLrM271BTICsDgI7fzJLiE3Zk8DnXJ0lX55bmSudW0z1smDlIWk+rowPh6BFBEttcJBmj2/rAWvuPXmxLBOlftid/+G/PMNr7WFlcK+o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:d7482363-be55-4f36-ab6c-f23a11826c56,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:d6fd995f-2aa0-4c76-8faa-804d844c7164,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7ee7c070516611f0b910cdf5d4d8066a-20250625
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 528651438; Wed, 25 Jun 2025 09:48:30 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 25 Jun 2025 09:48:28 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 25 Jun 2025 09:48:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G4SFc0ISFc6FGauCeLKAMuPb2PDbmWCTqJqup0q9L1R0LlivptR/6/kCHsNAnyJR0/viD7ZHCtkk05UPDS9nKfxNHkC3wbmD8gJcLE7SBV6yLa8T2EQ/2ZGpmiAfC7aE0ZUcdOUuMa5ydjijucEBnPA7Kc8gCBD8RwEI7nGj1Bu68swWmbo+Gj1LOspOeH4E88CgW6qFEBvWDoek900tVTlA7DheIt3Bzs3EXtdsUqgtSSZMXcRIT0z42LzyZ/aMDdh2fPCOA3ZrRL1kmkBBlz/MzP0gt5KM2ywnFQt9dR7nlqTtCKZxs3vBaNkKGL7+1GG+CLFIy3wF+w5EmeUeSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndlzr6HM2e+o9fQwTqLwyqZMakOX6922RKMo2UC7xGg=;
 b=Qe7Vqy3rG30AK/PneXKRcpxrUhHSQ3nh9agK/i49mjHXZOMUV1yAd63arO8QcujCEbWBBxTT72bmViyzCZ8KzTIrAnJWGFOukGOGJQklVhcEuRHgh76QCmH8uPr01p8CNAd/gcgowEUHU+51dFzv5LPCY97Kc9fbBLpD9eudDHVWiwapVv7TJrwW00WsrTrXGbL4QUoROxnaaTGHhyCUeJU5OLgPZCsGmCu2P0U5YCQ0UbmE25MFV1O2RFyav3ITfgDj7XDHwFnf75TN2TclJS2e/s+K+twIZEr3ssmzaSzXVNqU5rDXOQaPTGCgPc69Kvari86dUXSLeagaFeJb9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndlzr6HM2e+o9fQwTqLwyqZMakOX6922RKMo2UC7xGg=;
 b=l/4HC22jVzwFnWfe/5c3+cTUhSImYvD0QQXw/00NK30cAcudbYDQo+dfeNjERKhHjsd1B6m6iZb7nETP6C+yUjC1n6mp6QGXNGP0MALOC2ZZ3266H6yBgDlPidAX2x6s6GhQEO2Hddk3AIamf4/bxsPOi/rriw417hHq4oTBwUo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8178.apcprd03.prod.outlook.com (2603:1096:101:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Wed, 25 Jun
 2025 01:48:27 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8857.026; Wed, 25 Jun 2025
 01:48:26 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "huobean@gmail.com" <huobean@gmail.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "tanghuan@vivo.com" <tanghuan@vivo.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"gwendal@chromium.org" <gwendal@chromium.org>, "quic_ziqichen@quicinc.com"
	<quic_ziqichen@quicinc.com>, "keosung.park@samsung.com"
	<keosung.park@samsung.com>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "stanislav.nijnikov@wdc.com"
	<stanislav.nijnikov@wdc.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "gregkh@linuxfoundation.org"
	<gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scsi: ufs: core: Fix spelling of a sysfs attribute name
Thread-Topic: [PATCH] scsi: ufs: core: Fix spelling of a sysfs attribute name
Thread-Index: AQHb5TRRoX1FGR2+9EaduNgT9aZAMbQTHBGA
Date: Wed, 25 Jun 2025 01:48:26 +0000
Message-ID: <1b7ab6b54b29b9c2127c8173c4acaf099b622379.camel@mediatek.com>
References: <20250624181658.336035-1-bvanassche@acm.org>
In-Reply-To: <20250624181658.336035-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8178:EE_
x-ms-office365-filtering-correlation-id: 3775cb37-9cfd-436f-c20c-08ddb38a60d5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aFN5alV1a2J3VWpBRGlNelpCSmtGVUtSeVpNZTVhZEV1QlM2OG9oOGlWeGti?=
 =?utf-8?B?TldXWGFoK3hEeFlRUnBQQU92UG0wbFBsSjdvdlVLN2VEWHU1Zk4zUnNuK2Fa?=
 =?utf-8?B?RmRnYit4Mjlaeng5cmtXakdCTGtrM212cTFmcVFyVkRzTVJuMmVrREdxZHp2?=
 =?utf-8?B?S3loTG91bkMyL0hOOWkrMFdIcnpNSUV1S0MvbEJLODMrOUtEWFp0c0RsdzJs?=
 =?utf-8?B?U3NyUjVOV2tyOXEzM1hERE8xczh6NmRCUjFMNmNmTDlDV1lGZlU5ODdiVHkr?=
 =?utf-8?B?OEM4UnVhN09iZndrMTJOY1dobzBUUWhKL2NyQVBVYXNqN1BOSXMwYTgwVExC?=
 =?utf-8?B?M0Y3WVVIdFUxbmIzUm9qdW9kdXZTOUF2UVYxbnFFdHB6TVFZRit0WWlYOGNo?=
 =?utf-8?B?WitQVWhLWHhTUUJUYnd6SHA0LzFkQ2tnYWxzZFZNSVRtVjI5STFud1ZVZkxJ?=
 =?utf-8?B?QjB2UTlOenhyOXkvWjBtaWFGMGxEd0tjOVhNOGdlTG1yMkhocVY3SmhnN3Rm?=
 =?utf-8?B?MVdyVjF6cDMyelAvaHFjYjFWZ0JmNGx5UzRzdjYwNmxWdTdOaFhLVjUzZlJ2?=
 =?utf-8?B?b2RDUmxvWVBhVlNKMmNWd3JVZ1lRMm9nL0VIZjkrdlRLamdsTGFWbEhsYzNq?=
 =?utf-8?B?dDBGWEF2aXptdC9Qa0t3elJmLzZGWlhwYVhYeGRTYTNvSTBWMEdEd0tqS0pk?=
 =?utf-8?B?WnJXR0hhdDhJZU5yL2NCS2NwK1BQNmdIbmd2TUtuS2VwOVhTZ1FnR2RhV01I?=
 =?utf-8?B?Y09IcnFoNCtybitHVjVseWY4WC9wZ3NnaG5uODVZSnllYVg1LzFCbFYydExh?=
 =?utf-8?B?aFBYS3RFZXAzdU5JaTV5VTdYdnFQR3UwWkp5blBXRjNoYnMyWWNSOFVzVjJ2?=
 =?utf-8?B?NUEwcHFxbHpqVXBsbm81aGdSOTQ1WmdHWS93SWdMdkJscWVYUWpoTlZubE43?=
 =?utf-8?B?UmRieU14RUhrMTRBZE56VEZlTG1iSW9FbGVDSDNxd0pCMkJ1cDNCMU1sN0hp?=
 =?utf-8?B?c0pTZVlUTDZWT1d1cG9TNlR5UDREN0doS3ZyRFJiZFhqUmtoK2xmM2xKdFgw?=
 =?utf-8?B?N2wvMGZXUHdZTHVvYnllRHByNmNFdElHZzJRQm5Da1hGTEZ3VzM5QTZRSmFt?=
 =?utf-8?B?TWxiWmJoSlhleWd1aGR5Mk1tUk9ySzNIUWIwZmZuM3JVR3dHSksyVkxVS1l6?=
 =?utf-8?B?a1FsZ2hVczhKRUgyV1VadTVneXJ2OUppZ0l3TmVvRFF2UGxCMkpPekZORmNp?=
 =?utf-8?B?T2FIVUFESmtyc2tKNUVsQ002YXBsNEp5aVJadzMrd2phUnVMRTk2eUNTaWE0?=
 =?utf-8?B?QkN2WS9tTlhmRTNGMEVUTnJJa0h5SXJtQk55dGRBQXE3alBmWEM4a0J2K0li?=
 =?utf-8?B?b2tpVy9ubWZhdGJyZ1dLbXZBcVFLWjR2and2VFVhTkdRQjBoUFh6SzRLRC9a?=
 =?utf-8?B?cy9xVThQSEhKK3dpZExCUmZGVUY5bEJPTE56K0QvL1RiWW5Mb1hRb0o0bnhx?=
 =?utf-8?B?bmE1d2RTWUlHaG5ESmZ6dnZSM0xUTEEzMGd1SzJTODhCVGUxTWlDZWFRUXJC?=
 =?utf-8?B?UmNta21qWnA2NmYrczFUVXFOemI4Z1lYTi9tM3hEeXhpYjl0dE1wWDNBeXFk?=
 =?utf-8?B?QzA1L1o5NG4yaW5xN3ZQSmJPOWJkOVoydnRURElJMGNSSGFBMXJlWkpkdGZZ?=
 =?utf-8?B?YlI0eTJuc0E5T1Rnb0Q3SWpzUGRVa2NoN3BIUE42WmZkMFVKdVVhSnJzcHMr?=
 =?utf-8?B?SDUzNW1QclpvMTE1QmpvNm90WWVXSDR0eXpUdzEweXc0SnhtdTRPdnIwWnNk?=
 =?utf-8?B?Q3B5QzF6TmFOUW0vWkRDQVQrT1VwazVrMDNUNjdsT3ovL2doVEdYVkU1WXky?=
 =?utf-8?B?OGVXSFFoTXJmRlFNR0d1NXNXb1ptcHFkZ1BUOXU0VjJQSjlMcHRuWHVSdHpP?=
 =?utf-8?B?cG1PTlYzN2J4eUhwQVdsL0hxRHZ2clpQNUtKcTV2NVNXUXFFTGpDRzFmMXY4?=
 =?utf-8?Q?bfIe2bMYiIDkMS44dmtDCQyTyCrDJk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGxNZlo3eFhQZ29LN2JONnlIV3I1bGMxZzJidUxaNTNTOTMyNWlkWC9zeXlv?=
 =?utf-8?B?bnQ1K0EzMnEwb0Q1bXFjcVRKQlJqTWxMY3NwRUxxSkhYSGlHRlJNdmE5S0lj?=
 =?utf-8?B?YjBzUGwxTktGV1RiL0ZpOGliOW95eVF4OXF2M3R1RENiRXNlUENuRlg3TU5v?=
 =?utf-8?B?eG9zUGF5SzFpTE1iRGE2QTdBUVJOT3ZrWjBWcGZ4ZmFpRTNZeEtBc3Q2NDVm?=
 =?utf-8?B?aDdhd2RYVWhDWVNOTjZ3RldVT2x2RFlZT3Y1SzNQaEd3c2p6R0Q4RVJSZEN0?=
 =?utf-8?B?Y3RQaEdzWnU3OWdPRU5jL2lLcWZLOWZmN0VMYW81aDZreVkraERlWnhNbHor?=
 =?utf-8?B?dEdwL3FCbm5JT1hnSEplQWRCWHphZWpONGt1SW9hSUFTZUFNN0FPdXYxZTY5?=
 =?utf-8?B?dFRlaEI4alNNYWpqQUJFUkxhVUV5UzhpTEdNekg1dkJ2aDJ4T2tVTXVFMWVj?=
 =?utf-8?B?WHBYS1AxdTNYNjBQMXZCZnFRTGg2cnZjdlNMWkxHOTJNZkdYajE3LzBUREZO?=
 =?utf-8?B?MS8xS3ZtZ3VZUkZQeGVrVGJMTERocUNQY09QcEtIKytZck5qaFJtTXlFTHNZ?=
 =?utf-8?B?RmNUa1k5SmtHN2dIOUdyMHE0ODAxZnQwRjFjanpjdDFIYjQ5aTJiYmhjK2xX?=
 =?utf-8?B?L0k2WHRIMVJ2L0UvZFIzMGZFZ0d3b1NYWGowK2ZpT1F2UDJPeVlDcDNQbEEr?=
 =?utf-8?B?TzJvYVp3eFh6UXV0d2x3Y0Nkem5nYzBGZytBeC9rR1g3c1dNekhROGNzakpu?=
 =?utf-8?B?MXdBZGNhQXhjTHpSS3BET0xMMWxFKzhIR1RoNUdZL2FtbmE4bzBneDhBRnk2?=
 =?utf-8?B?Q3I1ZWNFVFpsWnowSjQ5M0twSzJzSDZFNEp3eXdneXlEVjZGZTlsVDlqd3hU?=
 =?utf-8?B?RjNGNUtVMm9kV0pzY2dWZG1xUUN3RFUrSWVXWkoweGQ2RDZxZkl2S1VydThY?=
 =?utf-8?B?clIxaUpaMHRNUVlUMm1xNUY0R1d3dXpjZWdIZUs4ZUNFMGJZME56cXFET2tt?=
 =?utf-8?B?MjhVamRhNWprci9Mbisva0RPYldjRVRTamswZlU0akVBcWN3UGllRDVLdGhG?=
 =?utf-8?B?ME5QYnFMemNIN0NTN0tGYUZVcUZrV0Y5RDU1bXlsaEI0Rk54RnQ1VFBaR3Yw?=
 =?utf-8?B?aVBGL2NobzZKdElJSXd3UGx3S1pKM0Jqc01aMXhyeGNlOWZ6NGI5UkFDT1o5?=
 =?utf-8?B?aTVMSlJxUGROalBsNTd0YXdxMzBMSFpacDZtMDAyVDdxWlpTMUZhbHBxMDdS?=
 =?utf-8?B?QVBncWdhZWdIUjFpcnNGcEFZV0lSZzdiejk3ekQwajZFQzR4NmtRTXBjQndZ?=
 =?utf-8?B?TEgwQ3dxUHFQZ0hJd1NvNFpPZmdONmQrYzExZmZMUmUvclJQazR1ZGRaSUhN?=
 =?utf-8?B?V3g2ZEdxWVVpaU9Lc05FVGVaeFVUbW9SeWNQZGljUWltWWl3dUZsT1NmK1Vn?=
 =?utf-8?B?aTh3SHZvTlNvRTRoRS9hbkp6elQvNnZSZ3diWXVvZ0UxYUNvL1BtZURYOC9n?=
 =?utf-8?B?Wm5NOFY2V2xycDJQSXEvZndFQmdIQ3h1eWdyOUNhZ0RiUkdiN1V5U3ZHcGpH?=
 =?utf-8?B?MnkyWXVNL0JERlZGT1R1UkZ5V2xmYjlLaStlcUVlS2twdVFqWGN6dEFQV24y?=
 =?utf-8?B?NHovTFo1Y1NNUGZzSzhVMU1sMmw5bFFDU0xVaktRM3hCNy81RDhLWUZ2VDBp?=
 =?utf-8?B?NmhQT2E2REd2OWpwR1FwN2I5QUQrYzNhZXNING1iNXhvZjNwdXZ2ODBMZDgv?=
 =?utf-8?B?dVJVZVczZUtEQTkreEdUdVhzVVAvbG1WMjRreURNanVvNDUwbG5vejM3YzBh?=
 =?utf-8?B?ajIxMW1XWGhSV1BxbndnUENvRy8zWHVSeTE4Ym9jcVl6azdsRG5laHNXUGRG?=
 =?utf-8?B?QnppUUFtUXlHL1hmODRmR2ZlanI5RFE5a3pwaU1EVGRvY25STVptMGpmNU9Z?=
 =?utf-8?B?OVZsT0VJd2RFaTRLK05JbnNmd1hvamhZeVpWeFNpbmtNdGh1NkdOaWVtOUlH?=
 =?utf-8?B?VUk3NGNDUHo5TVdOU09KblRKN0lQVnk2T2lrU1BxMVR2c1pyYzhZU2I2blZX?=
 =?utf-8?B?RWxkbFZuRy90VDRBWVlwUGtIQkVGS1FuMCtHQTVHTkRBajh3QlB3YUFhNEYy?=
 =?utf-8?B?aUZ5UjdvUWl1MDlnTG0wMGU2RGVuVDkwUFFuMmdUU0xSc2dFWUh1d3hNZ1ZZ?=
 =?utf-8?B?Nnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C60AD5A8C9BF64481F19498A71539CA@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3775cb37-9cfd-436f-c20c-08ddb38a60d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 01:48:26.7343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7sNHK4B1KVJkgj4UCy7bMzllk5m+t42EjPBEAwNYeflSeW9TtVQ7sKCMPsb1WInL7ALM59HtowVvzSYd3xcETA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8178

T24gVHVlLCAyMDI1LTA2LTI0IGF0IDExOjE2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IENoYW5nZSAicmVzb3Vyc2UiIGludG8gInJlc291cmNlIiBp
biB0aGUgbmFtZSBvZiBhIHN5c2ZzIGF0dHJpYnV0ZS4NCj4gDQo+IEZpeGVzOiBkODI5ZmM4YTEw
NTggKCJzY3NpOiB1ZnM6IHN5c2ZzOiB1bml0IGRlc2NyaXB0b3IiKQ0KPiBTaWduZWQtb2ZmLWJ5
OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCg0KDQpSZXZpZXdlZC1ieTog
UGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg==
