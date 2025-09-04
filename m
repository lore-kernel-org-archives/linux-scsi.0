Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144352D4B5F
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 09:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756979810; cv=fail; b=JSHaV2ynqHTr4Uji2qxH1uYQWCjJUPA4nof6X5ZRBvGuv+HsyUGL9HkbEfvdN4uZIHa9kn/oPXosKF9zfMEPsIEBun5JhhSWDx8I9UInv2xo5tG9HbXRELLFX4vmkEcxIMe88s6O5xQ92rwqDBjchjMyyMWZcwIWxo9l6hdScrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756979810; c=relaxed/simple;
	bh=vzMZ+Q+5TXqDMBJojnFH7UvqAlC6Si64JsWWYGJFQkQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lngFU17AlN02RyWnhiQ+nPIHdk+vxYSQpZANt8YW73IeohS3qa/cHCFnzTyzQiOl3pgWYfcS2+cmTvCFhW8duYYX/b6Uv3vwFxezIavGB4EFRCXJk074YA+TR0PyV8/oaF4wsCaHgBAlplxQFq9HWfkxYeOWC31OJR8AeRZpBkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cgYxbqSf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SGz9mZ7v; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cgYxbqSf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SGz9mZ7v"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5849dGkL025488;
	Thu, 4 Sep 2025 09:56:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=V4npPFc7CKJLVPRkDwrG+Ni1/i9wQhYqYo+ZPYTF4jo=; b=
	cgYxbqSfqTOqf8CMniGMEeYTgxCW3iuQ9FOSfB2Z1iDFfQy16PjPChlQQhr2X7VR
	HC7V+XFsFtoldLBBnG/gO2LcyjmAsB9Clf6hPFmYxBj7r3Wfa9ZpA5KYVdNH8OB7
	yeDWVZZxS+C4DKT1AnMKQIjKrm8iDbxCCDuzbjBteUkMHfzRnODmSlpM+ePtCCD2
	doyNjF/6wTKJwzrFdWWEV9y96A51sR69jtdHZIvxWvRT8ssaHVIVbtbJZ9DIeDwf
	MwsbnoJDU0vUkRVb2rRtj9KV7hRTY9YY8NWNYH9AdCUX+q5plq7/39bQIhM06bXZ
	zEt4m9FE4A3HY5pDSiruQA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48y8b0812c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 09:56:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58496nNU030982;
	Thu, 4 Sep 2025 09:56:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbfrvk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 09:56:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S85PfSkvC1fEtQxW5TaBibSKvTdcEBTxFkpNmIc8Vrx4ssGA6EDYz50+wa+AQgKFdwk7dvIDa1aqNPNA6NoepyvvfatVarC5sfqofu/RNvqiiD2PG/u7rMSiPqLkC+HzaBgSRTe5/Qzyhtf6zIm2vrfnbfRo5ews1I8M5vC1xyFMz6/8ezcQKUu4nYG9cafW93QmZCn+EmFF3nRNLECwS3Iw8OO7xpvIMqIfot1fTU2YNbUrnqOmUiWXmY3fl70JBYHiwzPaHgtzXP+mS1UKgFsRYnZsVH9NVsWeRO9faY1OtP/IXS+mL25+imPJLpyvJFmWsDQKJLFTSqZlfZuVlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4npPFc7CKJLVPRkDwrG+Ni1/i9wQhYqYo+ZPYTF4jo=;
 b=hvMOgG1X6UJ3F6S+Szt42JFabtcNTbcyLGX1fuvWPDh19Z2bcDukSBYOvK2p4krStruClyG2w5D2QYJH1Y19fr+Cp46eEBTtuptXRNANc+9UF4dfb1nPl8cilkgi2pFpKsmOz1aZ/simq6m9Za+86xoblmJ0v/41Bi1Ew11UIXUH3jm/X/f5n2jyK/N703GnJulMx8Dt//m/BHlqPcxxIf+/NLjhLmQCK2xnlukBjiWllJ+PtpsnZBVYjoxKB3zZ3mTOudjEiExEqfPtymzwkpv/AKUwYHEHB9CTJTgb5YyV07iQtRJ2iFqHG8qGlXxNB4rRj5sHTyTeK3fYDhL0aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4npPFc7CKJLVPRkDwrG+Ni1/i9wQhYqYo+ZPYTF4jo=;
 b=SGz9mZ7v67xOLbbGPypOVwReX7zwWRc31M6OT5OaCDIrVFKr8QZPlt7LRKtvmXj/Eflk9g+lKI59hn1ZdbE2s2faujmz5la4d6BBw71I91E2gzN7yYxR302LefPpEKinBpyTy/NkRQj8vpKuvRWHDITpt7lq9hy+Jc890SsH5KU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB6459.namprd10.prod.outlook.com (2603:10b6:510:1ee::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 09:56:36 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 09:56:36 +0000
Message-ID: <b9ebed12-0e89-495d-8aa2-a615603cec4f@oracle.com>
Date: Thu, 4 Sep 2025 10:56:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/26] scsi: core: Add scsi_{get,put}_internal_cmd()
 helpers
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-6-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250827000816.2370150-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0396.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::23) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d1d2e63-2bc0-46a0-0fc6-08ddeb9955e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlZoMVYrSHZCMlB3UkpSR0Q2S3BWeFE0M1NtTWNGL3pvTG56R1JUeW00ZTgr?=
 =?utf-8?B?UEQ3V21PRGM5Z0xTMDVYMUMxK2tBVjAwNnlrMUZqYm95aC90VzZuSXFTRkhR?=
 =?utf-8?B?QjV2a1h6aEtZOEdYb1U3ZzJDMjFwbnYxZVJwMjJ4cVNhN3lSQ0FzUHdySE5m?=
 =?utf-8?B?TlRXTEhrUlhydkR1SUJqRDljN1E5N2o2ZmdWcGFPTWw3SHk3NW1UdU90YnZ6?=
 =?utf-8?B?d045c3c5bjJiWlRYWkZjK2d2NUxhQkg5bklVUVlrOGsrbUtrNExZVmwyQlJL?=
 =?utf-8?B?L3YxUlVZb0R2NVJ3SlY2RGVvMmJBUmE3NUppdmxJWUhTUjhOc3FIRDNyZXpa?=
 =?utf-8?B?TGdCa1d3N2xSLzBIdTF3anRoZDMwTk9JbTY4N3FGNUVSb3UxdFhWeFp2MWJF?=
 =?utf-8?B?N2ZRSDEreHFsQ3RLS3NsUXFLTEwwNHRiMzhlbHJXSkY0bDRBZFdCSjFTd3NW?=
 =?utf-8?B?UFkwVmRENlRxSGs0WXZJb3hrSi9Ga1pndm9FWEF4QjZuZXNGS1lwQTdsQ0o5?=
 =?utf-8?B?MFk4KzN3a1lzUUJFSzF1ZjBjWXM0bGh2cWs2OGFpWU9iQVF4UWd3bmhiamxE?=
 =?utf-8?B?NWxDaG41czBhSmVSNFdIWmJNQzE3KzVWYTY3d21zWWFvVHVZeTJtQkNvR25n?=
 =?utf-8?B?eXQ3MVhUbWQ3aUR0SmJZSmE3TFhJS2FtOTBVbmFTQ0FYaUFyV1pydFN0MTdv?=
 =?utf-8?B?NURhdWYzK0ZLVXNnUmU5OStaSFhoY01Qb2FRWG8wY0ZYcWdnMGFjMTNXZWNK?=
 =?utf-8?B?ZUsxenp3dWc4ek1ESElqa3kzUk9XR3hFNm5sT3F5aWVnQWVhZWNiU0FteE9N?=
 =?utf-8?B?TG43NXNUaG01T3FyUnhSY3VtWm1rTisxTHNkSGlRYUdVTm8wMFpNOXBlL1ZR?=
 =?utf-8?B?UkhZUlJoM2hBT1BOczJucXpIdGNDc0JuanpEUy9JTW56NnZjSGJPQVJ3T09Q?=
 =?utf-8?B?OGlGdjVsZlhVTUVUMFRLN1dKMGhIOEYxSnlCaUQ5cjdVaFJWNlFjd1AwMjEx?=
 =?utf-8?B?NEExZE04YjR3SkZ5a3l5Q3lpV0JHVXVieEszMjJKU2lRcEJpeXUxK0tLaWtG?=
 =?utf-8?B?TWhRQ3pHSEpMZTQ2VVVwZjVlR0ZUOXFnTFdSTEZKVUZIN0MwbXVuR0VEWXE4?=
 =?utf-8?B?TWdGNmZnVWcxelRub3JYNUdhMytiUkFsaWVDbit3RXdwVFJHanFleHE2aFRH?=
 =?utf-8?B?dmdPQVRBcVVaeHByRzdOVjNNSE15Q1Z3bnFBSUNxdTlYUFkxWGZoTklkazdr?=
 =?utf-8?B?Zzg0M3F0ZTlrVzg5Y0JaUE4wQnd1NkJ4NnJMaDV2d3FJWFgveTd5ZG1vczhJ?=
 =?utf-8?B?L3FJMGVtNFprQXBEY1BRSUpwczJzeFlhdUtaQmFFQzdJWVdxSTMwbWt4OTZF?=
 =?utf-8?B?a3NGTFk0UCtuc3o4c1hPLzNnSFdaWEE4Y2UvajV6Y2diSnFabWw1elREejYv?=
 =?utf-8?B?RTFvT1h2QWNDRituRUJOYWhaZitkaEZ3VENYbklzcWlXb0U4V21mcTE1ak5C?=
 =?utf-8?B?YXBSdkZqL0h1N3R1aDI2d2RHNFd5T0p0YytpblJyVXFsR3QwQTBIeCtRMktV?=
 =?utf-8?B?ekRTWE9BRXVMNDJFcDZSR2lHRVhScWI4eHNnNDYzU25RZ2NiaTFuaFVwMm91?=
 =?utf-8?B?cElzVlgxaXBBZUp3OXAwVllzMDIwZGJpM2RjaG1jRTd5d0x0Ymx3ckNtK2M5?=
 =?utf-8?B?RGdiQTVtUXZkNmtMSnFFS2hWdGVTV1dmMTZlMER3QkVMT1JSWU5sUWVUaGNn?=
 =?utf-8?B?Rk4wU0trY0ZiRnFCSk4yWWg0Zi9Pa25lTW9rQXZYL25PY3g3dkUzS1cwb1Bp?=
 =?utf-8?Q?BPIdayQVdgAu3xTzc7rLmzarYqEEmqM+5PqsE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WFFRMENjRVJVOHVpQllVdzg3dHMzNXFUN3d3ZlFGaUEwS05KWjZ4N20wRTZU?=
 =?utf-8?B?a3drS2JxWWlOTGdtby8zSmprWkFsNnY4TFpySW9RakhaVEtqM21PWEZjSnJl?=
 =?utf-8?B?YndhTFdCOUdQMjlzV2NZT1RhTWdvOEdHcCtnb3N6NUl4NFYvZlowd3ZOUHBJ?=
 =?utf-8?B?OXBRdU1WaFZiTHgrK3VzVWU0bG4vZUl0eGU2ODVDb3pab2ZXVlAwcXR3Qk90?=
 =?utf-8?B?VThLbTFOR05mY1RwU0pseGYrY3NZVGVmN0FsVTJTWDFqeEdLSlNnRnVPTW9r?=
 =?utf-8?B?NDJLNVNJSGhLNys1dUZaeUJuZHNHcW9NUnJBRXVXemJwTW1FZUk0MW5NZzJx?=
 =?utf-8?B?dmRDRGRUT0l6bEpLRWpjR0hkUnF2dlNwT0psZnN3Unhud0JhQ2hCNUZXN1VE?=
 =?utf-8?B?UStjeXk4ZGRMaGxWTFM5SU1HQk1qcmRnTUFEMGllTUEvaHpER0d6K1FJNXJz?=
 =?utf-8?B?SzJHK0ZNSUlaZ0o3cENnVExHTWFTM3VOVU10YXVtL3AxSWpnQjd6eGdsakl0?=
 =?utf-8?B?dHQ0bDhBcHl6TkZjUHZrTnhjMjcrQUp2ZTZwVVZqWUVSNEc5Q1RuVE1ETVE4?=
 =?utf-8?B?WStrdDF1aHpiSkJzN05ZZ2pSc040b1pXeVlGWHRxRCtveVMwQkJTSVM4dDE5?=
 =?utf-8?B?RXlKUHg4eHRLUlY5ZzhzdThNNGNPdG5teDdncVowNlNiUVY0TTZqZG9SbXQx?=
 =?utf-8?B?allSUGZDWVFaeXpleXlSWXB4eTdZa2YrbjNMVlV2akJLRXRBVDAvNHVkSXEy?=
 =?utf-8?B?RTgxaWxhN3NHeUVKZllSZHEyQTlWVzV4L2hvOThCRGVEcUw0RU02ZWp3ak9E?=
 =?utf-8?B?RkFvbDcxbGRwN3NkYUEveWxaZjJkRUZoV2JOK2JPRHlQZDFSNzlKZ0RORW9Y?=
 =?utf-8?B?ekFhYWplWjlFZzFiK2VjMk8xemxocGVvSTBxbUs3NDI2SVRHNWFpcVZWUGNB?=
 =?utf-8?B?TlU2S1M4VWNrcm5CZkR3T1FLcHJMcnpralZQcCtpUXM2bTRkc1JUZHQ0Umt6?=
 =?utf-8?B?ME1kYXRCR29TWHBrZDVYdzNQZ0g4Z1IvcEtHcmo2NmZFbkhkc0t3ajFTOWkr?=
 =?utf-8?B?c2NnalZibU5tSktqOWtTcnZBUHJhT2NBV3JTOGp0bHpva25tNmorWVhGelZa?=
 =?utf-8?B?eGRBc1MvMXJ4SVpJNVBlWWRhYWZwNHVQTStmQ1Z5ZXMvMElEcS9IK0FuMU5m?=
 =?utf-8?B?NEdBczVIVDJheVdXWDVNc1llS1ByYllGc2l2RGtSeXNYVmg0SGtSbDNDbGpQ?=
 =?utf-8?B?RURhZWxDQXdyelA4R2V4SW9tMzNRWHJJRFhDMDVqaUlRR0F2Vlk2Z0hRTU9C?=
 =?utf-8?B?QnBocVI2TTVuMmFXak9QOW9nL01yeldVb214MDVENXVzaHVBb0JtY1poeWNI?=
 =?utf-8?B?MUFUOHJBbG03QXdjMUV2cWxtQnhqcmlXNDF6UGFRWTcraHlKaEFZOEhZZTRD?=
 =?utf-8?B?VTBtUXdtb2FyRE0ybUlUdGhZYTdLc2dwVUp3SjlVaGNFZlprdjdJTTVJMmFQ?=
 =?utf-8?B?NEluTlpXa0Y5UmZCY1g2ZFZoSFF1M1lBL3paRFRURktGSHNFL2IxeUJaMThv?=
 =?utf-8?B?NStGU0p6OHYxK0t4dUVuQ1ZhK0lWdkNEQTd3SjA0VW5qL1BBREV3QlJEaEtQ?=
 =?utf-8?B?YTNZcTlOdFU1SHNaNy9TWUdKTmY2N1BYL1JidTJuSnE0dXJhSnI4NlJ1MlVM?=
 =?utf-8?B?aVVPUmxRMERzUnNPYnVvN1ViMXhKRzFBNzgwUXJuUjBDeEFKVHZZTEJIR0Va?=
 =?utf-8?B?VjdHQ1lZWWsyUjcxYzB5VnN2SXJ2cHZtaGJLL2xHT1hIWUZ0ZExXeFFoOTVk?=
 =?utf-8?B?RVFycUpoMHgxdUI5dURpNWtmY0V5RUVJK0hjRWhIR0NJbE5IKytlMG4vYTNv?=
 =?utf-8?B?eHJJMVJFaU44bWp5VTdwNHVmcGtUM1hrTnlHSEpRckM1SUJoR05sdW1LZ1lp?=
 =?utf-8?B?WXhaaXlrTGRWejdYT1plbUlsQkxTL3FwekE1bit4MzJpZXJ4a2ZkSHk2eE5N?=
 =?utf-8?B?VXJ5SDNRTlB0c2RQbUtlWEhaUW43cFgrZUVYSWdWQnFpbm9GaC9NNHEwMHFM?=
 =?utf-8?B?NkRVc1lvZFUwQVh0Wnp2eHFHT3lzN0dERVlGZUlheDVPZnYvbHVCd245N3R5?=
 =?utf-8?B?RisxdE9GdmRlMHU0bDRXVkpqeUQ4cW9CWGZlMkR0MjE2SXZyTVVoWEFFT3R0?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TUfsKNcZEHiyVihL1nCqGz9KRhBiqGZtBj+ud/7aM+Rlzyi4Iz35nHMnu5rvPtKtK+B6CLIW3cgWesp5+roXkdQAoTszup/STguBuAM5AspEixPCzb66O3cmcR65F0LgBWJ0klQKQSPchbbuCDYw0Y7cKao+K1po750n3Gt5T8V901i838GR381T8rcU5rW7KcDCIh3TkPRoRqBeYcimj9GEmJmQj2kqPUbWFkVwAYbiNrozjxovqsxnOiEEHlm+q9jlKvkjaVlxJeF5no08uL1evKgNej7Ul357gmdo7WQ/9+pQ/7nRSahbyMoCRIhSUk+VB0CoH9NqAGksCrRO5JyklWhmXJVSwFyuJ9Eh8a40ajjgs+/Cd/50vVaKIbEwViUIB3+yx3D2eZlUq+6e9Q7zRSugnDJwWjSe20EnC3AFIFBI5qR/SUHRoczTUbgy5avTQZ3a/oGNVg2gEvXW6areVTcdjOZFz1pD+uY3E7VS8Sp+HI7DprIBMNOwUv3AgcW6XhxlYJFhOTDQ5AqlSKbbodbSB3z6Rpo+Ga2CHGkJFmt51NIGpJbTc4W7/kD2nIwB0cBKb1aDcvCDqM12MOPtEDybJchVpywMQtXxz1o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1d2e63-2bc0-46a0-0fc6-08ddeb9955e4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 09:56:36.2135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cudkPIonbEzo+nHvFaURGr5cItbRXBpitKMD7E2vvqUNqXuTjdbU3fxuy6e+Xr/s8k6H8otVLejgFGk6uE9lYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6459
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040097
X-Authority-Analysis: v=2.4 cv=Yc+95xRf c=1 sm=1 tr=0 ts=68b96258 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=N54-gffFAAAA:8 a=f5WLSRil6HtUbeVGyyoA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13602
X-Proofpoint-GUID: CDxdeNIP59zisvMSya9ARWvaNnTvjc_g
X-Proofpoint-ORIG-GUID: CDxdeNIP59zisvMSya9ARWvaNnTvjc_g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDA5NSBTYWx0ZWRfX3IU8kWOKCCmS
 URS4z4aQvQKFJXiD6xzUHmJ8oYn/NipZsX4PUH4cGBBOAqlG0uxgkIPCwUyv9QOAx/YPT+TuCOR
 9Qmnq0UOPGAjz/C8Z2VBQAaCWbhAmMZ6z52CO5uPJrmdZSXfTGwVhXGGi06vZEu4M0VY7Q6QyCN
 Kc7yQct+x4pPvZVjZ/DsbnLcp0FPY6XUAlFXSL681BfduqirGFAMooOJQdmwQeg7GmM55iAc/JI
 beZUavlEBB7IPQIUvv99hNqufH8hkT9ddmLVZhJSl/Syz6pAiWh6ao8VyIhclaUd1gLvYNnDWnW
 U/lBgOMlGRURfglULcnqP/J4yfogCz5jv3arFbnY2GQ3VSkFZbNkGbYaWyft7Woz+nUzNfqRKKU
 8j5kwsZ6qj9RH60gXTuunTFXcydgvg==

