Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE3E20317
	for <linux-scsi@vger.kernel.org>; Mon,  3 Jun 2024 17:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717437129; cv=fail; b=WOdn/ryvnVm5PUA10qHMSxD0RlfeiX5Y01na7A2KpqgFpBvoYxb17aP2ZVF3fOCDOA+BrkrBFEdxBUx6X+1X7Crajgom5vrkeEJFnBHxpmE1dUffIXp8ubYaRYiuquFTtJRV3efwasl87uQs82ZUjhhlWKG39hQwxNtAvkoRPYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717437129; c=relaxed/simple;
	bh=oPlVB9CJXHUVGQ5/UApwDpDqHdGecoW8DBSJwZ8AOwU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dSFHifczTt6wkLRghrW1ZsH7GWPO1IEcZTDZnmYSVHqeeXbjGFQdqVuTQtksKquiQW78infMRvhiFEtLR0vcvZjwCLoXLR0ZxOPhF4LK8MsCLOOCi/oXixSxrQ/6B18Z5rfsS176j+D+H3U55NSG4CARhEReSRhv+9siXuajtNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=gyqElgRT; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=rf4NtjBf; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gyqElgRT";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="rf4NtjBf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1717437127; x=1748973127;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oPlVB9CJXHUVGQ5/UApwDpDqHdGecoW8DBSJwZ8AOwU=;
  b=gyqElgRTa20KOy0oWVYEyMZaHaTl4ee0V/mAWY6yphrOtQ48nhEBmcLe
   Z+nE/JUVnP0Bwsmg6kiGStrZkRXOZYO7aFdWqChNsVbjOhNlUqdo2tyUw
   Jm7Vdz9Hwfava0eMe1NVZAlsLCwP87JxO+7DCa9vbkLDLTJG0Cbb1GyCo
   4Z1A8rwOTd/nk+8TsPvqK1aQqzeVPrI8HdVdFUUiFz7lF7pfOTTwczGuz
   syDCY2v6rHPzKE7fbTofbiR3zqUojVFvNcP9y8X3zQx9TCqjmdEsK3a+k
   LKS1f7X3X140a/ZvW1hbJ5EcbOfYSl0W3pkurCpkOYO9WadGByd4gUgY1
   Q==;
X-CSE-ConnectionGUID: nlgz+3L3QLCS2moLRwaukw==
X-CSE-MsgGUID: iy9JRkAoQgCx76RsAeE6vg==
X-IronPort-AV: E=Sophos;i="6.08,212,1712592000"; 
   d="scan'208";a="17356549"
Received: from mail-bn8nam12lp2169.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.169])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jun 2024 01:52:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EuvB1GiJpu9qFB/0nU93+7fcbgRRtao71bGoSFMU0zxnZt058ZFDA/uap+TnWL5ANIG/YRpQy5tAFTPmGteyNuD96zGjNlGD5crX79ak8yI0kXH53Y01FpYdwvTWBFuW2ovH+PC8HvAe0P+qCxy7BNEQ/cPEWgdkhaQOfvUZV8XjdtJJJF7F/o5Gt6kbBBky+GGty5OevGxQ2gadrJuymMN/Ig/ZRvdY47w8TRXRl25tYtnF2mqB/CjHoouDmHxuKS7iLLhZ+V3U3dXegA+MhRCG9fR2HdnBIw8kEAalN02SnxCvtasT+4czMhBiFpsAeTJKkLH6yRNXb96B3yczoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPlVB9CJXHUVGQ5/UApwDpDqHdGecoW8DBSJwZ8AOwU=;
 b=ZfQzEMPlogt6UJFywlRpJo1l1NftQQXIJPNKTZbs3F++99qWI2eRyEginP7tBI+ZJaYHbvH02m/Z3cDchXZ0woew4E0BN2/dHupLdykk2bOqEs7S6VOgrEHn0nRilXXpqa8p95eSSM2KpIQmRccMFV9+twime7rRJEEWw7ci2AOT7jaSRVeZH9T9ukFv/wO0/SSGRn5Da3aQGemhVOAF/o+Jv0W+8kmeML1/CYsRKSNGaSrfEXCkQgO5DTQrXxHF3TeHFtR3C4rJE8/lgsvhuk+LxFn88vP9S6AMpUxajOBETqLzIwH7qb8XlqFI6kUA8t/5RbWDcApPPtEHnh+hVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPlVB9CJXHUVGQ5/UApwDpDqHdGecoW8DBSJwZ8AOwU=;
 b=rf4NtjBfoTTKg2kqvF0XmeEouawCMary9RMEEb95ZA02QwTtfXB5IkiCxJqoflDmAkVQ81s1IZWa4LDmrdS6nK2TkpbanzGZ19x5s3nn19RhFyPmYlzgtffxDD6qvkYtjyrD1/oE38hQkWpjaEWuX0EY9Tg8RJUZOVuVxYX07xM=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH7PR04MB8612.namprd04.prod.outlook.com (2603:10b6:510:245::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 3 Jun
 2024 17:51:58 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 17:51:58 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/4] Declare local functions static
