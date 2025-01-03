Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88998BE5
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jan 2025 00:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735865600; cv=fail; b=HcKeBWS5k7G140DfvbqLuwwMbtIj04qgWvC/JLKrwflBfjJJAF/OAjyQS6UQohTM04A9wssjwFQ63GlP2oeuPJZxya1FDE9UBZ7g/yV+VQn8b5UwWjQDm6q30r9tFGhfoVq7h6e3viEspCJLafvT519/bVZYwietk8NfqY2LUDA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735865600; c=relaxed/simple;
	bh=ApAHxqUarrqdUSvnnrF7UE+wYxA3tzPDikyF4PRLKqo=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h2fhvQ0dpVDxecLZzq+14fipnGT70eFp42mqIfbCSu6bQXXKZQJsPey9ROzN1SvlkaWK3EyO+TWrygQAK55MoTSO7xtf52Dfkhs6FejGRaKCldQoufDd6zEoTtv3RNKg7wSz1Y/3iXYS3rvXBMVXBlcy/5uy/kKJavpXee2qBbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FfjdJAbZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GHjiaWi3; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FfjdJAbZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GHjiaWi3"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502NMpgG009149;
	Fri, 3 Jan 2025 00:53:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=IO2ROeF7zvRU6HmrhdG6qHPXfoD3NmZPgcQ4TKh+hp4=; b=
	FfjdJAbZzmZDPS8k3QYtvsnFh911OKAgrK8pLhgRXBiSNz0Yp2z1rR67SI8PKj3x
	Cq2q89Zo9w9CWpMZDZNir6WUNQlyOMQjKCuvOLe4FrlK5sjzDpFSE3Dv8YTcWrhJ
	T73t9jtYc7vrUvoVbql2ly7Q8+/eicysDvJwLZWBWQFG4as7LlLEloCLuqg4NBdE
	GIHOUE0WTbLKkXjK+6ehi83Pd4S0nBtP/O3yIbBqm1COc1fhpis8eYQKdKTgIgwS
	NJneqivFjW4FcDCjEVgT37VskEe8xQVQzDoJHAzmT1JDCumODe35OLivMBAF2oQ8
	ZwhVb/PApetPOEecIes/Og==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t9vt7dy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jan 2025 00:53:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502MkMkQ009521;
	Fri, 3 Jan 2025 00:53:09 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s963n2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jan 2025 00:53:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h/RnDQ1Ag3iLBaIFA9giwVl7u0oMOUGhgBMT3CBS1fH30DufnFHy2dRSGaU/17UJ3+lmApu9lwLIPppUpHGqffkogFTu3vchNGSwT18BTSZ15R8NAKzfCsqHycobfV7Cjfqd2pjeJjA1CR7I+azipwpS+7vRrGqzBWxiRF1sZmDchW9B5hIix1gjlPZ8T6sdG1pCBeCXAwxj3griCH1SbDr+bpkFJLaqev4lf3jmg381Uui1NqcCxDMeNhfr9WNxTwKD8SjaQPwVYNSE99GuTABt6UN5lRJphFv8JByFvyjGlMCwdE1hqUS2ad5/Tj2gVfgtH4+Uz/QBgug52Fl6TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IO2ROeF7zvRU6HmrhdG6qHPXfoD3NmZPgcQ4TKh+hp4=;
 b=P/UGaYa+xRdhFaOHWXALLnnTISDA4nbHVt5WfmiFHjFL4zlvcGjsKLavYTcoFwGmelvCorhgxZlVZHTfulJzPjHHm2u4/cV8sQJvPh7ZIEtFCvWOzXVqqrHzeyl32lTwfoILKFwjl52Hw4eW+zolC7UNqCgyd+Ct1BYqJ8Jr2ODGU+Ua8KHtvXgpELUXi/cf1ePeJ7Ld29eA/vcH7C7VjcStYnIh1WaKS3i3tSb1gczXdRGrIF7bFXfD0u/p/nvGJmEND8P69/7aU7JAPgOFqUZXV6wLRTPt55bz0f5Eb3enB41oogtuSSKv+kWmAWOnZ5tFUFnZ0e6lzpWMpz1++w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IO2ROeF7zvRU6HmrhdG6qHPXfoD3NmZPgcQ4TKh+hp4=;
 b=GHjiaWi36Erq1446hh46CCMlarV7QD8NVY/n/2bxHJXa2G7V9nt+ueZV7l0pCgqQxzIsgF3BHf+OM7eNxGPOvKKUHFaDPTx1vIEeo1Rfurl1NT6wWfAAT23vdgk0HcZCYW5qOsUSu8qOM6sf+NzO0BQxU7WkhmQFdCbfz8byR5E=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB7636.namprd10.prod.outlook.com (2603:10b6:806:376::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Fri, 3 Jan
 2025 00:53:03 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8293.000; Fri, 3 Jan 2025
 00:53:03 +0000
Message-ID: <1c452380-a6a9-48bd-bf21-cdd587777070@oracle.com>
Date: Thu, 2 Jan 2025 18:53:01 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug 219652] New: READ CAPACITY(16) not used on large
 USB-attached drive in recent kernels
