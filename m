Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735C0456E1E
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 16:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786724643; cv=fail; b=obeAbiIbZ/Dl3wpMMfKJWfU4+DdubBu9AAfu+tmM+Sr1EWKayqeASP4/DT9dWycsm86T+dmH5VdCGzH2I4n5xE2EgVVg874Y8Pz7sMO6jziFBfPdC1qSjt7Ang//BcrQqFGeB4osaK8ASDCPEXB8tn2XSg8EAl6KpaQITsgaK90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786724643; c=relaxed/simple;
	bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H42a8S/Ay/PH/ezec8T29oKRM9ajeT8pZTjf1kCz9pUAQS7CcvTHVphyJgs8DGWLtvt3PpNtp0x4IOpu4oUiKpD9g414/Ek9Ye/PbKivDASLHW0gWqwjSFK3dDIvFUWdg+fvN9YsTw3ayp1FygXMXrHBP1UiW+HkEOX1N87s99M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=odiG7gsW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tRrEBj1n; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="odiG7gsW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tRrEBj1n"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EFXjPR2435030;
	Fri, 14 Aug 2026 16:23:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=; b=
	odiG7gsWBrXpONBJFttRh0YlNDMr01Anc9xEoJ2kxLwDazOfCG4FiGGMTH4Up9sg
	hon7Gej2uO0ddTUQoqCCi1a/sZh/sTvu9oHycgoc7rYDWJKAoqW+V6vZAq2+q7Jj
	QEiSqW1cR604hErP5m/39Sgjl7QYRyR0g0dghhmEUgesM/KQ5+PmjEwLk/fRLxxT
	BiripXns0EgmWq9rlrGZwu8dsBiIObhuVXPoj9Je+f1RkaXpmOQL8s+xLeK/frXZ
	5qQ4ORkRcc1cFryW7Hs4Fh+fMnLhlTvgmXDG6MxruIv10zvxMjkzIzsQluOVpzSd
	pJsURvbNBENKkuV0JcHTNA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvet4m9r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 16:23:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67EGKjAi013801;
	Fri, 14 Aug 2026 16:23:54 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012024.outbound.protection.outlook.com [40.93.195.24])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwufm5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 16:23:54 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kKXTNsPraVlM56ZbjINdKBaFkslCl0eopRZzQaEyg2cyWYns4VSjSWfd5Wix6Y67vPg9NI4XYkwQpGMUoE7cuFzsMQNRsLfraNKs+BSV4U1xiN+w91gOi0dAUILL1MeN2JLLy36tAOdHAg9F7JLAJleLEQ6XtLX931jPqBMEQZV0n0J9VVBkVrK+H2HGdSFsUYKPBxWqWeh7bqBkftsqw7kWg+dXNqp7jdphqY37h4FEOJX2mUIVSE6TiOaFy//iZ5CYayUhz9JNGa9RL9ti9Ru0RkDKflQWYi4CaC+O+YpoqWJBMIol9uzEOSiZZh9oNsYIwKtts3DZ2GG+Ff9r/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=TBmsXKQPbvI0BYwHw48FM/ugPLHm1DATTTJZDa4OCOQfqp7FSMscm1fp29bX8zm9mNksxwTa44RvJG515RLcK8Tlo5tIXndVnLfpS1Ki1cpcLsrcEFSwAcQ+Nn4oczooVf4jS0Df1vM3OBirr2qWbuvo8zLkzfociPobYa1edn3+wE6TZy0HEerHAtqcfy6qAscZjYHlRIYixCXYat1TL0UGo3nSO4lmPrB4zeMPCBXDc4QRC9YsXSsvsa2GDW8n5mlQ/4zWbwEMfi9ZNtNjD57Hrk1alDMlpbDofRbsCb+Uk0ISgb1TlaNPwZD9/g/h+Ayq+JbSaBHGlTyB2aRo7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=tRrEBj1nLGFiEcbLM4CqOCGE5459o91eoB+a0/BlJXW+n6Gbg0MycRRRJGI/glizyfoEd9pDSO2zwhdaQvqDakroqNGtGfBlDuW0+6sR/FMgmFQjRuPPNLCPXJKxH9oH/07l8DNGSbn9Up8HzFuuH81XJMC1m65PaaMjr8T0LBk=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CH3PR10MB7354.namprd10.prod.outlook.com (2603:10b6:610:12f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.16; Fri, 14 Aug 2026 16:23:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0315.012; Fri, 14 Aug 2026
 16:23:51 +0000
