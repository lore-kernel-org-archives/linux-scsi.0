Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4064429036
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2026 11:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786447403; cv=fail; b=Va8k3i97NIRGHFdVEj0UPoZmAZn9rlXuZaq8ayMlYBHwcrPMsu2bT7zI5iZwIXu9RaJ13h+SQLfLSvdhmosvgboYmkYQQy8oqN1rCVyNz05eHhT4Ojy36NFDhyKq3QH3dyJoeu+2c6e+ZojToMnCBDtwM7jSbPKUVqx8m76FH3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786447403; c=relaxed/simple;
	bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JgEBNQDoTwTp1J1iKXbN7AF8G6lUOU9L+Mg7aqJfNxzqF2dIPfgSUQC7Ua4g3lRcIQ82vXRbGPAJ5x2XUkGpV3FgYcbKPwZANT+l8zy+bj3KgVoZ2oLHL0j8lb1aiyEHYyrgy53Bv5/kRPX78MV/9r2phmTyCIkLY6z+0YgBgc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ni0tkhGe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0OVol9a7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ni0tkhGe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0OVol9a7"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67B9MohN1964670;
	Tue, 11 Aug 2026 11:22:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=; b=
	Ni0tkhGeSED5RiP57xnsLRZ0RN9VNjeGywAKsmIhqdqFHesQbSrlTVmPwY2i2YkG
	RRYUAbfXO03wzKNfSH8JTyok++4SgqVa+kIE6o5//tgl7Kld1W66+IOxq766Lglc
	TWpTTWQp2dey7d2ezLMJuB7DdH2K/Po4n8eD9VUxuL948pD2r+eYeZRKK10ZPemA
	66tpK6R0xLKJzbONI5NsofmA+i82h307t9Dc4j8TskWkyDAOH2V3BZgQvoLBJ2Bm
	RH0nlFJocOeq9aKtM1SW4B9Tv0Tf265cOf9JOLrCMFA8sFE+9DFjLfhM9JHZhxRx
	/bwWx2WSCjquT1Ag8tsTWw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fww0svmnf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Aug 2026 11:22:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67BBKUOm001289;
	Tue, 11 Aug 2026 11:21:59 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012006.outbound.protection.outlook.com [52.101.53.6])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwrd63r-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 11 Aug 2026 11:21:58 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bsQYa3Ij082MZXwXMpbTbBU6Hf/ZSa5gGYy7Ddup2dztoJH18C3QVeD8b2lbkoFCAhkmX0ku0xGJMv8TamF7sHLKn+PfSZNyIJi/2Y1iT8Jhem5XJ8hPXoIFziH9981m+frPoHFLMm0y6aZYVGiYWWDIq/4/5W9T/XSVmpdRZkKjoCSaa5QtLNEjhfnre6LJjr01WA4txmFrIBDM8LWJvOEt8k09gUGREYi/OyU5UYQBr0FHPWbDaRWHFhPwZry/uEd2XCD9mWeWeX+EHpE2GMa54JjDyuRP1NAYVNnjr8sfVqMA47aqAm3YbjtGDK/ebWMjMrStwPjNXXBuQelsUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=ja3OII/n7vprXCgaB1RQaspgv5H8oVg2Q7Z69wscF9GCnAV2AEIzwZ5e3VQS5fqkHF+pmwHS6Qld62B8oHxYMjdhaB+FehBloZTe580pwBjOMhsk6jKoZ5eq7/4qE5aIUOt1rui3icgjLcGG7eNJ1WrFkwxuXmdVFJ9qXq+UFvcqByqIsYCUtuiOK7ictkS18IXIz9QUDroaryxAtfzu+hKs0ZFRuIMpznNje2hExAPClRuet6hhdyqCf8Hz49m1YfM9hEcJBMDoDzDwDO5xX69H5SgCYMeYlRgkr5nw43pnnSSIAMmfg5fNGZyjZiY3DEymvA0udw5nlnudAw8xTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qM5Dmvsup6HfE2E+4Ybaolxv9ELbKUztVFF/r9DRtz0=;
 b=0OVol9a7hdwk/LZKkt5LqgBZuYQQWsf2ZCcO6mk5lw4l2Az1A+vWFqn8vSVDTrbRLN3ePmF7IuevacmS/6kseCtawJNhKeeIvb5BttrQ4ryTkMBru3+iHsWIRLLUxWD4tKVUeOdsEnDOkgu4TxRez37rXLxboXBfpXBjh7aX0Eo=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 IA4PR10MB8303.namprd10.prod.outlook.com (2603:10b6:208:567::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.12; Tue, 11 Aug 2026 11:21:56 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.024; Tue, 11 Aug 2026
 11:21:55 +0000
Message-ID: <b0e3b801-1614-4d51-b70b-a377ea48e735@oracle.com>
Date: Tue, 11 Aug 2026 12:21:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/6] scsi: core: Protect host state changes with the
 host lock
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        Jianzhou Zhao <luckd0g@163.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Dongdong Hao <doubled@leap-io-kernel.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Nilesh Javali
 <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
