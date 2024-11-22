Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7B51C69D
	for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2024 02:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732243111; cv=fail; b=bM/yOreQSEO5HS2fZl0AOjRPQ3Csd/MQNO53XOd1nG/c4Plu8/s2ArBf7vbEEGUqPLSszx0qEH3nehy0ZE6iDXzCdAhV0q+Y2kwmK/HAoaTT9KSh1KfZU/6GbYeHs3CZKgEmHRyObA/OwxpddHGZrmASiWJ3w10IQnwnQimJtKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732243111; c=relaxed/simple;
	bh=C+qeuG0X1WAO+zUGt+exmBLyBQ1FxbT5p56nUrHj0ys=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CgCwEOHBWD9OssEvPVMinOmniaVk7V4uB23CMt80TmgQffOrPbz5xeO6Ab9ndfji+9tN+6b+ok8ULqb6XMjGlzpwRZ8/uixSkx4kxo1Zu5ZHm9GD/11i6Db5fsYu6LffSpkD2xiyccPx55LTv5+owSI3/A1a4/H4KLfzrzXXST4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=oVZCDvh7; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=EISbwW7g; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oVZCDvh7";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="EISbwW7g"
X-UUID: d7f013f6a87a11efbd192953cf12861f-20241122
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=C+qeuG0X1WAO+zUGt+exmBLyBQ1FxbT5p56nUrHj0ys=;
	b=oVZCDvh7LJYGjdhtyEXrJvtQf8ANAtXGmg9dKqs0nVgeBcx7Ph56SJ2IKlbUhEnZcgXO9F280Dr0SFrAWFoFJ2CyB6OvFqvZvdstW6TU9bFuLtfh757aQI9uGgo6qwa+TDzuMJs8CYrfhYwYnjxbWRzo5Sqd2C5x9M09PDWk5H4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.44,REQID:76db5345-23b2-4c9c-92d9-dcabfbd867ab,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:464815b,CLOUDID:4f3e35b9-596a-4e31-81f2-cae532fa1b81,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0,EDM
	:-3,IP:nil,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: d7f013f6a87a11efbd192953cf12861f-20241122
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 306134646; Fri, 22 Nov 2024 10:38:23 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 22 Nov 2024 10:38:22 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 22 Nov 2024 10:38:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KdaedJQPHeGrCS+J7YK1G5DS2UdSjSQ4vKU8c5WqIP6+Iw7ItXNg3WsYsbjzCV4CNbqTcF/V1VexQ++DhEsU1oS9N1hj8mf3Bs6Xnntv8uP80A69tzN0NpJ19HTxSTXrx7cEbKi4IC5le7C1jYZMjMVOVk+j7Qm28QXNbik+KUa8E1n+JpwOF+HQ1v0KAUqeE/zylewLy8N2i1eBlC1q4gQtPa/KWGw5xPrBPBEUAvnpQNpIikX8q3rZ/SdQQ1peuomnSWSUSSOtq1HZJwKy//SGQmRkDMJMqH81LizWSRRuuCVai+IjtMU0OoN/cdhDhq+15fQGaPXGqj8lkERGiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C+qeuG0X1WAO+zUGt+exmBLyBQ1FxbT5p56nUrHj0ys=;
 b=oySl+axBCJXPLP+ZH/HUM9rBv9Dklxy+YEJ1uYSNHN/SdnMdIgf5mvBlS75rxp01j39N+7UGg9TJvfcKwDjzG1VWStMJDTcSYyNGikS4gZI46YXaDz3V/rGUJBttx4SWcvdvRnf6qCTVq9eriZWKL0XVxqiYUoWBznLtUA0kzVKMAP3nJ0IJWX0YHO6IzKavDTbI02a97HZudi0YR3N3HUaQep6tsvvkMi3S1ofP4D6KV1EyLVmalZzno7ie7m+svJYmpN7nBpyXlrTGUluhzxvKSnnkV8ufS/9FKpyIGUfYPJ/lA9eVar03ypPoELK27/IAg7kZbHXJ47X2a0+xCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C+qeuG0X1WAO+zUGt+exmBLyBQ1FxbT5p56nUrHj0ys=;
 b=EISbwW7gDc6S0QD5+J8/UcudBkP4kgSFFoqnrwNA4UXKG7SFqzL241IgVV21snd2H5Rma+zgHH+PmXklPO2lEt4bOLKdnXrOjaGCi1qtGfPZUG/ztAuWD1puF1+QvcWHNueA2vISTl3iLakPo0vIZBFU5H3R1z/zl//H7WrHF4s=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB6795.apcprd03.prod.outlook.com (2603:1096:101:8d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.22; Fri, 22 Nov
 2024 02:38:20 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%3]) with mapi id 15.20.8182.016; Fri, 22 Nov 2024
 02:38:19 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1] ufs: core: add missing post notify for power mode
 change
