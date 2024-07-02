Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35D42B9D8
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 06:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901463; cv=fail; b=QXGHDD5vGkxazUbwMXbKCDV1cWuA0pNbnWjvszXvN9mRwrzDPcBqyh2tvxHP5+3UR6iW8U96iMGsZqZL9jTbkvjQtIQHOOCP76ktwIOrxELNu0Kowaz3Cqsc4QhAS/nl8LOvWdeyRz5cAWUDvWCBbchAlSXb6/iXLXLphujB+5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901463; c=relaxed/simple;
	bh=AM0EIrwDs5l98JWKR+8t+XZbMOxVT5o4s4Yoyrw6nzc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RnsNhQAABryr5cCaKHxn7NO0tP9+kBfl9A23iVkBgE2hbO3SOP3SfaVHTj1zcKA7GHbpFM844bJG7Fd7TPzBSEbNtVIYCfAxzntzJr0PGCbk6vmE0JlhIDW3dE2fAdI2COEPapTFXUj8wkX9yRdSpGEmyqbtgphjx+HW9P8QrfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=V9mw2WF7; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=Tv4BDs59; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="V9mw2WF7";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="Tv4BDs59"
X-UUID: b3e4e52c383b11ef99dc3f8fac2c3230-20240702
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=AM0EIrwDs5l98JWKR+8t+XZbMOxVT5o4s4Yoyrw6nzc=;
	b=V9mw2WF7/KO0URGWi0YFMyfWs+wlkh1RbmTgp9r+hd2XgPg3dMz1/bUA7WmALfdylRRBLLtTO5DCPHYZrFyEcWbw/nRqp7UbbBQdUGNvFcoNGwqBRjq8YmWTq50sA0GuYCAVviHfFYPqZZeTdYx46pReoyPjWl4vSQC0yGJypg0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:fff75081-fda5-4b39-bb63-c525ce3b50de,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:f74bd9d4-0d68-4615-a20f-01d7bd41f0bb,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: b3e4e52c383b11ef99dc3f8fac2c3230-20240702
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1573018331; Tue, 02 Jul 2024 14:24:14 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 1 Jul 2024 23:24:00 -0700
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 2 Jul 2024 14:24:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/fAoy9fgG7IgrpTdmywSLDccvGEVPWIDGn0fgGdDZawz9vZk7s+e/y5U4jqDNqApsX+n1nElV8tpqNlTlwfq4eiAEsHPrZ9T1Dt2xmNhKk30WcenVTHoN4fe1bmU9dte+iLimjbP71JONzODbnGi4taarY4ekVXuUnvGXgUl/AzzyBdiSulHeXV1Wp17H8X2apLDvn8E4v7eBUmYo4cbNkvWxIQ9JT0nCSRHZjZSjdCJR6GuA8/9PXw3ubkrexrR+7P5VPCO07P8rto4MQ0ak/oveXU1c9/iTatdQS4QUGfIhqbr5AUAArqhHXHiw6AjNj9mQRNSWp6LI4y+gKGhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AM0EIrwDs5l98JWKR+8t+XZbMOxVT5o4s4Yoyrw6nzc=;
 b=MHAwhj+O9hRg51NTz26ypVIHGAzvRRdqAPNqtDxzJEnDe/hM7ppPqN5cPYqHJpplSvzJFMHzgjqxpfIwOGqsyATKswoZvnx6NGqYkOvkfqS4//z1RbYhBax9qbwAJ20w79pNe3ZRJjJXqqRo7cYAPx9xiAO1VA0NRmpXVK0YZ+30kr2369hBiFRjWpXFH6sHFKft5dhA0a9biatHHI1wJT1mkIaL0Xu+9zi5Ft06T62zpX6Ug2cct0U8Uxuv71QGgmuTVhI4HlnYF23utrZtYm+qIIwSei+e0xc5dydooIoNhyLxDUMI6WIcNsSGan2gwuERhwdVnaBeBwGMNWOTuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AM0EIrwDs5l98JWKR+8t+XZbMOxVT5o4s4Yoyrw6nzc=;
 b=Tv4BDs59HAOGym9HcCV5ZVI23BV0gqLaVqRfcoQbSPTbBJBNAhvPhy84he3xR1/U/iFN9TfZcatFQ+hTRDa/BzXBPRaRXd9MSqFKF8Jpa8xSt9FwgWMPLIpBsOGZqMlSyueaW0xmioDy8RR316e8bY5CwUqcrD4kM816w1E4Z/U=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB7708.apcprd03.prod.outlook.com (2603:1096:400:432::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Tue, 2 Jul
 2024 06:23:57 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7719.029; Tue, 2 Jul 2024
 06:23:57 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "beanhuo@micron.com" <beanhuo@micron.com>,
	"keosung.park@samsung.com" <keosung.park@samsung.com>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH v3 3/7] scsi: ufs: Remove two constants
