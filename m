Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5569118C34B
	for <linux-scsi@vger.kernel.org>; Mon, 15 Jul 2024 12:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721046799; cv=fail; b=DfiDCh1LVd4Z2pcnvrQnerCs8NpyfwkxwdDDh5jo4RpI39SUTCRFps/NerTuvDiwKJYVR3zkVpcG3XXergsbpqmWqAxYoQGCiZejifn25fbvdMuhCEqSDzEf50NGu+vsc+uwU8r1dC82utjPjce9jfC4SKBTxcF8N52GdGL6BgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721046799; c=relaxed/simple;
	bh=4kmzbEJsjVOp/z44BZcALHmrelmPvQG/KTxMywCh0F0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CDGb1G529vGGarKtoWXByXNAVwLxLpMeDm2WJJTGOxDMAArOM4zPhdfqTlj5xmDtSGU73IUOw2ImmsmDaFZ2QnEBhJs4V5M+HU8gBpyKuxxmrOH1762/6mH7xjBuGQdv/ZkJn4Tv9915zGgrUZ+QTGBuZ1oqw6EfBcg5pFo/ukU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=AMoBCfGI; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=ahY953nN; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="AMoBCfGI";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="ahY953nN"
X-UUID: 63d6bb6c42a611ef87684b57767b52b1-20240715
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=4kmzbEJsjVOp/z44BZcALHmrelmPvQG/KTxMywCh0F0=;
	b=AMoBCfGIiAEXzAH00SVslKdA9geOMdjWaTvAdzFzJ2Mga3AAsP2/+MYo0uKKeq3bQ1TbC3T+JqpEcghNmDgtL68f/Cl/4y/5DjYyUWRM7/nutXLN2U/VqA3bEYCIDz/BaD9hqTbwmfBBuC76oz4DYnc2Cll7iocdUevPo+f4X8c=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.40,REQID:d59ae2de-9358-46ad-8d5f-f375ca039282,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:ba885a6,CLOUDID:24377a0d-46b0-425a-97d3-4623fe284021,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 63d6bb6c42a611ef87684b57767b52b1-20240715
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 972880788; Mon, 15 Jul 2024 20:33:07 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 15 Jul 2024 20:33:09 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 15 Jul 2024 20:33:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CUVznuEqikChk5yueU9IgaXe7PFkJPuBU9bl8xRhbSy7CDHqUycDpdMELVtba1HPK4Z1UDRA1ObGq7IV7Ft945CDyNbOgY4V733SUcqsJOCE5bxOt7fbapB3RqrvbVCkzE8J63fgAiIZx9bkUIHC+dyS31BofOmfuSnhJwLg9cRezxEuHnDbGB8jjeVb71Fc/7PFYebhrCdPpuCTzBgyi+AC3VT9vWedygmg9iMr1Tzx/UlUjr7OvTTlvZTHKI8N1iO5gp9lcko0/f5xCl0m8k/jehulOmTWAd1dYGwdUSBA7bD60Urih5Iqf3/4oWS4zCMWsGBy2q4JkFXTDmZLWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4kmzbEJsjVOp/z44BZcALHmrelmPvQG/KTxMywCh0F0=;
 b=AyTjFMLQrSZtIOM8IlAuM5KDtOQ2m3Jg1OHn07crLIb0WPLAkQ7Rb9HYUgRuXVhF7iKzI+eIROHL4sCorN6WLm0vPati9okCZvsja+2IWR7HiGoKPHo4/x+NXkAH7wrN31N7rAtKDBivU43rqDbvuR7fcuxeZuenKCDS351qNiS6UVuYtKoj3R1x6HGrgUVeX5XP1SHWKsDJO6JQJ9X94E/U1QT2p4uXS/MVDQbt8Nix7mBJSTX7zagaGSjKMTPipsznZ7FGzJxKus/nsFJo2R5OIt/ieBubJOTnnmworsEsq9us3MCflatiDkKRSb2gilCM4jnc55WY2O9/VcPLaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kmzbEJsjVOp/z44BZcALHmrelmPvQG/KTxMywCh0F0=;
 b=ahY953nNddFG7/1Kdc54tqf8Jyu8jGAzlejhySJn3LYg5yousVqotyFx4XKMObqDmuPdR+AAxxKg2keTBxD5Hr4daRH85t1cp2DhGd3smYFUl7zHwPyCORB0jEOb/8WR3581u8CRjy4INMoQl2h8bxYDS+0kKJ3F2m4bu/azWRc=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYZPR03MB7931.apcprd03.prod.outlook.com (2603:1096:400:462::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 12:33:07 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%5]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 12:33:07 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ahalaney@redhat.com" <ahalaney@redhat.com>, "beanhuo@micron.com"
	<beanhuo@micron.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
	"James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "matthias.bgg@gmail.com"
	<matthias.bgg@gmail.com>, "angelogioacchino.delregno@collabora.com"
	<angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH v5 08/10] scsi: ufs: Move the ufshcd_mcq_enable() call
