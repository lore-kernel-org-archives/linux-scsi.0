Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B741741F37F
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 09:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786007642; cv=fail; b=f7nfrUljUMkKk8zoIPOL3f8koKrfMl8ZKY8piyo+9Bo2CQY+VbQUrEI2XwvuINreLX+MObBIwSCQJ5PLGWDbySFnv0SGnrpRHELz6bA60B863OpAIQPQJcJbHBlUg6Pe5hQg8G3zBqzMbBDToPpO1a9ngLDA5rnETcAR0rTkTmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786007642; c=relaxed/simple;
	bh=OlyMI+6QhLt1xo+e252Trl0AApJCVhIIUBMJo9mTSkI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qiug0+ZaTDQeatMH4pc8SVfPQGScl5j65oQk8EHZ8hxcIYcbgz17xNY3j+BT/oUQ3/NJ0LbWM3m1Ww97iweJ/1i7iMuJCVA7QWh1Gw3o4cuDQU0rSA17x51h3/wictao9UZ4PLCfJ6LX3NsIwwwvTGdD+U3a/yc6/TMFnSJovdI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JTVQ4EiB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sWGxSnHo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JTVQ4EiB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sWGxSnHo"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6768sIEH602353;
	Thu, 6 Aug 2026 09:13:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=n41SzjOPESDwJQKlnJPDKOQzFPSoeqVvepDzLtF3REk=; b=
	JTVQ4EiBGSmoI/pWU5YxCJKjhjC1oBpD9UCbqQAJhnPk7cs79tDfR4VuTC0IchzC
	PBFIZ3dvPDB3DHsQsnd14UdLmgGv/Sj8pcw0FEm1NZ3TXQG7ZOEsnQ0VoVOEwiLk
	CyoREo47tdxq4h6sEx1LjFqCZ28Bzvy/IGZ9lV1rUL3kf5Sel8vRLYUQh4u35hdW
	2O6nC62V3t3Qipry/0jT/TPwVitpcIOFA7y0not6FpzGeLQcNULG+jkUJB6himCd
	ee45ZIxJMXW9JNjh9pajtZuxquYgXYOpsz6BmmFWWz9CHWNZrzRVtas67Raer1PB
	7qHIdGGzOel6ujph1AKY+w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8e54qg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 09:13:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67699uWv013983;
	Thu, 6 Aug 2026 09:13:45 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010063.outbound.protection.outlook.com [40.93.198.63])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftq441gyx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 06 Aug 2026 09:13:45 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yaum3Iq/1HDiNgvS1B84kiTG2Lkj+JS2v0PkcSobK13DUVUvefT8pGgOo9OwUUNGor6zzI4+UNR3CSBYPlC6h8ygefX42m6sWasFplx3feXYZxoWgiVB1wRjmLO/VCkAgnoB5AJOjzxfM6bYlV8zKnaye7GaI3zNWo+aypcfNZ/jatC7ker0lWtEUkr59fdo9hw1AfUitG8RT8JF1Vg2E7lB3S4XTTbGyELFyHE4XzaD/XxLQ47UDEpNjJiMcTxFiCZZftBGcq0kNMDYCS8l/suATAwY3PMyxxZ0Pz1u3mUhtqYkKmBouM+dFrK9FOkm1ra4nqoeCjhgUSFPP7pxJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n41SzjOPESDwJQKlnJPDKOQzFPSoeqVvepDzLtF3REk=;
 b=RSv5oporDqlsCHezSEiLey3LtmPltjBxJPjHE5RU6ibkY8MfvdA8BaKsqYPNqfe76mrciW8hJ8A9MQDaWS/f+Su6zWOe2lVO6NnKFUvsufiU3Sf23L9VJGX1Q+pO9p6xbESLhvLBZn1hQJdKUDhS8qVZQkV6TKXNzGlIv8AR2WR51FfXAKgjvEIwTVdWVEx2WdT7IIJKmVM2v5HDZn/0EyWzE70dw2FmrmQM+84iCgmrNAZHVyuqtFsM8LfSKcoGv3QWIoqjYfCQfHgAXerNEXYYwn0H9olKwnkbC5GEu1IPRkFHgfg6JQAeanetlEYimcWUgKcDS4+TEsoPYl1GBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n41SzjOPESDwJQKlnJPDKOQzFPSoeqVvepDzLtF3REk=;
 b=sWGxSnHoorwx8c1noNOIgJu0nR5tYBKJR8sW1r5dbleflt7IOIDVZXxx0QDAfJ7VbBOHoj7abilb9XXmC3XGZ8aAZ4LpqNMHP0A9KGqnLVcy9TF6O56u1Mma/K1562VkwI/bmAOX1asn8WuinAoelfFp9dVjdVmSwQ0OrmG8UA0=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BLAPR10MB4964.namprd10.prod.outlook.com (2603:10b6:208:30c::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.15; Thu, 6 Aug 2026 09:13:41 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 09:13:41 +0000
Message-ID: <6d4a31c0-308d-4f4e-9708-11a559137ee3@oracle.com>
Date: Thu, 6 Aug 2026 10:13:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/6] scsi: core: Protect host state changes with the
 host lock
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        Jianzhou Zhao <luckd0g@163.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Nilesh Javali
 <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
