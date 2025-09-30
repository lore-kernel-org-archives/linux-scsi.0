Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8132367CF
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 07:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759215813; cv=fail; b=lWUwR28kQSaLxMd1grfwz+YFnZi+3lNxMbkqB3GWZz5WGXzEMiQCTcY4MLFjiPqWQiWgml/MlJK6RwpZTW3XKPVZzgMpY3cbXwh/Kb/hBjMeqza6DLGpPN0moXW3IFjZVPa0oco2OqgvdYzNtqD7g5+uOhhefUwyfQYG7VbHFVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759215813; c=relaxed/simple;
	bh=5ZE9NeVNN1gSdRrxLgDc9ovqLHNTzz98N7ulZ9iu5uQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sWzPxRMLn1it43U18Wd4jlpXiNrOPf9aIYjyNuhOqeBznIX+IboeN90znyx/mdqF6cL8Ait4fNRWgwqfwIAKt3WJK4TIhvW0g8U5jFj2osPtOjfPTo2ajx8OgmhGv/taaMWUxmLZP/dHVWup0r2qIxPl+CFT1mIUYxmt09EVwLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XAP/0DBr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hjP7kyul; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XAP/0DBr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hjP7kyul"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58U6e015030984;
	Tue, 30 Sep 2025 07:03:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2DPGLx0QURzTESxXd/bl4XulYFjQiEE6Zfk77URSMHs=; b=
	XAP/0DBrBPX5HkgoIarkpS9ZjZVhT6b94mWtMAW5PxKNdixcumMa8ZQJA19rVACy
	ik1/TnZdXHR+owvD27YdFALzVhxTPeBcaI81XeCHT3ueLQereZ68W9gsECnrOk/T
	SVX/g4HeXVfmcqpSqSxHy8N8yntYbvV5FeHa3+eesKT2p7mw3zXnKVjNySsJP2vk
	ZZ/x4RrwOwOAzn5ffV7UsDc2rPEWqKISH1hxAd1DNIfHrqTLIh0JvaAxQP5zvZfa
	FQSRFaruZbHC+3Vf+j3M63UlTs1c/dnjmK71TiFroKh0l/+lJQaIbDyq5nT6dhgy
	HRVic7hJrjgRbQPdOjagXA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ga4j81bs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 07:03:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58U5skWN002031;
	Tue, 30 Sep 2025 07:03:25 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012005.outbound.protection.outlook.com [40.107.209.5])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49e6cdxn0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 07:03:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NZfcUY8Z7LuWalXuGwDGwFa7IDvdxQixbo71KNGuTS+4YxGlTL7Ufskho4L4j6ui+ItJuXV8t0zl3P2SLCp4quS7iWSryF51y0KGKXOkm/tDAPwIzCCuqDZ52XF6WHL552rXnSWn+DANvT2NfYSdfzk8BPkUZGguPJmkmIRirMQwYj1pX+Xy1OskLhHC+VVKaxAuMOre1/4O8h+FXs/SIaRsziPULB2o+Ih5Vcu+2RKQYRtjqQRtnVuq/rx7tyZPwigZ1uwpd5wYMInsifwarJeZJpNKb/9c6OaUqeON6bdvP8LrmZxFX4lvjfpcC96jGrvaEo2rKAao/DhJjCtQtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DPGLx0QURzTESxXd/bl4XulYFjQiEE6Zfk77URSMHs=;
 b=NbZg8m41T6OnaXnz8JPxIrJ4J1co7UfiA3t0r00eR0adkUcvVumZuBbougXe6pnqeq1a+TXr44uUAwiN1D4VtT7ZszHsr5NpVj8A0NOB/6w43sG5bCha+Ey6KAt5AbY00e0Z/p/7fVL6reZBgkt1bp1YAGSEdA/Wda1gNRbi5EY2MLNBezHMW+HByAodLCJe5VhSPob/1Em9xfLyS4rW+aT2QedXNTZ+8YPeX4R25VcNRO4u+MxeYJNYagndYxzpulNQYiGmlW2fqa9MmDB2qGQFv3TC04/MgaHVtOLecsAnd2rE6is3mLpNgfmkkR27n2ZKjAKq4sChKgyvMTQouA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DPGLx0QURzTESxXd/bl4XulYFjQiEE6Zfk77URSMHs=;
 b=hjP7kyulQgPlZR+8uLxi9U2sqTkeLgAaSF0mWvCfINdeZF8KEv22jZzfuTlKwksHRoJVcJEYqw11HT8Td55pM1yXiuDrZ5nMJC4e2GY4EeYMgPeDyjMBUrKCV+etJny49L+/hl7Pj+AWIfmMuumTg7af2XWZxR2exhsT/c5xKIg=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA3PR10MB8019.namprd10.prod.outlook.com (2603:10b6:208:513::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Tue, 30 Sep
 2025 07:03:15 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 07:03:15 +0000
Message-ID: <b0bf30d3-d682-4a13-b157-b30b304ecf56@oracle.com>
Date: Tue, 30 Sep 2025 08:03:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/28] scsi_debug: Abort SCSI commands via
 .queue_reserved_command()
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-8-bvanassche@acm.org>
 <aea7f72a-7d65-4ab6-98c3-34abf112f6e1@oracle.com>
 <550f7c16-036c-409d-9f5e-0fb2a5b3baa9@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <550f7c16-036c-409d-9f5e-0fb2a5b3baa9@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0642.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::11) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA3PR10MB8019:EE_