References: <cover.1786142946.git.bvanassche@acm.org>
 <681e4a5260c182feb5fc1d96f0d43c62c21dc6c9.1786142946.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <681e4a5260c182feb5fc1d96f0d43c62c21dc6c9.1786142946.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0206.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|IA4PR10MB8303:EE_
X-MS-Office365-Filtering-Correlation-Id: cf013dfd-7599-4617-fd75-08def79ac036
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|22082099003|18002099003|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
 0Hx1/3M8lgPtZ4i6no07wN6hVY1pKa3k4mSspBaqs3JeoYzxMe7F3ZVIcL5yv0oMVvgznK6TFvmVPPXII+hxIqweFbTDdyplEi89UAh/HlssbXpWQm/PcexlPXf1iVJT4K3ve94+HZA8Zn21n7oeTgedMmJdXkdP228/7guS+7Gt0W59vWiAcMGYxINPgcvCB2g6oNiR4LP5KGK90tAvO21vqlCUVvPy9Anl+79ADLOGkYfr68mLKBRRr26zcWNvA+oUiP2kCoM8U8dYtus6an98H9yJlm/tJ/XfcfvlkOwY0jVa8FGYK1nBnQvEQ1QoG9A3po5s2osaUGow1JlnQocGuNzXCdRqMaAn/LVlUJNAcGiKoqSUHKTNcrmbGPtM+r7pEJI7oE0y6PTFNo+HHl5cHDZiHsYzWwcy1B67McpKAIgNcH3FgjhbStVTGxymjMtdLa8+6LdEfOdn9A2eb5Mpub0N+a+6qbYpBAKTDo6oZ0McdnH8U876IDPkATxJOge7XOTOYVONbwVEjGUC+W/m+ciAgyZNZqpJqPIwrnCbpQwehy9tjhCpFPmhKpvWaFbkGYRQUiNZrQhMIesJYKbat2MNb3guHy8bwQ33zz16i7XIz1z/+IQ7ZvqYs4CA4FS++w6NpTKNX92qE74TxSqEywh3CW8Q2nhomNWzHZw=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?WUNzQ1JxeW9LRi9YMVR1cGErWmZ0VDBUK2pmbHc4SExCMUFnYzkwL3gwdkFB?=
 =?utf-8?B?c0FCK2ROcllFbEdSaVRzUmtBTi9LU3ZPM1VtalRjYkdRNGp2b0xJUXJIdnZx?=
 =?utf-8?B?bDhKMTZrNDBqTmtDVHRuekJXRlVrY20rdzVPOUJXeWw2WjRCU2pUWE1zYkVZ?=
 =?utf-8?B?b0ZMcllMWEM5azk0dzE1YUx2UHROcmRlZGFac09waThhcmpwdzltTmJQN2hV?=
 =?utf-8?B?S09zVm1VbzZaZVlxakdpdE5SampzaUMwbjhhK1FWR1B0SThYL2xrclA5aHNx?=
 =?utf-8?B?c0U3bzFLelZPM2pzUVdFUDNSWDh0V2FsSTlpcnBmaXJITVJ4WCtBejZEV05Z?=
 =?utf-8?B?WjF4UG1KUjUzQnRWK3k0cUs2UTdkT2ZLQXo2aUVhdWNabURiL3BueHg1N2F3?=
 =?utf-8?B?VGM5dXN6SnhBR3l4RThOSXhrYlRvV2hmc1dFZ205dmZlbkZnWGhtWVFoczVS?=
 =?utf-8?B?WDllbVNyMlZCUk1HZFZaOHIwWWc5di9LNFdXL1A3K3k0cTBSR3FMMEluM2ty?=
 =?utf-8?B?ZHJIb2NGZHFoOHpCL09rRU55VUJCRWxwME9sUGpTSkJlY3hucW1IUDhqREZ6?=
 =?utf-8?B?UHFxSSt1U2VnakhGenA0c3ZsS05xdjduVUswUEsvd2JlQS81ZXpHSDBuUkRE?=
 =?utf-8?B?YVRwSldXeWlVV25tUEc4VmpyNWQramVnUkkwbTd6b2VFQURJVnU5cHNDTktN?=
 =?utf-8?B?akM1MHpOd040anhrV2VQZmV0cGs1b3MrNU90UlBacHhTYTkwR2s0ajRFaUs1?=
 =?utf-8?B?NWNVbzNkL0xzYTRTNHZESWJhZERqZTJxQ2d6YUxzbXg3TjRaZEpUdm9YZU5N?=
 =?utf-8?B?dG9ZMWJ0cEMvZmgzTE5MSzFIUVFpdXhuMTQ4Y2FoRnQwa2JTVG11RDFCaGVH?=
 =?utf-8?B?SWpzV2ZNbE5XVzZuSVFlQ2dJVEpoWDFMeUMwU3ROcUlkK215RXFibThBZytF?=
 =?utf-8?B?Z1NDLzM4SkNtcGlqMVhLTE9STjF6RmcwZy9OUDFpYStEaXIwckRPZy83VE81?=
 =?utf-8?B?RkpNVVA4aC9kZExKd2lxRDFQT3VjQUp6RXNTL2Y4WDByWFBQbEQ5YVNwSHdk?=
 =?utf-8?B?RWZwTVptNC9PQ2x3TzNrcXFyTGc5VUNqZ3Bwb25SdldyOEt0Nm1nbExacE1v?=
 =?utf-8?B?YnNzdENDbkZta01EeWdLYmZyQi96M1ZYWGhXN0E4R25POWVaUTJXSUJZenJR?=
 =?utf-8?B?UTFHTGJlbU85MUxLUUVTV1V0OE5DNVhNeEJMS01rOVhWVWtQYmRJVDErSC91?=
 =?utf-8?B?TnNnbkpBUUIrbE91YloybE9FQmJ3aXlnMGltZVhhS2R0eFRFUmZWeEp5akRZ?=
 =?utf-8?B?aHVGS3laVkFxV3JiQVRmZ1o5Ukhudk1vaVR2MDQvV01ueThhRTJtQ3pBeVRT?=
 =?utf-8?B?T0VSaEdzaHgxa0RXZlZ4bko2MXptQW1tVGNrS3NlczBSejN6aXJKL296NTZM?=
 =?utf-8?B?QVJwbTB1ZC9YOUwxSTdRQkhLNjJLdHl1YmhOSDRQNnNLSFlrdVpYSno5Nlc0?=
 =?utf-8?B?em5RY0hmNldsc0lyVkQ4cURCdm82am1tL3NaLzZkR2xuNndxNzRCWGg3VE1s?=
 =?utf-8?B?ZGNMWWY3RHdQUlRteHgxZGJhc3dlU0RNenAxVW8xNVZBa0FFNFhNZStRTFBI?=
 =?utf-8?B?cWF5eDdxK0UyQU4vMHZGeWF5WXJpVXBFKys2alUxOEFKTENKelI3a0lVbHJN?=
 =?utf-8?B?SkVTYnlXVVZDQlcxUU5SM0RRczVzV0MwVkFlREhHc00yZmFCc2ROSWRJazh0?=
 =?utf-8?B?OUNKeXFJbWcyd01XSXV6aEdHRlJMQnhyYytWTFJTVTJIWjNKSDNCanRnMU84?=
 =?utf-8?B?VU51UlZORlRDYW5hcnVDZFpSdVNYWEVwRGNzb1JuUXoxL1ZSbXBZYnpkQys2?=
 =?utf-8?B?UlNDcjZSSWV4cTlsclNkaCs1SmdudnJsdkFkMGdlaURkV2hsUnIvanJEQytk?=
 =?utf-8?B?TEUvdHlxQVZROFlCUEFaNDZLeGk1V1FPclNUTmxKbGtnUmNrYjdaaWtZRkxx?=
 =?utf-8?B?alBQKzFoOWMzd290cUxKVDlJeWgzaFp0NlhPTDRpR05oYjh4L3BsOVJjc3g1?=
 =?utf-8?B?alJ5RU5ucEEzTE5hNmRZSDVYdVM3eXIxM2UzWVFIcnMxWVpJdVI5WnMraTUv?=
 =?utf-8?B?dWxackxMZHIyYU5NY3J0RWJiNkhWTlM1YnRHZldOdjV5TEFBRDFXN3BTK25H?=
 =?utf-8?B?UW5iNWFxVjB4MlVIa0pXYld1cVdJc0NyemEwVmRTdkJNSVZqQ3JOUVIza1Bz?=
 =?utf-8?B?aDF5YmhBVlU3cG5ERGhkaStSVHVFd2hWQjZOMCszaEhUaGNhc3A2RmIvYmYy?=
 =?utf-8?B?c3NBb2FobGNHOGt3VU42Tmo3b3dFaU92RUlNNHVpUXVrUWIwTFFxdkdzdlBt?=
 =?utf-8?Q?ctsiPWk6xCe3Rumw=3D?=
