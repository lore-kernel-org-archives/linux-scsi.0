Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09AF1581EE
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 09:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753696643; cv=fail; b=qDA/Z4rVZyQlSqVyDber69+vIpPDp33ATBr8bnFI8vuucSQttGOHLul/P8S8zq1YAH2CfGT5RstaKmNVfgdqplF38FguRrNqabrWGxglEq8LJQnFJ5G2yXWpzwwehkY2QmYbf2IUNWfhiwTapsrWLjxBvmZQ8CnO2meVMTDbVcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753696643; c=relaxed/simple;
	bh=G2IGWo96PFQJMiLr9RPfo5nhvGjZTupljRmjndaNFXo=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZCJhdtaK28ElvEQMvnoHigA4vsgEvQZdPRYSh5wJbsOTG3BT4fJNQNNm/295gGlg6YDe12S4EgkNR3WXmhQxBXAxjj6MsRL//AP73n+OV/Qhez1vJwlOkgmohfGTNrpsnIOhcDnOBffEXkiuezonbXY3+RCpD53K2clvUApQ5TA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UbZSTJiE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=P+jiUGOe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UbZSTJiE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="P+jiUGOe"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56S7g5mw027127;
	Mon, 28 Jul 2025 09:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nGjYTbl3Th6EpxE/amIw2nGzvN7J+9EbX4jWbHBRZtY=; b=
	UbZSTJiEDEMEbiL19PIU1Fp4/jaS0Oy7AqZOsOycn1jQOuxp0fTouyegzcnhoScD
	506Bq16G2tnDYRasBG7Vr/HyuORlmVZ7ehBDrc08Hb2eH30/K9fcO6KU+z+Np+eJ
	1TDkjPA2GBeyYRfYW661roSJLNS091A6lalWBk/P8YE47gxHjzZTfhLVCuIyH/zE
	V1FEBTh0Lsta/TzMHg2bexAzAzmz2cVnTrtsNVdctlzDYNAjrHbHdWyOv7bnlzig
	sALu/AP6xkVgq+NSbLk/xSxMyTdn48ekT4LyJcTMSL5aPZ2kE573oQ2zwTuqR2pw
	ezpL3td35jzRVTlWgIUT1g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4e2wqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 09:57:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56S8StVZ038709;
	Mon, 28 Jul 2025 09:57:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf82g0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Jul 2025 09:57:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wMvyGmQHGVYqny1RFU9Fs+jZgTmYQjni8C4f6Q8u7j8rQLP45K1ZVJkwfW30cy/Np6SqUM203DFb+p0jzNC5Z9gv7fnfCnkqV8xZGFOfqDWz6zvJZsWVjw+/mLDyFIx2/GKpFfShxsq7YlOhjAJ2LVxU8FJvAFQnpByjJC/HeI+aipLdBiFyAh8T34MyT70p6DXu1mbHoj1KeoSREoFNM+Wxxc25f8VqyeR4r2HrIDfj4LUIqxriGtXZameRcT9NuBqs4H+3ZHQe0ziHb5FOoX1FN8dFPNT7tpmBMDzEJhxCto3CtvHuRmXRFDbBsqVHenO6VMPqVs43D4Oju9DL3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGjYTbl3Th6EpxE/amIw2nGzvN7J+9EbX4jWbHBRZtY=;
 b=mQG3b+TvzdW8jnc7zXXp/xf+LZExbxHwfOXltPPJh6+blpdjyCg28GL3F68WRQHNN+8IlXE3Rpp0KBzV0ueyOM6oQub2ScKJnlrpJFjiPfRLPt2BHV+wgzy4uPebgd1gsVeSziUxx2zfEccKyc6sC94BZzxQEGxE3o4wqZ5/OXPDsC1X0ix0kRX2QiUfjfUTb6DoDq3zW8BUlTYQ+ss1BMZGNF0xE0OFlz3PJh6q1i4RMrAVCSErRi/MYyC2L8eN+14pZwtGYYNSoZ+2zP8s5ULWATqBUwfnQlEfhMvNCwLtxjklfHWURlkH5eeaU+P9QCb/clppFlg1jBtETY7sLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGjYTbl3Th6EpxE/amIw2nGzvN7J+9EbX4jWbHBRZtY=;
 b=P+jiUGOeMH3PaCBTLKFMdhC2s4ppFSu6AlmyzTDhBSIiHWicZs31ga+Nzk8pJjuVQ3hzfOKeVdvk3kS76qiBFVb/7kZ4fZNTQGTz8YKoorvK8NI5grmmJWz5fUHclQFvYVnDHvrHSjR21/CYvF3vfEFpHKlQo46V9vnQ7BHHVIc=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by PH3PPF8223ED5C3.namprd10.prod.outlook.com (2603:10b6:518:1::7b2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.23; Mon, 28 Jul
 2025 09:57:15 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.8964.025; Mon, 28 Jul 2025
 09:57:14 +0000
Message-ID: <c9ff3ef1-a519-4f6a-909c-13bca4b4f617@oracle.com>
Date: Mon, 28 Jul 2025 10:57:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Correct sysfs attributes access rights
To: Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20250728041700.76660-1-dlemoal@kernel.org>
 <d3d6659e-dfff-4f4f-ad3b-afe053fe736d@oracle.com>
 <9b997705-c758-44bc-bb7c-60039304cc03@kernel.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9b997705-c758-44bc-bb7c-60039304cc03@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0393.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::20) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|PH3PPF8223ED5C3:EE_
