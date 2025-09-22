Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6A79463
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 08:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758530241; cv=fail; b=Gha7LgKy+8a0vnOyzA/UrbJsNEtREdBKbjfpNJ3i9IZ6BRWU7ehrysFf32DlW1hcaoMHfD0Mcqwoes1QY28xvyjG2t1gNo69rMSVIhUkqI4QrekXxobx2sbPpmS/dJj0gQHc8a5Px8N2KdVKIx07KaG2Qg29k8dxbzgmIpOoDAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758530241; c=relaxed/simple;
	bh=uIYBoVzddqJxslilJALCL092SU5g9AVXBxYjvn9Cdmo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rEw2cY0RKfE49grtSJGoNifAcawiloWkcXAkwzRa9/POI4bBE6ukOXlenXcwBHN7wuyEjVq0wBUvoFHDRwDsKQwiZOvgQOCfqHiJy+wLxu2yp1pgalUNUCRPco0AB7457+Ogb7Rah3cwpLyYomQK/L2MHSfbUQJlTapyrRDMvWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XUDhRb5O; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=j9/xVoHP; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XUDhRb5O";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="j9/xVoHP"
X-UUID: 56d0dbd4978f11f0b33aeb1e7f16c2b6-20250922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=uIYBoVzddqJxslilJALCL092SU5g9AVXBxYjvn9Cdmo=;
	b=XUDhRb5OSdeQek8bx6QCFz42qUT0mNqN8pc6U968tZliMwXtfDQB/Y7MBjQmbGqbVWTh2n+o6W9EqF76o9CwtVWNAZUz5s63BT79YkXIXrWSl5NtA/+tdGZfSuRAkurPHUmJeut+9iDHIeOX8pYQqLlMlM6PJdSrR9KHem1VWXI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:453ca002-fdec-4cb3-bdca-a7486afcef70,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:fd8cb721-c299-443d-bb51-d77d2f000e20,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 56d0dbd4978f11f0b33aeb1e7f16c2b6-20250922
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1806022393; Mon, 22 Sep 2025 16:37:14 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 22 Sep 2025 16:37:11 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Mon, 22 Sep 2025 16:37:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZVyi59qdRvYntOoU8tRi6F3tMIs4Ujo8+aMb7Cc8gUDQEe8Z/S6qydjC5JIvMA/mJrc2KTr53hNLfEiDNjzDJgtWYd39PYHE+F2BJHkRboG3tPa9xiEsRHUeOa89CYOkS3CbS73AKq0XbwndH1IQsvvu42dgL7iQcW5a4BPnbN36XUk+6yqg//psAhn1px3GGPYkbzolNmZf1UYl2XxzsdKhFjGxJpHzfg7pt1FMKNIGjqjOqS93LGzaRXL8zfOWvrJIvRyrUtO4MZYxzFdQIK7dc3M0itg3kM0rGtkdjtkdIO1Xf7/FI1Uj0AkR4x1mjvP1fkt6KyR2f24cFuYhWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uIYBoVzddqJxslilJALCL092SU5g9AVXBxYjvn9Cdmo=;
 b=S1z1Vi+/BFykWa9WqlRByTVl0GTm5rurI5S3088iJOBuTpCs6t/QO/cm5FKiam15UewOTdp1AM4yFPdrL+5g75hOetkVXDrimWaMRSOyQPSe+xh2gjv7ZXJ/tDNT0ZxkPGiHdmQy1GNskwignAa4389AHh6ahwHatQuTWCc9QqZUy0ZqooiEGNK+NBhCib5yB1vbyyTaldrihYavXlBT2c0y+djMFnEKZcwCbGDgPLqF4ee1u1jc08oQXzhy10NeKc6BWTs/4NX8q4d3/jXxskoPQlzIY02c2RN0ohIwUj+bOufnCTYRcDU65IUVXb9/jn/xI33jY5mC+fPulaEr9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uIYBoVzddqJxslilJALCL092SU5g9AVXBxYjvn9Cdmo=;
 b=j9/xVoHPfNzEH36HqCKC8ukldq8+ydrfzqCiHGqCqWjFHIHdOAdY2EX2/OcQ6PFQDXw/16xXtQHfwavbiJ/EHHxJcHjZa0/uSHk0ElE9UgMXlpIkXZLwFRowIdFZqeOC2JRFKSJWKJmmbaK4tIO9vw1YgHKlSFE/nJZmeR5HXio=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KUZPR03MB9496.apcprd03.prod.outlook.com (2603:1096:d10:2f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 08:37:10 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.015; Mon, 22 Sep 2025
 08:37:10 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
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
Subject: Re: [PATCH v1 01/10] ufs: host: mediatek: Fix runtime suspend error
 deadlock
Thread-Topic: [PATCH v1 01/10] ufs: host: mediatek: Fix runtime suspend error
 deadlock
Thread-Index: AQHcKIiuaKZL4LPKzU67kdo2+Ird9LSZQs6AgADmAwCAANYVAIAD6DOA
Date: Mon, 22 Sep 2025 08:37:10 +0000
Message-ID: <4f8d4f0c9efd24aa4448e6dda064b0633d253f2d.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-2-peter.wang@mediatek.com>
	 <80a31144-852f-4df5-802e-a8c5d04a298a@acm.org>
	 <bdb6ee1402ae4c9ba8919011b1d8fcb9d984129f.camel@mediatek.com>
	 <bc612c10-a4eb-41ab-b8e5-726d22935518@acm.org>
In-Reply-To: <bc612c10-a4eb-41ab-b8e5-726d22935518@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KUZPR03MB9496:EE_
x-ms-office365-filtering-correlation-id: 1ac63825-ec9c-42c0-091b-08ddf9b33907
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RTg4RVdHYkRMYXRCNm1pTEQyM2tMM2NONzh6ZGdoOGpKWmFLOTBsSjJsZ3JH?=
 =?utf-8?B?azZZT0VQYTRSRWFmRVFMMHVOeWNFR3RnQ05EQ1A3aWIwcTN1bU82QkVHT0pW?=
 =?utf-8?B?ZzZRTExaUUUzUVpmMVdvT1J5UVdKVE1BTUtESmVreHRBN0pNRU83bnB0RFNN?=
 =?utf-8?B?MUJmWEs4K3FXc0huSGZ4bnhycjVGQXpURSsvRVk0M0N4Q3VaSDJrOXB3dFVJ?=
 =?utf-8?B?b3lUZmhURWNRL2hNTmJQUjJ0NVlublQ1TXpMQjhOeGhRMjhFT3M3MWpQYlZh?=
 =?utf-8?B?eVJtbktNNWp3cVhyRVYxbFdYZ2VxK3RmTjdSMHZ1bk9PT0t0RDd3cjB5UU9T?=
 =?utf-8?B?d0J3L1l3NFNqZGRQQ25LVm9xK0tPN0J4aThSR1J2TGs4YlZVeHBHNWVySi91?=
 =?utf-8?B?d29JWkx0aTRVTGV0cWxiU2Z1d2RrMGgzOVo1QkxIWm10Z0F5YVZ2b2p3cWRs?=
 =?utf-8?B?VWwwcmpKY1pSSkg2azFjcXE4SVNXTEVCR0dwelJjZ1hhS3I0UHZjWXZ5RHgr?=
 =?utf-8?B?MnFDVVBaK0VNSjdaSlk1Qkg0WExUUlBGanNtQ3Rnc0JOOFVqZTdVdFZuSFIr?=
 =?utf-8?B?S1NuS1dET0Jid1U5QmtySU13b3k3cHZteHpJVFN3MU0zN2FTWVRhbS9hTGkx?=
 =?utf-8?B?aHdPYXF6UDczUVdwN1JKT3R0M3ZVeXZYVHNFbDkrSmdEODJ5WjhSOXV6U2F1?=
 =?utf-8?B?eGJBRyswK3A3SWZ0Y0VXc3Q3Z3k4OVZRZWg1SmZUbm1xSzkvZll6Zy9mUThF?=
 =?utf-8?B?eGxKN09jQkNqQ2Q4TURMbysrOWFFRjQ2ckZjQkIrM1lPZlhpZUVFRHpKMmRn?=
 =?utf-8?B?MjdaWFBTNDNaazk4K2svc2YrQk1zUUhEd2d0UmRtU25XRUNvak44aDdjNnJm?=
 =?utf-8?B?RWpTV09tRmlmY2xpN05KdCtuOWZ5Sm80Nkl3alRpeFk5VUJDTitpK29pS0Rw?=
 =?utf-8?B?K2pCN29zUWdndmZ1aVFmdTVaYlhhWlNpeHlCMjVSSWFIc05idUpCOHVwSC94?=
 =?utf-8?B?YW9pWmRJZE9XcitIVmc5bXA5YzE2QXFUSU5BSXJDQWxmOHc3K1lrTTJDWVZx?=
 =?utf-8?B?ejh3dDBrMXpIaEJLQXFuaTRpdExqVFd0Z0F2NXNLZllaYUd2V0pxODlXdEVB?=
 =?utf-8?B?QTE3aXFyNmZ3elFjYUw2dVdVTEt6T3ZXbU1PMElpQmE4NVdVR1pzUkZzSkRs?=
 =?utf-8?B?aTJaMkQ0TW1IdzRGa0QxNWZOUFpRenpKOTYxdGZSZU9wUkloSW5ETC95Tmdq?=
 =?utf-8?B?MEE4b1U5VUJOV2kvWE5oanN3RU1WSHJsSHB1dHZnVEpTREdRNTdRRzBrdVNW?=
 =?utf-8?B?R2lhU3Y5S09QNWNBUk13VjFXb3hCUHhGTlpqamFId2FSZGc0WUptczM2czEw?=
 =?utf-8?B?SmRUbmsrcXNxVitYNXE5RGROck56TDBCTWt6dWdhQ2wvS2pSS3BtcXNkQWF4?=
 =?utf-8?B?VVRVTjJvWXFZYzZ3KzhicEpXNXFzOXljdFZvb080ZjluUC9sMUd6cndmWnJm?=
 =?utf-8?B?SXZSbmRicHFoSkFQSHMzRjJRWUN0cE1jRWMrcHFML0NTWmJxbzlXanZCTDBz?=
 =?utf-8?B?ZlFUM2xjUmFvRG5nWUFzSlFSK3MrZm1McjY5cXlrT3lqMFQxcS9jTXBqNUox?=
 =?utf-8?B?R2M3SUJ5aklyVytNMWRISmJ1enJVOFc5SlZBaFdKK2xEcE5YSm8rYVRYZHln?=
 =?utf-8?B?QTZOdkt5TzN1QmtzdzE3N2U5cHR0UytYVWFjb0VnbTkyS280N0tnM2RKckNp?=
 =?utf-8?B?Sk1zQ3J5MUR0Z2hxUndDcldzUHRBdzdoOEh6UVdRT0RiZEU5eWh3a3lubm5a?=
 =?utf-8?B?d0RpVitZZ0RHcVdVZ1paVDlNbDlpVFU4N1d4MUgwc3NzcVdDVGs2M2VPL242?=
 =?utf-8?B?TzBUMTgzaFBsSUVQdjZkV0F0cVNJOVVKc2ZxNm9Gb0NqY244bklraDZZWTJP?=
 =?utf-8?B?KzRHakNxamF3NlEvOTdaNkcvS215SlJMcXVjUE4yRHlQTkp2RzFqQU00YWVM?=
 =?utf-8?Q?VkmEx56XpBFNhCFAaB4O2+iqTwL4Yo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3NtNmZGWUY4ZjdKSDIweGFvVGNqNjk2M1VTYk0xSnRjNkttSkFEaGlhUTJW?=
 =?utf-8?B?aFl2QnJvb2hHRXRaYUZFWWNRMVE1R0JiaHQ5QkZ1YXRFZ0J5SzJnZDdsZW5S?=
 =?utf-8?B?SHpFTUZEeG9kd1Z4ZUZVT2hVYWtLZ2VBTjdBaDZxVEowWVhBWENwTmJrTG1a?=
 =?utf-8?B?RDVPMXFRV0FWOWErdlJJejc5V2t0eUlKT3g4bXRaZnl1cnl2TlN2RCtWYTRT?=
 =?utf-8?B?UUVHUUJnOHVnOXRHUkFuQXY0VGYwc1owSjY4YTMyQW4yV2J6Nmh0OU43Zy9N?=
 =?utf-8?B?UDRKUlNnVkdwVzBuTUVxUThGbkM2MTlUNENBRFBtS1d5L1huL3Q4bEJZRG9a?=
 =?utf-8?B?QXVqNHY2MmRXbEZEZHVZRDBhMHVEUi9WdzBvVmxGSko5bkhqWm5GbTlNUzhv?=
 =?utf-8?B?RTRDb2VvcDFZMlpmLzFOUm5RckJEaGl0MmRTRXQwTUZaRTd5TVZUYUU5L1Za?=
 =?utf-8?B?L0lVbjkrUFV1MEFFeWZZTTBJcE5sV1B0NG5TTEJneURocmhGY2c3VGxqbjBR?=
 =?utf-8?B?YkV6RS9SeHZFbWVFNWJkSVdYcDJCUVFYTUxyenRmczJRb1ZMeVZSdlRFNlhq?=
 =?utf-8?B?b3F3SHhxVWMxUHFLN1k2NWd4MkVKLzlMYWxsSS9NOWxKcXFFOG9JR3FpZERN?=
 =?utf-8?B?NkJCMmR2Y2pxU242MUNaZmdFVVVSelN2eEZ1ZUdPbFN0SEkyMG90M2QvY09o?=
 =?utf-8?B?SW1kTHpSNkU0V1dIeEtFdWZqM3cwYXZsVHk0ak1IRHRsQlZIUmZQQzlTcmZu?=
 =?utf-8?B?N0U4UXpUZXhhL3U0Zmo5VXFTdVZhVmNDSGpRNHJteXcrdlRqS1BVSXh5MVJj?=
 =?utf-8?B?ZjFMQUJ6YldLTHVaMnM1b1FOZENQWjdnWTk2eDY1ZlI2NDVPay83Zk9FMHhQ?=
 =?utf-8?B?ZUF5RWZ3enZLN0VtcCtXSUxYd014Q0J5UW1hOWVIam56Y0wzNnNjcUd6WW5E?=
 =?utf-8?B?dVpRUG03TEljcXdPRjEwNDdYVGY3bExyaDY3V3NaMjVzaktVbXhSTWQ2cFU4?=
 =?utf-8?B?N004RWN4SmtmMVkyYXNsSzN2RVBHT3hlSUFLT1RIOGZRNE1OZjFIWG5xdHJO?=
 =?utf-8?B?SmllNTFKYmpBMWwxK3pnUXBHdkhpN2J3U1g1NE9sRXpqeXZNTisrSDBzT3FS?=
 =?utf-8?B?VE1MTDVackczWlRkeWtLVEFLaCs4RVI2K2ZOa2xXSGpjWDNiWFdzR05zOTFx?=
 =?utf-8?B?eEZBUVRPL1l0bmpuRjFaSDJkU1MzNlFyajQvZFZkRjZwVDNSVHE4OWpLMC9F?=
 =?utf-8?B?NmhURjBrYVFSRFhBUlBBWE9oK3F2WkoxMzdvNkNoTk1DTjRYRFNlN21yY1Fn?=
 =?utf-8?B?eDlLcW5adWJTcENDWEd1ZGZRc2pVbm11MHNJNUxRQVdVcjZxVzM1Z0NOeGRo?=
 =?utf-8?B?dVJYaUkyNmtlTSswZzVzSjFDNFU1V0tBb3pRZFhMNVpUTXBCYUhiQXVPSkIv?=
 =?utf-8?B?THhOdDJzdlR4a25tUWFrSlQ0VzZ0RzNLa1BTS3dQVURFMWNVcmJYQ2xzYm5t?=
 =?utf-8?B?U2grSk5uS3FLMkxtSkpxYkZtRTNONnM4UU00Zk5ncGJ6cHlqOW1HK0IxbTBz?=
 =?utf-8?B?a3Q4Smgwd1hrcGNWUXdhekRrY0ZQRDk3a0Myekc0VWxRY1FXYmp2VHZoU2F3?=
 =?utf-8?B?Z1N1S0NNZG1oaGwzTlczTTE4SEphVTRlcVFka2R3Uk5GdnM0d2NGUGxvSlRj?=
 =?utf-8?B?NFFzR3lURFhiMVZxajRvZXU5OXdiQzRYeUU4QzByQnV5TVIxazIxWDl4ZGNL?=
 =?utf-8?B?aWdtay9WQzJyWHlUQ3NKVTlTWUI1YytrTWVsZldvdE5SQnBBSll0aHluYWtI?=
 =?utf-8?B?VUtXS2E4b25XMUpjODFuZGxQZExieEFjRjg4VzAwY1ZDQjFFSmZJc3lTMFY4?=
 =?utf-8?B?RjliQzhQR0xOUWxaK1JtMktqNDFNbVdnRzJuMHo2cTlMQVNaUmVEeGxPUTFs?=
 =?utf-8?B?djZaL1hOTnlGVTZmZmUvancwcWNuSndNMTZuOFpUbEJTQnJZL3JWMWViOUY5?=
 =?utf-8?B?SUY1WCs0bHVCUnFBbzBqNmllZWpWcER6UmxkTi9BZHUwK2padUVlNEUxcGd0?=
 =?utf-8?B?Mys2U2xoYlJFUkV3SDFvWlRDSVNmZXlGTTcrK3UrSEJDYzJTU2ZvaVBXb3BB?=
 =?utf-8?B?UnduaGdlaEQxeC8vYU9YVUU3Z0ZFSW1GSjNtd1liM3ZpMDU3amNoUFdBZWw3?=
 =?utf-8?B?YXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8B5092FD2380C4EBF65C84E9DA70FBE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac63825-ec9c-42c0-091b-08ddf9b33907
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2025 08:37:10.7108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: icCs8mheskrS8rGIhy4I1LQ64iNdrfpgVjuPJimSFkJynUbN9yKVSUxPjeFufBrK/WNLCvJB+Fwoh5JiWIp+yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KUZPR03MB9496

T24gRnJpLCAyMDI1LTA5LTE5IGF0IDEzOjU3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGUN
Cj4gDQo+IElmIHRoZSBzdXNwZW5kIGNhbGxiYWNrIHdhaXRzIGZvciBlcnJvciBoYW5kbGluZyB0
byBmaW5pc2ggYW5kIHRoZQ0KPiBlcnJvciBoYW5kbGVyIHdhaXRzIHVudGlsIHJlc3VtaW5nIGhh
cyBmaW5pc2hlZCwgaXNuJ3QgdGhpcyBhbiBpc3N1ZQ0KPiB0aGF0IGNhbiBvY2N1ciBmb3IgYW55
IFVGUyBob3N0IGNvbnRyb2xsZXIgYW5kIGhlbmNlIHRoYXQgc2hvdWxkIGJlDQo+IGZpeGVkIGlu
IHRoZSBVRlNIQ0kgZHJpdmVyIGNvcmUgcmF0aGVyIHRoYW4gaW4gb25lIGhvc3QgZHJpdmVyIG9u
bHk/DQo+IA0KPiBXaHkgaXMgdGhlIGhiYS0+cG1fb3BfaW5fcHJvZ3Jlc3MgdmFyaWFibGUgbm90
IHN1ZmZpY2llbnQgdG8gcHJldmVudA0KPiB0aGlzIGRlYWRsb2NrPyBTaG91bGQgdGhpcyBjb2Rl
IHBlcmhhcHMgYmUgbW92ZWQgZnJvbQ0KPiB1ZnNoY2RfZWhfaG9zdF9yZXNldF9oYW5kbGVyKCkg
aW50byB1ZnNoY2RfZXJyX2hhbmRsZXIoKT8NCj4gDQo+IMKgwqDCoMKgwqDCoMKgIC8qDQo+IMKg
wqDCoMKgwqDCoMKgwqAgKiBJZiBydW50aW1lIFBNIHNlbnQgU1NVIGFuZCBnb3QgYSB0aW1lb3V0
LA0KPiBzY3NpX2Vycm9yX2hhbmRsZXIgaXMNCj4gwqDCoMKgwqDCoMKgwqDCoCAqIHN0dWNrIGlu
IHRoaXMgZnVuY3Rpb24gd2FpdGluZyBmb3IgZmx1c2hfd29yaygmaGJhLQ0KPiA+ZWhfd29yayku
IEFuZA0KPiDCoMKgwqDCoMKgwqDCoMKgICogdWZzaGNkX2Vycl9oYW5kbGVyKGVoX3dvcmspIGlz
IHN0dWNrIHdhaXRpbmcgZm9yIHJ1bnRpbWUNCj4gUE0uIERvDQo+IMKgwqDCoMKgwqDCoMKgwqAg
KiB1ZnNoY2RfbGlua19yZWNvdmVyeSBpbnN0ZWFkIG9mIGVoX3dvcmsgdG8gcHJldmVudA0KPiBk
ZWFkbG9jay4NCj4gwqDCoMKgwqDCoMKgwqDCoCAqLw0KPiDCoMKgwqDCoMKgwqDCoCBpZiAoaGJh
LT5wbV9vcF9pbl9wcm9ncmVzcykgew0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
aWYgKHVmc2hjZF9saW5rX3JlY292ZXJ5KGhiYSkpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZXJyID0gRkFJTEVEOw0KPiANCj4gwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBlcnI7DQo+IMKgwqDCoMKgwqDCoMKgIH0NCj4gDQoN
CkhpIEJhcnQsDQoNCk9rYXksIHlvdSBwcmVmZXIgdG8gY2hlY2sgcG1fb3BfaW5fcHJvZ3Jlc3Mg
YmVmb3JlIGdldHRpbmcgDQpydW50aW1lIFBNLCBsaWtlIGJlbG93IHBhdGNoPyANCklmIHllcywg
SSB3aWxsIHJlbW92ZSB0aGlzIHBhdGNoIGFuZCBjaGVjayB0aGlzIGluIHVmcyBjb3JlLg0KDQpA
QCAtNjYyNSw2ICs2NjI1LDExIEBAIHN0YXRpYyB2b2lkIHVmc2hjZF9lcnJfaGFuZGxlcihzdHJ1
Y3QNCndvcmtfc3RydWN0ICp3b3JrKQ0KICAgICAgICB9DQogICAgICAgIHNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCg0KKyAgICAgICBpZiAoaGJh
LT5wbV9vcF9pbl9wcm9ncmVzcykgew0KKyAgICAgICAgICAgICAgIHVmc2hjZF9saW5rX3JlY292
ZXJ5KGhiYSk7DQorICAgICAgICAgICAgICAgcmV0dXJuOw0KKyAgICAgICB9DQorDQogICAgICAg
IHVmc2hjZF9lcnJfaGFuZGxpbmdfcHJlcGFyZShoYmEpOw0KDQoNCj4gPiA+IEhvdyBjYW4gdWZz
X210a19zdXNwZW5kKCkgYmUgY2FsbGVkIHdoaWxlIHRoZSBlcnJvciBoYW5kbGVyIGlzIGluDQo+
ID4gPiBwcm9ncmVzcz8gdWZzaGNkX2Vycl9oYW5kbGVyKCkgZGlzYWJsZXMgUlBNIGJlZm9yZSBp
dCBzZXRzIHRoZQ0KPiA+ID4gVUZTSENEX0VIX0lOX1BST0dSRVNTIGZsYWcuDQo+ID4gDQo+ID4g
VGhpcyBlcnJvciBpcyB0cmlnZ2VyZWQgYnkgdWZzX210a19hdXRvX2hpYmVybjhfZGlzYWJsZSwN
Cj4gPiBBcyB0aGUgY29tbWVudCBkZXNjcmlwdGlvbg0KPiA+IC8qIE1heSB0cmlnZ2VyIEVIIHdv
cmsgd2l0aG91dCBleGl0aW5nIGhpYmVybjggZXJyb3IgKi8NCj4gPiBzbyBpdCBjb3VsZCBoYXBw
ZW4gZHVyaW5nIHRoZSBzdXNwZW5kIHBlcmlvZC4NCj4gDQo+IFRoYXQgc291cmNlIGNvZGUgY29t
bWVudCBpcyBjb25mdXNpbmcgbWUsIGVzcGVjaWFsbHkgdGhlICJ3aXRob3V0DQo+IGV4aXRpbmcg
aGliZXJuOCBlcnJvciIgcGFydC4gRG8geW91IHJlYWxseSB3YW50IHRvIHNheSB0aGF0IHRoZQ0K
PiBkZXZpY2UNCj4gaXMgaW4gYSBoaWJlcm5hdGlvbiBlcnJvciBzdGF0ZSBhbmQgcmVtYWlucyBp
biBhIGhpYmVybmF0aW9uIGVycm9yDQo+IHN0YXRlPw0KPiANCg0KTm8sIGl0IGp1c3QgbWVhbnMg
dGhhdCB3aGVuIGV4aXRpbmcgaGliZXJuYXRlLA0KZXJyID0gdWZzX210a19hdXRvX2hpYmVybjhf
ZGlzYWJsZShoYmEpOw0KZXJyIGNvdWxkIGJlIDAuDQpCdXQgdGhlIFVJQyBlcnJvciBjb3VsZCBi
ZSB0cmlnZ2VyZWQgYnkgYW4gaW50ZXJydXB0Lg0KDQoNCj4gPiA+IFRoZSBVRlNIQ0RfRUhfSU5f
UFJPR1JFU1MgZGVmaW5pdGlvbiBhbmQgYWxzbyB0aGUNCj4gPiA+IHVmc2hjZF9zZXRfZWhfaW5f
cHJvZ3Jlc3MoKSBhbmQgdWZzaGNkX2NsZWFyX2VoX2luX3Byb2dyZXNzKCkNCj4gPiA+IGRlZmlu
aXRpb25zIG11c3QgcmVtYWluIGluIHRoZSBVRlMgY29yZSBwcml2YXRlIGNvZGUuIFBsZWFzZSBk
bw0KPiA+ID4gbm90DQo+ID4gPiBtb3ZlDQo+ID4gPiB0aGVzZSBkZWZpbml0aW9ucyBpbnRvIHRo
ZSBpbmNsdWRlL3Vmcy91ZnNoY2QuaCBoZWFkZXIgZmlsZS4NCj4gPiANCj4gPiBEbyB5b3UgdGhp
bmsgd2Ugc2hvdWxkIGNoZWNrIHVmc2hjZF9laF9pbl9wcm9ncmVzcyBpbg0KPiA+IF9fdWZzaGNk
X3dsX3N1c3BlbmQ/IEknbSBub3Qgc3VyZSwgYmVjYXVzZSB3ZSBkb24ndCBzZWUgdGhpcw0KPiA+
IGVycm9yIG9uIGFsbCBVRlMgaG9zdHMg4oCUIHRoZSB2ZW5kb3Igc3VzcGVuZCBvcGVyYXRpb25z
DQo+ID4gKHVmc2hjZF92b3BzX3N1c3BlbmQpIGNvdWxkIGJlIGRpZmZlcmVudC4NCj4gDQo+IFdo
eSBpcyBhdXRvLWhpYmVybmF0aW9uIGRpc2FibGVkIGR1cmluZyBzdXNwZW5kPyBBcyBmYXIgYXMg
SSBrbm93IHRoZQ0KPiBVRlNIQ0kgc3RhbmRhcmQgYWxsb3dzIHRvIGtlZXAgYXV0by1oaWJlcm5h
dGlvbiBlbmFibGVkIGR1cmluZw0KPiBzdXNwZW5kLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFy
dC4NCg0KDQpUaGlzIGlzIGEgbGltaXRhdGlvbiBvZiBNZWRpYVRla+KAmXMgU29DLg0KSWYgYXV0
by1oaWJlcm5hdGUgaXMgdHJpZ2dlcmVkIGNvbmN1cnJlbnRseSB3aXRoIG1hbnVhbA0KaGliZXJu
YXRlLCBpdCBtYXkgY2F1c2UgZXJyb3JzLiBUaGVyZWZvcmUsIHdlIGRpc2FibGUgDQphdXRvLWhp
YmVybmF0ZSBiZWZvcmUgaXNzdWluZyBhIG1hbnVhbCBoaWJlcm5hdGUgY29tbWFuZC4NCg0KVGhh
bmtzLg0KUGV0ZXINCg0K
