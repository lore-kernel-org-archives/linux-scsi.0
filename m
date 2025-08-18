Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6FD25D1EE
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 11:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755518102; cv=fail; b=I3TzZRJdPSRpR6Vmw5GWc3WxAqFjw/nQj80Wi7Jfluslmkd1YRpYnDbAxvgeXVH5PUvEw+oeTQAS81O/H4ZAB3COoS2oE8TIHBbp9DVHsCWRVPJHSYFIFqXYXazpCcp2FIpIIvNpyf45s01VM0axv2PUqMTjuvjixC1xhaDKfqc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755518102; c=relaxed/simple;
	bh=bhE0l9366kkCMJ2CGh1mBWTcQmaYREzuNFa1a+HI83M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uwN7nONTfz1ipOIY5p3rUnpA0/ffIfftNAjKfgkHH1URYRXAljPdmyAE/vpNKnSabqt+KaNUx5a0mmPcBBlxz3HdH6Zh9R2/O8U9zRJ8LTUjV18S6vyu0pvPgwSnwTi8iFRNQbR4w2TsEdCxPg+QIWpOZcwWgtWtjBylNWWnYCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=SBfe7yJw; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=IYdnzoRB; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SBfe7yJw";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="IYdnzoRB"
X-UUID: 27c9148a7c2a11f08729452bf625a8b4-20250818
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=bhE0l9366kkCMJ2CGh1mBWTcQmaYREzuNFa1a+HI83M=;
	b=SBfe7yJwiKZfw3nO7oHLDLv/N4Buj4GJA85VMvOh7Cjm2Cq53eNAaH7H+cHTpMnreoOmsqT0dSR0LpENtP6CAXxcaLUQgwQxgOBfoL/VoZEAcEbMNMjZARZPKVPQeBiX+9vbM65P8HWRgk1nxw737KGF2vMp+kMkU3gsdBdLVUM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:13bc5430-208f-4d09-972d-1f3b201bfbbc,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:568e9844-18c5-4075-a135-4c0afe29f9d6,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 27c9148a7c2a11f08729452bf625a8b4-20250818
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1359074378; Mon, 18 Aug 2025 19:54:54 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 18 Aug 2025 19:54:53 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 18 Aug 2025 19:54:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u4GcE7rMFyzxDyWHGEkYBBEMIHP08/Bw0lFNDIJgHt01PqGLp3Aqh9IdBau94P0PjR8MsYAODkliti1A1U6xVdci/iYhfA7x0ydzMJWms5SwN7BBpqfK3kpQkklKh19W1HiUeTpzUjCTQ+i0YjnBIzJBZ1B5KOkjc1WnHp/AO81P7uus6co4tLI9Zaa/tyq6mxTBkdT4vtDvqbAJAwSkhQvxHViU06ccDsKL6r+MQe1mnhvvYRTQi3M62jsZ1548IQIZet/fidxRFlDl7WQmRNSNW1Rknw8J9h7Up3pddll1vhSMYFwZJhST0YxEKcKyFq0kfMGmIIcV1rVyKq8Dqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhE0l9366kkCMJ2CGh1mBWTcQmaYREzuNFa1a+HI83M=;
 b=Upv5aemZYnGSztVYF4DQOJ2VzXTOCFJtCqyrC92lNZ89aPIxcBeG5hX29+3r5O3rdKANiBoIHdVL3jZ62JR5XAbYTVTCvPVoA0bK+skH0e5H2GBKnoQAl9saYXkDH2zybdKThlRo2UpGCiqX6UkAHsX/M3NB88jyxLSpyoNxn3RmwBJO40dSJJJsX3s/NrzZcmugpHkAwX+FIkHXlylnwrPyJAR8ZBtISrUcIyhf4ngpOqByd0ca0OqprOg1YUHg+tZDqh91kfS6HtzA4I7q42Dzpqpg5+CKeddVKFZ+ayyM4UAaJ1/iCKgh2+oGrBCUFhGQ7zCbR7xgbeH/xSYlcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhE0l9366kkCMJ2CGh1mBWTcQmaYREzuNFa1a+HI83M=;
 b=IYdnzoRBPLtoEnjGwIR4ArKnrDlnWeydxs5K9S9FvT7cxKnN3wT4F1fmbk4jh1wz+0ha7/d3UHYw5UseLZGQ+biVXTF9/NbbSOCv+XLQTWDxnd9PMUT0DaLLW17vLPqG4qQBWFea1uXu/JBnhbr0H7S3quIyVQwcU5/DQKbJD3I=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEYPR03MB8742.apcprd03.prod.outlook.com (2603:1096:101:204::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 11:54:51 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 11:54:50 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: =?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, =?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?=
	<eddie.huang@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?=
	<Lin.Gui@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?=
	<jiajie.hao@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, =?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?=
	<Ed.Tsai@mediatek.com>, =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?=
	<Alice.Chao@mediatek.com>, wsd_upstream <wsd_upstream@mediatek.com>,
	=?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1 00/10] ufs: host: mediatek: Provide features and fixes
 in MediaTek platforms
