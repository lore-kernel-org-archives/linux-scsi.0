Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DF87260F
	for <linux-scsi@vger.kernel.org>; Thu, 16 Oct 2025 02:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760580775; cv=fail; b=p8JhEGkTnQ4Y6Qwq2mC/Pc5F7wOd0is03ACEZSbGayPndTHogwiUwTNOkLxQaWmb8ZQHcXJAA9jsmYf6flceqFpFbO4HU2yEVSm6yzDBdu+k1KIA/LSn/wb8H64zG5VQoYD6tKKyzignjegcHfZ/QV/EW5/6u1nY8+fRkhMgce4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760580775; c=relaxed/simple;
	bh=D+BWY8KczkAFL6XVUjI6eLNCIIoFLDcJNwpYVb8CPJk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hvjlAK+gmWhY6T/T5vXYYhps344CM2fuFUPLbcUwxWdQFDcQkvKoUyTJaXs0U5swuMu/kDi+522r49W7lENUihO3cbR8ICaguOiutZ+ac4bmNIx4p2ASAjNlxcWe9MgZWlkRU8mfEfmOIDdAmmybzTW6WU/x0XcWHEzxm2GKMvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=RWJFhTss; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=RFLDQzjt; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="RWJFhTss";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="RFLDQzjt"
X-UUID: 9b2eb414aa3511f0b33aeb1e7f16c2b6-20251016
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=D+BWY8KczkAFL6XVUjI6eLNCIIoFLDcJNwpYVb8CPJk=;
	b=RWJFhTssiaG8H0lRpH9snnzXjBwZjbHyj1H9eYFHFZSUfpa1z/sJOrwctvB2WMmVf+rYR0IZRPxissB8YVbgNGh+duaeqYJsiwiXjTgHB2ILyz7zQC95tUJtmyE4blgK6/+h0iFPitVIcLD2sJgRzgpD2m8+gSMTDvb1Np+kuaY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:a9c19c7c-63b8-40ee-b13f-b557a4e757db,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:224b7002-eaf8-4c8c-94de-0bc39887e077,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9b2eb414aa3511f0b33aeb1e7f16c2b6-20251016
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2017055996; Thu, 16 Oct 2025 10:12:46 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 16 Oct 2025 10:12:44 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Thu, 16 Oct 2025 10:12:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A1C18K/kHa0ulKBc+mQi2ZGTNQlCuedF1rtdiua/pjsEYQyTuofgJVyQqfO54Q1+jm3QtFx8jxeRpAU1df8rQy615QjT7eon+14bfbLPuhon9j/7j3y5Gm7cBLE8M8prCEW1D+sx3ljDcfqaUnFuu9an/ivAyDU0sQUs9W+DFX/PJixl15hp7UhrxBOgPcAoTtlxL2sVv/j67xiA2lIZ+uPKokIjtmV6I4rnA0rgCwD1co51fTFsEiZhFWWIjvBgYC7PbBghAvxZfIKdWvQHpDypc+cY2Oz1Yqp17f41/0HAAyLHRBc3DznA2N05GCcaA2rwsWxrxMAaWnvmCI2m6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D+BWY8KczkAFL6XVUjI6eLNCIIoFLDcJNwpYVb8CPJk=;
 b=K9SXBjOCWQNri9RFFmdvETS8VWHv3irgINDTwp7ibuoNhhYqNjwUI25JFPcFxwfZ+RJcfA8618XmjhsWDA7fUsssWlLUskogvLfVq4hhqq60Lz9/ncuLuqh8SJnGJP6rgb38fkszUwvxomKrMhlyVUbmt+JlseFLJS4yl/bPHwfoN5B81JMkiKPaeKUYdPnImlqszeEKtLWTeotcEdLIL/MIXvvYfAWIUXA3B/TkGo0ZLSZhpRkXPGXZtiiM7rZ7DtEl/0Ch/5V0Tu1yoqRT26ykObIfQuf0EDdav7rkq5Q9VeZuvHld0j9PXMCqPKpJ3Ey6ES2tLF0IemId6cI2pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+BWY8KczkAFL6XVUjI6eLNCIIoFLDcJNwpYVb8CPJk=;
 b=RFLDQzjtKh+RBZBZ0OyozaPzgbv8CJENnUtrToSitVmlzrk9FkxUqsyxL4PHI2bpcjyE9BAJEkDN35OGQLPk31H1NZEITLe3KTYPFw1qBiKERLyz5QhYR86Qil/HzUdfzqR1TJQXC1jy99hWX2F2B9unoxBchMWlSrlT84WAlvY=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SG2PR03MB6609.apcprd03.prod.outlook.com (2603:1096:4:1d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Thu, 16 Oct
 2025 02:12:42 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9228.010; Thu, 16 Oct 2025
 02:12:42 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
Subject: Re: [PATCH v1 2/2] ufs: core: support dumping CQ entry in MCQ Mode
Thread-Topic: [PATCH v1 2/2] ufs: core: support dumping CQ entry in MCQ Mode
Thread-Index: AQHcPQ0IivSyUnOet0KA3J6Dhj8HJLTByVoAgADym4CAAKOKgIAAqxqA
Date: Thu, 16 Oct 2025 02:12:42 +0000
Message-ID: <612721b06de84ca369d9747dee3ab6a5f96e5543.camel@mediatek.com>
References: <20251014131758.270324-1-peter.wang@mediatek.com>
	 <20251014131758.270324-3-peter.wang@mediatek.com>
	 <4c47f800-0536-452a-b64b-d177fa306418@acm.org>
	 <b9a9157e09cde6ea17f9a0f36a4ad11fcbcf0b0b.camel@mediatek.com>
	 <fa118df9-0b9f-496e-abf9-bf608b9e361b@acm.org>
In-Reply-To: <fa118df9-0b9f-496e-abf9-bf608b9e361b@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SG2PR03MB6609:EE_
x-ms-office365-filtering-correlation-id: 87724389-ac51-463e-4ae2-08de0c597d19
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?MWNqZVVTUG5oc2szWWRFWUM2cUZFVnFaWWdnbWFOakRLL09qcTY0UVZDSFM0?=
 =?utf-8?B?dzdMamowYWlVWDdDOWhZbWpSajIrNjM0V2RyRWJmSDJzODZyeDd2UER0eE9p?=
 =?utf-8?B?OFQ4a2pJaS9uZzJyT2xiNzR6Z3JlNTlWV0ZDb2xXOGYzMk1CUEZJR1VGemow?=
 =?utf-8?B?ZTJyblJJQXo5YUlmeHV5c0prT2lTTGVxWFd1MVQ1UDNjc2JqcGJzL1Q4WlBu?=
 =?utf-8?B?NFFkUE9ZRlQzdnhkSDlNV2RQSGtZU2tNK2pYL2c5WXVqM1BEamJwYmtRSzQ4?=
 =?utf-8?B?NWR4bWs5ck9zZVlzUk9tTzRucFR5NDVzSTFDU3BHNm5QWjRvSEVLWFJVNitq?=
 =?utf-8?B?WmZUc3BrbStremh5cTVkcWtzMDFJVHgrOFNVQ0xQTSt5WFpmVW4vSm5SOEpI?=
 =?utf-8?B?eW9DMnMzVWdkMCt2VUpnN1NhaFRRUGdySjNEckdwZGdtQzBvWkFBTlhWQ0c1?=
 =?utf-8?B?RHpQZWJDTnBoamxneGpHUmNEa0ovRTRzREdMc0t6dm1sZ0NvWEZsQTV2T2J6?=
 =?utf-8?B?TTBMVVNWK016cVVWMjZ3azVRUC9UU25wc3NLSDJRRURveWgxemF1NTZaZ0dp?=
 =?utf-8?B?VFhqU0FBTmdSNjZDYWtGTW5XTXVpQ2Y2bzRYVnZTbjVDZjFRdVJzWjFNam11?=
 =?utf-8?B?Z25iblAxM1lnN3lScmZwMTNTT0tZNDB5UmdRWVNOV2RHS0tYMjFCTGFJQUdO?=
 =?utf-8?B?WXRGb2FqUGo5RlRXQ2xVMFZuOG1ud0dpSGhpKzN3ZXMvSE9idURVeWRic1FN?=
 =?utf-8?B?d1B4aFp0QStFTWM3Zi9SNWJHOFY2aHpQcnNnQVBxa2tmcG1MRTlvZXpmQVFI?=
 =?utf-8?B?eDN2WG1xNEw4Zm92ZmlWaTRyVHRNM29TdjF5TjhEV3JpM2FyYmlEUWJSSUNx?=
 =?utf-8?B?a2F1bGhSdW1Fekk4YlBBRldweGZIdENaMDVOL3BsMWFyMXJzY1RyUGI4d3Uv?=
 =?utf-8?B?c1VwMmJQRkFNdFlRUDdBbzdCMDRLMXZPejFMWndmYmtrMlNSY0dObUNZWHRn?=
 =?utf-8?B?UmdVM3BkT1YvcGdCQTFhWHpZbTAvS0x3L0FNYVA2VHBhZ21EUFlNbW1SMGRQ?=
 =?utf-8?B?YjBlQkdXc0h5UDVmeTlJMGhJWkdPUitRVGlERHplbnZuVWVZZVZtVjlEbjFI?=
 =?utf-8?B?ck5tVVdsRkdkdlpwUkY2cXJ2NTZqV2dkbmRCdkE1aWQyZitmRlpPNm5lcTdR?=
 =?utf-8?B?VXFVa0t6WEtPc2Q1V2cwcjVjUHR5cjFLVmdxc0hOTHRDMitHWVJlQXozL0Mz?=
 =?utf-8?B?dzE1YkpCL1NqVnlqUmQwdnE4a0NsVlA2R0VSZmZqTUgvemZnZHB2QUVQN1l4?=
 =?utf-8?B?a3YralkzRUY2ZzdVUEdKUXZHY3RucW9Oa0tUeUJWWHY3bE9xUUJZczl4Q3pj?=
 =?utf-8?B?TFBCUUQ5a05LL1JHcXFlYWppQ3IycFl3OERCR1pNVGhtWStSMEg4WGY1WE9z?=
 =?utf-8?B?OHJFRFZZR0E0RnFuYU9XRlRyNmtHckxPZHNIendIQzNMZXZIUmdQM2lLem9C?=
 =?utf-8?B?UndLckRraE9GWkZQR2VYU0lIcnlUSFdzL0JNUmc1R3FBY1VCSW1sL0ROTUZj?=
 =?utf-8?B?Y09naFQ4Vld1QVFmUFJHV21lSUloQ2pPNkZIRHA5TXhlTUQ0bVBlQ2lCdTJG?=
 =?utf-8?B?b1lyWFFYYzBGZ2dpVUJwRkV0LzdhRnNNclgrd0RkemlJYmdFQXpDejlFNTdt?=
 =?utf-8?B?RE5la3VOeElGU1podEdLRUl1dE5aUWQ1STNlTEt5VDBzN0pwNlEvdk9ZQm9N?=
 =?utf-8?B?T2VzdjErTStHTVVKUjd3Lzg1UzE0c096a01nbVNwK2ptaFI0UDJKai9GSU04?=
 =?utf-8?B?Q1lYYnpRczJML0VFUkdEZ3QwSjdtbDgrdHlOMCtxSHRCU0hMQkU2WVl3Q0lX?=
 =?utf-8?B?b0VlNnNudm9KaUtFSHp3aFdTbjVUUWpIYnEybERYdm5BbGIvZFcxVnJkOEVa?=
 =?utf-8?B?N2h4ZHpxT1RsWnhzRHJKUlVvZ2huSkR6Q2RCQy9xVGJCM3M4b3hXYkVBNlRH?=
 =?utf-8?B?OU9ybXB6Y1Qwa0ZtMTFxUTlEeEhJdEkzSUVKUWpmcFUwOExRM2tSMTI1eVlr?=
 =?utf-8?Q?dweBo1?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXA1OXVxcWdHRVNLR2J3dlNtTHg1dkZkSnEwUGlCekNXNFQ2MWhuQ3B3SHJk?=
 =?utf-8?B?MVcwendJQklLb2J2N0NOeUhnMzE0L2s3aXJwMGlQUzJ2UnA5TXB6aFlWb1Qy?=
 =?utf-8?B?bGtHbStGYzdub0h0QXp4eWJNbTYrRnNwbjhYeG10TmQ1cXdyQ2I1TkZxL2l2?=
 =?utf-8?B?RXNOVllkU0ZSOHp1ZFMxWjB0VmVFWUtHRDVISjRMRGJLeVVmVDlaMVVyWHNP?=
 =?utf-8?B?Q0htWTZIQ1o1V1ZHRWxLd1hTZ0o1SVU0QkhubnBhSDE3RU54cGo5eTRyRmZ5?=
 =?utf-8?B?RWNjdktFZkxSS1N4M0tqZ0NoTlZkMWJNVFE4WVd5Y0p2b2R0Z1JvUjFXV0x3?=
 =?utf-8?B?M3lFWXJsQmRucFhtbEt0K1dYb0psMm9mTWx4aUhZdmpydkVGbXlGYlZzMUpS?=
 =?utf-8?B?MFhvVDdDa0N0R1ozTlVKYi92UUhMRVEzV2YyZVpCQ2wwOXlGUGhvbENaazBF?=
 =?utf-8?B?SUZaWGxmZ0tCWHh0eFYyaStqbzVlazRRaXpJSFQ1K24rNVdxUGNVSVVkQVJ3?=
 =?utf-8?B?RDZsSGdnUnAybU5NTTBDdm5BVkNaanZHUkhvSHFmR2I5UHlYN0lDVmVESWNZ?=
 =?utf-8?B?ZlZnS3BYSERveUZBM3AxVGtaTzZpelU1MGtxODZQVm1yWlcvWlJxbjRXWjlt?=
 =?utf-8?B?V3p5Tlcramh5YytQaDJ4WW4yWkFtSFE0ajcrZ2Z1aXhIVmRJTFhPMkE2VmtT?=
 =?utf-8?B?dkJLeVN5QVBEMEw0cmlWck0yMkd1M2xJY3ZTdGV5Zmt6V1A0cFZPSWduMnZQ?=
 =?utf-8?B?N3JXVU9tUDlnVGNpSHRrSXE3WFBBVG4wZVJZMXVrZHB3M2w0K3E4dlhIWTVF?=
 =?utf-8?B?RVVJNG5JblVzMGRwTThNc1hINHJvQWhkQksxa0I1S1djb0RQajBwQjhGelgw?=
 =?utf-8?B?dlovMFp2dk4rQllRdUhoTW14cjNiQTBlb2FraTN6ektNdVlCWVNrRmVhWkVy?=
 =?utf-8?B?RXl4T0FQMjhkSFFBRXVxS0VNSGl0K0gwbks3aFJSbnZOQkdUdHNkU0VRb29F?=
 =?utf-8?B?YmJPWVhIM1h6Q1NnYng3aHNNV041d1pOeFJmZU5nUXBDSkdiWjQzekpBWTZw?=
 =?utf-8?B?eGlWRS8rdmhYeFE3ZkZ2OXpSa0dkVXcwQXYxci9Sc1RkOGZjSEJacjJNbkZ5?=
 =?utf-8?B?NUV3bHZZZGJraWdDZm5JdnBZZXFUWE9QRjdzZmVPNU5oT1B2L2R3WCtjY29p?=
 =?utf-8?B?L1Q4MGw2aW1RcTNDbTdsenpMWFVBeWl5ZEw2OFZ0VVhNc215WFJkejZKMFl4?=
 =?utf-8?B?ejlvclZBQjJMeHRWN3A2NlZSYjJ5L2JyQmRHT0hNZmZJUFAxa3pXNFo4T1JX?=
 =?utf-8?B?L3k2OElmUENYUytlUGxhVEVOTGtFaTFWS3JaTGh3QkdxZFFFSWJ2U2ttcEFr?=
 =?utf-8?B?VldaRlJoZklXTnFha3JOSm9BWEZ1Y1hKWjNvUWZhMDZiNDZFMG5mN201b2dH?=
 =?utf-8?B?QnI4elBvTDlnRE5acCs0TlNYS0lXOHh0TWU0SHpuUXk5Tis1cFFDdGJZbDdX?=
 =?utf-8?B?VDVIajh2YVg1MWx2c2trU2I2ODFPcE9kZ0xUT1pTdldyWGhZRnNaM09tZVJL?=
 =?utf-8?B?dWlXVmVGTHhvRHBaK04zUWZzSmZjeDB2dkRBTHdzTGh0NEMzaVZYRDFvT0JQ?=
 =?utf-8?B?R05lQzdtQ2VZaTRnNXp6Ymt6WUpNQ0g4YXlNbU1wNkVrOVhqQmxkODdkUGMw?=
 =?utf-8?B?VjV2RGt1a1N5WFVUWUs3NkNsWDdidTdhcHhOUm8vUU0wUWl0czVOdEplTTdL?=
 =?utf-8?B?ZzdyczRMSVZsUUlyeDJoOHNZMmkrendmWWZ6c2tzako2aDZnRTVsaHhMQzJ5?=
 =?utf-8?B?WnhRR1dqbm4wR0puUGw3ODNvRDBqdmluakFLT1VYQlRERTZZM2ZrTFN2ajdx?=
 =?utf-8?B?cW9nUkxMR3EzNi91MXdNSXFUMjI5UEI1a0RVcGMyWjZXQTNsRnlwaFAxZmU5?=
 =?utf-8?B?Skp4ejYyN0owSjFhOFV6c2EzRGNEcGNTUEh1ZDhYdXZCZkNqU0hIQWM2ZVJx?=
 =?utf-8?B?cnhwOENzK1g1amtqUlFsSjE2SjVLNGtJZzh3bW1ETDhKNHZKZ1hua25USG9F?=
 =?utf-8?B?Sy9rNVN0Zk9KL2xTUFZjU1VJYWxXcEY2UUkzMFB5M2NabzlUVE00WndkS1Zr?=
 =?utf-8?B?eVhFZlE0QTZoNFphVW1JSVcyWklKa3cyRHdYSHFyR2h1ZlZnaitkR2t3VjEr?=
 =?utf-8?B?dHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0613B57D57EEDB4A907886537E55C2B8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87724389-ac51-463e-4ae2-08de0c597d19
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2025 02:12:42.3028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9W0VSQL0m/zuLNXO5BMoEMZ3lS9rkkQ+G8/alEZlGETFtil3j4JZoXL48MKsCZvnBrZKFSC5m8jxw8lEsUM2Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR03MB6609

T24gV2VkLCAyMDI1LTEwLTE1IGF0IDA5OjAwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDEwLzE0LzI1IDExOjE0IFBNLCBQZXRlciBXYW5nICjnjovkv6Hlj4spIHdyb3RlOg0K
PiA+IE9yIGFyZSB5b3Ugc3VnZ2VzdGluZyB0aGF0IHdlIGR1bXAgdGhlIENRRSBkaXJlY3RseSBp
bg0KPiA+IHVmc2hjZF90cmFuc2Zlcl9yc3Bfc3RhdHVzKCk/DQo+IA0KPiBZZXMsIHRoYXQncyB3
aGF0IEknbSBzdWdnZXN0aW5nLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFy
dCwNCg0KSSdtIG5vdCBzdXJlIGlmIHB1dHRpbmcgdGhlIGR1bXAgY29kZSBvdXRzaWRlIHRoZSBk
dW1wDQpmdW5jdGlvbiBpcyBhIHJlYXNvbmFibGUgYXBwcm9hY2guDQpCdXQgaWYgdGhlcmUgaXMg
dGhpcyBjb25jZXJuLCBJ4oCZbGwgbWFrZSBhIHZlcnNpb24gDQp3aXRoIGl0IG1vdmVkIG91dHNp
ZGUgZmlyc3QuDQoNClRoYW5rcw0KUGV0ZXINCg0K
