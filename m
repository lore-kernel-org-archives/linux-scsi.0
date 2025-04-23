Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7F921FF43
	for <linux-scsi@vger.kernel.org>; Wed, 23 Apr 2025 08:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745395591; cv=fail; b=SzP6cpGjoAa+b/YtpRjkS5umavlKUVbnT2lb90UOpv71RD+X4B97y5DX4YTHYufMF2rzkZiQCfz7P7XTtpFL8Td1RUQ0SmDJhSuUFtXj5z8bbjTC47c4u7Zc25EuLmqkstzJPvnuQlteDcyQzg2qB9ia2saPRM/ZC/2VyTPZKRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745395591; c=relaxed/simple;
	bh=e11HO0Myrkh7pm7R+oMnUFOZbcQ4F/u2eyHkE9DLSnY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LAaPBS6tuZsLFv8IptdvbKl2EN0P3Mc+8mGkj7gKkYCwefQNi5+LypMpFLebskio8trRwPlu8JNHceKy34ca/Ecc+zRu0D7B+HvIGjJDhvurpwB4zKfgR22xHGm1p0vueI1HI627ddX8WkyKyXZTFUkRev3hKNfsecGTLTaMYpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=YWf1ZozM; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=BMyXvuYU; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="YWf1ZozM";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="BMyXvuYU"
X-UUID: d5dbacd0201911f0980a8d1746092496-20250423
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=e11HO0Myrkh7pm7R+oMnUFOZbcQ4F/u2eyHkE9DLSnY=;
	b=YWf1ZozMALGlwcMYhuQo8E85jKuHpmb8uWJcu8TiWubmMh5fMPRVtUqaXy4YZeJegRj6IU3jD3sFq7OrB6foV+E83yJW2NvefRKhJ2fbg57NkiKuVAxtcVvY8sI7JILyU6rl1Y6WymMvy6dr5F0mfVf9+jsjV1F+4bMVYvEBlLc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:ea7a2025-776f-4dd6-b07d-fd3632ef869d,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:0ef645f,CLOUDID:9f14fbca-9427-4819-8156-f3ab5b7769d9,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111,TC:nil,Conte
	nt:0|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: d5dbacd0201911f0980a8d1746092496-20250423
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1333972706; Wed, 23 Apr 2025 16:06:18 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 23 Apr 2025 16:06:17 +0800
Received: from TYDPR03CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 23 Apr 2025 16:06:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PBkrbjhxU6jpGgh7gWrItlDjuPLcomaw0flxNAbsOVJqSfs7jNaSlO5O4GMls6HrPUr6B1iJkqmcFJGKzyMrD6l+jhCSHSkZ/4gaPf0CKC7w8v7l8rOupM5gLKF83hodqFyd831Mf2IDDOEnIXaG8FF2YurZRcOXTxsZndhsQrl1TabvuozewugCRIzHRaAG7Z71HhVQzS1xWX6mGpV4WBulatAPI0ylE2Pv0nYN+mgeZvkKfBy25hTatM2T5oc/jBN3NatAmZa4haWFSTacf+036Ugumo/CZTh4CREUfuRi4jQbrMerynhduYd6PgqkabqW4CFIUN8pB8yaSHrvPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e11HO0Myrkh7pm7R+oMnUFOZbcQ4F/u2eyHkE9DLSnY=;
 b=g/B64t61WWPCBMmA5JxMA2W58627ux/6Yu5O8lIVQ/RL5bAn7pSw65sEIdNjtg5OhZZaIVOpeJsqiR55Jy+8ZH4hPc8moaV3pia2RnAZsb4Jcqmh8r5ga1/vf+hHIOwsTFvgB4A0Po61RXkdoJn8zU/jnNqx+pMFyIYvD+HWvJ0+oGAAwCN/Z2m1i8+xHPXlgPnjzd81BodhFZC7ldswkqG7MH/kb/xTs2I94Pto8tI60hhJFxpYYRl7UAldWvFJQ1eRHbbnpNEqN/DQOOmz8LM2iAdQN892UNw50v5odRl0cDXJzhYEPHKvWjj1zNyNsFu9JIjzspOnEa8QPG+Mzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e11HO0Myrkh7pm7R+oMnUFOZbcQ4F/u2eyHkE9DLSnY=;
 b=BMyXvuYUvoEX5mLtwInJEJscxqqkv8yz8Fev8AKPkzES3umUElSoKZAVVO51X2rgb1GOsHaQy3GHnm1ZnEef0AMhPif5vGiuGOqvGQ78rHWxJ4Sn3WPONscguPIikU4WfLxe+QxvK3kgBnbY/4qjptKgZYmMSQp3z8cuMjvSuQ0=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by KU2PPF6ED75D8C0.apcprd03.prod.outlook.com (2603:1096:d18::416) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Wed, 23 Apr
 2025 08:06:14 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.8678.021; Wed, 23 Apr 2025
 08:06:13 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "tanghuan@vivo.com" <tanghuan@vivo.com>, "bvanassche@acm.org"
	<bvanassche@acm.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"luhongfei@vivo.com" <luhongfei@vivo.com>, "opensource.kernel@vivo.com"
	<opensource.kernel@vivo.com>, "huobean@gmail.com" <huobean@gmail.com>,
	"cang@qti.qualcomm.com" <cang@qti.qualcomm.com>, "richardp@quicinc.com"
	<richardp@quicinc.com>
