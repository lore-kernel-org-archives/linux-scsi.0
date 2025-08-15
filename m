Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE7331987A
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 08:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755246778; cv=fail; b=iuxrLsimYvzE9ylC6ebj9ktwefrvMAAEWZudEPlH5ayw0MF1XFU1r+WRVsvekrccIRWdcj4IIAiQwgIHMb6IwJkNmhNUpUdrtdGJ9ZwIpE+pYsi+R4rXjZ1YN2GEgf4JvpNF02KQBuYiN1skltoKR0nBnCc2sI1Pk3PELGvoQKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755246778; c=relaxed/simple;
	bh=04UTNo2x7ZclMgzrd8Wsy0pERTj6gDmh2KzNqJiVKeE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lbCXipq4haFkRgjggFUriZ8GDoYYo1g29bOKsvso7tYrwP6jekCH4kmnWmjqKniq2K0PK/CU7t+hHE+OpxZOu3kHbieRtj7K6iA7FN+w6ne2v+KG+YlrYcc7nOqzd/ms8dDxd7951uC99Kr9YcwuufqTpfLFjU8KIbzPoIru4kQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V1r9XX7C; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DBak/bVi; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V1r9XX7C";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DBak/bVi"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57F7qhBo012176;
	Fri, 15 Aug 2025 08:32:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=; b=
	V1r9XX7CnX6MfKKJkWqgyTuevp9/Qqd9QWiK/WYzEBe6JWV1ddKcZKHY8QJ8N8c6
	o8SBd5G0bPqYwKhe00NGkRNqzg/Zl4VnxjIhqlJvrSwKp4kj+VZ0zhEisAk6Th6w
	nW74Emd+2jVOmP7HDh3VgEkgXuCpHgL5XAmRN/CCwAF+oKeIzzoaMc0ZgDvF0dmF
	Mczg4hmueMo0Ohq9lqGRodtr4FcS5lUA9vVttpDEtkTqPVR0MwwTm1Zb7b1eCNOo
	Agz5lqhA8X9RVzuwaYzXoNT1hdyFMoqJhggTFoZvrdAmz8CtyD8QZza8jpzRdt09
	F0cu9xL0SS7fiTwJb5Z3Gg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvx4kkw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 08:32:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F6XMjV030104;
	Fri, 15 Aug 2025 08:32:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdrxth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 08:32:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uklACr0HZMuSjsGJH0BToi/IzMlMkOaOEDE2TH05rOOPR9yrqX3al5lwVqMTZ+YQgZuvqH2sxqRMvN2Y4/UN/4lyHoZhBYlj+VU/9okrU2FysA9/GE7TFnleZ9wtBPrxvEFFINvvBLH9SMzPImTHt6ngExiUyioV6eDCAVayOvQ5TFfoVvdxuVU1fZVZrLZ1hO38EYmDQ+82JKtig4oZuzvIEsydoMwcMJh/gnqYCPYJFKR5fFeVLmEUD9yCKg9DpdE+SPwmDklwWLuXKAKx9GYKVnPcgCcEiK94yf/oADh5uk5YJ1AhjsW4uFYgkDfqUg1vOuLZMeqniie2QmAlDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=;
 b=eBrsEHKOCGW0AoE1OAh7BtFIHSS0dPFUiuz4evReLUT7X67hlarMn63E/0HO2Ch7BHURWtBdsSlfSjrIelJ2/CMQMDEkp/9jxZVW1D/FyL5NemSdY1jHhIcNuJ7d0Ng/mGh5ute05hNmJAhzjcXOJBxGE/hRnHBuRBQb+Ecq20BpO7d63hqO1VUgH5GU/Lo7MopLgeCrYuiqA+SQ9pNQXdlbZU5y2Mxqt58ooMHbqoTCM8RqzIJtkZJmrHMJsOBvvCKmBbMCUyzwi75Hp4yWpnwbRy14dinJXHoWqz00tOe0hFA60wUTz/m8rto5bs25fEFbbSYB9siqp4XIKYQ+XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=;
 b=DBak/bVilNGNiWwmwrfRlalQRa4XzmiaRdoTw/GomU+5yE7ov/OA5iccqvoCmmDci1LMwxTWQps5VIPKs9Fe7Z1yxQhTEhx+ew9/rF5dPjQK2y7RVPJdPnRBYlP9F+Y5AASwHINt6PxbrwidOcUaH89nKilzx3ETCtbkbKCS0H0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM6PR10MB4330.namprd10.prod.outlook.com (2603:10b6:5:21f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Fri, 15 Aug
 2025 08:32:43 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 08:32:43 +0000
Message-ID: <2406824c-ccd3-47f9-8c3a-a36d1512be76@oracle.com>
Date: Fri, 15 Aug 2025 09:32:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] scsi: hisi_sas: Use dev_parent_is_expander()
 helper