References: <cover.1785965531.git.bvanassche@acm.org>
 <d5b40794ca80ed83888a83847c293349e7f1de43.1785965531.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d5b40794ca80ed83888a83847c293349e7f1de43.1785965531.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MM0P280CA0001.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BLAPR10MB4964:EE_
X-MS-Office365-Filtering-Correlation-Id: ae499cce-071b-4100-bafa-08def39b01ff
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|6133799003|56012099006|5023799004|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 Gt1Qngn5mUMDIMAqOMsC5C0dp+vSKB9pFhmThElWXNI82+GG02jPtP1reC3wX9TFLH/rmzkc/J9bueZgJQwFmqgWe1U3sRSYCrLf4OqvLK2W39GbQxywqYW3xARh8/zr8LlE7UVGRMDw0t9es+RMgTakZlfzO6O5+DodAYQvqgggYDuafxQOB1WKylOe+nt6DgH01YBIbaz98dxVPe60yTpe9Q3u+YroE/uf6PPs9amL6gtxa+q/K/wLuFuE3EpV8J7Vph2IojLOHJ3xIsJ1d8KKCI8SBrkP/vxalvgq8OHBbhYme7Lhg8N6mq+9d0t0mRWR3fMqd+gQch4+3D3x8/w4V6xXEzijuQzDF9VIiGnyWHbr0aEQaT0/uplQYm2V35F21qEAk3DovxciKurp9pHIb00ww7htozOLgGkHeTTzxKyA1Q6FVkLbT6ScCWuNoEFz/mVDKuXcj+FZwPiePyiSn+lV4Tc6+STmYicg14WJI7Q53wonl27nBKGeZQcPcQGVCKFCti0ZJKCs1HqdD69BBsDXkJsxTgyNtRhewISBkVmlA+GQzJiXlXJPbf7oC0wzbyd2AjSxXboqAlzdOdsWJKADzl4nXq0oUgzKna67fzAke5KRggOn8Ud0xxCK83UyVJDkRDQoOemgGwHPQUjXE33M8xEU/NSa3753fRE=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(6133799003)(56012099006)(5023799004)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?OWx4Z2J0TDg0TWZkSmpENlJVRjVoa0dOZlZvRW5SWkV0V1V2Z0hSQmIvanlF?=
 =?utf-8?B?cC9adU5GbWFvbUxoUi9wU1NBandjTnYyemZTNHpFeWdaNE52MnZoSS9qMUJH?=
 =?utf-8?B?RjNkVDhObkZtTFFFcDBTcDVNVlpFLy9TSkFReXJEN2hIQy9BdU9TQTQ0MUZV?=
 =?utf-8?B?Q3FCZlNmcGEzLzFXNS9RWVQwLytZK3Y4Z0tlSzVHUGVaSHQ1RVZuRCtKNWlN?=
 =?utf-8?B?YkNUTTE1VDZTWis3UE9hYStTc1NCR1NISFJmSkZtdVIrdWhsYnpzQVd5blVn?=
 =?utf-8?B?M0tXWFZGZkw2eVJNK3REZ1lrU3VKK0lsZ1dBRmRKTEFneUpQdURHWlhoSUd6?=
 =?utf-8?B?N2FJSFF1eUtlaVB6emx2d3hLU0JoY1lxTDFMZnRkS3ZqSHg2S3IwUHNXNFo1?=
 =?utf-8?B?eG9pWDhSeDUxNGEzdi9zaHFTT1hiKzY4c0RnRVNFNHB2K2dnMzI2NUU4RXBv?=
 =?utf-8?B?eVErZEhYSXJqOXd5WDFBcE01dWxjTTY1ZmJiWEp3ZzJqcEtMVTc1YTFqTnRx?=
 =?utf-8?B?VGFFaXVXNDc2MGdoOWIwNTRBcjg1NjFGcDI1VkJlMmdXYTlHWFBqN3dMaW5Q?=
 =?utf-8?B?OVRBSnNQOHBpUlpOT3c1RmlVaFh4NldGQTlvWGUzSk5LWGJxdFltTFJjK3FL?=
 =?utf-8?B?Mi9CNUhCb1J6YzdCUGpSVTJ3MkVUSC9nakJWTnVLYkpZODU3cE9VaWFrWm5P?=
 =?utf-8?B?ZjZUdXFTajZxOXAzYUdiRXlPM3ZwWWhveVFJN0xCMzQ3eGJJQkI2amt4YWtJ?=
 =?utf-8?B?S0RyLzd5RG1LbHk2Y0p1cXJ0b1ByUGUxbFUyTXlNVkEvb0ZkVjByZ0gxK1JL?=
 =?utf-8?B?ZDVrK21BaUpxS1ZYbjJ6TjYvZlJTMml6bnNUQmI4MXEyc3RQZHhUcE1mNExS?=
 =?utf-8?B?eS9EYkhGVXlHbkd6anFtMEl4N2Uxd1dEOXdaeHNFQnloT1ZQSUdiVW9jLzdq?=
 =?utf-8?B?MW8vZHl2U2U4SkxsUG92WWNINlFPQmpBdFVRZXhGZzErTCs3ZXh3VjRhSm1M?=
 =?utf-8?B?LzVhcDB1OThyUVh4dFA5SDdaYXl4WnZNOHhoTFF2aU1INnN2V1dnamx2dW5G?=
 =?utf-8?B?VW5iVlppblhQdlpSUFpMVGRic3ZPZmQzYXBiOWxKMjJqV1JMUUwzQUFnNkZZ?=
 =?utf-8?B?amY1dStYSTV1R2pMMnBqb01XcHpSKzQwUlNYeTlkbE91Ri9FQnFDdTdzekpR?=
 =?utf-8?B?T0lOUkNRQTBZNHlKbHJaSDJPdXJGaFZUNkdZdUxiWVhSTHBPajdwM3lwTjNm?=
 =?utf-8?B?U0YrWGdpVEJYTE9SY05JUW8wZ01qNWFFc0pSSmtFVHMzck91WDhHVDRTNFNV?=
 =?utf-8?B?bWhsMlV5aTBNcDRCRXEvOEZjbEhOd2YydGN2NkRPRzVYeUNJL2lkRVVrbUdS?=
 =?utf-8?B?RXE1V3UvVzNHYkZiWHk4UjRTckhIT2JaRGdaSk5mMVhQeHdJVURXSzNQY1FH?=
 =?utf-8?B?cmZNbHJ5Y0pQMmhpTWlBb2FnMjFZT3NRUlBHaEZkU3BpaGlBQSs4ZWg4eGFz?=
 =?utf-8?B?T2ZNOGlmTFpqdlpmbG8vbW13YU03RjZXT3ZEaDFPbFRMbHBJSmdQWjl5NjVX?=
 =?utf-8?B?Q21WNnZPV1RFVjFUbG9RZnJHUGZFb0RXVVZHd0YvL0tuQ05lZTZEVFBJMUlS?=
 =?utf-8?B?TVJaSWNsTnFvYUpJZTg3YW9vZnowOWlKVUlSMmJja3JCQ1NpSjd5bXFiNkU5?=
 =?utf-8?B?SGYrbkljYXBiaVRiVUJJTUdyaTBpdGIxY0VwMzdPcEs3Ylo5cGFHd0JxMENY?=
 =?utf-8?B?OEZpWnErMmpIUU5qT0k1Q1paVVFSbWo3WjJJREdYcVdiVDhYekFKZ2pKL1dB?=
 =?utf-8?B?VENNMUs4NVhJREtNTkdwaHowNUk4ejVxY2w2WlRaenEwQjRQNjNZV0RVWjBZ?=
 =?utf-8?B?bndlYm1UOHlhazJ2akJ4dE5hMVl2WXBaZE12bjVkNVkzQlQ3NDBuQytzMEpJ?=
 =?utf-8?B?MktHdVoxSElFaDAzZDI0K0UvL2l6TklvOFpQRTRreitvSjdyam1ZVUNKdEpQ?=
 =?utf-8?B?Yk02VVQ5RjZZRjRRdXY0MnlxZ1JiVTQzaWhnYk9nQmNVWUtxeHhHNmYwai9N?=
 =?utf-8?B?Z0QwMFMwZzk2WWZFdlYyR09KOEoyZjV6WXRyaXgzTVV6MnRWRjRPYjhRME9E?=
 =?utf-8?B?M0RQb1pJYXYyNjg3bXRUN2dYcVVJTlhCekdoRithK3Jnc2lIclVpZzhIM2Ji?=
 =?utf-8?B?TzVvRjFCYngxbEMvQ2pBeFdUdXNOZWtQanp3RHppUkhwYitnNmMzZkVzczhu?=
 =?utf-8?B?ZWpJRjVMZllvUlMzWlFrTmczYkVLUHhTODRES2dEWlUrTDRMNlZJNmZsUURG?=
 =?utf-8?B?V0RLa1VRQlU1UnplVXluUCtubzNlblozRFJXQm9rakk1bXY5Z3hyNjBhODBL?=
 =?utf-8?Q?omxDZ3FPiED+1R2M=3D?=
