Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A11F3C00B5
	for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2026 07:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768980135; cv=fail; b=P9BoiJLsNwLrA2Ld+yuWvyqD9RkLGRc6ahe5voQ1E+r2i+p8Pz82TWnruEg1YTw80PwPfk2yuN60kfe0MTvsEgqljXzL2KYxETAWFmJeC1tnsnlHZwAvwPSd/HjcfKgAZkSptXBlwJ2zRYYE8kFOt9jQRyCsQoXg7qhCE6cAXaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768980135; c=relaxed/simple;
	bh=SDvSR07+4faswhwuP4AwASpRQE0yqp2jH1dlB5PACbY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=epJ4FA9RePtLgosuKxA6xT3M1l9hfDQ5uhYKXZFbLA38SHhfZgkhgb2Q6St29xZnqNE6JW+RFKXEeL4IrQt165XEp6gregXCKkPP3tnRMmIZXB1wW443G7SEMm19z4gKTvtzUy+WN2rWAkvpvwSnzQSEDZVF5W0XVv0JpSo6q4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZJwaJZBD; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=RD8Rq0Tq; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZJwaJZBD";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="RD8Rq0Tq"
X-UUID: df098352f69911f085319dbc3099e8fb-20260121
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=SDvSR07+4faswhwuP4AwASpRQE0yqp2jH1dlB5PACbY=;
	b=ZJwaJZBDkUTzMYwRVB36KCLei04HIlc0UxSmVfE9Pe6css2ModPbatAZYMS5+w7i530pfUqIWpp+g0ieYHHtXNYu7l3qZRyQo8vhrkmUvofFo3Fdkqwsxl2wshf0co5HWHj4K3AeRU+QqnHbR+5s0c730IxE2TZ0iuMStTgqnlk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:bbceb515-b905-4534-9c48-9b2624627c86,IP:0,U
	RL:0,TC:0,Content:2,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:2
