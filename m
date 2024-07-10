Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABDD328DB
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 22:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720649875; cv=fail; b=h7sw4R8O3fIroS1r4F9AEr39cT0bN1ob3gMYFZqmBnZQH1j5T3+PRH9gfDUkoGB1J5VAz+SEe5gneQCkND1CRKGbFUlMalvBpTRqJ39JfiJCT3fEWY0ADVOGaJlJsmU72dfvkHaaYd9McIE1N9sLBKshTJKDhRQHdKPUeK3qOMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720649875; c=relaxed/simple;
	bh=WdcUFYHfWpzZu83Dcd1H9aaH3dgCK9p/MNdNQN58dJE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l3uMpd8AdqOvctg8QaIugzbHORcqe4PZgZd2YF8MhCQ0/uyRybESLPnJ4RNsgXmdHHZVXsqc0gAMb4/CZcd09fkIFtXTute4O/E4cbnd9GNBu0Qex1N44pJzkx5NwpP7NllevVPVSaqXPq/zoxDRvSwJG3b5htUYsG6iDbvl2Ck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hQ6h5dkN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ouV4MaSt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hQ6h5dkN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ouV4MaSt"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AG6eEa017502;
	Wed, 10 Jul 2024 22:17:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=CRKcjpsm/bUwX7xe+YQi1LujY1I0unIjR9LG4i+XzB4=; b=
	hQ6h5dkNceWiDkzC/WWyot7bRrcV8Bx3+CsgSHh7k213IEHhGaLEWyCzLm7ec8Ro
	tu137FXSpefxNegjvprM9FZNx9ab5ViU2jQFdZjiQZUsdgpnpXyJYYe8YQ3F3bJp
	5MH5Of2+XM2EkuYXfAy96lx0gDNoHXnCnOYA2MstWZM/bMJxbEZxhPrRuLjGO5PM
	GRIxtDAiTVLC5BUjorfJJtVo1VxX8+b/dyNBf6V8Yygn4tbiXUQZkClCkCmRM2Vg
	wzh8WeIzl8O9q0CoJlg5biPpHaoUwi5rAUrcjM3g4+/3cz8nf6gxTih8diSxnBBX
	Dcjg1IeSxFF0DlyPei90iw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wybrf39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 22:17:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AMFGTu009080;
	Wed, 10 Jul 2024 22:17:48 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 409vv3qsc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 22:17:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X1lbILZ9JQQGyoIuz8EZ34jofHIMTKjpi4/VOyJMTOtix3pjb4UMODZ0gxBocSw+/6WeVIuclCYLlu3eT7jjKUvLJXY56qbQvVNrenZE0bK4enGt2hLCaSH4zlqpvHsOonkWkyj9TLhG9PiPBofTD0rQjeuiyx70WxQLx5NLAlnBIcOKfP0cWu7THyNgltCxEEIjFyDe8wNk11gbMCDn1qPtfbbgT3u9YF+0XEGPFQTaiCLHCEFMk0Db0wrYByF6l+e6PAlE1d3j8qAL6zPV+SohYVLOq0VvEdE/RtP/giB8luLQKDAyBeBpC2IvMzMFxFZ/BZ3gSwRTEBKacQq07g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CRKcjpsm/bUwX7xe+YQi1LujY1I0unIjR9LG4i+XzB4=;
 b=UWE3xmRKRlpSljn8YFczwaVJLOq55BTU9dMV2kbF+FjlIDiT3LGTqUqb+d+NvB2XkUaeF2DCNlox7ar2qEY305ca7aVCJ8ylHQHw5Iv0vjYQaKi7RWM52vxHBZj1pXerpa67qED23FGH/GL1OP9M//kD5SpCdZZzO5SD3jlVEZ5JVuixsVAw8SKkX19w0zL0ItkiG7miLDuJUphDrAwVm2wKai2Gf3leCCQbI9BjEoZrYiZp86sG3qRdxNiZ8yzKLeDqetA5REjEU1ebejneH2l3ykBZ68Vl5IxcPmtdB5sX6tNfFaZCDiUc0axRjmqlW7S95uX5VtaHhJSKxa2Mvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CRKcjpsm/bUwX7xe+YQi1LujY1I0unIjR9LG4i+XzB4=;
 b=ouV4MaSt3+Fv1dwDSRfs2SJW5T0vpXpmyTuHHFTrzm26KmzoGgFC2LVQ+DApYt5WVZ2HdcfmBzuP6WVbtY33xk5MryFGNfWi+XiQ1yRG4l7z0bCtGIx2nTK8EhpOlpgpRAwsNSSLlWBb+LXq7ETzxtbrc355fsaWfg8WN31UY34=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by DS0PR10MB6917.namprd10.prod.outlook.com (2603:10b6:8:134::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Wed, 10 Jul
 2024 22:17:45 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 22:17:45 +0000
Message-ID: <892be775-c4b4-4191-a200-70f30f34e67a@oracle.com>
Date: Wed, 10 Jul 2024 15:17:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/11] qla2xxx: Reduce fabric scan duplicate code
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20240710171057.35066-1-njavali@marvell.com>
 <20240710171057.35066-10-njavali@marvell.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240710171057.35066-10-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0002.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::15) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|DS0PR10MB6917:EE_
