Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0A879DE
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470123; cv=fail; b=cQAqeL/knrBZ5N0+x/y/dDcBvj2Fxo1flLfR3WFV/yutTCR4MQwBHlWjzwNZkyCB+ZA4mtKAYySc0nN9oxEESB+cZ52O6/aW4GzhlsrgPBZbLiM73+IhdzF8g7P7uu13aleNNbsBNK7RZ9BMJIOj1tJ9vzmHPpWVCNdkZl8r6d0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470123; c=relaxed/simple;
	bh=72UmpMeXsww5sziSlgBgjZ9gGgzExGaQmcfdjP91/hA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ef2TTfZeCHq9IkO76xAXOi5fiLfYBO1Stb11L1Is+4K3B1VbXAuA9ibPiscPzgCoS08bEoLMQRbaXEtkM4/+Y78D0vbLHH7Au69cV8iOngj5Owgx10yszk8rBSbadUGctJyUV4O2HnBEmmiWgwbT1tYmz0je/NQjKH8+1lhZdNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=RzWwdNIq; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=TlDsQyOQ; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="RzWwdNIq";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="TlDsQyOQ"
X-UUID: a7619d8ae27411eeb8927bc1f75efef4-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=72UmpMeXsww5sziSlgBgjZ9gGgzExGaQmcfdjP91/hA=;
	b=RzWwdNIqnHBPNaHk7o+8QuOQNvTUl1NJcxzN7TCRo/on8dAfs9pMJkFxZz8Axdu2gaJ4n8hPMHBWi6AWuzvegxMXC+Y3gICbgyFF3nckpKY0fJMvkNUPWwPBiRUB8zeBh8RN0xGgtfUmX6ScRrS0fPhJxDmmyfqyRlRsJKreGs0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:8ab7480e-caf9-4a88-8854-f471d8c0fde1,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:2de56c90-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: a7619d8ae27411eeb8927bc1f75efef4-20240315
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <chun-hung.wu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 411418623; Fri, 15 Mar 2024 10:35:14 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 10:35:13 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 10:35:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGjSNacksVJX77K3kMUHmVmlLoJl45UadutVlm3GKCLE3fsumeBWvo4xNLeWj0+HX641HA57g8UOrrkdqZ78+Pb8+A2ccDJTHJ/SQk+vJwEKs8C8g1cx2KQlNQBSTtXUOjcgXx6VRorQDzW6skmdaT6ZxsTftPeT6V4+asQhK15RsrpFGaZCZ3piyiILVpfDcKVwdT58f1nRlqP7SbhAtwUwPFFjZ7JvKuLU/4LVGk5xt0c+h94Vo9zaGWhODOmY6OqWPF/nv0DpiD4bBUrPs3chg2cDtnE4PELChXRhnUpm08RLn9bfiXdUAanoPxIHpKgX8/QxVkAZAcAztC8Jbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=72UmpMeXsww5sziSlgBgjZ9gGgzExGaQmcfdjP91/hA=;
 b=hSq45xRpGcVILJ/hj+dviWRU9HCgPIndqlxvs6fL5Jl+94Whtxif9NQEdXN33wot/Ypkgnc0WEkjH75z8yObXbRp7bt98WWb8LYfLeCsCbLODiT5ZYkU0N4nLEaNVjEkX1dGSep8WPbUxoCkSiwU+9c0xW7a49Ly4xqR7KUuD5DKLH5Lu+vE1M+Y4XaTX8gw1eeiIEA6FU969gvzgPk5lvb/Fxij1bl84UcGsUm6B4tpwcy546FyEUYncbTtO4sdsm1IzgxOgCwOFuk8B92Hi0uCbIofonuHUTClGZKUDoHSsOB07ESVSViQynENA0DuiZrLBxaeuWKPqUOoN2GWoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=72UmpMeXsww5sziSlgBgjZ9gGgzExGaQmcfdjP91/hA=;
 b=TlDsQyOQxSqbsw3bBH46sb/ibiZaE0o9v+hTijmKcu766QimkOu3OdlMfHh/ANhu51DlUV3aVhzNVys6wSWnbhLxb5786FRUuajSMmd2BfWYJGYWoyjMd3pQ4kv8xGc7o1E+bEduMcoNE6blcJxOMQHC8ZuVdcotQRKQ3t4DBXM=
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com (2603:1096:400:413::14)
 by TYSPR03MB8849.apcprd03.prod.outlook.com (2603:1096:405:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Fri, 15 Mar
 2024 02:35:11 +0000
Received: from TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c]) by TYSPR03MB7350.apcprd03.prod.outlook.com
 ([fe80::913f:a95a:231e:cd2c%3]) with mapi id 15.20.7386.020; Fri, 15 Mar 2024
 02:35:11 +0000
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
Subject: Re: [PATCH v1 2/7] ufs: host: mediatek: tx skew fix
Thread-Topic: [PATCH v1 2/7] ufs: host: mediatek: tx skew fix
Thread-Index: AQHacSa77qbip6e25Einr7+NNzCx6bE4IH8A
Date: Fri, 15 Mar 2024 02:35:11 +0000
Message-ID: <85d8d71a7a7b0d2eb16fcdee691954ce26c3418a.camel@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
	 <20240308070241.9163-3-peter.wang@mediatek.com>
