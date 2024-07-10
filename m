Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9741D8F66
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 19:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720641469; cv=fail; b=FajfvYyJH+2mvsB2z6A2H+f8NLr4YpPuYoTwPkKmGOSIVvM7/Hxq1x22Txa1M34iF85K8jJrQFkIJ2of9I7IirDX0ZQaIlGKvzkEFf1YPVvBCCHltNw6O6X28VgLG51Fq8H4kKCxj2sE+QfPXZgqtUpRWTp47gkFE0gPOeHSq5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720641469; c=relaxed/simple;
	bh=t+C7c4D57w+by19y1GSXoNKXxF6H2SaoTobkF5CHndY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gkClg6AMFDCNq4ZLa89G1BqZNRhGTt3Fc8A6d+ApwqA7XNhUZol0MiWUKxxB6UuZJqZQSr6aXH6h2TUFmH9Qvh76gZaHbhDm7skBcVOeGsL0KsdGku7AzotdOVGriHr6nHhEoaid+8MJFGcpE4wyCPzodeUf4WMJ7lFu03DiGd4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jmclalCr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LqDZP1nP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jmclalCr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LqDZP1nP"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AFjKqF019272;
	Wed, 10 Jul 2024 19:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=8h7eTNKxlz20v36MMX8Ttng7YTWO6rwerRFR4mLIIO0=; b=
	jmclalCrLPaohBh5V1xrh2Yu4wP0LjHIGCwZKWBXmsiWQfHhRkx9MrEYXA9jKi+u
	Lq5YNfAKofTXLIGaZfDhJiT7UYh0tjs5aJlNJFJvveO4u+mdF9KlWgVA8+6rMNpK
	5T3BnTRcefczyPCepHW1soBhwdLN7Qq6UrDpQk4GIIBAq4xFSWwXCFCdX+N8eq/a
	MdjV9vOM3HTbzzEZvjVz49YY0KLdIP4ds21iDSglgj1wHDqP45z29I+IA8qMXuW3
	N4O1RYQs0x0D/c+o3Lncn7vTLlD8px2uD1ck3Q71bsV8sRaomqv3Usc39SiTFXqa
	RhL+9zzaYcI4je/LOKkTYw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wky85mn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:57:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AIiDX4033696;
	Wed, 10 Jul 2024 19:57:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 409vv1ak89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:57:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AXxDxR9dbgn729UXITrbpOgBrr6eb1H1DzaXqerY9nn6AI7KRgafsmJEYKHWK45Y3CJ7V24h3FTXMIRJWhByFoSNbO9GHh3qH/2XjCAlqj24CaJ/Bmma5x3jt8On/rUKsLYLQnKAQQSTTAD2E2M3BId6iJ0aghNIoee5jG4x1a0XeiHzqJY6FY0aaq5zRWOLKuxOBbComrxkzjxvNDDvRXDOV3x9lOGZ/HhdSZM5ECzhuWvXX+XBB2y6K1gabcGiTRifBXa4j2z6OqOzWgAo5twUqgt5ooXtfWxbVHYV2syw4Ojnz2U9DipwsUIOXjA0sMyEhPTgBH/wS3sPI9YhDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8h7eTNKxlz20v36MMX8Ttng7YTWO6rwerRFR4mLIIO0=;
 b=PHyGePfiyj9uESDk685Ns2BxPm0xi588877cvbV+lMGS7zgXaUAKSneQ06WzFcTWhrny85JSQRlJEpG4KwtfCgjG6jQEh6XBfMAaeMbpGB7rQbUelqGtO0vdxiJcGbvbMacLMeRb3twbgz+9+e3YIq6s1dzhE8WK2tTwqoYeWGArinytcziociUGQySWvZaF4nD0C1tAd9JuIguBai1TNpEpvANtyw+EmsA9ItndSXqhJ1AHwSyPss0nc05/ibXNfIHXBMdRJMGinxy/MN5aYLunq2cQa5S8GHzWfUMxtA0oIIoSXLc4LJOC3AIifJ3nWm9rcdq46Eq+lI5LQ14iUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8h7eTNKxlz20v36MMX8Ttng7YTWO6rwerRFR4mLIIO0=;
 b=LqDZP1nPgBa2QgXZVBJjgO6z9TNyOrlI46nrRo68V3rLE8lNf9jwtf79GaoDVmUkQZzonfGLLtusZvrkADkhAYv67rkYXZjslLf8ohytLKL3g8Ca3SD9bZH9C1fmJomEQTVyNb5xgqQquTZOaJ8oYvdfGzhV7B7YbYIj8uf2DAE=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by BL3PR10MB6042.namprd10.prod.outlook.com (2603:10b6:208:3b2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Wed, 10 Jul
 2024 19:57:39 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 19:57:39 +0000
Message-ID: <01db4b82-e698-4fb3-973f-8d7e081d70cf@oracle.com>
Date: Wed, 10 Jul 2024 12:57:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/11] qla2xxx: Fix optrom version displayed in FDMI
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20240710171057.35066-1-njavali@marvell.com>
 <20240710171057.35066-9-njavali@marvell.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240710171057.35066-9-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0448.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::28) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|BL3PR10MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fbc8527-8c40-4385-5ba4-08dca11a8d14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?TCsyUGRiTTlkYmE3M3BWaXVCYU5zczhTNEpzUzdKRWdzKzZBU05nZ1NMVVlm?=
 =?utf-8?B?QzAvaTVJSmkxWDNQU2dRY1BONW9oMlhvMTRwcVBrMDJZU3J6RmFWTUEraWpV?=
 =?utf-8?B?L0tSRlM0NkJpS0tPSEk1VURMbjhQZzRaT2RQd1FpdzdSaythS3pHV2FUU1lL?=
 =?utf-8?B?OXZvVStlOGNLWWpzMmN5VnpDckJCZU44LzBGb3hYeXUwODdZVThkVEw2aHI3?=
 =?utf-8?B?Tk9jVXFFaWJ5bjJVWlpOSDlTNXluUEQzZlprTWtxQ3o3RFFuYnBadzkzQjFy?=
 =?utf-8?B?alY0cW52WmZPNDdWOFdTNmZiTXdWc0FHeTF2eHY2eC91a3lPczJ0V0R5enBZ?=
 =?utf-8?B?czc2TjlRMlFna0lyTThncU5SaXA3SHdCVUZqNUgycW14bGJjTVlWZGhRSDlX?=
 =?utf-8?B?MzYyNUNDb3EzejNPUjkrSk5UdFdyczNJU1NVUC9KY3VpQ0VySWFtL3NzUmI1?=
 =?utf-8?B?amRWYlg1SG16am55SndQYUhSY3NtWFR3d0JWMzVWNnplaExMSHVrRytma1Zr?=
 =?utf-8?B?UGVTM2ExL3hBYUZsVlVZOGpueGVBaUNBTTZmN1ZoeVI3ZS80YXhKRkVDbVkv?=
 =?utf-8?B?Z3ZBdnp5VStPTEQza0xNKzU1bXN0SUt0VTRzQjRiZWxKR1NMSEJ0ZWllZ3Nh?=
 =?utf-8?B?OWZUN0ZKOWNjbFhHNVg2aXVZb1NtdWhhNE94b2JMRmlYdkpYQzAySUJBeGk3?=
 =?utf-8?B?TURubVVjTERHT0NBVmEvWUxITlBnMFVYckhLMkluK0xBNDZXeTZFblF5am1a?=
 =?utf-8?B?MFlwcWFtL2lQbzlTSmoyOG81cDNGMjgxaUt6eEFzNC9FUlZDOEpUY2ZzTVZS?=
 =?utf-8?B?aGZ2TkkyNVpLNHpWYTZ1Y24wOXdVVXlEK0ZWL09tbVFNUUdtekZBenNVNCsx?=
 =?utf-8?B?Q0RWRkVXbnJic0dBWEJrTkZlYVlJWXN5ZUE3dy9vT1lZQXJBVDA2SHQyemdk?=
 =?utf-8?B?Z2ZYUVQ3T0tFVzBtMmR3UmxDUTdoczJtaDFTYUYwRlNwR3lvWHI3K3BvS25W?=
 =?utf-8?B?MlFrd1RXMEkzbEFsVkxzaWJCSlVEZ0ZUU0JkKytLL3d0cXo1aHZ6c1U2OUVR?=
 =?utf-8?B?aWJXUEtoam4rT0M1cXA2dXQ1Vmh4UGJ2OW9mdFk5eDlPWjBwT2s1M3lKOE9p?=
 =?utf-8?B?a2hKdzVkR090d3VmMHdTVlBYeUVKOHdVWm4ycy8xd09sYkozdFEyN0tidi9i?=
 =?utf-8?B?bkZPS0FJRUxZUjhzd1V2SUpGeFQ3OEJ3c2RPZTZhZkRubk4xRXFHQkxkWUw3?=
 =?utf-8?B?SG12VU0xUWlTclhPZjAwTVZwdEFMMGNrVEFldkhYL2dMb3lMWWNvelltTlR1?=
 =?utf-8?B?MHA1WXlyQ0g2Slg4Tm15U2VaQ3VWSXk1cmNyUmhaaUNzczdnRVB2MCsxelRP?=
 =?utf-8?B?Z1hBVjVydS91Z2RMY2RXVG9rQ0pVTDhRZmRvN1dseVN1WWNmY09IOHZ2cHBI?=
 =?utf-8?B?L0k5SVNJUEdyb3pMcTZJVmcrZ3ZjKzZxLzRjQ3FnZTVJT29mazhtdytMR29D?=
 =?utf-8?B?Mk5NcTJJaHN5OEc0NW1ZMnkxd0k0NTQzMi9yK0hkL1dFdTNleVVTdUlacEJG?=
 =?utf-8?B?U2FFQUdnYWp0bDVvTXVTeWQ5bW1STmZnaEkwSFIrb2VGVFluaXZuZmpJL1BU?=
 =?utf-8?B?eTViTHo3VDMyV2RYUm4zMGpJU1RlOHBjKzAwT0NqR0ZhTk8rMVJINnNLMmNi?=
 =?utf-8?B?Si9IZFhxeEJiYk1HMEd5aUNpYlJHRzI2Yk5MOGl4anBseCtlbUJtUGlMSWo1?=
 =?utf-8?B?WnlHZG9FVm54SWdpTXIxUHhHMFJSRUdDekg5aTB3aitZNy9NSWpUd1dpaTFY?=
 =?utf-8?B?c0NEbXY4b25UcUlIT0JPZz09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZGl3SWNYMGd5bFlzK1JmemJWc1g1SG9RWmdGZkNON3RLUGlEL2dHV1c0MTlV?=
 =?utf-8?B?Zk5URC9xZjlXRWx0Q0xUaE5tcW9kUE5BUnBacGZHSEh4MWcrYjVMN2pVcGxW?=
 =?utf-8?B?dW5Ob1M4YVdhSU03WlMzODNZRGlZMVdjNStWZTJWNnV0Nm5EUnZiVXR0aGF6?=
 =?utf-8?B?R0Vyc3JaUEs5YTd3a0dvMGNWWkpiZEpidi9RT0hsK1VBMm9FQm1wVlZNVDIv?=
 =?utf-8?B?Mno4OGNRUDJrWXJkMG5JOWYvRFBiNVB4QmNPeFMrNFZ1bzM0YzhPNUwyeENL?=
 =?utf-8?B?cXVrSzh4bWhwZnRBNkZSK1d6UHpIR1d0Tm1ESjk2c0lWYnJUbDQxd1BrNzh0?=
 =?utf-8?B?cHNvUklnWGxhdno2Mk9aS0hpVHp0MWh1UU5MbWRtbGJ2Z3diNm02ZjZqYWhZ?=
 =?utf-8?B?cDJXYVlVbCtPU3lLQ201aUlBZndLWlAxM29HWlVvTkpIMFlBL3crSnV6VTc0?=
 =?utf-8?B?VGp0c2lsUUFvSi9FNmdQVGxubEpFWVlyTTFSTmw2TS9xWnd3US9hQU53V1Ns?=
 =?utf-8?B?blFqeW9NQ1dHbklKWGNrWVF6ZkZ2SFFvSk5yZ0ltaS9RMUpFMjA4S1Zyekww?=
 =?utf-8?B?L2VXTWk2VGoyc3kwTEJJb0RUSFNmN3Z1TUZlaXZhQlVRQ1cyMDRSY2FLcjQ5?=
 =?utf-8?B?dUp2Q2ppaURVWEVGcVlkendYV3NOa0Yza3p1ZzVHN2lwUzdmemNTWXlDejZN?=
 =?utf-8?B?WGVDdSs2cjBzV3JyOUtTcFcwZ0xLMWIxb0xwTnFiN2FFUUI0RDB6Y1YyVkNF?=
 =?utf-8?B?ZmQ2UXZ4aWpxdUhZSXhnMXJIRCtWamsyK3R5eDYrNWQwbkN4dFFPYzZlc082?=
 =?utf-8?B?S3RkNk1VMzBJRFV2WEZtTDVSSnIyTjQ0YlVtcjFGM1A2VVBDK1luenZxamtq?=
 =?utf-8?B?cVFBbUxNQ3BDbHQ3VEJhMExCM29yTU9uQUtBcTkrNFAvOWpPQmlJditaMVJM?=
 =?utf-8?B?Y3JhS3ExUk15WE5nbXJpcnAvYU9zTEd0eXQ3dzRhQXVDMFpEc01QdnJ0RCs4?=
 =?utf-8?B?ZHFVb0x5TW92alNmeDJuL3Vmd01sR1gweDBtUjFlNklVa24ySVYzZjRrR2VY?=
 =?utf-8?B?RnFtYXlpT1dZc0R0MDBrZ1Mza2Y5Nk0yR09ObGcwR3MxbXNGVlJJRUJJaHUw?=
 =?utf-8?B?UTNSNFNCMEM2RkVDUWJBejMrcE5MNVNUUVBxNVF5UjY3V2NWY2VrUCsyUXdw?=
 =?utf-8?B?bXdLSjNFdFVmYmpzMEJSanFvbi9VVXVUL1hoLzNrSmo1ZWN6Ynp5ZmZxZVBl?=
 =?utf-8?B?VnFyMHRBNExxaFFEb1Raa00xTzUvZkZDU2t0UjJiQVljaEhtS3NvV3pId1RO?=
 =?utf-8?B?ZmtlSW9DcVU3M0t5Uk5FaVAzb2pLSkJGeGNVREFTTmFjMlo0NFVRTm4vM1Vt?=
 =?utf-8?B?bFFMYURlOU4zcmN2aWZTelByWm5DRkl4L282QlhvOWtzVTlXMXlzMStEN0R1?=
 =?utf-8?B?d2M3SjZHTkhUQ1hLZVpZZHdiMzFDZnd6VFdMNXhUc3BEemZhRm9BNUM5OFY5?=
 =?utf-8?B?dXFuTXVqTk1RTmVnckhhOW1vQ1g5bkNqeS9QMEZrOVEvcm1yOC9UalJ1ZGhK?=
 =?utf-8?B?YkN6YWhxSmphMFpUb1hWSWNTenJBVktjbWJRZnYvTThJRVU0ZlltYXI2cmU1?=
 =?utf-8?B?b1UrOUtEcHk4MUJFT1BqVXBndkJyQlgzRzJpTEJTVHBNUXowS1V4Tm9SMVFj?=
 =?utf-8?B?T3BXMG5oVUZwRzc5ME5vcVVab2Z3U0ZsT0U0bE5BRjdhd21ybjlRd1dJc2l1?=
 =?utf-8?B?TFJOQnRnWkx4NlpBNml2WHE4OFFjWStXQ3FGZmFVR1BaZmpneU9ZcSs1eHM0?=
 =?utf-8?B?YnRRSk9mc3BlZUo4UUduSEEyZzZKaXdXcjVKV0owQ3BneXcxcSt4aFZmbGdC?=
 =?utf-8?B?Y2JLUW5WZXUzaG5TT0VFL2JDckY0Vk1RbUdFbEE2QVZYcW5TVzl4SE5xS3BJ?=
 =?utf-8?B?cjd1clM1T1hEWUVwWU5VbTBXaW54YTgrT1JmRzZGM3BranhoSjhkTlQxL1k1?=
 =?utf-8?B?R1FtRERZT3RVTTJQMXErRHJQZUVSYUtSL3VKUXFNaVNWYkNvVjNrTlpVdkhD?=
 =?utf-8?B?UkJjUFEzdG1oNGpaN1R0T2F4dFg0b3pMb1dwZlNmYVFhVEMxYzc2UVV4Ujhw?=
 =?utf-8?B?S3VqWlA1aWRIVE1aa09tR25EOTE0VTlDWjBDT2MvQmdyei95Q09GanhUK1VV?=
 =?utf-8?Q?w8uZRBjuT+b2YnKtGVOtn0s=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	BjZWBuOH3tGcwdJcB1zVsRsNsZ/3CpAJDKuHUTfBjGMhFVEAuJcgWg7+wPWbHxqD0VaRVHBZtBrepwztHnd/UcwR9xkPYL6EgKXKmiBQ3w0asTJrvoIUqwGl9dKgBz/Kk7l/jXdibBjIzkFhzDxqSyFPREuY0YFhXt5CTcWYzbIUReVyQxdCITzsmFkyVm7Hyhao9KmMRn+17pckHfB8qqaBlKKsrrMFHPFNYjchDrYZOoHWGPosMBFNjXgNup+i05/weDV6zidhvEX5JMSHZOQy9gIGtM8n8J2/lX1pT94TSYe3wLDdK8eqSWUXDrSpoiNofJkjQ/nxDXPd8SInYWoaKAJ0flvcFdrJ5TkqR9gNVePVSsvJNZbhugcjhyI3ZYlg8vkeNNt9grxOTY5vmU1QsylKmlk+g4LK+leNljxxvnR5dQe27m8DVjB6iDuLDvnp8eNfGs4P4Infn0OdA/jZYCMBHvPuW+Z1390/JXVb7F1fgApcTzzU+tw4JNkraLccF720UNIVLCd3Vn7kWtyVFTmlN1/e04luVcjVMi/RshIJVk0mKjCPLo3bqu5rvJrWWV1NSMbzQzgsue7ewhKEyQAeAsDa7io+xHD4pfA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fbc8527-8c40-4385-5ba4-08dca11a8d14
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 19:57:38.9812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsR9cIHuGXP+wrQGJBSXV4JzMivUGjRdk3LG4buKa4r5yPryqsAI5b9qx1xFL2icPZBnXbTL/AoPRrjTaRo96J9a1DsHLh7pSP4vJbjAD7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_14,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407100141
X-Proofpoint-ORIG-GUID: v4zQ-BoM_ryQw2M4PA8SFp2v-igFfsPF
X-Proofpoint-GUID: v4zQ-BoM_ryQw2M4PA8SFp2v-igFfsPF

On 7/10/24 10:10 AM, Nilesh Javali wrote:
> From: Shreyas Deodhar <sdeodhar@marvell.com>
> 
> Bios version was popluated for FDMI response. Systems with EFI
> would show optrom version as 0.
> EFI version is populated here and BIOS version is already displayed
> under FDMI_HBA_BOOT_BIOS_NAME.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Shreyas Deodhar<sdeodhar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_gs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index e801cd9e2345..caa9a3cd2580 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -1710,7 +1710,7 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
>   	eiter->type = cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
>   	alen = scnprintf(
>   		eiter->a.orom_version, sizeof(eiter->a.orom_version),
> -		"%d.%02d", ha->bios_revision[1], ha->bios_revision[0]);
> +		"%d.%02d", ha->efi_revision[1], ha->efi_revision[0]);
>   	alen += FDMI_ATTR_ALIGNMENT(alen);
>   	alen += FDMI_ATTR_TYPELEN(eiter);
>   	eiter->len = cpu_to_be16(alen);

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

