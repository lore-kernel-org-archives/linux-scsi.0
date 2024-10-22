Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B270A139CE9
	for <linux-scsi@vger.kernel.org>; Tue, 22 Oct 2024 02:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729564633; cv=fail; b=fEVVwCet1ydMUmO3+lrQXt3ybXuoA1QlplOvfNxFOLP6+ms24Mi+dvYS+c2MRnc2qNlqctRapyzKPnLOT+UzIcrDKZ7weC5bRTBXiklDGm+KhhQE9nL+wuJOJaIE2cbeLTQ0eNUkyNlbweXeBRo5dewjLUvhC/QGCdL/VQjfjX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729564633; c=relaxed/simple;
	bh=U5iYDw1n+f5eAvYEyRx2ekpLKJJ+tyWjr4TcFtSw3I8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mH9tFgKGtkpfCyvJJjco+J40zlNtyjnEnAOBIFsvpaKCm9N2WqS+SsaHvlePl85qBP0e0b977RLlBIyFrCpDisw5Wu6GxT0yN7YcNLcH6Y0k75QR65Fzs2olCuZGTxqlU/sMeh0Lrx3+cadTFLN7oeEEHPp0NB378tSM4XdjS5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=An86X68l; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=dulEsgXN; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="An86X68l";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="dulEsgXN"
X-UUID: 848b1a7c901e11efbd192953cf12861f-20241022
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=U5iYDw1n+f5eAvYEyRx2ekpLKJJ+tyWjr4TcFtSw3I8=;
	b=An86X68lrdlaeQKraqm6q/pdVxbeVKJTmWXXYa/UASyAS35zq/MxytwDxCggZeutuAUJctTWyZyNCwP/Drz20GQk3v1I0qENTjuJrGZrURdSTA+wZ2e7PY+C4KfwkHyshIVSyFsAbNIye0QDR+PjKX7hWB/+1Ft1/6UFPX+eTh0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.42,REQID:6baeea29-5159-4c31-b204-f37652090b6a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0fcdc3,CLOUDID:cd3a9f41-8751-41b2-98dd-475503d45150,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 848b1a7c901e11efbd192953cf12861f-20241022
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 301318069; Tue, 22 Oct 2024 10:37:01 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 22 Oct 2024 10:37:00 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 22 Oct 2024 10:37:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UdZHcRdFxZDd9c1TT7fiGAv9wLCedgf7AFx/hOjyoYfuRCXbO5WKNwOmN7tYhBZZluoUVCRqQTAzvzRsu2d6mvcqxljTxlWXzVVsC+eS7mLea9ahPURziq5jiMLpGVE/CoK1ifuucY1GeWIHWMKuNAwFVk6UPIx4pOiwYBIkP3xpIsrqiCPREbM2A3dq3qOPpxy8AyruAvawzqnEAYEEbisxTG8o0hYXQvKXA0PoUbaLgPIHpDt19kir6m5TWQnfHcKcvVZ625yyJl+G+kuqIyD5El6YTv3BOA8Gyqo6SkBncMd0VWUn8O8cVy/aBzrkvNxrg47C0h6X3wNZ2GZepA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U5iYDw1n+f5eAvYEyRx2ekpLKJJ+tyWjr4TcFtSw3I8=;
 b=zCgM5OozOiLoLxpI1l0G+cI53Pp634KQ6dcOR8aNQ89tirb4RjFjtjcIPTnwd+xO/g4hCzV6ypR4/WhrVxw/jancBk27zmvHFj5AV95i0CRjNieJavDNdc6tI21W94kpQU6efWGDlaHN9N1jp0lkGbANPzammyFNI347QTWM1zFqplaXZKjbXVh44ZmjDTtcdyIbM2vb656U9pgSIO7yBNKS0WCh6ebXrvZw5WE8ynVY79iJS9uKFHjqDeuZzy0pueKawGqNdglHtEQ0biLdVpCI7qSBmZBG1oGex1cdCoCzlT2oXWt5PBEntQxmGsevVi4qpcJB5fdZ56J8epm52Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U5iYDw1n+f5eAvYEyRx2ekpLKJJ+tyWjr4TcFtSw3I8=;
 b=dulEsgXNkpudDC5XzS4mXaoK0acPF+TzNuTh4mxF5qwiUZrdVihBp5HlOBoe/3GO/uUr++mpAciuySN/EDoIU/Yhrf3bxmGo/LC1aFM8XShmmAmYN4dX61ejEeQznbyjDXgwdEow6S9tKyLItVMvNeEvNCF9HmyrsPN0bDNTofU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PUZPR03MB7209.apcprd03.prod.outlook.com (2603:1096:301:110::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.27; Tue, 22 Oct
 2024 02:36:58 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 02:36:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "Avri.Altman@wdc.com"
	<Avri.Altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 4/7] scsi: ufs: core: Fix ufshcd_exception_event_handler()
