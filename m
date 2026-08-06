Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0FB40DB2E
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 09:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786008424; cv=fail; b=qkjbWAi4p7cL78VS+S4R2Xg0yQ7nQLbn+/It9O1lIfV4rwBUaArDjbO/5U0dofFr1P7TW/812C7+gdptQqP8NlYE1nnSFSS2F/5Kh40zZKka7E8EpC8j9Q9C92rX7IuQK/4W5ZWUpNK8CBIwFYEfn0IiDaiD2rBnUmOR3rcyHqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786008424; c=relaxed/simple;
	bh=zqyucGX/G1xIcVYcNGL5tPshGwYUUm0V6cO1Pu1SUFM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OvpssXzYtNvvCiebq7umy2/3LGZN41SANPlDmk32ffWCg3skibiKqTPBi8aQF9I4InzeZnVuDSSY/qJZqtcMGr9UcJgOIOUtsoXkQN07VdzEFFGXoMiwq7AS076PpXGlCRLDaXxJzygjEtzLFqX3exLFiaEzXGX+3wTe+vx20y8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PxHqfGM1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SmS00k+V; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PxHqfGM1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SmS00k+V"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6767cRk4599367;
	Thu, 6 Aug 2026 09:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3tmwAzX/emfdHuqHpIt2Kdgnky2HEINX2yK1d8iUIrU=; b=
	PxHqfGM1RIekI6XhlkWmH8bdscCueuBfiUOC2lpieehnMGBuuNPXmdb1EpVS3kjT
	qHcvGXFb5sZ9b6irW9ptzPsO5+Z4DGSCIUFQ4YPi2e8L9XZ7zuUQQjikP2QgbP1h
	Q4RDYZdwQ3A8NeoRWpUsCYFuVnhdYb6sQarNn79b3Q2fzBSuiqixBK3Lry7OKLTR
	s8NqWbnf589shQ8WSY5L6bcdsR5QsUdxwhQqYoX0o3Fka8qMVURjpbABLHFU/FrR
	yDyfunkIcZnYmuQVKV7mFr4q2s8WLMSTmcp47xQo7fcQXBPiDo5BtHHlrCLOSjHD
	OiaK+n5Wtyl6HQLO9/WF6A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7cycy1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 09:26:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6769PgWj019804;
	Thu, 6 Aug 2026 09:26:54 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010036.outbound.protection.outlook.com [52.101.193.36])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w9gcy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 06 Aug 2026 09:26:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OxE3YcAQlZdppPLU/jO7YHpuIRMH+9zrQl3HOeaQn9Cl6qyreu1fZ8+4mekBr1DmY0oQJN89a52AV3llASBA2QKu+pKzPwiCQvwTmIJUuzGBWXBYKw9SjmOY7u4DgcasEHpmP2FPYD7Huyjg3ycsfO+A1UOSdthzjcr2CGD22LD+RP1kPKB0JlHD+/V7UtDyW6Uc0xxSld4VvwvyKEDp5hSQS8/SKeZET1CXXJlsxTERVJfhAcQQkeqEh6a4RjAAcnax3OKTqaHJrBEceK6n/9GQK+ToFBV1zDJzU2NAZYrYu6TsmmXGZVSr6G6T0UGdzDGoSzm8HvW4nK8U0L1FaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3tmwAzX/emfdHuqHpIt2Kdgnky2HEINX2yK1d8iUIrU=;
 b=JKkjeBDnfz+xZop+I1znkS29qtLqWuIEsHsu5WqxInOr7iCNlXgxtkj3UUkuS8gDtxYMihY67YrR7GWpr//HOMKGgrkUn8ROP74Wc+ufU+TBCssll+8UyZbhZ2O6Sxip5T/gPqELAbrZnbKvBoerDF7sjLKIq7RJrp0Btzv77SFvWkOKY+UaUI4orI2+i1FDDLrKxNqkPUHv16UAAtmilafeoqCbHNXPZqJ+jNo7p6v0WvjYZdYmDgYwsEZOkBs0O+EaOmrolO0OQRByJALK4lhaT5xZhAGlr9iI0PY9GnougP8RfvDtyl4jPrESkfQautPBe6MZtl6e6S2BIJXIBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3tmwAzX/emfdHuqHpIt2Kdgnky2HEINX2yK1d8iUIrU=;
 b=SmS00k+VuD0yTbl4cGW4wgLHlqbgz91hgy8X83chOV5niWIAEQ6sv6bc4ZKzsmztwkaHbLdg/LUv/3+cH046rd4ekiLI70L2PIvH7yo8K6+r7L9RcZ0BXvH4ChpLm5YxqOM3I+F8OXsKfHthTA9R3+qLCADdmEqaPuJaV/2ARyk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 BLAPR10MB4882.namprd10.prod.outlook.com (2603:10b6:208:30d::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.19; Thu, 6 Aug 2026 09:26:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 09:26:51 +0000
Message-ID: <b2b50bc4-5582-4c3c-b8fc-7595c3ba8eb7@oracle.com>
Date: Thu, 6 Aug 2026 10:26:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/6] Enable lock context analysis in the SCSI core and
 UFS driver
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org
References: <cover.1785965531.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <cover.1785965531.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0082.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::15) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|BLAPR10MB4882:EE_
X-MS-Office365-Filtering-Correlation-Id: cdb57a1f-1733-47c5-1080-08def39cd8d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|13003099007|10067099003|56012099006|22082099003|18002099003|4133799003;
X-Microsoft-Antispam-Message-Info:
	G3E9s9fxN03N7Fw8XgWVmwxq/UpMUPrrRtwo2IHVt/LnH+QLSyRhSaCtZoMadmG1yTJxv/a8dWM0Om0jc5kVMJtoBs/4QoJonghNq/VtNtK4ixpf4FhuhFWI/68iO5Ovr102tnxZsmlbHEI6OC0qtTu2tmIitVS8hNwIPSqkHUNMMxRk2zLRcRiE1rLH06/yPvXZhnkkP/WKTKFrFB4ZZ/6C2wmC6b9SOKEOL+W3pyYHlfwqsSuuloCbikPw48gFF71asvruWZKj1TKTI8gtQ1e+gTFYrml1aqcDNeK1HV34Yqe3DxCUJAL5nHLuLsrYozuCtLJAIRCCVmhaYNYhBrtjrmAcbdRAey/xtLMgS+weoxxjp2uzPphIKYvf8rZCqTwxnGLmsowM5J4DbDQL3vxgnLVlGcBooobqgOZ3p+YUnFw07lyNij26SsbjVEpoQM5IHtpgW8Dr9OAOli7T6OmBRkOrk3SMlgD5wLDCf1UWHLK066cmNhZUFf6VRfJjaXn2p5ac6reON7CJ+MVWfuYkm/VYjWovfs+6H9zR91rQ+5mzTUzYhkYOZEzwJ65aLF/0lUXMy0yonnMTeH8jThrATcsFtb6m+bYkFT/ctt8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(13003099007)(10067099003)(56012099006)(22082099003)(18002099003)(4133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aEJLNzhXbDUxWmlmN2VRSmp1YzZoN2pxbnZnTFZTV1RnUzlXVHkrOFNDZVBk?=
 =?utf-8?B?djl2S0xLS3poblM5eXpoM2MyRmxqanZjcHovVnlPN2xOald2azhtelFDT0cw?=
 =?utf-8?B?TXJCN2tPVSt0djYwYzQxcmFlTG9zM0tMVUtUcjNLQ2oyWDNGRks0dzE3UEpD?=
 =?utf-8?B?T1BsbFVsTE5EWGhrY2JFR3A3bENFaFlDb1N1S1VQYzhHSUd5V1BuZWdDL1dF?=
 =?utf-8?B?VEpEd0FPN1E2N0RLN0hHYk0ybnYzRXhLckNLU1VWRGRXc0twNFBRU1JkQXRh?=
 =?utf-8?B?SGN5VVlJdjVwQlUwZE1XbE10REErRXNTWFNNQmxrUW8xd0NZOHNXQ1lhVVRJ?=
 =?utf-8?B?ZHR3ZGl0dlRKNUFZbi9JaDcwQ1ZkMXk0a3lhTXJqYWNPajNkL2ZCRmtUQk13?=
 =?utf-8?B?TE5uSW11eDZMakJZNWd3RzZHWHc1dzZxVE04RHlzeGZSWGdzVFdWWE9Ib1Vm?=
 =?utf-8?B?WHhKSWFQUmJQOWcrQ0ZVN0xxK2s3bkszMXp5cVVVSmg3S09zNHFpVC9JQitl?=
 =?utf-8?B?aS91WXVHU3NWZVp3QUhpZnhiQ0FvNzR0WFdteXJLMUJWVG9xTmFNT0pBSEtx?=
 =?utf-8?B?d0RacjRtR04ybmJSM1B3QThveU9kQTZ6cnAwdElJUks0bVM5YXoyU0JhbU93?=
 =?utf-8?B?VE9GQ0hleHlWY2pIeFB4dzU4UWEyVjloMTl3TkRxQXo1OVpoZDBPM09VaDNm?=
 =?utf-8?B?YWtnc2JJTVJ5d044RWl6c29xQWQzb1FtMHMxUVBJZFZyV2pqd0VmZG9nKzhU?=
 =?utf-8?B?NDhxUlRsWVlZa3Z1MWJFR1VvY0txVDRkVkFZZDJBWS9XaGpyK1JmelQzU2ZQ?=
 =?utf-8?B?UmdoZlgwc3pwd0xlbis3eW4rdEllZk1GNGhqNjA0SmVjekdvQnFER3lmM1pi?=
 =?utf-8?B?RGVNbjFwN21BLzQzeHlzK29Bdk1vMEpvZkZhcm5KMzBWUEs3WXBHVVM1MkF6?=
 =?utf-8?B?NXBlSkorWVlYbHFJNXJwWFR5a1hPYjFlU012YkgxYXAyMS9NcXU0Y3QxU2dM?=
 =?utf-8?B?bDVUZG9yR2dFVmhQQnQya2ZiRVB1TWwxV0xYOU50VGFaR21BdzVoWnptUjlp?=
 =?utf-8?B?RytNeUhHSXNwdERYQXdLZjNkbnZnaEgvOWkyYnBLTDI0SFhnQzIwbFRBTEZZ?=
 =?utf-8?B?T1d0WmdYaTZTSURMQVF1UFJsVWhQa2NZVDEwME9UdzFqd3hVRHRjR2UyNHRL?=
 =?utf-8?B?a1plc1plblEvWGpwa0tNVVpIN1d2dHFwWkEzNXo0MTQzZEpxTms2U1hiV3FF?=
 =?utf-8?B?U3V5UnhkQlA4QVNpWXYrUUh5V3ZqNkdwSXozOHdaUHVEU1ZIcmxqYTZJWm1r?=
 =?utf-8?B?VDNCeC9xUmFhNUQvN1NTa09UZjZvbjFRNmJONFFEdjVRRll6dWIrQW1aZWN1?=
 =?utf-8?B?REkvRlpvb09YYk5yc2QxalZHYWtyTWxqRy9pcWdEbGJ1cjMwRENicGhLT20x?=
 =?utf-8?B?Nm9rcjlwQWlFTnNubVR1TFdWZFNZVjNiVFIwUFVuaHhCN1lDbHRXUWI3VVhk?=
 =?utf-8?B?NVBoS3lRYXd1QXlHNHF5cmtSZUVaZEllbGxuRzZHNWFlZy9KLzExQ2FqdWZK?=
 =?utf-8?B?c2dES0RXK1V3R2hxV2lUcEtsZXN0YmNSZCtHdkxLWkV1clR5YTh0QTZZbVZp?=
 =?utf-8?B?QVVZVFBhRFdlcGszNDB5RFdWcjZxRVNBbWJ3QWhwSW1Fd25Jd25qaktFNmV5?=
 =?utf-8?B?RG5pdW1kSFhiaU8vemhBRndJcjQra3d6WUVWQ0FSNHlUMHdGejI5OC9ac3Zi?=
 =?utf-8?B?ZDJRTFJBd3F3T0M1VGRqZG02VVI3QlluNERaZFZJSDFQcHdtZUsxeXk4ckd0?=
 =?utf-8?B?NGdjYytBN3V2d1ZoUjhCYVljYUo5Y3FNK254cUlHekgweWtrY3RPK2V4OG5O?=
 =?utf-8?B?QW5ubmxKZG15S3dwL1VLMklXd3ZRaEtxWStnVlc3WkVQMnM4KzVCb1N1RHVK?=
 =?utf-8?B?Q3BRMWM1VXlBa2hWRjIySStKSS9LbTJ2b20ybDhRd216emMzRTRIczZaQi9P?=
 =?utf-8?B?akVsbWRGTEw4bnY2K2pjdW9WZVJES3laRXdpQkZUNkVTWGppVU5xb1pKYTRS?=
 =?utf-8?B?aitDREppZDBtQ29FQnFVVDF0R2N4UU9wSHRoeVV2Wno3QXVxWFJjWnl6K2xw?=
 =?utf-8?B?ZGR0S0ZwRjF1S01uby85Sm9UbzNsUHM0NDZoeWw4Nzg4UEVOeHM1SFY3dDBY?=
 =?utf-8?B?NCtZM2doOGNwR1VTN3J2YXNwUGd6cDdOSnVBTW1NSExDK3VGdmExWWNFNVgz?=
 =?utf-8?B?UTJJK2lGRks4anZ1RDhXcndqUm9aeTBrNTFKenBVTi9TTTh4N3VrQ01WU3cr?=
 =?utf-8?B?KzJudzNTS1pIa2p3WXUzU2tuZVlQejNQSjlvdzhHR0JNWUo5U1R5VVpYNElv?=
 =?utf-8?Q?unlCYxLNw25itfGk=3D?=
X-Exchange-RoutingPolicyChecked:
	THmRVN3xIl16Us0jVlGYud4tsqI6oAZ/LavWiO6lDlavCbUlayAPdlSmbBn0yCn0vK/pewA9gibD4WkKHcZ/tsDn1yxzZnggXaoVYFLWISSK1MvK+eGMIgc0ynH8kxAoaSG4dzMub1tC5QgbZGSt0eV8qngp8zKMiEsS61W4K2loiEjXBgeLZxr730ygMptLitxyLQZ81q3yURKp554lPca4vUmScwIGm1qoe8dI6GKVUfeWjPaundSghcCVqocrEQ7EIyFa9uUCpXcgiluO2dW2gR7ZKnTYox7GB7dZSNGE1IKoaxukySBD2oJ1LfzAK8myBM8hXW2C4zir6P/+4Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bnd9WRyO1YubrnwPNmTJmHmcV/Gosu38bcu4/kSsA4TGpgmR2EezQy5625EZ1rOKM9mcuWk+1tccC/yJVAyUQMJPWfm6mINH1FQdel2er5bBCI7mIwvDoSl7YmQgWI106liD+qHEAqxumlOyyQul7A0OCE9/7jHIIt+dtcTPslzWagEzMs9MUISntDtvDn7FnsF0BxjnQZWhVTAKlCNJkWgPNPbK8lgpZzwYIuVl4dCuaxCCEYqxTbKhOm/tq/64TWB23GKbBbW9LcB/aG3rVoIjQ1pteD183d48uwR8j94uy5AnMvOEZ1ut1MTD8Ppekldqc64eUFh4nSR8IiR8UKnuBb+i5iclvSwYkyABx+U70FvvnOlE8F6eipzqwzRL3dYduLCJnBIo8Fmz/mtoT3PurGs66EIt3R4J7o4IRACMR9IC4/9FDrJnki2PGHh7ddYzwQPnDSCmWD7tS2f0XAtwyEoI/ZNgXJKXkbCsUovzboymA9N9LTGpqfjvsfUpdqpeZVkb8dUzk+YrSkRYDevnO40zMWxPM3D+1TfmXM7tvSD7SF540weFX8IIR+H2uwyRrHnQiaMnUT/CJWKusfbi18EcTozaaWSmQYSECP8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdb57a1f-1733-47c5-1080-08def39cd8d0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 09:26:51.4213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ep/aqmzq93GeoGoSR3Tsi1KBJQ/uxvocuT6hlCPrjNCrKu5OOzMzmY0ITvW3+uIPq62L5TNb1Wh67YG3Dt46Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4882
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=819 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608060073
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA3MyBTYWx0ZWRfX2goSs3gN5ZAS
 KaWMK7IxpkTIGKwBxOfiPHRpsp1BcHogH7zrvBEf4dMXYm82krZSkTVCZ/ZAyEiI0sxeHMvuwry
 Kc81fplDHS9qkupdoMJcNnlLxVC1wsmDQBcTbM9QHT5HHZRilMdj
X-Proofpoint-ORIG-GUID: 8Sf-j676Nw6IK_CLgIrzNpCJjxwGY_jz
X-Proofpoint-GUID: 8Sf-j676Nw6IK_CLgIrzNpCJjxwGY_jz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA3MyBTYWx0ZWRfX+kZ1FNU7NIy/
 FmJNy3eYdz0XlQspONvy4pJ3hsOKWMEx7X5rjkmiDjdhK647fV/IBqCHZQYJmQyRsDpQoQP1PQd
 G0gQGd/HmLUb4VA4RiY6W4d4/yuPXgx0itvtoN0jrkyziaSvcJ+3SYUXgge50r5NJ/xIUy13VjK
 5FkuolSCMr6CzJfmo+Y8s0pdY+Ze0tBY+yqyEMv7PyQ7rKSBeKsUYlkQcQ/jhq5MUxQ4LTz0vgy
 kF/VfeXLlQm+As69OsM2BCm6GxLnmxRfb/de9/Q6uyTSvuzHe3Seubd2mLOGHVc84oQNmTWua/N
 kpjQLsBAmU2Ku+0yFitHekkdOh/Q5frSx+gi/fIadIoUaxJ9e2K1G1jDGunN78ZM1PvqrjOtTNl
 EsBpEqkTVjvxdapBYyJ9w0cwtd4/dDRf2GtwfL7CORfsTx08z/3uLDIKKomRp1E8890lrNVYX9V
 cTXe7Ijz/xxlmaMSkKpHpwGQDc8201PB+khskXzc=
X-Authority-Analysis: v=2.4 cv=TsPWQjXh c=1 sm=1 tr=0 ts=6a745360 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=uherdBYGAAAA:8
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=IEq0T590TfS9NEJlG4kA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12100

On 05/08/2026 22:36, Bart Van Assche wrote:
> i Martin,
> 
> This patch series enables lock context analysis for the SCSI core and the UFS
> driver. The advantages are as follows:
>    - The compiler (only Clang) verifies whether the lock and unlock calls match
>      what has been declared via __must_hold(), __acquires() or __releases().
>      This is useful for catching locking bugs in error paths.
>    - Support for __guarded_by() is enabled. If a member variable is annotated
>      with __guarded_by(lock), the compiler will issue a warning if that member
>      variable is accessed without holding 'lock'.
> 
> Additionally, a patch is included that suppresses KCSAN complaints about SCSI
> host state changes.

Hi Bart,

In future would we enable context analysis for other members of 
Scsi_Host or other core structures which are protected by 
shost->host_lock, like __scsi_find_target() which scans &shost->targets 
and requires that lock to be held? Or __scsi_device_lookup()?

I appreciate that this is just the first series for SCSI, but I am just 
curious on any plans.

Thanks,
John

> 
> More information about lock context analysis is available in the cover letter of
> [PATCH v5 00/36] Compiler-Based Context- and Locking-Analysis
> (https://urldefense.com/v3/__https://lore.kernel.org/ 
> lkml/20251219154418.3592607-1-elver@google.com/__;!!ACWV5N9M2RV99hQ!
> J6vIIEsGYaCUO5o4dBP5HeRy8kITKmj51IVOoZN-7h8k2FZDnUuaJGMWAt3E5BL5Xf4r7iNMlthMNat6EJGVFg$<https://urldefense.com/v3/__https://lore.kernel.org/ 
> lkml/20251219154418.3592607-1-elver@google.com/__;!!ACWV5N9M2RV99hQ! 
> J6vIIEsGYaCUO5o4dBP5HeRy8kITKmj51IVOoZN-7h8k2FZDnUuaJGMWAt3E5BL5Xf4r7iNMlthMNat6EJGVFg$>).
> 
> Please consider this patch series for the next merge window.

