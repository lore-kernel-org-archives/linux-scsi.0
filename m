Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D8D306499
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2025 16:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758818322; cv=fail; b=W91ji3NQhAE7SXkWXzzkH4ngdFbIgzPG3MGSyuXyI4sY5V6/SrWBUPNkb4zw+zobGcV8kXL6iPxSmYGXS2LO0NWfELBkdmhTPAFBpYigMwi6eOJCQhw+sW8GUaicWa1WzRb1Lbz7Iz/aS5zxurqKOPj3ifKBylMxjTcA25Asqzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758818322; c=relaxed/simple;
	bh=0Jt+UNiWhYSH7WeRbbEPH2efdrEh8GrZ+id8khQflQI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ncj1sNXrb6CkiaLUkEHQ9zt2x+wbxUfPJ5lIJcYquW/RKqBzjnm9+Fl+Cd8ZGApLhXLqK1K/pLUdm4ZDf0tFQZlvyNDCgLPyfs0rh4gPnr24s0dAb9f8PhtWYCuIApMxjMsE3VS9EAOJtCLblxnLkz0oosVgWkUcActA6jmZ0AM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IjreSI8X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZhQcWMM4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IjreSI8X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZhQcWMM4"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58PFtxe8030946;
	Thu, 25 Sep 2025 16:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NuJ1bLZVwMbS91junhyhyMlvPGLkhmI+hWRZS5lvIZA=; b=
	IjreSI8XEAupM48qvMxB17EheZbjsdRw6kXOgIs0aUfJkcSDB7WG3UMKDkiXvv9g
	9NjggyChnDVr5tPq4qgv5Mk8MyI9tIOK+X+ttmB2GNDhz2AohMsUlQqjSjGe4vW+
	1X2mv112jDOAalRy9aWGjiJbuQUO34HeTei0QAIoHEkkCvfIm4WftWHhZL28ED+n
	jgpjcgawqRkNVtbwOBmHHSpLMx332eGoaq8ogpqUGQ508EDOB4AlF0MV5DsGXcsC
	wV/7Fy6v8ogUWSukuqft3/aZMpsh/EFarkiVVHX9EXHVf7sCWvP+xErlW+yq1ZWJ
	8wFF966JhmjTrzs450ro+Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499k23jeee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 16:38:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58PGPMbN021633;
	Thu, 25 Sep 2025 16:38:31 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012033.outbound.protection.outlook.com [52.101.43.33])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 499jqb9k1w-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 16:38:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MmSC5jgfWgpLO3IuBXx8nix4NSHr43+GiASS0JsDMFQyWPi5AMhs+KKxnA3rL0yOKGQ76sPo0x6VrutxukeVj4KKa6Ouum9u/jEYU1vdoDB8NqECIjLnfyioVxbf/DNyylAV9GWXCe7YzHHFmC3ZCotCexTvM2BfbEpesYD1yLW+eWq+X8FvwVn3m5yOtzHKxUAFZPSPhientYh0GnQ48OFS0EzHSYwNEjavUnmf4Xr9mHEbW8tcJxFWi/EZL5ZMFtinp1mBuagY3e1b7j+XVjY7ecXRtX8qiV7TtPUQTKsatVGGr/ETzmZ7CcZ+8jnxVhDv1vl9NsyJpQ1EhiC1yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuJ1bLZVwMbS91junhyhyMlvPGLkhmI+hWRZS5lvIZA=;
 b=fKBtzUt7YgbFkk8qaRQ4oxcItgdVHGnGNDiQUm1qvkA35h9Qpsb5Y+nSHJjtPwy47nPyxZkWv/JosYkBm2J+S+UucTkowIY607iYNkMHXxvC46M4+NtIS/bvHjpou3lwtLLpPDuh/e5ylr3oTWNr6GupEqMYlKgnjMh/ggGl3wi4z/GsExYPqBXOAx8C5fuuQotN4OEBA+Jox81SYhA1Fx7kLeyShI2U5kKD4Ao018c0USxrhHG4ASBhyTVI3bwsgVAiyUgOLs/f5WMvceJMSEl0hUKq813VBlmZSDj+WlPGvAUZmVBi3oHjonBbEYX5RfQcKB3PPNv2a0LfefNxKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuJ1bLZVwMbS91junhyhyMlvPGLkhmI+hWRZS5lvIZA=;
 b=ZhQcWMM4b/qQ7S+tn1OZVOdSBYBLoPckmG3K3I3E3JOLypzlvEYM0CvSk5lTOCoefZ0GiXOh4MOX15AXQHHol66o7xihVdpBQqGecaoCS6lIg03Kx4RMCosbA1MOJMnKDBmOXtyKhTAKIUmcOxjdB84pEwowIbqPDphz7lI2xt4=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by MW6PR10MB7686.namprd10.prod.outlook.com (2603:10b6:303:24a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Thu, 25 Sep
 2025 16:38:26 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Thu, 25 Sep 2025
 16:38:26 +0000
Message-ID: <f4a572b1-1c8d-434f-a5c9-93f1cdbd42ac@oracle.com>
Date: Thu, 25 Sep 2025 17:38:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/28] scsi: core: Add scsi_{get,put}_internal_cmd()
 helpers
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-7-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250924203142.4073403-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0116.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::32) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|MW6PR10MB7686:EE_
X-MS-Office365-Filtering-Correlation-Id: ef58a410-97b1-4d01-b5dd-08ddfc51f351
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YkVhWm9KSkx5TUlONTFRelQyTVJnZllxWTFVWUFnTFQrUHlGdndZMHBXQWdu?=
 =?utf-8?B?aEozV3hhTGNZbjNNVVJqZHF1bXJod0daMHYzckVveVlOTVBiTWYzZ2lvY1NC?=
 =?utf-8?B?NjFaRVJYU2RkelJoeHBLMFVncDFmOVc1VzlYS1ZRR0ZJSTVmWVhpaFRWNndh?=
 =?utf-8?B?YTZQc1piOWlIT0pUSFpQZTBxWFJlTjB6dmduRXBNR0VuTWpWV2RlOG40NjJa?=
 =?utf-8?B?WnZrOGtwaWR0YkdnMFZjdEZnRVdaYnJCWEpMeXZXVWxaOHlKd2pTcnZjQi91?=
 =?utf-8?B?OGlZL0Z0azhjc29oL0pteDlvSGFva01XSDl1bWdVOTh3SnhVVWU1Y25Ec1d2?=
 =?utf-8?B?YlNHR3ljU3VWb2ZiM1Z3WnZqMC9mNk9EYWNWajBCR2VZQnM1YXZERUxYclZS?=
 =?utf-8?B?TldEK3p5Yk1OME9HQkZ4Q1YxY2Fic0ZuYU5VL0x5czV6TnpaNGN3RXZzTnJ5?=
 =?utf-8?B?aG9aZFhNd016R1ZyTG0rSVhCOWlNemZIV0hzTFJjUytjNWpGNE9hblJJUHMv?=
 =?utf-8?B?akhJRDB6L2JjUGtUUzQ2djl0RjZyQUNHVnhodEJRSGdzbFJBb0ZwZktsK1Qx?=
 =?utf-8?B?SkdtdTBaS2srYy9FMUczeXNiV2I2Wlo4YnZtZENCaG9aZWE1U1BWdTFWeVFK?=
 =?utf-8?B?L0ZGN240NzYyS3pSRlBVT2ZjOEMweXczT0pIN3FUa2E3SHZycnQrZk96NDZl?=
 =?utf-8?B?aGEyMFpaVzJMaCtoaXI5RFpBektxYzBDYjBpaERRV0JrUU9waWpyOWQxaUx5?=
 =?utf-8?B?NXBZZUNZNE56RHptZ1J6Tyt3TkZTUTVIL2Y4WmJIajF6RXRSdDh6bzdzZWNk?=
 =?utf-8?B?RzloQWUwcVRtZmkyMjNUMkFXdDU0cE80K0puRk14SWlsUEJUb2ZTRGg0Nmsz?=
 =?utf-8?B?a1VpMmg3ZHpDc0VPakhueGs2ZHVNcnI0bUpXLzhUZDl2Um9lam9RRkVEV1JH?=
 =?utf-8?B?V3VGT3NzL254UzM3a0hsZkpTVU5FbWhMdGdEN3lKL21uQmNkQUFvcHJTQ0hu?=
 =?utf-8?B?cVRMaXhEYzZJUXhTSUlIYmFTZzB3R2FDcWFES3dQTExkMHhzaUtCbXYyYVlZ?=
 =?utf-8?B?a3gxelZHeS91K0h2dldCdzhuQld5WnF3NXNvMmVucFkwUkNEeWpKeHh6VFdr?=
 =?utf-8?B?UlRhekRtZy9TeXFzQmk2YWppL3l4c1pwMEZzWVkyeXBtOVUzUUEyMHhOTEg5?=
 =?utf-8?B?Ujd0aUg2Si84TXZGWVRocnZoR2hZbGxXamJiaUp6bCtiMGhTczJEQjRtc1BE?=
 =?utf-8?B?Si9mZkNyWjlVK2pQOGVFREtXTDU4dHpnWE1tRFV4U09mTGp4QUNiS3ZkNWE5?=
 =?utf-8?B?QmxGZysvVjVpKy8zTHVhaVZsNmNjV2hXNXN3cmlKaE5SbmhCQlFSL09BSUM0?=
 =?utf-8?B?R1I3MlNmeEt3Z0ZYUWo1STlDZGExTnRZMHN0ZXUrekRoWDFjc2o4dnNibytp?=
 =?utf-8?B?cGs3UFN2bXg3RFp3Wk5ENWdyS2daT2lScGkwZjh2MVFzckJRYjFLbzNiT3FL?=
 =?utf-8?B?ZHVySUJHWnVkenhlcW9GbnJIRTFnRzB6L2dDZWJQaXF1aE0rL1BydFlzV21I?=
 =?utf-8?B?d0FvZnAyZHVLOWF4dngzcjJMVmRKanRla0NoaXZLanpYZE52VCtGQU5lbjJZ?=
 =?utf-8?B?OCs1NnJiOS9FUHQ0NkNXa3NaUGtzc0tnelQ5Q29ya2N0Si80alZFWlhOVkJ6?=
 =?utf-8?B?S1ZBMUJjeWwzMnRSTmUySmxtK1RqZnFjMGt2bW41ZHFYVDdVOFhIV2E4VVFz?=
 =?utf-8?B?WGpWejlLSGozZExoZFdhRC9kZVhZRnlPYmIvaFRieG9vMDRjWlRCZkJ0QW9t?=
 =?utf-8?B?VUJ3aFJPT0F4REFyMFBQb0wyV0RzTTU2R2tRWWJQNVBrSjlvOE9DRkpEc2pm?=
 =?utf-8?B?L0t2RVhEOWg4cmN6VHRxYmNSTngxRWk2L1NFOUdYTzVxNDFSR2M5cldhSWg2?=
 =?utf-8?Q?Gv6+sd58CDc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmtWTFV4S2lHNVVTdFhJUjlZQWR6L0JyTHBHTWxmbmhnaTRNQ3E2a0xyejQz?=
 =?utf-8?B?bDR2c2tybzA4dmU3TmZiMlJPeGFTTUVIR0VFWWRiWW5FSzlyY1Y3RUhWV09B?=
 =?utf-8?B?dTJJb2Q1U1JpL1VJbkJNbjAwam80SFFqRnUxWk1Odkx6dmZpVUQvOEttdFkv?=
 =?utf-8?B?cTJBVmx2WC9xSE1XV0ppaGsyVXNIUTRjRzVEYW90bzZqRXIzN3VPdlEyWEJr?=
 =?utf-8?B?dG5SdGtxeHRoMWRaQUlSc1h0R3JTS0xPM0FhSEpDN1M3a0w1cXR1dHlJQlBJ?=
 =?utf-8?B?bGk4NWUzcXB1NXhpaDM0UjRDL1FveFcyYlRMNWNMM1lESnFtWk9qR1FEcHN4?=
 =?utf-8?B?M2Nid2tIaFI3VWx1UDlDY01lb25qUXV6VU9qWXhoZm9HY3pqa2xwL0E2Uldm?=
 =?utf-8?B?em1HMm9yQmZiUlZwdXhoU2k2QjlDdXoraDVLZk1EdGI5M09NT2ZTQU5BckNq?=
 =?utf-8?B?S2toNUdYRHFFZzZqT3JVUEl0WkR0eGpueC85WGluNHR3a0NQZTVMbmpFR1lI?=
 =?utf-8?B?a3doWjdBRlNkYmZ4QzVxdXFyMGp5UjlnWE43aTV2RlRpYnIwTno1b29OU0xl?=
 =?utf-8?B?UWx4akJNQVpBQjRBYzFubFRaV3U2bEhhZWI3cDdpakdiZ3VKUlozT2EybjQ1?=
 =?utf-8?B?ZEJTcWlrVDJFckx2SEtFZ1hrQ2FmM1VNZE5NOHFsMjFpUlZVajZEa0cxYnFz?=
 =?utf-8?B?Nmh4L1MyZVRzTmVvejlHU20xTjFZR1pFN0JkWlBhZlhNSjNUVU9qV09GVlZF?=
 =?utf-8?B?ck1lYnpsd1pqUWZIUUo2TXJ4VSswVTJWZHptZXZzOEVHS3VBcTlsWkdaWFJP?=
 =?utf-8?B?ZkZ5WDZGN09pemtyMnNueXM5ekdKejdrMUVVRExCZFc3azljTTJaSW5ldkpL?=
 =?utf-8?B?RW1VMm45UU5MWHhzZ0FlV1FlOWpGVzFnaGx5V0RDWWhKaGVUdUVkZklPZ3U5?=
 =?utf-8?B?QTBLSmMvWUFRN1pLYklKMUVqbithMnBIY0hKTDIwZVdnVXR2dm91dUszdXpI?=
 =?utf-8?B?cHBqN2Q0TW0wM0Q5N2NaZjVzL0I3Qk1jeThkNUo0b2xJdGlhU3lxc1JMc1Iw?=
 =?utf-8?B?OFNhL2kzbDFFOGxxMWtNYVh2WUs2UEVSaFVGTTBVNU9IenQ0MmRiTDdzYlgr?=
 =?utf-8?B?S1BiT2l4U2Z4ZDVBTWpQeEVEQW1NSnZpZmVUd0N0cG13L2htQUE3S0pobHFC?=
 =?utf-8?B?N0RHRCtRZ0V0ZHhPZHgzNFhKbkErMk13dGY4bzllR2piR3g0TU9kZk1jTjRB?=
 =?utf-8?B?ZThZZnRUUURnVStQcW9YdjdYdFV4d2cyMmRxNHFrbFN3NTk0ejlBb0tjYVhG?=
 =?utf-8?B?LzRPQmlNYWhaQzRBNWc5THhkeVpBTkc2OW85d0hacWFaS3ZmejN5SXptTGo0?=
 =?utf-8?B?bFBrV2M0ajlRd2RMSC9DTkwxRjU0UFN0NVd1ZDU3YmRwWlZucGs4OWUxOE9i?=
 =?utf-8?B?S0tkUEdjV1dkTEdjVXIzcjB0RzFZZDVqOVlLT2NkNlc2VTRvOUR6aGR6dzlX?=
 =?utf-8?B?ZE14dlNLdWttcGhRbzhBMEMxUnpSN0oySEI0Sm9NVGdkMUlCM3Y1c2JVRW55?=
 =?utf-8?B?VVpOSHhIK3BiOEE5WW1yMC81ck1XcStad29CRUdjSW5NZERidVZiK2EvZDdY?=
 =?utf-8?B?NDZIWE54UDlaQTgzcUxmQUhmU3QyRENMZTBHeVZHK2tzN0tqZ1ZselpDRnJn?=
 =?utf-8?B?TEF2bk1ST29kMHNnYlljYnNxU2NLL1l3Q0tiZDU5ekFBa0l4MzNWMGh0UitT?=
 =?utf-8?B?a1g0N1dTcmhoZE93dTQ4Wjl3YmJjMWU4all0THZBNHdwRTNzQjVlb2pCTDlE?=
 =?utf-8?B?clhoVkhiV3JUNmFXZ1JQOElGVGpQTklYclZ4VmhjVU1rcURXOStrQzIveFZm?=
 =?utf-8?B?Lzd1QXZiTjB4UVRLdWtnWDZwSTJUYmpLRHR1dS9aelBTOGNmZ2NBcEV0V1dZ?=
 =?utf-8?B?RUNRTDdyUzhmZk9ma3djZzNXc216TWdheW83dUk2NTlZdEc2YXVBblM5Zmhq?=
 =?utf-8?B?NnVpQ1htZk0vVml5NGFUUGxFazUwVGRpYlVOcVU4Z0cwQlVHTlFMUmVJaFVM?=
 =?utf-8?B?ZXB2SXQ5cE9yNDdqQ28rbExZM1ZzUzFsN3JiM2xIRXh6SG5JZ09sUjlZeDk4?=
 =?utf-8?Q?xFW2elor/asHLVSHqtFNrfYfA?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	51KK3zuHV61JkmM0ex9e+ze8zM4md/jZTKTIvKeZXdkonziVmc3GPRzT4vZRKHEcQ4G0mKzqfSSVEhWkQ2zqO+v2bebRAQfnycL0AqHWaFmIyOgn+ACl5S5QrVNiK0xMXcGI5Mj4xJ3ViPzFxdvSjpyLR7iBV+/+SDx058os5I1tneEPg4TD5YIovc0NpMpmWWbEtbC9fmwMGnHqs9dWQBBtIcALatxYaZBVP+q8PGNAe5kpqdFoM/mLZt57+AdExgrwRsrb7yXlznBf7nWcg8a/FYxRG4VmtN2onVjNuZ1+mofu5vAkyAZjRkeEcjhuHw9ZGBN4RiHLRwavWIB7dTB368aSUajgC+a+91awWXuADQGMr5XsGI9TqzWLo9acTm88XuhkTSHzzNNpxZx2vZW8r8qZEndkjCB20p1g7uyKm6E/3BNmpwOJK0qM17UZYzsOwcrrLmIiJgbpkhNuqOXQRFMfq/m1puUwWDTqgFeRxbywQSHCi17LPgfpVJ1jnNTE2YHzY2fbuEdEo/sa1G2a83X8QUQgk1lpc6SSkAL320wrDEFUWgVHtZSVEHQNtB1AlgRslb3+HbZZ4oJyyRVGHmyTUl9A8GR5mGY2Jl0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef58a410-97b1-4d01-b5dd-08ddfc51f351
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2025 16:38:26.4260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wTE+3EPgZEeXFDDJjYf4zpwADImbinkAvW1XMm2iUpxmtjFe1h7rqXIsC8lFJD9nqP+5SDoeRF1QnRaZvchhpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7686
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_01,2025-09-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509250155
X-Authority-Analysis: v=2.4 cv=C5XpyRP+ c=1 sm=1 tr=0 ts=68d57007 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=N54-gffFAAAA:8 a=ZRBYi1cuWKsLokgr_pUA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12089
X-Proofpoint-GUID: Zv2EHtNJVJV_JUCOTgivaA9y8NnkZD24
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNiBTYWx0ZWRfX+8m/oBthhqqy
 fD4cKcEyRf6WVUgMIK/5nYjvGgUqWZrtDmX7OT+M8KjVMsEcog82Dptb7TadvJcDJ90VNA3+DJl
 A/nV5DKnOFZN+cub2Z9PxMz5LZCYpzkydSzBMTaXHfy2rD8GcXtlU6wzcmX0LsYEFBrVK8bHf88
 YHIKUpiy5St6bbuXO2OSZinRtF6MWbgOvhMaFjya/EdVXcPu7c5bFYkpM0xJ9Fs941OYkJZdaec
 vWTp9sBZqZRSISYW74t92XCYYJZ9qSjrtVNrTH147bpIsptevL/+Rm7pHheGMuVZKDQLTGZWGBS
 9H60kHryhbaGJ9eMCJFzMrXmdo+RNiX4X4cBRixPvusrHSXfquHXCXq8ReaV1VK1Iosfu7IaYWD
 skTwYV63GC/cZXZ7uTCj7wmcbz5Xmg==
X-Proofpoint-ORIG-GUID: Zv2EHtNJVJV_JUCOTgivaA9y8NnkZD24

On 24/09/2025 21:30, Bart Van Assche wrote:
> From: Hannes Reinecke<hare@suse.de>
> 
> Add helper functions to allow LLDDs to allocate and free internal commands.
> 
> Cc: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> [ bvanassche: changed the 'nowait' argument into a 'flags' argument /
>    added scsi_get_internal_cmd_hctx(). See also
>    https://lore.kernel.org/linux-scsi/20211125151048.103910-3-hare@suse.de/ ]
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
