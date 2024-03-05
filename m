Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF1E86659
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 12:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709643321; cv=fail; b=Yx/rbsjW8gAXV+b9sDwi+cYZ84kseDrzI3wJr2F2K/J3uqTSyDVOie5MzYXNYHOEkTLgWIYESlv2D9qStvMT1spn+pJWWmflbx5iwpldxinBVNLE4dLoeKqoIzcaMyMXvtKbANA1azbsKjZl5qEhcm+O+Hc04Ip8WzSOYUg5Atw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709643321; c=relaxed/simple;
	bh=5gG3wBPUl9MDGTsrtDG1k90vfeCJpdT0Lx1wqLOZaCA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ryY4E95d95p0leqVURQ99lN+gKgcGHt2bmmIGE0dfS0oKJBro0+L5dEW5SWzE6dsaGh2rLDJfEASK1z3r7qQB4j2PIWalnuR1zUY+iy9z2YbXh9LaUUmMdUvQJL6WAv9cmXT0WXOQ+4J03Jx9I5JEDkFbFtivGVfplsYJoR1dSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=QnDLnZRo; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Av0waQSO; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QnDLnZRo";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Av0waQSO"
X-UUID: 9b316798daef11ee935d6952f98a51a9-20240305
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=5gG3wBPUl9MDGTsrtDG1k90vfeCJpdT0Lx1wqLOZaCA=;
	b=QnDLnZRoGzfZfzS9fI38DzQA5VgSF5/8Cc6xrlgwC9vLzCh4bSzax1dnIY8P4Yy8qO1hNXgeBzsVScSq3PTeb2eo6Ma0ivQvlR9ArbCjsOG8bOSSEbqd66uD0w7ZfmzY9r5BrxLCLlP7zM598UQgBzs0D+RX2ytj6msMX4to6Q0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:e84d7f67-2df4-471e-9790-f6ead0b5b17d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:b60ba484-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 9b316798daef11ee935d6952f98a51a9-20240305
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 266833544; Tue, 05 Mar 2024 20:55:13 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 5 Mar 2024 20:55:11 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 5 Mar 2024 20:55:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkfRgV+kVT4+4UzTLTN5foMTbxURcXAS18W57xxhqjFGnIskfXSuQFb1hmu/x9QwS+PQp/lKCsLpH9ZBKaswfY2kSGJjOZ+5l1nvgFR3bXUgPDMOFui1mqtMjV1bKg1TRNu6QPObjCjsaKzr9LRwhBTC+9oyS6f3Fj5ErUWeZeCqpUQF8vCDiyNyqwjWwwkesmhztvIvLY8UruodrgmMelVAu5eS4fyRK1z96bcC0HcK/sOWfYs29qkq4FMbzQRfp1HLRKbDJCqZxTgnAbPKBCsFrVtMtHx2y8h6sd0KL0b9VQupheb/cAxKyKpyV7ZhkfETEl62qkno6wf8u1byKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5gG3wBPUl9MDGTsrtDG1k90vfeCJpdT0Lx1wqLOZaCA=;
 b=bOpsRvO7kGJ6ZGBavsvxtUc73K8eh6OGNqU7PDZfmtVBxXLXOUBgURa6PUaUXuu3DEc1MKgZO+nnNtZgs5l8aEcTYrApRFH0eD8bJtIg/BzOuVv7oqVVT/N/oiMYZAt22OhqvWqVQrHtVF9cszF25zqEfxYWheJoD5eT9WItJs4dBW7Rg3nD7jILaGp9muaddZHYXR2Ot7mJ5WvLiDwf6Wvog+J0UgxBZ4WjktfmGcsfE6S/NX4FTiVQz5Lm1m5c2EY3JHR7ZDNwdi8w8vOFFitf3TlxhbQSQPXBWtUnV+XIEco9wrAnJdqylwgfutIz8l4ueYTpCU5qsWzIkIOnEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gG3wBPUl9MDGTsrtDG1k90vfeCJpdT0Lx1wqLOZaCA=;
 b=Av0waQSOLY3WttUlB4eXC9g2lnslBoxIzvS95oEcgRLm5UPwtND+4Fpbfw7/6Qm8aLaKEPLlnommjOIJ6guN7c7pIlwRPZpWIGLTWx62pZFaSg5ycBEYXvzT7XRGRPrnK454u3uU1oL7INLdsGpWDoHfCtX41DpxED7lQAp087o=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6605.apcprd03.prod.outlook.com (2603:1096:400:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Tue, 5 Mar
 2024 12:55:08 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::9756:b4e8:ff47:55c4]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::9756:b4e8:ff47:55c4%3]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 12:55:07 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "jejb@linux.ibm.com" <jejb@linux.ibm.com>, "quic_rampraka@quicinc.com"
	<quic_rampraka@quicinc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
	"quic_sartgarg@quicinc.com" <quic_sartgarg@quicinc.com>,
	"quic_bhaskarv@quicinc.com" <quic_bhaskarv@quicinc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"quic_narepall@quicinc.com" <quic_narepall@quicinc.com>,
	"quic_pragalla@quicinc.com" <quic_pragalla@quicinc.com>,
	"quic_cang@quicinc.com" <quic_cang@quicinc.com>
