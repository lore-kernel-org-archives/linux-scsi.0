Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A756D35A94D
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 16:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763654851; cv=fail; b=b61AEd5sHjvaRIXG//Uf8trgljuxCVPJLailgHnB5WS37bAuP3CYRxe/T0F6cyQPQsoHyoTYfacykxtZYve+mXNlW5ohz584kQqtic0VTHtNAtz8sHPtcjh0ywC3uDjdzWYaYgDYTVQ3xrauyKg32MSzjpQVHnbC70WY9rSSrSI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763654851; c=relaxed/simple;
	bh=XVnBp/rfb7D+QFtqAS7BhXXIN3J58bk7wPqFpIoajJE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cDoQzA8sT03bcCK3dBg/5t7RNQtcP1HlAVhZ7tvmvGTL/38TwgZxK1g1GzYEWWHG6sZTOLcQ4nrGR7YA0M5JTe8E77p7z37s6DJtJH4f/wi+k0J3NTGBY6yTP33suPF5TMB7Xb6JILm9FFZUAcEAHPm2E/pq6K1VWs1S+YjvNl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oMHDVoFM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AJlkJJRl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oMHDVoFM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AJlkJJRl"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKFU4Ep009035;
	Thu, 20 Nov 2025 16:07:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vsvkkoR5vBMBIwgG6BSEi/DsOG9IA7Qst//PmKx1jsU=; b=
	oMHDVoFMKos+duABsnIDf+D6NsnNlUKWUVDUouUDfm026Bd0kSRIDzSEtk+xCsxu
	YEuNPtlum+gAChWsbDAOq5Asw7RS6/yRxR7IviJmo72/dxpwVtFHv196IlkvpQiE
	KrKHpvPFSeYbQNg7Zol9SbOvuQIbadF8QlnRzR85lA1OIkRnNBK1VpoJ5RoNGPpH
	kWElko3LCPUHkJ0FHvyCByD0zmoaujwVI4YwZdOKCx3zxkjDIH+wEl/UJa8n6cRo
	ZY3MAel8ZsGU66YxCwhrXm1j475fZgl1MP4dE18wJrTymp40j2nC0ixdWLfmaeaf
	wEJPehmtpbZRN+iUBga1SQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej969dc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 16:07:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKF0ikh009679;
	Thu, 20 Nov 2025 16:07:20 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4aefygc958-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 16:07:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pVWFVsMSOakH5782eejcf+LYnU8yKyjNXi8G5XpnoDotKkJc4ClOkNYdhPOd67bSw4ngJIvF4y8Xk3UbCnoNOJfdsmSO9pWQLusFcaGIul7FjCXvPPLebL1GTjfEfOVY1unuh6V2j81mj6fzMEYHrlqxRVR2OfFhdMqUw/QBk/atnss3OlHrvgqrJXc6mksMFEn/nEUy06xiYSykiXNluk1tGyS4xIDwR/0cdL4lkCguWR10O1iivfZpJG34Mt9g5LeLsQyq1+aWkekkpleBA5oZzEyUA2tYC7i4ec+5UKVT7XJcBOKArbBhvSLsy06vPlhYBiCLiCMPPiVD3nlbow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vsvkkoR5vBMBIwgG6BSEi/DsOG9IA7Qst//PmKx1jsU=;
 b=eF3hmHcubcHO5eNS/nHBhu68r2v3ZGhwa92hTNyqmZ8/e6bpxff1tmawwk2OjE7A1c3yCjob3007GZSof6bhvI62upgEVjRdlZmnQvW9Lion7KK3OvV1UAfWXtN1oWBZdYiw6LkM81ZtBiamw5q4YK/v18YGWXMzRMtShxI4u+xBOoOMGZOH7gP5ur7TnpQk/ZkwFYf4S5XFo/AcpVlHpap6aS1LAazeqjlf+xGrAsQu8q++cZqBbQSGHbgn7yfW+Gm4tz1vEgoWwwPYJhnGoCfdNAoU4dfM52FgmQR0ZUkaS7mJs9mzK5PN3aLCMI3/Wqtd6FJd6tRfkMAQ3fFGlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vsvkkoR5vBMBIwgG6BSEi/DsOG9IA7Qst//PmKx1jsU=;
 b=AJlkJJRldhkBo+vXc5eQyb52psShlrnA2usE+Hr+MLOKU9uC9bGPfSAh4eIZsKZQq4RTN26U83Fyes06AQuRXZAvNaSE+hB8yRnALGj56sfqKBYkS6jBrl1P0ElE+ld3hmX2xfyRgUUgxix/UTjShACFEvhJ3yv9GCjvZH7aWTY=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH3PR10MB7163.namprd10.prod.outlook.com (2603:10b6:610:127::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 20 Nov
 2025 16:07:17 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 16:07:17 +0000
Message-ID: <4728a1b9-7282-4cd3-8a36-5d8f19bd1cc0@oracle.com>
Date: Thu, 20 Nov 2025 16:07:15 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: sd: Rounddown host->opt_sectors to logical
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Lukas Herbolt <lukas@herbolt.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
References: <20251114102853.1476938-2-lukas@herbolt.com>
 <20251114102853.1476938-4-lukas@herbolt.com>
 <yq1ecpt9yqb.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <yq1ecpt9yqb.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0256.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b5::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH3PR10MB7163:EE_
X-MS-Office365-Filtering-Correlation-Id: 44198eae-3252-43bc-d84c-08de284ee096
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TC9hZ214eElCcVdId3ZWS25KNC9RbWlscjBKWjdSdTNtRkYxSkMveTc5TW1s?=
 =?utf-8?B?c0pzc1ZzZUVGSldDV0JpMVpVR01ONGNyOHRLTks3Z01mY1VHdEp1RkkzbHFt?=
 =?utf-8?B?MEZqSEV0QUg5MjhxWGw5aG1NZjZJNlY1YmRiREh5alRpbXNlcFdPOGJIRXdu?=
 =?utf-8?B?UnYySUZkRWxzcnRwcVN4VktYenBLc0tHdGdKMjJMb29XZFBwSTd0MkliWVo2?=
 =?utf-8?B?anZoOC9yQ1FPaTZOOUVJa1diK0xhNGxmbm04cTI3QmFIUHc1TlhmcWJKSmYz?=
 =?utf-8?B?TC9pbDRUcmFiMDFlRndubFlEclNoVWd2RXNqakFOQlc1U2ZFdVpPQnhtU2E1?=
 =?utf-8?B?OTZObWpsTWZCM2JFK3dOZjhHSmRUaC9DekFRNHRJM0FBUHlDWW5YOGNERVJU?=
 =?utf-8?B?Qm5ISXJTelFtWVdPM0xnZjMvd0J4ZEhCeHlTanppdFAyaFZKRWQ0OFF6UUVy?=
 =?utf-8?B?NmNVQzZ6TmdqaFVQTzdoQ0ltT3h3YmVNQXVWblNRVG5JL0dkd3Qvdkx1bSs3?=
 =?utf-8?B?b1hqdTFLRE10RmtHZTNFM0xHNis0ZUpITDluUCtpZmkxa0NiMDB2a2RVZXIx?=
 =?utf-8?B?NjVrUUk3b05nSUpyVC9BS3gwalFDZ2xrUU5ON2hqV3h3VmVsV2VLNXZlNWZs?=
 =?utf-8?B?TE53ZXJJZWFQZ1ZXSXp6VGMzVnIzWXR5VG1welZuVGZ5Z1JuMjNRanRzLytP?=
 =?utf-8?B?VXEwbHBPc29PZzd0cDlTSng1R2dlUS8rMUF5OVVwSWluVENrdFlmaUdhMENy?=
 =?utf-8?B?NldmbDlXWkhEV2lQK0JXRk5tSExKdCtSdmU0U0cwbzBaSVo5ZGYzejA1M3ow?=
 =?utf-8?B?Z2dNcTUyTy82VDRnMVVPZ1RnejArbTBJZVR5OUYraGpMbUtHbUFoMWNaenFP?=
 =?utf-8?B?UjV4RFIvV09pMlRPUktxLzFpMS8veVpQZXlYdEtTOGlQdkVzdmhHUDZLd1g1?=
 =?utf-8?B?WnRrWnpCZVB3R0N5dXZUd2NTMkt5SnNjQ3VLWWQ0cEZ2aTJJQ3lGQUIvdm9x?=
 =?utf-8?B?N3dFQis4dm0rTTFORVN3dVZmUFovWVQxMU4rUnMvd001RHBFYnQyQi9qaVRo?=
 =?utf-8?B?MmNBbmJvdGVUaGtUZWpHekZTTnNoUSs2K3lnSUxCTjVvRFFySXgyTExmV3R6?=
 =?utf-8?B?aW9Jd1d6L05TMWM0aDZnYjc2ZTRtSForZlJtZFJVUVQrcXZnK2VHMmxlZ3Vx?=
 =?utf-8?B?WVBrZ2VYOXFNNm4xSmRiVTJjOUp5RXRja0k0Ym50Y283YlVWbGpVTHNQNWtO?=
 =?utf-8?B?M2U3Z2s5b3I2ZUZicTk3bDFxUTRrWVVIMEU0cmFPNS9CYUxvdVVpVXZCSTNs?=
 =?utf-8?B?OHBsMG1hbEN6Z29RZlU5TzM0VUUwR25PQVJqN2JrS25jTDIzRkg3czg4dWk4?=
 =?utf-8?B?U1Y1dHQ4VUYwR1dvVEdNZlZNT1hrS3k2U2VCbzZZM2ZUaHFhR2VRekpuVUFX?=
 =?utf-8?B?YUdUS01vaEptWjJCeW9DdGdraGJaVHp2WDN5WHNoQW9XMEtESDFQU1diSGdv?=
 =?utf-8?B?MkpDbnBLU3h1cThicEkvSjJoOWs5bjVKZWRzZDZ2eStBZnVHZ3V5dHhNRFZ4?=
 =?utf-8?B?YmliQlpGZ1hSWHdJM2pTNUFSNGpkcFlad2FEK2lBeFdGeG44WmQ0NFJZQW1q?=
 =?utf-8?B?Mi9QekN1eFJrcm1GYzBoZnZkWTVnVzRCYUdRM3Zoc3Y0bHE5ajhlaFJHeGFj?=
 =?utf-8?B?bU5qaEl5RUMyWDk0czBPbWxCM1ozQjRFQTE0RVZUQzhTVllqNmtiMGRFeVNi?=
 =?utf-8?B?ODlzUTdPaDVUblpWRUM4cmtZWmlJTm12VzlnZ1FtRmkwd21mRml4SGZ4Y0lM?=
 =?utf-8?B?QUhTSkZyT3pOQ0dmaUhkK0dqU3Q3Y2dkSkVEd25ScnNyTHhPUWdXV1FNcElG?=
 =?utf-8?B?MFpzd3ZXeW85aElyQVhFSU9tSVBXQUpCVFlkL1N0NGZPMGR6eU9BSk9wNHg3?=
 =?utf-8?Q?0IbnPS1XzkFzidEFZlByGcKqSWQMcFZM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkE4MEJzTWc5TFF1cVY2cnBzdEo4Zk4vRm5uRy9EVCs4clIzZ3A1QW5LNXo5?=
 =?utf-8?B?akJGZHRoT1BFd3RmbnVDZzF1bmRoT0FxbFE1clB4cnY1OGJ2T0lYQitwTzk0?=
 =?utf-8?B?STJVV28yaFdRUkEySm1KRGJFMis2N1hUK1M2ck9vTlFySlpBOXlFeHJzbFh4?=
 =?utf-8?B?S3lyeUZPOTlEQ3d0dHN0WHhieDIzMmRmdzdVY0Z5M2Evc2pnYnZSZmwrTktP?=
 =?utf-8?B?aU1TZEFObVFUcUdmNlJqUG4yNjI2QlRPalJWTHM3RWlVY1FyYWJLTTk3eERj?=
 =?utf-8?B?OTRvT2JWY0F3Y1FQTjdqeC94b3RpRHFlOTNjeCtFUTFwVVc5L04yM2U5VjRi?=
 =?utf-8?B?alZRdkdyVDhFTU5hZVpqWU1adHdodThOMUtCWndXOEdnRHhnOU8yU2JtRi9u?=
 =?utf-8?B?SHgrTUJMVFlqNVR1OEVVNHlCdzF1d2JkT1FWbTN6Sk8vZzZ3ZURXMHFxQXND?=
 =?utf-8?B?RkxJS0xEY1lYdXlZd01qMDdiK3pmNzZHOFNyTVpPa3RraTUrTEU3QWs3UTcz?=
 =?utf-8?B?a0xVcy9kR3VBUTl3TmFzQUlhUi8xak84STcvTnBvK2J0S0lTbGF2Vm4xTWEy?=
 =?utf-8?B?eFpodXUxbUVUM0pJWHp5NHBYSGJBUzR6bzBHdExwcVFqamZjMGRxSmJLcmln?=
 =?utf-8?B?M3c5TVVrSUltbm9lVFBGYm1kUEVOc3NzK05LTzBmY0VXclY3aWVmY0FyV0oy?=
 =?utf-8?B?SE45aFRaQlA0S3M2RUROQTVJa0F0Nkx5OWVlWHBtSGNuYlJ1bEpWUmNPUWtU?=
 =?utf-8?B?Kzc5S2VTUktoRGVUL0syeGEzQjErMzFNTE56VTBRcEVISHpEejVHbWI0K3ls?=
 =?utf-8?B?R0pJOFNDSnh4UG55bG1lYStjU0IzK2VvVm9UYkpBanVRLzhnaWV4M25jbGcy?=
 =?utf-8?B?QjR1dG5XSUJhUG9zbm1vcEl3bjd3T2x2Tk54WEJOV1V2Zm8xcmhFQWI3SzZ5?=
 =?utf-8?B?a2FGbWJNTEV0NURDL0tselA3K0pxQWlnT1JnZW5qOC8xb3RSSXRLZEdjWERj?=
 =?utf-8?B?MEswYXhKZm5CbEptNFZZMGlhbktIYkQrRGtsM3MwZFVCaXhzUmNTZWdmZTdW?=
 =?utf-8?B?TnpVQnIyR0Q5cTBWSWVCUjVuVzNqU1ZnMmQwMjhQYVJCeEROSExXc3VhaDBC?=
 =?utf-8?B?RGNRR0V4alJGY2QrSFBMcXpPc0FpS0VCaUE3WmhWVFlwYjh5N3JtYU9BS0ty?=
 =?utf-8?B?VGdqb0tTbmg1bkZoZWZ3bTJ6dUFERWxPSjdWeWNQRXRaTnh0UDZqeDBBU0Ey?=
 =?utf-8?B?MGl4Q0RBVzcrbm8ydlRZR0NBSWhUSktQTWlVcEtZcGMzdkx4TWNWQTQzcERi?=
 =?utf-8?B?dEVEbXQwRjc4YVlYcnV3QXNtZzNiWTE2VmczRFpFY0RzcU9OaEhWSUJUTWxF?=
 =?utf-8?B?dWt1bWpndGtuSDNteGJXVStTTzlxUEFOQnFQU2YxRzBhS3BoKzBxRkpqL2M5?=
 =?utf-8?B?SVowODBiM3dxZStCSUo1Wk44SjFnYlBOUFVtcm81QWk2aThtSWFpOXRabFNs?=
 =?utf-8?B?OVF5dG9weVZrc0RJNHJOWVBzWGRKOWFubzdzaE12SktTaW10OSttSEFkSUR4?=
 =?utf-8?B?YjNqRTVjM1hhMlNkK3Ewbi9nelErRlp0dnM4RFQyOVQ2dWNMSTEyS0Z5dzI4?=
 =?utf-8?B?cHg5aCtRNWlhaHN0WGpTZnpRbHRRVldpbWFWRTNRekx0bTJpNlRGZ2xMQ1pT?=
 =?utf-8?B?QVR4VkV1dmJkbVBxQ1NYSEpLbmpMc0t2eDJ5MjcvaEN1UFRidkI3ckxTdUhK?=
 =?utf-8?B?SFlIKytCcGdGN1FweWhyUHMwT3NVbnZDdms3ZDg0U3lWTVFzclhEN2phc0F1?=
 =?utf-8?B?TlNyUSsxcTlRemNZOTRIOEdjRjVPNXVyMWJkQzhsSTYyUUJGUEhhQndkNzQv?=
 =?utf-8?B?WTM4S2kwNWo5V2JCeHVodCttbmkzaC9nUlYrRmtNOEtPUnQ0UXNHNmt0S0RT?=
 =?utf-8?B?L1JvYkxOOFB6MDdYZUJxQjNSTjhoWE1EQUVZL3E5VkN6ZWxLSk10a1QwKzcy?=
 =?utf-8?B?WTYzWWptT0h3NzcvSG5GTEFoOFNhdDdlT0RFWTlLTHRBcm16NmQ0WHNsejZS?=
 =?utf-8?B?RjNTSDBBMFVlY0wwSi9IemwraTNGZURLejBVeUJHVEdaSElRdWt6VEtyNnJM?=
 =?utf-8?B?RzNCYVk2dzFlU3Z5azcyYUdWMndVMzIzdDlnZEU5dUJFV28rc3NucW1DOUo4?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5MjpjkNFfT10yAhQaqIS3zeCay4kcMF839RS3twlI3J9Al3OqZVG+NwAX988j8XmjBl2KfCCwzHhVvxxBITR5YNOKfkqVtlTBXu7dJlc+xzC9rdIXxFfo0yX74gQLGv4AGg7zhPVQPaXxR9WhAgY20BE9devkP5VYzhye5td6JQ5oHi0vtHlUDZbS5wYE/8394HCDDwyJ+ZkfyUtclidp60IvzIfGDLMamwFT7IIJ+5cNePohZ25puX1eaqBwby9I7XHT6iQ5v0/u15XYEOVmeRCs7nevZmGkT5jNzpEzXGJ4CHUgu2G3KLmZrYsigQgKQisqsfWx7ynPzML1qD+QTRrDUmsmHNlF0gSX9f1IV7tsGb7ORzaUkMQvLCbXOig2xMh1kOHicDP0S0M+IHKnnY7AmKB6XW0j3o7VPNMVb9hWFbYxrNzBIrHHA9uTN29x7ZYwULE7PteDEBJ/PNeIgSAF97orWH35hJp8dMDE8oZWFXufh8lIOMaAoS+3V/c7JuPwfkasOGmMP5qpO2sC1lsNJOB6fz60HTUFhK27lETwhwWY+EJO65H1Jazf6JcLfmM/MCZc0XoNkOMreF8nr3o+8cIzELYj6GV0GVGezI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44198eae-3252-43bc-d84c-08de284ee096
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 16:07:17.6686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o0CcyPq/zKuyGSfPSmw9F7i2d368eT7m945G51Ad1FiZvjsbcpU8HlFZDnz8Nf7k4FT5Ptsuk57MlV594P9BNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7163
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_06,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200106
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691f3cb9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=eRFgok0XRtLs4EvSPGIA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13642
X-Proofpoint-GUID: A2T82I6OLQrN6VbcyNrNnZFAvdCPuI1s
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX1zMrWMAUa++q
 iOaGBEsnD/Xu+zOj48E7S7scvzyUBrVOKhJHkLSDhOpqQdN+d3U3QvI20kxaENxs9tgVeyIopT5
 Q+TalqGZFC1gI/Wu3bSHsZM5CXKkRBIpZp20D+zs7rSxUlcZWPH6wnXswiMB+FK+W7tKPU8JETi
 idzsMsZm11ej24H0Hcl16JNzeC9GmAE1fRK7m5P/ZbrD3zCIZ26qzZ7lpDpT6YgO6iN8jCmwA1/
 epuaLTcLmGgIThBMR7E8Uh7fvHiyZ7JrbTxj3my0Zibug+ZXdqX3LFrNm407dNMTleeJFng0Aga
 JgUTbXC0hLivlD6aRBehiqa0Z769j8zKYwcVxPt2dUnLy5u3A+YzitJ/4O+dzh1m/m0xcGVNiwE
 EsEgcC0/LmOqIbOQ+fOQZi3QA2Dzk12wdT1YoZ6CDLWZcd6r7Y8=
X-Proofpoint-ORIG-GUID: A2T82I6OLQrN6VbcyNrNnZFAvdCPuI1s

On 20/11/2025 03:26, Martin K. Petersen wrote:
> 
> Lukas,
> 
>> The host->opt_sectors are by default 512 bytes aligned if we have 4KN
>> SAS disk reporting zero or smaller opt_xfer_block than the
>> host->opt_sectors we will end up with unaligned queue_limit->io_opt.
> 
> I am intrigued wrt. which controller returns a host->opt_sectors that
> would trigger this misalignment. What is the actual value reported?
> 
>> +	lim.io_opt = rounddown(lim.logical_block_size,
>> +			sdp->host->opt_sectors << SECTOR_SHIFT);
> 
> Those parameters would need to be reversed, I think. You want to round
> down opt_sectors and not the logical_block_size.
> 

In blk_validate_limits(), we already round down lim.io_opt to physical 
block size, and physical block size >= logical block size (so this extra 
rounding down should not be required). What am I missing?
