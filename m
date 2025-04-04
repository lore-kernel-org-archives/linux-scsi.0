Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB1D7485
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2025 10:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743763777; cv=fail; b=bYp8V84a75uQJVJzWHqacDOmRagD8JP7yjHr6uc2p+mLuQt3G/uhCV661Jq7y18spnVra/18wmibw2MUcum9W778Uk9409/+6802X4kjWBh1DvLhdb/y0PPWnrSJcoX8Nzyg5w+wjAOtpaQ+xZWoXNcWQ3K3c/V0McRwd7ACCaQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743763777; c=relaxed/simple;
	bh=3UjCjIBTMks3QUjeeFuOW8GO5B7GYbdqAaTabBnZ1HI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FiOOJQVyeQYVSMi4c8qiQzKei/4KI9Bcd1I605YyWYc7Nm2ir4NQGf/OVfBQXOuFILZD/RNb7aF1ofOzhlDEm25Dqjjtwkmkbw+2wlCpWH9hBQSmsvo1yRH3vREwb4/d7j9YRmx9QmdHVCBnZMLjJPstr3eYalXr/eYdpPEjs4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hFbBua/X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aGUDu/Gd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hFbBua/X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aGUDu/Gd"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5348N53A021101;
	Fri, 4 Apr 2025 10:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=81AKqmasYxElPooqzsADy5oht/Zhl0a/cTQTMZpGfcw=; b=
	hFbBua/XKeUHqrfrJ7QAh91QysV413Pk9wYn8a/Zfy3jDHTPkbEAU7vMSvUKR2pr
	EPzToorTNq+qiPLzz8YxsbZNs4WtFvX5tQY53/IY/2QN+VXnoDxKS5zKEHRX25So
	IF8brEaL0Xjc7MZ4JpMKmMBB+lvGPQfQWcHwmlIuVTke1rNfCMBGPOYi9GTrdPCZ
	65sjX4CreqguUyl+EQL4k50npC/TsQcQLKDuPXUGBA1dUxnlvMe6sVJ3wkYJ5cG9
	SUTgT+viZ7z0j8dhI6zyiOIfhQS45I5wz5acpNUnPX+qNnkueI6Q1YVvS9U8B6R0
	cLuG84TkBYjhEnCefeKtJQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7f0ppx0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 10:49:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 534Al4ZS036126;
	Fri, 4 Apr 2025 10:49:15 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45t2ntvyd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 10:49:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mrzg0jMIorWtdI2hcB0owcrAN45ZokCC8jbkSWMqs7FjH0S4UepcAKf1pjitlEPnDkTEGYrHWVrDmSm0WgQJMmB0LdpginSKM3lUvKhy/QlGlVkOe49CJrBdOKEsKyjj0AM7VayUpt0SWho+ORJzzfgMn5ye8rQbe5wG4n75Q5cBTkkX0RrDngNfO1KNiYxbYgsrycOgyeQgKo0Vio/2A9xzwnjcWjrqrTELYcClw4tHS97kcb3KcZtydurjlmpn1/nNMgmZA8ap6P7D9jHonwGZzWJhk+MVz3Kf6Pef5VhlfK8ciWZ9xdn3ffzF/Bs0Kkd84dnRmYyoinM+7QNHIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81AKqmasYxElPooqzsADy5oht/Zhl0a/cTQTMZpGfcw=;
 b=bBW9hpflebPUg7mexe/gTQhIvBRz6WO+9hV4yem6kUIxcElLhrKqJ2iJiewEQccA7IxFr4ihRVAvYNB8kgq5QJM6gU31Q3FyvqSP/rBWzWlM+0fM8gxsMOllqn46LqhWJ4OW2RWbTXHkQ+5DIDp+eZZMzTbmaelBebXD+m7t5z9IEGiG2Q5ptABHBZjBPVwQvYBdOVhhq3oiOkya8QLNxFqbIKDR0+o/PaCeBYcNkCgdf7qDIVsOGGQhB2i3jl56f7X3B2HGbpDh5k/Q4QABybN/ZxHRzcqyg5BIDmAe53FZsenT2JiLjA6lbBfYsnpPPALdoKCpw/GSKUUNYlU1yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81AKqmasYxElPooqzsADy5oht/Zhl0a/cTQTMZpGfcw=;
 b=aGUDu/GdOYR/JJObwRQITD74PEyWnfmusujN8P/u9QordYqRoGQhkAA5UI2LTPRkUs5Yp41fVM9GuNu7bLXXquIgZU4Bu5t5X6fVSe92wX6aYAE5eMS6KFMaexvPufF6NpI8WGctaRh8DgMjZcTpc5NBDXYnasOEzA1aFM0eZWE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7280.namprd10.prod.outlook.com (2603:10b6:8:e2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8583.41; Fri, 4 Apr 2025 10:49:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8583.038; Fri, 4 Apr 2025
 10:49:13 +0000
Message-ID: <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
Date: Fri, 4 Apr 2025 11:49:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250403211937.2225615-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0172.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7280:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b889dfd-f072-49aa-885f-08dd73665645
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkw4anBuSnBBK0ZHa0F1U1FZTVZaTFFDV0hsZTRCbjlMbE1VQm44Lzh0bHhn?=
 =?utf-8?B?emd3c01pQklkKzdrbCs4aFFwNGUybXF3bDFhckRiZTE1L3hYckpIRVJNWk1z?=
 =?utf-8?B?MFJFK3BMTUdOSGM4MDNLM21jQkJiQkcvdGZDWDhPaEJOd1pDelBCbGFMTmtQ?=
 =?utf-8?B?UXR0WTgzN0xabng1ck55Rlc5eGZnazdzbkpXRDIzaXc2bVZkQU5uYUlKRkUw?=
 =?utf-8?B?WkswSjhYbEdJQXdyOWZZY0NCVTdqOHdsWjFmK1VnVHBibjZQZGJRT3FaN21a?=
 =?utf-8?B?WitZMnBFL1NhSGZ0aHNPYUJpZVVRbUtaNDJCTWhSTkNudlg3WmZJUmlOWE1I?=
 =?utf-8?B?b3A1RXlzU0hIVmJETVkvbUI5enVXVk96N0hXUytuTktHbjN6Q2ViTEJ4Vzg2?=
 =?utf-8?B?MVRjditsVEVDZWpwQW1qODVja0RZcitiZ1dpMjloZ3ZnaXVxK3F4NEl2RE9B?=
 =?utf-8?B?eDF4ZzE5TkJvTDZHSG5NNWRyUC83M2JNckJmR0E3akNINXFONnIzNm1LQW9n?=
 =?utf-8?B?clQ4TEE4dHB2aFhzczNGOHYyY1ZjMlNlOHFXc2ltd1plaWxpcEJJcC9aMEVB?=
 =?utf-8?B?TkMzRmVMU0htWitORkRpclBpRDVTY25wZ3VuWk9MY21zVGNQT0g2bE43ZGZo?=
 =?utf-8?B?OFJrOE8zQTU1L3VMYjhvTlZiOVV0RzNHclJXaE5NdjZMTy96WXB0OFhQV2wr?=
 =?utf-8?B?MG9UWHBzM3JzQUFTcTA0M1VBeVJmOVZhb0RvR1I2c2NXSVIrSkU2eFMvZ2Jt?=
 =?utf-8?B?L1hBOHc3VkFDNnV0VTRpUnRFRDRBZ01hSWZCcXRIZ1F2czFoNkJqcVorR2Jm?=
 =?utf-8?B?Yk5wUDhHT1FiTzA3MlhQNWtZNGhOLzhzbVRBaWNlYnlhbHFJZE9ycVZTRVZr?=
 =?utf-8?B?U09hZ1BGYmNIV0p4ZGh5ektmaHUvelRWWGJtNnNOQnI1NXZxb0hXejJkc1VD?=
 =?utf-8?B?MkNpNnpLZ3hzWE05Tll0S1FDZnJzcjBuNXBRYy9iSDhyd2RVMWFvTERSbXFK?=
 =?utf-8?B?dUdkN0xWWjZFU1Z4aDNyalBhanR0cm0vVFNKUm5xaDRkemltME1YZVd4emI1?=
 =?utf-8?B?V1o2MjFvS0JOVStyaHZjenoyNXhtWnpCT2c5Umo1SzJSOFhEa2cwS245U0xB?=
 =?utf-8?B?d2QxdGN1TXdzcVdzMFFyUm5pVmY3ak1Xb1NxTTVsVy9VdXFJdW9iY1h4V0JW?=
 =?utf-8?B?RXNpVmF6UkZQbnIwU2tRdSs5cVJpb0RnRUZSUFRyWkVGUVdvbVZtSjMvNGJo?=
 =?utf-8?B?QkdLbEI3Zkg5L1Mxbm12b0RqejVzVENneEdrWWhObkl6bGRtZ0ZyZkUvN0tY?=
 =?utf-8?B?T2xBWXlmM0RySGQ3aFdQV3lHSjlFWUphZjk1YkRSQ1BmMEZUSmVBTW5LdjFa?=
 =?utf-8?B?dUdlbzZDOHJYcTBTYzM3R3NtTDQ0dFIwWTl6Z0I5K1ZNNXNKZG5Wa1F1M0Fv?=
 =?utf-8?B?VHB5TEhpL1JRcnlMc2RWSkpvZ0c5TnhLdWlHNjRtNUVFZEQ0Zk1NSk9JWHln?=
 =?utf-8?B?QllVZE9IZ1NRKys3alBHaFJ1SVhtcFowaUZrQTE4bmN3eEo1anVpazc4L05K?=
 =?utf-8?B?YXg4Uy9EdHRXTHppMnZnenhpRDBmVTRaeG0yTlN6MUYvc08vZWY2T2xZd21q?=
 =?utf-8?B?Qis0WkJ1S2VYR0k1Tm1TUnVkMjMzUmZNQWlvejVSNzJiSll4amJnKzJVajRw?=
 =?utf-8?B?SCt4bGdJSHlxTE0rMjhNQ3JacERVUWw0a3pNM2w0NnF2K2JVK3dhS0dNd0tX?=
 =?utf-8?B?dHlVMEVoenNXNTQrZU5Gb0srZE1FQkZSTVY2NCszVStIeU1pZXlrUXdKNHlM?=
 =?utf-8?B?K0NEV1VLNEZYZjhzTWx4OGdES0RBQUxjalhlRFZzZFBicG00TFU1T21xanBx?=
 =?utf-8?Q?vQtNlLq7tPNTJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R0FJc2RISHkwZmdSVW9na1B2bGZYODVZQ2FyNEg2TEV1R2l3a0tHUng0UG9Q?=
 =?utf-8?B?L2JFRnc5dm05TlI2YjJIQ3lrMUQ2U2IxRmY0bXN6SzdlWi85Q3VqQThJK1pa?=
 =?utf-8?B?eDgyUFZ4YTlvZlQ5U3JvMUR3YWh6VVN2cGU3N3ZGSzJpdTJaeUE3NFcyc1R5?=
 =?utf-8?B?SHl2UjluOWpNWVZoRTJjOHdqeG52ellnRVhkU0hLTXB0ZG85UWJ4TlVLU1Zy?=
 =?utf-8?B?SmdpcVJ6Z01LdGZMU0hjYXhWNWNLZ3NRdXM2cFFVSE9lMTlxYkVtRTlNZHl4?=
 =?utf-8?B?emZHMjBaWjlPN0d5VEZOZ0VFeW9TM1hTTnVpNkFaV05xUU5FV1dIcTd1a1BL?=
 =?utf-8?B?WDJreEdrN1duTTNVNS9yZmhnYTU2RWdYR0JJK0c0YlF5eC9ESElyemFvaU5Y?=
 =?utf-8?B?bXVJbU5YWHRZQWR2ZDJsOStpZHduNVJlQnVEYlUyRUxoZUtJcUNFQVRubm5q?=
 =?utf-8?B?VkVKdjEvcEZ6dW9tYUNaVXVnUjJtalozNUhsbEtBa29TRVl6dDdDb3BmeHFu?=
 =?utf-8?B?Qi94L0dsRWEyODl5NHlsNFVmSmN4c2NRRk1UM0JjUXAxTTZUbDhKVFRZZm96?=
 =?utf-8?B?a2o4ZDNqa2Nla3NqeTV3OHc4MFZQZlVFTkY0TFNadTlPSHU0NFNkSjB1SWFC?=
 =?utf-8?B?NFNCV2JrTXpqYkJWMmYyUllkYXA1eXR5Y2pha0RMYzJmVEl4R1drVkI3aGYv?=
 =?utf-8?B?cTUxeWZ3aTh5NkNmWWtveEwydEpxc2RJY1R1UjZPODUwVFlEMlVIa29kNW1V?=
 =?utf-8?B?WEhTT1M3V3pFblVINTlaYzg3ZHlZckJlOFVGc0tOa3dLWHF5SUU2TXhMWnMx?=
 =?utf-8?B?WWtlU1IxWUgzSWtIS1MvR3U3TklrOFF0a2o5NXp5YmE1NkRlZ3hkZitKZXlC?=
 =?utf-8?B?REtaN25XVy9OQzBhYjVBK095V2tYa1g5U0x1N3o4cFZaR0s3SXVEMk1kRFpl?=
 =?utf-8?B?ZlFzUG5Ed05SRVBNellkL3JGUjFtN0NZVHZEZCtqMDBmcmpSa2U5cXl3RWhn?=
 =?utf-8?B?QlpEamtvcVJaNHFINGMwKzBnVnNraEVZK0tuMnBEdkhETDVjSnBvRHBheElJ?=
 =?utf-8?B?Rk5hb3FTbUFoSXJ3T1N4N0ZlTHhWV0Q2Mk95TzJGeEg5QWtCWGVzRmY3UWcy?=
 =?utf-8?B?SlFGcVlETG5uYmZMRklPK1ZOdCtsbENVdFdTQjNIZVQzMmtPNG9LUkFCVXlQ?=
 =?utf-8?B?dGhXQ2RhZjBLSFBJdzBTcmpqcTUxcjJJckFNTTlMaVVMamhuYmpqSWpzd2FR?=
 =?utf-8?B?VVZEaW9jVFl2elZXOElXeEVRTkVMRkthT3ozK1drMkVCOUFPazB4MC8zeWQy?=
 =?utf-8?B?WmUzU3Fqc0FOdjM4TWRTNEVidTBFc0loL0xSaUlBcEduNVZhQUFvNWZ4UU11?=
 =?utf-8?B?dGUxN0w5MjdSeDFIYjdQV051cit4czQ0ZzZPSHc4T3VTa3BPU3FlbnJGOTln?=
 =?utf-8?B?NmVCWjdaVWI4S3dWY2Nzbzh5elVGOFlMN0JrMGFFTWtFa1UrOVBwcE12UDRL?=
 =?utf-8?B?aUZoaTIrb09aRXlydnFEWmVPRmNuNTExVXFKRStSM3hFK3ZFbGppd2dDNzc0?=
 =?utf-8?B?OGZOUFpZYVhzVUN5c2NnQnF3R2RsVi9nb3k2NDRuSE8xSjJCN24zTCticnBW?=
 =?utf-8?B?RmV2ZytCSUQ0eUd0ajBaZk9lMHVVTjNMa0wxZ2VicjNoYmZGMWtudmRWWk15?=
 =?utf-8?B?NE9kci9LaGZ3UFAwdUZTTGJZbG5GMFY1M09yQzE4UlpKeGUrYys5eHRlZ0pL?=
 =?utf-8?B?ci94RWpsVHBiLytvOEtZQzJwUXpJNllrRktZdTBlVkxLaitpNy8rTkh3RHpy?=
 =?utf-8?B?NnRod0NPdlBDMFNKME5zNktkaFYwWnM3WW9aTjVRSnU3NENBZDc2cWd1cjhX?=
 =?utf-8?B?Y0treXA3VDR4bUc1QlIyNTUrcEtnTHJYZ2lWbkFuVG9jalV3ZTZXY2F4UTNI?=
 =?utf-8?B?WlFYTk90aWUzSzF5SDhQRm01UUJXZzVZQzB3UUtOUHpiWnFjM0dhZnFkM3ZN?=
 =?utf-8?B?c0tJYWpZdWNlTFdJaDVUejBUMEwyRStSTE44QXMvVGk4Y3JWV0VZOWpnVEh5?=
 =?utf-8?B?a0xhUWVrRkxneXFHVVZoWG5PMUJXZGdxVVdOQmJLbm9UckE5WjZlcUJwRVNt?=
 =?utf-8?B?Uk5XNFdiS3FCYk5TcVR0T2VhNFlLN2sxVFJObEFBNWJIeHlkVGVzV3p6UnJX?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7PzarrypguqM8o8GqzAnsI/+GDA1Ycgoyn2mxNr3zm4YGSQ5dF+6Rb9C8Xdz4XxrEgMMghaxTQA7eh0H4wGD38eXOnaJD65l62554rR80S1IaDinEK9gAS4svFe9hXcB+EkWAU2a63a4fF2hfYAtpBY+Jphy6fEXIGSaEUHWd8aFV850KpPDQv/JwaNRGTCFrBK8KX05J7zFySR8Ck5UFrGKb0fq0/LH0G2JT7TKxXc/yaOV29Y/qkuZzUSMG0rSOGv989hEtomDUMu8wwccl4ZVLSG/Q+bH4yQ9l1ss1j7jnO4V0i200alSmIDX1tnWdtA7qB8BmXnq/bXbI0EqPQ/x9k5x2rI2qnA69nTHws1/Dd4oaLSaWjtqQTaQJCgOH+dRVbSreQLF8wXwEB0Bc0A6fv1wfDNtK7n8pZs8tW5p1ClK2mfo8OsT4zRc8brqXMIqy7iMpmoCi9A+8IskWs8ivw4X22nHzRhJL4s1QPmguGyijKULrTGMjz5BMwiqyIQ0p80uYbXAo6VZcxCZahj3gnL2pCIUS74jztSDXDLoI8P18OIpFq2CRlYsIMvfp1PqxeWFcuxmxRXnW0LxVucpM5leak9XQ3K0c/vkLuM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b889dfd-f072-49aa-885f-08dd73665645
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 10:49:12.9945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hfslby0lYtIqQSsgmRMRbw/ucYPbO5/vJ+XIwMECRuGP9rK16ypGVBHlGaQEROnQ7jx7BgAsPdyubet3gWgslw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7280
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_04,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504040074
X-Proofpoint-ORIG-GUID: DhteqmYTPC9chDeGmUFfvbRIn2vehD9u
X-Proofpoint-GUID: DhteqmYTPC9chDeGmUFfvbRIn2vehD9u

On 03/04/2025 22:17, Bart Van Assche wrote:
> From: Hannes Reinecke<hare@suse.de>
> 
> Quite some drivers are using management commands internally. These commands
> typically use the same tag pool as regular SCSI commands. Tags for these
> management commands are set aside before allocating the block-mq tag bitmap
> for regular SCSI commands. The block layer already supports this via the
> reserved tag mechanism. Add a new field 'nr_reserved_cmds' to the SCSI host
> template to instruct the block layer to set aside a tag space for these
> management commands by using reserved tags. Exclude reserved commands from
> .can_queue because .can_queue is visible in sysfs.
> 
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> [ bvanassche: modified patch description ]
> Cc: John Garry<john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

How is this related to the rest of the series?

To allocate a reserved-tag request we need to use BLK_MQ_REQ_RESERVED, 
right? I don't see that used...
