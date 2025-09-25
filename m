Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE73127F754
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 02:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758768041; cv=fail; b=dLwS5BPCwPweGUBPFlr8w9ij2Y2LIBUHWSSYvKyIP/CLVY/SXKNZ4KnyWwmDNaK50sNInHuGFKGv0FSexDbqOdRjp5B4xxI/y2w430NBLavEsEoMCKP50bqsgAvowD7j8x/S5Ck6t9JAXZtv8GYstr60dAj0gVVAg/nP6uIUKbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758768041; c=relaxed/simple;
	bh=ppaeJ/noh/t3am5vZePBchCJqVIcdU1vBHqIhtar/Rk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=PrpT4do52nUlzlKm9//MKc0bQTIaRttx2mFklfUeV13rHjcMWYCwhaXK0WrOJy2WGocX+WTm3aPrzDlluBLyKqf3JrsZX8dNZ3quTJ/ZvupHrmpeIcxHYHmn4Cqe0fOh/+MoZXmeZWalFL16D9kqTYc70u97J3yM8FPv7ZEwx+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Q2Aco9G6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=McZJ3KZw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Q2Aco9G6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="McZJ3KZw"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OIu4q1008129;
	Thu, 25 Sep 2025 02:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/hhqVHAcONzjlNzfGI
	lTocYtEIxLhoHdT7Dc0OK/8Kk=; b=Q2Aco9G6GXjMKiao20t7qFVdwUtlreQZXx
	T/QdrwpfBGJdMxGjYTeVjuFVlffOMBLfjg/1fZUW9L/ZDpi4p7XwfFDF9CbhStqb
	yqdHvUPm+MiF3kN03zB4ndZfa4N3wKdSoYTL1czvzcVN41h62J86VDFq4aOL0nvp
	WFHtpxdSDXkOGN2W1J3mRUtr36grBtjCe8RHGJ0Sbzuu4t5YCFhZ0LgqmJBoUuWz
	nS6oBhYPf8qSHhfRAH+rUfRJjFINo9xWDgmPvRnEVsXpscBCF5KXYiKvAHMqG0BF
	qwZevXBB+GvM52+MjFlv1CJh+5Z6TWTuCiaT5+d/Qz8dmcjL3TBg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499mtt923g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 02:40:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58P0F5j8040930;
	Thu, 25 Sep 2025 02:40:33 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010065.outbound.protection.outlook.com [40.93.198.65])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 499jqad4sb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 02:40:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U+C5rQia7UwHP8Tt7sxwzQvI8fM8DMAhddbgHUkIZO0Sw3kNVJ8X6G6GGNw3qTyLe6rJWGmhQ+MwGZPoOfU5yCfEoX7WoAajJCQA3gfUusLrD4YFz/rUTAMe7AO50lKwX6Mma8XdpZiaImgUBBImLF70iQu28Rn5inYdS2yNa08hdmX0d9RES90ov+tXUtmB/KT21DW5CByyVl8sWDV70I4jA7hHMGmhOUMpb6kX/Bv3Z5Ni5ALKYrYsoT6P3IpE5bockBvE1RqKYnDmkbIONPgg3ArvMHfZ9imML5bZTp0bVOG0B5DJSt8DybY5CvfWGBznHCau1N12qqiQarEf0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hhqVHAcONzjlNzfGIlTocYtEIxLhoHdT7Dc0OK/8Kk=;
 b=Fk9mKsGra2vdneKrjNE22IF1MmTyM94OnuB56UV/zAyCJ5yMJApglzs+5DDluGp7DaV5FKI2rK95aFfN3o5Zg1AvQYbvDMutnIuQa/IdXGM5UktK+LmN1ElcLNa60KEpoQy35U8IoY0IMSpQUuMN9wfxMJXqxRSZxqfOycPb5ItRC1LmOWZwJdM9jrYFdyw9BXEQJVLH43PtG76eykQ/eGaB64ih0pxwOYVZo/yOq1NGtqSyf0cFeAblzOcFsc0cenv6u8uiW+oLjqfPs/9eikziUFfcRVlYcjv07/pc4iVEbYkpXyW4GWBPvFAZlsC+P0B4dXrP7Dj8+508TFvCrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hhqVHAcONzjlNzfGIlTocYtEIxLhoHdT7Dc0OK/8Kk=;
 b=McZJ3KZwGXLijNDbuiWiRQQmnocq0DOTNlUQ2N+Szu9WaRFDtVcvJLU7HWZairTWbD4sqt5dCGHpcyzQLGTNposC19UYwaFwL/fmTE9ICm/OLZyyYr9TWurPXntJ2HC7DZ91QoB17Lsg8LRIHwhuv5Dcc5D7cm6YkJEOGIj2OL8=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 SA6PR10MB8087.namprd10.prod.outlook.com (2603:10b6:806:434::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Thu, 25 Sep
 2025 02:40:31 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%4]) with mapi id 15.20.9160.008; Thu, 25 Sep 2025
 02:40:31 +0000
