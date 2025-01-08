Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0AB1F37B1
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 09:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736327122; cv=fail; b=RQPMtdP4Z6TS8DTo0TY47DmCvMrvwZMFKAB4qntQsdG9Uac6QChGm1iqoII8UvznkMFgz+iPaMnY8P67bZ9poQKhZAHjb0K7Q8mIqvYK7GATMQcSvf5mdBRrbrh4mb7F5uaXQw62kVaZY2qXOR7HEVPC07CisGm6OZCtdIOvrVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736327122; c=relaxed/simple;
	bh=I6MggPmnrKiYqC1bfFf96XuT2BDBxDoKBYeIGAKcrUk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=T8cDwkIypWNP9beRm8whcVDAVOaSdNOf9m9x8WpkJSirpZAz9qKuxWADfbd4G1PJWj/zzPSfVRJpPG1l1pMidYC/hzwCuW0OPpE8V/arjr3Yj2y7Yi3NgqZol2lrYjOhmmbtLVUfciPQ7k0STtx2zItxcer3vpga6ndeXJq0HjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KXSe86A4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=udHwS4D+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KXSe86A4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="udHwS4D+"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5081twRk005965;
	Wed, 8 Jan 2025 09:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=i8yrOKxIBqo/lGtUCrT5HC3kMXsoXnG75CIxGt9GTqg=; b=
	KXSe86A4VhF97nHCFzgYt5QB1UZcgL5C47HLi3toCYvuWKVAKncpKjywpR7SmJUI
	jWQcujnP4uRyijscSF42O0Eej6Kkhux0axf+sPCJC17tncBbaDgN/iqMzeJwsxRk
	ecy/sGpt83Nf8DEzC38TMN2K8kp30/LHiuWk5cA92111qubM279VziY5QPJU6dMo
	J9rYgbp/26A9GO0H0kZ+3qmK1G3qYziiiLlZp67q+tocWD5x8vVw021IZRZqqvZU
	E0l5aeRxT+xqV8BJ6LHE//TtY6984tiVogkICRRWMEDug0kCF9mI7mniHMd9XRbU
	q0GE3eehvWxXGfjs7oMmjA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xwhsp7bn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jan 2025 09:05:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50893gxq010873;
	Wed, 8 Jan 2025 09:05:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xue9baka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Jan 2025 09:05:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QryYOTcPWsGsDYtNwyQiNKqOnxHhPQZq53XVjSzc3L4Ozp+ovs7sEzJtazzcqIdy6i9LuXqd86qvb5kUwugIa9UHrlc7xd01AbELcm5oAnQZC2dM10cLcjUFiadzbg1deB8fqZ0OZzyI8XxT3EGdtuNOCmMjt2zQQIypPieJ0ZzAjXaEpPGx15O3ZhoTbuufoBw+37zU09Qw6Wj12rF5C0A+B4OODOYCH2oYhCWdRLy2uebofMiWjjcs+viTG/oJpMFi9NT8y8mmCywtt+WY3vtvCfvIGGw+Vo4eJkx4kZhjnV9tKCRVKHgGW2Md84DhHCrtwX1HpqQEshUPQS8oeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8yrOKxIBqo/lGtUCrT5HC3kMXsoXnG75CIxGt9GTqg=;
 b=sV1gUno9ZGeWtK71v2PzZG4LItnNYTw9s3F19XpFwQiVf7ytpHA66fQoVmF+9kClsX28TkjHBzcdEnBRaCBZAJ8EQu3nBzuailnDUr63cOWpp8iws3RapuKPgn8wkIyqXZpo0zuWxDV7sU8NyZl0q1zyeR1c6lt7vxOZ3cQWiM3ZRMSyLiZHEe6hMczxuNB3dvYKdtzIJZb5Z/V9wE/zUe4KRieOVVsL/aeLwGkGJGXAxjanEIdu5K1NlGtDjOc+BMl2ySPWHlWjeXsoixDVJNL9TCAU099lD/6lrB/uiW4qDSFAlhqABfbOmqWvBFtecVm07bRVQn7+lr6Cb7PMfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8yrOKxIBqo/lGtUCrT5HC3kMXsoXnG75CIxGt9GTqg=;
 b=udHwS4D+2PntYMJZRjrCinkpq9pwhClt0fzsdPi2t7ceh2ECDjVzGZPygMFT1HWWcW2wjQJiQiKuIWdJOhx/LDcTkheGRsOngWtleFMp0pTNlWlTS/DuQ4d0iALBMr6X/r+2NwZF2dzifAR5cKLKDYzchcrnsxGTie0WYDhhH/E=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY5PR10MB6264.namprd10.prod.outlook.com (2603:10b6:930:40::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Wed, 8 Jan
 2025 09:04:59 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8335.011; Wed, 8 Jan 2025
 09:04:59 +0000
Message-ID: <fc3e74c1-9455-44fb-86b4-0690f7ee6a51@oracle.com>
Date: Wed, 8 Jan 2025 09:04:56 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: Fix command pass through retry regression
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Cc: Kris Karas <bugs-a21@moonlit-rail.com>
References: <20250107010220.7215-1-michael.christie@oracle.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250107010220.7215-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0690.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::7) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY5PR10MB6264:EE_
X-MS-Office365-Filtering-Correlation-Id: bb8fd477-c461-4630-aed0-08dd2fc38776
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVVOa0FZejhjMzRSVTVER3hXaGozS0hwY2tqd252WTlQeXFDMklIRmJCRTZi?=
 =?utf-8?B?Y2gvdTdzWmtXZ3NvdWhpRXRLYkFWNmxHRitHbXBzMHFIdkNsMlR4VGNDZHEy?=
 =?utf-8?B?bnZMRnhyM1BycHIwL0c4bTVLb2diUGt3NFRiYVRyNVJadVRHd1d3c2Jpb3E0?=
 =?utf-8?B?cTdWeUF1Z05mUC9USmtFVWdWMjJKRkY4eUtIN1MrTm8xcVBjTnhrWmJuWm5H?=
 =?utf-8?B?MGxSMWxuckkxa1BBNUkrOFA4MWlmTy9uUUd4eXEzeTd2UXcrc3g3R0IrZ2pK?=
 =?utf-8?B?RTJ5QTRIQThqQVUva3hQbUE3NEhEcVBtNUY4a0JkMG5BWjBSZVZiSEYwOGNI?=
 =?utf-8?B?WGp2NUk4V1gzTFFBM21ET1ArTGg1bDZEbTZaV0dTaHdTQk1XR1VyZmNjZDJF?=
 =?utf-8?B?Q3NFOEM3dC8weDd5ZURuNHdnOW0wdmw4Y29qUG16akxVYjJoVGpQR0ZQaXpo?=
 =?utf-8?B?bTVXZnRXUkNxbWRBZzFFN25KKzkzNUN6OEhjY0JqaXBIa1V6djNOaE5VNHFF?=
 =?utf-8?B?SFl3d3NkZ0tsU0pldnYzUDhiZlVCNjNrUzdLM3B2Y05Icys1bElTd1d3Y1Qw?=
 =?utf-8?B?aS9sREhOVnN0QzduR28xRzVFeWRIYmVNR1c3K3R2T2VpbDFHYU55aDErVjJP?=
 =?utf-8?B?ZVlsYkNLdWkzd00yeEk1czRyTGFaWlFBWHRHZE9XcUFoVnVEUTVFMGE2Mk9X?=
 =?utf-8?B?NkUza21CekxPNjE4aFlIZW9nTXhMOUIzVzJJVnVSZDJaQ1lJVzVIcGhKUzQy?=
 =?utf-8?B?MGl3eml4a1BLNXg5ZFhJVCtCT0haMHhzaThUVXVvL2FCWTQyckd0N2ZzWk9B?=
 =?utf-8?B?NHJockRRVmg2SXRXZlhpOUh1cjNaYUhlcndjVE4vVk5paTloUGFnK0dnU3dB?=
 =?utf-8?B?R0pOWlFJdmw5OGoyWjg2SjUvTmNvMFFDT1BkRi9TKzNvWS9VQ1h2UXE5dHdz?=
 =?utf-8?B?YXRJeWVWMDRzWnFIM1IwZ0dMc0E4OUJkVnNRUHFPM0pIem5mb2Iwd1Y4UGkw?=
 =?utf-8?B?MGxmc0pMUm5YY2Y2SzRFUjBhcjlMRXg5ZlZsOWJGVmVNblBwNVRVb2hUeE56?=
 =?utf-8?B?a3VHYnp0MkY5NWJPSHpBTlNjanJDTmdjeWVPTjR6bFBVM0N6Vjh3Nzd5dWFE?=
 =?utf-8?B?N2FrR0Nzc3Z1NG0zR3NKalg0UDhMTFpVYWdLanBYNzJuZ2lQQmhZVFF3dFJx?=
 =?utf-8?B?NnEyS05hbTM1ZWs3a2Nsd3NMK0tUZ1NQcUJMa2dMdjB5TVpwSFhaUGVLMEQz?=
 =?utf-8?B?eFFuUVhRSG0vK2didlBQVTZmSE10MzZ4Q2UyZElnNUpBVFBQcUhTUngxR3A2?=
 =?utf-8?B?MjNrMDlkclA2UWZZd1FvYmN2a1pUZ1ErOWMxdGJjSGx4RnVOY3FSWVBWQ0Y5?=
 =?utf-8?B?b2xCa3IzMkQvRk55MzZkUTdlN1BzT291VUpCZ3Z0dXA2ZGlUYzcrRi95YXR6?=
 =?utf-8?B?cTA3bHl4SDJWWFdWekhzNDRDT2NsejRvTFdmaTc1Vk52TXBlOUFvK2dJbjE2?=
 =?utf-8?B?Qm42SHNNVnozMk84Y2hQRGFsTG94NFZGVC9DUnFOWnY5SnJQZTFjQ0ZERnpj?=
 =?utf-8?B?Y042OWFXMGJ3UG9CUnpmcUgvZTVLOUltUmJUQTZEZGpnN09SVUkxWFd6RXpD?=
 =?utf-8?B?TEtzTjlUaWxSdnVWS2ZiUU5uZ0J2MmtuSXVSdVhxNm9sTnJKU0ZoRkZHMEMv?=
 =?utf-8?B?dkt6ZndGaVM2QUlqQTFUN29USmxGd1Y0VTRwbUJES1ZOWWxUR1FHOGFUQytr?=
 =?utf-8?B?bm5KaXhXZHBoeDJqYWloVGhqRG13TWFiekZoNXJJSlBvcGM4L1JtVkdwVG1j?=
 =?utf-8?B?bE9pQnNRMXg3Z21kcXhsTm1IVFhnTlh2SmlvWGVBWlN3Lzd4bTVVdGRKOEVa?=
 =?utf-8?Q?lQOcQ7dGkM3tN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TTlrbkJLb2lIUXIwRkR0QnRzNmdWQzFwRk9GUHBkOWFIUTNGN3pTaDNXb0dt?=
 =?utf-8?B?OU1GbDRFekVldFFZNlR3aC84ejh0SVJOWWdjYzVvd2FXa0VvS1NTUXNObFg5?=
 =?utf-8?B?WVNxYWhHM0tIV2tLOElNd2dxekZmeDNaNzRsSUFxS3dCM1BGd0ptUnMzVklB?=
 =?utf-8?B?NnUzc2Z4OUZETjVrQktSb1JadzRwZkJyd2k5U2JTK0VOR0RaZXRrYW9kams3?=
 =?utf-8?B?dDlMc0tYQytlWmtjdDNQc0s1c2RxUVdqd2crSzV2MnRCNVlDOHFwcEhzU1lt?=
 =?utf-8?B?emxWdHpRSGc5NmVUU3ovZnlNc2s2cytFTzBYVEd0SVFpalBJajV4czBydERm?=
 =?utf-8?B?WCszS0RQSCtDVnJkeVJxalFTSzh4OGJVSDJoeFZadGdiK3k0dURwOTQrc2Y0?=
 =?utf-8?B?VXZyaWNla2JqaXpLK2t2ZmhXWXZITEx0Nzdib2dtYmsvNDVhNWYyVkRJT3Jr?=
 =?utf-8?B?eDJUazc2RUpIVHY2ZlB3Umw3Uk5UZjhwVW84SlNrc2VGSnFRM2cxZjY1OUZ0?=
 =?utf-8?B?K2Z5a00rRi85OGYxS2hsMktQYWdzams5dXgxSGcvVnFKYzYyNFcxb0pRYmRM?=
 =?utf-8?B?UU1zSi9rT3dmVHZjMWF0ZDhPekdBVlF4bU5oTExBVW5zSEI2ZVJROUtoUTVl?=
 =?utf-8?B?NjRUdDVUSTlyZ0ZwcGJDWUFoRHg4eVFxaE54WmJPNW0ycUxxcnlkSW1aODRr?=
 =?utf-8?B?bk5kbi9OMGVldExCeUZiRFdENGlDbFpYejR2RmlZMXJseHNoOEJhYzVUWCt6?=
 =?utf-8?B?YmluMmxyY0VGcmdhUUNpQ2dHblZqRzBXUWlzTjNxSEdTYlVURmZzekVoQitS?=
 =?utf-8?B?YkRuNW1BTGp4UGhJUlJ6b1hPUGtmaXYyR3FlWlhTS2ozT0tjdnoxOEJMZnk1?=
 =?utf-8?B?YTBYUlpYaVBGTkJXa2NIcEpQemk5ZjNJcSs1K0RXWUFaQlcvd1puUnd4Z1pa?=
 =?utf-8?B?SExMc0Q1RXluSnh6ZlZWVysrNkdINW5QWHpZV2tudnFLd1ZlVFk5R2ZGb2hY?=
 =?utf-8?B?d0ZCQjV0UVZnMVRjd3JHSitacFpMd3hTaEhkZ1hDLzJMd1l5UW5QblJhR2U0?=
 =?utf-8?B?WnAzK3dZekdOclhrSkVQYXFRb2Y2V2krM1diQlo3VWxtS1hJY3RINVN4Uk1o?=
 =?utf-8?B?STM3b09qUTYyZWdFVVFwWGhSb1R2S21SRk1PL0VJOXgzREZMZUY3MXNIN1pu?=
 =?utf-8?B?cGJRV2hTalNrQVpxWVdpU0JJNXlrSEYyVkVXY1pud0tyRW84RmZNbVN6RjZl?=
 =?utf-8?B?N25xcDg3L2ZSZWxoWXB2dFhVUXZWUzdUUzF2OGxLUk5tOUFtakNiV3QwbzAy?=
 =?utf-8?B?UXRGS2orcnVhOFBpVnMxVnlDUGV2cnNPZ3c3L3BOTjNVMUVHWU5JQk5FMk5U?=
 =?utf-8?B?QmtHZkhWS3FJeHRvK3Iwc0d3a2RUY09qNWZTbGQ2b3E4ajlzdUFUSVVSUW50?=
 =?utf-8?B?d1J0dnBnOXVDYUUzbDhZUDB2Q1kycE5hL0pvRjNmL003MlhuL3ptMnJhdXpt?=
 =?utf-8?B?MjBGdmF5TEhZdlpIZmZwVStZcHNUM04xb0VkRjRjYk5PdmJqWmsxajRxdFJF?=
 =?utf-8?B?bmFQWnJzWmJBcGxMc0lzTWRmMDZ5ZTMwcVpoODI3ZWs4SG5FWE9td2tIMjdO?=
 =?utf-8?B?dzQ0ZlpFN0xqZ2hrTitwaFBsYW1qSFBOWmFRa0dxQWdBbzQ1N0lzeDBHTWRL?=
 =?utf-8?B?MWlPM0ZhTUpRNWUyUHRwZ0ViejFDcVNabG9LejVrVitFWkY1ZzMvZS9wMnVF?=
 =?utf-8?B?SnJDREM1WE9ZMld0NXN0WWhGb0EwNFhka2wwZkVCZ2tSYm9aZHVmY2ZhdlRJ?=
 =?utf-8?B?Szh2OXp0RG9xcHdzV29lTTdHc2JUbFk3TDFONVFyYmdTLzBPZEI4c0hITTFi?=
 =?utf-8?B?OWM1MTZYaVN3R1pGZ2pzajVncHRnejYyRitZN2gwR0lJSHJtcldFV2ZXQXh4?=
 =?utf-8?B?L21hd3psaTdJeS9vak5qTWt4aVhlb3phMUplSmw2YmxKVVY3eWh2UHBUTXV1?=
 =?utf-8?B?eUZXQThwYzhHaHJpRm9UaXp2UmxTQ1JsSEhhUFNraEVGZ2RXSmxwWWptOFZv?=
 =?utf-8?B?M25laGNPMkJqdFQweU9OSGg2bDdXL0ZhcC9jeTNjUUJhVWlVN1ZwaCswUWxK?=
 =?utf-8?Q?rLwseJWVC5CoRjivYsxJoheyf?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EcqOexcNaaNnH1r4c4Dy/jCNwA5pCb5MyH/mzDiCKUvwvyZUvZl7+/QFLJIBY93xPDYYGmVe6YbV2DZ7i+FTsaXoCBMaGNj7HjtrbBjfczEfV2Wgn9T/ulL07GZ3yVlBYGzM6B8BzJR1WbgR0R5ay2gY6UMzvkwHaJLBxneCWlsDOXpQbuxXFa0NwwDlkIrouPGQMMTMFHLiKsStYDktvd1nhJt6OkEoH/bKrojRU3XwjcweXdXKAuUzGQc9ZpWv1N6Bv6xpUexwhm8DoTFbf9xnz0d0MAaW72ua6N/dxlNG/Ox26V6qJjyeeolHp/LpsndZBhWhiIKpxQajMcynXqT7/ilnod984cai6fA20SuLAtVKi2CI3sXRBxJsAmr92ZQJFZGyi1Pde8A2FWeD5xU/RzBJCwFlGAQN1sTLcVDfis7ZLg7FLY4L+t6WVmWVriAz2gxwLl97RNIucPCU3uBj6PaMYmqGTZQoGkuBicLy9j+OO4+5RSbolUEq+xz4qW8w6ymArxFOxQlGRz06bZNx4IasdziBSKiVwc6dvRWbE+yX1/Yl00kLtoe2A5R1mKTi3Tut8pU2PKPmOjOPsD4IwiW7LnmR+tDO4IZPczs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8fd477-c461-4630-aed0-08dd2fc38776
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 09:04:59.6727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AW4EH+M8Bbcj+fLvso3QQnrzwEYtngKLBMT7swSnY2warW/iZrrkdDWPQHseA9Lg/L/DKE1pYPAzlK4yF624Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6264
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-08_01,2025-01-06_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501080073
X-Proofpoint-GUID: xGeKUxRW41OIJay4gGO4UIP4MnohnSgo
X-Proofpoint-ORIG-GUID: xGeKUxRW41OIJay4gGO4UIP4MnohnSgo

