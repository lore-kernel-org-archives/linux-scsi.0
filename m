Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D9E3074BA
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 03:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770694806; cv=fail; b=mwMs8lnBxjh3OYrDnRqaNO7jqKTGerSVo0bmg5O0/Jr85XgjtB67IpMYTymFamijGrmxR9RQzBQOH3td8Favu0F/WBU61pgDnY0yq1S7X5WicaCF3OyfsM8GH9HOjQAeGPXK7hKB921Mve6EAt3TxQe8YpNgRqGLLRqlpgGfJ2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770694806; c=relaxed/simple;
	bh=StNVdON1MDWVBU51UokKBbI8h7YdsHtUIo2XDYClUk4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ENFRQOmia66s5Bwu/lkmBA1+uwMchSZXex683GF6MdqM+4fz3bh/uxHLdVmiIbsnCi4FJGeDyqCM+XrfrQkwe4Y+6rfIsbbdBhhOf28BTMhOs8ilRqSZ8LltVVKp2T1IeyFHObGztAnAZqjFAZxjFag+GPZt5P7gaxuHw+SABpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=svQ0hjBa; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=VTcC8MkB; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="svQ0hjBa";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="VTcC8MkB"
X-UUID: 29c116c4063211f1b7fc4fdb8733b2bc-20260210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=StNVdON1MDWVBU51UokKBbI8h7YdsHtUIo2XDYClUk4=;
	b=svQ0hjBay3/me4BjE2JtHCI/Fe3/UhH806GtSXXx6DPD7IUGpeRp5WCjqItbNY06scgmLPFrPapA9aHpd33+mS9rNr4fLXcZDjlkhTIkzaKbCz43Mq9LrqhXhhrCUQ+UkPBvujawBNMjckoxikZI9bReWf3qfNr9vG01vSpXT7Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:ce63e46c-45e1-43da-a9d7-abd3b3d691ec,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:da1e1f5b-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BE
	C:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 29c116c4063211f1b7fc4fdb8733b2bc-20260210
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 95837981; Tue, 10 Feb 2026 11:39:54 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Feb 2026 11:39:53 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 10 Feb 2026 11:39:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cOAsZpK9NVPrXHD+/FtrxL/0an2DQT9GxgjbfSalRLDWG0tBjDl0AVt8lH7IzRN8XB6zeXfuJIaueZJKjd9LzObmfJoN1a3auSwZ9aRlP+z0enUkHsKgNVjGQfCTjOCLshivmL3YE3OqGdWzK5HfVGgMCIUMOyya/cerQLhf8RIwRIqEvmmRAbTrqiYYM/3cozjK72G+sqi7gYRR/v0e5BovvEbB/7PHTS1fUZFPtTKf1LhWnYiaoeWK55pycS9p4WUkfefUslXZ8DJ1O6lLZHElcZPiZyMbC0sxSFazImDZFqmUT97d4aav6E3vmYyZWFqiFNF5QzfUF+PHK8S8lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StNVdON1MDWVBU51UokKBbI8h7YdsHtUIo2XDYClUk4=;
 b=G9uOB7yHDSGckWTb5Cmp8WIeBMSUAtJua8Gq18g8l4yeeUBb/ijIDneVVOfNBG+LJRYEmReaRJR49VcjCan0L1xYdY05eE9G8NNtHr6ubbeesAUMqzdh8B0wJomInPsGcOzcpgk5jD+3CBkRlbF1ZSmMyC3UY0/RPrKF5YClFq5HRP04/uhXZq4nqLZzAdsjqMhyD0FVMA3tcGnR+iy6MrirmwKNdIQfyx8pZQSs+174paUYbdShpE+V7CetYHm74GPpwlKDkk1Ct4Br7va3vaeHyTPTr7ksdvArqE4CaMElskK3njo08xkWSGED27qTfXyX90IUiWV6dIHwqfMrcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StNVdON1MDWVBU51UokKBbI8h7YdsHtUIo2XDYClUk4=;
 b=VTcC8MkBjFXT4Wor0CT1abmTzf/JOqlxz3TSe38QZ9V+mxCs+M3LKls0bAAg0zsqlCvnWoEwlliWktsDWywc5ILFlDlwYz5fOYps7uz3bPzbluwX8vQwN5eAy4tQfnQ1bIhAHmrUHJ27ccK7N0Wknj+nCPjp9lOpMRCeBdediwU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYQPR03MB9483.apcprd03.prod.outlook.com (2603:1096:405:2a3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Tue, 10 Feb
 2026 03:39:51 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9587.016; Tue, 10 Feb 2026
 03:39:51 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "avri.altman@sandisk.com"
	<avri.altman@sandisk.com>, "bvanassche@acm.org" <bvanassche@acm.org>,
	"alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC: =?utf-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
	=?utf-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
	=?utf-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
	=?utf-8?B?RWQgVHNhaSAo6JSh5a6X6LuSKQ==?= <Ed.Tsai@mediatek.com>, wsd_upstream
	<wsd_upstream@mediatek.com>, =?utf-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
	<Chaotian.Jing@mediatek.com>, =?utf-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?=
	<Chun-hung.Wu@mediatek.com>, =?utf-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
	<Naomi.Chu@mediatek.com>, "linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	=?utf-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: support UFS 4.1 CQ entry tag
Thread-Topic: [PATCH v1] ufs: core: support UFS 4.1 CQ entry tag
Thread-Index: AQHcmb6RwA7QiX4NdU6gexZQSxVKnbV6lL0AgAC1lwA=
Date: Tue, 10 Feb 2026 03:39:51 +0000
Message-ID: <e998c4af94010d8951c51027c4a961e5bca26985.camel@mediatek.com>
References: <20260209122101.1529379-1-peter.wang@mediatek.com>
	 <19842000-3d35-4585-903b-2c194efce209@acm.org>
In-Reply-To: <19842000-3d35-4585-903b-2c194efce209@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYQPR03MB9483:EE_
x-ms-office365-filtering-correlation-id: fd0e0f31-f32a-4935-5734-08de68560bff
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WEFRZkV2UjNUbnlITEVpT2xmRm9kRk9oTmZscHNjWU1yTFhTUFFraVdtbWRH?=
 =?utf-8?B?WlpybW5aQnM0d2MrWUwvY1BULzZId2NkYXE2TFRiTEFJSXZzM2FrZGNVaFUz?=
 =?utf-8?B?TTBQSlhGNHp1Vm1iSXRuUHR3UUdhaER3RGhWMXh4czM1MmZFSWlaN3F4bkV2?=
 =?utf-8?B?WTB0NnhWQkF2YU9wZnlQdVEyVXpLZVdOdmRGaS9tSXh5Rk9IN1MreEpDQWJN?=
 =?utf-8?B?V202K29YdWNFSmRvbC9SbWlvUXJUempUYzFVWWFsMm1tTzNqNWNIRkNYeEtP?=
 =?utf-8?B?cXhzR1k5aElOT1NrK3Ryeko5c045Si9Nc0JHRXdTcEJPT2tGcW5JMEMwQVZq?=
 =?utf-8?B?RGY0MHRzYklPTWJtUW5BbnNBRUc2WGxGK3p1aXNRc01aMk1ndkoxNFc0b3JY?=
 =?utf-8?B?K0FzYnE3bmdzeWNPS2ZvdERnR3FpTzBLRGhhQkNCcERMZnRqclY5TVJ6Wkhx?=
 =?utf-8?B?S1hDdUhjZDJEUHFYWno4M3FKT1ZOdzdwOTA0QUNiN0toVzNGZkFDN2FlZ2JS?=
 =?utf-8?B?VU8wdVpOOHFyUjRGTzlKc05tanlIdXZIUy96MFRSNlk5dFJwbmxRdmE2WFIy?=
 =?utf-8?B?YXZmck5sV2pVYk9HSEdIWDYvUXZPN1Q4UFR0WTlLcm5yVENrMnJWa1BJakx4?=
 =?utf-8?B?ZVMwYVdKNk1UZWlaK3JPV2d1YTVNSTRISWJMSVRucktmR1A2Q29kM3BRNjBJ?=
 =?utf-8?B?cnZ6ZlVXbEd0VGRFTU03MnY5VnZQN3pmRXd3YVZYVjNaS3piemErL1dPSHpF?=
 =?utf-8?B?R1E5bWhkb1lPNlpPR25ZRm1VYTUvUmZUaVM3MGNRTVlqYVRCUGV3ZUxqWVcr?=
 =?utf-8?B?T1JzcEh2amtTejJjTS9keDlrazA5SGttYW5Ra01nTDh3VlFYQ21yKy9nSnkv?=
 =?utf-8?B?ZUlHdWlRbFUrN29BalZ0RjdyNkpaZjR6Q295SDNQK3g4TDNRMkx1c1o0bm5t?=
 =?utf-8?B?RnE2VjJ1TDJvWEQ3aTk2VitmZUszbGNycEVtem80blhtazV4TW1vb0xXb09w?=
 =?utf-8?B?bW9zY25pNW9QYktuZ3dCVXNUcGxJTVB0UzRaa1pGVXp1NkpTdG9MeXFSNEQ2?=
 =?utf-8?B?NFpzMEoyN0F0VHlDRXJsTXVHcDJ0dDEwUERhMXp4bnBqRXV0bTVZK2cvTHFs?=
 =?utf-8?B?SWhaSGhKaHpaeWZrSnZPNVU1cXZOc0EwMFVOOUs3SEZTMFpiMlJqZ2lZbzVh?=
 =?utf-8?B?a0dDcGN3SU1OZlU1WjBtRU1NQjYwOHdPWnNnOVp0Sno4cjFFSXFScXBqbjBW?=
 =?utf-8?B?SS9jT3hSVHJNak5qdXR4ak5TYXR2TEZnREd1RXVSRFVtdFFKWitpMis2M29w?=
 =?utf-8?B?RVBHNXRwdWlYbUkyS1BWdE1FcFJQcFJnbGNySWJFREc5c3RIU1pRa1JwTXpm?=
 =?utf-8?B?ZXVrSGJKRExUT0VpUkpvdExZUmlBSVpNdHRzTzc2TTZOQ2V4NUtpYnRNL2F6?=
 =?utf-8?B?MVVQd0lSNzFBRVQ4QjVGVGN3TmlTems4bVZLQ3E1V3BoekdOUUVTOHg5TGxD?=
 =?utf-8?B?UEc1S0ZkSER6bXp5NGlLVTZkakJZRDFmbGRpUFp1QjVFRUZDeGpSK1dkb2s5?=
 =?utf-8?B?N1JTMDUycll4VG53eEpwcHFZNm5idXowNTBpblNxOFF0N0s2Tkt5TW1Rello?=
 =?utf-8?B?Zm96TWNtRVNwSVhQK28zSmg3bFNONkJBUXR3UnptSTc5ZGxyNlBqSVdvUnpN?=
 =?utf-8?B?TjJaNGh3L0xiUit2SjNocnhjcU9EbkRGTXMzN0hFbjNFT3ZkOVpOemJPdVZF?=
 =?utf-8?B?VzFoSkxCQVJZUEZoTjJpc09OcElFZFVNNnZOZ1AvdjU0TTdEbGpWOGk3ZFhQ?=
 =?utf-8?B?T1RNcnN0UnJsY0V4MDRCd2FIakZuWUhlcFhTL2lpRHlFanUyaTFQQXhVcUw4?=
 =?utf-8?B?NkczeUFGNlVwNTJmb0JhUk1Eb2l2R2llNUZrWUoxVGtpU3ZMbS9ZdHA2UU9F?=
 =?utf-8?B?SG51SWVnb0N3amFIRVBSb2toS3FwWFg5Y0JVclZHWkdhQUs1MmRxSlNkZUIw?=
 =?utf-8?B?MGlJK3pBaXBteUFYSlpOakNQUE42L2NqWW1YWVRtc1NnN1Z3N0RQLysvM21m?=
 =?utf-8?B?T21INTVDMDltU0xOemoxa0pvQjFuNDRobXFaL215TUZIUTBVQW9DYUlrYmtr?=
 =?utf-8?B?Qjh2UWRUYktydW9vcmR6SmcycUJEamZseFcwVXRuY1NzM3lPUzZBeU1Da0lh?=
 =?utf-8?Q?8x4dPswQhRjlQYjAM5wj/4c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TERrenBselowZ2QyZTA2SEtmMUFtNmh1RjZJTmxEUzdBdW1vaTlPZ1hJb2oz?=
 =?utf-8?B?RVNESTJ6NEUrTDVUc0tqNkxxRmNTUkYrODJvejhnUEduRUtnckVQMG5WZHk0?=
 =?utf-8?B?aWZheEs2QmJOcVpJQXBxdDJKMHEzNzR4L0ZkbjRoS2lhQ1FiWXpMa3M5dC9a?=
 =?utf-8?B?bTNEcUlkZXZ3d1EvZGxQMnJmMkM3NFlmYU5iem4zSmhyQXNualpIR212TDhE?=
 =?utf-8?B?dnM4ZkFOaWF3Y0ozbnFYK09JNmN5eFQxU3ZuNXU1Q2ZWVnRuS2FtMkRvOWJD?=
 =?utf-8?B?QlY3cHROTFZRSmhDVi9USFhJSU9CRGxmNDltSitBd0pnbmpXUUVlZnZKWXdJ?=
 =?utf-8?B?MlY4ME92dWsrUzB4WkM4N0luRjVGUGRXdzBaVjdqaHQ3YUF3bUd5TlE1ZEtB?=
 =?utf-8?B?ZlNIWjYvQnRnaml1Y3NuZE5sWXo1dTZmWDlpc1RUVkIrcHRJZHUvWVpKVnZm?=
 =?utf-8?B?VHU1YWV3QStWZ1MzM3A3TGRyOUdRN0pMT0I2aXFxcGVlRWttYmdOUjNwUlJP?=
 =?utf-8?B?Z2pBMnR6ZWo0OTVWU2x5WUFqd0hxQSsxdUxFS1BIREE1MjdRb1NYUmhnMTNO?=
 =?utf-8?B?V0NtODFwMFMxTnRLaitpMlkwem5WM1JvSzMyOEJrL1FKMEJHek03RTFDTXdK?=
 =?utf-8?B?aHlaTjdiWkJzQzRrazdiaUpPZ0J5WThVbWR3WGNOV08zQjAyQWl0NWF6RlBQ?=
 =?utf-8?B?Ui9TWkF5cS8vTjZTSGNsTnhDWHRpVVV0UGZGWFFVOUdSOVVHVzRlV3RRQXk4?=
 =?utf-8?B?d1cwZkhWWDVaMTNDUjJwWWtiOU92Q3JQUjdTUmVKNnpWZlZYeUNqdGxtMUhE?=
 =?utf-8?B?cDNVQU1EQ3E4eSs0SzdsSkI3MjRWUC9UTEtFSWpJWnJwTE83Z2xHM1Yyb1B2?=
 =?utf-8?B?ZVFOQklsYWl5R2lZUnM2cVBNT3UwN0duWjZFR1VETzZteHh1WncvajlXQTVE?=
 =?utf-8?B?d0dYTTQ4a3pucmZyTmpvNHRTZDdEb1JJY0hIaWcyZm1na3RDN1MzMHIxNWJi?=
 =?utf-8?B?aUhLUUxqWlRiQlJLZmE3Qnd1a3JYc00vRHAxNHgyUmZ1cWJicmVHVDR0bTE2?=
 =?utf-8?B?K2xBNHN3MEpMbTVMeDVJVEtzdlBLYWtaM2xIZHptNzYxbWtNZzZBWElDV0pX?=
 =?utf-8?B?c3BPcFRsMHVkMlV6alE2RTJBMG1jaG52WU1WbHpDZWFOQ0s0Zkd2eDI2WjlH?=
 =?utf-8?B?Q1Fob2NrK0k0TkRMVjMwUW9hUEMyeWJUb1paT0MrWk13UXZhaGdoOUpONGVQ?=
 =?utf-8?B?Y3ltK2lqaTRGbnJHK0g5Z1lwc0R3SW1SUHJxNnpKZld1dmd6cGdzV29SMlBJ?=
 =?utf-8?B?S21hNE5sQmJTSmhWMFdFQ3FtNGQ1Qmp5TGxyUDh5eUcrZ0xMb3lmUzdDS3R3?=
 =?utf-8?B?M3FYZXUyTnQvR2tISTZxZi9qZW5abHhhdXFkcURkVGw0eXd2dlhZOU9GNkZY?=
 =?utf-8?B?NjMwYnRSQmIrSndFaUV3VVVZN014ZFNRMzUyOTg5cWNzeVgxTXVITFo0ZEgz?=
 =?utf-8?B?ZGw4YlR0eGlEUGRUMTNWNi9HdlpXcVMwamJON0ltZ29RdW5GVll4SUpReTRC?=
 =?utf-8?B?M1RTdTdsN3pSY1NvTXlvODgvV0pqR3U2dVRRS3NJektteEM1aUdMN1gyZnJn?=
 =?utf-8?B?Z1FsSHR3TWwrODk5YVRsWjFOY2EvL3FRRjNkS1NtcDBhSWIxeC85S25zTXA1?=
 =?utf-8?B?YUZ4SndUQ2h6YU1ENkxxY0thRWNFNURjT2xyZUJqbHVDWURkMWpJN0ZpWXp5?=
 =?utf-8?B?Q2poS2RyVnJGNXovSDV6MDJCWGgwaWhFc3lvU2J4d1JhUVhKbHZCWmU4WVhJ?=
 =?utf-8?B?U2R6cFBXQVNDSWhuQmZWcWxSU1pWRzEzMG9jM3JSUkpsMTArVjhvaTBOVmc4?=
 =?utf-8?B?Zk5GaUk0OHNRdXVHbEhuZHV6d2JraDBseU1IVjJWU2lkUUh6U1pyL2xqd3Bu?=
 =?utf-8?B?NGgwblVUU0V3TFlrRjFmSmpBUnFod3BGVk5XYzVadExwZHNwVTFiOGpnSFhh?=
 =?utf-8?B?d2p1VGVSbzBOUVN1RnBTR3Y5aVJhUERGNnVIdFI4Rkh0b09aM3JMS1l5R2dp?=
 =?utf-8?B?bXBYUENxQURTQjRMUHQrTlZoUlZTS1owSEVKUTVtTUJ5ektoVEdUYzltTzB2?=
 =?utf-8?B?c01TbHFwY1dtWkxKVmZzWlQxcERreXExT2J5YVhEdXlmeDlUL0hjbExLVVp1?=
 =?utf-8?B?SnZKSUE0TGFRM0V1MUYzY1dZektrVjhkZGtJc2ZUeWd1dmJCQzNvaEZlMjZr?=
 =?utf-8?B?VGlaZ2tYN1JGZlVud3EzaFg0anNEbm8xa0l4ZmFwdzJZdUxtdENKNDEwUEsy?=
 =?utf-8?B?NjhvcUNoUDdkbTNEbDBub2N5UFEzWlhGZ1VFay96R204OUFJK2UyMXNZTm4y?=
 =?utf-8?Q?PvcqD05bV/50o2bw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <83B1A4BF19FAE149895BED61390E7EC1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0e0f31-f32a-4935-5734-08de68560bff
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2026 03:39:51.0857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eB7E/q5Op7b6X0uAaadqr8xllRyW0ZoYhYAb+1c5rJR6+ajBxUVClYSgcW5yjPO+jlvmceGhEPZUSMiaKQP+LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYQPR03MB9483
X-MTK: N

T24gTW9uLCAyMDI2LTAyLTA5IGF0IDA4OjQ5IC0wODAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IFVGUyAtPiBVRlNIQ0kNCj4gDQo+IE90aGVyd2lzZSB0aGlzIHBhdGNoIGxvb2tzIGdvb2Qg
dG8gbWUuDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0Lg0KDQoNCkhpIEJhcnQsDQoNCk9LLCBJ
IHdpbGwgbWFrZSBpdCBjbGVhcmVyIGluIHRoZSBuZXh0IHZlcnNpb24uDQpCeSB0aGUgd2F5LCBk
byB5b3UgdGhpbmsgaXQgd291bGQgYmUgYXBwcm9wcmlhdGUgdG8gY3JlYXRlIGFub3RoZXINCnBh
dGNoIHRvIGNoYW5nZSBoYmEtPnVmc192ZXJzaW9uIHRvIGhiYS0+dWZzaGNpX3ZlcnNpb24/DQoN
ClRoYW5rcy4NClBldGVyDQoNCg==
