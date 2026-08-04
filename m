Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3C2412C0C
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 19:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785872597; cv=fail; b=H5lsfOGIY6jcTbaK1aIUZ0X2dtG6uBb9hUDWFQxUt5f34A/DG9wrX1MVsB5HghLfCJsOn9wWVKLCSEvlJTn9acfSDbMCPTchr5YJnoalG6M6IvECXWhXfOhsjlyEmyjxhrvCbhvIqLnYoxQVo4MewwZc5ZLIU9qaEleEgfXwut8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785872597; c=relaxed/simple;
	bh=gESufonAfgBlIgouoS9/54xI7IeyfpDCcJ/9vNhPbok=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gC9eWxsHCPalsee2gEQ39A65iX+oGmJiY4B1sl5aLRonitDVKtnKcN+RfYRvFozaX92oQCCnfq130ntyl+QjlIRsuh6fwE6MMoo+sjY3m4evJSb4nhSVV7XsZ9GuX47S5uYEHDItSy6KeeeY7myvE4bm0MQ+wr/16l3+c8zRXQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DyJWKC3W; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cqBbhmTb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DyJWKC3W";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cqBbhmTb"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 674Fu8n72490166;
	Tue, 4 Aug 2026 19:43:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VcposGcnchLswS2HVLVJzrIm3qZYbZLhWLet7fZ6ULk=; b=
	DyJWKC3W4MAoI9bPikI2JQ/3r4+Eqtnfv9yXhC+3O3/L0ZH6+J+rGwatxjn/pepO
	yRpyhI/zu8oIzFpyPS99m41QRVPs0YFRW1u2TsRuo2AtmsHOTuQZm8r7/irM1v3W
	USlZvSy2U5C6qI+8m8mwFMdb44MHqtGRXgkIq5BNrhibfsp+ukOrxiURwcFDLLeB
	uaIkXtxHquSevAiQSIhLfamoTU7OVYfAwIKRO9y/HaCHRt0W74Hytc1q0rBM/wNR
	ojCl1877my4tOWqVO0LA93Jk37qm/4FQmGkFZWxvluOEAW1dlesP6NcYfJE9YcGu
	p9LZc2aGYKmuRyyuD4TpIw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8ugecgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Aug 2026 19:43:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 674JdvKC026519;
	Tue, 4 Aug 2026 19:43:04 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010067.outbound.protection.outlook.com [52.101.85.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftq421c5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 04 Aug 2026 19:43:04 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pE6sZTxmho/6ve+N+rgppzpt+cWXqcsbNRbXOE0AZuZMVf0I6xj2HqEyfHnt7jeNviGfHHi/kItSv/jv7+GdeoRMmK1Oqcxe8NAFP1hkNdu4xQ5qfVIz/5uMx/PZRHTQ3G8TJ+DCW5fqI/rlN9u4BV8mXs1QMTPrMu0KFiDvTK/5iBjK45Ce/zsIFDeCrbtWMyQKSjXu/G03LGLz6noFdfGrYvM8uOdVrgb159QCtqurunBBD9tw3BSUvQ6J1xXTUzU8Ocq1AvK5T7KnYNWXmMrd4Dvi1jUS0FryyII5fz8ae4y+udXqyepuOtaCHEsxEwTwxBOzbqEwQoDLE2yBBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcposGcnchLswS2HVLVJzrIm3qZYbZLhWLet7fZ6ULk=;
 b=qihdozq2oQ2febPRjsqzN3nNSDWfvg0MrwrAP80QGfGaLGb5lxoHM8t8BhE4lREzQLLBopu08CcTKWTpwq9UQIXlGn4uc7UIQSqT95VUJVeXGNf3AQbn3o91pdSf0eEOQdn1CR3z4KvduKVJXPJygjBKoalQJGwl5SBvu+VhQlRkbgq5XyE0di4OB39Uv0SAMWItZMIl5lhjwsWFED31FuYoG0aWub/d1T/qKbWoJp7D6ehxTf/MebnV4x5hZ7T9CIUjaYe9sZBRLe4pEZUo2Mj/rgCUMqlWtjke8FLZXai/qATLYo9OPZnaa/9zDOTbA/3gFBxVy2/spdzsfTzKjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcposGcnchLswS2HVLVJzrIm3qZYbZLhWLet7fZ6ULk=;
 b=cqBbhmTb+t0YYKmsX8vdkp+FCFjAtBdR2MtjqnF+9rqaHP8VwzHkmHfMX3926opaqXlaflP/xUcbwQmlyr92fzr/hkt/KFc7P0Q3WViiUj1HkyYz5okGdMDs1u0Rt/ajZBNgQ2mZNBhtKeT/a/uxpUTKZTK2xlgH1Cmu8F2dbpM=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 PH7PR10MB6378.namprd10.prod.outlook.com (2603:10b6:510:1a8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.17; Tue, 4 Aug 2026 19:42:59 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.016; Tue, 4 Aug 2026
 19:42:59 +0000
Message-ID: <7ab3dca8-83f3-4ec7-8bb4-e9c3508a5c59@oracle.com>
Date: Tue, 4 Aug 2026 20:42:56 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] scsi: core: Drop Scsi_Host.default_lock
To: Bart Van Assche <bvanassche@acm.org>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, hch@lst.de, John Garry <john.garry@linux.dev>
References: <20260804113436.2373404-1-john.g.garry@oracle.com>
 <efff8e1d-0eb9-47eb-ba20-6bdbeeea15e1@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <efff8e1d-0eb9-47eb-ba20-6bdbeeea15e1@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0005.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:ba::10) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|PH7PR10MB6378:EE_