To: bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org
References: <bug-219652-11613@https.bugzilla.kernel.org/>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <bug-219652-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0116.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::31) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB7636:EE_
X-MS-Office365-Filtering-Correlation-Id: 421ab71b-71d9-4c7d-2214-08dd2b90fa52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zlo0STZSY0FCYlU3RWwrVURaRTZSeHZTeUNKdGVMdE5yOUZOZ1F6VEY3dE1h?=
 =?utf-8?B?VG9qNUZQWFNDVkR6elBuQ1lUN04yajRLNjUybFB3eFpyK1k5LzR4eVhCa3o5?=
 =?utf-8?B?b0QxY2FkZzlsZ2IyVFIzM0RESVVzbUpNaGFzb0hlM1Q2dDczZGY2cFFOS1U5?=
 =?utf-8?B?N3JpTmFPOVRqelFYdnlIRkdlcCtQa1hMck80VmZrazJqR2U1U1paZm1jS25x?=
 =?utf-8?B?aVh2SG9OQkVXMmwwelN4VCt1RlNzRzVINUErN1Z4K3dPQmovcTgxT2ZhRFBz?=
 =?utf-8?B?WVZta2RWTkQ3TDFuYXNSZEVpVnlvSndRZnltVW1WY01ielo3aFpLVXBHY2hk?=
 =?utf-8?B?M1lSaFpCUFF6aGZnOHcraGUwQ1VFbjR4WjVIRUMrY3ZKM2xKU3FtMVVFSnVy?=
 =?utf-8?B?MHNpNGpZbjV1ejRWOWY2WHJmSHNuMldUWDVDKy9aSjFlTUlpRnlORlJsZjNM?=
 =?utf-8?B?Z0xLRHB0TkIrN2RTQWRJK0lqMFI1S2J4Wk1xWktxMzBteXRGTno5ZzZKN05j?=
 =?utf-8?B?SmdzUjNaVitDZlBmNDdNUlZDV0oxMkgyWnpZM0VjMnN6NmFqbjdFbTRHTTdv?=
 =?utf-8?B?elN2SUhaUkNxTDdkNjRvYkd5OG9ibWV4NkxaNTBYeS82cWtOU2h1R1djS1Mv?=
 =?utf-8?B?V1plb1FTYVhXS3dLd1l1SzlSQmFIcnh2ZEppT3g4M0RYR2JrMXJzbWk1K3Bn?=
 =?utf-8?B?dlhNL1QxZFVkRXdLV2xsc2V2S09WYWlLcUlrR2xtZU1mVXZJOFJLVXNFV21w?=
 =?utf-8?B?UkZEaCtHK0tqUVVpSVA1SVN5aDBmcDg3TTdnQitSNCttS256YndVUktya3ND?=
 =?utf-8?B?T05PNCtJZG9IVVNHNENYU0p5L1B3RHJEV1RISXVQbXQ5am5vWkNXYVRpZmky?=
 =?utf-8?B?QkNDMG9UekV0SXJCdWNqbXhPM1pNVlllNmlIcjRXSm5sbVQvM2tOMGpucHdJ?=
 =?utf-8?B?eVdvRkNoc2ZWSE91cXFma3dPMXZyOHQvbHJpWmdwekNocVpBUXJBWHYyRWJU?=
 =?utf-8?B?aXc0N0VvV2VkMjNFY0JxYTdvVDJ5U2h3eUErS011T0EyTkVhK2VISkVtR1J6?=
 =?utf-8?B?MTlrdllIakk3NjBYUTl3MDdodGxkRjBXeGRuRkhtdXdEaWFKMnJLKzVwQjlr?=
 =?utf-8?B?UDQ3eWZ2M3hIS0tYUUNxbCsrY0lZOWVtVjgvWkJHMktZbEFaUnRuUk5RbitZ?=
 =?utf-8?B?NlBUcDQ4UjVNVk5TOG5RNEpVUjhra3BZLzRyMEgya2RIU0t4Z2dhSUptRG1x?=
 =?utf-8?B?NTNBMVU3NDdKNnFEL1IrTEZIUnZ0dWd0ZFp0bEIvME9xemQrb01PQ2FYK1Ux?=
 =?utf-8?B?VG15MC9FdXAzVEhuZ0VKQVEwSHFiM2lET3BxSCs5NFM3Ym1keFJqajBGM0lV?=
 =?utf-8?B?YlVYTzhzV0UvckdET2l4amV0dWZmUi9uZEtDTFR3MlZ4M0xhUXQ2K2FPY2ts?=
 =?utf-8?B?VGRScUljNkFuQWRzcVpGeVFtMGNrNW9ldzIvRm5mdWk0eFFnSEJvZTFRbGdi?=
 =?utf-8?B?K2xvR25uTldZMGROMmpsT2J0VTZrOE9EN203YVR4RXBmNHVIRi91dk5IdnJp?=
 =?utf-8?B?dXgyWGJLUmV6MVd6OUZMczlvWThMd3Voc1NSK1p4dkZhWW5kZ2RISmpLTk1s?=
 =?utf-8?B?c04rYzNvcCtwOHNYcGcwWHJCNGxURmJGYVR6Q2N5aWZpY0VCYzJ5cmI5eXpq?=
 =?utf-8?B?NVFjV2VSeXNySHEzSmdSS01tWlVVblJUL2R4MUZ6aGVZc2I5VTZNNld4QXY1?=
 =?utf-8?B?ajIrRU9vVG1ZdUpjM1BMVGh2aUlpeDNqTTB5aUFLblhCa0NZK3RQczJtZVV0?=
 =?utf-8?B?UDVrSFEyV3hrR1UyV2p3dFdvdDVacjRuci9OWEtnYUpaRWtwRjR2cnRkSjVE?=
 =?utf-8?Q?mgoLjJPxlyQze?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K2VyTS83ZERxTEloN0p6cUY1NSswRnRuQkxkZXZUSlgrb3RDK01kSG5kVmls?=
 =?utf-8?B?R1JLcGVOa2FnQStRRTV5N2tQREpxSXU2UXpZNmtSY3k1d1kvdUMxVXNOQUJQ?=
 =?utf-8?B?WUVLM0ZCYUpKdjBrdmpLWXBDMUtuRDNjVzcvclF3TlhNMjk2alVnMTYyR045?=
 =?utf-8?B?WTRmNmc0YmN3TWRkSFlieC9uMnZUeHNUU1VSVFIwTXRZS1YvZW9OQzNKNFhC?=
 =?utf-8?B?SXdXbHlhT3BkVkFtWjg3MmZlUWU2bnpuVkRKN0tNRTNrOGlEUmhNZ253czQ4?=
 =?utf-8?B?eFJ5cGg3UVp0ZDZ0RDZ6R0RuL0ZCb2hjNXhtM29zbjQ1YVM5bUhZNGJwNXYz?=
 =?utf-8?B?NlpKcHlyemwzdTVOc0d6VlBRdVVvMm1kaG1tV3Vhbk13aFNzdS9tNXk2bmNK?=
 =?utf-8?B?Sk93NlY4ZkVvd3pSRWVDMjNOUlhiRUVpY0srU0dZZlE2V1hxVkFYdVJpdkMr?=
 =?utf-8?B?bTRJMWJabTluL3NSQWNycEV5bVR4c0F6WTVRWk5kZzE1cndSUkM2WHE3eU1Z?=
 =?utf-8?B?ZUZ5SG1BZlZ3dkpVbm9KZ0JWZmhOYmQxSFdyeXhad3BTZDA4L0lPekN6UnhY?=
 =?utf-8?B?RVg0MFhwdkxUQ2JhRlZyQnFCTmxhWU91N1YwbENuUzBjYS9PL2dwQWhPZEtV?=
 =?utf-8?B?UlZGeDNvVlJFQlFQaFArNW91K3F4aGtJbVNFM2htenRiOXRWS25TalhFdFRa?=
 =?utf-8?B?bThNTUtIaDZLbVNqMFVNcGZPNTJzS0xJMjlSMmM5Ui9ZS2dUZGdiSEJvYjZk?=
 =?utf-8?B?S3JmcDY3OXNiWmVYejdWRG4wU0JUYXBpZDdPMHJIaENTR1dZQ1dGejlGdU40?=
 =?utf-8?B?aEpZcklnbWRCZ1NNb082RVd0T1lwNzJqcTg2M21DVnY2MVo1eGczemRnMTln?=
 =?utf-8?B?WVRSS1RPVloybFdiNkZXQktuKzh3UmxrcFphR283RkhSN09pWkxVajNTMndZ?=
 =?utf-8?B?RmtuQk5XRTlYZWpyRmtNa2pzVkQ2MEFuOWNZd1FkSUsvSXo2eWd4cTlKbUVK?=
 =?utf-8?B?U2JNQWRGdURGeVFTaDFzTHpoNDlUMXAzblNMakxuZkRxTHR3T3ZjMmtGWnNI?=
 =?utf-8?B?Q21pUExWNmUwMUM1MHpzbnIvSnZTTHE2dkdpaEdVL1FMUWhTNjFZTDA5WG93?=
 =?utf-8?B?UytDeGg5ZjlFakxVQ2hKNytON1owcGdOdmpJR0xZdU5jdzh2RENMRU10S2Y4?=
 =?utf-8?B?LzFNcGdZYW5Kb0R2OTgwS0QwcmlyTWkybzJ6ckIyVzB3eWVDa1B4SXl4cDB4?=
 =?utf-8?B?R3habUN3NjgrNzBodTJxNHBKaUxOOVJjSW5yclhicWFhekhYTXBoTnFyYlNK?=
 =?utf-8?B?Qk9Ub3dzZVg1NE9GaUNvaXc2eU5YMy80TEFENFRFbThiU3dqV0JaNGY4eTBZ?=
 =?utf-8?B?cDFOY2l6ZWJYZThPYkE4Sm5NbWJzWm8zOE1ueDVIWmxybXdSNlZJZi8zR3Fj?=
 =?utf-8?B?dzhubEtUQXFNVE5Wb0Zid3c0MUpiSXZzUUp0RGNJVlR2NUJGUys5ODBqM3VB?=
 =?utf-8?B?a0dGVHl0MHNQRThOWUJuWExSdGRSREVaZDFtc2FZT3A3R041Z0pwQ2RlZkFo?=
 =?utf-8?B?bUVrU2tKMW1JYVpYQlUrejhLTjV4UStnZE5JMUpMY2FTb2dEU3RqbHhTT1R5?=
 =?utf-8?B?ZHhSTlc0a1crYXg2Skp3aWoxUlFvc2svM0NUaGJ0a2NuN1NnaXVRejJDdDNh?=
 =?utf-8?B?QUhNaHhzMFVab1hJRkVmMW5XZzk5VllsOHMrd0pKVEpWVFo4MUJjejVLKzJZ?=
 =?utf-8?B?REp2dktCNVNsOHJWcjJaQW5xa3NWVXk4UHdIcmFCQk9NWTRHNHFadTY0YzZW?=
 =?utf-8?B?OEdDd0hDYTQyVjdqZkQvRWxuaWcrQkxEQk0ycGM2eWVuZEpqaVZDRDJZN2Vp?=
 =?utf-8?B?ZnFUOWF3V21ZcVIxc0Zrc2FtNTdYOUdibHFHYzZvK0diYi9WbFRGaU1nN1Qz?=
 =?utf-8?B?SjFDQlJsL0tzZCs5RHhHNXhaVXRNR2NaQTEzaU1FMUYzejVNNkJLSXl5Y09S?=
 =?utf-8?B?STZpVDg4VS80T0k4dG1Ldyt6ZXdFdFkwY0RqeWZqVDRiMGJxZDNlekNSUm1V?=
 =?utf-8?B?cDNVaC91TlJObFpUMUx1RzIxWVR6V3Byc1pudzZqQnlEUExGVHd1ZjNMRWR3?=
 =?utf-8?B?TUFEVG9pck1HV1IyejVEN2I0QXBnUTRNOUZHbkhLdEtuQXRYR1QzREZUVVNH?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UgmIKxu/7FQ2/EfeyKkHIJAYlLN4avrGxxoKKv0jFxOhnKPuoe9lvQmLm6uXR3oZi1Pm7dx35TL1AEASOkqE/1c9cwzUxJnNQ/4kGtmCoTIGeh/KTFsO4OQxek/mTlZc1iDU7EBwuk5varnNWFrxXXSsQffu/B19L7H5AjmS6Hjlyk7815/7eOusIcbDr9CahD5CvNo7hgmjWnAzpGGJgROq/kt46CGAcwGiuqarbnEYudZkFmrHkEBd/gxeGHdQGf+5plXk1dxQtDOYsQF6l6tPAQhz2hHit/I6dQTiM+ccvWZxUoNgFSlowKWi8hOg+KwwcF0N1htXnDYb1q99dtOom8tzcCmzEhWjK9EVCQ8WmzdZjeSegGybpR+rwwbUaPrXHR+EAXh7ppeaezSRctjA0gL1Hn6eEvgdovgUbdKDBVCyC/eTUaei41NbSPwYtZLo91lJVpy5HDLjlpPUZkeTMIunQGTslW3Ab2tlCMZTJY/b3ICcXtPb4fkocPT+Rv90DS6x4yLQu6u1NKB3WvFgVZSfgz1W1Gw14UcDnGpKrvbMkFfQcGJZtI8gCNk947xt7no8la9QWYLBfZzixnwt2gZNRDH94tGYhNliXyQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 421ab71b-71d9-4c7d-2214-08dd2b90fa52
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 00:53:03.2518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfjopNuv6QHY5i4zXfaZ8xi1bnxOR9g4DCKwXPwJUuWFNdJEDP3ezPtSoa71cc1cguZdv6OHfk7WK+RPzKtTkVVKa3t/7z3zBOn4nZROfVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7636
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501030005
X-Proofpoint-GUID: b33BltuME660RAFBd-OQtkzHbfVKQgPi
X-Proofpoint-ORIG-GUID: b33BltuME660RAFBd-OQtkzHbfVKQgPi

