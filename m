Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E365A399000
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 08:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786090940; cv=fail; b=rNfwmBWwoG/6H3COpPKnu1+n7wk6Q4m9BpEgIvYTpHitdAH7Vt6lgyGiy+477t3tuByQmOif/JN6NaRXQdOdasK+dpLwoIfVjHZVHj2j3+tIwZrCx3PljaXnO6PSxXS8gyZMxWmHm75u7ZV+TkrMkAAOj+1GG56hINb8lWJynl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786090940; c=relaxed/simple;
	bh=B7tD4REi8pdPbQPIgN6SlfOTSZIZCsoiUG4ugiZsy+A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cEtdHNvPSp8EWVmYsCdveO2AyPh7Ad92LTMoV59QFDlNm+rdXQmNRx8PW+PuNBTvHSBWUMQqKX8PQ6AlcBFhyFBdNao+KbDDyQoVT1edQBrrcxacgriGNETbtNW795lkc8Tb826IpDQhWqxNtsKDMtgoHhq6IAVrMUOOU+H9jYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OTAfpdsA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aivTf7Xj; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OTAfpdsA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aivTf7Xj"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6776A1Nh3074654;
	Fri, 7 Aug 2026 08:21:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rt0rfLv++MIHbQVFnzzE8usx0yxQ/3C6TUDQHo1Zn1I=; b=
	OTAfpdsA1vh5nD4fhKSWTUemoKnRij9Ih55eMIiJrcK1v38ZZn3CFRwzbjL7B+NH
	f3Md1Fr9fGuVDf2NRzaNdQNy71Kn1u/6ZuIXQOljAtfykXaeoEb21Qxw++Et05k2
	lU4g4MqEvtz4JAFG/NFtyiOdUKd1gxB0IyzDcVgeT9vAY+NjBJ19WNbQT23dZU6o
	cRtipEIBptizSd7B0EGkCpbUZ6qp7mkuktSgaoe99etfvu57q2ydwBn6/AalNFDW
	ftxF9OFsCogpjvGpboVV9lgVXibGxapfbT9WTpf+KD/VMu2LafXHDI0KD9hHiG0M
	E+dAlGY5Mqe34wIy+H2Vcw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8e57d2g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Aug 2026 08:21:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6778Jv7V008041;
	Fri, 7 Aug 2026 08:21:56 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012009.outbound.protection.outlook.com [52.101.43.9])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftq45av9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 07 Aug 2026 08:21:56 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LcGsYcO8WLRMfw4vCarti5KIVI0LB+z5ub9G3odPg60C8C+M0d3GlLXin8JWdw/Tzy6khKueA0yelp0qx6O5TSbBI7VmZtRplYzRGb05bYjrFxGocyQwf36NltKvlhei8Hev6PgAUxmw4iRCvB1yuwf5WIvxJR9nywyzBB9pV4UzZwCpyRZj1GAIwqYBpAGyead8OGGZZ2H5XKTaV9wshpIx74ialPZiUeyNg6qmkJT7u/Nk60Q9HhXlrkVJ6kQgndr5fiFW7M36AXEBNKFZ40sCQY91GzdQn7T6x7FdCGRRdizO7FGyJAAT7zW9HA6vWktApic+WrDx36naIbSybQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rt0rfLv++MIHbQVFnzzE8usx0yxQ/3C6TUDQHo1Zn1I=;
 b=Bod2DaYJN44vxuq/VvA8tR0DLCQ7Y6Zzx7ALoexaDQwmZprf3ZIlpNtTaLWM8OnhbGwy3GpdQPRStQDbr3tlicHioLbh8NXhEJxfbRoN26zcEPVJvuhCXc7Cb5lwTDUD8bAXEfnk1uGI/rEnImg5z6wcCYzYw52/JNOt0SZburOUtLb5z27dusRd2onyoYY6RFNZgNsVrbgYibrot6cqpeCxomyvnde2wdxZLH+AVklH6cUIYwHhlitQFkm3L2MsT2Eda21uHI6TPfWeWncRhQb2yjCE8ZNnXCMgRsK32WwLvi2gqbRanh3ky3d5zo3cBq1xK4bDXFTSXbrUqgE4sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rt0rfLv++MIHbQVFnzzE8usx0yxQ/3C6TUDQHo1Zn1I=;
 b=aivTf7Xj2DmOqJjOCePGucytXzYQGpEN9Ulmgal1gYJTMG7eKcPxCVxD352lOQkIgJUcFsXSYtMW6GDPTSIW7GaUxnpI5V+ke2so3OqcXlWLPHOWBBHz4ngHJH6ZsTpSyPVa8TL0Baj/dUzVjo3XuzQ1j7PiE9Hs7Tkc+diH9y8=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 CHAPR10MB997723.namprd10.prod.outlook.com (2603:10b6:610:2f6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.21; Fri, 7 Aug
 2026 08:21:51 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.022; Fri, 7 Aug 2026
 08:21:51 +0000
Message-ID: <caa3b35b-2ce7-4710-931c-35c5884a8ef9@oracle.com>
Date: Fri, 7 Aug 2026 09:21:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 5/6] scsi: core: Protect host state changes with the
 host lock
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        Jianzhou Zhao <luckd0g@163.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Nilesh Javali
 <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
