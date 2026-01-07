Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B4949620
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 18:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767809223; cv=fail; b=e9QIjj/FuX6DFQk89YEECqUi49Jff8+pE3IeRYRYWNOKE3snKpH+uXpMQxRtv0+Sg9+wsbKdaZ7C2gF2ADbhCGXwJtDMLJQ5fNWOvJZ5MOnP9EJMtbqOXXj1zS6HsCCg1Ocf0pP7JRJUxuuRtHygBHv/c4+MKcSJXEQNYhgnoJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767809223; c=relaxed/simple;
	bh=EDt09535pwLyREvlo2f9tcCJpI2ALm4N3CX58YFIg2Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o/B5AI3yLMDS6QFuFT4rvcVyDwo5W3DLaduNG2LwJJdJXc6n9Ed/2at7d0txmgWst/yqM/sOz4YoW0+EjKjihd5woKN2SlaZpz94tZJb7ZP22EqPIi8G5giSA+bzlrt0mI6rzvDm1GqhfZHPPzJJ2RL4qaK8HqhxOP6GZyZGwXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rvcoRdMq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uZ10bvv1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rvcoRdMq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uZ10bvv1"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607FxnqI2045444;
	Wed, 7 Jan 2026 18:06:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hFDDtzHgejlTx0jUQIZ7kkJwpxFxnBnQbE+0sPjQF5Y=; b=
	rvcoRdMqpJl4bd4rgcFLeFVPJ0JId99pwFeKY5/bW86KvfmSjXZ0n//Vjhk6UoVG
	8BbLM9UGn8yySZuVCKmkLXMPy0pwc+ogWCbtUQ6gktMYOy1wN6rIy4nTsaosWX5M
	kcgSu/+xVv9zaZXZP3xG59Vz1/lANdf83rg8MgU0IURCNo8VwpK/cCXINsKaG8Vx
	vHC2EgW8Tpoi/RerRZ4Qbah+/fNTr9kWe/b9MhxrFTr4iLkKgQKhcDZK7B3MPZWh
	Dn9sBu9r2A/biJNaPgoYoefTLMKvp1V/JoytIiIBmMLXWEMGpTHhHsPxT/QaexZZ
	5GHZx+Bmueg99sEpkuasiQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhtm687cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 18:06:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607GIO1R020376;
	Wed, 7 Jan 2026 18:06:55 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011039.outbound.protection.outlook.com [40.107.208.39])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjm5hat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 18:06:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UUQq2hLJWlQHhYggKujUWoNY7W2cLgJpo0qg6OKk9oxEFU5/SqS8mHgsD+kgyG3lArmPUF/6mY5T+uwBv8wlfoTAD/4w+A6tym0ctgUixnB6WGWuT4GBrNmNQWIeRegHywk3NMtQVSSphB5CrLqQfMxYVpwuZ284yvO2IMYFTLdrCBtpb9lApNVZf/V/11wImQyiDtxv/34KJJCnulMxJjB1dkAYKqyJ0+GOCP/63f9QW7WfI8BDCHA87JDOojxTKfAzWgHEL3UJZU8qyKiZIOX0Twn4Ia2TyvMhPQQ2dCsFDrd5kCQLqHWe3e3XrSGEr496vTueLfeSXGyj/y/7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFDDtzHgejlTx0jUQIZ7kkJwpxFxnBnQbE+0sPjQF5Y=;
 b=uECqBfd57rSoDNX1Yv6RzAl9UN9Ms5hH6g5G1e1HAB1p6L+vaWCG4G6rtgm1QyxP/EroC7G9hS7eZ9xUbdEflSGuBCBy7tDBXkiIv/yROnQubrw8OT+SS+g/itvit7Hvc0qazt54jRyPIGtUtfplpdctZbOz50Nn7GLJmA+t7QC6z8sYUbj+ImPEPTfx2skhb1Y7FqXArctNoYGMLxlBHrhsO98bhICA06jp+BzwAMXSzgnPJWCRJAWpMgGltwRodnCQfJzty86arny7GwGD5u9giFesVZH4kN4bhyuuZPu1zan+ZdDWNjN1yKbcgCD51m/5JOh8+Vble/SghFp0yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFDDtzHgejlTx0jUQIZ7kkJwpxFxnBnQbE+0sPjQF5Y=;
 b=uZ10bvv1B5SQSLAATL0BkQzwlNT6V+3Zv/WFvKZegrOJI1AL8pqjh0/7hgFYkNAmxVBUwf58qbfrBj2PNhyxpdDPeYQfTme3pEvEbdgv8IkzP5igrcI0eX2bNg8y5GFPOZ1LTu8lyR8AZPFL51tQc3pfCo51D7qqvwPHPavjyKw=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by SJ1PR10MB5978.namprd10.prod.outlook.com
 (2603:10b6:a03:45f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 18:06:51 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 18:06:49 +0000
Message-ID: <e820c7d7-f11d-4fab-a505-11b1fcc33d3b@oracle.com>
Date: Wed, 7 Jan 2026 18:06:47 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Revert "Fix a regression triggered by
 scsi_host_busy()"
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260107174753.3089238-1-bvanassche@acm.org>
 <20260107174753.3089238-3-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260107174753.3089238-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0045.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::14) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|SJ1PR10MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: 9faaa4c8-86b2-4270-f797-08de4e178775
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmhTN0lOZjZtYmpoRld1WXUyNVhUWFBsNG1LNm1WUWUwY1NUOEpKUmIvWTBQ?=
 =?utf-8?B?dHM3UjZwbjhKU2ZldjZVZDV5RE83dHJybnBYNW9DSEp6akk4Tm5vZ3FZQ0ln?=
 =?utf-8?B?S05WQVozOE1zbW1TNCtCUkpMbktIK0JGODdYY2s5cWlOOUR2NzBrMHNXMW9M?=
 =?utf-8?B?NldYVXJ2R2ZOQWFvcm8yV1EvY2c5OStmdVRKbWw3NkRTQlFqNVJwL3MzZVhq?=
 =?utf-8?B?QTBpMk5Qck40dUd3WTEyOVA0eENUUytrbGlDZGc4ZnR1Umh6RjlKQTJ6R2lw?=
 =?utf-8?B?VzFhc3NaU3dQUW40SjZQT21jOTd1aTBtdUVCTjhkaXFtWUtneUQwUGlNUUJi?=
 =?utf-8?B?cXllVXphdEZlYUhlQTkyN1FFd2ZiaHQvTEFnMlU2T2NDN2E5Z2J2K3Azdng5?=
 =?utf-8?B?UXNkUXBEVzdmYmVLL2ZGTlZKaGlXSVd1bVZ0TUx1ZzlhLy9rNUVSWkI0VGM1?=
 =?utf-8?B?eTNXdFRmVm1EWEFyR1B2OU16OHNLQ2JoYU0rY2FFQ1hVUXBxZjBmeDd4MHBw?=
 =?utf-8?B?NEZTQmtiK3JoQnUzakV4eVFodXhnc3dNQzdhQUJBWmlobUtDdUlhclhEaHRZ?=
 =?utf-8?B?S3VJdzQvdDl4QzNyL1MxWXVWZDVON01uc3hVSWpoUlJjNCtKWThObGhwV3Ju?=
 =?utf-8?B?YUlmMUNrM2pyODMwOU1uMWc3U3h0bEdKazhxRzhlYWppMXFNZnNub0pxZU5X?=
 =?utf-8?B?TXdQNW5UL3NGZFZjSktITitJV0RUNzBlRTVnZUo2SmNhY2F6SE5WOVZzVWNH?=
 =?utf-8?B?Z2JnWnVSTmxMRE8xOFQ2UERNS0lvK3A4UkJxQ3V2ZDNTNHdHaWxYL3ROTzRT?=
 =?utf-8?B?d3RQamJVWVViSDAxRkhrdTBwVEdlbzIrVG9kU2IyYllyaTYyVzBISnBvcWlK?=
 =?utf-8?B?UURUTEM5TGtPbDJxRWZSRWs0T1c4aFdEZkpYb285d3VqdnVxblBTK0xKdGp6?=
 =?utf-8?B?YStScEJXNnJ3Z2Fjd0FWTTQ4UzBzV1pOZTJZdTVqRFY3K1QzWURZOHkvb1Bv?=
 =?utf-8?B?S3k5SEYwZzJaMW8rSTlEZDBHaHdncjJnWE9tcjN4TTNkSjdhM3hqZFJ6Wk9h?=
 =?utf-8?B?R3FEL1Z5dmdjU09UWm5LMWVFK3U3M3I2Q3lwQlBMRFRjMi9NOU1tb0cwVnVJ?=
 =?utf-8?B?S3d3UTRvNjFjRTBEaXJ5eU50bGFxYXZCU29zeHlxQlJrOUEyWTdmMGNVbGpJ?=
 =?utf-8?B?eVA0RWp6OFVEeFhXemRydHVhZGNVSnJOaHl4aDVFTFFhdDNiR0x1RDdHSTg0?=
 =?utf-8?B?WlcxSFBLVVVHc1JGRkhtUE05MG5tYk5TMzRxQ3pvN0NlVnN2YUhFT29qUElk?=
 =?utf-8?B?VnVSNWQyOXpxZExRQkJEOThuQXJDcERyNk54UzltS2kzWGZyT1pFa1lleWJm?=
 =?utf-8?B?a1F5VzJ6RGIrWjVpWGhLVHdhaWFRT2pZd0IrSjZMUTlodHZyeWNXYzZHL0NY?=
 =?utf-8?B?VUJ4d3VGYk5yalVkbnBJSzFwK1YxMjNsdmdveDZwSXRMTGVPbGJLbVRLTjF6?=
 =?utf-8?B?c0d0czNiSi9ZdDFjOUtUNW9HZ0JLQXQzWEVBMkVONUdsV285QkhOd2VrbGZx?=
 =?utf-8?B?ejhyWWNRY2NvaFBRdVprOThkOTZaZlp3d1dtYWs2d2NBSy8wbTF3WFVWNlRF?=
 =?utf-8?B?d0w4UzhNUzArK1pjbm9pcHErdlBRL2JGYWszbXRYMUdIREtjeDZpYTFxM1Mv?=
 =?utf-8?B?UFdPbHBteGdDVEZ5RTR6Z0dscGI1eCtHUk1KZFVpMWZOMHQ4ZXk4RzhNdkRr?=
 =?utf-8?B?UjR4NUg3VnZFdis0NkYzdnV0MHVvK0F3NG5pd1RLMUJyZGIxUFcvUFhBRkNt?=
 =?utf-8?B?VjVqbEg5SHhqejJQd2psbUEvOFBWcHlhbjMyT3JlamFzdTBwOGo2NXNaNkUz?=
 =?utf-8?B?L0w5MXZXdWxFbTRlYXhpbzZ3TjRYbjR0ZnprYzc0anF1Q2w3dW8yZmY3UWps?=
 =?utf-8?Q?/qVYjinDweVDABTdQI9jgywkj5qk2MLY?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QTMwc3Z4Vm8yTXcxcnBJWklOQzBaTytUMlc2ZTlFRG53WnNvS2ZwQnlRVHA4?=
 =?utf-8?B?WGpUOG9uQlFQMGNVOWtVeGQ0V1R5VGFRREtwV1JldFZlK1NEaVZCSXRzMkdn?=
 =?utf-8?B?Nm9DVXA4VE0veXpBWUQ0WVpSZVVpb3poQWpta2wxcjMwVFdvb0tJUHhpVGVF?=
 =?utf-8?B?cjdoSG0wQ1dpTUhVYWczZ0kzdXBYRlZvd0l5ZVgyMUhPQ3ZXcjFOaUZpOWE2?=
 =?utf-8?B?T2x4MVJmK0IrNTBuQ2VEWDVuUTRCRFlid2Jva0ViUnV2Q2s5Y2t2TzNXVEFk?=
 =?utf-8?B?YXdTQTc2WkdWL1h1aHBId3NocnFqaUNQSFNtSmZlK2NxMmlvWFcxT1Z2L2xG?=
 =?utf-8?B?RW54aGdZNVJBT1NTSnFNOUQvSEZvOGhQbytXZlRUdlBKSGVlSjl3NTBWSmhB?=
 =?utf-8?B?NDVySzBQajJZTWU4Y2F4Qm1VaWkyZnNmSXNaRWpxOEZKYnpFTHBKd3NSMWhF?=
 =?utf-8?B?OWJhM1ZQWjgzUXMxdkdwWmp1cy9BbFdEUzdZcUlhdDVXRU1QbmxaZWoyZFVJ?=
 =?utf-8?B?RGZXZEFPSm5YVlA4REdId3QvVktZSWJDNm5SSE9iTnhiblE3cVo1N3NPS1NP?=
 =?utf-8?B?ZWw2Tk5qcWpDS1B5a3krZkxoVjRXVVhTTjc2eHo3bXA3WHQzVnl6Rnd4OTJ3?=
 =?utf-8?B?RWRkd0NPNkxiVEFjY2ZYSWJKV0xrQnIzTHhqcmY0ckZSMXBobVduZ0ZWSDc5?=
 =?utf-8?B?djdZVFQzV0RockhGNi9LOGF6K0tjZ25iVFRocml3S2plQWg2LzVCL2Zoc0hK?=
 =?utf-8?B?WVFMempRb0tBMDJpcEpFTVA3QitTRWg1czlMSlhrTzdaeFY5R0ViQ0d0ZHYr?=
 =?utf-8?B?bmI4S3lpUzF6WnNjODkwMzZibmVmc3hvYnhuMm5ZbmptTkdRR2FvU2F3UzV0?=
 =?utf-8?B?dXphdUV6T0ROMlJHMThWeWh2S3FLM0VHVHEwZHdIdnAyL2thMjZDVGUyaHhO?=
 =?utf-8?B?VEdXYm5ualpLNnorSjczQVNpQ1pGRU1ncWtCamxTa0cwY0lJQ3A3RW9UbjZw?=
 =?utf-8?B?cDVHcmMxTlFyaXZ3MWRCWEpVUEpsTkw2TncwUlBrWVZoZHA0VFo3VG5zdllB?=
 =?utf-8?B?MnFBbHFzUUJ1Sy9aM3VFaDJ6d1FGaFZZcC9keFc5bGFOb2hReXE2V2RiZGc3?=
 =?utf-8?B?VktUOEtEc3BSQ3grdjE3L2VwaXRpa0t3anJWTGgyWGlZUS9CK3BGUmhDVGMy?=
 =?utf-8?B?OVhCVzJaQVlBQ1BFM0FES3ZPYWNqUzRaNFdZeGNwSGU0Ti90UTN4RWFqeGYw?=
 =?utf-8?B?a25TbjRTRmNxV0ZFd0sxaldrWkwrc2piSWNuZmpjbzNseVdlcDJhOVMvb2l6?=
 =?utf-8?B?TGs2SzE5bGkrZGxiZy9jZG5nUmY0cWhBQmRPK1pGWmtKSG5zZjIvMFJ0QWhI?=
 =?utf-8?B?NlV4VWczejIrVzBCQ0pBeXJMRTdMZTlWTm4zM2VPSkp6Z1lwMkg4YjBXald6?=
 =?utf-8?B?eWp1SWVqNzg3M2kzL3dRRWowM1h6M2RYMjE1bFVDNGQwaUxFRStKK2g4OHNy?=
 =?utf-8?B?MFFyNVAyM1J3eHhIc000dmRDbkZFRXA1aUNPaDVPUWtyVDJGSjdYQnhpRWtr?=
 =?utf-8?B?ZkI4YUdDUFFCWkFSczVuU3ZhZmkzZWlNOEpzUXN2ZkJKaFlSTjZYbm12MzVa?=
 =?utf-8?B?ZEI5dDFqbFY5WTRoUzRuOGdRMHFua1FrNjhmMDExUHpYbnlibk41aTAyMWhY?=
 =?utf-8?B?bHNLclNVRDFrNk5jc2NLc0VsTmdmVXlrR29JYVJrMnZqYmZ5SUJOT0l3OXBv?=
 =?utf-8?B?dWxmdENxNC94Z0Y3VXFYWE1MRUVKUHZsNkZrNTdwL1VtNTh4WlNhL1FBQUxh?=
 =?utf-8?B?K1lGRHdjbGxlcWxXVVpSVm9xczhidm9Bbng2Ky9Idk1RZEJIcTFpL2I4SEJL?=
 =?utf-8?B?THBBL2syR0x4NTZid3MxenI0cjEzTGVsaEZobWF1Y21lSGRMbWJueHpTWGxP?=
 =?utf-8?B?cEtLWVY2d3ZWRU54MU4rTGpIc3R0dFZkai9zM3JMMGQ1K0E2MExjeHUyRlEz?=
 =?utf-8?B?d2E1MU5wWURNejUrUWVvQUVReXNrd1EvZWRmdFJjMFh2RVNXcGVhUitrK0Js?=
 =?utf-8?B?aGhTMUJPeWZiWml0MUFCcTdpRmljbG1wMjFyeVZMODgwcDlpTExNNXNzVTdM?=
 =?utf-8?B?YjA4ZFRIUGdla2RBeTJJZXdXNlNaYUFseFRLUWtQU3lRUkN3ZnVONkZsZFZM?=
 =?utf-8?B?TFl5bjM2VndmeXVYemNPNW9OV3gwWDhNbGlsMnNjd01HcWxXeFpZNHRtM2Vw?=
 =?utf-8?B?QnZXbUY4Q0xyeTI1UHJURmo1akcvYjd4dDZCL1RsUDZBV3VzcWFoaGt1YTB6?=
 =?utf-8?B?TUJ2T1Y3TjJrQkxKV29YWk0xUUdpbC9uTUsweHNvTGxKZWZMM3RVdS8xV3lJ?=
 =?utf-8?Q?Wx1Dlrhs8pXxH3Go=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4Ms5ThheNX/b0hcEsu4VRoyUbCJxTH10k668m11z7U9CyUC2WcEmcXCDN+zxgczjJIFMrbxMMCBY9nftIht/iDjwxSzUuWNIpKm3dTx8ld2XFW91Wa2PHGYyzQpXDMnVxcAmSP2nTOC1R6uXlXXJzEuaKMMmL22IiZMY1cXyUi/ks9v1o4N85IUFaixiuRMYxtIQ9QL9XXOs2n8Uex100S8IsOsXN0dszDfB3uyTqfwiHrH1TAz1nGpqKpdvh9/EMVH8nqkEzpOZViBl91rB6uHPvvC1XG22iO+fgo41kPgGG3ba8dSZ0xN5ZM1lRrr6TN9aFp1jWeheb4w3DRDpfn2SvDNs9TKsqpjs7qdiRHkSbp7Ulc3LphinhYnPh362DBlsMFeehjzDzf+Xs4Yjz9uP4cxar01BXl/wGeCUzeA7mHt0yuCwLiEIGHOxeyfi5B5FNI8On0f9VwnTfPSAww06F8G2fCjPrb4A6vu2mZOuiLDEDWkwQCfuMnC/LGTFIhCOnVAMB78caZ47nKWf085vfuMS8KsaLVQQBpc++XWPPGtSUjhBKEuOIQqYHVT75X+bRXDTbn1MOV/EDU0nQzOgCYVj1q453EPuUe4+W/M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9faaa4c8-86b2-4270-f797-08de4e178775
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 18:06:49.9023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CyBrjcjeHfPgJ4a5hvCYUrfs3+mbwH5Ywtq0xgv/bnhCYvHFbz4Iiu8T60pvN7+A8ddVA/kdK4dDebO/cN0vjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5978
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601070143
X-Proofpoint-GUID: kDVFK22evT7GLEsxCJmRbjDtNrA15e1f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDE0MyBTYWx0ZWRfX0G5YnY0wo7EA
 K5jMlLntYohlA3oBQrprXta9QDPWo8TEHskDW8cIYgsYnJaVtTrBGWIGYVtgV9/BJsqCYpJ1uAN
 Cmw6Q7FpHgf7ssmjR/rBf75OfybyUnisONEIIyiGR7iwRLrELVsHtjkxxRbg0+MbCJMdBrC3oh5
 Ys1OWZoYK9Zq19+U5oj3RxMSuJE+f/ar9t93GA3LLKzeZvYyMCveBeTwmlmtjNXWqnnXluQ+wMI
 wWHsRSF20N2waI4Aq1d9UY1zvb33Zzf3yapbk9YuZN6rwN4FoHnAftAnzSsiEFXhO9oDKv93y02
 ConQVtx9U4NlHpAHYdlSkz8h8DEZiztsmHgNAskoaYR/2fWeJHD3bm2EilayVOfDse5oNY/GV5/
 fhUc52KQFG1Wd/xzSY2XMWqWZYncG0TnEQiL6RMAbbmctNVSF9EQaCRqolaM/+qBMyXnltCFFTv
 n805e120d0/sCsAl3XXvMQdRS9p0Ddcm3ASSyOGY=
