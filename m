Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D232857FC
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 20:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757707421; cv=fail; b=ucIAnAbweguLzNDO0AzxFMBBiSC4LDly9zyJ+ANTF10DbCQB1LYtbZLR2A5ET4pLMAX0zupT6enZayoTDh5iAgHbYe1NbY1CdzTPoPF65t+p3UWtsu+aHH9XLyBnLOmyJ5K/zOaHJZkVhk+ttL+mIxiNeDJZcHzV9UyTS1iyA+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757707421; c=relaxed/simple;
	bh=QX8gKmvkd1I3VQ2CJrzZFNQgX3Ir4IcT/6lHfj1LNzs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jAK3ltvFt1q2YogGU+nCdCzD/SNYT3pwG14uxYmf7yYD8hg6ekG3WZPPt3SJJDUZ8Lzfh07j8rYV2+uhykBctDZT0ujJtDchuJijMDPfP82R/Le/45CEnPw590asVzDdNxFC1w+NxUSQL3q5xxTuvAEgmArApGc7sZv5qXYPLOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rGKvveH1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PAPC8XYb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rGKvveH1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PAPC8XYb"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58CIMjSu009115;
	Fri, 12 Sep 2025 20:03:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6u81mkHzq+wsIcCMteRXodWI/FhsBZLEW5pGrgHMLBw=; b=
	rGKvveH1nkpL6NGzZKONqpSGK2b0Ilq+Cl9jybGN03V8HtTRVY+79nR8Za+pt0ar
	EFwausY9Cclar8AdBbHmeWv0/YHkLX4bqUA2f3Z0B7PW1E2kcdSOgVv73Xl78o0y
	PErj/JbAYm15TI/mZUW194qzJEQZAqWJKy68yVa7TzihDgVuEYAwusaN+9fbred2
	FKy3wq1UPfN0u9VrmLSXFwwEsn+uatBBGr4lwyeh9JezOq+RN+tGl4RTz7m1vrUA
	3Ez51qihj5WrG2jiSTf7LaNVhSvwYDBMG03gCjHmP6SawjY71bdPO+4TsExeabAx
	EU3dOsfZuqADmNBkiFO4fw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m30w5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 20:03:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58CJc4t4030655;
	Fri, 12 Sep 2025 20:03:22 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010034.outbound.protection.outlook.com [52.101.193.34])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bde996e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 20:03:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K6Cq/ICWTE9KPm59K7+SdHukBhPL6U2AJFEBoPxy9kbu0qBDfE3Za10uqwvQ+jEvsgq3+mQu2ibtJkENaA/CCECPBfzds79SvDSY6nfQsXXCWnRiJMIUGOmcgPKcioGREMZ7DojUHmYOflTKuYve5nZ0Aa+aktP5NpJqc5cxrV/aMB0DlS4K1jUnvhD6Mtv6t98AT6rqenbNULhrBlWcfcDawx0IQB8hMy+y1qMlbM+706cwPD7wOFnZo0pBuKFBy6u+LpA6C/qlIiT8aMV3KRx8aIHxkRTAOayeXuWHVdfXNENKWJa/vBvfG6zcTST7kwP4KaV8a04KnERVEVw0xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6u81mkHzq+wsIcCMteRXodWI/FhsBZLEW5pGrgHMLBw=;
 b=FsJOcPLF/x/wvNLqmlg3YfgFKofbkX4Im4Yb5hd0Y6ilI37ohAuij57fftoG9LVUcC/I7SoD9w23Ge648T/uLgEzigDul/FLAb7Uj31m8K+wRaC9RLB2xw5xshCePfBEo6gacJXVsw1dIo+5w0WSEGta5tGL0iKtjPsHQqPoyH/XGM8LpKcOBJEMWqrmgLPadvIuLnjX8Wu5OZm4L+OZPmPxHMOShZW20XUWOpXi9TVWlYURUH9Le/vmaEdp7v7vW3RwKDiql886oQCM/ydhotTiTHpnSxOT6YeJ9yWGjZfA8H8285Rs6wGo29+paeW5yOunCNyhaktARl0SiebdtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6u81mkHzq+wsIcCMteRXodWI/FhsBZLEW5pGrgHMLBw=;
 b=PAPC8XYbLA4SBsouYbGoyVMtlH8R2sqmnCxuixaw9CDPT+EsSfjpTHZvoYlCqW3VYdYq5TkdWY3+yFziFn8PlKeZqysLp2jMU0bzEnbLwpGxYpHcTed0aloEAAKsLy3abC6Jy8GghEphMNVdE9ylcZ+MI8eKQxGr0vXiOhoMae0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM6PR10MB4316.namprd10.prod.outlook.com (2603:10b6:5:21d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 20:03:07 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 20:03:07 +0000
Message-ID: <1a1335d9-5690-49fe-b5a9-542cc17c1bff@oracle.com>
Date: Fri, 12 Sep 2025 15:03:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/29] scsi: core: Extend the scsi_execute_cmd()
 functionality
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250912182340.3487688-1-bvanassche@acm.org>
 <20250912182340.3487688-7-bvanassche@acm.org>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20250912182340.3487688-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P222CA0010.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:610:1ee::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM6PR10MB4316:EE_
