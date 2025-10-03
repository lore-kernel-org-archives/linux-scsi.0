Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3A3288522
	for <linux-scsi@vger.kernel.org>; Fri,  3 Oct 2025 09:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759485518; cv=fail; b=lX0NQVfGo4GXnwVKa+lR0FvUNVX/D7nmCxri4FqEWe3JbKt3jiLdkEZZA2SQKtpwBorWUHWBhxepH0TX+zgjtvMsujzJiDzf+PuHa3lvBIg9xRoGL7P0cnGDexcDmrE93LSXn7TmkVwhilK8VHFmK3BV2O3XFAWYAg7h0dq5wtk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759485518; c=relaxed/simple;
	bh=7pQ6o8Y/LefQl7PFyJ8gWjozqPW9gsr/nC8y7cY66qY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rthfKVqsjqoxNL7EP9PqnoxtQEZ8LIpzRkkXumIEbwwwIrAz6w+WIaiKCqItoCIyDfSfuDFeWEEy7q7aW/IVoucvnpLcdpLCCv8d0pIe4Wt4mXHEAdtU647W/iZZbibRv/72zA1jTGStbv1pPMTy7lhgafzTPiKY5aaXOkbDSiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZBi7UAMF; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=P5M2ZdRZ; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZBi7UAMF";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="P5M2ZdRZ"
X-UUID: 80e5d97aa03f11f08d9e1119e76e3a28-20251003
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=7pQ6o8Y/LefQl7PFyJ8gWjozqPW9gsr/nC8y7cY66qY=;
	b=ZBi7UAMFHfkCgeAZvFLNFTCknKUgeYWiqojrKWKg2vVFzJE3GjcD9rU6lC4uswmDRdrpUYggvJ0Rxt8JHJwgOuMpQPsJm9qDohrYx+Q4Ztoy9wiy5pUBkuDiUlt/Tj469Q78I758zuLYSahDK5GvR7UcZCIc6LgNg32dCInGXMs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:104bad68-86bc-4ff2-bcfe-a8dbe872f680,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:aef01c22-c299-443d-bb51-d77d2f000e20,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|888|898,
	TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 80e5d97aa03f11f08d9e1119e76e3a28-20251003
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1166084076; Fri, 03 Oct 2025 17:58:25 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 3 Oct 2025 17:58:23 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Fri, 3 Oct 2025 17:58:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g53HsNrIgx6D/s8HkMQ6ZLlKhcUNT2TiIAX2SrqgihC6csVtRjCc5wb1kJQR3zX2qhaba0VbGPt3jRInFY2jU+0duAMtpROMQ9NBY/YbXkTG/21MgyPFIGAguRp1q7PmOHBC94wETdFPbvSDr8WlGgbQYB1Y5xytk95m574qUzVkZzyBF+CX9FHCDy2r0lmPXOdzzWV32ZfEDkfVrpdysxiDRNtwITdmN8ScDdGqanzWJJSXz62UyRwP+znhUudVGmmOoiBRjeqAB0up6P+4xX7xhz09++ho843UtgtttEZqd+cQyDVYxap+kHbFGKMg1yGPHtd+QH4fw4dDsL7I2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pQ6o8Y/LefQl7PFyJ8gWjozqPW9gsr/nC8y7cY66qY=;
 b=jKmyyNug5vLcUTAraVSuCiqkRZeLOj+FKgj7yui2oJxJgu711sVvgYFnrH9wlCMMuIqOAFrLYH4Rt2D5rzbmiW1TSLfjp2x/k59EM+BkfFZx7CbIOrFglgP+qqsWSXLO0TWKHXmIOI28WTlyQGBG1CbFELZyBq8Ht30vMDTvzuTWc6woUWSHzzz7HCWq91XbkKnJZeInYcv5gQhYSuBJXguyjYVZL47V7IeURxQiptwIaVcNnxT6Opn9sFry0S7CLV+RJ3AlMkqn4Xe2eCohL/KzVnI0ET/cZLm4px2D/MDNmrWa0lzj1ZOpIuEF6cD7pTT3gGeD3NKs3dRAUuwozg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pQ6o8Y/LefQl7PFyJ8gWjozqPW9gsr/nC8y7cY66qY=;
 b=P5M2ZdRZ6kAfZa1wg+6vVKiNucIUxWttxR4SJe8APchS6I3nTnUsfA9SyCjZv4bJGoZlPvF/A5rfRexgY5vpv42MYHvDvpQP8q4r+vg2hL0Caih2VRhJyzUVGQ1Z162MPLJSxeehQLDhWT5TsWrw3nRifWC7X4Dic2OZDQoT6QU=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TY0PR03MB8176.apcprd03.prod.outlook.com (2603:1096:405:d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Fri, 3 Oct
 2025 09:58:19 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%6]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 09:58:19 +0000
