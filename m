Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037FA30CB3A
	for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 12:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758110965; cv=fail; b=fRHkbgIVZHxJuMXwFAe+OZrZkzvlGezNYbwmpHVV/vEgS0cKuwOpGLgfUfJ0seiKQ07zVbs7E91gqOfIMEECQheczP7yqTv7jr/ZTNsGXVfJ1RqUUU3ODrSNXDbFs+MZ9jvXt39rakz91WhTBDzmjvJ6SusWRa8vXeY8ZBqfwN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758110965; c=relaxed/simple;
	bh=baL9JK+N+OP3nPaf7HBqaQzzTeRk1Wy/sUXT0jU1omU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ahwfc2k4x0IWUqwr3UlPJtu3iGwBStMVlcNdP4lUzqsYzl8flvYSzVDB165Zn8E4ddieqaXCw9P8lIcWqs4q5Uu5i3fMKh07qrjGuriWOjMKkPp1b9WFKVuKCGxda+nh77fwZe+nfwFHj+EjwO60A9UmxYZo8Q1QEx1KE0+24Kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NgorPYqW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zWvnAuDo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NgorPYqW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zWvnAuDo"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAQwxs012813;
	Wed, 17 Sep 2025 12:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=QA53BVNdzQD0KygNSdmuj7F2N80TcPvBDrOe/AXT2LE=; b=
	NgorPYqWzNwOsgwI3T698ZXDLkmjfowWvRuJgDrwlA8GiCXUblkO4op3tYfBISsa
	0HdILROwA+bTljvJThve/drHA4jB4AJvZeqHr7AVCbwELzLHvbMDeRHvR7eYREvk
	96NsZgZs/h7U1tMv5URD7hFcJ2zimrGrxM27tSrlB9T7W8kd30YcI7k1S3ZYx0hS
	3hBCpG8vyekSAKglI8UDxyKxAsyhXtMny7sbKjyrEWzo1fTFOUKjVSGt0YkZv/Iq
	amZ4++FJRFgsCfGvrcOxifoSwwifxRX2+Eqxy1kc60D8R7SfRlzujk82lqVXz9LF
	csdTNzhugnv4xUeiQatoNw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxbs2yf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 12:09:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HBvHwh028898;
	Wed, 17 Sep 2025 12:09:16 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010063.outbound.protection.outlook.com [52.101.46.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dngsa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 12:09:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TapiyBBZDMGQlFL7Uc1cdsls033lT+Gytl3sUco+ULYDEN7icbu3lqCHnpMDT+d9vVoPZmrA+hrGl5IyenzHqoiFgkgQCnQya4kl/rGD3p8FiwzEiWZ1qT7H5wPRE8dZq8oX1XXxo3iVSKOQ7uCx0/fvD0S5tYvjwhXw0Pd/H2DvxW5xmUqhCx41l+u8/7zMmCMKHpFhHVo1BgY08a0y6lw0uRK6QexQXoR8Wn4HovdSBjNK5aVLbMoQZmVhNRmnFp6ZudYJMQh+jUGrQ+udQo0kFUr9K0EJs9OOokAOkdMZN1+tU49braAJJ2sssZi0FtEN5lwiYNXubV2i9OcLqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QA53BVNdzQD0KygNSdmuj7F2N80TcPvBDrOe/AXT2LE=;
 b=fe8bdgpPEIw3/6E70j0B9uD1nx6gvuRTxl5Vmq3yDeHp/9Ve65xwTv/nz9ghS1EyFwqd47qQ/hdQAUy5v8Z8B6DHFkD50fduPUomhA3BfTnuE6KF+kYTtHrsvlBNI0xjBCkO9CBvau3z24LZzZ1L9wNm1UAhjUMVdboTj/5KRMLLKcVgO2EBUGyd1vdRTcp9C5A2JFAD6d+gBx1nooVmlRHgD8iGE0PUoQPS1RoyWfBuUyz5Klg66ihw/miUYG3tWHP2OaPIAQ71OK7Q4smXfjtbT5ZAnMGGDzWP+c4r/BCE9+XMFphtOGzipH+yq+Ve4MuXpALOiziB/HVG31sxjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QA53BVNdzQD0KygNSdmuj7F2N80TcPvBDrOe/AXT2LE=;
 b=zWvnAuDomLqi66lwCMytjYodKJUaBJ/xDejQqh+XGwOC443LYDsbQwExMoFJ4jWSa4IBDqQzGqdSJSvKIB0frGVu9lXALV7tV2ZGHHT6R/cTrpnzKlIEV+HBKOArzOWOjNy2KYfdSLZL/6I43IjOvDvsqhmyfj35P0MzZDACaIQ=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SN4PR10MB5576.namprd10.prod.outlook.com (2603:10b6:806:207::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 12:09:13 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 12:09:13 +0000
Message-ID: <75018e17-4dea-4e1b-8c92-7a224a1e13b9@oracle.com>
Date: Wed, 17 Sep 2025 13:09:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/29] scsi_debug: Allocate a pseudo SCSI device
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-8-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250912182340.3487688-8-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP265CA0015.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::27) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SN4PR10MB5576:EE_
X-MS-Office365-Filtering-Correlation-Id: eed45814-d201-442a-2cd0-08ddf5e3043d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d2FlTWRHZHdVbWZ2amdKeXNCc0NsaWp1bGV6b29Xek03V2sxdGFqSk9kcVVH?=
 =?utf-8?B?WFdMVmZmSFZlOUVVN1NiVDlkL2lpdzB6YXVyK2YwWHlrbzZMVVFXdEdqVENG?=
 =?utf-8?B?L1B6NG5BOTZaMHRpV0EwTVYvQVphZmFxL3pIZHBRNWd2ak1YMXdSN0ZuTits?=
 =?utf-8?B?Tm1mQm43Y1pLd216MVFzdDlwNWRsZkZId2gwS1JYSWV3NkZBOWRBUktIWktX?=
 =?utf-8?B?SzlCemtER092V2JtL3h5TmkrOEhYNFhxNmNIbXp1bUprY05nWVhBaUZzTTVk?=
 =?utf-8?B?eE9UMEpqcXVCMWxIbnVpZldLL1FpVkRxb2R2YTdaNVFBaEgwQXN2Mk00WXJK?=
 =?utf-8?B?RTl6UytjNStFV1BlSmZCeitXVWFheCttSzJaOUpsWGZKK2dTYU01eTV3RWpM?=
 =?utf-8?B?Z1RwU2t5alVwL002WUVzME9UU2VVWW8vak54Q2Z4QVdGcDVzZDVOM1dEdG1q?=
 =?utf-8?B?ajEwanV6eDdYRkI1b1BYS0VTaU14MHJwbWczVzQxU3YvM0hoV1VhL21ZMVMx?=
 =?utf-8?B?Q1F4cWtPRnRzZnJYbW0wSjVEOGpIcURiU1ZFelU1VVZ5L1d4eWUycDUrSlUv?=
 =?utf-8?B?YWU4T1VlQU05aFFMU0d1ZW9FenhwRWtzMVlpUzVydGFyOFVJQm5Pb1V0aVda?=
 =?utf-8?B?UkVjOEc1Zm02dmY4SXBSV2RVVFBQellLR2VIcFdieERFRjFjQUxwbXFlL0hi?=
 =?utf-8?B?NThwVUxPMktudDBUYmRDMlFFODlOYkZzS2NDa21GbnAvL3ZnczFUVmxSa0xz?=
 =?utf-8?B?T3o1eUJiWXYxZHRzbWtpYmNKZ09sazN4RmYvUDUxY0hlQ3JXZk1ZNkhEWWZT?=
 =?utf-8?B?d1FyWkt2L3QxeDBQQ0VKMlZ2emQrdWprYVdlbjJiUzJ5bVBqZXNXbTR2SGQ5?=
 =?utf-8?B?amQyMUpydzlveGd1NStaUnM2cStWTjRKam9JMnB4T3RpbHFDMVZDSlFHS05G?=
 =?utf-8?B?bFBVWWhNWmNsVkkrY0VMeGtGSHBvL29PT0NGd2tiUWpJMDF6SGpWVUdrOXZR?=
 =?utf-8?B?NjJwWHViSmJCeFFjY3RQdkMvdHpNK0M5VzMxaEV6U2ExR3pNOGo3TVVrcWZO?=
 =?utf-8?B?bUZmU1VXR3Zwa0JzR2lpSmJpSEhHTzlpUTQyQmdNWVlQc0NQbmtJcVZJcWdC?=
 =?utf-8?B?L1dJdEIzSTg2ZDdkS1R5WHppYktya1hKMzNVTmNDQkYxUUp2bUdHRlIrOTBF?=
 =?utf-8?B?cWhBSnl0bnBhcndjQXVSbUJza0VBelM3ZVFUWXN4MGZzT1daMFQ3cXpTelpR?=
 =?utf-8?B?MGRvTm5Lbzh6a0wyR0JKdmphWk1MOXhtTG5kVWVlTEpjMWV4ZXdqaXQ4eERB?=
 =?utf-8?B?R3JxWE9zMzZRTERqVGowenR5S1U1QXF2a0pwVlJtVEdKc1ZWaHZkTHk0V0Qz?=
 =?utf-8?B?Zy9wVlhNaGVWWGVkaTY2Y1FqalBCbFhYYTVIekFSeEo4VDMxcy9RMGNUOGI2?=
 =?utf-8?B?MnRzN21pdys0Ty9KZEVTYlUrU2tmOUs5emgyaXV6eGlDd0FLWDFLQ2RaQWxx?=
 =?utf-8?B?QWc2V2IrZStOMXhNb05qZHFhZmRHL3IwMEFYamgwaTVJVGJiUG8rU0VUWFIr?=
 =?utf-8?B?blY1TndoeFVBYXRvMkxCWnZabGMrRnl1TjJnYW9QNmY0bGQyT000ZGhyYmtX?=
 =?utf-8?B?aDl4S0Y0aFZpcGQ5SFJEbU5DeThjd0VwNHJtblRjLzVDNU9QelVUSXFCV2Yv?=
 =?utf-8?B?T3h0MmlRb2VCOVNZRG9XNUdSQmtZaHBETElnSFJLMFJWQnNjNjFPSFdUZGtG?=
 =?utf-8?B?enl3enpTMStrS1RpWWUyMjJnL2IrVUdWc0xzUWphbUd5ZFcra1hjZjl1WTN2?=
 =?utf-8?B?cnMrT3hoYmhDQlRJNUpWZGwzUWw1K3B1dEljd2RXemdSUzFaVzYvVHBjN0xB?=
 =?utf-8?B?eWtNU213QlhrSDYrSUErRUJJYlM5RHNRZ1RBa0ZteXYrWVVmWG5INlo3clh4?=
 =?utf-8?Q?2ghC2HFQoeY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eUVpYmdUZ3N5cmpqVFoyeEdvaWxoMFdlTk1PRXNTQVBaRFd3NDN4TXhHcW9O?=
 =?utf-8?B?K3FlMWJCclpTVkN0Y1QzQ0dtSHhMNERDblJncUVaUkhrTXBZWW1rVlpnRmYx?=
 =?utf-8?B?ajg2bUVsMGxpb0xTWEJwMy9aaUlmanpIc1FxbjVtczg2UmhzVFBPaEZNR0JQ?=
 =?utf-8?B?ZzZOYkVPZmpmWkFOLzlMZzBUYWZNSEVWdEJLcUF5eWM2blJDRnJXeS9zNk5M?=
 =?utf-8?B?aThhOWN3SXhjZ2l5emx5QnNWb3JLQklCemVWd2VpSk1KTWtRdTEvSXhJVitY?=
 =?utf-8?B?R3FWcGllbWE1VWZCS2lodHJlVG1HSVlCQXdiRG80ZldYVzc2S1FZSlEzTTVE?=
 =?utf-8?B?OWQ0MURWbEd2TnBFbWRxVEk3MDdTL2FYY081dGU3MzU2N2JDUGhVUk8vVnFE?=
 =?utf-8?B?ZE5uVU4wWFU3UjZmbysxVmxKNzZmdS9GLzA3dVp1SlVBOXZ0OU5wSDFIMm5C?=
 =?utf-8?B?Nm5sM00vODFKbGYwY3ZnYlJsMlVwNEZ5RlFoKzY0SHR2UHl6aUV2VHVrbVVM?=
 =?utf-8?B?V01idkoydGdrbEN2ZVJ6T0NiTkZTYWk1OVpld1U4YzNMc2RHZGFIRVlKaEpT?=
 =?utf-8?B?L1pLTk9KT1BUa0dmNThjd0tRdmJpTjZuUjNhRnBTakQxcmU0eVoxZVV6Kzdu?=
 =?utf-8?B?a3JveHExZ1FhM3JSTGpjakhBaU5lZEp6amUxQmdkdlFIRW4zOVZZRStiQXlO?=
 =?utf-8?B?d1hEbGErcFFTbEVjUngycnN4Y2kyNzNQWHJYUUk5ZmlhY3dvK1J0UlFIRk1B?=
 =?utf-8?B?MG1Uak11N0VaL2xubEFZWkIybzVQMWNKcForWjVwdkszUll6MTIxTnlyZTEz?=
 =?utf-8?B?Y3phTkt3dWxaTFdaUFM2WWRsbnRIdTdyZFprOUVEQVhIbTd4SDhiVWlrYy9D?=
 =?utf-8?B?Vm9tcHV6Z1pRa1A2Snk5RXl6M2ZoSTAvSDM5V1kvQVlVVmFUeEV2bG9GbExZ?=
 =?utf-8?B?TUp5VEpVWUMwT004T3V1RERJNXpvTUtqOHBBaWxMaDNHS0VWV04yZDVyUG93?=
 =?utf-8?B?bjJUbDRMRlpLRUNjL1ZEczA4aGdNYlJ6MjFWbHhNSUx3Y3RrTmUwWURuTmxp?=
 =?utf-8?B?bDEyUjR3NzQxdFdpaWk2OGd5VjBNTThHU3g2RUFVd2NhcVBzTEFkYXU4RmRp?=
 =?utf-8?B?b1R6cUlEK1gvR3RrS08zemtHODhpeTVOSFY2cTBZc2FLOEdOOEV6T21mNFk1?=
 =?utf-8?B?UzRFNWlRTVNRdTBBNVRkS2orVDQ1VnBBTG52Si8xK2RTemxDOHlySW5uTFJ3?=
 =?utf-8?B?a0VyQm5mTTNhbnZMRmxLM0FLRWRTRUR0TnBPYlhHWU40Z1pHSnVxTWNvZTdC?=
 =?utf-8?B?eUpjMG5mQ0dYL3lIRjhQZVZTbWdJWDQ0TURTYXh3MG1pNFFiOE9saXZ6cFhI?=
 =?utf-8?B?ekFPOGdtbTkvRzA2bitSUWwyOUlodDZGdkJEa0krT0E0OTQ3VzV4T2N4SkdP?=
 =?utf-8?B?TDJLUDdUM3lneFpTbVVUeE5nUzBZeldlVVdnSk54QzQ3TWdmWGpoMkZOaERI?=
 =?utf-8?B?WVdrSkpRcHVlbm9iWGpQV2IzMmtSNVg3QUlPWVYwUExBR0IwdTQ4cHRsN3Vj?=
 =?utf-8?B?U3B6T1RkYjhsdElaMURnL3lFNHMwamhoZGUvbWltb1BWVmxDQ2ZGTmhkQmhN?=
 =?utf-8?B?ZzFBb05CYXBaRXU5eHJQLy9aRTlKdXJqMG43UFZPRlJ6L0U2TzZSd1JCTXh6?=
 =?utf-8?B?Wk1CMU5QN1ZUUVIvZW5sM2dIb0lQMC9IV1I2aDBSdDJyd1hvMFNsdHBRYWxi?=
 =?utf-8?B?c1pISDY1T1ZkOFYrODkyUFEvZEN4a3hTaFZMa3R1OUxiZ2hTQ3FBd09vUlpM?=
 =?utf-8?B?Z29pNFpRS3d5UjZ4aWNRS2VyYmpKUVh0clJaZllScVpLV0pvTzN0Y1F1emZp?=
 =?utf-8?B?OHRFUmJyUlBzSUFMVHNpYzNiMWdhRlBnWnJjbTNCNkdESnZuSGN2c2lVT0E4?=
 =?utf-8?B?UzYrSFBVcFd1Y2FjZTdtdUg3VGRNb0s5U01NNjJoVU1rbzlyQXcrNHA2dUZY?=
 =?utf-8?B?TVhWaUFKbFBXRWhrYTBJSFJnek1GV0RzdUxaT3ErOWZxcGptMkRVWmlnWW9a?=
 =?utf-8?B?ajJDT2xPWU11RGRFTStHUXhLNWJzWGs4VzBPcS9nMk81bHQyNlhOZ3d1SVJh?=
 =?utf-8?B?VzRnZThZbnQ4VlZZT0NOc0x2dmprcWlpOG9pTWQwS0ltTGh0Y0RESDdmaU5P?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vNJHv8h7hxQqUtiqu9wTnrhit1xpllpXTLg+jH1lyo0TCoHapzgTndJ/wrvpugQdWRfZ6b2ccxlhWSiRXlLDJcUqw0p50IVl2gO97uxf8W9ECEs/1JhP/gDJENDTbKfh8sWX0ps6TZIyIZY2HLb9m0easw+VF6v4vSX6pDpOB0lGA0C3HEcXoFPpbm8sV8jq/rrEOETK8oNxkH20H5BOYKhYh4/JOUa2fgbBjSe+OqEKhKR8UtYeaPDFxwloCWwxuypZJRvU+Bp54pWsKoCmbJJY3wT3hRr6Mq6KT9pOwnGjR0XKekdt1GGsSrPSPCDXhd9nOwyIJ7RbD+glh1yk0Gp/TYp8WNQKiRZEIpuYmnOJKj0FkhtaSNbTs5lK//O3dGFeDrF2gZ77GKphGU0ncLHJ3RfiSSxu5FnWfGh+UPaOJarw+qrKXQ4TVocY2BOGwJhfcNWzUagbYKBhyJT2036xABOuLmQRsZFMwmKe/xwpLl0Oz07oO+Jjv5i3Vi0RiJYVkq0NVhbCclnnwBO5wlUjr7rXcM3XWZGw1hbQfU6dvN0aH3w35z7SyJrbpbOrIt3YWn8U6v8Dl3+V0pFQV60lQWcZuIfjb1fTXNVap4M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eed45814-d201-442a-2cd0-08ddf5e3043d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 12:09:13.7667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: njarTpKiyS/Go2j2iakLfqN7kz4x9s0VBNLIL5XijOTkcMbF4UCIkQHF8VRpSfq/9Szh2DBfkKyihjgqkZmWuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5576
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170118
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX8iye+ishrz98
 kGx5zhqbSopE/VRd08CU9H55gBYtHZErVllSXRYLz8w9kEg30RYapEQ8YfcdoGpinYFPlMf4GvQ
 uJZ+p0gna2W2dC2xmkJR+ZGvAag/LsSoSz+J1YUhIxrERGrVwKBzWVe64iHzkJT37niqpe6rF2Z
 Niqunfl/V7HdUoQzcnDEbq861+QMKU+04qHtXcy9fjfQQ/E4Ush9W/vVpbLOSQq9/o6rygLKWJe
 5XjwnJyLcoDbB8UnGRzz3LpLRYRXQRpeHQApcoPih9NI9pU+nrlvsrL8k/dxy0kB2g3+ns/AFhx
 G3/MMfW0ZER3IGtAH+w8vdE7gtjEKv0zp5ht5kLE0IWJOZwN9qoqiZl8fg7fXl3uwEsaIPdFfH4
 NTooviku
