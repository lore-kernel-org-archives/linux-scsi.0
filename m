Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC1A6FA9
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710468649; cv=fail; b=Rk1pUgPg70fOvh6ppY4mh9z+yOiZclOmH6FMh/7cKv5w1KGJUt9y0n0pVl5YUjB5bzpiGXt4v9yEPbYwehwbWQ2Gc97bqbjdwOA3xMOkq0KhdblnboVpHqFF0UMP840wUtZr41uGyUm/uSogcSBZWRci8M/sBzFW67HLh69cfLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710468649; c=relaxed/simple;
	bh=gsKfx5MA73EuuxCt2TL8kbfR8vaJd3x1oltxffqVz0c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i+tpRyspRslM1WdZW9Gpr7efhzKUyciFSgyG0yeQHxWTMK04ttnzGbahJLsGnwqinLtk5DOHqexpnMrP6kQwv2bKElDQwEcYIvgQPYXXrop+PZLM9MB4efX3bQJKBGq5rUdbn9ljWJJQdArRSomkjkxohaHkxsHqakAnmtkHl3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=M03y1cCI; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=iko8Znra; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="M03y1cCI";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="iko8Znra"
X-UUID: 383d14aae27111ee935d6952f98a51a9-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=gsKfx5MA73EuuxCt2TL8kbfR8vaJd3x1oltxffqVz0c=;
	b=M03y1cCImMdtADcP7fTYtEQvqs094dFDr8y1v/vZOU0KsIlxPMPY4Epo778Snbn9mi+2eB8egoma4b9pm8CccFwQEMTIeAknW8sjtqXmcRnsEz4gM9rihtQjXK6QgeGOfSBxUuc9rA4TYk1vRAuVT0YR394H2RCLh9CaIJFdakA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:c88daa22-0dc2-4c0a-9b36-812bf7ffecbd,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:b2778581-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: 383d14aae27111ee935d6952f98a51a9-20240315
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1883873083; Fri, 15 Mar 2024 10:10:39 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 10:10:38 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 10:10:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7B4JZumxCmBpRNhOld8vAZFRrdkWarEj30NZZjG6hsZ63xHZpthv9IPm69AQcTJ7F5V65PJJAuguhJOo65iKmf1gLn3IwIfJp3bfvEi6a92ASoiBFNAwlFC9tcwg+ESFsmpCLbQIgxVAOb9euYidO8Svuw/5L0s+Dc7BubBHCAlEJu7cBfpd808H6jnMZ2rAfEZJXZVtfpF9/ZhmYiENrj2LU2QNRn26GVk6u4ilz9amcg8TvjT0mUzZWPfGYkyP9kRNgvYs58N2pj5N7DP0v3T+r1H7BlTFiiR3XQWUCoSaQkzPc9meXO9Dy70P/v5kPQbHsJcHiIL3e5lrSAs9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsKfx5MA73EuuxCt2TL8kbfR8vaJd3x1oltxffqVz0c=;
 b=JaIWlTHvOsBTX2n1EZWK/ZHrXKW6nJEzYC/83/vAlNudefoWzR7SrLj+UUiIYYC2bzvQaAJx10cNx8FjfO0Q+ocpHRzFjigsul77onb81PDAIrXiE3S4icR07AK19iABmyOPTmGwO4z/nGtcK+3SztDtDccUj7xvdQaYM/7Lvp3ejEfRgw6ZtVPoO20HCKW78YUZmcatsO5LFYcRlei+w1IsSEwdfoPr8BLPGd/zwUw6FXQtgQIIoQ84SBXL6WT8qGKsn36cHFxDArUrfOCKgPnrw2Ro+cyLSBJpbuPOXU9OiGn7bDSmP33uiB6K+7eOv4aQjvhX4hh9MqU1SOdvhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsKfx5MA73EuuxCt2TL8kbfR8vaJd3x1oltxffqVz0c=;
 b=iko8ZnraLYYqJT68z0xc1dW0qO7hBJCG3Ax8SILgpU/B8+at5S9euAEBf+gWt7Jt9jTVTGrRkpUxCkTsMP7ov8DxUA0rWyK3+0eQ+nfdArk+OsDmu5bUN7i4p0cVwzN/eMfhOzgAMZpBuscB2HGG583b7nA35un9yWOJkHShXX8=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by TYZPR03MB9096.apcprd03.prod.outlook.com (2603:1096:405:db::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Fri, 15 Mar
 2024 02:10:34 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c%3]) with mapi id 15.20.7386.020; Fri, 15 Mar 2024
 02:10:34 +0000
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
Subject: Re: [PATCH v1 0/7] ufs: host: mediatek: Provide features and fixes in
 MediaTek platforms
