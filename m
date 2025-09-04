Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A7F2264B1
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 08:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756975817; cv=fail; b=pnE357XPby4bUy78JNoQGXAEfKXqTDp2JLHS5tn+x2nIyecBzCMcQhbgYKeDcxVPCPxmLFw7jfC9xUO3j+iUm74vZARvzrXXV7hjopothRs54BLjJtxYuNfKcIUQ5wqmor7aYZrAz6MyBJH+1+GJqQe72jDs1Lb9iEcMoU1RqiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756975817; c=relaxed/simple;
	bh=G5chPoFYT5BMYnrBMQShenRFafJrvBA/qbhT1jHKuZQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uHpTfpDhqA+IQfpZIAP9SQqBX7tPoYiLFC7K/QB9WsW6IPQI7XGuaJlCN+vXkInnaZb6xGJ0J8LMLwBME14yHAWUmTCToAAuAcattXXVJEvmU//LRv8SFksv3Q4xtkHLvWkeVGVYieW4D6zwAWwFgvTo2PEL0ZFdZ5s6LYJPyyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=saCdEWXa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jEp81kwT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="saCdEWXa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jEp81kwT"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5847OvjF031885;
	Thu, 4 Sep 2025 08:50:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nbhcpmpBTu1UhFNuLRiz55gg7wJYWcLifsHFykvE8oA=; b=
	saCdEWXaUJmXhyF8kSegpuUkooYEvKKfa1Sd2tCNGei8jEH6SYxs0ZpRedbGpwUS
	OLxs5qPIaoDMyqgvQbE954xMb2UHUDSQH1WVhHqdEKt6ILebxeNndr4mXiAg6DhP
	HlKRnKbhHSmaLbWGX8BnvBWk9wFlluRWmqLjVBeIiLMQAIM2gIMmoXjVZdDBNUMs
	lmTdnxdRKGe3pcOFRDdr1CalJO2kF+GCqahkIetiZdGSF/K0pgCiukpIok9QPCVc
	KwPqX9cmeYfYYIz/7F0B6eoKAR3bWlazn5oWpQ+Id6BfI6narwAej+9FbWu9079t
	4j7jhI1++3VCXxVpVUu3ZA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48y6brg56x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 08:50:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5848L3Il030931;
	Thu, 4 Sep 2025 08:50:00 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbdxad-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 08:50:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d3S+nnBvk158nkmMo7t1pQ8L+pOkJJOYnoU77cT+J5qqlAlFHC0f8u+WwDNutfhvhR3OBGvj1INE4w9zAtHaBF6tBbZT6sm+QGEqgL/fHYGsIuJp3mC9Rc72IADQQttwnJZWiHYxRplKIgr7F0Y/aZ0bk7cVf+KXmKBOpjUvJMsp4IBXPwf7FJe84+cs0TQHcyMCoQx2YAg9KgJTJLYkBQR49pCr8It+xPAuJ57NE1Mhe9LjpQy/Obhr7UmaFiXbhWWcGy8M7i0EYk2uJ2dbedAZlRovMmEDKBGPUd/580OWevcq9sE2HSbe8LgsKh/REIH+edwIiTt31l+kPoqDQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbhcpmpBTu1UhFNuLRiz55gg7wJYWcLifsHFykvE8oA=;
 b=rY/JotMlTkT9/cZqQUD3OroalA/VtazNaXI0OUwpYROAgk4YS8EvQMtsivWcsOEN6IBgrsG5TC5j5mfTSTHC6muLJTv/0a7z35Wj1nSyNhwUTH5yaewkbUpINo4eUrvLTom42DPK7Y+hRogwMRJTNpv6iwYHHaofXFlltfu6WUkDPek6mMblChBoEn4qjbAH4kelg9/davN1bEKd1AKEoUFGkiEyGIgaeKOqysHG0AVqMGjW2pyx9eizr457GqYbkg6l1KEN+qS9bZbbEI2SOetwmyBkf7R6nZlLfIey4eiiloN/XC6Pg768BOncXk2Zua8NHDDLWPN8grcAfJlxfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbhcpmpBTu1UhFNuLRiz55gg7wJYWcLifsHFykvE8oA=;
 b=jEp81kwTXMjPyLkzIj4/SjEarB6Rjok+fbTQehL4TNhEFxjUEU7ZguJT9qL8Lwt4afFXSNnaBY1Dxadk/gqy2LIu2dtT4C2XUzb1IQGKxO3GwBm/eAkI+HrMOhK5kSx9fDhPp7uHwPtbBMuPiL7tw2truuO34g991u6b7k0Rh6k=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ5PPFB6A054FAC.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7c5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 08:49:57 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 08:49:57 +0000
