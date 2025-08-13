Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDBD212547
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 09:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755078566; cv=fail; b=oit16zbIOyiD/CMpDzPOeIBBmgbkfAWPfsbClOvJPO47kLOAYxyAEqU7TiqVv1QhQ8jArF992CMnsy9sTZM5IHvQwEUt2bQqsJSn1zwJ2HcrNW1pLiHrq+Q5S2WsxW7KTaVD9CfhCvfi2shVVSY7rjd39yBnHo8+ac7gWQfY09U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755078566; c=relaxed/simple;
	bh=a0ChBbkRptTT2xm/hc+er1to7rsWnxYmw5mWPaymvH0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kZnTGhYZ6YY8WSYXnNT6i/XVVe9HUTiiSBOv0/iSGOm4rh8143563DL9kUnwMp92w2w8OWgm+bpbYm34fIpzQH0L+kbbA07Wyz7ZroXvu357FsSzxsU4tXkKI7+5+kruE0qTexgwu5l6Kt4833GEHzQZr4aV1J3biqbbyy5hysk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KCO48048; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HeAiQZNE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KCO48048";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HeAiQZNE"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57D6u2tx008433;
	Wed, 13 Aug 2025 09:49:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1B7gT5Zh8wPyXmT5PoYgmyhv4WskTFutge+PJChmTMU=; b=
	KCO48048Z1yN81iVm9JIVycdMr/8TcnYWpfYA7QS+6QfwOzAWzJbfEUzYE4mI+xa
	XuR5+QF075E9wftOJdavAbai2sXpzPsuVTutFapXObKgoQlmolhJP8m9If6/P1cv
	UFH96LKASfQw3lqHGR9W8UD+WB9tZe5WbaWk2QXFcAkBCsc598waUuit7ZzlTtVi
	s99BX9Cwn4FGMAKIzPRHsnd6xRfe6Xu3iObTX0OQPQ9MxM16R6IvfXgGENMZycWB
	MwIsdYASwJNXNPUWlwusL+wsuQYQJZsTxTXDfzW1GOzx5uZ54JhoRXU9OOxx8MH4
	3qfEIBDcUGkQc85dAkijjQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw44y2ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 09:49:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57D7nlfE030439;
	Wed, 13 Aug 2025 09:49:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsb64db-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 09:49:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FTTJpuf3/9XBithpEEycPTzpQeQEjg9Sho5tvKyCooFXIXNr8Knh+2cvNbUgZLvZpBqqvbQt4+w9zQvQ/l0o5b8GqJiFx8Tn3F1ylpcz1wHHaXKZP3KtCYeTLO3ajD2hpnQMIglRGM8bu1PfIg4RfrfuWzCwc+6VmOreVe2q3tESN5Q0I03q7IpDE1y6b3Yijhzs/wNvUlivnuwp1Zxa9SIWWnZrrAZyOyYqHGhoF1I8HiK9yeh8bxbIyamd1xvzyKdBYNGnOSW5OW6FljTA3noptE2pjxZgahN9oyr1lyTS7FEf6/ch+Lo93bAuY4X8f9m3weWZ6p+SHJrOzaZUjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1B7gT5Zh8wPyXmT5PoYgmyhv4WskTFutge+PJChmTMU=;
 b=JrHqQ5MFn3rOC4ew7rMNIhiR7ziMRHjRqPzdO87qQ2W1TvApdHN7koTdc6I4QDu78HgnC8yG4c9rvcPbEZr9O+qjEuKIgvryumOt8nidts+IY+MUahWRT0nTa2RZn/+XUe5mmDocPa7PkkCsP63TRuhD9QfNVL/pZ2Vjcmxjeq7GhXrQpUGIG1zfKtR45eo+LMZ3jhARMLaP3b/NaPYDIVM4+PsJ2iTr8gzjYFefUB261Qy1h0bjK//hIS4YPfydG+8wHdZgFONBhoXiGtUkLuLHmvb7nzYw0GKIfy2PSD+eQI1MxMzjcOWQ72i3uzaaHx2hQnj8dFinLWgabVokOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1B7gT5Zh8wPyXmT5PoYgmyhv4WskTFutge+PJChmTMU=;
 b=HeAiQZNEhFSVKo+d1X3ltfU3GsEINVdOSQ/jliahiSvrr5E600U62aDbY/As93w+5NEibuqBP/PZ8GRqDHcnodXBycXGl7j/FkYDFg4B8iEV0WKmmDKDbQKGz94+N2hBnkcKdDpsASiYCmC8/m4GuDf0gOCTg4rPVE9Z5PvWPok=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by DS7PR10MB4861.namprd10.prod.outlook.com (2603:10b6:5:3a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Wed, 13 Aug
 2025 09:49:15 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Wed, 13 Aug 2025
 09:49:14 +0000
Message-ID: <d5cd0109-915f-4fe7-b6c2-34681b4b1763@oracle.com>
Date: Wed, 13 Aug 2025 10:49:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/30] Optimize the hot path in the UFS driver
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250811173634.514041-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0333.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::14) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|DS7PR10MB4861:EE_
X-MS-Office365-Filtering-Correlation-Id: d344cd51-465a-49c1-05e1-08ddda4ea9d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVQyVDJEVFptUGFWalNOeE9WQW00dGIyVlMrVHlkQ0UyeWl1ZlNxZHpXVlZy?=
 =?utf-8?B?NjdQM0JISW1PeS9oY0pybkZ0bVhtK05BOHNsS20rQzdreTgwNGFnelNTU3Jq?=
 =?utf-8?B?MW93TUlhdVpCWXpib2gxdTdIQTM5bHNycW9PZ0s1bEgwVmZGaWVvS3M1dkd4?=
 =?utf-8?B?WXlFVitSbVlFaEZWM1VxWFd1ai9TYlZsT3V4SVNEelFiVWdIcUhRWXp4Sytt?=
 =?utf-8?B?VFh1ZkVxSFVmT1R3cTdwT09CUm80dFZHWnA2TVh5NGQ4ak5aK0UrVzl3QnQz?=
 =?utf-8?B?aGIvZHVwbk9zL1ZpSTZXaUdtaFVmbnY2QXR0Z1FGbGFKNzZCQ3VTRXVqK1ZX?=
 =?utf-8?B?ZWtmT1NwSVdaTXFqYi9KRW04RElvNlFyeS9hbXVIZ2gybjVOQjlRSVR0WG9v?=
 =?utf-8?B?dTFQNGJUaVROOGU3OTlDQUpIcERWQ052Y0VuMnM2aUJMT2RoWHBOcGZySmps?=
 =?utf-8?B?dllIZUJ4bS9JQk0ySDJSQnhDVWFPT01vRngrdHFjYS9wei8vZGtWVGdOWWw4?=
 =?utf-8?B?enIyOHFYckcyWFpGWGx4MmV0N1VqOTdjcDczN0czZXZjcFdmbFhIYUh1cjJU?=
 =?utf-8?B?eTRaaHlOQkpNRFNYYW1yU05RQVZzU1kzdDRtemxITDRCR0FXVGpheXVQdFIw?=
 =?utf-8?B?UVhERDRiem1raE9HeGVJU3BIdWNKaStNOXJXdVZVSTYyVitONU1HdE1BMjFV?=
 =?utf-8?B?Zm9tTERJcVZHTHpxSm9scUc5eXhDMmRXM3NGWFdySUtRWWJhUTMrZjBkNGFl?=
 =?utf-8?B?ODBUb2twUWYzcUhGWUFHUkFxcngrbnJNQUFPREFyRFREcnlpbzlZTW9kUTlk?=
 =?utf-8?B?SW5lUXlzQzFiSWVScXpHU0w3bnNxNUFzbUNXZUFKWkRyTjNLUXphR1Y0ZWpn?=
 =?utf-8?B?RzlnV0NoSzI0M001cW15bkhYNnZ4d1JQQXZWenBNQ0VOT25MWWhrWHFwenhu?=
 =?utf-8?B?VjBkT2lyVDBhS2hiMm1KR3RReEh5ajcvT3BLbVZ4VytVZlZsdDNyYVpnc2J6?=
 =?utf-8?B?aGlTTW5GOEU2Nk9VMXBPdFB2VlYxVjFpQkViTUpGblhNS3RlNHNNNVNuOURJ?=
 =?utf-8?B?c2k0emZpTHRXY3JVdjQ5L2xDRVQ2bDBuVVZOdENhRjdqUExZRTJjQnJGcVBB?=
 =?utf-8?B?SytKcGt5TWR3blRDODdZRTdKSjUxekY2cGJwK0x1R0hKenZuTDNEK1c1cWN1?=
 =?utf-8?B?UDNmeUN4K1FNdVU2clNGeVAxcXZNY1RaQ1pacXVDZWplNTVmVFFJQ0dLalQ2?=
 =?utf-8?B?TStlZkpuMDBKV2Q5NzBBWG83Qi9iRVF4Mno3Ty9CelpKYnlSMUZ6NHQySS80?=
 =?utf-8?B?ZGx0dmVMNU9JeXVOWFMzanYxMzBzRjlNd0tscnZNTTI5SzJJcXhOUHBGeVZS?=
 =?utf-8?B?TVIvL0s4T2ZPVHJSc0VOa1JNTXcvdFRyenZVWWhaUWZMYzgrSXBsODNneWZx?=
 =?utf-8?B?Y1R0UVJrbjl3MGJXZENBNjVXMy93SE0vajZoQXhRa205RkNzVmJOQ1B3R09q?=
 =?utf-8?B?ckxMSTlVV3dwSkU0U0NhT3NNSXpudW44Q0sweFB6Mkc2MS9waTVvM1lOL21n?=
 =?utf-8?B?TDM1dkMrQmZOcFBZSDNuU1dHY0htWURtTnpJUVA5akdLUml4M2hLcWxIVkt2?=
 =?utf-8?B?YURQWHhRMGZhNHNIVXBJTkFsREJhdGFEeHVXeC9sRXBnYkpIYVVJaXBWTEJN?=
 =?utf-8?B?dzA1SGg4Q1p0aVhwemVHYzdwRW1CVlZxaVZrVUxqVFVkL24wNDNVSTJVQWVv?=
 =?utf-8?B?dkdkbGFrMVVPOUZLbjFVbE91VjBwZDVYdUVSSHRFSkkrc2MyNy9wekxycFR4?=
 =?utf-8?B?UXRmaEJMa0lHMU00KzhJT0NQNTVwaGthejd6REh5Nm1lRFZLQVFjM1RxK1FC?=
 =?utf-8?B?SHFmc0ZLcnZ4WnNBYytZUUlCb1RWcXFLUkIvamoyVUNuNEE2ZFhvLytHdklS?=
 =?utf-8?Q?MaF05EMyFhA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bW1mMGRZNGRpU2w1cWkwNXpvSWIyOGpXMTNLSGl2eW5zcEhTb2lJRHdNb3NL?=
 =?utf-8?B?ZzFuRXlsRHVNMjlsVUZiVWkxcEJIbnd6V1I1SUF6U3ZxZCtUMlB1Ri9ENkxF?=
 =?utf-8?B?VDNqR3QrUDNNUnFxejA2TjFWQ1cxT1EwK3ZyNjhpMWxFWUxqd2dwSi9nRFZY?=
 =?utf-8?B?VHdzeVJmVExMdDFiUjhjVS9vUWlFZ20zWFMzSVJocCswY1k1SWE5QnR3SlU3?=
 =?utf-8?B?L1Q3Q1g0NzhNdjByY0FlSFE1YzNuS2YxSDJ2TVNaVjVFYTNOWVpYUFl6b3g5?=
 =?utf-8?B?bldZa2NOdXpIbnNvUXplWitzd0JZelVHUThqcldOM3k4TERMeTBXSGhtVGVo?=
 =?utf-8?B?UGd5aDNBTTJVSXVmR3MreHM4a2lCN0FZRElsejJiRE1kOXJvVWlXS1F6ZTZ3?=
 =?utf-8?B?cVQ0MGw5ZkZzRndRcWRNWDZrNThoa1RHQ2lOY0ZFekhMQ0V3YUhOVExnc1VP?=
 =?utf-8?B?Z0JPSDJaNUZ4RzlJREJWYlp6aDR5UElnNlZlK0FjeldsbWRMeEJ6UnVlUHg3?=
 =?utf-8?B?Rkdvd0phUE5yVkpaTkpRTjNVUkt5TkpEaitaMVloQzM5clJBMkszWUNQb0FR?=
 =?utf-8?B?elA3Z2NuL1NhUTlBcE9EcmMzNklCOGJ0dGJGU0lEbHZSUTVkU25ReVZQTm1h?=
 =?utf-8?B?bmRvekJwL1pMbENMTDZwYW95SE1vRlNHa1dVSHRtays2SnhBQXYvdit1ZTIy?=
 =?utf-8?B?WVdzRE5GS2RFY1F4dWFycSt2ejBTUUVzRFdKQTYxRWZCSGtsQkZNdXFrdWpL?=
 =?utf-8?B?L1dqdzdQb2M2RkxuUTRlbFBLc0xwWmt4Q3lTV1pyMW5WM3BmQWw3bVdkNDdO?=
 =?utf-8?B?aVQ5OE9KTGEzc1pMcnNzVUgwWnI3ZnhQd1hUMDUrRFRxMlRDa2tXbmNwaGFE?=
 =?utf-8?B?Tzlyb1RJVUdoOVBUYlJxbGcwbTRDcjBQbnN5ZjFoSmdBV3NrZHNpdkxNbk5n?=
 =?utf-8?B?OS9pNWRZMGRmOEo1S09NaHhIc3ZhdCs4ZnZUWldyZnBkMExPSHdDbXd5VVBu?=
 =?utf-8?B?bXplM0x1RU5sZHd0MFNQaDd3bUFKN2dHYnNPQ1A0OFVxT3FjWlBYaGpRaHlQ?=
 =?utf-8?B?Mi9qY2cyY2Z3Z0JJK3JuL3h2S2NZRFhUYXpQMi9pMG5INytnU2ZwUktxUkla?=
 =?utf-8?B?YjhDR0RiSkw1Y0hiQWR3V3BQS3F1ZWExU3ZTSHEwRmpkYjJPRG8xbXNBa1l0?=
 =?utf-8?B?cHY5T3ZzMHkxMkRWdkM2dUo5VThZNHFHdXViVkk0L0ZPdWthcUp6bXluL3Vn?=
 =?utf-8?B?VEF0OXhYN2V1ckJRTWE4eitPaGM3YXVVSGtkQldBajlWVUh5YjA4NXRVcHFC?=
 =?utf-8?B?SG1PSk9Rd0t4MGIzbUlvU0ViTEhpRzdJcGJJTVU1WTlnS21Vbm9sK2ZyV3lv?=
 =?utf-8?B?Q2s2ZURFWFQvcGRZcmlrbVA0MGpjUExJY3FlTjVrUS84Q1l5Q3FUUkFDOHJ2?=
 =?utf-8?B?YXl5ZVQxdEwrTlVCaytzZWlUQkFjYUNyRTZZditIWE1xTGJIWSsvV0FpbUdn?=
 =?utf-8?B?T2phaWNuSFVXU29SdWdBV3YybDNicllJSlpKclBwUWVaOUZPSGRBOXNkczVG?=
 =?utf-8?B?NEVBdHVIRTJ2VGlVcHQ1eGhCcTNjNmFwUXptVG5LclJpMVMxUzJHdHdaQVg3?=
 =?utf-8?B?M1lhRCs2ME55Y2FWZzNyWlB6M2F6WldSWTNVUVpVRkJuckIvT1k4SVlBRDBm?=
 =?utf-8?B?d2NGVkRHMmw1T1h6OC9xWGhRbUs0dHhYVkdDdXJJdThIU1QzVDg3OTdGV01T?=
 =?utf-8?B?MmVBSlNyTURrL1FUdWNRYmNiMEpUZWVwdCtQOW5MbC9RRWwzb3kyWmxjK21E?=
 =?utf-8?B?Z0dHbFprMnpYSURxREZUdExIc21STE9GdkdDaTQ2YitWSm5BaEJ4Zmw0OTRl?=
 =?utf-8?B?ZEhNUVRoempLVGFXV2pMcVRsTmRzbzZ1L0J4WVJaZkxSUGwxZkNBV3VPaXh2?=
 =?utf-8?B?cHU1N2Q4YnNERmtYUFJLWVJ6TzRLWVhETitCK2ovTTFhNFlzb1pQbDRUcEF6?=
 =?utf-8?B?VFJxOWFhK3hpUXNDK3FEd1paMnF4RVhnNHRleTdjOTNZSDFhaUZHVWNtWmhM?=
 =?utf-8?B?T0ZpYVVabGsrNGtPdDdpbUdtSUlaVzdYeFRoNUVhSE1VUFkwU09uWXlxdFBT?=
 =?utf-8?B?ak95eHJyZ2tHSStsR3JYclplVTdCNWpkZ2xTWm1kUmczVkhsMjlKNU8zNjU1?=
 =?utf-8?B?THc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	F0e2nsZPXPkjh09fKweENMRknIj7Yjh6SGVRJ9u6PJ/1T4kcw7VG5J2jAk6Mtn5TD+8SEXW4jdlP4fyn1t6+PH7LNNjTZg7Elm52SUt1oLysLnpTUyOAZn9wdNg1NED7pu/KTXOKytmr0QB246+mQil/U5V9wJ8lUApWt8BxraZSkXE9cuBscYbWknFEdgUVndWf4QKGweSEC+YAUz7Z3WKLvWJvLjBfoQ2wGDav/YIz1aQBxAC40z16A45b9NMllaJboK3jmFcdzFXMaP4DpNwpEfoBzQkp+hjtPvson9vxtBHlqAoUI3M1ntpBgw0XFLnyyrnd/+WBkAhTMDYyOMYPURgbWgHULP9isUoygBnqNd4vDM6Ba5j47KQ5yY9LIHm8FoWoMtV+RJeV1BTVPjkbZm8ASfhs08VOMPbnuEjuGxXdQryU1q1Q6a7INH3e0VmVYl47ZVBCT2YJq74EVe0zVnSGhKE/3BZuAedLAZ0PwoioeyN+qD5bSmil4OjNMCay9RWdvKDBvproeRLbWw2dsZZH5EQIen+Y38YP8/BZGZaJFhHwaoY4jVKhvslCKd4ZzAgxEIK08elCtNr0MEqirEXNgnFubKu7Hka00Ps=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d344cd51-465a-49c1-05e1-08ddda4ea9d5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 09:49:14.9387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zRsFr0gLl19XW8Ogby9V+SQihRt3DBSxwvG0bbtEO5Ohy+EH9bHugcotbVsoUGQyskIRRHIUdVnNU4iX3Q+QFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4861
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=982
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508130095
X-Proofpoint-ORIG-GUID: bO2Op9gLplP2na_QGeELdzsb1hPSDxBW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDA5NSBTYWx0ZWRfX66ySd+HQ+60Z
 q4QCES8H3B/pbV2e36yvIGA+XcZlB+8p3DfRNu1oScQq9rwJI/kqGOErNfOmK+/yrQ5n/q7Fybp
 UGPC3tNtqUzisjuBRRDetTlfKHdonKYnU33ItrLs1IL/Y0oxbyznsjbI7NxlMc3i4xk1uEfTeH1
 nGMaPR1ICu2Al6goty86MdrNCC3K80hxTeYonNpH97YDdSOmlCFiuEIlZ1oaRpubXYyclGFQpYO
 ktC+WrxMoFMbTIRfp/ajyoK5NkQ2m5lqs4yQ/SvhOjqDRWuVTMwuaS5IGzlbiOFRDFJTg041uUb
 HORMS0p1E76lM3bI8U/By5GmgnsXxVYb2IG1VTrfC/ktkrMMtTv4YwGXQR5uKynnSfS3GrZ8UVK
 ktxH7nmNuJ3PYZXiNTu5OdWVW7ZUmQPPwPEKrBaoJFV40L8mcFZEtIuQYr2tcBUY+CwBUkZR
X-Authority-Analysis: v=2.4 cv=X9FSKHTe c=1 sm=1 tr=0 ts=689c5f9e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=4lsTPh7iMNHSYlcLV-MA:9
 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
X-Proofpoint-GUID: bO2Op9gLplP2na_QGeELdzsb1hPSDxBW

On 11/08/2025 18:34, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series optimizes the hot path of the UFS driver by making
> struct scsi_cmnd and struct ufshcd_lrb adjacent. Making these two data
> structures adjacent is realized as follows:

what is the baseline for this series? It does not apply to v6.17-rc1 or 
mkp-scsi 6.18 queue. Sometimes it's better to apply the changes when 
checking them.

> 
> @@ -9040,6 +9046,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
>       .name            = UFSHCD,
>       .proc_name        = UFSHCD,
>       .map_queues        = ufshcd_map_queues,
> +    .cmd_size        = sizeof(struct ufshcd_lrb),
>       .init_cmd_priv        = ufshcd_init_cmd_priv,
>       .queuecommand        = ufshcd_queuecommand,
>       .mq_poll        = ufshcd_poll,
> 
> The following changes had to be made prior to making these two data
> structures adjacent:
> * Add support for driver-internal and reserved commands in the SCSI core.

