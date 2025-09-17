Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1043B30CB31
	for <linux-scsi@vger.kernel.org>; Wed, 17 Sep 2025 13:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114669; cv=fail; b=NzrhPi3FjXFe6W+/QCwkBqZpSeSXHTy/NKNlQSYK/R9CM+EulqLgMWU0vPEZJzkfvdPY91hGjOHXY6iuEYpttXU6ERr+xqMYFh+i3i+k9gXGzXRBoNKVgXW42XIKjzKfwFXSGQhTczbD8/NjzDCjMhzDfiy96MkMDg20qd1Hcr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114669; c=relaxed/simple;
	bh=yY/8CEdxnyGRZLYD0ST6tZk60GpBJpVf5TDQAUY4riw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kOBvFb3X+6KgAcEdODjf62TwpZI+LiBcjuco2PEs1pMG4TWhxH5f3AOme6Fm4JHRtoIiaf5DS0BH9acTsE98Vb1yJ+0oxJRA9tN/VN/HKuXjojrNgmM9PVOzniIc4/AEwA85LIhgL6zw6G0qwzwPQMUpQa12jP4auY1W3mCB+6I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RHiu8PGz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QVUu/veb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RHiu8PGz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QVUu/veb"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HAQxW9008483;
	Wed, 17 Sep 2025 13:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=4LwdZhyP/EHnPXliIrbB25EZI7BuFuzN6w9bBaPRxSg=; b=
	RHiu8PGzT5D8q9Mf6u9Q2GWvst1FucVyydcJr6gnYr81tCe1FDVNkPGrbAMa03LG
	9QX6G7l0e41Ui2z2mSnizsrn6/qBbuZTmfm8aqgqPCXvd/xPh42NdfIMQ5Ilv04L
	ouMpLJTosWUK/phb5sosN0WpLHIK4b6JRBpElPRl1pW/A3laiKQdoipTMml7jjHy
	o6NWPn3ddkPEhjVWgmj3qadIHEV9nptpdqVReYv5KPE8XxWTSASW0FTGee0+fGM7
	IZRX/8AaR3kcgkD6qXSPieCNshR3AZihVgheTgrjibva62OAobvHxzbQplZxmzN3
	ETJTZoVo1SvXlMbFfo/ovw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx915cs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 13:10:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HBXX34028825;
	Wed, 17 Sep 2025 13:10:59 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012055.outbound.protection.outlook.com [40.93.195.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dqp15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 13:10:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RO/azzB2kx2ncQCVFO36mv2jJxlPwROBwoJFhxn5c54obN09vmSOv8ht88fvqWMG6leKYgfe3GPFrwdk3NzMxM6nz/3hEJVwMBchWmZqvmV/mIvlbMrrOoCgXjHTfJRuvu8h4qKncKZJVPJGXnF/HKVt+R2kw5d/Vu4T+4a3Tz+LU0uJi3S6AChTNdmTrsBVAvYSmI8hqmDEJW9EP4/HgxUJ7qFxj7B9JdoxTViulyC60tUhlXxu8exFqqqhlJOgT8am6YGuit3Z2b+HK9tNJM5ZGn84KLaRiqNodQ55zph3ZffxuvhxRGBh5TAJShZW6Af/kl/MClqCNIy99q0yrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4LwdZhyP/EHnPXliIrbB25EZI7BuFuzN6w9bBaPRxSg=;
 b=ioiN3pJ0iAJiwXxtvtWK5RSCl1pNeM0rPiGljZP4n19t00D5lUq2cqHQmyZoAqsyTwBisYrb7IuEG6ClvYNuwhTKpbnLw/Obc3ooN4aD/JUnWmCCdbbyTYrDeD+UQfdgI2mU9MJ7iZqn94jLLhqV+C4XfhnfAt8fVWKeiLoWGPT5zKzSJ9F/vVz/3Iub3fAWtFC0FEIf/eJdkMyzPHVAkdOIiPKir/pm0wGhfaUoMG7dfaLpXUo7wuBpVnBZsCHqT+NoXY1JZo12yjmN/HIHx277EKOZklZDrwnUueXmd+kQRWN78X2x0uQnUIdAAMlmUYyI4YG1QqMIgfMfYdrHHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4LwdZhyP/EHnPXliIrbB25EZI7BuFuzN6w9bBaPRxSg=;
 b=QVUu/vebO/Osr4i6hkp8l+jJXzB0L56ZNugk0L3G0/bFy0tRsljcjzPcQa/akXatX6FkIwwLTghkoKR1ptXqUIPn7jcMipcF1/cauZTGdyBCpQKgnMWjqM9TQotD1whaX0gZFEDUSEQRBE7NuL23x6hI3VPaSJcyV0+rPwiGVy4=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA4PR10MB8586.namprd10.prod.outlook.com (2603:10b6:208:565::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Wed, 17 Sep
 2025 13:08:28 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Wed, 17 Sep 2025
 13:08:22 +0000
Message-ID: <871a7b50-8920-4808-8537-e188e5ad91ab@oracle.com>
Date: Wed, 17 Sep 2025 14:08:18 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/29] scsi: core: Extend the scsi_execute_cmd()
 functionality
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-7-bvanassche@acm.org>
 <3688955b-ed3c-497d-a54f-633c9587a9ba@oracle.com>
 <2c10d952-8b21-4432-9a87-a4c82745f2d7@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <2c10d952-8b21-4432-9a87-a4c82745f2d7@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0048.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::8) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA4PR10MB8586:EE_
