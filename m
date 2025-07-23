Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72982DC347
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2025 10:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753268286; cv=fail; b=dBLCzrHaWd4S7b+LUaEzzBWQneDf1gKRg7jYJ8XxQm40nk4m41T+q/7l6rSrpA6A0Z74COGJldqE9wfhb/eTYp65MChe7sFlHSmWxGtdLgfkb5vJrpEGn+CzMnFWF5kMhAW1rjPaPDk2zgaJaw67cgm+sI/73+dlheirovyjZEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753268286; c=relaxed/simple;
	bh=nOUnom5X5owN76c7+k1il785eUTM9VH2LjQCfR2h8FI=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ihDhyKELAYMo/ocKbsHwhoM8g01rukAfpBN4WJrpPHPFzYEpgM0MhADLePcmiTFLFyW0e3Y8M5jMbO38B1ZI6xZFRpPvudE5CCU6erwQcPQTRSdrmjDBNsnQ3A03QyUN6vZQrTdoS1FdbAwHov0dDawU/w2pqhZcCTAcs2P7dNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L6Y6lTx6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SH1qskAD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L6Y6lTx6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SH1qskAD"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8NIop032759;
	Wed, 23 Jul 2025 10:58:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XJJqd83C1fDfmexHrMGnIGdsA8gTv2BdgGh+MNXYA4E=; b=
	L6Y6lTx6MKyKPBvp4O+/YoMoxV587PtIcPnKZubovhAARthi3aGY2UZzlso9FY71
	OV5jrILpUGD+viUW7E27SFPNQk3xvzge4maBOfBSpx0i9xoZCQGNhTz0/bdeqY0Z
	yU31DMIopMb18hhb/PUvst+lYppsADyeV9Sxzsco8uaz4eQXtKgXNju8ew7+O/Ow
	zvBZRxBRsvaoxMIwbNsJKVLEFGLjYy2RTm+L701zz8aNV1wfSM+EsIS4cDMZLkk+
	OxmNvEOGSfTknIeNtp86MBju6pcEMbm/X6KBQf4bGWToSIV8s+/uBfFH9AR5Vww8
	36TTCxtZNpgAJ387ctC/iQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48056ef913-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 10:58:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56N9gH4b011419;
	Wed, 23 Jul 2025 10:58:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tadx0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 10:58:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LrahI7jDk6JyQNQahngCBRZOHFHaiR/UXpy1jGQyFGqH95aR4j3CI/L0Df5ITausK3+uAudhf+tqQhunBliP87xaueE8v5yQm8YbGrMkgKeQZ/UQ8o8pL/Aqn1/rt77WuFdW/2UGgZP66uJDzRdl3DvdRhSpuu5mfvqvCyNV+vvWlZrLKbNWDkwIoDPndEwarAOHyeBaG9T+cSOhGVbYpwRCCLKlqAc7qN5AVM2WDSt/nDA3gCriQJRqDz4CH9Y1gML2uRl5ERrJp8SaOYGWBvzXQEFIRTZnaeRwMlsuprgqSrv/z/dELgNpgInTOjWGAIat5zuau9D4jbTlKtneHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJJqd83C1fDfmexHrMGnIGdsA8gTv2BdgGh+MNXYA4E=;
 b=kv3fuljLwPaa6asUBhg3DoaW5fmiHz8/+Icdu7yF2mD7E+PCl6Ln6RIZ1q4Of3RfROoq0yhoyRkO9kl54YbMVQzhzOW1DqUh/33tdwO+K2AgLs1KQbuV6bxYJi5sZapGPZfw2EEv6pnWH/zusnDKmsDVmo3CErDJedUS5z/7igN2rbXIzGT7k8mtviIOv8mgjLfYFy6DRBqdYjVwinTSLcDmILecWUo3n7qtfqvBWBYHcenR/o8vG89TWJIasE128sfo+PLVlNBgEI5GX68TI8bCf+nfZWrBQgJhaoN02VdCyp/VBTqTgbwcZr+LW2XPC46TvMP1BubYwAOj9JxHUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJJqd83C1fDfmexHrMGnIGdsA8gTv2BdgGh+MNXYA4E=;
 b=SH1qskADe4kEOHk8s/ET4XoWvLJs2iWm3BKcJNH42Efz0gnqLt5WfMzYVxu2SNDXj95Kbcey+EZWRXPkkHwUya/JgvebwPhiXamo+4KMjQ2ZHBlHhq7rZ8YFeQRoYytMn6EX/Cf7uDUUKF0SmUsrh4WVjlbZIiZzC9S/PXbRbsM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MN2PR10MB4208.namprd10.prod.outlook.com (2603:10b6:208:1d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 10:57:57 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 10:57:57 +0000
Message-ID: <61a8ad89-14a1-4733-a758-57db84627c76@oracle.com>
Date: Wed, 23 Jul 2025 11:57:55 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] scsi: libsas: Refactor dev_is_sata()
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20250723085143.134333-1-dlemoal@kernel.org>
 <20250723085143.134333-2-dlemoal@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250723085143.134333-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0009.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::14) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MN2PR10MB4208:EE_
