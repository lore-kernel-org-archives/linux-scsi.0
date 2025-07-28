Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D983C2367A9
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 09:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753695637; cv=fail; b=m6D/sCv0RCkxRdMVF3mLl1Zytzm+reZLy3pYdN9xubBqJBFbsvo3bdKhGm0C1NmbdSIYzUNa5vAN82QmToM7DJN/oTSoCSwOTM42HzhngJprTwRhKQj7XTRv170FZBKvC+oL7xlhkanZes6qGiiRaf8Docmk7Jsl8ZF+gnHKkeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753695637; c=relaxed/simple;
	bh=KlApfULHW4yKATWJKkijdfLjTuS7OSBaMyrMywMFvog=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=J4ywpzTN50YHrVtOcRQKaCbDgIGjIq+VVOOdux7PwresmpxAESD3wDwSG8FCf1agUYsGvO0BIBR/35Fv5jbfANlrM5R3O6ykhMvctBEsR8wEGtgvVjEa1Op8kj10/uzGq36JanDaPoAfgmHasqEqXXOqBVi5ooft3osnyEYE+mc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fUbdbCob; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eyxYJtdF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fUbdbCob";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eyxYJtdF"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56S7g6eM027148;
	Mon, 28 Jul 2025 09:40:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RqOnML+Srwi/tbNjRzk5stQJasyeQeUhEkSfK2Vm8+0=; b=
	fUbdbCob1g06n7H67j0EOiVQr3NO8S5zAruPIVIpxWOWpot90+N/y1LBszDK9f+Z
	XPARE79IYKGYzJpzLsECdyQFDmHRC3gJ9FSOko1UGeRWXCG+1U6DqJN1Y81jGerH
	1myKHBLMfmISryWaW5oEjHDnB0I6GPZFG9lci6PZ5AkUMz7GIQDbJ0LBNPqOR5E9
	hanG2JETOtAtTGdgWdfbeYodL51UIWl6bVGCCiO6+yDG8S5dfUQmKs+pDcuyNlGl
	UhFW4rvLHp1VMChEBnbzqtQDP4XILgCmzDZ1Lvqa7hukckwKfMiELQzGwroyV/es
	jc5jcvohF8uC+Tg6Ua+J5g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4e2vx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 09:40:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56S8cD8F037813;
	Mon, 28 Jul 2025 09:40:32 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2068.outbound.protection.outlook.com [40.107.96.68])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf821dn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 09:40:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o386EznM3DPS/k7ONiWIFow3J5bns5oWGIeVsp3KEd2BtoTsLZOFxmXYk6ehAbmQQAm8X1DLtVyflLMOJG0z3du1p3KG/TB1iUxL2GAS38kZPLXlZXq/ByQxOaB/iQ7eEbFJwrI8hksYjgyjOzciUuH0NLg5QQ9AHXTV/beTPtcI7Y8nN/u7pa/+LIcNNbnde+tWAOp748LRM8qd3tl0wkU4Ddqh89VlFB5So1hpLa9vOQvCjRry0uLV3kB3nbhFbZaVGlX4KvzmNVyNNeGI5PjwiO25CYMI2W2ZJAwNJnf6YnYWByp5jX58ulxbQhndE67PLH/xmWqDR7HeHe6ZNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqOnML+Srwi/tbNjRzk5stQJasyeQeUhEkSfK2Vm8+0=;
 b=KFO1hZ5HjysQRRGy/gGulC6lD3b/oYnPoYqfL7NY55Xr6Q1+wkXANTVZnT/PD4nsGXM7gNwH4uu2cu3N/ihL5tmaEwxz2b4NOg6NR4sAWeUy+7tBOWfwcUsHg7KmsFVSNsFRMC83aYz9PFoBO8KHZQFRvdTkKpKCJI1wS2I4dvQZyG7r9bQSIjM3cYyXh0UbYMBFiVc6pkznbT/w3EvU7dNrqKAz6qjYjzlzkZgErYTuuhiTJXxaULjiAGmHDd6/PAj48WH3K2WcF77D9pYDhWiqKOwVWrjxiKH7w9MMe3kxNKEAGS/SRURNBwDkUMY1upLDL1m3k7+IosMvvepCzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqOnML+Srwi/tbNjRzk5stQJasyeQeUhEkSfK2Vm8+0=;
 b=eyxYJtdF5qLtzQEBSe0iIHVDgAa6jxVCQbFX5NbtM6sEnupJZZa8ZNHCd8txF7QiGuXPjEMtF6mmOWdKiqRdp9b3CQCd1/e/cdnHGF36PxZof0noV8pmS18KqoZ6m1v7hEgNmfa2iMf8B76S93/HnjuH7WlQUja7HXJeLLMeETU=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by DM4PR10MB6208.namprd10.prod.outlook.com (2603:10b6:8:8d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Mon, 28 Jul
 2025 09:40:28 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.8964.025; Mon, 28 Jul 2025
 09:40:28 +0000
Message-ID: <d3d6659e-dfff-4f4f-ad3b-afe053fe736d@oracle.com>
Date: Mon, 28 Jul 2025 10:40:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Correct sysfs attributes access rights
To: Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20250728041700.76660-1-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250728041700.76660-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0232.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::21) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|DM4PR10MB6208:EE_
X-MS-Office365-Filtering-Correlation-Id: 622c53ba-30df-4aca-2e98-08ddcdbac946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXRDdnNmRTR5cmUydXNUN3hoRmNEZUZSbVV5MWovN3hVZ25uNUxUM0Z6aVlY?=
 =?utf-8?B?Ni96aWQ5d2JoUGpXWGFDQSs4SUFVQkxnRHU2dkRjWDRQcjRxQmtoeEZtQ2x5?=
 =?utf-8?B?K0Rna0h4eUVWb3hyWE5BaGYvYjVYQjdSczAzbWl5eWxpZnNBSlRoOXArZmxn?=
 =?utf-8?B?VHRpTHlYa2tOK2FIUU1XZFNhTDlKTno3akduU0MrekJ0T1Rqb0JucXc2by84?=
 =?utf-8?B?aFQ5OCs4aCtzU2E2TG5hc0tid3RpdXJiNXZvTjRyTEtnVGQ0WllWM3N6eDBn?=
 =?utf-8?B?Zlk3NEV6bXU1dGp1WFhnRlpqdE52V1F1MkUyZkFyQm9RdUNXS3JLcm1VSU8r?=
 =?utf-8?B?RFFEa1Q2TVhvN2hlSHpHUXZLL3BtQUVSbXNNQi96WmpzT3RxZ2VORm5KZDhK?=
 =?utf-8?B?bUlQdDY3K2tVOTdYUXp4K0ViclNabUovekdYT1FOTnUvMUlVUHlLNXU1Vk02?=
 =?utf-8?B?VFBzNnhMTDJxRko4QWljQTBZbzhwd2JERHlSbXkzbThaRGdOYzdoSjIvK1lr?=
 =?utf-8?B?czRmT2doaHc1anhZUiszOVlhNFNyWTh3eWs5d3pxMnVleWFRSXNnVFJmcVlM?=
 =?utf-8?B?THVMdUlHWkQwZ3dZTXd3NkVlSS9UN2c3V2dVT2tYVlFZK0dsQU95Q0hmOFNW?=
 =?utf-8?B?elJqUzduUkNFM0F6MmlRbWNDeHRBdzNHQ1pHbi9mVjZaUTJVSmpGajVaS3Zr?=
 =?utf-8?B?Q0liVGxIRlVtT0VzcFV3Tm5LOFhjS0tyYmY3eVJaVitWdTVuNTJvT2JHRlF4?=
 =?utf-8?B?Y2YxbDRTNUlCMnM0U1MxS1ZDQmFFK0J1RHBjd0pXTE5KbExHNVN5UUFmSDhi?=
 =?utf-8?B?RVJnVFJjRjk1WnNsQ0MrU3M0RVZuNWlacjFYNjNYbUl1SWRJajZ3eUg1anhZ?=
 =?utf-8?B?TXk1Z251ekJXZnlOK0lpemgydEg3RXpON0VGSmhrUDhYRWVFZkRZUmFhQWVy?=
 =?utf-8?B?VVZkRjAxZ3FPbmN4YTQ3bTZPUXl5ZndTMlJ5Qjkzd1JxUnlDWWQ0SDlyZHdn?=
 =?utf-8?B?a0RTRFlQZ3dPTDQ4MlVXRHZqN1BtS1graTcwcHZJU2dmb1RtaFJla3JqTGVz?=
 =?utf-8?B?eUk0dnhraTVNZkFidk56Z20xMVRXdXdZT3ZWanZTVzdHT1lrSW9LSFdGdERw?=
 =?utf-8?B?b3JiZk5zSWdwaHVxV3dSVWdHZ29qNi80dHZxS0RsSnRZSWpEcktnWGtZSkdh?=
 =?utf-8?B?c0VQb0VIMHZyVndQenlhejBhV1BOK2VGRnVkck14VjAyVkk2OVk5WUMrODYw?=
 =?utf-8?B?T2pjcnhaS2tpU0NDMk1WUHIxNm5hbHR2Y3hCZHdsSFRrK0NQOUNZekVOdENJ?=
 =?utf-8?B?emlqQ2xOUFY4UGxTWVYxc2xuRmdHWjYvZnZ1SGt1cVl4V2R2WEpUckVjMWJH?=
 =?utf-8?B?S05ZWHJxTDk2aDRWWWhjQjMrL1R1N3M2eTlYNnNWM0lsYjliRHlZTmIyb0N0?=
 =?utf-8?B?WW1NekYzSjlpbit4MTN3T0N0Zmk5dVI1YVJTeWxZNzVrNmthRFhEWTQ5M1Zu?=
 =?utf-8?B?N0FaNkRvOUJNN2ZqalprQVkzVVQzUlorZEVIRTJDejFKNmN5U25aSG4vbTAv?=
 =?utf-8?B?dzVzQzYwNWRSMzJGRi85TTFuOCs0Nm5NZFhPVG9PSUdXVnQ4SnI5STVWVFRP?=
 =?utf-8?B?WklGOFBiaWxaVUZ4c3FWMmJaMW9PQVdOSW9udlQrZlZrUWlJUkF1bFN0cGcx?=
 =?utf-8?B?TUNyWWNUTis0NzBnNmcyOU4xMlZvWHk4ekFvSHYyQkVsR3hGMjF3RHUvd1oz?=
 =?utf-8?B?dVJlQ0xJUGVZNUN2aHU2ZjlHVVBCRjRtdi8yamdUdnJXaEh1ZHM2dlo4RHNK?=
 =?utf-8?B?QW94WGtsd3phRjBDeXRSZWZLQnRDc3UzRzIzQ2pOZXd2Qlhkc1VEczJ4bmJn?=
 =?utf-8?B?QVViU0tiVytaQnI2WEhEQkd6U1Y3ZnBIbW9lM0pKcHg3bStJRlA0SXYzcVh4?=
 =?utf-8?Q?DVeXcgDzdTs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MG1BWmE1M240Mk9MdStXbkpYYkNnZXNLTHJ3eDhqVW1tYXg1MzJSZnptd2s1?=
 =?utf-8?B?NUhZVUJ3SEp1ckI4QTRyQmEwVWM2aks4djUzQS9IZFR6Lzc3NURnczgvL0hv?=
 =?utf-8?B?RGJWdDUzNm0xMmo5TVV3RGJYSXJhNFE0blNhd3ZhWW1PZXRlU1ZZZFVONUJR?=
 =?utf-8?B?cUlTZFVrdjI4UVNiUEt5WWZzSmFCZFgrbHBvampUb3ppWmc2SVZwU0RjTEVJ?=
 =?utf-8?B?ZGhMYUQyRzZyV0U5TWtrZTdkS3FhbWw1bE9ueThucmE0UW9SUGpCTVd2ZzdF?=
 =?utf-8?B?L3YyeTA4aDdJQ09Dc1VWVkdJSkUyL24zNU43SE1VRUg5K1o1T0RCaE1jVHVU?=
 =?utf-8?B?TEdONmp2bTIySENwd2tXeWQyUFVCN2pnNWtrMmY1akhhKytrSmtHejUydWFE?=
 =?utf-8?B?dkRTU295Syt0K295dUcvWE9IWUxjajlFSXZZT1FMQ2pnRE42K1hWL2pDbGtQ?=
 =?utf-8?B?MzZWTWJvZ3JtRWNRamRQdkgzcFJnME9sSEs3dTBBRW5DOUd0Y2J0N1BzT25B?=
 =?utf-8?B?bXIrK2MwZDFpSWJlVzRLeEswRmxpTEFmY3E2Zm9uaUhma0xDR3BoQzk2Qlh2?=
 =?utf-8?B?THlvd2JkZ0RMc1ZCd2pBSE8rWHV3OHdVZXhTdmppclA3ZlVTL3c5MTdnVDN3?=
 =?utf-8?B?RFZDejlRYUwwY0VzdlR5cmpvRHVNZjhHYjRZazFXVXhCR1o2VmlsZVJxRDgw?=
 =?utf-8?B?eGFWeUpxWGhSalUwUFI4YWVVRHFWc3JVT1hsbkxUcDUwYTNmdVZxNHN0OXBy?=
 =?utf-8?B?WXBDNnRYdXU2WXBKV3VoeFF2cG1sWkN5N2x1UnY1UStvRFNjckJ2N3dSVEc5?=
 =?utf-8?B?c0VyTGg4ekh5bW5ya0VyUi9xZmhIVmNBWlBHRDA3SnlDT0tnb01XWm4wUGxz?=
 =?utf-8?B?d0xzRk1vbzhvR2ZXcm1lQnd6cnU1SG9la3JWbkJOeVl2OHJvQ2xuRDVsOS95?=
 =?utf-8?B?VndYTWFRN3lkK2I2VHRtSFQwZlRnUkE5aDJhZ2lmNHo3OVo4TGxFaFYxTmM5?=
 =?utf-8?B?LzAxd0tBTkZLa1dGWnZ0YVM2dWR2czVETWx1K09WbEtDejlpQVQ2VlNmSTQ1?=
 =?utf-8?B?Z2ZhSXY4aUpBSFJlTExNUHZVc2RMalQyeFhaWFc3ZFVuM2ZkaS9Jb0Y0bWNm?=
 =?utf-8?B?Z1ZYRlRGMk1sWE54MnhsRTJIWFF2Z3k1MmVRNE9xeUtVYkJQbjJNeWR5NnM3?=
 =?utf-8?B?M0JTRURqOWloS3VnQWJaR2RLQUMrWkQ4MzBRS0w2ZFArYjdsaVNSdVhIdStu?=
 =?utf-8?B?dk44QUpRbDJCMS9jVEZXUkd4OFlqdWNkZUFRRUFndlFQV3d2NW9RWEtPUmVa?=
 =?utf-8?B?b2FScXpCNVlKai9tamJiVWQxMm9jaTBxSjM3Nkx4UlM3NzFmcWV4ZlQ1Qkor?=
 =?utf-8?B?dzFsYUFNOGNzRXJwUk1yNXFLQ3k4OG1JZ1Zac3p5d1RmeEo1UXpDZFJLOW1X?=
 =?utf-8?B?cVhWZk44RkxML0M4QjU5aDVtOEFZUFVWczRxZ2x1MkdjVzRtVyt5NUpPQnI4?=
 =?utf-8?B?dmZQL1I0VGp0WThrYzlhWm5MV0M4M2ZUbWhhYmJFSHo0dzBrSzYxV00rSGov?=
 =?utf-8?B?Rnp3UWE4NmgzWUJ2WkNjRlF3ZHhuS0RzK2tRak9sbGI1Y01QK2NUK1lYUDFk?=
 =?utf-8?B?bjFuZENpNzBKQVZtRnhycUV6TE5xYkt4VEpuZjBHaVhHU1BWMi9aL1Z3QnVj?=
 =?utf-8?B?OXpJTHBxemczc0huRWE0b2oxRHFVWjZaQVljZ0xUMWxpRi83dTdJM3grVlBo?=
 =?utf-8?B?bS9lbU05enRtMmhzQldmVnp2WHBzWlFBb1RiRS80SldReXNXZnhQa0t5NmxF?=
 =?utf-8?B?akhxTDg2ZS9zWkNiUjZ1WE9KMGl5VTVVQzhHRGYxU2pRZzkzUU9kdUl1aUs1?=
 =?utf-8?B?VXA0VG0xbU9JN3ZBU1I4d0RySDJ3am9MUmtQOHdlY0NmWG5BMXJGcHJReHNF?=
 =?utf-8?B?TllpZGdLNGsrcGFkMmNUVXlyNmJzeDNKUGI0Q0FNNkZYNC82eDJOb0ZsamV4?=
 =?utf-8?B?QnJob3VwWkgzN2c5ekpBQVNSWlFZN3dPdzF5eU9zVlkvaDVqZndUMHBCNmpH?=
 =?utf-8?B?Q1dXVzdjQWR3NjJUNUIvVXNHY21IRHZFSC91emZmSTM1MFRUcktaQTZpaFJy?=
 =?utf-8?B?VWRWRngvNXJnN0pJK1NyczNHaXF0a3dzWkJJNzZtYk1GQU5Sdk1GUXBZMWZ5?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kBQCu/9YUSOT7CkrU27VGv+znd36p8YVb4znn50jnrFty5bDYVkCLCXJI7C/pc1C5B0E1y7y901PTqHafXHfQasfbgxf7UF5DizO+IjvTgY+eeJThbzPFGoMmslbn3h1m0yn65P+IDHuFSDunNLUB2chV9+uLiJPNS9bMx7BmkjGQml45Z1jwMC+ng4pHe0l7A9ObgjXAQnpStGrujk3eI8LbdV6YyUa1hzljAUSEvUWOdlE0raouP1u1orv1EdC0oyVXqk/ufMk6h6LGardCuMPMJcYLzPBnWzPipMI9e9Af6e/x7gjeT4N3Avk9eZ/MgrT2zGyHoPLFxIr+OppuJnD8I55z+Z5wHMYJjkyQ2VMnofqGDTy/c9VMFhBG0GfS5O5UHsr4kcBn2kMqviH3wer0C0Y+TcnfTrC63JdLWDos9puFEKjZ9rwGSKm+/CSugQGVuuJJy2c7tEU1NBQ5vxEawwEMFzaOd/+KEEAhkimKP6gKUe68PAQVv1ZhTmSbhwAW0NoOa1puE1Ys0hqqZsDtPTHxKeHq9YTQQf7Ej1gkEHZRY2BprZ5+yV4Kd6bLbl5ZQ2rUnSUbHW0dlvbS7G0ELPMzyH81fyMOMjAybw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 622c53ba-30df-4aca-2e98-08ddcdbac946
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 09:40:28.3099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNhTLntrk9iavX4c0wnQL+XRut0H2lbh0pO2SafdU2+ysR7qNeX0e5SvtJkKlkIx4bYhguH824ICiniKIbWJxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_03,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507280071
X-Proofpoint-ORIG-GUID: HPXXK4rB4XGvdzpH8T5d-PHA8KNW2Yva
X-Proofpoint-GUID: HPXXK4rB4XGvdzpH8T5d-PHA8KNW2Yva
X-Authority-Analysis: v=2.4 cv=QZtmvtbv c=1 sm=1 tr=0 ts=68874591 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=6oclSbtYDlVGBrW_fJQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDA3MSBTYWx0ZWRfX4YV2Fv9Wzxyh
 0ZiBRhM7nVZBFasGimeh2JotPT8P/a4svP9LPzwgXe+jkSESFRNhXGPpcgsEFuMbFelByigNg5y
 Sos3Ehp3C4BHt7mvOlMVdyQQTk1dMgaX3GnWHzVWBTq/MLpCyPYnXbw4VqX6hRQ6H/L9d2RV9kq
 6UWNwz4vwlecNKxFjpBHQqEmSllphqAr+U2agwtWnzYSRW0blOqzR8mRMU5x726m1dmPNSDSSZV
 ARCUfy8yQgyuiaYhDOQ4zICLmlwGp3lTxn+VkaPq+Dd7rttAR0Cktamr0IZwYmE8pd1v+B+bMZ1
 x9/c8ScFOtsPuacarxX8r2aN0sV1qFV7TO/F6A+R3BjrCoiL2crC3VQCdF+dUryiCGZcWZkb9rF
 jeLC0AaHSTySfMDtz8JeW13ZV/crof/jg9Xw8Dv32N6pdBoDaDY6Gbq0mnP1OxTbf27Y7KLP

On 28/07/2025 05:17, Damien Le Moal wrote:
> The scsi sysfs attributes "supported_mode" and "active_mode" do not
> define a store method and thus cannot be modified. Correct the
> DEVICE_ATTR() call for these two attributes to not include S_IWUSR to
> allow write access as they are read-only.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>

Note that class_attr_store() returns -EIO for no store method. Does the 
same happen after this change?

> ---
>   drivers/scsi/scsi_sysfs.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index d772258e29ad..e6464b998960 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -265,7 +265,7 @@ show_shost_supported_mode(struct device *dev, struct device_attribute *attr,
>   	return show_shost_mode(supported_mode, buf);
>   }
>   
> -static DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported_mode, NULL);
> +static DEVICE_ATTR(supported_mode, S_IRUGO, show_shost_supported_mode, NULL);
>   
>   static ssize_t
>   show_shost_active_mode(struct device *dev,
> @@ -279,7 +279,7 @@ show_shost_active_mode(struct device *dev,
>   		return show_shost_mode(shost->active_mode, buf);
>   }
>   
> -static DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
> +static DEVICE_ATTR(active_mode, S_IRUGO, show_shost_active_mode, NULL);
>   
>   static int check_reset_type(const char *str)
>   {

