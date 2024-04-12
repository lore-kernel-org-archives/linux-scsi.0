Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005C44D58E
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 09:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712914376; cv=fail; b=KaHsuLtkCdwGRzrUDkXrd+ka5nEAlFMPsZGI1a0ngljXa+EudcY6pfBsrduSIgZ55/uF0EXL3gAHwVCpbd7sxnNWk1Mf1ozHyxRXLyfUf/JqRP5msmwIBfG/pAQRhezrgayVley0HDzhu+x4lwhMjFX+BdwSOVqxwfn3dllTJ/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712914376; c=relaxed/simple;
	bh=tdw1gjna1TkxxaWpxlJaQ7CKgRqYBSfazci/qAl0F14=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ky1//x9adpBCZyTj5bmQ5QqNTHCBxtyP9y6OpkLXmtvowS0W0XQFHA4m8NYqGDVHF3SnDpn0dICOWA+o9GVN7MOwopp7Vp8E+Hp+hpid7Vv7+VNJ1MWTwffo21ATYFjRte2+iWGZFxo5TSIWzBU9Arf5h4d9pzC+pyGAz3QhxWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=l+WxN1EV; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=QllCvAAJ; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="l+WxN1EV";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="QllCvAAJ"
X-UUID: 9f4f8156f8af11ee935d6952f98a51a9-20240412
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=tdw1gjna1TkxxaWpxlJaQ7CKgRqYBSfazci/qAl0F14=;
	b=l+WxN1EVG9w97bSGFp4Wfs8SMCgJyvA5VZMSKMXuPNctCZgSMYaVkZL6IIQW7/ohFLixkjjI3MnZkfPfmDP8lV1wtNpSDhrjPW6xgcQ4lkunBnj70tmquHX2zEbws+lD2a1ltaLyGA73SUSrr5QwwIZIeMzdTgztfKN4rDO2ftw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:a1eab08c-f77b-4708-84e9-cc229723acec,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6f543d0,CLOUDID:02359982-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 9f4f8156f8af11ee935d6952f98a51a9-20240412
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 929354826; Fri, 12 Apr 2024 17:32:47 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 12 Apr 2024 17:32:45 +0800
Received: from SINPR02CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 12 Apr 2024 17:32:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfX+g11T5tbbQZWu5C78jP7ESZxdCmvFTmFSIx3wvngM6wbrnTP/09xhD5sDuTes8vWajhH3HhQD8IKqP8uCbwGPJmNOpTOYZ3m9sttKYWHOG2m8cR+RkGdtRpMIYed6Rut2WbqQhRPAck64eVQbugQ9NEDTJfpJda6jSjZlxAdsekXlPgRxv9g/FK06o5HkwALgDhbJaK6db0FH5VJ1Ff+r2QfV63qp9fLsNkwCDB+yvniYqWyJM/tPKvTgfY1Ac/zJxzDXYYkaODRUD9h7HRF4pXE8/wZBxYWKgw/wkUU0ZUuI6Im0hSZPqTjBgL1KJy8RAxm2pBkUO9aPV0gg6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdw1gjna1TkxxaWpxlJaQ7CKgRqYBSfazci/qAl0F14=;
 b=OOoPSTDH5yM0AQdL2T3RtDvTmNUucKz7c7B3MFWc9UYyNEme63T8e8gQ8USRBpKBci6HpTsdxGn0q6OQoQDst4OPMdh9B+YUUcCFsE+4Of0Yf8113daJri0GBEahxqWSofIIJxFeIyB9ZQRVEdwb3AwQtv9nXgo1xJikJMdw05cSYHd992qgXgdP+q60AYnsT6vm/XZJKQeJ0tWp6WtF5F7yYPZkvf5Sj1fOodQhditI4iDzuoCTL8XCGsZHXGAJ/4ydhjuVLPOXBvnxqOodZEc4xLshmQM9VCc5YbuWeFwFwFlOtBToYk9bnjV6JjqSQkVaKFkVaUX/WBs6HbWwDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdw1gjna1TkxxaWpxlJaQ7CKgRqYBSfazci/qAl0F14=;
 b=QllCvAAJ7rOPa4pAbbVKHH0H7YuxB8Y7emTF/Vw2yGbCmBNzsLPhHV9jR/Jb7KE9/t1o1G2s9m5BdS4C3E3TLR2CTXq5pus8d4saQMM5b+87xWJRYfjrUK/BOMYtm5f7BBkZNSY9mlcFXHC9RTXe0Px1gcSgIqb+q/h8LOTHLNs=
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com (2603:1096:4:129::11)
 by TYSPR03MB8670.apcprd03.prod.outlook.com (2603:1096:405:8c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.45; Fri, 12 Apr
 2024 09:32:43 +0000
Received: from SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::dcdd:6cf0:8378:c97b]) by SI2PR03MB5609.apcprd03.prod.outlook.com
 ([fe80::dcdd:6cf0:8378:c97b%3]) with mapi id 15.20.7409.042; Fri, 12 Apr 2024
 09:32:43 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "zhanghui31@xiaomi.com" <zhanghui31@xiaomi.com>,
	"quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "cw9316.lee@samsung.com" <cw9316.lee@samsung.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"chu.stanley@gmail.com" <chu.stanley@gmail.com>,
	=?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
	"keosung.park@samsung.com" <keosung.park@samsung.com>,
	"konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>, "andersson@kernel.org"
	<andersson@kernel.org>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
	"yang.lee@linux.alibaba.com" <yang.lee@linux.alibaba.com>
