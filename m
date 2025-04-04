Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84802080E8
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2025 17:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743788117; cv=fail; b=D7lLk8ldU0r0MO+JXhspZzpAqRpDuVLIOOCWonZiqZxwy1AhGoRrrionYu4o90MQuwBCVOfRfDC/noHZHfInHM/EpWathYcyNQD2hBDf7i+6NISVR7NakPxW5g70uUeFhn0N3ICXnXslIx20cnnW0p5evtVDSycaJ4aRIfyQjYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743788117; c=relaxed/simple;
	bh=nY87R36v1sNBSpetIkc809IPMaF3HpKosp81qpRipIw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MX34uE1Q6hdlKh/OKcYQ5YOfANO/E2muKX2+QWUTgjhpKOuRvl4v72d32OdCP3zpL2grfzN4ClP644i1wE6FTPwTaoQiRsWdf8nCTxnej/QGfpb3eeugt4/DtGbpoihbJ5e7Cr3J4vX8FM057wEP+aIBI+h6b7UGJz3jEY3wuYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WD4egEyg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZcvZxVNo; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WD4egEyg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZcvZxVNo"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 534Du3Q5021169;
	Fri, 4 Apr 2025 17:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=nn8tEof9altJUEutX7RwRwrpmbM5K7K+pqRmCMR31/A=; b=
	WD4egEyg3Ik2nNOd9VXr0zaynS+UMZ+3omstJwZtB0D1eUd0ul8Z6EUDHB40/9OU
	Q8yw9Tdwoa2e/AuQ6LOHQySRe4Xpa9vxyedAvIhGfDsiaXPFvqgdsT9FxNA4tnbX
	kso1scZc2Z8lKhuid/VvHylDuwoUxFsjkzHhNbfG3Tz/uXJXfT5HFfDh6xxOkM69
	AX1COzGSJIF/VLF48/ScLMJTwjq8fdhryeiV6iYpHI9ovwmOz8U/XWCDzPfeW+L8
	Ybpq7yHESwa3JgIGuspVccVqOKiwQXYJBbCMPDdIjMqRocnIHYd6GtWKpLI7I7Vh
	dTGTWsqBS+2C+uNdryJDAA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7f0qekp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 17:34:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 534GO4TJ036468;
	Fri, 4 Apr 2025 17:34:55 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45t2nubnav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Apr 2025 17:34:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qwBcLEck/XREWIUQlx+ZPeryl3+8+dyCfh1JhXFfiEPYW4tbicI7cWcghLfiBvzrvvwCzd6rYnNS5CJ6icsHoCDIPZ3Vl8HYqdAjjr+auT8J1Wl32uKdXgvyTYRbi454QlRKyqDbK++jkzXV4PENBhkpznQgcnWBmPd9gpLjCd3CJj/k69fO2FuCfZMBCxl7YvophvEK1nkOabZQ/L5gV6hZWy6dgWNTXbFB0kUm+doQJ6qRfepQPGK6xEZGi46d/hxPhIwcLblNh34/QqxtCBCLCq1JplLNroHWcyfX9G0mtcyuPgHF5zJ9A8cTxGRT6KrLXICzinWFuk7HglsANQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nn8tEof9altJUEutX7RwRwrpmbM5K7K+pqRmCMR31/A=;
 b=dRGSXWRxyu2zbLv9fxJcmnfuOqFExogLdyk+VkyogrA46xftJN99R59BbgOG5szvV3Xt/xNgPXue3gGz/ueTd0KUewIuU9tV+f6VgvUL3fzVu59Q5v24hyvKIjprrOftJgDpqpmPmB/2i4HnIN/7mvLX3yjJO7HdL/n6qwSWgocDnL+EhWjVEpaOwW6nghtuzP4U9mhgpR7Sakg2fuSK0di2g9rC+BmsRyfaOd/svccZGrNOsnc0oqFhmrdkTTRAH4wkCcnrFflM+gGKhwtdgtdRxHXk5P7c6LxqtaW2MdtaQoGKB5KlSNAcKklrg0vVhM+IEjlYFPBfwBrl+KTr8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nn8tEof9altJUEutX7RwRwrpmbM5K7K+pqRmCMR31/A=;
 b=ZcvZxVNoWnU/Eo25KEEvE+jLzuikVZWRq6QvSQF7oED8tMteeQLeWvaPuzlkhyppRny7guqYPz74DqAttiOHgbjkz6EU12oOsuymJEEQClQlvh+77Bg9wA0QTQ/UsRk8p8t4gZN//hK15ZSvgzK1S2YDNo6V2kun9mZOcW+7GIY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB5712.namprd10.prod.outlook.com (2603:10b6:806:23f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.41; Fri, 4 Apr
 2025 17:34:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.8583.038; Fri, 4 Apr 2025
 17:34:52 +0000
