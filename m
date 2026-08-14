Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EB43CC7CE
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 14:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786719393; cv=fail; b=X59gZPwDflWdUKK40ywr5teaERKodcNTkyqtONuqgnUQmoaZzVKAFOyWrOIjkEyj9kSzhVHEy5cc0ve5LyO2NHo17lST9o0RG59NPwe6prv4R/+tz+RYmCGCoh3k6G6vAIGKgseu7XL7nAirLHxinuoBlOeL+yrPjDimJm2KfOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786719393; c=relaxed/simple;
	bh=ebxeRmRdckcngunNnyb0Tj+bV03HxRJuBkqigd3d734=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VEMaeDCS4DR31Pz66SI6xFR3DXPr0ysNabAU40Bf4MGmrbuI9eCmVnweOBZ3RdWB3tEBJfVP2KdbhV+8b0DALlremOP8xB6evcSL0eU4pIMUSZPjCirnmxknJQVVXGEs9zoi0wLqih4UREUWLhqBTaoA+j1ApOtaUk5eerffBBo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hNZVCwNV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kRtjGLii; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hNZVCwNV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kRtjGLii"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EDOx331742229;
	Fri, 14 Aug 2026 14:56:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oX1nlhWCMg0wfA/8wGfH15deIA1weoM8v97fMwpEU88=; b=
	hNZVCwNV/+FMrrceDikS3kSAicKK6cI2wtN5T1Z5zRextPR30vh6wPJEj1QfcKIR
	5Mhf0tRg3gzETYKryTLqqxzPbiBHF03CM/17kqpuToXiQyE2o91xaiNS/6yhx16E
	lhCCp4yXx8dtyk6RQ+CWFS409J+Qsj8HpOc2QRkin1vbk7ZwHTqQlHCFmz3yoAlg
	RelMjV2kFzGh6RfWpR5sFUvDCQT7IjS/B5AMr6Akvz9IC6ZsC1AFANs+fxcGaTbt
	xQMQ35uMMI/w6Nw5voM7M7jr8YxAWxOLT25VJ1tzLd2MDM2XZlQWNJVsT/r63i1k
	pxfesbQHF+n0QQz6DDiRVg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvh2mawv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 14:56:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67EEodwW010337;
	Fri, 14 Aug 2026 14:56:08 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011024.outbound.protection.outlook.com [40.107.208.24])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwhqcbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 14 Aug 2026 14:56:08 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HXjGE+Xt2xBv6NITose9Sd15G6hKO+AZ3TP+kWmWLJ2CO2VHUHCUTBWvpES+qyhj+1Bn1cqJPklbUlR08kwwX8aEIwgNCAsgXgtKbOSlrUVJt9abi8lEL7h0tdiIPJQC88NE6PzJX8GVVRVDOqPLvQSrBbwcc1YGg5CdXmXI+XgGyB+9e5pYtyLohNhACB76wscIgzP8rjcyE1oLoQ8YRs6t3WxUeAUrDe9ZN+DRkCfiUepeEoLaqCm8I84G2O7EEKe3uw5oePJ9bRz4Y8BHSyWBL3vVCyaVMJfhah099hSWj5FlaMKj9X+FvL/SgvCGEk5XGt5tW6Lq8ywPhUQ+MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oX1nlhWCMg0wfA/8wGfH15deIA1weoM8v97fMwpEU88=;
 b=DR89YudNf98tMpq/3kkbaHOYetzLBaNQ+NIZbYr4mCmKIw4mEwBO7eI/gTC3sF51wh0DXfdEZc9+F1VouA7mg2xA4F4nRIOF7LYOyLgPj5Nhymgf2wwPFjndrrsSdIt3vAkiR55ME62R+1PVF31TvPN5SR1V1JZqdFPCjEq/r92b2jsCC2iQcG9nBJsHCi4UNuzErtT+9tOiBTXWZ6FTYEDWYx5z9cMMBWrqWjvzHvW/VFydLkTBZrMqRXJFPq1ViyXV4p0fhxUVgCywuUI7QIVJJftbYC2I4hCC2bactHe9+X55QGxagBkWvdJjrv5PUFnZa7ZvxJocqBF4jqKZqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oX1nlhWCMg0wfA/8wGfH15deIA1weoM8v97fMwpEU88=;
 b=kRtjGLiiWH100B6+a+c7suv17h+O8x4+X0uUgHDN3kl7iGU2v8zRLEWhK07RAg0UYsd1FLg3SUG5Yy5a0WcpP8x9fWosFj+wRtbZFXq/+bGr/j86c30B9l3xfAhQ78+rmcSnTPTvFfEz5zWd0k9X3kYY9chFZrdvXNFg40RfDmI=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB7783.namprd10.prod.outlook.com (2603:10b6:510:2ff::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.15; Fri, 14 Aug 2026 14:56:01 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0315.012; Fri, 14 Aug 2026
 14:56:00 +0000
Message-ID: <cb699d91-0ca7-40a9-bdcf-ee2c00a22aa6@oracle.com>
Date: Fri, 14 Aug 2026 15:55:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] scsi: core: Enable context analysis
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <cover.1786142946.git.bvanassche@acm.org>
 <2576d2f7e3530b721b5050ac6d25c413037d7e7e.1786142946.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <2576d2f7e3530b721b5050ac6d25c413037d7e7e.1786142946.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0144.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::17) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 75e658e6-bd8d-4e0d-5050-08defa142768
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|22082099003|18002099003|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	iZqbIsan5gPIA03Pd0h3QnjX3jKrV0zd+T+6pZNKlbDRTYgApKl0qZGErG/FybwM90C1prU2tl219cd4rToKJ31q6hpJ623NJi6MEqCtd21KBnxLdoGgP4d/4BfhfLwQmcP2+TIxR3FNcNZcsZxGNXb/Kd8XGLI0hBfQsizw6nBgwbhtAyjSf+BcOgpTX8FyHodzW9wCOOKMePQBKClIGJ6GCmcYXo7DUT8/UpoKXmkUd4z5//h43U2X8L4W4i33bAkeV7aSuNusxSRmvsbO0LFsJkJHeCIAbO8jxTKwOEZfeoz7WuiaCdn+uUjDpwSKhSdMbqb5LRslzyG1GulB3+XbzUgRu5egnL8CqdW7KSmEgaobm3pQLm99P76aaXxX1CnlHxL0QIyM5K1ne4Nv2aDaTcSyAFjQWFeGBT2clJS8ug+9ooKd+kAuETEbptbatAs6V9iNMhPSFWvLqOxvx/LOYCKOnpTLNM9TmQ9T3c3CJdYcrh1lgxzmAYjWHmSoY5quriwHQ7j8116vsQw+yUhZ9K6BMC5rEfgRJMx5lNbqYtr4sh8rBRKFXbyEywzeCmEzGvNQKfHqcjXoThbmZX/tNEjrmE48R88FKLZhqtT0rl7a4vQUzgxDBm+Q4yaQrRATcO2Z9/wTXesGxcsuHQ86uXFADCvMRrda45YUfIM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(22082099003)(18002099003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c282eXFIVGtSd2xhRVlLSGRiZ2JFektTcUpXR3M1Q0xMQkpyWngwTCs3K0tx?=
 =?utf-8?B?bi8ySjVNNkdJbE1KbjhuRzR6RmxPR0YwRG5zZ1p6Rmo0ci9adVdKaStBNUJQ?=
 =?utf-8?B?ODNnTHRmWTI5bU5BaDZNUjlGTzFXVFVRdGxGWEVjcGE3T2N4eFlaNE1COUlo?=
 =?utf-8?B?c09EKy9MM3Y2NmQ1UW1iaXFRS1NKY2hLV0x2WGpIN253WFJvTFJCT2xGQldG?=
 =?utf-8?B?UWNjU2lEaFBkWDNEaU9KQjdMNXg4aEsvNDRrSC8weEUxV3VBUFowSERqOFV0?=
 =?utf-8?B?M2ZBK09MTXRobXkwQkpwaDBWemtjV0VDZEdTdURNTlVWNkw2bXJ2bDhTTjRM?=
 =?utf-8?B?Sjl0Ni9EQWRSb0hEU2FsMjZDYUo2a3h4TkVXYVBQeXZ0NjBuVFFzSURBcDFr?=
 =?utf-8?B?UkVCQ0hySTM5c0taS0FkZktzT3oybTRDa3BwMndaYmQ2L3hiUnJVR2w4NllL?=
 =?utf-8?B?SGVMV2NLaVNKS3VTT2RZdkV4ZWdKdnZwQWtIZzVicTJZbmtjb3Zab3NLMGhj?=
 =?utf-8?B?ejZmL2Jua0pZYnJOR2gvYS9zd296b1BCZXNGc3grUlBQOXpMV1d0a3NnaUNL?=
 =?utf-8?B?UVpaeFZoMkk0cWlJMU1YVGpwQlBsMEUzSnoxazZaU0RHMHlJSXY4Unk2eHdh?=
 =?utf-8?B?L0pQem9adjdESURDSTdaajV4NkNCQlNIdzU4VGF4d2R5MEJJb0ZJb0ltKzht?=
 =?utf-8?B?bE5zbUlNWGFXOVFheUg5WjVnMysrQXlNa2ppSE1TWGtvUWIyWGNycHkwdkk3?=
 =?utf-8?B?SGprUHRxU3FaNWtORXFQUUNtMjgwSzcrUjZtQTZoUmptZVFlK2UwdzVxTXMv?=
 =?utf-8?B?RjNNYzJiNmJXS3BNemQ1L3liSFBxeC8vRVdYRWJJT2R2NVNlOGJIbXRTdDg4?=
 =?utf-8?B?QmYreVJXemRoZGRkL0orb1JkVVRKQndsRm95TGlkUFI0TnZuaHB4OHA3Nkxo?=
 =?utf-8?B?RUw5Ym9IMVJ4bzRCRzAyWHJaUk50RmF5RjJMRHkvNkh4MFFJZXh6TGhjWUUw?=
 =?utf-8?B?OHZCelIrbkY1QnlFcUdhMDNUL2JyVXlIY1c4TVR2M1A4cVBVRG9jeUlqUVRo?=
 =?utf-8?B?N1ZOVU9tMC9MM1RZM0UxcFN3c1M2OUdXNitEQ3hVOVRSWkFaY0xHaVROTUVr?=
 =?utf-8?B?Uk95bjFlZFFqa0lmSUVlTkc2MWNDN0pvNm8zVzRnN3BTYkFSM2w0b3JVWjcr?=
 =?utf-8?B?b2trMU5oZWFZYjV0dXMySVpzMlpVZUNObXFmbjJTSit3RVdBbjRuRDRPZFVP?=
 =?utf-8?B?enpaeW93ci9zNUpZUW5TV1BLalQreHFtbVhMdG5NWFFOMFE3d2NDWW95ZWFU?=
 =?utf-8?B?OWNzL3lXWUJCaTNibU4yVzJFRG5vSWNTMGo2R296YkxES29uMXFHUlhlVmxG?=
 =?utf-8?B?OWZGUGQ1V2laM0ExWVM0aVJERWgxSjd6TEozbEFzUjlBbnd6bTJNd2h5VmE0?=
 =?utf-8?B?dkpSS1llYnpBK05WTmI2SVlPYjlHQ0E3R3lLTGJjYklISTN2NFQ2blBjL1Fo?=
 =?utf-8?B?RUhDT2puQmYxcC9sVC9yMHpoVklLTXdTQTd1Q2hyeDBPQTlCTTBONWc3R0h1?=
 =?utf-8?B?MFZJU05xM2RsMytvcldPWkJnREJNOWhScGhlWmQvNnhqTW1INW1MSWZ6eEJu?=
 =?utf-8?B?bFdSQ2lUbXNjZjFxR3Q1UHQ1dTVaNm43aVZCVFZKejhKN28ySTUwL2JJMjNH?=
 =?utf-8?B?Y0JaZjdDM3Y4czIyMCtXNXJOeWY4cFpCTlJTNi9WWThqdDhJSmVwNFlBcXJZ?=
 =?utf-8?B?dVB2Qk5aLzBsQVRQQnJFRHkyT2NWU0N0VzNSdW0rSmJxUWV0UWlKRWE1Wlh6?=
 =?utf-8?B?a055QzJybjFsbE05QVB2Qzc1cmZjYWhiNnFOc2ZrcHlBQUlWQjA5Z3ZQTTZ1?=
 =?utf-8?B?NDdVbXVDUGs3T1hGSncrKzhMbE1mOVFQRFhXbWFNL2RwNzhNYndsTFZoSlIw?=
 =?utf-8?B?dFJtT3pmeHR3dG1OdE01NDRiMlRqRnY3OFRlR3g5N0hMTEkvWE5HUXdVejA5?=
 =?utf-8?B?b0h6K1pyaWVMYjV1NFQzZ0dYMno5ZXZFeFduOFI0TWxKNEU5NUlSSXFFd3FO?=
 =?utf-8?B?UzNKWjdHQzAwc1BHSStWNHQzLzhSUjhMelNFNEpWWUxpTXoxUUovZGhVOXFz?=
 =?utf-8?B?U3FxSTg0bStqdzdKZk5ERWw3b3JKVmplYW5FYmh1eTk3Y2NVTVJuVUkwcXVm?=
 =?utf-8?B?c2pXeE9mWlVqc25RWUsxQ0dYQzB4VmQyK2t3RjRrclpvcjViWlJvclhncDJ6?=
 =?utf-8?B?M0NHSnpOR2l1SU50SUI0Y0VRa3NOSGdqUHA2clc2ZG9oTHRIZHFETys3Y1oy?=
 =?utf-8?B?YmpHQzlRMHpFN1BLUzZmTkttVkRoVEkrTTd4QWhrNWFlM0o5U2J2QT09?=
