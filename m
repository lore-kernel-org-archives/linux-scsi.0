Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24295502B2
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 09:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712914485; cv=fail; b=POLUCtlnjo7rrThjYPD3yR74clfXMAKejz8MqU7KT1sVlATVpVqmKXuSGRhUv/a3znwriIsggpctRvw91t+6NIUE4juScsavSwc005s1JiDof+Lw2a9J7APag4/yRWVcKRkHXGUDH0WyoF6Fl0XlSYQLs/UUSkbasyFEGydcr98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712914485; c=relaxed/simple;
	bh=va7J5qjv0NqN5irLn+WZxsVg2qFWP0WlZoMlfrez2Mc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s/BH70J0FyQc+q8RhmgUfvsbzhxo0Du3rgQ9wdaOt12N6hk5XhYqlxGSsZGWjCkAegpraQxKKqph1c9UuClNp+Kaxx1ckMU8RUyGRPr6sYgz7ngqL8PkR/lCOg85SEs7IxCvRGiQ7e1ZH0z6WePHE/351BJFZAG+Nv3txng7Dxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=scU5uYuY; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=eKLKJS+v; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="scU5uYuY";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="eKLKJS+v"
X-UUID: e15ebe0ef8af11ee935d6952f98a51a9-20240412
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=va7J5qjv0NqN5irLn+WZxsVg2qFWP0WlZoMlfrez2Mc=;
	b=scU5uYuYcxYYCCXfPmX9zu9FKUzyalThA9SzfYRsWlI7Voz0cTIbBwZPN9KQ+hwG6t/OagvC7pNLypXR91tUMAmCEjGfQp7lK4mIYfNHR8BGc/CTaiezsvtRS3arNFC2UcAHHjblSDI8qbAACG6Bm0m5Jwcyd+tGnTXnx/o0O8Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:f6328715-f763-4765-8880-36d34bb5084e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:163a9982-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: e15ebe0ef8af11ee935d6952f98a51a9-20240412
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1854584719; Fri, 12 Apr 2024 17:34:37 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 12 Apr 2024 17:34:36 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 12 Apr 2024 17:34:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGIP5Z1HiUXss8zFj2hV4FZ8FzPsqVkmPIEgD9F9wvW42T+8VE3mPdJ2S9FLtK1NHf4zN61cY23m8LBKo+eMMLtfYwY8gAHSQIB2uNuEq2Z54hjz5ZII76T0jlItZEYG/HTD5yGs8U+TSGf8olVuUYrQG//3DvusklTDX4w2aCGn7E1xr1Ra836IEWdkHXxCwn/kusRu1DX0S4VktwEL+bvyRZiaH3VaQfxb1szovOYDh5XEmUrpoYSBWoUGMlr7ta6e/XuPL5PI4ckXNhpfwQFNzRJAG95kYtaun8zDsjyWwuyJ0Zi1nP3tKjEQme460smu5FSpLl/QEfcraU4WbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=va7J5qjv0NqN5irLn+WZxsVg2qFWP0WlZoMlfrez2Mc=;
 b=Z78K990BWgq842obERFyoO1olMrUB1gNGP8DdT/qzDK0yBzc+LWu/K7M4yAhJfSrfZXjCWkcR4ymNFcFr6JYYw86j1BuwzFKshtmaAggkQYLFQbMQCMMeZMYqwMn0cbnZutYsgs6oawIk/aHfnQQdb5P+HFCpMQN4+AMCtaRSk0GGmIAS5dLMLqOmjHewB7LqluQgOjZc7uJIznCvwsg/xdm2wMxaJkfn3C25W1z+R0wmEg4qFIgm/awF/Z3aaYe7ctgcAlGYEhPx3H9sirjUXHdblxG7TT2XWepZT4xD7rQDACBTDI+gWd88ihsTcuk+x0agczlyVugelJJttNSJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=va7J5qjv0NqN5irLn+WZxsVg2qFWP0WlZoMlfrez2Mc=;
 b=eKLKJS+v3rXKjMblcde7Mlk9OpTzKy/tCWYPw3KfNaDdOhwv3JZZ0Hp28XeP43JSf1sa4UZ+SezNLYOHP+NmW5qDBuC9Ayywg8Xti9u8VfwJCtp56ZZK2A1T1rzAAvbppAUn0shJkkPAb+R6TGE8aP4Z+cwVPX865s1zFfJGLS8=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by SEZPR03MB7659.apcprd03.prod.outlook.com (2603:1096:101:126::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.54; Fri, 12 Apr
 2024 09:34:34 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::dcdd:6cf0:8378:c97b]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::dcdd:6cf0:8378:c97b%3]) with mapi id 15.20.7409.042; Fri, 12 Apr 2024
 09:34:33 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>, "quic_cang@quicinc.com"
	<quic_cang@quicinc.com>
