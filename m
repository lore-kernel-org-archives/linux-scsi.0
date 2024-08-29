Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4197E18030
	for <linux-scsi@vger.kernel.org>; Thu, 29 Aug 2024 02:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724898878; cv=fail; b=f3e7W9sqq01BTi4zHTtu1bmg3FpEzH1u2j/qBOGUXyAz1pRf9gmR/AQAoJp7yqXoAUEcaJIU/CtFQnt9BIytiNGJZ3ngp2q8Dckgn4Qh9AV0ccjo0fzrTtquRj25I+gjkzVC+tsOIund/gCs4uXVd0DLLCefsBBPvdDrPFHEuqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724898878; c=relaxed/simple;
	bh=K1CuAzv0Ews2Jac90UM1ZqMOZ3J8Z2JdMF2zoRLQkZo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J9DhV2IKs8nvgCJqRzoLLZikbVAVaJ5aMpv1GbRemnk5KqT1R/iM/OxiJG9hJkhdKGcnhIXKeEpe48nPH9LjBNSpaR1n1ExXZdJE//O3vUkHHoFe0gYko8v4UjLC9Qt5Z5w3I1Gr9nLePHIvkjsOD+BTZ4EPG7aV19lANTs70mM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Pong8fjT; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=B4K55lF3; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Pong8fjT";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="B4K55lF3"