Thread-Topic: [PATCH v1 0/7] ufs: host: mediatek: Provide features and fixes
 in MediaTek platforms
Thread-Index: AQHacSafugp8MteMUky57B0+6BNgNLE4GZ6A
Date: Fri, 15 Mar 2024 02:10:34 +0000
Message-ID: <b50229afe2aa9f5b769e10f8205a69b49c44615c.camel@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
In-Reply-To: <20240308070241.9163-1-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYSPR03MB7350:EE_|TYZPR03MB9096:EE_
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R1wUMRn127b59TiFPYogNiaBL6YTur+qItSq4BM+KgOYpY3TLUjg/tbnSO1lYFHClLGV0xrPlr/Tf3r61PLakD26a5Oc25MCrfdWN0sLpkQstXrLeEi+IrqWKgJTIsdayHmAexGhu1Vb88OVe0Ps0VaIXpc5xibd/d0zWHquq2P6BBmI6/C+20vA8YmugvyBQZrLQw1wdAuPtZ9qD05WTznpno1WqOHDfe6M5pNkN+bzV7n9e91aCqkyTB3r6wgbTkgxJJK1BRjm9vSxNhGXKZexTO3tvPxwhqQmXQ6NcX3TEaU6yI1kXpOWRm0evW/Y89Tq3r47nS+gu4LAdYNbK5wiWnMYozF0ThjLd62pj50365TDrsZSpe+bBECz54abEq1uBX2YlApd2vQIL+fsFpdUNTEpw6sQ+PByP19sEwMyfZahEwi0L0zyx0nGpJRq5s1tmD70tts276Q+Y2fzpnaWY9ziNvPpuVYckqIMcVbfa9C8RRQoBGiGeGMHW0rWB069UiBwLO39U4Mfi/D+MiAAQF3H3z/5nymcf6VIfgHoUD4d/wQTCjdIuzMfeXIkS4GtSWeIm49g5HO/1VOl5eFMordLEh0DnRO8BJqmggsi2nbxYsTT/ifaBkcjBWrcEse7Xx9eRrc30oao8dcqsWR8KSFpkW4yt3VScN6d8e8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUdoU0dOc1JmeXpqRlVHa3VGak4wQ0ZQcmNWeW1rUFJ3Ui9BUmZ5TWY3VFNP?=
 =?utf-8?B?MWovK2Zyckhib3pBbHJoYWR4MDNtVlhja1hwaGtEbXhYVlkyclNSa0hQY3VJ?=
 =?utf-8?B?NjNHQUgrTmlBaXVjY0NkKzRHalBCV1dWbmE1bjRhYkF5eDZzZm5JR25MWnRD?=
 =?utf-8?B?N2J5VzZNcUMrUlRDQmtiNHJEQm9xbHE1MGE2anB0NmtGNFd5Ykt2cmZXL3Jt?=
 =?utf-8?B?VHRQN0E1TFErRmZqdXFuYkQ4N0doRndjZXdZbXNxWFJVd2NwcWFFVWk5MnRN?=
 =?utf-8?B?TFJ1RHZNZmNrekc4RnllY1VXcW5RMjl3YzFuTmozWm5tS2tIcUdwamRGUTNG?=
 =?utf-8?B?RGQ5SlRSMTBPY0VxVFp3QXJlQmxSQkx4QXN4M2VobGVrR1Y4dzJ5eHpkRitX?=
 =?utf-8?B?SWlXT3RUaXpUMUhmUDdlaS9UZVpNZXptQm51L1p6My96K29Jdk1MSEVkekM1?=
 =?utf-8?B?cVU5aW9yTERsTUF4bGo3dXlwZ01yNkZqODg1clNXZHlRQUNvNXdFRjhOcmdE?=
 =?utf-8?B?UEdaaXlMUEc1ejZSYXQrbHN6MEFMbjBrdnN5NjVDMFZ1NTRsUXlyY1QvTGNq?=
 =?utf-8?B?ZGFzS3ltVkJEb1kzVkV0UkNIeDZyN2QrS3RwWmtMQTd1RnVsOWt6UjB6TGEv?=
 =?utf-8?B?NHo0ZmExVm4vVldhTmtOSFl1dUhRVWdidFQ5dEMyM0NRd21lZTlDZ0d0TGZU?=
 =?utf-8?B?RDlaZG1MNEQ3K2pmdlVQRE4wN0ZWY0lsQjNvMVVvL1VaL3dEMngzQVdOK0l6?=
 =?utf-8?B?eWZLVUZoaTlKUk1sUExUOU5NS3AvbEUzSlNNMFNVeVNRaUpvWWwvOEZMaU9J?=
 =?utf-8?B?aG9KZDFQeDNmVjQyK0NJYXFwUEJmTmh1cDJEeWt6ZWtVY3IxcnVwVkFINlFX?=
 =?utf-8?B?bDZ0K3hsOGRxOWFpdFB2UkxvUUMxZktSVHo0MWdZckllZ1hhQ1Y3SDBEYlRk?=
 =?utf-8?B?a3pyUjRNaVdOU2l2bGxubm5lUlBia2lCSWY3cjFpdVRibVlmS28ybDhaWFln?=
 =?utf-8?B?UXo3UDJYYndGUktmY2ptTjVWSzIyaFNaYktFS1ZOdlUwYW5FNkdicnVMYkRr?=
 =?utf-8?B?ZEsrd1ZEejRQYzZqYlkyRi9nd3dtZFBObTl2SFRYTVYrZ0Q1NTdHMlRuWnl5?=
 =?utf-8?B?YVBKNnRUckc5ZXBzWXRBcjFtRzdzZXB3Yjh2ZEJWdjNaeXBhUE1XQjFUTW5Y?=
 =?utf-8?B?bS92MG03NDIyOUNHMU9QaDAvT1FVWUJDblNJM1VBWFROY2VXeVIrTnNWaUps?=
 =?utf-8?B?ZlBIeHYxb0VpTGdKdkEzZzVuZ1dYRm5SWS9DV2dVQ1dncE96VVB5QUtHSWNF?=
 =?utf-8?B?cVI0V0lyUThqZktzMFd0OGNTYXVJaCtRS3lsRXFaU1RwNzJnc1JiZmIyc01x?=
 =?utf-8?B?S212dWFwc1N4clVxbDNEbzZQL0hDUTZTc2xyQ3NUbS90L20ya1RFaXlKOHMw?=
 =?utf-8?B?amphTCtWdU1kUlM1SzA0RDJEdkdNZXZLdkMyN1BCeHBkYlFUa1VIU2FlSUNL?=
 =?utf-8?B?YXBIRnZqMERNT0E4ZTF1RVpRcmxZYkw4WjdtSW54MitBNVRFRnhVR3kzRGJK?=
 =?utf-8?B?S0hXVzZ2Zm5xeVAycUJCc0IwVWRRWjJ1eWhjL3ZWYWNFbHR1cWFocUlWZzNx?=
 =?utf-8?B?cGRNRnNBVmE0Rk44V1orcWt0L2ZnTlc0MVhJOFZqQ2lFZ25yREdMNk9QakM0?=
 =?utf-8?B?cDE3dFE1RW9ZK2Z5Zk1TbXNBd1FtRFUzckRtZnZjMjNsSWF5M0dpM2trZFRa?=
 =?utf-8?B?aDRqQ21tc1ZzQUY2WUtjQTFXdUtYMkpRL0NBYjc0ampqNVlFbVoxSmRXbE1F?=
 =?utf-8?B?UHdPNEpNcHdraE9uaUJldTR2NENWc2FwUFFCK2QyalpPNmhvWkc1RkFNM2Jj?=
 =?utf-8?B?dTFaSkFyMnVmS0tVNUcrVkxqNTcvclZXeDh5U1VRVGxiNGtIbmo4b2ZYRW1L?=
 =?utf-8?B?WFNqVHdDdXRiejVUQkhsTUo5TTlVaGQ2YUhkdVBBZ1lUTEkvUlZJSTh4RmZi?=
 =?utf-8?B?MkwwbWtkeWdoWWdTVnBoUHZLRlFxcVAyVDBTOHAwd2pqdzkrTisranE1RGRx?=
 =?utf-8?B?eGFRaWk0UUFpRm53NE5XOFU0eWpMREIrbDZhY2V0M3ZMb01iMjZhdzRReVcv?=
 =?utf-8?B?VnFOb0dEV2VuMVcvelVVK2ZuZ2dHdFhtNDlUY1V4dDkveHVVMFBkNi9QRUtZ?=
 =?utf-8?B?RHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0928A54740406C40BD6DD7A6CE71AA75@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d5758c-2998-41d4-eaa0-08dc4495190a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 02:10:34.0188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: deipDHkXPie/A8aOV+QLYNa89P8ecyDEY7cAJhgSf0lwyqun6zYTvIuEhgJEgRUq+9b/Vll0ld141zXyhh+wDKQeofe5Y9zaq5ADEsk7tOA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB9096

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE1OjAyICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBUaGlzIHNlcmllcyBmaXhlcyBzb21lIGRlZmVjdHMgYW5kIHByb3ZpZGUgZmVhdHVyZXMg
aW4gTWVkaWFUZWsgVUZTDQo+IGRyaXZlcnMuDQo+IA0KPiBQZXRlciBXYW5nICgzKToNCj4gICB1
ZnM6IGhvc3Q6IG1lZGlhdGVrOiBmaXggdnN4L3ZjY3F4IGNvbnRyb2wgbG9naWMNCj4gICB1ZnM6
IGhvc3Q6IG1lZGlhdGVrOiB0eCBza2V3IGZpeA0KPiAgIHVmczogaG9zdDogbWVkaWF0ZWs6IHN1
cHBvcnQgbXBoeSByZXNldA0KPiANCj4gUG8tV2VuIEthbyAgKDMpOg0KPiAgIHVmczogaG9zdDog
bWVkaWF0ZWs6IEFkZCBVRlNfTVRLX0NBUF9ESVNBQkxFX01DUQ0KPiAgIHVmczogaG9zdDogbWVk
aWF0ZWs6IHVmcyBtdGsgc2lwIGNvbW1hbmQgcmVjb25zdHJ1Y3QNCj4gICB1ZnM6IGhvc3Q6IG1l
ZGlhdGVrOiByZW5hbWUgaG9zdCBwb3dlciBjb250cm9sIEFQSQ0KPiANCj4gQWxpY2UgQ2hhbyAo
MSk6DQo+ICAgdWZzOiBob3N0OiBtZWRpYXRlazogc3VwcG9ydCBydGZmIGluIFBNIGZsb3cNCj4g
DQo+ICBkcml2ZXJzL3Vmcy9ob3N0L3Vmcy1tZWRpYXRlay1zaXAuaCB8ICA5NCArKysrKysrKysr
KysrKysrKysrKw0KPiAgZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0ZWsuYyAgICAgfCAxMzAg
KysrKysrKysrKysrKysrKysrKysrKysrDQo+IC0tLS0NCj4gIGRyaXZlcnMvdWZzL2hvc3QvdWZz
LW1lZGlhdGVrLmggICAgIHwgIDg5ICsrKy0tLS0tLS0tLS0tLS0tLS0NCj4gIDMgZmlsZXMgY2hh
bmdlZCwgMjE5IGluc2VydGlvbnMoKyksIDk0IGRlbGV0aW9ucygtKQ0KPiAgY3JlYXRlIG1vZGUg
MTAwNzU1IGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLXNpcC5oDQo+IA0KQWNrZWQtYnk6
IENodW4tSHVuZyBXdSA8Y2h1bi1odW5nLnd1QG1lZGlhdGVrLmNvbT4NCg==