Subject: Re: [PATCH v11] ufs: core: Add WB buffer resize support
Thread-Topic: [PATCH v11] ufs: core: Add WB buffer resize support
Thread-Index: AQHbtCZLQdhAtI+30kKGSytP4S+MM7Ow5NsA
Date: Wed, 23 Apr 2025 08:06:13 +0000
Message-ID: <7ce05b28f5d4b4b4973244310010c1487bdf4124.camel@mediatek.com>
References: <5588fc82-888e-4be8-b28a-5ab2a69d2ce9@acm.org>
	 <20250411092924.1116-1-tanghuan@vivo.com>
In-Reply-To: <20250411092924.1116-1-tanghuan@vivo.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|KU2PPF6ED75D8C0:EE_
x-ms-office365-filtering-correlation-id: fb18d658-5fd2-4e8b-a36a-08dd823db779
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WVI5WithNWUvMWNIUGl1VHJpdmJTK2ZPTU1yVnZyMDg4T3d1c0pCMEN5UUVj?=
 =?utf-8?B?UUNTZVo2d3JPYXFkSGFJL3YvclJnNU9vRTViSDZRUnpzL0c1RDVsVERENHlm?=
 =?utf-8?B?S1U5dTZzTFNXamZPSFc2NmYxamsrcWM3NDFoQlo0VytsUXpyRzA4RUhuQWdx?=
 =?utf-8?B?YXhDRi8wOE11Y0ZTVklVRlpvSGJ5N0pyWlVsZTMzQnBrVEtIZTgxUDZ3SEpQ?=
 =?utf-8?B?SXh6YTlRMmhFK01oYjRBRnFlVTB4aXFoR3p2V2JsWEVORlB3NnM5M1pBc2Ux?=
 =?utf-8?B?eXhzTzNNNEt2VHJtTWExSU8zdG11ZWtieW9kUEVKSjVXNTdBd2llSm8rOFFj?=
 =?utf-8?B?N2FGanN1ZmUvMzlNRk5WaHo5ZUNUMHp4VmpxTDJRenhDckNGZmlVOEpiUTYx?=
 =?utf-8?B?cE1PK080MGN6WWR0Q2RTVGlJMTg1aVV1R0pHa3pGS3ZiNDVocG5sRlFKSzUw?=
 =?utf-8?B?b1ErRERQNjY3RnB6enlBWWNrYVVPWEozdk1sQ3djQWtPckxBNTFndktqQmJM?=
 =?utf-8?B?SlNVbnNmbnk0L1NEUHl3ZDR0S1k5TTdXR1AzMTNUOFZ3SkU1T2NyUnEwRUl6?=
 =?utf-8?B?KzhCSW1NYmZ1YmhvTzRwZlhzeDhXaEZyaXpJVjVxV2V4aDBLN1RpTS9uNWEv?=
 =?utf-8?B?bjRFSmhmNVRrV1RTUEwrL2lPV1hPeGtmOGNoK0hXWjZLa2tRTlIrUWNzRE9l?=
 =?utf-8?B?Y2R1L29id0Rvd21BZk5Md21OQlFyU092dENPTGlXL0xEUTVRM0NyUDVtQk1Q?=
 =?utf-8?B?V2w4cEFhUDBhZnJCeWFoeCtEQkc0RmVpMmU2TGpBWEp4K1hVaGZTQnJVRFBw?=
 =?utf-8?B?MEV2RnlqMnlXTThIcDVJTFlKdW43WW9nZ29BTUc2RXZYaXpkaEZsSWdxTllR?=
 =?utf-8?B?bTlTVExYKzZvTDkrOHdIc2UzcTdmbXlDSGREa1lFVnZ5U0drNWJmSHZMNUxl?=
 =?utf-8?B?d1I1dW54REdnd05mNnYvVEd5bWI0VHJUUE9jNmd4UFhSN0NVVndSUytGbmxQ?=
 =?utf-8?B?bkVzMnlNaWEwWEd2RGcwNDFSYm5iMVVVQjF2aGU4Yy9ORWFXRDRodHo0Umc1?=
 =?utf-8?B?KzVzZDVTMTVoTCthS05kRGx3b1UwamlTZkdHcklvZVMvNWNCSVZLaWt4UEJ6?=
 =?utf-8?B?YnV3VXpISXNCQXRYcTUzUTV5WnJ5ZUJ3OXJ5aG1TRUdoWm9SV3hNU1FWelFU?=
 =?utf-8?B?OHNmbGcwYmNSV253aXM4amRlVDlZeVNwTEhwUVRXQzZQQzArdTNXakRzNURi?=
 =?utf-8?B?Q2tuUzlweTJDazR1cXBLSXBDekdKNmdEb0lNUlJrS1VValFnMUZRbU0zM2lz?=
 =?utf-8?B?Rm1pSkJXNmlabHhINm1Iemw0bTZ2VzU3Z2dGSWpESVZqbTFXTmV6VERGakho?=
 =?utf-8?B?dUZuQTlpSVhaZWdEdHdUVUM3bkdHTHVxZnFpZXdlUlFMRGhZeHdPeXB5czVN?=
 =?utf-8?B?K2dIcERwanBkVVBFSzZwMXYvUnlaSGVJTWRpcE5JSHRzSUNHbDQ1cVNZdHI0?=
 =?utf-8?B?bEc4S3dVUjgxbkZ0ZlhudXFYRHVhWXdxdWlYTVd3dENrdktONFlUTkdDZytP?=
 =?utf-8?B?SFFDMUwwMzFtNVZCZ1dmdXFweTVzTXZBTkNwcWhoWU1XbCtWSmlmcmVRZS96?=
 =?utf-8?B?TWdOREcvbWwxS00vTXNoSGFSNStzWHhQd1d1QlZnUlU5QjFXeDlvNDh2elZn?=
 =?utf-8?B?M3dPZVpmODI0ZndESEdRR2psdW9qNVpYUVYycHpDTUhyRS9VWnF2aGJPUHRx?=
 =?utf-8?B?ejlTL210Wkhnb3EvTTdLSkpaSUdkK0hlS3d2RUtCbWZVME9HUzFqUU1ZVVJX?=
 =?utf-8?B?TmUwWkJiZTl0ZW1tUnBXckhoaFpuT0kxTG9WaTZXUWVaYklFU1lFR2JyZE1j?=
 =?utf-8?B?ejJkRENJTGlFbytxeW1aVE9ydlI0aHVkZlhINlJkKzkwaVBzS1pIQTVscmZD?=
 =?utf-8?B?cGNjUjZrTjJhSkQ1Z1pOU0ZqWXRtQmcyMXpXME02citzb2pnZHlJb21yTlpj?=
 =?utf-8?Q?TtWBeG84aLQ1gqA1iAlwphSjMkOkaA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDhoTjJUZ2N3ZWFva014bkUxN3FTYlhKL0ZINmlFdkFXcmRGVjRJUFZuS2lO?=
 =?utf-8?B?MTRIOW5YS3k5VVJwaGtpUndFeVJTVVl4Tlp0VVluZUVxRDRWTWdGeHhBZ2dv?=
 =?utf-8?B?a1BqQk9sR2N6WkY3ck5xY3JHUkVzb01hWVNIUjBKNkdLbm1rWDNTMWp0RnVk?=
 =?utf-8?B?a0R1ZDN5T1lDMFBCUVgvbzdpc0NReWpMRFJUd083N0x5SGVITUtpRnc2UlZi?=
 =?utf-8?B?bFlMMmJ4MUlwazdkVHAwKzJRTjU0TzR6ZTlGY2hhSGNMRWI4a2IwemNxUFRm?=
 =?utf-8?B?a0J0VnVkUzNLZjdXM0pNWnNSN3JoQkJqWmQ1YkFmcjNCNkZ3OVIxR0MzalNY?=
 =?utf-8?B?d2RhQ0V1OGhDdVZRMFZuMjhjdzF6MVhwQktOR1lYQjQ5UjVtWlVndUtPWjVO?=
 =?utf-8?B?Z2hENmFJNHFCS3QxS3JpU2EySllIM3RRS1NYdE9pREdyZHJlcDJqQk5MTU4w?=
 =?utf-8?B?QjQxWW1CMi83SU40NGNsYVBrTitpeU9NTmowT3Qwb0JSc2ZiaWxZNUZIbVQw?=
 =?utf-8?B?NTgxbXhvem5sMGpUY3ZxUE5GaFVTbitLanBwaDZNLzJ0bzFwUWZ6cWp2TzRJ?=
 =?utf-8?B?WndZQmpNNnpSZVlhcjJsTjVFWVExMXdZalVTK0NpeGtOZmgrTFh0T3hSVksx?=
 =?utf-8?B?YjA1VSt5MHR4SHROK0lJNjdVS1YrUGdkTkFlVkM5a2hxbm10d0pSdENiUndF?=
 =?utf-8?B?R3pOR1U1Y1pRUDZpSnpYRDhxOS9YNks0eElHUklQNFlWQjdJSFQyUFRJVkFX?=
 =?utf-8?B?OU1yaVBNOWh1c1NhdTd1WEJWbUpkaGl4VEREWDdkSFQ3K21LM1NQQk1mWVpC?=
 =?utf-8?B?NTRTOUp5YnhHWWZwN3F4R2ZoTUNSWFQ4dFptd0J2U0JRRENhZkVyT3dzVmlJ?=
 =?utf-8?B?d2UrK3pqeEtvTDRDTE1LclJoU2Z4cHRveGlLUHFnemx4NkN3ZTBvelZOd0Ex?=
 =?utf-8?B?VWFsazlvRm1wcklUZEc4cW12eC81WFR0MDUvLzhkQlZUdXQ1ZGxLUWNoQXdo?=
 =?utf-8?B?SVp1LzVJWHQzY2RmR1ZBc0dDdEJhdk80U2dxajBiTkdDVWVpcVVIVnN6NjdE?=
 =?utf-8?B?M1A1eUxRdHBsSVc2NVgvY0ZwOUZ4NnlpTmpCT0I3anQ2Wmt4VkRlVVhVdjMv?=
 =?utf-8?B?NUhkNzlXb2IyWkFIZ1RyNlJQbjFQY2pJdTEzYUdpSUx2eU1KU2xTTFFTN0ta?=
 =?utf-8?B?VEdESEV5c0Zib2xMa25QRElZYS9CMld0U3dXMU9QTGFLcXR5L1F3UUk1OUI0?=
 =?utf-8?B?SW1mK1pPcXhHdkxQbHpmSE5WbWpvdzZBV2RxQ2s2VFRhMzJmQzdEZ2pPc1hV?=
 =?utf-8?B?OEZsbzY1MDUyMmhIazBvU0ZmdWJsRzl2NitzMXRQSWg4eTN2YmZtV1NBeEx5?=
 =?utf-8?B?OWJsQ1NidlBQVUg1Mi9GTmVLYnVueDlOTUg4ck9CZE1FblI3TThvTlVJbzQv?=
 =?utf-8?B?TVkzRkJkRHFLWjIyMzNsdm84UmVoRDF5T3h1Q1pZRERaTkxGWWVwbGNxeGEy?=
 =?utf-8?B?b0cvTHhmanhDQ09NSjc5REVHbmNWSEd4NUh5QjEvZW85QUZRVUthQTc2WDRu?=
 =?utf-8?B?Y0lRMDEva0ttQ3lBaW5sYVVqQTQ3ZHQ4VjUxZktlSUZHVWFoUXdYZkNNSW9w?=
 =?utf-8?B?S3NEOTVrNTFPNGpIUWFEOTNBN2J5QmhFV2RIajFmTThGLzcveWllRk81ZEdT?=
 =?utf-8?B?UlRNRlJVVFcvNm45T0N4cWJlbGJEQ2dUSnA5aDdIVk1SWitheXBZY0YwaDBS?=
 =?utf-8?B?dTE3WjJxV2owRTBlODFpSVhBaGRzMUxHOWxQNnoxeUlaWi9CcDNJaXROaFV4?=
 =?utf-8?B?dkZGS29haTF2R0R3RXl1OTliOVFQVnRoT2U0YS9xTG1RaWNNeDBLV3pybmNP?=
 =?utf-8?B?Z3pQMzQ3L25UaDZURXdIb1R3UlJqODJwc3NFNCsrSTZBTVRiL1ArbDJTbHdO?=
 =?utf-8?B?MGlIOEZjZVd5dFFrbHJ1eEh2TW9KQ1B6cTBhd01wUXJVei9xclR2elFnMzlm?=
 =?utf-8?B?eGJ6VFBPa1RIRG9uY1B4TzE1SVNZckxUZFlSYkJzQzluRVd2OS9HTWJNbldG?=
 =?utf-8?B?RTRwRmtGRSsyYWw2RXRUUE5FbVpabzlpRktGK2pxcGs2RnFtMS91bGZOd3pi?=
 =?utf-8?B?Y2NkNkdMeTlHWTdTKzlWdlpNK2ZjT1k3TzFnWmFoNnJXS3k1SEdkUkFaUTBh?=
 =?utf-8?B?M3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0308E77253E7C49903D941CD15F5AC8@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb18d658-5fd2-4e8b-a36a-08dd823db779
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2025 08:06:13.8921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /KhmzgwtnybmoTz5qbf9i1QEb6Y4NfodjX7EHHirZLGZznggmBhEF3GvQSPOYXBohDV/QqENF52EMT0UE/nYVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU2PPF6ED75D8C0

