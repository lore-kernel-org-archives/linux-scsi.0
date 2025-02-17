Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56492137750
	for <linux-scsi@vger.kernel.org>; Mon, 17 Feb 2025 05:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739770385; cv=fail; b=S3dUfm8E7SEphuBRSCzL65nW1f+GKizEYw7yx7ewVFa8PjYA0oW0fxqKu1g8fsUnpPAvIRnbSNzLV78P/Zi1KfPUy9HLl09I3E2mAoGts7meHVo/uM/VtVk7VgQVW2sgAOd6+Raqtxs+sUs/nboDFeUNN3ErG8Pd1yoSGwBmodE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739770385; c=relaxed/simple;
	bh=VRR/ZLWWhFGkU99FzMbm3HfTTG1s91CAW5tX9Kp4KgU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XGuVMVUUxHZ/sflIk5hRtAgOiltp3Y0zzLTteoK2jaUNNTgm5bEZK5Sa+P51+obPg9oIxQai3BUdIlQ3nppV+S0Xb3b6lhLjxSG7ownTomQaVpAQkN2Art4XOk5Oa/92DVECL+atjX/60zKvseBm0yDyxujoTFnNrT8X410Y8s4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Ql3zqGot; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=kqIGb7/w; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ql3zqGot";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="kqIGb7/w"
X-UUID: a5798dd4ecf011ef8eb9c36241bbb6fb-20250217
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=VRR/ZLWWhFGkU99FzMbm3HfTTG1s91CAW5tX9Kp4KgU=;
	b=Ql3zqGot5asnzwaCFgrDHMZX/wiVvL9fORy/bhVBSIY1E5iVYpiGJwjXdrpHnrQXAqum6DrjoLgSkMyVkCTbkJH4XHNPiJV456Sky79OMQF1hyo2sp6XxFkPhg9VgwDnyQu8SlJ7uEgbaSr61Dl2PRBi/o23m35Woz+L5oWp+eM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.46,REQID:2b3104e2-ac15-4747-94fe-d8737ea6477d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:60aa074,CLOUDID:6c2edd24-96bd-4ac5-8f2e-15aa1ef9defa,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102,TC:nil,Content:0|50,
	EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: a5798dd4ecf011ef8eb9c36241bbb6fb-20250217
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 220898057; Mon, 17 Feb 2025 13:32:58 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.28; Mon, 17 Feb 2025 13:32:57 +0800
Received: from HK2PR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.28 via Frontend Transport; Mon, 17 Feb 2025 13:32:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X/o9GKvgpkHytZfEzWZ4jZ7TUn74MYXk8VL9vdXT1oMPzEschr3d92ZQ1l1xlLzY11vdLs76rvXWqajhenpUoc3YYeGoIbJ1TulvaFvQBx7033BPJx29I8xhCqpna+xuB31apYQ4PGTGgKW9k0qlEqICbdMPyiG1LsNIMAI190QLri2hr44SF2mRU/sN8+XRtMpkYbC8RYIXbg6damfNZCPldhTttERpeZ4yC8VgUwxI13UtinmCUoTeDxDlKHpMFL7kd1uPFOpO9MF8OoP8M74NjaUX/kgSoL029ngtWhWZnq95z2s7fbaLOFl1wj2it8bc+7/euK5pk1YCwz6qSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VRR/ZLWWhFGkU99FzMbm3HfTTG1s91CAW5tX9Kp4KgU=;
 b=Blujtvloo8sRspUJXHIrmaGAuLfV4i1WEeECwjYAdqtbTMvIoiFI6URGZNCA38CXACvJEItRDhCC/8Z1ziaioHQ62VK6fuYh8Om/4C8beLUhkUuJhq1fKn/FUa0ipJu3a3OPM0Chcea+SXeNr1d/XsQ1QwiUCZeNqDNbBhgO73h+5WiMh0hxI/Rv8KxNZ3dpUgtH+EM9q3OSc6weM4k35RgTTmPmI/x8X+H+7YjnG2U4Sw1pXuAmQK8d63qFjmiHqbdTMkPYpIWVu3khCMEvolntDxa3JoZnXMnxTLWr61OHzSjEnm+51n0miaKSk0WuRwOfCY/qci43aNDXnO3JQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRR/ZLWWhFGkU99FzMbm3HfTTG1s91CAW5tX9Kp4KgU=;
 b=kqIGb7/w41TE/8EOn8pDFoEMDPNmeH2KpAb8kTacN5LmkAXnid1oDuCz85AtdQhN4kSYNusPR0vigg2uzTvBXB0S8Yj5uOZWNkGfa476JmlFctzCXpI5/g97bPv38qsEOvv99b+lGfEPMRmI9zMIqGSZZpCkzyYItdhFsePR3fo=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by KL1PR03MB7599.apcprd03.prod.outlook.com (2603:1096:820:cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Mon, 17 Feb
 2025 05:32:55 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::c4cf:543e:48b5:9432%4]) with mapi id 15.20.8445.017; Mon, 17 Feb 2025
 05:32:55 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "huobean@gmail.com"
	<huobean@gmail.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>
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
Subject: Re: [PATCH v3] ufs: core: add hba parameter to trace events
Thread-Topic: [PATCH v3] ufs: core: add hba parameter to trace events
Thread-Index: AQHbfrq394hno+2a0EKBFGOrIXb6GLNJ/QWAgAEATgA=
Date: Mon, 17 Feb 2025 05:32:55 +0000
Message-ID: <2d3e3ce44c3e84941943a5c5cce93a6acc481fae.camel@mediatek.com>
References: <20250214083026.1177880-1-peter.wang@mediatek.com>
	 <2420c932bd2443b3c924c02a1375ae63bed8ab6e.camel@gmail.com>
