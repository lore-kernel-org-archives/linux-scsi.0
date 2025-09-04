Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCD12571AA
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 09:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756978527; cv=fail; b=rz4DyrrCPRnjZhVUvD/P0maFuXbdu13hyFPdMbj1ccUUXvLmO0ZN7cT/esZ3De3JFXTpyBF0wB2eMRQG2FntpPt5Wqr2yLeWUxCYPCtiZlDJJ8Xk3PBMe8vPQohB5S9OJDz1hb8Fi/2qtLNf3v8RSKgYvwCD1f6JL0DN4uEkoOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756978527; c=relaxed/simple;
	bh=frmadjQF/5MwgNhwuX+oGoX1t2AGk/xaQsRpyO9meZ8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=InaXErvZZGlNo8ks87ISE+XPq5xpgG9JR71s/D214/1eyuI/li1dXKDIJUT02wkzOWMrqWoDrSUXYxOcH6wmwmcoP32ZenpG5QEM8rVY1wihULD07TXZo825yrw8jbKwc1Kz5hZVCFCUmeymBO/UFfQaQOlmP2CJdhyguO7yDKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XPXvPa9D; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FEhi7dEv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XPXvPa9D";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FEhi7dEv"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5849Tw4X009078;
	Thu, 4 Sep 2025 09:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=j/8V3hOP3fOWT++wbpgLeujp7kay3vjZ3N6GxxM9vWA=; b=
	XPXvPa9DkULSnNBBqAXY8flaUfQ2QBB4lfJnBa85UF3PcmvSuSi3JANHBPwqaYqf
	wPjWpQXg6z4E565GaDN5OvTAJQ9JZ3ozZSm6Z5pP0wC8oVGxzfp0Yxl9Fn4vAT06
	P4/cVQ3ZWqk5x5zHoX7o4nb63VRGSensVvso5ygSdBDuQruGY1Phx4swL9PQMLOu
	i20rdbNkQ+hW495STiGmscin0+Vs/9vjRlBYXJJsWcxMPaotA7QM1u1KtZD0ZtS6
	GFL6swe+rSp3cxJUGpTPHajCwJNWKYwAv6Bs6JhV0EDeX1sIIuO7ys+cNu8YL3tW
	tFT9mOkCEpmQOMgPPWPcpQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48y86br0gn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 09:35:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5848X5Px031136;
	Thu, 4 Sep 2025 09:30:17 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbf1xv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 09:30:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aDvfOdES2yKRSCImL/NmZK2APtMIq1SJztLhjA/Cd2/CP8RsTnR4Xy93GPyqixIJr2ZzotAdSjwicHbYg5LDIOGWJfldCa7pAL9lwPDvpWwRpIakln68JHVM/m67RMbuOGR+n7RyzQTUT/tbLJfw+C8eoCrxT4ZL7mx2hHMWxIrbruTEbvTgcVdcSMBzus3SGhUlWkgLQJHNfS17TlOjr5HDTbZyqC+lDzCYYjVYI1vSSRcXPPbVzeETzhA3z68+kmF030LCfNShK+olovc03LSdntLXz7JhiPuQ3e1B4J8LVmgc+N5ZRwKN/82RIdwwcRog/C2KcaRpEncGdTAzOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j/8V3hOP3fOWT++wbpgLeujp7kay3vjZ3N6GxxM9vWA=;
 b=viUB2u6Trw7pClE1PXYm6CmrH1QAYh99JigqLQCV27+IUHeKpJ6eiXAyZS6aocmLw0JMSTMB8eOpWsO89MRRBU+QSzMAMbQ+91wBvOmZq/Q6KacpS+Nk24V6E/gtVtZdTqwZlAgkGDsxdKElhk+PGlR6/X8nGfBMMFx1LgR7CJeNbMJBMfDc2p7upm4pXTrG2EfXPV5Hse2ZU62iLtApc6v6AH0uT6DgX20bseLDgIEkrf0fzQsZZa/4zS0Z0tUPqXv9827lksWjB07yF998tvhNjQX0NWmFlKzzcwWaCJodxXjYKUFbCy5JWQPDxTSnPXbwvG5JxwPu6sdBqFiumw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/8V3hOP3fOWT++wbpgLeujp7kay3vjZ3N6GxxM9vWA=;
 b=FEhi7dEvZvo/GtITHujYIUoXZBPjv0NU/dDNITH97drSwn63XUsy5UFODuzRDZ8LZRV2iZ+gGkHGloLUH2YbC1vIvC0YSjpil8WNql188CBHdPI//Y1S5tISZfa95b9KjXik8th+8WYlnRYyFsxF4f7cGj8U/Z67BGCORlZ5QAg=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH8PR10MB6455.namprd10.prod.outlook.com (2603:10b6:510:22d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Thu, 4 Sep
 2025 09:29:43 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 09:29:38 +0000
