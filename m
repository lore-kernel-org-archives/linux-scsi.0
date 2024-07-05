Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F88425761
	for <linux-scsi@vger.kernel.org>; Fri,  5 Jul 2024 02:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720147734; cv=fail; b=HXL4spEMWK/T4RWNrMDOAdv1wqDtgabaxuOxtQ7xZIf2Tajo0n2zgIodvUFNcQZjk0ujFF6hM6IDGmPIuZnlFEA36Okc0V/52YiBtBvr13Lpq9fbvaoW6C36avHtuAk1Ne7Wr4g9xqjrEf7mEV2VhjMtwjtXmz9lNC8fHFTPWZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720147734; c=relaxed/simple;
	bh=TVb1VmfFA3eTpRHmu0UXFB1OG97cFfN9MIkFEUU8/0I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=CLv+D7CF1Iq+Eiu9J540W97VLB7gfySIIw03CtI43GenlTzhxJkcol/PcQifyln2yUj+rGtOhnpYj6J9w0Py8z21Ag3S8+eRu38X50Ey5Gig1QNFomvTm0n2/BFGbJkENlsKjQ1csl3hPOIFK8PbK5BeTdEPGviBQhDd5ypgh9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lUADABZj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BjU6yk+E; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lUADABZj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BjU6yk+E"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 464EFG4a016760;
	Fri, 5 Jul 2024 02:48:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=/DVLtdD2wtJ6UQ
	O4mXhANYeAOkvKbHfwJK+lhO82QmU=; b=lUADABZjscF5TkwioFj8dS+Xx4oT5c
	i1p75F7NWsPouFLcf/cj2Gy6GWgDJ/TBe5biDi3EUigjdaMZIhDqdbGWXyXKJcJp
	trIDrIXkBih7SDpNGSvt7QatERmm6ynWmYIUlvYTtEkTyuMjnMghKG3ODteVqZ3o
	CFwynFRQx1sWwFnzCcgvPtVq8Mrl/LXVMeVnFikWMNdwCgSwlEc3NtNa8dapQAnK
	T26QpwccofI61U3KgeatIRspU9OqDoNBT0EdUzkNFTcuR8sSYVjq1fGKAYu72O01
	FEJCTDYo+Y+MKwdr3j8KahnjHRsgd69PJbmU0XSNxByVq1vYANVPU1NQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 402attk0sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 02:48:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4652bCVS024715;
	Fri, 5 Jul 2024 02:48:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2044.outbound.protection.outlook.com [104.47.55.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4028qbankb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 02:48:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9iBj9u1YYrnla3rQVAzvLIlTEt5u/QzS54N0n2LaO9TMynu/zW+V9tl4G4D/e2boaiL5p47jvZChIT9MKvCY7SE2rRvfx8iLc50tZ6LRq6yOlynuaP6gP5j7U2PvPUf4EB8X4lKaH4fdN2iyQ1pq03UTAkoAoJuQjJ6ux7RIH860/IFKTbRcErgOnHb81ntmFgDnTIZiFQ3/canryzhprFuJEhoqWqTAdYIZgDOazX+8CJvXB+P9OaL3DouGdRDp2DOM+/6cgXQ8oMoUBk/aUCWJkv2lMkO0D5tY+OzeEMCfqbA/VDZz9PfgtTkQOSDZp7SZKXCMmuA36nk15Ml5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/DVLtdD2wtJ6UQO4mXhANYeAOkvKbHfwJK+lhO82QmU=;
 b=PPy4PHSdAGoP5UIMN5ixNSlbH24fGdkQbj/J8vQW0T8JdD1mwwNbCLpMjw0MnuMOiwOthWl7UWi2JcexIQgzQ9m+CR7OCTVGtTsNdkfaAZ3uutSYjFtGfnGzCviPGXJKFLVxJHW0gYs3JDIORzcVhWbNjIQ1VATDizZoQpf3LNn/f3UIAY1SaVdJa7WAGloOcabsWyUWFeu8ItgoJqakVU0ZTlms8pxnvmCtgObQlilyxC7FKgJ9aiowxcw+jL5uYtBoBLZdd29IMVh3SzDy11o6n92kTO3EZeKxJugad+3IuVVLlBSDnAmcGA7F7AR5gBr8Ncj3J7Ydfs248X3SKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/DVLtdD2wtJ6UQO4mXhANYeAOkvKbHfwJK+lhO82QmU=;
 b=BjU6yk+ET2jnj+olQ47xSv8QmKP8qGjQFk661J4t1thpX+eTQ2WTYwUMvKd246lQX2cDsXSmENuQ7URyvZLqxiMl5sJbsvMTZhvqVek+LEdCxtrPh76gdmUAhmatSfm2mrS3IBnGrq9IRcHEuj2HLIdyiBRU/u8TD+S68P7z1aM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB4874.namprd10.prod.outlook.com (2603:10b6:610:c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.29; Fri, 5 Jul
 2024 02:48:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7719.029; Fri, 5 Jul 2024
 02:48:44 +0000
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, chandrakanth.patil@broadcom.com,
        sathya.prakash@broadcom.com, dan.carpenter@linaro.org
Subject: Re: [PATCH] mpi3mr: correct a test in mpi3mr_sas_port_add
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240627074827.13672-1-thenzl@redhat.com> (Tomas Henzl's message
	of "Thu, 27 Jun 2024 09:48:27 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ed88blkq.fsf@ca-mkp.ca.oracle.com>
References: <20240627074827.13672-1-thenzl@redhat.com>
Date: Thu, 04 Jul 2024 22:48:42 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB4874:EE_
X-MS-Office365-Filtering-Correlation-Id: 91606077-e052-4596-f7e6-08dc9c9cfc7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?S2Hz0qbedybXeGAK+C6DuOjVsYvwhMMYUCinN+hzfSOWeccd1spVY+41WwhT?=
 =?us-ascii?Q?+7jTpM1nlsUJG5C/6wGFwYS9ScJnyEg/JrgLGoaGB7GudD6Evv4EeEjTPAjk?=
 =?us-ascii?Q?4w4Ix7FMhUrc95ABYBESKDOW7M/YZLVxMYXayDtGMabngdL+P6LUMp90Jtea?=
 =?us-ascii?Q?c1yaWrxi9eZFeX5/04Mx7D5RXyHY3Xc++OwkpP0PACDfVXjMv10pv3byGjek?=
 =?us-ascii?Q?K9TpL9RlfQsPKVGwN3upcq1tprKbJmDXBQW66vTU0+3Cqyvf12XCK8WurFf0?=
 =?us-ascii?Q?TIsX+5cbiJUxmRjfkdBZpx9qEboqVAtiEgfDl+50lkys72x20j19jcbCkq1o?=
 =?us-ascii?Q?h2kdCWpCv45ZrFvyXJrdUiai+X2FNYnh6mhrRM4d/wcMB1DLP2sp1AhgSbCp?=
 =?us-ascii?Q?J+oj+JAmu+bWgkDVPkzJN6ft7UfJU2kj5V5sK3chZa0wuxwmXElgDpP2IU8U?=
 =?us-ascii?Q?iH/5WRQ2PCEekxMVL4yChmc19rjPC4UJA2cx1vfUGcGH69m4Qqf2Wm5ye5uj?=
 =?us-ascii?Q?rh3sfSwws0YaohpzbfmFyeFGdHRKd2QtPe9YK+d/o1IkRzIAtfgT1BMZxPyH?=
 =?us-ascii?Q?HBpWsGgwOFFuG7chPdioVQI1U/uBb6cIkVmxhjsiL28GviQeYstBdYOcrO7g?=
 =?us-ascii?Q?CbOW4QZfc/wUFGIhoSBXdruoY98H7zjH5xhCJAyURamA88S5nUbRkWKwU3Ow?=
 =?us-ascii?Q?g629jZeWPlhQmQegmEztzKTwi/D77yJWmvnAjqyo59Vm1EDMY5D1kMGUx8h3?=
 =?us-ascii?Q?X7aa763FOYH9KYEjqhN0bzDys5MmWO41AqmXYhAMVpEJyGspxt1izx+OuysB?=
 =?us-ascii?Q?yV0vhbV3iQm4hdGCV2tZpAizvkYDdlMweHyiuPw2saZ3mTy7js9Rg2mvgEyJ?=
 =?us-ascii?Q?qaMLI8nYnTrDW+PEftSlXBK3PwzZAuW1sZ3GaHFJ++rWqmIoXkcjml7JYnsm?=
 =?us-ascii?Q?8EnWZnWaTs4/jck7abwJ4Q/8y9MqsASXx9qdDQScBvzmkhBeV+D0v+DaHJR2?=
 =?us-ascii?Q?GYokL6pPFbnF9MnXcA7YNeZhJ1iJVGBBl5Cy+gzmKsii29hT+STxK+387l9G?=
 =?us-ascii?Q?lggwBfptMcWK2ImSOB04mj5GwlnbXH03yjRtVxuHBANN/ewVuuPtsgb8RGsa?=
 =?us-ascii?Q?T/mH/PEOReZd5P00ydpdg1vJ94l3sWtfMVHUq61mqUd6qAlHIToCo9sWTujj?=
 =?us-ascii?Q?9Zp+Ml7NWHM7MsUPmfqdOe8e6HhAyyI8ZXGouIK71ipBQBBeOnGDhWgIybX9?=
 =?us-ascii?Q?AJ8eOUNzFIs42eWdVzhajdmqFn60lm35IPCHj7Lpgfu725OxIqaKTg6bP8FP?=
 =?us-ascii?Q?SQFSsB7+CfyIkSPrtF41joFeUshMfbuZuFh1kk8tnsXgFw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?a+HhQHN/Cjp8YgMpLpd7QEverU99R/K+AAjYvrm4wbWrm7t8eEqsEPNnf/zW?=
 =?us-ascii?Q?vZJ0BZg3kiIhsJyRY1UnbULf8FCWUlWrT9WAuUGyVQ+N9IJDC86FWRBAOfnK?=
 =?us-ascii?Q?F6qAA5E1aSIZOPhWgam0XgkTdtB6cftD24ZEbKoGTmaA7y8FNMbYMBiL4W3x?=
 =?us-ascii?Q?SRalLgFf6BVdv0Z6WPZPr5jWeKs+QUGSg4ZO5lkatIP8hbLhqvaKFQ5dTLEv?=
 =?us-ascii?Q?5p9ywBwVJWgkKyXHCO4QIlbpOGBWwf5JkwHPmKmylbTXvPJDYZ6qCGsqz2q7?=
 =?us-ascii?Q?x7FyBUOkAPMnbMPabTrcb2sg+s60gCRK8ypzrUNc4xbLlB8VBP/GurrZRf7k?=
 =?us-ascii?Q?7iIEraEYpymhR1DzuH1L4+4CLs9KyS5vd1qjfCYNVNJ792o0v4Exqwla2QMR?=
 =?us-ascii?Q?xVI/GkGXYjXx/+0WkM9iOWY2yYQ20sJfWK1RfJciI6zuOtyxpVNdCQRRwu6m?=
 =?us-ascii?Q?5T/uFPwUL6O6e8lk2kuaKhYfSMAJgOL9aZuFsbvgPt8Q6LnBNbAX0/6LqGQX?=
 =?us-ascii?Q?NZJu6g2LNfYLT5yKaBPPjaVZX6iFgCB4BoflnMque0NoH0C5sz/13gI6Xe9m?=
 =?us-ascii?Q?WDtEvRTl4OfcSQNyEZqjRvzXmIyHXfsuFeGXxZrGZdATxbmsqX4OAsf9Oo4o?=
 =?us-ascii?Q?AEcOb+4m+wnyrh2wPTCVcoNtJIhk8fQwc3mfQ7N4Me2w1Vhr/nGYHy7u10yf?=
 =?us-ascii?Q?vpI7j8SSneGRcAuCn80yb6NCuY/FleEC/cHqR3tM3kwSaBbcX9kr7uYRTzdx?=
 =?us-ascii?Q?i3QBHsaxDgKorN5Fb89P0b2Dj3gAG4gJ9o1ZmcfRKHhCaGjQTOrA3Qpf96/a?=
 =?us-ascii?Q?WYPL0VKnHBZAPrAObSj3JrTxj/WlJWg7DGkkx0AayireAm/C3BhjNndyCNga?=
 =?us-ascii?Q?+RxTJylBMfg5Cr+u/PBJbohCgzIVAfETZ6t6Q9LpslplaBqhcDfFjcNaG4XF?=
 =?us-ascii?Q?PKkjiQ+VC6ulm9uI02l7dy1QBZg44NKmo6n0mVqGHm2gYWGwSSBy/ISagRB/?=
 =?us-ascii?Q?d6tJ/SSeffh9STIyS1vIygaqrVKAnwmSgC0h7aUjluAgMIX9scy+QNoAiCDt?=
 =?us-ascii?Q?gVTSi7AmJ2GO3N10We67pYAj94I2hMvPJicMgwCYoVW1bPW4M+NAJbha3HXC?=
 =?us-ascii?Q?43+Rg+ShWMxEzX9AfzjFA7kyaOdIpkCxHm8exbAeAoCypqh0JQIZ6VvVUP3w?=
 =?us-ascii?Q?GENuhZfrnCyXlLTf626MZkoIqkgtgtneps8WIqjNMzW71I1NzUpz8KjNnMUR?=
 =?us-ascii?Q?34YtfM7USG7+fRF8B+p90mSmwxDFp7ao1P4DeWXQivSOCteYEUdYG5+Idxj+?=
 =?us-ascii?Q?MlNCCoZiZs4aGbkVnPeKAupdZumrf0M/3e8fsvZ5u1NoQFQ7tX7i+CdRY87m?=
 =?us-ascii?Q?dxDl+Ae0g+ad9BzIFhlnKbKuTbEe1O72nlD/RUJFo9RALJiVReMANUNggkjW?=
 =?us-ascii?Q?lzjyHIE82L5yPysqpK6ibY+WcVfLJGnOLsMlS/NQeVY2PaY8oaEx4zWyFueY?=
 =?us-ascii?Q?fhpObzOHAoK2Yemwf7O/RqVTLg+HGKIfEacc4xuPJGyWjtHkcC+/Vk8SJ9IE?=
 =?us-ascii?Q?C8a7AH962ReMlmAEJCv4rDwOKKxATggO+L9OlCwrTaVS5kscADJ8MT43inhT?=
 =?us-ascii?Q?Ug=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	vGoGRJt/SniKGxUlOsva3xp2KCNN6cKkgvZMDzsRmtJNyjObK22s1vbGdZcRfxhfVdfbShHGVVv5fsFOeBuzIVUCwLWRc9megf95obbqdypMW/SQW2ov2Y9V7b6z9E34L9C+bHVZQ6X1GEFM7w8l5VuHGCWi1xPNuyTqRPsjJzI9VzHZFhz4M9XyPemxMXInshgsnOSJybCNnnJoSxEtF/QLilTBFB2/vbhDw7Kt0H/8hKS5FQ4IhuOgn2gProCbleY4IyyJMOfi5m6X1Key3Nvry2D7OrZTsDSAbCSyNi4SZh4pss9b4xns8pae312brsGk/P2epw+kExuJRTWnPe6RM2AFiwQzReauPC96vCJZxbIbagrOtiBMDEb8wUGwFF+IUgyoG0W6c1t0awknPT5I1SHl7cgThmryfGneFAX7IPx/AjscRJTlBtVuFax5JwepiuOKA2cIUv1wJmH9hF0SGrPlF3lep0EXqAHK9FrwNeWS294yr5Us0uAi92mbTlbmGt6vzvA46deM4WAz2pfFePcQUVJkDG0pdoIoQoBh5YYYv1Tk97wXRyQ1tSIKqFqHBxpdsVEig4X+2ouG5t6ieCzjzkbexrZZ0yUFkKo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91606077-e052-4596-f7e6-08dc9c9cfc7e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2024 02:48:44.5739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BuGUeWmL6pqFBeG3NwO+zazWQIHektFPDa1p67G5nGdf18o5TBznrjrcvo92agV03BST4ss10oA2tohUx2sv/7+ibQ/qyMlAJK3NzWnLUdQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4874
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-04_21,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=915
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407050019
X-Proofpoint-GUID: mDV-6-_GIx2ltuxZW7RNsqoGF32HHYis
X-Proofpoint-ORIG-GUID: mDV-6-_GIx2ltuxZW7RNsqoGF32HHYis


Tomas,

> The test for a possible shift overflow is not correct. Fix it by
> replacing the '>' with a '>='.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
