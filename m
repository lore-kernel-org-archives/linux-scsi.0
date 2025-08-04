Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE2617555
	for <linux-scsi@vger.kernel.org>; Mon,  4 Aug 2025 05:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754287173; cv=fail; b=oL+3+Pot3ZAENUkKohVoa8tLrV1niZPtPN60efmLi3BAdwZCYqTLs4uazaWbYNN33e14dfyeU7OMA6MT0UQeUfhvzRfne5fhfL97sTyyEmaZfD+Ju+qTnzBCi7Ub80wbz8CylEGoh+MC8tVRbmXLFj/XB+EK0vs1/tvMMX89xds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754287173; c=relaxed/simple;
	bh=YrfP0WUAGMWMUu0WtJOlnLdERbaak4HkiDRj0LWnmp8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qn34yDNADrKXB5MUGmbZWRZJ2Lbnu+S1o2+ezEdaNe4qbu7sNIyRbRiD/f3R8Km+xmRSjovDtmUuXKi+uLSRVLjHrKkC6lw/VhiblOUke4klz77vbpY/ZvdLCP9dukvxYg+inB943r506TY8M1Dht6yiSi+TDmVk4CS9o+yR+K0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=g0wlMUFL; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=EvHmykp0; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="g0wlMUFL";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="EvHmykp0"
X-UUID: 2a91177270f811f08871991801538c65-20250804
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=YrfP0WUAGMWMUu0WtJOlnLdERbaak4HkiDRj0LWnmp8=;
	b=g0wlMUFLnrdnVVPVtarqE6faT2dV0L4Br2YgZwZis8vysAHZRS1iL3ffCzzKE10jyhJmdch95eiMFqj6qBaPMQyYN8bAWs/3zCgupPJKu6C6lCcc6RFCGdDcw58B3rIgYfBWkl14cUY0uG7OYOl0tVU4VagRaaBCgwFROWAhHao=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:84710c53-5ec6-4988-a1f1-33a8d3018f05,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:d5e91509-aadc-4681-92d7-012627504691,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2a91177270f811f08871991801538c65-20250804
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1089744900; Mon, 04 Aug 2025 13:59:21 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 4 Aug 2025 13:59:19 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 4 Aug 2025 13:59:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SoB9TOYx+iazBB3hhg+6WVKH21DMgT5G5kGOQzgAAM4BAIjpNVld1jrp/xHSZPHJaN386K7F1SmHq4/uu4BvY5ThH02qEVqw5dW9PHyHovNA+ZI6iElUeLXclikmK5E+WDegwHRpgUmcbZNTRZAbAhUstPB05TPxw8COEpR63CCxKhmujL2alJiXaYoP61eDEOBKos+C9b5MHbhP9x4Ga2JvjReOoST+5jRyBr2muujQF70aYGbiWNQjrX4UkzgUNRRipUM9uannchAkPWbU5XtV6Q3xaFGgYCZquciUxt/PKhjVGkyChJb5/n1Ao18/5jx6PPeKnJOTDhKEyb2oBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrfP0WUAGMWMUu0WtJOlnLdERbaak4HkiDRj0LWnmp8=;
 b=x7Z7JvCPGaWWFDlrxDjZTjXcoMbO4e3mVsNNru5BNHyoz014UMdVFAv23yi1Zn24c279Xf2nEMN/2uA31n7TvFpj3hRlyy5fvLOu4nDmCKN0j2KM1P4esRBIo4rdr8oje57oZCt9h1fTzLxa1grEvK9J1Cf1xARsBdIHBirt97i+8BohTElz4z8fJaiLN+W8B4TuLdMMwCmZx/QU5B3qhGI7DmuOqQ7gLNHKtDCtP284J4ANTHbiksqeiIFsTey9grzQulaZNLmHhGsP7ENyXRMMreKdTrbSwkINCg6oGiXp/L3Ei4thXgoEWi0A4/YZlGALpaFvJaNuaaAOd5xPKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrfP0WUAGMWMUu0WtJOlnLdERbaak4HkiDRj0LWnmp8=;
 b=EvHmykp0pwvGp3bMo6Jx3Ylb2xQsXFQqMY10IWa1mG7ahXA/xeB+2y9vjkjJ3ZO8QiI9mEXjTB/nShBEzXEFA8Aufh17Aoklt0H3wx85yxOyRIe97Vu6y7CNG5DwFIDJ8WtnsV9EMQEZ/Wi0z/pGif7DVcu9MJnOkd8teQwdxMg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY2PPFE6DAE24FB.apcprd03.prod.outlook.com (2603:1096:408::9ee) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 05:59:18 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 05:59:17 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>
