Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14BD309DDC
	for <linux-scsi@vger.kernel.org>; Wed, 22 Oct 2025 08:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761121811; cv=fail; b=gwVv9rPzI7/Ov1ZzqPXFj86OtM0611kCA2WnC+KQh8+EfuNm6INOzJ7o1vAPQx/lypn/FGYp3LBZqgiRdqGPefNXDYhyHkhz4Gh0JJaMqDn5HvN5U5iyPLw59T4hlKiUA5YpTly+tt8lx0kVRquGpdrlvgGQQtEx/xC0il9PTOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761121811; c=relaxed/simple;
	bh=vjaDdAPzcWhXr0evoqWRy+PEqCInuBL5BhEdPyv5aSs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ptclaHOZHnNSOc+dBTh9MOIcgl//V2W91dwno1vfLNwUCgnzOcOsA+gQzn2XH/V/4fnSAUa3Yy64iM7eQz6jbJM7yrjG/Xi2PbOrSMvbRdGW4oCXJj2kW1Bv62+/c4qS27L+fEaj7Oz0T6ZgORt55KQl3XeLr4ZNJwK4vg2tKt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nFhXrEVZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rTEGczWM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nFhXrEVZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rTEGczWM"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M8CGTO003909;
	Wed, 22 Oct 2025 08:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lRDI7/8YIG7d7NAFJFIWjfCA8dHhemcjDFXApCt5MoA=; b=
	nFhXrEVZ10R/oNw5xQxl7p4DV7npcqiKoJ2B21RsGUFQDDV+CMHHOo88nVC1jLYu
	AVavg3feaujnxoZSpyi6NLt3TRdonvIPOSqBF6B1fDJR7sGwaNVwIC/Vka9xWsTz
	d/Z7dEf5myFaLeWdfBMEdaCvWjZzKNKWiRWUOOypdgTJhzWzjxRx18IjcgDrj+Af
	yXGcJ6koLPZmbs7T5454APIxSNloMr6hvJ0Tm4k2KdkWyAbBQYwUEsencYDsqEMJ
	SWpmpl/ZgcYkHunmxucYC/111hzA8RGVZ5FTgkL+zdapSvgpHT/D4IyA/29969AO
	xZ63+ID3rOs0vAu3dy3u4w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v31d7b0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 08:29:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59M6Orrr032245;
	Wed, 22 Oct 2025 08:29:50 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012017.outbound.protection.outlook.com [40.107.209.17])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bdwm36-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 08:29:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iwb2gBTc8KgQE5o8gsecmutOjO22gXrC3737IaGH3eVDwsVc09yH0vFAADxpWWb2mQGPfky/opoGLL2jOF3Lz6I/8tgtN3JMtfX70kQN7s6GbBmSLhVvt36MgJjfNLUUA8YPI7A/QNA0LX4enckXWiAFVP9w7wVaJ6lxrhENwyYZXYHGlEdvjrqxwl9SPE6zSO7z4bq1R7xPtWES7z9xIvZrME8m6x8ugd6JQ4X+l4FsYQO5GLe/OJ3y1YC9A/QMyYLtpkESm2e0C7JIl2dHXHPXsn+L4BUZgrKujFYFZiULTAEbclLGBCWoRIH8XSCvadw4wSZfOXXGwNpWZF7ZpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRDI7/8YIG7d7NAFJFIWjfCA8dHhemcjDFXApCt5MoA=;
 b=kxiSLlR/rxDPq+/6Nyu79EQXAnfnZcTM5hvRjdT4Rhn4/0LVSOv97ijwcNaGtdisgMq+N5NX2zQVkfuYXYaTH7OguOnTyzFXSRB9RgldAq1QDOKYCdCz097m3ZKdeO0gQwAdbGijg1cp+2j/VERUZrE/b6cffhaXWDW5zaROwcTswKv27x37lW9OHWGKb5axSHb8iIFfObePGvu1jhmOo5zorgrg9l+TehH/VrTnuzMAQPtAbaCEMUMFyy9JE6QgyafQi88JZonLrv/eTvMGGZ13OSjo1uNjbYlqllMRUpoXxw7ysKmX/1RY8MWDG0MB/smq55uH+VWT9WISKsWl0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRDI7/8YIG7d7NAFJFIWjfCA8dHhemcjDFXApCt5MoA=;
 b=rTEGczWM2EDHQwAmBhGgs+dguqXvCbYQ+dlCxZNu2F2tHTtsiF9LHsusb5r+3uiSWf6rEorIHSOTk1hb56BznxAE2yxsSNFggYn/QsX8asNQ3g600JAKJCLgP5iWlvCS1CRgKl0UrOHYJDDU31+yz2k9XpfaKYwuBNYjvPgECDU=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 08:29:47 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9253.011; Wed, 22 Oct 2025
 08:29:47 +0000
