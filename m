Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01olkn2073.outbound.protection.outlook.com [40.92.53.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B20C5676A
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 14:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.53.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709648499; cv=fail; b=DFYNMKHdnh4oFCmSF5ZZCy3rhayr6aNqK2ItAQwmwrS7FeaoV1BTlZxJZnGUdTQkeuX3yCN46dIpHWC+hyHMWjqqOaixTlB5ibcfJwhPEF7UiMxXGKFxkkAcLzUhVSoj0KRlMzY9ovRVBzwY37c2eYgqN9jaS9/spGhgnNAqncI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709648499; c=relaxed/simple;
	bh=RboP3jdBjHRJDlAXIgzWfpaJLGKNd1O1mjaxDRZaxjg=;
	h=Content-Type:From:To:Subject:Date:Message-ID:MIME-Version; b=QqwCJAoLwFG2q8Kwj7kdkCtZAYXVRgYWbdrKbQ60F8PKPnEqhp9D3fUOVWthFJwkJJfs9eEYKb5pS4X2qPWENmmf6r69nerMs7dCCq6Ks8YxZv846qzlMr/Mp1BSuaxuLSaoblDDLZ68CbBVA6J8EpoE/Y7Qj9Oxl8tFqRleGuI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=ZvBE9LMl; arc=fail smtp.client-ip=40.92.53.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="ZvBE9LMl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PcB2MwkALKF948oa4nxrQBKizd6Dqt93KPPaRTlWvBy0nncK1sR07p2O8wrVgckrED6xYk8PkCcqh7E+4KVDcAig+o3RMvOT71msGejJbsokl7nF9F+zhQ9nFCOTT+G7+H8mtrXzgQHQ6u4v+chmwksU3lKRFOw5HqrIgtLV3Pr0eG2RKzsuCa2qv9sJM/9R7BJwXQ2xkEMjT9nS9MJCAIlsp9vxdevZINGww4CTpxOl26WMue78qRRK7tqX8Pp/mJz1Ee53AlaInR4pgRxxAK0WRtBLN+cBfSRqJdY9pJtBlgYpkRBYsEY4vU8cAFL8Tj7PiE0u9QTvQ/qeXQ8+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RboP3jdBjHRJDlAXIgzWfpaJLGKNd1O1mjaxDRZaxjg=;
 b=PXvgecOH7WdXdZatNK/LYefyZFmYeV6XX/feKoMup0bgVtE+Q0wAn0OOEYwgRj09CnZK4LJnXQ5B6LXn9UEXQ15Y9Lj9zBw6m+LsQZCCny/QDMLbVXhhI7NGaeDDwC8Ugczv9AIdtZAem6EkWLQAestNZPFOKEtZ9y9df9KElSPEkLVNczSaUmgfRStY6rD7o7K9SQfbu875g9/fAbOdFxo/Yx2KnksO9EbwG1sciVqL2FFOYLJywPx3MqPE3ydEOM9Ptap4dWpMKgLidbiIzSKAqGyio9DR08QlDT4ocwYqPDIFaHCJ843FP1Fiw92zXXFk1Ice/mqG9P9+IQNm2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RboP3jdBjHRJDlAXIgzWfpaJLGKNd1O1mjaxDRZaxjg=;
 b=ZvBE9LMlfJu0hvj6W+SyJRITEJj1Qm9cqfVcPlMwWgfb1U5nU2ZIBOGmeRDAL5c4bSA7XKqS2E1RQHNxNTFOcaZP/z2DRRCPLIs8qW5EZdLKAJLWb7htFYcdo+WiEPmgwOfsk4uR8ikL2I3EHmVHDMZ73hMBZwr5M+VlZDxCgKAh7k3my9cMphrwMfihIUYjZ37UhBEXBKqb832ekjMK1ZMUsYUNXX3Lex/ACDVypgswatppxAxNtugOA5Exu1FDqEqjSmIWSt/llIb1jeJMTxWT48CtViHXk12gokURDqUF5KzPp/oi/mVq6qfOij7SEO2MH9WRorw4X/RXYk4n1w==
Received: from KL1PR0401MB4963.apcprd04.prod.outlook.com (2603:1096:820:80::6)
 by JH0PR04MB7204.apcprd04.prod.outlook.com (2603:1096:990:37::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Tue, 5 Mar
 2024 14:21:34 +0000
Received: from KL1PR0401MB4963.apcprd04.prod.outlook.com
 ([fe80::20b4:e1fe:bdee:43d6]) by KL1PR0401MB4963.apcprd04.prod.outlook.com
 ([fe80::20b4:e1fe:bdee:43d6%7]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 14:21:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From: hikingsales03@outlook.com
To: linux-scsi@vger.kernel.org
Subject: RE:Insect Screens,Patio screens,Flyscreens
Date: Tue, 5 Mar 2024 14:21:34 +0000
X-TMN: [XFqUZYbbQFNHSdoANvG+/PlRBlKFjyn9]
X-ClientProxiedBy: TYCP286CA0226.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:3c7::20) To KL1PR0401MB4963.apcprd04.prod.outlook.com
 (2603:1096:820:80::6)
Message-ID:
 <KL1PR0401MB4963EC7A660693F322E9D790BD222@KL1PR0401MB4963.apcprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR0401MB4963:EE_|JH0PR04MB7204:EE_
X-MS-Office365-Filtering-Correlation-Id: eaa935a6-9af2-451d-cb0d-08dc3d1f8fcf
X-MS-Exchange-SLBlob-MailProps:
	Vs63Iqe4sQlu+i0OUZ3xyYd6Qjs+zzeVYJPuBh9D9IWj/0ecGavAGHs55NEF2UIasmKdxawlRPymk1cLxSLqqYqxlxPZICYr9knQFQwp5Iz3QVluU6fLZ+7vt2wtm8daKCy6c0AOqqiTQhA3PshuSG6rZ0s7OOxTf0M8Y3zaIExWZtECxFri0PKnjc6hg1ZP4g6dB/bkPWw74+T2vYRTVS2CsMAorlA2u/rizHRsfdzmKZrQltiXTd0186sMzL29cmezvH98r480k9Oiw2H27Jv/7Cq4KPL17kriNub/IdkdReQJfrMALNgOZhaNyu84o2yI9U5nIcV3iSCYe5YmnElwqZ7Kt5fTQP4wz1rzs4/f/MTjBqrqwxI4kvS+l+TCghVK7npd6GEXxwd1R5x+kyIaW6W5VlnpmGOtcqkRjCTlZXgDb9O5L72rFnFV76ka4R5yeH5XaezE1S3lIn2BKZYoxQHMR2TsP2byhCWThf6Sq9OAEn9N4KfFMLwFZRqnuwFu1bWsecOc1yOECcAAi7kRNlTO2GaQtZ6gFM1lZRsOHOXbr55JJ8Ff1t3Lh6ESlQtq1m0CblX6ArN7UUFiogUI9L8o9x3eAacQYNZBewGKiRx+WQCL6CjDjYdlt5cS6pEVqPtvWew89a9iWQTnomf6ywDNICBTCnP/wIawKFHscy5HembkrCm1WG7DU08rtaqWQVKyScBldr0X/lasIuLHI9mx+Vm5qQocr4Jwpaw=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gqww8n9q4NrtGmHgQPg9HPFkZiIqw0b7A7MRjCyR4Ty6xAEvQiHiODVnjQ2B+y2CAO/nPUjSFzXNJ5Byiv99NFpwdcO1bPV9DTdHOlEPbsLqnCnSxJjcB1GgMnzwEKvQWWZ9lCKW83+WOlQlzhtimx/Mttru4n2n8vviuBjtyqydjI5iS4+iiq/a7ASeU+TWIjkx70SFHtTrOuqIau2/KBUtn19tSHVFEag1J5ZyDeuTlJQJoiNNZuRe5rQZMenmvYQbTU4SpU+cWka2b5sy9AEUTJXrcd55vFW8wzwBHaMhrIQEpF0u7808T+LDyku3UQIbP61kK6cRk7srMcrBOThWDA7fb2FEqkXPYziNOgrqepXzRfngM4NY53Dsiuahmz9JRaRAHpU6glY1nRxSS17kKZ4htAgMJf4hPuym7V0KVMAgnbNrK9tuDjSBN47tHxEDMhfxzXAa2bZ6Ja7hNF8Jm7nKClHHSJiXw0PgTTTTA9VWaAX5UGq4dCbByPUXMKh0lAqkmOwUPLl2lbJcyZoVwzs29o2VClGbN5vFnEuStOWspJfbZrDTQVnIkAhX
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c1FHTXQxMGUyQmJBUkZablFOQlpSK1MwM1k0MlVBTlM0U2hsUy9sUFU2cU45?=
 =?utf-8?B?TmxpUGpGamtNUnlIL0xhcElTZVExWnFSN044aXJJMzVNR2cwMW9FNkpzRVhU?=
 =?utf-8?B?L0dPRUZCZ3dtWFVlWHdTdjFXN20wd2pMZnZKQ0wwSjdlOFp4a0JaOG9sUjZn?=
 =?utf-8?B?STJpNHBwcDRZMzR5am8xcmFaOUpGOTJQcEh5bkR1ZHhPbVhJOEhpN1pVRll2?=
 =?utf-8?B?cXRKL1VmM0lJZ1FxeVQ2L0k3NllPeWRSSHdQYU9MNTJLV3lMV2E5S3NsemxX?=
 =?utf-8?B?UWh2MFY3bkR2UWFCY2ZJaVJ2cWFqMVNNYzNGQ0VLaXRVbGtJSXV2dUFCM1BM?=
 =?utf-8?B?T3duRzhoRHU5RlhLL2FKVWQ1WEtaY2pra3RsZG5ENTU3YlYxZGpPL21PZjZo?=
 =?utf-8?B?d3J3Yzl0aVpPdWdEWnd2UEE0NlVKWnVna0hLVEVNdDFmU0N4ZmlZU0RSVkJT?=
 =?utf-8?B?aWZMVVdPZ3J2dXJvOEl5eXI3U1dmK3VLL08xQXRKMUkvSzBWWDVvQVhCUVgv?=
 =?utf-8?B?S2Q2SXBETzQxaWJTVVhaWVBGWWRwSzlySkQzcXE2VklDSEw2TXF2azdVSXpI?=
 =?utf-8?B?Vk84ZjFOL25ZcTlxM3kxalViTGJoS3Q2aEQydk5YWUZaTUQ2TmE4R2Q4NWUz?=
 =?utf-8?B?VUM3ZWVOTHpWdGdjS3BBUGRGZVQxSW1vYXFXYU5mWlY1WUNBcmhXUHpFamtp?=
 =?utf-8?B?TjZFVC9iYkJ4WE5aME43cTdJa2hiOTdMU20wbWNlY00zMXhaVnRwbXczdWhZ?=
 =?utf-8?B?OEpsSG9sMk1mR0Z3Qi9kU05BMkd2VG9FbFBzMm1aRzNMYUo1VG81MmZCMDlH?=
 =?utf-8?B?R3I0WC9IaURwcG5hdUsyc1JLMzJ0VnArWEgwNU9hSVZLbDlwRzk0N3UvNmNO?=
 =?utf-8?B?Vy9TcGhmL29qZit5NXJjL0JycVZLR3JjWXk5TTMvTXVHRXQ4ODVPWkFRZUJr?=
 =?utf-8?B?YkdzcGlTR25JeFhIek9jK0JBTnR0eTZBVExJcXhCdGRGUnlDTkhPZmMralhl?=
 =?utf-8?B?TTFGTUp1ZE5qNkhhM1dlZkFiQXpwVnBOeHkxT1hiYVh3RTE5bTlxN1RBNlhO?=
 =?utf-8?B?YjNjeWY0dHh1N3M1NEtBUnhPdHhXU1BOanBRQnd5dEJ6SXdTU3VxT0wwYnlr?=
 =?utf-8?B?d0hSZmdNcS9SK0hrOUd5MkVGZTA5aGFpRkpjRkRYS2hqSjhwWmxDR0NqZ3Np?=
 =?utf-8?B?U1I4Q3BpRE1ha1Y5aXVxcVFhZzZ1YmxnZXI4RURNeVpyQlFDellFbDEwbit5?=
 =?utf-8?B?UWYvTnIyREs4d1RaNFczNGppbVY1eWVRYmQxWU5WOStQZ0dCL2RTNjkyUWdY?=
 =?utf-8?B?RG1vckluMUJDWEtNNEF3VE03RzNSNThsLzFRYVNTZFgzNUw5WWJSOTEyNnkr?=
 =?utf-8?B?ZEhheGJHVmJVMjRpQnN6NDNuSEVIMC9tQjhBRnAxaVVhMGo4L0RwUWh1MCsw?=
 =?utf-8?B?OW00dEVvVk9mZjRTL3BVUXRQanBDallXaE1RMkh5UXA4OGNaRlEzZjZydm13?=
 =?utf-8?B?Wjlubzd1ZlY3RVVuU1UvQjdiNG5DcDZ5aU9wamEzQTdlRTRQU0FXaW5xMzlj?=
 =?utf-8?B?UHhVbzlEYk91TW8xQ0ZWeHFwVjdwT1RoNjhMenlCOTZiMUFYV05qM3Rxa2Q3?=
 =?utf-8?B?dmM5RzJLZElYVVVMZ1hjUWtERlZwUjE0K2FJcmJ2L0VhbVpsUGV2WUQxUFVU?=
 =?utf-8?Q?mgpIXuqjZFRN4i3gpsy4?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaa935a6-9af2-451d-cb0d-08dc3d1f8fcf
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0401MB4963.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 14:21:34.7513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR04MB7204

SGkgbWFuYWdlciwKClRoaXMgaXMgdGhlIGJlc3QgcmVnYXJkcyBmcm9tIExpbmRhIFpoYW8sIENo
aW5hCldlIGFyZSBhIGRpcmVjdCBmYWN0b3J5IG9mIEluc2VjdCBTY3JlZW5zLCBQbGVhdGVkIFNj
cmVlbnMsIFBhdGlvIFNjcmVlbnMsLCBQb2x5ZXN0ZXIgUGxlYXRlZCBTY3JlZW5zLCBldGMuIAoK
SGVyZSBhcmUgb3VyIHJlZ3VsYXIgc3BlY2lmaWNhdGlvbnM6CjEpIEluc2VjdCBTY3JlZW5zOiBE
ZW5zaXR5OjE4KjE2LCAxNyoxNSwgMTYqMTQsIGV0YzsgV2lkdGg6MS4wLTMuMG0sIExlbmd0aDoz
MG0tMzAwbS9yb2xsOwoyKSBQbGVhdGVkIFNjcmVlbnM6IERlbnNpdHk6MjAqMjAsIDE4KjE2LCBl
dGMsIFdpZHRoOjEuMC0zLjBtLCBMZW5ndGg6MzBtL3BjLCBGb2xkaW5nIGhlaWdodDoxMC0yMG1t
OwozKSBQYXRpbyBTY3JlZW5zOiBEZW5zaXR5OjE4KjE0L2luY2gsIENvbG9yOiBDYXJib24gQmxh
Y2s7CjQpIE1hZ25ldGljIFNjcmVlbiBEb29yOwoKRG8geW91IG5lZWQgYW55IG9mIHRoZW0/Cldl
IGhhdmUgcHJvZmVzc2lvbmFsIGZvcndhcmRlcnMgd2hvIGNhbiBndWFyYW50ZWUgdGhlIGdvb2Rz
IHdpbGwgYmUgZGVsaXZlcmVkIHRvIHlvdXIgYWRkcmVzcyBzdWNjZXNzZnVsbHkuCgpQbGVhc2Ug
ZmVlbCBmcmVlIHRvIHNlbmQgbWUgeW91ciByZWd1bGFyIHNwZWNpZmljYXRpb24uCldhaXRpbmcg
Zm9yIHlvdXIga2luZCByZXBseSBzb29uLgoKCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCkxpbmRhIFpoYW8KUHJvamVjdCBNYW5hZ2VyCkV4cG9ydGluZyBEZXBhcnRtZW50CgpNb2Jp
bGUvV2hhdHNhcHA6ICs4NiAxOTE1MzI1Njk5MApBZGRyZXNzOiBCdWlsZGluZyAxOCwgTm8uIDcs
IEthaVR1byBSb2FkLCBIdWFuZ2RhbyBEaXN0cmljdCwgUWluZ2RhbywgU2hhbmRvbmcsIENoaW5h
