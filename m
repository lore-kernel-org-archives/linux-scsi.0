Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C891D540
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 07:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753083030; cv=fail; b=DII5yAuvl9z6ttdWtIM8ewC1QPU6tkXQdwNC8FfmTFJ7vplkq2EBtadELrgcdtx4tinfm0MofyVqCyBw4fTkVaFRfLG6fo4givcbgWCUupDOlm+E0GR2WjJhdPUKBcd+cGj9m/BibIDVStcwcl89KdfMnt7c3BfduB5C3l/dOQ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753083030; c=relaxed/simple;
	bh=tA8FwR39lchJy6J/YPEoaDVhe/JhRWZkEqggiOnHgG8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kVbDpALJiSAThYigYzdbvGS3Dfk5NDaNLvtdz9nT7JxggtnxJrR+JEe1lTenDCmhrqaOQNe9nl9tgjCHact8JSPLWkWAmkcisR5ldc1paRK/7WjfGfw8nzEMdjTrBfa7kkhTTdTBsAYSArDFGUSRY08/VXeF/qLNj1afz7Qdwto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=NG+RtzXj; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=fveEXDK0; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="NG+RtzXj";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="fveEXDK0"
X-UUID: 8f8bd7ce660411f08b7dc59d57013e23-20250721
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=tA8FwR39lchJy6J/YPEoaDVhe/JhRWZkEqggiOnHgG8=;
	b=NG+RtzXjrlwYs7z2y9sNijNh+Okd//BmK67rEutecgHwZ2U0DQoFQKHu4FcEmqyAJ2LFv7fQCbZa8/KHutL8O0ZkiOTdKvdn8xYosyVsEoJrLKGatA1jcFGrxfGUqB7tS/DT2XhO0ZSqk2TVdEF8xVuHL7BNlu2xSKbwmvaXmoo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:978eb65a-9dd4-45d3-9740-5dc7a2bcf590,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:79183b73-f565-4a89-86be-304708e7ad47,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 8f8bd7ce660411f08b7dc59d57013e23-20250721
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1328373287; Mon, 21 Jul 2025 15:30:22 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 21 Jul 2025 15:30:19 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 21 Jul 2025 15:30:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xJ8AhccNECb4bN3aAs88ks5nKT+YgwaYu4OsVBSe6KSXlk/AYnS8JPD0krGePNaORr984NUGBUfaibD4C7eBpECLnaeeUcK/leUKn/KxN5U22p4scFSPiO2wRZ8NGmlJosCUJseL6psCGadoWcdzL+Y0ZYooLxFUlS7RfO7hbJ07ARw/UdgCoApAMtSlU7hxkHDmfHeiObP8pEtw5Y1wrf0c2dUeOElCDjwLe0CaWj44V9KzVFOUMXzjPjTa+EkigNzjkVsgTdvbeMSh3DQMgPlbXHLKdrPDIJR36rNnz5WnmUlHpX2Yy6ndvJn0WxbDY9bd4KciVu3MSIxdWYakdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tA8FwR39lchJy6J/YPEoaDVhe/JhRWZkEqggiOnHgG8=;
 b=ZKpAUcAAC8VzXjzf+hHzhbZ+6YFOOiEGAuuCpgvwAa5JYBVGiyQQrgruK+5/BQHdbnpDowsBHKqspIBXe/g1X7xb4xoGPCxXaH3ZmLmWxlaUDi2zpWymrfQ0dsbcJ5IdE+zHylHL3hUVlXldpZ2jdAvPLlr4a0oQEudvkTVvsMYPh0EG2Ad5j0TzXdgMhri0rifZ2ixuBkHhAt6pdVPGHJ2DjeOG3ujVM/W575UwoASV8Lro1sXp/6cDfEHG5JsZU8T7MeQrK9445GKGKEVpeyMS/x5EaZDFacpOsesF1OhJ59D5Ba/Tmh0MefwtgkBCbJ5HuH7dHVmiOIeBYR6eSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tA8FwR39lchJy6J/YPEoaDVhe/JhRWZkEqggiOnHgG8=;
 b=fveEXDK0YyAyCgPxn5DfhINpqWvcVUusTWjiEM5JMvzUbK37fU9vgCGe0SHHuB+io8we75NqztvgDwh9I4I7p9xM1a897x6FLZVfmobC21XiOcDz/T3N2D+9FF7Q5FLuDseVCmdiAx3R60ZN5oaEw8AZm7HT2Ghzl5ZG8nlja2Q=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8035.apcprd03.prod.outlook.com (2603:1096:400:45b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 07:30:19 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 07:30:19 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v2 1/9] ufs: host: mediatek: Remove unnecessary boolean
 conversion
