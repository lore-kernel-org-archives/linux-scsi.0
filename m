Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6051DF979
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 08:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755246881; cv=fail; b=OvLkFym1SL5YzuU2QZ9v81fgcLjwyjIl5dPAhBd7qbZiZeyV5xXPa69WaQP7R8PaX773r4chR1Cegmb40oTsF3DjMp8h9HToZpLvQjwZ1iMS1UWuS4IwvxKB8bL0J3w6e7FiKvn+2sF+/8nDyCQ/+dQSQQMqXKAgHFzKtpv9Cp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755246881; c=relaxed/simple;
	bh=04UTNo2x7ZclMgzrd8Wsy0pERTj6gDmh2KzNqJiVKeE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Yly6ViFDkjalk5DENNPi+zcAKGBrIlF/Wnu3VNxt1sN+VGLzGeeGFMLsiDwonnCRMcUSgEf2QJYZ82vajSsVyoEJffutE2SynRN1YuBXNYqlUFktprUtjEeNOSB17Y3UPCJL1y7/IuYs3ZTSpgBYTDRpwjbn8h+enDZML4iBCPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UV5WIVuC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yeTCHTUo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UV5WIVuC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yeTCHTUo"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57F7Ux5u018361;
	Fri, 15 Aug 2025 08:34:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=; b=
	UV5WIVuCIV8MLfLZID2nxy9NBv/2z5OQtc754q/I6F3oJEc0TQiY9pE9z55Al3eh
	gpFUJs3Pw3LGvflRPWqq+3WvTsWxRV5j7q25AFgPQyswOZNL4XDMxrTdB9GhUwHB
	rTkUG8oxK2FV1414ZXGaP0kEAWO/+JZYAcuhcyWJxE3+Vgtsgd7mlsgtpUwIf8C9
	ZESn9yk0ObDV3t/Jh+2k27AdSM5Zb9kcYvis5DKQxYomBbZvlWVAKxMTn/skkYgO
	AxuEZUHRv4D1m+NT4gZg34NnrktAPqsUQ7606vxNeNfWrPKJUV22hY3L971UsH/H
	bgn6cySkr6CD+Dc9OX3X6g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48guchc32h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 08:34:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F7CYLo038842;
	Fri, 15 Aug 2025 08:34:34 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsmaxsj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 08:34:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uPw3lGUcIRk/6f7FGQeiHMUBSQHXneaxUmcvhhT6a4xoeuPUp8Hy4AXNHok3F5DOwOB4Zg1S9K06H2mSut+b6OiZyNYHQEld++DqIvuY5ilJD14EPCmKVI6p7TnYHxrbJS/vVjIwmCYeATU4WQ5HLMIdFwkl2j8wv8ZfLTykE+G+XOnoC+s7XFnErWnY0MfPwDd8jyazz6dJxWYmbcdcOIjq+3yFrKL6wV66Yt9k1NN/fgGOvyHqg1l1iemxwiGNZ5Qga7lt3fFGffQ6uvLat7FR7okHZ0QLLHDWIBBy3LdZ3ZZCS+Yv4h+Pg6jugHsdjDo76wJLJuBrjkutwLKnOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=;
 b=yqTw77hRUEJPCWdRMx8rC6I0RWKBYS5TfIswpngjEW0F3YLGK7IhK+lyH9yRRpjKPaZInUjWbUNJjCAYl8Oto+1rkIsPFzLU2WVx6454nG2SzHY6eGSX4fuN/bgnepdUS3N1fcnoxKUaklMrLfHLz5CCdGj/92fGftlhkpyf4qMS/7aJjn/bc9UUfPtmcatz7OxeAB9sUGRgyb+cD14zacy3YCXjsLBOLq4eVa3Fq1UItgnUhQUx8dL87Xg+V0Xh69rtB3YNvUbCbVr5tryuIEFnke2CmPyY2qJDCPJt3N/3raOscUAaAP0ewGuzKKJWNzFMRNTC+PvHT2YXuAMb8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=;
 b=yeTCHTUoOofM3F6GTMAJF9KSNRo+ghZpxhkEFYB/yfKTtgpVbEOeLP9MiJlAoIlVFgLXmrKDbC3qu9HISvOsYIwHJxecaRwD5S9ww99RVdsT0ZIKvBgFW38fm0MW5+RcUpqXEGGMifezdxJqj1UYfiqiKTx3pCqooD6Gv3goW/k=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM6PR10MB4330.namprd10.prod.outlook.com (2603:10b6:5:21f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Fri, 15 Aug
 2025 08:34:10 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 08:34:09 +0000
Message-ID: <e2ecf418-5ef5-40fe-84a8-9d50e9d0ccfc@oracle.com>
Date: Fri, 15 Aug 2025 09:34:06 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/10] scsi: pm80xx: Use dev_parent_is_expander()
 helper
