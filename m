Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02A531B831
	for <linux-scsi@vger.kernel.org>; Fri,  5 Sep 2025 15:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757085474; cv=fail; b=mpyutcrgxbaC+wYw1CrZm9DVxDRZzxAlaCzJN8RMEypmcTfNSrAxUKOnOUCJ7A/g9TgByXiu/zsDVQiJo74XjUir3Ht8MRV1avspnxKB30fuc9sChDLfIF5agRY/O5tEtpgzitjp35Eve4S2tzGmQkxG+WSfCYJ+AKfTlWa96B0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757085474; c=relaxed/simple;
	bh=mRLjjiCkz7ai5Ne1vbwz/ifjORBtJnARmtkBwsA4hY8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gfa6JHFrIDxAsPQ7M0yS1icvzLZMb+m9/KmAtMLrVR42g9Z+PpuWFBuGwHINlBA6P9VXfPx35SAMn6TCIEsJkAldf/m6VJq/hOzJddZvfIkW2vZgyvOwLktxzYJB+sANFBXPvgZ004Jm9elzI1cmlsBEFgvULbdpPukwSxgHqHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=I8bbkl+z; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xBoY/GRl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I8bbkl+z";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xBoY/GRl"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585EMfc0025055;
	Fri, 5 Sep 2025 15:17:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZX99eN1MHG7vVJOM50fTWvI5WgLGUvf2yFVJdR1CsVI=; b=
	I8bbkl+zfpcB42Bybug6boLVvdZmkw+Q+MF/r2cD67SOM2vk2ZyMIHE3LepPQ/+6
	RNRmnsc+Z92cIEG2lyij5SoXv+kGcJsiZ+XpWzUnd++mpacpFhfCf/AdN/SfSH4w
	2MQZn+/mdXjtapYUqTOPvr6AEvINW//yXkkl+Fqhfh+VtUO68shBt/j9Cq6jlJS6
	GUBeukTjpnN96TWjBGnkBOaFJx7EDyHkafyRH9YOAL68/js9sUf5vPUkpTSyQBE/
	V2BxI4KK2OD1PtcgE6LlISVrmVKkmj2NbwZWlUc/9JFiq7ML27D7Qft66nmLFMR/
	PDWAEZcX8+8ZHB2mqkai+Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4901a9r5dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:17:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 585DY1kn031659;
	Fri, 5 Sep 2025 15:17:38 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrkca8d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:17:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jMnk8yVGtxhlkjnmsElnbiPL3INvUV4rZqgGZQKFWjHoEfWd5OxHHL3ea4fISaI6jCb4JwGQOInTCiinQS0Nb0X8AKc+1gpqCyZTN/jhOD/PConznGWtUZXgLJg44aDH4HNyHQCf4KeCFt00oNBcyIoHBOJKKTQ6ob7bzjtha9/8zCq8rmtZQIdmGlJ4psG+wvpME+OzzIOtdBhFoqiXX9aOZHgSzfQHt89wocTdT244Hh1Up4+hz6p1Y+SXzS6aM36gtdKU9eCfaGH/rROO6spp3X158RMvdTRjB7IW/rSCfwIeKaqdYbSU5Qd5QyavyLLYhCTJc0S8AQQUHdy29g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZX99eN1MHG7vVJOM50fTWvI5WgLGUvf2yFVJdR1CsVI=;
 b=ai7eLWR7wD/wRM0ryRykvg4PTsFbTEaPXgnbmBzOicA/qGMOTALnfILo9YgaiCkbrDgzSmrNxZeMUvIvNCy4m6mLhSYzCBVeSRnhshNeEk7t8ToHipiBoV4ZIuBUJpLk/1f73HH3Q2jRe494sGtJPXmEfJboCog2BZpTO8ebw38myOEfx9Umop6ZEJWlEHNOu5sNLyDmIe1BtIBjPePIl1v2+EEBS98MONflNVmrS1095CDGSWic4yCnIK5Nlma5v8zyUYyDY8ZoUcTTvF42oATw5vvYrRZARCPkNC1WRIlMBSvZa3wNdDxx54AF7Is3dyQaxLT5eT8B85eDlgeSYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZX99eN1MHG7vVJOM50fTWvI5WgLGUvf2yFVJdR1CsVI=;
 b=xBoY/GRlWdRFVD3B5zAfeB+mcCWBQSZ4n7Iadtg7jbjy5wiVmED1Mo2DZkCkUglSzAVlp7Hr0jgeN/+WE+z2W0iQDkKkh/lh9EZxTeK+0e/SsvXGYxjN57GI8VBkhIshx2fhSh5sdlhY055YPsRNsmSUCNBEA0eaXsEx6kE+IDE=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 15:17:35 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 15:17:35 +0000
