Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AE1111BF
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749825119; cv=fail; b=FZJp5kyDo2q1LBvkJdB8aoWGmS64Emvm2m+9jA3k2F+bWbfja455Rjf5YcgOLmkD4CJqIHCFvoEl8WH702ImzrAC9M/CchyqY6r+BeLgTv38J9LxPcAz/1ejUbYwvss6C9Nkm1dbbvhzOsNvDh5tg5zZLdAz6HXrk0wrDQ75hwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749825119; c=relaxed/simple;
	bh=E7raznZHcuQVlgUYskUZs3FvUw0KViEFJhKTUHTGwPk=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YDt84GVFF1pH8Lg3KemH7yhzxDK4YfbvImpdTyndQqA3ZLJIvtLR+0jgErPwMB7VwpYoIpFgGvJao0oOgj/MS2j9SXo6zGewVNk25rdJDg6dEBTqSrI7UQOaJldiIlGy5iQiQ6TosQ/NoxpqjO5NohRXD4rdcxJiu/Ib88iPIoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cWghql+T; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fUL5S6ZV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cWghql+T";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fUL5S6ZV"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55DCteMO020279;
	Fri, 13 Jun 2025 14:31:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NnlRZGCpG6Lrwem2ZtSaST22+doXa5f1KNObUdbKO+s=; b=
	cWghql+TUsPhrSmo1I4xX70UiJC/VZkTYb195DPYHs7Fe6v+k7NIlKOz2U0X4Fe5
	YVVJeFv9rGHF59M13HbPVrgZbwP5T1yS2pmq/ygBEcunv1eTlZ9U9k9WcbxAOA+W
	q7TP0kn+//j4wzChFsmCGqHRPxXqU0IP33hsxP4SRjsuJuhAzDpvYycyngkCHpGZ
	U98JlRB5R1EiYi0JfnxMsA+hYsp6oxkaUshCUmyES4XDJZPWxCRuHrt9Ij+FooQK
	aVJU8qFvkmaRMkO0BBBTYdZHIFYpFvI4jT55g+0pcgo27hGc5nktSXJG1PcvkuVq
	NRyA0PD1RS/F+4NhqzrebQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474bufbm55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Jun 2025 14:31:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55DETlRC016782;
	Fri, 13 Jun 2025 14:31:53 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010018.outbound.protection.outlook.com [52.101.56.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvd05q3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Jun 2025 14:31:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pTyD01E+1Wym4Ebu06SLMzFstCgkOWEBhr/rO7htd+4tS92eom2HzzSKPyUVsbTnM5Bm51BZ+dYz+x215rlbYVLFKZLkXbNu3Qmcs5K1DUOi/mR44LcNo2d/dmaW1cF3XyWf1zicV6JqdROHL0kVb8qqYgYWygGujs4s71qn7j4bNg3Vd7T89VrF3Lr1X3Yg4dXb9T6UcfLqqVx26GW05w/pplxWug0iPSnKs8GvYT5Svy2ar0q/M1jng4TIq+9AVFJ9a9crYMvm/bQIO/lTe356hOQpy9H+axGpyYx83TFOUC9ZR36ZK1sna8mKWBy4KfE9bl2iteAMT/mOp00hVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnlRZGCpG6Lrwem2ZtSaST22+doXa5f1KNObUdbKO+s=;
 b=oHKNqPA12pc2KjU7kS68T4H68+/ABCepuj+H+34SOd6K2ZV2YhZU1iwOmejACHBf8ET/zV9fo6PWWi3Q+pUQ6KWZck5ZcinHy/mK9Y6tVBgVGFkXl1gc46ghZHI7FwZXKqgSKHn85PgOFX7Lp4lq8L/RYmzIpvt1WYuzQ9mLRS40NgaRUfPs0pwGA/cc01tIieUv9FBfTbPl2AthTfzNQZ3tQ6QzZtRWtcg/CWhcyaVrTW+Zl+dDjcWawZHZU1vCLgC/V9ZGzHik36Q2bQdmES3LWh3p0fAnAP7RKx2CYjPlQYcJwC7REJn5mACYNpBeGCQyZmN4GghxnBfJXgIi3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnlRZGCpG6Lrwem2ZtSaST22+doXa5f1KNObUdbKO+s=;
 b=fUL5S6ZVUNu0uf6lwy0z17rH3IsYag7cOaLGLPaSyQ/orBH0pGoykZil4HA/QxV+ZnUWQiFmwxiVjHRzOI2G/BMOaZp+8o9zTSpIwP1eax1OJ0Uw7E2HGl5RBYUHR+0kuBxUNM4rjlKaB6cB/qxiwD0m+l6LY/863ho0AL3PcQI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Fri, 13 Jun
 2025 14:31:51 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 14:31:51 +0000
Message-ID: <b20bde78-5f11-4700-9f99-e9bf4bc31e85@oracle.com>
Date: Fri, 13 Jun 2025 15:31:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] scsi: sd: Set a default optimal IO size if one is
 not defined
