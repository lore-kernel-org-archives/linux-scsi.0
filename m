Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA3633555E
	for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 06:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.141
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765954546; cv=fail; b=F6ygtlcIrGuxWvaNnKHQu3b2NHo259ePXKBGA5jCyKLstedoSzSOqYeC1HhGw/6e9v6AjdYTDnlyZTXRa6bU/oT9nXd40k1DYHoGak4sWKjqputguluKSyW/ljaPlUvGJbw8lCAUfHRQ1GFHGGaBACSWl/27LzmNA2bOArD3hYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765954546; c=relaxed/simple;
	bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=seMTx1KZWCfr2zAPImlIz99GGA+WHzDxg7MBixgw9fwl7b8lVjbF9fF/iRVSAc2rIAHh102pnCI+n6GYhJRb4W/aOg/9Flf/yV+kvdMS/HoRl0Jml0mdiYp6imSzhFN9SyACdoSmwQ337qVOt5uRPeOMmDqcBHTLqVtl/r/O22k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=PU17HPqP; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=mEBxjua1; arc=fail smtp.client-ip=216.71.153.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="PU17HPqP";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="mEBxjua1"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1765954543; x=1797490543;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
  b=PU17HPqPPHLwmx+TPc8n6Owoxb9SYyGSBo1BaOhHSSLjmkZ7PF0Xj9mH
   6CVVJsbIOh3cXqx++R+y+RX2kSIEWb0BZBXMS+8rztR/UsjoZR8AS5e0G
   K70FapLm7wA8YDg3dyDq3w3AptOBwcpJkpoi99Ux9PzoPl9EbKHSKyWm2
   ZWh/cWFCvUZr80dXJDdasWoGBZkf9SJEjmqHv1zrCyYEbpGbu8vxJb2CG
   +cSvbojYwAFaA4edmPO2FSagd8tx3An6CZcc9wTxV54KbQFtXoK+G9Li9
   Jbjb/XrNfQDyymM4WcO3pmVCI0N0QD3b/bHE64UWGTce6EvEhK+AUAbiJ
   g==;
X-CSE-ConnectionGUID: xjovt5lBRAiDUSfQx1Kr5A==
X-CSE-MsgGUID: avVDx+OKTq276NJjDZ7Rmw==
X-IronPort-AV: E=Sophos;i="6.21,155,1763395200"; 
   d="scan'208";a="138039030"
Received: from mail-westcentralusazon11013057.outbound.protection.outlook.com (HELO CY3PR05CU001.outbound.protection.outlook.com) ([40.93.201.57])
  by ob1.hgst.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Dec 2025 14:55:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cyboLjIIKPOSUoZt5Vc2YqHo6/86ubmRWzi00PkjUQOJVlV3YFkVQ9o1DAfRk36IFsAwMuPDKRoqoaiz2HQVVs9Pg30F/y0T4xSngkzcTkCH6E8CAx1Pv+howAnHmQDx4KiFJFY3BfHgcG2g0ejKURB+1MEyCipptTqM6kzZ3IrbwUM9ecA4EKRzNMLDFScshQqkRdao2HNJucTFWTEbTTG6o8SoynR/4joar2Pwexh5iWhIHnukiQ/0jg+BZId9ufkGR5J9HFjJ37LV0m1slx8IlHkznWH3xKDowsj3pAQPf8k9KWdxm6dDrcXjswhE6FeUr+e+AHYnTpteN3Ke2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=k5qkKYRzJT7LeF2uBbYfLghL5H9hBZ0Ma9Q6JhjVyGGlyb7Ks52AxD/arUgMEkKnEV3DcKRg8o7cRigX605NwXqpV0JWxl1ToqGUl1lda56GZZMAf3Po3UOf3psh/fGSWWkiNOe4+fvRo5gFiBV2ovdUPJIRgjn/MbQRIwkY5cfXZ5j1XdU1G18YjK2aJntvsdlNZeta0E0x2t/Myhf80pmyBhL0E26xFUOCHQUsivvqeNEwGoRWcZ5gKXnh0f+wFcvSfsifaTd9lTWPUPUVocTy4dAwzFIvBoJngapP0krKX9600d92L3r/ETr8mBwyvh6lbv5CRSipDsADEIbyzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+z6ql9M5JhawzkmfcJJBxApS2D5ls0dv54BOWw8ja8=;
 b=mEBxjua1xlKVkPewgv1XCFAwk+8W7+4gBu8Pmoq7C2tD2Q2qvMiCHOIldWvjVn83/RMR8ky87siWRJXdCuw4RFwkS6MkqxcEGhCVHY7OI9ofKuGHHpl5+jfBUlaBjPdB27aczBNRHt2KMbkvuInPr/0xIv4AoPo0J8nuclUQslw=
