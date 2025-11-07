Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECE125D216
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2025 10:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762509934; cv=fail; b=Y+B6bbUwosUuO68sKOL9ILgRN4pqVQAVQzyFgXZHj8lws+yYXLji2auBhjPzGBCqWh6mSHfUiWqmeumZK4uBr7shOh66lptXBTKTHhbkgnZUoP+zOFleN9MVqBnLV4+VpG7QkxkvrwAjvqGrIaJqQId/SX5rZQghxGSUHkOuQbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762509934; c=relaxed/simple;
	bh=3zswaFNre+1ix0zNdsHTXBcQG5jm8/4HvfmPYJQigiQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NXDXAh9qUn36zAyJAvyh+IC17K+ytnrj/6+UfYa8qm3nxV5JgTieELEzAniJo9hR/S+AzYz+G2XCwNsbO+wVO85cn/ZZh/7X1j2YEAQDLyP0Tqza/F1ERAbkRYsqGIIlKatCXVeaNfDiYOIab4aBlM+MB8rvbO0XqqT3MD6l3FA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OOxEQwXJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jn8SkHut; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OOxEQwXJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jn8SkHut"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A78uYOI008483;
	Fri, 7 Nov 2025 10:05:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=faNnnGiF/rPARANV7FRdRQU+F6MNd62SaoVR6y1nV5I=; b=
	OOxEQwXJs+hz5b4p1PNL1+Sr8XgUSMzOXyDLmUaG8hE0kMcJDtaqQ3ViTlQh668Y
	PjwUmVHBEjyc093TkFnQmMPzAsKn6ASEwyR+xdD6NLwJnK1Kd9JevEhgkueyoFeU
	soKrKSCYtU4dBmo1JHtGQImxeDcVkirKqUHDrczMFGBlj8gT20/vaNIcdso2nzi+
	QLr/SxW7vv8w1xrdj7nfnS32ISgRXbwn2q6jiXOdroNtWfO6xkG6AFE+zEJsNzVW
	CkvHABfEp0CmwQo9oZaafwCMea+eXOD1k2A0b8BecX1dZx9AtZKEiYF/UNRPzlmW
	+frE74SkMbxDDJz/HxQTJw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yprhhh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 10:05:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A78UtoP002695;
	Fri, 7 Nov 2025 10:05:11 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nh5v54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 10:05:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DsGkGMDLYco4G706xiLYXJR+hIo1jPhT67UTb959N3KsG9D60YgStNq/02K42enBIdFEv78zjvtc2rubKR4webrV6/jWcxII3CwIELHJTwie1k8uUt89d/J1tvMXcdfH91+tjNGS0kxd7YfL80uw7SvXZVk+qV9/bDiA02/WKgLp6/PtRIlurZMg0SQIEnrjhOTo39US7qOOkP7Uq6JB0UgKyOCezyg+dDW8FzN8o40Vb5GuB/2/9Q4X2nP7fDQnHbDr9IF6wKrTED35g/SYrSBHQF/dfGO48EuydsJIKyiGrtoDFr8huv8KXgiy6fDwkWt6pSHZfcL5ENbk1a7I8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faNnnGiF/rPARANV7FRdRQU+F6MNd62SaoVR6y1nV5I=;
 b=vODrlJQA8WE/hhPtR42xqsjyU9HvxFb1W9F3cgdcYTWT/CHuwvUkjj5boiYDz2NFoJKzAo47fiX6kzZt5SxtEOgc1DKgiTlxtc4gaema9jpS5SD/TNWOKmvtT1SVbdIF43jqkPMYQpRTlg7CHBgQ2Yby/jJPUm/ys6feJD2us84ODKK/LOhQy0mtoIpEgFG3GXfyFtECILCq/BbWglLtc1sWS2AZAsGtWd+ISRiEIrq2S+cGKz8CNPwVQ1DSNqBoSYvC6dSnJqT01xOxPtGkHyUNImpafx72ob6b2HgMN7jJP5Wodn2fKvazZNqAaKb+73wd5ERw1ugnO9DiNoLxKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faNnnGiF/rPARANV7FRdRQU+F6MNd62SaoVR6y1nV5I=;
 b=jn8SkHutkbW44qICkhuHQUwbCG2E6QC2RmL44zOlvmiSVQMYUlYc7JqLJzOlJQeujkgMaGuwETioWoQ4KUkzLlVyVpVNZyFPaponLH5ZCuVwRiyna0ojhDBTDjLvTywOsSWgpioBCPpNEQhCw9pZYu9sY4SVSLSllzdt/KDaI88=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH0PR10MB4908.namprd10.prod.outlook.com (2603:10b6:610:cb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Fri, 7 Nov
 2025 10:05:08 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.006; Fri, 7 Nov 2025
 10:05:08 +0000
Message-ID: <8d4247f6-2772-4f2e-aef7-32c1b0dc8091@oracle.com>
Date: Fri, 7 Nov 2025 10:05:07 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: scsi: scsi_debug: make timeout faults by set delay to maximum
 value
To: JiangJianJun <jiangjianjun3@huawei.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, hewenliang4@huawei.com, yangyun50@huawei.com,
        wuyifeng10@huawei.com
References: <93816c36-26ae-42e9-bd2e-bf7324279c1a@oracle.com>
 <20251106120314.3272270-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251106120314.3272270-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0172.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::16) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH0PR10MB4908:EE_
