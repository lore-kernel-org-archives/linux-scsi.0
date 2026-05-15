Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD38A3E8C61
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2026 08:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778832849; cv=fail; b=QGh+Yyf1zfHXXZo+fatafFtfgZEj5NH4/OrFrbNW7esaFZNDT/L6r0MPFfs0APeCWLRuUgV688ozXaQiG7m8zvOkbh5tpV8Dy9TBH34Pd03RTPSQNTptxOmW9tRCR+KA/U4KaIXTsuAZVBnlgACtFNR8B/8PRhGklJ/GZa3F47w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778832849; c=relaxed/simple;
	bh=pgIWZxoUQqHFAHKjRo2VebrVG4M5YIX32Lcd8jMoRMw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VZ+v3fBKSQfmk9EUSuvip1OYay0n2gvl8ENuZyardPR4/W93dmpfE6KnaE9TvpjAjMC3AySt9HtxEhBs/0jzP9PyDZVX08xB2gHHjA3d3iGs1x4DMZhVD3z3+dXCeIOn0aZwNlg2zMlJXZ6L2PhblIb5CCRAR8eKBtOK7pJBj00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZAJO0Jz+; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=VJ0HCT3R; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZAJO0Jz+";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="VJ0HCT3R"
X-UUID: 027a81e2503611f1a3561939bc42ff46-20260515
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=pgIWZxoUQqHFAHKjRo2VebrVG4M5YIX32Lcd8jMoRMw=;
	b=ZAJO0Jz+RvH50WBZDItDDJu3xwEnnIHTJYGr9Ej2Z7zvsVb5f4cmqRrU8YUeLfajlsr/2mGuGl9NHFJnvX/rmnRUAJX4bFVEdh86nmNY5KdtDyEmOp5UDe2CiEW4EOh6IG1hiUMc5PWK3RBfGcPVuYt//XyaCubd08ROuvA/69g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.14,REQID:69ae44c4-891f-4c73-84c9-9823bfa6fc66,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:9091e75,CLOUDID:a228777b-1fd6-4ee4-b486-88dbea9db487,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 027a81e2503611f1a3561939bc42ff46-20260515
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 704575556; Fri, 15 May 2026 16:13:52 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 15 May 2026 16:13:51 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 15 May 2026 16:13:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T3CyXUfYq+nYT5yxTXv7hcHXezgtRvNxzK5BjhmF/yjFOnxKQRxu9FR14qT0IFfJ4WNZ0Xpu8P3PW7g4cjxur325WdNATbJlQhF7A7VNJ72bnepxnyQNojLxfh9ENWwbsWItqnbsvdY0CQTFsItyKRNOn8ouygFtpQ10Kty6lw77oJkJNQrVfFwxpRQb+74eH8W96YahQONqEF+24WlhHpCNyJ8pm4kyAZ1SJiOMLx1lgq4aysHrte31lD3N7aeIq0ofMWAcRilnu5/XM7x6Hx/9FtEiUM0Zf52GuqFNc6ggfyE3XRfTJIeCcXGL6sbVcDRgrZjHBa/6Vdnnjmx3Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgIWZxoUQqHFAHKjRo2VebrVG4M5YIX32Lcd8jMoRMw=;
 b=QI82GAav32AFVL1QiTKrJSjhz1NfAum3r197ZWWcWcQfa5AGPVfLX9PJ5wVNpzczBYX1BjVBpf8droKDQEY2MlKBpYvaLTTrEKDPXK6s/qt8QmThbGSZLKKqZZ6f3/ajjggx08B3T9EPOT6o92bzVt7KM01avbMtLwf5VlHad/HBzmZIXzvakKaXI4l6IcoHdt5uSUd5nTKi6uF1TwPj4WcUb1AX0SbedYSJc3w8WO8RGeCyAbiHGmmFY2l5/3cuhyMwkM/crj0HyWmYPQAhGPesGRpgHyNge9H1v0I661kBYl0NX7ftrd9k6D4/Nomm8WOn3yGMpVI7/EOf093ZwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgIWZxoUQqHFAHKjRo2VebrVG4M5YIX32Lcd8jMoRMw=;
 b=VJ0HCT3RYxLH1Sjy452Gxx5b5GgYBWXaJ8an8Fy3eCcEvUCA9+QlMR11uxp7kUpJnRZDgwffXMdSvr2ORXUay8F9tfRcZ6yIJLV9qMOGIrdSDkj4QFp63dUi9MGWKEcpplMxcDz3Htrz5wxkPrtyyhjwmMZzWKKUgVj1JGrmjvQ=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KL1PR03MB7174.apcprd03.prod.outlook.com (2603:1096:820:c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.19; Fri, 15 May
 2026 08:13:48 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%6]) with mapi id 15.21.0025.012; Fri, 15 May 2026
 08:13:47 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "quic_asutoshd@guicinc.com" <quic_asutoshd@guicinc.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	"quic_cang@guicinc.com" <quic_cang@guicinc.com>,
	=?utf-8?B?TGlnaHQgSHNpZWggKOisneaYjueHiCk=?= <Light.Hsieh@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
