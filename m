Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BCE15CD49;
	Wed,  9 Oct 2024 19:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728502142; cv=fail; b=AgkJd8YnMlOE/Ii1wGHJHFHAEeFjQooPow04u/Y/6q3WG3p491u8C3bRjTt5swRvsf/hB8p9DLzuF1pCf350/47KAU9jBmO7ma5//eI+KUl3s5Bq/Yit785WGGQX8mfn2Fguu52LDrjLuZ09CiEHJ2ss9S52oHNEMi0cg73Wvbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728502142; c=relaxed/simple;
	bh=Nd5XF8N/XgbeYWZvaoqrwj7t028riKO0S0kRD5hPwh8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k/V5UGqZRS4b/AaeabR9xpqA8leMfNgkZJgx9FMh8Vq28ODQyo1s6R2Co0SeS4/xHXhpKlMKS/DBJ30CBNCp+zjnZjngcybay+ghMk0YitbLveCsv6Dorx0Hr1Wt5B6xxvf6ARZ93a6hlBlm5MH+nS5w5fIscQb+DZctVj3Zh4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Be29BkwK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JXOWtkK4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Be29BkwK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JXOWtkK4"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 499IIUax001318;
	Wed, 9 Oct 2024 19:28:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6ZQyQIDDqp7TmMc1obviHPwB6bAPAR3LwRlZ8zFjzKc=; b=
	Be29BkwKdMd9L5Cp26NwdUfIdVYMoGdzpY/9isXaeO3kxXhIhffzQT0QgJjahtVA
	trKg+4tC059jo3QsAnn89S99PdZqFFTfIAGp/7fmWwwzGKG9JnPCXWXLvKlqB7CO
	Xm5YhCMKb9Dq3+UHsOaacisdYGmFzK2mhWQbu+Cj68rgtbMpQKIQ67Huq7CYGrEY
	5gKS9bSbCwcHB3untpW8/HF5GPS3B2jK7Flpqp41CcsBoGwatm2ivrajXdnCabor
	hsJLhpx86wfbAFbvkonnYufBybJg7G8lau7CNQ85ALr8LKrUB0WuAAJhulFF2rE1
	q/MMPxsDtWdAW2+u/SQK8Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42308ds6m1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 19:28:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 499IUUUB022903;
	Wed, 9 Oct 2024 19:28:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422uw92k0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Oct 2024 19:28:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R6vJaszjMhwE0A82h5B1noBhDFXyOcoK2IUrgQrvB/0Oi8jR307D3tBdzCPxxWb4GIBuVljj4L2O98FlCKwynLON2+RkVB+jOsMALM88oU6lYI7NdAaTyBGekhSpLfqP7rE18SNDmQKEoMR8gZI2cYY9HjxdzWHvyritxfjTFY1mS+x8/QvJmZIbMLZtQqkcd4wrL7FHxEYDQYJ1Ciky6JidFsF9AbDLNLdGb7uFgbALYLKnreXz2cGeJgvYXbMSv+CwUFGthCuFjmrDpzRlna4UH27CaX9iMxhXeWWfwSpmvspXB4RhbGuPBtgHXuY9EzCQJrN3kn/5ZoYA3L4BmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ZQyQIDDqp7TmMc1obviHPwB6bAPAR3LwRlZ8zFjzKc=;
 b=YJpNRh7FDRajk3ZbNbD0hSbcT/K3JB3ATxySmHyUb4U0SXTKMpaAb1/dhTVYSi4Y4L8QiVaZfa0dJcQrjbvHgiIuR3cFpWcanYqTUUsJ2Cbzi/U1Ptbn1CVvBnscz/c+TbSa4gkjC1xzDjCsVBReM0SGAPvB5mfzfixv0xgY2Pvc66ZM/dzgD2DgHmjhbTszb19AbXWPNCbYmrwsydKTCCBYyWDFNc20hzBYvrkXYKBrLEtaXNBvW/QxIBRQUGgeW8GVYecPBuzy1BG9SBiUFRnHJNnQ1u3R94CQzvbNWh97YLPbREMMZ5Eqa2uCe2AX2IY0s9AbOPvreeMAu9yRmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZQyQIDDqp7TmMc1obviHPwB6bAPAR3LwRlZ8zFjzKc=;
 b=JXOWtkK4biNxZJjc4tj1l9vg+mkXQbZya6cqj2aXf8ZI41BVpiXu05tKBSWLeOIRJVfXW9G84qKcI7vnhsGJUGjA82EmjEYmbh4gWlR8f0XheZNZwslDcLkg3nK9fGgAuw8e7RVqXI/lWIkSOzpPnpkdYpmM4YjApX0y6BXzTNs=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by IA1PR10MB7469.namprd10.prod.outlook.com (2603:10b6:208:446::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.25; Wed, 9 Oct
 2024 19:28:41 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%7]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 19:28:40 +0000
