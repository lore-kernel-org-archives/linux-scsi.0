Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742952F83AF
	for <linux-scsi@vger.kernel.org>; Mon, 20 Oct 2025 11:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760958686; cv=fail; b=QxqY3cjBgRrw4oOCmUIqb264bQGFxWqBemyvJxoHkmVy5FFxPII/wDQ4XQIOTklyiwjRpoTQIW/dq09l6zdyETA0Wzju0Q8yAm3I/N1DzUWGo47xewmDZj+mq7pHLa/6n/fnwlKMCKtqdIPBj5k4i6+8tC++5WA7zpRCWDqyzyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760958686; c=relaxed/simple;
	bh=DWV+RK3SMTTgvBbgFAJ7MAffo/jRN0Ixk4ojRNjsw+M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g+NppTuZ5WqeoOFLJjD9eraBpEOfmFYkeOmJTugF+UDYI+64V5pBaX36pKgUf/Isbn++NQho99Q6wiWMzKovEx/ybDHZTfHnGGXglgjQ4kMYcBbWgHKFuOA7GrNysTHjGNBYj0r1qBEwF9WbL6tspf3LFwrw2nLEsgcm6T31x2I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SAr0iM+z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wXgejIwh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SAr0iM+z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wXgejIwh"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59K8RmWi025511;
	Mon, 20 Oct 2025 11:11:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2Q1C7mQa1rai4DvbZNv0Ev9++pbJ2ixuzVvJQ80Yydk=; b=
	SAr0iM+z5CnxFMMpL0ojQlWzVrwjUEhnKazQFR/zYOIk1oLsoJOJjMurKTFraRg+
	DLBBXa9XN92lmmyMytj3AnPIGKmnkewlfVOz37Jr4z5aa4Uobkrb7tBBn6vuiPy9
	HSOT31GaNKylQzF2jABQM2qrQEnXOg3xZkuczqRn0PfQgJ4fR9h++6Fq6yd2Mde/
	BLEUGpSjrn5MK0Te3P/K/t+4x2/SC+SV9JLUFHUZdk+J7xEfzhpfWrHrN9TP9b7z
	dYr9a3nOtfzNDc93ZYidNRsR1MG1nab0FzIufg5+eHiP6gAIYIb5Sf7/ZBVZAfxu
	KJlYIQxkzmyapOU4SmhloQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v3esj139-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 11:11:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59KAVFjT034892;
	Mon, 20 Oct 2025 11:11:06 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010051.outbound.protection.outlook.com [52.101.56.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bbkavb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Oct 2025 11:11:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gdyauwYVXj1cMY00GBPxEULZoWlkaRkQk7rYLSxIQToNowk0nnUJNnts80Rg9li4HD0btQpjKLyWQt7Dr6EHYQZ3mKCNc6me7JjmN3z2m8c6k159mDD3yMgCb+6axwc53cZyo4xvUQs1pcYs3z+78FM3d9d2a9qRJh36TWTK/G84xFMlSH1qQEluwhLtEGvmon9qtvGAIZR0pT66yz0j5OLxjaMDbVru/qzX12zVZ3kxVZSYcAt3mP3OTTn/GhSleIHIX5JNrW6J/zItbbMRy88PVKnK44IBNsh/mjUXTzqwNJ+/r/IBKCKSDpDNjpp1N3qYdzmDRloxyFiTSeSrxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Q1C7mQa1rai4DvbZNv0Ev9++pbJ2ixuzVvJQ80Yydk=;
 b=aRYmugOyEUJJpZ5kM0PdDAtkPG+/ov89sUepaFp+f0u+YTofL6oMwkw0ZpsI4OBsHR2b4ajL79W6lco3Ad2sCSt+ZM/ZuS0tpq8cpZ65oWhtW4EtTWfsvNVHuSy9oYIBLu5chQ4/433t6b4LCXIk0iTFvb5hl8z07Ui5H4LgtRQpacMWnlrYJhdCXpKSz4GNQ089IkqrrPRiHJtefMX1hv3boKFT9U6tPJ4+ritnCro66iVsl/oknYlEoPLnZnk1eihVLoFo56NX0+xGmiJO+3aJawQV43AalO9RipcQLIzQX68+Td2e4JJ9n2sfDpud/7h+8HCB/QPe0Y7jLhXshQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q1C7mQa1rai4DvbZNv0Ev9++pbJ2ixuzVvJQ80Yydk=;
 b=wXgejIwhnwKESGB0ml31NEeS78hlP4nbyMQSvdyzNWkvjQMn0Is7TowIZ7pjdEGH+bSkNFAz6cPNkQCV8abGLi9ohgc5/XFiGe4S15CeEAnIh0/Kc75FoLVnxp4gSTK4W38ETQfy3rp9MARPpfX6NAoJPVhoHEdC5qasNcVBWdg=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA0PR10MB7181.namprd10.prod.outlook.com (2603:10b6:208:400::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Mon, 20 Oct
 2025 11:11:02 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9228.016; Mon, 20 Oct 2025
 11:11:02 +0000
Message-ID: <548939fa-90ea-47b5-9f75-3bcee3231e53@oracle.com>
Date: Mon, 20 Oct 2025 12:10:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/28] scsi: core: Support allocating a pseudo SCSI
 device
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014201707.3396650-1-bvanassche@acm.org>
 <20251014201707.3396650-5-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251014201707.3396650-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0121.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b9::19) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA0PR10MB7181:EE_