X-MS-Office365-Filtering-Correlation-Id: 97e89000-6553-4977-29bf-08ddf23763dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0Y0TmRteG5QYjZhSS9GczlBYXBxLzd6OTFoUFlOYlRLQWhEcEhqWTFGbTZ1?=
 =?utf-8?B?QktnRG10SnI1OUg5eCtXTHVyZWswTUUvQWZCTGt6TjBuUGhud2J4UE9ucmpy?=
 =?utf-8?B?ZzJOY1RMT3BqeSt4eDJSNWFJNzVZWVV3TWIrM21WMGdhQ3VLUGd1UFYzbERx?=
 =?utf-8?B?Z0FiNE85T3VxTEc4SGFnK3kvZ01jUFIwMUtyS3V1VkNQaVZ6SzlQMjR6cmdV?=
 =?utf-8?B?cWpJMUJybjR6NVg4UDhhQlVJc3NUZ3JsVlh6QVdCSkdpQ0pxL3NPa3lma2FP?=
 =?utf-8?B?NXNnRSszTEZOSEVTT1pienQrY2VodGtHc3g4U2ZVOWNzaGZhQ1dTTjE5ZkVk?=
 =?utf-8?B?Um1zVFd5TktKeHpSOG9xa3c3TmcwYWkxUWR6TW1HRHJmNU03T1U5ek9VUzhw?=
 =?utf-8?B?bTRXZW1PdkhoY1NLbnNXclZ1a1BGMUdsNWpkL1FkbDEwM1c5bEpORVNJNDdj?=
 =?utf-8?B?L1RWL0FYMkY1Tk5oRFMwdG5qeUNQc0YvTVRBM0hMa2ZJbnhDSU5zWE43VUZr?=
 =?utf-8?B?V3FYS2JPU3hvR2lHTTBLNkVwK3g3M2hZTHkzczN4SG96WnFZU2ZwUE82dW0x?=
 =?utf-8?B?OEJXNmUvZlUyNUJ6cHhYSVI3YTAvN1ZPckZkaEVEUEIrK3FEV05iUDQrcTla?=
 =?utf-8?B?NTJLc0d5WUNPT2FMbE1wNDd6RmkxVGJraFRxOVlnb3Z5S1NLWlU5U3MrRGxa?=
 =?utf-8?B?VFMrVnhYQ3JzVVAyeml5Q1loVG1BQ3NSeGVBanRiMXRNcmNYSG53WjJETHN6?=
 =?utf-8?B?WG5seVNQdHVJaGFCbEhrdDhoK1EvT05oU0hQdUt6bVpGaEJ1SkViMWlvNTB3?=
 =?utf-8?B?OHdwU0ZzSjFsbk53d0VaZUhBV0VjeVc2TTRySHFuaDVSbC9TanMxTzhBUlRZ?=
 =?utf-8?B?SmlpekdUaEZSVGJsQXVFMFpUZUppYVBlMk5heXBKMUFMVERNeU95SldmVnVN?=
 =?utf-8?B?ejFpbVNzZDVmQnBuKzVDL1lWYWJsVG9zSElhSzZaSXZ1SnUrWUlBeE9rQ2xh?=
 =?utf-8?B?SDZybzhqc3RrNGRjZm9JaE82VUtXd3paMmlNaVRVOTROZ2ZBUjYvUTlKeXls?=
 =?utf-8?B?OWl0Z1RpSCt5U0Z0aWxmQmZYM3phWHJVQ3M5dWJCOUhoMFpGYXpSd2szL2Zm?=
 =?utf-8?B?UEVSZTd2cVhRWGpkYzBCckljdmxmMDY2YWpkL09OcFhKL09mRGpZeXRZOU01?=
 =?utf-8?B?RlVOY0RCYktHSk9taTJ5MW9FN3B3dGxDK2hXazFLODhVaEErNHZod1JTdnBn?=
 =?utf-8?B?Z3FwNnRETzZseVAwSDhnNFh3VDRMRGZaL0V1NnB0bG5HVGJVcFpJYW5MR1JC?=
 =?utf-8?B?NjRwclc4ditWSVMxK2F3NEVxMXo0QSs1OHljRC8yc2VoNUNvNUpCb1FqTHNN?=
 =?utf-8?B?NG0ydkU0T1RFNHZNejAwYkxFQnNyQ0Q3WE5WRlltNjJWRCsyb1JTOEtReWZl?=
 =?utf-8?B?QkpqKzVtcDZmVkNiZ1RBODIrU3drT2MyMGJpSEY4c2c1MVFpRDVQSzRsczUr?=
 =?utf-8?B?RVFmUXhUNWs1dkRVbUpBelNITVpmTzBMYXZ1VnY5VDRtRDFVZlZhMHhGRU14?=
 =?utf-8?B?RmVnRGF2eC92TTRhTGVUR1pGZ0dLRGNUcHNvK2lSeERYUVYrWElHM0E3YnZp?=
 =?utf-8?B?QWZiMTZ0TVBCSEhxdFA5bDNzVkE0dnNlU3p1Y25SQzVOcW5jbktvRDI3Q0VI?=
 =?utf-8?B?NHFKVkswelhIY2xLRzNCd0tqNmkybE1mUVdtS0hDWFBCZGxRTldXd3dxQXFV?=
 =?utf-8?B?TnMwaG9vL0VBYWJDVG1UZWw1VzMzQVl6dkl1VVRhajYyWDA4aWxveXgvbS9m?=
 =?utf-8?B?RFh6cllsMHFWYkpmeGlwT0hYamxscndCNlYwK29hSlZuQlNobmJBVnNmcUQr?=
 =?utf-8?B?d3YvUkxmTkNRSTdoMHdxaWxvdWRpQjRHUHM3SE5iTTRmZCsxWG12U2lUS1c5?=
 =?utf-8?Q?/b0vNb/8HdY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M20yZm1iNjluRm8xK0pCWmxxN1Buc2lzYUN2WnNWdzY5TG0ySXhLeHd0S1Jt?=
 =?utf-8?B?akZNUlhFWEFTSFl5TkhFV2VEVU5LK2NyTUh0eFFzUHRKZkE2YU52VnhCZG5k?=
 =?utf-8?B?Mjk0V0FFVVg1YnlSTXNrTjBIZUZDVUtPeVNuRHpKeHBFT0QweFQ0RXBSSWl0?=
 =?utf-8?B?S2RHYy9hdGFIMzYrZTlkZ1BtT0hPWW9hdUR0cnliM1ZuL1pXMXdPUWZNd1Ra?=
 =?utf-8?B?djdGeGlYZ29JZ1hLM1ZoaXFGMmVTc0RUOCtnaDFnRDE2VXhYMmNNNFU2c0lG?=
 =?utf-8?B?NitXellOOXZkaTRkQ0ZBZXBJaU52bXVnRjdQUmcvZmJKaHJUL0pycTE1dFNp?=
 =?utf-8?B?VkVwOWorbndDWHRNTDBXc2FWMkpoNk5BNkR1ZkZjc2REVjk1a1ZLUDlIc25C?=
 =?utf-8?B?Mmh1R24zZkx5eWFtUFhXNXZMeTJ1aFZ3T0xISEt0UHVUVksrWWdtdTFUQjFN?=
 =?utf-8?B?aWkxUWhQQU05azl3dy9tTHdSUEx1SXZMNlZzRnVYNzV1bVhCNlVqL1JTM3RO?=
 =?utf-8?B?YWNrT1NuZ21tb2dtYkFBTXJFTjg4QWJkRFlwaTdVNlNtOWVFUFJXenlmOTBN?=
 =?utf-8?B?cGxUSVFSNmd6RlltTER1UDRkK3BHVHFqVGJZTDdSTnhpSW1BY1UrNzR1YUJi?=
 =?utf-8?B?VFhlL2hmNEFoUyt3QjEzeDViSUNRVEphRHY5WjdES29YclpneTErVjRabHZo?=
 =?utf-8?B?Yk93NHQycG5ZVWpBOENEc3gwRVFBRUVMcmJ0R3BHbWVKNVhYMmprTVlobmx6?=
 =?utf-8?B?WENZM1I4czV5UHNlWUlxZjZBOEdocFFnRmlJSVozbmRvdTM0VisvQzJ2Tlo3?=
 =?utf-8?B?MmRrNVUwdGV3bHlvWXQzMmlPZW5oVGxnaXhBSWljcHVzL25tVlFQUFVvYmtw?=
 =?utf-8?B?OGdUZXhqSFF6ZHdscEhabW5zaWR0dTRUOFE4T2Vya3U1cExvZTBXRjRaNTZl?=
 =?utf-8?B?SzlwNW1RenMxdUl0VGxMY1JuTEZONDNhdFhjZ3pRYUxNSmJWN3JYdCsxOXNs?=
 =?utf-8?B?a0w4d3BkYkdETndsblNjZThrWDQxN3hVbGNqWXJOVCtBZTgyQldDZXpEU2V2?=
 =?utf-8?B?aHlLRzkzMEw2cFh2TzdpVmxzUk9kR3dtTDlobUlUUGpXUFMvdFJPcjRBT2Ns?=
 =?utf-8?B?VVFCaFhkNkExMUQvQ2RMOWRwaGdnRi9HWjJMZVRubGRxWGdpd0I3WU9OTEZh?=
 =?utf-8?B?UlFUVkF3RGczYzFxcnE2Y2ZtTGdoZ1NrampIWHRWYTk0SlhrUFhNRXRsNXlS?=
 =?utf-8?B?TEYzb29xYVpGODFpMmdKSFZ0SHFpNG96RWVLNlVDMGpiT2xGNktXQ0xlVGxX?=
 =?utf-8?B?WmZkZHd1S08zZWVqRnM0dnZUOXhzTUt1Z3RacmF5ejUwd2YvU0pydENRdHFx?=
 =?utf-8?B?THBsQ0NoK1krV0ZIOStQS2l0dFY0WktVb0dEa0tqMFJRRHkxVjZ0M3JGN2Vw?=
 =?utf-8?B?d1NOWmpCN0tsMklmdXUwaFZOK3UwZEpWNVJxblo5TGZaM3FKWDdjeFkrRU5h?=
 =?utf-8?B?NzcwQzVXMGtJV3EyUTNBQi9aeGFnTyttVFFnRDArZE52bGdoU00vRlhwWG1E?=
 =?utf-8?B?cGNNQWowVmkyeldaQnpaTGVGdm1pckM4dFdkZnRDZDFKRE0yMWhHSzhGSmho?=
 =?utf-8?B?K01vRzUrd0txdElYQVM1VWt2MkFtUndMRmNaZ3JLM2xyMTJYak92c3dJbHVY?=
 =?utf-8?B?RS9iSzdrbnRtb0RiUzZNRGFlLzI4L0hkbjhoaFJFSURMT21nNnZ1L01rNWJI?=
 =?utf-8?B?eGdjd2piSWJXWWdidExFdloxZUZKbG1YL1ZuWVpjY3llK0VKYjdQdTJsVnp0?=
 =?utf-8?B?V25acHFOZ3phdnZsNjJiZ1NzM2lodTlpaFpUVFpTZndmc1YrS3gybzRnYnVP?=
 =?utf-8?B?YmFEcDhua3dWNG14YlZuNmxYbVpveUlvVEdacndKQVBsNXk3VVhUODNZQVln?=
 =?utf-8?B?NktqRDNvdHJtWGZJYjE5SldaMGkvNldtVTJoQytCMkNsdXo1KzJFN1N5NVNY?=
 =?utf-8?B?Z01LM0tONlc5MWR1cDQ3RWRoOHJPVnUwMW5uOVJDc3I5TFArNDlGakxIcEV5?=
 =?utf-8?B?MnNEcnlPdXNxV3Z2SWd6ZDRCVk9QOFdzRmFnREVTTnJJcFNWOEhlcWt2UzBy?=
 =?utf-8?B?N0ZQNE8rYXdtaFY0Sm4yUG14YWVJWHRGL0tWOEloQzFLREkrNjA2REt0eFJv?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hx7DuPuSKhinjnIz5pWaQcoCyRg3BUUj21toE2Kyoi3jwzpSpBHVi3UD9gCqe+adS/EtHGuO6hKMeZCreFrOOyt3gve/w29UbBJK9CRrwUV9suGM6e/ZbNVtV7vgkliIsokrKnhsrNmUJ47mwGWR/uDqj3KVV4MuilNmiZVWhEDoCb8mFBu9wI9GfcIlvyJT6oeYHOr9v3i5AbYAknjmdf+h/2rPqE/2ELQ6YKJ8R0R3rm5fU03b4epqsCCWWN/3mz1AXwnT00nn7jW0kwxnRMb5Ih9tD4cbSQqn2ITJBlyM1VuPtG0GOuA+FBHJSwRKiNcdJ4yV6GHFrDYRaDGgLRjFXqxrhSbvm7JmG2LvEg4IufHCHsWpl1Va52hAMsVS/sJ3U/MZTDSlgxlVAxz4m6/TEvLt5Vz6dpfiug8jL0QagC3MbnWdSftT9BHzaGdFLWWvn9gNBnADqG3CIjSSgcxlGDB7DmWLwxM/K3z5lpwwikmiYvw7k/AABdzOaosiRrkagvSPNsaQMZGCiBXkD9r9PRyOMoCPu5vC7DpOsH/kDl5eHDDoFX9X+sY7k9OhF1otrj1ozShfzugIrd5Ej+XYumXlpwD3G899uQa+uu8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97e89000-6553-4977-29bf-08ddf23763dc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 20:03:07.1689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: spAfigfYUORNUJmd25WBWepxBAfZqWjS/Bis1BpfpriyISzWtxvWo94EQ2eT+G3Q2sqqoVYifnqjY9vgYGafEBFh9kVqFwJ9ElMgQOqizd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4316
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_07,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509120184
X-Proofpoint-GUID: QqLyAzSzyaIEoSObMHsgYgqL688va25j
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfX+DvPrmQDH+4C
 EdsrVr5LFFETKsODP5wmYlWGfUM68puIeTV7Q9aaEnacMCZzL8VdnyDE0fuFe2qVEEqpZgP//rN
 cAqGjddotlPiGLU4ug23xyQACnGMvd1rnnXsMHYCbrGj4KO4DlaOJSQ8o0uWiE8zL6dMI4uahVU
 xaUoDo6xc2etBvL2RRFR99KuUZr8/fe/tUFteZqhxagiPJ/tFev1Gl4evgmV2adCLd6FnMwDKvd
 nnuZCjVwgnKGlZ6rQvN4+CW95EenFhmgI2YR6MG3n1vOjw3Y0ox9OoyB2hx40KrcTUwojItCOPB
 d+bXsU3ruZ2fGESBrwMVRSg2xTzCCa7E0x4V2ws2XIbp7ILJEhYLXx4o1HfkzrhOP08mN/wwo8e
 F5/wu/Ym
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c47c8b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=N54-gffFAAAA:8
 a=UrUWvgnOX60BLFVr1jMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: QqLyAzSzyaIEoSObMHsgYgqL688va25j