Thread-Topic: [PATCH 0/4] Declare local functions static
Thread-Index: AQHatdrO/pTFXj6ab0mdwHJAhKii4bG2Ub6A
Date: Mon, 3 Jun 2024 17:51:58 +0000
Message-ID: <b6ac9234-8f76-41ac-9fea-c6f2c2028908@wdc.com>
References: <20240603172311.1587589-1-bvanassche@acm.org>
In-Reply-To: <20240603172311.1587589-1-bvanassche@acm.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|PH7PR04MB8612:EE_
x-ms-office365-filtering-correlation-id: a7d9cf18-a8f2-4b5d-c2bb-08dc83f5dd4f
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info:
 =?utf-8?B?NHl0UGRCa01NRjg3SURXZ3JPVEhOdkoxaXVSR1pDODhhVC9mNVNydWdETGl5?=
 =?utf-8?B?Q0s2SFlMY2dMRHMzYkgyQW1xbmlSUERmTkVSNDlFVzJYL0xuNjg4TzBPeWJs?=
 =?utf-8?B?UG5tU2dHTWJmWmczNnMvLzJUS25WV1F3RDJqQmx3RXFGR1J1bk5Vbnh2cHMw?=
 =?utf-8?B?d3pETVN3dkFpUjZiN3B2NGZudkNGbFFxZHJ1WkZXUGJ2V1dyV0RUMUdZaFdD?=
 =?utf-8?B?RHNLUHBCSytpQmdZRE9oVHpONlQyZTVSOWh2UjVLVmRmcW9SUExvcU9PK2Rj?=
 =?utf-8?B?aXVjSE5nbWRsNXdnTGw1UVVRTXFLTEM4NnhlQ2w0bHFRMXpUeUlwb3VXYWw1?=
 =?utf-8?B?Nk5IelRUa3E0VU82NU9TZ1NHaXdsOU5xdU5lVmlsWE5mYVliQWI2WjNMT3h1?=
 =?utf-8?B?MC9UMGZOVWMwK0RpUk9NZG5mU3JyUm14Z3o4RGYyWTJlNjNHSWpSMVoxeGl4?=
 =?utf-8?B?TmUvVFBTYnhRVUJBczBBSFRGRkZCUGxTN0ZWZ2llVmlsSXgyaW1maUhRRVJ6?=
 =?utf-8?B?amdjeTlpVHlSR2NOWFhjTWx1eHJKTkc1ZjAvRitvVFlTS1haWEFNZ2FpQjdx?=
 =?utf-8?B?SFpPMzBIUm1aTjhEQktHam4zcEZ4Qm54NEx6L1hIYUFpZWlvRWt6cWZPY3FG?=
 =?utf-8?B?dTNwRU4vTWg2TGRGeFA4UnFxdjZ3c1MzTTFBSWorOTJDYUpESDBTSDVqemV6?=
 =?utf-8?B?dUFELzBTMmFYR0xEQTZ0Qy9VWUFWOGs1ZUFhSnAvK1d5Y09rSVI5R2twVGRC?=
 =?utf-8?B?WTBUUTRTVTlJeExxR0VwcDJKNDd3Q2ZYZTRUVjMyZjAxVFQ5STNzSzEvVnZH?=
 =?utf-8?B?a1hkYmtMb0dRMkNmSmg4WDdZMWo1RHUrQWpWRmRQeTBIZWlObG0zbGtkL2hG?=
 =?utf-8?B?Z0d2Uktmem52N3NlSUZNTzZ5QU1OajBiSnhiemtmU1FkcDlBbDhHSWN0czRl?=
 =?utf-8?B?N2dzS213d2tKOUMzZHJkODQ1VGR5MURseTJ4ZHpueHljSlJPUVZzQlpINmhQ?=
 =?utf-8?B?a0N3djhCUEdVVkxCN05sSlBxSHQ3Slc2VHcvV3ljMWdsaUxKS1liMjJSY1hO?=
 =?utf-8?B?SUhMM0RXTklJRVA5SUtEUlhKaTY5N3NCQlVEOXBWTTR4SW5tcjhuOVlmRXdu?=
 =?utf-8?B?eDUvb2VHU2R3Q3prb093WElLbTJPeGxCMmxISmphNCt4RFZDQ1hGeTBtM1Zu?=
 =?utf-8?B?cWdnWS9KczdTSUhQbzgxRlU3czF6c21mSHNSeEpKdzdhbXRKLzJzMlkwNWp3?=
 =?utf-8?B?Z21Yd21QRTl2ZzliYzRWZzd0UWtIcjl4TVlIaTJyaUo2WStXTDdwVWxYSE1q?=
 =?utf-8?B?cENVOUV1b3dNOGhxR3c2TS9GNGMxWlRSeUFwSnJTTUZJblFXb2lTOEhrQmdy?=
 =?utf-8?B?MGFmSFVvZkJtUWt1dHRPSEZwZ3Z2WGhFYzhud0l6SjQraVFtdG5ON2NOK1ds?=
 =?utf-8?B?enlKNTdsOW9hNzBPTGIwbmwvUU9zZ25rc1dRSVpaMlNQRE55U2wxSlFUeWIx?=
 =?utf-8?B?bjdJWDlaOFgxbTE1MityNGFVNVNxWno2WFg5b2F0cXR1K0wyd05pUUtaOW9P?=
 =?utf-8?B?RFNlTzBtVzlIM2U3WHQ2cW1zQXZTYXorOFA1Ui9KbUxFa3JOMmRsV1NUYnVx?=
 =?utf-8?B?K2hzeGpabHFyRkFCRlBKUFdIYzlQRUFMc1BYTHgyb05WVlRBVGdLWjd3M2pz?=
 =?utf-8?B?MnVLcWV5L2tIZHRqR01YR0lIUjlwc1VqU2J0S2hXdHBUbGkrTk51Vi9XZGlY?=
 =?utf-8?B?V3JMM1FLamxhR0U1eVFCMUVGejNpTUNyKy9SYnlGTnFlUlpOWkMybCt4REt0?=
 =?utf-8?Q?ksF2R/dyyjJz8OdGLqO5l8/EzO71Y94lCmqIs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?emV0bytjNExwWW5ZVEM2WlVpM2NiT004dmNyZVlEUGN2Ly9iTVF3aE5zSjht?=
 =?utf-8?B?MWM0RlNPMkh1OTRqbFl0K1VEdVUvU1NtVDJFUHhHU0JDMXQzT3p6eXRhRkJU?=
 =?utf-8?B?dk41UmdWbkxMNkxoNXpQdTFMaTFXeUxvNmVuTTVOSDdDSlJUNHBSMXZNWXlI?=
 =?utf-8?B?NUN1ZXZQelgrL0pyWk41T29jWUNuOHNsc3NhT3cxUUMySG5iY2lLSjdvNmlS?=
 =?utf-8?B?cHFjMDZYRlh3eVAvSVFWSFo4aitxNytFQU1Hajdmb3k2N01pU05UUVJ5anlL?=
 =?utf-8?B?Mklta2xkSXkwOC9MRHJiTXJLdkg0MVZLZE5Yckx5YkwzSUcwWXRtVHkxWU5p?=
 =?utf-8?B?VjFNSmJxTzFYS2tFL2U0TG1TSW5iK2lFS3g2QllQS0J6R1JLNjRMK3ZaUjdL?=
 =?utf-8?B?S2R2ZlJ4S1h1eXF4b0lPNnNvSENiM3M0YlhHUkRwZ0Uva3UvZWxQbzZjV0Zm?=
 =?utf-8?B?RXdWWkxrNHdMeHV3OENtMDN2MExseVlHMnJXNW9sa3lDaDJ2UnFRRm96Z25W?=
 =?utf-8?B?alJVQW84U1BuZjhLTGNGWlFraWphT2twR0RwRWJTMXU5WDZLWk4veTFhZDI2?=
 =?utf-8?B?YjFoL3NtbEE1UHdPRGlnUzdoZmJsQ29DLzltVExBV1piMHE3dmRtUCs5Mmor?=
 =?utf-8?B?dU0xeTNob0FzQTk4T3l5TmlyZGRYVHhDdnlyS1p3R016RTdscU0yUjQzaDZu?=
 =?utf-8?B?UXo5QWhlOHEzOXgvWEM2MzJCSkloM0RrUCt2N2U0T0hwQUtaRytXVnJTYno4?=
 =?utf-8?B?ZUVuM3RVUmE4WWxVRVh4VGNLbnd0dFdMSkdJZ1AxaUNUQkxkRVdhUGZQNENO?=
 =?utf-8?B?V2E3ZjlVNFFJZUVEL1NxcUFpNlBWaUpFOHA3M21kblRXZWgwSk5BY1p4bG5Y?=
 =?utf-8?B?UzdMcVNYVjdIZDl0eFhBRzhvNFdtRG1sWVV1VHpOek16VUdkQUxleHZSRGlv?=
 =?utf-8?B?UVRVQUxBVXp0NjdlcDkvSlRFd3VlZ29UMW1UMjJjMFlBekhhd3l0ZGh1enNW?=
 =?utf-8?B?emFCVDkzNWdGaDZYaWhGdkhuaGVVdnRVTDRBV1Y5eVY5eis4dndWekhCSnFu?=
 =?utf-8?B?NU1NaVg1T3RwNEN0MUJnOS8rVE5ZRGcwc2ZJbFZIaXprNllNSENsa0E1Nkp3?=
 =?utf-8?B?VjA5M1JESFRGUUFGZnlvMFFiODIzSDRoSFoyQllhT2pCM0VNNVZodTc2WHl2?=
 =?utf-8?B?TVh4Z01ZcjNPNlVldXYrNy9OaEZZTXVCUEdlWUkrbkJiZVFPdFdUS3g4by9B?=
 =?utf-8?B?N2tSWXFTUEI4ZUNraUdiY0E5NkFmSTlnZ0gzTmlSTG01aU5QelhFb3ZQOEtq?=
 =?utf-8?B?b0dLbnBXZWxnczJsMU9nV2prZmhTa1lvNDlmTW9objBDdk95S0hORWJOekRr?=
 =?utf-8?B?T2YwY2g2blVnR2ZkMW40aVRIU0FHWHJmZm5neEo3bU91dDRLUUFQK0xiV0Rm?=
 =?utf-8?B?K2Y5WnFqUmNJblRyVExYcFZUODRHYkw0aktoUytyRWZmaUFOZG1nR1RBaXFC?=
 =?utf-8?B?QmdJOUlBbUNlbUtnVEh6cy8xTzhqa3c1bjhlaXZqWnZmRmhSS0c4bVVmREZz?=
 =?utf-8?B?NXhnamtuaVJRODl0TTN6eURGS1JNV25La3RUYUk5cVJzTDhsSkdqOUVTSjcw?=
 =?utf-8?B?MVg4Y3RWRnZHRlpReGVvaWdmL2RjRUlBRFVGVEZoOTdJRm5BdWVRM1JCVEtp?=
 =?utf-8?B?SS81UGJSUlNIZlJXM01XaGhtRTdDR3A4ZUlWaHVEM0UyUVl5NGgxNG03ZnV1?=
 =?utf-8?B?M2VPa1ZiM1BPZkxtYVpkeDBZckFqMWNxbUwwUFU1b1VvNDM1eTRTb0M0M2ZN?=
 =?utf-8?B?emcxNVV1TlAvUEpiZlFvVElMS0p2MHFCdzJIZTU5NDRPU0cwQTZLUVcrREM0?=
 =?utf-8?B?M0FBUTBES3loTDZBTjk0RXg0cUlad2hIbHpmTWxlc1k5R3h3TXExK2xsSkVp?=
 =?utf-8?B?Ukl2L1UrTzZjMXZXRG90bUpLcjFHNndobVhLRlZmMFBmcGJJMGNXTkVxN3ln?=
 =?utf-8?B?ZHdYYmNhV1BUaTFNamRlN3JNU0R3QkxIamVUWGVjUFJWQTB4UzJtZFQ4Q0hR?=
 =?utf-8?B?OVk1ME1ycFZGSHhLOHZMRFVqWjZqWFF2RktIVTNMVXljV2lYYXQwU3pvcHJq?=
 =?utf-8?B?YXN3VHMrNE9vdUtLTDkrUW92cWU4THdHWTh2ZDMxdmRlbGlodzdJaDBOcDM3?=
 =?utf-8?B?dkpRc3RqVGFDVHhxcWg4WXpJKzRCL2sxUm94U3dhSmZiVDhYTmdRQlBxaFNK?=
 =?utf-8?B?NDlTbTlpSWhubmxrOWcvbFBsTVlRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D440E4270E9D4438A1426CC9DDEFBFA@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9+y0Fh56uwW+Fvfm0qKjevfio4Ti+/s59rR/UEjc5ocoCgZuVz07qv1GxBlHEDzVLm1tNXKcbb88yWAbCR4jJo6RKmnhr/azP6wwieXB1h59v0UrX/fQ1P50TM0Zcevp2DyrK/k9UArD5ThPaBMwZhYOZ0bj5UEuqfzuK8VB+UdwLei1F5MXDCcY9uNqTByN1FcmG1rwDNDMs4+WPLwf3YKgguc2L7nqDtDIG2HM8f2ZVJO7uUad4dSwb4XmJGRno/Y4EifZ+OKhcXgF8eMgsIMhuB/TF5gUUFvSHcBXrOcErWHiKj4YSl/w5xJ11qGU81AwJHrTUjhVzPFAvivSa9E4qzeP6HCB9T93ky1yjNs0W5JnHJwKC01G5AXAP+wc/iZ+hAKkXSTqEg81N0LFNYeAAJBMBpDQvBGqhaj9nwQ5lHH2+Ux4HmIT7A5RZwBwwzKlHjO3PlbQRy3IlLGatY1ENhvM12BO2aA4equFazrkBUHzTx3B2V2NDmGbcvpVxWVqT1PbYsAcFGueUH7BajE9hgIlcNF2cTYB2bGnPv3gJfrPgYsII41g40TMwET8kouyF+4ezSVnw7fMQzmUXfTQfPVfGpbYYkGU+wEvpRZfx/3JB/oVMaj8qSOvSGWJ
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d9cf18-a8f2-4b5d-c2bb-08dc83f5dd4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2024 17:51:58.2786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ofMzxs1sL1bG4PIOV0z4ssQLSPKNHtPuRM7ZaEpLUzavz3f9RyCAnJoFHRMFwLjwLWDfCDFEFT9VFgXcqxTJN+cui/TjqfHdZ4Flp7SI0Ik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR04MB8612

