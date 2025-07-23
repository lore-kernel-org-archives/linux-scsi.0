Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49A222DF86
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 11:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753268692; cv=fail; b=dFVZgNJgkYf2w0GUyzPx9QfPtapSgde8/q/Mli0nuRY6MhZr16PRUeQjbBw4zremr84wWp38VotDuG+JLw/tDpWdEmx0g0+M8Z0ULI4jSAvYMCUCWitchb7ki7WJ0Q+SDEGzaCD0malSKDs3/07TnSoLxZvVWugI0FaSgtSPy5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753268692; c=relaxed/simple;
	bh=iRWCkE6NZ34UuJDWAfRGpbRAU/6MqbaarizuBb2f0UQ=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p4O74XH6Y/2pMs9shMh7zXYejG2ZAXNd/vh5JXX/7tPWnUxoMZ08aK9tKpry9krXZjntAn8vzygJpqlrrn4zhdLgMkKKUTeTLmwkGrMjXOUBv2m3TxIB6P3Li1rlRNru+zRW6RJDODEvFl7lhLebwTSCoV3YB1a4y9p3+xU+/A4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b1+mPqGG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iMdHyD4+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b1+mPqGG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iMdHyD4+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8NJiD032763;
	Wed, 23 Jul 2025 11:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qknn1CDo1e3a28/mR9gyqdt7htTtk7aC4mCOPYwi3RE=; b=
	b1+mPqGGp4n8+qA6Dva+Qs8YZ4SrnJt4UqoectojUwr11pcqB+r5xHYm6LGLqrqM
	DpGBmlLVgg42AwO8ybuEB4aLT//f6Bx7qsZk0ereT9+doWgCPDUHlaNG1fku2E0K
	bMayNPpeITcn6vcFyNRW+765NdSaH6LrOD9C3igXy47o1fJA+LhEfHVEa+O36wBK
	K0qppgsyr1pVO05EfmdDUO8e+W+AFvMfOlzdxEZu2MiF23XuFxPtTG0RPnY/GKZr
	9dFdj1RbzGA7tVDXyUPytgmIc9Y3s8vgYoR1iibCRk/t/EqP8GGLsRce58f3Ce1N
	QPvAC1RqvkGALJHSss7cXw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48056ef990-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 11:04:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N9DsQo010800;
	Wed, 23 Jul 2025 11:04:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2057.outbound.protection.outlook.com [40.107.94.57])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tae5wx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 11:04:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oJAi4lyiuNwXldNX9hGIRdgT7AuBqiT5FJMKJCTgyo1/hh0ZC4TodYevmzbKNc2/9iOIr8+n2akfH4u8Rz/4Rbvv312N8CIKDlixlHjgm+9gaPvOimSiYQDlcC7gL5FPJc2LlU3yOB5T52KS4qWOEaLK1m1Ke+OvShRi9BxDGzjGZE+L7llU2wome7y2ZNAeKPgl928YwyhfPt8amieA9KVjIyQz09gW9KRM612D7nDknxYl6Gw4DEHOCOBfUNNG8xQh+0YbiTcgFfPIgRxJU3U6NGO285cCK5XfBqqAlbXPK/xHWA2HAEnvit+kYBZB1ROzmqM51pqMXqutAf8AgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qknn1CDo1e3a28/mR9gyqdt7htTtk7aC4mCOPYwi3RE=;
 b=iyb5vEjtGFZYB5cuR6mhwXy0gc8QKzyBf5YsP/1OITj6hve/8adretQAuaDVM7kepIWNlCE0VkYpcMJK9VTYTxtKUExB8nTEC+Z+sc4yyOPgWpUfKbUDHvpwF00pxT0iW14qbdyX0gN5VZ6lmGmY2/AuCdoy0QTL44whgyG12nuNbcMcn0wYgJQ8YywvIlmgLXBXrd62SxqtMALjVW6abgPA1LGxnSkD+paWXGpgOS+shMJnfOs9Yl0a92HILDgQo8ah7Nnr2r/cj3Vslm4r5ANOIglfwrKpYEQLWldp7r3I0ADhDiD/dqBNm1mZiYvaPfHTYbdtCk02AYoFGxpl0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qknn1CDo1e3a28/mR9gyqdt7htTtk7aC4mCOPYwi3RE=;
 b=iMdHyD4+xLQLlLM79KNEIgA1nK60XreuGz1ZxSj0+4KuN0ATRlLthMNQ8Ow/AjWmUdW8wdjgUnSe2N22inCZmaBe9d0QxgASYYUc4VNxb78A7b/RP4eKERp8ouohQ/55tpQs6w7KDAq7bmk/bzNwmBTzvFspfyoZWjFPoDoJqbY=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SA1PR10MB7753.namprd10.prod.outlook.com (2603:10b6:806:3a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.24; Wed, 23 Jul
 2025 11:04:44 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 11:04:44 +0000
Message-ID: <45f2e6c5-495c-47b9-9fb3-bf7fa8ebd652@oracle.com>
Date: Wed, 23 Jul 2025 12:04:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] scsi: libsas: Simplify sas_ata_wait_eh()
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20250723085143.134333-1-dlemoal@kernel.org>
 <20250723085143.134333-3-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250723085143.134333-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0322.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SA1PR10MB7753:EE_
