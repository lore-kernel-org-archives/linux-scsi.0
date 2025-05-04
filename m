Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F732382
	for <linux-scsi@vger.kernel.org>; Sun,  4 May 2025 07:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746344217; cv=fail; b=XuevIJBEE2yQeLKCXsNWvr8fPW1jEK2BLboDYmkXf3UJdo7zZMCnx0kXCUqKrIIuEO6ZU/fDQXGm5fZYyHqmqDf5xUCZ4VsrFS7XFyx4dVgFZ6GyyPSVBdl3Mx7+qBl7oJrf3t0mizI+pLJ9/53k4Pr7WRdNunfhXBMEVO78UAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746344217; c=relaxed/simple;
	bh=fDOq4aR7LkthevPD6NGwQtrgSh1YVVnEf5jPvitKpZ0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UAlw3iRqzdBXdw4ZiwmVuSMtfnqhR3miVN892v7KXsnxFwfnhsxilAe60N6vh93f/82lvz+22KKzs017G4Ygchu0uHposjG/zHYJtPxGObn65Dx15NwFXvSzMNjQ6iT4lEhOcdsL7uZ0OahWlNXwI8/UgcZmK1oV3caueCitc9w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lzvy5Zsb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MjpVPMRm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lzvy5Zsb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MjpVPMRm"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54477cGv015925;
	Sun, 4 May 2025 07:36:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jESOjE1tIWIHfpzZ0ShjV+Rjcb10Prv1q3Fvg0uAu/Y=; b=
	lzvy5ZsbHn55vL5fcji6SQOZiTIJV4u9ENKNiGMjcOMZjxbWZowXJheSREmgK6GQ
	2vvGnB7m9XRcPRkGSp2BppiEksHRRsD0AJEzfytI40o3eyntHgvQeWuHT7vJih2F
	59nKihY/bW//DspGUt5fW6X0jgw9ZoJhrutyPhoSBSr7okvKs+UwlFNKP2LG5o/z
	tMGE5qBS83H64eHvjZZtoOTQZZYrcwonW8X5TXBGbnUUwwz6XAZ7QClQMZlnh7gC
	5g4g3ukQZFl/ndKtcQPo6V/PTUE5XFVu79iFW8noq2Kxp52NlIMszFg/WuCb/EeL
	eIppG4RzVWRhagdzPtZ5Lg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46e3jk01p7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 May 2025 07:36:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5445fcBb025089;
	Sun, 4 May 2025 07:36:38 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010006.outbound.protection.outlook.com [40.93.1.6])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46d9kcybq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 May 2025 07:36:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oNOZn+Y0DfT4znc1Nj+eK7jJ6SC5MkCPsrJK0S5qHFJKjjoDV8kDBJi9WSZtNV0+85FUUgDr8RKoHnP7hAYrj5eHOAuMmDBOGsM4YGuNgcN4dCsYsocGdrb5l2CylZgGcScDtA3TeKUNv9tLYFwg46ZjZ6aZAkfpJQcMERJrd14Fl31vOaEATBaunbiv6zladw1hu5wd2zeacSViR2yNBCP1qnDrbxZDHtuCfr19dt7xnPQH9NDj4hQqQDmhEqygRhYbWJjDx3RmV5dTZX+YGfQn88MnRwJ9XvG1SoansZLQzS4nwe2iWvky7xUTiFf+pcdaiMGLugkvchRhWjMMcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jESOjE1tIWIHfpzZ0ShjV+Rjcb10Prv1q3Fvg0uAu/Y=;
 b=tOs4QNE4xyeMHmvbZY1IajJ71+Yc6V9ZM185V3A1srRrH582yZByZTBatemaKnvwlFjs9qMSVbhqfnSySeA6YmntDY7/dzYXTAqRMiiLFSV/eQ+BuXC+MbREJ8RkjXvGw1Q02e+SHXv/7foheD+7PcQTjMZ9A/vBYtgo+CZvaH+fV8DbB7QL0qU7tmX6Lxs5U89fbw886waPto6Iqmgp9QSGwzar8gxY1xexHGx6FTwUnMwgmW2Oghx0Efd23C/WnRfvg250B0xbxrr6scfMVeCM21duTUfYVDFHJNtFMCbjjNJkYJGYrWLRB2efOyPd5xH3xlUTuZQap9C4SqM9rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jESOjE1tIWIHfpzZ0ShjV+Rjcb10Prv1q3Fvg0uAu/Y=;
 b=MjpVPMRmHBH5jJY7tdOj8b9aGFp10w5XNw76HhmFSSofODBS7YaCY0CAe0g998ToCyRhP/B6i1kOitPKD643Yi+UQEBap7V68ZT1DRZlV0YJpMZ++5fnfnrfF3FinYw0IBypYVcWTos4SzNyhAbjnuVW4gRcFw6VLE0Wbqx2/hw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB7527.namprd10.prod.outlook.com (2603:10b6:8:182::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Sun, 4 May
 2025 07:36:34 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8699.022; Sun, 4 May 2025
 07:36:34 +0000
Message-ID: <197f45d0-e86a-483f-b16b-cdab30f0199c@oracle.com>
Date: Sun, 4 May 2025 08:36:29 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_debug: Reduce DEF_ATOMIC_WR_MAX_LENGTH
To: Bart Van Assche <bvanassche@acm.org>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
References: <20250501100241.930071-1-john.g.garry@oracle.com>
 <0ede0a81-d0d2-4425-88c3-2e2e6f741427@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <0ede0a81-d0d2-4425-88c3-2e2e6f741427@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0118.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::23) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB7527:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fe2cfe1-40f9-48d7-a879-08dd8ade64f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N1ZGb2U4TzF1TzJ1RW4zdHpmd3FRQkRVNGxGZE0yVVkxZUxnTmo1MFZhOExi?=
 =?utf-8?B?OVBFckhpeU1DNXMzbFlNYkVhbHVoYWhuUkFFNzI1Vy83YWIvS2daMDkvR2Nj?=
 =?utf-8?B?ajZSTHNidzl1NWVxdkU0cjhNb0RqYTQzdy9XaHlMSzhOc0lWd3gxblJyNXpj?=
 =?utf-8?B?bUQ4emxpNGpQQ0c5Z29nSGlRZXNpMm9QNEJvQzZmNHhWdEhweHdGWE9zNlM1?=
 =?utf-8?B?MFJPTXRnTzdCb2J3aVZER3UxZnRLOUNoN1BjanhtWEhvN3BJODVZNkhSRHQ2?=
 =?utf-8?B?bFFZTlNtTXdrMlIxMlRJSVhRVFdOS1p6L3d0MEtxTzI0bm55Um5KaGV2eEY0?=
 =?utf-8?B?WlZLM2pPK1FiNXhXUVhYczVDSFU5ZTFxVExCM2Vmbi8zR0FyclU3cnliVW95?=
 =?utf-8?B?Y1VrcDlCemEwcmQvYVh5M3JvTUVEaThjYmRWK2ZQcWlVckN0aGlIMlhaQ0xR?=
 =?utf-8?B?K1U5V1RKZjZBUEF0ejNOV2Vqbk4rME43ZlhQYkh5ZlMwb3ZZc0Uvbi9zeXNV?=
 =?utf-8?B?RnBrZHg5cW9NUXo1R3dMYjRldDBZdk9UM3ZXT0FJMlJla3U5OGZORCtTN25R?=
 =?utf-8?B?Rk5DR2YzdUFGRkhBMng0bEhVeFdmRDQ5MUlSK0JVRFNEV1ozM3AzZkdoQ0dV?=
 =?utf-8?B?c2tiTkw4QlJkQmJvS002ZVBkYk1leVZCVnp1aVAwSHZDdXZXdEFaQ2F1QVBv?=
 =?utf-8?B?cUJIQXQ3aTk0Z3ZBNWozSC84cllCdEpmbU9SZzVETjNTNDRacVZnMVFqTnYz?=
 =?utf-8?B?cnQ5V3dxbTBZUkFjZEpMV3BwVE5GbFFEQU1xWE9kbVBxbVViNzJSajAwYXly?=
 =?utf-8?B?S055Y2twZVlCUkpvd25tSUhOciszV1JMdzhHTEhkY2huSWxvd0ZMcFlGYzRy?=
 =?utf-8?B?SUNqNXZCMVBPbFNsa2gwcXFFbGNDSWZqTGNrSnhQRFpaakhTSjJwdzZkQXB3?=
 =?utf-8?B?alJhaEpPV01ZRW4yZUoyUFA0Q3U5UnhuZGZNUDNhbnBLZzdjOGlOUXZnaHlX?=
 =?utf-8?B?dklSU3ZVaGZwMTZ2RXdZR0JZeGU3T1NYSFBjMzFiU3o5WkJQOVBVZU9tTmh5?=
 =?utf-8?B?OXpzQ2RCQnZ6ZThDNlhzK1FPSEtrMkNDVmJrRWtKUTZFaWhUWUwyWndFNXRP?=
 =?utf-8?B?WlE4TlFxY1ZpWGV3SHp2Q2JQNjJycVZFQ21oYkU4M0Q3ck1Ud1JoSU94NHow?=
 =?utf-8?B?L3RuWGRIMnJYOURqbnUrWEJYZ0orWlY4VlM4OFZJcGE1eTBDSUozYUY5eW1Z?=
 =?utf-8?B?cmhidG41ZjhWY0Q5SXZvUFovMFhiNmVIV2dHK1dhanBEWUtkVlZNeWR4NFo3?=
 =?utf-8?B?UUFrZ0xKMWFTd01BNG83ZzkzTHZkZ1VhZmorRVgzM2tObkZLZU1jMGI0Q2Nx?=
 =?utf-8?B?bFZHOXRhY3ArSFVTZ2JpOFZabUtIMWVZcFVUVExVVTh4dTl6SUZsMU1Pd3A0?=
 =?utf-8?B?dUc3N09DR3dqQjhmSWZqM3BmMzNtdFNLOEZRSzJRWnAybVVrNW51RkFlSFNn?=
 =?utf-8?B?WEV3K2tUZUl2ejlHR2tieFZEdUxoRU5OUUdMUThxRGRJamNCS2hOL2Q3NEwy?=
 =?utf-8?B?U3Q2WTRjWG5vUmJxM1pnTnEvb04vaTh1SzhiZEd0amVTTnkxU24ycTMwajQ1?=
 =?utf-8?B?ZnpMV0hYaUYxd3Fhc2h1aStGbjNaK2hSU3ZHLzZTOThmOENRV2dMMmswbERw?=
 =?utf-8?B?bzJ1RjNsVGMvaDZ2ZGtRdGk3SDJraUZKcWhFZDZwWXpHODlueUtZb0MwRjBY?=
 =?utf-8?B?M1BoU3o1NXZwM2w1U21RY1ZFUmVReUx1c3FmaWJxb0xBYmw5L25aenkzMCtw?=
 =?utf-8?B?ZFVuYUZuSmhZYkRwUG5iWjRnUnRML1pSVzE2UDNFMWZvelFlWTNPMVBLbUVS?=
 =?utf-8?B?bk9HaTIvYUhjN0FFQ0pVUm1LTStRZS9GTy8wU1dwWnVpK2hPRjl3TkZ4N3cx?=
 =?utf-8?Q?vc3HL2lJ8yU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UCtlY2lHaFV4VDV6SHBqL2lobXJqTHR0YVFLNjIyZ1FlM1lXK3Q1S2NGUnpp?=
 =?utf-8?B?TVNDYzFXZUJsVnVaWk9lajFXdjBOMEZ2T3kzRyt3bjNsZnR0N2VvYlY0eVV5?=
 =?utf-8?B?eG9tcE1Ra1prdWhFY05lNG1aTGZGLzU5TE9sS1NacHNxV01BSWVPZnBhR25p?=
 =?utf-8?B?ZDZ4SS82c01LNzBVMjhMSk9teGExd1pCOFJpd2VyamVKZ2hMVVpEeTVzSlJv?=
 =?utf-8?B?c0Q1azNNRFlaV0pYZHBDaWl5Skw5RTcyKzM0ZG5jY2JEZmtKVkl2VjV0bkRQ?=
 =?utf-8?B?TThWeDhieFhJNm9aYUxZZmZGOWl5MmxCZ29ZSWE2NlBycnp4M1FXZGxURmNW?=
 =?utf-8?B?MmNhdXRCMkM5Vm1RQzFtRFpVb1F3Ukg5VTBMeXV4QTRCazB3WmJsNzR3Y29l?=
 =?utf-8?B?MG1obGszNDdNb3p1OEc5ZUhmQjJYRkJWYUdJMHhpM0RqMEgrRDQ1bExyNkZ5?=
 =?utf-8?B?SzVSQmxVSUpUZnM2d1A5dDA5NHNXWXJCdjV2ZGsxdmEwK1p5RitBbkkrVDVv?=
 =?utf-8?B?L0dKeU1nakp5a0o1VWlrNFE5NVVHUUtHSWVISnNhTFg0SDJKYXIyS2V4UGJW?=
 =?utf-8?B?VWNSYkl0cDBJdkV3aFA1Q01UalIyWjliSitQUkEwVmJzdXZxTlV4bE5hRU9P?=
 =?utf-8?B?d2IwN1BzUmpXNTBieHpmRzFmYk5WT3NWU0ZpdThaQmNWT09rK2V3aW1VK25l?=
 =?utf-8?B?c3NxUnhYck16L3BZN2s4UUtlc3NVNWwwaCszeXR6S0dlTDB6Um9wbzRGZWh2?=
 =?utf-8?B?TGtjTkVaekxQN3hhS1U1OE9MajVBU01YOTFacXRJY2RMeDlxcVJjdmpGNXlz?=
 =?utf-8?B?azQzYnFWc0RhYzF3R09pcFM4QWJqdER5cDV6S3RRZmJieWtjRVR4aEh0K3V3?=
 =?utf-8?B?RGZmdzU5cFErR3IwN2JvMjUwbFJJOGxjQm0zeGxIK2YySEZOTGthMmMyZTJJ?=
 =?utf-8?B?WHlpaUhyeXZDcjNSdWxyQUxrQjZyTGJBZlVRWjR4RFE0VHFXZW1xS1JkN2F2?=
 =?utf-8?B?VFpYY1lZc2FXM3BaUWZDdVhoL2VVYUNjZklxcGVWK2VuSFVXWFdrNkpSbC9N?=
 =?utf-8?B?UEl4bisvMVRnZHNCNTYyRFZLY3ZBbWhHZjdYMVdqZkhhZ3dsajkzbTRZZERo?=
 =?utf-8?B?STdEUDBTM3hyR1Q0WDhXZiswVzVyMklXUERSN3MwVS9YME1aalJrNm9iUEVs?=
 =?utf-8?B?Q3hkaXhCQUFEZEZ6SnFOd2gyYlVaSVpjWHpQR1NhS1oyMTJVb1ZMTjVST1Zw?=
 =?utf-8?B?aUJOZnRkR2tyd3VmYjRDZzBMc29MR3ZCRDFvUjFxeElScVZRYlNrS2I2T01U?=
 =?utf-8?B?eERWbmcxbTJpY1hpbzkrVm9pemlxZHEwbzVJZnUrZXNzYjVVa2o0c2lEclJY?=
 =?utf-8?B?NUpkRTIzL3liQ3ZmTlZrOGlGN0FiYU5MU1ZMWFpNWVZTZURPVTVxem04dlFS?=
 =?utf-8?B?QWh4NUsvT1kwejRpQ2JBRGJ6Y3V1VlRCb21OdmRHZURoNTZsdENzSWlBL2pL?=
 =?utf-8?B?bTltWGdxem0zeEY5bGhJUjdRMlpTbzJjcHR2dDlhRnVMMHFlcklvRG5hb2FM?=
 =?utf-8?B?WHpUUmhaNk9jenFhcm1OVUhHWlpISDZPKzRqRk80Vld4OHpSKzJZalc3MkJM?=
 =?utf-8?B?MExyZTRuK3hPNVNoM0NFNzhyTEsvckxBanJTWXFjbTVKRnorYmZ4eFZvcEZa?=
 =?utf-8?B?NTIybEpvTTBNSjhYNk5lZGR2b2w1ZmlUK3BkeTNEeGVYS0NSY3dVUlBlUlZX?=
 =?utf-8?B?cHMvdDdQeitRTnJrNENubnZMQ1NaL2VwR3IyY2NRWDYvQ3lEamo2VmFJNFQ1?=
 =?utf-8?B?MW1QV1lOWUUzNEVuZUNrWDd0TXRlbnVZSHhrc1hnTmkwZ2FmdVRYcjZhczRu?=
 =?utf-8?B?aThjVllUZ2ZsZ21CS2lqdGlFZGMzZEZTU0M0Rklkc0xwZ1RBSUVWbHZnblVk?=
 =?utf-8?B?ZjBGbEJVYk91a2FxSlRLamJNaGdLaERaTUVuaHp6dVFsbCtLSURhaXVvQnl0?=
 =?utf-8?B?ZW5xK1h0UFl1OERFNEkyL3l2ZW0wbjNyTjd2djZvMnJERjBiTWY3azNHenRr?=
 =?utf-8?B?SWNrUnovaU9mdURNeEZlMEhhUnBFQXdVNk5CSitjL1VYV2JWbkdjVERXM1Bz?=
 =?utf-8?Q?fhgeiiDb1vcG/EWIc3f4oY8Nx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KJ924eB5I8L5QpZE1ZvW8KFS/X8OH1Hyjb5kt+t2mt8QHqOBSjc05hsXo8oWwbJ9MziuFqNQaGtKUtYrzramuNCI3/Atuds4dq7/m0siGmzrMqAkD66JSDURBJakOEYvvngMuRmtIf5bXtp9Om9ZrPB5xBuM98cgFbJjQF1unueL2tP9qaJlbP2pmhCqTUePRxR3aACWlTTfMUIsiOGZU5B5bc8iV6/0gK4cfkA+SpZkQ+sZHlMTUDWi+mLYTFhW44JfB+hjx/2D85NPK8rYMAqgU+neB/tau3kx0CGMOe3vADbKtw3CgyJkP4Ls6P6pHpDmvs1b3yaP8gVDoENgTbVv9GUWp1UVFr30O0rjfBUEDdhJlJalJM0SzYhEfWW3zh6NKtJtCFehZ8T4X8vRorqMAWMeaCrwpMGA02F2UL0CmsSPk1hRUrRu3jDIJuj9jqGy+AkI4bnn4N8SbjxX/raYzQt17QhgZ/J9vHBDj1sA47YVUdg2KpzAlFZ5p/+KeFpggw//G6h+Xo6D7b6DjMDSey0ch/xhWnBEwqgL1u2+Ex5dFvQ6wnZBFI07fk3iIo+eMKgr7mB2B54ZLPwDBZhL4EKINH+W38+dTuJvK7k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fe2cfe1-40f9-48d7-a879-08dd8ade64f0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2025 07:36:34.0071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hpX11Dx0ZzStsy6PkIyOBif7lVmkM2fcxCjT5VcxKyIW+1XhahcbLIfxKIKHTyPfWe9pYhiZFJXHc/iPmvHLgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7527
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-04_02,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 malwarescore=0 mlxlogscore=987 mlxscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505040069
X-Proofpoint-GUID: 1xfmhSx6gYcbhoDo9GaNrPyFuzJVmRG6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA0MDA2OCBTYWx0ZWRfX9j4riwahOinm KQSn3qI8BpaaOf/xEz9UPyr8owuIz28QOuF6UgXD04xI001znwn4sIU7++DS9PHJRCrYL7WbdN0 22Y8I/mhgOVYSGmnQYBDAEJPbNbkf/k2sVoIoVhdInCfVSMqocc9inlfTj9BtNdber/URDrsDbG
 KUgr4+Yo3jPCXPRNUn6YgsY/CZy9hvdHo7ul+lA+W49dJsXxGtY1jsFewGxTTvzFAxqAZC5cmZE SxJRRBQUMqvxqhrP/c5aR/pl1Mv7oMHPMrP+07sEGJj4EJmH+A/7P6a+dBJ0Z7g6VxTLaxWcnPr gPb9LKgi06Dor4z1aNrQvNjl6Lqf4NKB13ZoiRhMOM1H2DshBG3qYNgDMKSNRIx4Zws4+7UKiqH
 qZ4+NerbouSejPxz03e0nNCN7PN29lhDYpVwPUJdInH8+xS7ioPDh+w35ZhmC9UFLq4xfmFo
X-Proofpoint-ORIG-GUID: 1xfmhSx6gYcbhoDo9GaNrPyFuzJVmRG6
X-Authority-Analysis: v=2.4 cv=IaeHWXqa c=1 sm=1 tr=0 ts=68171908 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=DQxkuMu_DAr2c9TA9FAA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13129

On 04/05/2025 04:13, Bart Van Assche wrote:
> On 5/1/25 3:02 AM, John Garry wrote:
>> -#define DEF_ATOMIC_WR_MAX_LENGTH 8192
>> +#define DEF_ATOMIC_WR_MAX_LENGTH 128
> 
> Shouldn't a comment be added next to this constant that mentions the
> unit of this constant?
> 
It is implied that all these values which correspond to VPD page 
parameters are in logical blocks.

