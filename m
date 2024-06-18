Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DFF14A4C8;
	Tue, 18 Jun 2024 12:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718712562; cv=fail; b=PV0FhvrkC4ky3G77zqWv8mGqhOTM9Dffqdr1Zuv9QlNUWBRVuypf1BXStY+GK8+LwD1DR0fnqRoBoRC+YsaiRMBpUQXbWfe3if9Kk2dojCgflDWewLorebWaVNSTwSKfLmMZmOWsTLYrc2jQr0z935VJMEFvvitkGZQlUPXzKHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718712562; c=relaxed/simple;
	bh=YupEkzwBp269ZQGPB+3sFmtOeYjpa7UrqocS5BxjGeg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D9Dcodarcbc4getQEyXcoL9f6UiBogXhepA2cLQDiMJOC1/+zmjWxgTKDoOp62O9FyEsWYMNcCfhbqhQrNL0NkKM0oCsHsEZh2Dx1pYdP2C476l/xBuS+yUB0kgPND8vW3IBeyGzyhndBidP1Zkur8AVvM4OG56wy6tBVTZcaLg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fqXvo9bp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=reBbHIHv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fqXvo9bp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="reBbHIHv"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45I7tPGB031956;
	Tue, 18 Jun 2024 12:09:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=+dR9ZWO5BeS3xvo6q0JQHxNY2kT/pYeHYjM/5a6/4CM=; b=
	fqXvo9bpwKGwjsMud83KNXYV6T608gIeaYjDH/jl8CtChOg6LcWZb+skYpE5IX2L
	Tp1UtRTGI072ZqHJ1yYJmowOJvulV+F9KQCmAZy+3p2p9IkIr9kV5JlG5zhbzb/W
	D8O5Q5jdAaL7Wi+9wfvRuAXiKs0lZ6+wi0OktRDAUpUbs7Jt+/+kRvlvSAwl8e/T
	bR/SemgkOa1ovDw9Ptk2aeSj2uAZsSCPmSZJV1qWF8C8n6n2K8DnhhRLYPABgwC2
	rdBxiYlwLwVeN6Ljy9wdoYuN/82RS/QDbPUb+96h8KehQ6wxri3wiyVdQw0bjjq6
	oG//iYtpD7DIaBX8Q6WpDg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ys30bmrcy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 12:09:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45IBNd5O034477;
	Tue, 18 Jun 2024 12:08:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1de98bt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Jun 2024 12:08:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axFl1+1ksd2zgplGdl76t1bNljiDFkubst6jUV9TbBMwBU79lBH6E4XoZVA4bBWSnRUwHyImM9F1EB0PL6QbUetThMAKTUgRSq2M1x/ns8wCdjFeI4epjhDfPQhDCAYPjsLbWn5JqrwqjOTtu/BddiSj5gny9zkFxQT3fUz6GK7sEyFnT66GctRTDhWO0yGVBdmTmd1EnY9MrM9oEaCBUoGQ3EnNSvmy2HKcfMqXopg4j2i3m/YnGJ/D5v+9hCYEKU1gRqUZiFAtHyfsN95kD63ZDeTP2xBdFyWg8gvIgDcAKc8GcIEplnMx+sXYJqTn5MyCxtJJOEQJ3UcWh1m/OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+dR9ZWO5BeS3xvo6q0JQHxNY2kT/pYeHYjM/5a6/4CM=;
 b=X1AMeL3dqpx9Z8O9/101RUTgCzBNKSkf1qpdHNBSuKc7BT3FQXGcfzIwn0dg2qVEbW6rrDDvcNtUSK2v2JGi8hh9He5fjFsm1JLCAe53H58D6DntGy4ya4goRY+57qWLjrWZ9FZAQcf0+EWaAJQ1KQZra8UgzVU0gBeA0FZX6Z8ew3URsGokHudgui4uQwbxIC9c3M9YrtKCOg35Bcf9XDIieHqJKfTY9ETikqfAzLW9mplakzMrNPaQXRzRaHzx+WLTCA/i197rLHBL88FEGRs2rj1IYyhVfHyMu9rEDKahQk1ceQielHXjNh3ed659LYh1IgYzG3ajcWdEZdN/jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dR9ZWO5BeS3xvo6q0JQHxNY2kT/pYeHYjM/5a6/4CM=;
 b=reBbHIHv5DSrqfMt/uqDsQwiVE585KR6jvKlBEj+gTQzqtzjMFPvqgQ+XrHUgHe6JA3qYo/rQUypjPXFnP3/irjczNDL0ipMee6bAukVoIDkVQZp/0k2W3O5uy2oQPh2nwEwYd+UTATKtG9nvgctiLwRNAyktc1/4f74g/yTjy0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SN7PR10MB6452.namprd10.prod.outlook.com (2603:10b6:806:2a3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Tue, 18 Jun
 2024 12:08:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 12:08:57 +0000
Message-ID: <bfc045d4-746e-4555-9e17-5a0be57ac787@oracle.com>
Date: Tue, 18 Jun 2024 13:08:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        damien.lemoal@opensource.wdc.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, prime.zeng@hisilicon.com,
        chenxiang66@hisilicon.com, kangfenglong@huawei.com
References: <20240613122355.7797-1-yangxingui@huawei.com>
 <437c99f4-a67d-48d9-98ee-58cbbc3d19f4@oracle.com>
 <815fcddf-85cc-126e-4be1-618b5ba8f823@huawei.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <815fcddf-85cc-126e-4be1-618b5ba8f823@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0505.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SN7PR10MB6452:EE_
X-MS-Office365-Filtering-Correlation-Id: bb3db300-a391-4060-c787-08dc8f8f6e4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?NlM4djhCSElpa1d4cU1rYmE3TWdGMytQdWZmajFQRnhyTkY2Yk1QeVdsNFhk?=
 =?utf-8?B?MHIzVW1tVVdZRVBuOEhxelkwTVo0ZkxiTHdyYmJFYVZJeWNkOGdFMXdHL3Vv?=
 =?utf-8?B?bXFISlpNWHlid3hMU1RsUWxEYURiQnpoT0VvTDFKSXlhUER0V256NExRd0hJ?=
 =?utf-8?B?cGM5Nmg4bVNzL1hsV2RRamlYNFNYNWJoQi8vcmt0T3kyWWlwMWt6VmxiUE5V?=
 =?utf-8?B?NTNVcmQxRE5GdDJLSWlFQ25XazlyTVJKNjBkaWV0RWdwTDlna0paNjJjNnBk?=
 =?utf-8?B?a0J1SFFvUlRtYjN4b2RSVFNoTlp4NXRNcGlxTHdXTjhkclVVUFhEVHJ2L09Q?=
 =?utf-8?B?UGREMzVCbFkzMkliZjhia0J6U1c3ZTZRWE5ZbzA5Q3M0ZXlnVXRXbVFmd05W?=
 =?utf-8?B?Y1hlZ2RFYU00MzRuUStpZVlaYjZmYWtQQmVyTlcwU2NpRTV1byt6QktINWQz?=
 =?utf-8?B?dE5ZSU8wN0NDSkJrSU1CbHlML0Y3SGYrRlcxbm1ock1SQ3dRcVRVcFUzelg5?=
 =?utf-8?B?L0w5a1RQUUMrMWkzcHZpRkpmOWI0bGcxRnRSMU9aMXJ0MlhERWZIVy8reHB2?=
 =?utf-8?B?blI1VElGaWlVVlFtRzdxWjd6SkgyOG84YVQ4RTd3ZlR1VjdZYnhSdzZzVzQr?=
 =?utf-8?B?YXdzalpBaGR5MTF1Y3MrVjZDUm5wbHo3QURnQUtaNTFWMGpydTZpQ3M2MWxo?=
 =?utf-8?B?eHh4Wk4ySTJqUkVGT1VUMUF4REFyUFBqN1A0c2xXeWZUVW9MSU0yWHBZUU1v?=
 =?utf-8?B?b0QwbjNLUzFJb1dxL3BxbHJBR0UrNE5naHFoOWh6akJOQUlKZW04NEMzY25G?=
 =?utf-8?B?dWtucUpjZ0F6NVNmbk9kdGV5NDh4U1Y5TDBDcVFBb29uOGJ5Vk9lZVRwdlB5?=
 =?utf-8?B?KzZaNlJlMDFMR2Zma1lPRXQyeEpjRGh2ZEl6SWpDVVQ5UVpodlNuTUFPTytk?=
 =?utf-8?B?cFRXTjV5SzJsUDVzUlZNWHhvRHdISnJkeDNoTVAvQVMwNitKVXlsdExIS3lm?=
 =?utf-8?B?UE5iRGp0cUZtSmJ5aUFUb0dkb0wyMThxM0Y3UXQrSVV5SjIxQW02T21yQk95?=
 =?utf-8?B?K0x2UWhqdnUxWXlpcDNJZ1Znb0JTQnpWcGdMV01NWmlpbEczTFE5aUp3N3Rn?=
 =?utf-8?B?RFVsTGtiMlR4M0lDTUpDUjYzcXkxQVBLQTVIS0lMWU1KQWo3RXVlZ2JnSXpK?=
 =?utf-8?B?eXZqdWkxdTVVM21HOVgyOVhROFZaWjNtQkh6KytDZ0hJWE53UkY1OFl0czZk?=
 =?utf-8?B?Q09JTmg4YVlCRkV0UE0xUElzeE41N0xrZkFTaFZDRlpMTnpHS1YzdmlJTGVQ?=
 =?utf-8?B?MHpNcU5LQmxOM0NicXREUVlrRTVEVW5RY2VaY0ViQUZscXRSV3doV0tMUERW?=
 =?utf-8?B?YUM2ZVE5WTJVQVFkQ2JGZGViZ1V2SDJIaUlnSzk4cWU0dlBTbko3L1pOS0Q3?=
 =?utf-8?B?T2ZWd0UxZ2ZYZzhwcDBMNEtUZnFMTHN1M0dpR05FTloxWFFqZDZQaFRaZHdt?=
 =?utf-8?B?NnJ3cUJqK2toc0NKYmtkSDlubStQUjV5bHVsd3RiN0h0UkJ3dDBneENZblZq?=
 =?utf-8?B?UEVRVStBSUNpMktBY0dtZ29zOC9VNHJkdkxEMlZmMVdCeWVueTJaMm53YU5H?=
 =?utf-8?B?TWxjdmdGbjNUWXV2a1lldTQ3bnpiZjVEcUtwMDQyMERoK0VXQ1ZUaGw4dUV0?=
 =?utf-8?B?NUtyM0pLUU1sWEhCd2hGb1p1dllsTnIxb2cwSVBHK05uUjFXODdyUk5EMnFu?=
 =?utf-8?Q?SJP903RDpJHXoVJ3DFF0e0jUoiWXXAIPsmr2Vmg?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RjVaWGdrc2dJVEdBUUwxS0MzOTNFWlZtVFAwSmdwdytOWGlBbElqdk1RNUsx?=
 =?utf-8?B?bCtZWno3TUs1eCtvNUlkRE14cXhUUWY3dDlKTFNQc0oxNHpOZjBad0ZaMFdx?=
 =?utf-8?B?TXJYTi8rblRzTFdSOTRpM1UrSDFrb3Bmd243ZzIxSXVoNTYzSllVSkpBYnNW?=
 =?utf-8?B?UFh3L1pTclM0c0xpNDVHMzJWRXkwMnV0SjZhZzRONGUrc1BtOHluWHY5alND?=
 =?utf-8?B?bG9tQ2dhTFNRQ0ZiSzkzQ0J3aE1CUEpWM3kzREgyVmJuTVFRbm1RWm1sN2ov?=
 =?utf-8?B?dDlXQWErN0lZQ0h4TkZZbUs2djk1emx6LzJkUjVRMmtpU1JLZjVyaitRdlVT?=
 =?utf-8?B?VkRnNFNFeGhqc1RDc1g5QU0ySjNDWEJEb1pZeFRSTmg5Z1RVYTQzdThTRzNZ?=
 =?utf-8?B?dTN4U0N5WlN4eW9UdC92bGZ0VmRkbHllWDhSbm5CS0hVaElHUFYyZm0rYmNL?=
 =?utf-8?B?di9tZkpZaUtHaVBlaWhQRnl3OFd3OWJLQ0c5OThvbUtXVzE5SnV6NzV3V2Vy?=
 =?utf-8?B?b3E4MG5MenY3MWVLWFhlcXlwZmJSckI3Nk01TEwyNVhFVDFBWTNXaUp0SzUz?=
 =?utf-8?B?NDJrQjRJRXdISkVhNGhTMVZ3WUp3L1VPczlYY09hNlZTajlpR2hFRlRYeUE0?=
 =?utf-8?B?UWNEVlRVaHBuNVlDUkxMWDhvZzB4QnM0ZnpsaVZGRG8rWEMwc2dXamVLQ1Rk?=
 =?utf-8?B?Nm55YUN5ZnFQVVNrVytnTTlGWjRBSGF6NThGajh5ZEFPeFF5R2JEVEVYd2cw?=
 =?utf-8?B?eWNHcmlJQkgvZWNIK1ZjTXBXSXo1NjNRTDk5dEg5VlVUN0Y0WVhPOUhIdVRK?=
 =?utf-8?B?VzhtVFYveUhSU1N2M29HcHd3dC9pWGpjOGNJMmZmTGQ3SXhtYzN1bXowNjlz?=
 =?utf-8?B?djRpaXp2MHlzdGFqbmxkZmR2Wk5PcHNLbnF0UGk1NkVHRHFTT3B2STdBU1ZY?=
 =?utf-8?B?RXNGcFJPbGo2UUZVY2xSZDY3T01Pa2xBTktDTzFyYUgrQWhCcU5tNmVuNXZq?=
 =?utf-8?B?NGtORi9MMHNIcnNYTmdzd09mc29iTzU1aDU4cmRRdTdsWExCSHk1VGhzN2Nv?=
 =?utf-8?B?SzB5M1R6WG5SVWVlL2h4RWZiYjNQUk12SHREWHlzK0I0SlV1YnZHRTJ4Umkz?=
 =?utf-8?B?N21zbXYwRnFjYmQweXYrb2JWcUo0eTNZTFpvQnlzTHM2dFFWNWxDUXQ1MmZk?=
 =?utf-8?B?Q0J1OHBXbDBjWHF0dERKNEFsZTdRUjcyMDZRQUpqRExuaWF3YXFhWEoyaG9H?=
 =?utf-8?B?VllCZG9FUzMvRzh6Nmd5dUtTZndUN1VUbWN6dEFvZkpuUnVlNjZlNXQ1TTlu?=
 =?utf-8?B?M3diU3YzdWJ2UGFMbGZzUTZVN2dVOWRyWVplc3ptNHVGeStiZnBneDFZL2xi?=
 =?utf-8?B?OCt3TnIwVFZtUjl4WkwvVjZ3VWJuTFhqUEIrdG1aVFZhclBSUWVlVit5WHVI?=
 =?utf-8?B?QVBhV1o0aFNmejJ5RkM2a2hCaWdKbkxrTzJrOU1NaXNoc2JiUW1VK0R0TGE5?=
 =?utf-8?B?aVJPbGcxV1ViMUlJZFo5U28yZkN5N0Q3K1VnU1ptVGlNUmpJTmF4Mm8yMWRW?=
 =?utf-8?B?VytZalMwMlF1d1A3TnFFMXN6bU10Y0FCbXBQTnhkVjVmNkhNSW9tcDhhTncv?=
 =?utf-8?B?MnIzTktuZG5LZDJBb2hvVWZLWUpkYzFKZW5DMjNuQTljRFBLM3BkMENHRGNu?=
 =?utf-8?B?dVYzTEJBUk44RHNCbFhhTXNaQjZVeTVMV0FpaFRZQ05NVE0zK3pHRWZCNndn?=
 =?utf-8?B?U0l5K2hLakR1eGJBNmVBbVpvcURKbVR3bWw5M3VLZ2h0bjlSUGVERmVsUC9p?=
 =?utf-8?B?REdPdUpTTVc1SkNiN1cvNnI2MzFKamI5ZndNK1RIR1JTUTBSZlNEQVNpTGRW?=
 =?utf-8?B?YTdiN2hqR0pXK0MrNDk3N0ZEalllRERQQ3FvMkx5S2ZGdEZVb0F2UVdKaTQy?=
 =?utf-8?B?MlFwTVpyZlphQjhjYW4zSEYrYjJXYUhUcjFOS2RwdjZKSU1tNWpha3dOMFNI?=
 =?utf-8?B?L1pUM0plUzlGYW4wSXJ0SzJXQVBzd1dGdXNndXpSSGVucnpkQWhRV0dESUlI?=
 =?utf-8?B?TGhzSHdwcms2N2JlVHFDOTN3SmJDbGtUNXJFL0pSanlDVEYrTGJURTB5S1dT?=
 =?utf-8?B?eE5UWmIrRzN1b3ZKTUc5bWh1VmZIS3V4cUl0TGZDdW1LWG5BZVVMR1JTR3Rt?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	j/Qu7bQqUJ97ZQyS5HLBXojvBkZFjR3tLj7l+H7735vfavQbk345+IuFMYbfJeMtwOaCFSmEtzaDGmJX/xDIWPt4mMh9Cr4guAJzbruw2qkj9q1LQYqTEfyeoMxhqvWOnYIr+kfaAPmhHMaPM+8tbR+85o1kwIrxEDuw/L18H53GeaVtPimyI/SQ1xmB9PD2PeIKkS6PVRMuEom+w5aWbWkFkNYMHRhNF/FyyQNjqZkdvkKu5eqYGGHX4YRfCQDyNKLr8QPr7AwQ3m8b2EnO6wkMopeeMuHDCTjg8SQyvg74IkceFskiYEy99BTwJsLRwRqmE7qFWRhqCaQmEkRHHaEpa6bFfx+g1YIotr9x0IbdEU/hmB7xZnwqDjZ7CmqUy1C8drSwP7qH3p+MFkLWfyb9UTGMcIZtTqGZTbtDBzFCJOuPYEjKhjST9jjtI38VJ4wwe1vLcqzHgab93yNJ6xaijMWOD/Z6WD5cU+dgzeuX5SKY+gLRZTnQAaVPsT58Vat6kROZqQE26DBgv5qNqHhyyQHqEuC6BDWEYW2Pgc5ON0bR7fanSxhWBrdWfAs5oOh5kH9UjtVFaBE8TvPEyU6mBMkNqV/LnvliZIwvhiY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb3db300-a391-4060-c787-08dc8f8f6e4c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 12:08:57.6602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZMWknIohYqrHZeDvSWRoXb9Zd0NmMUcMbpyJf7KZy/7HJ3WwwumQKWfKG+x905l6uA2tUV+dezu+JO0gf57Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6452
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406180089
X-Proofpoint-GUID: YXhUy1WKdxOLxoE3omS7n0WoJxFThGOO
X-Proofpoint-ORIG-GUID: YXhUy1WKdxOLxoE3omS7n0WoJxFThGOO

On 18/06/2024 12:45, yangxingui wrote:
> Hi, John,
> 
> Thanks for your reply.
> 
> On 2024/6/18 16:55, John Garry wrote:
>> On 13/06/2024 13:23, Xingui Yang wrote:
>>
>> Sorry for delay in responding and asking further questions.
> It doesn't matter.
>>
>>> We found that it is judged as broadcast flutter when the exp-attached 
>>> end
>>> device reconnects after probe failed, as follows:
>>>
>>> [78779.654026] sas: broadcast received: 0
>>> [78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
>>> [78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>>> [78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated 
>>> BROADCAST(CHANGE)
>>> [78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
>>> [78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 
>>> 500e004aaaaaaa05 (stp)
>>> [78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
>>> [78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
>>> [78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>>> ...
>>> [78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
>>> tries: 1
>>> [78835.171344] sas: sas_probe_sata: for exp-attached device 
>>> 500e004aaaaaaa05 returned -19
>>> [78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
>>> [78835.187487] sas: broadcast received: 0
>>> [78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
>>> [78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>>> [78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated 
>>> BROADCAST(CHANGE)
>>> [78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
>>> [78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 
>>> 500e004aaaaaaa05 (stp)
>>> [78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
>>> [78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
>>>
>>> The cause of the problem is that the related ex_phy's 
>>> attached_sas_addr was
>>> not cleared after the end device probe failed. In order to solve the 
>>> above
>>> problem, a function sas_ex_unregister_end_dev() is defined to clear the
>>> ex_phy information and unregister the end device after the 
>>> exp-attached end
>>> device probe failed.
>>
>> Can you just manually clear the ex_phy's attached_sas_addr at the 
>> appropiate point (along with calling sas_unregister_dev())? It seems 
>> that we are using heavy-handed approach in calling 
>> sas_unregister_devs_sas_addr(), which does the clearing and much more.
> 
> I just tried it and it worked. If we only clear ex_phy's 
> attached_sas_addr, there is no need to call sas_destruct_ports(). We are 
> currently using sas_unregister_devs_sas_addr() which will add the port 
> to sas_port_del_list, so we need to call sas_destruct_ports() separately 
> to delete the port.
> 
> Should we also delete the port after the devices probe failed?

I'm not sure. Please check it.

sas_fail_probe() would still call sas_unregister_dev(), as required.

And you said that the sas_fail_probe() probe call would be asynchronous 
to sas_revalidate_domainin(). I actually expected you to have the new 
call to sas_destruct_ports() at the top of sas_revalidate_domainin(), 
like v2, but it is in sas_probe_devices().

Anyway, please check whether you require this additional call to delete 
the port.

> 
> Maybe I can update another version and only clear ex_phy's 
> attached_sas_addr based on your suggestions.
>>
>>>
>>> As devices may probe failed after done REVALIDATING DOMAIN when call
>>> sas_probe_devices(). Then after its port is added to the 
>>> sas_port_del_list,
>>> the port will not be deleted until the end of the next REVALIDATING 
>>> DOMAIN
>>> and sas_destruct_ports() is called. A warning about creating a duplicate
>>> port will occur in the new REVALIDATING DOMAIN when the end device
>>> reconnects. Therefore, the previous destroy_list and sas_port_del_list
>>> should be handled after devices probe failed.
>>>
>>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>>> ---
>>> Changes since v2:
>>> - Add a helper for calling sas_destruct_devices() and 
>>> sas_destruct_ports(),
>>>    and put the new call at the end of sas_probe_devices() based on 
>>> John's
>>>    suggestion.
>>>
>>> Changes since v1:
>>> - Simplify the process of getting ex_phy id based on Jason's suggestion.
>>> - Update commit information.
>>> ---
>>>   drivers/scsi/libsas/sas_discover.c | 32 +++++++++++++++++++-----------
>>>   drivers/scsi/libsas/sas_expander.c |  8 ++++++++
>>>   drivers/scsi/libsas/sas_internal.h |  6 +++++-
>>>   3 files changed, 33 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/drivers/scsi/libsas/sas_discover.c 
>>> b/drivers/scsi/libsas/sas_discover.c
>>> index 8fb7c41c0962..8c517e47d2b9 100644
>>> --- a/drivers/scsi/libsas/sas_discover.c
>>> +++ b/drivers/scsi/libsas/sas_discover.c
>>> @@ -17,6 +17,22 @@
>>>   #include <scsi/sas_ata.h>
>>>   #include "scsi_sas_internal.h"
>>> +static void sas_destruct_ports(struct asd_sas_port *port)
>>> +{
>>> +    struct sas_port *sas_port, *p;
>>> +
>>> +    list_for_each_entry_safe(sas_port, p, &port->sas_port_del_list, 
>>> del_list) {
>>> +        list_del_init(&sas_port->del_list);
>>> +        sas_port_delete(sas_port);
>>> +    }
>>> +}
>>> +
>>> +static void sas_destruct_devices_and_ports(struct asd_sas_port *port)
>>
>> "and" in a function name never sounds right.
>>
>> Can you just call sas_destruct_port(), as it takes a port arg? Maybe 
>> rename sas_destruct_ports() to sas_delete_ports(), as it does "delete" 
>> - this may avoid some confusion in names.
> As described above, if we only clear ex_phy's attached_sas_addr, we do 
> not need to call sas_destruct_ports().

Thanks,
John