From: =?big5?B?UGV0ZXIgV2FuZyAopP2rSKTNKQ==?= <peter.wang@mediatek.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [bug report] scsi: ufs: core: Fix runtime suspend error deadlock
Thread-Topic: [bug report] scsi: ufs: core: Fix runtime suspend error deadlock
Thread-Index: AQHcNEhrcWgn0Sls3U2AwJDuXIwdULSwL8NQ
Date: Fri, 3 Oct 2025 09:58:19 +0000
Message-ID: <PSAPR03MB5605A05A192039EA74288B83ECE4A@PSAPR03MB5605.apcprd03.prod.outlook.com>
References: <aN-XrK70ORfuWfEG@stanley.mountain>
In-Reply-To: <aN-XrK70ORfuWfEG@stanley.mountain>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-dg-rorf: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TY0PR03MB8176:EE_
x-ms-office365-filtering-correlation-id: 393e999a-887b-47ff-4a32-08de02636196
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?big5?B?ZC9oRmJMdnVrT3d0cHF3RjllNXI2UFh6Y1Y2NHBHbmc5YjZrWElWeCtxdnU4bGFG?=
 =?big5?B?ak9jalhTTzh3TmszNm9oenZENTlIcXFBclhkZk9sVFhVSkdNT2EvQmlkT3lkcGJ4?=
 =?big5?B?OW9XM0c0TFBYeS9iSm96dVhSZlJmMm1CMGRWZnVTQkM3eitmZi9ZK2IzalV5ZVMz?=
 =?big5?B?cXkzWUpYcmpWNlVhVy9nWTNDdyt0WC9KdlMzT2ROVEQrazVKdmpITDh0cGg2bFlz?=
 =?big5?B?VzdrRkljU0NkZkl4NWlrN1ViSW0yZUR4Y21LWkVEOTBjdnFRcng4RitKa3pLWTFw?=
 =?big5?B?SWhHL0lCYTBRbm5TMkJZMlNqeG5lNGJkcWgvUjNJSE5lNDZCcmtzWjN6ZGhkQ0d4?=
 =?big5?B?K0VzelpHUUZiUzFQdlVuUGFNVHJLa2ZrQzlJbzlCSzFmUHlJL2lHaEpoQURveWl4?=
 =?big5?B?eEgwUi84Z0xGaFpib3pMd25xRWFuYjFJYWVnRlp5cGNCUktIUCtJRkZxZGNrZWVI?=
 =?big5?B?MEc1UzhtYnhGS0xEUE44dVgzVms0M1BHb1ptTU03c0pvbFE1WG80QVE3Q1lnemZo?=
 =?big5?B?UnJPdmdPWGFmRStKb2Zpd0ozMFdEQ0Fqa2hiNzdpSEpKbDU0R0h0aU1uTi8ydkVT?=
 =?big5?B?NWt3ZXJGL1U4YzRQY3I4dE1vaHV2SkQ5T1RLenZHV1J2WlV4VDlJSHZYak1tenl1?=
 =?big5?B?eHE1K3FRQzJxbEU0dlF4amRNaUpZa1M1RVhoTHZia1JnYlNDS2YyRmw2WW00eDAr?=
 =?big5?B?NlFUdGhWWlk3TVA4M0F6V1ZGUEp4OER4R2k2b0JwR0pmVCt5MjBmM2NwZjNYdWdq?=
 =?big5?B?anVRc1JWVDh6a29PQ2V2eTZmdFRRcFJpaTFVemV1ZTBvVjdVWEtiMlJVSE1qMUw2?=
 =?big5?B?VHF0MTAwU1JrQzR5bzFEeUVwNVZMQmsvRnNUc3dLQVpJZnZZS2UwOEtLbW1XbTlN?=
 =?big5?B?eWJQR3gzb3d4SE1CK1lrZHVQVDlBYnpuZUhIT3JNUU0zSlNtSWpqV1phc0lNb2VM?=
 =?big5?B?TGpjcEZGTVJuMm8rVnFKOERzMFErVTFhS0RlTWcrUXRyUjVvR3Nlb3duc0J3WWp5?=
 =?big5?B?ck9Gajc5Wk9rTmhsdW5JOWN2S1JpSTNQbkFCZWptSHpNS1ZBNEVjUGorN2s0dS91?=
 =?big5?B?NVhKYXMrczdvMWdDNG9Rc2hUbVpmNmU4MGl1czU2RW9WMk8wT0NOQ2I5SDdZQVpa?=
 =?big5?B?dzllaWpJcGYvRmtObnpYdUE5allnbWhTNEFnaXkya051ZEl3MVNJeGpyQ0xEbklC?=
 =?big5?B?emRLMEEvZFdtY2paZVgwNzlLWlJNYmxYWXMyTkdoVHpzeEdmOUU1Y3JFUk02U2d2?=
 =?big5?B?d3JUWERSd1g2bTRpTUdDV3lYRmJDZ3FLeTI2cUVDWDdycjlVOGcxR210djZLRUlV?=
 =?big5?B?M21YZHFmZXd2K2ZDSk9IdnNaK3hvdWYvako2VkdTRlVNNDA2T0RheGErODlWa2Jx?=
 =?big5?B?Y21YV1BXNkNzWThJK0dvcFNSKzlUS2d3NUNNUFcxMXhuaW5uWTFoRHRabEcrbi93?=
 =?big5?B?L0JqRWFwSVMyT1VFbWlTdmxRRTdUSHB2dVhsSDBmVE9CeGxsRFprZjM2QVNTZTB2?=
 =?big5?B?cGt6bkF2MXlHbTRRam5QUUN2YmVkZ2I1ZWlYcEJ2Vnk5ZEJxVEQwYlFRTHJiTk1X?=
 =?big5?B?dzZ6djBBemE2OUlmNWx6c0hscCtNWDhIUmxtQU5RY3VEVFVVRUJEU0xzRG1hYWcx?=
 =?big5?B?ODNkY1pDRVJmZkphcmJCdjdWcEJBMlpLcDJDU1dYbHhuZ1pFSmp5cVpkRkRyNkc2?=
 =?big5?B?TU9VZUN1ZG1iVEtoZXFHRzNXd1NVMW5kREpRdHRiT1lyMmpuWnkyMWNLQzIvQ0dk?=
 =?big5?B?dHhoZkpqeWJyaVJFbXh3WGVSQ1lMMnRidXAwVDNLeTcxaWRlb2JTdW1kZFNoYUQy?=
 =?big5?B?SGJGWTAxV2tXSGdPOE9nRFRIRklkLzh0d2R3N3N0aER2WURCaVBFKzZRbW5aUUlR?=
 =?big5?Q?Vf7yoVSoyfJO9IsXn6swn144zKpRHZarPCBb7LlikSa2nBK/?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:zh-tw;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?big5?B?V2liUEdtRmZ6ME1nT0FoM1ZOMUxFc3lVTnhJaWduTm9CdHludU85cWVZUUZsaGV1?=
 =?big5?B?WEdFODh1bnJ1Z0w4dS80NmtKSXQxMFdsUk9VNURGUjRiNndqb2lEdTkxMmkyUy9X?=
 =?big5?B?bm9OYitWTzNtUWpZSGtlamo2SWFoQjdjSHBVMnc4QWtxQjVFRzRtQmsrZkoxZHRr?=
 =?big5?B?VlJEWitTajJwZi9XSXdPV2hCbWNBUWE0V2ZZTEZ6RHltTGwyTTV0ZlU2eDl4aTNH?=
 =?big5?B?Tmc4cU1jSTZZQm11MjVzMzN4MUIraWRmOTRXNlJveStrNnBXZXUvN0ZHaElKUGt5?=
 =?big5?B?WWtlMnJOb1dpNTZXWWlCU1J2Z3gyc1o5bVBrM015WXRwNXQ2WlpjQm5PVFZzSy9i?=
 =?big5?B?ZDV3ZEJkaUZtb0FkcHN2NVhRL3JRMjNaT1lwdHdZYjJIS3huY0d0SWMzUFZCS1BO?=
 =?big5?B?TnFBTk9PcEMvWVBQTlBYcFpJdXBJSEZ1K1FJcE00WVRiMFRRVUR5aXRkUzBORUVC?=
 =?big5?B?aVdBcFFaZU9LdlVESURJcEtnUGhzODdjaXFQaGdzdVE5ZlYrMnFEUzIzbXlDNkti?=
 =?big5?B?aU5tQ01VMlZiMTRlaFVQOFBBM3lIMkR2MTAyZFY3SERmSmo0bXFzNkN1OGlKaTNS?=
 =?big5?B?NzZXeVpQbkVBOHl6ME40RFR2S1JxMmFiUC84SVMvYjdVYU1BVzMzQ05WUXZiZlZ6?=
 =?big5?B?amFqU0hvbHcvZ1h1Sm83RmxjZStGdVRjZ0Q5YVk1Vnpja2p6T3YrYzg4Yjg2cWRn?=
 =?big5?B?cStENDVuaVNZQWhTTFpqWVVpZlRDZzBiSzBnWEY4dXR0RjVxZUFHMmN4QVpsbmc1?=
 =?big5?B?RGZoQnBZT0RHUHkvb3VQenNQb1gvUUJOQTYyeDIwK2xMczNhWmVWU3RneVY4bW1w?=
 =?big5?B?dGtnNnlBRC9jdDR2aHZPMm10TTY0MlRLTlF2QkNCcnp3SHZLMWxHY1J1REh0cXRq?=
 =?big5?B?T2tReGNtdmM1NDlBcWxRN3MrQTdCNXg3T1NQSkRwd1YyOGpBTGhzN0FmOHcvMUFI?=
 =?big5?B?UERKdWFZbnl4TmZtQmFzd3N4MVJITURva1Q2cWh5SzdZTFhkd0JNTWs1Tlc4ZWpP?=
 =?big5?B?VGI0YnZkbFBYWTBGaDMweFBLNFJVNUhqSzJ2T3RHbTRhUm1pOXAxejVKalJ3SjY2?=
 =?big5?B?cUFONEowYjVPSllOYUxYaUtRdDBURWhSTm5iOEdDdklNeTE0Y1dibHZIckZ0T0Jr?=
 =?big5?B?NmRUaXAySFlWZXBpSXRsTkY3aVU2VUNtbmcxUXVhallseHAzcmZLc2kxVmZWNnlC?=
 =?big5?B?Y1M4djU3R3JOQW5oOE5VVmFLUEI0ZmhxY1Z6SzU4Y05teFRiOFlzcGNkeHRzSmgw?=
 =?big5?B?LytYYzVKYzF3TVJsb2hFV0R2ZGMwVmtPTkF1UnlmM1RxaUJWVjV0SVQ5VkNwZ1Zq?=
 =?big5?B?SGlDRmRZSzh0NENpZ3p2aW1yZVNTRmttbW96cEJOMEM5cTFXL0ZTdE14UW4rQU5x?=
 =?big5?B?WWR6WkljQWtpRFo3aTNpa2lZMVdWZHp0QWlPVVB0NnFhK0gyYTRxUU1HZVV2UVlp?=
 =?big5?B?L3RUVDU0NWVvMnpMb0xjRndnMXVML1RvVFpHSkRyYlloMjlPZ3JoSVVFSC83MTU2?=
 =?big5?B?cXFqQkRta1pMaWNZckFpMGV2c05vNHNHdEhZZTQyRUVlR3R2aGhkV2tSWHA5TVBu?=
 =?big5?B?N0ozemd6WjMzTitUbTFySExCaURrNlVzM3Badjg0ajRwRmV6N25UUzlVKzBCREtI?=
 =?big5?B?a0RxZ0MvRVIvU2pRYzArYU8rUTZqeCtSYmZ2Yi9XSjNydGRDTlhlVktYRlZyak0z?=
 =?big5?B?QXd2ZkhzamVMTlNia3NGVDBLY3NUQTBLSWdSNnVIQ0F0ZVRhcjlOUnpDOTQ0QTJG?=
 =?big5?B?UzdCb0hqdU5qY2ZCSmxQK2U0N2ZpeGpFaElha0EvWS8xajY0SXZIN1lIZHI2Q3Bz?=
 =?big5?B?R3RidE5reHZGZTRVZmh1L0piN0kxeER6WitLZTRKL1RrWWNHWnpRSGlPbWJpZTha?=
 =?big5?B?UndHNUYrZ3J6NWZhVSt2NVphQ0FGUW5jRTZvKy8xdVEzZmNPSjZXZy85M1oyK1hq?=
 =?big5?B?dGFSTHNqUzRWTDM2bWhqY0V3Uzg2ekRmVEFNV3lPSXI1dUUvdGIyU0JWQ0gwUFlm?=
 =?big5?Q?Fyx+oEu2p+FsjV4b?=
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 393e999a-887b-47ff-4a32-08de02636196
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2025 09:58:19.4848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9+Bih2s/vjX6FlVayyhc9vOO17p57e5YxgUMTIVklA/WTY4MYphiG4xq3iJT32/Gx3KwNa4u56K1DYTwhK9Vpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB8176