Thread-Topic: [PATCH v1] ufs: core: add missing post notify for power mode
 change
Thread-Index: AQHbOzJUyw0Ven+QIESinoH0tL23y7LCDtgAgACJ8AA=
Date: Fri, 22 Nov 2024 02:38:19 +0000
Message-ID: <0d9aa65cdbe2a77ba80f47830f38c4f3d691915b.camel@mediatek.com>
References: <20241120095518.23690-1-peter.wang@mediatek.com>
	 <c1fa87ed-ad87-4620-82b8-24541d3928db@acm.org>
In-Reply-To: <c1fa87ed-ad87-4620-82b8-24541d3928db@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB6795:EE_
x-ms-office365-filtering-correlation-id: aba32fc7-47c6-457a-c8a4-08dd0a9eb9dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YlZmdGlxVzRZaStBZ0ZDNmwyUXpSYXFvdjZ6aWt1TDF3YTdhTnA4RFdoZmsy?=
 =?utf-8?B?OUUwZkQrbUp6T3BIcWRGcUF3d2dvR211NWhRMUQydEl4NGhqQll1T3p5Z0Rj?=
 =?utf-8?B?bEExV1k4TDVOaXpHMWN3KzU0cDhTYW9RVStMU0s0cGViSDVsSXVHOG1SOWFw?=
 =?utf-8?B?dkJSQmt6a0wwSjdFR0hhVVRtS3VPT3VVZGxlclRzejc5UFhObXRyOFQxaE1n?=
 =?utf-8?B?MU5Gcml3eFRyOTRzdEIzT202NnFUNmMzUjlLS1dtRURpMkxjcUd2ZnExNDM2?=
 =?utf-8?B?c1crK25EZ1BJT05NcHZVcGVycTlwUExxdUROVzZWK0JlTW04eUN4QW1CUUpL?=
 =?utf-8?B?bCt5OTQ5dHZicnplUld3YnNpNWdFKy9PcjJUQ1RpOTdnbmc2TVkyY3NDTmht?=
 =?utf-8?B?clZOVGlJaWVKd1FmdXZZSnA1emE3U3RvR1VQMzVONDhpL0xQbmlsdFp6aDU3?=
 =?utf-8?B?bzNad0xJeWFWYmFVd1lVTlZlY1JJcVhqMFRnaUtnMWhMbHpQU0VabEtWZzN3?=
 =?utf-8?B?NXUra1diRlc1VXJrd01TWTRqMjhqSWs2UEF4TjByRUl5TFZKN3pnQjMwTWda?=
 =?utf-8?B?M0pLdHFoT0R0dXF3bHF0RmQ2bktUclhhQWZlcFovNndrbGRPNmFvSXFXdEdU?=
 =?utf-8?B?VXdTNW56ZENyOWZzMzQyWUc4QjUzUmNpbnM3ams4QXpQbWtWYWRjTjJQSS8w?=
 =?utf-8?B?eDNBVks2R2dvcDNNQnZaVjNWL3pNTzAvK0VSbVY0RVpkdU11SHhYUTdKTnl3?=
 =?utf-8?B?NTlWbXAySjgwQlhna052UGNDVUl6YkZ1OHVCeTd1Y3FsRTZaWmU2b2xndC84?=
 =?utf-8?B?Vzk4NTBkSjNxOWNOVEFYNkNxZEVWOElPR3NQWHdNV21ML2NOOTZwT1VITGJh?=
 =?utf-8?B?WTk0Skh2UFkrdDh0enFYZDJiT3VQVnFqdVR2SENxY2Vodml1Qzh1ZG8rQ2Fz?=
 =?utf-8?B?akhMc3JHS21mRmlWVDVSdWZRM3pacncvUzdnYi9nMGdubzhra0xiNDBaTit0?=
 =?utf-8?B?ZXd2NU5FTmh0YzlWZ2xiR3pnYUdPTE5EMHNsblpYVVJaNUVyV1UrSnZYejNC?=
 =?utf-8?B?SFJiNGNiaHpReUZqQWlzUTNTL2czeTg2ZE9UR2dZdnJmNmoyU1hGbHBscGIy?=
 =?utf-8?B?NERadlY0SHlOUlAxcUZ5VmN5Z2VYZ1BFbVJPbTVEbGVObE5pR3gvekZQaVUz?=
 =?utf-8?B?cEVDRnpKZFo3RmFaTktSenRZK1JzcGw3d0xyb2ozMnV2Ukc0MFZDdXpoMkVQ?=
 =?utf-8?B?d1NqRnNFTzV2dDhhcUpvR3JFckJlYlNqZ201eHFXNmZIVXRpSTdrSTEwN293?=
 =?utf-8?B?QXlvZzJIdnpQZTlWOGp3SWdLVEMxbmRqTlFTbUZDbU04Z0JJZWMwdW9TeTht?=
 =?utf-8?B?bUxvdElvbVV6aGVrVmRqTGY3aHQ4OFdzV1NOZEZvK3RPUHJZdGQyQWl4RXFG?=
 =?utf-8?B?ZWVMRkNFOTdlSndrY1JPakxrdTVxdlpJY1lNbFNIL21TVFd1QUt2NjFHS0pK?=
 =?utf-8?B?eDdRR3lDcjFabU5HSGRJdWwxRDIxT1FmTUlGOEpHWGJ4azZPL2R5VlljNnQz?=
 =?utf-8?B?Ti9zOTNocGk0UFlhKzlldVhyYzRjR3U5aEVUY1hMZDRYWEpGem5nbHZ2ZTBl?=
 =?utf-8?B?NVNlTnBxVWhoU0dpeFRWT0s5WHI1dDdXVEhicy9ZSTJ0WE00dm85a2t3OFhI?=
 =?utf-8?B?dzNEWFhUaHZoOCtHOFc2QnJBSm5JanJZc3VTWVlsc21UeFhPTmJuYktPZHR1?=
 =?utf-8?B?a01KSzhzdXl0ZS83NVNLRUQ3Mk5FZFZHQlFJMDlWeEpqWFN4NUdFU05Db1Fw?=
 =?utf-8?B?MTBFY3ZnYmxvWmVNQVVPbVVnUFUwNzJMUFhvK0FEdGVRdTF3OGVEaGRsS2pX?=
 =?utf-8?B?TjNZalZkRkVZMDJsZG9UOHVRbGlyR2EwOVhKLzVhR2F3ekE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ay9kY0c4Nm9SZzhpTzdCM1RmdGQ2RDNiQWlaV1NqN0Rhek5jM245a1V0VExL?=
 =?utf-8?B?VG9DRkEwNktFWlpQeEk0UXBtZVpDQ2haeTlFaklIdHZsZlN4VUJ6L1VkamRK?=
 =?utf-8?B?SkcyN2oyWnVxTkJzSWFHRE1xMnc4cnhpdDdqeEJJcXRSaWhzd1RiSDhjcDZz?=
 =?utf-8?B?SEZ6NXZCcStEZ0g1NXNaRmZMRnlOV0s2d08vMThqWUg3cFVqZklwNlNRMGNH?=
 =?utf-8?B?cEY0YTI1TXAwWWgybXp2R3V0OC9xc0dkZ0dFSSsxVVo5K2YxWGtrSGVMUzFx?=
 =?utf-8?B?UC84Ri9uY3RZVlNKT1NaVXB6TkJxR1RwYXoyNGZieEdocUd1UnpWSVQ2ZVMz?=
 =?utf-8?B?R1pUaG5Kbzc3R0JRWXhhTU1Td3ptbFdUaUZkdEpPcHBSWFVzai8vN0JJV1BZ?=
 =?utf-8?B?VFlkZHpmU1lhYmYvakRnT1RpYjdKSFFKNHBBNm9ydDNhYW1XVFdJTTd5TTZE?=
 =?utf-8?B?MkE3Nll1WEN1OEpBaXAydU1FQmppaSt2U1ZXRkZIdFAvQzc4eTNMT2ZyL0pM?=
 =?utf-8?B?MTh2blFEYVJRc1RjSUY3ZGtTN1NpSXBtZjBJZzBqcW5SOXFtZWcxNy9XUlVi?=
 =?utf-8?B?UjRvMjMrWjBFQXJyUkFFKzBaOHRtQWQrRFQvbWUxZ2hNT1I0MDZMNW1mbjEr?=
 =?utf-8?B?U04yT045NG5wc0xpT05tYWlvc1V4SHJoVi9JcUY0c3RxQ0pzZzFXV2pFaDFX?=
 =?utf-8?B?dVlFcjFXTWR6NzV4L3h1dTdGQXBzdko4cDJWVTZXOXBwZWN5T1BNR2V6RjhB?=
 =?utf-8?B?emZwa3dpdzlreDNrWUxXUDQrVE9ENHdWeXQwYU4xdHhPT0p5VVJzcXhMZ0Vy?=
 =?utf-8?B?TU5xTzY1Uk9ZQk5qRVZibDVRcWRobWE5S1JCenQ2cGwreis3bFVUN3o0VGt0?=
 =?utf-8?B?SlgvMFN0Q3ByNktKeU5qRFV4TGlsTTFYOHJFRlFaQ0JnSWVuU21PNHc1amlJ?=
 =?utf-8?B?U3lhazU3ekc2NFF1K2Z2bzQzbm5NT1NjMVNNcE4yMy85elRrdjJmd1VhRVVE?=
 =?utf-8?B?eTJLUkIyekpSTjhuUTc1MmorbmNOcHlHcEJURjNydlNoRzQzb0RkeTJFZ1BO?=
 =?utf-8?B?ZG84QW1SSTkyTXdHVWE2VVlobE9jOXhwcDc3ZldhMG84TzhYZXdaZjFqZzNF?=
 =?utf-8?B?b1FyeXIxZlhCMXVrSXBGVmpKaWFMRGVxMjhHZ0h2MVFzeXFkWUp4MGNmVFkz?=
 =?utf-8?B?QVpLMUorM3BmU25NZjRSMFdxS2UzM1hNb0RzSUdoVDU3cHBueGRCd0tLUHBs?=
 =?utf-8?B?U1R6QUk2SU5xOC9QUnhFbGEwTTJtS01vWlA1WnNLVWlVUHhMVTNqVkp1SDNF?=
 =?utf-8?B?c2pNdnFTcjZQL050dkpCTEdZcGs1alBKTXR5cmRIY2p4eTRQbGV4NlJLR1Zp?=
 =?utf-8?B?aEYyTGpTUnpQUXR2V0lQd3crUUp5RDZKOEY4L1VwblZRTDhZYnBicWRUMWd4?=
 =?utf-8?B?UC9vc2lnVHoyVnNQNkl4UEJuV2lXR3dIdzBEMDlrNXlhTlAvZkdKdVI4ellO?=
 =?utf-8?B?YmRuL2RsdTR0d09rZGpxeFE0L3VTZ2xpMmJSYlFma20zMlNMakdHbU5STnJm?=
 =?utf-8?B?ZnBHVllPV1JvWFZqcytlZUF4OGRLcVpwdVJjRlFxU2NQL3FSa2ZvK2ZEUFow?=
 =?utf-8?B?WCtseXlzcFpRbGhMajZVSVFBTGk3OURwTnRjSW1ya2pCM2pYNUhJekQvbDdp?=
 =?utf-8?B?aGlla3d2UEZVb05ZbEdKQ045K0w3WnRubEhHV1A0eEZLN21wRVAxcERCaVAz?=
 =?utf-8?B?RDhXL21UMEtuSlY4VVovc1daZmJSVzJaaFVrby9hVDJCR2NaZGFLRXVacHNv?=
 =?utf-8?B?TVB2ZkNwWXBuaUI0OTJnVEo0cEZCTDJZbDhZY21rSzN0dnVxZWpLSE8vVVpG?=
 =?utf-8?B?QVlDRFRLclpMZklIUkEzTHpmdUdtaHVKeXRvTFZpc0xqYnYwVTNadU0yTDVn?=
 =?utf-8?B?c2FKOUpsZEtRa0RWNncyOENsTFJqNkJDRkJFLzM5bkZycGdFeVE1cHNOamdT?=
 =?utf-8?B?QVQraVJaZGtadWZFWWlNVDFNMkpiOWRBMG0wOXlpMFVSTGxsa0R4blZhYU1s?=
 =?utf-8?B?d1lmV2czTUlhWEplTGpzWGJuQjFvbEkvWWRiWEVHWHp6Q09lQ1UxeGxmNHR1?=
 =?utf-8?B?a3VSaGIvMEN1UlU5bXdNbjYyODZqUDkvdVhkVWtydWZkaHM4T1hycWl6cWw2?=
 =?utf-8?B?NWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AECB83F9DF83CE47891D79360A9A125D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aba32fc7-47c6-457a-c8a4-08dd0a9eb9dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2024 02:38:19.5673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zstrudApWXCvBsuwIyHaH14nuzX4qK+ZHeSSUfsak3UgGP4hRhY5fpLnNeLebnaRopVZ0ROAvHf/BsMjjvY0UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB6795