Message-ID: <aed4e1a1-5182-4c8d-b01f-264cf70cfa5b@oracle.com>
Date: Fri, 14 Aug 2026 17:23:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Enable context analysis for hosts.o
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen (Oracle)" <mkp@kernel.org>
References: <3e1c3c0ca9307e2581cf4b96cf3fcdae35202255.1786724393.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <3e1c3c0ca9307e2581cf4b96cf3fcdae35202255.1786724393.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0672.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CH3PR10MB7354:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eac692d-f586-4da8-a7ae-08defa206d31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|22082099003|18002099003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	2+fbOGmoxx4LF7hI2i3iVUEtCtj7lpO+m1sUhmazNdFs6ndTynYhDYyzCwMg4atP95pQYjYzSI3Rwl2uo1kuEDi8FySEDuJf4Yg+qYfNVwo61AI0ggyaHxmT0k43nplzh8zeF27yXpfk0/TA4pl2bASLKfjPuoqjOtMNqTah4ryHtOKV+gajpaRXSGN32sgJhhVVppdsSiGZn1SYkzo33pdj0wKv0sefClZv3LxD43TvVgSjH1L4QPxgwF0bCzpOAoijUxYtPjo/8EvHGakACs4n0X1bf7tHZzwXwxHok0ixjtaZZG5FXiVUuHmKnkH3zzid3EBTwbcImqDxhwyhMw6/gepQ4KOkuncqhRiC505JcZWG0Belebnqv6sGN17lerJBZKqd3nbbCpQd8fmQ4jPoFt1gylReUNEhDzrfTKxT9j1fRY+dQ1jxrY1sHWzwYiCptEAAtQpM8qENepY8m12xRYaKB+KOcdMvtDMIlFp/4VfO9Ga7Mz8VejaFLdbtPLrhixXowp0ku3Izfb0Pw5BTPAE2MD5hlouTMqFqzA3gcdDQ17bedz6VIG4z3oGUZnVLHzr24ZAb/k28IcU/TexcYjeEfYsBBlkJo7Y2kjT/Gie86ELhRj9G1YKO9yzoHQf5Y/rTaVeQDye9iaWiuwWj2sgd9urUWLccbi7BIpU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(22082099003)(18002099003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TnBTNmk5ZFc1MlpVZk5GYWhvZStvVjVUNVdaQ2tEQ1JhdFJIQjB2b21LWEZW?=
 =?utf-8?B?YlRRZGxoSTczdnBBbFk4ZXNlMlhxeS9CekY2bGRSWS9udXRuSk1wcndER3h5?=
 =?utf-8?B?eW56SnJsRnFJam0zeTBsZjBYbW44NjlocHN4elMvd0RQdzdaRXV1YXo1VldP?=
 =?utf-8?B?T1l5SXpPWlBGN0wrbmVtWlNQSTlBUjA1VG50Qy9iY21PNGxiRWZDNGtYYklB?=
 =?utf-8?B?LzNPSFNjQVUza1ErWVl3YjAwR2gzWi90bmMvUEJ6N05hcytLcSs2R2pHNmFs?=
 =?utf-8?B?RXJudXRMMkZWRXZETVVlWWF1UUNJODFCbTJaVnVVSlJ5SGJmbmRoV2NNd0F1?=
 =?utf-8?B?V0RYUXVrTGlOdXF2VjR5bG9scTFWYnJyRHhCTXR0dW5pUk4xK3hKWnRWR0l1?=
 =?utf-8?B?MDJsck1rMjN4djJZTzA4MW1MNzF3a2Z4KzlMTXpzTVhmRWxTVTZrL3Z4NEFL?=
 =?utf-8?B?b2xTRGpjR3JhN3FCa0F0MnNKUS84T011eWZiMkRGMzBWZjhmWHNFOTU3dy81?=
 =?utf-8?B?b1RzRmhscHlKTUVzak8vWm0yZS9Kdjk4dEpBcDlWczhsRDViT1Rja0htMHg3?=
 =?utf-8?B?UFNGa3NyMmlHb1Y2V2I0dDR3eU1zY0piaTFOZFBVYkZ4OWxLYk90VUFKYjdo?=
 =?utf-8?B?YVRpYTFYaC9CWnVNVDYrRFNqZklFZzdvMVZxa3JqV0VzM2dPRnJjeGJySGlF?=
 =?utf-8?B?MlFvWHBXdDdERGJHUzNSelpDYjk0UVBjcW0wSzc4RVdPVVNrTE9hT280UnZT?=
 =?utf-8?B?b2lDU0ovaWV5djgxNDdjNUNrUDhydFRRaWVkS0d1cVpDKytBbDRaSlNQeWJL?=
 =?utf-8?B?YTRIQzdUTzNGTnNjV1ZwSDNwNm9JRmczYktzSnZ4VnBEekJQVlRJUURCUzJB?=
 =?utf-8?B?aVNNUFNGSEVVcENSckJsSDBtaklaV2JQTEtzRFpzQUJXOTd1ZmdhbHJhR1ha?=
 =?utf-8?B?azJFQUIza1FpN2VGcFhlQmdrN3J3clJlTFl0NGlPdHNOYXgzUVBjc0tlakJU?=
 =?utf-8?B?KzRvVStmTnNGSnZKdHFOckk2SjRDcDhDTWNGTUlMVHNNK1FiSHZKU0Nxbkpx?=
 =?utf-8?B?NjNVemJ6Z1QvTk1xbDZkSjQ2RVFucnpWekg2UEFOQ3Y4aGtwbDFwb1V3RWt5?=
 =?utf-8?B?SkovbnR6M01IQXVHY0JiaDcrWlFOS1JwS1NTWWRlR05sMHlpdVhBekhPSllG?=
 =?utf-8?B?S2ttWnFWSWprVnYzaExQNWkxSEcxQnZLVjFDQ2ttdXh6eS9LVVpxZ3NVUEpm?=
 =?utf-8?B?TGlJVEY3V0h5TjdvSXBWL3F6MjBtZjFvdVlEOC9DSFA4Rit5TmU3K2VKMlNJ?=
 =?utf-8?B?VTBmMjk5cDNXZFlHMDRFWnIxVTh4R2VwRWtmUHJzSDB2ZlJ5YTFHYUU0d1l6?=
 =?utf-8?B?aDI2ZHhPcXlrcUZFRk1mMUJmN2tXdkxFZ3RZdytRcXZINlR5NXM2SUNuYjVl?=
 =?utf-8?B?YXByVTlvYk1vWGx6ckxzMXBRd21KSlhSMmtxYnlKd2RZc2NjSWpuQytLbFli?=
 =?utf-8?B?UkZOQ3FiZDZlQkpXbFkwVGM1R2VSZHlTWFZRYnpDai9aeEpJOWxFbEdMbHBR?=
 =?utf-8?B?S3dQZWVNK0tTdndzZFJDamVYbHpibmhxaU5SekRLek9ObGp1SGR3Sk15TGw4?=
 =?utf-8?B?RzJMRDJlTzM0bUJ1UGYwQnVGTVJndkY2YTNWTGp2QmR1bDN5SmVPejU1bXRx?=
 =?utf-8?B?VjJ3ZUQwamJxcGNoL3h6SVZxUVJKUVFyOWdIQzlrY2UxdUNUZk0rOVFQTEtT?=
 =?utf-8?B?Y3RjUkJhL3Q2QWkwZ0F2dFp5SS9KZGtpakVUQWErYVlha2lyeVl5NEJTK1VQ?=
 =?utf-8?B?QnU1RkpEaFdEdzZQRjV5ekZuZDMvRXhRZVZMNEFpbW1TRTZFMUgxOGtaSnF3?=
 =?utf-8?B?QlpzTzBZR05LeXlqeU9QbUdXMi9LUlVwbG5tMGhqU09jWnpWZ2dSWTZuQUVw?=
 =?utf-8?B?VWZVdWlzd0tEay9kUytiem4rcitVcDl1MGM4WmxpR1hUNmZyYUg2cW9zTHB6?=
 =?utf-8?B?d3J1YzdMTGdWblIwWHU0NW9nQ0pVeGlJczRuZXo4SGN1QjVPV29OSzU3aTZO?=
 =?utf-8?B?ajF6dWdOemdaeUx6VHNUWHMxMWFYdVNqN1RlK2syUXZzZ21DVEJJZVNTc2M4?=
 =?utf-8?B?QVlZckorM2c5UGt4Ti8yM0tUV0xMYkJ1djlzME11R3BFTUh3RFZKUzZuZHEx?=
 =?utf-8?B?bzkxR1JmWTRLNnNNdzhpTTNKWVlUOFdKV0hSSDR3UDlvTDZkOWpWRVRtYnpy?=
 =?utf-8?B?QmV4amdDSkVTSDFiZTdHSDI4NjRML3pCREJTZXpKTEkyeFQxTDV6WXpyTlUr?=
 =?utf-8?B?QUFmRTNRdnVZVHJtU0lGc3BpMkZDZXBwYm56WTFXK1BTRXlsczI3UT09?=
X-Exchange-RoutingPolicyChecked:
	HDO9rBaoMjaqRQAoq6cjle98VTlObTc5k1d6KrmM3rfF4YjeYFPd31KzjXSHjzO/uUuXnepqdW7WJ8A273T5dF+irkM/Js7b9R/EovsuuetrKmg1LkRRkut54mOEs5My1VxrETuKcdZxSE2yTo+UvWfK6UAPYdicvzmO7cxpG5JXDWHumi7J4W5KZhxb+VM1DSyOMn7rxWoPF6XICNjl/WeBFS/oWFo9KHGszdE3+U2cLO+5/Me11TQiYjOtphrgroEu/vJIU3rrRqxdFjwCuY8w/1rpDNoVtdwYfhVO+ZdnsTThSCSFPGh6J2Oc7MDKPbBed5sCPHf3RdfV5VrlIg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KIo3eRhJt3wXWsKXMew8oJndrNKJFC9GropSeRQ/cC0RXJNoKcyNQtnXy56QYcQMbwNvwUkyjMLmq1GjZOhdyrN+bVT7PFaZ5TqBDY4oS9cI0Mcb5lAIS0+HXQFSR+M0nM/nOz+jWAcBDtw+vMuWRiyLEQCpnV4MYljt/A1lyJI6G00/XRsuMF3KsN9L4Ia0GlYdKdyONR3hXJFcrC+pVdcl8/gECyzx+ANKeJcBR4JaAl4eIVGda9ySQNoJDS4KniqQd4Yv1d+VaGKLlzJvOjQs9gs+p+U0lmobhnw89QOiJlkX1hfIlrCJGVWEIu2Q/FhQARhYsxzucheDfigxGL0AFAPlwk43kM0sWN3TnqvTDXwR58BU4B6thNFqFWLUqzhmwnIhFevhCdEKZmYa9qpqxSEmcfB7pY/5RZyjbXKJEkH+tbErxxBymYByci98SyWpl0juW78siO5c5JqDT6DXbv/6h0lpyyF6eo3xrrhinv6BvSJ1sAOU6Kp1Fa31o1n6V0QEVwSMKLhJSfk1t+p9aj1L/7K4YyJrwURaic5bGo1RGm47noAIK5iXyRRp9HjKLIY97AbWB7oUPg80b4s6g1FyVecA+/SHzQeA5v4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eac692d-f586-4da8-a7ae-08defa206d31
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 16:23:51.2895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BkDiIKRObTRWeOrf9TTMTgZhwuJCCRcewCdjlVfjVaom9ue0dgH50Qd3Wkyn8Upv4EJlMrJvMdvHQUcSU+LVeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7354
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 adultscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608140125
X-Authority-Analysis: v=2.4 cv=R8wz39RX c=1 sm=1 tr=0 ts=6a7f411b b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8
 a=YwXNSyxGt--lyTdxN8QA:9 a=QEXdDO2ut3YA:10 a=6pWzAbgKvXYA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12099
X-Proofpoint-GUID: g1b45AJ0LqKLxtuyAeJEN1MISHk2Pod9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDEyNSBTYWx0ZWRfXwNrHPKXki3tU
 9NujZS2KT72yLnPFvfCDZ8Hf9TRKEG9jnp+3jKCAHf1+ClzcBJ+UDkuWtg8id+6uQRUH6mIw1w7
 qC8f1o97gMwB8bQzUDSKLMx2phJQptCPIZo/ZMcP/GLtM5/JRZi12jZF2rnvT3hXbPUln6fLprd
 cmp+8nkNSEYvXvEHTbvFrdjEeRekao1XmGdyqApSWm/e+5EySm+iZNpylfRQ17ue+oy8XsHdbUl
 XK6qLnAUJekd2JTaAoX6Sd0D6O527ELA2fDuEWPyhiYtSM6JOGA34w0o8uXUF0sKNI9IvaxsJlN
 +NYIMA04dlocN0OaxopUWAyObLyUV/qdishY3Jg2eJnSdc8XVGEPD99WBCr32oEo29EIjhNpHu9
 hJJvF7oHEuZ3sI/wqlX4BLbMXWzORQq9EnTB3eUvdp2vkDjuGRCMNEsL7/rhfNg6fUZ7pvtVYwZ
 3/HjAWlQTABezCmLWSitR6psrygvrao6Fvp5mpYQ=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDEyNSBTYWx0ZWRfX7i8qgUnxNgai
 7okpB7+I3HbyjZ8DJnZLNyeqipV/pKWdl56Lw5coeq+E4tqxwQKk/s25plnMgRRXkMFApeeTzBr
 QNDnJzvEiWQoN1A2joMQi3IpcXBnG9s/DtPaEOkJq1z9bIr+XfPh
X-Proofpoint-ORIG-GUID: g1b45AJ0LqKLxtuyAeJEN1MISHk2Pod9

Reviewed-by: John Garry <john.g.garry@oracle.com>
