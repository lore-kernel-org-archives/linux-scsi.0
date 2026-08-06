Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951F0422542
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 09:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786006946; cv=fail; b=HEawZzeersmGVyotNjcm4VY9Szu0ELuHXyP0JYIlKco8TwieCtKWYa75rH7IwXEAA3FnXxFsc0DNn/bpAB7MPxOzSUXw2yOcn/ZRWZQ7bSBGCrexyu12D0CmwDgWXxpIsnLpewDRfZLqzQtsPwEP0lMUCIOH/RLVo9usyj/faxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786006946; c=relaxed/simple;
	bh=PY7+Yj7Uz2/39qrDgPxWq9UjWzYiiCKkyEH6YoK5LnQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cvH4Z6FcFC3cvhfo1Mr+HRZCVqCOqKjiHmvw6YfxQw1mF//zsOh8aOr6CH4eodyiOc7DchOnVc3PJYcQRj7oCBX929mXKvELq90NkUC6aZZH9LZ9zUZ7JOUWiPQIQDUxP4E8/R+WCHIMKwO6ZRPxc1xV0EhbPCNjF5OSebnt+NU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kRVcKsUg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IJB1kFPO; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kRVcKsUg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IJB1kFPO"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6768gm7u948917;
	Thu, 6 Aug 2026 09:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6PQftQQl/KTscLwWq0oUhLH2mVtLyjAYXjZ3ALPVh1Y=; b=
	kRVcKsUgtGrbt5FhXxcP7+60f879e5wR0LBH7nA8wvR8kWozXqgNzI/QZ4I90+wE
	1uHKgGMvcymyiBV5NN1L5txSkpAd5NEaYbDb6L9lI/vQQNWxFj211mEIkGCUDr27
	skD2WB2YwAD3/wYXKI2SUmfK5uiabC+suDM7jbXuTuDwgOfbn37Td98H+b4vk6qX
	WjU3kAp0UNZ5zN6o+igStRLxV+aDfZEJxDZTI1mY5Hq3H+iJfeLuGB2nKft+1tXX
	O+IcZK3uSw0yrHAenXeft9bXl9aBQLWjVejM7aAM9JZgrFQDFtra0bnMK9RokTdW
	j2wpr3gIguaOHHLSyD3++Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7qacx6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 09:02:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6768tc41009862;
	Thu, 6 Aug 2026 09:02:15 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012038.outbound.protection.outlook.com [40.107.200.38])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w8uaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 06 Aug 2026 09:02:15 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PxD7vZEujhoriakh/ia+hZg7oWijSr3xA6SH9LVIhIoH/YjlqzOrO92tZdyS20e9d9lImUyc2N5GjbPUIT/MqUHAeTediEwusui/wHMxUqVwJfC4dTGim+VeAy991t9YIl/Jm306pFjCFeA8WJhiAYkIGwMe0o79r6cboiDRYCggDjXpNA+2OTcUZKaHWqk0Loozlq9uQCVU66m7zSYm2svHCLvCx4EW1PUyGQd+CRoqdTheVucpscvRJcJ5IBwlI1TDhII/6jc3Mzy2MUU8srk0mzP94yD5Wd6RibKsYxCDFzWYTbZ2d5bycQDh4u/kImsTOGh60alljfkYdG0YKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PQftQQl/KTscLwWq0oUhLH2mVtLyjAYXjZ3ALPVh1Y=;
 b=Z+1jeBqizGbK0efYg0I6XThrlu4kNIdvnZ/4ieyl9FKUbAETg8qhw2VLXQph/hmbpBLFllmxgiMKOAMRJ1bGniyWEX/RsUezwbKN5Ze35iaQ8JFOZKBh6Mna6g9dVpf2sZb2AeznJwBJaNgxa6xzo3UCbE2tCeuEi1//SDPcMZKa4Fyj8EP8Hb33uH2MNVtXmYzGCFLvEB8KhgLGrYqhLOb7/9so8QnvZlPwOjRerjYeWngoriON/tIjegSgKDxTB4/v70rXFa4deXR6KBHwTejES2NRwihPUTh/JiScZOZtHp+cTaiooStT2OJbka4MAj1qe2RCgDuUJMqF/j5VAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PQftQQl/KTscLwWq0oUhLH2mVtLyjAYXjZ3ALPVh1Y=;
 b=IJB1kFPOhS4UrCkQ+3tX/s5PeWvi3LpEJdP4hWIkH1LDp/mWdS9LH6l/ypvHtCCPkuZTyVjZQk0PxkWco8QWZxMJ9LxnAkh/rL8CxUBgbtEG/x+wDlESVHm+RMIvcc2zysr3cGRCA1xtGCE1eWDsZpxM1YHqqQSMxmH8ExADIQs=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 MW5PR10MB5764.namprd10.prod.outlook.com (2603:10b6:303:190::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Thu, 6 Aug
 2026 09:02:11 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.018; Thu, 6 Aug 2026
 09:02:11 +0000
Message-ID: <96fabc42-6fa8-4d20-8c48-9435121bb34e@oracle.com>
Date: Thu, 6 Aug 2026 10:02:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/6] scsi: core: Pass the SCSI host pointer directly to
 scanning functions
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <cover.1785965531.git.bvanassche@acm.org>
 <c4c76a09b8fccfbeee5f0f86578a66781f4aff4c.1785965531.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c4c76a09b8fccfbeee5f0f86578a66781f4aff4c.1785965531.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO2P289CA0002.QATP289.PROD.OUTLOOK.COM (2603:1096:790:6::9)
 To DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|MW5PR10MB5764:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b67212e-2f1f-4d8f-5c4a-08def39966af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|6133799003|18002099003|22082099003|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	8YUf6dTNT9gDrGIcgBhiaC5VWWs+1ZiEj4jhB/iMq3n22yDBswJMvzuNC/TI8WocOE3TapYTGC2G0JtFybqcd5EXXH9ZAd0EHXeei0eIDOPcRZ9/vt6KLYQaSOuIZhLzAkuECvetZLoVlwRCpOMJct6NKOuHjQZueh74ut2rUIeIz87CV+Ck0YhCilqVGtMyUVWJI67BJxjkVqDJcvp1BYvEwtqThzdv/Pjv1yKqwbWKXlTTI0aJ6DrxvK55LODRTJkTS1B7x/lX9lCgWHWSgSZuudeSQnWEz611wyOmfRMHRxEhGN6qMxutgCuiQCaHv0Udh7RWL5M3aRhsycehcCG4CtoruRoREEVUItwjZcti1JOZfU7hbRdjUpkWE7WVBOJ9SDX1U9W60iAZlURwa6fenz1GoPM0/YZGLOVeCIat47l0RTvk46GSGJFsDCr82veGjBgUtxT499z84pcxG94/iqVzamWi6DiFWnzCn1/WTgzpV7bpwvFWFi+aWaX5Rq9O6jmEdDXVMZgvTuKMAqfCpghTVCAThJWi7JpI0egpUmhM/qy/l4tEyuKYPMwSY9GhIGd3Gps5CCyG/SlTyd5FPH5jbvqPHBzfElzkoSKSGlr+QgXPTyJr6kljQIfmk3ilJ9pTpPqnKlb0En3X7eIJoxKcOS7JjBELcnyK6io=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTJiZmNBSU5vOEs0VlNIT09WVEN5ZUZwVU5qdEVKMFg1dWpkc0tLNklwTGhk?=
 =?utf-8?B?VU54RWs2SkRmNExjczJtb1JuUmszYUFXckJ3MDR3SW9VRXp5cXpHU0ozT0ZJ?=
 =?utf-8?B?ZGVFUk9hdE96YXVidGZjY043VzB4blg4TmlZRjBQQkdHQ0VCL3ZaMlk5STA4?=
 =?utf-8?B?U3lab1VQRTFYTmc0Um5FdStiZG41WHY5Y2tRcnFxQnF0TjhzekJMck1JQjZD?=
 =?utf-8?B?NDU1Z1o4UnBaYU5TSnJIQkVBSDFVd3FyMEhyZ3hEei94OXZFSEwvZjRXNW1F?=
 =?utf-8?B?WkkwUG5ESm1FR0RhcSs5VkxVMkJwWmVnQUNudFFORE1SSlZqa0hzV3B2TjZ3?=
 =?utf-8?B?cnhlUHA2VG1JZllXVmhwNk5MY1FJWS94cjdySkdGdWtlN3BMNHNlbmZ0NEdT?=
 =?utf-8?B?aXp5dTNoZHRUbm9wbVR0VUFycEZOclNEYWpyVlZwTGFNZno2VW5ta2h4NzBZ?=
 =?utf-8?B?THRuNHZQamxZNkNQTDNmT3F3azZncHl3cnhzZ0xYWElkOHg5ckUrR2h3cjJ6?=
 =?utf-8?B?VytSRG9zNjR6SFVlRi9JOFdkNUIwR3BUTzVNNnEwVklRb210WHQrcEFIZzl0?=
 =?utf-8?B?U2M5OHgrZ2RBOWUxc200aTRDMnNQNDlNUHhRRXNxTXUzeDk1T2RuSE0yUjFG?=
 =?utf-8?B?TWZiNHYyQ0VtOVlUQTN6Y0RjbE9lMlZVN0VEdVFZaTMzaUtoNlE2bzFaclZr?=
 =?utf-8?B?d3A3SHNDUUxvYzlTZjB2Y0ZCazRuU1ZVSXJ4bEF0dktrcjk0Skl3dmcxV20w?=
 =?utf-8?B?WGxCL1hWOVlOSTlGQjVmUURMTGRjNmxraUhOMmdob3V0Ly9sQUZsazlxMVdh?=
 =?utf-8?B?NlVTZDBZajd2a3JIMnFDTW1pV0JNT0lOaHdRRWhGOHFxU1pvSDBzQjVmMVR0?=
 =?utf-8?B?NWQ2L0czVWFHSStnRTM1dUZseFB2VGZsdW4velpJaVBXVVBsOGJjTWJ5azRj?=
 =?utf-8?B?ZGRuc2kwbWhmM2J4Tlp5anFDVXVxcW0waVB6ZzhFU1BlbFhLcytIQUVmSW5S?=
 =?utf-8?B?c2Z1blIyOFVSNDExSFlsK3Y0S1ZYU1dvdXBNYUZ4b1I1aHhzRElsUnhibTNu?=
 =?utf-8?B?K0tNTG80OW45RzFUL2dEeFRPM2pUdWxuVHd1RXQ1eDBjSzdGMUNKbkJwbW5D?=
 =?utf-8?B?dXozajhoR1JlZlowN2w5VDF1M2tzbHZsVWEyLzZpVnRsR2lVUm1Wa0xLYkRl?=
 =?utf-8?B?U0t5L1cxZVdsUmhkN0pYenBhQ1NKbGY2OTl1NVZkUzRobHhHbkc1QUZkazB0?=
 =?utf-8?B?QlN0WTRPdEFGa3AweGZpVWExbWRBaHhLajBmOUUrd0ZuR2NUVklHb3dCalFO?=
 =?utf-8?B?Y1hvSGsxS0pQSUc3QXE0SitWQndwZ3k1R1FuL0QzbHNBNk5iaEJDVVBHdVlm?=
 =?utf-8?B?aGora0ZHdVVPMDl0dTVwOHVmdkwzb1lkbGtGVzh6UVl0eUJqN1krc09Nc3ZK?=
 =?utf-8?B?c1hBUTZ2WHppR2R6Ukt5cHBndy9UTHVZbFp0T1FPRVFLck5paXlkZ2d6ZjY2?=
 =?utf-8?B?ZFduaWExNURMcUR4YzdWM0IzYmNlTnRqbzcvSzhmM291RlhYOWQyd083RC8y?=
 =?utf-8?B?eU1SVXV3eGgxWUtacjMrdWFQQ09nOUJqNkQ3Z3JoZXRVTTQ3UlhxUE1OWGo1?=
 =?utf-8?B?d05kY3h6K1pJRUpVNlV1R2xENjVFempKcEdzdWdjUmlwTzl4MXc3UExYUnor?=
 =?utf-8?B?ejRKdjloa2UwVXlqNGZzd1lhSFlXMldOaGM5MFlRTS9aU25rN09pY1YxTTdC?=
 =?utf-8?B?QzdkZVlVdnBJWWs1TE1FeWpLVWVjT3ZWdGl1ZEVnc0NWQjlPcWxCTEEwTkVV?=
 =?utf-8?B?ZTFJRzdqWmtWMjJOS0MzTlNESnBlejJDdGEwMXh1VkhIMjljVWNpQlQ4aWlq?=
 =?utf-8?B?cHorRjN5cldNQkh2emFXczJ6WURxWXlYbnV1S3UzaStoMjBlU3hxV3FBTXJ2?=
 =?utf-8?B?eHQ3ZG9Tc2x3a2RoQ2ZXUnZqSHRnclNLd3dzeHVNdVd2eExUM1FHOG40STli?=
 =?utf-8?B?RlBKeVVyb2JqYTRJRUFZZGhSTFFPa3pqdlkrY2tqNzdpaUlVV3dJZDN0MExZ?=
 =?utf-8?B?dWh6TEFRd2RnT1JCM3Y4ejRPNmhWSXA2UkFoV0o4TnVoNnJ6d1A1L0ROTGlI?=
 =?utf-8?B?VFZubk96My9IeXJTWmoyZWJEdXc3UlMyN2RlZ2E0aFdUVXBocThBS2pJNFlp?=
 =?utf-8?B?NXlrYkViZ2oweUc2VzRELzh4MW9ZY2o5cTBZblB1SzgxQWZyUFhTYnVJSVQr?=
 =?utf-8?B?dDdtbWZLRk9WNndxSVdVZkgvbmtBWmxORGRpZE5zdmJZVFg0dVdxekY3K1Vr?=
 =?utf-8?B?ZkFTbmV4SDRzTU9tYWxkQkY1WS9nSTFvWENTd2hCT0MvYTg0cFYyR1ZYZ2JB?=
 =?utf-8?Q?La14gKlnpPbhpts8=3D?=
