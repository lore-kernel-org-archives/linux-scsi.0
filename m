Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD7B28AB10
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153510; cv=fail; b=amrcX74o5y133lxe0omRW8PPlAy/UfKqAw39z+UX7CjrR/l//dnkIn4V0HJ/X4EpRaOwPz0fMfm1fjAG2q8akbNZrY8xiI7XnZINZM3hPKNSXREROkbDxKebMzDzKjSSxB3TIH9qg6w3GohFpqaPQ5WbqZbxhqvGSxSo4wGVO5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153510; c=relaxed/simple;
	bh=PHQzEtP/nz3YW3/5LzaUaX7EzN23QzJRMUUP+8QG8VU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RSxoEYuAQ1SOrQBJdqNjDWFEhuXPUzKEPS41ASWm2bCqSyDcKzc2ogfWL4Zq7bOH7DGcLIuqSRDlZ9n8qvRdWTYUzXZd9qsB3rF4DL0VfHlCy3QfOB99G+sYkKdFEXfaCS2evttiHJnh6ZlDrV+Xly+xAMGTFkJOSkS7CahP2x0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=cPYrbCbe; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=T6ZISGP8; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cPYrbCbe";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="T6ZISGP8"
X-UUID: a7ed855c66a811f08b7dc59d57013e23-20250722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=PHQzEtP/nz3YW3/5LzaUaX7EzN23QzJRMUUP+8QG8VU=;
	b=cPYrbCbeWvNEuoNxzHtqhp9zoaH1pZBCLWqlckgCAhTvbp+ACER9YhOW6FdvViXOBqfi7qCK9mR/sMICCisluvfsvUr5Rw05ghVawCkO6Ulg6xGl7vQFd0mzPEDadCEiJNXim7Tlg00c85kmySN9VviRuSfYcYijwQ49mA22osk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:0db4075a-cc14-42b6-bdca-44f0ac62abaa,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:1cc31b50-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a7ed855c66a811f08b7dc59d57013e23-20250722
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1446723218; Tue, 22 Jul 2025 11:05:00 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Jul 2025 11:04:58 +0800
Received: from SEYPR02CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Jul 2025 11:04:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mhGIVBJ5a48XqGbPB5lY6/gFXZDgqJGaEsKj9Lhti0MyHJR9L5iKNgWCASkqBXTOflgTrB+ol62Syz8i8xPwqpp62f9k1TrzXQAK53epnOJrn+67x1z6auFspLXOrS+828PTpdlsgvPwO0IUpW5Jz5qBAZUftLqvDzknBIkmiYSCjXrt1dj49f577yOH1+8grVZwmtSyMYpKquKP4rRLS7HZpSBw0xpUzxZ9EcKoq/MQIsQ3rGJmStTPPXTbMH4AZv9yVThiUldxmatCBhgJ0wYjw72YrqzccekUfOJG1pG1uEHe+ZAUSkV0IdmEGHY55ZBgZI9inxA6Y7gXoWd7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PHQzEtP/nz3YW3/5LzaUaX7EzN23QzJRMUUP+8QG8VU=;
 b=aIbMjNatWMp1wJSHd1KEL70n8/wftlsQiMkb6LydcAIvixAugF49+hA9R/2eadZQne26dbticFLESRoTPFZnzyO4rNVT7iBfERsYChev9G1eh9WTxQYGQjXzgqXrpA6P1eXxEHTSx/BAdSGEu1jYhOpYh9C71FxkEjWIBGGcKwh/zEcPXudFnmPfn1BgWSCKD+UoDK63zAQF6nQkG3LzMFaU/dhn4JlLOyk64FEKCKo74lXkXHfB7Rmw8IiUnDx+y+RIKT6+RFtYJupF7R4GachvcjpWco+78HItzAUTk/z+P3gF+cTcgoywBIGz7YAA05Vg2QkWdiaC/433ep8Q0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PHQzEtP/nz3YW3/5LzaUaX7EzN23QzJRMUUP+8QG8VU=;
 b=T6ZISGP8rmTxOLeCUAitY8jiUsqyeqgYwHGefakGtGVp+LbvidDhcB+P8E86PuHU6Znj+zAlLuEmj1ZqBODon1xuZy08JsthXUUrcSoYOeTT20TIN+a/rTU3A0fK0CL9MPB1yABvKA8sx9dvXmj8kwl2ODyUlVkMzGPc+h8l++U=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB7629.apcprd03.prod.outlook.com (2603:1096:101:12e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Tue, 22 Jul
 2025 03:04:57 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 03:04:56 +0000
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
Subject: Re: [PATCH v3 1/9] ufs: host: mediatek: Remove unnecessary boolean
 conversion and parentheses
Thread-Topic: [PATCH v3 1/9] ufs: host: mediatek: Remove unnecessary boolean
 conversion and parentheses
Thread-Index: AQHb+hquhooDcyHPaESlkxjqpXEckLQ8uIcAgAC+EQA=
Date: Tue, 22 Jul 2025 03:04:56 +0000
Message-ID: <b00ce970cee5d8d66376667704d571463d995f25.camel@mediatek.com>
References: <20250721083626.1801668-1-peter.wang@mediatek.com>
	 <20250721083626.1801668-2-peter.wang@mediatek.com>
	 <37ef75af-70a4-4030-9bf7-0bae0f53f7d9@acm.org>
In-Reply-To: <37ef75af-70a4-4030-9bf7-0bae0f53f7d9@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB7629:EE_
x-ms-office365-filtering-correlation-id: 05019843-ec48-40b4-d8c0-08ddc8cc89db
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aGcvQ2tLcjFIUGxjQnU2ekhlalZZdVV4MUZqaExEUzN2NkliUWtobUdOOWxF?=
 =?utf-8?B?MmxBSHl3SkpnekowK0g4TVc3RzFOQXBuK3lGYkdSL1p0Y3F6ZEJDY2t1M1JS?=
 =?utf-8?B?Q0lPYmdvblZzNE92RjVzVVNibE1OSlNLS3FqWk4ySmpwMEVPTnU2S2cyRlZD?=
 =?utf-8?B?UHcxQkN4MHIzR2VVbHRGalNHSVVHbXl5dlpYejVTclNiR1ZUTFpLMHdzdnFV?=
 =?utf-8?B?N0lMY3FUMnd2ejRKbTBFS3NuWUhPRERwMWZSZmVzVFE2cU5PREtoUUNmbSsx?=
 =?utf-8?B?QU1LblZLZ1N2Mk9IVXJ3c1NFeGwxUndXWWJ2Sk9VWndTQkpjNHJmMjRFQnQ4?=
 =?utf-8?B?UjBrMTROMDJ0NHRvOStGeDZ4LzFEWXlOT2ZSYWoxZWNZb2Vtb0ZGSjZwQTFK?=
 =?utf-8?B?ZkpRblJQMUVMcHBicmFTUTFEZzhvb2sxc3k3Q3BWR1hxZHI3d2h2SnF3NDFr?=
 =?utf-8?B?cEVQZmwyTDdKSlplMFdtSEsvekNVeHFzZ1pScUxOcHcrM3FFSThGOFVLRUMw?=
 =?utf-8?B?ZUxuK0N3QnRka3RyUkJrKy9VVkkxMk1aQjRiT3g0YXoxWUJ4eXdGUlFYQTBF?=
 =?utf-8?B?cm1PNU0rVDZ0YUw3SWRqRGlzQW1RLyt2K0xES3RWd0tvRTd5YitNVmNXdkxR?=
 =?utf-8?B?VGVEanI0a2lyVGZjOHdSeSsvVnR6bDM3b0p4N2NJLy9ZblpCZ0ZXOFdqSlox?=
 =?utf-8?B?eE1qZFhFVUliVVpMVVU5NytJd292V2pnTHFPTGFNYWtRbWRDc3BZbURGZzBk?=
 =?utf-8?B?QkQ2bVlZUWJlYW9KVFpPOTFpd0M1TnEweVNOSEswV2xiQmhEQWVmVXFCcWU3?=
 =?utf-8?B?TEFOYTlUd003ZW9jYTZMTUtzRUlKUUNMVEtDQWdKSzF6dkxYdi95Z1IzdDI3?=
 =?utf-8?B?WERTa2lsZTlJU0x0MytoU0JjbEhuTXNUWTVXcW9qdzJsUVppNEExNUNWNUFY?=
 =?utf-8?B?clpzT0tSRGdNbGxFR3Izdi9iWkxYNGplbDI5bGFKR3BOb2VLMlR1VW5SM1JZ?=
 =?utf-8?B?d2MyVzlhT0ZyaUdabkR6S1R6dHlWWFdlcU4rZ2FWei91KzFxZ1hqbk9yWjE0?=
 =?utf-8?B?djlzYzRLL3dTSFJQdkxiODZ1TWdBcWVqaU9qSGF3Y0lqZGpRSmw2Uy9sdXFD?=
 =?utf-8?B?S3c5TFpURzhsdUJCdVdRWkpGV0VHQUhQUGVyMi84YkxKckVPQjEydEtkSnR4?=
 =?utf-8?B?cENQdDFSVTJsam83clo5Z3U3azg2N1VaRHBMcVkya2ZsK2xRSmdWU3dHdjFa?=
 =?utf-8?B?ajcrendIY0liMURQZjU1VXM3KzVvNnBTS3NkWHZibjZCdTJWOGZVdDBBVVlj?=
 =?utf-8?B?eWJZaUd2VktSU2U0OGpyb3VFZ1pob2dmWXU4YnQ1VXZ3WEl6bHExQ2ZJWXB2?=
 =?utf-8?B?bEdzVFg5OGZVYTM4R2xJL2lvRUF5ZTZ3VG9PZDduNXp0NGRmMG5mak01Y1cy?=
 =?utf-8?B?Z3NHQlZvQnhjNmN3VnlyM3FNQmljOHV1L2RpUEsxL1BPT3JocUdnZUg2OGl5?=
 =?utf-8?B?ZG1TZ2VTTlBqL1NTTHRKdXNRdEdDTU40bXFHVC8ycW1UdkhaOEovc2Zyd1Zq?=
 =?utf-8?B?ME9vSDJIRE1ZQmExdzVOQkdySERUck16bk00WkQ4VzlZaWpDUXFJSjh4RGJt?=
 =?utf-8?B?dmxkbDlXWWpnVHRLVGl4bXg1dlFCbkdUSERmUWladWl1eDNSYUJ3d3REWCtY?=
 =?utf-8?B?dklXMGdjbzBVYUFuRVR0SmJtZG12TVVoclMrY0J0c3k1N25ZQ3pDdUJuQ1dj?=
 =?utf-8?B?MHJWMnJNakczTzhVMDRWVC9TbC9uY3ljNThLMFpML1dHTy9yQjY4aFhyd1kr?=
 =?utf-8?B?amd0TjZIWEFENzZiRXZqcEI3T0pkM1hSb3RyTEVCS3BvT2FFQjRwRGZWQmhu?=
 =?utf-8?B?eSswNGJvWVUrV0ZtOCs1bjYxYnI2T3lVOTNKeWxha1Z4dmg0RXhjRmpDTE5X?=
 =?utf-8?B?UVlDdjQwYjY3bkdyeGFxdWR1MUFUSGFZYnFBS01uajlGVG9NYlMrZmZkcG9X?=
 =?utf-8?B?ZDdaSEs5Qm1BPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OTE2b2phSDlJSGxTWkp3WlIzcWk1RUtoWkxTY0s1T3VsQ2dBbnU5UEZFS1Mv?=
 =?utf-8?B?WmgrSnphdjAvMkFwVU1HVWtqcGpRQ2lkNlltT2dOU2c5ODVieVc0MnBSaC9U?=
 =?utf-8?B?N0ZqdXJzTXhpNTVFUExlemJzOFcwa3VZbnFJRVFMbStJOHZJZmQ1Uk1BRzlt?=
 =?utf-8?B?UHBTQXg0R1ErdzNNOC9kNzRGVXRNODVYZVRibWpkUDlsOHUyV3RxK1dqbVo2?=
 =?utf-8?B?MmRlYkdNOWFlUFErbFc2VW5JMjc3M1lBSW1VSmU3NitiZjVxZkxMWFh1eS9y?=
 =?utf-8?B?U3dJczJOek9CUGNIZHRmeFNKZVVpUWlIRjlDVzJ6Nyt6dEZZWGhaS24zZHNx?=
 =?utf-8?B?ZEhCajhOcmRrNExNdXl5M0RXTmRtRDNTRUxsSUFOQUxsOGN0OUgxOWVYU0gv?=
 =?utf-8?B?VlFWMVMrSHB1MGI1ZE50YS94MW5Cc2FNUVZLUnc3TUxyWkNCUzlvTklMSG9N?=
 =?utf-8?B?YnpWa05NNnZmRnZSYVBESWJ3M0R6SHB2Unl1SzNNa3diNTVtVTlSL1hrZWwz?=
 =?utf-8?B?ampncXArS09ZeXJLUVFRdG1RQzNPOXl4dHF6eC9rbk14QW9XS1BFSXdGa3hq?=
 =?utf-8?B?RFFOVjZIaUxuR3IySzNETWNxWm9hMm9Wa3ZpUG45RE0yU3RHZUxKdVU3enBh?=
 =?utf-8?B?ejFkTzVYdm5nSlJnd3E2WWVTVXppN3h4TWZmeU9XRUVIeFdoeE5GUHVxTnFy?=
 =?utf-8?B?K20xOXI1QWNNMks4ekNBM0hqNE1NK0VRcjFrcXl3aGRLMEowUituQW8ydU1C?=
 =?utf-8?B?SVBvVWRzNGNvcDNhcTFuMXNqZGcxODBKNzhRdVo1UFpud0JSa2J5dENCOFE1?=
 =?utf-8?B?b3IvblpObVZhelozZ3I4UkEvQVg0dUVvVm5abFZPM2JIY3Y3UG5vaU9ZcWRO?=
 =?utf-8?B?TEY3RytxL2xLYTVBQkJMU2ZvRjdKU1ZjRmxkaXBGcldWWHRHZjZrcUZINEpD?=
 =?utf-8?B?bzlMVUVERE5ha2J0YmZMbERzVEVYcEVWMGN1SjNLQ0Q3bWF3bDJSNjgyR0pZ?=
 =?utf-8?B?bmg2S3FBMXUzRmZNc2ZNT2dlL1FBalF0MjR3QVBTL1I5SCs5U3F5VDMvTC9G?=
 =?utf-8?B?UW1taDVMUzh6VGo1NEF5TEJNK0wzUGRaa2ZzRFREb3RWR0kzdkRoNmFXZHpT?=
 =?utf-8?B?WHdtRHIrS1U0NGFDNWtLUkRMWUZDQmxHc2swMnJxVkZPbnJPSFJqRjd0UEN5?=
 =?utf-8?B?MU1WaTA1N0ExVG5Pa1Z6NFdOdm5PNVJTRlJCQ2JLN3R5OUZzQm1KYS9uZnR5?=
 =?utf-8?B?V2NqenlsMGZMRzI5N3U4NW5HZ0F3VWQrZlVTOGFFTllrWTVTQlFGb0tLdzZ2?=
 =?utf-8?B?VzhFMUNPTEF2aEY0U3dTRTh3eVA4Y0RLai82SWN6N0FnOW9uTTBMWUw1ODU0?=
 =?utf-8?B?VHJzUE4yU3ltMWpDazVULzN3UVBacXpDVG9BNVZ0MnpZdXd0eDh2NnBtaTBl?=
 =?utf-8?B?NUNhNjRueFFuQW9GWVczQnIzNjk5VWUzSHZES2tTak9aY0ljMkZVaG9CdTl2?=
 =?utf-8?B?VmJCNWU5R2w5OE9aTUwraTFuYVp6bTJQekduVUpUNVRDalpBa1BHemtPVGFX?=
 =?utf-8?B?cmlXTDJDTk92OThMWXJnQUplTUkzK1MzbXYxUkpIanh3aGlRakJTa2NQZCsw?=
 =?utf-8?B?SzZaQ1NhRHJkdHVoN3JiU3pUVXFrVzVUaDFiWXhwbmJQR3dQVnJqdVZIR3Rs?=
 =?utf-8?B?cjc4MnNhcUxjbERKZHhNSWdpdkxxQ3FidmRUWEZOYVBjdHl5M0ZGUUdBcWNx?=
 =?utf-8?B?U3lyMGY5V0lDM1c1VHlvczJEVXJwQ0lxaW9PdTBVQ2psU1QxZ2I1c2FZZm5z?=
 =?utf-8?B?S2phbXp0TEtGR0hpeHplVkEyQk8xS0t6aGtDT1dVeGNodUFwNXg4YlFkR3pX?=
 =?utf-8?B?aC9OSzZNMUd2ZlUxanlXdngzNStSUkZBRkd5c3Y3MXRveVFZZ2RHcHlEYlNt?=
 =?utf-8?B?VkVuNys0MlRCUWZhRjBITUcvdC9FYXk1ZWNCY3JoOGRnbFE2ZGdlczNpSjBR?=
 =?utf-8?B?MWZ5emVrYlg4bE1sNDlJWElrbmFDQWY5UWRLczgyMUYzdUlmbXpjZVF1bFNI?=
 =?utf-8?B?TEdXMXB2eXFUSThGNjNsdEE5Ty92Y24zV0lKckpUUUE0eFR3WThhRklKV1p6?=
 =?utf-8?B?Q1VvcDIrdVZrdEo4MGN1RHJydE0wb2h2eHlLR1ZHS3NhMVEvZUIvaURyUDJV?=
 =?utf-8?B?dkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BB7426F93B33246AFD4BF2DB58614C4@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05019843-ec48-40b4-d8c0-08ddc8cc89db
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2025 03:04:56.7653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rqb7NS4gr3sK84+o333ZjbiJi/Tdzn01Lv0VkgUsDaxE/+kGL7sOzHJSrND9cd75uNja+hmEygSXUlwkFbDbZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB7629

T24gTW9uLCAyMDI1LTA3LTIxIGF0IDA4OjQ0IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBUaGUgY29kZSBjaGFuZ2VzIGxvb2sgZ29vZCB0byBtZSBidXQgdGhlIGRlc2NyaXB0
aW9uIG9mIHRoaXMgcGF0Y2gNCj4gZG9lcw0KPiBub3QuIFRoZSBjb252ZXJzaW9uIGZyb20gdW5z
aWduZWQgaW50IHRvIGJvb2xlYW4gc3RpbGwgaGFwcGVucyB3aXRoDQo+IHRoaXMgcGF0Y2ggYXBw
bGllZC4gVGhpcyBwYXRjaCBjb252ZXJ0cyBhbiBleHBsaWNpdCBjb252ZXJzaW9uIGludG8NCj4g
YW4NCj4gaW1wbGljaXQgY29udmVyc2lvbi4NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoN
Cg0KSGkgQmFydCwNCg0KT2theSwgSSB3aWxsIHJldmlzZSB0aGUgY29tbWl0IG1lc3NhZ2UuDQoN
ClRoYW5rcy4NClBldGVyDQoNCg==