X-UUID: 36b1c20465af11ef8b96093e013ec31c-20240829
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=K1CuAzv0Ews2Jac90UM1ZqMOZ3J8Z2JdMF2zoRLQkZo=;
	b=Pong8fjTryAEngfQdLaUUjfp0ir+aOWZoTCpLhlhMkkazf9ihAzOgQ82Ytdf8c7oOXwncTOg5HPteWz4r9ZJ4/CcdoaHnOF+bOLXSP/hRkxj6QCC4VlNgpRLUBz2/K5+6m1bklesoPG/4X6KEryprbisj45gVqBkU7Augr+4Tus=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:c061a967-1245-4683-8fc3-41a7694f653f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:24d657cf-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 36b1c20465af11ef8b96093e013ec31c-20240829
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1782752355; Thu, 29 Aug 2024 10:34:28 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 28 Aug 2024 19:34:28 -0700
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 29 Aug 2024 10:34:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kADrcfWOLwDF2uLL5MfPf/qPGninAfHKLPqosO6CxuOdvGsP06Kc4atSN2SQBImGn5RhLa35nkYEyokiVJA3n5RVpJU9+xDkAJYRFIFZoc8yyO4KrQuJQbEGXwMGrOnpyKhzff2BezJUPGXTBgG1oGtoVT1607m0AxsiMOMcLsH0Ul/xBDLuGmlOvJEhFJPh/1CG2DC8sI4rPxaXwUcgynENStdfoAwJq7TlQ9elrAtYqhUVhrpXaBeZnPl4GbgoOeq9lVSJ3uJcS50KZ7d6srH1/9/JrSG7sU0A2NnVx644QubN8gZTOWAD3biJwlker7pUX9/qIJ/xqFD1jH5tpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K1CuAzv0Ews2Jac90UM1ZqMOZ3J8Z2JdMF2zoRLQkZo=;
 b=hDF7kSzJRrnUxqSK11pp/1XUNCDnkzWFkqkWzTSNkY2/FSRggxubsuOAFX25tFDkhNr8QdlJNm8DdNp7SppwakGG8G/vE78NyX+NaJiuWYWvsaL2kbYQAa0z36C/KL/sG5Lv8KFp+ZHQCUqDJDajWGfXqTP++94IUsxVGDJN7QOZY6Mvwk0ozKOirL8mx21w3lCRMvOCnwyPQm++pN9oFQ3tupu81xEcgIpxjER4Ctf9yCf4xSCXCGpcfSkOcg7bCWte6CKu82ICJfhyLdhd2OHXYvw803UBWlHj5iCJ4+w8gC/t4Mwoh+PFac1Du+dkkCa1swY2VYs2z3Zl+7LGVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K1CuAzv0Ews2Jac90UM1ZqMOZ3J8Z2JdMF2zoRLQkZo=;
 b=B4K55lF38BBY01uPowFI96a5XWcqAA4sn1aFY9UkLSppgf5kkutErTSV5lAWxRgoROKdjxyRO6kbD9xN5n7iPEr064DDAV7VZKojvFoa0K4e8D0qy3YYXEwBAWYb/aGl/ZjScwc50RGyTce3+qiAZVIr8L9It2AG4+frctp615g=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB6470.apcprd03.prod.outlook.com (2603:1096:400:1ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Thu, 29 Aug
 2024 02:34:26 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7897.027; Thu, 29 Aug 2024
 02:34:26 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Thread-Topic: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Thread-Index: AQHa8/g1O9xCFCXi4kKybU2KvbfJOrIz76mAgAAqm4CAAA4hgIABJXwAgAPJKoCAAMcMAIAAfgUAgADrb4CAAPSJgIAAU+yAgAApjQCAAAZ+AIAAz/GA
Date: Thu, 29 Aug 2024 02:34:26 +0000
Message-ID: <d9242830b959878241eee610d815940be53bd8cb.camel@mediatek.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-3-bvanassche@acm.org>
	 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
	 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
	 <471e5a037f5fcc996e36b6112dc011731e75b66d.camel@mediatek.com>
	 <63b82e64-e968-4704-85b8-fad919994432@acm.org>
	 <b7b0395a59e275c5e43cb282b827b39416a5b4ad.camel@mediatek.com>
	 <082b7053-e7f4-4dd9-9d84-c8d9c7d75faf@acm.org>
	 <37fc6433d70483b7a889ff804e56023b1081b7b6.camel@mediatek.com>
	 <f7f0ca00-a8ce-4841-8483-5ad886da82ad@acm.org>
	 <0476168b16b4ba6a2b52cad23714206c6e386d80.camel@mediatek.com>
	 <71de72f4-2cb0-44ea-aac7-0f2a5c8fa492@acm.org>
	 <1f0274b239c4a2484a65c28c5678aac4d4040a00.camel@mediatek.com>
	 <62a5b419-930e-4e70-a4bd-affb29c2e95c@acm.org>
In-Reply-To: <62a5b419-930e-4e70-a4bd-affb29c2e95c@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB6470:EE_
x-ms-office365-filtering-correlation-id: 67546890-a346-4754-e207-08dcc7d319a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OVllZmtmK0JXTzB6ZUI2d0xvTjJFY1AxeXFNcDNjeEh3WFIwUEpxbUVMUHpl?=
 =?utf-8?B?bldHbEkxOUhkclkyVWp5QlRLd3padXR6ZEp1d3VzcEdGTEh6Y2FRWExEM2wy?=
 =?utf-8?B?NWY2dmtST0YyRE9tbHR2UzREdTMzNDBzeDJVRzBXQ2pOM3VEZHFTNklZSm55?=
 =?utf-8?B?YVhYYSszY1JrZzFyRXZkeUY2Ly9jcUhXZ2txd3FXRW55c3dzd3V2ZEFVNVU3?=
 =?utf-8?B?bzJ5blZiQ1RQa1ZlQ0o5WDcxTW5qWlNlRXN0Vy9JY2ZuZVB4UXVYVUVOYTRG?=
 =?utf-8?B?OTdEb2FjU1VJemNyMXE2UHBWTFpUa2p3Mm1pWCtSNzJ1YUFKWU8xWXpFWVVk?=
 =?utf-8?B?NUpsbUNNaXZVampJUnd4K2JGUlQ1a0JwZjY0SlEzU0J5UlMwVC95c01DWm1i?=
 =?utf-8?B?MWJTOXR4ekNxc29La2paa1o2S25uWHNxMGNLNDUyUHdUdjJVTTlkbHoxRlRD?=
 =?utf-8?B?QVUzYVlQUmppTFI2WGVCK2NPeGhWc1ZCa0oybUxZckt4clNLdEd1d2FJZ3Zm?=
 =?utf-8?B?cXh5bVMrUVVHUXhicThJSW1zOXg4VmFRTUZsbnEvV3kzRFBVUmJKL3RwVkVJ?=
 =?utf-8?B?eWExTElGM3U2STFsOVkyVFBwd0gzVDNWbUE1aTJyaXgrYmNUZzkzQW5wSnYy?=
 =?utf-8?B?QTlwUktLeHVmWlV6bnJtMVBNbDBSSlNQeHFKaVpQTmpqcDFncm04SGQxR25L?=
 =?utf-8?B?cjVQODBpR1dPdGtTaCtnMDMvaUJMbjZscDI2U3FKbmRhTWV6bTRlTmFlRlh1?=
 =?utf-8?B?QUFrUFd0RzVTc0FtNHBHOGFKK1F0cjJsMnlZMmtianY3SEx1S3dicXNDQjcw?=
 =?utf-8?B?TENXUVh5RmNUcnY4Y0sxcE5iamNVYUx2UFJ0VGhQUEtoSzBiYjRqYnRLcTBY?=
 =?utf-8?B?MEJpUC9KS1M5Z0hUUUpQeU9xYlExWnp0VG5kc0pqWkd0L2Q0cUxoRlgwekl2?=
 =?utf-8?B?elpQaWdmQmxYN2p5ek0xQUs1ajVxL2RUL3BkbDZXWGQ0S0JHM0s5aEdkbk1D?=
 =?utf-8?B?L3gvMU92RWdOZ0F2MXI2Q0FhUDFhQkJJRlpERWZ6YWszZi9TSys4NEVSME1m?=
 =?utf-8?B?ZDMwbUFSaDhITFZPMDlRMVJCQmtEU1R5bG80Ny9IR2xtYWpwS1pkdzJJaGpP?=
 =?utf-8?B?L3AwUU03ZGdSZCtEYk1Edkw5OVBCdmpVV3hodVVLWXdUb0lWYVo5K2hYUmQz?=
 =?utf-8?B?VHNLVndObWVaMEl6Tnk2RHVySU5QM3QzRXJSR0U5Q0Zjc05jVXRDV3VxUUd4?=
 =?utf-8?B?YTNiempsTVVDOGJ5MENyWHIzZ0F4TG8rVmxRUVNyQks4WlJVK2xMRDUzcFly?=
 =?utf-8?B?bDFWRm9LelA1c013blhiR0ZWdVdIWFpyT2NnaE5MOW1VREp3RnRSRWF5RDlI?=
 =?utf-8?B?MEhnaEl4UTNHQTBsUFdYUktrUWluY1BtOG8xSmtVY21tZTZiMCtRZ3orM2pa?=
 =?utf-8?B?cWc5RW43aXZBdGxxU2t4eDZZazI3Q2xZb2tNR1B6dWNmQ3diOUtnYytCdDBO?=
 =?utf-8?B?d2NEUitDMUYwcjAzQnk4MmVXTGlmbG9zeUlaMEdyTmpacnh4SUViVlpsMnl1?=
 =?utf-8?B?bi9DQlRiNVZLaER2RFM3SSt0SStxdjJrVHZLNmFwNC9wNGhyRFF6c1o0OFBI?=
 =?utf-8?B?emk3enVrM1Z1R3paMVpmMlljUzV4RXptNEYwYlBYOFRwZXVkdjJBY2Y3b0pI?=
 =?utf-8?B?bStLaklPb1ZaYlEzZEc0b2tEZWhPZGZHbThReXVhRnhsNUVWMzNCTTM3MDk3?=
 =?utf-8?B?T3hpUGNDaDI3K2tEK2Q4cjJoUDJ3UGNLMlRTYVhxRXJMZXRKdTFHWUIvRVVt?=
 =?utf-8?B?ZVd5R0FROURGZ2k1VXlUWlh3WXRmOW5NUUIxVlBiWmRGM1FGZm9rWG5TZHRn?=
 =?utf-8?B?V2NtblZBYlZ4TUJLRnBWUjNFU1o0ZmlEQ09uUlBNbzdQMmc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkVsSnUxSnlIVnBIekpIbDMwVE54dnpBcEZXSTlURlk2MUFxaWZxdFNNUlky?=
 =?utf-8?B?RVRjdm5ncThOU29DYW5kQTZyMUhmUVdQckF2QzU5WGpZK2NranZFbEowQjZU?=
 =?utf-8?B?UjJ1SUkzU3lhalVJbWJXcmV2R1lPMEl6ZVJzdUgwUDdUU3RKd2ZrbnI5bERM?=
 =?utf-8?B?ZnB0N0kwa292QWtYNXVoK0pobm55dG5DcFFVUzEyeklhUTdWYi8vUVJxRi8x?=
 =?utf-8?B?cnVoT1o3aHlzek5UTk5wTW1YVEQ4dWVyNGRJQVRkT0Myc1pTTGNVODF5ak85?=
 =?utf-8?B?eXZhbHVRWFBRbkhjeXcrL1UwaFB1Y2ZHdVdKMDdLT0g4K3FaZjBsaGVDWGRa?=
 =?utf-8?B?OHpYUzVqNnJIb0RFK1FvQ0V5TXVMNkk5c0pvTTBLWDc4dnFELzJQaGVFTFBz?=
 =?utf-8?B?OUd6M2pwOEI3WDJhRyt5emNGeU55L3RvdzIyRnRWL0l1OW1USU1jcHJJdVJF?=
 =?utf-8?B?YkxoZ0lscStkV2xuN2dWeHZjQkM3NTlRaFhhbnlNOXpnV3NmTUtHTjdnY2NR?=
 =?utf-8?B?T2dsWmRWTHNiaTJxem02N3p3azRoSTBpMnBsUG9vKzV0VHpEZm5YRDhoamdm?=
 =?utf-8?B?VVdZNXlOQS9QcWQrejBCNXBBVU04L3lsM2laQ3M1YXhaNmRCR0s1NDQvYWZK?=
 =?utf-8?B?OVZaRHR3R3JXUjl0VGJXS0lreG8xWWN1RUJDVmlXOGhpUGZZQlY0MTJwbXdu?=
 =?utf-8?B?M2VwUHFiUzVGZVRGbkpjd2R6TmhwQVd2ZENhdVBNSFgzQ21iWW80VEdFM2NX?=
 =?utf-8?B?WVlDUmphOEgwV3IvMVdDMFpYZnFrK1AzYzNueTJFdnBldnZYek5jV1A4VzJP?=
 =?utf-8?B?Z0tvL2lOYllIVXFyZCtGM0Voakk1TnhrTDNsSnZKbTAzeGFPU2pZbFZsYWpW?=
 =?utf-8?B?UllDa2szc056Z3dueFkxUWEyVHM1dnArZUlqc2VUOWNDS2dXRjkwTjJFcG01?=
 =?utf-8?B?dXE1TWxZR2F2eGVnZHkvSnhaM1RKcGFockEzdzF2Wml1SjQxKzJLa3drUUhR?=
 =?utf-8?B?dGtlM1pSNVJ3R3hyRTIyVTFZUFlTRXgxdm8zVm12ZzhsQWczRjN6U2VyeTVv?=
 =?utf-8?B?cXg5NGtlR09scjJNWmZUakVQdXRMWEdONXNzRHBHL2lwaW5Jd25BcUpkQ2dj?=
 =?utf-8?B?Mm1GNmRPUEx0RUYyQ2E4bkhaRUFYSHVyNlNNei9FL2gyeFMwRHFWUWhVQXhK?=
 =?utf-8?B?blBVcWdoSEtLMlZSOVQzMHFtMHVTTU9DMURnT1gwNVVuYm5yNVJINFNLaWw2?=
 =?utf-8?B?cS92ek1hSnhPSk14d3JrK0t3Ynh1YU5oMFdKUW03L3FTd2lGWnptWGUyWnhm?=
 =?utf-8?B?bjBLLy9Ba3o2ekNQSmJoTGlkVURRbis5NXhQNWtDZ0Jlb0NpN2tkc0pOQy83?=
 =?utf-8?B?Ujd2Tmtla29hSWFncDVraXlWSHN3MmlOcUJxMDF2UlpENnhpOHFlbFIxTkVM?=
 =?utf-8?B?ZE95NUwzNEVmVFhGUnM3WE1idVJUZ0l5cjVCU2dtbGJHNy9qTVlyUzBPK3hW?=
 =?utf-8?B?SzRFbzF4c2ZmbTZrblJXY3BHNGJNUXJ2RTlTOVc5NytVQmY4cnRoekNEMisv?=
 =?utf-8?B?WStxK3Q0eldpTitHTHJ5SWRjVmo3ZlVZdmhLWDQ4a3NYQzNWMFhVUUZPcXZo?=
 =?utf-8?B?RVFpZUlWQ01zWmVXTVdZeklFS3ZpZUtqdVBDanRwb21kVm02OGFqY0VDS0hR?=
 =?utf-8?B?UGltdHY2d21GUlV3Zk5ocWgzZUVlRGlDR3VOQzNva2VJMy9hcjkvaHFZR3kx?=
 =?utf-8?B?cjhDZS83T20wL29TTnFQMExXT3JJMzVUaFdNZkU0NzdzWHBJRmI5TkRQRnZU?=
 =?utf-8?B?OE91MmZUOFRqR0JtWXJZd0pvNHdGNmNvNmI1T29ZeCtBdmNpYlI2R1JMMjBz?=
 =?utf-8?B?d1kvYWFVYStUdC8ySnFVR0tadHRBMXo3TnBScXE0V1VJdC9VU0lzWVhGKzVD?=
 =?utf-8?B?Z3ZlYVpUMFhrbUVSK1JoREp2ZVJXSG9ZKzI4bWNBSFdoanNpTkwvSzhva1hE?=
 =?utf-8?B?ejFQTFNucXhMVFBBZzd3ckF6Wld4TkFreVZJOFNyZE9jazdBNG5vUXlTYmxE?=
 =?utf-8?B?NUZ3UlNpclNCSHFzblQ2SFlkRnFLNmEzY1RpbkpQVTQwcVNCSXRQS1hIMEpn?=
 =?utf-8?B?UmtBeDJTTE4rK01jUVJva3I3VXU1clZvK283MEp2b3FHTnc4V1UzZXA2TGtI?=
 =?utf-8?B?N2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2B0E821C6FDDD4A8A31193B188CA153@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67546890-a346-4754-e207-08dcc7d319a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2024 02:34:26.1322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Sq0gc40IYkE4nzFjmJS8hxNLRswSATH3RMZjQ2nOcVwVDv66VZ2wPTa9DaUOaT/2dWWkfgrOiyN9O49/YTt/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6470
X-MTK: N

T24gV2VkLCAyMDI0LTA4LTI4IGF0IDEwOjEwIC0wNDAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOC8yOC8yNCA5OjQ2IEFNLCBQZXRlciBXYW5nICjnjovkv6Hl
j4spIHdyb3RlOg0KPiA+IDEuIElmIG9ubHkgVUZTIGNvbnRyb2xsZXIgY29yZSBkcml2ZXIgc2hv
dWxkIGRvIHRoaXMsDQo+ID4gICAgIFdoYXQgYWJvdXQgcmVnaXN0ZXJzIHRoYXQgYXJlIG5vdCBS
RUdfSU5URVJSVVBUX0VOQUJMRT8NCj4gPiAgICAgU2luY2UgdWZzaGNkX3dyaXRlbCBoYXMgYmVl
biBleHBvcnRlZCwgc2hvdWxkbid0IHRoZSBob3N0DQo+ID4gICAgIGRyaXZlciBoYXZlIHRoZSBh
dXRob3JpdHkgdG8gY29udHJvbCBhbGwgSG9zdCBSRUdzPw0KPiANCj4gSXQgaXMgbm90IGJlY2F1
c2UgaG9zdCBkcml2ZXJzIGNhbiBjaGFuZ2UgYW55IGhvc3QgY29udHJvbGxlcg0KPiByZWdpc3Rl
cg0KPiB0aGF0IGhvc3QgZHJpdmVycyBzaG91bGQgdGFrZSB0aGUgZnJlZWRvbSB0byBtb2RpZnkg
YWxsIGhvc3QNCj4gY29udHJvbGxlcg0KPiByZWdpc3RlcnMuIE1vZGlmeWluZyBob3N0IGNvbnRy
b2xsZXIgcmVnaXN0ZXJzIHRoYXQgYXJlIHZlbmRvcg0KPiBzcGVjaWZpYyBmcm9tIGEgaG9zdCBk
cml2ZXIgc2VlbXMgdG90YWxseSBmaW5lIHRvIG1lLiBJIHRoaW5rIHRoYXQNCj4gc3RhbmRhcmRp
emVkIGhvc3QgY29udHJvbGxlciByZWdpc3RlcnMgc2hvdWxkIG9ubHkgYmUgbW9kaWZpZWQgZnJv
bQ0KPiB0aGUNCj4gVUZTIGRyaXZlciBjb3JlLiBPdGhlcndpc2UgdGhlIFVGUyBjb3JlIGRyaXZl
ciBjYW5ub3QgYmUgdW5kZXJzdG9vZA0KPiBub3INCj4gdmVyaWZpZWQgd2l0aG91dCBkZWVwIHVu
ZGVyc3RhbmRpbmcgb2YgYWxsIHRoZSBob3N0IGRyaXZlcnMuDQo+IA0KDQpIaSBCYXJ0LA0KDQpC
dXQgd2hhdCB3ZSBhcmUgZGlzY3Vzc2luZyBpcyBhICd3b3JrYXJvdW5kJywgd2hpY2ggbWlnaHQg
YWxsb3cgDQptb2RpZmljYXRpb25zIHRvIHN0YW5kYXJkaXplZCBob3N0IGNvbnRyb2xsZXIgcmVn
aXN0ZXJzLCByaWdodD8NCg0KDQoNCj4gPiAyLiBTZXQgUkVHX0lOVEVSUlVQVF9FTkFCTEUgb25s
eSB3aGVuIGhpYmVybmF0ZSBleGl0Pw0KPiA+ICAgICBJZiBjYXVzZSB0aGUgVW5pUHJvIGxpbmsg
dG8gZXhpdCwgdGhlbiBpdCBzaG91bGQgc3RpbGwgYmUNCj4gY29ycmVjdCwNCj4gPiAgICAganVz
dCBleGl0aW5nIGhpYmVybmF0ZSBlYXJseT8NCj4gDQo+IFRoaXMgYXBwcm9hY2ggaGFzIHR3byBk
aXNhZHZhbnRhZ2VzOg0KPiAtIEl0IHJlcXVpcmVzIHRoYXQgZXZlbiBtb3JlIHN0YXRlIGluZm9y
bWF0aW9uIGlzIHRyYWNrZWQgaW4gc3RydWN0DQo+ICAgIHVmc19oYmEuDQoNCkl0IGNvdWxkIHV0
aWxpemUgYSBob3N0IHByaXZhdGUgc3RydWN0dXJlLCBsaWtlIHVmc19tdGtfaG9zdC4NCg0KPiAt
IFRoaXMgYXBwcm9hY2ggaXMgcHJvYmFibHkgaW5jb21wYXRpYmxlIHdpdGggdGhlIHBvd2VyIG1h
bmFnZW1lbnQNCj4gY29yZS4NCj4gICAgSSB0aGluayB0aGF0IHRoZXJlIGlzIGNvZGUgaW4gdGhl
IHBvd2VyIG1hbmFnZW1lbnQgY29yZSBmb3INCj4gZGlzYWJsaW5nDQo+ICAgIGludGVycnVwdHMg
ZHVyaW5nIHN1c3BlbmQgYW5kIHJlZW5hYmxpbmcgaW50ZXJydXB0cyBkdXJpbmcgcmVzdW1lLg0K
PiAgICBFbmFibGluZyBhbiBpbnRlcnJ1cHQgdGhhdCBpcyBhbHJlYWR5IGVuYWJsZWQgaXMgbm90
IGFsbG93ZWQuDQo+IA0KDQpQb3dlciBtYW5hZ2VtZW50IGVuYWJsZSBvciBkaXNhYmxlIGludGVy
cnVwdCBzaG91bGQgdGhyb3VnaCANCmRldmljZSBkcml2ZXIgaG9vaywgc3VjaCBhcyBzdXNwZW5k
L3Jlc3VtZSBjYWxsYmFjayBmdW5jdGlvbj8gDQpJIGFtIG5vdCBzdXJlIGJlY2F1c2UgTWVkaWFU
ZWsncyBwb3dlciBtYW5hZ2VtZW50IGRvZXMgDQpub3QgZGlyZWN0bHkgY29udHJvbCBpbnRlcnJ1
cHRzLg0KDQoNCj4gSW4gZ2VuZXJhbCwgZGlzYWJsaW5nIC8gcmVlbmFibGluZyBpbnRlcnJ1cHRz
IGlzIHNvbWV0aGluZyB0aGF0DQo+IHNob3VsZA0KPiBiZSBhdm9pZGVkIGJlY2F1c2UgaXQgaXMg
bm90IGNvbXBhdGlibGUgd2l0aCBtdWx0aXRocmVhZGluZy4gVGhlDQo+IHJlYXNvbg0KPiB3aHkg
aXQgd29ya3MgaW4gdGhlIFVGUyBkcml2ZXIgZm9yIFVJQyBjb21tYW5kcyBpcyBiZWNhdXNlIHRo
ZXNlIGFyZQ0KPiBzZXJpYWxpemVkLg0KDQpZZXMsIGJ1dCBlbnRlcmluZyBhbmQgZXhpdGluZyBo
aWJlcm5hdGUgYXJlIHByb3RlY3RlZCBieSANCmNsb2NrIGdhdGluZyBvciB0aGUgcnVudGltZS9z
eXN0ZW0gUE0gZnJhbWV3b3JrLiBUaGVyZSBzaG91bGRuJ3QgDQpiZSBpc3N1ZXMgd2l0aCBtdWx0
aXBsZSB0aHJlYWRzIGVudGVyaW5nIG9yIGV4aXRpbmcgaGliZXJuYXRlPw0KDQpUaGFua3MuDQpQ
ZXRlcg0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQoNCg0K
