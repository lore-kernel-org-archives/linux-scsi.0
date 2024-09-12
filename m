Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DBB44C8F;
	Thu, 12 Sep 2024 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726155548; cv=fail; b=PCmCCrwM5XI7r2uFqJbcCk5TrlR1hqIGAqQKk7OfzlXzLrS9oA++al9UkouUdkzre1w1LFXMtur5RYbGC4c77uVcJu8Va23FKixzXmege8c+MJUJtpTsv0XhDrV3kJPNgt+LlsJmhzFOigYJjento+8nOZDI7PQEVwKtlv9xr+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726155548; c=relaxed/simple;
	bh=FEGm1YwxkShOAR4vLI+XOd+2ZTXd3hFD9mfzwJnU6yc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q2KbeNOAemO62QhPTVU5K/8XoUdO9gNcwXZSdJEBGkYdF/rn/wTf+xSj776pOHuTUPJtCGvkghhPDOyvO5PfAup3pMJaBpOdB2rra9rB24XF8KVvL6ZAHhn3crViGnWUCMNaZO5/3BCnOy2kgWf+GeGyqb0dBlfDDZ2AHvLl5ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YocgUOPm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZYSocz0E; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YocgUOPm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZYSocz0E"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48CDtZoJ006918;
	Thu, 12 Sep 2024 15:38:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=ut5/IXskR8OAU+4V/O7prF35F5g2nshE4UR1Okfhowk=; b=
	YocgUOPm3DgvN9TQyrxTWYH0MSZbsFHzKeTwUmoFriXG9sxK+3IPjFjxUnxJ9J79
	qaGY+zAoFsCSWWw1/WwWk0Rlj5dU8dNrZpEYPtPhAY6RXKhmB9tkN3QQriqUDICR
	y8UI/g5g8EieRB5cYGgL08XntNryM42GGCBm/2pROvjwLPP+2m1/YQajq3coCcGS
	D1OKakqi8wfxtF3kx3jgN1eJmiVbSrG7XxG7zNpeFegawgG4ikWassLz8sExa/aW
	LhvZt+PM58EWZP8Ttb9vVUrDDvbPWyphbsyXOjTaYhPOxkt1UXF4OF4woSCv2ltQ
	ecBMEuUqz8N2NODMZcWJDQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gdrbb7wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 15:38:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48CFFswX005456;
	Thu, 12 Sep 2024 15:38:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9bfyh4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Sep 2024 15:38:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PJOPMsp5AGJ3F90yEY9byL68aS6giMnqjt0caKSrGMs5zWMTeQtsbBVpUwi6nWTZ/F4ELCbiGgZk+6L+1Wn0Hal7xsU2OaINrTeKUNjo+ZpEr22kG/K3CzN+IulrkMSHfOLuAhPdss5UUKW5RVXzbhoqrJnvmiPFRzC3LlfILcmFo6bo92JUie/dl7uQFV4m7E/+LYvVB/Ma7sBvY2KNNgJjchcWWM+HXRhRcGTB6Hz2Xy1VJdrrOe6ftpWRGwPu8OhGZ0pYSHZA3sxWhICEZe03mXO6joEm5Re2XK1aUBCf73zzeLwFks2j9Fjyt88n4SJ/0yESBq7Dn+wSbuEvAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ut5/IXskR8OAU+4V/O7prF35F5g2nshE4UR1Okfhowk=;
 b=kac8TixaLvhu3A0zG3onqN9zbXBs0yXEq7QobZuSgeCWbRA6N3gq2NAHOdVIDfC+HYs/8FoIuEgwoJA1pa68B8tdDX1n+TMUPrnuw4WurJrIEJjsD0yOfrDulAI9CBFxYkv0wYZ2OKQryVvTeQLUzs5soXwYWkzNWUWrWl1Z2hwpbWXGHX58TvvYoMU/futS695It3nwT3W7TQ0vcV+nRSCwfgWVnqE4c/CjFt2I1JXeCAcF085UCgGs9q9gUaYXTnAja1LioFx+DuMtuOT6GbjvBGMfu+ma3Ub83lqJ1Kmsq8cO/wO0LyZoNtSyZF3a+wjqkoc31Ty5mgC/dRkWoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ut5/IXskR8OAU+4V/O7prF35F5g2nshE4UR1Okfhowk=;
 b=ZYSocz0ENnuyY4Obov4cJx15i5KJ6Bindww3HLsHq7fIbvIdlD5sixiophkCix7Tan3nYhDgq8JeEcZZ8xRWw3MOnKAyN7mnhTCnJ/qQD+x9gFtk6WPdqftxcpBhrH9pxhNaEo7wyvw+ysD515rF1QnotzMOBxBNIHR+MqrTm3Y=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6509.namprd10.prod.outlook.com (2603:10b6:303:21b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.14; Thu, 12 Sep
 2024 15:38:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%3]) with mapi id 15.20.7982.008; Thu, 12 Sep 2024
 15:38:41 +0000
