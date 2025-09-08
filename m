Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12082E8E12
	for <linux-scsi@vger.kernel.org>; Mon,  8 Sep 2025 13:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757338818; cv=fail; b=ZfSbspp8OO/+XS7EuZQPkj7oFqxh8CwK8lRxkPdPrFJLyTob3xBHf4b6LOhAMrHYIrYSfdQhYtD1JlkJWYk0bI9DKgp2O8Y2XZdH3jfHcVDiSd3VNv8tYRrlCzbK6wwMIC18eyf6H0GbMJJl/PHnA8DWTmu4EkT5CMvuZ4Gb/gI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757338818; c=relaxed/simple;
	bh=H+tQl/TnPnp4yjzQEbNnDTM6YMSMAM9uewFfiX6qUEg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QEWu2CuALpWvrY+5pRupJS2A5iCN8ORFKVKZ/+x7ml07vHltf13nfBR9ytsYyaExBfJSb6EfeBTqzW+FD9Wpu8Q8fcVS0q8d7d8fWVFlWb5Ta78Ps068S3SgYy/aWFy8Atcj59vlTAPn4Zq9RONMjzRm0V55R0wFxR91MTFQyMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QRnPj0YX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dm7gjnM/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QRnPj0YX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dm7gjnM/"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588DYYg7027809;
	Mon, 8 Sep 2025 13:40:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/1P6cconSbjMZz/EIJ6owN0uzIif6yZ1bfznLJoyRts=; b=
	QRnPj0YX3tvRoJEM7+LOL0lASGJe3xQBXRhfNYU1/2ehjSDEIICNZak7nLE5zlP/
	j8dFSTduHlHJPCAjPvNfW0arS+oQF4MZGDYl33AeoCleQ+lEV8LdFKMJ6ncA0WNh
	CUUV47MnPgcpx4eGv6fN7QFfr5cFmRWobeiZLKwWHKr8k/7KQbPenm/IsuSVUGa6
	qvmXR2IwlZJBP9dxPVT/rnVucy7J/vo78+NcsHoZTY644KXdu4Iw+FZKwW1BE/tt
	xEwcBgAZTqICuE0ttI4SfRQi2hihND/UPWYsCA1z7mepx8An9C7ovZrjI66mfCje
	e0gV2dstda285XTQo8PYtA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 492054r0ek-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 13:40:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588BveTg030839;
	Mon, 8 Sep 2025 13:40:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd86nmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 13:40:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rjYPLVCyCpJgN+MCgHodvNN01amVcPeuH9eVoyEYyY7FedJvFtLU8r3NNchBD263a/48K0MO4lyH9dEKhPe8GEbG1PS/OG8uxy5rM0to7mYY6KksQCTU4CNc+ifnErAgURn0zlVY8zYQ5bVqnkOLpSUk7yO3ttc6XvGe/TM1ZzboK9sfiQE1qIb96At6HyearnQEfvYpanZAxClaQAoAX7vn33URbyDHJAqrNSQgNuI22OL9rsitrdpJWeFcBcL8yMDohHMlkisoHHGDm3fxOFU9EqR1c4hiUYpfndjC93SPIaklcGk9UDnfzg2eBIvirGnpb3WdU3Bw4jPnBZUpHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1P6cconSbjMZz/EIJ6owN0uzIif6yZ1bfznLJoyRts=;
 b=Xjc6fx8iGdjhty0z59x3VOC/ag78Ha4Z6gtmeBG79gfkgBjDjKGXlVTVJio451isIbnbuXWur64uU6KMYrcRx+ERbedYHxfrB2Qogd+s7u001fel4JSHulqsseRifGLqGyhonT1Vfn3YhmxjrCrTEgrmY7oYOAwAIVMSzVvT6oHetev4WZhx3/cjBFEl4qu9v+XFY7JskHYAwhNnm1SXUf8KQ7z92hy74ZeFuucrp3hjYrv4TMC4kSEjWBnUeyc57u4biB/zdcf013DeruXMMg/dZ0wiuz6NBH2k2KzZjAgUubpJ3Nnv4ObdetdqpJD/Al7J8xp6y9JQ4MMcPx9NBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1P6cconSbjMZz/EIJ6owN0uzIif6yZ1bfznLJoyRts=;
 b=dm7gjnM/BkIVs6XmQ0eJQX0ci8zsN/q3i79lnTQvDSbLGq3UEgYMNx0yN5Lid+ipJ1HogfF5/k14X1wGfBxwLixh+5otx8Q7YYpo28pGx5oMzG/bkqkYWZBbJ2BHpquqL0wO4xd0BBuRSCVM2N+2Guwv6rFpyzwtNGwhqmPHtx0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SA1PR10MB6293.namprd10.prod.outlook.com (2603:10b6:806:250::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 13:40:00 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 13:39:59 +0000
Message-ID: <ae0d289b-a61f-4546-a886-ab904fb76b79@oracle.com>
Date: Mon, 8 Sep 2025 14:39:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/26] scsi: core: Do not allocate a budget token for
 reserved commands
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-4-bvanassche@acm.org>
 <7341ada1-05c4-4a70-94e3-cd208d47231d@oracle.com>
 <719e714a-6f15-46b9-b4f1-b697ea00ef66@acm.org>
 <c9b3a67a-20f2-4d2a-9b31-6a492dd17f81@oracle.com>
 <4477b1b9-be63-4e0e-9fdd-2b9633e8acca@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <4477b1b9-be63-4e0e-9fdd-2b9633e8acca@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0224.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::20) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SA1PR10MB6293:EE_