X-MS-Office365-Filtering-Correlation-Id: 0727ff7e-6b5f-4a14-9d15-08ddffef6cfc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VWR5amJMSHVWVnFpMWFEc2hIY3J6TEgwRHFrMmZwOEd4MXN4eE5BZUcwQjRq?=
 =?utf-8?B?VEIxUFM3RGpKTEZ1NEtXaTNlVnhNeVQxTjBMZzluaE9kZWZsdmU3Ylo2bU9U?=
 =?utf-8?B?OGZrQXU0SmZDSjB0eGtNdlFwdEpVS1hjakw4b0pheEVBQnZ5QWw5NEkyYkVO?=
 =?utf-8?B?UXdnM0gyaGM0MHRTbHZ3WGFvZ3R6Y3ozaFA3RVc3Q0lxa0YyaDRudW93NGFO?=
 =?utf-8?B?bDlyakJ2MC9UU05kTmc1MnFacmk3cUErM0Y4cnI1SW9MejVreHY5MXNySDYx?=
 =?utf-8?B?ZFdpR2pveGxPUGpNdWhBeVordGhiSzhxbExZaTJ2MHpSUndhbVFnQ1ZJb25D?=
 =?utf-8?B?OElidVJBa09IV0U0MDdlYnQ0RXN0cGZxVGtxbHBaUndETjdVeTlWSFB6ZVRY?=
 =?utf-8?B?L0d2cjN1VTBuM25PTlFRTUZFUi81bmJFVkFROThRYmZRblRoVWFpcXZ1Qnhj?=
 =?utf-8?B?Z0JiclgvS1ZuR1hyQkJNblhielFqMTRSd1FqRFZXTUVjbFpjbkV2TmhlOXUx?=
 =?utf-8?B?c212UWtiSUFaUHpTY3E3RWoyeFJHaFJHSXYwdVR2N0s5akNDSzFsbTAzWnJn?=
 =?utf-8?B?NURGRUc0MkVQSGkrdENOZ1FGd2FiRHFMak80Uk5TQXNUTHcwTURtUUNMSzdq?=
 =?utf-8?B?SFh6blk5UXNlR1l2dXYvVE5RVFBubGxhYzFENEVnZmN2Zml3aVBPenppcGUx?=
 =?utf-8?B?VlpJMUR2NWNrU05VeWhuQXZSYzJtTUFEaFBXVTN5RE1xbkRjOHFUYmRvTWxy?=
 =?utf-8?B?L214Nks1ZkZncWczUHdVOC9aMkhOTEhzREZMRFNKUFFtd1dHUTVKcXg1cVZ5?=
 =?utf-8?B?eWZuOGtTODVFcWRYaWIybUZIUENLd0RsT01SYjBnT1E1RnR5QWZuN1hsb3NL?=
 =?utf-8?B?YzFkaHlOMCtLNDR4Snh4YURURTBURERQZnhXelpRVVZrWTkvM2Q3L2tYTHVj?=
 =?utf-8?B?dXFhNUxTdEJIRCtaTVZjNE1nTUpUY1BBT3k3d1NuYVNTMXJwd2FTTTZsREk1?=
 =?utf-8?B?N2x6dXE3bk9yTnp1VGQ1YTJTN1Q3T0dLWUFRQUg3c0FhM2hPL2FCcGtwMmMw?=
 =?utf-8?B?aC85c2JNT1IvbXhDYVlYYVBMYVM2MU8yRFV0UVNOb3pxWmRMV3A3d3oxb1RG?=
 =?utf-8?B?RGFyRFlYb3k2RitlVEJJMjQvK0lZbzE0Rkt0Ujc1cEVpUXFhNmJrYldHQklj?=
 =?utf-8?B?dVp5eCtab3ZrRGhVUWs4cDYxa3p6VHdqdFFONHRYTjZMb2tNWUpnQnU4Tmlt?=
 =?utf-8?B?NXNSVis0SkNyeUNFWHFNSDUrK1R6M3JJNFJSV0xKTStKOUVQaUFDYWRSUVVu?=
 =?utf-8?B?UVhYSWF4bFVNSkxCdzFvcUU5eEdxM0o2dHRXUms1QXNyWEtZYWVnNVpPbG5N?=
 =?utf-8?B?WHRKSVZmYWtISER3a2tTbGcwc2FKZFM0emx5M2hSYWNNNHV2L000K3BtWUIz?=
 =?utf-8?B?L0ZxSFgvUklpMWZseU80dk1QczU0K3hYdjA2a3BPU1F1VURjeWVPWTNNYUtu?=
 =?utf-8?B?bUF1SDNoVDg2d3ZTVjF1c1h3bmdXY1B5OFRnNDNrTUNISzJocTNiSkQ0bmxE?=
 =?utf-8?B?MlJWQ0tuK0NlV2x0dzNMTFc0eW1hYnlVcjgzVk1UTHY3cGpRY3BWQ1MweXQ4?=
 =?utf-8?B?OXNBbGZSdUNVaUQ0SUhwNjR5RnRjK0Qya1RSK0xpUTEyMHNlTVJWMlpWdG1i?=
 =?utf-8?B?aTFaSnNVMXJiZ2lRSmdZNnd4eHBVbXpLTWdPeXFoeElNRXpMdmJBNlV5L2Vh?=
 =?utf-8?B?K2Q2Z3FuNC9QeTJpQWl5WEd0eXJac3VCK2ozcXR1UXV1dGtPQmNOSjN3bkNL?=
 =?utf-8?B?RzB5VnFKMEZaZS9ZOStPQ1NxR3Rqb2x4aHpxV2s1dWVLTGV5cmlSWjBvc3JP?=
 =?utf-8?B?d3VuL1IxMFBWRGk1MkFGNGthbE53d2xQUVFBZkxGNmdkUU14cHNsY09hN2M0?=
 =?utf-8?B?OXdMa1VCQ0tWZm5pSmhsVnNHcWNYRlc3OHphK0xmcUJTUE51K3lyUVZCZDZB?=
 =?utf-8?B?RFRLMzBPeFBRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVVKd2xZOFdDb1FsQ2tuSXdtakI3THZBb1FtM1QwNngwN1lHbGgwRndWT1Zr?=
 =?utf-8?B?alN1L3VqTU15b0NJemJnRXVPLzh3dkluT21nYUgwOFRHQ1ZGVEtPSEJNaFFN?=
 =?utf-8?B?VyswVm5BR1Rva1p5Q29ZdTZSREtpMUUzSHlKeVBiLzVjeXZmUDBXTW5zSlRj?=
 =?utf-8?B?QVJ1WHF1MSt3cEJCU09EeU5aOTI0WkREcGVBaW5rb0RkcU10a3o5OUR3eTVD?=
 =?utf-8?B?WVZqVDJnU0p3MjRIZ1FmdkYrUUEyVXpLd0dpbUVNdlpMbFVGTmhTT1YvTHF4?=
 =?utf-8?B?MWQwVjdrblJDWTMvWlMwSFYxeS9rQ3Y2UGU5bXJJaEh1SVQ3ODNxZDZZSlNw?=
 =?utf-8?B?QXlMeHo3VUlPaFovNStUQ1J1RFBWS0dJTU03UXhGQUdxb0VhdTlieXAxTEdx?=
 =?utf-8?B?TEZPN01yQmkyWm5ldDZVT3lWRUFTVFcrQy9TYWtYR0RIN2hSZ2VLVWtKRE1O?=
 =?utf-8?B?RVI1emcxRUtkUEZxNjc1MmpnT1R6MUZURnNxM3A3UU5OT0I4dzRTSFhpTC9h?=
 =?utf-8?B?dStSQ0xwOVk3OTd6enh4U0xvNyswdks4dUJwR2hhNGNCMFRSTGdKZ1J2bzJS?=
 =?utf-8?B?UmJLUlRsam90YUVzMjB1TGNUckxvb0xITGF0NEMvaUhvNVRJaVBGUFJ5b0VP?=
 =?utf-8?B?RE0zMHFlaWxwWXFVZTN1U2tSNmVGQnU0Q3dCbEl5Q00vOFhHOEkzOFdkRXUy?=
 =?utf-8?B?VmNDWGdwS0l1SmtBeTJSVDB2d0NHaXBNWUtBN2VnRXQ3UGJxcm5lWjliOEtR?=
 =?utf-8?B?eVgzcjVrNUhDRWV1L1dKVDdheGV2ME1kbHFNNXF1QUt3Ym1YV0xOQnFtTHpX?=
 =?utf-8?B?RXBXOFZDVDNOZUg5YUVwZ3NDNWk5WnlJdllYUEFObWJ3THoweXpEZVdFWE1Q?=
 =?utf-8?B?VnR4Y2pBSEVjNHg4MWFFcTZLQ1VMb0tCMDlVcUkyUnlOaFlieWZWeHQ3TFBz?=
 =?utf-8?B?UDNOYjJ0ZDZBUW1YcDFSRU9qUndabHN6R3VrOFNSMnAxWExnL0JXWkFDZ2Zn?=
 =?utf-8?B?VTNEREFkV1JvNy9CRDhoU0Y4TGFyMyttTXpEbFVHR2UzNVA3Sno0eHJPU2hI?=
 =?utf-8?B?RXovak5XalVmSTBnNkVlVG03Z21TZlBtQzFFZHRZb0dOMnZWRnMyYzBwTmph?=
 =?utf-8?B?NUhIK0laVnp5MWYxb3J0R21EWnRlVE9SUzhOdVVUN3I3VkhVZ09yRTJjdzNs?=
 =?utf-8?B?aHU0SDRsR1dzRHpCeHgzT0ZiWGlaZmJIVkg3bmswWTIwVHh3ZWJvTVpnKzFU?=
 =?utf-8?B?T1ltL04rTTgxQ21vY3JCYnYvbklBZWVEbS9vcU9pZzluMWRxQnBYa1o5d3VW?=
 =?utf-8?B?RXBqYk9TUVMvSjYzVnpNbnJFVnRKbzlVRFord3duVlFNQnVuVEs5Z1Fhbm9B?=
 =?utf-8?B?K3o0ZjF0cFBzWXIram1QWWZKYkgvanJrdDAxUGl4K3BNdFBwVkJLNGIxamU3?=
 =?utf-8?B?WjBWV2JvQzM0RGwwVjRKUVduR0V4SjNDMGVpalZvdnhvTjd5QUxPcDRHNnQz?=
 =?utf-8?B?QTM2cS9ERy9VbUloVEdRcWJUMnRiR214NHdLSTZteTJDbWg4eFBHOVFYNy94?=
 =?utf-8?B?cjZZWXVXQitiNTMrdkppbWU1bDlZS0cyTGlyVWJzbU1TN1FlelVLMkdhUlRK?=
 =?utf-8?B?RXlJSVYwMmkyd1J4d3hKOEtYMFFYMjh3SVZYRUJaMmZhamdjMGsweENnSkVP?=
 =?utf-8?B?RXFJSmtSa2JWY0VpZGJmUXpSWHB0SlhMSllJYzFHeHo3WFVaZFptZXVITnVB?=
 =?utf-8?B?K3d1VUpKLzJQNitZMFdGTXdvMTNMTlo3TnBGRVluN3dWMXBGVlRnSm5HRUhQ?=
 =?utf-8?B?NCt3WnBUSlcwUm1teVc1cXJsSWtkTzAyK0ZFQkVmM0gvM2R3WjdtQkxtMTlQ?=
 =?utf-8?B?RGdPSGFYVlVxeXpnb3R5M1RqMWlGUm0xYlRPdXc3azN6cXNzMjQ0eGZMcWRo?=
 =?utf-8?B?WHlCTGhxa0k0NmRrdHQ1RFZNdGdrWUY2MnpjRDFlNnB5OERxeHU3YjNtc1Qz?=
 =?utf-8?B?dGpIRFFGek52S3BiWHpSbkJLZUZxODAxb3J1bG1QRUZva1FVTEs4bFg5TXNa?=
 =?utf-8?B?bHBQM0NXOWk2TzlhYkkwbnB1QWxrNHhHVjEzQktib215N0h2SGQ4a3BuYTNK?=
 =?utf-8?B?RGppRTRkRUxtZmg1d3Y2dHovVWZOK3RPL3VsR0p3MFNrOUtuV0Eza2tIcEVr?=
 =?utf-8?B?Z1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/jcD9yjf1gXEM5LQsyPsakk66sy38GTfYLEhdb/4HAaO2Alua40doG5ogNsMrvGIeZ1vJB2UwBzx2krOd9DlR6bdADXaHpqox1BGBnxjdsmtm321MN2V1EZShk4NPqDeWwDmuT8f5LiqgFurN3jiIhq1e+1hVV1nqKPd63/zgKUlBwuOLeZdhTvSEYdkpF/Uh0Zj4x6ZGxXyvywPz6U6xa5lskHQqBRcQj3wad9IAvFtXu+MLY+y5FRmehryBmmQCypWGN7HNoiFcuPNRfnvneFGxqEB1UgCwDxO7jrJB2nJf5oO3tku4v7g4VVtXoHhRkd/XodCYITHhNpnmwaC8D48FVsUTT6k2PkaA2XS4TCAO7twxoygk99B5dTrNoYSNUks7L2Kr/+8EAcuOrHScL2hLTY/uYPML0tjFWjWBGwH3lP53t9VSx3hdy757vrY2RotD0825/aUu0YmGDnVCBN3MxBriyDXFyfnCCsMjDiKWaHvmGcjH75uhq+rL4NTuVgN7hU6unClWRjeIRuGFnDFIOMEMJIaeBMRhjd+WcjkmBufNN7+g/tmsYHsekMQQ4BNGFqhM/uWA1lMQqZY94aQL/ZoanVdlqYyMusGE0I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0727ff7e-6b5f-4a14-9d15-08ddffef6cfc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 07:03:15.4173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /qtUtI5SWG0DZ2nU9RBO32vp5jfcrxS2AtSYyCbYC8yzFOQP7M8W48MWGYZqaOlW1bJ4EArWJeypaKNGyX1J1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8019
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-30_01,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300063
X-Proofpoint-GUID: DMn8zIdEm2bkHIRF4VakkWVpEKiTtjMn
X-Authority-Analysis: v=2.4 cv=dZWNHHXe c=1 sm=1 tr=0 ts=68db80bd b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=N54-gffFAAAA:8
 a=yPCof4ZbAAAA:8 a=vMw3FoLWZTTWJKjd9qQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12089
