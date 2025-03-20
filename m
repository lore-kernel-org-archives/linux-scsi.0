Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6581E98ED
	for <linux-scsi@vger.kernel.org>; Thu, 20 Mar 2025 15:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742485379; cv=fail; b=WArJ7pRja46KWrGrO8UngEO30MyvOkT1pEnxK5VIOC/MljB/1t/y8bEZGFvx1IW0xZWgGhqR2mLRRzgjHwuSKFjntdiquQuF6XeaVAMS8bRK/OKMaZybNr/+5Kkm7YOJRMYnAV9RmtLMTmP1hjqDBOoEeO8ASOeVhOVhsCJWgsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742485379; c=relaxed/simple;
	bh=K4wSEhBu266Pwvx/LupjLT1oRgQU8xfxMzjKrUzJyww=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ckVMDRwkn/AB1whJ2M1D5IMGLL4UzKk6jntw8y0KQVmC22loW7ftfxO5yrm3+5H2ure3IS2XiMBX1/jWOQTSFU9jwwMcnU2f5akaekjvBbf04tGl3Lc+KQe4qI/Rd7XX++MBHQEhyX0UB2vIvkjBqR3L6OQ+F2wbgRiD35aPh+A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c4VElKC0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zYt0vyx/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c4VElKC0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zYt0vyx/"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KDMh5q004806;
	Thu, 20 Mar 2025 15:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=aZSiECf863UUbUa0/7ei5PWc1ReacyCQmuPd89fHXBo=; b=
	c4VElKC0OnZIyzo3KUPFS8p/X/YfXgL5Gaw7XZHSMuqJ7TCWKoyhLcfS84dxq9Qz
	vFtLK8p3F1ncyifAt1m3kPGNOPNQP3XjAnvcgRtCOMmAiyVqx1Mm3IOJmQZCwv4q
	3C9rCcQfJWvioLkD2wssDfltlsiL2xfXFbkveSuQ2bUMTv5KZTQVwL9DUjtWLVIT
	yo1Z8jLWmEWz7LFOb17Hri/s9ePMFFhNLcDr6ZuLOdPc4o/hUo2bk8afi1jQmOse
	Fspdeqg8a0AJxVdBf9lnUIqAfYrMzpGFTLg+pD0wbnSwHvcdPYshTUvhH3mFqSDg
	IgHQ4mzoD4oqj8u/V9Efgg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1hg6kan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Mar 2025 15:37:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52KFLwew024920;
	Thu, 20 Mar 2025 15:37:17 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45dxbmke3u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Mar 2025 15:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sch7XOsnBi7SSzCjbco2UO6OlLQzzunhwL9QQ0IVBgsTDNejtF697ZPgobcasYcyztRH9Opa4dVYWa6VQMY38p7ySKFrOvjcNH1NzmKWNQNvScXl/UaQtNfjXgtBeahLme2Q+6qFNaHF88X1HNy9eSGOao1bMarHtTiTbl3Hfy9CDIZEcCh1eLpxSoCG8VnuH5cwUYTDqIvPRgMPrOipTH8i3rRjdnaxOin9jh2EAuNvcmyAN9m+BCuMknaqrK+kwCUt+4CD7ChKov9ASXvTLK5ItMmFHe9BwK4WHadTfm+LpjqGdTp1x/kBDy/yPlnOWVD6UiqWOte7Hmw1cDW+sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aZSiECf863UUbUa0/7ei5PWc1ReacyCQmuPd89fHXBo=;
 b=tfMDeAOZHHoWi+H07TP4J9EVJPT4bCF0f1DUfSVm+5tpzguTC/16HYXB5kexiD2scz4frBehKTdC6NJGPd88KG/vHNtyNIiUGPXYGrFdECgHi3ojA5OtBm1L5ZY5+9i20PFLskxik+QyGe4/BdMegKRlMjIBenwQ42fAZ1ZQgPRJkIxdvh5fTE2GZhZVNZ72EoPh3NPlKjpLYYM62d1Nz+zoKtdzbjj8KMW+KGYmMy+6TkWsndM5bKrrd2OrMftbP+VBFtIRBHQ8DgTBjshzdp3esZBl67+TKdrEGZ69G1NWHwa1jwyVT4ppeb8+yMj9ksV7SYy+3CJL5sldia4e1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aZSiECf863UUbUa0/7ei5PWc1ReacyCQmuPd89fHXBo=;
 b=zYt0vyx/ge191Yig3P6EIvoim7KA7QFwZ4LtOH8RQftVorg37QuHd6oKZyg5ahjd/hJmKfuq6yDpbFKCtrxl5a6kQQ4/3VrIphlXd4uRLhYOQQsbdQCTxKKCgAKVeqfAEJ7qq1uiD4vAjQwlKhaUrH88NFC1b00tKiUvrXK3Yek=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by LV3PR10MB8010.namprd10.prod.outlook.com (2603:10b6:408:282::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 15:37:14 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8534.031; Thu, 20 Mar 2025
 15:37:14 +0000
Message-ID: <d7c30f0a-0a68-4f36-8d89-d0d082cb2473@oracle.com>
Date: Thu, 20 Mar 2025 15:37:11 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/2] scsi: hisi_sas: Fix IO errors caused by hardware
 port ID changes
