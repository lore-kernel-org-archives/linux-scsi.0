Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F6E2EA721
	for <linux-scsi@vger.kernel.org>; Fri, 19 Sep 2025 08:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758269867; cv=fail; b=nwRiB/fXmk3nH8DiQsloYCQaLW3j8pMRpKhsfzOILpZBaJ3tE+vr2IZQxJYd5G68Pc8N2Nzfs0O0zP+23+81c4L5lReSxwi5SKaAPB8BZGxKSHdQGhF8AKOy3YmnrnXWWUVtDdmZyObLghk+T9X4dHQAFtkqi7EQ9B0mxHdQv4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758269867; c=relaxed/simple;
	bh=o53LP4+Q1HbfpbgGNXrw32M1tqTaisO19m9asyogE2s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YaOszmOj+MObKjmSVrmixA9cYam5oP2XuLAuYkviK/BGhhXQpmP5VjxW4ymy6qCrtA62tyUmvfszNhk1JEj1/IjaCyvMsGHlDb1ZJqhaFDanLEDu9n5+HdQayTGavZ2lZd1dlMzxl2BTkToYlUAmSPyv41wfrx4WwJHBn3bTuyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IvbkdOEd; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=i68q/Uvs; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IvbkdOEd";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="i68q/Uvs"
X-UUID: 1ca35014953111f08d9e1119e76e3a28-20250919
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=o53LP4+Q1HbfpbgGNXrw32M1tqTaisO19m9asyogE2s=;
	b=IvbkdOEdrg0Z8R5NNzm5pUGtOP3gj/U/kdGhi8yXiRKuoZIreOKcRxZxrgcWUKSw5+hZiKc4Q/kMK2Dir1U90SVvneLSA2JX/6+YV3fUKMQJjaZvRiuERhcycpiiqjF4F1iQvEzbs+j212Jf3QrZMHmSlyRTAgi2IXr/APcLn6s=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:cf941071-be5c-4d8a-9652-0c1c473fd17b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:3dc479f8-ebfe-43c9-88c9-80cb93f22ca4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888,TC:-
	5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1ca35014953111f08d9e1119e76e3a28-20250919
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1560251924; Fri, 19 Sep 2025 16:17:41 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 19 Sep 2025 16:17:40 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 19 Sep 2025 16:17:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UE2k1/hrTMUufYCTNU8eCjGVnBug0+Cc23CwjNoxKr+PkhwIZ8oK0smhgK+t9xoQ3NyNnaTr4b8hKLTbGQE66oNQjPzT4cwYouxS8wE6bzUh/ELHJW9a0gG2HWyIOCWJmt54+Ovav3PZTjpHBAgWhkEf30TqwXSjGyJN4DOLCtWcE27MNVZFP6+5sd3lG1uqIwhCK4H/oSe8e3pgchIZv3vMTpMlIz6Vt+2yLpjCgKG5thkZAPpyfxkU1g/Wiy8RNFio+vAhDNpAG7pEtewVViD+1kJtDa19kYzoCNAo+UgCg0Vi5QKFjg+6WKUpZaF7RvygUzOfbwRPvlbs9aZBjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o53LP4+Q1HbfpbgGNXrw32M1tqTaisO19m9asyogE2s=;
 b=RhDQ7Rv5TFFwoWdU4cDJbXWjKJEPYZKHCL/oANmHCWZIpe9OahvxNcUNi6Lg51Q6QGgxw7GYFn/82jTYca9sNZeGlf3PS7Cs8Pw00xOr5nynW/Gt+OlS+T4iLtEBglKxHuwSLyzFQ+Cwj5SjijtJTcjwOTGPzZjDssIrI3yoD54kXzwjiCwFBRZGJsjaDDSl34SHi24kwbnVQywJft+oYbL5IEXLFiJd1LG/NYIekkuZg01oTWiNQyOiwUM9f2S9R9suX5A5r9KbWw1Q733GkPnvWWAY/6zJT2+YCGa5gqsnNdwRLXhbb75VZFGp5lwuG2U0RSerEk4bd02GUBdoLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o53LP4+Q1HbfpbgGNXrw32M1tqTaisO19m9asyogE2s=;
 b=i68q/UvseI/oAczNwGcoH1SVCUxZP9PTFrfNcLKuxqoRKYUf1P3My7B5n5jhGrzwLJj5vef6b//TvorGEnXP11zqRrN1AXOmRlAtqd9wJrOsQx57N6IhpM8FOZ91yttUysGeR2cf4oGf6AiGwpGbuxsXyjoPPWUfXQz/KT3Teg4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7389.apcprd03.prod.outlook.com (2603:1096:820:eb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Fri, 19 Sep
 2025 08:17:36 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 08:17:36 +0000
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
Subject: Re: [PATCH v1 10/10] ufs: host: mediatek: Support new feature for
 MT6991