X-MS-Office365-Filtering-Correlation-Id: e09cf755-c054-47cc-c849-08ddf5eb4776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3dZRUlZTDFEZ3V0ZDZsVldBRTR6eWx4aHN2VU9va2o0Mm1MRElKeHlZYzdW?=
 =?utf-8?B?V1BKRDRBNVllQVJ5MG9jVlB6aHhTUTJQN0lHbnV3dXRBZDZQY0pVV1pBblNS?=
 =?utf-8?B?VEZPbG4veUxDMkY2bzA1Rzc1VFJDeFFJckczZEFJSzBSRjN1a2g0V25Mblh0?=
 =?utf-8?B?NXdzV1IxaVN5VDhhUWNlR1lKZEpmR3lFY3NEbm5zZ1BlVUVIdkd5K2toWjBP?=
 =?utf-8?B?TnpNOGQ1bEZYaWtNOGRpUll0QnFJRS9MYW4xbkd4NVdPd2p6c0RpaWFkOFZE?=
 =?utf-8?B?aDRJYUlLLzRGQ0pDOWNTSXhPSkRPWit6QXRTYmUzSjF5ZThjdHIxZHRudGJ4?=
 =?utf-8?B?dWhWZmhsbzhrdEFqTXlTUDNRVm0wUVJ4TnpIVzBYRzhxQjBjbnNsbnkvRngy?=
 =?utf-8?B?WXRoaTNMaHR3aXRIeHdhdXZWUnk2QW5jcEN5b0N6U3Q5cG84SHdLWU1ERDgr?=
 =?utf-8?B?OUZoemRpSDJoOTNzT3ZFenhVUEZYTUI2blJENFF5RVdMY1IvaFVGa295N1o0?=
 =?utf-8?B?Zmk2Y2RzRjBoR0N0MUhHTVJtdGJocHZBZ2txUUJXRTFOTjJJMW56Y20xU1Fs?=
 =?utf-8?B?UVZ5Z2lVWXV0Q0doWFZ0eUlMWXRGZ0NxVFI3bmU4T1VUVldBREs2amdLRSsy?=
 =?utf-8?B?MkJFcExWQzFiK28zRTFSUnBCanN6cWJVZUFac3M4eFpwNzFzMmszUXl1NS82?=
 =?utf-8?B?NndLdlQ0MWlxaU1oSlRUYlUzMDFxYzgyTUQyQUtXS2ROS1J5ZzRldlZkcE5U?=
 =?utf-8?B?cThRaDBQcSs5RnNYcXBzOUZJOHRVTlBNT202WXp6VW9YTjJIaXMzczJIV21l?=
 =?utf-8?B?TUY4ODZQa1k4Q0Q5TFhlTWlOeW9neFduRS9kd2paTDZqVVFwVUNrZDVRYURT?=
 =?utf-8?B?TTJpRWtqMGhhVWVnYkF5ZDNvSW9kZ1NsQU1keDBYODhKZXZGSzk1TTlMcWpH?=
 =?utf-8?B?U0VlaHVRbE1hRzdMejNSWHdGOGZndmptVmlzWDNLSWZsbXNWYm41eHpyR0J0?=
 =?utf-8?B?MEc4ZGpMQ3Ewbzc2QkI0Z3E2ZUwwL3FQeW9mcndWRlkzRWVQNGUzYTVRcTAy?=
 =?utf-8?B?V3J5alBERm1MNElNVnUyVTNiaG9za1dyaEx2bnJvd3MrcVZpQlRZbTQ1TUdv?=
 =?utf-8?B?L2dKVWlkUDRvQWRBRWhHL0N6eXVYTDJ3aU14VnRTdnRSRkNNcGhyZzBJU2Z1?=
 =?utf-8?B?blNGVUM2aFN1SGRyT250VlJTczE3OExHN0VIUzYrQ3QyOVcrNVVYQWJHOExl?=
 =?utf-8?B?Y0tOOXhqbGZYcytWNnhNVFpkdjdjbFJ4R212bjc4RzVveEtlOVdTZ2NDU29q?=
 =?utf-8?B?ZjhWNTdSaWZ3Tm55SjlRZ3VXNkExZnNKMkFFN3hHWGRaRU94cGxlV0dTYlZS?=
 =?utf-8?B?UTdzMHFSV1NtOXFkS2JPV2pLOHVBWWRMZ3hMUmt6dEY3TjFtZWdSbzRmbVJq?=
 =?utf-8?B?QTZFK0ZwL3FPbXF5dVB6Z2lYYWY1TXJxM29iNzdnNHpQNGN4bC9CdUh3VU0z?=
 =?utf-8?B?WFBTKzJ0RkFJRUFRM0k3dlVJV05GUXNZeStvamtkVlI0UVlzRnl6cHEvQzJL?=
 =?utf-8?B?NkF6RW5OOTY5UDdFMUZSeVYrWGw0anV3R1k3d1J3Rzl6SmxReGRhc052TzdS?=
 =?utf-8?B?OHl4dUhDZlFUV0ZjUFR5MFdrQWxscDFUdjNlTUdqZXBQUFp0WWpFOXlDN0Qw?=
 =?utf-8?B?S3FJK1I2cDlXOUpURDhQYjN0VGw1SVJDdytpWUYyRUw1Wm9yUjhGRHVPUFFs?=
 =?utf-8?B?aXBmNTdxdEZjSTlSVGFqM1JuTEppdzFiUmlhdlVyZzFzSXJKYU5rcXE2b09T?=
 =?utf-8?B?MWdPVzhaZmJsWUVyelhESnJIczJ1MHFhbG02MVhiZGlBL3F6Mk14OEMxWjJp?=
 =?utf-8?B?b2pFbFErb3pRM3RDK0pvUXpsdUV5MzRPZVkzVkx0VEFyb3JJbDZvMnNPcHc4?=
 =?utf-8?Q?4hURaK+lwHw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3BRNTJsSFRPY1k2Y1FoR0pjdFdjTDdaRDNpenJJMjBRVlRmSXIwcGNpbkZ0?=
 =?utf-8?B?eDJBM21VaW9jVk9mY3dhNzlhOHI4SWIyaEh6NTI1SFIzRGYxbGxDa3RNbm1R?=
 =?utf-8?B?a0FTcStKUC8rLzVFYUk1R05Vd3dqSTNEL2YyNVZybWNQRUIzUTZtdjFxYXFy?=
 =?utf-8?B?d3pnWU1yV2hCVHYwakhvZWIvOHE4dHY0Nm0yYWVQWE43N0xkUndicnIxbjk2?=
 =?utf-8?B?NHhWd1RXZStZaW1lRmljbGx3aSs4czluSWN3S1pPdTVNWk1IbVU4aEpPRnlR?=
 =?utf-8?B?dlh2WTRFc1lPQksydGVDaFhQUW04dlFwZ1publpzWXVqcHdhb2p2aXRiN0E1?=
 =?utf-8?B?VDVHak1Nd0RFdUw5MVZsc1FvQm1idjZ0WnAxVTNsVnpDSlZITlpYdUQ2VXlU?=
 =?utf-8?B?dGpFcDBUbnFDSGtZY2M5YncwTXFpNkhvWU9YWFVLUU95d0RNK0lNN3dJanhk?=
 =?utf-8?B?cmhpYVVWZkJFamtQMG1QaXhXeGhmeE9SQmxCdGFuRVBqYndCZVkxNmlKTkZs?=
 =?utf-8?B?c1E2Nmp6eTVOTnFxNXJNS1BLMU15QjBya3BVelcvWVlzR2xzZXBicm11Qkds?=
 =?utf-8?B?aFQvUHJaWTVMNHArcy9mODkrR0xiL0tnWTY5cisyOVAydEF1L2JVNm95ZUQ0?=
 =?utf-8?B?NnNVUXB4b1hTb3dxbHZ4cHhtMVRITy8zdGhoRm5YYlMvL0tCeVpkUHU4U1Jh?=
 =?utf-8?B?d1lLazgvNWpnQlFRNW1VSSs5OWxteUdxQjNnditLeldCUGZsY2h4Ulhnb0RH?=
 =?utf-8?B?d21LQUdxZmNqTlRmUWQwUXZYbnp3OCs0aklXS2hoR1k5YWkwK2pZbG5aN2xU?=
 =?utf-8?B?NGtiM3pRT2VxejR6Y0IwRWNpZDhBYTFqeWFTcVJQK0RFbXVlWEgrK1VMZjdy?=
 =?utf-8?B?U2V6OVpnVW9RaFZ3UjIzZmdYTXJTdmwwa0w4M1FCV1J5cUUwQktmVVVnTmZo?=
 =?utf-8?B?TjU3WktpV29qN1JSTjdDbExrbTIwQjBvWGZ4eXRETnArR2ZCWDUxR0Y5M2xs?=
 =?utf-8?B?YXV4dUhwNUVHWGVWZHNjM0FPTnhiS1FiRE1CQW94elpteTNWSG9KMXZUTVRj?=
 =?utf-8?B?bWhNaGxxUEkwK2xXZENzTVd6TEtUaHp3NG1hT0hxdlBVcHRIL2V5TUtEMXhR?=
 =?utf-8?B?blBveWhCbEtsV0NsdXFzWkxDa1YyVTB1T1djTVJnRFZXQUZZdER6MVdVZTlj?=
 =?utf-8?B?RVY4WHBncE1TbDRKVWhqUDNuREpNTGFWN1poazNpcTRWYkk2bUt5WFYvMzhV?=
 =?utf-8?B?L1JtRmJaekRsN1FncW03eEVmb3dQbjF4ZWI0RmltRVVQc0RMRDgzSTA3cC90?=
 =?utf-8?B?S09xa01qQkVGbCtuTHQrcXI1ZGRBVDg4K282bG1LSEJjd1RNdy8yRElTcEZT?=
 =?utf-8?B?RWdrWkxOK0R5MHgrTitGTkhpdllGaDNySVRTMEhpQW85cFV3emd6RzRxSmFN?=
 =?utf-8?B?Z1Z1QW4xd2tNaTBJTVNMcW5yZ0xpYm1xd2tCcmdiMUpKWHBkdFpoblpuK3dq?=
 =?utf-8?B?TExLRmxqUU40clpHVG5LR0pyWFFjRkxQMk1abFdVR3VNbE1Ua0M5WTc0WmZn?=
 =?utf-8?B?VlI0Z3pLSlRWV0o1Sk9OQ3hQWTRMeGZVckdBVHc4azRhS0RSaGNMZ2JXdEln?=
 =?utf-8?B?b1BRZFZHbGtZMkFpNGhiVlQvSk53OWhISy9uK2ZoRGY5QnRvVWE3dzhhbjBx?=
 =?utf-8?B?YUIwM0VXc3dHdnE4d0IyRzFycThSdWRjUksvKzluWmo5U1NVelRvMnk3NDNN?=
 =?utf-8?B?bGR4SUtCVHV3K0JJdWZFNXhFMzBKclVZZmhNQzRlNGdHUC9PdzVSUUNPRFI5?=
 =?utf-8?B?MktBYTdndi9ZTzNOeXRHTnZleEJZOHhNcmFnK0luOFpIdmVIN1Urb2sxdnZo?=
 =?utf-8?B?d0hXOVh0MGxNUlAwNWlYdTJMVExKMGVBaXU4SWNUb1RBVHNuT3ZNUWt3dWZE?=
 =?utf-8?B?Mk9iMGlxMUFXYVF4V0h4VERxTzliTG9uR0tnYkIxMVM4VysrdGNxWGJMYnV4?=
 =?utf-8?B?VFdwb2ZzMHJNK1dPbFVhajdiV3FYQmlXTnpNMlF3UEJhWkVlUjRwU2VSZURv?=
 =?utf-8?B?azN3MkF0K1R6NUdqb1BwOEsza2RFcnA2bTloQ0g2NExaNTh1WERKdlVtcXdr?=
 =?utf-8?B?M3hLbmpnM1hGbGZVdzNUTllvZ094RmVXdWtnRkEreGlEUWtEZ2dIaWhuT2ts?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wCG4dA9gmUHs5yl9DPvfxwi9J4tX3EFCVFdvfs9Aus747ZUn8lktIavdIO2dIkT5ZnNUT2F+l9pRXpOBIiKfSpeAYK1dV0L/M1YAw3Rl0TMz4XNgm9j82ahVVMcRIsOkzqU6T8W1nr6Rn4+TXxWuLz2fkhPg14VV6UBHMKIN3lK1KKWpsXHHmly5QvDJHNo1EU8OEx77JYV4CxouBnQxX5Lgs1/IwUvb+R2ybUrxGGUqVB5ZNxfglA8fUUA9j87mfjGWXoUxiDs4KPDJvyAQ+EHYBz6fH3CVAaHVBRAPJzlSTozecOMdp0a4MijtdF/B54+mIZBKnbKildI5C57M4XxN9Gk9WVFt7/Vv/i/4HM+hs7tdiQAOH6p8mOqFq+KVGfUQu78bdRFbaYdrzqAV7tuS5JsuHRr37yVq7XDSKup1bmGY4+dAHdxVLmW6R4V5nOmvzAPvfTa7x7OHIHrO5JBa/M++oT3s64FEfj/+Q+O+cKWSolHFk3wsnUKhxqRKHR15xqKsJAafk6slHTnKfNsC+9Cq6RZnvARTEzhhaIB+3WJckuXCa6+s6JecS1b+SqaXgLC5JjIbtw0hQ0y3c9O38omNYp9cQR53qWqd/Oc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e09cf755-c054-47cc-c849-08ddf5eb4776
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 13:08:22.3546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hc7X3zLWbOQtyKN5eO8W8fhiWY6IhOkrXkJpjqnab2JEHcl18GzkO6T+XGqHtqrhT8zjlKbQkQ7KyFcmBjW4uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8586
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170128
X-Proofpoint-ORIG-GUID: sz9DHcKigMQiB1kcCsEErnVTTqiXoqxW
X-Proofpoint-GUID: sz9DHcKigMQiB1kcCsEErnVTTqiXoqxW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX20bECgCmikZX
 09Pl+QP2IqGNVM9bo+QIgKCmV6/xIhnwJdkVAJ4OfcbDxyscIfkiwHA9TsAlqQcKv2PXt0Kku97
 c04lr0KxAQU56EBY8olJK7CekYgoMdmHqTvj5GgJWatKOry0vu2nBDjjnIQoRa3nbS2bF+Awapr
 xwa7rtot8BwanmWrr1sKPJ09ou0MmDrIv18/G5jMT0ujYpWXmadVlDVFivbzwnQqzjayR0ozFi2
 /tckIvkIYJCjkV1MlwbYE3UgO8jxMH3AgGUgt0lNjaoKx+ppJiQ9SkDbmR7lTczVVFPTHS830GE
 PpvGf5j6lKbzHtsxB3qb8z0wG0Yk8hy2WrDebN9fz7lZbfQrEAYbAafEXAt/EQd9v6kdwtSHN9j
 TDiO1cJU