Subject: Re: [PATCH 1/1] Revert "scsi: ufs: core: Only suspend clock scaling
 if scaling down"
Thread-Topic: [PATCH 1/1] Revert "scsi: ufs: core: Only suspend clock scaling
 if scaling down"
Thread-Index: AQHaagfdnu/7dWEB3EK21x4WVKWgnrEg9A2AgAfVtYCAAFrfAA==
Date: Tue, 5 Mar 2024 12:55:07 +0000
Message-ID: <768897ca7336df5b159c7d39e467b5b74f49b3b4.camel@mediatek.com>
References: <20240228053421.19700-1-quic_rampraka@quicinc.com>
	 <a585c5a82fdb36b543d48568d0c5ae1265642f26.camel@mediatek.com>
	 <bd253a59-de58-2184-a818-82ef1ed8c962@quicinc.com>
In-Reply-To: <bd253a59-de58-2184-a818-82ef1ed8c962@quicinc.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6605:EE_
x-ms-office365-filtering-correlation-id: e421c06f-29f2-4ca9-4b0a-08dc3d137c53
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bBL6892muGLhCzNqij32vlhbQ0l4HtUbUmeaGcCi2YCx4JkRsgIUXIkMk+mtMycj742n/ZSkrBhM5nMA6kudKlazUiZiXe4okEUr5br1IdAIbsuJR7KIyQP4zpbkDh+0Zvns32hrkPCwjkw2kTNbx3gkXyYj8TrdnfO2AaDiVgdJ4Q2WPpHWI60MbOLwaN//yeAUG7zaYsIHmY2m9ZZgAbHJ0krpP+25DhNfgmJrzE/+9T1Vl8rbvLgGiWHTEJ2lloZ9UH9tVji9j3JJQtSPNDfZ4e5B+I6E2Ru6+ioqYfi2LD9SU0QkUEGMtve7VdcHZ0Os1FtQdNun0hu6gDnHYYuyI+ZGCD20Pi22dKcXXTPu+nvzGerAMiFbo80bmCaqQsG70EZXV1tX07XXFP+5zhN36+64AeMQ0VDVg5aB+ZyjjCsssLP1fh4M7/8VO8wmuleGJz+rayewrLU5hxBhDf94wjNBqzfyDZzUHXI2Z1wdEqF/NNs1DVfCHIob/+6x78D6fZV0JhdNL2bxvdwoXfaK1pzdlvcIEqbuK8fcZieicVH+dQP4KgH9FenHrSoPr3bpY2tWp+rkfKtErGMcrz4yPEmpf4GuXEmTdQY/HdXUqSk1QklZav+pwt4sHt/srVg1naTFHz1W0fuj2B14CTvIq8FijH+lGTgL/pB3j5oiGq4CTn+J/baryyvV09+iQMXEucgX72a59wxEZ8sX4IwwU0OU3jz519QXCGSEqTU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZEkrUHJpMGp1ODRYNzl3c1NIWUxoSWkzZzg0c2hwdFVSSGQ3VFNyOGJuSnJ2?=
 =?utf-8?B?N0twTHNxd2piajZCUkZPa2dDMzd6VFZQVDBJbFhvMnMwL0pHUXhrdFBpdWdM?=
 =?utf-8?B?RnlVcTZVOWR6OVVKWlZ5OUZuaVJvclNNZDEyRHVkUUM3RWxYeVV2TTdiQUwv?=
 =?utf-8?B?d2RBbDZlWHVFdENGY3lzUDV6eSsrTG5ubGU4TWk4aU5DemNmRGZBQndOL2JQ?=
 =?utf-8?B?TjJJczhNRVVBTENtb0M2Rm8yTG9LTnhjWWRsazdST05TZ1pYZjdjYjM2cVpN?=
 =?utf-8?B?WTdaWU9IVFQrMHpmMFpja1pIWjFxWncxTmRrMHozYTJCTDhoTEpwVjJiZklK?=
 =?utf-8?B?Ri9DdHh5ODd0WWlZQVdpVlBvRFgyRUZydTNMS1NPdEpYNm5COWo3b2VXem5o?=
 =?utf-8?B?VU54QWpxYjZBUENXTk1LSWhGTEdPdFNXaWN3RjY5UTBsRzUrMTBjN0VOaFpR?=
 =?utf-8?B?Tk1xRHF5a1FSZllWbzFHbHlQeTFjNWlTdEpqaXdIUDBYZS9QRkNJK1kvVG5Z?=
 =?utf-8?B?empJOGM0SjRXaXR4UFR3bnlDR3E3TkNmdnpkTHVoK1pucUFMNGVWTmtFTW5x?=
 =?utf-8?B?MytNc29OcTJUTitEak5TZnQ1VnQ4dlZSN1ZSTGNHa3dOTnZocm5pSkYrWXpY?=
 =?utf-8?B?eDJEUUhHNkRUbUpoSTd3R2VPZlpvbzNjdFNHLysrdlQ1QXlKekxCUXo0Q2RT?=
 =?utf-8?B?Wm1hazh2MXZBcHNJazlRaXhDckRkbFVxSksyQzVUWFc5TkY0cG9zR3lVTStS?=
 =?utf-8?B?ZHVGK2g2Q1c1Mkh6WUVLVzNEVDdSV1NQSjFIY2tzS2svcm54NnRSTitZaFBk?=
 =?utf-8?B?ZEtLR05PSWlXT1JkbThld1FuQTAzOHNmZDlVMVdIbGUzV2lVWGNldk9KS0FW?=
 =?utf-8?B?UmJ0VXExVFBTOWJMNXdFSi9tL3E3T0g5VUI5MUgrL2Q1Mnl2NDY0U3ByWlh6?=
 =?utf-8?B?WGNHdDA2K0Q0RFBOVjJqNEpkMVV5OTA1OWNYNW5kRlF3M2dRQkE3ZU9sRllp?=
 =?utf-8?B?dDhhOG1uL2xvQUZ2c0Z0SVpEbTU5SUNSTlVMa3ZoNmJZY2p0WC9oSGw0SGtX?=
 =?utf-8?B?TFRYTzZnR1lyd2VSZlN4VGw3alRlK0QvajRCbStRcGJuVmZiNFd1aUw1RVhq?=
 =?utf-8?B?R2R2RDg5MzVER01La2dWRVhmRDdEc3AwNzZDZ3l6QXRZUlZQMHZOWW1ZLzRs?=
 =?utf-8?B?UEd6OVJBRG5wN2hVbGlNUnhYd2V4Y2ozaXBjSE1oelYzT2VhUUk2YzBoZ3d6?=
 =?utf-8?B?T2ZRbEtGdURCUEtWYVhESXdxVzFGWVRSMmZnZjRzN0pVdFRFeWhpQ24yakpE?=
 =?utf-8?B?ckpKSUtRMVRYOWRRWTBtZTRkMGFEdUZ3K3FHTzFPcFA4OTQ0QW1oem5QWUJi?=
 =?utf-8?B?YXNRRHZJS01yZlFCOU0xUExYalVQemkwZE15NGpDZkIzNmVWM1BDRjJ3SXAx?=
 =?utf-8?B?S0VqRXpHVUpSQ1J4UXRtRWIvZmpiYnpROU4yUjBXbm1seEN6VHlHODEwcXZv?=
 =?utf-8?B?a085b1ZnZ2lUSmxZdDA5SHNLWXBQZXNBVXVqNnFBeG9NRloyM0o3MFBvR2xJ?=
 =?utf-8?B?elhyRlVzUkZmcGFEV3RPL2g1UFE3N1dycllDNHdzSTRwTzAwQVphVEMra3RH?=
 =?utf-8?B?OWNsVjBnRkp6cHVieFQxcE9nM1FSYnlJVzFPYmdIemhzM0hiWHJDektJZVAw?=
 =?utf-8?B?ZGF4UmRNeVVlUUJSbkp6M21iV2F1ZGlxcUUyb0loc2tZTlphUVBvUmRUWko1?=
 =?utf-8?B?UWsrVzdmQTlmeWpQSWlncTdKNDlmSktOTXJseGsydUtTUm1HNGMweEVwTzNw?=
 =?utf-8?B?ZU5QL0I5amJVZzNTWEdpcXppeW9zWFhjT0ZHbGh2aEc0c0JtL3Rwd1hULzdL?=
 =?utf-8?B?bmhJMXk2T29FS0NRaFNYaDl6K2JMOFFoSmJYaFVNS0l6MXNFYzFkRmo4K3dL?=
 =?utf-8?B?ODl4NVZWNlo2SmlvQmJkVXFxZDA5U1JzUE9nNFoySVNXRnFVNGVFcmdiOVhP?=
 =?utf-8?B?YkxuVHFLRGpseG5MMmgrelFiV1ltdER1OFhvb044TFZ4em1LcWRMZnJuMEl3?=
 =?utf-8?B?ZFpzenpZWkdkVVRVeTFxbXpVaVFzMEZZaDhxWkdMSHZGYlNNZHpXeVJWQWpp?=
 =?utf-8?B?M1FvL2d1RCtWTlhmL1R2anlLNFhxNWVtMTkwcHlJRTdCWmtkTmxiWFdhdVA0?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09EADF3D69B43544A03D2C3C3692F1C0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e421c06f-29f2-4ca9-4b0a-08dc3d137c53
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2024 12:55:07.7281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dbRALsxd0J7zdz1iEq2gZysKMO2+e5CAU4vf9uF1zJlSgMrK2vVIJsvL/pKq/2nwBEhM8TtzTsLeuR+Fuq0brA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6605
X-MTK: N