To: Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20250613062909.2505759-1-dlemoal@kernel.org>
 <20250613062909.2505759-3-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250613062909.2505759-3-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0080.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::13) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB5009:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e8156f8-94a3-45b1-1bbd-08ddaa870948
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1d5WjBWRnJKNjFuelkzMEUwNlM4cjVLM1g5bGVCWktLTWcrTXhXMTFWdk5j?=
 =?utf-8?B?VHdtbStWNnpUamdHQjFFRG96TjAyQXJXYWRzZkdGZklvYWFhbXpuckl0OVZL?=
 =?utf-8?B?NHhrSUcrRExWTWxmaTA1aGhqR3dCRktiT21PZDcyenJKSXk0VlA4dFh0NU42?=
 =?utf-8?B?NUZyTkhlYWc1eExrMW1SOEJJS0RHRzgrRm84UmdZNWloY3p0TDdnVnFPSTNy?=
 =?utf-8?B?VEwrQVhDaDNKK1BFeUlpc0wzMU8vRkhic2o5cW1BdlJxWnBoK0p0V3ZBcjlv?=
 =?utf-8?B?YzRadXQ1N0FjSjJBUEhlbDFaU1ZzbTRSL201TytYc2l5MmEybVNhdkNIZHhq?=
 =?utf-8?B?aEhqUWJSd2k3YkJSU1hnK1QyS0NvL1lrQUlZT3hCd0NjWWxvOTI3ekI0MmRM?=
 =?utf-8?B?R2dTOFoxNzgyY25XbXc3NnRjWkxjSnM2ZmVtYXRUdy9xalJRT1YwRGI2cC9U?=
 =?utf-8?B?OW9LMGhHNlJlc3ZGN2VCNWszVjhOdTVPWmpFeGYwakRST3pORzVKK3RRY0w1?=
 =?utf-8?B?NXNXTzI3YzBlbmgrRy9XeTcvMU5wWFQ1Mk83QUZDYjNiWVg4RXZBYlQwTmlZ?=
 =?utf-8?B?UDM2bUVPUWNEWEJwRUlGNmtmcWpPUVJiZ1UrcFhIcWNpdDY1QUNONG0rSGpw?=
 =?utf-8?B?MHNBZlFVOVRJUnNMb2JyeDh3T2lnTyt4QXllOHdkRlVwa2pOMmVtcnBPRWtx?=
 =?utf-8?B?Y2ZsV3lJK1FnVS9MNEkyL3pDbmtDNG5mRU92NTUzOUwwWkhTVVBVTkdhMjBp?=
 =?utf-8?B?d0QvVlNhWW1hU05hQkVML0c3Zm1XNW4vK1QzWXdBU0ZIdlUyQWRyNkxxWW1a?=
 =?utf-8?B?eWlUZTJZQjVDclJ4cVI1Q2kwbnZVbWRHNlBHMXpubjlaenZmTzF4UW9rVHIr?=
 =?utf-8?B?Sk10VzNXQ3NuQUVjZ1o2dWw1RVNUR2tQMXpwbXpBejJGN0xZR1pSR2hVTHkv?=
 =?utf-8?B?NXVrMU9YejQzTUpmb1JIT3IwT281VzVBTHcvV1VTWFl4ckxMc3hhUTFqajNl?=
 =?utf-8?B?dVgrTWlBNVdwTHBiQ0ZEU0E0MDUxd0JnTk5HeVFybWdXUDJxUnpoSDBURnJw?=
 =?utf-8?B?d3ZjMjdLZXUvS1dTTDFET1ZKZXpoRWRkMXh3RnlGZEM4M2t1RTBZR1ZuZTZm?=
 =?utf-8?B?dzFISDFzbEpZQXJIMzdJcUxDa3Z1YjFuRWlvcVpHSjJtS1JCb21HMFFMTnFq?=
 =?utf-8?B?cHlwTWFaWmlmblIzdmw4T3p2VHowd3BSaUpJWmpFL05HR3VLYk5FaWhmOG1Y?=
 =?utf-8?B?d0pqTUcwK2YwcElLODFzVHNVK2RzYkZWSldjWlVpcU9sam1mSXpuVnpER0hC?=
 =?utf-8?B?M2YrQjgwYnluY0xKeWs1cFRuNXpNdkRSQUtZdW5ud3lkZStTUHNYellRb1RN?=
 =?utf-8?B?QytGWlprYWc0ZVBWVDVocFFTRnBkMUFPQXhKYnNzOEVlMlBsSVlhWFJ5c2lN?=
 =?utf-8?B?dHA3MDBOWmFWOTlTUkR5b1RWU2ZXQXJJNXZsTExUTzJnaTcyMkVuY0N1WUhy?=
 =?utf-8?B?bXdaWUwzS3IySU5aelYxdkx6YnNSUUg4Q3VRMUNwRFVpVTQvUXJKKzZTNVJa?=
 =?utf-8?B?cHhEaStDa0R4NXc2THE3bzNVaHVQenJSclYwTUUxUGc3YmRFQkZsWlRtKzJ0?=
 =?utf-8?B?dGZSemxsYzRpNHFjWWdINitnYmhBQkxJK1pCazhpdGdhcFhKdG1CWjFGeFpU?=
 =?utf-8?B?RUpNZGQzSUZnZHNLOG04WkdQUFFFc2JDUTNHaUxJVUg4bTNNdkFwd2owcEFR?=
 =?utf-8?B?RytJQlNVNm9GdHY4SDRWancrR3pQcENZQ2VXeVcwaCtKcWlTMWFDRXUrbEs0?=
 =?utf-8?B?V1dZNzhjYmRQelNzbG5MWlQwZjV5WjBOSkRuR0FjNzhTNDJCVWZCenVHQjA3?=
 =?utf-8?B?VE1yUzE5WjJiMWVEMUd0WDBTdzVSQ2hwZ25hQkFiMzkyUGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cjdhWTFETTZ3LzdOUGtza0xTSHhXYUdEb1hwZDVkcUpzVHh5NWNBY2ZFczh1?=
 =?utf-8?B?eU9RSVMyU0dNMnhuQmsrYitac29pRWlqd0g0WXo3cm13dDVVTUtvM2FwcjZV?=
 =?utf-8?B?djlxYUZrUFRWL205YlJUODZCQVV6YWsySElwNkhwakN6NmJ1UXBsUnEyZE5E?=
 =?utf-8?B?OUVMa1liSjVlWmF5Qk9YeWlLcWZwR3IvVDAzNUlwUmpqRzhFS0xjdXVCRThM?=
 =?utf-8?B?WHBFaGNkTGRXWEJXUUpyaksxcnBBZ2F0ZjhMZm5XSEd2UW9VUHlIekVkU2s3?=
 =?utf-8?B?TllBaXd5MEJUaW5SbEcrQXV2M0xwYUEvdDJtUm5leVkvZDhXUTRuQ3NoRnFp?=
 =?utf-8?B?aXNYcTg2NnIwQjZ6dGYxN296MjBOODRQSllRMWx5akFtay9PSEJqM1BuZ0h6?=
 =?utf-8?B?bGQvVTZVYmV5THlQSnZGZE9rN3U1SURyQ05QNkw3L1haZWVKTTZ0ZzZib3di?=
 =?utf-8?B?MFVodUFvZ04wa0E2RllmOVFDUTJGYTNSK2VjRUNJRi9kamtKN3JzVzVjSkVI?=
 =?utf-8?B?NDRqemQzbkRsdEJsSEptTkRHcFBFd2g5Q3d6cndVbGJWbXdaMFZOSkt6K2xk?=
 =?utf-8?B?TGhrZ2RBTVdDQUF3RVE0Ym9pdUcrOUd3QS9oYURHMng1eWhSWDdVQ2FwMm9J?=
 =?utf-8?B?a08xejhFT284S3lYeWNBNTdYNnJrd214V2FjWXdvU3kxSUNIZWw3dUdIbEhj?=
 =?utf-8?B?eUFuTi9LbysyRnNWQklyaStITGtPSHNvTkJFSldMbTBDekYrRzFsQ2ZSSVpy?=
 =?utf-8?B?UDFScVR3Zi9yKzVVQ0pQbXo5Q0RONFZmQjhGb005K3BWOFR6YVdFUmFwTFp4?=
 =?utf-8?B?Q3pUQTNuNExEZmYzcUU1Y01HWFpFNE1YWFlqZ3dLWm1WS09NOTZ5YUxBeFFy?=
 =?utf-8?B?UnlRT0JmUkVhMHpTY3ROdWtyaWJIOWVkWTVYK2hhbW9ubnp1T1BIc1hoK2ZL?=
 =?utf-8?B?d05LZG10NzRXRnMvcG1xTzR2aWVvNDd6emdwMnNuTmpaaDdyK3lZcFVkRFdU?=
 =?utf-8?B?WUEzd01FbHErc25tN0srOHRxbHpkd2VzOGpmUzZwTk92MjE5QmFGMmhuOHRt?=
 =?utf-8?B?cElUNU5ZZkZsREtWeTRlaEpkNkdWMlF6YWxlcEJVRWwzYkVOOGNxWmRwbGtE?=
 =?utf-8?B?a0hCZlJNWktmWFc2WXJhVzZQdytzb1d5RjAvSXRvNTk3dHdrZ3hDZUp5bnlB?=
 =?utf-8?B?aEw1aDlsclhwbnk1dEkvSks0MjJFTFFqSTA0dHNpU09XSXdTWUFLTURLY2F6?=
 =?utf-8?B?bDRWZjVXUWNjZVM5MzRybUIwMERHdmlwaTdCRTNvL3plWjNTNmlJck5rUkZL?=
 =?utf-8?B?SnJ5emNlRVgvQ0gxUUNzWXI5RVM5Z01MNW5scUZHVkxNZVJ0UkZ0SUtId2Fr?=
 =?utf-8?B?bnJBbys4Q2lCeWUxUWVsRG5XQzBiVDAxeFpxYzVNenRRWFRkOGVaNW1zK2Mz?=
 =?utf-8?B?MVRtUDVHZ2ZSTmt6RTMyT2ltY0Nod3V0T1VIeVpPZDRGNWNQU0RTeUpRdFY2?=
 =?utf-8?B?dnFCcGhUYVFxMzVESGJqeGhMcFprcXdjdzNCWkkyS3BpMDlMcm94aE8wdldP?=
 =?utf-8?B?UHJIVjMyZ3Vzbi8wd1JkS2Q4T2crNTBLVXNYSHU0ejhIOHFIcWptczFkbWZJ?=
 =?utf-8?B?eTM2RHlvaGVJVHhwS2tNUzR0dysyek9QenE2VHBSMU9LSmFNVE9GUkhoRFBO?=
 =?utf-8?B?RkxoSXpjZlZRZUp2UlZHU2hxSi9iWkF1VmhjZ1ZRejdYV1RRY2M4RHl3cW1a?=
 =?utf-8?B?aTJwd3hjbDJFQSsrdnE2T1BHTk04MUthSzg2L0MxMno3b0l5allKZlJoakRT?=
 =?utf-8?B?SFAwNE9XdGVUQlRYbHhtWkY3NXpuQ0lQL296M2swWk1sMjhBY2xaU1ovN3JD?=
 =?utf-8?B?UEFVOFNVSzV5WlAycUhjOEtsUzdUUyt4SmgrZ0JvU3AxZ2FpT3JvQlJ1VFZv?=
 =?utf-8?B?RDk0SHRnRUc3R0ZZNERCdnkzcVhtYk93ekJQMmxtWWNHMU1pZEVmTDViOElG?=
 =?utf-8?B?YTZ4TnJKVGZ1S2hmTWVpbGk1K0hkbjl2VjlQY1EzRE4xWm9rMXNRV2RsWFNC?=
 =?utf-8?B?NGY1RlJCTzNDRHhXaksxSWgwQVhYcHFQeWFGOEh2ajdYWkRxRkYxVEhHcSty?=
 =?utf-8?Q?wmkDhFLVLF6JZXRPVJbpsZYhu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	b8fOHHYq4JbrWGQcWpF8KAHrBxccSE4UIaooiiBuFBx7PQCXpTQcbeyHdMm/n8V7hzCyYkytI/Nlf/xGHXrtqE/Mx2p0wuBeSFJR2quFet/YSXDWnz2QxQ73kLENJlQbQC+FMnI2O/+WLaH5114GKUicr+oQZ//9TIxkHxjb7XkGuIGuGGhmnfcA9VXTJYoZAT4ltt9R99+KPP0G1l5SryHHeRi/YvSsQ0EzD6aSejyvJbHqW51KUSJ4ZGJHAfhuJVjyXSJ9q1XBKHcwVx200MEbEQOdL/MeP0C/kxF2Qg4tUb0Pr0eqRytbUjbUaidZWuGI6HQiGYWZlpyhgU/V3qmmoWHuHQfTo3DqXV6zjTbkdepn05wWijxjIAHMdG/BBk8Yf5SzUPMhYlPGcCaZzWMIx6OlzgpjBg19It/DsZeqppAO66i9ofWv+AQkVxyZhnSSAEdfYLTv8pSyM6Zwxm3hYjsx7n50VkoMJdS8qFpo791EGll41tVEzzW8IkR1PaMl/ub2r3WIlYMoiqwD+Ni2LaTj7zSLWedj5y2Uz1ig1RTXRswUk4bITbEgDiQdDd2bzGZaJE2+jkbL2gu097Af3WLkq+h0LMD9UW+tuG8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e8156f8-94a3-45b1-1bbd-08ddaa870948
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 14:31:51.2498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZXV/CFgoJFgYw69SSG44tich5NlPTzkxjwkkYyCZ3yp7fQhxkQeQxD3Ifs7cwuAY5i+t+Mifi1Z+xtVXPrTJWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5009
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-13_01,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506130106
X-Authority-Analysis: v=2.4 cv=RZGQC0tv c=1 sm=1 tr=0 ts=684c365a b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=N54-gffFAAAA:8 a=n5uBJ6SOWK9waS8VyQQA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14714
X-Proofpoint-GUID: Iopy3m3g79Gpc6B5ATPBE4T633iP1zN7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEzMDEwNiBTYWx0ZWRfXx+MYgEygSyRO i/aJJwQMNGqJNGfr2QddhtEsN1bLswLU2Oh0CTGEFCK2FQ0MKNmSsvOTozGO1E4PaZOOZ0nxVX/ 6eoLOWzy8Z0gw6vFYwF0CiPZcGwK0OCrWhcx8Hx2JS3vr2Ovhwxb5JaA7DYLDSlS8rYZo5zbREs
 GfyKArRMObKhC9IvQI+UWyQR/HKOXgYtglEE7G677ekoqHwCGLfygwX8kosR2B5y18cWxF5NeGX vdQPDCs4oFGsJSJ5838oAvgB4zKLdpFsKn7m3Gd1TJXssujoepdaxu0VBay0xnc0RFoOKfpgain wo8ikFDZmIsAsDFON6IhF4Gzs76duI5bD7n0xn2JSBJbksKwIOrVSDU0qhKI8Umd6y1IULXMdyK
 +bbCm0AexoOP6HTi6vaJwp6/ITXWENf0L4Q5p5gjvlBAkDkaVlAumWHPxQHBUVwb/uonmEjD
