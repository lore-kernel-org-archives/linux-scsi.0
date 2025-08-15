Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39A7155CBD
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 08:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755246814; cv=fail; b=A8KgZL9a9Izwvp2aNqG5uyK9X3I/YGteXKrYSNBzyqmG1dNU2Qx0FZScimoOIuYJyR355sD6Bnotyz/E9cTOqBTWdHYvpykBKAr6czwOwziROUma28fBd8pMMJN+GW7tc0bf7RBhJq9q77IgMQpthum0okqfl6LdSn2i2724dmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755246814; c=relaxed/simple;
	bh=04UTNo2x7ZclMgzrd8Wsy0pERTj6gDmh2KzNqJiVKeE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rMSViBZyWV2ckpq9HE4NGu3hRO2K8OVCfU/NWmrgoEuEMuphV8x7zLq66XpzRgpSgCM1QKCi1dZ7xwxYeObibEZMEV/lY0/ZqK1f97HNKatifiW/vtjk6L579VBKk1MbPy/Sn0QVBw1swXa6zzBHQTylaf4AFvypzDPKBS1aRqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eFEVPaei; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=z33qNeUC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eFEVPaei";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="z33qNeUC"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57F7Z7Xt010572;
	Fri, 15 Aug 2025 08:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=; b=
	eFEVPaei4FSkrXJnwyVljDTG9vZaXKzFVY5LGahCAKD5i8nuF9gXLEecpxwbZeXX
	vLasTggGTet4FHlljeA4kdwBNug0bubUaS7InZUjsZdZEQlp3bW6+pgLdE2qnZBG
	DRl856V1fuRKxu4vSbwB7nstGk308L0quj+k9QoPeKULFKsrRul+733d2SB5aoz4
	lPV16MTJIWkMI+Il/9sRD7vzALavOLRpJenHsnk7h6u0QtVpzhnsxvOzgF3D8n7I
	TCtfxFaFnUkFpndiVMNI8yI0KK65t5ULb3JwMnANyFFO16M4JPcQaCTqitfjFicb
	zm4r4iK1F5FO+O1HebOUmA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw453mf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 08:33:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F6KwMx006438;
	Fri, 15 Aug 2025 08:33:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdkeqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 08:33:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iNwVs2sArOGgz9+M7OZNBWjjUkxDZIpxdLwOsaPOFhbTcZdnLqKyP7NBUmWeWPAJLYWpg4k6BeF0kWeP4FmbgOJ7zciXoM5vBkqN1kNIkQ0i9uO1AJXgVdmeHAKHjivr7zC5lDA0GnhuptFwlmoDitsRqbcrc1Q/KNNN0EEJCAdP4ety7BpEMPnE3HXK0m0u1IeFTT/oC/0D61zFhiz3gcpYhmrkEleiUG2aDCXvIuqewhe2nKD48IGqC5S20aG9rUKw4r7F6zARoFaBU4NjMOUg1VJqJZzNRlmUrTjbsh8I0mfl1znChfEYU3DpiupREWN5Xx8LKynXqKE9m8oGfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=;
 b=oJMeic3ycw3QiykqZdlgukdgYuctfAGQgiDeT4NAl+LEA2Jx0TRFBdYV3J0OElEPkKDSLndK/5X4je2rVLB7UM70JxA1Np5jmlk2sCd3B3+I71NjOHRDMblNzDiJNUTX4IwFxhWFs1U+Al4z7eZfxeFpkQPJ2rhDYWh3pqBRBcDodCVdugKTkUNksS3dDO7Dbi2HPDOpVVMc1UQy6UBVF/+GcKB90l1Et9CY7MTt+W+/ZcVo2VWj3jtHqTjVsvwT1YK+vVFiGcFYVtnzB6Q8Qw1OM/d1dlON3JQfnitCUHFCrmqgmXATFfbazFKR3W716CFDRMbY6s3bqfDvA0Vhcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YwDb7iCLYgKsA8iQABpD2sWQt/GyYpdswAQ5m2XemK4=;
 b=z33qNeUCfpoJER82KSxU5qjqD6bO+Vn71V0EakJMkcHiQ3bNThQFPamav4MVWg84rarqpGsNlH2nELJo9EYi+g91TtuAjnBlLXTomcs1OT4lBpigMf6NqHMSR6wf+VQYVU73HImJli7bC/OhYSSGVugjRxHtL1Xfl7wT6261xmI=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM6PR10MB4330.namprd10.prod.outlook.com (2603:10b6:5:21f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Fri, 15 Aug
 2025 08:33:10 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 08:33:09 +0000
Message-ID: <b1874237-45bb-47fc-ad0f-e5765b6fd0bb@oracle.com>
Date: Fri, 15 Aug 2025 09:33:06 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/10] scsi: isci: Use dev_parent_is_expander() helper
To: Niklas Cassel <cassel@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250814173215.1765055-12-cassel@kernel.org>
 <20250814173215.1765055-17-cassel@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250814173215.1765055-17-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0046.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::9) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM6PR10MB4330:EE_
