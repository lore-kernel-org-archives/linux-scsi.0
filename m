Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D121B261393
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 10:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758881335; cv=fail; b=MEp00sI6McHrl7y/FMO5IZyubYmaS0xO83mk2K1VrfGBe08B1SEvRLQo0LDMnsOBdfYwSNFLdFv8emXcmpVzG8zcuIFQFkGyOAFISbWfTalnSeryO+IBhkFCGmW7dot/zMUVi244dUrla6XqqxRuzj23KvgimQPa+69PRQHeNeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758881335; c=relaxed/simple;
	bh=Urs3cGQOCgHmc7Ks8+C7iBGZ5FSiac9dcA5fnCs5t7c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Oa2fypXY60WV0m1RrCEv0RcxfTlJn2Aj49mfhcP8AZaI/G5vSzMRLIUWxLElXJ3D4rKbJ254iRw2f3i1QPqlXDVKEw/aZ+jgT51FaoMbY0aePkAZnowZLkZKX7ETLgm54f/V4PutVwk6EbJIopu++qQbXgKe2hDIPPGz1ELj7Tw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hrXiPgK4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=StDbMuBR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hrXiPgK4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="StDbMuBR"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q9dpMS008261;
	Fri, 26 Sep 2025 10:08:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GI2eLrFyEywlUwoaCStCSXTshLxd2Hsm7aOmg/Fwhlo=; b=
	hrXiPgK4T2aZHgP8Jai8Lqu52tnudxIm6S+pU7z80GRi6XFRHAEkmDSNYVZiFG10
	qgynMm0YE2jADjyoK0RF7BNn9IhJDfdO1CUjionZm8BbEROg/QCSceKdnT/fq7v+
	UkQfuAH2lpyYJc494d5qEmh46RQpTxRE3HMSiHIQsZAHikxmt4TZgk8y7bhWvwsR
	QhUJSPZ2p99yje3B1CmrggAkeORwo6RORvnZhw5U+upnnTLZ7H1E60vRGLQu/29m
	LTT1AXLpyYimJhlE1OkG41VjCzURQDv8NpWAElMra/5CXlZEbkUE8P3cSnmZr4QY
	yFUs8FrvDlPnu0yxa7+NoA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49drcy01p5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 10:08:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q9wlEq004621;
	Fri, 26 Sep 2025 10:08:46 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011018.outbound.protection.outlook.com [40.107.208.18])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49dawk9prj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 10:08:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zQXdq8FIK9tOW08YF3MjQp/81KnlR810MzoZ5Eo+UJHIQN0KtdeThaFCtDN6s0Nj2sTldoYDsS91tK6/F9MKylJkrfMhfnWwqSTaFOszec0XyWEeVOUfAyvDBAxB2n7C4BvqTD5W6d9x8ET8mxfbg3x65cl1h/GSawEy7g/04NK6ds3xxqP0pSoij4qZb/eQFyOYy1aydCrW/RT7FeDoFFEhE0jh58QfQwTazCnUAQJ8i2uhH1W+80g4o2GoaVj4d1s7UmYporInIMf0zba632XJADqGakijHXrlAh6tplNkvVBVMtTeVmE8hoEFLr5h/Ty81x6Z2pWoPi1NH66EKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GI2eLrFyEywlUwoaCStCSXTshLxd2Hsm7aOmg/Fwhlo=;
 b=s69A9lkwHgY+GwbfpVUYWNcszSFCphiHzYefu2cRtcKglO2vOXRCrxnh31xILF1kzq1djphp/fCNotA1HjQRSvYyVsQFW/kMjPIqZfedpR3V/Igw/28y8ETus1E0/PejUQmh2yq8DqPGo6IDArmtxG3tkMKw7RB5uDzQqWJr4knyhtO+H7UNRmJPeU493Gv0C6lyT96tNV5I01P/wZEGlbd7wJczX1zSzIjRen2aetSOa3g0IZKUYq6RmVYLppSGiwbFyFTqf48RJBPvJPdcbZJLdNlY6T83VZ96L42RRUZsIvv2nTtaPDG1XkYPpUcJuBODgatgbWCWzPftQIDIXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GI2eLrFyEywlUwoaCStCSXTshLxd2Hsm7aOmg/Fwhlo=;
 b=StDbMuBRuW/pAwWAR0+Aov4bch6IlAGNpOHfk1e7DQHqIJVA3RNjvuVpL52WJonyn3bNvoSxOmYDgLRz6LY5n6o4C41oSz4JBDJ7jiprXsJxssyUXqHjOSYBOTPF3nutwF8nL9jmQdPz5z7m3wQ9VOHgyQ/IPR1DPVzCLmEjoMU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM6PR10MB4364.namprd10.prod.outlook.com (2603:10b6:5:223::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Fri, 26 Sep
 2025 10:08:43 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Fri, 26 Sep 2025
 10:08:43 +0000
Message-ID: <dab3464e-7f60-4843-aede-6c81a348da8a@oracle.com>
Date: Fri, 26 Sep 2025 11:08:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/28] Optimize the hot path in the UFS driver
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250924203142.4073403-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250924203142.4073403-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0007.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::18) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM6PR10MB4364:EE_
X-MS-Office365-Filtering-Correlation-Id: e749e4b8-37b9-408a-f455-08ddfce4ac88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NGhKT3NRWlpPcHNkYU1rczBMOWJFaEJiRVowbDA4NG9rMk1tb0dSblZ3TU55?=
 =?utf-8?B?NUVxZ0Y0TTlieEJDRXFGcUkvb3RzVGhMYk40SzhJZTRQcWdCWDFLc0xveWxM?=
 =?utf-8?B?WTY1dzJqN0ZjTlhOOS9UQ0ZCUTVEWWlIS2pyL29qREpKYmdCNGJNeGlyenFU?=
 =?utf-8?B?bDczZjZVMDVpODROZzZSWEVUNFBnaTNyT1V3WFBWbmlpWVovNkI2bk1MNmNk?=
 =?utf-8?B?KzRIU2U2RTFGU1E3STZOV2ZwenVJaXlLaFNmckVxVHNEK05zQStObzI1QU1Q?=
 =?utf-8?B?WmJ0R1I1Mm1OQWV6dFNDdjhSUVpWamxwVk9JYWx4TkdrNHdGZDRLOGFWOXpM?=
 =?utf-8?B?UG5MRTRQK1JRLzRwUmZJeVBIK3E3N000L2hjWlNvZ3FGdHk0eENCVXhVVGtF?=
 =?utf-8?B?MDhaV2ZCWkhQZTNQSGdoMjRVRUNXYnNtMFpTUUZPQkc0N2xKd0t5S0dyTVRp?=
 =?utf-8?B?dlJSKzBRSHp5WHRtZkczczFBUmp2SkZVUjU0K1JPSkpRRzJVYjlBVzlvd0hY?=
 =?utf-8?B?UjYyVzVxK2k2WW1lR1FqcmdTYy9TbDhoenZ4Yzh6LzB4dUZ1ZFZ2U2lzQ2ds?=
 =?utf-8?B?S0hiTVBxVnA5Q3JteU5rV2xFekdiQTFUaWhyVm9DSFRZNGNRKzdLQUdwUk5y?=
 =?utf-8?B?R3g3QnpGMUpwRWdHZHg5MG5zcUI4MDA2QVJDUWtCV2ZNc1V1TzJoeTdTSmZj?=
 =?utf-8?B?cjdvMEVDTDRvcXBuL2UyZ0ZIWXJ0QllEMmJUQ3RwNTZuMTV5RzIzQm1CODYw?=
 =?utf-8?B?cEloRnVmU3dndjJVMHYxNGVQS2lvdU9sc2wxRER3alo2dEZQZzZlVGVKZFpj?=
 =?utf-8?B?YW95Z2lhLytXOUE4MFl1c3lXSmI3YW95WHp3ZndlL2dkeHZERFIrZlVGRmxN?=
 =?utf-8?B?b2Frem5rTTFJOHdXUWxyNDNiZVluWXJVeTBDMFd5bnhKenI5ZmxVVWJqYnVQ?=
 =?utf-8?B?bTJ3S0RWaHprV3NPbkNWRHVFbXdwQTA2WTdOWmtEVmYxdzZ4Vk4yRlhQa2xO?=
 =?utf-8?B?VXZUdWMyMEpweUM4M2JTNFgyVGdXZlFrc2l6Yk1QRkMySFRTaWNzb0lCRzU1?=
 =?utf-8?B?WktSenBKL3gvU1JxTk9lZERDRkx6OE9SZE1SZFE1QnJHT0d6SFpmcHRYSEI1?=
 =?utf-8?B?L0poUW9tTDZ6SFk0RHM2MWhNMG9QdzFlU3RoZ3hzNHlXZFU3bWJOTFRDY1hq?=
 =?utf-8?B?TG51VkdteWIwWGIzenlESHFOcmJwcWh3ZUQza0lJOUFrQVZCL3BPWjJpcHVu?=
 =?utf-8?B?QmFTQlRiVEhhQU8vVy9YQmFVeHlEM2theWtzckE1eG1GRm50WTJHV2JoTVZP?=
 =?utf-8?B?NHl2KzJtVWtqR2thNDlOZE5YQWRuRWxvdXRkUmdmV282TERjVHJZdS85UUIx?=
 =?utf-8?B?ZGtld1dNWHpQdnVlUUZaM1BYOW84M2ROR0IvRUN3QzhQY2E3WXBzTExRbDRO?=
 =?utf-8?B?NFp0Zmw2TlN6WUlJczR3WGVsQzVDcnh4YXpOZ0ovcUdkVmdGc2I4dm1TTHIx?=
 =?utf-8?B?UlhUbjN3alhxVUdJNlVJUk5XUm1oazVqS3gvUjJISkZOcjlNSUtDVmNwN0hH?=
 =?utf-8?B?NHZ4MithVDlSYXBDWnJ5cHV6WEpSWFd5eVBYa2NtU0FGbkN3YldGRWdkSjdt?=
 =?utf-8?B?aklHYnlrNnBsYU8wQ0NyZm5LM2FTMjJ3aTdlNGRCOFNuYWQ3S3pSZy85dHR5?=
 =?utf-8?B?ZDNxbEEvOEc3MURkYjcyZTJSTktoY203R2EzTzI5SDZTYjBHeUlJeHlodHlx?=
 =?utf-8?B?b25XcGNjT01ZWENYbXduSUNOUy9IbWppcUpsaHhISnNPNFZEeFpUdDJ2TWlG?=
 =?utf-8?B?T2tGWWE2MHRoSFh5UllmYTVWcWxLUjQ5Mk9HcEs2WHNWbFphVG83TnYrZWsx?=
 =?utf-8?B?U1hiSkhDOTZlUVVOSFI1L1o2NGRTbklxdmQ0a3AzRHpFdmVkaTB5SndjSkRm?=
 =?utf-8?Q?YtQYHhy9cEb1cPT7ut1s7TEoTAPqU/T8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHE0WVVSTW5IVzBqb1NMQURFWXVFMXJUcTZ1VGFVTTVtUWtTYldib1RaMkc2?=
 =?utf-8?B?aVFNemlRZ3Y3Q1NwTWdHQ0RPTmwvWExCRVJmU0dGbFdFWmRyeERSdTJJSk82?=
 =?utf-8?B?SlJTWUdCTGZza3RTOElPK1k2WkZoVWRVOENZN0ttc1JNNFFhaHJnemtHRlE5?=
 =?utf-8?B?dXowK3RoZUpkUmkyQVBhcnBVelI3SWRFbHhDVFZ5dCtpcUJuSUNBTGI4MFNz?=
 =?utf-8?B?dEVybnBVYkFUaHQrNWc1TVRqRUpMM3VVYUlkcUZpenhWempvV1p1d0FiWkRz?=
 =?utf-8?B?N0dGbGZnZ3N0V3FsVU9nd0c5ZGxKQnlIRmNBUHd2RDN6VUxCazRvSTBUcE1y?=
 =?utf-8?B?QmNXZ1o2d1NWaVJ4VlFQYVI3aXJxVFUyOURFQ1ViYjdrS2ZQb1JPY0Z4a3k4?=
 =?utf-8?B?RGp0MkdTMGtVZWtXbGJSa0lxQUxyRlJ4Vi8vQlVlb0pLNVRnZGJzc0l2aVhV?=
 =?utf-8?B?OCs5REpMRXJ6OSt4eFY1cCtxNTNjVElHRUg2NUVrVUpERlFRUXNCZjN0d2tO?=
 =?utf-8?B?SzAzVnRhR0g2bS9FazdDR3F0Z3JoSDBLNXFnUkVIYWNRTWw3U21HcG53Tjdt?=
 =?utf-8?B?djM5SW82TTBLVXl4UW1McmxCRUl3SW5OMFlBdFgwM1JCdGIweEdzK0h6R0Rh?=
 =?utf-8?B?MVJ0S3FNODhEL0JTRmpFQkJCcjkyUkJPcXFHK0IxclMyeHVLSkdrRngrRW9h?=
 =?utf-8?B?ZERCd1AvWG9NM0h0MFVHYXVKYU1zVktJQ3NyMlJhREJhZ2pLUXNUeTVGY2ht?=
 =?utf-8?B?N2QzMGRpTFcwMHU0OHpXQVljQk5NWVBMMjR1dWtNelI4bnl5R0dTWGNGRUJW?=
 =?utf-8?B?L1dmbmRabGswRkp0SEZzYmNPUm5IL1J4VjNZUkx2aHp2Ukt4OTArcHhlYm1D?=
 =?utf-8?B?SU45WFgyWEhEbVY0TVFuVGNKZ0pwZ0RNVDIrZFlpdEV3VjhDQTRKRStKdURF?=
 =?utf-8?B?WEhGT2lJN2h0elg0OTgvNVR6OEhURHJMRHVHZnBYMnp5TmdpSEdwbmREVTJ5?=
 =?utf-8?B?TDZXNDk3UFpTZ1g3UlhxVDBsS1g3Q2hTcGsxMEttUkovdW4wakFMYWtScW1o?=
 =?utf-8?B?MDYrdFVoQ25UcXV0cGpFa01TUlFKcjVlMFdhN0dFVksvU2ovSnUzejM5eFdB?=
 =?utf-8?B?SFd5VXFtT2ZlU1hFSEZvKy9FQUZicWVlazgrWEpjVFNXMEoxaFpuVDRSWXRh?=
 =?utf-8?B?WWlFa0lOTk9qOTUzS1AySXNZZFJpL21mYThVak1qZTFUK0xmUVdGVVc1TGR3?=
 =?utf-8?B?MFoveXFzRlZrN3V2NXVDQ0M0aTdBZHpuT3czZit5SzBvVVlhZUFhTTREdjNU?=
 =?utf-8?B?NlBmVzUyRGlubVIvTHl4Z3lRTkxYamtNQnY3Y0hIeTYra3hsak1ib1RzM2tZ?=
 =?utf-8?B?QXBPL1hEK0ZSbXcrNE5XZ21HanJqVmZ4U1FLQUQ0NTdWZGdGQzRWa05yeFhw?=
 =?utf-8?B?N2F5ZVNOOTNjVnRlZm1DN2Uvcmg2M0k3YWhjYWd3dElRYk9kU0taazE2TDRR?=
 =?utf-8?B?d3VRNDQvbGk0Q0ZobFJMMTlzZEFvVW80aDVybk12RVdaeDZUcXNmbk9FLy9z?=
 =?utf-8?B?NEllV0xnUGt6VHdIUXVYSmhxVTZJU0RrQlJTU3M5eUFPU1lZbG5QTkNqelhw?=
 =?utf-8?B?V0lCTVd1MUNJLytIdW82OERacVYvRDRtUWZYWVVSZW55VEhBODVPb055MEtZ?=
 =?utf-8?B?NlFxWXdYVmwwTUYwV0l0MW9rNnhZc3VmdXBRYmgrMVhBazJKclVpQTF1Rnox?=
 =?utf-8?B?V0lxM0ZDRDg0SS9IbjhNUWNxQWk4MTNYbTNOOG9Qa0thQ0hiR2R0MUIzbWpw?=
 =?utf-8?B?VUkrSld6ckE0UWQvWUhNaVAvT0ZBRmd6bVAvOFJtbys5OE12TjBXU3hTSVpO?=
 =?utf-8?B?Umg5YUg2MUJFVHFwalJGbDdWNDRIM2ZxS0x3UnBTK29QOUkxWG5MZmY5d2Q2?=
 =?utf-8?B?dUpPTG1VbGZ1aTE4c1IwMEpuYm1CVnBOYTNYOU9XRnhWV3o5QU5idW14QkYz?=
 =?utf-8?B?MThlMkF1VU9VQWdPem9hYnJLbFRWMVk0SXlmUFZXVnc0ZVhNamtLL1V6WmZt?=
 =?utf-8?B?L2V6cHlQcDNUMVVtT01wUW50cFBuLzllTWFPVyszTmtIZlpxVzBrT3lhTTBl?=
 =?utf-8?Q?JWPdhuQxcHpVfta3P3kK/vuHB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/ilZFDY3qGv+YXZVgnstug7y9mnQSRwRUgp4l1Wh/mFcoYy8DBOqRnNuuzn5BhhNd2ofKkGSVdXyP/7ERjCjunHVe98Dq4oPl5FZsgKwvi3Iv2ABpoyJa32SU4yEJhTOrV0VmW/sSlQSwT2oetEO3cHPVf4ykV8atlBOC4JZVwmCfHWGQIYsG0oj3fq64dumzrSj4PxP4C8T3S+fbPiGeqHhPjUifIix0BMf46reWFwg3Hp6tVgfBj4tNJl8rHadkW1DD2dnmVWWc9OlPOVym4gklen/DP42QZ6n5nK4Mi2u4Xb17QRYGgr2F9BZWU4H2lTx7JJmZ2C171PUzIgI/CZkhZdfp1yMfRmSTom3V1h+kIoaJlW08qmsaj+4zapKPoBIX32G0GlCgrNn1npyj6rwuPyUGTRlrrRXL+lZu2JUVVVpEoT4jvMQbbCIJoaXxZTR9WljEjA+cvVS+vXzJ+SlWGmLRBbtSjNtFs8J9LvKugNPXXg6fZ4NrtksnY6iFGpT0AlZduZ48vp0TncRBdxHWmXkyY9wRSBxYr+elkypLM1TyOtVw3iiYVo9h7m2FsweTmR65skw01cHIWLs8PDMuHtirdYf40nQropbtUA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e749e4b8-37b9-408a-f455-08ddfce4ac88
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 10:08:43.6713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bRXkz68/pjVPzuIN7CMopePf+jtUy+cLbHppPRfBky4PF9l0TN8Bua/2YuFdxKBSxm/9LOHfzK/+Uvr/r6KbaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4364
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_03,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxlogscore=860 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2509150000
 definitions=main-2509260093