X-Exchange-RoutingPolicyChecked:
	aLFpDbAgZmbsn68klC00vMx7SagYRNjapbOswlufkAkOZCE8hlHQRbRqPgZJ5pFSg9tvWYQeiHMeXlB31/Ea6gdqvCMsfk8NKjx/UfovXpmmc/VPCbh+Y3ew9IgnPE88TyJYV6dTqRv2ei7P+zAktsV8LOjY+yJc5gXJ1qsdSm1i8iMd/p+0yAyo3vac8KHlL5TUI+ZXONb72Mb9Lda7Byl/I7THSLghR0flnJjJgI5+jTeaidDtHUDEesJY/Gdjlpe73BEolqFSoIi+ui0pD56YyiobSoYS+ISsYGsw8WfK3h+c2y1i0tH3OEphBpLUGqqjwzBWGJdOGWQefuLlng==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oj9IksXUBWfxQ5PWMtBk0sRe2rsLFL7P/kti5t8x/CJCZxwsL6Mbjw6NJ+XX8uYmikiktevfU+XEvu+KJ1v0n8OG0Fze85+jvyf6VgRdSRaNHhXk1S2uM83ZdmkKaLIgGtAOVGAl4+7YhPK5KP5cm29qdqB/ENkGPKJy7GAmK+q79RDu5C+EcaTIbsT6YblND7nRPCAfe7cOjK7vIwSSL8sNGmWz/2wvpHygi+O951N3JoTMu0ugWsnxOClXXrXf7f6O+BYUTjJxOp1AoccUO3nC5hxPrh9d2PPSDWcZK661a/hodZyh9UQtd1kkJJ823cXtEJKuIUJsIy5dU7WQEtcf+P/nNVV5lu+9zuDwyJ36fS18UNe2wxnWFPJXBVLq5aQ37bmRk9zMTrOHv7MPNCq8+eOVClBAfde95/X9K5O1Y/vPty1DqIJMKYsuVtv68n5ZRCImqmngf28k99St3W373WIszQsJm9vTcNo0tWwUpVy0v1cIfHti3RJ5XNWbSCqs2ifg9AmAG6PFdGhU+wiMtPMV5WeqdTdS6M9ZMwkECYrbXHyU0CN2F1ncIQaYktJAOxEoyxcvjDVTyf+q0Wilj8F9jsAUdSNHmnk6Vjk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b67212e-2f1f-4d8f-5c4a-08def39966af
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 09:02:11.3607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aj3nisyY04iGKJCfRek0/cNaqjU+ggII9mu9euGXepQwe2f3uIk/U6ZQ9iRiWbTR8FGskNGaa4XdLPg7P6HMgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5764
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608060069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDA2OSBTYWx0ZWRfX4LvE/OArQOxu
 WBiIG25B/fk/Vcw1VWQn3Stlyu+23KHyQDAQ+WxxTbNbcH9ng5BtujwS/UaZmLYk3eR7uTLutdz
 GCz+OQwso3pTXDeCaBXuw2CIHCy4lVNM6ve38GGiXfIswFe6AzOvm7YOmUmr5X3Z1jrA9+8Im6m
 nfvSnELyOmex74eB7b+z9zBEZUR3WMjzhVBKtR5eC8+hkwqqv7eHwt8yKcM1GNAyX+P5g3kz13J
 HE5D07V6UA38dQT07kDQdSIY+206l5wWc/M9WNjZOMppDVcxFNgEQoNvrSDekpLpAvjwM/+0HjC
 Qxy12qjRZtQ899sYoroMt/7zbtahUBIff72bJEmzbloATFsF9xVP7UTERMTA8tV3LJt/UvCJ3Lw
 ge02Pm5Lf4U0kvKdKvyi45PNjDnV0zaT462VAimpD9ESAwzaYJe5g84grMOD83wbZhtnuuBs//n
 lLrTX5Rraa7twVJs3UaN6IUZhWmvyUrGTTo4qmfM=
