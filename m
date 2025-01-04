Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B8A2F5E
	for <linux-scsi@vger.kernel.org>; Sat,  4 Jan 2025 03:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735962646; cv=fail; b=GH6MIXeLt6iA0TjFfSF/XchnwTLMkWrTbhHxu3Q/+2nZoagNxTVNLg1vUxE/zUnHib6LcsMEYJw1imr+lfTQL6s7HqLxPMi2d4f1Ko2MRL2jndsOGNx/zoDkGe4nre5GWQxaTFUC+LT1ULMDDpawmfgE/NxkGasDpiu5aHNdxws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735962646; c=relaxed/simple;
	bh=74CiTKKJDJLkr3FrTbprW4TOvVPu8Nq8NVbs4bDUEew=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UlpDs8mY+T4Hc9vi6hWuE4WOl34XrkG9De2oOK/xzGTMohl7h/cNmCqVnbhIKo0FsuxxGHxCLIHp15Sk5cY+P7j3MHL+YYNGP9iAoxhhfPHpbRK9n4/e/QO5gnYI59tRTSiMzpNUcp4YUDOdmVPfSB1SQ0wxbotu8RAg5kop0Lg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ftr3V9rS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Y6o/2XG6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ftr3V9rS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Y6o/2XG6"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5041uSk0027367;
	Sat, 4 Jan 2025 03:50:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=cHaaX3nFxeSBgnfh8mzOAJi50U4/009gIQH+fenjG3Y=; b=
	Ftr3V9rSG0qbPw6XaFkvKhWjhBmh3YbQw3830Jpr4RrvFqhAFF7l7iTSGbfo0TO9
	xI0si5BPjw9OvFgfsQ+ziPWacEGpRrXPsE2DcET2MgaiZ/5WTSkwP234SK4dLrJu
	/lFrYYn2zo857wsYo9ZIQIrkTXdgwfxubBUIvPlC1lJnMwZzgOHurM9p7mOWL334
	umIKykonfe6KYN8ftXt4xlbvknYsrK9TVI3gEQkSnf66yI6i4DgIBY88//KxJY+y
	VXWLLp9SIhWyxLuwqMY66DAmL1BIgV6dISyvpb1TE2B6T046OWHNC1UO3jR6bpzb
	z+9EsZUItgmBLT2To27MyQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xus289en-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 04 Jan 2025 03:50:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5041YDhW020040;
	Sat, 4 Jan 2025 03:50:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuebtfxa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 04 Jan 2025 03:50:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZnmL2J10EbxBd8muNgQLhjM131uMwqwIlhdIDFUcNzlDHkeQ0QUCM7THl5baidFIz4v+8LxAcYWZIQ/1Q2dCRKprQSG2riy1U6NMQjBZJEK5/z5GibZYQxSPep1PQs3BM4IqXWoaA9kpGgEg2iuM6jiiJvKS0pjjJvJqVHO2wNaP6Gb67nOre3zZFtU3ObhCNWL+0u6aZLBJl7gVaXoSzuJ1gPqEUTvcQxYax5LMg2h8WMntqKCoQlqQIMjXfeSDWLjNHDQLN9Sfjg8cL5kg0LdGumhX6qTUFL9F3lrmDgj52zy5dHciGO+hH55J0y/BJuJSbUVf7lQRFR5sYetl9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cHaaX3nFxeSBgnfh8mzOAJi50U4/009gIQH+fenjG3Y=;
 b=PrWL21aHs8ydSDHCzP974HyOHpYkhA21F/4yyPj6Cj8p1y/AvflmjfojYKICEWYOoCYsYtP2K/kjCK+rIhJzQe2FMqY2mziU3YhnDRdl5QwBm3DpS14zIjHSenVQfYMjZIimPHCFUTrMnqpmYm+fCs9IrlK8dVJAtshKqiQaU/x8cWu23X9g49l0iWu92Hws/o6MF7f1a9inYTzHDuFhHIjuOjLwbTbWNPY/ZVFCQXQ4ZoTwPXI0L182ZkJMxpP0WWp4w9RQAqSq1hYj6EqMyFwSPvbmZv9tnEq/OOM28MpBOM/GmnuHNqZ37Y+U/R9pT++DRXxm5pL9ZeAOt9di3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHaaX3nFxeSBgnfh8mzOAJi50U4/009gIQH+fenjG3Y=;
 b=Y6o/2XG6GOLrS4wtJMr89Q6GCgtjbUXZyUDqxupbgQws16PESImvEAADk8MLzKHvbWzMVVr3bEtgsjqeSdNxr8Xc0ef8jKsLHE/QTai5ML/Bl9V3yfhzzBljmGwCbNxNOBAhKYEqaaxWHUaun0yuKeFf7bRa/f1LnJ6eRLUwjYo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5177.namprd10.prod.outlook.com (2603:10b6:610:df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.14; Sat, 4 Jan
 2025 03:50:32 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8314.013; Sat, 4 Jan 2025
 03:50:32 +0000
Message-ID: <802d5417-0d13-4bf0-ac6d-8c816bda2c96@oracle.com>
Date: Fri, 3 Jan 2025 21:50:30 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug 219652] READ CAPACITY(16) not used on large USB-attached
 drive in recent kernels