Message-ID: <b5d5b534-6c65-4136-8bf5-74f472f660c1@oracle.com>
Date: Thu, 4 Sep 2025 09:49:51 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/26] scsi: core: Support allocating reserved commands
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-2-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250827000816.2370150-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0173.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::17) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ5PPFB6A054FAC:EE_
X-MS-Office365-Filtering-Correlation-Id: eccd9b47-5c96-4ebe-f92c-08ddeb900646
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Wmg4UnVvVkg0cFBXYy9DQXdUcitSTDQ1dnBjNXlYL3U4azd0ckhqc09rUGJq?=
 =?utf-8?B?MEl0dU9sekxMaEpWL1JLdktVVFUvazNuakdBSDNQREMzSWEycG1WQUg5a3Q2?=
 =?utf-8?B?QzdNUXJhaC93eTBSRy91amJhbGZvZm8vTFpOZ2FxZVRaWmRGWllhbmZQNkg5?=
 =?utf-8?B?Zm9PMUdSRnorRlhuK2FZZWhPb0lIWnlQa2Nzd1Bha0t5ellPb3RsNnVpa3JV?=
 =?utf-8?B?VXBqZ0ppTGU2UVZUcnJzL1o5d1RjeXRzbCtDSC9CbWw4QTlEcW5rbDV6ZUJH?=
 =?utf-8?B?SFZCQm45Y3MvVTJkUXZTQVVBUWgzOUNWaHVUT2pDSnNJQnNjMXh2MERYVTdp?=
 =?utf-8?B?bURKUC92Tkp3dzE3bU9pbWpVWi9zTGphQVFtUFQ5ODFlbnNLQmg5WXVGYmx1?=
 =?utf-8?B?alBPR2ZSRFZ6NmE2VU1KSURsdjBmU1c0NUZwbmRWclJDbDZrR1dwUy9JLzZw?=
 =?utf-8?B?akYvZVlUQ0swUG56RlUxeTBhSlN0S0pHa3ZHUmtXVTJiM3BvV2tRZUR2NzdC?=
 =?utf-8?B?RU9LN0hrWnp1U1NWU1EzUHVwYkZ4MTVZYTFXVnQ5MG1DcmZiSy9XZDRaVnk0?=
 =?utf-8?B?Z3E0c3RlZDltWlE5SEdJR1E4LzlrQTFkN2k1L254MHRoOVp4cWU0S3ZxVGM3?=
 =?utf-8?B?ZGlMdTMwL1JtRzluZjU3T2xuUTlIVjN6SFIvWHhFdWJ0YU1ySWpycW52a0hm?=
 =?utf-8?B?dGdJSXdpazU2V2JIaEF2NXIrL05wWnBEK0dYdDEwb01tN2VlNzlvdHRBY1pV?=
 =?utf-8?B?NnNiZzc3TzZMMFdmaXVCbGhsUGp1cVdjREEyYXplTmxFa2NNdXgyRnRxTVBX?=
 =?utf-8?B?ZlYyeWtHR2ZseXgvZmNuS3hHUHZUU1puT2VFamVRTVBHRUpxcno3dElGbGZQ?=
 =?utf-8?B?dTg5cEZ1cTg1eHhiaWtCdW5SN0dtTS93a2VHaFVXOS9KMlZjbC8ybm1QNmJ5?=
 =?utf-8?B?aTYxSkd4Y2FZcExTVTUxeW5JdHMxU0MwdE1xY1RqZlJWczg2TVkrUHJHR0V0?=
 =?utf-8?B?TkQ0MXBoVGtKYWVwcVpZYmQrRG56anB0RkM4SUpJWWZVVUtUeHpjWXp0Ly9w?=
 =?utf-8?B?R1NielM2WUgrbnBhbE1WL2RjalNYbTEzZSs3bm1WKzRVYkkxaXFLTlFTd3Zj?=
 =?utf-8?B?RkFlRllDSDBrL3B5b1NDT0V6Z3Z0WkZMcHl1Zm5SQ1puSjc1cXBZWG9NakpK?=
 =?utf-8?B?QzUwY0dZSGhlVnk4NWN0bC9sMTZ3a2tzakt0YmM1RURPYmRMVi8wR1greGZF?=
 =?utf-8?B?YysyZTRyWWhnTitBUXRoVUo2L0prSjVHWG8rNk5JQ09lVUdyTkZyTDVUTG8w?=
 =?utf-8?B?d2Y2N2pPZWFJNE9wQXVyZnNrTXJqY0twOUpKaXNyRG4zK0NBZ1B4TXVDcWNC?=
 =?utf-8?B?K2M5R0cyK2kxd0NkTStySG1EQndjeUdZZ2tLWDJ6YUJ6R1JBaHhMMVVNLzBF?=
 =?utf-8?B?V2IxdklFVnNLVWsxa255bTNTWC9Vd2lZaVRGUzJnQjh3UTYzd3ZEby84MDcw?=
 =?utf-8?B?eDB1dXJWL29rV3JBeEpCZE9vMEx1NCszb3U3dFk0REh6UmFmeTNwU3htVFQ0?=
 =?utf-8?B?QWJBMUxxeDhqRStzK0xxcDhPU2tsZUJnZUdmd1dFVWNkcyszaXJsMUU1dDFq?=
 =?utf-8?B?REE0NGY4Z0dsaXlXT1FkeDl3b0IvSi8wTmJpYVVVaW83UlkvZEZNTUlQWUxs?=
 =?utf-8?B?MGhyVXo5NHRuVldaQ1p4Mld1WmdLeEpSR2tYVXRwMTFadlpQZEJ5cjdKeWNY?=
 =?utf-8?B?NWxmejZBcUxEdzlYOHBkTmphOElmRWVLWmtjbnQwWGkxeWhhQXJ1a0RXL3JI?=
 =?utf-8?Q?kwr6gHBeB6SAoml5RS852AE0nFV9+36ScLF7s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eTZhQVJ3UndwZ0ptYmJ0VkNwMmlQYjFzMlMwTDlSRGYzblJTcEpVeERsVWl5?=
 =?utf-8?B?ZWpkZUFBbUdCU05TV2Z0RkJ3V2VpdUtxRHdBVlprY1NXaUlWaC9uM0hJaG13?=
 =?utf-8?B?WTcxQmFJY2dxN1dhRUVDSWxQWEN2djlrYXVsNHlSMmZJNkVPLzNlamN0VmJv?=
 =?utf-8?B?Y0VWWGpablZNWU1CdWI3QnVxQk5rZUwyYitKMm1ZYmR6YWxnUVF1eXpObDZj?=
 =?utf-8?B?YzZ6Vm5oa0MvWXVGUk0rejhhSk05SlZtaWtIMTJ2TG1XQzJYNERGcjU5eHla?=
 =?utf-8?B?RURjZkY1cDlueXFhN0Y3RzBqcFBGTSs3Q3M1UFlnREdTRnRsMUo0TllDUmFv?=
 =?utf-8?B?ZWkxQ0R2OG9TZkpkeVRVSlc1QjBqdnljaDErMys4bUJRS1dWT0NlMzN0M3hh?=
 =?utf-8?B?MlRsQ3psUURSRFZaVU5DZkFuRWtvSWJBQWdJQndiTnRzNjA0RU9nSys1ZktE?=
 =?utf-8?B?UEJFS1V5azRhNmlTR1NjaTkrMmYxdnMzaEwvYmN1QXhJTDBjTDQ0ZnpzamR3?=
 =?utf-8?B?a1M2RGo5UXlZWkhEc2g3Zm9kd3BTWjlVMDZUWjJwQ3MyZ3BuVWdJQ29oUjFC?=
 =?utf-8?B?Z2taalp6Y2ZQRlZ5VzlwamxYQ0loKzJ4RjhjbllWeDZQQXR4dTJYWkZsZDQ0?=
 =?utf-8?B?QXJrWkNJd2dXdVQ0N1ozMzIrcTBWbWdkNzA2RllFdlFVVE5aM0tFWnl0WUE5?=
 =?utf-8?B?d2UrTkhiaVNGUlB6bmNJTExDbEJucjlVcEFXaEFsd01kRnFqVGphZ0ZpUlhG?=
 =?utf-8?B?KzhKc2F3Vk9Ib3VSSk5icFZBbldITjcwRFFqUWY2NzQ1UVptaC9oWEhZdmJx?=
 =?utf-8?B?ZXVoQ3p3dm9rWVdFQTNqZExTYzcyZGxheHpvc0NVWlNpQmVxS3ZyYjEvVkpR?=
 =?utf-8?B?N0FHVUl0bENFSWZWeWJaL3A4OXRoVGhxbWpaeitGWjZsZUh1S25YbUZKaFU2?=
 =?utf-8?B?UEd5c1oxTjd4WTNqblZzYnBCVWtvSHQxcTM5WndpMThqcHVBNTQ5MG4rQ0dJ?=
 =?utf-8?B?N3UzTU5TKzJhem5GU1VMWDJFamdPYldjeWVzcUhBR3lHSDFxLy9ueER1REk3?=
 =?utf-8?B?UVVpU0t2bUw0MU9jclAyaHRXMUhuUkt3SDgyUlF6eldtWkE0YUY1YmhFYWZB?=
 =?utf-8?B?bHdGUHNBdlhhcjU5WFFqaXpsamRyZ3VQbG43aHlwT1N2cHQ2K1k1YURiQ3FX?=
 =?utf-8?B?Z3RFRVhLTU5EVjIwU2RGakw0eUdsbXJlMlAraU1DVW40L1FvYmwzUGxsUXNB?=
 =?utf-8?B?aDFHMGtuMWZwQ292SFp1VFpnY0NGUHJOWDd5SlRlVUFEYVBSRUZVZHVaR0Fl?=
 =?utf-8?B?eUN4K0NDQ1BuYnlzU09EMHorb0FuNHRtN2VPNEpQOEM1Y1N5WDkzOCtmRStG?=
 =?utf-8?B?NysxS3dsc01kU2EwNjhEOUxyZm9WSXg0azk4N0p4QXNmMDZxdjlKQ0EyT3Rk?=
 =?utf-8?B?allzSnk5M1B2cVFHUW85Z3R1OFFhK2M5aGllVlJhbFA1UVE2L2t3ZUNiR0cw?=
 =?utf-8?B?VEk0NExFMTlmcWo1c1Fyei9hVlA5TERMbW5BT2lDS3BkMEtsRFcxc3QyZ2hH?=
 =?utf-8?B?WDY4TjUyR28rRU9LVHlHNUt3N28yTjBlSGYvU1BwSUREbE1oRHJlRTNBVVp0?=
 =?utf-8?B?ZDdQWjlKVmU0d3ROYWkvL1UyWlNldkg3OXo0VWZ6aG85N2VKM1VzWEtManhE?=
 =?utf-8?B?eS9lSFlkV2pTcUliNVFubVU4Y0VJSXFXWGxheDF1eXpRMHh2OEVtQk11M1pE?=
 =?utf-8?B?RnZmeEJaL1dpenNuc093bDdoVjQyT2tYMXdRWXE0dTlvc3ZsY2dkczBOZ1Ra?=
 =?utf-8?B?RFo2d1ZObHFCNGNRSkt5OVBRcmJmWTlWR2YrOGxKdm5Ud1pwb1JPVWhzRWV1?=
 =?utf-8?B?YjNjQkREMk1rNjFXcHU0bmQvcDhDalM0c002UnRDVXN5ajNEVGFPSnN0VmJv?=
 =?utf-8?B?RDR1S2c4Z2F3TlV6OGg3bVNBSlNiTmNHVVQ5UHhSQ3J3b2oyVURpWm11UkRm?=
 =?utf-8?B?OEZtdlo3L2psRnpyWTEzTmtkR0JiL3k0UGhHNHo4R0h1SVlJVEFRM2ZMYTFJ?=
 =?utf-8?B?N05lQUdMS1hNN21MQVRrMzNBNXBDYkYyb0RadXl4SVpXUENsdWxVUXlpN2My?=
 =?utf-8?B?MW9tRnROQkVYMHN5NkJ5Mzl6Rmw1Zm5ZeXFTWmx5Q2QyNXBNb1ROL3lXVTRP?=
 =?utf-8?B?alE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	avQgdpt4nsJJLYFDWHzEdU99dWCOD54iisEVDoUE8zonAQMVVDA9Hn3mRIJazLBfSN3ZadT+C5mSyYOkujulNltxkyP+3RbED8/7cobfWXz4dJ4u7BbhfXszv5VnBHKqbl/qHdfgZTtCZV5uV9fUE3rqfkucyK0HMgM5NgRPJJcw+DqN0UsGIC9v7lb+6fTqrLURbSkfAAZ0TEUXX4sAQ4oHMSWZwrbPnOigkPYbWtPDqDTo0q3kHys3fDyuyl+UXFc1zESWPqbDICN/q74PW/rKfnBYuZW04NtLmTbAQJi95u6L+w8wh3NTC3B2qTV10kRnucw9t6wSBGrjnLaAmDRFE7WG6wtHZRBWuQ7kvD0BaRhnBsCu8mPrcVmkzpW45So8+LESYGKyizE9Lmv9p4TfIhCwhdeJyAAzQ8H2PPFLRfP7RMMLmLmAwDx0YlTGeiL0kHSrWX6ty1s003gEcn1Cg8pmFUdjUJ3HulFI6uZff9cYZyJpJeREKSaKZER3bulnsxdP43sebJx0U8zIExwKP+QN8M87psTQnEnd1Cin5kemrb1JqjqkST9rOOCOA0yG9i/cdZ8qhRd1iusJpPHS1x16jo3sQuYI0iFr7dM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eccd9b47-5c96-4ebe-f92c-08ddeb900646
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 08:49:57.3755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OLhH44eVPVD2DyS8hfyeRckRChLltzpK7Bo47ZZqmyBj0FttdS5cOt9R7bjaSDPlxuUfgRI9ZNWRYPHHFbZgSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFB6A054FAC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040086
X-Authority-Analysis: v=2.4 cv=QLdoRhLL c=1 sm=1 tr=0 ts=68b952ba b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=N54-gffFAAAA:8 a=yFzyIJCBBdjE8KEdcEoA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13602
X-Proofpoint-ORIG-GUID: hZ0hPV1bU1v_yOOVD8WhoToRuVsGih1r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDA3NCBTYWx0ZWRfXxUSVYyLqbY+k
 H7OgkGe+nGj+q2CKEI63AuQQzbcoHLWxV2N6yO4ixsT3pWSjmzKpKFS76ukaeJzVx7qvG27FGuK
 TDi76pFWb+LlfYFHhxRe3Ta7vlMxmD0wg+5FYs8V5VJ2vGEC2BFEJRg0lr5ZXqqWwsVtQv4EhqW
 ForumfLeT/JGQcMWRFtuF1lja9BV2z9R6MgmbM4WW3fZSUoFlpjQ2mHdzRYQcAboUlcq0Lt2XwZ
 4Hk91tOfEO9GWQMhljhnQbsi+q+08BxnY0zMLp2LCUEVNd/HD4evRH0baB4o4Lr6JzeEzs4SxN9
 64SXu8E8IWs8dZTtq/Tr8CIPP33TbC2o91f5R5UWlHxXCdMLhlPmC5oUj1IoQ1jK/zTa06vXkIb
 N/NR1bDNqVL6FzKC5SLTANzI3ug4Bg==
