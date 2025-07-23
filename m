Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B86025CC63
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 06:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.141.245
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753251384; cv=fail; b=EJO0h6hIzvngS+74fDXSmfaqz7chnhCSsv1pdcYSjM0BKE66K3DWRYyraqoloVNuFpWHmIluIAxl3qr9Cf3sqxMk7cW2/SVWmkD6F/VyhugeIULTFKf3AJ/RWguBMm/zd4z1kEm8rxBTl9nWAhMw7crQzKt9AC3Ka/8W6ONFAn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753251384; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P4b+TqU+KVjR/jpwV9QwCg6zesREjpJ8xNhDd3sbMMY8ImpOQc4bJz7c+OsWzc3nCfE73Al8nu2acEb4UwtdGgZx/W2fWAtffeiRhLwR3IPQlCIvpwYLP6HUDpK5wN8QRhLkVkJ5+oXe213p56LSV0WVsPj3UosRbd6rVCP3KQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=d2bOgmhs; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=DOVCEWhH; arc=fail smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="d2bOgmhs";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="DOVCEWhH"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1753251382; x=1784787382;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=d2bOgmhsAeIhgGn7M7Thtq20EYe00hlhPI2UtuAmYUuzHea+KMT8uvSh
   PcRVKf74EBxfe3dn+nTpd3BItIBuEicJ/7qa5LQ8d1Hlz+9u+zF/SkE63
   Gt42US6KsbMXoEPJJUL4HlhPPmeOKL1gfvuuOUp8VLiZgVf7ilfaz2A/Q
   AtfsWIM8EGC3DYJlmWZKyP67X39xbzdE8/Zli1xDo2qFoyeGmS0+ZApyt
   /DisbhOGXm4ozgQefukpoZ+SsY402b7f4bgbpSOXaBzm78xro5VgcHUmr
   e5aCR73N7XZo4XzuheM5GS44/oWQIRwIgeUIHlyLchpefzvXAwA6keu4L
   Q==;
X-CSE-ConnectionGUID: jCS9f4usSkGlxu+klHfL+w==
X-CSE-MsgGUID: /nr6hSJgQxWUhkiIqq4asQ==
X-IronPort-AV: E=Sophos;i="6.16,333,1744041600"; 
   d="scan'208";a="95069830"
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([40.107.236.41])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2025 14:16:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mkpML55qNILebaClMidbC/PU1okicvYxnZbKgAG2LTGBBq1qX68YBLcLxHulVYxrE8vdDv2IupLXQcF9MTCYH6QHOOsC23n7SxHtmPiiJ5xtlg33TSRBILgDNIsIndg+XA1jkpYWPyxD6GmwoqYPI3HYsfcFC5jFd3Dm5DwEjdOrCmNbnM/f1R1b7LITp+j4uMEnlf9uzBY56ExPWFwIn6HltG8ROwxWgVs6eu2CCA/T6qv73XH2nNC/MJTjbkFfUgB6nbWnrTmcx+24CSFv8POJNY3DnWypc2RKiW/6wL6u1NmpGMcm9KmEdbA3tAEsE/m0BuHZllOs5pykuC8BKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=QRt5HTlF1eQRbIHMfZovAnxCHa1RHfvxP7oQklKijtqcxcXN7WKe946nuXYaM4qwyMAgQdIwDXf8ZhuBOACuYqaUh2/sUsQIv0wYij9yV39Cpd7Tm91peOm237I6FmHWDMLf9A++rX9G8DHHSrLk97k3xzLzd9ZUuGiaKM0HpQkuQnuVrqLMNXCEaXrd6A6Wb6LCAiveEzcb+KKZRWPTJnXk7c85UhuV98q2T7Dgr/3t9YO0V+qkh3oK15aiTex2pzEPNpbXOftHbAqbuFsQMFTV5p5OZUFxxOuUhgL2bBzQgKgYb/RHdnw3ryvYzEoaamNs72lwmtx/XnuChoDD8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=DOVCEWhHesxH+PChWrdv/p/JkjVJTTdKgY1Do6VbH0NzRbI0QsKnvAcF1wgiH593fbzo1iOvX5+BaEyRi7bP4I1AJvR1YkoxrYBlyJNigh7qR1q6zzxGL7gHgWTSJ+Jutf/hXXhbF5KTcYQO6JfhkZvVI43Rnz4sKF8CeQJFoqY=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SN7PR04MB8642.namprd04.prod.outlook.com (2603:10b6:806:2ed::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.29; Wed, 23 Jul
 2025 06:16:20 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 06:16:20 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <dlemoal@kernel.org>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH 3/4] scsi: libsas: Move declarations of internal functions
 to sas_internal.h