Message-ID: <21f19b4b-4b83-4ca2-a93b-0a433741fd26@oracle.com>
Date: Thu, 12 Sep 2024 16:38:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 4/4] md/raid0: Atomic write support
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
        sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240903150748.2179966-1-john.g.garry@oracle.com>
 <20240903150748.2179966-5-john.g.garry@oracle.com>
 <20240912131803.GD29641@lst.de>
 <340e4306-4442-4276-b420-6fee8ed97a7e@oracle.com>
 <20240912151038.GA5858@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20240912151038.GA5858@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0215.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::35) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6509:EE_
X-MS-Office365-Filtering-Correlation-Id: 008c077a-7eb6-451c-8577-08dcd340fa31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YlQzNjcrenhKdFFDS0xLMUwyRC9XTE1TaEQ3a2pPWmtWSGZaRFg2MGxlZmIv?=
 =?utf-8?B?L1h6SExnc1pIczY5RWxQSXFqNTlnMmx4VU9td0loRlRIQkUzTlMzUUc0K1Bv?=
 =?utf-8?B?WXp1RkNtd0ZNQUJoYUNYV3VIdnFlNFhpTEM5dFUxUk5FV2FGbjR1V2Uycmc1?=
 =?utf-8?B?dEM4eURlMVViY25heFZqdDFsRmhIejA0bUNEUDhPOG5odVFHWDZtSGpzelJu?=
 =?utf-8?B?bnkrenhEY29iZzhIWklzUVI5TWxxREZFUHovVmMyRzltTlBFNEh5ZnFhOVYx?=
 =?utf-8?B?K2FhenNOMTBOT0ZIYjhSakNVV0VtQjh0cCtvNmlBQm55aVVPWVU0UHAxMXo3?=
 =?utf-8?B?ZVF4UlQ4MXJUdEdYQ09XaG05WlArdkdDK09QQm5YQzEyNXdudFkyTFo0NEh5?=
 =?utf-8?B?RkxDN2tuM3JCT0JiTDIweVdoZDUzMGlGMHhqUW0wQkRVYVlQTURjbGV3ZERC?=
 =?utf-8?B?djhlam5ERzZvb0EwbjZBd0twcVdvQmtQZXk0TnZDS1V5N3kvN0ZLVHF0aE13?=
 =?utf-8?B?TXZyVjZ4SkRnbFVuZnQ5SEhDNDE2SHBmaWVuMFpvajQwOHcwVm0yVnRuSkdq?=
 =?utf-8?B?OHlGYWNnTzI3eHQyUlpNMGE2aWFkMVYxYTRrQjNPUHphVDQ3MEtsOXo4Y1Uw?=
 =?utf-8?B?QkN3Y1cvaGtpUGhzRkxLdTlrU2tWR2h4c3p4a1VWb3Z5dFNNME80VklIRmM3?=
 =?utf-8?B?VVZ3eGo1WkxjS2VkalUzVThaUnpTNCtDMHl1TVZjdGVDUXRSL0ZIVGViMDUv?=
 =?utf-8?B?TFhNNlNnYzQrRzcxVCt1eHBTOVphZVFrRDlrb1Ryd1BoN2xGU0d6SDd6YzBa?=
 =?utf-8?B?OUY1aTJ3dS9XbFpBaFlZWVlLM29MTWNNbUF5cWZ3bkE0TWwwRmk0ZDltS3FO?=
 =?utf-8?B?UTF2djJNcVNTaElKMTh2cU16dWl4d3NscVVRek5lVzVNTEdFYnRFSlhrbWN3?=
 =?utf-8?B?TGp1d0lCMHplY0R1UEVJNFNkcGRBcEEvMWJHS0hxaDdQWFlnQVZzcVg4b1o1?=
 =?utf-8?B?V3FOTFZxNzkrazdyK1VRL3ZCTEo1SVZ0OXEwRDhuSkcxeGswazJrZjVNblYx?=
 =?utf-8?B?NG5tZTQ3cFUwZ0RYUWJLbjE4L3BDemNrY1J4SnVMb2tnVCswNUl1NUNCTHcz?=
 =?utf-8?B?UlVDbnlrYWU4Q2V5Y0R4azRYOHMvNmV3a3dWWDhwTmF5QkxIK3VCZTQxN2Rq?=
 =?utf-8?B?aEpwVVZCakE3clRoRnl0UWsrRmVWQnE2dFpST1pycEZza3BFRUREclNNSnJW?=
 =?utf-8?B?ZFRmbDgxUjRsSTd1UEI3UEdxWmZMbWJXRG9tZVhoaUlFWHFTdnVSallXeGZm?=
 =?utf-8?B?OUg3bVREVko3Wkh0RWVWZGZqSEo0Wm51OEt3cDk2QzcwaGlhWTZpMnJOSGVV?=
 =?utf-8?B?dTJOWFZEcjJXQ2NtUHMrYWcxM0JYcWVUdkRWSlpoNUwrVTJ0QWtmanVWVktv?=
 =?utf-8?B?OTM1S2RDQ09XenJMbEdBSkQ1M3hoWlZwM2s5MjU4a3VId3lNLzRLa2J4eXJo?=
 =?utf-8?B?QjhKVE1pNWtEcVN3emRyRFR1MkI2cnpNSFB5cUJpSmRLOFp3MWRXRFBobjNS?=
 =?utf-8?B?aFg1bkJ1RFU4S05kTzY3R1VmcGRxVG1UMG5kS0NNWHpiSVhrejRNTTYwVVF3?=
 =?utf-8?B?aWI2N3VYdDBnenl3NGhGMDlYOU5XcXV4Y3FWc0dqMEdCVzVTOWE1UmpjZzJG?=
 =?utf-8?B?QUZFMWhBR3Ivc1pNdjlMT3BmNWViMGRwSUNZU2dwdGhoU2dFc1I2WDl0SGNX?=
 =?utf-8?B?QUd4eWt1NkoxZG5Md0Z1Y01BbFhCZkZiQzNoeHVXaGlGYjE1K3ZScHVVcGR4?=
 =?utf-8?B?L1diOTMzdlY0cllCcGdTUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjgxV1dkaTlidENnUVVCU0dGQVZQTzdUN29rWmc0YW9vbzlJOENYNFR1Rjhm?=
 =?utf-8?B?amoxT3F4cFUyQ3ZEMkI3Z2oyMWt2SFY2NkZGMG1SQThsTVBQazluSEhiZFZR?=
 =?utf-8?B?UW1MaGd6eW1WcGpOVTIyaW5yamppdFl6RmpJRENTVStBQXc2dVlqeGRWaXR0?=
 =?utf-8?B?YWZUTlJ4SlE4UEc5WEVBYytaSUg5d2hkWVpmbDZZWTZ3ZEg3N3Y0SmhnbURh?=
 =?utf-8?B?SHpvYXFUd0h4T3gvRFRkYmRFbHlqYllvWldjc2E1ZFhYUXBLTGZXdG9tV3h6?=
 =?utf-8?B?U2dXNzhjU0Vwa2h2UFpFYXRtVkR5NG5SWWhIYkg4TVNtbVhUY1NiUnJKbmlY?=
 =?utf-8?B?K21sbllHVW5ZcWE0S0FzMCttZkdDM0QrR2hwUkZldVl4WCtpaExUMm5lSEFR?=
 =?utf-8?B?K21VOWwvNko5NmJtaktVdGpwYXdJVnRwQStwaVlYWlZ4Y3EzeFA1cjZaRU1o?=
 =?utf-8?B?T1liMWtLaHJlMGlJTjE0MHRXUUxocXZsdGhjQ3NXWkUxZ0Y0LzZ5R25hRjU0?=
 =?utf-8?B?NGtYTnBBVnZKRWJXTXdZNWd3TzYrT0tYUC9TY1JrK3c0QVErS1VjYWJYdTZI?=
 =?utf-8?B?WFZMY0pqK0ZiOE5YdUVzd3Zob2xJQk1BZlArd1hmMUVMNExteVZlbXQ4Z3Mz?=
 =?utf-8?B?Wi9xVW16MzVCd1dQYnp3U3Jac2txSEpxNGtqcXBFV2U4ZlRES2lMS25yVEhy?=
 =?utf-8?B?MUNWVzREWjdXSS9NZFdYZU0zZVk2ZUxwSTdqMGgvcThqdEVLOGlUN0JtbGpD?=
 =?utf-8?B?cmNsam1pUUFDbFRlT0VML3JYb2hNTDhibFBZK21NNitOaERNcmlzR0dGRHZS?=
 =?utf-8?B?UFZseVk5YmlxYnBDZlZDOFRqY1NndjgrUXYySFAyQnl0a3ZqSWJPcmpya1R1?=
 =?utf-8?B?UkhKMzVuWm9scEh2eEhDWFFWQ29CeXNZejgxS2ZFMmJ4Q3R0NFNhM0ZRTTUz?=
 =?utf-8?B?NWJyR1lvaVdBOVdZZENNM3R2QXFnYTQyWnE3bGRGdUJENHFoNXg0d21LT0Iw?=
 =?utf-8?B?SnYvb2plVkpQdjd0cmI2bnNyRlB6YTR3MkVoR3FQTXppZEdFNVVHb3BleVJu?=
 =?utf-8?B?cWRFUEwwallXbWZTd0RYcGx2dVJyWENiRHg0ZzJhVmo3Yllrd1JTUmd0ZmlY?=
 =?utf-8?B?U1dvK2N1UUF2eGY1U2pGaFl1T1ZsY0c0M0lSN1lFOFl5TW84NEJyREJZUTJm?=
 =?utf-8?B?WTZtY0xsSDZDdktCMC9aSUFDVWQ3eXJHQ01ONVNNcDZxMUlaR2FaRXBtSzhI?=
 =?utf-8?B?cTBQUysxTE9Pd1ZWSWFOS2c4cnFjanFGWlFOQnpNNVRNTzJDeis1OWlTUVho?=
 =?utf-8?B?WGdZbkkwczNXaXNHaHZXV01RazllZVY1azRPT1ZCdXQxQ1l5dEYxR1JnUDN6?=
 =?utf-8?B?TmxMMVN4eXpmVWpXU0haaVBMbm15UWtvZkdnVkd0bGlCL1Q0eDVYZHlLenJx?=
 =?utf-8?B?S0JMQWVIUU9RWnhMZEhFMHJINjVUZk96aTRZeGExQk9FV1M2WGNlWitrZzdk?=
 =?utf-8?B?QjVlRlJPZkNycG9RZXRMN2Y1bkhURlU0Vmd5cDd5bGtxNWthR3lPVCs3dWhx?=
 =?utf-8?B?SW9ENGROemRKWWpSTGM2UzNSaXlUSm5UNmxGY1Q5eUpOVmNPa2hWaHFBYWNK?=
 =?utf-8?B?ZlFwRHRqbnM5NG9jdTRrYXJhdURFK3FNRHVqSTE5OWs5MFdNT3VFY2NGZE9N?=
 =?utf-8?B?U2IwcC9pODY2czRsc1RlKzFKOGdnK21XditjUUNEcjhmZHM3bkVRdUZmcG5o?=
 =?utf-8?B?aG81R1BMekJoWnV1ZmhsQVFTQWFOL0ZQZmZpcENrK2hBSnBJU3N6eXFiaUpt?=
 =?utf-8?B?ZDVJRGxEY0JTY1N1eDRJdW01bHhsRWE5V1BNbEs1MkY5c1RkNk9PTTdPNnA3?=
 =?utf-8?B?VitrUDdCRVR6VUdVQnVTemUxa280cmJTenZwaXFZL0MzUWZUcWhjMXg3WVk3?=
 =?utf-8?B?Qzh3YUwwSnBCYVRvK3JwR1lIYjI5ZTJHZ2UzUjczNnhuOW4rSldFSVVYNzQ3?=
 =?utf-8?B?NnpsdTExY0p3OFlMZXBzUHU2M3IxMWRMaDI5REdLZk5XTnEyV08vZnRpSUl2?=
 =?utf-8?B?d2NZRHNwdjRzWEV2R05ib2RKZjVTempHeTdGa3labjJ1cmFlcFBjNVpSS3Rk?=
 =?utf-8?Q?R1MN9N6OKqcpIxMO35UBTaciG?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yAZjF+pZZJsbi2aB/R7tpESHBqQPOYAI1nROT1rsi1wAnH6+FtIC1BK1UuWJWkufpzorV6d0piB5gEzRnxKsUAsFkew02zU8X6qjoIcrrG/Ros973sOMojazgsBb3B70OZ58OBF53Qlm4kFe/C0IdXv7cTULYPhImUoZecRV+uIZq+5LbY1Ifwu/FSSOVniHWGf74KWB7CXQ9gXuJFRZDfG1DYLPAyzCYUAn2nWfxJBtUp6aIERF+8R3MKh/WDNgHfK3hIsPn8XCXDzN3JdhQuOJAkYI1KMwPVh7Hu9S2c0KYe01HGCRIjHZFMsgr1LhGeZhHcCl/WSQOZGP+f5VuCpCnnWF0yJNMXI0+MwiQXDVqfZq5flhqShBhf6Vi26Rbn4ckhCtWE9HaT373WvESx0mfxfEE13f5nLbROKrtjVUIYR1s4e61UbiACvAuiYp3Y8+QtnWaEkP0huhRUlbjUaCGgNXQv1k3+OUzf+Z3ymylt0uf4dz2iWHOPF+fTD/sLWI4n0c5PngEGeDKxwrh4NAdCFspxwu8zRyA5QYW4nat9wAfu4ozA5BD+DxfEmrNYc1ktjYHhBe5c0JXz8QnFx5wCIsr/KLcd7IXt9DWyY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 008c077a-7eb6-451c-8577-08dcd340fa31
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2024 15:38:41.0847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cweoKB84J7x/ly3RM0+HRE6Rh+aa+0m09LdoMfTfxNFdjzEghUEK1JMrwbuw153jI9ZaFAdpsLM4uj8TBRhwCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6509
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_05,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409120115
X-Proofpoint-ORIG-GUID: er5BfrAbQMrgJo99VGKKpxya2QnDw-Kj
X-Proofpoint-GUID: er5BfrAbQMrgJo99VGKKpxya2QnDw-Kj