Thread-Topic: [PATCH v1] ufs: core: decouple CQE processing from spinlock
 critical section
Thread-Index: AQHc44A/IHVJ0+M1ukqkaTZOlDMObrYNtNQAgAEJrYA=
Date: Fri, 15 May 2026 08:13:47 +0000
Message-ID: <3d359319927f808dffa0aef52b03c437f803335e.camel@mediatek.com>
References: <20260514082906.58593-1-peter.wang@mediatek.com>
	 <382f6d79-c877-4dc8-813b-ee91ac5489f9@acm.org>
In-Reply-To: <382f6d79-c877-4dc8-813b-ee91ac5489f9@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KL1PR03MB7174:EE_
x-ms-office365-filtering-correlation-id: a5613cac-465a-4865-04f9-08deb259e3d3
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|56012099003|18002099003|11063799003|4143699003|38070700021;
x-microsoft-antispam-message-info: ctTMbZXbhP2gIT0UTb/arZJ8/BkfBYFi8N7qIX1cJLGnjOt1oKfuHv+UE2q3tu8AGl+GiVoMct3e5XL+t7SbadPiwLybZ7WEslXvTXv6+jerDO/OvVuNSzSsUwgTevruqZO2meOv0sMMxS1j2kpAnBQ9YhcXocujxOmnw6tZnGLuKEI/mVoK2jVYclWlq3NQuSN2wncnExEv/N3DJCO1Evyd2B/ogQtbHsSP1z48hM//2kUM/dqBCYT6sLGIHqTito7jp5mi94YCogVeiux8yEF7r7LZSsvMb9lThxkjmi1fBCbueF16OlzlTYJ6dxVzUA8PLMBtwp3toNzSWOygGQ+WYx9O0JsKTovgWZ0ZDhzaKwN1kwouDYR9pAoBdM6i+RPvXxnvnc3/H0NyVmjuDuAYyMdRppZA2ITqNWqNPCJU4kd6Mq1lpsr+nTuMvSXfncZLN5W7DFNJLrDtTDWoCu4ehix2crY46FQRwkXjMT6RGUqqBAp/wzfcjTw2QnYlhiLvleiwO1IxKdkVSGhQ+/2fWXFA5cI1YoEO4zbDkjfuCLTMCoM8fLZFAPKIMDwQRAbYFqvUl6RAodfJ8jUJlgO70MSskcgmSwPQmtWbBEO7apbbPeaCFBA5HWMMjc62X8ea9a8Liqc5qQOGKsPhgyWhzsMTghFZGnVL/id4X85Huamu3eHb3wJlLTGFUTAwuObZ1YeMBwUlVlx5BJHbvj3X5gBkDhPSopJQxG2eV7y0ugg4CnAw/eVGAugIez6q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003)(11063799003)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzU5aXVlZUNpZmcyWDZBWU8vck9hSWtFdUcyQjA2UG9RS28zNUx1OGtVdTNR?=
 =?utf-8?B?eUxSZjB5OXA4ME5BU2d6MUpzYllZWTd4eFRJWUtCRkszSzRpQWVuT3czbWxn?=
 =?utf-8?B?eGRMTUhOZ25vMzB0VjZTVWtaQ3dpK0ZMRFBqbVlPcTZRUGwvTy9IMGtjTEl1?=
 =?utf-8?B?bDRTOXB2UEhyUVBSdnk2SnJlbkRnWGVJRUE4cmduZ21QL0NDWWlEY1d1Q3hL?=
 =?utf-8?B?aXo5L0EvdzNpUXFZcXpOY3QwTS9yc01xZmI1N2s2blNnK1l5M3hvRVNzUENj?=
 =?utf-8?B?NThHRUl5d0o4bERoYmZnb29udFZrdHRlMFl0T0txUW8wUWdTN2k2S2ZPT0d3?=
 =?utf-8?B?M3BTUjhuYUhUZ0dXbzBaSFQrRGwwU2NVbjZSZno2OVBHZEJPZmhPOEc3YXky?=
 =?utf-8?B?Z3ROKzBtMDIvNyt3cUZnd0d1WWJNK00wZ0ZnSGx1Q3VENERWYmlVdERUejlZ?=
 =?utf-8?B?QVIrQmZ6V0ZZWDVLdUkxMHB4MkJGaXJCSzZNM25qTXVoTVYxZHpWRTB4REJ5?=
 =?utf-8?B?Q0lBVzFpNjBKdzhwdHpqRlhEUDJtVWwzYk5wdlVYNDd2Z1Fsd3B4ZDhjaTFs?=
 =?utf-8?B?MWJrRk1xMTkxeVlaVTlhQTQrMTN4ck5oOExKTU9jVTU0QzE5dXZocmlqT3g2?=
 =?utf-8?B?d1hHS2dpZTZ2UXUxbUxiT3FYSStqaWd0UzhzQ0QrRWkwcytNZVkxZjlnLzVj?=
 =?utf-8?B?QU5YU2lsOE1nR1UwUi9uZURPdnRnazluZndnSndYVjFUc3ZreUltY0RPcEda?=
 =?utf-8?B?VEU3dWZZaG5ZeFY1cUhwK2JzUU9DYWRGMkF6bzFRSzRSbm9OU0FpOWxxY0dS?=
 =?utf-8?B?Z05CNlM4ZjZJVDZ5d0grbTlHWjc2b202eHV1VTBVemcwREJJeVhBRXFQSHFh?=
 =?utf-8?B?RndQQk1FRlpSa0s1WlpuTTg5L2IyL0ZIcVpSYmhBaDR0czgvQmNpdlFVMzRy?=
 =?utf-8?B?OUxtbmlacE9URDM3WEZsSUMydWJwRVFvQ2xHQWR3eExvcFRoenQrSFpGK0Er?=
 =?utf-8?B?Z1dSYnI0NXVBTWJFV0JtSWxrZmZBY0t2Vkt1dU5xSkllMmNNQWJRaWNZWTFT?=
 =?utf-8?B?MzFQY1F5SnB5NTIvaUcyUGdMRUNNSUxSWVhXdlJRbzluRXVTcUl0eTRFUFZM?=
 =?utf-8?B?K2Rla3hkekZvK2RKWWxKWC8yam1oRHo2YzFrK3BlOVJndVRZajg3eTZNekw0?=
 =?utf-8?B?WlJMMS9zcjRKK01xdWJQcjdaS0pOaDVKemw3OXhGZzBBSUpLREFkL0lTdUNw?=
 =?utf-8?B?Um5WZXUrYlhvcVFTQmRDQ2pod3ArTkxnN3AyN3prMUxhSStabDlacU4zMFg2?=
 =?utf-8?B?dnhheUxkOEdHWnQycmQ5U1hoR1hCV2R3NFUxUGxRY1VmZWF3aEZoR1hCUEYr?=
 =?utf-8?B?Z2VoSlhnOGdvUDRDUmFHbzZEeHdYNUNpVUlmUzkxSGhrZVpCZXhBY09KMEdQ?=
 =?utf-8?B?N3J4NGk0ZkNxa2piRmI1KzdIbHUvTDdzbmV3Mmowb3Y3cWQ1bkFmZ3ZRdWE2?=
 =?utf-8?B?V0V4Tk9TbmppZXpJQ3Iyajd5TDdxcys5OVpvdlJreWk0S3hkYTFNZzIxekNM?=
 =?utf-8?B?aE1GNkJaRlZWbG96SGs2aUdJWlhsd21YanQxdHZhY2RnSlIrUHphM205aGR4?=
 =?utf-8?B?eEo5MXVQa1pJc1FIcEZadWdyOWExaGI5a2srODUzZHZFMU5RbVlsYmpQSmFU?=
 =?utf-8?B?bTZyeldWR2g1UWxaUjZEc2pjRFpGUWxGVFZCcXFGTVl3dHkxeFVjK0NMVHlq?=
 =?utf-8?B?b09nckl0bHRXUTlvaWkxdXMvL29vYm96MEpuS1NFUzZhaTAxSERWRDBqWG1Q?=
 =?utf-8?B?NzR4MlpmeStLamhSMlU4Q3FWa0tCa1ZOdlh5YnUrMGpoS3BzNUpHSVB6NXp3?=
 =?utf-8?B?T1poNExJdm51WlJPUnFjZjV2K0wxZDhmcjZpK0xaMUxJRlNOUkU2eVJiL2Iw?=
 =?utf-8?B?a2k2ZW1ydEMzYml4dWo1R3hsRVNRTVZROXJuS2N0UytWblk3Ti9pc3pYUzg5?=
 =?utf-8?B?THNZekRzVEcwZm50TTdrcWRSTUhVbmp6Lzh5M1JxZURObVc4S3M1dnRJTWUr?=
 =?utf-8?B?dWNNV21nekhMMGhkaUNxalg0UXN5eGFLOW02S0ZnUWdRRi9CemVlUWFSbHFz?=
 =?utf-8?B?YndxTE9TU2xzZGZ5YlpHSFRBSmRMWXVWSVN4RHhBdE5Vd1IyWEx1aTNkMGh1?=
 =?utf-8?B?MytoMEhVcWhWYmwySTdqa0ZMaU9TU1pHaktSUHNvMVJlb1hXbDZwUlFQMmty?=
 =?utf-8?B?dTRXektUYzU0NEFMY3lCWk5OdWV6ZmdZekVya0VHZTZud3VaVEo3RWFwMm82?=
 =?utf-8?B?clhkRFVCTks1RlpYZHJtMnNPb3plSHRZcUxaS3k2d3FDU0hyMStGOWNVYkZQ?=
 =?utf-8?Q?PceRozIJxL9lVOtA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35E889B6D7EB794EB44FE8F45DC9246D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: WgS1RB3Kd1DKGBWe2vP6F9CjZI5//V0p0FEUsrZe8m1j5MJjIC0kgGm4r1WHqArK8+JSYPYqqnapsZdToK+KSLe4NRz6UF0kkwbwAVQjB3WJlkafQUwVedah/FFr7py6/QFKqI0zs58R2KEhPSG7ZEGiSJWLaEJFdLWeOhuA3EyD4gW5/UyLS03WI9+6rTD9b42tctjp1zQdtelyEYIGkj8a4OVCKabBKzVVWRIPSSteRkxgGijMjFV14MrSTMNWdU0YJfQxzCekWxQlzq1BKXpUM0tVqpLI6ScWf9DAiTLuPSKoTg4LMn9l1PMNqwtIEVIlR9alRUOPphCNfWxBlQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5613cac-465a-4865-04f9-08deb259e3d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2026 08:13:47.6715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K22XIcavsXomTspNUFp8So6BNZk2PkT6yvQs0394dNrG1QqI2IDzISCFE0OhMegLgrsPksURYY1xA+PKh1bwmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB7174