X-Proofpoint-ORIG-GUID: DMn8zIdEm2bkHIRF4VakkWVpEKiTtjMn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDA1OSBTYWx0ZWRfXztU4VuU1molm
 bc4qh1nHG5pgWCV0/lN5WO+fnMUwODbDuYUdURzBCkQloXc6NmnFILXXg7uYqEd/tuNl49j5M+U
 PwYVVlCM1AqYuI9RHOEtTQf1yDFLCYrEdgMgKAqRuyoc4JZfVz+vdjBmHahBaBB1M8UZ1Oz2gwP
 +fsDJufg3kuH9Lst2bLCWppqtOvptrLu0/l2zVSVdgW9hpt222SViVh/Y8WPlN5wqggjiKdGAxn
 dAfLncz2wMUjdhYV1VsKW5LbqclmJNLK+w5PPEpEwAKjXDHoldxx4B9OHBEPBp73Fmtr17Z+wxI
 ZepFdQSlL8LVh5Zgmr++qDGCjEouaMCKx6y3fd5dZolfl3unOWWBtYas6DGvBjphjg1mYI3HqaH
 og+Nc0cuGs4qCgzJ9E/7Xc/jkNJVVwNMAxd3A3NXZTwMn0inWyA=

On 26/09/2025 21:44, Bart Van Assche wrote:
> On 9/26/25 12:32 AM, John Garry wrote:
>> On 24/09/2025 21:30, Bart Van Assche wrote:
>>> Add a .queue_reserved_command() implementation and call it from the code
>>> path that aborts SCSI commands. This ensures that the code for
>>> allocating a pseudo SCSI device and also the code for processing
>>> reserved commands gets triggered while running blktests.
>>>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>
>> At least Suggested-by would be good, if you don't mind
> 
> If nobody objects I will add the following text:
> 
> ----------------------------------------------------------------------
> Most of the code in this patch is a modified version of code from John
> Garry. See also
> https://lore.kernel.org/linux- 
> scsi/75018e17-4dea-4e1b-8c92-7a224a1e13b9@oracle.com/
> 
> Suggested-by: John Garry <john.g.garry@oracle.com>
> ----------------------------------------------------------------------

