Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66E621ABB9
	for <linux-scsi@vger.kernel.org>; Mon, 22 Sep 2025 08:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758530368; cv=fail; b=FvnAswZosVLP+F3o6s7GTQwA9nd7XWJQV/YAIDkOq5Kmw8qJFpL7JAY3PFi3HL12xqEPnOQ59zOOMxxDm0as+Pi8uGxUBoGaVtUShxUtr+q0bq+lMKg95rzHUv+uGab6KrOiVWlX6jIx6oDA3TcYNn3cnMhoBzdzkq9cenepHLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758530368; c=relaxed/simple;
	bh=5cn0JF9jjAEt/riA8oy4UWqNugB9g85PTYjmL9Ya1DM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e3SwkbSwIHkei60DL47I+rQAfQt1prAv80yfCM6F4AHYXgtin4Lg/mCG/1MIKc3TuSmbRzrvqUl5rddIEuxks+HBUtlPWEkXcr2fyaHwRB1PHN/0/NZMlWxYmDd6m/lZw1a6Ps6uJofo4AKg+78hasSwBqIUbF0sV7nTXe32/lE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LicajlbY; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=CaQYiSXQ; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LicajlbY";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="CaQYiSXQ"
X-UUID: a282b8d6978f11f0b33aeb1e7f16c2b6-20250922
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=5cn0JF9jjAEt/riA8oy4UWqNugB9g85PTYjmL9Ya1DM=;
	b=LicajlbYDKXd1B6bKlKCVR6YpMFmntcRVioXXUFdtQkCxsNKKOX7fOXNV+mIYWh0DpMeDuKI3rqF1gBvNdP7XLaqt+CiSmwcWhCxFrqF3ge0+o053OcOzsOzocakbMGmOepw8LDyfV+vdB59Bq9Rk11iDDRHtlPrcCUaDlGfl+k=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:1e3f0f6a-2143-43f2-9422-07e4fcd1b488,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:6afccf6c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:n
	il,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC
	:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a282b8d6978f11f0b33aeb1e7f16c2b6-20250922
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 942610909; Mon, 22 Sep 2025 16:39:21 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 22 Sep 2025 16:39:18 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Mon, 22 Sep 2025 16:39:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rP2Xjhl+rQgaoIl2KeeDSxjYkuAL+GZBYxBDUMMK8aX68MdymeUWS4v18nTUqRyAy9p/UXx/O0+g3Udhc2YCEblh0VDrCxDxvoJK/TsF1V8mNkx7MJw3mVFQ8tMGdhkbBZZMw7J5nyFtK+fNhjKUGeMCJN4QXYeyl6BPnTQzY9qMz3RAX4VvxZ/Mu+gAYCNwlfa7zQadbjC6x6UE4HwwrNIvr8e1K/5A3YKdGruQQnrZvmIyhLfs0k7iT2kwkdT9MaBqTkIvLdFkSsj3GhpGU6rbcj6bD5FRbJCJI28nIEKMm/wCvNZQbmPb+0/aUrfJlW55OLPc8GQuL/K6PqCjZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5cn0JF9jjAEt/riA8oy4UWqNugB9g85PTYjmL9Ya1DM=;
 b=Rbnv1z30RLihjKEU78kWASi+H6oDVW4ekRHu3S/cXyEEA/5Dg7yWBRLDvODp3WQxPTbw+bhKtsCe/x1feLZbjV9hsC6jXiB5q0gs7eiATXI2P+kw/1cDK9Q7q0qhFu0JiWuG8JupxE6qfMROr8jfnxbpuELhbk74MSsM2mg73W3ueFTthCIgrrKg7rlvayZDJS0G2U/MC9RWwUCu4VxA6Q5vIRl3dbSqD2+yYystuXPGJbuAil33TBBQB0l6l2HdK7dTUR4djYDVgkcY4DhkqnygowT+VekicZvpWPLgsqPpGfWQF4gz69lhdp2Y7aqiQJvOS6s0Woo52gWQMeFdAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5cn0JF9jjAEt/riA8oy4UWqNugB9g85PTYjmL9Ya1DM=;
 b=CaQYiSXQ8zBSvmVFMEnceT/OIKrZrVeHq0/OAXkzF1y92iPquUamWwxbZr6yeGdEEiTbiB1VgRvAFXCfRTqX3mJgwtCBBr8LaUELZzKJtLQAA7/eGX/j3oc8MYJSpDypI4FXlcVGsO3oILNIF8IUJmhihQfmYyC0V8tMfWlAKBQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8327.apcprd03.prod.outlook.com (2603:1096:101:1a2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Mon, 22 Sep
 2025 08:39:16 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.015; Mon, 22 Sep 2025
 08:39:16 +0000
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
Subject: Re: [PATCH v1 02/10] ufs: host: mediatek: Correct clock scaling with
 PM QoS flow
Thread-Topic: [PATCH v1 02/10] ufs: host: mediatek: Correct clock scaling with
 PM QoS flow
Thread-Index: AQHcKIi68y1ScQQmRECt8lruVe3TV7SZQ3oAgADllQCAANdeAIAD50KA
Date: Mon, 22 Sep 2025 08:39:16 +0000
Message-ID: <c5ffcc850a222b23d1b0ba93c9f28521ff2fedf3.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-3-peter.wang@mediatek.com>
	 <02338932-b3e9-458a-ac24-41b4f29eb514@acm.org>
	 <21a451c752709cd9c1a3e18568c18f384bb77a05.camel@mediatek.com>
	 <ba381e9a-4cb5-45df-9fe0-3d370a84429d@acm.org>
In-Reply-To: <ba381e9a-4cb5-45df-9fe0-3d370a84429d@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8327:EE_
x-ms-office365-filtering-correlation-id: 6abc803a-07a1-4004-d57f-08ddf9b383e5
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QVZiR0hsYXJzWFl0dnNjNWlxc3VsT1JYSDdXMis4MmhQM1hZNzFpd0d5cDNB?=
 =?utf-8?B?U3RRdHlqbUpVdVI5NEpiMFRFb0xxMHZBQkpvZDJINDc0a3BJakJESVFiTzBU?=
 =?utf-8?B?REdremEzYWNHZzdDd3YraEZrbEpaaHdsMU5pS1AxdnY3Z2hGbHdteDRSOFBs?=
 =?utf-8?B?UUxuQzJsQUJKWFVuTTV4cVI4aDRlemtvTlB3NUsrWW1qR2d4dWNYcDNQQ0pk?=
 =?utf-8?B?WWhDRC9xYXMxcXFFN3JSTzYyMnhWQTFpNU5oMW9WMnNTUjIzVUdIVjhhWEd0?=
 =?utf-8?B?Vnk3VS8vM1NGNEpVcTNXL0FDS1hqLzFZN3pYWVZQNjl4Mk9BMTQxNmxXQkVn?=
 =?utf-8?B?c1FSN1UwZURRaUZLNk9lM0xvSlJhZzBkSWZ6TG9Tb3ptV3BQZC9aVlJ6SWxh?=
 =?utf-8?B?V1JWTzJWNUpQbkNZY3VtNndNeHZJa3Z4WTYyNm1nejN3VitvRTRZQnd0QjRP?=
 =?utf-8?B?clhWOFQyenZaaXF4MmJ4UXRwR3BrNjVBRFRCcUpoNTFTcE5yWHJVeFZhZEov?=
 =?utf-8?B?TmZHdXlvNEt2eHFONVp4d3lUd0VDb2d3UTlYN01vaHQwbDBXMkUvOHFoVXkr?=
 =?utf-8?B?bGlBSVZrajk0VHNzYncwU29uTFczSlYrWU1Lam5ZSkU0V2RUSzRsUStlbzR5?=
 =?utf-8?B?dGlRTWEyYnpaV0FvQjdZUlh0dDJVenk5d2FKNFBURDNkblp2WElMOGg5a1ZR?=
 =?utf-8?B?VTFrdnVIdEltMjd3S3ZJZU93c2tCNXduVlAvbmhQcFlZdks4ZWNvQ2hOZWZl?=
 =?utf-8?B?QTNYUDdBVXZhcksvbkJXS0JvR05EVFdzN21qNkhmbG9lT3FDaEYvQnhIZGZw?=
 =?utf-8?B?T2NnZU5BR2FQY3JnMjQwUC95SzJEWHNPNjJuU1FzbTFFb3lBOXExbndPUVo2?=
 =?utf-8?B?dG9seTQ5STgzSk5zWW1hMGJ5ZCtnSk5la3RHNmVJeFVMRUh3VHluRXZaNTdt?=
 =?utf-8?B?T1JaZDc0NERHaVFyZXVNUDNYRWdaUy90ZElaU2VMaHNOSnFEZzVYMHRFdGFC?=
 =?utf-8?B?aFJGVHhVSlZSa1k4Y0E5TjNtSkN2RS96VkRkS29BaDYyeUlDMUN4MG5odDln?=
 =?utf-8?B?SVFyTlFKY1FNMVVkbFZXajRuOE1VT2duQndwSjF4RVdLZHJUc3lFUFQrbjg5?=
 =?utf-8?B?VmFxSkIwTkIwb0hsVFhmOCtkb0ZtV1E4Qmx6ZEIzT1VCVDdxZmQvTjBmNnZZ?=
 =?utf-8?B?cUhxeERCTU1wK1RLWi9JbUZUMHlOaVpEaGMvWmdmc1lVMkJkdi9nRVdqV3Y2?=
 =?utf-8?B?Umx5RHNybFlNWWMwSFoyNFJmUnNQc1hoeFI4STd0WEtkRWtuWW5WYjBFVHYy?=
 =?utf-8?B?TXlUZE1UcWdSZWFFbVVlaHJDQWVkK1ZiV2JqWEVJSXZLWDRxNDNkVGJVV2lO?=
 =?utf-8?B?ZDcyeGRseXdRWkZ3THowMHF6aXBJZkZsZTFzTmxJalBkN2k0Qiszekp2ellj?=
 =?utf-8?B?UzRGMElXeTBjRmltUitOU09KNVlSM1RXZS9ucGVlL2NrZ09jcnpwMis2YWJw?=
 =?utf-8?B?Ui9vNDN2QjQyT3dUZjk4Rk16UVYrMWdpVFlMNlp6bVFUMVpKNFVCVEJmT1Fv?=
 =?utf-8?B?R05KakkxdnlLN21qeTdESEVDZWhSbUpXZk5qV2lZZUxFbHZhR0ZXZktZOVRr?=
 =?utf-8?B?ajJmOHdNQlhpNks5TGdRVE1YeGRXOWxCMXZnRHZpM0ppQjFDR21NZFBJZkpB?=
 =?utf-8?B?VWJNTUJSK1hkZG1MT1FTb2FMOU92NTdqeDc0aklRTlg3cXhna2ptZHNDTXZn?=
 =?utf-8?B?TUROZUNONklqeWVaU3cycjZsVnF4YmJRblFucjRyUFI5T0lDdjRlMElLeVhy?=
 =?utf-8?B?c3p2Nks1djN5cXN2WW5MUEUvaCt2dWtxanFMYmU0RURhbmxyMXllQTgweHdZ?=
 =?utf-8?B?SE5QNnpxYmdmWUlEcCtSQnBCUlpiNi9hbkZudkQ4aVJhOFQydlBIRm9Xa0lp?=
 =?utf-8?Q?fpy1nC16EeA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3BnVm9PckhlZzh0dWtRWFB4S3VudGVIWWMvazhQbjNnQTQwKzVMbUdmbGwx?=
 =?utf-8?B?eWVSL29helJWem50TkRmQlhVZnFIS0taRVkzS09ScUFJY0xNczRqcWlVUG56?=
 =?utf-8?B?UWd5cEozZ2U0TVQ2eC9PQmZEazduTk9OSXp0MkZ4cHFSS0hBNVBjdFRNSzlQ?=
 =?utf-8?B?dW1ZWWhvNjlXbmFuWEY4V3phTVl6RzlsblkxWmVNZmI3K3ZwUTdmZXFtWFE5?=
 =?utf-8?B?dEVNUXBuWHpMbmQzQ0xkM2N6WUllUGlWUlpEdW9GM2RaNXQzWC9MamhpWUVJ?=
 =?utf-8?B?aWtnYjA4bVlFL2h1ZFgxU2pHdVdteGdtNDZJdFJxMklGbjE3a1VVWWlIeEcy?=
 =?utf-8?B?MCtMVnJROTNrRUw2U2F5UGE3M05MN1ZmUTFKS2tTZlQwMGM0ZW9EdlZkS0Y5?=
 =?utf-8?B?eVFlY3ZLSE5aSmNuNmc5a1VaTnJodU8xRnh1cURJRUdjM0ltK1hORkY5cHp3?=
 =?utf-8?B?M0RSZC96QTE1THA4K1VIU3ZGOXVOK3lXREZveXcySkU1TkNnUDRhWktNRzVV?=
 =?utf-8?B?bFNicU40dm93UVpPY3R0ZDhYYzNRcnNZa0RlRnJ0Rld2WWJWbTN0NXZGTjB4?=
 =?utf-8?B?NTl2ZXhZUllmV3h3MUloeUVJVFA0Q1dwa0pqZjZ6c3l3RCsydXRKR1NKSis5?=
 =?utf-8?B?MVh4VE1ON25Ta0ora1VFTktnRnB4aU5rZmxnTVRUSVZGRUM5aWpFSlh4Yngr?=
 =?utf-8?B?b3NKT3ZiZlk3ejNrV2p1NHh1UVkyallXZjJmZjVYcGpyaUFOWThYSFhSU0Rp?=
 =?utf-8?B?MXk1WmJLdTNJYkJUdFp2STMrVW1aRmxjam1oSWVwYjkvSyt0ZXFmNlJzcGFT?=
 =?utf-8?B?SWpRR0pCQVpmRjFuNitNMzNIc25MWkxjbmhBTkM5TzY0bXFDbm5uemkyZDIv?=
 =?utf-8?B?WCszMloyMDUwQk1aTzZCbmhMVzRoYTQycU5KakZKY3NqQU9MUzc0cncwRG85?=
 =?utf-8?B?SzlJdEMzWEZtNmpZODVuZDhBRHdGOStER0JsclpyNFRmS1RKckxlVVJBQXNQ?=
 =?utf-8?B?VVQyTkRNa2xUY0l4T1owTHR1dnNmbVVFRWl5c1VaL2E0M2hEd3ZOSVh4elht?=
 =?utf-8?B?T3ZaanJnWi9ZR2hnRjUwdUMxZTNkLzJpVG9WK3pJajRGcmdObUFzcjErdkdB?=
 =?utf-8?B?b29jRUJkQWEvRlNjL1NseDhFcWpjUStqd0JXTkw4dVJjdkFFZjhEU0FBUVdM?=
 =?utf-8?B?THZ0VDlreUFDUFh0Zmw4WDJ3a0NQdzZhb3NaOG5YcHBBSzN2UDVkYXFoMXo5?=
 =?utf-8?B?V2lCS1FlVzRRb1Vhb2RySk1nek1FMjlrZGViRi90aEcwM2lOMWlPWFpTYUtu?=
 =?utf-8?B?RnVQbTdXaGZFZ0E3YjFiVU1EVWEwdm1qa0NHZnRaNDBBOTRGSWZKUEJvRTQx?=
 =?utf-8?B?Q0VmSEhXd1B1VGc5ZEpSQkQ1WGFuY1ExUFZBL3RNUWhVb09WVEYyaGZpeGJV?=
 =?utf-8?B?Qm5ZRnhicHMwNTc0SW4ybDB3V2hJaW5jcUJ6MVlBVjZWNUxoR0M2Y3R3blpJ?=
 =?utf-8?B?WUd4Rk4wd3JIUWltTUhHekk4ZWlSem9nd1diTmFsbW1hQ0NvSHUxd05Oekx0?=
 =?utf-8?B?ZFVEUVFQNG1qaDFOdnZJZWZ2SEdnN1VYQUdDSnBaeG55UTdPNWpCU2RnTUFJ?=
 =?utf-8?B?ZjRNWGp1RUZGS05RcS82UkluVTUwSU8wNXFxcmRreEpmOUZ6aEIzL1FXZjdj?=
 =?utf-8?B?VDlEYVJQczNxeEtBRm4wSlIydXR0RTdhNzcwSFhWbzc3VFA0WDdpWi9QU0tz?=
 =?utf-8?B?WWVyNjA0YTZMQVN4a2xjL20vQ3Y4dWRpVkNPbUN2SzEvRDg2V1dLZ2JqOG14?=
 =?utf-8?B?RGFhOXRKL1JDbG9oeVp6dDAvM3h2dFhsa0l1OW5tdHdkbG1RKzdKcE1ZSlVM?=
 =?utf-8?B?V1BRdDUzQWF0bjF2bm8wek51OUpzNWtmZUhockVRcy93dmJBOUQyRkwreFVY?=
 =?utf-8?B?YzgvdGpEcGs1T0pWNnkzb2NUd2c0bDlqbUZQMm1jbDlGK2gzc2U4UmduN0hz?=
 =?utf-8?B?RzdWNDRmNHZldndZbVlMOURMbytRNDdjd0pkVUJIRDNpak91WndZc09saktr?=
 =?utf-8?B?UDFVMWFOMHZDdjJuMVhMWForaExRakgrRGVuME52eUdTNFpBcGRvZW5WZHRM?=
 =?utf-8?B?dHR5UFBKT3JNUFJSTlY4U0wrL2Q1VGExQXVUb1FpQzhHcU94ODlndGQvb2px?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <827FF63137E9934CAE549458A3D63249@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abc803a-07a1-4004-d57f-08ddf9b383e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2025 08:39:16.3628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fqHk/F935aDICHu2Qo7Gx+4qjea+MGcmLdL0T8FCUZ0KxkIHn4yJ1ETYwQx1LaredcDIvoT8VVMqe0Z5ow6/EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8327

T24gRnJpLCAyMDI1LTA5LTE5IGF0IDE0OjAyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBIbW0gLi4uIGl0IGlzIG5vdCBjbGVhciB0byBtZSB3aHkgdGhpcyBjaGFuZ2UgaXMg
c3BlY2lmaWMgdG8gTWVkaWFUZWsNCj4gaG9zdCBjb250cm9sbGVycy4gUGxlYXNlIG1vdmUgdGhl
IGNvZGUgY2hhbmdlcyBpbiB0aGlzIHBhdGNoIGZyb20gdGhlDQo+IE1lZGlhVGVrIGRyaXZlciBp
bnRvIHRoZSBVRlNIQ0kgZHJpdmVyIGNvcmUuDQo+IA0KPiBBZGRpdGlvbmFsbHksIHdoeSBpcyB0
aGlzIGNoYW5nZSBuZWNlc3Nhcnk/IFN1c3BlbmQgYW5kIHJlc3VtZSBzaG91bGQNCj4gaGFwcGVu
IHF1aWNrbHkuIERvZXMgcmVtb3ZpbmcgQ1BVIGxhdGVuY3kgUW9TIHJlcXVlc3RzIGR1cmluZyBz
dXNwZW5kDQo+IGFuZCByZXN1bWUgcmVhbGx5IHNhdmUgcG93ZXI/IEhhcyB0aGUgcG93ZXIgaW1w
YWN0IG9mIHRoaXMgcGF0Y2ggYmVlbg0KPiBtZWFzdXJlZD8NCj4gDQo+IFRoYW5rcywNCj4gDQo+
IEJhcnQuDQoNCg0KSGkgQmFydCwNCg0KTm8sIGl0IGRvZXMgbm90IGFmZmVjdCBwb3dlciwgaXQg
YWZmZWN0cyBwZXJmb3JtYW5jZSBhZnRlciByZXN1bWUuDQpBZnRlciBzdXNwZW5kLCB0aGUgVUZT
IGNvcmUgYWx3YXlzIHJlbGVhc2VzIHBtX3Fvcywgc28gcG93ZXIgaXMgbm90IGENCmNvbmNlcm4u
DQpodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC92Ni4xNi44L3NvdXJjZS9kcml2ZXJz
L3Vmcy9jb3JlL3Vmc2hjZC5jI0wxMDE2OQ0KDQpIb3dldmVyLCBhZnRlciByZXN1bWUsIHBtX3Fv
cyBpcyBub3QgcmUtYWNxdWlyZWQgaWYgaXQgd2FzIHJlbGVhc2VkDQpkdXJpbmcgdGhlIHByZXZp
b3VzIHN1c3BlbmQuIFRoZXJlZm9yZSwgaWYgd2Ugc2V0IHRoZSBnZWFyIHRvIGEgaGlnaCANCnZh
bHVlIGZvciBwZXJmb3JtYW5jZSwgdGhpcyBjb3VsZCBiZSBpbXBhY3RlZC4gQnV0IGluIHRoZSBV
RlMgY29yZSwNCnRoZSBnZWFyIHNob3VsZCBiZSBzZXQgdG8gbG93IGR1cmluZyBzdXNwZW5kLCBz
byB0aGVyZSBpcyBubyBuZWVkIHRvIA0KcmUtYWNxdWlyZSBwbV9xb3MgYWZ0ZXIgcmVzdW1lLg0K
DQpUaGFuc2suDQpQZXRlcg0KDQo=