X-MS-Office365-Filtering-Correlation-Id: da0b4278-a969-4f8d-c93b-08de1de52197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHBkRVgzaEJRMDQ3Z1Q3QzN4M2hNVGdpUE1sU1NQWHlGeXptSTZJU3ArV2ln?=
 =?utf-8?B?Y2dUYVlrTU1WNDY5NzF4VTByV2xCQklvSDc5T05PalordWVkWnREL05QaXox?=
 =?utf-8?B?bzVYOFV0WlpFZXFwUm9paEExaVI5MVdHbEhaMGZiNVJpdmdYSzFyM2puRHp4?=
 =?utf-8?B?Q2hza2pRa3pxckM0VkhCakljL05iR3R4c2RteXZodnBhWUZXQ284MGxnTTVL?=
 =?utf-8?B?RWg2b1VTRTVWd3gyTUhLWHJkSjZDUzNPWnhCMHVHSU02NDlqdSs0cVRLV2c0?=
 =?utf-8?B?VHU3alZUZGoyU3NqWjZsRVFMMWxVZmVpc0FUTlppd3VYSU9CVzFaU1RZME5h?=
 =?utf-8?B?enRuOU1qREJwdnVDSzZuSFpFOEFtdHJMZW1kSWE4NGxvTXVpd25UR2VCUHJi?=
 =?utf-8?B?NTkrc1dJNGU1TXFqZ2hLUklQelYwcTJFNjI0ekFxWWE4aUtpb0xHemVxak02?=
 =?utf-8?B?akN4TGhCOUdsdG16RVV6azJoaUxJdE5hY0RreGZuMXpCZDQraU5zMmlYeHJU?=
 =?utf-8?B?Z0E5dm8wT0RoeEs1MS9WTVRYSXpZeUwwam5xZTV0cUgxOGVSTTNvV1JGRUdt?=
 =?utf-8?B?d1RLSFJZNG0xS2hmdm82cGlWVXVyeHZwNEwxMzNZS1k5UHdScS9VdWdLVWdZ?=
 =?utf-8?B?K0l3WjZpaEJCQ3JHNklGUnphM0FDb096aG9YNHU1b21sNHVZRkl0RVJiMGFP?=
 =?utf-8?B?UVhRYk82YmMrZ1lmOGVIcHMwcU1RUWkycktSYkJMNk9WWGVqeExMQmw4WFBs?=
 =?utf-8?B?VUdJeDFVbVNhV0d3dEJWMkpqak9RanI4TU5WTnV3YjNNMnoxTlZQYnBtbUd4?=
 =?utf-8?B?bHZIM3JqTXFiajVUQ0NPWFlHLy9ZNlRXRE11aE5IV0p2ODVXNktDQkk4b2tv?=
 =?utf-8?B?azZUNE1QaGJQNktSM2JyMjR6NG9pdFhYRXQ5NVpiaTJOOTUzNEhoN0ZjN2JL?=
 =?utf-8?B?bkZpSm5CRDVxTExQb3pRVTJ4UmE4NXluSDNlWDNyMW9PNU5zby85SklSOUZs?=
 =?utf-8?B?ZEJGWVRodmM1R1BNWEJHSG0vMU5rNnQ3WGNqbHJZMW9TeHp4WkUrK0Q0RGZJ?=
 =?utf-8?B?MWhxK2t1K1FNUERRUmZ2bEl4V0oyUS9vT1VuRTU0MmRINC9hSFVjUGFKODB3?=
 =?utf-8?B?dHpoVFBVRnA2eE5wM3dZdExyRHcwc2xsZ2MxeUE4QVBUSmtBaDBEdGlLSHlG?=
 =?utf-8?B?QW5KSWNYZVFTV3R6L1dCSHhZcDFkYk5nMlE0VTQya1dNS0o0OG9nQmpFZmRi?=
 =?utf-8?B?T3Q1N2h4NnVDWEgzazdibjl3Tno1VC90YkdlTzUxVDRGaVAvWlI4U1NCeDNU?=
 =?utf-8?B?RmlhbnNGQkpVRWs4OXNXbnpIVmRvSzlQaUxDRHVSWFBzTFZOdmdmdzlNQ1VI?=
 =?utf-8?B?SkdtZWVCWmpVRnh5T2wyTHhzaUM5UzdWd0QwL3VQYTg5MXdEdjlxM2VsZzAr?=
 =?utf-8?B?Sko4cDh0cjVTYVBlaVNZZ2R4TXFlakxzU2p5M3NFSk5NSnJoMXNNYUJqcGdW?=
 =?utf-8?B?VkxkNkV3bnVaNXJxTWV4NFZvdlp6VjNoVUhOd2pxUzdPUVFhWEZ6MVdJQzI0?=
 =?utf-8?B?WWgzNDc1Lzc1MjlwWEVRQzZtcFNyQWZBU3lSL2FmQXhtU2c3cXN4SjB6cmtD?=
 =?utf-8?B?RUdhVW5lRExmbW1QQjh3ZHp6WFdzcTV4NGpsYU83am0vaFlqRHFGTEpGZmtY?=
 =?utf-8?B?ZStaT2IrdW9acE1qQzFJUTRQVFhuL3BNYjI3anFDUUxFZXVKemFTcm4yY1A1?=
 =?utf-8?B?anAzci82VkI1alJLWWQ2Q1BSNXdHdXQ3eGd1eU5MMzBqUFNycXFRaFJHZGJY?=
 =?utf-8?B?bFNqd09WaUJUYndNcm93Z1VNY2F5dHFCWG5VclBJMzJ0clYzVmFocktuQURz?=
 =?utf-8?B?bmpjQTFVeGN0ZUl4ekdDbXBBR1lIaVdPVU9saHVHK2xpOTJtVUZKa0EyN0dK?=
 =?utf-8?B?YnhYZjI2UXlLSFhHV0RNcUg0YnlqS1R1UXVBd1QvUENuT0hsZFpNTFQ1Y2ZZ?=
 =?utf-8?B?Q1dtTlBRUE1nPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Nk1Wc3l3VjhXM2w4Y2Z1dXBJNTcyNUxqb09CdkxaMFpZMjYvSVZvcUY4SDV2?=
 =?utf-8?B?VFJ4RnZwOWdyZ3JCTkJSc2R3R3F5dTA1WXM0blhjR1J6V2Z2QW0wY1c2Smsr?=
 =?utf-8?B?RGp1SW0yTXBiZ3Q4SlgrdStwbkJ4ZzArd1U2OEZnRWtFc1dyd3NvN1UwVE0x?=
 =?utf-8?B?bVg5SG5pOFk4eVZOYWpSM0FlZnhVdkNzRFA3TGpZdENUTkdMcVlQL2hYV3F5?=
 =?utf-8?B?NW9iU1RnMWVKYjV6akdOcEVpS3ZhWVkzL0VQVjY3UGphL0JyQm5iTWMzREpr?=
 =?utf-8?B?cm5weTgyY0N2anB4QURGS2I5eHJZTWlYa1N3R0h5NFBLOEQrdHlTWS9ITDRo?=
 =?utf-8?B?Qlc5RlNuRHEwd1MwVTh0V3RyVjNhQmZJMGRuNk56dVFoeUpYUlF5RUdnWG1L?=
 =?utf-8?B?d1BudTRNamtIdzdvVHQrQ0h5WXRZdkdDWkR3QVdac0cySVU5MmFtV3hlMVk5?=
 =?utf-8?B?cmtjd3pLU2hnaG1CMVUwcjVNWVU3Zm9GdEFVVkFVQXgrbDVIaFV4blo0RVR4?=
 =?utf-8?B?WkFiTy8rVzFuc21Obmt3amtCK1dVZXBEYXA1RWsrckhyY2RUaVQ4WTlUbjJh?=
 =?utf-8?B?RmhXeXBlTjZCYTF3VGZ2SnRpTDgrbDRGbnNMRHRaUSszTmR2L2lhMzg2SUlQ?=
 =?utf-8?B?TnFqN3BkeHpoYVZGdVNxMXR3eHZrRHZ3WGxRNmhjd082bDZvZ1JYTGplWTM0?=
 =?utf-8?B?YlNFUUNna0E5YU4zM2dYQnpNWTAvM285TGVLbDc2YjlaWDJ5cFpGRUZjQXBt?=
 =?utf-8?B?QUpoVjdoNFpDZ1Z4bmtvaGhOU0l1dkhxOVdSMWhWdlpGZS8zd0VYUldOZ3U0?=
 =?utf-8?B?d1lqN3hDZkt1WHRxV3N2OWpOMzlKQk1oVGhWdnQyMzVTanpXOC93YXRkcWNN?=
 =?utf-8?B?cTNVckdhUFU5TUt5RE9kZWttbzRlMmFJSGxKa04yV2dBNXh0ZXlXZnNzdGxB?=
 =?utf-8?B?M3pwUisxcEQ2V3dteFUvblduaGRmMzZGbFc2Mllkb2xzdnpxZWord3l4VEFT?=
 =?utf-8?B?MmRMRnRscTFpWHVWTnRBc0J3cHZqTGJOaFd3WTd1aDZjTDR5bzRYVTRGTjh4?=
 =?utf-8?B?eUNONGZYVDVjZ3dLckNUY21xc3ZLZHlrZEQxR3lJa2gxZjcxcHp3QjNxenNz?=
 =?utf-8?B?SnFxMXlpNndNa1lob0QydG16Z2xqQzZUVitOZ1paTHIwUVFqMlNJQTRPVFR3?=
 =?utf-8?B?Q3lqc3VjaGZoRE4vMGhNS1IrVEM1UjllQjNLZkJqRENwOUlPQndRT0ZSTnU2?=
 =?utf-8?B?UGxXcndySmZwYkxhUjFmbWNrQ2NUcURGWmMwbGRPaFVIa2RFR1RMVUVmRm03?=
 =?utf-8?B?ejlUNWlQbFVDdzRBeDJJTDUyTktjWHZGYWl5K09aMzREb252YVhvVjllaEZR?=
 =?utf-8?B?eHpTYWhRdlZWMGIrandLTi84N3NGS2N2Mmh2NmgwWGhPcjR1QThxb3krRFk5?=
 =?utf-8?B?WnNLWnBvWGRhTjBXK1VGWkErSDdpSVdlVHNXaEFBV0ZJcmh0VW9lMTJzRXpV?=
 =?utf-8?B?Yjg3VUxvZThycWUyUll6YWdYZHJndDM2T1BOUUdpU1ZJYXN5eVZCSUw0UEFl?=
 =?utf-8?B?S2h4ZCtCV2tWWVpCL2xlcjREeTZHTDJvYkxmdXBzUlpNQ1ZEcitEOVJvWTlr?=
 =?utf-8?B?WjRDUXk1VHJFT2x5UUR3WjVPby9oK2llVXZTSmZWRFNua0NGYi9Wc2xyeWRj?=
 =?utf-8?B?aUNEQ0lNNytXWDNCdTh5UVZxUEtxdVd4VEpRYUVSRXlQWnBJNy9DMTB0anND?=
 =?utf-8?B?WDRyQTY1RU9nSkZVMy9Hck1NTmdtQ0dOdlBQYloyc3VOQ05sNHAyWnlaUGVO?=
 =?utf-8?B?MFFjMEg0eVRYU0V3bDBqSHR6R3B4QmdOZVNCUHZOdUhEbGswd0tSQVJtTXhx?=
 =?utf-8?B?cEZrbVVjaGRncFAyUHo0MDhIdG5jZFk1RG1UUVhQNXdkeFpzSXlNVzNiZkRI?=
 =?utf-8?B?TkV5NHFqTWNOYmZ1Wjdwc2VIbG1wZDlFM05LbldxdGxZU1g2b1BrbC81NGJq?=
 =?utf-8?B?UEJhSHZPZFJFbHVOaXhpS3JmbnREV2s0MVNMcTZmM0NKS3dVVndqUHBJNjVB?=
 =?utf-8?B?Y1Z4bkgvbUVrWE1pM3JUaldLaXdZUi9iN1RFS3FkNjVxemxPeHJ6dlZJMk5Y?=
 =?utf-8?Q?/PG4hGlKOCGPAB+nkynUlyhT5?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WKAsjMOx/MSLXEdizv2SK1fhmkp3fcwq/l16rZD5VgjRPs3lX1yjo+2NmX0IwKcOE8cBViN7ZXaPYz3jd3q3S2Gf7Tp9m5RkGNhE0q102HJck50DRyrFIyF+Wr76/59ku3vdmNxQUpxP5CdMy+TZGO0vrkEBF3pWZ4W5moISh+1g1htjel+r8qE1TlbidDEo7R3ajWGdlTkSfaxrgiBEUGwjo1r8L6GITJcURSvkzRzozaO3g4gUS6Rn7vdVDSmjBOkbwoaqp8MMjPgW25Ga/Kg8HAcvD/y6BPo/IcSCtYai0BDGiRm2OqF7c279uJs9rYbLVrvFlFTM1lYRMMpphMAbyzihsVmmIHsEHPg9+f0KYIJpsmP001C74KNlxSG53TjytOypCbzrc6U/ba38BxXR/G5pa/MAgqZn8m5RCI2jvBgRzhJ3c/mutkZXfViFiRL4c+CEWYyCQR9G0uu6i7tpLfhXqiu7cqbgOXLJlHteYabgT+RrzrSoz+bKW/a9ZzytIcl7bHsmPS2GlPJyL+Z2XhLaszpmbDrGkf0SIGz+jdiuHjts1Ek1c5XnMP6awgt9mOaDSkNMd1NjaMGUy3tbBsxhSyVaRw9ioRFS784=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da0b4278-a969-4f8d-c93b-08de1de52197
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 10:05:08.3701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: raMZ6WpB2P4Z/LLSYDryCXM1Gf8vvufdC08evH3judHHD94orlH150lDNQh8MKjsy7z8r0x/8izuEDkh9kbLmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4908
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_02,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070080
X-Authority-Analysis: v=2.4 cv=fe+gCkQF c=1 sm=1 tr=0 ts=690dc458 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=YS-dSGhIofRX88d7sLYA:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:13634
X-Proofpoint-ORIG-GUID: XiXgb8M9kIqV6yPoF4x3Ox7ECFTgLLQw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzNCBTYWx0ZWRfX4pUxcJqYXm6+
 aynwGrWN5EfMdZswVYfuMb6EdJHcwb+DtF9YivCbY8QHF2c68TUjQp0z8AXHqFHO0FuMhoPt5Mb
 YgKjJNPaPwX+sdTJdunniHuvbXVyWMYfC7GAw128SDNcyq9a+LeTdRGbvz28x2yAonx/c3eWaDl
 KQVOa0OY5ETFS0EFTRAczwIHcNXCuvxbO/Jzkq0c/RYQ2xkdG7+lxg8AgQxHwlIifZ41wN35r2O
 8oBHFPPi3/0jmPeiZiMEnTVUfJlfhAEgVuh2KV3QKdzZC1eMYDD0VnLAj5CeWeYMiWIQ0+wXGOl
 EI2Mq+gOqaSXs9jNPrqdxoUKiPqY+MkoZNyxias8O4LqwmiN7pmnD3W7VWflnp+RsaHLkKVfQQk
 HzSLPT6GsZ0KULZp8cXuNBBjkXWf1fXii/RzH2gx1VrORTW2ZhE=