Thread-Topic: [PATCH v3 3/7] scsi: ufs: Remove two constants
Thread-Index: AQHay+E8AbP/DZRZ8Ealr8InlP67MrHi+RSA
Date: Tue, 2 Jul 2024 06:23:57 +0000
Message-ID: <415f303adf40674932ff9f6cd6b062015b529566.camel@mediatek.com>
References: <20240701180419.1028844-1-bvanassche@acm.org>
	 <20240701180419.1028844-4-bvanassche@acm.org>
In-Reply-To: <20240701180419.1028844-4-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB7708:EE_
x-ms-office365-filtering-correlation-id: df59d0e4-5a4c-4469-e53d-08dc9a5f8e40
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VzZ0dEs4UlJoQk94MHdpUUFmY2R0cFJhUzZkSGsvejkwdy9CNDBTMmE3WkJI?=
 =?utf-8?B?azNCMG1zY3V5MVZRZldmeXRUVWk0enNYTlM5T1NmdkVFT3Y1UzFsRFducDRV?=
 =?utf-8?B?TEo3TGxYWHkvZ3lXL1ZqVjQzVWR3QU8weVYvc05tQWNIeHc5a216bHJMeXcv?=
 =?utf-8?B?OXpOVWFhc050RTAwN3JKcG96TG56dmM1LzJOaWUyb2hONCs3Q3dBTlRJRjVY?=
 =?utf-8?B?SVdXeGQrN2xpRFVTT29jeVVmMmp2RkFJYkYza2hCMDZHSFQrZTBXajdPRGtE?=
 =?utf-8?B?ZzJLeEdMUnhXS0NxOSs0Z0RYWFpPcWxpQUdZRUdvcUF3N3JvRkJxRldDN2NC?=
 =?utf-8?B?RXNTNXhNSi9TTHNPY3RmWWJ0eitlVkZGeW5LNHhaM09VZ2FXTW12ZzhGZGJ3?=
 =?utf-8?B?cEJFT292amVYaHVxSlRDeTZjdUJ5ZXBRQ0RIQ2cvSVE2d3hFeDlSOVNCQ3Bh?=
 =?utf-8?B?RDJuVlNvK2JvUTVDc0hGV095QzRlaDdjT0pLUFVveEtxNzR3T3llcFhqUXVC?=
 =?utf-8?B?WXhGOHlnQk9MQUpUL0VZTiswcVJENTdLaDdzSEo2WVlkeFAzZnhiMmlHUnRR?=
 =?utf-8?B?bFNKUGhHYlNPSFJkSndBK2Q0QUdYY2VVeGJYV1hqVlMxT0NiMXV1bmk5VHkx?=
 =?utf-8?B?L1g4ZmJ6R3NDb09rY1d0ZHMyV0YzRjZROWpWQUgrVHVyYlZQclU5Y2xHU0Nv?=
 =?utf-8?B?NnNuQzBrOFRSN0xJMm5DMm9CdXBoQjRLZGhad2F0dGdVNStQTFJsNW1Ydmdh?=
 =?utf-8?B?M0QxL3FmdHAya0oreHhZeTh1QnJPQVN5emxBMG5oNHRFc1hwc2xlTkUzbkxw?=
 =?utf-8?B?WWMwcWNpdlZuL0tnaGJrTkVYN3FyTFNBaXNWSnBMSldLQzJvQ3RlNjVxMGlh?=
 =?utf-8?B?dHpmQlFGRnozZ015Q3J3U05UM1BHTXV4K1FnbzhtL2E1SVozWFRHWWlIcFVa?=
 =?utf-8?B?VEFWZERwRDRBRXYxMTZZUlpaVHcvV0MybUUyYlc3cm9LVENIekxzVk5hNjlE?=
 =?utf-8?B?TExuNWFOYzF6dXIwSFJlUGNCVlY1MUFoUnNibGt5aWNwb2VLOXBqU1YvR2VG?=
 =?utf-8?B?aWxLSm5CTGc2S21TTG9yQ2RhdzRiSm8yNTk2VElsVUpEVFd0SmVOME1wU2xH?=
 =?utf-8?B?ZnZ6TjRhaHNmR21HelVLZGVaUGtCb1JxSk96OXpPekhHWUtRZU1pL09ReXcx?=
 =?utf-8?B?Q2xNdXExU0poN2xUR2hDU1h1UEhPMXFac3c5RExsNWpidGZIbE1FZ2NrdHZm?=
 =?utf-8?B?WDVEM2ZTc243UU1xSnkzc2MwVk9YR0d5bkZvL2U2NTY3aXlOWTZGNVI5RzU2?=
 =?utf-8?B?cTVTbnR0ditSV2RWakJ0bUgyL3pzOVU2V21JdWNseG9EMGlGbGRuSk1MeDd4?=
 =?utf-8?B?cHU5bHR0d0lCYUZzYUY0d2NyNkJIa2YwSi9OaEwzdEhGN3I2L3lNNTJJM2N4?=
 =?utf-8?B?WlN5UDVsRmpHWGxJTGRvTTFWQ2tmRlBpN0N1SGl0NDNyV0NJeWxIRC9xeDRL?=
 =?utf-8?B?Q3l4NmVDRkc1MzhKOWJZQ29UUGd4dlpRMzNOUm80cWFDVDI3RUZnU0o2SzNB?=
 =?utf-8?B?SEtZM2RmT3BISXZzdGNzYXVKaExWZm94TGRUbmhnY3c5OUJmRWFEaXAwOTE1?=
 =?utf-8?B?OC9pb0V2UkVzbGppOUo2NW9VVldpTVNmaXUxOVIwY1hsYUdVMjk1VEg1MXJS?=
 =?utf-8?B?bm01RjY2UXdmRUFyem9vbzFsODBxTGJKVzhYdkVyT1hGUUZqSmdOQjlkd0Q3?=
 =?utf-8?B?SU1UeUYwUlpkbWJBV2F3N3hYcGNuYzJMbm1mbHNZdUc4NGRjL0YreHE5ZkJz?=
 =?utf-8?B?ZVVxWUVRU0pLUWJXU2RXSUYxSGdxaVM0N1lZMlVJbTFKOTRNS28rWjJIUzZh?=
 =?utf-8?B?TExRdzBDc3kwNHR3dXltSUlJZTNpMDJLclE3d0kzN0k4YXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVprTnVxbW1saUxWeTNiU1hRLzR5R3VoN2xmYkRVcGpYWFkyOWxpV0N1LzlQ?=
 =?utf-8?B?eHJHY0VXaHFteENrYTRIdTFTNm5UTzVOMFJNOGd6VDh6ejA5dmROQ245dmNE?=
 =?utf-8?B?anlzWGxjaWhtMWpiSzM0QnZIMlY5YmU2dkNBY0hSNTZSelJsejBMVUYycHRS?=
 =?utf-8?B?TFBzUDcwSDk5Qy8xZ3d2aEdHU3FrOFd2WGNHYnlFdmRwaXErUTh3T1YrY3lP?=
 =?utf-8?B?eFVxU0xnTTluNUNaTzFrRTh5MlBXbzIzNGxIWlMrbjNaekpNTmpjZEFhZnVU?=
 =?utf-8?B?cmt2VkNyMUU2SXhqRFhBbUZyV2h6QzkwNkVmYnp5SGk0OHY1SEtodU9EYk5m?=
 =?utf-8?B?bHhlTEFrUjZnd1NGWGVTSTUyaFRKcXhBdmRQTm1rajNmZjhZL3FUM2dkdFRw?=
 =?utf-8?B?aXVJelFNR2JJNWE4QlFpSlhTcDlSQzhJNEY5VVlsM2RKSWVBVnVPV2JXL1FD?=
 =?utf-8?B?cG5nMmxyVjlUdXNiaVpIZDRIeHB3WmRKa0pZbGZFTG81VDlVcnltZE1PRWhR?=
 =?utf-8?B?TUdGZVJYU2l2NVNUQ01OeWwwN1QvYWJ6S0o0NzdTUlRha0IvaEpuWTl2bjc4?=
 =?utf-8?B?NVhxNDl6UFkxNG1SSGd3eTV3MWxQYVVlVjJ2U3kwUFZGRVhxaHZ2QWhtcnFz?=
 =?utf-8?B?U1dUL1NRZ2xKd1Q2Q1RWNTk2ODZPL3F4TGFuOU5PMi90dG5KT3lyenQ5RE1n?=
 =?utf-8?B?Q3N5VGZOOXpoU1dFNEtUMmhBSWlmcmZya1ByaUhuUllLZFRSeFlkUU5CTVFF?=
 =?utf-8?B?eFdSTDdkT0VRWG5IeDhWaHlIUFIzZXBvMWt5SE5rT0VpeFdqWUlNSXVsTHNO?=
 =?utf-8?B?ZWpwMG5JVHl1Z0gvSzAwRDlHQ1VJVkpnWThORy81MWFWRTJMVm9oZ29aR2RV?=
 =?utf-8?B?bjl4K3BIMm1kQVZZZTZjOHFTem1OSlF6ZDdkRkd6VVBBUGk2a08vcmdsLzQw?=
 =?utf-8?B?NTRUc0p3TE9zVFErc1V0Wm1sNnhqWnFvQWpJRDhIKzFyTGMwWk93WUxHdm54?=
 =?utf-8?B?OTVUN2p0WEU4bFlFeGFlQUJuL0JMb0x5TmErVlppa2tDOGM2RUR5R1JUU0xR?=
 =?utf-8?B?TGtqR2x6Z1pSSy9YRTJqQ0JhekRmbTdJS2dEV0VaTzZPZWI5V2RFYzU4M2Ra?=
 =?utf-8?B?WUxkN0lkNk1rMytNK1hXb2RveVd0TEErVWVRL0tPTGlob3U2cW5lamExZ2pR?=
 =?utf-8?B?ak5NNGpBdFJITUNmWW9kMUZVSmdnZkM2M1NMb0ZRa0lZYTNPYkFTWThuR2Na?=
 =?utf-8?B?bmtPVlJUTW9JVysyNkRzZlJHMGJERVVjT3ppT1AyTFVpZTJTSmZ0RVhnREhv?=
 =?utf-8?B?eGJnMDhBT2tTK3d6cWxOd3JXdmp0ckZ0dGhydHExVFl0dWo3QjloUUh5VDVi?=
 =?utf-8?B?NGZFK0k5UjNFREg2d0VuU3k4SS9uN0dvUzc5dUFEMnp1dEkydm1hRnAydWNa?=
 =?utf-8?B?WFd1WEIzcWUvTWFSYmVQa3FzY3NzazY2U3JJMFRLVlFZd3pYNERkVmNwSERC?=
 =?utf-8?B?dGRjRGpZZHRaZmEvQ3Q3WnFhaGdDdWtkcytiTGtFeURkMUtlcDRFK08xL2la?=
 =?utf-8?B?QnR4WWpMV3NFbG1GZmpNMEJ5eGJOemNWRDlxZDdCclFhZDgza3Q2KzEvSktQ?=
 =?utf-8?B?ZEhhTnhUc01Pd0ZQdTdQZk84bHJXaEF3VFk2ZEp0K2hkTW9xYmZFb1gxeFll?=
 =?utf-8?B?UUx6clBkOUFLTmZYS0V0QkxMd1U3UHhGZWRqTVV6R290bmNoU04rdDhESWN5?=
 =?utf-8?B?NlNzZHU0UWNVUGNMZnZWKy9yd2FZNGJTM0kyN1RaTGxjV2NqYTlqVC9HRVlv?=
 =?utf-8?B?QUd0dmJreUJjYkovdDZJM1dXcGpXYVEvQlE1dXBRYzNZaVpPUVltT1RCTzFz?=
 =?utf-8?B?dHNQdGt0cmtUa0MzY2dvS0JLMnhoSWZHbVNpdzFQVTM5TmU1UksvTE04UXpm?=
 =?utf-8?B?UnU4UG5GOHBLcFRSNlExbWhHdnhVZDNCVlZLVExIenBMUDlqdDc1ekRWN3VN?=
 =?utf-8?B?OFVzR3E1NDFkNjRxTEdpZzlhWmJmWGFzYkdYMHVtUkRzZEJkU2VmdGVqQTNy?=
 =?utf-8?B?YU9qL1c3YTIwQ1lUOVpUbmV6OERXS3BzTTcwOXhGeWx0bmhlSU96UXNIejhD?=
 =?utf-8?B?NlJGbm0rZVYxYTRkSUxxWnZnMUlyUERkM29Cdjh6Zmx0MTArOHNVMUlwWi9u?=
 =?utf-8?B?WlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AB669BCA2857324C8457F13B1500816C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df59d0e4-5a4c-4469-e53d-08dc9a5f8e40
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2024 06:23:57.8532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YMcWWEUQuEwmLaNxOYxoCdIV9TEQ2IEmwYJ5Kk3StEaJUKU9j1CwiMHS3NPVNS552A7hZ2WDHbj1X4NI9uf9gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB7708
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTAxIGF0IDExOjAzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgVGhlIFNDU0kgaG9zdCB0ZW1wbGF0ZSBtZW1iZXJzIC5jbWRfcGVy
X2x1biBhbmQgLmNhbl9xdWV1ZSBhcmUNCj4gY29waWVkDQo+IGludG8gdGhlIFNDU0kgaG9zdCBk
YXRhIHN0cnVjdHVyZS4gQmVmb3JlIHRoZXNlIGFyZSB1c2VkLCB0aGVzZSBhcmUNCj4gb3Zlcndy
aXR0ZW4gYnkgdWZzaGNkX2luaXQoKS4gSGVuY2UsIHRoaXMgcGF0Y2ggZG9lcyBub3QgY2hhbmdl
IGFueQ0KPiBmdW5jdGlvbmFsaXR5Lg0KPiANCj4gUmV2aWV3ZWQtYnk6IE1hbml2YW5uYW4gU2Fk
aGFzaXZhbSA8bWFuaXZhbm5hbi5zYWRoYXNpdmFtQGxpbmFyby5vcmc+DQo+IFJldmlld2VkLWJ5
OiBLZW9zZW9uZyBQYXJrIDxrZW9zdW5nLnBhcmtAc2Ftc3VuZy5jb20+DQo+IFNpZ25lZC1vZmYt
Ynk6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KPiANCg0KUmV2aWV3ZWQt
Ynk6IFBldGVyIFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0K