Thread-Topic: [PATCH v1 00/10] ufs: host: mediatek: Provide features and fixes
 in MediaTek platforms
Thread-Index: AQHcCsHfyD7VE8x14kar1OwMZgVUf7RjEW42gAVG2wA=
Date: Mon, 18 Aug 2025 11:54:50 +0000
Message-ID: <826d4477effcdc15fcdcd96091bd84fdf73c7e00.camel@mediatek.com>
References: <20250811131423.3444014-1-peter.wang@mediatek.com>
	 <yq1h5y9qnso.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1h5y9qnso.fsf@ca-mkp.ca.oracle.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEYPR03MB8742:EE_
x-ms-office365-filtering-correlation-id: a3579211-7cfd-4d81-efbe-08ddde4e09a6
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YkRSQ1plMjJncWVwbmxaTlV5RFM0R3VZRDY3TisxUFVNVU1FbS9vQXdYcjIr?=
 =?utf-8?B?YnJ3cGNyTUJjWk1jMHk5Y1publQ2U282SU9YU1NKRnQ2SUJteUpON0JTMEpu?=
 =?utf-8?B?MjVmT3dabzdYaTYyWnFyWE1IMnU5Q0tDRVV4T2RjSTM3VG9wUElqQXhWTXFv?=
 =?utf-8?B?Z1cycnZFOVNpRGdGN1ZpNW81ZDNZTkhiSitNQ3JpUi9CQkh3azB0N05YbTNP?=
 =?utf-8?B?VlBjUkZGL08yVmNEMEI1cWoxWVhidGdlZDFQYUExNlpVWUszbEpoT1lBd1lj?=
 =?utf-8?B?MFhXeVdKQW5ZZUE5T0tVRFdOTmRsM1hsOHVRZTdKSlc4UnA5enZER1Y5SFIz?=
 =?utf-8?B?Wk5EN1JTa2ppVnN0dTErTkQ2c0diQTdRYVJTb1VzVFkzSXZIc3pBd2FGOVJ3?=
 =?utf-8?B?UUxTU3BGTTdHUk04ZlMyV0xCeWIwMThyV01CejF6RG12ZnBoNGloaTg0L2hW?=
 =?utf-8?B?b0cvTjFqczlzV3ZkOG8zS2xpYVB0TDJrRlZkTTJjc1BJWm5RbFZlVjBhbmFu?=
 =?utf-8?B?Yms3d29lYWdSRW5aWkxTTE5hSlB6R29WazNxaDJ1b1NMK3RDOEZJNWFOSEdt?=
 =?utf-8?B?cnFLVGJXRzliaitsa3NHN0hiaEx6ZHRsQkZWNjFDaXh2Qm10VE9oNlVFOUlD?=
 =?utf-8?B?Y2RuTHRMRk9STnM0ZVJpZU9TZ0JkaERtR1Y3amYwcktXbjE0SGNiTWltcnpT?=
 =?utf-8?B?OElpRUNjYjVZYXZud2J0ODB2d04rMSt6ZjVuZmhFM3VFUG8wS1l3NENxNmdN?=
 =?utf-8?B?TFNtc1VLNkgrTVQ0NDhzd3BBTXBTekFQZHJheDFTVnpsam1Idzk4blFUa1dR?=
 =?utf-8?B?SUNmMG5zcmdaeVJOd1duWjB3QjUwMUhhUXRYdkV2d3g5THl5dVJrd2VGdXIw?=
 =?utf-8?B?aFlxUTl2aCtFOHJndmNDemtWS056TDlad3BWaTdCUjZIT3FrcUkxVXM5SVRj?=
 =?utf-8?B?VHM5bmtDd08xMllnWjN6Z2oxakJqb2RNaUo0K0ljQUxWa1REcmpzT3p0bGZn?=
 =?utf-8?B?WWE2UTV6ZWFOUjdnU1drR3BTcEIrYzY2bWMvUnF5ZFJMczdPbGFvd1RNVFVB?=
 =?utf-8?B?V2JpWGROVEVoY0VHZGs0OTU1aEQwMWhxblphVXUzbE83eUJyMm1YOW9CV2JX?=
 =?utf-8?B?TUxGQVg2S1ZYUXZJM2ZzcEdhYVQzbDB4R3pMNHZGenNZamROUFVxa1FsWE5L?=
 =?utf-8?B?Wmh1Z1c1ejJpeTYvSko0aHdwTDF6dzJMOTNxVDUxa3k3V29YUEllQmExaVBF?=
 =?utf-8?B?TkVCMllSb1lPRzNWSUlFajJiNHB1dE1TRTR0UnlaeURoVkp2ZXc4bC9hdXNo?=
 =?utf-8?B?ZjNMK3ZqdmwxNld4N2tYWWFxdTMyZHlucnU1M0Q0TTg0KzIyOC95WlRLVnNu?=
 =?utf-8?B?MnVwd0JsY3B4K3pLWGw3aC9lZEtHMTlqY2J5L3NWbkVGVnRXaWtPSnhYOUt0?=
 =?utf-8?B?RXF0T0pFdzRxelJ2SUQ4RzBjZ0g3bUJ5ZXhnYlE5M21NSzR3QjdYMURESDRG?=
 =?utf-8?B?UmZUYnJROTZ5U1o0d0tDV28yODAwdi84YXVnNFo3alVOZjJkTHU1VjFZS29B?=
 =?utf-8?B?ZVRCb0pZNEg2RWtFRWdMWlNNbjIvQTBLb1FNM3VZQ0hidkNrVi85MEJYaGpa?=
 =?utf-8?B?cnZnNUNFQlkwWk82aDdTS0J4dEpFUVFodVBpMm5tdXA2SWtlU2VWdjFhSTVm?=
 =?utf-8?B?VVJza2ZMdS8zRFRUVG8vdUo0S0p6WkZWOC9LM3ZFZ21QT29MZWN0UU9QU080?=
 =?utf-8?B?TWU0dmlYYVZLajBBUFVrZVl2bkk1cTZ4ay9yS3lyeDNRT2JRWUt2ODBuSU5Z?=
 =?utf-8?B?ZjBVS215aU4wWnd0cE9yUk13ME5SY2k1ak13WkJnZDhGWVpkKzNaVUZneXlE?=
 =?utf-8?B?aUdEZmxLaUJvcUlvQlhPVGlWUmxDWWpxS2NadUdrVTMwUjhaQzRZTXdkeFZu?=
 =?utf-8?B?M3I3UkJCbmxsV1FFamc3eCtrTVo0a0tVL09YOHBmK29FUHdJNTdNQjN5TTNn?=
 =?utf-8?Q?BtlGhMeT4IWMYsep6nX9yOjlpNu/BU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFZpNlA0UWV3YzJsdWlLMXk4UjNXOFAvVmZZL2cwQjlqazgyYUl1ZmFhb2Mv?=
 =?utf-8?B?WTZsMmh0ZnU0QWlhTkRZbHFRNjZJZzBYYnNTL2MvTGxLZUU2Z1J4U3hjdmNo?=
 =?utf-8?B?U21WL0pXWS9pVU41aEZUR05XKzN6dk53R0taeGRiMVkvRDR1WW9iNWtxM2R4?=
 =?utf-8?B?M2tsQTZYWDNVckRhNEh6QmdDYWtjR3h1R3RzSGJZc3hZZngyNjFNclY1OFRi?=
 =?utf-8?B?VHlhcFZUKzNnTVZTVzdWaFpuK0ZIVnF3d3NyY296VHNITUpJdXFkUXA1MDdQ?=
 =?utf-8?B?VEhFR21lM1FSUWtVeXhoVXUwbXVMKzdaTWNlb20vSVVHUzRjL3FmckVUR1Vm?=
 =?utf-8?B?YXhqcWh2bldyWWxBWWxadmt5ZzBwQ2Y2QWFHb052V2xiMDJ1S3IyVlpwcEd2?=
 =?utf-8?B?M2h2ZDMraUNKdzgvVkdrU0xIcmdlbSt5ZXRMcVR0UEhNOXErQlg3MHFWWGJN?=
 =?utf-8?B?M3RMMlpLbkVwb0tiek5FcUVVaUtYVkxVNGEvUUMvMFZOK1p0SFh0cnNEQVIr?=
 =?utf-8?B?ZXYxSnVnaXFIZExyMU1DVTloR0p1NXNHNVV6TE9WMTNJUWdZaU1UMG9iZVRa?=
 =?utf-8?B?TkV6NXFxR3B5Q3BkNmZVTE5ZblplV2lNTTJKUExadyt4TUw3alhZY3Zlb0xY?=
 =?utf-8?B?SnZoejhBUC9FRFBJS0dhUDZxVGpIUFkzZEk0bjJvS2RkQlIrdzc4MldnMytT?=
 =?utf-8?B?MHhucThwOW5nUS9yeER3QlgwMllWYlo1eGI2Vm4yTytNcXJ2aUlIb0NnTXZN?=
 =?utf-8?B?cE10V1lWbittMStyUnNzdGh5bnI5YWJoWnRva3VpeTlXYzY5Nm83OVpBaEFO?=
 =?utf-8?B?SFJhUUNVeG4rak05MlJoTkFSeENqOVZkRHZOS2k5R2FPdFU0VDQzdVhOdUlN?=
 =?utf-8?B?WjBuZndLMzVsOUFJbmdhS3l1ZTFsU1RadC9IMzVkdkN3bjh6TXcwcGNNZjQ5?=
 =?utf-8?B?YzRySjZPUnBTcTI1V2RoNWlTYXB5MGMrbzBmaGZ0eGVLVXF3WURDcjAwZmxQ?=
 =?utf-8?B?M09vL3dhaUxiOTdqZU1lVkltZlRvZDJYZ0lJMnBJRExNekVDMFVoWVgvMjhi?=
 =?utf-8?B?WmFydGR3SVpnOGNLVkFiWXVkQVo5RFJJL3BvdU9jcVpMM0xCUUVCeEZvU1pB?=
 =?utf-8?B?b1JWTUhvNTBZUUNRMUpVc1V2eUJHSnRuWEZNVk12UEM4QndNaVVVV0Rhbnkr?=
 =?utf-8?B?MnRxaHNPamkxUU1CT1AyR2ZZNldYSlh0T0hiZjF4aWZGVUJYcmJVMWNZUUt1?=
 =?utf-8?B?akpiMWJRbjVpREU4UTRSakZvUUdydzJqNXVwT1RuS0tyZ044RmMxK0JBamhl?=
 =?utf-8?B?Mjc3R20xcWZHYUdsd3JxYzhnbGZwVU5VRThFUkY4YjQwWkh5MzR4TWZmcXNl?=
 =?utf-8?B?djhPTEs3OSt5UEthQ0VCSWRPVS9jSk55cVBZTFhaUkVmT0NOT01qUmYyVXpo?=
 =?utf-8?B?Zzc2RzJiQWJtVmliNEVZaWxrV1ZWNS9PVUJURE5sR3NyQ29CU2JoVU9Wakh6?=
 =?utf-8?B?K2dKVlhuRVN1VWFZNGRodDVyZnVoQnJ4eUVpWDhHVjFmYXFSazZ2aS9Qckp2?=
 =?utf-8?B?eGdYOHhkbE4wMUV5azlubWtOd2I1K3ArbVVWb09uTEF5ZUxzMFZnMVpicVJj?=
 =?utf-8?B?cWMvSUo3cXo4UHZ5U2hnOVlxZU92T2ZKby9yS1dwallJM0pOZS9TbWtHeHhz?=
 =?utf-8?B?NGhJZ29OeTNIRTVuSTJZcFovNHFhNDNwcTZ0RFEva0U3dC9mUmtRTUZFdmc3?=
 =?utf-8?B?UEdTYUtsS3R3QXMvdm9obUJ5WGhkbVpFbG0ySnNrRncrYTdBMmhCY00vSmRY?=
 =?utf-8?B?SjZsLzM2Q2lPdThaeDkxQjVzOFVvU2RMbHBUTFh1eDh6U3A4OWhoaWhRdFdD?=
 =?utf-8?B?UXJHUnRSVHk5clAvZnNTa2ppYnA0RlI1L25kZ0VldHBtQlp4SEt6YVAwdlZz?=
 =?utf-8?B?di9rZnpMR01YK0cycThadnNPTldybGl1dEVzMGtXVlNIVFBJSjVscEZKd2sz?=
 =?utf-8?B?M05nbytqMGRqb0lnTHQ1VU9vMU1CYThoMDI2OUJQMUFSR0ljYWZiL0g3Tlpz?=
 =?utf-8?B?V1BieUVTUSszUnZaOVhVaTRTZzk4L0ZkMUU1TFRIL0xON2hrekNDeUQvMVRB?=
 =?utf-8?B?SXNLbGN3Z1Fodk5SRCtJbHdZWTJkL2g5QjR0NGdVNHRYbkZCd25ia25nUHBv?=
 =?utf-8?B?Rmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3FB294EFE347104394A1550AB5D2366B@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3579211-7cfd-4d81-efbe-08ddde4e09a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2025 11:54:50.6622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CS4VdJLojZNXNzBdlDbUGxqcBQt1ocuWEoh+jS7E3PCZaUGpwfzxvTXX0H527AlNgn5n9g2LwKXny1exa77XXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR03MB8742