X-Proofpoint-GUID: hZ0hPV1bU1v_yOOVD8WhoToRuVsGih1r

On 27/08/2025 01:06, Bart Van Assche wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Quite some drivers are using management commands internally. These
> commands typically use the same tag pool as regular SCSI commands. Tags
> for these management commands are set aside before allocating the
> block-mq tag bitmap for regular SCSI commands. The block layer already
> supports this via the reserved tag mechanism. Add a new field
> 'nr_reserved_cmds' to the SCSI host template to instruct the block layer
> to set aside a tag space for these management commands by using reserved
> tags. Exclude reserved commands from .can_queue because .can_queue is
> visible in sysfs.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> [ bvanassche: modified patch title and patch description. Left out the
>    following statement: "if (sdev->host->nr_reserved_cmds)
>    flags |= BLK_MQ_REQ_RESERVED;". See also
>    https://lore.kernel.org/linux-scsi/20210503150333.130310-11-hare@suse.de/ ]
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Apart from some small comments, below:
Reviewed-by: John Garry <john.g.garry@oracle.com>


> ---
>   drivers/scsi/hosts.c     |  3 +++
>   drivers/scsi/scsi_lib.c  |  3 ++-
>   include/scsi/scsi_host.h | 22 +++++++++++++++++++++-
>   3 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index cc5d05dc395c..d7091f625faf 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -499,6 +499,9 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
>   	else
>   		shost->dma_boundary = 0xffffffff;
>   
> +	if (sht->nr_reserved_cmds)
> +		shost->nr_reserved_cmds = sht->nr_reserved_cmds;

small comment: shost->nr_reserved_cmds is always zero-init'ed, so this 
could be simply:

	shost->nr_reserved_cmds = sht->nr_reserved_cmds;

> +
>   	device_initialize(&shost->shost_gendev);
>   	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
>   	shost->shost_gendev.bus = &scsi_bus_type;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0c65ecfedfbd..9c67e04265ce 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2083,7 +2083,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   		tag_set->ops = &scsi_mq_ops_no_commit;
>   	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
>   	tag_set->nr_maps = shost->nr_maps ? : 1;
> -	tag_set->queue_depth = shost->can_queue;
> +	tag_set->queue_depth = shost->can_queue + shost->nr_reserved_cmds;

this seems the proper thing to do, as tag_set->queue_depth matches 
blk_mq_init_tags() @nr_tags, which is the total

> +	tag_set->reserved_tags = shost->nr_reserved_cmds;
>   	tag_set->cmd_size = cmd_size;
>   	tag_set->numa_node = dev_to_node(shost->dma_dev);
>   	if (shost->hostt->tag_alloc_policy_rr)
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index c53812b9026f..722ecbee938e 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -375,10 +375,19 @@ struct scsi_host_template {
>   	/*
>   	 * This determines if we will use a non-interrupt driven
>   	 * or an interrupt driven scheme.  It is set to the maximum number
> -	 * of simultaneous commands a single hw queue in HBA will accept.
> +	 * of simultaneous commands a single hw queue in HBA will accept
> +	 * excluding internal commands.
>   	 */
>   	int can_queue;
>   
> +	/*
> +	 * This determines how many commands the HBA will set aside
> +	 * for internal commands. This number will be added to
> +	 * @can_queue to calcumate the maximum number of simultaneous

calcumate -> calculate

> +	 * commands sent to the host.
> +	 */
> +	int nr_reserved_cmds;
> +
>   	/*
>   	 * In many instances, especially where disconnect / reconnect are
>   	 * supported, our host also has an ID on the SCSI bus.  If this is
> @@ -611,6 +620,11 @@ struct Scsi_Host {
>   	unsigned short max_cmd_len;
>   
>   	int this_id;
> +
> +	/*
> +	 * Number of commands this host can handle at the same time.
> +	 * This excludes reserved commands as specified by nr_reserved_cmds.
> +	 */
>   	int can_queue;
>   	short cmd_per_lun;
>   	short unsigned int sg_tablesize;
> @@ -631,6 +645,12 @@ struct Scsi_Host {
>   	 */
>   	unsigned nr_hw_queues;
>   	unsigned nr_maps;
> +
> +	/*
> +	 * Number of reserved commands to allocate, if any.
> +	 */
> +	unsigned int nr_reserved_cmds;

nit: maybe co-locate with can_queue

> +
>   	unsigned active_mode:2;
>   
>   	/*

