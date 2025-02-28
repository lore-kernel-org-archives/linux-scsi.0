Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4318926FD81
	for <linux-scsi@vger.kernel.org>; Fri, 28 Feb 2025 14:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740753391; cv=fail; b=pHLJIPA9KMkF/UrjT4owCC6tPl7IisPNEi5NXgBhKRknAcnQsmoz2Key1je6AWHxYRLE9J0yVzJ4asb3bIW3PbYPFDjImOJOmc8N44qAw5hfrKAf+QUcMZ65xV1h6T49CnEJLoUd95plf5bl/xv7aYApo3Xw1QEpynzkVAfsShQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740753391; c=relaxed/simple;
	bh=Gp2EUclHNcYC7JXx0bLTWZvga+LFse81QyQqdM96Alw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cjhAxswop4CjPiW5gPvfSMC/zDQYMzwEIGhihF91UgKvitdiZ4t53bnMW/CbwK4ghwwIh79VD5gdaYgF13pqsQzK7qc+lCNEc90sJS76aVO/fKm1KSNY/Sozad7sVDv5XWZ/Lj/Lfb7ifRGWwhrek7tVcWJExp4nKcUfN4/IrHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LT55uzRD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CGZgOl1v; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LT55uzRD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CGZgOl1v"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51SEH3hu005713;
	Fri, 28 Feb 2025 14:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Wh1D2HzP9du53XD3obPt7F7SvaG8H2JQ+zrZp/T9Yd0=; b=
	LT55uzRDqxZh01h8J9zebw3evV1jHm3MxMyDycTJhT0IcIn0EAcIEUcSQR2VrSLb
	dBFXq95UWOYihNjATpEV8RgQGljrQBMPC9Rm50qSGaLEIWEnxAF3dVnTkIU2zcrg
	xgK4V1eGQMH0uI532E5cllttCHmdTHScX1CBIm4Km18icw9ez4irJb0ZQ+IYMyj6
	mV11vMxjNmPZsY7nl/GeobQYNotooCcCnGxpXcPWzF4T3gPJe71+wLMdOCnIjZ+V
	c87JMlpyZh2loKL2sSAkE2Ze0Fw1uCbxI1dSPPIZddTTCBJUxroLPC7KzsLoGqwG
	jUNZDooHiVnbafNNE3Q0Mg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 451pscdr6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Feb 2025 14:36:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51SDhVGh025293;
	Fri, 28 Feb 2025 14:36:22 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51ma436-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Feb 2025 14:36:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UGOLH2MIL/xKw/MqahXrAGb23s80novt1e0cSUgcBSyVDf/T2sk9a0qJO1Tx/lTT7+Ds1b+5eF8vBjoaCdEFtL8+Vc5Fdkiis09QpRCNGCJz36sERtAmlyBtXF2QiOToQP1OY93xSVWJQ8/BZG0O4ee91KxPNNmHWb/F2AHwphK5kmfU8xDWFLiLrQHv0Oq2R/bxHpKBkFjKMCNZv7StUCS2Co+Ve0mG7FQi1UObXHJuut/haRqJqtOBbfRCEcqHURd/YsSETzYLZnk9ovL4mQeUcyly/x+i+PXp98szFJLcJQTfGWtUbLbqaansgBfSDLmW3/rnZSAyLy90kAGn8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wh1D2HzP9du53XD3obPt7F7SvaG8H2JQ+zrZp/T9Yd0=;
 b=Rog2hOxcF/i/UrZcOrVPb0v3rZWcYCd4Ds6i/mKd0xTdy4rWz1V+GarjhnxZIxtakXEuuT6FsVZZ6x8e6/tqYOL5lEFX29P8UvLwayk4ZDHAnzANkZhzgDu+Ez8hcKKJZbzIR7PbgqZylNCMGpufsZ+CDYSjCWh+DErQble/w1pm/MXaD3H3bhMZDds10ygc0qjPZx/9spgh9ARIjNg/ggB5yjMf34OcAUHyVWAEg9rJ1qFSBImSLAdY6F0kggZUSvgoVAmZv4WJpA7BixKPjyDe5XMA6lxdlAjGNTmoZ2iOZFdfVQeZv7H+dIA69B26QQCQk8+ku4cOIjkUb/6q5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wh1D2HzP9du53XD3obPt7F7SvaG8H2JQ+zrZp/T9Yd0=;
 b=CGZgOl1va33o3VGQjDEZNRyo3QnynF0D0a+wrygwVo3UoTFEEkM2cVcrprVcqfJRQToR+xVuYvg+X+g/kgIUWRfhcnw58dH5UFzZHFt5zb+jpNdc5XU25YbsUdtu8JZa/+YgaUy8VhLiLMpLFR676KSjVJQHbZBCOoGIsbieK0c=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB6351.namprd10.prod.outlook.com (2603:10b6:a03:479::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Fri, 28 Feb
 2025 14:36:19 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 14:36:19 +0000
Message-ID: <73bd63fa-9ea9-47b3-b6bb-aa97d2a0680f@oracle.com>
Date: Fri, 28 Feb 2025 14:36:16 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: scsi_debug: Fix two typos in command
 definitions
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20250228124627.177873-1-Kai.Makisara@kolumbus.fi>
 <20250228124627.177873-2-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250228124627.177873-2-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0158.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB6351:EE_
X-MS-Office365-Filtering-Correlation-Id: f67c3df4-311a-4458-afe9-08dd580543a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHpQWnJISjNpMW05ek5DMzl0OEIzWTBKWU5ncjczeTViTjdreitPSDRMKzJY?=
 =?utf-8?B?SlRHc3M5OVJYRjVtU0k0R09MbXhWdFNtK2kreGd4c0dPcTFUOHY1QmN6V0Jl?=
 =?utf-8?B?ZG53YnRFYWNYSHYxVnZqYXZzTTlOVml1VzBvMEptL0JaTlJPSWJiK1hYS1RI?=
 =?utf-8?B?M3VTeGc1OEZEWDlQbnlXbWZtdWFqa3VabjJIcWR0S0xuS2hwbjRjYlRNV1Fk?=
 =?utf-8?B?ZzBEcFpES1RMM1BMRHJnQktJS1JWU28yTG5UTFYwbC9mUmJLN3NZZk4xYUU1?=
 =?utf-8?B?TGxuTWExSnRYL1dOVjNOMFEvTkxQWDhBcVJLaEtBTVRXNHRJSnhabWQ5S1px?=
 =?utf-8?B?QXRybTlqNXlJVnc4THpOWlhLKy9hcDQyVlcwSEhpaEgrWmNmMXhhd2FtUCt4?=
 =?utf-8?B?UTZoVEhsS1lYUnZlWmZ5TzZFTjB6M2xKZnZLd2R5Sncvb1crUFh4MmtDSVhV?=
 =?utf-8?B?VEp5TjJrV3dJdUpJYlp6cE0xS2Z1Zzc1L01TaDIvUjRXSlp0ak9rM21Ra2lx?=
 =?utf-8?B?L2wrRlNPTVlsK01ybmhqbGhnUk9YNmphRndOeTlxVlpGS3pidURZanUwR3Fi?=
 =?utf-8?B?Rk1jcTZ3SzczUmc0c21TRDZFdHBBM0dtNU1SUHRxZ1BQeVk2OTRZMnNHalVw?=
 =?utf-8?B?WG5hSllUUk9FaE50YXNWRmJoM0pWS0VjRUhTOEI5S1M3c09wbnhwSjhwR2Jj?=
 =?utf-8?B?SjlHejBsbjhSMnh5aVVZN0FEMno3Qm9yVHJTUUY0bUptTXYxM3RtMXZKaVhw?=
 =?utf-8?B?dzBVWWZaT3lHN0tTNDJxc1VYK2daM0R1U1dianRxSTNmZFB0ZDBxZ0tOVXFM?=
 =?utf-8?B?RVFOclRJMDYvRE9obzd1U09hQVdBaVU3ZGlBdlhDSytWMWU3NkEvWGJBNUJl?=
 =?utf-8?B?a0tXSzc4cjVBR3RuMGlxRmthRVR3eHhSS1lFdE0wWGYrRkt5NzFlOVBVVFBt?=
 =?utf-8?B?NTJDTmxvRDVCb1hNZWVZcituNDBxTDB3aGFYWWJMRkUySnE0aXNMMTNxa0pP?=
 =?utf-8?B?MHBDbzNSNXg2SlB5TzY2ZlFYcDhKMXNMd25yNTJCSGlDeUNkNW1WSExQOG9M?=
 =?utf-8?B?QlZOVUwyTnZ4QUp4T1EyN1BSaDNYYVY4U3h3dG85WVIveW9mMzRza0RDWWlC?=
 =?utf-8?B?QVd1M2xpZHJUUlpQUG5mZW0yZjBZUEdmYU5kSE5HQURsYzR6eFBlTXZ2Y2pz?=
 =?utf-8?B?R1RnK2x4N2hML3duazk3amRmR3Z1Z2ZmcjlucVh6NUQwY28yRU0zRktFczRE?=
 =?utf-8?B?NlppR3FRN0hlRnIwWktmclhhRk9HMDRjUnR4Q2FNOFJKa0FFQjVPanNMMzZo?=
 =?utf-8?B?QU1nNnEvKzhGWEgyUnR0bThEYmliL1VDRkxlSHgxWHc3TlY1blIreURYaC9C?=
 =?utf-8?B?L2N0bnl0L1lBU2pHamNSbkxYVGkrenJOS0pkUUNheHZIb0l2aEl4WHlnZFJr?=
 =?utf-8?B?MERlWkd2QWZYdHJ4NGNOTHNJeG9ucnNwODZOSlZ3RFNvOGhDa2NTZk9VQ1NG?=
 =?utf-8?B?eUVOdzBuU2Rxekl4ZUF0MjRlZ1l0MDdGcUF6SWU1M1VFcm43TnEzaFVnT1Zz?=
 =?utf-8?B?VnpRaTZOSHlRaEM5dWVkR2p0R3U4R2tIS2hldVpFVUV3d2E5Sy84dEcxeCtx?=
 =?utf-8?B?M3hTRG80Z0lYOEU0V0ZwOGRqT283MmxtUnhSQXFMck1BNnRHOTM1VlU1TDZL?=
 =?utf-8?B?RktCQ2lXMjVXV2hnZGZPNHdXUUtJTW9oazdCKzd1akFQYmNDUittenpmK1kr?=
 =?utf-8?B?TzdWU0hnRkFwNTgzYXE0VHJlRTNtNDB2aVB6cFFubzhZaTNJcjNQQlM5eUJm?=
 =?utf-8?B?VFFMdjgyZEdxQjZIUDNNS2l6bTdaS1RZc3U0eUNIeVp3cUpkK0xhdnVva0xz?=
 =?utf-8?Q?fCESFdUAfJigk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkNrYlNCVkNpSlJWdkUvV3hYYXA2WHhIUnZQUmtJczRJM3gxUGFUdlRYSktX?=
 =?utf-8?B?SzdKMTZYcWt0cytKMXo0bXZ4dWdiWVQyYUFGWHVhMisxTG1Nd2lveENWODdG?=
 =?utf-8?B?N29FUWhpeVNsSmlZVGVmTThpTWpCSlJBMXpkQ3dQSDlhdVVESjk5aVk4c2RD?=
 =?utf-8?B?M0N4V3d4RXpuR0dlTHBwZXZubnc4dmNHdStIbU10N2M5QUp6enpOeWFmVVdP?=
 =?utf-8?B?dEZpRXFaMnhneW5WNGlMWVRnOUJMWEc0L0xLUzFteHRpYjZ5RmFCc0diUDE5?=
 =?utf-8?B?UTNqZkJaQ0U4QjRsYTIrNlkzWmdsTHhSclRvdjA2ZmdMYWlEN05qSWpUbVp3?=
 =?utf-8?B?TG9vZDhwOXkwdjlwbGZrb1VpNS9pQlBHb0plNmNMTGhHem5yZ3d5R3NsczZF?=
 =?utf-8?B?eVUrMHhMMDNtL1dOTmdtVENlSG12Qks5bjMwUjJGU1ZwVjZxekVUZ0w3SjZY?=
 =?utf-8?B?U3ZaR3RweVBMRkhOV2FiZlV4eHVpM2lWcGxFOXYwQ252UTR4ak03MjI1VGVE?=
 =?utf-8?B?RWtBa2dhT2lZU1ZFSU5TUmtWR2c4VHhZbFhvbU1zUDZ0cTJOVCt2SUZHamZr?=
 =?utf-8?B?c1Y3M3BaeUlxZm9QYmdvdXlyNnBqRG8zb1JKcStnSUFRNHNmYUJnZlFsYjY4?=
 =?utf-8?B?dGFIeHVnbFE4aHFuY3hla3VldS9GNGFPSDJtbTdwL1pBdzhiYWFqeElaa1U0?=
 =?utf-8?B?b1ZoeTBVMHRtb1YxcXBPZnQ1eDRNeEhhNkJDMksraS80VkRiZmJPak1wWW1q?=
 =?utf-8?B?anhiM3R5VUg4QWFRUVlOWHRUN2JKcGxnYXJxVnB4VUJTZzdUb010dUpGOWln?=
 =?utf-8?B?QTNpSzdSN2lOajNtcEY0aGlpaUJzbklKVVVuWStJWmluWElGWnJZUUxTNjEz?=
 =?utf-8?B?bkNJTDAwV2F1ZEhLRTNDdUNUOFhYWlRkbi9vWURLeDgxZlU5MVVjZGJFNnJa?=
 =?utf-8?B?VnhiNkR6Z2ZtaFNPbWRNeXg3TEl4RXpqWlFzeWx3cDRqejhoRk5WZUQ4NEt3?=
 =?utf-8?B?bVZjckJ4NnhoVWpoZXlQcW9yVmt0SUw3eG9FL2w4SEJyUkhWRCsyOEVkUEVw?=
 =?utf-8?B?Vy8wSkhjZERyZWdXZVZXYkFqaENBSGxXMjFpMVRwRzY4ZmRIUnI2bndLQ2xm?=
 =?utf-8?B?ZmRzNS9zTE13b1g1QjZrbDh5V3NENGI2bXdWZ2NSM2xzOThZRVBrRHVRWFFD?=
 =?utf-8?B?SE41SktwbEtSN09pdEpNc1JoQSs1RDBGRkNrYm5QREEwdFJqdWcvQWY1d2pE?=
 =?utf-8?B?U0hCZ2JRNHJVZm9VK3Z0WHhNWFd5eVRsWmZMVThPZlJFeE9kdzlXbUZDemFQ?=
 =?utf-8?B?NEk3RWFodDVvSkdyeHVKTVl5bHZCeHNGWXQ3Unl0UkhEUXJTamZ3dS9lQUNO?=
 =?utf-8?B?NmJITnRWeTAwd2Z0dUtxdS9uR0hjUmFvaXZVYkEzSkMwdmk3K1ozWXBmMm8r?=
 =?utf-8?B?ZmFBWW00MFJxVGFyWEU2ZG1MYWlxOHhlNnZxRzFIbG4vYzBHdDhaeFlHaGVh?=
 =?utf-8?B?cXJHWUc2OXRleDQxV09KMzlFU21adFBoOHFiVWx2dWdyM2FoOVRIQVlBTWtH?=
 =?utf-8?B?ZEVueVcrejZJY3FBR29MMnYwUnVOSTNGOWtOaHpUYlppQWl0c001Yytma01j?=
 =?utf-8?B?OWFrRTdSY3lFMWlIcjJMZ3RuUU1wbVVSbnVqUU14L0lteGxpanZXaTR5Vis4?=
 =?utf-8?B?Qi8xTU5BaVpid2xoOVhXdnpwbWJwRitVVmNNMWVWTi9oeXZhQWlvcWZRZFB6?=
 =?utf-8?B?dmxDTU9POUZPbzRkazlzdkQ3OXFTOW5wMldjRm5XcUQ2QjJrbG5Ub0ZtaEt4?=
 =?utf-8?B?WTR1VEdrd1VNYWJ4N1Vxd1hVTkx4ZU55WFhhRTNESGoza3JHTTdxKzFGTjNz?=
 =?utf-8?B?SjJuTU9NdlZBUmZoL3JKc2U4QUtPbW1vVVh6Mk1xZEpKQTdxa0FvZk55U0Iv?=
 =?utf-8?B?MzFKRkdLUUpDQVRZbDZIYk52MmVkdnlSMFlLVUVoeFZvOC9JVlJkZStPOVRV?=
 =?utf-8?B?ZllhdXhETnNMczNqdExpemRPQlZwcC9CSzYzTlg4dUFQVHVqUE1YMXhoS2Y0?=
 =?utf-8?B?azR6RTRFcVJDTEx0eEtid01UTjVXRTdDbjFGSjV6bDY0T0NkaXArZzBwQUZD?=
 =?utf-8?B?UTdrbHNwOXE0USt1SXllRUEzZGJsVXRBWkhTSEljVDJPbzNoS3NrMDVsaytK?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jrQ5WqXLvQzyxmnxsECsSZBok3XM5CzM3G7qHPxLdg2J0kGawZuN0scM/7sMi933HS4Wfh74PIg9nHkDLWAuGARjZPEEw5MPw0ifxOytUc5miBKoP+JFlm8Rr8FBTwaD7CVVw2N4ORZaVajapjM6b5tJiUR0FwFRoArllgZ5KXNd1raYezJbQ2FqzVWBhqSDJGVIjetRgMrMDlc1mu3SSlZP6PrrmCfUnQ+EV2EoSerPMc3aM/4X/FYZnGEuatZOsvsYkwA7nJ0PMe47jFwpee0IYznyT8CKhqaWHYQAwrvcQ3GpS12M85NqaWP8hiHn9ACMzzkrhkmiDr0BnMTvU6Tng/CJebCmN/wqF3PeEYYHFuTrINsesJah0nyK2MI29fZNtmcMA3CrfkzJyuCIpYGsOG248SRv+jZbr2Gvep2L6QC26fn6XXxR9A+ySp0Qkw1k+y1eecmJuUSPvKAa5CMjlnQLOGCLDqE8i53QvOwx/SxQNtclUU5pyz6kJIhq6v0zg8KlI624tBe++3FehoysFhrBpCRuhCo61Pkax0HchrjmRckmrkWiCiY3Nt/4xQfdnjaMJi5ZwHBD8kMMGuwx07sUJafQrisyfmTeCp8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f67c3df4-311a-4458-afe9-08dd580543a6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 14:36:19.3239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sgrwRsmP3l+PULcY0SmknX+f/3Lc0SwoeATeJd+AOFybQVGWyJWrQiKjzzC25Is5e8EtsoxBwlOHSa7s7sybcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6351
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-28_03,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502280106
X-Proofpoint-GUID: j9wXCP5KDzO1KJY9T4qU5-x3VZSix_JX
X-Proofpoint-ORIG-GUID: j9wXCP5KDzO1KJY9T4qU5-x3VZSix_JX

On 28/02/2025 12:46, Kai Mäkisara wrote:
> Fix two command definitions:
> - flags and service action reversed in SEND DIAGNOSTIC
> - ATOMIC WRITE missing opcode
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_debug.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 2208dcba346e..4bc0c8350b99 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -817,7 +817,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
>   	    {6,  0x1, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
>   	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ATA_PT */
>   	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
> -	{0, 0x1d, F_D_OUT, 0, NULL, NULL,	/* SEND DIAGNOSTIC */
> +	{0, 0x1d, 0, F_D_OUT, NULL, NULL,	/* SEND DIAGNOSTIC */
>   	    {6,  0xf7, 0, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
>   	{0, 0x42, 0, F_D_OUT | FF_MEDIA_IO, resp_unmap, NULL, /* UNMAP */
>   	    {10,  0x1, 0, 0, 0, 0, 0x3f, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0} },
> @@ -852,7 +852,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
>   		{16,  0x0 /* SA */, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
>   		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xbf, 0xc7} },
>   /* 32 */
> -	{0, 0x0, 0x0, F_D_OUT | FF_MEDIA_IO,
> +	{0, 0x9c, 0x0, F_D_OUT | FF_MEDIA_IO,

Any idea why we don't use values from scsi_proto.h for these, e.g. 
WRITE_ATOMIC_16 in this case?

>   	    resp_atomic_write, NULL, /* ATOMIC WRITE 16 */
>   		{16,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
>   		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff} },

