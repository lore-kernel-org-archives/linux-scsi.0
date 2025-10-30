Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16441E2858
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 06:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761806353; cv=fail; b=M+Nktwom9VzRRHg1ZRhL/2Bf4HYQL00AKHbnegrj9N0gyybutQm4wFs/NzVWiy3v+QoW/bCf/lFKyZz+ekr9bykr0XVFh1RDaSy9QSVfm25wzfKZqa02DgDEAVqZNUnaDTA/Z/nE6OlSM/OmGRgozR6kkGmiTJQY7nBy7+dJh8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761806353; c=relaxed/simple;
	bh=yTuMD7ETTYhkhvn0hsGptWDXE+TriS3i8PYrIPGfy3g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iuzYZHgf3cUcnk5wvhxw/vGwe4OQJQKDOYxUb6UB0woDDhdAZ4qLCar1jhpDcXuXCgSEmOLgDccMu8FVQLp5TBlZT461z7dtVqfBhaFnQ7RJZgUfjma34uD3M+ESXMlewOpihX4qLSc8d0W4dt1oQM6KTvnsrpDgwoMzM+kKoso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=QM+l4tzi; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=RJovZSSE; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QM+l4tzi";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="RJovZSSE"
X-UUID: 20632ab8b55b11f0b33aeb1e7f16c2b6-20251030
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=yTuMD7ETTYhkhvn0hsGptWDXE+TriS3i8PYrIPGfy3g=;
	b=QM+l4tzicWUWohRn6MQSZpcAlwivQHw4Hfabdbuh+GqUw7njADIbbrggs2W58OO39IE3LFRI3vIHmMfipqAKtA9k4MIZhvStteSKKzAKDJBzJqllksgWrzmy92Q+JEQiwfX/Rg/Qb7YFUhFzBQ8E9/RTbVXNAXRn9d1CbIriYS0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:15cdaf92-69d1-454f-8daf-ff87951e1105,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:f5ea6a26-cfd6-4a1d-a1a8-72ac3fdb69c4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 20632ab8b55b11f0b33aeb1e7f16c2b6-20251030
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 635891657; Thu, 30 Oct 2025 14:39:03 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 30 Oct 2025 14:39:02 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Thu, 30 Oct 2025 14:39:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cVrGhmT9uQjyg9pJYbcXK8SssizQ3LseXbPJvSvK2cfGS5GUyZR0WvDUIUYCqIFf9bWzWiIVAY2fkFd74gofEs0VZSKpu2RmFgIUUXm1Fd+WDmSewUAOZCnx4kih/fouwWatSWKketxN4N5owCTpzfIeyW2Qdj8ajJNyj2+OdpA4ohLM36CZ3JYWIZVag27A7VKWC+51u0xyEFXmi72Vyd+GktpsJS9Wv811xCVYRSHCmuCqftOjG3w+Ishz2HdBWjsuyFqCtS4/A/0gP93WpMjC38RoPla+0eDLVVJsHkjHOQF8N4A30w0Z1qNRmeZwMITrBKxQG2PlDlTnb7AfsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTuMD7ETTYhkhvn0hsGptWDXE+TriS3i8PYrIPGfy3g=;
 b=X+MPTYwsqbeksKu1lWXCXih4ZDYpwUGBn40r7a+y6wxhJ15BhniWPkn7QvS24YPfwFkahwSWZIa1Ua+ErMXoXno/bHHrYcpKrHh2geYV4Ioy0130pd1EKqNOLvi+V0VZdAmwwZ12YgYMHbhEGOQ1xDaroHEEyCsjtH2qn+GorNnokKsqtun0AyK/LMJJbFnvUi/c1y3KQJdiAJ2PiSApSLdMLEkrDKm4HmqT07jZJDu638Iux8OPHmXDxxScog9kB4oF9hkdqOT/gUSe1tI5NuE2pHwYkOae+YZ0MFMo6JjSiMWMYjtCxMwkIAwnjQ0H2ajT2h6yxIptbiu+7Zoqvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTuMD7ETTYhkhvn0hsGptWDXE+TriS3i8PYrIPGfy3g=;
 b=RJovZSSEm5s6x6ad4LaUOMCdjmGs2Iwo1nNxb0tLOiSAI/NYYSrnJSffnCqDGQt4zmI834joq7IN2ChqunRzELjue5+8slUmEYaMANDr0h143JKAr8TPwGVNoQWQHMw3pxzJh9bVpoPCIDddOkNDitKFN0xEiWU1G5qj45EYHqA=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by PUZPR03MB7160.apcprd03.prod.outlook.com (2603:1096:301:118::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Thu, 30 Oct
 2025 06:38:59 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 06:38:59 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "chenyuan0y@gmail.com" <chenyuan0y@gmail.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>, "ping.gao@samsung.com"
	<ping.gao@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "mani@kernel.org" <mani@kernel.org>
Subject: Re: [PATCH] ufs: core: Fix the UFSHCD_QUIRK_MCQ_BROKEN_RTC
 implementation
Thread-Topic: [PATCH] ufs: core: Fix the UFSHCD_QUIRK_MCQ_BROKEN_RTC
 implementation
Thread-Index: AQHcR1i8Z6TpPPMGpUqmiLsOvKkoHbTXiHOAgAALWQCAASYDgIAAjvcAgAD4RQA=
Date: Thu, 30 Oct 2025 06:38:59 +0000
Message-ID: <c1c7b449924dd0eaf8179cf8a3e5b9983fffc0ec.camel@mediatek.com>
References: <20251027154437.2394817-1-bvanassche@acm.org>
	 <dae8ac46abd89f4d48e649cee0a6b301504bcdac.camel@mediatek.com>
	 <37a7d14c-5e6f-4fb4-a850-af3ca322ae99@acm.org>
	 <7d955a693d11424d527fcdaf4f05ffd792e1edfa.camel@mediatek.com>
	 <1674d018-9243-4fd5-83d1-26783165e3e6@acm.org>
In-Reply-To: <1674d018-9243-4fd5-83d1-26783165e3e6@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|PUZPR03MB7160:EE_
x-ms-office365-filtering-correlation-id: c2d80afb-4b5f-43f7-3035-08de177f0206
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZW5BQUY5NlAwOFlUTmxGTG9Yc1Fub2xzakViWmd5N092TkFyNmM5cWFyNGZj?=
 =?utf-8?B?ZEI5MkVjcUJHWGhJZlBwRXM5bDFGNnFjR0lhcndCTlczSWNPSC83ZXlDUDJR?=
 =?utf-8?B?ODdDbFcvYjRRV3dHbGkyeTZEUXAvUHZPTFBxWUlaVk1qQmN2eDNqYW9hczRz?=
 =?utf-8?B?WTJramJUQjR4dnFjWGpNV3Jmb1g3WXZHMGxKdjhCcFo0TitBQkpsNzdvRWk3?=
 =?utf-8?B?RUVmdjBvUnRkYlI0RzE1OUJ5Wk1wZGlSM2FKUmhnR1ZFNjUwSytaWFpvRlN0?=
 =?utf-8?B?NDBWcFgvSGozZ21uWTNEbHFSVVN0T2NPMHBUeHlmckRkN1FNaDBHMXNrM3Fm?=
 =?utf-8?B?NUVUOUgwZ29xZ2pqb3ovdUNmMklobzFPd0tkdVJISmZJSjZLMEN6d2NmT3NW?=
 =?utf-8?B?YldjSEJMaHpubEVPbG5ueTQ1SXBkT1N3cExlTE9aSGFWN1JrdjhySy9DN2ta?=
 =?utf-8?B?aUtBTjE4dm9aUjJlcnFKVUpUb1dNQkFMdXBlUE5mcWxGMnhnTm8wQjhyTDFZ?=
 =?utf-8?B?cnJyV3o0eGo4aWt0NWdvV3VGcFZ2eWtXMThXSUVpemZhTWtsNm9hQUhKa1dM?=
 =?utf-8?B?SnNpMHAvV1FVbGo5QnF4UXN6WGNiWGpSZUw1RkpRMi93TlpTbEx1Yi9Mc1VT?=
 =?utf-8?B?NmFlbEMrVjN0WXBSQWxZU2dsNysyQW56dHNxOVJsYkZlbS9DSi83UWI2eUVE?=
 =?utf-8?B?d0toSklZUEozQTBjRHRBSU12M3VCM0V5cWd0RGdpaVNZWW1OOXZ3eGg4bFRD?=
 =?utf-8?B?YVB2dzNEZ1l0MU42OXU0WmpsRTdGbFBWMEhjTEhYOEhXUEd4Q3VhZ1dybVdX?=
 =?utf-8?B?S3REVmxQa1g0cytJV1gyQW02TnNJSGMzMGhxQm4yMUtQT3Z3MndQWWduWDh1?=
 =?utf-8?B?cG1IWGxWTVBlY1RGWjFwS2RpYTBuNkpBWDlmUTRlandjanpySEY2em5KZWl3?=
 =?utf-8?B?elN0Q29iTmNhTW1xZ3lUZFl5UEhraXloTWlKeGJOQm8ycGdIVUp3ZVdUbktm?=
 =?utf-8?B?TEc5RXA2N3d2WmRBdmZtOVJ6Q292RTQ3Y0RuekpmQ2dQeFE4NlBJb0lzc0lH?=
 =?utf-8?B?dmxoY25lYzhVYU5WWVQxdVlGWEswSFFBU1FwT0pERHZYS29TTlU2d21TWXNN?=
 =?utf-8?B?ZGcxT0tFVDI0WXFjMjI2K1dRaXN2NlZOOFF1dThrREtDTHBmR2dnWXNSOTdS?=
 =?utf-8?B?VkNQbTJXU1d6cmhKRmM4OXZobzBDNysrNEhjVjc3VkxLR3pGYUxzL3laS0t4?=
 =?utf-8?B?NlVnWjhiYjVGcnVJTzgyU1pNR3J4aTdCYmxJVC8xaitSZ1BVNk9rL0ozMXZE?=
 =?utf-8?B?MDZCRGd1bVIrd1ZhaFIzV3hyWWxvZHNkNVZsbjcwQ0dzWC9pQmdkcEttWUpT?=
 =?utf-8?B?ZFVBeVJJZUFuSmk5aHNsR3hSaHRidzc5WVJ5SHNYcHM5VVBQWFhVZnN6Nmti?=
 =?utf-8?B?ZmRzUkRlbDEyRk9KVUdpU203ZFBtNDRtU3VBUGJFNFUrWHMxMkc2SEQybXdm?=
 =?utf-8?B?cC9IOE03UWE2c3VhditLZzZRTGoxb3g1QnRqRW0yVys3eDcvQ2RPL1h4RjhZ?=
 =?utf-8?B?QTB3SXhmQjA0c05FYUZ1SjRKSEdxNDJUd004aThWU1drdmpCcjFvU2pzeGJ3?=
 =?utf-8?B?U1pvNWdIbHBBMGhEVWtJTGc3RVozc3NPZGtQWWtBTnBMMUtGcHdwUkw0RDFy?=
 =?utf-8?B?NEdmNzg4Qld1U2xjYW9QaCt3UkFBUktBYU1zVkk2QW5CRmFwZ1I1VFFaRnQ5?=
 =?utf-8?B?b01oTWw5MmZOTEdESzZEeTc2bDVIbFdJSnFmL1lPeVhoSGxDaDBsQU1jQ0ts?=
 =?utf-8?B?WWxVWFdMNWpOY3ZIZGhQeE9MMXB1dXV0Q1ViVWswUVZMT0E1UFBMeWtna3hU?=
 =?utf-8?B?Wmx3RE5sWEN2bmVyYlZBNW11b1FkYm1TWEZnQnZ4YjNCWDM1am5KUHJQYllF?=
 =?utf-8?B?QjU1K05qVVRnOHVxbFpMNlp0R0sveHB6V2QyM0tsMVFDeG94dzM4bDA0OTlI?=
 =?utf-8?B?SVVOMzVLZWJjQUw3NVJiQ1FBMVJIVkdjVUlobk5iWUptK1JXUUtGelZaS25X?=
 =?utf-8?Q?7CtbDj?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXBZczZkVndCeHRieEt3TURSWHZtQlVRYTlvRmNLK2s1WXk2OThXOGZWdU1B?=
 =?utf-8?B?Y0RubjNOS0FtRnJTaklVNi9ZdmZYNEQ3bFJ6SWpuSFZaUGlPOEN1dFYwQ1Vt?=
 =?utf-8?B?eWVaeWFNcGtJZllONlFmcjNhOVpXR3hJa2diajByRE41eUN6TTdCMGpRbkRH?=
 =?utf-8?B?K0kwdXBnZThRMmVNbmFhdkFLUG9BcVBNbzI3Y0xJNTVaMlVMb3phS0FnazYr?=
 =?utf-8?B?dUJJc0ZvYjhySzg2L1VRRVBSMW8rb1h2OXRPZXJOR0MzRnhyOUJ4Q0sybytN?=
 =?utf-8?B?YlFoamRYemJsSFl1NUJVcWRDZW85eXBTM1cyNm82dFdDMzhnSmw2b25Od3ZT?=
 =?utf-8?B?NVQxbTZFRjBkdUxzYlEyVFNQQVcyeFB5N3dNQldOY2IrWUhJc05Ia3J6enRo?=
 =?utf-8?B?NHhnR1hjbld1RWFCS20vaFNKM3Q5SU1VOTg2ZFB1MUxXNkNPckZMNGQzdnNL?=
 =?utf-8?B?UlNSNXBSaTlWZ3JhRmNidmdwMk1DN3lXYWU4V3Fna29PWVRaWlB6SXFjdTVO?=
 =?utf-8?B?Q0FqSUs4M01QSTIrY21FWWJ2SytRbENZQnU4eTI1Yy9WVHpRTFNaaXN4RTNM?=
 =?utf-8?B?bVdkWlBqalpoaWVyU2FRaHpZMElqOFVNQmc4S1BYNnhhRGMvNTJ3b2V1RURn?=
 =?utf-8?B?Zm5CNnBhTWY0cU5vUXNqV2ZsUjVYVUprNm9DMGxiTUg1Mjc0dHBnbmxJLytq?=
 =?utf-8?B?OVpHNDdXbjVGbWhQdGRSVDNDNGZWRi9YQ0lrcm1WNmRRSHVGMVBIa0hxbFJN?=
 =?utf-8?B?VjBBSFE1dzMxTStmTWVNbjN2VWNsRlhMenEwM1Fud2VlQk1Kd044d2ZKNmVF?=
 =?utf-8?B?cWJlaHhFc0EwdTZOOGxJTE94eTloL2dTczNzWndSU0dJcVB0eGhVUDlPL1Bz?=
 =?utf-8?B?ZmpBTy9objNweDMyU2JSZU5lWVpWc3JUUVVOTks5eWphcUVWMXVtRDFuVDZF?=
 =?utf-8?B?cis3ai8vWE1qbWdzSE0vdUJ1TkdmODJmV3d2dFNrTjYrRjhaVWlCTGpoRzhx?=
 =?utf-8?B?eGJNdVlNV2tQN1BuVVU3K0xQbGdWYmdORCtISkZ2SHUxeW1oZ2MzbnlBOWZu?=
 =?utf-8?B?cmJwZWVlWVNHQ0ZaQ0VudnNMRVh0R1JrazlaVE5FMUZHQmxYbmE4RXVaNXNq?=
 =?utf-8?B?N012TnZxaVJEbUJ6NTJ3WkhqUnl0d3hNZndwcG5VNUJ3cW9wVFdJbFM5bHMx?=
 =?utf-8?B?VmdZaWxGWTVtTVFqNVAvWUtwUG00blRTbjRDRXJhd2NwV2doUVZWaXJIdEll?=
 =?utf-8?B?eWlBano4Q3ZaYWcwbDhPUHg5MjNhRG5odVVKeE83c2lTeEY1bnZzdjBqL21y?=
 =?utf-8?B?K1BoaW8wS0ppbzJPZjdhVmhrc29hWHhzSTdVOFljZUdPelpaSlVvRGkyaitx?=
 =?utf-8?B?ZXZHbkRabG5VQ3RJeC9sRTZaNEQya2NjNHJGSGduTDk0YXdFRllsemk1bUtY?=
 =?utf-8?B?OXRxdmJIQ0V0S2EyUnJsTTk5ZE5MNlc5akVTeHRiMS9uUDZYZWVlM1k2Rngz?=
 =?utf-8?B?NURINTE5U2JrRGsydVJka1FCL05IT3h6S0RLUVNRTENzT2NJWEl5ckF3eWN2?=
 =?utf-8?B?OVRvNEtQR1FCZ01DajhXbmNuT1FEMFB3dTdkY3daWUJiUVlHaFJuc0MyWDVv?=
 =?utf-8?B?RUlKQnk1MnZtdXl1YUVDSUVCYU1GVTZBQ2lCTjFmOGQ0Z2hqVmt0QVphc3hz?=
 =?utf-8?B?SmwzL3lNSUIwelhaMUZTaXpYWWRDRDhLM29tZXkraHJQeVpUc01tbGhrbWRs?=
 =?utf-8?B?allKSTBqODNsZ1oyNURHYnNXRi83R05NTjBKVGRkamxZZDRIMGlxekE4TTdX?=
 =?utf-8?B?ancwTFhoL3U5c3hBNExUSzlYaE1MUGtKVjNxVnQ2U3hGcXd2L1JCSEpKb1RQ?=
 =?utf-8?B?aU92VnhPK0dMM3dGZFphZzl6R1BHRjEwYVNWRzZsSzRHZ056V29BbTJqTUJk?=
 =?utf-8?B?RTRyaEFvYmR3WE9YZ3I4aEdtTnVveFpaSkM1WlVOSzhFN0Q0aGxQdzFrWmw2?=
 =?utf-8?B?T01pekphYjBhT1p0ZmZMNXlsaGRJUEY1dVBIS2YzREJueW9XZVA4dVozRzky?=
 =?utf-8?B?VFZKeUNmL0ZyK01QOW5yYmpnMmpkdFpia002Nm04ZzltZjVaUU1nc1JzRjh1?=
 =?utf-8?B?TWtUQlNmRW8wdk1TQWV0RURrYm1rVDJvOFBYSXhtZVE1VXlyRG1vZlp6dlg2?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DB2F95E285157449D041B5C7BE7B74B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d80afb-4b5f-43f7-3035-08de177f0206
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2025 06:38:59.5020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NFrix/DWRnAplnkrrEpPd8vZTucl8my7xepfhFw8wcsc/kIsMbb/5MXfKLcFnY0fUV+h37rz1XwKAKYqb6UjXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB7160

T24gV2VkLCAyMDI1LTEwLTI5IGF0IDA4OjUwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiANCj4gTm8uIHVmc2hjZF9tY3Ffc3FlX3NlYXJjaCgpIGlzIHR5cGljYWxseSBjYWxs
ZWQgYWZ0ZXIgYSB0aW1lb3V0IGhhcw0KPiBvY2N1cnJlZC4gQWZ0ZXIgYSB0aW1lb3V0IGhhcyBv
Y2N1cnJlZCBpdCBpcyB2ZXJ5IGxpa2VseSB0aGF0IGENCj4gY29tbWFuZA0KPiBpcyBubyBsb25n
ZXIgcHJlc2VudCBpbiB0aGUgc3VibWlzc2lvbiBxdWV1ZSBpdCB3YXMgc3VibWl0dGVkIHRvLg0K
PiBIZW5jZSwNCj4gdGhlIHR5cGljYWwgY2FzZSBpcyB0aGF0IHVmc2hjZF9tY3Ffc3FlX3NlYXJj
aCgpIHdpbGwgbm90IGZpbmQgdGhlDQo+IGNvbW1hbmQgYW5kIGhlbmNlIHRoYXQgbXkgcGF0Y2gg
d2lsbCBjaGFuZ2UgdGhlIHJldHVybiB2YWx1ZSBmcm9tDQo+IC1FVElNRURPVVQgaW50byAwLg0K
PiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFydCwNCg0KSXTigJlzIHBvc3NpYmxl
IHRoYXQgeW91IG1pc3VuZGVyc3Rvb2QgbXkgcG9pbnQuDQp1ZnNoY2RfbWNxX3NxZV9zZWFyY2gg
d2lsbCBhbHdhc3kgcmV0dXJuIHRydWUgaWYNClVGU0hDRF9RVUlSS19NQ1FfQlJPS0VOX1JUQyBm
bGFnIGlzIHNldCBieSBiZWxvdyBmbG93Lg0KDQpzdGF0aWMgYm9vbCB1ZnNoY2RfbWNxX3NxZV9z
ZWFyY2goLi4uKQ0Kew0KCS4uLg0KCWlmIChoYmEtPnF1aXJrcyAmIFVGU0hDRF9RVUlSS19NQ1Ff
QlJPS0VOX1JUQykNCgkJcmV0dXJuIHRydWU7DQoJLi4uDQp9DQoNCkhlbmNlLCB0aGUgY29kZSBi
ZWxvdyB3aWxsIGFsd2F5cyByZXR1cm4gLUVUSU1FRE9VVC4NCg0KaWYgKGhiYS0+cXVpcmtzICYg
VUZTSENEX1FVSVJLX01DUV9CUk9LRU5fUlRDKQ0KCXJldHVybiB1ZnNoY2RfbWNxX3NxZV9zZWFy
Y2goaGJhLCBod3EsIHRhc2tfdGFnKSA/IC1FVElNRURPVVQNCjogMDsNCg0KDQpUaGFua3MuDQpQ
ZXRlcg0KDQo=