References: <cover.1785965531.git.bvanassche@acm.org>
 <d5b40794ca80ed83888a83847c293349e7f1de43.1785965531.git.bvanassche@acm.org>
 <6d4a31c0-308d-4f4e-9708-11a559137ee3@oracle.com>
 <b861a237-eb60-45a9-b932-1bdaa29abc46@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <b861a237-eb60-45a9-b932-1bdaa29abc46@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0320.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|CHAPR10MB997723:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cabbcf1-ada0-41ca-d700-08def45cee7c
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
 YH/2HZuLbVjcA+3AOEAwbOmzwhq1yonFy0ez5qeQqmbI6voHf2hHav5Emgwr4/tH2AdIQ77ocI5ijwI8MO4MAri44AFJ8hLMvoOKD1s4SQamlxcop0gChBxbtCZjInHsSsJ6h5qw7N/KjgAaOxIcE1L7j+PeKWBloDul4M9qYtF8vksDV2Zw7HMMkkp6+mrAiUZG3ILO1lLx93lEE7cH9k2Yp+ZSApGlRxx+FwjsQEcbqLxqLXGrMExC9wA/x0HDFwAGAvJR8ub/6m6uMdgMD9WZMI8btZoFNUI8E3NeXRhKpqzIyj4BPmfXa2icL6MWjRbHLFoZv5mwUZ5WcSGZrtuRHpSjHsaVilrXxpiZHro6v6kbU1oiPoPiZBebv3M+gTNvvc6FJ57p7P+LT7Aup08GY9qB4M6yFP+9nrbKroUFR+Rata0nFMshEd5bCu0T0uwNz9Mho1Ca8igHQ4njer9FzaSjS5+t+4c+ptBHpn/qupqvgU/fXT7YsD4HA7GUibMQx1oz7G0e4oSBaWxIPVKEFjR7RHBsnq0YuZhFU82UBAUrYHBj6rAfAYwGwUc0CMymMXzIJ+nZgnswBrpabXa3O0kimNTJDCA8qG522B0lWvSdeOQHpp6XcawQ4mHzDzhdFTwrtC7TzpePbevF70sQDnjH5OqnbPx9SIgs/FA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?TytYd0x3L2pMUS9BR2JsV25IbWNlSFNpeHkxRnNMalBZK2YraldUV1JYZ29l?=
 =?utf-8?B?RFpYbTcvd1RJOURJOUtQazdJMUExai9qN3JJRWJhU3czQisvVC9GVCtrclY4?=
 =?utf-8?B?SlF1STNGTWIvQ1d3VGhDNUhSUEJFekpkVWxZc1JreXZKQ1JUcUI3K1pOU21h?=
 =?utf-8?B?YXIyMFRvUXBHOW9XZE9WMi9aQi9JWjcxWVdsZ2J0ZjFvREZmYzZKYURBQkgw?=
 =?utf-8?B?NkRPbHVIVnYxMlJhVUNEWUpXcUpsMmVDTFBqY0YxeXJrUjRQVUtiV2xWZS9N?=
 =?utf-8?B?bVd5UmJ3VnlaRmZiUVBCVFlBb0hUeHJqSTdhODRGeHVFRmxya3BId0hVVUVi?=
 =?utf-8?B?bVJwNHVmQU1RU2ZTdlhPNThUZkczNlppSXNGcCtjMWxBZkU3cEw5TDgzYTE4?=
 =?utf-8?B?eWc0eTZWT2c5Q2NqRnpUTGVmR0FNSjRDTCtKa0JnRUcwU0VIUFJGRDc1UEY1?=
 =?utf-8?B?d3BWSUdScFJucFRmOVlOVUxQV2pxMm5ZYVpVb2lNakFJZFFlblZuK2dwOHRj?=
 =?utf-8?B?UDcybEdUb2tGZmx2VWRuMGZGV2pscDV3VjVaUGZyQ2VHMGNET3lMUHNVWEZo?=
 =?utf-8?B?Zmw3WjR2STlaU3g1VlhXSXVDMkpuVFJqK3VoWkZ5cDdpSWt0di9BQkFLODdE?=
 =?utf-8?B?dDFzNjdUYkMwOGMwaE9FL0R1bWRWRzZjQlBlWlhvZ25FbWljOUJQK0k4Z0pJ?=
 =?utf-8?B?cXQyMEpYVXQyRWZuOHRlS0JFWWU3TUdPYTVKU1Y1NDEwMnU4L3M1bDVqK1or?=
 =?utf-8?B?Ti9ncFg4ek5ENkFqajJ3RHArTXJDaUplbFA0dHRnMWVCcHJnelZwVURENFEw?=
 =?utf-8?B?azJqOG5PYnpjQ1lZOThWYmIxQlBqeU5TS1htb0h3QkIwaFhzRFY4WmZsYUFS?=
 =?utf-8?B?RjhyL2lYZnNlMnhOZHJ6cDVscXFNQWFocnc5akNzNHFqSFhZZU9mdXZ1eEZT?=
 =?utf-8?B?YWpDTHJmSzVYVzRoRm1jdFhLSlpDczZaUFlwZG1pVVlrQitIbTJYblFwd2Vl?=
 =?utf-8?B?aVFvanA2d1pERmhkdnl3cXdtUzZKaVdteGV1K0xNbUMwM2pnTDJBK3dCRlBW?=
 =?utf-8?B?YnJXLzlmZ3U0SEFCSmNQaVJDRFFTWnMvU2w1d3B3TmhiQTdOOEI1WXppaW9u?=
 =?utf-8?B?NGZ0b25ZeGkvTEZOMklQK29QNUdRQ3p4cjNlYXdkY3JQVExNMDhYQlhkUFh5?=
 =?utf-8?B?YU0wUEFZTmZnb1hnVkZGZmdzQWNBdit3RkQwQUJ2a0hUamp5eVVlQXc5MmtM?=
 =?utf-8?B?NlFLM3JVNGoybTA2TzJXTGh1aVJySUtCLzJ1TUpHOUVNUUUyV3d6N2pkek9p?=
 =?utf-8?B?VzNsaTd4L2MrRm5wdE5vVCtBcXkxdm0xekI2S2lUVDAxbDJTUms3UURBZDRI?=
 =?utf-8?B?Vkw3R3IzcXA2VTR0emx0UTR5TWt0TWJuaXBiYkxPTEVSVU84bjdkUFlsZ084?=
 =?utf-8?B?dmx4aWYrOHlZQUdkMmYwRlpjNzdRQ01oQS9ZZTVVU2dndnMveDhZVXFqVFBT?=
 =?utf-8?B?QnVKZ1dMTkxRME95YWIwNTBOb05xSDB0SDZEYTlUbGtoUGd0UEFjNnVEZlBK?=
 =?utf-8?B?bXlrVDdteXRPWE5hNDJQWHFtOFlsZXBWN0NJb2NJRWg5Zk9oUlpLRUhRdU9K?=
 =?utf-8?B?Q3ZFMjNqZXduVy8vWjFqOWUyd2VsN1hnd1ZybnFHTnpIODVIUlA3SkpuZVRH?=
 =?utf-8?B?UWYzVnRCUXEyejMycHFnL1hRWUk2YTlHdnN5R0hRR1NrNEhPa0RuclBDNUtK?=
 =?utf-8?B?SnRVZVlkR0tjcldMeUtVc3V4N1FWWE1KZDV2MWh3OTYvMnpPVHQzdTgwUDhF?=
 =?utf-8?B?M2toM294QmcxNkJ1R3E0T1IwQmd5KzNLdGg3bS9VSVZiU2VEQlgrRHh2QmlB?=
 =?utf-8?B?Mk5ydWN4cWZuK3B6WU5nWlRoKzl0ZXJvWTlFNXNBeFliMlJBcXU0RnJzUGNK?=
 =?utf-8?B?VGMyYXlCVUVPTWVmaWxya0pmdGtDVk5uS01zdnoyeDRYTklkank0aU1VVDNR?=
 =?utf-8?B?SmhjSVBhMEhyNVY3cEdLMHZ5RmxiZDlrblRvWGJGY2VGbUxiczZzeTBhY01G?=
 =?utf-8?B?S1Vhd09iR0t1SVJtcmN6RURNT0VLcit3YWR0eEloNVluV2cxZEJNeXYvdHBY?=
 =?utf-8?B?alZxOGpPL2pMUTQ3YTBvSHJmMTd5dytQUVAxMFhhMFprVWNLNVE3TU5JNSts?=
 =?utf-8?B?eXRTTHlMcmphNzZtU1FLUEVFT1pvM3hWRDZ6TXVkSlNWaW1BbGdUR3N3Qldh?=
 =?utf-8?B?NW5Gc1ZyMWxzQkZpZk9UUVFISGhyeTJIR0xaVW16RkJxc1FmbFlmeTB1eEZM?=
 =?utf-8?B?T0FLaW44bVQzUXRPMFg2ODBqa3pSaDE0dVc2STVYbVNBWlpHR3hNUT09?=