Thread-Topic: [PATCH v1 10/10] ufs: host: mediatek: Support new feature for
 MT6991
Thread-Index: AQHcKIi5SmVLY4+VRECqlpneXEt2SLSZVNiAgADVy4A=
Date: Fri, 19 Sep 2025 08:17:36 +0000
Message-ID: <a4469094c79fb0305e558221dbe62108c761982a.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-11-peter.wang@mediatek.com>
	 <7a51c923-d311-46c4-b9db-5df807a091f2@acm.org>
In-Reply-To: <7a51c923-d311-46c4-b9db-5df807a091f2@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7389:EE_
x-ms-office365-filtering-correlation-id: 24f56105-1ea3-483f-751f-08ddf754fdb4
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NGdDamhqb1dWVEhvY2ZOYVJuajF5cTg0WE1PTmVsY1FVcHhyMkZvVTdvbzlC?=
 =?utf-8?B?Ukk2dzkyVUJmUC9DZ2dwbHI2ZFlaQndESCtnZVhvaTFFM28vSU5DdEVxMWp2?=
 =?utf-8?B?YTVCcXBWdUg5L21lV3NNMm9yUGtHK1gwcVFMT3hSM0hxN3VXTzlGWGxvV2xE?=
 =?utf-8?B?enNOc3g0TDJSNHpkd2VjOFMwSWdIcDFFdWI1THZhTGM4eHBOeWFFZVFqQVhi?=
 =?utf-8?B?azdCRzZKM05YUXRJdllBQmRnblJITjVJNnl0MUN3OXlhMm0xSG1nMXV6eHky?=
 =?utf-8?B?OGhLMlJJbzNkZTZxTURRL0ZsOTBlbVJaNHNnM0h2WkhMQXFlem9wZVVwRHAz?=
 =?utf-8?B?S3N5OGFWQk5UdE9qdUlKSGo5QlpNUTBJM1ovZThjUnJ5MUxmNEd3WUI4Y3hn?=
 =?utf-8?B?MnVsWjFzTHAvS3FKNVRPT1NDbGZBSW44RUgxZGFLS1JpMlNxdDJhWXgvTzdM?=
 =?utf-8?B?K3NOdCt4ZUM2ZUdkSlpwRTRONkI2UEVmc2E1WjdwSUpLNUdVWGZTWlBJUjNH?=
 =?utf-8?B?UnVqYWRrRFR4ajNoR1pWUXdnOFJ4RlZXdnFHeWg0RjRwWmJNSSt0elQwaE0w?=
 =?utf-8?B?eERXeURNZzJRYkZseWxkQVJOazUvcEo0RHYzMkROUW1kOHBNWnlaSG5sSFl2?=
 =?utf-8?B?RllmODQycTV3UTdUWkh1eVRJWUViWnVFK2ZrWkZINFhBenFQaVcvdDV3ZzVt?=
 =?utf-8?B?Z1ovblE5MGkwK2V2SEFoU05Fbm5mT0owbml3V0F2b3R0SDZueUZ2RVhQTitO?=
 =?utf-8?B?NmtPUnJYUkZSZWZ3RWRBYVhIa2tGUDk5ZVMxeUZDVHliU1R1Y09kWnVWQ3JU?=
 =?utf-8?B?bzFlWjB0eUhaQ2ZFQ1VWYWw3bmtITU1jT1RKZ0R0WUpwc1doYkkxU3ZMMVRr?=
 =?utf-8?B?bExWYTVsUlUxQTVOdEpxUGhZSVRjeTYyeXJ0czZjdVRsZmNOb2JUM2lVUGZw?=
 =?utf-8?B?UkthNEwwc2k1c1ZIUFNjUExiV0RkSFptZ2VhZ3l2UkFkc09lWGd6eTR2WWRM?=
 =?utf-8?B?NWdmbmROMTBGd1FXdVJVOFBOb2UvVW1XeGJrN2FqWDNyVlA0WFlxSGdEc3Zy?=
 =?utf-8?B?TlhNTUkzMlgzaWpzZkY0d21JMVN6VTVwUHhqSmpGYjdqRU8zWWh6R1UwUUxj?=
 =?utf-8?B?eGpzN01DRExTKzFUc09uVDRXMVQ1aWp0NnFZUW9vOTEvMmd4YXVyMHpibVJB?=
 =?utf-8?B?MTFsUzl6blY1QU1sM2xoQmpaQVFSL2poR1NPdHZrSm5nSEpISmw4ZWJreUlr?=
 =?utf-8?B?NFlDRnNTSnlmbUJ0U0ZhKzY3MVN6NGFGbTAyV0VKYXdsNkZ6em1CNldhOTFx?=
 =?utf-8?B?cFRTVEw2dmRZZ0tuNUFIRVB5bTBNYWU2NGlyMExXaEpWQ0psYzVOSTF3ait2?=
 =?utf-8?B?WmM0WC9KSVV2cUxxZDc1MG5Tb3IveUU5QXR1M1N4RHFYT1VsK0NzYThmcHB3?=
 =?utf-8?B?WEJ5MGk5UGYrVkEvQlZDNUY1eklrcEZQN3Z4VFgwTk42M2g2c2oreS9PaDFI?=
 =?utf-8?B?NXVBdnA1Wmt2cVM1UTdoQ0gxRzJEZS9OOWd5ZG9kNHJCVUVxK3FBd0k4L3RM?=
 =?utf-8?B?ejNya2tHRUxiU043OXFmMURSWTlVT2dRNkJMWDNkRmxHTXJkUHZINDJxeFJE?=
 =?utf-8?B?bUk2aTRZdW5aejZBbERxSVVzdUFxRlNrMW50UXIza1gweXNzajgwK1c5MW10?=
 =?utf-8?B?R3NBdUhKdmRCaGVvdG05NzIvU1lVNTAxUlJ5QzBQa3ZVaTJMU3JHNFBqcDdp?=
 =?utf-8?B?S3RVZ2JiMlBhTDBZUkFBdjY3d2R6VFNVUFZDYTZUVVpsWDlZVlhrNFdvOTQv?=
 =?utf-8?B?dXUzQkF2SGRPdTk0RENJdm1yODB1Q0VHMVRVZUUzQjIxdWRzaGZXRSt3dm1O?=
 =?utf-8?B?VkY0VnN6cVM0Z3Z3dTZ4czRnRlJ6c1VFSDJSbnNWMGR0cGpjV0xqbVphOUhZ?=
 =?utf-8?B?em1mOVE0QVdneE1seDI3MnY2K0l5cjBsQUw4UlRSNjcwK3h1dUp2ZklFeHZN?=
 =?utf-8?B?RnBTWFNCSi9BPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bE5ETmIyREQwQUgrYUVwVmlVRzBPVW4zV2d6aDlKNW8rT3RneEVUV1Vuemll?=
 =?utf-8?B?eWdCZENNRm9uZEtFTGQzK0NyT2JwRnhsMlo1ZVRYNzBzYmo4QXFic3FwcHhL?=
 =?utf-8?B?Q0ZVV0Fwb25yMnRLMHRtTXZTSWl5VVBTZ1hmSkd4dERWWlFzN0hLcVFZMm5o?=
 =?utf-8?B?VmFnR2RLMjBzL01CQ1ZPR2paUXY5N1VqaElxMGZuZVppckRUQURaa01lYTJq?=
 =?utf-8?B?VEhnZUhuS2VuY2lHaFlDVHJaZUpzS2lLR1dkdHFRRE1UeHkyMjFyRkhlNXhC?=
 =?utf-8?B?eE5GOHM4aTJYQ3JwcXcvcEVxNjZSK2dLYXp4STBqRUZENXRSODE0VTFjMjgx?=
 =?utf-8?B?MnRPUUtVYnN6L0dvUFUyTm83NkNRRGVBRlE3akw5R3ZIamh2ZkRSMnB3UzdJ?=
 =?utf-8?B?NnJZQk5WakwwcmZjOUE5d2Q1QVdEa0JDNUJIcEdBZDVjbDBEcnQ1L0JmWWxU?=
 =?utf-8?B?M0NMTGZHNktLUDJXc0wzM0lKejBKcVlGamhxL3hJY1ZkY2V3cVNVREFWV3Bz?=
 =?utf-8?B?K0ZQYVorTjNYeDZWUjRjRFJlOUZYTmJaWmpWYkJSTVRLMXo3TE1NREpSNVNS?=
 =?utf-8?B?V1hoV2RzRlA3YnJ5aEI1OVdEaGhnMFhmUnVJYi9kbGtKeTlUeTRkOUxrenNM?=
 =?utf-8?B?R3p4NEFkL0NxZXZ2Y0NYRlI5VTJCVituMzFzZnFrSFFKODM4emhySkt0bUZS?=
 =?utf-8?B?a3YwanRYR1JaaDdubHBMcm40Y2xTQUgyVWhyTk84S3pid3VHdlR3Zk1valln?=
 =?utf-8?B?djhvQ2V3WFpKblQvYk0ybWErSnZIRWRva0JyUnRoa2FWODFzdnc4SDU3UkZ6?=
 =?utf-8?B?TDJwSDRhbGdUZ3Q3OWloS0dhWW1QYUU3QTIvV0RIM001TW9ZZEtmdFJJVHA0?=
 =?utf-8?B?SXh3QzNSRllTVlJHT3R0WHFkTVZUWDBOS3pGOEcyTjNvK0dYQytxenNVOTNT?=
 =?utf-8?B?ZmtwNkpPZG1DUlBtT3VER0xpYUs2MWVUM3EwUFFLZlpBdmxMOWlqQTYrcHor?=
 =?utf-8?B?TDRRM1JDUkQweWtNNWVJRHZLWVk5K3FSSTF4MzNYbEQ3dUYzZ3Z1V2pGejNa?=
 =?utf-8?B?bmpURkVyaE54N3ZvN2pDRExDRURPSlBVcDF5Y3NORldzc1FROGtUNW1wSklq?=
 =?utf-8?B?RjFVT25NMkhRMjUra3YyekhPY21GWE0yeHMrTkFYL21zWnB5N3lYUmNBbjdM?=
 =?utf-8?B?QW5TRk1DNzMvVTV5TDZHUTM2ZFIvVlV5WjZ6MUwvZEdEdDIrVjhLbUYwUno3?=
 =?utf-8?B?RVhyZGdvdlJPdW56QmtPdXhZOVFUQkgwNisxL1EyRU9ZQUlGOWtLcUlzNUEv?=
 =?utf-8?B?aEhBbjZybUdYa3g1Mkt1NTNEOHJYTmNhMmZHS0pOcHZ3TmpZeHcwVjVEbjVH?=
 =?utf-8?B?ZHAzb3lQRFU3eVdYUVJDdXlMblZsQTRzbFIvRFZXdlE1akFpa1dWSmlsRS9B?=
 =?utf-8?B?MVM2aWdtWHpINW91V084NlhwQkp0bkhYZlhqT1BRWklhYkx1b0ltaTlCRFVj?=
 =?utf-8?B?SGc2Nnk5ODdaUGs0Q1B2V2IrdzJsalRnSDd1bHpHTFBNOFhkV2FaeXZrQlEr?=
 =?utf-8?B?RFNDVlBnK0VOOHBQdEczOTAzTE1KRTg0SXExY3BGT1Z5MDNpYXFFN1NNVGNO?=
 =?utf-8?B?Sk03REtoWi93Q203Mi80NzlCdFhjbXZzdjFJSy9wcGp2ZHVzZHN5eEdHY2tP?=
 =?utf-8?B?ZzhjVXhPcm51WCt0RTFxcW9jVVlsaXREK1VFWjIxMEk1dlE1dG9RVE9GUUdF?=
 =?utf-8?B?M0VSYzlBd0VaTGNLckNMQ3RSbnVWNGZyMDRJRlJMRkUwd0xyckhTcnZLcGRh?=
 =?utf-8?B?eklxTDJQNDlCR2Nrd1Bqa1ZTZERLeFNxNUxnQ1VVczFsa1Z6RUJIM1JxWkha?=
 =?utf-8?B?RkJHTjA2STVhMGVlQlZobUxyZnZDQnlndjREY3k2ZkhYS0pHZkdqaXFER0JG?=
 =?utf-8?B?eVY2Z0ZXNnR3S3JEREZnVCt2TXMrdTJsSEU0QmhZOFJ2NEVkUFUzWmhxZ2NN?=
 =?utf-8?B?dDZDMzlJbEI5dWE1ZjIyZFV4Rms2RC9mT0FJQVMydFlXMDFCckVmSURiK1Fm?=
 =?utf-8?B?RGhrZGsxREJsV05VNzU4bWg4d0U0Zk5VMWhaYWJPZ0gxbE56aVJ2bGRDMjFG?=
 =?utf-8?B?OUlCWjhmZFF6eExjODVUSzV5QzJzQzlZV1V4MHE3UkdMVnZiL0d1UmxIRHZS?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F719E13A4726B4BA65F12EA66CBD2D0@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24f56105-1ea3-483f-751f-08ddf754fdb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 08:17:36.2226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /UvhDrAvHcQLVwjkv1tUT76dl5uO4lv9iakP247hvZpH+VmozxUdhD7FX8CLd8PjYcGtfOtOKuucePPIndKrAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7389