Message-ID: <5070296c-5fd2-4698-88f2-0870caab051f@oracle.com>
Date: Thu, 4 Sep 2025 10:29:35 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/26] scsi: core: Support allocating a pseudo SCSI
 device
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-3-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250827000816.2370150-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0239.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::10) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH8PR10MB6455:EE_
X-MS-Office365-Filtering-Correlation-Id: 361a4de1-ea4c-4cc9-26e7-08ddeb95919e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q29xWkIyK3VqSGdWUVRacTI0U2NrbDJWRHVKenBna0cyT3EvTHdSS0MyN3RL?=
 =?utf-8?B?dXlTZ1NLT0hWaytmOFZFSlhnR1FmNUNYMGZMRytTSjlKbXhmQ3dqMFhEMVY4?=
 =?utf-8?B?Ri9BallMMGMybUJsOTdRelpEWGtXV0RkaXV5MVo1Ym9sWHcyMHMrV3lJVW1m?=
 =?utf-8?B?bW51Z2IzcXlGNUZtaXlhd2ZHT1JueG1PdmJhREdJeXhGUXovc2NBcnRCT3RF?=
 =?utf-8?B?OWcwWjlvanE0aWdIaVdJYnVVcFkxVXVObXdta1VJcUVoc2p6WGsvbEc2K21u?=
 =?utf-8?B?ZnVNWUdmRGdycUVsN1MxNGYzZkhabXhLNTRLbkNPcmRORkRsd1Y4OEFIcEFp?=
 =?utf-8?B?U2h5V3FqSStsRWM2aW91L3VwVlYyMTBQUklPbWJYQUt2U29KOG9PZjhZYWJF?=
 =?utf-8?B?eVFqQUZQTWs1bHh4VkhnZlI5aEFTcjNkRTk4eGpJVG9FKzY5UkNTTllrQ3hS?=
 =?utf-8?B?YUg1L1JKNU1vb0VodHIxVHJUKzNvbm5XYW0xZ2J1a0EzVjhGSUFuZ2REMFJE?=
 =?utf-8?B?Z0pWREpEZ1NxbzQ5Y09CSjgwUjRMSlZQN25EQnV2dGhvTEMyeTl2YzF5NU9N?=
 =?utf-8?B?MzRNVkkyVXNxakI0WkZob08xaXJzdXViSlMzQk1qZ3V1OXVWaHdQbXYrczdO?=
 =?utf-8?B?a2R3MDIvdTJxSVh0MGZFdzFNa3hTQUszU1BtNlVFK0M1aWUrVDY0emJoQk1T?=
 =?utf-8?B?UmFlS2xtL2RVeVUzQW8xSDgwNHlmaWpWWWlkYnIwaVhCK0tDUnFzaGJpNkph?=
 =?utf-8?B?NEpjZ2VnZE1PdW5xaVp1cGY0ZGZQWVpIYmdvYlREalJCTWNQRVZZRFlVekFt?=
 =?utf-8?B?Q0ROUDNKeVVWSFBEWmxFZjl2Skk4YytxMjJGOHJZTUxqWXVkWmdMSURMRmhh?=
 =?utf-8?B?Zmw2TFk2OEl1TlpEdFlRNWpwV0hQN1VsSGUyTTk5bFJYMmdBWTZueGxpZVYx?=
 =?utf-8?B?Um91SDhFTnFLOWsxYWpKSkJBaG5COXlFYlVxeXloMVZpdmc4eXpqWFFwa0RV?=
 =?utf-8?B?ZEFsVjdXeDRDcmxpYklPdE5NV3lXUW0rNStPMzZxenJwNiswVEVtVXJLaUxq?=
 =?utf-8?B?WnVhb0RXbVJReUZ6WmVJL21obUJRN0d3WnFUS3JHQ1J2U1R0dlJpRlJBMlhz?=
 =?utf-8?B?U1ZDRy9jU2RETXdaeG4xUVEyR3RaWUNqcXc0N2I5VDJ4RStKdWgwaUFxVXZt?=
 =?utf-8?B?dEtBcCtXQXhRckVRQ2tOblBKcTRnOTY1S3lsWnRxNjl6NTgrOHpOZnhZbklx?=
 =?utf-8?B?ckhmQlBpTjFndm03YW9pdnJDMkg0OXp1ZDlIZkR5eFd4UU9IcjRPc0w2a1JB?=
 =?utf-8?B?bkQ5cDlqWDhnQmtiNUdFOWpwb0kwYjZRR0F1M2NTTVRNVW5QQ1YwcTAwelZk?=
 =?utf-8?B?VFFkUzQreG04ckdhMDQzZ0NZQXRwQnBabXlhdGx2UWZkdFlvQnlkMEZJaFdh?=
 =?utf-8?B?MFFnK29SRzJ4NUpaTndzVHcxN2tzVVgxMDc4Nmg5Z1hDN2dzWkNlMWkzWnN6?=
 =?utf-8?B?MU14Mm9EQ25WM1ZRYUtodW1SR055cUR4bmN5eGZtcHhkNkJ5MFpjUWlXNWRw?=
 =?utf-8?B?M1NuOVJEdkVVUStNanNGODhpM0NTYmk0OXlXQ3JLVCtKVS9HWGJqK1AwUGNI?=
 =?utf-8?B?VVVQQVNjZmR0SThQNkZHeUZFT3ErN1dUdUczTURTb2dPRWpUTXhqR2lJV3pB?=
 =?utf-8?B?MFlrSjNLTjhIdzR1OVJyVExqUVZGNHZyRU1vMXVibHRIZXNiYjlzUWpzSVBw?=
 =?utf-8?B?S05WVHBBc0VrVE9rR3ZnUGhHOVVNbHJiZkdMYzdoS3FVb2FCc05NTWIrSEJ0?=
 =?utf-8?Q?7pm4bks8MCYcI9oxfQTewcaHbzogqIxpQ3cxM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnpHUEtjUlZZbUEwTzRoUWE0WUtBangveTNEU3Y5RElOaFNDTURPUEh6TVBw?=
 =?utf-8?B?c1M2ZlQrQzI2N0JPdUpuczNhbHdyZ1orMEF3VVF2eTdhamV4MkxyVVhTWjI1?=
 =?utf-8?B?VmMwRytNZTJWdTdhR2xqMGVmTUVJQmxVTFBsYWVkSEFUUFphUi9MeUNOdURV?=
 =?utf-8?B?YzZQbm1XTmgzUExjK0p0dzFNQzlmNHJCSytrbzR3TFE1ZWFGMFZETnIxV1Zv?=
 =?utf-8?B?SWM3ZWIwb1NKOG5tSHdFQWpsNUxUQnI5QmREcUZxbmV4aHQybmR1VjVIZkh6?=
 =?utf-8?B?Tk45RzMrREZ1cHN5bU9TdGFsK01TVHQrZU9ydWxqWTJNcStWcTk0OHh2djlZ?=
 =?utf-8?B?MGF3cXhFcHpDd2wyek82OU9iSnJFZVFiOWlrbzl0UExMYnlEc2xrY3JBNndT?=
 =?utf-8?B?TU00c3paY1lYaCt4SkNGd3o1VG9heStsbEtVY25WdTJFbWpqTTMwTWNNN21Y?=
 =?utf-8?B?RzFoQWM5dDNVdXM5d3VObGJJcUUrclMvQ08zSzc5YTVKaFd4UVljWGxSeXZS?=
 =?utf-8?B?MEZpT2gvYkFZOHdVS1lqR1kxQ0dhZHRIWmVRQWNBZnUyVlFneUVVR01aOXhz?=
 =?utf-8?B?M1MrUitGaU8yRnE5NVQ1bTY1M2wyWjJlWnlCanNhbERPcnB2THlQODg1SGxu?=
 =?utf-8?B?QnhBcVBMSGJOZUhDNk90L1VuNXI1akhJT0ZxVXZUNUdoOFViRFZpajFrTUZU?=
 =?utf-8?B?NGQwZEI0dHBqVzF0RVZWMll6Mk1yT1BqYVMwQ3BDZGhmK3A1MExsZXZ5VDk0?=
 =?utf-8?B?WnF2SGFpdFNrRFNyR0xUejdQME5yN3NjTHY2VkRFVkdqTkE5UzRrRXdaSFVw?=
 =?utf-8?B?bXZLVUNMa1ZNUS9pc2ZQNjByNXR2RnIrZ1o4NmhUUUd2NTFuci9KMjduOVhy?=
 =?utf-8?B?OS9NOGorcHY4bWpGdU5BdlZOUXVLUU5BdjkyOGtwYUhueEkxM0tyL2hpZi9u?=
 =?utf-8?B?empHVlltT2J6UThScHFPUGszS1JLSS9aUXlWeEkvdFRtSTc3dFdOZWg4Q3VB?=
 =?utf-8?B?T0lFMWhUZ2dVNFdKUzM2M0g3OW4yT1BMcmx1TzhUbk5xd1hTekoySGMrVUdo?=
 =?utf-8?B?SEplMFlFT0djWWY2SHhtODRVWTd3TVEzU1dFODd5SU50ckpIQnoxR0hjWEhL?=
 =?utf-8?B?TDBPRHFGQThwQzhkaU9ZYmhHVldXckVCc016YlpBdTIzS2E4N1I2RDYyclds?=
 =?utf-8?B?SFdWTUF4MndEOVU1Tk5vWWhaVVl4R0JoOGsxZFBtQlFya1JCNEJzUzRyUHJu?=
 =?utf-8?B?R011aTNGMDMxTW8yOFBML3FLUFNkdHFpN3Vrby9CSWVDSGc5a0FwM3Fvdm9R?=
 =?utf-8?B?eklKa2lXdlNycmx2OTRyL1U4NjJkRXo5REdEUHd2S05FWTdLTWIvZnBGLzZ0?=
 =?utf-8?B?MjR4VVZ5SXpmZTI0MHZ0bmkwcDFmUTNwUXF3VGJWcklnN3dnOXc5Z2VieGxo?=
 =?utf-8?B?WDk4NTcxMEpnZUVlYjlQdnBZKy8vb0c3eGFlaExFSitKQTUwYnY1cHk5a0JS?=
 =?utf-8?B?V1l4c1F0d2pRbFBmcDFtRGc5Z0dHdXRGVEFzOGZqQmN6Y0NwWDZ4UW1sYzd4?=
 =?utf-8?B?eEp2K2JtZVplMFZ4Zm9KK1ZYaVpTOTJWSDE1OGpaNXFHVDF3M0UvS3JjNlFT?=
 =?utf-8?B?Y3R3U0VTNnJ4UDRJa0xSaU9ON3JHUDBpeDRRTlFhdkI3REQyZ0NXZ05USTBw?=
 =?utf-8?B?eWI1MFhMazl1bDdkUko2WUJtbjBVQmZCNk0xaE1XbktxYmZHMExOT0NTZ014?=
 =?utf-8?B?MU9rUTVza1pVMGFBNVNqdU1QTmNCYVI3K0lCLzBEejVNSnpIS0ZuRngydk9Q?=
 =?utf-8?B?Y3IrTGcxZ0hmeG8zQkJDa1pld1cwSU1xWDlnRkw5STVNYTZwMFVjclhZTkNh?=
 =?utf-8?B?ZDVZNUJFS293V1l0cldrNVAwY1pyS1dhVi9CVkdUNjk5UkowU1NkUDVNd3hX?=
 =?utf-8?B?MllROHcyektPb0xmYkp4WU14enJRb05KSkJCUEkzV1A3ZUZnK0tSVGRFRFNl?=
 =?utf-8?B?ZkNRNjJSVFhBZDVrRFBzcElhVDRsMUVxNTNyM1h6YjFMNmNrMHpNY0dBVGo1?=
 =?utf-8?B?eG4vdENvM2FFWlY3VVpNSGovOE1naDFHTVdUSmtLVTNRUmU0V2QxRldqaldn?=
 =?utf-8?B?enM3alhhTHRVMDd5d3llWEdUa3ltUXRUak56bnRGY1Npc3lTZ2x1VDlmQU8y?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BJXauUnNOIRpIY1wXQhLMhLnAGY9EJtwlhWUGq3rEdoiRHaHK2DkyyX/gSU5scYXT+wwqlTVNFh0A00w8LkzgUZgYCq/20MXjIPhaBlsOqLYxabsIprExTTGjdSqYj4f3PfpDOw/Rog2beVA4wRT2I89Yd2t3qnq/yVb9ky8fBxZQKnjvTCJTTLhwLLRVgOdW41VBi8GrMUYd0WUw8Vlzp6ZJWeM+ZklDtfKEnGEoQsZblwRzRsr8mh0u+pBELztKkJ3b7NamcC3DyUdvIHj0Wuj5lbGurUzOzgpBC+J+CFIB/BlaNC7Cv6u+dktUT/J9vpb/HvTKqN8NWj30qZAYrXEzwzFI/ygsm5s2t7kzod6F+D5v+ttRudO8sB7CjDK+LHr+vUPt7GekgWeZ/ZuAbB+2FvaLp1Arqn89TfJZbhneYTQz2wANzeFGEOFDAYwnCgio9wTuyqfid7fpveMlkFizLkpQntxGxjsBn0qWx7G/tJBFwWOEPpzgpEHWIC1lb08MEFvbxhKU0o2x5VlHpfMr22GEx/0ypjTzJjGgZzvl6IjvfGKDVPLHybB1xwSSVG+j2e4vYo6Kw8h/EMxNQFn0HRbEZO9GLhWKK3wlX4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361a4de1-ea4c-4cc9-26e7-08ddeb95919e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 09:29:38.3575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tpHSTq0hVcacAjJsi9zBnvhMpoH/kI9h8qSAKdLNz0pNbzaIct+nxbSrXNSCLFwuC9TWudKJhjsJhJbe5xwbXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6455
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509040093
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDA5MyBTYWx0ZWRfXwIKxr3jEru+D
 v3HmlR5Xod1ijvz6WDzRDWfStkGtumiVL7ibeohwfpCInpW4d3s1slJGoqLkXSytEoUTA8pnS8I
 LnsMsAovJhWDUcsLRklWkRrZObRDxZlRcfz1ejYjLD7XLj3/vNAsJR3DenaMi3TV+VqIBojKT/E
 RRHOqH97L77ZJE3Lxu7uCdRxwzrf6RCKh36CSPOOI2QN6fbwEy1gxP/HyMcTUFpI9QBODuFxsZr
 mq2t3NOR+ZTtVHMuV+3h7aYOJtCfbKT6aywCSKlDCKzwVBWl95i7heC3py68QLOL7DZ8CSpCPmy
 5ne6b5QRb3O7bLokO5xc/UkDb/XP/HhY9T3jCUzFvjUFaSFpzOSOceyFG5+hhmnIiO5aWEaRp8S
 8RKLhzMiCG3njM0WeoblCIqu0sxkww==
