Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC29321F36
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 13:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522986; cv=fail; b=iaSaqO2QQAjLaMr3tz2XlUKYgjKlZSqFGjH44O3sb46v/bkLM/ZvR0jNYQ4pKgHrYwphDozk9huKL82IVSqkRU8eLo7ONOqIunStiVrHt/DFxUO9m/98sJJOhSj0Ezetf8Yg37gRLrtLhEhTr2YZXSb6I1ZyvGT0F53nYBRo7DY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522986; c=relaxed/simple;
	bh=uGwrg9hF/bzTcJum4Uef9JcSbNVIDx6zmziVsNFOXUE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A3PooPJqTSAznzLiIxz0rPnhR1RczCVsxVeEFOIwFuI5cBujzvCm7y7hEociBZz+v4OD+bdNHkbPbDuCbzAdCp7P0ZWWVo9KVzbCDij+0QRPY/PmK8zWB17/h6gdn63V82kT/WhCJWn4Ops9rmmpeb6G015nVG6Yb5E3lS60LDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bt/nXSY5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wqT+bQsL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bt/nXSY5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wqT+bQsL"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57I9esgw016474;
	Mon, 18 Aug 2025 13:16:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fpWPCGS+I/Sh3vLLZ4OfUVd7scSgG7Sai6tuzEZdvFs=; b=
	bt/nXSY592VrLt2kKYcduIGsNGXD60HHtWERlY41SUgOk/hhHEINLV/GNYcry4JB
	w7e98/OivwaH6NKNWYMRybPIoNPEwR6s6PjXAlX8JdJ9z6aiFRSXINYfd79xFOwM
	QL/Elg1yiq+7pF1og0Brps4wMTYDZluW3XiCCIYrpFbK9fgZRGLAjvDhMwxE/K9P
	GlwzdY5Gtl5UFV8deoxxIAE3H1UyxXi8+xtPDcqyEMnoA2rlCTpDZYpqPveNqhQv
	wOWufsjPhIcYn7VrGgCYmwhijpQL3mtKyX+0EbfULEDy1bFrKB1Ui/el5tXjUL24
	3OeXFIc1gIV98MnaXID9ew==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jjhwu103-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 13:16:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57ICdB1d011639;
	Mon, 18 Aug 2025 13:16:12 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010047.outbound.protection.outlook.com [52.101.56.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jge8y9fv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Aug 2025 13:16:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qst5IgO5fZklQdPhk0vwoMToDXGC5MYVFWxfQJr3G53FK0BoqhDhbMPdFDtwD23zmqATX6nzbk9Cp0J9R7DPb1iTvYY03/0f0mYre5a1uxtyo/dE52siW/BlC/n9wqraHIk9S4YuWp+ZcaBtR/gTATjkknpzj/5X7yDd4vXY15lxeW5FRD7TyHMUP58+CAECdvNDkdRCyBcP2TnK1tNjjaMUT+l6jl3OzUiIADHaeKhfGlTXDfll9es4bh+TcesLk+Vz/loPjyFQlxRcqRxiW8TIMuPU+4qyTCMpnlb2gnk/aioRTc2oPIjDpQ//brekNJ8rqg6NpG1VJye0BZC9ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fpWPCGS+I/Sh3vLLZ4OfUVd7scSgG7Sai6tuzEZdvFs=;
 b=j4wohfJfdPGw6rA1P6lOLKbQTiUFbV4BKd34RCANmQxB6NuaPjfDh9aFXX7K3jgLRUHcx2Mkj1b16/nfvRYYYiBCKQ23yib9wDdfuhh0eU4GLTVbs+iQGvmoQRJAZeEdQEsRwkM68U/R8g7c7I1TbvTgAFFvjucvyn3Re49EqYpX18PU9VkxjYBW02pWaS+SUT4vj8ft39WgQnLovybaw02r6c+7fPCjR4Lk7+GETNlit+n/Gy1L/nteQMFaeXPGBxrFS46TN5h+7zIu3Dy6Tk4OyPQhzf/i09eM1QwH/U2aAfemzM5DT5ogeAu56bvzdJB421hbAOQLgjepQ/F6xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fpWPCGS+I/Sh3vLLZ4OfUVd7scSgG7Sai6tuzEZdvFs=;
 b=wqT+bQsLz/h/C3hIONFzpR8epF1oxL48sSpBiggduQocctCIpp9/B88skYdguEcPzPh+eSLZ2gudC5oZda8piAMGIwCCozKZByE5jaSyNdfRwrE6zg4uy6a9nQXA69FwW6oSohZGJTZBiBLA57Oo97w/i8TMplbqMBWa+Qm42+w=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA4PR10MB8711.namprd10.prod.outlook.com (2603:10b6:208:566::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 13:16:10 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.023; Mon, 18 Aug 2025
 13:16:09 +0000
Message-ID: <30b475dc-3287-4bcb-99be-f2b6649217a5@oracle.com>
Date: Mon, 18 Aug 2025 14:16:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/30] scsi: core: Do not allocate a budget token for
 reserved commands
To: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-4-bvanassche@acm.org>
 <f2d65247-ad6b-44ea-a687-808d8c398afc@suse.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <f2d65247-ad6b-44ea-a687-808d8c398afc@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0034.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c7::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA4PR10MB8711:EE_
X-MS-Office365-Filtering-Correlation-Id: b4f438f0-9b47-4738-7517-08ddde5965b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHJNN2ZYQjUrVjBOSWk3cGRweUpYK2NnbFQxdHgzZFpJRXFvYWNxRXNpUFcy?=
 =?utf-8?B?RVZIWlpMY2t5cHEvT2VXZnloUGNZZDhXa1ZtRTlsT0RUckZQcFRlYWhaem1z?=
 =?utf-8?B?UVlxVHpGS0lDemtLaS9KZGxBT1lna0tkdVpKZHNVdFc1WVZ0Sm9uVHd4MDFv?=
 =?utf-8?B?RlRwNjdLdldhY1M0M0F0cVltbFVrSnlFYThWWnpIZ2RPYnFVVHFBWnRUdmh1?=
 =?utf-8?B?MEg4bzJ3ai81emNocDk3cWNQRnZDMlp5Q3ROTkRTekNQdk9lMUNVUldTODMz?=
 =?utf-8?B?SUdDL3V0clVzNmZVOHFkMS9mQUdVNE9oekhvejMrQ0RHcmYxcEpNaTY2dVNJ?=
 =?utf-8?B?T2NncE8ydWpmZnUyT2s3YmIrS2hHQWtLNS8wc2FuYlEwaTJ5ZzlJemxsbWlU?=
 =?utf-8?B?bmNZZmMvY3NRcys1QkJBNEZvMHFHSDBGV2NnQW94OFlyOTBZUnVHMEdPS3Ba?=
 =?utf-8?B?dm1FL3NXVHVLVFMxaE11V1UwZ3VCeDIva05XT1BRZkdmQ2dvaFF6QXBvUEtT?=
 =?utf-8?B?djhUYmpoUDhvbHAwalRoRXZiNnZiSCtOTlpyakRhaVUveEdiVEZzSFAyTVgw?=
 =?utf-8?B?MDBWQzJ3bmxKVmRpQTU2elpzN213V29GdFA4cHJ5SkRiQU1oaW1VYndrV3pK?=
 =?utf-8?B?MG5aZ2FFSGpjUzhMY0dVR1lqR0c3SUxPVXVTUGVnVkVXcjY0SXZqdlV0Qmlo?=
 =?utf-8?B?QnZRL1Rudnl4dkFXNHhYN0ZtdXpRMUVBVnNYWE9lamh1a1Y3UXdMNGh2TDJn?=
 =?utf-8?B?Q0FidU9CdlhKSjYybTlmSmJjMGdRcnN3V2xtVldqU1hNTzJyVDMrQ3NURnNo?=
 =?utf-8?B?WTNMdGYwMlc2QmtiM09DbHd6UHdCNE9RSy9EYzNOWFhONUpOZ0dNRVNhUHE0?=
 =?utf-8?B?TnAvK0dPSzJrZ1BYTXRobnNjYW90VE9tTkRibGJybGQwRDNvVE9VTkNyejV6?=
 =?utf-8?B?VXNPOTFJTDBwdm1LWlRXVUJIeGtRaHNLNGE4UFFGcWpPdi95QW9aYS9Wd2Fh?=
 =?utf-8?B?L1Q5UUo5bW16bzZML3JwNkx3UWRROEp5aHVDSnpaL2Z3dHNJL3E0V3Zabm9V?=
 =?utf-8?B?SVpCQXpQYmdSaDh2eGJ0aHZ4V3ZIdFFHZU5ock5NYUg0REZIUms0dEpRS3k3?=
 =?utf-8?B?OXBEQktwZWxWWER0cUhMNUN0MlZ0ZHBySEhYcG5YMlg1ekVsbm81Tkc5UWFw?=
 =?utf-8?B?RVpWaVMxUm1HNEVoOXJUWWtLMzN1cW9zTldMaHd1VE5CT3FSODZGbW1MSzQx?=
 =?utf-8?B?Z2JDZUk0NGVlWFpxaWs4U1pPUnhSYUxzOFpMQlFzdnJxRS9UM3oxMEdoVUs2?=
 =?utf-8?B?cHpGcmRQR3hkMGViUXVxOW52U3h1R0p4cXgvcU4yazVDeEY1bWVRUUwydC9G?=
 =?utf-8?B?MVBObERHbVZWeUpuUldIQlFYREdIUzlZbWR5ZmY3dkNTQmRheENtbkY1U09z?=
 =?utf-8?B?bkJoc1c1RTA0QkNmM0U0b3lsZDV3UWFvT2k4Y21WVXBETzZmWWE0all4WnJk?=
 =?utf-8?B?RXY4YXQvMTVSRmFFRE1TdkVBZVJkcEtiUzFYclo5a2FlL2NnMjFMODFCbExj?=
 =?utf-8?B?c3pWRlNUMmJvRmF1djJYdXFlUC9VNjZzbzROaVFWaTB1NEVaZFB4RDlYajRr?=
 =?utf-8?B?cmduMURyUHduUi9JaTZqQ0xzaS9lZkt0RE5nZXp2ems1YVNRejJQWHBPaS90?=
 =?utf-8?B?VDNjdUkvTGkzMzRpRmZRcjBtRCsvWnh2SThPRWoydGo2S3VDaHdRWHI3ZDVi?=
 =?utf-8?B?eG45NkxLQkFuSGtBQXpyZ2Y5MXJaaDd2NkRlZG05ajBqZGtxZFRkbU1xcEVH?=
 =?utf-8?B?KzFtTERHbWR3MDlRZkROM1pDV05UZWpublJ5SUNnaDJoUTNDYUI4aEQ4WU9j?=
 =?utf-8?B?N2UrL2dQSmtDMTBBWDRDWlJETUNUUFhHNm1BOXBLWDZ3RjVObVhTdjNwNGpp?=
 =?utf-8?Q?U1pB3v9BqWY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bjE5blVTZEl4MW1FK0ROLzRVV1VQYWpRU3hCQXkya0l6UG4wMW5NdC9JQjhY?=
 =?utf-8?B?ZW54UnFHSW9ZMGN6Tk9uV0pocEJHeU1OZXhwQVNZdWVPTTFyS09ycm1Fa3dr?=
 =?utf-8?B?NUMzRDVSY1FFM2RoQUtaSVdwOHJCQlNLdE5Cc2dMSWZBeTJWRU9YdXpITGxw?=
 =?utf-8?B?cHJLMUl6R3F0YWlQL1gwRjF3bEZhUUEwaFhUdWliR1pGckVEdTFPdVFDSkU2?=
 =?utf-8?B?REhnbnFTUzkzTnd4QktlcDlhRkNsNlFRa3pLanMrbGw4STdxN2wxaXZmM0pI?=
 =?utf-8?B?Y2pncE85K3hQQm5kRWhObHpqanJnWjFwbkplU0JFVkhYeXB1bEQxeHhYSGJ6?=
 =?utf-8?B?VzlwQVo1MkZMQW81T1RPNUI4eVVaU1ZFeWtGcnZuQ3BRRmIycm4vS29XNWVp?=
 =?utf-8?B?ZVpKL0VnZzJ0NlVTQUc0cVQrRkRTNWhXUDA4RkhSMnZDNFlJWWNJNDVqT213?=
 =?utf-8?B?b2hTdW0rbVpSdVRrMjloeG9TdHg3REttVVV0d3VCYzh2MnBoYjJBM1JZazAz?=
 =?utf-8?B?WEhxUHNNa1d1bFJxQ3AwVWhpYTNKL0Y5bEJWT3kyWU9BbHBVY2gwUy9rYUUw?=
 =?utf-8?B?QTEwSTBtbnlsTXU5VmVFVTNKbmpoUmt0ejB1cEVGbUQ2ZEVacXhFUkx2bEhu?=
 =?utf-8?B?bzFTR09URzVVT3V6N0pOTDRhVnFCMk8rM0lIV0hKb3JWQ2toNWxMWlFnWXB3?=
 =?utf-8?B?ckd6VysrQlhxQVRMUjZUZ25BMzZWeXE4cUJmR3FFNTFycHNmZE5Lc3NNcWIy?=
 =?utf-8?B?ekhtOXdMeDI0WXByVVhhY2RINGhkc2tZdnhyamJSajRVdVJhTlVoWXdRNmxR?=
 =?utf-8?B?bVNBWE5zV05KWElsS2ExcGNMTGhmM0RyNWdQbzVVOTlNV3pBNERtQ0JlcjUr?=
 =?utf-8?B?ZUpnZFgxWldIOHkwZllwbGdwZ3F1VEZqbFJQSUZzR2wzVXA2UHZmVDQrVDhw?=
 =?utf-8?B?S0J1bWs1Rm9wa0pIbFplNkMyczlKTjhhZjhHRTk4cndvbXJQbkpRRUZUNXhT?=
 =?utf-8?B?MUdwRlR2Y0h3aWIrQkxESjNGZVZhWCtLRHpGSlROQTZwR01sUG9mWFlNN2l4?=
 =?utf-8?B?M3VTOC9oczBXb0ZoTVJ4NnhIQTFodzVVdEZQOVJzbm5od0FFR3RZRFlwVEd5?=
 =?utf-8?B?Nit4OXowcWVXbGtkS2FUM0lFdlpzY1hzSGdpM0l1cDIxK1V4RmtDWW9GcWtm?=
 =?utf-8?B?ODdQNmpxbDdyMGZEd2xHbVpvT3dGSEdPSkZNQTdUdTBhcGc2VTRLM21BV1NP?=
 =?utf-8?B?NmRsdEdpZCtRUlRUUDRUOGVLTmtja3B5RUg4cGpRRXI1ZmZxa1B5amJtSFJI?=
 =?utf-8?B?dTl1eHRKZGlaNWRkcWtNTVgzbk5pcFZQU3VBdDMwazRSRmRreXlJMDhFYXpO?=
 =?utf-8?B?QVRFRzRsWHB4UWhMMXp4elZjNG03MEVDODN2S2Q1L3FIZnBpZktTY2t2dVZJ?=
 =?utf-8?B?Tm9qWXNTMHdFejVpS1ZIYzlUK3ZsbnRHRXdNTXZnNDVTam1TMmxQVTJ2ZzVG?=
 =?utf-8?B?VmhvNkJPYnhnbVBXYzBJVDdEWjhzN0NDWW5ydGFPWWwvanpzZ09qcmRWRHpZ?=
 =?utf-8?B?U1FVZHlQTG8zRmFpZDlkblVna2pEY2YxWUdYQ0pvejloNC9wNWEzRVpIdm5x?=
 =?utf-8?B?MldWaFB1b0ZNNWxiSzV4c1dDRjZMNFdkQnAwQzgrcWJkMUk2SEp1NUhmRlhG?=
 =?utf-8?B?VFQxUCtNWGhXU1BxaitNemtFWU02R3p4aDNmNXNHTVVRV2IwNUJnN0FCbGpS?=
 =?utf-8?B?bmdoV25XNTg5TE1KZCtaVitucStETFFJa3FwWC9NZHJQd0R0anpYY2h4RzYw?=
 =?utf-8?B?OWpXdFFMT1grUzFQSmtNak1aZGo3VlpCVXdUZE00Wm01UE1YYjVnR1Jpc2Fz?=
 =?utf-8?B?dGE1cWtENm0xVFhWUW5PbmdlOVdMQWhrbXdSSHJoZUpJQ1diWFp5SWRQQnh6?=
 =?utf-8?B?bVp3TmZ6WWJlTjZueVRQMWNwaENudXRtM25aMWQ2S0VOSXhpTWVJOXpZSUcz?=
 =?utf-8?B?b3RiUm9MdEkrU3FSMFgzakVoYVJWWXJ0OHFPSG1sSms1N3dqci9pcElYMFQr?=
 =?utf-8?B?Z3pCNEpUR1JsdDZBNHVzVEpkb054SmF2bzR4Ry9wWU9paHhDT2M2OEJiYUNq?=
 =?utf-8?B?bFNDeTZ5T0g2bTFnTnkweU5aNEtDRWs3VWFTbTBYeVlnYnIvaTJWZllMbnEr?=
 =?utf-8?B?TWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ryQY+Z7P2khzLhu4LqqfLDBZdB5CCqpqospkLOc3zjYP4C2gtkGKC4CqylEn4GQ/5p74kgJAINh+Ub9ZsQnRaK/Jll+IsukiXV2iqCho5Utk7LKcHbp5E4EYC4FXlQcMNrNLp1uiCVrbFb+CLS6WmKa474COsukhdWlQgZJitzVTIwf18SyYhSvbGlQsBViHTASOjVaBfmBtvE08lxdXZ7jXFyPuEHoc+d3IbAmkrSh+D9G9vwCgIRvTGsLkeDsgfZrKIcuJWD3s1BL8OLODx5NY5ckzkerywMdUSDBndb3YY5ICJEVEvpS3YkQSfYTRoRz0iAgO6vwIyQK3wR7EHW4Y+OTxmA07CnpbatTD7Hvx3Q0XvVp3P/PHQ09BWlM9gVb/QV25e4/bhXGZHOy7VrsbV/omYcm4CCYGSsRcRGtZAfcpgscQ6AB2uRg4ZkG0sGyRqV9ulCJ1RVOErjYkFB6KQurg6wQhpvxHF14kDcLsxXGHgwbFjge4nrajkbXOUacJJXK6dlX7QLi4rt61f+4un1u+nhlV2BWk+gp3Vf+EBa3YtE7RLnIBcSdbSZmPnxjxWbi5JbjxfaRQ/DzA9HZM/qMY9z3glOAxkGbD2gQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4f438f0-9b47-4738-7517-08ddde5965b9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 13:16:09.8996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ySlirbAEbUTn6vkczKhUw4jy487vTOH3BPm2fE5HeIIRq33xyh8jG8URQ4KeXAo97r3w031VGY8ujxSRVSldUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508180127
X-Proofpoint-GUID: mcOZaoZQvo1Y26t9KGVuYYrvLRkGz2T0
X-Proofpoint-ORIG-GUID: mcOZaoZQvo1Y26t9KGVuYYrvLRkGz2T0
X-Authority-Analysis: v=2.4 cv=G4wcE8k5 c=1 sm=1 tr=0 ts=68a3279d cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=N54-gffFAAAA:8 a=A5iTGLr83CvmhO8VqmgA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE4MDEyNyBTYWx0ZWRfX9mXbgEBm0yFE
 N0/tkuFfolarf/++5AjI3lfXZ7xyUo6NHPI2KPoxviANm0nwRCLiko40FnmwiEUAmR/UXECsqKL
 mZ4l8LER7BhphCYnhrQOKowQWrmNWmJPBu5/v52BiUHacpm4bQ0hFIAGORMIATkRguY3jctwpeJ
 TdO0d4G6nfYS9yclTWSz3ijxpBmuLfs9Xc21vVK8fKOOQUs4PSmnjDc4zQ5YbdHmuH+pMCPsfoW
 ooUhUBFDvRRAjGVGM+FduBz0hyuVvjmo57WinM/eNBeikND9s1hhvv2Jx5ZNEUqlrMY/ngl4qsG
 8Bwl5X9TM/yO17rim5cQL8V8lPYZyS7po3HkExrfv1c35crdqeyf5m3F90CoiCSCXpbFIIpC2j4
 mxtRNTRQ7iWOziyZN0Gvbe+H6E6bymnbCRM1HHjIsRJNMHSctyZcpK9XNa1A3vx0Lmqz7r3Z

On 18/08/2025 13:23, Hannes Reinecke wrote:
> On 8/11/25 19:34, Bart Van Assche wrote:
>> The SCSI budget mechanism is used to implement the host->cmd_per_lun 
>> limit.
>> This limit does not apply to reserved commands. Hence, do not allocate a
>> budget token for reserved commands.
>>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: John Garry <john.g.garry@oracle.com>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/scsi_lib.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 9c67e04265ce..0112ad3859ff 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, 
>> struct scsi_cmnd *cmd)
>>       if (starget->can_queue > 0)
>>           atomic_dec(&starget->target_busy);
>> -    sbitmap_put(&sdev->budget_map, cmd->budget_token);
>> +    if (cmd->budget_token < INT_MAX)
>> +        sbitmap_put(&sdev->budget_map, cmd->budget_token);
>>       cmd->budget_token = -1;
>>   }
>> @@ -1360,6 +1361,14 @@ static inline int scsi_dev_queue_ready(struct 
>> request_queue *q,
>>   {
>>       int token;
>> +    /*
>> +     * Do not allocate a budget token for reserved SCSI commands. Budget
>> +     * tokens are used to enforce the cmd_per_lun limit. That limit 
>> does not
>> +     * apply to reserved commands.
>> +     */
>> +    if (scsi_device_is_pseudo_dev(sdev))
>> +        return INT_MAX;
>> +
>>       token = sbitmap_get(&sdev->budget_map);
>>       if (token < 0)
>>           return -1;
>> @@ -1749,7 +1758,8 @@ static void scsi_mq_put_budget(struct 
>> request_queue *q, int budget_token)
>>   {
>>       struct scsi_device *sdev = q->queuedata;
>> -    sbitmap_put(&sdev->budget_map, budget_token);
>> +    if (budget_token < INT_MAX)
>> +        sbitmap_put(&sdev->budget_map, budget_token);
>>   }
>>   /*
> 
> Good idea, but we should document that somewhere that 'INT_MAX' now has
> a distinct meaning.

JFYI, when I attempted this previously, I put the check in the blk-mq 
code, like here 
https://lore.kernel.org/linux-scsi/1666693096-180008-2-git-send-email-john.garry@huawei.com/

Not needing budget for reserved tags seems a common blk-mq feature. But 
then only SCSI implements the budget CBs ...

Thanks,
John
