Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EDC363084
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 06:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773817061; cv=fail; b=ZdKtuEY9eefb6W+lg8CLlMX0WzvIWJjY67Ui2wQ6bHB7Fl17ElhJ//wrZEFd+524y72Tag1Qcv0UNwaF2WDc6c1pViJkYisvoYtZMzq4G9HkSBbBlnlr/yqd19ZnTLvfuIUOxzRfEGwRYwt4xYwXcMG1IU2H9gxKJWFEBCqI5rI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773817061; c=relaxed/simple;
	bh=bp77fyDJoSUbOqzExWV9ukhaWAtJt5wTMBh2gZmMbws=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WQySsY5zBhru63I5w/XQw/Ix/jGXigFM1DQEvY9T4rze+h13/EVRFXfEPi+7EC/pEtCwtcncbUmgfh8hL6BPJnH0jBZFN40PZGa8Cv8DhjeSjLXZ4vAgZ/e9EwSXgvag5W4ArGghtx8BKbVe+cK/Rw+pO88MiqnQcMSknfWAiPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Wy1hfyRK; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=V7EOyk9n; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Wy1hfyRK";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="V7EOyk9n"
X-UUID: b9f01124229711f1a02d4725871ece0b-20260318
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=bp77fyDJoSUbOqzExWV9ukhaWAtJt5wTMBh2gZmMbws=;
	b=Wy1hfyRK+Dp24xCj48+i8veOgdLyNRHY9n3B0UpDKFgC1cR7RP8uy8JQMppdYUe7k/g3nh8ttD8R/eiISO/2+3P3fXZKYxsYCE+585nLLSIBQrRWlLsvNj0crNbXD7uUXjgx25pQYGSCPQ9g3bGBItW718qfAnHkVQRnGtrZai4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:872c5bcd-52fa-425a-8d97-71dd9530ccf2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:a107d616-aa6b-4b2e-be76-373ef1a42b04,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b9f01124229711f1a02d4725871ece0b-20260318
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 611725652; Wed, 18 Mar 2026 14:57:28 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 18 Mar 2026 14:57:26 +0800
Received: from SG2PR04CU010.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 18 Mar 2026 14:57:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yn8bnw3uoyuY1kZ8myPfR0UX26Fh+TGZTlfVILG40QJ7gs/LKhMeLQ7sZLqrXt1jb4I938/+SFM3SzTSWuhC/CqlUGF0DwObziXhcFOVrRiievo0KV5nPCC8xMOdJvRpvLMg/YwAI1be84OVKkoAcgwMHDc5J8MsxgQD+q2o1Clk+J6RgeXu4MxbrXy7SG8YRbACxGPGKRaKsEHxsrnDnDCJpfCS1kqndb3YuQbKitY3GVgtCebpIbv8B5uiyyE9IHgLXZRNKLncCXcsp/FxWvr+CPPKS1nGXSShZ77FFbpMhs/auCNCWZEajAy8SUAUqWbJwTLgEuaNCDnulvcoRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bp77fyDJoSUbOqzExWV9ukhaWAtJt5wTMBh2gZmMbws=;
 b=ZZpf5gnMJIpTJiLWNbRzx3WgYnNYA7M4pImy1qcPAYNdm9fUySpkK6F8Doaq/7O7jSZ60ed5d+dzPSDb0Wfvc2VzO7Yvhi6jGYe+QPhaSqWJC4YWQ6HV6u5VMBG4c/OcwSNleRQ45jQPtfW8Hpesd/LLd2ms8zEBVpkaPqGc8gBu7Hgj+zUvPfSs989SgBxRjUZOl6fwsbO/W8VuIcT8T2xTdntx90ehHzVyaSC9fxjUZP1Ko5c0XikP4CYccZsRZAyN9LIn4drhdm4nxn1hg5vNAgcutWpcNRgepH0iRXpLOhnw04ve3XZydSuea9pLJwnttpFdraTyvsxNQHqA+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bp77fyDJoSUbOqzExWV9ukhaWAtJt5wTMBh2gZmMbws=;
 b=V7EOyk9ntsklLUvyq9DG23ADopJD2ucuQnWMTjLXMljrQloNorsKPSWgPdmI/L/IuKqOlBoAvA9bb/bfFr8wJvMlIGosLbwT5Ka/AXITU63fQiJJA2WFl3QTLvSeIyYDhoVh4NHK7q2RS2bUrDxIiEKXGF069b8gaKTTG8dJ0+s=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB8424.apcprd03.prod.outlook.com (2603:1096:405:76::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 06:57:23 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 06:57:23 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"m.szyprowski@samsung.com" <m.szyprowski@samsung.com>, "jejb@linux.ibm.com"
	<jejb@linux.ibm.com>, "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: "bvanassche@acm.org" <bvanassche@acm.org>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
Thread-Topic: [PATCH v2] ufs: core: Avoid IRQ thread wakeup during active UIC
 command
Thread-Index: AQHcrSxPGnfAtrpK0kOvBMCDgGF4JrWzB9eAgADmwAA=
Date: Wed, 18 Mar 2026 06:57:22 +0000
Message-ID: <a341a70943ffb8b8c5bbc9b4e19c017fe664fdf1.camel@mediatek.com>
References: <20260306054419.3816557-1-peter.wang@mediatek.com>
	 <CGME20260317171131eucas1p25dd55bf1aad6d5b310526d51885b3b7a@eucas1p2.samsung.com>
	 <1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com>
In-Reply-To: <1f88b91c-59e6-4347-84c2-50b7cf106c47@samsung.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB8424:EE_
x-ms-office365-filtering-correlation-id: a5f43fef-6b31-428c-bb6b-08de84bb9b2b
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info: 4PUF7Cjm5y2YcUphJDKxOiDjq9m4w0Gk1bkYPyS30BsndVIZB3l5LJ0ew3dbwZwtEEcghY13TwHUk89EBJ/GSxtAb7aasLHzOfKtffhxXlWBjD+Hz3OGNp6xttIuSxLchGAOiugKlAoQJifQoOIbDUiCTfJroZMvr09ljwqohxw8Cnml5Fm6IiYaA1kBh4avFPeCzBJ26XysiND3eoMo0WbkE9+mGAwkHiDQVP1/1gIu/QZmtakCQAkMUiLabBYpfSu34cBjguHjozgt0TNvYM2Nu845EnlLetjX1rcSDvq49INgX5mIL3pptV3CQY3NG8JB7N44VFfyzxFXJtRRw4PaY5ydGvTLMYFIgRp6p+vR2K7nYQMhxUr7KQpy45xPGxwewi2S6O39jz8j1n+kgc3YbRyGGRfK2wZD1zTtKiVYeVMahnktS9gBvglnLstQAtWtCPccX6OCdZslrDDZ3gtVAiI+IxIdpWmhrLuQaN4vh5/+wWTWN5NSnLyFdWy2EEAcD+9z0tXcthmnSl/CjhZvFU4w/rBNEDzHhQQIe00XOG9h25rHZ5zZce+SaaR0of8ZQ6la2SYexRl9nW7ObUOuljAL87do7FykHYw58lEFpXQ5ZZahRY+5Dy2Elc7GTRCbrEGXEo3IZAcIBVTfTmCjeoAxSaRJ31LHYMQ6xqBZxEdBFRIfvMzA0GS5v6aCFbcFmA4wTcgN0V5WpessE/R9kWKiWF+MdXfQxZagSQXjSVwAX/wJ4rIzzevdLrhFZ4ixJagEVQIQI92y50zbHt0vA5nu9tAt+F+6wH1Toss=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1ovSWh6cERDVXRpb0ZYbVJrVVh1Z2xYaGRCRU9DSkVMTkMxaWlCWFA2Q1I4?=
 =?utf-8?B?ejRNWlQ4Q2FlWmZEblp1Zi9VUzRkTnZlTmxOdE5yaEtWc09ZMGlmSWNIWkVs?=
 =?utf-8?B?MFVxeEFoTVYyYTFpWUFmZFBQSWRtMjdQcUg1cTljQnlJeFAvM3NVYjRzN1Va?=
 =?utf-8?B?ai9ybG81WDZUNHVCem1uUHV2YXQ2Zm44VHByY0g1MEcxWEQ3VXJNZTRsRzJ5?=
 =?utf-8?B?NTEwaURaYlJvcUg5Y0REZGVVOHJONUY3d0t0V240Zi9RQ2JEY3FtUmZEdEdN?=
 =?utf-8?B?QVRzNzJwck96d0dpQ3NtZ2V4RmtuTkk4cExCdytVKzY3NGtDa2JMNWhUVndR?=
 =?utf-8?B?VWp1YjVlYlF6Nk5ibkNrUy9oQzJRbGRFRUdIai9RSDVxWDlGZ1A4WW50MFp1?=
 =?utf-8?B?KzJUdHY3ZFdCbFdsY01jMUxnM3QrK21OcFhMWFEwL3M0RE8xaVdVM0w1dHNW?=
 =?utf-8?B?ZFRuMEswSmJ2RzdRMlcwaXY1RHlndUdxMnVxZmpIbmFWNmw3bEdsWTVqZjBx?=
 =?utf-8?B?R2tDVGFwdHZHOWo3WG5qUm9lYUlNc3ZodW9BYzViVWpUVWJLOXhJNzB4R09R?=
 =?utf-8?B?emlOTGNpVjQ2SzZXdnY1Y1dyb0VlUjlwQ0hkUXUzRUVmcFV5amMrY29UNDFP?=
 =?utf-8?B?NXI1YjAzMjdyMWJSSnRIbGpnUEFUMjlvWDhPUFQzM3FvdG9HRUtXb0RaRzJr?=
 =?utf-8?B?KzdOcStiMGZ5RVJ0MkFaZUowZnY1MW05NTdLUmtHbmYrQ2tJajlQeW5LL2JE?=
 =?utf-8?B?Nk9QQ2xEOXhQQzBlV3dnNnNsZ1ZPQlB5N2ZpV05BcXFoMW5mbXZWY0lFOEtO?=
 =?utf-8?B?TkJsZ3JmV2ZwMkhsTGlHRVZJYjEzeHNKN3lleGdrRjVmczR0Ty9DOFFTaFVK?=
 =?utf-8?B?enJobitVN3U3WitmVnB5cW9DK0o5bXdlRDZlMmk3UmN5MjJETmFzOExkKzB4?=
 =?utf-8?B?dWE5bzlkdllLMXpwMnlxa0hYS3FoNFNuSFJQODd6SFR5Ulp6cDIyNEpoVm1K?=
 =?utf-8?B?UEZidFk0Q0h1OHFmTHd0QlNIVkdJdCsySGczV1U0WVF6RlI1VVQreVQ0Y2lw?=
 =?utf-8?B?ZFJGT3JLUkgwQWxqWTcyYjBPSVJ5VDBTWSs2RS92TXNQY2QrN0VGTWJsd245?=
 =?utf-8?B?ZHIzd0lLT2lmZWFQdlhXQmRJNldEVVp6d3JYd05QZTFuMk4xRzBNUWI1QXpR?=
 =?utf-8?B?MUJTWmJWMGRyWUJVamtwQk54ak9RbDVWMUdUOFkrZDZSMW5TU0JRZDI1bU00?=
 =?utf-8?B?WVU0TW5uSjY1NXNmaUZRTExjTW8rbmJHS1BvdGhiWC9USEI0WElLd01XdHV3?=
 =?utf-8?B?VG1Rd0NUc1V5T3QxQmRZTUZReE9CTDlRTU53cEJnTkxHWGJPdjdINVplL25t?=
 =?utf-8?B?VlN5UDlkMWFGRmFUbDFSS0NQNzgwNHllQzY0WThsQitIZ0FiU2pod1ZjcHJP?=
 =?utf-8?B?MkhIWnY0Zjk5SU81aytLd1BGaEpkaElCMzVramJEUjkrTVJsSVI2Wnl2RWp6?=
 =?utf-8?B?Q2ZjRkxObXhySzhhQjVsSUFCaUdwai9QbnJwL0xTZUx1bStUSG1TWTV6eWFO?=
 =?utf-8?B?OGtQMUJnaklnbzRtV1Y4UUhWajc0enA2cnlMZG1tSXhEWUFyRm9leWlIdFVO?=
 =?utf-8?B?YUU1RDVCZGgyVWgvVkRkellQV04wVmJ2UkhKQk9mVjRjamNjdWxha0VJZGpk?=
 =?utf-8?B?c2JuamNhcUZGanA1NEMxZk5uVXA4bThSejM0QmJiN01pZlVIMlFtNWQ0SVRy?=
 =?utf-8?B?a0R1S0pCMnM3MnJ2aGVwYUE2QUZ2QnAyclVzS2lORWYyaHdXZm16Q3ZTVkZj?=
 =?utf-8?B?dDdqRVMzbyt5cDRnbXNYYS9Yck1vNHl1aUtYbjExU0hHT3VFVU9iOWFMVFBs?=
 =?utf-8?B?MVBEeFZqbVdzZ1dGSmFmSCtwME5ZOTkxS2Viak5NRTBSelBITWVCVkdlNTZJ?=
 =?utf-8?B?dGlMTHNGemJoYzRSR3piRFpOQUk2UUJNWWM5bllTM3FuTE5YNHlvRFZEZDF0?=
 =?utf-8?B?TzNKd2l5d2FvY2JJbWlBa3F1N25Yc01nNUJweDlST04rR0s3MWxuTTk0NEhr?=
 =?utf-8?B?N3kxTU4wRUpBZW9WU2pmVUhKeU5UTFJmQ3kycDY1bXBXQjJzMC9OU3pWcVd6?=
 =?utf-8?B?RWEraE1MaG1EdDJvOFZaMHd6QittcU1BMUpQZGhYejNOTGZkaXRJemoxakpT?=
 =?utf-8?B?OUROd1BKbWVMN2cyekpzOEU5cUVaYU9xOW9uWnRxTlJoR005d09icnNDdC9I?=
 =?utf-8?B?TjFWR1ZzNkx4dTdoUzcvTnpGNlV6M1BZRit1Nmt5T1VqbjM1N3NjWUwvOWp4?=
 =?utf-8?B?aGp1Q0NJZkc5TVB4NXZ4NWp5U2NsMmJEbkZ0WGlEWHNJZkl0QnFGK0pnYUJq?=
 =?utf-8?Q?6b1BJQFbwzEKiWdc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA670E2E498DA148892C8C70A9E54DA2@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: oBc9zAp6AG7MlPWdl8qu5pXh9CLfDeTr0ohy8q37DIyRc2BexQluMJhXL2Ro9lHfQgx6JN/MhbGJmaQQ3iRboREqSbnEVK6AA+jkznhzTZAILZAqLSC3aa4ODTS1Wc7yimlKPvjIXSnB1akLlnnZ5uyvacJTSVzUS4WaWUGdryoACYM97JYXfwd50HupELx5vTVWrM3qgoqYyvhSuIeiyRjJEk72xkJwSqELWcRkpq9deA/bjwkbnSciRoNS9+owMFH6luBM4ILM3Mu+abgeolEgUh+58kqXW+vCdDBtt1vNm1vb6rwd3j+JuujXPX+3ENZvQjg7hg9vbEgWvnfLhw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5f43fef-6b31-428c-bb6b-08de84bb9b2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2026 06:57:22.9913
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ka2qXI3aNzbhB1dbRhU/tUZyBU48x9DXM3pWUGrJrBeoI2OKE6ZQW/G9s9JW9mVk6VvWy8cHb/Ohrv7uNsAYOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB8424
X-MTK: N

T24gVHVlLCAyMDI2LTAzLTE3IGF0IDE4OjExICswMTAwLCBNYXJlayBTenlwcm93c2tpIHdyb3Rl
Og0KPiBUaGlzIHBhdGNoIGxhbmRlZCBpbiBsaW51eC1uZXh0IGFzIGNvbW1pdCA2NDc1Y2ZiODFm
YzQgKCJzY3NpOiB1ZnM6IA0KPiBjb3JlOiBBdm9pZCBJUlEgdGhyZWFkIHdha2V1cCBkdXJpbmcg
YWN0aXZlIFVJQyBjb21tYW5kIikuIEluIG15DQo+IHRlc3RzIEkgDQo+IGZvdW5kIHRoYXQgaXQg
Y2F1c2VzIHRoZSBmb2xsb3dpbmcgcmVncmVzc2lvbiBvbiBRQ29tIFJCNSBib2FyZCANCj4gKGFy
Y2gvYXJtNjQvYm9vdC9kdHMvcWNvbS9xcmI1MTY1LXJiNS5kdHMpOg0KDQpIaSBNYXJlaywNCg0K
SWYgdGhpcyBpc3N1ZSBjYW4gYWx3YXlzIGJlIHJlcHJvZHVjZWQgd2l0aCB0aGlzIHBhdGNoPw0K
SSBoYXZlIGRvdWJ0cyBiZWNhdXNlLCBpbiB5b3VyIGxvZywgaXQgc2VlbXMgdG8gYmUgSVNSIHRy
eWluZw0KdG8gYWNxdWlyZSB0aGUgc3BpbmxvY2sgKHNob3N0LT5ob3N0X2xvY2spLCBidXQgY2Fu
bm90IG9idGFpbg0KaXQgaW4gdGltZSwgY2F1c2luZyBhIHRpbWVvdXQuDQoNCnVmc2hjZC1xY29t
IDFkODQwMDAudWZzaGM6IHVpYyBjbWQgMHgxIHdpdGggYXJnMyAweDAgY29tcGxldGlvbiB0aW1l
b3V0DQp1ZnNoY2QtcWNvbSAxZDg0MDAwLnVmc2hjOiBkbWUtZ2V0OiBzdHRyLWlkIDB4NDEgZmFp
bGVkIDAgcmV0cmllcyBubw0KbG9ja3MgaGVsZCBieSBzd2FwcGVyLzAvMC4NCnVmc2hjZC1xY29t
IDFkODQwMDAudWZzaGM6IHVmc193Y29tX2NoZWNrX2hpYmVybjg6IHVuYWJsZSB0byBnZXQNClRY
X0ZTTV9TVEFURSwgZXJyIC0xMTAgc3RhY2sgYmFja3RyYWNlOg0KdWZzaGNkLXFjb20gMWQ4NDAw
MC51ZnNoYzogTm8gYWN0aXZlIFVJQyBjb21tYW5kLiBNYXliZSBhIHRpbWVvdXQNCm9jY3VycmVk
Pw0KdWZzaGNkLXFjb20gMWQ4NDAwMC51ZnNoYzogdWZzaGNkX3RocmVhZGVkX2ludHI6IFVuaGFk
bGVkIGludGVycnVwdA0KMHgwMDAwMDAwMCAoMHgwMDAwMDQwMCwgMHgwMDAwMDQwMCkNCg0KUmVn
YXJkbGVzcyBvZiB3aGV0aGVyIGl0IHJ1bnMgaW4gSVJRIG9yIHRocmVhZCBJUlEgY29udGV4dCwg
dGhlDQpvdXRjb21lIGlzIHRoZSBzYW1lIChob3N0X2xvY2sgY2Fubm90IGJlIGFjcXVpcmVkIGlu
IHRpbWUpLg0KU28sIGNvdWxkIHlvdSBjaGVjayB3aHkgdGhpcyBzcGlubG9jayBjYW5ub3QgYmUg
YWNxdWlyZWQgZmlyc3Q/DQpBZGRpdGlvbmFsbHksIHVmc193Y29tX2NoZWNrX2hpYmVybjggZG9l
cyBub3QgYXBwZWFyIGluIHRoZQ0KY3VycmVudCBjb2RlIGJhc2UsIHNvIHRoZXJlIG1pZ2h0IGJl
IHNvbWUgb3RoZXIgdW5rbm93biBjb2RlIA0KdGhhdCBoYXMgYWxyZWFkeSBhY3F1aXJlZCBob3N0
X2xvY2sgaW4geW91ciBjb2RlIGJhc2U/DQoNClRoYW5rcw0KUGV0ZXINCg==
