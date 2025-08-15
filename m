Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A311A2C06
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 08:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755246881; cv=fail; b=XEqpZpwZanGyNmR4PcYRMItm7iBm/Hyhjq029W3CS4z/ENiFvadvcwFDiAXVUCHfM8d4tLZUyoRrhdKD9kSe9EQ3gANVzGyh9jfA14XVYw4tnl4NAvaKvEYzybxp3c00xw72wooYtABRc2sNw2tKyImutDTwZ2i/EVtpEB5iMUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755246881; c=relaxed/simple;
	bh=04UTNo2x7ZclMgzrd8Wsy0pERTj6gDmh2KzNqJiVKeE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hPypzsHvVUL2FRZE4TAn3XBtrlGi14RPgG1K8oh4zm9rlt3WFsup5VFjwDwQxqEqXBGwT6w2xEVTOQciFQO04DyF6r4V2fRaZSzOwlBpOI+E/utryGy0m3eI5DauHSikpMLrpRW5wMXgs3tlkCLZp8zk0oa66TSjdXa8EcpSY9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TRc+g4kW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FE6PBm2h; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TRc+g4kW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FE6PBm2h"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57F81ZPm002580;
	Fri, 15 Aug 2025 08:34:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=; b=
	TRc+g4kWIVSBmcERS/9QiDoVI2O9lAvewNB06DZUJ4boZwou9UQNfQmu13Fb85ep
	P9bsxddnYeR7pBw+xgYa+IXBUffRV5vyfupv1sH6bvQD4OT6xSWTNrq18lF2WYjg
	MavfyNch8K+hE0e1UGLxNoMpOQIvTag8bTWWpI9LD2kfrJD97ypNK3L5FNKFsOQJ
	beXnheEablhDY7QhErQmdkx2q5b/nLPjcSLQZl49BEcklmNJ06oEUJWAL6SMr5Az
	p1t8lcm07LckK5bu7PfTaXy8Qplfn+VkiJlRJJTFUaV0KDmfJoQ/LBdCIEm0DulD
	QhyphGt3GWbjX1fPLDLVZg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dx7duds2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 08:34:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F7CYLc038842;
	Fri, 15 Aug 2025 08:34:32 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsmaxsj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 08:34:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mzqmvOnj36rqHsdf2GGJm/FwAkm2bu47K9XLeEcLdKSp2+U14OJKphC2FUkXHdsRQCykOwmTHmm/63Sk3Noxy8IiencUgQ0PI+v3opLPFqPP+muLHdUw4AWzyH3pU8LPgXnInGT/y2X4IdX2yZnhWXwpGNRPjVQkPrjGP3lQp/UNjMUfmACmnwYwIRH/WjcGcJCqHnZrnorOKbbKCiByVAdVt6hNbNVnlA9C23CGGf0jMNZNbdOhkYs6L60Rg4Jy9ExPmqB4IORP9qGxNQt8K6je7F7ErLldvCJW+gjP4rW2eF19Ii0ntvZz1AcUF4Be68NPmZUDYt+hNzet0TzIag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=;
 b=riwCl7OqMQnhLwyycHd/Fpw4Sph3s8Zdzl2lpXQA95Lmmg02P7Hy7w1cgQLQLeXhUmTWhxxgH19rehyHLO5TJdS6O40mWaa2WtsoxBiNzWhG4viQ+jTGuZGJZTms0woGHtXnKEOVdXxLweX/CtfUf6ZNqJCiEZ7LgDUqxYYH2pP6RuTtwkbWHvVegld8TlnOB88TKRJKGsANiccFAYQ46NwXl/AWmCquiFik9HkJOUJJtxDr8NtpF8c4EWHlznJjHpLn80le+UX6GEjMGgpr9uzbNd8IdLTRL1M3hzqSPKZR2uaKRPBqa7vwfSY8rwD9TtbAQ2cH6ZhIcxRcYYvIDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=;
 b=FE6PBm2hQokwTNe4MMA8jQg9T4NYd/UVv1aLccJL3lBcE9J2rWM0AsLaQLulfRgV6VAsWavxnUEK9ui5j0fDE8vP4JzYyYgT/XN7KFtJAkgWgrI6lgILVWpwmwDhLsEiunGPoidI2eZB1PpL34QI28EVR+fR1tvoHQ5be+j66GY=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM6PR10MB4330.namprd10.prod.outlook.com (2603:10b6:5:21f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Fri, 15 Aug
 2025 08:33:31 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 08:33:31 +0000
Message-ID: <7bcf721e-ffd0-4d02-a192-33bf30226ced@oracle.com>
Date: Fri, 15 Aug 2025 09:33:28 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/10] scsi: mvsas: Use dev_parent_is_expander() helper
To: Niklas Cassel <cassel@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-18-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250814173215.1765055-18-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0088.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cd::19) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM6PR10MB4330:EE_
X-MS-Office365-Filtering-Correlation-Id: 16ee90a9-1db8-4a1a-5258-08dddbd66a06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VE51MzlvRjN6QTduN21vVDdrQkJoS2lGUHlKUXBzYlIwYWR6anRhUUVwVmJG?=
 =?utf-8?B?bE9XaEN6aklCNkhwSE1xaU5KQ0d5ekR0Zk1VTGcvc21hVEpVU1FzTnlnRUZl?=
 =?utf-8?B?d2NTSnhoWldyYUhQcUF6bU1sT2F0L0pNWFRRUEJoRXJXNjZ2dkZpVDU3eFJ6?=
 =?utf-8?B?Z0tFMitickxmNUpJS3BoRGlFNDE5eXJ0RmtrWitzWXpoTVducnB6NXltTGdW?=
 =?utf-8?B?TFJCYSs2V1NoRVNzVFMvQXJzb0Yxa2FUNzhGNFhnTlVCbHM2MzJwU3hnNFpE?=
 =?utf-8?B?YWVjRnk0dHZxSVl6aWRpaDYwMzE1bVQyTW04dkg5SVlFRkw3V25QSXNZZ2J3?=
 =?utf-8?B?dHRYUk11RnNWeGtyb0h4QzBDZXBDUVgxeDhTdjMwcmRYYXRJTmt6QWlyaitk?=
 =?utf-8?B?QjhVeHNQZWNTZ2tKSXBaU0p3ajZiVEdjOS9OUGN1MXFPQ2YvNDVucThDNVRo?=
 =?utf-8?B?aHArbHNvZUo4cVlqRUtibUFwMGRNaUpWRytNQ3F0U3J3OWd5R3p5V1JHUTVU?=
 =?utf-8?B?YWNQbXFHYTdsWk1DTFFKLzliSjJxNUsreS9Vbll4bmlsTGFVeGpBeWkvVkx5?=
 =?utf-8?B?eUc2bHdPUnFlVTlFZk9qQzZZWGVEWDhad3RwU0NCN2lwdHFGZXhYa1hPV2NG?=
 =?utf-8?B?QnFTYWp3SGJtTkZlWWNCT3NxUUdscnVuOW56UDRPVUkveFlsd2ZWN0N4TFZB?=
 =?utf-8?B?U1lqL1NQMDNWUStMQnpKQkozcnJ0cDcwVlVSY1hqcENTaU1QSDUraTNjNjNl?=
 =?utf-8?B?Vk9WU1JRNmV5bDVkY2ZGOHA2MnVDRHlNeXlDTDBlQmZCZ2hBaGZWQzdkUlI2?=
 =?utf-8?B?UTgzZHE2OXBHMmJlRWExL1FSN2U0NGxmT1VVSnA4aGVyMi9QUzJFNUl0UHRp?=
 =?utf-8?B?ampPRzNlY09RamVmYmtYejNWZlE5V2FoTTBRcWU5VHFwbytUaDFrR2FjOUFR?=
 =?utf-8?B?REJtNjF1WGowWnY2SjNQY1JaYUpNWndSS014dUt4MGJESW5ESXc0YWhNN1VM?=
 =?utf-8?B?VUZhVnc2R3NhajAxa1ZkTjlzZHkrd0NZclJESG5CaTVVaDhEMFFWa1RIMThI?=
 =?utf-8?B?WExFM05LaVZXNEI4bzVOUFBrbEJTcE1VUnNRQUlWNkRncXZ2S3FiMWpCeEJG?=
 =?utf-8?B?cjJISUx5M1BSakdGMUlNQ3lFRVFjRmpPMWpLUHcvT1JPZUJxelZLZTdRZTF2?=
 =?utf-8?B?ajJpUmxJSVluZEx2bmxOdFc0MjdoMk9kTUJkaVpUU3h3VndtREtJWUM0T3Yy?=
 =?utf-8?B?NHQrMEQrSWw3VFdxTnc4akIvVmk5WWU5aXA2SlhZSVBlcWRHVXRGbzlFQnBv?=
 =?utf-8?B?UDFqMEs2VmhGeXBRTEw0WW5vNkNsSlZ4Y1NqVUpWaHI3aG84RTFVTGVmbjVv?=
 =?utf-8?B?UTdjMXFKcHdhaEVpTjVrdXlSRHdYbkVYaVJlRHJ0ZXRXaUV5K1VqTkMxL1VH?=
 =?utf-8?B?dGVzdTJHZnBlZXJwR1RvYkQvcXY5U3N0aVFMdlo5QUFqS0JNbEF0L1RyeEdL?=
 =?utf-8?B?djdJS3BVelN1RFNzQ1hQL1RJNGR6b2thNCtGazZmTUhPMFJqUTIyWDJsbzhM?=
 =?utf-8?B?bG9qTis0QUQwREZxOHJxVm5aYXF0YXJDQnlUNnJOVDFQd0lPc2JFMUFTMlRs?=
 =?utf-8?B?NUpiREVOcUc5ZHJTOUFCeGphM3dMM3VDaGVtdmdBa2p6OEk2Q2JtNDRFNng5?=
 =?utf-8?B?enc3UUJza0lFQ3d1clE4NmVCWmlPdGpseVN2Qllmd0ZlU283YlFKNkhqNjNF?=
 =?utf-8?B?TktmNHpWZU1VM0NZOTB1MDU3WVJjQ09TNzBwMmJkeHNyYmdYMHNFb2l1STVm?=
 =?utf-8?B?K2p0dk5NWW1Ia1IzT1dxbGxOMmI5eWNEOUd5TjlHWXYxWFd4WlBLbk5aTVZY?=
 =?utf-8?B?SGU0Yy9xRUxWa3dPbVltdDZjN3ZieTVGaEJiaVFXanUyblE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?azBOcVJQcDNKNzlJWkZmTkFIOEpqbDJkaU0rUk95bXFwU3B5aFRsRzVCMHlt?=
 =?utf-8?B?dFNOTTJIemF5WFRBWjdtZ0tRMHB0eEZpR2wwVlA3TkRsS2JOQTJubXRFMStx?=
 =?utf-8?B?TFc1b0EvNUcybi9HZ1dGYStYaDZSellKNDk2K0NTdXpPd21nZ1liT2tjWVVI?=
 =?utf-8?B?MlNra2V0ZUMxZlFpSE5TYmRVdFV5dmNGdnpWVUZTK28yK01NTTh0V2RSWW5u?=
 =?utf-8?B?WllsMDRpVnFMMzZNOHRBWEhjeU9pTG5uL2ZVbEZFNm9zVHdEYXNtZmZzZzBq?=
 =?utf-8?B?QmNDdUExSkRqL01IWmZob3h1UjB6WjFtcWRwR3pDN20yUldDMjhDVElMTEpF?=
 =?utf-8?B?ZDR1WGVFUVJ1bHgvUExUNEdzL09kVjRNVnQ5TzFuSjRKY3R3UWlkb0xwUnc5?=
 =?utf-8?B?d0hpKzFVNWVZbE1VZWg0RmphQzVpbWcvTWZ3QXBoeXV0TlZlemQrVFV6UTdp?=
 =?utf-8?B?ZXY1TU9KczhQN2RZQ3l5bG9QZmtEQ3B0QU1yREV3QUxGaWprcXBDR2cvNkRy?=
 =?utf-8?B?Sm9IRTBrd2cxZUJDUFN6Umdaak1VL1JIakdSVU9aR3NsZUduVEErekdEVGlM?=
 =?utf-8?B?bG84TW1YQ2YyZjNTT0NicGxwUkZFbGVxRUJZYUIzTTlhK2g4SHlNNHFkQ2hD?=
 =?utf-8?B?TGpDMDlIS0hjNDZwTld0RjM4VWxTcWhrajJmSUt5bEJKRi82eVo5cUlqVUlr?=
 =?utf-8?B?eWdoamkrdjg1YWd6Sk5oNVovRXYvWUxOa08zS3B4SzFiYzBFNWY5N2FCQXBm?=
 =?utf-8?B?WFN3bzJ6K0Z4eklWam9YeVhVZVBpU2JacVJ6MjRvT1FQVDcxWFBibHowamd6?=
 =?utf-8?B?NTRuNGFVL0hsTUJaMFg0akY2dWlZUXhlaXlua244c25yUURzTVFMY1lYUWln?=
 =?utf-8?B?c2dzZ0xnSXZkWktOanpMQmFXZnV2L0pBSG9QZXV3VjgvT3lqZFNpY24vRVMr?=
 =?utf-8?B?ckwvaGx3dHVSM0xtOHVkbzdUN0FSZkhPSjQweklyTDFaQloxdW9tUnZGbVZk?=
 =?utf-8?B?Rk90Q3BRL2ZDZzQxbFdOUTF3eDU2aXBVTkJHcCtpaTN1OFJDRmJkZktvK3Ri?=
 =?utf-8?B?bXFWbXllajVsVkgxNVhQdStLVUdPTXFCVzNoMENJTGlvL0FJa29aWXNBWjdR?=
 =?utf-8?B?d3ZOcWExb3kybVV3SWVMZktlUVEyVDgvdnpwOWV2QkhUUWZsVE9hNXVMRUpB?=
 =?utf-8?B?MHpNRXh2aU0yTGRQbUJ5azgycWlkM0NLQVVKaG5naUVya3VMNnRTN2xKSHcx?=
 =?utf-8?B?SW5kZy9UMnZmVCtXUVBJeUZiNW02cGxSVjJUUXNneHlvWkEyWkZoeUk4b2pl?=
 =?utf-8?B?REc3bEFsaHNMVklUWnZHaSt6RlRVNEZUd1Z5MWdCd204QjNLdHZXU1h0WDNx?=
 =?utf-8?B?QTlHZk1RaVJmeCsyTWlOYzNVMkZ3MndTcG01WkNuQjQ2V2JiOFBRdThTOVJt?=
 =?utf-8?B?ektzK3ZQRkhsMGRiYXIyN0dqUTFYVmRHWkkzK3QrdFJmYlQ0WmQ2RnBmQVd5?=
 =?utf-8?B?SDBKU0JhZDcvM1BNRnVtUGQvQnV6aWY1L1pEK3lhMTJTMWovaUpkZlMxL1hO?=
 =?utf-8?B?bzk3ZldPSDU3ZDI1aUQ5TWQ2MzRRNlJoQnlxZ1Q2OXJtQm9rZkRUMjdEa1FM?=
 =?utf-8?B?QTdoaHZGdXZyTDV0TmZtcXprS0x5NVd4S3pTS05lRURpb0VrRklFbjhPU3Za?=
 =?utf-8?B?R0JDdHpBWTlGMy9xckFXRkt6OVVBRXFtSit1NlQ3aEhzRG1sWHl5anNpV2J4?=
 =?utf-8?B?dXRodmhTbS9vY1Yya2t4UWI5S1V2eWM3c1hsdStreTk1azQvR1IwQ3MzU3BS?=
 =?utf-8?B?UFpxNTUxR0tHWGNtcUNLQVk5WFdZc3hGUHNOeTdXZCtKc1pmaVdWcTZ0Ulg3?=
 =?utf-8?B?RzdCR1o0R0VHdUYvWkZZVmhBUjIrQlE3RnIwdDhwSk9LTjBsWkhONWpEbXFF?=
 =?utf-8?B?MzcvbXViTjYwaytpOFlRdVVGeTh4bU1vNjNBZUtCODRkclJ6ZkJIZUFZNERz?=
 =?utf-8?B?WnRmZHBnR2J1d1JrT0hqdEVJbG01YzJic0U0Q1ZybThmVmhVQnowL1Job3dy?=
 =?utf-8?B?Y3dKV3B6d2p0cWZpalVRM1k2Y1NSTUFDem1vaE1BUUN2SGtNNzJWWnJmNU5P?=
 =?utf-8?B?LzlNdVhxTTZmYUk2LytDdk5YRjc5eDVEQ1lKUGt6Z052SHcxWWpHb1J3TU9S?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VGZRsgOgPOBFJHJ/I1ka1GlnEGWk/UJfudr1r0tb94ykAJWHFCbpsCJ26LUdMOjmzUC1iQ8Q27HIR3lF16CH83azhjdfC7Zhn41WPJ7ubENIi0Vv4ehCAJH/AlWh77PGoiVOEefY6flTPIdt2yij35x9BVqI3IljiFVgsVvfvTLMyhStmrMIdbuzP6RzvmbxW3ZJlgBt02Cu5hlTJiVuIr7/Id7ZCBgk/XNqA1wRyYkc4otjgavcGVkzuVO9CmUyrLmOkUbcWCv1WTPzs4hEJl7KeifyupDfqPKWrlfLoRRDI0zEVVbZy842GAe4vsyyrFyeo2ArAXeQpOZz9gdUKMjW+c3hvxbn1b6V5bQoj2Kl7l5EO7AM1SiYaGh2BBBUeZGLeGNeQIq9Ob6gJCQ071zrgiQQP/X4J4eozZQid4F49AakIdbhsqcHrFNBvc2VFTn9+QyhZCwDGNhuHNjgKuDZrhWKrNxgj6nDjjRcW+rjDi2IpS1wzjOC08Uh+iNaDRtfQX3VM7QrUFmT6CS9rGtUvSdbEKlM0LVR6IbqKa25Phk4QzUachFOV8gWxIFbsBrDNbo3X9q7iFj454Clj42M8bUMNXdhUtNnEf8Lfmo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ee90a9-1db8-4a1a-5258-08dddbd66a06
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 08:33:31.0953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OUk72TU3lLJEoQqQAtQOdnY2jhBvOtbqzSt2geyds649RUJgu+v2bguNODpGwuxWX+TZQDnaWCLdEfxva03LzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4330
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150068
X-Proofpoint-ORIG-GUID: DNo_sFMChUwiyVCWyppWjilw3pqYZBQ7
X-Authority-Analysis: v=2.4 cv=WecMa1hX c=1 sm=1 tr=0 ts=689ef119 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=AacqcoUYExIgVmBA-oYA:9 a=QEXdDO2ut3YA:10 a=qVVAQA5K0MwA:10 cc=ntf
 awl=host:12070