To: Niklas Cassel <cassel@kernel.org>, Jack Wang
 <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-19-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250814173215.1765055-19-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0181.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::8) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM6PR10MB4330:EE_
X-MS-Office365-Filtering-Correlation-Id: 726f658d-c4de-450e-f548-08dddbd680f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WUlPTGVPbFdnNkRsbWlUZW82dXl4Vms0UkhrOWNhUFBSNlNJdHNnYm83UmxZ?=
 =?utf-8?B?Y1ViTE9BNFh2T3RXRUFqM3hEOVlqVngrTEYwN1EzU0wzeExwTGNpamtJK3Qz?=
 =?utf-8?B?eCsvUThkbWZTRzhaZ2pHVm1nKytXVkVWS0ZCSkc5RENhUzIzUWJ2YTd0eFg4?=
 =?utf-8?B?VXRJWHgzenlTTjB6b2VLSmpXdDJ1cFYzU2pKbFF5VGkwbklzNjV3eXNhT1Fn?=
 =?utf-8?B?WG1BSUowS3VId3UvNHlUV0x6ZVZzWFpTbzA5SVYzV2VQalFDT1gzOVQxU1Nt?=
 =?utf-8?B?OEljc2Z6NFRIMG9BTUthcFBuUTF1SSs5dUVoQkpVUldWTmtzWVNEcmtHei9B?=
 =?utf-8?B?bm1NRlFOemJlQVBQTGFsdHMzRm8rTnR0bFZmcCtmdkVDNWRWckU3NzZQL0dG?=
 =?utf-8?B?YVRaeXZqM2c2R3Z4ek54VmNHZUV1czJXVHZldjJxbjNibW1sNTlJcWEyUHJG?=
 =?utf-8?B?a1NRN3ZZWmdsaGlKMVo5RHVXTitQejJVN1dhOXFnOTQ2SlB3WGI3ZTliYWVH?=
 =?utf-8?B?S3VCaXhrZkZWUGhIWkY2WUtqS2F4VTJmSnkyd1FkdGpTcGE0c3FUNXdVcG9s?=
 =?utf-8?B?ZE51YTNWSVdINzNqNUJWb0gwbTlKY0RNYnZWenV2UitSTEQwQjIyQ3NyNjN2?=
 =?utf-8?B?UHlYMm5GQnNqUjRxdXpRU05uTGRhbUZoKzZNemJzSkZCN0MvRCtGSjd1Z0Iv?=
 =?utf-8?B?UEhaZ09nUno5aGdQZXBWOW1nd0lzNklaMHF4ZlZMNHl6L205SnEvMVJXQUZH?=
 =?utf-8?B?MnAwNSswTGhaU3BQdURJeWtRT2U3elBLa3hYZUZSVTBPQ2EyM3JSYmNOQkhm?=
 =?utf-8?B?NzBlT0ZtQlhkWkpFYVlpaXpJVU1hNllrb3E2SmNVY1FTSjFhazI1dXc2VmRP?=
 =?utf-8?B?RXd3VWdJTnNtSytIZ0I3NEVBOTUzbStFbkZBeERESDZrbDNPemRwUURGWEsy?=
 =?utf-8?B?ZlRERUkxQUt6MWNrcWJYa3NZZEVKdCt4d1IrZ1A5Q2RZdDBQNXhkVGZDMVgw?=
 =?utf-8?B?OHJ4QUxuaEpWWGM4QWpINDN1WElMUEdzYnplK2VmNVVudzIwNGFoVkZubFVl?=
 =?utf-8?B?dnlHb05yblZKZEhEMUpqYTBLSkxzd2xSa2ZDQlFSZVo4Y1UyYUdDRXJtSlhv?=
 =?utf-8?B?YTJBUmt1b2t3N3Z1VWZPSVZUK3lVVkM1TWxKOHlIOW40VXYycHhSUktTcnJs?=
 =?utf-8?B?d0RKaWRGRkg0djFMcTRJUzVGdS8yMkJ4dkpIdmsvK0R6WmliMkd2WjAya0V5?=
 =?utf-8?B?K2xJblpSa041NnhUSWl1K0ZYK2xWYXdMNmNCYS96V09KM2lOSWl4Rno1MFQv?=
 =?utf-8?B?QkNUZ3Z6bjl6RFRkWDRIdGo4RElmRkwvV05HSkQrY0pnM3VndHk1MGgweENt?=
 =?utf-8?B?cnZ5aHN3d0pWYmlYbGgzMDIvZmZKS0FDcnhxa1NXZ1d1aUFraDB4MlhZdWN4?=
 =?utf-8?B?R3kxZlZxaFE3Z09vZlZ6WEdVa0c4YTF3VnMyODRVdk42aW5SdVNibU5jMXM1?=
 =?utf-8?B?dDlZTE9QSzNLMVUvWU5FaDJlekJpeFdSNW9IM0srY0VNVGR1RWdnclpudlJu?=
 =?utf-8?B?KzFCSk85SzlFVzF2WWo5YkI0NEV5a1NPenV4amVUVjJ6c1plRi91MlRCWmc5?=
 =?utf-8?B?RjVwcXRGRUxVanFXckRhbENxV1BXSERUbVE3WlBRTmtRRmcrbGwzR0NKWkxl?=
 =?utf-8?B?ekNYV25ZSlNlbVhjR1dQeVZkeGdMaVBabHk0MzVpUk5aZk9jWDk5c1hzbVVl?=
 =?utf-8?B?enJzOStUNUJpY1lYWGE1dXVLSmZaUEI4NWUrbzlkQ1doZ0ZPcmlvcVVVaFJY?=
 =?utf-8?B?OVZCbHgvNTVtNUo2RWdCSm1HaEpGLzNja1NDMmxuRDhVTzlmVEdLUE5HaWND?=
 =?utf-8?B?RFVHVGNHKytwVHRFTVJiRWVKb3pPZ1phRmhNV2hRZVMydUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnhHY3BlZXhvd1lhL05JSkpyMm5qaTZSa0luZFNmR1hyakd3WnpCRGo3d3dK?=
 =?utf-8?B?WFdYcmJaUzhoaDRXVy81MmY3SGllemRaOTFGSzRUVTFSdjhSYUhwbHcwN25v?=
 =?utf-8?B?TmVOcFlCb3l4UEpsZW1zWEdDRzEzRnZGU3c0b0pPRm1Ld1hISGpPa3BTN2Rr?=
 =?utf-8?B?dVJhd3ViLzJIT3J3SjVoS2Z0OVc0d3ppRDh1elNxQ1ZuZzFhRmlMQ0lwNG52?=
 =?utf-8?B?Uk9PZnhDTXBrd0RZSmR2T2lxakFsY05peEhMTTdJMzI2QzNzV1RaZXp2cEx4?=
 =?utf-8?B?dEhDMSthUzcvT0pHNU43S212ZWMxV1ZuT0pFTlZyVVZQUzlYMGxnZUJHL0hu?=
 =?utf-8?B?SnhwTmo4dkVpdWRLVHAyZTdXYjZuVURpRFhrNzdYK1JSZzVuaXU2UStlWWRo?=
 =?utf-8?B?M29XandhVmpmSmg1RXBiOXRPUEJtUEdrcnNPbDc0OEI3YlBuZGtHZ0E1UW1D?=
 =?utf-8?B?NE5yUytCNldZdzVLS1VBUFluRTJSWlpIRE81dUJ5dktPcW9HT1ZaMXVFVkNz?=
 =?utf-8?B?dmQ2emZBRG9qUEhUSzIyNHllRVhpK0ZsSHNPZHExS3JjVHNZZklld0RpSlNM?=
 =?utf-8?B?STZZc094VlZJNzZmNUdiaVlQWGRGbURtU21sd1NRd1Q0aE55Ukp4VVZRNS9k?=
 =?utf-8?B?anUzdWZJVVJmbGZZZWdaQUdmRHFMQUdGU2hIaTJWdmUrelhKbG5tUVh5THFY?=
 =?utf-8?B?V2owSlBiUFk5cURrY3F6aVBCa0hWa2s3ZHZ2T0R5Y3c0Uy9TekVsQzFPUlBj?=
 =?utf-8?B?K1JpMWJZaU54TFBCY25YNXpEbTVCL3BlTzF2Rk1YVlBrT3h0bk9MRU4vcko4?=
 =?utf-8?B?L3ZsdUI2c1NoU1Z2OXNaNEdmdjRaTkNxczdiNFJoWXJYTmd1RG5sMCtmNkkz?=
 =?utf-8?B?eHluNENrK0NVV1ZmNkdzOW5qMmJxenBiWUtaK0pZNVVIWE1PK0dJM1dSWG1Q?=
 =?utf-8?B?ZVYyM24wMlllNGxnZDJLQUpySUdpZGVXdWlFNDBJRnhvWElPdkhocXpxMjha?=
 =?utf-8?B?cWF4KzI2V0hyWXRmaEs5N1YzYVVmNm12cVZ0VURLMVluTThOM3puM1FRbkNL?=
 =?utf-8?B?ejVxNXZBOHVYS2VDdDV6c1g2Mmk5VEhSOHNIdDdPcVR6eEp2dFVUc3l5MWd5?=
 =?utf-8?B?N3ZkaVJhdjJiU1BGdW9zL2xmZTkvQjFvVnJWb0pIUHBBNTNhWjd4OEc5SEJK?=
 =?utf-8?B?Q2hMZTNIY3A2MTJ1dFBndUdqcXJZVWxKZjhORHFueGdTdk9vUXVFSEdTT2Ji?=
 =?utf-8?B?MExkOFhTaFUvSUFqQy9RTWdnb21wTkYvSVpJN0xqVGEyeTJFVHZvL21sclBK?=
 =?utf-8?B?dTUvQkF4M2xxcFhXSzU0Ukt4MVpGY0hNVW5iTHc4Z0NqdXdtRlU1bGJqcFpN?=
 =?utf-8?B?R0ZTNGkxWm1XWEJXbGlPVHFxWUkrdyt6ZTVhYlZ0cXcvaFhXQXRNMVRqOWk1?=
 =?utf-8?B?VXJGR1pBVkJ6QjRwODVncG9pQWhvZzNyeFlDdnprYVl6K3lkcVpZYXNBMlJr?=
 =?utf-8?B?UUMzWVBrTVlLMUxycjE4Uy9pbXNhTXhPT3g1V3VJRjdBRUkwVGQzQUh2aXRN?=
 =?utf-8?B?cU1MTDU5b3N5bnZkTmNZdHA0eTdBSy84TEU5NkpxcVZ6dkdNT1IrNEROeUhH?=
 =?utf-8?B?bEdOd0ZxeGZER1kxT0Z3WXoxTXBJWnA4Z2xBUTB6NEljMWNPTk5UbFVCSnly?=
 =?utf-8?B?dTVBWVJzdENseFFQUEEybnFGdC9RRGoyRVFRRWJPSVlGTDJ5N1FHbm8xZW5O?=
 =?utf-8?B?Mm1GYk83WW5VMENoK2FFRmVwaUJGK3FIKzhHZmdDOGRrQndQNlVwc3J4Qkhp?=
 =?utf-8?B?dTkzS3FDcEhIcm5uR2ZnNDI3M1YxN3B3NC9Lc2dmcDhIeHBhQjZqWkNuTmR0?=
 =?utf-8?B?WDdQcVFYQWpEcHBKNUprVTlYclR6aEhGd1lPVUk0Sy9hd0hoeWkrdzVINTZO?=
 =?utf-8?B?OWVlR2hyaUxydFlaTmI4YVVEdEkreUNBWWhTSE1YZXg1SUpZSVlrV0NTa01z?=
 =?utf-8?B?V0FYVXZvTjJOZTJyaUgveEpaeHRWREs1VE1wR01KQTQrSWFJUWhtL296Y0dy?=
 =?utf-8?B?TTRMZG9iTklyN3M4cy9WT3gvUktOV20xTXZQa0U1U3ZEcDB3MFBTZG5xM3g5?=
 =?utf-8?B?dmttRnRRcXpId1BIQkxsQzNhYTdaOTRyZmZIeXIzUXVINlV5RWxEaDBRL1lK?=
 =?utf-8?B?clE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ITIAceiuERQbS4y4Eii0agbWhnZpUyptC9urIOyOQqeB37Rvez/cUmb6wcnbdsvkru1lNlXaFQCPbgebS8yvv8dMWRsx8f7eC/ikuKcCzN28nLWoDowC8md4nsuQVAWHI/kTDtuqP7553jmoS05uUqKGddV3HPKpZyxFf3GQlnqNMh21t6zggwX2RcnBVHjww1NYSEkP/HbFKKKtuI0jvrgv8upAmOfYfftnqTUVYwmJ9RT/kinWHMmXeuI/G1Xo0ZD5qieeVRrbrBhvMaLVDo/4DhOEIqCYfS7OPQV2tlGJbNGsVYn1t0PVRNgKDofT+6YMeE0h6KYDRxRkVqtFKz99xRhCnzemyWFheIHk23j+yXCEQJfy1oOknYUqxPtX0kUtcvt6sWo1iEXSgcKQAKy3TPBxnU1GbmGxXjj8t0QyHVyXbLxKrzQnRKxymmTvz31hYcGaT2vx++P1B59NUR9H0XeHDZw0eBWYlQFq11bzUnuoKp+HavdFqQSvyRyabiUCvtQOvQUoq7xdQ+GjmclsSg7ogm5T646D4n86yongm5LJbRyxa3OUYCVdsB4srg9U/ylu/eRc6lvb3SBUqu8rbvqJR0HApIbi31gJUvg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 726f658d-c4de-450e-f548-08dddbd680f8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 08:34:09.9359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vaJ8FD/z9PsuFr4RpkC2GcbgaB/ADrBbdc2Dt2yaRdx2wM7igiDs6uOkVOD5vCk2q6rUpULXSptoBK6ZGTxozw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4330
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150068
X-Authority-Analysis: v=2.4 cv=Eo/SrTcA c=1 sm=1 tr=0 ts=689ef11b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=AacqcoUYExIgVmBA-oYA:9 a=QEXdDO2ut3YA:10 a=qVVAQA5K0MwA:10 cc=ntf
 awl=host:12070