X-Proofpoint-GUID: XRUbLYEwB5-gbMYXsDEiTCh_d5nTAb5K
X-Authority-Analysis: v=2.4 cv=frDsol4f c=1 sm=1 tr=0 ts=6a744d98 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=N54-gffFAAAA:8
 a=yPCof4ZbAAAA:8 a=PDUtP1vUtOj_gQ9FbFQA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12100
X-Proofpoint-ORIG-GUID: XRUbLYEwB5-gbMYXsDEiTCh_d5nTAb5K
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDA2OSBTYWx0ZWRfX5LznhDDsJD33
 vK+TskWE7786vpHuwqSEHuRiSsq0Vltc6Ogb7PkbYevlxyPgA/VQMvLup7Fw8rJ3UyKvPdUBwMO
 d+x5jV4L+uNFLmWVJJoz/WOFeMurPvkcBHBEKX7XAZncQ9ca34C/

On 05/08/2026 22:36, Bart Van Assche wrote:
> In the functions scsi_probe_and_add_lun(), scsi_sequential_lun_scan(),
> scsi_report_lun_scan() and __scsi_scan_target() the SCSI host pointer is
> derived from the SCSI target pointer. Pass the SCSI host pointer
> directly.
> 
> This patch prepares for enabling lock context analysis. With this patch
> applied, lock context annotations can refer to the SCSI host pointer
> directly, e.g. __must_hold(&shost->scan_mutex). Without this patch, the
> following annotation would have to be used:
> 	__must_hold(&dev_to_shost(starget->dev.parent)->scan_mutex)
> Additionally, in code that locks shost->scan_mutex, the following would
> have to be added to help the compiler understand that shost ==
> dev_to_shost(starget->dev.parent):
> 	__assume_ctx_lock(&dev_to_shost(starget->dev.parent)->scan_mutex);
> __assume_ctx_lock() statements should be avoided if there is a good
> alternative. Hence this patch. No functionality has been changed.
> 
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
