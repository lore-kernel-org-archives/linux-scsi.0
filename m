Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D7D2C159A
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 09:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756978910; cv=fail; b=FkXkwC6S8gKNJ3GhRPPE3rEhMBxK8Is6Y2b3pDf172Q+8KZ6VjPNYpLyTmD6xQCjxV/9dOcVxcnBGdgFOCBePbaokfVfQrBKZ80ew4mOQgW6/D2c5jklHL/+zj7ShAfRzqUkFIFh3BRc36kByVcGmj5Gjl4+MukGEzjvUF+1ZzM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756978910; c=relaxed/simple;
	bh=4A5Dle6neemjLTsScoI4domiy1jtzf7fazgfIKF1s1E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rEcjBXq/f2qyItEjd5QAoNSeO+EPwOgaJoSpoEG9/OixXyQFMDBcxIVabhd+Vara61KxMR5G/A/d8X0m70/Q4eWVQTsMA+uvwcr7iqcxWelE3lWzTk6tFW45D4HOJpIRWmeFl5mv/wjxdlSv5GW21ri/Tsz7vEeuWvgKrYTr5mU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OXTuy1rr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=US1OtD7Z; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OXTuy1rr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="US1OtD7Z"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5849OqhB007562;
	Thu, 4 Sep 2025 09:41:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vCEwmcl33085BtAkNp4sjyM9R6DjoBfhdbVabqPMUkU=; b=
	OXTuy1rrmQV9sVa8D32KRIbTcItYdxE/hDDGvlbJNx+8bAH0e84x11R2cq2XUMqS
	c8pVlaVvSJq97AJfwgpTARkziuZI+XaPGv2DaI1xH87MkUIK5BPDu6zvMbxgUXl1
	fVX6Cxb6quwb9vc+DiJxMHJ2yMcZWtNsb10F0f7sPFS15ykJiJ+PDehc+kVy1Adw
	hLKFXX0IhtZTvgbcndBZ2YA/MdC7Ok0aHY+sXfMENvQOx/hNS+cjLRx4DdenGdHn
	nut+1lwhaE4kjbAtBjdUj24whbcMzmwl2ihAlvxpHYH9Z2r/egDi+wYo/E0+/5fC
	eiMQJIXD2iJMsSI26OpzKA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48y841g16t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 09:41:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5848ed8Q032616;
	Thu, 4 Sep 2025 09:41:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhpxsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 09:41:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VnFG+VAYP7LlqMjCpmIwuylcFmqeasrdUzd1R1mQ4C+uXKDoWa8p656QCntqJv5Wric9Rns6Hs61W4SgnTtmU66hYi8HRhUdY5XZTs+rBkP+DHQ/Vh8i5Xr9oRi7/JSsfzFLUtJKk0KrWw/xnwQ4fx734NXz+39MBTRJwinOmZETlmj+8ds8LDvp5szAKVGs410610BrYy/hWXaXj8xzgrFlRZZyOIg+CsItRXx+YgOElA2zJgrbAaHMkribj/CazIv2yFSZ21cKvyJVy3ECV5Av6S0rl/1Pkukiia/8j/cYX/uB3NcEJ5PMJ8Wm18vWpMf4bbWzoHijH39beomXXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCEwmcl33085BtAkNp4sjyM9R6DjoBfhdbVabqPMUkU=;
 b=RWU67jifkGVzNuzTLCPQdD4+osGuwRQuPw5KdXqEwZnZ0DjeRRQg9GTiJrB+HUrXJ2CgPymN7AzXh2Z3Ul+j008EwFtbzGrvylO2eH4O+Bg+SwQX7VQUwXa5z4LTlnOWQfsBvIdkpZE1lNzmqU2N2I4kngSHaNloM32uvjWE8rd6Byn3fWW74dbT2UAvBjQw0lxMXtC5qOKdWRS66mWmlRLfx5FCgx29xBXcRhEk4LBRNEqGYueUXfIQxDN44Rniv9Q7IWg9vOj+nhwKQXTk1BrnwCl5wjo4Ge+Y1X75jRUXx0/IaOa93+BFNT4/CsSnFGHVAzOtRTKNvxeM5U1k5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCEwmcl33085BtAkNp4sjyM9R6DjoBfhdbVabqPMUkU=;
 b=US1OtD7Zbs4RNchUTSutF8QzN5sE8QvhOp729FT9+nj3PrLc1YY2RYloCJODM7mND3cjfM8aBlCk/Um/DrUMMgaiFzA3LYjtRQfT8xpAXgjZuPWJ1Se4i2GZn76cjybsFgqSqif+ALrn92oW3yhbXY8SzjC9nTEAEc5Hi3ZgHn4=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by SJ0PR10MB6327.namprd10.prod.outlook.com (2603:10b6:a03:44d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Thu, 4 Sep
 2025 09:41:31 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 09:41:31 +0000
Message-ID: <7341ada1-05c4-4a70-94e3-cd208d47231d@oracle.com>
Date: Thu, 4 Sep 2025 10:41:27 +0100
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
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250827000816.2370150-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0121.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::18) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|SJ0PR10MB6327:EE_
X-MS-Office365-Filtering-Correlation-Id: 52a2d71c-e839-4f12-0728-08ddeb973a71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SFlXQko1cm8wZHFZS1c0OW1kSGVScVFFVmd1Y21NN1huT05ncHFUek0wWDU2?=
 =?utf-8?B?UGtlS0RkMlpTT2JRV21KeWlYZFd5ZEN1TGNDZjJpNnRTdU81ZkxQQlJHTUkx?=
 =?utf-8?B?U0I2VnFRNXNaTTJwakJlVithMUI3dzdyNTZ5T3MzWHdSUm9JcWtEbGN2SzZC?=
 =?utf-8?B?bjdad1ZPSjFMdklQRGZzOFBrUzdRU0FDTldYUHdxdjZuT0RtbnZHeWJLY0tY?=
 =?utf-8?B?aTVrSitoRUM0MXlmVXVhYitGbjJGNndpdGFtQlZTUGFScEkyTkxHN1BRYVU1?=
 =?utf-8?B?ekhnN01BcUc5Z2U1dTZTREtqamh1Nlh5TXpMWVhwV0ZEMmpqNVhEYnVDc2M4?=
 =?utf-8?B?TFR1UGJhUkpvK1MzbGFjWVc0NWVtMnR0UDU5emQva1p2b2JFbGxITzhFY0J6?=
 =?utf-8?B?WndtV2YwcjBpaW5odG41ZndJUVdONTUrVHkwMkYzWkkxNzMrd3dmK213aUtq?=
 =?utf-8?B?M3Q1ckVsYVp1UmRWZGdRanFGYS9DQkNKNjgxaVlxNlFKM2swYkR4bHg1YmFo?=
 =?utf-8?B?Z2R6ODQ3b0NONElEU2hRTVQ3WWNkN2NleCt2alZNa0ZCZE5pWUh3SWNaWXJ1?=
 =?utf-8?B?MjgyZVhoRXcyWTFKTW11dWpwYzJhNTRoak42MHkydTNRY0ZZWGxxL1RpSS84?=
 =?utf-8?B?ZkdNRDZzbTE1NDk1UENHR1k0WE90bm1MVExZYytURmNWaStoZ01Fdk9FUHl5?=
 =?utf-8?B?MHM5bm02KzkrakJYNy9nU1lneCtpY1c2MGJwRFoySWd4WXBiZHpPUUtvWmpN?=
 =?utf-8?B?SmRNZ3NFcU9aVEI2WFpvQ2cwRkNuTjdwY3UzWU1QUzBLNURnNHNOZnFEbExo?=
 =?utf-8?B?ZDFZbjhqZUx4ZnFWcHdNdjhmdlQvSXIwZ20yTVJJT1ljVEhvZTdaWXNSMndJ?=
 =?utf-8?B?aEtnaXc1NHgyYmk1OXhKU0hUUm9aZm50VmQrUTEwVlR0OVQreFNxRm4wamFp?=
 =?utf-8?B?bDdpNE1sSTJvSzVLYXpmSHp2NlEzZG1NYWVZaEZlV0pjWFRUaHU1dWdHaEo5?=
 =?utf-8?B?cXJLVWlPTm1ncVRrQ3dSL0x4WUtvMnl2K1RlVmNLbGl5SzBwK29TTnRPWEt0?=
 =?utf-8?B?K05CYkpzWU9KcnFSb3c3R2NueHhXbGN2bXlCUm16SU14Q0dUR1JnQi8wWEdI?=
 =?utf-8?B?VXZsb2lvNjF3VDBaWFJWTlNYK0krNUNTN2tWb2NrQTNiMC9vdnFITUd1NWpM?=
 =?utf-8?B?bzZ0RzJ3UkdFdDFBSjhMZ0h5bDR1Z1Q2UkJqQ2lJdnJ5eDI3YWVobXo4ZEM1?=
 =?utf-8?B?YmVxSTBrbzh0cm8vaTIwL0J3MlZjSUtuQk1ESitWSGlOV29XUUw5cEl0ay9U?=
 =?utf-8?B?T010cElHUVNrdUdJQ0hMOXVWdkEvam80djVJWCtOWWFmMHRHckVyRXptQnJO?=
 =?utf-8?B?SW96NzZMT05mZXFpZStRYTBDbHZZSUM1NE1uOEVQcXk4cDZPQmdRZmpydllV?=
 =?utf-8?B?SUw4UEZTbU40K0NJS0oveUVYcHJSY1FEUTd0a2V6RWtqb2FkOWFvUGcwRTBI?=
 =?utf-8?B?Q0RJY0ZYNEpyUzVvdm5SM0lHOXB6KzZvSnp5bFNZY3REODBqTWJ0bEszVG8y?=
 =?utf-8?B?WjZ5U2pHVTFtLzFPSlh4Y3ZGakd4ZlFHUytwQlp5aHQzQjNWOG5YRDhOR2Fi?=
 =?utf-8?B?RmtKcTZ1N25DV0crMUprMjZ1eTRiZVEwYXlZVFVUV2xJVEtDMGczODNJM2FZ?=
 =?utf-8?B?SW1tWldmMTVaRUluV0ZlOGNEUXFLQ2dnSHA1VlM3eTgrUG9ZSlNld0ErOVBE?=
 =?utf-8?B?TS9PeFY3Tm9vMG1SeHM3NDNJVFRLaXZNVTF0L1ZvSUg0K25NbW95QjV0OCtC?=
 =?utf-8?B?WWRIOTRSaG9EOU1KNHg1bkJYY3pxQURadERVWVBqSXFXT1gzckM3dlJ6cCtY?=
 =?utf-8?B?Vkp4Q2RjL1JhbSsyZWI2V3V6akh1cHlZeTNERlB3bUZqM1FDaUU5SnBYRXVs?=
 =?utf-8?Q?0Hovd7aTfFs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTBZZFI1eDRONWkveDA0ZURaR05iZnFxcnY1eXlnTG9naU9sclFEUmZ2eVBC?=
 =?utf-8?B?VjR5ZSt6UUgzdTBJVWpBSWpEWVJKRE5KMXZXREJhN0MvZGZacHhhdndNcjk2?=
 =?utf-8?B?Wmc4QzY5UnhMS2IzYUNOenFwNzVjQWc3NERWRXdjMWV3Ull6bWJvYkVzdWw3?=
 =?utf-8?B?Z1FlYmFCMXJaejJkY0xNOEg4QzVHOEdqdXVUZmNtRko2Rm5jM1VZRFVhWkVj?=
 =?utf-8?B?MFZzVWUzRVdodkxUWm5vM1RGVVpPZGh5b08xYzhJV0tkb3RjWFJsN0hiQUhp?=
 =?utf-8?B?VjhsYnU1UnV6UmlqZStlVDlvMFNZenpCZ3ZWT0NIb0VMSkd4bHV5RG8walBo?=
 =?utf-8?B?OWVHL0NGZ0RpR1JpNzd4a1ZRZXVQcTQzU1dIVlVWSmswdUp1QXgzbGlHRzdY?=
 =?utf-8?B?V3I2aTRLZ0l1MGpQSy9OTkZZUUhvOERXcGNtU0JDZUtSTXlaVFJ5djJ1TXFn?=
 =?utf-8?B?NDdxeGtyZzFacEdGV2plWjN0QlpEZlpnZDZ5U2lVWVIyQ1BHOFhUT0M3ZWor?=
 =?utf-8?B?R0p5R1VvUG9JWEI0enhhU0QwckFVMWYrVU1ZYzA3MTc2QVAxWDM4bGFrY1dp?=
 =?utf-8?B?MjZINlVZeURNSEJBWjVzYTBnQVl3SWRHaGtENElwSlVpdW1NaDRXSlUrN1Ju?=
 =?utf-8?B?ZGdoMkJ0eFZsZmdReC9EVnovL2pIbVRHQnZSY3ZsVnR2dDZvUVZvMk5sKzd2?=
 =?utf-8?B?VkJ5RmU4ZkxUeldrU0pBRnQ1UE1SdS9ZWUkvWTVna0h1YzFQdjE2MXlpTHAy?=
 =?utf-8?B?RXYrNnhPc3p0T2R3RzJoOENrcTRVY00vL28raS9zRDlCVUU0UzdMRVNZZWZj?=
 =?utf-8?B?OVlXQW8vSmVhMDd6TmtCaW83aDJ6WGxIRkxNV0dQcUtUREtJckpoS3FCUUh4?=
 =?utf-8?B?Qk5aK3VyTXNjNHdveGdqS1ZOeVNWR3hJNGdvdG45S3UzTXI5d0tXcXJ5SVJh?=
 =?utf-8?B?UjRqcW5WWHloUnd5QWJkT0dodnJLK0Vnc0VzTzNibm81WFNmbnlFVkIwOWRz?=
 =?utf-8?B?MXk0dlM3N3lYdFoyWVM4QXpXb1pHVkg1Wjg1TTNmVlltWjdJdEErWHdUTkFx?=
 =?utf-8?B?V2hIYTh3eU94Tyt1TThEemc2OUFyQ2Q1WlVkeldlMkZmd1lpU0EwY0pRcmwr?=
 =?utf-8?B?dE95NXRuczA5KzhrWjl5dE1uZnNVZTFZQkpwVGNhRHJXTGZLQ2Y3ZVdnMDFx?=
 =?utf-8?B?Sy9WTkdsRlBoeDMzU3lCbFVpbytUMld0aTIzRHQrWTA4eTgxalFyd2d2ZXBJ?=
 =?utf-8?B?Z2NpMlRuUVJia2RKVEoxVDM1TDRkZDlDWTEvU0ttTFRBNG4ybWkzNHBlalN4?=
 =?utf-8?B?dlhNZW1LRm52bjI2blRyOXlXKy9UMmxnOHp5ZHpjOVZ2Uk93VE1LdDg1ekRT?=
 =?utf-8?B?UHVPMmF0c0t0bzRkMUI1WGo4aVV6UUxrdUdiUTlhci9PR3AveG9DZlpiVVZX?=
 =?utf-8?B?c01CSS9acUpNQ2l3NitUTzI5cmc2TUVYaVcybmtVdmd4VmNSak9sbGFieGtS?=
 =?utf-8?B?blZualNkdGQ1MWVvYmJ5RlhVaDdSMkZWZzFLWHB3THE0QWw0OWNqOWg3M2M1?=
 =?utf-8?B?RWhqay9kWFBWK0hkRFhwVkJGK3h5RnBPcDBsdjlkZFNud2JVdEdxbmJEenNO?=
 =?utf-8?B?amNGYi9QUjJJdmFudW4ySXBxZ2RqWkZKTFVHdFBCL3pMbTN0YVJHZFYzUSt0?=
 =?utf-8?B?ZWtvamhIR2dYbzZyL1p3MzhjMGRCVkl2ZjNHZU1iRzUwOENWQTZkNjJ6QWxh?=
 =?utf-8?B?RUtPNkk0TVZNVlV6cDgxSzJaYXhDWXlTeElOZTlBeWtySWhsU3hJcFVLZlgv?=
 =?utf-8?B?ZHFxeDB5YmhzT2cxaVVTMkw0VTBUakYzcjVwM2QrRXFOaGk4eW8zbHlRaE5B?=
 =?utf-8?B?UU0xQmpsYmhoSHFvS3VaR1hSZHNDSkloOFh2TGlGVTd4aGt3ZnlIUVp3ZHlx?=
 =?utf-8?B?RkhvQlhYcm5PdVZhcVRxS253SjhxTTdpbEh5TW0zU0tkWm9KN1Ixd2RsUTdy?=
 =?utf-8?B?RVQ2TlpyMVRPYVhUa2hyaS9XSkMwbVJEdncyVGk4ZElHMVlkc0JZSk1wckpi?=
 =?utf-8?B?dHFaeHlBZC9CK1d1OXdHc2FzYXpvSm9jOEVSaWhUQVpwc2RzK2VoaVpmeUVW?=
 =?utf-8?B?dkZxRFdKWTljZDdYT1ZtRExpY1llLzEwM3pwSjl0c3hXMHZrQmgzN3FLYk90?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h2n+Ql8grbpFKUexZ0uZiuYxmxsSLvxNoqBBTBhoDeaCsPsgbIHHSxAs+pVhHphExrFnNJ99Cy+3/ICfcppw88ukUloGoq++hcuI86khL4oG7CAS3uPdhktYCOJwZZOzx5VzsU05KcY6DXoGwnFPTe7UA14Sxv8gqLadx9V/OOpqDGUjujbgYoO1D/CvP2AHAfT0zX+w0ynPMQpGXP2y2qzzfgTqh/Pi3qGCz0Zde0I2Kxf8QooUcNawsFYY4uKArG9fTETAzE4QQ7Yxbdd5kCioVgu4mYSfFwBVlnrr2SNedz+8UBxW2+JeSTRkn7sglvx+cL+oWERjMn4g4mHwTwhUmANKElOU3jDVjxXPTrJATEJMqksPVAcAIRkV2GYVcNbQ9ci+yFNfz4T8OjIiCbOqhYNWH0n1apWOe7a1FVUYUrs1RLo6jYlB5Ec7ffvWU10nj+d74QJ7aVWT4c4EiyVN3QG88LSt5Qwk9YPEjs8wbGf8bFztSWp35FzdZc1mv0UDIw9Lk2Au6dC8r0cr/YkaOOuq+yHFuxANw+C4l+tcvcQtHMv8CBzMcg470JJLcEF8or6QcMGZF4y0BWccLl/0OFVGTFbUDLLBBFJcmrM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52a2d71c-e839-4f12-0728-08ddeb973a71
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 09:41:31.1973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TO3quzWmsYsPomvst0dHgn882AJ/PPDQCtps0qWYcqiHlKmKnGCspRBF1t+XIBj/9CuYIwoiPogkflSKmkvyWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040095
X-Proofpoint-GUID: 5tjKVZb9s8R3flHqBq9qatLjpL5Yba9z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDA5MiBTYWx0ZWRfX2AzgODoQJPLi
 nlUCZEg406J+EwMuaAy1MbuXtSjoh97BLqlIyo0fEC2EaA/xxri+j97aO2WZ/eHA9/ai+78xOTe
 YaLcSMeAp0Hgn7eJklAp6CyTPiWmEnndqV1KpCvgOgGiD5j5V9ya4IyWJeQYLB1djGhPy4feTw2
 0Hw8nxjAJonyHDeT4r9DBmp4imRXb9+nbr+Axi+Cv1/Kbs5ZWwjzodHb9aJoGNCgQez7yX/4Z/y
 5uQCF7hlwZWXy1egRxx9XkvmdzpJh9CUGy8eyLTDRzEBxUTTU725xyMUys6NbnMkz/EnG2aFQKG
 5Dst2hPFborOXXXjuJaKv+yXLCcu1u6ieWXXR+EMGR/n2yEJEcWUWmjUZxQe5B+UY48jFLwspgo
 LFJn+oMkC+KkYoY4G2l2zwEarEzG2w==
