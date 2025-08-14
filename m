Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85091E4BE
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 17:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755191057; cv=fail; b=byvL/wQRx+bWPespdO7CxWYbbVPtDPEq7vzzZlniCVIyUyn6nRXqtFnAsmh+7cKIkoiPzwV7hi61E7YuHRo1DbbihqhV4ozG/HrCYaJ03akvk+2F9vqwXvJsUOFA0rKKqA7zw2h+yvT5++Jx0OIu2bWzvA1Xpdabxt7VNBZWavw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755191057; c=relaxed/simple;
	bh=oXO5O4A/5jllOGdVdudsW7PFqlVi5S9soz0yxwHqJXE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dlSnMvkckYrSHo6oncTryF3q8pjMX5HDri0iLd0z3N99K2922sZOYVHAbhxRbQ3YLmIGz8Ck50YXwmJ1psRDg5gqNnfiOJQas3CeGortwRPV1XsXRJB5VNZYYq8BUogVmJ3XX4X0fuY7rf+PYy2zOcvWbbwUivvEYpiIysOpOb0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Bh7KadFb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cDvTdLhv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bh7KadFb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cDvTdLhv"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57ECg37j002217;
	Thu, 14 Aug 2025 17:04:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zzDHgviCMrpT31DUft5wNRxH21lhFbMv8XggH8jE7VA=; b=
	Bh7KadFbiHSl5kUVuX+kVs8Zxdhe7V1/EixS1RC6qSsybQE9swOBi9zyT9lqdp7w
	jCdRD/CLxXZRPsjIc3zqdjeGWnIg4FkhmEZ5+zTHf7keXNQWLMplnU4p+VAxyUQ4
	CVX2C9lCgnzXhh/riVbQbY3HbYLqUZEL55iQuP0xqYinXPr4V6GSV+RxQiumBsjO
	iPOJyQN2Iol0i759PJ40gBnQuZ11s51R4N3etJVoCLK2FJbOeW3FtkH98jkaeXpY
	m6JNxpkLvtGP7baB2I79lkZwiVTpb8xuRnwNUBhW1GA2O07vMiLsMmsawtmP03R1
	2jyQu18eK0I3ajjRvFxmcw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48h7rmsmse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 17:04:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57EGj7Rb017412;
	Thu, 14 Aug 2025 17:04:06 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsd0nwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 17:04:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qm0cI68mXAiP4pUdjPsr8Yeon0LddVyDxihTOCqaN5/9SPU9WdyzGw9IQ44xHfk3bmQXG0fsFW2wQK0C8ReqUzHmJmcaDNnM/XZrL5fWq34QeUVcBwQqwTqo8bW4svvI/ZBtke4kF7AcYu5F1e6HoeuBUSP6WNUijJFX4rhZD3Unm2jpJynR4aL+zsMWHNrDyHwD/0muRSuC2l2UWxjhq2J6lTZbsUl4H1QFe1R0MZBjXFvPpTMjThpqmpCurceC655kOhdIgz55ISrlOYEk7gc0y8OTZW0JIF2b8Pxy+IpkFcHhkeo9/LAYsPEHwDI4lhaDh4Y8cvttJGMDcIhYmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zzDHgviCMrpT31DUft5wNRxH21lhFbMv8XggH8jE7VA=;
 b=XS9/xxO2HkBMhlat4yTK4gRFqAd90OoY/B/CaJ8oWayFzKSjdlf12FXJZSy1cBBthgd/Jz9w030R87psw8tesA7J0WH/bk2zpBHwciDHQRdgFqM7j4GGFB5EKYAZjI8Cd6EHgXSlmgMnrXv3QnA9Yu7W7WaQyJYnC8S5uGy3fWVfrTOy0ro6YfldKsYrojYDc7yiSUMPYFDHC+aI3SLMvp5rMy06g/MzRAYocm/qm8wKcAORXX+IlnR6A5iwsJPh+Wevb8M9NUOzKP1hp5FQ+KHzooax0XKJn4GOE4zQblJ/SnK/FpKGOA6xhMLril9r2BQvDheRBceX26reP3/CDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzDHgviCMrpT31DUft5wNRxH21lhFbMv8XggH8jE7VA=;
 b=cDvTdLhvMK7pYo6QIq7v6X0vLfupHQZILHRIZJdy/3eYsMlV4Wm6UTuwVV2bulkT+Riq/2WRO693Wr5oOYNdUDTH+kxzpQL0q3G05TDqlys2uvtrZXlJn7qgdBli8PEpz1Fb9GG/BOwHYjeplrQp6s8zWCwV+W22jSQ/AzBZUbo=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA1PR10MB7357.namprd10.prod.outlook.com (2603:10b6:208:3ff::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 17:04:02 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 17:04:01 +0000
Message-ID: <8feb4887-ec2e-460b-ba53-532cde86aeb6@oracle.com>
Date: Thu, 14 Aug 2025 18:03:58 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/30] scsi: core: Introduce
 scsi_host_update_can_queue()
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250811173634.514041-1-bvanassche@acm.org>
 <20250811173634.514041-6-bvanassche@acm.org>
 <b65c0887-82da-42c7-b6dd-4a42d593fb69@oracle.com>
 <26558c0b-d793-4804-a60e-a21ab7116d1a@acm.org>
 <dcb3c431-c9d8-4f9e-acda-a3111bc05c38@oracle.com>
 <c9458843-db32-4619-837b-bd0a87cebbae@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c9458843-db32-4619-837b-bd0a87cebbae@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0301.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::19) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA1PR10MB7357:EE_