In-Reply-To: <2420c932bd2443b3c924c02a1375ae63bed8ab6e.camel@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|KL1PR03MB7599:EE_
x-ms-office365-filtering-correlation-id: dc481094-d376-4d3d-5ec5-08dd4f1487f7
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZUFXU0xnSzdObCtrTk1rc3drMk1wTzhteml3VWJ5U0tJMjJaeG9Bc1cvZ0Fa?=
 =?utf-8?B?dzVyZ2pJSjZjaSs1K1lCT25zUVhpTnNYbU5oMjYvK3dobFdDSzFoLzNjaDd1?=
 =?utf-8?B?OWRaTzdGbkRIeDJxT3NxbFZWVzRhSDRuMjh6SVVteGFFK1U2dFdVcHJ5eExn?=
 =?utf-8?B?TnpGUDhpeFhUc0kxZXdqZ0ZHVjRHQ285akVYTXh4Q1hVUUUzcWVBa25NUkh6?=
 =?utf-8?B?QTIrd09vVE9VSnF2NytKUzNqdmd4T1EvRE1TZU1nbG13ZFRoOFVjdGljVlkx?=
 =?utf-8?B?em1aanF0ZUpUMG9aQUpSOTJWZFAwSFBEVDVCNUROS3VPYVAyeFpEVkJKV2xr?=
 =?utf-8?B?a2xIMHZYN3ZHMlUyUTJDVW14UFJVVUVYU0lIYlNqS2hLMDkxd3VVOE5DT0ti?=
 =?utf-8?B?VHU3dmMwSThWZ2JMZlJXM3FJalFTclBpTW9rd1JUaStscmJCaTI2OEJBQkox?=
 =?utf-8?B?engzdTJrd1d6d2dPckxBYTgva3ViSjI1cGZCRms4ZDBLOGVyajZKTHNEWSty?=
 =?utf-8?B?OUt0ekdVckwwRUQ2QVpSd0VCUEQzb1dxd0xMcGdqdThybG05andod0F5QWlE?=
 =?utf-8?B?dXorOWhoaU9uR1AyaXlpZzZBeEt6L3lpTEtaYWNtSzlncGZha3R5alkwRnlG?=
 =?utf-8?B?YVY3RHU2ek9tOXQvTGJ5UzgwVDBnak1wdStiSUUyUEJNZ295L2UvcC9JUzFO?=
 =?utf-8?B?OFhySXo4TDJuV0dDSjhwZUJvemRFNU9ybFlpSEgzVnlSUlBoeEM5OGQwRlJL?=
 =?utf-8?B?L09WRElpNlNIR3daT080YUNLZWI5c29JbnJ3RUROQVhyZFk1RGI5OGpTZ3J5?=
 =?utf-8?B?R2pQLzdJblFtUjFzb0RHZmV0cHhTdjN2ZFhXbmZYVVVZbTUybUNUTWp2L242?=
 =?utf-8?B?eTJnREgxT3RVSUw2NlVVeXhOOTBTRVBIeUpOa1JLZXNpUCtzRWEzMU1yVmZa?=
 =?utf-8?B?WjdEVXBJRCt5WldadDVJdHVPcnNNdCsvUDNjVzl1cHc4LzFKQnZsZTZwQXo4?=
 =?utf-8?B?OGlHOXdiWmJPVm1LU3MvUE92TGhiVzRZMFYzWmljcHJGZkljQTMvRVVkQ2RN?=
 =?utf-8?B?VENRYXFjc3pvL1lCSUg2c21rVlppczdmeWpaQSttcXFkRno2czFKbmZxMHZx?=
 =?utf-8?B?aDRjTTZLdS9YVEtaZFp1UStFZlJ2cGE0SWdnbDk2YkV6blBFbXh1T3BNRzhC?=
 =?utf-8?B?VHpGa29HMTdtSlNPcTJ0MVY3VUhmbk5sTEZ3VXQ5aG1rOGNFRVl5UnRodC8z?=
 =?utf-8?B?WStlekZRcGFvdTNvZGVxZElIS2Y2OVBvRDl3L0R2Z09ZUExmM1dvcTZndlhJ?=
 =?utf-8?B?WjhyWVZ5TWlsN2c1Q0FOTUNseVhEN0Z6bERReldjajJ4K3BPbHlqZVZqUEwr?=
 =?utf-8?B?WmNmdU8rSmpHRGxMMm50R1pVeHk4YXc2Mjl6QlUrTDI5ckVTbGpBeW1aUlg5?=
 =?utf-8?B?RzdWREhEb2kvMnFyMFRIYWdyRWR3bnd5UEFFMGN4WTFjbHAvb0JRc05yL3JW?=
 =?utf-8?B?TFd4OWNodXN0MytWTWRGSCtvdEE0WGx1QzVLaEJXdDljTzJMSkRtTXIrQStN?=
 =?utf-8?B?T3hpd0M5clErVmprdjhzWUdDTGVsamJET0M2aHpiamJNbUYxTjZXSm5kZXBx?=
 =?utf-8?B?bHZZT1NyM2E4ZkNYelh4UW9iYURtYkRaOTh4RTNaRFZUMDFxSTNzSW5JMVA0?=
 =?utf-8?B?S0NxNjV1Q0hkR2ZMRE1xRStraTdvdU8vNmpOWDhHV1E3R3ZYUXR3akp6TnRp?=
 =?utf-8?B?dHU2TlNFT284cElPbzQwaDdXb1daR0hERmNJM2FNbFBuZ0VBaUNpMFVCTDJH?=
 =?utf-8?B?cWtGVUNIZ1FmUUN2TFJ5VytUdVpFR3U2b05rbnhKTDFRVDY5SnlIYjJPYUdE?=
 =?utf-8?B?ZThqRnE1dDduNU10UEt2M3ZVdmZOc2twVUJsdGE2dUQ0ODU5VzZxWjhnTURh?=
 =?utf-8?Q?5E6+fa0B5IX5jH1DHr3VKjiXhDdQgW+f?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z05EWXJzbjRCUlhpMVQ1WkpRdGtPTTZIalNkVEpIZ0Y2Lzh5Y2VqemVBMzZD?=
 =?utf-8?B?RndqaVZWRVRkc2p0OUdVR3NHbXRKdHRxN1BERVk2bVZXS09la09LMnUwYWN1?=
 =?utf-8?B?bXFyMFo5V0lvSDloRmJ1OHRFNjdCdHVrdXJPdTY3N202MXpOSWM1RldaSjY1?=
 =?utf-8?B?UHZNQThVQ1prTGxmU05BMzJtZGU5SEd2cG9sR0VlM2tLeXFZZkd5T2hZRlB0?=
 =?utf-8?B?Rzl4SHpKRU1lSUIxNWJvUGZIekZHL0JqczNHOHp1UDhMbHl2bmZnVFBmNnZq?=
 =?utf-8?B?ZWNaNjdDRk4vOTF2RHA2N1lUSnAyK0pqYjNMMXlVRFhvcFBKcWxzWjMxcElQ?=
 =?utf-8?B?d2ZEQjgwalk0Q1hTTUlpVk51bGlGUkVYZUFYd052cm40cTNDbDRFa1RieGZx?=
 =?utf-8?B?dGRLOUJEWlo3NDh4WWRGNkVzeGpiMTVVSUl3OGo3WWcvdGdPT1RyaXA3cHh0?=
 =?utf-8?B?OXhLNVdtbFRGaFFWNXB1WW9LZE5DUWozTGRUd282RUpJdnROeDV3VmJsQXNY?=
 =?utf-8?B?a3h5czRYdkR3K3NvRWVkdFY0TURxUi9rVHNrUW15VXJMOXUyajZMSTVCZ2pF?=
 =?utf-8?B?ZTVadmd0STJYREFlMWNMSk5KTkduYUJQNjc4Z1lLWlkzQTI4aGQ1T25mN0JD?=
 =?utf-8?B?c0tHWXdvNldtNEcxN0x2YklqT2EweVllcTZuSk10cnVCM0NJODliMTlNTTlu?=
 =?utf-8?B?cmFQMHBUNUR2QjQ3dzZacWV3YzkvRGNyRnVvcnZxWmE0b2JDWGx1VmNaVTZB?=
 =?utf-8?B?STV3K1VwNFZXaUZURFQvYlZaY3lHazlYZk1waCtURlAya2hQN0JmZm0rTkgx?=
 =?utf-8?B?V0kxWmlsTWhUVURQQ2h5K3hKK3RXU3loYUtpcHZIcEkzS2RGdjVZcGViL2gr?=
 =?utf-8?B?VGhpYkVkUUlsMm1OdjdtbCtlZXRZOU1ObGtHZDFRcmRRQW1IcEM1ZDdLdUZO?=
 =?utf-8?B?OHpWeFM1K0o0S1JZVzJ6a1oxYXN4ZGcvSnpXOTN5cC9tVVIveU5sakJVRGFI?=
 =?utf-8?B?eW9wWXZxS0dpMEdocFRZTEM0dmIvR01tVTd5ZFJDdWdmVVBySTg3YUZMcS8w?=
 =?utf-8?B?RmZpVE41bDhiWlJtcllQWnR2eHpRNWhnTXlRQXFRQUNXaXlyY3JBU0dlTEdy?=
 =?utf-8?B?ckF6KzZZVEFNR2RGQWNiNGY2eDIyZzFJNThsenZuVWt2SmxZY1BjNE5SdGR5?=
 =?utf-8?B?dnVOL21iWFcxT0VNTTY0ZlVQT1REV1NWNUpPTy9rR1QvU3hKOWNmUDlOR1NT?=
 =?utf-8?B?cm4wZGtXbHZad2NKQ2R6UEN5eCtKU29YeUJrMFhLak1Ed1Nwc0ZSV3kzZG9Z?=
 =?utf-8?B?d2NMM0xISmNIOWxrY3pVUjdZVXM1TlBpWTBMb3lIYSt4Skkwbi9TY2dWZ2ZI?=
 =?utf-8?B?WVFlMkZOK1RXR3Z1b0JIWUpaK2w5SURjdkFYaG9aWWNDVWpUTHR0Wlh1WmZz?=
 =?utf-8?B?N1BZYkJUTk9HRitkci90SFR4U1luZCs4TUMrM0dNd0lRRFhlVDVFc3hWQWJq?=
 =?utf-8?B?R1ZoSW9NY3ZHUXRGWEVZelhTQ0Fzc2xFTVVBVEthRmdtdjg3MDFVTmg1Sk5S?=
 =?utf-8?B?WmVhY3JkR3FNalhMTmpSZkJtUm5HakZxVkduTzFKbFBpU3J5dU1QNXhjV05p?=
 =?utf-8?B?R3AydDJpSTB5T3NWUGFkb0lPRUtoTExjczhweXFRd1hWbkJlYnlwQ0RSYUx1?=
 =?utf-8?B?V29BaS8ycDZQcDhEc2pCRDZGOWNpRzlvaGtvcDZPQTIzOHZqbHZ4Q0EwMnFX?=
 =?utf-8?B?THZ5Z0RIYS9JMWVqTTYyblpqK2ZCOUwrQnB2NHNETkE2RDI5YTFpcm5icERJ?=
 =?utf-8?B?d3Z3MEcxWkpUWGtZMzhPcjA2TEtHZkZWRW1USjZKaHNhU2RUVmJ1Z1VPZ0o0?=
 =?utf-8?B?aVR6ZmpDZTV5TDVvOS9nQWtyVTMrRHB1d3IzdnNFQlBOUDJhbWZyYzNuY0Rr?=
 =?utf-8?B?aXNyWnFxdWJpNVNhc1Jjd0hVczgxaDVvNlRZQkdFOWlhSVRFWnhCL1BwdWJj?=
 =?utf-8?B?NTI5Mmxsa09memhTaElYa0pTcGFaUlROSFViWGpqc1J5OTNOOEpHcWJaUWkz?=
 =?utf-8?B?em5mbis2YjcraDJnOWx2RTU4ZUdqbmlWV1JzWlRvNm9iMEVPVEFJcWhCWlpW?=
 =?utf-8?B?YWRLWVJIUzZhZmZXVS84Uk5TbnREZEhnd1IyM1dZdVVGM0pNY1NQb2M1S2Vn?=
 =?utf-8?B?TWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A474082C149B9438A216F97DCA48D6B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc481094-d376-4d3d-5ec5-08dd4f1487f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2025 05:32:55.5406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3/eQEw01f0+E/n/a/Xl+vlxl6nNq4pzCSbvLLFK9wz/nnULxJgj1TZidMySOtFhyZJYHPyXWsIM/00nJjyBVFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7599