Subject: Re: [bug report] scsi: ufs: host: mediatek: Set IRQ affinity policy
 for MCQ mode
Thread-Topic: [bug report] scsi: ufs: host: mediatek: Set IRQ affinity policy
 for MCQ mode
Thread-Index: AQHcAublIxvIq188hk6NJuUB1nyqB7RSBAQA
Date: Mon, 4 Aug 2025 05:59:17 +0000
Message-ID: <ddccb7332dbd4eea22e12f00e35d84f8183a16ff.camel@mediatek.com>
References: <aIy-t8rS0b8vhfmL@stanley.mountain>
In-Reply-To: <aIy-t8rS0b8vhfmL@stanley.mountain>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY2PPFE6DAE24FB:EE_
x-ms-office365-filtering-correlation-id: 5d98fd6b-49c4-4aec-7b1d-08ddd31c0c6e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UzIyNFNLZlVRd2crZFREdDl5N3o3OFc1SHZRVmZMbDlXeUdET0ZwVGlrSWF4?=
 =?utf-8?B?VUt6YVBvTzdnYmkvYm45WVFLU29wVDJTOUVINy9PNXZqRjNreEtCK2k4Y084?=
 =?utf-8?B?MElranNaT2NRL1RkZDFoaTRtZUN4d0FqMDRUUHJMRnh6ZC9mWEU0WGxMMmQ2?=
 =?utf-8?B?ZUNrTkx6S0t6TlZPYW9xazNRTUdvU1h0a0tuUmNpTmpCQkFZdkZrMTVYYXJ5?=
 =?utf-8?B?U3c0SGFEN2FoUFJyUG9JK3FlOVdkY3pJdmcrM1FyUVNLUDVoamtoTDFGNlR5?=
 =?utf-8?B?dmhGaTJ5S2YvMCs3Nm0yMXhHRVdHd1hiNlNZanlWa29QT1VIT29iQW5BYUZP?=
 =?utf-8?B?NzhvQnVDV0NVSVJzS3A3V0JzdWEwNzRWUTJpS0Roa3l4L2kyc3NvODBUQUNM?=
 =?utf-8?B?L1Y1RlBiM0ZUdUNaWjhWR0tNU2UyWW00SDZSTjd6aFp2QWhQSDZvNlM4YnQz?=
 =?utf-8?B?TkNkVFdMK2VQU3JUdUN0dGVxc3JTcmVZVVdLMTh0VkpnVlV6WlYzeE5lNTB0?=
 =?utf-8?B?eW51WG1hQnlDeFZLRVNCRk1kQ1oxOEpGODNGT3l2MzJqQVdDZ2xHZnFwRjND?=
 =?utf-8?B?azZERlY2UkorTXhRQmI1cUxXaTZ4WEpGRmd6eWphdzRhcWlEZXpRcmxBTGNz?=
 =?utf-8?B?dE0xUHRtY3BPY1NtRzVYRGNIdmhUb2N1Q2gzNksrU01xa0J1bCttZzNBbjNZ?=
 =?utf-8?B?OXVjOEhwbTBkR0t0a3EzY0d0Mjk1aGNTUTJNcGo2NGFxdG9pYWFPbTl5dzdO?=
 =?utf-8?B?Y0xnK0xVZkh2TVp1dlpKVlY1L3M1WHdSUG1teWhTdXZSUzgrajZ2c2pNcjFG?=
 =?utf-8?B?NFpSZGF6Tzc3U0o3OXFHRnovVjRXMW0zM2RjNXl6dHZ4VWxQQTZ4ZzFBWERO?=
 =?utf-8?B?SjdhYWVaNEIrbUZrZXdlL0tnRjg4bEJ0R1BEZ0ZIYnFzNFRFWGlSNzdsODNZ?=
 =?utf-8?B?b1kwL1VzZFY0NUxnRXdDcGxkOXZhS3pORmtXU3pwbVpBOUM3UkRyUVBBQW5l?=
 =?utf-8?B?NkN5QXYwSUUyMmQvZmJINm9yU1VVWTFoRWtzRXVUeVZza25oOWd5K0QxUUVa?=
 =?utf-8?B?aUJLazRoQWtsNHJsUlV6QkVWUUN4ZjNEeE5QMmNWeVdTS2tvS0NGQ25LMlNp?=
 =?utf-8?B?a0t6NEptKzB6Q1ZuWGZNQTZNZ2dmNGs1MXdUU0FNOHZJYVhScWt6eTc4c3dD?=
 =?utf-8?B?RDg0RllFaVdzMGhSVlR2SzdsSWMvQkh5blNTR2YvOWxHTmdKVjc4clYyazlu?=
 =?utf-8?B?dldHOCtnYXRwRmdqOHhqenFtdHdZVllBUDl4V1RZOTVMN2lBcHYwam5sZS80?=
 =?utf-8?B?ODdzZnVTaXVHZXRwKyswRklFTGtaZW1iYU5Pb3Z2R3o5ZHcxa1J3WVhrRUoy?=
 =?utf-8?B?cVlDNVhpcjFKY1UvY2toV0J2RWxaMFVHeVZOWE5HQXJwN3c3aUJXc3dvVkU0?=
 =?utf-8?B?UEwvc2k5ZWN2Um5CeGJoc2FsVXQrUUFTMFRqcGhpWTdhSnA4bCtBc0hzaXcy?=
 =?utf-8?B?R21vODE4M1oyb0R5Z2RUWVlsNGhmSGVmMHZ4UHZ5bG1PdmxaN0FtM0RlWGpk?=
 =?utf-8?B?ZUs2VWNVdTFBL3RjYTNlbDZYMUgzRXNtU0dxaTYvWEw5WGlsem9FdHRZTnNF?=
 =?utf-8?B?U0VLeko0TmpyVWk3RHdmQW16VnRkbCtSSHhnZ2xFbloyUmJ4WDJ2RjF3OWhQ?=
 =?utf-8?B?ZTFVRlF2WjBZcWZER0NKOEk0cC9Dc29OVU1VVXFaY1BKaU03NUpUZ3JMUWI4?=
 =?utf-8?B?dmc1NjQ5ekx4SjJsZEZrSzZHVkYwekFWNllXaFFnOVVwaVVOeFQ3a2ozdEc4?=
 =?utf-8?B?dk0wYkNCaVVmKzBmWUVZR2dIN0QraklBWEsvUFF3azdEWDh1TWYzTTMwNkdz?=
 =?utf-8?B?WXBJL3d4S1grbXlkd3YxeDQxMFlEZEIvSjNCYUY3aUJVMFVLR21NMFFqMXhB?=
 =?utf-8?B?RnJvaUdhcXBNOW9zOWdvRkZ3MG9WMW4wYkVxR2daekJnWUNqa1QvNnowc0JO?=
 =?utf-8?B?WDJ5NnI1MFpRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDkxUFM5bDQrUVRDbFN6dDdxeWlwWHh1QjZEbWxFWjRiTTM0UnM0Y3Z0b2xh?=
 =?utf-8?B?Y05HeFlScjNWUm4rLzlHcDdiUmNsVzNWWk1xczdXbUlDMVdSalpmUmVSZ1pF?=
 =?utf-8?B?Q0FpZFVMUVN5bGRVb0lLaHpYT1NPRTZLdytzMDFla2kzV2RFaXJINHFNNGRs?=
 =?utf-8?B?WDN4N2JhTnRaL3dDTEJZc2k0aktLcExLK3FiV0w5MWYxSzYxazdVZmtqVGVs?=
 =?utf-8?B?dlBsYVgzaUxHOC9kN1VCcWhOKzR0YjhuOWUxRFpYaFowZHhkc21BSnBmdUpa?=
 =?utf-8?B?aXF2TEdvUUxsdUU0dldGdlBLSnExQnFNcW0xeFZMcFpCSnVYenlNdlBwUG56?=
 =?utf-8?B?WU1penl3alh0VE1FMDlnMk9OUVkySWNWbmVkRG1xZmh6UjVZQ0RBZkJVQjhw?=
 =?utf-8?B?ZXhKZVhFbzV2TXNJeVcxekhoS3dqTTZ2QmRLNFZGRjl5aHdIUkRXbERqdS9G?=
 =?utf-8?B?VXdKMGY1R0hmdmprTUwwZloxelFDM2wxVXB2RzJvVWx2dzYwVzdVQmtEVHVM?=
 =?utf-8?B?dzZMVUpSUUNmcDN2enZmamFYUVV2bnV2cUF3RDF6MVdVMXdSY0Jwazg0ai9t?=
 =?utf-8?B?aFJzOUFpeVZNY3NnTjN5QWVnTSs5YlVpekVTWUU2SlNoY2hHUzVpVGhYd1VO?=
 =?utf-8?B?SG1oZmtVcUxTbXNtWUIxVlovN01oZ3ZtZm5vRkg2blpodFBsKys4R1FhSjB1?=
 =?utf-8?B?UEE4UnhVVXBrSGtmTjhwZnA2ODRFNFR5N092NzBWNHpQek9rTHpMcTNzb0ZR?=
 =?utf-8?B?OElmSGE4MUJFYU5Eei93WUlKbkVRQ05DOXM2RTV0VEVqUDZvUTRaNENlR2tZ?=
 =?utf-8?B?VWkwUEJabEExUEp6MSt6Z1RVZFpHeURIZ3dZNVpvUHVTMW10VzVPeTl5VG05?=
 =?utf-8?B?OThYU2JZTGcxbHIwMzJzVzlCNGZnV2pmY0Z1YU5sNVp5VUIwNE5SL1dLRWRo?=
 =?utf-8?B?c2xEMmJBTFdnZnBEOGl0UjRYdlZSZFFrUjg4V2h4U1BrM0prbXNwZS9yWTlY?=
 =?utf-8?B?V0Fob09WQURtKzNaclhNdmZpNGUzRVJDU25qdmMvVUpSRERWMGlqYllNbWRn?=
 =?utf-8?B?Szc5bjhDMERMemJHUUxHMWhaRmxESmRNWFhlOHhRL0wwYlhNeCtlRC9yTVJq?=
 =?utf-8?B?YzMwWVFRVmxTRHpVeHE5cWtQYTNaQnorUHVENVoxMVEyQmN2MHBxZFFqVk1k?=
 =?utf-8?B?RmU2T3FoMUhWMVRUc3FWZUIyRWFGYy9OVHRQYlpWcG1xN3BpZVFDQk5HM0Iz?=
 =?utf-8?B?VndlL04xWVhSbTlFN0lyWmNrcUpKV2dtMXozbmtnUUVNVlZoeEh0L0NJT1V4?=
 =?utf-8?B?K0VqcjNObDA5TjV2NWthbHhLTVlISjFhS1FwZkpRZDA1RlVrMjVjWGxpUGVj?=
 =?utf-8?B?WTRDYmNhcTF5UElnY0MzMDM2bWttV21Xcjg3TGFHanp5MGtFOFRlcU5LdDZh?=
 =?utf-8?B?Tzc2MnhVRU84dUU1OWZlajNzQnlvSzU0VURQc0lTRjU5bjlNc3E1OUswS3Zz?=
 =?utf-8?B?dXgzQWpyN0VoZVBoWVRFYmNhV2owckg2OE9aV2dIMEtIMk5ZTndKckJqS05R?=
 =?utf-8?B?MUQ4TmxZdmhWNmx2R3YrSk5zN2I4a0lnY0dzRk1RdGduVWhtQ2NJUlNMalhF?=
 =?utf-8?B?RlQzUXljR0xOUjA3YmlYVkVacEJYeUdMWTBzcmQwUjhhbWZFazQ2dm1EeFJ3?=
 =?utf-8?B?Wjl2b0U5TlgvaU53VnphTlFDdHp6dEtGSWoxRHFSWUxET3hKWWJTQ1dIS2Fo?=
 =?utf-8?B?YWoyR2h3YWRTKzBWdnVPRUxidFJ1Z29sbEpoa1NRa0loKzhBZmpSbU9id3hl?=
 =?utf-8?B?VVBYUkpvTUVlb0VTQkN0cmo0Z2xaaTFjenhRVldUUXluWTZuUkJFNS9uV3R5?=
 =?utf-8?B?UmZQYjJsdG1PS0p0dFBnZ2tZM1dLMk9yTVdObjVUQWJQa05kbE5melQ4dlNi?=
 =?utf-8?B?bEZ0UURwd0I0N0p5WjJQVG40dTNKUyt1aXc1czVVVUVLVFk0T0R1TWYxZ0JU?=
 =?utf-8?B?RUdoY3lmTmJFakVkN3pjcGNhWXIyamJJNDY2MElHWWtwQVhpeEVHVitqOC9B?=
 =?utf-8?B?L1dqaXVwdzZpa3RwZlNJNHNWMmpTMlBvejQ3V1UxZU1NcmUzQ2szalB0TkZa?=
 =?utf-8?B?QWJQQ2NZQlFHOU5MRCtCa0I3a0c4Tko2RFZCbjJHTFBjM1pDeWxsZXM4eWFq?=
 =?utf-8?B?REE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2FCE4C107C85D48BEEE8B1D188C227A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d98fd6b-49c4-4aec-7b1d-08ddd31c0c6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2025 05:59:17.7401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ISN4KYBr5bAeeuc/i+1LTNqYVMrGG54JHxxFGeKc07OvR5v0Ha1RCH9YGrTH1i/EPBwYiIxRSOKxfF9sRsSspA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PPFE6DAE24FB