X-MS-Office365-Filtering-Correlation-Id: 41638c2a-f62b-4385-6584-08ddeedd34b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QlpsRkZVVmxGNENwSHhCOFdXa3U3TUhqUy9xOW8zajRkQmRGdTk5YlYzTGlo?=
 =?utf-8?B?UnllREVlamJFZFp0c3pPeUtoQmxhVWhaNi9wcDV0K3NzTW9tOHZGN3IyNDdD?=
 =?utf-8?B?bFo4TkNpcEdGdFA1S3M4TjZMdzRqRmNJVUdHMTBpQ2hPK1RjM2dSVWtWTWFE?=
 =?utf-8?B?MlJCVWRpcTM3TCt0NU52S2dadTlUN1lycHQ0Qk8yQ1g0KzB0clhJaFVOMjlF?=
 =?utf-8?B?NjdYMVptVEM0MmZYOG1Yb1RFYVF4cUtnWW8yWEsybDZaUTlTUWFlbGppb3BN?=
 =?utf-8?B?NkJiZTZ6NFc4T1hya1NEb3pPN081UmxxbUNlc3lCZ3NsdUhZdGpiM1AyTmVV?=
 =?utf-8?B?Z3ZlN2xZRGw0U0FmUkRtaW5xQVZ1bERVakowdzBxak9ZNm1NNnRjS1pQM3A5?=
 =?utf-8?B?QzZ4ZGxOR2FueHV0YU8vMXk0WFNRYUhXUXNPSFhjeGhWK2VZRnpvWEdHRGFN?=
 =?utf-8?B?OXZWdUlEdE50K3hOSVNVT25rbklIZ3JMT0dIUDNRQXZaMnFqNUszdGZ5RXlr?=
 =?utf-8?B?bGFjUEhlc3NNMTI0VnIwY2lybkM1ajNxTVdJMW5iZndESGMyUGlyVWJKY0Zz?=
 =?utf-8?B?d0IyNm5lMTdUeWtXNnVyOGszOVlWQWNUZEFGbUhWK1hmTHZPeFRQTmNHQXQ3?=
 =?utf-8?B?ekQxMkk3Nk8wZWFLMURNVFlwRDF6UTZGK3ZkczhrY3k3cksvbHF5Y3Jzb3dT?=
 =?utf-8?B?V054ejJpQmdZaEJGaHhRRDRLQjlSYlpQZGcrZkhjdVJoSU4wZ2VRaWRUYlJX?=
 =?utf-8?B?OXkxYUtVS29vVGg1UUtwSy9nejZxRW5IVk1GdXg5TzQ0elNqMkpheUJzSGZY?=
 =?utf-8?B?MVdOSmo1TDF2MW5FcEt3eXd5dVo4WS9ialNya2FRem1OeFRaaC9ySVdRWjFT?=
 =?utf-8?B?RHlJN21PZVVRMk42K2JmWmN3Sjk5TStTWWpmUldaNEZMSVh3VlBibnBPa3J3?=
 =?utf-8?B?aU94L2NUOEx6b2R0QzFGNFQrcjRocjhqS2lQQ0tsS1dUSDFTdFZtdTBMVWFR?=
 =?utf-8?B?Umk4RDN1Y1p2MEpIMEZHRVpCcFVCYXFCbDNORVZqN0U2bU5KcC9zT2JyZFJE?=
 =?utf-8?B?R0Q5cjNseWF5cyswTHlsUUgxOTFwTjdaZ0ZOdkxTd3B2dDhYVWo3eVNPcVph?=
 =?utf-8?B?ZnVYdTBnUzhaaVBZdmJweTUyODhoMVJneVc4a3BvQ0ZVUS9rRUpkeFFaV2Zx?=
 =?utf-8?B?bC9oZDN6ZjRxSzh5OHFLRVNmUjgrb0I4R2ZyUVhNVnVEeTdmcEhydEFqT25y?=
 =?utf-8?B?aG9EazhwRldGM04yWE9qR0RqVWdYanJ1MDVxTmh3NE1EbUpQcUZQczZMU1dQ?=
 =?utf-8?B?RVpuUDQ1ak8xODZCQTR0NWplNzExb0c4OXNXWE9LTExTUUs3TW1SMkYrdy95?=
 =?utf-8?B?MXMwdmdCMDlrbU1hRE1HNXNYWmlMcHdmV0ZtaW5jb1JTMVM4WXV0SlhmaTVM?=
 =?utf-8?B?T3c1WE00bi9oZmVWbU5GcU9IZitoU3lKMUhDVDEycHdSRjFPNk1vYVlnbXFt?=
 =?utf-8?B?TnlzMVZoZ0xkdDRUNnp6TitWb2pXYUdnL1p6WmU1SVNPZ1U2c3A2MnJUUjZu?=
 =?utf-8?B?bUJuUXhxbXlHRVhRYzhWYndMbk1FZzlVVzJuSDFpUi96YlA3RUg1WklrOXJT?=
 =?utf-8?B?aVVnV2liRENNa3pITGVTcU0zUzY2WEtjamtoMERGbzN0ZDVOQVRNbFpUTkMy?=
 =?utf-8?B?U1JmRG1UVmZvL2dUNTgxcGVyUDU5MTFwanltWTZ5V0MyQktucWprbVdvaDdM?=
 =?utf-8?B?NDluWWgzVG5wVjcvY3JKbUtKY2J4TExSME5CMENlcUpEQWxMSWVMUVkzMnFp?=
 =?utf-8?B?UXRGRFJZTXBBcFJKNXhEa29naXkrUDM3MkN6NWZCQUREWVIxV2dsZWRpRVls?=
 =?utf-8?B?UHdFUTV0UE5OVnZjYmlwbHVrNC9PZVNMYkJkMENyY1dCWjlKUUVOYmZ6aC9m?=
 =?utf-8?Q?54p/llflZWA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cG5pbTVvbnIydmNyYzU5Y0RXWFY4a1UxNk5vbG5pZityT1RuTmNGVm9GYzAr?=
 =?utf-8?B?cXI5b1oxL3pGMlR1b0c5NlQrSzRWbUVhM0Jnd2l6aGZCeHJua3MvckhieVIw?=
 =?utf-8?B?eURSbm5PUzNwdWZBRWwrdGNxYnBHYSswRGZ0WFFpRkRDWWxlWnN4WTl5VDdp?=
 =?utf-8?B?Z094OUd4OWZKeEp1VmdJK3QrZWNWc21CakZWZHQrM0VrTkdkeUtzeXJPZzRI?=
 =?utf-8?B?Z0ZHbGZ3cW1JcjJxMW5oWTY3MWJMYnJOUWNIaDFFVHROQnhmemF2TDZUK1J2?=
 =?utf-8?B?dUdscmMzR2tGK1V1cHNES0FZYUxUKzBqVGloMUltaTR5UkhST0tmd3FSb1l6?=
 =?utf-8?B?OUNZa2p2Zyt5NUI4KzRUNDF4UTlWb2VQSTNXanQxQVFIaWRiT29CS1BjK1o0?=
 =?utf-8?B?S3FkcFV3WUgvR3R1OHFzeEc1VVEycXp5SWh6ZFN1N1NoYzBUVWgzdDZNT0da?=
 =?utf-8?B?L1FDNVphTTJnbExhOFd3YSs3QzZ4SlNEMFBJZ3BYRk5JTWJleHdaSmxpaUtR?=
 =?utf-8?B?S3N4WWExeDVLN25wK3BGOC9FRml1MFN6MWZHSzJQTHZWSXV5S0JLRzhGYmJa?=
 =?utf-8?B?WFpCOSt1TTBYNXpvMUhiNnRScWI4QlVUTE43anJCeG84ZmMwcDY2QVp6WUxD?=
 =?utf-8?B?eWVnYnlvWUJBOThvaEN5WDdLVmlBMkJOUlVVU3NybHBrd29jOTJhRFExVUhW?=
 =?utf-8?B?eFBBclRQR010YkNEeDhDbDJ2cVRHbGtuN0JPOXZrWW93S0Nibk5LaHRESGZS?=
 =?utf-8?B?NU5sMlgycjlRQWRad0xaZTk3RHdTWnZlemZld3dSUHYzQy9hZzlIME9mdDNJ?=
 =?utf-8?B?bjdrV2pic3prSmY1M2h6b2lrR3JpWkdLMitwczJjUlgySzNMaTJJbHBQaUlH?=
 =?utf-8?B?VjJXZnBzRGluaUVONkNlMGkrNTlsNVZrbG5OWDBRQXMwQVBnWmE5bjlMT0xS?=
 =?utf-8?B?cnFBVWFWRDdkTGcrdlBHaVgrMGdCOWllS2lNcGpsRTVTdDRpRVM5Rll0RHpG?=
 =?utf-8?B?VzZkTzJnR2ZKVEdxcFY4YzZxZU9DUzlFTHhRR3FvYnoxNkJDdWFEK2ROTjlr?=
 =?utf-8?B?NXNWTFVKbElXYXZMaEJJSXVGaHRjTzV6UE5LRXlJOUlXdGNzK1A2akxtQlhj?=
 =?utf-8?B?NXpzeXk1YUJpWENlUHN0WmFFWXJqbXpUcEtnbCtNZWd3eU1kd3hGZ29POTN1?=
 =?utf-8?B?SzBzTS91WXFaZGdWeFQvWWpiRXBsaFJFTy8rYk5OQnpuVVlBY0tUdkQ2dk5C?=
 =?utf-8?B?WGtPWTY4elg2S1RGbHdCK3ZRYU1DY0lnanpyNjRYcHdHQmgxZEtVK2dON1M1?=
 =?utf-8?B?NGgrMWlxcTgyYUVmSVowak5XTnJqZXBaa3VMbDhPOGVkNzJnZGlHV2kxQzRY?=
 =?utf-8?B?YjBhUmMvOWVKSzY2OGJ2U0pIRHkzdktrMWdScjh1NTM5dERCVkN0U0ZJc1R3?=
 =?utf-8?B?c0lPL2JDWFVMYzNmczZaMWc1NlRuS044RzJYWFVuVk0vQnhwTWFDcFF3b0Rk?=
 =?utf-8?B?aEppN1RoNktuQ0tFemdDZXpEanRFRys2TWtDa05zWGxuTVZrVEt4b1NBcSt3?=
 =?utf-8?B?aU1CQVFJSnpIdGNQT05adlZIRURQajR3ZXd3azFPVGVtTjV6Um9WdmdSVVhI?=
 =?utf-8?B?dks0R1NjSC9LQlpIWGNBckJNeFgvdndJWUxXSlgwMVFZQkQ5bzFQMEZlVWZm?=
 =?utf-8?B?V2tHMDJBc1ZsRFVReTJjM01LWWE4dFpzVk8zWTd6c3k3RFRuTnY2clJaWlgx?=
 =?utf-8?B?MExIY0F3ZEVvNnBKTzBpdmgyUFl5U2kyZzk2OHkyNTkwTGliZy9wNGNhcWN2?=
 =?utf-8?B?Wm9weXUxN1FEZ2RMcXo2ckdhQmZFdlVKMDV6UUFTZFlwbnlWR2F4RVluamZQ?=
 =?utf-8?B?V2o4eCsrS2U0dm9sa2tvSklqd3JXRHVTN2FFYjlERXpuSW9BVW83Z25aV2FF?=
 =?utf-8?B?SHgvQzZjbzlyaW5JZDJ4RU12aEI0UzcxZTVvSW5PTUVrZHZpaVh2d3lTcFdi?=
 =?utf-8?B?R0xWMzVEZndBRVJGbk1qOVA1OTNBNERCK1JITEJCSzBQcGI5NUd6c2UrL2o2?=
 =?utf-8?B?dXNZYnRic1dzSVhHVi9ReWpoQjVldUlKdkVhai9hbnBVSUEybDExdnlBenNE?=
 =?utf-8?B?NlpIVGdETU1jZWVOU05wNWNHUXhGbTB0S3ZFZFFYc0QrOFh2R1paMjFhcXU4?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OR4JYiEieHyeWmHkS3xtWFszPNfSWW9eiYSxFNT1zQZk6Z3Nj58xzC39NUXT31+ic3PdwXFlk/7M1+VIBxWf6d/p6Cp1kYk9HX/mmVF73KkIJab2MI0P/gIggk4onNfgVN3sTUQLHdaVj2eI8s1HIrWCF4gVvXY3mlxJHttZOT/Osm9K+S9NQni7UlrZB1B8ItJKvSTJV+2rUNy2UqROsHjKRbE2YQx89JvXkUqPrZBndFSEm2U6VwcBHl9jsJTNuqqULcxmnkF22aC90foQM6D5z2cIEpQAyEzdDJPUwbSFnwi1VPhk6Ddo5AL+srS7c59ZzlaVgwCx5NNweHKsTijSfEUSczsnX+XRBVj24zxERK+73o5PRx1BxxLGaPPWsPmla5IKdQSXeyyh4TFEe3XuuWp1LqspGHGvBpyRFG7xKoz7PSCNSLkElJLIJW/pJuTf4s83/5//HoLx/L+hUD679EWDrCpjcYVX2a8IuE6xwLLDFklMFMMACBfwOr5GBoEcE/L8+LC2V/+y/O1C0Qn8l5YZCSVi7mvsd+ASWy1bD9/Fpv7Hdpz/NlMpzbnCJsdDZk2VLl7fln7pebKoGrTg1SVTO+lA4lylgOA/Ya4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41638c2a-f62b-4385-6584-08ddeedd34b4
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 13:39:59.8016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qfl0OHHuXcL1AOLzib3SNvwrmL1xsp8IG49VWMC9g9m2GSdL52xUB9DGlPElBzIgjxiRlnCLdgv2ED03c67Z0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6293
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_04,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509080137
X-Proofpoint-GUID: xTg7cFwMIcvQpMQUTSoe0bHZhKIhk6LI
X-Proofpoint-ORIG-GUID: xTg7cFwMIcvQpMQUTSoe0bHZhKIhk6LI
X-Authority-Analysis: v=2.4 cv=RJOzH5i+ c=1 sm=1 tr=0 ts=68bedcb4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=h0xRKc7d2W94agKUNJ0A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDEzNiBTYWx0ZWRfX657Pp+XORZRX
 KsB6sTUxSiGyGakLTPEyzNOfpJ8Xn0ma9aS1ew4uEJKAe87HQDDc7rWT7/kpslsFfca03sxp/DS
 tTHzvRtZnAj2r42cNE+QHccJN2WQNR9ofvSeab6r39NNxbJsZp9N+tREERyX552TOngNIrQEexd
 eJcShP9yDR1iFDvh0xcpcJyPrbBTz6ILznjh0Rcr4x4TwcHow/Y5wTJxiQSxHHjuvJ8ZIE/k5vG
 v5dLXPTBYB9gDmqJtuLtPO6NLYbTaugcpSIqByRqM1g4Z9UVXfJAH5lufm2/bex6Hridp1Wnoia
 rmigvLZFsrqkIQH43FNo5o/VVN48e63GvHTFf04xJgVKeThwNG39OHqYoXKIOLoMCAUEigwJNy7
 6h+DfkbX