X-MS-Office365-Filtering-Correlation-Id: 72e1764a-3a8b-40ac-d7b2-08def2609654
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|366016|1800799024|13003099007|22082099003|18002099003|4133799003|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	QsPNH+sC7A4JPig8X4WbJK6NGcjaDVhHkXXztiFFCwmJekwWM+WF7vXY4PA5rLAyscFj+qJO7ZjhlbP5y2IZ1AK+Ks5tipSLRPlEUQiRBPbYJA7DEk31HfoXmop1NP4qS9Pg+WAnmNddGuzW15lXtLFDNjxKywnUkK/Y/Qtate62LyOfVt8f3SLpiHj5RxXtuXsqGbRyRuFp2BZm0zNdayeSQbSxAvATAwNiFaC2m4X1hCQ1j0u/sWmORlMhixYaq3QiAOv+vOdOMqltvRJr13jqIGXSr1rYoxxbLGiP0Mtqn6t762l+t6TrQDqpry7K+A80u/CTLVOb7dMSy1Yf6fKW+sBio2xYKFPq24m2ZVGwRWaapQsFc2ymlvlCPc0PNoGrtRAW5VfG5NvKMHVjP9uDL8kcZnU9BUt/Qc1M730oW8Amd/kf6FRi48boCiumCrwZdrnQhDDvfyjlrNYLzGCogOaYzYC5RF6oq73nzQc/ZhrL+3nV3CXbrNgOb37wJ6Y2zsQxOok7XOeqUnfCCozQqxkLWx0PaVfTyGS5JV0YC/49XdV0fvUuBbGdYerA9s8dnf4rA1JzZpGZgckuLsQkDSovH/clAAqrMMNJ4r8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(366016)(1800799024)(13003099007)(22082099003)(18002099003)(4133799003)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlNtYXF5VHZFMFFCc2VRWnlmZDFlOTRCVWt3a1lyZnczQjJYQzVhbWgyZWRN?=
 =?utf-8?B?Y2xFaS9YL2VqOTFabDRyNHp1bDdJM3FxYmdONEczQVd4M2IraWptYUFpZmNC?=
 =?utf-8?B?bjdnTUhteDg3Z0d6cllMUXFnV2dpOU56dmFER0JBcEhhZEI0V3FWb1hxbkt5?=
 =?utf-8?B?ODBqWlhxL3JkaUJPOThwb3lNSm9CdHBZVTA1RXA5elBPMVc0cElwYlV3UDFR?=
 =?utf-8?B?QldOaG9Xc0F3ajlONjRKMTNiMkZ5OGxGQllFai9hYVdOVmxOb0JtdllxakdW?=
 =?utf-8?B?aHExdjhLK0ZQTHFqUFB2d2R5OG56ZEVuWjI2RUFEZXgxVGtCRFNKQkpuaURJ?=
 =?utf-8?B?aDFaa25SUWNabHZCSkdtSTNmWXJRMnp6MWhDN0xTVUgyRW4rU1F6cTV3aWRr?=
 =?utf-8?B?cVdsMTNGU1FMa3UyUjhZbmJBOHZEUkFITVdUL204alhUL3gwQmF4T3lsaTYz?=
 =?utf-8?B?RzRSMXJOcWpKZkJML3ZJb3M4OUNnZThLL01xdWNUUWd0cTJ3amlTYWF0S2JD?=
 =?utf-8?B?SVU3ZHZDMFRmWmlKbGVCTkZzLzFTdFFwWUYwZC83bjlvdmRaaVZwSjQxMmJ4?=
 =?utf-8?B?UmZ0VG1IaGZtckdDaVRZeEtHUjhBOHp2bEtRSVcwdjJKa0I3VmFvQUM2NTJO?=
 =?utf-8?B?QndKOGxFM0UyUnpNb3dUcTNvM3pSbnpiZ1hQQ01hYU0xTUkyTTJVMjVYNEFN?=
 =?utf-8?B?OHVoMzRRUHdRRWRjV1NoUmJPcnRnYXV0UFBSM0ZGY294WXFCNWtkQWJ6UUdR?=
 =?utf-8?B?MnJ6Zi9tL3FUczVHNWdZcWpPY1puOEE1c29wT0JoTVhpdHdlVFdlSnIzR2Ir?=
 =?utf-8?B?eXhtejRCUlVZbXcrTWZaRTBVRnpnMG5EY2lBdSt3clBjTGZ4aTBaQ0N5R2Vv?=
 =?utf-8?B?RUwvb3o3b0lMVnBqU3ZKMElvUndxN2pLN3QxNGFzcEMvM2J2d2ZPVVRFdkxC?=
 =?utf-8?B?UWNkUjJMNXIvNFMxQUNUM3NIL2o3M2YwUXRBNy9GTmxjK2ZkZHlsQ3BiL2dC?=
 =?utf-8?B?N1pvZ1lTeUttWXVSN0g1ZTJpbXBmYkhHWS8yMWFDd2RWVVlrYVhQWk90UHEr?=
 =?utf-8?B?akY3TFJJSkNlQXlHeEZydDlqK1VZeEEzL1IzOTg3UzU2NEpvb1lydWptQ1VD?=
 =?utf-8?B?eURBdCs5REo3a2RuYW1ncUsrQUFLZEpVVkNuSG9GNkN2OFJ2UTAvcUd6aFZz?=
 =?utf-8?B?cTVoMGlGckR2WVk3N3V5QUMvdTdicFJEczBOejkxYnJBTGhlRkJBYllCY2l2?=
 =?utf-8?B?aXMveVp6TndLNHBjQm1VRS9kVnVJOWtkQ2JUODNQaFY4MjFXdXgrbnFYY2pB?=
 =?utf-8?B?NVIzd2NNRngwNDl1aUdEWG5mSFVxNngzRmZKK2FhT3U0bkdRakQ1WE5IckdW?=
 =?utf-8?B?OEI1ZkRCMmhueFB6bnFZWUtzNE8rRTlZSHlJTnZ1b2lQTytFZFFRUHlIRjVF?=
 =?utf-8?B?dGVtdXloWVcrYStKY3RwQ3hnT01JNHhGY3RFd1JvTDk1SGdiVmtCWjJIYkl1?=
 =?utf-8?B?ZnkrU1lZbUl4VlN6TlZZKyt4MFlwcnZBSS80cUtKUTRKRGVvN3N2OWtLRUpt?=
 =?utf-8?B?VkZXcFRvejNiVzhvak1aM2ZnMm1XUkNBRjdSbXBZU3o4YlBYeXBaakoxSVhI?=
 =?utf-8?B?TDYzaGwrelJJR3ltMWJENkZicXdIaS9lcjdZemVUR0ZzaG5OMlNXVVhHZmVl?=
 =?utf-8?B?aXdJdFBSbEQzeTJIZERUZDlqWXQzTlpLOFpjRFpoMXU1Y0REQWl2NHVLVERB?=
 =?utf-8?B?Z0xBYmc2U01jWHo2TFhQTXJSR0htSmUxZWFIRmV0bGppMUdyWndSQkZzdE1Z?=
 =?utf-8?B?N2Z1THBmYWEyTGVrN0xEcTFBUHFwaVR5Sk1xOWh0VDBRVVpoOUdDWHhMempv?=
 =?utf-8?B?cHdnbUd1Sk5TTG93dTUrck93UmR6Qnp4eXhXTEg3dkRscFV2WlF1aEI2TzVP?=
 =?utf-8?B?NU1UM2dWQTVNVDcyZTNvVGRPcC9WTXl5RXZ4QlF5U2RKM0M3QmlTVHZBNitB?=
 =?utf-8?B?VXFUNmVSNWdGRTRLaFl4TVBnbXQ3aFFLNDJTeVcwVG5JbEFGeVlHMFF1QTlT?=
 =?utf-8?B?U001N0dtdVRwdW1GZ3RnSTNpMTJyODd3OThEeThwSXU3cWFxNUpBM0hEMlly?=
 =?utf-8?B?SEZ1YVd6UGtiWEtxL3JETHpLZGltb3ZWNXZBejZVVlhvcGk2S3d4VFN3akVz?=
 =?utf-8?B?S3d1YXBJcmhaQUJCcFdOWGZ4eVpmYkZMb0pObGZpRVYyVXZQTFdwY05rbmpF?=
 =?utf-8?B?QnpRRFk1bGxwQUV5SUdFTHlJYW4zMmtsbmVVaWkvMUxqa1U0azBSUlhzQnJH?=
 =?utf-8?B?UmI2YmVVa21BUWlFUW1WT1h3OFJ0TVl5NG5ZV3RKc2liMHNLaklIUT09?=