X-Proofpoint-ORIG-GUID: 5tjKVZb9s8R3flHqBq9qatLjpL5Yba9z
X-Authority-Analysis: v=2.4 cv=S/LZwJsP c=1 sm=1 tr=0 ts=68b95ecf b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
 a=N54-gffFAAAA:8 a=ylMNmuuF2xg9MjJHVAAA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12069

On 27/08/2025 01:06, Bart Van Assche wrote:
> The SCSI budget mechanism is used to implement the host->cmd_per_lun limit.
> This limit does not apply to reserved commands. Hence, do not allocate a
> budget token for reserved commands.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_lib.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 9c67e04265ce..0112ad3859ff 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
>   	if (starget->can_queue > 0)
>   		atomic_dec(&starget->target_busy);
>   
> -	sbitmap_put(&sdev->budget_map, cmd->budget_token);
> +	if (cmd->budget_token < INT_MAX)
> +		sbitmap_put(&sdev->budget_map, cmd->budget_token);
>   	cmd->budget_token = -1;
>   }
>   
> @@ -1360,6 +1361,14 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
>   {
>   	int token;
>   
> +	/*
> +	 * Do not allocate a budget token for reserved SCSI commands. Budget
> +	 * tokens are used to enforce the cmd_per_lun limit. That limit does not
> +	 * apply to reserved commands.
> +	 */
> +	if (scsi_device_is_pseudo_dev(sdev))
> +		return INT_MAX;

It's not ideal to have this extra check in the fast path always.

My original problem in this area was that we were trying to send 
reserved commands for real sdevs and those sdevs may have run out of 
budget. So I was suggesting to not get budget for reserved commands. But 
would it really be possible to run our of budget for the shost psuedo 
sdev? Can we just set a separate budget there?

BTW, you are only sending reserved commands to shost pseudo sdev in this 
series, right? I mean, I think that you don't send them to real sdevs.

> +
>   	token = sbitmap_get(&sdev->budget_map);
>   	if (token < 0)
>   		return -1;
> @@ -1749,7 +1758,8 @@ static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
>   {
>   	struct scsi_device *sdev = q->queuedata;
>   
> -	sbitmap_put(&sdev->budget_map, budget_token);
> +	if (budget_token < INT_MAX)
> +		sbitmap_put(&sdev->budget_map, budget_token);
>   }
>   
>   /*

