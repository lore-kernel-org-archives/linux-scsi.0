Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D790C7464
	for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2025 05:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758607156; cv=fail; b=Tg+BqtAM+NoNq0zKLMn6RcbqkjFbIKR9Tio+d0xeMt4f7V5y+cLWlanluO1ZzvmiVqYa6xIhr38PoJs2dpe5kiF6b6uVBYWvZujxe/jnXIkcdoJI2tqa4BnIEjZM5bqiLTJPS2PtGpr4THyjOmjok653Padb5ZfbxmR+G2bzWRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758607156; c=relaxed/simple;
	bh=d1TRs7uXeh8bHNhdylaWXJqr+6QJTtPgcKe+osV6ZPU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mIoL4EHm5mIK8JPusOw+oG5pTPMs62ZtfPzubwhzSEZHHmPZ9jzDLxgLFaK8JNY79lPXn/YBSmYYoIhPbOURpqdQFR+WkbVoI4hmxI3pOwk7D1wBjNt5zXo55WVk9dkwW25TydAjDuA8ZMsbBJT1FgeMTaDaMzjzZ6LkkdUj/Ho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ivPGDKKJ; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ZDNIldJU; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ivPGDKKJ";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ZDNIldJU"
X-UUID: 6be1fad6984211f08d9e1119e76e3a28-20250923
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=d1TRs7uXeh8bHNhdylaWXJqr+6QJTtPgcKe+osV6ZPU=;
	b=ivPGDKKJBiyMBMZqEzwBHaI9U0zcV9swdR03swDCCUzrlCRcMlsl6/W3JfyEwQPHyHzF9kMlOqsE9mnx/BrBIwLcMwvkfsYs8WEwrJRRMKIYgLloslXKQ4SE1FawkESiZCX29XbGL45pWz3p1jdB1Z8vBbeH55aJmw0sN/V27dc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:41456a4c-2ae4-4a14-bb30-eb1d66eae285,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:21a1d86c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6be1fad6984211f08d9e1119e76e3a28-20250923
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1660288975; Tue, 23 Sep 2025 13:59:09 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 23 Sep 2025 13:59:07 +0800
Received: from SG2PR04CU009.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Tue, 23 Sep 2025 13:59:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HI9vh80P/ka0bJXjpea61KdZwogU1Jq0R39pHdDKr1vN9DwxiDLvGzHQQAzG9VL5Sw0my3IAGVNtxymEbVcui52orz99yUoT8CPMIvStcrodmDZR6X8k8RHPu2EwOHSGblzRTsg6DJlp94m0vp6P2YWGoNdKHYcD6AZvxPzB3BwT/zvArU/FfqNe7ZqltZWkb4a3Arg/Md1V29VDh25o5u89Wx2aL8+QwjJP/dRhpuXdFLmpmUAf9s1xJA9hZ4gq+EZ6JeZ+xDDxmXnGijMro89YTnhzTSfOUTOX0mnT0KWrKwAx2wUGt4ZutlQGRhq+WRx3wkkeNvM2lhOrI7pSUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d1TRs7uXeh8bHNhdylaWXJqr+6QJTtPgcKe+osV6ZPU=;
 b=ezdbQQVvmpPBe22/InP0Ou+/zcqSH3W6DWYZ5gRJpaP8Yy3HTLc/LMkmLEA/N50et93+4rBM4EaPBDZWq/9oCuRi9goQhpJu+ryoDzbxsu3ziZVQlGGtDgKwAUrVw5y/IbYhz6cHmUpXZt141LjUj9MSzjxXvolbQA4qqCqTviiXv2YtCm1Of/1q1LpSD/SGznOAoYvac3Y0cwX21PhV5QoGSo0tFL7aeLifIoz2ULUJFqQKqnxd/oNhRq/1SCKZwUp2pGBmkOT3LnlNA8XwQJLaPfQjjRJRoXPmDqzva6JCiebS+VCeFNJb7KF85N1AvkUETQd0GU/RSpy8oTOVvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1TRs7uXeh8bHNhdylaWXJqr+6QJTtPgcKe+osV6ZPU=;
 b=ZDNIldJUlX0wgkt68qU7wGCLFi7HNLlrVHFqf79IUx16GdnH+TglM1ej0o2aivRD6xll42Pe6xDW2bJ5FkQTB6ajRFI3OGR0b3gy7T4B3+xO3wIM6kyjvnJa+pybMJgcNFcDHfX7jldISob/Sp2gJgdrAdAKlx0/GfH+c8s2MNU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY1PPFDC458EFE2.apcprd03.prod.outlook.com (2603:1096:408::a6f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 23 Sep
 2025 05:59:05 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 05:59:04 +0000
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
Subject: Re: [PATCH v1 06/10] ufs: host: mediatek: Enable interrupts for MCQ
 mode
Thread-Topic: [PATCH v1 06/10] ufs: host: mediatek: Enable interrupts for MCQ
 mode
Thread-Index: AQHcKIiyg6scP6qY1kauuFd5GClYQbSZRI8AgADlVACAANhogIAD5gmAgAC0UQCAALCdgA==
Date: Tue, 23 Sep 2025 05:59:04 +0000
Message-ID: <6eee2bee945a537588af4a529f0b284678e2bee5.camel@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
	 <20250918104000.208856-7-peter.wang@mediatek.com>
	 <5ae6134f-6e41-4453-b11f-4e3eb92a1c04@acm.org>
	 <beda693842394d162c95d5523eb90373fd975d3c.camel@mediatek.com>
	 <3d2a98e0-03d3-4b7b-816c-581d77551598@acm.org>
	 <9b09e799df468f2fe33bd9acab6d2487d0539e7e.camel@mediatek.com>
	 <f60146c1-e0bf-40dd-adb1-95fe8884c550@acm.org>
In-Reply-To: <f60146c1-e0bf-40dd-adb1-95fe8884c550@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY1PPFDC458EFE2:EE_
x-ms-office365-filtering-correlation-id: 4cf31d7a-ec9b-44b8-67b7-08ddfa664d5c
x-ld-processed: a7687ede-7a6b-4ef6-bace-642f677fbe31,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NU4vWTE2cEpHb3JMTHJqc1BZZGNJbkdTOWVVKytaelZwbTgyY2cxUU0xVStJ?=
 =?utf-8?B?RmRmVHJUa05NcDlxNnVhMktvZW55OTBTWW9qRzRNdGRkaEpoVjVBeEhnME9Y?=
 =?utf-8?B?VGsrbk1TZjhqaHVvMTREYng3cmVTMjdZTWhwb25XMnVaaWpCQkxpQlQ5OVNn?=
 =?utf-8?B?M3pEclhBK1Ava0IrNU11SDlMNUUrcFVlR09rWFVCNVNGSDdTdU5JQnNNdGc5?=
 =?utf-8?B?QWNFOThvaG0vMHNMMSt0cngzYW1VNldEVEdlbVRaVDY5U0QvOUl2YkxFWjhZ?=
 =?utf-8?B?TkhPaCtXc2lON20yWG01U1MreXhtTncxV21oVEltUXFlT2hrbGFmK1ZuWEpl?=
 =?utf-8?B?d0l4cTlMM2xjQmRyYWpkNzU2YkF3c1dQVGxTSDdkYWRZdmIrQUxua1A5WExJ?=
 =?utf-8?B?QVd0VTFoODdRVjJIZGE4SXp5Rlo1SDlTTEg2WEEwUzdkNDZhZm9CQVVodmF6?=
 =?utf-8?B?c3J2Q3F6U05Pak1SVE96ZFMwMWh4VDEvUVpFM2pOMmJJbVBSWjQrbHFQaVor?=
 =?utf-8?B?ZENEdkJOM3l3Ky9PMkVMdGFYS1lyK2w0SEVoZmlXcm16b2hndFNqUTRISyto?=
 =?utf-8?B?dEJLVGNwb1Z3Q0NIc0xOL0k0K0hYcFdncHV5VCtadkFSTzFickZpMUdIZ2xw?=
 =?utf-8?B?RnQwN0I2alZ6Z1E0cXFrbnM0QjJUb2pwM2hRMTlWUDlNQ2lIMjY0TlpwUDdR?=
 =?utf-8?B?S2YvdTViWnUxYXgrTTh4UEJ0bzdFZzNTOTVEODZGYW5rTEJTcGVKNWtuUENS?=
 =?utf-8?B?NENFajMxVmRKelpxWnJsVUF0MzdCT21Ea0gzWDY0SmtyNWpZZjZMd1VucnM4?=
 =?utf-8?B?aFVpdDRJL3VYdCtKL2U0OWFVbFRTQkc2STZmSzBrWWVUT25aTnVEYXU5Tzdo?=
 =?utf-8?B?eXJJOTBLc0VzNE5MZElJVStrSnBDcWx0TlgvVVlCNEtjZk1NSmVHb3dkUHpt?=
 =?utf-8?B?eEZscEZOVDBmbjJ5dHdBRXFHZVdZRlJ2SjhRL1pURlAxbWp4alViSitIS3g4?=
 =?utf-8?B?dGZnRUVLVU9KZmR4cmtjQmxRcDZ1YnE4QVdUb0ovNkNWVDQrVFp2K0F6RWp0?=
 =?utf-8?B?ZkUzbXZCUW1MaTBWRjJoT1h6enBicFprTERUK1Rzb1hiQmJKZm5nWGgrRGgv?=
 =?utf-8?B?UjhHcVcyZDNZcThOZkhjb3MwS3FQRmRCaEtkTUtDQ2I4aFhsMlVrWUJsdm1H?=
 =?utf-8?B?MUhjd2ZzVVRsOUFRNTB4WVNkdStNWkQzUUlNSGZzL2pWRzRZbU5Cbm01cGky?=
 =?utf-8?B?WDR5d0tZN2lqclRQMlFOVkpndzU5aEloYjJzUlRyU3RJcm45TzFyKzZzdHd5?=
 =?utf-8?B?bHVNS085OUhxNG82cjIyc1d4NjRSY3A2TDdrOVlyY2VCNDErazFlc21FUjVF?=
 =?utf-8?B?ZDlLTjdmZk1mQ3IydUxkUXdZS2wrOE1Kb2x2Z1hNYmJuQ29vODZsanNIeDN3?=
 =?utf-8?B?dWZmR3g1eTRJbWE2eXI4djlJeGlmenRqTXlkUTRTZm5mRFNkR0I3M3lWVDlI?=
 =?utf-8?B?YWJ1TVNJenJ1TEpvWnpaeVZHdXlhNlQya0NneVpFeEY5RllPQ2M4WkpGbXJr?=
 =?utf-8?B?VmovQUxZSU9YSUxmUE1Zem5YNm5QeDh0MGsrNzZkTmZrdjFjc1RjZDlWSTk0?=
 =?utf-8?B?TUpjdEJ6ZlNRM3dIM3JJa3JtdTZ2VHM4RTh2N1F5MWNwUWE0NFV4YVY2VjVp?=
 =?utf-8?B?M3dCQUJyeWZkL1NBRkRUcW9EMytVWklnNzVYUzBEN0JRRFdoQUhQUnBuWVp3?=
 =?utf-8?B?SUZzbytwdFpEN1NqUjFra2pOYmJhTThrUGt5RURQSjh5eHdJU2pJbjA4R2Zy?=
 =?utf-8?B?SHVZNDBkZ1Q0Rkk1S1lWTlV1NXpzb2V5VWNUY1BzVXMzendVV1hJaVEvYSsr?=
 =?utf-8?B?OENIS2tyNzg5d256NUc0UnQ3bU1hVFlkUXUzMnBFQnJhZ3A5aUhHek50Yjdv?=
 =?utf-8?B?UGdTNlpKU0ViSXFtZ0ZUS2RweEpNMFJHVmltNFRNa05OQmpNdWp5TTFLc0NV?=
 =?utf-8?Q?1OO35GYHHwqc3jWQq7nzTXWbn66PhU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVJ1R3RQMjR1V1ZNWmFjTVl0NUVIUXhCVzdyZHgvUmp6bTZhbVIyNzdHMEpw?=
 =?utf-8?B?RmNsb0NmNGUxS1ErQlJpa3FjNTczUmQxL0FYejkwaEdVMkZHK2JnNG90N2Rw?=
 =?utf-8?B?a0daRUNEM056NHBFOG9lVnpXSVQxdU5XQ2hjTVpQeXpXblF0a09INmtYSFpj?=
 =?utf-8?B?M2NEeFVZMDVjS1A4eWlxTXhtQXB4M2ttT1BGWlMyVlZWZGJDNkpBaWlxMjhm?=
 =?utf-8?B?Qy84aVd0OE9SemtFcEpwQXRmaFZmUDFYOTlGQ2Z0dVZCempmV3JoUWczeFJO?=
 =?utf-8?B?d2pEWEp3VkZ0QU4rbUR3dElocC9sVG9IMFo4UDNiQXNBWU9WVWhLcFF0K1Bl?=
 =?utf-8?B?Z1djQUF2UnEvRlVnOHJXSDR3WE5HZkJXS1pQRlN4SWlrb0dzd29nd2lxZUdI?=
 =?utf-8?B?TGx0Zm1sSFQyU01wUlZOd29yWFVCR3N1ZUV5R0ZWODgxYVl1QzY2Sk85VXFT?=
 =?utf-8?B?ZStiMWxZTkp4ekFtWjIrWnZWdmNPYllMSEhOUUhhUWlJdTVMNFdkV2FlTVNB?=
 =?utf-8?B?cHQrY2ZST01SdGdWbTUxRkkyc1ZRQUFNOXBpajVJaWZCbE15VTlNRjU1V1Y4?=
 =?utf-8?B?NFRHVHlHQS9uTjlTRHJLMVBZeHQ1WThJaDU0L1pKN0VHUS83Z3FkR2dJUEp5?=
 =?utf-8?B?Q1JZdU9XdHJ2TnJIS1FLbExnQ1EvT3ZYdjBQcDhvK1R0UUtBN09TSUdrMGg2?=
 =?utf-8?B?dUpGKzhBWG1IdDJVR2RmWUJZeXAyajNTSHNVNE0zWUs4VStWQnV5WEhQdldw?=
 =?utf-8?B?SGFRQk44MUZvR0htUFFDbU1FZGxWR1BWZlNQZTNPZmVuTUl3eHVha2doZUJo?=
 =?utf-8?B?ZlY5TjNMckt4UVE4ZS82V285YXY5TGt2c3FMbnpsS2IzeHJ3MWpDb2VZMUxJ?=
 =?utf-8?B?N3FOZkJBTDhNTnZjMFAyV0ZUc2NNWHhuWThoQXdmS0x5QVJxZ3FSZTlzTnVI?=
 =?utf-8?B?b0tkYzF0dWUrbzVMYlZhN1BycHNEaEMwMUNNRFlncjVFS1MySDFMa0I1VkVz?=
 =?utf-8?B?MlNxL2FDU0pEMjhEVThUYkt5VEJrWEc2d0ZDSDFEbEhrWHIwS1JWYzdHU1Zm?=
 =?utf-8?B?M1B6UitlS3VUTktqYmVZRUVlWWd4cHRxOHltMEdoY2FHQVdiVFkxODI3R2Y0?=
 =?utf-8?B?cDNwajIzM3NqMjVYL1lyZi9EemJZZzFjL0NVNmZIRENoN1JlQ2pFTUNUNENj?=
 =?utf-8?B?Rml1WU0xRGZ3dzhpd0tNT0NVOTlVSUtEd1QybVpPZVRvS3N6a3kyT2lHQTVJ?=
 =?utf-8?B?Wk1zMHJ0K255T2tPblp2OHI4cmVES0RKVFNrSk1OOVZnT2ZuaFhubmZQUi9E?=
 =?utf-8?B?cTEzZmNZM2QvakNXb1Zxd2g5ZXZtTElRVjc0eCtRekovdldKTFQ3ZHdMamJZ?=
 =?utf-8?B?eU1aWmd2bnFhL0g3dFNvMlRLVWJZWUZmNzhuQUFSNVVDVk14RVBrSWl3Yi91?=
 =?utf-8?B?WXdVL25LODVidThiZStvMkRxR2F3cFdHeFFxOWtidnA1NEQvZ0laWS9jNTN2?=
 =?utf-8?B?TlhjQ1F1dGRYY2svRGJ0ZnBVWEpUNmhyWXhnZU5GYVByeTN3SWJzZ1Z4bzZW?=
 =?utf-8?B?Q0VsdW5QWG1hSXBTSEY2ZzJCYVlZZEEwZlJ1cngxNnVkSG1vZ0UyNnYzdEJj?=
 =?utf-8?B?YUZreW9Mc0VzKzlZRDNVRGtCVVJ5TVlZdFV6Y3RrNlVuK1l5cGRXOUh3cFoy?=
 =?utf-8?B?RmJ4Tk42TGZEQmdiMmZwWFhRQmdzSzIzWk0xb2F0QTd4YjB5UmphaXhtRFdl?=
 =?utf-8?B?WXlYYzc1Y3JWd1dnT2hrZVBzRnI4VjVpSURYYVV0WjlFS3BPNFJLSGFpdkR6?=
 =?utf-8?B?am54S205ZkFmc1NQQUEzczR6NzRFSW1ZalpxZ3BJNFUxdmxhSkJPQUxlNDh6?=
 =?utf-8?B?b2RlZTRjaDA3dUM1QjFMM1piN1YzSVNBMWNreGhlbHN3NHhXWG84anpwRC9q?=
 =?utf-8?B?clVBWFFrdkEvMndaVVlBaEJBdjRaNE1KaU0zaDZ0eTRHWWhHV2JlZEl4a2xw?=
 =?utf-8?B?c25rYVRadjdUZFR3K3lRUXRCVktVVmJ0a2xjakhGdTVEMi9iNlNFNXZLczg4?=
 =?utf-8?B?OVFUMFdpUnVZZ2UwR3pEQjhSWFRVRlk2T1R5eHU1UWF6NVRJamMvb0hhNHhs?=
 =?utf-8?B?WlRoKzdCcU84eHJuWHltS0xoN05UN1RpVmJVeUlEYVFrV1MxTTJ0VWFFdEEy?=
 =?utf-8?B?L1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABF519791B59714EB3E9DF925FF8898D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cf31d7a-ec9b-44b8-67b7-08ddfa664d5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2025 05:59:04.7876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LVp+MYHLl8xa+LbO4IQMdOOPjZ1CYXx+2rphA0Yy/TZ2HTYi7XbWG78VrbdpsQhv8BGJ/ksLlr5NlYtbi5i0tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PPFDC458EFE2

T24gTW9uLCAyMDI1LTA5LTIyIGF0IDEyOjI2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ID4gPCBoYmEtPm5yX2h3X3F1ZXVlczsgaSsrKSB7DQo+IA0KPiBUaGFua3MsIHRoaXMgbG9v
a3MgYmV0dGVyIHRvIG1lLg0KPiANCj4gSWYgYW4gdWZzaGNkX2VuYWJsZV9pbnRyKCkgY2FsbCBp
cyBhZGRlZCBpbg0KPiB1ZnNoY2RfbWNxX21ha2VfcXVldWVzX29wZXJhdGlvbmFsKCksIHNob3Vs
ZG4ndCB0aGUNCj4gdWZzaGNkX2VuYWJsZV9pbnRyKCkNCj4gY2FsbCBiZSByZW1vdmVkIGZyb20g
dWZzaGNkX2NvbmZpZ19tY3EoKT8NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQuDQoNCkhpIEJh
cnQsDQoNClllcywgaXQgc2hvdWxkIGJlIHJlbW92ZWQgYXMgd2VsbC4NCkkgd2lsbCBzdWJtaXQg
YW5vdGhlciBwYXRjaCBmb3IgdGhpcy4NCg0KVGhhbmtzDQpQZXRlcg0KDQoNCg==