T24gVHVlLCAyMDI0LTAzLTA1IGF0IDEyOjU5ICswNTMwLCBSYW0gUHJha2FzaCBHdXB0YSB3cm90
ZToNCj4gIAkgDQo+IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBv
ciBvcGVuIGF0dGFjaG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIg
b3IgdGhlIGNvbnRlbnQuDQo+ICANCj4gDQo+IE9uIDIvMjkvMjAyNCAxOjIxIFBNLCBQZXRlciBX
YW5nICjnjovkv6Hlj4spIHdyb3RlOg0KPiA+IE9uIFdlZCwgMjAyNC0wMi0yOCBhdCAxMTowNCAr
MDUzMCwgUmFtIFByYWthc2ggR3VwdGEgd3JvdGU6DQo+ID4+ICAgDQo+ID4+IEV4dGVybmFsIGVt
YWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzDQo+IHVu
dGlsDQo+ID4+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhlIGNvbnRlbnQuDQo+
ID4+ICAgVGhpcyByZXZlcnRzIGNvbW1pdCAxZDk2OTczMWI4N2YxMjIxMDhjNTBhNjRhY2ZkYmFh
NjM0ODYyOTZlLg0KPiA+PiBBcHByb3ggMjglIHJhbmRvbSBwZXJmIElPIGRlZ3JhZGF0aW9uIGlz
IG9ic2VydmVkIGJ5IHN1c3BlbmRpbmcNCj4gY2xrDQo+ID4+IHNjYWxpbmcgb25seSB3aGVuIGNs
a3MgYXJlIHNjYWxlZCBkb3duLiBDb25jZXJuIGZvciBvcmlnaW5hbCBmaXgNCj4gd2FzDQo+ID4+
IHBvd2VyIGNvbnN1bXB0aW9uLCB3aGljaCBpcyBhbHJlYWR5IHRha2VuIGNhcmUgYnkgY2xrIGdh
dGluZyBieQ0KPiA+PiBwdXR0aW5nDQo+ID4+IHRoZSBsaW5rIGludG8gaGliZXJuOCBzdGF0ZS4N
Cj4gPj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogUmFtIFByYWthc2ggR3VwdGEgPHF1aWNfcmFtcHJh
a2FAcXVpY2luYy5jb20+DQo+ID4+IC0tLQ0KPiA+PiAgIGRyaXZlcnMvdWZzL2NvcmUvdWZzaGNk
LmMgfCAyICstDQo+ID4+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pDQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5j
IGIvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiA+PiBpbmRleCBjNDE2ODI2NzYyZTkuLmY2
YmUxOGRiMDMxYyAxMDA2NDQNCj4gPj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0K
PiA+PiArKysgYi9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+ID4+IEBAIC0xNTg2LDcgKzE1
ODYsNyBAQCBzdGF0aWMgaW50IHVmc2hjZF9kZXZmcmVxX3RhcmdldChzdHJ1Y3QNCj4gZGV2aWNl
DQo+ID4+ICpkZXYsDQo+ID4+ICAga3RpbWVfdG9fdXMoa3RpbWVfc3ViKGt0aW1lX2dldCgpLCBz
dGFydCkpLCByZXQpOw0KPiA+PiAgIA0KPiA+PiAgIG91dDoNCj4gPj4gLWlmIChzY2hlZF9jbGtf
c2NhbGluZ19zdXNwZW5kX3dvcmsgJiYgIXNjYWxlX3VwKQ0KPiA+PiAraWYgKHNjaGVkX2Nsa19z
Y2FsaW5nX3N1c3BlbmRfd29yaykNCj4gPj4gICBxdWV1ZV93b3JrKGhiYS0+Y2xrX3NjYWxpbmcu
d29ya3EsDQo+ID4+ICAgICAgJmhiYS0+Y2xrX3NjYWxpbmcuc3VzcGVuZF93b3JrKTsNCj4gPj4g
ICANCj4gPj4gLS0gDQo+ID4+IDIuMTcuMQ0KPiA+IA0KPiA+IEhpIFJhbSwNCj4gPiANCj4gPiBJ
dCBpcyBsb2dpYyB3cm9uZyB0byBrZWVwIGhpZ2ggZ2VhciB3aGVuIG5vIHJlYWQvd3JpdGUgdHJh
ZmZpYy4NCj4gPiBFdmVuIGhpZ2ggZ2VhciB0dXJuIG9mZiBjbG9jayBhbmQgZW50ZXIgaGliZXJu
YXRlLCB0aGVyZSBzdGlsbCBoYXZlDQo+ID4gb3RoZXIgcG93ZXIgY29uc3VtZSBoYXJkaHdhcmUg
dG8ga2VlcCBJTyBpbiBoaWdoIGdlYXIsIGV4LiBDUFUNCj4gbGF0ZW5jeSwNCj4gPiBDUFUgcG93
ZXIuDQo+ID4gDQo+IEJ5IENQVSBsYXRlbmN5IGFuZCBwb3dlciwgZG8geW91IG1lYW4gdGhlIFFv
Uy9idXMgdm90ZSBmcm9tIHVmcw0KPiBkcml2ZXI/DQo+IGlmIHllcywgaW4gdGhhdCBjYXNlIGlm
IGNsayBnYXRpbmcga2lja3MgaW4sIGl0IG1lYW5zIHVmcyBpcyBhbHJlYWR5DQo+IGluIA0KPiBo
aWJlcm5hdGUgc3RhdGUgYW5kIHRoZXJlIGlzIG5vIHBvaW50IGtlZXBpbmcgdGhlIHZvdGVzIChw
bSBxb3MgJg0KPiBidXMgDQo+IHZvdGVzKSBmcm9tIHVmcyBkcml2ZXIuIEFuZCBhcyBwYXJ0IG9m
IGNsayBnYXRpbmcsIHFvcyBhbmQgb3RoZXINCj4gdm90ZXMgDQo+IG9uIFNvQyBjYW4gYmUgcmVt
b3ZlZCB0aGVuIG5vIHBvd2VyIGNvbmNlcm4gd291bGQgYmUgdGhlcmUuDQo+IA0KDQpOb3Qgb25s
eSBwbSBxb3Mgdm90ZSwgYnV0IGFsc28gdmNvcmUgcmFpc2UgaXMgbmVlZGVkIGZvciBtZWRpYXRl
ayBodw0KZGVzaWduLiBBbmQgdGhpcyBjb3JlIHZvbHRhZ2UgaXMgdXNlZCBmb3Igb3VyIGVudGly
ZSBTb0MuIFdoaWNoIG1lYW5zDQpUaGUgcG93ZXIgaW1wYWN0IGlzIHZlcnkgaHVnZSBmb3IgbWVk
aWF0ZWsuDQoNCg0KPiBOb3cgd2l0aCB5b3VyIGltcGxlbWVudGF0aW9uLCBzaW5jZSBzY2FsaW5n
IGlzIG5vdCBzdXNwZW5kZWQsIGluDQo+IG5leHQgDQo+IHdpbmRvdyBvZiBkZXZmcmVxIHBvbGxp
bmcgd2lsbCBnZXQgbG93ZXN0IHBvc3NpYmxlIGxvYWQgd2hlbiBhY3RpdmUgDQo+IHJlcXVlc3Qg
Y291bnQgaXMgemVybywgYmVjYXVzZSBvZiB3aGljaCBkZXZmcmVxIHdpbGwgc2NhbGUgZG93biB0
aGUgDQo+IGNsb2NrLiBTbyBuZXh0IHJlcXVlc3Qgd291bGQgYWx3YXlzIGJlIGNvbXBsZXRlZCB3
aXRoIGxvdyBjbG9jayANCj4gZnJlcXVlbmN5LCB3aGljaCBpcyBub3QgZGVzaXJhYmxlIGZyb20g
cGVyZm9ybWFuY2UgcG9pbnQgb2YgdmlldyANCg0KSWYgYSBwb2xsaW5nIHBlcmlvZCB3aXRob3V0
IGFueSBJTyB0cmFmZmljLCBpdCBzaG91bGQgc2NhbGUgZG93biByaWdodD8NCklmIElPIGlzIGJ1
c3kgdGhlbiBzY2FsZSB1cC4gDQpJZiBJTyBpcyBub3QgYnVzeSB0aGVuIHNjYWxlIGRvd24uDQpJ
dCBpcyBiYXNpYyBsb2dpYy4NCg0KDQo+IHdoZW4gDQo+IHBvd2VyIGNvbnN1bXB0aW9uIGlzIGFs
cmVhZHkgdGFrZW4gY2FyZSBpbiBjbGsgZ2F0aW5nLg0KPiANCj4gPiBCZXNpZGVzLCBjbG9jayBz
Y2FsaW5nIGlzIGRlc2lnbmVkIGZvciBwb3dlciBjb25jZXJuLCBub3QgZm9yDQo+ID4gcGVyZm9y
bWFuY2UuIElmIHlvdSB3YW50IHRvIGtlZXAgaGlnaCBwZXJmb3JtYW5jZSwgeW91IGNhbiBqdXN0
DQo+IHR1cm4NCj4gPiBvZmYgY2xvY2sgc2NhbGluZyBhbmQga2VlcCBpbiBoaWdoZXN0IGdlYXIu
DQo+ID4gDQo+IEkgdGhpbmsgaXRzIGFib3V0IHN0cmlraW5nIGEgcmlnaHQgYmFsYW5jZS4gQW5k
IGlmIHRoZXJlIGlzIHJlYWxseSBhDQo+IGJpZw0KPiBwb3dlciBjb25jZXJuIG9uIG1lZGlhdGVr
IGJvYXJkcywgY2xvY2sgZ2F0aW5nIGNhbiBiZSBtYWRlIGJpdCBtb3JlIA0KPiBhZ2dyZXNzaXZl
IHRoZXJlIGJ5IHJlbW92aW5nIHRoZSBhbGwgdm90ZXMgKHFvcywgYnVzKSBmcm9tIHVmcyBkcml2
ZXINCj4gb24gDQo+IFNvQyBhcyBwYXJ0IG9mIGNsb2NrIGdhdGluZy4gQWxzbyBpcyBjbG9jayBz
Y2FsaW5nIGRpc2FibGVkIG9uDQo+IG1lZGlhdGVrIA0KPiBwbGF0Zm9ybXM/DQo+IA0KDQpNZWRp
YXRlayBoYXMgdXNlIGNsb2NrIGdhdGluZy4NCkJ1dCwgdGhlcmUgc3RpbGwgaGF2ZSBhIHdpbmRv
dyBhZnRlciBlbnRlciBhdXRvLWhpYmVybmF0ZSBhbmQgY2xvY2sNCmdhdGkNCm5nLiBUaGlzIHdp
bmRvdyBwb3dlciB3YXN0ZSBpcyBub3QgcmVhc29uYWxiZS4NCg0KDQo+ID4gRmluYWxseSwgbWVk
aWF0ZWsgZG9zZW4ndCBzdWZmZXIgcGVyZm9ybWFuY2UgZHJvcCB3aXRoIHRoaXMgcGF0Y2guDQo+
ID4gQ291bGQgeW91IGhlbHAgbGlzdCB0aGUgdGVzdCBwcm9jZWR1cmUgYW5kIHBlcmZvcm1hbmNl
IGRyb3AgZGF0YQ0KPiBtb3JlDQo+ID4gZGV0YWlsPyBJIGFtIGN1cmlvdXMgdGhhdCBpbiB3aGF0
IHNjZW5hcmlvIHlvdXIgcmFuZG9tIGRyb3AgMjglLg0KPiA+IEFuZCBJIHRoaW5rIHlvdXIgZHZm
cyBwYXJhbWV0ZXIgY291bGQgYmUgdGhlIGRyb3AgcmVhc29uLg0KPiA+IA0KPiBUaGVyZSBpcyBu
byBzcGVjaWZpYyBlbnZpcm9ubWVudCBvciBwcm9jZWR1cmUgdXNlZCwgSSBhbSBqdXN0IHVzaW5n
IA0KPiBhbnR1dHUgYmVuY2htYXJrIHRvIGdldCB0aGUgbnVtYmVycy4gQW5kIHJhbmRvbSBJTyBu
dW1iZXJzIGFyZQ0KPiBkZWdyYWRlZCANCj4gYnkgYXBwcm94IDI4JS4NCj4gDQoNCkhhdmUgeW91
IHRyeSBhbm90aGVyIGR2ZnMgc2V0dGluZz8gDQpGb3IgZXhhbXBsZSwgZW5sYXJnZSBwb2xsaW5n
IHBlcmlvZCB0byBtYWtlIHNjYWxlIGRvd24gaGFyZGVyPw0KDQpBbnl3YXksIEkgdGhpbmsgaXQg
aXMgbm90IGNvcnJlY3QgdG8gYmVuZWZpdCBmcm9tIHBlcmZvcm1hbmNlIGdhaW4NCnRocm91Z2gg
YSBrZXJuZWwgYnVnIChzY2FsZSB1cCB3aGVuIG5vIElPIG9uLWdvaW5nKQ0KDQoNClRoYW5rcy4N
ClBldGVyDQoNCg==
