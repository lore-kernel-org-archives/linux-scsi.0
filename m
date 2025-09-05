Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40C12417C2
	for <linux-scsi@vger.kernel.org>; Fri,  5 Sep 2025 15:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757084719; cv=fail; b=fgi5ZxV1Sdhogbq4f7EFj8PbSuFGOSNz/FH/G2YY75gSL66OWU+ERfX8i3yj0DlS2VeKdCIBdaTNIUaNnro5IGYDgtwV1wZSrpgzR86gKs9vwuguYStun8EmR9vXbmtT9e2OznKm65/cYBtDrUZAlCQuw+mjxirYewoY7Z+818M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757084719; c=relaxed/simple;
	bh=VQqS+znHT2e/5z9mxx9UsMYYV75J36/CC3XX5otul0s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S/DJSg6jzXiUeg6U5of6Eaq2H6lZ4zCkhHzEIxFMuYRFSv4QHOw8UY/tErBxP1fItGnAQKF15gbN1LJ8gA7nq4Le8L+cZOy5Ql5Q7i8U81/PGLf5/MmuCgRXRaCI3SGNUUjU9Ah1HwaRACPS+tPyfyDDzyHhkc4COlklxgbt5qA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J/MoZhLL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jzg9SYkT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J/MoZhLL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jzg9SYkT"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585F58d1013704;
	Fri, 5 Sep 2025 15:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Syz7FyfNO1vNl9VTTLquePz9CbRR5vhrmI/3uXrYWM0=; b=
	J/MoZhLLJYVMvo7k13ySLzvTg/y1sg3ARQHhCB3p2BLJGxAUxZ73wtuHfn1dRj5l
	IHzgbt0gfOhYtpvaLXO88BKQCweBEkTStswM8/eE9R7Fvsf+JTmqECYcbJ6cBa+l
	kZzBw7W0/pbVHG/0UrngNJDEGSRSic5BKRrASALvWFe/4UnXWHdbCZbSoaJQ0WQf
	HpWBKAns2bl1+D6IRGEPYIyU53eM0Nd9+wzgyvlATcU3Qy3fPud2JXmTFGl2sVWb
	zDuCCD5q/HeqRZhTVeZdpPTFiHorIqL/yQIcbgOYQsbT7uj7Us7+fYOF3J0G8IW8
	VUprSUJ7vDRN6g7D4UjIRA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49026dr00g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:05:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 585Dm9s2019643;
	Fri, 5 Sep 2025 15:05:07 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2082.outbound.protection.outlook.com [40.107.102.82])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrd052y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:05:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wEog9sqgw8WhcrPppNko5XRlMClKCLpYHaHhsWfhBaSc2rpxm7ZD07HAfOwTqrOYU8/A6nyoZHxHIDJ+MlIsITFjb7aofeQxUfvAKtfgDtD6iQu1dN0Ny5k8kLQ4HDesI5gF9SJf/ZmogdfkTL5/PyLMZNRHq97SCrvpHHYta+rRzL9P/BWjteA5/yz/uRx9A+24L+YF0QRHgyZoh04QKp6WJltAcjlUbEUCOV3Pcm6I43T5xu71Ph+2RT18ZhWCLu0/5Uca345M3P51tDaY5qgPBjNg2ayardhEIaxr1pFJ3P6dW6uec8aDsO2iJPjZm2n7UnJ9F68BWXIPsPMZQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Syz7FyfNO1vNl9VTTLquePz9CbRR5vhrmI/3uXrYWM0=;
 b=VybtmT4NAXL0gRaHGb5rKy9xljPdHzvi6c1JxrtJibAXkzd0GKcwNwrvFcGeghyXyNU29Szz3Cx3tBc72SHBl25ym6FC58vGVsQ2Rn4v/g5kybB3kuWlxPBvnRH2BBiherAH7kdKHHmkRR/0ZeG/l4F9BebZRTQwxNtmuak2WWl98scZQdXtA6h+OucCaUD06RotHWszEWFQMlDjqrLKf7viMd5aRwkooM+DrgdY+JN8QjrXEgVUofFzxbHw5QDbO7Li9rOt8dDmuVhuZPkChJposSpiG/552kNVrAYdxamHZycZIacbQAQzU6T3RNwrrChAEXJGrHLn1HHAUpTL2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Syz7FyfNO1vNl9VTTLquePz9CbRR5vhrmI/3uXrYWM0=;
 b=jzg9SYkTXFiiMiDIt915VmpKFdYrWszsoDxP2quyJPZKgVxFaAt5yGokoRCHS6wTiM2CEywsUL3871+v4bVAIn4jN/l/Lb9rYI5rR0mhIDT5a4HmZR3my1mnwRb/yr4QFiwnCOwLhAZJK9zojHZSqDf/azSB96ATue5p/1vpNV0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by CH0PR10MB7481.namprd10.prod.outlook.com (2603:10b6:610:192::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Fri, 5 Sep
 2025 15:05:03 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 15:05:02 +0000
Message-ID: <bdb2ac55-15f1-4b1d-b0d6-d34e432e8c2f@oracle.com>
Date: Fri, 5 Sep 2025 16:05:00 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/26] scsi: core: Add scsi_{get,put}_internal_cmd()
 helpers
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-6-bvanassche@acm.org>
 <b9ebed12-0e89-495d-8aa2-a615603cec4f@oracle.com>
 <ccf0f76f-1e9f-487d-9844-b8847565532d@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ccf0f76f-1e9f-487d-9844-b8847565532d@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO0P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|CH0PR10MB7481:EE_
