Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2746C1D554
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2025 08:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760689718; cv=fail; b=lDzE3xrqkyLdoO4Fhz2YCIsw2TtM92US9fyzZ+KSkbUaWw2G6LSBn49mcfQlXLX+FI7ByDq9bspwShjfIlfq1ZYO4rDROLSW/3vHMZayjjZV9ZW4LZeAd9pw9YnzYr06I7Rfnzu/+f7VSp7NxdFcYX0PwarngNb4WXNqRMWmpVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760689718; c=relaxed/simple;
	bh=idn31CzAd0q0gFjiBw2aThmGABaHMuYigLyqYXnObJU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gjp5toI+y6WyUYaV3q/Zn8J0/Op/ehCrGiOBPVX3+DotGcOivjdOeuI5RCXQlHwIyba9dsZbUYuvE1IYFU3eF4HQmKlUOMRRA5xqqnOCo5uYyqGnLq2W5kA9XXMKy/0XjQIIBhj6XD7m/rHsOuEy0TWrhvJIxclgwKagfTjnmOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=YuOSvn2y; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=XRVP0MER; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YuOSvn2y";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="XRVP0MER"
X-UUID: 443602daab3311f0ae1e63ff8927bad3-20251017
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=idn31CzAd0q0gFjiBw2aThmGABaHMuYigLyqYXnObJU=;
	b=YuOSvn2ysLCaKcGHTcCp+itBxEMCAAhyY8MKFvTbmiMZ/kOABWtrovI6WMYVVqethvOY1aYQKysaaeVad/t0lPXrRCWHvLoPQ89luSLI3huP9RH0T76EwA3K19S5vRUHDnjvczD+WJU+qAyeAhYFTpUNBeQTq6KE1AHUvQXZSos=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:0b83db7d-458b-4043-b3bd-1b117e91a643,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:5e5f2a51-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|83|102|110|111|836|888|898,TC:
	-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC
	:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 443602daab3311f0ae1e63ff8927bad3-20251017
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1254563273; Fri, 17 Oct 2025 16:28:32 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 17 Oct 2025 16:28:29 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 17 Oct 2025 16:28:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aOPzhK0DG6lmIVtiQ0+LhQOAp88yq5wSmjvoO9h+vt5X55z6hmFvYCgCvhdJn67Fo78XeTNATvtr/MrPG0MTNOrvh1ASIIYqClcgAut++Kvkuh4XRD4oC7iqUVLIl4+Svaj2Navwi9U7o5CMgEQOi5YJRkow+ivy9al8SzvIrCIH3bButx9C5pQnoucWHcn7W/WZ4wVXlM9dGJqJrmTcBxsHZMoC1kQiy5eA4UK8Lfn2mvHcPNtzIHhwNQ10Lqe6/jjH2UtUamjiUw/OxzQoBCDm95PX9aLHH38/2RFkfUz6x/NLE5sUmEZ0boxsEKl41P3v/OYci3hkk3dc/k/hvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=idn31CzAd0q0gFjiBw2aThmGABaHMuYigLyqYXnObJU=;
 b=bxM0aqKhlWSbMN8p7oA+M6Af1To9c3V4qrFSeFdDqeokWEzJr0JKl/lBMgbwxttDJI080WznaY26xZxa4hPkiBq3hGtIq3n08jScrwtEE/guRgXO4gQBYntCEl6QYR5ornRcbtRKDh6726/xTMeG9is1spENpz1qDpuAO4XvWsWwwzGbd7EqcnAbS6xpgOKEcelEpuLB1DPzzLKO7IW02zb+BgLhCOT/ROURNNT9XfzftuWZfM1TbxDR7Q4jVcnku4QMFOzFHJJEicL8I9e8d3INYb1mSwouLkQOFcy6Jj61OQ2f+BGd+N2Sq/myl6qe3GNP9CVweHFa+wc6AN9Gxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idn31CzAd0q0gFjiBw2aThmGABaHMuYigLyqYXnObJU=;
 b=XRVP0MERL4EdUNkTDNzxSZ/j4PqywgGnXVWrZGcE29gDDJrEoeTgNXJAHfjc8erQxoQT4hCIA2OsgDlVuBc3Dju645TeOAVrO2uPTbyoJQATH426+a1SmhVKPgQIwWa+bFXnQ8c3Nk2k2OhwTQ7NgZ7QfiT4bwQhZDXx5h+TSMg=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6847.apcprd03.prod.outlook.com (2603:1096:400:25b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 08:28:28 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 08:28:28 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/8] ufs: core: Remove UFS_DEV_COMP