Message-ID: <bff407bb-ed99-42b1-bfc8-05b8aa76957c@oracle.com>
Date: Fri, 4 Apr 2025 18:34:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/24] scsi: core: Implement reserved command handling
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-5-bvanassche@acm.org>
 <3c2fe290-5e24-4985-833c-24d8b80b98b7@oracle.com>
 <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e1cc3f08-e7e0-4eea-82a8-c5d2e7618238@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGXP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::20)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB5712:EE_
X-MS-Office365-Filtering-Correlation-Id: b1a14357-b06f-4812-2d80-08dd739f01a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZEJDWVhvU0NuSC9IT0VZSWo4ZVJuTFB2c2UvY0R6alZ0d0FLckJwUHVUQmdP?=
 =?utf-8?B?SnRISFV5anNZYVBleGtSS1Q2QWV4SENmcFY3ZjBsbld0dVNyOGxUMVJ6MjE1?=
 =?utf-8?B?MTBjM0pDekIzRlovZ1RXVlZxS04xZWU3dEl6VElmaHladGZtdkVVRS9nYkJx?=
 =?utf-8?B?Um5PczRaalRndWdOMXVrZ2xMUnlzM1d0UjR0V3R0Y2c4dnZoKzJidG5GZFFJ?=
 =?utf-8?B?Z0wwYldJRlJibWlvd3c3SjFQU0lUV3JqUFJPNFo0VThyMmVINDYxVTlzamxO?=
 =?utf-8?B?N29IekZISGRSU1FRRnhNR2p2ZGZCU09iaEtaSnVMRDF6OWNncndpNzlod2Rq?=
 =?utf-8?B?Z210OXV2M1UrRzRKWGRmWGVtRnllMFlBM3RPV293U0xqTnFNbUlXQXl3c1JP?=
 =?utf-8?B?UzBBYlhOSTZCNWJqREMyNlZqUllxUm82RzdFcXRZNEZIM1dRdjRIQStxVkJI?=
 =?utf-8?B?Y00rMXdOdk8wVXAzc1dIcWR0THQ3MXZHbWFDWjk3TkJRVUdGTXJrRG9tRi8x?=
 =?utf-8?B?NXhlRlpIVjg5dU9tcDN4aHVPYnZyeURLS0pGT1U3UzJCRHhFZytubFNkL1lK?=
 =?utf-8?B?NWk5L1RxSzNKdW1TNXdHUjEvQjIvVG1wcUJLSVpBZnhqTzg1ZFZ2dmlmYmx0?=
 =?utf-8?B?UHp2alQ4S3QzT014UUhvK2JMRGVKK2o4RnIvaUpXRDMyZXRsWldSaW5MTUhM?=
 =?utf-8?B?dnBMbTEvamhyM0xMRU9SdklQcGhmdE5HWWVkQTBwOVNqdWk4T1lua2l5YktV?=
 =?utf-8?B?NjJrNHNrQk1lRFFtdGUzRlFURzl1dDFQd05aeFIrZVpkYXR6emIwZ1ErV2RO?=
 =?utf-8?B?cnp5ZlNqQzhPb1ZTR3hmclcxUjZDdThBclVGZU56am81UFBZRGtaUXIxMkp3?=
 =?utf-8?B?UktQZCtRWlN6b1JqOHg5SXJNYzFLV1VBaVVNV2lUTU9hUkh5STRyT3dzK0U0?=
 =?utf-8?B?cCtVaFU2Mm9FS0FGVjF2WFVYaW80RG05N2kwK3d2L2psTE1zMkVla05jSEdI?=
 =?utf-8?B?QWZtRUFpSTVOSzFqdGNubEt4Z2VBYTBMejdoMmxOaVAyTmlmeHlwaWh2QVBm?=
 =?utf-8?B?cHdIa0Y1TWdpS0YzVVdlcEpJYkN2Zm5oSHBOZE95QjZBNFNOcDhVck53bEJq?=
 =?utf-8?B?ZzFoN3JPRTJuMnFLbnRtQ3pTVnh4c29FVGV0ZkpaUkdwTS9WUDRmTk02eGxC?=
 =?utf-8?B?TG55OUNEZllGMUdDVDNPZG4rOFlSQWd3VVFwVUNpamZKTjdrZ2s5Q2dvVUNn?=
 =?utf-8?B?amFlQSttY29zVDJnd1U1d0ZsUTNoOUVYbll2Z1dPcW0vaHR6RGJlNWo1K0FC?=
 =?utf-8?B?TEpMRjZIOUYvb0UyLzRtdDNaMkZXRHdxaDFWWk93SEhHc2FNZWwvWncyd29k?=
 =?utf-8?B?VWRjRGVlTkJsMjJyS3hpYVdiN2pGVEo1V1h5RVhIaWNLWGNIQmRrMHRJMi9r?=
 =?utf-8?B?TENRRm94a2NRTjh5aUdjRTJuZHBrcEpoQlE3Yk9uTDZadDZVcjJNVUY4MmJE?=
 =?utf-8?B?VUlYakJFRTRrNUpLU09xTXBpOXNOTXhpaldlVVBFeDJQSktuVVhqTWY3SVYr?=
 =?utf-8?B?NlAvclYwaklxcEZrdG0yNm1rZWNHaWFpT28wVE9TeFFZeGpWdFllZjFucDAw?=
 =?utf-8?B?YTdES09MWVJFU0ZmNGFRVTdDY2Q0d29ibjJLN1dWMEVvZ2lhckFHV2hzeVMw?=
 =?utf-8?B?MG90Vkl5YmlrMFFSWGtJSnIzZXM1dVZ1cklONy9RMnRXSi91Q05sL1lWcVNk?=
 =?utf-8?B?VnJoenBPdWNma2ZOdzZCRXVEcGg5NjdIWjI1ZElRSnpLVVNTSDVUeHNSM28y?=
 =?utf-8?B?RFNoRGQ2ZzhhSE11UllhVVRSUDZOVDFwZnhSM1ZLSEJZUVJNZmV0VTN3Ny9H?=
 =?utf-8?Q?A4An9cjpbgQdH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1Fpb09mNWlCK0FNQ0xFeTYwYTNCWVpBeVdyVjVZMHNPZ3hjQi90ODUzZDZT?=
 =?utf-8?B?VEFnMUNrUUVmRys1T1JJUk4rWmg5enJhbmJJZmVFUm5hNEhFQUZ2ZUd6OHpY?=
 =?utf-8?B?T3BnRFZHYWN2WGFvTE5uenBxVWoySUd2WTlpNEtyMlRTL25hVUQvL29RWC85?=
 =?utf-8?B?RFNyUjZMbE5GVDM2QmZYK2lRMTRUZEVOdGFqWGk0QW94OHJZcHBxcnNlR1RQ?=
 =?utf-8?B?VnJId0Y1Qm5XZStibVpKenlpd0ZQSU9jS01QQ0hxOE83MWZXanlhVXFRMlBm?=
 =?utf-8?B?TnZGemhLTlFGOS9FZTVKREd1OVMxcGVjU1p1OVRETkpnSXFMQ1dxWGo2Y2kw?=
 =?utf-8?B?R3pWQ0xOeVBIZ0FDWW85MFpEdHdxbStmbTlReGYzSy9MU0dyVDhtcnZsOGhS?=
 =?utf-8?B?dGpzdDJIbDY4QlN4S3IzVnFtTlg4ME9EMnNjazNkQVFpcUhnQVF4VHA2cXZp?=
 =?utf-8?B?WWFPdkxEVFMyaWV3TDB6WSs2RG5uOVJKOXZxU1BpWWh0a0ZFT01Seis4bW1C?=
 =?utf-8?B?dVBhMHg2b2lrZ0NMakRsTDAweWlrVEdvT2hYK3REWi9sbFJCeWZQa1pjYmtN?=
 =?utf-8?B?NTJHMHhlQWpGUk1UcFFVYmRVaDA1UzlMSUdDSW92ZEoxWkVCNXgrUHdhUGpO?=
 =?utf-8?B?SStuN3Bnc00vL1A5WDh2K2UwaGErNlhHZ1c1OHljUVhCc1RzaFZOZkNIMGdn?=
 =?utf-8?B?cTJaeU0wcDlldW5PZzRRaE9pbWxGdUpWZUc4Q3ZiQTl2S2JJMDRrU256K3Rr?=
 =?utf-8?B?NFdKRFRHVnFmamN4SFlIeTMzZEtlNVgwMlNmTGdGSkJWay91NVhOZWhNZVgz?=
 =?utf-8?B?dGlsa216SUtZcTZtVVZIZXhZemhxeE95V0MwbUJnUGZ5SkU2QUY5RHAyeWl1?=
 =?utf-8?B?aTR0Wm9oYytvNlZmR2w2NVdXU2RDT05CWTdKQ2JWVzdFendidUhpM05jQ3dY?=
 =?utf-8?B?dlhMcUx1aS82RTFONEEwYWMrN2poV3RMd1pScXc1TW1rbHIrc3hyTzJyT2tw?=
 =?utf-8?B?cGlvUVZyYmR5UFBkTlBDTnZiaGIrMitLaUVDWHJ6KzRBdy9RSUh6VlRsd0Yr?=
 =?utf-8?B?eUdjS0VwU0JsZ3pMdzFuVUg5UlFkV29MSEIxNkh2bVpxcENWNS9STEl3djdT?=
 =?utf-8?B?YngySHExZWRWTFMxZFpUQkp3L2NTTGZtR0RlTWdhcFRPbzBYMFd6YXNGbjFQ?=
 =?utf-8?B?MVZ6bE5KcVl6b0o2eWM3T2lzZWxiS2RaVWlkNnErTGh2WXUxQ1FXaGt1NGxZ?=
 =?utf-8?B?c3VXS1JtOVdpSHRQNVFTWkx1TUZFcjRKRWQxb09zM253b3JZTFhqc0tGMjRq?=
 =?utf-8?B?T3Q3WHliMzZ3d2lMZ3FJem04QmxnOGlMd2VNcGVmUE91U1Q1c08rTzNEbzNl?=
 =?utf-8?B?ZHFlTVBQU0V2VU5GSXloWVdlVWZGOXR2R0t3b0JQUTRHL0oxY3Bhd05Ubzdu?=
 =?utf-8?B?Z3FrY2VDNVJNRFRNelFXOFhDMmJyNTkvTmtlRkczcHhVYUd2S3JtN0R5SHFv?=
 =?utf-8?B?VCs0OW85UlBBSVVKMm1wT1VkNWRpZTBGa0I2MXhHQmtJZENiUTBmbmpUVW9R?=
 =?utf-8?B?MWFYTjEyK2luK2lJZHd2K0hoMEFja0tIVkYwL1ZSbnlVU2RDTGF3dGVhQktt?=
 =?utf-8?B?Tm8rbkM2TUdKcW4ydkVFUzZlV0NwUUU2U01XZFRjZS9zVWVpL1k2K3JmSCtp?=
 =?utf-8?B?dWIrRWFDRDdjazhFVEdGZGc5a0F2Q0pMOCs5QnFEOENMUHN3TG5WdHZjOEh1?=
 =?utf-8?B?djgyZHI4aDI1V3cxTDNoTElkckZ4VXpMWU5FNzY3RE9oUldBL1lSR1VmbXRF?=
 =?utf-8?B?WXFnMVFDYmVHQVNBQno0Z05xeUQvTkRLcFlYejVNVjJxakNpdzhhanZ1V05h?=
 =?utf-8?B?OUdWYkdIWGQyWURCVXJkbkkzVlN4bVBNczExZ2Q1T1dVMElxcDYzUDlzODhH?=
 =?utf-8?B?Q1BGdGJTNlQvN3NIcWxTODFaOHp1SERPbGd0dW43Mjl5NnBVNjNMK0NMS2sx?=
 =?utf-8?B?SS9idmtOUXR3eWRobjJ4OGhubG5lL0gzWVA5bEdTMEhYT3J5K2hUNzc5YlpK?=
 =?utf-8?B?Y2RVUFpiVlV2Y3EvUWJESWpWWG5pNmVsK0NUQzFIeHVwRy9KSDdFOWttU08v?=
 =?utf-8?Q?aBQSrF78LIlV1s+BMP/K63E/7?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8Zdchi3gWMl7qQJPq2qBunFMWaIwLCQa3ME6PjQB8GwD/Of/AnXZwfpAaGO8Io+xI07C/VyhURD6OD2zeKrpG2mzKHyLcpyvgE7GgBH6rO6ylrv9NrADDJeyXKdgtaS5mhGEYaLpIywRvcxLIxw3X+TqT4r0lXp1UROsCTxmmikz8he5kuX56rERw33rZKEz7f3gpNGSJF0op13fotXjBNS4tvwNMnia8jDEyKCwuVtPLctJgiT/K1Bo+uGz1xi3W10HFcquWG62vh7CSiOpSwBZPPejFoD2NZNXBtN5Wrugxx9mpL9WPqg6qAH7TgphMsweUuqmZ6fv2v24IgJdGLihm9lYm0R5G7K+cl4CjVAu7nCkPOF27DjcnUy2RWYEwnTXfJM1eR4b36OJMgJ5HqfbD4HcQbn2y5/ehFTCe6WSO7tAgYGs31ZNRY36/Y9C4DuUS/3kELTzO4m8Mwx1CotyeWtuGJVHScaUwRDmY0jd5GI2p8Hi9ZNE3E7UEf+MJYgyTlYnqSRDkc8yncDCRfXM427vgWlsrngLk8QZazWh8yozbA1wNWkZ0EDcKSOSEOnMckRvJlD1lzSvwh/NLl8WM/tBKEiX2mkuoebnKzM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1a14357-b06f-4812-2d80-08dd739f01a9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 17:34:52.4502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9xhZYVZMZJUk1CXRKftoqsXL9kOUpBnFWDOQ0EvYNz6+J6n3mHUIor8Ubn/p4XM89iByM79vP6bUFKTznszvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-04_07,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504040121
