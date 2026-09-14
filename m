Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FCC3F166A
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 08:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789374797; cv=fail; b=HuZQOYeBeHCHFsgoP768B5T0HwkOSfzZ2y0Pe0wsP3xUz7VYeuy4LabYl0siK5Nf3jyqU2Skl/M3GyuyFzCCkxYA8hbbfH70EV8uZ6lm/t6DDyJUazMOSF+qC+2C/Y79DgFwe8nTfmAua0aOa4fD6uHwZ2o66w4Ex2zodyzdqUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789374797; c=relaxed/simple;
	bh=+rfc9MuXuCOfqcrtEw9WUcayU0sy0g7o1mc2FnuUbi4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DPEM7/A3Gd7gpLaDXcg90ETqJmiIbxBg+WYyo9U6pBCx0ByIga7ul97mdI5tNc2TVQXnf973FKMdX60m/0AnUlxQj9S/OOiP5GT5n5g71PE5D+p5z0GnUvhTNgHP1o/Tg9rPjnm4Nj9ipPwM+3VFh17AmXrav3bx0JXC4PKaV68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=P06wk/T+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=OseXd6H1; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="P06wk/T+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="OseXd6H1"
X-UUID: ea2e92f4b01611f1b1788b6acf885367-20260914
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+rfc9MuXuCOfqcrtEw9WUcayU0sy0g7o1mc2FnuUbi4=;
	b=P06wk/T+OnUnEERnkCTc5i0hY/GtnTaOkTTRX2y745jhOEwx+ndtPX9vpQ0ji0bBhiHdjQdIvZx68xEpYNmw7qD0jSydpwg2tki9H46G3MWVt5Q2oT0Gop0jjiOjYMKvE78tHCOrp6GFioi1/+mR5xAO+1Ar+lVn/5gykW8euUQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:bf76b134-a8e2-4d6d-8ec0-0768367d3edd,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:d677c3dc-e2a3-4c41-83fa-4adacd638ae3,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ea2e92f4b01611f1b1788b6acf885367-20260914
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 507096230; Mon, 14 Sep 2026 16:33:08 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 14 Sep 2026 16:33:07 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 14 Sep 2026 16:33:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rt2mw8ya8fPfAyIve5H4htUpAbJUtBVrf6FXfrNpTa/8FUHGoGe+fvYxgKFMccpHZeehJABlSHQyxxIPGVpy2Ox51H+fxCUzLBQsz/Cq7DRIi4w0z/GGJoy/4VHgWpGmkdqfY2G1TXN7UAjvyw492LjOubwlmsxmzVLyIS0JqDfnk1n+EdZLzgXcqnGjAzl/zihdL6YPKMTNWxaX6CanD6FzbIlx5zY9Hst6FgRXiCOWMQgxNNBb5Z2DUJWfQMCXnekZ65HfUqPjo4AjBoEZdzBQLiYQzm+WOSE4lnIlWbXA76iKeIpoQryjI+cUHfepYhNzFY1qXFej/FXt5B7cuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+rfc9MuXuCOfqcrtEw9WUcayU0sy0g7o1mc2FnuUbi4=;
 b=Ck4XHBsLJ82RY+AL2ZaRRJ3IsTIdxWVq+ndeOecQ9iKWq1ra18xd20dTaBb0mabqbqN79HgsucqlhJ8kZ2e2XAe5bU0UJYcT9o/BIhZotBOf3SoQnnZBNYSx7sYCyKdbfjgC/vTVhbHE9i2mvGDeryv1JF4NrYFF+ZD/cTYX3s6Nk26MNdfNsm0hBfS6bjT07LI56I7nomzT9OnF6My5tRjdc7DAWhpEXDXdStE2y2aoG6hunWVCZK0qenyOfdlLMxfbKfHvvMbsjgBi7rGwI+M8U/EXYEJDSBEM5KrCTuRIWF8wmBnz+4Xk/+WenpU/QZ51csTPnYyvxsRBso4gdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+rfc9MuXuCOfqcrtEw9WUcayU0sy0g7o1mc2FnuUbi4=;
 b=OseXd6H1RdSQmDtkQdVgsakbH28STD8hVo8XZSFv3N1qchq2sbdsZYQz77nQbhaAkpfnqkIFZMXyMjN5RdlLZndTr2X9hVb9nRud7gvdLw2t8mK3+Ysn9mflztbW5JzodLKLseUywtjZCSgykibmeeOh/6ew6QzzS4OTJBIkunw=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SI3PR03MB10053.apcprd03.prod.outlook.com (2603:1096:4:2a4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 08:33:05 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 08:33:05 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v1] ufs: core: serialize AHIT register access between
 sysfs and host driver