X-MTK: N

T24gVGh1LCAyMDI2LTA1LTE0IGF0IDA5OjIyIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IE9uIDUvMTQvMjYgMToyNiBBTSwgcGV0ZXIud2FuZ0BtZWRpYXRlay5jb23CoHdyb3RlOg0K
PiA+IDQuIEluIGJvdGggdWZzaGNkX21jcV9jb21wbF9hbGxfY3Flc19sb2NrKCkgYW5kDQo+ID4g
wqDCoMKgIHVmc2hjZF9tY3FfcG9sbF9jcWVfbG9jaygpLCBzbmFwc2hvdCB0aGUgc3RhcnRpbmcg
Q1FFIHBvaW50ZXINCj4gPiBiZWZvcmUNCj4gPiDCoMKgwqAgYWR2YW5jaW5nIHRoZSBoZWFkIHNs
b3QgdW5kZXIgdGhlIHNwaW5sb2NrLCB0aGVuIHByb2Nlc3MgdGhlDQo+ID4gY29sbGVjdGVkDQo+
ID4gwqDCoMKgIENRRXMgYWZ0ZXIgcmVsZWFzaW5nIHRoZSBsb2NrIHVzaW5nIHRoZSBuZXcgaGVs
cGVyLg0KPiANCj4gVGhpcyBjYW4ndCB3b3JrIHJlbGlhYmx5LiB1ZnNoY2RfbWNxX3BvbGxfY3Fl
X2xvY2soKSBtYXkgYmUgY2FsbGVkDQo+IGNvbmN1cnJlbnRseSBmcm9tIGRpZmZlcmVudCBDUFUg
Y29yZXMsIGUuZy4gZnJvbSBhIFVGUyBjb21wbGV0aW9uDQo+IGludGVycnVwdCBhbmQgZnJvbSB1
ZnNoY2RfcG9sbCgpLiBQcm9jZXNzaW5nIENRRXMgd2l0aG91dCBob2xkaW5nDQo+IGh3cS0+Y3Ff
bG9jayBtYXkgbGVhZCB0byBvdmVyd3JpdGluZyBvZiBDUUVzIGJlZm9yZSB0aGVzZSBoYXZlIGJl
ZW4NCj4gcHJvY2Vzc2VkLg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg0KSGkgQmFydCwN
Cg0KVGhpcyBpcyBub3QgYW4gaXNzdWUgYmVjYXVzZSB0aGUgQ1EgaGVhZCBpcyBwcm90ZWN0ZWQg
YnkgY3FfbG9jay4NCk9ubHkgdGhlIENRRXMgZnJvbSBoZWFkIHRvIHRhaWwgd2lsbCBiZSBwcm9j
ZXNzZWQgYnkgdWZzaGNkX3BvbGwNCm9yIHRoZSBJU1IuIFRoZSBtYWluIGRpZmZlcmVuY2UgaXMg
dGhhdCB0aGVzZSBDUUVzIHdpbGwgYmUgDQpwcm9jZXNzZWQgbGF0ZXIsIHdpdGhvdXQgaG9sZGlu
ZyB0aGUgY3FfbG9jay4NCg0KVGhhbmtzDQpQZXRlcg0KDQo=
