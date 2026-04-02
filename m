Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFD7306B11
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 07:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=210.61.82.184
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775114457; cv=fail; b=i14KzE+m+lHI+reW7ateXJY5yDqmvfeX5UD5ZWdEkVRzT5JU49BS5Ml7ROIoHMKiJwNbypwufbEo0Z1tqOx4YwZuVFHsmNoCQMpFZZMJ2XaykQh6q8TuFfqePYakqL+E1fdZj2RGco3Hf3zLnK40TIMxXxSmiUq6sXpAfnhBPI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775114457; c=relaxed/simple;
	bh=aLEm7fXBjxb2gaYurce/M6MGWGsjjigNakM4W4aNp64=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CXw1U/b6G2k1LOfYk4RvNnsde8KaIHn6K/Q5Hr+5jFVFoIcKdCfMKNUNo7thwW6BaK5cVpZkDAxUQCoLUaxy0qrjZqnbyq4aUBmLM/UneFNwBuVHiBAJIycmfc4dyvvEVg156aVMXYESfFJqzIiZAOmIKbtAK2fqSiWyYFHiuBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=mriz3oyU; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=jMxbmCzR; arc=fail smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="mriz3oyU";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="jMxbmCzR"
X-UUID: 7a2a93ce2e6411f19a16598d5ca7f8ec-20260402
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=aLEm7fXBjxb2gaYurce/M6MGWGsjjigNakM4W4aNp64=;
	b=mriz3oyUX1TjfrE9HTB7hzqYNvjN2tfxo7ANmLhldguN1lc1crE+vsD2S3nGTXUPG/Efd4TLPMW2sao4TldvlIs3aNOA35vwtIsbENXc7icjExHtMFWALi8t2BGzlIqsCY7iCVxa+YUqwEBQrb9liydJ8P/s6x0opAyz3zNCOdM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:2c5be808-cf18-4b3b-9702-26a344a43c87,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:a4166cd5-060f-4ecc-9ee0-121eeeb4a682,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|110|111|836|865|888|
	898,TC:-5,Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:ni
	l,BEC:-1,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7a2a93ce2e6411f19a16598d5ca7f8ec-20260402
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 865644495; Thu, 02 Apr 2026 15:20:50 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 2 Apr 2026 15:20:49 +0800
Received: from SI4PR04CU002.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 2 Apr 2026 15:20:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xUJ1o5xQ55tZb0agyQzsHuQdVFOpjOPEQhpo4ysQyaoC5SQGKEcvsMzbdH6VwG3fOBlhLpVqre7Pvfw11dl4F9J1UDZW4MviC+dvpVNoYmI/QSEqPyzQw2xg7k2iiLP9hhM/oAv6JuvQLNKgVUQa7/RzFanyriYbcCwrvjxrBBN4Rle8Jgl2Q9HcmPCcST+y+Z635GzKID0fU5mHvDOKwj53+MA4z07aK7r8BTeomfAQwXczrctOxyjFM3hIS3WDD/Gh40ymM8L0cDwKyLCE0NPUp+KRJ3klDZQ547Lrv9LCEwRP1wbpu8/z+uwjnsMens1NMJFGzi/nd1r2BMSZ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aLEm7fXBjxb2gaYurce/M6MGWGsjjigNakM4W4aNp64=;
 b=Qwu76BSRCfOw5/ZwTReVw8gkyw7ajjqFKSsnZUyOoGDC4FXPk9WqdlaSHWHeUegFYod/JvcwC3FIR44itlhQlnepkaHa8PoxbpvYXBkyddOYGZ9Wnwa8Fg9oQtpp9MNdnDAszFkxg/05UKoPt4Let0pjM4s3KRVCyJxDYwL0kNymb4vZLfbz64w5txjzS7D6yOLOErQjot69hC5NFN6LM4TRmZceLIvXgEv27E+jNnG9yn7tU5OYp4KPLn2fCCwl3xnSufnEEsNoTK1L4mY2TnficdJtd5bhnLz12vSdJ+Tlv7zVndQRF0DfwWiAiC+zZ/OFEoOgMbSO7RSMUd/0tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aLEm7fXBjxb2gaYurce/M6MGWGsjjigNakM4W4aNp64=;
 b=jMxbmCzRBeeV+CgmqIvfUdU0mY7dbuL1BMfFucT4HtJGv/45UGsb5isZ+eEDEynZ4Hum/gwt0L+0YuBetsmHCiMIqqf/hqXBFbLeokW4vNDv5DYSPxjGhuJGuHHcx7vygyzLzl1AiETWrmFerjyzGl7sDPaF+ZzfCh76vYtiGeI=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYUPR03MB7163.apcprd03.prod.outlook.com (2603:1096:400:356::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.28; Thu, 2 Apr
 2026 07:20:47 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::165:d36a:3f76:2925%4]) with mapi id 15.20.9769.016; Thu, 2 Apr 2026
 07:20:47 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "vamshigajjela@google.com"
	<vamshigajjela@google.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>, "chenyuan0y@gmail.com"
	<chenyuan0y@gmail.com>, "ping.gao@samsung.com" <ping.gao@samsung.com>,
	"alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>
