Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84E520E6F3
	for <linux-scsi@vger.kernel.org>; Tue, 16 Sep 2025 08:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758010888; cv=fail; b=T4ZKheisbao43oh2UI39FLBzTI1i2Bay2uOG0wwVrs6SYPQwRCy+Q3xxUYx5kSo0MBFVErqWi4acprX87oXPRONMh7y1QbU65mhoH1n3Ms/zy1xgqU5M3ZmX2O9eSe66EEqevQ/no7P4Ln4prsRlhinXzO8fArzzhlkp/+GSipo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758010888; c=relaxed/simple;
	bh=Sj/oZ5x/5pBpW0xzqHi1FBUM+LCh63FDoMEXc0DMVXY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rnjLCxQmVtORnO0E8/6iZSRIC4uTDi1jqBCNDzlDVryE1WO7BaP5KtcrmWQ17c09a9QUdl6+Ikq5nOALXGi5LGUuMtbj4pBCKatkj/yFDG6NPzB5q7ngEMSZoL/+Xcu76YmXW4oMSdrg5SUUAq4ewJvK5AISTglmxFJbxSjvPMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Tm1NoF1k; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lHcya8eY; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tm1NoF1k";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lHcya8eY"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G1hC4N012232;
	Tue, 16 Sep 2025 08:21:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Ng+7wICAcByZV4ERIqA7LDJ0lfozMxT9UluJLlJgokk=; b=
	Tm1NoF1kKE4JlHBLiaDujWJO8U7BtICQd4U4L3gI4TOYT6K6q6njOypO1fpM4m17
	r2dAts0gplD+BjJa3uEWEzURs7IqyFPutQBjA9ej76uewijfQTOYH2wBNHIX56uA
	IGGlhJff4oT/75V9Sf8wuyjRJnlKzW7QgPUjQAvRkuAHgPT92BWkDzvSkOUqQ+iU
	wc8yxBIKXtCq7XsfcJ3+Rq9d1EFk+g9i+4EAZRh8t5I3WxXigL8ne1I6tFghAkef
	cunryryTiFMvN+OrL285oA01ZwRrxUh0Q7J8gP9elN4kVDjRnRYxhwIC4y4VxkTa
	dTTF+ECHpNXXVl3xEn356Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4950gbm1yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 08:21:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58G70TJJ001486;
	Tue, 16 Sep 2025 08:21:14 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010001.outbound.protection.outlook.com [52.101.46.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2cakps-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 08:21:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpXM+WVN8EyaVd3YeVcldY90T6CYygu4xJkOZivVmAbYi50sB325WazW+07ByJkgvpZ3GFHMxV6uhVHrP006n04yPOsuRnGfiABBibtf78DgJsH4pnjrrqAAv6g3kdu8dq6JHZO71Uu9oWVgc5p5kFhqjdZdsEGenhCpuC0ggmU+h+x2WnJ85d1cZZInRjGLbiZTMMLo51OnZLbDS2WplyroefjXxqyiaS70h1N2MXPsVrVpVc032LR6D9MRC65wDb6jzDzFnniGa6pw7qAApRvz2QhqG7bxix/7I5JQQFK+knqm9vkphBocMeShGFSi8+4fVKCxORGA08JJ/d+mjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ng+7wICAcByZV4ERIqA7LDJ0lfozMxT9UluJLlJgokk=;
 b=Ic1vmQ/D/SrLdXPBD8CmATtjPDE7e58KWMyhP1x/V1yrvW11mP0jRiAnjQQ+thOFkZ4rjZyqX+K9IAkezPyR0VYERd2WGvGMluo6nLwBn4NLOoq3rslqyatLKT91/R87IM+JnSY+/kKedefy/+McO/mGfAvUnTIp7E7DQIqIi20l3IJKtCF+qERBYkO0rshveLz1kSUZrOh4kQeDmcDSB2EmS5ILDw3vPK1JiLNeya/8CM79mgPFKCmv5sOyBT4kiC8OtquBY4Vg5tJ3baKVSN0LTgYhML4iD10wBCd0NzCkB2OZ7ltpF8p+WMG3W1aqqrfL29gwJvDmBankj7PY8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ng+7wICAcByZV4ERIqA7LDJ0lfozMxT9UluJLlJgokk=;
 b=lHcya8eYBW3Q7CduQ/8PdfStyX8VZgzoOX3FIpmoo+/w+RVN9Y8bG/CulpWbO7B67LMZd6gskzNoQS11SnyZL8AIo8CIqvoqcUcXRj9YiTmC6vxUTScPAZj9k7HpBgUnkAAVFV6JEqwjxNIp3kzf19mJyX3PIf+SYCfoDZvSnNM=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DM6PR10MB4235.namprd10.prod.outlook.com (2603:10b6:5:210::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Tue, 16 Sep
 2025 08:21:12 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9115.020; Tue, 16 Sep 2025
 08:21:12 +0000
Message-ID: <4c865666-a2d9-4037-9762-4bed3490a4ea@oracle.com>
Date: Tue, 16 Sep 2025 09:21:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/29] scsi: core: Support allocating a pseudo SCSI
 device
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-5-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250912182340.3487688-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0201.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DM6PR10MB4235:EE_
X-MS-Office365-Filtering-Correlation-Id: 539d32c5-31ef-4e41-db18-08ddf4f9ff00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d3pqL3ZwL0Q5ZVBCMlpDOGlKYzd6ZDB1d1ZsU2lMTmNWZHhEOFI0T05GQUVx?=
 =?utf-8?B?U0o1V0diaGQxaEFid3VxQ3hlM0VCZUNFVnFvcGRsUERWcUxBaGRRdlVCZTRV?=
 =?utf-8?B?bjEwMUpTVUFXZy9UNWlIR3NGT3RwTS8zSGRPN3JDd1JwRXJMQW4yQjRMZjJ4?=
 =?utf-8?B?YlpCMERxeG1YUzNPWEhJbXdoRm4vcGF4TzU3d01ZTXBzdGgxUHlRaExrT2t2?=
 =?utf-8?B?UkV6Vks0aEVrTjY4TUxiUkx6MHMwK2hRQllzRy9mN2h0cDZDbGk3Q2gxZmxu?=
 =?utf-8?B?Q2tPRWNTeHRDckx3NXNWY1pqSzZYbjBXRlFqVUd6Yzl2ekgrYmpGb291cWVv?=
 =?utf-8?B?NW5vSFhWTGpuZks3Y1JBV3BYRHVQblpXTjNyaUpndHRSRDNLTjQ2M1BSeUNi?=
 =?utf-8?B?WGI1QXRpd0JFVnBZMDBwNDBzaS9lRHlaQW1Na3oyVUxsZEdqY09TZWJocXNs?=
 =?utf-8?B?cXBzSnRXUHdzak10N3J0MU5NM3lvY1FSRzFOODdrdlVEckZRZS84c0RqOFAy?=
 =?utf-8?B?R0JETGpEbCsvaythRFRpSXFuUlN0T0doNkF2YjJLNU9vQjRmd1ZTUS9MTFpj?=
 =?utf-8?B?RXVtZCtzTU1YampMYXZ5eFFyd3VkbWJ2VTErTXhZUzhPak4rVTRUWk91WSs0?=
 =?utf-8?B?OUxvOVRSNWVZcjcyQWVoVVVCUGRUUTZHZFpGeHRiZmZDRTdwNFBhMm5KZ0Z1?=
 =?utf-8?B?S1ZVbFdOaDNReGdabEtUclpNVGwzV2dYL0szSmFYTkdDdWtkZm9wczZnMTEv?=
 =?utf-8?B?NWhpMVVKcVRZdjFDTUtaTVNsczZsZzUzbUM5TUxuVGhrdFpxRnE2YnVDYlBJ?=
 =?utf-8?B?cG9mWHNDM0E3OVQ1aVZ0WUdvZVRWQVZHTlhlM3U4VFdyeFNGbHhOQi9wdUNv?=
 =?utf-8?B?YkdsK3REZVVmYUdGZzFYNHl2MGFRTUNUSUxjN3BrVWNxS3pHTlVkclN3elRv?=
 =?utf-8?B?c2ZIaGN0UC96ekorZ3NNbHRQQU5hYVNJVlRoSXNJUjEyOEg1Ly9haXJ3L05v?=
 =?utf-8?B?V3JPTkd5Ny9HbmZXaFA5TEpUd0JaZFk5NkV5VHhjVWhCd0lzUk9HSCtPYUgx?=
 =?utf-8?B?VFNIeUsyNHZnakhTOUJqR0VnVTllQWgxbnNNbjVpdUNsN0dCZ2oxZytFdGtm?=
 =?utf-8?B?Y0xZRHpZRVYyMlhZU1N0Rzh3M2dtbEhmWDBoRE5tVDRVaklkaEpoNVBCcUVh?=
 =?utf-8?B?YVpvVDZIRkM5aTdSNGdQTjBpK1VuMElGZyt2MlJjSTM3QnVBb0ljd0xwd0VS?=
 =?utf-8?B?OUFkL0I5R3ZNYmhVelFEL3BiRlNWTkVwMXMvbTloSjd0WkVyZFdLb3l5bTJu?=
 =?utf-8?B?SXVHSXNRbG5QcVp0bnFUeEFXK2Z5L3cvSnBRd2hWYnZsdzIzeXQ1QkhnZXd4?=
 =?utf-8?B?RzRFY1RFaG1XUnVrbUN1ODNhOHNraHhvNkM1Nm8xdG51V01MdHBibENaMWhq?=
 =?utf-8?B?cktzdnFXYzVXV2hiUDZGYXhzMU10ZlV2eThnSGVtU3RnRlJVSnNTa09HZHZs?=
 =?utf-8?B?YkxneTl0THd1aXFMM2VUcitkUEZ0WUg2VEhOdS83MUhVRkxnWkxMRFVaTWRi?=
 =?utf-8?B?R1BKWUI0ZmVKUGFYVnp3bE5WQkJnck1mNTBaYmZVZ3MzcWNOQkl2ZHIycG5M?=
 =?utf-8?B?ZVYvZmxZTTZwNkY4TS9sYmdUM1QvNGJodG5sTXhQc1BlOTU1SkZ0dVBEeGZR?=
 =?utf-8?B?VlorU2VJMEsyWVVzdVVOQ09KVTUwdHJLYzFQYVh6NTBuSE5VaVN6Tnh6cEFo?=
 =?utf-8?B?SHRVOWhvVE42eGlGNk0ybUlRaWxRZzFRN0V4K2tjVUhmTXlUYUZsVEFEZDhL?=
 =?utf-8?B?WEE4c2R3YnlTbXJaQlJsMi96WExaamQyOW04WjJLeVJBRXhCUHR3Yko1RkJ4?=
 =?utf-8?Q?cI5Zi5oCWPzjX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S204K2V1SlZqSTQxT0YrU0dtVlozWForaW9oL1k1S2Qwekh3QkxzM3Vtd1lz?=
 =?utf-8?B?SVprU1A0Z1hteGcvdFlDYmdPWG11WnNGTFErQ3FWMjhieW91TE9GNDIzRU9x?=
 =?utf-8?B?aUEyU1UrelF5R09nbTI5cXRvV2Y5OVd1UkhLMmJzdDdsVkRWWHZIQ3hMU0ZM?=
 =?utf-8?B?QWltMjJCV3oxenFRdWF3NkFpSThVQ3dzQ2Z1QmZhUUtXeHZTeW5tMHAvY00v?=
 =?utf-8?B?N3JpM0I0V1h5RFMxTkoybWVHOS9DZkY1TUZZR2FHa0lYOVJObnZwVmdQNU5I?=
 =?utf-8?B?RnN4L2F2aDVXWWtjc0V2YW9MWmowM1ZzY0xXWVRxdFhXT1p5ZTkxT2oweUw3?=
 =?utf-8?B?Q21UYWFyUlM4eFBzdTdJdGtzeFFTYXJQUm9kVzhxK2xlZDVTVjhwNnhLVWF1?=
 =?utf-8?B?S1dDK1RrblZ4dm5uOHpKWFREMlNML3R2cWIwU1ZwaEtkRTRtZW1iVGlXZnc4?=
 =?utf-8?B?V29wck9kbE9WR1N6RElaV05Yci9pMUZLWXF0Z1M2NlhuaEI0Wk9mRVpGQXhR?=
 =?utf-8?B?ZmhkNytjY0p2dHEzdTBZVUVITlZmdlZibFNMZks4Rm5mMHIrNkxxdUlZYUxk?=
 =?utf-8?B?dmJzOUtzN0JieWd4Rys2YlNDZ3IrTEgzQUxIMDRycDJob0F2WkdBa2pFNmZi?=
 =?utf-8?B?R0QySjlqOWhEbFZZWE83Wm8rU2RQSzFJMkxKbEg3aHRpaktHTWNONytrNE1h?=
 =?utf-8?B?R1QyODFLZ2dsTnBaczZGY1VqZVVEZEFES0hTUitKZXpwNk5ubFBMSmFIaTFt?=
 =?utf-8?B?aEQzQkxPNnFCVmtlalVOcnVUR3BVU0hxN1Z1QjY4MlhUYnNhNzlLS1M3TFNJ?=
 =?utf-8?B?d0V2MEFFN3hVSkU1V2d3SFZqRmF5R2xUOFM1RysrRE9mamJpTWdrUjJNRWFG?=
 =?utf-8?B?N1pGeVh3UmYyclRkeHdDOFEyaitJUWZyT29mNERxY3E2ZysrU1JlQWY2VXh1?=
 =?utf-8?B?NlpxY1VWU1UzQ1lWTTJIVTdURERRVDdGU0lteDJ0RDVPdS80c2dJL3YzYlhJ?=
 =?utf-8?B?c0IvYXkvTlJJaFdWcnFqbFpFdjRVV2w2TEMyWEV4MGpXU3h2VzA4YVVZNWQv?=
 =?utf-8?B?ejAvOHBzL2Iyb2ZHTklOd215K3BQbWdWTldraUZsOUJid3BwQTRIOS9jM0hP?=
 =?utf-8?B?dUdseDR4NG5Da2xLbXB6cEdNbmVWMUtMRlAwbURSbzN5NHhUb3JPWEZML1Jr?=
 =?utf-8?B?VGNkcFB6UGZsZEY2TENTYktnNXQ3ejIrYXNxQytxRisxaHhLR2NyWWJ1c0RW?=
 =?utf-8?B?MitDOElUbkpYZjVJd2xKUGh3dEQ2V1hLdjJaZStEd0F3V1RCYzdVNmZHVWc2?=
 =?utf-8?B?aEx5bXQvaUd2OGRDWjlEQWpVWVIxUVdFZGF4QUJrWTFJYW9LczBQMHpwcFhv?=
 =?utf-8?B?eDFBQ1NPRmVoWWlDSEF5dUg0WXArSDdLTlpRbTYyQ1Mzby84VVZZd0lGdFZn?=
 =?utf-8?B?Sm02dksxOFZXMDI2ZVZhVE8wVzVHbGd4aU9rT1gzRXlQWnRBOFprS1Ivd0Zw?=
 =?utf-8?B?aW8rblFuQW9BRE9aUjZpNTZIbXdzZlh2NFBTWk13NXBkN08zdXdtSDVyOTNm?=
 =?utf-8?B?U1M4bnJZV29wY1hmMnhCY0VSZGFoSUtoNTVPN3hwQ29MVDlqMDd3QlV4TURw?=
 =?utf-8?B?U2U2ZDhxa1p5cmc3NG9zb3daSUM4V2hZTHlHbUp1Q1FpV1pyd043UzJiYXY1?=
 =?utf-8?B?QVJ0dTlDcFYxUFQ0VE5Ta283SzFkSWJheUp2ZW1aMjVRdGNtdEt2cWFqOVpv?=
 =?utf-8?B?aXpjamZEMVgxMmgrNGZLUnpCcDlySFlXTjlmMEFHbE1PWERKZnVZOUh4cnBB?=
 =?utf-8?B?cWZnRFIycHZtSDYwUStuRkJWZzNTbWZ4UzV4eTNJTlV5K1M4YVJIWHFXS0tD?=
 =?utf-8?B?K0U2dUNsQmtEd1lOVjZMdlZmSDRVbmRocHlpOVlWc3UxaFdKNXJMUW02S2FX?=
 =?utf-8?B?N2JaOW9aL2h3L1NDQXlTSzFnN3Q4VjZ1OHFHeDRVM3lFakdjVHY4TlVLMlVp?=
 =?utf-8?B?LzZONVBVRkNBaldsSzlROGRwUStUOFUrRkpyd0VwZ0hJS0U4N0xVQU1tMjZj?=
 =?utf-8?B?WGxhbVV5NVErZitrOXVOdXoxbGNISlJpTStOTnVhK0swUy9rUUFrMERSVXlU?=
 =?utf-8?B?UjVpVGVBVGpNSjVac201bkd4cFVwTXFEODBEZklmOHpsUTNFRzZvamdyVU53?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VpRjgZThyY2iMzDPTzPhY2TTtgZUFk3uHADrmAL94H/+imoEBgjHsrdXYDqykDHrV5I+yx6bALn0wxEa6V5F2kz4zkmTmn+MS6M6yW8HZlZ4XnO2U2HNvxknobDyGyGq64/HAqJXPq1oryNPaFeQCtVTE0QsvcGZuzZ5Yam0ZdnwS41Q2AIFekWXENtWdMwSBUtaa+NFmX/icZa0gaWxopx+xfbSmeFsmQtl7in/JtO70fvJsnlAFGsASyzw6ZsHk8UOz1ZfWE3CaJkicKBKhZTnlcrWqXm3vVPubwvJu2MeMUWcAqSBWcfIMhDZx3lZDDxtEMgQzwCebbHRCFw2KEjKPocjy+JN4L6cvFaoPh5pz7cyAzpJzqmrKiUxy6547SkZ9r68/vs8d1PMezcTvCzhWeJn6ubqUZ6kTDBq5H2QxweONdQWJlEN8WsXJEnrMLMHZ1mfI+5E3qLW3Rj8go0jFqF06JibFFqgi7q3MqtBDAzC/FsrfzKj82njTPlmJs03951UqDEukdNYQe7DsYHpsNbUI5zkHh6klzbzrzUAfPMoO74sG7VNZv/xAI1WOzvf+LOqNPaUsMUfVFv5/BRU6v+7uXPYHh1OxPgV5Do=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 539d32c5-31ef-4e41-db18-08ddf4f9ff00
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 08:21:12.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3oLkgvhri1r1vUGs3GTX3egsdGwykQ5WN0PYNyfCDhdFFvdYIYFH28I+HTw9j3Z/Voy9VOVlHjj5kzeqPbOHQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509160079
X-Proofpoint-GUID: LkyqAOpN_HuMsdffo_BHkXKfPh_TcF9w
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyNyBTYWx0ZWRfXznIRzAt4s0o9
 tYKb5jkxzEq85rN0sbP74w+uzRIwkuMdkGGkoOqwZBKy5T+kYA9YQTsG3muOuxPMn3fA1+UoFNV
 5SYF96tigPaLWSmcZHd2sbT5HIr1Dt6yP7mnTLtW/TyiASlXJ/vvCAXeo7qmtfVZLv8Uy0wy24s
 HvZrXGgEzgybJnP8ZNpAsXGksnuts7L8NxpHn8+NMO4Wq1FDjr3vXPjS0NQgKtH0gAxX+upnRtA
 reXYABCOh0xGlCKLs0+NL1hMVyYssVwJxP2f1vfK5fjwMFbKmvsbBFIAYLxCOcB4Mr8XDKKzs3s
 w4MfWFyZG+edC9RkdDr7+yGOUBwN1AspzsENwpr4b3Jt75+cj2OYy++MjJqpY/bTYEMreyjexGP
 kGV3bCZZ
X-Authority-Analysis: v=2.4 cv=QIloRhLL c=1 sm=1 tr=0 ts=68c91dfb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=N54-gffFAAAA:8
 a=yPCof4ZbAAAA:8 a=ix5oNTiq0c0CI5EEL9IA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: LkyqAOpN_HuMsdffo_BHkXKfPh_TcF9w

On 12/09/2025 19:21, Bart Van Assche wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Allocate a pseudo SCSI device if 'nr_reserved_cmds' has been set. Pseudo
> SCSI devices have the SCSI ID <max_id>:U64_MAX so they won't clash with
> any devices the LLD might create. Pseudo SCSI devices are excluded from
> scanning and will not show up in sysfs. Additionally, pseudo SCSI
> devices are skipped by shost_for_each_device(). This prevents that the
> SCSI error handler tries to submit a reset to a non-existent logical unit.
> 
> Do not allocate a budget map for pseudo SCSI devices since the
> cmd_per_lun limit does not apply to pseudo SCSI devices.

IDGI, in v3 series you said that you would allocate the budget map 
https://lore.kernel.org/linux-scsi/20250827000816.2370150-1-bvanassche@acm.org/T/#m13c361e081b886b9318238b6dc05b571840b9698

FWIW, I still think that it is worth allocating the budget map for the 
psuedo sdev and making the queue depth the same as nr_reserved_commands 
via a scsi_change_queue_depth() call.

If we want to optimise budget code handling, then I think that it is 
worth doing later. The whole budget map and cmd_per_lun handling is 
murky IMHO.

> 
> Do not perform queue depth ramp up / ramp down for pseudo SCSI devices.

Are we even ever going to try ramp up or down for the pseudo sdev?

I suppose we could see it if there is some internal reserved command 
error, right?

> 
> Pseudo SCSI devices will be used to send internal commands to a storage
> device.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> [ bvanassche: edited patch description / renamed host_sdev into
>    pseudo_sdev / unexported scsi_get_host_dev() / modified error path in
>    scsi_get_pseudo_dev() / skip pseudo devices in __scsi_iterate_devices()
>    and also when calling sdev_init(), sdev_configure() and sdev_destroy().
>    See also
>    https://lore.kernel.org/linux-scsi/20211125151048.103910-2-hare@suse.de/ ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/hosts.c       |  8 +++++
>   drivers/scsi/scsi.c        |  9 +++--
>   drivers/scsi/scsi_error.c  |  3 ++
>   drivers/scsi/scsi_priv.h   |  2 ++
>   drivers/scsi/scsi_scan.c   | 69 +++++++++++++++++++++++++++++++++++++-
>   drivers/scsi/scsi_sysfs.c  |  5 ++-
>   include/scsi/scsi_device.h | 16 +++++++++
>   include/scsi/scsi_host.h   |  6 ++++
>   8 files changed, 114 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 9bb7f0114763..986586bf67dc 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -307,6 +307,14 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	if (error)
>   		goto out_del_dev;
>   
> +	if (sht->nr_reserved_cmds) {
> +		shost->pseudo_sdev = scsi_get_pseudo_dev(shost);
> +		if (!shost->pseudo_sdev) {
> +			error = -ENOMEM;
> +			goto out_del_dev;
> +		}
> +	}
> +
>   	scsi_proc_host_add(shost);
>   	scsi_autopm_put_host(shost);
>   	return error;
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ff6b0973d3b4..2d2a52c3ef49 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -257,6 +257,8 @@ EXPORT_SYMBOL(scsi_change_queue_depth);
>    */
>   int scsi_track_queue_full(struct scsi_device *sdev, int depth)
>   {
> +	if (scsi_device_is_pseudo_dev(sdev))
> +		return 0;
>   
>   	/*
>   	 * Don't let QUEUE_FULLs on the same
> @@ -828,8 +830,11 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	while (list->next != &shost->__devices) {
>   		next = list_entry(list->next, struct scsi_device, siblings);
> -		/* skip devices that we can't get a reference to */
> -		if (!scsi_device_get(next))
> +		/*
> +		 * Skip pseudo devices and also devices for which
> +		 * scsi_device_get() fails.
> +		 */
> +		if (!scsi_device_is_pseudo_dev(next) && !scsi_device_get(next))
>   			break;

looks ok

>   		next = NULL;
>   		list = list->next;
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 746ff6a1f309..540d82974529 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -749,6 +749,9 @@ static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
>   	const struct scsi_host_template *sht = sdev->host->hostt;
>   	struct scsi_device *tmp_sdev;
>   
> +	if (scsi_device_is_pseudo_dev(sdev))
> +		return;
> +
>   	if (!sht->track_queue_depth ||
>   	    sdev->queue_depth >= sdev->max_queue_depth)
>   		return;
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 5b2b19f5e8ec..da3bc87ac5a6 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -135,6 +135,8 @@ extern int scsi_complete_async_scans(void);
>   extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
>   				   unsigned int, u64, enum scsi_scan_mode);
>   extern void scsi_forget_host(struct Scsi_Host *);
> +struct scsi_device *scsi_get_pseudo_dev(struct Scsi_Host *);
> +bool scsi_device_is_pseudo_dev(struct scsi_device *sdev);
>   
>   /* scsi_sysctl.c */
>   #ifdef CONFIG_SYSCTL
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index de039efef290..a3523f964bc1 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -225,6 +225,8 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
>   	int ret;
>   	struct sbitmap sb_backup;
>   
> +	WARN_ON_ONCE(scsi_device_is_pseudo_dev(sdev));
> +
>   	depth = min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev));
>   
>   	/*
> @@ -349,6 +351,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   
>   	scsi_sysfs_device_initialize(sdev);
>   
> +	if (scsi_device_is_pseudo_dev(sdev))
> +		return sdev;
> +
>   	depth = sdev->host->cmd_per_lun ?: 1;
>   
>   	/*
> @@ -1070,6 +1075,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   
>   	sdev->sdev_bflags = *bflags;
>   
> +	if (scsi_device_is_pseudo_dev(sdev))
> +		return SCSI_SCAN_LUN_PRESENT;
> +
>   	/*
>   	 * No need to freeze the queue as it isn't reachable to anyone else yet.
>   	 */
> @@ -1213,6 +1221,12 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   	if (!sdev)
>   		goto out;
>   
> +	if (scsi_device_is_pseudo_dev(sdev)) {
> +		if (bflagsp)
> +			*bflagsp = BLIST_NOLUN;
> +		return SCSI_SCAN_LUN_PRESENT;
> +	}
> +
>   	result = kmalloc(result_len, GFP_KERNEL);
>   	if (!result)
>   		goto out_free_sdev;
> @@ -2084,12 +2098,65 @@ void scsi_forget_host(struct Scsi_Host *shost)
>    restart:
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	list_for_each_entry(sdev, &shost->__devices, siblings) {
> -		if (sdev->sdev_state == SDEV_DEL)
> +		if (scsi_device_is_pseudo_dev(sdev) ||
> +		    sdev->sdev_state == SDEV_DEL)
>   			continue;

maybe this would be neater with seperate if statements

>   		spin_unlock_irqrestore(shost->host_lock, flags);
>   		__scsi_remove_device(sdev);
>   		goto restart;
>   	}
>   	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	/*
> +	 * Remove the pseudo device last since it may be needed during removal
> +	 * of other SCSI devices.
> +	 */
> +	if (shost->pseudo_sdev)
> +		__scsi_remove_device(shost->pseudo_sdev);

