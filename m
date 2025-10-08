Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A1E128819
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 07:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759908789; cv=fail; b=S3uAn5XMYl3o6HfFZlnCaPzrhGX/fq8t+on93QFIVxCauUyuWhjze191YCKGQidezkjH8tmX9jIwFYSXekR+Vq/8WUH472qxmmbfKGVngifjjj2eLs0Q9mudInC5Lb57u24xcI/8Na/Dl7+BFxuy/N4SRtzvFX/LuhZRqnReK8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759908789; c=relaxed/simple;
	bh=v4HmEUK9gxB9SEQVOH0PzLBHX4jxhRtFB2mXzQMJNLo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dtvBKKVUnZDWkW9mgHU1abOQTZICKeOsOQJFyalVh8ba8OQmCJrUCPNVR+ISI/MGoBYkiGy4z1Ncpq9Fg88c7Tl86cTiZXtez5PN0eDMZL4AbSjrMXxFHueLgdbqM8MnPQO0kbDV3mOwDOkDHq/F6YCHZnHL0vEk2PZcqqdS6gw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=a3grz0SB; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=UutJE8Cy; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="a3grz0SB";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="UutJE8Cy"
X-UUID: 006cafc0a41911f0b33aeb1e7f16c2b6-20251008
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=v4HmEUK9gxB9SEQVOH0PzLBHX4jxhRtFB2mXzQMJNLo=;
	b=a3grz0SBDj1qluqmhJ1iiVezekCH+hnuC1B5tL9ebi8TZ4/IiqQ7Ru1ycncuew5zl5PvcZwPz/R/D2Nmr9hhDGDNEN0JkdqaiKxkio/mwGWtdLjBbSWicODBMOafjhhLryBoySTqdDbq0iJh/9gnatHVQ7y3F9/Nmog8bvLcnx0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:b159ec01-23ec-45fa-b353-626cc579965a,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:a9d874c,CLOUDID:defad650-c509-4cf3-8dc0-fcdaad49a6d3,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 006cafc0a41911f0b33aeb1e7f16c2b6-20251008
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1105531175; Wed, 08 Oct 2025 15:32:53 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 8 Oct 2025 15:32:51 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 8 Oct 2025 15:32:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jSwSgEfMyzSRTnkgQjQ9+t5fM6zMZEmVcTvtKdI4OGnn6Th5Yp4Vhd9ZQ4dhDTX+KadEiQqNyuxclrJh1UvfRAWbNQsopdr+UkRKITLfOcFb5JE9YWrCVZ55sJR1AI9gstIxQynvNFvOYovqgUFPdVO3GSSkTiPfP02cxAonyv6FbrJ+u/wMsty+SgVPU+GC0tyZ/TwDgAZyo9ylSWaBQRLOA7uWZZ+Ef665mO6BCEFU03itOPqTLr79+pUUZdTrpWHpUCWDlNmBz6SDDRBT6nE7B3n4eMBH76SEjgX3/3WaqV/ssMpfMvVFFh/akZegIRsKvnERGhB2x30HN4Erdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4HmEUK9gxB9SEQVOH0PzLBHX4jxhRtFB2mXzQMJNLo=;
 b=MHTigmAYveA53lLJtgD82Xf5Mi7Tuj3G18pcoVEqZh15zTBn1T/3NCwSY5r/e3dZEdUgLeT8KwFEeQyCwTS1vpXAAW0PYRkjkr9WGwWhnhuRZ87GhzmCQ6/3DWzP0572DfrXENBd6K3fPkhazvjWhNdFvj4HBkSFxEwn60nV1KoUgQyZYfqJTCEGy6DU3HgAcjwy2FVQ7F4Pp+cVbf1+rr7NG51dKEPO8I93w09jjmI7wqVufsiQHyglJXURX1nsOQ3kpjWNipm8ewJYrAF21UE+ZUwAKYO2KSxtw6HrTrUjZ/9PnkdrbjH8CwiGJO7fu3zDR5+0ziJZY4QGfrkGEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4HmEUK9gxB9SEQVOH0PzLBHX4jxhRtFB2mXzQMJNLo=;
 b=UutJE8CyZwdgZw/V1y6My6thiTi8Y8YJUd/PguQJSSsE4ZkuHSB0Y5niSh965xMT4PjwJhwQqi67OWwW19ah7TV34Q835e55649Wd/R92suCAKzHs9DaNhLdM1ugREXJgOtfquwBDqRML6VdrA9oLGHxT4DQGwo/gch/CCTL49U=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY1PPFE10C2B785.apcprd03.prod.outlook.com (2603:1096:408::a71) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 8 Oct
 2025 07:31:45 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9203.007; Wed, 8 Oct 2025
 07:31:45 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "bvanassche@acm.org" <bvanassche@acm.org>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
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
Subject: Re: [PATCH v2 0/8] Enhance UFS Mediatek Driver
Thread-Topic: [PATCH v2 0/8] Enhance UFS Mediatek Driver
Thread-Index: AQHcLTf4devQMDuHgUiYa5mBvHVKarS38MEA
Date: Wed, 8 Oct 2025 07:31:44 +0000
Message-ID: <e818d9ef6f5625de02330a6a92a2ab2b77229c87.camel@mediatek.com>
References: <20250924094527.2992256-1-peter.wang@mediatek.com>
In-Reply-To: <20250924094527.2992256-1-peter.wang@mediatek.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY1PPFE10C2B785:EE_
x-ms-office365-filtering-correlation-id: 240210d3-628d-4b34-6cf6-08de063cbba4
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dFlDeHIzcGlhOEZSbmhHREpXcmF4OFFoSDkwY25ITWtFZExkUzUyK01BS3NJ?=
 =?utf-8?B?STZoNnM1YUdhUHdsQ1k4bkY5VkVRNHpwNXF2UERDYkZxZGJXaDE1REIrcGxY?=
 =?utf-8?B?M1I0b3NnSEF1M0RpUksrOXYremJPVmdLOEFrckxJN0pFdzg0MkJSQUpwRUtQ?=
 =?utf-8?B?elcrSEExZGNOWnVBUlBqaGtLMXhxUmllNk5Va3pWQWdWQjliZzdSMVZiSFZq?=
 =?utf-8?B?MUpoekVWZm0rVDVNMjZVU1M3Vlk0d001enpyeDlwaTBKQVBDZm1XeHkzTktz?=
 =?utf-8?B?UGtNQ2cxY3B4N1lVdTErZGlhc3dFbWcxM2ZlV3pkNzYrMjN5RmdaV2FIZVVP?=
 =?utf-8?B?a0oyeUliQUdlbU81OTBsNEVMdSt5T1NNdE45VnRiUXd4cWFFenBKWFdMbmtI?=
 =?utf-8?B?MStsd21KQ0NQWERyY1hHS0YzUGdKckpjcVd1LytnK05YV1NHMXVaVVJNLzhR?=
 =?utf-8?B?QW1ZM28vM0hEMHBGVW9zNWJZNGE0RTUzRCtuK08rd3RmcjJQMk9keC9oRzZp?=
 =?utf-8?B?dFlwSGdjOHpmTGFaYlZXMnUzTVFyYVNuQ001bjdYanlxMEZlOVZnM0lyTUsz?=
 =?utf-8?B?YnJON3VZQzRZLzIxaDFUQzZhUHJrcU5UbGZlekI1UE9zenFVaENMTlpiL1pO?=
 =?utf-8?B?dkorNkduRm04QmkrSWNvSFB4T2ZLQXlZRmhJSDlZeUlnY3NxV1BKN1V2blN2?=
 =?utf-8?B?dFNVUFA5TExmcktSWU52QUpnYm1VNklWWXc0OFFLQ2xxRFAzT3h6TzF0VUxY?=
 =?utf-8?B?QVpQd2daaDArNUJDZ1FoSkFGOUhOZjZIVWczUzNSVllRSkZJYld1ZnlscVpr?=
 =?utf-8?B?T005a21jSUlYazRQd3lZTW51QXdFcDlrejVOSmk5ODQ3Vk5NYkFRVnVFcWZy?=
 =?utf-8?B?Y2txN0oyVzFUZ2JWK1dhelhQeGNGWWVYTkE4elJFaHVTZzFBaDNiMXp5ejF3?=
 =?utf-8?B?Q3dkazhlQ2dPQThWSVVjUmxUMDlpOGw0M2VWMmxodjlnNE1SL2RHblV2OUg3?=
 =?utf-8?B?eHFBM1N0YTZPRzYySlI3MTZCa3lKYzBPTnRvakNBZUQ2WnNGYW0rcUVsbDQ3?=
 =?utf-8?B?dmZhUjFQbDRzb1N4R3FKMzZzbUpwdzZjclpwQ0FnTnVaa0xOZWFFSldXYXpt?=
 =?utf-8?B?Nkg1UXZUMmJ3UnZGT0h6N3hqNi90SGhOM0JjVXpNNzBpQjcvSm1DYlJWNUtp?=
 =?utf-8?B?ZU5lOFVIYWQrS3RyRURoTmoySU5OME9NRG5mbEtaTUxXRnZ4Zml1N3cwVnpG?=
 =?utf-8?B?Rlk1QW1ybG1jdmU0NlJ1WWQwTmxiMEJKdmtDT1NYV214YVRZTWtYRXhjZ1Ex?=
 =?utf-8?B?MnljVUN2YXJYSW5OQkNhZG5jNWYxaDB0TklWNnlKUWUxZEdFazA1RkF2WFVP?=
 =?utf-8?B?ZXBFZEZqNzZmVlNNbEdCOHZiV002VDlkdVQ5dEhLZ1VSbVBRb3ZMUkN5VnB3?=
 =?utf-8?B?VC9BbUpDQmhNTVJyb3BDb1hzbGY1aGRKUEdSQ2pVN3pUU05hWGRPTThhWTdl?=
 =?utf-8?B?TXZBajlCQkNaT0E0dk9MaWVrQ096VCtvRGFpd1NJZXFSUnlxeFl2dDNhK2V4?=
 =?utf-8?B?NDN2TzRiMk04MFdZL0pnazdOV0ltMWRHa3hTOVptNksxMC9tSkZ1Y0tTWXhQ?=
 =?utf-8?B?K0xJb2JKWjBkSE10Z2tDb0RzaFlnM1hmMTBpbzVZUkVsQlBRRkFPTjRJUFdv?=
 =?utf-8?B?dk1JQ1pjOUxvYlJrV3RXZjRESWpQdHdKMjZoYXlkdmZiZjVQVHN5cUsrMDY1?=
 =?utf-8?B?Zm1seTg1S1FWS2cwd3FLTlJlR0ViRXROYUgrRDVHcnhvdHp4S1p5ZkI1N1lE?=
 =?utf-8?B?MDhRVG5Tb2pvQk1ZMktDd1hvQnUrZEhUUHlMTW43bVhPRG91QWVvVGp3RUpB?=
 =?utf-8?B?N25DVzVsVXJ0SC9EaGV4U2RkdVFNTytUWkhZbC96OUhveWVXeVBSWEJDYlR4?=
 =?utf-8?B?cGQzbGxlanJib1JHRVlBOVFMZjB3REkvUzQ3NmtSMW9xYVllN3YwbUxUWVBr?=
 =?utf-8?B?SWdFVzZYdDJsdDNJSDNHbnlhTWR5SERTYjgrUGZRbGlRb2NXN1ZDSFNQTTUx?=
 =?utf-8?Q?2RN/1k?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WURsZXV2RWNIMEViV2JnZ2tUb1doSmNTSmVSTGhadjk1NCtRRlF3MmkyUjN5?=
 =?utf-8?B?UVZjOEFCbFIxK0ZqblBzOC9MYnhxSk5pSmR5Um45T0VjVUFTOXpPUWNDSSt0?=
 =?utf-8?B?VHkyd1ovZ2w5RTZRYTBQYzJBMFo1UXVVaWhXVUZra0pRTE4xUXdnOUQreG1R?=
 =?utf-8?B?WUNNN3lWY25FNTIxRlhiTUxQN2dHd0VZck1YYU5DWElBK2ltWmEvQ3JQdUVp?=
 =?utf-8?B?dDhPS25nMXB1Vm1OSzhIcXVMNVBqNU85bkF3T3g0Q1NGcWRDelY2UkxmSm5O?=
 =?utf-8?B?R2pFaWhYWUY0akx6T2xMZFF0OW8rZ2g3NkxmSzVtUW9qclFNVXIzekQ2MWZF?=
 =?utf-8?B?Ri83OEUzODIybWVHck1Ba2p1dnFTVmdkNlpjaXdvdGgvbDgwdk45bDgyS01z?=
 =?utf-8?B?NFp0ZTBja3h1cmgwVjBLYkV3WW8rYWluc0JlMmliK1VmZ0FyOGFoRDdidW5Z?=
 =?utf-8?B?ZTJhdUpGbzZ1Y1R2L2NMYWVkMFJrSm1uWG0rOCtCWUlVSUx1b082SlFINVg1?=
 =?utf-8?B?WktWTkxaOERYQXI5bmlTY0d4dUtXVjNydHFqYTVGRkhIL1p6OTBBWEtjTlNG?=
 =?utf-8?B?YnBYSDFldFllYWpPSVJPK2JQMVRvWUtkUWRhODFZODRyUkppSGk1TEoyTkRt?=
 =?utf-8?B?VWNsd2hKY1NxZHJ1em5GbW9EYUtoTjdoOFdsM3FicmxPc2JXTEd3MzdqUGht?=
 =?utf-8?B?dThLVTJ4QnU2RE54ZVZXOFhxMU9DcUJ4Y3hsczdBYWVZZE9Ld1NkOFhzRDN1?=
 =?utf-8?B?RTJDMlRQaStpSmI3WTZiUVlPTTBMMFlodWZzTTgxVGg3VjEyN0FlZ0tqTmtu?=
 =?utf-8?B?UDZtMDA3UHM5Y3FzTGp3SFV6ZENkNHA1QWY2RGtSUVdzU0NKS3BRWDFGejRJ?=
 =?utf-8?B?SDNpL2U1TGhHam54K1U1bDliUGNJZVNnTHEwcHRRakNlRjFlZDgvRzZ6VzRq?=
 =?utf-8?B?SnZ1ZDd5WFVPMnJPWlZabk9vTTdXZ2dOaG9ROCtFNTFDajRJVE1LeFBieUlD?=
 =?utf-8?B?aHEyZXFyM0UvSzVOWUdvWWhnbk00OWNKdFVuclJMcnM4OVllc21QMld6VGQ3?=
 =?utf-8?B?Q2t4VlpLblQ1SW9ReGRCbjR3bXBXVTZxVFErM1ZpeHlYL2RrRGlob3pjVzFt?=
 =?utf-8?B?Z2xhSm5GWU11RXBnVWRhaGFlWmdUajRrNU5ZRzNUT2drenVqcS9QRGdSVzda?=
 =?utf-8?B?RHhWNW9zZ1M0OGU3NlpyMDNFUUI4N3hlRnlUWlFoRjR1a1NtRFNRRnVjTGhP?=
 =?utf-8?B?T0ljREplUDI0Z0VXSU84SGNDeUF0TDlPbGlnV3krRW5rY0pCd20zcVFzb2xG?=
 =?utf-8?B?c2ZFNDFucDFob3Foa3laUTFQQzBSNW1PbCtQWlZSRTQ3WHgyRVJYUW9tZGNX?=
 =?utf-8?B?dWhkTFM2WThOZVVTdUxBb2hUbEd4b1BxMGwrcFBjSHRoT01ReG5BODhncHNp?=
 =?utf-8?B?RThXKzNkdTQ3WVZEZVYvdEFzYUV6cnA0WHpWckQxWFJkWkQ4MkdMYUExUFAv?=
 =?utf-8?B?U0gvOGI2dHJEMTM0elRQU3VlSVJWdVk1QlRmSmZKM1RodmpUM0RsMVdlb0JK?=
 =?utf-8?B?clFraTBwa2ZzT3lIWVZaYWlldkdydko0a3hDTjlkM1pLS1hmMS9LbWpyNzMw?=
 =?utf-8?B?S3VTTm9vYUpuanpGSFJPMENBVTdvWmltRnpuY25HWFdkb1JGT3RPekxjTFhU?=
 =?utf-8?B?dGlkTjZRa0EzdzVRNUczTm1NVCtGQWVLZmJmN2kyRkUxd1ZhNUNxbW1nZFly?=
 =?utf-8?B?K1VtLzRrZ0YweEphUm92RWo0TGJoKzJUMHVYZDdiY2hZUEIzbFVEc2R5bGp6?=
 =?utf-8?B?YmNwQzM3bHhkemRuaHY2L2hBeHBuRnRyRm5VMlJraS9pNUdOWXdoUS9tS2Ni?=
 =?utf-8?B?RnNPVVIwZDNjMHNzVU5ubU9sNHpLOVBQMURsK0trb2ZIVFhrTnA3KzJJRHhu?=
 =?utf-8?B?bEZENkwrMElZUlFWT1d0VmJKdXZadE05TXNlcHhYRGI2K0U1WlpjSHRRRG80?=
 =?utf-8?B?RGdabHhYTzFXeXo4V2pDZXQ0RS9KbnZyOStWOW1ITnF0NElxa3hjOGJ3V0lW?=
 =?utf-8?B?Y3pONmR0azc3NFN4SDY3dTY5RnlCYU55UG16amZ1TDBuWFZuTEtFejhnZlRu?=
 =?utf-8?B?SGxML2dqZEgyczJmcmxjb05zNENmb2hRbkZGbG0zeSsyZ0lTN3RmKzNLQ0lO?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1119C1D7756018499BB09E3840B0914D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 240210d3-628d-4b34-6cf6-08de063cbba4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2025 07:31:44.9019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eok/BeLvLlTS0kcOcdQ+EB7O1ophYBBUae61KZbh7sVAtDfPv1oZVmtPWjxZw7XiZvCpraaewF6CpM2DjVA1FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PPFE10C2B785

