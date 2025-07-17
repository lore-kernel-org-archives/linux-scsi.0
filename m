Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE18216E26
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 06:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752734438; cv=fail; b=Mxfr4PuqQdiyy0QCPbHDv7jYvQ24SdTstVFZiFHcInDH3c5s00H7ES2AH4jZuNVKxU33NcZ/MaPeSVwtlqukZbXWZ4FGB+8U8tYjGOeVPXyq1CH64jgeVEb3hEA3cLESH9JP/BTqG7wT+JB5aI2/37SJVC3PtBXKOhR+S4aENno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752734438; c=relaxed/simple;
	bh=Xvux4QsuJQKijmqodi0jnrj0PPYbTiShuWIeFKmbeyM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AAPveafytkbTYDZUf3WOnQH+o65I7tmdPEGD7UkceoLOQLboHhFOJeBbQksXWuGldN0M5n3aj2rljL1ejF61XGul5nf7byBA+hd9/WT56G1B/Hbdp0iPJc+mhn/LsMc2XZVt3QKp7qmsgBamRB41bwSZeC4f0kOZ8iHWQq72TrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Ri28FxlK; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=eofEn0Qq; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ri28FxlK";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="eofEn0Qq"
X-UUID: eacf9cc662d811f0b33aeb1e7f16c2b6-20250717
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Xvux4QsuJQKijmqodi0jnrj0PPYbTiShuWIeFKmbeyM=;
	b=Ri28FxlKhsvSeQ3lG7PxZ0eHr21fUwESqiqFAwrNU+WUbSkN9N/HoxCl1P1AUFwJs3MhSypy/voYAOPTOCv24fsYKmfgq1J+Vnl3psXGoxlwEXbZOp1VZt/8rgTxpoUJEXKdTaJPb/vBLpPq4h84DF0VfS5jeAExsuY/oSIsJYg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:60268056-f05e-4a70-b9d3-23ef31f2f5bf,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:8e968984-a7ec-4748-8ac1-dca5703e241f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: eacf9cc662d811f0b33aeb1e7f16c2b6-20250717
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1555743020; Thu, 17 Jul 2025 14:40:24 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 17 Jul 2025 14:40:22 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 17 Jul 2025 14:40:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lP5R1binZTlftZ9DyMgFM5AvGEti/dSLRpGtZw+YA1d/68BxsEQWXsfSYuzVxdWawovOTIlIr34rBatuprDRbx6tHtMZhbQqD/bTeJ84z78csPL0VfOFM40hMk7UGl2h2cpU+6HXWMuyAWd3PHseQ1YcftDd77ZQxPBvQaVrrOeQXwd0y2gV+Y3kA6515/3yLFLG+ZaJMnj0b6OQsfRvz6MuxhS/HNOud45K6YJTMOT8X/lWIH2ytrnzVnccyYdL0278NlX1GGF3F7xeOjpHYsKq6GkgksnNDWI+CYx4Pb9j4wtgAAd9cZ33nJGVRifsLsxQivESRijfLasa5HmZVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xvux4QsuJQKijmqodi0jnrj0PPYbTiShuWIeFKmbeyM=;
 b=CjCRw8C8Vt+oev9jmZbqI/BLUg5tPZbJlAnNJOZRDo/wrHCZp1vCqa1Ff3AObwGTegzM0LQ510dWhZce+Llf9qSHRDQlwOpdNtpa0oFLy/ZXW86uqGIcoYvIbaBN5xYKXMrn30vxFtCQHzfDliNs6F53MFVcyOqXSx7x6xiKhdYP77K+ZVhatXWaoXCTHKDZxsr/D5MSZBJhVSt2li71hegmnX+/l/+aBz1CWElys8OWL1Y728uVQNkUXz+Sy5tpx++Hp9TEhDPwGdDTHRhdIIapiuLdRhrYkHB5FaWrra/ddIr5D5HGJwFm3M+KnDN6O7ZRursJFluq9azryvm65Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xvux4QsuJQKijmqodi0jnrj0PPYbTiShuWIeFKmbeyM=;
 b=eofEn0QqYU50PywYjaBi3rQdEBW+ZsmDZl/tEDoofi5c/TXsVB9vUngvCcJcQKDbJQW1t0blnW490lEdTsdps/1lJ8MTs+mz4q1keochBwd5uy+HEHlSKkkkLALlJYwSdO19+OCr2jgU5vlKISn1oLJW23e4fkMT89FCoxNj71E=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSQPR03MB8460.apcprd03.prod.outlook.com (2603:1096:604:277::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 17 Jul
 2025 06:40:20 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8922.037; Thu, 17 Jul 2025
 06:40:20 +0000
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
Subject: Re: [PATCH v1 02/10] ufs: host: mediatek: Add DDR_EN setting
Thread-Topic: [PATCH v1 02/10] ufs: host: mediatek: Add DDR_EN setting
Thread-Index: AQHb9hr/5z0KeLrWQ0uaAXcZhdl+lbQ03rIAgAEAa4A=
Date: Thu, 17 Jul 2025 06:40:19 +0000
Message-ID: <4cf73b6be43aff6c9b1b126a9b8eccb9144ebc41.camel@mediatek.com>
References: <20250716062830.3712487-1-peter.wang@mediatek.com>
	 <20250716062830.3712487-3-peter.wang@mediatek.com>
	 <9aafec2c-199a-4373-bdb1-6031f574af6d@acm.org>
In-Reply-To: <9aafec2c-199a-4373-bdb1-6031f574af6d@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSQPR03MB8460:EE_
x-ms-office365-filtering-correlation-id: de863dd9-0cae-433f-ffd5-08ddc4fccc9c
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TXdJdmgxbjJHMUloY3ZjWlNTWThRUzlqUWIwdUdNaDlmNTRJWjltSnZ5VXh3?=
 =?utf-8?B?QmFQMGwyVDI0VzF3WElqQllQdDFPNUF2OVNDcUlRVzc3SjladExNQ0FPcGFw?=
 =?utf-8?B?ejAvZk50RE9oNlNxdFhucnhGc2tlUENLNTJxNitPeGJqcTBUenYxcWRrUXli?=
 =?utf-8?B?TXN3dFNDSFVlWldvdWJzL3ZwcDBOOWpZYmFnR0YzQVViZkVjaHZQU0RlK1Jw?=
 =?utf-8?B?N3FpYjhyL1lCUFF1T3QrMXhwdENTakRLOXRWV09SRjFJczA1YjhkbnFxUy9k?=
 =?utf-8?B?Yit6ZkMrNkpwb2EzMEV1NkhWdmpiTldPV0xJRWtDb29pM0tCYThZZWJqWmVN?=
 =?utf-8?B?RDVSOCtXU3RpZnA4VmJqMGg5a0x0Y24waU80YzJ3RDBKeDRtbkVPemlpclh4?=
 =?utf-8?B?VDduSG5BZzBGOWsxTTZubmdIQ1JhOGFSZmNLOW1BL3hoNzdFOUFFTkpyT3Vu?=
 =?utf-8?B?RXM0NUNqc05saGZiRlp3MTBLNzV2SHh6ZXdsdXE1bWlIQmdOdEYxWGltTGVx?=
 =?utf-8?B?M3c4YnpPMkVPdVdDdDlyb0Q0T1hiUSthVnN0N1BQL3dpYk5wU2l1aXc2dDlo?=
 =?utf-8?B?azlRL0RDOUlzUWtsL2VzKy9CaDZIWU8ydTBzOGNqOUNmaDhqdVduU2JqTVpt?=
 =?utf-8?B?RnVoalRHUEFwT1ppNDFqTklobnNIZjFRL2FyKzRGbFJQcWZVNXZiTlBkNjdC?=
 =?utf-8?B?eU1kM1pMVlNaZHhpT0ovcHNhLzgzclR2VWwrSkhQbDU5Rk1saTdMU2o1MDhT?=
 =?utf-8?B?cUV3RWpGVnRnZC8rTysrb0dwRGtWUjRYMmtETm1lcnJFb05CaVAreXpWekpw?=
 =?utf-8?B?UmlMU0k2NnBTeW5xVVMvb2x2R2ZWRXBnS0xpUDcxenRFWEV3T0ZzVlVIbTky?=
 =?utf-8?B?eC9SamFYTFk0YmlsTklJYmFOMWJDdzQ4Y21mSGMxOTN4VXg2MUtWdzZNb3JQ?=
 =?utf-8?B?YitoblhUZ25TbkhYWFJtdVpzVFJmQ0JmallFbDE5d0JqMDZxSEZyVG42aENo?=
 =?utf-8?B?cDZlempLcDVXbHdERllISUNMRzRTQUhNcVFFQnRwdDRiZ05BeEVZaE8weWM4?=
 =?utf-8?B?VzRaWHUvK0ZXLzhvZkJsTzZlaWg3ZWhDWTlSaHVCWWVMTThqOW1YWjYvdVE0?=
 =?utf-8?B?bFBacFEzb25HTDkyUTBibEUraXVYU3grc2p4QkZxRjR1SzdUaDU2bVV5RVlG?=
 =?utf-8?B?QVVlbWNkcWJwYkIraVg2Yi9TTTl5dE5xNkl0K0ttYWMxUUFOZThhdVlRL1FG?=
 =?utf-8?B?SUZ3TjNEWmp4NHBsMHkrc1IvQmRSZ2NScWRMRW5BRERTYkFuNUxGQjBHemJa?=
 =?utf-8?B?TjdpTkVRd2JaWGlVSHlmemZLL1FydHlaL3NYekNqeGVSaVIxR3RWLzBjYVV4?=
 =?utf-8?B?ZWhOM05Ga0VhbHNvbXlQNG1JQjJ2QkhXbHZaZ2pJa1BFOThPK3ZXVktMdUVk?=
 =?utf-8?B?akVTUTdKVXNodEVtK3pQNnl6Nm10SUQwWHI3bm5mTWV3SndVK2FLbm1iZENT?=
 =?utf-8?B?T1lVcVRqcGZ1UUNkdDB2Y2h0YjU2M01ORlpBK3dLSSthcndrVHBRVzNSbk11?=
 =?utf-8?B?ajEvWk12dmdSSitLcjZXM0pLV0FKVEhuQ2hNTVNudnNrNmJranF5UjV1a0JQ?=
 =?utf-8?B?T09WUEl5Sk4yR0ZIdk8wWkMzVGtQZVFlUzNRNTlXSmdPeHk0UUR6OHhPYjlk?=
 =?utf-8?B?eVYxcHBhTW4xbkxoeWdzV25CazBNZUNKRzN2STVBZzd2NStCZHhhcHcrckRB?=
 =?utf-8?B?QnhWZlJIdkRPMWo1VWVyUlUwakYwYmgzL2NXcm4zaDB4bW9qcUZGTnBtL1hp?=
 =?utf-8?B?dC9EYlJsOTNjNjhubEtrY21lN09qZmVlRUtybzRZTEFLMzdJUjFhb01PaUVQ?=
 =?utf-8?B?TTVGQi9ZeHpEaEh0TFRVRmZPRTRObmdReVplWVRqejYrQ25xbWFNSkZBRjk0?=
 =?utf-8?B?ZG1tcW53eDd6MmNnY256TWswS1RPUEhpT05PNk1zRjZKbmRwQ2t6Y2lpbUtP?=
 =?utf-8?B?OHNSaVBaN3pBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VWtGTnl2U3lYNlN1WnNTWXY4ZzZ3cXA5TThNZ3B2dlVMenRad2owNmRzalBv?=
 =?utf-8?B?RW9GMmp5NW9VeWhIbHdrd1lIUHB5b0Q0am5Sb08vRkgxNDdDSllVa1JZaGIv?=
 =?utf-8?B?ajVJUTZSZnlyMStKVitNeDNDK1lld3ZKV04rOGI0NHRNZ3E2SnVxN3lmQ09v?=
 =?utf-8?B?Z2xhVCtBTWtaSzRtb2U0N0x0cE9GYTJ4QVdEZlpOaTF6blZlRDVPUFQzNTgv?=
 =?utf-8?B?OGZOUXQwc05za29ocjQxUTErZnl3elBDK2RqUmFET2VDNngzSDR4dnV3VHcr?=
 =?utf-8?B?UDh4QUVMN1JrcXp2Q1ZSOTh5YlpjRzBEV3ZiY2VwL1FML2hySGllNXJWK0ls?=
 =?utf-8?B?c0NuMkUrQzJjZFRNai8yVGRPenpKclFSR3ZxZmErWjMveE5UMWUrbklDS0FF?=
 =?utf-8?B?YTNUN1dWbVNJd1A5c1JCbXYvQlpzbFRGSHJGWE9RUVJCNU9VWXRhaWdueHFW?=
 =?utf-8?B?akl6bzZzeHcxSEZCRzlmNHdJUU5vaXVERXI3OWNEWTczak9hdnZadWcxK0NQ?=
 =?utf-8?B?NkhjN05LOXpnRHJNcDBSb1c2RnFMaGtFWTAxSyt4SUpLUnkvNExhTVFRMUt6?=
 =?utf-8?B?TDBYZGNwWHpESWxudVNIV0ZubEtlcnpOYU5EZHZSMkE1MDFsYWM2emRId0VZ?=
 =?utf-8?B?N3VPNDB4c0t1ZFhqb0xvUGdCRUx3NU5NUmlWYmVETXBsbmJWRTZzdXpQRHJr?=
 =?utf-8?B?WFF2Q3orVXRXaSt4V2N2VXNLRENSQlRZcmMxbXROdC9jWU05K280OU92ckJu?=
 =?utf-8?B?ZE9wUjlBdlR4MzZBQ1gxUUFVMlBpeWZJdUlJamVwczN1VDA0RktQS1JJaUl1?=
 =?utf-8?B?elpVbFlNSXpUQWlOTEJEcVlvakMvc3preTNsRTM0WThDZmROWUQ0cXFMdy83?=
 =?utf-8?B?bGlBZFYrRHdJWTRMc2FzQm5LL29uOXVGSktGaW5RQlB6MVNJbHVUTC9uNVJR?=
 =?utf-8?B?VXJXaFg2aVF0N2NvQm1QMDdVUzZDcFBDdXMrcUxpMkFMK1RQc3Q0dXNBc254?=
 =?utf-8?B?Ylo2bGpwU21UbVBBaVNpeTRLaTVua1ZnMTBQenJBMFVSYmgwNjBYdGpBODZZ?=
 =?utf-8?B?NHpFV0p2cVVBOW9KMHo4RFdGSkZXUFdEQzRpa0xzZHNKZHdDZmtWekwzSStq?=
 =?utf-8?B?OGFPQUxjWnBiNDhIR2YxVG1VY3ZqeEIvZHZ3UWt1Qk9aSWJJaTk4M1NNQ0pH?=
 =?utf-8?B?VzRKcUkzZmhHRW8xWThNV2Z5SFV5bmZlQlpadkdheXNOKzdrajRQd0d0dUYz?=
 =?utf-8?B?V3lLUUZuTXBwM3RyTXpuWnA2ZW9XTC9pdXJwZ3d0a2wrRDM4NU81c2ZBZ2ow?=
 =?utf-8?B?THhId1NRazM3dmtXVzBoSjVKSmZXZU9XWXR5ejFzNUwrTkttUUFWUzZybTl6?=
 =?utf-8?B?d0RvNlR4YUNQZ0xBMWdNY2REVE5tWjliSUVmeURFeHJuR0dmVHYxekV3azJo?=
 =?utf-8?B?c0RvM3N0NWtmeEU0QUp2d2RZTlcrUUJNb2tYcFEvZkxzcjNnUXVNWDNCTHRW?=
 =?utf-8?B?dUtONHRPVURGK1NTcXI3UkdpbnVRbHR5ME0xdU9FR2pUOVlZMlUrSDNtTW9X?=
 =?utf-8?B?RG4zUW9aVlFxTmlvUWpHcFovWEtxblRPUVJmSFdTM1NSMUtiYzJRdzlhMjhX?=
 =?utf-8?B?YWE4VzZaVjRIT1pWVzhqZW1LYzhkRjlDdVQ0QjRjcGZ3Z2pOdnF4cENwY2FI?=
 =?utf-8?B?blFqaHYycllhWi9ub01sNjlJcmMzc0dwc1ZsdHA0TWRtM3hzVEgwQWJUb29p?=
 =?utf-8?B?S0JXQnpiSW5PVzNNQmZWNVV3Sjg3UVlTTUc1ajhuUVNjWFJhNnVwdG1BU1Bk?=
 =?utf-8?B?T1k2ZHJTbHQ1cGp1Z0hsNFk3cXMvTUVDd1hWU0pOdHhsRVhyNncwd09QK1k4?=
 =?utf-8?B?eERXNjlOUmplN0tOa3JVd2ttTFp6c2x0YUUrNzl0WFpqdzZqL1FGeFJGQll5?=
 =?utf-8?B?dE5XbkpSamFlYnVWV0JkUEVqeTM5cVdVRC9sWnNDL29rQjFSWDRPaWRXcnky?=
 =?utf-8?B?YS9neFREOHZnMXFrZmFkeFVmTVhsUWJsVHpVMUtQRFlNRzlUdDlQYlFrdmN6?=
 =?utf-8?B?WG5BcFpYT3lLUGdETWpyRTJ2SHdNYzdRZnpwWXdxdGdIRDBjY3VOekE5TUpy?=
 =?utf-8?B?d0FNc0ZiQ1U1blhnUGtRTk5CRE5pZk53SDVlZ3ZBVkllR1RMeE4xNXM1aTcz?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C637F06FCE158428A30CF6C4DBFA13E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de863dd9-0cae-433f-ffd5-08ddc4fccc9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2025 06:40:20.0010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GWB3Zlrp/M0VvnHHOtjILSz3ke0PNUHel4/psG4bOlqAVfTEVKvdsdN5901rWdYRL6AaOJV1rmu0P60aKNGMAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8460

T24gV2VkLCAyMDI1LTA3LTE2IGF0IDA4OjIyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gDQo+IE9uIDcvMTUvMjUgMTE6MjUgUE0sIHBldGVyLndhbmdAbWVk
aWF0ZWsuY29twqB3cm90ZToNCj4gPiBPbiBNVDY5ODkgYW5kIGxhdGVyIHBsYXRmb3JtcywgY29u
dHJvbCBvZiBERFJfRU4gaGFzIGJlZW4gc3dpdGNoZWQNCj4gPiBmcm9tDQo+ID4gU1BNIHRvIEVN
SS4gVG8gcHJldmVudCBhYm5vcm1hbCBhY2Nlc3MgdG8gRFJBTSwgaXQgaXMgbmVjZXNzYXJ5IHRv
DQo+ID4gd2FpdA0KPiA+IGZvciAnZGRyZW5fYWNrJyBvciBhc3NlcnQgJ2RkcmVuX3VyZ2VudCcg
YWZ0ZXIgc2VuZGluZyAnZGRyZW5fcmVxJy4NCj4gPiANCj4gPiBUaGlzIHBhdGNoIGludHJvZHVj
ZXMgdGhlIEREUl9FTiBjb25maWd1cmF0aW9uIGluIHRoZSBVRlMNCj4gPiBpbml0aWFsaXphdGlv
bg0KPiA+IGZsb3csIHV0aWxpemluZyB0aGUgYXNzZXJ0aW9uIG9mICdkZHJlbl91cmdlbnQnIHRv
IG1haW50YWluDQo+ID4gcGVyZm9ybWFuY2UuDQo+IA0KPiBXaGF0IGlzIFNQTT8gV2hhdCBpcyBF
TUk/IFdoYXQgaXMgRERSX0VOPyBQbGVhc2UgZXhwYW5kIHRoZXNlDQo+IGFjcm9ueW1zLg0KPiAN
Cg0KSGkgQmFydCwNCg0KU29ycnksIHRoaXMgaXMgY29uZmlkZW50aWFsIHRvIE1lZGlhVGVr4oCZ
cyBkZXNpZ24sIGFzIHVmcy1tZWRpYXRlay5jDQppcyBjb2RlIHNwZWNpZmljIHRvIHRoZSBNZWRp
YVRlayBVRlMgaG9zdC4gSXQgZG9lcyBub3QgaW52b2x2ZSBjb21tb24NCm9yIG90aGVyIGhvc3Qg
dXNhZ2VzLCBzbyBwbGVhc2UgYWxsb3cgdXMgbm90IHRvIGV4cGxhaW4gdGhlIGRlc2lnbg0KZGV0
YWlscyBvciBhYmJyZXZpYXRpb25zLg0KDQoNCj4gPiArLyogVUZTIE1USyBpcCB2ZXJzaW9uIHZh
bHVlICovDQo+ID4gK2VudW0gew0KPiA+ICvCoMKgwqDCoCAvKiBVRlMgMy4xICovDQo+ID4gK8Kg
wqDCoMKgIElQX1ZFUl9NVDY4NzjCoMKgwqAgPSAweDEwNDIwMjAwLA0KPiA+ICsNCj4gPiArwqDC
oMKgwqAgLyogVUZTIDQuMCAqLw0KPiA+ICvCoMKgwqDCoCBJUF9WRVJfTVQ2ODk3wqDCoMKgID0g
MHgxMDQ0MDAwMCwNCj4gPiArwqDCoMKgwqAgSVBfVkVSX01UNjk4OcKgwqDCoCA9IDB4MTA0NTAw
MDAsDQo+ID4gKw0KPiA+ICvCoMKgwqDCoCBJUF9WRVJfTk9ORcKgwqDCoMKgwqAgPSAweEZGRkZG
RkZGDQo+ID4gK307DQo+IA0KPiBIb3cgY2FuIE1lZGlhVGVrIElQIHZlcnNpb25zIGJlIHJlbGF0
ZWQgdG8gdGhlIFVGUyBzdGFuZGFyZD8gU2hvdWxkDQo+ICJVRlMiIHBlcmhhcHMgYmUgY2hhbmdl
ZCBpbnRvICJVRlNIQ0kiIGluIHRoZSBhYm92ZSBjb21tZW50cz8NCj4gDQo+IFRoYW5rcywNCj4g
DQo+IEJhcnQuDQoNCg0KU3VyZSwgSSB3aWxsIHVwZGF0ZSB0aGUgY29tbWVudCBmcm9tICJVRlMi
IHRvICJVRlNIQ0kiLg0KDQpUaGFua3MuDQpQZXRlcg0KDQoNCg0K