looks ok

>   }
>   
> +/**
> + * scsi_get_pseudo_dev() - Attach a pseudo SCSI device to a SCSI host
> + * @shost: Host that needs a pseudo SCSI device
> + *
> + * Lock status: None assumed.
> + *
> + * Returns:     The scsi_device or NULL
> + *
> + * Notes:
> + *	Attach a single scsi_device to the Scsi_Host. The primary aim for this
> + *	device is to serve as a container from which SCSI commands can be
> + *	allocated. Each SCSI command will carry a command tag allocated by the
> + *	block layer. These SCSI commands can be used by the LLDD to send
> + *	internal or passthrough commands without having to manage tag allocation
> + *	inside the LLDD.
> + */
> +struct scsi_device *scsi_get_pseudo_dev(struct Scsi_Host *shost)
> +{
> +	struct scsi_device *sdev = NULL;
> +	struct scsi_target *starget;
> +
> +	guard(mutex)(&shost->scan_mutex);
> +
> +	if (!scsi_host_scan_allowed(shost))
> +		goto out;

when would/could this fail? It seems to me that the shost add would also 
fail (if this failed), right?

> +
> +	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->max_id);
> +	if (!starget)
> +		goto out;
> +
> +	sdev = scsi_alloc_sdev(starget, U64_MAX, NULL);
> +	if (!sdev) {
> +		scsi_target_reap(starget);
> +		goto put_target;
> +	}
> +
> +	sdev->borken = 0;
> +
> +put_target:
> +	/* See also the get_device(dev) call in scsi_alloc_target(). */
> +	put_device(&starget->dev);
> +
> +out:
> +	return sdev;
> +}