Subject: Re: [PATCH 2/3] ufs: core: Introduce ufshcd_mcq_poll_cqe_lock_n()
Thread-Topic: [PATCH 2/3] ufs: core: Introduce ufshcd_mcq_poll_cqe_lock_n()
Thread-Index: AQHcwHPTaq/YlHAI7USfheU+xp3IirXLYYoA
Date: Thu, 2 Apr 2026 07:20:46 +0000
Message-ID: <8f90336bd7d7a8ec17823f0302e746c6cb214b06.camel@mediatek.com>
References: <20260330183311.1941942-1-bvanassche@acm.org>
	 <20260330183311.1941942-3-bvanassche@acm.org>
In-Reply-To: <20260330183311.1941942-3-bvanassche@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYUPR03MB7163:EE_
x-ms-office365-filtering-correlation-id: 7fe9d228-937f-473f-9f8c-08de90885c42
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|22082099003|56012099003|18002099003;
x-microsoft-antispam-message-info: pNMDQEZF89FBmU16PBPPzqfFXVlAfHE3x+iKjzYNdi07ErYvAn2HFzGhaWa5jG7d9I2AZDE1wlloW9dS3l6B3RaSDSkI0yvjTk2zgfKZgbrerZFgLTvusGju4Zdq4np1h7CeqcgVYb2Qr8YKEBbIR4u1HJtYEp51ZFl0IHA4EcqGEq19BMUzsbT65VKG6smDzAalRVGJznn+B/I9GOcjcCCv6opUYZmMykGm1y4nlO1szWDfLUQEM5lBHX2Ylje/VeqU116sQXfUVhYme+sKg/MqNkIPx7npVub6/yNBgyf5fNTCDiJvV879UZhdyH1cHbuDUjY0q7VNeh3EXSiFIq4959n09yCcx/oAHtcXceHPeUZCjytrccwRzdvQ0A1+00qzaaKmdz0Ox0WYuP493O+F52epxVa5iJy8k3y6B6K8mzDcYk/2z1s7TM36V63WoLjcOxXEOYcEIUYXblULVpGMia9AIYdiOdYszxN5UF2TvxUKv84Egfca0m4r1lAcVCCrpp+byeRSypvp/dhO3JW9tKyCW7vdofkrmziLI8k28iLOdvPzLUPXbsscJ26LPYdRomT1kkyuJmXFwFb38vGU3bUkxb/Br/JF9vf+bPeANc1cv5ITiCr6SRHxUAOkuBbSTWMd4W97CdpnN4uhKq+a3BsjiAg3ktamLxDjLKAh7Btiza13wqxlw5SE0uiuE7eotuiHYM4EtNkhR/YtihydSRZFHLNI6ONPHeIBGShNkxZhohqsrpHQ4WkBIgCuwl6D3cF5J8b7fK+A0cyjt/dKpSdTA/KWMh3ejmIsUrc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cGZHdFJxZkhrN3IxbHd5RDJneWFhTHJhWUZiQW5xU1laQzkwNWN2aUN3SCtt?=
 =?utf-8?B?VE82NVVMUVM2MkJ3bU95MnVENmV4NEFoc1ZsNWpUbm5Bd3c4Q3R2WmJRZzc1?=
 =?utf-8?B?OTNnRHhzOHdrd29SbEdQZHZLNXNEVE9oVWZHZEo2NVhxMjJ6b1pUbGN1djZr?=
 =?utf-8?B?WFdBUmhSbGV5WTR3TGFLVE8zRzlGMGxJaTEzc2xnVEVmQlhsQW83MThlM25L?=
 =?utf-8?B?WURUNGVoYXJGK2o4UHdnelN2eGpmVlFadzIwemp4dFB5WDdwVlFBSXVUQmx1?=
 =?utf-8?B?ZGRTZm1nVEI2bzdUcXUyNzJISWdZRVBZWm0xMFRJVmttMTFENkZuZGdDc084?=
 =?utf-8?B?cG8vRW43NlpLQjI5V1ZpZ1kvVmpHYnR5V0k2L1VKRW9SSTB0Z1MzUlpmd3BG?=
 =?utf-8?B?bDBsL0tLclJERmhDNXVlRUt6cDJKQ3Z2bFo0SGsxSFFFb09vUWlncm9JZXJa?=
 =?utf-8?B?YXpmUFZRdG11K0V6MWVrMWNCU25uRGZwVlJoclFEVndKSXZBR2FxY0MyZHFR?=
 =?utf-8?B?QVdob0p4N28rNktwWnRFY3JHdHlSc3JPSHQrZ09FenNONjlSUm9DUTRHLzlw?=
 =?utf-8?B?VUUyaXkvZmZWTGtVaFE3N1NiUE9TVUtCQ2g3bmcwVEhJVFZpZzQ1eHJJY2lp?=
 =?utf-8?B?akJmNWZJVTBtYnJ0NTZsVVFnd01VQUlDNVYxYm1KMm1UZjgyTEV0QWFkYjFE?=
 =?utf-8?B?cklSVTlyRE4zdVFmVFZyOG13MGduUkU0dVNuZDQvcGFPcEdrdnNGNGdmRmF2?=
 =?utf-8?B?QmFwRlFTbVVUTklUZ0FoUXV3RjZKT2pOYTg3ZUd2WHdGT2c3dU00OUFzRkd2?=
 =?utf-8?B?RE8xWTY1K2diRzNSeDNDOXpaNWlQSE9xelNueGZFZWlKVHIxRDRkZm1zYUR0?=
 =?utf-8?B?Q0hkZGxRNkFDc1ZGa2Z3d0ZuMU9yaHltbFRQWm11VCtGTXRWSld2V1ZRQWZ2?=
 =?utf-8?B?R3FpZzlMZVhHRWlNOGhuRnhrbzR0UU9iaFRrb0xqYVJzdGxsT2lDRlpENkM5?=
 =?utf-8?B?S0ZrZi9POEtMckJOT2p2dkhWZUlZWHNkdXN5NnI4TkR5U1pIRGl2U09Qb0pS?=
 =?utf-8?B?MElyL1J2bEZlY2Q4QVJ1VHMycWk0OVRUbS9yQmhIQ2V0aTZ1U0p0TzFsYkk5?=
 =?utf-8?B?dEF4Sng0WUxUSFdrUWFHV2hWalp2MWdkRWsxRVVjQkg0S2Z3Qng5amZTc1lN?=
 =?utf-8?B?ZVU3a1Y4RllFVUJkdUpBUEtJdVFHalJOT3V3UGFrVWNxQkdvdjF0VGxvMHZw?=
 =?utf-8?B?ZUcyU1FDblIvNUZYNHZLRGp3R2lEQ0Npemcyck9yRFAvaWo4WkZndlJPS2xX?=
 =?utf-8?B?NjlsUUtWRTUzRnBrYWE0Q2Rob2dab0VMZVRyb0laVHA2RXB3eDVwcHpIUm5D?=
 =?utf-8?B?anhjUGVZYkJVTFZWYUYvSTZwTUNzM0t4VUNHZFAzVVdyUTBIUVZLcmdDUE12?=
 =?utf-8?B?YTBCVmVZcmdGWHh5K2ttZE5Gb2szZjNXZWRPRTIzTDVOM2hpUXRNbEdwbi9l?=
 =?utf-8?B?cGRxbGJZZkpzc0V1cjhEZVAzUy9SQ3p4VENFbUtQRHNjYTlwY3YveFVmVnE2?=
 =?utf-8?B?blZYUHpLbk1UVUJRM0lISCsvMk1FenZTR2poOEJXd2ZCT3RJVloxVEhweUJK?=
 =?utf-8?B?QUh3dmxlUFJsK3ZwUldzaEtMeGNXWjZnVG9uN3NERy9Ud3Fvdkd0VWpZKzFM?=
 =?utf-8?B?YUpJa1hTR2c4VTNsL2w2NzJMaUQxdnJsdFVnM3NmUzMrdGFEbUE5cHRuSklZ?=
 =?utf-8?B?cjFIZGtWcHp0QXpSWmc4ZTNCNXEvck0zaUJsN01JK0FnZ1R3VkNwV1pPeDNI?=
 =?utf-8?B?dmdoYTY1VVpZK1dlYTlkcTdjT3ZOOXFrVVRsalk2bnZqdDVIOWQ4UlpxclJN?=
 =?utf-8?B?dS9SUkthVXVURUlFUURWa2ZqS1prcUY2N01XWXBZUDJnNzdxcTl4QmJOVnBn?=
 =?utf-8?B?cjFYZFhwNWc3NnVGWUxyN1lKRjh3T1RxaU0xY0RJRFVFNEFkM3JrMzR4ZENL?=
 =?utf-8?B?UU0vcW56NUlRRE0ydGthTGNQVTNWdndoZWRjMkxoOFlacUZBTElwT2pmUHlk?=
 =?utf-8?B?WmJIQUJZSUs5NTFQVWFaRW1wa2oyM2ZrQmxabmVrRE42Zy9zUWpRY2U0Vmx5?=
 =?utf-8?B?NHVnalRwdHJ0RW1QeXNnWGxOcU9vUDBWY1Q1WVVmSkh4YlgyY3RGbXczS24v?=
 =?utf-8?B?TmZ5Mk9RSFYzUTl4R3NnbGg5SFVxN3BHaUJheDhnOVp6dGZNSFlaNjJHMlM2?=
 =?utf-8?B?N0ZNZUplMmk5NTVnUGpuRWtueVVuN0g3QlVaV0FNbm5kUjhVd1NCV0x3eE1s?=
 =?utf-8?B?ZXJ1QXpLRTNzUTBWYWNKOHZCbnFrcmFmVENtcGF0VDYwV2l6YzIyayswazNU?=
 =?utf-8?Q?223kcS0Z4PNzWd+E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B9DAD265525404A9376D83A21B5267F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: hPuCsIOyaw5CJ5q0umdjDrf28FAutU+KEd4fOSJFgHH2MSJiZYi62hPAVPZ0McTH3WBhSihCTDIPFDECSgznWfsKHQfZuI67RI/RZhvFLNFVYaI4HBOuRe3PnfHkmU0SXLTXx7Q+UDLdXTrP1t15CQhloKG6d8Jdj1wJIwByIxCEteRNGHRrVBSrWX8hXVa9jppvWxWgcv2cYehZHQYRBRrFWunvy1/AulXK0xclxaQD6DPAmWaeID+GuMJGrxP7B6wdYncm3JsIbbExA4i4hvNVfRVwzcAL97Wuwm3ZcVebkjXy4eFzpIkub+NRf5QmsDVzpzhB77R3SeRU8N9aFQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe9d228-937f-473f-9f8c-08de90885c42
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2026 07:20:46.9770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9xtuQ8PCG6zYuQUe+OQUYjG94BrlrMy5sLkvijXCYGCb+LRQLPLdytK5grXK5UUWWpTVkGgxOA4NHmzMLr6EPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR03MB7163
X-MTK: N