X-MS-Office365-Filtering-Correlation-Id: d2efc257-476d-498f-b2d3-08dddb5490b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODRWemcvTWtPM3hZTUxoUmNTem4vaUpUcC92Vzl4K1F5N0hnR3B1U0FzdnI2?=
 =?utf-8?B?bmRQUEJ5VlE3UU9WTU14YjRjSmwwSDV0eTI0emNmM1dHTXVkVTRQeXUzVDd6?=
 =?utf-8?B?YWZTQ3hWeFd5TVIxZk9BLzE4dUdqWnU4QkRFTDBEMXNIMGViL2ZzTVZWUjRq?=
 =?utf-8?B?aVMycUYwdXpUclV1SDZXU3oyaHRNREZoR0tTa3VXa0dOMGw3UUhNT3B0U0Jw?=
 =?utf-8?B?WEVPcWpEd0lhU1hPeDlBZUJid0x1R3RiVmxhMEtnTGF4b1loMXJUcmpqalBj?=
 =?utf-8?B?dDZiSkdzamZmRnFISjB2SHA5WmQzOGw4R0l2Wno1SDFBTUdLayt2cHowTE1Q?=
 =?utf-8?B?WHkzVVNrVFJmbXgxU1NhUXNDVFFFcG00TEFROWtrWUJQeC8vNHU2YTJJOHVx?=
 =?utf-8?B?RHI2cUZ0ZUUwU1JSSlZZWDZjTFRjQURmQWVLS3BkRlgrZHdZbkpZUmdZdjB4?=
 =?utf-8?B?THlWTzNwNVB1blVPTUxyc3lWd0R6NUtCazhwYjlhZ2hGVjd0RytDNjFhZUR6?=
 =?utf-8?B?eW8wd0ZkUi9yeE5FQytGOEJxcU5sanNDMlhJUHpBdEczMmFlaXNkZmdhbHFK?=
 =?utf-8?B?bXJma3FqZWdOdGRySDFoRXBkQkZ1QUltYkEvcFNzVUsyYUZBZ2pQVkNWVllH?=
 =?utf-8?B?TExyMWhibHJmZXg1SjdGQjhzQ1R0eW1Qd3JSVDZHVDNiNTJ3dXV2N1JOMXNX?=
 =?utf-8?B?NzdlSDh2ekJMaXZ3M3V3dGNhSGV2VTdrK2F5SVk1RXJmbXI4UkhSckFKa0lM?=
 =?utf-8?B?SUhNRG1sdlBDMUpoWFNRbUFPVGFKVkdIRFU2dGozS2ZzSzcyZi9PYktlbXgv?=
 =?utf-8?B?V0JCTVlPZFluSzMvRTNGeURwQUNsS0oxUFR0OHFCTVRMUDJGN0lsbk1wT3l6?=
 =?utf-8?B?NGczSWpiODF1ODZqTXZKQTg5ZGpwdWNVMi9tS1VUSjRYNzVCTVlMUU5McFNz?=
 =?utf-8?B?dWt6ak5mak9kTmtPY1krWVZVQ2w2c0JONm9PMEVLbmhTcklXejIrQTgxcjhM?=
 =?utf-8?B?cEVNN1ZiZUxkRHdic0RTaWhRUHJlODJZL3lveGIwMEJ6UkVDWmQ5dFpvL1Qy?=
 =?utf-8?B?WVZhRjFTdXQvdEdNS3Bua2szTGl6R2tDUDFSV3JvdHlnQlRPTUlEK1RMYk9L?=
 =?utf-8?B?MEhWeVo4eGxtK250a1hWTHQ1Z3l1endWcHg1QjdYaExpZkp1d0QxZ2RCTW1F?=
 =?utf-8?B?MGpxNGdpT3JRTTJCNkV3bmMzUXF5M2ZYMVFhRjFHUXFyUWt1Z3hZS0t1MnBZ?=
 =?utf-8?B?cFRNZ2FpcTJMajVJUzFGOGhjK1A3NVRaUk55eTFDR0xreTV5aHdGajg1dllt?=
 =?utf-8?B?Q0QxcnVmaDlFcmtkZGRQZVdmWnJhbUFwcUU1NG5USGpGalZ0UVI4N2xEVWZY?=
 =?utf-8?B?V3FlRVZSS3ZKY1hobXB0L2xTZjg1NDdmOVhjUmhYeCtUNVdCYkE3VUswY3J5?=
 =?utf-8?B?VXl4dnpTYjJ0YVpJMHNVenNMTnBJWEVBa0Z5WHRTcklkakl1TVhXaVFvb2JD?=
 =?utf-8?B?MXlqVkVnTkd2Vy8yWVMvenhZTFZpalVpUjlEOTgvWFhSNTJxVEVFVjE0blp1?=
 =?utf-8?B?eXRkQWlibTl4ZGxSRUFZbUlhVHMxdTIxRUNnTlB2eXdYZCtoNEF1Q3dUZlZU?=
 =?utf-8?B?a3ZvdllqS1hFZGxHNzh3NEllcGYzbzRpTWt0ck5lRVBWZ1BIaGVKWFRjL1FB?=
 =?utf-8?B?UERJRks4Zm82Qkc1enR0RllhOXlNRC9teGNtNkpIQVBzVlVUbWorRVZEQjND?=
 =?utf-8?B?ZkFpVlZic3ovaTZVZXlpUTc2cWpsKzZZZXIvN1F1c1cxeEdOVW1XbW1zSmd0?=
 =?utf-8?B?OEFkM2R4a0ZZZ1diZFBLWEVRMTQ4eDR3TWtoSS9BZnh4RGJPRWU1a0VzTWMw?=
 =?utf-8?B?WlNKUExpK1pKT3VqYVhaNDIrdmJHVlpzMTd2VjlZZkM2UGNLZ1F2cHVDZFI3?=
 =?utf-8?Q?dImCZhAWdLg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzcwU2F5WklmNmx2eXJkSGNYMndhYUcvR3ViK2ZsaFRTV0RRalpYeUo1dXkx?=
 =?utf-8?B?cnFWQ0ZXS0JVdEFUeUR4b20yb1Z5ZEdmNC9xWm5tRlEzZ1pIQkFQZ25zZXhR?=
 =?utf-8?B?UTMxNndnV3NwK0dMVGh1d3hRUlFMaXpLR1R4elREZGhoejRpR0VPc1NMZ0l3?=
 =?utf-8?B?VU55Mkk1Ri9GNXVWQlp6SWc3SUU4elhESFpnOGpTODFLUHpPQ3ZmY0Q2YTdK?=
 =?utf-8?B?a3lrTDAvUHRTYUVqTmJ6aytvdU9rK015bW9SbStMUUNWQUpkdTk5N2JxYTVW?=
 =?utf-8?B?NUFZQ1ZyS2dCVWlycmpoOVkyTWNiMlJjWDB3cjhmdVZraGhWdnZ6TW1Db1NC?=
 =?utf-8?B?cU9hWDRoUnJGYmpnWmlUd3NTc0tXTEZhY252NXU3a3ZscDdZU3NxWnU5L2ty?=
 =?utf-8?B?UENSU21XY0UyMk9YY1NjRzZHZ3lIV3huaEc2eER1WHM2NGZnbVFwUy9vUDJL?=
 =?utf-8?B?MzRMRWJqMnJDMjZPTldYZXQ3Uy9vWnI3RS9aWWNFSUUzNnN2eXBXWUN1dytm?=
 =?utf-8?B?R3d1VWZKdk42WWg1TUVDc1lheEdQYk80SFo3VE9NZWtKb3RyUFRBcXUxclBr?=
 =?utf-8?B?d09HMCtzUzFLRTR6dloxeElYTXhvcVMzTXJNMzZBNlNBakw5SEpMWXU1SHUr?=
 =?utf-8?B?amYzOUIvaWYwRGJITldVdWdCWWo4eWFZOTRTV1p3azZ3azJYeDJRUDM2VkxJ?=
 =?utf-8?B?SFZ0ZDZxWk02bFFkbE9vYmFDeXZQZmZtWHhDdWo2eS9QUFBGbkRHMEhiWUlx?=
 =?utf-8?B?alVVY01LSlFlNGZEaTRZQnNzSnozSnJ3eEZHekRaaTFqSldWcm9QK3BmdGdP?=
 =?utf-8?B?c2o2VjIxMWJqNW1LUzVFMExZb0M0SUxBT1R4ZmlLaVNnQktYRC9jMDFCaXk5?=
 =?utf-8?B?b1NIK0JYOW0va2hMZ3RWUHRlcFV4USt1dTJlRjVLelc2WEd1em9UUVhENTJ0?=
 =?utf-8?B?ZnVHUzZ0dUVVSXFkTktsY1N1eFRLcFdmb0QrR3FzTWlhbkd2ZUR6dmRhUXBK?=
 =?utf-8?B?eWxaZkJxajRxU1RTZ0pSVm14NmRyYUtGbFAzeFVmdHJnMU0zbFoxdEJJcjJO?=
 =?utf-8?B?dS9Ma0RoR2UzNGFCdGZjSnlOdDBHSGh0TFp5NWhNOTFodVZoa296bzJUWEg3?=
 =?utf-8?B?R3FNeE1yZVkreTZ1Qk1YQ0YzejZ3QmdtYVJYZGdBV3FZTkhJeW01NjQxR1Jp?=
 =?utf-8?B?Mm1abHZoMlo1T2cydkNJK2hjTThlamMwQ1NHMjNEVy8xVVJFcW80VlFyeGpU?=
 =?utf-8?B?ZVI2eG9nRGZENm1ldE9LWFdWZzEwckplZnVPWWIwL3NHa2tjcUdNTWZMVEJI?=
 =?utf-8?B?REJjNm5zaFN1UlY5TVF5dnkwdnFQYnFRdWRONWFzZXhkTzBGc2UzNVJmcGw1?=
 =?utf-8?B?NVRxU0xCSVNIMFBJeFB6SkdHQjREc0ZEVVNVbVN6WldSQ3BhdSs4aHBROG9u?=
 =?utf-8?B?WXM5Rk55aUJsRWpVRnhnNmV1aHlyWWdzdUZ3L1QzcEFxZmhETkJsYXFFRURD?=
 =?utf-8?B?ZVN6eEd6Q3YwVHdlZ1hzNjkweEhPSCtOODdqd1YyU2xiWnNVTU00N1Iwbzl5?=
 =?utf-8?B?MFBMVnZGOFN6MlVyNXlPNXlTMHZVbDRLMFdLeWRRYWNqNXY1UEJxWGpQbVJR?=
 =?utf-8?B?Qk1ia0pldmpVbDZhMTJrRXh0VTlCSU9VTXBrODFUTzFSaW1TWGRBaFVOYUIy?=
 =?utf-8?B?akZwQ3hiUGtFZWg5dkxIYVhuMlRMKzMwNTFzTFBTSXgra1E0eU1Mby9WWEYy?=
 =?utf-8?B?cmFNSUg0ODNqL2Y4TS9NM3ZTcDFUTWtRU2xBN2pqbkFFS0JkNzZlRSt0bmdO?=
 =?utf-8?B?M2IrMENCMlg5VEN6dXllU2VaU2ZMRTZEeFpGdytwaFhuT0IxYWk0NkdjcFE5?=
 =?utf-8?B?SGNVSTBwcGZKN01NWUdmbDAxb3hjWWxlMmpGM0tMYVQzak13VGlPZC9lRjZI?=
 =?utf-8?B?cWdOcTN4NER4WEhvWFhHTEMxOXVtZDdmYURiOUNJOUdiOEptWGh0bkl4MmZC?=
 =?utf-8?B?Y0NnRnFKMzBxYlJGZy9QNWNHWk9vYitIdjcvSlFicFgrdEFOdG5kckVBcUdw?=
 =?utf-8?B?Y0JhRllOTktOOFc0RDFXeFZvWDdXWFNTYUZwVkh4MlBIZ0l2bWtQdDVvVURo?=
 =?utf-8?Q?UweBEgzBZfMr5PZmn0mexLKMw?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dpN89NQSPpwCJtE8a+TgrC/8XCF6T0f71j4ruC5vQwg57dV2NZYzwCh+hD1n4v2YfMwCN2p3KES2eYTkU1vQS7CQqIv+UXu0ls8sRh9TVe1wK2LWlAmFD7zHRtM6JcbelORf2ZXeUbd5mv7zNlNNPvtzLwbN8kgWXN6VP4TsWweAi7GHlYo1uxwdcKFMru4HA54YEZhg1nM1mfmUseNTPJhyVixgGHQFuxqNMI8ChtdIilI1OqDmnlc50kjr9XRqnD0TBSqWHU7++bjAmEdkAuNwU/YPb3YBTlexR8X9kVDnOh0QShdG62TlB6pudQf9fu2LlY/XyCI/HBb7uiIhFcs5ABMcgCZ/hImVKmV6SSlRQFoR0o0NG8KXAkECvVM65mfUhNMWjcT5r4GWzNyXf+HGcUsR7f1xjpUPLQNd6dXvdIyEAjxoVGJI4ZiRjpC7gLEy643XwasSWm8iiP5FdhOGQEwGCtWw2YZ99xa2/g9GF3hlcDWLokXBcQjdeQURp/a1CWM/2wKzgXOgj180MJ6eRFK80hDf3wo8dFrw4aPzlbZv89tIkF/SPEKHkz/bzVAig+zJHuDKhEZ/wmTB9lK4rfLdgeEjp6gYRzxRWWQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2efc257-476d-498f-b2d3-08dddb5490b7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 17:04:01.0275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T90SVXQ2TkSWfFBwG0ZZmVBbALjuU09ywrdiD08hzgKWhzz/CAC5A0wewZpbzhRXRPJD67XX7K5hGMaEjX5g8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7357
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508140146
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE0MDE0NiBTYWx0ZWRfX41U8Qex5D4qp
 MRLzJ6gDRHnB0droX6XfsCLs7DLdu3DIFVQ0xL9PvPUQf2uzlVTD8n2UO3VCB/kn1SXwOX5oNRW
 SHfNI5obmhgjX8jKoUyyIu6/NqKBwly+Nghb9dCKUOvTFjQWKnMXPH4Tk24Hx4lJHOxHOSw5rDF
 vwKoMUPMhAlXaNxtI8wYdwde6GMNSqnRQOXhcotD5XMXugDLNW0lAj2Q8rPkFfSgsdv/lOLJX0q
 2F4ATzo5SvN+D9wAgts9F27TbDgLUKmt3cvs6poZEtjLJJDw3TKFRk25r9sYlz26ZaWgsqSbDZ5
 0A0SfUdMgJ50sod7VY54bUrF8qgroPvYcSmMW1CYXZlSoJTUc3RpB66xzqVDgK7GN2gSeepyRlZ
 /+FYDYIkecV35zhmYSscd5HG11LhjWwSAPQzSpQ+oRhxYnpWO6gku+bpeBWwGHcvrMcCROBQ