To: Xingui Yang <yangxingui@huawei.com>, yanaijie@huawei.com
Cc: jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@huawei.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com, liyangyang20@huawei.com,
        f.fangjian@huawei.com, xiabing14@h-partners.com,
        zhonghaoquan@hisilicon.com
References: <20250312095135.3048379-1-yangxingui@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250312095135.3048379-1-yangxingui@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0029.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|LV3PR10MB8010:EE_
X-MS-Office365-Filtering-Correlation-Id: 36a209e2-76aa-4673-4599-08dd67c516d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnB4cmdqNm1ycVhvTWxsMEtvNUhBOUxINXdDbXVzUlBmcEFuL21XL2xuWWs5?=
 =?utf-8?B?aUpnaHdRSEVZZ2hDWUNvdk42Z2NhNGJoZ1JQUlgxRWxoQVo2cGxHS0hBR1pB?=
 =?utf-8?B?SjE2YWxSWk5wRUtkdUhpQlRsQ3BXNytxUjVRRVUvbnYyVUxxWE1JMi9WdkRl?=
 =?utf-8?B?aGVlanRLc1QrWDdPNzEycGppUUFaU1ZoSlVPK0FsNnlUeW5hVzJoekFQczRD?=
 =?utf-8?B?ZkxyYnFTcWxDNk1hUEowUTFMRTRRTmp5R0VlYkxkMXNteis0OG04REhCMDNs?=
 =?utf-8?B?NVdhMldrYmhTZ2NkNWVIU2laNGMrYjNXTWw1bmhrVjNsai9NbkViMG5taTM3?=
 =?utf-8?B?RXFNY2l5K2JPbmh3alcycEJGZkFjZE13QTRvSmF6NEM1MVk1TDAyUEZYbzY3?=
 =?utf-8?B?M0hEdGlwb2gwUVBzdXU1Q3N3M21kSFhTT3VSKzVkRS94Z2pFbi9McHl5R3VH?=
 =?utf-8?B?dVM2Znhkbnl3ZEd2NmhkYlk0bDMrczFJSzloRElYWHo3NE9tb0FxeVFwZGdS?=
 =?utf-8?B?Y1RiZFo5UWwwSWV4cDFVL1k5SnRDMllNU3M5RUlxTUF2K0lxdEV2Q0hmM3Np?=
 =?utf-8?B?U3JDNTRGRWphRm5LYVpsbUIvMWhtUjhKUC9wa3VlMWtKejRPdWVlZk5hN2VD?=
 =?utf-8?B?dVMrdmFJN1dvak5IQVRuVlE5dDQvUFp3MW1FaEhWdTJOQWgrdjk0bzBzQW1L?=
 =?utf-8?B?VFFEUXE3Z3F4K3hTeGNicytGLy9DLzJTNHpDRWEyMDVUZng4MEFlbWllbnFN?=
 =?utf-8?B?T01qUHR1RkFhd2dwa21hTXE4RjFaZkJkS243SklVZ3BidkpZYVZOa0Y3VlN5?=
 =?utf-8?B?WXc4ckw4bldHazhDOC9abU5UOGJiVEMyU3YxVWNkWlVyZHR6Vk1qaDlVODVZ?=
 =?utf-8?B?eDV4Si9NTWNTb2RSRElORXRHbUZKQ3RFL0dVbVlYdGtGOEp6WTJkSjdUWERY?=
 =?utf-8?B?Zmg1azFDc1g0ZURsNDJsRUgvSTVUdnVlU1gxQjFQODlkbnlqOUpkSzljSzho?=
 =?utf-8?B?Q2xrdGxHOHJvc3lwaW9halZDSk5SOUVBZjRTNXo4Mm5yUXcvWmVpNDg3NnJC?=
 =?utf-8?B?QU1pZWkxem5qcFRsUk9tYUhJcERGek9tb2s0akZ0anprbmVGT0tMZ2xVQk9u?=
 =?utf-8?B?KytHUDNSYTR5SXBPblM2VUxWbXpRTWVjWU1IcmR2bER4b3lHN2M1VTIzNU14?=
 =?utf-8?B?bXRhWmM0K1J4N2RLTzlMUVFldmZqdzd0c3pQSWlTQTljYnI1WDQwRHdXeU8x?=
 =?utf-8?B?M3IyRnFaNEY1Y3BoVGUvcGMvNDdNalFnaFFmNVhzb3ROMXM0NU8vVitRVnlH?=
 =?utf-8?B?VWZQR0Y4RE00aWxyOGNVQVcvUFh0ZGpXOGNQd3JRRC9qNjQ2RHRqUkpLQ0hi?=
 =?utf-8?B?KzVCenUycnhwOS9OUHovRFl5dmg2YzRpeXAzNkVVekJrb1VEYlBMZGY5Z1Nn?=
 =?utf-8?B?SkJZL1RFRFNFYk15eFRGb1FSM1drak00c1ljTjVVWCsvdUFadHZKWmorVjRM?=
 =?utf-8?B?dkdKc1NPSFBLaFRPT1dJOFo4aEZlc3p2dnBMdUZ2UEM0NnJISDZFeXphV0Zz?=
 =?utf-8?B?cGx2SWloZGRnVGh1WE5iTHg4bGpaaVRqOGRpMUQwY2JSWDY4R3hTenBHVi9J?=
 =?utf-8?B?WnlDb1BrbktaL3gwNDh5M240Q1E5VllNTnl4VFhPQUhwd2dmTXQwUXFVSHJV?=
 =?utf-8?B?NXFSZlBuVjNrbFNTWGFGV0o0My9BS1J1RWNWcHBnazZlVDN5UzI1WU9GVkRW?=
 =?utf-8?B?QWdkd2hwS1dPb29DMmkwY3NvRmFaWWdKWXlyUVZTc3dURmR0S3VEemc4Um52?=
 =?utf-8?B?aVdGeC9TK3hJczFRR3VkekVja0ttR3FJRFIxbGNMRHhtWjNpcS9wbDFUcmpW?=
 =?utf-8?Q?3LpK3n1MhARqY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UyttT0lHMHRBcWZuSmNCeG9lMW9ESEZiZWtuNEVGM1FRbUVXQ0l5Z0F2VHFL?=
 =?utf-8?B?cFJxRlhXYytGTW5lWUNKRW9Nd2FlVDNFS3BRM1RMdW5QbGdsSkUxL1JVeVMw?=
 =?utf-8?B?RTd0dWpGQ0psb0U5aENHNW9HdFdKZjBMMnlBWmp4RGZ6Sk5uUlRXZGxFQjYv?=
 =?utf-8?B?MFF2ZE15ZEpIMEQ3RkQ4WDVHZDA4cWR2cmR3TThsTjZaOUZ2V1JTOCtsS2lm?=
 =?utf-8?B?RTFzTVY2L3pnZVJSQndyVmdxSkFwV3l1eGRmMFp3UmVJY3BUMHJkanBqb3Fv?=
 =?utf-8?B?YWdNWXI0R3Q5NmVRaTBXMmVOUmU0RUoxOTBRWE1yRyt5R0k2VGZ3QnU4azRm?=
 =?utf-8?B?QW1qN3htenVyeWE0S3dVaGlaU05PQWxSbE9KYXpwL0tmTWNPMGNHZFZKWHQ4?=
 =?utf-8?B?RUVFYXBoMDkvMkY2c09rTE51TncyQVBwQm1tZFcwbFowQmw3dGdmRUdsNGY3?=
 =?utf-8?B?WWlpUzZrZDJhbTAxeEZqU2RhVU96d0kzbVp3dERlSDZnWTVPL29OdE1UdTRh?=
 =?utf-8?B?bWQ5aWVWY0Y0V0M4SElScnlNa1BVYzJ5T1BVQTd5UEd2dmY4MjQ4SS9qRWZE?=
 =?utf-8?B?Z0MxdzRCaVozejVOSFhGY1p2NmZxRkRHZHdaUkp4djdRc1YxbVlZTHQrUkZo?=
 =?utf-8?B?dWduUm5RcjFOeHNHZzlrL1cwd2pqYjFDOEw0ZkdRWUlTOEdrdTA2VnhiYldh?=
 =?utf-8?B?c1R1V3gwU1RQbURMWW9uUDYvVzhvYUEzZ2piOGZIK3BTaHFveUxwblduTFZq?=
 =?utf-8?B?Zkh5VVYzdFp2TFNZRDkrTkZTbGNxRmVvb2VPaHVXTUdqbUJhZVN5b1luM0N1?=
 =?utf-8?B?V2ZLSlFTN0RkM2x4M08vQUlyRG9ya0VDbzlWNElTNnpnQ2dQWXU4NUxRREFq?=
 =?utf-8?B?dGR5dk1mMTZHZ1UrVjdRdEIzcXZCQkdFRmwreWhkUGFwR1JLcEZyOW9Da0Jj?=
 =?utf-8?B?Z0xUcTJtRTFzWGRoV0NuaHF3bHRYR0tZZk9qSnFDaTcyZDkvOTIwa2pEWmtC?=
 =?utf-8?B?eXcrREVpT20xUmdkS0ZyMjdRY0N3QVROYVc1NzkzWHhkSjd0UEpiOFFzRE1B?=
 =?utf-8?B?bDRXTmU4MXRVQ3IySENaSWdZTysvU09CVXovWm1RN3Bka1NwN3hnSzBZYmtj?=
 =?utf-8?B?SXloVnYzWWlCcEhkR0JwS2tVQmdBb2c0cFpsN3Y0YXlFckNRZml2VVRvaExR?=
 =?utf-8?B?NHVGcGxOV2M0RDBseHZZbHFWQkdTZlFqWHFSNmJMZjNZZWljcEd2aDdLTUhF?=
 =?utf-8?B?TS9GWVVYNFZMa2UyQVJheCtwQXFmTGN1NUhhdTZGTXdRb2Q4K2w4UmM1dkEz?=
 =?utf-8?B?OFZ0Nml5TFFhelB2a2ZYdXVFMURyWTFnSkRsL1diV3ZFcDlyNFovQUFqb2RL?=
 =?utf-8?B?Tm51ZVVreERveTVPNWJ6TURaQzdneTU3WmJXaUIyTCsvRTBmRExUc0g5K1JY?=
 =?utf-8?B?ZUYzS1c1QUtFWHkrOTdIWk1BL0Y0N0pidjBFdTFoUjlrNTNwVDNMS1h3eXc5?=
 =?utf-8?B?MUVPK0tONFZmaWlSbUh2QkpuR0pHUW9oYXI0SmZwSElka1NaN1pvZjNyUWIx?=
 =?utf-8?B?WHlYMjFsUkV1eUVPVnF4TjFsd1VLMXNIVVFrUng2NTh6a0IvZjZwTXRsUktB?=
 =?utf-8?B?Z0ZTei9hcTJHaGl0UDFTRnlQVkNtaTE2VWtlRUxZL1FmaCtLSzlMa28zV1h0?=
 =?utf-8?B?TFcrdFc3YVF6VU9vNmZZVTErNUg1ZUNXTDVPa2FEY2s4eUVyTDlPMlBqL0w3?=
 =?utf-8?B?K0VyMWZnZVY5M1MyN2x0UC9hcXBwWkJKZVZUZDFXY2VIaWNIa2s1Vld2YS8r?=
 =?utf-8?B?MHhFMTJ4dittWE9YdUJzZktVczVIdFYvWW1NeVF1NFJ6UFFEMWNjZCt1c05K?=
 =?utf-8?B?STRMSkVjSXhzUHYxaG5jLzl3eW9JSlJuYjZxZkxaTzgvbVFxZE9OWk1hZm1Y?=
 =?utf-8?B?eHJtc1l4RjFyaFdnVGlmS0NBZlJMNGViSHhRakE3TU9yNitmVWYxdzcybGlx?=
 =?utf-8?B?VGRZenlDMVozSUxacXBCRkZRYSs2ckpGY2VsUVc3VDBFaDVYZ1RqZFk1LzBp?=
 =?utf-8?B?bE1nTXdQQWJ2RmNjY2lIYTJIR0YvTlZ4Qlk3Vk1ZZ1RyVVFLL1dCQUR6Q0t5?=
 =?utf-8?B?aERqQUhweVdzcThSZmVOSm9hY1dWd0NRRSsxK09ZOUhGZ3dHR29qUTFHNThU?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zp5gea2B60k0DB33HoPNfKH97RIP2ceJkFcOL+yP0SHQL1nVEUAl4yjynBZjhWCe/bTAX4u1PbDN6KO58ZVbv5kwzfOduPgrXPbvniH7Ak6iqUEoZWKmKS3Cn5hYGNMIi1Y7ORH7tybvbq9UnLMzPLlCAzrORW+93HQeJXRSg2xLbaseEnen+5awgCkRZkW+VU7g78EF6cEM4gj5m4fMzCuOhU2YjErt+thEHdiPuD6SLHXx9ayPaJnsNCw7wdiWZ0X+8soCEL5mUS3U8vyrHN/wDNa24YK/Zb4vBxXYusTII9ZQqks6d0wkx/SQwk8IpH3DEWOisjBoQzyBygLMGCY3MR6CKvb02JSD7Acis1ZvrDO8Wsit9JQPagc0nEjlAZHEHb1SBZoR39L7wjwWv2NG+qybeVIKZDzG6ULFX8OXQsP38jyatS14kMuTuZoYDfFMsZq+0cFZbcvoDXRgfEwI1wMwI+58gpU6moVVVM2zRHgPnpUNeBiqxTwN75xDDE01G3q+7DPggGYEfaIfPKX2p1q+mO5T8Edwx1TWfBN3bkYefplDDGPX+m3jSPNgL8+8kL6MBYiixlyIaow+mi3rdAQ7izEfz4i/TB1DiDg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a209e2-76aa-4673-4599-08dd67c516d3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 15:37:14.8472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h10T1wbkXn3mvJxHGBZMpriG/yUbAIp+NaoXru1tM/d7xcv8dkujNfZddNZLRBw5JL6yakC+5+CjFiScXnHEaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8010
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_04,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503200097
X-Proofpoint-GUID: epdSf1CAnM1KuHxwk-M0U9qAVXHUsxBa
X-Proofpoint-ORIG-GUID: epdSf1CAnM1KuHxwk-M0U9qAVXHUsxBa

On 12/03/2025 09:51, Xingui Yang wrote:
> This series of patches is used to solve the problem that IO may be sent to
> the incorrect disk after the HW port ID of the directly connected device
> is changed.
> 
> Changes from v3:
> - Lose and find the disk when hw port id changes based on John's suggestion
> 
> Changes from v2:
> - Use asynchronous scheduling
> 
> Changes from v1:
> - Fix "BUG: Atomic scheduling in clear_itct_v3_hw()"
> 
> Xingui Yang (2):
>    scsi: hisi_sas: Enable force phy when SATA disk directly connected
>    scsi: hisi_sas: Fix IO errors caused by hardware port ID changes

So this is all solved in the LLDD, then this is good

thanks

> 
>   drivers/scsi/hisi_sas/hisi_sas_main.c  | 20 ++++++++++++++++++++
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  9 +++++++--
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 14 ++++++++++++--
>   3 files changed, 39 insertions(+), 4 deletions(-)
> 