X-Exchange-RoutingPolicyChecked:
	h3iWqQw4AsIVjkvlAkYOPgkNZoESy+8cW+V3z/q/4yJLhACZw8sdQeakJ4emX5u1AJhGLZWybKxNqnI5oG87TbjZ24dJOmbV/oKVnSPyWklI3jwnwJX045pOLbLiYX6qEILJ8nHIUFF684nXSlo887xFB5U89ERYCgPfkVk0f54NcoZuUAjuB4/z/7HtTecW6gQyHG5DvM726lW+dT4S79sJ8w7BTd5CoCVC6ozzMgK52VFybOUfYqJVeAf1F02Sjx/K9yKQbenTgt9rsc/8elGQfTaKKPgwfPC5/maKYoj0IvpKXierH1Y/mby99fTewk03cZKyeVe6i3ehy1I9Sg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Pp3GgIqZceZnx7qX4y8jM80YUz/3tedEx2y7mLFws+jaH9JRyQmr7XCCDXc1FOUUQsxA/oomGQGtMjDL6M9vff+/opZVObk2b8KSE5iuXy35tv+eMxsIPd6bRjNUC9LopKpgYNPaQjriRN8F4zYVfM6v0Wd53gQflijkk1IA9bGcRGR75/FSChcSZXLsF3dvPk0VfoQ8xfKgmG9ORnbNncv6w5R0HFapdtk9FhOb0qVz9ITFPGEif9k7d/p5rWM3PDVJH28Lk1c5WJCpBtYVHEzfdPSVwHgN0m/ZPA4BBPjOS9Xv7t0Mid1I/9IAOt/9m2dM08HDG2ERJZbuZX4155GJpYgg4cGKpvao1mTF1YpRKajLrtagm2t0/1/S0H/T0dvz5cuth4EWOo32AcZBLbHJouO5x7W5BgE62bztMmNgHwI7ZEUBvUOMPezzws7bqkGVI+nJ2PESeQH71pcdXdXP8umvFbcHUYDFZnQcbneSDN8c255SRo01uXobhCVSACfElNGYbGUIA5dm5MHk1fGe/7Ke+GpgvOTJRUwpvZ+yN3bZ9mEHnWYeO45om3oWVl/srUdHDtBYhVZShc4NmrC7IVodlOUL5UuXTYGGLl4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e658e6-bd8d-4e0d-5050-08defa142768
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2026 14:56:00.3621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /YbSXoul+UpAEEofSOvjqY95tt172Wofx9XJWv3QkxDe4/NupGQfcM+DDYcOPMQ9f8tnMp1sKo6TEaUke6rrzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7783
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 mlxlogscore=837 lowpriorityscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608140113
X-Authority-Analysis: v=2.4 cv=M6V97Sws c=1 sm=1 tr=0 ts=6a7f2c89 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=AW86dJP0qlMLNa-6APkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: hBYefj70_I3uEukW7GfGLlb-4h0yR7Vk
X-Proofpoint-ORIG-GUID: hBYefj70_I3uEukW7GfGLlb-4h0yR7Vk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDExMyBTYWx0ZWRfX49cyAu0DQlAd
 KXl7mCNooimTb7XyegFu0NXTnR5MN1uEI86G+3ewQYTlwM9shoLq1+ydChmjUz3w66tWO4DDy5N
 VDEXGzo9Nkm6OD8r2pfofVGbCL9zcYLtGOIhiuMGbpm735UMD3eXVv5RA1ZDzkB+L2X5ROswobL
 bjn/gKUU/AZrO6pKscYqN7spUykyLXiTNYCq31AMYe2XJm+Wdg58QO/G7w3DkrCW5W/qNnwZMwD
 8RGDaLm6jpsfPHwInUpDcGYyevOWafeaH6FQfd0fdMuLrs9EZovj8mUeIbcZsi7PtwDHWkDEQWk
 vjutfSU2cVVhR5SAXsJXuwp3HpE72Rk8D04EGQlPtm98l2uI5yiczdrQ1AWL3OSuP4v/bpLWTEP
 t9WtAYxQNFCMxBxqahDZQVGPZPNcey/Ux+pzyFbyKmGwwylVRGN3IRdxsZTGsFSDLOIrfzCgTp3
 vx5BPYELsgdjYqZ14EA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDExMyBTYWx0ZWRfX/gXowSRAPG/N
 4Dl5mLdP0mZHhp0bg/+A9fe+OMHsd8LM1DEhKiS7KnhSUhy1ukhwfObh1483M+Kztt230gZSznC
 54Qka7PmNMbeVyyZ7Mr9JI1fkYEPBo1X81l3v3HT9ouqtRdLFs/y