SGkgRGFuLA0KDQpUaGFua3MgZm9yIHJlcG9ydC4NCldpbGwgZml4IGl0IEFTQVAuDQoNClRoYW5r
cy4NClBldGVyDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBEYW4gQ2FycGVu
dGVyIDxkYW4uY2FycGVudGVyQGxpbmFyby5vcmc+IA0KU2VudDogRnJpZGF5LCBPY3RvYmVyIDMs
IDIwMjUgNTozMCBQTQ0KVG86IFBldGVyIFdhbmcgKKT9q0ikzSkgPHBldGVyLndhbmdAbWVkaWF0
ZWsuY29tPg0KQ2M6IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnDQpTdWJqZWN0OiBbYnVnIHJl
cG9ydF0gc2NzaTogdWZzOiBjb3JlOiBGaXggcnVudGltZSBzdXNwZW5kIGVycm9yIGRlYWRsb2Nr
DQoNCg0KRXh0ZXJuYWwgZW1haWwgOiBQbGVhc2UgZG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW50aWwgeW91IGhhdmUgdmVyaWZpZWQgdGhlIHNlbmRlciBvciB0aGUgY29u
dGVudC4NCg0KDQpIZWxsbyBQZXRlciBXYW5nLA0KDQpDb21taXQgZjk2NmUwMmFlNTIxICgic2Nz
aTogdWZzOiBjb3JlOiBGaXggcnVudGltZSBzdXNwZW5kIGVycm9yDQpkZWFkbG9jayIpIGZyb20g
U2VwIDI2LCAyMDI1IChsaW51eC1uZXh0KSwgbGVhZHMgdG8gdGhlIGZvbGxvd2luZyBTbWF0Y2gg
c3RhdGljIGNoZWNrZXIgd2FybmluZzoNCg0KICBkcml2ZXJzL3Vmcy9jb3JlL3Vmc2hjZC5jOjY4
NDQgdWZzaGNkX2Vycl9oYW5kbGVyKCkNCiAgd2FybjogaW5jb25zaXN0ZW50IHJldHVybnMgJyZo
YmEtPmhvc3Rfc2VtJy4NCiAgICBMb2NrZWQgb24gIDogNjY5MQ0KICAgIFVubG9ja2VkIG9uOiA2
NjgzLDY4NDQNCg0KZHJpdmVycy91ZnMvY29yZS91ZnNoY2QuYw0KICAgIDY2NTggc3RhdGljIHZv
aWQgdWZzaGNkX2Vycl9oYW5kbGVyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAgICA2NjU5
IHsNCiAgICA2NjYwICAgICAgICAgaW50IHJldHJpZXMgPSBNQVhfRVJSX0hBTkRMRVJfUkVUUklF
UzsNCiAgICA2NjYxICAgICAgICAgc3RydWN0IHVmc19oYmEgKmhiYTsNCiAgICA2NjYyICAgICAg
ICAgdW5zaWduZWQgbG9uZyBmbGFnczsNCiAgICA2NjYzICAgICAgICAgYm9vbCBuZWVkc19yZXN0
b3JlOw0KICAgIDY2NjQgICAgICAgICBib29sIG5lZWRzX3Jlc2V0Ow0KICAgIDY2NjUgICAgICAg
ICBpbnQgcG1jX2VycjsNCiAgICA2NjY2DQogICAgNjY2NyAgICAgICAgIGhiYSA9IGNvbnRhaW5l
cl9vZih3b3JrLCBzdHJ1Y3QgdWZzX2hiYSwgZWhfd29yayk7DQogICAgNjY2OA0KICAgIDY2Njkg
ICAgICAgICBkZXZfaW5mbyhoYmEtPmRldiwNCiAgICA2NjcwICAgICAgICAgICAgICAgICAgIiVz
IHN0YXJ0ZWQ7IEhCQSBzdGF0ZSAlczsgcG93ZXJlZCAlZDsgc2h1dHRpbmcgZG93biAlZDsgc2F2
ZWRfZXJyID0gMHgleDsgc2F2ZWRfdWljX2VyciA9IDB4JXg7IGZvcmNlX3Jlc2V0ID0gJWQlc1xu
IiwNCiAgICA2NjcxICAgICAgICAgICAgICAgICAgX19mdW5jX18sIHVmc2hjZF9zdGF0ZV9uYW1l
W2hiYS0+dWZzaGNkX3N0YXRlXSwNCiAgICA2NjcyICAgICAgICAgICAgICAgICAgaGJhLT5pc19w
b3dlcmVkLCBoYmEtPnNodXR0aW5nX2Rvd24sIGhiYS0+c2F2ZWRfZXJyLA0KICAgIDY2NzMgICAg
ICAgICAgICAgICAgICBoYmEtPnNhdmVkX3VpY19lcnIsIGhiYS0+Zm9yY2VfcmVzZXQsDQogICAg
NjY3NCAgICAgICAgICAgICAgICAgIHVmc2hjZF9pc19saW5rX2Jyb2tlbihoYmEpID8gIjsgbGlu
ayBpcyBicm9rZW4iIDogIiIpOw0KICAgIDY2NzUNCiAgICA2Njc2ICAgICAgICAgZG93bigmaGJh
LT5ob3N0X3NlbSk7DQogICAgICAgICAgICAgICAgIF5eXl5eXl5eXl5eXl5eXl5eXl5eDQpXZSdy
ZSBob2xkaW5nIHRoaXMgc2VtYXBob3JlLg0KDQogICAgNjY3NyAgICAgICAgIHNwaW5fbG9ja19p
cnFzYXZlKGhiYS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7DQogICAgNjY3OCAgICAgICAgIGlm
ICh1ZnNoY2RfZXJyX2hhbmRsaW5nX3Nob3VsZF9zdG9wKGhiYSkpIHsNCiAgICA2Njc5ICAgICAg
ICAgICAgICAgICBpZiAoaGJhLT51ZnNoY2Rfc3RhdGUgIT0gVUZTSENEX1NUQVRFX0VSUk9SKQ0K
ICAgIDY2ODAgICAgICAgICAgICAgICAgICAgICAgICAgaGJhLT51ZnNoY2Rfc3RhdGUgPSBVRlNI
Q0RfU1RBVEVfT1BFUkFUSU9OQUw7DQogICAgNjY4MSAgICAgICAgICAgICAgICAgc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOw0KICAgIDY2ODIgICAg
ICAgICAgICAgICAgIHVwKCZoYmEtPmhvc3Rfc2VtKTsNCg0KUmVsZWFzZWQuDQoNCiAgICA2Njgz
ICAgICAgICAgICAgICAgICByZXR1cm47DQogICAgNjY4NCAgICAgICAgIH0NCiAgICA2Njg1ICAg
ICAgICAgc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShoYmEtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3Mp
Ow0KICAgIDY2ODYNCiAgICA2Njg3ICAgICAgICAgdWZzaGNkX3JwbV9nZXRfbm9yZXN1bWUoaGJh
KTsNCiAgICA2Njg4ICAgICAgICAgaWYgKGhiYS0+cG1fb3BfaW5fcHJvZ3Jlc3MpIHsNCiAgICA2
Njg5ICAgICAgICAgICAgICAgICB1ZnNoY2RfbGlua19yZWNvdmVyeShoYmEpOw0KICAgIDY2OTAg
ICAgICAgICAgICAgICAgIHVmc2hjZF9ycG1fcHV0KGhiYSk7DQogICAgNjY5MSAgICAgICAgICAg
ICAgICAgcmV0dXJuOw0KDQpUaGUgcGF0Y2ggaW50cm9kdWNlcyBhIG5ldyByZXR1cm4gYnV0IGRv
ZXNuJ3QgcmVsZWFzZSB0aGUgaGJhLT5ob3N0X3NlbS4NClRoZSBwYXRjaCB3YXMgc3VwcG9zZWQg
dG8gZml4IGEgZGVhZGxvY2sgYnV0IEkgd291bGQgaGF2ZSB0aG91Z2h0IGl0IHdvdWxkIGludHJv
ZHVjZSBhIG5ldyBkZWFkbG9jay4uLg0KDQogICAgNjY5MiAgICAgICAgIH0NCiAgICA2NjkzICAg
ICAgICAgdWZzaGNkX3JwbV9wdXQoaGJhKTsNCiAgICA2Njk0DQoNCnJlZ2FyZHMsDQpkYW4gY2Fy
cGVudGVyDQo=
