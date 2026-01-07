Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97691328B5D
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 12:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767788721; cv=fail; b=jOyqHsVVPpeiXlFdqe6CUkzrVc9gideXCkEmoTpe1DDik8XGJano0YEDdcWKFVPvxmBXBlPSre6ooSkRoi+n/XgKo270INY9oF1ukWHy/gw3MjnVIyRB/7tNKwxWMdd86iLlXw/Si8MgavsZewCuyxRzVVWAuOmZu651G8HaWZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767788721; c=relaxed/simple;
	bh=I11vOFCrybD4J6iPeIprAmE+KHjGtK1EzDu0W8PMLZw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H2DoTo/OZU747YodVWd8G13ZO2AaTrb5wZ4Ni4ZMk+dWajf2dzARB+lGY91jXL2VfR51UdhGHmK49UezWvuXjK2Y4gpaiOG3CmyxZ8CditePlRQRr5+rpQFNpHIYfPMAv79TRl1h1RkOcTfuAUd60Iix5iMQaI1PPmvDgDzFyK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dz8/yEJs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IS8HBp6y; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dz8/yEJs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IS8HBp6y"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 607CNKmq1687295;
	Wed, 7 Jan 2026 12:25:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=BQ1jPyAcu6X62s8ssonO/hzDpRddVoGklHZi+qSwyFk=; b=
	Dz8/yEJs0ypYMtekvWLMajv0gyzfyQ9bP9gtyDAS0ZtqvKf5y2DBo6s8R9bH5q/L
	3HSSrTNQ5RVp6UDquSokbVHWsdpQ3W0Q5NeaKPqPXQxYpmN+zCbmBPkwlpSLFGMt
	1x7OQcpDPW9anGwK8IoIA9SoIHF4642JzE77qIrm7zXN+m3k46LQWVfZVvExHKwG
	gvOPlEIYXvCRw8qnoGZxwaBp+MjnT3ccoj2hAQ0dyuZ06T+4cK6SlN5PhbOHCSy5
	D9dlHzYc4NVNm/77EM9t8xp2RaNgjex7Mg22Vpo9AcOZPbQOFHrs8VmDTO7+MhbS
	4B6vD6vMzF1+fyYCpLPsjw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhqew002b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 12:25:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 607BpB9w020492;
	Wed, 7 Jan 2026 12:25:10 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjktb76-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 12:25:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sWlDAuDFFuZg5rS+EDp6z6SG4Gum3KofThuJUiIKOqTpD5gIoy7my4XDuhEEvN4dZxLvYt9IkQUl4Tr8ppwjlK8PutfZELUtyEh/z4HO9uor8F32wZzg2sWhvkq1OpTnavLpqTW8UzA9PxYMHxVJlzant6JzpVwQe8n9Fatpu1kxtc2zmmY98rB1uS+zvyuLAQaxJxOn2uX/fQkY1g/mT1OW/ZJXEzYA8i6DnxU76sEWdaMv2Dd5zcdyHynNePwFmYgCH0cr/8JmW5ds6R30iU1W1tJCa6ZuOkKapMWg/w4Pst++h4b+bcgTHyYnqpixAq/n9+AHu+ZiyZFJNnGBTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQ1jPyAcu6X62s8ssonO/hzDpRddVoGklHZi+qSwyFk=;
 b=b9obJOt7igxYZ3S+LPYIx7Wrjosnx7qmszl9on8JbJWprMPchHxfcr9x4OxD+CG6d5LjgvF13N33Rvaimdyhbz52fBzhX96i67NCGuhhOkCnv+jyvmnX/iPT0DOh9q7cNigjpB/ocgnqSk69gkI3Cy21/CoWKXzF1j8FbEGsaq3GpDD9IWAEKNz/I25ptslonSLGxqhHcamyrMAgFWRWrt4X9YwAMJ+8i+BptvzFO+aoH2VbrRtYtt1KxOl8cgBQaBjuyTjKwLllUh+XIfEZQJxMDYMWrHzzJkP5IN2R02OrE8DWrLSnxXUKsqGzN1QxGPtreo+Yuyd3V+Idf9qgSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQ1jPyAcu6X62s8ssonO/hzDpRddVoGklHZi+qSwyFk=;
 b=IS8HBp6yuQPKVNfbz/NuMB/9yxLUxkoKATA3SZ34wqC0MeTxjQ5nfgDYxMgSPMdNH0T0m9MvsjoY837G8VGSB1KfB+WKp/ISrZDYqLzqdGCtr5luf5kWLn3Gc7rOUsJzg4+bdASZ1QHQcGibZfCZ1Krni4EXDNDARd1R69yiyS4=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by PH3PPF1C5E69607.namprd10.prod.outlook.com
 (2603:10b6:518:1::78c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 12:25:07 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 12:25:07 +0000
Message-ID: <d2294529-4054-4936-ac76-20c878bc74f5@oracle.com>
Date: Wed, 7 Jan 2026 12:25:04 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <yq1h5vr4qov.fsf@ca-mkp.ca.oracle.com>
 <fe16b110-300c-4b13-bf2b-56e7f2c6f297@oracle.com>
 <540bad1d-ba01-4044-94e0-4f7b05934779@acm.org>
 <cee0f307-b875-4578-b7ed-43daef2b238e@oracle.com>
 <91e387ed-fba0-4622-b357-53356fd7fee3@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <91e387ed-fba0-4622-b357-53356fd7fee3@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0407.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::16) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|PH3PPF1C5E69607:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a316fd9-8d3c-404e-695d-08de4de7cafc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RkNQMWdwSGQ1ZEVJYU1ka29KTlh6OG5CN2VucUcwWTBGcm1YTkpiM0ZzSU9R?=
 =?utf-8?B?cTBKVnMyOE1XQ2QyZzdPYW1YMXJ0V3VoVlhkZWk3UWFrS000N0dWS1J0cmtk?=
 =?utf-8?B?aFhzV0R6Rk5HbXFBOEtJSGFmUCtxRncxM3AwM281SkRXVFJPaXlhU2FOdG9B?=
 =?utf-8?B?amhmYlduT0k2ckVxNHhScEVvdVBORCtpMktHN2pZclVaQkxHM0Q1cDJRV0hX?=
 =?utf-8?B?Rm55RHVOblhhZThHcWN0eEcvcm5RNExJSmpDb0NZR1hmL0NYQzQyMUNiNW4r?=
 =?utf-8?B?Z2l5VWVYYVFxeW5hVElQRmg3a3NMWjlSUStyTkl4N1VSdFQycUJidnI4Zlpk?=
 =?utf-8?B?UnROdXdUQkY5aXViZVYzK1JWajg1WmZKTWpkYU5KRkZxTSt3MGJPbEs3REdD?=
 =?utf-8?B?Sm9LQXEzYVg1cXNyTm1ZVVhXN3FydG9GSXFsblFDcThNV1pXTDFwZ0NTZlNq?=
 =?utf-8?B?ZVZldnRWUyt4a0RtdjcrZXZjTjJuMUVDUG1PK0NpN0k3M1RNaDI4VTRRRFNh?=
 =?utf-8?B?UTBtTWlaRlV2MHZ5cVY5aE9XUWxqWHNPT3VaUkFOczd4ZmVuWTNoSWdDcE5Z?=
 =?utf-8?B?SmpVNVZXUkF3a3hTcmp5dk9CMEtmL0xTcGtrTUdQOGJoM3lMMXM4ZTJBZ3BH?=
 =?utf-8?B?KzhoWXZFeXlwWDU3YWIyUGZIWnljU0p0cGE5WlBzTWJ0SGRHTGRnQW5lMStL?=
 =?utf-8?B?ZTJ2UjVHdFc4WE10VkVLdlJCQVJlMFVwdE1vbEJSM25wUUE5aWdUZDREbEVM?=
 =?utf-8?B?U1VEVjRMelplVE4wY3ZOZ2VTU1g0UlA1MUNxYWdRWm9MZ1NZd1N1amRXUkF5?=
 =?utf-8?B?MVBLOE5ZekJqelhEcEJhNHNhNGY3QmRvcnl0MHcwZThtY1R0RHZ6ZFpoUjdw?=
 =?utf-8?B?YTZneDMxUGM5WHlMYnlNT3dNek9OeDljY0I3MC9qWVYxRkpIb3JrNTlmRFRR?=
 =?utf-8?B?RUFyWUpnNG02UFRTZDI3b0M4cFRoTEU3VUNuYUZkekNOcDc1OWJ3U0NodGRz?=
 =?utf-8?B?eWdyNXpjVnlLSllTc2dwejRoQUJ1L0I1R0dVODRsZG9FRUt3Z0RwN3l0US9B?=
 =?utf-8?B?aS96NGkramZ5KzBLQnlvaXg2aC96anhHaCtjZklOcHliWXFRWU5BeEs4Z0JS?=
 =?utf-8?B?VHVZTnltbnFjZGlJNmt2d3JpbnlSbFZCVGpqU1A2TDBwTHVOdzFRSzY0MU8y?=
 =?utf-8?B?TWpJMUdjeXpwQ1hPb01NWjBieXJZaVpiaWJKSVFYK29SSWZMS1NtTUYreWRB?=
 =?utf-8?B?NkRGVUdpeWNvVjdlMEQ5Q25ZZWkrZlhqb0dRMWRKbzhXQktFbWIyYUNkVFY4?=
 =?utf-8?B?em5haUY4MGV0d3RKV01kbTdaN1pQQlE1MkZtUG1MVW00bVQ4dmxKbjB3ZnVx?=
 =?utf-8?B?TVBuMnFvd2VHZExZOUZ6YXYwb0M5TzZUYkF3MVp3VkhFZ0dHckhKSE9aN1N0?=
 =?utf-8?B?Umd3aVlyOXNPT29zL0piRGdWU1RrYXlZcXdzaDlEeEhMMTRmTkV3eHdNVTUz?=
 =?utf-8?B?WXA1MDA2YXY5blhDbTYzZFJTWTRTT2JNcEhzOWwzQ2dBQTd0UHh4bk8raTA5?=
 =?utf-8?B?NG5qVVlwbitDTmRKWXJCb0t2TjM5QlNDRmtVMDArNVAwdkFZaFFsREJCZ0tC?=
 =?utf-8?B?akozdVRuUTlpVFUybmthZkc4WkJPMEsxWjBEcWNZWlNlRXdJOU93UU41b1kv?=
 =?utf-8?B?SFNSYmZMVHpaZXZHbEhrYjhKamNqcE9zMUsvVW1ESzBydnR0MlBkd011ejdB?=
 =?utf-8?B?U3oxWjdmdnREWGJyU3JQSFJ3L0wxT0Rwc0JHUldqUlZ0OFppTjQybVZkdk9m?=
 =?utf-8?B?SUtqbXZqZUoxdkFiN3hDbFFqK2M0a0txL0dCdTBuMzRRWWZWQ3FZWE4xK0hR?=
 =?utf-8?B?UHBncXRYSWluNVUrRjNLM2lYUG92TndqUmxwYnF5VzNvVVZBT1hFVFg3ZXNC?=
 =?utf-8?Q?L+5K0+sXqM+7n8WZATmeSs1iiVYVl6fk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3N6ak1VVlhXNGQxSkdUMEJhT3ZJSTJ0SWRMaTdtNk1VWCtXVFd0c3RVSC9l?=
 =?utf-8?B?RTlXZDYveWtvSjdMOGUrbzFNNFZGbldUaEVFdDR6NXB1S0FaZzJMQUc1bU8w?=
 =?utf-8?B?SEJBdkExdDlyVlF0UHVrbS94dmFYbEdZN1V4SW8zV09kMVBGeFFzYlN1ZG4w?=
 =?utf-8?B?U2lOMnRaVUZLVXNBb1hDNEsxOUJoT1NJOThiNDdvNzZ2MGJOOXp2bHFScERB?=
 =?utf-8?B?THBWeW9QY3d4NGFyOW1zRHVWVnJzckN5Z0dIbVI0azVybjg0NWpGMkdPekg2?=
 =?utf-8?B?STJDYkU3SUIxYlZjZ3drUDJnRGd1RS9rTzVVc0dVbktpeVRMb3dFZFl5YkM0?=
 =?utf-8?B?S0QxRWxYSi9lcmVZWFZLUm5UOUVNSy9JdWFSbnRhVkgwbS9jdmRjcm1LSmZj?=
 =?utf-8?B?Rlk1dVNDSjdSR043cjFsbExvWXBpVU1IVDM5S1V1OFFHckpjclI0cVk5UEpP?=
 =?utf-8?B?VzhYZ3l3VnFlbG9yWmgxRFMvelJJb1hzYjlJUS92UXRGZlp4M0FPT1pqOFVw?=
 =?utf-8?B?Y0dzRGxTc1lDdVJhQlpsamFybnlvVkd6azJ5bFJENUp1ek9KRXYzQ01kcVF0?=
 =?utf-8?B?Y1h0RHRXNWtqRjRPZXJDbGFiWnZVNWdLL0hHOExqOWhobWYvQnlDMWtxaGJG?=
 =?utf-8?B?TDdMMFN0Tm85WGVMbVBOWjlqZ2NTdDZZQnJqdk9QeThXTWhrdjJxMTlvYUhB?=
 =?utf-8?B?SjVGamUyNUR3TFlmMmJZR1FVRXF0M3V1UXMzbUliMTRKVTFDcWpFYzdrRDFs?=
 =?utf-8?B?Q1dSN2RLUGp3QzBWUG9HczVNR2FFTEYxUUxqanErSGZnU1hNdk8rN2dXWG8r?=
 =?utf-8?B?anRMbGdYbjg5a3pIOUIzaklOeGlKZDV5cEU0YWFVVDJjWVNBNWdKZjFtUk5E?=
 =?utf-8?B?LzZzNk4renk2aHJpSmlEeGMrTHhOVFZvV3ZMeUhrQWpObjBRNUI4cU02Z1hN?=
 =?utf-8?B?elErVFNRT3pJK3IwVWpBUnBub0c5UEhMMGthZGU4TEdEaHVtRnZQaVYzRTZD?=
 =?utf-8?B?dHJBWUErU05HQlFxRzZxNmtlUG44ZGlYYUxORy9GSjhTL0UvUlh6U0dnYSta?=
 =?utf-8?B?WGNSbnIyU0swWmNCZTVRdjZDUTNxa2VXMXZHOEE3Sk9HR0tWanI1TUQ5eHVV?=
 =?utf-8?B?UEdCYzYzby8wckpKSlduMlJxV093akE4bHd0RFUyaS84N1NFTjNucGJUZGhY?=
 =?utf-8?B?aWRNK1NHaHVxR3Z3VkNsZDdmUnBvblVBdXdLWCtjRmJRbVJRL21RMzFBaU5h?=
 =?utf-8?B?L0xMeGVXZlpXalRJZER6R1hNZWhYUDdzMGNieVQvV3hMZGY3Y2hzMTlGekFP?=
 =?utf-8?B?QXM4aXlCL2s2Y1JZUi9VVVdjM3BKSTV1VHZzUkFZdHNKZEdSQVlwenlPdGRD?=
 =?utf-8?B?aWJxdGUrZEFVOTNDSC9tT2FmVXI4TlNoK3llWEhNYmEwUXVxN0VWMnFqY2wz?=
 =?utf-8?B?OXB3U2hTSmFER2M1SGlUQ2s0VXpuRXVwNE43dEtpQjFSZy9HWTVYeXB2M2JE?=
 =?utf-8?B?OVJxQ3ZQNUxVbXBvOXlUdXlNTmRNMlJqa2RwSEF1RXkrUUV1KzlVcS8zMW9Q?=
 =?utf-8?B?NUwvb1I4RFFxMjJ0NnF2NmxUZEtXMEJNZUs1UGRLeGZlbEFITDVnMFRYUnZJ?=
 =?utf-8?B?K1ZQRFlBRlY4ekFuYUdjaFd6UEN0UDBySGo1ZktCY0xFUDkxYURldHlQRS8r?=
 =?utf-8?B?Uml2MnZOQm0xRE9BVjFLR1l5Vkd3R1pkWWw5QXZ5REEzYUkyc2RqLzV5VW1O?=
 =?utf-8?B?aUl0OFZUMXkzSDdRSlZzYit0cjdGcytESkpWTGFJa0plZjhMZSs4MUdYYWNj?=
 =?utf-8?B?ZmJxOEtwaG56QWlrZXlLdUVVOU0xRWpIYmJySWVJY2JxT3g0Z3hMVnRjQ01l?=
 =?utf-8?B?YW1xVjlWRTBGak4yZElTa05lSXdrOWJ3aVh6Y1FFOXdhd01wWXNydWk2alhn?=
 =?utf-8?B?UGdQdSsvQTJESllrUm1lVkFGTlNHS2xFd2JTNU1PdmtKSlE0QnIyOWlUNUZ1?=
 =?utf-8?B?elVmRk5nR0dGL0FtczhwMWZOV2xrK1dlaWlQRVN3MmQwM0ZYN1VFNDhvWjF2?=
 =?utf-8?B?b0NsWGxrL0hrd3JJU2NieE4rSnJXdHFXNjJGSjNNUjMyOGJlaUVIV0NzSFZs?=
 =?utf-8?B?QjI3UnJnb3NMa3NFNys5TWtxTEx2clFWTDVaY3EwN2YxZVh0VWtZa3hiMGpa?=
 =?utf-8?B?R0FmZGdwcUo0RzU1c1VocTdBeU1uZGloK29LMjFKTW11azRiWjBYUVJhdytU?=
 =?utf-8?B?ZXZjZmw2dFRCcUNmZTFvUE9qMFBMcGdOblkvZVRKb0RiVDI4WkdVN2l4a2RE?=
 =?utf-8?B?UFRMRTlxaFVJZVpzQVVzWUR2ZkpYb0dSUG9QRzVYUE5wU1paUmhWc1Rrd1RZ?=
 =?utf-8?Q?hZVFi/URHJrk5JlA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wy8+d+ulvU9B51L6RDGTNVcSCsaNay98Qoysd5ggOKFIes3YNLwIGjFAbn1zoe2dTZ29LeiCiXyF0J3kqtCmCpRvGuT0GXciWFubk0A9vy9x1xYAkjeW4j8o59RtpYM73SYbaKCHfDTfe4/9LB8AT2m4diAjpUYfEUu3LUQS54DTtLLYnGHi01u7NYb/4/SAVStPPN6V556MgOxURae1uDVzCM21W+MK+K0JVVMj21D2yN+2Gr/oPmZ7OsCffeHaFWoRdhWhWsmP52Zha5e4dcih2rHb5mQHmQGbEsLBQTEEze9hsk64npbFPithnDMdho/xBG0+Yi4xD1Yn2CTElVZDGIERdhuONlSmMbLCIwvUDSWcYvxwSlr5myJpRKA0ROB/peIpWf3jRNXQvZ+zEjfDawAt006Qq7Gv90o5oydrdScQX0pfaDPS1hLRUq2Eqe+/7+jEs9BR3okwUqUPtkXPXMP8tCf9RZS6Ym+Y1lk2ip2vGGlPITVKDFnhTfdgqvm6rUS4yRohwgt/fiP/8lWrqphDYiazlWLR71/+tLWJyOzNNvOcWr9QWc2+naYeqqEf1MhuJpsnNtZTKm8XG5U5jsc/biL8UMrs/h7lm9s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a316fd9-8d3c-404e-695d-08de4de7cafc
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 12:25:07.3622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uR229TnA4rz0eIsaTYTyVJVxZkyRFEBxjYuED3x86x6YqfqM2/3YNdyUdMrt84pOncqUjGsgZOGZVXOjhdqYcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF1C5E69607
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-07_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601070095
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA5NSBTYWx0ZWRfX6L9wv3GYXbIP
 HuvOmOIBXDX/1ivgasa+rggzbuUn0chqS7ZiM/G36gqtT3EiKmI6jhWb3EQhRPVu1PAT0bEVxDz
 oBBNYcD/woRMs00GI1iNHANustP59g5CMIqZGSovIKYSXaiSG/8NkfeXx9vRQweSa/s6QGFPDW8
 ELvYH8MiVv3ClpEy8VvZv5DwcHq8ppnsoUvHJDIngHYe6+IMOhQPegZpwqdtkSui6mB1nVfdjcB
 w1udcexEsV2gIzic/h0efv8hgOUlWaXC7YXvKKov7cBV1zrHfOUXxFzCo3WT+D+5HOMZ3mlGWN8
 5rL6PahC/FGCyPF+jVxSoLzb3FR8bPZ0d5oj+MgGVcrdUZ/++nkJ+qYlhlNqhUTE04tHZWRUGN4
 TkDPqwbQ2VQF8eesgu4eGxV+dMnj4cMH+rOSkMUtJTNBQEUgz1vuLhTDSoXE3JcPouhkjFLgx59
 iTftsiZ/Vdq7yDk6nkQXYYGJXW26Ph7eBzNE++cw=
