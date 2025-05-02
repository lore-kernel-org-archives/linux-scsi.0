Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B841D95A3
	for <linux-scsi@vger.kernel.org>; Fri,  2 May 2025 11:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746185479; cv=fail; b=YtljkMZztAONYMZlEWnaWDjgs0kFbWIV5S7COM8/2Vh8wdDlZCbRc+fyPixXJBxwWkOMghQpicvi43SOfJ+T8+WDmGsMHr5kTvU+U1teVpKugle2Xq+InIjVy/p++wvIGUogmtz17zs7bbvzPtd6wNqWgb5VSoT7mnKZ4ydp2HA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746185479; c=relaxed/simple;
	bh=XEnO83spoIv2+WPlPrsHoT2gz3c5oDE39YpcYzpd48w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U3SJmoRTXk/1+U80P0uvGoGwMTXSt1yqbVBm8yCzYd50OIXyTkYz0RmDsm7r2c/+6doshT90GUnBj84Ts+4PpT7yPyP6DNZRw+tuyjs99lktOSqhW7zWcMZ4FJQGlA3JAaLAXSRuVC2YsvLS6biW7YrElu13lPCxWFOWwi/4nEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WaetZmAl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=j7LFNapY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WaetZmAl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="j7LFNapY"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5425WASC015417;
	Fri, 2 May 2025 11:31:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=F9Bq7Aw1fh88WunqCJEc61e8a/afGyzy09L0SvywbjA=; b=
	WaetZmAltPmi12DsVoTuKNVSZBtXqm/3o2dinhPT50A5DR1Y+E1/Vyvhnil01Kub
	jf5i04xiKAly4LYb0KTalJJ4U6/BdB0GkEX6d9BPcr0Zd9q83v2VNqwWWKHJKYAI
	3TApMA1CH2s9laPGFWIX/AODOh95HWjhEGcLryAXk1qKum35W6iw+AW23MxHvYQU
	xjKhsUpva/q/F5pnJYtzEfLi/GHngMkjosai2QLuWuA2BotcyWR8DMBaTWYvdsBB
	J3L1LH0//4HHDHiY0U8zp3Mmx+YtAjRivWgsPWLheFe99GkNVWJL82UPVmjIiqOD
	AgEFVhmipCmylZBatN5Shw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46b6ukn52p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 May 2025 11:31:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 542A1H0Z001357;
	Fri, 2 May 2025 11:31:02 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazlp17012051.outbound.protection.outlook.com [40.93.20.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nxdnrcc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 May 2025 11:31:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f5cM0ce3W08zIdUha3/dXgOFl53SViwgvppp0j5O57a0563cSFQda7jfWhAcsudNiZKxajeosHRbn46xjaoCiExEvNS//yQ9GtPyAx9ZGCt1n1mXvZefTqVk6PC5yCfCa5qbbF7IkMXJU85bpuJ6JI08AKb+SHgA3ewpjX//2Diinq6CJ1zBB/NClF/fb+fVMpGejyZgM6lxq7pqbPwQ1rn7CYByjMAk51kbGAPfS6K8XsK2+I3c9yGXid1CBf9OnqEj6rH58iV6uh/jpWbL5J3ykNF5+1i5tPg3AlmLby/uJiDl+lKWV/agcUbRIEhqR5BGBGfBaekYBeSzNI7S+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F9Bq7Aw1fh88WunqCJEc61e8a/afGyzy09L0SvywbjA=;
 b=pJxz4GJnWyuwvqbimBqMt706GpNRglIBv1ofZTT1rJRDHgrWegIf9itDrEl/SpbRj3iqtOVV129ci1EZ0GxwFiYihXohDdKwc5nhkknyEgjhlK85p0dg/DLjbSqhkozi1WP+deZuMtBD8JnE7+fToPEueJ2TZ2mmzlGub3yTdom2y+R/bh3PmOufhIqr2s8l/bPMEt3xVJckLkn0LNYUJB7S5DhqNcuTMWb/5+EPxF/8Z6N1Bi3MQz62oRfDppzeip4juEAqucAmSdVY9fC/UxS34hdkw9xFFZ+8iyAov61FQVCdqJt+UMwSdIWKfFlfsIQm6Oid2hh24L51d4iSCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F9Bq7Aw1fh88WunqCJEc61e8a/afGyzy09L0SvywbjA=;
 b=j7LFNapYfFprYI8pcW545axtIhna2UxS0TIo3vbDMB505hZmwH/Lmoyxy6MLHwYhjzSUCvgk3EkykTscaOy9x9Dn4w++noqmGdPexeQFZsA7nyV+id06km9baC46Z/IDZAdwEKmbiVaa0jY6HBcguIAIYq//7h4qAt7CnDcpHPw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB7480.namprd10.prod.outlook.com (2603:10b6:8:165::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Fri, 2 May
 2025 11:30:47 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8699.022; Fri, 2 May 2025
 11:30:47 +0000
Message-ID: <e5ca9f35-c357-49de-af22-dcf7c7d80ca0@oracle.com>
Date: Fri, 2 May 2025 12:30:44 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: remove the stream_status member from
 scsi_stream_status_header
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
References: <20250501181623.2942698-1-hch@lst.de>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250501181623.2942698-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0564.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB7480:EE_
X-MS-Office365-Filtering-Correlation-Id: e150ade7-69e2-4d2c-b323-08dd896cc885
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UStaRk52dmJVUHBwKzgraFpWR1pGY0xkT3c1RlZsZk5yY0pSbDJiV1BjNFlM?=
 =?utf-8?B?K3c5SDM0cDhjUEZpdzRoQ3hsM0JpRUh1ekt3VllEanFOV0pyQU9MNHhSZERB?=
 =?utf-8?B?ZkJJSkpsMGZRTWtiM3UxSk1YQ1pZc1k0a0dMci9oNllac2t5bEUwcWlLY2Rk?=
 =?utf-8?B?V0ZpODZwVUYxbEV3TUpvVXk2YnphRXJLTHd2UGlSTndKaW95SXRZQ1A3MlpG?=
 =?utf-8?B?bDl2OTFFZkg3bngxRm1xSmlkRHp5Wmp5NnNzeVJDZXhoSE5oYk5rRmkwd1lL?=
 =?utf-8?B?cFoxMmdWYjl0M2RMUFV2WEsyS3lnK0VSWWpJa2FRQmxLRTY0SkIzMGdhNnFk?=
 =?utf-8?B?YnRhSzJubFhrN3lHeFJOeVpmNjl0ZDVBYVEzWGhVQWxFZTNtam1KZlFwekhn?=
 =?utf-8?B?aXVzdDl6Q0FqdVdlMTJ6a3pEcDh3cC83c285MHhGY0ZyL1A2Y2tiSUd4V0pR?=
 =?utf-8?B?YlNBQi9zYWpiLzVUMm5keVRxS05NbndHTmxzVC8zQVJjaG5ZQTcxSllnRUsx?=
 =?utf-8?B?cVB2WERWUzNQVDVkRC8wc251R0dOYlE4RWt1bHB3YTZVZnR2NTlJenhGeXRz?=
 =?utf-8?B?c3R4RURLdEswMm5VMnh0K2EzOVlucFViSFRDVWk2WmxaVDJNUHZPbExJMWtl?=
 =?utf-8?B?Njd0MU5nQnVhY2hFRFMyWnJQVGsraFpjYlN5aEF2WXZhRDBJMWR3RmRTb3pw?=
 =?utf-8?B?S0FwVnowemtvYlFKSkljbzVaSU9KdkNPaVpqODFTQWdZcVllSTRnRFB4V2t1?=
 =?utf-8?B?T1RTbFZ2SzZLdnEvcFQ0eDR4OVBlRm5UaGxTUXUyYWpSY09RZnBtSmNGR0ls?=
 =?utf-8?B?MmZnUVAwTTlQSURlSUZDZlBVVFlWWFhzNm9uQjVRNFJ5WmJCNUFCV0ZkenVs?=
 =?utf-8?B?Z0QxRGs4SjBybzZlL1lJR09EMlhtNjN6UU5oS2sxcDByZXNYd21BcXF0Vjc1?=
 =?utf-8?B?MnhHUUQyR052ZGptbEVpNFYzV085K1BlMEZJYnFqdzNkRUdTVnh5Y21ITnlz?=
 =?utf-8?B?QjFTKyt6TTNpaml2eTVjMURHbW9RRzlZckh4V0VTNjhJbVNxQU1mNnp1S0Z6?=
 =?utf-8?B?VkpYWm0wLzkrUXJFQmFzVjZhNkVvc1pZMmMySzdtRmV3L3l3OG9LWU5nSGZ5?=
 =?utf-8?B?dXVldU40NG9xR1ZURlZGQkdWRURBRHhveU5IN0xoRi9VaDBCTlE4bEcrMzE2?=
 =?utf-8?B?Y3M4aUlFT3U4UGV0Mk1DbEF6M0NxaVd1NTArZFhQZEVkazZyQzFockVlUXh4?=
 =?utf-8?B?aXhYSHhWMWFSa2t1S2o3Z1NKNVN6NDU5WGNqWEJmZ3RPY25EMk96VkhPWmJq?=
 =?utf-8?B?V0tWcytxK0N4YkxTRU1FZ0NtYmxWajYwejJBMlVyMVF3cU1uOUEzc2dvTHlw?=
 =?utf-8?B?cWtJdWRTaEhHQW55cjBKT0lxSitNMms4RGJjb0F5K29RRDNQUFJiYmpybHNz?=
 =?utf-8?B?aXN3SWtRR1ZPMUNnckpxSlhGZDZYbk1WVDZpVkVVS2RBSjh6dDZIVERldjdH?=
 =?utf-8?B?M3JhNkNxRlEzbXRubDQzTXYxZFIraVAweVZOQktaVlpQT1FVKzNlbHNoTzB3?=
 =?utf-8?B?RmRpVWpvVEs5YURNWjR3Skx1Q0N4WVByZ3JiYVp3RENxc29TVlNnUzdNdHFZ?=
 =?utf-8?B?Z1VUN3JUME52RWdIWW9BVnhDTUx1dGF2N0MwSURBSDFwVTE3dWY3N2NqSzNV?=
 =?utf-8?B?WVM1N3d3VlFPeWJMUmNwUkJJODN3eFR6TU5pTCtOd2lJaEVOWnYvZkZGcGJr?=
 =?utf-8?B?bnQ5WXpIVEFRb09kdEJCQm9Yb2hGZmR6WU9TQ0xPUzBGZVI5Wk42UCt0ZEpT?=
 =?utf-8?B?R2J6aG1LdGVldkp3UFlaT3NoQWRuNWFYeDIyZzV5SkhQZGtJYm5rZ1pVd0lC?=
 =?utf-8?B?S2l1ZXZsSEpXZWxCei94b1ZGV3RuWlpTcXozWHNqaTFUVFFZWnNHYzlxa0o3?=
 =?utf-8?Q?W+4qVJhjFbQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVNaUUxTTkxiWkpLTEtNYUxKamJ6NnBmT09QalZOcGQyZmtiSUFKL05RN24w?=
 =?utf-8?B?VmtuRG1IMituMzMxZ2lrN29CelUxeFprQTNJMjF4d2ljd3ZmSVpKOWlhZU5X?=
 =?utf-8?B?aHk3K256L2VSTVZOVVNHVmNJOFk2S3lQT0pEbUZ6UWxHcEJFM0w2SVlKZ0h0?=
 =?utf-8?B?WGwxd2pabXBRZE9YL0p5UGpidHhOM2VGd3l6R3k5akg5a04xUjJOdEZ0bGl2?=
 =?utf-8?B?Y0hWaUNpMzRaSzdxY0RpWkh2eDYzOTJUUUdDcVhMMkNZdnZlbnU1bmMyVW8y?=
 =?utf-8?B?Vk0rSWJuTFRaRXl5Y3RLMzRHNVk3Z3VzSWRadGRDTFdwdUNuYUN3Z2hlZXlm?=
 =?utf-8?B?R2JFTEJvRFNsMUZMM2J4Sjc5Q0xoekxmaEhkT0diMVpMaG90NEw3K2lPNXNz?=
 =?utf-8?B?bkJxQkM1L05jcHVvYjloQzFHOWNTRlJqMzNHVDlvYVlEZkh0SCtIWGRxZWlo?=
 =?utf-8?B?NDdiWGFlczRuQzdWQkdTV2pyS2w3WFM1dGpFKzJNUjJLTmRKVTdRQ3pVV2kr?=
 =?utf-8?B?UzNVT0t0LzNFRlBRd0RHbzVLUGxzYUtpRUZ4cWFXLzBFdlN1MGd0S0FrMDRZ?=
 =?utf-8?B?YytWVEExNDdlS3I2N2h3Z1hzSVMzWEI2cnJxcHA0Q1V3c2hLekFvT1hZajZB?=
 =?utf-8?B?Ykp0ZERwU0JBTVVYQmhSQkRyK2pIbW1rSEI1bjZGVjBDZC9hK1R6OG1yT3dq?=
 =?utf-8?B?OUs0cHdobkpyUVRndmNkRUFLZmRqMlg2VkNuRkxidlJjSmhXVVdjQXpBZHpy?=
 =?utf-8?B?SXc3Q2ZqNEdDZ1hmVHM5eU5LVEYzc3EyNlFQMWpaa0xqTWdIdmVTUDUvSHdF?=
 =?utf-8?B?R1MyRWh1UG9xQ0ZQMzZIK29SUVY2Y1d2K0kzei8xVDFCRHdLV2d0MXdWZW1s?=
 =?utf-8?B?dTlNTHNaWmhiTGc5UzgzZlJaaFFJdkJCQldrOE1Lb2d2clczeXZueWVudENS?=
 =?utf-8?B?V0FPbnk5OFdyc0syTVB6TDdtb2NKTHh2bmVtYVBPN1BKN0RialM4TzBSMUhv?=
 =?utf-8?B?dzdWRnpqYmRVbVRJR2pQbkZQbkQyMU1UQmhyRjhLMG1obWczTXQvRzdsYmx5?=
 =?utf-8?B?STVWSjBDaCtkeVAzcWloWlRSSVVnSll1WTBVV05LMXRrU2J6OXJvM0VnNzRk?=
 =?utf-8?B?ai9mMm53OFdnWnpQZEszc0s1UDI0c0JLclo0NnhYTHBGZnI3SWw5YUNnV2dW?=
 =?utf-8?B?VEFwd1FZZlp1NWtGNXFvMCtRN1pOV284d0NTZzlhZ2I4eXB2dEs5Ymt5NnpR?=
 =?utf-8?B?SnJsR3Z4OGVXK0lFQUIyeG9qeVZOYzhXVWtDQS9EdTIzNjlkTTJBcDk1SDJQ?=
 =?utf-8?B?amhKeG9TdnBGUWlRajdTYzRVTjhOM1Z6ejBETFdHMjZaZkJFek1tbW5QQjlk?=
 =?utf-8?B?WTRhRVpnb1pvdlBmL3FJZkZiNm0vTmdkZHpGQ1g2NDNDUGdwYWhYSzJqZXpa?=
 =?utf-8?B?WWhEVU5nZFg2NmhoMWpRUzgzUTdMZ3ZjcXo2OHpielR4UzVzeVgxalg4blRG?=
 =?utf-8?B?SzhGNWREcnFJcFc2Z3Z5R00xU2RrNGhtUlVqYTNRN2JLVC8yQklrelhiUjBz?=
 =?utf-8?B?bURqbHdac3ErODhpNWVncVRqdmxlbVFoK2JDQUxTbGlza1RQOTkxRnF5SDJ5?=
 =?utf-8?B?S2NwSXFpM09VcElIZ01JczB3eDBuZDBUcXQ5WEViY1VIYzdPdGlDdUt3ZzNT?=
 =?utf-8?B?VWpLeEVHQ2RkdE4yQ0pZLzhkdXVNSWRYNEJCUFkyaUNGZ2s2eHpWNUdiVHV5?=
 =?utf-8?B?dGl3ME5hODhRSGE2Uk1Zam5xNEtrWmJrYWJJL050VzMzbndkV2NBemVLZ3pO?=
 =?utf-8?B?aDl3Ulp5cTRVeU1UTGh6U3FHU3BjU0dlZFY5WWIxU25pcXhEOVRhUkovNE1S?=
 =?utf-8?B?NS9sYjdmRmhxOXQxVFpwL2RxSjZQYjFHNzhOcmN0WFhnem84ejFid3VpRDRR?=
 =?utf-8?B?c0hBRktPa1RvcHJHUlJtcHdkWSs4M1ZTTDhNRjRlSGhxK09pMjBuajgwQ2xj?=
 =?utf-8?B?aDBBUERqREs1SVJDNFhwNDRNdnN2T3A0U3VOMUpJQ3FBZ0RBV0pZZm9GTkhj?=
 =?utf-8?B?NUR5WnlVSnJCRzE3WTVmVTRnM01QUXBSMkpXc2hEcDhNeXZLOWgzTFZNd3g5?=
 =?utf-8?B?ck9lVVZBeFpzTStKaXN2RTM3cjBpbDQ3L24vS2dMU0M3OXNXcTA3MHhDRnJH?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2RTj+q8CNs2OlaWP+BJ60byiOe1kHqiIWaL9XvmvQ2T1pblwY1js43qL8QjrgKjZ1L4lOVv89Ym582mVmJyace6NcuxRqL1BYhb15nhgmep0xPDKAdG/jg8li5M7rL6pAROPnU4AnQ2kyoQ69nvd3r8ENoYnviF4lR1S5WoSOX4Hh5U6iIGYVe13qbcntd+wMubeYGkPlCt3Ci0vsRppi+UUKnUzErXbHpqkikUmrOPaqLseWC1XoeY8CeMXJfE4Y6cXmEL5xTtsh02QRZwcoAlvO+L6RM0Nqxm09XlijA/XV7+Bf7bCbK5zY8mvW5Umtzv58GRIQQMMlvucvuACTCGVShdIDLJyYbrbT6PmcwC2FuMwZJAlrqavDiMO7ZJ+sdQ0TesfPt4l6cTZtPzC5gDtAY8Lxd7g0n3/gV6L9a66GqI2zo1M+z5NPaKafZ0MDvDiFYchPHevERjGZTfnbLm3hFbI2pphSLHPzrF0Sd75RvTJSYMT8O7MgUghaFdu5LQbMUcvUJ/MAjEqKd4f1pQZsC1bUYrteYo+YAXJdl/XzNC30yk/C4G933evp7wd1KB7F3P4jhzI5sKtltTNc0lOSQiz8v25ArgW0+Dru1s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e150ade7-69e2-4d2c-b323-08dd896cc885
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2025 11:30:47.3223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5755bXtq4neNhxQzEdn46w9WLeZr489T+Sfob5szfeentNUYLovgW4GMcCU3L+xDSZWsSGFwsyKu/bnBwYOKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7480
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-02_01,2025-04-30_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2505020090
X-Authority-Analysis: v=2.4 cv=MIZgmNZl c=1 sm=1 tr=0 ts=6814acf6 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=MlAHjWgV6TANj_rd7hUA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13129
X-Proofpoint-GUID: GF2N_kTjNkYpQCUoouI8zSHwMudpmqdS
X-Proofpoint-ORIG-GUID: GF2N_kTjNkYpQCUoouI8zSHwMudpmqdS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTAyMDA5MCBTYWx0ZWRfX1kqGo2vVipbM GLqgj3cKQIcZb/yEG6APEtBlsgGFL48ePqo0bhc8KLTX2fZuFOH15Cig3ImFrQjeFl+cXan2SKY /d/baHAPwmg9sUkZltD0FQCGfi5fTBk9v+1/43lMrhjoKkZiFtoi5Jw5bK7oxzdwP8ZQDpaN3+M
 i0NXCsqBEKeb11v6YNf5rC9txXvThMXl0aVC3sL9t94TJnH44DrsuoztYzK0muYdAQ5TMNWkrCc CVyRXwISxrm4yqTFb4Wfm3AHJeXvsqfDPTPS5M6ckq0gx+gFGwYLdlVLl3LdbgXNK4KCyIEF+9d 0oJbq4A2WQab7Wt71EkF5IgRMem+Wsn0407ly9X0vvAiKDl/z8BTlO6urkQjxbYj+fj9+uYbm7s
 mjdJVnE6Oj/hNAridZ5mo+gKoKKmYrwoD0fBKsO9GAwTcM5OuyK7Wz1j0ehyBhAPdYbOJl1E

On 01/05/2025 19:16, Christoph Hellwig wrote:
> Having a variable length array at the end of scsi_stream_status_header
> only cause problems.  Remove it and switch the one place that actually
> used it to use the struct member directly following in the actual on-disk
> structure instead.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