Thread-Topic: [PATCH v5 08/10] scsi: ufs: Move the ufshcd_mcq_enable() call
Thread-Index: AQHa0Xx4mNXPzc/Ps0Wc7aWkEkc2GLH3w08A
Date: Mon, 15 Jul 2024 12:33:07 +0000
Message-ID: <ae77da8bc4bf6885d2f393dce44a63741b76758c.camel@mediatek.com>
References: <20240708211716.2827751-1-bvanassche@acm.org>
	 <20240708211716.2827751-9-bvanassche@acm.org>
In-Reply-To: <20240708211716.2827751-9-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYZPR03MB7931:EE_
x-ms-office365-filtering-correlation-id: 8f1a967e-f109-44b2-00dd-08dca4ca47cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bUJiNktIdnJCZHhUdGpHZEJseENJYlhjKzhmcTdvcWcvOTB0dkpDM3JZNlQ4?=
 =?utf-8?B?akZhZHZjajBkZmNBdkd5anI5QVNxajZSdVNRSnIzaHJKWUpTQVJ3YkVOOGs4?=
 =?utf-8?B?RjY4Qk41L0ZkZk9QdVp1cW1MTEJoTWJNeEhuWmljT0NadTMxSW5sV3kxOVlo?=
 =?utf-8?B?SlhsdlBEZDNUNG9sU2NFZmR3Y3VzYzFlTDUxZFFuZ1JnNGlzRkZUdG1RNHYw?=
 =?utf-8?B?c3UzbWs4eTdjREdFeVlZV0N6OExPY3o4K0wzZ0NWTFg2SU5PYVJwdTY4dmpz?=
 =?utf-8?B?RUxpYjBIazNPbXhWSVhkeUdPakd3dlRmTEdvRnpzYmttMnBXVUhreFFwL1Zl?=
 =?utf-8?B?VVdEb1RzK3BTQ0xZcGU3NVdzOCtnenh2ampISFFLNW1oZWRuTEw5Ri9XbTNB?=
 =?utf-8?B?SFliZ0pIeC9kamNpeWFtNTVXMnB6R2RQWm9CaHVVZUVQalB4V0UrQVZ2L3Rr?=
 =?utf-8?B?TDNlNVcwcEhOZTMrMVo0NjlidENWQ2RxMTZpQU0zTFRpUmorbi9TWU14M0VC?=
 =?utf-8?B?NUVBT3h1NG82akZXdFRVM2Y5ZkNsdEE1OVdHWjlFTXNVYW0zN0dlZDRaa0Ro?=
 =?utf-8?B?RWlTWURROTErSDBSMzd1QlpsYmNEYkYzQ0NVYUdKei9maWtzdlYrYzJXaGZr?=
 =?utf-8?B?MWE5RklHdVlYcjFPMWo3eVZYMlVqL1NDaEIvSTZVbjBoSWFhZCs5My94aXdq?=
 =?utf-8?B?YVV6RDhYMzVFMmxCT0cvTzJWMU1LNFBHNEMrTUorVFpoS0NmVDRpV29GNGI5?=
 =?utf-8?B?Y0o1Z2RYUU9nNDZFL2ZpL3Q1WVh5SjFhUnJuTzVGRkxFWXgyUzE4MDFLdis0?=
 =?utf-8?B?d0JLbVo4d2sxZjN6aUFmVHNuZkpGc1lvRmw1cjNhWUdHY2tjWFdZd0M2aFla?=
 =?utf-8?B?WEZUN3dwUXN0VitHei9PMjZxN3VsZVNxWFI1Vy9PWnBxYy9wMmhyKzNnalZ0?=
 =?utf-8?B?OFF3ZnpSZUd1VDAxT3JZVUs3emNidWJjdWFFUzV0aDZEZlR2eGY2S3ZIMUZK?=
 =?utf-8?B?TWNvMmFaMGJ2TjJKSDdXZzhraWJueitQVFNhWGRVd05lZy9wUWEyakxQaVJS?=
 =?utf-8?B?RGV3ckFRQ3BVMk01cUcrZDdmTlhqM2p3VTUrTDQ2YlhBbU56NXRNU1FrK2NI?=
 =?utf-8?B?K2RkclJBSHVSSmNQZEppd0d5VEZWS0R5UFJ0eTlxMGRQWGdaMnYvRE1ER1JH?=
 =?utf-8?B?SW0zWS8wc2hobGQxL0VRZlQ4YUNwSUs1RkxDU1RreE1zdzZwU25LVmxHMVFv?=
 =?utf-8?B?QzdvYVcrdlphWUdla3NvTVhHZEJSKy92YTRqa2piOTJ1Z3cvWC9LZG90ZVdF?=
 =?utf-8?B?bGppU1JYMktZYnRDcjd5d2VMVHFJczd2bFRxNDF6SjhaRlZPSUtXRFRZM2xX?=
 =?utf-8?B?bTRFUGZvbklibjY1V1pFN2FzYldYWncwNktiRWNmWGRKazJHUFhKdm1yaWZv?=
 =?utf-8?B?MC9iUjdEUzJScHdnMURYREY0bVR3M0xlc0ZEcVZ5KzArTHVaRVBJUk9ZR0wr?=
 =?utf-8?B?QktHTVlkNFUrYWN0cVR6SWw4ZzJWRmZjdzgzRkYzYWxuTjF6ZHNzTUlmYmhF?=
 =?utf-8?B?ZitRVExKMVV2aDQ3NnhTUHN5S3c2bUEvc2E1eDdQMVVSMzNpNGdJRS8vMjMw?=
 =?utf-8?B?VVIrdm4rWUN0YmprZENUQTUxeWdYQVhvQVRWTE12Y0hCeHpwS1p2VXJJWG5P?=
 =?utf-8?B?VmRYc2d3dnhQcE5mZk9YZEhSLy8vVnhvRENOTU5Nc3poQzhPVDFMRFh6cm1z?=
 =?utf-8?B?RUZtMTk1SEhqYkxsL3orLzNIeUdDRVcyMzBtcndHUFZqT2dlbnprRWhXa291?=
 =?utf-8?B?WkRwTFNXYjE2T1F4UTUyMEVIdklwK3M1aGd2ME8wY2RoWFAzUEJ6L01GYTlQ?=
 =?utf-8?B?eXd5aURkcHVRQzRPaU5DajZMd1NvQVRNT25qRGRKcTBkckE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RENYWFJzL0xLbHNvVE1pMXN5UHVLSWw2QmdvV3paS2VObDNRNWVpQWNoL0N3?=
 =?utf-8?B?WnZBRFR6dVVOZkZ5TXliYTI3WWVKT25wbEVYOVpCdThQVXhYSzRQM0lEeS9u?=
 =?utf-8?B?MEpNOTJsOU5yUVozTzBoSlNRM3EvVkNHRnZKOGQ4N3ByM25ZZUxBVUJ0T1cx?=
 =?utf-8?B?WEdDaURRcjZuTnhVcFpGM1EyNzEzYW9nUmNJUEx3ZmsvamZaMm5CNkN3cUk2?=
 =?utf-8?B?T2p0bW9oTGR3ZE1LK3lyRnlCNHNlcUtsbDhEM3UrZGgzR0UrVzRZOVpQZnc4?=
 =?utf-8?B?OEdKcVVGS1VoWDZGbWJ3WWRHTnIrd3hDZnJ0S2RoT093VTZKWXNyMWpUVjlZ?=
 =?utf-8?B?SGtWT2l6LzFyVmp6UG1adFdKUXdHVGdRRkJRUHZvY2lyNmJTcFhXOFU1ak5v?=
 =?utf-8?B?Z1BiTnpUNk1EaFlTT3ZlZWR5UWhzdmxoSHVGMThLRjNtUGNpQk93WGpkRjlV?=
 =?utf-8?B?V1pZODN1dFBGNittMUFDV09VTVZsQjZlVEJjZG9rbEsxZlRaRHJEcVNXeGNR?=
 =?utf-8?B?dzVKTUE2UUJIckh2VjcrL0MwclZBOWZoUkdxclVmbmxBcTRxbk5Jb0I1RGo3?=
 =?utf-8?B?dFhmTElxU0s5NXpINVN2RkIvM2pBbnhGOHR4Z0VUVTI5M2V0akY0TkN2cjhx?=
 =?utf-8?B?M0pYOGsxYVI5clM5L2J3cHNIbFFncGhGaTdFM3hYQ0lsSjJTRkpHOEtkOXFU?=
 =?utf-8?B?eFJaaTNFTU90eFVKN0pFZDZWd1hsdW44Q3hYMjJ6SFkyK3gwU2w3YjFkSWIw?=
 =?utf-8?B?bExrWnhDcWJqVFdUaDUwWTFLODA3RVpQZHpMQzU1MnJHSisyR2F5WUhRanpx?=
 =?utf-8?B?RDVqY3FyQStCQy9KbXlhQWorcHdIY1Y3WUY5NGpsZzM4c3A5UWh2OXphTFpV?=
 =?utf-8?B?QzU0Rk9xK0w3WCtKcUdyQStpL2o0ZVhwdkxmR0I2dUErYnJ4TVQzV3JkMHUr?=
 =?utf-8?B?Ny9OZGF6Q0JJUWtLMjdYaUFiT0tYdDlmVlRLMDdFVXFuMFVNWVU3dmFJRTgw?=
 =?utf-8?B?aEh2ZUFaTzhhR240b0RINml0NURzcTRXSXJtYkFLdFl6MzVBSU1nUjBVbVZQ?=
 =?utf-8?B?UWNnajVCR1R5ZDZxdmZmTmhLT2NlWVN6YWVrdW9HQW9hQ2wyZlZWUlFnWGE5?=
 =?utf-8?B?VEFXZXplcTF2ajMzUzZRMHRhQTc1OG5veEE0d2VpRnZ5RUR3SFdxRlE3dzIy?=
 =?utf-8?B?WGJadjNWU2lteDJqY0RKbUpVdUNDUFd6OGY5YUd4VVdrNzhUbzFQczFpRnRQ?=
 =?utf-8?B?cGMvcjBoVDNybEhFVmFWZENZWXhvMzFPVzF2ZkFWdVhYZjFzbzB3L1VtYitz?=
 =?utf-8?B?Slp3S3lpZXB2QXVKM2pWcjJDZ0pvcE50LzNna0hucXNlVVNKdHBjMHNhQUpp?=
 =?utf-8?B?dXJ5RjBQQ2oxcTJzYUkzOFI2eEl0ZUhNMkkvcmJFQis3ei9Edmxta0E0K0F1?=
 =?utf-8?B?RU8wT216dWc3aUNaWkdwbTFXOWhNd3VTb3lUZ2xrdVl5emNCckt3UEhUbU9O?=
 =?utf-8?B?RDE0SVBhWE42S1VGWFJkTXZOQXBCN2QzWGY1c24rOGJhc1l1Y2xlYzlHNFZZ?=
 =?utf-8?B?UUFNb3ExU2hRMUF2Qi9uMnpGMXNScXZmaWdoUEN0ZEtvc05YcklTc0NRYWM5?=
 =?utf-8?B?OGxtc2NmTk1FNjlQNHFtek5nZyszY3I5dzN5ZUF5WWxyNVUxLzhnelhkQXl0?=
 =?utf-8?B?ak14TGpQb0Y0UDhqaDNTdjdqZlpjTWpPMUdXaUg3RGwxY0J5Tkg0YTJ6bEtH?=
 =?utf-8?B?TytNanNYMlpTV2JNanA2RkRXRW5aMzB6SUN0eHd2eEN0Um9iS0ZJNCtiZUY2?=
 =?utf-8?B?YytieEVTdG4wVjB6eTdKTDVCQkZKUDRNekc4aVVDM09ZM2htN2VQOWlDZk1T?=
 =?utf-8?B?TG01T3BKRWdJak13ZDVVQUZyK01QK1Q2RXVJUkZ1ZjlVM1cvc2VUdFVuS01h?=
 =?utf-8?B?K0xkUUM2MG1jTmxpcjk0MmNsL0JXcFZTNmQ3NGVMaW1WWGIxV2liOSsrSm9J?=
 =?utf-8?B?eFFZWWdsRUZ1SVFtVjlMVEZERjY1bVExbHJNaFgxWng4cGFhL3ltOTFYTEwz?=
 =?utf-8?B?V2RsTHZueGxTZ2FLclAxMnhKWEtIdVFLVGhna21xWDVWRjNQeThhTnQ0SS9P?=
 =?utf-8?B?ZVZYRnpsQ1k1TWRWcFlhTHpRMDhzMHVNaWxaSEFCTzUrbzZhR21qcXpxaXVH?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A873AFB1D6E16143B66994F9B2F759D1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f1a967e-f109-44b2-00dd-08dca4ca47cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 12:33:07.4265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hu5hdOb5UQXwZ4rGX2Gn8E+ZASoDTtIUaDu+rDhR6LMQkU3XdYcstVKH54PJ2Gcj2tp1pA7VUE4hammc+PcyPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB7931
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--9.993500-8.000000
X-TMASE-MatchedRID: TDQWNTPftUDUL3YCMmnG4omfV7NNMGm+1GdxOr7L6H1V1lQ/Hn0TOl1B
	h0XVM81j1Fc61VCGvh1oYMUHwkc5gHjxgHkp9duCQty8giCJW42r3d1rmRdCgKXJ9vMysD/ClwW
	f7/4SyDvU0OGKE76N6A806TUJTm7zyEM5rU7071YZ9FA+BlOSKmCnlTu2jBBzmyiLZetSf8n5kv
	mj69FXvAOkBnb8H8GWDV8DVAd6AO/dB/CxWTRRu25FeHtsUoHudeDE2wm6rB/hhnkR+mWOcGehq
	7AlC3LSn4cGuT7sX06UTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.993500-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP:
	7C6B730CB0FEDC4B318CEC9BA4C56DB82AA2430EFC4DA63D75480391EE918B422000:8