X-MS-Office365-Filtering-Correlation-Id: d79b5605-8955-494e-14f6-08dca12e1f75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?YUZWZzZ3cnB2b21HWWlXT2pVdzVWamRwaUVlQm1acnZrZlcxZGhhQS9VdFBC?=
 =?utf-8?B?ZmZxU09jYVlOMXlOSTg4Q2tFQUNlSGFTZGNjVnIzZHNodHlHelZZQU4zQVV4?=
 =?utf-8?B?blNIWURlNkUrOXZ4dzZmNE02d1JJeWVRcjFMT0Z5VWk4NUVkZnpqL05lYUxw?=
 =?utf-8?B?MzlNaEdieUthaDlzbmFIMnQzeWY5OG1zK2c1QWxEb2loQXlXc0J0YkhCRWEv?=
 =?utf-8?B?enJGWkNiUmppZE00NTdlMERrOHM3UU5tTlkweFBGSy94dHdJeit5a1J3cWFJ?=
 =?utf-8?B?WWordDUyMk43WjNmdzFsZ3dlWFlMeGtUMFY0d2kwWWRpRTdtRFE1Y01FK1hN?=
 =?utf-8?B?dDA5SGZidzNGTTRkQkwwT3pGSk51MDhLa2l6UUxOSk5KRWlVLzhFQzdTcGRt?=
 =?utf-8?B?ZnVVQnl0N0E5NEUzWUJyS3ZTSjgrOS9HT21KRE53NlN4NGdCZ083eFpxY0Na?=
 =?utf-8?B?azhpd2JQZG1UTElLdzAvMEtwbWVQbXZYR1hncmFyZFd4OGhKbjIwcVIvWENr?=
 =?utf-8?B?NkdLVGo5RGEvMUlUZDY1aFI1VUJrVHFQeFRvMm81VG9qakpLNDlySnpWRjI3?=
 =?utf-8?B?QzVVQ0F2YVhBWkdQZksvbnFVRTZJZUU0a0tsejlSU3E2bEg2V0UzL2ZnejBj?=
 =?utf-8?B?bXlzUVVVMTJ3T3MxRjh2eExQNnFta0RVQ1RHQjdrUmJKVm5ZMVB3K0s4MWxv?=
 =?utf-8?B?NkIrV1NTM2hlUUZ5SGRvNUR2V24xcjhFWDFzNTYvV1pYNXZsSW8xT3liczFO?=
 =?utf-8?B?MERFUTJST2IwVnNPaFBYQWpsdDVYK0o3WExuaVlPdkRNMzV5M1AyemhNc2tR?=
 =?utf-8?B?MnZnV0h4a0JFVy9BQll3d21DL1orQ1hLSGpZUmYwRVFwSDhjMWp5MWgxRVkr?=
 =?utf-8?B?d0xYOS9YS01Rbkc2RS8xYkVYQWphQjBSTEdaRVFGTUFrZ09XYzdNaGJ0V2U2?=
 =?utf-8?B?cEVVNVdiQTRNL2NGZ2hRSWhxc0hDV1Z2WVRjRmNHVUdIZHQ3clJua0UweGph?=
 =?utf-8?B?eTJXZjFqRDZ6d0xWYTdESjBlWFRtbGFlNDJqdXp6QXVQVjVkZ0JQbnNWMGQx?=
 =?utf-8?B?TnhrUjcyNU42ekZaTkxMUkpIK2RoVjh6ckxib0paUGtNMXp6R3ZWaVpJd0g5?=
 =?utf-8?B?K1FqOXBNaXF4L0dPZHg3STlxM2V6SzVYYlV0TC9HZkhuVi9KNUhMV09CQndx?=
 =?utf-8?B?OXpIdW1qTVdlVmprWW8wci9QUUhYMWd1emVhUS9mT296OWFRVmt3ZVl2V3RB?=
 =?utf-8?B?Vmg1UStocWVyMTVJR2Y4VXJCeUpsOFhZQThwVWRXUzhaNTFhUDNraDZJbGFL?=
 =?utf-8?B?MGlmYVNNV0RtTDhZcnBWcUNsZ0lVM0luTzlNZjVoUFZZRUNXMWt0NXFsbTJx?=
 =?utf-8?B?djNNMVI5K01lb3FJbUpjcDR4STUvR3pRTG8ybjFLWW5idWVBNmhaYVRoRmlK?=
 =?utf-8?B?bGQxK0pGOERCMWVkZXN5dGtpVlVLMU41REh3Ui9LV3RXOUJ2bTMzUktpVWxU?=
 =?utf-8?B?RURXUGUxeUlKN0Q5djRValdlaDBJY3F0SXVCM0VGTEZ4WWlVaXlQSzhmOXND?=
 =?utf-8?B?V0ZUM2tDZEJZUXFxdVJCeGdkN2dXSWwraDJRWW9ra3d4aTBoVVRkb003RUJn?=
 =?utf-8?B?SHc3cDRSbklBaW9sczRLekxETjVYOWVFNEw1aWxSTmM5bFQ2WS9GUHdSUkdk?=
 =?utf-8?B?OHVjdUpzbkp5R3Y2UDlEKy83S3RBY0pZSzdwYkRvczgrM1VwQUt3bGZWSHdz?=
 =?utf-8?B?M0Y1TmVVc0lpQXVINnFGTGpEWmRTc3JOdEJCc2Q2bUtEd1kwRUsrOUdGTGEw?=
 =?utf-8?B?WkNTV21OUGRucHVad1F5QT09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MExVOFJUQkF1ZVh6MTVTb0RiZVBtRXNiSUwzUmlFVXhkVDZVSU1pb0I0dzdG?=
 =?utf-8?B?b2YyM2JXQXNNNXZJb09JL00zODU5YU9mWGZFRnlwa1d6R08yLzBQUldDSVkw?=
 =?utf-8?B?Y0ZzRjBVR1o0eW9mTzZNMHAwdkE1ZHVvdlFTS2VKS0xVaTVJRFYwTERWRHBa?=
 =?utf-8?B?OEtVTUNWdlVKQXlNaEswaFN4NnRhZkozUU1RME9ZWEhQZ00zUnBQWjhHaVlR?=
 =?utf-8?B?YTB3TzZLTzVBR2ZrSURMdEIzTEo5ck1zMCtNeWs1Yk9TYUZ1ellVcGxibklo?=
 =?utf-8?B?K2FqaG15MjV3eXNvZHZ3QVRLMkxqTW1YNXJOeHNpNUdqOHkyTTQ1aXp2TjBW?=
 =?utf-8?B?S1d4V1RDSWdHd2NpaXJEQlhNN0Z1V2VybmFyaXRoekJNVmJVRSs3RmpTTEEz?=
 =?utf-8?B?YjUxbWt5SXhoanlKeFlNdHExNGZRVDEwWmRTOS9zVVlHL0c2ZUd0dmFaWTFv?=
 =?utf-8?B?RTc1UGFJWE81cnJyUFg5RFpxZWhrbkRBZDNCSWJ4K01BZ0VJZFd4NHpmSC9W?=
 =?utf-8?B?TmhFWVJsdTBRMzNNKzAwTzZwai9wcVpVM0tpaEZ0UWxvUC8yZWg0Wk1Sc3VX?=
 =?utf-8?B?Ukpjb2srM1pUdlUxaUhKUUVrTzJxVTlvYUhxbmNBWk9tYW9rdzlFcnZjZmc4?=
 =?utf-8?B?YkQ2TmZnNmhLMVdERnZZdjJReG5iMWh3OTN1NWRSdFFnNzdsK1hCT21qS3Nm?=
 =?utf-8?B?ZmRSZnJ0c2h1dUJHbEMreWE4RFYzQ0pVMzA1YmgxVTVOOHJDaWZmTm5jSSth?=
 =?utf-8?B?OS9QL1I2VzcwT2hyREhoaGJ0VzRMcnlybDVDQmd4eDRjUDlkV1o0eUxoWG5t?=
 =?utf-8?B?ZGlXMlAvOWZJYjZzNXc3YW81Z2NJN09JTUhBN1NRZjhUbkd3d09zVXdUa1Q5?=
 =?utf-8?B?d0g1VkI2Vk1zVnZ5UDdKYlRpeWNXOWZJRWVJc1hMVGJTM3pWV3hBSGFrMTVh?=
 =?utf-8?B?Q0o1ZVlXOFltY1RjdDh4ajMwekFvVXR6TlhhT3U2ZkJJLzcyMm1heFpwZFc3?=
 =?utf-8?B?NTErWTZOYzVDS0Jkc1grSTFtNmJwVkJ6L3hKMk5RVGRPeEZQZlJGNDl2N3Fu?=
 =?utf-8?B?UktSVHhlL1plR3ZqWkp2NW1kbjdNUXZLSGNpOUJ1TXdnNDJ3RGxpcDBvVXVC?=
 =?utf-8?B?QkpOYW1xTm13cmVES3dBVnJhbDhmY2czTFhZaVdRVlNseCtaTThmUlNFRE5J?=
 =?utf-8?B?VXNoaWIzZTFZb1p5WUJ0ZENRL0MvTmx3NjlwbGVGUldhNWJJNjR3LzZOakgz?=
 =?utf-8?B?YnljamJObDdvMWh1Ry9VRS9kUlhuajNHRFI4NXFHbGFLSEhORDJQVzNsTjRG?=
 =?utf-8?B?Vk9tMkllVkFRSm4vT1Rwd2R5R2l1Lyt3VWxCbkhvUUVleHNXRXpqUTA5dnRh?=
 =?utf-8?B?amFZWThEdjBHRU4wZVRHckpOQk0zaFNwU0k3bWI4Z2N6aEwzS0NNRzBKdlBU?=
 =?utf-8?B?N2NyVG1LelA4WHFGRmk1SmZEUVRWZi82alBEZ01Ia0FZNzcvMENoWGc4WWpx?=
 =?utf-8?B?cUNYTnQ3VGFSbkV2SEpXa04wZHIrYTh4MnZHZmJXaTFoYzN6UG1wN3Q0SStI?=
 =?utf-8?B?NEdrbU9QWlNBL2djUng2NHZyQXdhWE5Pd1NtQkFvY2hWaWdFQURzaWJrb1V4?=
 =?utf-8?B?ZFNiV1AyTS9lMndhTERlZ2RRN0diYXcvZllPN3FGd0dFa2o2MXFQa0FDR1oz?=
 =?utf-8?B?MkROdEZLUklabG1YNTBuZ2tVVkp0UXZKdjhhRzRkR2xxcGVjWk9mdDdSQjZM?=
 =?utf-8?B?cHJMNlY4TWkzSlVvUlBpRS9WR1Z6T3V0dE8yQ3VBMnNSbWZMN1gzUG1NV0Fm?=
 =?utf-8?B?VE1jc2JUTDlLUCt2Ulk5TkZIQXNOMmNjWUZzdSs0bjI4WFhzaFlpZHFTOEN3?=
 =?utf-8?B?c05oeTNuNlhneFpjRWFmMXU4Uk8yU1VESTRLdVVGK1B4YmZFQ2JHRzdoWURQ?=
 =?utf-8?B?Q1VaSG5aMjdnd3NMTjBIcUY5YXRFTmtNa1pBaTR6aFFsVUNDRFNWUWwvUVVx?=
 =?utf-8?B?Rll0Y3JkWVFaMVpBcnI4WlgzdVFRcjBnQXNjcFRlNmlRdVpaSG01UFZzU3hE?=
 =?utf-8?B?THdiNTNPMjRrQjFkZGU5dEJXdTc3a1JNZWtpOGpjakYvVm9nN1l3Rkp6ZlZ2?=
 =?utf-8?B?UmFQTjVpNTdqM3dsSVlMcy95VmQ5Z051R1BoWmwrZGk2Tm5adncyZmQ4SG5C?=
 =?utf-8?Q?GeC2fVDQX9FP4p9tXBtf/zY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	9nBuTN5EcGxvWLC7GnoNQF1yIl90FkPjskSg+zBecG7SBth3ww2X+bNan8Db7fAucfDW2tot9nPbtBs/7eOzonQVkAURfmEvPE6U/GT6wCjs9/JaTuxPQbMAUgaAFbLe5ZzUuJbvc0ImjfDtZ6T3SDtEmauRLiRAD2L5/uk5OeBnsZWqYtqZ5o2CTbi2TTVrDxCJHSfaFaYDe+tgVr1Q8M2xb7qfuaDygaZrLwDtags6ksYYtyaSUdhM/baFkHRNTbk/TK1XRvKUrZUsCt5xITxAz9HBgjMskKTZonE+NyerOqJmuHvCA9vQU+MnRi+9DZL6jDd+WgPFONdjdEmMAekE98cjW4SgZStJ3et1SQOXLBGgwMo40gCBxOMGLtmjwy242HGIQKZKcyDLaQOt/MUtaLgKfm9KXzpjkH+UkjbfxrY63ju9vsg111bvrXotxhHL/gJfVNMsqRE9J0GFpNTs8BI1i8ymuTu1MY8YXQ6OXSy+UNawQwbzQtrygSsyySH8WceVYX485NAFwMv549UL/aqNyxKkJunEOMempqAE1uCMFjnpar2U+UuxQsdXQ+99egXS8o/VOyTzqWmoygLGvB8grzzbRtFR/kCgaok=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d79b5605-8955-494e-14f6-08dca12e1f75
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 22:17:44.9750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E3s0wYhpltnZ0cYKZ1dJBSSeHuti8cXxWfcATNjCyCpYYl7DuPt2xKr4xG3XWoQC/e0opoI+6AS7+JFmOR/zHvahkMW6nRj7Lj3K2EOFvX8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6917
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_15,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407100159
X-Proofpoint-GUID: IGH_c3ohRUfZb59m7cVrDipwKjXRwIaN
X-Proofpoint-ORIG-GUID: IGH_c3ohRUfZb59m7cVrDipwKjXRwIaN

