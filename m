Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B24E567
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 08:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710490862; cv=fail; b=DX1CBuxG1d4H3qR2vLeQkyf9VxGB5pMx+xh8E8hqR9gjnTuZmyLfRY1A1kwifvxgeesAtKl8ucfXDXC00L6DtrWozgFN3dHH6Lah8+sI9cbk3JmFF4xjZVdpALzKlknJ6sYo5i6Z6rgZwsITzcBOWdEN4ppGAyg1UjqIiiO2J9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710490862; c=relaxed/simple;
	bh=gF76jVnGR8M+mLjJqc7p1VWtl2t9RhhQ7dlzdntAbGc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PpIXiAbo+Ky+wqaASbrPuHiVq3/Pz7HjZxtlbhuUHim53T3d0LRaPUHyizJM4e1kq4ltYDPeq558d/yeq5C6rrixb/xP3pLmUQ+aERTMkiVMvuYqFBckSkH5J4+MjhnicoiBsLyQ+XFCelcIda069k5+5UEAyn/4d5cPgJIhFek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ByLfMHfu; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Cahl93o6; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ByLfMHfu";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Cahl93o6"
X-UUID: f1e842a2e2a411eeb8927bc1f75efef4-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=gF76jVnGR8M+mLjJqc7p1VWtl2t9RhhQ7dlzdntAbGc=;
	b=ByLfMHfu4nQa9F9mYyUiBX1fK5GBmTnbLDK1q7BwsFTERYN9Dzy/4coE0BC5QWEVmC4PVNy+h6hf0icHE3FxzGz7QlGk2Nz/grkClu8D1nrFr9+H3H2tE0qDZ1WXhUJe/DCbMRX12PE1/oVTGKKeM3xt42pf2/AYtkE5HsCy9ow=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:22ae2ae1-0d09-4e4d-8d6d-06dd36a2061a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:39a5eeff-c16b-4159-a099-3b9d0558e447,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: f1e842a2e2a411eeb8927bc1f75efef4-20240315
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 404402660; Fri, 15 Mar 2024 16:20:55 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 16:20:54 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 16:20:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7Td3PabXqz+rSZKHG8qcH6lr5uwPGCJjsbFDePvmxYFws4nwX/7ukHicm6G0N5LSy1s4N3AC9u+xFjSjCMcGy4GuO+GgXVWzG4t+DGC8C8/0xd7gbIZwvRvDoOZs6DYygF+wXGG2xi3TrHmt4MCTW18C0SPK2qLnCzd3T5WRRDseQOttLbWuHFdxD1XnYYpabLOFCtl/hoEoitIOisp4mJtvPV3O4U60wbtj5RGlet6R/gdgvCGd24MvZqMW4+yxJ3xVCkDVlFWWUFfrczliMkrDRo/d72hN+IUI6oRKe0nxt9plUZqbEtr8FoCmT7TM80rd0ozLF6/vuImQYLuxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gF76jVnGR8M+mLjJqc7p1VWtl2t9RhhQ7dlzdntAbGc=;
 b=Abj/aDXXZemgcV0TNZ1gEDdiPebDeQxQxI6Rs/2qtyXwJN3/IUt+5k/9gHJCe+Ej+K0+wqowKUjd1LsQ4CQr0Zdw/wztmiYgQd9SqzjqBjR1znMn1I1byaLXhHxeGv4DclImuLgKK8w3VzXxxZ1V7cq6+2AbAyUB08PENIMa5w02t60Hoh5mUzU95oBOhQVkFcJdtbA4Bg8QBaiSKQemU3LMMwpB2wYpq9hk4k0biXhKvAzw9w4IQiUGtugns9GkAEY3o660raf9eeejysxqwlJRYf/rpSEvhGUGmrJxA6qM/eJ7f68ROC+adlRmUDdmJnLrEUqRTgcxSObiZM/R/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gF76jVnGR8M+mLjJqc7p1VWtl2t9RhhQ7dlzdntAbGc=;
 b=Cahl93o6heBGnRPXsWPFVpLSxXG3IE1DbP5ItKlVHf9T48QurSWdA2dq/xHUVFwqXHanVqM7EdDqB3XZkKzDULPlFim11tfypI6UQv6RN6jETRzc5ydhp1JYhwJtOyAksdnI47oAVfoGgW3kunbujARDIXy2bYhlFIdl7WzC0bM=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by OSQPR03MB8675.apcprd03.prod.outlook.com (2603:1096:604:295::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Fri, 15 Mar
 2024 08:20:52 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::9756:b4e8:ff47:55c4]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::9756:b4e8:ff47:55c4%3]) with mapi id 15.20.7386.020; Fri, 15 Mar 2024
 08:20:52 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v1 5/7] ufs: host: mediatek: rename host power control API
Thread-Topic: [PATCH v1 5/7] ufs: host: mediatek: rename host power control
 API