Subject: Re: [PATCH 4/4] scsi: ufs: Check for completion from the timeout
 handler
Thread-Topic: [PATCH 4/4] scsi: ufs: Check for completion from the timeout
 handler
Thread-Index: AQHajGzppont71hzWEqQ9WwNteSVpLFkYGSA
Date: Fri, 12 Apr 2024 09:34:33 +0000
Message-ID: <10541ba3421bf6d6228add4d87a682abd56e7e35.camel@mediatek.com>
References: <20240412000246.1167600-1-bvanassche@acm.org>
	 <20240412000246.1167600-5-bvanassche@acm.org>
In-Reply-To: <20240412000246.1167600-5-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|SEZPR03MB7659:EE_
x-ms-office365-filtering-correlation-id: df82cc9d-eb2b-4009-1be2-08dc5ad3c32d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jvzsTcjZkXtee3Six2mMh0arc+89uFz/duO8SaVvEruBYi1Qssxo6DIPbfqTqC65fm6H69gC/tnf9BrbE627lhgrHyKmhKlOeB53oal514pGoRR50fFkGi2kDYFsvhaIKyC+9xORD7fgoPq4ys8hok6T3qYXVv42OEZYL1QJ6rabMl26cVRF6OLOmKH4cZUSo+yFaJIfO7VxOiuUNbvQT4V37jpkV8wWNCzySwHQCViQAr3vB5Tp8EgOr4bOK4orDuZczsHmZ8+PYvkAcRnbNUdgQXwkLufw3fz6MsqoYGyjYCDhpc1ErNsmqovmW+DP52QvxrZTJuO1zsAXZmzdiWRSM3wOaGMdQfZpy/r6qFQjHmVhNx2qtoc5lXU5w+bqQy0Q34X9v6mjbgPOdPTUUYi5Z5lFQgysBrTomlbmnHtFKJeEK0waOW8l66oW2o8RnQRHhz4uwmr42M2wNIa4W0TMW7XQuLa3D/BDPjSHfWCMeRA6oQpU142WhzHxm9dE46sRMeTF+TCAsvPCfYaUCW8dJ2Jvx+o00DI3X62DpkOZEEPumAiEfzg3h9ydmj7JV8ETg+nhkjqTIY1my0kEIq62dg1mBA8hZ+ggZ1P/pbc65F7qCF01Rz4gUvq4CUq8tvT/rqlACMuV2GR9i4yBAqcuo2md7OKtS3eNQbfcCPn2gBCuHlT3Ih8JRkqH8VXsww+krDadtwz8vWGWZpsQnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cjlGYzQ3R3BMU08wQWY4Q2I2WHFSZDdJZndnaTYwVmJ4Uk5FS3gzT0MvQ1I0?=
 =?utf-8?B?ZWFGdlpuY0VqUlNncmtBUVJsZ2MySVBoUU0xU1dqYm9DZXhERWpvOTR4ZTR6?=
 =?utf-8?B?bmN3WEJwUVlPU3NpMy95OHZ0Ny95aEp0TFFPMWthTE1JZXNETldRR2Y2R3NJ?=
 =?utf-8?B?b1g4YmZTc1RlNVpFdklxTzAwWjNJWGZZSHRhd1NzWERibytxY3ZudUtXSW16?=
 =?utf-8?B?UldCd2I5K2V0Y05NSG9MYXRhWm8vN2c2SEVpTUFab0xqTk9aWW9zdW9EdjlR?=
 =?utf-8?B?cjN3RitIajhrSjNmV2VIRlprOEFFWnZ2N05nMWFUM0ZIVS9SRG1FOEFoWlcw?=
 =?utf-8?B?QzhDZ3ZpQTF1VnV3WTRyNzFSR0cza3U0UkpvOCtTd0V4TXBhdER0Qm1lQUZW?=
 =?utf-8?B?RGFUcEdWRzBocG5qYjRTdEVOWHd0UUtOQ3B5VWNUZEtFcG9HWVJabjN0ZXZV?=
 =?utf-8?B?Rm9xbHpjV29pSW1iTldUTHc5c2lPeUJHTGZwSGFJek5SbFVNd2M3QlJEMFQ4?=
 =?utf-8?B?bWhGeHdyUHpTVWNuNDlnY09rSWkxa3V0TGcxL3NBWGlzR05NWU1KbDhEK2Q0?=
 =?utf-8?B?LzNmZGNsTjJUV09xRWY1R2E1aDRlTXFPWXVxYTJISTBsS2dVdWErY1JBWTlx?=
 =?utf-8?B?cnBaNzlmR25JTkRHaWxLTjdlbG84cVJrelJQQkl3NzN6QmxnVXYwYXVSKzRM?=
 =?utf-8?B?bTFWdlkwaUF4QjNLNGp0eVpzTzFVWGIxMm1IYnJKVUk3TmJJVit4TVU3cngz?=
 =?utf-8?B?V2ovY2F5b3REbStRaUNQZVFkWk9SdTVkSEE5eVlwb3VzcDY4WkY1eHQ4cHF4?=
 =?utf-8?B?Z3FHVThmTVAwWTNicFVuUTR2WkJZUlJWelJtdllIQ2x0MmYwNVdmcHQvT2ZZ?=
 =?utf-8?B?RDUwMWRkMTE5b1ZiVElWaFlEM0lybTBKbERRdTlXNDJFZ041cnFyL2lZV0Vq?=
 =?utf-8?B?TlZBS1pzak9lRXJuTmluTC9ScStNT2FPUVRsdm56Sk90RWRIM2tBWHRsbTlM?=
 =?utf-8?B?bzlMV3NMV0RjTnFwTXRWMy9oUDkwYWl1VVVWZzRqRENaT1NqZjdKVllpSDY0?=
 =?utf-8?B?LzFSb29WcU82dDFQWDB3aWFjNjE2ZkxoWkIzTEowcU94OFlBakx0UnJJNDZl?=
 =?utf-8?B?Snp5bmZiVnBVZGlZKzF0MTlJSE5Bc3MySVMzM3pINWt1OVZxQi9TdWthMXA0?=
 =?utf-8?B?Q2lJa0ZycGZqbUkwdEpFcUIvdE1xeEF4QzRqMURxd3d3elBCMWI4M2U4ZFBD?=
 =?utf-8?B?TkNMNmZGcFlXVkRlTUNQSWRDbmhaT2VGZVJjZy9nVXVkalBFMTExWXFISzBi?=
 =?utf-8?B?ZXRGa096SHFzcThmWUFucDg0c0IwaHAvakJHeTBxQmduT3E3Tkx2RUhkWWhW?=
 =?utf-8?B?dmwxbmE1UjFrZnJGcHA3VFpPTlR4cnFmMG5JenFpYVFGai9FSzFyNzZvQ2Z5?=
 =?utf-8?B?MERTU3h2WEg3aVV1S2IzeEhEWUlBenhCT3paWEswV0x2T2xHcXFyakRhYW1o?=
 =?utf-8?B?YWVwRjAvZ2M2bjRvK3ZiWnNLUEJBWFdkMUFEODF3S0cvdG1tTDJtdTMzMTJy?=
 =?utf-8?B?TVREMGVBeS82SU4zVTRlK2EwbFFRaXBLdTh2SGNTWk11NENuQW9rNERINDRk?=
 =?utf-8?B?clRZWFRQUGg2WDBhNlRxRG83MEpxcU9wZ0l3cEJBd2ZSbUkvdlV5djNPZ2ZL?=
 =?utf-8?B?VzZaT3BTNDJRb0hOaU1pOGtWN1d3WncrM3FIRjhWNWZnMi94U2t4YVhWSnRJ?=
 =?utf-8?B?YVBlQXVsZGFGcVI1cTVRSzV6cG1BYTJaVjArZldMZmtUT1RMcWQwUjQvU2JV?=
 =?utf-8?B?Z2NpRGc2bWZtTWdRa25oYkpJMUxTTGltTG9Qdm5obnFsVTB0VTJKZFoySmxh?=
 =?utf-8?B?SVVHa0FxWWZGRDVzSjJnbUpSaEVJcFVnc1U2KzdiYUUwYTM4VDB6NWN1c3Z5?=
 =?utf-8?B?UncwVTd0RGRFRlZrVEVwM2VFd0xoNHhsK3Q1K3FycFpYR2pzZnpGNCthUjBY?=
 =?utf-8?B?SllrNHVKZExWT3ljQXMwZ3hYTk94eXdwSUQyKzhkVFRWUmpNQWZUTHUrSi9K?=
 =?utf-8?B?Vy92QkxENkJ5RnpnS3FXek5tdUtjaVNpMWRiVVlsSXdrNEpVZ2d5cmY2cDBO?=
 =?utf-8?B?MHNlSzNqaEM3M29NWUZSQzlkbnlickpDZUgwbWdLOU43NjBleW1zRXgzS0JE?=
 =?utf-8?B?WlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA341E285DE67340B6D11CBE15E7356B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df82cc9d-eb2b-4009-1be2-08dc5ad3c32d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2024 09:34:33.8448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +f52InmfWSpkDpkSjoYarqFijwfo0YwWovdnsS0AnL/0enGArZCok6dhaX+y590WeqDrixnQLBsOm883+O36Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB7659