X-MS-Office365-Filtering-Correlation-Id: 054eda7c-4a15-4157-8f9b-08ddc9d8bae3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXNTM3M3bDFWZm1LTGtXYldLQmhwMXRwenNlamNRbWxac1ZybmNQcFFYcGJv?=
 =?utf-8?B?MzZyZHJtaGRMNFlwczcxRWlCbGtTMDMwWFpQSHI5VDFJTnZvM3NVM3R0NkFF?=
 =?utf-8?B?UExnclNKbjRpOHBHMWRKUy9lYlpPUWREcVFzQlRNVHZDcUhndzM5ZWU1Y1Fp?=
 =?utf-8?B?SXcvQnRoNlVaMklzZE5NUXU1RnE3Tjl1WjlROERMcU9qVGJrTkNMRVVUUlFF?=
 =?utf-8?B?dmdjUDV0MmRSRDVaQTlBMVVmRE00VzVxNHNkNkx0eCtMc3VTai95TWkxaEJy?=
 =?utf-8?B?bW5BUGJiYTdSYVB5VUxjMmtlb213TWxXWDFIbG9HYXBDdWhZMjlrcU9aaVZn?=
 =?utf-8?B?L2t0dG9laTJSbkFoRlBmRitRa3ZiMnFyQUdUa0ZYRjFqaVp2dmJwdFVTQUJ1?=
 =?utf-8?B?b2RTUE92eW1zTTBCdjdnSXRrdUNyeGJ1RUx1am9FQzFJZWg1eDM2bHJpMncy?=
 =?utf-8?B?ZlVDQVRoTHJ2TnRzckI0Q1F1aktINUEwM1RvMXA1WGhSZDZIRXc3cVM3dVhs?=
 =?utf-8?B?WndWWVdWYU9kN0tNOExBeFZmM0lFNFVmSHRUc3EvcUpkR3NyMWd3UFUvY0Rn?=
 =?utf-8?B?YldzYmhpeTB4NkladWQzdXRpdzVieEQ5RkdQM3dWbitQMVg2T0FtVzBpY2kz?=
 =?utf-8?B?TXRueU1FKzBKVnptcktoUjZMbkFhbzBjQ1VIRkZMNlZmVkhOSzFNVnNvQ3Vh?=
 =?utf-8?B?VUlqMHEySGwxZ3hDTXNHYU1mSmJXVmdMc3dkNUZ4YTA1ZVpheDMwYURnaTZD?=
 =?utf-8?B?N2dTL24yeVExVDFuSWNnSUluZTNUeXMrQjg0SWd2bjVGSndSQ1BuejFXTG9t?=
 =?utf-8?B?aHovMDc4NmtZUjQzQkh2TjVmWS9RQW42TEdwdnV6QVpBQVRoVERiNWJWbFpI?=
 =?utf-8?B?VmZ0NGFoeUQ5ajNiTmhZbEtWaDhHSUphM0ZNWDNpb2ZDTVp1TkM0U3EyWnV3?=
 =?utf-8?B?S1FlNHg3eTh6VDVzS0ljUHI2UnlweXNsQysreFhtZWxkTG94QUNsWGhoOHZr?=
 =?utf-8?B?NGhPdVlldVpmaGJIbHRZcU9vZ0lDWDVpV25BeDlUVXlHeEZ1ai93dzBTc0o5?=
 =?utf-8?B?aWlTWm5lbFFXeUY1ZWRERVRUYUNLem92cFViTWt2K1V3akt3Tlp2YXcvUDMy?=
 =?utf-8?B?Zm84aFRrMFRzMFE3YUVQTHZOa0IwRXYyUkZEWkN3QVdtOU5EM0hJTTlXSi9w?=
 =?utf-8?B?UzF6YW1DWi9Ld3RaSWhYS3RuOTZjOW5CWHlvS3Z4VSs4QWpsb0hnc0RNTnEv?=
 =?utf-8?B?cE5VM2trYU84MGcrNXFaTFNySTdCZmtmTFVtSnJ1UGUyZCtQVmFoQkVvR0Ns?=
 =?utf-8?B?TUVqRWQ1UmNEVFcwbzlSaHhWZWVsaERoY1VSaXJrSldhYTlEU0IySFRhWjBC?=
 =?utf-8?B?dGZMd3NsVzNtYmJvazBYRUcyVDllbnRyTzNIYlV2b09jS05PL3gvMTg3cDRu?=
 =?utf-8?B?eFlJaGpUT0hLdUNMUE9zajlNa290ZnRhV3NnbkhzVkdPck1UbTFTVmNPTUVU?=
 =?utf-8?B?RnlIM1d5akdSUzNJUVl6RlZSWWlRaEJtZFpBcEJhZi9uNzZsUGpkTFVjdDA1?=
 =?utf-8?B?R2lGUGVaalBYQm0xd0dOTkxFRlVPMll3Z204Y3Z4Mm1MMGM3Q1FZc2Ird0Fs?=
 =?utf-8?B?UVlLNHM5Z0RuaWRoSXlocXdNc1oybmhxNVFMakY2aFVCaTZLQkI4M2lYVlhQ?=
 =?utf-8?B?SVBNTS9WS0pRYVVmSElKWE9DeGVTWXRjZURNNTlOK05TSkVXYmxhQ1M0Zzlt?=
 =?utf-8?B?WDJZKzlxNTR5VTdNQThJYzZ4ZXBuOGNTSGRZRG5DRUM3RHR2Ky9zbTY3ZnhD?=
 =?utf-8?B?VTZkWGpZTlFGdGptV3l4T3hsVWNuREJKWktBbXl1Uy84bUhPYWZwSGlDYWJT?=
 =?utf-8?B?Q0R6em1WT29GWkVNaWxKMGswZGJ1NUZYWk4rK2U5c0kxakp3Qy9NYnU0M3ZE?=
 =?utf-8?Q?cYblc+M41+Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVNyNCt5YlFMUUdaTFBib0NVMmh0TzhLeXpjWDJzMjhpaWVVSzBoWmZhTzk2?=
 =?utf-8?B?ZFdRdytuaTNrNUs2YVV3bFR5OGx3cTI2UXFXaWpCZ254Y0ptMW4zdndBQ0U0?=
 =?utf-8?B?aytoVG9UZEEvV3cwT1F2ZnMxaGZ3bFYycFpUU2NHeWNoT3lFUXNVb29SaHM4?=
 =?utf-8?B?MDhOM1VRKzRSc3YzNW5YNzFGRVc0eTRMOWt2LzRTQnVYcXdpYnJxV3dkdWto?=
 =?utf-8?B?WVZtUEhaQ1RpTWsrdVI0dmRjemZMRGdpYmFxbVJsTEI5L0twWThkQmowb0g0?=
 =?utf-8?B?dnJ1Um1VdmNzRGtncDF1ZENNelVzYjZ1S0xLQ3liSHBacVdLcXNsMTYxc0Fh?=
 =?utf-8?B?dkxGd2N2VVgzTXpyNUNZZ3l2Uy9menNhdTNsWGlReGlXdEpkOUpTS0ZMUk1X?=
 =?utf-8?B?OGZqK3NkVjJXaFpsRU1FUlJVenVLSDJJdWM5ZEV3aUFRajY4MmxWeXJTM3Q0?=
 =?utf-8?B?Z3dtV0tGQkhwMWV5QjUyVjhhTStIWkptbDRPN2dIYndVVkpqRmdReE5rdGNn?=
 =?utf-8?B?N2RRbWRJR3VsbVVyYkZkQnNETTIrdHRFSkgvV0dPR2ZTek1ESUhCYTdPS2JR?=
 =?utf-8?B?eEkzaWZKc1VUOE9WbzR6VEovcG54MWdSZFRLUGg3Y2FqcWFYYUs1V3JKemlK?=
 =?utf-8?B?T2J4dWlGZ1kvTEhzOHYzZ0Q0cDNwaTZKaHUwOGl3UkE2ZGF5QWVtbUdndVdj?=
 =?utf-8?B?a2I3Tjh0MForVWNSTTFpNDQ0OEpiSWZXeWs5U1YyL2dmMkJkeERqaDJOVEpr?=
 =?utf-8?B?TWs1TVhhSXgxblVKcHd0anlxMHY5M2RTdE82TFBpdDZTTHZPNk93ZTBTczZN?=
 =?utf-8?B?bjh0MFFOYjc3UlVmM2twUmZiMFA3WWRKaWxEYWpheWZCdEZEU0NpU2JlTEZJ?=
 =?utf-8?B?V2tUdG9VRHVnUG41UExkUThBN3M0Skg3M2hwN0ZIWStucGZPdU5ucTJrTklk?=
 =?utf-8?B?b3RiTit1eTZkWEE4VSswSFBiVCttejhKRUxCanI2TTdtbU0zUS8xSmxZTEJr?=
 =?utf-8?B?aDlaWHhrUFJ6Vmhuc28wUUxabFJvK1IzR3Q4Qmc1bHRsWkF1U3NCOVplRHl6?=
 =?utf-8?B?NXVNd3daU2tFd3ExR0dHVFdBcjd2ZGxZcWRmS1JYY25GWUNZNXpVU09GaFBD?=
 =?utf-8?B?Z3IyUDZFUWpQQ0xrajE3aHhCOVlmb2xRTldGRUNVZUdOZ3h2djg4Ym40UlFn?=
 =?utf-8?B?Nmp6MGkwRWlCSFFBWEtuL3I2b25hUWdhb0hOWE1rWnp5VWlHMmFYTnlOalBv?=
 =?utf-8?B?UzlOU0dhSUVvWVRhNml0LzBiditKRlNLQ1BmZ0plb09iYnZmVS9KWmtEaStZ?=
 =?utf-8?B?NzFDR0lWV05HSUZuMHdBYjlqbHNsd1NKT0h6aUpuNlA2eStuNTBWMlRNM0ph?=
 =?utf-8?B?b2doVnVFcGNxbllVVE5qbUZHOUt2QWNWcEV1TGtnVnRaVWZ4ZkZodGhvTkp1?=
 =?utf-8?B?LzIrZFIvajkwcFFjVUloM3dnSHFnN3dTWGF6ZjhmanI2NEI1WjlMdGFiMFJi?=
 =?utf-8?B?azVEVXFMa3lYYndKZjBSQW5veUxsZnh6Q3RPVVZtRDI2N29iQndScGtWOHA0?=
 =?utf-8?B?aDhFWmFlbTY0L1ovaVMyR3c3TVpLL1A2SW4vY0lNeE9waUp3R01DUllUdjk2?=
 =?utf-8?B?ZUM3elVCaEJkNGpka0w1d2VTbDNNeCs4SkJia0JkYWR5N3dndm1Tdyt0ckRq?=
 =?utf-8?B?MU9ScVJOVWJ1b28yYmY1RmZBZFByNHdYRkxMakhGbUlEdXlmYStvdDFGR1VH?=
 =?utf-8?B?aGlOMXdsZE54NS9CWklMQ2FFU21UbmYzWTlncmRGaTRIV2FjUnZVU21oZkMy?=
 =?utf-8?B?aGwrRDdJbUk0eDJzUk1ZNkpMS0c1Q1Y0dWJVUFJ6S3NzMHNEUUZsQVVEN2F4?=
 =?utf-8?B?OTg2R3hYN2tqY2NLWlhrOTNhbGVJT1hWVlpBbHF1WUR2dGpsa09ZU1IzTDVQ?=
 =?utf-8?B?QjRkSEVORGVjRUhVOC9KS2lIdDZnVldiL1JGUjZFNWFTSCtyRlloWmdqaGxz?=
 =?utf-8?B?QW1tTTJSMStIZVk2N3A0dDNPV0F1V0U0L2J2VDgvOXc0ZVd0V2ppS2ltOHFV?=
 =?utf-8?B?TGlPb21IdThkbXZ6YlhKU0Fiam15Qzh0YVdFSzcwVkVoUWYvY1VGTEhUcHRF?=
 =?utf-8?B?cXFKMUFiclU1VWN0WWpqNDlMOHc3TlcvQlQ5QU5NNUF6T0lRVm9SSTNhbHlQ?=
 =?utf-8?B?bUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	unZOx9ZYvBmT6NyrAqpymXkmzE4mxnuy4BH4cEpmoAHzokPrCLpR5PzGxErtNr7Dbr+fbUguBYcyMc6cELBn295DjQkOe3HXuzvUFEmFIO9wCLEQUvrktsRYgrsqpMq0ZMH/EDA/czAL8VBHYmt52VtXbKhl3WzFyKazv2aE0Lw6AaS9DoM8LpvRipxeyHPoa4UILb266N+0Phc6wMjOXBDA8kkF1k9GkVI3l2RKf0WGhzxXtsZHGdpv4GjtGTuDftzqEcerDqj8Q9Zit84bHjuoXYZT0S+dKSUMuDuAIguVUumk2d5c0TTyWPLXK4YZSQbkDBS9X1g+piFrk/yFOuIPw9I5CiEg984+366hatvzM9OMXtIPewXSaY76KznmEh5tuLSJ5iuSsj6CKJzceY7ikSor2NuH1dTOqjxFww8fopaOrvNflX9iKkNS8Oc4k20esgTGdNVzJbi9VjgAHbqAZy+Q8+pyc8qwhSZYeUqZn1r+ZJX9MsSe+eOyghJLtr1ye67KZB4ILzFt2k/3ohFvDPUdYL6jFposTO6F/2Ye4OP0hbF6wpHBNML9IGs1N8mpbUi8qPMGhK2rNvnIB/oct65q+FAYM+DPK1T5+9M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 054eda7c-4a15-4157-8f9b-08ddc9d8bae3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 11:04:44.3975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bByFgl36AvcKbLt5vdIVoS5u8vsU59VyFXFMtF2zsDwc9x5Yjb5ZvdejQnKiMRaNl5lBNWTN51ID6cj44dHQwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7753
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507230094
X-Proofpoint-ORIG-GUID: ZpvbDNBMWTkohwkwora8Zq6YJTyF8Ybh
X-Proofpoint-GUID: ZpvbDNBMWTkohwkwora8Zq6YJTyF8Ybh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA5MyBTYWx0ZWRfX4pNm76b42oi3
 f8CgltfnjOd20BDYla6Bm+QyWQPpHZspXka6VkfAOiX6mJgJv0p6pkU01sJSbDy/Jbhfgj0R7eO
 tvombi2D/HxXPNKLXZeNYJkJp7B6p4zDmRhOpHPjiIbH86AOqwss9lX5XnAVBAHuROBupK7TITR
 8Xkx5jnyFNMkQCuC/AHSDIxu+BQNT1ktrmFvc1OUFOeDveIYzyNTDTqZc60oVgvqhB92HSKsYrA
 PrLC0st3ZPoQIf/FyDHBwzqpY9QW2iniHo/U0ZO2qqSC0M5T4NoPOh3HG+jJBXgUJYRg6W+MhvR
 86qa9kJ7iuU6OlJLBNL5CN2whINUufzygUzVqCw9BteWLDhzRZZo3huaj/NQvtip2elYXqVlYzd
 fjUN9qYoAJWx0h4K+glCISQJyAIWL3JsGAzMoVl4ntJa4OrTShKc93JhpXXyl1QI3O4JRu9h
X-Authority-Analysis: v=2.4 cv=Ef3IQOmC c=1 sm=1 tr=0 ts=6880c1d0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=1aCmbhwLv1SYP5RKocYA:9 a=QEXdDO2ut3YA:10

On 23/07/2025 09:51, Damien Le Moal wrote:
> Simplify the code of sas_ata_wait_eh(), removing the local variable ap
> for the pointer to the device ata_port structure.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
 > --->   drivers/scsi/libsas/sas_ata.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index 7b4e7a61965a..440efdc714f7 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -927,13 +927,8 @@ EXPORT_SYMBOL_GPL(sas_ata_schedule_reset);
>   
>   void sas_ata_wait_eh(struct domain_device *dev)
>   {
> -	struct ata_port *ap;
> -
> -	if (!dev_is_sata(dev))
> -		return;
> -
> -	ap = dev->sata_dev.ap;
> -	ata_port_wait_eh(ap);
> +	if (dev_is_sata(dev))

note that all callsites seem to check whether the dev is sata, so I 
wonder why even have that check?

other sas_ata.c function have the same pattern.


> +		ata_port_wait_eh(dev->sata_dev.ap);
>   }
>   
>   void sas_ata_device_link_abort(struct domain_device *device, bool force_reset)