On 9/12/25 1:21 PM, Bart Van Assche wrote:
> Make the @cmd argument optional. Add .init_cmd() and .copy_result()
> callbacks in struct scsi_exec_args. Support allocating from a specific
> hardware queue. This patch prepares for submitting reserved commands
> with scsi_execute_cmd().
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_lib.c    | 28 +++++++++++++++++++++++++---
>  include/scsi/scsi_cmnd.h   |  2 ++
>  include/scsi/scsi_device.h | 37 +++++++++++++++++++++++++++++--------
>  3 files changed, 56 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 5e636e015352..022cd454d658 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -308,7 +308,10 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
>  		return -EINVAL;
>  
>  retry:
> -	req = scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
> +	req = args->specify_hctx ?
> +		scsi_alloc_request_hctx(sdev->request_queue, opf,
> +					args->req_flags, args->hctx_idx) :
> +		scsi_alloc_request(sdev->request_queue, opf, args->req_flags);
>  	if (IS_ERR(req))
>  		return PTR_ERR(req);
>  
> @@ -318,8 +321,12 @@ int scsi_execute_cmd(struct scsi_device *sdev, const unsigned char *cmd,
>  			goto out;
>  	}
>  	scmd = blk_mq_rq_to_pdu(req);
> -	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
> -	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
> +	if (cmd) {
> +		scmd->cmd_len = COMMAND_SIZE(cmd[0]);
> +		memcpy(scmd->cmnd, cmd, scmd->cmd_len);
> +	}
> +	if (args->init_cmd)
> +		args->init_cmd(scmd, args);

I didn't follow all the reserved tag discussion so this might be a
duplicate question. What will you do in the callout?

For these types of commands is the scsi_host_template->init_cmd_priv
callout not called, or not called at the right time, or do you want to
do special case initialization?