X-Proofpoint-ORIG-GUID: FwivjlOvKbBGmUfOSr1TBC2hYI62VQmt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI2MDA4OSBTYWx0ZWRfX6gP44IiBykx2
 z/cutoYdHGgOBO/p/lz9ctAOEUVau8YYLYPWtkOiUek37i3JxeDo//8PK8mV11FbAvyxwsLuOeQ
 dGGyBGNB4jfLeNYyeSzQ1bidWV9enRvRqXhagCK/1eOJWxKsCJtmQo2NwIyAz6FRxZNhs7aks2E
 RFPEkO5SyAw6rGXp/VN1jf0slYFW/2ZG7OIcz+cC2efxdC4in8Hq4frN/GcPpv0oLq+h1FGTDLg
 ME56S91VmIRtC9SI7BadhiERZrELfv+dxJQxhMLdJtcsfzD3vJn4XnRljgL2TtMMHYNxV15i19p
 A8U1n/BK/5vlkfsi4yLLJYAcPA8aFdy5WjrCz0MsY/mRyo7j/JcBTSKbjZZDdId9mKa1ODtjQMJ
 9RhcMUv/0DCcygrChkO7yTCPglNUvQ==
X-Authority-Analysis: v=2.4 cv=JaaxbEKV c=1 sm=1 tr=0 ts=68d6662f b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=ID6ng7r3AAAA:8 a=LFVFpfqQI1mq7hhNV24A:9
 a=QEXdDO2ut3YA:10 a=AkheI1RvQwOzcTXhi5f4:22
