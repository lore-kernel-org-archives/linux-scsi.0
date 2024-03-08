Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F1452F7F
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 08:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709887292; cv=fail; b=lhuuFK5ANNYwQIxu2BOKiPTRKzLE5STw76UueWBIV1Tfh6T/Yeb/H2igr8B7M65xn+8UXtQ4QHYUf8yJV4DHIr29jyXWxf9NoWFvJxOw37F2krQlF3oE4ro27qxIrvovNvjolxJU4x2Pxhyq9mBSPHTAra1NfEya1rvBA40GG98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709887292; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dUkw6JqQwcnVL3UaJhl0IxSeBmj1w8Gt8HCZcahP7yNbrthinFazx13UBazlI36b8yG2JprVWxVi7ImROEukDsT4E/yXS92NQ3joxJt/EfoxPT8ugwGYuLnLMQmS/AO2NBptfIVpK9SHbRajS6TmlsM2QjRQ7ioh8dVEjup9/eU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=k2iOeyFj; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=UJYUmSa3; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="k2iOeyFj";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UJYUmSa3"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1709887290; x=1741423290;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=k2iOeyFjj9IhJjKP2b70NLhL+ACaDhFTf9PgMsCIxVANOLFtapnzBRwM
   E52spsxbPTVetnEBetREQgkE+GAWMyeJ2fO6yYxK4Hy9v8qbyrbR7uY1b
   gDd093oE+fHXe+10BikuMchmthokRP3XDwPccKz1UGPUH4g2LXMh2px0m
   nrDXzKVsLtK6Z2zssxQewKyioi4wR3PsjXJJgGuhCMEgD5OCE7ufqcfN8
   XA/3u+cig+UCSkv3jIPpjn2kncsTFqZOJ2zefYNVCCXrp7WJWgrfJrORV
   ZeCrsT4rNNVvzmCmU6z/xSO0Z8Ondhxi3Zzyqw6dmcGiB0GF5F1Y86R2T
   g==;
X-CSE-ConnectionGUID: 9t8MoUCSRNmnk3FBMwuZAA==
X-CSE-MsgGUID: toyqa6vNRTa9fbKOBSnhOg==
X-IronPort-AV: E=Sophos;i="6.07,109,1708358400"; 
   d="scan'208";a="10649354"
Received: from mail-mw2nam12lp2040.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.40])
  by ob1.hgst.iphmx.com with ESMTP; 08 Mar 2024 16:41:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpya4I/OwS1w79LW1ZEEWVergHbT2nth8gdBehyzsXh0/8tVMAUWmLufxZQD/nBZYmn1gjxsFktgsp+fI/8Jjm8iaLqDbUuoVh3zJ6M5j4jK2Vz2uf4sBlVMXZ4HWvy8u4F0v1UzMb6WGX5Z7+Bg26yCoTVmEJFSWI/EXugkjtUvBT2BAXdiJuA9Iosh232z8GGTqdTRRR8jJ8gXFGlKA70t1cWhiWSU/U6VXWluRseanM1VaRFGJw01lWeHbpFW6gREl0XmyamHMPk0+Q8xJpbpqoO70oG+RmeHMYz4Xg/XwWLORXKmkV0oMp97KDJudK/XfJ48ea3XzYKq50R6lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=aT1nNTGsSfOwbzzixpVSj8OLzzu1pBd28+9yQkzH7sV+oBWa7i0aJPjk3ti1VV5UdgPJ14ETXnEd1qF8/VU4S0OgBnQ0WUrqkzK5GPlfVIsGQRNlQXEHK89nqlsX8jnlS0hAgW9zNpIkhAtKNbHtW5i75lQJRqdKbanmVUfkPigvEoYG/PrFoq94wroIr2A4uLD3e9L4KX5hmVbc/zcGeJJpdYFWs5RE34Q7lzqwswBYsOPcbJwD09foUKUFNZ6bDPtOcya5ZObbic05VR6VSdsp9EEuYMnwgRK7f2VO9ZuXGQFy2wwqL4O6GHhyqW5CO/wKEsxlHLsgZs89/KI6DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=UJYUmSa3hO8VKwjf3iZSUiFSOcNUtPc+8AqqWqC1JkfsNw12Mh7eTAIp3787HK6iEfW25/s1I/t3qf1q5rEXhU2+JgNpoFk7lRBwqgYECuJmHQBHPhJXN9swu7NwYxcCt8L4Em6QJsgG8BGplQB3sCZVnsI3M84cHGqFiauEtkk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by CH2PR04MB6807.namprd04.prod.outlook.com (2603:10b6:610:a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.27; Fri, 8 Mar
 2024 08:41:20 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::a814:67f1:24ab:508e]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::a814:67f1:24ab:508e%7]) with mapi id 15.20.7362.024; Fri, 8 Mar 2024
 08:41:20 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, Kashyap Desai
	<kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpi3mr: Avoid memcpy field-spanning write WARNING