X-Proofpoint-ORIG-GUID: kDVFK22evT7GLEsxCJmRbjDtNrA15e1f
X-Authority-Analysis: v=2.4 cv=XKs9iAhE c=1 sm=1 tr=0 ts=695ea0c0 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=N54-gffFAAAA:8 a=YXk6d0r1JlC5MdOZSoAA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12109

On 07/01/2026 17:47, Bart Van Assche wrote:
> Revert commit a0b7780602b1 ("scsi: core: Fix a regression triggered by
> scsi_host_busy()") because all scsi_host_busy() calls now happen after
> the corresponding SCSI host has been added.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/hosts.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 196479cbfe6e..f1dd71a2d89d 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -626,9 +626,9 @@ int scsi_host_busy(struct Scsi_Host *shost)
>   {
>   	int cnt = 0;
>   
> -	if (shost->tag_set.ops)
> -		blk_mq_tagset_busy_iter(&shost->tag_set,
> -					scsi_host_check_in_flight, &cnt);
> +	WARN_ON_ONCE(!shost->tag_set.ops);

If shost->tag_set.ops == NULL, then we will detect it like before, 
right? If so, I don't think that it is required.

> +	blk_mq_tagset_busy_iter(&shost->tag_set,
> +				scsi_host_check_in_flight, &cnt);
>   	return cnt;
>   }
>   EXPORT_SYMBOL(scsi_host_busy);