To: Niklas Cassel <cassel@kernel.org>, Yihang Li <liyihang9@h-partners.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-16-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250814173215.1765055-16-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0049.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM6PR10MB4330:EE_
X-MS-Office365-Filtering-Correlation-Id: d34f8700-8275-4f55-94a9-08dddbd64d57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L1hvRUdIUVBsa1U0NDZWWUxyMzlub2NPWDl0SmNsM2E5TDd6QWdTNG10YjJT?=
 =?utf-8?B?Zmh4aTRVeGtPVlJiRTlDMUV2akk2VFFiVlh6UWc2emtVWVA4VmxTNnFydW5X?=
 =?utf-8?B?ZnE5cHpMSFRuN09tYmFvZnpQeW4vYzBJMUhna0tIVzNaaERUWkxpaCtSSFBN?=
 =?utf-8?B?RTdBUXpZR05iOHJvRXdBdHNScG5jOU1yaVJuanlHS2c5T2dENHRpSzFnbHBT?=
 =?utf-8?B?dzBRNURhU0tlN2NKMFVVcHU0OEhVeXNLUzF6Zko5UXhyc1B3U2hVWWo2VUx0?=
 =?utf-8?B?RFFKQ2I3ZnhlQ1ZFdk9HQVBCVUs1R2t6eHNPWlpNeE1WZmxtMzVheUdnaGRQ?=
 =?utf-8?B?VVRNM2dkejc0MnJhOEEyVDJ3N0pjSnhoN1MrcVpNWkxrdlE2OU9YVjNSejFM?=
 =?utf-8?B?aGNtaXlma0MvUDBkblhjUlhwTE5nNWVqdldZb21wVksrMFYvd0VkaEc4SVR1?=
 =?utf-8?B?MlZrUWJGYmNSdVVvVzBkblZKNG5mMGNUSEFpNWZ4MU1TSjJJWlJhRTFBK0xY?=
 =?utf-8?B?Z0xreTBoYzhCOVEwNk5VRmlDVWIzMHRPWjVIYWRNaTVTOFN4WG5aYU5UYkxi?=
 =?utf-8?B?N29yblgrYjlIK25Rcldmamw1bUlYcXBPQU9RSmJQcm1ZS29BbEFYRjVFcW5y?=
 =?utf-8?B?R042R1AwanA2cUMxblZkRUNYNFdlNDdNa0t2eHh0UWZKUXgxVllRMDJldnps?=
 =?utf-8?B?dkorQXhnVUxJSnU5RmxadUsycTFXRHF3elk3b3N5YW1NNmJuQldzQnFKNVFz?=
 =?utf-8?B?OWQ2dDMvVE1HM2JDb0pHMzJZRjU2OG5oMzYyVmprZ3VjZkpBMk1lSEJ5cUQz?=
 =?utf-8?B?OVgwRTZ2ZjhmRVdKc0hHUHVEbUVnVGtjU1J5aGozUDU1Z3dyYklsQnozdUpJ?=
 =?utf-8?B?OWFPYkhVNUQxY1g4emlhU2hYQU1ZYnA0Nko1WlJsZXY4b2NLbngyUjNGa3Jx?=
 =?utf-8?B?RDNmNUlmZlpBdVBrdTY0bEpJcEtjSU9sQ3g5V1luT0JHdXVHc2pYdjZpeE40?=
 =?utf-8?B?b09uSy8zV09KbjMzMlhhT252a3RFWVg1V0hOUENSQVVhUnRQcHN5VmUxK1Fh?=
 =?utf-8?B?Q3VmZ09FQzUxdzN5Vk5OVlErY2tUQVFlSWJBUUdHb3IrWThkdWxsdko2OTND?=
 =?utf-8?B?cVV3U3NJY3dlUE41VkZ2RjRPaGJnUjlialgzTXRJNWc1Q25KTVBjRXJ5SFFa?=
 =?utf-8?B?a0VoNHVHMWY5T0dPWllQR0MrUGZmYXFuTUJ4NTIyQk02MEFjbEpZdGZhcU9n?=
 =?utf-8?B?MlJhWWVZSnVheCtHc1U0K3FvVjdwUi9FYkE1QVcvalNaajJDTGhFRUpMdXZn?=
 =?utf-8?B?Si9URTFFeUZabGtKMXpwamNoQVM1TjJ1eFFMZ2ZaaVVnWTZyaHd6bnJPRGQw?=
 =?utf-8?B?VzhrRGRDRERCY3J1MFlBVFBQMkhKVGU4ZHYwSjA0YVpiVGhHQ3dDT3ovTFpJ?=
 =?utf-8?B?OWtSWDhUdXVIR1FmNEdyT1JxcEhIWmFGYnBsYXVGYTlnUXAxSlpYTkp5VzFs?=
 =?utf-8?B?RHNxdS9hVWF1RlhFSi8xR3FxMlhUNVdEd0xUUGVoNXRPQ21xOWFKTkFVVUkx?=
 =?utf-8?B?aEFQNU9ZRFdEeTh6Qys5VGJNSWJjekFqbS9UOU5DdnN1M2ZSSmU2cGtMSlAy?=
 =?utf-8?B?ZndxejFwTGVJZHVucmxwQ2FRZTZlSEQwUWRkQktGTERlTWlna0pEelE3Z2dl?=
 =?utf-8?B?WlA2eHIvekVFYkpmZHlERGM2NExPTC9WempIVnFWNGtqeUJ5U1JKOC81ME55?=
 =?utf-8?B?N2F2T2hPZVhGYldsWWlqRWZ2dnh3Q3VmWTNRd0M3U1Z6SUpCYnBSdlhSbGpT?=
 =?utf-8?B?K3E2TWtxWHp2alVRVUwvUU5VYlRYV2hKT0g5aVFFVlRrelE0RkFvL091TEhQ?=
 =?utf-8?B?VVM4K0lFL3hSUlhnTHAyckJZMm1POXVrWlFwdmdrd2lhNUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QktTTFZ1V0xUNDhIUWtLOExvdnRucE94cjltUDN5SDFrOU54SjY4VXU1NFE2?=
 =?utf-8?B?eGYxTGUyTmR0R3VxRVdRenhHb3JRejJEczJidkFQVHQxNWI2UkQ4WFpEc3cv?=
 =?utf-8?B?M0ZmM3UvMllNbnE1S1ZXeVgyVTZSSDlSdG5pbWRER3lUYUV3QjI1eUVvTGFH?=
 =?utf-8?B?MnpvZEpPTVpSZ0JCUmExcHE3TlNTUitodEpoZ2JJODZoQ1k4NDhBbzlxbzM2?=
 =?utf-8?B?ZEQ3Nm9mUGZSa3lkVWxyRUl3b05vMm05cWsxTUQ5bTR1R0pCdG05WTZ5NlIr?=
 =?utf-8?B?d3lJMXRsL3JJeHk2TTZzcXhMMHNNQ3FDVzNqQ2EzQ2xkby93Z3lLTXM4RFNk?=
 =?utf-8?B?ZDd2cnJaUWFwN290djh3cHcvenpLZmIrWHNlWWVJS1Nyc1pDOWJJK3dSTS9R?=
 =?utf-8?B?MDI4N3hKQXJ1ckxrNUpaZTlMbjhSeVFNdHJId1NqaG9QZGdUNStjTTc1Zy9s?=
 =?utf-8?B?T1hpbTZZcXNPUkQySjJOdG1iMkErbC82dEE4ekI3MVZvM3dSYWxCYzdUM1NY?=
 =?utf-8?B?K2dFT0J1UWdrQXdrOVRNdjN5SjZQdHBjak1CckU1ZzFIUjZhUmRpUkhUd1Jx?=
 =?utf-8?B?cWJLVDd3Wk5PdllMNThPR2h0QWZCOHNKanBaeU1hb3FSOTVsbGRudmxRMUJR?=
 =?utf-8?B?TzhsVVM0NTFIZGZtRHNCV0hkcUdLeGExdXhORjBOS3lxZ3krc044RHYwd01x?=
 =?utf-8?B?WlJRK1ZkMDhydm9hclNnQnhraUsxd1hDODZkajdmTmVzVWg4MCtYTTExUy95?=
 =?utf-8?B?RHJzYW5mS211bThPQjNmamZQV0EvbzhLWWQyY1RENGtMVUpGUzRUelJ5L0NC?=
 =?utf-8?B?R01Ybm9Ob3htanIrVm95MTBJRzV4ZDd1dnZDL1JmM0dYVFMyVXNFaUdRR0t1?=
 =?utf-8?B?M2dYazdPUnhXM0FCMGdydG1lTnUySGR5amFrV1hLWDVTN0trdlYwVFJ1aGxB?=
 =?utf-8?B?WnJTam4yQmZVSllyVFZyZ0o1dUg0M3ZQeUttdHBQa2pISnBYQUwvaGQ5TFBq?=
 =?utf-8?B?cWY1TFcyWHF4bzY3R3FLQTl1b081b0pjODBSYnQwOWphbjdsczEwZjhVQVZO?=
 =?utf-8?B?cjZYVkpFWDBSM3djY25VTlZBOVkvTEIyY2JTd0dyT3c5SXU4dVB3bXMvdmtD?=
 =?utf-8?B?ZWxkZXVEZTNObG85emdKMXFuUFZoZm9uSnVZcjR4cTJxdFo5U3ZkcnNGT2t6?=
 =?utf-8?B?YURRRklFYVpPUTY2U0ZCRWNkakZsc3E3YnpYeGt1SnlVc3dyRFN0WHBKYXln?=
 =?utf-8?B?RnlnWUI5RFJmSXdqaUNMTkdHRUw3aU9HeHpuT2ovRDBJMDVzQldxRUZYeklG?=
 =?utf-8?B?djlYUzdFWjRiUWFmamYvd3psRGJNVmtqMG04U3Zhd2FMSWJJMExsV2tLc1A3?=
 =?utf-8?B?T0QwTHp1YitCbkg0RERUN1pVaG1ta0hLK0hrZi9nVHJTVkwzcHdLL296RHFK?=
 =?utf-8?B?WnB2YUZnRDZ0ZlNITXN1YWNOY0VqdWFVNkx0YnVtbTJ5ZzUrOTZpZmUySXQ3?=
 =?utf-8?B?VFh6NmRqN1B6NnhXQlVXZE5yYlliazlNR01tRTF6b0pSZW9ITTU1OEJXQ2Z4?=
 =?utf-8?B?NmNtNStZUU5MNWVYRlhydUVZY1U3SHY2NGc2aCtob3U3YTRHYm9LdkdmRWxK?=
 =?utf-8?B?N2ZzQjhWWTlhZHpwS3FnaTErVDJWWDJkVlJkbkljTFRnT1A2cVJyK0VvcmY4?=
 =?utf-8?B?WmU2YjMxRWFtNUVrYVpEYzB1dXdiNGRjTHRDcUNqaDhsQnI0OTUwcHowV2VJ?=
 =?utf-8?B?bG1RWmZhVDF1N3ozd01RNUxLbitaTDNvYllTVHZ0ejhHSllMRENjS0t0WjZ3?=
 =?utf-8?B?allFamh3bkpoWUJSWVU1QWdlZHFrR0RJTXBPTzQxeU9JZkNWR0diSCtBNWlk?=
 =?utf-8?B?WnRHak8zRDU0Nk8zSUtPZjFQVVNMcFZWd1VDaHhpZWxSRHdPZ3JUc3pSYmRn?=
 =?utf-8?B?MXo5MEdUVjhRMm15Sk1rOHI3ZXl5ZGZVT3JubzJGdWdXQUEwUU55dVRqVUpF?=
 =?utf-8?B?ZlNGR3d6bTYxQ1FwWlpYNGhlNlh5NExWN3B4RGRkc1MwUzlCcWp3ZnRsWjJk?=
 =?utf-8?B?bGVKbTFZb0MyQUw0UHJXWTlMVkFHWlRFUHA2all4Y2w1dm9jRGZoZWIySU45?=
 =?utf-8?B?eFhkWVlyWE80OFNBUTlpYjUyNTQ1MkZiUkpJbXlNUms3SUZSTXFBTXlFTndW?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tn7y9DifgUCfxJ6hCf49VKZjvOtB+KrQ9UTYkHRCgf6wmvto4fbZbeE+opuJ2huKrH8wx5dxWbpR5tjD4R7ub/T/gMXQiZmdwyxElRC3V61MYxOxB36yYeWHVSI26X9dyUp6LFKbB8/WwmLcXnDopzaDoiHYVb5LIFUymQ+XRPYu7QloLSw9tsZ7hbXs+Oqtgapf/30ooURMwYQlBzvAPYifXWPR9S7y9ahSYyvkXPgzpCnMzX8SSA+35Q/f8BbF5ixKN6qECl4auWgYuZOUJ9PJE86hVHkPjn0xZfA7aubn8l8IrLw8Qr5BNOF6ljaf5Pr6eVJ5wp+EfiJadI6pNrVvpPT03ph/MG8dDOBJ9TG7IOYdiPnG3zc5Hcgy9S5CBBb6qfnLjbvgY9U09HE96RzZvAhfqaWfF9eouzfwEgNgTC4iiNlT1lp/tsLXhO6fKpN14jpc5v7oui9fDs3W4N5e8EKJ39djggWOrOMJfRzTivoX786rWHRn7UJpga35bVPQLBd/SCvhphJrprYnQKu2BWkO7llXAsLvclqmrbGHXWxJLIy7RxBybSqeYHgFEc1ZcpWkDYAHOKBVJuLAPI7vUs1S0Tr3ReOu+ZUAmQw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d34f8700-8275-4f55-94a9-08dddbd64d57
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 08:32:42.9602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NuMQvJ83SL1s07bthut7bto8RETSOeMiJ0SnDx7jW8xT4nWN+/YRz6bcEgkSN80QJX/Co4xPVBOaPGLruU9i6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4330
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508150067
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA2NyBTYWx0ZWRfXwfh5mqLBqUEm
 iRempWvfMm8bK1/lZEg82Kg6+GeLDCHQZ5WuinRF2m8iq8jmD8otB5a+/Z9dBeRBFe7JIkwrHHv
 vXiB65DRjbB5lp6FcsQXQZktGljiN9LpbV1REIen9I9kT+lMjSHbN2NfDR4gq0gBOqtdhS8sWiA
 LIa31Kq7F0pgmrCpPrGfiISFI37yz6/UfxquAz/AjVg5JtirWZs8CK4JKggG/sfLvLOUNhpmCrx
 mjgdWj2KxXsa5plmdcPdLQxF9I0SFOO+3X/2tqUintmzrhdV6N4e8BzVoEy0Df56ZyOEoA9kwB4
 1u9xTHKrjOcvb7VhsnGgl2ZXXeIb1eV9Vh3LgUmSJ2ePkjNxWgikc26jqkkqlHj0RpLiOadHFZ7
 Km2M+YNDndvN+oJ/7vLQ7K6/g/LFivxGSmxPmcZyNtl2bn212qf3L9qUq8w525a3Vm/2oL/h
X-Authority-Analysis: v=2.4 cv=eIsTjGp1 c=1 sm=1 tr=0 ts=689ef0ae cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=AacqcoUYExIgVmBA-oYA:9 a=QEXdDO2ut3YA:10 a=qVVAQA5K0MwA:10
X-Proofpoint-GUID: znmupiTcDO-Uu__IjyN2aaIyqaposlmo
X-Proofpoint-ORIG-GUID: znmupiTcDO-Uu__IjyN2aaIyqaposlmo

On 14/08/2025 18:32, Niklas Cassel wrote:
> Make use of the dev_parent_is_expander() helper.
> 
> Signed-off-by: Niklas Cassel<cassel@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