X-Exchange-RoutingPolicyChecked:
	jAe9Yr2mqEulu24+mr5ah+eMbu59WHIYKhWgQfX3SgUX8hJC/sSCmbbHhOonKO7LtRcf+yNrJ68Ohn/s9q81HRn2bMkWj+gpFUbmLDJzvMuUaQ+zOaKmsCXXc03JbjbW8iHa4svoV2TzgPtLR8LncA9R0MMDj25+zlrWPPdhpJOqV6qJO2ukV9UQWT72VjLO/ed0Q7aNfhA94qS0fGqJMAjQrtVuKYCSoZJuCD5YYd7PcpVpw7ZEKNLECJbPB6D4o/0rwSUviKNQwi2X7wS/nOnTDLSRLmkvgoava0G/QmqZYW4+ZOdH2YdlA7klcTVn2z7lOluhkqMxVHv6RF63NQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t9koeMVsZJiSm36QYPxiR0cfUpqvapKF0IsEkah233vgfRwD70n4CP8kmqTjVrGijQZ+quHY234K+oWv8XrAURmk7R3EO4Bo4AgTC/VWi12XV0QsOR6usKQrWfOxIkoYr4XqhnSUqFMf/38I74XfxkF2nwOE0YUsf8pLef2jT5/c5rbTQkOC6OY69uEzdPZvd4DP+L5q8bv7bMQNLPOu8e3xAErPy3KF/KfWUkT9CGjLX4nn4eBloZLowu4U1ZTyodduDsqEcGhjHVD8FFLR3kBtpiYjMe8NaOa4Iq7ZYmpO1EDxzpfubt/XNxyLgiqV6WFs/19xTxupgzJ+Aj/sf+P7llA9b8GtRo4qJiQzZrA/TozMDHVylIegCSwttIKeFWmga7sjBp0CY/5/ABcSuO35TrRe0bYuRPhSBPo4gXTlAzAzaSh4KtY9CpgEKhzO+olj3SacbPaJBaWxWC8Ft1o4mK4h5sYe01sV6pJVjyhA+O5qBhDdOYCQiXo6A0cG/morlQ2uhaTVlIsPd4wa8GgatREXq/AkcC84r+kpsZFCMmPJq0jUFRL0qUk48VCt6/5W+uWUfkD3Hf1sU+yllVv6kLbs05ky702SG+qSouQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e1764a-3a8b-40ac-d7b2-08def2609654
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 19:42:58.9946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+v6TOfG5wd6/3H28Ymj2M1prCIcH7tjkKahrAzulLXm6aEVHOsDvIJkvQlzjLftfpaHlzmsBbazdRhxMWgQGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6378
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_03,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608040159
X-Proofpoint-ORIG-GUID: d2cDBu6kDxZL20VFV719ctP021MgKanY
X-Authority-Analysis: v=2.4 cv=XqnK/1F9 c=1 sm=1 tr=0 ts=6a7240c9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=uherdBYGAAAA:8
 a=NEAV23lmAAAA:8 a=pFU74E9AeWGXz_FN0iUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDE1OSBTYWx0ZWRfX19WZG4N+JlUd
 kGsLYKeLvpip77Q5177QIUTC6q/5NBOvhhW4pDXv0qsxOCQKCgV2VYZUv1vZYFrtN2WoUQpAsyo
 PEyfZ0vC7DMvZsjqFhetjNYLTlpIgl2u8DEHQFU5EcWTQMAv9i/N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDE1OSBTYWx0ZWRfX8EJRwleSIF1C
 jBnhp+I6EH0bfmHqpyTESx1Qfyx5a7r3FOr4XfXIcJ4Tt8lCYMtekxHK7ZIqF8KoqSqj8x81F8I
 xn6DXLLUUe4R4ueujkLOOrWky6JlSJTzI/jGHSY3BPkFS0+c1Vn5FCQwhNLR94fEuJJ6+IxnlzX
 WAlrPRhmfhv5qxvIEew7tAEgY+PfArgL+HfCkTGtXzf9LdT9QGJXFkvlRAfTHG3VR6WYPCFIt3g
 TGTcAdUTgCVTc9+4UrHrsCSTitX1MTkz2wt0U2q64Y4iQ9MXxkoHzAA7V/UyxB/TMSVNwZLp6Q8
 HF4vvme3CNTrnHo3aKrbgJfJEvPFmw1I6Rxl1Ag0IMOKQ2TNlxjh53AwzxR48lIDxOOsDJC6Gxa
 gK6Y58stwtseDuEBMajNaUuhkYX9PK0yATfudmdENoc8v035mHhD4lip8ld2/hXTjql8UHWz0li
 v3EWpeSjuNPH6yO3k5g==