X-MS-Office365-Filtering-Correlation-Id: fe9970b9-f244-49e3-24bb-08ddcdbd2102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHBkbnBCVk8vbytjYStlQUROb3A3S0JlMEJuY09iZG5od2dWejR0dXNUdXdh?=
 =?utf-8?B?UUkza2xISysxUTZ3bWFtbHRaSHhhYndnQkpGT1BSbW00dE9Ed2ZIWG92WFhT?=
 =?utf-8?B?MHJtQlRtUzUrOEJaWmR1UlpCejAzTUNydUcvR2phMWVGYUV5ZnZCeUxCdHV5?=
 =?utf-8?B?OTM5bk90TkppcU1ZR2lscG5xZDBuZmtReVJmNG9BQU42UFVZNHBJMXNoVGI1?=
 =?utf-8?B?eWNzNkRrWmU2TlhXMGphQktPc3FLUG9pL050T3R2RGNMMnBwRkx3c3IyU2hu?=
 =?utf-8?B?VTJSRmczTkxlaitlem5lRE0xUXVjeS9WTkRzMFkxbEd0dENPeGVyZ1h3UlBu?=
 =?utf-8?B?NWQ1T2NGWkJGTnVodW9NR2luREMwQzlYSTFhY3dJMDJqOWtZT3NCRUlqb0tR?=
 =?utf-8?B?M1pNaWNIcE1uamcxZjZyTlpkbXh6YW1SMStoZjZvaWVEZTJWNFRtbGNxdGVs?=
 =?utf-8?B?RWpnbTk3MXZ4SXg2bjhSUmp3ZTFWLzY2UUpIT3lEVVpLOWowU29HdWhwNldz?=
 =?utf-8?B?VVFuVldwRXk3QXpITVJ0TjV3R28wVk9uNWJGT1F4bW1uZnVUZjFGVm5tVEcr?=
 =?utf-8?B?YTR1YXdhdUR2N2hPL3NPVldEY2JZR3hkV2V1S0pYOFgwMVVFeEN5Y2F3aEhZ?=
 =?utf-8?B?UWM0MWYyUi8yUmlxN2gyYXFLVHJWUGd3MjFCY0t5TWl4c1FUZlNtMWVwOWYv?=
 =?utf-8?B?ZEphclBXNHNURU8zdUJ3TVB1YVR5emZCNTQ3OHk4Y3R1RjV4dnlnd28wN3dC?=
 =?utf-8?B?UCtmV1ZFSGZTZ2liM3hnZmFDNDRuVkRrSjNKbThkak9xbUZEeUdDcEdKL1pI?=
 =?utf-8?B?U28yVnphOUFWR3REVnZNQXQzenRib2MzVmxIdU40Q1pCclMxSlhLSDRxdnU3?=
 =?utf-8?B?amM0Zi9yTHVZODdyNWVtSEZNRzhKcFhyVHJsZlM5MFh0SzI0czU1ejNBZ3JR?=
 =?utf-8?B?RlZUWDdudjFxY2k3a1JnQ2ljc0I1WVg0SW5HVHBic3k4THZ1YkpGYVpDNFV2?=
 =?utf-8?B?TzNYN3MxRFpudUlpejhBZXZYQkNPdmsrSCtHdGJFRzlYTUozUml6MTJWNkFx?=
 =?utf-8?B?NG5ZMnR5OWtOUmxwdm1tdEJWalZMVGd2dmpIcG9hUVJrNDVrRVkyNExxUjNE?=
 =?utf-8?B?MnRBTlkzb2pSYlpNTmI3WENBeHNPbEw4TU0veXZqeHZKM0pKcTJuVnpvcCtw?=
 =?utf-8?B?cW83Rlc5QXVoTHVsNnBHNlRHMnBDbVRsb0JGK3RyZFFyNVVrV0htaG5XMzU1?=
 =?utf-8?B?YTROZkd0anhQYXlvM2d0MTFhMWVlNnJMaGdBYlM3aTdFNFBqYkw2TzM5M2ti?=
 =?utf-8?B?dkZWZTNjOHhLQkpSVVNpWWRqbkx0d2QyaEdmeFFkaTdkNTlaQXdVcEJTM0xp?=
 =?utf-8?B?TWlVbHNFdXlpU3pkVnZkcGpYZUZXVy9mTGh6VTNEaHZoM2NDYUJlYnpKdzB4?=
 =?utf-8?B?cGVFNG84blc0RHlucXN0cW9rUk12ZEhHcnJnYzdoL1NSMVZyV1JKbHo4NG9r?=
 =?utf-8?B?ZVVHcFFLczI5d2FzcXhDaHZHemdQTE16M04xdXN6WWFtdWh0VUhCVDI3Rm91?=
 =?utf-8?B?c0lNbGlkVVE5Z2JHNDdUa2RJaCt3VFFXT2xrVzMvay9pWGpVejAweHJjbXhC?=
 =?utf-8?B?VzVacWpCZWtIeFFJd2tIWTRoS1BTWUpWRkl2V29NaVgxREtMcnhLbkNSV0VO?=
 =?utf-8?B?TTlBdkVrdTRwRGJObjgxVFJCYWdGTFlLTmw2SWZXUEQ3TEVKM1V4L2ZGWFVv?=
 =?utf-8?B?em94VzNhYjJ2VzJDOVFWcWFTaGQvemVBQWhOa1V2UFJRUlkzQWlmWWljZm5l?=
 =?utf-8?B?MXJpK1E4eG9xUXoxcGloODdjeFJlQUUwOVZHMktLSGZ3cERNYlF3WE93ZEZ5?=
 =?utf-8?B?aE9xUUZGb0wrUDhLK1FPVThzZ2hRMGxFN3VlWUJBNmZXQzVPcmswV3cxaGVE?=
 =?utf-8?Q?bo01T1igW2k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTlnbFJ0eFFhd2hnN0RXMkdNOWRUSjdqanpNUEFYMzM4V2txNlVpTndQTUR2?=
 =?utf-8?B?WjlCUzZCNXpCM0gyaHE0RFhKSklQdHNPRjRTWGdzeVZFMjJPRnBUc1Z6d1p1?=
 =?utf-8?B?WmtMVXp1aW0ya2dDV24xSWNzSEUzU0U5UkNhcUlXOGVKZytQcnRidkdIM3hj?=
 =?utf-8?B?MWkxQ1JmRTc0U0N0MlFGeDFZeE9DVEZUQkRpRDF2MkxvZ1pTaGk2cGhXWFBU?=
 =?utf-8?B?cTBDdlR6akYzQ2Rrdk93SlhVaHFZWDAxQkhDVkF0RTUrUlNDcjErelBzbW93?=
 =?utf-8?B?ZVVya1gvV29LZ1hHSk1Ic2ZzVDh5TFhVLzh5U0pvcFNKQ0lrZDFyTWFBanNu?=
 =?utf-8?B?dW82aERWcjZyVHNEVFRIRGt2dEoveHh4a2Q0SkpQeUtjdnk3UTRjZjFXbXRN?=
 =?utf-8?B?dnd5K1RtT1JEbDVYS3lOTktUemx4Z25TekVzK08rbXVQbGVuUHVuTXMwTkFL?=
 =?utf-8?B?THRpYWx5MFFJOXZ5WGFqeUI0S3lISnRzUE1tMHFDOTdzZGVMdlhpajI1VFhv?=
 =?utf-8?B?T1RTcnd5Slk0TkF0NGdveFBxakhwSk1NK3dDUWlvTkJQcFNwdngySk1JOEZF?=
 =?utf-8?B?SWFLb1NJN0EvVmpXTVlWckY5YXNtTmVITXJjcnMxL1NtRzVwWGhQeXJ5Y1Zz?=
 =?utf-8?B?N3JFdHZwTWhBZFNXaTR6NkVnc1F6TVBVNmhtT0wzMWpXU2E1YTA2eVBpWVQy?=
 =?utf-8?B?b1FLL09vOFYzaFZqc0x5NUJYbXFFdXlZVyttdE4zQ3BmMUhaZmdwR0lEa2dF?=
 =?utf-8?B?NUJTNVFES1hMbzZ0Z2hBNm91ZE1VblIwSUp6Tk9qYU85M0ZTeFhYbGFBcS9p?=
 =?utf-8?B?QmovYTBDek8zdUk1OHlpdVlxOHllQ2o5WnlEQVpqb2NsN3FCWmJtZ2ltL1Bi?=
 =?utf-8?B?VSt5SXVBVExFRFJQMlpzMFR1aVkxVDdiR0x6STZNS0xDOU8vZUpYQVJqOTNh?=
 =?utf-8?B?TlV0NnA3c3ByRkI3aUNTWTlQZ283Vm81N0RvcC9XS3BMNWJUdWhJRW5LSHdN?=
 =?utf-8?B?UXhvOEV0U29DTmszRnB5REJXSWpCY2FicFB0QjJ3L09oUSsrcDFJWnNhaVlY?=
 =?utf-8?B?U2NGUFNySVdkTHJKUHVSMXBaWjI3MXZqTlhQcys0ZTRqcUtET2xteEk2VG9G?=
 =?utf-8?B?UnVmeXNpbmJPbVdLTFBrZDRiUnZKOUhVcmExYlJRQW0xd2FyTGMvaGRYaTlx?=
 =?utf-8?B?Z3ZPQTM3QWJKQnU1VkxRUGowQkRKTGJkV0trSnIrZHp4RU1mbmY1cWNKMUVJ?=
 =?utf-8?B?ZHIxZzNCR1h4dVVaazhrVm9nZlNVQTNXa2NMVXZvaW5KVjNLMkovdzZBNWlV?=
 =?utf-8?B?Q0V3R20wRnh6TnBieXU4cUtsbzBWRHc3bmQyR3VYZ1ozbDYwSngvYzV4UW5W?=
 =?utf-8?B?ZHhFUUppa1pJNzA3RG4yR0IzSWFQeGllSGQ3TUFKWWw4dWZBaDNjTzdHZmx3?=
 =?utf-8?B?SDlrRW1kb3hCOWgyNk9VMzNvK0dWYmZwUUR6TFROZVlmOHN5bnBBU3RaWHJl?=
 =?utf-8?B?dTNRYkF6TFI3eDZ5VjZiL3RaNkx6YWJacXgzVFNDVElLTDMvMkdXYTVkSWt3?=
 =?utf-8?B?MlVKOVhBYUp0b1RKVEk3SW5iSzZJbFdhalhYWjd1NWRUZlFNVTVzaitieEN3?=
 =?utf-8?B?eUJuTnNZU1ZxYUk0dmd4YkVDMHI3cE5VbzlTNnpBYjNtUS9vVC9nSGhTL1Nv?=
 =?utf-8?B?NTc2OGxmL0NJdFdJUENhUHNvcG5BcW1FT3BkTm5mSzRjU1VTY3NsL2VQbzVW?=
 =?utf-8?B?Ri9ndjIwcWNjT2tvYng2SjFCam5pbXpBODVqMGo4eGtraXlMR0FoSWw1N3gr?=
 =?utf-8?B?MG5sN25TbzRzZGdzSjU3UTh1dTZHcmNrTmJnSFlLSmVEbWFNRzlkWVV3TVN3?=
 =?utf-8?B?VWI1U1BLcHRZMFR6VlNVTEprNUdPL3hBOVZKdmROdUJTMzVnMXZOQTBKZkNk?=
 =?utf-8?B?STBxMXFtTk9WRVF3L3g1eHFYTjNXVzV1OStzVGV4ZFYrMWJmeGo4VE4ydG5R?=
 =?utf-8?B?d2c3Q0laNm1rdHUxeWJNdDlCTkduWkk5d1lXRW9jdWhGRXRlL25IeGx4VXFs?=
 =?utf-8?B?TnRKU3laVk5yemdzZFN0czRTV1ZQazJPUWd3MWlzaURuUTlNKzFZZllPNWFv?=
 =?utf-8?Q?+VpaLXzNiUSQynDzfVIT/P0jp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uKJSok4sHG0Obj1NwGOcBZpQQgBpMva4jeVri9kxUJ0vVaDvOETY3/Jv+ScP2gVpXANXa32HkZwQa7BmC+Ousjhvd9qykOAIU8hd+k82kIK3OGnkvi6rWHPim3W+9suCrwm/3ruaq7RBPTRKXs1ZMFuNLzvbng8qefbsp+M7HExT7M4UMkDxc+jocy9OY+9V8lNJRVQiRkH26fqxlUNsHdWCig59BP5bRxCEgpoDvhbXKnCnIt21pCNhRIUFJFlijH7RaZVnTuKSao+nJSBfcwrmDVL7i40BcwotDKRj3cEzUNi7nOufKLN9oar0iVQ2HsIbhumyw8UKqu8to7TnwL2ADAFdX1TQg2EtYw7kgEjDsUOy44wMS0MR+m5SlI3h86NIlbEdCT+flTcteCbZM4Bp01uZjgwfJxqCLZ7GdNgWzmbLNGwXaH0yrFcQDusXw8/5TwietgkZFElKw/9QKBqgA8wiuJA5sDxoF3LqDBRc834dXpOCRBKd/7uyVMEJIxsA6arFeUsnGV+OodRutetnBWxSCp0NEOFoUh5GmU03f0vKfzdNiPSHXVS//bgwIvftAOzOxtw4kqOUwhExJiCT+7qQdWpNDeGzmThbjt0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9970b9-f244-49e3-24bb-08ddcdbd2102
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2025 09:57:14.5473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Orj7ejENc+LP2sRPysn/b5iVwT06qjpKNMnZ9clpvmnQ/gbYpB3hIYB6MG55sSZq7Mk4+ZCsuxHYLCHOE8yqNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF8223ED5C3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_03,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507280073
X-Proofpoint-ORIG-GUID: hrj6eQy5OH5zF7V5EvcK0g7WeulvNTdQ
X-Proofpoint-GUID: hrj6eQy5OH5zF7V5EvcK0g7WeulvNTdQ
X-Authority-Analysis: v=2.4 cv=QZtmvtbv c=1 sm=1 tr=0 ts=6887497f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=3_Na6VyaaU3G-fl2EcgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI4MDA3MyBTYWx0ZWRfX2Bj2B0+2LWQ7
 4J4zrLdzeJaaR9iC4JHbA7JgLO7RMktF/FoJjcNZQLLv5xogFmmthBH53Ut5hyJJBCKjKAkCRwY
 5JsAdJMdcAPbbEd/5USrPciP2gLb9LWbZMGXR210zxfXXImATSrOdWMlRftw2RKCAOrzSxZJHtZ
 iGIuq3fHQzBcLJ0vONj4RHfVOgzmyxDPij8Ukl/eITF6OdcXQ8pjzPslK9iOHVLmzeszXw1I+m5
 c8zwMjkqNpYoM08WH2jyhPKvI43Mk36xNUyBxf+Jsju/LL0mcxXuWYQxIfTy3Kt2ECDflRFmVKJ
 smqiBMvDX4UExOIo0x5UHH5/eWfi29DPKwNMK3vRDcIgboQEii0Vb/j9W/94Lua2iT5S41BK8Ot
 Nml6jqJkNdWU7LLrQOixe7iyH01AQPPx5gBVy9aYDGpqAhIERcs56jXGt/6LC1f0zYWkAz13

On 28/07/2025 10:52, Damien Le Moal wrote:
>> Note that class_attr_store() returns -EIO for no store method. Does the same
>> happen after this change?
> The regular Permission Denied (-EPERM) is returned.
> Do you think that is a problem ?

Probably not. I can't imagine that any sane application would rely on 
that behavior (of returning -EIO).
