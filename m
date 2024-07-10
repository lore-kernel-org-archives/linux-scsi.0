Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB581422CF
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 22:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720650072; cv=fail; b=bt25AuaAsTD4BFmAce0smS5EpnT/+VF8ks1hLpkt8/+etyRfTF+dP7jfkRlj6TDp4Aai2sn48+TDx3s9g+JQO+ygasGcYdBHuFe/S9cFDBwSEvlS+MSM5sgrmiM3QcGTp87x9QCzhRtcRXxwT2EvWMxbx0fPQG+bxRWugPiVE6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720650072; c=relaxed/simple;
	bh=2t0CVn/coKDLSwUMZFl4dd0bzBqThziQ6VGIUZvpzW8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iWHBGeTUjsgk/IowBt3uANqR+Bkcj9ReaGOsTiafKgD5i7CYTiRNhMvR6uV3VjnbZHBYdNlexq2t5kGhg4ziW2kjxuA6a1MKBf2HVJNttXF85/BoU8xsv76pl31Pztz6ujLJoPo4GpGDx8yBbOTw6ZGy7ZSxn9hiYcVM8gTR0t8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aavjPNaG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LMLeIyPE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aavjPNaG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LMLeIyPE"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AG4RHj012011;
	Wed, 10 Jul 2024 22:21:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=x7jEIIbdrMipIMJ9F+5wgvCiWwRt+9PM5fpOXs0SfDo=; b=
	aavjPNaGwH5fk/mr1ReDTxKU/1EpHZv0cLG9fO6xqxFvoQTVKDd/qV2CghUNb+8I
	SUMz1j3J0HZiMeg2HhIGkGp93KN6Iv3JvkAZkRexdmcodBjCgSA1uekY0Cv0/eaq
	pn8iRk/QQHWgVB5VIzyFskGO593GhbB8842NFh3YirAtiaLdXwpDxZ+oT5BxNh6u
	zxG30YMwVvHURoFX4SIeq+p0XlTil0T7rov++mfXEyVU1qfCpp1qSm3EhvYucxgy
	j2LeOvRMdT4oYysOQfd+lYB/Q7wS28f8iUj2y4LUDG6TRWR+1yISrcT5JQD50SHM
	p0jd9O2QKFxxDpzmVC+Itg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wkcgaxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 22:21:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AKSYmB010787;
	Wed, 10 Jul 2024 22:21:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vv4ye2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 22:21:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0EFq0yXu4Fae10EIyStvYoqQZazkZpmIAzcJ/32e1t3s4FtF4tUzNsYYpK4UxETUouVxxnNkFlPF7Cow+H3Y9v5vQjre3qLoCIoXWYQrkvXtBtdNQB+y5vVhlF7CFIgpIYi3ILvBLYRpHgAkYrKxXrKx2Zk9n4Cvc4bG1Ds/ghULIOTO1WhUIS78XHJdgiiJJcZRmnsntBnX+c2VsW01FyYOpyRgTrIPiishhCSm9KmJ6e8lej9y1oZxQbyFKf6Rmv8cKgayoFjWr9+vikSA7DHxXwyYQvlJQhXJmxf/CFDuhVCOVEfoalSlXAt7j+nqff1mLRM4OnBvEZY+qiryw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x7jEIIbdrMipIMJ9F+5wgvCiWwRt+9PM5fpOXs0SfDo=;
 b=KoQsngYHy8kceVInFDYxULHBT+7K8isR1ujKNe3g1ou0MjHurCVHD6EVXFzme+jqUifrvrvMs5KJEt6wV+142dbmB2fEaTbxB4bm+XrvWL97c5YC3Xll1mkfdVi8gPrEkarwIfahA1yZLByTpaDQwzVNAr3bbqs79um8BC8e32uGhxP+dOlM6No8NcSBcrOV0S/kAPAipVXp3tyXD2UBdHJMZehu4UbU1Vkn1Z8Z+EDh1yweTsw3WFK384ApxAx8Eun5Su0NJ3b0tplZ5hs+VLnB0DBQlm4CfmL8Uual+sYEkVDA9MmR8LLe4zDNdNoycCspiWeulFR7GGEXOdPxbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x7jEIIbdrMipIMJ9F+5wgvCiWwRt+9PM5fpOXs0SfDo=;
 b=LMLeIyPE3d6t9Gvr57Qg5xjwM0oW1Kd8IKce9aTUc/jN+DsUpANIswXeGGbs8byxcj9qzwcXPik8pJ9e0myF+icF8xhgx4wlgPT6Eo81qS+kt4TlPeH5utkYvxbGX72cDWU3kVI7xZMTU61bZYtmK8qOlKkGzeJ8ygrAKykck24=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by DS7PR10MB7299.namprd10.prod.outlook.com (2603:10b6:8:ea::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.36; Wed, 10 Jul 2024 22:21:03 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 22:21:03 +0000
Message-ID: <cc8464e7-8e1d-42be-ba60-3baf66682f1b@oracle.com>
Date: Wed, 10 Jul 2024 15:20:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/11] qla2xxx: Update version to 10.02.09.300-k
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20240710171057.35066-1-njavali@marvell.com>
 <20240710171057.35066-12-njavali@marvell.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240710171057.35066-12-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0293.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:38f::11) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|DS7PR10MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: f783f42b-aa16-429d-7ea3-08dca12e9575
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?eVFXWGVPNHh1TXBoMUhQRlptWVd1RFJYd0swaVZ0MThta1FkbUYveHE0K2hM?=
 =?utf-8?B?OVA5UjJmUG93M0hZU3Jick8rWUkxV1RtQjMzNkhIUjNiU0NZa1pHQ2RLSXEy?=
 =?utf-8?B?ZzBMOERyZXd0SFcxUFZFTHhCMjJJMVZ3d2huN2ZkdzRUazdtVjR6d29xdlg1?=
 =?utf-8?B?K2pXWCtYQThHZEJsUHRBWjVQdXZZbnN6NENPWVZQYWFQdFkxSEZ6Wm5VMFBk?=
 =?utf-8?B?QndxOXN5eCthY3gvcmtIdUxVQlQ0M0hZWVNjR3pwcW11c0xVRmpYYXdSaDg2?=
 =?utf-8?B?YjlBKzZSTzFVRHJqVHJMYkQzZ0FYZEZ2SksxbkRKTnNKYnZObG9vSXVDWGNj?=
 =?utf-8?B?N2szbTNGTDhuZWZvYWwyN1BiMFM1V2dDc2w0WGMxMlZJT0UxZVJIWHVReVZ4?=
 =?utf-8?B?TUp0YlF1aGFKRjBsVmlBUCtYSVN6THNJMGJ4MlBHTjM1OTl0VWdnOVdUSzNt?=
 =?utf-8?B?TkNFMnpvckdTM0ZzT1FNeGo4K2Z4VDVpV1NFc2twMytVYi9tWGJ6dWNVMDJx?=
 =?utf-8?B?RzVENFJLTmEvYVo1LzhOQ0NoeWNSNFUvcDRIcHV4ZzVKUnBtVDZmRGR1UUVm?=
 =?utf-8?B?Qm4zeUVpY05XYnBsSjlobTN0NEJSQVNGZithbHl3RCthRVIwNXZ0NmRnbXRG?=
 =?utf-8?B?YjVYNHFnWG1kOHgxZWZVTGlsS3N3cjJKQUkyL0g0KzZkbHU5eUxyenF1dEtq?=
 =?utf-8?B?SlpraWJ4M1JJbEtYMVk3b05FR2NUdzNnMlpOeEJXV0kxVW5ybTZocEdRamNB?=
 =?utf-8?B?M0xabmtwWWduamR1a3Uybld4Vi9NNytuUnJyd1VpZ3IvVmh3OTRWdVNzU055?=
 =?utf-8?B?V0RJaG81MHRLWlNJbUhxU0xmWWdpbVFhNUxJS0d4UVBsbHkxS3dFMXlqR2py?=
 =?utf-8?B?T1ZpaytrOWJpL2lNSnhwcGwwZ2I0dkgvZktweEFpTXVrbjlPTHNod21mUFkw?=
 =?utf-8?B?TDQ5eG1GRE9qbGVtWlcrbTVSSkFnVm9DOFIvU2swbHZQazBuSFBlQUp2U1lh?=
 =?utf-8?B?ejBzNi8vaGlmd1dyTHRXc0x5Ly85MCtrZ1k4WGFCR0hydkRkZ3hUWU9TdXFl?=
 =?utf-8?B?OE9RZndnU05WK2dVcmNhN0xES0dtSjJzZ3JkNlBtNzFGbklhTy93bStsWEhr?=
 =?utf-8?B?OEl3SzlhTS9pWlpZUERzVWY1R1dHOGJkcDZ5UEJ5cXNhYVRPNkQ4anpPWWFG?=
 =?utf-8?B?Mlg2YkhKQjZRSi9jYis4MTBsS3o5SnRYOUlGaFBOend3Z09sWXJpbEtmOVZI?=
 =?utf-8?B?dHpjckxJWVdobmkyT1VCaUJyUjNmSDhJT01STkpaWWFvaU9jTnh4cFJmRGp2?=
 =?utf-8?B?SDFoKzdDOXl0azdsUXE3cS95OStod1QyMlEyWVRXOWZ0SHFkcjY0bWdBNklP?=
 =?utf-8?B?SjF3N3IyUDZXSU10d0FaTlU3d1J4aU9MZldHM3NISTRQa1dBMHRnZnQ3VjdY?=
 =?utf-8?B?c1k1NzNyV2hqVzVRdDVBeVlDZDVUd3pCNWdlcXdDOEVtakNvRUthaG1mKzVM?=
 =?utf-8?B?S09tTE1ZY2lQRGxMVTVDTFZpYXJDWVdjYU5Ob1lOYjhyS3ZEM21LK0ZzdGor?=
 =?utf-8?B?MnViK1F6QnBwU2pMTkRDOXNIU0VIaGhUSEVqRTlwSjFVc1VhcURrOHlhYjdF?=
 =?utf-8?B?VDFQcjZqcWhXSy96TnNJSmZ5cGRnb3BrYkZHTEtYSGt4RkhueEp4ZjF1SHE0?=
 =?utf-8?B?L0YvSHJvYS9nMEQ5eTcrbkhDNjlvZnhwRHdHa3hQa3o3bHpTVi9pV3ZqM3JE?=
 =?utf-8?B?QnF4dVpkbCtzUVRLbVR0RFVTTmNwbWU2QmpZV1ZzQjF3YUZvQ1VxT1BIS201?=
 =?utf-8?B?d2tqSGMwRE84SkdrOTRtUT09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TFg3OTFTcStlcWJha2VvTDgzR0x1Ni9BT2NSQmJDUlpNVHF3MEJEclRFK3d4?=
 =?utf-8?B?b3FIYWQxUU9PN2VzUWtCZndUUzJzWHJPdlpqa2JJZmtHRjF5NFZONFlUbjMv?=
 =?utf-8?B?cnFpUUhzVkpqcnN3cWwwckJ6ZGJrTkdnUmUxSW1helRsdWYyaDB2TFZXTE5z?=
 =?utf-8?B?cVBIY3JIcklPQXF3Vzl1YU0vVjF1N1YwYkIxdzVwWDBacHR6WUpSV2Fwcnhq?=
 =?utf-8?B?eGRhVnhoV3ZXMko3TFYvdVNnN1hBaSs3SFNxUSthbHBpUjFrVlUxSitobDhS?=
 =?utf-8?B?N1NBc3N5NFlvaGZucTh1encrVk9oYXZnQUxON1dLRGRLR3p2K3UzQW9pYzY1?=
 =?utf-8?B?TjRvOU80ZXF0a0dqeElycVhBb0FpVzRkNWpiY0J2UFdPdnZiTDRBN2E5UHdX?=
 =?utf-8?B?Wml2UGtMT05KSXRsSEcrSXpYRDArZWZxQUM5THM3bVE4dWRSUVdUSDJkazdy?=
 =?utf-8?B?UEFMZ1M1ZVBvVUZGM1lDYlBjdVk4V01iTG94RTN5L0t4d3M1MEVZcFhHTUJO?=
 =?utf-8?B?MFhrNS9kU2U2eWhud3Irb21YMWgzZlhGR0t0UmZyNCtDak1kSUlBUzF3MlVO?=
 =?utf-8?B?NERMdjFMc1VRaEJ4c1c2SlJKMW9qTzRtbytxZjBqajFhQzV3Q0tPcWZsYzBR?=
 =?utf-8?B?QklRTEpCbFBROTBzUVVlVm9UaVJLZ0RyaFlicS9BdUhRa052WTVZSFB3MGRJ?=
 =?utf-8?B?ZjliejRtWVFEbXFyMmlaRjA5TDRlclV4T0NGZUVpUEZuSlJUWHIrLzY1NDV3?=
 =?utf-8?B?RnI1TGxLdjB6bGtuTUh2dnBxelZQZTlEQjBzMmgzR0RBOXl3dmNUUm9PUGxy?=
 =?utf-8?B?amdsd3NtQ01nUXVaVU00S3Y5a2FDQi8yajRIMUN1TzZUbENJMnZKUmwvNUVh?=
 =?utf-8?B?dk9mSEtLN1pBWkxBTDl6T0NwSFcyTTEycklKbFZHVndaRFBDTUFxYnNWMER2?=
 =?utf-8?B?SVNrMHZNc25rL282QVRNdnJSeWx3OGh6SUFabDBDclBlaWNuNUtxRlljVFEv?=
 =?utf-8?B?eHNST0hEdmEyK0tBNzdWaENBZzdnQVl3L054M2ZaL01pSHdxdXJPSEJiZFRz?=
 =?utf-8?B?MGVIaHJlYnptb08xUlBERTdlWjcyUzZpdDRSL1VCUzA3RzZqVkd3aEtETk54?=
 =?utf-8?B?cGVGS2QxREJsbnhCc3EzOXZ2ekFSVitHSnJMN1laME9ZaUVCVmxBaFJ0VHJy?=
 =?utf-8?B?N2Yvb1IzYjUvbHpYNW41K0RhWmhPTDdwZHJnZnUwTWZraktVK05MTHRpL29a?=
 =?utf-8?B?bnFvTDNyU2pXeUxoMzdRUTUzUUJnK2pNTG1EczBKMERmdzFJUHdOYmY3bzJG?=
 =?utf-8?B?ZXkvSG9Nem9yZ1Vndzc3aCtETUMyODhUYmd4M0pyWVZ0M1p0am9KOXpEQitK?=
 =?utf-8?B?NTYzSE9RYWJhS1BwYSt4NDFCNkVVSWV4MUlmSjcrdDRaQVY3eEQ4VnVGcUVj?=
 =?utf-8?B?TitGa0s1c2tidjcvMTJwQjFhRFdpSmhweERuRHc2cG9VWm5SVjJmMDlPa3d1?=
 =?utf-8?B?VVdMWlpzYk1xNG54RTBVSVpZcVNaQ3pjTVZPU0JpQmlvZ3d1YWtSUDdjNVNU?=
 =?utf-8?B?Yk4xOEtSd1hLbXNndXFFZFN0ejhCcDZSMTZyOUpmMkxhT3I5ZmlaOG9YeGV0?=
 =?utf-8?B?RUNmK2ZlL1FZdU5iSEszbGN0NTgvSFZJYnk3UUZUTm4rT2lZTWJITW0zRzBR?=
 =?utf-8?B?bWo5M2xDdUEwV05CdTFSUUFGZXgrKzViWWlKZ3FKQ0lCQzBPbXBTcEdKTmhH?=
 =?utf-8?B?bXlwN01pS2JqTm43QVNhREpWMEx6UitqMnA1OGJuUVlnK3VPYnF4UWtOL0lW?=
 =?utf-8?B?UVoyNW91YUNVS1NPRFZHb0tNOGlrMFJaTm05RmFFalVwSVZTNGVETHh3cGlz?=
 =?utf-8?B?T1RZYUdoWUx5YldkV3FHNzhJU2hSZEpERWdyOXp5QnNhTVh5aktoa0FURFBO?=
 =?utf-8?B?OVN2dmFUdmt3bnc4dXV3SU5yb3QvRlQ3d2Jkb1R2U29uUG01SXNTRC8zRXE5?=
 =?utf-8?B?VlpFMlR1WUxkREhKeG9Ra0VkREJjb1BIWXNvb0NNQ3U0ek1uejEzVzRBVE9U?=
 =?utf-8?B?VXNDa2pmTW92Z2RXdUZFT3k1YUJzSmplcm5JTGFZcHhKVnZhOFhwSHpUTkFB?=
 =?utf-8?B?NFluMjZ3c2gyTGRMSkYyY05GNXluNTArNmJJeERXUWZocnVZNlNveUNVK3Rl?=
 =?utf-8?Q?I/bGKS98MBPAzFEcsaLjfec=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	BwAs3IrDRmFbayFxvNvNwk2dwatCAL6vPdf+sbt2UHAnsdA2UysjDfD8bbcykaF8vXJRoME5NobWpipynRY2TJZncB50nZ965DN9RfHfREh2WGIwYW3P+wAdt4URQ7gG2jqABxGNbAJH0bI4TTD5Nx0rfOlWTITSumyHyhIYt6sT/O+W4TUgC0IYDhcbdOVJDk7N2Hnar6XjTGlmk6pjZluyIWnYzPxm6FjBbWGKvQc+C/Nkp1NJt/utKVVxVBwYRiYa7UQ3RNps3OmbQ+F6xG1NbWiMiRVpF4ED1xDfIFyQK/S3+4uHPLoXz1Hi0gqvQXwnErJj1Fc5KqFl9TplCkKCbkEX+GwSp7TfrG51Ioaxa9Y9ET+7q5cXcJIRm4UbyRaiA4QxejoAzffx6Wa7ehhNftBzZdGiBTMyAgyWnsWRZx/bYhe2ZW5kz3MF1VkCMSBB5EwLofchyQB7x2nfzTX66o5cSUquCR3BBmy2uYfNRS66cls4ay7KTpG5f8ptP30lXTwUnyW0DHJn3Iq5dPk/dM5sLVMMWWcNCFxA3hLrA5h4S6Nxmiv6c5nOkvsf3z6tuNEszy3CwOF9ioLAFTpYbGwFWEs+onKnZSK+Ng4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f783f42b-aa16-429d-7ea3-08dca12e9575
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 22:21:02.9967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bKA6Vh/VeXEF6Zr9mOuZZG1ZwDfAZugxIgwnMTg1/lmP/Y7ftmB4CwwMVJ4odVa8Jw2+w4l3eFJvQg70RHBIHtbQ9ct6n7oxk4UVAAmFA0I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7299
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_15,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407100160
X-Proofpoint-ORIG-GUID: pBi5FbHohtMSa1hLZ8_QIssq3MnvRvv0
X-Proofpoint-GUID: pBi5FbHohtMSa1hLZ8_QIssq3MnvRvv0

On 7/10/24 10:10 AM, Nilesh Javali wrote:
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_version.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
> index 7627fd807bc3..cf0f9d9db645 100644
> --- a/drivers/scsi/qla2xxx/qla_version.h
> +++ b/drivers/scsi/qla2xxx/qla_version.h
> @@ -6,9 +6,9 @@
>   /*
>    * Driver version
>    */
> -#define QLA2XXX_VERSION      "10.02.09.200-k"
> +#define QLA2XXX_VERSION      "10.02.09.300-k"
>   
>   #define QLA_DRIVER_MAJOR_VER	10
>   #define QLA_DRIVER_MINOR_VER	2
>   #define QLA_DRIVER_PATCH_VER	9
> -#define QLA_DRIVER_BETA_VER	200
> +#define QLA_DRIVER_BETA_VER	300

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

