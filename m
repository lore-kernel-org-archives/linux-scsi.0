Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263E8288D6
	for <linux-scsi@vger.kernel.org>; Wed,  3 Sep 2025 02:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756867345; cv=fail; b=jv08B1w6g/SKDBur3IO6mjwmy7BqvANttnsh4q1Mgw4gU4nFWXT66GbsnyT768wtlJOmeOy/keg1228CU+WFm8leoxpP6SgZPDd9TzYVWwDXnphN4fm26549nk2paEP24x9z6M0Wt0bX4+JowmSFZA22h/HpCqY/AmjEVgeWqso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756867345; c=relaxed/simple;
	bh=DNSbD/EPBIGNQf46cPeQcAsEW4U8KSYVMJs7tZSsK4s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LT6IlgRJHXk44d688megrvE0G2P1CMgVrgIOqvX+0707jz9CtMLYEwLLpEPj38hTXpaeeng8swBpZr68w6NnrRoqy91plGTn3dx9aI8paGhbtaTyEC3zloM3rgjtcso2AklJFXla5zca2yh+dBndshSY6DJ9sLqdYmdbdv3ScBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZK5KgMYj; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=hUsOEp9g; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZK5KgMYj";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="hUsOEp9g"
X-UUID: 9a6dbff8886f11f0b33aeb1e7f16c2b6-20250903
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=DNSbD/EPBIGNQf46cPeQcAsEW4U8KSYVMJs7tZSsK4s=;
	b=ZK5KgMYj8GdidxKUFwDlt49vnn5Ujogt0tUyISHgCidVFsFRuBOG84kBVzHtuT7mz4GAD/PYKa61WDqxbIzHGC3pivGzgR19GZc3/xSw8YnR7M1kIRCTd4Ute/Ghpx4Rk/Z7seLQW72C4XGhvlKuIW0ZejAkvl4cjuSh+nlskoQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:170ef216-b192-4106-84e8-d29570ad5ad5,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:322d5f84-5317-4626-9d82-238d715c253f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9a6dbff8886f11f0b33aeb1e7f16c2b6-20250903
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 863164000; Wed, 03 Sep 2025 10:42:16 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 3 Sep 2025 10:42:15 +0800
Received: from TYPPR03CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 3 Sep 2025 10:42:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sEDwygOrp3Rkzapu/b68oMFdM5ybzEnwPgI5eaVvHe+/gvL7wmprfQSG7n2uvThjTCw5BTgK4Hg+dZzsXzlW9GLt5hbcCvhyk4wOQu2BTdQBlu29+1uej/nLUw8ka7kT90r48Fty60tbhNTPtX7fEjgWMhoQnbuei1BbLNCHWwshwUO/iXBx/akmUtWpkmdxZ/mb2Bt1ZsZsNbhiHDmoZ2fKuBg7570fgc6LDwH4SdAMzJNHOcew2mQSy+lx6f/G9DsRSUflYmePO7ZHUw73jNky1Cb3mcOpswCqQX6Hrdckwdqs+D78eMBTV0YsBqzmgLLtCAe680Cv4iaJI1QL0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNSbD/EPBIGNQf46cPeQcAsEW4U8KSYVMJs7tZSsK4s=;
 b=RbIV7fIhL+yTGgrhnVomRkkt/OJqRQ8LbgmQ/JHYvEdXn2qywFH5ryO4nuoQxwCSTeQX4wy7xmVeQn16/3odGbcJBF76GLhW8RYJ+HOLHsuubaHaSptHvoo7g+7rL70ajaKhiFhkCYIsE9TAJt5/l6X8mLeLuCV5hBqsT2K2fSA3tct7NVhROj5YgtP1AehKoJsl2hMl9SB+VaYe3vndX3bMhTE9bSHz3vhYTn55Jy2i+ipYA2j/RFjfJcVX1tvk4XH7i9d728mLLVOU8Zlf/3uxMAehiZ2mrz7yBNkDUwL52I7X4FsrrCJbRec2rOBvQvydDN9t/Z3HkLnHn3Xd3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNSbD/EPBIGNQf46cPeQcAsEW4U8KSYVMJs7tZSsK4s=;
 b=hUsOEp9gXXrJIf11xhMJ/u16pKRbF5rfLZliWeUFqlRn0ujxLRf9R+qMTVYfriDxRB/l6+ZhSmzmK+jZ5IxD8YG7DAs3Fj9WknUUVMM+zER+5Pnu0Puvelo5OKLz5rwSIQvrHCas1hP1Dkh8l1XPQ9mtokyAPJcjQjBA/WJlGiI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7001.apcprd03.prod.outlook.com (2603:1096:400:26a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.29; Wed, 3 Sep
 2025 02:42:12 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 02:42:12 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, Sanjeev Y
	<Sanjeev.Y@mediatek.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?=
	<eddie.huang@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?=
	<jiajie.hao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?=
	<Alice.Chao@mediatek.com>, wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v2 01/10] ufs: host: mediatek: Enhance recovery on
 hibernation exit failure