T24gVGh1LCAyMDI1LTA4LTE0IGF0IDIzOjE5IC0wNDAwLCBNYXJ0aW4gSy4gUGV0ZXJzZW4gd3Jv
dGU6DQo+IEFwcGxpZWQgdG8gNi4xOC9zY3NpLXN0YWdpbmcsIHRoYW5rcyENCj4gDQo+IFBsZWFz
ZSBtYWtlIHN1cmUgeW91IHVzZSBpbXBlcmF0aXZlIG1vb2QgaW4geW91ciBjb21taXQgZGVzY3Jp
cHRpb25zLg0KPiBFdmVyeSBwYXRjaCBzdGFydGVkIHdpdGggIlRoaXMgcGF0Y2ggPGRvZXMgc29t
ZXRoaW5nPiIgaW5zdGVhZCBvZg0KPiAiPERvDQo+IHNvbWV0aGluZz4iLg0KPiANCj4gLS0NCj4g
TWFydGluIEsuIFBldGVyc2VuDQoNCg0KSGkgTWFydGluLA0KDQpPa2F5LCBJJ2xsIGNvcnJlY3Qg
dGhlIGNvbW1pdCBkZXNjcmlwdGlvbiBuZXh0IHRpbWUuDQoNClRoYW5rcy4NClBldGVyDQoNCg0K
