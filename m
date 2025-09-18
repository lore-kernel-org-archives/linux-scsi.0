Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B23D2D94AC
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 07:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758180632; cv=fail; b=IXp1hEljZvU/OuWWWxmpqNpXK75rJ4XGC+BL1REWPucSo7yogmSXoR7MVqGGvFYhVRVSEFVXbnX2VdASIchoDnU5aT9DO33IkC0iGBTnnjHXmT/N72F8l07Tb/vEqb8sQBz/sL58DED+atit14eF5eJf9OXz3OCaLvSwJFlzl+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758180632; c=relaxed/simple;
	bh=0UumZrFjkfX1LVlEU5fyrEKCGvderngBZqqVt5IukNY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KpdK7xWAWAZtEQglJq1X6bEoJTGLUzFqLN4IX+jLorPSNq3L2zDdGMYC2pGnmMAGY+uZYHEPDF9o7kLto0b1J74uUDjzjHOfqUOifkcBllEmafy/SfD7aR+34e879AE6yb2Kl18Qpgrcf+p7CUgVU0KArrKw1Jn64GC+eXi03jg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JIy5z67b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b9UZuEBe; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JIy5z67b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b9UZuEBe"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HMx1pi008351;
	Thu, 18 Sep 2025 07:30:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qe2dJR+Qk7Hg6uefIoH08kObLyJjYBXkgdi9MbOnjOQ=; b=
	JIy5z67b42jKGIwGzWolEQ4r2CTCUIbHPs1npL43m8AOjDgWgTScE4q9HtStf+Yr
	Nd7XWbVdMOYtO/766w+hqMUSu17vFNYCKRXTwcp7067T41a726SFD2ds3oKfPj6U
	DVLkEHhOX/GetdNF6kCjPkBItLnl7hDw4pWYwqzzI/BnspwPA34SldYyO8uLDsKL
	s9I1yLcYmEdYlUGkRd4hZWs7PWKkpprM0oSLNnVXM+gv7REcDpgivN0QgF6W97PB
	wQy7MohyYMLSWZYzgKwN7LzynY8a3sugZG7DHVrkF4s7g4mZk/FVzZsI/6w/teH3
	LiZD6sSGU6BJD972Nk21YQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx8js2n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 07:30:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I78XcA028797;
	Thu, 18 Sep 2025 07:30:23 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011053.outbound.protection.outlook.com [40.107.208.53])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2er74v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 07:30:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l9dfJ/Vn1DGQvlC2bit3oW8E9Rav39Gqiy7kfRGzWC5g2nk5Kys3bkNi9Igmt6O5KCNEjBjpgq7ZuGXluXr2LXTmAyMMt+qpMlRwmBzzt8m1SIhMqA1xV1Y8b0ub6P37Or05fO8T3r5YmgWYNsK6SqWWt7dCRJPog0GYHdOT/JQ+JuKJwHPA4uhBdHv4W5/gXAB+w51WJm1V5T5jIUncwmmzbE+27GO534DpYglblsuYqDkT52f17hKCmt31DxdjJqBxo//NjczvIWYJov5pbai2lzS3UI1Lu5MDheVerzYVJCJy5cA87I7GT+5oCRoGufxzhmsUk2LlcpxX33ss7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qe2dJR+Qk7Hg6uefIoH08kObLyJjYBXkgdi9MbOnjOQ=;
 b=xSc9TG1zOuGhpyh6CGwGPkJhHytRiRuqt8J8G6gJnsnoVMHvhI1EFgoeapEB8LuF2orCJNKl+9BIcKpqvr8ZzkpOab6jrNiQx8DFw2MtCMGAJSRgT9tdiUWp+Dh/BCf2CSWWg4Paywb2HSH3Z7jEoqoIlJgCBAP5jMlcE/zIdos3wmszjvnuDUyXy+Cr11uva5C6WCNW19U+hfB9AIoCI8xdnUnL2laqRnusQVSZwJTlO3FxEhA3dEJoCPBdWoyclBGh+gz+Q7dY+OeuRU0mnaqX7UXUWhEqvjK58K1Qsr8EVtBNz1Xkd0Ayp731bX7ogT9kuRWVOERpXb4+JSObwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qe2dJR+Qk7Hg6uefIoH08kObLyJjYBXkgdi9MbOnjOQ=;
 b=b9UZuEBe1OUcRpL+BA8z4Lqr6zOcGSKwmY9WTaKZWZeGL2/c2zg44G51KcEa2hK1ovDfYjyF/9IAcla2CGU2nAgtKuoFlixLObcipYBXKwKps3UgZlQV3mYzG9iR+gYDt68WAG+hK2Z0D4ooMCphL+MLpHnZ3nKoKeNrToLlRDw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB7720.namprd10.prod.outlook.com (2603:10b6:510:2fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 07:30:21 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 07:30:20 +0000
Message-ID: <c05defa8-604d-4885-8022-f696517b5bc2@oracle.com>
Date: Thu, 18 Sep 2025 08:30:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/29] scsi_debug: Allocate a pseudo SCSI device
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-8-bvanassche@acm.org>
 <75018e17-4dea-4e1b-8c92-7a224a1e13b9@oracle.com>
 <6e3206c3-e9b4-44de-b5f5-6a6312013f7e@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <6e3206c3-e9b4-44de-b5f5-6a6312013f7e@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0271.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37a::7) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB7720:EE_