X-MS-Office365-Filtering-Correlation-Id: e7fa7d81-6dba-4f8a-a934-08ddc9d7c81e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VXFobk5odGRRUmpodDN6aFZMeE1uTUh0NXBHTGRkSGxNejBlVnFXZGlDTmY3?=
 =?utf-8?B?VWYxSUZGMU5QY3BxKzQ0bzREL28xMDB6Q0VFRDErUE1haFB1ekZTMzVTbk1t?=
 =?utf-8?B?c3g0ejgzbkhuSlIrWFZGOTRJZ09aVlJ0N2dTRkorRDVZUVhuZnBEUWdYaytU?=
 =?utf-8?B?amNiaG9QM0I5QXF0cUZIN1FHRHVzOWwzdk83TVpBTXRyRGRQVWVQeXdRY21o?=
 =?utf-8?B?cTQ3Yks0VFlsbXZta3crYlk0ZXEweGtZUGljUXJNb045YjllM0NkU2J5Qzkw?=
 =?utf-8?B?cDZ6Z3NrTDR6M0JtT2FRbGdMSGxDa0tob2pEeHZzWTZZbFhUUDNxUGh4d2d6?=
 =?utf-8?B?K2tvbStWRmR0QlpYc3pmbFhpUlBZNHRrdjhENFZFbzNWTjNtWGpQc0QwbUlT?=
 =?utf-8?B?Zk1IVFRMZ0JUc2lWUWg3TCs1UXl5WkpxaElROXFSWDQrNTJXYWFOYVY1NHpn?=
 =?utf-8?B?eFEwblRPWjhneGVQTDkxUDBMblNhbjQ4RUdxcXRlbWZqb0EwN1BWTTJBRGY5?=
 =?utf-8?B?UDU2SGVFZXExSVpITDdwZ0lFTnliSHozRXdTU3RxSWZ0b2YybldEQytXem5K?=
 =?utf-8?B?bXNWYjRSQUFhOXlCU2VNalVmc0p0YXZaaGxzcDRHenk3cnNLaTlOQUxmTXdC?=
 =?utf-8?B?MXZYTW5sVzJoU29TZ0NZOTU1QzdNU29Tc0ZYUjJBWTBPTlFLNTJZcFNCMFor?=
 =?utf-8?B?V0UwQm05WmtWRkpkVmxSZkdNQTZDQ1RPSi9PQnVDZXYxZTlUWGlFekg0WGkz?=
 =?utf-8?B?TWtaT2MvMUFjeEljTmRBSll6WlhPZUFxY1k3Z0FYM2JqVlVXUWFOb1ExdHEz?=
 =?utf-8?B?RXZlQTRiaGVHTlNWYjFYV0tHUWF6d0o5eWl1OUgzQ2JjNUdWRHFGWnZJZnlN?=
 =?utf-8?B?dXV2UU5CU1hWN21ZQ3hkaEpUMzU4UlR0TnYyQzZBVGIzdjRxVHJXbzJaNXNq?=
 =?utf-8?B?dnZac0VqUnlYZXZtU3Flc2w4dGEzTU5xQ0ZPQ0NTV3p6Y2RDc2tBY0dPMU5Z?=
 =?utf-8?B?Nk16Umt6RXp1TmI1ZEkrMjVxTTAzRVN3dDdEdWRQMEZBOHgyeFpLN0FPNzZP?=
 =?utf-8?B?N0VtdGl1UnZNY1dqdk1UT2NjRGx5eHpaQm5acjFRdmlzYnZvdkk5V1grRzQr?=
 =?utf-8?B?N3Q0WXJJRHlJVnB0RnlzOXVsQUhuSng3cGJxeVNhTVM5bzBvSDdoblFnViti?=
 =?utf-8?B?VnltVm4ydXVwY2p0NTVhelhWTDE0M1c2WjBYNXIyUW5QVGJkUW9oNEJiWURq?=
 =?utf-8?B?QldmYytlcDg1dzY2ME9pZ2FWa3laN2dxRHA4LzArdG9UdDVNUUcxTEd2N3Jm?=
 =?utf-8?B?UXJSbFJjR2lFQUxhQVluYzBGWmpaRGZUYnhQVkVyRnVpaExlaEt2cWtXSi9Q?=
 =?utf-8?B?M1VkenlDZHdkK2gvN3VTR0lzS0tyenQxMVN0eVpFM2RXakdJV0dhNjNnY1JU?=
 =?utf-8?B?NmhuMHQ4by9qdVByb01kay9EZ0hWUG9xVUZyOEwyUHNISk5hZnBYNnY4Szl5?=
 =?utf-8?B?aEY4Q3ZpQ1YzNHR1NHpOWXdQbmRSTVQ0MHBUaUFCc01tMjRLbDNEWjhBSW5B?=
 =?utf-8?B?Si9DSlhOdGxnYlJ0NHpzV0xZTkxtelNma0ZMT3l2NGo1UVkvaE1uWHZ0L3B4?=
 =?utf-8?B?RTZ0ZGV6ZFNqVExRMTBralBFdFpSakVDNDZ4cEpaMG9XbUVCQzR5VElQY05k?=
 =?utf-8?B?Vmc3S20vd01vYW9GczN0VjBObE04cW9hYkltc1Y2M3htdEVxbGxPNjVPOTBW?=
 =?utf-8?B?RXRrZjhkaUtyRFVhZXo0VHUvQmNCR1hTb0pGcU5vSXRnSkVYSjJVQlRlRjB6?=
 =?utf-8?B?T040NHhubGR2WGxGSEYwVDFhUllWOUl1Uk9NNEczWnh1VTRvRjN4QlpMcVFt?=
 =?utf-8?B?N0h5Vk93dGpsNlQxSEZoTUFMRkhyajNhRFJBNUdXTVUyaEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTYrQ3h2MEMya0FsM1ZOQjUwVlVyV0sxTDdGS09zSDNYSnRWR2hxRnBHSHlV?=
 =?utf-8?B?S3kxL3RuQkVyMjI3Q3M0MHh1aXNJQ1JPQW5Tbkxkdnk5ekZSU1c4VXE0NFI1?=
 =?utf-8?B?dTlFN2hNUE45U2hhcnFET2oyQWUwdC80Um1yZE12ZWZRS1M0RXFzRlBZcURw?=
 =?utf-8?B?S0k1dWJ3a2lOazhHbVF4WXUyTkEwVGVLR2pGTWFtYjc1Tmx1dlNHK2VadU52?=
 =?utf-8?B?bEdsUktoT3hWSlpRaGVmeWx0Unlldmw3UUZUZzV4VFlhWTZ3TXBCbFNSQXJa?=
 =?utf-8?B?R2VNMDVxK1JlODZzYjZ5L0IwNThZamllWitWWlJzb1p1U3krU01UandRSXRo?=
 =?utf-8?B?QkRZYzJVbW1mREh4NjZJaE0wUS9BSVpQUEdoSk9DdUE3WjVRTkdadHNlTUho?=
 =?utf-8?B?aGNPcncxUzZXc2UrNnh3elBORU9sNU50QjFNTWJrdEtGUTZwbTBiN1hxMGc4?=
 =?utf-8?B?NFo1ZENZNHhQUkF1eHhrZTZmZXlmcFUzOEtDOXZpUHpNb0lIOHlMMmxQUHJD?=
 =?utf-8?B?MVRMWnVqVDMxMVJ2eE5vN0QzeDl2c25FdjVEeDduUVlXcDRCbUplU3dPeTRk?=
 =?utf-8?B?TU5LOUl0U3VXTCtoQUh3UUxWeTR0RDlkY1dPbUlGRldwanMrZjkrTkpvUzc0?=
 =?utf-8?B?NGJVNVF6bEUrc1d5K0xJem5CTHBOc0NBMEhWa1hQNndtUEwya2E3MmdFYmh1?=
 =?utf-8?B?R0NZYU9RV1Z2OTVuc3RVVVU2S0lIWUJ2U2tZT2ZobGNWc0NXQXlTZHNIZHhL?=
 =?utf-8?B?MVJKQUN3Sk0vU2VwUng5dHdPY2R0VndPdVVTeVJBNVNKNFhqTllicXovd2sw?=
 =?utf-8?B?R25BallLWE5oYjg0Vjk0SU4xZmRyZnlEWG0rNHRsN2g5M3pNVVNyNm1uY1da?=
 =?utf-8?B?WEhJZDY2Q29LV21CYnVlaWNvekdTTHZnWVYrb2piTDF3aWdtcmJWek5jWit0?=
 =?utf-8?B?Smh5Q3ZvVWlycEtYVzZ5RmFSNElyb2phMEw3Y1VIN1BRdVJWcFh6SGVaZHNL?=
 =?utf-8?B?b0pMbGxpRHBLNTlDMWxubHpmNGt0Z29ERHJXS3g4VmxXRWUwaWhkTkUrTjFQ?=
 =?utf-8?B?cmNuOHhmdXVEdlZhaSs0Vmw1SjE5SUhTb2wrbXk1SHczSDBVODJSeUgzTHNR?=
 =?utf-8?B?YU5SYk9jQnVjQWZJZHIxaHB4WXphVmFBcEJiQjN1UmtYSmpXdUxxL29WVjF0?=
 =?utf-8?B?TlovWHdRU1NGYlloQVZEdDRnT2dkYWU0eGZNVkR0VlVpUE52VnE0UmRranJX?=
 =?utf-8?B?T054RGVoWWc5QjZFRmRGcE5vSjY4ZXpoaWQ3dUVqUTRlZHhPeHY1akhwR0tL?=
 =?utf-8?B?QkdKcEttM3F6aTdlTlNVeHRwZjlGcXdjNnBEd0NLb1N4a0poWktwNmw0b3lz?=
 =?utf-8?B?TksyOVJBaE50bHpORWNmb05JTTRacWN5bThGRmlWbnBheE1lUUVxVHlHKytn?=
 =?utf-8?B?aU5leEY5Z1pkTjRvdFRLS3ZGcTlKbUduc1g2WndwaDN5bHdlcFhBQXJtUFNX?=
 =?utf-8?B?eHR0ZjdhUUw2UlNLMmxRYUJUV3EvN1dWYWRZV1plY1FQMWdrRUhWVnVlUDlj?=
 =?utf-8?B?MG4wSzNrS3ZhaCtjN3hWbCtLYnJEdzdZdXVKOGI2ZDNBL3RHMEFXWVNETkZT?=
 =?utf-8?B?aHZFWGYzWDkydklRNVNqQVZlQzJ0UURJS0EvTXJXK2pQTmdSb2J6SGVDbmdr?=
 =?utf-8?B?eGp6cG15THNnYUZ6eXZ2Y0Z3eVJ4MXE2VTN0QWJ0clBQcUo2dWxia0UzekRl?=
 =?utf-8?B?K3JocFdzTUlmd05SM0NoL2d0MUd2UU9nME1OWVIwMHlYY1VPd3FEbkVmYzVK?=
 =?utf-8?B?cXlYRmFlOXR4OEp3OUVreW42TnJ2Vm9WaFJxWDFEL29KSkxCZ2xNeWh3Uytl?=
 =?utf-8?B?TVEvRlZCOWRpVENNMXMwalZVeDZGcktHMm4vOU01OU5TZXdPU1dTeUVOVUVJ?=
 =?utf-8?B?Q1Z3UEI3RGY0YUpLSDJ2bk9zcFdLcjdIbDBEUUE0TFhrNHlWTnk4ZmsxZU80?=
 =?utf-8?B?Z053a2pxY2xoSmxod1lxWHVpN2tlM0gzT3Zidzk3NzU0ejlyTDdFQjlqWWJ6?=
 =?utf-8?B?UVBmRk1WRENJNWVjbHhmWFBVK3RWaU5SbFowVnNPOFhjVzR4dTdaeXdSalY4?=
 =?utf-8?B?WFFWeVFYWWFKTEVnYXR1Q0NSOFFYUm5wb1pHTEJPVWtaMEgwbjNSMW44dThF?=
 =?utf-8?B?d1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o1nUevn1WRhgPXzFCjWmLBSMCTKDXO8TjQMeSbuXXXk7i8N1FZkaYuMqa9fdoJRaUL0IrPu1lYo5XDTlevwy9zSLH9ViEa5yWPnozyVQz6zB/H1AH9WhAPg9hT3CLzxFHqAjHsq+KVuQzfQDtR+N2OEJPRNKGvizRFgvTbd3hZ7rXtPT2oIrqGyBR4G1aw4cl3GlJkS3oJKtUJuq2INjDKxUuFs3o5zWeQfVlWFwycOpTp2TieS65H21p16832Cuh7mgXR6tJshyijSws12/AtIjk4vxXzi1hfag0ChXsvr16DKdI74CBjI6xywQPeS51uBOJDzmS/XM2tvp/d5plv/nhvPtDZJYmcx9o1wx+MzW7EJNscDkHegZ7Wt4UgV+RzeaCUHv1TKltmTuVspYkifFSnuNEgfMh5KkFS1NCPI1FWqHjSnEzON5GwU7yXGjpUfw68//fIaid3tg3JA1mYbWWjtTjVtOAW27nXNFgf/APHNBcrEiF8sHGOzIwVEUYXxJWx/JRR5usKJlJyfGUqCJbhEbAtkxX0oR4hAjaG0aECTawCK8vquwuN6iQ1Rm/cJveBJQQuXfgWWWURPbf2ilXHCyEAdnxUZpdNl61ck=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7fa7d81-6dba-4f8a-a934-08ddc9d7c81e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 10:57:57.6050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t17VRWvEyBI/fRfadaZ+T/rezHGFJqOnTarIYbcEUWejKjF5xQhU5O6Iv13TjupOlp/fG6yFp3Ran2UOlISU8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4208
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507230092
X-Proofpoint-ORIG-GUID: Htcqrb-gmpNdEOmTF9Z0VxDd6ut3D1A1
X-Proofpoint-GUID: Htcqrb-gmpNdEOmTF9Z0VxDd6ut3D1A1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDA5MyBTYWx0ZWRfX/2X4EIoijAsD
 an8sbn61XqK2D7nZ/ld9ey3oworEUnq/tdomCubs/5IyguNuMbvw/Hea/zoUGAvKOYsxcM15VlH
 lqltChJoTiqgzmHpsi8bj6tP0e/b0tHf5Ue8LnTY80saQ76VRzOgjEFKEZWCiqCPG8mkFftoWRQ
 cQJz39fbNW591fB28V5gfT29S4TxX0PxDgMN07Kodh/YctYDtMQLflQbMYQwggcX5B71i0LaK4T
 AcYjPUAK9K1tW/rNe3dPevVoHJ0xZVOra27FBZPUfLYkOiO8qS+J9uaZQuUoMPhlHxXFNRqWKLU
 K9E3L+szwP4DJi1cxhAVmFSpukn3EEVjQOVfDvoP4TxhD1Tf0+hEP65Y9Aiuihr//7RJUvDw+u/
 +8LDeQaSqZ9WTFsuYYK1ixQne+Wq+KQo9ub3bdQRi2S2+C0ieTv1eteFAKPt2Om8LL0p5mZ7
X-Authority-Analysis: v=2.4 cv=Ef3IQOmC c=1 sm=1 tr=0 ts=6880c039 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=qPJfHBQAzEFGUOg2e-8A:9 a=QEXdDO2ut3YA:10

On 23/07/2025 09:51, Damien Le Moal wrote:
> Use a switch statement in dev_is_sata() to make the code more readable
> (and probably slightly better than a series of or conditions). Also have
> this inline function return a boolean instead of an integer.
> 
> No functional changes.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