X-Proofpoint-GUID: d2cDBu6kDxZL20VFV719ctP021MgKanY

On 04/08/2026 18:53, Bart Van Assche wrote:
> On 8/4/26 4:34 AM, John Garry wrote:
>> Getting the address of embedded host_lock structure just requires adding
>> a fixed offset value to the shost pointer. However, getting the value of
>> the host_lock pointer requires loading from a fixed offset to the shost
>> pointer. The latter should be very slightly slower, which is relevant as
>> this lock is used a lot throughout the core code and drivers.
> 
> I like the idea behind this patch. However, I think this patch is
> incomplete.

For sure, it's a bit of work to cover them all.

> The changes shown below are needed to make all SCSI drivers
> build again with the script available at
> https://urldefense.com/v3/__https://github.com/bvanassche/build-scsi-
> drivers__;!!ACWV5N9M2RV99hQ!
> M6E9mlAub1UcWra37zJgh_viQQpt0iL5URAr5QPhRm9PfF4eaqXeGyG1MOWRzdyojhZ3zFekfZ53Dro49iIFtQ$<https://urldefense.com/v3/__https://github.com/bvanassche/build-scsi- 
> drivers__;!!ACWV5N9M2RV99hQ! 
> M6E9mlAub1UcWra37zJgh_viQQpt0iL5URAr5QPhRm9PfF4eaqXeGyG1MOWRzdyojhZ3zFekfZ53Dro49iIFtQ$>:

Cool, I'll go through this. But how does it handle the arm v3-related 
drivers, like fas216? At a glance, the script requires 
gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07 - but I thought that HW 
like this requires an even earlier toolchain version.

> 
> diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
> index 4f23d585d062..b1ed0cb30a72 100644
> --- a/drivers/s390/scsi/zfcp_sysfs.c
> +++ b/drivers/s390/scsi/zfcp_sysfs.c

Thanks!
