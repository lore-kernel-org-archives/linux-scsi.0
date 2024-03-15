Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D165944F
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470180; cv=fail; b=STSOYIycPs3VCUXal/jH8Y03mbXM1ju4CRdm8L/rAu0T+gCHOjPJ4BeBHF/uqUtXyk33MrrLN02v/Cq3eSnGWKVejxD+NOowrEo27oVpWW6mnTj1RiwSmE3NBAb4kUtfSjYFkkHQ89Ub1anIRBPmZSKTVMV6HWiivTSNFc+ANzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470180; c=relaxed/simple;
	bh=+k4bZv/LcmSdsvv3ABMAlRDCHjcIe4nFI4hyY52cP8U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rKujYPIEPbTI6eFlhjpCDFQFgg4sq5Bs9brpMEPxMEVxaXrWN28RS2xXANjd0C+MKe1jS5hfpWpnjo1YrH55FV2R+2SYxrqZMXhdfMHomnmSYn8xMHXR+5uVRojN6sWQZsoTIT6ce/0zRf4n0DNFyggZUtakQGWspTk/+DNvipA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=mK1A6R8P; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=oDlHwFXM; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mK1A6R8P";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="oDlHwFXM"
X-UUID: ca1fc8ece27411ee935d6952f98a51a9-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=+k4bZv/LcmSdsvv3ABMAlRDCHjcIe4nFI4hyY52cP8U=;
	b=mK1A6R8PtrbQPpW/q8MkC5p1iWPCAB9KEYpLEEO5m3PyYkT79S6i8YRTf8dVUBGTgJU13qSvpVQZUXCp4Cbgf/TC1XgRCRde3xyzdAKSHIxvgWASErjdanhx+CWxt2iJVcYO/HupMYiXFFf+RFANP6IorOtoqGY7y9L3veVaGqM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:55083dc7-294d-4c32-b562-600f87628da7,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:33cd8581-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: ca1fc8ece27411ee935d6952f98a51a9-20240315
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1939484206; Fri, 15 Mar 2024 10:36:13 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 10:36:11 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 10:36:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBXOK8+St0fUizL0YXcmMYLoGPEEWZTyURVxfZHcjc2P4ZUZsACME3icOOdYxE6HcpWB31hHfv48SJSZkIldLK8hmLFkXvXFScIYxk7DhVzYhs4rRI7LL2BFrQtmExAj0vgLuppYgcijZ5gK/b3bckmdB3ah2Q9lA4vhmrCGqv15HLGzsHDQOQP9Uyby/4ExMzZtIX0/jzeKGvNRVlOgCugwCudYJKg4Hug5jQZe/EYfeED6CG4N96Vlxn3CGNpkn4ca6nQrxqO7LrvocrRD2w7YH0TYIBUGHt8v/oSky5VvZTbJGLfWoDugPdwAAnBGrVBHoStmU5TjBDw8QDBrYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+k4bZv/LcmSdsvv3ABMAlRDCHjcIe4nFI4hyY52cP8U=;
 b=bH98LpgrNf1XQfdUopNoCxAbeZxVJ35GEvo07E1HFpHcV7Q+jPIfWc77ijPBGm9991byCgSTLlpAFnjzrT2rqkbJvD1VbkplbYbY/cVSWNoMhBgcF5/31U653qxnfLegEkd2gHdSClR64aCRgEeKXts+ACUemlOm1poG8fIrLYIabfTSoztHOD1rAbGvW1wO2ovAfFM6dgzQ+LzrAZgM3A5qXmrjrwLT54DjM9F5I7dBuBtd3wkdLgv/rNBzoLfQ3wJ6R2RQ6MafX+Kn32gcNZRcYP9ziBaRjFb+VMliaRlUyHhkv6c4KW03dfaoIMJb36lTPSDifFeOVKc9sfPXfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+k4bZv/LcmSdsvv3ABMAlRDCHjcIe4nFI4hyY52cP8U=;
 b=oDlHwFXM+O3BJaf8/9IRswLg44o/zYisAztfQX3SFY72pkMMrvx78jzFKvIAbUGh+tLWnMPPCsxTTOMMSLx+rWXGdWeLeAo33/eCBQnZzbtHNBRPSFOSN/BL9/sW2XBcDnsvUSQnMr0nsFt+Gc3uVanEW0prS9fAATABZDzHOFU=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by TYSPR03MB8849.apcprd03.prod.outlook.com (2603:1096:405:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Fri, 15 Mar
 2024 02:36:07 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c%3]) with mapi id 15.20.7386.020; Fri, 15 Mar 2024
 02:36:07 +0000