X-Authority-Analysis: v=2.4 cv=N/QpF39B c=1 sm=1 tr=0 ts=68cab363 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=ZDIJpXH3xisRzM6o88UA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10


>>>   retry:
>>> -    req = scsi_alloc_request(sdev->request_queue, opf, args- 
>>> >req_flags);
>>> +    req = args->specify_hctx ?
>>
>> Can you check args->hctx_idx is a specific queue or something like 
>> NVME_QID_ANY?
> 
> That would require explicit initialization of the .hctx_idx member by
> all callers that don't care about which hardware queue a command is
> allocated from.

Yeah, doing that is not reliable. You could also add hctx_idx as 
a(nother) new argument to scsi_execute_cmd()

> I think the current approach (only code that cares about
> the hardware queue a command is allocated from has to specify
> information related to the hardware queue) is more user friendly
> because scsi_execute_cmd() callers won't forget by accident to set
> .hctx_idx to e.g. ANY_HCTX.

understood

> 
>>> +        scsi_alloc_request_hctx(sdev->request_queue, opf,
>>> +                    args->req_flags, args->hctx_idx) :
>>
>> did you consider passing this hctx info to scsi_alloc_request() and 
>> allow scsi_alloc_request() contain the logic as to call 
>> blk_mq_alloc_request_hctx() or blk_mq_alloc_request()?
> 
...