Thread-Index: AQHacSa7CMxEsDX6MEmyohcUOYhIW7E4IhWAgABe/4A=
Date: Fri, 15 Mar 2024 08:20:52 +0000
Message-ID: <f5b3cb551d17a9bd6decbddd4e298b59e31f65f5.camel@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
	 <20240308070241.9163-6-peter.wang@mediatek.com>
	 <8b63a194-e4c8-41df-90f4-869c39636467@acm.org>
In-Reply-To: <8b63a194-e4c8-41df-90f4-869c39636467@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|OSQPR03MB8675:EE_
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vb2fHsCt2Y6D45AdqZeq/cl8HRoPd0heUmeUDpldumbFBCeuIqCXwap24wKL9HDbOUfcEqncmdggwk1xJ+sLN6gTyAkct6awyEgn5va+nOkcuifAvytj692PG3FGRIY5mDGBGucxnl3QeDs7uxASuBtH/GF25q4ZQDGmIYhJzMF7HflgaFHKxuVwC+ZZu6hmR8/lxhnBgmQPRn/rlkBVMxbBrxbzPeEy7DnPjwQaE0NRKLWpPkuDEqhJ+77nagm/dByB0LelBetaqeAX7+5Syv8shbz3CUPymzE7NHPrOvhwJBesNO0g2e2dc/GGGHsTtB0GBdm0+qa+mX/wS5RuzkGVI6+J7YrVz8Up+r7haF7qSdLwVA030rzMGANLp59/Yz+6z5EzzzPW2EBZHHr+MonsCXu/CGezBqa/xo0mo6ADECTJ050PsyjNuPg+DPs3TD+IuqaFp4Sh/7xmjBDFbsl/ygqjvPUjRGMwXuIOS2jQiEysFyUduXRCjYXL5WSGGc02kb/OKtwdliqUSKI5bw3RsiVv+glUehkyli9ttEm5kCWcMWMYbkhxElI7lRcc4Q91KsR2iicFvAffkx7gUESe04tcMhb5V2rr+4ztqiz9xQLSqbR9d5GY6yAbzt5f3n8/WhUVM0+lDw9yIPMQ/Tm/3r3bG8fGHP+HKXUyCFg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDgwWGhkU2Vvbm9CMEErQ3NjUmYwaXh3MWUwZGVnRHo4YTA2MWo2SXQ4VnJs?=
 =?utf-8?B?a1VsOXh3N0VwaTBJWlZDWG5CV0tjSjhQWFAyYUIyNnNVUnVMd0hrRjNvWmRK?=
 =?utf-8?B?S0lLQW1hSlhlNHMzSk5RYjYrT0NOekYzamdiQzVxRklKVWhBSngySnU0aWFn?=
 =?utf-8?B?bUU5UGUwYUdDRzQ2SUV4Y1RpN0trWFk0MnIzL2Z1ZkFzVWJ0dU0vbGNFSGVK?=
 =?utf-8?B?L1huczFpY3BoYk9NN0diN01kWDJMS2RoeXFiUmFZaVNXSyszRzh4OG1TVVNK?=
 =?utf-8?B?aWZ4TXk0c0tlRlJwR04zU3ZmdXhJc2syblBtN3prZklKRmhGSURzbVg2bytL?=
 =?utf-8?B?UzNJYkV1NjF1OTNaSnRGazg4VkZyanV6TFJnYlc5TmlEMkpPVkFuQlFLcC9u?=
 =?utf-8?B?T3BocFo4ZlpkWEVJbVdsWE5UTGNrQlpxUHpIRU45OXFXd3pBYk5mSFdoTFR0?=
 =?utf-8?B?OTdRTHlCd0RqMWtNeEpieVBoalJuTjQxcU5oaDRXNDBvUFEyTE9SeWowMHRD?=
 =?utf-8?B?SzNlSzQwblBXbk43dEFweDUyem9DdjBhaE9UWTZEaXZ6SlVNZEZMUnBucG1u?=
 =?utf-8?B?bVAvQ0dNSCsyNk1qOGZTQ1RoYURXbzEwM2xQUXZQc3BHcmEySXlRTjdpbE1G?=
 =?utf-8?B?T0UyQW10QWRCOGlVa2FGaHU0SkNYcmxEWjAvd29lR1FwYmMrUDc5NjN5Ykl5?=
 =?utf-8?B?VzlQbnYzSlFKVGpzczRtaFJITFB2T2dEYThibTFZM1lmdDdWak51MTNIZmEz?=
 =?utf-8?B?SW96SFYrNnF3NExVcUhmQUVKTDZTWkYyTEZZVkNkaXlFUmhNTmF6SzI5dlN0?=
 =?utf-8?B?cVJqNFNJeld0cCswM0NHZ1l0VVd2Rkw3dWU4Nk5XWE91K1cvOU50OWFmS2Z2?=
 =?utf-8?B?MjU2Skd4R01pcDlNc0NyaGRodU1weWJEZ21Xdi9xQ1I0ZGJseXd0aEpvUGEx?=
 =?utf-8?B?ZjZhNEVqSWQyTkJYYzByV3d0WHQ2NUVsSmRvVU1SbXdkVFlVaWRKWmwycjRy?=
 =?utf-8?B?M2dKc3RSU0NEa3pQeFpDMEs2V20xTUJjNWdZSmI1SSs5djROZDBNK0VPaTcy?=
 =?utf-8?B?MGZlTHBkb3hwNU5yazZGb1NnNnF5Wm9rTUN3VUxwcndGMzZ2bzJ3WFo5aU9T?=
 =?utf-8?B?S2JjbVZUMS9PanVYNDdCWHk2Q2NadFE3UjY0aWxXREdpc0EzYzNxMC9PWkR0?=
 =?utf-8?B?TnhPMHk1V0ZpNkdvNWxFNTZiUmpDSFV6aFl1NFpSckhTdThHOWtxR0E1bCtm?=
 =?utf-8?B?RnRIK0tEWSs2QlRFZ1NRQ2pKeUQycVpRa2pQaGRrQkFVb2psNDYwRUY2d0dY?=
 =?utf-8?B?YXZDVHpDaUNmS0JJbmxnSUNPL2NsMXFXc0VCQUxxWU9zaVFXRmNrWVBOTmFP?=
 =?utf-8?B?dE8xZE81em9tMXM2V2Joc1BRUWZlTG9HSTdHWXRpRkE2aVRkVE42dU8xcHhn?=
 =?utf-8?B?SnFJMGVqUHcyQytNcUUyT1VEN0NIZnN3Vm5aemJ1WHN0RzQxeWgvVzA4bXo4?=
 =?utf-8?B?V252WmNnMXR0MllzaFhvTUczRUdkUzRjdnc2VWFmak9wc0VLc20rV1l5aURh?=
 =?utf-8?B?czVpM0ZMdllxVUxhUTJrVysydFlJOVdaZVBnZjhuVVlOb1h1Uk5HelJKa0ZF?=
 =?utf-8?B?Nlg1Sm16aHNiVjhzUm12UmxqL0Nab0dGeXBRSGxZdmw2clBWRlBiSTI3NkxN?=
 =?utf-8?B?MzZLZlh5bFZIMWhkMHhCeWVGanMwdTljSW0rWlJoZlM4eFo4S1M4L0xEQ0F6?=
 =?utf-8?B?cFMvVGEyd25SemZXMVRMTmttZGVCMldiZlgxMFlEQlVMYUVTNlNSczZ5N3pY?=
 =?utf-8?B?L1dwVjZTb2ZrSjlCNmdINnZqV0JNa2ZFaFowcG4vZkZ6L2x5cytEaUl0aHU0?=
 =?utf-8?B?TVM3M1RJNzZGNzh6RVh6M3ZzczlSbUhQNUorMyt0T29NYjdaUFByaS94NzVF?=
 =?utf-8?B?c0JBdTlQNlVUYUVTL1VCb0FyeDlPMkFneGVHeGk0VlBGTnI4NDBpU3d6R3NB?=
 =?utf-8?B?ZmRKSXpBRzNNc0FIaEV4MFdRaGZKVGkvWHBlS1M5U1o5d2dVQVJyblpjb2c4?=
 =?utf-8?B?ZzF1dkhwM2lQNFV3bTNtUnBOMGNzQ08valdoU3YweHMwYzZwUG9NME9LczJx?=
 =?utf-8?B?YVVRNzFwRVVGYmVaQkJJS0N3N3NNeVR3dFhWVE9DbHBDVC9pbUJGeXcvdXF4?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E2EA6A3157F3D49869C7A21DE755DB1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10c93103-62ed-4625-9cf0-08dc44c8d422
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 08:20:52.2607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1WicbB31i61mKrHcohpypLA2zZ51I0kk6RUkib8+6vpRDg5kodvUZT20puu20P3aOhE3f6SizHLfW3V3GzP0/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSQPR03MB8675
X-MTK: N

T24gVGh1LCAyMDI0LTAzLTE0IGF0IDE5OjQwIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gMy83LzI0IDIzOjAyLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gPiBIb3N0IHBvd2VyIGNvbnRyb2wgaXMgY29udHJvbCBjcnlwdG8gc3JhbSBw
b3dlci4NCj4gDQo+IFRoZSBhYm92ZSBzZW50ZW5jZSBpcyBpbmNvbXByZWhlbnNpYmxlIHRvIG1l
Lg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFydCwNCg0KSXQgaXMgbWVkYWl0
ZWsgaG9zdCBkZXNpZ24uDQpXaWxsIGFkZCBtb3JlIGRlc2NyaXB0aW9uIG5leHQgdmVyc2lvbi4N
Cg0KVGhhbmtzLg0KUGV0ZXINCg==