T24gVGh1LCAyMDI1LTA5LTE4IGF0IDEyOjMyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDkvMTgvMjUgMzozNiBBTSwgcGV0ZXIud2FuZ0BtZWRpYXRlay5jb23CoHdyb3RlOg0K
PiA+IEVuYWJsZSByYW5kb20gcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQgZmVhdHVyZXMgdG8gYm9v
c3QNCj4gPiBvdmVyYWxsIHN5c3RlbSByZXNwb25zaXZlbmVzcy4NCj4gDQo+IEkgdGhpbmsgdGhh
dCB5b3UgbWVhbnQgInJhbmRvbSBJL08gcGVyZm9ybWFuY2UgaW1wcm92ZW1lbnQiIGluc3RlYWQN
Cj4gb2YgInJhbmRvbSBwZXJmb3JtYW5jZSBpbXByb3ZlbWVudCIuDQo+IA0KPiBUaGFua3MsDQo+
IA0KPiBCYXJ0Lg0KDQoNCkhpIEJhcnQsDQoNClllcywgeW91IGFyZSBjb3JyZWN0LiBTb3JyeSwg
c2luY2UgdGhpcyBpcyBhIHN0b3JhZ2UgcGF0Y2gsDQpJIG9mdGVuIG9taXQgIklPIiBpbiBjYXN1
YWwgY29udmVyc2F0aW9uLg0KSSB3aWxsIGNvcnJlY3QgaXQgaW4gdGhlIG5leHQgdmVyc2lvbi4N
Cg0KDQpUaGFua3MuDQpQZXRlcg0KDQo=
