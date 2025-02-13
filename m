Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D5CB663;
	Thu, 13 Feb 2025 03:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739416678; cv=fail; b=m/E/uLX1U/iokiJPIGMQYfjAs6P6piO389a8m3aKC77816hVGD6ki1iKwTLruBp0gm3ZzFw+wrVzbcKrg0vN99tV6GP2zCAKcwAHIoqSEibhnL3Et/peTeYvDRiPy6WNDbYqTW61X+WNJ67sSn22C3WLKhA5PBL//giNF7Nctas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739416678; c=relaxed/simple;
	bh=Cd0VkbuyMzlwQh906fwidrP+6ALcw+Qawf6Gmv2hgy8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=go0roLL/FUOjflGoaGGyaRN6TQrNK9/p5R/e9bvLVDhL+DEqWgoVGyIPMFVNWJON9kdu+cZu3Qmt+TltujNL7dhJ4Ku2wNpV2HjZMCeRDSgCkPDUEueWkERflvotJJGOUndz3lUt7j75lR+SksQopvyesdrnSzkN5WGwxyc8Kcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LEBnynsm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VY2HxzTm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LEBnynsm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VY2HxzTm"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51D1pg6m028232;
	Thu, 13 Feb 2025 03:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=9i0jsNDJJdM4ppzVoa
	lSVllcTjwpgSehgajtH8LqHYU=; b=LEBnynsmBCBzzNyHoOgLSakpLtybRCSHvQ
	NuGqeSQLf/aTZd2sBgA4S9NxJ9VJvyXCVj8L/RiANgL0YOjLDZChiUxZeT+kOaFF
	YmxBR12Q2qkqfq7yM1p3Hf70yMrqpCld94RbZVr2AQg96Joz/P06yFS9ukV9L1bg
	ijwcgDXGDMTGrnaBqAZIPMz50pkbHk5bwQ4oyR7dXZfHHY28d5Za362hAz1BBeQB
	VCYXIUJtrkTLI/hH9DEuPhUnCCAOG+1vAL8c2a3/VYW/rtO7M40sFwsCYekJ7UI/
	K86mCfL0MxXBYv88OJz5daqNmUAVb+dXoLPPQRAiZjIixTyg9zxQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0tg8uqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:17:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51D2Bpqc002336;
	Thu, 13 Feb 2025 03:17:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqhpa84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 03:17:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpJsICWDf8EuMW2ba7LzSR8aXAINh8sNznCBOXzJ56Lu+JYxtgxACQqUd58I0bVMPY06lgMmlamw672GShDcVzl0SYLWLwBf4IPXl9ywBsel2dCfRwN5bYUGRQ2YaDoKIxmGqsaW5CAixx5WkdqzXgvVzhzdfYDXJxlR+7jGPy2Vm3XuFIvgjx/8VECkiKnmoagXDHhDkH2tKzHKLuSvGDrMHAgU1+m7e6s/c8/714jciW7xCGiP21Jc50hiO6UYgkWQgzDgl9W8qZd+en3OeFG0FJlcxBU1A/obA5U/lo7JLteZlHAz5Xj4ZXZiZlGJuBXbv511A8XTcYvhGcX8dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9i0jsNDJJdM4ppzVoalSVllcTjwpgSehgajtH8LqHYU=;
 b=dk2E23gFB/Ml9e0jpbcbX9JmfHWeURM9AnmKDcSSlHILr5hVtuPEBR0aK6dkiAz/pYT5JzXpEjZZRvynNR7FQ8E8OLh9swElptjr/QyEPrYb3758U4V2353omuxLW5HyJMQEiPpnKvYnSwPidp6oQdyibsC6OHRxKXMwziHcNIlSq6xTdOUdg0zyEdFtP1pvbdNw6qcq9Y1/gx1EZGkU/NyMQx1ZoWCVJqvVR/hVprYwX/Ou24Hc2xDUV3TiK/XN+Kc8ijGY8unz8/CQXA5iw922vOpzVKSoCnt7q9Tm9JjwTvzI5WcXV4kBRP4E9IOx0GJzOBw7A18kuqqssvTCGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9i0jsNDJJdM4ppzVoalSVllcTjwpgSehgajtH8LqHYU=;
 b=VY2HxzTmG+qrt3wAKC0aERN/YGbwcDubYOu9NhCAHFWayYHt7yeoYFqdE8zAfCRIKZJ0wG6udADXds1lkZKmxbtQaFjJ4U3erzkkpZRgg7M3GlKJr/XeJfm+siEZlJ18uGhUPGsOb2VSvGVXAvlSRPFwX6A7Wb8AfCYGbpbRuMI=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB5064.namprd10.prod.outlook.com (2603:10b6:408:114::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.13; Thu, 13 Feb
 2025 03:17:48 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.013; Thu, 13 Feb 2025
 03:17:48 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van
 Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4] scsi: ufs: critical health condition
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250211065813.58091-1-avri.altman@wdc.com> (Avri Altman's
	message of "Tue, 11 Feb 2025 08:58:13 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ed02v8hk.fsf@ca-mkp.ca.oracle.com>
References: <20250211065813.58091-1-avri.altman@wdc.com>
Date: Wed, 12 Feb 2025 22:17:44 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB5064:EE_
X-MS-Office365-Filtering-Correlation-Id: 670f1c4b-6faf-4feb-341d-08dd4bdcfdfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7u0b68VpDZrqiMUW+MeRKpdhY9E559X1MmcieUdyg6SZS96/Gb9X+TrGBNJJ?=
 =?us-ascii?Q?9h4O0z/dw6ShWYMbS0cHmdBI2b+JGnodXay8XJLcZ3w6g5ZnJUfljUUif1b1?=
 =?us-ascii?Q?s/j3NqrDzWzYO4HCaG7dRXokuQtDUHzzxxJaNKfQ+2dxbIsk5HeA2Am63Y9z?=
 =?us-ascii?Q?Ol+bfYCp8gzSQ/dW68D5l5oezeakOJAZsrtp4QTDDSyKSff9J+CG2TkiIeSR?=
 =?us-ascii?Q?CHnAAC5vi1esgCedKFViXar36QnK/w+m5z4juKZonX+/Tn/XTu5+6QvAeqWP?=
 =?us-ascii?Q?JDmEJvDelXsz+XsZjllLQtXPqwIRfmAfzXzpwPkVaDYu8bgzFNljfu81jEVe?=
 =?us-ascii?Q?xZyIyWXiFD4Z5E9S+3Ede2PBf7XfHstSJr1KrAd5GKfXGBaLZm+tzRM90NiT?=
 =?us-ascii?Q?Jfe0OnNMcWVhMYWQcMVSUOs+jAAAzRHCTFy5bMDcm8kUJEDARgYHCBG7ITL5?=
 =?us-ascii?Q?M9E88HfQ57kfFD1emVCuRv57T07RYfEXVIBHQI2rUB//mkT/gzN9JnZH9lr5?=
 =?us-ascii?Q?hFRgl75OcmrR+wPrFxYBpXZTpeXB+rnI7w4BKpcOIiLqFjVv69fRHboR1abh?=
 =?us-ascii?Q?YdqShV0i8dSEesz8HyagMG4NelmXiHTkk/WZmM3MF6pRVP+7nQLDuuyBDIBs?=
 =?us-ascii?Q?evoPJeAVAExCZEwwZldzegBFolW2zf0YqHs4GP21666xTumwNfpyhRGzzJb8?=
 =?us-ascii?Q?OQusQc5neKs/7/o4fGn+r5IBPIdka85kouO1AumgABaUyCSg2bxdWbDeq5hW?=
 =?us-ascii?Q?HwVD+CChP168myP7JyiReoB6jHDydJ5qHzyA/wVngwjhcjFiLlJQo2/oQDvK?=
 =?us-ascii?Q?h3bQmVlbl4VgN7+VOAY4myiR+7o/Ounhu4ag6C0bN56NFIWIo4pbVH+913Vj?=
 =?us-ascii?Q?aMIsE+U5pNprFF5Unw1mjZ98dtC4yYTFCeANUpvjgSw+gpMYvWW9Fgu9xasm?=
 =?us-ascii?Q?FxsOc5gYSLb76JcZeDHdED/cAg1uBCWGDpm6nS0SZVk2EsxA9SSKzRJSH0Bc?=
 =?us-ascii?Q?bIwEKS7NmP5lb93kVkLrXZQXZz3Luk1Po2mLoO+KpPOX+OYpUmQLVbuiEtwP?=
 =?us-ascii?Q?rspalsEAJLYsXzaMpqVTkbSwP5ikivwaKZjQ5yTQGU/nAykK/R8KQmXB0jfU?=
 =?us-ascii?Q?7gCez0OqpOyVFwgwQAWu/B2GJ43Xqx1OYHUluTOiIv5RUFrOCP90IvcKDsUc?=
 =?us-ascii?Q?zfupaQYChvFMkKiBjm65eWUDc6io+bvhVWToAatE2JFUJFeqZQ+rpFI8Luig?=
 =?us-ascii?Q?+ASuqjnNjievxhIeTf2o78pLUIyzzcpqbxH/8LHV61LWPmEBb0ppXWDOtymY?=
 =?us-ascii?Q?HZiaM8psNPm8mFdB1DjgMQqSYO2UQPN9XvExHkwPtTnKTYIVratAWcsCrIyy?=
 =?us-ascii?Q?gzg4DGI7i6v99K4PRD4dhzFds/Qj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V2f9/zb5cBnf2+kblfC/BgNE4l9h7G+HLdZQmY/9pqUyKcVmsoxZp+ZceZeY?=
 =?us-ascii?Q?0dwPMo6j3fbwJ2/3qCkNRzpU3NyOBU57NScmgLn6lGYj7MJJOQoo/Ees92rE?=
 =?us-ascii?Q?mt4reCV7zJ5tWtm0I6pXRF0Gi2OLCN80XZEqc0ZdMoROxp/B9YbSKTLy5Msj?=
 =?us-ascii?Q?eV0Z/G8U124IhceAZYCaolmLhncECNcFf3Gshe0GcqTJbhwZ76zQICOqUjlF?=
 =?us-ascii?Q?/WKjIIRAUcvXMWs2+Pf0+CRB9og9vzjTpQY7y+pARA6hRwFbGE67BOvRE/2J?=
 =?us-ascii?Q?o/ZY60L1OhPRAJ4moX7WSQlUS4FYFWrxLzGr620M49zbBBxFS0ZM9Ajo2na3?=
 =?us-ascii?Q?9tptpBr1TsGwumbY2+G8/QuaqsfB4Wn7iSHuVGoQ/z5QZamtxGA9EiG34iBb?=
 =?us-ascii?Q?uGpLWjjt7+Nsi4kJ8lbnAfbK0KEUirFS+tBufSY+ljgJD/EKTZv297DdiSpk?=
 =?us-ascii?Q?9ps6IidZdlZhbN4fyc95J3oFpKIZPIvFhiTjUlhr+nq267W3VrxckqLk98eZ?=
 =?us-ascii?Q?KKjQDeLXCY5iaoAaVjin7BEQUpFXUQlTI7d18lwnN0gzGs0pL+2uT4rv/Y1h?=
 =?us-ascii?Q?JU799wxJa9wQB1sgWQLAiVLXgsZ0fYyI1qs+l0X1VimR0YDVtePLubw31hVw?=
 =?us-ascii?Q?JGa39ieGfW1kgvn7h5mUKc+EVLy44S1NsVcqCfDiWClS7myzpDz/b/mm22NF?=
 =?us-ascii?Q?tWX3AYgS8lVRegfTDDqxVdEpaFjIoN6u2iFkTctc1gsD+wgHaZTAzZfhJHgK?=
 =?us-ascii?Q?xrIiR03lqHdYXfoyXy86CS3JDh1ySlGgFtJwEDSK8/Hi27d8TOwdEgaDptZr?=
 =?us-ascii?Q?mwNAf1LCz0INlzTh38ncb5to1YXIlzXEkxftcVcFIY7eWnTTAy6gPVLlyYFL?=
 =?us-ascii?Q?lbvKg8zZbinsWw3jWi08JRZ3u//txvq2Huu35ltIzQHe7Lq5/qeo1KMI8Cr2?=
 =?us-ascii?Q?6DKhs6JXsWnK7hf9k73N98bN1YQY461VKqc81NxQrW0656rcNaOJS/dcdF05?=
 =?us-ascii?Q?XuyM2OgqmcCyxINhZ89lSLAWpUYesatbX0aaZC3ICFIujfkZwa/AqoWzU3re?=
 =?us-ascii?Q?1ovn+DvPxp5qvJFRGKhGaB0SqF8v23yXEcCjrtKoqm6iDQJoStlDqO7ZPRfD?=
 =?us-ascii?Q?YzkqU6VEKVuOpa1yy2DaYCqHziR+eOa7QYVs5nr+TywmyA5w7fDBJdOWCwiv?=
 =?us-ascii?Q?kkuPkbzwB7gTUo0NpROYLqGdTofoeYzRgSdnv4d+WapjWVpiIkskR7sOQIj9?=
 =?us-ascii?Q?4IAqpvT1sng/D/YYiqOCPkYA4m4fixMvaCa/hFI6YWVxsmqVygEcioLl6E89?=
 =?us-ascii?Q?tw/+0XoLfNIjyTcL+Dd5lL6RtI3O2vuweUlTjmKvPxZctILOc4p8LAQ0nr6t?=
 =?us-ascii?Q?MR29WbzkOZjYOiSnwMkzNGiinwBUlW1F7aIN9U8gEfqGdw9NH4HRNRTlgS0q?=
 =?us-ascii?Q?UY8i0K9BKFf8ymMWBZwtSky84K+gyzHO6nKgNw9Jfe6OyQa5DPZf5Nz2vesW?=
 =?us-ascii?Q?z8YyBqxSPYzE86zdZ/s8L76ZT9vQM3KcbJaokbw6o/qePilcVbBcs2Mm4fF8?=
 =?us-ascii?Q?XYeRSUH8y2Mmb+CB4ErwVEoAt6/nOIm855ecWcBjIkzv0nQyXSmInsRzwoPG?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F6PfFHot7LFY25DPeyF9NdSf/0haHISFnqnImdhQvqBu9y7oBlhK0HDO4g43UIlE2PbpPBSldCOzAty0/AwkbfdnloP/5pEJujImW55Yz2tWU4x0gjjPW66xzJIfc6vDZ2rH6BFCioDmIBuKJqB2/SXn2t9iHgz6kEjgCkMAFIN+uswgCQf4RZDsp9LNUd2jqVzNYjMY6WSi7g0hnsKnSXd6XNW2rErli2/yrtNQHYPc1p0qoJtGQ10B0cTPE7DPvF8yvyCraI4h/bHzvC4FfknGsRYNMTGOEg9/gcKico4CeroPxi3/HutQq17bAnscUd7dZHZ8pWEr5ykumCUDjg3YbOUqzyqIrJaXKvhlebu32/CSPmKmNqmFY5/c6h0jcb/OJ56U9iUY6wrICKpUhROv5qO+U4ZmyVJLeibcdueSZGfuZzJb54wPh7+QYY2hu+d6yssPUA1Ua0DKxypvarnS9LJEzXrwuBITUjnA1VwinLbzeDhe6DyYdHfm6aHH297onLuzG7NTbUp4+6SnzbMJmYDY1p+Xd6/TrYjkKWNsBVAdwxLlSHHZfr7N7kOX5IpuyToYaUxU2SPAiiedjCPPjKA05OnRarNBpVbxAr4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 670f1c4b-6faf-4feb-341d-08dd4bdcfdfc
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 03:17:48.3564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dTOPKb5wF07kAx5SmuOoGMJKYg84Aq1fpS5GbBoqTt/T74waNyOqdyAOoqOxEYsanauepTkYdaWfvaOL/qIXZxhszw78NhvA0poSDd1hZTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5064
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-13_01,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=742
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130024
X-Proofpoint-GUID: c7uLeDc-x3rlAdrVJegRY6PGLiiF0_7D
X-Proofpoint-ORIG-GUID: c7uLeDc-x3rlAdrVJegRY6PGLiiF0_7D


Avri,

> The UFS4.1 standard, released on January 8, 2025, added a new
> exception event: HEALTH_CRITICAL, which notifies the host of a
> device's critical health condition. This notification implies that the
> device is approaching the end of its lifetime based on the amount of
> performed program/erase cycles.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