On 07/01/2025 01:02, Mike Christie wrote:
> scsi_check_passthrough is always called

...upon completion?

>, but it doesn't check for if a

doesn't properly check

> command completed successfully. As a result, if a command was successful
> and the caller used SCMD_FAILURE_RESULT_ANY to indicate what failures it
> wanted to retry, we will end up retrying the command. This will cause
> delays during device discovery because of the command being sent multiple
> times. For some USB devices it can also cause the wrong device size to be
> used.
> 
> This patch adds a check for if the command was successful. If it is we
> return immediately instead of trying to match a failure.
> 
> Fixes: 994724e6b3f0 ("scsi: core: Allow passthrough to request midlayer retries")
> Reported-by: Kris Karas <bugs-a21@moonlit-rail.com>
> Closes: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=219652__;!!ACWV5N9M2RV99hQ!Lvd5QQ8J-3Z1AIBugQywYdRmGcEJdIffF6RBkszOroX8uqGBwmdS0ggKuA7mclKJvk3Cq38QEoOMDRqX3BZ4IOqpAb9Frw$
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> 
> ---
>   drivers/scsi/scsi_lib.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index adee6f60c966..0cc6a0f77b09 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -210,6 +210,9 @@ static int scsi_check_passthrough(struct scsi_cmnd *scmd,
>   	struct scsi_sense_hdr sshdr;
>   	enum sam_status status;
>   
> +	if (!scmd->result)

this could be combined into the !failures check to have a single return, 
but that's personal coding preference.

> +		return 0;

Would it be messy to drop the separate SCMD_FAILURE_RESULT_ANY check at 
the start of the for loop and include that check in the individual 
result status and host byte checks? In that way we would not have the 
separate !scmd->result check, introduced here. I guess that it would (be 
messy).

Regardless of comments:

Reviewed-by: John Garry <john.g.garry@oracle.com>