T24gRnJpLCAyMDI1LTA4LTAxIGF0IDE2OjE4ICswMzAwLCBEYW4gQ2FycGVudGVyIHdyb3RlOgo+
IAo+IAo+IMKgwqDCoCA4MjHCoMKgwqDCoMKgwqDCoMKgIGlmIChxX2luZGV4ID4gbnIpIHsKPiAK
PiBUaGlzIHJlYWxseSBsb29rcyBsaWtlIGl0IHNob3VsZCBiZSAiPj0gbnIiIGluc3RlYWQgb2Yg
Ij4gbnIiIGJ1dCBJJ20KPiBub3QKPiBjZXJ0YWluIGVub3VnaCB0byBzZW5kIGEgcGF0Y2ggZm9y
IGl0LsKgIENvdWxkIHlvdSB0YWtlIGEgbG9vaz8KPiAKPiDCoMKgwqAgODIywqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgZGV2X2VycihoYmEtPmRldiwgImh3cSBpbmRleCAlZCBleGNl
ZWQgJWRcbiIsCj4gwqDCoMKgIDgyM8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBxX2luZGV4LCBucik7Cj4gwqDCoMKgIDgyNMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHJldHVybiBNVEtfTUNRX0lOVkFMSURfSVJROwo+IMKgwqDCoCA4MjXC
oMKgwqDCoMKgwqDCoMKgIH0KPiDCoMKgwqAgODI2Cj4gLS0+IDgyN8KgwqDCoMKgwqDCoMKgwqAg
cmV0dXJuIGhvc3QtPm1jcV9pbnRyX2luZm9bcV9pbmRleF0uaXJxOwo+IMKgwqDCoCA4MjggfQo+
IAo+IHJlZ2FyZHMsCj4gZGFuIGNhcnBlbnRlcgoKSGkgRGFuLAoKWWVzLCB0aGlzIGlzIGluZGVl
ZCBhIGNvZGluZyBkZWZlY3QgdGhhdCBuZWVkcyB0byBiZSBmaXhlZC4KSSB3aWxsIGNvcnJlY3Qg
aXQuCgpUaGFua3MuClBldGVyCgo=