> 
>>> @@ -318,8 +321,12 @@ int scsi_execute_cmd(struct scsi_device *sdev, 
>>> const unsigned char *cmd,
>>>               goto out;
>>>       }
>>>       scmd = blk_mq_rq_to_pdu(req);
>>> -    scmd->cmd_len = COMMAND_SIZE(cmd[0]);
>>> -    memcpy(scmd->cmnd, cmd, scmd->cmd_len);
>>
>>
>>> +    if (cmd) {
>>> +        scmd->cmd_len = COMMAND_SIZE(cmd[0]);
>>> +        memcpy(scmd->cmnd, cmd, scmd->cmd_len);
>>> +    }
>>
>> you could just pass a dummy cmd instead of doing this
> 
> Sure, that's possible, but it would make some scsi_execute_cmd() calls 
> really confusing. Making the callers pass a CDB that is never used would
> make the reader of the callers wonder why e.g. a TEST UNIT READY CDB is
> passed to a scsi_execute_cmd() call that submits something that is not a
> SCSI command.

eh, don't we have space for vendor commands which could be used (instead 
of something like TEST UNIT READY)?

> 
>>> +    if (args->init_cmd)
>>> +        args->init_cmd(scmd, args);
>>
>> is it possible to do this in ufshcd_init_cmd_priv? Or too late?
>>
>> We could have a "is reserved command" check there (in 
>> ufshcd_init_cmd_priv), and do whatever processing is needed which is 
>> done in ufshcd_init_dev_cmd
> 
> This is not possible because the 'args' pointer is not passed to
> ufshcd_init_cmd_priv(). See also the conversions of the 'arg' pointer
> into a pointer to the surrounding data structure in the .init_cmd
> functions in patch 29/29. Maybe I should rename .init_cmd into
> .setup_cmd because all functions in the SCSI disk driver that have a
> similar role have "_setup_" in their function name.

