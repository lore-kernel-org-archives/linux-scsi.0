Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD27328605
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 11:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768563641; cv=fail; b=AcnTCtW2gnxs6+XtEFJD3iNNxKVrMH9edAs0uWkjctLKyqVmjD3Tda81vvUJPBqJDr+FJrboQnnf/1l0rmb4TF87ZVDVYSEQ/N5A+qBDSOz4sy6zZcZ6eRmiW9Y0WVywn+c0wFLLoFhSrC7WkonUlo0EpXexDCFMukuLIT+mS2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768563641; c=relaxed/simple;
	bh=GymG9tUSJveNwslb8fEPIV/8ZRxhG60qDcU+ZN/luqo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IFkhqne5bbobNsdownxNOBPCdFvo0SoQgSopWsbSJ4drWDtPSLdwrXCYsPALiVlWWys/iGZ93+ygFQJv0hwH9YOFLCbQBIZESjGyE9xVVwEwP1BAbzqxb4uGyOZdD89fkNoEnbuwSNWFB4rSW1uxWREnkMO9MeZsvJIZrNIWK14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HSZzU7Rr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zsJr3IQO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HSZzU7Rr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zsJr3IQO"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNFcp1429743;
	Fri, 16 Jan 2026 11:40:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=SnpPmw8PBVXw89yxHMZmBQCx3AZCS9leMQVHN6wUM/w=; b=
	HSZzU7RrR4VgEkhQCFXuSp65C1358BsMRP9pRkiejsGOjoGZWXHZuAhzOztE8ZBc
	2hHKjWD5I2Flco6VHrX6xjNJQ30t1/IJiskJrqSJEnNbw6onoqMqpowWrSfV+1S1
	KAsLlr4QhcguDkzaj6KVJ+24nlCkTqt5YlSgqO+fDOvtjYscFvuoRhXYJurFVnnC
	mkHG5ZLekSCZlLbtd3yiK4j4u0k9j8NjRUIWQ+6KDf7onKSB47dn2tm/IuNfdmOr
	QLhkPLff6eUoRgAvOokpHHnTY4nnlXhFs0m6GvxzfTwEUtEUS0O/RtPup6MWrYzT
	66fv1NPa5R+Vo5JgybJQ9g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre41urt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 11:40:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GA4V2G035319;
	Fri, 16 Jan 2026 11:40:34 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012062.outbound.protection.outlook.com [52.101.43.62])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ctfa6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 11:40:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aF+6yJk0wLGZsvCQfmHGawdu6corgwbFQoyJBqB5VigGrqirD7hTcd3E+XrS17d1VSRlRoZ0uVhHRsRq7rWnuPj/BHKpHiii+ZP4Jyzb4/Qmzd2YYKtUX3/XPF1Q6PtM+4Xjw5yLLi/cDUwAV2x0xtXV7wRdGLvPTNWeoJF2pTqkNAEoxgsB4/ZG8OTXCQLRFR1XKUeicMaZr4J5wL9QHcSCj9hMOl1TeMhT9TtlsjFMnyjB1gMyW7PbQWoL1lI3YzK5f54/O31BL82gquP28pXrURzug79FYD2ZghcfgZywsU89kT99IRH6fENPcJrukQcM6VH/XkCGkb0tUed3VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SnpPmw8PBVXw89yxHMZmBQCx3AZCS9leMQVHN6wUM/w=;
 b=EzmGPVpKPySk4FcR1W8rw+Q39wc/BkFz+IiMdUVWG1K6agH0TSw16Ze4Fm5HdJeHcFrXFEcqDZpn+uTFaMbyDqNSne+WYMn0V7J3rGNhk0Xg9qLFauJzl8EgzM7te+qwXR12GJIacMjPXm8GJXZXUPAYRvfAv1pNBQMz0pYYXCO5k8eB5J/k5LYruDgXJN7MrwwOAMb+THDM30j36fbx24/2jCHE27RM8jQcm1RJoDx5sf2zVjG9sM9A/G+YhX9rQxcIkEdfYCaEbAsPqbfnm+p6V5N4qgOpWTuhhLcmUqF10UvVmgAZeLxRv6dCoWE9a05X2Y4uNX0ho1Dn2X4cxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SnpPmw8PBVXw89yxHMZmBQCx3AZCS9leMQVHN6wUM/w=;
 b=zsJr3IQO3V1EYrCwLYI5zbEvYg4Pgwq+XcWeyl3a41tKBcqvRE/x/104L2QOPCIFapZi6Psucs+hiEQMiUuNRdjo/NSNITC4EhGc2s+0Vw1eedg7qPRl7CjEUZVeKIQEWqe8fts0JC/wF0XvsN8yi6hRqA6wymtIZ9Uz7xixjNs=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY5PR10MB6096.namprd10.prod.outlook.com
 (2603:10b6:930:37::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 11:40:31 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 11:40:31 +0000
Message-ID: <d3a77799-fd03-4a01-bca8-d997f0676f42@oracle.com>
Date: Fri, 16 Jan 2026 11:40:27 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] qla2xxx: Declare qla2xxx_mqueuecommand() static
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260115210357.2501991-1-bvanassche@acm.org>
 <20260115210357.2501991-5-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260115210357.2501991-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0248.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::14) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY5PR10MB6096:EE_