Thread-Topic: [PATCH v2 1/9] ufs: host: mediatek: Remove unnecessary boolean
 conversion
Thread-Index: AQHb98owYLy9Jw4SPEi2rWlP7pkfQ7Q3/VKAgAQ1tYA=
Date: Mon, 21 Jul 2025 07:30:18 +0000
Message-ID: <a1cf6616a5bcce149a7442ed4bb72ea75c9452c9.camel@mediatek.com>
References: <20250718095524.682599-1-peter.wang@mediatek.com>
	 <20250718095524.682599-2-peter.wang@mediatek.com>
	 <06cca9bf-e88a-4884-811b-ec103ca6f40f@acm.org>
In-Reply-To: <06cca9bf-e88a-4884-811b-ec103ca6f40f@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8035:EE_
x-ms-office365-filtering-correlation-id: 634dd748-b7ac-4ba5-3d35-08ddc82871c8
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cmIxL2ZSYjFoWHFRSG9mSXFPTFJ6S3g5bkRPQ21pUi9KS0dsNVRsZEpjMU90?=
 =?utf-8?B?L3J0ZktheitScTEvRnNoOHdRWHNjWGFUZ3VsbHd4RzFWcEdPL3RSRzFQMkQ3?=
 =?utf-8?B?NHhRVWdkbUx4Z0dmQ1JwajhKRmNvdjZWeVZPKzBIZGFYNWRCbEw1V3pZc3ky?=
 =?utf-8?B?U21tY1ZLTDB6VjFDZFdpd2c0Q3dOeTcvZnZUeTdXeWNzS3dFZjBHUVpGcy9a?=
 =?utf-8?B?eHNFWjQvRUNxVFZiRmVyejBpa2JPMnBqdm5SVldKbjdnMGpyVEJlbGxIbXVX?=
 =?utf-8?B?YzJsK2JuZk94RURkV01RRDFqZFpNYWJnblUwMXpzSU8rd0d6a3dhTjFaVnla?=
 =?utf-8?B?YVdCQ1ZFbENWcG9IN1lMZHVxcHNDVjVRRDN4UzZaTDJXWVY0MFdZeWlzWnEz?=
 =?utf-8?B?QlJBbGlrcWVQajI0dGFuMG9pWCsxV0hNblgzTDZOaTFKOCtLRHY3TVlSeHFB?=
 =?utf-8?B?aVEzWG1ZZ3lvR01FSUpPUmlIUDdwenpwNFRyaElSQ0doMnNUZEZGQ0hqUmY3?=
 =?utf-8?B?QVhYZTBPZG95RUJ5R055MUNPS3JSNXpTNXh1NGc3Qkt3d1UyVGh5a0RjSHZq?=
 =?utf-8?B?eE5iN3lZVytzTDFuRS9BQ2p1S0JRYS9QWTFIdkdITDNrRjBOSnYxT0pad3ZD?=
 =?utf-8?B?QkwwMnhsbThSOUFCbUY5NXdRYzNHcnh3N0Z2MFZzTWZHdHE0ditwNHc3TFVx?=
 =?utf-8?B?Ky9vZ0hoZ2FZY2hRM25DRUFIYmZoV0dYY296QWNLQlpnVk9NZm1SeFpZMC8z?=
 =?utf-8?B?R01seThPZlZUeElXVjkrK3I3QzNJd0dCaWFnTFJQcmJod2M3Mmszemc5eXVj?=
 =?utf-8?B?OWNGVzI4MlVVZG91TlRvOTAxRTMveUtDWU8vTDRBWjlXeDZudmQ3OFNiZ1VH?=
 =?utf-8?B?SGVvdHZsLzVhNzY0Rmx3cm9CYkhGQjd4QWdRNGhjMjE4WU9wc1p6ZlBrSjJs?=
 =?utf-8?B?NzE5cThzZ3hCU2JGVWlZa09kMU5YSlJzZmtoMldsa1BxcEUwWi82RnEreXc5?=
 =?utf-8?B?YVI3Y0JCdnVPTXNuVVlBcDZ3VzVjT0F0YklHSk4yeHRabDdFYWR0VGs5MWlL?=
 =?utf-8?B?cmhCeWZXWFJmQytoWWhrR2hPNUpuQ0UzSVRBOFhOcG1tYmVBa0IzVU5rd1Bi?=
 =?utf-8?B?UFN0alV2M0N5SkQ4eE5zdVpmT2Z6d1BkN3l5T1ZoNnlHbnRTNThtNGc4Tisz?=
 =?utf-8?B?bHNRUFpjaURQcTJ0M3N2M0hkU1UzM01mODZSSUJQWmg5SmJUN2VhVHZQY25M?=
 =?utf-8?B?b3NkVXpEeFBXZEgzZGc4aGVzTnZJd2tsYXQwQjNleFVXc2ZDeklsSmZGTnZH?=
 =?utf-8?B?NlBOOTZzRGlCRFdqMEVXeG5Qaisybmgram55aGRKcE9KYTNyZDdwbTY4YzBJ?=
 =?utf-8?B?ZngwNk1ZSmpmMUVKTmozU0tmQWhGMlEyRzFGN3JxRlcxaU81K0dEM3JvdlRa?=
 =?utf-8?B?YWpFdWlETldndVU1Nklya3hCUVRyMTBQUmphaUNzejgyUFd0R1Fyakp3T1BP?=
 =?utf-8?B?SFpOdmN4Q2VBR09wcitYSVE4Z3V3MkdkYkI0RlpRK3F2OXVteXNQWHptSnRp?=
 =?utf-8?B?UkZCdXZMR1JkL0xZOUoxdXVOSFBodmt3ZTk4RkxEelJmVGlxK1B0TTJXRCtZ?=
 =?utf-8?B?VHFneWdrZVYxNXgyK2pwbGRlT01yeXNSeWZKc0ZhOHBteHB3VG9iZVlOMjVt?=
 =?utf-8?B?RmdwMGpYQjVDaXZVYXZQWXRxaTJ1REhJUzJEWTZkS1dJeHM4NVNJMTFHZzJ2?=
 =?utf-8?B?NHEyQ0dSZHV3Y0FxRUFNOUdjNXdCemhaQjhoR3E3M095ZWtZcE5NWklyRkVW?=
 =?utf-8?B?MUVCWldOZTQxYmVRaU15V2l2azM1VFdOcVdqY2JkZlh6Ly9tTms4VFFERXRj?=
 =?utf-8?B?czBlZ1p0eFZGVXdMeFM3RjU1anVwQVVjN0FYbFVXMThuck9QNzh4dFBpQjFr?=
 =?utf-8?B?VkNkTFV0L1hMR250eS80NFd3NTk2dDRyVTZZU1Zzd0c3emhHN3d4SGw3Wko4?=
 =?utf-8?B?N044am5CL01nPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0doNXZ0clZLR0xJMTloNk4ySUgybWpDb0FyUitvK2x6MlVsRGJkaTlSNUJH?=
 =?utf-8?B?cDNjemFlYmk4cDFFWmlZcXRGNGlPakxCaFEySEhJa3UzWUJwc3QwcGFZWC9J?=
 =?utf-8?B?T0RqK1FPN2RQSy96b3lUd0dRK3hDYUxZelJRTlZ5Y3lydm94WExsM1MzQ29L?=
 =?utf-8?B?ZGg0dE8ydFAreUJaREkwalFpRjhLMUNqU3pJYmxuM2ZpTTRjYlVIeFpJOURG?=
 =?utf-8?B?UnZrVTI2c2RheWJQd1hvSUlzY1pQYy9odFF3bkl1TXowaklyMjkxamMrQ0JW?=
 =?utf-8?B?Z3ZBWUorelM5eFNJbXZsd2tMVkM1R1FRT3NJY2doT20wRlhpbTUyVTNLeVdq?=
 =?utf-8?B?SDlrd3dsSUd2ZHZ6NlZBSzR1YWh1cnIyZ3lKaXlNdnpKZWMvQUc4R0R0Tlg1?=
 =?utf-8?B?ZkFUb2VTQUo1UDJjeTAvc3AzakZuR2phZW5tWGdlajdvdUc0NFBqbk5jV0R3?=
 =?utf-8?B?azY1eWx2YUhGMG40TjdRWlpGUW01MFlIU3ZmSEJneC8vc1BRUFlVd3ZWeERo?=
 =?utf-8?B?YmxDZWZBa3U1REhaL2FHNjBHYmpLTFM0MURJL3RHSC9ocWJSTDQ4bm9YNmNG?=
 =?utf-8?B?STJWUU4yQ1JCdlhId00ybDlVY09CTll4RnJJSGwvVzlnNzhBenlZVlhMUSsr?=
 =?utf-8?B?KzhvT2NsS3o4TVNTeWV4cDc2RGFUbW52SFJkKzh4SU1EQUhQbTZkcUZIajlB?=
 =?utf-8?B?Y0JQbmprWndpZ2RlSTJDcWlxalNlaVpOc0lzVnI3RDJPdmU2ZERJMU9hanNP?=
 =?utf-8?B?ZHg5VjNtNFJVVzBaWkRMSGd0OVRrdGN4Z0J6dGZpRjl6SkpyYWR3WHNKTEQr?=
 =?utf-8?B?SXU5bVBpQ2RHamMzMGxYdHBaQUVOMmtCazd2Z0VqWXMzOFlmd3VHWURuY3RZ?=
 =?utf-8?B?VXYvQmFFZ2F0ZGtRWjM4MW5COU55VHcyZWpoRjcyQmZpbmp4SGlKU2Z0MHlG?=
 =?utf-8?B?aytKR2tNaFZOOXQyb1V4Zm5GT3haN1hKdHpIMU4xVDFPZHlmb0lJamhTL0tO?=
 =?utf-8?B?VWxxd0hwQitiOXdnV0pkSWRhZjRVR2RrRkxtbndCeXBzcHN6WE5YYStYRVJQ?=
 =?utf-8?B?WDV5RDg4K0NOSEpqTXl4akJaT3JzRUVjK3B1bXNCTFJLaUxaeE5BVXJjVnZ4?=
 =?utf-8?B?ejhXMXRWMXNEbi90eC9hbk8xVFp4bkZ1OVp4ZGpxVnNreHlybmZmNzRNYWhP?=
 =?utf-8?B?VkJ3N2EzbE1kSTZtWUVZRWVIbGdOb0pUdm5iRXorLzRwZjFqK2NtTVE2VE5y?=
 =?utf-8?B?Ykp6UkFvck8waHBBWlRyd0JLVlFNZ0VwUndkNElHcTN2d3YrN0VJN0dwa3JY?=
 =?utf-8?B?R2VONzRIcHlRc05PY1hSVGZDaEVpSW5rU2tjL0tCM2k5TTdoeHhucVgzTGha?=
 =?utf-8?B?WTJtVlpyVXhKdHpZcFBlL2lPcEJROVcyajVyMitvYXh1ZXljakxuVTVuamUv?=
 =?utf-8?B?M1pMRjlYaENJNC9Sd05ZbkRNNit6SFkxdVd3YUdtZFFhdFh4Q3RLZllzR2FW?=
 =?utf-8?B?VTBtb1o2Ty9STThyWHFBMGdWak5hOWIwZGdHTzNzc29lUXBrSnpNblYwaUYw?=
 =?utf-8?B?WS95YUlSVHBraFFpNmJ3SUs2ZEREL0RQNTNRMFBReXV0MDEreDU3TVhxSkNo?=
 =?utf-8?B?UEk5bW9NYzRiMkZmdmR1ZVp5SGhqT1NtN2I3UlJiM0hoem0yQldudVpJUGEr?=
 =?utf-8?B?QjlaVXZyRHV5OWVDZCtkUmRycXpqcW1LVkFvWE5nb3MySUhrUVhTeHZGdkpX?=
 =?utf-8?B?L3UzOURVM0hVUFc3Znlzb3lKV1hSQ1ZyM2UvYXoremhmSWprdEQyUEh2YlFB?=
 =?utf-8?B?MnhoZ2R1MjgxcEIzUWpDQXBRcFF5L3QxTW0vOCtBd1M0SEZoSGpvOVQ5UHFh?=
 =?utf-8?B?YUJPUE1WdU5ON2tROVJRSVFraEdKL0FtcGRsZlQ0WUVIY1BzM0EwNGFESUkv?=
 =?utf-8?B?T2ZzL29KbWdoL0lPSDkrNkhDWHZDdldZWmdDVWp0T3QrU1ZGNjNYemxzQWJ5?=
 =?utf-8?B?RERGWm1pTTVGUnh3elU4YkI5TWVFTFF6TzlHcERTcndpdzl5NFV6RHFFd1Q4?=
 =?utf-8?B?ek5qV3k5Y0JjY0pkcWIwakNNY1pYTkJ2ZDFtNGwzZjVQL2FHcU5KODNVdGpO?=
 =?utf-8?B?ekl2bkdGYk5OekNsd2xPejFYN1BodnVORHpDVFlVeWlSVGZEby94R09DeXA5?=
 =?utf-8?B?NkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B87EBDA0F0518746AE2E54A54842B70B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634dd748-b7ac-4ba5-3d35-08ddc82871c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2025 07:30:18.9144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bTcHoO6ULJj5aCdDGoOuYH/Va9UM1kqqlumNkejD96ys6rfUkvEjeNg7M7zV0LTx/ojnemDVitWm7zOpxEAT1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8035