On 7/10/24 10:10 AM, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> For fabric scan, current code uses switch scan opcode and flags as the
> method to iterate through different commands to carry out the process.
> This makes it hard to read. This patch convert those opcode and flags
> into steps. In addition, this help reduce some duplicate code.
> 
> Consolidate routines that handle GPNFT & GNNFT.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  |  14 +-
>   drivers/scsi/qla2xxx/qla_gbl.h  |   6 +-
>   drivers/scsi/qla2xxx/qla_gs.c   | 432 +++++++++++++-------------------
>   drivers/scsi/qla2xxx/qla_init.c |   5 +-
>   drivers/scsi/qla2xxx/qla_os.c   |  12 +-
>   5 files changed, 200 insertions(+), 269 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index ba134f6237b8..7cf998e3cc68 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3309,11 +3309,20 @@ struct fab_scan_rp {
>   	u8 node_name[8];
>   };
>   
> +enum scan_step {
> +	FAB_SCAN_START,
> +	FAB_SCAN_GPNFT_FCP,
> +	FAB_SCAN_GNNFT_FCP,
> +	FAB_SCAN_GPNFT_NVME,
> +	FAB_SCAN_GNNFT_NVME,
> +};
> +
>   struct fab_scan {
>   	struct fab_scan_rp *l;
>   	u32 size;
>   	u32 rscn_gen_start;
>   	u32 rscn_gen_end;
> +	enum scan_step step;
>   	u16 scan_retry;
>   #define MAX_SCAN_RETRIES 5
>   	enum scan_flags_t scan_flags;
> @@ -3539,9 +3548,8 @@ enum qla_work_type {
>   	QLA_EVT_RELOGIN,
>   	QLA_EVT_ASYNC_PRLO,
>   	QLA_EVT_ASYNC_PRLO_DONE,
> -	QLA_EVT_GPNFT,
> -	QLA_EVT_GPNFT_DONE,
> -	QLA_EVT_GNNFT_DONE,
> +	QLA_EVT_SCAN_CMD,
> +	QLA_EVT_SCAN_FINISH,
>   	QLA_EVT_GFPNID,
>   	QLA_EVT_SP_RETRY,
>   	QLA_EVT_IIDMA,
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index 7309310d2ab9..cededfda9d0e 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -728,9 +728,9 @@ int qla24xx_async_gpsc(scsi_qla_host_t *, fc_port_t *);
>   void qla24xx_handle_gpsc_event(scsi_qla_host_t *, struct event_arg *);
>   int qla2x00_mgmt_svr_login(scsi_qla_host_t *);
>   int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport, bool);
> -int qla24xx_async_gpnft(scsi_qla_host_t *, u8, srb_t *);
> -void qla24xx_async_gpnft_done(scsi_qla_host_t *, srb_t *);
> -void qla24xx_async_gnnft_done(scsi_qla_host_t *, srb_t *);
> +int qla_fab_async_scan(scsi_qla_host_t *, srb_t *);
> +void qla_fab_scan_start(struct scsi_qla_host *);
> +void qla_fab_scan_finish(scsi_qla_host_t *, srb_t *);
>   int qla24xx_post_gfpnid_work(struct scsi_qla_host *, fc_port_t *);
>   int qla24xx_async_gfpnid(scsi_qla_host_t *, fc_port_t *);
>   void qla24xx_handle_gfpnid_event(scsi_qla_host_t *, struct event_arg *);
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
> index caa9a3cd2580..d2bddca7045a 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3191,7 +3191,7 @@ static bool qla_ok_to_clear_rscn(scsi_qla_host_t *vha, fc_port_t *fcport)
>   	return true;
>   }
>   
> -void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
> +void qla_fab_scan_finish(scsi_qla_host_t *vha, srb_t *sp)
>   {
>   	fc_port_t *fcport;
>   	u32 i, rc;
> @@ -3406,14 +3406,11 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
>   	}
>   }
>   
> -static int qla2x00_post_gnnft_gpnft_done_work(struct scsi_qla_host *vha,
> +static int qla2x00_post_next_scan_work(struct scsi_qla_host *vha,
>       srb_t *sp, int cmd)
>   {
>   	struct qla_work_evt *e;
>   
> -	if (cmd != QLA_EVT_GPNFT_DONE && cmd != QLA_EVT_GNNFT_DONE)
> -		return QLA_PARAMETER_ERROR;
> -
>   	e = qla2x00_alloc_work(vha, cmd);
>   	if (!e)
>   		return QLA_FUNCTION_FAILED;
> @@ -3423,37 +3420,15 @@ static int qla2x00_post_gnnft_gpnft_done_work(struct scsi_qla_host *vha,
>   	return qla2x00_post_work(vha, e);
>   }
>   
> -static int qla2x00_post_nvme_gpnft_work(struct scsi_qla_host *vha,
> -    srb_t *sp, int cmd)
> -{
> -	struct qla_work_evt *e;
> -
> -	if (cmd != QLA_EVT_GPNFT)
> -		return QLA_PARAMETER_ERROR;
> -
> -	e = qla2x00_alloc_work(vha, cmd);
> -	if (!e)
> -		return QLA_FUNCTION_FAILED;
> -
> -	e->u.gpnft.fc4_type = FC4_TYPE_NVME;
> -	e->u.gpnft.sp = sp;
> -
> -	return qla2x00_post_work(vha, e);
> -}
> -
>   static void qla2x00_find_free_fcp_nvme_slot(struct scsi_qla_host *vha,
>   	struct srb *sp)
>   {
>   	struct qla_hw_data *ha = vha->hw;
>   	int num_fibre_dev = ha->max_fibre_devices;
> -	struct ct_sns_req *ct_req =
> -		(struct ct_sns_req *)sp->u.iocb_cmd.u.ctarg.req;
>   	struct ct_sns_gpnft_rsp *ct_rsp =
>   		(struct ct_sns_gpnft_rsp *)sp->u.iocb_cmd.u.ctarg.rsp;
>   	struct ct_sns_gpn_ft_data *d;
>   	struct fab_scan_rp *rp;
> -	u16 cmd = be16_to_cpu(ct_req->command);
> -	u8 fc4_type = sp->gen2;
>   	int i, j, k;
>   	port_id_t id;
>   	u8 found;
> @@ -3472,85 +3447,83 @@ static void qla2x00_find_free_fcp_nvme_slot(struct scsi_qla_host *vha,
>   		if (id.b24 == 0 || wwn == 0)
>   			continue;
>   
> -		if (fc4_type == FC4_TYPE_FCP_SCSI) {
> -			if (cmd == GPN_FT_CMD) {
> -				rp = &vha->scan.l[j];
> -				rp->id = id;
> -				memcpy(rp->port_name, d->port_name, 8);
> -				j++;
> -				rp->fc4type = FS_FC4TYPE_FCP;
> -			} else {
> -				for (k = 0; k < num_fibre_dev; k++) {
> -					rp = &vha->scan.l[k];
> -					if (id.b24 == rp->id.b24) {
> -						memcpy(rp->node_name,
> -						    d->port_name, 8);
> -						break;
> -					}
> +		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x2025,
> +		       "%s %06x %8ph \n",
> +		       __func__, id.b24, d->port_name);
> +
> +		switch (vha->scan.step) {
> +		case FAB_SCAN_GPNFT_FCP:
> +			rp = &vha->scan.l[j];
> +			rp->id = id;
> +			memcpy(rp->port_name, d->port_name, 8);
> +			j++;
> +			rp->fc4type = FS_FC4TYPE_FCP;
> +			break;
> +		case FAB_SCAN_GNNFT_FCP:
> +			for (k = 0; k < num_fibre_dev; k++) {
> +				rp = &vha->scan.l[k];
> +				if (id.b24 == rp->id.b24) {
> +					memcpy(rp->node_name,
> +					    d->port_name, 8);
> +					break;
>   				}
>   			}
> -		} else {
> -			/* Search if the fibre device supports FC4_TYPE_NVME */
> -			if (cmd == GPN_FT_CMD) {
> -				found = 0;
> -
> -				for (k = 0; k < num_fibre_dev; k++) {
> -					rp = &vha->scan.l[k];
> -					if (!memcmp(rp->port_name,
> -					    d->port_name, 8)) {
> -						/*
> -						 * Supports FC-NVMe & FCP
> -						 */
> -						rp->fc4type |= FS_FC4TYPE_NVME;
> -						found = 1;
> -						break;
> -					}
> +			break;
> +		case FAB_SCAN_GPNFT_NVME:
> +			found = 0;
> +
> +			for (k = 0; k < num_fibre_dev; k++) {
> +				rp = &vha->scan.l[k];
> +				if (!memcmp(rp->port_name, d->port_name, 8)) {
> +					/*
> +					 * Supports FC-NVMe & FCP
> +					 */
> +					rp->fc4type |= FS_FC4TYPE_NVME;
> +					found = 1;
> +					break;
>   				}
> +			}
>   
> -				/* We found new FC-NVMe only port */
> -				if (!found) {
> -					for (k = 0; k < num_fibre_dev; k++) {
> -						rp = &vha->scan.l[k];
> -						if (wwn_to_u64(rp->port_name)) {
> -							continue;
> -						} else {
> -							rp->id = id;
> -							memcpy(rp->port_name,
> -							    d->port_name, 8);
> -							rp->fc4type =
> -							    FS_FC4TYPE_NVME;
> -							break;
> -						}
> -					}
> -				}
> -			} else {
> +			/* We found new FC-NVMe only port */
> +			if (!found) {
>   				for (k = 0; k < num_fibre_dev; k++) {
>   					rp = &vha->scan.l[k];
> -					if (id.b24 == rp->id.b24) {
> -						memcpy(rp->node_name,
> -						    d->port_name, 8);
> +					if (wwn_to_u64(rp->port_name)) {
> +						continue;
> +					} else {
> +						rp->id = id;
> +						memcpy(rp->port_name, d->port_name, 8);
> +						rp->fc4type = FS_FC4TYPE_NVME;
>   						break;
>   					}
>   				}
>   			}
> +			break;
> +		case FAB_SCAN_GNNFT_NVME:
> +			for (k = 0; k < num_fibre_dev; k++) {
> +				rp = &vha->scan.l[k];
> +				if (id.b24 == rp->id.b24) {
> +					memcpy(rp->node_name, d->port_name, 8);
> +					break;
> +				}
> +			}
> +			break;
> +		default:
> +			break;
>   		}
>   	}
>   }
>   
> -static void qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
> +static void qla_async_scan_sp_done(srb_t *sp, int res)
>   {
>   	struct scsi_qla_host *vha = sp->vha;
> -	struct ct_sns_req *ct_req =
> -		(struct ct_sns_req *)sp->u.iocb_cmd.u.ctarg.req;
> -	u16 cmd = be16_to_cpu(ct_req->command);
> -	u8 fc4_type = sp->gen2;
>   	unsigned long flags;
>   	int rc;
>   
>   	/* gen2 field is holding the fc4type */
> -	ql_dbg(ql_dbg_disc, vha, 0xffff,
> -	    "Async done-%s res %x FC4Type %x\n",
> -	    sp->name, res, sp->gen2);
> +	ql_dbg(ql_dbg_disc, vha, 0x2026,
> +	    "Async done-%s res %x step %x\n",
> +	    sp->name, res, vha->scan.step);
>   
>   	sp->rc = res;
>   	if (res) {
> @@ -3574,8 +3547,7 @@ static void qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
>   		 * sp for GNNFT_DONE work. This will allow all
>   		 * the resource to get freed up.
>   		 */
> -		rc = qla2x00_post_gnnft_gpnft_done_work(vha, sp,
> -		    QLA_EVT_GNNFT_DONE);
> +		rc = qla2x00_post_next_scan_work(vha, sp, QLA_EVT_SCAN_FINISH);
>   		if (rc) {
>   			/* Cleanup here to prevent memory leak */
>   			qla24xx_sp_unmap(vha, sp);
> @@ -3600,28 +3572,30 @@ static void qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
>   
>   	qla2x00_find_free_fcp_nvme_slot(vha, sp);
>   
> -	if ((fc4_type == FC4_TYPE_FCP_SCSI) && vha->flags.nvme_enabled &&
> -	    cmd == GNN_FT_CMD) {
> -		spin_lock_irqsave(&vha->work_lock, flags);
> -		vha->scan.scan_flags &= ~SF_SCANNING;
> -		spin_unlock_irqrestore(&vha->work_lock, flags);
> +	spin_lock_irqsave(&vha->work_lock, flags);
> +	vha->scan.scan_flags &= ~SF_SCANNING;
> +	spin_unlock_irqrestore(&vha->work_lock, flags);
>   
> -		sp->rc = res;
> -		rc = qla2x00_post_nvme_gpnft_work(vha, sp, QLA_EVT_GPNFT);
> -		if (rc) {
> -			qla24xx_sp_unmap(vha, sp);
> -			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
> -			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
> -		}
> -		return;
> -	}
> +	switch (vha->scan.step) {
> +	case FAB_SCAN_GPNFT_FCP:
> +	case FAB_SCAN_GPNFT_NVME:
> +		rc = qla2x00_post_next_scan_work(vha, sp, QLA_EVT_SCAN_CMD);
> +		break;
> +	case  FAB_SCAN_GNNFT_FCP:
> +		if (vha->flags.nvme_enabled)
> +			rc = qla2x00_post_next_scan_work(vha, sp, QLA_EVT_SCAN_CMD);
> +		else
> +			rc = qla2x00_post_next_scan_work(vha, sp, QLA_EVT_SCAN_FINISH);
>   
> -	if (cmd == GPN_FT_CMD) {
> -		rc = qla2x00_post_gnnft_gpnft_done_work(vha, sp,
> -		    QLA_EVT_GPNFT_DONE);
> -	} else {
> -		rc = qla2x00_post_gnnft_gpnft_done_work(vha, sp,
> -		    QLA_EVT_GNNFT_DONE);
> +		break;
> +	case  FAB_SCAN_GNNFT_NVME:
> +		rc = qla2x00_post_next_scan_work(vha, sp, QLA_EVT_SCAN_FINISH);
> +		break;
> +	default:
> +		/* should not be here */
> +		WARN_ON(1);
> +		rc = QLA_FUNCTION_FAILED;
> +		break;
>   	}
>   
>   	if (rc) {
> @@ -3632,127 +3606,16 @@ static void qla2x00_async_gpnft_gnnft_sp_done(srb_t *sp, int res)
>   	}
>   }
>   
> -/*
> - * Get WWNN list for fc4_type
> - *
> - * It is assumed the same SRB is re-used from GPNFT to avoid
> - * mem free & re-alloc
> - */
> -static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
> -    u8 fc4_type)
> -{
> -	int rval = QLA_FUNCTION_FAILED;
> -	struct ct_sns_req *ct_req;
> -	struct ct_sns_pkt *ct_sns;
> -	unsigned long flags;
> -
> -	if (!vha->flags.online) {
> -		spin_lock_irqsave(&vha->work_lock, flags);
> -		vha->scan.scan_flags &= ~SF_SCANNING;
> -		spin_unlock_irqrestore(&vha->work_lock, flags);
> -		goto done_free_sp;
> -	}
> -
> -	if (!sp->u.iocb_cmd.u.ctarg.req || !sp->u.iocb_cmd.u.ctarg.rsp) {
> -		ql_log(ql_log_warn, vha, 0xffff,
> -		    "%s: req %p rsp %p are not setup\n",
> -		    __func__, sp->u.iocb_cmd.u.ctarg.req,
> -		    sp->u.iocb_cmd.u.ctarg.rsp);
> -		spin_lock_irqsave(&vha->work_lock, flags);
> -		vha->scan.scan_flags &= ~SF_SCANNING;
> -		spin_unlock_irqrestore(&vha->work_lock, flags);
> -		WARN_ON(1);
> -		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
> -		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
> -		goto done_free_sp;
> -	}
> -
> -	ql_dbg(ql_dbg_disc, vha, 0xfffff,
> -	    "%s: FC4Type %x, CT-PASSTHRU %s command ctarg rsp size %d, ctarg req size %d\n",
> -	    __func__, fc4_type, sp->name, sp->u.iocb_cmd.u.ctarg.rsp_size,
> -	     sp->u.iocb_cmd.u.ctarg.req_size);
> -
> -	sp->type = SRB_CT_PTHRU_CMD;
> -	sp->name = "gnnft";
> -	sp->gen1 = vha->hw->base_qpair->chip_reset;
> -	sp->gen2 = fc4_type;
> -	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> -			      qla2x00_async_gpnft_gnnft_sp_done);
> -
> -	memset(sp->u.iocb_cmd.u.ctarg.rsp, 0, sp->u.iocb_cmd.u.ctarg.rsp_size);
> -	memset(sp->u.iocb_cmd.u.ctarg.req, 0, sp->u.iocb_cmd.u.ctarg.req_size);
> -
> -	ct_sns = (struct ct_sns_pkt *)sp->u.iocb_cmd.u.ctarg.req;
> -	/* CT_IU preamble  */
> -	ct_req = qla2x00_prep_ct_req(ct_sns, GNN_FT_CMD,
> -	    sp->u.iocb_cmd.u.ctarg.rsp_size);
> -
> -	/* GPN_FT req */
> -	ct_req->req.gpn_ft.port_type = fc4_type;
> -
> -	sp->u.iocb_cmd.u.ctarg.req_size = GNN_FT_REQ_SIZE;
> -	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
> -
> -	ql_dbg(ql_dbg_disc, vha, 0xffff,
> -	    "Async-%s hdl=%x FC4Type %x.\n", sp->name,
> -	    sp->handle, ct_req->req.gpn_ft.port_type);
> -
> -	rval = qla2x00_start_sp(sp);
> -	if (rval != QLA_SUCCESS) {
> -		goto done_free_sp;
> -	}
> -
> -	return rval;
> -
> -done_free_sp:
> -	if (sp->u.iocb_cmd.u.ctarg.req) {
> -		dma_free_coherent(&vha->hw->pdev->dev,
> -		    sp->u.iocb_cmd.u.ctarg.req_allocated_size,
> -		    sp->u.iocb_cmd.u.ctarg.req,
> -		    sp->u.iocb_cmd.u.ctarg.req_dma);
> -		sp->u.iocb_cmd.u.ctarg.req = NULL;
> -	}
> -	if (sp->u.iocb_cmd.u.ctarg.rsp) {
> -		dma_free_coherent(&vha->hw->pdev->dev,
> -		    sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
> -		    sp->u.iocb_cmd.u.ctarg.rsp,
> -		    sp->u.iocb_cmd.u.ctarg.rsp_dma);
> -		sp->u.iocb_cmd.u.ctarg.rsp = NULL;
> -	}
> -	/* ref: INIT */
> -	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -
> -	spin_lock_irqsave(&vha->work_lock, flags);
> -	vha->scan.scan_flags &= ~SF_SCANNING;
> -	if (vha->scan.scan_flags == 0) {
> -		ql_dbg(ql_dbg_disc, vha, 0xffff,
> -		    "%s: schedule\n", __func__);
> -		vha->scan.scan_flags |= SF_QUEUED;
> -		schedule_delayed_work(&vha->scan.scan_work, 5);
> -	}
> -	spin_unlock_irqrestore(&vha->work_lock, flags);
> -
> -
> -	return rval;
> -} /* GNNFT */
> -
> -void qla24xx_async_gpnft_done(scsi_qla_host_t *vha, srb_t *sp)
> -{
> -	ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
> -	    "%s enter\n", __func__);
> -	qla24xx_async_gnnft(vha, sp, sp->gen2);
> -}
> -
>   /* Get WWPN list for certain fc4_type */
> -int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
> +int qla_fab_async_scan(scsi_qla_host_t *vha, srb_t *sp)
>   {
>   	int rval = QLA_FUNCTION_FAILED;
>   	struct ct_sns_req       *ct_req;
>   	struct ct_sns_pkt *ct_sns;
> -	u32 rspsz;
> +	u32 rspsz = 0;
>   	unsigned long flags;
>   
> -	ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
> +	ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x200c,
>   	    "%s enter\n", __func__);
>   
>   	if (!vha->flags.online)
> @@ -3761,22 +3624,21 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
>   	spin_lock_irqsave(&vha->work_lock, flags);
>   	if (vha->scan.scan_flags & SF_SCANNING) {
>   		spin_unlock_irqrestore(&vha->work_lock, flags);
> -		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
> +		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x2012,
>   		    "%s: scan active\n", __func__);
>   		return rval;
>   	}
>   	vha->scan.scan_flags |= SF_SCANNING;
> +	if (!sp)
> +		vha->scan.step = FAB_SCAN_START;
> +
>   	spin_unlock_irqrestore(&vha->work_lock, flags);
>   
> -	if (fc4_type == FC4_TYPE_FCP_SCSI) {
> -		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
> +	switch (vha->scan.step) {
> +	case FAB_SCAN_START:
> +		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x2018,
>   		    "%s: Performing FCP Scan\n", __func__);
>   
> -		if (sp) {
> -			/* ref: INIT */
> -			kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -		}
> -
>   		/* ref: INIT */
>   		sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
>   		if (!sp) {
> @@ -3792,7 +3654,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
>   								GFP_KERNEL);
>   		sp->u.iocb_cmd.u.ctarg.req_allocated_size = sizeof(struct ct_sns_pkt);
>   		if (!sp->u.iocb_cmd.u.ctarg.req) {
> -			ql_log(ql_log_warn, vha, 0xffff,
> +			ql_log(ql_log_warn, vha, 0x201a,
>   			    "Failed to allocate ct_sns request.\n");
>   			spin_lock_irqsave(&vha->work_lock, flags);
>   			vha->scan.scan_flags &= ~SF_SCANNING;
> @@ -3800,7 +3662,6 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
>   			qla2x00_rel_sp(sp);
>   			return rval;
>   		}
> -		sp->u.iocb_cmd.u.ctarg.req_size = GPN_FT_REQ_SIZE;
>   
>   		rspsz = sizeof(struct ct_sns_gpnft_rsp) +
>   			vha->hw->max_fibre_devices *
> @@ -3812,7 +3673,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
>   								GFP_KERNEL);
>   		sp->u.iocb_cmd.u.ctarg.rsp_allocated_size = rspsz;
>   		if (!sp->u.iocb_cmd.u.ctarg.rsp) {
> -			ql_log(ql_log_warn, vha, 0xffff,
> +			ql_log(ql_log_warn, vha, 0x201b,
>   			    "Failed to allocate ct_sns request.\n");
>   			spin_lock_irqsave(&vha->work_lock, flags);
>   			vha->scan.scan_flags &= ~SF_SCANNING;
> @@ -3832,35 +3693,95 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
>   		    "%s scan list size %d\n", __func__, vha->scan.size);
>   
>   		memset(vha->scan.l, 0, vha->scan.size);
> -	} else if (!sp) {
> -		ql_dbg(ql_dbg_disc, vha, 0xffff,
> -		    "NVME scan did not provide SP\n");
> +
> +		vha->scan.step = FAB_SCAN_GPNFT_FCP;
> +		break;
> +	case FAB_SCAN_GPNFT_FCP:
> +		vha->scan.step = FAB_SCAN_GNNFT_FCP;
> +		break;
> +	case FAB_SCAN_GNNFT_FCP:
> +		vha->scan.step = FAB_SCAN_GPNFT_NVME;
> +		break;
> +	case FAB_SCAN_GPNFT_NVME:
> +		vha->scan.step = FAB_SCAN_GNNFT_NVME;
> +		break;
> +	case FAB_SCAN_GNNFT_NVME:
> +	default:
> +		/* should not be here */
> +		WARN_ON(1);
> +		goto done_free_sp;
> +	}
> +
> +	if (!sp) {
> +		ql_dbg(ql_dbg_disc, vha, 0x201c,
> +		    "scan did not provide SP\n");
>   		return rval;
>   	}
> +	if (!sp->u.iocb_cmd.u.ctarg.req || !sp->u.iocb_cmd.u.ctarg.rsp) {
> +		ql_log(ql_log_warn, vha, 0x201d,
> +		    "%s: req %p rsp %p are not setup\n",
> +		    __func__, sp->u.iocb_cmd.u.ctarg.req,
> +		    sp->u.iocb_cmd.u.ctarg.rsp);
> +		spin_lock_irqsave(&vha->work_lock, flags);
> +		vha->scan.scan_flags &= ~SF_SCANNING;
> +		spin_unlock_irqrestore(&vha->work_lock, flags);
> +		WARN_ON(1);
> +		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
> +		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
> +		goto done_free_sp;
> +	}
> +
> +	rspsz = sp->u.iocb_cmd.u.ctarg.rsp_size;
> +	memset(sp->u.iocb_cmd.u.ctarg.req, 0, sp->u.iocb_cmd.u.ctarg.req_size);
> +	memset(sp->u.iocb_cmd.u.ctarg.rsp, 0, sp->u.iocb_cmd.u.ctarg.rsp_size);
> +
>   
>   	sp->type = SRB_CT_PTHRU_CMD;
> -	sp->name = "gpnft";
>   	sp->gen1 = vha->hw->base_qpair->chip_reset;
> -	sp->gen2 = fc4_type;
>   	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> -			      qla2x00_async_gpnft_gnnft_sp_done);
> -
> -	rspsz = sp->u.iocb_cmd.u.ctarg.rsp_size;
> -	memset(sp->u.iocb_cmd.u.ctarg.rsp, 0, sp->u.iocb_cmd.u.ctarg.rsp_size);
> -	memset(sp->u.iocb_cmd.u.ctarg.req, 0, sp->u.iocb_cmd.u.ctarg.req_size);
> +			      qla_async_scan_sp_done);
>   
>   	ct_sns = (struct ct_sns_pkt *)sp->u.iocb_cmd.u.ctarg.req;
> -	/* CT_IU preamble  */
> -	ct_req = qla2x00_prep_ct_req(ct_sns, GPN_FT_CMD, rspsz);
>   
> -	/* GPN_FT req */
> -	ct_req->req.gpn_ft.port_type = fc4_type;
> +	/* CT_IU preamble  */
> +	switch (vha->scan.step) {
> +	case FAB_SCAN_GPNFT_FCP:
> +		sp->name = "gpnft";
> +		ct_req = qla2x00_prep_ct_req(ct_sns, GPN_FT_CMD, rspsz);
> +		ct_req->req.gpn_ft.port_type = FC4_TYPE_FCP_SCSI;
> +		sp->u.iocb_cmd.u.ctarg.req_size = GPN_FT_REQ_SIZE;
> +		break;
> +	case FAB_SCAN_GNNFT_FCP:
> +		sp->name = "gnnft";
> +		ct_req = qla2x00_prep_ct_req(ct_sns, GNN_FT_CMD, rspsz);
> +		ct_req->req.gpn_ft.port_type = FC4_TYPE_FCP_SCSI;
> +		sp->u.iocb_cmd.u.ctarg.req_size = GNN_FT_REQ_SIZE;
> +		break;
> +	case FAB_SCAN_GPNFT_NVME:
> +		sp->name = "gpnft";
> +		ct_req = qla2x00_prep_ct_req(ct_sns, GPN_FT_CMD, rspsz);
> +		ct_req->req.gpn_ft.port_type = FC4_TYPE_NVME;
> +		sp->u.iocb_cmd.u.ctarg.req_size = GPN_FT_REQ_SIZE;
> +		break;
> +	case FAB_SCAN_GNNFT_NVME:
> +		sp->name = "gnnft";
> +		ct_req = qla2x00_prep_ct_req(ct_sns, GNN_FT_CMD, rspsz);
> +		ct_req->req.gpn_ft.port_type = FC4_TYPE_NVME;
> +		sp->u.iocb_cmd.u.ctarg.req_size = GNN_FT_REQ_SIZE;
> +		break;
> +	default:
> +		/* should not be here */
> +		WARN_ON(1);
> +		goto done_free_sp;
> +	}
>   
>   	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
>   
> -	ql_dbg(ql_dbg_disc, vha, 0xffff,
> -	    "Async-%s hdl=%x FC4Type %x.\n", sp->name,
> -	    sp->handle, ct_req->req.gpn_ft.port_type);
> +	ql_dbg(ql_dbg_disc, vha, 0x2003,
> +	       "%s: step %d, rsp size %d, req size %d hdl %x %s FC4TYPE %x \n",
> +	       __func__, vha->scan.step, sp->u.iocb_cmd.u.ctarg.rsp_size,
> +	       sp->u.iocb_cmd.u.ctarg.req_size, sp->handle, sp->name,
> +	       ct_req->req.gpn_ft.port_type);
>   
>   	rval = qla2x00_start_sp(sp);
>   	if (rval != QLA_SUCCESS) {
> @@ -3891,7 +3812,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
>   	spin_lock_irqsave(&vha->work_lock, flags);
>   	vha->scan.scan_flags &= ~SF_SCANNING;
>   	if (vha->scan.scan_flags == 0) {
> -		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0xffff,
> +		ql_dbg(ql_dbg_disc + ql_dbg_verbose, vha, 0x2007,
>   		    "%s: Scan scheduled.\n", __func__);
>   		vha->scan.scan_flags |= SF_QUEUED;
>   		schedule_delayed_work(&vha->scan.scan_work, 5);
> @@ -3902,6 +3823,15 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type, srb_t *sp)
>   	return rval;
>   }
>   
> +void qla_fab_scan_start(struct scsi_qla_host *vha)
> +{
> +	int rval;
> +
> +	rval = qla_fab_async_scan(vha, NULL);
> +	if (rval)
> +		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
> +}
> +
>   void qla_scan_work_fn(struct work_struct *work)
>   {
>   	struct fab_scan *s = container_of(to_delayed_work(work),
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 5ff017546540..eda3bdab934d 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -6407,10 +6407,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
>   		if (USE_ASYNC_SCAN(ha)) {
>   			/* start of scan begins here */
>   			vha->scan.rscn_gen_end = atomic_read(&vha->rscn_gen);
> -			rval = qla24xx_async_gpnft(vha, FC4_TYPE_FCP_SCSI,
> -			    NULL);
> -			if (rval)
> -				set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
> +			qla_fab_scan_start(vha);
>   		} else  {
>   			list_for_each_entry(fcport, &vha->vp_fcports, list)
>   				fcport->scan_state = QLA_FCPORT_SCAN;
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index e4056cddb727..bc3b2aea3f8b 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -5558,15 +5558,11 @@ qla2x00_do_work(struct scsi_qla_host *vha)
>   			qla2x00_async_prlo_done(vha, e->u.logio.fcport,
>   			    e->u.logio.data);
>   			break;
> -		case QLA_EVT_GPNFT:
> -			qla24xx_async_gpnft(vha, e->u.gpnft.fc4_type,
> -			    e->u.gpnft.sp);
> +		case QLA_EVT_SCAN_CMD:
> +			qla_fab_async_scan(vha, e->u.iosb.sp);
>   			break;
> -		case QLA_EVT_GPNFT_DONE:
> -			qla24xx_async_gpnft_done(vha, e->u.iosb.sp);
> -			break;
> -		case QLA_EVT_GNNFT_DONE:
> -			qla24xx_async_gnnft_done(vha, e->u.iosb.sp);
> +		case QLA_EVT_SCAN_FINISH:
> +			qla_fab_scan_finish(vha, e->u.iosb.sp);
>   			break;
>   		case QLA_EVT_GFPNID:
>   			qla24xx_async_gfpnid(vha, e->u.fcport.fcport);

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