X-MS-Office365-Filtering-Correlation-Id: 26c337eb-7916-499e-e65b-08de0fc95ac7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NnBOMmk5M1NGd2s1REhOcTF4THM5akNOaXVxNVU5OEpjZjlmRnVLL3djenlN?=
 =?utf-8?B?Nk1JT3JWV2FXTU42Rmg2Unh1Sy9QeG10N1U5ejEzWjFpbS9NSnkxKzRDT1Z5?=
 =?utf-8?B?dkdXZjZ6K3ByUW14TVNoSTl0a2YyTU16RUVMN1VUZUxWREFRb0c2SzJpNmFu?=
 =?utf-8?B?UTdQZmF4M2psWUFSQlNoNkdRVkRuL0ticGY3czJENm1lY0hKY2lVazRnUDlV?=
 =?utf-8?B?YmVlaGxUTjhRM2lyRW1kL0tSMDVRVFN3NjNCRnpCNWQ1QW9QZDV1a2FONVlj?=
 =?utf-8?B?R1lBNDN2TDlpcHBQNzJsdHZGb3pIYVJ1OWNDcnRpY0c0VGNSUnRLejZndnBI?=
 =?utf-8?B?RE9XSHprbU5hb3ZIcUNINVl0SjdKMkFmV0x3U1FSS29ZZDR2K1dJc00zbFVv?=
 =?utf-8?B?ZWZDL1NxeUkycXBRRGJrR1lGSlAzMHBibDJFQnkvdE9GSnZUZ1FFclBiWlBC?=
 =?utf-8?B?VStaQVVYNmhnVjl0aE5rZXdUc2JRMGJjNVNTYUQ5c0I1cVA5VVVZVi9NNmVv?=
 =?utf-8?B?amhNU1U5T3ozbmdLbE5Vbnd4UFFpbk9NYnVXd3F1Rm93Z3NXdVRkTzZUZmtu?=
 =?utf-8?B?MVJoUzVwbE9qbjBSVFFIdGltZFVPdklaWFo0UnpQM1RIZ1JTZTdHejY3aVpP?=
 =?utf-8?B?SkpYSDJ3cmdWckRGMTB6eU15WTRsMnhML00rRmdOWkxwUjlDdWYxTmh3YW5O?=
 =?utf-8?B?TEUyR2I2L0ltaFY2bnpGM2hZYVZNemZmNE82dGtETmJnZGRtVFd2bnFqaStl?=
 =?utf-8?B?WlUwVndSRnhpRFlCVlh2SnE2Q2RBaVlvS0UvUnFoY2FtMGdkVUJ1bUVqdUcw?=
 =?utf-8?B?aEFhMVlJRXZ2aDB4enQ2QU5nTDl1SjNGOEVpT3dZT2ROTUlQbGx3aU82RmRS?=
 =?utf-8?B?Q09uTlZVaTlEeHhIVHdKeHRGRnI0SlpWS3pua0tBMDZmM1ZIYzBHT0V4Zm9I?=
 =?utf-8?B?dStoeTByUmhlMFZHTVdCWnZ4bTlXYzRYRzVoUlBBUSs2ZmNQdDZoM3c0NnZ0?=
 =?utf-8?B?S1JkRWM5aU1ycWg0UFdoMXlDSVo1dzFiK2RMcFBSREIxYnV5NDFJVitkUk10?=
 =?utf-8?B?UzFvTy9JcVZtd2xycXJsZUhRWi84NnNxcEV6WEpSdngvZTZMTXF2ZjhLN1Ri?=
 =?utf-8?B?Rk5BMHgxOVFUNXVRRkZISVJJS1lGQ1QzbnJDcVRycG9XR0ZFYjNmcFcvdzI3?=
 =?utf-8?B?LzNmUE9VNEIwOWtWTUZDQVhhTlhSMTZuL2lCWkhsZ0UxdUtON0hXaGVnY25T?=
 =?utf-8?B?WUVRaWJDTXdLWDViMFdNUFFkVW5ucHJpKzBmNWVvUi9KQ1B6SC9Od0NDeGYw?=
 =?utf-8?B?U1draWRNNDBuZXhGTVdZTUdVVzZVYUdMTmN5Q09FelZ4SC9LVEhueCtTc1NL?=
 =?utf-8?B?djA4ZjlZMURVeUZmdmFKb3U2QU9YYktMejRsRmhpbHdzTm93RVhYN2Vudytn?=
 =?utf-8?B?VGxxcVhlbzhUdmpLS1F6ME54YnkyMTRycmdUM2xNY1ZMTUI1V1FWaUppMWVu?=
 =?utf-8?B?TlNiTU5WeG82TFI2elhySzZMbzdBL25HWTdDeVd1VWM1bDR2RjhwcE1NV1lv?=
 =?utf-8?B?T0hsWkhIaEg0dk9ESmRjSmhzSjZQdzdhelFMYUZubHBCakdzMWNKcWk1eGNL?=
 =?utf-8?B?Si9xYnRwdzJHWkk5eFlxMDY0TXFQSTRZVk5ROEREVjhRdEduZlN0dGppYXA0?=
 =?utf-8?B?K1RhcTZrL1dwQndUdTN1RmhYK2RKYy9LMndIbWdKcysrbEwrcGJ0SExTQlk2?=
 =?utf-8?B?RGNKUHRBVzB5Z2tZVmVLeXdoczNiTUx3NmxxY3c5cUxCN3gxR3NwMENJOVo1?=
 =?utf-8?B?amNEQUE3dHpYVkxhQW1JYzgzOFR6RjIrdmh1U1lLNThON0pUeFdFUlI5R1Fo?=
 =?utf-8?B?czJNZnlsbFhjZUl2cDVSVHpKSCtoQ2U5dHR5NjV1WmEzTVMwMjRNcnB6RXJC?=
 =?utf-8?B?QTF2NFFUemdESEZPQXZsaklBK25FRGhzZEJTUStEUThTRno3Wms1TVRuZFJi?=
 =?utf-8?B?YmFyM1BLVm1BPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmhBK3ZaUElnMHhrUTdpV3c3cHdvNEYzaFB0SXgwZEhsOEhCM1A3Z2VxclNL?=
 =?utf-8?B?eXpObjBvT3R4ejNEaDRJK2tlYXRMNWwxemZMb3NKTXIyZmFoNjZjV2JhM0Q1?=
 =?utf-8?B?K1BYUXNKajBKcnArWXZpTjJIVjY4STdrNFIrSGt0WnRhUC9JZGNQUTkzZFdx?=
 =?utf-8?B?K3hNa0VFdG0zallRVUZLR2ZhRWN5UTFObkh2Z0lNeldXcXJSQ0VBd09oWDE5?=
 =?utf-8?B?eWNaSDhtd0N3bUZBZ0R6ekV4T3F3NWZCRW1pZUoybFAydGRSVWZmSWNUaVJ6?=
 =?utf-8?B?T3pPcW9VNEdqUjBIOStKdHRITzJldDh2MjVFSThCYzRnNE0yU1RtVjRPTEFK?=
 =?utf-8?B?cDZCNXY0VWYrVWJabjFRa3pCSHZ3ZHZTaVpPSldMR2pOdUhhR0drMmdyb3Bj?=
 =?utf-8?B?YSswNE1JSTd3RGlXZWo3WnRUTzFoS2JpYmhxMFk4Unk0T2NjbW1SMnBtYk9Q?=
 =?utf-8?B?cGlQRVlHc2NlZVlMSnBEd3ZnS2NTVXhoU0RxMkZJdHd5VVIwRVZtM1JHNHhF?=
 =?utf-8?B?STQ2STdNR1EweC80S1B1VXJNbDE0L1RZQ1ZXUEZTSkVycjVOSTBwSUZmQXc0?=
 =?utf-8?B?OTIzVE9kYmVkc2ljKzd6UkZzK0U2WU1iVGFpb2xBdXZVSHppcS9DRkovakN3?=
 =?utf-8?B?SnQ1NjdXSjZvY1BzNk8vYjZtcHZWanFhNDlWaXorbUl3b09zK1B0YTBIVjdj?=
 =?utf-8?B?bXpLY3pnVC9DS1B0cldHSnhVVE1RSXowWENTSFpEOUVGWmdOdVdRRkEzbHg0?=
 =?utf-8?B?VFFCQThCbW1yMnhPcE1udm96bk9hQzN6eVJiOFF6MldUT1c3NjVhcFJzcnNL?=
 =?utf-8?B?R3FyeTZkNXdzOVRRNDFQNHpsVks4czFVbnBTbFhJV3d0RUNheWdSM0FJSG5Q?=
 =?utf-8?B?Vjh6UUlHWG00YWFGeERvVlhqL1IvY3JidS9ENE9LQUpnNEQvZlZaak1YZVdE?=
 =?utf-8?B?aHBVSXdoSU1xcWptcXZnVGU1U01BeUgrUzQyZkRSWUI4WVZBMXRiZXk1bmQr?=
 =?utf-8?B?SzYxcFNscnZqUjhaaTB6Q1pjOXR2dlhnVnlxbEJ5em9adTJYMVg3RGhUSUtE?=
 =?utf-8?B?eWVaRFRtT0tQQ3cxcjJrWnV2S0N3MHdNa0EyOEtUUGpOMjFXTnVQN0h3MVN5?=
 =?utf-8?B?ajJldm9sVW9hakFrdmpwUkhrNXAyMkwzOFg4c3lkVGZTcFlpZkMvTFFXU3Uw?=
 =?utf-8?B?dTQ5R0tXaGszNk5uQ2FINVhDQXFTS2ZyeFN4UXR5NXYwU3VxM3dZd1JsMC9m?=
 =?utf-8?B?cklPZXhuM0ZMWWJaRXlNbXRkL0pJVE40bU93bk84bG5jdEh3dmx4dkcxWXRU?=
 =?utf-8?B?YzdJM002WlhRZHRrSUt2VEN3NUcvSkFwZ2M0d2ovckZSZWZRK25YTHRTV0hl?=
 =?utf-8?B?eWQzcFl4SDBmOFVNZjZ5bEVtbjk0bk1OdGIxL0pjZWJRTjM0d0dsUk1zN2Ra?=
 =?utf-8?B?QWt4ZzE4R2oyNE9WRmxzbzdHRmg3NlpQajYzeklUVmFLcDlQdURiOVN1dHZ6?=
 =?utf-8?B?VExmckgrSnUzM1JTazYxVldSNi9UcHRGYnppRHVObW9zcVpNdnpta0hxRFRG?=
 =?utf-8?B?NmRmQ0JKS1VCVjhWL21CZUt3RmZETHNlRGt1ajNhclRNRFZkNTk1eDBCbnov?=
 =?utf-8?B?NUFMa3pVV3NoNjNIQTBjdTVwT2RYZTZSL1czWVVDUytFQUs0V1lCZEFXVExv?=
 =?utf-8?B?NGtldTFvQlo2bmRZd0JJWk85UUZoTmtxNlhCaXFsRVFBTGFHcmcwSnpJNk85?=
 =?utf-8?B?L085eE5MQUIxb0MrR0c1cStTTHc4NVVOTWtRRG53NURmUzF3enE3anhTS2dt?=
 =?utf-8?B?MkhQWklJWUZOeVBseW5BK1RBOEg3YzZ3S3dBbzhsQmNpems2U1NDUVdrT2NY?=
 =?utf-8?B?cjNiVUFSUmlnN2pmd08wbWUybE9kSTNVOFo4QXoydnRIRGs5U0JlZklaQ2JU?=
 =?utf-8?B?dnJWencvb2JmaWdtVWRsR2FjZWZ0dVNXOWtCeHdrZ1p5YXhoOERIUEI1ZnNk?=
 =?utf-8?B?YXhESmFmTUM2NERRS252ZEEyQW9GRlVMaUNPWDM1U0ROb0hHZUVJMFA5QUV3?=
 =?utf-8?B?aHVkSllsUXVtOU81RHJPS1pwVzBubGYxK0gvbGlNaXFSaVJiL1ZSRWlhR2Mr?=
 =?utf-8?B?bVBpMm84NjR1dzNRMVRHS25NbTdROFJ4d29BY0pvN0FoVDlMVy9ESkJuWDdT?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aJQzxt2vI8+E22MmiYZpM71hhLDQMgFswVSSgQdWBPAnDHtOxPywlUwGE3P9TqIWtKKj/uLed34Va0Uqy2vS1Xhkri9lFyuU6Fx8bKr7ynGaDt4zbgIUlU9eti39A5HcCK4EjSVZNgObvZRw6W8HI9NXqy6s3c+ONI3scFJsg8lQnxgqKlkaPCTg3ttycOxT26WZZYL4gxVcxWo6MwwjNMK3W9Apm+QzK+49znF9oKEU6gVE/J3sINDf3LZHw8xyC+9ngQbrd1Ea2WZ1lpyQk6heST/+lNR/F+mgVddDwrvvEfOjBgtHQ5+piPWWIA1KLOoeeNDcU+LODACgicfZdyuUHGfTF9g1yZorUIFBxmpwVESpoj0c36XlCSzYfo4ly/8K1KKBSrTA2s/T6BxSFITFJVotiCTd3eHLXkbI75xO0ou51a5FdRZDXfzySckMlIN/3n14qQ6cuiG7i6T6ttLnaqsaQSKS70y6B2zdCLodPaB5LBU3uD7qD/C9R/trekb9T6UVKFsngS5kYAJvCasltQyn0s1QondlphrqeTjMSBg2so+o6liPWdaaHOUsOXBWvqCLkRGT4q+CfloAwDPW+ALkl8mUN+MNtbdOSFo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c337eb-7916-499e-e65b-08de0fc95ac7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 11:11:02.4503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lCO9HbJLAaoNo8wy2+ZkvCwvykycsjbbs4cYmBsPbySnvLjzaEqHRJOnQjG0V8p6AHwv17Z/dERn0OyN2Cz3yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7181
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510200091
X-Authority-Analysis: v=2.4 cv=N8Mk1m9B c=1 sm=1 tr=0 ts=68f618cc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=eDT6CgwtUIX8YlNg3G8A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: GBt8kQNQgnfuGE3n5Uu-7hBRQXNAmLNI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyNSBTYWx0ZWRfX0RDtvDU0kkPw
 jKYR7eaxNMdkM9vdzq3JmNqzJ1TeDENXDrsufNC3gua7qScItipNG5jaRbObEUwCDbTEYzWQtsa
 k3upBfY63uEWw5BhpsPU8Jffj1WqEdszbiJ5pMp+0u57rsXQmqU6/UKDTlJSWyKBOnO7KvVv9Wv
 wsLPo6h/qTmlW7dm7HRez6jRWaQErR+PkHBs9r2KSATNeZk0w86JLFbElGGvDH2oPY5wI1s0csp
 JfEbeRAKCv6HKvQi8Q7+Q8TC/E92OBLiAjDSdItK1yNbjW5Sc5lQl9cacYmyz35/x26jHubrCoT
 C7G7paS8cUPA7wA0gHdBY+iAjqrPrT9uV4tzpCa5zUEcVIzIwYNEmOxOAGTOyZbYd+lWljvu/Ph
 H+0eVY5h73XV9WCQAXefGDeSvkUF+L096ldP6Ak/QrJG7R6NfCc=