T24gRnJpLCAyMDI1LTA3LTE4IGF0IDA4OjEzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDcvMTgvMjUgMjo1MSBBTSwgcGV0ZXIud2FuZ0BtZWRp
YXRlay5jb23CoHdyb3RlOg0KPiA+IFRoaXMgcGF0Y2ggcmVtb3ZlcyB1bm5lY2Vzc2FyeSBib29s
ZWFuIGNvbnZlcnNpb25zIHRvIGVuc3VyZQ0KPiA+IGNvbnNpc3RlbmN5DQo+ID4gd2l0aCBvdGhl
ciB1c2FnZXMgaW4gdWZzLW1lZGlhdGVrLmMuIFRoZSBjaGFuZ2VzIHNpbXBsaWZ5IHRoZSBjb2Rl
DQo+ID4gYnkNCj4gPiBkaXJlY3RseSByZXR1cm5pbmcgdGhlIHJlc3VsdCBvZiBiaXR3aXNlIG9w
ZXJhdGlvbnMgd2l0aG91dA0KPiA+IGNvbnZlcnRpbmcNCj4gPiB0aGVtIHRvIGJvb2xlYW4gdmFs
dWVzLg0KPiANCj4gSG1tIC4uLiB0aGUgY29udmVyc2lvbiB0byBib29sZWFuIHN0aWxsIGhhcHBl
bnMgYnV0IG5vdyBoYXBwZW5zDQo+IGltcGxpY2l0bHkgKGJ5IHRoZSBjb21waWxlcikgaW5zdGVh
ZCBvZiBleHBsaWNpdGx5ICh2aWEgISEpLg0KDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdWZz
L2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gPiBiL2RyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVr
LmMNCj4gPiBpbmRleCAxODJmNThkMGM5ZGIuLjE0ZjAxMzBkYTY1MyAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay5jDQo+ID4gKysrIGIvZHJpdmVycy91ZnMv
aG9zdC91ZnMtbWVkaWF0ZWsuYw0KPiA+IEBAIC05NiwyOCArOTYsMjggQEAgc3RhdGljIGJvb2wN
Cj4gPiB1ZnNfbXRrX2lzX2Jvb3N0X2NyeXB0X2VuYWJsZWQoc3RydWN0IHVmc19oYmEgKmhiYSkN
Cj4gPiDCoCB7DQo+ID4gwqDCoMKgwqDCoCBzdHJ1Y3QgdWZzX210a19ob3N0ICpob3N0ID0gdWZz
aGNkX2dldF92YXJpYW50KGhiYSk7DQo+ID4gDQo+ID4gLcKgwqDCoMKgIHJldHVybiAhIShob3N0
LT5jYXBzICYgVUZTX01US19DQVBfQk9PU1RfQ1JZUFRfRU5HSU5FKTsNCj4gPiArwqDCoMKgwqAg
cmV0dXJuIChob3N0LT5jYXBzICYgVUZTX01US19DQVBfQk9PU1RfQ1JZUFRfRU5HSU5FKTsNCj4g
PiDCoCB9DQo+IA0KPiBIb3cgYWJvdXQgcmVtb3ZpbmcgdGhlIHBhcmVudGhlc2VzIHRvbyBzaW5j
ZSB0aGlzIHBhdGNoIG1ha2VzIHRoZQ0KPiBwYXJlbnRoZXNlcyB1bm5lY2Vzc2FyeT8NCj4gDQo+
IE90aGVyd2lzZSB0aGlzIHBhdGNoIGxvb2tzIGdvb2QgdG8gbWUuDQoNCkhpIEJhcnQsDQoNClJl
bW92aW5nIHRoZSBwYXJlbnRoZXNlcyBkb2VzIG1ha2UgaXQgY2xlYW5lci4gSSB3aWxsIHJlbW92
ZQ0KdGhlbSBpbiB0aGUgbmV4dCB2ZXJzaW9uLg0KDQpUaGFua3MNClBldGVyDQoNCg0KDQo+IA0K
PiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KPiANCg0K
