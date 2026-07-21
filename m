Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A231319851
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2026 12:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784638464; cv=fail; b=mQ+bNSW7HDHThfDem9Rgo/W3Hsersk2YZWKYgrNET2bLm09BPl/jSveGoZkNkodvXPVzvCn7QNcaMjWbtCnj1pFm1oXfFN7Err9cnrBNy0EQHEQDbjSOW8Z1ghhSQii1tGQ+Weq6aT2Jd1B/L4tDhH+CXjlPcQ8eLxQkzdbd/14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784638464; c=relaxed/simple;
	bh=3chuYACsbmupFsXqaJaxFXa8Yqlcz9geCY6H9blVWpM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BwCIgcNNPuKMYDPDIW6XEyFd8zZiw3rdIaeXh7hVcF7MwQYnh3xd2J6NXnVjTXu/PltfSAcR1NL3aRgfyAlIqczWYe2EnjoxFkmJCaH7rh4PSsma7y1/Z1VQfzhASwxM9j6QOSwmhTzaxXBV93wiPcjwa8JwL/v9OpkRhnYr1e0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=pb8ph1nu; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Ov+3E01f; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pb8ph1nu";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Ov+3E01f"
X-UUID: 42c7877a850311f1b1788b6acf885367-20260721
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=3chuYACsbmupFsXqaJaxFXa8Yqlcz9geCY6H9blVWpM=;
	b=pb8ph1nuyO/nqwZLXON4yCkykJIH4ZX4h/e/sufcOcaTyqUr+UIsFDUr5ejtP7ScftqegGj3iwJEOOClXSpJdGnsOCee1nxlDjfhzRn9La26KeEeepeP+yhvIUL/8x7wKiGiHE02brKY2vf925Pl0iXkzYCM9F4lunPT2ifZON8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:29beedbe-56fd-4230-b5d0-ff252f86e006,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:9cb8873f-46cf-453a-bd84-ad9fc7cb0e8c,B
	ulkID:nil,BulkQuantity:0,SF:80|81|82|83|102|110|111|836|865|888|898,TC:-5,
	Content:0|15|50|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-
	1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 42c7877a850311f1b1788b6acf885367-20260721
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1423303389; Tue, 21 Jul 2026 20:54:07 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 21 Jul 2026 20:54:06 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 21 Jul 2026 20:54:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=od/LXVC2zhMDqQuCHgzxJfXAaGlAQxu4SfgNSuAHMBdSu8zZXEbbKhn3sAlXDyqVJ29pubyKZLa2F+GFmPtYwAl9ggBPfI4XgIUaKsX0lyCDPQr9cqnFg0JKNhDAdt7mekvNPTH0spPwqB5f3oHe9UL5lmP4pdfGhLHdmMG3+6WRDqG3+EZ1m7smKnES4r5ruBoqEk8rZmanMZDJ3+YbLzPugOuAHn8Kh8mTXpFtE9zSx6wFPCvDt5y0kmzzAcTZ5FZcU0bErT7K3FpQmClP5OZseConjjhiGU5egITTjD6tuB/nILxbCHJHT9wNshVs7lbP6ATbKEXQrkudOElKog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3chuYACsbmupFsXqaJaxFXa8Yqlcz9geCY6H9blVWpM=;
 b=JhWzExYNA3/h99mbCQbluXYF1/aDf9JshaCTuj3WwNmoK1ewN3EOy1S9F/8ov6kl5W9NeTOeSVhefA3Mg70X9lMoL8MdIdDU6tdjURo6cal2BgydZofjq+xymSGNdHQm4xYxWLy1MAFkec4TO11QvUnbF9v5v1GT4nYNEn0I5gJISclp7t6m4yBJkGhYhPGJqvNi7aEmU7tGPvsnY6a9sy0Fp2eVXw9oj2LQOeskol6pRxWOsNmJ+enAP815fyq6WkvCETnLG9pXtqrDOO/PYEEE/J5ZMe0PwAB1SkKEq276th25o6ctHX7QKXptCbxgXO+CWdxHT5shRd1s/+WWqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3chuYACsbmupFsXqaJaxFXa8Yqlcz9geCY6H9blVWpM=;
 b=Ov+3E01fbL25RU4su3zhTa16Fu4Xd4wNzHHjEjm35F7QMKGgtoAyOebHYwfLLJCa/8kRoWFU9C1FnvVUC7vk8jnr8KsJjjzyTfnRqvaSGNQ34uqDzPFAf1eAMOTLwWlosMwJFypMgYims143vbRrV+t5kysVSjTCtuxdwGGi/84=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB6981.apcprd03.prod.outlook.com (2603:1096:400:277::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Tue, 21 Jul
 2026 12:54:02 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0223.017; Tue, 21 Jul 2026
 12:54:01 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "shengchao.guo@oss.qualcomm.com" <shengchao.guo@oss.qualcomm.com>
CC: =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?=
	<eddie.huang@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?=
	<Alice.Chao@mediatek.com>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, wsd_upstream <wsd_upstream@mediatek.com>,
	"avri.altman@wdc.com" <avri.altman@wdc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>, =?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?=
	<Tun-yu.Yu@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: Remove unnecessary block I/O quiesce for
 clock scaling
Thread-Topic: [PATCH v1] ufs: core: Remove unnecessary block I/O quiesce for
 clock scaling
Thread-Index: AQHc9Cb93EUGOKVTq0+kTr1d74Ua7rZ31FiAgABjWQA=
Date: Tue, 21 Jul 2026 12:54:01 +0000
Message-ID: <29b5f4368a63847b84b87e36a1e358f5991b694c.camel@mediatek.com>
References: <20260604133503.2049288-1-peter.wang@mediatek.com>
	 <al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y>
In-Reply-To: <al8YkXydXJQZrl_Y@QCOM-aGQu4IUr3Y>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB6981:EE_
x-ms-office365-filtering-correlation-id: fa98c4d4-0e9f-425b-06cc-08dee7272366
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|38070700021|22082099003|18002099003|11063799006|4143699003|56012099006|10067099003;
x-microsoft-antispam-message-info: vqdXr7/T+zEgK2f2r80cocfYnn5t+FuP20CuAVYbZythBtHwpF0ChDCORT0y6dXU8qm6xzWGs1iSkjx7rf2RuCA8vpSUmw7FNrEaePB/ekzenr+/2KkxN2hdnHL7P5Qx81jkPLgyg3AoTIWIzjNpgNgiyAQhNOT8kwn8yJwRcSX3AWu+sy/TexlBN/m3N0notujhG+exXDwPS0d+FyA2HsA8SZBsqt5I5Thxr07/fVJ1rHIN37cTyH46toEiXt4PUtVmvjOx0aWguYvADd2/T37692vv8nXTSGCr9cMTmaKoe6DGSb0DWOxjogg8HdEsd1nt6YeuPhgFXV/a2BS1v7AtoEvMzpC5rR4AtYBn62qDfZBAXyyyEKXc+4/9CplGAYsZnswBYBJx2U4pukJRX03aKcV+m7WjDPWnaR11nRbZ/z+dc76+Dv49znydx4g+XrH3bCJ+DMm0sR9QK79Qxj9NlRZOZQpxjzyn6IF66ziSYOzN3QmpID3ikInW9QM6/rBjQBEsQ+b6ShYb9AJJHo6QtJSkcvieWKFa9P4PonTrCRAwkyvS7ISBC+E6495X9Zlp4sjZVRX/leuqGMPPFUP80UMfr9C9SMe1SLe699r5SV5DlC/pFwKfQKwwKaCfaaT0cw6Jst2Fk5OqtOA7lraSxKN3x9KxVQDqePK1duCK+C0AuSyTo7YO+R6wudNPVKoFW4JtXX8HNn9v6WIgHkD9piMUEFZdcCc+isy4NWI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(38070700021)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L25rN3dYQXZqbnlDN21HeXcrUXBXL0YzRGV6MWdVemk5dUkyRDhrK05ici9l?=
 =?utf-8?B?SXVJY2VrMDdkMFJscGRsTUlGR0ViQ1NHM3BKNDhLU2NJenRNZXh1eXYrbkd2?=
 =?utf-8?B?dHR4bEpIZnh5Q2RMa2MzZmJ4bnN6b1lOQnA0STBQZG00aGFHRUZvQ2FMTnZ3?=
 =?utf-8?B?bFJrM3diWGhvbjdZalNibS9EL1F0M0ZFMjdONzczT0U5Uy82ZEs3VytPVTFJ?=
 =?utf-8?B?VEFqZkpCU3hOalRoMGlaRVlZSDVuaERPSVp1VnltbzQ4Zm1ZckNWYitzWHpD?=
 =?utf-8?B?ckhqeVNGemhPNkt5UU9zQXMxcWR5ZUZGTk9lQVljRFM4UHZBbWJxajZjc3Bm?=
 =?utf-8?B?ckpHdmtoZUlENHZQc3R4R0c0R2JmWlpiRHY5M3dVU0Jkc2NjbXRmN0VER281?=
 =?utf-8?B?YUlmMENNbVVpMFZoSUxkVjkzUFVScFV4RncvUVRaMGFZTjVucUtkSUhSbUVB?=
 =?utf-8?B?NGN6VW9oREsxMXJrdWlPSnFoZGVDTnM2Z0VjYnVYVDIzakRNU2N2VnRSbFdX?=
 =?utf-8?B?bkNuQW1heUZIcXRtcVpMWjdhbVFhTHQ1VGRlZUNTUXdwQ1c0V2hwNkJIbTND?=
 =?utf-8?B?TVpMR2toMmF6SmgrcXduemlsOGtOUjZQVTJJcXg4U1F5NkQ4UnFFVUszKzRC?=
 =?utf-8?B?ZXFYN0s0RUpBSG9mVGNrbGhaK3ozZm4zcGxPd0UveERmenJzUjFGSmN3MWI1?=
 =?utf-8?B?Y3pVMkpBdEZwemJLU0lKdVplRzVWT2VpUldMaDNQT1BlTUJheTI5aFRyK2JZ?=
 =?utf-8?B?aUlPY2lkNDVkdjZOcUk5VVRVSkwwVERSejdDMWZRZm5UbWRPZTliSkV6V0hI?=
 =?utf-8?B?T2hGVXlyK0NPM0ZUWlRQb0FHNU9EOHJDWVVWeVRZTGdNRmhNeFdUb0UwSW51?=
 =?utf-8?B?ZVJNMVQzc3JyYVcvTEN0dEhHMURSRXdMYUFKbHFEcWo0ZWFBc2Y1Z3A5TlBD?=
 =?utf-8?B?ZWxySUd5dmpMR00rR2dpTW9VbUxGQmVMVCsydnBIL0FTNnNIT3d5cm13eVI2?=
 =?utf-8?B?VElNRVkxZEwwRGx2cXY2SFJhVm1QV0pDeW5ZWkRTVmNOU25McFFaUk9tZXc3?=
 =?utf-8?B?dGtzbkJzR3dzazFGN1pxUm9GRGpISWJuQkIraUhCWUhkbng5dlU4VnN1YTV1?=
 =?utf-8?B?N2lqUGMzdU5TdU1Fc1dEZU9CRnp3dGZ3V1lGQU1EMWIrWWtUUS9Rd2haa01j?=
 =?utf-8?B?c1JYdnlydW4yRWxTZ3BFeUdJdjZBcVJKZG1rMXdxUjVlcGhiN2NFRDNMd21L?=
 =?utf-8?B?VFhiUEcyc1FERllIMkJINHJKK08rcVFIaHdaTkVMdzUzS3Y4T0N4U21hTVZG?=
 =?utf-8?B?N3dTNHdUaXNtNHQzSTEyY1ZUZCtWY0JuN242dVRDRlRBT21uQ1ZnbEs1d2li?=
 =?utf-8?B?ZzFmNFF5ZkNxM1g2OVJrcm9EaXdZNkRjLzQxTkRZc0xuSUlJUzN2M3R3TER6?=
 =?utf-8?B?cHNhNHc2QmFvMEpuZVJhSGVVVWlGREtRT1J6dzh3alU1Qk1rRHhTdzZmWFJy?=
 =?utf-8?B?b1dzdjBIcHdlNGRQMDJncHBxVDZ4S2UvVFVYMHlUSnFzVURTTUg1RlRUYXg3?=
 =?utf-8?B?dEVHaFVxbERPYjFPNXg4UkZBcnRLUWo3NVcyTEpsdVBvSkpOOEt6bEhPNTkr?=
 =?utf-8?B?WUZ2Y3F0aUhxQUNvOHUxYzMwV3VWVzBVWGlSSjUwQUlhNHJCSTZrc203M0Vu?=
 =?utf-8?B?ZFNoY2I0WjRPbUpxMzhIUlhRK2lVS1FxQXM1dEE2YVBrbUxFVG05RDh5QXRh?=
 =?utf-8?B?ekhMclVudUZaRWl0d29zNWVQT1BuOTdLMUdDOE1UbUhXSHVqUmdHREEvejlw?=
 =?utf-8?B?OXpkL3dYcnU2ck1TK2xqSzVxMEJpVkd5b0xlVCtLNGdkMzhKTlZZeE5rSVpR?=
 =?utf-8?B?S0pWbUpldVJYd3p5Y21hN2llbXRrT0I0ZlZNWWpOT09DVjBpR3B1RWx6YkpL?=
 =?utf-8?B?NW14Znl0VStqVVFFb2pYL0o3RTExUUI2ZHZKY3d6UnBrSW9yOFlRcE11bHNy?=
 =?utf-8?B?aWt5OTRRVU1ZYVphZlVOS0d4TktrM3l3YUFJRGMzL2o3S2w3eTFHeHhZRjBq?=
 =?utf-8?B?Q2E5OU9CcS8wbWdSYzFZT1hnK3NWVmlUSDRNeHc1ejRhZk05cWZpWjZvcWxV?=
 =?utf-8?B?VXBRQVVJQzNDK1JTc3pZYnpkc0d2bGNRYis3ZlRaMnMxcFFLV0tBUGVtTGp3?=
 =?utf-8?B?NEtObDErVTl0akNGanIvdVk5aHloajZ5N1J0Wm16YXQvNEdSRUxOWTBsaURP?=
 =?utf-8?B?eFJYT2FBNWlLcFY4bUZaQ2JqZVpMbmp2YVlIb3c5Wlc2b092RHAzSHBkL1FR?=
 =?utf-8?B?eFR2Q0VQdzdsRmZ4Tmg2eW5qUnpJVmRXNHZQT3RlMDJuUkFBNndsaHcyMTlD?=
 =?utf-8?Q?uek1WPdx1ZL6+I78=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEAE57150504EE4FA31F0473DA624615@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: C9Z+TyNPpTyrYIPXh6u18uDIVPXoGkfba8ToWsA8PYucLrxdGXQ7qAZe1it+8qDOlaksBzziItAEmNrWtllw0OK8+YCtDrWajXT5VIwjPFgc1X92QLY21dcRsOOIULZVVrjqi8JQaOoXfOcXl0WT8et6Nx8Gm7828+FjNpJiwzy+Ou6fGqupYqih7qiamRMR+ZqyMHVQedk8FMtTXz+/XzbHd0PiHo5dxy3WP5ox3WQkhFoaO42zEzjHJXPhe3hGU5lR8ry5IkfjDAJvqgcATxsFZlBxTMMelWEeXDF/t2JoEL3KBJePS86yqYWEAph63nDjAkVyro/3WFg5l0Ejgw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa98c4d4-0e9f-425b-06cc-08dee7272366
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2026 12:54:01.6482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuoio6Juj59fOXb9LChwGwsrw3QceYw6ZD7+6sauMTbL+gMkXUjE528hQ6SMmc3JbXlQv/rpCYszxAEll/obkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6981
X-MTK: N

T24gVHVlLCAyMDI2LTA3LTIxIGF0IDE0OjU4ICswODAwLCBTaGF3biBHdW8gd3JvdGU6DQo+IEEg
cmV2ZXJ0IG9mIGNvbW1pdCA4NWIyYjk2NjI4NTQgKCJzY3NpOiB1ZnM6IGNvcmU6IFJlbW92ZSB1
bm5lY2Vzc2FyeQ0KPiBibG9jayBJL08gcXVpZXNjZSBmb3IgY2xvY2sgc2NhbGluZyIpIGZpeGVz
IHRoZSByZWdyZXNzaW9uIGZvciBtZS4NCj4gDQo+IFNoYXduDQoNCkhpIFNoYXduLA0KDQpXaGF0
IGlzIHRoZSBwcm9iYWJpbGl0eSBvZiB0aGlzIGlzc3VlIG9jY3VycmluZz8NCklzIHRoaXMgYSBk
ZXNpZ24gbGltaXRhdGlvbiBvZiB0aGUgUXVhbGNvbW0gcGxhdGZvcm0gb3I/DQoNClRoYW5rcw0K
UGV0ZXINCg0K
