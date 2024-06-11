Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2024.outbound.protection.outlook.com [40.92.53.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36AB17C238
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jun 2024 09:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.53.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718097701; cv=fail; b=qrWW4nXbK6AtjwVS3uO3VK83h6dgTCFCuKViTvUYlnDuE3o3PXJl89oMJMHwr42XyJ6QAbSn/umGc84eQ1S5JiV0beDh61S3JmgQmwT7+pwu+AdulT4rHkF3JQ+mBW1k9HHSwYFeCsgMv/f7tw89vgtSXP1EmJcxpGXcSCV78Vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718097701; c=relaxed/simple;
	bh=qOghRguAIKhc5Eumngk8EfdfuRKvPAGIVtgPDLeb2vM=;
	h=Content-Type:From:To:Subject:Date:Message-ID:MIME-Version; b=YTuZwk6tsftFLtRFxDYvh8htjKRpJCFrTpeMoKqy+lWaaGA/Iw+nlLRUR+s0fU2zc6MIaAC3oY10UigQgxqwrFSnheV1ru+eLkuCOVVzsK4f11025VGKU2Y/5cfiJcM1yru/FMS49cd5ZuOy8FuXBwK6F3si/t3YwTH3zZfSxhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=u6/z55nd; arc=fail smtp.client-ip=40.92.53.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="u6/z55nd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcEMu0oRoIBpV6AZkXM9s5J6dmSjp3XPDk67F4By8dBdBN1ALmDyH4TUERzRoM2OlkH0zaCITXq4BhoGmALrnUy0orcVZkSYWnWa8ehT0f//wU+ZnLS7R1k0Y6jGhFN9dPJxgDZmDXPqRUJpFYrZ/90aVln/OfU1ZEmuANHM17y4l30kdfTYAZV8M/RN+etukfvZgRwwf6flv9UqobWrKTce1YLt96KdqtY65+XyAuqSIxVHuIUXesK9W5b8E33B6nLlK5ZZzW+e04/9f57cMcMS6pW+m0a8Zo6iKMwrCxPLLIYMFQwQB7Ahq9Z7HCf2GZ5ulzYXuVNN8vub8HYfDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOghRguAIKhc5Eumngk8EfdfuRKvPAGIVtgPDLeb2vM=;
 b=e7Hy5sDnN6GsylJ3mfMQfXIevZEjY7O4ulbCd4uD7ZML/uDG74ldbOlTUWA326YmilnWw/RQnKIBgqBt10MA9dUD5RzVcswUyvgwjM22SFa2H+DFERAmr1Vn1H/HV0INj+e/i1CWyFvKeNKuN13ha2ukK6h68h8Mrq07L0R/tVvGD28iDo1DLWmPf/+wa9j6Bu9a7cb3CoUpHVWZZvuco2n9G0fNGSTlLq+yLgNynVQrLFo5gCS5X87zcKARwZ7BLvO3DDtLvdC34wwLWc8NKqNV4G8XRzyVTJIqTMByZohm2Bg9N8E6R1o9S1+1ll4aqot7XOVzqKofGuPUavo0XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOghRguAIKhc5Eumngk8EfdfuRKvPAGIVtgPDLeb2vM=;
 b=u6/z55ndmT94ZS6d6MEyKWzgw+hSNbBu/JMwF9fQVBP0S7b3EsOj+q+HAHX4+RvlIp6U+Asf3uSmfiFMkOIHOr4x2Xf2UZjIn/bCtIwBbxXjjnii/Now9+VlrewW60Yf1bEcM2WG7gp5jzUHYzloF3764vpXp/MtIQYJnbbyuA1MYjBSv5CdAa/SWMgN6lu7oM9GB+5AlQmh/4gumuzxUr3SxZsmdLgA913Mtz2jEWf3B0eDSvIaTu3ZSj/GawqL2oA4c7LmarsW4hctmWXXSoG0kSZZT80LPL4QA8XNP95v/5+reZ8DqlIrK+l/fagVaLsYXADKKesbF2OvZK818Q==
Received: from SEZPR01MB6314.apcprd01.prod.exchangelabs.com
 (2603:1096:101:232::12) by SEZPR01MB5110.apcprd01.prod.exchangelabs.com
 (2603:1096:101:e0::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 09:21:37 +0000
Received: from SEZPR01MB6314.apcprd01.prod.exchangelabs.com
 ([fe80::e0ec:b284:fe32:199b]) by SEZPR01MB6314.apcprd01.prod.exchangelabs.com
 ([fe80::e0ec:b284:fe32:199b%7]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 09:21:37 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From: hikingscreen@outlook.com
To: linux-scsi@vger.kernel.org
Subject: RE:Insect Screens,Pet screens,Flyscreens
Date: Tue, 11 Jun 2024 09:21:36 +0000
X-TMN: [ymmlmYb+0U5XdlaxpPcK79YQmkTZvyT9L4n0qsqGJVlCENhWiZk8GdXn+24cGF53]
X-ClientProxiedBy: TYCP286CA0009.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:26c::11) To SEZPR01MB6314.apcprd01.prod.exchangelabs.com
 (2603:1096:101:232::12)
Message-ID:
 <SEZPR01MB6314D8B6A485AF08B6BA528EDAC72@SEZPR01MB6314.apcprd01.prod.exchangelabs.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR01MB6314:EE_|SEZPR01MB5110:EE_
X-MS-Office365-Filtering-Correlation-Id: 04c1f3d8-31c4-4ff1-f79f-08dc89f7e4e6
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199019|440099019|3412199016|4295299012|1602099003;
X-Microsoft-Antispam-Message-Info:
	gz8z3v0pkBrz7tMjKMe2Avx88f2RpHZjMwpI8EBtJRDSRkBZ/9aS5/xZ7RtBYc/S6eRsDZdPPlWQqf/MhsDCWLmXhmUXDOtMuVlra3tNdRWWjmcJnaWLooso7xSfpsZzAg8OqEZZuJRoBQ3WOupCfZVldfWD6GmD6GRhsETMfytOi4Z8N1WDe7oMNA6yftmOZJgZ/9kDjQqF63Vdq6VeYDg+/M99sjo5n6Kw99JSpkNTCms1kDNM8RPK9cAKTRu5csZ0EkbYvAds2gaSnJQ7i3WNn7DZVtLcxQNV8IS7rDgf8RoOvtwrJcGG4vMPTEE4gCQTqk5aryfDTruOMMwbFMVdldCY/0ETzrWf/F01K+g1IcNl2u8D9OyFjNNsSXWdnDgPlg9DXJNvx8d+rzIOx5mLitJk6+qXNyN6UvxYxVD5RnhDcoye982aRpqM4X0Obbekh+eR6mhUTNFSdbYDwtfvmQyMS6kI+q/u05+N27nEVWsXRTc5UZxSNryjwXIfmJMYdm8oHwYNrrmfCKEc7jk+yzQqqo+B/8Ki42ZEjW9serj9LEWfRv1Z1AvcXBxpmyBFPEg6EVKVpIpyu4FywTPlb8KtCk4gdZzHmrf/Sl6Aqihen677dPfnOFQyZtVGDDnMOOkO+aO0ejM6bvImnqPJXR7YFtmCd00wWXs7CtA=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MC90VkhNbi9obWtEa05xRng0Vm41RisxK055TDlMc0ZMelMzcytDSTV2dmxs?=
 =?utf-8?B?dDNRaGhYUjdhS0VReG1oL3IwOHFrRDJrQ250amNXeTV3Zk1neElXbTF1RFN0?=
 =?utf-8?B?bnJTcFJndmtUWlBxcEc2bis1QU9UeTNoTzNvVzBuYUhGemI4Q1k2QS92Wi9W?=
 =?utf-8?B?OWY0TGtodkphcmZab25KNERrZ0VTd3VFcjVWK0dvVCtRZ3FnYklPS2xOVFYy?=
 =?utf-8?B?VUdxNTNvMHliazFMeTFFTUtBZHJsamN3Mi9lSjkzN01GZXJieXFmWXFOb2di?=
 =?utf-8?B?YUpWMU5nWlB4RmlNK2daMFI1bThJN0Voc25TS1VnMUR3OFNQK1JrU21YSDkz?=
 =?utf-8?B?Z3RWc3JmNGkzTExtSjVPdWVHY25oVVI4Vk10WkkwVVFETjBxOG1LQ2NJOGhl?=
 =?utf-8?B?dWprdzAwaGxPdW1FNVNWNDFnY28wRUZYaVBZQlVVQnNqcHFXWERweEtkZkFQ?=
 =?utf-8?B?RzUzY2RneXhaUzVzYTNTekNHYjVlOWI2QmU2czVWeDRLbEJkUWpQWlg3UHFj?=
 =?utf-8?B?SEVETERzZ3MrdzFCeFpZaGJHQkNxMzFjQ3BEUVhVb2RObzVubW1tc2FXbTRB?=
 =?utf-8?B?dWE5aEtYZHlXdXRUSkRCa1BqejRKVU5xRWRsM1JJaURyK3BoSnNSeUNXdzRS?=
 =?utf-8?B?enZ4SjJBaXVNWTlMeXlQSFhFZ1FTRzQ5bDVQa0t4Q2VPeWFEQnREcHFMcEVP?=
 =?utf-8?B?czRPU2o5RHJ4anM1WkdINkU1a0JuK3pmRFVTOFcyMHlhQng1U2NGa2hJbzlC?=
 =?utf-8?B?dGp4TS9oMENzclpMMnhXd3BNZmpMMTlJeThHM0FRMXVHUjN1cXBkakRLZFE1?=
 =?utf-8?B?enZYa25PZW9rSklSZkVWZE96bEQ1MTM2aUIzUW9IUzdLREcyZ1loWlRhRjhX?=
 =?utf-8?B?c0lkUE1yYndoSkZ3c05tclg4amVTMmVWOUNERzdMODAxaXJQaGpTK3ZNSGFQ?=
 =?utf-8?B?WmJHNUF5RE4xMGVVMGVLZnZwQzFpM0NJa3cvZk81REc4RVV3QjBZZ1JLajhy?=
 =?utf-8?B?YVpKaDVVUFhETWdvWThCTjZZbGxkRFlvbWNyUTNRUzVVaVc0cFdmZG5oZVk3?=
 =?utf-8?B?MWFXSGlQbEJncXhrSVVXV3dSNU9SR08weDhnckVCdUZyRHJxQTMzSWhQVURO?=
 =?utf-8?B?cjVyb0FPMElVLy9aY25BamVFUjhHeXIrS0NPdUo4QVUyMW9Gd2RPRFN5Z21N?=
 =?utf-8?B?SkhrdDdlcDViN3VadlQ1UzZRMUxpMFpMT29FdUFhWkFlUmxuSnFmcUhhcVNP?=
 =?utf-8?B?UVRoU3RQd3dVeDlkSDVNcmQvYTZoMmJQeHhXY21vbDZpS2h5NHNWeFd0aDl4?=
 =?utf-8?B?YnZvU01lSWduUm1ZRmpJeTJONmxna0pHQW1NRzNsRlJTVkExWDlucEFEY2lu?=
 =?utf-8?B?MStMT3p1TDFjVXY5QnprRUorVjJHL1pRN2hCcDRndjkwQmpNa3JNTC9sZSsr?=
 =?utf-8?B?TnBBVlFWRnlLYkhzK0c0dW9SUytIVXB3Q3o2WEVWOGpFMGRnUGVyOG53V016?=
 =?utf-8?B?aG9vQ2pXNFpQK1ExTitNVWhrNHQxS0Z1VHVTdy9qTFhucHVHTTJoMlZKSktt?=
 =?utf-8?B?c3dBdExjQnVqWTIwS3JQNm5wZk5LQkt2MDJnSmRwOGFBMCtyQlg3R2VnaENF?=
 =?utf-8?B?anNvSTNFc3ZNSzdlTGlWK0h4NXhwczNodG96U0NWSHZiU1VXZ1BoYkJwZ3Ra?=
 =?utf-8?B?NVlKRXRIZ3c5TW11MitOSTQvWldSTzd4REYySG00aGVGNU5URVpIdFFLSEk5?=
 =?utf-8?Q?i0V0cAx5vVrN5GvXtBI0p+UF3nbxmZW9CL6BAkZ?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04c1f3d8-31c4-4ff1-f79f-08dc89f7e4e6
X-MS-Exchange-CrossTenant-AuthSource: SEZPR01MB6314.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 09:21:37.1550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR01MB5110

SGkgbWFuYWdlciwKCkJlc3QgcmVnYXJkcyBmcm9tIExpbmRhLCBDaGluYS5XZSBhcmUgYSBkaXJl
Y3QgbWFudWZhY3R1cmVyIG9mIEluc2VjdCBTY3JlZW4sIFBsZWF0ZWQgU2NyZWVucywgQW50aS1w
b2xsZW4gbWVzaCwgUGV0IG1vc3F1aXRvIG5ldHMsIGV0Yy4KCkhlcmUgYXJlIG91ciB1c3VhbCBz
cGVjczoKMSkgSW5zZWN0IFNjcmVlbjogRGVuc2l0eTogMTh4MTYvaW5jaCwgMTd4MTUvaW5jaCwg
ZXRjLiBXaWR0aDogMS4wIHRvIDMuMCBtOyBMZW5ndGg6IDMwbS0zMDBtL3JvbGw7CjIpIFBsZWF0
ZWQgU2NyZWVuczogRGVuc2l0eTogMjB4MjAsIDE4eDE2LCBldGMuIFdpZHRoOiAxLjAgdG8gMy4w
IG07IExlbmd0aDogMzBtL3BpZWNlOyBGb2xkaW5nIGhlaWdodDogMTAtMjAgbW07CjMpIEFudGkt
cG9sbGVuIG1lc2g6IGRlbnNpdHk6IDE4IHggNTYvaW5jaDsgV2VpZ2h0OiA4NSDCsSA1IGcvbTI7
CjQpIFBldCBTY3JlZW4gTWVzaDogRGVuc2l0eTogMTV4MTEvaW5jaDsgMTR4MTAvaW5jaDsgV2Vp
Z2h0OiAyMjAgfiAzNjAgZy9twrI7CgpEbyB5b3UgbmVlZCBpdD8KClBsZWFzZSBmZWVsIGZyZWUg
dG8gc2VuZCBtZSB5b3VyIHVzdWFsIHNwZWNpZmljYXRpb25zLiBTYW1wbGUgaXMgbm8gcHJvYmxl
bSB0byBjaGVjayBvdXIgcXVhbGl0eS4KTG9va2luZyBmb3J3YXJkIHRvIGhlYXJpbmcgZnJvbSB5
b3UuCgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpMaW5kYSBaaGFvClByb2plY3Qg
TWFuYWdlcgpFeHBvcnRpbmcgRGVwYXJ0bWVudAoKTW9iaWxlL1doYXRzYXBwOiArODYgMTkxNTMy
NTY5OTAKQWRkcmVzczogQnVpbGRpbmcgMTgsIE5vLiA3LCBLYWlUdW8gUm9hZCwgSHVhbmdkYW8g
RGlzdHJpY3QsIFFpbmdkYW8sIFNoYW5kb25nLCBDaGluYQpXZWJTaXRlOiBodHRwczovL2hpa2lu
Z3NjcmVlbi5jb20vY2F0ZWdvcnkvcHJvZHVjdHMvaW5zZWN0LXNjcmVlbi1tZXNo