X-MTK: N

T24gTW9uLCAyMDI0LTA3LTA4IGF0IDE0OjE2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgTW92ZSB0aGUgdWZzaGNkX21jcV9lbmFibGUoKSBjYWxsIGZyb20g
aW5zaWRlIHVmc2hjZF9jb25maWdfbWNxKCkgdG8NCj4gdGhlDQo+IGNhbGxlcnMgb2YgdGhpcyBm
dW5jdGlvbi4gTm8gZnVuY3Rpb25hbGl0eSBpcyBjaGFuZ2VkIGJ5IHRoaXMgcGF0Y2guDQo+IFRo
aXMNCj4gcGF0Y2ggbWFrZXMgYSBsYXRlciBwYXRjaCBlYXNpZXIgdG8gcmVhZCAoInNjc2k6IHVm
czogTWFrZQ0KPiAuZ2V0X2hiYV9tYWMoKQ0KPiBvcHRpb25hbCIpLg0KPiANCj4gQ2M6IFBldGVy
IFdhbmcgPHBldGVyLndhbmdAbWVkaWF0ZWsuY29tPg0KPiBDYzogTWFuaXZhbm5hbiBTYWRoYXNp
dmFtIDxtYW5pdmFubmFuLnNhZGhhc2l2YW1AbGluYXJvLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTog
QmFydCBWYW4gQXNzY2hlIDxidmFuYXNzY2hlQGFjbS5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy91
ZnMvY29yZS91ZnNoY2QuYyB8IDggKysrKystLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2Vy
dGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KDQpSZXZpZXdlZC1ieTogUGV0ZXIgV2FuZyA8
cGV0ZXIud2FuZ0BtZWRpYXRlay5jb20+DQoNCg0K