X-Proofpoint-GUID: DNo_sFMChUwiyVCWyppWjilw3pqYZBQ7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA2OCBTYWx0ZWRfX3T2DZnUUWNJV
 3XAvjplp760QQdBCWp4u0zvPtBgc+ZosiXCg1eGM6rOhj2zDXmwn8Gqde8n/gzov0riuS5hNxvO
 wEF8Vjt0rgVQxBTcnsGp788max4rryIG5eUYfQmc75+Vjin0q40HyilfE2nq0DV0wizkDMVncy5
 r2Oid/enLX56e9qPEEpbNbEpz/mFK4TVj4PupX1u/ltYqzgUwhNfhE00lcRDxsgwpKzBsw/IDws
 0vQ9x9xDoTNbeXrwHSc+6Og8nYQC7sNcd08dfCkW2k7YDx4NW0+Q0gOIddW4jLK+PS7EJ8YWM1G
 ZgKdPSpPR58sGMPKTghh0WtYPno/BFFQD2qH/HD4/ld2TApLtCuMd3h3hqcGPAz7tkUortMMlgq
 xO9AajZB314DyuLKgDvQUBs5Rnew58OR5e/WLX8iYaFmVQtwAEaLa6F4iE31HQO1v42uBqr1

On 14/08/2025 18:32, Niklas Cassel wrote:
> Make use of the dev_parent_is_expander() helper.
> 
> Signed-off-by: Niklas Cassel<cassel@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
