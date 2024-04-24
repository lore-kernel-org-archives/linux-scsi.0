Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361DE13D530
	for <linux-scsi@vger.kernel.org>; Wed, 24 Apr 2024 10:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713955592; cv=fail; b=dlcAu1b/TZwOjBot6ZbLwbMJ1OwXo33+OCTihw4p2LyLfO2VU1Oh3rRLl6suKg56cIzJRgYcWk5u0ZIK9VoH/DZoXUK5aXO0Qj9qOLbagoWxWBbxk+0mLs8WqrkPVnCqkYsxr2NxrQgFX4Vbd2V1Fr7CPskC8hH8whZjt9FcyGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713955592; c=relaxed/simple;
	bh=gFymkG9cIyidTrSZSOjNf6Ak2OoqOlai5lZYZt20FGI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TAEMCjBteacQtrSGemkPcDaFHHMrDZHQf8CxHvBUhHxB1DhYkakwBhOyDF48FhOQ0fTFxv4L1OC55Mfy5pqLgHlGj/pu8xx5byzKkyihdQ71rT76jlt+9DxRDicoazIrPccPSXQCTSFqdNFSviXnoxtUOUYqyqfXV1KLRvxwcqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fO0G89bu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Kfha9TV+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fO0G89bu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Kfha9TV+"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OACjCv019758;
	Wed, 24 Apr 2024 10:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=iaR4k/Q4K6+5X/Ajh8MqFkBaplHETcm6p4JsU87FvEs=;
 b=fO0G89buHf82+9Tbm2eiRc/coxAN4lx4OuTr9WquaSzp0yXboB5Ov0WM/2lzJVr5GYuN
 Zy2RyMGMFKPzHYUCUhiJYU5b9PCoeWAGaY8ZWDkDzIB/eQUX8tEMEG7sCyNH5oAkLnIy
 QOQ+wIT6lZoSt2ZDlWswMkoxIu9YvsdaYyATYISJYAhos5uxI+6/PZF47PBqRz2bGFdC
 EOJGpt4LwEv71oukp6Sr9fr6ur/VX9WjO4KMk0pQVTD/rLqFbG/umdyze3BM2hHCunzc
 BG7pD2pHNS7IeD5KyjpadniFdWpV32cWxfblzAmsUg1G8ES6qWxzMyIVnGm3q/tpHQv7 kw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xm4md8dfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:46:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43OA5jdQ025260;
	Wed, 24 Apr 2024 10:46:22 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xm45ewcq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:46:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEJkav24B6KJnKiY9ei3VM7Q5VTkhvMgSoQ72EaKH0yHoz84J+rh6FAJUf/Oe7Mc8786LAci03rTOuHxcDrh2XyHM/L2B8IhTrv96n0RC8O7Y9RZpL1mdro0ihpWGPvmcJSfvWIXhMeir4fr4SP5Q2v8VnNWTf4qv9ZQCbnBlL847FV2DWkTXa5DgyPMpy2qQ/lY2vCmBBkkl2zlLkGOf6WYZX30WAXLPdCLpXkDPNCzvZZZu0EUQ4JJ0+Zbugn41haWqnwXlTWsFSmQxutt+uB8KaaGZlv6PwYA0Ym+pt3h8hTkeO5AtdDnhh6hOjOah+aZ4VmKVX6PER6osQcUWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaR4k/Q4K6+5X/Ajh8MqFkBaplHETcm6p4JsU87FvEs=;
 b=H7gikFY9r9hGkilRfY6ZYnWj2lEgt+2vUwDr2BGR3iYKp02/AOri0OWd02QHxo9EOMrSfJ1kByGEsoRs99GGZyCHE6a0cnEvybgZDB1z1M8Ge97Pr+Gqfe0CFabywHNa5EFWNOyWt6CzYJnIFGkdNu/Y8GThQXMLxoaPUKlFDPkCFmHQLgB0TwZ9CVhYkRCTzLKqOi/U0z5s9FDfM0nIyuUVK6xiqsl/stO1vtNh1S9zQAruW6hdN2XCnm1z2k9YHepX1AAyI9w/C+ekBp6hFQQEdk19/AAsWmGgfqVAyc173j3u8ETowsPJNCij/jspWkB5ZQHjbkaEd+yOTcLLxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaR4k/Q4K6+5X/Ajh8MqFkBaplHETcm6p4JsU87FvEs=;
 b=Kfha9TV+umXFZ9ypFgBEb0yn/S/XpPMZtFpl2zxVHqSNZkJfWwL+lpAHPVLaaF/59FVkvypu/xRlF12xh/a7ZnlqqNdLlaqlnptURWz/UaRnStrzoNyEXCS97O6zw8Ku+wgBTgBpsf1/7rEykiMAbLKEep9dwzjsLCEJKEA1vCs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY5PR10MB6216.namprd10.prod.outlook.com (2603:10b6:930:43::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Wed, 24 Apr
 2024 10:46:20 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 10:46:20 +0000
Message-ID: <09dd80bb-09f9-481f-a7a7-b9227b6f928f@oracle.com>
Date: Wed, 24 Apr 2024 11:46:16 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
To: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>,
        "james.bottomley@hansenpartnership.com"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        yanaijie@huawei.com
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO3P123CA0021.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY5PR10MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: 88105195-fd69-40a8-14b0-08dc644bc6ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?d3ZOZjVFWFViNWhSckhEcXZaNzZ6UUtKZUg5bGMvVGw3WjVzNTdQS3RBalpn?=
 =?utf-8?B?TS9kazhlTFRlTGhqWEdJN2s2Rlh4aDE5L3NRNldiemtld3g4aWxxenFpRHJ5?=
 =?utf-8?B?UGZtdEtUekY3c3NiZUNwL2hwbk9GQnNsSE0vb3RoWjNLNzgvU2V3N3drNWlh?=
 =?utf-8?B?QTZUOEFyb205ZWhTK1NSMkNvWHZtZ09kTmlNbjFpL1lMbFU5aXR1WGhNcjMr?=
 =?utf-8?B?aXRuQ3pUUFh3TFNrNWFUQytoaXQ2WGF2V2w3aDYrNW9pUVVRQUFvSDh0SmV6?=
 =?utf-8?B?QnBXdjBKQ0xTNFB1NEk5bThIaEtqMklCVk5SR09tSzNaTjNUbjRXaHM4NkNk?=
 =?utf-8?B?bFpnMjcyMHlrUUtIQ09qNmFHZEU3SGtWSWVMMFU0eVVVMWFxUFNEZTBsTFZ6?=
 =?utf-8?B?QlkrVmZaU0lNZkxiRWI3QUFxVGl5bnZNc2UxQS92YkxNMWcveDB3Y0VodXBD?=
 =?utf-8?B?QklnamV6aEovQVYyUVJmWUdYK1I0ZXhTaXcyZzNtd25YM2JYa0J5blgxdzEy?=
 =?utf-8?B?OGtLeEh4blkrdE05cTVRcjBFNzRTK2psTExwL2lVK1RtODhGSHNHR1RyNnVD?=
 =?utf-8?B?elo3cVVrcHh2OHNlL3FRYmtSakE3NzZPMmdkNndBQ2JzL0VQM3Z1QjhKOVBM?=
 =?utf-8?B?ai8waEFxcEM1eXcydlY4MlNrQzcvN1d3K0Zkb1hkTk92SHg5VXhuMHpEQ2wy?=
 =?utf-8?B?aWlYRU5VWGZYUTZCdVd5b3BKQUxWeHdlWWlFUXhpQkMrMmkxYVdDTjYwN3pr?=
 =?utf-8?B?cFd1Y25RYzM0UjMzWm5hUHlGcXhIeDVGTkhmdzdUVXpRTVJRWXR6WUdFZFln?=
 =?utf-8?B?bE1uYlJScS9scitVYTVwcWpERXdXdFFWNVlhby9ObWdiOERER1laS0lwcFMr?=
 =?utf-8?B?QzJUMzFjS0JhQXhFSlFCMDIwMmdWQjI0UTlWaFJFRENRS0RCOGI2YzZnU0tK?=
 =?utf-8?B?MWJjVGo5bnlYbTFuWjNqSmc1cGt2NnM0ZStSK1A1L0xmT0tuSzJGZ0I5c3Zl?=
 =?utf-8?B?andJQ3BNWDNIM2F0aUpFbFA1ZEtmVmVqTENkNnFkZVZEUkQrdEVsODFteVh0?=
 =?utf-8?B?d2dSUklGbHA4TklEM3RyMnhEUjFZbW5SQ29MZms4c1Fnam5KSEF6ZmkzeHZP?=
 =?utf-8?B?ODR3MDZHUW9ISGNjQWdRR3NXdVhBK2JIK2EvS2dwTE8yMFJxNXBmSnViV29j?=
 =?utf-8?B?TW5vbXdQdUNzZTZ4REJqWDRuOXR4WkZ0RHcrOFhTcklSRGtFaWVBUllzN1A1?=
 =?utf-8?B?aEM3VTBpMTNHNUFibDhnZm1uWmFMUVR3Vk1ja2FHeWlCNXkyMDlocEM2a29F?=
 =?utf-8?B?dEp0eWJrMlZ5YUl4YkNjczdQaThaM21SVFZrUDhjaDh1N0Z0d1hYdWphTno2?=
 =?utf-8?B?Tm54K0J3TWNGbk1mcXJHZFhqUFdaVG9Bb3gzNnRkZjdHQkI2elNnMWRZVEk2?=
 =?utf-8?B?TEhpZm1ycWtZRUk1ZGZWek9YSVZ0T2xWN0NVSDFZZUNycFEyQTFWL1JERWdj?=
 =?utf-8?B?RzlvVDNhcEo1TENTUEJkR2FnSnBtaXJWZUJZaDFrSUFkSjcyem5yNDhpaEh5?=
 =?utf-8?B?dHhZRkhjRlBGaS9tSHhsNEl5d2ExNmZGbFphajQ3OU1lQ2NHVGpXaXVpK05t?=
 =?utf-8?B?OU9ZMG13UWp1YzhLcDh5Nm1mYVc5eHk4cThkMkF1NU8xT3UwMDRxdjFCV0ox?=
 =?utf-8?B?SU1YeWxWRDEzbmZBbG9BUUJZc0g5Y2ZTVTR2T1VURDRqekhzMXVMWlFBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OURjWHpQdEhDS1N6QnVmWERlT3pMYlk5K2dQQk1JUXYxRGc5Y1p1bjN0NUVI?=
 =?utf-8?B?bThWVEVNWmc3V3dDd3g3Kytua0dUaVJKeDQ3VTZsbnlybmVkbjlZMkltZXhq?=
 =?utf-8?B?T3JBcGk5RzkxQWhPeEtlNVJkYlRKS3orZW4zSlQ3SHlNRTY4WnN3MnFQM1JZ?=
 =?utf-8?B?YVY3WTJFbGtrdW42cnkwVjdyNDlyU0hreWlkbXpvQU9pNWIvM2tYRytoY1pv?=
 =?utf-8?B?a2RHeURTOGxoc1N0ekFyNHlXRmdTczVDb3RnSUR5ak5wbjhuNVdWNFc1NGw2?=
 =?utf-8?B?STAwN3lZTmdBOTBlSExRMEZLenNsdkIyVGl6STdFZHFEMXpyUHFsbkx4TzNx?=
 =?utf-8?B?akNnT1JzKzh2ak9CeEdiTVhMVFpNUTRTOS9MQ1FpRU1QaFg5djZsRzZNT0N5?=
 =?utf-8?B?Q1E2ajdadDhrYk1pMUZST0xWaWFhOUJmWHZUQk81MEFPUE5ZS094L3BKZE53?=
 =?utf-8?B?YnU2VnFUTFAxWnVhTGdJUzVGUWpTb09TVjFzMFlJczJWVksranZuRXpYdHNE?=
 =?utf-8?B?OGhNeDBUZ05QL3VEQ2JmRXpGNDNubTV3TzZGM2JVYzVKWDhJS1FVVFZ0bFpN?=
 =?utf-8?B?TEJGcTFGeEl6TlcvMU14bmlHVmF6eWY2cEpuUFlmdkZFSDZrZVY4RGtWaGRh?=
 =?utf-8?B?VWtNbTE0a09sQ0E2L2p0SXFaYWt4RlFXY1JRZEg3ZmFzT2xFdVVLZG9NbFdH?=
 =?utf-8?B?dFUzZE8zMWlUQTlML3hVQ3ZVVGYrYTJhYk85aTd1REY0dnk3SjRvUmRxSUVH?=
 =?utf-8?B?YWxSL205dFhCNG1wN2RYdVJkWm9KWU9NdWl4SkF6eExlRitIa2RhaDFEQ3pl?=
 =?utf-8?B?eW5XTFpVQ3ZySUFkaHFEQWhieW0wNEVYMFBHcXRCVGdlV3JiUVFDQlhLZW8r?=
 =?utf-8?B?YitoclpFSGs0R0tYMkVzdElHL3luYlc0c1hveXJzcUlhbXAvcEhYNHJNakxh?=
 =?utf-8?B?QlNWb2ZjRXFnRXhDUUtuK21NN0l4NVRMK2g0dzE1UTNqY01oZWJFRUhBaXZl?=
 =?utf-8?B?dkpKRWJYTXFrOU5RWHVCYnRxamRvejUrdnpMUkdnTGNIcVo2SDBuNFhYUHNw?=
 =?utf-8?B?TEczcGZaQjE2cSs3SHVzYmozZVY4Y2ZVNlRmQm5PdCtkYkJwL1RvMjJsYkJ6?=
 =?utf-8?B?dDdaODdQUGFTMUhKY3VZRm0wYTJKY0huTHc5MTRiTVhQei9FTnJPUGlMODJs?=
 =?utf-8?B?ckJMNFl5dkJWVUJLUnhZZ0k3V29hOUZuRkJnaTJNOGw5dDI1RFVhQ1p1djF4?=
 =?utf-8?B?a0JZRENSNnJWWmZpMERvQ0R5KzdpYzhoWkpkak9HV3loVzIvRkVDRXMyaFV0?=
 =?utf-8?B?UWVCKzdUZEIvdE4rUFYwNFZNSjBGRFRRVEZKYnJpemVSWWc5Rk1STTJNN2hD?=
 =?utf-8?B?aUZYTkUvQWd1VFV2NXkva0lMWHNWN21KWDczTGJvb0szRlZzMHlRVjVxYWFu?=
 =?utf-8?B?aFpQY0xVZnZCekxtUHlLQzQwRURRNCtUTzlpclZ1bjNKdzd1K2I2cWNqVFhy?=
 =?utf-8?B?ZUoyL0hxbHhEMTlMRW9HTHlUZGpwNXNMS2g4Z28wNWg2aWpSY29IbEsxZUZI?=
 =?utf-8?B?bDEyelNESWJXZy8veThjaERHS0JEeWVkNW9SazR0SFpvL25Vdm5jY1BNMW80?=
 =?utf-8?B?M1RQNFlQUU5ZelZNTkdQQ3dUK1JCWElVY1dFRjNXK3dEZlNBRm0zOWFIeDFo?=
 =?utf-8?B?eThaOEJCb1l1Qnk5WHNDbEdwMnhRaFFXQWs4djVRaWVDVG8rT0EvSjdyMDQ1?=
 =?utf-8?B?aXJILzFYK1M0WW84SEFmeDNzUjQ4K3RZcWxWbXhMcnhKMlIrQXhyUHNqdWhP?=
 =?utf-8?B?VFJYc0NYc0Y0TVZxM3JpVWRpZHBNa1hKcmRSZTNSVWxDNTV3NGVDalMzcTc2?=
 =?utf-8?B?R01uYzRFVkFmKzV1emxBL1lUclowV2ZSNitaMHBDQW5lYjdtTTMyWkdiOFFE?=
 =?utf-8?B?Q0JDcGdhbE1pZUhWREhDKzhyNWdnVlNRdGFEUmtXN1BPcTFnMlhNWmZqMlBN?=
 =?utf-8?B?eXJqUUxsT1BDS2QrS3I1d2JSZjRMY0xaeDRWZ2JOV0k3Y2lQdnoyRk9kL3Yx?=
 =?utf-8?B?MVptUXAzbkM1V29TNHBVc2ZDM0d1V2gxQ1BaSHA4MmtYbTg1aG9ISkNyZUtP?=
 =?utf-8?Q?heq5dXZNVtZ2noYQCilM+YBqQ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	CCHsbxXoYqcEMzqWVQBRLVJnJLi3uLUxqqtAD2iiaFZgYPNleEvkoyLs33HsK1kqlMCEw7o66CV/JIzi8DDb3jtPE2lBxdQ+YlEJx9H7jv6x/IPQkORmDJsI/a+zX1G95SxPiSE+u1q0wWtCzoOZtES9tsNtP7xpbVbNct2/tHrlihkGd94c+NaG+TMqV0lYR2zc4QDZMELbprbpFGifxLk3KQp8oNoHoTd3pXw5eWh2Wtd3MPSHX9uDuk3pXpbz2jGcp15J+9+3c5a/RmM2vRnU2XhULuNvpXJHN2/wWzYu31aUKepL1oVOmNsYsrOK9KR4cH5NvBnODfqS4/oJ72PnO+x6CM3AyX4DOK5ps4iYVs4VKvLG+KbrUwA8RG9EEBPznhwwcXTckarty4pPcLnWCxda1qFmH+CCcWt8DQ37jLMTZl2FpktZMcB/mUI9lbS0ocdSYjJatWr3ljmWsgnGv3M0ZJ0ko2Td5WKNLW7CC1h7XB3D/VFKkA7rJCuFWWkv1hiLvDHmfkUg1HCKu8pf6ThBhNeAZcCk5DUKHnSzP7vH5OyPEHtM2Dgp0r4Y3xNvG8HMzMliEke1KJ+CSOYnwaVyCHu9uCh5iOqbey8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88105195-fd69-40a8-14b0-08dc644bc6ae
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 10:46:20.1947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hv5GmS3HIWM5dPcG6Oi3iF92VvmzhieS7fIKQODJUqcR/Hg/dg3FCmlc7+MPjVMAaj8s/iv7Sfw2RQsEbBldKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6216
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_08,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404240044
X-Proofpoint-ORIG-GUID: VQ0sbdFq1BWr0-_biPJvMW2VXyTqWLja
X-Proofpoint-GUID: VQ0sbdFq1BWr0-_biPJvMW2VXyTqWLja

On 24/04/2024 09:59, Li, Eric (Honggang) wrote:
> Hi,
> 
> There is an issue in the function sas_ex_discover_dev() when I have multiple SAS expanders chained under one SAS port on SAS controller.

I think typically we can't and so don't test such a setup.

> 
> In this function, we first check whether the PHY’s attached_sas_address is already present in the SAS domain, and then check if this PHY belongs to an existing port on this SAS expander.
> I think this has an issue if this SAS expander use a wide port connecting a downstream SAS expander.
> This is because if the PHY belongs to an existing port on this SAS expander, the attached SAS address of this port must already be present in the domain and it results in disabling that port.
> I don’t think that is what we expect.
> 
> In old release (4.x), at the end of this function, it would make addition sas_ex_join_wide_port() call for any possibly PHYs that could be added into the SAS port.
> This will make subsequent PHYs (other than the first PHY of that port) being marked to DISCOVERED so that this function would not be invoked on those subsequent PHYs (in that port).
> But potential question here is we didn’t configure the per-PHY routing table for those PHYs.
> As I don’t have such SAS expander on hand, I am not sure what’s impact (maybe just performance/bandwidth impact).
> But at least, it didn’t impact the functionality of that port.
> 
> But in v5.3 or later release, that part of code was removed (in the commit a1b6fb947f923).

Jason, can you please check this?

Thanks!

> And this caused this problem occurred (downstream port of that SAS expander was disabled and all downstream SAS devices were removed from the domain).
> 
> Regards.
> Eric Li
> 
> SPE, DellEMC
> 3/F KIC 1, 252# Songhu Road, YangPu District, SHANGHAI
> +86-21-6036-4384
> 
> 
> Internal Use - Confidential