>>>
>>> Yes. The UFS error handler may be invoked if the SCSI budget has been 
>>> exhausted and may have to allocate a reserved command to recover from
>>> the encountered error. The UFS error handler may e.g. submit a START
>>> STOP UNIT command if the UFS device is in the suspended state to bring
>>> it back to a fully powered state. See also the ufshcd_rpm_get_sync(hba)
>>> call in ufshcd_err_handling_prepare().
>>
>> I assumed that the budget map depth for the psuedo sdev would be the 
>> same size as the number of reserved commands, right? If that is true, 
>> if we have a reserved command allocated, then we must have budget as 
>> well available.
> 
> A budget map is allocated by the SCSI core to enforce the
> host->cmd_per_lun limit. That limit does not apply to pseudo SCSI
> devices. 

Sure, but if you had a budget map for the pseudo sdev then it would be 
simpler, as you don't require special checks, below. I appreciate that 
the budget map is not relevant to psuedo sdev to enforce any queue depth 
limit tracking. I am just suggesting to have consistency between all 
sdevs, to have less special cases.

> Hence, there is no need to allocate a budget map for pseudo
> SCSI devices. The patch below shows a possible replacement for this
> patch, assuming that the previous patch is modified such that no budget
> map is allocated for pseudo devices:
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9c67e04265ce..91a0c7f843c1 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, 
> struct scsi_cmnd *cmd)
>       if (starget->can_queue > 0)
>           atomic_dec(&starget->target_busy);
> 
> -    sbitmap_put(&sdev->budget_map, cmd->budget_token);
> +    if (sdev->budget_map.map)
> +        sbitmap_put(&sdev->budget_map, cmd->budget_token);
>       cmd->budget_token = -1;
>   }
> 
> @@ -1360,6 +1361,14 @@ static inline int scsi_dev_queue_ready(struct 
> request_queue *q,
>   {
>       int token;
> 
> +    /*
> +     * Do not allocate a budget token for reserved SCSI commands. Budget
> +     * tokens are used to enforce the cmd_per_lun limit. That limit 
> does not
> +     * apply to reserved commands.
> +     */
> +    if (!sdev->budget_map.map)
> +        return INT_MAX;
> +
>       token = sbitmap_get(&sdev->budget_map);
>       if (token < 0)
>           return -1;
> @@ -1749,7 +1758,8 @@ static void scsi_mq_put_budget(struct 
> request_queue *q, int budget_token)
>   {
>       struct scsi_device *sdev = q->queuedata;
> 
> -    sbitmap_put(&sdev->budget_map, budget_token);
> +    if (sdev->budget_map.map)
> +        sbitmap_put(&sdev->budget_map, budget_token);
>   }

Thanks,
John