X-Proofpoint-ORIG-GUID: CHYKjnWF-Ws_V-01x0cbf59OlYde0LlX
X-Proofpoint-GUID: CHYKjnWF-Ws_V-01x0cbf59OlYde0LlX

On 04/04/2025 17:34, Bart Van Assche wrote:
>>> Quite some drivers are using management commands internally. These 
>>> commands
>>> typically use the same tag pool as regular SCSI commands. Tags for these
>>> management commands are set aside before allocating the block-mq tag 
>>> bitmap
>>> for regular SCSI commands. The block layer already supports this via the
>>> reserved tag mechanism. Add a new field 'nr_reserved_cmds' to the 
>>> SCSI host
>>> template to instruct the block layer to set aside a tag space for these
>>> management commands by using reserved tags. Exclude reserved commands 
>>> from
>>> .can_queue because .can_queue is visible in sysfs.
>>>
>>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>>> [ bvanassche: modified patch description ]
>>> Cc: John Garry<john.g.garry@oracle.com>
>>> Signed-off-by: Bart Van Assche<bvanassche@acm.org>
>>
>> How is this related to the rest of the series?
>>
>> To allocate a reserved-tag request we need to use BLK_MQ_REQ_RESERVED, 
>> right? I don't see that used...
> 
> Hi John,
> 
> Calling blk_mq_alloc_request(..., BLK_MQ_REQ_RESERVED) is not the only 
> way to allocated a reserved tag. Another possibility is to let the
> driver manage reserved tags. The UFS driver only needs a single reserved
> tag and already serializes use of that tag. See also the following
> change in patch 21/24:
> 
> -    hba->reserved_slot = hba->nutrs - 1;
> +    hba->reserved_slot = 0;
> 
> Use of hba->reserved_slot is serialized by calling ufshcd_dev_man_lock()
> and ufshcd_dev_man_unlock(). More code is serialized by these calls than
> only the region in which hba->reserved_slot is used so I don't think
> that the UFS driver code would become shorter by using block layer
> functions for allocating / freeing reserved tags.

Now I see this in 23/24:

+/*
+ * Convert a block layer tag into a SCSI command pointer. This function is
+ * called once per I/O completion path and is also called from error paths.
+ */
+static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba *hba, 
u32 tag)
+{
+	struct blk_mq_tags *tags = hba->host->tag_set.tags[0];
+	struct request *rq;
+
+	/*
+	 * Use .static_rqs[] for reserved commands because blk_mq_get_tag()
+	 * is not called for reserved commands by the UFS driver.
+	 */
+	rq = tag < UFSHCD_NUM_RESERVED ? tags->static_rqs[tag] :
+					 blk_mq_tag_to_rq(tags, tag);
+
+	if (WARN_ON_ONCE(!rq))
+		return NULL;
+
+	return blk_mq_rq_to_pdu(rq);
+}
+

Do you really think that it is ok that anything outside the block layer 
should be referencing tags->static_rqs[] directly?

Even using blk_mq_alloc_request() would seem better than that.

