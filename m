Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6549BFBEA
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 02:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706669453; cv=fail; b=ljL88hUjvP3EM/RsL1hHwbLPiy1JeKY3+kWCxeNy1HGxrhLSzFRjdlQQh65Zd3X6QWeauQ5L24Q3JMpEYlk0/0knrWZZEnMTizLCdcIG2uAfVuDwzdTF2fD/dG8qakjFLUO5mtu/g87reIQQMoVo8vQjBCwEvN1gwOTlv+lJW8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706669453; c=relaxed/simple;
	bh=M3IaPFRpp/oRF6iwirIDwbCfEF8aNtisehgJU4JwzEU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cO8ZGoD5DWXozb4IxQfd/e1qkqWBbOx1EcLs5sFQhpNLQzmKEUl1SA/KuxS9iYVAHgRYG0NvmveH3AwLQ8YUb2RssqfhfGAWmg9q0cEvOmCoNUjCuvjXMz5wdlXSUtwbk+5DGEqX2d62INbH6wZNVjzheYOXRWj+lwT4aviknQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ls1EuRxB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MqByI5t5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ls1EuRxB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MqByI5t5"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40UKxUwQ026019;
	Wed, 31 Jan 2024 02:50:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=iLGW5yHu11yAASAK7yumwwLzTH0vweCI8Ff+UyFmJT0=;
 b=ls1EuRxB4EbFxxTGAipdSuKrVF98as6bmCj0UCvhTOmRZO3OIyUlzwG2ifMZKiSkD4Qh
 Hl4ZN78aoDFqdPzawV7ntjotWS7efyj061oPxGSs/j/z+GWmMqbTR7VnVFR5+C2ADkfY
 4lcEYWDsN1bdMOnqnlbkw5PkK/pjpah5Y3Z/3nlD2TL7ZT+AvLyXt3G299SEMnPZZptI
 8HK699A3st9WmFh4a0Q4lzlqRefBlON5CJ4aHhRM5fF16YUH8pz0yH8OOCmkkGo7D22b
 DsPWTnm1Ub4f2zwtxnltwVNWlyQgayyrzoHTqBdkaISkldx/cmC4ecqrifLrXVA4/H9+ tQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrrcgrts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:50:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40V0PlZd014567;
	Wed, 31 Jan 2024 02:50:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr9ee139-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 02:50:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMH5vo8O6xIPI6boFNSXYByotNUb0XZqGmjXFFIpLrBtzw3rUa9cK9cuEalLYzY88SwNx7twNDV91qemjBJtyxUNeg+uKNzB8+E+6DkE+VflKiLRg7xdsrOmZFImrv2b9EUxOdbsxRVxUqtWGH2x3s9ZDq0q2OQLVzA+vfce6fuWhfcKlgIVw8KU8XRvBILFgdaAizkNtVcMQ1uwvcz2RbEgmlLIN/S126FEUy6ODBeLlaoPzRTV//MJlbTjyOcIuT2K/ZSo6YLKzbA6HaWPpg0zeHcRSDNyHsTp6v7daozO12c8RDuCQCmJgMT9Vs2IKWH3rUGBgLBMXtTeIgMEhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLGW5yHu11yAASAK7yumwwLzTH0vweCI8Ff+UyFmJT0=;
 b=XA/R+zpsj9V7L83UIUO47EJ0qDd51Qdx0DHO4uVQTIvfdOIMBYSkw8oiq9clTbYIbuWB7OYZm+oxKF8aVFrq6rmBCCov9C8kWnMN11C3NQuWfI/TsMkmQ02UlZz3YmbTczKxYFhR++Eu1iV6KpwgV3CeVroGZpETyh7MCFqjdcRYQ7P6zW3UDPD2w+NXeZUwp6Ooa5h5fJevNy4sSY1Sl8vYLuN8vtb76KWGx3SG3JmxLqbDYXFmUnuhnXZvN4jPptsrGu6kQYxyA29Z+4Oj7yyqKZzHNzbXLsnEhlhSBHmtNtQ/kn+0vy/DP7q6VvSHdlIRo5HOw27/BJGvaR/owg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLGW5yHu11yAASAK7yumwwLzTH0vweCI8Ff+UyFmJT0=;
 b=MqByI5t5AS/ghjJblCU9EXdkNc4zVzerC859XhObEolyt0dniF1CXWKqCbp58badGs/yySuF/cUQlAh1OSCpDJ2USQcArJPW+NPvqGHtMrIBS/looYCZHW79jZMHMY4EwHwmvCr0UlEikyPOhohxiC268VymWQ3FZNqBsfu7BxM=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by PH7PR10MB6356.namprd10.prod.outlook.com (2603:10b6:510:1b7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Wed, 31 Jan
 2024 02:50:44 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::284b:c3bb:c95:de8b%4]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 02:50:44 +0000