Thread-Topic: [PATCH 4/7] scsi: ufs: core: Fix
 ufshcd_exception_event_handler()
Thread-Index: AQHbIBAtyEdjQsJ5W02GNnoGUokUOrKMA0MAgAC7XwCAAAbCgIAAJFgAgAQFMgCAAPH8gIAANXmA
Date: Tue, 22 Oct 2024 02:36:57 +0000
Message-ID: <dbf4dedda38f346828538e20d8dd9ba80a453e56.camel@mediatek.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
	 <20241016211154.2425403-5-bvanassche@acm.org>
	 <DM6PR04MB6575DD9E354A70A9EA97E439FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
	 <608f86d5-0f27-4c88-a2b2-6504348f2f18@acm.org>
	 <DM6PR04MB6575010F498BC3F480EA198AFC402@DM6PR04MB6575.namprd04.prod.outlook.com>
	 <793f958f-353e-453a-b2eb-288853a38dc2@acm.org>
	 <efedf22012876b4a30f4cf71cf053d5e4bad9982.camel@mediatek.com>
	 <4693839e-b6cb-4926-81b4-2c40c1283f99@acm.org>
In-Reply-To: <4693839e-b6cb-4926-81b4-2c40c1283f99@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PUZPR03MB7209:EE_
x-ms-office365-filtering-correlation-id: 9b3f8ea2-1073-4a9c-68e8-08dcf2426655
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N1VLd2p0VzlWdnphcTRJU2xrVE1xcVBHUWFSek1nTXF3WDFyclliWGZZS2Qw?=
 =?utf-8?B?TStFTGdqTFRoRHhnSnVnaEdDZ0lTUzZ5ZG1jVlgybzI3cmkyWGFsWVhvWnpK?=
 =?utf-8?B?T2tleGZ6Y21WSHJmWThLYlkxV0RrOU9SN2FuSkU3MXhwcGVBTzdiSDNVSURQ?=
 =?utf-8?B?cy9ZZVpQc3JwNHhqenFJYlNtRkxNejJuMHdzS0tydHNveUh6ZlJMb0hCZ3ZN?=
 =?utf-8?B?WjdaOXlUQ1p6c1Y0c1BsQlNQdkIvaFhQMzl2dGlzZkR2V2RHMnhHaWltKzkr?=
 =?utf-8?B?YkYyanl6ZHdmRmNWakZaODBEYnJSM2dZeTJHVjYzR216Q3oyT21yOTR5MkRr?=
 =?utf-8?B?KzR5d3VLK1NhWHRKVWlkZG5TdkczYmlYR3pNcjEyQ1c5MmVVODJBSVBWcWYx?=
 =?utf-8?B?cFU0eFBuNlZsVVBoMXhJTm9ENmVCcDVvK1BoTVJoc25Cbm9POHQ3TVRoMXlP?=
 =?utf-8?B?OCtzaHl6cHNVQUduNGdKSEduWG8weDBWWk8xbUZHNlJLRzdaQ3JVclMzQ1d6?=
 =?utf-8?B?b2FDd2w1b2tLUzBNLytTLzgxbFRsYzZWVVZwNE5BOEdDQWxEa0VTOWNOSDFF?=
 =?utf-8?B?MTJKOWRLWWZFdUpTQTMwSyt1Z1JVUDY3QUFEOVp5ZnhIRFBoVlJ4dXVNU1Qv?=
 =?utf-8?B?L1dXQytNMzlreWtCZ0dhdUcwU3lzeG9lZzVNRTlaV3hYbi9NbHgwZk5sUGdS?=
 =?utf-8?B?OVB4cG9sZ016VExRVjEyVGx3bFB0T0RoaXR2dFBqamFpeXFzMGRpQmd2OGY5?=
 =?utf-8?B?SnByRUdqTWZHMS9ndkxHNXR4QmVFYS9XZm5XOVlXVzFuMWtrMWt2VjA5WExs?=
 =?utf-8?B?SnB5THFKRTF2MFVVUVJTS3ZqMkYzQnc2RTU1ZjZQcWFzZmQ3OFBrYzd4ZnRP?=
 =?utf-8?B?TmY4ZU5aTjJIUURQMkJsQjk0akxtUnZlcExNcGFBRy9XcnpPbzE3R0dBMHJt?=
 =?utf-8?B?OXNkSVgrWU8rK1hXQ0I2dXBXd3dZcWpLM3BtSVdwbUdVNURFSlNSQnJFdTRw?=
 =?utf-8?B?b2xjRjkvYXlLbGx0UWZKR1UyM2JHUEJJa1huWElSOVN4eEVIaGFHRTM1OUs0?=
 =?utf-8?B?RTRYZE4yeHBsOFZXWHdUdGNSOW92ckNlbmMrVkUxYld2ODRtQjBTSldQYURl?=
 =?utf-8?B?UWJUNFFGZzk2UDdoR0dzTzVtNXNralgwLzUzT0xGa1pMcUw1U0lOcHpBZDhm?=
 =?utf-8?B?K2dRcWdrZmFDdGd5R1lqKzN3ZWxPQ0UrOTkxSU5iZnNKaVZGYkpxb3NxcG9z?=
 =?utf-8?B?TVk2aWpSNGdPT01ycVNLczNCbHVydWE3dkptRDVTVnNsUEVVYUwxb2dKZ00r?=
 =?utf-8?B?bzlKQnFLdkpwQlJBL00rTkUwUG5adVRScnFSN3F2SHdLZENGbzRhS3p3UHlY?=
 =?utf-8?B?Z0Iwd2hTM2hOQmRPcWVxU3pvTUUydnExNElOeFJNd2dYYjhUMi8xYzhQZFY3?=
 =?utf-8?B?Y3Vyakt6YzROUDVONGttWG9jRVdRUWxyZmdYbVZDQ0MrMVFiVFhUdEhMa0Za?=
 =?utf-8?B?M1l4Tk5ubytudDNCeU1LRDdYUlI4Ykc5eUxTUVQ0dExoUk9TSlVsZTM5RlJ6?=
 =?utf-8?B?WVM1OUxwTjBxMTZWQ1dQbThSSWJ4ZXg5RVZ3QU1oSmFOUEYxZjUraS9iY2FL?=
 =?utf-8?B?TnR3L3Q0RmQwVW43eXRvekZVNTZWTWszZVFFeStobDZBTW45aVFoQTRGUkFr?=
 =?utf-8?B?UUVGWnZRSmQwQkxsU0pjMWEyQWtDbFBMME1DMjR1cTJ6M3FMMXcydjZMNWJS?=
 =?utf-8?B?QzNKRitkVzF6QzkzSHpQelAyTE50ZG1UVVBQWFRncEpobDhQOE5WREhFYXNJ?=
 =?utf-8?Q?B49YFSJLfRTCCI3gLoFp9oig2dSB8HSy0Fnnw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WG1VK2dJTEhlbHlybnFDZVRPdDdybFpZdy9KR0NMR254allEbGhyS1g1dVhs?=
 =?utf-8?B?NGk5OEdGc1k0RHdpdDZZd2cvQ1VZYVBoQTkwaVY1eUllTGF5MHRmVDBvS0lE?=
 =?utf-8?B?NG54aVhqSUhuU0hRN2c5dHBvSTh1VXNiWU1BaXZYZTN6N3M3dm5QckZPWVFn?=
 =?utf-8?B?VWtrcXptc3psRVFKbm5Dc09oVXlQbno3eVdiQ0dRNnVQNWNDcXVpb0Q2V3RM?=
 =?utf-8?B?a0lSR25PbEFuWTRVUnNMWDM4YXRTQmdzNFNEMGpuRGl0cTJWdUVQRjJkSDF0?=
 =?utf-8?B?SStGb0I3RENUQWlQblJxT3RFRHZGeEYzeWdoNno4OUhkR3haYkFRcVNFZVZC?=
 =?utf-8?B?dy9hQTRRS2t4dEphL2xlend0cGdoMkhyV04rSlhnci91U0IyQ0Fhc2ZBMnVB?=
 =?utf-8?B?NVYwRmFRSk05cTQxRUFBSktSblJuUVg5V2Z0cTdMTEk4YTNDZUFZWEJwUmJm?=
 =?utf-8?B?eWlieXV4NEJBZHhpdklwbTUraHlBdExwSVRDSk9paCtFLzVzZnNMaTdBd2RI?=
 =?utf-8?B?Y2p4aHBoS0V5NVR1Y0paa2l2VmJQK1ZNMDBncVlaYUV6THpiVCtmbThpY29z?=
 =?utf-8?B?QVk1cy9QMy9sUjFlQ2FTQVQ1SytyVnIxVEZ2OFlYUHV1aCtqZlpvT3ZFeU9a?=
 =?utf-8?B?bEVrUUE5Vjhxa0tLaWtsOTZCSDZLeFhkcUFUK3A0UTZ3eDJWUUcrRkd6MXZh?=
 =?utf-8?B?V1ZVYTRxVGdVTFEzY2lJSzM3bExvdnZBeG01bVhKZlBNa0wwTkhybTVrdXZQ?=
 =?utf-8?B?SWRzZjBZQW41OW8ybjBsMVVQRk1BZ0lUcm5pQ1BtendQMkphOVgrQjRHTU9x?=
 =?utf-8?B?eFowOE00U21yTHRWVWVXMHVWY0NUMVZGdVE1SWRiZW9IZ20zK3B4S2NOREdS?=
 =?utf-8?B?YW5RM1V2UU54bDdqVkFHVTRWWStKWlZQeVNvTmVGcXBJZzJrUmhONmdTdG5R?=
 =?utf-8?B?ODFiV3U2OG9jYmZ2M0x1RUw5SjNwVHBMUmRBcGVOOC9EbGlBb29mVWo2TXE4?=
 =?utf-8?B?dUIzb3Z4NEZBWWxkS0U0bHJFSGJxaWF2VkNLSFNnUkQxWk5VMTBwS1NZdFhq?=
 =?utf-8?B?V2ZuWXRSY053ZnVkNGVhRG42eFpTSWpLeEVYVzRTVElKOTlOWXQxRDdTVjEv?=
 =?utf-8?B?Q2lSaTBaMEp6dnljVU0yaE9RWnI0c0NvL0RnaXZBa3kwN2Jrb1M4MnRrcS9P?=
 =?utf-8?B?Qy9RN2hLazF2S1JQRjl0SGpyYzV1bzhPdkxtK3N5cVRmcFNIWDg2alVqWHNP?=
 =?utf-8?B?eTByYWhjbVF2MUs2VlpXV3lsNVR5UEUreFBpRWxRbStSTUVBMEtXRjdqUGg2?=
 =?utf-8?B?aXFvU2hIMko0QTFUSVVtazBNVCtUQTlqYXNLUG84RmViNUdWMTRlQWg3YU1C?=
 =?utf-8?B?VFlyZHpEU3BjRXA4eDR6L1d5RWFZZUVMTFYyV1FvSEhhTjJFbXFYYjVrNlNv?=
 =?utf-8?B?NDBuSTNZUWJCZ2hkWWorTWdESW10bVREdUtibk0zWHpSNG10dXBkTnIrY0tP?=
 =?utf-8?B?R3Z1eEhnZGZIbW01TW45bXBBZWFkL3R6TnQ4SUZud2hnZWVHdGp6YUxNMjVq?=
 =?utf-8?B?N1JobGVIQWFYbTdTd1FONWF6OERJTkw3aUVVRFhiN1JBcGVtOUdOVVNVVkpW?=
 =?utf-8?B?MDE0TnZhR2tPTHNqbUExSVpVbjZtbk9XKzRybFhHeEFBVkthRHV6TWJDWlpH?=
 =?utf-8?B?OG45eE1CMURhSHNJWnpuUFl2cjIwSEdXYlpoN2lEUklMSUhRMWRhZlQyZnc2?=
 =?utf-8?B?V3Uwbm5qK2o4enNyQTR6VnkyYlp5UExNYkZGTkVTbU5Cdnd5czNzdno2c3dW?=
 =?utf-8?B?alorbFVSQnZxSE1rZWxGRGlaYU9pcmJMVi9FMkdENGtNekFOQkRZSzJxTWVn?=
 =?utf-8?B?VTBueklvNU1SMVpGZHo2Z0J1T0Iydk04cWY3UEVzSjY2djJ4UmYxeWFvQ1cx?=
 =?utf-8?B?QjVLUXdWa2lMcmVQcVZFQ0d5QkpJM1hpWGFvMllUWFdKVERRVERPQnZRUS9x?=
 =?utf-8?B?UFhVMmVtLzd6amxYOGdHRlNYV1J1V2xSV2Ewd0x2R0ZnYytRSDZCYWtPNHBT?=
 =?utf-8?B?K0tnWGFhRGZoS1ErTTNrMzBKTTlYVHdUZkVRZ1JmWFlaTzZ6ZlZMSHhMN1ND?=
 =?utf-8?B?eWJHczJ5ZkdqVC9ueWt5WEs3ZXVMSDFoOVU2UGFBU2tMREZnYUVmQkhtRE5s?=
 =?utf-8?B?SWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBF5305B01504E4298C66822B2C227D9@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b3f8ea2-1073-4a9c-68e8-08dcf2426655
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2024 02:36:57.8376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aYkus1QK1nYiqR1ISBCTJYgXhTxbHxMxGTtQZjMnR6azB4bRj0wjaHEO+ylYDkidt3WipxZOpa7QDUiz2N2YrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB7209
X-MTK: N