On 27/08/2025 01:06, Bart Van Assche wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Add helper functions to allow LLDDs to allocate and free internal commands.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> [ bvanassche: changed the 'nowait' argument into a 'flags' argument /
>    added scsi_get_internal_cmd_hctx(). See also
>    https://lore.kernel.org/linux-scsi/20211125151048.103910-3-hare@suse.de/ ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

did you consider reusing/refactoring scsi_execute_cmd() here? I'm just 
wondering if it is possible.

> ---
>   drivers/scsi/scsi_lib.c    | 80 ++++++++++++++++++++++++++++++++++++++
>   include/scsi/scsi_cmnd.h   |  2 +
>   include/scsi/scsi_device.h |  7 ++++
>   3 files changed, 89 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2d81fd837d47..c988e6f8194b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1247,6 +1247,18 @@ struct request *scsi_alloc_request(struct request_queue *q, blk_opf_t opf,
>   }
>   EXPORT_SYMBOL_GPL(scsi_alloc_request);
>   
> +struct request *scsi_alloc_request_hctx(struct request_queue *q, blk_opf_t opf,
> +			blk_mq_req_flags_t flags, unsigned int hctx_idx)
> +{
> +	struct request *rq;
> +
> +	rq = blk_mq_alloc_request_hctx(q, opf, flags, hctx_idx);
> +	if (!IS_ERR(rq))
> +		scsi_initialize_rq(rq);
> +	return rq;
> +}
> +EXPORT_SYMBOL_GPL(scsi_alloc_request_hctx);
> +
>   /*
>    * Only called when the request isn't completed by SCSI, and not freed by
>    * SCSI
> @@ -2139,6 +2151,74 @@ void scsi_mq_free_tags(struct kref *kref)
>   	complete(&shost->tagset_freed);
>   }
>   
> +/**
> + * scsi_get_internal_cmd() - Allocate an internal SCSI command.
> + * @sdev: SCSI device from which to allocate the command
> + * @data_direction: Data direction for the allocated command
> + * @flags: request allocation flags, e.g. BLK_MQ_REQ_RESERVED or
> + *	BLK_MQ_REQ_NOWAIT.
> + *
> + * Allocates a SCSI command for internal LLDD use.
> + */
> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
> +					enum dma_data_direction data_direction,
> +					blk_mq_req_flags_t flags)
> +{
> +	enum req_op op = data_direction == DMA_TO_DEVICE ? REQ_OP_DRV_OUT :
> +							   REQ_OP_DRV_IN;
> +	struct scsi_cmnd *scmd;
> +	struct request *rq;
> +
> +	rq = scsi_alloc_request(sdev->request_queue, op, flags);
> +	if (IS_ERR(rq))
> +		return NULL;
> +	scmd = blk_mq_rq_to_pdu(rq);
> +	scmd->device = sdev;
> +
> +	return scmd;
> +}
> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
> +
> +/**
> + * scsi_get_internal_cmd_hctx() - Allocate an internal SCSI command from a given
> + *	hardware queue.
> + * @sdev: SCSI device from which to allocate the command
> + * @data_direction: Data direction for the allocated command
> + * @flags: request allocation flags, e.g. BLK_MQ_REQ_RESERVED or
> + *	BLK_MQ_REQ_NOWAIT.
> + * @hctx_idx: Hardware queue index.
> + *
> + * Allocates a SCSI command for internal LLDD use.
> + */
> +struct scsi_cmnd *scsi_get_internal_cmd_hctx(struct scsi_device *sdev,
> +			enum dma_data_direction data_direction,
> +			blk_mq_req_flags_t flags, unsigned int hctx_idx)
> +{
> +	enum req_op op = data_direction == DMA_TO_DEVICE ? REQ_OP_DRV_OUT :

