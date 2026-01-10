Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7EE21B9D2
	for <linux-scsi@vger.kernel.org>; Sat, 10 Jan 2026 08:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768032079; cv=fail; b=AGhes3yCdmnCDiVOLCPi4WV6z7cG/K8DX9I1sMdD6VDv3pcg0a+SynW8a/3v4HZu4zESVo9EUvehACKoItgMaW4Dg96gjYl7sNyBn3lxCj+WyWy8yyFbWb5eptqgMh6rcIIG/8Cv/etHY9Ti3sLh1pXtFoMLOK5ISfEvhX+gsO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768032079; c=relaxed/simple;
	bh=bnEnqeXYy0Rvuds6YhVaVzYdxgYwqWHRm64S4tTclKM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ur2xflhRkdcmFSg7nuyCEINAHxJ2Fb4wpqUaLOcNB2WX/+kPNwogj6EwFX3VnQaDV1G+8AAYoGXQ25/TPr9ikY6iNDeX8LseKt2ko50LnSXEtH0Ohu9u4CBUDozyQNzrUIKdGfW1ys5Wj6v8CU4Bd0F1iwbCRkex3aJDzjBKhxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LfUF524d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hBHZJS5C; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LfUF524d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hBHZJS5C"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60A7xnG9341182;
	Sat, 10 Jan 2026 08:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=oiDljysAuwQEjWKG5P8bY6hs90ut6kb8wMTii5pa1UU=; b=
	LfUF524d+/hFWzuQlNXIXeU0yMFYCNgZ6W9BMv5YnSmCUTDayyePfl8npDhCRPSE
	C8hAYtAfet2patf9+4eVsI8KTQrHHvRjDuVaq4n2sBboElIj8CF2mWEIGcTDGGPk
	CgrUC3jfHEx9kGmBsECK6ksFx9L5ZTEfaJEDoYDZ6HStzL6w9wtshEwf0BIS6Psw
	JJULARli2rd9Ts9gFYb558FVXowBYyTV2P9v5G6FHeM2eIlWkmsEAJYlZbpy3Nr4
	8inlctfeAOCD50TaF8hO16bfH6RKhlPBmtT8b/p4DD63Hd+40rfEGBWd1NPOaLQk
	zD0gyZqUO2tCRjHWLWVULg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkjqg003w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 10 Jan 2026 08:01:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60A71uN1029143;
	Sat, 10 Jan 2026 08:01:08 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012027.outbound.protection.outlook.com [52.101.43.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fnrhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 10 Jan 2026 08:01:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iaFJZPH6jPrOeOgGwhvYj69LJKXE0x11RjBIquoPb2XphBBg7FwKSo7WCZLeoAKqNGpNPOW6r8gRbsnfKl6485+spB/EBvEPzOXHg8jx/hK+pIQhVJQtxwK6M9cuXihFvd/HbD6LfvaICfqfBf4J1vls5kQc+dZXDumFTFCOyBx8OrQ07nEkOXskxKHT/2DGE51w94P1adp9jMnFQLrNcu1h13YZE5vVp6t2expflLTnorq1IVeU4LY7YpWWyOwxexUiUXb6vHzObf0gDptdYyGNyEJzePz0KFZCeXxtXfTmkFG/4+V4EUI1zx12Ni1VfW8yTnzLG3P3uAMI3S6zZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oiDljysAuwQEjWKG5P8bY6hs90ut6kb8wMTii5pa1UU=;
 b=hfO72yS1oVCyw0SCWl1hOKUJukQ8truB+u9CTr9azmTqkUnkDJ9ZymmlSeDoTEikBuWaG0EwcH78JRzWvWCGl+uwoeuS5XUbX3Z4OvJYDuEaB/7+0XKv3KMpc7Zgq3dt3cZ9Xjlmz+n3D23AnNOYpRNV8UPY+6JaRT/FkNRRUBDWfFZ0eRHIt73q15GAyWaPLGxRUsdepuBaHfI5XzZlEqbF4XSszS3bZ7LYtwDpfqxXiPAZcmrPe+7BaTX+DVISBSX5KX7KqRRoY8kKEoUNWnBlnihmRnVbNhShmIYn4BZztYk3Kc0wXZS1w+DH3IjQysiY4gfdVk0MLaU7ZCFjYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oiDljysAuwQEjWKG5P8bY6hs90ut6kb8wMTii5pa1UU=;
 b=hBHZJS5Cmb155D0uMOMvyXGaTavHzUu0RLPlE0TFQPSS6w3Nb5Ls3EAO7HLfPx0T32/aM6lFz8ngn7P/ybdrsc+RMWvOoH8/AClbuhfRvkEQz8RTCNMNsq4sbhEl+Irf43eJOfhWcoUVFcT15Se7JsOfW6JQ80vrPscWnofvpcM=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by IA1PR10MB7115.namprd10.prod.outlook.com
 (2603:10b6:208:3f4::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Sat, 10 Jan
 2026 08:01:04 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9499.004; Sat, 10 Jan 2026
 08:01:04 +0000
Message-ID: <c0cea8b0-d54e-4c9b-9aa0-10f8504d1669@oracle.com>
Date: Sat, 10 Jan 2026 08:01:00 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: core: Revert "Fix a regression triggered by
 scsi_host_busy()"
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260109205104.496478-1-bvanassche@acm.org>
 <20260109205104.496478-3-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260109205104.496478-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0017.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::29) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|IA1PR10MB7115:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ce0077b-6ed4-4da8-74c7-08de501e6713
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cVZpL2NtR2VpSnZYb0dVZS9RQisrdFlKRVU4NGRRNVMwMlIxN3ZmVUpZb0p0?=
 =?utf-8?B?UWxVaStwSFF0WU1JalBWYUpiN1lnL0kzUVhGUDFJQ3V5UUR0cTB4dXN0NStq?=
 =?utf-8?B?VmJTTllvWjNtR2N3N1AvZWpkbHo2eTYyS1NsUVZFKzFzYllBaXZqZjU5Q0Ni?=
 =?utf-8?B?ZUh4K3lwVnI2NnVaL3NsK2IydnR3QWJSRjdFS2JEMm1md2xISXp1ZkpQZm5k?=
 =?utf-8?B?dVRHR3FNU1VPNlUyMDViTkZKajVoY1lUQVZVRmsvczQrYkpoQ0JMbW1kQVJk?=
 =?utf-8?B?MjlwTnZ3empQYTFVZHppSmovL3hQTkZCWnMvSWdKSW15V1JaMEFjbDlkdlM0?=
 =?utf-8?B?MWpCSFVGQzF4OFdWdXVPazJ5RmhEOEtZdGorTFNwMGljdGs1UzJhUi9aMWgy?=
 =?utf-8?B?ZkhmempKUlBTUWI1cElQWTRMK0JMOHloNlpycFlyb3NRUkYzeGI1aTVCRjV2?=
 =?utf-8?B?WDBRa250SksyeDBmdThwbFphcmtRQXB2a3NXTWFQdlpYZmljNkNiWHg1UXo3?=
 =?utf-8?B?eGlGaDJsUnpBM1pvbkdGamtnQWsxWlJNTnZWZlZRRkVPcVZEc1FaemsxLzF5?=
 =?utf-8?B?S081Sk5iRUE5bHdwRzNaNENEdWRvRWpQUDU1VTNZcVZYSG9BWmRlTmtzTlFU?=
 =?utf-8?B?MzZCUGJyUTR1L0hDRlNmZUJQblU1M0haSVlRNTdOQUNGamM2dElNRDVXd1BC?=
 =?utf-8?B?dUROWWZtU05mVnAwZk9vcDZKSTdKTkZVNDYyVVl1MnRXaHF0SVRmRkJ5dFN4?=
 =?utf-8?B?SEFVZSt2bFFuM29XVnRkN051STd0MW41YmI2ZmxhTlROMHQvM3BhbTN0VlVE?=
 =?utf-8?B?RnltRERrUDRpTWNieE5xdC9aTUEvdXd1ME5CamNmekY3Z2FXdzZEWml1a3gy?=
 =?utf-8?B?QzcvRnJMZmxpUTk1bjdad1ZoZXJKSHltRGRXYXlzNllHUlpFcEJOUER5blQx?=
 =?utf-8?B?Sk54clE3Y3FtbTdBanZCaGJrZDlIUlBkcnE3K0UzU2lEbllZQ2FNNTNpSkc5?=
 =?utf-8?B?Tk9leGUyc05ubitGRE5HRUJNSDdTTEY0Z213V0M2cnZvZHVRMVVFR0s4TGlr?=
 =?utf-8?B?alFwMjdBQkZYdmlseGY4NUNSd3RCV1J5cm9mR3hzN2J1MUJXVWRwMitvNExJ?=
 =?utf-8?B?QkZTR2I0OHZYNTg4WVhzRFNpWjRNV1ZzbTB0RWd1RjdIMXR1TCsxam9TMnJ0?=
 =?utf-8?B?c21SS0xnUkZRY0NORHJaQ2tlY2ZsNGJPSWpoZzJwT0ltTVJ4UjBUbzU4Zlcw?=
 =?utf-8?B?aVJ1NmcrdWRjNmVvMXNpOUt0cVdkK3E5STluMmZxK01CQkpWdU1zN1lnUi9U?=
 =?utf-8?B?aTg1MEl1Z1Zma0g5cWlTaUFpWDRvaGpsZldiNkRQSVRQZ2wvVWc1clh3U1c1?=
 =?utf-8?B?TEpwTlFFOXZHd1ZYMzNnZ3ZJc1JrUmFFTTJLUjZicnNQTURyb20xb3dHMlg4?=
 =?utf-8?B?WlF6K0hKNmwxczN1Qk5GRVRmQy9VNXN6Z0lYdXZlWlgwM3QrcVplTE9rR3Vp?=
 =?utf-8?B?RzUyRWlCNVRoaENrSWRVbWJlMUNnR3pzcjJ5Vzh5alAyb01GWEtYQitRTG1j?=
 =?utf-8?B?VzlhbmdIcjlnUzNiL1RKZ2x3NUVRck56VXdpZi96WGFBQzZWVWJqM3Vob3l2?=
 =?utf-8?B?a0wvTFl4Tzh4dS9HMXdubkRJa1NHazBxYUFYbVpmODFxcHNuKy9LTlo2SExo?=
 =?utf-8?B?a2hlczBHWEw0NGVlY0xrczZaZG44Q04wamw4NDhFdnZHbFA3Vmw5c0hTSkFn?=
 =?utf-8?B?SCtoUTR1MEdSemFVV2xrLzJFeGpyNnNTeEJwWkUxN2JsS1R5VU85dmJVWUM0?=
 =?utf-8?B?MXIwQ1JMN0dPZU00Zkx1dGFpR01YOTEvcmwvbmNESWFKbityWEVxM0FpRXA2?=
 =?utf-8?B?V0lnK29WWDhlU3gxQ2M3SFV2TUVCVDViMGsrSi9GcVpwNmhhUmZmWFlTYVZL?=
 =?utf-8?Q?0GPbc5mGiDfU4WVPrl+vKZumZTKdYLaz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MkRnNVN4elhvdUYwYTMyM2FHS2NlRDNVQS9Hbzdab1hhcUhPTUpZcWVjNUp0?=
 =?utf-8?B?WmhYNndScHpHTkZsSExkendSQXUwZC9rRXZNZjVTbDB0ZHJRdXFaY2cycmhC?=
 =?utf-8?B?Yi9EKys0QkZuYWMxQklrR0pKU3RRalpaUjQvaDRySW1XbHJtZVlwdGpNWkIw?=
 =?utf-8?B?ekVHcjRtMEkwVHNSeXJ3QU1nRHREQ2pEOTZWN2Z2eXltS2hLbHFqZXlxQXk2?=
 =?utf-8?B?YjFSMXdFdVdjekFwWW9MYUlUYkdaQitKRGMxL0xIRVVuSE5FSW51V0dFSGFq?=
 =?utf-8?B?aVJSaFQwZVBuV21tNnVoVi9hZkd1dFhWRkNrbVI5RDAzRlgwcmVXcnE3NW9O?=
 =?utf-8?B?eFF3QmZ3NFQ2Z2hjeUQxdkcrSS9YeUlURTlxeW83Y295RXpwNDgxVkFWTHE4?=
 =?utf-8?B?V0JqVHJteEFZR1FSOXgweGVJYVd6UTlOUlRMNEJTNVA0VW85RWY4R3pQMEQw?=
 =?utf-8?B?RmY0a080RExIN3VKQWxHK2hjNnFGRzhpTjZXbG5rRnV4enRHSUlocmZGTXBn?=
 =?utf-8?B?UngzN1JtVEZCSkNqZjhWWXhsQXFlRWxvTmJvdHZ1WnpTMENkT0hacVpvRGtY?=
 =?utf-8?B?cmFVc0xYK3M3SWNvOW5VTkdrMDJlZWxuR0hpbkxrMXYrR1JsblBVOXNaZk90?=
 =?utf-8?B?WjRMRlRHZG91cU9XMEF4QnQ0WHZybmJFUEhRNjJqcGN1Y0lDQlhCNnRQWi9Z?=
 =?utf-8?B?VVpmdkphNXdXK2p0aVBTZFFsbklxMjBRdXBCMnMrQThHazlQYy9RK0I0UFV1?=
 =?utf-8?B?V2Z0cHZieEFwLzdLTkJaeDRLLzdyNTJ5Z251TFArd3hVcTRqWUd3Q2FuR3NP?=
 =?utf-8?B?Ukt5ZGZVcTEyS1pzT2NXSUZrOG9DUytwdFNVMmJ4U0RhM05kNHFqeHdRRWZk?=
 =?utf-8?B?Q1dIV1FnemFwb0pSRGNzaXI3NDlmbk42VlR5WWg2RUhVQ2hNeXBhSCt0MFg0?=
 =?utf-8?B?N0VIRG8vcUpQRk04WnM0ZG1xOE85N2RwUEJXdTBSV0FDTzdiOUNtNytoQWly?=
 =?utf-8?B?U1dOSEl6dDZENGk0V2tDSUpjTUhmQ0w0WWxBRXMxbTNuRzlweWpjcUl0MGdT?=
 =?utf-8?B?V3dyY1QwR1NSR2RxZUJxYXlMTU96ODZxeUlkdllOOHNYVk1CcUpLakJoL2Nv?=
 =?utf-8?B?cksvTThrcTFVSmlBUTFQbVE0L0RoaHZBbnYyYysrQTVCUUoydWk4dmJ0bDhr?=
 =?utf-8?B?SlZWcDUwRlhzRlh6ZERKZUg2ODJMR2xCbkRuNHVUUnovdE85UGRyVDlndEov?=
 =?utf-8?B?L2p6TFR4b2NkazNCRnNURlhKZ1I4ZEl5ZTlPcXd5VXI2RUZGb2N0c0l4UENO?=
 =?utf-8?B?QWovRW9oaFZBVzhnZFBRYmphZit2NTVELzBmTEFpREVTamJPZnVqcDRiNUhi?=
 =?utf-8?B?N0RmKzUvbEk5c3JGZktOR2RZRXc3VGNCc1ZLWUxDem9rYTVCUllwM0M1STYx?=
 =?utf-8?B?am9FQ3dXSVczSEZVa2dSNFV1bGVRV0swTmVLYjZ0Tk9zYkZoZVBSTWhMS0k1?=
 =?utf-8?B?MG5XUElZUFlmekJYeWRVTnZNUkdmOVBtOWVSS012QlZaMjBNUGV2M21veWFB?=
 =?utf-8?B?UjhxTmZ3dnZkVkdjMjgzME1MMjROZWhMM3JUUU8zVmd2eEpIWHN2SldYdXRx?=
 =?utf-8?B?TlBLN3c2dFFLN3FFQ1BYNGJhcS9lK21SMUd2MmF0RmE2dUlNMkpoaVJiU0U1?=
 =?utf-8?B?RjJnTlduR1lxQ3FmZnR1ajlDV2k1bGpNbEI2Wm1VZkJ3YnJFdWpneGU2cmNz?=
 =?utf-8?B?cDZ5eFpOSnpzb1FPZXZ5UlhIeEt2V3V0SlRRR2NJQUpEN0JNQlFiNXJoejBh?=
 =?utf-8?B?K3RhZjhta29ZejF1SEN3WStiTzYwbG43WEhQUXJ2M2hmRCtWZGNnZUh3Mzlr?=
 =?utf-8?B?U0JVdWNWSFArdXRsT0J0c285Z0ZMdSt6Um5sWGpwK0NvKzU4Sk9nZ0lwUVEr?=
 =?utf-8?B?Z1BqcExDNW04QmpQbTM4ak1vcEdHVDVtNUZGWHE3eE4wRDlVMXlwTWZuSkVQ?=
 =?utf-8?B?Vm1RVjRXVmhobSsyaGxSRWt3bEQrUE9KN1RTTG5OczJSYVJzbUVMR0dNL2ZZ?=
 =?utf-8?B?dUl0MHVlWTBsd25CUmJNeEhKcFdqdkZRVm1sU0xXNThUZFoyMFNrd2N3N2NT?=
 =?utf-8?B?Y0FzaUEwT0VpUlA1S1hmS2VTZGlhRmowTEtPd1p5Szhoa1QzR2FiQVgwYTd0?=
 =?utf-8?B?YlhibTdGL202U1AwL2tLRXZhU1ZRK1hsVVVCZVF3R3d2bjZCeml0NkZVVzdD?=
 =?utf-8?B?SWtTejV5RG9OQlB0UG9FU1VaUkVDS2JkQmxXUXExczNhSXdXUHFDRUV6bUI0?=
 =?utf-8?B?VXpURWUrZ1ZpcUhidllRcVlxa2l4N3lzd1VoV00zMENBNysvSU0yVXdCUFpE?=
 =?utf-8?Q?bq9Jg0BNc5tsq9CA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FSABswXeqIOxih0OgQWsNUupGKDL8DrNmxdTzkXXQQGsriSFxEqBTyaTdOfdhIZ501D2vut7w4QhyF1zBGM+bvFUoCs5XcbJ9aZZaVWkxgfis6MxNHFkNwjrbaIxUN47+fzg6p64EXRCLyHrGIwN5C052x5lTtvt1yzNqiycXqHZ4W/+KLHZoiP9xWC0tW8lDnpjGhjrGqUhEEPUYlK/Hs41LxOv4qJv7Zruio1rBiruGF0LEi7v9vRKIrBS6wxJJ9HA9M6Kei0cmwTad1V5Yuds2fPt7ug8+8atZClSfF+TsY0cVBYVVrplu8LZZtMnZcsmcrJRUBEv0x3eTJUvpVXGVxrtjobEUYJtmkiilQH3UOLKzpgN3d0L15C7i67g8Qi5kRMB07APdSyKN8G5VRySPjBxuuhzXG60siTjnQBBiq5WOcBqd58is6F96Mm2P7P1NUlg0jxkqb+8twH67/0PS4pjo0r7Gl7VM44Wf/HeDiW7wmv+XIj4IKw4YNx0ApDgN9czA6jgjdl/elIXCNyXzDiByy8UNemxL3M6y69R26Rs7kdqrq22p2VZ5EiH3ztXnOQeWmPe2MnXnYwGh2CFJFx6W2viH78A3tNwB8c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ce0077b-6ed4-4da8-74c7-08de501e6713
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2026 08:01:04.4259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BFhfp8SpcEAuyag63sU3Os33PIpD3yrboZkXPgZ2JEq1GEJUxIhC6O1Jc3DjrlddrFCBZQeNuRiOxsSkEV25kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-10_02,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601100065
X-Proofpoint-ORIG-GUID: l2y8TtjQLkrXjLTgyPSE8w21NsFMvIrQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEwMDA2NiBTYWx0ZWRfXxZnwfeWlXDJi
 Om9qbl+yBv9jhA67rJcqgH5CwPRUQsrM3aqmJk8NBx0swX0bmkN1c1+nzbAVKD5Xw6S1tGeCVeS
 U/09WUieHP3311eaMQogNjAy5lPcQZreH3lbPp16RdL2I+UGPv/nOa8RSTJaKFQgcmQe5zjlaOW
 v41Jxwt2sYSMjTyRyVF7Hij6PSX56tTj9qnHrf0+sc5kGBfXxO3uDdPTHh2jQcajL6cwhZqFVmX
 Q2g5nJhV+60KM0A7XAuXn3TTtqIu2v412L1bX23I7zhH+ZNefeYbD6SJdyic0YKgjETiDTP8OAq
 TREBqHmXe1udv4HPIKzihsZqLWZu6O793m1eKiCYjVAyoBwTC20mzxjASwuvJD10A1AmgZGWhp3
 S14iNjCDQSrEJglsLgRrkrEj88oNY1yO320lDyZ5TWjIoKjcluKK6fNmpa9PjOuS3D1EDyXTCZk
 smBg/YxT/2K6dpcjxncu0X1OXvSzQnY0wr6mY2lk=
X-Authority-Analysis: v=2.4 cv=D6NK6/Rj c=1 sm=1 tr=0 ts=69620745 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=N54-gffFAAAA:8 a=yPCof4ZbAAAA:8 a=0abX6kX93VBHWdR4D58A:9 a=QEXdDO2ut3YA:10
 cc=ntf awl=host:12109
X-Proofpoint-GUID: l2y8TtjQLkrXjLTgyPSE8w21NsFMvIrQ

On 09/01/2026 20:51, Bart Van Assche wrote:
> Revert commit a0b7780602b1 ("scsi: core: Fix a regression triggered by
> scsi_host_busy()") because all scsi_host_busy() calls now happen after
> the corresponding SCSI host has been added.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

thanks

Reviewed-by: John Garry <john.g.garry@oracle.com>


> ---
>   drivers/scsi/hosts.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 196479cbfe6e..4d17f242d191 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -626,9 +626,8 @@ int scsi_host_busy(struct Scsi_Host *shost)
>   {
>   	int cnt = 0;
>   
> -	if (shost->tag_set.ops)
> -		blk_mq_tagset_busy_iter(&shost->tag_set,
> -					scsi_host_check_in_flight, &cnt);
> +	blk_mq_tagset_busy_iter(&shost->tag_set,
> +				scsi_host_check_in_flight, &cnt);
>   	return cnt;
>   }
>   EXPORT_SYMBOL(scsi_host_busy);
> 

