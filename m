Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E674879CD
	for <linux-scsi@vger.kernel.org>; Sat,  3 Aug 2024 01:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722649861; cv=fail; b=taJBhZzcv3i+98W832lX97sRCf3eu+kFwWPKJqHce9jY9uo5tujMg2Dt4JkB0TPHc1QTZFGh+LTKRPmH0kGa9N6a8LjGjHAe5309ZAvMai1lyU7TglmVvhRGf/6MIxlTSJ8Glj9dddI1cqqPcuUYiL/ittb0vUyM1iFzc2+SsnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722649861; c=relaxed/simple;
	bh=Ijt8nGJwd89/SumXzMb7zXC8BmNsw+eYtzzX3GsQPfk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=FteuH17CoArvS8aK5VprrBOQgFK6/hF+2LA9Zkygb8V9RSORbdNlvt2tusUH6o9tGDv1Q+JWySa/9tkQA7ruECZ3mYPWv1yH+3Q3ItWlnmLrSZSEH8cOLcvAHLgQPhAZ1LZm9TI9Ue9B3wwae3796IxyW5YR0ZxUxrzocHnwRoc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bQ7QGPxC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rK7HMPlK; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bQ7QGPxC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rK7HMPlK"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472GtVFa021637;
	Sat, 3 Aug 2024 01:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=VIBOVPPtw3aXir
	KRI0TI6wbrxeNMAX6ezOMDSEi2h4s=; b=bQ7QGPxCfS/AQhcABy/PKTWP10Vflj
	d2ag+X3zRSbP1MCX7OOupDsWwuOqER2hcwl68GSTKmunZDSg+316W10SExhJo+u4
	MjOoqiVuFpmesJDFT3x/QuE442yLuGrPndiOdmGcdljGs5hwn051vGWVejjpZOHl
	Ky/xdv7hecruSO8ABPhfpCJP3dOkhsSYtcKuExo5PdW4/oDKB7fSXElbGV6I603T
	6R6qWx6W0vdBhy3JEeMDcwbJDgyQeNUoQ4VCmtFiMyjdye9JDrm9hr+k9hqMx5R4
	d1P0y8qskYDbPlorl4PbkSJvJHMSIvA+YDpz6rBhLtOLU74vGtxDKmdg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40rje6ae8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:50:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4731XdlF016944;
	Sat, 3 Aug 2024 01:50:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40sb06r7qs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Aug 2024 01:50:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DV/vFw+rUN3Lq1tXZARyGluhcsMN4TqjtafLOSGTJAlh2fwvDAv/9TltcXP72RPPA2uZLY//NczgCuS6Xp+fKcAi37jMjyLI0AAFygvSozKExCGXJgND+EAEky73mPq20ykwG08fzS0joidBh66yDTeqkgjMcHUZIejrnqeFR2p4m/MCHMapMr7YwKqBFK0aPrSCMg1WWv6nluPouRJFUwcXWrovFUQUTHvesEi8zxrlX4kLsVCL5u9xOe3qBWJSg4ItmAds9zs8WQq6DyShTKxFnSfqjpQbUcFQzSXrA+YKRaEJ/OjPaGsVtSnQk2Q7mCFl0kZ2bYMgneppwpp/3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VIBOVPPtw3aXirKRI0TI6wbrxeNMAX6ezOMDSEi2h4s=;
 b=deLCRPRT4RnjeCbkCsQj71PcZyRGRtJXzDZZO7ylHpLXUGa7YEzqIhBLOGTWz4CAdjxZeVAqKejBWilfp5uxKSAIYwsr2ErQbyBLAZaPa/d/x/199ZTHcuTh/VH5ws/O3ohiDxj8aGmMJGROZOYVCfeWk7LN+9Al89owXf0KxwuCUbltC8a5ph8XXuXT5hCHGukBHfhXtH9vvuhASc6sjJdG6R172ps+5v609Ax0GkgUgMDHJiU1ATjmHo/hZSn6/20gDx7DMULMzEWGK3IlY6lTJkNvC/mhB7voJmPo9ehNXweWNbWyNe2GWjWYZQNxdS3Vq9DV9JSDkqjkL49W1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VIBOVPPtw3aXirKRI0TI6wbrxeNMAX6ezOMDSEi2h4s=;
 b=rK7HMPlKt8UrlyVvKjzyrD1zsNAThaz6EMHFex/SVrl3q/q25zjH2VmJ8xpIygvjjCw9adNUwD9Lp8CEdxsXGGLwhrdyd8Bc7qH4yuS8U7Sug44ZzTjcSwzEFvlsAwA8ZqPCQyBx75Asuvxm8ZzKBhshl9JzWeFaPdo2YfqtbqU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by LV3PR10MB7963.namprd10.prod.outlook.com (2603:10b6:408:20e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Sat, 3 Aug
 2024 01:50:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7828.024; Sat, 3 Aug 2024
 01:50:50 +0000
To: Justin Tee <justintee8345@gmail.com>
Cc: linux-scsi@vger.kernel.org, jsmart2021@gmail.com, justin.tee@broadcom.com
Subject: Re: [PATCH 0/8] Update lpfc to revision 14.4.0.4
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240726231512.92867-1-justintee8345@gmail.com> (Justin Tee's
	message of "Fri, 26 Jul 2024 16:15:04 -0700")
Organization: Oracle Corporation
Message-ID: <yq1r0b65q8f.fsf@ca-mkp.ca.oracle.com>
References: <20240726231512.92867-1-justintee8345@gmail.com>
Date: Fri, 02 Aug 2024 21:50:48 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0028.prod.exchangelabs.com (2603:10b6:208:10c::41)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|LV3PR10MB7963:EE_
X-MS-Office365-Filtering-Correlation-Id: ae640e7e-f33f-4f02-926a-08dcb35eb3bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hxudvZ6FBhOXzMgDDCp0XPd7rAlIg8wP6clnGC6iv8N3167B8WxEB6mSPx6u?=
 =?us-ascii?Q?Ra95qEX+Gyucutg/nvAUpqMIpyifOYTBbpR1T6JpiuHEVsXILMSeKZ0FDDbj?=
 =?us-ascii?Q?UFT0aUfWia9Kfm+3WBsAL5xJiiTK3IdEut5DsIIQmJ2T0Yq5+kpv1zpdPY+d?=
 =?us-ascii?Q?H5XzBgAZB7ttjau2j2xZvyVcAnzwSkRHWdqCAfQuZEUtsFew7E4q7ibbxMiy?=
 =?us-ascii?Q?bImR+ms5vIpw52e+s2dNRe+TcLz0Fd786KFjsyIsoFzrtIr3mLPLlPV8g9NU?=
 =?us-ascii?Q?7QaeVpHSMBD3TV5I9O2+VsVjqlvBRDPUP/0+4/8m26oI3EniVZNF0yJDHjun?=
 =?us-ascii?Q?1z/niZqA8+cQyuhK/YfmGfVjL6hmi81o5fLTTD6NJ1qv8kkEJ6bL50jIH8Ec?=
 =?us-ascii?Q?+unPztQ9ghwGxqmX5matquyg3gona1CBy+dOvntjirmo3PnOaaOtwitOneoh?=
 =?us-ascii?Q?s1yDgMs5IOi/4rNJXogQ8dL/QGWxGsMSmyjV6F0iPB4tew3R9ASla1TowIop?=
 =?us-ascii?Q?u//U2roZdx1nwp5L/wXAWa7CwmzS04fZsXgyJebeRyquzeyxS0RYqBgreScs?=
 =?us-ascii?Q?0HtDNXEpMuKAbJsGW1BcEwqjBGOxrEoPR4qPiTxgverrqY+eEEpf1hnd/8PM?=
 =?us-ascii?Q?8CBdZrSYEMRqBf6fOi3wkB0yvZB7Zz7KBuBsPExagjlNtG/s4gHwHKBA3q0n?=
 =?us-ascii?Q?niLlRrP41T/uSYoL1DVWCQ22ays6WG3wGDgPMm/H35hr4XMl4Uklsa1Bi9e7?=
 =?us-ascii?Q?AMKnZ7P9v7F6Ho2gBnvO2+n+OV/ld4DWS0RO6eZAF0L3a4pIf5+ajHqA3XnK?=
 =?us-ascii?Q?MGpD1T5AB5Jc3nazGPQAtlPIL7JxsGJS03CknlZ0EvkKQQOcB1GbPSWFzxOi?=
 =?us-ascii?Q?tcyFQw0ILi+a0tZGGN/GJ5F3BAcHgqbhJmIHgN+mN86Nt/qp7j1fRp2eLnH/?=
 =?us-ascii?Q?jxC2GSYeuHdEEbHTX2oQR8uYtn6Q3KUeCQ2kGwlUhl2AR2+lpHffEnX5Udhv?=
 =?us-ascii?Q?nx7s+UB6CqA0dGGgBLmyDygv5Wm9ATZ8rrTwkdhg+Q4HhFnn2CKJ1x4mX9WL?=
 =?us-ascii?Q?9FYRVHsesJeA17r+259E2P1dS4WWxNnflHzwRu0GT19iCpN4k4uftaSRFHl8?=
 =?us-ascii?Q?v1+9wQUegtnwo1Ssc8c3uirgwva+LWv7dMlFos/Y8lx6ly6ipVgchrV2pley?=
 =?us-ascii?Q?hd2Iok1sIivbDLVXSnR1rh0ic18RkT8mKkN0uhjSRDxJWUJyG5jfmtWrN/tM?=
 =?us-ascii?Q?BiCnFouSjSXwjHZcG/Wm6e0VpyWAMqsMbaoPFszFrwz1J7OfNT9YH6pWslTW?=
 =?us-ascii?Q?Q9HYQbiG+4ImzF00OaWxoIon87/0a2V6K1L1s9rkYqeyNA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FR3xUI0y+gYa0zKEMHDYf6i1bZHO1xOAp1TASC9JI327yPJ0HbCjxHTEHmE9?=
 =?us-ascii?Q?NhZpGRyM4NMjyAVwGz+uT+2tNzHypLMb0SmlKO9cwJAa8FBEmKJS4yoG2g3V?=
 =?us-ascii?Q?Kr48yHQElfin9Kbwuq1yK7nbgQyAWmmSt2hfmybZGjo7LDDL5505dkCce1C4?=
 =?us-ascii?Q?TlGkJCasS4If1ZalqDkRqShqKwNaSvKqrOMzMRUUS+xDI4VFFcz0PJPgvrSk?=
 =?us-ascii?Q?nBUmHmDlm8d3PgoKhCtYUOpgiNMjEyPCXUamMevgF6f8pZfcmrIzjDNLoO6Z?=
 =?us-ascii?Q?X5NlRtvqqv5N2hnzgwtycXzH/cHX8fLfvnWNuan/u0ZLm65YGMl/bDI+RpW0?=
 =?us-ascii?Q?oDQU4tPr7xh9769zL7Jd5/IuYlcnjRx5ShFeINVEhIgNguA4HbwRvnQG19sM?=
 =?us-ascii?Q?q3fnl3fUKQRcr3NNGX4LYMgqgjL1zwwTyV9U9fzSWv1bCfGbBXL+OOFtmunU?=
 =?us-ascii?Q?Z8UeQSZ1MBJFjnb6rRkw81eFmTfU/NRWwmTjiw3OhaqC91OIunj3LaP45czb?=
 =?us-ascii?Q?oS0ILRO1lnXiw0ZA+FKF5H88iqRi5f806lltFrw+chDMs4j/Tj5oqcZTIAJD?=
 =?us-ascii?Q?hHrIoDHI4j6UQHQ48MxAWukImqthtnZz0y5BpcwMBbB3coJFO8OvvBEmNLL4?=
 =?us-ascii?Q?sJZqT76ZDzblmavjNPmf+ynKifhfFPuYC3gBrqwoeSVrvhge9GiP8x8BEDKC?=
 =?us-ascii?Q?q1pcym7OiZBYqzTxkYqhZpyfHxSI0+tY6dj608RtWC1prRo26h6IwsLsihRE?=
 =?us-ascii?Q?SpG2dpdJafP2aLvhxBEIWUDYpg0sY3nNZ1kx8QtmpydgmcDXIU0M2qheuPs2?=
 =?us-ascii?Q?rEkaxr3T17MebGdxGlpLrWCNCV1vDQ1ZBgNg755HXnz3yur6uWFGQsngF98x?=
 =?us-ascii?Q?r+yORPs6hSoEDliWSdvZayniqz0ymQDPvu73rrd7dx2+W1Tm1qNDKKrYKuqF?=
 =?us-ascii?Q?9fNAidlCweWOn6tJGx/ue5uXCDrHk6nYMwZmcyZOJgGBKkwTXbkVMLxucDdi?=
 =?us-ascii?Q?pv1PKt2zj+zoBdfP7CmtMUqZaeRONTLnqO+9GivPJLlolb8I9vHeiIjmE33b?=
 =?us-ascii?Q?5B0H4nOlbIBxMX3ROsxVYr+F8t432WC7zchUslhfuKjNz/6fO/fwsg0WLUtM?=
 =?us-ascii?Q?RxiGzM8u/E/x3XnUA4YkYXYG69ub6W3tWeMOY7XBbzuj373hQYEiwmq1wRT2?=
 =?us-ascii?Q?w6uKz0GMLV2EoUwYJpyoR79IsXwN0j6s8yNVZjcBXffHcCJbAbxk8/KlSH58?=
 =?us-ascii?Q?q2MnyIuIXQMR0CFMcTRSpH/fU8TU3DjG3jFJ1XEqtMWb91zk6uCSjIn3gZfJ?=
 =?us-ascii?Q?58rCXBB/ELO3iffWPeGUk2+qyoDpH1dNFsh9+nAQHqiiaQYukFm3OS+yWVh2?=
 =?us-ascii?Q?5nqIaWZvF6Jd3tGzGZliggG6rHKreI0luN4/+Z9WC7+yWnOxF0GeeiYxYqv9?=
 =?us-ascii?Q?jKGl0KQgQVPpIs83ii/b5PjsBQswWH79qdJeMECfKJ2AJ+fTBnDtnLQ9Z9VP?=
 =?us-ascii?Q?RxmFhFJEzgmyvjII0FUyHSkILSes/0M4W77QyQ4Sgyd4M5paPsMVmcNElQA6?=
 =?us-ascii?Q?epzs9tBcrYd/ODJBbk4mY8DYQMwO0rTb9bAakvnK3hl7CKMVQcaOUqWsiW/2?=
 =?us-ascii?Q?xA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h2pk9skn0n9wFLl2+/6hHL2c8RT8scZNaiNezNYk9ZJ/z4ShzqajU1uK7r1P/9ViQ2hLa3wgw1V9eD4gPZm8Kg+1q65MHQxPMg7XltCtSHGFr8pBkFr4HZTA4BdEjjvl7i8vVQmp1+eJEkLo0U8sIYMCrifdoHoWNByvaSJ/1tPgmLYMQoaK/SJfrBAA/2aayesW2Qx5Hrdw3Dfetdoi8hqWSnBrdBs8nrm1jBZuVw0hokJC5i7TUTdiZLGHlVbfWmQkUZv4KkRAB2QZHpJFOOTCy78TNCF3QjnHHL+I4ayqE5w8cZ1/OTxkINUnoNEOUaK4gx1b/1H0uOPMGgLT7EDKPVqADLIfePjJ18WNycN2xIukaJTtjKc7ucJIPpvNvM9mJRWv01bhJw0ofB3K6Xslpsbw/OndcSCO/r6Ap9Szt3xKk9otTyoXchJcl5+oYIjJdwm5A0ECCpw/BdIg5kbsnpsssbKijggr4sq7QBjGUYYAT3wd6teiULmb1ZRC00mfE44/6n1j3XI/xSAi4gIXwmyjA6zsN4Axu2bn/4EIqy5QwvAJc9+zwFKvbYA/lDJOWQzSyGrZ3naLYAbAv3LYjax8ERDH0IovZHX/Ubg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae640e7e-f33f-4f02-926a-08dcb35eb3bb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2024 01:50:50.4287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7PtInBNfRC13e9ktJiaYHWzsbSS1/UxPvXsit+DAuDm0Um4R5MNQZYyZhdb1pmHN/g9HopwgXHvYL3BLs83duww8qR3HClnl8nf54j108ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7963
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_20,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=609 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408030010
X-Proofpoint-GUID: 4JuV4JdB7jiPu6mllQdJV_O_wSgytvX2
X-Proofpoint-ORIG-GUID: 4JuV4JdB7jiPu6mllQdJV_O_wSgytvX2


Justin,

> Update lpfc to revision 14.4.0.4

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