To: bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org
References: <bug-219652-11613@https.bugzilla.kernel.org/>
 <bug-219652-11613-5LnvEcp66x@https.bugzilla.kernel.org/>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <bug-219652-11613-5LnvEcp66x@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0298.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::33) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5177:EE_
X-MS-Office365-Filtering-Correlation-Id: fec69408-85fb-48ce-a4a4-08dd2c72efde
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YjFld0FTeE5kWUxPcEQzWEdZYXJKYUwxejZwOU5WWkpXNWlLVW9LMG91WFJE?=
 =?utf-8?B?dXluNFlpYlk4aFBYWGpyU1hKZGpGK2dCa0F6VjBrTHZHTWtpTXE4bmNTZ0Rh?=
 =?utf-8?B?WFlmNGU0cnN5dTNobFQwaGMya0hDdFAwbDlZY2lPQkIzVVgxb3Byb3dvaHJU?=
 =?utf-8?B?RmxmSEl1aXpuY2R6WDlwcWprZWUvbGVUdzlqMXV1cGJUZXRQVDMrVFBoSUk5?=
 =?utf-8?B?ektONW1WclBpSkpEZlhtWlRqN2pPWWNJblh6LzU0OEpsOEU4a3owZTlkUmVw?=
 =?utf-8?B?UG5WNGpKMHF2c3BhcnltaHRla21kM2Y5N1VZS1BiUUZWd2RWSmFmM0hPeHFO?=
 =?utf-8?B?K2NtMUtic3ZoR3hyQVVNNEZHaXptaWpqSWYzb05XRVFvNDdUOGQweVZ6TTZZ?=
 =?utf-8?B?QlFGZUZyVlQyYUU2cWt2eHhJR1lZSEJxT1V2bEdOZ09kY0IxUlhrVFYzNDM5?=
 =?utf-8?B?TFU2UTlmWFJsSHE2Nzh6YVp6Y3ptWmdySWtFVUhxN29Ja2NjUCtEL2F6V2lw?=
 =?utf-8?B?VmN2Z1Q5b2FkSjgybGEwbnZBTVpTTXJmcG9Cc0pudmFZZFZoREdqdEhPb3Bn?=
 =?utf-8?B?QTZRNDBYUUhNQk1BamRlTEQ0anZNTjdSbjhZaFkzSG5HQjd0VW15SlAzN2Jm?=
 =?utf-8?B?dFhhNEE3TmtCV0w5V3J4UGcrTnpFZDN3MkFGSThMV2RaNG1vblJZQ0kzQ0tw?=
 =?utf-8?B?ZVZXY0pvWDljZC9sKy8zelluaEpMR3FoVUszR0JtbTlKdzFwc3NRTmt6bFBJ?=
 =?utf-8?B?UEZVRS9XMEtrdVJSVE1IVjk3TCtKYU55TVl6UER2MHhCM1FVOGNQcytaODUr?=
 =?utf-8?B?L3ZYSEpFNzRJamZKVEVKbHR5b3E1Q1ZpYUFqT3Q1aG5NM093c0Fjc0h3WWJs?=
 =?utf-8?B?Z3NyUURleWlVbE1SNi9oaHIzYy9kalF1VlJraDdTNmp5QmlGSjhpdEp6cUJr?=
 =?utf-8?B?YS9Wem1KT3Q1R09RUGg3c0I1TXI5djhxOEttUHFMWmRRWDZuT2dvc1d6SmFL?=
 =?utf-8?B?ZXZENnBZYnN3cXpudlBlSDZ3SEt0Z0JhUEtQT1FZdVZ5QzczeVA0eTNibDdV?=
 =?utf-8?B?azd0TTRpMmNkTGRSQTErOFZnQ0J5cGU1U1ViaVRWWExpaGNOdWhjK1JON0ZI?=
 =?utf-8?B?Y2Y1UFFsdk5ObkV1RWRNZWllSGltNUNJTTY1Y0VPU3c5RWdYek1WM3QvK3ZI?=
 =?utf-8?B?ZHZKczB0Zkc2WjJadys0OVhpNkxtUzAyckc0MDExRlA0YUpuNDBXUnJRUjF2?=
 =?utf-8?B?TWh0Mysza2RBcU1tQ0dEVjFpeDBRdVlFWE1aZU83d2dBbjFzbGdmUTFDTURM?=
 =?utf-8?B?WW51MEdIRlNSUC81RTR6aWJYY1o1YXoyU2Y3emFlSGd2WnloV2Zhb240VEZ1?=
 =?utf-8?B?SFhYZmxRRzNFbmplMXIrL3VDTEpKZHVhREJucmU1b1A2RFJUWDNTWmpNMjY2?=
 =?utf-8?B?N0NZVVpzK2RZTEdxb0c2MEJRSTNOMVdvci9ydG5zM2FmL1JqdkNheTVyY2RJ?=
 =?utf-8?B?VkQ4cTB6MUVjYjhlbXpGUkRwSWpXRmJoTWFDYy8ybDNNMXRrYmRqdWF3TGor?=
 =?utf-8?B?UUxsMmZMVTlmYnhmTjNCUlNrSTMweGR5dkhHdjFYMTNGd1IvT3h3UkVYV1U5?=
 =?utf-8?B?bGhTdjNYb2NvL0ZUUlIwbE16c0dhMXFQL0JUcFVXMXRhdFUwamNMeHU4RzY1?=
 =?utf-8?B?WHprQ3J3WE5GTHU1THNNRFFWZGRyYlUwL2ZlTGl0b3hNeXVkSVMvM3IrYWha?=
 =?utf-8?B?Yk14Rkp3Y1c5M1E2WGFRcm1CWUdmZklmRnptZVNTQzNPYi84YkxCQjhBVWpt?=
 =?utf-8?B?T2hBUFd0S2JmZ1FxR2hIRjgwWmc5RUdvTlo2eU16T2FhR2l2Q2QrOHdrV280?=
 =?utf-8?Q?Abubk4UigYz7b?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Qm93VE1ISi93VzRXZDN6MS9LN0JMUnBVdkJwS1dlcm1jWHRDM3BTRU4ycHQr?=
 =?utf-8?B?Y3hzb3ZVTTUzZTRJbG1yNUpZeDVFVXpwREZBcXdyMFNrejUxakt5SUc2TklU?=
 =?utf-8?B?YlJmTWtucWZIMGVFZHNTNm9lVFo1RDNuRHhBQWRVVDdZWE9CSkhkNi9pV3l4?=
 =?utf-8?B?aEdmQW1SUjNMK3cvWnFpNjZRWTQzVzgwSVJrc21aVE4rLzJNUkVtSnZVZmRk?=
 =?utf-8?B?OW0rWkx4UXowL2grZHo1N3VGWkFFM3crWTJyNTdRYkprbzBWaVhYT1JOYXVy?=
 =?utf-8?B?MVhuOTZJaHM2VEZYWWpDQXgyNFVaT08rRmZhWUduWDhpQWVISDFuZE5pbEpk?=
 =?utf-8?B?d29FMUdZd2VuZy9wUzZPZFQzbWdLamQ5SmpZeGpldGFlOFp4OE5QR2d5VjRh?=
 =?utf-8?B?SDZvZXRldk5nWTBpK3M3MDdsMWpwS0pDR041TzU2VVBHKzc0REp6Q3FUbTA5?=
 =?utf-8?B?cWd3elRYay9POWQvNFFmdWVYK0FRZFF0QnRxb3RaNHI3dHYvOTBsRXlkS3Ja?=
 =?utf-8?B?QXk1MlZXUXJsNEk5Y2lSUnBnVlo2VzBzdk5IRkRFQ040M0hTSlZYc004RWhj?=
 =?utf-8?B?eGcwa0JLcjZUTVlxdFVVeFY2VTNUMEZwRVR6R1ZSMGNzRHhCdStKUGtnMlRF?=
 =?utf-8?B?TW40aG42YkNKQkJnVy9WNHN3S2Jtait0RmFVMGdRR2JSelIvZ2RneFNRdlhu?=
 =?utf-8?B?QnI3V2l5bWNwcm00ODNGNzdncTRWRElTMm8yR0RoWWhEWWptK3RVdlVocEhL?=
 =?utf-8?B?NlB6ZTJZNENDOTlJWVBQdDhUYk8wTUlFNkdXWCtUbTE3MHBjYWxpdnVKcTF6?=
 =?utf-8?B?OVhrcGJuVWZIRnk2SGRCQmZsN3lXOU5Td21WU0xjazVNZEFtQ2t2VnlocjVG?=
 =?utf-8?B?WVdjV3F2ZzV2U3BaMkg2K2RJMkJXb1JabUdqaExXaVBsQ0NSRGVUVjdFU0Jr?=
 =?utf-8?B?L3IwbnRnYTlyb2FaUlhyZ2FGNHRIOERLa2hoNVpvd3paVXM0WWdXemhOWWRN?=
 =?utf-8?B?NWU5b3U2c2ZNOHQxbzZocnlneGlGNlNXK0JyNjFjU1gycDZOSEhYbU1XM1M1?=
 =?utf-8?B?K1lCa0N4aEFtVzVkVFJpNHVWdTYzYUZTTkliOTNRZ2ZaS3FJL3FZYnNQczBF?=
 =?utf-8?B?a0x1VE9GZ0pqMVZPTURQdzhkRWxtZXJtNExYNUc0R1BhdTUxcXltdDVtYnZY?=
 =?utf-8?B?Y3RqbmU3bHJLcUVmRHpHbGViVklsY2QvdHBjR3ViVEFDd0dZNUNXYm4wYVlV?=
 =?utf-8?B?NHBLbFM3aFg3OTFhaG1SaWRDdXZpb0FNV1hZQ1pVdTlhdU1rYkliRzhkSzdt?=
 =?utf-8?B?cHpGQ0RueGRaY2EvMkdxbFB4R1d4VUpzWWdlZENpajFGbkdKNDh6OENPWVl4?=
 =?utf-8?B?Vk5BTkNSWXFRRlVWYVIxOE5ZSW5hMWNsUmpBZVNhakNqeVFsem5YYVVXK1FW?=
 =?utf-8?B?V2lmSUl3ckZ2YVNFNHdJMnlNZlc1K0d5a3B6Z1V2QU5oNVBRS3FEQTVTR3NG?=
 =?utf-8?B?RVVzdGorMEc4N01hd0UxNVZCRGdOK2dwTUN3dlRONUhKSTduMW9Ha2I3blgz?=
 =?utf-8?B?dEtzY2tVUEZhcnp3VWUzbmlhTDB5ZlVNeDAzTExnVnk3OGRQbFMzZzJrQ2pF?=
 =?utf-8?B?dS9zZGVScGtYNTlPTXUzbzVDOFIxUHdtNms1cWZCajNneldRL2s5S0M5UzdM?=
 =?utf-8?B?TXRta3pORVZFZVRRQmlreE9Cd2czNG9NTXplaE5mVVRUYnZOL1pWa011eHdT?=
 =?utf-8?B?eEVrbUUxRitDaFlKRDErbHNtKzhZaXYrMnRNRTUyYW5rZlZySTdXYkFWUFV5?=
 =?utf-8?B?V0wwc3Q3R1JIUGZBUENYeHgvMnlHT2xsMDN2VGRYblFyY1dvUHg5OGM2clpn?=
 =?utf-8?B?cDlKSFVmN0ZvMkE2YUs0cWpHZ3hnWjFRdzZ0UnZCSFZKcStRbTZZMnFCbllB?=
 =?utf-8?B?Uy9pNkNaN3VHTmpzcjZRVjE1OHYyWjBDZHFVVEJWZmtFdUhPWnpOeVdvZWs2?=
 =?utf-8?B?VFRQaU1pL0pPYTVGQ3VDN2xKK1dWUUN4ZmducnhHSHB2WmlxUkg2OFdTUjhh?=
 =?utf-8?B?TzJQdGVWTWxBOGUwVGRkeXhEcXlzQnlkSWVNS2xJU1Vab0hqdWFzalpHbVJ1?=
 =?utf-8?B?eDJuOXMrS0xUOXVtUUdwSlNiWm9jTGxrNEZzRHVwTWVEUGhTVitCczNOdzVH?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1RLbOVh7P32GhAA6zZ1/Mru5LgIm4z1veZtv/Yu818gDmi10oIMTsR/FNxvwxGbb6HyLxUEDPWfd6EJQ1G9T+dJCQjgZRF17TuntgvEnnvqbCHuc29ZDD+mHVm6EAT7Y/CfQbwWL7zxnqDf3GF5WKv+NwAyLRlZOkEl9RraymPWUNf6qXjWDMqrjYjoBCR6NxIH5xEXp4k1SGCO3RMosXcrUkE2S28vijLMZ7iTZM1CrD7EU1X9JG9oYtBo3VAdoRuE7kZTP2T4YH2V1eLdEjKknhGfNvYyGBDobsDaBMh4+b/7+Ucws9cXvBjEgF2CO89Yn5dAQ/UQZe4DNpvMDhWRQntZOc/fxHcJoa40XNMImIWlPaawoppiyv4q05vVm8z61qM7SBcsSQiiwPJZEoq6wBloJ6MWvNEQ2M/Fp6iaabx1lJBSNCzbychEUHDB7esRIdrvzymE1PSxXSSg4ofzz7piflcHO+/CEWYk0Q1atYgCiOEDspE+HNSGP6UhuOaHaalVUs2AFBb2bINlM4W7Zs2QFSAo8Aih9TicFm2ZbswFJpI9c0LMahDHc03NlTjoFRE9W/Y4KJLg3fBvOwacq+CimgWZaak49LWzrVwE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fec69408-85fb-48ce-a4a4-08dd2c72efde
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2025 03:50:32.0662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W5FaT4oZCRxhTj4lq95qwaUvbtPPA7rCKqeZ+uB1bwHmw5jRZvCt8hd82PxkKwQHCCT2EuK1vkE9qw3VL7B0jC8hfJ7q4kYYV8E7KZh63PA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501040028
X-Proofpoint-ORIG-GUID: NkBp4vHljT_kQRJOpYniFwLezI4yx4df
X-Proofpoint-GUID: NkBp4vHljT_kQRJOpYniFwLezI4yx4df

