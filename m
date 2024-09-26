Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985B01F61C
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2024 03:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727322167; cv=fail; b=fYjKgGyKW1prkBVxqi4SJUV//gJN8DmLLSmjxP9a1kU5FKY+ms5zumnqG1V9WZWz9oyUdDr8arLfqm3DwlTXDqEqCJZ66eEhfHZ5yEEUCzb5/ddLYfGw28oRfMOJ8ueiaWkZ8Fd6iTtGZbkx2gtF4BlvDYjwVt/ItOtiXmFgZko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727322167; c=relaxed/simple;
	bh=KlpfPJMqQTPbCUQCFdV8sUFTK/2oURiy1WwINnNhdh4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DMa5pfZaOkyFIWKdfPybr853UYSmaFEI4jM8cHFTQSa/GWnPr1xXw+NrozRMtyJoALiQegQJkhgqRfzQEwTPp3bKW4CdX5A6M1bB9//a9EIdHSDf29NznWgDllMwaV9P9ywMJR7suNbPEJhN9907df+w2bMUxySJmMdRPXcIsWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=cUQcvU5R; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=J9L53g57; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="cUQcvU5R";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="J9L53g57"
X-UUID: 608b028c7bb911ef8b96093e013ec31c-20240926
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=KlpfPJMqQTPbCUQCFdV8sUFTK/2oURiy1WwINnNhdh4=;
	b=cUQcvU5RXwRROmOpNFQT5KIpyt4t/MpWyoW2SXb+MuhPUgw43aklhB44M7N8LUhb/ndJTZ2gmTsXGihKMoOd68rM9VpROycFNazJa6GR7kJqwus6KSrcRa/Xx7JrPXcLJNQINNB3Yf2M5fQqJ/xv1kAqmDyS5MG2kIMW8f/m4pU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:ae16d174-09fe-4606-9361-a712cc7475e8,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:467ec8d0-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 608b028c7bb911ef8b96093e013ec31c-20240926
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1870816485; Thu, 26 Sep 2024 11:42:39 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 26 Sep 2024 11:42:37 +0800
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 26 Sep 2024 11:42:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=laNSB8LpzP4kzjGHQaJFI/iIL7zV49Bl+oCsuyY8fTAe+oFTwqYG+V3/rxjAXf4QpfAFR/PJiLQYugHl73Q4otAggX+WFT2jByCgFr1lAN1ahaOb/UpPVgzmKgoyCO3+/FR4ISDSO/Mu6QghPpZPqynVMQvTqZcLHX8VHT7ElO0tEmg6cjATBR4iDbeROMufgIPbgKdFdwjd/P2TjR6nDzg1fpV3pUoa1XUi3dqihezz3bPtOM9VJlf480DYK2mSuyUq4w+jmbwX9PsC9MX6aQYytxfq+DQug2kdLmojys6FJY8YqPCouu9TqcLyHahXdU/wFUjKKunOMKzFjkAJ0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlpfPJMqQTPbCUQCFdV8sUFTK/2oURiy1WwINnNhdh4=;
 b=lX+vJ6szHwCLJwKr3uTettsXR/C/dK9y5wCfehuJKNP0G/MwVjNXVqiTChrTe+mMrrZkVlLJPGR/02eLsG4fnOHDoqrtmOAVr4L02fxqRbIGUUzhuhbONCPJ5H1pbdBfmjus6nzVS+mBhHuy/72imaCxPeEnZoSyS1KIn6VReAv4SqWp3w2LyIufWA7X4txguU2b6h112dvQpc9W+WLeGO1qeuzagSNmO7g90p37alItquvgfAKWlYdUyuRKhymqgc4PYnYI2ACB0Fa+KII8xggL/TNaLCY9ZQyVxbh4qqkemzqjlfY4GJMWLrlG8rfe7xoTKstK4bO3OQ8/b59XQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlpfPJMqQTPbCUQCFdV8sUFTK/2oURiy1WwINnNhdh4=;
 b=J9L53g57wdwTLgtjpl4p4JOYeT6yP/Z0I7dYVPx/JPAwbs02I+qM2PQXfk/VYU2rn97R7i1+60f3rYzdTCb349xPlnGfuP4lNDQfSg2mX5Vv2Uz/qoO1Ce7rE/7e3tRxX3DN4gd5jvHtpzCfS7Qd+XC8pgWfB2Vs7LJppTU9a8k=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by JH0PR03MB7981.apcprd03.prod.outlook.com (2603:1096:990:31::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.23; Thu, 26 Sep
 2024 03:42:33 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.8005.017; Thu, 26 Sep 2024
 03:42:32 +0000
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
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
	<Powen.Kao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>
Subject: Re: [PATCH v9 3/3] ufs: core: add a quirk for MediaTek SDB mode
 aborted
Thread-Topic: [PATCH v9 3/3] ufs: core: add a quirk for MediaTek SDB mode
 aborted
Thread-Index: AQHbDzNl3QHSMHQYMEikBUqWzi2LwLJouUGAgAC0k4A=
Date: Thu, 26 Sep 2024 03:42:32 +0000
Message-ID: <80c871dae894780c1d713ee9a093e1fc9d110ffd.camel@mediatek.com>
References: <20240925095546.19492-1-peter.wang@mediatek.com>
	 <20240925095546.19492-4-peter.wang@mediatek.com>
	 <03b34628-d70b-4ce6-ad87-3c2070105bfa@acm.org>
In-Reply-To: <03b34628-d70b-4ce6-ad87-3c2070105bfa@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|JH0PR03MB7981:EE_
x-ms-office365-filtering-correlation-id: 19e55d0f-1b20-4e81-ce83-08dcdddd40d2
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dllzY3RCTUZ6cVBPT0RDSE8zM3ZUNHdoL1ZySjJhMXhZOU1pU1hxRStDNUZl?=
 =?utf-8?B?VWRseGJUMGd3T1NWYjFLbUdrNVNsN3o1M2plVk1OUmVBYkN0SEQxQUo0cDNo?=
 =?utf-8?B?SkFsaGRYdHJHNjBDWERvSEtzRldDMHh0eXNaY0VraVhaVTFsNXh1QXlkaHRB?=
 =?utf-8?B?THNIbVNjdmJpT1cwa3FyZ0tONW1jS3owd1VNa0h2bjJiNXJqQnIwLy9DMzdR?=
 =?utf-8?B?RTNWaUw0MFVIZ3I5SzF6bE5hREN4UXFkN3Y3a0FESnhTYVEyTy9Seit2ZVFx?=
 =?utf-8?B?aVNFVjM1NzJqRlV4RGZGWVpYdENRUVZ3VmN4eFZXN05KdzhLVUdxWlhmM1Bo?=
 =?utf-8?B?OWh4QlllaUE5U1pEd1Z0OTR0cVE0TEllUGh6UitzSllvSThJc1pBbGxpUnFH?=
 =?utf-8?B?ZHhtU2Y2UW5PbzdlQmwzLzhTVUE3L1BCUmV6Sk12cE9aTHA0TC9qbm5aUko4?=
 =?utf-8?B?a2w0akdvbEhCY0h0V2s5OTlGekhncmFueWhHRFk5QXJ1MFF5c0tSM1Zjdm9R?=
 =?utf-8?B?Y2dCSzdJazQwbktxN2xjSno5dFZKVTRVbjhqLzNZbTNGajVYNmlQdy8vVU4z?=
 =?utf-8?B?RHk2WmNPSlptSUJGdlFwMEd3K3N4Tmx5Vk1LNk1WeW9KamR0azViQ3F0ZEsx?=
 =?utf-8?B?eitkMk5xL3NrTy9IQmp1S1RqazQzdFRYY2FJM3Z1WFFydU5McHFiL0pFaXBp?=
 =?utf-8?B?ZkpVNEd4L2FNZEZwalRDbVl5Vk1MUldqR3AvQVd1bnhCNXhEUXYyeVpFdWtu?=
 =?utf-8?B?ZHFFeGpwSlhSQ1ZBNlhwaFNYVUkwKytCNmhkQm1nSWlSMnNiQlVKbUNhdjRF?=
 =?utf-8?B?K1U1YnhPd0phY2Jpb20xY0dOTWljTHBaVHFpb1FFTDNQd1dJdkM5bVZvd2J5?=
 =?utf-8?B?OExyYmY0V3RiSXN1THV3ZTlZWjNKbWlPZzQ4NjhMMXltZG5xUklOT0RRa2NZ?=
 =?utf-8?B?WkVxbGdDYWJjWGdqOXcweWNiMldkeW5KcXJEbHk1T1lKc1dxcHk2b3F1WEp1?=
 =?utf-8?B?WlF2WE1ySldKSC9US2tFWEdWWGJWZEtQazVZcFdlRlZRbHFZZldyRDBOL3la?=
 =?utf-8?B?NVdYREZNRjRrSTF6V28vcWNVa0xSdUNUaUVsQkJabkFtZm1PMXNyRjVFblRX?=
 =?utf-8?B?bnNaSDE2RnFlMFV0MmpnRDlGTzVRVUZKUTlTN0h1bDEvRG9MbUtpOWJ5b0I3?=
 =?utf-8?B?V1NuT0VMaHZ3S1NCNWdOOU13MmdQUmVwbE5KYisxN2haZW5ZU0o2TUZpMEV0?=
 =?utf-8?B?cFNxWGFtS3F3NVA2Wm96MTh5cnRRNzZKRktqRWEza3RCYXRYMFROdkxHQzh2?=
 =?utf-8?B?cnpvV2hiNkRQMmxYcURDYkpxVUVvd2hZZ3Z2azljbC9pU0J1ZzJqRnJxY3Jl?=
 =?utf-8?B?MzhxM0FDU0NYNjBEVFRIZ2hPQVFIaEFtbGtDV3BQTnN3NXg5Q080eUFZaE9V?=
 =?utf-8?B?Q2kzRy92MTdwNlBOcVdVODlzS0NrOGVudFJiK05PRnFaYW5ZVzRRVWNnTmEx?=
 =?utf-8?B?MjRzMHpQdW5YczhDTXNDU0ZPMStUU2VJWVRuUGxKVGJ6bkJBMU5SQjVhRFNF?=
 =?utf-8?B?blc4QXdLRjJLQXVEd1RPeWQxVGFCUnJGUmNYZUVEYUpVREp2YndKOHhCZlNV?=
 =?utf-8?B?NzR5NVZDSlZqYVExTXQ5ZjhqdTYyVERySXdjeENaTlJhKzhHVFBNNi9SQWxu?=
 =?utf-8?B?OFM4bkc4MUlsM25ETE1ZNzhJYkNrU0oyM2RqVmQ0VkRmM2dFNjZPYStOVk5k?=
 =?utf-8?B?bi82ZkhtdUU0L3oxeGdxRTNvUElaK0Y3ZWs3Ly9VbVpFWUxTVm40eXJKd1Rw?=
 =?utf-8?B?SFhHUWNTdHQ3R1V1YTUvZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVVpSkhKUmNDZTFNMlV1Zm50YmxCTnJLZUYwck5xelluVjZneXRxTDVxUXJM?=
 =?utf-8?B?T3JCaUZtZ3dIV3l1cUF0aEZaSllLMEZFbUR6Y1Nyb1Brc3F6MldGd0w5Qnha?=
 =?utf-8?B?Uis0N0ZxSFlhVERBNWV5UWRrN3BRUTRSbnNEZVVtcUc5dHdNMFdoV09VeGxp?=
 =?utf-8?B?MjEzVWEvODVBWG5FM2FRK01aYzU2K1pyQTcxUFlTWmliYTg3MDFEbkEyZ2ps?=
 =?utf-8?B?QXFuRTVXNUhjck1zYzA5ZG1Bdm5KNTl1L2ZqT2hYbjRvcWJ3QjB1dzZxYyt6?=
 =?utf-8?B?QmtaTWtXaXZkSnBidFBNL1VFUWV4TnkyeU1XeWJVNSt3NkZCWnJLNkswNWFq?=
 =?utf-8?B?S3J0NkdRRWR0TUxqRUh3MVoxZHRrOFVadGhld2dWekZRSHdLY2Y1dzlmNkhV?=
 =?utf-8?B?V05qTjlwK1oxbnpBK3IvelBpLzdqcVpsdjBLalNPd2Z2am1GZ3pEcWpMT3VT?=
 =?utf-8?B?ZUlMRHV5UVFHK2MwUkZSb09ZMkJIZ25TMmg4L3k4NlVna2RVZ09LZzI0WHBm?=
 =?utf-8?B?bytJTkM3UFUxMmJRYzNNREFvRWN4Z1FrdFR6b1FDc3NMSGZLR3BqYXpML1Nx?=
 =?utf-8?B?ZzA0OVA5anpUL3VpVng1UGtkM3dGSThiaDBpVlhVb0tpRmM1L3M5N1dJak5U?=
 =?utf-8?B?MjlnMzlVeUNSUGJrTnN4eGFmTEVGVnFvQWlPa1gvT25pVUdCdkJSSFJpeVpN?=
 =?utf-8?B?bE0yUmszOXpHVS84UjluYkdBTTE5OWdrK01RSG1Qc0VjU0JpakZwMDZZSG1t?=
 =?utf-8?B?blRtOStqZy9RZ0k2dTdWTFVqUGtNZmJvTXhuUnJnVjBGdlNsa1dvOVJ3QTVF?=
 =?utf-8?B?SUl3K3prZEhKM0V3ZVJkbEdZVkoxZWpGbGwyeC9LeC9mUnFZQzQ4ZFQ3RlhZ?=
 =?utf-8?B?VnpYNDdIYkhCeXJTWXJ6bUNZM0FRTDhJMms0YzlZdHljSEJpTEJ5QVQ1dDdV?=
 =?utf-8?B?c1JsOTJRR0xyZlp6RHdjeTltSU43aGo1QWJqMEhVVWptb3VvalVJa1VGcGpE?=
 =?utf-8?B?bnZXTis5NzF2cCtmK1dIT21rNlpUKzJEalo0MXV1RkJRcWp0cm93eVEwTGd3?=
 =?utf-8?B?VWJIZEsvVjVMUUtIajlCa3ZlOEhLSzFGamUyQzV2UnplT0lXaldkcnNHM09z?=
 =?utf-8?B?bXRXQ1V2Yytxck9tRzJrY2JlcTI5Q2MzWm1vK1IzQktidHhoa2lTT3Qyd1pu?=
 =?utf-8?B?SlcySE5YNGpDRTdWY3pPZzAxVk8zYnM0ZFNtWDNHQ08vVWlhbHo4SzlJZG5L?=
 =?utf-8?B?ZWY4ZGNVRjJtVE9BTkw5MGFNbnRjcE5rRU9BRWpOTXBnVFV4bFV3RGNYMzRH?=
 =?utf-8?B?OUlvZTlUT2VqQ1YyYVQ5bUJxamJOY0FNdEhwdzZrQUJkdkZnYzNVOW5RaStY?=
 =?utf-8?B?c2JKTGpGWjdPZXBuVmRZSmJOMSt6YmxyVmIxWlIwdEd1S1lwcnh6eEh6NlJI?=
 =?utf-8?B?T3IvWTB0MUtQTmM0V2Z0TlJwQi85dkpHRUNvemJlMXgyT05zeWZFZlJXUFBi?=
 =?utf-8?B?VXM0TERYRWdpTmJOYTROSzY3YjUzdFhaemJBQWlwVkR3M0ZBSGVtV1Q3czU1?=
 =?utf-8?B?SncvUEZqZnBLZi9qdVB1N0QyQ2JpNGM2UW9RUHNadnRqc3NiSkNnVlhyU2Vj?=
 =?utf-8?B?MTZoRGxWYTB0WGU1eE5LMXVBbko0N2RhNzk4TlptWkQxS25yanpuQnphSXp4?=
 =?utf-8?B?RWtobC9GbTAyVU9CQnFMQ0ZTZFZ1TTdhL0JuS09VZ0dZSEY5OFMxK05PMGJv?=
 =?utf-8?B?RU1UZ2FLdW5rSlhBdVRUSEhORS83Y1dURmh5V2UyVWxwSHNjYkpka1AvMDB5?=
 =?utf-8?B?amtHb2FWUGFVaVJLTzgrQjU5TTNwdVlOdjR2UGY1Vmo0Q0dqZGI2eU1xZWZn?=
 =?utf-8?B?ZnphSDdQNVBkdGRVNWVlUzE3dlFQYzZVK0lZQVBjcUdOaStVNEtvZWxCKzhq?=
 =?utf-8?B?WWhRUnBqSVI5aUNiR0NzSXB4RitodjF6Vk9VY0w2TnRSbnFWWXR1ZjRKaHQr?=
 =?utf-8?B?czZZWDJiN2IxY2ZZcXF2a0ZYTSs1Wk0zbnUzV2ZPb04zTGJlOW9HWGtFNGpE?=
 =?utf-8?B?NC9xd1dpcDMxNDZWMjFGYVNGNytabkpndEFpY0hsNTV5RzdXMWJ1aTNNVVpo?=
 =?utf-8?B?WGc2WXlsb2NaZUdPRWZYS3JTV1JPK2ZuSFBpWFVsd05GK3U2L3ZyS3RXd1A3?=
 =?utf-8?B?bkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DF4E8E8D532434980A713B5B74026ED@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19e55d0f-1b20-4e81-ce83-08dcdddd40d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2024 03:42:32.4265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sftxN5c8dM7CFyuw8j6ubRKmOsmpA7hn9+fqTuuCW5kXx5V/9fFZkwHmzijY4oodPB/2OfVRhKFAQc80gZcdmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR03MB7981
X-MTK: N

T24gV2VkLCAyMDI0LTA5LTI1IGF0IDA5OjU2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiANCj4gdWZzaGNkX3RyYW5zZmVyX3JzcF9zdGF0dXMoKSBvbmx5IGhhcyBvbmUgY2Fs
bGVyLCBuYW1lbHkgDQo+IHVmc2hjZF9jb21wbF9vbmVfY3FlKCkuIFRoZSBwcmV2aW91cyBwYXRj
aCBtYWtlcyBzdXJlIHRoYXQgdGhhdCANCj4gdWZzaGNkX2NvbXBsX29uZV9jcWUoKSBpcyBub3Qg
Y2FsbGVkIGlmIGEgU0NTSSBjb21tYW5kIGlzIGFib3J0ZWQuIFNvDQo+IHdoeSBkb2VzIHRoaXMg
cGF0Y2ggbW9kaWZ5IGhvdyBPQ1NfQUJPUlRFRCBpcyBwcm9jZXNzZWQ/IElzIHRoaXMNCj4gcGF0
Y2gNCj4gbmVjZXNzYXJ5IG9yIGNhbiBpdCBwZXJoYXBzIGJlIGRyb3BwZWQ/DQo+IA0KPiBUaGFu
a3MsDQo+IA0KPiBCYXJ0Lg0KDQpIaSBCYXJ0LA0KDQpCZWNhdXNlIGluIExlZ2FjeSBTREIgbW9k
ZSwgdGhlIGVycm9yIGhhbmRsZXIgc3RpbGwgaGFzIHRoZSANCmNoYW5jZSB0byBjYWxsIHVmc2hj
ZF9jb21wbF9vbmVfY3FlKCk7IA0KVGhlIGNhbGwgZmxvdyBpcyBhcyBmb2xsb3dzOg0KDQp1ZnNo
Y2RfZXJyX2hhbmRsZXIoKQ0KICB1ZnNoY2RfYWJvcnRfYWxsKCkNCiAgICB1ZnNoY2RfYWJvcnRf
b25lKCkNCiAgICAgIHVmc2hjZF90cnlfdG9fYWJvcnRfdGFzaygpCS8vIG1lZGlhdGVrIGNvbnRy
b2xsZXIgZmlsbA0KT0NTOiBBQk9SVEVEDQogICAgdWZzaGNkX2NvbXBsZXRlX3JlcXVlc3RzKCkN
CiAgICAgIHVmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKQ0KICAgICAgICB1ZnNoY2RfcG9sbCgp
DQogICAgICAgICAgZ2V0IG91dHN0YW5kaW5nX2xvY2sNCiAgICAgICAgICBjbGVhciBvdXRzdGFu
ZGluZ19yZXFzIHRhZw0KICAgICAgICAgIHJlbGVhc2Ugb3V0c3RhbmRpbmdfbG9jawkNCiAgICAg
ICAgICBfX3Vmc2hjZF90cmFuc2Zlcl9yZXFfY29tcGwoKQ0KICAgICAgICAgICAgdWZzaGNkX2Nv
bXBsX29uZV9jcWUoKQ0KICAgICAgICAgICAgICBjbWQtPnJlc3VsdCA9IERJRF9SRVFVRVVFIC8v
IG1lZGlhdGVrIG5lZWQgcXVpcmsgY2hhbmdlDQpESURfQUJPUlQgdG8gRElEX1JFUVVFVUUNCiAg
ICAgICAgICAgICAgdWZzaGNkX3JlbGVhc2Vfc2NzaV9jbWQoKQ0KICAgICAgICAgICAgICBzY3Np
X2RvbmUoKQ0KDQpUaGFua3MuDQpQZXRlcg0K
