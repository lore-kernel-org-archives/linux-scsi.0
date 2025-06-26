Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3182D12E1
	for <linux-scsi@vger.kernel.org>; Thu, 26 Jun 2025 08:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750927027; cv=fail; b=hvx9tbZiFin/ahBaUICPhc7XNy5WCdzThBlzMgb83CxxyO1NxoPOTsam2whpw/dZgAUvEnV0Deh8WJ/KXdtwOo1dKAbXhYFB7O1WcSQy3vwurAa1HrrFHB3fHEckJCXOGtT+q0rjnaoQ6NxKevNMH/L+vVbBy8zcRWTJcMitgXA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750927027; c=relaxed/simple;
	bh=XFb9eEveFPoVDjhXordppQgpuvx9NRjHYn4BTlxilsw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KlBHCpPIKSD3TySsblRxJi5EAPrlBbm8yIIr755YRHKPAweFFVd+JS57oMqnJ2zVSLIlvxAPwQsKxie8q19J0L/3S7STGeNlPCw/w9yusCNp/cydUsrdQllnZuijT7REGw6IdWTmNHT+IFYkyuXbk9bWzcAxBMv0B1J92If69JM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c4DxWceH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QF65pwxM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c4DxWceH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QF65pwxM"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55Q7fkks023196;
	Thu, 26 Jun 2025 08:36:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=FmzXlL0/GmcCN/VCfUfDYpP7ApGDYIb2WnvMn/7MsXA=; b=
	c4DxWceHsH9+ihkPvIF70BuR3ZR4/8Rw7cqEfRvFwtmHxGyQ192xCkVDcVn9GtY4
	f7nqGt+cMblaG+6wtagRpliqI15z+iKU6WKVEah66+64iQHXeeralEPsX9XRgdRX
	3Srhhz8hqZXkcGKF5uKdH6P8uVSmpsyHwx91kxH7/jT7yyFchRclryT9VXn77sIV
	kUkqSgl8bBG1AzrblZE8JSfN3FfnUTCCoFC81zk9T+EzAT4yBqIpfVr+fHzMh36W
	s20AD4FLoQy8JQ/xRbhqLPPhuT7gsIL5668VtdI65YjdQCR2siTK2xusZmROLvWj
	eLDhOQ+9Vr3peBpEJS3aHQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47egt1g3wn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 08:36:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55Q7kKOD016850;
	Thu, 26 Jun 2025 08:36:48 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47h0gunf5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Jun 2025 08:36:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PJ054IcggQJtBH4Acj2kO1hRtV7iC8qGViEzxZZzz/nnwh+gy3JKE6LMeXyR30S+WCTYRJONrBVRhtneIbsUfYeftHbtzUqdl0LLvvf9GtqwLGwac0RQpt5f9OjUwVqKW+aIPfp13/Ec2wFz1BzbtS6RLBkd2rgwZBOOjI80i2/SxKUCrGT4WYRXXfEg+WhpcoW0TC8EqcpBL0IhIKQ4iifvau5qs8f5aJYCB7NqKV07uEcQSf+U5BeVpnE4GRC7e5quVL2NhQmA/mBDSvCZJaZ1wS4wmJq1Yso4poQpTnh302mWH8oOQs6NRhN8l0uOz8VuN41/FLzFXBZQBHA6eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmzXlL0/GmcCN/VCfUfDYpP7ApGDYIb2WnvMn/7MsXA=;
 b=fZN9JOmOXA3kdkH6oX3FX+jPODSlfRrdMmZ7CTUKtIIR+KMRHG7UAi9QIyyF13mWNbYnSesvQJ7PbXSXjiDVu0kWEGcdN2lCYkwXyc9GgDKgj3Ezy+Kw9uHX//mgvoku+CYsyOT9Wm6lNALMUHE90C0mkamkPQiKi75kjAGftZzTgHGUTnqMBb/zULUqalK2r9T46g2kTANeCKphgi3D+GVNaydmwwoeFua1UiQ84dsAcAC3Gzq1FFcWiqu8nlKqGuEWiFbmv8nvSuswDKFIh9fh7cqck/8f/anr1cNSa5N8rET9qXNDPNHjc6ghQx/pQ6RgbGLa85h9H6Efz0e8Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmzXlL0/GmcCN/VCfUfDYpP7ApGDYIb2WnvMn/7MsXA=;
 b=QF65pwxMXzrK5yo1aLtPUzuTLq9oqpWGVZrQPGEZPI2EjyBczLgzZQLopHaNt94bCJHG3IsGc2zDu5xdFh80zx09SnzO5IRCCOw58LrN2ULwCz5rXZPo5IooWgfHqzcGLJ+XtDqAQHInBDrA4lIw8wwR/8oNEJ02SlM4W09Qirs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB6762.namprd10.prod.outlook.com (2603:10b6:610:149::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Thu, 26 Jun
 2025 08:36:44 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8880.015; Thu, 26 Jun 2025
 08:36:44 +0000
Message-ID: <302ceae2-176e-4c89-8f44-aa2169ca2840@oracle.com>
Date: Thu, 26 Jun 2025 09:36:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: core: Make scsi_cmd_to_rq() accept const
 arguments
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250624210541.512910-1-bvanassche@acm.org>
 <20250624210541.512910-2-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250624210541.512910-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0004.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB6762:EE_
X-MS-Office365-Filtering-Correlation-Id: 180e2b2c-dd14-42f3-0bdf-08ddb48c94a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RWhCMUUyN25qaStTcTZoSEJsKzdEV3RGaHRvbjZrVDdyMGR5NkRSVy9ESm44?=
 =?utf-8?B?UTVLM1pSc3NDNkR3a1FGU0NHWDVrNEt0QW52WWdESUtLSms1V3NwZ1I0QXFz?=
 =?utf-8?B?MW0xdHZ0ekhPUFIyOU5pL0pkWjBjeURVWHlzSmNHY3J0dE5pL2UvdmdCemtD?=
 =?utf-8?B?eEZWb3V1WitxRFh1TVVFYWo3RUoxSDN5YWxBdVVITDhEQlNCY04rSTZuZDVG?=
 =?utf-8?B?MGc0V2ozVk15WGNjWjkxREZUQUp0Qm1aY3psekpTY1NjWUl5NnI2VmlCeVIv?=
 =?utf-8?B?czJMdzVRd2Y0a0kxTm92ME1VQldCVk92Z0V6dDQ5MTFPTFFOb1E2cEZXNFZK?=
 =?utf-8?B?UFZ1d3FjazdXdUlrNzFpdlYrc3Y4MFg4L2xoUVFqKzMzVTlZRmxrNzFoWXhZ?=
 =?utf-8?B?L0lpLzB3MEVRTGI1Z1l0NmRTOFMvYk96QTR0L2Y0dkZXVGsvdmtWeG43YStH?=
 =?utf-8?B?RndPb0o0Wk9NL0lrcHNuR1p2ekdOY3hVc0hYTGVPTFNRdEh2N256Mmw5VnVG?=
 =?utf-8?B?RmN5NGdFaG92UmlKVkt6b215c3dFZkxQR1Q1ODlNcHMwcGJsNzhjYys4YVJE?=
 =?utf-8?B?bTFPRjFuZU9vaDhuUVZXeDV5M1U3RUtFeWNZUFErUitlNVJjSE5NRHdXYVZD?=
 =?utf-8?B?TW8ybTVzYU9SR01SNm0yVkJnbzFrU0xJajczUmpkRUNreFoyaWVvQmJQRWho?=
 =?utf-8?B?M3pUbFpqVW9lRy9KWTFpemh1NEFremNzOEMvc1V2K21Qa0F3dUYyK1dxR0Jt?=
 =?utf-8?B?eldtSDQwMXRQZ3I5SXcveVhBMEVNNTA3bEZaeGFoQitUMmowUExISnplUlZq?=
 =?utf-8?B?MEZiM0ZKZEZqd3lDVC85emJWb1hlc0piME10aW52d0JnZVRoVllKbTAxTXhU?=
 =?utf-8?B?TUk0bmhRcDQ4U01wL2FUMXFSazRIdm03akNCY1EwV1psVEk5ekNnRWY0V2tw?=
 =?utf-8?B?V21NN0VUMWlkRUdBZDRVaEp5UHdvYUVPWlRscDU5VUVnclQzR2JtMHVLZkhD?=
 =?utf-8?B?SlM5Y0dUSkFwZ1YvQWkvbHlJQmFnTFpaTENhUElQampncnZvcWwyRlllMitl?=
 =?utf-8?B?dTdtTUhiT2ZBL0x0NUJIcXZOYlhPejdEM3FVR0c2ckFyZHRQc2diQzVEY0xR?=
 =?utf-8?B?WTI1TmcvTCt3L2pmV08rSkIvUG5pK25rdzFuOVhPRHFWbTMzZU5OMGVaT2lx?=
 =?utf-8?B?Rmp0WnpvZEpaRFY5aHYyVzM3MUVWK1lKVHJ5SGFLenBWKzI0ZmoxSWhJdkNE?=
 =?utf-8?B?c0VBeVBmZzFiOE9kQVRYS1FDdHpqWWNMQ05yblloM252UDMxRFE2NHh3bG1O?=
 =?utf-8?B?dGU1U1Zja3NJM2J6S0NVQkZkcFByQldLWEpmNmNrRWNTeFJVS3ZNQWhQVHg2?=
 =?utf-8?B?VUxWUjUrK0dxZ0czYThsUGh6RzczUVlhQjQwLzhkbENnYk9nK1R5L1Y5bHp4?=
 =?utf-8?B?MWRRODhSbkhrS1JPR2toeGlzUnkyblltWVQxSVVNa2dBUHNaWXptT2JPRlBD?=
 =?utf-8?B?SDVTdXFPTWxsdmRueWt1Sm1IR2lQWVhtNDE4T094Z3VaZ1dYTVFoNldVWCsr?=
 =?utf-8?B?MG1ob2ZLMWNrSm8vd29xa250b0RuUHNRMEZpR1BTVlMwUkN1VHJuOG8zQThD?=
 =?utf-8?B?MTloZzM4R0w2bXdoV25KZ2ttb0wyZnVJaXB4RE1PYnVsdHVBQ1dyVFNpZ0p5?=
 =?utf-8?B?bDE5TnhqY1A4WURTd2ZhSXhtRGlJaytaR3lLcmNQNnRaOE5UWXA2bzdkUHVR?=
 =?utf-8?B?SzArcGVxVXREWVhHTytEQ1VXeXNtNEdzbDJrdjJ4cGlnWFlvVWJ3ZEMxbzkv?=
 =?utf-8?B?SXBzRkFLd1o0MWlMem9CdjBEZEJlOFplR1NUK2daOFk3TkoyeFJKaUhHbTh1?=
 =?utf-8?B?cHZuY0F0WUY1WUQ0V204dUNhNnFYZWh2UVRFeVFqT0tEZkNGSU1aNEdNaFBW?=
 =?utf-8?Q?JWV3PLnrrno=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGF5NlU0Z2M0bnNOcHliczVFVkpvTWZxNUhuYjJZMHRwd2gvVkxsZjUremVG?=
 =?utf-8?B?K2p3V0M5T3RiendQeHFPZjBvcVpPUDNUd1hFaDBSSXQ5OGFTM1BpQTA2RlQ1?=
 =?utf-8?B?RWpGTGVYcWV4WU8rR0JmakRBTDlmOS9rblRtTnI0UlE3YWY1b3B4SHhxQUt4?=
 =?utf-8?B?ZThmNDVpblczMUc3OUtLdE1CRGFkWFZPb0dQc3poYkNkNkdvamhxa2Q3NC9V?=
 =?utf-8?B?SmVSY2pFZk9VcXpwV3JUSWxvOWFtaDAxVmNWQ2hsc2ZSWVNMNDhVK0dUYlFT?=
 =?utf-8?B?MEtCNStKZVdXR2lUZHl3UFVZdTljMUFQeGxaOTJ0NTNITldjejE0UkZnR1hj?=
 =?utf-8?B?bURVUFZnS0tjVFgyYnl4bFdkSmJSOG14MWp4R3plejNvZ1dpQ20vU0tHSzZR?=
 =?utf-8?B?TVpNNml6SjJHM0lRNGc0VzlJazZVTUpJQ3BzcDZJL1BSZWtVS2xkOEVVVjli?=
 =?utf-8?B?azkxWVYrV0N5SFBjSkZJVXRyanhKRVd5S3hEK0ZUajE1cTBkYnVqcW1ZaElU?=
 =?utf-8?B?ZjR2cUM1dzZZR0dhdlJSbTBZVjJ4Y2JGR3hIRVNhVHlOQktSdGZ4U25wckdt?=
 =?utf-8?B?STR1TWRKUFowTWZIZWpGeUhtM1dtWGFUWVJDUjZ6aFRmc2xJeXU0VHNGWEwv?=
 =?utf-8?B?K1I4Z3NsdmU4QmpKb1lodG42UDYyRW1lWk1ZSkhHMmxFQUhFUElzR2l1VjRi?=
 =?utf-8?B?NHVoTHhZRlJ4bjBlbnllWDFSSkVCdFRLUjBldjg4bDdOaFRncmR6Rk9iRFg1?=
 =?utf-8?B?SlBFNUF2NzdQTXRQVHZuMU82ZWFVa2Q4SXVJUG9KZGRwT0d3YkFtcEtpWFZ6?=
 =?utf-8?B?NXByUFFjNHNHanBrU0FYWXdhUkU0NzR4L05aSC9kczhBekh4cGJUREpGbWh0?=
 =?utf-8?B?RzBQSXVQK2p5NlZZVk51Yk42cFhJOGZhUHpPd3JOalBHd0tKL0ltZ3RlQVpF?=
 =?utf-8?B?VFMzL3lWYklhRTZLdlc5c1lrVzJ4KzFpdlBleHFXTGFkZSs0QWJueXEyT2xs?=
 =?utf-8?B?bVFMNEZWR1RqUGJzOFJWbktVWXhQTXM4Q0UzYlcvRXRkWEM5ZFZwVk10WXZV?=
 =?utf-8?B?TXJzVldJQjEyMUdKaFlpMnZEUytPZ1lLVGpudithZUdGYjA5Uk9FZW9HMkR4?=
 =?utf-8?B?STJ4eEo2U0NXeUFDYVhXdkRzK1JaWkZaTkpFY1RHc3JTVHdncHlBYlB0NHdy?=
 =?utf-8?B?TExSNGxzZW9HY0tvTHFWK25HSWIyd0w2N3BwcGc0RXRLaUdDbm5iQXAyV0hZ?=
 =?utf-8?B?UE1jK3UzSmJ6ckpjdzB5NzNkaUxuSTBEV0dmOTI4SlhGakFER2ZOU0VyYWlE?=
 =?utf-8?B?WXVhdGJwUklGOGlMWXlwMXNpc1l4eE1FajQxNGV2WThqM0wrSVg0MDk3SmEz?=
 =?utf-8?B?azhIZXRiNEVNRW5WMktNenZEVXFxaklsSUFaYWthazJTQVNYajdqY2ZCT0Fv?=
 =?utf-8?B?QTZzSTNJc2s3UkxMd3NRWHRHandSUkJiUFM3ekFpMXppZ0RIc3F6aXdoWXZs?=
 =?utf-8?B?akg4dVErQ1MrQ3VpdW5wMnJMMElSVWhnRThzYXBndGFEQno3dDIwZGMxY2l0?=
 =?utf-8?B?aDNSS3pNem43Z1JBWm1SbFozVzVkTEF1QTYzbnlMMHRvWCtMdFAzaHY4TWE1?=
 =?utf-8?B?ay95emhnNDVKNW1GcmJmYzV0cHVuNzhVbkhyS05YOSszNFhvNGE1Y29qNEtr?=
 =?utf-8?B?cW50TStBVlJ3NUduM1ZKbElJSk5EeEdsL3lJWGR4U1FCRnM1eENzQXViWnAz?=
 =?utf-8?B?NXovN3pNZ0YwdlFYdGxVeUd6OTJ6cVY4cHBCbU03L3BVZkJuSms1M0NvbWN5?=
 =?utf-8?B?NHl3OFY0WksyYzg2bmZXR0NTeTJ1Z2FybkdOSk5leWMzOUJ5eWRHZHFINW10?=
 =?utf-8?B?STJhNDErN0RHYnpoZUs3cXBrVW5POWpMVHhQVHczeDVCSDJBM2N4NEl6R2Vi?=
 =?utf-8?B?OWc1UTRJeWNsK3hTZ1RxQVl5SHFnTHZuQmZrM0prTDh6RndDZmw3OU0yTkcr?=
 =?utf-8?B?MEg4MXNvTmZyZDFJczNVNTVvZ2J0dkFPTm5nZ2FkU3Y5WUpudWR5b1I0bnhi?=
 =?utf-8?B?ZzMwdVFhODNTVlFuQzB6WTV3UXorYXdzSVlMUG9sRmIvbUVYNGJxQW5qUkg5?=
 =?utf-8?B?a0svb01DZWNtVUoxS1VaY0lZbGNEUkx4Um9tczZSaWMwakxoa2U0bnFoKzBz?=
 =?utf-8?B?ekE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xYTN6CVqMxL5ntW17MECYlTu9rWRAtiOuS+hhBdxclh4ruPo4syjkROdQO7Dq/Gl4oL64dGDeI08ZXDs5+Hyb30Uf5ecat5hidSqPKbGanQADrWLQcrpfJ6zaKKnMGwSg2hYXYoSH0ffzrZhVAN1r9PVoEJSCKuF0Osu5Zxjm1bYQDochddHmnZYScINaul0YW882y3X7ynMiuQjfVfJdqAHPXHpdfwRsfJpgnJyK5h19fYyoDOrAv5qQz1uYw6TLmoC8E3gM1arfM9yWaTYqtznwm//cDolQHS4tjrLKHRl5Amb0k7MpT52r+mrYcmj4I91eKzX9TzyjsF2axfnGRHURrxnklWi3KqNZQ16N5BS+z5MP3G9Krr6e+1zLnadG3BBYYZYy2u4IKt//yxUTlE/iMFnx8rc/6yQ2d66zWq+E6yFXFFukAgjBRG8OvGiG/V7IdoQyGUNf7HMdg/BzOyKU1iwQwuBEc/mufCRceOeUSP2gYrPSisbHq8OpszbmDHIEC1HtjwBVrVKM0hOoEbLppFJ8Cp+pciLPY6VZakd1RBBA75vBx0SQA2OVMdai34PLOwdbpZTIE+VDKSM+MQ6o8JA2jaW+Ffz1GbKWXM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 180e2b2c-dd14-42f3-0bdf-08ddb48c94a4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 08:36:43.9905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGN1GG51lX2/LYGX1+Wm7+ELd3mw22jiFZlKm21x9HGd1TUPunRi5CZEolJdvWr9KncbQgj8Ht/CKS8h9UB0aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6762
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-26_04,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506260070
X-Proofpoint-GUID: Tx7mpRp6wfNO-KTs41lZw0rASCua23ES
X-Proofpoint-ORIG-GUID: Tx7mpRp6wfNO-KTs41lZw0rASCua23ES
X-Authority-Analysis: v=2.4 cv=cpebk04i c=1 sm=1 tr=0 ts=685d06a1 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8 a=8QV2A__SYSEjZZK1HAAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI2MDA3MSBTYWx0ZWRfXyZFlohuG1i6S xuvyoNV0dNafamWhmEOj0fmBQSSsRaVvN3mOVlRpJ/QA8vDsxTEe7mOZ3aWl9TqUuipZIA028hB wj5qpdx3NooTZ1SbYaCypsYhdN360V3zmuNKSTEasva6EmltZdeRFwX9AcQIw1qaykLzXmLT9pf
 HPKRYbGKODpo1rruzAEClqTPyBqyw1tPCyXHMfAXVF0Z7vqVbGfPAti8JV2Hb7RDA9ooSggQEmM VbIAVfDRn4BKDEQN8ITBOhrIvRFyQSmTwvPuS5IoVUIn00Nd63mfMSJ7hjJM2CzcEVZemR1Ppwe wbUjf149udEKncbYj7SjEvzPndNXuasAA1/n8+8Dmptin9sNMqWal3UycKPAFurQYtOh8W5bZec
 A4w8/98DDJuyHqQFcYUHK8Ah+pelXyd6iEx11O7FJz+q9C9ttQ4kDZ7Hut8cMgi3DGRE+3U7

On 24/06/2025 22:05, Bart Van Assche wrote:
> Instead of requiring the caller to cast away constness, make
> scsi_cmd_to_rq() accept const arguments.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_logging.c | 10 +++++-----
>   include/scsi/scsi_cmnd.h    |  9 +++++----
>   2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c

Is there something special about the logging code that it even requires 
that const scsi_cmnd * be used?

Or will it be encouraged to use const scsi_cmnd * elsewhere in future 
(after this change)? Or, further than that, convert all scsi core code 
to use const scsi_cmnd * (when possible)?

> index b02af340c2d3..5aaff629b999 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -28,7 +28,7 @@ static void scsi_log_release_buffer(char *bufptr)
>   
>   static inline const char *scmd_name(const struct scsi_cmnd *scmd)
>   {
> -	struct request *rq = scsi_cmd_to_rq((struct scsi_cmnd *)scmd);
> +	const struct request *rq = scsi_cmd_to_rq(scmd);
>   
>   	if (!rq->q || !rq->q->disk)
>   		return NULL;
> @@ -94,7 +94,7 @@ void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
>   	if (!logbuf)
>   		return;
>   	off = sdev_format_header(logbuf, logbuf_len, scmd_name(scmd),
> -				 scsi_cmd_to_rq((struct scsi_cmnd *)scmd)->tag);
> +				 scsi_cmd_to_rq(scmd)->tag);
>   	if (off < logbuf_len) {
>   		va_start(args, fmt);
>   		off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
> @@ -374,8 +374,8 @@ EXPORT_SYMBOL(__scsi_print_sense);
>   void scsi_print_sense(const struct scsi_cmnd *cmd)
>   {
>   	scsi_log_print_sense(cmd->device, scmd_name(cmd),
> -			     scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag,
> -			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
> +			     scsi_cmd_to_rq(cmd)->tag, cmd->sense_buffer,
> +			     SCSI_SENSE_BUFFERSIZE);
>   }
>   EXPORT_SYMBOL(scsi_print_sense);
>   
> @@ -393,7 +393,7 @@ void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
>   		return;
>   
>   	off = sdev_format_header(logbuf, logbuf_len, scmd_name(cmd),
> -				 scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag);
> +				 scsi_cmd_to_rq(cmd)->tag);
>   
>   	if (off >= logbuf_len)
>   		goto out_printk;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 8ecfb94049db..154fbb39ca0c 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -144,10 +144,11 @@ struct scsi_cmnd {
>   };
>   
>   /* Variant of blk_mq_rq_from_pdu() that verifies the type of its argument. */
> -static inline struct request *scsi_cmd_to_rq(struct scsi_cmnd *scmd)
> -{
> -	return blk_mq_rq_from_pdu(scmd);
> -}
> +#define scsi_cmd_to_rq(scmd)                                       \
> +	_Generic(scmd,                                             \
> +		const struct scsi_cmnd *: (const struct request *) \
> +			blk_mq_rq_from_pdu((void *)scmd),          \
> +		struct scsi_cmnd *: blk_mq_rq_from_pdu((void *)scmd))
>   
>   /*
>    * Return the driver private allocation behind the command.