X-CID-META: VersionHash:89c9d04,CLOUDID:7c7d605a-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:4|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: df098352f69911f085319dbc3099e8fb-20260121
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1821786695; Wed, 21 Jan 2026 15:21:58 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 21 Jan 2026 15:21:56 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 21 Jan 2026 15:21:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I8nUL9soVFf0erouB5DX6Jk/b7NIj3kserKCSEr18B52vET43aWfQQPtP4Z5WQOWXg+PmOIPVRv5FwyGnzswZa3ze2IGOyFkc+l2VsT5kIHnV9q8Kj+h9md6EGSE6oteovv2ANYF23LyvSUTTMcOZBq64ri11nJWji0QWoNRt7MkA0sYZFTeZpTPag3zRly6gzGoRa1uouniWqzzy7d0WJTgqMDhpb1FO4EH77ZmYQD8rj1pIDYIURQJ0/qBRR2muT6Ctb9CecEr5o7a/ln6ejQN9ESooKopiBoDZN3osNX2kLYzXTs+l9oiE586e+r0AFstxzkGkt+GgIy3W/ys8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDvSR07+4faswhwuP4AwASpRQE0yqp2jH1dlB5PACbY=;
 b=meJGIOYYsT2eLIC1A7cfC89fdu+oSZ0bZ3z/GGDO0gJ7d/yUzuconNXtKJLCyT/gmSZlHPaL4ssM/NxT/c1AVVqMjNnSDya3fuLcXTLO3EjITeF0bjImbDLFvZ9n698LH6iDGRK1161D2/gfQDHJSC64MayziGieBi+EB2K+/9mzJyeJ9DVN5d/E6u3ea+CQnYmCcBGRalStl8c2b5srcJMCPKzsqX5p1hH2mQR2HQCkx247gczs35K52jC7A33frP6ZQueWqjWN6rK/iw7zR61so5hrV5M9aOJzyUBWZ8Zc1G+QN6vuRD417/N0sMq5Tn2F56Rmpsle0KQoF9nfpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDvSR07+4faswhwuP4AwASpRQE0yqp2jH1dlB5PACbY=;
 b=RD8Rq0TqvrfxMa52xpIY8rwPz5UJrvYbSbBXYPJm5bjbHkwsOwePZv6XCivFewffM+hF4mLXVDLrkN1Vf0YjVu96OjwyM9yQmNHCNpWz21Yu6X5F43ER5Ef99Vhe/Z9NA+UIsCZomQSrfUA2qF9yKCSv9T/ghWAVhgvaGnA4cuk=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYQPR03MB9484.apcprd03.prod.outlook.com (2603:1096:405:2fb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 07:21:54 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9520.011; Wed, 21 Jan 2026
 07:21:54 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "beanhuo@micron.com" <beanhuo@micron.com>, "vamshigajjela@google.com"
	<vamshigajjela@google.com>, "alok.a.tiwari@oracle.com"
	<alok.a.tiwari@oracle.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"chenyuan0y@gmail.com" <chenyuan0y@gmail.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "adrian.hunter@intel.com"
	<adrian.hunter@intel.com>, "ping.gao@samsung.com" <ping.gao@samsung.com>,
	"avri.altman@sandisk.com" <avri.altman@sandisk.com>, "mani@kernel.org"
	<mani@kernel.org>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ufs: core: Use a host-wide tagset in SDB mode
Thread-Topic: [PATCH] ufs: core: Use a host-wide tagset in SDB mode
Thread-Index: AQHchxMnto2FFYD7U0aTMA4KBGn6KbVcPxWA
Date: Wed, 21 Jan 2026 07:21:54 +0000
Message-ID: <a7db442bc069ffa32a3dfa5524eba0a2c6ffd28c.camel@mediatek.com>
References: <20260116180800.3085233-1-bvanassche@acm.org>
In-Reply-To: <20260116180800.3085233-1-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYQPR03MB9484:EE_
x-ms-office365-filtering-correlation-id: e84bb37e-c544-405a-39e5-08de58bdc0fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QVpSQTNXU3VldGNWSEs2SC93cTNXVE1wL2xTWVJsN2NQMFJIdWk1ekdKUkxB?=
 =?utf-8?B?UTFrTnVNWnlwOUpOaURRVUlBUTBEUlo0UUVRcGtzaW1XOXQzcEFrdnl5WlZy?=
 =?utf-8?B?eUYvZkVDclI2S0lTS09LVjNESUg2Uk9YU091MjJBTEpzamFGVEVKc0VQRWlX?=
 =?utf-8?B?UXhSbTdCcTIwUFdjb1g4RHFuNVpxQldRNiswcDRsMGc1Q212Q2xkTXgxTU56?=
 =?utf-8?B?RnRiYjR0ekdEYlpBVXFxOENLeE5DUUkrZVA1NlBTaEVBbzJaVk8xbmYzalhy?=
 =?utf-8?B?REsvVGdOelZzQ3NRZWlJT1FkMllMWWtEMy9jY01ObHRYaXBIb3hjWjFwRTJs?=
 =?utf-8?B?UEw0OGl5aVh0ZzlHMDVsQXM5VmNLK0RzZVlrVWc5b1M5dDd3bmNhU3U0L3Rn?=
 =?utf-8?B?bzFMeGFmS0VZbEhjSndRRCtIMDRudXJHTzB2dUJvQmJTbjJlOVBZNlFvQmll?=
 =?utf-8?B?VWRpNXR5ZEc1cFZzQlNuRFhKUVhBSlpyVUdKenRkZDRhblVGQ1FsN3E4Q01p?=
 =?utf-8?B?OUh0aVNObnBxWmpEakExUEVsaS9MZ2hzM2ZuTk5STUtzeE9nNDU4K2lra3Bl?=
 =?utf-8?B?QXVQelFuN1hNNmxOVVFuWG9yMGoxTXdSRm41blRkVE1LS1ZMbFJvZExwVnZN?=
 =?utf-8?B?WDcwMEJYL1BJT21xWGROdkJNN3doRy96U0Q4TTFlQ0NMSHJqWUlmR3IrRTF4?=
 =?utf-8?B?Q0twaVNXUzAzWThuM2lnbGhqSHhwWnN1bFdBQ3pPVW9ndWR4QjlZVWtUTlJ4?=
 =?utf-8?B?NEJMRG4rcjRhOWZVNWR0amdhUzQrSFFLUzZiSFlBbHczZlJxRndYQUFIM1lq?=
 =?utf-8?B?YXVxdFk4c3RSRURkSzByeFhRMTlVZCtuTEs4SWVOQkVCNkpac2drMmIvRGpR?=
 =?utf-8?B?TEQ3bEFCTVkrRDZzUDhCbGdRcVovU2JvWFlyODBMT011cHZzcXB3OG5hY2wr?=
 =?utf-8?B?ck93NDdmdzB2YS9pZVZMa3Z4Zk5GL25zN0tYWVk3S2tFZFozZVVKdlBTdGE0?=
 =?utf-8?B?MUFabWE3SEx2Kyt4MzlwQUExZWRzK1l5WnI2OUhRZnFpbllCNFpNbnQ4cjNR?=
 =?utf-8?B?Q1ZjcGZNOUNXKzRWeE11azlLRmQyeHhySUU3cnJkV1NRUHVrcTRINjBtVHJB?=
 =?utf-8?B?bkF0VHNxUHZFaldNS3hPbWZRSzRhQzZYQndiQmEzM0dNWjB6eEVMZU1LZjdX?=
 =?utf-8?B?eHZnbHRFRmxxQVlHVElkaGx3OU9CWmU5MWc2YjZLS0N2OXEyY0pIN3ZBOXZN?=
 =?utf-8?B?WitwVDVwckRkY2RESFVnMzVxWlVRVlgxb1Awa0JTUGgvU0MzcDNrSVRYOEts?=
 =?utf-8?B?dGVsazZYTDBIL3I1S3Jmb0JHRlNBRUE4MzJBclFrbWh4L1lWaHVHNkgvMzJ3?=
 =?utf-8?B?dzRSUUtJRmVBdVZ3cWdIN1hzTFUwN2ViUEwyUXJFMFRHZGp4ZHFqNlA5bEoz?=
 =?utf-8?B?OXBOYk5Hd0VyZGdKOUdEbmxTR2wrSVpMRTRWZHBicDFlWVJkc21kR3hkQnlI?=
 =?utf-8?B?YUFBTkNwSzlCdDBqY0IxUDVuS2F3WDBHbG1DamFlcHkvemJTYk9pSXVVamxo?=
 =?utf-8?B?VDRmb0VpVnF0MUtORnJtQVZSSDRmbEczS0EvSXM1TFV0czY4NytFSE5PcHpo?=
 =?utf-8?B?Z3ozVlZBYUlDNzVsU05SYXFRMFplcWUrZnFvYXUyLzRmc2xyeDBLb2I5RUNM?=
 =?utf-8?B?RFZ2Kytxem0xL08rbUR5T3VFa3N5TlFBdDR6Qnc2MjNRZjNkYnptQzVtai9I?=
 =?utf-8?B?VnQ2cGRMSERVdjJhSXg5cVpuKzBGSDFWcGpyTEhJdTNYK2VjV0dPUW40bklH?=
 =?utf-8?B?eHJDU1ArdU5mNnhoc29jRUhFUnN4cUhiT2o1cmsxK1ViNHBGMG9EZjJhc3lK?=
 =?utf-8?B?NE5KTG4zNi9SWjJXTDhkendGWWFVMFlxOVFMNGVyZ0RYdzdwUmNKc01ZaDFi?=
 =?utf-8?B?aW4zY2lHSDhiSE1yLzJReGxzVEJxM0NOZkpReTViMUF1RjJLYXlZSU5BVGlH?=
 =?utf-8?B?OHNvM0JvbjdhY2dnRHlFOXpOMXZOYnhPQ2tGRlFjS0xXek9rZitLWUF0UjhQ?=
 =?utf-8?B?aUpsdVp0eUFMS1I5eGJKWmtHOXRzVGQramJ4K3VzczlGSEUxbndyaWoycUcw?=
 =?utf-8?B?VjRuSEVvZVp3UXp4alB2TG1ad3dSQzBNWVk2Qk5IUUN2SHdEcjlLbm9hVFZa?=
 =?utf-8?Q?ALuAfs8jf3eO9mRefVVn5No=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFlDVXBlSStMb0FMYS9RMVM2aWVNL1lyaTZSNDVpL1JNRTg3WVhTc01MOVF3?=
 =?utf-8?B?WkxQZE4rT3lGOWZsSG9WMWd6R0pUZ2E1Y0pGMU5MMGJpUXozOG1NTEJjVFZT?=
 =?utf-8?B?R0V6VEJySG9wNmNFRGNpMkxRa3Fick5kNGJrSG5rRVhDQjlCdi81dERGWUtm?=
 =?utf-8?B?dFFTTWJ6b043NXhiZ0tkbVAyWUNKQWhGVmNubHJSc05XQjV0QjlSL3hyV1RT?=
 =?utf-8?B?dU1jcU9aOVJnUTEwRTZvZGxvMGxKc0Q2TE04R01qVnc0OXROSm16UzRBSmRG?=
 =?utf-8?B?N2NxMUxuT3hMOHNXVlZkT1Fld1EzbGp1NzZSdkt2b1A3S2pmajFmTzNIdmIz?=
 =?utf-8?B?bmhrVHdVellsek5SME1GSXBzT1N0dlNmMnJqOEZIamhVTjM1WTNKOU9xcno3?=
 =?utf-8?B?aG1xV0ZlMVo5ekkrSlhscHJ6NG8wMHNiRXRRM0k4VUpQUmF0WHJzaFp6ejEy?=
 =?utf-8?B?YVNUMjBoK3hMV2FhQUhNcVkzc2NJMFN6aFZoaC9TeWhsZkNtRUNES1V4UFJv?=
 =?utf-8?B?SWRkM3haRG52RjFhb1R6N1FrUW5URnhDbU1jU0ZFUUFMeEdNR0V6R28ramFI?=
 =?utf-8?B?QnRTV1dPK2Q4Y0dCNDZEYm5jUjNVRVRRVmVNNFRaQllLWjBlQ1FUYUhtbUdz?=
 =?utf-8?B?bkFtTXZsUEtQeFJrdk9CNHlyYTRKMndSNDM0bElIcGJrVXRtZ2l4aWVMYlpo?=
 =?utf-8?B?S1VQeGxxTi95enVuandMOVMzeVZNcXBvVzRQRHQyT3pCaS90UzczL1pvY0pQ?=
 =?utf-8?B?VXE1WjlKcVloR0s4czRORE1iQmljY3VFd1NvakwxS3JITGdINHNnY1ltb3di?=
 =?utf-8?B?Y0FlMlB3M1k2UDFCaWV3WHRvV0hmU3QzNFl1eEY4QW5EeTYvYlZJQ0F3bTB0?=
 =?utf-8?B?bUlvaWlyNkRHZ0pYUlhKTXp4YlVLNUpjOURaSnhkRjc1VTM2dE50QXh2QTNP?=
 =?utf-8?B?TCt1eVRIVGNUNWxQeUE3ektqRVVqZ3FoSkViSXJQejgzY1B1S2p1K25SZUww?=
 =?utf-8?B?dmhudUFFb1VLNmZRR2g4eC92bkwyWWRZWmNQTFdDa3k5a2N1Y2ppRWJXTWF2?=
 =?utf-8?B?V0RsaUQvMVFjN2h3T2xNVktTQmRBdGZEQ1EyS1JzdEFhTWROOGlyOEF3WC9Y?=
 =?utf-8?B?UVFpY2wya3hoZnd6K2MzQitDb1o1a1c3akhxcmxkei9rV0drNWN5ZWJIWlVN?=
 =?utf-8?B?blM2SU1kNXBrdUFJN2trd2RvblZ5TEhnWU9DZ2FvWmI0NXVza2pxZ3l1cjA1?=
 =?utf-8?B?NG9VM2RxVnR1cHYrSmVGRTdDZ2JXNGo3ZW1oRW9jSVJ3R28xV24zYlRXODlh?=
 =?utf-8?B?WmFUcXMyeWw1Qld0MEVaRFhtbDh3RkRPRjRJdk1rQkY4ZzcyYnpyRTBtc2RJ?=
 =?utf-8?B?SU5JZEkvWDI1blNxcXdadVBZbWRUcTRMdDhVME5kc3doUjhaUkw0QUxkTXlz?=
 =?utf-8?B?MFd4amFkTUFMVVBVbTVRRVVTQytmeURaajIwZndackpIdXZCUHFpVUtjQUdF?=
 =?utf-8?B?eFB2dXhaNWpLa21manVzTzZ4SFhpKzgvYkxObGJlVVlCR3R1ZG5SNmFVNXFE?=
 =?utf-8?B?TWRWV1k0UkpsUklJOGRBdWVlcUhrY2VJNkRnazNYcUVaeVdIZHVtOTdxTWFj?=
 =?utf-8?B?N2RMbEpJemkxRUNzTzF1cUo2MGhsOXhJNXBCVE5NS1lNOUlTUFZrUHMrNWp2?=
 =?utf-8?B?MnNhM1Q0WjBidU1UZElmRE1HQ28xZlRDY3VQM2Z6aksxRDlUdjFFaG1rWjFY?=
 =?utf-8?B?OEFhTmt4TmExemVjbnBFam9lZ1JCdFl3L2VLQzVqdUdXUk8zS0hESHpHdG4w?=
 =?utf-8?B?R3hLck5TaFVKM0tJTWc3REl5NmFpUlRjTkYybzN6Y3JKaUZnUE9JeC9mOHZz?=
 =?utf-8?B?dk9MTUdwZkZ2bDRoVnlNVStGMjBBaFBlYktRS0wrdm5XbktTMDdOMGNTc2xO?=
 =?utf-8?B?bHM2NER4dWtQMmtyYjdGSUZ0S1lPYlJ1SFJJZnkzaDh6UWhpcFpLdTZqNHhh?=
 =?utf-8?B?Z01jYTFhdEtHQ1JVNlVCMkViZWFJQi96cm5LQmZ4QjNkd3RacU5COTl6YW5J?=
 =?utf-8?B?WGRrNDNTUzhOaWlhQVpIL1RCU3hZbTdOMENGeHVZeG5oaUdtV3dZOUM5WDJk?=
 =?utf-8?B?d3NHdmxETTJaVVNvSHNPdHpvYjdFSi9YcXFvMXhaL01Gc0dnM2Z6dThrVTNU?=
 =?utf-8?B?Z2RGT2hGTU1SdDI2OEU2dGR5YkxncWd1Q0hXZzNmQ1VrUnVUY1VVK1BLMkpG?=
 =?utf-8?B?NktmNUJYeFFwRlU0Qk9VRTZqdVBQV25wQXBEdHFGR3FGcnlTRURUc215Ylgz?=
 =?utf-8?B?UVRhamR3QTZXVEpXVlZWV1FXN3AxaUpKTlJWenplbFhKa1A4cUZ2bExUU3Yr?=
 =?utf-8?Q?xJDBNrXeNiptXBwc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF28A841E391214AA46F53FC61F2C652@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e84bb37e-c544-405a-39e5-08de58bdc0fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2026 07:21:54.2636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tievbmOCXGOB77EJxsK9lCbEstr/CKWj27k752pS6/oI3CFF/Z58qbenLD122oUoSaAAyugEuhCjs4JksYPSiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYQPR03MB9484
X-MTK: N

T24gRnJpLCAyMDI2LTAxLTE2IGF0IDEwOjA3IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
Cj4gSW4gc2luZ2xlLWRvb3JiZWxsIChTREIpIG1vZGUgdGhlcmUgaXMgb25seSBhIHNpbmdsZSBy
ZXF1ZXN0IHF1ZXVlLgo+IEhlbmNlLAo+IGl0IGRvZXNuJ3QgbWF0dGVyIHdoZXRoZXIgb3Igbm90
IHRoZSBTQ1NJIGhvc3QgdGFnc2V0IGlzIGNvbmZpZ3VyZWQKPiBhcwo+IGhvc3Qtd2lkZS4gQ29u
ZmlndXJlIHRoZSBob3N0IHRhZ3NldCBhcyBob3N0LXdpZGUgaW4gU0RCIG1vZGUgYmVjYXVzZQo+
IHRoaXMgZW5hYmxlcyBhIHNpbXBsaWZpY2F0aW9uIG9mIHRoZSBob3QgcGF0aC4KPiAKCkhpIEJh
cnQsCgpXb3VsZCB0aGlzIGFmZmVjdCB0aGUgcGVyZm9ybWFuY2Ugb2YgdGhlIFNEQiBtb2RlPwoK
Cj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMgYi9kcml2ZXJzL3Vm
cy9jb3JlL3Vmc2hjZC5jCj4gaW5kZXggMDU3Njc4ZjRjNTBhLi44ODlkYTE1YTYxZjAgMTAwNjQ0
Cj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYwo+ICsrKyBiL2RyaXZlcnMvdWZzL2Nv
cmUvdWZzaGNkLmMKPiBAQCAtOTMyMCw2ICs5MzIwLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBz
Y3NpX2hvc3RfdGVtcGxhdGUKPiB1ZnNoY2RfZHJpdmVyX3RlbXBsYXRlID0gewo+IMKgwqDCoMKg
wqDCoMKgIC5tYXhfc2VnbWVudF9zaXplwqDCoMKgwqDCoMKgID0gUFJEVF9EQVRBX0JZVEVfQ09V
TlRfTUFYLAo+IMKgwqDCoMKgwqDCoMKgIC5tYXhfc2VjdG9yc8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgPSBTWl8xTSAvIFNFQ1RPUl9TSVpFLAo+IMKgwqDCoMKgwqDCoMKgIC5tYXhfaG9zdF9ibG9j
a2VkwqDCoMKgwqDCoMKgID0gMSwKPiArwqDCoMKgwqDCoMKgIC5ob3N0X3RhZ3NldMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgPSB0cnVlLAoKU2hvdWxkIGJlID0gMT8KClRoYW5rcwpQZXRlcgoKPiDC
oMKgwqDCoMKgwqDCoCAudHJhY2tfcXVldWVfZGVwdGjCoMKgwqDCoMKgID0gMSwKPiDCoMKgwqDC
oMKgwqDCoCAuc2tpcF9zZXR0bGVfZGVsYXnCoMKgwqDCoMKgID0gMSwKPiDCoMKgwqDCoMKgwqDC
oCAuc2Rldl9ncm91cHPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgID0gdWZzaGNkX2RyaXZlcl9ncm91
cHMsCgo=