Subject: Re: [PATCH 3/4] scsi: ufs: Make the polling code report which command
 has been completed
Thread-Topic: [PATCH 3/4] scsi: ufs: Make the polling code report which
 command has been completed
Thread-Index: AQHajGzqI5sK1vJFzk+MA3f1mzFbgLFkX98A
Date: Fri, 12 Apr 2024 09:32:43 +0000
Message-ID: <a5d76eba8f40d05c47f3b1e0642f9532b058c345.camel@mediatek.com>
References: <20240412000246.1167600-1-bvanassche@acm.org>
	 <20240412000246.1167600-4-bvanassche@acm.org>
In-Reply-To: <20240412000246.1167600-4-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2PR03MB5609:EE_|TYSPR03MB8670:EE_
x-ms-office365-filtering-correlation-id: dcebc092-b58c-457d-c5bc-08dc5ad3817a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H/vzYB91evOn8Qz3FhWPRTYSfRBIH3ZfHugFjNgT7gJ06fE+Z7HJ7SgXR9/15o5WCo0E8/4NzJHsJ2Ahzyqy9fqedwGc6UStjOn82/fcuk1sHXdzg7PCuyGSIiZVfbEju4YB1AkBDLS1aVCMVqFs31SXdyGpxHYvk+isrr810KoudBNeduAkH0ugyySxZR31k9OvvEXo4jetek3xD33tmHDGO+Lagdn+I2Y/Pg0RJHP5wxmGT1aJS1/UGiOXd7FU4RGxXTAqGO7olDNXEkw8f1bg5MP2iHfOqkyjFDzl/SGY8lHU+pDwntd3nSKc/ahdLdUQb4MDzcPGzew2ZSAIBBvCsvZf2DdGE5w4OYwrT7yRqwQlZPkkPlFXZJBmtYRG7nQB5EqjedACkZOuyR4w+w82BQnx02yzkyktgWGMn1y43+IEOv1OAT3wN8rHz8N5won9CQXZDtgpMhS7NUyTqPdeEpcL/+UZz1YYl9aWXUYxWiiq38WGibxzjaxCOYkhCRJVPAoWLme1bBGPIdt0Sj6r24wrew1EPunVRMcz9CHmA0zk5GNg3PQBpO4QB5pdR5J9pS4UoJh4EAl5OjlebRUcGxG2tbsXK+4iUyxOfRnQQSZL38uOWr5E+ivVXjJny6bMJzMADDYNlfoXqQXa+G+qIrmyukdkPLA4SHi9wleqDyp1r/f6jY7qnmzlVB0AFQ2OE3ETus8nMY74RW7x+sttqFmt6OoFhB54QN1inSI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR03MB5609.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cU1Mc245Y2JQK3dhVU80YlJMSlpBaGtML1ZDUFlxd3RPQzRKQ3p1aTM4a0h5?=
 =?utf-8?B?bmNYLzVZMlVJWFp3aC9Yd3RkUmo0OWhCYXZEN1hER3ZQRFZnN0ZTS3dJL3F1?=
 =?utf-8?B?ZkYzWE1iMWNoTG9jZ2FHdlhZdjhQRUF3T0J6bmFnYS84Lys2ZmZBM1RQN3BE?=
 =?utf-8?B?TlVaMXBGc0RKc1oyN08yZ0FESW0ycjJlajNKZ0s4TjVwb29nUXhyK0JGVTBj?=
 =?utf-8?B?cm1ZdWVUT2docE14ZjBHQnRpZmtkbDZQQ3I0TnI4aXYyM2ZCaW9vOS9DUjNt?=
 =?utf-8?B?MmdzeWlCV29WMUI3dDhqQlM3UjVCQWZLajVGZUZCQzU2bDg5WDZtSG9VM2hM?=
 =?utf-8?B?dFV3aFQyOU1NZS94ZWV4TVRaU1dKbGhOazhGWnJjS09qdDZVZEpaSk9Jb1hN?=
 =?utf-8?B?akZTcE9VaUV3aDhwSWNvSmg5WGFaQU9sZ3ZCbEtNVWhkVmpjOFE1SnZ1ZUJB?=
 =?utf-8?B?Q2E5Nk01RUVGVmxQelFncXJrZkV6Zko3TmFlcTdtbFgzNk9EVmJqVTYraXow?=
 =?utf-8?B?cVBLaWhWWEdOK2tlemRyVmhTOW1tUk45M2YvNzFycEpRaFRTMDU0WG1yd1Jz?=
 =?utf-8?B?SVgvRFdYNTFIS0s1N3pGbnNMTVdBQ2xCemI3VDNvUWFmcmJyNFJwWEhjd1k2?=
 =?utf-8?B?K1ZJUG9TNFRhSE9CdjZ3L0lBMkxhUHYrTEUyNzI3dW5ER3N0Q1VqNnR5SFJE?=
 =?utf-8?B?UGhWTUsralh4dUtWdXFGLytuTDk2bG5VV29XNUJkczNObXRYcVpyRDR3V3BM?=
 =?utf-8?B?c0I5N2JxOW1yaFU5dTkyQWVWM1NoMEVLbDhjNG5mQ1B0ZXh4NGJVZDAyd2Rr?=
 =?utf-8?B?UmpQaHZ2dm03OFZuc08yN2xUcFJ2Um1lR3U0Y1VyYWx2WVFjUm5ZMGVCTHp2?=
 =?utf-8?B?V3B2ZzFPdS9pTjF0d1FZZ2tzc3RvOU1lQ01jMXVpcW9jSTFlbG1KYXdsZGdF?=
 =?utf-8?B?akNESkZBd0dFQTRKOTNTR0kxT05TL1VrY0t4TThFR25sL0ZRdUF6Wmd4c1ps?=
 =?utf-8?B?TE9VcVp1R1F0SWhoK0QvYlMrWWhBVXd4TjYydkdhTExFa1ROQTFiS29KUURu?=
 =?utf-8?B?ai9haVMvbGtLVWlYTFFxZU1SNWtHbGdlZDlma2c0eVFMcXhGTFhCbWg5V3ZF?=
 =?utf-8?B?bnQ2RC9mUmM1eWZqSEIxNUoyN3YyVklLWGNNb2tmS0ZiVGFZcHVjVTRSWjZx?=
 =?utf-8?B?SkdvU3lUNzFIVWxQMkhEKzI5alpYNlc4WVJmWlcyYllnK1J6TEYrVWR3SHp6?=
 =?utf-8?B?ZjVIRkQ0eVNxZnJEQVUzT2QvaXFSdTNKVmJRRFhCclFwMEpZZjc3cG53QjQv?=
 =?utf-8?B?UmxDQ3VRT2VUbmJQVmh6cGFsVGcxUVM3WHhFUDJNWnc4MTN2V3VUOWYzdWVL?=
 =?utf-8?B?V0FmYzg4Zml0RnhVcjFFbWN6bklmUDUxbFRYK25HYmUwZFJIWkU4bXRuNlF5?=
 =?utf-8?B?SkE4RkEvV3Nhbm9udTZtTE03VzIwRVNxNXRUemU5Z2h2Sm9Yai9DNElseGRq?=
 =?utf-8?B?NXJZTE1PcXp6M1pkS25iUTh4YjZKWEd0eXdmNFIzelpyTTdKMld3YUxncTJr?=
 =?utf-8?B?ajVFWGlzU2o4ZEZNdzREb2JlRGJuQkFMd0RBK3RhQmlKekczZWxGekRaYlVu?=
 =?utf-8?B?cnlvdkFFM0xLcUZKdmYzRkgrUUI3ZDJ0eUc5dzlYWmU3SGw5eHg2ck9vN3ZD?=
 =?utf-8?B?NE5OaUFiUVdVd21oZjhReVE1MTFIWkp0VFcwcVlMQXhJQ3lyaHl2T2YrUG5p?=
 =?utf-8?B?SnpRREdvemNYMEZvRHVHWmcvVXkrUEljNXdmNnhxNHl5c21tTzl3QnR6bWt4?=
 =?utf-8?B?YUx0YjY2UEVmTU1vNHIyNmg3ejNDaU1vY21Qdm5OM1BteVN0K2JtNiswSklR?=
 =?utf-8?B?L3ZVckNHV0lNNnlDak1JTGtsMjNtOGU2ekJMbFFkd2ZXdCtlaU9nd2k5cGhr?=
 =?utf-8?B?WGhoeEVmbTdtSUtUQXcwbXVTNGFYWFpJTXV5dkcwcWkvV3ZPMkp0c1UrM1cz?=
 =?utf-8?B?MzdpMzlnUWFWaTdnWWJRNGVsQVNNeVJWNHprb09OdytKcmdpdk81OGhXVG9v?=
 =?utf-8?B?cksvOHZvZlF6aGJTU1N5eC94YUxXeHFYWDB3NzdOZ0lXVElycW4yM1kvNUlU?=
 =?utf-8?B?VGJIU3RVMDdhMjFyVEJZd2plVng4cmw1bTNGM1NmK2lpSUdtV2E2bWk0Tzh3?=
 =?utf-8?B?NFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2527D6880A99C34BA9F01C14DB15F80E@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2PR03MB5609.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcebc092-b58c-457d-c5bc-08dc5ad3817a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2024 09:32:43.6467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x71qNcDbCxn+wP1ExJKulzX3ePUkSX7wnSdOj81jM2530t1R8IhnlifjzkGyD2Z4bkQLM4+CcpvbQ52kmlgbIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8670
X-MTK: N

T24gVGh1LCAyMDI0LTA0LTExIGF0IDE3OjAyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgUHJlcGFyZSBmb3IgaW50cm9kdWNpbmcgYSBuZXcgX191ZnNoY2Rf
cG9sbCgpIGNhbGxlciB0aGF0IHdpbGwgbmVlZA0KPiB0bw0KPiBrbm93IHdoZXRoZXIgb3Igbm90
IGEgc3BlY2lmaWMgY29tbWFuZCBoYXMgYmVlbiBjb21wbGV0ZWQuDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gDQoNCkhpIEJhcnQs
DQoNClBsZWFzZSBhbHNvIGNoYW5nZSB1ZnMtbWVkYXRlay5jIHVmc2hjZF9tY3FfcG9sbF9jcWVf
bG9jayB1c2FnZS4NCg0KDQpUaGFua3MuDQpQZXRlcg0KDQo=