X-MTK: N

T24gVGh1LCAyMDI0LTExLTIxIGF0IDEwOjI0IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhlIGNv
bnRlbnQuDQo+IA0KPiANCj4gT24gMTEvMjAvMjQgMTo1NSBBTSwgcGV0ZXIud2FuZ0BtZWRpYXRl
ay5jb20gd3JvdGU6DQo+ID4gQEAgLTQ2ODIsNiArNDY3OSwxMCBAQCBpbnQgdWZzaGNkX2NvbmZp
Z19wd3JfbW9kZShzdHJ1Y3QgdWZzX2hiYQ0KPiA+ICpoYmEsDQo+ID4gDQo+ID4gICAgICAgcmV0
ID0gdWZzaGNkX2NoYW5nZV9wb3dlcl9tb2RlKGhiYSwgJmZpbmFsX3BhcmFtcyk7DQo+ID4gDQo+
ID4gKyAgICAgaWYgKCFyZXQpDQo+ID4gKyAgICAgICAgICAgICB1ZnNoY2Rfdm9wc19wd3JfY2hh
bmdlX25vdGlmeShoYmEsIFBPU1RfQ0hBTkdFLCBOVUxMLA0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgJmZpbmFsX3BhcmFtcyk7DQo+ID4gKw0KPiA+ICAgICAgIHJl
dHVybiByZXQ7DQo+ID4gICB9DQo+ID4gICBFWFBPUlRfU1lNQk9MX0dQTCh1ZnNoY2RfY29uZmln
X3B3cl9tb2RlKTsNCj4gDQo+IFRoaXMgcGF0Y2ggY2F1c2VzIHRoZSB3cm9uZyBwb3dlciBwYXJh
bWV0ZXJzIHRvIGJlIHBhc3NlZCB0byB0aGUNCj4gUE9TVF9DSEFOR0UgY2FsbGJhY2suIEkgdGhp
bmsgdGhhdCAmZmluYWxfcGFyYW1zIHNob3VsZCBiZSBjaGFuZ2VkDQo+IGludG8NCj4gJmhiYS0+
cHdyX2luZm8gYWJvdmUuDQo+IA0KDQpIaSBCYXJ0LA0KDQomZmluYWxfcGFyYW1zIHJlcHJlc2Vu
dHMgdGhlIGZpbmFsIHBvd2VyIG1vZGUgdG8gYmUgc3dpdGNoZWQgdG8uDQpJZiB0aGUgcG93ZXIg
bW9kZSBjaGFuZ2UgaXMgc3VjY2Vzc2Z1bCwgaXQgd2lsbCBiZSBjb3BpZWQgdG8gDQomaGJhLT5w
d3JfaW5mby4gU28sICZmaW5hbF9wYXJhbXMgc2hvdWxkIGFsd2F5cyBiZSBlcXVhbCB0byANCiZo
YmEtPnB3cl9pbmZvIGlmIHN1Y2Nlc3NmdWwsIHJpZ2h0PyINCg0KDQoNCj4gQWRkaXRpb25hbGx5
LCB0aGlzIHBhdGNoIGluY2x1ZGVzIGEgc3VidGxlIGJ1dCBpbXBvcnRhbnQgYmVoYXZpb3INCj4g
Y2hhbmdlLiBXaXRob3V0ICB0aGlzIHBhdGNoLCBQT1NUX0NIQU5HRSBjYWxsYmFjayBpbnZvY2F0
aW9ucyBjYW4NCj4gaW5mbHVlbmNlIHRoZSBwb3dlciBzZXR0aW5ncyB0aGF0IGFyZSBjb3BpZWQg
aW50byBoYmEtPnB3cl9pbmZvLiBXaXRoDQo+IHRoaXMgcGF0Y2ggYXBwbGllZCB0aGF0IGlzIG5v
IGxvbmdlciBwb3NzaWJsZS4gVGhpcyBiZWhhdmlvciBzaG91bGQNCj4gbm90DQo+IGJyZWFrIGFu
eSBVRlMgaG9zdCBkcml2ZXIgYXMgZmFyIGFzIEkgY2FuIHRlbGwuDQo+IA0KPiBQbGVhc2UgZXhw
bGFpbiBpbiB0aGUgY29tbWVudCBibG9jayBhYm92ZSBzdHJ1Y3QgdWZzX2hiYV92YXJpYW50X29w
cw0KPiB0aGF0IFBSRV9DSEFOR0UgaW52b2NhdGlvbnMgb2YgdGhlIHB3cl9jaGFuZ2Vfbm90aWZ5
IGNhbGxiYWNrIGFyZQ0KPiBhbGxvd2VkIHRvIG1vZGlmeSB0aGUgcG93ZXIgYXR0cmlidXRlIGFy
Z3VtZW50cyB3aGlsZSBQT1NUX0NIQU5HRQ0KPiBpbnZvY2F0aW9ucyBtdXN0IG5vdCBtb2RpZnkg
dGhlIHBvd2VyIGF0dHJpYnV0ZSBhcmd1bWVudHMuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0
Lg0KDQoNClllcywgY3VycmVudGx5LCBQT1NUX0NIQU5HRSBkb2VzIG5vdCBhbmQgc2hvdWxkIG5v
dCBoYXZlIA0KdGhlIGhvc3QgZHJpdmVyIG1vZGlmeWluZyBmaW5hbF9wYXJhbXMuIEkgd2lsbCBh
ZGQgY29tbWVudHMgdG8gDQpjbGFyaWZ5IHRoaXMuDQoNClRoYW5rcw0KUGV0ZXINCg0K