X-Proofpoint-ORIG-GUID: zy6A6E5IiBbS5UJT7y2rmDSOb6IRscLu
X-Proofpoint-GUID: zy6A6E5IiBbS5UJT7y2rmDSOb6IRscLu
X-Authority-Analysis: v=2.4 cv=cNXgskeN c=1 sm=1 tr=0 ts=68b95d55 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=N54-gffFAAAA:8 a=2tV7ngs75H-R2TIe7gAA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13602

On 27/08/2025 01:06, Bart Van Assche wrote:
> From: Hannes Reinecke <hare@suse.de>

some more comments.

> 
> Add the flag 'alloc_pseudo_sdev' to the SCSI host template and allocate a
> pseudo SCSI device if the flag is set.  This device has the SCSI ID
> <max_id>:U64_MAX so it won't clash with any devices the LLD might create.
> It's excluded from scanning and will not show up in sysfs. Additionally,
> pseudo SCSI devices are skipped by shost_for_each_device(). This prevents
> that the SCSI error handler tries to submit a reset to a non-existent
> logical unit.
> 
> The intention is to use this device to send internal commands to the
> storage device.
> 

about naming, I think that "shost_sdev" is nicer than "pseudo_dev", but 
that is just my personal taste.

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
>   drivers/scsi/scsi.c        |  7 ++--
>   drivers/scsi/scsi_priv.h   |  2 ++
>   drivers/scsi/scsi_scan.c   | 70 ++++++++++++++++++++++++++++++++++++--
>   drivers/scsi/scsi_sysfs.c  |  4 ++-
>   include/scsi/scsi_device.h | 16 +++++++++
>   include/scsi/scsi_host.h   |  9 +++++
>   7 files changed, 110 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index d7091f625faf..e860ac93499d 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -307,6 +307,14 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	if (error)
>   		goto out_del_dev;
>   
> +	if (sht->alloc_pseudo_sdev) {
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
> index 9a0f467264b3..a290c3aa7b88 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -826,8 +826,11 @@ struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *shost,
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
>   		next = NULL;
>   		list = list->next;
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
> index 3c6e089e80c3..3eba5656c82a 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -365,7 +365,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
>   
>   	scsi_sysfs_device_initialize(sdev);

is the pseudo sdev visible in sysfs?

>   
> -	if (shost->hostt->sdev_init) {
> +	if (!scsi_device_is_pseudo_dev(sdev) && shost->hostt->sdev_init) {
>   		ret = shost->hostt->sdev_init(sdev);
>   		if (ret) {
>   			/*
> @@ -1077,7 +1077,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>   	else if (*bflags & BLIST_MAX_1024)
>   		lim.max_hw_sectors = 1024;
>   
> -	if (hostt->sdev_configure)
> +	if (!scsi_device_is_pseudo_dev(sdev) && hostt->sdev_configure)

we also have an sdev_configure check later for calling 
scsi_realloc_sdev_budget_map() (not shown) - should we have that call 
(to scsi_realloc_sdev_budget_map())?

>   		ret = hostt->sdev_configure(sdev, &lim);
>   	if (ret) {
>   		queue_limits_cancel_update(sdev->request_queue);

should we really be updating the queue limits (not shown) for the pseudo 
sdev?


> @@ -1212,6 +1212,12 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
> @@ -2077,12 +2083,16 @@ EXPORT_SYMBOL(scsi_scan_host);
>   
>   void scsi_forget_host(struct Scsi_Host *shost)
>   {
> -	struct scsi_device *sdev;
> +	struct scsi_device *sdev, *pseudo_sdev = NULL;
>   	unsigned long flags;
>   
>    restart:
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	list_for_each_entry(sdev, &shost->__devices, siblings) {
> +		if (scsi_device_is_pseudo_dev(sdev)) {
> +			pseudo_sdev = sdev;

it's not ideal that we can be re-assigning this to the same value since 
this loop may be restarted

> +			continue;
> +		}
>   		if (sdev->sdev_state == SDEV_DEL)
>   			continue;
>   		spin_unlock_irqrestore(shost->host_lock, flags);
> @@ -2090,5 +2100,59 @@ void scsi_forget_host(struct Scsi_Host *shost)
>   		goto restart;
>   	}
>   	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	/*
> +	 * Remove the pseudo device last since it may be needed during removal
> +	 * of other SCSI devices.
> +	 */

don't we already have a pointer to pseudo_sdev in shost->pseudo_sdev?

> +	if (pseudo_sdev)
> +		__scsi_remove_device(pseudo_sdev);
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
> +
> +	starget = scsi_alloc_target(&shost->shost_gendev, 0, shost->max_id);
> +	if (!starget)
> +		goto out;
> +
> +	sdev = scsi_alloc_sdev(starget, U64_MAX, NULL);
> +	if (!sdev)
> +		goto reap_target;
> +
> +	sdev->borken = 0;
> +
> +put_target:
> +	/* See also the get_device(dev) call in scsi_alloc_target(). */
> +	put_device(&starget->dev);
> +
> +out:
> +	return sdev;
> +
> +reap_target:
> +	scsi_target_reap(starget);
> +	goto put_target;

can we do better than jumping backwards? Maybe


	sdev = scsi_alloc_sdev(starget, U64_MAX, NULL);
	if (!sdev) {
		scsi_target_reap(starget);
		goto put_target;

	}

> +}
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 169af7d47ce7..f1d509f74f17 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1406,6 +1406,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>   	int error;
>   	struct scsi_target *starget = sdev->sdev_target;
>   
> +	WARN_ON_ONCE(scsi_device_is_pseudo_dev(sdev));

should we also error out?

Can we seem to be able to call this from scsi_add_lun() - is that proper?

> +
>   	error = scsi_target_add(starget);
>   	if (error)
>   		return error;
> @@ -1513,7 +1515,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
>   	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
>   	cancel_work_sync(&sdev->requeue_work);