X-Proofpoint-ORIG-GUID: Iopy3m3g79Gpc6B5ATPBE4T633iP1zN7

On 13/06/2025 07:29, Damien Le Moal wrote:
> Introduce the helper function sd_set_io_opt() to set a disk io_opt
> limit. This new way of setting this limit falls back to using the
> max_sectors limit if the host does not define an optimal sector limit
> and the device did not indicate an optimal transfer size (e.g. as is
> the case for ATA devices). io_opt calculation is done using a local
> 64-bits variable to avoid overflows. The final value is clamped to
> UINT_MAX aligned down to the device physical block size.
> 
> This fallback io_opt limit avoids setting up the disk with a zero
> io_opt limit, which result in the rather small 128 KB read_ahead_kb
> attribute. The larger read_ahead_kb value set with the default non-zero
> io_opt limit significantly improves buffered read performance with file
> systems without any intervention from the user.

Out of curiosity, why do this just for sd.c and not always set up the 
default like this in blk_validate_limits()?

> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/sd.c | 45 +++++++++++++++++++++++++++++++++++----------
>   1 file changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index daddef2e9e87..8070356285a7 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3681,6 +3681,40 @@ static void sd_read_block_zero(struct scsi_disk *sdkp)
>   	kfree(buffer);
>   }
>   
> +/*
> + * Set the optimal I/O size: limit the default to the SCSI host optimal sector
> + * limit if it is set. There may be an impact on performance when the size of
> + * a request exceeds this host limit. If the host did not set any optimal
> + * sector limit and the device did not indicate an optimal transfer size
> + * (e.g. ATA devices), default to using the device max_sectors limit.
> + */
> +static void sd_set_io_opt(struct scsi_disk *sdkp, unsigned int dev_max,
> +			  struct queue_limits *lim)
> +{
> +	struct scsi_device *sdp = sdkp->device;
> +	struct Scsi_Host *shost = sdp->host;
> +	u64 io_opt;
> +
> +	io_opt = (u64)shost->opt_sectors << SECTOR_SHIFT;
> +	if (sd_validate_opt_xfer_size(sdkp, dev_max))
> +		io_opt = min_not_zero(io_opt,
> +				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
> +	if (io_opt) {
> +		lim->io_opt = ALIGN_DOWN(min_t(u64, io_opt, UINT_MAX),
> +					 sdkp->physical_block_size - 1);
> +		return;
> +	}
> +
> +	/* Set default */
> +	io_opt = (u64)lim->max_sectors << SECTOR_SHIFT;
> +	lim->io_opt = ALIGN_DOWN(min_t(u64, io_opt, UINT_MAX),

does lim->max_sectors << SECTOR_SHIFT really possibly overflow? I guess 
that it the reason for the min_t() call.

> +				 sdkp->physical_block_size - 1);

blk_validate_limits() has the following:

lim->io_opt = round_down(lim->io_opt, lim->physical_block_size)

Does that do what we want already? I do realize that we want to print 
the used value in lim->io_opt, below.

> +
> +	sd_first_printk(KERN_INFO, sdkp,
> +			"Using default optimal transfer size of %u bytes\n",
> +			lim->io_opt);
> +}
> +
>   /**
>    *	sd_revalidate_disk - called the first time a new disk is seen,
>    *	performs disk spin up, read_capacity, etc.
> @@ -3777,16 +3811,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>   	else
>   		lim.io_min = 0;
>   
> -	/*
> -	 * Limit default to SCSI host optimal sector limit if set. There may be
> -	 * an impact on performance for when the size of a request exceeds this
> -	 * host limit.
> -	 */
> -	lim.io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
> -	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
> -		lim.io_opt = min_not_zero(lim.io_opt,
> -				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
> -	}
> +	sd_set_io_opt(sdkp, dev_max, &lim);
>   
>   	sdkp->first_scan = 0;
>   

