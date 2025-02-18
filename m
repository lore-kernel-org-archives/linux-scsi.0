Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E1D1B0103
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2025 12:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739881111; cv=fail; b=anxA70ICdfceVoPPs0qvQ6fz4tlOZRRPWQoXonCErpdJlngRY7oSVyOhKJBXA9Jyk2bY/6XOAvij1GITifqPCLtPUxXeS8An4Bu+8cvUt+ape2QVq5VYyFTqOYjrjF5xtliQd/W6rNIIA/WlR9ZMHu009lWllz6/ni1F3cbhyz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739881111; c=relaxed/simple;
	bh=hVF5/Ju2l2dGob7tAljY8uCHq2rygykiuiWwaw2u6xE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m/+jD2Xl9ZlZ7LPscpr2qsKlFPeQ0VaSZ2lkA49aaoHPc4CuTq93U0QXxuMqNv+hqotPYQlTeztqZcB+XL2b/6JIuURPwOgCrHkdIHOmTb9kKX8AAO5Wa1snOcxAYHlfzLpxBXQmuDN+yZT3k/vZ3gJrlwqxJLfloLW9A7CVmW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LD9tcmco; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yQ/W8XX3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LD9tcmco";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yQ/W8XX3"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IBqBMY027742;
	Tue, 18 Feb 2025 12:13:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=4qd2PgvYdMUQP4X3/7cOW51TfgvymAZzctxzF85NutQ=; b=
	LD9tcmcoNdW5UaARFa4GYsx31klDuOOAL6LCvT1abMAloMxs9/zGoa8JsRBjf3a8
	LBYD/acHFiyc3JrRh8k3CxfrysKqdMFu5GC8CgflSbo7vCyJNZdWuqtsOJxAST8F
	fzh0kyzTTWXecIjj7b8J6JtoT+uzbKPV7V4c1KCiqE00B9iYX4tUo5YumnoXiYZ6
	QsgxeLdGDidVUDfHapjFxlHFKCUhVX4TmmgGvSX8swfAJ031g2vz9i6pdMyF9guf
	yDvf0PGHQJY4y+JNT4XsRel4aV6gtDz4cSsZQLy9Om+dnseBglh4QoJKxbBtVHbC
	q07YzWTGRzNNwFe7ZtQIZg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44thh06c46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 12:13:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51IA6lOC004196;
	Tue, 18 Feb 2025 12:13:14 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44thcf84nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 12:13:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yP7tNQ4xmV+m5CIzs1Lk1enyUz8tgX1dUbC1yZwyLwT+sBPmAeTDKLNZL4N0bS213xF0wtwIjcSoc+nHmm2XvWfWUjTA3o9UnLMp61jiv06QsGjJ7Q7V3UZyGtxgQtRwqYU95LgtKV5cWNffH9QB59lqUdVlms5/+78VGaMpHL7fxoyXpfxnFMMxjOA1UL4eSU+8caoYRswLm7+uX97fKuzQyW3dv0BJY2G+aX0vL47kXTYlFF90tQvhV8uvjhtWbeiV8kZ84Lxq237AHyH8Mhz6NypggceVcgc9fe9fLAmxsYDOe2XoEInc4Sb9jNl0lSCNtN6Y1IkvSxHjdWc3Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4qd2PgvYdMUQP4X3/7cOW51TfgvymAZzctxzF85NutQ=;
 b=E/DBt3w0Ys23vMdHZNuSKls3PFeV9FEma7VzMjsyMi/XYBA4H6kNPp7x1C1wt+ke11+ihhLF3tutJPWZYnBFITfIS6GdnYgQlkYjSkJBzYZ9t9dNhnntf9P/G8aiYQHD1uxoJMDvAUZ500lbpgGH2zcIhcFHG3dzlwHTluIM9OiMC9uoq5Dbmk1F6L+5l4w1mf7fvyLqw5Tn9KPNW3LXznYY72im2h1Ke5Mvy9VlpzhSmMBTiKoglG6Bm0CjFlMjarlzDp9axLjpRK5WNZxPBxbBNg/cnnW7lfqgZp+WqukcWFqUA+5xlIAF9pYCi57KyROYtq+iIkpq0T+CBlKhNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4qd2PgvYdMUQP4X3/7cOW51TfgvymAZzctxzF85NutQ=;
 b=yQ/W8XX3zzuKc79UStiJhu6jklW4krHP/AiRHleqMeyHw7e62tjO4R0NISgUKd7ZZzv+1cSLHNcodGzFlGA9rXgmCd23Nn2GRuS+HOdaZWBPnk/5DNtyVyBsHtzDQRoGrzDP1S9oWhkgzjz8diOmCEOB8X1Wf5yuBujHCfvmVGY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB6748.namprd10.prod.outlook.com (2603:10b6:208:43c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.18; Tue, 18 Feb
 2025 12:13:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.013; Tue, 18 Feb 2025
 12:13:12 +0000
Message-ID: <11a36fb5-2644-405f-b368-e9a23a6e92c7@oracle.com>
Date: Tue, 18 Feb 2025 12:13:09 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: clear driver private data when retry
 request
To: yebin <yebin@huaweicloud.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: zhangxiaoxu5@huawei.com
References: <20250217021628.2929248-1-yebin@huaweicloud.com>
 <4fe6b94e-41ae-48b4-aa9d-a0712a4ef16e@oracle.com>
 <67B46DBD.7060805@huaweicloud.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <67B46DBD.7060805@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0357.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB6748:EE_
X-MS-Office365-Filtering-Correlation-Id: abd90fd9-27b4-432d-208c-08dd50159d3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWRYWGJKQW1PUkpjNjIrQUdadXNHSUlaOG9WY2drbWVHZThkREpvSEVJNmY4?=
 =?utf-8?B?RHY2UlZoK1ZydnFtTzhSQ2RWUVQ4dTZCcHVPbFdUbVV4OU9NSjc1eE1haFdz?=
 =?utf-8?B?Unc4NFR4ZkpWWnV5Sms3UnBGM1JGM3NTZVFtc1pGY2IrazZtM3ZBVlBqUDd6?=
 =?utf-8?B?Z3dqV3BFK2drV1hEaWpWTWsvQ09uVkoyRW5VREVIYmpZQjRKeGFRaVZIMFlk?=
 =?utf-8?B?TDMzWnRZOE41WUFpeTNQdEF1SmRyUUtmaGRNSGhYWkFsMUVPOTkvc3M5bDQr?=
 =?utf-8?B?K3NzUUwwUW9yK0ZGdzJieE5vK0ZNM2Y2eG9CQWhzNmw0RTFPZFhHR0FGNjZW?=
 =?utf-8?B?akZ5T2JMK1R0RUhKMXBXdkRpUHNsMFh5azlrOWFuei83emlJOUFLc3prdGtp?=
 =?utf-8?B?RE8ycitnWlV4eXUrcGxKOE5QWjhDbUVEKzB0WC9DMFVTdTB1enY3bHVacUsy?=
 =?utf-8?B?Mk1US2dHZjVZcE9MYTZqV0FtNzgyd1hmM2tqaTNYeDlERjk3dEpOc1BHaDcw?=
 =?utf-8?B?Vk15K0tvdlRDaUsxYjVBSUVUWm5mZU80Z2QvL2dudDNRaFUxN21Za0k1N0FK?=
 =?utf-8?B?REVXL0VtNWdsdlpSYXZrSU1acmR0NTVSekNON0EvMEpZSFEzNW1tTGZ1WEEw?=
 =?utf-8?B?TDlMYXllRjltcE84SVYraEc1Z2w1L1FhSXhuajhtencwaUJWVEpFaTRqL0Yz?=
 =?utf-8?B?THpLTU0xZjNORytieGg3QnNFSTIwNlV4ckdqSmRzT1NTSy8zN29WNU9yUHVU?=
 =?utf-8?B?VExtYU0zZG8vVXIvUHRVVzlPL1hWYjQ5R215TWtTTkxRYXNpUWZKSWJZdG1V?=
 =?utf-8?B?MENXZkhuTnB5dktKYmxJUGx2QjVBVE4wa2MrVEZMckVwY01ZblJ2UzFQTGxz?=
 =?utf-8?B?OWw5QWRnOVIrd1VuT3VwMjZYRE5TUUxQN2tFUERsNm5JYXJDTmpMVWVkeVBv?=
 =?utf-8?B?bHA5RzlQTnlIOHFRVnZVVm5YeUt1akMvNG9Fa055Ykk1NzBESExYSjFxMHZZ?=
 =?utf-8?B?VVNkUlQyelZMSFlVc0w5UzZ3TnBzWlpIR2l2UWN6ck1jTkdIeWEvNHFaQjYx?=
 =?utf-8?B?VjhsQXJ2ako3MEVXR0FYeHFHMTBaNU9zWEcyNlpPdFhNbm9jeDg1czh4SUhW?=
 =?utf-8?B?cGJMUHpUY2ptdWlzcGhyRUR0UGJWTXZCZmQzNEZYVkVhYlFkUFF0OTBCWVdK?=
 =?utf-8?B?d0RxdEQreGdLdGhCTHBQQWhqdlhjbnZVWXUxTVBEZTJ5dzBnY000NUtCOWV1?=
 =?utf-8?B?d3dUOGcvZlN1S0h5WmszNWd5NGJSYmRRdVdGQ09IVTlIQk5BczVGcUJ0dnkz?=
 =?utf-8?B?Zno5cjA0RkVacVJyM0pNVnZTeTlZeVQrT2FsNVVpR1kyNU5sVWhXRG1WNG9z?=
 =?utf-8?B?UWRnWlBncU55ck5RREUrTzVJZG9NVi9lbzIrSUNvK2w4bDNGdXZEOExMV0tT?=
 =?utf-8?B?M2xnelFsUmcxQkZaVlhYQ3BFcXhSelorOWM4ZEVTcWVVd1hWWWRvT250NTg1?=
 =?utf-8?B?UmVNYnBqTUptblVQVFlodyt3cEVzQ0N1N1NPeWV3enc5QWF2N0RLeFEycFRm?=
 =?utf-8?B?VU1WSnh2UWF2NU5LYmgycHlLR3NxYWVYR1FIUW1maEVQZUpMSzhPRmp6SDZV?=
 =?utf-8?B?QWVsUkxqZVYxMUpudnRiaTdnYTN5cEozRFJ2bGhqSmVwY3hGMnFxK0l3cEpP?=
 =?utf-8?B?b1ZNU2dXOENsbUlWbTlYakJDMHdQVjdlckVFNnhUTjYyc3oxb3V1aVZiVGha?=
 =?utf-8?B?TnVBcGV6M1FjM0VKK3BtMGpzTUxQWEs4bmNwN2t4UzAxbzJCT0FIV1MySFBV?=
 =?utf-8?B?aTlTYVlXNU80b3lRbjZaanZTTlFrdEZJVUxBQnNtNVFRQXlxbFRMWlVPL3Nt?=
 =?utf-8?Q?RFmlby1M0JB3l?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1NhbVdQTGhqVG1rY1grakJzK1oycG44VktKOUcyN2RoazVyNlhWZWNZY1Za?=
 =?utf-8?B?NFpkTE80M2MwL2owRElXQU5hbHA5VlJlcXpmSVMzbHhSZEZ1T0s4MGl0R04y?=
 =?utf-8?B?Qm5JeXIvcU1QcDlEQ2ZFU1QrSFBQSGY1T2pvVGJ1L2xWRFFJTzhUcDhUOWti?=
 =?utf-8?B?YnZNYndtMnQ3dWNRWWpScmhJdkZLcHg2OUVZdTdxTzAxODNzU2RwaGZ0eEQw?=
 =?utf-8?B?Ky92ckg5SENLelQxU2puWXlwNXZ1c0E0WGpvdHo4K2p5eHcxbVdGZitsYVVo?=
 =?utf-8?B?emNWeWpvbFBvTHhTRmRUWk1mOGdaQk9HZEhHT1g0WnZEbVh3N2FaeWxqQTN2?=
 =?utf-8?B?b3JEbEYwbCtQMW1Nd01wNm9sTzNEMGpHTEQ3OXRPKzRYbVoyN1BMNE1WUHB0?=
 =?utf-8?B?SGpzSlA5eEhxY3NmV3E3TW9jVHJZU1lJTFQydFlDM0tyaFdqMWhhTXVjQnNr?=
 =?utf-8?B?SmU3ZFdlYU54SHhnVnVwTzNwUmVDTU9YQVBEYmJhV2VVeDcyaTFaajdUNlcy?=
 =?utf-8?B?V0M4ckgreGh3RjhLbmw2VzNLcXpJeG10bVZJeThZUEhmSm9OOUk4SldCVTFv?=
 =?utf-8?B?VUtiMlBRMndMV2VjckJSVC9zYkliR3pWeThqOG11T29sNitaU3BGdGRyaEFk?=
 =?utf-8?B?ZzJ0ZjIxM3MwR2YwUENocHE0L0JsSUdaZVArYno3WXZNaW15dm1xbC95eVBV?=
 =?utf-8?B?WENlR1FIU2VkYUJpd09HSFB6Y2FGaGxjQUQwL0t4bmZ1NkxaODlvWGtGQ25Q?=
 =?utf-8?B?U3VjcnBVa1hpd09LSUNsVnI0L0orb011SmxpeTAzUTdOejkxdVZLMFFoL0dr?=
 =?utf-8?B?RnRRcjlzUjM2WWZNQWtySVRtUWp5WlpJMTZnc2d5ZEV3eHFCQ281allNemlv?=
 =?utf-8?B?ZWRia29DaGgrSzV3amZpM0F4RkViaytsNWhKYVlmSzdkMlM5OTVhUSs4NUdu?=
 =?utf-8?B?Z1NZZExMbzVEN3ZwcThmWjNyczBmZHhoWGZHbVROZy9tMHlwbUFGNEkwUnN6?=
 =?utf-8?B?RERUblAvS3I2OWlkSE5saFN3b0lMcFJZUEtyNEtiSndtYTB1UlBucTRhY056?=
 =?utf-8?B?ZzJTSC9ENXBKN2ZmK0t4S0F6ZEYrZVNNdDlzQkFQMk1BU2VLb3EwQlU5YmxP?=
 =?utf-8?B?NkxUS3djcGY5ejZORzJlVktNNW1tSUNFanJyZzN2UXpQSE9zUjZaS2lGT2tG?=
 =?utf-8?B?RnhibFRzZHYxTDZhZjVMbUNldThOcVV5dEdLejh6MldhZE1Gc0tDSlZXbzVT?=
 =?utf-8?B?a2Z2NlQ2SUFhNnZtNHZPL3V4clhMbG0zREZxZ0l1MVZYeXRKZkMyUU9lVWJM?=
 =?utf-8?B?NjlDa3ZMRzI5OWJGcnRHSDFrWVBHWFpuallTRDQyZ1hvRnJQV3NUcVlKMk00?=
 =?utf-8?B?ZXZaKzR4OXd5c3U2MlAxWlZjVGh4cDJ5OVBFaUVkaG9NdStCM081NUJBc2Uy?=
 =?utf-8?B?Y3V3KzhkNzdEUjZwSkdOSTNwK0FjenBYWCtUdEw2a0daSSs3SzhiZ0syM1lQ?=
 =?utf-8?B?R3BTcy9WREpGVnBTSERjUU1WOTU1dkhlVGtGcUxNbk54QXpiNnRCK1I2cFRS?=
 =?utf-8?B?b2JoOTBFNnUyWTRhUlRqMFpRM1hnT05Nb2RWVWRicndFSC8zSDMyZTVpcmpi?=
 =?utf-8?B?azNaMnVMQWRhR0xPNmdkT1JyVjNBcER5Z1FzZ2doYTJiNks5VmJqVmZOYVRW?=
 =?utf-8?B?QjZ4Mm5ZY2J2eFBaR011UW1adE9HY2RYWGtHRFZ0bURkUHN2WFhxMXJLdWZW?=
 =?utf-8?B?OHZUM2FudHVubHA1ZmkyWC9vblJ4QWljYWFFY0xWZ3NVcEVTUyt0cnhYYmJv?=
 =?utf-8?B?ZUVmclJlMlVPSjV6ZFVjMGV0TUJ6eWI3VXFqY1h2N2FUS3NtdUpPZDRJS05F?=
 =?utf-8?B?VDIzLzRHdjFJQlpPZ0U1bXVja2laMFVtQzhWZXRNWVJwQ3d2RWZtalJuSm9a?=
 =?utf-8?B?STQ1RTdJbUkvd2grSGs3Zk9tRXNWbUZPQnZNQWlGbFcvem5mQmlFK2VKdmVE?=
 =?utf-8?B?bm42NG5hZDg4bHlTd2FZdGVxMmpsaEZJRmpSUlhIR2FiUWtRZlcwaUc0VEpJ?=
 =?utf-8?B?ckkvZ3lSamFxdTdjeTkrSGtSVkR0bDlDQjZwV1A3VlB4MnV3aXBlZlltWGF0?=
 =?utf-8?B?OUxjaStKMmFzU3BPcmlaQkNGd3JKdjJIVVJSRjY3Z3VkTXhTRjhnaDVDR2t4?=
 =?utf-8?B?Nmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YFwc4XPF9c4EVupzYNl0cclT81Ql42Xu69If4yARWeUlSmhbhrhJ8cOiBvR2MX/gqvFXZpafzAQ1r2aTB7NA32/PZJRRHYJJ70aHl94/An2V0Pt7b70sfJc1i8tR/OSWOoCau3unYo84duCsPBkwKNEs2AD5B49LpjCZ9HlfqdU+Dj3Lm8hTxL1qpqVlsRXxT2/8ysFKDaXaNWZoPKYiQNbi63wnaV+UQ+a+mFpMZKRJPDcMjKezfU7QP7pNAOjXZQYsRA3+DZ4yLFVYK/9lbdQlJxgTFdfDrWlRap/ImhzGKirfd96BVEO71sTKqWqroW28Le3wl8RgpjqG3Xclc1R4zBjsxvcfWlHOdQjDDmGNNtQnSwvU15Q9LW6s7q4xPSk6tZz4HTuDbZEk1xSQC1bnJD7wDLlbh6RxXHViD8TtfA+/4GDTTic1d1mjfK8JvDFdj7E2FbQWvhZzc6s+ESFIkiVtiYUwDK8epLWQfir9evedta/Yy/R7WkondEnl1QcCXlrbATA+eMwaR48e0leHcIQoQCW1MsaKbBzosbz2tmQybT8I6B6hDSt1NI4drpZe/6prbPIv9LyrRQd9C+VMULP/mt1Sc9Oz7BIGKQU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abd90fd9-27b4-432d-208c-08dd50159d3f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 12:13:12.1453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5tfmv8i6Gw7V3Rrfz21uP5VLQAfrwhtQ2TDpdqA7ITOLsH70hQfuFgv42MLiJO59eh0FYY9zPUK50KWlt61hQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_04,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502180094
X-Proofpoint-ORIG-GUID: yWeA7hZYANDEjlN9cSOTE8X9m9R98kTQ
X-Proofpoint-GUID: yWeA7hZYANDEjlN9cSOTE8X9m9R98kTQ

On 18/02/2025 11:23, yebin wrote:
> 
> 
> On 2025/2/17 17:44, John Garry wrote:
>> On 17/02/2025 02:16, Ye Bin wrote:
>>> From: Ye Bin <yebin10@huawei.com>
>>>
>>> After commit 1bad6c4a57ef
>>> ("scsi: zero per-cmd private driver data for each MQ I/O"),
>>> xen-scsifront/virtio_scsi/snic driver remove code that zeroes
>>> driver-private command data. If request do retry will lead to
>>> driver-private command data remains. Before commit 464a00c9e0ad
>>> ("scsi: core: Kill DRIVER_SENSE") if virtio_scsi do capacity
>>> expansion, first request may return UA then request will do retry,
>>> as driver-private command data remains, request will return UA
>>> again.
>>
>> So are there any drivers which expect this sort of behavior, i.e. keep
>> private data between retries?
> 
> No driver that depends on the last state is found. If yes, the driver
> should provide the init_cmd_priv function to manage private data. In
> this way, the SCSI middle layer ignores the private data of the driver.
> 

TBH, I am not sure on the history here. Maybe Bart or Christoph knows, 
but my impression is still that the priv data is only cleared once in 
the lifetime of the request (from 1bad6c4a) - at prep time - and some 
drivers may rely on that (not be cleared again). Unlikely, though.

>>
>>> As a result, the request keeps retrying, and the request
>>> times out and fails.
>>> So zeroes driver-private command data when request do retry.
>>>
>>> Fixes: f7de50da1479 ("scsi: xen-scsifront: Remove code that zeroes
>>> driver-private command data")
>>> Fixes: c2bb87318baa ("scsi: virtio_scsi: Remove code that zeroes
>>> driver-private command data")
>>> Fixes: c3006a926468 ("scsi: snic: Remove code that zeroes
>>> driver-private command data")
>>> Signed-off-by: Ye Bin <yebin10@huawei.com>
>>
>>> ---
>>
>> Ps: in future, please list the changes per version here
>>
> Thanks for the heads-up.
>>>   drivers/scsi/scsi_lib.c | 14 +++++++-------
>>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index be0890e4e706..f1cfe0bb89b2 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -1669,13 +1669,6 @@ static blk_status_t scsi_prepare_cmd(struct
>>> request *req)
>>>       if (in_flight)
>>>           __set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>>> -    /*
>>> -     * Only clear the driver-private command data if the LLD does not
>>> supply
>>> -     * a function to initialize that data.
>>> -     */
>>> -    if (!shost->hostt->init_cmd_priv)
>>> -        memset(cmd + 1, 0, shost->hostt->cmd_size);
>>> -
>>>       cmd->prot_op = SCSI_PROT_NORMAL;
>>>       if (blk_rq_bytes(req))
>>>           cmd->sc_data_direction = rq_dma_dir(req);
>>> @@ -1842,6 +1835,13 @@ static blk_status_t scsi_queue_rq(struct
>>> blk_mq_hw_ctx *hctx,
>>>       if (!scsi_host_queue_ready(q, shost, sdev, cmd))
>>>           goto out_dec_target_busy;
>>> +    /*
>>> +     * Only clear the driver-private command data if the LLD does not
>>> supply
>>> +     * a function to initialize that data.
>>> +     */
>>> +    if (shost->hostt->cmd_size && !shost->hostt->init_cmd_priv)
>>> +        memset(cmd + 1, 0, shost->hostt->cmd_size);
>>> +
>>>       if (!(req->rq_flags & RQF_DONTPREP)) {
>>>           ret = scsi_prepare_cmd(req);
>>>           if (ret != BLK_STS_OK)
>>
> 
> 