X-MS-Office365-Filtering-Correlation-Id: 102f6941-bb1c-4918-b4b2-08ddec8d970f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1lXQy84emgzVHVoWGEvMmM5ZWdPREVjQkl0bGgwa0k1VXhNZ3lKa1pFakNX?=
 =?utf-8?B?L1dWNEZycmVHdnl6OTZmVXFlcHM1M1VZNWZFK3IzQkVxdGh2NXRQU3p0MU5U?=
 =?utf-8?B?b3lxZlQzU1FGZzFsRkU4aW1oTVA1N0VJVGVVQ1YwYnFMTUsvTGpKSWU1bzI4?=
 =?utf-8?B?dHdJbEQzYkhETHNacTdUS1JLNENOcUtuUzNUbTdsenpLK0QwQmcrTFdoUWlK?=
 =?utf-8?B?QWlJWmhuYVZtOFo3K1ZnMjNiQU5Lb0dJNkRNL1pVc2RJZnJiWlBVcldHYlNi?=
 =?utf-8?B?QWZRZVBzbi9TMzQ2NC9aNXgvdDdVdHhDVXBWWHltQlMzOFErY200YTI5TXRh?=
 =?utf-8?B?dHpmMVdhMzc0V2p6dHZNbDVoMjJydVVKL1U2cit1VWtDa2Y5NFlFcVhuaDJ2?=
 =?utf-8?B?QktOTXA2cmZranAxZ000TldMMXQvZUs1ekVGSkRYWk10RHhnNDVKZWpCRWtF?=
 =?utf-8?B?WkZjOHp0YkhUZG5QZFg5NTlpYWtsSFVvdDJEaW4xNE5JT1dPMXdKOVl5VE5l?=
 =?utf-8?B?aVhjQVBQSFdvV2pUeWFROUJXZm1uU1gyN2ViN0hFQlF6S28reGxOdURkNW9r?=
 =?utf-8?B?eHBBT3N6bjVIb1lPajZ0aEM2QmhRL1V4dU0xdHIzVDk1T0tpZnczOUZQM3Q3?=
 =?utf-8?B?RldER2EybmFaMTgvRWE5Qkcwbk5aQ0hsM1lHSXMyckhTRlBLQ3o3SHZRRHBH?=
 =?utf-8?B?SmlmUkpZQ0c5T2xQNU5qVTFSdnV3ODVldkJwRytUK0YweURSUDBmTzh2NTd0?=
 =?utf-8?B?SWRLRm05ZzBLV2NtRGYxRVhDcTVZWTZrVkV5c3BPY0FvUkFQdTB1ZTdXTFJh?=
 =?utf-8?B?aUhyT1VDNU1ZanltbDJQTE9xVVNSQUxFUGFZSXpYWTkxZTJxaXMyY205ZmEw?=
 =?utf-8?B?QXF6cy81cVcxSkFqVGJxTFh2ck95dll2bDlab0lNb21IYmZLdjFwcmJWV0dO?=
 =?utf-8?B?ZksyNWdKcnZ3MG12MzNGS3E5QkpsRE5yeDF2MFVrb2NLZHdvVVdKQU9QQzR2?=
 =?utf-8?B?dFR2WkkxbzhHd1c5YTIwYmxDdUYvVHUxNGxIZTdPcldRSWp6NE56eWlxQWZo?=
 =?utf-8?B?Q1l3dG5FYWlPaGJUbGdDcG05K3ZxVGZTeTBaL2pja2IvN09vd0JGOGVtWHhM?=
 =?utf-8?B?c3dIeHY2TDdscHNEc0RjalhMNVFvWW5zSlo0akVEbU11RE9Lc2lCcDQweHBs?=
 =?utf-8?B?NGk2b2JsWU5EVERPMmpjZHIzeXJBMUhjaHVpQjY5blRDRGRDZThiWVBUdDFs?=
 =?utf-8?B?Wk5xVm9BU2VHQnVaZjJUVHN0OWhXTmpxRC9wbDdFWnpmSit0blNOQ3B3NThl?=
 =?utf-8?B?ZXZVM1p0dmorVnluRjRGclFWeUhXZ3pOMEtja1dtbXF4RXFLN1gxbEVBMXps?=
 =?utf-8?B?SWF0cnYyMUJJWUpZT01DcmphWDg2NVcvWDlRamJOWE1CK2RwVDFpamRldi9H?=
 =?utf-8?B?dHF6ckJzNFlBNDhETFd6S2RiaHJXVjBQVC9wZGNJdjBwRWI0NEFDUHJKRlV2?=
 =?utf-8?B?SXVmYVdjSnVlaHpOQm5FK2pYZ3luOGcxVXFEa0VHVWxEUkUwOGtPcnNTQS9i?=
 =?utf-8?B?bFhpVC80cURNQm5iWFVsVG5PRGpaM241a3RWV2E1cERZaHpmUG95RFpGZEpI?=
 =?utf-8?B?ZzRIQjVkdkx3aGdQVHpsK3ZkK3AzT1N2YUZxSXBJZ2RHVzdTempRL3ZpTzBh?=
 =?utf-8?B?QVBiOTZtcElmZzFna0lQWWR6ckswb01nMXNqWWpkYy9TRkpOOVJyRnR1TDlL?=
 =?utf-8?B?MjAyaWh0WWxhLytrdDhDUXg5bHhsSkFYOVRaaTF1UnhnKzZBU29iaVhkTlF2?=
 =?utf-8?B?a1BzM3VaVUtEc05TcWJOakJDT0xibGF0UDZNQzk2WW45VmJMWWdienZGWGQ2?=
 =?utf-8?B?SklhOWM0emhobllZQU11TjRVTXJyWkx5Y1IwNnhHVkh0OVMvczlQZFY1Nk1x?=
 =?utf-8?Q?ZVEDcuS1e6g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGxUcnNzS1NCOUV5S0p6UVVIbFB6OWJoeGVzTG1yYlJVUHZjZzFMN0VBK1Ra?=
 =?utf-8?B?T3R4R0FnbFQrZ1NnVWd5b1pnWFJNaDIxbEd6OStRYXAzZEx6WnpjWHVHcUR4?=
 =?utf-8?B?Mk14K1ZvTDUyUVhwRVBGTjNSekVoWmdudy96aUJTbGZraVVNTmhYdkkzWkZa?=
 =?utf-8?B?bU40WENkSVR3a1Y5ejI3NkJ5RGlWQmtQek9QY2pvNG51R1JxWjFqRXNpT2dB?=
 =?utf-8?B?c1M3R0FjOW0yTzJ5bWJsa09aYXJ1cGRwQ3hVdjZXTExFN0dSYUVxK1lOYjFI?=
 =?utf-8?B?Sk5nNXd2amVJZkZvQzVESUYwNHF4aTFmVUhHbElvM2FjY3RCNXUzemh6eVJ1?=
 =?utf-8?B?cjZhaTNKcDQxa1QvYVhhZkVIQjNXL05hMkQ3UnlHUVFLUHcrejNWeFMxa0pv?=
 =?utf-8?B?SW9UWTF4N252QlB0RzMvMTZzUml1bWhFS2dxeWlva0NoNGJkYlcrMU5iK0Yz?=
 =?utf-8?B?aEtsVFBPQlFmRzFhQ1VxbWtqVFFrTzdOWjI5Y0tnMVVqV0JsNzVzUkhzZDdr?=
 =?utf-8?B?UnRjaWtwRzJDSDhTM2ZLcnM4MW4ydjVzdzA5WklnZjQ4NVkzZVJTTXpsbXRD?=
 =?utf-8?B?dzlETmtTTGU0MjJJRnp6NVdvT3NHQVpuNnI4Tzk2MWlERWlUSmRvN0x3OE10?=
 =?utf-8?B?NGZUQlZjMlVFZVJEYzJJeTFKZHY5aVI0dnplN1pLTjF4cHJRQk10bk1VUEY0?=
 =?utf-8?B?S1ROUHZuUW5mYjNKVEd1QndDQVdaME9PREV1clZCVXlBQzdVNWtnc1Yza3lk?=
 =?utf-8?B?cTNwQVlpZnQ1MWhadFFCcytCZ3g4bE9GRzJySzE4N0lzaWJXODNkSHJyME8z?=
 =?utf-8?B?dWV0MHFoU3ZrQWFZRXhSVXZ5UkJIem82ZVA4UU9vS0I3R3g1TmJMRW1VSnlE?=
 =?utf-8?B?Yyt2ZkttVnpxOVNmT0pma3FiQjdjN2M4RkNZNkYvcDJkeVcrSktnK1IvbjZW?=
 =?utf-8?B?a0k1dkU3VHFwblF3VGxGNkczZFpJVnRTOG1sTXFTaTZ2UnFPaGlvdEZTOC9t?=
 =?utf-8?B?QTlvSmRHd3dLT1dpV1NYVlpNdzlSSmF6VXdwcEY4QVZCS2d4c3NFb0F2SkFC?=
 =?utf-8?B?enpGVTY2VjJzUmlPcTVvcStUMlJYSG9rSThFejY5QVZXQ3h4UWZ6WEtibmdk?=
 =?utf-8?B?b0hyZ1pnRDNFNEh1N0ZRWXBGZHplWEl5cHhzWDlEckloaXdOSDVRWmRjOFB4?=
 =?utf-8?B?Z3pidGFPMWJIN0RacUl5MmV1emdMK0hvZi9CNER0WWh2eHA2YVZpWGo1VVlj?=
 =?utf-8?B?UWhyZjllcEVBNHlRUG8xUXRiek9WdDNmTi9HN1BzTlJPcGxlR3oyUHcxZUNx?=
 =?utf-8?B?Y002QXpZN0hjWG5kSTgra2t1NitwWHN1Rkh4bjRsb0hGUmx2TGlBOWgwMVYy?=
 =?utf-8?B?RlRIWUZxRFZvd1ZSUXRyQnZaMTFwWlBFUGMyY0JtNHdVNnNOeElReHQ3T2sr?=
 =?utf-8?B?SEpZRlZSZ3lIbjJkV2dCVVE2aXh1SUI3U0dXMU1LL0dWZWZ1UUg3SHo5b3dN?=
 =?utf-8?B?M0tUcXNYZUx0ajZZcUdMMXJ6aVJBbnZVa3pmM1paQzdSWXBmcXZCbHY1eEtq?=
 =?utf-8?B?S013NmxxcE10UVVYREYxK1ljQytxdzQrZnJPTmdmeUNzVVR1MmVSSUp4QlJ3?=
 =?utf-8?B?RDlDemJhVFJSV2hjb1JQWXhyM1ZoZHBOOFVtYWlyUXlRY0tKeTVLQTA3RWtp?=
 =?utf-8?B?Sy84Q3FTbGdUYi8yR00ya3A2NDFoTkJCQWozcVprSFVwVTlhMU1DOWN5TVJi?=
 =?utf-8?B?WWZZKzZSNVVwZ3M0WmZXRW9Eb2lrZFNOZWpMNjRSSnJWZ0tZejYwSExVOWYw?=
 =?utf-8?B?cXlFTlpQUnFqNFJhY1ljdytnNytmQ0YwY1JONDZLZTRPNjQ1L0gvOG1lMnY4?=
 =?utf-8?B?dmRIMU1Fcm1FQU41MUp5TUJqNCt5Q1kyNEJ6TzJXcWhWZERkVHR4V0JPNFli?=
 =?utf-8?B?Wmx1TFVnMWdaT0xhSmlCQTQrS2Zza1dkN003bWJ4TktPY0YrOFVQSE9Namwz?=
 =?utf-8?B?cDVwWFlPYldnd2Eyd3VEY0MxY1dCUytTRjZqTnV5REd5WXpLRzZ3Y3c5V0h4?=
 =?utf-8?B?TVZPSjVmZU5wSzgrT0VFQURWNW1UblhNY0VBQWdaRWh1WEdMVm1URWZvYW5Q?=
 =?utf-8?B?TnRDZnVCRjFFWGNuMHFRUUY4RitzUG8wcnZhL1ZDQmVPV2tkdDhYL2ptSWlT?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W7kL7xfZJ4i5ZvDp24hVy9AxQVxxlbFnY1XLZdHw7pQl3E95oSBXPFhs5SpkcMxjaxmfFylp4NPBYJogBS/sYV/n2Bs746Xhir+on72UHWos4b6MhtgMmHtnUq+GQqa1HZpXoZxWx8rDjmQq2V1sit+gBxt/1Tm599VxN0FxUKuQ8X+zx69Y313xZuEwlb/pVgibjzg2siKSyu10mmBmGVhku8IM1pA/VskdAPk5jpBoMbdKzcVvYBYBAVw0VX56xA0t9U6uuXDHTs9/zB71o3nJwNb0k2f4UIV0mHdWVxaD5GDuYIXiL432Xbzo2pk91MXrMRxfvT8RIwR1twQTP1XkPzn8yY55mc6lO+fuYTEJt/Z5FM1mY6av23jXpTBjtt+w1wQI0hR2lWRDBwA163+QvCYvTFkh0inB0Ni4aL0WtHV+ukkjFaE6pxXeh3wGMnTniDr9ZdWiejr1RwPAadd2FTCnUgtSfyKmw0JYnmgE2dHOuSRDytWIMeXJjW/syXOxaMV4fl7r83zsxp0nsE2qLTiDa6KPFp40U5Xefhd+2TS32AIG9quzUm0VEl1ZX//rMY0rAnnjJMmvYRGiR5E+giKiKCFTmTGE7AN9Mcc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 102f6941-bb1c-4918-b4b2-08ddec8d970f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 15:05:02.7945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X3B2/AS9SBSdt8evjE+4L0NXkoxx+9UxMiyNh2b+ysmoYqZANZp1k5tG26di8carmQM4Ou1wk/aVAjt/Aa8EzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050148
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDE0OCBTYWx0ZWRfXwnGXNaRCllWV
 p+neJgAEWAiIVSbSfyYQcOWzOP7r0+sgCTJdl82gbA9jF4OzmSkc+iGJVU3IRbUbmF+idReifKd
 oT29CE3Dik0FkWftz9/Uupfp5rE7Px9Vx/SboJl9IdqSd5N8wQkVbwLkc/XxEWpdOgW7vk/I9Os
 KGyWUW59JHWriU9RaHVtP0mdjsPTLpJgEtCcpRkl72mbehJ2c5FVlz4rzayCOj2v9ruNYqSTaX9
 8zP1Abw0gaGmP2EZwdYrkye8icccvUIo+P5qePtC2YgzYnxAqRVAysP+d1qFLPhWRvoEzl8HX5H
 shy38k9wVmQIkr2TNm0IwHVPuYeQW380R7Kfzuqt8h10H5KXVuFZ3fXasUjCLiEWLQOHICnLCFV
 KjFpmhXo