On 12/09/2024 16:10, Christoph Hellwig wrote:
> On Thu, Sep 12, 2024 at 03:48:09PM +0100, John Garry wrote:
>>
>> I actually now think that I should change bio_split() to return NULL for
>> splitting a REQ_ATOMIC, like what do for ZONE_APPEND - calling bio_split()
>> like this is a common pattern in md RAID personalities. However, none of
>> the md RAID code check for a NULL split, which they really should, so I can
>> make that change also.
> 
> bio_split is a bit of a mess - even NULL isn't very good at returning
> what caused it to fail.  Maybe a switch to ERR_PTR and an audit of
> all callers might be a good idea.
> 

So for bio_split() I guess that we would change as follows:

--->8----


diff --git a/block/bio.c b/block/bio.c
index c4053d49679a..36ddf458753f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1671,11 +1671,11 @@ struct bio *bio_split(struct bio *bio, int sectors,

  	/* Zone append commands cannot be split */
  	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
-		return NULL;
+		return ERR_PTR(-EOPNOTSUPP);

  	split = bio_alloc_clone(bio->bi_bdev, bio, gfp, bs);
  	if (!split)
-		return NULL;
+		return ERR_PTR(-ENOMEM);

  	split->bi_iter.bi_size = sectors << 9;


---8<----

And then fix up the callers to use IS_ERR().

Or also change bio_alloc_clone() to return an ERR_PTR()? I don't see 
much point in that, as we will only ever return ENOMEM (from the 
callees) anyway.

