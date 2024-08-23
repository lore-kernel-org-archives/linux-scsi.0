Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29B024B4A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 02:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=60.244.123.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724381854; cv=fail; b=Sqeo4I/GlrMClJG9uI4waFLscLM2A9KOC06YuxFLjX+eSzZMbgh+Mn/0g0fqFMt3OJoKP3iHruqWDgy4K50a61SzS+rwp6MLYO60QR0Si1EsQOn0hb9hkwO7Vw1zcry/A1LIKvwLqgF1HsykMhm+XqglWi9QzeFRQyC+zEyNrDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724381854; c=relaxed/simple;
	bh=N4lchmN+bjU8pf07Z73n7uclxZBqQ4+NHu5UOFhz05g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PlLXL144Qtqpp6NoIbpqiPZNxAAaZS/ufNMA9AbITObil2yrEp8t82z61YKEbEsP76Kkmefofj/BAQpg2P0TUuswAeI2QYfl11DDtNBgcxF189iODp3q69rg5pFLmCz2XEpD89UmoWztIRjXQMWJJEDVyYJlKsS5sIrGc1a1VNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=JxR+cQk8; dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b=iyUQ3oMQ; arc=fail smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JxR+cQk8";
	dkim=pass (1024-bit key) header.d=mediateko365.onmicrosoft.com header.i=@mediateko365.onmicrosoft.com header.b="iyUQ3oMQ"
