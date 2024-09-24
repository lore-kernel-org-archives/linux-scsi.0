Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543711509B4
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2024 08:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727167726; cv=fail; b=RhNhtNgb/KIsLEliTY/2bE86sy+CB6D66Wl2co5vTVkqIUa9ayaLiTmYD3pyj5k7einRdaM1fRNHfkWcyG4swGKdFqELsv3duzz2qCkngA+cBTcSFJNw++J67ujkTLbcJ16qDaW1u/bxWb74FeI4FrV5+bfbYpFgSuq0ch7ZRHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727167726; c=relaxed/simple;
	bh=mrjnVu5PeCXBfZ9/XiNfKu66bQh/vBnpoqSz1roABDM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OHa4yot+p3T+Rg99K1c/EGlw+3HYr9Wrop0cHzoW0UYT8mH21pn9t897xIzJTvgI9YuM3PUz7K650tuSZRIOUuxU4emoKUrnPyjddgcFnL+Xr042Bduze4RmWk2gBDNeybuJV4bbYKU2KN8g4wtTQNpyxKulmM7DjGh+YD+X+Vg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dAHrQ3+j; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=sGw0n5c8; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dAHrQ3+j";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="sGw0n5c8"
X-UUID: c9cff8107a5111efb66947d174671e26-20240924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=mrjnVu5PeCXBfZ9/XiNfKu66bQh/vBnpoqSz1roABDM=;
	b=dAHrQ3+jse/ZAgddas+SurVaTqcFr10zeVKb8WnTRRxixTnscIveg4+cbSMQLrGL0lAlauwl5NSK2Av159yyQOXQw3c80JlqAy/Q/NJ7BN0hBcayJZlBft080YdHs/SF+4EFCHSoQOlNvrrypjLWgKFWZE5lDghZwkKFRMfPHSg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:679b0822-586d-4135-ba1e-dd189a6c7711,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:03fd799e-8e9a-4ac1-b510-390a86b53c0a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,
	LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: c9cff8107a5111efb66947d174671e26-20240924
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 392293045; Tue, 24 Sep 2024 16:48:36 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 24 Sep 2024 01:48:35 -0700
Received: from HK3PR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 24 Sep 2024 16:48:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XDm9xO5Kkngv0TlXzRAvLDLHoPk4FPsIzlhBmi77MLglrxdzmWX3QKuwe53i+uz9cmOi+zornR6HsCWVHX7iKoxWBnlwuD8m9716XjBF5zVJb9qTr02cfP6wogz1hfx93Zw0Rl7xvJoakExZHf3yIiGVQkDkkOO7U3dJXhL2DSyloRS/Jnx15kg0HdIRoK7lm+0vbfseO0dQCRffmekP7+T8cDwv7Zlcikzoma+FpwhlkHcG+k2c0H0GZTyPTeAg54RKf4EXKfW0NvIZ775mCiycueph6kSkpozWhttrrUCJ6aP536EOxnt0yQvwpOoP4tWVNIAvs1Dbq8YAOBIH+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrjnVu5PeCXBfZ9/XiNfKu66bQh/vBnpoqSz1roABDM=;
 b=wExV4q5a0H8cRk3sRfgTkGIxmOpxojxRzV3Q6qOVZgNpbb354/2uGSRI9hUbPTYaVIcQ+e9B3N1q/POQ6dbZjfFpJnBuDwVfgfLQq4Xw9tVjPr/bwAjvqzB3eSreBHbHr++1/06scjkf3AhvoKg2nAW0hjQTcWbQJMWDUoCzEBvYYOHL3HT8MegUuixxSs4mbSHJgWQj6bi1JFNjEiwk0jBlL74j1ym38r4KJdOYztU/pIPjlUlnkczBk/MZGI2uCKrD3NGne+9SvIukGr1L6WYD7fKkvzCs91CqUWukZvbeAVFZ5r9YJyc3lfCo57wob5O7guQweoasVSyRnQv2nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mrjnVu5PeCXBfZ9/XiNfKu66bQh/vBnpoqSz1roABDM=;
 b=sGw0n5c8GJa+cjlCTtb4AtkclHkmXBghC8caZOzaLKQYkth33ZVFL9ainVADQ0rGelOE9aVBjAlQO95lUpCvr/G4/BwCDWv+ltoGcbVrRzhWfYtiiDqG0bPJc4acaVhVBqujDJT0pFhnNA4DBlJTGpx7Hgt+C4s6xAqZhwvs0PE=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by SEZPR03MB7374.apcprd03.prod.outlook.com (2603:1096:101:12d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.17; Tue, 24 Sep
 2024 08:48:33 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 08:48:33 +0000
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
Subject: Re: [PATCH v8 2/3] ufs: core: fix error handler process for MCQ abort
Thread-Topic: [PATCH v8 2/3] ufs: core: fix error handler process for MCQ
 abort
Thread-Index: AQHbDY89enamWMGEgE2B7kNIMpetirJlryIAgADyz4A=
Date: Tue, 24 Sep 2024 08:48:33 +0000
Message-ID: <d78ea5470b2b91a8a3162639202ac48bdb27a5ef.camel@mediatek.com>
References: <20240923080344.19084-1-peter.wang@mediatek.com>
	 <20240923080344.19084-3-peter.wang@mediatek.com>
	 <f08fbc51-22a7-4c13-b9d4-ee7f4920bcfa@acm.org>
In-Reply-To: <f08fbc51-22a7-4c13-b9d4-ee7f4920bcfa@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|SEZPR03MB7374:EE_
x-ms-office365-filtering-correlation-id: 98a577ef-ce51-4eb8-0ad8-08dcdc75abdf
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y1VVSVJIR0k0RkZYREJoUlQ1T1VqUTBaRnBwL0d3UXpMVUZjSys2YXUweFNr?=
 =?utf-8?B?THdRQ05WQmlPS28ycXgyM1kvOExSU2doZmxwcDN1dFpNd0hwTzA3MWEyTkxW?=
 =?utf-8?B?KzZGbjBqOG9GVFVJNFFpc1lPRU1NSWsyeDdyS2h6b0I4WUxvOU5uckhhZUV5?=
 =?utf-8?B?aEF1dk9Wb0cvR3huMFF2SzhkcVZwdFh0eFQ3TUZVcXkzWE5qNkFzZ1VlNWlh?=
 =?utf-8?B?SE5pUVNJblhIYUpEUHhsM0Q4aHlTZWJ3VlM5UkRXbGZSTDJsOTBIMlVEV2tK?=
 =?utf-8?B?WURUdlQxb0NXMGNtMGRZbFJzVTZjekkyZWtQSmgvZ0ppYnVRRDVHdVVZSllh?=
 =?utf-8?B?Znh3MWJyMGpSZ25tZGEwWUhxTFp5a0tBK0d2bU1RTk1VZk9KL3YxVWk5dkxF?=
 =?utf-8?B?R0RuRk9zc2VIcUR4VjF5dG43OFZhUWc5ci9KNEx4T2pZZHFNOHo5dDdZQzNT?=
 =?utf-8?B?UUF2dGRvQld1MzBaM3I5SGpCeVRqK2dSYk9raDljOHFwdUNySEdkVjlURlVH?=
 =?utf-8?B?Q1hsVUV2NnNFQXpIWkFaT095RVN5UktKS1hGcDVjM2xrVnlBcFJwemxrU3I4?=
 =?utf-8?B?eW5xcDJLU2VYNWdwcENxWEVOYnNVRnR2ZjdXdTdWMVRST1BBaEhvTncyZXJl?=
 =?utf-8?B?VjZYQ2xQdmkvM2dYZ3hadVZJVmpMSk1oOS9Fd0pScUlQUlN4YTh6UTFJUDJ4?=
 =?utf-8?B?SHBuZ3BKWkNZTFZDNTRiRFl5VnlXeXIrZEEzYllEdzFVbGFJRERIWUExRWZ4?=
 =?utf-8?B?eG5UdzVyVUJKclBoclg5dTN6TitVZkZFa0MzWXV0U250czQxQThHVlVDMnJB?=
 =?utf-8?B?cUNRSTdKNnhRNyttOG44ZkNxeUc4QU1oaUh2c0hYRVk3WjllYWpBdDNITDF2?=
 =?utf-8?B?Q3FOelhhaEVJM2R3cjN2N3o0UC93SlBFODh0YVFpQ2h3bHdvTjIvUldHbk4y?=
 =?utf-8?B?NkR6OGhtTUJvT09CYTkzU1pVK21LWU5Bbjh5TkxxN29OTGpFN1N1aXUycEYy?=
 =?utf-8?B?K2lkMzFvZXc1NUpEMWVFdTFjR2JWTldqN2hIdWNjQkVUNE1aR2QyYU9GZkxW?=
 =?utf-8?B?VlBXb2t3YWszM1liczBKS2NpenpPeGRXOGlHODBWdzJiaGJDRnhGV1dQS25r?=
 =?utf-8?B?QVdNZVRmRUszSEVMSEF5TE9sck00OEZNZ0Q4ckcwbjljVVJmbVM0YktnUVNz?=
 =?utf-8?B?QnBES3FvMk5yc2hpeGpZRFptM3dlOEwzc0U0aUlWL0NuTVBZT1VmUEgxZTJs?=
 =?utf-8?B?dnZKNENOMWlvY2xydTJHb1VtQzlZU1lXdDdoT0RWS2lZY0hEbGg0eHYzUE5K?=
 =?utf-8?B?MHRjZ216VlFldnpoZXkxdUxXcUpidm1PQzRSQmdMQm4zSnJrYWFBU2dlb0FT?=
 =?utf-8?B?SFQwNTlYT1JZbkR3QzRHeXBEbTE5eWl3UnU3NUVNbWpFMk1EOXI1U0w0UmVG?=
 =?utf-8?B?SFFHTkl1V2J2OEtEZ2FhSzhQVUhQQjZFUjhST2tLd2tvVHBFKzhqeEY3VTBu?=
 =?utf-8?B?azF0S096Vm5iVUpNK0QxZkQvcllZeUlBNXkxcVArMVRJVUdGK1hxZkVpMlVw?=
 =?utf-8?B?VThQUHEzd0pEeHQvY3BuelFzaDNvRHlwSVFpd09SQ3V1UmgwZjRvQWkyb240?=
 =?utf-8?B?V0F5ZWlRQWdMNm9VUGRGY1E2NzRGTzRMYWpZN0d5RWJySUxTUXJhSURqYlVs?=
 =?utf-8?B?ajI1ZXdoaDA2QkVDdG5sYzBaaEo2V1ltcVlrNWZxSC9CN0s1UGIrLysyUjNm?=
 =?utf-8?B?UmlBYUVJZ2dXL0N3RVVLamhkc3ZaU2I5MWNnei9ES2YrVndoZUI4cDhZK1pE?=
 =?utf-8?B?VTRiSWRGbkU5Sk9iRFFndz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2xEZGVFNlVnTDYrNTYyaFZMMnNYYjRwVUs0bmNwUFR6KzNmZ2FNTmRjNzIx?=
 =?utf-8?B?MGEwekZ0aXlaNHNjZEhXcDV2VW1CTkRVNGsvL25IZzczWUFBaVhWVzBPTXhR?=
 =?utf-8?B?UUd6WmhyVUg3ZmJJbWN3eWsydXFKRDlGZ0thejRYbGFZNndXa05BeVR0SXg3?=
 =?utf-8?B?SzlCUk9oQ1p4M2NSM0hkRGdBeDdwTHAvMVFCUzV6MjZEU3RUTHllVzZqMmdn?=
 =?utf-8?B?TWNmeXVoZnBKQ2tNdkdaVUtNaEtGdVljQ081bzJwTGRNTGVwV1p6RmtqZGpw?=
 =?utf-8?B?UHJrWUs3U2xzSFhEeGNJY1FIK3VvZmNBZXY5S0NmQnFYUzl5TDB3dGk3Vkhs?=
 =?utf-8?B?dWlGOGkyWUtWV1R5ZHduSUNxaENKTW9MNXNiMU12VVI4TnU1UFdSK013bXc2?=
 =?utf-8?B?LzhkN2hqL2cwMVg1MGgyNWpUNGVGeU1FeVZXZFg0ZFloWFZZa3REaTg2dXph?=
 =?utf-8?B?UExuNGJ2eC9hM1hVU0pSNGpNNzMyZEcvQlM4NkgxakRWK3JhV25pNzVIZ01l?=
 =?utf-8?B?bFQrVEdwU0hvWEpUbFRubHJheEUzbzJ2K0ZXNk9XQWFmMDF0WHIxTXBCanFl?=
 =?utf-8?B?UGNLMlcvMEt4MlZ5YS9kSkZOK0hldUM5WUNHdVp2YWlnMjVPMWtyUENEZkVV?=
 =?utf-8?B?WWFjSGNxUDl3SDdlWFNCTGozRk1YaDdUR1FYNVNoaGNnMlVpRG1ldTVycWY4?=
 =?utf-8?B?anlna01EUzljMGJObUd3aU9EN0VETDQ0NmdDSUNqNWJ5YS9sNURpYTFnV0Ji?=
 =?utf-8?B?cHowWVhCUitKOU9IOVlHSSsrb1VCUXZrUmhWS2V5T0sxTG9VMFF4RmM3TytQ?=
 =?utf-8?B?bERCOVhIMnptWnI0Y1FKUkx5SU1MYVBoSXhjTDFNOHliME5vRkZDakVKcER4?=
 =?utf-8?B?NmFWZzRnQ0VGMXRtNndyU211RDJUa21hZkQreG9FYlBLODNYWk9DMXQ4aUYw?=
 =?utf-8?B?TXozb045WEtUejBIOC9OUm9DRHE0enBoaHE4Y0ZLOW50SjZvdWxHV0RIVFVj?=
 =?utf-8?B?RXFpa3lHMmhTOXFzOHpvTnJWVFlFYStnMTFWYmVpY3I1Q0lsMmRwTW5aNG1C?=
 =?utf-8?B?VkxLY1F2WVQrUWdYQ3g2dCtIdTZTK3RpK0VYVVJFUFRtUDJhbTdOUU9Wb3NO?=
 =?utf-8?B?ejl2anZ2UlJPQXpBNW1QdkNWZkZBYUxOdGVvTkxpUlJpc1BhOWV6aUhxNmts?=
 =?utf-8?B?YVVJcjJzQkREV1pqb3REZExUT3pIMmVxbjcwS0xacnhsTFREL2F2eEJjNnB3?=
 =?utf-8?B?OVhhME9hekNQbzBPeUo4TWhBSUdpdDhOY1VyaW1ReDRvZ2JRVkc0WjNDNzZW?=
 =?utf-8?B?WGhWSFpabWo0MHRKQllvQmJ1SlpRaDFNbDZ5RFhGa2wxRUVPcUN5czN0U2Vw?=
 =?utf-8?B?eXlDVDN0cVZrNFhJM2pMVWJvMGk5anAxc3JCMGFIdXg2UEREY0NlRlorYndx?=
 =?utf-8?B?TE53TnB2ZkRiNDNhd0wzcWw4ZVhYbm5hQkp4VGFOckhUM05DcVhCcVI1V0lq?=
 =?utf-8?B?cmVuMnFmQjN4ZDNLcVZZREZsUDRuaFdMbm9xWlV2RDMwaWd3dDRqWU94ZWtt?=
 =?utf-8?B?QmlqeUNqRnNPRXhESE8yQzlFUFpIYlZEclZ5OVBuVTdEK29JSjhhd3pzT2Rh?=
 =?utf-8?B?SkNlNTVhRklSdEtERi9sUTZDRmpBK1FWSlBFRVhzejJqTXNORmhZbjhPMVVZ?=
 =?utf-8?B?VDBJVlcvK1dFKzdpVENDU2FiajhUTjdPSXAwUGhHWmVEaFMxN1hNaTYwUThv?=
 =?utf-8?B?UjROdHdoZzJmZUtyYWFoZElMeGVIY0lGNmJrNGY4bzA1cmtMcHR4WTRjb0Zt?=
 =?utf-8?B?cWVuV1FsNW40c2pGakY5TjBpc2h4TXR0RUV4VEZQU1puZmhBaVdaQ1h0ZFZS?=
 =?utf-8?B?WExlVUxHWHJrQ3ppaXNmcFJxajRLbEtCeXhUM1oxM3FjcWp2cVRxY3BYcE9I?=
 =?utf-8?B?SkRSSXdQR3VDc25hWmVCVlNHcjBCdlBKa1c4ZUk5SWYzTVpZL1F6UzZMMHo4?=
 =?utf-8?B?Sk16N1RZbURqdXdxaEVPK0M0WnlOLzA3N0NPMlZ1OEo1MU9KaGxrMFJZbW5s?=
 =?utf-8?B?L2pHOThBdFhyS3hQSFFuZTF6cG0vZWhxOGN3WGxkdkVjajBqbGJuS2xkbTBr?=
 =?utf-8?B?Y3dZdmNZMG8yY2FGRlBsbnF4SEdoL3MwS292aFhITE1HN2JYdjFPY3JDK095?=
 =?utf-8?B?ZVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D8C5565F2C6424E90B0517255C34384@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a577ef-ce51-4eb8-0ad8-08dcdc75abdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2024 08:48:33.2314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XyGc7cRLUz0CDMfwexbMc0wfQUzsmw5U+appxKVPrJL2pcKKIeQKFlWSOHqCZ2o+LdR1BL8NY16gjVY0QIqYwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB7374
X-MTK: N

T24gTW9uLCAyMDI0LTA5LTIzIGF0IDExOjE5IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOS8yMy8yNCAxOjAzIEFNLCBwZXRlci53YW5nQG1lZGlhdGVr
LmNvbSB3cm90ZToNCj4gPiBXaGVuIHRoZSBlcnJvciBoYW5kbGVyIHN1Y2Nlc3NmdWxseSBhYm9y
dHMgYSBNQ1EgcmVxdWVzdCwNCj4gPiBpdCBvbmx5IHJlbGVhc2VzIHRoZSBjb21tYW5kIGFuZCBk
b2VzIG5vdCBub3RpZnkgdGhlIFNDU0kgbGF5ZXIuDQo+ID4gVGhpcyBtYXkgY2F1c2UgYW5vdGhl
ciBhYm9ydCBhZnRlciAzMCBzZWNvbmRzIHRpbWVvdXQuDQo+ID4gVGhpcyBwYXRjaCBub3RpZmll
cyB0aGUgU0NTSSBsYXllciB0byByZXF1ZXVlIHRoZSByZXF1ZXN0Lg0KPiA+IA0KPiA+IEFkZGl0
aW9uYWxseSwgaWdub3JlIHRoZSBPQ1M6IEFCT1JURUQgQ1Egc2xvdCBhZnRlciBNQ1EgbW9kZQ0K
PiA+IFNRIGNsZWFudXAuIFRoaXMgbWFrZXMgdGhlIGJlaGF2aW9yIG9mIE1DUSBtb2RlIGNvbnNp
c3RlbnQgd2l0aA0KPiA+IHRoYXQgb2YgbGVnYWN5IFNEQiBtb2RlLg0KPiA+IA0KPiA+IEFsc28s
IHByaW50IGxvZ3MgZm9yIE9DUzogQUJPUlRFRCBhbmQgT0NTX0lOVkFMSURfQ09NTUFORF9TVEFU
VVMNCj4gPiBmb3IgZGVidWdnaW5nIHB1cnBvc2VzLg0KPiANCj4gQWx0aG91Z2ggSSBsaWtlIHRo
ZSBhcHByb2FjaCBvZiB0aGlzIHBhdGNoLCB0d28gY29tbWVudHMgYmVsb3cuDQo+IA0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jIGIvZHJpdmVycy91ZnMvY29yZS91
ZnNoY2QuYw0KPiA+IGluZGV4IGE2ZjgxOGNkZWYwZS4uYjVjN2JjNTBhMjdlIDEwMDY0NA0KPiA+
IC0tLSBhL2RyaXZlcnMvdWZzL2NvcmUvdWZzaGNkLmMNCj4gPiArKysgYi9kcml2ZXJzL3Vmcy9j
b3JlL3Vmc2hjZC5jDQo+ID4gQEAgLTU0MDUsOSArNTQwNSwxNSBAQCB1ZnNoY2RfdHJhbnNmZXJf
cnNwX3N0YXR1cyhzdHJ1Y3QgdWZzX2hiYQ0KPiAqaGJhLCBzdHJ1Y3QgdWZzaGNkX2xyYiAqbHJi
cCwNCj4gPiAgIGJyZWFrOw0KPiA+ICAgY2FzZSBPQ1NfQUJPUlRFRDoNCj4gPiAgIHJlc3VsdCB8
PSBESURfQUJPUlQgPDwgMTY7DQo+ID4gK2Rldl93YXJuKGhiYS0+ZGV2LA0KPiA+ICsiT0NTIGFi
b3J0ZWQgZnJvbSBjb250cm9sbGVyID0gJXggZm9yIHRhZyAlZFxuIiwNCj4gPiArb2NzLCBscmJw
LT50YXNrX3RhZyk7DQo+ID4gICBicmVhazsNCj4gDQo+IEluY2x1ZGluZyB0aGUgT0NTIHN0YXR1
cyBpbiB0aGlzIG1lc3NhZ2Ugc2VlbXMgcmVkdW5kYW50IHRvIG1lLg0KPiANCj4gPiAgIGNhc2Ug
T0NTX0lOVkFMSURfQ09NTUFORF9TVEFUVVM6DQo+ID4gICByZXN1bHQgfD0gRElEX1JFUVVFVUUg
PDwgMTY7DQo+ID4gK2Rldl93YXJuKGhiYS0+ZGV2LA0KPiA+ICsiT0NTIGludmFpbGQgZnJvbSBj
b250cm9sbGVyID0gJXggZm9yIHRhZyAlZFxuIiwNCj4gPiArb2NzLCBscmJwLT50YXNrX3RhZyk7
DQo+IA0KPiBBbHNvIGhlcmUsIGluY2x1ZGluZyB0aGUgT0NTIHN0YXR1cyBpbiB0aGlzIG1lc3Nh
Z2Ugc2VlbXMgcmVkdW5kYW50DQo+IHRvIG1lLg0KPiANCj4gUGxlYXNlIGNoYW5nZSAiaW52YWls
ZCIgaW50byAiaW52YWxpZCIuDQoNCkhpIEJhcnQsDQoNCk9rYXksIEkgd2lsbCByZXZpc2UgdGhl
IGNvbnRlbnQgcHJpbnRlZCBoZXJlLg0KDQoNCj4gDQo+ID4gQEAgLTU1MjYsNiArNTUzMiwxOCBA
QCB2b2lkIHVmc2hjZF9jb21wbF9vbmVfY3FlKHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEsIGludCB0
YXNrX3RhZywNCj4gPiAgIHVmc2hjZF91cGRhdGVfbW9uaXRvcihoYmEsIGxyYnApOw0KPiA+ICAg
dWZzaGNkX2FkZF9jb21tYW5kX3RyYWNlKGhiYSwgdGFza190YWcsIFVGU19DTURfQ09NUCk7DQo+
ID4gICBjbWQtPnJlc3VsdCA9IHVmc2hjZF90cmFuc2Zlcl9yc3Bfc3RhdHVzKGhiYSwgbHJicCwg
Y3FlKTsNCj4gPiArDQo+ID4gKy8qDQo+ID4gKyAqIElnbm9yZSBNQ1EgT0NTOiBBQk9SVEVEIHBv
c3RlZCBieSB0aGUgaG9zdCBjb250cm9sbGVyLg0KPiA+ICsgKiBUaGlzIG1ha2VzIHRoZSBiZWhh
dmlvciBvZiBNQ1EgbW9kZSBjb25zaXN0ZW50IHdpdGggdGhhdA0KPiA+ICsgKiBvZiBsZWdhY3kg
U0RCIG1vZGUuDQo+ID4gKyAqLw0KPiA+ICtpZiAoaGJhLT5tY3FfZW5hYmxlZCkgew0KPiA+ICtv
Y3MgPSB1ZnNoY2RfZ2V0X3RyX29jcyhscmJwLCBjcWUpOw0KPiA+ICtpZiAob2NzID09IE9DU19B
Qk9SVEVEKQ0KPiA+ICtyZXR1cm47DQo+ID4gK30NCj4gDQo+IFdoeSBvbmx5IGlnbm9yZSB0aGUg
T0NTX0FCT1JURUQgc3RhdHVzIGluIE1DUSBtb2RlPyBJcyBteQ0KPiB1bmRlcnN0YW5kaW5nDQo+
IGNvcnJlY3QgdGhhdCBNZWRpYVRlayBjb250cm9sbGVycyBjYW4gYWxzbyByZXBvcnQgdGhpcyBz
dGF0dXMgaW4NCj4gbGVnYWN5IA0KPiBtb2RlPw0KPiANCj4gVGhhbmtzLA0KDQpCZWNhdXNlIGFj
Y29yZGluZyB0byB0aGUgc3BlY2lmaWNhdGlvbiwgb25seSBNQ1Egd2lsbCBoYXZlIA0KT0NTOiBB
Qk9SVEVELiBNZWRpYVRlaywgZXZlbiB3aXRoIGEgcXVpcmsgaGFuZGxpbmcgU0RCIE9DUyBBQk9S
VEVELA0KY2Fubm90IHNpbXBseSBpZ25vcmUgaXQgaGVyZSBhbmQgbm90IGRlYWwgd2l0aCBpdC4g
DQpPdGhlcndpc2UsIGl0IHdvdWxkIG5lZWQgdG8gcmVsZWFzZSBkaXJlY3RseSBsaWtlIE1DUSB1
ZnNoY2RfYWJvcnRfb25lLg0KDQpUaGFua3MNClBldGVyDQoNCg0KPiANCj4gQmFydC4NCg==
