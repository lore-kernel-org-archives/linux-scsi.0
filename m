Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6A33D6CB7
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 09:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774343501; cv=fail; b=GVI3ZIjTBTIMAlhZeN9Bi68Okk1gj1QkEdmbga3APOSxkto59n6v1WwgO5Pgve8HB34kOnDzwe/Rr7a3t7+AOT3PpS62OcF7p1ToPxfEJH1U2bJhUuUnarM83RfAzBFBeRsdfuoTSlGX3C8+a2MHtYzmtyFJHXFvDM0QC5QwsLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774343501; c=relaxed/simple;
	bh=cjFmJGbWAKVuoOuIdOLi1ZcFV0DCXeomuA0qJb4oJ7c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ct47ZvAFJY/XMVMcSdPdQnozEFw2yx6ng+NhYbbVraK1erZWHfXvBjMZ8xZfkZLLrl2qYnCEfgK9xjhsu1yYCa4Id/o27K/39TmsehZpX5D9h//z4dXiTCkQO4y08/jiqZtPsWhUcarSLoCGk+D+z5VwAp0JVRnsxW9D+/ubNYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VnUJjpnD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=db/3sNjt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VnUJjpnD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="db/3sNjt"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62O2oBUn2957645;
	Tue, 24 Mar 2026 09:11:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SV6/ur3VPNVd45IcuRJGh8QmEDRuQF6eiMT2+EkKeM8=; b=
	VnUJjpnDeqmuIu28XE9jiX8R4N+BZNA6b3f4aayf+brtDPyxO2u+SbKIb/fTNsfZ
	LWjIs48RssKO5SngJB7uB0XoNKBvXBPpxo7kwqToOQhIWRq3fZE6CkO/ZlcZxxoM
	VvL8ALpQA9TG9yUHrxFSxaWbuqshKJ7781d2GTPvqk/LkLeoPKT5Q+3xfezURu4e
	HnJDqAWI8FUYmlTlRWQLZcfhqCpx9Fv4lXOVNYacUgRgaRpZBKepPlDT+hSxr48M
	rzWIn9Pw+adsYfW9YZHcPaHbI5c1RJbuRdsEtKoPHRpwxctWHV1eZi8YRSTb1RzI
	iZIBbn4rL6xJIWMSXq9C+A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d1kvnksph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 09:11:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62O8i8FT012397;
	Tue, 24 Mar 2026 09:11:29 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010028.outbound.protection.outlook.com [52.101.56.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4d1hsfpsxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Mar 2026 09:11:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Djk0IRBXNmoqRVjoVy/+wlN35CsO+ZrmQOfx28GTy49bNg9/DGAt4EvX5ZmiMlmsYpzj8eh7iTJZeLlX/fmEMIWAJiqKOWcPyDm4kVsV4ukM8moe5QJgqmMxBmeaC4S/Dbywgu+6cRg1ajkTXsWtN+VVMhHC4IHGWxFxd8ZBXGlHQDRe0Xo8ag9dRR7ykfWOPpY9LZTVuvA+4zX17xvb94YIuJh+wBAxMYfzdUhmdDghQBBd4pa4fJ1ibOa3QuJIQVSg7/enOLotzBhFcr3g4siQAqAfmBFQj4MVe8SskXhWAfLOa8Rv7DyCYYn1dilsia4GLXYQxBldnLRB8xdG/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SV6/ur3VPNVd45IcuRJGh8QmEDRuQF6eiMT2+EkKeM8=;
 b=tZA12S3Pzl1UdLMcXs3oXmJHSDfUOcO0AgiBU4EfEVpG2jBbsGuWAGCn6ykUAO4pMsnBETNNJP0PjZTCvi4zYqA/XszGj5dUTj2XQa9jWML+JnqRZp0fCj5iCbpQSuKGISvxFahcGfw+jMZFBhUMeQiJ4rbk8Oho4K+sNzfAac1arabGZb5Gg83z4f2uoB0DSYdjZNxjnEUIVLa/x/vozKPytsl47aQOTWDBp7uFOtouKS04ERP+1CB6Th6S0WslT4HHmYqhcr8ZlTUh3308dyw8sigWXLUzpoyErpuqdsoErKpTDA4hR1d2DQqMqwUyx7XvYvubPwAUmaVCNdHE0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SV6/ur3VPNVd45IcuRJGh8QmEDRuQF6eiMT2+EkKeM8=;
 b=db/3sNjtK4/ZajB7DCkibOgDFp3thEWFeNGrX+wjhSUpmh3R2JJc4xGoCr5Swy68AUojeYXJtr8HFhOUS3J3qV9M4eiHjJtka6yv8gEjZaLvukWCL3fUizGbKSKpK9OS3kevEs21ezWYmhnqG+h+RU0CMLGlv8+Zm/76hTIVK0M=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY8PR10MB6684.namprd10.prod.outlook.com
 (2603:10b6:930:93::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Tue, 24 Mar
 2026 09:11:25 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9723.030; Tue, 24 Mar 2026
 09:11:25 +0000
Message-ID: <1d4c332e-6151-47a2-8f9c-160f03416e64@oracle.com>
Date: Tue, 24 Mar 2026 09:11:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: Support configuring the maximum segment size
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260323203117.1248925-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260323203117.1248925-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0058.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:310::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY8PR10MB6684:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e532e1f-68c3-4154-3cff-08de89855318
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	Sb5oVypRoy6psEazE9k26VnwF/secFY4lr105VOkUyyhd+8oxZ/8bmBASgozqVbcHiOiOfPZhonooZB3062+1T/n22OEz/UDgLg8vjtEf97tYBzquQJxNA3YL6rm2BMNV93s9l3kHbx5XYpa5TxEAhY+WxYkXpOGKV0blzHWjBPQ/Y4E/dv/xPsUu0FZVzPEianlN4zzuHOc49PXFk+8Dl7qxtUiIkqe3vxHmF9GUo9UxEXVENaU9x6S6RPcb25SQmdOOv3afPqRXkh3SqIbX/P/EGnya/LJTjP1RfVfDnFlT8u/tQp+FLFLkH02ZacKFGm1vVjwmCvy//DAu0pOEBBvRyBtv978WwUYw8v+kIrEBez41J1kFhZ/BwzIwmwT1F21QS8p22RDLVMKC0Kefnv6jRjGjSB1mG8GOiQr4jB55DGlFN2b2VRxM9Ymrxa5DzjjeDWTb2aEW9mHENRDA5VZkBhbCLvwbx89jjzCwGF9mH1z9dbR3QYW0i967Ws8M1kJzZzV7PcH1ONQZtptPomXidK1YsjGBs15cqC+JI2U9blJU83LxEzDs6oO6YPChgAwTj1thk6+JD8mCwcIdDgHSVMPf9XBMLUEGA8kDNhXBriqi6nGZ/ddCUtED/emo4Of/VTuKAF5xNA1MxFs8wubw9eHbv2vzzmrpfefOThFsxgRE6pK+TjYJtPzToPbVl/jBucLhntzqaI0ntJ20ATC2CA29nJNP0cZCr8KDI/KYpCZ48h8IPrDvgG4Zwp5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MGs5RUpHd2V6WXR2U3N3cm1VS3VZWFVtaHkwdkhOMGp4ZFlHZnh1b1JVSFl6?=
 =?utf-8?B?NlAwMWZyNTFyRVpydDVWRnFlT1ZMYTV3VmlnWUxXcGluZkM2M3Y3cDRCZVB5?=
 =?utf-8?B?bVd0ZENXc1phSXlYbkFTYVM0aDlHVVc0WSt3YStWcjFVUUVQKzJDQTdTNGht?=
 =?utf-8?B?eUFFakFlUStHQzFkK21NL0FHR2oybWhoci9RS014TVB1MXdTUHVrdkh1dG9x?=
 =?utf-8?B?dlhQZEpncUs5TktNYW1OVEcxOFZhM1RDTXkybUhmaFIvUCt3eEVhK25NREJJ?=
 =?utf-8?B?d2ZDclRCWGk3eDdwUEpVdWZPRmN2bjJoVTFReUdoclRYN1BQS3VYb2NHSzRU?=
 =?utf-8?B?bksxQXpoVDg1cVF4Mm1CK1NTSjhQSE5YRWxlaEU4aVdWbU1FeDIvcVI4L1pH?=
 =?utf-8?B?WnNSWTVibzVPV29IWlI4TlFncWpuYWVDYTQyaklGTTRwSEtRclBrVGFCdWs0?=
 =?utf-8?B?RlIxZ2dENHR6NHFxK0RieXNVbHk1ZEVkRDVIT21jczlpdU53cTk2NFhqWk51?=
 =?utf-8?B?aFRmcC9BbXptOHhkcEpHUmtQT0RXVW4xclNocm5NSlB6SEtLbXNmUm5EaXVM?=
 =?utf-8?B?TXlFSHRxR3NWd09VMzdON3BFRUd2SlZhTTF1by9ZSUFocUREY3FoK1dzN0k5?=
 =?utf-8?B?RERLeDEyUXJJUkpSS0JZMHJXR3JWNCtySkx0SDk2Tk5zNXFDMXZnSy9mR1Bq?=
 =?utf-8?B?dk1CbHJaRUZwTDRGNU15Q3FJSHM2bDNDTmtiOEdJc1ZCOWFuejRteVR4MVJ5?=
 =?utf-8?B?SUNQTzRLa3lwNWdjK3YrNUxYSFQ5UkNqUUxNaXhxcWl4R0gwVUs5aXJCOHlY?=
 =?utf-8?B?bWxpUFVXS0p2U2JIdDdCbVVrT25kczNoRTMrdU9nM2NGaTVncm1YbHdZanNW?=
 =?utf-8?B?MHNSeDIyTktOSFgrdVZMWUpTenpJcktLT1I1c1U2Qjd3R3UyQWxzb2xvN3J5?=
 =?utf-8?B?cVh4NmY1eWwrclhoVkVFS2MvNGgyQjBZS1c5YmpoWVp4SHV6dWhkOEtZUVlX?=
 =?utf-8?B?dWRJZlYrYVFTY1puaXNXT2RVN3p2WWRvNEVCYmt5SVRJazZzUDA3akJmR0xj?=
 =?utf-8?B?YTdBdUxHdGRSb053dmhubFdwQ0sxNC80Z1U4NHBJMnlHTWxldVJPOEN5a3c1?=
 =?utf-8?B?dlhjSGJlalA3aDlkYjVJd1d6aGNTWmE3YXIrZ3FrYjI0RTdoMFZ0RENPLzU0?=
 =?utf-8?B?UFMvNHc5OFBrYnhZU3pSMU5YM1RDblc2dm1qOEp0UzVmUWxkZGpyTFNxU3pr?=
 =?utf-8?B?QUh0eGd1Q3AxeU5UbFNjdTlHMThZb1ZiUXpCS0dudk11NlZERXpUOW9mZVlM?=
 =?utf-8?B?RzV4Tk5DTnFTNitBNEdEKzVMalc4RGVoM1BXM094R1paYUtsMGk2TGdUVjZP?=
 =?utf-8?B?bFVVeDdZeXlSZnRSOTN0WEVHZzVIczVjOTBiN0gwSk1YL01rZ2hiNisrYjFm?=
 =?utf-8?B?aUlMYkZuU3dOUE9BVEZVdFRUWnlZbm45ay9oZWt0VUcrbDBrL3ZqTkRMOHVa?=
 =?utf-8?B?Z3hXM3R5M0YySzlBaUZPcTN2N0xFQUlHUGwxcEZSNXdmVGhZUTRSb3lzZTh6?=
 =?utf-8?B?cUhVT1RzUlBPQ0N4Y2RhVWxjREhoK3hrM2lzYXBCNERNYXJ6UVl5M2huNDcv?=
 =?utf-8?B?SzNNQnhER0pVT2VranlzUC9VbU81ZVBOWG05QjAzTm9RVXYxcU1xRnMxaHFq?=
 =?utf-8?B?V0pOb0t2eThleE1SZ0dpUFdpd0d0UlQwemUzTHJkK1pDNFdNaFIydU5icXhv?=
 =?utf-8?B?bklDOTVSQWhMTE85TFlKZmJEc1lFYmdNQnZ0TmJwZUFwa2lkSDdGeXNpNUEz?=
 =?utf-8?B?aWhFM0IrOHVUd0E2dGF2Q3NYM2hpVUN2NUNKdVExZjMrQTJsWlE2c1VqcFNS?=
 =?utf-8?B?M2gzMllGTnVuSlhHWHFtTEtlbk8wMC9La2l4VzJXRHdDZUVMaXJEQVBNRFFa?=
 =?utf-8?B?dUFaMUcxRVB5bWZyTWsreEFOS3Rxa2tJQUhCWllvclRGQW9ZTG94azZ0OUha?=
 =?utf-8?B?ZUo3RExxTkVUZGxXMlBMa3M2V1VmeGJ3RHUwNWNkWHJlQW54TGd1MHh1cE12?=
 =?utf-8?B?a2Y5Z3NCZTFGVjJ5dUNNaVBvZEJoNDdtdktUZ2ZzbExKbEtXUjBzYSsvdXNI?=
 =?utf-8?B?cTkyYmtpT2hiM2lTNFdTZzZNOTVkYnNLVHRrV1Z1WkEzYzRkNzdnRnhpUHFX?=
 =?utf-8?B?T2NNVzg3cVltOVBNR1B2Q1RVTWdBT0p0SEJvSEJyT3NvUEp6ZmJYUGE4Wmsy?=
 =?utf-8?B?aGFWY3FlK2NVaUNER0NTRVRJRWlEZVZSMHdIQnZYcGRxS0JMRjdNZ2krOE9X?=
 =?utf-8?B?ZjE0cmVHOVd1Vm9Jd09haWN0Sk5scGcvSGZQenNIVENXb0FQcXk4dz09?=
X-Exchange-RoutingPolicyChecked:
	eFZhnP7S9eoykis3WOHKJDqFqaY/ytzs3Db3PQrkgYaRh1sU6mNJkUyLU08TmyrHjek8bAVwq9zykXnfggqM9jH42jxa6Xy+lbqN9osRYvseEDi4QpgjzhVBGMuqGMvEmFq/+T4vkgT7EO6qAsrFCuhQWPjDBAowtSuhTCyILClmSBFlfAHOBGg6FL9rTpmTBSPmMdQ9G1wnq9pYT9CJmTtLrQdPzZHIEnFiZRkJElz5QNLiHyuZno5OOlzLN5bDW+iXT1SEmTYRbMu6HBgYPP3PpbeQ52Q6u4pqeuZTtQJCwbRF9sOvv1VApBDc9soyngG6mZKabY9TRm4kNZSfEA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Nam5DqBBeGVq8SWNJbskfihKzvLKxmXPitVxe+DwKn8vyNFOOH3ExWKdULTZgnu5KwpYMViGbkAWPfJwbz0nfllkbXD2idZ8LesHEizAgv1ITHk3cL5TSmE0ritqa2YRxOgwybI5eVNWIFUOOB29QQ7Dw4V5kbprsPR6+7ckvv+oQ45IoS+gZUsoyiI+xlMKbDLjc7cxGpE7/hPKHbAtq2GgiBSO330DZQyCZUs99dYk3n1eKCuvqGxiNn6uP307V6J8Ehw3bBc/3gi6avo9DTzskJyBi/om/7dO+LHu9QI3grDYm1SStMw2DX40WsMY+idbE75EZlMpL2TZ14s4CM3aTBGf3nBrsYQJvPNUeDZhhVfGlXFwGc8dqalmwHYOLWfT/6OEmS+j/Ty8jZlLw34rCC+x9+B8WZDkxRWmir8V6fqMe26aIWR52ta5cVuGX+VK4HDifRFKNxXAPUicN37dPNDBy4zVGRd6k6bSX/tf5WiqLNxPIf7yc5TIL19C/SC99BjQ7PeFlcKei9mEueyGBswedn4R8i7yy4CDTmQ+xeF1RNLQv49frcNA1afTwItiXyCHLB+9Htqsz3+LFIYT2y2Vh2/hXxVZ17E8O8E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e532e1f-68c3-4154-3cff-08de89855318
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 09:11:25.3223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kXDRYyHYPDND6tfSwHqb1R0jpo4dcJ9Mg5gzLhpJPNxFclZN+UVzyymOCPUvhxKhoodaNvKm17G+Z/P1lOk5Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6684
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-24_02,2026-03-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603240072
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI0MDA3MyBTYWx0ZWRfX7AA1LX9F1WIC
 kKLr/aThCaUlzJIiP35/BNfl6EwWDi1FiQEItoFvrmpEzGbAqqxj/pRpJnNusAunzME1xQh8NMo
 rGTkFGXvht/38oYRoHRW+UIsHl6rQsq6Te6pjMXnqetT8Q3FBr5Z3rz4T5SSvwxXgQtK0GWQnCp
 G5rnmyXEBiPayipzX47C3jWtb8+0wQTWuqqo6WReHcqSbcw33dE2rBsRA21ObfwNgMhyS4sK4PH
 /CNUV1IyWEuxU38rfWMiTOuDDtp68iwFRY2I0qZF4nlMhQUe+Gg5TDU0M9tcZe2cmAOY1k3ozd/
 PI+ezfDv7NMWCFCu4QlksRQ7R7om5p3hlN66VKNVMQvrLeDLVsPV8ZgXMI5XdS4vIaiNXNxkwsh
 To/UXCZsZMAONR2jaKZagkua1DEuUe08FCW/TFDRzLNqubV1ZyuVQzcDgCBPuAQtRq7ur0u2OdX
 iCRPDH6rcU4l7sxB6RKuSnMz8dS3xmw9uaUMhxQ8=
X-Proofpoint-GUID: kBWJqi7y70iaRnB2gdRR2xjqQh4966e3
X-Authority-Analysis: v=2.4 cv=GrtPO01C c=1 sm=1 tr=0 ts=69c25542 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=N54-gffFAAAA:8 a=yPCof4ZbAAAA:8 a=NCkSHYsgAAAA:8 a=fHJ0T9YE3hZ99LMLLJQA:9
 a=QEXdDO2ut3YA:10 a=AnMw66Xr5OuzjdxB04dI:22 cc=ntf awl=host:12272
X-Proofpoint-ORIG-GUID: kBWJqi7y70iaRnB2gdRR2xjqQh4966e3

On 23/03/2026 20:31, Bart Van Assche wrote:
> Add a kernel module parameter for configuring the maximum segment size.
> This patch enables testing SCSI support for segments smaller than the
> page size. A test that uses this functionality is available here:
> https://lore.kernel.org/linux-block/20260323200751.1238583-1- 
> bvanassche@acm.org/
> 
> Cc: John Garry<john.g.garry@oracle.com>
> Cc: Doug Gilbert<dgilbert@interlog.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Did you consider sanitizing this value? Maybe we should ensure that it 
is a power-of-2 or UINT_MAX or BLK_MAX_SEGMENT_SIZE

BTW, I don't think that we still need to set a value in 
sdebug_driver_template.max_segment_size now.