Received: from LV8PR04MB8984.namprd04.prod.outlook.com (2603:10b6:408:18b::13)
 by CH2PR04MB6934.namprd04.prod.outlook.com (2603:10b6:610:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 06:55:33 +0000
Received: from LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8]) by LV8PR04MB8984.namprd04.prod.outlook.com
 ([fe80::9ba6:7273:90bc:53a8%5]) with mapi id 15.20.9434.001; Wed, 17 Dec 2025
 06:55:33 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Damien Le Moal
	<dlemoal@kernel.org>, Himanshu Madhani <himanshu.madhani@oracle.com>, "James
 E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 1/5] scsi: sd: Move the sd_remove() function definition
Thread-Topic: [PATCH v4 1/5] scsi: sd: Move the sd_remove() function
 definition
Thread-Index: AQHcbtAJI1I45IGKr0uMONOPQk+k37UlZqUA
Date: Wed, 17 Dec 2025 06:55:32 +0000
Message-ID: <21db3893-304f-4aca-b949-42253e738821@wdc.com>
References: <20251216210719.57256-1-bvanassche@acm.org>
 <20251216210719.57256-2-bvanassche@acm.org>
In-Reply-To: <20251216210719.57256-2-bvanassche@acm.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR04MB8984:EE_|CH2PR04MB6934:EE_
x-ms-office365-filtering-correlation-id: 9ddf567b-f79d-4ccb-af8a-08de3d394602
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|19092799006|376014|366016|10070799003|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eTNlS1VOYW1KK0lwOENPbHRld3ZQT1dERXRCcjFBVUdVd1hEOCtSTW1MZGR6?=
 =?utf-8?B?V3V3YzBjckQrM1RMRk9xTlZsQkZPM1ZKZ3V3cXZhdk9FcXZsSVIwNFRlK25n?=
 =?utf-8?B?dHE1c2haeHRFaVFUOEZmNnVMNkxvZkJFcWJCcFUzbU1BblVGSjNsQUtxeWZs?=
 =?utf-8?B?aFlYMGZ3WHk5QStXbmhVUWJiVHNoVTV6WW5GYVNMNWRQRjVsRjlMRTVOUEFW?=
 =?utf-8?B?aWhYME9GNDYwSG9yNy9pcjZaSGpES0ppckdnY3ZzZXU2cFRpY2VmQUhvWjNN?=
 =?utf-8?B?UmhQMDVhMjZub3VVYzJFNm5uOTBJWnJtYTh3NXNtTXdSZmJSamdZbkVmS3hE?=
 =?utf-8?B?bkNzTmEzUHJQZkplcjNqdklPclBWVStEUy8xb0kyMzdyWnRsOGlGNzhlOVlQ?=
 =?utf-8?B?Q0d4eHBSSHB2dDNNNTk0MUt0VTRRUGI2ZFZOVnIxOXVIOGEvVms4MlVFWWJ2?=
 =?utf-8?B?elFUYmdwSUxtVDBINWMwYS9oTjZ1NTJ1UHVuUGJuTVZTV0hHWmNjNFFxVVFq?=
 =?utf-8?B?dlcxN1JDY3dsalJBbmd2VUllY0VmNVRJbis3aldhWU1rb3EyQlFhckJ2ckpB?=
 =?utf-8?B?LzRxT1ljNTZWbklUZVUxZ3Z6djFKbTRGS05vdmRHVHluQUszUXFwWDMvd0g5?=
 =?utf-8?B?dWpBa1NzSEUvYkt3N0J4VlZGTE1tYkQ1OExLZ0xyRVdmeXFoUWJrMVVnSGpO?=
 =?utf-8?B?aHRNS2U3T1c3VjIxRmRuTDI1QXFUaTJuQWhqRUJkdXZpeW9ZMXd0elZNOWZm?=
 =?utf-8?B?Z2ppVjlna3hmU1MwUzRnYWMwQXF5RVV5d0NkOEljL1lLYnBJRXhGQW92YnZC?=
 =?utf-8?B?WFJCWnhBckxraWJmd0pqQVlXelo0UzRsbjdLREIvU3JwU21tUXQ5U1NkZUxh?=
 =?utf-8?B?RmlwbytWK1dYd1ZuYUFtSnBhNDIySnZKRUswOWkrL1UvMGFBVkxNaUR4L1FP?=
 =?utf-8?B?RE5mTnYrNGpWT0k0S1V3Z3ZoU21ZbG85cjd2V0xVRlR0THMrZ01HcmVvNkYw?=
 =?utf-8?B?RWVweW9qSkZtYkhkKzVydkxNTXFJSWhTYmNjcUtkWGthcW1hSVVubHIyTUsw?=
 =?utf-8?B?YVNUdTV1RlFvaDB3bE5INC9TUGpiU0tnOXd2RDRIR3hKRklIaDZtS05aSjgx?=
 =?utf-8?B?NUxsN2tObmZlclJLYXFUZW1nR2c3UVVEN3YxNjNxL1YyUkk2Z1FWb3psaHBk?=
 =?utf-8?B?eDlKWEt0NVdtcXJqWlpIZ2VkNHBBYzhKbG5RN2ZsMURMUzZ4eVRXd3NNY0xv?=
 =?utf-8?B?RXhyRjFBakQvNEhSWEExUStRdTRvdmdxWlpFc3h0VzNUNFIrVFdwMm1yMlR0?=
 =?utf-8?B?amRTcFpYeHZMNUpuZlErRllZZDl2L090WFcwL0NWakhrYUJ1MVVJNmxwN2sw?=
 =?utf-8?B?RkVhdG9rK21qK20rUnRzMjVHeDIwdlI4bm5SdTN6N1pvQmJ2alAycVZ0ZDBm?=
 =?utf-8?B?eWlKeFUxQ2RLS1RsWkw3ZDBkd1dYSVRDeG9vWkhFcGVxRUhQU3c1Vkl3dEFX?=
 =?utf-8?B?NDFiSnVIdE1MZ2NvV0xMR0tPM1Y1MnJ4RXJKV25CZ1VmUXdtQnRsZ3RUVlVV?=
 =?utf-8?B?b3lIb2JGU2Rxc0kxbnkxVUF0NjFScFhXTFErdnllcU5FN3NrTWkzUGxOMU5J?=
 =?utf-8?B?MjNPaHpRVDhKeG1kN1ZxeWdXeERVQmlWUDAxR2JnTk0xeVdkV2NqS3ZIR2VR?=
 =?utf-8?B?QlQrdm96c0NwSkFhY25XWHczeStpdTJwdkYxN1ZOaVJyTVJzNnZKWTVQTXQr?=
 =?utf-8?B?bnNWMW9BWkhSQVY1eXFuZGIwMlJhcDA4VTNVcFJYMGF3b0E1aiswV2gwczQy?=
 =?utf-8?B?VmJVY2pmalhJRDFmaWc4U3lUUG5FS3dxbnlEV2lsNStMeVlueTYxSm9lZ0hO?=
 =?utf-8?B?ZTczdXQrVGxNNXhPNVo2MXRXRjNXNVE4L3VBN0JQd1U5bjJhRENIOFNpemE3?=
 =?utf-8?B?MXYvL2w4ZldBZElGMUcrUWRXTmt3ZEQ2VkladXI0UWw5ZGpHYmNYbW4yVTVN?=
 =?utf-8?B?L2dTeVlESGxzY2IyMHRuMmFyeDMwSVpJaW42ZG5oSmN0MWtkS3hZOWNoU3lq?=
 =?utf-8?Q?QiB9BC?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR04MB8984.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(19092799006)(376014)(366016)(10070799003)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dzF2SzBOcmZCaUhuNVl0RGI5UVVybEs5MGY0a2F2R1JLU0VXaEROOHM5azE4?=
 =?utf-8?B?WEU1S3Rla2s4SmwxSzlhN3Awb1ZrYjRSYmZxTHBUckQvRDJFTWhYUEFKUlRS?=
 =?utf-8?B?R0JHVEsxMUtuVnJLbkVWL2JVVFJWZ2owUHlzL2tIWjNnZXZhR3g4SUdVTWVZ?=
 =?utf-8?B?TUZNUExoWGFBeGVnL2U5ZHVvSGpmeGY3Ync4TG9nWUR3MTI1UnBDazIwbUZu?=
 =?utf-8?B?MkEwVlo2SUxWUXk0QjcyVmN6SEFZNFJIYm4wdGtIelRrSHVZM2JwYjhKTUZ0?=
 =?utf-8?B?Qlg4WVQxRVp2dU1ET2JINm9NeFhZUkNlTjVzdkswaUpDSzBhYXMyemZ2V25G?=
 =?utf-8?B?YU5teHJQejdrdkQzdC9adTlha3E0ZXRCaVJ0b0tPR3hEY1JyUkV0dmFMTkpR?=
 =?utf-8?B?VUdXRGxpR0pUeUpHZUJRRWJhSU5Ham5ITDU0RkFDWFdZMW1MUmZleDBieVhj?=
 =?utf-8?B?MmhuTkRQZnhwN0xMWFIyWEN4L1RJd3VNbXppQTJOZEZTaStvWGpTK2xzMnBy?=
 =?utf-8?B?WXE3RTJ5dm9Rc2xSQ3kvSUlQRWQ2bkJiNVc0RUNUTTVZOWpQcGw3bG42dVlC?=
 =?utf-8?B?T1AvNmdGcjVpNnlhL0cyaTliWkxjbHZGNzFuWG40NXVsclNldjNaeVJCQU10?=
 =?utf-8?B?QjA1SGVyUHNxMEtpaFArU3VTNDVQMDA4cWNXNUsvNklIMmR4VHQ3WUpLNHZ3?=
 =?utf-8?B?VGZKMC9UeDVNNGd0V1d2T2FGUmpGdTlUUXNWbUlGMEtiYmRZanFzK0Z0RkZk?=
 =?utf-8?B?ZEdEZlBrSnlFY3VUQklnaW9nRGhVYnpXVjBJWjhkMGVQeTRUN3IrejFHZ1cx?=
 =?utf-8?B?NDVtc20vZ0o2NHhGc1RzeEdUbEtXZGJQb0xyYlVocnZLbFkxdjRCZDZGT0dr?=
 =?utf-8?B?RGx0emVBTG1Wd3Z5MG0zdFFERERIeUpjdjNMZHNSQnNFMnFTYlN2a0ZMMXJu?=
 =?utf-8?B?MU1SaGZremVwKzcrQlBxeHBZTm5FdVpvZHR3YVVlV3gyaTY5YXVRQmM3K0R1?=
 =?utf-8?B?Y3liSnRacmZUSjZHNDI4QlYrUGNBVW52QjFCR2gvS2dQeW1FUllMYXE0WnM0?=
 =?utf-8?B?dE42VVFtUlZTNERkOC9PUUVzeWNFQytsaDNjSm1pN3h1Vkx6Q0VaL09JbGg4?=
 =?utf-8?B?OHhlNFJWQ2E3ZnZVb1ZubEZUbE9OanlGMWc0NnY0TEdlLzh5RThGUlFObjNV?=
 =?utf-8?B?WFFTRTY4aHdJLzRBNFhnYmZ4a2cxUVN6amtXOVpheWYzcTNOeUR3cGt5Yncv?=
 =?utf-8?B?dysxYlNqV09iME9XeGxJM2JrQ3ljM1lPUjIvRTJCYVUvUjl2SGhsdUtPQnZV?=
 =?utf-8?B?Smw1UUk4a1RrM01FZjZyekpxUWFIVGtVZ2VZbW04UmMzMXA5YlR4VFZPdEhM?=
 =?utf-8?B?WmxaMWxUVktCT2w4T3AxM2EvUCtFQ3VaUXJCK1pCSWswTXdCN2FkSCtoNGdZ?=
 =?utf-8?B?OU9WNzdYN3FXOGtrd01ET0kyYmRmMDR4djdieWNML1hrYlc2VGdZV0N4U2FU?=
 =?utf-8?B?ejFmdDZ2YXpXZEw5YllKOVR5blN2Y2Zpait3b1RiTkd3UnJrZU9rN0Y3TytN?=
 =?utf-8?B?aThlRlNWMENUaktVN0Z2Q2hqekswK2llKzFxWmJ2MnVJWW1tcFZBZUwrRXc5?=
 =?utf-8?B?dHJiSFBGUm1JajQxcXN0U2xIUTc1WHRDS0hzNUlTWk93SE9nUnRwYnBGdHFW?=
 =?utf-8?B?OGhkYmJ5TTFHcmE1TSszajdGZnVFWDFFVHZQeWthczV3YWJHbjIwK05VSWxr?=
 =?utf-8?B?SVYwbXFWd3ljL0JMd3dxYm1hVW1qcDdPQXI5ME9ObUttbmVjNXlkVHZ5Q1ZQ?=
 =?utf-8?B?SFBwMGFXT08xU0JNWHhTT1JOWWhpaGhqY3RkbU9UTytZcGdYY1lzck9ZUFJB?=
 =?utf-8?B?bis1SkZ6S1gxL1RxOGFKRTBpZmNUMDFzZzM0YXBWWDdVc0xHc3dueTNUdjVs?=
 =?utf-8?B?dUx4RGhyck4xQms3SWRYd2lvc1N1STUyVGRUWXFKWTNLa3ZTbHgvbXZYZWlZ?=
 =?utf-8?B?cEdzZVRqVlB4UnhxaVAydloyOVJWb3dIRC9PdUFNcEJpS2FtWnRSaWxPd1lo?=
 =?utf-8?B?Z3RBK0R6VXNSTWxWeGNMWmVGaGJJeVpMOXdHcm1yYTVnVjBLMk9ZRVNZdkhG?=
 =?utf-8?B?Q0l1Q2dwTEIrakJXMTZuVFhhUlM4dDVmb0oyYS9mWGp1SHc1YytSYWFqZEFy?=
 =?utf-8?B?NGpkY2hOSFpqU3BQWTBUOUJoSk1LTGZEVGxKQ3NERHh0V0tLQlZob2hEb0dT?=
 =?utf-8?B?c1hwTFlIdjRjM3hURElKVW5iK2VBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <278E13669C836542BED5359E4A6B6800@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xJPF6GIn01UXtoEh1nJCyQjBqIvsOtxTlvweon0h6lqP0Yzg0XIl4RvAyl/R0wRLEMRTNSNZXfcW0aHf1UVynQIZHylBDYvUjtgGq8SkvzZSKO6zsuEw593VNEaXU9xlSdsiE0mnDm/q0NRjynmnIEvhOYTFBMDHWG+yOCyojigZqL80eNmdYvkfq7UGW+IenyPJ6DrN/dre3nMXquWUJSfqaHDnLuxjYkkjxTlBKWa49KTVKLjpFBmBfSwPW0q3LOyjmF76b6xFD/2DQJgXQ5nRHmQK6Lr4a0al/XkbfjAS9wUg/ScAvqImduxaGLzm0dW2j4H4zLYPCJehUI3MhXhYJE2tuxThVW94q4oFPFuXoHaPM2ZnomgeSueMGSh/KUIA8tXsfEGHCTokkfhe/avvnbcX+KgFHoiCsE6jH7kR63ytCiEkVnKOl9KhKv6kIC0PbnO2Dve4JtaZfNwqyQtCHlAkKqWvmId4b04+H3h034b3KKmNVBvw82v/0VEGwOd/87XpUzb3GSW4rlVcwuO40d0Bnssu4iQm0sddi3LnXcOoakclnz5y76CuCjwsdXskPB6mtWBiDH90J79VINcvU34/L4dOcTLgfqWIH9dtow6KtgjBq9uLdLBFI4bW
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR04MB8984.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ddf567b-f79d-4ccb-af8a-08de3d394602
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 06:55:32.9646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MxSV8kHYswOozc8GpBSbGVlObd76CGTgypH6LKscpZViVNSWJOcI+X3CZRXs9d1Fv/hAlg/taOtivPFms6ve/oIJFoiAzbliC3quqv5BgT4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6934

TG9va3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IEpvaGFubmVzIFRodW1zaGlybiA8am9oYW5uZXMu
dGh1bXNoaXJuQHdkYy5jb20+DQoNCg==