Message-ID: <c9b3a67a-20f2-4d2a-9b31-6a492dd17f81@oracle.com>
Date: Fri, 5 Sep 2025 16:17:32 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/26] scsi: core: Do not allocate a budget token for
 reserved commands
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-4-bvanassche@acm.org>
 <7341ada1-05c4-4a70-94e3-cd208d47231d@oracle.com>
 <719e714a-6f15-46b9-b4f1-b697ea00ef66@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <719e714a-6f15-46b9-b4f1-b697ea00ef66@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0212.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::32) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH0PR10MB4518:EE_
X-MS-Office365-Filtering-Correlation-Id: 63bc1fe6-3d5a-449b-27bf-08ddec8f578c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V1QrenhnamZGbFhPYXVVTDZvMVJSUktXcVVpaXJOUGZLUFZVbnZnM2d3ZFZn?=
 =?utf-8?B?K3pBaDFqcnZNVUplb05ZMS8vUWwrY1NLSS9nc2dEbUNQUzZ1TUdwalZkTnVT?=
 =?utf-8?B?eHpKeGd0M3hudUxnZHlrVDNQRWVTSEhPeDZFTGM3NnJNSjFLWVpRZEprQ2VZ?=
 =?utf-8?B?N3BUWmR3NnUvc1VkOEJYTFVKaDdpSU9aWHpHOWV0aitjSFZMb21FbFlkNitj?=
 =?utf-8?B?VlVWcTk0MUF4ZnJjbGxXaXBqSWhJSHd0L1RxbTBxM21TRXcwZnJDbTd1ZmF2?=
 =?utf-8?B?eTNoVXJQQzMxNWNjYzZKajVMSWROMVFwQlZIeGJ1RTBTa3ZrdzJoNjg2OUlT?=
 =?utf-8?B?N1h3NHZ0ZkQweTcyZTFxZmhheXNYK25wSFUwR1VHRldmbFlTeWZNcVduUTkv?=
 =?utf-8?B?c2o4TElVbW13TFFVK3c4ZDh2WnlMMUpaOUZCMzEwQzgvQkFrL1ZMVHYzR2gw?=
 =?utf-8?B?TzJSenpXTEYxelBFZ0U1UHpVOTlRSnF2RFpWN0wyRGZzb2ZGTU5ScVlYUG4r?=
 =?utf-8?B?aForRm83RmpBTnNqSEtpcnJHVWZ2VEFDOFNTYUxtZzdnK2ZRc1p0andnclYw?=
 =?utf-8?B?MTduSVdMQ2NveUJFNTFwYkNyeDdvVXYxVTA4Y3NQUHhxVnZHUlYxWlR4L1li?=
 =?utf-8?B?bEMvUUI4cENHaU1nb2N3T3AwVXpESjZVWUNJSkdjTXF4YlVWVUJEY0ViY0x2?=
 =?utf-8?B?YmU4OForMVBuUEhhZUtTMURXTVNDbHArYkhHa0dpYzF6Y3dHQ3ZDNFpRWkVh?=
 =?utf-8?B?dG5WSUcxMXZEak03WEJnL1ZHcS9TNXp4Y3A4M1NqV2p2cXZwVTdxdlN2U1Zk?=
 =?utf-8?B?VTk5WmNsMSsrVUpOdFN6VFBVaExjenFKL0RVWTFVeDFqaUpQaHl6WmFndTcv?=
 =?utf-8?B?d3RtemsxUmUzY01GTW80VFd1YVpLVWM5NWJiVTFIL1NJV24rcnA5ZU1hQStk?=
 =?utf-8?B?WGl3dFY4RGxoMlZqWnpxSHhVM2hIemh3ZHZKV1Nxc1BTcENmWk9MQnVyQjQv?=
 =?utf-8?B?Z3luVGkzeWFXdkppbDNPeVJldlRkYXZrK0UyaTlUOU9BUkU4YnluV0hYR3B2?=
 =?utf-8?B?eWdCYXZnY3I1NW91dHZrT2FCYi9GY0JqSEIzUTRHOWMvbEQwcXpiZ0F1TDQy?=
 =?utf-8?B?RmQ2MWNyV0ZkY1RqSFU1YWg2bVh2YmFhdTIvV1pySVFGRGdpMUFqRVJUSGNF?=
 =?utf-8?B?Qk13RDBPckR4NVphTXpoM3MvRGhzY01vd1BnS1dWR2lCc0RBNjhlbU14UlMx?=
 =?utf-8?B?Y0xEZGhtNFlNSW5KZUVkT04yWlAwZ0xhWEdBaDZtWm44S3pBVGIwVjlpMStG?=
 =?utf-8?B?dzRtUEFsdTFzQjRqNU4raUJwRVFGOUpQTGszRXFVTXpVeTl3ZVJCSEtZWTRT?=
 =?utf-8?B?ZVc5TlFic2NJK3A1c2xFUS90QndRenFsWUhISThtM2VGb0tsNjI4MEI5TVZ3?=
 =?utf-8?B?aHo0cWFzWThBaTZqRmZPVXptQnI5T2ZscUdhMlFyajJNRUk3VFNoK0h2ZTZs?=
 =?utf-8?B?TkJhdzgrdW91ZVkwS0szZ0ZuT3JOME1tT1RnUEJ0RG9tU0Y3RDY0WStCK1p6?=
 =?utf-8?B?MFptZ0RpQnNadWtBRTJHc1VSODd1a0Q2aVJncHdXcEU5U2s0a0MzdEFyWDcw?=
 =?utf-8?B?MkpZeERCTndIRlYrdWN2TENBcGY2ZlBZYkIwZGNvT1JCeFlXNTlFdVJaWU16?=
 =?utf-8?B?TWxRcC94cWZEbmJyMDJSNEJLTlM3TzNGMW1nVCtrYVhFOVFUUG5SVzFvUmZU?=
 =?utf-8?B?ZWNOWE9NQ1R6TWJWNE5vZUZoNjhHcVhxaVdCSGxHQzZhOEtGdmNQNVUyMUN0?=
 =?utf-8?B?VzhYOFF4dHYySEcwZUhFa09lNUlkZSs1aHBuMmE2c2JOT1lNOHJvUEw3YVBZ?=
 =?utf-8?B?NU8xMnMvU2NFK1lQdHpIV2NkdEsvVFJXS1dUMk55NER4bVpEY3gxaVVseUFK?=
 =?utf-8?Q?TM1JLdHJCHg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cyt4dUZGb1E3U09ETWcrNEY0UGtVbUpFZExNcU5iZm1GRGdkRkFXbmNFRzFi?=
 =?utf-8?B?WlJtaTZxSFA4ZkVzejY1VktSMW1hcHBJZDlHNkVnWVZRQkFyd21GTDJOUFdw?=
 =?utf-8?B?RTZMbkhmKytrbzArb1c1d0dPK3hBbmdhanpPR2dydThLYi9iSi9MRTJCRXlC?=
 =?utf-8?B?eTFLU1N3QmhrcVV0UndSYUQ5Tno2MEhGdDd3elRXeHZQalJPbUVnVkpoTzhm?=
 =?utf-8?B?c3lVRTJuLzRFZGdpYmFJZlhvcnFKOFFmU3ptYmRFNTVvSFdXOUZFSURGWUY2?=
 =?utf-8?B?cjFIbnRSbERVTkFUbjVmY1BhUSt4dzRxYjhld0JOcC93QmpJRks2WThBc1RB?=
 =?utf-8?B?Y25QU0liSmVWWWdwRE9kTXFZREZOeVowYnA5c0ZJeUEyOGxaRHUvWVk5eCtX?=
 =?utf-8?B?UkZoM2JQRjNQckNqamprVGRHblVUOEhndk5Nb2pNUlhrdldwQ0ZLbEdoanpr?=
 =?utf-8?B?Zm0wM0pRek5rZzYzVy91YXRwQ2lBSXhPcTdibDFnaXJPbjFna1lhTFN2aTRi?=
 =?utf-8?B?SzVUMkRqd3d3V3lkbkNHcGltaW0xclBsbUVyNS9jYnp1L0RrcHBGVzQrM05z?=
 =?utf-8?B?VlJ5bDkvdzY5NmVIM01hVldzRndoT3BGWkRjRDFqaWI3VW1VUWh5aHRhVjh2?=
 =?utf-8?B?M3JvSUFaajhvLzBRMy9EZXFvQkhHM21rY3Y4K3NwRExtWnJGMm1uK1h3KzFz?=
 =?utf-8?B?SXdrclhWN0Jidys0WWk5SVVNeDRQVXVIcSszcENSVGtZTXFzMXZSSWhJRzFk?=
 =?utf-8?B?Y0R5WlZxaXo0cGFtek1JMUt0dC9iaTN0clVqNHpzTk5vWERxNnkwVnJOY3Vo?=
 =?utf-8?B?aWQ1TFJqZS9MMHRYNWhiTDJQSXRHVm91NzJKUVZ4cWRiWk1SOFpKQXF0THA2?=
 =?utf-8?B?QVZWN3FaM1JRQlZjR1lnZHphaS9NbDF4Z0hrTTFMdXRKZ2ZodDF0ejYwK2F2?=
 =?utf-8?B?cllVdytiT2hUd3FWUFNHM2t5Wi9samxNZ0hFdkl0L1U5cnQ3QUVVR3NoVzhk?=
 =?utf-8?B?VXZ0bW9qOEZSOHdhcDF4VFFXR2VVL1lXWHU2bFQ1cHZ2d0JCdGhzOFJhWHc0?=
 =?utf-8?B?WDlydmpmNW1WZytTdHI5R2FoaHo1anUrSlE4U2NQMldsMkdNWGYzalNNZDg2?=
 =?utf-8?B?TzBISFlMbzNneGlwODg0NWNIT0pHL3VwcEIxQ1lxNE1ZR09lczhvdFkyYTZz?=
 =?utf-8?B?cTZPMjNTeDhXUlMyaU85QW1PYTJBVHVDZEdZWkwwQzN6b2FGbUlzbHVVTnhS?=
 =?utf-8?B?NUdFMkVGaVhVbjhLKytMMWl3T0FOS05KRmN3Ty9Gb2tvYmpaUVJld3BPZkpi?=
 =?utf-8?B?Z1lnOFNZTEdzUW1FSWt5QUpmZmgzc1pPN3VUSkpiUTRpKzE1OUtvQ25OM2lQ?=
 =?utf-8?B?WVdsOXBpM2RMckswcFM5ZDI3eU1qeTBsL09xYnZCRzRpU0dONkRuR0RUUExY?=
 =?utf-8?B?SjVTRlBQdTRJYWNtaU1tQ05qREdpVEZIOStBNGszMjRvVDJYNThBYURYMm1O?=
 =?utf-8?B?Y1JjdjdhTVVoQlZvTHNBUDY1OEQyUk5RK09YRlhTdyszaHQ4c2VIaktYNTBH?=
 =?utf-8?B?WmJIc0pyN1Qycnc3V1NrazMyWXdhTjlRTHNHbkdaQ0hvay9Rd3ZmTFg5ajNa?=
 =?utf-8?B?UHN5cUhyZ0p3ZWJjTU9rNndhUlh6T3c2RkNwRHdSMDJyUlBZdElyYjlnT0xM?=
 =?utf-8?B?TjRhdXFRZ3gxRGRjS2JjaEltVGhlWFVKeEphcHNmWGV2S0lzOXdGWnRaR0Nr?=
 =?utf-8?B?WUtVbW5zUnQrZGhneFlMMEc3Nnl2Z2FsQ1lqdnl0b1JHYSswYVA2ZUVqako0?=
 =?utf-8?B?WE1pOCtxQkxjUlduN240QmZ0VnpxdzZiN3laOHpaVkFJeHhhcS85eWRiN0Qy?=
 =?utf-8?B?NER2RGNNaDk5dHZkcUJZUlRuZzFpZ3Y4L0o2RGtrcVc2WThzT0VCSTVLeXNJ?=
 =?utf-8?B?SW1kRUVWUzZBVWFiN0xsT1BDcVFzenU1Z2t3QzBWMEtkVVRMMVhmdFpvNURY?=
 =?utf-8?B?d2QrTlZ3Q3ZjbDdVVEEvTlRYY2ZtUlU2Z0U4YUlINFRHSWJ6ZzdmVUhRckxP?=
 =?utf-8?B?S2xRdnBtaStwMHZ4ZmFTL2gxN1lXV1Y3U01WQTZWUFJKTmx2NEJmL1dhdCtu?=
 =?utf-8?B?Wjk1Wk9DVlZINXlOdmpkelpHQ1R6VW94QkFQaStRLzJKK0hWa21MRVAxOXdH?=
 =?utf-8?B?YUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jjf16lYhp22rtBo5P1FGotfWpP1VaFNJn38n9Ec0HNig1r0j3mJprbIXJ5o5ytGYVn1GHPX2qrBcSsWkOxVcFC4DGNUi9ca8wr+oXVrI/T7JnnC7R3eyHu26T7L5sFJ1Qq/dnv8LdnE8YpsAkXs8PGxRKurG9Zbg9Zf8WVvtfxV2pY458E6nOsoDEeP0bFE9lDLl0YpStgLihEUnl4iu/C8w+bDKLxmnYFwirGJYxzs7nofsMlef8vtta3LbiprbQjNS2+eXP7h39efagCjcMyOQhJnS6S5SQ9WNdbwrlitzaz93sqOgPXhvx+CTlVfgZvAaJOduPljR5o8Ym3gKWcR52hV5IHLWXZalY1AvmT9Ja52MZnRDZsjE1qI95lqwlkz6RWTPMU+DwAKDqEkHxrDHwdQWDJ9pxwIEccuo9icJfPSnGweoWoeP818Q0+3LHObOplXX2RuNSUjgEcR+CboZBj34lqcJ7FLLeBVsfx5ig5F105Yl8Ev0pTHpt5OvheJpYE5mtp9mOo6cozK4l4hoqr3OXrlxwfT91cNxjKf9i3F4txc3lJh4iUEcnWei6dqMGdyZkS1r8gGpZnegUDqNhIEP8X8aem56CGSgz1I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63bc1fe6-3d5a-449b-27bf-08ddec8f578c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 15:17:35.2217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKlSHTE7IJTUMiGwiEHUhOc6D9pL0h9Na0UM/5wVATadbPFo2GX+nC1kL/VkRg52mqpq2P/EJCuZ1ob9PyEL0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050150
