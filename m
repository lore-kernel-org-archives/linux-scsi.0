Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AE6381E9C
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 16:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785774646; cv=fail; b=kzMGAd+YSeO8POAAMhQQYAESCI6R3Xo6qfEiEU7shJCOqcBEymgsLIMvAM+gbt/3iaL4D76wiaihAdGjrgV1bI4oYPapLLLuiEuWgsmdrr0fAC05fPPP/pXQcXcKbxqCBffKA5gHuwKe7Ir/JiSrDFuZS62JDRWaC/ByGkrWA5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785774646; c=relaxed/simple;
	bh=UY5NcHDwHJR8oHN7IWqK+CjzezVUxY9V1HaXpCxBFD4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 MIME-Version:Content-Type; b=WQhjpW/ltVJ7VWbtCWgKEbS6J2bPKxU7SiLmm9vkAoE0wUEHOCfHJrcWcIcLjA8d7ddFT6ze6FLYAjM6TRuKadCqc1GO7215ClPHwmCjKjhmguwLMkiQo4Xw5M7eGP1hdEp6ua0CKzisO1I3J5Vr5ElgVaPgGVh4lliZ7c3f3W0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oe1LYKA6; dkim=fail (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=teNbq1Hl reason="signature verification failed"; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oe1LYKA6";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="teNbq1Hl"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673CC3Kt2753994;
	Mon, 3 Aug 2026 16:30:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UY5NcHDwHJR8oHN7IWqK+CjzezVUxY9V1HaXpCxBFD4=; b=
	oe1LYKA6SdhyEVIFI0uxP5GttiyzspC5T/iVcdK47PrNqpUoGmqct0EXcpeSeaUL
	BWMYF2PE3WatShhBsvc693NPvAid8Jvojw3o5zR4cYa7eDFYOMRwAUy59GKW0aLB
	pi4xpgWVWB/NOQ7VzJoyLdTT/vX5c7ZY8Yuv3VD9BCqr023V1dgFoFwWEN2euCip
	Im+eYrJdXc7LosM+JxUmb/BpQNaAbZrh534KEMcDy+coRNL6I/2brQhgC975hbeF
	ut5g/ypbmX9rbQOz9CTBH/0g9fDDaE2poMDG+CosNjSqqK/rAIJmw8bTOREcVWi/
	vRG0Fgp6quumJxuQsCHkAg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7cy4g1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Aug 2026 16:30:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 673GPWZw030148;
	Mon, 3 Aug 2026 16:30:34 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011001.outbound.protection.outlook.com [52.101.52.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78s426s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 03 Aug 2026 16:30:34 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q4+uwRumPfJ3pfDfpEWln3y7GLG4DS+aTzOsU+UqMgx8CFFoB/NtdwyKK59RxQWF3A3HTPsnaxS+FLMXL6og8DEoDH2yW5g1JG079xppHh/HxcKlM5jsEuOLF2toNucb3HkjpjUP9SF0Qm5Xxj7qn83DYac83ewexY97b2VGvHjtxqMDyMgxfIuXgK7CcngquweOF8E+Sd+ce5EIxowPzSoj+OhxdTgRsBlXVDQVYrgnG0XfAmDovcdNXQac3pxbBhk17Ig1HQL6mQyNZfmWtdsGS6P6CzDH47AqYquhmW4uTcwfdx8fdawenONME96OgVE3y2+JiFIZqVdvJMX+jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsfGd3npIAVNUjS3iFVwz1BpdWfrAIJ6SNfR0b5JVSU=;
 b=b+TwMnFTrEeUFAkr7mAv0FAVC+gjT3EtATyAvy5ItbVsoOwFY5y+GuSGWhkONCKFi7+J3jy+KbeXo+2XeCR2Y8A6A5q6FKlg3+gFZdni72SWYKa+QSVjx+cqYeJIuXmIYcDeB+gGxDY4ViSLvBIWimZh3IWWSHAzFaL9Bnc3IgGjLQGACt3uZ7m9Lrj6Cb9wOVXp10HuIfHXlFYkhbxIwPLWo4U1vo9OicxUQiNtqHBJHx3jT+8jFoCrhw/8PiSXyn1BIqPuDUK19kbWV1V2N9Or2A3YOSMinsYyWdE263/mZrt6VJqtVdSbGG35EdvVzq3tqd0Q20pAI5Rdau4KSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsfGd3npIAVNUjS3iFVwz1BpdWfrAIJ6SNfR0b5JVSU=;
 b=teNbq1HlN8Er6lAlHjarwzKEuYNwjmXRCzNASN28jUEBG5Muo9zvW5Mrv6OFTD+peVyPtdU1j93C23AaXvnP98zCtmLRLiebKCVlExDNIIKoYOb7GBQsFZhbx66z1uWC+Fj5ChslOs4oNRNho0iXsJlZcHt3uwDii7QRlHBGdok=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA4PR10MB8753.namprd10.prod.outlook.com (2603:10b6:208:55c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.17; Mon, 3 Aug 2026 16:30:31 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.016; Mon, 3 Aug 2026
 16:30:30 +0000
Message-ID: <69d7dd4a-2c0d-4e1b-984c-732af4e7efb9@oracle.com>
Date: Mon, 3 Aug 2026 17:30:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] scsi: core: Pass the SCSI host pointer directly
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
 <0f417deef926f1574c555ec44fb2036e997a727c.1785534721.git.bvanassche@acm.org>
 <98049e01-09ac-43cb-aa5e-593bd5fb25c0@oracle.com>
 <58b7c76f-6893-44e1-bf0c-e9cbf080a073@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <58b7c76f-6893-44e1-bf0c-e9cbf080a073@acm.org>
X-ClientProxiedBy: FR4P281CA0303.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f6::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA4PR10MB8753:EE_
X-MS-Office365-Filtering-Correlation-Id: c4b9638b-7441-4c73-017c-08def17c889b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|22082099003|4133799003|18002099003|6133799003|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	Zesp1eynSygN4brqd1SvYW/kv90Nau1n2oRfmJhRrYAQ64SzGfzPTu7db3YefNPZBdak3lfqUNkQOCytssAsAyh1CfLKtp3+CmkOv3Iswr3afyhv7iIzF6OMQPogBwE8VdW4+15gsy+Q9DRTh51rsDpVHKEVIGa4Y2PI+KENYTif7Aj+Q4MvA49jaApEOzHxj6a934VhteYIOQxPtw4poxbd8smqwr+ik2Mh9U5y0cB7acxAXnDwumnZlUodW7Npp1hJFKX+j6HwRWxfzd07XUNF9hFKU23aFUBY3z9ZYA37xjrL7UPT0OPepyBaqiJDEn85tYa3nC6a4+pL90XlgOgKgpwXfAcyuAvIC5wnYj3RmNfxrHpolAN+cUbHDrrSSf9CH1TidxiORNjs3932Vk4TI9atRTWfF1zadXPzBSCusQ1/GopRIp1WVQ3PWQXw1jL2D7yo+iB64L0dfSXeQ1NuuV0AAwXaIWGaOQrouHbphMd9nY6PwePuxGHpyIot4UIpARzLrM5t5Xfdg4pqMKvk2JvHLj1Z5NMO+R/46zKh29lYeWA1E+YcAdIefKhnmd7bbDqJ/kk6xXmTR2/Pf7byIsTWiui49JZelqd7lJO4WAHpj1J+/1WbhDLEW3RGYixUDBsmBpqeoDh+VN5mtAXxEoLL5D9DyTcGYej3MzI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(22082099003)(4133799003)(18002099003)(6133799003)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTJIVTd0UnRJcHpXMXBXZDJZVUF6WmMvaGYyeERKNmhCUDl4L0VGbkdiRnda?=
 =?utf-8?B?OVNqejRwZlJTZGJVL3I5ZlZwWWh5emtnWVh2ZXBsakkvWXYxRjRybi9hWFVL?=
 =?utf-8?B?OGI3VUFPQ1R1RnNsVk5WL2F2ei96bVNCTENySFYrTVdpTkkrdDR1Qm1lUWVW?=
 =?utf-8?B?eFhjN3QrT0JqN0Znd2RWK2VuUWI4ZGxWM2FxTWlDK1I0bzlDS1dEbENQd09G?=
 =?utf-8?B?dWNINmhEUzRWMDRRdmlabU9QYUlRRkIwNXd3aDdCUzFRcFQxMnJsWGc0cytW?=
 =?utf-8?B?bW1SaUQrWnZFcktSOWVkWVZQbmhoZWxRKzhROUZmamVPMGVPZjVOSzN3c2Jw?=
 =?utf-8?B?b1Bwenp0UmJhTWxzeUZia2dQbGdiNFVEU0xwbll6QVpCaUtTUzlBUkZqNWdr?=
 =?utf-8?B?a2Q0Q3BJSDlSREdXQlV3dXNpaWF0eS8wb1lKRXl2TktKYm5vTlFlT0RQbDNk?=
 =?utf-8?B?c1k1SkN6cmFLc1ZXK3FIUEZxUzNPMlFDVWVPSjNJRlBGbWFwRDNiU1o1c0g3?=
 =?utf-8?B?R3lCQzNCM1VHa2tEaDlmWjNCWXk5dVNZTkJWcUhHVWJ6QXBUbVUxQUVMUzN6?=
 =?utf-8?B?dlU5SU1nendRenhrak5NQjVjUGRRWktOTENkS3VyaEsvU2NSY1B3bnhyeG5w?=
 =?utf-8?B?MHQ4K09UTU03U0hQMHB4algzdUN2c2NndFN3UEZ0VGhnL1NJMStFRDFZTzBv?=
 =?utf-8?B?R1lrSUw4MmliYzVWTEM5V25ZRkNwaG9qeDdDcUI3RHR3YU5ZMWNxS0ZrT01L?=
 =?utf-8?B?c3M3RVk5dTNuRnFyOHljd3BVd1hCdWdUUWttenhyVlg2aDJ1TThQNFBTZlhZ?=
 =?utf-8?B?VEpkTS9EZmxyejE2aTMyaEU3WTVmTEkvUllHaGFiWUo1cGZUS2p6cTN2bWRl?=
 =?utf-8?B?VGErTFNhQk8vZnVYNEl5VHNnQ0RpZEdiZFQ0OHRZTVhsUVhaaXVYNkgxZU5Z?=
 =?utf-8?B?YlRsem15bkxWd3RjdGRPeG1KbFVkWG14b1RXUjVhRWpkbG0xUHlPejh3bVhQ?=
 =?utf-8?B?TXJHbUNEd0tXMmFDTHFTNER0ZWJmc1pObm4zVkhENytQS2pQd3NjVjM0c2dk?=
 =?utf-8?B?S0RQdnVpU04rTW9LY2k1aG1ybEE4dzVZakVNcEZNUWZCV0oxMWFPZHhlWXFm?=
 =?utf-8?B?YUxoNnNnWm45WFVuYnpNU2NGZlpodWVuVlNLZCtVeVFobFcySnNqS3BCdmRp?=
 =?utf-8?B?VFFWMk5hVDRRamNvVEdQVm0wcjg4c051dGdxem1ValpDRU1BNVdORmtjZWwx?=
 =?utf-8?B?bHVvbUxKUENpeTM2dHlrUjQxNG1aYi9UUWRvaDRLYzRza1pidVFzVllJSFVr?=
 =?utf-8?B?Z2N0Nzh5MlRvWFhGMzhqUXllRWNrNGhOOXZvcTB0ZE5VMzd6cHdJOG0reWRq?=
 =?utf-8?B?citXNGN0cFhDS0tvSEhoL2FoUXBicWVYK0NoVWJkcUlsbjVWdEN1d3hsTDNC?=
 =?utf-8?B?OWZRenRvd0UxUzNYdFdmeEtBWWtIbXRsTy9KMHhDY21ITjVKTS8wOHdSL3lT?=
 =?utf-8?B?aVNVakRIQWsrOTA4UjRKRDlGTHM5NzVIVjNFYmZkM3lSc1hXRjJWdURUbHJV?=
 =?utf-8?B?Mlg2RnVlT0lseTdwN01TbFdBSTVpRDBBYUhDMnhvU2NyL0dTQTJQelZVVjRo?=
 =?utf-8?B?SGNGK2U4a1BOODgzK0ZFSk9PMUZjZGh2TkZERVA2Zk9FT3ZMYjl5Nm5YWXM5?=
 =?utf-8?B?aDh5bkdwai93eW9oRXZmeGV2S0o0NXJhL2N2MDE4a2hieWloR0JVc1RXWjRl?=
 =?utf-8?B?MWhXS0ppdEJnaTU4MzhQcUJiLzJVb25zWk44bi9HWFdPK293Tjh3dEZDRlFK?=
 =?utf-8?B?bSszMHNNZ0luc0FjYWh6OVhUam9TTGFhUGZOWXU5ZUF5VFdFRldtblY5VUc2?=
 =?utf-8?B?MHVhZjVqN25xYmV0ODMxajVBVWMvRXhQSHdBeUVNWHpmSzBaM1FhYTRSM09o?=
 =?utf-8?B?T2w0emRtS2tQMkhiK1FhbnZuNHliZkdoUXNOb2xzNkVtcEI5bTk5S25ndmcr?=
 =?utf-8?B?OHhVY3FNL1RybHZOWWV3ZEVsZ2NPbXc3RzBYbUI0QUU0WW5pRHZZQm1LY3Ba?=
 =?utf-8?B?bU85VkRVbVVMMHFPaHNCeUxHY3UraDBWK0dWTWMyUTB5ZUoyUjUrUThBUUsv?=
 =?utf-8?B?Szl2WHBqRzFCbTlCWEVnMW9ZOE1OOTlOM3REZmtFbnd2TTBxSUM5eFgveFBG?=
 =?utf-8?B?em9iTXVlTmdxeGVQVFI0Q1ZCV1M5eUdxWk5ONVdSMHR1SWgzZXpaQ3VBaDBG?=
 =?utf-8?B?MzZDU1I4ZGdvdXB6RUZjUXZpTXp1VGFlVmRnblBTNlEyb0hSZzQySUZDT2l0?=
 =?utf-8?B?c1VjSExZdUdtdXhyUEdOYXFkNHRNZmJxR2gzbzlYeWxxTVdBUXBLNS9UQnJt?=
 =?utf-8?Q?VxT16qh90jUQHqWg=3D?=
X-Exchange-RoutingPolicyChecked:
	knO7ILSa/yr+ikkkKTJHyLyp13pjUS1Vy0zfRlfZ1vWRpYZmdzgn4F5P5m68Qxf8KpT2HPclmFVgALOkhQUL3Z6aDu34GzC1LIycZ7XYh1aKNSKWiQqRgGE1sezFLBkD3XeT0j6MCzSlIoluxkm74AI3nTHH5tuzQ7GVVmfBzf2rCKvXmZ7CtxnaWPl6v6xUJidf7UcimI6sEXU7p2mbnsD5YSC4WPvH/Nkcc3CDXA9YIrrhnPwmB2DSb4g8aDmqnRg1ZacLdZ8gUt9b1xGoj9FWxizcrQNS4Fel8xiEE+joW4zAF/shHD34E8hG7VyFCIa83O3KgETYTLGO0IStZw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p4EBxZ7Lv8cZdXNpCoKKZd42Aj7GAW4vQ2fRFILh2NUwhbR+53kh1/pJSPdYE9SPtjfqgcGVfEeSzOAnhFSk9VUa6Wi73nHv98yHUlMwsGldGmp8xpoW8nAeFN0dSd5v0jbttXZPXTP+5MTg4wq2o7F0V13FUGgY26MKHnwshBKjHQ/0B5bcA77wg/WOuW18xI9Q6vSAvw7IfGGKPkupVk81hifvGeYE5v8832aL7Ae5CZ1BzjZgfl81NUZWelqw32jhIkbdDH/yZAzM49xzgmsg+6tixfyq0Ca3o1VCXLN5fEe5g6JrLf6lFUU0z066Sw9byC+I4ZcqSjLvsqgDXOKmTh4Ajjrm/TAiyd8ouSmfnZ7bKkJGCpMeCR0G7GvdaFvfZ6v/UqOfwJ1RCFDzXxnioRlyAqHT3+/CZ1xbhqmSUKBxcQ9dkU26l9kWN5/6b7ljY6gbUFmArX+Twknu+W2hu3az4QYgvJXYv0fsM7WgPwRimRCzbI4TaarG7fxD6HrZ2NNKHNHFmIolbBxVXGydInBwXNndhySZJoCnk2GND7s7lS5FJhSrc9OUEnVmF8TE10/MIYHLBeGFmzPMo2ZFQtg5wDMLG2Neh1l4NGQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4b9638b-7441-4c73-017c-08def17c889b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:30:30.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z65ui15gdI6W+hIUZU3OWISP4d/gPlKLmTPR7ZMUdiqfo3vr3bId35LBj6lqvQ5cz1f3M8URCI5XNfiGnJ6CPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8753
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-03_03,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608030147
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDE0NyBTYWx0ZWRfX1xjeL+EmnocJ
 sr1NFZUZvqlrgDrWtgE2ojNl8iZbkWcGTIskxw1diptv3V6Xw4QlSYHLkj6/0FTuQfvNXlT+YPO
 sWcOUNzgOL6d5dhyEWcSgxotHcaBPEVt4SLPUwJNWFhOm5MpvjF/
X-Proofpoint-ORIG-GUID: KmFgRmca6n5wtmDqC1pWrqFbk6tqgTai
X-Proofpoint-GUID: KmFgRmca6n5wtmDqC1pWrqFbk6tqgTai
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDE0NyBTYWx0ZWRfX11Sz+PvjY2Ob
 q1n27TyNdlKhyoG4PoDezAEK1sXkZE47/HBbNzBabNEOzHT6QkYOQFtbi0fCoGbAo+fq9zhzXNC
 +IHB63BSJ71ozq/QCCxSDWgeQLFOXNjQAJMzwRIhEb+0waiVp8ECuGJKSUYu30sDmhdmc0zlcIt
 f4RlC5JGg1e6fEV07ryMlKY92X+nffevWHH/SeWLZJSrSp6E/7lbFR0qFBv/voeut0nmqGrUIoy
 aoq9zCkMjlqYABVG2uWlu2boiygU8AiJaLR5R8pZvB8mSNQkeewuM+5gO+aln+GFt7ixaMVca34
 4jpPcLKx02qynOoRy8/0XDLfHcONh2dKFroB+X2xE7bQuOXt0UkIONV1b/jGclhKjSuFdalcstZ
 iJtUk1LnuTZQTVBxruLXr8pWpw3qGnlOK1gDrr3htM40fWdqAd9+UYNHGidpczHWedLXTDzKfSV
 cg9tfXHSc1uDDfjOYdcikjMuLTkI9LACKbUiMV2U=
X-Authority-Analysis: v=2.4 cv=TsPWQjXh c=1 sm=1 tr=0 ts=6a70c22c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=RpNjiQI2AAAA:8
 a=yRFkrE7xalmnS3IKRJcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101

On 03/08/2026 17:14, Bart Van Assche wrote:
> On 8/3/26 6:=E2=80=8A01 AM, John Garry wrote: > On 31/07/2026 22:=E2=80=
=8A52, Bart Van Assche
> wrote: > > "Pass the SCSI host pointer directly" - that's too vague a tit=
le.
> Huh? This patch passes the SCSI host pointer directly to several function=
s instead
>=20
>=20
> On 8/3/26 6:01 AM, John Garry wrote:
>> On 31/07/2026 22:52, Bart Van Assche wrote:
>>=20
>> "Pass the SCSI host pointer directly" - that's too vague a title.
>=20
> Huh? This patch passes the SCSI host pointer directly to several
> functions instead of deriving the SCSI host pointer from the SCSI target
> pointer (dev_to_shost(starget->dev.parent)). Hence, I think the title is
> accurate.
>=20

I wrote vague, as in "Pass the SCSI host pointer directly" to and from=20
what? I would have "Pass the SCSI host pointer to scan-related=20
functions" or similar.

>>> In the functions scsi_probe_and_add_lun(), scsi_sequential_lun_scan(),
>>> scsi_report_lun_scan() and __scsi_scan_target() the SCSI host pointer is
>>> derived from the SCSI target pointer. Pass the SCSI host pointer
>>> directly. This patch prepares for enabling lock context analysis.
>>=20
>> How?
>=20
> With this patch, lock context annotations can refer to the SCSI host
> pointer directly (__must_hold(&shost->scan_mutex)). Without this patch,
> the following lock context annotation would have to be used instead:
>=20
> __must_hold(&dev_to_shost(starget->dev.parent)->scan_mutex)
>=20
> Additionally, in code that locks shost->scan_mutex, the following would
> have to be added to help the compiler understand that shost =3D=3D
> dev_to_shost(starget->dev.parent):
>=20
> __assume_ctx_lock(&dev_to_shost(starget->dev.parent)->scan_mutex);
>=20
> Christoph Hellwig made it clear during the LSF/MM/BPF summit that he is
> doesn't like __assume_ctx_lock() statements being added and also that he
> prefers to add arguments to functions if that eliminates the need for
> introducing __assume_ctx_lock() statements. Hence this patch.
>=20

ok, I get it, but it's better to mention the reason briefly, like=20
"context analysis requires checking on passed argument when using=20
preferred annotation form"

Thanks!
