Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6970F2749F2
	for <linux-scsi@vger.kernel.org>; Thu, 29 May 2025 09:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748511811; cv=fail; b=a40i9hpvPCgybgSW/z2q9vTR81nPMKPVqphU0f+S0BdOxAjyl25Ho5NqgtARr2outDi4o0o+aZ/I8jeGWhN5q1ZZQLpCp5W8prZipa8JBfMR0+EmjFiwHU1RykTFcdkO2kGIJvH5k51KaxA4pYIW30JvyJMubZGBQzYBIIUdjTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748511811; c=relaxed/simple;
	bh=UzYqQ9BX9JbuHWPaDwIQyv13Fo3NUAcvNU2YhLBkybo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LBJTkuvARaMcN5WMoeEwjdmD1e4oMU4K+dZGFbKsls0ZtGGajYNqboeCJt2diF+7QE9tV5BNQ2y3k0R5u516/if8VY0+s/nFdoWOf520JLB27ugU+f5mccxhVtLX7PlHBx0MVPGhoy91khEqBdjfs+LcbASAbE1v9pv0HlIvss4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=KahyLBh1; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=nWKvpX46; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KahyLBh1";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="nWKvpX46"
X-UUID: 5da37d783c7111f0813e4fe1310efc19-20250529
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=UzYqQ9BX9JbuHWPaDwIQyv13Fo3NUAcvNU2YhLBkybo=;
	b=KahyLBh1TWA0oyJuuOzIEV0T7F+og5l8DFuJds+Us0R3O4TuSXhOMAxsoGlokO2FEtySB3b3BtlPgcmzJ/RsoT/KeXtFgTGyMhrOAyLY5nmhMdzv/iYSlPGWPhtQyd2/I2nt58Zk7afKQQZv//GayuxWOI664UGZT7YLFbpth+g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:0c66135a-e308-424d-a3be-3f8c5def69e5,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:533a1c58-abad-4ac2-9923-3af0a8a9a079,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 5da37d783c7111f0813e4fe1310efc19-20250529
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1027876807; Thu, 29 May 2025 17:43:24 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 29 May 2025 17:43:21 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 29 May 2025 17:43:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uSx9EDtcxL82ZNg/WIeMm+twgCQpX2qBv7jbd2O8nX2jBR7im/Jy7XfZw4fjfv3Fz9WZ7e5p7T3p1cOoZoghIOQacjSqSqzrndGqpfzoDt0LQm4VsxzmahUov9H6NevcL1b8sfCuREiRpKBtUDZn5QShiGsEyrRlf7cy8VinvBaoFIL3T/nvy2N+reiyKMJ2ZTwR8Iiihd0PkJF5IgFkwVICIeffQVAC290MMqL0kJTulLKfVro4SbqGosrdRmo73W+ImpuIWuPQQLWTHhSMEh4+mkgYLEVmYSOx99LkKjOD8Zi4+gCBfZU7H+NpnvLrSI4DiaIEWOa24A4yIVkpvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UzYqQ9BX9JbuHWPaDwIQyv13Fo3NUAcvNU2YhLBkybo=;
 b=F1+bo0FFjv4sKPwWWP5y2ro2RTpaEt2D0zSN0GQ/PPx6szEkvVOiKpIap3qQ1NmO4qIwAxB/pnCfqwezFgIu4kDwxJFr3oiYNHGl9Bi4TNP4js3kKYvfsXANSwMwNZiktV9mQ4S7M3jA4yUbA43jWfrSPwnADP6biFWKWqE4Jp7Q3rYZjRf5IZj1uJ/GYc/bwXzIs4n094MPcZHdT87F/JOMXspLoUtME2x4LTlzX+qRwMCavG9G9wyGuoausStuNlTVJ2p692hrjuDQRF19+AmpyWU7NZFcBy/sLviGdCUx19C9UdKEI/AlIAG0LqUSaumnBJUbkOEnB1/FrI8Jmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UzYqQ9BX9JbuHWPaDwIQyv13Fo3NUAcvNU2YhLBkybo=;
 b=nWKvpX46MkOOSZizKWR2xl1/MgiGfR4NREpFNP9qZP5fkMo0k7AVzw6jYtyU4Tpef+DEguTkj+lWUoaksq7wQeJVYi35Z1EvEc8aTesz9Dy2RDA7eYa+qzvKNMHw3ITRPXdn7BPV6l97h8EHCt6o7b3ew+E/gpsx/qAobejueAo=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8053.apcprd03.prod.outlook.com (2603:1096:400:45a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.30; Thu, 29 May
 2025 09:43:19 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8769.025; Thu, 29 May 2025
 09:43:19 +0000
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
Thread-Index: AQHbzB9auVPXGDRIzkKd3VohNkQZa7Pk6deAgAIj2ACAALAsAIAAeFSAgAEtyAA=
Date: Thu, 29 May 2025 09:43:19 +0000
Message-ID: <03ccea47401a5754fffaae91c549857478545a36.camel@mediatek.com>
References: <20250523201409.1676055-1-bvanassche@acm.org>
	 <2ab0ae98fd101d893d4f20112771cdb623fbca67.camel@mediatek.com>
	 <ecfd1748-d257-48ae-808e-c672ac2f1536@acm.org>
	 <32f45a00d5c1cdf26f91bde4821fe73d5b06dadc.camel@mediatek.com>
	 <6d82c9dd-b93d-4400-9500-a850b1ba0bb7@acm.org>
In-Reply-To: <6d82c9dd-b93d-4400-9500-a850b1ba0bb7@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8053:EE_
x-ms-office365-filtering-correlation-id: d869c7db-028c-4537-48d5-08dd9e953e9c
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cExrcXNXWmdqbzhwY0xNZU9tOWYrUFd4K2RacTNpWlVxV3k3cE02cWlONFMr?=
 =?utf-8?B?Ti9peHdiMXQ0STcrQlNrRVkyOSt2MFpvTWlsK0Q5dW0wZkFJWlArbkxBNysw?=
 =?utf-8?B?ZVhnd3Y1WXJwM1RZOVAyeHRQeHhueWVOcHJ1dHQreDZkbHFHakV5Vm1pQTFm?=
 =?utf-8?B?MStoUTUzdW1lWitXbStYOW5pMkZlVFY1c2JwcVBoR3k4QWM0eU85ODhiN3VG?=
 =?utf-8?B?bDBCN293eC9uSitpRDMrOFlTM2dYVkZFUmpIaFJsaVE4OTg1VGoxUDBlNUV6?=
 =?utf-8?B?ZE5KdGVxRDdGTEpiSDQ0KzJiOFZjWWtQN0RTZW5aYTlmMXFXTkQyeEtySUZE?=
 =?utf-8?B?VFU1Ky9CcTR3bHpKUnducmhETlFhQ2FyK0xzSGo2Y3R5Ulhic3RlMlMvSkN2?=
 =?utf-8?B?T3pVWE9ISG8rMVZ6YXVheFhmWXEyT3ZidU1IMFVIbXd0cnY2ai9wU0tuTUp4?=
 =?utf-8?B?M1hYTkZJMGR2Ti85K2JWVnNmMFJYMFdZajI1aHJUOVhBV0puSzVvcmwvK3Jr?=
 =?utf-8?B?RGVnRlVuOTdKZiszV3NXWlFQMlh6aUZzVktXM1lCU2Z1Wnh6c3B0YVhmN2xR?=
 =?utf-8?B?SjdpYjV0SlNyYTZ6VWdqVEZsOUZ2eGU4VWtYK1A5L0hIV05yUWs3eWV4Ymt4?=
 =?utf-8?B?eW9POHdXTEY1bWszOXNTNG51TVV2MDhxb0dlRDBIbzlvajh2RG5henlwTmVM?=
 =?utf-8?B?Skp2WXFqdndsZ1lmbWIrTnNIZDRkM01HN0NFUFNPcjVMaXdYK2ZXK2YwYXc5?=
 =?utf-8?B?OXhxYlNJZFFmNnM4STRjYjRrdEdHYkluZHZmNVNiUXlnMkdpM1h0L2dnQTh3?=
 =?utf-8?B?NTFIOFNyL0laTVI1T1VZWkg0OG1VUkNuNlZ0MVFrd2dWL2RIQThpaHFPd2Jh?=
 =?utf-8?B?NGR6dnlwZ3pjUk4zZkNtS3ArQURLUVdNM3Joak5BWDVLZndWbFczWmZSeU10?=
 =?utf-8?B?UkF4VFVBajV5MVNFaXFPZTd0SDIzbE5YMW0ySzY2b2ZlcWpMREUrSEo3citJ?=
 =?utf-8?B?UTVSV0RBZnFqQzZnMWJjVXZYSnlYanY5OHZMM3hKYkZTZGJNdng5a1BTN3NU?=
 =?utf-8?B?a0R5MjU4M3VsbmZpS2VWMjJoOEJ2aXJKejRPZ2s1cFQrZy9SVHg5dVYvYUU2?=
 =?utf-8?B?N3R2TmFRMDRmVUh2b1ZNQjE2OHJPbEpsaXhma29kUWgzZHhsbk51bENjRlkv?=
 =?utf-8?B?TUlvcGtNcnVQNm9GZ0JZd3dhZjZBWkFZTE9NNnhlTjRjZjBrNjI3Rm9GQnB2?=
 =?utf-8?B?TmRuZU5tMHA4KzJUdjU4UmdYZy9ZbGZndk02VTBXcCt1MmdaWEFqV2RSV2VW?=
 =?utf-8?B?amZ6Y2RFZURUWUZrWSt2Z1RMdDBFZXkxM0FMNFY0U0dxTDhIREJQMFMrR3pT?=
 =?utf-8?B?Mmd0ZkpJQjhFTmtOUUNCc2NqNWluSmt3TGdyQkd4d0cwaTVzOGd6S05NOUJN?=
 =?utf-8?B?RUlGUHZMc3BSZHczV0o4WDc3bGZkNjRmMVZISnR2eWE2V2l5MWNnMkdUakY3?=
 =?utf-8?B?NFM2TURNSEIvMFVTUjBMMFpOTTVDeXF0VTZESElpRmVVb0RMa3JQaS9lSDJ5?=
 =?utf-8?B?MXhvOVdOQjFlS0tzZnBUMXppbUh6SHoyMEF3VGExZCtJU2VjdHh5eHdLRFdT?=
 =?utf-8?B?Ty9YYUVLdGU5VmMxRzdwRzA5VW9mREJBZGRhOXNFcXgydFRpNHh0eXpyVDFG?=
 =?utf-8?B?T3h5N0IwMGVOUDhPcWhLTjhZUHFNMmN1UmVudDBKOCtKbDh2M2tQOUduWDVL?=
 =?utf-8?B?Uk5MN2ZqQS9kamJZWWRJa09MOUVJd082YzZBdFlYN0VZSmExeE9KOEd1bWFy?=
 =?utf-8?B?UEF4ekNIOXdGYm1Kdzc3VkRLb045VW9GQVhxZnB6d043NW9zdHppM3NlWTIz?=
 =?utf-8?B?aXZtQXUrejhqOGE4enNNU3pQcmJZWVZOeDJmTE1jOFdvUHZ0R0JhdkNaUkxN?=
 =?utf-8?B?Umd2OXRJdFVmeklvU000YU9IdEZjejJvMTA5VjFpU3h2RVl1YjFWZ3F3QTRi?=
 =?utf-8?Q?zjxxHnZ2YYy0ive2oRd80k8UhujimY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZG8relJmSVFNYXEzdEZNeHRZVjNTcWdQVVZ4cmxGNGZvOWcxTTNoZGdiLzNG?=
 =?utf-8?B?M0pXR3FqcDhLNS9iaTZxMVhLelBINThhZHBBNUZuL3dQaXd1QXo3NTVPb2VQ?=
 =?utf-8?B?SU96cmV0N2xvVmhaSlhBZ3BLWWZ5S252cEJxTnZYeUZBQnlRaGpTQllab0or?=
 =?utf-8?B?b2ZzSU00bFVVdy9wczJ2WGVsTENlcHkySnZaZldSdTVyWnlqODU2WCtMQlI3?=
 =?utf-8?B?WDFWOFZ5MVpwYlo1b3ViSmwzMHlCc0dPWm9KVHRjeW9oQ0FUbjNKQUhaNXFS?=
 =?utf-8?B?dGhSc1lqQTVSbmUxSCsxM1RDUFdRMXlMNHN3OU0zUzhZU01oTkQrWS9LVWMy?=
 =?utf-8?B?NlRPbWNhY216c2l0cm9JQ0lFNUVnMk43a24veW1OZ2J2UlF1M2plVytrd21o?=
 =?utf-8?B?MldRQ2NqTm1ydXhDRTY2cXYwa2tYY0tmdHduSFpRZzI1eWpVYWU4TWdJQVBU?=
 =?utf-8?B?N3R0QWdRMFEzZFhtZS9jL1U3Sk1naFB6OGxscERZbFJWU2dtbW9hS2ZGM0hZ?=
 =?utf-8?B?aU00bHZzdWpDUUNINjc4bzk2cm0rWUJJUGZZQkZVeFFOYmxRY0I4SUhtTW9Y?=
 =?utf-8?B?TXJBbGFlYzBEQ092NmQvUmIyeVRqNlNSRmFJTWU2b2YyK0FVRlY0aGgwMStK?=
 =?utf-8?B?OU9OSDV1VFNXMHFLak1ONnpDcFppM2lqdVcycGFsZVB5TW9KRHlOQytjQXpr?=
 =?utf-8?B?dHpSU0pUaE9oZUdhZjNwY0lYcEU5Ri9YT1JRS3B6RzZ2UnlQK0lRSU1odkZ4?=
 =?utf-8?B?bXJPamk1czZXbHdXL0VHRjM1UjRzanpqZGwxMjJEYzJkN0NWbThWRzlhd1ow?=
 =?utf-8?B?SGMzSVJoYnN5NktHckpsQ0VvMnpuMTRyT0FJSkdnVVdKWW4rNlhITlcySFhi?=
 =?utf-8?B?aGNVeTFXTGIyd2ROc3RYdlVoTHpaYTlaeEgwelFLWkRjQVBEMndnT3hPWTEw?=
 =?utf-8?B?RlU0aklQVlVES0gzb3hpUkZrYnBHampPUW1yWXNkNmNmVkhCaDdoaVpqY2FI?=
 =?utf-8?B?dFFJOWswS2JCMjBVdjU2Vm5hNUYrWlYyelF0L2RUWjJKcG1PNkVZWTdLc0Q5?=
 =?utf-8?B?UEhPc0lhYnl6TlZWaktONWhweHNoU214c3F3Tlg1TjRwUTBla2VFcGNmbVRB?=
 =?utf-8?B?YWZscjB2Q1NNL1NleDFnT2s1Z2RiZ1kzN1p2TmVqR1RodC9jRVBqZ1M4T1hq?=
 =?utf-8?B?QkgrbUl4QmFGNkVZdUthZjQwQjgvVXNFVmRCeWQxeEdKQlJPRjlDNHZOdjJ0?=
 =?utf-8?B?aG0va2tGYmRRM1dPdnBMWFRYTUZ2dkhQMHdIR0pRZkN5My8vUHB1dm9EUUFi?=
 =?utf-8?B?SlhNZktURktHRzhqUXpURDZJN2Z6NHJUaHQ3blNHTEc4QVpxdHZKVDFWK0c3?=
 =?utf-8?B?TWtqTHNpMDNLUkVFVDU4cVdOT1UvVVo1b3dRYkpJcXAvNmxMaFJ3Z01pSlRH?=
 =?utf-8?B?WWZLSXdabWR5dGpGZU5JNE9wTmVmaHM1TlU4b2haQWlrM0JwejdJWDA1UXR6?=
 =?utf-8?B?VnJUN3k2SWlyVFV1dTNYVm11M1E3WnNIS3cwN2tYc3FDV2xyVzh0TVoramZ5?=
 =?utf-8?B?MWZJT00yZ1hEU000OHYrQjVRKytYekNKVUlZRWMreHdXbVdmd0tJNjZZN1dP?=
 =?utf-8?B?bGYwOEFoYWxkc3FIN3VZa2M3d2RERFZncXVna0lJWFFBUWoyVjBTSWdsRnFw?=
 =?utf-8?B?VGp5N0ZRTEM4TGFXd1plM0ZhM0t4Y2pyMlVsV2VRc3BiOHp1TFlDOU1EQzhh?=
 =?utf-8?B?UytXa0FXQzRzSFRHcVJiNVVjbzVDUGNPNk5NZEZmMkppZk1yblI5b3pnTDE3?=
 =?utf-8?B?eVRnZW1XS1Z2L3VaaG9Wb1piMndVTWdhODJPczlTVTA3QmdtYkF0WVQ2a2xR?=
 =?utf-8?B?c0MvR3NYMkNtTjhaejFkY1A0TVF6UEY3M1l1N01SNFRuR21TYldWcEVORFpm?=
 =?utf-8?B?Mm52R28yREF1Uk1FbVZlSzIvZGUyUkVLaThVdzQ4TExFRGgwOVRMbTEvalRp?=
 =?utf-8?B?ZXpKamh6U05lU0JBT0pwY3BHaFlRWjlhYmlBSGt4Sm5wTjFydVdoenRKZDJ4?=
 =?utf-8?B?MlRyOWtaeDVOTzM3RGhzd3dlb0RUZ1oxZTFkZmNDL29TNXovaFNvaC9VMEtQ?=
 =?utf-8?B?dURYbWF6K1pXM3MwaEZJblRjUlZhV1l0dm4yUWNKaENuUVlDbm82dWpzejNi?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFDB1005E80F5546A2F14F9F8FA62324@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d869c7db-028c-4537-48d5-08dd9e953e9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2025 09:43:19.4003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i07qu4rhPNsYt6S9dp8YlR8i4WOPH327w8KO4kVAgRLP5sn4X7E3/7HEb6cax4TCJewZRSXvIOt35KEX3AXzPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8053

T24gV2VkLCAyMDI1LTA1LTI4IGF0IDA4OjQzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEhpIFBldGVyLA0KPiANCj4gSXQgc2VlbXMgdG8gbWUgdGhhdCB0aGlzIHBhdGNoIGRvZXNu
J3QgaGF2ZSBhbnkgYWR2ZXJzZSBzaWRlIGVmZmVjdHMNCj4gYW5kDQo+IGFsc28gdGhhdCBpdCBm
aXhlcyBhIGJ1ZywgbmFtZWx5IHRoYXQgdWZzaGNkX3NldF9laF9pbl9wcm9ncmVzcygpDQo+IHNo
b3VsZA0KPiBiZSBjYWxsZWQgYWZ0ZXIgdWZzaGNkX2Vycl9oYW5kbGluZ19wcmVwYXJlKCkgaW5z
dGVhZCBvZiBiZWZvcmUuIERvDQo+IHlvdQ0KPiBhZ3JlZSB3aXRoIHRoaXMgYW5kIGRvIHlvdSBh
bHNvIGFncmVlIHRoYXQgaXQgd291bGQgYmUgZ29vZCB0byBoYXZlDQo+IHRoaXMNCj4gcGF0Y2gg
dXBzdHJlYW0/DQo+IA0KPiBUaGFuayB5b3UsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpZ
ZXMsIHRoaXMgcGF0Y2ggc2hvdWxkIGJlIGFibGUgdG8gc29sdmUgcGFydCBvZiB0aGUgcHJvYmxl
bQ0KYW5kIHNob3VsZG4ndCBjYXVzZSBhbnkgc2lkZSBlZmZlY3RzLg0KDQpSZXZpZXdlZC1ieTog
UGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg0K
