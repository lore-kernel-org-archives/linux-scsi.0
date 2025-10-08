Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E2C19F137
	for <linux-scsi@vger.kernel.org>; Wed,  8 Oct 2025 07:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759907038; cv=fail; b=sHqwMH3h93JXr+bCOi68VNMoaGgRCFvg2yTpeJ1YGyncz8sLPZ0Ecu++n2HR20uT8lSzNWtTQhRrxp9icWq9chmLrJJg1+20P8kzh+aXSa6EvsN1qOCTtvo3GtONuendZ8iH0bBX56H4sLEjrmEmNNfQvjgJVIVPgKpPHVQo7tw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759907038; c=relaxed/simple;
	bh=5x079S/62VPhormZq+6fC+/qKs+U/WhwOjv+5TpGMDQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nr6+kfxY/veZH3IXmvKgsHFPuej8bCFxt5cglt1Wj+BUb4gnY18tZnwlwZ7BlfxoclB8m7cA0Q4GbqV0eHpivlpeutGUtMFIazvrcxkjn3lKuKqFskn1xG5G+LDAFeNR1W30w4vCsLd7ItGvn1CVhH/p9Dt506vI+3JJ+KYqa0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TD8b6LKc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kANOFhUT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TD8b6LKc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kANOFhUT"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5986sk6x020135;
	Wed, 8 Oct 2025 07:03:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6cg08fkndHJMW2VLB9SUS9FYOssMB5tkOzyEl5rpkWw=; b=
	TD8b6LKcC2f+e3PoUXAt2EkkzMbdwsMlmVHLKtFg86ht37hnfkzMG9IJYBDmIEzE
	jPGxPBrhaJQOhtnUf/HBiHTleau2TVCWLGoMtUGrLCEAd+Sd9lsG71UYlPdi25Ro
	HBSotWAAmQIFCp37EK8Y6N3ogRn7OA9vzpSd9ow+fD+lZj3Hqb2mig66b8WRoeXt
	5DkQZKelagtINaqx4I4TvEJYJ1EDRGXsuMNWojcHzooccQ+9lGI3gwiWjVKa6Qce
	fnxXSMoJTGIzsmPUp/Nh/gKpz/mUWtKbMKlqo8YHBJfy3Vc0napYNIHY6Ijj70T9
	wiJBKod6voPw2jQziHBGwQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49nk3n00bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Oct 2025 07:03:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5985csaq021390;
	Wed, 8 Oct 2025 07:03:37 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012034.outbound.protection.outlook.com [40.107.209.34])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49jt19fc50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Oct 2025 07:03:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xnrtTL/cFAcG9L2MCyLjzrHZx8z4xvmJNa6S/OdZyDR9xc6NkT9mr7zYP8kyYNgI5+e+IvDa2Ai16sQuuaAOoA2lpV2HU0jhCcAAhtTCW9ABty9DwfkNf1ncuNQMnsbjt8/znWN+5pXZ95e4bkwe02RU5ivVd/DtQjw7SQKdenKElnjEK7vbKM+VlOF23V+R7IN0DOgq49qKuz5Ez25WlLOqaq2QF/tP5EFtLzQcerbF2bOscGIvVtF2aQsxnlrcS9HgNdfApeo2OTlA2l1eGND/kSYC0bfsEQ8ql43i6TKmiuMTk24IAw75+5ckmlDyLnM+g4wInt4snrxzx/qn2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6cg08fkndHJMW2VLB9SUS9FYOssMB5tkOzyEl5rpkWw=;
 b=auqFaYLAPYvaDMspgGohX5ByogcJa91Zci9IThKYAlGC7IZyuBh2TFEZ/cb/zewbFJe1Qwz5W7qSoYPJ4mv/lyeH2AgIpVv879j9W02qdzSeHl9vfU8IoIqA77uRhh3f20mgBcNzeRAWe/ZXxHE83uug3fvY++xIyewH9E/ry8wZqacmeOF8t8lc0JJsoFf0eSeAUw8z4JO2pXR324Y8h+zAgQQlCLQjBK32ELCWsD6U6r5HcDwALVUEsJFT4qc6ee3yRUxTnqDQXa30s1jLhzsDSj1ulFt7KGLeY0szTNOpxW1tx5opGTcqg6hZEJk98Stktl6RffPrc2dz3yFsfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6cg08fkndHJMW2VLB9SUS9FYOssMB5tkOzyEl5rpkWw=;
 b=kANOFhUTa51XGQM7b8R2Mkc3PpUB66/MmT8nbNao/JDs4dKGSb3fwIcG3Ab38Ce1AiIclP0wD09P3RbY2r/FMDJ2fZ6Y0Z3kmCTRlHtdHQhvbPvhsXI/6PrqAsxH//APHCnGTJ/HhyTnokhlfQEb6rBP6eBR9as22FAVK5idcio=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MN0PR10MB5960.namprd10.prod.outlook.com (2603:10b6:208:3cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Wed, 8 Oct
 2025 07:03:25 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9203.007; Wed, 8 Oct 2025
 07:03:24 +0000