Message-ID: <60f9a312-455a-4714-81fc-abbcf86715f5@oracle.com>
Date: Wed, 22 Oct 2025 09:29:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/28] scsi: core: Make the budget map optional
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251014201707.3396650-1-bvanassche@acm.org>
 <20251014201707.3396650-4-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20251014201707.3396650-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0691.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::19) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM6PR10MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: fcc5e405-ab05-42c0-825e-08de11452900
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVp6MG84MjZqMHdEcXc0bjl1Rys2UFgvREIrUmlEV1ZXbXRIQWNRTTVCdGxD?=
 =?utf-8?B?NTVodlMvaXNDQkFneUhFaXAwWlhwanoxUWRZRU5ZU2dVamw5U3EzNDZzaUVY?=
 =?utf-8?B?aVVDdmV6YW9LUEdtMHVRWVBWNXQwVGVCZnJqMU5DQ0IwQ3BwejBjNy85bTlN?=
 =?utf-8?B?aWdJZ2JEd3NRaU13alBEYkZnOGtTQ3hJSHQ0Yytud3I4SzFmQ3FEbmYyenRQ?=
 =?utf-8?B?OWx2ZTVFTmpxWk5GeGFQeFBVRFRYMjVraDlWNUtNTVhqeWptT1J5c2NXbU1r?=
 =?utf-8?B?MHpxdGQwaFIvZ1dTTm8wNlFGVitnUXRFVXRuUHJ3S3NKUnZWZU93QS9pUFhh?=
 =?utf-8?B?QVNTcUFpWFZIczVRT3dDenRNR3FndUFGd2NqQnoxVHFqNUttbFp3cXpKakgy?=
 =?utf-8?B?bDBldUZvZEZMcHZ1dG5aUElvYUcveC93QmlINjd5Z25aUXVuNFZ0bkxTVC9u?=
 =?utf-8?B?S2dVdlR4RW5FWk1Gbm5keDVJMUROdE8zWnlIOFo4ejBHVkFyOWhhb3VZcUEx?=
 =?utf-8?B?bE9NcXFqM3NXUEdPRC9pTnYyd3VtUXcvbmljd0x0ZTZHQjF0QUpia3ZSelN5?=
 =?utf-8?B?VUNVT01QRFo2N0wxMTZiY2FpaTJKYVNBSjlLcXFrOUd6dVlmRzFCUmhRVmdu?=
 =?utf-8?B?N3paL0dDWEZaY3hpeGYwMHZ6a081cnF4ajVJaVpKdWMvV1RndnRLZXpCVTJO?=
 =?utf-8?B?ekZWakJkektMWmpVM3BoMUpzVEFWM3dnK0w5Y3ZRVk5sU3NsN042bjZ6Tnor?=
 =?utf-8?B?R0NtM2FCNWlHRW5HZGRGVFc4VXpuL09qbFZuMGg1Ny9pL0tsNkU2SDdkUkRh?=
 =?utf-8?B?akFMQTB6NGZvczJ0a01QaU12MXNHM2ZnNCtVdlhZTnVNMXRHOWRxdjZpdExF?=
 =?utf-8?B?NXdNaDlnbHIzWEdLWk9UQWFuYnpEeTJpMUVtZGFtbXduMUY5T01EUDB2SEZU?=
 =?utf-8?B?VytJci92Uk1hTmo5a1RPcHpoeDN3dlhIVzVySW80QmJFUDB6WDhLajR4eEdm?=
 =?utf-8?B?SjRuU25qQjYxMWk2SkxoYkdPREw3ME0yem9ySEI5WUZPUzhUQ0VpOGJWbTdC?=
 =?utf-8?B?S1hCMmdscGp4NUd6SndpR2tPVmJDcHc0Q0ZHYUd3QVhPb1lQV0Q4c2Z4dW5i?=
 =?utf-8?B?RUx4dDczMEtJNUVKR1hHMk95ZnFzd1pCWEdBRThWZFVMZVo5S0JOZXMrSEgv?=
 =?utf-8?B?eEl1cHBzakZuQWwyNVQrczg3bnRMS0Y5TjlBeGhOS2MwWUg3WnZZUjV6WVBm?=
 =?utf-8?B?amRjTFF0Zm4wWC9iVkNaL3l5VjQ5Um9KZ3pCU0thU0ZERGI4VXRhdUlKYkxU?=
 =?utf-8?B?Zk9RNjhHUnBRWGpsZ2dCU0xnVE9vRk5kSVhSUk5yWCtpZk9US1ZvWjE3YkJO?=
 =?utf-8?B?SHFQdkhtcU5IK0tKbzJJQ1R2RDJ3NlJxRWtYb2owSXpDY1ZJWlJZT0xRQ0l2?=
 =?utf-8?B?cFFOeUN0L21JeG0yUlY4TjJSZjJlaC9YbjdaSW90TnBHczRsU2pqV0lDb2tw?=
 =?utf-8?B?U1QvNmtkR3gwNFc2TGxCeDVJZ2cwT2pHUnpjV1JhWDU5cXF5WGJmNjBFTnJt?=
 =?utf-8?B?aXlzNCt4cnNLTWhWS2ZOMWFINVptK1kyaFYvSUFNY0dQd1NudmE0dlBTTHpS?=
 =?utf-8?B?YXlXanJzZXVmeWQ2UzRWSDJZYnpGR0hhdlF1K29XSTExS1lrbmJld1ZUWHZy?=
 =?utf-8?B?MktHdUQwa2kvYzZ1T2xLNGp6OFc4bnRIUFcxRXRsWkdDZ3dTcnMzOEpINEFW?=
 =?utf-8?B?TzdHWnZYRnQzQWVpMGdqdUJPTmh4SFFPYnNXZ1JjMWVGdSt2eUo2MUM1K1dU?=
 =?utf-8?B?Tzl6aGlvSEkrNmxmWnN5ZmdLV25PRU8vWUF1dUtlcHBJd0lYUGZVckdMSWtv?=
 =?utf-8?B?d3BOVlFEaTJVdTNOREFpaklEdXJOYmc4WGVWeTI5TFhvU3JlQXdxQXlGOGE2?=
 =?utf-8?Q?nWJUWf6qbrYirR5RGOsfmKBVVTxUH/85?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MjVtRXNHZVlMb3BOV3ZFRUJDTXZnMXM0RlJiM1Y1dVpkS2QvOFFtOHBSS1lu?=
 =?utf-8?B?UmtUNkVpUlVQamFSblpncWxBZ3ZqRk84ODNGTTZtMEVSeUZKWGtndjZlT1pE?=
 =?utf-8?B?QklFL29EcllJMjJrYUNFUmZXQlh2NGVjV0Y4SThUZDVOd3VDNmVNVjFkZk9w?=
 =?utf-8?B?amd6MmhQbEpIYTFKcEQxbXlTWTNZSm1iQWpaa3lBRHVFdnMyaloxRGs2QjdR?=
 =?utf-8?B?UzRSTkp0VWRQMFp2RWl1TGxEcGY2Z3NxOU5vVGJmczVydi9VS1dlK2c4Q3Az?=
 =?utf-8?B?c3U2bVVKazFGeFVPOU04N0dZeUhkZXd3aXQ4UjVqUWNOR1JSTHE0Ny9FUkNl?=
 =?utf-8?B?YTIybnBYbnkwNHBQay9jVkI1Y0FIOWpuaUp6TDEwaGNFOWh4ak1IeTdNaTZF?=
 =?utf-8?B?UnBselhUWkJ6ZWZrS0h1azBrNVQ0Q2hpYlRPWTBINlV4RkJPNVE4NVpIa0F3?=
 =?utf-8?B?ZDdkRTNjTC9Sc21DQktvVnYxODZNdk1BUEJvU05FallXZVJhTVIwNVFZWERT?=
 =?utf-8?B?UGlaQkVVUjdNNDJ3MVVZOSs4ZTl0b0VWV1dOWmJybUhBelhFRHZYLy9jMFlD?=
 =?utf-8?B?c0dsb0k3Q25aLzZzK01XaHkwZCtWWjd4OUNqSlFNQXlTSVFWdVNvWHAzTG1t?=
 =?utf-8?B?dVNOUkNwdVNQRTI0aTlxbXJYclRhU1VHNDRsN0V6ODlOQ0ZZT1ROdkI5OXM4?=
 =?utf-8?B?endsUXI1TndNdE9wS091aFlMaFZtOXRDcjVWcnhYWFBsZjlWeVkrMVJXRzRR?=
 =?utf-8?B?UDdxSTNiYngyQnhLNjNXbnMwanNFSWpPSGZwRTZ2QUJSZUJ4bkxYU0llSmFP?=
 =?utf-8?B?Y1ptRDdCZFV1cjZaUmxLYTdSUURsUFFDOXVtOHN4QU5LQzRpOEYzSlE5akVw?=
 =?utf-8?B?eWVtK2JlczhPNFJGdCtFODVJNEFxL1FrU1JCNEljZEU1QXVFdnJDN0tyeTZh?=
 =?utf-8?B?SjZ3bWhKUW81SU4xbXlMcUxONjFXamk5RFpmTWZyOVEvaXBWUWRiZWFTU2d3?=
 =?utf-8?B?RXFpSUo5ellUV3RISGs1Qnhxejg0TTllMGdtdndpNE5NSDFLYkhmVXBmVVF6?=
 =?utf-8?B?TWI0dFo5Z2dkbGJFNzYzK2lmbWRWZUZKZGkyUWY4QU1RNkNPMlpSVU01eHVB?=
 =?utf-8?B?ZURrMDFWTHRId0h2NVBySHlSZE5wQjVseGFlUTBqTlJBbksvaVorbHNVdGJm?=
 =?utf-8?B?SkRoSHpGVzd0dGdmcnZxYnBqMVFhMnl5VUtxL0RUcVd5VEMvY1B6M3JEVUNF?=
 =?utf-8?B?Rmt4d0J0RytJbkMyMkJNN2lHaDlpUFAzaGEvL3hTR0xYOU0zQ2RWTm5MSnho?=
 =?utf-8?B?Y3R1bis0WldDSG9kNG5uZnYzVHhwSys4b1ZwSytiTEIybDNNY2JzS2k1OUwx?=
 =?utf-8?B?NVBLeWcvek5GZDJHMjBBZmRzb1Z4aENJN0tBUndvcVhvOEZlZnUvY2VlN3M4?=
 =?utf-8?B?cGtHTEJ0RUFlbWpsS2dUT2VjeHJnNFFXKzJsV0NOQ1J5QUM2dXoySjZVa3ZU?=
 =?utf-8?B?cTVnVEVYaElKbXM2bC9uRUNmWlhTZm1aTWJPczlmSUczMzBqY2xsRmIwL3pR?=
 =?utf-8?B?WExLMllBR29pRnBvNXpHUnhvcU5VL3YwT1NUR1NsSWNucWtOeURvL2hYaFMy?=
 =?utf-8?B?bU9aNndPMk4wTXlwSm9PN3hrYWthUG9hcHN3c05saCt4NnJSa3YyeE44TW0x?=
 =?utf-8?B?WHJ1SGpSeERZNndSMzI3Ri9IQkNyNGI4VmNkeGxCRXpoSVRkdTZVb3RsN1h0?=
 =?utf-8?B?WXVlajNBMHlncnFkaEtqa2pXNjdSbFR1Mk0xWTczcnAyZkdBdG51Z2dOeTNU?=
 =?utf-8?B?cEIvblRDNnExcjN4TUh5cXp0cWovUzE0aEg1M3MzcjNDNmpIN2wrZjR3bGRN?=
 =?utf-8?B?MmpuTjA1Q0pCUVNSZkN1VDgzeERibVFHclEzT3ZTOEVRTXdteUg1bG9KZXdx?=
 =?utf-8?B?NEhFbEw0REZCZE94UzRhRm9aZ2ZxQ0JweTRGZXczM0lWRVkydnJ6SjdwQXFI?=
 =?utf-8?B?VUZsWVFKd0sxWXI2UWwvazJKS0l3cGQvNEZxN3M5WjA1ZWpEcEw4aU9BN1Bp?=
 =?utf-8?B?SlBrZ29XRHJRQUZZNFlQMzh4OW9tNnRxZUJtUnZYOTNhSkFzZHlBWkVnd054?=
 =?utf-8?Q?EEEyvWd/571rSQJcjzJUVjftI?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iPGfYexizgCzQT0tn6TZohqIfNvVtc0MKeMgJlKPGTqv3s7kz//uDXu0QJWjyxJSlm2DCEwqvNTX9jIJgaZBKz1p/+62q5ghisRdQU7anbjr4WEO6SKSKJD5aRo8ScxiwiFSeMXXOuCevuR1bdLQhNTHQwUpnZsaz9khkOV6xRUFlGj8st+lwdhGVBBC/yCTJjbiPwhXhmCh7vbEG46Zo7ANirn5dEH19LIJ2Ni1hVTFBi/E1CiyEhpieCGI0rg4H1Xa/yAB8+jDiiHPOxpodbkbzITQ0LwVevK5xPEEwJHP8wWuyoSfkCF0+UzzBjS7aD8GqVALKwb6Sr++c+26IjczmddOrbVvmOZkzGzyFW3wP5KXN+sh06bkmvcRT3N2dk9T54gdch+QnZX8XEZyczz8Yxcwr/KmdajBlAG4OX6rWHqqfBtb72dos3nP+64X3CV/UvKDKFCNNhKl4PmFRmVpC5KFMtXBRFnlPXf6SMaCpuu5RcPBf4AjLeuKP/IIuqbFbamnEawxH8HWrb9IWuMOIarFfyeQXe6MDa8McMQ3yPTjTMAH4+33LMS8ephwxr1Hm1/l2t98wDnk08QF5SjmEXa1OSEJkbdnAT9vvuY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc5e405-ab05-42c0-825e-08de11452900
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 08:29:47.3427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsoaQTkCREHeQr8Oj7LS7vtvdWfOY7VOUPY1EQl/VDwhF6I/qiYLXjThqH5iT1Vy2CcYMCKRq84P2A65Y3axiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510220068
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfX6Gf6lTWCuAUl
 0k+iehMByJvetT5Zx1OJDNMIf5yTf5QlIXwtRMOGh1zMdYi0rdWYQ5j9CqLoVi99zRxr+w/dnsR
 4ou813Z3SyGmytVIb/lW7OOrCKYMd9wpHAwM7v5JX7bfDbSLg57xPBHz79s9jhvz2p0ZVoWDH/N
 cj/B+SwjLNyKqcD7JnSnVFcmovLX4Y5yRwl2zCK4Hkni9o/V52HiNEBYGipcjLxaN5SO/CbQJF8
 dHwgqrxkK2HKIX0y1YxH8cd1PQzoSU5HjpJG+XFx5wc1rT8PPFE++UcMqLEK4bSDnoX6oIafgXu
 vrwFqZo1fxogKCnaHkfeLpySFNpumooefr1LwgJuGFLH8EbINogWfT/fTwoXmV+kzcLVrnLHnYg
 4RTAxIjDnF6AWNP/xAsWLgI8bz9+r8mj9u9QhOkKuLw24gTxWsM=
