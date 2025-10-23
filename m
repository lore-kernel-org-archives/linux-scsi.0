Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57B72FFDEA
	for <linux-scsi@vger.kernel.org>; Thu, 23 Oct 2025 08:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761208291; cv=fail; b=rdORiQ6W2Hd9PXgtcWMlyNzrSRNbc524MZnfDXAh+6Ifw3NobutWI5D3OhY3Xw7eskfRDQlny7EVqe3DHsn4QC5RUcj3aoH5C3RtFYdbmV01xoQv4cdHH3HJMl3upijvi6tH6hIRPMFfkzS1waPQOOHB13wn34bFZWcBJSICOtc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761208291; c=relaxed/simple;
	bh=UOCLm4r/jWPlUa+jmn7K8cBv1lEPQULLUfmTd7phvCQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f4PY4pDK7XJhaGmjJQtV1NwM1E1NLkNGVFaqjSJHUrFjP+GxgDkzPlvhgT8LsSfqbThSABsR5NLgUTKqhhq8BF4Zedjx650GJo+amgsV4/fuE5lCZno7kGLGT+0EHp61xfS/NndEQwibKxdkZf7BN8xTCvaLqoX5njGZaPIYe7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jSkvi2fO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Kv4BuY79; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jSkvi2fO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Kv4BuY79"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59N7uJce009118;
	Thu, 23 Oct 2025 08:31:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=na1+kRR/vBWZ2ZyLUQtVPRby9PwUulJPzlfpAC1SuQ4=; b=
	jSkvi2fOIWxYHOpRV4XOxp0JLjlRw9hvH9ze6b20Mq/eb6opy5Q3v7l1NnRdJcar
	+vX0aFpFWQDnbN6uL/l+JLTWfwORqri17yTbwmEupyWakXzo4J54/fKuQwrGs2Du
	gzqQpMnHkyqBPKvZg2ex7y6qxdtZDSuMWpQgZ0huBR8dtxr0XprtKkPW7D5sIxys
	Tn23lzy1D/8sld0ZHLHxnOaZg/qJlf4k1/Q1puN2KGaVbFmLHDV5RcxS4Jl96txH
	tB0s4vWqw68UPN/0g+hBdeCr32p82TX+5lkb0vOXt+7s31KgBPwIpqvF5ln67ikg
	vu1MuRa82Ds/tgSrtfdpYg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvcya1c0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 08:31:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59N79KiM012459;
	Thu, 23 Oct 2025 08:31:17 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011046.outbound.protection.outlook.com [40.107.208.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1be9ga2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Oct 2025 08:31:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BDNXHLm2cLhmILQyr/zTN5QSx+80MzlK76DnxkRsaGK0/524ofzTms9VrmpyDBsOF14OgyRrTy9w2KNcv+6k4IZaMofzdFxydqwKBpPQYbhj6W5agxP47sXXKOcT964LmkMTGuVPnq7BHuXZFG1IcyR09nQz3gDkDnQpaTwEqAgKS8LId/zywM/xglcVIrJueaJswh249Yq4Y8Ed2AlTg/wKYFcG4ws4yE3IY5DASkJ2P1VI3E3B6rNoPylhGvuwy6jJrlMF9GhHX3txRJcjHqSmNwOsEP4i3zG1XEgm21cJe2MOO5B5v2wG+l4s2CYy3ITBI7YwmRBng7bRbmHyxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=na1+kRR/vBWZ2ZyLUQtVPRby9PwUulJPzlfpAC1SuQ4=;
 b=m1ua82SgX6SWNiry5MRNd32nkf3ro+Tmy8z3asJZaQHVu5hQcoIKHLP+ECsGdE7xudhkKlX03lJMDBEtMB3TE+5gPio8zTj9Yvbivm/8LR5zvE2UZNPg+jdxh+XI7btFF1V96vnGpAkChrDq+8ZtxAVv0KeX1xvRNTUtUDhZwDTvX1XwBCbQkah5o9YpWVq8859JWBcT/E/vAz5/OlhPpVsHkoLOzBfl/ye18eS2/8YVVO+e6wXDWIx317Thr8LzfIQtoSPJFTqfzWwGihv6Et25+InO3zxRfzd5yKcPuZLRbpzwWN0d2jenPpqdd2vHu1Un5aaA8AAYCoC/Dcpr7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=na1+kRR/vBWZ2ZyLUQtVPRby9PwUulJPzlfpAC1SuQ4=;
 b=Kv4BuY79QlvmxY9B1YAhj08xXzHrriSrQeaFcwh6fE+p04QOpeRMPo81D1M6fNtABVZHhd1sbqO6CVE2wC+GuVwMeqWp5CSHFAYTwI/EW2AuSNPzSfudyhMLLFWQ6gVJWsHHwmTb8AXxTqVTU1ePx21WB/ha+a0rKH8FRlvEzu0=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA0PR10MB6721.namprd10.prod.outlook.com (2603:10b6:208:441::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 08:31:14 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 08:31:14 +0000
Message-ID: <2427124a-24ae-4a49-a26b-5d1fd7fa3948@oracle.com>
Date: Thu, 23 Oct 2025 09:31:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <yq1h5vr4qov.fsf@ca-mkp.ca.oracle.com>
 <fe16b110-300c-4b13-bf2b-56e7f2c6f297@oracle.com>
 <540bad1d-ba01-4044-94e0-4f7b05934779@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <540bad1d-ba01-4044-94e0-4f7b05934779@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0007.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::12) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA0PR10MB6721:EE_
X-MS-Office365-Filtering-Correlation-Id: 47127fe9-531f-47e9-c3b9-08de120e875a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWIxM2Z3MTR2ejRPYXF1Z2YyZ2Z3T3pTTDRPbmR2dm00ZVAvUGMrVXBpMjlC?=
 =?utf-8?B?M0RHanZDajZTMUlNdkh4dUZvZkRmbFdlQTMxNnBsa3pleUJmK1QvK2NSRUhC?=
 =?utf-8?B?RG1YeXN2TjlSYThSd2xlSDZwUkcvVXNLYkhrNmJyQ0lZa2M3U0hJOGhBRGhJ?=
 =?utf-8?B?aTQvTHhKYUQ2dFI1b0JEdzdkVUlndjQvZnZxRS9VOHpDd0llU256dXM4TWxU?=
 =?utf-8?B?STVtbFN1ME1STDJkeGYrWUYyZFQvb0lsbU1FMVVsN0tON1hDSnA5bWdJK3lh?=
 =?utf-8?B?d1RQbC9mRm9mR0RGR3VLeTlhY3V3TllCY3FZRjZxT1VnL3FnaFZsQUlCemlT?=
 =?utf-8?B?ZUxST0ticlY3V1RkYW0wdndVRDlTM0o1bnlzZ0Z6dkMyMFY2YXV6Q2IwcWFY?=
 =?utf-8?B?UzF2dEpOendKa2lSTTRERFUrOVlNckoxTXJmeUJoa0M2YXpPckRpSzU1MmJQ?=
 =?utf-8?B?V242UmsxVGtLbS8rTFNUaDNyUkk5R3NNRXBoa1l0NStub0N2S1hrZFRxaXFR?=
 =?utf-8?B?TUN6TDhFSE1WNURwSER0TWpxTW9mSU5kMnRvS25nNVVNTmxaWnZMSEszK1h0?=
 =?utf-8?B?WS9hWGlzZlFUVjRrUWdSb1RoVXMyU2ZlT0FsSE9JZ0xqY29ZZEl6b3RGZTk1?=
 =?utf-8?B?OVhCVkZMQTRzR2hpMCtFTHpyUmVHdnVBYk1yc1h5eUw2RHArQnBWTGpGbHh4?=
 =?utf-8?B?TDFRaUR4cFQvNi85U2kzaUM4T0F2R0dSSDR2bVdSeDc4M3MwVE02V0ZNNkNS?=
 =?utf-8?B?MWZGd1ZFdlBDK0o4UnVKN1puU1NDZFpGTEc0MVJkRjZ1Vlc0ODhpRDNjUUpZ?=
 =?utf-8?B?M2xrVWtRbFdsSWhCVVo2Nm53YklKRzJBN2F0VW5wN01TWjBVbnd3czhBbjk5?=
 =?utf-8?B?aTA4RkJYSGlsWWV6SjJKTFBxWkhDZ1VqeCtPM3dSeU0rdCs3NENCdzN0TUNI?=
 =?utf-8?B?UzBMUkhOZXpDRkFVWGVocWNTdUVrb3NKYTlVZWR3Mkw2dG9ST1Y2QmRZZjJZ?=
 =?utf-8?B?SUtZODFzL05US2xZdXlkcGl6bnZoNExyekx1dE5pUGFoYUR4VWErQUZ4bC9U?=
 =?utf-8?B?aHFoajc4OUtpZndRRkhMdnZ0RDVFT1JWMldBcjYwUEV1V1RBUDA3akVkWVNT?=
 =?utf-8?B?SSsyY1drbzZJM0VVY1JaMlFpNDdsYjF2cDRoM3dXOFQzMTJTeDZvdVdZRk8w?=
 =?utf-8?B?dkZoR244NTUrcnVLQTJoZFV4aVd2bjdoYWh4cjAvTVA4TVVVUHpaRzlhMFFt?=
 =?utf-8?B?ZXBLMWpHOGdHV25naUpxeWZaKzl4RHRuWER3U1hBMlJKZXJ0MmlUZmNEaERs?=
 =?utf-8?B?d3hOVEhvcFR1VzdNQlV3QVZ4aVdYb1RWTVFvdEJkMFR0Yk1XS1I0ZU1BQlZY?=
 =?utf-8?B?dnNLQ3hFNldWNzFBQ3lRQVdaaDJHeW1uQ0Q1eVR5YkNlV3lzZklPVGljOHhT?=
 =?utf-8?B?SHVSdmp2bFBKRnAxVkxYQmN6UEpaZkViNW9jWDZ1Si9lem4rQ09WaUlxSzYx?=
 =?utf-8?B?QlpsdUdoSFpVSkpONzd5QmdEaUtRNEhiK1BqUmYvT1lhOGJXclJ0T0ZPWWNF?=
 =?utf-8?B?WHl6bUtWNzQvUno4bHJyODFVVWlCRDRiZ0JTeFM2WXdtRWxiWmNwajFLYks4?=
 =?utf-8?B?UFhqL3FFNCtmUnNqbWhia1MrcC9ZeWtsYS9FSkltRDIrYlBkMDBCTU9NMlA1?=
 =?utf-8?B?V2N5VzFDd2t5WFVkZkRMZDQzUktidjg3ZzhDV0F0WXRFQVJNR0k3eTNsZjZM?=
 =?utf-8?B?clRxM3JkVnhBMm1SRWZnUDBWNFU3UEF3RXd6ZDVLK1hMdkVxL1dBajU0dnB1?=
 =?utf-8?B?TTE3WFUzYVl1Nis3cU5zMUkzNnBEd2FzU09ZMnk1SjlUWDgyM2sveWp6UmV4?=
 =?utf-8?B?TTRtWFJwSzVjM2s2cUpQRTY4ZEdRMHJFOXBBZWhFK0pwNDVLQWlkNTRKWG8r?=
 =?utf-8?Q?ue03ddz2RcvntY/JeTInQf1f2bMruJtX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U29tbEppd3U3bjR4aU1WVUJqSU5CRWZkUVgwaGYvdHo2UDlWL0ZtTHJoQVNk?=
 =?utf-8?B?RGp2U2VEOHdNODB2MWJzemQ1UVRHWFZ0SlBDdHhxa2pNbWpjdDd2K0lJeGUz?=
 =?utf-8?B?eld3Y2N2djd2ejJFRTlPVDN4akdEQ2VMczNmUWhNWG4xTkpsckM1WWRLY09N?=
 =?utf-8?B?MnVTVlRvZzZsTC95a0trVFN6SmdZN1JwWkZzcGFVRExwU3NYOWRFY1RROFZJ?=
 =?utf-8?B?K2EweG9nNVBmNFRCSUx3TFFkbUFSTWlrb2hxVCtyT0oveVhmOHI4S0RHNHFv?=
 =?utf-8?B?L2NONVpTdmQwUFpaTXVsQVBUUDJMc2VGMXhZVmN5VE5qMlRJYTh0NktOUEJD?=
 =?utf-8?B?T09OUnQ5T3N0K1dWc2dFVXRoZmpOTkN2MFdrMHhqZXJNVkdReEJZVjZmQXR2?=
 =?utf-8?B?Vm82dTEzOFFvRUxRUnpZd20zRmJTbGFOdk8wR3V0dVM5NENxRm9pSDliZ2ox?=
 =?utf-8?B?MGhEOVl1SWplTStCNklVN2MyMFVhbFVnWktVMHgxaGhwQnVuMEFnWlA1eDhF?=
 =?utf-8?B?ZjNxamdOV3FqbWZFejJweDB4dXZQT2ppUDJjWFpZdDlQb05kQjVndS9tUHdN?=
 =?utf-8?B?cmw1MjlBU2g0NXpYVUVCV2c0enNLWXBVVUQ1ckJsY3dyWVpFNVFVTkFacWxo?=
 =?utf-8?B?VXRJRCtYVXMyQzVNaE80aCtKa0gxUXBpNXFHK2hRcFYvSkhpTUVJQ2E0Y0Rh?=
 =?utf-8?B?K0NKZlRCc05GQWY4TjBOZFAySlpEY1FaUnQ1a2YxTEZvQTJnd1RJTzE4RWR1?=
 =?utf-8?B?bkdrMVdkL3pqd1BLTXpzMXd4eTJLci9tQjRISUVaMTJwMFdGdkJTaEppY2dU?=
 =?utf-8?B?OXBKZkhXZ3BaZThKYzkzbTJYRXMxWTBmUkVoUGlUaDB3RHJzbVNUWU5qckQ0?=
 =?utf-8?B?QzNtakZRdDBLRThmTWNxb0M4dVN2cnExQWNnNEp0RUdTWGFNY2pYb2Z6dEh3?=
 =?utf-8?B?R0h4MVBQOXRBbjIwWnJGc0w3YWNLOEhNZktlc29XMlR1VENnNTVFeU0yTFhR?=
 =?utf-8?B?dm8venh1WjhKN3R5bTBwNVJCendpOEpXVXBSY1ZHREpCd1RPMjVXaEI1aFZY?=
 =?utf-8?B?TjNWaG5ZZ0VLNlROdjdubWhleHozVDk3c01UOThVUWNya3N5WnBNU0NlSmxT?=
 =?utf-8?B?RklxS0xvc3FFQTFaeVMreS9sWEZNT3djMzNzVGR2RkRLWHZwdFFWaVpQSUhN?=
 =?utf-8?B?eVBhd0h3UGhtaXQ1NnlVWUZWUElkMFB4cjRZTE4yd0YxQmdvQkN2OTUwOFBE?=
 =?utf-8?B?bnBMeTV0cmYvTGtNVFFxV0ExTFNocWsrMk10VzN1cDRkb3VXVEVvUXJIc2ZV?=
 =?utf-8?B?Q0hMc0pUYXduNzFuM3FFV08zTG1kK0o5d3pjWmdLTWtiWmtLWUhyUjVnWGR2?=
 =?utf-8?B?U09KVHhRNG1OQk9KcmRWTmRTR20wSHRzWDFjanFmNUVDajBmQzZ2SXhtOCts?=
 =?utf-8?B?Z1NqdGFqZnRDU2lOdFhzOEdCM0pESmVOeUhkMFJMZ1NIdmVzaTJRYms2SUlZ?=
 =?utf-8?B?NlNMaURMa0xycFMvWGdNOWE0TmJSNG9lKzdiVktPbmpkMElCRzFLbjhyNHg0?=
 =?utf-8?B?d0lpaHA0b25pZmVxa0I5a1RKVGl2dG5ZTFFkenJVSEV5S2gzT1BIdnNMbUR5?=
 =?utf-8?B?cmF1d1ZrREY1djk4Q0dycFJNdng2T0wvN1VmejgvR2VrbWJrR01vOXd5blFY?=
 =?utf-8?B?K05SQ3c1S3p3aTRpNjExb1dDK3hKQjduQmcyY2hqTGNUc3didUJERTZQUkxO?=
 =?utf-8?B?eUNHaXBhMm1JbTYvWjZDRVdjTllCcDVTY0QzQlFjR0NWbTBKWmx6bUVNLzJK?=
 =?utf-8?B?bVhFOERxc2NCUTI3M1pYdU1iM212aDczSWVPTUN5QW5MQy83L1dzZ3h1dmZn?=
 =?utf-8?B?YjRMVnZVYzFBMmEwclJrOVRSR2NVbmpROGRETGh5ZG1BL3FOOUJlaXRPU3Rm?=
 =?utf-8?B?OXNybzhtdExCejE5ZWticlJWTFhxQ3lKV3BoMVpWWVFMeDlaWXY0eXpHbWZz?=
 =?utf-8?B?TmY3NDRDSEhjYzZhR0hUeTF5dFQ5V25tYWlEK1p3ZDhlYnBGRWpWTFV5Y0tV?=
 =?utf-8?B?dXZGc0JYNkgyY2N1WENSWFlpckYxNmFNVy9WUlRDY0o5anZucE8yT2xmaEpk?=
 =?utf-8?B?eVBBMnFoZjl2NXUwTWF3SDNIMGlMOWk2NHRjcXNhMXk5RkVqVmZXYjJFY00v?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YVSxM5teGuAbKxFMKbgJ7cfdgUQndBdAsGHWML++vF0S18/vIaTqhfoOIukvMVHxE8fImAxw4DQuNubtpWyc3R2+5x+RIKRbhREAu45aV8v+sTb5TQnqAGsQexFqfAOBGBNN93eXrtE7YjFlBxTXF/Eq6WODeff84p+yf7u9Ov5dmJE9ffMkQjjyAjsh8OpzgGNhXEq7LrqgrGDYzyrwKLBUiCFLgcZNIsYeTxGZD8CHJq4K/x4TrHxFIpiVFoNFcePwxXvgvEfFKtz/0kRNZvUAI8bVSHgObkeyScWbAirI4t48+l/NkBZbliKfP7tpbwR7rMr+o4dG/SE1BOXpe48hAHSXfPgPoZvZOaYOsRaNn+ynL7ycnwgD7zzF0WEou6OeozX5JLzklC3+oBcoV/Qr2LK16LrzW0UcZkWlRoSiNgMucgOAWVb1ukAwLYZ6LCqkj6G8vn5nQByMl8PXwU4JvcrYUyaQsK8GsjpCkmvMnFNwLdetBfDUb5cbZytjRchCkfXmNqUA4elCHUKmrLeurJXmvKtT/7zrgcyS2oW/D65Kk4Pt2rO5vuX019IxrDQHxOvcHwbT8n4Jwrnm3HA2nfOqz58hH/2MY0v0GGU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47127fe9-531f-47e9-c3b9-08de120e875a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 08:31:14.8082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UbuproEin2272Ii3ySbpD+tUKxq/dqpO7EiNcRDMLuFM7TO39vgvzQZkKP0evzk+ByUXIc2DcTOeWeL2CWaPNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_08,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510230075
X-Authority-Analysis: v=2.4 cv=GqlPO01C c=1 sm=1 tr=0 ts=68f9e7d6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=5gPmGLkl_mXyrk_o57oA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX9mZqsXT7SvX/
 rwmE54qw84cgFqfO4p3VNJ3iEXO1wsSAbL6J7nZUoWtQ1dvnxk6nbGmShRZWmpxhYqyS5WP4pVt
 dGJJxkUXRI6Ga5cj2vbWstHloOPl4wGGBkirxb2qNrBvgETAe4sd6jYL/aP4wmfWwlenptHZ3y6
 94WRtT541Oa1cpFjGWppTZjeAOsCwFKZgcgJPB6jNe8pehahs0YyXXEXMwCyCarKtkYgEjcfpiz
 b1wLlVNAxyUXpe6nOkmJKJkcMXO+cQ4FZG0Rdkpu/Gdt5lZxk1aJseGvT1Yk1m99KwKTRMquRMc
 yCk92RyApIdxXzFd8Mmc4dpSjtXB6Tsn9vByMIIQT0mtAXEloS8XrEYLrd4IS95qRyubFfcRk8S
 5dKNgIohJXfZ2b19EzPCgIOpoa7nOg==
X-Proofpoint-GUID: QVvRN6BvbC3huBhdU1e8A2gKwowQblOm
X-Proofpoint-ORIG-GUID: QVvRN6BvbC3huBhdU1e8A2gKwowQblOm

On 22/10/2025 19:07, Bart Van Assche wrote:
>>>
>>> Applied to 6.18/scsi-fixes, thanks!
>>
>> I don't think that we should call scsi_host_busy() on a shost which 
>> has not been added, so it would be nice to have a plan to fix the LLDs 
>> also.
> 
> A fix for the UFS driver has already been merged by Martin. See also
> "scsi: ufs: core: Reduce link startup failure logging".

Good, so do you know which other drivers need to be fixed? I saw the 
advansys driver mentioned. I can look at sending a fix for that.