X-Proofpoint-GUID: F0d3CDAACzuOam8oM9pk621FJMsTCxCT
X-Authority-Analysis: v=2.4 cv=P+s6hjAu c=1 sm=1 tr=0 ts=68bafc23 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=3fpKwyXWg6cfsEBRwnwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: F0d3CDAACzuOam8oM9pk621FJMsTCxCT

On 04/09/2025 20:41, Bart Van Assche wrote:
> On 9/4/25 2:56 AM, John Garry wrote:
>> On 27/08/2025 01:06, Bart Van Assche wrote:
>>> Add helper functions to allow LLDDs to allocate and free internal 
>>> commands.
>>
>> did you consider reusing/refactoring scsi_execute_cmd() here? I'm just 
>> wondering if it is possible.
> 
> That should be possible by adding more members into struct
> scsi_exec_args. However, I'm not sure this will result in a code
> reduction. As one can see in the last patch in this series, the amount
> of code shared between scsi_execute_cmd() and ufshcd_issue_dev_cmd() is
> minimal:
> 
>      rq->timeout = timeout;
>      blk_execute_rq(rq, true);

I think that it's a more a case of we would rather not send 
half-initialized requests or scsi commands though the block layer and 
scsi-midlayer. scsi_execute_cmd() looks to set all fields up 
appropriately, and not just the ones which we are interested in.

Thanks,
John