X-Proofpoint-GUID: vX6qiDta5DQ002yGpqPmefQb5fBkIfWu
X-Authority-Analysis: v=2.4 cv=KoZAGGWN c=1 sm=1 tr=0 ts=68f895ff b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=8E_EsU61KpQASj2CJX0A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13624
X-Proofpoint-ORIG-GUID: vX6qiDta5DQ002yGpqPmefQb5fBkIfWu

On 14/10/2025 21:15, Bart Van Assche wrote:
> +
>   	depth = min_t(int, depth, scsi_device_max_queue_depth(sdev));
>   
>   	if (depth > 0) {
> @@ -255,6 +258,8 @@ EXPORT_SYMBOL(scsi_change_queue_depth);
>    */
>   int scsi_track_queue_full(struct scsi_device *sdev, int depth)
>   {
> +	if (!sdev->budget_map.map)
> +		return 0;
>   
>   	/*
>   	 * Don't let QUEUE_FULLs on the same
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 746ff6a1f309..87636068cd37 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -749,6 +749,9 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
>   	const struct scsi_host_template *sht = sdev->host->hostt;
>   	struct scsi_device *tmp_sdev;
>   
> +	if (!sdev->budget_map.map)
> +		return;
> +
>   	if (!sht->track_queue_depth ||
>   	    sdev->queue_depth >= sdev->max_queue_depth)
>   		return;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d52bbbe5a357..53ff348b3a4c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>   	if (starget->can_queue > 0)
>   		atomic_dec(&starget->target_busy);
>   
> -	sbitmap_put(&sdev->budget_map, cmd->budget_token);
> +	if (sdev->budget_map.map)
> +		sbitmap_put(&sdev->budget_map, cmd->budget_token);
>   	cmd->budget_token = -1;
>   }
>   
> @@ -1360,6 +1361,9 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
>   {
>   	int token;
>   
> +	if (!sdev->budget_map.map)
> +		return INT_MAX;

For the record, I would not do things in this way.

The shost psuedo sdev does not need a budget, as mentioned.

However we complicate the code and add extra checks in the fastpath 
(like in this function) by treating this sdev as special and not having 
a budget.

> +
>   	token = sbitmap_get(&sdev->budget_map);