Thread-Topic: [PATCH v2 01/10] ufs: host: mediatek: Enhance recovery on
 hibernation exit failure
Thread-Index: AQHcFlIdVBOjGqfDKkyNyjfNvaWKxLR8AraXgATJV4A=
Date: Wed, 3 Sep 2025 02:42:12 +0000
Message-ID: <9fe3cdeeedaac3dc7756337442923d7e37767e52.camel@mediatek.com>
References: <20250826062314.3070425-1-peter.wang@mediatek.com>
	 <20250826062314.3070425-2-peter.wang@mediatek.com>
	 <yq1ecssffil.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1ecssffil.fsf@ca-mkp.ca.oracle.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7001:EE_
x-ms-office365-filtering-correlation-id: 3c51446b-d759-4313-9837-08ddea937c69
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NjRHLzQzNjdLNkEyM1JyVk1mWWlRN3h4dC95TmVQcVpHcTJHY0ZlVEt6bTN5?=
 =?utf-8?B?d1pBcEVsckI1Rzd3Q01SK0lxUDU5bGdNd1ZFWCt1TWoySHYzcmtqclZ5UnBC?=
 =?utf-8?B?T1U0S1VQZzNvdE95d2NCcUI4aE1mRXFJZzRVVUd1S0RRbW1BTU9CRWQ1cGth?=
 =?utf-8?B?bkFqdmt2dTZNMkk4a2ZPRjgzclc4S0ZPdmQ1b3BIeEcrdDM2TWJaM21Bd2ZN?=
 =?utf-8?B?dXFwV2NTaU00QjkyWitnc1A0ZlpoZVF3aHFzc25jWnA4cE1kb0NOY2hVTmp2?=
 =?utf-8?B?UHkvbzdHamlyWndNWi9CdnFTSUUwRGlOTk1yZXBWZFhJZ0sxOTh5NFZnZnVn?=
 =?utf-8?B?SWxyK0ZQZllGQys5c1Z5OERrdXpNYjU5TGpGRXZlSlRIZkhZd0J1TDhIM0FH?=
 =?utf-8?B?SzNSdHRMa09jeGpOY0gxcVA0dVZNMm83VlZFYURCTkpvVEJJNnBQUGlucVBR?=
 =?utf-8?B?YzRUckwxU2IwSmZuWEM2Nyt4UGRscEsya2ZzUmZEdWd2c29LNFpFMlVCdU4x?=
 =?utf-8?B?M28zbVdvTmVrY2lRQ1VFSWo1d2RhbjlNdGFNVFI1UGVyZlRzSmlXc1hMNTZm?=
 =?utf-8?B?VnV0Q3pDVThoVC9wbUd5SWRHR2FTUEQwVGVVNHp0MmlSL3ZyM2V1c3YvQ0Qv?=
 =?utf-8?B?TEVoTDJzOUozaUNGOEVXakpwQVRzbHF2WEtSSEpIcFQ2MzdxZ0FJRlBjSzB2?=
 =?utf-8?B?UlovL2FXMmh0dUpZb0hTOGd6SkxSWFdjTGJzc0gwdWNGSVFjM1lLRXc2MHZC?=
 =?utf-8?B?VDAwbnREWmJUaFp5Wk1KOXhZTldmMStPdzYwOTd5bjdGUXZ6YzluRzBZTHVu?=
 =?utf-8?B?Y1hsTjUxaWl3MFpSUUh4c052dmpleEJPQTZyeHRVcFdBY2xyV21YV0gwMDJY?=
 =?utf-8?B?WlNlYUJDTU52b05kUGxROTNXd3loUjdCMll1dmwwRy9sOVhzNE43MEM5Rmdl?=
 =?utf-8?B?SnYzSHZpUktmUUtxWGFXZ0MrelFGOU9rM3ZhOGNoNVFQNVppSlJpWVN5emJn?=
 =?utf-8?B?Qm9xaWwxck5oclBhWTlBR0FkMG54b1k0UWVSUkJtWG1xQ3g5clVCcWpWbDhh?=
 =?utf-8?B?VjFLVGx5eHU5UU5xLzZ0KzVCa0J1RVhySERGTmZoMnAvQkVQMUR5ZFJsdWZU?=
 =?utf-8?B?cVBaakJMZWo2bW5HTSt4LzAxNEtGMmw1NVpkT0c4Rk90US9mRENMZGpKVXdG?=
 =?utf-8?B?d1dyNEFpb05uQkpIVjhtNy9jUVFYSWRvanlDaWI2d0x0T1RZVlhNVC90SVlL?=
 =?utf-8?B?b01ZUDNRTmVrRmdWMklobVBqZnNucmFudUZXVUZ4QkdvM05ZTlU1V1BKSEtl?=
 =?utf-8?B?Y1lOOVZmTHZNSTNXTUMrT2dTb1pLa0RlbWh4V2xFa1YvcEtvSWJjUC9xSGd5?=
 =?utf-8?B?OEFQcnFwTWVabCtMVnE3OWRGT2NRZkdIVGtPTG1CY1RNaXMxTUdCVDBkQUpm?=
 =?utf-8?B?UWVaeG5vRnNjZ095L2xobExWNWxNZndKSHJzLzFWK2VqaEtPQ1ZyMG9vcHZo?=
 =?utf-8?B?UTBVbk5hVVFTNThjL3J3eEg1UUdPRE9kaXlkaEpLc3ptY2xqOERXSXNZY2ZT?=
 =?utf-8?B?K3lBcng5R3RpK3RkL2RwRUYvRFgxWUZTN3RDeG5VWHJNaTFhNEhValBtQzVY?=
 =?utf-8?B?SjdDTVRKRlA3akU2R2xlUXo3N29RZUpWQ3pwdXlGS1IzUFpiVVdxRTlzeWVv?=
 =?utf-8?B?NjQxY2RybEJkZElTeHRweWJHWFNRTk4vODdOR0Z0ZUxEK3IvZm83UFdxM0x5?=
 =?utf-8?B?ak5hWFJYOXZERXU3UUlpampRMlhveXFOMmpMWS9oWDlEaytaTnFxVkR3UTNi?=
 =?utf-8?B?L1V6Qld1dlRxSUgvczdmV2xDUG4wNk5GelMyeGdCamgwU1hxNTVZc1FzNVBD?=
 =?utf-8?B?NjFyZmxJd2toTTBQR2t0Wisvb05ZVWpwZldibVU5cy9OSm9kb2d6czI5aVlP?=
 =?utf-8?B?V0R4VG8wWk9xNTVjOTBKNVNVTlRFeUVqdjJWRDhjOU95NWxYUEV0aWR0L1Fx?=
 =?utf-8?B?RXAxTkF6aHd3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QTBJQlVvZm1MT2tYcmwvYjF3T2YxbXFkQ2wxQStZdGtPSmdndUN2cXBlN3Ey?=
 =?utf-8?B?eG13c2NXOWR5T05iV3crNVRiZ0l3ZFRKa0NFY0pjNENMc3Q2U1lHNzZSNm1u?=
 =?utf-8?B?N1pCMHJybHVpZ0FzWlNaYlhVMWFndFZkZkFSMmxBaTczVW9vOTVLYUh6dk9M?=
 =?utf-8?B?K2k4UUcyNHlFS2tIM1pqRkszelRDQzlhempscVJSK1RhbG1kWDR6UG56SzhX?=
 =?utf-8?B?bDJMSnhwWmUyRVZjbDFabStSMmlPdmF0UTJ6dTZxZXZmOEt2ajRsU0lpN2Js?=
 =?utf-8?B?VVlBSDBMdktDTEZ0OGwzZ0o2M0pqWWxBQUlPaDdnT1BxNEZIMDZ1UTQxdE5P?=
 =?utf-8?B?KzNSa1RyRUtwa2xFOVl5MjhNamtuS1lMSHpFU25TS0ZEMk1sdWlURTRtQmpo?=
 =?utf-8?B?dXpyK09RcmJFMldYMTBGVGp4Q0gxa05odlZsTnB6R081SS8wMHBPWnZyRGVU?=
 =?utf-8?B?VW9yWnhiQjFwSEZaUnB0eFlsV1JaQXd1ZDRnZjFEZzZwZyt1YnVWaGxDUzFk?=
 =?utf-8?B?TFJtQnV5V1c3MDdJOW5qZUh0OGFZamtsNEVIcDk4ZG5BWGtkN25vcFNENVBv?=
 =?utf-8?B?emZxbUVhL2NJSVczeHZ2YzViZURLMENYMTkzZWdZanI5Zlk3MU9kYzhJNC9h?=
 =?utf-8?B?c3g0WjdzakpJUmxHcVd3NHZaaHdob2lnN3FvZy9yZTFlMTRlNnpDU2pPc1dD?=
 =?utf-8?B?OTdYRzJuOUJyVmxpdE5abUVVSGpoMkJtNXVPLzFwYzBzNVp5bThuWTF5RjRW?=
 =?utf-8?B?QTZocDZ5NElFcnJJbmNUQXFCQzZiNHpZUTJwazJ4WUhCNVBqenc1VVZwNkVh?=
 =?utf-8?B?VXptRjEyZVpPbEI5cFRGeTQxZEtFSVZ1ODBQeDY5RHlLNlVyYWs1bkZWV1V2?=
 =?utf-8?B?OXlmK1pqejI5VzN6SnIyQ2ZmODhPNlZGNmxjeFFLS3R4NHlKb2tLeW5qcmVN?=
 =?utf-8?B?cTdPbWF2aWZmQVpHcEJRYnhvR1hmMGtuNkJUeitUZFhtelpKSTFHYURMRmJO?=
 =?utf-8?B?UnJCN01UQUdnbjZrYWhuQmphcGFGZ1FBd2UxVjhOblRoa0VNV3h4YTFzcmdK?=
 =?utf-8?B?aktlaE1WUFFCNzhjclZBMU9pRGs2QTdDUTRQbnovc0s0RHFFc2hrbFAvTzF6?=
 =?utf-8?B?TlQvd0lobGhpd2ZSQ3NqV3Vkd202NDNRRVJPZHEwMFh1VS9HQktvZ3VhQnoy?=
 =?utf-8?B?RitGMjVRaDNGZGhzS2FvVDVscEd0WVRMeFIza0VuWDNwa1E5QzZGTWtJNjB4?=
 =?utf-8?B?cElaZkZnd1lzWjgyTUpVVFpKU1c0L3RkUWV0N3h0d1IrOVlBVGZraEdtSUNQ?=
 =?utf-8?B?b29udFViTWswS3Y2REV3RkFoVWZmaldhTDBmUHl3a2VxcnMvZTRqZCt0OFBh?=
 =?utf-8?B?UlJBb3J0ZDlNa0w5SEhkbFpqZ2dsL21kZDNBSHdxNG5maWJCb3VrMjl1WjBl?=
 =?utf-8?B?dDFBSURrMllvd012Z3IrcjhKaURsbmFCTENQd2FEaGYrSzBtWnpuK3lXM2hT?=
 =?utf-8?B?V1JtaDU3WVgrREd1c1djK09iNTJDUEVOdGM5RitISFBzMy9JNXdCN2ZFRGpa?=
 =?utf-8?B?eHoyZFVWTGJDdFdiQU80SXl5VnVSZlNScU1kVjFVdGU1WERQUFJIN3FWMEpW?=
 =?utf-8?B?eG9nelBzL0IvQ0tGUzc3c1JjZDFNc04wNEdxSmhqZWFnYmdTZVpQRTBVc2g5?=
 =?utf-8?B?QUlua3Vjd0dqUWRQVklPK0lyZEtCQlFuSUplYVl3WmFRSFVwcGxmMFNTc1h0?=
 =?utf-8?B?VW1VL2tHZkV5Rnlzd0xEbFlZekRMZnJnbnJ4M1dvWVg5aXN1YkVubXlwN2dI?=
 =?utf-8?B?OXBWRkRvMm9NeWJNOHRrT2tpUjR3UGpnQ2ZXSm5oUFhLT1N6OTdNaDFMdjJQ?=
 =?utf-8?B?Qjk2c3VNeWdJc0RTWS9SSlY5ZXd3L1JIUnJuOVU0ZjV4NVBDRzQyMVVwOUkx?=
 =?utf-8?B?cGFucE1XYWVtV2ZUK2hVZlZLWkt2WE9VRnpVM0FxaFo1VUVPUGpyaDEvUmRP?=
 =?utf-8?B?RGlhc29MdmZoS1VIWFdiMXNtVVpFSkhrTXRRWDZXYmJCdmczSmxWalMxUzhv?=
 =?utf-8?B?UGRnRTRhajl2VkE5bTdPODJ3OGw4V0dXR3hDOGNxcGJJV2R3T0RFeXJ2a3k3?=
 =?utf-8?B?QWI1TExSZGYwRExJZE80NWhvdXp1WlgzWEIwMTBmaVFiTjQxSkk0SjA2REQ0?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35E1A002C9BB1A49B244D3AC86805BEB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c51446b-d759-4313-9837-08ddea937c69
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2025 02:42:12.4756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e5tJUZ3EW+fYcEZ+2EsZ/JYBjWB0nQfm+irzzOqY/pfTY5ol4JbUEnnLgVoFjStZ/NcctNUYAnW+HvvuPRFIWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7001