X-Exchange-RoutingPolicyChecked:
	ZUyxURBGtbHVznWIN3C7IRQ4si1V+BN/NOeokhl9eDndKwPzvhzCiuiT5jJ6W+n+NNZzqCNQi2TPbHUA+Y0+/AXN4nS3W+/JlqgNftxLqry/v8mjAaqzttWZYfwhtLp+nduLu4osQLvXSRwkkXm0i3ZVm65Ns19CjTsaJsCvPHIXdQaIoNjy+oCWXwljmgllIm0BL/ZoC2ow4klgDcooBfv9KMhrAISGrzOhTHAawYbD7NBKeJe6+b1URmZXrzkANJg7vdEAWUObTilL5lg/zH0Ew2PJf9QLiZgDJ6ssCxdqNeHYgHsUA67eiDnH2oHbh/Huo8L9z8ND85f3lSN4qg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gZ9zO2qoZpbtmLliXy7TZal1a60uxO2yts2z5sO4Yb5A+2aOcyh/4GaXJ8jA/PX9qQ4UgqKib/0eo1w7eAsHt2W147xhEno8pwBtH+IB/viEPgbm9+KdGL+ZUaD4N9NHVZW4uYNShZMiKPbLX34t4OiRQm0gFDZXqTPjVZ9tV5ONMDxvXgS3rfDzLs+J2TfwB9D0gfybBbEU2nKY9j/Z9uf7XDbgIPDeqaYPhO40EW81x6+fcZD3V82bhk7UEDzt0YE/0tubP34gmKhLg100dU5hIuRg3GxiBCvZ3l/99FFFxQ71fOYz4qrdvhdaTAYUvWnUnts3azWBpmtvFeQmr7157c+morzRO5plLYpkoIAh2BQChoSRBNdgcxET5Tivth/RetpaHsHIZe66jq1Y9iwXRUWvrHfLy40bJOoXowpCBjHa5+uDovvI9vGMZClfgLC9xcxkc9O81vxyeqqZtCxKDc1YJVzHeTWiL3atZKSZvn3m5rtqzc8ChYBrUIO4qSD/4VDH8G/rSx3WtsHMKW+Ev+Lw3reRfp1VlSY83BWj8K9s15qDTMD0ZXL+b1NGRC05vLkDduSPzn2Ngwx3+gbF12FPvTpuu3KhZjt0cY4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cabbcf1-ada0-41ca-d700-08def45cee7c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 08:21:51.7480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XV354+TOqtsvDvgpvMNsbU2pW0xjyPZNA8MVPUba1U3NYrAwMYyGElPrQtOIBkNh0E2Hq3KDoQaajx5wphWHrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR10MB997723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608070061