X-MS-Office365-Filtering-Correlation-Id: 0399a907-aac7-4ae7-ed65-08de54f40d7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVd6ZGhLbkMwS0FjOTduelFuelFTbmFIUkRSTWpkZThEN2JZK3c5RVc4d0U3?=
 =?utf-8?B?QWt3YWJRVm5VMExaSHZ3NTNrRWNZNlF6Vk4vZU8xcExyNlROOHNvM3RqcEhs?=
 =?utf-8?B?dUVzTlJMSjBKdkVQOTdBOCtLSDVVWExrSGd3WXo4MUw0QkVuZUV4aWthS3B0?=
 =?utf-8?B?d1N6NEI4VnNETHUzN21iUVhHMzAvNUZRSjA5cGFtU1ZBQVA2TWtOV1pWNWdY?=
 =?utf-8?B?SHd1dmR0SjlPZHBsWDhTSkRlTG13TDZuSWdTdkx4UE5RTy9GNE5uLzZBQmMr?=
 =?utf-8?B?T1FpMGdVSXQzY25qd2Irdnd3OGtVQ3lvb1NiTFVIS1JITW5FTzR3NzdBVDdJ?=
 =?utf-8?B?TWF1TVhtMTZEbkZQczg3bGhZSEVvQStNK0hNdmFTSXhxdVNtVW1LbWEydWNK?=
 =?utf-8?B?SUhpdkoxVHljSXZ2QzlMSmk0ZWo3VzVBUGF5NWRmU0R0QUdnV2dHbnJIKy9M?=
 =?utf-8?B?MzBWdGEyZk91SGlwR0FMOHJ5aWlNUm83Wk9HNzNSOVhGWlJCbVRtL2FEZE9Z?=
 =?utf-8?B?TE5SSVgrekZ2MTJSTlBFM00vY3VtaHNZaWw3dXpOa3FBNHRWYjlrODJEWXdw?=
 =?utf-8?B?bXhrSzhEZmVWT0ZFY0YxMEpqL08vVk1MTGd5WnFselE5VW5OSkVMR3FNVmU5?=
 =?utf-8?B?SU5DZ3gzOEkzdFYxOWFuWDgvdStCdG5WQTFLbTR1cGl1SUlmanJnVlFZY3Yz?=
 =?utf-8?B?eWdVb0pMMTR1eVZMbHNsQjR4dEI2amRmRUdtMmo1YnBKZERadklxMlhVUlZz?=
 =?utf-8?B?c1BGQlNQdFl6UGJ2dE1hdWc3RE1BbFVTL1BUWkZqT1VabHJQZHlmNTRXUWFS?=
 =?utf-8?B?ejFBanZubU5yR0tUN1g0R3NhNzh6QlVCOUFWTGZldTk2ZTdlamJFTUFZMFo1?=
 =?utf-8?B?VUxienJaMERlNmVQeTYrc3BURDV1eGxBbkxWQXI0RXlQY3J6R1hreWRVYTUr?=
 =?utf-8?B?dFR1RHdBcmoyZXR2V1lGM1ZpZHA5T3d6ZUR4anhqV0p6eHQrM2VidzVnSnkx?=
 =?utf-8?B?aDZGbUxuUkVzUVFVaUZweTNXM1RGaVkvOVNMb2hWNDBWZS9YdHhiRENWaEI3?=
 =?utf-8?B?cW1vU2VoZ0JQeFQwQUh6dUd0bmRCS3NaY0IyNjFpdUZFdnpTQ2k4dHprM0hw?=
 =?utf-8?B?Y0I2MW5YWmE4bE9xUGFmMjdkTnErUmt1ejNkZjhvQzlSb2UveXEya0VYUkZz?=
 =?utf-8?B?YXpsNCtnTGVYelI0aTlKUTQvdkJNT0pDc1JRQ04yNHR3ZmhJSjkza016MzFl?=
 =?utf-8?B?K29CNEhuc0VVcW1Ec1YvR2Q1UjZJWitMblYvNk1DMEIxOXVSWlJYZXE3RWVH?=
 =?utf-8?B?bFRsTHBnMGNDUHo4RmlQaUM4d1ZDMlNob3hERE12My9pWkxkV0IxempHblJP?=
 =?utf-8?B?MmFleDdGbXRodE9hM2J2b1RLVlBjTzlzVGFvMDBjdXErYmdJWWFRQ3lUVTRH?=
 =?utf-8?B?NFphRUorY29IR1c4VU9mLzI3ZlZ4alRPRGt3c3NieWswTGdvNFVtcDhOZ0lz?=
 =?utf-8?B?UWVNWmQ3MFFCaSt1WDhhalQ0YU9oZnlleVhWNy85UzJNYjVQVFhMcHNWWDFW?=
 =?utf-8?B?SHhhRWRmZUlwS0FTUFBBQWxpZmtDNC9nRmh6OU9VVC9pdHJUbkNSVEJ3cjNI?=
 =?utf-8?B?aXdWVktsMFF1ZWpONG5UNFY2ZGZ2T2hOaVo2NGZxRmk4TUFjRFVMNm5lWWFm?=
 =?utf-8?B?aEMvK01TQXg5Y204YWd4Z083OXJuVlFpZDdMNmdEN1ZwM3h5dk1UVWFIcU5J?=
 =?utf-8?B?NFM4NGFOOHZ3bUE4TURsMXpiUEJIMzVVWGJ4dkN5SVlqbWlKdVI0bGM1SGxD?=
 =?utf-8?B?SXpJSHpsVlQ5SzBxWVRpNGZZZklNbFhGZWlaaERJOVlRTnhFa2hFajdaRW5B?=
 =?utf-8?B?ZGNJU05WVmZiYjNhNXhObjViVW9QUjBVbHU3ZFhaNFNpTVZWYmtPSTBOQTRX?=
 =?utf-8?B?dWlsbTVxVHYwUDZGeHRlSWRJYXF5Ump1NDllSGhOWnJRUzlEYndyZThWVmN1?=
 =?utf-8?B?QmUrZEFFOXgxYnUwVEI3WWRVd3dSdVc1QjFIcGZlMzFLQ2FlbXZsS2ZtSFpT?=
 =?utf-8?B?VXNyZUQxdm53MnhKbnNDWU5mcno4WFpYNjhXL1U5N21zQ1RPb1lTQ3FQcE85?=
 =?utf-8?Q?+sMY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnRsTUxhbU1wTHJieUo1NEZUYysrY1FibFVmOHROajdVdjN1Y0xqL1Z0K29h?=
 =?utf-8?B?bnVnRjFqb2M1ZDVCNjgwbXo3VkNOcU9SRWZDMW40UTU0ZlRGL0Rzb1FYUTJC?=
 =?utf-8?B?N0l0cE9GSS8yYXE3VDZ1WkFiSlZNRDNLQ1dFZEpOZVlZamtKWEd2SEEzQ01N?=
 =?utf-8?B?VW4zZlFyNjhYVlF0T0NBeC9VZ1RrYUFlMjB6Vm5uWjdrK3pXV2Z4MS9VbDdC?=
 =?utf-8?B?S0w1UzNmNTZveis2dUE1OEZpS09EQk1NZFhXdksrRUpsdlR4MlFzclR6a0RH?=
 =?utf-8?B?QlVzSVk0dEU5U3F0TlVkOXlSVFFhYlJpQU1DTm4yemFRckpYRENWdFFzcmFJ?=
 =?utf-8?B?a21RZ1dWaDBvVkZpTUJQUkZxNXVRMkNtT0pMMnVpRmRPRmx5YllHd1NHbCs2?=
 =?utf-8?B?c1VWTzJzRzJKMG9kUTVYN3BPRTQ5MTlDOVpaM2dHcWhEUmhqMWorYis2OHpT?=
 =?utf-8?B?QmlGeTdGQjdlMDlNK0lNckdPN2dzajlENHhBWnpZeGp3VER3ZTIxakdsYTRP?=
 =?utf-8?B?ZVplUU1BWk5KWGdDZkg1S2lPMUMvUUhOY08xNnI2N28yT1drcXBJVHpMNTBE?=
 =?utf-8?B?aGMwakFMcm1DdTBXS2xoR29JNzhIWlcrYzhYeDVrWEhyZWhENVJaWm1aaU1R?=
 =?utf-8?B?NkZxRVc0dGpGelVQd2w3NjNodVl3YS9aemhROGFlMnlDb1pUYXZKRWJNMWkz?=
 =?utf-8?B?OU82RFFxSU80eUpGSVRBQmJSeGpvZ2c1WndXZTFQTUtGNy9mU3N1M3daakFv?=
 =?utf-8?B?b2xDOWx4V1BybE5qSkp3T1BYTmMrL2RDRk9HaG9DeEdNN3dmdzkwTk1pYmVH?=
 =?utf-8?B?cFhQYUxubmVvN0RSQ2Uxc2lOL0VxTUpkMHE0eSs3a2NoVHdQVVVGLytJWjVJ?=
 =?utf-8?B?VGtQdFM1THBTV2FiUkZLNVk1YW9URDE4NjlTbnlxUDhxbk1ybFEwRkg1Y1E1?=
 =?utf-8?B?LzZjR29zdUVHckFwTFk4TmYxRXFiemtCdk1QeGNxcmtVU1BnUTdCNkZJWnkz?=
 =?utf-8?B?M2pWaVBnMGFpbFdzNk5idXoyWlhySGFxSHcwWkxUZkw1NW9YcW9Ob0U0bkNG?=
 =?utf-8?B?bjVtN3ZSTHJmbVZrbktESXA0Qlgrc2RsVmRodzYwWllLczdCWWNjQnE3VXo5?=
 =?utf-8?B?VytERUc0SWhXR1ZjbVh6c1VkZGdYV1NSRkJXNWswV1JzeWcvOWZNUkZkbjdz?=
 =?utf-8?B?di9hMlFnVG0yN1BndmRkU0tCR3hvZkdBemh2Sm1YYVNYbWVHQVJsODZIWlcw?=
 =?utf-8?B?VDh4L28yeEUzN2lvallLQzNiM1VGek5mVjY1NUsvZjNKaGhNem54VFp3TUF0?=
 =?utf-8?B?eHhLSVVta2RsYmlXcFlpeWhINHlBa3pXY3lHOGM2dGwzWnFsY0h2dWFLYUJx?=
 =?utf-8?B?Wlk3VU1SZkhSM2ZSa3dnSVg3SDdlTlNwTUhVdm0zN01vQ0l3ZDNBRVU5Z2ky?=
 =?utf-8?B?diszaHlvNGh2bG9SUXFqU3N0c2toSXBlclNaL1U3cWxodnk1VWhZUnA3amJJ?=
 =?utf-8?B?SE4wUmtYYXpOSlFDK3lDQTkvL2ZSOUdHOHV4L1ZrWXNFVW13Zjl3NWM2SHlt?=
 =?utf-8?B?YytEOGllUVJ6NkM0S0JjSExPcnV1Rzk4MnkwNGMzRlBKdmNPYm9VWW9DRktH?=
 =?utf-8?B?Wm9rSGtmczRiTHRsM1FhZnpyRTNkWmc1R0VLQjNnaGNjNUZ1RGQ2emJBOXBs?=
 =?utf-8?B?SWE1c1pQOE5pTk56Tk1LL2JiV28ySUNxdGc2YUxwQXdNU2ZXdVZLaDJqRTla?=
 =?utf-8?B?SzErSXJVcGlSNWNuTEpIVmQ1c1JOYU9wWDVVOEtpc0VDQUhMOFl5bVdNaVVu?=
 =?utf-8?B?a05Nd1ZJU1BRdklHS0EvcEVZazZ2RjNBbW5VZXh3WXRBdUwrdkd6U3RWSGM2?=
 =?utf-8?B?M01weG8zSkZLeUw2SnZJOFRmcUU1RW1WNjU1NjVKV2pPNDlBaTEvL3JlMVpU?=
 =?utf-8?B?eXhLcHZhMkVMRkhXNlpHc2VQeFJzS1R2blE5cUlZOGVaM2tSZjM3WEZMc1dj?=
 =?utf-8?B?UmR4MEJ6WS9uQU50Y2pIalE0M0dvS2cwWDIrTlFWMGorcmdha2krTjJZKzNr?=
 =?utf-8?B?emFkL0kyU0FaTzh3bUV4UVBvZThFTzcvSFV1TG9wVTliSERySlI5bjREZlBq?=
 =?utf-8?B?VUJJcUVJeFM3SThNY0xsSlAyYjN3S25SNTgvbDZpVDY3OHovQ2RteTFnYnVk?=
 =?utf-8?B?SS9nK1l5SnN4NWhpdVVvV3puMFdKWlNjdk82T2E4aXZKK3YxUTZmTWxUWDRa?=
 =?utf-8?B?MWJ3a2g1ZlJ0RkhqRW1PRis5eTFyYlh2cHlvcTZ5TzU4TnIyVHhRd2RHaGxC?=
 =?utf-8?B?ZUFDUGcrZkE0NXNkSk1EejZONHRNTVpGVUxQZDdaQjYrenoyTTg4ZkltOHFS?=
 =?utf-8?Q?M/OSBo/XGgnW7r6w=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Hatlxd9kWUB5nh1r4BW53Yovuo+bAjMse/T4rf8IiyV6ou8DLc6jUkp4PgBHVLABZ1AkQiC8iUfaTSbNGJQG1dRuGRLJeOtWhPToz8q9JqOzTvmbYOvzXWyMllgG0ht0H4Scun9dDD0vkzqtdAkQ7zSapiAbIdn88NFSqztV509mL0NR5HGYs38rH5McVYNpAO3skUuBhN1IRqHDTOOEcaX/YVJmr9jZVTr2NAoFtfdx/ldgUtjQ8dl5/W0yaQ0zknLRZHU0wl5Hnn7DrYNyzlqUSQRIz6ReY+n35K+lClsjo/Ih8JJtFysjRit2Xgd83m1r7cAH73SQ/Y5j3cYM8VF9tDaldwPOiux1+GKDI3WroOHWXqctRJ2drZj/M4qy8RaIWotPFBUq0TOvKpHUnjuChkj4CLSY/s4CTf2X+rPz6rh+1gBWylsjCUs+RGx9utDszAa74BfcPWz2d3DEVpGkVOKIyeYYAz3B56onnOkPaHU6K86W/KkT+IoOl2OQvbfLBbaYsAHlSgxX4vZycLQIwX3paE6BlWKi+7jsN0AiE37C/bAr53RJ8I9G2Xmvow6yKRHySF8GaPOpjmHvNk85Iz/UQhRWuk7174YVVzM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0399a907-aac7-4ae7-ed65-08de54f40d7a
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 11:40:31.0481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w03gAU3V98COWAIFs5lA9+SYRg/RcirtnNbXcMGMyJ5Q4Y40Rl2uwd7t86N1v2yo39GvrBcpA/n9Vr77kl2lLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6096
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601160084
X-Proofpoint-ORIG-GUID: r6pZY1USy3W4Dd-bpsSWrMQlwAgEAgZ0
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=696a23b2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=M5GUcnROAAAA:8 a=N54-gffFAAAA:8 a=yPCof4ZbAAAA:8 a=j5ftW6QZBCB7dShDYhsA:9
 a=QEXdDO2ut3YA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA4MyBTYWx0ZWRfX+izceXJL138z
 4JHi6HWD4F302fEbbYYHisQqd9SZ9zq2rSHaAn7qbI5+hjHTgMuqzq6iZznzcENLa0nCYzPFDac
 wR+arLkPaNc+JKUpHSel3Asnf+auFzsWYm6w21ZELsgbcDJt1UHVL2JIBqOW49foljjLBjhANcG
 G86QTq4ec9xDfxMt1BrO4/1MudywlaOGbJgkAHzmIEspJk2q5pwRO+T+w9RJVx17ilOduonwIHr
 lPGB4xjPfBvW9u24krLZ0MX1+RcqbeSLA3dpIu+wUE3cvcy3wdaC2sD1ogNzgYW9gU0OdEimzB6
 XO7HGrZ85iKT/uph3PDcwSWDZ/CDxGzHtVRBbvrING+5ljuLzKF4Wd/Dg6h7LKtTAm7tn+UskDO
 MPPS+7Dk8y+8skfy6vNlRYxhj1/6eQVIde55OKj5P1YLqDAZjZOF/CTRnRUqUM3Qt2pD/PC1QxY
 t5KOM8QDWAwY5dNWnNQ==
X-Proofpoint-GUID: r6pZY1USy3W4Dd-bpsSWrMQlwAgEAgZ0

On 15/01/2026 21:03, Bart Van Assche wrote:
> Prevent that a later patch that modifies the qla2xxx_mqueuecommand()
> declaration triggers the following checkpatch warning: "externs should be
> avoided in .c files".
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: GR-QLogic-Storage-Upstream@marvell.com
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/qla2xxx/qla_os.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index c9aff70e7357..fb0b689cbacd 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -402,7 +402,7 @@ static int qla2x00_mem_alloc(struct qla_hw_data *, uint16_t, uint16_t,
>   	struct req_que **, struct rsp_que **);
>   static void qla2x00_free_fw_dump(struct qla_hw_data *);
>   static void qla2x00_mem_free(struct qla_hw_data *);
> -int qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
> +static int qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
>   	struct qla_qpair *qpair);
>   
>   /* -------------------------------------------------------------------------- */
> @@ -981,7 +981,7 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>   }
>   
>   /* For MQ supported I/O */
> -int
> +static int
>   qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd,
>       struct qla_qpair *qpair)
>   {
> 

