Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541BB19992D
	for <linux-scsi@vger.kernel.org>; Tue,  1 Oct 2024 07:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727768785; cv=fail; b=A7DTp66D/QFg9GfxqLk7J6eIikGpyd+lb5DH88UqoM0dNI3jYVIPWVIiow0eonAthEil4KghSOm1Tc0pKMtFwec0u3gFh9q83Hm1WmXWCQKoxy6kEsXH47Oi0sCQyehiwqqG1YidsrysHV1QN8rDSvQpf3L4pn6UVMdbaNB+9kM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727768785; c=relaxed/simple;
	bh=a6A0CFqK57Myj9ekx66yRPivb0rttY7WgxhYuec/tgY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RihNPLjrmjIXQK6C/TUKMHqvJ2Fp83wBDeA4nyVnCs2VEwCFMnjrySbyJfADxpuIVYdAW3FqugWPa0QGoXGLC4qHKGx0AdX3mHg9zEsdmIzwbHxw9w2wj9SwOQPtSd7vzMt80onyRFYtlsCrsCBtGeQPSaj7YD9M4AJXOvvg2uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qgxQG4fh; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=v7yKxvHi; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qgxQG4fh";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="v7yKxvHi"
X-UUID: 39386b347fc911ef8b96093e013ec31c-20241001
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=a6A0CFqK57Myj9ekx66yRPivb0rttY7WgxhYuec/tgY=;
	b=qgxQG4fhqyG0Y47ugO2X+SmyaTBkHyFDTRi6VAPvcYBogR+t76iYfXTvEylfCVyjlnPoT9mdwp5TCLesnnlBDBnMLr/O1dPftU/IySJ6e0mql4meJIOsmPrz1949BJUi/Vp+faiodxRQsVoPVZ4VFRCewJ08H7zOb2z6RzSk8gg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:99da0103-d7b0-4b8f-a291-f5726dd39220,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:19e70ad1-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 39386b347fc911ef8b96093e013ec31c-20241001
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1682682791; Tue, 01 Oct 2024 15:46:09 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 1 Oct 2024 15:46:08 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 1 Oct 2024 15:46:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aP8TevuqGOzj5vUnIH4lTSsUNcSzYIiYqWB/Ltq4ejy3vKbOFS8zwp+gJ7pjBaHqjaMNXXSW/ZkGyoNXIPa8ubMdycuxEf0aQGo7ypU7n1K1iJPpjPNXYSigMmeJ94LLQJ1DEpXPrd4QQJMS4fmYjYQ7IB/VTLHi8+kvP/A1hsEQX8xc1wVKWr+4Xb+UCYyi+WV7rY7pUuR5Tb0xVNShCbXoPnJhEnt4RYbdhPNwCbJH8pdI5QTdyfa2Fx0PD6dnURpgkAL5Xflhu/on7T/jCUxACDA8OmfC+cNpZWPmXvxNpG+k2+FlrwUauGvq1gB8Auby4s7SAGxgxA6WT4ukXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6A0CFqK57Myj9ekx66yRPivb0rttY7WgxhYuec/tgY=;
 b=kTeaac46+/VSn5CD9Nw9unhB2novyT9zHY4FgO+I+lM13RBO8BxUYRf9uZXid+oQJVdi0nqhHnDYM/nlQGRueC3tcs3uJnSBuaKzx2ryeLRHA7x8N+o3f6AOpBVnfWIESSn9Pa61I4cTRghKu5+hWKP4cZaKbpb8vaMgbgCNE0P1r/auS4cn/dg9rO2C/t4ZgPlmtYrBWv29IlJVB3V6vpsn5bHaHGBgCwOJ/zWp+6x0/jrdlKwxJ89dEsqxTCF9Wc8/6vVMyrAJV9fF9TBwcZwLhQHbesJWmmMLEJuZ+ObswbCmDbU4+GACBfzfcK4OPnyZBzHtDpT56bQ2MGkyjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6A0CFqK57Myj9ekx66yRPivb0rttY7WgxhYuec/tgY=;
 b=v7yKxvHi6SLs+TA9oAd27poCZJXrndSH6XEZmT4PQIriAcKtNwduOReC3QBRJ+0UXSZaS5yDj2D9w3a7E8aJT8Oh5eBqlfOFyitlErLrbM+YIh7gMsUHWL/pIXTMhM/pKEwM02HkzU/JWixDixBs98vKrWHk89Rh+qTtLjNiCbs=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8084.apcprd03.prod.outlook.com (2603:1096:400:473::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Tue, 1 Oct
 2024 07:46:06 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8005.026; Tue, 1 Oct 2024
 07:46:06 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ abort
Thread-Topic: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ
 abort
Thread-Index: AQHbDzNnjCHDHRi190OQQBukK2Coj7Jot2cAgAC3HYCAAPZCAIAA4Q0AgAKS3ICAAhGGgIAAsu+AgADwZYA=
Date: Tue, 1 Oct 2024 07:46:06 +0000
Message-ID: <b2666fcc1803090ce33cde934b7bf9ee5cf40457.camel@mediatek.com>
References: <20240925095546.19492-1-peter.wang@mediatek.com>
	 <20240925095546.19492-3-peter.wang@mediatek.com>
	 <949fb86d-6b61-4a1a-bc04-c05bb30522b9@acm.org>
	 <4bc08986190aecb394f07997b2ad31e301567496.camel@mediatek.com>
	 <108a707e-1118-42f4-8cc9-c1bda9fab451@acm.org>
	 <134227055619610a781d5e46fb14e689f874b7d4.camel@mediatek.com>
	 <c014f499-1a5d-4e3a-adc1-a95a38bbe2de@acm.org>
	 <ad352469b3a1b6efd07506fba78c8f8f7f0295b0.camel@mediatek.com>
	 <e934cba7-a4a3-4363-ab07-3b1a9350d9ad@acm.org>
In-Reply-To: <e934cba7-a4a3-4363-ab07-3b1a9350d9ad@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8084:EE_
x-ms-office365-filtering-correlation-id: 1a681d64-c9c4-4ab4-0bf7-08dce1ed1b46
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QkhCdXROR1YydVNGKzhEaWJEbzh6TEtZREVTRnVCU01zQnozb2V2L3VIMWF4?=
 =?utf-8?B?alQyMW5tRUxQTGoyRVRhdWtuVXk5Z09vazNqZ2RmNTZiTnZPbWlXaHp2cXVO?=
 =?utf-8?B?c0lBYmhSTm52UExqNUZmY3hNcC8xZXViem8wbGgrS29SM2lManJhU2R4dkJN?=
 =?utf-8?B?UGVKRHFFak1ZOU9tbnN3MTNTVXhvbE9vL1FUV3h3QTVsRXRYTGlYNnZSRkhl?=
 =?utf-8?B?dS9yY3dBbkJMRlJyRHdVSUJqU0w5dGQ4a3dMMkoyTjhFV3EvTlVVM3NvTW55?=
 =?utf-8?B?a1UyQ3FManlJUDI3bmFoUE5MRHR3eVFUQi9xZmJ1Qy9od21mRkFscHF4cWdE?=
 =?utf-8?B?bGdjMXo0d0d0SC9Jc3FESEk1RGNTNmphcTl0VmlMUGZSV3pnMnBNQTFCTzM0?=
 =?utf-8?B?c2ZYc21XMmIwRERPdDIzNE5yZkNvL2NoKzhteW4xeTJNTnlSMzlKMHpTNTdJ?=
 =?utf-8?B?NWtXZEgwMWpRZzMwYXZKMUp6V29QbGhFMWJlbERRbGduS0VUVUI0TnJ6bHZL?=
 =?utf-8?B?cU1CYUJKNUNhbE9wRVVwVmlqaEpBZmRYeHM5ZUVOeTRtOWtrZVRwbUJkUlox?=
 =?utf-8?B?cEt0YS9SclFYV0xQVXZDRmxWYVg3d3QyWTFHRG41RlVXd1dOb0RLMGlXNTFn?=
 =?utf-8?B?cWJxRUZCVVVuSzZYUm5hZ1VXY1U3bXh2R1dWUUxzZk1xODVWZURjMTFRNm1y?=
 =?utf-8?B?ZmtXWW9PM0lTSWJUYUlXcGlsRW5rL0hKN3BzVVJlenozTlh1V3VpWVQ4NVIw?=
 =?utf-8?B?MVg4QXM2YzVyQWEzdHV4QUEyQk5Lbjd4ZStrd3VSdVBjaFBUZ0FjelY1ZXN5?=
 =?utf-8?B?VE9pS20xcHZkSG01ay9qcllWSUkrZjFmd1htTWIyRnBCelpWTVpRSVFUeGFS?=
 =?utf-8?B?Y1BEUksvUTJydk1YMHJMd0J2MkpzNHlIRGViMGExeklJUlBqZmw2NWVkWC96?=
 =?utf-8?B?WnBDdENkMGpLSi9sLzAzSmV2d1BkNnZMUGVLNCthMlgwYStMSGpBZ3JUcWdD?=
 =?utf-8?B?dHAvSzBaNHlzeXVkWVU2M1hERjZQU1ljR28xaHNjZzNFUFc3NE1MaFdnN3Iz?=
 =?utf-8?B?aUM0bW5CNGdKRXlCTlZ2YVNPNXR4QUlZS1UrQitvV1N6RVNJandVMkQzSjV1?=
 =?utf-8?B?L2daenpYWmJndDFUSERhUDhUT0JTRFV6WnNtNDNWekRnT1NJTERWTjF5bFNu?=
 =?utf-8?B?dXhMdWtUWGZpL1c5OTdJUS9TUGVtaFAvV0NRalA5NjRMTWl4SXV3eStDY002?=
 =?utf-8?B?Ly9YclpjOTRIRk5yTFRlbFI1Qm1oUHhYL2hjVnNiSkNGd1piUWNpZEZuSTd5?=
 =?utf-8?B?RkFUZlhuUDlZWkNpMzJ0VVFDQU1UV0tpU3VqS2E0UGdia2tRMFBpOGlxc0VS?=
 =?utf-8?B?eHExRks2U2VSSytJMHRHUlkvaGVRdThaMVREREJzd1pTY3BTWmxDYXhCaVJR?=
 =?utf-8?B?T25uWTBYT0lMM2RmeTgweS83cHhvUFNYOUpmbXQwUi9IKzcwaXFiazVERTl2?=
 =?utf-8?B?UjZIaTVEakVMVjdwV1B6SFFwL2tRL0kvcGd5emt5dUthdThIbjhGclFVeE9O?=
 =?utf-8?B?MXJjbElZYzRmejJkVUwwM3BobUdOSGpxaHQ5Vzk1R0Vxd2ltMTZ1NHUwVXlI?=
 =?utf-8?B?TEh3QjBQbXU4K1RpWHpBalVHZ0hiTWI4TDFCMFBjNzVtV2hFYVdxeFpWYi96?=
 =?utf-8?B?UGRDK2V1NFcvN3hRUXBHRXI1TnhOVWppVkpwUEMzbEEzaFN6ek02Yy9DQkcv?=
 =?utf-8?B?M0Q2Wm1ieURUR2JicGVkYStQQXZGWXkxS2VaUXFPUWVLTGxDb3I1cHlFM2xI?=
 =?utf-8?B?MFZuMEVqdWliUTI3aUhqQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXRjSWJLdmoyZlJxVER4L1lmLzVYakFnZ21neDI1V3VtS2pERlFNWktpaG1l?=
 =?utf-8?B?d2owUEREaVIzNWFFM1FSd1k3OWhMSzlEUkZtdHJseU9CV2tQN2thQ2hGcFhD?=
 =?utf-8?B?NXIraFA5V1R0YjIzSkQrbnA0T3BhSnJIUk56Zm9TdUtWMi9Sb0M4S0xTTUR6?=
 =?utf-8?B?L3MxOE5JVXJGWTFldU5Tbm9BN0RTRUlTcEY0MjNtTExKbm42Y2tHb3hza2xm?=
 =?utf-8?B?SmpGTXNkTHA5MGQrWnpuTWFueTc3TkJvOGhJMDNzbGtMR29uYzlHVmRsRVJQ?=
 =?utf-8?B?My9MVXk4aC9MTW04OWE1Rko5WXdjM3pWMlBhczRScjJzY3Q0clFUYzJRN1JG?=
 =?utf-8?B?ME5aUU5Sd2pUTUFtajVPUFdyZEw4SENFNjV2WG5vM0cyelFyckN2RktDbS9K?=
 =?utf-8?B?TmZPcU4xQWFxNlJZWEZNLzZad2JyU1V0bXpNa1VFWDQ4QllQbTVXS3p3ODVV?=
 =?utf-8?B?OWxXTm5QTlJjR3dCNEllS1NhcnMvNitsMUQrRmQ5ODFTWTcxN2ZRZElUa2p5?=
 =?utf-8?B?ZkVkRXlXcEtrbE1ET0U5OUtHYkN6NVNWZGRTRGZrNFlQQURHdjlHNGQ4djAr?=
 =?utf-8?B?L3Ric0tGMTl1QUFGdU44eXdWcE1tVzhhTXNiK1UyMWFzRmYrSmIzTGQyd2Zx?=
 =?utf-8?B?YkJ3M3VUbDUrNU5SU3RSdDVINHdFYXRRR3dLcDlaVGFXOU1neisvRjVjNFZm?=
 =?utf-8?B?ZHZYYkJ0RkZZOGpvd2ZYT0JrTUNaZGlBa3d1allqc1pZV0ovWkJnTkdlK08z?=
 =?utf-8?B?ZTdKN1Z6bW43TlhUcm54WmdjZmh2MGlqTHk1WXZsSWplejVVeUQ4cFhPQ2M3?=
 =?utf-8?B?VEZpakswa0dEeG9Kd0NneHBwVy91TlNBVTFHOVdFQjBqTnhOaUlzZnhtQTNh?=
 =?utf-8?B?Ump5K1NsQWtFdStCMzJHdlQwc1FZemJ5NU9OWVJXT3lBeDFkRDRtUGlIL3NP?=
 =?utf-8?B?UFl5OTlML01Valc2ODRmZVJEQnNDTGlwam5QRm1KTkl5WFhCUVlxTE5lQmdq?=
 =?utf-8?B?SGhBbFIrS3h4WEEyeUMzTDdzRHJkRDNZREFNUmd2Uzk0cmpCUWNWQmJNeEZO?=
 =?utf-8?B?T1NLcVdXYjRSc3ErcTQ1TCtPNWMyZzQvRFZEbmdyeUlnLzhGRUt2UldodmxT?=
 =?utf-8?B?U2l5aWFtNkhZRDRSMjcydU5yTTVGaVQ0SWgxVUM3VHpIZXJydXNaa1Q0ZmpR?=
 =?utf-8?B?R0lRbnFSYk9zV1MzOVpCRzhoZElWQjZrQzJzWlJiYjY4TGVDeGxHV3lpKzRD?=
 =?utf-8?B?Ykg4Z1BvMUtJV0pvcldqcXRaZldvTWowRnJEQVcvbGdZYzlpK0x3eEM5WWcx?=
 =?utf-8?B?cU9sR2pka1JTKzdJSTBlLzFuRC93NjRzYzVudkk3YnZ4emJLTXJ4VnFlVTBv?=
 =?utf-8?B?OWtMdk51TklmZWFmREhKN09wcmViM2w4QkZ2ZGl3eWVDZVRoMUs0c3NxL3Np?=
 =?utf-8?B?VXNkQWpmSFhPdm05TC8wektwUVVVRDlCTWRQc3VRbnNtUHdsaC80NlpsclBu?=
 =?utf-8?B?RElYWlFGU1Vna25neGZGeEFFa2RGUkdkZUFMK1FKbS9hOTJaOGRVUFpKT3NO?=
 =?utf-8?B?WEd6bElHZVkwMG0rM3FrY1dRSUZ5SkZHV0tQWUkyMjVJdmtveW1POUx4TmtY?=
 =?utf-8?B?cnNaK3NYenNFQnBSQmEwQnJJeVhsVHVWREp1NFdDNWNNVDJkYkVjWVp3Wldk?=
 =?utf-8?B?aU5wWmhyNlZuZlFCSm1Db2xPYUZvb1RtaHB0bDdCelppYnBzWFJEdzZLaUZo?=
 =?utf-8?B?bWZXMEJWTkUzeGNXTXRnbjJuNk5NcnBIdXhqcmxmb05waUFMY0FJMzg0ZG4z?=
 =?utf-8?B?R0V1d0Q1b0RGU0ZtdVBRRkJHRE0xclZIeTZoRmU2VS9VaDczaklFY1lrR0Rh?=
 =?utf-8?B?aFFkYkJGNDUwK0tpbkFwOWJGQjdGV1d2MXptR1FzN0xkMzZ2emJRYlBmNjhw?=
 =?utf-8?B?SHhQSkxzYW1EUHNJZnkwQW8rcjNuZndWS2ZMTU5CcVVjVjg4RjNVdWFKZVBQ?=
 =?utf-8?B?RmZoUC9mWkc4MHNteWl6UGxRNmluejl1dmpPaWJPWFRaUmEwdzBJdXU0RG8x?=
 =?utf-8?B?ODhURHoyeGtrVi92Y2t5UVgySUxkemNFemc4Ly82OFV0K3pOSC9WNFVjMG5K?=
 =?utf-8?B?aEcvM3RFbUJ2Y2RVN25KUk9NVGdxVlMvTlhyencyc0cyRzlSVmtVM1dEWlMr?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6DD0ADE9B254B4AB678679287E90C75@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a681d64-c9c4-4ab4-0bf7-08dce1ed1b46
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2024 07:46:06.0562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nNtcB7YiZz8AYA7Rp35Ppv/TGkWuXRFPdgb0vDqvuqM6X3cQdgHZ14QmGZ0DdgyuebP4v50o5prQyUCiT2KF9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8084
X-MTK: N

T24gTW9uLCAyMDI0LTA5LTMwIGF0IDEwOjI1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KDQo+IEhpIFBldGVyLA0KPiANCj4gVGhlIHB1cnBvc2Ugb2YgdGhlIFNDTURfU1RBVEVf
Q09NUExFVEUgYml0IGlzIHRvIHByZXZlbnQgdGhhdCB0aGUNCj4gU0NTSQ0KPiBjb3JlIHRyaWVz
IHRvIGFib3J0IGEgU0NTSSBjb21tYW5kIGNvbmN1cnJlbnRseSB3aXRoIHRoZSBTQ1NJIExMRA0K
PiAoVUZTDQo+IGRyaXZlciBpbiB0aGlzIGNhc2UpIGNhbGxpbmcgc2NzaV9kb25lKCkuIE1ha2lu
ZyBzY3NpX2RvbmUoKSBjYWxscw0KPiBuby0NCj4gb3BzIHdoaWxlIGFuIC5laF9hYm9ydF9oYW5k
bGVyKCkgaW1wbGVtZW50YXRpb24gaXMgaW4gcHJvZ3Jlc3MgaXMgYW4NCj4gdW5kb2N1bWVudGVk
IHNpZGUgZWZmZWN0IG9mIHRoaXMgbWVjaGFuaXNtLiBCdXQgc2luY2UgaXQgaXMgdW5saWtlbHkN
Cj4gdGhhdCB0aGlzIGJlaGF2aW9yIHdpbGwgY2hhbmdlIGluIHRoZSBTQ1NJIGNvcmUsIEknbSBP
SyB3aXRoIHJlbHlpbmcNCj4gb24NCj4gdGhpcyBiZWhhdmlvci4NCg0KSGkgQmFydCwNCg0KWWVz
LCB0aGUgU0NNRF9TVEFURV9DT01QTEVURSBiaXQgaXMgdGhlcmUgdG8gcHJvdGVjdCBhZ2FpbnN0
DQphIHNjc2kgY29tbWFuZCB0aW1lb3V0IGFuZCBmaW5pc2ggb2NjdXJyaW5nIHNpbXVsdGFuZW91
c2x5LiANClJlZ2FyZGxlc3Mgb2Ygd2hldGhlciB0aGUgdGltZW91dCBvciBmaW5pc2ggaGFwcGVu
cyBmaXJzdCwgDQp0aGUgb3RoZXIgd2lsbCBub3QgcHJvY2VlZCB3aXRoIGl0cyBzdWJzZXF1ZW50
IGFjdGlvbnMuIA0KVGhlcmVmb3JlLCBpdCBpcyB3aXRoaW4gZXhwZWN0YXRpb25zIHRoYXQgc2Nz
aV9kb25lIHdpbGwgDQpub3QgcGVyZm9ybSBhbnkgYWN0aW9ucyBhZnRlciBTQ1NJIG5vdGlmaWVk
IHRoYXQgdGhlIGNvbW1hbmQgDQpoYXMgYWxyZWFkeSBiZWVuIHRpbWVvdXQgYWJvcnRlZC4NCg0K
DQo+IA0KPiB1ZnNoY2RfYWJvcnRfb25lKCkgZG9lcyBub3Qgc2V0IHRoZSBTQ01EX1NUQVRFX0NP
TVBMRVRFIGJpdCBiZWZvcmUgaXQNCj4gdHJpZXMgdG8gYWJvcnQgYSBTQ1NJIGNvbW1hbmQuIEkg
dGhpbmsgdGhpcyBpcyB3cm9uZyBiZWNhdXNlIHBsZW50eQ0KPiBvZg0KPiBjb2RlIGluIHVmc2hj
ZF90cnlfdG9fYWJvcnRfdGFzaygpIHJlbGllcyBvbiB0aGUgYXNzdW1wdGlvbiB0aGF0DQo+IHNj
c2lfZG9uZSgpIGlzIG5vdCBjYWxsZWQgd2hpbGUgdGhhdCBmdW5jdGlvbiBpcyBpbiBwcm9ncmVz
cy4gRG8geW91DQo+IGFncmVlIHRoYXQgU0NNRF9TVEFURV9DT01QTEVURSBzaG91bGQgYmUgc2V0
IGJ5IHVmc2hjZF9hYm9ydF9vbmUoKQ0KPiBiZWZvcmUgaXQgY2FsbHMgdWZzaGNkX3RyeV90b19h
Ym9ydF90YXNrKCk/IElmIHRoaXMgY2hhbmdlIGlzIG1hZGUsIGENCj4gY29uc2VxdWVuY2UgaXMg
dGhhdCB0aGUgY29tcGxldGlvbiBoYW5kbGVyIHdvbid0IGluZm9ybSB0aGUgU0NTSSBjb3JlDQo+
IGFueW1vcmUgdGhhdCBhYm9ydGlvbiBvZiBhIGNvbW1hbmQgYnkgdWZzaGNkX2Fib3J0X29uZSgp
IGhhcw0KPiBjb21wbGV0ZWQuDQo+IEhlbmNlLCB0aGUgY21kLT5yZXN1bHQgdmFsdWUgd29uJ3Qg
bWF0dGVyIGFueW1vcmUgZm9yIGNvbW1hbmRzDQo+IGFib3J0ZWQNCj4gYnkgdWZzaGNkX2Fib3J0
X29uZSgpIGFuZCBob3cgdWZzaGNkX3RyYW5zZmVyX3JzcF9zdGF0dXMoKSB0cmFuc2xhdGVzDQo+
IE9DU19BQk9SVEVEIHdvbid0IG1hdHRlciBhbnltb3JlIGVpdGhlci4NCj4gDQo+IFRoYW5rcywN
Cj4gDQoNClNDTURfU1RBVEVfQ09NUExFVEUgc2hvdWxkIG5vdCBiZSBzZXQgb3V0c2lkZSBvZiB0
aGUgU0NTSSANCmNvcmUuIEl0IGlzIHJlYXNvbmFibGUgdG8gc2V0IGl0IHRocm91Z2ggc2NzaV9k
b25lKCksIGFzIA0Kc2V0dGluZyB0aGlzIGZsYWcgYWxzbyByZXF1aXJlcyBub3RpZnlpbmcgdGhl
IGJsb2NrIGxheWVyIA0Kb24gaG93IHRvIGhhbmRsZSB0aGUgY29tcGxldGVkIGNvbW1hbmQuIElm
IHRoZSBVRlMgZHJpdmVyIA0Kc2V0cyB0aGlzIGZsYWcsIHRoZSBkcml2ZXIgd291bGQgaGF2ZSB0
byBieXBhc3MgdGhlIFNDU0kgDQpsYXllciBhbmQgZGlyZWN0bHkgbm90aWZ5IHRoZSBibG9jayBs
YXllciwgd2hpY2ggaXMgY2xlYXJseSANCm5vdCBhIHJlYXNvbmFibGUgc2l0dWF0aW9uLiBBZGRp
dGlvbmFsbHksIHdoZW4gYSBjb21tYW5kIA0KY29tcGxldGVzLCB0aGUgU0NTSSBsYXllciBuZWVk
cyB0byBkZXRlcm1pbmUgaG93IHRvIGhhbmRsZSANCml0IGJhc2VkIG9uIHRoZSByZXN1bHQuIFRo
aXMgaXMgb2J2aW91c2x5IG5vdCBzb21ldGhpbmcgDQp0aGUgVUZTIGRyaXZlciBsYXllciBjYW4g
aGFuZGxlIG9uIGl0cyBvd24uIE5vdGlmeWluZyANCnRoZSBTQ1NJIGxheWVyIHRocm91Z2ggdGhl
IHJlc3VsdCBvbiBob3cgdG8gcHJvY2VlZCANCmlzIHdoYXQgdGhlIFVGUyBkcml2ZXIgc2hvdWxk
IGRvLg0KDQoNCkZ1cnRoZXJtb3JlLCB1ZnNoY2RfdHJ5X3RvX2Fib3J0X3Rhc2soKSBpcyByZXNw
b25zaWJsZSBmb3IgDQpjb211bmljYXRpb24gYmV0d2VlbiB0aGUgVUZTIGhvc3QgY29udHJvbGxl
ciBhbmQgdGhlIFVGUyANCmRldmljZSwgdW5yZWxhdGVkIHRvIHRoZSBTQ1NJIGxheWVyLiBOb3Rp
ZnlpbmcgU0NTSSBsYXl0ZXIgDQpiYXNlZCBvbiB0aGUgb3V0Y29tZSBvZiB1ZnNoY2RfdHJ5X3Rv
X2Fib3J0X3Rhc2soKSBzaG91bGQgDQpiZSB0aGUgY29ycmVjdCBhbmQgcmVhc29uYWJsZSBhcHBy
b2FjaCwgYXMgaGFzIGFsd2F5cyBiZWVuIA0KdGhlIGNhc2UgaW4gU0RCIG1vZGUuIFRoZSBjdXJy
ZW50IGRpZmZlcmVuY2UgaXMgb25seSB0aGF0IA0KdGhlIE9DUyBhbmQgcmVzdWx0IGluIFNEQiBt
b2RlIGFuZCBNQ1EgaXMgZGlmZmVyLiBBbGlnbmluZyANCmJvdGggdG8gdGhlIHNhbWUgcmVzdWx0
IHdvdWxkIGxpa2VseSBiZSBhIG1vcmUgcmVhc29uYWJsZSANCmFwcHJvYWNoLCB3b3VsZG4ndCBp
dD8iDQoNClRoYW5rcy4NClBldGVyDQoNCg0KDQo+IEJhcnQuDQo=