T24gMDMuMDYuMjQgMTk6MjMsIEJhcnQgVmFuIEFzc2NoZSB3cm90ZToNCj4gSGkgTWFydGluLA0K
PiANCj4gVGhlcmUgYXJlIHNldmVyYWwgMzItYml0IEFSTSBTQ1NJIGRyaXZlcnMgdGhhdCB0cmln
Z2VyIGNvbXBpbGVyIHdhcm5pbmdzIGFib3V0DQo+IG1pc3NpbmcgZnVuY3Rpb24gZGVjbGFyYXRp
b25zLiBUaGlzIHBhdGNoIHNlcmllcyBmaXhlcyB0aGVzZSBjb21waWxlciB3YXJuaW5ncw0KPiBi
eSBkZWNsYXJpbmcgbG9jYWwgZnVuY3Rpb25zIHN0YXRpYy4gUGxlYXNlIGNvbnNpZGVyIHRoaXMg
cGF0Y2ggc2VyaWVzIGZvciB0aGUNCj4gbmV4dCBtZXJnZSB3aW5kb3cuDQo+IA0KPiBUaGFua3Ms
DQo+IA0KPiBCYXJ0Lg0KPiANCj4gQmFydCBWYW4gQXNzY2hlICg0KToNCj4gICAgc2NzaTogYWNv
cm5zY3NpOiBEZWNsYXJlIGxvY2FsIGZ1bmN0aW9ucyBzdGF0aWMNCj4gICAgc2NzaTogY3VtYW5h
OiBEZWNsYXJlIGxvY2FsIGZ1bmN0aW9ucyBzdGF0aWMNCj4gICAgc2NzaTogZWVzb3g6IERlY2xh
cmUgbG9jYWwgZnVuY3Rpb25zIHN0YXRpYw0KPiAgICBzY3NpOiBwb3dlcnRlYzogRGVjbGFyZSBs
b2NhbCBmdW5jdGlvbnMgc3RhdGljDQo+IA0KPiAgIGRyaXZlcnMvc2NzaS9hcm0vYWNvcm5zY3Np
LmMgfCA5ICsrKystLS0tLQ0KPiAgIGRyaXZlcnMvc2NzaS9hcm0vY3VtYW5hXzIuYyAgfCAyICst
DQo+ICAgZHJpdmVycy9zY3NpL2FybS9lZXNveC5jICAgICB8IDIgKy0NCj4gICBkcml2ZXJzL3Nj
c2kvYXJtL3Bvd2VydGVjLmMgIHwgMiArLQ0KPiAgIDQgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRp
b25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiANCj4gDQo+IA0KDQpGb3IgdGhlIHNlcmllcywNClJl
dmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRodW1zaGlybkB3ZGM+DQo=