Message-ID: <16adbc43-af1e-4f2f-ba64-c25b20c71b7f@oracle.com>
Date: Wed, 9 Oct 2024 12:28:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] Fix bugs in qla2xxx driver
To: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org
Cc: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        bvanassche@acm.org, quinn.tran@cavium.com, himanshu.madhani@cavium.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@yadro.com, hare@suse.de, stable@vger.kernel.org
References: <20241009111654.4697-1-a.kovaleva@yadro.com>
Content-Language: en-US
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20241009111654.4697-1-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::19) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|IA1PR10MB7469:EE_
X-MS-Office365-Filtering-Correlation-Id: db612380-c9d9-43b7-6aad-08dce898949f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cXh2c2dnMG5BWkNFaDRWVklaSHVPVTBia0loRzdxTXJySENxaFR5NWo1SlU1?=
 =?utf-8?B?OGNKNTVjckZQMVY2ckFJSUNET2V0ZXNtRXNZTEsrS3RJWDkxNHViMGZHNjl2?=
 =?utf-8?B?NkFMb0kvdmlLYkxkclFxWDJwS2JvUHlBR05MZXlocnlCQkxiOHVSNkoyWVFw?=
 =?utf-8?B?bXJWbTZYbVJuOXRDazV0M1loWlhSdUhEWjRaZ2UrZk5XNkJZdVJUU05tUFkx?=
 =?utf-8?B?NkFoTEJNQzZ4MXJoZjlsRlBpUXhoVTJScmc3NVpaZFUyL25QUDNDL1Z0aTJ1?=
 =?utf-8?B?RlhWcVpHdVp0WENPS3YreGZXUWd5UGd3eEVyZHEwWmxVL0dmdmxKQmgwWC9N?=
 =?utf-8?B?MGkwWFEySUZ2eS9vc1NXZ3lZOC9aczE4dXhoUCtHbURaVk5TQktUZ1hjUXJC?=
 =?utf-8?B?SU4rQXBkZzhaZ3pXc2V6dm8zdlR6NFBoUFdVTkdMTlUwVm9XSGs5aUwwWXBG?=
 =?utf-8?B?RXpFMXg2cCtId1hodTkrVWRyZVlmZjhHNVczTEc1aW4xbUxkVEhMRVRFRkRB?=
 =?utf-8?B?b1g1eFN1TEZVNk5IRXBUeTNWMHVZZGd6K2xjcGpZQStYZHA1VS9vUEttR1pi?=
 =?utf-8?B?WVpUQ1gzWDNQRkk4RmRZV3dwczFyWVFORVdXbkkrSUlSd1ZoOGtQNG1qTnNT?=
 =?utf-8?B?RVIrQ3VqdWR2aFV1eHNoZ3hEdHFVY2w3b0tWRGVzVDU2UVR5cGpqMXptUnpo?=
 =?utf-8?B?Q3NlZzVlWFJyc2N0eDAzRHRNNGh1Q2FzeW1SbWZJaUpVQ1lnWmRLaEpHclI5?=
 =?utf-8?B?V1NRaHZsUXpjektzOG1JQ3NQVjd1aXNUUXBtY1E0YlBRb3laWUVPaGd0dUky?=
 =?utf-8?B?aGQxRnhuOWVqTWR1NVAxUnZ0T1EwbURiWXZrYi85SkF0MUFhbkE1RWxETkRU?=
 =?utf-8?B?dGY4QklVbURyQjNVQmFlYis3SUoyRGN5dmVBaEdPQ2xWUXdJay90RFgwdXE4?=
 =?utf-8?B?ZjN1aVFPL1RiVDdOc29YcnV0NERudWJ5aDc0TGF4WUx6akVCU0h6ZmdLZG9M?=
 =?utf-8?B?S1JpWkcrZm0rREsvT2pFWXl3SGtNcUFzRG9VZFUvYTVXT1psendMdjlVNVdW?=
 =?utf-8?B?ZFlnY003ZHRXc0NidURQdEsxbE5ldXJuSkYrQnVQMHBYcGJVRTdQVkpDZnIr?=
 =?utf-8?B?RWRoRU9lNFNLWXd0ZE81bS91R0Myc3VzYzVSSmtzRENXOFMzMnV1WGVkU3V3?=
 =?utf-8?B?dGZJMnc3NGZYSnpuYy9ZemgwNUNrOXE5VThuaFhBTGloTTYxMGxEZEtxOURl?=
 =?utf-8?B?V3crNjBlRU9WUjZMSG8wb05JUSsreGhKbTRBQjdYOTl6MXpKRzRqTmpHdEdM?=
 =?utf-8?B?b1gwMExycFVRWHJSVkxKYWxVM1NPY0NINkk5WUZaYzRIUWhoL0s4MUN6Smww?=
 =?utf-8?B?MFNENDZybXF2L1ZnV1E3ZjhZdjlEOGxhMVN6THdnaXhYRXJrYithRlJOWGUy?=
 =?utf-8?B?R0dNSmlyWVluV3p2MGwyRDlLVnRrVi9yWjdRWU83eGRUL29uRW9XZ21raWI2?=
 =?utf-8?B?NnhDOTYvdVNJUGxIWjBtTmhSOGtYdDZsWm5YYVYxODl0aUVqQTJwak1tNG4z?=
 =?utf-8?B?MkxaeUNrNzV6NzRyNXJkWWRMZWhrNjY5azc1MVNpcEZ5NzhyNnR5YUh2NGdL?=
 =?utf-8?B?Y0dwUVYxdDhHMFpvSlV5Z25USEJ3ekxjeDNXNWEwN0plb2dLLzh5MEJCMnhB?=
 =?utf-8?B?WUR4OWovN3l6SnNqdHVEOXRhdldKQXpBZ0swMGdrbkVIc3Q4TVdLVDFRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a0IvSWRRR3hMeGJsQmxnOCtQcHpPNHpDeFVkZk9xb0lXNFBkQ1Z2eEdGdVlu?=
 =?utf-8?B?WHBqdHVWZkY0WmxPZnRTeWt6RncxWTlhNFNXNVV6Qm9ZTSt5b05xSDRBai9Q?=
 =?utf-8?B?c0E4KzB4K2haR3I1RVhVZ1g5UE5oRDJCRVB5YnhsNk5TRjBCUTI2cVBZcllI?=
 =?utf-8?B?RWlYSGdtQU5SRHY3NjBwR2xVMXhDbkVYTDh4MHdOOVp0TGkrSEEzaVEray91?=
 =?utf-8?B?WUNsZVFVMGkzeWNhdjFGZVlFNGxMQlRJalJiczdDS3VrbzEyNFBFNkhWZmo5?=
 =?utf-8?B?UlplZkNEeENHTTJwUWw2VENNS2dOYjVSMS82blZXeHovMDh1VUZ1L1gxZ1M1?=
 =?utf-8?B?UUFOSWtpZTBvVXpxYmo1cFdUS1BDSmIwcFNEcndhNE1uOU1ia1c1THRBZzdQ?=
 =?utf-8?B?dnZiTjRKWEl2OS9lRXQ4Z3BaczhwT2FQM1k1dXc2ZGtOK1J2R3cvazBRSDF4?=
 =?utf-8?B?VGZySm5SOFc4VzN4N0RnRGRFdzk3WHN5WjBJT2RoZC9wcHlmVTJUa25OQ011?=
 =?utf-8?B?MFJkL2VRMTJ4aCtqejJXL05RM3JURCsxNmp1T2dsS0lud3JxTldNenY2cy9w?=
 =?utf-8?B?UHZ1bzlOQkRQZTUyUXJiZnk5WkI2c2RGSE1ndEM0QWdORnBxVjUyUHVkYzZH?=
 =?utf-8?B?alhCMUgrYlNGRlF1WFpBNjBkWlI0eWZXVVNnS2tpaW1seVVWWkQybkUzY1ll?=
 =?utf-8?B?b2Fsd3RNaGJ1V25mM0Qwa3hRNGFNQkRnckpGWXYxNHFYSFlrUlg2YlhkU242?=
 =?utf-8?B?TVZSQ1NINzkyanBRYmdhNUEwMnJyUC9BZHVoUC81ZVdEdUJWZldDclVDUjA0?=
 =?utf-8?B?TjlMdERaWDVIQVQ5UHU0L2Y1Yk4rbkUveGNvaWhQVGtvY2Vkbklya0xlOWhO?=
 =?utf-8?B?YzZEWDZuRVpDWUNDS2V5OTBlLy9HdGJOUmMvM0ZDc0hQcDhZcVlZZ1pzSDBr?=
 =?utf-8?B?eXJVTmxleE5hZktwQmpobXBKTnVDaTErM3UwTDZQVkV5K2E2bTJWM0IvYkpT?=
 =?utf-8?B?TW5IWHZPbE9mOHp2bXNOZGlFYXFma1hadEdQeEZlZG94RVgvV2JsVE5hY3Vv?=
 =?utf-8?B?S1hVYjdZNDBRa3J5NlNpWmtGcHhZN25JcEFoM3VpUDZ1bWM1V0RWaTJwU2xs?=
 =?utf-8?B?TE0rQVlXTFh4T05ZcW5NOUp3UC94Q1NCTVF3czUrTVh2L3JLOUpvU2FaZGdr?=
 =?utf-8?B?UU4wRU9xVjNpekRDdmMvOUlUWGpDQkdpb3NMV1BKVjgyb29WZTdodzlBb09Z?=
 =?utf-8?B?OXV5UkdiRVZGdXRVZDNkc0hqblp2NlRxZDlYMXVJSDltSWw1MkJEbEN3WGNp?=
 =?utf-8?B?NHpxMnJISUJuSkpZUjZITGR1UHZtNDFRVDRaVzFCUG1nRDRhRFVOaGF4NmM0?=
 =?utf-8?B?L3lEZ2VZUnpDcGhrQ3RDWnYvSG1DVERmTWw0SmZCaVJBTS9aZXh0bXgxUFRO?=
 =?utf-8?B?WFJBNUMwOENNU2YxbGNzQ0JXdDJWRHNsdzRreFZlSnBRU3BXRWxlVXptYXVu?=
 =?utf-8?B?ckdTYzJYY3F2SW4yY3dwRjlhNjlEbzJMMUloK0RqQi90cGpITDNDVldPaGRv?=
 =?utf-8?B?M2lZWjAzSnVBczhvR2tIYWVFWFZsaU9VOGl2ODZhbkRpMTFKMzdoZnpjTHAv?=
 =?utf-8?B?eW5YTkRoaTNVT2NBRHdlaU9FUFFDWk0xc1RFVEhnVER3Wmk4bHFWTDBaVGpt?=
 =?utf-8?B?Z3FkR3NVV1lMOXhjYkV4TGg2VnRTSnZ6a3BiMmwxMElTMDRrNmt6Tkxyc3R5?=
 =?utf-8?B?Z0lEbW9mVFRPUUpMeHlKenVsNGw1ZUV4ZnRpZ1BqMVk5NlhBZTVqNzdIaGpw?=
 =?utf-8?B?VmFqSFBwMlJqdVB5YW8xcys5Um9WUWxDUVNUWmprS0N4RXYyZ0hwRlQ2ei91?=
 =?utf-8?B?c0tZWWFlVmlDTTNnY2kvNllDNUlEOW16anU0N1oxalBmT3VWL1BSdW1GUWdX?=
 =?utf-8?B?L1RvOTIraXZmNlNrVjd6d21lMkJ2YzhHbDlkZG5xWDN1LzBpRjIwNnhaSXd4?=
 =?utf-8?B?aW03R0lGa3R1dEhkZFl4eTJ1QjJPUHl4VUtUNkFkUkFlWmc4dVhPVkhMNlZJ?=
 =?utf-8?B?T09ZZGQ4RWhoc1BsSHdTamV4c2k2Q010T1I0aUdNais5b25Bbm5CTThDaG1M?=
 =?utf-8?B?b2Z0S29SNC9FL0FNT0FjZFRQaldzeWw4YlkwRVJBSENUbDBkN3BEdWkyamdu?=
 =?utf-8?B?VGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S5Cxsn5pH5hpNQ7as73V3n5Jt7t6nhfz2py3K/09RiDHIK+/93JK3V5FRTBQL1MnNwpwq03LlKzJRWWeeiq3q04CNN4pievNt8ux885F+4+VeHx8Y7krDBJXRPdmu2p/ZhioHbp1MOSLTzQfHiJzDHBDpQKZcBCOZqyGc8sDv3xGGTBhEx5LIXcBvxYTA7HIi84Z7xZoeAQIYoWLbENn38+dHpCC1vo08PdLEDd1nqsNG6f9F0fyDtUidV5fa84TWN0lPHl8xqk87WgFV4DWAvZ+JJRcafgHgTQK50WuZy4FKIA0KdSzyXgXk+mI7uBwIvOhONA2hWGrAt5AFgSfL6GY9i+P4fnJ2qfoJ6eJGfIwY2WA0wSFa+/irZBX6TnPeS0cQOENVEEWnJR5s4gFIChoXUx3p2e4tzmoKI7DWokk9DuTXXldVcHYY4E5ekw7ajyw77wHCGmwQY7HihJmqYLRGCjfQ/qoivh218jayfESuUOP/glTWbRWtwEgAkf5ptm+4HsCbGf/YVQxDv/JrnNmi1PMXo3Vy3xG9ILYd/aPRM/lGAwm8uKwlCBjVwr7FaNqVUamLqQL9ddhuOQDuEykqb1WUI69ZThGpXVGGz8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db612380-c9d9-43b7-6aad-08dce898949f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 19:28:40.8182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Jxnt/WmtFUosmnEi4F6ItRWNQlvJKLXkVnkx8hrSzKG4bGjhWzo5tAKmGca3LMz+lN+5bbtctDAzCMSzNetWdSfoD8LiCF5CD9Ch6ZPyLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7469
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-09_18,2024-10-09_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410090121
X-Proofpoint-ORIG-GUID: x-QtD9unqnYf_v-I1glqsWRj7opr4KEf
X-Proofpoint-GUID: x-QtD9unqnYf_v-I1glqsWRj7opr4KEf



On 10/9/24 04:16, Anastasia Kovaleva wrote:
> This series of patches contains 3 separate changes that fix some bugs in
> the qla2xxx driver.
> ---
> v2:
> - Change a spinlock wrap to a WRITE_ONCE() in patch 1
> - Add Reviewed-by tags on patches 2 and 3
> ---
> Anastasia Kovaleva (3):
>    scsi: qla2xxx: Drop starvation counter on success
>    scsi: qla2xxx: Make target send correct LOGO
>    scsi: qla2xxx: Remove incorrect trap
> 
>   drivers/scsi/qla2xxx/qla_iocb.c   | 11 +++++++++++
>   drivers/scsi/qla2xxx/qla_isr.c    |  4 ++++
>   drivers/scsi/qla2xxx/qla_target.c | 16 +++++++---------
>   3 files changed, 22 insertions(+), 9 deletions(-)
> 
For the series,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