Thread-Topic: [PATCH] scsi: mpi3mr: Avoid memcpy field-spanning write WARNING
Thread-Index: AQHacEe3ZiPF3AmlaUKgtf4Pes89x7EtiDiA
Date: Fri, 8 Mar 2024 08:41:20 +0000
Message-ID: <369dcb71-26d3-491a-872d-aee77f048af9@wdc.com>
References: <20240307042645.2827201-1-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20240307042645.2827201-1-shinichiro.kawasaki@wdc.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|CH2PR04MB6807:EE_
x-ms-office365-filtering-correlation-id: 1efe4a0d-4572-497d-15f2-08dc3f4b873a
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 D7ewbz8behbjrGeEa92PTKYoR+2CpbwWAysfZUTaNND/ur6BBKfhjCo5GYCXClSL6AKEIbSPcJkdnaiqUjWUb/zRlTsFwm4s106jMzSoojegCkl9etfxAcYZ+0QnYPuHtlwW3R0hADTGMt4B0vW8tfUnzLZA60J7FybXfOA9kqTlgOjUL3zYPz+NgR+d3nFxKMKySDfWeNstXs3uniGzYOo6MEps9PonzFTaJjMTTAyR7awBGvpim/jushEDGKpwt5khg2BZsM7QvRlyTrVjvZcuCDj36JGAzaDbvzeMaZ7ht6wH4v/XyxuYK7Aez00+dI98vWwZGPImHpYYLPVK2IAKmC+c1rbY7DwZZepFRzylpujBlpr0P/I+3EWjXTZCeAaIDOYFztyf8D5jcINMW1vHIp08Gwdw/FHD0qVdqJ2zRXLonHMscihyS4LG72bQavEXBC+cG62m1BBHiAbNkIik6hBlM6kBKQk8sIblaN4F5jXVXPM3RkfzfnlrXZIP6eYtwoEi5vPq7hKy7DIwgPJmVyD3lIfrb+qCe++jJ26Zl07EDVK3f/vWLIMH1XuPKQ4uoG8yZgZqay9LEr/67wxC8saRJinTBbwPJ7k0/G9kYwxNKV6vt2hoTwVUSr2vMx7rV9mo3G+G5cVLbqsxj807dU8TlvID19e/e+pHCbmMjV9enY1tkFff95xzl5VcvWB0YxRQoKLZdV+KaKZ8Ne3bxf7qLVM46t00V/7+h5c=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZUMvdjhTRldDcXpDNTM1b1dXRXFZK2tRQWxUalUvYzV3SkFxOHFaeGJQV05K?=
 =?utf-8?B?OUhCZkF0R0NaVS8vMkRiWk9KZ1EwYXJKN1BwWHV2SWhnQWgraHgyRU15QjNI?=
 =?utf-8?B?bWJENjNOWlA1Vm1wWldEQ0tkVGxkbHZsYnlXdTNPcVZvR3RtT3J1aTFPY2lV?=
 =?utf-8?B?Y3RtdlZhdEU1S3FIRStQcjlWc25pTWxuVmxrT2psTWFNTU5sNUhGblYrdFRX?=
 =?utf-8?B?VlVDQmdHWEpBbExWdEhjNmVTS0RhYU02a3ZyN1k2c2pTaTBtZEZHSGFaTVp5?=
 =?utf-8?B?cXVvQ1c4clZTVFg5Um91Q2dFTDlLTlQzVHBpRFkvd2lpc2V4Y0szcUE2WDgv?=
 =?utf-8?B?TGtaUFJtOHV4V05Pd3QvQmJqOHh0K20xWWxNMG1CbENKKzQwMmJmWmZMZnZB?=
 =?utf-8?B?QVV3MlpoRlNsMm84NkpwcjFCbkJhQkY4MjJndkdhS0xvMWw2ZkQ0dFlBbDhU?=
 =?utf-8?B?ekZLa0twSzROcmNKMnJsV0ZoMm44Rm5CUExBQnc3Q0cyMEZkY2s0cnh3SjAz?=
 =?utf-8?B?R3lSejlBZ1dJVkZ4NWJ4ZnJlaCs5RE52bXlFN3ZFakI4dWNhQlJ2NElXdExq?=
 =?utf-8?B?dStVVGF3RlJCWE5pSWxHbGRLNm42blVhSlZsN29QakhmeFpZa1BJTmd6K01u?=
 =?utf-8?B?cHNqSmJXV3pzUG5PbU43RzM0am8vdElRYTlxTk8xQitVSkhxRUVkR2xNWHlY?=
 =?utf-8?B?dlZvV0swTk8yY2dtRkxjLzFwbnF4TitVTjR5dkZRdUExd0JKdmhoU3pNOTBQ?=
 =?utf-8?B?MmpxT0JxTlNLZmd4aE5sUUs5ZGI2NytTdTZ0MFRXZVoyemtjWXdPcnUrdDZv?=
 =?utf-8?B?L3l2QkFZMVJXTFFYMkFqU2dEWDFEV3AwMXJxdlVZaWVtK2xseldTaVJaclZX?=
 =?utf-8?B?TW1jRXVNSnVzckdPNmVrSDVtbzFkOW14WU1WdXJHRXFiRmtxeFJlQnhzOTQx?=
 =?utf-8?B?ck1jbVdxRWE5K3BGQWlPZkpIR0R3V0w1elJWWUFhL0lweVMvTksvM2x4bFQv?=
 =?utf-8?B?UjJzajMzS2crdFRGeWM4UmJYdkl5amtCM1Jqd0hWOC9xMkVid09EbzFLWGdE?=
 =?utf-8?B?Q1JJakp6M3EwYkxid3lDT2xaK2IzUzMxUUJEVVpxdWFKbnVqa283cG9MMmEy?=
 =?utf-8?B?aW5uZ0s4N0pEbDVjOFhRd3RVSkY2emlkM0JQQVJlc0xYbjZBL0ZIUEJTaFBE?=
 =?utf-8?B?azZ2c3Y0MmpUQ1c3VXFSRkFZRmxoblBsdDE0QzFPSVlHWEZ6TWZyUUJla1lx?=
 =?utf-8?B?V1piUDg0T1R5RytWTkd2eEVjNlozSE9iNk5pZ3habjhHUFdkZ0VRMUkxWnpn?=
 =?utf-8?B?OEM5YVlYYS9RZ2NYZUs3WitKWTZiNUZQdG9KSStrN0hGdFhwVXVEOVdiTENo?=
 =?utf-8?B?Qy9HRWt2a3dBL2M4SUVZa3I2TGw3enYrZXBURjF1WGdTSmRtZ1RjMWtVVVJY?=
 =?utf-8?B?cmZKN1hVelVsUS9OMjhicDNseFlwRm12d1lrblNZUUMwMFJ2T2pSd2JHT2sr?=
 =?utf-8?B?dEpwWHFYd1d4MndCN2lOeHE4YnAzbkhTYStiZDZWamxLb0h5NExubTBrWU5n?=
 =?utf-8?B?SDJhbE1tVytRWVlZNlJMRGVHWUh5b0VTUk5LSlBiWHlrMjdCM2UwTHRnWTl4?=
 =?utf-8?B?N2dtdU5qdW5rcXdvTWpFRjQva0J6Wk5jMkxpZGZSdU9RMGNmdXk0VWcydGFE?=
 =?utf-8?B?S3gvWWM3RDNCZDMweTFwZVlnaFBmaDRWWVloeWFQa0g0WVozblI1Z2RZY25F?=
 =?utf-8?B?b3Nhdm8xS21iNEhyOXBzMVBYcm01a0N3QjZibDVVdmlnTzg5RFNhTHBEVmE0?=
 =?utf-8?B?dS9ITEM4aDhEa3RObnlhSk9yVnNtalFPSzRCQVdTZ2pJTW9QVXJEMU1MdHlL?=
 =?utf-8?B?S2JndVVtejhRb3Y5ZXRLRXBmTXdXekMyVTR6MEo1YjQ2cXBYVHZjaEdXRnNj?=
 =?utf-8?B?dFVPaXdTM0FzM0VVOUptZ0pBaWswQnpra2F6U1VETjlaMG1HSzlJL0RZUHlk?=
 =?utf-8?B?N2p6L2d6TDF0d0ZIdi9TNE0yYitjRVJ0aUJDTXE0NjNMQ1gyS0t1aE9OMENr?=
 =?utf-8?B?OTJNYU0vSDhvVllaa3JORUtBeU5FQXVTU2hIRkdsVjhvRWhQZUx5bDg2N1Nx?=
 =?utf-8?B?V0lpZGhETzRVY3BKV0R0eG5ndXkxN2xnNEpOaHY2TkRhU2NYQ3h2dGFlZFBV?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E9CB5684B514F45AC03DC849FC3AAF2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sx8l0PNOqvG4IB9QETWs1DVWWdwc6HOn1ikKEopyIxFLwjrQSUNbkLnxKDXougRn4rCmvSXOSWLGHa2ahpHVa/e5Uq1JB6DE0V5cPoRLH6BWI+eyw0TPMmtKkWYiyPw6XFJyPpKBYITC9mbU/KgjMaOeO9oRqaKwlEfLEete5sDFvsfibjp17MkTets2xU2wewxkEbWlE//iDkLAmv4uedWDlQPJ8Vfserh1OYOqdtVVwzY/rdeICNgBd6BWMBRC5B+H3iYD8nulKh9OCdF680Rs/9W/57GEXBDqgJxH7tjQy6rCetWGJqDS/AnsgpUCsxDJr5uxK4aqkdAPZErQYcVFcIERSw9aaIaE/pXfrh2QOF6zITpFIbjrFSKm5r64fYNliBHcgy39k5qCM4uVU/q48ofmrJMe1qwOPDsVbmu/Y+YzTlgUs7BNBgSVhcqTcdUaIMAabnXT0SbO+ICsdNtCUD85jrVRRS3mVqIxBOX/+kDl8JcgxC6AwX1ubjnAQWqxoswZaXooqYLmbUOSdJjTeoKls3l4H0SoITi5foJ8pH9teDlreh1oxjXr6GIP4tYqBg7zNnsuwNpdCqAfanzVSNtvbQymvsPmG6u4TVeqzuN+v8RVHlqXnbqf4Z+1
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1efe4a0d-4572-497d-15f2-08dc3f4b873a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 08:41:20.3385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1n+f4+sdlpFAGINUryVeFn1BhW1XhDHFUPEfpSRDaEh0lpmwEUd1/SlSU3eA6jodg/iaVJAHY1KXp7sOydimJVvSaj8+zz5Aiqm+tn9dOlE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6807

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