X-Exchange-RoutingPolicyChecked:
	IkoSQmShwWxP/JVp69Bl58/s9ep24+CVwmqxpSjMLN1fBfigx6zuP8iZnbmPrwhcNEKal3QDoxv10+JvqBfjXJKhQNk9/xKwtmFLSNRkK/P7SmH2xd+Igr0eFd780hXlMWIs9bmWjGLm4uLKSDXaxbHuCdMHuKtgg2mzsVbYL2/q4ltLGm3tR2N/wbRqqxClu/hUqr1Pfb1P19+WvRA0UShZ8YsWqNrk2VeNjkTAvH+89D8W8+sAROW4Acrp84q2geNR18K6SliZyUZNCZgjUC5E/aK6P+IPP0VPr470tuLCGOjKTI3Kx/6LFHHxREuQUS9UmJ52ZTsw+6orVdLYyA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T0cuWd3sD9uy0aMh3lLwpLd0UfpaqBhHDI1gVOlyY/IVEIwtDYS2z4rMiDQvhsuyDQqo3FCD8zzvM9S/uka1zpaPVlKFP94EC23vGIdRNyDQJTS6lBzcGFP0t9aYnJV4/N/xYxK/Kfyi5TEQ2Hd1fcsXEJWAbQDjX9WjuG2nmSg/bNrxej64FmAt0JpEWo6nrjyiWEDjVnd21AcqZl16wFyFBQ/TIa+yr9EH5SHFcm5+dy8ttOHHw2WXuQukTMI9U1mBytVSM8SYPcrihoX7pARa7uX3uEiRAWpBHqLGxqA+cCPjbe/JmNGKHz1A/+KUlXHNNkJ6BZFrU/ZD4EhoIHacXsnd5TL0roFvok1NjgJMtUBsnu3FQBd551hIbJmA9YX/0GUus9k5TfXiIA41ANHkVIOzgeaEao6VZiDoSLQBvldK/gmxMpWin4JjqrsT0xLX9Ckoa0DUr6o9UenN4Jee5Ruxrs6Pyk1ZbOuehrR875wccUstYpY78BAoDg/greM/Y6wVtHpvu7emgs/4X2uY+Ukf7dJANab++GFpNN5R1/p9GrRHGhxRfOnyMwQ6r+lTL1zPw43u0mxSRFkQZPxhd0KSn4LHmvGpiCiThp4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf013dfd-7599-4617-fd75-08def79ac036
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 11:21:55.8352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oLdG9qDnxLp8z7zMmaOWWyBFCOtQvwK5dVGb/Jv9cbLa2Bqi/po2AJgDV2A1s/VYS+poSR37kWtNihURRZFAXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8303
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-11_01,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608110094
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDA5NCBTYWx0ZWRfXydyPgpKsYrdC
 IdPfwvzy2EziGyFVt5rL86feA38xjtG9kHTyR14DfDemYsZXDeQ6pCecqZQ+0Lw6kb5I4j9GHDM
 CAQiKk69tNO694gQ9qEFbImgGliVoVGXxXHyuAaMn0VI4GKVEZ1L