Thread-Topic: [PATCH 5/8] ufs: core: Remove UFS_DEV_COMP
Thread-Index: AQHcPUWKIFqE3bEJgkeA97b8fb4YvrTGBXqA
Date: Fri, 17 Oct 2025 08:28:28 +0000
Message-ID: <8f81f0b9b4da80ae3adc70e7ad4b161ffe162dd6.camel@mediatek.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
	 <20251014200118.3390839-6-bvanassche@acm.org>
In-Reply-To: <20251014200118.3390839-6-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6847:EE_
x-ms-office365-filtering-correlation-id: 273e2cbc-432b-49df-f29a-08de0d572610
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?L2dHbTBDaExzaEszc3FOUm0wN1g0OUVlSkVhdWE3WGlWeWthSWpLZGEwVkN3?=
 =?utf-8?B?bmVYVVZkdWdydCtDcm5vc1pXTHFnbHQvTGdnQkphdW5pelA3UEZIRUZIOSt1?=
 =?utf-8?B?SmovcHJoaFptRjZQNVdqVjYreXFFOTBJN2Mxd1I4bUJteDlLQ1V3eW9XWUNS?=
 =?utf-8?B?TzVtYUttbHBnUFBFWFNDQlpJN1J6RklKSmVSWUovYWQxWHhKWFhJdFZFRFdX?=
 =?utf-8?B?aVRzMnR4dzRsb0RxajZnUmpuZWREN21HRUNEczhOMFcwUTZGZitPcHJzTUJk?=
 =?utf-8?B?YnIzYjBreU9tT2JtdGpQRFJLdHFtcGJSbGZ3blg4WE1mVXZ0dTRIbHRHdG5Z?=
 =?utf-8?B?Znk3VklWZFJWTTFZZUNVTFRzMkZjS0dqSEZmYjNJRVQyS3JjRHFqM0pBSmZz?=
 =?utf-8?B?U21iclB1blB4OFJLeU9GaXAzM0JTbzJOdmdQTXFTWTZiY0RPL2NlR1pndGlX?=
 =?utf-8?B?MHR6Sk0yaTNheisxTm4xMForS0xNUGkrZGk5YWQ4UGFJV1Fqak5iWW5nSlZs?=
 =?utf-8?B?Z1NDQ3dQbGRNbG9obUlqUkJkUEFQZVJjcCsrQnhiNkh6VXRwRElaTkN2dGdr?=
 =?utf-8?B?YWlwR3pvMWlVWE1pZk5UaVlKVWlXQ29jQUU1QWtaZjRiaURSaVRNTTNNZElP?=
 =?utf-8?B?Q1NhZWcxSCs0emhDbWtJM3BkUUcxZmIvS3hpUjJSUG5GeEVob29CcTRzY1Bs?=
 =?utf-8?B?aXgzN0hPM0RSemNKY0JqRnpzUkRmS2hIL1JsSzV5WDNtaG9LSi8zb25UZWN3?=
 =?utf-8?B?OGpMR3FTMTFxWnBvQTkycG53MGVvTzY3UnlreWFJeStLblZaVTFBbVNlUlVt?=
 =?utf-8?B?bm5XdVQyeGI4ZElGWCtQWkZidVZxYllYQzBwN3ErWHRpWG02YWViZmM4UUJ0?=
 =?utf-8?B?Rkk4K2gxNzVsRXc5V0IwUjRJcDZ0Mm9zUVRQNDhOZFhTZHh6SWFlMGRQd3Ar?=
 =?utf-8?B?Rmtab0d0TnlkY1QyWlo4dGVLNGlvSGk2a28wRFZtMXNJYUFjOUpaZTZUWEZF?=
 =?utf-8?B?YzAxTUNTeGlIRGVCZVpKeHA2M2R4VWtNYUJJOXlkY1hHRWQxdWxWTDc4VHE5?=
 =?utf-8?B?aHdNYUFFZ09jNTJUNHpBZlduc1AwaUVaR1JQSnF4ZmtBRDIxaE9XbnA3cGhZ?=
 =?utf-8?B?UkNRaTRkK0Rxd2VPS0wzK21jZWMrdFVCK0JNNUNtK3dhZ0ROTCt2Y2x4eUdS?=
 =?utf-8?B?Y0pRN2VxM3lDbnVmSnpENlhZdEtJQUk1QmRiL2poWGhxMFk0VDRKVWUxMzNZ?=
 =?utf-8?B?ZVlLSmlaS1ZLK0dZNzFHblhnWisvL0N4NFlpRVdpOHVlV0lITngxUzM0aDVw?=
 =?utf-8?B?WXZGWkl6eWw0SUYrM2ZHL2lGdkN0djdVUmJvQVlJOVp6bEhRZk0vNDBwUUxt?=
 =?utf-8?B?bSsrV1RHeloxSWJXbGRZc1lXSnFMRU5KZ0FYQlJpdEhxRU5pWlRzRHZkeUNS?=
 =?utf-8?B?cmlZLzlRekdVYW8wZVBhVVBBNnFqUTZlSTNtZ3pUS1pJZ01KK1d2NllOb2JR?=
 =?utf-8?B?WFNwclVIRXlsNlEwVzZGWVdVUldaYjBhVjlkOTZvNFVBT2RSbndFQmkrRXYr?=
 =?utf-8?B?OUNiV3pTeGJkVXNqRmlDNnUwdktHNnlHZFY3TXZLY2RJSUR6MytaTE5Db1I5?=
 =?utf-8?B?emR5ZGgya0ZjaHlNa1dqWGU3S3Zoc2JESktlc1hKK1RjK0NPb1NncjRNdmV1?=
 =?utf-8?B?Z3V4N1ExRlUybGsrQXNDSnFFdk5kekQ2Rjd3WURTcTN2U0VOV1VtZVEwMVdm?=
 =?utf-8?B?YjBNWnpoT0krN3IzWU5PMmRJRWJVY3dyRXN1SUtCOXlDa3dJRDhoOG1nUVpS?=
 =?utf-8?B?aHF3M2JBQktGRWpFREtNSENOaUl1NmxjcGVWNStoOU81N3g0Z1JWWEJOYWZI?=
 =?utf-8?B?UlVRbHZackhkNUxYMHF2TlhvTTFXcVlFOEsxaTMvTFkvSUdyZzRaU3Q3Umhw?=
 =?utf-8?B?byt2MHI1ZHcwb3pZYUY5WWRFRHZGQmdNb2Zvd3dCVThBNGVmR1hjRUJncTFy?=
 =?utf-8?B?VHdmV2Q3bU9SdEJlVXVKVWQzYXYzMlZlUm4xNE1LS1RGWmFIeHgxYUFWVDRq?=
 =?utf-8?Q?n6p0pZ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkR3TllyZytURFBOVVJyQnFSdE9sWGRjNy8yMlhYZnk1Qm8vSzgwdDdUbFRq?=
 =?utf-8?B?eW5yMURGdHBjZGZNY1kyb2ZaTmVpa1ZGem0wcWNQdnc5Z2drUnRVd2FLM3d5?=
 =?utf-8?B?cFZqOEhtMHNGeUJ0QUNlOWxDWUcxMHRNQUxGbEw1Tk16TVQ5MkttdmRBNlVi?=
 =?utf-8?B?Vm1VeDJ4UVJGR1MrZUNETWE4a2xaT09IMGhKQ2lrZzNKQlJkdVZnV3hUZHdz?=
 =?utf-8?B?VFNYZ0VRTGhWY2xSOXdmSnNtWHVYYVpyV2FNYnBmMmM4RWIyS0FaaXVXVm5i?=
 =?utf-8?B?VWpxdmpUUWNoaFBkYXJabldQM01GeldMc3plV1VLRVdlY3IxMEJJRHV3TDN2?=
 =?utf-8?B?REJTSzcrK1F4Y3Z4TUVNRUdwZkhQZS9SUGdsRnk5b3Z5Nk1HdTI5TTRJZThV?=
 =?utf-8?B?QkZyU0FTUk9RY0dUWHFkWWRNRjhOUzZYbllvMWpheWVxTGdPSlpMV0JkRFNI?=
 =?utf-8?B?VkxrakIvQkdNNCswaWU4cFIxNStVNFJYZzFnbFFacm81UkxXWFp0R0hXY2Yx?=
 =?utf-8?B?dVpJdVJSL1M3Y0VuOW42eGliV0ljTWkzYnJ2RlhUSy9GR2s4ck9HbkZvZGZx?=
 =?utf-8?B?T290VkgxNWlJSEFJejZib2lmRnptcU1wLytRcVoxV01zSmVaM0VjWDFFQ2hy?=
 =?utf-8?B?Z2JqMmJUdFU0VmdsRVUrUm1zbTdlenR0VlhDaUZXaHBMdG02Q2Rnc1ovVURJ?=
 =?utf-8?B?MUVkakFabE9FN1lNT2lreHRWY0VZeWU0dWJkdzBGYTFCYkNuelYyNDdRZUh2?=
 =?utf-8?B?Qm5OQUxHNG9yWG5LT2taUlpNOGtOUm5FaDBVd3lLbklGV2dON2pGV1pCM2R6?=
 =?utf-8?B?RWlvd3ZUNTI4M0xaKy8xcllXNVN2dkpRQVlMZ2JSbkxwRkhPQjNUVnBDSEVH?=
 =?utf-8?B?eTVhMzdFbEY2eThxTStwdW5xSWJDcGZZWjZwVWo2eEpWRTBTSjFjT3htdTAv?=
 =?utf-8?B?Z2RNREpzVFNoT1FQaXN0ejVEdTlLQ05aQW9ienlHVVFKZkUwa2RrTkNzZ0tz?=
 =?utf-8?B?cnBkcnN1RFF4OEtMQ1QrQWU5NFVOVDVqcVl6OVpFOE5TWU1DS3ZXRTI0YXQv?=
 =?utf-8?B?ZzhlbUNKa2FrNW4xeTJjdE9SVlovMEF3YU1OVWFoUE1zRWZ6Z1hPUDVmNyt0?=
 =?utf-8?B?cWNhQnlNNHFlNVlMMzlWZ0NNbytiKzlZZHRJdGw5SUdHWkVZdm15M2NGbkZl?=
 =?utf-8?B?b1dqdUtzVWVreGNtL3hvVnhXSjFUUzNlYmVReDdMdjA2cWd4UzZEMlN6cDBU?=
 =?utf-8?B?WFlsN3pVdHY2azQwaG5oeG80TGt1a043Uk5kODZ0WTM2UDZRSEFGR0hOdTl0?=
 =?utf-8?B?Sjd5MmU2Um1BVlhOcXh5VW1yNzc1ZEFHeXlUcUFGcm1PQWdVdFlFaDFBZ0pa?=
 =?utf-8?B?RFFpS3phbXo4MFRZbXV4ZzZPTVFWYVg1TE9EQThWYzdTL2hrN1RoTzhGQnRV?=
 =?utf-8?B?TWNSb1pNMFV4eHh3YUpQZE9ZbEhLek1rdkhidnhNSjFCdGluWW5ZZ0V1OXlm?=
 =?utf-8?B?QW55c0xlNFlMUlgwQVVybzBiQjhyamtzNHdLeU5DOHJacmZxNTNUMGlRUXJh?=
 =?utf-8?B?dzlnNE1CUDNxVEFlT1JrVXFTSEc0L1dQbzladjRnUVo5ZStNUG4vMTB4WkRk?=
 =?utf-8?B?TUxldjZwOWZQdE1hZy85WWRKVGVpTnpsS2pCSEN6KzVRU0ZNeXVJd0RTOCtY?=
 =?utf-8?B?SVpvcy9id1AvSkYva0dweC9VK0E2MTI2OE4xc3ZjM2p0MWRLbU9OK2hDNFhO?=
 =?utf-8?B?SzZ0OVl4RzNtVDZnNnlQVDhkdU9LRHAxajg4UWNsbWU1d1lyUzJsQXdFYmxp?=
 =?utf-8?B?Kzh2b1I3S0V6SnE1b0txWE56VVdGbDhMRTlDVUpZc2JSb05SZzVCWGVMaHJR?=
 =?utf-8?B?bU1HMmhXaUt2TXh1VEtUYUM0SDRPdHRQMXFFQXNsOEg0OWU2bFZhV25ycmVq?=
 =?utf-8?B?dHRJYUk4UFdMWnROZXRvODNxZXgwWHcxOW9yZHJNeTdDRFl1M1hORUtQYmMv?=
 =?utf-8?B?VFpscnFLdEJ2WWJhZWpzNS8zYTR6R2x3NktGNENvVXNiWWpQWkJzS0NsRWRL?=
 =?utf-8?B?UnJwZGVVQ01HR29HTHFaU1BpdkVKak40bi8yWm9ScmFMZ0JDenRHTFZvZFk4?=
 =?utf-8?B?NUhycFBRcWZLTHd5QVZNOUEveUw0ZERMbm93QXNENjYwdFF1MHNpUHhFMUZP?=
 =?utf-8?B?Umc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BFAFDD1D1C06D4991391C4F2D942BE3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 273e2cbc-432b-49df-f29a-08de0d572610
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2025 08:28:28.4688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 445vy0AJuiuR/SFD0G+/4OV7eFM33aXN7Y9rA8Gc+Y//5AYEAfDC8YNK/JEfURcbqztXTORsDmCpftQlcVfdpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6847

T24gVHVlLCAyMDI1LTEwLTE0IGF0IDEzOjAwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFJlbW92ZSB0aGUgVUZTX0RFVl9DT01QIGNvbnN0YW50IGJlY2F1c2UgaXQgaXMgbm90IHVz
ZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNt
Lm9yZz4NCg0KUmV2aWV3ZWQtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29t
Pg0K
