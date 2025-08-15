Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C802A29ACC4
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 07:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755241959; cv=fail; b=inPghkCzWRX+L4IY4EN8azoB0gYhXjjkic3CoCeKrk34kaB21rKDONVLgyVEvyZ/yAw2e4Gr+Z3rnbQIXsR8X+54RKGik5Rc/7rmpMBjoP1ssCsESDDXHCbVuDyb2kaPDOy0vshIhgebgoKumFOx+czNCL7UNbqEMpkxvYXtqBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755241959; c=relaxed/simple;
	bh=ODqTxxRp/b15l0/8l5x7T1b40zytaJAGkB88vEaz588=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ud70wIuI8QrNZQxjidu21HYQ8LqNVXQs6zPo/Gge3VgY4jKcZSWXBT9Sm581CozYIqKQsDsTfMGisAfS4/EWnuH7RW3r1iYWHWOxQ4UMf4YiDu0JMuZ+Gsku2DPqITIm5JFVv/Knrd/A1iG4dkkhXp7b/50GUPPWs4hO7tQO/EA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N/CQhNlJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iJrktXHm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N/CQhNlJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iJrktXHm"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57F76SL7023009;
	Fri, 15 Aug 2025 07:07:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FUIomfU539Al2NHcGf+1JivYAtqzb/CkJ2asiMmiwHQ=; b=
	N/CQhNlJsUpbZol58EJYfRnWRDDOwNwahC7dRZUj1RxjRf8TSrwSfkGxnewfyn2h
	ddsdOmB74WdsMEq8wNhVNCEzb4WY4bsrGlP+KOtzafBKtKnqLIiOxMJyOU2gf4a7
	D8m28dpTDcPqL/HHGt9HjgPFYE00r1UVuSaro0x4+Y4qYzxRZBXumuTMHdgUUxTt
	TSoYDqc4GBw+FS0CX/sd0ByhEnmTFLP4Hnkh8hFP95A/b5eHzdZvLrRDsBgeSg7X
	9rcHi7qURqOrEDGdEMVXF5GvWgZ5FF5jN5/9rcWNF74hiKMvlT2jzGHRYs5Ilpgz
	R9EHZu5nCI3zcKELCnxaSA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48h7rmtnp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 07:07:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F6xT2D030087;
	Fri, 15 Aug 2025 07:07:20 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2070.outbound.protection.outlook.com [40.107.102.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdpv3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 07:07:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A8YbFplBR4SMR5GoHxmKIm9O9hkxPXGdanNJ52gAByrxJg+sXgmdI9y9j+vRWF0gELNa975K2luMAx4QDUnM8+boWP87p8Jn1JpXefFmv60fFb2NiLdF0zZUHVCxYx1NlqSv33t2kj3gYllNRX2xgeeS+17XlXM9i486PdHmr4SVZiaLXq/YBk/jtl+vo3C02FkVmIoTl6zk+a3vO97wkp5v9ispu+uxnRAGtdVtGWRwF7x8EcnFsw42r4Zpdz4xBHtRZ9sGvQ2yOYTlyLU8nJrgzMECx+R/sWu8FqanhLzhyPdkJ/nqQUYK9t7dNjvAVh2WZl1YHVQwP8Hkngj5XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUIomfU539Al2NHcGf+1JivYAtqzb/CkJ2asiMmiwHQ=;
 b=JmV7H1Q2NwIcAlkaR8prjrAElF/k/tX1IPbWnQMV7v2Xll2U8yEwY24zJjX0KHYqrChsI4jtXL7j01vijwiNupsLXC6uSWrBpWW73HEUfShjVWyha/SWgsAvpdf0+QuRVoJZKJi7G4Y+lF2QYzGxemZBsoGaTw5oS0AfYLRIFJ8zLmTF+S92UbWSIOH6/n/eJE/YoqB7uQiXkeTmXxJtZfryZE/AjO6Dak5JVTkOGnv2LHiC1c/Bnn9r/pHGRNg12NvtwCzen0X4hT2cBdqcMjWdYdVKjjP8t6aNJL3myYY/KVvRePnda/aleDJ3RRjqC6S/x/eJ5ZKIaj6uTm/MVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUIomfU539Al2NHcGf+1JivYAtqzb/CkJ2asiMmiwHQ=;
 b=iJrktXHmCPkR6lPrpq2nB8TqhQ0wE2aW8OE8N+VtBD8mNOKEp8loQi1R2kZyYOhA9wsByUYioNvCB1Ls0eNGF8KRpyQh4v5lD35ranBgGuK19V9nGaJ4i6PPl60w5A2p/n1u99d4t71rZOFcVZHzQM8lVQCKm6zdmQrg4pBrhMk=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH8PR10MB6454.namprd10.prod.outlook.com (2603:10b6:510:22e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Fri, 15 Aug
 2025 07:07:16 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 07:07:15 +0000
Message-ID: <0823c04c-4d52-4814-88e6-a594c19a6259@oracle.com>
Date: Fri, 15 Aug 2025 08:07:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/10] scsi: libsas: Add dev_parent_is_expander()
 helper
To: Niklas Cassel <cassel@kernel.org>, Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-15-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250814173215.1765055-15-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0119.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::17) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH8PR10MB6454:EE_
X-MS-Office365-Filtering-Correlation-Id: 621ddc19-94b3-4040-73f2-08dddbca5d4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NlNoS2JxV0M1WEx4MnkyMDRVejFIT2dZZmFPeTRvQ0xVei9yVm9iMnU5enVi?=
 =?utf-8?B?eFExVmhSQkFCWXRSNzdaS3J6WU9JSjVwYWs1NnJkT1Q2UmFDNnE1alVkVHky?=
 =?utf-8?B?ZkRJbWVmZ0VzaHJLem9kMm9xcG5uTzBaM0cyaEwrcWRQa2xXdzN5b3IrcmJ5?=
 =?utf-8?B?NUdjakl0ZzBNMnlIS0tSMjlUTlJFSnV1S29UR1pSUHhtL2dsZW5oSzU0eXl3?=
 =?utf-8?B?WE40QWxOVERrYUJDUmlaYmlTRXBRSnVlNFFuYlFSNTFSU0pCcEsrTGp5WnFD?=
 =?utf-8?B?S0ZVM3lzeEpFa2pLZGxubndjeUxQejZZenpodW5Fa2huRXY3ZVpyVWlSenhk?=
 =?utf-8?B?enk4VnZNL0kyUWZxK1NBdzNURnFRNVpYMmFKakEvRE5YMHVITXpXUTE2RU0r?=
 =?utf-8?B?aGxKUUpZUkJJRlhZVTg2M3VmTThhVFArKzU3R2hwVjM4RXFBYnVJU2pLc3Nx?=
 =?utf-8?B?T2lmNDdWRkY2WU1ORGhUeWd4NUdTbTNLVHpIK1JRTUg0ZXppcDN5VFl0U3BK?=
 =?utf-8?B?Z1d5WE9UemUrVzZnY1h5VFJ3SnFDNzRzUzQ2WTluVkpkLzdpYXZDWlA0bk1W?=
 =?utf-8?B?Y0k2RzlMVVFobG5kU2c5VHZFTnF0aGRzTkJHcGlaN2QvMDUvMHo2Qzd0NVQx?=
 =?utf-8?B?VlJST2pUb0pPZjM5dHFWWkwvWkZwamFvTzZNY2JaaHQ1NC9ad3RQTkhSV1Zy?=
 =?utf-8?B?dENtWjVZZ2tTMHcxblQ0aE92TVdMeC9PcUhGbHZsZytPRlkzN1ZvdTNpYTho?=
 =?utf-8?B?RkRkUkNtS3VWaVJHajRFZVZlTDJEV0hnbjJEN1k0RCt4bnU0c1VuMmIvR1ZR?=
 =?utf-8?B?M3dwdzNkOVNLZ09ETGtOZHVRVS9kZ1VzSld4VHRKYlJPTGkwdEQ2VCtBMVBp?=
 =?utf-8?B?L045bkdEdVlnZTFRY0d6ZW40UnR2a1ZvUG8xYm5PRVRodXI3SmgyN2J4MWlv?=
 =?utf-8?B?ZW1TSW5WWm1VNHVUNU0rVGxndlR5ek9jV25OcVVWY2s4M3VsVGVTbldqdHBV?=
 =?utf-8?B?dk5vWWhiUnplWVphUU03R2ZuaFFwUGVUclpOV2V1L295NjdVS0dkaHlxdjVM?=
 =?utf-8?B?V0NCTE1jSWlnWWN5UThqZGZET29rQjYyZTlUckNKZXI3SmNpOXN0U0pOUUhD?=
 =?utf-8?B?SzNhRHZBMzNtdFlQZDRhSE9pNjVseVVzaUxHWnZoZzY3cHo2WTNtSGozZFhY?=
 =?utf-8?B?UTZqdEl3K2pTdTlXVnBrQ01iVW5LaGFRVm9DcVJjMTY5NjhjSVl3Sk53RGhJ?=
 =?utf-8?B?ZHhZZFUvRmY2aXBRKy9LdkFXUVhJVFBETEtLb3dCT0h4bEVGUXZIY29LOU9z?=
 =?utf-8?B?eG44cDY2S1pjdDdCZjVHNFJIWVlxaXAydjBqZk9aNGF4cExwS21HOXkvRWo1?=
 =?utf-8?B?U2hpV2pZazV2UklpcHFGbkw3NWRzTVpBd09uaC9jOEx0TzRHbzd2aytzS2pJ?=
 =?utf-8?B?OG5wT0NHYkNrMTE4bnBlTlZRaHR0QWM5MFhTSkRBbTVWd3BSc1k4Y2k5cUp0?=
 =?utf-8?B?dmFvSUdJNkJFRFY5UmVnWjl6aUtJdFpoKzZWSGJJRzVPT0ppekcvMFhOT3c3?=
 =?utf-8?B?V0JlUzVRQWxOajNYV0JsUG1tLzYxMDhDL2l4ZkVaMW9mR0EzODV6VnRmV3Zn?=
 =?utf-8?B?SFlmWGJZK1lYcDFUb1F0VkdXOUQyYytidzUxNXBxR1V2TTBZd3hJRHNjdmpD?=
 =?utf-8?B?anJ2L2E0TzdJT3Q0NjFJQUJSYlRSUHFFOFp4Yk5Rblc4WTBvWUNXK3I1d1JM?=
 =?utf-8?B?SE9KODhiaVQxOHpITFJrc3hENEEyd29TcnRNWjFjUktjUVN5WmtGMFMxY3I5?=
 =?utf-8?B?SjNrSUN0RElMNFB1YmpaV2p4amR1YnNvRUdrRW9ybHlmRi8vd0VSQlg3K1No?=
 =?utf-8?B?TjBaQk8vWFFBR1VDWStzSXlPTWZBWXdjTjRBNGZPekNEMVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VG1jWnFTU0tnSlc4QitrZ3F3QnBHdEhOeG5pVStyRXRjNE40YTZxUFdtL0F3?=
 =?utf-8?B?bCtTc2swRGxTSStXL3k5YnkwRGZsUUpEUmtFUzEwU0JjUjMyNTh3emdab1Yr?=
 =?utf-8?B?YWZHd2xVMWNSeW9jZGpMdWhCaFVzZVJkQ3hWQ3Nid1h5VWhhTytzdklXUHVp?=
 =?utf-8?B?alZVajdORlQ1bHdFUFc2VCtnNldNMlhWd3UyU3pJM1RQZlBiTjlvV1Y3RGxl?=
 =?utf-8?B?ZlF6ZSs0bG1wQlZhV0JVWlVrUDdUYStrc0FxdzhtNFUxV3ZTRXgxZWVGT1oy?=
 =?utf-8?B?a2JZL1N6WWVmQTZoSmw3cVg3OG5rbnR5QStXejVxVnVLS3puS3laNHJPMGVa?=
 =?utf-8?B?NUhUM2xoeVRhWXozRmNjaU5uRzc4TDV4djF6YnFqcG5Ec1hERUVOcUNMYkVj?=
 =?utf-8?B?MjA5aFdzZnFaMHZzbG9ydTdmTitzZFRtRytvQXRVYWxmYWtOWUp1eDhqNGFK?=
 =?utf-8?B?ZGlPNkd5RzdBVk10K3ovWDNERjFHcFdWeHlNVVZmTEhLVXMxQmhqQzNzTTQv?=
 =?utf-8?B?WUtyclJLOEhETTVEQVpsb3luU0FmQmd5aldjVUxjUUQ0eEQ3MkR0RlVkWUZD?=
 =?utf-8?B?V3JBUXRva092TjlHa1BIVWc3SGVEdWpydlVnTmZhSmIzTHg0amJMWTh1T1Iz?=
 =?utf-8?B?T0Izb2MxczcxMEg0c2JHd3NQNDdUVmp3QjBMYTBqZjcrTkhHQkp6MlZnd3NO?=
 =?utf-8?B?SHc2WGZ5SVZaS3VHN0l0UHlDSUZabVBBUTlSSXBOcEp5akNMZzNaaEdCd1Zw?=
 =?utf-8?B?am9VSjBiRFcxQ1k1Si84MXF3YmVNZzNydVFXWEFTMTB4Nm93N1UwcFFITG1D?=
 =?utf-8?B?endyWUdjWW9ZZzJvVGp5bnN3dFdHUDlxRVloOUdPVU9YYzJ0TVJqY05udktV?=
 =?utf-8?B?WWp4MTBGd3ZPN1JBOWRaNzlwTVRpSmkxWjdkUkpwL2doZmhvTU1DUVRlZWcr?=
 =?utf-8?B?ZkVXWHQ4UWhtbVN1aWJ5QkdZZ1RTb1VJZjhXNi85OWxNc3hrR2dDc21MOXZR?=
 =?utf-8?B?VUJNaFhPLzNFL2pjSVI0U1RyNjlidWt6R3pRZUgrWWU1RnlCZVFzdnltL05N?=
 =?utf-8?B?bDdhdlRsR2NDeDhpZGNqNUxCSUkrcmRaaDRDZTJYOFd2OG5FVVF6NjNBM0Fo?=
 =?utf-8?B?KzR1VUNhVW42T215SGZvMDVVQnY5RUdRK0JpR1VzUG1jblp4ZWZHTmZaODJD?=
 =?utf-8?B?YWNHNlhDS212T3krenY2NVFoVkJvNUlLeHdRem54aXlMWTdqZEN4L0YxK0NE?=
 =?utf-8?B?TERERCtFd2xPbWRSOUQ3RzdIMHYzRkVIT3UxSHJ0U1JweGRxa09vZzBKNlpQ?=
 =?utf-8?B?OUxId3MrcGRrbDJPRHJCQzA5M2VKUVFlWVBxajd4YUxnSzBQclpRZW1xTjRr?=
 =?utf-8?B?dCs2Nmg0NzlGcFd1QmNVV3pQMW4rOS9HNWNsUlNDZUcvU3Z6aFl5NEVuc1hH?=
 =?utf-8?B?UTJObWk1UHFQaFRJSlpsblNhcjkwenArL1FCOVF1ZkNYMHJWTFJCZFhQR3Nw?=
 =?utf-8?B?Zm5KTVdWcGg2RjZrMTZ3b0NpZTB4RUV1T1VQeTRRazNuTWlyRUdlNmo4RjlJ?=
 =?utf-8?B?aEJ6eE01QmJjYXVkeDgzMFpUUE5RMGxMbmMyRFZmakdaNS8wa0lzMEJyZTJs?=
 =?utf-8?B?NWYrSEd4YjA5LzRJR1JoR1lSc3lyRmhYcWgzSEowR1AzYVYxWFlvY1lKWUJ3?=
 =?utf-8?B?ZFh6QlBWaHJUWFZobDI1Q1VmdmMzOEdwVXBkQXdyZmZGcE0rK0pOUmdyQ3kx?=
 =?utf-8?B?dEdtWlFQZkZkTURRMjhkWWhUZnVKM0VyY0FWOFhnNzNSMDh6RDdnaXZ3V0l0?=
 =?utf-8?B?Q21OdUZicVpKNEpUbXJJNmlBRGx3QTMyWTVhMEZ3bU5VUUkrU1lBcTJXL2Jq?=
 =?utf-8?B?a1Boa0d5Q0lXb0VNU05kVGlndVRnaHExeURHcHVJRU01SU9Uc0t0SURmVFAz?=
 =?utf-8?B?ZnBoRWhNSzhIWlA3V2NvaDR2eVZVYmVZYjk5NXFZYUl2bnpxZnEycStJUGE4?=
 =?utf-8?B?S2hrS0FmQWtiYWJaTXd6TjBBNm5oRkIxbG5BZllicThmU1dhS0lrQjJnTDUz?=
 =?utf-8?B?S3p5UEkwLzY2ZU1iZWRZVzZhZjBIck9zWExycGFOb2VFZ2pvUXQ4VzJhOHI3?=
 =?utf-8?Q?zWKyWlTiz/6CFnN5nhQLr+otg?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SigxZA+ek49nTezn5GwI1WvlIvDfqrR26N5dkEWQIiVUG1SHfebBC1y4u3GZmXjXFTnHd76w8BbhSk81x/D7PiDsNS1gWdz4fzlgl/R8y3XN9TL/s2zRY0kGwFmB8d0DSSJt8mthPkHdjomzCeeYKoQ6ewA1WODRCO30Az6wQOwAeQNwoaoWiRVGUGSNEh94NsOMBpeEYHy2j4nCZ2dHYycHRrrUw0P6b03tsy6W4LWGPyV58r0ilFyj9HNKgQrzhjnEst0doQl/jU/w7XrYkC3LnIZCl/ODbu/QH/dSaFk+22iM/kTWmKhRZcxOOmN4Z96QzakdejGTa3AUeQzlOfygyyTYxveYzdsH3vvui/he5k3eM93q0zJ0xZNWk/YZZftqjUNBN0imX9TliaWvcHwvFpvHD3OWHrCnGXUOxEIsDVAiTNBuJ60Lwf2XgyqIyIClDuEiNfUXmXWfeii6Uw1eJ8U3I2o+JGCLT0CNvK7EGczuXFf8yQheUoYJK75yeZPn9R/fLM0/w9CNWBZZgy4+PFGrzVREqsObhUX9FtEZhDDgn2mizbZjEWMx1ivYFXHxRNHHuZQRUajqPLSlQaSgQMyikFg/fX9zJH/LsBw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 621ddc19-94b3-4040-73f2-08dddbca5d4f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 07:07:15.6451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2STWN0fvUDME1Dn5YyI2Ms7y9FgbPzc/bXiEO6gkYJdQXjJNJMLBkfddC0PdzcRPlv3IBRA/Qxb7/S/Hk9vGfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6454
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508150055
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA1NCBTYWx0ZWRfX3WcRski8DXnn
 Syuvy4qn3bqrYcW2ImJMs7xR1f514VQNycpsDlWCL+WUxVaoJs66RTn81VBh3TU5We8XK9Uj1Ae
 2nlja6NziIYG8gkduw+cyUruaCTX7K/rAu4xm80Wfv4TSnNeuuUoCgW3T6OcetdT6UEvF14ibDX
 d+tZFRMpMjOwsprytYo2gAm3oXArtToo2uaCnllzyXUVtZ9G0vDO3LpSoq6LABRlK4ifyRQkFSO
 Lw4UF5rKSjqSu+kelBJdjSOUymRQUxhxLHvECZ037/9HnP2qwforb8/pl3fio1qs98T0/Vbcmf6
 5Onu1arqyhD6o9BDRlvrPPyxROExohkBvQC5op1HqBHspb5nqjAxPuiJPISm55vio2RGT8YdYtL
 k0WQ71aRMjKTqhy8r7W4bi/MKIhImQQ+4DAgaBIZkximFXGn23fFg+656feLPqil4hqcxf4h
X-Proofpoint-ORIG-GUID: K_tm9G8p17rwQi5GEWLH5w1HNrCzWPov
X-Authority-Analysis: v=2.4 cv=UN3dHDfy c=1 sm=1 tr=0 ts=689edca9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=l3nu21jHNtwAd1FSofMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: K_tm9G8p17rwQi5GEWLH5w1HNrCzWPov

On 14/08/2025 18:32, Niklas Cassel wrote:
> Many libsas drivers check if the parent of the device is an expander.
> Create a helper that the libsas drivers will use in follow up commits.
> 
> Suggested-by: Damien Le Moal<dlemoal@kernel.org>
> Signed-off-by: Niklas Cassel<cassel@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
