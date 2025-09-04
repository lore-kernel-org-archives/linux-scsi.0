Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7007024167F
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 08:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756976371; cv=fail; b=pu6fR6LZnNbhF4vxWZe2u4iZ9EtpjZO9i/FwlaPBSn4dbSQZzQbhA8P95f6oqZj3GaPdCB2SZ2fNKB8P9r/tKw3/5L0OnjyPsruagGwflZLebN8VlNfAr1VvPbEiZDWn1zas4GhqZdEt5UzO3gz1TgOiy6p7IZdFcCrJ5vn6h3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756976371; c=relaxed/simple;
	bh=3HN2rFjlfY9RDtW2rGc9SegvL8BXE5olPpNIcVC4yy0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CMJrAM7VMGuE5At5pAjCC4o1JXGGgwHRQLL1CmlS5/x7sMZenUHvXwo4qyhwR7LHc3o5gIa7MsLY/I+urhVuvc0qQ6LgP7mKrJiORhB2Jo9Y7M3JcuCxIhdaVRiLdAL5IsGgOVPVc3h4DoXhZPx/QhhyFOt/byXAPMET5hG3lvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Br1MAxSZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RrKeuBvD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Br1MAxSZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RrKeuBvD"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5847OlYJ031845;
	Thu, 4 Sep 2025 08:59:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aIT3lCWJwBa+rPQ0iCsK7u8An4xQsTzTNI2OhCvdXSY=; b=
	Br1MAxSZegKC0s0yDURGRpWsn/uNyU68YF5IQUmk0prEcri/VLOi/ivOmOgcOS2O
	3vlYZBJBoKDAMo2a8uM62/V+TvygkomxxTd3t9Epjg1dxdz7hGO5iv9evFK055kF
	cJLhtGJwxwZ3F1EUWsevP/TvmoKnFlgGkc/SG7+2IcNkBdlDaroe7ArbcaubeRqE
	07fx4wUeEeRHJW/2O3VPfWyhCPAu6/Anojefj93u70yLRZ5ze0WTu3D9tG6yfpbG
	Djchxxq0UvT8kp33o2k5UT3YGWnqetuKM4bT0fahgC9Z8pV0cjQLN+QhaX0107JW
	4e8nDP6hiPuy9PLIVKAaAw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48y6brg5pr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 08:59:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58478HZc032539;
	Thu, 4 Sep 2025 08:59:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhnqqg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 08:59:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFJUiOhwsrbknVmBTI7UoghnSGRw991BdtEDaZBS3GObdeLV/WsdFktS48VHggT1oJy5A4dOaT8slvZuS7CBXsVBwYKDOorZChHs/siPmaa12ig3SWyII07rYvUMNjZm550MK3BMEb8OXk2kNwk7YY1vNrPkXcnINcPLd66SN2eg6fzRHP7ZRMbKLX6Q+ZugqnnC+zvniiQKi3oy8sXTK3exqrioe2K+rZ1XpFDtf4OdRmA5LKmX467MbggUT0Xe/Xjo6U1uXkglbAJvkB6/66LIN6x6g7BcqDhRMjFTh60aXd1mZFU/DNib1e1uLxgsMX7gjujSvWtMEJLpr+XzYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIT3lCWJwBa+rPQ0iCsK7u8An4xQsTzTNI2OhCvdXSY=;
 b=LPFOBialVbnb6S7JGL9KhknyMh7HRJhZMEeWxzzrGj679DAU6n1gqytoGXU+rcqE+CDZTofUgeF/7LsysdKkzBlO8I55SvuLdMr23hxzae6S9rShF6hQn0KP6Y4VgU49iAru5Ux4rF3xK5PnR3gya5146ASDnNA5ceRnEDwEMphsriX9RjLbSygVH7AChQySYJniR0ch6sejlTaosNpvtumtmqxn0tlL33GREVpc6b8Z8Qf2y4JR08dIvf/xqpDPy1LvMJwG1R/tqOHnISCZbrhpD22ZRvt+ziBL/Z8WzXfDBJwKqtc9R7NJrmLpKXU9VAmISKnnYeZOKpWs2GoMcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIT3lCWJwBa+rPQ0iCsK7u8An4xQsTzTNI2OhCvdXSY=;
 b=RrKeuBvD+EDw91e6yI4cOrfCGr/5clQ7/t9uvoA9LM/oBzDmP4CLblU69+4AZpoAOPDrQTTyRCqZ1Dd0ipWaqIPROkLpKWJYusCWulTPo4Zo+bTNDiXYaK1raFz0OJ9626Bmhw0+18pOzb51cVLorbkkd5EkYZmbiWAfBivLyGw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MN2PR10MB4223.namprd10.prod.outlook.com (2603:10b6:208:1dd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 08:59:14 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 08:59:14 +0000
Message-ID: <11ae4f31-857f-4830-b1a9-b1593b77c032@oracle.com>
Date: Thu, 4 Sep 2025 09:59:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/26] scsi: core: Support allocating a pseudo SCSI
 device
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-3-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250827000816.2370150-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0261.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::14) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MN2PR10MB4223:EE_
X-MS-Office365-Filtering-Correlation-Id: db0a399c-688c-4e6c-766b-08ddeb91524f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c1htdTRXNXhNNTdHMkc0WjdRU0lZNDBQWk5NOUI1TnZzbmFndW1lM3VaZWZY?=
 =?utf-8?B?M3hMRHQ0WERCazJLbFEwTTFGSG9SWEdnYWdPNUladzd4c1hSODU5eTZ2U3lO?=
 =?utf-8?B?bWFjR0V4NWxyQ1JZTE5BamlEdVNNSXhjSGZQMFVIMEVrbFZvZ0ljdStSTzd2?=
 =?utf-8?B?cVhtZEFHeWlneHpJVWZvbmEzVEtYQ2VDTG9pTVJXUjN3TFVhSjBTZU9ESGNQ?=
 =?utf-8?B?alF0dUdhOG12dXNSUmdPa1p4OCtvNDRSa3JlVzdLUytmU1p5cEd4SXlxS2NP?=
 =?utf-8?B?RUowKzZ4N3FabENpVXJJa2lPRit5U3licWE5elBZdy9qT3ZXWGVpWFZPSnBq?=
 =?utf-8?B?ekRkVlhPdUU4aG9NMjMwVDVtT094Qmd4R1poSEpuZVhEaUhXNzkyMjI2ODR6?=
 =?utf-8?B?LzIrdWlSSHRiYmx0L3JsSzd5aStlSERvYURhU2V6WFJINGEyUHZuTG4raVVU?=
 =?utf-8?B?OVRPaGQwQ2ZmSFU2VjI2L3ltbU9TRUhrTzZNbVNiL2Vuelo0WkpOZCszampp?=
 =?utf-8?B?Mmsyb1RtcmdvVDZ5T0hYYTJhb3FVSjFjMVJaUjhLbXFJRGpxSU00d0t0cGVm?=
 =?utf-8?B?SUtnS0FReTExaDBXcWVkQUJnNmoyM3pPRzVUeHczdkJwNjd0S0NZSkRhUmY0?=
 =?utf-8?B?cnhaZnJRc1hXSXJWdGUvRFRjUkZwSzZldVU2SS9abUE4WTBMOXlqTGRWVlQr?=
 =?utf-8?B?Y0FFNlZCUjZRMnl2ZHVZT0pReVh5eUpqRm56Yks0RG9mM2xFUTdSUGNuUlR1?=
 =?utf-8?B?dEhncDdDU1N1MEoweGt6YkQ3anJLTm9XUHFEN3E1N3YwTHlyWml0VG1LSW5Q?=
 =?utf-8?B?c1EzRXBnaGh0dkg5VmhocDJUMTVmb0VGbmcxNk5ZSjFJWVFKS0RmaXNMa1Mr?=
 =?utf-8?B?NmRKWjRuTzBVNGVMazBQaWg2TnllNFNOMG1NOWFVdHZuelVVVFBDV0FNUTE5?=
 =?utf-8?B?YnFWb0lRNGpFaTdWQmMvMmdQMVZLTzdsUlJHVXZXYWE0QWpMZWtrZnlaMGZx?=
 =?utf-8?B?N0xHeStkY2Q3Z1dDaEZONmV0TUxhdElFVFhHUDZLMGxFeTRoRkY1dDlkeHlV?=
 =?utf-8?B?b3FPc0pUL09IN0FOUGcrdUJidFoxNkxKTC9PYVByazZ2STFBMUFjNlprNmU2?=
 =?utf-8?B?U1AxVXpUckRQaFZNSmk4cjVHbmJMOGxFdFhRWkxwOFFNdmJZOFdLNXVyaVhw?=
 =?utf-8?B?bFZjNFhiNlNMWVN0cUtzT296UlcvQ3NxemtpakFZajN2M0VRV3QrcTNhUm5N?=
 =?utf-8?B?T01wdEZrNzRsYit1QjZhWlBUaUFWYlBoOXpYY08xcjluY3BsOHBIVnhyU29Q?=
 =?utf-8?B?bnIzRFBmakF3YXdVeFROUHNBZXQ5cXgxbTZzMjhUVk9iNW1nY3JqVGFRWFAz?=
 =?utf-8?B?WS9pWTBkcDdMSmRpM2xxRGpuY25XRWhTY2pSWmY1dDlwL29xVmYyVzlqbHVD?=
 =?utf-8?B?MzYrSmY4aTl0TnZUMGQ1ZDNxcE1CUDQ1NW9ZMlVLdUU3NDdodVBVbVBITDgx?=
 =?utf-8?B?eDRPZnJDK3ZVMUY4TW5SalZ4NmxzcFNiVnZreFBOcE43b20wNG42UER6b01i?=
 =?utf-8?B?Wm12WXVqdjZudzVxVlovZGpOOGpCWXFNRkljbU1EWVpoc1BQTVY1QVYzYjNJ?=
 =?utf-8?B?N3N0b0FseExqVDhqdG9YWklaRzA0ME5Id1FNanYyL045b3dhZlk4VDc0NXFs?=
 =?utf-8?B?UWQ4TUIyd2owb2VtWS9HVnVlN1k4YS9xajdoZUs0OTRxWC9VSDhOT1ZCNHEx?=
 =?utf-8?B?TTdhSEQ2R3h6bk9FSmU1bjZZK3BzUnQweXpuS09hMGpQaGw1djkxTlVENUJh?=
 =?utf-8?B?b1JQNWRZa3VEY0EzNlgzUmYrQ3kybFg3WmtKYm1NMU9Sa29wVnpQNFlCTzc0?=
 =?utf-8?B?MGNZRUovQkZLM2ZzSVhQaEFNc01XWTRCcEJDUUF6V2tMell2N1JKK3hyVEJ1?=
 =?utf-8?Q?J/KcFjrtfgs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b253Y002NUZ2RlRreW9HYmhhdVd1Qmk1enlWSjRvc0Fsc0RneU55L09VU1hE?=
 =?utf-8?B?WVljdWVHNDIrOXVEbEhjMVFWS1B6SE5DRm5NQkFCUHNWc1hGdWhGaWpTQXNU?=
 =?utf-8?B?NzZNeHFGMHVjVHZXUW1JcFNxamdDS0l0aERNWUxiNlZIRGdhcXJaZnYrTTcx?=
 =?utf-8?B?L2ZsRE1QV1prUFcwa0E0dzZYTGhRU1pOSmFWTEFaSjU0YUp2eCtnUjBjSC81?=
 =?utf-8?B?T1hKQlQ3dkJOZHUyZFQxMmdKc1lyT1UrL1pVdG9HK2pDM0tUeS8vVkQ0Ynd3?=
 =?utf-8?B?MlZGSVFZUit3S1M1Uks1WUZhN1hDOVlHcXdXajVyWGkzWWt5SFp2V3puNEx3?=
 =?utf-8?B?MDJjNWVneUduUTU0VDVLZXJuZTNMTlJmUmIybkJyV3g3UzBVOU9OVFlFT2Rm?=
 =?utf-8?B?cTZPWmR0Tk9jWjJKSzZ2NEcvRUlSYy8ySTc0ODdZeDZERlhZQklPekRLelBF?=
 =?utf-8?B?eGRpaEliRzBuL1JDQW1VZUFVb3VVbDJqaVlzWVB1bUcrSzdKbDZFVmJ4elpL?=
 =?utf-8?B?YnFpaEM1R3h2Z2VLbkZYbHhIeC82N2xNSlBKeTJlYlBXSkpVUDFLZkFScEtJ?=
 =?utf-8?B?Wld3c1lLYUZUdmJUek54WVFzRzJLaUtzdEJOQ0pjNzYrNUZoQnZDMWdzN1Zt?=
 =?utf-8?B?d3FLK2ppbFpLdC94NFpRQk5IeWFlOTExdWEzR1MyRzNDendSRVY3b2l6MTVq?=
 =?utf-8?B?c1A5NXRKcHdFYXE0MldETDdPejNkdVZZbENqaTF0QjQ1WkpYcHF5SEs5Zkxo?=
 =?utf-8?B?VENmTlZBWGNSUGZ0Tyt0YUtmM29zQjROUDYrbkxQbXpWVzhaVURyRGFONHVN?=
 =?utf-8?B?MTJyYVRud29VRVIzOS9MR2FoVDZpZmZxdStNRWpGdlpGM00yS0hVSFJ2cjFG?=
 =?utf-8?B?NysvQ0xMVXBFeENET0MveWlBUTR0TUNLb3dxcVZoNTJIenpOdk9uVGxzWjlC?=
 =?utf-8?B?ajU0TUY4allxR0Q3WEdMMi8yZmtWV1diMDdmWFJwSnhLZVBWZXVQQXQrVWwz?=
 =?utf-8?B?M1dIM1dLajVwTmFYSEx3bGFVZzNPT3ZCOGdJZnhKa3BKVEd1dkhZWUFQaC93?=
 =?utf-8?B?OFVTbnpnUmZFN0JxRW5Fanh6eDYxZzhxU2paK0ZWVW5ub2FjZG5uVDJFQkRM?=
 =?utf-8?B?ZkZsNU9zWExEcURsUWZHdkUyMFFyK3RULzcxaHpTem53Q3pmSnY1MWJ1Smp3?=
 =?utf-8?B?ZUJCR1RUdHQ0VzE2blg0QUhJd0xuM1BPRHVhWEtEdWFpVnllalN4OGhsTG0r?=
 =?utf-8?B?Nko0OXZza2FuMjA4YlRHKzFOTWZZSkpYZ2RoaTFKRThiWEt4bkJpZ0hVaFE5?=
 =?utf-8?B?aVU1ZzBxNzBpTkFsaEZPN0hmemxXb1ppeWc2QjYvbmtFT1IwSEM1TTVOSnN1?=
 =?utf-8?B?dzlLNU03RXd1dmd0aTBITC9memtjekNFWkxXYmk5YmlCYVZma1EzL1hEa2tu?=
 =?utf-8?B?UXI4SkozREwxcTlPcVRjRWs3bDMrTFFFeE52Y0xkRnFpOWZrc2xiSmJnMHd3?=
 =?utf-8?B?QStuV3VjVWRRRmFsQU5yM2dEajZ4UVRTaWtSSXhGemdSajErUDlaT1Qyb3Nj?=
 =?utf-8?B?dmh5SGF5U3VsRExWRnhLa25wVjJZTGp0SnIwcGp5RmZaL08vNmVZcU1PbSto?=
 =?utf-8?B?eCtlVW5Pb0h5K25USTBYSTl4Y0l3N1NGNk5qd2RITkhpRTc2bWpGa1JWYllJ?=
 =?utf-8?B?QWg2V2pkd1dXbTVERDJpTFpVRTZvNHo1QTBRY0tHTDlSWEtzZjhwbUsyWGZp?=
 =?utf-8?B?QkdqM0w4d3RaWlRwZVAyYWNjQ2ducjFYaVIrMzZhejlIb1VmaWdXZnJFa3Fy?=
 =?utf-8?B?UlVwajVWZ281dzkwaGpaNkdmUEpLRy9NQU10eldGUXA3TEMrRFdWeGpvLzZX?=
 =?utf-8?B?MFFkM0lyRDRaUzRZQmJQaUJWTDA3QjZZeEw1ZkpwUUtKalN2eURSSGJmOGht?=
 =?utf-8?B?a0I2dU9ZcUFmVkV5MVVtNHVRSVRGSllIL05XYmhjQkRvRzMwbzZyRE56dHVi?=
 =?utf-8?B?M3FiRUVVWXpxSDVjcGxXb0N2QjRTU05RcHhiQ1YwRWFWUXErWGZiTnpLek1a?=
 =?utf-8?B?NHBJWDFUbFhIM0dLeVZRYjlza2tsUVdRaDJ2T1pPKzA0WS9MNXMwUWpzUHRr?=
 =?utf-8?B?Qm1RRVRyVzEzb1ZTSll2SjVhU0lMYTZOcmJUVU5DVld6dmZhemxjaFRhYVgz?=
 =?utf-8?B?Vnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qipBv2ZHeLCqPNScIECjj/BqlE2KAQrnVK3ZiPtquxZYXqBVHWVBm+7QAaI92F5ea/Tr5AGrhvGtEEeuUE0PeaCbl/e3rkHazqVuUX8I7RN4vSpcipzk/Jf7YObV5y9wqJuIH2HJmzNvX8k7WSuJgXoJNsyoYScImBcncbRUdmeWpOxYHQmMyz3XrO2KyFMHv0216TBF6DWzdp3b4jRjcBQQNsigYMha2X8LOY+5y20adQwmsPLRbzum6jjKDKJAGcsKtc0HNRGDi7wH8IeoP4cdE8lQ9jdYacd4gMTsAEiiDWU/ePuAmII/ZYq++0g6XYohjjGbXkHqpFV5BHByxenCszUXHM4aHNKbxujIB+WC8+4ktArQ/zMUX54veKbeN+rp4n4qXKpdLIf4AbjEa7CSeC3uxcrqyt6CAxU8XhBITZ3+0qrV2ntQDUJLS71pVtHVzc79Hjk4g+cpsM2E/ksmSbvHBb1icHFsY7aDU1g43h0ag8GiUdNIqzA7qhNXiDQJhv9Z7QohoW7Rik3DYmu9AzAeptIOF/+wph0hDSe77fP0HUKLSF+uajXG9zKFgcG99VCO7hBkUym3gcJun5CoQ3lRMIT4Imt+dRQJNZ8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db0a399c-688c-4e6c-766b-08ddeb91524f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 08:59:14.2601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4mVwqDx4wWOYehDOQ9zVXVQAVDBaHTDEUCTca6HmHkez2qBa+xQsJvGleMJoSIM+NKnpUUpxrb0XOPQtkmxxAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4223
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040088
X-Authority-Analysis: v=2.4 cv=QLdoRhLL c=1 sm=1 tr=0 ts=68b954e6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=S_NVzVYh8L1mRjnsqiwA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: Ehkc7YEtOBfESXBWBg8PAA53Me_Y79tH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDA3NCBTYWx0ZWRfXxTDRzOF+msD1
 WmEM7dRtWzBSVLW35TmxIoZBPrzG62f4TAQAaqbD20ZSVc7HmLZuRVPtNsmAmNjszQPQ8LvZbw1
 ozPKLj1RQJI963unDHoyeWiugk+TSqtQ+SPGoBH8cHgjtWJ1UdD641OlX0r1Y1xUb4uYs/+UsVr
 iNjkTh/mhkvs65dC1lcRixYWXgb1D7FtgL3iqKDPCsxF6vTP3Dk81ufibe03Qqv/X+EoO/QnyH4
 e7V0rWbczvJoxl5VfyI727IGU4J3jAe2GuwrEhz2XLwqWB7QQ/ZA1hUJIDCmFhle4NwHPqDSsk1
 W+xxCuMAfe7HhuUmiHUScmr8H4vtuNcKWLO/porjOzMApXYN5ynk7LGcmgJe7d77DxBdCcFwjXG
 b1Z42akaILBWn4RidlRzN3TGkEJJzg==
X-Proofpoint-GUID: Ehkc7YEtOBfESXBWBg8PAA53Me_Y79tH


>   /*
>    * checks for positions of the SCSI state machine
>    */
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 722ecbee938e..3b5150759c44 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -463,6 +463,9 @@ struct scsi_host_template {
>   	 */
>   	unsigned emulated:1;
>   
> +	/* True if a pseudo sdev should be allocated */
> +	unsigned alloc_pseudo_sdev:1;

should this always be set on some conditions, like nr_reserved_tags > 1 
or we prove a method to queue reserved commands in the sht?

> +
>   	/*
>   	 * True if the low-level driver performs its own reset-settle delays.