Message-ID: <3cea82dd-197c-4aa7-9a9c-8908d2f41db8@oracle.com>
Date: Wed, 8 Oct 2025 08:03:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251007214800.1678255-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0129.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::21) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MN0PR10MB5960:EE_
X-MS-Office365-Filtering-Correlation-Id: 37af4f9b-3d14-437a-d126-08de0638c5f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0tyUE54eXJXQXJGOTBLc3hobm9xNHBHVElvYlFVZndrcldDdldSOFB1aXYy?=
 =?utf-8?B?MGQyL2s2K0tjNUZGaFM1UDg5WVVwRUl3dU1SdlFTS2xwYVp0N01KR2JYcEVR?=
 =?utf-8?B?NTNJK1NzbkVIOEtwQVcveFdEZDV1WTVWaUtaalZRNW5wTEpMcGtocUJQTzlF?=
 =?utf-8?B?NXB2c1ZOSUdjU3Q0NmhmN3ZCTS9scnJOOEhoZVYxLzVNcURSVG1JV2VrYnhM?=
 =?utf-8?B?NE03c0VGUWVONHJKd3p1WTd4WXQ4M0R5anEzUGRSWVIxem1WSkh5dXUvU29n?=
 =?utf-8?B?ODBBd2I3OXNnQ1F6N3c4QTNxaCs1bGRlS2Z2bVEwMHFaYU1XRElWaWNsRFBE?=
 =?utf-8?B?a0VMdmprT3I4cnFpM0hnL1Zock1iNUF0azVwMWRkMWFzTlNzZTUvSzRzbHh0?=
 =?utf-8?B?QTBCL0w0YTd3cGJqVkFMMGovelJaclloVlFFZ3pZUUg1Kyt2OE1zbHlFZUFs?=
 =?utf-8?B?VWl4QW5LcXdmeFA5T3JiUXV1LzAwRFNsYTQzdXBGSStJa1FZZW9DS2ZvaU5T?=
 =?utf-8?B?OVdIV0RSYkROcXMvbkhnMS8xMzNyYUpRRzJRc2h4eE5lQjRuMGVYMEtTLzVu?=
 =?utf-8?B?NnRZY1dWdlRwdXRjYnUrbW43NVF6a0VnVTBmYjQrQVp3eWVJS0hSSVVUZitL?=
 =?utf-8?B?OEdiODZ6OXBSOG45U1lpdVBNUTh2TFJuNzlITUR0L2VKUDZiTnJyQ1lZMnRN?=
 =?utf-8?B?WUhUVzZQc3pQblMwY3F4QllxeFhibndGbE5zRUJGazlJSE5XcGJ3RWc3b2pP?=
 =?utf-8?B?V2FsQm56WHZyaVJhOXlJYVpWOVRxZTdwYk1wTTVQUnZMNmdHN1ZLSWlwM2M2?=
 =?utf-8?B?ZUV1REZJLzdHdVJENThTaFdXNGdOdDhJWXFvbldwZ3ZTVjllTzBvYm13clJS?=
 =?utf-8?B?elU5MjhIdEJsajlhaTIweWt0aGQ3OSt0eUpoMkowM3FYNzIrcmo3WHVRYXFU?=
 =?utf-8?B?UXlGRytLaFJRQlRRaFdhb1pMcjlKSTU5OEk3cmNoSEtMMldSVW44UkpldWRu?=
 =?utf-8?B?ZTdJakdoZGZNZHE1MEw5OHhJZCtWUVNGdXFmMUJGN01EY3lsK2VpWnFoblJI?=
 =?utf-8?B?djJVckx1ZnBQamRmR1l1ZGY4VTBBQk1NajNBMGdKTTdHMmYycDhGNTVrcTNC?=
 =?utf-8?B?bWRkWXFuK0Z6TllFNHJudWh6ZXVrc2Vhd20zNkV6RWlOa2I4UU00bnhCa25u?=
 =?utf-8?B?NnVMZUVWRUZYNUtvVjY4RzRUL2diQ2d4RW1XRGJBSjVnci9mRGJwR1FhYUEy?=
 =?utf-8?B?aFE0MkE5ZVVzKzNnZzcyQTRpTVkzWGlJbTZOOTJkSlFOTlRKczRpQUVZVUg2?=
 =?utf-8?B?YlZ6dGxBOFhrRkZxOW93Z0dyZDl0eWwrTEd5QVN4N1lNWWlvR3R6YmcxRnlQ?=
 =?utf-8?B?SGQxMVBPd2R0bW1ZdVN4d0ErNjEwUWRzOE5neU5TeTA3STlkRHRrMWRCK2My?=
 =?utf-8?B?bWw2RS82NzFiWjhIcjRtcFczdXViVFd2WEtEYTQwWHRZNVJoSS9lVXNPckl2?=
 =?utf-8?B?RWNKZnNWZ3ZNWEVlcU5td21henhWVlE0U0UwR01XZjczbG85TWJMVno5NHZs?=
 =?utf-8?B?aXV0bVpPNHNUbkk5NkRHelN0MExzQm16cDlGSDFlaWhOVFM4Zm1pVUhuYll2?=
 =?utf-8?B?eWlheFN3N3NOTUtYL0Y2d0daSGNzT0k2SHFiSXFrUUlObGlQNi9VTkQ3WUZR?=
 =?utf-8?B?ckdDbzJTV2xvZy9MVEhVUHljOHcyTUFUTVBaVE9VOEtoVElTdDYyL0puM0tH?=
 =?utf-8?B?cDBBbmpJV3FjZnJKa1hLU0R3ZEQ4YUVDWTNWTGhnS0RJYm9URzdDNitDaTNs?=
 =?utf-8?B?TXd5TVNRUktqUTAzdDRQN05FNDdtN0pZK3hSb1RKQi9NMUlDUm84SGdKdnRQ?=
 =?utf-8?B?Z1VZeG1JV1ZLZ3pQTzNwL1k2OFc4WVEva2JhQTlKMENCRzdUWnRBcDJqTmhw?=
 =?utf-8?Q?KbcV4g3zIHc4WwQ8drmKvMhi+WX67407?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TVU0YVF5RXFYemZ0R2I3SHZCeFozM2I4ejQ3MVhKSGU0UFBnS0lseGxocTlz?=
 =?utf-8?B?VWFVK2ljcEJROWlmendUK3oxWjdPdXYxMVJ2dEVQdW1zaFJBT3UzaGNYTlls?=
 =?utf-8?B?TFQ2Uy94bm5jMzRpZ201dDA5VEhvOFdTQVdBcEU5U0dEMGh0YjBJejNBRk4x?=
 =?utf-8?B?MzBwL0IxWVhaUGE3R3BtVkI4T1RpTVUzZ2loU2JqblczNkxWSDgxK0lhN2do?=
 =?utf-8?B?NmsvSmNONFR0MDQwMkV5dURlTW55SzhvTnNRUmRMN1ZIbVR0VmR5QjcrNlpP?=
 =?utf-8?B?YmxyVTVzNStzVUgxWVdVdjJsQ1lKRUtKSXRCQXFGWnYrMURGbTNiNVNPOXZP?=
 =?utf-8?B?RU5KOW5ERThNbTJxVjliR1hJTWQ4RjE2Z21iSnV6ZDdMWHRYZm92MXR2UUdy?=
 =?utf-8?B?ZmVpWlZqbDg4NTk4V2RZelJFRWh2MkdUajI4R2QwalJnMlZCTjA5QTNtVzdi?=
 =?utf-8?B?V3hiL3NWeHFLcDU5R2dTZ0VPVVp2WmQ4VnB2a0JWcStJSEQ3bmZ0WnVOc3Ey?=
 =?utf-8?B?WnFLNmNCVWhYUitzY2VFeEZldmZhc3NJWmtacm1PdTllTlNNVzFmYnlmOUk3?=
 =?utf-8?B?L1daVTk5N3dzRjZFMG9CMW13K3N6dElmMjB4bzZwNnBVTlc2V0VMbmhRU083?=
 =?utf-8?B?b2syMFoycDVZNEo3VnlrOVdDRUdFNlBKQVdHeTBCVzNjR1FFd3krOWVUTkQw?=
 =?utf-8?B?cm1Oc1JIemVYU1RtWHpwTVAwRzRPdWRyNWlOYVhCT0pFVlpTVzVVS2phTVVo?=
 =?utf-8?B?ZDdreTAvbmR6N0dJWHlwN3BNcTRVVGs5a1BRY0t3UG1wTyt3ZTVVQWdwSSts?=
 =?utf-8?B?TmJQV24vZ3hpTlRyYUM2VmE4WmFRSWhvd2lDbVdBZ3BTODAxU0NYenlTMUVr?=
 =?utf-8?B?eTlLT2xiK0RmZGNVa0ZUK0YyTXFrVVBhVXF1bEREUEVDL3BrWTljM3liNlBT?=
 =?utf-8?B?Y2dHZVpMbVVJc2ZnUjhhQzQ2dU1SZGFWNmRiYW1qS1dMM3pYcnZBTnMwUnNN?=
 =?utf-8?B?KzdUcmZTdlUxMjJhc2tNNmk2MTlqakNZQmx5YVEyZ0JqV2MvZ05ia0RibVRI?=
 =?utf-8?B?cHYvMHJXNGo3YitJU2d0MDJHaVluUmNwaDhDTTZRc3FjZm9veUdzUVhmNEQ3?=
 =?utf-8?B?VUFaZmxKYUFKTWFpVGF1enFycmZqTEFmV2F2L3hCbFZiNHBLMWtJSTZEOEpm?=
 =?utf-8?B?KzI0R0d1UEFHL1dsL1Z2eWRRdXdyd2pleHJRdFVFZzBBZ2JpNU5zSmJOZStm?=
 =?utf-8?B?SzJnQ2NZRDVGOGxvQXVnM3lhc2YzNU5sY3JzTmQ0Z25hbjJYYTFBWUZMcG5o?=
 =?utf-8?B?STJEQUJkNlMzbkpaNDk2bWhjL1RSZ1E2Tjk3eUY3RlgwVzJETU9VVTRRczdj?=
 =?utf-8?B?MEVzL2VBQkFFQVNWTzhPM1JJVHFWK3hpNEZMcnRzMCtEMkhTS3BYNXJjQTZa?=
 =?utf-8?B?VEx3Y2dyNWM3UU1OUXV4aXJMYTFjZE9QeFA5V3dyQ2dLRGFueDhaZGtLcjky?=
 =?utf-8?B?Q3hKU3FJQk1aRklsTmRlNFJVYkFuM254c25uM3JlL1BxYzRCMkEvVkdwd1A2?=
 =?utf-8?B?R21rZTFEUEVBd2Fab2V1UUk1NFNkbVM3UmF1MHNjQmVSWUt5M2t2cWJqZi96?=
 =?utf-8?B?MWNEVGdodnZlWGNuM3AvOWo0Um1FTmoyQmVyalhsK1VSTWZMS2FCRytLdGdU?=
 =?utf-8?B?a3NKamppRUJ0YVZheXM2ZGVldVE5VW1EQmVtRys2N0wzaXZBcXZaS1dlQzZY?=
 =?utf-8?B?cVBqVG55amF3QXFubGY1aEFCNlhqbVNqQlowV0RvTHI1dUJXMU9selZhSTc5?=
 =?utf-8?B?bnlCVHNtcTF2eGxYRFZ0Qmo0akhkSFErSi9sOTl0MzdJUFBTaHJQWHJrc21R?=
 =?utf-8?B?eThIRlN5eGNRK0pDc2lOVEJjUXZzMUw2TGhSYzhhTjE4cm5VWmQyck9FK2ZO?=
 =?utf-8?B?aVRSSlJ1YW9GQmdxUHRqYWkxRVh3SWRyaHZJMldQbkgySTlhbTc4b3VVRHZQ?=
 =?utf-8?B?M01EMTNvSzdQdUpGMDBNYW1TSkdwQzd1ZDYxckQ2Y2cyemcwcmMvSHZLbERy?=
 =?utf-8?B?bDBZbGhjbStqaExkNkJSMktCem5STk9uUkIyRUt4ZUtrK1FzSjlHZE00Z25S?=
 =?utf-8?Q?qc0cZ+VH7VdhpIFjZjQDrMJGJ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LymZ6esbUou5f3yfwLibeKyUimHKEUwkWL7Wp9Al8NmUiACXOOKJBIcr4JlzCneBl9UMLDc3jB/auCnfY9O/g8BKN6dWGFYU8J2TpVw8fzeV3OSMiOAxYKR0cc96W7OBNLDfH5NQmzLDB0MtuxPl6n3q0rJTb0TrJnf4aV7CLbuGr/Qupu5qdBmFB1VCJtURa7+NeU/t2Kk6rOLVfJyw6HlQVSdUG5znd7oaedpm0VjEgw3wDSsWsprg0K4PH3SS+Zkp9+ShsMg0QdRpR7zGYnfcDPyV6rSLifuV8Oh/fOqTRsMX0rhJZ3QVw4ctZdeg6yJbjbRSQV/lUfGh2Eg5cLsKiK6h2eDgvfbuAwX0Rx0oKGtPnYYl863Kza+GIN9fyq+U/gRP3bhx4DJOKZpqxs1V4pEkdl6cRzv9Uxm62hwxbk6Um1SCvByXTlcmxABecdV2/zajiHGKcI8vFdkUFxO23IHqoqleX/Jp0DHwNQQAabbkwLfKJzN1o7HyVlGKXfH4zRg2Txrx+pUQk0QpQv/h+mq9QXoWLEc3O5sSfEwbMv+j4ioTD0fiM5eCx0M0UuBxGEia/39+zoRX3/i3GBIhZLAmvKy2crDyhJlpfrI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37af4f9b-3d14-437a-d126-08de0638c5f1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 07:03:24.6636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JxIPk6pBT3FAixpLxXRc8Z2m4FzFrEnKI7ygJN0SSxx78TsonDHw5ek/8bydeXLGVX+0HELvmW3QwsyJE7I4ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2510080046
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDA0NSBTYWx0ZWRfX9VTixhj/eXtU
 cpqNEj8MyZ6mPa6XA6OPlYmkwl91fi0CzzZxtc8e9/is+1L25JxNcWNcJn8XJ2uGFyJ1wBGp8zI
 020AxbpZIMN7x6q+Q+zU9LVGxn9nILNuDYZB5xfrfhPY5fVCyLomaPeU67pb8A1sjjVS78CBp48
 mK3ZKik2yDfX4T1VFOE/RwVUAJvxStxpEtRcPencCJtbUQ4BAjIT+Bop6Qk8kfXGy8nKO2fYXoA
 qNbrQYlIej6YGHyvU4xFIsZ+LXD77WXtQyWlVbLb1p9rdoZKDBqasc5euz9XtFb6bPWRBhcJtIW
 7xv+/1gau+0GNdeHRfu0Lw4OfJBATnA4LQU8yBkedFOQVdbACMUsfCy67sxk0rP9VYPvCaFc/4Q
 S+yd3FDI+T9PDN3Zht9keqjMPGiB3g==
X-Proofpoint-GUID: -j33U7YOh3rbaftBDewCiOIuJs6nqw6q
X-Authority-Analysis: v=2.4 cv=MvZfKmae c=1 sm=1 tr=0 ts=68e60cc9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=-8Vx-d5cZGwl6lyWjJ0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: -j33U7YOh3rbaftBDewCiOIuJs6nqw6q

On 07/10/2025 22:48, Bart Van Assche wrote:
> Commit 995412e23bb2 ("blk-mq: Replace tags->lock with SRCU for tag
> iterators") introduced the following regression:
> 
> Call trace:
>   __srcu_read_lock+0x30/0x80 (P)
>   blk_mq_tagset_busy_iter+0x44/0x300
>   scsi_host_busy+0x38/0x70

this value is readable from sysfs, so why even print it?

>   ufshcd_print_host_state+0x34/0x1bc
>   ufshcd_link_startup.constprop.0+0xe4/0x2e0