Message-ID: <0e5db4b1-7f8e-404d-8197-796f366e9e16@oracle.com>
Date: Tue, 30 Jan 2024 18:50:42 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/17] lpfc: Protect vport fc_nodes list with an explicit
 spin lock
Content-Language: en-US
To: Justin Tee <justintee8345@gmail.com>, linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com, justin.tee@broadcom.com
References: <20240131003549.147784-1-justintee8345@gmail.com>
 <20240131003549.147784-14-justintee8345@gmail.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240131003549.147784-14-justintee8345@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0011.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::24) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|PH7PR10MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bf75938-643a-4c2a-4170-08dc22076ba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	hl5FNCRej4nVx17llNOPNy6jR7BgB/HPO7gyLj4KXDuoMKunP4CMqiFNUHytgju1fTobQbB5n5nNgzTnKfDXaaV7Wlm4E7AneyEQRVHT3y2sj2vsRlDpU6zBiixVfSwsVcKt/zGuI7i1bULSCB00C+rimTFzRTL2DQPfZZMecnjRwF3NKEDfQAYVrYJScptpJyhNddgkapE762BI1/HeQtKKh7xiA+oargIi9rnJnWmJxxHqJobJWtxykN7Rv+ngatU5MCpJzjCjcl9T68NBdse042pFQrmQeK9uNr10V9ErYvpKsO6qV6B72iKObX8fjHAPLomVP/GFIuup7dW8Jp60BnM7VKE3CmGyalMYnw/DrMbuzeom6VG/BTl5mMEF4ZBnOfiJjB70fyqu2eyLcZgEBVHMU+0FmhYta9fZpf65Uc8cwT9foCUn5ivH9+nFOW79N7tiwsHZEBJP0e4d/arv+Ln7mfWW6uOI0lJXqLYPtYQjx7SU8FXnRGhmODm7I6fR6Iq+ohHgIGdgyJyArm6JqT3CImfaP/GlwWEOLhc3k4qFhyHI8fkURKFrXBkauPBdmFq8AQ3uxnD1vRHUkZ0XLSKM7rGiNvVViDFTJoPUtbI42ihzcDucA7Dl2bB46wK5URSG0gioO6f3w4R/6A==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(366004)(39860400002)(376002)(136003)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(31686004)(53546011)(6512007)(36916002)(26005)(83380400001)(6506007)(36756003)(31696002)(86362001)(8936002)(4326008)(5660300002)(44832011)(316002)(41300700001)(8676002)(38100700002)(30864003)(2616005)(66476007)(478600001)(2906002)(66946007)(6486002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aEdoVnJnblFIUmxUQk50azdQYlI3bnI0NldHcHpBeHBTd1ZJdVEvVXpZSGhJ?=
 =?utf-8?B?SkNkZ2lGOENFQlBOemtWc09tOWl6ZUdvKysxWlRzSkoyTGZFeUJaaERjVWZC?=
 =?utf-8?B?S2xFZ2kxWnVZWTEzTjRadVZEV010VmRLaDVUMng0WU1zMHFqZTVJYW1VN1FD?=
 =?utf-8?B?cHpFZjgwOVc5aWlwVXdueTZ6T2tzTEc3RkFaUEJudTg4WjBXL2lVVy9RMnp2?=
 =?utf-8?B?Nm9GU0NuMXd1dHFhR0xsVCtvNlB5N2JkU3JFOFR5TEZWT3BZKzdGYnI5QU50?=
 =?utf-8?B?a1c2Z1Q2V0xuYkZra1lPYVRVSC8zR0c1VE0zaE5oSGFtZE5FVGxBTkcrU2dm?=
 =?utf-8?B?QVFWYnIrbURCQ0hUU05HT25MVE9ua2MxSmdPQkpmVWtuNU9pc0ppeWdlcWt1?=
 =?utf-8?B?Nit5ZlVPc1p5bHZxdVMvbi9waGNaYll3MzRMcnllU0Mvd2VYdjc2Q2dTMlNt?=
 =?utf-8?B?M1YvSHppT1BPQlErNGsybEN4bE13QzBBQUZ1UXRudXFCNmYrTk1CcGpuMjFE?=
 =?utf-8?B?cUhNNlFrS1FSWGdNdWNMU0lUN2graXlmV1c4U253Z01sSTRSNHYyc1JDNktF?=
 =?utf-8?B?OC9WQ1htRU80U2V1elQxM2Y2TjM5WGdGRzBkT2VVY3oxdG5idFdkZVlaOVRT?=
 =?utf-8?B?c2t5RzVWVkxjVmVzRlVxUDhmTUhEdkE0RjJGMzVXUnp6dncxeUk2Q3c4dGpz?=
 =?utf-8?B?SnVwZ2Z3MTN3RkhpOTI0YURVQVpXMUd1eldHTy82L2FSR29OLzZmNTEvbWhk?=
 =?utf-8?B?Mm5WT2VDSkJEb1czV2ZmNE9YTTdULy9nUFVwWlViMW93K0RwamNRZXZPWjBJ?=
 =?utf-8?B?bEppM1U3clUzZTlrMWZVazFYMTNkY25kV240WGtzRVRVQk9JRjJyaFIrT0x3?=
 =?utf-8?B?Zk1qMkhzY1RVSURWMnFwekl5OVhpdW96T3I1RURWM2pMU2tOUklib2Fma1F1?=
 =?utf-8?B?OGFvMFJjem91b2FUb2g3UDlGRUg2d0dHaVovWHViS2NnTE0rSXR6SldpUkdW?=
 =?utf-8?B?RU1uanVWUG5iWjhMdE1FQWxVT3hkNUZaSExFU0lvZXJYdzZLNkRxQUhJUDJF?=
 =?utf-8?B?SmpaZ05qbWxQczdhRUZYMVd6SVpSZzllK1VmZWJBMWo3YUtQczdUVFE0amgv?=
 =?utf-8?B?K2x2dFIyS2l6cDNCMnRuUVR1LzhyMkNYSElWWmh6blZ2OThZL21lek1yczBp?=
 =?utf-8?B?N211WE04TENPMHJlUVFjYnlCNVFPS3RaUHhERkdBa1ZpWXVFeVhWakUvVWpJ?=
 =?utf-8?B?bFdnamprMHp6VWNVdzRSeUlqQzFXdGxRMGg4bEx0eDEvS25iTkp0bTR0Q0hV?=
 =?utf-8?B?M0NHMHdVeExXTWg0OUtpNmd6R1FpaGhXbHkzUC9PME1UZVd0cUk2WW1RRXVS?=
 =?utf-8?B?dGw3Q0VIUnY4enMwS1BuVGtMQUlDem9MSmxsS2plbWo3N0d1bUR6MldDK1VU?=
 =?utf-8?B?QWN2NDA5MGJKbWxiWXJGOEdyOVpEN0NQdFdYWkh4MER6MU1wUWhTVGdZdDdJ?=
 =?utf-8?B?MDFwbDFzeGx4akRxMXVURlRUcVBsQ0RQVW9iVldGM2pYa002c3hJYjVaZDJ6?=
 =?utf-8?B?NFkzcHRsR1ZNb3JXRDNJT2s3M3F1clUrL3pMaGtuTWRpQnNERmUzekNiR3pS?=
 =?utf-8?B?RVFoOXhEOWJHT2pIdTRuL0wzRHdZYm5NVlBCKy9GaU40N2dyWDR6ZzdsODMx?=
 =?utf-8?B?R0tOZ0ZtdlBHUE1qci83K09kSlgvQnNteSt0ZDZZOFJvZEFGbWtTeVlPQXE1?=
 =?utf-8?B?QzhYK1QvSkJoTnJvSVZrUjJTa3dDM0hBaEFDem9aSUtCbjhuU0hqNmhRbEE3?=
 =?utf-8?B?Vy9QTXNPMml6dlFtSFk1VlZCd0V0MTZCbVdWbjVISElSUlh4NTRkTEZzbW1S?=
 =?utf-8?B?Z3RlUEdwODZTNFo2RHpmWDFZN01Sa0lSclBvc1FCTGtXKzFYRkR2bFpiQytj?=
 =?utf-8?B?VFBadHdXa3I4Y1cxUDlsWWRuMStFM3VkTVExaDRkZUxiUU9tWmdlZEpJUjlW?=
 =?utf-8?B?TysyTTJEL3lteFJHMkdEMFFqZG5jeUNCd0tWNkU3dWtRN1ZDREkwQU5xQVhZ?=
 =?utf-8?B?RzhjRmoyQjBsbTYwRWxFbGo3djlyVk83K1pLZW9SdVNyc2swK3ZRVVc0RS9L?=
 =?utf-8?B?M2tuMFZ3OXdXejBsd051R1ZrYzlYMEE0RWJxZ2pFVEJER3VHTWRxbUFMelBo?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Tv+8gye2uXaAgPmskv+9ZonWolE4NTqK46tFZ/RuLXmUcYRm3myvNaXm0YbzZVRScRnRoGiflcoS1ufBNtDPSGuJZx49Q6bmo8xDTNVSHmsNqQYMOKPrgraK/tSaFUUHVMBM8s9vmixgCcmZ5wr2cVKbK4/ZlSPuEydIrInnhucbmkiIWhjPuP7bHm65ci3LtRigIVu1rqtFdrjYh0MuT4fmLOm5ckaN9HJk1eStTFQHaL1a3YIKsT+p9OQvPbDOxrhrC39g3IyQ5hZvMr9x2zv+LkoWU8UPICx6i9s3oAYe/3jF2REff4wTb+7oXUoZH+tYz2KN/g6iWJSil8YPXu5KMCqoXlaPDw5umzPy+f3Mpd63tkryx8XlOOaJ2/lQO1EXlMl0uP8pIXG87MEuViNk8vP0wzvygGczpyr+2LmXGpiZRQa9ocJ/cWTZcPQJcoMtsAlU45/8fvW3BNC8NV0hPOe6dvkgctQhqGgULjKCkgLAZY2NltFRkGBT/ixR+WqFfsxcEMSjwCfklwL68i4YnhHsI3wrN5pEONiicLmT8jobC+5Bs0VpqL9ZGvFcuAinjahh+F8jTPb0uS6VI4rT9pSCEx0i9qpGcfXC8ps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bf75938-643a-4c2a-4170-08dc22076ba5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 02:50:44.6877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UMptanBjST17qRHp+MMhHcVaXDPFRm2Jc0rfGH35tRAjqAN/M1rL7ySmvRWL9xTXrYMAHj9uSv6RIeZjFQtf1Ko+QpiLWAeDsU0d89Uzes8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6356
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-30_14,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401310022
X-Proofpoint-ORIG-GUID: SUMRsEHvfKjYq-ZrCj1K3azV5OM_QBIU
X-Proofpoint-GUID: SUMRsEHvfKjYq-ZrCj1K3azV5OM_QBIU



On 1/30/24 16:35, Justin Tee wrote:
> In attempt to reduce the amount of unnecessary shost_lock acquisitions in
> the lpfc driver, replace shost_lock with an explicit fc_nodes_list_lock
> spinlock when accessing vport->fc_nodes lists.  Although vport memory
> region is owned by shost->hostdata, it is driver private memory and an
> explicit fc_nodes list lock for fc_nodes list mutations is more appropriate
> than locking the entire shost.
> 
> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
> ---
>   drivers/scsi/lpfc/lpfc.h         |  1 +
>   drivers/scsi/lpfc/lpfc_attr.c    | 35 +++++++++++-----------
>   drivers/scsi/lpfc/lpfc_ct.c      |  7 ++---
>   drivers/scsi/lpfc/lpfc_debugfs.c | 12 ++++----
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 50 ++++++++++++++++----------------
>   drivers/scsi/lpfc/lpfc_init.c    |  2 +-
>   6 files changed, 53 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index 8f3cac09a381..da9f87f89941 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -587,6 +587,7 @@ struct lpfc_vport {
>   #define FC_CT_RPRT_DEFER	0x20	 /* Defer issuing FDMI RPRT */
>   
>   	struct list_head fc_nodes;
> +	spinlock_t fc_nodes_list_lock; /* spinlock for fc_nodes list */
>   
>   	/* Keep counters for the number of entries in each list. */
>   	atomic_t fc_plogi_cnt;
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
> index 142c90eb210f..023f4f2c62a6 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -344,6 +344,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
>   	struct lpfc_fc4_ctrl_stat *cstat;
>   	uint64_t data1, data2, data3;
>   	uint64_t totin, totout, tot;
> +	unsigned long iflags;
>   	char *statep;
>   	int i;
>   	int len = 0;
> @@ -543,7 +544,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
>   	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
>   		goto buffer_done;
>   
> -	spin_lock_irq(shost->host_lock);
> +	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   
>   	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
>   		nrport = NULL;
> @@ -617,7 +618,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
>   		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
>   			goto unlock_buf_done;
>   	}
> -	spin_unlock_irq(shost->host_lock);
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   
>   	if (!lport)
>   		goto buffer_done;
> @@ -681,7 +682,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
>   	goto buffer_done;
>   
>    unlock_buf_done:
> -	spin_unlock_irq(shost->host_lock);
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   
>    buffer_done:
>   	len = strnlen(buf, PAGE_SIZE);
> @@ -3765,15 +3766,14 @@ lpfc_nodev_tmo_init(struct lpfc_vport *vport, int val)
>   static void
>   lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
>   {
> -	struct Scsi_Host  *shost;
>   	struct lpfc_nodelist  *ndlp;
> +	unsigned long iflags;
>   #if (IS_ENABLED(CONFIG_NVME_FC))
>   	struct lpfc_nvme_rport *rport;
>   	struct nvme_fc_remote_port *remoteport = NULL;
>   #endif
>   
> -	shost = lpfc_shost_from_vport(vport);
> -	spin_lock_irq(shost->host_lock);
> +	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
>   		if (ndlp->rport)
>   			ndlp->rport->dev_loss_tmo = vport->cfg_devloss_tmo;
> @@ -3788,7 +3788,7 @@ lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
>   						       vport->cfg_devloss_tmo);
>   #endif
>   	}
> -	spin_unlock_irq(shost->host_lock);
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   }
>   
>   /**
> @@ -3974,8 +3974,8 @@ lpfc_vport_param_init(tgt_queue_depth, LPFC_MAX_TGT_QDEPTH,
>   static int
>   lpfc_tgt_queue_depth_set(struct lpfc_vport *vport, uint val)
>   {
> -	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
>   	struct lpfc_nodelist *ndlp;
> +	unsigned long iflags;
>   
>   	if (!lpfc_rangecheck(val, LPFC_MIN_TGT_QDEPTH, LPFC_MAX_TGT_QDEPTH))
>   		return -EINVAL;
> @@ -3983,14 +3983,13 @@ lpfc_tgt_queue_depth_set(struct lpfc_vport *vport, uint val)
>   	if (val == vport->cfg_tgt_queue_depth)
>   		return 0;
>   
> -	spin_lock_irq(shost->host_lock);
>   	vport->cfg_tgt_queue_depth = val;
>   
>   	/* Next loop thru nodelist and change cmd_qdepth */
> +	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp)
>   		ndlp->cmd_qdepth = vport->cfg_tgt_queue_depth;
> -
> -	spin_unlock_irq(shost->host_lock);
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   	return 0;
>   }
>   
> @@ -5236,8 +5235,8 @@ lpfc_vport_param_show(max_scsicmpl_time);
>   static int
>   lpfc_max_scsicmpl_time_set(struct lpfc_vport *vport, int val)
>   {
> -	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
>   	struct lpfc_nodelist *ndlp, *next_ndlp;
> +	unsigned long iflags;
>   
>   	if (val == vport->cfg_max_scsicmpl_time)
>   		return 0;
> @@ -5245,13 +5244,13 @@ lpfc_max_scsicmpl_time_set(struct lpfc_vport *vport, int val)
>   		return -EINVAL;
>   	vport->cfg_max_scsicmpl_time = val;
>   
> -	spin_lock_irq(shost->host_lock);
> +	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
>   		if (ndlp->nlp_state == NLP_STE_UNUSED_NODE)
>   			continue;
>   		ndlp->cmd_qdepth = vport->cfg_tgt_queue_depth;
>   	}
> -	spin_unlock_irq(shost->host_lock);
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   	return 0;
>   }
>   lpfc_vport_param_store(max_scsicmpl_time);
> @@ -6853,17 +6852,19 @@ lpfc_get_node_by_target(struct scsi_target *starget)
>   	struct Scsi_Host  *shost = dev_to_shost(starget->dev.parent);
>   	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
>   	struct lpfc_nodelist *ndlp;
> +	unsigned long iflags;
>   
> -	spin_lock_irq(shost->host_lock);
> +	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   	/* Search for this, mapped, target ID */
>   	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
>   		if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
>   		    starget->id == ndlp->nlp_sid) {
> -			spin_unlock_irq(shost->host_lock);
> +			spin_unlock_irqrestore(&vport->fc_nodes_list_lock,
> +					       iflags);
>   			return ndlp;
>   		}
>   	}
> -	spin_unlock_irq(shost->host_lock);
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   	return NULL;
>   }
>   
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index 315db836404a..633b8ba25bc3 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -1853,11 +1853,10 @@ static uint32_t
>   lpfc_find_map_node(struct lpfc_vport *vport)
>   {
>   	struct lpfc_nodelist *ndlp, *next_ndlp;
> -	struct Scsi_Host  *shost;
> +	unsigned long iflags;
>   	uint32_t cnt = 0;
>   
> -	shost = lpfc_shost_from_vport(vport);
> -	spin_lock_irq(shost->host_lock);
> +	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
>   		if (ndlp->nlp_type & NLP_FABRIC)
>   			continue;
> @@ -1865,7 +1864,7 @@ lpfc_find_map_node(struct lpfc_vport *vport)
>   		    (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE))
>   			cnt++;
>   	}
> -	spin_unlock_irq(shost->host_lock);
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   	return cnt;
>   }
>   
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
> index ea9b42225e62..03abc401c5f2 100644
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> @@ -806,10 +806,10 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
>   {
>   	int len = 0;
>   	int i, iocnt, outio, cnt;
> -	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
>   	struct lpfc_hba  *phba = vport->phba;
>   	struct lpfc_nodelist *ndlp;
>   	unsigned char *statep;
> +	unsigned long iflags;
>   	struct nvme_fc_local_port *localport;
>   	struct nvme_fc_remote_port *nrport = NULL;
>   	struct lpfc_nvme_rport *rport;
> @@ -818,7 +818,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
>   	outio = 0;
>   
>   	len += scnprintf(buf+len, size-len, "\nFCP Nodelist Entries ...\n");
> -	spin_lock_irq(shost->host_lock);
> +	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
>   		iocnt = 0;
>   		if (!cnt) {
> @@ -908,7 +908,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
>   					 ndlp->nlp_defer_did);
>   		len +=  scnprintf(buf+len, size-len, "\n");
>   	}
> -	spin_unlock_irq(shost->host_lock);
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   
>   	len += scnprintf(buf + len, size - len,
>   			"\nOutstanding IO x%x\n",  outio);
> @@ -940,8 +940,6 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
>   	if (!localport)
>   		goto out_exit;
>   
> -	spin_lock_irq(shost->host_lock);
> -
>   	/* Port state is only one of two values for now. */
>   	if (localport->port_id)
>   		statep = "ONLINE";
> @@ -953,6 +951,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
>   			localport->port_id, statep);
>   
>   	len += scnprintf(buf + len, size - len, "\tRport List:\n");
> +	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
>   		/* local short-hand pointer. */
>   		spin_lock(&ndlp->lock);
> @@ -1006,8 +1005,7 @@ lpfc_debugfs_nodelist_data(struct lpfc_vport *vport, char *buf, int size)
>   		/* Terminate the string. */
>   		len +=  scnprintf(buf + len, size - len, "\n");
>   	}
> -
> -	spin_unlock_irq(shost->host_lock);
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>    out_exit:
>   	return len;
>   }
> diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
> index 7c4356d87730..08acd5d398aa 100644
> --- a/drivers/scsi/lpfc/lpfc_hbadisc.c
> +++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
> @@ -4860,10 +4860,10 @@ void
>   lpfc_nlp_set_state(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>   		   int state)
>   {
> -	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
>   	int  old_state = ndlp->nlp_state;
>   	int node_dropped = ndlp->nlp_flag & NLP_DROPPED;
>   	char name1[16], name2[16];
> +	unsigned long iflags;
>   
>   	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
>   			 "0904 NPort state transition x%06x, %s -> %s\n",
> @@ -4890,9 +4890,9 @@ lpfc_nlp_set_state(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>   	}
>   
>   	if (list_empty(&ndlp->nlp_listp)) {
> -		spin_lock_irq(shost->host_lock);
> +		spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   		list_add_tail(&ndlp->nlp_listp, &vport->fc_nodes);
> -		spin_unlock_irq(shost->host_lock);
> +		spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   	} else if (old_state)
>   		lpfc_nlp_counters(vport, old_state, -1);
>   
> @@ -4904,26 +4904,26 @@ lpfc_nlp_set_state(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>   void
>   lpfc_enqueue_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   {
> -	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
> +	unsigned long iflags;
>   
>   	if (list_empty(&ndlp->nlp_listp)) {
> -		spin_lock_irq(shost->host_lock);
> +		spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   		list_add_tail(&ndlp->nlp_listp, &vport->fc_nodes);
> -		spin_unlock_irq(shost->host_lock);
> +		spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   	}
>   }
>   
>   void
>   lpfc_dequeue_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
>   {
> -	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
> +	unsigned long iflags;
>   
>   	lpfc_cancel_retry_delay_tmo(vport, ndlp);
>   	if (ndlp->nlp_state && !list_empty(&ndlp->nlp_listp))
>   		lpfc_nlp_counters(vport, ndlp->nlp_state, -1);
> -	spin_lock_irq(shost->host_lock);
> +	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   	list_del_init(&ndlp->nlp_listp);
> -	spin_unlock_irq(shost->host_lock);
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   	lpfc_nlp_state_cleanup(vport, ndlp, ndlp->nlp_state,
>   				NLP_STE_UNUSED_NODE);
>   }
> @@ -5421,8 +5421,8 @@ lpfc_unreg_hba_rpis(struct lpfc_hba *phba)
>   {
>   	struct lpfc_vport **vports;
>   	struct lpfc_nodelist *ndlp;
> -	struct Scsi_Host *shost;
>   	int i;
> +	unsigned long iflags;
>   
>   	vports = lpfc_create_vport_work_array(phba);
>   	if (!vports) {
> @@ -5431,17 +5431,18 @@ lpfc_unreg_hba_rpis(struct lpfc_hba *phba)
>   		return;
>   	}
>   	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
> -		shost = lpfc_shost_from_vport(vports[i]);
> -		spin_lock_irq(shost->host_lock);
> +		spin_lock_irqsave(&vports[i]->fc_nodes_list_lock, iflags);
>   		list_for_each_entry(ndlp, &vports[i]->fc_nodes, nlp_listp) {
>   			if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
>   				/* The mempool_alloc might sleep */
> -				spin_unlock_irq(shost->host_lock);
> +				spin_unlock_irqrestore(&vports[i]->fc_nodes_list_lock,
> +						       iflags);
>   				lpfc_unreg_rpi(vports[i], ndlp);
> -				spin_lock_irq(shost->host_lock);
> +				spin_lock_irqsave(&vports[i]->fc_nodes_list_lock,
> +						  iflags);
>   			}
>   		}
> -		spin_unlock_irq(shost->host_lock);
> +		spin_unlock_irqrestore(&vports[i]->fc_nodes_list_lock, iflags);
>   	}
>   	lpfc_destroy_vport_work_array(phba, vports);
>   }
> @@ -5683,12 +5684,11 @@ lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
>   struct lpfc_nodelist *
>   lpfc_findnode_mapped(struct lpfc_vport *vport)
>   {
> -	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
>   	struct lpfc_nodelist *ndlp;
>   	uint32_t data1;
>   	unsigned long iflags;
>   
> -	spin_lock_irqsave(shost->host_lock, iflags);
> +	spin_lock_irqsave(&vport->fc_nodes_list_lock, iflags);
>   
>   	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
>   		if (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE ||
> @@ -5697,7 +5697,8 @@ lpfc_findnode_mapped(struct lpfc_vport *vport)
>   				 ((uint32_t)ndlp->nlp_xri << 16) |
>   				 ((uint32_t)ndlp->nlp_type << 8) |
>   				 ((uint32_t)ndlp->nlp_rpi & 0xff));
> -			spin_unlock_irqrestore(shost->host_lock, iflags);
> +			spin_unlock_irqrestore(&vport->fc_nodes_list_lock,
> +					       iflags);
>   			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE_VERBOSE,
>   					 "2025 FIND node DID MAPPED "
>   					 "Data: x%px x%x x%x x%x x%px\n",
> @@ -5707,7 +5708,7 @@ lpfc_findnode_mapped(struct lpfc_vport *vport)
>   			return ndlp;
>   		}
>   	}
> -	spin_unlock_irqrestore(shost->host_lock, iflags);
> +	spin_unlock_irqrestore(&vport->fc_nodes_list_lock, iflags);
>   
>   	/* FIND node did <did> NOT FOUND */
>   	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
> @@ -6742,7 +6743,7 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
>   	struct lpfc_vport **vports;
>   	int i, ret = 0;
>   	struct lpfc_nodelist *ndlp;
> -	struct Scsi_Host  *shost;
> +	unsigned long iflags;
>   
>   	vports = lpfc_create_vport_work_array(phba);
>   
> @@ -6751,8 +6752,6 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
>   		return 1;
>   
>   	for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
> -		shost = lpfc_shost_from_vport(vports[i]);
> -		spin_lock_irq(shost->host_lock);
>   		/*
>   		 * IF the CVL_RCVD bit is not set then we have sent the
>   		 * flogi.
> @@ -6760,15 +6759,16 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
>   		 * unreg the fcf.
>   		 */
>   		if (!(vports[i]->fc_flag & FC_VPORT_CVL_RCVD)) {
> -			spin_unlock_irq(shost->host_lock);
>   			ret =  1;
>   			goto out;
>   		}
> +		spin_lock_irqsave(&vports[i]->fc_nodes_list_lock, iflags);
>   		list_for_each_entry(ndlp, &vports[i]->fc_nodes, nlp_listp) {
>   			if (ndlp->rport &&
>   			  (ndlp->rport->roles & FC_RPORT_ROLE_FCP_TARGET)) {
>   				ret = 1;
> -				spin_unlock_irq(shost->host_lock);
> +				spin_unlock_irqrestore(&vports[i]->fc_nodes_list_lock,
> +						       iflags);
>   				goto out;
>   			} else if (ndlp->nlp_flag & NLP_RPI_REGISTERED) {
>   				ret = 1;
> @@ -6780,7 +6780,7 @@ lpfc_fcf_inuse(struct lpfc_hba *phba)
>   						ndlp->nlp_flag);
>   			}
>   		}
> -		spin_unlock_irq(shost->host_lock);
> +		spin_unlock_irqrestore(&vports[i]->fc_nodes_list_lock, iflags);
>   	}
>   out:
>   	lpfc_destroy_vport_work_array(phba, vports);
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 1285a7bbdced..c43118fab4aa 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3829,7 +3829,6 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
>   			vports[i]->fc_flag &= ~FC_VFI_REGISTERED;
>   			spin_unlock_irq(shost->host_lock);
>   
> -			shost =	lpfc_shost_from_vport(vports[i]);
>   			list_for_each_entry_safe(ndlp, next_ndlp,
>   						 &vports[i]->fc_nodes,
>   						 nlp_listp) {
> @@ -4833,6 +4832,7 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
>   
>   	/* Initialize all internally managed lists. */
>   	INIT_LIST_HEAD(&vport->fc_nodes);
> +	spin_lock_init(&vport->fc_nodes_list_lock);
>   	INIT_LIST_HEAD(&vport->rcv_buffer_list);
>   	spin_lock_init(&vport->work_port_lock);
>   

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
