Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C781D27B34E
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 11:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763034527; cv=fail; b=AjzZq6uK0CE1KCU3wkgN/XbgN3aH2ZaMJl4sAJGWoqBD0w3VN6d4uh+I4tPErjUCbQaosyWNWSAmL7VyHBa3482q6/IZbuEe/vb/fJtIAg0VpflLk98aqrooqkEhRKpZAK0pDaRIshKeBhs5R54hQ03U+QjlbPG1n5mI8etLV94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763034527; c=relaxed/simple;
	bh=wTi7mwgwcq1ta6JME4aB0uYSFP+NSKTarQPg1MwQ10Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kF03m4Uv/I1ZYarxN04fQSRNXprLl2ptYuAsOZxdEaS7wfYGH5NOviOBjdA38aNIfKMwT7IoUBv1KXh4u8TT/6XGXp49f5JmtoTFpsenhzwD43O1UpUl4bcJTMG5IFTyx5uG1vojIPXg9vHDbfp/8ycpUxvAOms1rreMqh9TW7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XU2RNVn+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ketAmXLz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XU2RNVn+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ketAmXLz"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1h1Wt015915;
	Thu, 13 Nov 2025 11:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Gplyo8AtXQ7W8a+RVTkU+ceAKw7R7JybYnQd8hvZIAQ=; b=
	XU2RNVn+0Y+5JeZfu5uD9NQo+pbIfzrL3B83flMyK1SemXfQjbqD6jH0HXNlkBlY
	opOTHg+HjP7r4+iaoQOotRt68hGjkpF84WroBu4gyEoKLmSdDxrSvhUKDmmf7dHD
	D82DZhUksTkgqKDTWrrouoT3OXGKd82verYICUZA5V/wL+S0HWvT0ll+sw67jmyY
	gywRz855HK1OF2tP0TaBkw/PzlEhaI4ZFa3eJFx2/beRvEuCY07Rq7HBK/b+vIQx
	Bp1jp0OvJT8bK2nnMDFes1l6zBYXuWPW+UzxeFMBS4ytJRKkeudc9Iksw5VEunrx
	etCfdK2Mzd3yujMiYQhU/g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxfvhq2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 11:48:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD9hjNI022558;
	Thu, 13 Nov 2025 11:48:28 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010021.outbound.protection.outlook.com [52.101.85.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vac13x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 11:48:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wJn0kHaYqzsIiFl++P+k5c9E1nG9wUcw5HMklQav25KsjOrjOJ2q8JG8liV/HlUMYCRs1fMp6GTPSs7lffVoRtsTPns8mUc/DAFsIyRNIo0t7HsF7j4/2DxgAkNHuO8pE2gMG4D7YS0z1TL4t4nk9hyn21r+pxq834tYS0wku2AoOCsaIzeq81t9sk2oqEacBOm1Ds6jInqYmKZaPzfqyCSbhqT5ZwU3IRNCeM55rvO98bqYQJ9VPi6o+nwH0+YJSL+YwgOzXXJWAPPPDUyYmQmuOGEeaOgJR2aWnMh5r7V902ou9UvDhPgji6/jg85DwjXJeuVhw3Ud46aAAP/67w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gplyo8AtXQ7W8a+RVTkU+ceAKw7R7JybYnQd8hvZIAQ=;
 b=FHEYq+39UGFc7915G/6v3bOi/9UfypB7RUIZyN29Xt5SDjT4wP5/8a+g+gPx+f3PCH9/htyEKL+bTx6OiEbc/bVwGaXEUqA1nDFbQMUbfhALF5npClehUTEULcJ+eljE435X7UN2R6YGO6VQiGw80/oYFwfkrT+E+5bjzAnDhAGe9fD5PGpfEfGyEYTaT58e+ZgfHfFVw+gWmwXVRJhGM59GLzO4QqVsU2/ta0e7E37xZuGFYV7YF+qMwbxlP9iGdjdXuQc9sBctB9Ac98gPeLYfJLPZ65rWCItzdgcbcSAidcpEOwVNZWzukJjRj3E3YTT+BJhKNTXHYmRni0DP0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gplyo8AtXQ7W8a+RVTkU+ceAKw7R7JybYnQd8hvZIAQ=;
 b=ketAmXLzjzCh7eceP6Jnl3AdQueS8t5b9/Ea/RQ5cqRIsbnPkNj0SXphke7mhBqDs6wgtPh7od3X2oJKwE7DkInW0oLosOBCn/ZKG0PhqyDXPG5GUgR7N6LbgPSAkskRgR2FOXshFPXnaoecuU5ZUufcP4K0Rc5RvsQAoBNGIVA=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB4728.namprd10.prod.outlook.com (2603:10b6:510:3b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 11:48:25 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Thu, 13 Nov 2025
 11:48:25 +0000
Message-ID: <4efb45b3-455a-44e8-83fa-e64ca8b9192a@oracle.com>
Date: Thu, 13 Nov 2025 11:48:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: scsi: scsi_debug: make timeout faults by set delay to maximum
 value
To: JiangJianJun <jiangjianjun3@huawei.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, hewenliang4@huawei.com, yangyun50@huawei.com,
        wuyifeng10@huawei.com
References: <7b020e5f-3fca-48eb-bd20-cb0521120f5b@oracle.com>
 <20251113112258.367-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251113112258.367-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0366.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB4728:EE_
X-MS-Office365-Filtering-Correlation-Id: 91b0afa6-600d-4d82-4fd1-08de22aa8da9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2ExcE8zNVBsSGo2bEtFc09CR3pGMkRwZGsxWjMxZ3VFY0FJeWloWm1BQXVC?=
 =?utf-8?B?cjNvMVdzTTRnbUd4RFFNVUhzSi8zUGdVYnMva2ZzWjBTSERVVkM2aDVHSlQz?=
 =?utf-8?B?Z1Yzb1BPeE5VRGVrUGcwTHFwdWJDUDhxMmZZRjM3eEY1aWdvWW4xa0JQaTZI?=
 =?utf-8?B?Um01b2FCQ3VqdEtqUGVkZ2thU1FkUVd1MVp6MXZlajhzY0hwcnpkVGhpMi9l?=
 =?utf-8?B?TFZld1luZmJmN3g0ZkM2YkdLVjZTc3pGQUQrQVVDT0gxVFFFVWZHUFJLTitV?=
 =?utf-8?B?cXVDSjNPRDJybTNKL3oyRUt0citmYXI1a2hWSkVpSkczSGwvVlp1cFF1UVZV?=
 =?utf-8?B?MklTNVJQaS9PMUJWeWQzN2FQRDFISnlrTmRwNi8zOG5CVmdxczQ3OUhQczI5?=
 =?utf-8?B?clNkVDcwYzRGMmlYdHhmT1FiU2MzaUNPSmVJUE1tSE8xQmlETGxIazNqZXBh?=
 =?utf-8?B?OFMxbnF1ZVllOVAyWFB5NXdHaUpCNWVXR1Nna1ZlRlZKMHAzK1ZiUWFkWTg5?=
 =?utf-8?B?cS92VzJuZ2J4SHpZVjh6VnQvNHVWeGpNVmlvTXRtc1FGdFJVU0NHSFFrNXVO?=
 =?utf-8?B?YkFBL3lRL3FDVjZHWHFFdGphK3kxamhURlNlYXRyaERQSVhvTW55cEJFTEdx?=
 =?utf-8?B?dGZsZXlIRXBFa3BVWVhpa2dodGVuaWJLbkRSeDVObUUvVUhuOWJybzVsUUFN?=
 =?utf-8?B?cEc4Z29YaDBScHNiUzFPWGpBZFZJVHI2N3ZOS3Y0OWN5ci9kRXNqSVMyM0tR?=
 =?utf-8?B?T3lBRFZxWEZ2QjBJbmo0R1pvT3BwcXNTUGFSTWY1T09ENUl3ODRBSVo5Ukxx?=
 =?utf-8?B?MUNocExJOWFyVm1sVjZPNENhZUNLMzhJV0tCZExRUUJNbUlMM1JkUnZFK054?=
 =?utf-8?B?Q1pDeVFMR04yeGRXeGNJTUJsKy9UdCt1YlNUaGp3eG9FOFdYeERSZ25HVDhu?=
 =?utf-8?B?UWY0ZGUxT2pUcjc4aVQzRjNTN0tGbXdTZ3RteUtYUWRlbjNjUkJOaVlUZldh?=
 =?utf-8?B?bFQzZ2RVaXJDQVlVVTEzUGtKd2M4N3Q4MmJTQ2xxVjFFWHY5RXZJMHRVZ0E5?=
 =?utf-8?B?bjJGMkoxeFhKUk56NE1pamxFNm45Q3BtdXZicDU1WU5qNy91Z2YxekxyNTBa?=
 =?utf-8?B?VWN6UWpkdTVFZlpKem42dzdVaEJhdjJ5Ym9PRlVhL2I3VHRueEFmVGpoTU55?=
 =?utf-8?B?VXovbUN5b2w1d3l5bDV2ZWxVZWhOcTg5WTJJMDd2QWptdm5NdXRFZjd3QXd2?=
 =?utf-8?B?alc4NkxFYlR2aXhvTlFCRUJZTDN6YVgzQStSRUozbGJtL0dSMnA1SzRLd3lk?=
 =?utf-8?B?NTJQczV1TWVYVElaV21qQnp2TDVkQmZvV1N5VENSTnFmTk1pYUNBeTZiMW4y?=
 =?utf-8?B?QWVrK0plQnErcTZRejBBbk80eXN6WDc4bjZkZXJGTElIaHdISzhmLzh0eDhr?=
 =?utf-8?B?ekhFWGRvOGxUZjJDcW5aY0FNUmhyNFFWRVFManp0L3FYWkFrOWl5aDdwQmh0?=
 =?utf-8?B?UkJhVzc2OXNhMG91dXJ2dEh3UEdxbDdIMmZjaU9iU0RzKzFWRm1FQmdHWEM0?=
 =?utf-8?B?RG9JeE13MDFPUzBkYi8zdzFMbHkrdGVNZm5malpnR2FzdEpjZ1ZlTGdLb2JZ?=
 =?utf-8?B?Y0lPVldyNXJEVVBkN0tMWEtHV2pZbUVkN1N0NWJzT3IxenJQT1FNSkxCdVFy?=
 =?utf-8?B?MVZaR2M4bzN1RFFvdGZCNHMxcXBWNm9FaDZQQ3dRRjZVR2J0VFg2OG5ydFow?=
 =?utf-8?B?bkJXdmo5cmxlT2tPQ3k5VGhMa0RML1lKVGFkUGdha0RUeXNJbDA4ZlJiVTJ4?=
 =?utf-8?B?bG1NNnE0VStSWXVWeXhLRlliVURyejhKNmxDa3N2cmlkYlZxS3IyaHZoYmJs?=
 =?utf-8?B?WUhIMkZxeHV1UG91ZGcrL3gzMnpoWUZCOWZ0bGZGOXN1WjN3Z2o4SlRGKytS?=
 =?utf-8?Q?sYuvRbCfpdh9jqyNlRNfwlTnsJf09noS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RW4xOENmUjdqS090UlVQZysxamo0aG94TE11R29xeUFBNjBBYTBmNVRXc2gz?=
 =?utf-8?B?OVhRV21XNGNocW95OEdRRnNKdHpIZ1hGeWw4ZDFhcHhGaE5PMndubUtkbTU1?=
 =?utf-8?B?dW9Yc2VMMkhwZ09kZTdDWG1xWWx4bUlxeGd5cEd0ell6Tmo2bzY0Rm9kRFlS?=
 =?utf-8?B?cUROZW1UUlJMZkQxa3NPc1pwRFZxYmwvUlhlSU16ZzNuQzFQdUUvcExvOWxv?=
 =?utf-8?B?MHNaOUhIaFF6Yjk5aXc0UEM4VFJCNEttRGJncUNnQlhOaEU3L0tMZWg3Nncy?=
 =?utf-8?B?Z0xWVWFtcVk5V0htazdjY1RpTnhHVmVwdWJPbW0yM1Nra21sRXpRK3lKWjNi?=
 =?utf-8?B?OURvcDJVb1FCalAyM0tQSnltYURvZVZTeFFlMjVrRUtmcmpjS0RCQUhQa2Y1?=
 =?utf-8?B?bks1Q2N2TWtyVDVKeElxcjFBWkxPRm1PY1ROY1F0S0N1WmJwenNLTWhIRkI3?=
 =?utf-8?B?bnA1QUxDTU15cTdVY3ZkdHprRVQ1YTlyUWwzcEs3ZllvQVB3RS9WVXA4OTV2?=
 =?utf-8?B?RTJrbmlQcUJTMjVPN1lxY3kyQmVqUXNCSms0dUZ3eTFYTFl2Z0lPUTMxS0sz?=
 =?utf-8?B?dDRiaHlsWkxkTmlyOTdvWGl4UWxNdi83QStVbDNFN21GM0Y2RDFkSTUydWpJ?=
 =?utf-8?B?STBvZTZjM2hVZW9iVDg2a3krQTM2MlFUVXMyL0Z4OVFqVXpVS1VGNlhLeVhI?=
 =?utf-8?B?UTBQN1psSmU3bU9pRW9TUGhOZjBEeSsvT2N3eWNoU3RzdEpPWXRLTks3dlBK?=
 =?utf-8?B?Nzgwb2RRZ0FMdnlvY2tLL294WHhFWXRSOEIrVUpGb3dzVytBMW1iL0ZPVHVv?=
 =?utf-8?B?Y3lqTWhlQWdNS3Y2eXlqUU9sUWRIdE1IbGxHc1BSeXVoYUpsdWtxcWQ2a1hX?=
 =?utf-8?B?N1RUeVNsV09YVTZkb3J5U1doRlNHWnBuUU9oYkNodHBya2JOaGM2THJWaTZG?=
 =?utf-8?B?VzFyQjNEUHN1eXhWVjIrUG9YVzg2a3c0YTVRVkpmVU9YVTBPWm9BNnlJZlpw?=
 =?utf-8?B?cmRzWHpwZDc2MHptUEZUb2dyR2Jic1AxVlVQZUkyemRBOVUxTHZpcmhyYkM1?=
 =?utf-8?B?WDRtMnZEbHJsRkhSd3ozOFJFaUQxM21aZXdvamFaS0s0alhKK1h2QWpmaFZ5?=
 =?utf-8?B?ZjNrZ3RQWE45eWR0cXZmV2MzTlZ2cy9Ra2Y4MTFmQWFVUmxFUmhmL25zTUht?=
 =?utf-8?B?c1RlNVU4T2I0S1pPb1lhZ2ltTk5mQ1RZSC9JUjg5OWswdml0bVhIVWRzUXNR?=
 =?utf-8?B?cjZwSXM5MjQwQjlMaUVvNzdJcUMwUEdkTnpVYm5Tb2s4QXpwbDdIQUNFYTdV?=
 =?utf-8?B?MWtuYU54L1BYcXkzQkl0ZU43M3BUaGQyM2xtWkFGa1czeFFUM2VTcXBGc2Ez?=
 =?utf-8?B?VkNuNEEwWWU2US9zVG5oSThaamhZditMMzhNRFJMSTVObi9zUnFYOWRyNWR0?=
 =?utf-8?B?MjB0akxPZFBrRHhpSEhiQ0YvczdZbHdSb1NZbWszLzdvVURwYWxJQTE0WWtr?=
 =?utf-8?B?WWRFb0RoWkZOL01va3lDNmFpbjBVNDludHlEMHZQY1p1bU1wVjlBc3lrUVd3?=
 =?utf-8?B?ZENob3NaeElGaHdFdkVDR3BzMWJlU2VGL2c4VmpKU2d1V1ZORXY3cWptcTFC?=
 =?utf-8?B?MzVOS3k1UXRQNzduV0Q1M1p0eG40MldOL1NHYU5PRmRpMU1kOStkRG5jenNR?=
 =?utf-8?B?R0J3UDJqajdkYW83RFQ2T1lmOVpCVnFxbTVEaFljQnIvWWdodjlZd0d0dEdB?=
 =?utf-8?B?TGR5RU10T3RtaWVKeUVNTGlVNU9rY2IyUkRTaUtMR0VlanZ3cWhpS20ydEZJ?=
 =?utf-8?B?OGFteU5neG9WK3VDdWh1VEFsemNRSjJMeUtzQ3hma0lWYVhUYkV4ZFBJQloz?=
 =?utf-8?B?b2Q5dDJTTXZ2Y0NxU0VXd1BPV1U3bGcvbDNrOXZ2eGF1cUhvbXBIRHJycVpR?=
 =?utf-8?B?WEFTekYzYWlTK1VQN04rcHVTZXRBanE1MlVzY2xBaEwyUlpZSk5pTElOc0lh?=
 =?utf-8?B?aFk1K0lVRXVOemxhUVRYelFCYzlBNFFpOGIrdytOTFRJSnB6NzRaOWtqcGFk?=
 =?utf-8?B?TlZkK05DZFJ6SzFzbEhMQ3pyWElOSmVMODQxVDdmbVRCSnh3YloyUmNLa2g5?=
 =?utf-8?Q?lKqcUKpoWdt72/y4itrmvAxtv?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZftCcpwF+yIdSkRiXGWNe+shVuUD3J/k9fMdoAB05p5FKcMWde2IuxfXJzW2MeyB7fQmVVjY1rJgskyH3FHSSMK90D/SzPVmJxOrdsHvSLPMzLXmS8DqrlC3GQKutGWHTOvCDqY2IRr//EAFZtdouU1ZVB+Q4XO/uYuLh2jwTaZG+muqfUnO9vB0AId5TQOGXA6JZBR7V+2+yRtm+s9ewUyeLo+dH5U99sbOduA38WabklCKAJBsojam3yyljVBx6eJ5NA75p69IdgTLJ1p4zYZ27SY4mHAyaMqP5DIPUCKgh9eRCIIw7dz229xQdqChRnuGaWypYjcGw9iFPuq6M62vWpo4b4dYpx9Y4gce8mrPMxDTxRxMRzib5gQIse7RqMBmlBP4l3OXBNXuYWOphBzwS9FX4D5O08W59+qPn/lYgWqURI22+xdB9piibUhkc85NRPo5Q6BSx2C9qksFeus39Rh9u4aqd4LIit/rD478IafiEZD1nBnFwKThiqWHrmxioNlYKo1ECizfef9zY1tYpuvVdoXHKhmXn0krBHDDoaJZSJF/FdRdbc/y6GTqNmuIHcZv+484lENYkIpEyjepARAhTraOcmG0aIpdaJE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91b0afa6-600d-4d82-4fd1-08de22aa8da9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 11:48:25.2621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ooukfq3X85/a67+rsC3wWgRu5Li2lUOaqryLCTLoHsLePUB44BvAhB9hlbgOzxTKQS9qNXPbhDiugrc2dIR4Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4728
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130088
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDEzOSBTYWx0ZWRfX6FC5QR/JS3Dq
 cDPF/8x7Ttqgg97tK/Vmr2MmpQUw+8MLzhg7ZByS9vo2RADCJqbjCljqdODdMUulPFoqCjkspod
 FB5bjkuOSpuS7wKJSxkcG/9tW6Hhf0wI1Js7GT/td9+R9hLZPIGNqMzavXWkKF8x6lxRSNlzUWj
 jp4lD8fVtkHplBLaJo2/6mnK8HPFQu/voKnYp3zC6tUAW0VGzyTiMs9s3+Ucqf/1jXIogii73Cu
 krQjHCAk6cxxV+s8uJvO0Rf0zF+j0CEpwl19XOYNH8kC1KFZWao+q2/NwxcOPK6YGi9ICgARJ6Q
 JsMg9sMqtjdjhRzb5k6IP4B/glluTK2a32NOW9eU5NUmDqUJDiopbXv/++etiWGiNHjYbJaapR0
 l2exWncJbum6aC2DHe9j9JPP8Fhf1g==
X-Proofpoint-ORIG-GUID: 3I2C9zXWaHpRw1G6ZBcOeFY4-aU_QhSy
X-Proofpoint-GUID: 3I2C9zXWaHpRw1G6ZBcOeFY4-aU_QhSy
X-Authority-Analysis: v=2.4 cv=FKYWBuos c=1 sm=1 tr=0 ts=6915c58c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=qUZ1zIllbZFYOeJy0rsA:9 a=QEXdDO2ut3YA:10

On 13/11/2025 11:22, JiangJianJun wrote:
>> Now for a fake timeout, there seems to be a problem in
>> scsi_debug_stop_cmnd() that we abort depending on the deferred type, but
>> this is not set for any fake timeout. Or - more specifically - it is not
>> reset for when the scmd is recycled. I think that we should just allow
>> the abort to be successful for that case.
> 
> 
> I think your design is rational.
> 
> 
> 
> I think the method of simulating timeout is rational because discard-command is
> 
> equivalent to the queuecommand executing but returning a success status, which
> 
> is clearly not what this interface expects. It is also within expectation that
> 
> such an unrational approach might conflict with subsequent changes.
> 
> 
> 
> So, I tend to change the discard-command to setting a very much long delay for
> 
> schedule.

I have worked on some patches to improve this situation. I will send 
them in a while. Please check them.
