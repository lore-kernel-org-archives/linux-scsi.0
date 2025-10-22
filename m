Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8DF2FF64D
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 08:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761120051; cv=fail; b=uzi/Xkk2tK9ij7bj7VbXqgcTuPRnGf5YrXkxqgT8sV2PAo0tZjehk15o5h7kkTEiqTiGnuGx1c/ThpjJrOZhv9srZvDdqwLpA4qVelFUCeKqtkvO6ncLm6kgjbqsaWy1dcqWQyHIMIA1nHLWR5gt4Zr57rR1Xg54rGcQJg+CFkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761120051; c=relaxed/simple;
	bh=C474m4W7F7M+KccoZnfPiq/0YkPpnCAaivpAYv2faoQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q0ZTvhrBCT9zLJf8jDpHyQmXSepNTB73PLgu91NJo/lMRPTJd0NVDvkU+MWMQv/MGR5z1yP2++hKvHdzwbxq96dlDr+n7Mqw1gw9ddKeVZwg81G5G6Sz+Jz4Xk0/6edrvMYSYGuTmXGsMHfvXGrxoflckuXkxLyX59/ENJPPxBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G76NZVBf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bF6zkai1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G76NZVBf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bF6zkai1"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M6FYgn022140;
	Wed, 22 Oct 2025 08:00:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=AXdJ169Zn+XO1cXBlzHD60GEgwdaHlwG5ZTbq3wx0Co=; b=
	G76NZVBfRn6VO8qF4WUb7iRhUqIt8TZ5SMRVW/0zkdW2NpYDaklwjtcCM/93HBG1
	uidxG8ZpJVTyOxk3uZr8eeHY8AkdgLz1k0gY4Gdr8LEj5oLGK/HqEDlE5nTrFQ7L
	9w/z1+6Gz2Bq3HZ7sjgBIRtIQ7f4fGF0J33K4gRdEf8jI95ywb1vSseRcZfK03Vq
	VqVQhQ9t/Ot78Ukqw+pps65Fn+iSXSu2pywD6RafCEv/sg7ed6vCjBW/r+YhJAe7
	g5VF2Vex15ROmqfa2z91r7He2fbZZfXngLxeGKJyX0pjyenAZneBxWUGaoIif+4O
	j5NRVaExqUFfGHIz83KSPA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xstyg4ta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 08:00:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M660RF032333;
	Wed, 22 Oct 2025 08:00:39 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010019.outbound.protection.outlook.com [52.101.85.19])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bdvpvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 08:00:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oePZ4KyljKHkxUevmyS9wg9DdrF/9EO36tp/JI7skCkoKkTU4WABOlkCeoYtpm+qNzDQhj2aQc2UZQIwj/Sji+qlG30LpOKvq254xFQ0HFxy0IYTC5SzOGuIjKk1WgBjiUF35O+JGiVOv6mDv8qgvbMy8zUSg32ODyDy+CxreIm5TrANH2jer5FrR6AdBq6w0HR6xqG2BZPJB/5q6bIeyTySZnQBy1i8HCaCSbBN+IZ7toqihNiJwviTXnPCzPDt/hi2wtxeT0wZwDIoXsTAnCtq2x4WCe/jlXgl0c1/RgXcFGASOM12RjHbD4JvsRglil3OjQ9GmIZR3YCWVinPvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AXdJ169Zn+XO1cXBlzHD60GEgwdaHlwG5ZTbq3wx0Co=;
 b=hzYIPTWxb5UYDc1aLCAzgZ7p2u557+kV8FgVJY3fd/Zlwzblwz0p8LiK+C0+AUmm7TRmgnZhvGIDfLJFcUW0hVJ8reV7UzYk4ZHnyC8l6VmjuXj968Wff78jb6nn7UDuosc9ffoHybCrqFAcqiomq/KWRM1URHGKuV4J2rx0gpKwKqblJx+nWz3ELmwrEhaxkRi5v4G4zbEMf7CGSeINtUSau2vTDSXwmIZxe4y3IuAXJUOywH/oUYQcMrC0cu/NaqqlFoeE3xUEZmzq24qcxa/iyoNteog+v98zqQuHp9baQ6U5CbkbAb78EOL3C/201Jf2JWt6NzhTvhZtkJuE6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AXdJ169Zn+XO1cXBlzHD60GEgwdaHlwG5ZTbq3wx0Co=;
 b=bF6zkai1ydyYuOmenMSzjaDKAcfsxuR3pKc4RXWg2OXyW7fnmIDnN4eC2x1SAdfPOm/g6Exke31gYP2uUvwkEW1RjL4ops+x56mKoclBvy5KMK8pFA1C9HCXJHzY8AZOieh7gSAW7hB0sIu8+3MzCLRLCMxupBuAkh0T7pvknqM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MN2PR10MB4303.namprd10.prod.outlook.com (2603:10b6:208:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 08:00:36 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 08:00:35 +0000
Message-ID: <e51a6615-91fe-48d7-995a-7fb84007ff5d@oracle.com>
Date: Wed, 22 Oct 2025 09:00:33 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: aacraid: Improve code readability
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Gilbert Wu <gilbert.wu@microchip.com>,
        Sagar Biradar <Sagar.Biradar@microchip.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251021201743.3539900-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251021201743.3539900-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0003.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:2c2::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MN2PR10MB4303:EE_
X-MS-Office365-Filtering-Correlation-Id: af91ebd2-82ce-46ed-df0a-08de114114d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eEEvUFFIdmZQUGl0NWs3aTdQS2pvQlY2dS83SmRRNENHM29rY0dHKzJHUGcw?=
 =?utf-8?B?blZya3hCNnlpd1lrZGUrMHduUDdiMUhOS2s0eFFkYktOektjZkxBRWl5TjRS?=
 =?utf-8?B?dWRyNlMyWldiMVJENnNjellaNTNGYnEzQnBFSTZDKzRUbFZuT0I4RkMxRTF4?=
 =?utf-8?B?S2NYcmtueHRJMktZRWNEcnNhRDk4Wml2bjRhNWZxR0JmVmQ2OVlEZkFkZUY3?=
 =?utf-8?B?WGFnTVMvUCtaNndCZ3lrRmtORE9CWHRpWmpYMGRLK1REbTUvZ2o4WURsZnFK?=
 =?utf-8?B?clJxSko2YWxrdmVJTTBMdmFIYU0xU2tDSGVia01KaUV5dEkrd3lzS1c0bFFN?=
 =?utf-8?B?U0pSU1o0SkxEK25aZWpQNmRuY1EvYlVnTFNKdW9nS0RmN0o1cXI5Mld0eDM1?=
 =?utf-8?B?eXdURzhGTzZNT0tCOXZtZ1JIQjc5c1U5bDFkTlN6dGliTWFseEpjNVd5Uzg0?=
 =?utf-8?B?NWs4emVJc0pwak9LNk95RTdOVVIwdlVNOHJOQmlzOXM5NFMvUnFvMUEvdEtN?=
 =?utf-8?B?b2FmSERPQmtvRHlKTXRqKy90aWJ3Tk9QVjZndGFmT3lOclhTOHVlcnhCUk9Q?=
 =?utf-8?B?ak9FNzdyYUc2WEY2Tmp2cThidGpNVlBVY1JBL1hhbE55d0RqajhVVlZReHd0?=
 =?utf-8?B?bThudWVXclJVMG5XR0I0bldvNzFMUlJXd05yeE1KMnRQQWE2SExFRndSWWlB?=
 =?utf-8?B?TXNuWVI2REhCUGoxWm9CREo5dGhwNUphNmZLMi9EOW1BSVdoMVZPN1Bnd3A3?=
 =?utf-8?B?N21tTElrbWgzNWhud211ZjgzaHluZGpCMVpDRjBKTTk0bW9mSTgwMnVleUZT?=
 =?utf-8?B?ZjFJeHd3dnNsejQ5b0trR2F4b2UwTjd1N1ExOHhBTE9sNTNIdUhSNFpjSjQ4?=
 =?utf-8?B?RVFoalJveFVPNjlQVHQzSjBGM3g5UDFZVkVENEpMQ3VSNnZhMko1VzdGOXZi?=
 =?utf-8?B?TjhMZE00OVFZU0tZYkplQlZFbGpvVkFTOEhDQU5aQm40eDJiQTJEU1kxSXR6?=
 =?utf-8?B?dE12Mk8ybVE2b3BuNW1lR3pSclp6NEpGczRka2NpWWY2a0FrSjhKTWlYNDRN?=
 =?utf-8?B?T1FtU1RwMWNHUFFrR2RpWWJkTm85OTVUTGZUNjhDWnNGNGhrZHFKRTFGVlFj?=
 =?utf-8?B?VTZTRkZIK1hOd0NPK2pNSDhSUzJIcFRUTlZMcWxDNzdGNDNvS0VRTWRQTVBM?=
 =?utf-8?B?SjZvaUl6UmREeldDVEh5TExZOVZ5aUwxamo0TE01L25jRHl2U3B6ZTFtY1Zi?=
 =?utf-8?B?bGttZklVMkRIb08xRmp2MWZoZTRJL1NmWVNnaGlSTHRwVHdUbWdDUVpVM0RF?=
 =?utf-8?B?NjJrYlZaaUZPNEQxUGM3bmpIclVuWWtyWlhWaWwwc0dnekRQR1lFOHBiVk1Q?=
 =?utf-8?B?U0JhcjZkNUNtUEYwUm1Eb21OV2xRK2xjbmRBSHhHRkFwMGVtVUZ3S3VESjFp?=
 =?utf-8?B?UkRwNlBsaTU3Y2ltMmlOc1NXVWhoOFpMQ3FOWVFFSys4bVVDUVROVmZYWnYw?=
 =?utf-8?B?UGEvTkY3VmxkYjR6aXhUVkJCZmUrZDAyajM0WmkyQUpPaDJiL1Fmc3B3OWdy?=
 =?utf-8?B?QU15d25UT0pCTTZvakFZODFQalhqbFBic254N2Zwb2w3SVpUOEtrMkFNOGlN?=
 =?utf-8?B?dmxRRm13Vmw0Vlk2a0YzWWRlQWo1aVJOZUh5TGtKU200WmFlSzBPZGNwS3Rt?=
 =?utf-8?B?RHBRMk1CeUFSUG5qbXJtVHl5ODJpUTJKUFhncWllUG1WVjFzanNUbTFzTnhU?=
 =?utf-8?B?Zk5nbFhHU2hWRFFLaXh4RzFFQ29vVWFWSXZicTRTLzEreEliSlRTY2JoQlNJ?=
 =?utf-8?B?dWJmR0hlUEZTbUluaTArWDhoQnMyVHYxTjFubklzcmtmWEFDVVNkTllnU2xt?=
 =?utf-8?B?ckd6RmtZaW50RUN1aGVaMDVLOHJ1QzJza2RQSEpFVzA4WW9qdTJ3aTVaVDV0?=
 =?utf-8?Q?F1b5b4HlW04BzzBoOOhKtZeVLLEvYhnQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cytldURDSXRaLzliQ0Q4L1djSEdvbWtsVW12dUF2Q1U0YThJSWZSWnJ0d05W?=
 =?utf-8?B?L3h5aktCa1hGdTloRGFScmd3SmZONHpnRjlxdWl0bFRMaHJod2IzRFpZbUxF?=
 =?utf-8?B?ZmFMR3hIa2xjR1dReEpBTlFhVGJUWFI3L1dpNDk3R3AyZVJoSWJSL3k4Ym9m?=
 =?utf-8?B?cy9udWJtL2F1SzMrcnM4V0xEdXM0REIyT0ZOemI2NmpIa3hCUk9zeVFnQ2V2?=
 =?utf-8?B?bS9ZRG5nQ2UzQ1RHSklXSUNhZHdxclRnazA0V0dNR2pVeHEyVVhLTXl0OW54?=
 =?utf-8?B?d2xrK3NVd0drRG5qUWtTNjE3UXFEV1c0di8vMTBFTFlvYkg2bm84RkhNei9W?=
 =?utf-8?B?Qk5vZy84Y2ppYVhUS3NtcGFwRG8xRVJkSzBiWFF0SFl4djJDckJRVmltQVpU?=
 =?utf-8?B?QXZsZjFoREN4WHR3akYzNVlEc2dkdjhuT05ZbEdwM0oyUGRrMFdJc2xiaTZi?=
 =?utf-8?B?VWNTUWdLYUg2djZSNUYwUzg0WVErT2RJMXFxOEJBRnB2Q0IxV3dRbzU0Mm8y?=
 =?utf-8?B?UFlwcG5UbjdyaGhjQmJWUnBLeFh2VExlQkY1MGxBbE9nYzM0M3o1ZUo3MWpB?=
 =?utf-8?B?Uml2N2xMZllmR21yM21zQVNqc0xmZzh0STNzRHd1a3k1amFpZWFDVmNrN25D?=
 =?utf-8?B?ZGpCRXpUbytKWUExR3prOXVvS2tkOEdqZmtBWHhRL1MvQ2Rtc0NxRFBLM3VX?=
 =?utf-8?B?L3crQ0k0czAwWFhNYzFQenBYdUd3N3l0L2Ura0lva1RLYXBUd3NuN0tqM094?=
 =?utf-8?B?M3VuOFNxQW5mNElYZzhHRmxFV3N3Tnlqb3ZoUmJiMjhXQ1VzYmNaK1I2cm16?=
 =?utf-8?B?dHNaQmExMEtPYlRyaytxLzUzSnRIOEhyYTRxNTU3bnUzQnA0QVFld1dZV0Q0?=
 =?utf-8?B?WEI0SjNzWkRFUXlkRWRmclhrSjFydCtJQjB0WkVub3V0YUdrYndsTEpodXQ3?=
 =?utf-8?B?QVgwOWUyc0tiYlRKSGRpd1h1NS9Gdzdkc0pIWDhFV1pjeFdnaEZzdklPVlBv?=
 =?utf-8?B?RXl6WHZ0T3JzeU9Cb1luYk9ZU0ZXYWN2UkhWZHJWenhyNjlkZGZMOWRML2xh?=
 =?utf-8?B?cDdFRS9odkRmaHQ2djVTZDh5SGJoeEM3cWhKK25NWlBEV1o2MlNyMkJqY2o0?=
 =?utf-8?B?YzkwbUVIS2xGR0lRcmIzYjdhNEN2WFFLT25wL1dBcDdrNVBJWDh1MkRmZ3dj?=
 =?utf-8?B?RzBNYkFGdWhnYk13emRiTC9MZ3NuRHljNElwbDdVVTRRUkV1SFY1Z2hrOS84?=
 =?utf-8?B?WWpGSHVRYkJrYjJ2V2J0Q2J2Q3BNem5WMW9WNXdKd2laTUpRNld2djVoQ0xS?=
 =?utf-8?B?Y3hwcW9KalAvWWcrN3ovR3R2Wnk4ZDdwK2owTVJZd0t0SXA5a1Fob0p3SFFV?=
 =?utf-8?B?UTAzVnBqT3dsTDI2L0E4bExRT3Y2bWt4ZnE1RVo3b1d1QVRkblFUblNMSGQv?=
 =?utf-8?B?cXI3alpEaDRrdTZpUVRmQWtKN0hZWjlqK2VibHpmWXNSVk8vaDUyRXBtRmJn?=
 =?utf-8?B?T1lVcEZJSlBQTGJOeHlVOFViemlqd2ZEaEJVUEZubVRTQ0pteUtNNDJnSkJR?=
 =?utf-8?B?L0FNMDNMRVlHZ2VyYzVhcnd1Rk5lQWRlb1ZBcVlmQ3lCY3hLZlIxS1gwYVNH?=
 =?utf-8?B?YzZOcFJaWllGSHdPeVNBL044cXorUUNjUUN3aVdNaWVRNjA2NkVIK1JIWGlN?=
 =?utf-8?B?UWF4dGd6cHZLR3ZCL3RxZkx5N3hYN3BZZmsyR29CMGVYd2RsQjBaR1dxbXpN?=
 =?utf-8?B?WDdJUWxJcUF6V01FUWkySVdYa3JKcUIzT1NUZDBaQ2xzcSt2czFDeFNxNEls?=
 =?utf-8?B?alcrWmlpOTNHZjN0c09xcERaQ3F2QzNWbDhmajVJQjgya1MxdlpqM0thanF3?=
 =?utf-8?B?NXJFVW40VUlIUFRaMXNnNGRYWGVmRjNLRVd4NjJxb1JMRGpTbmE5Kzg3dkNp?=
 =?utf-8?B?MVI3RlVaSThjeExaVXhCWFluMXJySW5jb3hIWXNrU0dxM01SdUJYUWd6Tmtt?=
 =?utf-8?B?VU5ZM2g4RTN6T2kxOHBYK2d3REdZNHUwWS93ODU1ZVdlWFBuWGxqTEpxanBv?=
 =?utf-8?B?MmhlQWRJckN5NkZxVStKTUU2eS9lWGp2d2QwZ0Y3cm9FRGhYT1M2Yk1wOHNj?=
 =?utf-8?B?dTNhNlJESnpveVdLckV1R1RrcjZ5U3pXOHRQQlpGc1djaEp3ZjJ2UFM2bW9C?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hqjeuD2qg33LQL80igbwAZYITwgj/yKzdcz1+YqIdlKWDeoe8C4xjx9xIJmej4z9JZrHZmouXgJZIh+Q1lgrcI1+0/yWBqgG1v36mywoLMomkYjmMAawUnKrFL+BaE1ejdwNzCxcRNqjiFVZMYr2LXYGFo5hZ3I3K9IjAdMATXenySv3tTSn2QpOIhECVoGpPtLM2on/UorYbc2dSveT0gkqfLpbDvnWNPKwryGz2j/xsCBsTwMIKi9DJ/xxX0sIzEnGBLOqyYd4ILKqU6rg5XY3xBCnOkr6eQammEEHaX16BDW4s9EXPmK+NXnb7hxpKtNzohp9//2icwBOqBIEZ4CucBLyDs4f33Wz45E39YEPqMSpmR3pdOszB746TgS8TqiObiRqYyqwOk2ovztJhKlO1ZNWo/RmscbFXKiJ0FkbeLlnqkt3qsbddjbilhpB+7mwFXyqXipIS+4AHar32zXD0ErDialiwrJ9mZKS5bIOWa/FUuHwGypgLzS9z5bmLF2+0JPgSN3AlT3qe7GQ2MfQIg8eJFwbSdySulP3GERQFoLMDz7labYgHUZWbW4//wb6WcG7qQbePN1NGNfDHhL0D6JqQHcoVGkYfeRHigM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af91ebd2-82ce-46ed-df0a-08de114114d9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 08:00:35.6075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S2xd+bhb2StYxIDD7mW56jGHNN827iNMHnYh9nuQ131s/Fw0Cmvw67WI/roq+zxpGwW5Y/zwC/n+cn6PmLVuuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4303
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220063
X-Proofpoint-GUID: PXDkK9nBX2AMdQpfg8PP2mAW6SC4bsS4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA1MCBTYWx0ZWRfX90a4PbLGyhcq
 ewMuwkbmkTwo6y3vEJ14f9K+qKSV/tSNvfzryVOJZjI/zFQKjow9431bU/AfP6IZGG649N7kieQ
 cEZEn1eXhQ0HIjwSpTEufApLw7uCnK339fBpaO9BVkzOFt4H/VLdjnfyC7EsWX2hd14dLBjFKFT
 kqFBJ58IKxYL2kf3QLOqeRl2hLBUMotnkeA1hGKKRSC7x5FuJ0+RWTuoYm8EH2Q52FElzLW53dy
 z7EAPwShYt605GYtkOhn/vFXyS5iy5d7b21ICnOvnhzx2xFezkkreIRMnZ2E4tIeL2+fjU/Yy/V
 ckpgUKnuNU6UvBZFWG28nvtHYm2ZCDHBa83ydbqEtFya3zi+Nxert4NXk1HK086daE39DdxUIjw
 BVzK2gRgzPd/kKKtcO5lss+IbzGIt2XARXVsmVodBYvwdK9Yn3o=
X-Authority-Analysis: v=2.4 cv=OdeVzxTY c=1 sm=1 tr=0 ts=68f88f28 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=XYAwZIGsAAAA:8 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=7QkVp4JIjVkmms-0QjsA:9
 a=QEXdDO2ut3YA:10 a=E8ToXWR_bxluHZ7gmE-Z:22 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: PXDkK9nBX2AMdQpfg8PP2mAW6SC4bsS4

On 21/10/2025 21:17, Bart Van Assche wrote:
> aac_queuecommand() is a scsi_host_template.queuecommand() implementation.
> Any value returned by this function other than one of the following values
> is translated into SCSI_MLQUEUE_HOST_BUSY:
> * 0
> * SCSI_MLQUEUE_HOST_BUSY
> * SCSI_MLQUEUE_DEVICE_BUSY
> * SCSI_MLQUEUE_EH_RETRY
> * SCSI_MLQUEUE_TARGET_BUSY
> 
> Improve readability of aac_queuecommand() by returning
> SCSI_MLQUEUE_HOST_BUSY instead of FAILED.
> 
> Cc: Gilbert Wu <gilbert.wu@microchip.com>
> Cc: Sagar Biradar <Sagar.Biradar@microchip.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
> 
> Changes compared to v1: instead of failing a SCSI command if aac_scsi_cmd()
>    returns a value that is not zero, let the SCSI core retry the command.
> 
>   drivers/scsi/aacraid/linit.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index ea66196ef7c7..82c6e7c7cdaf 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -242,7 +242,7 @@ static int aac_queuecommand(struct Scsi_Host *shost,
>   {
>   	aac_priv(cmd)->owner = AAC_OWNER_LOWLEVEL;
>   
> -	return aac_scsi_cmd(cmd) ? FAILED : 0;
> +	return aac_scsi_cmd(cmd) ? SCSI_MLQUEUE_HOST_BUSY : 0;
>   }
>   
>   /**