X-Proofpoint-GUID: FwivjlOvKbBGmUfOSr1TBC2hYI62VQmt

Did you notice this when you tested?

[    0.927347]   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
[    0.930065] ------------[ cut here ]------------
[    0.931137] WARNING: CPU: 1 PID: 1 at drivers/scsi/scsi_scan.c:228
scsi_realloc_sdev_budget_map+0x163/0x180
[    0.933292] Modules linked in:
[    0.933948] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted
6.17.0-rc1-00143-g67ede8ca8ab5-dirty #1769 PREEMPT(voluntary)
[    0.936317] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[    0.938683] RIP: 0010:scsi_realloc_sdev_budget_map+0x163/0x180
[    0.939955] Code: 45 39 ee 44 89 ee 48 8b 7c 24 28 41 0f 46 f6 e8
23 df be ff 48 8b 7c 24 08 e8 f9 99 85 ff 48 8b 3c 24 e8 90 ed 8a ff
eb ae 90 <0f> 0b 90 48 83 c4 30 b8 ea ff ff ff 5b 5d 41 5c 41 5d 41 5e
41 5f
[    0.943854] RSP: 0000:ffffb29bc00139c8 EFLAGS: 00010246
[    0.944950] RAX: 0000000000000080 RBX: ffff89bac0a53800 RCX: 
0000000000000005
[    0.946515] RDX: 0000000000000003 RSI: 0000000000000004 RDI: 
ffff89bac0a53800
[    0.948019] RBP: ffff89bac0a4e000 R08: 0000000000000000 R09: 
0000000000000001
[    0.949521] R10: 0000000000000000 R11: 0000000000000008 R12: 
00000000000000c0
[    0.951038] R13: 00000000000000c0 R14: ffff89bac3d09828 R15: 
0000000000000005
[    0.952537] FS:  0000000000000000(0000) GS:ffff89bb47fe3000(0000)
knlGS:0000000000000000
[    0.954258] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.955464] CR2: 0000000000000000 CR3: 0000000120e30001 CR4: 
0000000000370ef0
[    0.957001] Call Trace:
[    0.957547]  <TASK>
[    0.958087]  ? attribute_container_add_device+0x4b/0x130
[    0.959295]  scsi_alloc_sdev+0x27f/0x360
[    0.960191]  scsi_probe_and_add_lun+0x1e4/0x2f0
[    0.961203]  __scsi_scan_target+0x104/0x210
[    0.962157]  scsi_scan_channel+0x54/0x90
[    0.962942]  scsi_scan_host_selected+0xcf/0x100
[    0.964420]  scsi_scan_host+0x19f/0x1c0
[    0.965289]  sdebug_driver_probe+0x1c0/0x420
[    0.966317]  really_probe+0xba/0x2b0
[    0.967171]  ? __pfx___device_attach_driver+0x10/0x10
[    0.968308]  __driver_probe_device+0x6e/0x110
[    0.969286]  driver_probe_device+0x1a/0xe0
[    0.970232]  __device_attach_driver+0x7e/0x110
[    0.971276]  bus_for_each_drv+0x8f/0xe0
[    0.972183]  __device_attach+0xa9/0x1a0
[    0.973080]  bus_probe_device+0x88/0xa0
[    0.973973]  device_add+0x61c/0x810
[    0.974805]  sdebug_add_host_helper+0x1ca/0x260
[    0.975843]  scsi_debug_init+0x341/0x7d0
[    0.976770]  ? __pfx_scsi_debug_init+0x10/0x10
[    0.977801]  do_one_initcall+0x55/0x220
[    0.978706]  kernel_init_freeable+0x199/0x2e0
[    0.979744]  ? __pfx_kernel_init+0x10/0x10
[    0.980688]  kernel_init+0x15/0x1c0
[    0.981765]  ret_from_fork+0x80/0xd0
[    0.982710]  ? __pfx_kernel_init+0x10/0x10
[    0.983689]  ret_from_fork_asm+0x1a/0x30
[    0.984742]  </TASK>
[    0.985223] ---[ end trace 0000000000000000 ]---
[    0.986231] scsi_alloc_sdev: Allocation failure during SCSI
scanning, some SCSI devices might not be configured