From: =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?=
	<peter.wang@mediatek.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1 3/7] ufs: host: mediatek: Add UFS_MTK_CAP_DISABLE_MCQ
Thread-Topic: [PATCH v1 3/7] ufs: host: mediatek: Add UFS_MTK_CAP_DISABLE_MCQ
Thread-Index: AQHacSa6INtRdiVbWE+3XOHoXM1lvbE4IMEA
Date: Fri, 15 Mar 2024 02:36:07 +0000
Message-ID: <cf6f4c42dfbfb8e1e43b770d0fb6e13dac53c37f.camel@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
	 <20240308070241.9163-4-peter.wang@mediatek.com>
In-Reply-To: <20240308070241.9163-4-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYSPR03MB7350:EE_|TYSPR03MB8849:EE_
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CfO9AKAny8Pqx/GV1EDGSMvouBy0hZGSQ+CPAkQyUJD+L2C1adFBGbhP3OPxQ0WOJ1AAu4rA0bZuyhE7L2GVV59Sh1fcwzhZG/w7WW/UuLcplgJE526RytTLjqC0YKZcOBPHvPQd+r2DZ49HNYcFk9wpSCCzaIsBbzr82is43sS3gMRsgTlZygFFIDg3M0T5wi2GY/1HOp1iA/FsQWmdfL/yBRNEZ3HmqHmJCjFqmGFvIQY3oFG2UnZpuch+1LehQc+w0/YQ2g4TgdyPfL4Paz8Q+q6v8mA1iWDy5VKiTIF5boP4DaIQlgQ00sA4TVOZo0iI80SGSa6cf3ToU334tyYGpk7ReaTp+fTiUJryiAMMWp65ecag8fcO241S/44eS9sUMmt9zKagdkslswsT53/135dU19jaLnkeXdMJhig2W9TBjXPnV6cn2UmUzFQfLak4HdN6s9CJsNwHnDeeP/is/WEZAgagL7tFM253z4ifkP20jLNf6s4Q9crv8r31nNCg+6A7ogetRwsN14RVgD/bSDnKtmtpt+T43TdtoNbKvStDw1khaGihnnWcaJO39HM/w8nsAPHrFt5bP4YYRhgP/sLQ92WnX9p8JLh6Z23nuvo0pawPNWkLCnV36mG7xqs4rx6xDpTF1SBRqU0hlunQ+w6tRBM4zcQIloPJtmg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a1BoRnNtREIvT1BDS0Y1RDd1WkJ5RWUwMFNLOCtaT1o0S00wUEg4ME92VGhY?=
 =?utf-8?B?cXh2cVRQandFL3lkYjF5OEtyOVYvSmFOUVplemZIZ3p2UnVac0IxZ0Rsai9J?=
 =?utf-8?B?b0ZOQ2plUGIrQzdxbGJJbi9uVkFoUlVweERoNFJ2SjUvRHJtZ2ZTc2wybExr?=
 =?utf-8?B?M0V5enQ2bGJYU09wUGI1SmYySnl1THhuWUJGRnBjZVFtaFFEWkRPazdReWtt?=
 =?utf-8?B?RkRDbFJwWXdHZ2s3UkpNcWI1dXZGWUFUa00weHl2N2pJYkd1VGhoZS9IdDJM?=
 =?utf-8?B?LzZaWnNwS2s1Q0JZZStZQUlZSlMvZFB0SFJ5SnYzQWRpdGJPbWpTbEdYMldw?=
 =?utf-8?B?ZktjYndkeDdBVWwwd2k2VVVHcktMUnB1UFZQUGRicVN4ektTRDJlNk5pWjdo?=
 =?utf-8?B?eGcrajBFektMT2RmQUo2OVlMNkI5dFZnUlVCeXBaYzZjN3hTcTdVSHhFd2ZU?=
 =?utf-8?B?N2JSK1JISzIwTHJVZDlTb1lsWVh0MDE4OXFSd2laRGNObjJsbW11Qmg2Q2VW?=
 =?utf-8?B?ZjFCc0lrMkZhbzA1SkJRdkZzbUxoZ000SkhUSW5XaE9LSzN0ZFV5VWhYTi9H?=
 =?utf-8?B?VU0xQlRvMFUrRmVwMFJXWWNvajc4TXNaNElQTmJzTW5hR3BkZ2dYREo1NlN2?=
 =?utf-8?B?VjRVK1ZQY1F5aFJWQWlEK2lvTi9Id25YbTVaS0dFQ2NkcDEwUDcwQkIwWXJx?=
 =?utf-8?B?MFhRTU5sY281QXJ6MVRIenFOSkowcjQwK2JzWjZOSWE2ZVk0VE1GNUpZTi8y?=
 =?utf-8?B?bURVMG1tOVQrR2Iyc3NOZzZpd0Y4emdrdzdLY0N2UWpycTBXZzZtZ2xVN0lO?=
 =?utf-8?B?cldRaVJ1SjNhQXFkZXRPL0N4Q3dXSncwOTU0Y3BqdzA5amtjUTdEbjcvOHV3?=
 =?utf-8?B?c3RRTWx5TUZTNEhiWG1LSWd3N2ljRHlNQXlleEQzaGlzYzhvOWx2UWlsWlpG?=
 =?utf-8?B?RG9RTCs3SGhCTTBQN092dEt5TU1NZ3UyZXNWdTAzZ1Zjdjd4TCtNMFNtdTBB?=
 =?utf-8?B?K2xIYjV6VHhibTFuVTg4QXQ3RDNGTWk4MXRqLzlML00xZ1RyVHQwMm1qRzd4?=
 =?utf-8?B?Ymx0MmprM0JnQ0hoWW9xL0ExdkhPSU1JSEdJUW9YTHNtbVF5ME0rQlE5a0Zn?=
 =?utf-8?B?azBQZ0lpRjdwcDVOY3VYNzhCN2NRUWJJbVRTOUV3K2g5RGllaEdsbFNYb24z?=
 =?utf-8?B?eDdlMjNtV05yRjd3SE5JcjRxaDdJbUFqckg0RmZnY2UrN0hrcmhyNmZtcXNZ?=
 =?utf-8?B?dWJGQ1dMRHYyRHBwZWc5czFQQk5uTUlIVmNlNEtVZ0VHZjFvOVZIU3UxaVJx?=
 =?utf-8?B?Z3g3dFZqZkZKT3ZGR1ZySFRQN0NDcks3ZXgzdkVqZGY4WkN2djNCQVVWQUI0?=
 =?utf-8?B?WEMyWVNqRkJTbTkzMWtDZ2FiV3VWdnNRUFZkblFNVFBuNnBNVDZ5WExYeEhi?=
 =?utf-8?B?aEtQdWVJdnJoYWZhMTl0dGpiNHdCQmRDcnZ1NCs1Y0IzSSt3emZpQmV2K1Bs?=
 =?utf-8?B?Y2EyVVgvOGF5SGdwUy9PeGkybVdEams3YitRTVh0aHJGdVgxZUJMN2dnZHFJ?=
 =?utf-8?B?akNiSnc3aU9CaVM2L3lQME5kSUNDYkxCVlNnd1pJVmVVQmdsTmN1N05pN2RH?=
 =?utf-8?B?bWVJS2dCdTg0ZTVSOVZ2cFYvSVRJYmNTVU1DVUYzTXBqT3VSRjJiR2o3REcr?=
 =?utf-8?B?dTA2Wkx5a2RMSlh5V3l4dHJZZFJDRlFBVkFmcG4yU3J0cmQ0MVh0ai9hZFF0?=
 =?utf-8?B?TDNjaTRSYkttNmlhbERzT09jMkVtSlA3T2RLMlpheVR5RHRCYytOeWp6Z1Q0?=
 =?utf-8?B?U1dRUmVOOHRYQmpOdEs1UUxhck5CUkFuOUk4UmxrRjl5U1h4Z1RmcG9KcTNk?=
 =?utf-8?B?elg3Tlp2WmZzczRBdG1sZ0MxQ1ZwbjB1QkJydVA1ejhhbTdDb1RMVW5HNVg5?=
 =?utf-8?B?WXIrSFQ3blFibEpRS1NBUldjcTl6M2tISHJIc2RSU3N4K01NQjREbEVuVDRj?=
 =?utf-8?B?OWZnVWV3a3YwMzk4Z0F3cW1tUFBJZC96WjdOb1pxeDViL2htYk9ybWZMVlFB?=
 =?utf-8?B?L0RkRnRYNkhnTXQyUjROTU9rUHNpT0pHaWFwYzRNZXVWaWwvU0w4aW5hN1Aw?=
 =?utf-8?B?Z09tUnNLMzE4Y0RveG16NWE2Q3NFZUR4UUJGbnJMdXpwWW16c2k4Tm03czNp?=
 =?utf-8?B?WUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2F97F76F11AB24B835C18C57FC21AA3@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1f285d9-1f87-4a73-bdae-08dc4498ab0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 02:36:07.4689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oCZQ5ZQuZJew5WYlVBd/siLc4UMR2rp04gER+6yUApyTj/n33ICCz2xDy5/C7P65QX70VER51h0Ez/TI91DzxfdkNtqxrN6HCcUMTHuvxLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8849

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE1OjAyICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBGcm9tOiBQby1XZW4gS2FvIDxwb3dlbi5rYW9AbWVkaWF0ZWsuY29tPg0KPiANCj4gQWRk
IG5ldyBtZWRpYXRlayBob3N0IGNhcCBVRlNfTVRLX0NBUF9ESVNBQkxFX01DUSB0byBhbGxvdyBk
aXNhYmxlDQo+IE1DUSBmZWF0dXJlIGJ5IGFzc2lnbmluZyBkdHMgYm9vbGVhbiBwcm9wZXJ0eQ0K
PiAibWVkaWF0ZWssdWZzLWRpc2FibGUtbWNxIiINCj4gDQo+IFJldmlld2VkLWJ5OiBQZXRlciBX
YW5nIDxwZXRlci53YW5nQG1lZGlhdGVrLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUGV0ZXIgV2Fu
ZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFBvLVdlbiBLYW8g
PHBvd2VuLmthb0BtZWRpYXRlay5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMt
bWVkaWF0ZWsuYyB8IDEyICsrKysrKysrKysrKw0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVk
aWF0ZWsuaCB8ICAxICsNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgYi9kcml2ZXJz
L3Vmcy9ob3N0L3Vmcy0NCj4gbWVkaWF0ZWsuYw0KPiBpbmRleCAwMjYyZTg5OTQyMzYuLmNkZjI5
Y2ZhNDkwYiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYw0K
PiArKysgYi9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+IEBAIC02NDAsNiArNjQw
LDkgQEAgc3RhdGljIHZvaWQgdWZzX210a19pbml0X2hvc3RfY2FwcyhzdHJ1Y3QgdWZzX2hiYQ0K
PiAqaGJhKQ0KPiAgCWlmIChvZl9wcm9wZXJ0eV9yZWFkX2Jvb2wobnAsICJtZWRpYXRlayx1ZnMt
dHgtc2tldy1maXgiKSkNCj4gIAkJaG9zdC0+Y2FwcyB8PSBVRlNfTVRLX0NBUF9UWF9TS0VXX0ZJ
WDsNCj4gIA0KPiArCWlmIChvZl9wcm9wZXJ0eV9yZWFkX2Jvb2wobnAsICJtZWRpYXRlayx1ZnMt
ZGlzYWJsZS1tY3EiKSkNCj4gKwkJaG9zdC0+Y2FwcyB8PSBVRlNfTVRLX0NBUF9ESVNBQkxFX01D
UTsNCj4gKw0KPiAgCWRldl9pbmZvKGhiYS0+ZGV2LCAiY2FwczogMHgleCIsIGhvc3QtPmNhcHMp
Ow0KPiAgfQ0KPiAgDQo+IEBAIC04NzQsNiArODc3LDkgQEAgc3RhdGljIHZvaWQgdWZzX210a19p
bml0X21jcV9pcnEoc3RydWN0IHVmc19oYmENCj4gKmhiYSkNCj4gIAlob3N0LT5tY3FfbnJfaW50
ciA9IFVGU0hDRF9NQVhfUV9OUjsNCj4gIAlwZGV2ID0gY29udGFpbmVyX29mKGhiYS0+ZGV2LCBz
dHJ1Y3QgcGxhdGZvcm1fZGV2aWNlLCBkZXYpOw0KPiAgDQo+ICsJaWYgKGhvc3QtPmNhcHMgJiBV
RlNfTVRLX0NBUF9ESVNBQkxFX01DUSkNCj4gKwkJZ290byBmYWlsZWQ7DQo+ICsNCj4gIAlmb3Ig
KGkgPSAwOyBpIDwgaG9zdC0+bWNxX25yX2ludHI7IGkrKykgew0KPiAgCQkvKiBpcnEgaW5kZXgg
MCBpcyBsZWdhY3kgaXJxLCBzcS9jcSBpcnEgc3RhcnQgZnJvbQ0KPiBpbmRleCAxICovDQo+ICAJ
CWlycSA9IHBsYXRmb3JtX2dldF9pcnEocGRldiwgaSArIDEpOw0KPiBAQCAtMTU4NSw2ICsxNTkx
LDEyIEBAIHN0YXRpYyBpbnQgdWZzX210a19jbGtfc2NhbGVfbm90aWZ5KHN0cnVjdA0KPiB1ZnNf
aGJhICpoYmEsIGJvb2wgc2NhbGVfdXAsDQo+ICANCj4gIHN0YXRpYyBpbnQgdWZzX210a19nZXRf
aGJhX21hYyhzdHJ1Y3QgdWZzX2hiYSAqaGJhKQ0KPiAgew0KPiArCXN0cnVjdCB1ZnNfbXRrX2hv
c3QgKmhvc3QgPSB1ZnNoY2RfZ2V0X3ZhcmlhbnQoaGJhKTsNCj4gKw0KPiArCS8qIE1DUSBvcGVy
YXRpb24gbm90IHBlcm1pdHRlZCAqLw0KPiArCWlmIChob3N0LT5jYXBzICYgVUZTX01US19DQVBf
RElTQUJMRV9NQ1EpDQo+ICsJCXJldHVybiAtRVBFUk07DQo+ICsNCj4gIAlyZXR1cm4gTUFYX1NV
UFBfTUFDOw0KPiAgfQ0KPiAgDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1t
ZWRpYXRlay5oIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmgNCj4gaW5kZXgg
MTQ2YzI1MDgwNTk5Li43OWM2NGRlMjUyNTQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZzL2hv
c3QvdWZzLW1lZGlhdGVrLmgNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsu
aA0KPiBAQCAtMTQzLDYgKzE0Myw3IEBAIGVudW0gdWZzX210a19ob3N0X2NhcHMgew0KPiAgCVVG
U19NVEtfQ0FQX0FMTE9XX1ZDQ1FYX0xQTSAgICAgICAgICAgID0gMSA8PCA1LA0KPiAgCVVGU19N
VEtfQ0FQX1BNQ19WSUFfRkFTVEFVVE8gICAgICAgICAgID0gMSA8PCA2LA0KPiAgCVVGU19NVEtf
Q0FQX1RYX1NLRVdfRklYICAgICAgICAgICAgICAgID0gMSA8PCA3LA0KPiArCVVGU19NVEtfQ0FQ
X0RJU0FCTEVfTUNRICAgICAgICAgICAgICAgID0gMSA8PCA4LA0KPiAgfTsNCj4gIA0KPiAgc3Ry
dWN0IHVmc19tdGtfY3J5cHRfY2ZnIHsNCkFja2VkLWJ5OiBDaHVuLUh1bmcgV3UgPENodW4tSHVu
Zy5XdUBtZWRpYXRlay5jb20+DQo=