X-Exchange-RoutingPolicyChecked:
	JkSc7DIklDjYhW23hdef/ayj+LU99SFhb/t0Qrvw2TDp0LPQMiLPGCoepIu/FoVR7GIpDgiddnLuQdUGc+9Zp3tr+LGBKHBLpp4fhp9y3TNF2NSdPARoNhJlP11zWoGgVVRRnQhXREBzdVHLDbIXUbc21HSZvIOgepDmUKJtX6x3rZb4gIc1/AfxtdA9FFZ/lagEnxYqCFkuBbruVmTWy1O/iGapGmrCpO8wYI+y51zAZAVui+BSlgUs9HYpMDxFyUDyr2khL7+Z9qaT5zPDWMsbrJc3mdiv2oM0Q/acMjm2pkhTvqbcfwret4iFHeGNZIXFYTZJJXrRFXaNcmlwzg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W2NYyu4OJy2ylgcKjNcRkM+8weOs8ZH1lEVWxVZ3n81JZLFgMtD4lV4XcoT1H9NepuYxchFf4dujlMMwb863XdO6jH3R0JVE2O4Ip8nhqiWDJs0PnF3tk4PLh2WrxoCleUDqMTdX6k6IVmJbQg5zFYV6xwtYAdfG7MjtPjK6aChX3OqS0PGrKNPnAt2aufGPz7zcMTP88MWn0D6rbj8spWwkhMGj+ZkU1aCm52xkYjiMORHyvOO5M5XutP1QrogbKoBuy7xC2gsssNx3rl4ZGZXoznzNgouVUjZ+PP5IT20+VilmhQpMRAjT1w6WYeRAF46RnCy3xY5xU5S2CWmDxxXuqplSLwU6l1RXsGtEWPgN2b1QQ8ISuuFFxl7QpOH0TrpT9ECnZTvjAqjk+usJymHunN49miLNnTlcySnyhd1cD+pjAocQS2DxU0zycwSsx6cpZyti15RnY1MBtTrLQvdlmXUF1JhkEPjHZ8aRwzhOpTVFA4m86gEs9vqqRXZP9nUTMQRGmfvCgOAWq9EYZ8zvXpHuBmMmvsovNC9tgNAZLmmRKsgVIZ8JRISawlmeWRVaLCPNaMv6d93+e8s8kPaWl4o1aty5x8XExhOftMw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae499cce-071b-4100-bafa-08def39b01ff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 09:13:41.5032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vKz8TbZ9bHcGtiD442jBdoCC13zKIfFU8ltdSrHgPGyDifyQ1wPkT8np9Etz9lmqi7iLUKoM+XGc5v5j2KL+dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4964
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608060071
X-Proofpoint-ORIG-GUID: yX9TsgSjgN348NZ3x7p3wRPgilABqJ1h
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3MSBTYWx0ZWRfX7ZqflB4Pq3AC
 w+WhGbuf+8OG7I+2apsRwSAPJinJUDf3AkeoxHJQwxqRgBhUlagHcE+ch1YR3ahOLCNPrAoLu7g
 zJq/eJUR9aG3aiQHt6Eibrg1fx9RahWKF4JWEe+T/ybubx3se1Nk