X-Proofpoint-GUID: GBt8kQNQgnfuGE3n5Uu-7hBRQXNAmLNI

On 14/10/2025 21:15, Bart Van Assche wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Allocate a pseudo SCSI device if 'nr_reserved_cmds' has been set. Pseudo
> SCSI devices have the SCSI ID <max_id>:U64_MAX so they won't clash with
> any devices the LLD might create. Pseudo SCSI devices are excluded from
> scanning and will not show up in sysfs. Additionally, pseudo SCSI
> devices are skipped by shost_for_each_device(). This prevents that the
> SCSI error handler tries to submit a reset to a non-existent logical unit.
> 
> Do not allocate a budget map for pseudo SCSI devices since the
> cmd_per_lun limit does not apply to pseudo SCSI devices.
> 
> Do not perform queue depth ramp up / ramp down for pseudo SCSI devices.
> 
> Pseudo SCSI devices will be used to send internal commands to a storage
> device.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> [ bvanassche: edited patch description / renamed host_sdev into
>    pseudo_sdev / unexported scsi_get_host_dev() / modified error path in
>    scsi_get_pseudo_dev() / skip pseudo devices in __scsi_iterate_devices()
>    and also when calling sdev_init(), sdev_configure() and sdev_destroy().
>    See also
>    https://lore.kernel.org/linux-scsi/20211125151048.103910-2-hare@suse.de/ ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Some minor nits below, but feel free to add:

Reviewed-by: John Garry <john.g.garry@oracle.com>

>   	while (list->next != &shost->__devices) {
>   		next = list_entry(list->next, struct scsi_device, siblings);
> -		/* skip devices that we can't get a reference to */
> -		if (!scsi_device_get(next))
> +		/*
> +		 * Skip pseudo devices and also devices for which
> +		 * scsi_device_get() fails.
> +		 */

maybe previously the comment had some value, but now it just tells what 
the code does (and not why)

> +		if (!scsi_device_is_pseudo_dev(next) && !scsi_device_get(next))
>   			break;
>   		next = NULL;
>   		list = list->next;
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 5b2b19f5e8ec..19d244ef1fa8 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -135,6 +135,7 @@ extern int scsi_complete_async_scans(void);
>   extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
>   				   unsigned int, u64, enum scsi_scan_mode);
>   extern void scsi_forget_host(struct Scsi_Host *);
> +struct scsi_device *scsi_get_pseudo_dev(struct Scsi_Host *);
>   
>   /* scsi_sysctl.c */
>   #ifdef CONFIG_SYSCTL
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index de039efef290..5e7ef4655348 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -349,6 +349,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   
>   	scsi_sysfs_device_initialize(sdev);
>   
> +	if (scsi_device_is_pseudo_dev(sdev))
> +		return sdev;
> +
>   	depth = sdev->host->cmd_per_lun ?: 1;
>   
>   	/*
> @@ -1070,6 +1073,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   
>   	sdev->sdev_bflags = *bflags;
>   

...

>   	result = kmalloc(result_len, GFP_KERNEL);
>   	if (!result)
>   		goto out_free_sdev;
> @@ -2084,12 +2096,65 @@ void scsi_forget_host(struct Scsi_Host *shost)
>    restart:
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	list_for_each_entry(sdev, &shost->__devices, siblings) {
> -		if (sdev->sdev_state == SDEV_DEL)
> +		if (scsi_device_is_pseudo_dev(sdev) ||
> +		    sdev->sdev_state == SDEV_DEL)
>   			continue;
>   		spin_unlock_irqrestore(shost->host_lock, flags);
>   		__scsi_remove_device(sdev);
>   		goto restart;
>   	}
>   	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	/*
> +	 * Remove the pseudo device last since it may be needed during removal
> +	 * of other SCSI devices.
> +	 */
> +	if (shost->pseudo_sdev)
> +		__scsi_remove_device(shost->pseudo_sdev);
>   }
>   
> +/**
> + * scsi_get_pseudo_dev() - Attach a pseudo SCSI device to a SCSI host

you could call it scsi_get_pseudo_sdev


