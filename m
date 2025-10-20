Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A258302758
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 11:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760960393; cv=fail; b=nudUr6xQiQ7HoV7stU+xL4qHGJnTC75HQNRNES4YU6uHcryDl/OEy/AQ0tuJ4BXdQknp3BdaQNBHLWueDzLapcwptKyF0ZjG+75mAi4GyHtH9p6TNIT/suh3H+ePD1NOjIrpzrJGeSgQKT8P6yw2UGguo0Jdaa5VUvo7nuGo1Yk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760960393; c=relaxed/simple;
	bh=vRHqXoGpAv2Et5JjBia8yuAodxbMhlxZcWBiQD03Hqs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s9lP2oBjdh6/LDZEXe0xgMu/CFjaLKhjVyjv5fr6ckW3a+2Sfr1R1AaJgT6FRQ/DRo7DuAxIik3ShL9Cmm4FLMYFttXUzjaNrcARXBuT6uBd3suaCoo6ql1jtHBAo95JplIv7u5yE8NLrvTY8xgQ4LnsU3sxTUlNqVL8F5GW6XM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HO84qnr5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DeXUNHWt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HO84qnr5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DeXUNHWt"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8SAXJ028240;
	Mon, 20 Oct 2025 11:39:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=D1SWlS3QOOfU0mpDgEyY9bwfcjtOKJnvMhAJOwwpyhE=; b=
	HO84qnr5WjEM3B1/yyizqM4uV1se7ENT5tYudcb6dU6gPL4jA1zg7wXITPF8o0f1
	A3QxgnZTb/uHPz36dChDNNKZ0KJoivgM/Izus9m1ACTtpWDz5BAXGul4Doh4OKOP
	r0Mn7TSVhEQXH+EaH4Kcvy9tUx+5KpOoDDHxTQQBRG0XuO8PRBDgEz2D+gg+c4i8
	ZuUqykpzrRf8pMIkjDZk+UOFzf8PZi1eE4RlYioMo7esDtTrpOnsrcLDto38Rj9N
	pqVPYQJ6TWRYJAjekfTMlTz2H7kK/KS7JpPX3pSRWkVy08xwtjA/dd144L8TVhkh
	AbP/8BfnJZwDpULUi9f02g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2ypt2ux-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 11:39:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KA24Ev009332;
	Mon, 20 Oct 2025 11:39:33 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013037.outbound.protection.outlook.com [40.93.201.37])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbujmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 11:39:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fdl6Ci/Ivis6ikNoZxWynbSViknXymQOzAe9aAjZDxoV4Dj4pCvr1+rJCgfMmUIyPb8bm8vCrYdLyoVMOls1Y1kR74qpn4w9X54VxZch4SHtDOB2U6sjguBYOA/FI+6zOOOPzytfYfxoeuShq1I2E7mmTa+pNHZlMOxRiSG0MaL3rjaAEMWXIoPXZhS7w3Ny4VPwASDGMR5Fz0dbWxdBnrxA6+y6OOQoZTkA5iB3GnX+iRfRVW/WU4nxCxCnWlhpumdgJIkTdieuyLbndaWAQaFQOywP3GZvc/uVka0QpiIff6MBh2q+LdK2seVF4BW99mqh2OHf0JvA6JtOz8UMcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1SWlS3QOOfU0mpDgEyY9bwfcjtOKJnvMhAJOwwpyhE=;
 b=RsYrfoiu2T7+nWBAKGV739Qye9fjYHVmF3+wWAlg1bWXkqribSf3Ij9Qq/yJednLniIqQLKa+6aVEtogljKiB/IQF7U5PlTKDKyHl9zCHShWUKSbX8wpdUtHhHFGvhPKMIJz+YNocIbEmgDuirQZoXVO6hCf+Zseq/T66scRkwknSUvAivkRYs3TTflki4hSe0doRyG2SXgZfUedmnvJErUr/ryzRxFbO/H2FAH5WcIXCmvIyGhCrCpmPLR2oHzY3I9v3fborCucfVTzsXbc8Imwum2mqKypupY7YBsLuwCk0BC3MKK0caIrE8yeW12dwfGQlQv+Ljw5DLPQsJGESQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D1SWlS3QOOfU0mpDgEyY9bwfcjtOKJnvMhAJOwwpyhE=;
 b=DeXUNHWtkEp2A7e1cWumjSHQA+mqJ4QSXoQFhCCg/G5s1nqFrOptQ3SEJGxsUrrBiwlWrixBbwl+HCIXtm5oRVbaYGPfJBHcYgPrkLh/L5gRRz4L3ocMuD4WOqXOygMJhIVuyOOd/8lsy1aKBTlK1BsNHB2FxkVhQjEpZyAHRPY=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CY5PR10MB5916.namprd10.prod.outlook.com (2603:10b6:930:2c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Mon, 20 Oct
 2025 11:39:31 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 11:39:30 +0000
Message-ID: <0b3e9efd-9ced-46c8-8758-76a1ebbe9ecf@oracle.com>
Date: Mon, 20 Oct 2025 12:39:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Do not declare scsi_cmnd pointers const
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014220426.3690007-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251014220426.3690007-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0319.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::7) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CY5PR10MB5916:EE_
X-MS-Office365-Filtering-Correlation-Id: 829c21e6-3542-4400-b6c8-08de0fcd5543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U2FYcDZYYjQ1N0Q2eUUvRmtyVEsxYlVxVzBRQzdPRVV6RCtnMkk5TXN3a3lF?=
 =?utf-8?B?VzRES2Y0V3VuaWUzdFVObmQ2Qlc2NUtzZTBKVDIzdDVpMHh6Ty9qU0VHMmdr?=
 =?utf-8?B?VERDYjI2czFIdTN1NTdvRG02dVpzNDZZeUJQeEsyT1kvZzE5YU80NE05UHdn?=
 =?utf-8?B?TCtmYjluTDd0Rk9DQTNCNFBhdXdvN0FLNFI4aHRpTnlkM2lJTUlUalJOWS85?=
 =?utf-8?B?ZUxsZHpZUnpWa2Q4bVhpdjZ1UDg4VGFWdkNIeW5CTHZlV0pERmtxWGRHWW1N?=
 =?utf-8?B?VnZKVVcvZ21OdFBGSHl3RXd1VjRTb3V2emFDcmdldWFXbmFKazAyM2pNQ1hC?=
 =?utf-8?B?bHJuOFA0dUVYbmw2cUVwd0VSWlVXbVFQaUs1RzhpekZudm9CTkY5ZUpZYy9k?=
 =?utf-8?B?VEh2WmowYzFwRlFscnMvK3ZqVHE3NU5TblkxRVdlOHV1Vjg2NVd2M2VQMURC?=
 =?utf-8?B?TXlaRWxldXJzdXpuSVRuNDF3em5MbCtnYkZGeDE3VWkwNG9IL28xS05GZ3BG?=
 =?utf-8?B?ZUQwcDloNDFpZ3NPZCtUUFRTWVNYOU0rWTJRV3JacURkRUhGN0VwRUQvb2Ju?=
 =?utf-8?B?VjA5bkMzcmwvNnpoc2FWblJXT0Z3eFljRzJFeitaTzRHamlDeWhJTzZUejNy?=
 =?utf-8?B?QzJCSnk4YmJpZG9lSVpaMzVWMnNpMWZRSkF1YzZTblkxeHJncE00Q3l4eE5x?=
 =?utf-8?B?ZGpkem8vTXUwZXVxeXRscTJad1REcnZDaXVQZ09wY2ZCL2NJM3JINWlmY05O?=
 =?utf-8?B?aTJZN3lkdmhEVHN3V0Q5Nkh6dmZmc1FzYXYvdGdtd0xJMTZLR280UmdsWWVJ?=
 =?utf-8?B?N09xNVo3R3EzZ0w4RmZmRU90dExKUGVneGhmN1B5cFVKZ01MU1l5MEhwVVBn?=
 =?utf-8?B?VnNFNWt6ZmlEbDlJdlhHSjZ4Nk9wVUhYSHVGY3BmOHVCNStFMHFmRTZnb2Jp?=
 =?utf-8?B?UzM0eTRuTWpNZ3dIbHNpbmtJNnU2b013RE1GZ3gzSFM0Tm5tQVZwU0U1ZGFR?=
 =?utf-8?B?azBSUW16N2EwTkhXQkk2dGoyaWJrMXJpQmpZRzNlalcra0hRMDB6L0pHZ29N?=
 =?utf-8?B?VVJkamhyZGhPVHhMSEhlYXF0V01Pb0txa2s2OERoT1N3Y1htVmlmemZONW53?=
 =?utf-8?B?eVhmQ3NLVndUUGZxRTNUdHVMaHhKWTRFOWJKSTgrcFhYWVVyeXJqeWNlbGMw?=
 =?utf-8?B?MzZoZFBHd0hhRUk2d1VMN2xIS3FYQjdCanc0YVhobDUxWjFZRHdqb2haekxp?=
 =?utf-8?B?ZDg5N1hEM3F2UFEvb1oxR01pb2VMZTJCaTY4ZXpyWmxYY3VrTTEwZnJodnV2?=
 =?utf-8?B?QW1pS3pXTkpndSszcUlaSHBsWWtRK2V2aFl6TjFlSklUSTkyc3lOUVVscWxY?=
 =?utf-8?B?YVZVbTlIZnRzaGdEdXp2anZodks1ZlN5ODBXbnFKdnllL0t6S3lwY3RoUTZl?=
 =?utf-8?B?eis3eHJOUlJjMHIvckZ2TmcrT1FkY1JvNmxleDMvKzNqVWh2Zzh2WFo0WlhK?=
 =?utf-8?B?a1RPbDgwcW96WmQ3Q3Y5Vk9naTUyVDBmWkhyNXZBNEo0NWxtZ0t4aUgwbS9L?=
 =?utf-8?B?ZkcxYlhjbC80ZGNkRngvM0FZeWV0cXpZOEZWUFlORnlqOHgwbzQ1cTlwZm1K?=
 =?utf-8?B?MmlXUHlKbXl0bXNJVzdocm1Sa05NTHR2Yy8xTUlwT0xLcEVWODE2TElRWTBv?=
 =?utf-8?B?MUNiUVlJTjQvS2lvUmNBem1ZYlJHeUE0aERuazJTYy9zQzRXMm13NGVXd09H?=
 =?utf-8?B?YjQ5M0RBVVRMZkgyaG1mS0x0cUk2R1dIUFpITEFwZ2N5eGdTcC95RStOVnJ4?=
 =?utf-8?B?c1NTNkg2Y1hYWUg0cWhudXc2cXNwL0V6M0VWVmhKamtvYk9FVjBIbkdCZENt?=
 =?utf-8?B?M0VpaE1qUGUxUFdSVS9UYVc5amZpTnBhYkpIQnN2dHdmdGF5bm85LzMxUlpU?=
 =?utf-8?Q?/6p0cqLYL+pMp1LLZCncMxc3WxiZ/o92?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWlIVzczekFVakFoYy9kTlU4N2hORDZVei9rTUFqWWJ2Z21DQmxLNkZJN0xP?=
 =?utf-8?B?SWFhWTg1U3QvbVRKdVZrT1VSSXZ5dnIvMUhPOXRNOXMrMGlKcWpGSDhQVGx2?=
 =?utf-8?B?cW1TOUZrMC93NE9jd2x3cTluWjRtWnJOTTVQR3RHSUhWOWwyb3UrdkNCNDRa?=
 =?utf-8?B?UnlxbERpTXdKa1gyb2dHRTkzZjNMKzhlL2dyNGRXSWtXSmxrc1d5OG41VFRp?=
 =?utf-8?B?T3crS0RqOGxHK1lLSEFIT2FDUkE2eFNMK1gwVTUralVvRS9zSzh5MUtVSWFi?=
 =?utf-8?B?NVRUNjFrZW8zbHFZTDQvMitkWE9hZXVZVngvQVhqMlFIK1RzWGw4VXIyV0Rx?=
 =?utf-8?B?KzgzbTJVemRldTYrOGpxbzBkVFRORE1EUXQ2bEc0TXl6SUFDeUVPTlRrSDBa?=
 =?utf-8?B?dmlOanBYZ0ZzWk5tWXBwUm9kOThnLzA1OWdsR1o4Qy9mbjhaMitPWTMrSnBn?=
 =?utf-8?B?VjFjSng2R21mcDN5WloxQlNSS2Zra0pFN2ZodDNPY1NQV3ppd3YweTFpVGw1?=
 =?utf-8?B?Z0VySkViVmx5UXY2WVlNUk5MNHJJZG5TNVlvYlkrQ1NmNHl6SGExdjRWaG1T?=
 =?utf-8?B?M1VtRkVZTkp0bXF1MnFHSEUvR1lvMHNsNzlQRmZzOCtwby9xVzBJSFlmZnFv?=
 =?utf-8?B?OURoWTd4VU01TlFoTFlXdnl0M0F3eE15U0hEWXhOYUFBMjlaSTlYdGxoZ0VD?=
 =?utf-8?B?TmEvL3pGYkxJYUlyeVNibytENldqVVB5SEVSMUNNL3VWZE4zSk9vWExRdWgr?=
 =?utf-8?B?R2xPaDhVZFp5SU1VbUF3a1JVZ1lrcm56blZBeXpOL3NURUlwSkVxd0dCaUx6?=
 =?utf-8?B?blZtUUV3ZCtKczJ6aXh4OG9vYkFtaUc5NVNxQ09vRFVyY2M0bEo2cmVseFlW?=
 =?utf-8?B?dTJsOVAxUVREZG1DN3FUK0ZSSGhDMG5Vak4xVjAyMXovUkQwd1RZT21EOHNq?=
 =?utf-8?B?SkttWmovQmN0eENkNFVFQ1pGb1Q2SW5nN3pQZ0kvQ0diQjFSbVBzUE1SY2F4?=
 =?utf-8?B?N2lrSVVGRHNRT2VqeEZrZWN6VWVCQ01tdkZBSUtHOXV6aDVLVGFLakxMdnlK?=
 =?utf-8?B?SUxxN1l6OHZ2UG9rNFdybGtNOGNKNXZSQXF4dVVyZDZQYzNtL1pyMHprNjNL?=
 =?utf-8?B?Y1I4NmNldXpWTHdmN3JNbFRlTVZlL0Yyb2J1MkdXVWJob3lGVUgwKy9qQng0?=
 =?utf-8?B?RTVsRjUvNnlqcDVseUptR291WDhlZGVwS1NQWnIvcXZlUWRYY0NwVUt2T2RD?=
 =?utf-8?B?b0FuMnU1K2tPMDhFd3phVGlUY3BJby9hVlBUR3hsbWhpZndtRCtjbzdHdVBM?=
 =?utf-8?B?NHBub2xGTERXZG1DTm9iUFlUR2hoRXo3d1VnQ3JYK0xNWjFiRSt3Um9oaWVT?=
 =?utf-8?B?azZUbU1NU0doRlhUekxrZVRiRjNmcVlmUkNqbnE1Y1lFY2dTU3pmZVloYVRZ?=
 =?utf-8?B?L2NJUnZrZGd6d2xrLzdNQWRRNHIyd3ZpcFJpUXJqNklBMHBWbXBxOVZDSFRT?=
 =?utf-8?B?WTJVdUpXYnR1NFhqbzEvN3FUUmhTd1RySS8vMjZOTy9VY0NkZXBxU2JOc2pS?=
 =?utf-8?B?eEUzQzA4Qmw1NEZtMmtZcUlubmV6Mlg0Y0JlbXBKV3dwTWhVbEhNVmFudVpO?=
 =?utf-8?B?S1B0RmN1Q1Nvd2gwUzRSdzJMUHBsZEFJTDZnbEhOOTBRNyt2bDhHOTg3TVNz?=
 =?utf-8?B?MzJWaE9mVml2eHd1Ym9YWjlCeXBxcjlkWVRCeU9Yb1daVEdvQlNEK3dqcEdj?=
 =?utf-8?B?d1kzTTBOV1dNU0s2dmppRHJsTHU0NDJ3emtSa1lSbVFkNzhwaWlacndCOXZn?=
 =?utf-8?B?elUyVjYrbjJvaEE5cFdwSW8vejZQaCtISUZhN2oxTkg1ZUZsWXh6dU91MWdh?=
 =?utf-8?B?ZkRuL3drZ3VQQzZxZ3M5RTFXeDhCcVJPMk9jYWhWVDJ2T1BQcmFlanYzQzR6?=
 =?utf-8?B?MC9rZlBFVXRFeWxVTWdxdzlWS0MvM3AyaXgvcWVPc0J5Nk5qaHdhWUgzWHpl?=
 =?utf-8?B?RXpjYmtJK2NvR21QbHlLMk9iUmt0WTg5K2R6alU4Umh0S294YTg2UzVFdnJU?=
 =?utf-8?B?eEhyRUhNRXBZanh6WHZRMGhWRlhiR0IyUjNVRUZsdmVBWlBCSnBTQlpKK3VJ?=
 =?utf-8?B?NE9ZVXdLenovUWMreXpHSXNYQnlqdWppQm4zWTRUV1FrT0hnSjM5eXUzS3My?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oSV7WULG5G0+bV48x+qEcKDdwQZjMRxXHtWO8gz0Xc7jpHl1hPfpzGg+NMvNe5J17GnajVe1JyHMNVgE8uhDVJF/Eh1OWFPCjiRM8DU0HDsDveXj1/QSaM+nB1vH0FnWHVG8D70NnC8V/gFOSjx+rK95cOPY0wdI2tEFBbvTV5W7YHf5qq+b4bUJJwqNDToqxbQuPorzdlnOih2Zz4rvHTKt02Z3DJ+b2Zi+wVdTkdvpPMEyVCLEnmwE4SkTPEV0TnEOHyMC1FVWEygUtDh0vdVlHUKQWyn8eC7pYhEI5pHu3z8PE8E3eOoH0hc6fDsbFCy7zz5ztgvITP6JgE6ebqA/3lhtCQymy39Swok+lEXP+mCn/v3OzFjuDvCm1o5VU7JYABrVG4wCf2ieczWczDam5a1iDf5GHG7gGY+WfBL0uSdyfpVb94s51KnQ2HtJcO6bF4Be91rj+S0VQ/36QAKJGHRY8tRb79/5EYyG6p0eDOJyIcG294WadCOY9bgkDE24mz3kJ+Y9YjE/f0/X+faX6ypGzodMu0QzuVCcD3i2NlzaSEqEGgCs/DZF0EG1N6CIgutqY49XMO547TinTog9e2gRUZDmLQvsAlYWR9A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 829c21e6-3542-4400-b6c8-08de0fcd5543
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 11:39:30.8496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f6Aihu+0LH23yZ5a1EbmuatWXg/ftV1MzRtBZUbv/1+Q8XuC962gvlnykuRiYky1uCKoTE6w7KOfbFpGelB1BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5916
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfXwhij0hP8q2N9
 gsu4Uc6KlU34ZjpmoDs2b7kqUaVCXLhLMSRC+dMxkGXzQVaybt19+bo5C8xTcBTnDu4nAPNwyJo
 ravX4cjWJSQdhQuOGSRxv8uQStW7yN8AmZzu0O44EFowTOL+/8gNc1S9FkppctFE+FGzuBkNBY5
 xFyGBG+StxScVtiLK+8PsQL6oBDoG9IQd8peTrRVJYXh9o87gWytEho0dj4rfAH4iqSxC7l9InX
 YLv2R24OviSCZ9IyFzig79EYT8oR+J53XqjtwYQOAN7zjQGKiPbc9g7w5VInFr6LurqMY/73p2A
 atNK8wtjIpgWKsdYqzZ8pw/zrXhMkrWB4DcBLm+2Xa1sNSKCJZo8oSSu1/pZC4hdELKbPWlaOmt
 2LpcL0uP7etZ0MGBsdOrUiiv7eeZEDEBlbyXJUHmDJVgNTdcImo=