T24gU2F0LCAyMDI1LTA4LTMwIGF0IDIxOjM1IC0wNDAwLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3Jv
dGU6DQo+IFBldGVyLA0KPiANCj4gPiBUaGlzIHBhdGNoIGltcHJvdmVzIHRoZSByZWNvdmVyeSBw
cm9jZXNzIHdoZW4gZXhpdGluZyBoaWJlcm5hdGlvbg0KPiA+IG1vZGUNCj4gPiBmYWlscy4gSXQg
dHJpZ2dlcnMgdGhlIGVycm9yIGhhbmRsZXIgYW5kIGJyZWFrcyB0aGUgc3VzcGVuZA0KPiA+IG9w
ZXJhdGlvbiwNCj4gPiBlbnN1cmluZyB0aGF0IHRoZSBzeXN0ZW0gY2FuIHJlY292ZXIgZnJvbSBo
aWJlcm5hdGlvbiBlcnJvcnMgbW9yZQ0KPiA+IGVmZmVjdGl2ZWx5Lg0KPiANCj4gUmVtaW5kZXI6
IFRoZXJlIGlzIG5vICJ0aGlzIHBhdGNoIiBpbiBhIGNvbW1pdCBtZXNzYWdlLiBQbGVhc2UNCj4g
cmV3cml0ZQ0KPiB5b3VyIGRlc2NyaXB0aW9ucyB0byB1c2UgaW1wZXJhdGl2ZSBtb29kIHBlciB0
aGUgaW5zdHJ1Y3Rpb25zIGluDQo+IERvY3VtZW50YXRpb24vcHJvY2Vzcy9zdWJtaXR0aW5nLXBh
dGNoZXMucnN0Lg0KPiANCj4gVGhlIGFib3ZlIGRlc2NyaXB0aW9uIHNob3VsZCBiZSBzb21ldGhp
bmcgYWxvbmcgdGhlIGxpbmVzIG9mOg0KPiANCj4gwqAgSW1wcm92ZSB0aGUgcmVjb3ZlcnkgcHJv
Y2VzcyB3aGVuIGV4aXRpbmcgaGliZXJuYXRpb24gbW9kZSBmYWlscy4NCj4gwqAgVHJpZ2dlciB0
aGUgZXJyb3IgaGFuZGxlciBhbmQgYnJlYWsgdGhlIHN1c3BlbmQgb3BlcmF0aW9uLCBlbnN1cmlu
Zw0KPiDCoCB0aGF0IHRoZSBzeXN0ZW0gY2FuIHJlY292ZXIgZnJvbSBoaWJlcm5hdGlvbiBlcnJv
cnMgbW9yZQ0KPiBlZmZlY3RpdmVseS4NCj4gDQo+IFBsZWFzZSBmaXggYW5kIHJlc3VibWl0LiBU
aGFua3MhDQo+IA0KPiAtLQ0KPiBNYXJ0aW4gSy4gUGV0ZXJzZW4NCg0KSGkgTWFydGluLA0KDQpU
aGFua3MgZm9yIHJlbWluZGVyLg0KSSdsbCB1cGRhdGUgdGhlIGNvbW1pdCBkZXNjcmlwdGlvbiBu
ZXh0IHZlcnNpb24uDQoNClRoYW5rcy4NClBldGVyDQoNCg==