X-Proofpoint-ORIG-GUID: vKT340gUAAV3wQgwycMQQsVAzrQZ6_jK
X-Authority-Analysis: v=2.4 cv=dMimmPZb c=1 sm=1 tr=0 ts=68baff13 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=rWn2vElnQyNi-uJUX74A:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12069
X-Proofpoint-GUID: vKT340gUAAV3wQgwycMQQsVAzrQZ6_jK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDEzOCBTYWx0ZWRfX7+wJFP3EPvEA
 zLXYkcgHDFB9B7ArQt58EU5PC5HIJyrC04Q1y/26tAHGcK3shvlI+Th7mxvzh3MCvJOHaWh1raT
 dwTwZGxqP0fGv37d3PmCpBVBgn0NKXMUfEO2RfiRz5QK/e89XPUUhyMdB3XDxL+HZLhG/E0Rq9y
 azzrpnCXd7R9i9FDka/YHQv6U+tgxZ/NOvF7Z3AvT0NYy/m3cBrtaxc+O7rJVrK3TFGaZmqL0UH
 2YLGhEsE7AEbTYzxOBDJhwoDufmBqswzrVVUW/7dmwC0AUsUlazimD4JKrvkyEmqPAF+YWDLcNc
 LxT8mwvttZxw/RnzDlpvF01PEpvzrd64isGftdQae0GQaPZuRhtNi02xDKPJ3M3XPfg6ChUy4eO
 nRcuHoly8VjOdjsbFYl4ZlEHS2Yo9g==