I thought that you could pass the data like how I done it in the 
scsi_debug change which I proposed.

> 
>>>       scmd->allowed = ml_retries;
>>>       scmd->flags |= args->scmd_flags;
>>>       req->timeout = timeout;
>>> @@ -353,6 +360,9 @@ int scsi_execute_cmd(struct scsi_device *sdev, 
>>> const unsigned char *cmd,
>>>                        args->sshdr);
>>>       ret = scmd->result;
>>> +    if (ret == 0 && args->copy_result)
>>> +        args->copy_result(scmd, args);
>>
>> can this sort of thing be done in the LLD completion handler?
> Only if the 'args' pointer would be stored in the SCSI command private
> data. Do you perhaps prefer that the 'args' pointer would be stored in
> the SCSI command private data instead of adding a .copy_result function
> call in scsi_execute_cmd()? 

I don't think that passing args around is a good idea. We only have args 
as it minimizes the args to scsi_execute_cmd()

> This approach is more risky because it may
> result in scsi_execute_cmd() callers forgetting to clear the 'args'
> pointer in the SCSI command private data after scsi_execute_cmd() has
> finished.

Is there anywhere else where the result can be stored and passed back?

I know that it is not ideal, but could we use scsi_execute_cmd() @buffer 
arg for both in and out data?

Thanks,
John