X-MS-Office365-Filtering-Correlation-Id: 70953de8-09c4-406f-534d-08dddbd65d22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N25qWkdlSXhIaUlsWXlUZUhUN2lEOGp4dXBQU0hNVmhXREZ2dkVuSGg2UXVU?=
 =?utf-8?B?amh1d1VOaW40ckdIY0svWk15WFlEaEw3VnVtalh6cE83U2Q4dDZhUCtjWlBt?=
 =?utf-8?B?cTNKaERjbzdXK1NWK3gzcjl0c0FSSDZaa0RBdUFLcDVYZ201NVN3K0ZKbGZa?=
 =?utf-8?B?RW5WeHlRdkEraTZqRG85ZFhIbGp3U2x0cGNFVUR5Z0dkTGlzbXZnOXVVVURJ?=
 =?utf-8?B?RWlRNVJlR2FrS3ZZb29VcUlRYUw0ZjNHWTZhY2RGckRXeDZOYnc2NFdpOElz?=
 =?utf-8?B?bGtSdXJ5a0FpVGlPK093RzFkQXdkdStlMjZJZnZkVTMrdUg5ckoxUTRmaUdF?=
 =?utf-8?B?SHdNTlNBRVNIR1ZmUUFjK0U4aFhzYkVrRE8rVnlJOTA1WkVkMGhlM2daeXhH?=
 =?utf-8?B?SGtwYUxrL0VkSFp0TVVFRHA5UjNLZGMrTVVwVE9nNEZReURISWhORWRxMGN2?=
 =?utf-8?B?RXczTVpvWnlsTmUvQjJqVTRLVkJ2eEVwWExYZjlpSFN6M01XTXBnNkxmR2R1?=
 =?utf-8?B?YzUvVzNsZU10YXVmY3FtVDN0SlN6a1VWREJhcDhBcDF6VVZNdHZFa0ZXZjgv?=
 =?utf-8?B?SlhaRVNlRUNyNWJNWUF0Ukd0OGNxM0g1WHBMajhtSkt1QWNHMmRRU1ZlSXFR?=
 =?utf-8?B?a0kzNFpsYzFwV3RRM0VpM1h5dnJRSGhMc3UyZ3gxSVZuTVFBeDhnYVZ0WTAy?=
 =?utf-8?B?NEkzMEs2T2FkVFVNWGd4UzdqZXVhMk1KbWlnWXJsUWptc2NjWFFrNm0xcFVX?=
 =?utf-8?B?UFNsY0owMC9yRDRtejJSWUpkVzRzRW96Z2o4M2pNWVJWZ0tUZnVxV0VLbnRj?=
 =?utf-8?B?Snl6VHYzNEx1WDdVaGd6V2FBY1luUmFUYUIrdXppSEgzM0N3YXJDS3czTzM2?=
 =?utf-8?B?aU8xZUIyWFpvRjA1SDkvUWFzY3lBZUpyU0NyaDFSWTBJSWoySGNXdDZUN3lh?=
 =?utf-8?B?RkFzSTN2STE1bEhhUVpHZUpZOUVZNE9lYnlES0ZjYVZoUkhHSmQ5ZmpqdUxl?=
 =?utf-8?B?TXphT21jNGc3ejE5UDNlTitWelVIT0Z4R1loMHBtQTZVRHlPQ256K0ZrNkFF?=
 =?utf-8?B?cUdKZCtid3hhcnM4YnptK2cxVk52bGQ4SXArWE4wSHgwcWNjc0llMjZpeVZO?=
 =?utf-8?B?eGNuMFN4N3gzUGVudGxCa0UvODBWZ1FBWVY1NkYycS9IcXBwMFRPNlhVc1p5?=
 =?utf-8?B?bEovSDhRNFVkb2lhaW1EczI0TzhkZ01RT2JtclBkZWx5RnVRYmpYdElZWS9p?=
 =?utf-8?B?SWQ3NFZmMlNOSWxCREJYL1JRVkt5ckQ1a1c5Q0M1d2RBWXZFOVhPNkJlbHRh?=
 =?utf-8?B?cEN0aGU3NHk3L1RRSXZoaXNnMG8wSVpRZy9HTDdtSHFGRDhjRXFXSEwzdm9F?=
 =?utf-8?B?cHJtQzBmMmNJTHFuMVFTTEVUQU10VDBJc3FEQVVvK01MQTVsb0R6cjJ4VDNm?=
 =?utf-8?B?TVJ4eTkxRnFWUDdRMW1sQU1KWXMyWXFEcWRNUVpBajRNYkhFaCttckJDV2NU?=
 =?utf-8?B?U0trRi9acnZlWGVXQm10cjBrWm9HcDJrU0dCY2RoM2ladEpmZGFreXhlREk0?=
 =?utf-8?B?UFl6UHBUclhuS0l2QnhlSEwrWC9iQ2MrL0xwcmJLVERxSkNoM2hMRklnRmwr?=
 =?utf-8?B?V2ZDRVEvaGJyQlpEdDREcG9wRVVLcmV5L3ZHOXZoT0VUQjJWcHN0cWx0VG0v?=
 =?utf-8?B?cFA2d1JTdUNIbnYrSDh2SlFkRDBYSVMxUXZnb2dwTWhTZDZTbCtoRUhuZjdm?=
 =?utf-8?B?d0lLNU5DbXNxckRlRDJSQ0dhbXlQM29RK3BJOXh6RHVpNzFiTWV1UlRhRzM1?=
 =?utf-8?B?THJabEppSnQ2dHJ2T09pUlhuTGd1OXBLUXFVVjZtQkU2SXB6b2RrMVNxS3Q2?=
 =?utf-8?B?Z1J0dUlKTkV2SlBvNXV1bUpMRzFRNzhtTmZoOGdYWXdRWGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WFYvRzk3MkRoSi9TTXFxeG43dG5BdjkwdzcvQ3MrK1dINXh1TTkzK1RYUGZz?=
 =?utf-8?B?cjlxbWQ0WnQzOFdtMnIvZVJNUklrVkpzbHpmK0Jzakw0azh0N0owM25jVjBs?=
 =?utf-8?B?a3BkNHJJWEdDNUhJR0NkTzBGR1plTTNoWkZpZlNHMzh0Wjl3elpMb2tKOXhK?=
 =?utf-8?B?amVYcHZxM0N0K3VDYUgrclN2SUN1QUoyeUJDMHZGYUJaMk5XbWNaV2UvNWxS?=
 =?utf-8?B?OWhJRGJ4RVE3VTdkV2VCTktPaGwyRm9INFVDUU1lMXpmNk1URUVBYjM1K2xT?=
 =?utf-8?B?SnJraVpadU53SVE4ZWtYa0E3c2NpdEgyM1RVSWxCdmJOcmdlenk5NUlnTFpp?=
 =?utf-8?B?OUZ3YTBYazNCdlFMRlFHTWJrTXVrRHhmck1NeTZQdzlBSzdwYThmN0Q3UWVO?=
 =?utf-8?B?NXBCTjFoWkpMQytCQW5sZEFrNU5xRmk0ZW8zWFlBKzRIM1Bsc0ZvczJjeWla?=
 =?utf-8?B?THZDbHFNMUZLdzUwY2FNYWRpbm9jdk1US0drTklJSEk0SWZPUUs3VDVBWlZN?=
 =?utf-8?B?NzhNVStyaU1rQ3h5MVdOWDZwRUlnVG1qMDVUS2UxdW1UUUlUT0RzMnVKRGRY?=
 =?utf-8?B?MFdKVWt2ZmZhbzNrcjZEa2w5aVVoWTRQb1pxREVIRElqVmQvVjQybUcxS0pC?=
 =?utf-8?B?YTE0dHU4M01SRFZSTzBSU21UMGs5b2huSUdTZHZDcWJkeHlmYXR5T3c5a1g0?=
 =?utf-8?B?dzFJSHdxRHUrMEphb1Q1UU4xcDlQTTF3Kzg0SzV0WlZrTWtwVWdLbmpUM09k?=
 =?utf-8?B?S0FBZHBTa0FBS2toSjFMNWgxSDdHYVlTTFpaRWVUbXFoSjJzNmx4OVV3QWxl?=
 =?utf-8?B?eWE1dlFIYS9ranFYMnJSUTZza2EvR2JDRURVSFg0UkR1YktYWk1RTzVzUk9I?=
 =?utf-8?B?ckNCV2VBR2U2SEJNOGJMWkg0d0xla29nU3d6dHJrNUZLUWU0QnhlNkgyQm5N?=
 =?utf-8?B?SzkwellHdlRFY1RjL2xVMDhhRng2dXk0M2hDTEVmSGFLTncvWWEzOVBnbVVO?=
 =?utf-8?B?NE4vZHJQSjJSYTdIZktQeHJOYkZUamx2WDFudVFkWjcwM09OaXJlNTJvTjJ1?=
 =?utf-8?B?RDgxL2c0WWhCeXJHa1ByNFBVTlVVWkI2OE5kN2pUSVloQlVaSTNIeWJmeWRk?=
 =?utf-8?B?Tk5UMncyRGJ0U0hGclh4bWhvUlpPbFBSS0lKd05abWcxSnczYnJTb05FdzlS?=
 =?utf-8?B?NkorR2RpbDlmV0VGMWJ0U0c5YnZKZTgyVVJScXVzMk9TRUc4QXNSc2R1cjM0?=
 =?utf-8?B?b2lhdmk0emllY3ROdzM4bGRFTzlXQmpSSndOODJMaHJFbldjUlAvTnBUZlJN?=
 =?utf-8?B?WWhNS3laVCtDRCszS3kzYjQrZER0VnRMNmVpK0p2MG1UMVZsWUxhdG5YWS8z?=
 =?utf-8?B?SG9zbldGU2VCcmpPRlFScXJrSGkvdlAvL2ZhK3pVVm5EQXpJejJieTAxZGdn?=
 =?utf-8?B?cFVVMXc3cy9OWDhCL29UK1N5dDhsTEc4dktwZU50NjM2S1JmbXZHcFVFeGJU?=
 =?utf-8?B?N0xZclFQUk5oK2FkazlOZjdBa1phaXBGdkJ1K2tVcHBhNzd5bS8zS2k2cE5t?=
 =?utf-8?B?aEIxelNYdENwU1VQUldsYTE3KzlwVGZvYzJYc2dlZVlLdzVkOVJuS3dJMHJY?=
 =?utf-8?B?U2FHZVRmQWhZRml0V3lrUkZOWlROTDI5R3V6eGczMHNpV1FZemwwSm9rVDda?=
 =?utf-8?B?TjJaUGdMVHNoWElnbUxSVXJMR29Nd1RZVWhOUTRodnBRei9YMVVhRVYvVzdY?=
 =?utf-8?B?cE5kenRiVlJBVy9BT0NmeEsyYmNnelpqYWdPQVk4R1BPL0ZYSXB0clE4WFZx?=
 =?utf-8?B?bTUrc0t0a0dxbXhQdU5FSmZpdzdKdDErRWMyR3pLdUFvdzBpYkFrdU5jUjB6?=
 =?utf-8?B?UTBuNzF0T2JZWnhpOVRoVWhwTEdld05TdFZmWDAxMklQaFF2enlhYThlRWJh?=
 =?utf-8?B?dGJEN29QYy9zNzlDQXZkMXNMVmFlZjNzNkc1b2JNMXpabGljZnV1Y0xVYksv?=
 =?utf-8?B?aWlHOXhIV0xKM1hyN1hNbVZhQzQ0R2NhcjY3QjZsTnk4VkVabHhNakZLSzZP?=
 =?utf-8?B?TldDSmZ5a1lZbE9EWEFRajhUYlFCKzlBem8zT3FXUWJ2TXhqQW9uWUh0aFVG?=
 =?utf-8?B?WGtDdzNkaXB3SU9MQTNEa2R3WC92cmhPM0I0a2w3M1luSFVUY3J6ZEtVbmtY?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fu8HHHdkShVfoFmTAIgPYHfKpXyCUEw0lGhhI5MnKW96Am7mlvaq9NudJAf6g0DpnhZrsYv5E50qSaTexuavgY28KbsUUp4Wp2wqhGbX4/VIeewPC9QUl6M85q9KVChp106msUxU+IGJ4onur3mpVrzp0QJBdLZBEyxAZi3xeHCzsOMghkzXZ+lcowLdGZdOxZoSiBhzDDBJUWpLz2J3sOjK3+Hi0BolWXHSid3Oc1We/6oQIaS7r3LW3TVR8jjoSqUp9aFvMpbc+sNU9LpkUHdutD57hfPKBkRZ6kV8z3ruQVyT5fyWt1akdTgtU/Wu/B7zFQdJmCV45GrRTP8o4ZheWCsEPLNqj5xQ7Gf0bmHkLHXzCu+2xMwUAKDZ4/pFN4PRNCIJfaJl+ptjpnhBl1fdG5NO/NpKVtJG4D29q9DKgk1F+GucTdofAm09pUVSJoKgfjr6D6u9xOiNb+nuZw2pSmTZIDIjeOTDKqSiJBx860VD12qAYcabaE0mT8JUi5/eXLEH2+eaLga+1JzR/PULYOXGVIAWyfEVQxLCr2RIgk15M54G/qfi841Bh2r15doTyIeEN9+Mc8fMyGKylllP26RMOxQI1Z2KtcEbomo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70953de8-09c4-406f-534d-08dddbd65d22
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 08:33:09.5453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uVHAEqQcmdD8ONogv1Xx+cmxfdMbQQDddIkdUZG4MwNfHxKQ5Hl076t7aDGQ7342RCrMtkbvUhbFi/1snqgh5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4330
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150068
X-Proofpoint-ORIG-GUID: 4WFmgzvlaN2_BMQCIdOevyOcdB3AuwNS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDA2NyBTYWx0ZWRfX1JR/8jZsiIKP
 sAhdkgFgKa6okXUFE4YEp6cmZStv9V4mOvoo+V02daTgDJ0OeV1JlETL8gIX78nSd0JXqEGHLhR
 WXPJlIhXErv50+FHHakAOt/2BEZJCEvJBxnpF402z5TsOTcopyh4TM1WobLVEIa3dE/jmGPs202
 AJTwg6qyx9A3wPE9e5XF4tS+wyoPKVR12gUXKZChFKqTqZ4Q6uTj5IgbzCW9nUcT7VcyczcrtrG
 /cQVhUmtxGCO24QKfEgy2NAZz6TUkkGfaZ5xcz0PL0ZOV000VSexLf0UBPyMXrpT4wTBupaLOcJ
 tVqTJYnf18CdLoBLmYU1YkzcjgfxUh/ycWuZdYVojnAmwy9deDuon7GJo8Q/ufBVviPk10BONjC
 NjR2HlAh+4Y0xBg5BPXcjpZh8urZ1ubw4e3y2yEsGe8e/kAAugXJLTajD0711xv+XSlJDMZG
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=689ef0d8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=AacqcoUYExIgVmBA-oYA:9 a=QEXdDO2ut3YA:10 a=qVVAQA5K0MwA:10 cc=ntf
 awl=host:13600
X-Proofpoint-GUID: 4WFmgzvlaN2_BMQCIdOevyOcdB3AuwNS

On 14/08/2025 18:32, Niklas Cassel wrote:
> Make use of the dev_parent_is_expander() helper.
> 
> Signed-off-by: Niklas Cassel<cassel@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