On 1/2/25 9:30 PM, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=219652
> 
> --- Comment #10 from Alan Stern (stern@rowland.harvard.edu) ---
> Re comment #8: I would like to know the answers to the questions asked in
> comment #4 about the bad kernel:
> 
>    In sd_read_capacity(), does sd_try_rc16_first() return true?
> 
>    And why doesn't the "Very big device. Trying to use READ CAPACITY(16)" line,> along with the subsequent call to read_capacity_16(), get executed in the bad
> kernel?

I see it.

With the new code we think the command is failing. We then retry the command 3 times
like you described you saw in the trace. Then because on the 3rd retry we get
0xfffffffe instead of 0xffffffff, we don't hit the check below like I mentioned before:

                sector_size = read_capacity_10(sdkp, sdp, buffer);
                if (sector_size == -EOVERFLOW)
                        goto got_data;
                if (sector_size < 0)
                        return;
                if ((sizeof(sdkp->capacity) > 4) &&
                    (sdkp->capacity > 0xffffffffULL)) {
                        int old_sector_size = sector_size;
                        sd_printk(KERN_NOTICE, sdkp, "Very big device. "
                                        "Trying to use READ CAPACITY(16).\n");
                        sector_size = read_capacity_16(sdkp, sdp, lim, buffer);

With the old kernel, we saw the first try succeed. We then saw the 0xffffffff
and then tried read_capacity_16 above.

And the reason for the difference was that with the new code, I forgot to
add a check for if there was even an error. We ended up always retrying
3 times and that lead us to get the 0xfffffffe value on that last retry.

so we need:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index adee6f60c966..2dcf225c7017 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -210,6 +210,9 @@ static int scsi_check_passthrough(struct scsi_cmnd *scmd,
 	struct scsi_sense_hdr sshdr;
 	enum sam_status status;
 
+	if (!scmd->result)
+		return 0;
+
 	if (!failures)
 		return 0;
 
