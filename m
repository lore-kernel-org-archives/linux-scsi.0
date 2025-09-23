Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FA57464
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2025 05:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758607021; cv=fail; b=hRgE+xLsd0mk+rNtaudH2Z5m786v8aHzM171Q0kjyMezYXYBzVamMuDcaiqDdsk3Zv12ognpIf4gUDRr7Xw3wN1r0kfrHFGPuzrrCm5f095/MpaLUQbCUVXWy6QagwNtYUJOCiqvbRG57YnPqz0NJMKwZuntsdQ7zLvXTsfMZU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758607021; c=relaxed/simple;
	bh=q8dd+5DvJV1MNZ4sutPSmUu6at+KExid+CWzDWiOv7g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JVwyjk+TExFLYlUuE/Igc3UmHF7KYP7NAICSGFIypZp+5XnCMVHy5JV69yRX6PnrDLvpzvsb8aqfPWQWy+/v2WIFwbGIeP0L617ZSwhaANKdn4rSSvRoEZeTvoHB9Hdh4yyqFoNgXVmC1zaZgWWP7snyjPeLDoqFucJxPwVNgUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=py4pDiFb; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=D+NSv73O; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="py4pDiFb";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="D+NSv73O"
X-UUID: 1a7e0144984211f08d9e1119e76e3a28-20250923
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=q8dd+5DvJV1MNZ4sutPSmUu6at+KExid+CWzDWiOv7g=;
	b=py4pDiFb2/gZCXLw52GrdNRsZOmpudsvBbfDvP6uwCyVspa7EnG5RdL7u0kbJxIk1sHem7ZjLAGKrqnimwPh3v/ZnRcWvWsocPJJYneIwdaayQMsxO6E7CtatU70A9fKVE5DvwhYlyzwJ8PlY9pgvIpEWghWGx/CgQTpZgUwTfc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:48a93b11-d581-47ba-9905-63b9e0b963ed,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:ae661485-5317-4626-9d82-238d715c253f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1a7e0144984211f08d9e1119e76e3a28-20250923
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1379769013; Tue, 23 Sep 2025 13:56:52 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N2.mediatek.inc (172.21.101.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 23 Sep 2025 13:56:51 +0800
Received: from SI4PR04CU001.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Tue, 23 Sep 2025 13:56:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xg3xIRvxgeYbgJrh6PxtYJnL4xF9hTw1lbOV4UCocxm4y5a9NH+S0hAA5M3SiDAgdT1hWh/oI68Edn/MseKCMEkwg2Q6tH1FQwsIxelTeBO2Y3bEqkZWlzVSYv/tpI94alMmEUWDh48YTvTy3zF9/tBiAC3+lUf2Wt7U6QU8wAT+yqZLc3zrJm/wMVQ1y6AchgoVoHqqujgPXEU+CKnGFq8y1vuqLDglu/2KXsBydtLv8JMKACCqSGi5iDfzg1Ze/A+PuREs8qVDd/QG4ArHEht88bZ9Gw3KPqBjkjAf+s6q+gFo+h/BDCOjoMLB3j3bfuW/uWweFVASBoQbFHZ6sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8dd+5DvJV1MNZ4sutPSmUu6at+KExid+CWzDWiOv7g=;
 b=ktt1us8hMIdiAjAcejI9Jx/IfhhMiIOBoEYRZOzZVWmNoUTur1LoaqOa6P06Vl0XBoy0JnTvzVVLw3fjF6vQfenusn2VUaSGz6eiC1GoOhRC/7mRVzr+nZ5RLSSP9yEKdY/C9DxcTbORU53WzK2OfLRtFrmT19/Ih30KE0F7XjaqMacX0lCsjDHvvrVM4AY2LuF8Kf7fbufszFKMET5nw0mJqXHwvmhyxhwypz69OX2HDAriS+oF41NQjHvi9ih0oqVxszUPXQij9kQsLRAzONBHOpKzid0sKCp2J0jFac5p/sLGks96cosfQnr+YcpJjY0b9mw1xWjHF/CnCyLb2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8dd+5DvJV1MNZ4sutPSmUu6at+KExid+CWzDWiOv7g=;
 b=D+NSv73OJMx+gx3bymrB9B2/h4ZOEHrPopVgNhP01/Or3FxzZYXW5z7gcqKq+aOEqFcCTjuZ4guMX0h3ZMq8qKLtltIkXglFxyZTMzCxy4Xo2MWAd+plAGyjjxnajn3w+JwopWccaaHia6FyZG3IjNifhXDidhJGmjLgJoqkcOU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SE3PR03MB9491.apcprd03.prod.outlook.com (2603:1096:101:2e9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.20; Tue, 23 Sep
 2025 05:56:49 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 05:56:48 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: =?utf-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
	=?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?WWktZmFuIFBlbmcgKOW9ree+v+WHoSk=?=
	<Yi-fan.Peng@mediatek.com>, =?utf-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
	<Qilin.Tan@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
	=?utf-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
	=?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>
Subject: Re: [PATCH v1 01/10] ufs: host: mediatek: Fix runtime suspend error
 deadlock
Thread-Topic: [PATCH v1 01/10] ufs: host: mediatek: Fix runtime suspend error
 deadlock
Thread-Index: AQHcKIiuaKZL4LPKzU67kdo2+Ird9LSZQs6AgADmAwCAANYVAIAD6DOAgAClD4CAAMB4gA==
Date: Tue, 23 Sep 2025 05:56:48 +0000
Message-ID: <c6aac69ab53de8026702264750d2b44e716d14b9.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-2-peter.wang@mediatek.com>
	 <80a31144-852f-4df5-802e-a8c5d04a298a@acm.org>
	 <bdb6ee1402ae4c9ba8919011b1d8fcb9d984129f.camel@mediatek.com>
	 <bc612c10-a4eb-41ab-b8e5-726d22935518@acm.org>
	 <4f8d4f0c9efd24aa4448e6dda064b0633d253f2d.camel@mediatek.com>
	 <59dd8d29-48e8-4f45-b9f8-2f67b3f316b5@acm.org>
In-Reply-To: <59dd8d29-48e8-4f45-b9f8-2f67b3f316b5@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SE3PR03MB9491:EE_
x-ms-office365-filtering-correlation-id: d78d4a09-7b4c-4bc2-cc8b-08ddfa65fc2e
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cHA5RUNram83aXhITU1IS01QNzJjRUczU1ArQ0VPSms1b01iMFBma05vT0Yy?=
 =?utf-8?B?VE5mcDE0dnVqY3F6NC93SDRnODhySWMvbUU2eUtIUEZWVDRIckgwR2FsY09r?=
 =?utf-8?B?UXBibXV1U0duYWd4QjZnaUUyQ0U3MGlYNjJMNFNFQWpZK1pRc3ByRTdnM1h2?=
 =?utf-8?B?dGh2UStyVk5ITm5aSVljSEJCMXJKSkozcE56UHNMTnlTVklWT2h5Rnl1bll0?=
 =?utf-8?B?WkVza0dwQXdDSU1ZT3V0WGJJQzJKL2hFcEMrbHNVcXRqYldFN0txdE9QQW9n?=
 =?utf-8?B?VzhzZmsrSytzSUdtQ2tzS0x5N2ZUSWpvVzBRbkZ6MXJwUDRha3Z2b2Eybjhl?=
 =?utf-8?B?b0JlODVtOTdvNVMyWXNJaDljVlRsMEdKVk0yZVBaSmhadldGellBeHlMRGJT?=
 =?utf-8?B?NVkwM2h3TnhELzZ0aC9kemVUNERlN3BLTzI0bVNPN0ZMVmVsRWcyRGRGTGIr?=
 =?utf-8?B?YmpFSC9aTDNSSTZ3QmlUV3ZaMm8wS2laLzJVRzBhc1VXZGFaNXFuOHFVRitr?=
 =?utf-8?B?WFc4QnlTZzh5M3I4eENWdkhlc3VKemtoL2RTQ3VCT3BydHY0V3dCNnA5UVNE?=
 =?utf-8?B?cXVkYlFzZ0JveTM2Yy9VcnRldVg5VGw4eGpabXVzcGhEdm53L2czS1BOUW5L?=
 =?utf-8?B?ZmdyYzJGRFJuMDdKUXdOdlEzUHZPN0phQ0hyc0JmMWozdGFML0RkbUFYUjBj?=
 =?utf-8?B?dldVZHMvdUVkNkhEeEQvVUNTY0FZZTJRc0NhYk5udFA5VWJrMGc1Vzcrb0ZE?=
 =?utf-8?B?NTMwL082ZW1PTm9FZHlROHZnSklPQzEzSFNXdk8zZXBwMFFwYU9mS2E2Q0xF?=
 =?utf-8?B?NlhueldpWVpUZWtUQzgrei8rVnhtR0ltSjRpdFRiazQxWWpDMU9ESkdMcnFQ?=
 =?utf-8?B?bGpTWGJXakhoR1EwbXBsenlkbFR2Q3BsTytPTnJXb0ZXRmFoQkp6V2h2NnJp?=
 =?utf-8?B?TmVLWk1wNEFJM1ZqdjJXdTFid3R4VHRsKzI0TU4rTHNySDVnS05jSXNSczZM?=
 =?utf-8?B?ZkdoRW5OWGlBSVdjR1hZQ1hqRGRDa3ZpSFJvNE9NS0tHeUlQb1hibVJCTzY4?=
 =?utf-8?B?Z3FpM3gwZUFTM2NWbDRrS3QrbE93U3h5ZXRybHpaYmhENlUveC85V2Z4dUZh?=
 =?utf-8?B?dUtlbzZ2L3B2RzFmY2tlMWpYNUJtQkczd21XQm83OWYwUmNNaDducUV6YkQ3?=
 =?utf-8?B?TXlsaHNPSUVVQkhFNXBGMzJHdG9KTmNnUjRUNnZIK0ovMWR2OTIraG9wSTRO?=
 =?utf-8?B?ajBta3lGT1QzUCtBTlY5V1kzaGg1LzZrY1NsNHpoczRvKzR5RFZRcU8zY0tl?=
 =?utf-8?B?UG5mb1ViZERYRCt3SzAyYVlsWWEzN05yVi9iZjBxRGczeENrYTl1Z1JKVHVq?=
 =?utf-8?B?YjNCK2xrYmFCWnNHbVFVTW8waU54ZGI5cDVsQ0JZNTdZak5SWlYxOVM2Vll4?=
 =?utf-8?B?Mk1uVmZyZy9Qd2dUZ25hdFQ4ZGl6dVRDMjkwWTFZWlhEYy90UGlGM0tLaUJl?=
 =?utf-8?B?KzFBZ05Ic0xlVU8xTVU1bWZoNlZieTJVQUNFY2Nwb2lPeDh4bG9TY2RycElr?=
 =?utf-8?B?L3VqQUV4amJ2aUFkWWlVVmtUNlNyZFBrTFZjR2hkVjN0ZndOL3krQkpBdE1n?=
 =?utf-8?B?UzhqblkydFJDcmF5d0VnNDZqYnNoTWQrd3Ribm1oKzZ6TXJYc202U1p2UHFx?=
 =?utf-8?B?UDFQT3RoemdHU3U0YmVMQ2pJWEJzRGZ0aWl3ZEFyeHFBcnJsYXA1SThpdCtD?=
 =?utf-8?B?anZyQStNOURtb0wrdGVIREpKajg2TlU0TTdxOVB1N3lvVWk3N2w5UzRPN3c0?=
 =?utf-8?B?WlpMbzZMUGxseGI1WVRoS3VyUGNEVlVGa0M1N1JUWG1ieStTTm1FcXdjRFhO?=
 =?utf-8?B?M1R1WG96WklOMUdNTy92Wm1YTVZnQ2tzWTBNZHpHSjZFMlgrb0tWU2hmQ2JC?=
 =?utf-8?B?OW9UVUVvZi9keUFRcU4xMXNkcWVMRitVcnFiTEt4UGZrb2xRd05KbVFhS1NZ?=
 =?utf-8?Q?mbd42AKpJPEw/le8QBkmvXgDrswrhQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVVXMzVRdEpxSmZUMEZ5ZHhVSUFXMG1LSTE4OE95MlZXNURRRkVQVWxjOVF3?=
 =?utf-8?B?aFhMOWtHY0FnWTlFRnhmdnpmVGZ1NXBKRXNUamZVeUw1dWJ5ME5iYzlZSnlS?=
 =?utf-8?B?ZU5yanUrVHVqOHcxc25wQ25lV1ZOSEZZeFZMOUxkb3JYUkJnQ1E2NVB4M2Yw?=
 =?utf-8?B?Rm1tMkpZclZSQnlHMEliZ0Z6eVZyOXpZU1l1VVZBVFBrdDhtMm52TEcxdEFx?=
 =?utf-8?B?YUlyRHBTTGNQcVNPUU1XMDRhZW9nZXM2WjNEcTNKYy9hMWVMdkpmK1NxbWFT?=
 =?utf-8?B?ZDFTclBCT2EyTk80TG5vNy95NGtrL3JuZk5mL0YveVNmdUlDV3hNREVNblBm?=
 =?utf-8?B?azl5Wkh4N0tRbEJvRFYyVVBSSXRYZnBPQ2Zkb0V4YUdRM0RmV1VURmJrb21m?=
 =?utf-8?B?OXBXWTlSTzRFaEpiMmd0dDRoSFhPU2JaMDdYM3ptdUluZ1JTOFNTUE1sRFJv?=
 =?utf-8?B?MHBPL080OEVkcXNKZXJMWmJTc3MxNW9oc2NBajRZQTAyNW5kVXhtVHNvbE5Z?=
 =?utf-8?B?WGV1UVhrZ1JVZ0hHWU4vcHVVUWxOdkVMNW5pY2JlaHdaVjRZNUhtV2QxVjF0?=
 =?utf-8?B?VlRvRlYwbTJrQTA3bVBIWTliR3ozZERINmFqVCtIK21PY2g4MitjclBtVjBR?=
 =?utf-8?B?dW90OFh0OXZMdkpkakZBU0M5Q0ljT1pSNnJHY1ZrMFpPSndXRTRma09SZnZ6?=
 =?utf-8?B?RGpYZFNFVHlQM2JWZ2wxTnpaT1YrTFdlM0FjMVBQK1Z5T2VFZ2l0Nlh1a3Nl?=
 =?utf-8?B?ZUgwR2VKK3Ard2M3Qk5yaXJ1WUNrTkdwODMyeFR5NmlJd0lESis4RUVuaEpm?=
 =?utf-8?B?VjBxb0w3cGR5UWlURkNOUTJmMEtyMEpCU2dTQ01DM1RFVWZBNFFZMER2YWk2?=
 =?utf-8?B?dE9qQVNuR2RlVzdSZ3FmTUIwa21MMWo4Y3pzMjJiZW5QNHNpcy9VQk5uNUph?=
 =?utf-8?B?THlSdnVGRTlDUVFBT3B2ZTVkc2dNQ1kraGtxUStIME8yanczODh4cE5nMVA4?=
 =?utf-8?B?TFZvVTFPeVJzdW5Qd2dZYjlsZ0hJeVRnbjMwNlFkaGI1Tmk0NHBEQWVVeXFt?=
 =?utf-8?B?bElDY3E1YTdrMU13OW5Ja0daREpFUDRnQUpNOHlveEN0eE9UcWFOV1FhSm5i?=
 =?utf-8?B?cy9iRDVDelRpSVlxdWZScC9pbDZ4NWh6bEMzclpvd3BkYkxvUnFNZXdiQ2Zm?=
 =?utf-8?B?b3FsOUtZQWxBRUEvc1Y0cW9jWFJzTm9UdWxZM1U3anVPZUxmd0pLWFlwbzFv?=
 =?utf-8?B?ZjVpTm0weUhHa3FJUGZvVmhGb3J1UHdFSkpBTDhKTnlLNVhtOHhMZFRnNjl6?=
 =?utf-8?B?cW5DVUxSWTlNUlFSNlBPd0Z6eXJSUTJuYWJvYkMwYlFXelovMnhZc0I3Ty82?=
 =?utf-8?B?L2RENGx3RUtERkNCMU1pbUZNMG5KeXQvNkkxS01qeWlZWlJNODVKSlBnNXVi?=
 =?utf-8?B?NVM0Q3pCUjVMbEdpZzdWMDZpQWpvNVBON0djSmI2YVUwNVdlQUpBbmpuMmFX?=
 =?utf-8?B?c2lQRHB5blRaeVVlV3JOeitSekE1ME9MS1NnbndVNjErT1BwK29ERFByUzdR?=
 =?utf-8?B?cExHaEF0WlUzb0hNSHd1REdEUlNyR2RaWlYrbitYUGFqa2xFek5GblkxVGdK?=
 =?utf-8?B?ZVEvQkNLc0krTGJQejMrbnBEb3l0dGVSVmFIU3M0dkpsaUhPb1VkL09wVis5?=
 =?utf-8?B?ZDNzeUlhRkg0TVRqeFh6cmI2MFJreXl3bnR3WW1MZDRBV2NQVG01UU9hUFdR?=
 =?utf-8?B?aTNiN0ViZ3BySXd3bjhyMk51bS9jZ0hBQzc2UnJqTHEzZHBaMTdOK2p3OXpm?=
 =?utf-8?B?V0NoVDR3T3JZaW1qQUNKWFZiaHcrbE5iL3FPU1puM2JDc1Jrb1FLUkVEVDlq?=
 =?utf-8?B?VHF4NXlzZDlVWXk1UStLbU01OUdJeFVGcFByZ0ZYY3BGRWdFcHVhZVYxV2xj?=
 =?utf-8?B?bVUyWDJBNCtraDVoYWJjWWlQUnJvZnZrN0E2T3Q2TVlMbm5naTNmRW9HNWV4?=
 =?utf-8?B?bU8vb0ZqN3dvUDFieFlIT1pzL2NTYnk2M0VFV0p3bTIybzJ6V043TjdVUmk3?=
 =?utf-8?B?NTNJejJpZHJaTSsvZ0JQbFFSNUtsZi9HQjVwSHVmZ3RxVGxEa1I4NldXVzg1?=
 =?utf-8?B?L1lwQzVzYklUQW9SUUhNYjRMcFZDcGZNQ3FsL0lXRlJvSHNxcW5QZi9sMjRv?=
 =?utf-8?B?b3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <084E007E13B7904692709867099A44A7@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d78d4a09-7b4c-4bc2-cc8b-08ddfa65fc2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2025 05:56:48.5234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jSTotXePsx02/fWIBcufzBT52sLYXTSmhse/u2mS9rLeEUWVEE3O2jXeDraN9T+meTHCZ4/GbKVIub7GiOlhBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SE3PR03MB9491

T24gTW9uLCAyMDI1LTA5LTIyIGF0IDExOjI3IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9yIHRo
ZSBjb250ZW50Lg0KPiANCj4gPiANCj4gPiBAQCAtNjYyNSw2ICs2NjI1LDExIEBAIHN0YXRpYyB2
b2lkIHVmc2hjZF9lcnJfaGFuZGxlcihzdHJ1Y3QNCj4gPiB3b3JrX3N0cnVjdCAqd29yaykNCj4g
PiDCoMKgwqDCoMKgwqDCoMKgIH0NCj4gPiDCoMKgwqDCoMKgwqDCoMKgIHNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoaGJhLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsNCj4gPiANCj4gPiArwqDCoMKg
wqDCoMKgIGlmIChoYmEtPnBtX29wX2luX3Byb2dyZXNzKSB7DQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgdWZzaGNkX2xpbmtfcmVjb3ZlcnkoaGJhKTsNCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm47DQo+ID4gK8KgwqDCoMKgwqDCoCB9DQo+ID4gKw0K
PiA+IMKgwqDCoMKgwqDCoMKgwqAgdWZzaGNkX2Vycl9oYW5kbGluZ19wcmVwYXJlKGhiYSk7DQo+
IA0KPiBZZXMsIHRoZSBhYm92ZSBjaGFuZ2UgaXMgd2hhdCBJIHByZWZlci4gUGxlYXNlIG5vdGUg
dGhhdCBJIGhhdmVuJ3QNCj4gdGVzdGVkIHRoaXMgY2hhbmdlIG15c2VsZi4NCj4gPiA+ID4gDQo+
ID4gDQo+ID4gVGhpcyBpcyBhIGxpbWl0YXRpb24gb2YgTWVkaWFUZWvigJlzIFNvQy4NCj4gPiBJ
ZiBhdXRvLWhpYmVybmF0ZSBpcyB0cmlnZ2VyZWQgY29uY3VycmVudGx5IHdpdGggbWFudWFsDQo+
ID4gaGliZXJuYXRlLCBpdCBtYXkgY2F1c2UgZXJyb3JzLiBUaGVyZWZvcmUsIHdlIGRpc2FibGUN
Cj4gPiBhdXRvLWhpYmVybmF0ZSBiZWZvcmUgaXNzdWluZyBhIG1hbnVhbCBoaWJlcm5hdGUgY29t
bWFuZC4NCj4gDQo+IEhvdyBhYm91dCBhZGRpbmcgYSBjb21tZW50IHRoYXQgZXhwbGFpbnMgdGhp
cz8NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCkhpIEJhcnQsDQoNCk9rYXksIEkgd2ls
bCBzdWJtaXQgYW5vdGhlciBwYXRjaCBhbmQgaW5jbHVkZSB0aGlzIGNvbW1lbnQuDQoNClRoYW5r
cw0KUGV0ZXINCg0KDQo=