X-MS-Office365-Filtering-Correlation-Id: 881e2754-aa08-4d6f-f0af-08ddf685391b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlduWWJ3b3FtUWxQL25ONUdNQmpZSjFIVk9mSXl0MDF3MEJRQm45c3BQZEcr?=
 =?utf-8?B?azA3by8ySDhaMkt6Y3FmeHNyT0RBZE9ZQXpWcXRLZi9HVGdWbDkxMTBCWmQy?=
 =?utf-8?B?enF2WjYwcEgzRkhhOGNMTmJNMlpYbU1EM1RNdFQ0bHk0enRreGhWOHlRdnFD?=
 =?utf-8?B?TXliVXVQUkVGUnBZU0hkLzVVK3l1akN5SU9OYzh4K2RQYUEwZ2pqWEdmazhS?=
 =?utf-8?B?ZTlINjFsa0FJNkRvMHV6MmdBNGhnSUh1TWJYV2drZUE4WnpzME5EOXRsUno4?=
 =?utf-8?B?bW9jMFowandEMmMvTzBIRHMxMDg3Y3grTFMvRWJhVXpWTklMRWxSOGhsMzky?=
 =?utf-8?B?cXVURnBtWS82Tm0wQmsrMVFJVHd1TkJTU3p3YUZQalloaWxuYXRlaFNPdE1v?=
 =?utf-8?B?ZkNuMEh3RklZWm95ZU0zWTVTN040TnZRWkZuRHgwYld2MzFUNDdQSDNORXNz?=
 =?utf-8?B?cnAxSWZMdE5la0RJdDZHTXVDdWhTcDFUMVRJSWRvdS83cngwWTFsUEszT2ln?=
 =?utf-8?B?Unp4dmJuTmdHVWdWeCtKQXRZRXg3U251aGpZMm1hcncxUUxIVTMwYkh4VGlr?=
 =?utf-8?B?UU5xTzN6bXFSSGJDRE9rUFdxc05hSkVwMURKNmRPb2RMQkpUNzM2YWg1bHVM?=
 =?utf-8?B?cHNvbWxHa0ZLOHB4T2pCZTllV1cxbzNmamFja0ZYQWRuSmQ5Qk00b2tPd1Mv?=
 =?utf-8?B?a3gyM2NFV3NtUnM5VWNqdnVKOVZSQUVPcVdyOTBSUXdXY3JETDlkZGFvblNZ?=
 =?utf-8?B?bHU1bHVvVzU1b2ZPT1RIZDdnbC9lY3d3RHBQRk5lOURjSU1lV0Zya00zdzFY?=
 =?utf-8?B?VHVhR1p0UE5BbkZQR1JTWDFPcFpvMTE0M01ITVpHMjNySU1LTEFnelJxWFMx?=
 =?utf-8?B?T0pIaFlmb0ZXRXhSdmhHcTgzbnlJSTFGdG1FRjJvQlM2Q3lHOWIwYkIxRXUy?=
 =?utf-8?B?dzZSQktDN01LZFB4R0NBSVpDU090VzI0c2FxaGFSQWVNYlBvUEErY2RSRU05?=
 =?utf-8?B?eDcrZm5mazZnaVEyTmRnTEdxTVhsZmtnNXFMOWxSV2dWRWZTM2ltT1hsVjZy?=
 =?utf-8?B?amdHVUluOTBBZVY3TlFQTHcrZk0xNkhXT2wwNlNyS3dBMUhVRTJlMEkrS0V5?=
 =?utf-8?B?YUVLWWFVQStNY1lyelRRV3pHWHZaTDNuZENCbE8yKytpYXdzZGdKbHRJTEh2?=
 =?utf-8?B?MlNJS1hMYmhaUWQ4NDduUkhRR0hQR0luSG1mL1dkZWdVMnRlYlNZT3hUcUV3?=
 =?utf-8?B?K0FIa2xtZTNUNFpJZnU5OWtuK25ldGRHVmlNckFwYlhaWnVDaVY4RGNSWmwy?=
 =?utf-8?B?TEJTeW1BdG5rMEpnU0FnMXJYTTAwS3ZKK3J1OGpxOWNjYWN2ZFhnK3hSN2JL?=
 =?utf-8?B?NUh3SnVnZGpYUVJHK25POTVqTndkaHd5cFZxdXJGSUxRWDFiL1JwMnNCQU9V?=
 =?utf-8?B?SnI1VmZrZjVpS2wrTnBQdHNOaGZnUGdaTHhBcVBGd0U2ZEx5ZW5mdG9kQ09Y?=
 =?utf-8?B?ZWdBQkpBUWhPQUZIRFZRUm1EVzlFSHVpSmZId2hidG9uZ3lVaVh0UHBGcm1j?=
 =?utf-8?B?YW9UUnIwdGJEU3hsN0NZcGFmSG5DSUVjVmxBN3pCRk8yOUZQTHA3TkxnS1M2?=
 =?utf-8?B?YlRET3ZQVCtHYUVPZ0VzaGFJYllNVHpGQVI0bEVYeW0vZFd6R1NtZ1k1bDZY?=
 =?utf-8?B?TWVibVFWdTEzUEFLMm9DS1paL1A2MXZkNkxLYXJOWnJUTEVWRnRIVHRlb0dV?=
 =?utf-8?B?ZGpZREh6QVJMaVNiMkhSa24rK0xzR0hReVZ5VWhHMWxRZ0RBd09zeXNxZk8v?=
 =?utf-8?B?WTBpcFN5b2taeEtLYzltYnNnZ0dLMW5YUm9NZGJaRlNQOStpZ3ROa2h0RWIv?=
 =?utf-8?B?WXFYRUwzOEtaU1VPSmRUb3JGTmhXOFlrWWJKbTJVaVJzUSs1MWpmd3JzMlpQ?=
 =?utf-8?Q?8twXeIylGnE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlNPMGpacGZjb2I5YlNJamZjMGdYNHF0bUE1eXk1bkZCZ1JYdVZXK2E5OEFu?=
 =?utf-8?B?bmRmTm1naVNlbDNudzRZblVFZTNOVk1sQmc4OG5NQmkyY2hjVjJQcktnbnBw?=
 =?utf-8?B?WFByYlh4NEZxbVZUaE1lR1BCeVFyUHJ2THBrRmQ4ZFdvKzlWelNCK3hlMUsx?=
 =?utf-8?B?NGUwZWw1VXpwbW1qQi81V3JXS1NaZTBidE1wUnd6THZIS1hrWmhhcEN6SU9U?=
 =?utf-8?B?MGt2NU1qTDhheWdLTEVTRGFOazZEYlVxSkM3M3RleVhjdzdlejNYbkFqejgy?=
 =?utf-8?B?M2RMUFo4U1BTYUhNT0NkV1M5N2szTmJRQis2UWJ5d1pBTTVBNVNWN0U4MHNN?=
 =?utf-8?B?ZTJTL24zWjdCS1NRclJweUsrZ2JKU0RlRll4S1orajAwMEJqYThsMWFVUzVu?=
 =?utf-8?B?RCtBcU8vNHBBUjJoUEdhakUraHVJQ1JjWm1TQ0tMWFJjaEtHY1RZQXBlZm9r?=
 =?utf-8?B?TFhEc0RKTVgzYTVsSVR6aHZKUjg3Y1ZQT2IzT25SVnlGc0owaGJNN1ppa1ZB?=
 =?utf-8?B?akh0OGZyMXhGV1pIdHpMM3cyM0xOUU8xclRtcEZUQVNaWkk1YU4ybzFvZHo1?=
 =?utf-8?B?cW9ZTGlrRFlWeS9xVHJDMDVTbm5JV0VOMFAzMkRMSEhPWUlqcXpRQTBQdHVh?=
 =?utf-8?B?MWJVQ3U4Z0NZRXM3RzR2TzAzL085ZzIzSGs3VXYwbE43VVNYaEx5aTRmOXBD?=
 =?utf-8?B?Z2Zwc0dIbHNhZmpWeDdwbUVuenBaUWc4MXdPd0pMaGs2NmdQcXJjZzdOV0hm?=
 =?utf-8?B?blRRR09waDNQdU1WNURtb0ZIS3ByMitROGg1a20wb0k2MnQ4dW5vakFSMUo0?=
 =?utf-8?B?L3o1L3R3T3FvMTJ5S201eEs5YVJxcHJzaVEveHJNbzNkVG9QT2RuR01aNGFZ?=
 =?utf-8?B?QWQva0ZMdVlKQlR3WjYyZ3V3NWVZSWNZL0d0VUUwM2FmdzBCb3FIUkt3TmtY?=
 =?utf-8?B?bE40MWpDU1RSVGNVa3hWS0pDTTZ5UGZKSEU3aHVlZFRiRlJRMWNyemlCUnd1?=
 =?utf-8?B?S1JMZlE5VThjZGNYVGFLbG91OUhsUnJWblNqRmpjUHhaR1NmbVk5Q0JyVkNp?=
 =?utf-8?B?aGdoa0VUVmxqTGV5ZXNEc1FjVXpNY3JQK1dCU3hudFlVaVhlbElVN0NVSTZ1?=
 =?utf-8?B?M3JzREo2MVN2b003cHFEZFR0U2pCZ3duYkEwcUNPbW04TEhNcnhkYTlRRFdQ?=
 =?utf-8?B?anF1NlBBSXJBcXFpaDlxYmk2MTZpM1BSQWVWVkg5NDV5NndHZ2ovUU53Y050?=
 =?utf-8?B?NEQrRVJDaUMvRjVRaGt6RHpuSWV0RWluL2ozY1lwekg3amRIaGt3dVJZRG5H?=
 =?utf-8?B?Y3FMTk53bmhPUzJjMGNCV0JoUGJ2UnRiS21udWt3L3hEVjFndUVBeFBTOWpV?=
 =?utf-8?B?OVNOVDlyckZNNmpCbDFkS0JtRVBtVEFTZEh4ODMvWngvUzQzeGo5VysyM2Fl?=
 =?utf-8?B?cUFKU1lZRFV1TDd4WlpOSkRqeXhMLzVaR3BDa0Z3NHdzS1htc0F6UEM0ckFK?=
 =?utf-8?B?ZFJMVkhoNjRuVkt2VmJRL3Z6KzhIeEVxRE5YMnhtd21SRHF1a2hnOGdQNzQ5?=
 =?utf-8?B?eFJnUkI5eXViTXhkRmJNaTZqeFE1QTJvY3JFQXU1d3VhU0FITHc5ZkFSOFcy?=
 =?utf-8?B?ajFPTzAwYlZheDR3Wm5LeVJTaHVBUlA0UGFYOEhhYmViVWpibHBRK0pkN0R4?=
 =?utf-8?B?c1lBMFU4VkMyWG1GNjFSMjRpU0dLQjVibnpaYkZ6bDFFNzhLdVpNczFvMUZy?=
 =?utf-8?B?VG51WG5ldXBubzZoOU5jRjJxRGxUanRTUnZydTQ0alB3Q2pFd2VQalc4ZDMr?=
 =?utf-8?B?bmFyR2pvT256N2liWVlJRmtnVU5xRUxmNVpOWURGVllzQ1JML2MzSXN4SUcz?=
 =?utf-8?B?azdBUEl4azdzRkYwYk1NOEh5UERmZ3VwY2Q1b0lDTE1OT3E0Z3kyM1h1SytX?=
 =?utf-8?B?NmRIeUIweUJLSUlUQ0YvYTR6NE91ZnhBWDZUSVBRam04cjZaVUJQMjM0UXk4?=
 =?utf-8?B?QnVDb1c4R0V1YjNlU1hlWVA2NXowSmxTOXE3d2t0RDlLbkNUN1VHMFJmTExj?=
 =?utf-8?B?c0ozakJ2VXFjZmdhSEdHR0xKbndSQ2kzR0pnbHI3ZCtPNDczVjMyOHNmektL?=
 =?utf-8?Q?paQek5kD2TMTuw1iTq0b3p03/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dLskHcWcsIdF09p+h56hw3xXG36sLvoZmkPBokhep+3Xkvav/NzzSluyIeaIcnLsTrbRZzm80VUhT8xfv/t3AnuSGMi5KlHLOkInkwJinn1+DXYmgkrGL8lWpKM75r1gDJahRHKLIsn5RDDzUqol2Lr5BnqGJRQm0k8CjJ03LS9CKbYvgIge3Far4JCa8219oHcdFBKvDuANq1ydolAkL0TMUu5HHcwOWTv1RUHKtvVmyAQ5oYUiJk0xvAhAG4YLqqrh9Q6BFDR3dBB1z8tswlRIU9EHjZx3TRQYcOYn/eBtmq2pIB/MW6BBlUe1P3FO2ADV5ERoIOIddCTjy2cTujmqIOd+y2/DPNNHl40gmtlP7iqrJG+5xTuOTZ62qLukRs6/4ya7yZ1nW15L/uAYoe4JmV3zNWXbyjjeJlIOeL7V7qq5s5qkcX+onVTHRzRlFmUPoqE1iefgqEAlEsWCup4ROKfi6xRYtdKh/Fa0DOcE0djJCZ+Dh+/iu3Ca/fgSZxt4wBq39meC+5UicKpl1BfAoYAVdHQy3RjupIG5xm6aaAuA9KsyC/IjcOwAfpbp/ca/R7Zjdpf0Kn1KJxUzLOOUNrAjwgnXrBiLDyieUc0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 881e2754-aa08-4d6f-f0af-08ddf685391b
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 07:30:20.8613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P69h2IeA78SXg46hvpA8zin3NHl9T1ak4gp90aiMgQ3a/K4CDmO+OS/cLvdHPvUUw7eCURtWlKjY0sSTK2J+GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7720
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180067
X-Authority-Analysis: v=2.4 cv=JNU7s9Kb c=1 sm=1 tr=0 ts=68cbb510 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yFdJI-AkAMJVj5LBpxYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: T3vDWbD6T4DfRB2xg6PCuxbZ4ynhuJhg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX9gbtbL46V6ge
 Qy4UpD4pdVr1akCWEtX/bJ4oiYhTp39QVIYN8IxsVy9Ki8zTMf8KDm7UxfV5YTPOQot//YmAKoi
 70kcS/xNSg5BAlzifO1Q5jSfKNUqegf/+BzN/fCqozZoY+1+4tjGWybGCzNFJ7i5AR27JXQNomx
 cbQwg19nAQx4Vg7uwk2IzY0MRAns2ODpsI6FHR5oM8u86wnmiZ4+7iMUve4kSshxhK3cgoZQyLI
 lX8ee32egxSJBtHGq3laQO7ZDkWyZhKGhaRg+RIPhV23Inin99FrmCiDaUfNzOaZr/etVFAuaXz
 AjOsthz+D3vD//aUgxLY3QUnukUJGIgIosdlQDfC65a/X0JrH3YuITf1mtW3FKjZmTFgFBe7UTT
 TqBdvnwI
X-Proofpoint-GUID: T3vDWbD6T4DfRB2xg6PCuxbZ4ynhuJhg

On 17/09/2025 22:37, Bart Van Assche wrote:
>> Could you consider integrating the following patch into this series? I 
>> think maybe some ideas can be applied to the UFS driver. I made this 
>> change on top of your series. My motivation is that I would like to be 
>> able to test reserved commands handling.
> 
> Thanks for the patch! I will look into combining this patch with "[PATCH
> v4 07/29] scsi_debug: Allocate a pseudo SCSI device" unless if you
> request me to keep this patch as a separate patch.

I think that it only makes sense to combine. Indeed, my change 
essentially overwrites what was in the original patch.

Thanks,
John