X-Proofpoint-GUID: XiXgb8M9kIqV6yPoF4x3Ox7ECFTgLLQw

On 06/11/2025 12:03, JiangJianJun wrote:
>> I got this patch 3x times...
> Sorry, command has an error, i thought it had failed, so I sent it again.
> 
>> What do you mean by "checked during cancellation"?
> &
>> I don't know what is meant by "cancel the command properly".
> Maybe I shouldn't use "cancel" to describe it; in the code, it's called "abort".
> The function `sdebug_timeout_cmd` is designed to simulate a command timeout, by
> discarding it. I noticed that you added a check to see if the command was
> executed before "abort"; otherwise, it returns a failure.

When we get discard the command, we get a timeout, and the scsi error 
handling kicks in eventually. The first thing that the scsi error 
handler tries to do is abort the command. All that the scsi_debug abort 
handler can do is ensure that we no longer have a reference to the 
scsi_command, which may mean cancelling any pending completion (if 
possible). Is your problem that sometimes the abort handler may fail, 
and we have to escalate?

> Therefore, I change discarding to long-long-delay, so that "abort" will succeed.
> If we needed abort-failure, we can inject ERR_ABORT_CMD_FAILED.
> 
> The fault-injection can be seen this link:
> https://urldefense.com/v3/__https://lore.kernel.org/r/20231010092051.608007-5-haowenchao2@huawei.com__;!!ACWV5N9M2RV99hQ!L_o5Xt_9lhXLe0R8AWsJWnt33qXlNijbVEWyiq9kjgA2lBsuV7E2s7ficvGM37RlSxxvXVZ1YEkAQxZ-WkFvKGTURrU$
> 
> 

