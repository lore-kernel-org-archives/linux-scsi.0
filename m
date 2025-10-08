Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771622E266A
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 06:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759903814; cv=fail; b=u9I6ynzyPKzO6HJkLUThvzc+zMQTAatMxhz6g6iKlkHvtzW4OBwSUMZ41K6XXcaExoUtNVZ0tdEWm4EE9upaR6pZIpzanSUA4kxuiGYFG5gUdLa+GHib7iFH1QXDpaTHJqTgbv2GhLOJlTInIEcax6QicIlQ8ud4nxw9OfkR0PQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759903814; c=relaxed/simple;
	bh=GOAgRxKKIlgtcAmCF+8yoYQQqbjU6iidLFDEPu9JVHY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PJkk75AJNDVHRNB8C6xD+0A0q5uBkNAOuIyzkruDkjpxb9rHfbPC+HnzThgeMcDiOBzbuwhxV8arHiY/IIPazwmQn3CBD2QhcodDZSre+eDYRvaE76dvWpc6FeqkRbrc268dDmD3SqgqnBpvD8E4KiNN4TEUtFr5jvUBedhUGj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=D7z9kUfT; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=dfCRUqwn; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="D7z9kUfT";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="dfCRUqwn"
X-UUID: 6e98409ca40d11f08d9e1119e76e3a28-20251008
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=GOAgRxKKIlgtcAmCF+8yoYQQqbjU6iidLFDEPu9JVHY=;
	b=D7z9kUfT1yW7DDNmOu/NPQ7yiZCROym767QcgG0/HHtb1/3P6SyOoKmMNjoSU9OaEEhIsROd+wkPa3ODyLXEiKQp2b+zJc8wNGSFpRSv60ICDuKeBUJgYYxiO6cxPBnt9wIfH4aeE+yUS4H6jnzlDtl6z5kf7TkIq2dRzhEatOo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:9fafef4b-cb60-4b90-a734-b18f03038cef,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:804417f9-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6e98409ca40d11f08d9e1119e76e3a28-20251008
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1380507898; Wed, 08 Oct 2025 14:10:04 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 8 Oct 2025 14:10:02 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 8 Oct 2025 14:10:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cDdMkMGw3UGF0oTgXxRbVOstb5SG+0iA6/S8kKmZtJpz/Nev/B3bX7EnllEKXO1wMEwcmnkulHeAK6Jj/1daKKkzeDUDaJezGP+hpziail+ckDmreRuAcbGdgFC3aHYlZ3to43hrB0m8WJKCfKOhyETOGJGqzSw9jl+bS6kJsca1ncf2vQxHebcLRpSPkHE+KuTsIoUc6W9jK6KV9Wibb/Q1JNfCdcfhoEWSEHdYX7FBPS5maH6EANtjll+GiT6FOzlsFzFpi95/xNubIp9sNdkbCzT4PuHQPBuDCIbdQ+ck4P/8MZa3YrVd/6cCuSiooga6dDBlFpsokYdfqO/VNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GOAgRxKKIlgtcAmCF+8yoYQQqbjU6iidLFDEPu9JVHY=;
 b=NxcJi84HiG27DHYT3mZw6jPP21sr2TbP35Wgd42nb9DVvW2FbB8n0H3cO4umXc/XSdIF3DAh1jwfVkdE4QuSX4MnwZA5W2G6BhUHiYxa2/gKPXvvLrRqI5wbTDdvXQJGV3rOMW5WBE8SoMtjhv2yKayOnNNNCeeeofpVpBpBCFwgTvQRQ0ibdCyeucEtBiL38HVU1pQyeaQOcbiuBR87UCPEC6uTw2ZFHdV5QZlrULebbsrj0pH/dJFD2oQBYwsClcLrkM6lRukuY3glOTDBF1OF9nGKAd4VQ80MybayUIJ+QXkbiVNjNcpx7ky28p9+zee/ud2jSoSz4khFbStOew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOAgRxKKIlgtcAmCF+8yoYQQqbjU6iidLFDEPu9JVHY=;
 b=dfCRUqwn1nFMjdsLq+faXwnkg/hLIvcOUtyp6QqkFY4ONVtXXjQopmoZtp90wp9Jsu+IDLLc5KmVBnajLJQM8cMH+Dr57lAhM/kscE7ZFVqc3yHkRwojWlfv+rokT1oVKo14YNztb6ykRj0AIOJQ32d+jiwa1fN4mEDZnyDLCxQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB6898.apcprd03.prod.outlook.com (2603:1096:820:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Wed, 8 Oct
 2025 06:10:01 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9203.007; Wed, 8 Oct 2025
 06:10:01 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
CC: "dan.carpenter@linaro.org" <dan.carpenter@linaro.org>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: Fix error handler host_sem issue
Thread-Topic: [PATCH v1] ufs: core: Fix error handler host_sem issue
Thread-Index: AQHcNE3xfnA5Lp3JNEepwG1XYGUBJbSwmUEAgAWudoCAAJ3EgIAA5kQA
Date: Wed, 8 Oct 2025 06:10:00 +0000
Message-ID: <0727ae57478955386455a4a8c58b2dbbca49a65d.camel@mediatek.com>
References: <20251003101115.3642410-1-peter.wang@mediatek.com>
	 <3e673104-d36a-4128-bb5c-a71093eda419@acm.org>
	 <c5c8293b093a7d8f03fc8b25059b5566214a8c06.camel@mediatek.com>
	 <68b362fb-b07d-463a-98bc-b0061524b0f1@acm.org>
In-Reply-To: <68b362fb-b07d-463a-98bc-b0061524b0f1@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB6898:EE_
x-ms-office365-filtering-correlation-id: d0ffcbe3-69e8-4ff3-74b9-08de063150ab
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UmdUVkxFU043MGRvWG5uN3Q2aTlleFR1djZKa2VGMkk4VXo1SkZmS0V6ajlz?=
 =?utf-8?B?OExvWjVUWWFLa1U1NklqeWxZS2prR0d6aGdBL2VJRExaVG5xdDJSUXZSUDkv?=
 =?utf-8?B?aVZFU05xbEJVcy9MVjk3UFFlUXQ2a1RaK1JUeit3N2prVWhLUWpOSTBZeExH?=
 =?utf-8?B?OC8wY2diaDhuK0xqdTJnblRiNURwVzBFUE9wT3k5SGlGTWFZN013N0hISDV3?=
 =?utf-8?B?Y1pqYzluRVE4aDFpblM3bmJNeGR5M2p0TGVMS2F2MFVGODNCeTBjRlZ1Tzd1?=
 =?utf-8?B?Q1ZXVnk5MHNSaFVKSGVBbzFNMSs5M3dRbWJZcW1RT2lNQnRPbWdjYlVyR1Jl?=
 =?utf-8?B?ZDlCeDdOR0Q4L0VKTUJDNGlGWm9GM1JHSzcweTRRRFhiVy9Kc1A4bUwzRWI4?=
 =?utf-8?B?U2x0SmJEMFR0aVUwSVJjS0FZN0tNVlNaTjVmbkk5aEtQNWx6MGowcmprV3pE?=
 =?utf-8?B?bzRxV1VLdHdjYzVFbDRobGdaSTk3VnlHcUROSC9OZVdENVF6Rkp1U0gvVk15?=
 =?utf-8?B?TCswdmRPRk5lZER3bXljcldjTnFmbERqVlIvL09CWXQ1NHg2Um1Ec2d1S0ZS?=
 =?utf-8?B?V2dsSjBCQ1pJQklXNDdxU0tYR2NObEVwWUlpMHdVU1MwdjFRaUMwdjFTcUtO?=
 =?utf-8?B?SGUxMXdqWmgrTGdGZzRKaWhPVURibVE2N09TcnlaMjlIaEZub0c1TXBrbjdQ?=
 =?utf-8?B?RDdpemxXV1RWWHVhZDM3VzlOa09DaG1GcEUvdHJCanVqbXo2OU8yRFo2SUQ5?=
 =?utf-8?B?MFlpQnJRS3hITmNURFM0WUV5OFBIYkxCek1UeXJXUENOWUJZVGhKRTBKQTFh?=
 =?utf-8?B?Sm1yK29FaWtyTTh6OHZvWXRySmViWnBIOEFKQ3BGRHVKTzFac0tibzI0cStr?=
 =?utf-8?B?WG5ySnJwaFpscEFkcXJCNUhURDZLcG9tMWQveWhHcjdUTmtmVnNUdGNTRDNJ?=
 =?utf-8?B?WnM3Z0NGTEFzcDVvY2VFT3MzMVhrY2FtSTZmUFV0bFYrcnA4VUtDWkw0R0pi?=
 =?utf-8?B?UlFsajFtckV0dlBGRUNnbU1xbG1LTk5veld2eS93SVE5bk9zVndOMmVGdXRP?=
 =?utf-8?B?SlZkWEUvQmJ3M1RJNkhYa1hUaUxsSTl4WDArMWdxTEoxSS9qTXBueXpFZGta?=
 =?utf-8?B?ekhSY2thVUJuRWZvYzJ3cU9BQmEwdVBXdjZWSE9sUno5SDVsdnhJazNOV0Rh?=
 =?utf-8?B?UUFkem9MNlpPbytIWlRvNUkrem14ZmxsTHJ5S3hJTURIUUNJVjhtYnEvaU1N?=
 =?utf-8?B?eTJlREs3a1ltaFI1Y2grQTlHaGh4cllzWVFzekg1YlpONXgzRlVTaHFEZFd1?=
 =?utf-8?B?akFTRDhKT01lTTJTbDdSdnNVd2hwTEduclA0c2dmcjg1c3JBanBDQUx1N1Qx?=
 =?utf-8?B?RGYwTkRJKzYvZllEYlJqclZMVVJUN2ZDMzhtM2xGSHdYS0t0UTBTaU9pVGtJ?=
 =?utf-8?B?VlkvUEZ4LzNMRi83TWhrc3ZUcTVWQVFWdWZwRStDUFZiWmlVVWpuZk4yMHJC?=
 =?utf-8?B?VjV2SklpSEhYZWRXS05ONkI0cnM0TXhRd3d6RHhUUURSUE5xcE04NHdlUGYx?=
 =?utf-8?B?ZDVxbG9VQTRacEplYnJ2U2xIZnhRd0lBV2llakJ2cjhMVGFaQkZUS1ZKY1FP?=
 =?utf-8?B?UVpCRXVDend5RktuUnJYTzlZRE5qMGdFbjJ5a2FKeXhyWTVTaGE1TllVREVj?=
 =?utf-8?B?T2d6ckNGL0F3Z1hDRW55b3VPOGFSVU1HZW1tRHMybWp0eTgzRS8rZ1VCamFY?=
 =?utf-8?B?bjZleXd5WlBRRWoxbXdJc1cxdGd4ZlViNkhsY3JuekYrT0tqMG1qNHRTc290?=
 =?utf-8?B?bjUwY2toVkhXcGlXT1hmUy9uM1JrbXlacVV2cGhJMzJJQ1pxR0RsYldFS2lW?=
 =?utf-8?B?Vll2OFpGWHNDM2x2WlBnZU5RaTR6NzY0cUNUU3RrbWlpT3pyVFRuZlhPQjdQ?=
 =?utf-8?B?Q3MrWWU4L2NPMkFlZjFqSWJrQ0ZyS21zWmw1OGZUdDYzZkdMdzVKYlZEMmJD?=
 =?utf-8?B?Kzk1OEJKZmxwOG1Cb0pXRm1KL29NNjFMd2M2Z3JPcFNoeHkwSjRUN3ZxUnAy?=
 =?utf-8?Q?JvFWpj?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZSs0UTNNSk1QRmFhVkM1b1NKcTFqMlFXNVcxWUp0YjQyeDc3WnVzNDdRSXM0?=
 =?utf-8?B?Q2RRMEs5RDIwSTExRUdCbXZRZnlUL2JvbTRUL0JuQWt5eUdvL2d0Y09BV3Vv?=
 =?utf-8?B?eVIwOERIaDgxTVczblZPT0U3SDVrL1RsOFBhMVF4ZkMzOVpadnRmSzI4M1JE?=
 =?utf-8?B?MEYrSEpoSFloU2NtNmxyRFNGeUNtQmN5dHVrd2tGdWgxY0UzOXZUQU5BclUy?=
 =?utf-8?B?NmdmZDFiVUVreUxOUFVhN081Y2FrdktFd3czVU1Ra3VnQzRmY3BZK3huTE5P?=
 =?utf-8?B?ZVY4TlYzTC83R3VISVJuVkRuSlo4U3h0dmlzSzd4NEozNWNEZ1FvVjBXbXJH?=
 =?utf-8?B?NFRjek1PdXl0M2VPMDVoNW81WXZ6disvV0RxaWF0Rks5dXlHeWVVWlZFNFA1?=
 =?utf-8?B?U0lieGZJNXduSTVERlh0MHgyM0ptMEJ6ak5yc1c3MTkvTFBRajJaOTF5V0tI?=
 =?utf-8?B?S3ZZUXkrRHk4ZkRkTjU3amtCNk00VzhON2xmTFhTSmZEVjNENzhNYytEWGZR?=
 =?utf-8?B?U1JxNkoyVUNEZ1VsVVhIejR0bnp0UWthMmxuZ1NQbGFSSHlBZ2lNRFpKZnRS?=
 =?utf-8?B?dVQ5VXJuVGFTaGV1ZVo5amhsakl1OGVuVzBNZWtSRjlKV1MvUXhwWll5ZVlZ?=
 =?utf-8?B?MS9HNlZXak5uN09HYmZvZmZuOHhWSm81NzRkditudkI0aU1kRTMycnpucTJZ?=
 =?utf-8?B?MXFKMWloZmtNeVdzaXZPemthSzJLSTR0TTJiYUhzTVl4eHoxTHcvcUF0MGhx?=
 =?utf-8?B?SFp2MzNOajFPM3Z5UWhWaEFjdVFDRTlCNmFROXpLUlpLdm9ubXIxVVNZeWVo?=
 =?utf-8?B?bWRXV1UwaEpTK1pSanMvWnJ2RUo3LzdnTzR3K2JaekFudXpNMFoyU09qTXpn?=
 =?utf-8?B?VFBMdHlSa203RmN4akdTUjFZNEVmM1lJT2VWV1Z5WVhrL3RyRG5oTEdKTk5x?=
 =?utf-8?B?NW1jU1JCUDQvYkRrZURrTFBIQ0VwczdRWkNOTXFqUDZ1VENQSld4Qjd4MUJi?=
 =?utf-8?B?TVAxdVIxU3JqUWVZTUxUUFBUQWQydEdCaVdnZk5GOGxOR0RJM2hFbVBOQzRG?=
 =?utf-8?B?REVxOHNKaUpBUC9XMS9vY0tBTE44OS9TQUJ2NnhDek1qSFZpWlBUM05QOC9G?=
 =?utf-8?B?TkJDVVBIcGRTMnkwVFFCSnI1SWRsL3JkdllYWUVKWFI1cXRDSllzSTFyYmJn?=
 =?utf-8?B?SHp4N29yTElDY1RHcmdPRERHUkt0dTFlb08xTzVhcGJRN3NHV3g2NzE0NTVF?=
 =?utf-8?B?bFR1U1JTd0JwOUEvOU9GWEFoa0IvS1IybE9NSm9FVnZpbzM5Q0dlVDBGUWRY?=
 =?utf-8?B?M1dRWmdQNlExdTlPdzZ2clk4TmtZVnhkb2ZnMjZOcTR6UDVneFlhZTdTREw0?=
 =?utf-8?B?RFhJUnkxbTc3dUdLM3NnTis1QU0wNi96MnVtM215VmlPQnljRW10eWZGMzMr?=
 =?utf-8?B?Z1crOENMWWw1UldWTVpzdUdUcGh4NCsvVmRXdTd4VFF0NzAzUkNmbWx2Y1Jk?=
 =?utf-8?B?V0tFRm5ERm1xaHdNTVl4M2hyeGZncjJlbjYyR1l0VHFOMzJnaCt2SjBJSXNH?=
 =?utf-8?B?NGV1eXd6TG1ocG5kVVkydDA5aXdKZWloNEJZN0tVWjIrM3crcUZSd0xkbFFu?=
 =?utf-8?B?QkhiYkhxczQzQkhTTGw1a05GNlZEdndxb3AyV21Kdzc1aXYxdmRtemFjMFNM?=
 =?utf-8?B?RTFCQ3Jscy9ib3dzU2hSN215c2M1cHdlbjYvamlmNi9xS3BuZ3BCdndSTHZv?=
 =?utf-8?B?ZG53QzByRnFhTkR2TjZ5NWdQZllwQWRmYzVtMUNOeDB3Vno0TUlhS2dQMXg5?=
 =?utf-8?B?OTBPNC92bmhJcTBDdktDaGFjanNlUk5PZmJBaWdDVmlpU1JSN2pwU2NnWUs0?=
 =?utf-8?B?ZEE0LzJDZVdCNWJOa1oyUC9lV1puSkNrRVBzbjE2SzZoSjM3MFpJcUpmNVBJ?=
 =?utf-8?B?aWlNV1JkUzc2eGJLYmZOek1IQnpZNE1MZVB5SjhmenFPTjdueHQrMGlSOEdu?=
 =?utf-8?B?Q0JTc2JpSGdRdFMzdG1hL3JjU2czRGM2ZkxIV3BEY25PWWVxUFEvMzVEajNX?=
 =?utf-8?B?UlVBWFM2ZDZmK2NsWTNuZ1FScFNRZE5vUEtSWVFzQVpLQUtlRkdwRm9wTkN6?=
 =?utf-8?B?UWlrRy9jQlpQOVVvZWI1MG9uRDNFZ1NkU1Nqc1prVDVYU1VhREJjNFdWTUJz?=
 =?utf-8?B?S0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9829E20F9331E24B9F0D6D5E71892F11@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ffcbe3-69e8-4ff3-74b9-08de063150ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2025 06:10:00.9191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WTW3JX9t7k4sFKV96rYzG9u9TgB+uTiR4pXgwIZt1YFvb3U1CvwwYG5s5GnC/HbxPhWDqWYJNPCw56dKPXo0xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB6898

T24gVHVlLCAyMDI1LTEwLTA3IGF0IDA5OjI1IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEhpIFBldGVyLA0KPiANCj4gUGxlYXNlIGFkZCBhIGNvbW1lbnQgYWJvdmUgdGhlIG5ldyB1
ZnNoY2RfcnBtX2dldF9ub3Jlc3VtZSgpIGNhbGwNCj4gdGhhdA0KPiBleHBsYWlucyB0aGUgYWJv
dmUuIEkgdGhpbmsgaXQgd291bGQgYmUgZ29vZCB0byBoYXZlIHRoZSBhYm92ZQ0KPiBpbmZvcm1h
dGlvbiBpbiB0aGUgVUZTIGhvc3QgY29udHJvbGxlciBkcml2ZXIgc291cmNlIGNvZGUuDQo+IA0K
PiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpPa2F5LCBJIHdpbGwgYWRkIHRo
ZSBhYm92ZSBjb21tZW50IGluIHRoZSBuZXh0IHZlcnNpb24uDQoNClRoYW5rcw0KUGV0ZXINCg==