In-Reply-To: <20240308070241.9163-3-peter.wang@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYSPR03MB7350:EE_|TYSPR03MB8849:EE_
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wo9Pp0FcS+RE5Ccf+qYncr75xKsB0rI/g3/IaJ+SogsORcKfTwNSOMzxskw4jdjYJp5ISN3PNBUAB51UlhpfPArxeGThYsYd0U4D2tIjNTx4iiRCPQ1/sNeTmuHIHz/aIBulAtqqIDZ+2XpNECX7L7Ik5pVHKO5ACvcQ7xDa8fRJ2+iwMQnFw80Xc7N4rCH6puJ9Z6KQ1mwyc41WC+mV0wyy5UnnJGPR1hI3AneE4AyC1NjncIJSD/3UOLwImoAWAWiPn0oST7zHhIFAH03vMbhsRYK/NV9ImZmqA4OqM8Kd0alFlo1gzlktVsXHO5aLWLBZ+cSMUjRvDYJWATF34S4XJ2L1YpmFWfRj3THqfzs0A0i8txKQbBWPqS/qTtlj6W1IQO4GaofnwqyWQFRgbliBtJBwXiYWVO18OvRFUZvbqEQgRDZKmM0GHu0qc8vL/WOBYLMEjSRnz4Gr/ezwl+b51Pt2DQBRQGd7inTyOSxG/sI4JFIk/KO6fmOHafjGYIeo3p6PbCdymfIGp7qCJgW4j5Q6lO4UtbRA0ekL2SMfkbyUmoap13g3ARTMZLW6US+0Dq8SGiCCNQPtLvsTWYEDoE0udTYPBwsA6RLeofVGJvELJU0TII3/4meSx3CFf6btDqXopSWcR6VK/iUfgYytWZjsFSVRCqvvEVjsWpQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYSPR03MB7350.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bFlYaTJXK1NpWUFPdWFtYzVvS01FM0JxWnl3eFl3aDdtZG1GZC9ibzJ4Qk42?=
 =?utf-8?B?VEZkbWJBSE8waVFBOTRIZWRMa0Z6UVIyM1N4N25TWFlFSWJkOXlMUTdRQ21C?=
 =?utf-8?B?S2IyOGc3Qk1mVURhQUg5VlVXT3ZaUzBhVEl6SUd1VWJ4K3IzczQrQStuTDll?=
 =?utf-8?B?OXRabDlXdERpTUlwMW8zTWI1anZwc3dlMFdZV0dDeVcwTisrRkEvRXYxUGgr?=
 =?utf-8?B?N1hLWGVqNFB2alFEY3gvYzhUb1ZlVytMbVpUSk8zQ29TbU1yMFlUZm9pdzZv?=
 =?utf-8?B?SVhHdXpTRjRNT29MS1JTMEQxOWJrczJtR3o0MU11aS95emczQnRFdUcybFIw?=
 =?utf-8?B?QWdpbFliNTM4M0p1S2lSNlpOZGN6cDZyeFM3TFQvY29PR1BFZHo1Wkk2c3lz?=
 =?utf-8?B?eDdqdlA5Rm5wakpEbHErbHVsa3ZEeUdZcExHVW5HbS9TZmIrWVRNc2xPTENN?=
 =?utf-8?B?OU9ucytDTTExa0pvQ3drZFRnTjlpRkE4bTArd3UvOWdVdTJwTG9aVUh1dzNJ?=
 =?utf-8?B?NVhiZ2xXZFo2bUtuUFFwa3R4alRmaGF4S2pqSS9td0RhMHBDT1dXRUdJR1Z5?=
 =?utf-8?B?Y0Myalo5UGoxdWY5Q0UveVVHeWFycjk1SnRJNkJ5Q1ZUZUNTcGZQVXBoSHg0?=
 =?utf-8?B?ZWhUekJZNnhEV0ZyT1NFYVJqQVRYTDZvSjVPSm9Ob3U1RlZSckZqbmFtRWNi?=
 =?utf-8?B?T0VFK3VaMkRza1d4ZFZNNGoxdmluem5BMDhWR002Y2lzb0JUanM5MHlBUHVo?=
 =?utf-8?B?WkJhVkI3SElVTXgyUmRUaDVrZzZaM3RzYmhJQnFYc2cwRG1qRnlsZU5jVmp3?=
 =?utf-8?B?WUNHSWsxVTN5V21LVHNZemMrVHY1Vk81T3dOZi9VUDZpSTFodTJ1NFlPSDFK?=
 =?utf-8?B?N2dLZVVXemxJd0lOUTcvZTlOamdKSCtSTitDbnJaRHVRdW5SZXUxbjRvR1c2?=
 =?utf-8?B?WDlNLzNIV2tJRlNxR09oczRMYXNlbWRUczVuR3c3bDF5ZEdvTG9ZSGhCcEp3?=
 =?utf-8?B?VGE2MDlFMVVRRlcyWXpXdEVUSFFRK25LQll6L3FVeDcxTHoySVJ4Z2Mrc1lj?=
 =?utf-8?B?czkxNXBGZDZodEVZSDJxaUR4WFZsSTVFYzB3VlZVb2tHcGNLbGhUR2NlS2tl?=
 =?utf-8?B?dEtDR2w3eUg1NHBiUUw4SVpjbHVNdU1LcHdGVUZ2ZmdSSjY1SEQ2dyszcnVB?=
 =?utf-8?B?bmFPdmd0eUE5RHZpV3FMK1RDZnQ0b3g4Skp2SkpuT3hWdnpRMk15bVVJb0hQ?=
 =?utf-8?B?SkZXaFZJOVdZOU9LWGY0SEo3aTh4T2Izb0FySC9sZ25CZktRU0xZODNjMGFk?=
 =?utf-8?B?RmMzcW1PbVhTajlobEtvbWdySU11dmRJMmNGWmVOZlh2d0JVeTVRMUsweDF4?=
 =?utf-8?B?TkNTQStrSmpLc0czdXVvTWFLNGRWN0Q0SHZMcUdWVkxVWHU4ZzgrMWFPUWZU?=
 =?utf-8?B?VUxUV0FlV2oxSnV2R1B4UVlray9oMjdsNlF3dGlXb3NJQ1BFU25zaU03Ymo4?=
 =?utf-8?B?SzhMUHpCdTR5enE5YTFoa055c3d3cVBoYTh5WnN1c29aL3ZvcFJxZTdLc2wy?=
 =?utf-8?B?aHg1cktIaTU3THF6ZkhIdVBxRUhNZGQ0Qk5mc3VoMzJZc0ZQU20rdjErK0x0?=
 =?utf-8?B?V0I0ZWFaTFJNZ0IxVHM0SnhodXFUTzRGOXNYVGR6REhRaVlwQ0pDSXNtRkFW?=
 =?utf-8?B?ZzE2RUNpZ0d6aU81MTNsaDBseHVrMS9GZ2x0UFJFaVJqdXFNT0JsRE02c21S?=
 =?utf-8?B?SHBZdFpXTUIvWTc2aUt0ZWFLYVNmY2t6eU5lMUVmNzFxOWxKSkd6dzl2Mldx?=
 =?utf-8?B?U3hGZGxnbWxoam55S1JGNWV5UHQ0MGF6QWxXWmQ0cWxNVnR2OWFpYjJnNWRy?=
 =?utf-8?B?OGlUSUh4WUNsN2xrRElXSVJHV2t5Vk5GckkrNlNvTUQ1dGFVa3FhbVV3c2N2?=
 =?utf-8?B?V2VBY1JlOXM3cHBXL0xWOGo2RjI5N0NiYzRmMzZ3V2daTFdsOFVSSk1UNk8v?=
 =?utf-8?B?eisrV2p5MXN6MFRCb0ZnVkVGemNaMHViN2VEeHRwbGJsWFZnclZmQWJsbXow?=
 =?utf-8?B?UCtJSk95bDRNTHpuc2tjdXNUSmtuWE00UTh2cURrTzl4VUxsdTArRUZsc21O?=
 =?utf-8?B?R0JyemkzcWxHUllmdVBVcFJQTWtXMmNhZldSNGxxU2FTZFRHdGVvYWNPUzBU?=
 =?utf-8?B?QlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75CDBC9A4490DB4A81D08FB947A8965F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYSPR03MB7350.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ea2638-4fea-4301-7036-08dc449889a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 02:35:11.4738
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VK8elXZHOU68F6nJinZ/jVdhh2QvR/6u/hdUqIPuYMEv6wc+E7RUOmFGWW4TZe6yW8GeQthzQDguKYhd8gVxi0AAN7Cwx+tBfkJdkq0HLMA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8849
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--10.610700-8.000000
X-TMASE-MatchedRID: h20DFeLkM8/UL3YCMmnG4oei/mZCYVwugDRlwc+wR6cNcckEPxfz2MWl
	hj9iHeVpINAJ/M2fVv0lKzzhiO1jPq42liFPoJXkH5YQyOg71ZZMkOX0UoduudM2my+Pv+HL95r
	i4fhj2G/bgfxR9ePGrHcoVxeDLbRtbr0Y+tOgZ7aeAiCmPx4NwMFrpUbb72MU1B0Hk1Q1KyLUZx
	EAlFPo8/cUt5lc1lLgoGRyAacnhaa730BAujE1iDDiGuoMOIxiOCPrmw45UH8/mBcwO/zEzX7cG
	d19dSFd
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.610700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	7A165C22B11120DDAC4DE4878FD54DA467A4D07498BF2E530D40ED9FE6ED0F7A2000:8

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE1OjAyICswODAwLCBwZXRlci53YW5nQG1lZGlhdGVrLmNv
bSB3cm90ZToNCj4gRnJvbTogUGV0ZXIgV2FuZyA8cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQo+
IA0KPiBNZWRpYXRlayB0eCBza2V3IGlzc3VlIGZpeCBieSBjaGVjayBkdHMgc2V0dGluZyBhbmQg
dmVuZG9yL21vZGVsLg0KPiBUaGVuIHNldCBQQV9UQUNUSVZBVEUgc2V0IDgNCj4gDQo+IFNpZ25l
ZC1vZmYtYnk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KPiAtLS0NCj4g
IGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMgfCAyMSArKysrKysrKysrKysrKysrKysr
KysNCj4gIGRyaXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmggfCAgMSArDQo+ICAyIGZpbGVz
IGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vm
cy9ob3N0L3Vmcy1tZWRpYXRlay5jIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVr
LmMNCj4gaW5kZXggNmZjNmZhMmVhNWJkLi4wMjYyZTg5OTQyMzYgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvdWZzL2hvc3QvdWZzLW1lZGlhdGVrLmMNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91
ZnMtbWVkaWF0ZWsuYw0KPiBAQCAtMTE5LDYgKzExOSwxMyBAQCBzdGF0aWMgYm9vbCB1ZnNfbXRr
X2lzX3BtY192aWFfZmFzdGF1dG8oc3RydWN0DQo+IHVmc19oYmEgKmhiYSkNCj4gIAlyZXR1cm4g
ISEoaG9zdC0+Y2FwcyAmIFVGU19NVEtfQ0FQX1BNQ19WSUFfRkFTVEFVVE8pOw0KPiAgfQ0KPiAg
DQo+ICtzdGF0aWMgYm9vbCB1ZnNfbXRrX2lzX3R4X3NrZXdfZml4KHN0cnVjdCB1ZnNfaGJhICpo
YmEpDQo+ICt7DQo+ICsJc3RydWN0IHVmc19tdGtfaG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFy
aWFudChoYmEpOw0KPiArDQo+ICsJcmV0dXJuICEhKGhvc3QtPmNhcHMgJiBVRlNfTVRLX0NBUF9U
WF9TS0VXX0ZJWCk7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBib29sIHVmc19tdGtfaXNfYWxsb3df
dmNjcXhfbHBtKHN0cnVjdCB1ZnNfaGJhICpoYmEpDQo+ICB7DQo+ICAJc3RydWN0IHVmc19tdGtf
aG9zdCAqaG9zdCA9IHVmc2hjZF9nZXRfdmFyaWFudChoYmEpOw0KPiBAQCAtNjMwLDYgKzYzNyw5
IEBAIHN0YXRpYyB2b2lkIHVmc19tdGtfaW5pdF9ob3N0X2NhcHMoc3RydWN0IHVmc19oYmENCj4g
KmhiYSkNCj4gIAlpZiAob2ZfcHJvcGVydHlfcmVhZF9ib29sKG5wLCAibWVkaWF0ZWssdWZzLXBt
Yy12aWEtZmFzdGF1dG8iKSkNCj4gIAkJaG9zdC0+Y2FwcyB8PSBVRlNfTVRLX0NBUF9QTUNfVklB
X0ZBU1RBVVRPOw0KPiAgDQo+ICsJaWYgKG9mX3Byb3BlcnR5X3JlYWRfYm9vbChucCwgIm1lZGlh
dGVrLHVmcy10eC1za2V3LWZpeCIpKQ0KPiArCQlob3N0LT5jYXBzIHw9IFVGU19NVEtfQ0FQX1RY
X1NLRVdfRklYOw0KPiArDQo+ICAJZGV2X2luZm8oaGJhLT5kZXYsICJjYXBzOiAweCV4IiwgaG9z
dC0+Y2Fwcyk7DQo+ICB9DQo+ICANCj4gQEAgLTE0MjMsNiArMTQzMywxNyBAQCBzdGF0aWMgaW50
IHVmc19tdGtfYXBwbHlfZGV2X3F1aXJrcyhzdHJ1Y3QNCj4gdWZzX2hiYSAqaGJhKQ0KPiAgCWlm
IChtaWQgPT0gVUZTX1ZFTkRPUl9TQU1TVU5HKSB7DQo+ICAJCXVmc2hjZF9kbWVfc2V0KGhiYSwg
VUlDX0FSR19NSUIoUEFfVEFDVElWQVRFKSwgNik7DQo+ICAJCXVmc2hjZF9kbWVfc2V0KGhiYSwg
VUlDX0FSR19NSUIoUEFfSElCRVJOOFRJTUUpLCAxMCk7DQo+ICsJfSBlbHNlIGlmIChtaWQgPT0g
VUZTX1ZFTkRPUl9NSUNST04pIHsNCj4gKwkJLyogT25seSBmb3IgdGhlIGhvc3Qgd2hpY2ggaGF2
ZSBUWCBza2V3IGlzc3VlICovDQo+ICsJCWlmICh1ZnNfbXRrX2lzX3R4X3NrZXdfZml4KGhiYSkg
JiYNCj4gKwkJCShTVFJfUFJGWF9FUVVBTCgiTVQxMjhHQkNBVjJVMzEiLCBkZXZfaW5mby0NCj4g
Pm1vZGVsKSB8fA0KPiArCQkJU1RSX1BSRlhfRVFVQUwoIk1UMjU2R0JDQVY0VTMxIiwgZGV2X2lu
Zm8tDQo+ID5tb2RlbCkgfHwNCj4gKwkJCVNUUl9QUkZYX0VRVUFMKCJNVDUxMkdCQ0FWOFUzMSIs
IGRldl9pbmZvLQ0KPiA+bW9kZWwpIHx8DQo+ICsJCQlTVFJfUFJGWF9FUVVBTCgiTVQyNTZHQkVB
WDRVNDAiLCBkZXZfaW5mby0NCj4gPm1vZGVsKSB8fA0KPiArCQkJU1RSX1BSRlhfRVFVQUwoIk1U
NTEyR0FZQVg0VTQwIiwgZGV2X2luZm8tDQo+ID5tb2RlbCkgfHwNCj4gKwkJCVNUUl9QUkZYX0VR
VUFMKCJNVDAwMVRBWUFYOFU0MCIsIGRldl9pbmZvLQ0KPiA+bW9kZWwpKSkgew0KPiArCQkJdWZz
aGNkX2RtZV9zZXQoaGJhLCBVSUNfQVJHX01JQihQQV9UQUNUSVZBVEUpLA0KPiA4KTsNCj4gKwkJ
fQ0KPiAgCX0NCj4gIA0KPiAgCS8qDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9ob3N0L3Vm
cy1tZWRpYXRlay5oIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtDQo+IG1lZGlhdGVrLmgNCj4gaW5k
ZXggMDcyMGRhMmYxNDAyLi4xNDZjMjUwODA1OTkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdWZz
L2hvc3QvdWZzLW1lZGlhdGVrLmgNCj4gKysrIGIvZHJpdmVycy91ZnMvaG9zdC91ZnMtbWVkaWF0
ZWsuaA0KPiBAQCAtMTQyLDYgKzE0Miw3IEBAIGVudW0gdWZzX210a19ob3N0X2NhcHMgew0KPiAg
CSAqLw0KPiAgCVVGU19NVEtfQ0FQX0FMTE9XX1ZDQ1FYX0xQTSAgICAgICAgICAgID0gMSA8PCA1
LA0KPiAgCVVGU19NVEtfQ0FQX1BNQ19WSUFfRkFTVEFVVE8gICAgICAgICAgID0gMSA8PCA2LA0K
PiArCVVGU19NVEtfQ0FQX1RYX1NLRVdfRklYICAgICAgICAgICAgICAgID0gMSA8PCA3LA0KPiAg
fTsNCj4gIA0KPiAgc3RydWN0IHVmc19tdGtfY3J5cHRfY2ZnIHsNCg0KQWNrZWQtYnk6IENodW4t
SHVuZyBXdSA8Q2h1bi1IdW5nLld1QG1lZGlhdGVrLmNvbT4NCg==