X-UUID: 6a8fc97660fb11ef8593d301e5c8a9c0-20240823
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=N4lchmN+bjU8pf07Z73n7uclxZBqQ4+NHu5UOFhz05g=;
	b=JxR+cQk89Ltp3/yEc+Gc8xF0F36/BwIEs+C5EfFlD2q7WJundM200w7rqXO9gWn/BUE3XZHczUPhiESALjtbG4rmHqQRFoOMYrHM988E2kh4qwbA4NXXiag7/iNxQ5cbWQzIXk9E4qFVJny7v5+NcLgZ7kf6T0UBglg7Pfnmz+s=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:40036109-fe15-48df-9e70-8057c8495281,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:0598ccbe-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|-5,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 6a8fc97660fb11ef8593d301e5c8a9c0-20240823
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 512748883; Fri, 23 Aug 2024 10:57:21 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 22 Aug 2024 19:57:21 -0700
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.237)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 23 Aug 2024 10:57:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c08Jb2Mx9YvZSF7biwMKJ4uanvQV5FOrGLQD2QMW6nhz2r3Ft44sbaPItaSNTnxmCrcqSkwJqDEslHpE9nIGsqwP9k1YnGQg+uLoQMAyMw7Sbp7c9i2oq8hG6gbY2IO6qRBkrZRATaN4vsXVNdsfFKbiDtDknDHi1kq3iarTGIAfUWW63gHyVUFy2Z3fOYk8ilUX5pk+N4NjIo45bTs/+Dx46g5QXkLezy5huVcLP+0Ysj4+BVV8NUWidLjPkWWP/QgoluSB9sQYt+s0hhsH2Rmjd9kOdSz6mJy729EC7t7h+fasePFYsbdFUavj0vZjqRavCzVflFUphw9EmNXXwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4lchmN+bjU8pf07Z73n7uclxZBqQ4+NHu5UOFhz05g=;
 b=jS1HKCL5xD6XS97ezIFnzR/0QPd2hUZnAZunPKR5gf8lThsxHz7YjRI/ktvBE5Gojsqd62HrvCovc6AfDz9fljvnbHCOOHiKEyfRdxqeqWlEYSsiapST/QPK5Kf6tPocMLHMeGASwP7BVrz1UHKOTo5CePcyjG7RJXkMGJW3OW6vfCHJggVnJc0vU2fhEvBEyEfkYsFZrg2Dt6wap3PgWZ//5lQSkKut4/tv/PWGQNVfemyIkSXWYK9/tvbwK3iINV20kA8ehb1bWnxkY4qezrENT+Dhy8znp+snQP7hyqS8L6CfgVte1mLl+Q1tGgARaFi5NfmLkrOfZEBw97lUQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4lchmN+bjU8pf07Z73n7uclxZBqQ4+NHu5UOFhz05g=;
 b=iyUQ3oMQfBqJeDd/PXWdXBLje39lkaVaqiaJPoG5BeyUA5M+6pig6UPXn0OBGccrkQGP7SH0+ym/cbulfHVTSY+yMJsBDCcj3s/6xTA72W9NkIZcPC5BB1eK+rCTnKNFTxtyCBo0k+MXN95smIdz965UCTPoj/Xm+bVkfy/Ux/4=
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com (2603:1096:301:66::6)
 by TYSPR03MB8081.apcprd03.prod.outlook.com (2603:1096:400:470::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Fri, 23 Aug
 2024 02:57:20 +0000
Received: from PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c]) by PSAPR03MB5605.apcprd03.prod.outlook.com
 ([fe80::3945:7dbc:62bd:c31c%7]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 02:57:20 +0000
From: =?utf-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>
To: "bvanassche@acm.org" <bvanassche@acm.org>, "quic_nguyenb@quicinc.com"
	<quic_nguyenb@quicinc.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
CC: "ebiggers@google.com" <ebiggers@google.com>, "ahalaney@redhat.com"
	<ahalaney@redhat.com>, "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
	"beanhuo@micron.com" <beanhuo@micron.com>, "avri.altman@wdc.com"
	<avri.altman@wdc.com>, "linux-scsi@vger.kernel.org"
	<linux-scsi@vger.kernel.org>, "alim.akhtar@samsung.com"
	<alim.akhtar@samsung.com>, "manivannan.sadhasivam@linaro.org"
	<manivannan.sadhasivam@linaro.org>, "minwoo.im@samsung.com"
	<minwoo.im@samsung.com>, "James.Bottomley@HansenPartnership.com"
	<James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Thread-Topic: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
Thread-Index: AQHa8/g1O9xCFCXi4kKybU2KvbfJOrIz76mAgAAqm4CAAA4hgA==
Date: Fri, 23 Aug 2024 02:57:20 +0000
Message-ID: <471e5a037f5fcc996e36b6112dc011731e75b66d.camel@mediatek.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
	 <20240821182923.145631-3-bvanassche@acm.org>
	 <ba9ae5a8-6021-f906-9ce1-d637534ac9cf@quicinc.com>
	 <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
In-Reply-To: <20c1866f-9bb2-406f-a819-74ad936d92d5@acm.org>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5605:EE_|TYSPR03MB8081:EE_
x-ms-office365-filtering-correlation-id: c1bb3d33-ce7b-4117-4736-08dcc31f4e18
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MU5MbXQ0dU81eUxKTCsxdjdGUEtHSWI4eERyOHNUZ1VkaXlZZWZnKzEzYzNP?=
 =?utf-8?B?MnhvYi8yYWw3aGl5TE16ZjVPUXZudlI1TnZaa0pkYk1YdkpxcjVsdktLdG5K?=
 =?utf-8?B?YTU2Ym94a1d2Y1YzMCtqWUt4Y0pDeEFQOTZuNUdsWVdMYjBIZ09DR2g0bjF6?=
 =?utf-8?B?a0NFNVNpWU1MUDAyeGoyZEZoQ0cwQmxoSFFMbG9BRHRiVEt0b2M1QytQajh3?=
 =?utf-8?B?OS85L2haZ2lPRVNKTlpFVGpRc0VsWWkrWlNmT3VHQkx4YmRyUDhaam9OalZo?=
 =?utf-8?B?c1ZoTlFkcnYxcjczd0lQRHkxcDRBUWF5dzhtNmVFS25GNWdnT3FFdSs1Uy90?=
 =?utf-8?B?Zk1aL0NkWGFhdXhrSndpTnJST1A0bzhvYk0zZ3hQc2tQTGFHS1F2d1RhV3dq?=
 =?utf-8?B?bHZQY0F3SGtDbEJObnpZdTQzT2ZIemR1RkE4V0ZkMGZHSWozSS9PazN0WjUr?=
 =?utf-8?B?aStyQ0wveWZrMzUrYkoxOXkwajArUDF1YVBzR2diLzJYWUg4NVZHUnZoaEpE?=
 =?utf-8?B?WlVQclZ4UU9MdWVaRURCOEVoblV6L0xNN2pUOXNqbDhvZ00welp2WGc0NTFa?=
 =?utf-8?B?QVBRKzhia1JReHcxcjFvWnU0S3VIbkpiU0MwNzdIcG0rV0UyMUNwLzNQeWF2?=
 =?utf-8?B?QStsc1pmUGlMK2RLaEQ2YjAza1B4bGZBVDhZYko3MllNdUlzdmhjTzV3TXd3?=
 =?utf-8?B?ZXJEMG43UGw0TjJZaEN3RjBvdDlMMjlwMlFRcGpBUEhxYkRXRElUVXFHeThn?=
 =?utf-8?B?dWlkc0ZmeWhEaFdXM0grcnlwb2huTDlCQ1FxUVBpaHJsYUozb2ZWdGgyTXFT?=
 =?utf-8?B?enMvNWNyWDdYUWtsbzFQNEQxMmJqL3prY3R4SVZmTDRBSlhZYVF3bFg2cWdx?=
 =?utf-8?B?WDdaVkJwMnB6dUg2dHkxbEpzeDhqU281a1lmQlNFOW9hVmNXMjB6dEo1YVhY?=
 =?utf-8?B?Tngzd080VE9XMjBrcjlyTzFldDFkbDE5WWpkWjZaZmhtWnB1aEhsQXJBTkNy?=
 =?utf-8?B?WXBna3dTdVJhanpRbmZzZGRUTGVrZHhHdmRFdGR3Qlk2OFlIcTNKaXNiaEgx?=
 =?utf-8?B?SVQ4aG1EUFZUcUJBOFd1L2k0U3NuMSs1cHIvYWpORWc4aC8xV3YySXBUQTVi?=
 =?utf-8?B?UWFzWTVYMUlIakYwekJtMDhmSW5tcXluN2RQd1g0QkJRNStmSjF1Wm9GbnJp?=
 =?utf-8?B?YkZjZXl5M1M4RXN4QWI5RENjalpvUHBUMnJxSTZFd1ZKZGRmNmhyTThLQXpN?=
 =?utf-8?B?UFl3eUorOUpUcUh0M01neStmMkNKMHUySzRtTmNjcmpOenR4S012M01ORWZM?=
 =?utf-8?B?UUwwUG9QZ21aTkNIL1EzaUF3Y3laeDZsd3F1dUx1YUY4ZHpNUEwzTERXYTlD?=
 =?utf-8?B?aWZPa1ZvSFZXeFNaS1hqQWNvbGkzNHhFcUkraWIwS09Bak5CUmgvWmhobmNU?=
 =?utf-8?B?QXRVajh6Rjhta3A1YTBOL0lGU1pOVU1tRXUvK3JhWUZZMDYrald1alhhWlBW?=
 =?utf-8?B?eXc1YTMxTHoxWXArTXRIRHBTQTFLSjBTWExPQXhKd1ljVklYdXVzY1R0YTl3?=
 =?utf-8?B?WU9sNk5RN3NGZ0xJUmlDRUFUcU9NZkVKZE1ONXk5Wi90SFBZLzBwNlZ6SldL?=
 =?utf-8?B?ZU56dkpwbFhsekhhSThMMk0vYUQzSTRSck5ETTd3UG1XOWprNStDc1laQW12?=
 =?utf-8?B?MnJMNUNYb3YyNE9qQldtUmRpTTZ4VGFrMWl4RVNSQ1RFS1FUOUh2UXhhY01S?=
 =?utf-8?B?TW5NVU5BQWtoTjZGRTBrT01QaDVTL3NDT0d4M0NHZCtJTkZDZHI1SWQwekpR?=
 =?utf-8?B?UURSQ1BkdFpGUnFvbDNwREhXbnovM3FqeFlVWUY4NlFrSjNQMDlTMWVRYWd0?=
 =?utf-8?B?L2h3YldYWFNIdmhqNjV0RjFmUzMxSEdNVTJIVjZDSFVWbmc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5605.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnpVUVhkUnNCSmQraU96S214blQ2b0pxNFV3VUZHNjRmU3B4SnhXQVltQXBC?=
 =?utf-8?B?cDAyQzEyZTFBcE01NkgzWFp1aDBidExYY3RXb2tKMjF0c3A5dFE1Nnd0N08z?=
 =?utf-8?B?RmI2UHE2aERtUjFiWmxxTHphWHFIZVNBYndGckt6RDZBRjJabzZnblYxakxV?=
 =?utf-8?B?NHdlTmp3Wi8rV2dLRDhBbERKZytNbWFzY3E0MU9uQmczQSt4ajdFSVJKR2Rt?=
 =?utf-8?B?WEQvYi9jbmdjeEFVVVZMZ0xEenozK2FtZHVGVGFqbk1VUW5weWQwUnZGenMw?=
 =?utf-8?B?VnU2YWlBQWJTY2NaVXo2NHVHMVRXc1ZYZStYU3Y5L0Z3aDhwWUZTSTM4QzJC?=
 =?utf-8?B?SC9WdWc1Z0F3UTRoVkZUYTNoVWpod3d3emhERE94d2lkNllBVzMxV2VBNE9M?=
 =?utf-8?B?a2lRRjhlWko5a2xFN01Ea09lNmtFNDVXRUpONGh4cEdSbytuTEp5dnhoOGxR?=
 =?utf-8?B?cmc3UDFjckYvU0lYb1VuRUgvRjFBcVFVNHZ0ZlEyOEp0VzdZS00ydWFwSTY5?=
 =?utf-8?B?eGlWTUlDc3NJY1ZrQmsxRUNMbUl4OUhBZTZrb3RSWTJhV2dzeERhMTUyZ21k?=
 =?utf-8?B?MGk0SUxlU2k5bllxaVBZTVJxRVBXVFpmY1ZTUnFPSkVYS01YYjFQWlFESzZW?=
 =?utf-8?B?UnNZWVowN1NKaXRvc0lmTWJ6Tm1WanRUUk9yeFRHbDRiazQraUxRcFNJTlZZ?=
 =?utf-8?B?UVRmcERnVVE0U0phMjlxWXg0Y3o5N2NmaVF3Nk1VR05KQlordS9GTGxSS0RS?=
 =?utf-8?B?eGFWWUFnMk4rYTZ3dkcwTmx6V3F1QlcwRFZETXhJYytBVjduZGhISmJObzZl?=
 =?utf-8?B?czVwYUdsN2ZNVWNObkhabGlhUDdxUHB0RVhPYnh0WDMrTUVreGRFMzJmd2hi?=
 =?utf-8?B?VGRNSnAzNzhSLzRSdU1mVFhWdzdsRmU5YlR1dUxSdHRuUlUvNjFpZCtEblpE?=
 =?utf-8?B?dGlIMWRZMkg5dFFER3R2TnV2UHhUT1NrdEt2TC9OOHBVbjAzSVpCcGgrZ2pN?=
 =?utf-8?B?OS93R2hIb1QrQmt6N01NejJkSXI0aENiTnlzazVYK2ZGclhYZStUOTlnbmo0?=
 =?utf-8?B?L21Vc2Nna2Y1V200U2xDczhyQWRqZXhBN0tWVTEwVE9XYkRlVU9BZUc2OWsr?=
 =?utf-8?B?NTJqZjVNNGJaaVpYL0pXMUlGMTFJcDZJdnVQNEN0Ykk1Rm5URTNJNTZuT0s1?=
 =?utf-8?B?ZUVkbVJEMFRQQzhxSlovTkI0MFhadHhLMEtQaldYOUNqaXhWU285OXhheUVw?=
 =?utf-8?B?SldaL0pLZGhKdkpsY1cxR0NadG9UMGJBdG9KSHY2U0o1UnNSRE4xMTY5Ymty?=
 =?utf-8?B?ZWlGV2xJaUdQYnY3Zzk3TU5YQlo0dVYzNlhCRzhwbmluMmVNT0RFQXd2VFRC?=
 =?utf-8?B?TzRVcmZsT0ppNW84SXBOVCtpeGQ4M2RjVy9ZN2oyZnVkdHMxZVdHLzdKd2xO?=
 =?utf-8?B?T2xZcXAzcGhLMCtpM1lQYjFiOFBoUE1nSmVXZmF2Z3UrMlJ1WTEyamRnY2VT?=
 =?utf-8?B?RzNvTlpaaXNWQTFtVXdUZmY1d3dNVVlWS0FyOEJPSkg3QnZXclR3Y0dXSktR?=
 =?utf-8?B?UUhCbmVKS21MT2RPNGdKOVAraGt6WXBITzhjdC9Xb3pZSW9JbHFPeXg5V1dJ?=
 =?utf-8?B?eXBRSVUvL2VqT1hKN2pOSEpFa1Q1SkM5M01SQWoxK3VXN2lrSGtvbmdSUjFs?=
 =?utf-8?B?cWhERXQwT3dIYTRLNnVMdnNQS1cxWkpXOWgxV05FcFdaZWt6ZmI2b3hoN3NJ?=
 =?utf-8?B?cWt2am9FVzdXSnVYMFkxNTJOOERZMU5tYmRaMjZ6SUpZOGM3RzE2R3BEM2J6?=
 =?utf-8?B?bmJBOGliano1R2s3NHNnNzRLaTVST0xNRWR4bWRxbG1hRitQQklxblgzK3lZ?=
 =?utf-8?B?MElDUFRHVHo5S0QrY0MwakJIZmdiZ1BScFBZdFJYNnBHcG53Q2xrQlc0dDZX?=
 =?utf-8?B?OXZqNDd2UVErN2hsTnIvakw5Y25Pb21sbDZDa3BQaWFrK3g3UlFUWkpsN2Y1?=
 =?utf-8?B?MFBTYUNrRE8ybm9IbWRJUkJqZWpheWRONVAzR2FXbTRSSXp2Q1pLcHJMK2xL?=
 =?utf-8?B?SktoVUlkK1hHeDhLcGVwSEt1SDhVY3pYdzVsRmdaSXRpbDV3cHdQZEhCMlpm?=
 =?utf-8?B?aEw2cysvZ1V1czhaK2p5ajU2TDRkVkptVmIxNDA1d29BWDFZQUdOM1gxR05S?=
 =?utf-8?B?anc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F11A0E8B39B9E4C97A60E1C8079C92C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5605.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1bb3d33-ce7b-4117-4736-08dcc31f4e18
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2024 02:57:20.1263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0QeyRL6URs5JimfhNQJUzBM5tw1z06DoWXidXTLaJJf9QyKiQp3bKNB6mFXAHZVo7Gkp1lVIU9qPosP8BPgvOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR03MB8081
X-MTK: N

T24gVGh1LCAyMDI0LTA4LTIyIGF0IDE5OjA2IC0wNzAwLCBCYXJ0IFZhbiBBc3NjaGUgd3JvdGU6
DQo+ICAJIA0KPiBFeHRlcm5hbCBlbWFpbCA6IFBsZWFzZSBkbyBub3QgY2xpY2sgbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bnRpbA0KPiB5b3UgaGF2ZSB2ZXJpZmllZCB0aGUgc2VuZGVyIG9y
IHRoZSBjb250ZW50Lg0KPiAgT24gOC8yMi8yNCA0OjM0IFBNLCBCYW8gRC4gTmd1eWVuIHdyb3Rl
Og0KPiA+IExldCdzIHNheSB5b3UgYXJlIHNlbmRpbmcgYSB1ZnNoY2RfdWljX3B3cl9jdHJsKCkg
Y29tbWFuZC4gWW91IHdpbGwNCj4gZ2V0IA0KPiA+IDIgdWljIGNvbXBsZXRpb24gaW50ZXJydXB0
czoNCj4gPiBbMV0gdWZzaGNkX3VpY19jbWRfY29tcGwoKSBpcyBjYWxsZWQgZm9yIHRoZSBmaXJz
dCBpbnRlcnJ1cHQgd2hpY2ggDQo+ID4gaGFwcGVucyB0byBiZSBVRlNIQ0RfVUlDX1BXUl9NQVNL
IG9ubHkuIEF0IHRoZSBlbmQgb2YgdGhlIA0KPiA+IHVmc2hjZF91aWNfcHdyX2N0cmwoKSwgeW91
IHdvdWxkIHNldCB0aGUgaGJhLT5hY3RpdmVfdWljX2NtZCB0bw0KPiBOVUxMLg0KPiANCj4gVGhh
dCdzIG5vdCBjb3JyZWN0LiB1ZnNoY2RfdWljX3B3cl9jdHJsKCkgb25seSBjbGVhcnMNCj4gaGJh
LT5hY3RpdmVfdWljX2NtZCBhZnRlciB0aGUgcG93ZXIgbW9kZSBjaGFuZ2UgaW50ZXJydXB0IGhh
cyBiZWVuDQo+IHByb2Nlc3NlZC4NCj4gDQo+ID4gWzJdVGhlIHNlY29uZCB1aWMgY29tcGxldGlv
biBpbnRlcnJ1cHQgZm9yIFVJQ19DT01NQU5EX0NPTVAgaXMNCj4gZGVsYXllZC4NCj4gPiBUaGlz
IGludGVycnVwdCBpcyBuZXdseSBpbnRyb2R1Y2VkIGJ5IHRoaXMgcGF0Y2guDQo+IA0KPiBJZiBV
SUNfQ09NTUFORF9DT01QTCBpcyBkZWxpdmVyZWQgYWZ0ZXIgVUZTSENEX1VJQ19QV1JfTUFTSyB0
aGVuIHRoZQ0KPiBVSUNfQ09NTUFORF9DT01QTCBpbnRlcnJ1cHQgd2lsbCBiZSBpZ25vcmVkIGJl
Y2F1c2UgaGJhLQ0KPiA+YWN0aXZlX3VpY19jbWQNCj4gaXMgY2xlYXJlZCBieSB1ZnNoY2RfdWlj
X3B3cl9jdHJsKCkgYWZ0ZXIgaXQgaGFzIHByb2Nlc3NlZCB0aGUNCj4gcG93ZXIgbW9kZSBjaGFu
Z2UgaW50ZXJydXB0Lg0KPiANCj4gPiBOb3cgbGV0J3Mgc2F5IHlvdSBoYXZlIGEgbmV3IFVJQyBj
b21tYW5kIGNvbWluZyB2aWEgDQo+ID4gdWZzaGNkX3NlbmRfdWljX2NtZCgpLiBUaGUgdWZzaGNk
X2Rpc3BhdGNoX3VpY19jbWQoKSB3aWxsIHVwZGF0ZQ0KPiB5b3VyIA0KPiA+IGhiYS0+YWN0aXZl
X3VpY19jbWQgdG8gdGhlIG5ldyB1aWNfY21kLg0KPiANCj4gVUlDIGNvbW1hbmQgcHJvY2Vzc2lu
ZyBpcyBzZXJpYWxpemVkIGJ5IGhiYS0+dWljX2NtZF9tdXRleC4gSGVuY2UNCj4gb25seQ0KPiBv
bmUgVUlDIGNvbW1hbmQgaXMgcHJvY2Vzc2VkIGF0IGFueSBnaXZlbiB0aW1lLg0KPiANCj4gRG9l
cyB0aGlzIGFkZHJlc3MgeW91ciBjb25jZXJucz8NCj4gDQo+IFRoYW5rcywNCj4gDQo+IEJhcnQu
DQoNCkhpIEJhcnQsDQoNCllvdSBhc3N1bWUgdGhhdCB0aGUgZm9sbG93aW5nIHN0ZXBzIGFyZSBl
eGVjdXRlZCBpbiBzZXF1ZW5jZS4NCihUaGVyZWFkIEEpIHNlbmQgdWZzaGNkX3VpY19wd3JfY3Ry
bA0KKElTUikgVUlDX1BPV0VSX01PREUgQQ0KCWNsZWFyIGhhYi0+YWN0aXZlX3VpY19jbWQNCihJ
U1IpIFVJQ19DT01NQU5EX0NPTVBMIEEgKHN0ZXAgQSkNCglkbyBub3RoaW5nDQooVGhyZWFkIEIp
IHVmc2hjZF9zZW5kX3VpY19jbWQgc2V0IGhhYi0+YWN0aXZlX3VpY19jbWQgKHN0ZXAgQikNCihJ
U1IpIFVJQ19DT01NQU5EX0NPTVBMIEINCgljb21wbHRlIHRocmVhZCBCJ3MgY21kDQoNCkJ1dCBh
Y3R1YWxseSBzdGVwIEEgSVNSIG1heSBjb21lIGFmdGVyIHN0ZXAgQiBhbmQgY2F1c2UgZXJyb3Iu
DQoNCihUaGVyZWFkIEEpIHNlbmQgdWZzaGNkX3VpY19wd3JfY3RybA0KKElTUikgVUlDX1BPV0VS
X01PREUgQQ0KCWNsZWFyIGhhYi0+YWN0aXZlX3VpY19jbWQNCihUaHJlYWQgQikgdWZzaGNkX3Nl
bmRfdWljX2NtZCBzZXQgaGFiLT5hY3RpdmVfdWljX2NtZCAoc3RlcCBCKQ0KKElTUikgVUlDX0NP
TU1BTkRfQ09NUEwgQSAoc3RlcCBBKQ0KCWNvbXBsZXRlIFRocmVhZCBBIGNtZAkNCg0KDQpUaGFu
a3MuDQpQZXRlcg0KDQoNCg0K