fine, thanks

> 
>>>   enum sdeb_defer_type {SDEB_DEFER_NONE = 0, SDEB_DEFER_HRT = 1,
>>>                 SDEB_DEFER_WQ = 2, SDEB_DEFER_POLL = 3};
>>> @@ -466,6 +483,8 @@ struct sdebug_defer {
>>>   struct sdebug_scsi_cmd {
>>>       spinlock_t   lock;
>>>       struct sdebug_defer sd_dp;
>>> +
>>> +    struct scsi_debug_internal_cmd internal_cmd;
>>
>> you could prob make this a union with sd_dp - I mean, could they ever 
>> both be simultaneously used?
> 
> Introducing a union for sd_dp and internal_cmd only would suggest to
> readers of the scsi_debug code that 'lock' protects both 'sd_dp' and
> 'internal_cmd', which is not the case. I propose to include the
> following change in this patch:
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 0d4bdd38597a..12b885a2f719 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -483,8 +483,6 @@ struct sdebug_defer {
>   struct sdebug_scsi_cmd {
>       spinlock_t   lock;
>       struct sdebug_defer sd_dp;
> -
> -    struct scsi_debug_internal_cmd internal_cmd;
>   };
> 
>   static atomic_t sdebug_cmnd_count;   /* number of incoming commands */
> @@ -9518,7 +9516,8 @@ static const struct scsi_host_template 
> sdebug_driver_template = {
>       .module =        THIS_MODULE,
>       .skip_settle_delay =    1,
>       .track_queue_depth =    1,
> -    .cmd_size = sizeof(struct sdebug_scsi_cmd),
> +    .cmd_size = sizeof(union { struct sdebug_scsi_cmd c;
> +                   struct scsi_debug_internal_cmd ic; }),

ok, but you could also introduce a new structure which defines this 
union. That's looks a little bit better.

>       .init_cmd_priv = sdebug_init_cmd_priv,
>       .target_alloc =        sdebug_target_alloc,
>       .target_destroy =    sdebug_target_destroy,
> 
>>> +static int scsi_debug_setup_abort_cmd(struct scsi_cmnd *cmd,
>>
>> nobody checks the return value
> 
> Agreed. I will change the return type from 'int' into 'void'.
> 
>>> +    abort_cmd = scsi_get_internal_cmd(shost->pseudo_sdev, 
>>> DMA_TO_DEVICE,
>>
>> DMA_NONE?
> 
> DMA_TO_DEVICE is converted into REQ_OP_DRV_OUT by 
> scsi_get_internal_cmd(). Isn't that more appropriate for an operation
> that has side effects (aborting a SCSI command) rather than
> REQ_OP_DRV_IN?

but it it make a difference if we use REQ_OP_DRV_OUT or REQ_OP_DRV_IN? 
If not, then I think DMA_NONE makes more sense.

Thanks,
John