looks ok

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 169af7d47ce7..22f76a1ca23b 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1406,6 +1406,9 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>   	int error;
>   	struct scsi_target *starget = sdev->sdev_target;
>   
> +	if (WARN_ON_ONCE(scsi_device_is_pseudo_dev(sdev)))
> +		return -EINVAL;
> +
>   	error = scsi_target_add(starget);
>   	if (error)
>   		return error;
> @@ -1513,7 +1516,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
>   	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
>   	cancel_work_sync(&sdev->requeue_work);
>   
> -	if (sdev->host->hostt->sdev_destroy)
> +	if (!scsi_device_is_pseudo_dev(sdev) && sdev->host->hostt->sdev_destroy)
>   		sdev->host->hostt->sdev_destroy(sdev);
>   	transport_destroy_device(dev);
>   
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 6d6500148c4b..3846f5dfc51c 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -589,6 +589,22 @@ static inline unsigned int sdev_id(struct scsi_device *sdev)
>   #define scmd_id(scmd) sdev_id((scmd)->device)
>   #define scmd_channel(scmd) sdev_channel((scmd)->device)
>   
> +/**
> + * scsi_device_is_pseudo_dev() - Whether a device is a pseudo SCSI device.
> + * @sdev: SCSI device to examine
> + *
> + * A pseudo SCSI device can be used to allocate SCSI commands but does not show
> + * up in sysfs. Additionally, the logical unit information in *@sdev is made up.
> + *
> + * This function tests the LUN number instead of comparing @sdev with
> + * @sdev->host->pseudo_sdev because this function may be called before
> + * @sdev->host->pseudo_sdev has been initialized.
> + */
> +static inline bool scsi_device_is_pseudo_dev(struct scsi_device *sdev)
> +{
> +	return sdev->lun == U64_MAX;

could you also check sdev->shost->psuedo_sdev == sdev?

I suppose just checking the lun is simpler

> +}
> +
>   /*
>    * checks for positions of the SCSI state machine
>    */
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 91eb3f52b3d0..3bfb53cf5dfc 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -721,6 +721,12 @@ struct Scsi_Host {
>   	/* ldm bits */
>   	struct device		shost_gendev, shost_dev;
>   
> +	/*
> +	 * A SCSI device structure used for sending internal commands to the
> +	 * HBA. There is no corresponding logical unit inside the SCSI device.
> +	 */
> +	struct scsi_device *pseudo_sdev;
> +
>   	/*
>   	 * Points to the transport data (if any) which is allocated
>   	 * separately