T24gRnJpLCAyMDI1LTA0LTExIGF0IDE3OjI5ICswODAwLCBIdWFuIFRhbmcgd3JvdGU6DQo+IA0K
PiBAQCAtODA2Nyw2ICs4MDgyLDkgQEAgc3RhdGljIHZvaWQgdWZzaGNkX3diX3Byb2JlKHN0cnVj
dCB1ZnNfaGJhDQo+ICpoYmEsIGNvbnN0IHU4ICpkZXNjX2J1ZikNCj4gwqAJICovDQo+IMKgCWRl
dl9pbmZvLT53Yl9idWZmZXJfdHlwZSA9DQo+IGRlc2NfYnVmW0RFVklDRV9ERVNDX1BBUkFNX1dC
X1RZUEVdOw0KPiDCoA0KPiArCWRldl9pbmZvLT5leHRfd2Jfc3VwID3CoCBnZXRfdW5hbGlnbmVk
X2JlMTYoZGVzY19idWYgKw0KPiArCQkJCQkJREVWSUNFX0RFU0NfUEFSQU1fRVgNCj4gVF9VRlNf
RkVBVFVSRV9TVVApOw0KPiArDQo+IA0KDQoNCkhpIEh1YW4sDQoNCkRFVklDRV9ERVNDX1BBUkFN
X0VYVF9VRlNfRkVBVFVSRV9TVVAgc2VlbXMgdG8gYmUgaW5jb3JyZWN0LiANCkl0IHNob3VsZCBi
ZSBERVZJQ0VfREVTQ19QQVJBTV9FWFRfV0JfU1VQDQoNClRoYW5rcy4NClBldGVyDQoNCg0KDQo+
IMKgCWRldl9pbmZvLT5iX3ByZXNydl91c3BjX2VuID0NCj4gwqAJCWRlc2NfYnVmW0RFVklDRV9E
RVNDX1BBUkFNX1dCX1BSRVNSVl9VU1JTUENfRU5dOw0KPiDCoA0KPiBkaWZmIC0tZ2l0IGEvaW5j
bHVkZS91ZnMvdWZzLmggYi9pbmNsdWRlL3Vmcy91ZnMuaA0KPiBpbmRleCA4YTI0ZWQ1OWVjNDYu
LjNmMmIxNzcyZjlmZCAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS91ZnMvdWZzLmgNCj4gKysrIGIv
aW5jbHVkZS91ZnMvdWZzLmgNCj4gQEAgLTE4MCw3ICsxODAsMTAgQEAgZW51bSBhdHRyX2lkbiB7
DQo+IMKgCVFVRVJZX0FUVFJfSUROX0FWQUlMX1dCX0JVRkZfU0laRcKgwqDCoMKgwqDCoCA9IDB4
MUQsDQo+IMKgCVFVRVJZX0FUVFJfSUROX1dCX0JVRkZfTElGRV9USU1FX0VTVMKgwqDCoCA9IDB4
MUUsDQo+IMKgCVFVRVJZX0FUVFJfSUROX0NVUlJfV0JfQlVGRl9TSVpFwqDCoMKgwqDCoMKgwqAg
PSAweDFGLA0KPiAtCVFVRVJZX0FUVFJfSUROX1RJTUVTVEFNUAkJPSAweDMwDQo+ICsJUVVFUllf
QVRUUl9JRE5fVElNRVNUQU1QCQk9IDB4MzAsDQo+ICsJUVVFUllfQVRUUl9JRE5fV0JfQlVGX1JF
U0laRV9ISU5UCT0gMHgzQywNCj4gKwlRVUVSWV9BVFRSX0lETl9XQl9CVUZfUkVTSVpFX0VOCQk9
IDB4M0QsDQo+ICsJUVVFUllfQVRUUl9JRE5fV0JfQlVGX1JFU0laRV9TVEFUVVMJPSAweDNFLA0K
PiDCoH07DQo+IMKgDQo+IMKgLyogRGVzY3JpcHRvciBpZG4gZm9yIFF1ZXJ5IHJlcXVlc3RzICov
DQo+IEBAIC0yODksNiArMjkyLDcgQEAgZW51bSBkZXZpY2VfZGVzY19wYXJhbSB7DQo+IMKgCURF
VklDRV9ERVNDX1BBUkFNX1BSRENUX1JFVgkJPSAweDJBLA0KPiDCoAlERVZJQ0VfREVTQ19QQVJB
TV9IUEJfVkVSCQk9IDB4NDAsDQo+IMKgCURFVklDRV9ERVNDX1BBUkFNX0hQQl9DT05UUk9MCQk9
IDB4NDIsDQo+ICsJREVWSUNFX0RFU0NfUEFSQU1fRVhUX1dCX1NVUAkJPSAweDRELA0KPiDCoAlE
RVZJQ0VfREVTQ19QQVJBTV9FWFRfVUZTX0ZFQVRVUkVfU1VQCT0gMHg0RiwNCj4gwqAJREVWSUNF
X0RFU0NfUEFSQU1fV0JfUFJFU1JWX1VTUlNQQ19FTgk9IDB4NTMsDQo+IMKgCURFVklDRV9ERVND
X1BBUkFNX1dCX1RZUEUJCT0gMHg1NCwNCj4gQEAgLTM4Myw2ICszODcsMTEgQEAgZW51bSB7DQo+
IMKgCVVGU0hDRF9BTVAJCT0gMywNCj4gwqB9Ow0KPiDCoA0KPiArLyogUG9zc2libGUgdmFsdWVz
IGZvciB3RXh0ZW5kZWRXcml0ZUJvb3N0ZXJTdXBwb3J0ICovDQo+ICtlbnVtIHsNCj4gKwlVRlNf
REVWX1dCX0JVRl9SRVNJWkUJPSBCSVQoMCksDQo+ICt9Ow0KPiArDQo+IMKgLyogUG9zc2libGUg
dmFsdWVzIGZvciBkRXh0ZW5kZWRVRlNGZWF0dXJlc1N1cHBvcnQgKi8NCj4gwqBlbnVtIHsNCj4g
wqAJVUZTX0RFVl9ISUdIX1RFTVBfTk9USUYJCT0gQklUKDQpLA0KPiBAQCAtNDU0LDYgKzQ2Mywy
OCBAQCBlbnVtIHVmc19yZWZfY2xrX2ZyZXEgew0KPiDCoAlSRUZfQ0xLX0ZSRVFfSU5WQUwJPSAt
MSwNCj4gwqB9Ow0KPiDCoA0KPiArLyogYldyaXRlQm9vc3RlckJ1ZmZlclJlc2l6ZUVuIGF0dHJp
YnV0ZSAqLw0KPiArZW51bSB3Yl9yZXNpemVfZW4gew0KPiArCVdCX1JFU0laRV9FTl9JRExFCT0g
MCwNCj4gKwlXQl9SRVNJWkVfRU5fREVDUkVBU0UJPSAxLA0KPiArCVdCX1JFU0laRV9FTl9JTkNS
RUFTRQk9IDIsDQo+ICt9Ow0KPiArDQo+ICsvKiBiV3JpdGVCb29zdGVyQnVmZmVyUmVzaXplSGlu
dCBhdHRyaWJ1dGUgKi8NCj4gK2VudW0gd2JfcmVzaXplX2hpbnQgew0KPiArCVdCX1JFU0laRV9I
SU5UX0tFRVAJPSAwLA0KPiArCVdCX1JFU0laRV9ISU5UX0RFQ1JFQVNFCT0gMSwNCj4gKwlXQl9S
RVNJWkVfSElOVF9JTkNSRUFTRQk9IDIsDQo+ICt9Ow0KPiArDQo+ICsvKiBiV3JpdGVCb29zdGVy
QnVmZmVyUmVzaXplU3RhdHVzIGF0dHJpYnV0ZSAqLw0KPiArZW51bSB3Yl9yZXNpemVfc3RhdHVz
IHsNCj4gKwlXQl9SRVNJWkVfU1RBVFVTX0lETEUJPSAwLA0KPiArCVdCX1JFU0laRV9TVEFUVVNf
SU5fUFJPR1JFU1MJPSAxLA0KPiArCVdCX1JFU0laRV9TVEFUVVNfQ09NUExFVEVfU1VDQ0VTUwk9
IDIsDQo+ICsJV0JfUkVTSVpFX1NUQVRVU19HRU5FUkFMX0ZBSUxVUkUJPSAzLA0KPiArfTsNCj4g
Kw0KPiDCoC8qIFF1ZXJ5IHJlc3BvbnNlIHJlc3VsdCBjb2RlICovDQo+IMKgZW51bSB7DQo+IMKg
CVFVRVJZX1JFU1VMVF9TVUNDRVNTwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgPSAweDAwLA0KPiBAQCAtNTc4LDYgKzYwOSw3IEBAIHN0cnVjdCB1ZnNfZGV2X2luZm8gew0K
PiDCoAlib29swqDCoMKgIHdiX2J1Zl9mbHVzaF9lbmFibGVkOw0KPiDCoAl1OAl3Yl9kZWRpY2F0
ZWRfbHU7DQo+IMKgCXU4wqDCoMKgwqDCoCB3Yl9idWZmZXJfdHlwZTsNCj4gKwl1MTYJZXh0X3di
X3N1cDsNCj4gwqANCj4gwqAJYm9vbAliX3JwbV9kZXZfZmx1c2hfY2FwYWJsZTsNCj4gwqAJdTgJ
Yl9wcmVzcnZfdXNwY19lbjsNCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWZzL3Vmc2hjZC5oIGIv
aW5jbHVkZS91ZnMvdWZzaGNkLmgNCj4gaW5kZXggZjU2MDUwY2U5NDQ1Li43MjIzMDcxODI2MzAg
MTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvdWZzL3Vmc2hjZC5oDQo+ICsrKyBiL2luY2x1ZGUvdWZz
L3Vmc2hjZC5oDQo+IEBAIC0xNDcxLDYgKzE0NzEsNyBAQCBpbnQgdWZzaGNkX2FkdmFuY2VkX3Jw
bWJfcmVxX2hhbmRsZXIoc3RydWN0DQo+IHVmc19oYmEgKmhiYSwgc3RydWN0IHV0cF91cGl1X3Jl
cSAqcg0KPiDCoAkJCQnCoMKgwqDCoCBzdHJ1Y3Qgc2NhdHRlcmxpc3QgKnNnX2xpc3QsDQo+IGVu
dW0gZG1hX2RhdGFfZGlyZWN0aW9uIGRpcik7DQo+IMKgaW50IHVmc2hjZF93Yl90b2dnbGUoc3Ry
dWN0IHVmc19oYmEgKmhiYSwgYm9vbCBlbmFibGUpOw0KPiDCoGludCB1ZnNoY2Rfd2JfdG9nZ2xl
X2J1Zl9mbHVzaChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBib29sIGVuYWJsZSk7DQo+ICtpbnQgdWZz
aGNkX3diX3NldF9yZXNpemVfZW4oc3RydWN0IHVmc19oYmEgKmhiYSwgZW51bSB3Yl9yZXNpemVf
ZW4NCj4gZW5fbW9kZSk7DQo+IMKgaW50IHVmc2hjZF9zdXNwZW5kX3ByZXBhcmUoc3RydWN0IGRl
dmljZSAqZGV2KTsNCj4gwqBpbnQgX191ZnNoY2Rfc3VzcGVuZF9wcmVwYXJlKHN0cnVjdCBkZXZp
Y2UgKmRldiwgYm9vbA0KPiBycG1fb2tfZm9yX3NwbSk7DQo+IMKgdm9pZCB1ZnNoY2RfcmVzdW1l
X2NvbXBsZXRlKHN0cnVjdCBkZXZpY2UgKmRldik7DQoNCg==
