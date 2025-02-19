Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640981C3C00
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739974475; cv=fail; b=dJX0Dkl/EtGjplcdgvsPizjcjj0AyQLazbjcN9CJVKsJzvD0lc509D9l8+0ipiq18uHFH5T1sG+0cp/2QxXAAvSmgQ0k+4vLnMjdVE02adnY3JUjjJ7ZPgXyJ/GFepQpGUUmU5sKoQZ9WflDnXtnwUncmfrG+75ck03iV6nTFBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739974475; c=relaxed/simple;
	bh=ngxZZtTXAjzKD46FB2TlQLtGwPMbbw9UQfLAvqWEDgY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vm4QOZeiRIhho8xjQ/3EXf88UcBZbf0lc7C0S1sn8soLlpjdy4IhtgQYMk7Nt9VUpHrqVa+JHnkhf95vtuevau7r8R30rdfVBmGP44eaVugDntlOcdIhF8dNmDHpOrC0ZA12Vtvitn2JlADCjhqNrEP3JKJMPcX7qema1RGN7Is=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bk0r4/5t; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PY+dMjuP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bk0r4/5t";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PY+dMjuP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51JEBYtS004313;
	Wed, 19 Feb 2025 14:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6+jLiKNA1U5V9qrohDJ2Pccz8WBQZTGkW1eofLRlbj0=; b=
	bk0r4/5tYB/jC6diKYB0WPFQB7jgY/iQE+U9rtRIuU62MQPq0LFBtO7KbPdnaL5W
	xwUKhYR8i+kJbhLlS5wXAEwKuMK4YCTfklz5B7K57qH0ivZLjibi+up6pXL4qFkz
	xw+gJm3iK4SGNuzkzSiQSxuhUeOz35V5DmuqaYSJf9gEnTrZWwDvcYGz/rWfX/IA
	daKN0tU0kJcCYKbS/Hvom2g37KFzoSfajPTUJxHUjvdfoeDDWlw7INGcpKqSSJd+
	Uk1RcgSDvObNE3h9RkmyEcLHiIc1mtHenhAq9mIHbE9kKkMPYduvHsQuflOiIZZQ
	NC4EtrVCJSW6pFVHP9j3hQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00khr49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 14:13:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51JE6DA5012093;
	Wed, 19 Feb 2025 14:13:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w0b2h9u3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 14:13:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BpHYelf2sx9vql2E9jJA8/X+pzzvUSqEHqUKt98aiU/wZhxkz+WeGTbzcMKZLkpEWdQrwVw8Opyw4T6mKEYehFU2Ol/qKTL77KdCI5dtoRvCO/n5FIhwb/q+ELJ2hw01csg6XZto90A4rjldBh/0kc2qmRsEwOibd+d2xXSlqprrVwP4dQ0AffyBDdiwN546C8cJgUJb2nFMCJisZKwMkLbs0Wy18fLQv8thF2m9NkOtOQSgOH77gHvCp+SEPI2Ug1Z785n7ovEmn0n3UWDNd6ZC9ULOQz65iIWuJLawvf9By9cDmbcSa3pxEMfUZzzwDvsPINDhy9NeHTGGeSa3Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6+jLiKNA1U5V9qrohDJ2Pccz8WBQZTGkW1eofLRlbj0=;
 b=A/VfzgUXxPk4TFeXOEizOGRt5bh8NGDw0NrcGAtek/SV50FJstrcL4hrPFsTXODPFcwI8UNI4Q5mXv6LVZWAeYDGDOHncxaouRRTMkZzLTjhA6+ob02IFP1VdYfFHYt3ceC4Z3C2IJOdb7oZv8MiXPxKvbgLSSRdDEfwhEtquA7dG1LMXasCJ++Ql1pzEK+sXvKKL5uTKTmkuwe3F1sX1AtclnN+Iya3Jfm8t4KHAE54GrDRicijvCFoxFoNXzQSaQI6Zn1QJWbrrqvpVZBYw00KvIpUXCvUoXl2a//O60+sKjkGHEAk5oIAG7sIFLWHLZa130cNWGh5cfpd+8bILg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6+jLiKNA1U5V9qrohDJ2Pccz8WBQZTGkW1eofLRlbj0=;
 b=PY+dMjuP2F+5ta7WVISttwyKpxVUgaenov3dG6DzYhiluoicoJmfloucmBgwIy51jxVFtYi0yHjymGNTlFTHu5g2ri3vfkLHBaEyQTgAHfqK+eDK3tmEnMXZFGaTZLW41j7EanHUJKwmGYGvZ+gIzzRGWzPcxchQ2XLJTtlmgBg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5873.namprd10.prod.outlook.com (2603:10b6:303:19b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 14:13:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.013; Wed, 19 Feb 2025
 14:13:54 +0000
Message-ID: <ad661773-2ef5-481b-aa35-45b83e4f4a8d@oracle.com>
Date: Wed, 19 Feb 2025 14:13:50 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: clear driver private data when retry
 request
To: Bart Van Assche <bvanassche@acm.org>, yebin <yebin@huaweicloud.com>,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc: zhangxiaoxu5@huawei.com
References: <20250217021628.2929248-1-yebin@huaweicloud.com>
 <4fe6b94e-41ae-48b4-aa9d-a0712a4ef16e@oracle.com>
 <67B46DBD.7060805@huaweicloud.com>
 <11a36fb5-2644-405f-b368-e9a23a6e92c7@oracle.com>
 <3dd1baa8-e236-41f2-810b-e14a28b72ba5@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <3dd1baa8-e236-41f2-810b-e14a28b72ba5@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0614.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5873:EE_
X-MS-Office365-Filtering-Correlation-Id: f3d6c5cf-1266-45ba-166c-08dd50efa3c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OWt0dncxQVR3Z0xSWEs5QS9NQ0k5LzdHYmVtUlRHamJrWHlsM1QwZ3pUYkRv?=
 =?utf-8?B?eFhES3FNaVlndXRocFdvKzlrUTF4SUJqYWdNc09uY2VrVzJqakY5TmdjQ3lV?=
 =?utf-8?B?bG1MYVd4MU1HRnBnT05yVjNRMEt5MFFUTGw3c1Z3NHFRZjkxRS94SUpBQUxj?=
 =?utf-8?B?c2kvTTFzUEV0Mk45aVhNM2k2NXRoWnpCbFhhbUUybklLVEtRaVkybXRXcHQv?=
 =?utf-8?B?eTdLUDZIUEpTWkJmS1pyZG92dnRRSmtTOVNMdjVQMmZ6WGo5M2xFTC9uMzFq?=
 =?utf-8?B?NGJnYXhVWWVaQlZMdTRtQVViMkE0UUJSOXBDRjlFNzNYUXAyTHpmeHA4UnRu?=
 =?utf-8?B?NUpTbUl3VzFlRTBHMHR3TmNYK2Z0SFRMbkR1UHlIWW05OXc0Rk56ZU83dUhZ?=
 =?utf-8?B?dU9GSTZHR3JZT1czYUY4MFV4OHlTS1pOSVh0SUQzQlpocWJieGUxZmJ0eFp5?=
 =?utf-8?B?NStYQUx6dERxNXdiQmlTUEk5SWtPajZDVGtZeFgrWmVWVk9sRVBXdFJtWlJN?=
 =?utf-8?B?cmxnUHRtTStCc2lQcmxyODFqam1STHpycnE0L3BTMkRvamVpeXlsZlNIdDFk?=
 =?utf-8?B?M3ZXQWkzQ1dyZnh4ZmtkOTg0NTJTUGJXTmNqbU1FVkZVbkRaa1FGTG1kZERq?=
 =?utf-8?B?dnN4ZmNneXVqM0Y2eVJGV2t3VXpWenhqajY2WmlSSGhpeFRSdHRCWUkwaFBG?=
 =?utf-8?B?VnBmSFc4UkZBcDlxOHRqWVU4VEdSa0tOdGY2ZWhWUWU3bWJpTWhMbUxMT081?=
 =?utf-8?B?U3ZkMTFWTWcyWWtWYmcwc0pCcVppMWZjc0t4VS8zdkFRK3d4b05rS0lrUzVN?=
 =?utf-8?B?MWIrdGZaY1lTUFVaY2JIZE5kM04xN01yNUREYVhvMWtHWXRGRWM3SHgwOWtv?=
 =?utf-8?B?YlY5Ums1NG9heTlabno1RWZ3QlJBTUwyQk56Tk1HV3cvQnV6K28rWmtLT2Q1?=
 =?utf-8?B?RnhzcXRBUkZIemo4ekJaenB0RlZqVDZiUTEwMnkyditiSDRTYUcyeWhGekVv?=
 =?utf-8?B?VmZiS2QwMThlNFYzeXBxOHh2UTkxcFVrQ25BUHBZVXQrazkxSVY2OSthR3J6?=
 =?utf-8?B?UUVIdDY3SFVpVTRzQ0JTbkQ4YkgraWE1RUZ6WFNJb3phMXhyN29kYUNxWXdO?=
 =?utf-8?B?OUR5U0s0cmpoWFByQXNtajFNQWFVMkVjVnk4UGNjZlQ3TnpPL282cE9KVWJL?=
 =?utf-8?B?OUUxWDI2akJWbHhDWVdiUmVOdTlLTWh3V2p3d3RycjFXcjA3YTIwbFFOVTV1?=
 =?utf-8?B?R2tEWUxjVGVCNmJxTmtMTHAxcVhGSjNtYWZpd0xwbkx5LzBUZlhDemRxSnZT?=
 =?utf-8?B?NUFtWnEwUmM5R0g4QlFEUXBzblhOcE93SXk4VVAreWdFSktVa1plVDRMdU8v?=
 =?utf-8?B?WGJTT05uU2RCdWwyZndyN0Z6QjE0eFJNQjZBa2VHdFA2U0pqMmhwTStnOHE4?=
 =?utf-8?B?aXloSnRFNDdaajFnSnZIQzllN3I4dXZBU0F5b0tQTDFLYXVTWTJYYzA3SFhY?=
 =?utf-8?B?U09ZWWhhenE4QWp4SnVnVG11MzFSelBLdW9HdEdNQnZ6eWdVWGo3VmdTUDdE?=
 =?utf-8?B?WGxpcTNUTVlQdVliUDl0YjhNVzhWU0RraFQrZVJMZnY3cFY3VklSTXQ1ZHZZ?=
 =?utf-8?B?UDN6eGlGUDBVWG5YanQrUE1rVFcwQ2UzRjY2anVuMExFaGw0anpUeDk1dDFS?=
 =?utf-8?B?eVVQREl5U3BuaE95bk1GYm5SY2tCcGY3VGtHQ3N4VitiY011OVdFbkl1SUlq?=
 =?utf-8?B?dVY2cVlZdnlKZlF6K1ZEZlZqMEt4ZmN2Nm04QzgzU0ZMbzMzL1BUem5SQWVn?=
 =?utf-8?B?VEE5K1lVaWxMZHI0N2RnNHRzTTVmVWJDMjRLSm9WbThxLzU4Vzl6a3BhWHJz?=
 =?utf-8?Q?CRG+dkB0IEtqq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEswc0NuR3N2NFcwdkpIRFJqalNHRUNqMWhxWVJPYit0NWN5ZHNNa3psUjlU?=
 =?utf-8?B?eHQvQi9FZjlpcE8vb3JEWHR6eHlyRzBPZXJaNGFpT3VkdUc2RzBHT2lTamRB?=
 =?utf-8?B?SEJ6KzRZZm1yeE83UWwxM3dVNUZ6R1NkVE90OHRxK3gzMVo0bjNYenBuQzE2?=
 =?utf-8?B?dC9DL0xFTkNZNGJvRmRNbUxuZW0vTlQyMERQclZRaE13bHFzZVJ3U2xYWHVE?=
 =?utf-8?B?R2ltUVkwN0hpSkFXRThHL0FKcDZVSnVVNHRvM3NBMUNJcmVtUmJxZ041Ri9o?=
 =?utf-8?B?VjJHaDdDRDMzK2FqTEwvT01rYlJGVi9UUllIVnh4NWEyVE1Xd0d4ejIrTDNC?=
 =?utf-8?B?aWFPeUFOWE9zUUlOb0N2TE9Bcm5QTC8vVDVmcEVWSUhlbUJldHhMRytHckVO?=
 =?utf-8?B?TVc2MSsrZG15QWxYZjBtNXNvd3BVS2V1NkxhWURNc2xsOXQ4MTRjZCtxa1pN?=
 =?utf-8?B?MmJIdWJyVkpiQTZ6VFdpc1diVE9vbktENlIxTXhycnFKeUR0MkJ6TndZeDNk?=
 =?utf-8?B?ZVNpN2c0UDBMNHV2bGZMdXBteCs4N1l6RnJxUFRDdFpxZGlRSHRVajJGMy9l?=
 =?utf-8?B?TmdsTHZhSkZTajBZS0t2V0d5TUx6bzJEK1VIWFgrZG5xaDBKQzdJOGxBZEh0?=
 =?utf-8?B?eHV3UFFOcThINWFtYWRBZ2RNKy95TVZTdm54MmJCMkN2ekR0eFp1bHk0QVRQ?=
 =?utf-8?B?WWM0TEkwejQyOW1IS2dkMlB0UGcyblNSWGNTdnpla29idVViU3dXZ2hWeHZH?=
 =?utf-8?B?QVgxR0QwVWc4SWdQWlJYeWV3NjBaTUtlVkJCenZObHpQcUJxbkpFeU50Wnc3?=
 =?utf-8?B?Unk5K0Y2dHB2RThlV3NFVVJiVjUvUmhwbWpUMjczQytZWVJFVk1BeGFuc2Jx?=
 =?utf-8?B?WkIxV3JhaXhsZU5RTVVhMk0yK0IvbDJuNldVelJVTFlmYmQvQVJGZllKNzlE?=
 =?utf-8?B?eWFwUjFHeFlBQWcwYnJtdTVaSURMRFNzTWlLTW1vUmlpRFRPQWcvbGJTZVA0?=
 =?utf-8?B?eERlWEFBV0ZKRUZmS1pxaGp3VGtzTUNvbDVqNnNNcW41OGIrVlRJQ2l0Z3F4?=
 =?utf-8?B?SVpENUpZL3djNGxpM1FZV3lUYkxFZlJlODhKb25aVnM4bGR1SWEwSGZOcnFW?=
 =?utf-8?B?SkZvQi9tdUpiVEhya04rZ3hqZ3hYOUk1OTVQVFdac09PVGhwVldpYnErc3Uw?=
 =?utf-8?B?aTF2RTYzaUZPMjBPSXVOTDZlUzFMVTYraUtFbGdVcEF6c1gwRnZYWWI2RWdN?=
 =?utf-8?B?V005RXFiSmtYV2hxeXdwNFpnU2gxTlN0TVBBeDU3TDNQaStVT0pLckQ2UVhw?=
 =?utf-8?B?bjkrekUyVVlzUXhjR3VHZTg1WkZ0dUJMM1lJN09QQUp4d3JRMFdXSkxUYitX?=
 =?utf-8?B?bHltUmhCQWRNWG9KbjNwb0pDU1hVRHREbEcwQlJRQk1yUGprRG5vWFh4dUFL?=
 =?utf-8?B?cHZYbjBXSXBMOC9XWjdmOVQ3RmkvSDlQZ1pWaCs4SE0wYklFNmFMVHh2S01Q?=
 =?utf-8?B?MGhsVVdzbEN2RldyK0pzUDdWN28xSUJweHZYNUlQb1ZJT2lKSUVZWVlWZHB1?=
 =?utf-8?B?aUxnM1dCVFZEYmhweEhvSlNibkVRdS8vVEsyTlhIYlJBU2F3WVQrc0xHUmV2?=
 =?utf-8?B?S1VjL3VVZ0FCMG4vT1B6WmhzYzVueGhzRCtWRDNTT2dhaFF2MHYxNS9TUGN1?=
 =?utf-8?B?MEI3REc4RVdTbnFZOU9Damd0QktCM0NWdkdGR0VmUDRRdzFZVFViaVJLb1lh?=
 =?utf-8?B?M0l6blp3VGRKUklyU21uNFBWVjlNUmsrVWtqSWh2MXlKL3lIODZjeU9la2Rh?=
 =?utf-8?B?bTN5ZUt5bEw2N2hLeDZXd3FmNmFXMlcwVC9sdkp3NE9Wek9WM2ZKaW96U25I?=
 =?utf-8?B?a2F5cjM0THNCNktzRGk1aWNqU0tZbjRiRjk5TUtrVktBNGUwK1BPdXB6SG1E?=
 =?utf-8?B?bnFqOGVjTHNtblB2V0I0cjZrTkMydUx5Y1ltMUIxT2JYQldMcDEzbUE2VjZJ?=
 =?utf-8?B?TFZPWjVadVNQU3pOZzlVVWJWL1l5eWdOWllXQjdPREpIT0cvUlREekNLOGhw?=
 =?utf-8?B?c2ZoWEFWdldXa2RWZXBzUXcrRTJsKzdtY29XMFhFZ1hPNGUyS09TMXk4bG9n?=
 =?utf-8?Q?N99L5JmIDMElaJ9oCzl8wMQWl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yYSRv7ofXP7hKvVcv1EChwu7KzwKk7m6UPZDkdLvFK1hXA9FzNSiJ/hxYWR6+VwLNScbp2KTp0q8vYgpTJk6zz2S41ZzCllOS7YXlVdmbcNYNEuxQnarnJcqoZqzEYKVcHwVMfFvnojvBZDgfJ3G8F6JtwpIzhaffag6aMb7e5ZzYtmDIHJZlVysPLAyvOZWmuqpoxXdMI/7fubY+tNsNilB+ooYKwlJQkmMIu61+wmycNGDPOvgQCEZ+8doqbw7r4xfcVL7BCHiJZhZwGl3CJcRyVgumoKpL3lphAj8FI+3CB2gviMUbGhsGCpP5ibL20gJzpk6QGIHVhVdTSl0ebSETkGDYSaa1tSzwM70zaMuwdCUCzSr/0z0v2JifOFOmaJJVqNh6ZIjR3LJUHEiC8AynjHuLjDYlRMGHCwEQJkleUZSoC4CEnSf8cnxLpQHwz7YzFBFje8YSCAreKrlWg5uwKwOk9tuo70oU0BLQDEFqQuUNHxBUD6eJRYXpRxU2PyLs9t4enmQKmlp2/jVkOyyuZt9oOxIwRH5ZFmj95vixx/rm3lmeNjdFaRJYcidP87TvHPcN4ErgNgDvKqhqcoCY+zspeyZ1n39+cWYk+s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3d6c5cf-1266-45ba-166c-08dd50efa3c8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 14:13:54.0355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1MHyzzVGVGl+/6Ua8q3qxYUOoL0RH5qKOVrX6hLdDirD1Jb04ttf2gueJTw5HwQK9mHAXQwWqqgvqVZni6+3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5873
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_06,2025-02-19_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190114
X-Proofpoint-ORIG-GUID: qYog8xp7cC8zKaBnh_KUrc-TR1ed_K6E
X-Proofpoint-GUID: qYog8xp7cC8zKaBnh_KUrc-TR1ed_K6E

On 18/02/2025 18:10, Bart Van Assche wrote:
> On 2/18/25 4:13 AM, John Garry wrote:
>> TBH, I am not sure on the history here. Maybe Bart or Christoph knows, 
>> but my impression is still that the priv data is only cleared once in 
>> the lifetime of the request (from 1bad6c4a) - at prep time - and some 
>> drivers may rely on that (not be cleared again). Unlikely, though.
> 
> I'm not aware of any such drivers.
> 
> Driver-private data was introduced together with the scsi-mq code. I'm
> not aware of a similar concept in the legacy SCSI core.

ok, fine. Indeed, to me, it does not make much sense to keep the data in 
this structure persistent between retries anyway.

Thanks,
John