Thread-Topic: [PATCH v1] ufs: core: serialize AHIT register access between
 sysfs and host driver
Thread-Index: AQHdQDs3FQp4pBcyXkq+qwqvWwZ36bbF+TGAgAfNqgA=
Date: Mon, 14 Sep 2026 08:33:05 +0000
Message-ID: <8d2623b0cf6ce87e84c8171811f7fc8fff9ab90c.camel@mediatek.com>
References: <20260909091120.1134414-1-peter.wang@mediatek.com>
	 <20260909092309.AE9861F0156E@smtp.kernel.org>
In-Reply-To: <20260909092309.AE9861F0156E@smtp.kernel.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SI3PR03MB10053:EE_
x-ms-office365-filtering-correlation-id: d3969432-3fa6-4689-7200-08df123acc44
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|22082099003|18002099003|38070700021|4143699003|10067099003|56012099006|11063799006;
x-microsoft-antispam-message-info: JoDLrEyviIf/1V40JOhTNrFs9pjQb057GDIs5/vi1m7mtOoff+9oZybeylbfJVhblrSqqYWQwVfNLb4SKu6hVU2UuLm3U+N6Mx1JC60K0LNUN9rQfrA18D+BcnFFLxYlo6adw2/s5MeuIWnoUWh7195mQxZL62P2MtQWEKmsFunF/7ScN03rN40OwTPCjKDe9xlMFx296NdQkn52tTf9ViNnW749Xt+11eijhAVSmxFCq4MnyISnl7RsX9hnKnaInVQWq1ccbFpE/qiuYRWYQX7ZXPzm8wu+9/cTxl3pOqoazuTpacKp+SsSkjkCVphsaTqWoliXIH2LRx5KVYS+XvXrJpVIBrzmPuughAiwwgGMhaEq9YUmG1sl87Jd4ODNNEahdhXJrDaUxd45+N3NeQS/9N5JS0hv8fHyGNZwr/swZOPn4g4/FCokU7b3rl3oWgAh4wGLLY/JKEqoMEY9zPv32zIw6YEnWXv7HbXpvhX98p+ic5ipHYRnW1Pds7wADg9WJ7YlqZ7N/8rdWG+RLEDT3cZvUWtvAIDz0u/3LeEbGbuG6Emv8AEwxpFpovmHUapHRNQcqnBAAXhNVqq0qWY+Z8sX9U5C8Xlkvv7oAFbV6PtUg4jDbdd9jU9motAEePMm5gfSiMb6Qw1kPiNk8xTRAMsAip6p7u+hBEWfgPRtuF8ooeus96WNVHzAPPOg8febSgOQgbWVvjlQefTMKfG5dsyUz+0XtOSygfJLjAA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(22082099003)(18002099003)(38070700021)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEs2eTBmOUV6RFZGVHZvcmFVUTJWRjBYTnIzUUR6WUk1bXk0K1A0NmptZ21L?=
 =?utf-8?B?SzhGaVluTVRaVzc3VWdUYk9IYXFLNWNFZmtNOVdGTzNmK1RWSmtVOXFKbGRU?=
 =?utf-8?B?WlgwQW5kNTJ5WXRIUTZDcVJuZzFXa05BSGcyaXYxOGV1R1FIWXhzYU8yMXBQ?=
 =?utf-8?B?U0hrSDduWHlCSmFObGlzK2o0Y1ltS0Q5clJGMGI4TWFvNVBvZmVLNElZbnha?=
 =?utf-8?B?a3VSWERNSW5wMGZzVmp6Ni90SWdYNktidGIrYkkvbHpsbWJ6WFZnTXZnQ1lZ?=
 =?utf-8?B?ZkkvNTRpelpwNFNxTW1rczlxOGxnQkY0TDJoTFJ3UnJDSFFra2hhVDBTeWN6?=
 =?utf-8?B?bEE4ZFFIbFFOcHBiZytscVNna2VjODhpa29iN0hmelEya1NmZjloOGVZK2dj?=
 =?utf-8?B?WklnQzFuM0pkYmwrVUpHOEdCb3ZLOE9kdVJSSUJiZ2ZqdVFQazAwZW1JbDNR?=
 =?utf-8?B?OFZIV2xxQm5mT2N6ZnZUbWNSeHJhelBxYk5laStZMzRLU0lTSm1ad3EySjY2?=
 =?utf-8?B?alRSZDB2ZWEwRmsvb2Z2T2xNMWtNOUFUQngzYi9hNkZXcUl1MytNRFMyWmgy?=
 =?utf-8?B?UGVwNENGMWYrTmNrM1YrU2tpNUZSUjFPNWdRWGNhV0xXdERtWW9OVktrQW8y?=
 =?utf-8?B?amNuYitpWk5CeFBYQzB3aDZUWjVvOVlsa01CNHBTenRrWUVpUEFlQnlHb2F1?=
 =?utf-8?B?bEE1UmJOalk5R0doSEpOaVNIUUdyYWxBWE9LbEJyYnJSQTdaa1RNUzhFNFRu?=
 =?utf-8?B?d1dLVFE3STA1cFBTMFV6UHdseWR4WkFrWVNJTTMxdVR5VW1JYXA3YkhFWDND?=
 =?utf-8?B?WTZYa01DL1VMaklkMlR3aFRrbzNGdTFrM3p5MVI4dDlUS0pkcDJKcDNJYUhY?=
 =?utf-8?B?cEtmTlduU1NlV1RMUkRjYWpYdDBvaC9hMGM1NEhPZ091dW5vUjhaYUV1QzJM?=
 =?utf-8?B?YUlEUys0dGRZQ3p5c2JaWkRObXZKd0hQYjFiNnhWekJvUHd4d2tWbW5ZeFNo?=
 =?utf-8?B?L1ZVbjArbHVTR1YrSHFWZEFrb3YvV3dDTjZwODRMT0phNFZ3QjBLZC9FZS9n?=
 =?utf-8?B?OTJTblVqR21HeUpOc0lwMGprRjJHa3JtMkRhRTlUTUJuTEhYSStoa0lKNHBx?=
 =?utf-8?B?UFdpNXZkZ0RXWXkxWk1yeVR2Z2VKMkRKbXpGbHE1endmYlV0NGJiUllhMjRX?=
 =?utf-8?B?alRYV0ZBN0J2bUMwWjBWdEx4VUxkOUk3ZnJQM0piOTN3Q0MzZU5Cc2lndWFy?=
 =?utf-8?B?VVlmNVZsSk4wdUhIcUpVcE9NVFFQUXl6anBodFBxLzFFanFPSUR2d3piZVVT?=
 =?utf-8?B?V0xJazVBR2tVc3NXRktiUVZYcFBNTWUxS3FNQUhnY1NoS0RSL2dsMkd4Z0o2?=
 =?utf-8?B?aVNkdjNLeHI5Y0RpQTJINXE3Yzc5a1Q0dEpSNE9SUUhCY3J2TWVXa0ZxbXU1?=
 =?utf-8?B?NXdSNkJyNGVZeis4eWZMRDYwTUxvTVVhRW5CNTBpYUxubk1vUjFsWklwTE9O?=
 =?utf-8?B?cU42NmZXR3FuS09kTk9PNFpWS3ZVWmRrUEM3SnlPYklGR1FUbURyVDllcnZQ?=
 =?utf-8?B?bHFSbmVRUkdzSUgwd2dTYnd3Tk84RHg1Y29jN1RkZkNLMGdHRGtPa2tuUVNq?=
 =?utf-8?B?SXJiWjJSMXAwb0pyUVBiaG8rc1VHQ3grR2dwdC9ZeTFsdzBpQXM0WnBoNlJj?=
 =?utf-8?B?WHhydVhEdzBtOE9rY1JITkgxSjhkaVVDNDFqaC9rT1p3UnJ0Nmdac2ZwZm5G?=
 =?utf-8?B?MlV0dFRlTTcvVmh4dHFNYTl1bGpxWCt2NmxoNHFQUG8wZFhMVXVnQmQxeVM0?=
 =?utf-8?B?SVhscmpkZmpwM0FKV2hMcWlSbFFOV0xhUXZ6UmhKNUpqRWZyYWIwaUpiOElr?=
 =?utf-8?B?Q1BOMVhyNTc0OGs0YjZ3TXZwSnR1em5xQkhiWGdNeUM4RnBFSWNJYzN1UHhr?=
 =?utf-8?B?eGJXNXFJN0J2ODRRYmdBQ2VUeDdNb0tITGd4cXo4ZDNVU3IxbFp6bkhFSHA4?=
 =?utf-8?B?NDQ4ZzRrN3hLUUdtZUM2RitQelFDVWFRM3lNQnRtK09pbm1NcStSaUI4K1Ri?=
 =?utf-8?B?a0p3blJwQ0drNk1pQ3RNTWJXMEJnNXVJc0pzd0NpUncwUllYVGs5V2Rzdkkx?=
 =?utf-8?B?Z2xSYUN3ZUZJRm1CVEFNT1ZRZGNkbS84cVdUeUlVV0NNdDI0WGZMVWN0VWI1?=
 =?utf-8?B?UThST0cxeTEwSFBjNWdpOWNVSDhWRE1HMHJ5OHdLNDE3YWl6cEVXT2JGaUhp?=
 =?utf-8?B?R3NGOFR6cHlNMjV3L2JHUUR3bTJiMDJpZkx1bFZneHpYd2l5UC9UWDYySjgx?=
 =?utf-8?B?YVZXMjB5YjlRbzZmUXcrNWhwUG9nS1RVVDc5aEpaUUIybTdhV0FtZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <572288AA2327F64496B737BC007C8BCD@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Mw6ZgIgcVNJAMIQWqFXXYgMAWkON9+4PvTUw5jED4+hpmXAda7WQJkWr8WCRx1aqL251omE5E8IbperygUfpNMDQVulfpa1tm1oG0ZV/kPcgiqCR/5RJRprjv3LA8X4o4mq8X/i85up7EU0LI5GSbv/G3mI6PvzXbM0Oqyej9VU/op6cMMAqEGna+J+SGPF6pPt5EKFMRZxfUFnlJwGooP8bGC0UB9Q3o/XjAoeWzb4+Pnt1HclKbwt/t/g/50cWtwWSz7q5luQEJz8bYatcbvToejDuyFOjvy4C6+anj3J+pkM8BW88g82Ypu69eShyMOimfKry4usDxvVMUsAPfg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3969432-3fa6-4689-7200-08df123acc44
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2026 08:33:05.4190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tDBR4MzSnEriNFyCuTffRj0kJsA6N0ztg9mc2m/DlqXv37ZmYzns+QFX3mgo26b1/pccFhh2RTxesp6jxecpLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI3PR03MB10053
X-MTK: N