X-Proofpoint-ORIG-GUID: am_mIQu6sulKUlChAtitnPQddjOMia02
X-Authority-Analysis: v=2.4 cv=UN3dHDfy c=1 sm=1 tr=0 ts=689e1707 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=KpfKWv26lmIQ69-VN3QA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: am_mIQu6sulKUlChAtitnPQddjOMia02

On 14/08/2025 17:17, Bart Van Assche wrote:
>> If so, I just don't know why the ufs host and device queue depths are 
>> not handled separately like other SCSI drivers. That would be the 
>> shost-  >can_queue = ufs host queue depth and the scsi slave device qd 
>> would be the ufs device queue depth.
> 
> It is probably possible to convert the UFS kernel driver to this
> approach. However, that will lead to some wasted memory. UFSHCI
> 4.0 controllers may support up to 256 outstanding commands. The UFS
> devices that I'm familiar with support 32, 64 or 128 outstanding
> commands. pahole reports the following for a local aarch64 kernel build:
> * sizeof(struct scsi_cmnd) = 344.
> * sizeof(ufshcd_lrb) = 152.
> * sizeof(utp_transfer_cmd_desc) = 1024
> * SG_ALL = 128
> * ufshcd_sg_entry_size(hba) = sizeof(struct ufshcd_sg_entry) = 16
> * ufshcd_get_ucd_size(hba) = 1024 + 128 * 16 = 3072
> * sizeof(struct utp_transfer_req_desc) = 32
> 
> For a controller that supports 256 outstanding commands and a UFS device
> that supports 32 outstanding commands this will result in (256 - 32) *
> (344 + 152 + 3072 + 32) = 224 * 3600 = 806,400 bytes of memory that is 
> never used. I'm not sure all UFS users will agree with this
> 
> BTW, reserving space for SG_ALL (128) scatter/gather entries in each
> command seems excessive to me but even if that would be addressed, there
> still would be a significant amount of memory that is not used without
> scsi_host_update_can_queue().

Well that is how life is for other SCSI drivers. Changing the shost q 
depth with scsi_host_update_can_queue() is a bit ghastly, IMHO.

Earlier you wrote "The current approach in the UFS driver
is to reserve one command slot for device management commands, not to
make that command slot visible to the SCSI core and also to have code"

I don't know why a raw QEURY command cannot be sent before 
scsi_host_alloc() to get this ufs device queue depth. An arbitrary tag 
can be used. That tag could then be re-used as part of the shost tagset. 
There prob would be some duplicated code for sending this raw QEURY 
command, but that seems to be worth it if you really want to save memory.

Thanks,
John