On 04/09/2025 19:17, Bart Van Assche wrote:
> On 9/4/25 2:41 AM, John Garry wrote:
>> On 27/08/2025 01:06, Bart Van Assche wrote:
>>> +    if (scsi_device_is_pseudo_dev(sdev))
>>> +        return INT_MAX;
>>
>> It's not ideal to have this extra check in the fast path always.
> 
> Can you provide more detail about your concern? This is a simple integer
> check and hence the time this check takes is negligible compared to the
> atomic instructions required to update the budget map.

Sure, it's a simple check. But it is in the fastpath and it will fail 
99.99...% percent of the time. If we don't strictly need checks in the 
fastpath, then better not have them.

> BTW, if no budget
> map is allocated for pseudo SCSI devices, the above check can be changed
> into this:
> 
>      if (!sdev->budget_map)
>          return INT_MAX;
> 
> The performance impact of this test should be even smaller than the
> above test since the budget_map pointer is already used by
> scsi_dev_queue_ready().
> 
>> My original problem in this area was that we were trying to send 
>> reserved commands for real sdevs and those sdevs may have run out of 
>> budget. So I was suggesting to not get budget for reserved commands. 
>> But would it really be possible to run our of budget for the shost 
>> psuedo sdev?
> 
> Yes. The UFS error handler may be invoked if the SCSI budget has been 
> exhausted and may have to allocate a reserved command to recover from
> the encountered error. The UFS error handler may e.g. submit a START
> STOP UNIT command if the UFS device is in the suspended state to bring
> it back to a fully powered state. See also the ufshcd_rpm_get_sync(hba)
> call in ufshcd_err_handling_prepare().

I assumed that the budget map depth for the psuedo sdev would be the 
same size as the number of reserved commands, right? If that is true, if 
we have a reserved command allocated, then we must have budget as well 
available.

> 
>> BTW, you are only sending reserved commands to shost pseudo sdev in 
>> this series, right? I mean, I think that you don't send them to real 
>> sdevs.
> 
> In this patch series all reserved commands are allocated from the pseudo
> SCSI device. From a later patch:
> 
>      return scsi_get_internal_cmd_hctx(
>          hba->host->pseudo_sdev, DMA_TO_DEVICE,
>          BLK_MQ_REQ_RESERVED | BLK_MQ_REQ_NOWAIT, 0);
> 

understood