To: James Smart <jsmart2021@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: [PATCH] MAINTAINERS: update FC element owners
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250923153857.100616-1-jsmart2021@gmail.com> (James Smart's
	message of "Tue, 23 Sep 2025 08:38:57 -0700")
Organization: Oracle Corporation
Message-ID: <yq11pnvqmpc.fsf@ca-mkp.ca.oracle.com>
References: <20250923153857.100616-1-jsmart2021@gmail.com>
Date: Wed, 24 Sep 2025 22:40:26 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0169.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::20) To DS7PR10MB5344.namprd10.prod.outlook.com
 (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|SA6PR10MB8087:EE_
X-MS-Office365-Filtering-Correlation-Id: 11f0135d-959c-48ef-fdf6-08ddfbdce3ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?te0RdURut3ixX3L2bk662r3yKrstDKbFOyn+50HpqgZC4cxyozYxmVeTNvJ9?=
 =?us-ascii?Q?qtYoMBn3FCky+Z7ksPkuuwvL6Aq1JYHvStkWfazxbzQtsy2wMR8VJBEg1uXq?=
 =?us-ascii?Q?/EfmzPRFbz7jN4EVwqK1TmSyXMZv1w005I2h37edO+90DTKpjeR8/JMY1BPN?=
 =?us-ascii?Q?eXXcLd3MjiuRaDeWo2pD/82X1RsMSI6i7xb4dTj5j760OvhXe4/dlaMviF6C?=
 =?us-ascii?Q?2JEfX7BPSCCaFB0l7XjgMU/sV/nKY55zOWkZc7fRutSV+NE6upFaQzIVXAXd?=
 =?us-ascii?Q?6pY5CJCPjbq6MK7e+fgUFKOWERB0UHuDomMdPBJUJLYUVzAT6T8beSQ3dood?=
 =?us-ascii?Q?IgOeNTPcUSVPDJ2aIAUL1aTHOUTT/M+wXrXYjhBDqc686TUwLdvTlAwHZRHB?=
 =?us-ascii?Q?N0EifWm9AbBgxw379qpUxPOzo7oidm7FdTZ0ALaNRLCT7qKzPRxMEvnWwgZE?=
 =?us-ascii?Q?+xY9yp90hOJ08iT8FovNEGM4GVxQJtDiqrzkASpmTd9szmqI0mAvNFwwPb5o?=
 =?us-ascii?Q?25tddJSnYwx5512cD/BuGNensUfoll+JfPSorr3FJIuat5JQItL8Oo8tSXHh?=
 =?us-ascii?Q?ZuvsjeD530cjNd1JtNZVpQLmMX4EMYeeQoy9ix4wcv1BJ+EzixsTlGF0JVtH?=
 =?us-ascii?Q?gguFJ11DG97bJ7odKC3Q6DM4hZFTkCSzcXw7+w6Nkpg3nnZDB7icPf0Mz+GD?=
 =?us-ascii?Q?t2dQW29eilt22QJw7uORWKP2AB7x6PdcPeocj4Xkox/EYMKYgcPbgTYAFSEX?=
 =?us-ascii?Q?K+vukksaTjbna02a1NsM07bHvuNMnID3oPBqytBID9HWR1MqbXWdGxt9WqCi?=
 =?us-ascii?Q?FWPZBLxNbQ7NPitsgPTr4/Ly4LAZwaf6PNDdtqadjU5oaCCD8b33/DhT5I0s?=
 =?us-ascii?Q?jvqFrtddoRI8DwdMg1N/yovE27z32+RQoaGNbadqehVTefjuauaaysAp/dOp?=
 =?us-ascii?Q?DuLnaLj6xxaxyPcXjtLyzs7/CkDm03JmW+0sob0R55kihAmAjWsjTuVs2Ky3?=
 =?us-ascii?Q?X6WuKjX7G2Jv4g3SwWM6k4KdYZiTAEIOjQ5WlHi5MBhVth/a/HrQktocyoUv?=
 =?us-ascii?Q?lUgE1/S1IW56WZoACoIgIWaidZ3+MqoYecrgtczBJ4pxRT9Afc9gC7lRaOvz?=
 =?us-ascii?Q?phqF2JH2htImmJB3lvjAloZGR4V5JOmLSCBsdkLqSgi2lVq1QJuYZ1NTqBQ2?=
 =?us-ascii?Q?WAKGXttHONBmm9r7zfwEnfWEbG6P8Gg3KCMfzfKZlIktq46c4sjdhW3G88lp?=
 =?us-ascii?Q?kZdpfRHr9xsDs2vS9H/oDFpItbMDWGIQ+K1YviNK09TDvAznFeONZkwHyvs+?=
 =?us-ascii?Q?K3llG6ezGArvPLX2D7rpODPXRocolidr0Hwz6++YWhSdJre3bVeEUJkRYz8d?=
 =?us-ascii?Q?b8hlvplgmm4Qm94bC4k/W567XUK1cSMKEFR5Q1SvBW5ptOE1h8VAh/V1H2Eb?=
 =?us-ascii?Q?zITHjXn2O/g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1nIRPZt7fUYVxCjHOL4Z7AtNl3ugCl6FL0DW4mreTwzD01xWBj0puV+xTrd0?=
 =?us-ascii?Q?gk0/bPQWCTvnrBt0n4BTvpKHbo8tnWQHsISNwunnVlAEQBrhYP3GtY1pAvCz?=
 =?us-ascii?Q?V+q0vwWy5INuX5ZzBHbBN5dEnP4LgmEAr4lNAFDVAnmErxG9gBSjEVct/sfw?=
 =?us-ascii?Q?OzboZEVMB4R0/Hv/bRpRnbYtuk7dWeiSrkfpSrcV56YYJNUti+eejYuZ/f0o?=
 =?us-ascii?Q?Rg13voMQZK8+cj5XomFizaeGntfQDC184mT/k+SElk0i2/rBeG2VZF/Iw5Vw?=
 =?us-ascii?Q?mum6IfniidqU8Koe1wjY0/cHzQ00GaCxwIKIqZ1ULQOwg5f+McyqN3MxPro8?=
 =?us-ascii?Q?H4b0xVfhmQ/u/Mggk66PzTYL89MQUBnv8OU8dE+zOmel5zqLavydJggBqiZ4?=
 =?us-ascii?Q?awNxTRw59IiEuTdskXGfAoRIvEzjzJUG+E+uQxUMeEvpMQyC2RGTJSP11H7r?=
 =?us-ascii?Q?YXvNoU47qtzy2jSh4YcBWveCWVMJsMXZr2konfvtS5FNh+xiOkdgBB/sgU9J?=
 =?us-ascii?Q?V3vH/YR5UMi99CEY/uGklLLF3K4M8EFnItTnt5Gm9TYzK5WwYGpx5hzEy/aD?=
 =?us-ascii?Q?3mo6CWfDE2Wtof+Xsu/QZwajmghL6y6+C5CxHs2PGRg8Zoxm9ZBED1Bj3kPg?=
 =?us-ascii?Q?exgQJC/P2XQnFaPqctAc3tNu2JrsgpDlDd5T7iBMLSIoY0SSEzk3xjoYgHvY?=
 =?us-ascii?Q?qzWR8qnMn+3AaRuOskq3hMnaZJFIeVMOrYa167lEwQAvMd/gw4QLMCsJMtgq?=
 =?us-ascii?Q?UMJIo3I9wMzMiFzVwiGumTVUbCEhZMX2A9xijshfo6+7F6eWLquYvT4yH70/?=
 =?us-ascii?Q?rBoUs0VHHp3XjkyuOzAfZBHxGjrqDrg4m4QJVAGCdqazaluQ86L1V/r6Om8j?=
 =?us-ascii?Q?fupyTjUTmvThOgmd8u5MZAyvPH+RuixJs7UFrVpk6nEY4wteVUaQWa8vOur7?=
 =?us-ascii?Q?a1u9jL9hZiuNI783nqhPr4keCkImRrTXV44z5ABIqdQNWNG5+x+PCVQWq/sQ?=
 =?us-ascii?Q?w6l+y7C1BkofqtKUjlUROa6v70VzgY6TyB6s0FcgLnvvUN0o12+pm2TxLFnO?=
 =?us-ascii?Q?jtqGe3WDE83oQYRwKxQ3bobRaju1P8yCgxh/74IPnI4MKN3m96Fxb+OnSTr1?=
 =?us-ascii?Q?cuStHRA536s/MnAzWDEP4mq5yvhM6ovhL7hTgwNWl+nQwGNdkDVsXFoQcBWD?=
 =?us-ascii?Q?xdzsD2zAjR/BmgyUIfjTH2DYYJhk7lwwPU+8ID7ODgKZjsL74B0WZGeYrX49?=
 =?us-ascii?Q?gK0wJ4gB39DNctsqQ/WN3vmIuCd+5BQU3IkeqhECnJx7SjV+K/AOtw9bpH6F?=
 =?us-ascii?Q?Et+csSRrkCg9PR9/rkn6Hj6YuMD/MxsT96bnD1L2KHzzU4CyYRvMf0BhLyKs?=
 =?us-ascii?Q?OULcKl4F/DHyIHIEHr5rwh8fDIssXLaDNuZTfF1KvmKH4rj58lUJHML48EnM?=
 =?us-ascii?Q?YyC8B0M0TBs6m+pnfn2k2KGow1m6M0O2ufx0RN7/7Sd6l1ZIHchpcQueMeI0?=
 =?us-ascii?Q?U3biZLsXx18/JEAqHdqFwq2Bp2CyPtCQG69nfWkNcgRJb5bKRkXzI9VMny+O?=
 =?us-ascii?Q?f+nubg1+i4VC5yGM4dKQ9ociuTI+seAxhM/xX5wHx87d5EByE0FBpo2OyYe6?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i3A9N5vdb92II4CM+xXERy9raaufnkjD4QLdfmEjB2uC6yD053H11pgKrpBX4+U+WgAoxCok9bcoOHM3uHpYbQpZjH2If1Nt5Mwg/dom0COLZ5y0g6FlYHwLu8RHuZ+yem+KIXgbjt8G01eU0lGTee+tHN6yCzBbCcd8xl+41yjrzYz7V0lYXSCvBIm8oSIMSbG6Yx3b5SeMMhH3v6CY97lSalI/e6mRHwPWwsoYP0T6KQUcwnaheWhIRP3g4EHUt1j855CmMwMHn9s7rdGdPad4wMrZlDoht4LL26S2rTr5x6I709QG0x5Zr2Tz7Bu6PojibqJ1/ixItlsSXRhr6SJgWnBBYO6Kv1znQ1TwSgGsmACCTHpzPGPsCBopVG0z7bzAxw2OIPBzpT7+LYtqt66efuSHwGYZlDrisD9SHi7NTCjnLh4RaILWYph5I3CEdXZPhp5xt+WeuDdlugvhouWo3jYwVCGfo9utNxOOhEScFu2TzF6tthMqPkozfkiF52KYvQh0NliFU0osI5MdC7+p4QE9UHHcBR0vGs7XVRjBUrDTF8u/zQPtTSGWDQK3BWHXnYMEfDw/5l+KwWOEwxRYMlxDHTJlwvgluYwjQsQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11f0135d-959c-48ef-fdf6-08ddfbdce3ea
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 02:40:30.9939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q9E4G3XFCWi8p9x+7EYjguIFY8Rc3Hx6YC9HdHptmNFkoIA1XE6ovgYbtlOcbzwrewxQdXm3pWX8D4/5MpL0298kxGydgsLE6ncD6+Q08Tg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8087
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_07,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 spamscore=0 mlxlogscore=674 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250023
X-Authority-Analysis: v=2.4 cv=fd2ty1QF c=1 sm=1 tr=0 ts=68d4aba2 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9
X-Proofpoint-ORIG-GUID: -zjLyerOA1IP327DbmbrZyNz85gVgIOP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzNCBTYWx0ZWRfXyiRF8CwamAOV
 HP8KxZJ2mF/hT0FSK9sJpHMOA8FoRzeCnfT+d9xd+K7VFiIDQDj3GQhID8RNiex+K20LRH0y9Ja
 F/xSSm4wiZX5eti+piLFX9toY2W+mkgugQ/f0Ys9MeWAdgHJ4ghNzrmFTo2wI4ijCEWcLiRtRvV
 K3QMccY64nwkD7TBvwPjtyBU2FsAMg14s06znieFM4WZN0kfLF9w/s76VnWZx8ojB19jFdgSuDg
 tOOru7TdWrnBs/DTCrI/GkeYjpGVPvs6inUMm7wibLcy7Ts0IpWU94klWntZpRy7pDRX4iHYRW5
 zF2MosolstiVITdpc8940t5Hm9D+KnQZNhPK2328VHrToYtHfKRQjTAq/v7NVZ2m0a/nwNNZAPS
 wI6wAupF
X-Proofpoint-GUID: -zjLyerOA1IP327DbmbrZyNz85gVgIOP


James,

> I'm relinquishing my maintainer position on the different FC elements.
> I am updating them to the Emulex folk that have been watching over them
> for a while.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
