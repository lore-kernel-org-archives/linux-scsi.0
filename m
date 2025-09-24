Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BFB2D0631
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 09:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758705210; cv=fail; b=EA44H0q6mO0sARQKzDTYg1CdDuyqfV2+NLLSk2aQGG1QxeCumVpFfxGKYQuYUDeJJQTIM3tAXa2qhhJbQubdU465cxrelfvWnTnNOCO+RfcBLIhKmbHLLU70nr03X7dXdJobMwwvuHcVRd/jpJV0OFdwJeFrtygBXOoFFhQ4O/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758705210; c=relaxed/simple;
	bh=do2ChHI8jG0vHgLwOCTS8lo3Td9pPjwwsVYAp3nX2IE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=puaJN/IjqJULkp5g4DhvZBTjNmpJUW9AYh3H+ZSg6M0rAnQR6fn3nTCsvpFW+0c3CSZcAZyGollP3Zx9pzSRj6QaCTrmjedAMS0NGjrEk3URw6T0C6pELOER9NNqoUBsNCcqL04RSbNLbPhJ2tbrc7gY+eOl6mXYpu/5Yffn+aU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ReIPvSjh; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ucZ3vfnE; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ReIPvSjh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ucZ3vfnE"
X-UUID: b7e99350992611f0b33aeb1e7f16c2b6-20250924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=do2ChHI8jG0vHgLwOCTS8lo3Td9pPjwwsVYAp3nX2IE=;
	b=ReIPvSjhbLYGDATsfLnKUn58Dj4ooglxi06BZQxnaXPwKTWTNPUFulXawmbicuGtVQtpF2UUTz5lG4gQgUVh5oSD8xWuBvaxcMEMZ/yMNagwavuvVMSGLdFSJBzO88b0m5L+xcQeZYr8UTgGXqEZrjTf3uiusQTISbuS8XrVRUs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:d30f3440-1c3b-4c42-b44c-d313f050c679,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:bbaba1e9-2ff9-4246-902c-2e3f7acb03c4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b7e99350992611f0b33aeb1e7f16c2b6-20250924
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 338425105; Wed, 24 Sep 2025 17:13:22 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 24 Sep 2025 17:13:20 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 24 Sep 2025 17:13:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CpQu8bhWIQ/rkPV9oW29o4HAamSrR9PdMX2XCvuKj6kKsblT5Pj5dsTymINCWlPjPEVdRLMw3dO6GqUi/PQF7ZN+9ukPTpKmTXbwdxUyS9EEyuceganSHb6wUXmtOLju1n9ZqREzcceljUp4HASaXSkNukO3SgnWhLQcUVjjIq7lvkRufrg24wxxkEKFUrSDvIizGEGMIVWeNq0HxFwiZwJ8hl+kGNeM1Mh1jz7qWmaxbt/yd6bj+pz+uxseM7qJkcAesrGOAb93aobx0f9U6CpmX0floILGhoOEmSsCfXVV0P0J5h6p+urmPczR7Ro8cWPQZx/167h+sk7sizqB2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=do2ChHI8jG0vHgLwOCTS8lo3Td9pPjwwsVYAp3nX2IE=;
 b=MLGzAJRYYmcBea6bch7zia+aeWLBv48fEZnSffMQH0MxnWwbYRr6i68QBgVEfD0RCQuuxOO2t4WeM/NJkqeqUzyeFhb9lU+kPJQUtZJ/MaHQ4J3nilh+4iO7rvMYpNPO0Lu6u3ryqa8YXxTYTD9ez7GZbeF0CQRkpNoRmZ3NtfIy3AQbvrBCnVBvaJMP2uvRHnRknrmnskXwIOI55Mhuv848v4pA8Fmwp0zdFtcvfrr1cgn4n2l+vy77OyaRdQaWxKDQwhW8t1KxUKrUiDlSnCxvIOTj788IKbO0P5XL3Wdmvi/U6ZNFBXQBm+ubWVy0blm+9nA9xWDeQeZGPqjI/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=do2ChHI8jG0vHgLwOCTS8lo3Td9pPjwwsVYAp3nX2IE=;
 b=ucZ3vfnElBP8aui8bxhyO0rb43UY22xQyAWTcHOaY93GZwmwMkJIn/lQPd0ZopboFG5yYpCsOXMdZEoQdP0+IIF1OgQizNVrJqKHgtvNU/i4w9XJ3Rd1CUyP8SZx2wC6jqtdF4QbXYqcrpPKxZshwVOZPudo7cdZFEBUb+ZFPVQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7696.apcprd03.prod.outlook.com (2603:1096:820:ed::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Wed, 24 Sep
 2025 09:13:18 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9160.008; Wed, 24 Sep 2025
 09:13:17 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: Change MCQ interrupt enable flow
Thread-Topic: [PATCH v1] ufs: core: Change MCQ interrupt enable flow
Thread-Index: AQHcLGm1SSdlscwJ6ku2BPbB8YE6WbSg69sAgAEiPQA=
Date: Wed, 24 Sep 2025 09:13:17 +0000
Message-ID: <9b5886367b8386a0927286b7b7aaf086b65f6688.camel@mediatek.com>
References: <20250923090855.2522149-1-peter.wang@mediatek.com>
	 <c9f1ce41-b81d-490e-b919-a6105ed34ff0@acm.org>
In-Reply-To: <c9f1ce41-b81d-490e-b919-a6105ed34ff0@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7696:EE_
x-ms-office365-filtering-correlation-id: 061d73c2-5529-4667-e29f-08ddfb4a992d
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Z0M0SFhGUHp5b3lxaU1CeDJEUStTWDRBSTRsUm10Vjh2N3lpYStFbmtxUmRQ?=
 =?utf-8?B?M1lBbk95WjkwVVRCTmNwcXl4NDdjcGFCQWlPZ3c1VVhrd2dtN1A0dWs0elMx?=
 =?utf-8?B?aXF2dzFJZ2N3WkMyZUo4UUV4cTNxSENqTmVCYmlwRDNGRjBUMFFIUTBqdzY0?=
 =?utf-8?B?V0hZbFo1Tm5YcDN2Nmxib3MwMWM0cWh6bktYRDk4RWx0aExIVmFFTGl4bGd3?=
 =?utf-8?B?NGg0dnp4QzE2MzRQWFhzUjNIUE1ZN1BZc01wMG5qbTlyMTI5aWkvdUFsUTUw?=
 =?utf-8?B?eEZJaEY4T2laUTVNbzBCM0RVQWpXRkRDbHIralFKWVRkUEp6K3R1R3l6Wmg4?=
 =?utf-8?B?d0xLRmNQTnZoS1U1UXhDNEY2ODhZSFgyR0xLbXB6MXpUeDVDSlBSTTFsdEFN?=
 =?utf-8?B?ZXFkN3A2VSs0WllpZzMxNEpDR3dCM2NGU3hnOC9NSlZKeTN0SmVjSHRBZEU2?=
 =?utf-8?B?Qyt5NGRSNjVYTUFhbUZ4S0NrMjBQZVh6YnJUYVZUT09hYjN1SlJKYUp5WGJa?=
 =?utf-8?B?NXZCaVI0UVZFRkx2TitPQzcyTlN3dFh1Z0liUVFwbHkxWVdHb3FzMGh5Q05C?=
 =?utf-8?B?Q3NUcHR4T1hjVklkYzgwRFA5UTRkMkV4aVhaLzF4N3d0WVJKUmpzN2pFdXdO?=
 =?utf-8?B?MEZtNDMvd09tOUFJY3cwcXl6eHc2NkZWT1NVN3o1RTg4cXZSQnRyeFdkcGdT?=
 =?utf-8?B?bGpzTjhMakhHL09GUy96WVpnSjZxVFR2aGxDZm5NUVl3aDBVMFhhNVpIZU9P?=
 =?utf-8?B?UE5EY1A1U1BTVWh0NkRMOTFaSE90WXFzU1IzR2wyTTBPdytDUFhwNGdibHVh?=
 =?utf-8?B?cHd1YVVIdXFqOHJOVFJUTUJFT3FDNldpMVU0bGpqOW5xSTdzem56anI0ZExv?=
 =?utf-8?B?Uk0vUmpFUEtteW5oekZ5dHdYU1RJSGNQcVdPUXl6R1NlbkRLRWxvSzVLWlhh?=
 =?utf-8?B?VE1SdFE3b25ZeVBJYXRlelpOVFZTY3E1eXZVdlY2SjlnWmhHZkE3NGtnb1Ri?=
 =?utf-8?B?VFFpbFRVa1NFVDdnYkJ0ekRHUXRMSXpoY0RJSnc4N21FREwyWW5adklGT0NT?=
 =?utf-8?B?c2hNUE14UjdDVUs2SW4yMU9iN0JPWWJqb3pFT0hSYzlocS9qK2VLR3BMU0t6?=
 =?utf-8?B?VlZ2bERlMHA1Rkl2bHA5NnVUTVVqME9rdzlqTGhyUG5jK2NVYksxUU9nb1Uw?=
 =?utf-8?B?aXQ2Z0x2U0VFTzJQQ2ZDdGxNT3Z5anJGTzlQWjNrbUpROUVLc3NMTjRFY1pX?=
 =?utf-8?B?cExtT3Myd2NyOFRhVzFIZk81YjlnSjluemJoaUFhSlZoS1BIRVpROUd1MEVX?=
 =?utf-8?B?eS90WU5Fb2pIM3NOYm5jaW9aeVQ5SU1LRzVLTWpJYTdjTkZXbkwwbE1uRFJp?=
 =?utf-8?B?RllWV0pTNGlLTHBLeFFxbFhjOS9aekFrVFE4Z01EUXhWK2g4YTF4WjJzQlZm?=
 =?utf-8?B?VW1mOGRLeTRwTU5PTS9PUjFVcjRkaitxQ3IzRFJrQjhDUnRiZkwxNnRuQ2N1?=
 =?utf-8?B?VzNzTmZ2TGpXTEVycEdBY2ZNS21Ta1FUWU9tSzJrK2RLSklnckI2eFBTTUw0?=
 =?utf-8?B?cXU1T0dSVkwvRm0zT3pJMzBZQm8vUUM4bjB2bFNCYnZ4WkZlN1VQYkppbGFT?=
 =?utf-8?B?cW9Ka2JZUHVSTmM2blNsTjdZSkFrV0ZTYWwxWlNoczRaSyt6MUpEaVk5YzVM?=
 =?utf-8?B?UXhhUlJYU29Cb1QrL3VkbmJqNG8vRElDWklUbmVrL21SWU8vdXZCS1VoM2hY?=
 =?utf-8?B?TXdsQ29CSitnZkphZzhvRzZDbE4wTktDU0lsMUE3b3EyN2k3N2kyZUdjZ241?=
 =?utf-8?B?ajdiMEpWclhoZ1h4cE51ZWxuQlpVR2ZmSWVLVWtPNUFncjhsMXJIck05SUJ2?=
 =?utf-8?B?SkZqMUo0NE1aSzdmRU8zaGlwOURwSFMycUFweEM2Ry93Y0QwNHQ1ZXd4YUVC?=
 =?utf-8?B?NlZoaTk1OGZ1Vnh6M0ZPRjhZRUFmQXF0c3pBUVBVeERnRHR6Zklqa0FVRWJI?=
 =?utf-8?B?RFlQS3Y2N05RPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzlvMHhzZmhvcDNqMHB4MVNYTTVRcHZTNG5mS1JGTzY1UXRSRytWMSt4ckN4?=
 =?utf-8?B?R3FDbkg2NGZpbGdtU2U5ejRhYlhTc1lwQjRkbHIyd3RCbHJRUk5xa2c2N3hx?=
 =?utf-8?B?TkZud1J1NUFxSjJxT1EyWml6QjREUGRDYVBzS1pPeE5HNm5zSjJpYTJqU24z?=
 =?utf-8?B?OHhWWmZldVFpMFB5Q3k1eEVCcTAvaWNOZ2xaNWtGbENYalgyNGd2Um9ScVl1?=
 =?utf-8?B?aWZqazg2ZmJmMzRkM0JmOTA4MytqbXVKQXg3ekE5TmFsY3lhTXdxN2xHY1NI?=
 =?utf-8?B?R05uMEVlTmF1a3M5WmR5SE55YnVYelV4TThuNEJQWjhHZDYyQ1hGalhCUTZI?=
 =?utf-8?B?dmh2SXpzb3VJb2JoQVcxOFIyK3owZ0l6WW5IOU1jWUdBemFaejRsZnNaN2V2?=
 =?utf-8?B?dndOSFRtdk1LRjJzWXJRYm5sRko4RnZqVlZRa3BycXRIVThOQjdON1U0c090?=
 =?utf-8?B?NHA1U2F3T1FwUXFMenFURktZVUlibnlZaGNOMzN3RmM0RGZTTFBUdXdRQlVa?=
 =?utf-8?B?MWNOZnZaSUtvSVJqZ3Evd0JaMWhBSS8yVU9OTjRVaEc2QVY0aUFxekRvUTRY?=
 =?utf-8?B?cWRGaDhNc09PSGMxNlhoZ3RnS3JVV0VUN21aZy9NQ3EzcS8raU5oT0swN2Q2?=
 =?utf-8?B?QU9yM0xqN3ZZWFZwUGJieFp5ZHdTNG1paXFLS1Jmdkh5ay9vZUR0QXVFK3Q0?=
 =?utf-8?B?L05oQzJqMGxlalZWdVRFd25oUEVpVnZuUDdjQ3lreUk5UzM1KzgxRXMrTFI4?=
 =?utf-8?B?YWxLV3ViRGduUUVJdzlGM0hOWWpOcUFpYXZjVFk2ODh6MGNIdlZ1REozSFdF?=
 =?utf-8?B?aVJweTRORDRoZXhNRDVqZmJVY25xQnM0TDRZN0o3dlE0Wkp1QnF0eU5lUnQr?=
 =?utf-8?B?UEo5NG1RdHBXQjFzSFAyTGdoZ2NnWUFTbWtkN2c2VXVYU05iclNFc2NpNVJV?=
 =?utf-8?B?MWVGY2JrWDd1cU91L25PL2lVZG04RFNzQ2RnRHNRZ1lFSGw0T3pPaUdDcjZD?=
 =?utf-8?B?K2o1S0oyclhzSU1IMFN5QWplMDlZN1kxUTJaSDdjMWxESUF1eTFycitrZWNK?=
 =?utf-8?B?TmNZMXlUdTNOaDEwRCtEbEUzMjNBMWRmWEx0SHFuSkIyUnBUbjcvSXFDZVVw?=
 =?utf-8?B?c2xaVVZPUHE2MHJsRTA3K1dsNmZ2NHVwYmpzOGlHc2loQUdmRmhsSEJTRlR2?=
 =?utf-8?B?UWxRZ2MyQUQ4cVAxdmNIeUN0bXI5amVhekZseDMvQ1FUcTJLUkxRZEl6K05p?=
 =?utf-8?B?ZU1RZURvK3kwQ09WZDd1bnhFN2ZXU1E2bUlwc21CSWloLzFZamh1WUxFTHJm?=
 =?utf-8?B?bFcyY1lNUXUvWXVuQTJWcHJSUVhrenRUcG1nQ0tDNFovaEsxcU9lTmNvemxj?=
 =?utf-8?B?cjFDYXRxZGMyeXpycFRRcyt0UGFXVXhFQ2ZuQ093bVpJaHZKa3A0MDA2QjY0?=
 =?utf-8?B?NDhlK3RvdlJpY3FYOGRiQ3l0OURRTS9LZkRuQVJ3VXZ1VGtyUmNxZC9NSjk3?=
 =?utf-8?B?RmNTaERwNERtaU5GNkJQc2xJMWlTdFFDOU5yRlN1TXFMQ242TjZXZUZYNzB3?=
 =?utf-8?B?UFp1MDQzbktscEg5NUlOR2d0TUdkSDBxQTh3eUk5cWNQLzhvYk80emcweXJX?=
 =?utf-8?B?WVl5Q0Rod3ZoZXlNUWdtMjlTazc1cFNoM0l4UTdzTWt0WHhzL0FHSWZ1ZnFZ?=
 =?utf-8?B?SmFuZzdPU3lDTURQeDRMc2QvQVBrUmNHam9ueDFmalRSN3pTVjd1M2E2U2Ju?=
 =?utf-8?B?bWtFWk05UDE1Z1V0bU8xLzZSQ3RMMkc3ZnBGTzlaSkdyVlVJcU9xWWJBTkVJ?=
 =?utf-8?B?REdsRVIvYW1BdGlYSGdkVncvZDF6UTJ3L1pyc1A5L25tK011Q01veUNEdTBV?=
 =?utf-8?B?c3FLZ0hnZWc4STVrcGljZCtWZ245U2x3L3JDQm96RUtGUHM4TXBLa2laUFNZ?=
 =?utf-8?B?eGVITDNFcnJoVVVmMVkxYlJsdzhKM1hzakZCNGFZaEdqNXlnbW53SHdoeDd4?=
 =?utf-8?B?YnRBMWk3NUFVK1dTYmlYd0xqemhJOXdoMW9raGlDYlpsZVZxSG1KOFlQeW9v?=
 =?utf-8?B?ZnFNcHM0NHFMOFczUkZlVlNvYVJoaEVkS1c1SlFHZCtuUldCL0xRVkZ2V2h0?=
 =?utf-8?B?dlhVQXI4QW0yRDl2SFJxZ0Y4SmNGd0VXbkdxaFZPNmxkK1llbFl3bWpJc2d5?=
 =?utf-8?B?NXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <133FAB1E9E7AB445AB9A9D9EAAC603C5@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 061d73c2-5529-4667-e29f-08ddfb4a992d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2025 09:13:17.2395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VZqmHY41lgn647hOwllg2TzTEUSG+B3Ic59aTS4MltQXB+zwQK475yTz4hcGGfLEUaMhTuOTccTJFdOmJ8y+pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7696

T24gVHVlLCAyMDI1LTA5LTIzIGF0IDA4OjU0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBPbiA5LzIzLzI1IDI6MDggQU0sIHBldGVyLndhbmdAbWVkaWF0ZWsuY29twqB3cm90
ZToNCj4gPiAtc3RhdGljIHZvaWQgdWZzaGNkX2VuYWJsZV9pbnRyKHN0cnVjdCB1ZnNfaGJhICpo
YmEsIHUzMiBpbnRycykNCj4gPiArdm9pZCB1ZnNoY2RfZW5hYmxlX2ludHIoc3RydWN0IHVmc19o
YmEgKmhiYSwgdTMyIGludHJzKQ0KPiA+IMKgIHsNCj4gPiDCoMKgwqDCoMKgIHUzMiBvbGRfdmFs
ID0gdWZzaGNkX3JlYWRsKGhiYSwgUkVHX0lOVEVSUlVQVF9FTkFCTEUpOw0KPiA+IMKgwqDCoMKg
wqAgdTMyIG5ld192YWwgPSBvbGRfdmFsIHwgaW50cnM7DQo+ID4gQEAgLTM3Nyw2ICszNzIsNyBA
QCBzdGF0aWMgdm9pZCB1ZnNoY2RfZW5hYmxlX2ludHIoc3RydWN0IHVmc19oYmENCj4gPiAqaGJh
LCB1MzIgaW50cnMpDQo+ID4gwqDCoMKgwqDCoCBpZiAobmV3X3ZhbCAhPSBvbGRfdmFsKQ0KPiA+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHVmc2hjZF93cml0ZWwoaGJhLCBuZXdfdmFsLCBS
RUdfSU5URVJSVVBUX0VOQUJMRSk7DQo+ID4gwqAgfQ0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTCh1
ZnNoY2RfZW5hYmxlX2ludHIpOw0KPiANCj4gUGxlYXNlIGRvIG5vdCBleHBvcnQgdWZzaGNkX2Vu
YWJsZV9pbnRyKCkgLSB0aGlzIGZ1bmN0aW9uIHNob3VsZCBub3QNCj4gYmUNCj4gY2FsbGVkIGZy
b20gb3V0c2lkZSB0aGUgVUZTIGRyaXZlciBjb3JlLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFy
dC4NCg0KSGkgQmFydCwNCg0KT2theSwgSSB3aWxsIHJlbW92ZSB0aGlzIG5leHQgdmVyc2lvbi4N
Cg0KVGhhbmtzLg0KUGV0ZXINCg0K