T24gTW9uLCAyMDI2LTAzLTMwIGF0IDExOjMzIC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+IEludHJvZHVjZSBhIG5ldyBmdW5jdGlvbiBmb3IgcHJvY2Vzc2luZyBjb21wbGV0aW9ucyBh
bmQgdGhhdCBhY2NlcHRzDQo+IGFuDQo+IHVwcGVyIGxpbWl0IGZvciB0aGUgbnVtYmVyIG9mIGNv
bXBsZXRpb25zIHRvIHBvbGwuIFRlbGwNCj4gdWZzaGNkX21jcV9wb2xsX2NxZV9sb2NrKCkgdG8g
cG9sbCBhdCBtb3N0IGh3cS0+bWF4X2VudHJpZXMuIFRoaXMgaXMNCj4gc3VmZmljaWVudCB0byBw
b2xsIGFsbCBwZW5kaW5nIGNvbXBsZXRpb25zIHNpbmNlIHRoZXJlIGFyZSBuZXZlciBtb3JlDQo+
IHRoYW4gaHdxLT5tYXhfZW50cmllcyAtIDEgY29tcGxldGlvbnMgb24gYSBjb21wbGV0aW9uIHF1
ZXVlLiBUaGlzDQo+IHBhdGNoDQo+IHByZXBhcmVzIGZvciByZWR1Y2luZyB0aGUgaW50ZXJydXB0
IGxhdGVuY3kuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBCYXJ0IFZhbiBBc3NjaGUgPGJ2YW5hc3Nj
aGVAYWNtLm9yZz4NCj4gLS0tDQoNClJldmlld2VkLWJ5OiBQZXRlciBXYW5nIDxwZXRlci53YW5n
QG1lZGlhdGVrLmNvbT4NCg0K