X-Proofpoint-GUID: yX9TsgSjgN348NZ3x7p3wRPgilABqJ1h
X-Authority-Analysis: v=2.4 cv=M/t97Sws c=1 sm=1 tr=0 ts=6a74504a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=x6Cei9KSa4p_9Gd9CKkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3MSBTYWx0ZWRfX70U+6yZ7Vril
 s6BNmAS+AsdDYidWG3qEgp83xhWdGs5Ew43ATPd30dc1F6y8B1XjntMYmuVui8VWccp3LouIHY7
 QKwLZjVEwivpW/TCHFJh3BjR3Y3fS84rhf6XMVhHgz3OZgF6P4tLDHnDUngEhhlS/O7cqzgYI5S
 VEa6hWWHUh9hjnwJgKlQ5wMtrWN6L7/sq/66w2KnkkUIIwOSK7TwRwlkE6bRg7ckuLh5lLS5OTO
 yPjUQeczv4MbHH5I5q8OSjLogF6YPE0FHPzBubiVNqKnAMfRNamdyvKdLslus/5ETVIBXWq564u
 qMaoWLiVe9UGyz26x70SPRGmv2rfkd2kifXCL3snrS56Yo1LFT59FjahvtSjeh5uXeMxOa+dLGy
 flmtN7jYrJ3qGKRtlYfaUBQ23hMzQe5jdFEOjvythenY0dKjQkBoCN8tuPduxozCTkoxf5IXAEs
 9B/1vy+yVPnOrKfrKsA==