X-Proofpoint-ORIG-GUID: sJ3YDsHnFGm6H_yj4rNgqWdR-Dsjm85a
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA2MSBTYWx0ZWRfX9U32HTYMB7rF
 XlAtd9o0liGA2S+GVoEZjDmYuStUJvKe28Ze0lwFu1IXYBCxT8RseMAb/n7z/BQ8z7sN71hjjJ+
 R2ML+ZER7lZTkVcw6r0oSlrnzXe8iKcn82H+d/F11rs18T8XaSQx
X-Proofpoint-GUID: sJ3YDsHnFGm6H_yj4rNgqWdR-Dsjm85a
X-Authority-Analysis: v=2.4 cv=M/t97Sws c=1 sm=1 tr=0 ts=6a7595a6 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=WJULPG16Ci5EwXj-PGsA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA2MSBTYWx0ZWRfX/lNb+WRA9/vQ
 zfmGWfpZTyq3iDAzA476SVsMk2xMOu0xLoUW/PQl7QRvh3FXUWK3W2ZL9DoXqyfvDm4UoyxzkIY
 QEDC5bVYK0bLFuXoOcVKvnVJU6cCywWzdWceQu9Ek+qt2fDCatcD/SKlwtnj4pUdi4YmJ+Fx4G5
 lN++VD/Md2T+wpx7X+t1jLJTctoymJQmwYglHQIGbbsTFd8JPQEJqG+6KpuVFFFP35GX5WPy1ck
 NNY86LGcWDv4jD7SPpPD7ED7R/yhokS4uIdWUseWJHE0c66ptj2T35Gog2BSuNisUMQWuXkTFBJ
 xt3WqQjFETy1JMGwXi5hS+nb54EmjkmWURwcEbXltUIze72vPBkmGmX1CdjzDKDt5yF/mcFQlSQ
 goHMVk9NgaasZwP1k7o0djS4ePnpA5/9AG6/j9L3UftlcYzF2YSz70Fvi0SLscJ0wEIPBRZjmYR
 LE5tW9jl3KT4ThDvqHw==

On 06/08/2026 18:19, Bart Van Assche wrote:
>>> +int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state 
>>> state)
>>> +    __must_hold(shost->host_lock);
>> 
>> How come we have this in the prototype and not the actual function itself?
> 
> Adding __must_hold() to the function declaration is sufficient. Adding
> __must_hold() to the function definition is optional if it has already
> been added to the function definition.

Understood, but I would have thought that adding it in the actual 
function would be nice as when developers analyze the code, they look at 
the function and not the prototype (and it is nice to know the locking 
state).

Thanks,
John