X-Proofpoint-ORIG-GUID: r8ANdtMc9AXSgPBfzfTliLVyIlPXdvQU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA2OCBTYWx0ZWRfX4zHKKQrKRzg2
 H5K8UwjE7B7ARGvGdkdUuWc7wI3vQGOZi2V7mzY2vsQMO3t0Usq+pCTnbrJIG5lGq5tnO3w7dCk
 DdgbrUrsJ4TvoRDjydnGr6kDqZvLy0n42f1JP6r4Vxh1wWCHfeGNW3080bzIzNFKx/sqc1odqHJ
 U6/AucwpbkeFBhdVgNxCirhWMID7bJFWYaa+JWhKRVrg5I1/gfMPrd8BNIqUr5xH/NM9/+JAv5e
 ZLCwfdPlpQxfJcd7MffxR4VlibhO8aNdeEC9vKMFKZZFP9bCt1iBdF6+HbM10/qWd2uGBAT4cQX
 B1IsR0kXEXruPvZEgRn66ysUX3MSOgqlYy7/Di53yC9oY2vUxz/6W9s+vkZdG0bXROHCLpSjOZ1
 7/iILhG/cIKziSPGp6VUDiXHFEnAxgShpy4cJQ0PBdiIjgLCiYQ6EDiwsy6oopB4H//VzG6u
X-Proofpoint-GUID: r8ANdtMc9AXSgPBfzfTliLVyIlPXdvQU

On 14/08/2025 18:32, Niklas Cassel wrote:
> Make use of the dev_parent_is_expander() helper.
> 
> Signed-off-by: Niklas Cassel<cassel@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