On 1/1/25 6:57 PM, bugzilla-daemon@kernel.org wrote:
> * When booting into kernel 6.12.7, the external drive capacity
>   is mis-reported.  Booting /back/ into 6.6.68, the capacity
>   continues to be mis-reported.  One must now yank the USB
>   cable (or power-cycle) to get the correct size detection again.

That part is really strange. I wonder if the new code is not
resetting the device and the old code was somehow.
> 
> Here is a diff of the dmesg output when plugging in the drive.
> From (-) is kernel 6.1.122
> To   (+) is kernel 6.12.7:
>  scsi host12: usb-storage 1-13:1.0
>  scsi 12:0:0:0: Direct-Access     TOSHIBA  DT01ACA300       3.00 PQ: 0 ANSI: 4
>  sd 12:0:0:0: Attached scsi generic sg1 type 0
> -sd 12:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
> -sd 12:0:0:0: [sdb] 5860533167 512-byte logical blocks: (3.00 TB/2.73 TiB)
> +sd 12:0:0:0: [sdb] 4294967295 512-byte logical blocks: (2.20 TB/2.00 TiB)
>  sd 12:0:0:0: [sdb] Write Protect is off
>  sd 12:0:0:0: [sdb] Mode Sense: 23 00 00 00
>  sd 12:0:0:0: [sdb] No Caching mode page found
>  sd 12:0:0:0: [sdb] Assuming drive cache: write through
> -sd 12:0:0:0: [sdb] Very big device. Trying to use READ CAPACITY(16).
> - sdb: sdb1
>  sd 12:0:0:0: [sdb] Attached SCSI disk
> 
> I am attaching a diff of the usbmon output for the earlier kernel (good) and
> current kernel (bad),

Just to start can you tell me what the device is returning?

We hit that "Very big device" code path if the device returns a size
of 0xffffffff or larger so with the old code we at some point returned
a large size. With the new code the device returns only 0xfffffffe
(4294967294) (read_capacity_10 does a lba that we got from the device + 1
so you see 4294967295 in the log message) so we never hit that very
bit device code path and try READ CAPACITY(16).

I might have changed some behavior during the retries that causes us
to not get the right size now.  However, I couldn't fully understand
the output of the usbmon traces. Can you tell me when we do the READ
CAPACITY (10) what the device is returning? Is it returning a sense
error like UNIT_ATTENTION a couple times and when it returns success
what's in the data buffer?