X-Proofpoint-ORIG-GUID: an6HtND08Y96satSa-ggWCOqlfhr9aY9
X-Proofpoint-GUID: an6HtND08Y96satSa-ggWCOqlfhr9aY9
X-Authority-Analysis: v=2.4 cv=FcAHAp+6 c=1 sm=1 tr=0 ts=6a7b05d8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8
 a=YwXNSyxGt--lyTdxN8QA:9 a=QEXdDO2ut3YA:10 a=6pWzAbgKvXYA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13509
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDA5NCBTYWx0ZWRfX4h86gGwAWjTI
 ShO6rFLwJD9JL629O02rmCcVWdm50CLwhmMai0lOIlh+7s57LoHfE3ww0S/ANih4dgWIf0nojXn
 GzHoPPtTDdOa2LzXm9/MPgpYSBi1ea1XeKii6FMvS14gOxbRmLNS9rbk/6OxaE56rMVIiRCpSX0
 4dyjOcwc4JHJ/kzKXUXjiRu5pD0R5cea0xkQ+ctrllqCjO/7jHer4EUjGBrmQ6ztsJ1OQ7l+MOs
 NA1So58rX3ccyNAR8A0QPevySdwHrKPTUA3CNDYjx55HbeWRyI1II9jJy2++gubnFQcbH8R+/ku
 xONX5b5hIdAuEE2jTJJ3puM3qgBMhcLB3VmyhhoffR4DVhixremJRLkOX7tpv82nZVeck+uPGXq
 +OMZ8gakiB/Lg5nqeHFp9v8RV6vEraK4g2Av3AKnoHuucsJ8cESMe7G/hyIpjHYMdNgCOnnXOlL
 SGg9F9bRyCnHMd+o0+0J/nIRiVgwS/0qj0dOUjhY=

Reviewed-by: John Garry <john.g.garry@oracle.com>