X-MTK: N

T24gVGh1LCAyMDI0LTA0LTExIGF0IDE3OjAyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgSWYgdWZzaGNkX2Fib3J0KCkgcmV0dXJucyBTVUNDRVNTIGZvciBh
biBhbHJlYWR5IGNvbXBsZXRlZCBjb21tYW5kDQo+IHRoZW4NCj4gdGhhdCBjb21tYW5kIGlzIGNv
bXBsZXRlZCB0d2ljZS4gVGhpcyByZXN1bHRzIGluIGEgY3Jhc2guIFByZXZlbnQNCj4gdGhpcyBi
eQ0KPiBjaGVja2luZyB3aGV0aGVyIGEgY29tbWFuZCBoYXMgY29tcGxldGVkIHdpdGhvdXQgY29t
cGxldGlvbiBpbnRlcnJ1cHQNCj4gZnJvbQ0KPiB0aGUgdGltZW91dCBoYW5kbGVyLiBUaGlzIENM
IGZpeGVzIHRoZSBmb2xsb3dpbmcga2VybmVsIGNyYXNoOg0KPiANCj4gVW5hYmxlIHRvIGhhbmRs
ZSBrZXJuZWwgTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGF0IHZpcnR1YWwgYWRkcmVzcw0KPiAw
MDAwMDAwMDAwMDAwMDAwDQo+IENhbGwgdHJhY2U6DQo+ICBkbWFfZGlyZWN0X21hcF9zZysweDcw
LzB4Mjc0DQo+ICBzY3NpX2RtYV9tYXArMHg4NC8weDEyNA0KPiAgdWZzaGNkX3F1ZXVlY29tbWFu
ZCsweDNmYy8weDg4MA0KPiAgc2NzaV9xdWV1ZV9ycSsweDdkMC8weDExMWMNCj4gIGJsa19tcV9k
aXNwYXRjaF9ycV9saXN0KzB4NDQwLzB4ZWJjDQo+ICBibGtfbXFfZG9fZGlzcGF0Y2hfc2NoZWQr
MHg1YTQvMHg2YjgNCj4gIF9fYmxrX21xX3NjaGVkX2Rpc3BhdGNoX3JlcXVlc3RzKzB4MTUwLzB4
MjIwDQo+ICBfX2Jsa19tcV9ydW5faHdfcXVldWUrMHhmMC8weDIxOA0KPiAgX19ibGtfbXFfZGVs
YXlfcnVuX2h3X3F1ZXVlKzB4OGMvMHgxOGMNCj4gIGJsa19tcV9ydW5faHdfcXVldWUrMHgxYTQv
MHgzNjANCj4gIGJsa19tcV9zY2hlZF9pbnNlcnRfcmVxdWVzdHMrMHgxMzAvMHgzMzQNCj4gIGJs
a19tcV9mbHVzaF9wbHVnX2xpc3QrMHgxMzgvMHgyMzQNCj4gIGJsa19mbHVzaF9wbHVnX2xpc3Qr
MHgxMTgvMHgxNjQNCj4gIGJsa19maW5pc2hfcGx1ZygpDQo+ICByZWFkX3BhZ2VzKzB4MzhjLzB4
NDA4DQo+ICBwYWdlX2NhY2hlX3JhX3VuYm91bmRlZCsweDIzMC8weDJmOA0KPiAgZG9fc3luY19t
bWFwX3JlYWRhaGVhZCsweDFhNC8weDIwOA0KPiAgZmlsZW1hcF9mYXVsdCsweDI3Yy8weDhmNA0K
PiAgZjJmc19maWxlbWFwX2ZhdWx0KzB4MjgvMHhmYw0KPiAgX19kb19mYXVsdCsweGM0LzB4MjA4
DQo+ICBoYW5kbGVfcHRlX2ZhdWx0KzB4MjkwLzB4ZTA0DQo+ICBkb19oYW5kbGVfbW1fZmF1bHQr
MHg1MmMvMHg4NTgNCj4gIGRvX3BhZ2VfZmF1bHQrMHg1ZGMvMHg3OTgNCj4gIGRvX3RyYW5zbGF0
aW9uX2ZhdWx0KzB4NDAvMHg1NA0KPiAgZG9fbWVtX2Fib3J0KzB4NjAvMHgxMzQNCj4gIGVsMF9k
YSsweDQwLzB4YjgNCj4gIGVsMHRfNjRfc3luY19oYW5kbGVyKzB4YzQvMHhlNA0KPiAgZWwwdF82
NF9zeW5jKzB4MWI0LzB4MWI4DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUg
PGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gLS0tDQo+ICBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5j
IHwgMTkgKysrKysrKysrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlv
bnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIvZHJp
dmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiBpbmRleCAwOGFiZGQ3NjNjNTEuLjk4YjE0NjIzMzE3
ZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KPiArKysgYi9kcml2
ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jDQo+IEBAIC05MDIyLDYgKzkwMjIsMjUgQEAgc3RhdGljIHZv
aWQgdWZzaGNkX2FzeW5jX3NjYW4odm9pZCAqZGF0YSwNCj4gYXN5bmNfY29va2llX3QgY29va2ll
KQ0KPiAgc3RhdGljIGVudW0gc2NzaV90aW1lb3V0X2FjdGlvbiB1ZnNoY2RfZWhfdGltZWRfb3V0
KHN0cnVjdCBzY3NpX2NtbmQNCj4gKnNjbWQpDQo+ICB7DQo+ICBzdHJ1Y3QgdWZzX2hiYSAqaGJh
ID0gc2hvc3RfcHJpdihzY21kLT5kZXZpY2UtPmhvc3QpOw0KPiArc3RydWN0IHNjc2lfY21uZCAq
Y21kMiA9IHNjbWQ7DQo+ICsNCj4gK1dBUk5fT05fT05DRSghc2NtZCk7DQo+ICsNCj4gK2lmIChp
c19tY3FfZW5hYmxlZChoYmEpKSB7DQo+ICtzdHJ1Y3QgdWZzX2h3X3F1ZXVlICpod3EgPQ0KPiAr
dWZzaGNkX21jcV9yZXFfdG9faHdxKGhiYSwgc2NzaV9jbWRfdG9fcnEoc2NtZCkpOw0KPiArDQo+
ICt1ZnNoY2RfbWNxX3BvbGxfY3FlX2xvY2soaGJhLCBod3EsICZjbWQyKTsNCj4gK30gZWxzZSB7
DQo+ICtfX3Vmc2hjZF9wb2xsKGhiYS0+aG9zdCwgVUZTSENEX1BPTExfRlJPTV9JTlRFUlJVUFRf
Q09OVEVYVCwNCj4gKyAgICAgICZjbWQyKTsNCj4gDQoNCm1heSBuZWVkIGNoZWNrIF9fdWZzaGNk
X3BvbGwgcmV0dXJuIHZhbHVlPw0KDQoNCg0KDQo+ICt9DQo+ICtpZiAoY21kMiA9PSBOVUxMKSB7
DQo+ICtzZGV2X3ByaW50ayhLRVJOX0lORk8sIHNjbWQtPmRldmljZSwNCj4gKyAgICAiJXM6IGNt
ZCB3aXRoIHRhZyAlI3ggaGFzIGFscmVhZHkgYmVlbiBjb21wbGV0ZWRcbiIsDQo+ICsgICAgX19m
dW5jX18sIGJsa19tcV91bmlxdWVfdGFnKHNjc2lfY21kX3RvX3JxKHNjbWQpKSk7DQo+ICtyZXR1
cm4gU0NTSV9FSF9ET05FOw0KPiArfQ0KPiAgDQo+ICBpZiAoIWhiYS0+c3lzdGVtX3N1c3BlbmRp
bmcpIHsNCj4gIC8qIEFjdGl2YXRlIHRoZSBlcnJvciBoYW5kbGVyIGluIHRoZSBTQ1NJIGNvcmUu
ICovDQo=