X-Authority-Analysis: v=2.4 cv=V+xwEOni c=1 sm=1 tr=0 ts=695e50a7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yK-KhGhZiwVIJIO0UigA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12109
X-Proofpoint-GUID: wHEmesCscQuacKKGLSHaBzyHy4qTjRIR
X-Proofpoint-ORIG-GUID: wHEmesCscQuacKKGLSHaBzyHy4qTjRIR

On 17/11/2025 16:29, Bart Van Assche wrote:
>> So far it seems that only scsi_debug may have a hidden problem, but I 
>> am not overly concerned with that.
> 
> Hi John,
> 
> The patch series "Optimize the hot path in the UFS driver" makes the
> scsi_add_host() call happen before most scsi_host_busy() calls. However,
> a few UIC commands are sent before scsi_add_host() is called and these
> may trigger the UFS error handler. The UFS error handler may trigger a
> call to ufshcd_print_host_state(). Something like this patch may be
> required (I will post this as an official patch after having tested it):

Hi Bart,

Any update on this?

Thanks!

> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index e90120d590f2..fadceb396400 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -678,7 +678,8 @@ static void ufshcd_print_host_state(struct ufs_hba 
> *hba)
> 
>          dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
>          dev_err(hba->dev, "%d outstanding reqs, tasks=0x%lx\n",
> -               scsi_host_busy(hba->host), hba->outstanding_tasks);
> +               hba->scsi_host_added ? scsi_host_busy(hba->host) : 0,
> +               hba->outstanding_tasks);
>          dev_err(hba->dev, "saved_err=0x%x, saved_uic_err=0x%x\n",
>                  hba->saved_err, hba->saved_uic_err);
>          dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",