On 07/08/2026 23:49, Bart Van Assche wrote:
>    
> +CONTEXT_ANALYSIS_constants.o := y
> +CONTEXT_ANALYSIS_scsi.o := y
> +CONTEXT_ANALYSIS_scsi_common.o := y
> +CONTEXT_ANALYSIS_scsi_devinfo.o := y
> +CONTEXT_ANALYSIS_scsi_dh.o := y
> +CONTEXT_ANALYSIS_scsi_error.o := y
> +CONTEXT_ANALYSIS_scsi_ioctl.o := y
> +CONTEXT_ANALYSIS_scsi_lib.o := y
> +CONTEXT_ANALYSIS_scsi_lib_dma.o := y
> +CONTEXT_ANALYSIS_scsi_logging.o := y
> +CONTEXT_ANALYSIS_scsi_netlink.o := y
> +CONTEXT_ANALYSIS_scsi_pm.o := y
> +CONTEXT_ANALYSIS_scsi_proc.o := y
> +CONTEXT_ANALYSIS_scsi_scan.o := y
> +CONTEXT_ANALYSIS_scsi_sysfs.o := y
> +CONTEXT_ANALYSIS_scsi_trace.o := y
> +CONTEXT_ANALYSIS_scsicam.o := y
> +CONTEXT_ANALYSIS_sd.o := y
> +CONTEXT_ANALYSIS_sd_dif.o := y
> +CONTEXT_ANALYSIS_sd_zbc.o := y
> +CONTEXT_ANALYSIS_sr.o := y
> +CONTEXT_ANALYSIS_sr_ioctl.o := y

Was hosts.o missed?
