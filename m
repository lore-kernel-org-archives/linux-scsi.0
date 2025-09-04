Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74FA42C1583
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 10:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756980150; cv=fail; b=PV/DOxMHKdO7UbpCxFfLvJiqxXBH8phHHQeqBgvkG1JWVCDq6tU0SkNBCfylDgr3XmaGCK1GNGWje//3Dlui1n+2qtWE1A+S1RlXUDZ++GaZ8CkKlGxZ/xo2t4aM8Uh3eHyiUX50E8omI7ZFNewXw3dsjWdixMhLJtzLehTDT80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756980150; c=relaxed/simple;
	bh=2D0Peo6rC0vQQRFmnMhEq9+rtH1wLWlieu45eM63By0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bwZx1REKKyi3MZ6t0DBOFAql6X2/b63nE/Vg6zHXvAuQUEi7kmI4nVgueRLJuAzy0VQ9vdxOxzUPaEEZKCYlFKs7Yu/clzplsG/NsjlXnwHqEj+US/nR2T0bkaUJCJlrBSAdhhSuvvpXfGOcBuXrYNOGs2FBa7uMrsov/+Dji1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ry/jdu89; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=a9w6VApb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ry/jdu89";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="a9w6VApb"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5849dS4p025720;
	Thu, 4 Sep 2025 10:02:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JMk1Xt00FTx8mes2Cg3+DaQNVvQMT5RruwYBVlhp43Q=; b=
	ry/jdu89Gb3TxGiDTN4DZnv3sGZo1wskj7uvi0tphibYSLZLMg4cJFr8NXIYujDF
	Fcz6ITb6jd85dqwPjiosaT9enopxgYefD9Wl1AiIG09IPwY9aDWbipk9Qdb26cAl
	Cq9GfNMUaJy5tfwzYlsW4EQDa2zBlOu1mbLpRwE9jHGHXH9hbHNWNb3JsH6kX+xy
	4f8sMrMXQwhZX3OQFNsGV65zVwF65t602xsEh75J5S27abl6azahPD2G4RNGgEix
	r+4GBFMrxYszxMV+1jFQsZuKNNU9vCBrKFfpbaIaUXO+OQgc5vgINJFj0ZDfaMVR
	vIdTjnY4kpNNyQ37Q3RWIw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48y8b081qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 10:02:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5847niuV036112;
	Thu, 4 Sep 2025 10:02:21 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbcd9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 10:02:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H+B8ST4s+s5o2Gf3sDW/FmGo16+CteFAIciXapq1GRFlcudf6MS+D1vOt2dlK7E3SrWUSanIcggdlGFita9/i1SQCoXxs7FU1s5eT2CPe0pWK5z9QOY8vX43obGORRBAx7wzy6Qd8+SjxODtdhOa0Kep4Z4dYg0RBZ3KWsp7mnFiL7HhZ691O/ZTSyHuImd6POc+ekTceBhf89b22AGWqW7HoLvGbKlAsJoNGiugqmdl9AtsI/sKgrnZBotScp0bPl2g4HFyqEdta0mAcvYQmQstaam8+yvVan+lT1EjYkYokEnyE7gLtCQ72AXRC/P+lR4ugs7XfyyyJZG0wmnLWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JMk1Xt00FTx8mes2Cg3+DaQNVvQMT5RruwYBVlhp43Q=;
 b=mgl9wcibaI4aSXuBd0XGP1PdBRM5YBlg0XQipuVN4MsOyEZuIl7WjCQ7Yx1gXvshxuujuXugH1i5OsXNMfAePwyj4p/lbF+74jSgqqY3eQz22qBPoftbW6H/L+Ac3ebGp0Qs7aw+87hneqA3MM9XnkgfkLI9f+zgB90fScLSDljUIM8cLThk+x8nv2B09W+1xlBn41TGKk74e65JiiITl1YNJJ6HynMW6ZRURPSIJKD1blmGp/w7qDfqhmvmSLumEfTlVGl1sEhq1FHVKU4LeYhyBGjbW2iGCDfc8LPM6yd7TctpeCXv4kTfJZLmh4SHGz4gAdgoCeD1Mk+XtVyykw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JMk1Xt00FTx8mes2Cg3+DaQNVvQMT5RruwYBVlhp43Q=;
 b=a9w6VApbYmmcTB/V0yaC+fo5xv63e1DtUT/hAsKKEcmi8HU2r6jKKh00YArk4jZZ9RY4Wj30uU7s981K4WwZ5+giWJ4jSPdH4fdznS+FH2++hrvOh0z2Pa7eQMdVpkDQh9GpDxWXLJU6YAeth0iCKhzO4Bq60JWMqhvI4tlCLA0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB5561.namprd10.prod.outlook.com (2603:10b6:510:f0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Thu, 4 Sep
 2025 10:02:18 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 10:02:18 +0000
Message-ID: <85ebf74e-47d6-4208-9d41-61ac818d2115@oracle.com>
Date: Thu, 4 Sep 2025 11:02:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/26] scsi_debug: Set .alloc_pseudo_sdev
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-7-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250827000816.2370150-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0012.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::19) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB5561:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e3e2831-81c9-4a99-c4f6-08ddeb9a21ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z29OVHVCUFlmbzg2Y0FsT2Q3N056TVNwVzRIQzJ4cDNDelVzK1JjdDlGdDZG?=
 =?utf-8?B?UTNwT09WYmpLdGZiUXJnMlZFdWZuTURBcG4wSkpaeTF3MEQwY3VxUUtQSzJG?=
 =?utf-8?B?UUxtUzNCckRiOFphL1lneUwyNy8rakV2U3VGNkxGTzdlZ0xyN3RkcnVrVnlS?=
 =?utf-8?B?ZHVqSGJtYlZuajd3a255ZDhHZnpQK2lMNTI5T0Rhc2JUYTNVR1c1WGo3RjhY?=
 =?utf-8?B?d2ppbzF4QlV1ZmMzQkRmZjZWbTNmRGxUb3d4RlZWWmt1bDJ3Wi9CSVlxV1FY?=
 =?utf-8?B?QVNWbUpzYTNOMHlrd0VOM2hDSzRCSUZqU1p3aWpncjF4Q3JkMU1Ham5Zem9B?=
 =?utf-8?B?VWQzOXpIU3l3Z0M2QjBFaVFZb3ZPLy9WZzJEeis4RWc1OVFvODhKWWlvZEtJ?=
 =?utf-8?B?blZtRHZFTTlTWGtVU3Z2Y0pST3JDNnRnUE1LMW0zRjQvbnFyQiszR0tzTm5j?=
 =?utf-8?B?NDRXNG0wbmpna0dWaEsySGlKc3hLUHV5LzI3QktrY1g4aTNrdnR0bEJOdVE2?=
 =?utf-8?B?aDh2Q0QxNlUvWHVqTWFOL092ZWYwZGhKTWRBSlkrb3ZSck1ia3NsSUF4K3JX?=
 =?utf-8?B?V0psa1RBNVpHV0NRbUlLa09KWUdlYk0vc25keTUvWGMvSzNNSXJRcURvcTZ2?=
 =?utf-8?B?dFBwSS91cWhUem8wQzBlQmwxL0FmUU82dXhDSjRDTnJZSEo1a1VZQWZMMGcr?=
 =?utf-8?B?VVNNMkdPVC9LZWhIcVFNOHArMjQ3TzE3dlhvZUpYVmpjY3ZQMUQ3dGFESUs1?=
 =?utf-8?B?VlVEYjV5bEIvdTRvdVdIR2RBdHNsMjZzWkZhR242TnJVdHc4b25HU0J4SS82?=
 =?utf-8?B?SGdGTEVLL0l0SS93V09NUDNEL1hiT1VlTmNrZkNTdnRtNWJmc2I4a1A5amFj?=
 =?utf-8?B?VTJyNERFN3JjU0djRm1haFNscE5YbVdHOTkwK3dlMXVhVTVXdmZBMlhWSHdQ?=
 =?utf-8?B?WmVtQ3VkNkYzQkRBQnV1Q014Uk1zbGFNQnRwdCt1eURhT2hCYWRVd3IwMnox?=
 =?utf-8?B?d01WUzVLbUxxSUJtdDdLK0YzYWVJOWFJUEowZXBFd2hSQkw4ZE85L3dSYi9S?=
 =?utf-8?B?Tko3YkRYUStlZTB2dTM5THZFZ1ZFdkVxd2NyWUxDRXl4a3ZBbDJtTlJoM01w?=
 =?utf-8?B?ZDFtZHVRUHFXbUZkUWpNZlNkMldTNWd2SVJXemt4aDFtdTVMT09maU5rYVN3?=
 =?utf-8?B?aXdZR1lDQm1QRWV6ZFBCckpsclYvTnRpQm43TC91UGhwSWJlNlN4N29mSUFX?=
 =?utf-8?B?MlhvQm5rZVBFdGZtSWcrZEFkWSsyZ2xMNll0LzI3Q3NjK0trS2IxMWtxdmpI?=
 =?utf-8?B?NXZGbDBXQzN5SDMzRGF0UitheVpWdXZuNXVoUTI2Ri8vbWZpU2FXcmpaU3h2?=
 =?utf-8?B?S0ZWNHpRNEVEcEg2bmRsWGlUYThETXNZSXdEMWlETlg5WXk2bHo5UjhHYUxu?=
 =?utf-8?B?cCt1Qnc4ZnRIVFJiTmlPOWJSSUYvZ1lrVjRtcVMyY0doQ3R2ZXN3MVZlSGVK?=
 =?utf-8?B?QVBSMFNOZ1RDYXNDRkNWNFgvR1JQS3VXQ1BoMmc2dFlORW9KS3dXZWtuYjVP?=
 =?utf-8?B?Z1VDWWV3alA4TUhmdFN4bERhOS9Rd2tQZXVVQ25HT0k0cGFWcThzQXNzREFD?=
 =?utf-8?B?c3Y5dnlZV29BWldvbTdwRTJheldCa2FzcG5lRngwNXNKSnA3MENsMEpoRm5x?=
 =?utf-8?B?Qnk0bUFMakduR213cHlkT2FKWUhZWTlhRlNLRkp0aHNvVDRuNldEQWJsbWg3?=
 =?utf-8?B?bDNVNVZsT1ZMSlFNcFA2TUl3dHdMdWw5L3JESXJNUVFsZS9qNkFGSUdSdDhp?=
 =?utf-8?B?QlFjMFk5cUREaGtsMm14Vys4UmdLeFFtbDdYeWZYNy9lcWw4VU53b29oVGVP?=
 =?utf-8?B?MmRac29mSW1ueE13alkxOXJpWGtBMGVSNGdjSks2M3dFR1NLa1g3eXZYSkpt?=
 =?utf-8?Q?JYSy1oQsFzQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a3J2QUlSa3BmWmpLdGV6MThTSUlpTHJ5L1d5YWZjWTlyWXltNVBvL2pyTGx4?=
 =?utf-8?B?WVowNjdHUlJ4TlZtcVU1Y01hWXppbWhtY0J2ZDRHeTkxeWN1aHZuN0tsZ0Zh?=
 =?utf-8?B?SE5WQ0l6bnUyRjQyTlBWTEUzZlVRMEdKOG96Vml3elpMOFlIdzgrSnVxUzJF?=
 =?utf-8?B?UDN5YUcyT21OSnJRLzN1UVZWWFFyR1V3S2cvUzllYWFPT1JxK0hYNVlweGdM?=
 =?utf-8?B?K1ZoUW1BUENxQU9tdzFmcnU2bnQzSE1rMWR4M1VnR0RZVFpKWGhBSEJneVNi?=
 =?utf-8?B?WEl6NC9ZQnBDdVV0bE04c3RLc3d3Q0gyK2RpdUIxZEV1NW4yRDhUVGlFVEhQ?=
 =?utf-8?B?N0FidTBYeHQ2YkswMWpibjB3ZVVWZy9OYno2WEdPU2Q5Y3hmRXhIZjRRakQ1?=
 =?utf-8?B?dWRTOHErVEJ5VlJlck9XQVlCK2pUQzZoSndVR3dWQkpNMldPelNyQnV6ZWg0?=
 =?utf-8?B?UVRMcEFEblVwUkplQVpBWnkxVlp3NjZ2Mlo2dGdCZHBpM3FjZWxZTkxMbjQ0?=
 =?utf-8?B?cE9YVHVGK2tsZ0FFM1JyNFFkcS80NXhJWWx6dWFOeHRZQStKT0czZVlBR1lO?=
 =?utf-8?B?bzR4VDFYRmVMTnhPN0p2eCtTNm8zbzhLZ0hsS1JnNGJwVzlWdkRxQm56UDBh?=
 =?utf-8?B?UmE5TFhGU2JVaWdxK1ZheU45REN0dW9CK3plS3dvWTBiVTEyR2kwMWplREkz?=
 =?utf-8?B?OGFRNFZCNlFLS1BXdS82ejNEcmpqL2RlRWkyb3NKeUJkZXVCcVN5RERNRG1Z?=
 =?utf-8?B?ZGk5cGlrWlpoMmZMYlpQQ1BYQm1NemNXcFRwclNXU1BFNm1ma1RhbXlkd0dh?=
 =?utf-8?B?bjMybHNTdDJ4bWoxRXp2UGtiNGh3T1JMWTdacDRuZ1U1NktOWkxhVUsvOVR4?=
 =?utf-8?B?SGlXcVpENXBza2JGbnhRRXV1dE9TVU1scjZpRDhoSm5XTis4cHZnQXpGUVVD?=
 =?utf-8?B?Q21qaHM4ZndNSVh6bGdpMWZPK1dzMVJ6d1l6cUNTZTc0cHBJODBGaGRoNHU0?=
 =?utf-8?B?YVBvNmpVQml4SCt3NlhUV0VFdkhKZExYRElIR0NtVFp4U28wN2NHRWl3OWp1?=
 =?utf-8?B?eGhyZDBtRHNTdXZzd0piYzVXNGhmMnVQakhYbzZkejE0RkhXNnRUUEJpMWZo?=
 =?utf-8?B?a3ErMjYyU3R6QnJHVXg3QTR2bENraUorQkkyNWhlYlJHazIxVXlGdzVyZmtm?=
 =?utf-8?B?U3IvWU5LZzMyekVyWWlaK0RHUFBEdGFoaVJWcjZrNEhkbElHSVZGbFFYbXBK?=
 =?utf-8?B?Unp2b2RKZHU2OEJCTisxaTdwazB3aGZzWFFkS2ppK0M0OUJQbGJWbndLOEpy?=
 =?utf-8?B?dCtDTGl0VnVVTVlPMUIrR2FJblVFemRUR1k3cW5JUVhDRHZoaUN2bFA2Qno3?=
 =?utf-8?B?N3FqQTZUZ0NiNEMzbG9PaTNJUFJ5WkZ1Zk1jNGx4eEZOZTRHR2p6ZE5QZmQw?=
 =?utf-8?B?NnZQZEYrNjlIc0JCU205c2Q4VTJ0SHJFMzNHVmhOVnRhd0xvOEk3K1g1d2Zp?=
 =?utf-8?B?R3hla0o2ZFQ1bjNlNjdOYm5odDAreWhtRFNDbXprUFhrbUFSb20rOUpxdHNI?=
 =?utf-8?B?dkhrTmZQMVBlbzFkTTRaeElGS0VWbGRZeS94VUFDdjFxYnQydXl1Sy8xMDdx?=
 =?utf-8?B?ZVF1QUovWVFBK1ZlczdMUi9KeDJvRUFNeEtnZ08rb2t3TXlnMzlKdFExd3dw?=
 =?utf-8?B?NWtIQmJRWmtFWUdmOXg2VEtBRmxFQzhtNEIwT1JPQXJQc0dOMlcxUGVkTGs3?=
 =?utf-8?B?N1lVTFFWYzgrZ2FEekNwRXU5b0JMNnR3NXdZUXlXNzJTSUUvWjVmS2hqTmNZ?=
 =?utf-8?B?V1BTYkVEakJrM3c5cWV1dldnOHVSVTdiRUhjZjF6bjJnazgva1oybkpwQUlT?=
 =?utf-8?B?WFRHbURXcG5ZRjNOSmd3NWFwalpOME91b2czUlF5TVJOLzdDZXl2bW1jZ0RR?=
 =?utf-8?B?cVpkUnZ0TnludVA4eEhOTGIzdVZwdWc2UTVXUklmV3F1aUFwaEZDeG92NFpR?=
 =?utf-8?B?STBKWUdTWnlqaWlxQktDVVk2K1JSTGx3YVlOUE5uOVhTempzRmtRUTFRSlAz?=
 =?utf-8?B?QXd4SG5oQXh4SUVIOEUyMTE5WUdVSXZ2SldqSmV6ZlMySDM3a251eWpxMFhh?=
 =?utf-8?B?U3RVZ3FubEdOeFZaQnozaSt1eDBTK3NNUjYyc1g5cGozT0tEVDhlallqbXRG?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6IZg5kvEVaXgHDFvu5/V9HIr9hX3uSfPdJvvbmRACJXESjD6zTRN3Tv0cKSx437e8fFdAaoQbTQ6o++QCsFhrRWajeBXFI0uRrApAvIJTqYnK2paJXvaOkfv0+kGEb7M5SgLKMYHlu5dqjfpne28J21gbTRZVDCvJnL8+ziYKrqd7JPYD6oa+xITdXNfW7lpcTGKq/6VGoEeceSZVOKVLmkFutmpFU82PoLGXv+zZhxTVO5Td9xhWuk8aYGuphDDYuoKQAb/omNwH6MQ03SmRBsBRmFGQGBZXUWHn7ziQk82ooUyKZaQJ/5YPFVwv7pCGBB4VkjDmGdv2DUcYRaJ3ckWD1qtiW+LVKbh5Z08x5UbARezkr4rck14ir661ok/LD7xPyWWOUpYumK9ns7i0FuJFAfla8/nNA8vym7filtOYBX1947gEPDVZJkJntWq4tWJhSY3m1lpHp9BgLEEQyL8HV72MlaoxaICR+C6t47lw/0dUfLQX1dNyANQnSE8TkjfpRs/bofN1UwzI55MoTi5/FwgLTeIKXkWffjHMM3+Tp2DZS7zjd2AG6DLzYk/GLjOJJa+hvoNaAHWpIKUuKGPqUg7Bgv+dOatvORZIKc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e3e2831-81c9-4a99-c4f6-08ddeb9a21ae
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 10:02:18.0984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfnb1sbIg/CT2aplrLVUdA9rzhy96SmDzZok1jyYpRmovgoZRu26XqJgJk3lK+oCWwxNlFIMRUkhzdxPtfkieA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5561
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040098
X-Authority-Analysis: v=2.4 cv=Yc+95xRf c=1 sm=1 tr=0 ts=68b963ae b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=N54-gffFAAAA:8 a=68KowEBWorXKjN_4ao0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: M76v9WxExa8QW_K4MoTzUo0dMn2OjBYG
X-Proofpoint-ORIG-GUID: M76v9WxExa8QW_K4MoTzUo0dMn2OjBYG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDA5NSBTYWx0ZWRfXzwJTrNVau9wK
 B6+ACg88eKJR8QoXRj7vBCv7s+TDDOPdtDsgF2XtCUb6RjrJ506aq2HIoxHWQHPvh+8UrNdtSWB
 TVUQ9odHkmBWaDx6rW1xuDzMLV7v9AUs8xr/32G9/fNfuo2dZOSfquER+ELuoJSpD53T5uYzg9D
 DzQxJseTr6XSFDpHUB4PS1FDNozeHRLTwsrbuK59N2qsiGoLQ/3nPoyoZ+alGYU4jbmGl2g+CQP
 j023r2o0vLp5DnKL92vC6qn2z7WzxcGmNueO/gbFtNIl+z1jNDT2TGclCjZbTwYo8vWW1Kw3kUe
 PPrerxsgONhOuKIKbnGFoMseA3zADTaAiSN7SZ8N09G4H5f249jjkNiijh/Z1AY1Yw3MTvuubvm
 Mg1Zu0n/

On 27/08/2025 01:06, Bart Van Assche wrote:
> Make sure that the code for allocating a pseudo SCSI device gets triggered
> while running blktests.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_debug.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 90943857243c..83bb84ea2ea4 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -9438,6 +9438,7 @@ static const struct scsi_host_template sdebug_driver_template = {
>   	.module =		THIS_MODULE,
>   	.skip_settle_delay =	1,
>   	.track_queue_depth =	1,
> +	.alloc_pseudo_sdev =	1,

yeah, it's prob right to do this. But - as I mentioned earlier - we may 
not need this member if we can logically derive if we need to create the 
pseudo sdev from other sht/shost members

>   	.cmd_size = sizeof(struct sdebug_scsi_cmd),
>   	.init_cmd_priv = sdebug_init_cmd_priv,
>   	.target_alloc =		sdebug_target_alloc,
> 


for scsi_debug, maybe we can add reserved command handling as part of 
the driver abort handling, e.g. eh_abort_handler -> scsi_debug_abort 
should send a reserved command to "abort" a scmd, and the reserved 
command handler does the same as scsi_debug_abort currently does.

Just an idea. I think that I prototyped this a while ago. I would need 
to dig it up.

Thanks,
John
