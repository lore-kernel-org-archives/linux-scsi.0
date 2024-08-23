Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62902594
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 01:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724376755; cv=fail; b=PfO7oDdPIk4hD+rTl9h7ESV6Bvvxq5e4AstkssYI2SOxUDE419HYFbpIHC6hx05rgvaPd9qgmvEY7bK0t8vZLeQizfzfNwV+eamdRXFWUPNwUIZsFjj0CM+SxLk/cYbs9+gp+IDg+3Cn+PPf5CKqJEZswjCcqx1Tft6kI+x5v2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724376755; c=relaxed/simple;
	bh=5a/rjK5MfbmUPEh6Wv8DJCxuaGkcBj5e8uDwhYkvh6U=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=aRWlzxBzhozHhPxDpOlNrSsFemuK5FWWXJH78cb1EmAKkyViJ/k/wgL1iYWOHlWV7azdGvdljrwFv5OL5ZoOdEZdqzeGnukWnbahUXRZamZFF4kwk3mTN4a/QPiGoBQQxjgKlQG1i+AvCW/HRiRp9P1unY3V8mope5Yv0/K0idk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i4GP+Xdg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bA81Ny/a; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i4GP+Xdg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bA81Ny/a"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0BYBC007201;
	Fri, 23 Aug 2024 01:32:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=F3JGHw2C8wLX4t
	Fd5J2P/s0sYEEZfZh44ickoJaTkM8=; b=i4GP+XdgBnDsaiqk5qgXkyqAnT7aMv
	IXX/dsBYgOWTQNyczfMuMBd5o63x5ZH7Ei9CSJWbXEOlrIxWTtdm0VO8CrRPXne5
	cXilcprik2R4Oth201XZfgwT9114FIOzcK3LKV4eamEUBDA5IgnqAwiXaLc3Z5di
	HBjl8wYWKRs2oIu7IdWVlCSt9f0cJ3EdVBEchjM1Ugo9VScoxlGiIp8m+JX417es
	ZIFuzTxhmEls5kVSD1etMydYDNPSsl5r+Y/EMOAHJqbOSXN+N8fDq48atoKQc2t+
	+re9ftuPeCOy0Mv/A8v8abjbnKyyUScJwnrpe/99r2rDqYLghQ2cfwYQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 414yrj5jtn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 01:32:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47N0tGL8027750;
	Fri, 23 Aug 2024 01:32:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 416g9xgt6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Aug 2024 01:32:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N2uzvufjiP70ytQgkvnh/Uar96zJbfqas+9RZWF+wTvnkGh1NKbadQGkRio6L1VzccHUDJZMRDcvkYXzZ/jW1Wjp1OkwzK2+uTtsbW0VfACRKI5FdJ5kxxgL7RoGCacwX5YnQD5/Sj1UYPorIk1QjXW1DLdO7/qmLwgRt9AkfcjkkUigOvkLzqEnvFV2e18AxxXklSteCGkE6rJUB2zWodJBQkc9PC5QaQBN0V4CnMjWegT7h4vASSKIG7o6hL+xckFxNe7yNA5qxVy0kjAd2brBnDxYieWb9XNWuHCOQ5oJBVedHXvlb8PymDyc8/8Vp8csSNaMWuam9bcPVncuZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F3JGHw2C8wLX4tFd5J2P/s0sYEEZfZh44ickoJaTkM8=;
 b=n//YgU+ow2kY9TiK4MKxQ1as8GbASqcpHDjqQZH0LbH3vdoUSrOxirUWSvalvrBsuxlxkqQV7SKEsHIi1vgmnbxlwlkA210HSMNPIpJunc5BE8pl4nTV9bzqbFS8EKu7vZEKcFCmaolTARLz11iEBsMjR4Q7GAO64xzJxekI/Zwa0HS1Deh0HjA10yHCMnN3ObPCL+cjH3kXBU9zUEjkkfOuEdXByT8vz9cH+GaS0H9s+EM2aQXJy8wodu/eY7C7cC4RGjWYrj+O4inKesA0Q/61/4SBTo+CubUv7mQ8r6XViKUr4Tv9mBIXLU1G/fLMUmBpdyDeaPB31mXpw8yb2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F3JGHw2C8wLX4tFd5J2P/s0sYEEZfZh44ickoJaTkM8=;
 b=bA81Ny/aaeXhzbnzJlS0cMtEtnjDjiN/r6M4sFIV4fUEXBsP2vylIzF4qEA1zJYXYaWjbQf4OoZjOEpXAA7GVFQPsLdrizK7UjcQgEGDmEKGvPxJ/PWAuxH11Ugys3evovB9Z0R80yaL4cePleHskRj2tguUtoh3NYrczEF4Gfk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY5PR10MB5938.namprd10.prod.outlook.com (2603:10b6:930:2d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.12; Fri, 23 Aug
 2024 01:32:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 01:32:23 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 00/18] Simplify multiple create*_workqueue() invocations
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240822195944.654691-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 22 Aug 2024 12:59:04 -0700")
Organization: Oracle Corporation
Message-ID: <yq1ikvskorn.fsf@ca-mkp.ca.oracle.com>
References: <20240822195944.654691-1-bvanassche@acm.org>
Date: Thu, 22 Aug 2024 21:32:21 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0024.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::37) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY5PR10MB5938:EE_
X-MS-Office365-Filtering-Correlation-Id: 81b36828-7342-4b34-3c42-08dcc3137004
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RwrIIFb25TLaq6oBSPtHbHsTkKnUVxo+O20AjYAVunETH6Cv58mUTf2dIb1e?=
 =?us-ascii?Q?Bx9hNQZnRV/vvn6iW5zkUnL/jCwBCUt/DPL+u9bHduNS063DzKk1SV7bilzA?=
 =?us-ascii?Q?x8sEfaCUOxbn4JeQCRSXA2txAz+3nONRj77kgq1M09NbBsfjB/ONQiWRpsVj?=
 =?us-ascii?Q?Y1dzWm9CFXlSnlqpAYrENPMDPcoPeerBzc/OMXuOSdQyIe5zLSp/LqDp8a6o?=
 =?us-ascii?Q?owZKwgpO66gyjNuTAhX6OuhFhe1IUnm1sFX8kCitsQEZOspFpgE4AZlTlPM7?=
 =?us-ascii?Q?lrg7b+bl/kzy324j2+lqKgJhEMXL7Mo4AoReCK1XGW4/xBDT5KVbNRGVRhSs?=
 =?us-ascii?Q?IA+1OozWyuKRpUUEgyLEvC0MGChSU3DCOkmirvFnOoTaXEFVMVks0AeV0aoC?=
 =?us-ascii?Q?+0QzMWo04Yx9Jux/nf2D1aS0MS3PRtNmyb87BJoIbJAOpuRQBUKS4oyfkvhF?=
 =?us-ascii?Q?+T4xm9Cr0I5eMZ3ACYgC9nJzO83YCWk6aAFdtjE8a+JBLm75ypeivkoh34A0?=
 =?us-ascii?Q?CgsqBnPO3vmjUy4dfOnDjJcrcBp1mIVunlRRP0MclhpAtdNVhyhrTffTkPmu?=
 =?us-ascii?Q?GQ3Vh2PzHbEhqNJmQOu9tAnac/2Vzl9zMr6C1AHXstqVAdaYBWhjbo/Lj3L0?=
 =?us-ascii?Q?5PKOlzEq6CdUjuqNilkXiL2xwdmsiZNrpg/G12WmWI9CwIQ+wzff4i61nFog?=
 =?us-ascii?Q?df7tqL2WOxJIJQZblV0tZvyiieVovVxTBvRvo0AjKNGmoMGfKjPwM1a974sB?=
 =?us-ascii?Q?IJ2dUVv4GsMdF7Y2jX/HXgKs7v0eiKte/I1QzwhO+AgOSlX8vmr9X6Zu/kdH?=
 =?us-ascii?Q?xS4v1GRuas2atdsUDAmWRSjUpDIkWfWskzRkGUkWbwGoU7gPrwC8LuW0XQdo?=
 =?us-ascii?Q?1VlRArcoJgxoB7FD/joIpkFWJspEX24x1lOxacHamPyw8Rcc9z7FVYnNzxTI?=
 =?us-ascii?Q?mZ88M+l1pqdivOGkBEOovCbWQRxn9GgSYwlnOJMzy/T113+YfUxgkgun1kaD?=
 =?us-ascii?Q?gheq/4dwMh6AEJPT43KJPmJfrWRYtosa6KX2RvWa63gD8Okgl9DewG1GFYSu?=
 =?us-ascii?Q?NOL5uylaBOIR2JL+M5KxxGtjZ1jPEI0wHg0VegQaYPu+t2zdd85xhreh+exO?=
 =?us-ascii?Q?sLZt4Wg9cxXm7aB9pl8LxGlDDfZLxUFMqMr8rr1qo5y0EbUZne2GSo2O5hru?=
 =?us-ascii?Q?v90fFGcUTAAO2FAqSQLCevH8DZha3m0VHpqxK3Lj+t4JxQ759P5sqNnhyBDO?=
 =?us-ascii?Q?+Ly5hCB4QruJSF11TC7gzQLDsXGWvir8H6Nytq6jgp8rAwe36Sb5/wq7purt?=
 =?us-ascii?Q?YKDNiP0SCHEIgzWZjibrdGvk9/WpG5ug0LFs45ZwomZ7cw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VmkvKxfgzZHW/EoI+Z3H+jfEIY1NGEICzuam9zy+TkjL0yPhpsqG9iyS4obz?=
 =?us-ascii?Q?tRvzUBMDmkl45Z7KCbrnw6ACltL1liAOpe9oqyIsMEJOd9lBNagvE2u1bIy7?=
 =?us-ascii?Q?w4xIHzkGp692sz+SdNjOsyUXTKfj9EZ2xy9evf8aGE6rDs6bRhQmfuNogxDw?=
 =?us-ascii?Q?+iWINKs/CISfwEodPYiv6ezEK1F8AkNuUEsz5mhLUltY+jc1RhJvh8lmmg+X?=
 =?us-ascii?Q?1nIkkrseJSU3qzkl3Z2hCTeMLy83jab/Nd6WvStFfPt3BM226TfIcgHCzOHL?=
 =?us-ascii?Q?L3vn2PICXRkMc9sCgPlDf7bLkRPqs7oZsoi47nPQEVAyEaG+Nw87As0cGWdp?=
 =?us-ascii?Q?3TwkX1CzX0cEw31ZeKWwjPzi3aIqIU6fOH8u+WDhw0jQB42LFAHjphWSAoAO?=
 =?us-ascii?Q?TO5PUw5ebayVh43oT2AGepVuth8uSIm2BpkhdIYL6u4HP4cfFsjaiPRhbB60?=
 =?us-ascii?Q?a4C1WkTpaxuxCLnQ7+8Q+S1gccG9Rgy4KcSg3uQEvieKv7knse+S1boB3SyV?=
 =?us-ascii?Q?/IveSVQAIUjcyTiImk5Qpaeq500XUIi/6bmBMIIxdVnoUS5pFYyJr7MxI8l6?=
 =?us-ascii?Q?Qqr3cayniz4GxUL0k8iZkP69fNwf3h2eys20MY/hF+UADMdcoav3GgCXzKP6?=
 =?us-ascii?Q?tC49ADX7Iwa2vEzw1p56i20vLj2dzh4iRMntWetTsFCLSg4aFwTLLRfyst1v?=
 =?us-ascii?Q?Z9mWed7lsv2yBxCVvW7BAFtU2ntkeruKfQ8GTcVrizPNg8NtAnGBh4VZZ7jg?=
 =?us-ascii?Q?MGkBTXpLWb0h2nomDoXa22oMSEpLgn64/G+zUGtjTEsqeBEYViaWVHMutiWy?=
 =?us-ascii?Q?AFf8vWMLSyqWNA3sBJJp7irBO3p+jw1ezPv3cuqc+Js5AnOUxusFXdX81Tv0?=
 =?us-ascii?Q?mDpb1uYhHfR7ZoRsKygv3houC6PQSbigen2WRaG9hv3uwhilawbrOHaeZ5tU?=
 =?us-ascii?Q?jUu+fal3k97eGeD4r1E41o7xgEvqworJ4b+vk+i6Rxe8Lg50Q+Ls7DvFf0x0?=
 =?us-ascii?Q?F4AdsHI8dMIaLojCFd4kt4HsD8CVdbxjXUr8Vd0UoEdsx+BT8sL9sdVWuh54?=
 =?us-ascii?Q?rMq88i5vAQNj+1OImW8ppjHyBGit3IQAq3Czh81xrphuSvpjMOpFu9iXO0rb?=
 =?us-ascii?Q?8hHWMXt6+P7ZzKcPwnINdMGADiEFmZINAXM9G9kNmVA8/UJEbu0FyhvNx9So?=
 =?us-ascii?Q?UrhvGDVWYW05QAFDDDUhMTU120DIYjd1WcBzus/YzZ7mnFaJ1gJLbMuYCVum?=
 =?us-ascii?Q?Yj8Nd5gFVyswtfodSHlLwnhnCTTNjVQ3LoMxThs/Ht5I81+5y6O+uuFQwzg5?=
 =?us-ascii?Q?4IVCpQrbTKtVJOEkVeSsyrNwr6ulaLw/ZqvxIJ24p4Zm6hSgGUlgj4Vv0Z7/?=
 =?us-ascii?Q?OQcHEo2HqHph5U+xwOor4HULDiA8OlZ9g8KAHn5+8X4F+SY0AaMulYWbIqbz?=
 =?us-ascii?Q?F8MzGX15fUJMJ9GmEEXOZlA2zo/9JpEMjtHVCeYCg/m5pN3/dY/EaHfKHwTt?=
 =?us-ascii?Q?GMu/cEEx2PjVaHqxQa/kRBDE1ytTXgam2al6xqjGAovYLgh+oQuJMYMLaNu7?=
 =?us-ascii?Q?l6t0wkNTwtb93t64RUCwu+UMRlQCrew3b9HzmOkyvAUtrE0h6ajnxofk4UHy?=
 =?us-ascii?Q?9Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	acdMj5txcSn0GZCy98YzEv6+hHNBlo57Pj5Z+eg4msLkept3k1Y8IeFzoCey9P33Uor35qXhok3iyEC+r62r3URxE9zFE3QkCDkvVgxyo8diRnPf2lKZLfoMBYAySnJcr56DrpFpR8Xa3rMxrUhKhkcExQRXb2TZiMvi6JCAmnAHom9VksJx+VuydmGzim4X7kNVoQsrrJ2MpVsYQs44L13QfRnitCue+4w/9Wqh0uiedLFj/Du/9NNcFtaWlgc8wRor7fWbYR/TBchdlnwZK9vE/JWuL3zxl7FSX+UJgmyUj1a9Ytdhbz2MM8u6pWb1aqTcjtYWhEclhezv+YxALBsmAxAoEUGhwR/VRBo02tHi5v373wCw00s8Ec18TS7TT5s680MyUhawbJKWaqgDcqLsOsMLeC7XFHr7KebFa2RUMF5Y3wwlaOBpjF8O50lGLK7ch+tYFKnnjuns/36TXnq791uneLI9JzvCr4gMb2QOhmcvwVsw7jOiHUEz8Yz4Nb+GmZzmFj+Chf93ge2tWTb5qj0QrZlK0x8x/RQfhfrh1cB3Jl0fFlvuhpzrh/P6kTHer1EsVb8MkF654qKlYDVDGTz0kuviSkbIupKmJdE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b36828-7342-4b34-3c42-08dcc3137004
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 01:32:23.2361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8a1NsDH8meMZxdVbRZfpbUrPiqRzw5JF6q0MFHaT3rbWA655emyHs1XixJAy63JRBKQqk/CdLp1rya0VIFpmv99DTVVhfhGGarInKzSGKI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5938
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_17,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=709 adultscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408230009
X-Proofpoint-ORIG-GUID: vTZRBb-FCCppm1XQkmOICL0p0crlrE1Q
X-Proofpoint-GUID: vTZRBb-FCCppm1XQkmOICL0p0crlrE1Q


Bart,

> Multiple SCSI drivers use snprintf() to format a workqueue name before
> invoking one of the create*_workqueue() macros. This patch series
> simplifies such code by passing the format string and arguments to
> alloc_workqueue(). Additionally, the structure members that are only
> used as a temporary buffer for formatting workqueue names are removed.
> Please consider this patch series for the next merge window.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