Thread-Topic: [PATCH 3/4] scsi: libsas: Move declarations of internal
 functions to sas_internal.h
Thread-Index: AQHb+5SDtH+ehSyIlU2WNf1QxoNl2bQ/O3MA
Date: Wed, 23 Jul 2025 06:16:20 +0000
Message-ID: <f45eca1d-29be-4e7a-af31-5e2f1c640b05@wdc.com>
References: <20250723053903.49413-1-dlemoal@kernel.org>
 <20250723053903.49413-4-dlemoal@kernel.org>
In-Reply-To: <20250723053903.49413-4-dlemoal@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SN7PR04MB8642:EE_
x-ms-office365-filtering-correlation-id: c335acca-56ba-4418-19db-08ddc9b0711a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WVdPZWpBU1ZDeTliWmhBQlZSTDc0N0JPdEpTbmJQNnV5andJYXBQNHF6WDV0?=
 =?utf-8?B?amVkK2tXMTBvelVQV1B2bHFhWlJlUjdLU0VtNEFQL0tGWWdXT3gwZnlRVmFB?=
 =?utf-8?B?ZFBRQXJKdmJ1OVRvN0wzM2xKaU43K3l1dUlwaEVSbHc4dXFleWtWU2hTN1RD?=
 =?utf-8?B?ODNNTDhab2QvczMwNW5BUmhxeU9GV1pkWnJFUzQ3SFVZYTdZL2hlZi9DVWhr?=
 =?utf-8?B?Q1JMT1pUNXdKbmhvS0N3N28zZ2hHSnRqYmdKOEJBU3lEL1M2eHFUa3RMUmx5?=
 =?utf-8?B?aFNCSGNLck0rMmZnZ3luMzNGMDBJOWhXS0FsY0JaZDFoY2w0WGVxMExIOG1w?=
 =?utf-8?B?WUQ4WTl6ZWxTZHpIU0lhd1hZU21sWVk4N3RvcWZCWWljVVh4QzQ3R1dVQUFO?=
 =?utf-8?B?dWU0VWk4dmk0YUpFd2Nucm9nbi9Uc2NMaCtIK3lEdFBHVjQ1TWhJcG15Kzk0?=
 =?utf-8?B?QUs2bGRLZHR0aGlkL0tScmtia1YzMHd1RkhXbjVnMUtWMndNdi93MUc4c1RX?=
 =?utf-8?B?MEFGeDBqRnhKNDNLV0ljeWozSm5DWmdtVUZrbkdjOHZpSzFLbDVTVlErOE93?=
 =?utf-8?B?QVZaMnZqYVF6TjA2QUlnVnBRNTlQS0ZhcDRmZEIzdjkxSW1FOFEwWXRWSTNv?=
 =?utf-8?B?Wkp3SmtYSkFTQ1c5QU4zbDZiMEVydi8ybGtLU3NjdDEzZ0NMREpjODROTzFR?=
 =?utf-8?B?Q0tmQUwrOVJjZ0RqNzgzUm9NZXJFanpiRjlzYnZBTXhsSTUydzhCQjlJSVli?=
 =?utf-8?B?QUx2L2FSWVAzQjRyQmt1STdPSHRxMU9yVnpudGpqcW91UTAvak1oZnVGUDRS?=
 =?utf-8?B?SGFrd2ZtaEM0RkdQSkdDN3o2dG1ybittS1MrejQ1M2huSXNuSXpEU1VWWnRp?=
 =?utf-8?B?RTN6c2k0WTBZN1RQRWM5cVhBSk9DaUhtZnVremZVdHZmNURqQzFQdmExbWh1?=
 =?utf-8?B?anpGM3l4YzdiMlBlWlFNMHRERkpUcEdQY3U4NnF3TlR4ZnJpaTZGY1haQm1s?=
 =?utf-8?B?UGp3YkdRdkRheVczSkhiTkpSTjV3ZlVOc3hmSHNxSGRIT0VkK3ZIc3U1RWNv?=
 =?utf-8?B?bk9rY0I4d2VlWU4xTkpDN1ZHc0o3aGVKY0xXaWtzNFVMbXpmcUVaMTFFTVkr?=
 =?utf-8?B?R1JTUHdpUXZ6WTZ0VHBiSGNYQ0IzZnoxVEtteTIzaUwyNkl6bElZUHBHRkp5?=
 =?utf-8?B?VVByQWNWVWN0YmRQelliM3RVNys4M1VNVGt2d1poTEFCaDRRNVo2eTZ2N2pG?=
 =?utf-8?B?OGFKNVR4RWhrMjlvTEh2Zkc3b01XMUJKOXJWL2NjVzFwYzcxWnlNaHJiVFYx?=
 =?utf-8?B?Vkx2RnYya1krSndjWGFES2o3VlM0SXk0VnF3UUxsQitlSWJEcXdpQUJCRTRE?=
 =?utf-8?B?eUZBd01oVkt6T01GU29uVEkzcnl0Yjlvd2Iza0hxai9JRDdPZGhYVTVqSHd5?=
 =?utf-8?B?dWZGNW8zaXdFN3lkUWswcTc4K2lyWFhpWDhINTd6Q0c3WUdvbEdpWHZUbEEw?=
 =?utf-8?B?WmVwNTFrNTVlZG9jaGZzb1I0TG1oOGM5d1Q5c2tPaHg3WmUvN2U0ekV2ajN2?=
 =?utf-8?B?SmplbXNkdXBVRkdBQUt0N2ZsT0M2UERPYllXVGpEeEFzSENJcDB1R2t6Q29Y?=
 =?utf-8?B?SmV0MmZmMUN6ZnRkeFo3N2w0MXBCUDFuQ1AyQWp1dmlIa1Y0UFJGUUZza2Ex?=
 =?utf-8?B?SG5CQkFnd0hsZWRwL0ozdmpwdVk1b0ZNNm5SNXRlam1DeHZwaXFsNG44R2Zw?=
 =?utf-8?B?b0wvYlZlUWh2UGZvUFpDbXhyZzJSS0hLN29kdGNBcUExUmF5Tno1OW9CM01l?=
 =?utf-8?B?K2dCUW5PMHdxTnQ1anM3NVIzOWhJSFhIdkFHYnp1dDZyTlZqU3daTWhaQVNx?=
 =?utf-8?B?cEFTWEMxOHBRemh4TDYva3p3VEZSSThrdE11ZE5JeWxxc0RWQUJ6RW1zbWUz?=
 =?utf-8?B?TFptekF4UTI3ZjFzaHpiRks2TWFlbmt4VERPT0pMa2Vacks4UWk1cHNhL09K?=
 =?utf-8?B?eVlJeHVIc3RnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S1p0ME0xQzNHVkdsQXN1RWRoTncvSU1qSm1FWG9YKzlRL2hGYjJhN1JQMmhh?=
 =?utf-8?B?SzdML1Z1bWdYQjJnKzhjZmJ1NEZSZmdQYmc4TzBVYnNZaVorVXo1b3pPRDZp?=
 =?utf-8?B?alRwRFNyQVJwRTR0R1grcEdyZlhmYlA2UUlTUGxHdlJ0dXJDbjcyUkdVdTgv?=
 =?utf-8?B?cVc5YWlaZmY3Zlc2SHd5bStjWU92WlByV2lMQzBVVFFGN0xtb2c1S3RlbS9x?=
 =?utf-8?B?MnE1RUNOYUJYcEZnVzFFaHozN2hkWVlPYkJFNmh2VG1RZFdUWnppbGhOQnU2?=
 =?utf-8?B?N3BPaXpjaHZOSkJmSFhHTmhHSnllVmlOZXMydWZZNDhrWEJ2Sm90WDNaNmgy?=
 =?utf-8?B?THJIWk1UTFFxWmdKVGtWL2xJYkVKTVhFUEI0ajJJaVdnNEdmenF5SC9MOW9J?=
 =?utf-8?B?dHVGNVdQZ1A2RnYvd2FjQk9DeFQwSUgvSjYwQkJlRWEvc3RsRWZ3Vi9jUzY4?=
 =?utf-8?B?YVh3STg0RXZOSE02cXYwKzF2ZFNhc01qMTJNUFJ2a3RBT1BQTmplN2JGaGMx?=
 =?utf-8?B?RUdoWTdsSFA5bjFEdzdLMzlOQnVnQWk4Rnk4blJWM1ZMdFdzZG9rbUJSVENt?=
 =?utf-8?B?SzFlb2NNbUkrSkZWRWFpUzZPZTJ2eVlxQmNic281ckVjSVVBWHJuWXlaN3RK?=
 =?utf-8?B?bHR4OGtram80cmhISmFqVy8wMUVkdlZlUjdyZVFXdFdROXA0WVlOb05HK2sx?=
 =?utf-8?B?WXgxM2cza1c0WnVWcmd3dFR3OFo1aEtsYVo3clNoR0R3Wk9NUU1PMTFwM0R6?=
 =?utf-8?B?NVNDRnkwMmNOV1hXUlZGTzlHVEFzQXFNcGtSZ3RWNHBPWTVha2JQTHM4RkF0?=
 =?utf-8?B?Ujg2ZENWekVLR1FNeXdNRlYrN3pJZXVlNzdtUEFnLzNKOFZWT1NnSVgrOHcr?=
 =?utf-8?B?NURCVHplNmo2blZyYnFEOTF3YlZiL3R5Q3crUTNmVzN2a1VlZFpuZ21Xb2FE?=
 =?utf-8?B?dnpNaEY3MVR5MHp2RnN3M2ttMkN6RjVTSmp3RzBZU0ZHWHBEdHB4VDlDcm1r?=
 =?utf-8?B?b2xKamx6aHZtVmRZbHVQMDJ2Q1hvb3g1akRNZlA3LzM1QlRXVzZFRHR4WUhY?=
 =?utf-8?B?RkJ2K2pyOVNscU4zQU41cktObFMvQUQyemRWbWlzb2M3Q1N0b2ZDU2pSNWR6?=
 =?utf-8?B?U0EwVTlmV28zdE4zRHEvTnBJOTFuSVd3dVZJd2NTdVhkaVFzU29LRnhEY0dW?=
 =?utf-8?B?SDc5RjVxTEFpSTlkeXlMREZSenlObTNGSkpIMkFVZmhHUE10aEY3Z1RqMlc2?=
 =?utf-8?B?TFJncmlzRDBuaHhzU0l3UXhNeFFNUzNiQTFMekJJSEMxdjFqU2lnN0sxRjZ5?=
 =?utf-8?B?MFhraWJPUHpZc1VVaWFHZ2tHY010ZzV5cUJ5QjdoemQvL1B3RThBakEvR2dQ?=
 =?utf-8?B?ZmJmemp5M3VyaGIxWkxyRGNDWUlrbmJpT2xWZXFKNXhHb0c5RlY1cFpvRFBO?=
 =?utf-8?B?dmVGbXJzZEZvUXpXUXhFcWY1aEptU3E5bGhVS21KMlNpQS9hMG1UOWVzWmp5?=
 =?utf-8?B?S2pLOGlta3hsbEJxV2FkMWJUYkorQWJrbDk5blY3WmlabTdWaGlpYVFrZ1kv?=
 =?utf-8?B?eVZHUm90bkZCMlk0OFZZRlZUV3NZbkdUclBnd3hwSFNvTGNjSE42d2lUODdG?=
 =?utf-8?B?Mjk5cHFid3VrV0F4RFBydGh1aHg2ZktNL3d6cHF1S01VVDhBYXVYQ0xja0JF?=
 =?utf-8?B?SEZMRm5HUzRScFJ4TU5xWThVOVozMjQwR2tvMTdFWTVBKzFzWjZ3UXduWXRE?=
 =?utf-8?B?cElkZzNkd09CVHpKMWJMODNoeTVTQkdmMjIxTVZxb09oakxlR3pzdjhIOUxG?=
 =?utf-8?B?ZHZMektvaStVclFmR2VobXM3ajRGRi9SbkFMM2h6L2tQTWtIVXZSWVVNam4r?=
 =?utf-8?B?M1haL0ZQNG5RMlRud1BOOVlDdzdvU1lrQ1p3aXFnTFdvOFMxbHVyZE51Umcy?=
 =?utf-8?B?c3RQNE9GTndxWHBiSGlOdWVEeVQ1NXpnaE5GcjV1MCs2clF6WDRtUzJQbmRK?=
 =?utf-8?B?ZXc2by94ZjNOSVB1eXF5SHVna3VranVTVmtTV1FrOTM5cU5CTkl5YTZwNU01?=
 =?utf-8?B?VnlzWm1EOURlZ3pPTmVmRTREWHM5dzM5c2htZE1BcVRIa3FOUWE2MFV1c1dE?=
 =?utf-8?B?QzN0eGw2cGczcUdtY1hIK2pZdkN3Z0s5alhNNmIvMUxhYWFGeUdUU0dib0lw?=
 =?utf-8?B?K0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CD1AB43436E8144B45EE44FC5FC24F7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	k55IDamGn7SVvAMcypk+QpelYyNQkfmuZVqBF35xB6Kt44Ai+u6jVjDlXTLc0R1a6hnU6R0cXQA2visaDEO+fgtRKrH+cpF6pJmlX+Da4wYQ2dufrnUqTLxTNZWgCNFe1VezyLrYVajKIOxQZ4nclWcJZv4BKsJWzWcJkKur5Klq/KOy3fhi+vfphSQtQF4f23bPs28bAOHm5ZBT47iMFSWR4hnWpHOh3vqH2J/f+eA1lblh8i7h9kEy0ljCgGFsaWLIqPkLyeawiXNeDxI7jkk89LpxgYCuBBY7pirZVZDnfz2tCYm/OPewvQcFS0VH4hlk+lQ5k3UOEijr0LunYykZlpFW3iat5aOYJuJtiJWsM46au096b2l/iEQ7hilM36w1++L9eNfWnWj+RKoNY8Y7nYm948X4f5p186fyFnpfF2WIsAv7ZQb6yj4ZbS4LHMxn1m0Q/07eguWxEUBQXxZhNwz8hyghmKt/TxJm/H/PrKVU76z7oYueIzTY7jch1au0GinlNBvLrjSiNivVHMfDtIfKkrpazn7RODfraZZDQOUNz58g9mnxLrElD4yPu3/kdW3ewPfEd81iKd2Mh741oYy9X+YJWxePsgGUfMROuoif4Zisu0xkSD1//Glz
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c335acca-56ba-4418-19db-08ddc9b0711a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 06:16:20.5356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OtBjFrsflAiWW8z9L9qTbTaVd8ORpx4zlGKeK2Z94X7aMps1ayuSw5P6rNN5Y/xxgBX6UQhKs1/6NGyz1UoXjdESy4kpcV/SwurLX+J9u1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR04MB8642

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