X-Authority-Analysis: v=2.4 cv=X5RSKHTe c=1 sm=1 tr=0 ts=68caa4ed cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=N54-gffFAAAA:8 a=yPCof4ZbAAAA:8
 a=WkX6UQAgNGhJ3wlZ18sA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ltFNwz3zIOnQNRcMrJKZijQzsB_fkzVL
X-Proofpoint-ORIG-GUID: ltFNwz3zIOnQNRcMrJKZijQzsB_fkzVL

On 12/09/2025 19:21, Bart Van Assche wrote:
> Make sure that the code for allocating a pseudo SCSI device gets triggered
> while running blktests.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_debug.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 2a8638937d23..3f7884025d19 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -9197,6 +9197,19 @@ static int sdebug_fail_cmd(struct scsi_cmnd *cmnd, int *retval,
>   	return ret;
>   }
>   
> +/*

Hi Bart,

Could you consider integrating the following patch into this series? I 
think maybe some ideas can be applied to the UFS driver. I made this 
change on top of your series. My motivation is that I would like to be 
able to test reserved commands handling.

Thanks.

-------8<------

 From 67bff76aacaffcf8f22c634d5b8afaee8e705424 Mon Sep 17 00:00:00 2001
From: John Garry <john.g.garry@oracle.com>
Date: Wed, 17 Sep 2025 12:58:10 +0100
Subject: [PATCH] scsi_debug: really handle reserved commands

Use the scsi reserved command handling for issuing aborts.

This allows developers without specific HW access to test reserved
commands handling.

In reality, the only thing which we are doing is changing the context
in which we abort commands. But at least we are trying to emulate real
HW handling for such a scenario.

Other users of scsi_debug_abort_cmnd() can we switched over eventually.

Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3f7884025d19..1c5d0b012c65 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6729,20 +6729,53 @@ static bool scsi_debug_stop_cmnd(struct 
scsi_cmnd *cmnd)
  	return false;
  }

+struct scsi_debug_abort_cmd {
+	u16 tag;
+	u16 hwq;
+};
+
+enum {
+	SCSI_DEBUG_ABORT_CMD,
+};
+
+struct scsi_debug_reserved_data {
+	unsigned int type;
+
+	union {
+		struct scsi_debug_abort_cmd abort_cmd;
+	};
+};
+
  /*
   * Called from scsi_debug_abort() only, which is for timed-out cmd.
   */
  static bool scsi_debug_abort_cmnd(struct scsi_cmnd *cmnd)
  {
-	struct sdebug_scsi_cmd *sdsc = scsi_cmd_priv(cmnd);
-	unsigned long flags;
-	bool res;
+	struct request *rq = scsi_cmd_to_rq(cmnd);
+	u32 unique_tag = blk_mq_unique_tag(rq);
+	u16 hwq = blk_mq_unique_tag_to_hwq(unique_tag);
+	u16 tag = blk_mq_unique_tag_to_tag(unique_tag);
+	struct scsi_device *sdev = cmnd->device;
+	struct Scsi_Host *shost = sdev->host;
+	int err;
+	struct scsi_exec_args args = {
+		.req_flags = BLK_MQ_REQ_RESERVED | BLK_MQ_REQ_NOWAIT,
+	};
+	struct scsi_debug_reserved_data data = {
+		.type = SCSI_DEBUG_ABORT_CMD,
+		.abort_cmd = {
+			.tag = tag,
+			.hwq = hwq,
+		},
+	};

-	spin_lock_irqsave(&sdsc->lock, flags);
-	res = scsi_debug_stop_cmnd(cmnd);
-	spin_unlock_irqrestore(&sdsc->lock, flags);
+	err = scsi_execute_cmd(shost->pseudo_sdev, NULL, REQ_OP_DRV_OUT,
+			&data, sizeof(data), 3000, 0, &args);

-	return res;
+	if (err)
+		return false;
+	return true;
  }

  /*
@@ -9197,14 +9230,41 @@ static int sdebug_fail_cmd(struct scsi_cmnd 
*cmnd, int *retval,
  	return ret;
  }

-/*
- * The only purpose of this function is to make the SCSI core allocate a
- * pseudo SCSI device.
- */
  static int scsi_debug_queue_reserved_command(struct Scsi_Host *shost,
  					     struct scsi_cmnd *scp)
  {
-	WARN_ON_ONCE(true);
+	struct request *rq = scsi_cmd_to_rq(scp);
+	struct scsi_debug_reserved_data *data = bio_data(rq->bio);
+
+	switch (data->type) {
+	case SCSI_DEBUG_ABORT_CMD:
+		struct scsi_debug_abort_cmd *abort_cmd = &data->abort_cmd;
+		struct blk_mq_tag_set *tag_set = &shost->tag_set;
+		unsigned int tag = abort_cmd->tag;
+		unsigned int hwq = abort_cmd->hwq;
+		struct scsi_cmnd *abort_scmd;
+		struct sdebug_scsi_cmd *sdsc;
+		struct request *abort_rq;
+		struct blk_mq_tags *tags;
+		unsigned long flags;
+		bool res;
+
+		tags = tag_set->tags[hwq];
+		abort_rq = blk_mq_tag_to_rq(tags, tag);
+		abort_scmd = blk_mq_rq_to_pdu(abort_rq);
+		sdsc = scsi_cmd_priv(abort_scmd);
+		spin_lock_irqsave(&sdsc->lock, flags);
+		res = scsi_debug_stop_cmnd(abort_scmd);
+		spin_unlock_irqrestore(&sdsc->lock, flags);
+		if (res == true) {
+			scp->result = DID_OK << 16;
+			scsi_done(scp);
+			return 0;
+		}
+		fallthrough;
+		default:
+	}
+
  	scp->result = DID_ERROR << 16;
  	scsi_done(scp);
  	return 0;
@@ -9451,6 +9511,7 @@ static const struct scsi_host_template 
sdebug_driver_template = {
  	.init_cmd_priv = sdebug_init_cmd_priv,
  	.target_alloc =		sdebug_target_alloc,
  	.target_destroy =	sdebug_target_destroy,
+	.nr_reserved_cmds =	1,
  };

  static int sdebug_driver_probe(struct device *dev)
-- 
2.43.0