X-Proofpoint-GUID: mzjx14ohN4B63oB2xJ0G-5OkoueIJAB2
X-Authority-Analysis: v=2.4 cv=Db8aa/tW c=1 sm=1 tr=0 ts=68f61f76 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=UG9abp3cszHm3YWyTxYA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12092
X-Proofpoint-ORIG-GUID: mzjx14ohN4B63oB2xJ0G-5OkoueIJAB2

On 14/10/2025 23:04, Bart Van Assche wrote:

Maybe mention in the title that we are touching the scsi logging code

> This change allows removing multiple casts and hence improves type checking
> by the compiler.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Suggested-by: John Garry <john.g.garry@oracle.com>

thanks
Reviewed-by: John Garry <john.g.garry@oracle.com>

> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_logging.c | 21 ++++++++++-----------
>   include/scsi/scsi_dbg.h     |  4 ++--
>   include/scsi/scsi_device.h  |  4 ++--
>   3 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
> index b02af340c2d3..3cd0d3074085 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -26,9 +26,9 @@ static void scsi_log_release_buffer(char *bufptr)
>   	kfree(bufptr);
>   }
>   
> -static inline const char *scmd_name(const struct scsi_cmnd *scmd)
> +static inline const char *scmd_name(struct scsi_cmnd *scmd)
>   {
> -	struct request *rq = scsi_cmd_to_rq((struct scsi_cmnd *)scmd);
> +	const struct request *rq = scsi_cmd_to_rq(scmd);

do you really need to declare this a pointer to const? Or just a good 
practice?