T24gV2VkLCAyMDI2LTA5LTA5IGF0IDA5OjIzICswMDAwLCBzYXNoaWtvLWJvdEBrZXJuZWwub3Jn
IHdyb3RlOg0KPiBbU2V2ZXJpdHk6IEhpZ2hdDQo+IERvZXMgdGhpcyBjb2RlIGxlYWsgdGhlIGFo
aXRfZGlzYWJsZV9kZXB0aCBjb3VudGVyIGlmIGEgcG93ZXIgbW9kZQ0KPiBjaGFuZ2UNCj4gZmFp
bHM/DQo+IA0KPiBJZiB1ZnNoY2RfZG1lX2NoYW5nZV9wb3dlcl9tb2RlKCkgZmFpbHMgYWZ0ZXIN
Cj4gdWZzaGNkX3ZvcHNfcHdyX2NoYW5nZV9ub3RpZnkoKQ0KPiBoYXMgcnVuIGZvciBQUkVfQ0hB
TkdFLCB0aGUgUE9TVF9DSEFOR0Ugbm90aWZpY2F0aW9uIGlzIHNraXBwZWQ6DQo+IA0KPiBkcml2
ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jOnVmc2hjZF9jaGFuZ2VfcG93ZXJfbW9kZSgpIHsNCj4gwqDC
oMKgIC4uLg0KPiAJdWZzaGNkX3ZvcHNfcHdyX2NoYW5nZV9ub3RpZnkoaGJhLCBQUkVfQ0hBTkdF
LCBwd3JfbW9kZSk7DQo+IA0KPiAJcmV0ID0gdWZzaGNkX2RtZV9jaGFuZ2VfcG93ZXJfbW9kZSho
YmEsIHB3cl9tb2RlLA0KPiBwbWNfcG9saWN5KTsNCj4gDQo+IAlpZiAoIXJldCkNCj4gCQl1ZnNo
Y2Rfdm9wc19wd3JfY2hhbmdlX25vdGlmeShoYmEsIFBPU1RfQ0hBTkdFLA0KPiBwd3JfbW9kZSk7
DQo+IMKgwqDCoCAuLi4NCj4gfQ0KPiANCj4gQmVjYXVzZSBQT1NUX0NIQU5HRSBpcyBuZXZlciBj
YWxsZWQgb24gZmFpbHVyZSwgdGhlDQo+IGFoaXRfZGlzYWJsZV9kZXB0aA0KPiBjb3VudGVyIGlz
IG5ldmVyIGRlY3JlbWVudGVkLiBUaGlzIHBlcm1hbmVudGx5IGJsb2NrcyBzeXNmcyBBSElUDQo+
IHVwZGF0ZXMgaW4NCj4gdWZzaGNkX2F1dG9faGliZXJuOF91cGRhdGUoKSB1bnRpbCB0aGUgZGV2
aWNlIGlzIHJlc2V0IG9yIHRoZSBzeXN0ZW0NCj4gaXMNCj4gcmVib290ZWQuDQoNClRoaXMgaXMg
aW5kZWVkIGFuIGlzc3VlLCBJIHdpbGwgZml4IGl0IGluIHRoZSBuZXh0IHZlcnNpb24uDQoNClRo
YW5rcw0KUGV0ZXINCg==