On 05/08/2026 22:36, Bart Van Assche wrote:
> ---
>    drivers/scsi/hosts.c                      | 18 ++++++++++--------
>    drivers/scsi/megaraid/megaraid_sas_base.c |  2 +-
>    drivers/scsi/mpi3mr/mpi3mr_os.c           |  2 +-
>    drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  2 +-
>    drivers/scsi/qla4xxx/ql4_os.c             |  6 ++----
>    drivers/scsi/scsi_lib.c                   |  3 +--
>    drivers/scsi/scsi_sysfs.c                 |  7 ++++---
>    include/scsi/scsi_host.h                  | 23 ++++++++++++++++-------
>    8 files changed, 36 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index d512080268af..d036accb4903 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -74,7 +74,7 @@ static struct class shost_class = {
>     **/
>    int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
>    {
> -	enum scsi_host_state oldstate = shost->shost_state;
> +	enum scsi_host_state oldstate = READ_ONCE(shost->shost_state);
 >    >    	if (state == oldstate)
>    		return 0;
> @@ -145,7 +145,7 @@ int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
>    		}
>    		break;
>    	}
> -	shost->shost_state = state;
> +	WRITE_ONCE(shost->shost_state, state);
>    	return 0;
>    
>     illegal:
> @@ -276,7 +276,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>    	if (error)
>    		goto out_disable_runtime_pm;
>    
> -	scsi_host_set_state(shost, SHOST_RUNNING);
> +	scoped_guard(spinlock_irq, shost->host_lock)
> +		scsi_host_set_state(shost, SHOST_RUNNING);
>    	get_device(shost->shost_gendev.parent);
>    
>    	device_enable_async_suspend(&shost->shost_dev);
> @@ -350,6 +351,7 @@ EXPORT_SYMBOL(scsi_add_host_with_dma);
>    static void scsi_host_dev_release(struct device *dev)
>    {
>    	struct Scsi_Host *shost = dev_to_shost(dev);
> +	enum scsi_host_state host_state = scsi_get_host_state(shost);

nit: it would be nice to use consistent variable names throughout the 
code, either state or host_state , if possible.

>    	struct device *parent = dev->parent;
>    
>    	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
> @@ -362,7 +364,7 @@ static void scsi_host_dev_release(struct device *dev)
>    	if (shost->work_q)
>    		destroy_workqueue(shost->work_q);
>    
> -	if (shost->shost_state == SHOST_CREATED) {
> +	if (host_state == SHOST_CREATED) {
>    		/*
>    		 * Free the shost_dev device name and remove the proc host dir
>    		 * here if scsi_host_{alloc,put}() have been called but neither
> @@ -378,7 +380,7 @@ static void scsi_host_dev_release(struct device *dev)
>    
>    	ida_free(&host_index_ida, shost->host_no);
>    
> -	if (shost->shost_state != SHOST_CREATED)
> +	if (host_state != SHOST_CREATED)
>    		put_device(parent);
>    	kfree(shost);
>    }
> @@ -411,8 +413,8 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
>    		return NULL;
>    
>    	shost->host_lock = &shost->default_lock;
> -	spin_lock_init(shost->host_lock);
> -	shost->shost_state = SHOST_CREATED;
> +	scoped_guard(spinlock_init, shost->host_lock)
> +		shost->shost_state = SHOST_CREATED;
>    	INIT_LIST_HEAD(&shost->__devices);
>    	INIT_LIST_HEAD(&shost->__targets);
>    	INIT_LIST_HEAD(&shost->eh_abort_list);
> @@ -598,7 +600,7 @@ EXPORT_SYMBOL(scsi_host_lookup);
>     **/
>    struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
>    {
> -	if ((shost->shost_state == SHOST_DEL) ||
> +	if (scsi_get_host_state(shost) == SHOST_DEL ||
>    		!get_device(&shost->shost_gendev))
>    		return NULL;
>    	return shost;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index ecd365d78ae3..f0152b043e18 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3072,7 +3072,7 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
>    
>    	scmd_printk(KERN_INFO, scmd,
>    		"SCSI host state: %d  SCSI host busy: %d  FW outstanding: %d\n",
> -		scmd->device->host->shost_state,
> +		scsi_get_host_state(scmd->device->host),
>    		scsi_host_busy(scmd->device->host),
>    		atomic_read(&instance->fw_outstanding));
>    	/*
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index 402d1f35d214..f80a21ec161b 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -5172,7 +5172,7 @@ static enum scsi_qc_status mpi3mr_qcmd(struct Scsi_Host *shost,
>    
>    	/* Avoid error handling escalation when device is removed or blocked */
>    
> -	if (scmd->device->host->shost_state == SHOST_RECOVERY &&
> +	if (scsi_get_host_state(scmd->device->host) == SHOST_RECOVERY &&
>    		scmd->cmnd[0] == TEST_UNIT_READY &&
>    		(stgt_priv_data->dev_removed || (dev_handle == MPI3MR_INVALID_DEV_HANDLE))) {
>    		scsi_build_sense(scmd, 0, UNIT_ATTENTION, 0x29, 0x07);
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index dea78688cc9b..0e12009a87f6 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -5472,7 +5472,7 @@ static enum scsi_qc_status scsih_qcmd(struct Scsi_Host *shost,
>    	 * Avoid error handling escallation when device is disconnected
>    	 */
>    	if (handle == MPT3SAS_INVALID_DEVICE_HANDLE || sas_device_priv_data->block) {
> -		if (scmd->device->host->shost_state == SHOST_RECOVERY &&
> +		if (scsi_get_host_state(scmd->device->host) == SHOST_RECOVERY &&
>    		    scmd->cmnd[0] == TEST_UNIT_READY) {
>    			scsi_build_sense(scmd, 0, UNIT_ATTENTION, 0x29, 0x07);
>    			scsi_done(scmd);
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index d598ab4126f8..c9d9fc7c81fb 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -9411,11 +9411,9 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
>     * This routine finds that if reset host is called in EH
>     * scenario or from some application like sg_reset
>     **/
> -static int qla4xxx_is_eh_active(struct Scsi_Host *shost)
> +static bool qla4xxx_is_eh_active(struct Scsi_Host *shost)
>    {
> -	if (shost->shost_state == SHOST_RECOVERY)
> -		return 1;
> -	return 0;
> +	return scsi_get_host_state(shost) == SHOST_RECOVERY;
>    }
>    
>    /**
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 22e2e3223440..89d2e5a70e9b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1661,10 +1661,9 @@ static enum scsi_qc_status scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>    		goto done;
>    	}
>    
> -	if (unlikely(host->shost_state == SHOST_DEL)) {
> +	if (unlikely(scsi_get_host_state(host) == SHOST_DEL)) {
>    		cmd->result = (DID_NO_CONNECT << 16);
>    		goto done;
> -
>    	}
>    
>    	trace_scsi_dispatch_cmd_start(cmd);
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index dfc3559e7e04..9480432f650b 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -214,8 +214,9 @@ store_shost_state(struct device *dev, struct device_attribute *attr,
>    	if (!state)
>    		return -EINVAL;
>    
> -	if (scsi_host_set_state(shost, state))
> -		return -EINVAL;
> +	scoped_guard(spinlock_irq, shost->host_lock)
> +		if (scsi_host_set_state(shost, state))
> +			return -EINVAL;
>    	return count;
>    }
>    
> @@ -223,7 +224,7 @@ static ssize_t
>    show_shost_state(struct device *dev, struct device_attribute *attr, char *buf)
>    {
>    	struct Scsi_Host *shost = class_to_shost(dev);
> -	const char *name = scsi_host_state_name(shost->shost_state);
> +	const char *name = scsi_host_state_name(scsi_get_host_state(shost));
>    
>    	if (!name)
>    		return -EINVAL;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 7e2011830ba4..69d432fd8e32 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -727,7 +727,7 @@ struct Scsi_Host {
>    	unsigned int  irq;
>    	
>    
> -	enum scsi_host_state shost_state;
> +	enum scsi_host_state shost_state __guarded_by(host_lock);
>    
>    	/* ldm bits */
>    	struct device		shost_gendev, shost_dev;
> @@ -785,11 +785,18 @@ static inline struct Scsi_Host *dev_to_shost(struct device *dev)
>    	return container_of(dev, struct Scsi_Host, shost_gendev);
>    }
>    
> +static inline enum scsi_host_state scsi_get_host_state(struct Scsi_Host *shost)
> +{
> +	return context_unsafe(READ_ONCE(shost->shost_state));

I am wondering if it may be better to protect reading this with the 
spinlock as well. We could lose the READ_ONCE and WRITE_ONCE. And we 
would be more symmetrical with the set function.

I really don't feel strongly about this, though.

> +}
> +
>    static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
>    {
> -	return shost->shost_state == SHOST_RECOVERY ||
> -		shost->shost_state == SHOST_CANCEL_RECOVERY ||
> -		shost->shost_state == SHOST_DEL_RECOVERY ||
> +	enum scsi_host_state state = scsi_get_host_state(shost);
> +
> +	return state == SHOST_RECOVERY ||
> +		state == SHOST_CANCEL_RECOVERY ||
> +		state == SHOST_DEL_RECOVERY ||
>    		shost->tmf_in_progress;
>    }
>    
> @@ -835,8 +842,9 @@ static inline struct device *scsi_get_device(struct Scsi_Host *shost)
>     **/
>    static inline int scsi_host_scan_allowed(struct Scsi_Host *shost)
>    {
> -	return shost->shost_state == SHOST_RUNNING ||
> -	       shost->shost_state == SHOST_RECOVERY;
> +	enum scsi_host_state state = scsi_get_host_state(shost);
> +
> +	return state == SHOST_RUNNING || state == SHOST_RECOVERY;
>    }
>    
>    extern void scsi_unblock_requests(struct Scsi_Host *);
> @@ -940,6 +948,7 @@ static inline unsigned char scsi_host_get_guard(struct Scsi_Host *shost)
>    	return shost->prot_guard_type;
>    }
>    
> -extern int scsi_host_set_state(struct Scsi_Host *, enum scsi_host_state);
> +int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
> +	__must_hold(shost->host_lock);

How come we have this in the prototype and not the actual function itself?

>    
>    #endif /* _SCSI_SCSI_HOST_H */