T24gU3VuLCAyMDI1LTAyLTE2IGF0IDE1OjE1ICswMTAwLCBCZWFuIEh1byB3cm90ZToNCj4gDQo+
IEV4dGVybmFsIGVtYWlsIDogUGxlYXNlIGRvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFj
aG1lbnRzIHVudGlsDQo+IHlvdSBoYXZlIHZlcmlmaWVkIHRoZSBzZW5kZXIgb3IgdGhlIGNvbnRl
bnQuDQo+IA0KPiANCj4gT24gRnJpLCAyMDI1LTAyLTE0IGF0IDE2OjI5ICswODAwLCBwZXRlci53
YW5nQG1lZGlhdGVrLmNvbcKgd3JvdGU6DQo+ID4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2Fu
Z0BtZWRpYXRlay5jb20+DQo+ID4gDQo+ID4gSW5jbHVkZWQgdGhlIHVmc19oYmEgc3RydWN0dXJl
IGFzIGEgcGFyYW1ldGVyIGluIHZhcmlvdXMgdHJhY2UNCj4gPiBldmVudHMNCj4gPiB0byBwcm92
aWRlIG1vcmUgY29udGV4dCBhbmQgaW1wcm92ZSBkZWJ1Z2dpbmcgY2FwYWJpbGl0aWVzLg0KPiAN
Cj4gDQo+IEZyb20gdGhlIHBhdGNoIGNvbW1pdCBtZXNzYWdlLCBpdCBpcyBubyBjbGVhciBob3cg
eW91IGNhbiB1c2UgdGhpcw0KPiBjaGFuZ2UgdG8gZ2V0IG1vcmUgaW5mb3IgYW5kIGRlYnVnLCBz
aW5jZSB0aGUgY29udGVudCBvZiB0aGUgZnRyYWNlDQo+IG91dHB1dCBpcyB0aGUgc2FtZSBhZnRl
ciB0aGlzIGNoYW5nZS4gQmVjYXVzZSB0aGUgZGV2aWNlIG5hbWUNCj4gKGRldl9uYW1lKSBpcyBz
dGlsbCBiZWluZyBwcmludGVkLCBidXQgbm93IGl0IGlzIGRlcml2ZWQgZHluYW1pY2FsbHkNCj4g
ZnJvbSBoYmEtPmRldiBpbnN0ZWFkIG9mIGJlaW5nIHN0b3JlZCBhcyBhIHN0cmluZyBpbiB0aGUg
dHJhY2UgZXZlbnQuDQo+IA0KPiBJIGFzc3VtZSB5b3UgbWVhbiB0byBsZXQgYnBmIGdldCBtb3Jl
IGluZm9ybWF0aW9uIGZyb20gaGJhOg0KPiANCj4gDQo+IHN0cnVzdCB1ZnMgaGJhICpoYmEgPSBj
dHgtPmhiYTsNCj4gDQo+IElmIG15IGFzc3VtcHRpb24gaXMgY29ycmVjdCwgdGhpcyBwdXJwb3Nl
IGFuZCBpbnRlbnQgc2hvdWxkIGJlDQo+IHByb21pbmVudGx5IGhpZ2hsaWdodGVkIGluIHBhdGNo
IGNvbW1pdCBtZXNzYWdlLg0KPiANCj4gDQo+IEtpbmQgcmVnYXJkcywNCj4gQmVhbg0KDQpIaSBC
ZWFuLA0KDQpUaGUgdXNlIG9mIEhCQSB2YXJpZXMgZGVwZW5kaW5nIG9uIHRoZSBkZWJ1Z2dpbmcg
bmVlZHMuDQpXaGVuIHRoZSB0cmFjZXBvaW50X3Byb2JlX3JlZ2lzdGVyIGlzIHVzZWQgdG8gcmVn
aXN0ZXIgYSANCmRlYnVnIGNhbGxiYWNrIGZ1bmN0aW9uLCB3ZSBjYW4gdXRpbGl6ZSB0aGUgcGFy
YW1ldGVycyBvZg0KdGhlIEhCQSBzdHJ1Y3R1cmUgbW9yZSBlZmZpY2llbnRseSB0byBvYnRhaW4g
dGhlIGRlYnVnIA0KaW5mb3JtYXRpb24gd2UgbmVlZC4NCg0KQXMgZm9yIHdoYXQgc3BlY2lmaWMg
ZGVidWcgaW5mb3JtYXRpb24gaXMgcmVxdWlyZWQsIA0KdGhhdCBkZXBlbmRzIG9uIHRoZSBpbmRp
dmlkdWFsIG5lZWRzLiBJdCBkZXBlbmRzIG9uIA0KaG93IHRoZSBkZWJ1Z2dlciB3YW50cyB0byB1
c2UgaXQsIHNvIHRoZSBtZXRob2Qgb2YgdXNlIA0KaXMgbm90IHNwZWNpZmljYWxseSBtZW50aW9u
ZWQgaW4gdGhlIGNvbW1pdCBtZXNzYWdlLiANCkhvd2V2ZXIsIGluIHN1bW1hcnksIGl0IGlzIGEg
cGF0Y2ggdGhhdCBlbmhhbmNlcyANCmRlYnVnZ2luZyBlZmZpY2llbmN5Lg0KDQpUaGFua3MuDQpQ
ZXRlcg0KDQoNCg==