T24gV2VkLCAyMDI1LTA5LTI0IGF0IDE3OjQzICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBJbXByb3ZlcyB0aGUgVUZTIE1lZGlhdGVrIGRyaXZlciBieSBjb3JyZWN0aW5nIGNsb2Nr
IHNjYWxpbmcgDQo+IHdpdGggUE0gUW9TLCBhbmQgYWRqdXN0aW5nIHBvd2VyIG1hbmFnZW1lbnQg
Zmxvd3MuIEl0IGFkZHJlc3Nlcw0KPiBzaHV0ZG93bi9zdXNwZW5kIHJhY2UgY29uZGl0aW9ucywg
YW5kIHJlbW92ZXMgcmVkdW5kYW50DQo+IGZ1bmN0aW9ucy4gU3VwcG9ydCBmb3IgbmV3IHBsYXRm
b3JtcyBpcyBhZGRlZCB3aXRoIHRoZSANCj4gTU1JT19PVFNEX0NUUkwgcmVnaXN0ZXIsIGFuZCBN
VDY5OTEgcGVyZm9ybWFuY2UgaXMgb3B0aW1pemVkDQo+IHdpdGggTVJUVCBhbmQgcmFuZG9tIGlt
cHJvdmVtZW50cy4gVGhlc2UgY2hhbmdlcyBjb2xsZWN0aXZlbHkgDQo+IGVuaGFuY2UgZHJpdmVy
IHBlcmZvcm1hbmNlLCBzdGFiaWxpdHksIGFuZCBjb21wYXRpYmlsaXR5Lg0KPiANCj4gQ2hhbmdl
cyBzaW5jZSB2MToNCj4gMS4gUmVtb3ZlIHR3byBwYXRjaGVzIHRoYXQgd2lsbCBiZSBmaXhlZCBp
biBVRlMgY29yZS4NCj4gwqAgdWZzOiBob3N0OiBtZWRpYXRlazogRml4IHJ1bnRpbWUgc3VzcGVu
ZCBlcnJvciBkZWFkbG9jaw0KPiDCoCB1ZnM6IGhvc3Q6IG1lZGlhdGVrOiBFbmFibGUgaW50ZXJy
dXB0cyBmb3IgTUNRIG1vZGUNCj4gMi4gVXNlIGhiYS0+c2h1dHRpbmdfZG93biBpbnN0ZWFkIG9m
IHVmc2hjZF9pc191c2VyX2FjY2Vzc19hbGxvd2VkDQo+IA0KPiBQZXRlciBXYW5nICg3KToNCj4g
wqAgdWZzOiBob3N0OiBtZWRpYXRlazogQ29ycmVjdCBjbG9jayBzY2FsaW5nIHdpdGggUE0gUW9T
IGZsb3cNCj4gwqAgdWZzOiBob3N0OiBtZWRpYXRlazogQWRqdXN0IGNsb2NrIHNjYWxpbmcgZm9y
IFBNIGZsb3cNCj4gwqAgdWZzOiBob3N0OiBtZWRpYXRlazogSGFuZGxlIGNsb2NrIHNjYWxpbmcg
Zm9yIGhpZ2ggZ2VhciBpbiBQTSBmbG93DQo+IMKgIHVmczogaG9zdDogbWVkaWF0ZWs6IEFkanVz
dCBzeW5jIGxlbmd0aCBmb3IgRkFTVEFVVE8gbW9kZQ0KPiDCoCB1ZnM6IGhvc3Q6IG1lZGlhdGVr
OiBGaXggc2h1dGRvd24vc3VzcGVuZCByYWNlIGNvbmRpdGlvbg0KPiDCoCB1ZnM6IGhvc3Q6IG1l
ZGlhdGVrOiBSZW1vdmUgZHVwbGljYXRlIGZ1bmN0aW9uDQo+IMKgIHVmczogaG9zdDogbWVkaWF0
ZWs6IEFkZCBzdXBwb3J0IGZvciBuZXcgcGxhdGZvcm0gd2l0aA0KPiBNTUlPX09UU0RfQ1RSDQo+
IA0KPiBOYW9taSBDaHUgKDEpOg0KPiDCoCB1ZnM6IGhvc3Q6IG1lZGlhdGVrOiBTdXBwb3J0IG5l
dyBmZWF0dXJlIGZvciBNVDY5OTENCj4gDQo+IMKgZHJpdmVycy91ZnMvY29yZS91ZnMtc3lzZnMu
Y8KgwqDCoCB8wqDCoCAzICstDQo+IMKgZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuY8KgwqDCoMKg
wqDCoCB8wqDCoCAzICstDQo+IMKgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyB8IDEx
OSArKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0NCj4gLS0NCj4gwqBkcml2ZXJzL3Vmcy9o
b3N0L3Vmcy1tZWRpYXRlay5oIHzCoMKgIDQgKysNCj4gwqBpbmNsdWRlL3Vmcy91ZnNoY2QuaMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgwqAgMiArDQo+IMKgaW5jbHVkZS91ZnMvdW5pcHJvLmjC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgIDcgKy0NCj4gwqA2IGZpbGVzIGNoYW5nZWQsIDEx
NSBpbnNlcnRpb25zKCspLCAyMyBkZWxldGlvbnMoLSkNCj4gDQoNCg0KSGkgTWFydGluLA0KDQpK
dXN0IGEgZ2VudGxlIHBpbmcgdG8gY29uc2lkZXIgbWVyZ2luZyB0aGlzIHBhdGNoIHNlcmllcy4N
Cg0KVGhhbmtzLg0KUGV0ZXINCg0KDQo=