T24gTW9uLCAyMDI0LTEwLTIxIGF0IDE2OjI1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMTAvMjEvMjQgMTo1OSBBTSwgUGV0ZXIgV2FuZyAo546L5L+h
5Y+LKSB3cm90ZToNCj4gPiBUaGlzIHBhdGNoIGxvb2tzIGdvb2QgdG8gbWUgYXMgd2VsbC4NCj4g
DQo+IERvZXMgdGhpcyBjb3VudCBhcyBhIFJldmlld2VkLWJ5Pw0KPiANCj4gVGhhbmtzLA0KPiAN
Cj4gQmFydC4NCj4gDQoNCkhpIEJhcnQsDQoNClllcywgSSBhbHNvIHRoaW5rIHRoYXQgYW4gZXh0
cmEgbG9vcCBzaG91bGRuJ3QgaGF2ZSB0b28gbXVjaCANCmltcGFjdC4gSXQncyBqdXN0IHRvIGVu
c3VyZSB0aGF0IHlvdSBoYXZlbid0IG92ZXJsb29rZWQgDQp0aGlzIGFzcGVjdCBvciB0aGF0IG90
aGVycyBtaWdodCBoYXZlIGRpZmZlcmVudCBvcGluaW9ucy4NCg0KUmV2aWV3ZWQtYnk6IFBldGVy
IFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KDQpUaGFua3MNClBldGVyDQo=
