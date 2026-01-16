Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649D335FF5F
	for <linux-scsi@vger.kernel.org>; Fri, 16 Jan 2026 11:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768563589; cv=fail; b=m/arTJ3nn8opyjUAeDUtUwY3e5+ULicc4QeupITQlno+CJh54/BloKjK05SXawz0XHnH9NBiqXGIe1jfZg+UWjT5qfZ5gWUEjAlHqIFIRHPG0vJeoglRu66p7By2xwNu6p5FTs9VSaQr+tMvWirs4Xl6Pg0HhvGOG3kK/yw8TO8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768563589; c=relaxed/simple;
	bh=gwAYbXedeSJ1kdMADtzc9DqzGsTeGfXkKFQl1VHV+qk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rhfKHI5GiSwesAVeYZj9ml75/SIUcl6Z7MVbwl8TlFCVuHqdN9eIbwnCH6JKF0maLomYmWRY6fbH21P0uUPYpWI6fD5EzVVG1R7iYpkslkgvzk5Y8Hx/8Go03MCC2G8HrLzH2UazWyNchQbBoDgiRp6xth8A1HB4FenK7eriJDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Yy0WnYNs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LvP/c1kX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Yy0WnYNs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LvP/c1kX"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNR8d1818408;
	Fri, 16 Jan 2026 11:39:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=R4GD65l1HQzUDycHROm1m2MqHxvATCP4Fdnm9nnhfF4=; b=
	Yy0WnYNsSSAs0yG+i0zoOhwm9bfBBdGEHhvLdCOI9qosp8OCmy9JRFaM4CTih/K2
	1RU710rht9J9XuPzWA5sF2OsI5tS64BxLsuvsr92liNGbVIMtCysZULqqYfjyKDU
	tKfYsDI1aRzo2oZ/LZoD8txe2gvgY+m2NdOCm8R5uXouazcnchjOvCp88rADglMy
	nQD/1vZuyiC09eet/tH1x4za3ckTbkFrVry9oNNgYtKyDV72On9+lKU4l5vFec79
	hU/DtN1SsZzpMiAbUEY1/GeFkjo8pitJYMYKGVs2tzlLhlpzYCGKPrsCubCGj7SA
	jGlw6Mb+aYFtpuOnZH3rEg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp51m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 11:39:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GB1fCx001864;
	Fri, 16 Jan 2026 11:39:37 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010056.outbound.protection.outlook.com [52.101.85.56])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7csp8v-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 11:39:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NLjuRoqe0q2NfMZyJ7vYot2nKe0APM6F6aPn5X+QKw5sondl5zP0tZ/ine6WwKWqEA7ngRfcYMRcf/K081zjfbdKsZfeNyNiwIzxGlcFDYiOiEYWx8eT9GRUOpx2nB2HFO6DLYSiy1bA7dpJRc00wdLZEFv3yayhnolnIoaqi0U/WKopSQIaNcjUY9t0G1+5spMuUfxnUM79DXoNKQS9v+SzKdbx0CYzOphNgnFUl7pNtXauySgOikgK1Jh7t7xdXXJKhn53AKwyBvzl5g5FUt/CWQIl8ZBweSCAV1SVBNredUWJA8w+ueWW9KDisvsVPvCS1/bAxMu9/Tk37xdh5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R4GD65l1HQzUDycHROm1m2MqHxvATCP4Fdnm9nnhfF4=;
 b=TtJsHs0nmEmDuZ/sOBr1hnyScTCAUd14tiGsYd/u+l5S9kXxoEdhztOOp/T4+XY22A2BvRNdSraNtfPuluJVyDkBZGT1oRPEKHSHFCA2M+3vDIG9tAOOk7bKvrIIORQTUL5AexRG7IRX+cgdM3OtXItTrI+ZXL5ec6YHmB6weONKjvtMEXwNMiGxx3HtMcz7ua7SvZ1JuATGCEVwmWTei49o4SpJf+uwoTxVKYRR1lS01yO2RsxGv9PEzY7iYADl3YpJa6W2VGFt5SetN7wEbL5ndsWd6BQWSgaFNsU+O65T8NX2y3510wEiIiJfX2MmPx3OlFD7ogT3B97eQbGH8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R4GD65l1HQzUDycHROm1m2MqHxvATCP4Fdnm9nnhfF4=;
 b=LvP/c1kXfeDzsosWLZ+Rm1jZv0lkuKWCaWEVbJm1y08YGkKAbIyo/RsuKl3nNYtkwkUGY1kkqh/lQ2hwo6NgjQpJPDydjMXeiia0d3AV4hAzUiyVwfGX1WpP4ZC1D0/4xJlNtoXV7Zl/wYm2i7fJKNzmJGj8/7ZIHVg7BBHtLHg=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by CY5PR10MB6096.namprd10.prod.outlook.com
 (2603:10b6:930:37::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 11:39:33 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::ba87:9589:750c:6861%8]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 11:39:32 +0000
Message-ID: <4247de59-248f-4e77-b3cb-7bb0ee712761@oracle.com>
Date: Fri, 16 Jan 2026 11:39:29 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] scsi: megaraid: Return SCSI_MLQUEUE_HOST_BUSY
 instead of 1
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        megaraidlinux.pdl@broadcom.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260115210357.2501991-1-bvanassche@acm.org>
 <20260115210357.2501991-3-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260115210357.2501991-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0338.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::19) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|CY5PR10MB6096:EE_
X-MS-Office365-Filtering-Correlation-Id: f7176d15-6a29-47c3-7905-08de54f3eacd
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?WS9tMU5BaVJiTEd5VWFBQlB2MW9ZNzYzd3pkU3RuYU45SzdtYWNtR3BKeW4x?=
 =?utf-8?B?Zll4dW13WXBlSFpiOVgramFVbFIyeWl5UGt2MlhKNzNOUUE2SFNrTFhmb2I3?=
 =?utf-8?B?Y0gvTmYwNEdPdW5WeVhxUXlwUjRMSXhaUTBmSStFNEJsd3ZWS0Z1VHdjOGhR?=
 =?utf-8?B?ZVdLUk8yTGl6cFFpaTF2Sjl3RnFGM0tMR3VlZW5xNVNNclYyOW1HU3ZKNW9l?=
 =?utf-8?B?cEhxelE4LzNvak12cGR4QjFoL0pVSDhadk93OE9MQUpxZzhHZGpXM1JINmUy?=
 =?utf-8?B?TW14dURxelk2Y29Rb2xUbENWNlJyYURxNTZXYnRzOWErNW1pMTgyWFRRaXNZ?=
 =?utf-8?B?bWRaemtvN1cxWGJ4b1h6NTF0THlPaHFESDNqT1NLNmhGc1JIT1plVWVrbWNG?=
 =?utf-8?B?UFoyM29IN1hVeXZNc2p2ZndrVFRSZXVqVVlPUm1aaEFna0lQMnBlOXBBQms1?=
 =?utf-8?B?WWxiRnFHVWZqS0tyY2ttN2NseEViVEszdGQrTjIrVlYwT1RZV2NWV3laNUFw?=
 =?utf-8?B?WjR2UW1TSi9FTjRDMDNJeStzd0JiN0hJRm84VUtmOW9NcWtyNlY4NzRXRlYv?=
 =?utf-8?B?TmxSN1lNdGtzanNPeENlK0QzeEFWcVdPZ3Q3SXhxT1QzS1R0R0hLS2U0WjJw?=
 =?utf-8?B?WmVRaUpoTDdCQ29wcXpmaCtUR2lENW90ZVA0WEt1WjlVek5LbDk5Q0FGclJ5?=
 =?utf-8?B?WEhldDk4QmhmOHJxbjJudFZxcmQ1QnhPbUdDUnpaNHd1akRkWGQ5N2ZVcDV1?=
 =?utf-8?B?NWxHdXhyU05ERGIydHhGVTl4NGgwelBEOHRzSE9PUk0vQ1JkV3liYWkrNlBK?=
 =?utf-8?B?NWRnQ096N1dvUWFnNnNtUmhzajZnR2w1RytBd1NIRjByc1VlOFEyMmN2dkY1?=
 =?utf-8?B?TkhkTTltbTJlVWV5YUEzbEQ1M2dKaFhlQ2JUaUtWTzdQa2E2SFRabHlLVWdj?=
 =?utf-8?B?NUF1Sm43UmtKcHNRdzRmTFViVGpMM2dJRDZoYlBrbGFWaHZyQnpzTnBDVkFs?=
 =?utf-8?B?R0NjWk5XWWJYME8wa05CYWFJWmt5OTNSMkd4NDd4Y1VGREt0RDhDanpOc3FZ?=
 =?utf-8?B?VVQ1ZE1pVm5BUUJDaWpibWVKZlEvaG1NZzZ3Y2ZMdEFBQUZxZmlUaTVLbDFl?=
 =?utf-8?B?MWdlRUNDN3picnYvN2k0YXNlSnRvM0w3MG9JaDBXZjkxUnNzR0RCdjRrb3pp?=
 =?utf-8?B?K05FNzJDMFZIWHRZcHFNR21ZSkU0RjY3dThyaUVhS21RUXh5amlvWFNQQkhp?=
 =?utf-8?B?blNqYmlwZThNWU1hdVgvVjlEb1A4MGp3VU01dll1R0g0YkQvcms4MFFKcVdZ?=
 =?utf-8?B?Y2ZTTGtGUldBbEpGUkpWK3RMSE5XZ2J4c2xrb284cCsxaCtscnJXUmFyQnY2?=
 =?utf-8?B?Y3M2eGpnc1l1bjdsM2ora0RVNElHak5WMks2TzdQU0FjbkQ0ak5sc29BVU0z?=
 =?utf-8?B?aVdXZ20zQk04c2NTdEhmWDJvMll3WG8yWHZQVjBGRmpBUU43c3V4Zm5ZanJr?=
 =?utf-8?B?RHViQjFQb0d0eWZCRzFLSWNNZVN1MlZ4TGFkY08vSzRBSW5XL1ZTQnYrdUxY?=
 =?utf-8?B?RWFVZC9heFRrN2dVWTRmODJNLzF5MnVGekthanNKZlhMWEZVdHJtY3IzN0NE?=
 =?utf-8?B?enR6ZU9jVTExZTNnaDVEaVlBWTA0ejdyMWlFWVljTW51MEdITkIvSzZQOEpW?=
 =?utf-8?B?QWY2RkZzL2drZC9vR0NWT0d5YWY2L2g4MDZ3eTlTVGNwVXZPUmh6M0V6T3U4?=
 =?utf-8?B?K21FbnllRHlYSXNQb0JTUVFZR2lEbVZBS2ZrNjg4VE1sK3VJb2lrMWVRbGc2?=
 =?utf-8?B?WVVFRndnd2FPY1NhWWNOT2NzZG8zU25hNUUwck9WVStKQXhqMUVMazRoalFL?=
 =?utf-8?B?NHFwVDRXUjJMRkxIT1YrQmpleDhhekFMRlgyOVFRVVpES1drbGJnN1g5Z2lX?=
 =?utf-8?B?dW1XMkxGR2RVdnFNbVFrQ3lRamYzS05qd01UamFIQW5hUklwVXM2VVN6VEFS?=
 =?utf-8?B?MTcyY0NuUWpMMDE3WUdYcFFWbkwvVVQzR2dlcy83QVVvQUN6ZDhVcUFGVkhN?=
 =?utf-8?B?Q2FOaklxclZHWktONlB1UDdMbTZiZXRQcDBEMGo5Yi9ncGJ4SDgxMG1ZMm9B?=
 =?utf-8?Q?1QSc=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?ay8xOXB4MU5xbG1PdHU1NkVldVhJUzBndk41ZGVybHpGaUM0ZXhvS2FTQjVG?=
 =?utf-8?B?eis5dExKVi93S2o3N3BySGFZakFuaU9UYnBraUF3MHo2b0J2OTJ4ZjdFRExm?=
 =?utf-8?B?WGt0amVXZDBibTAvaFdHUS9sUFAzRzFmVFo4cFVjelM5eTdqS0NKS0x4QytR?=
 =?utf-8?B?WUFWTXl0VDduZmNFaGhoYlpPd1E0aE5ObkJtbTBYNHJ1RHI4Tk96YWxLVW5m?=
 =?utf-8?B?NFlnbUc3YlF6UWhSdk1iSk9VV0pjU0c4NEh0cUFPaUdRZHdpUGhCVE9CSEtG?=
 =?utf-8?B?MXBvQTcxdjBBREdIdjNCSHNwWXpSejFGU1BvZ2V0dEFjV1lnWlZWaWlldWJL?=
 =?utf-8?B?T1FIU3laWGlzSzVRSnFNQW1HbE5GLzQ2bUlISjU4YWxFMFUyRkl4b25jZm5J?=
 =?utf-8?B?REdNd0NlNW4xL2RIWjRyWUNHWjR5WG5rMW9vekttUmNjbEJVcHI3MFk0d0RD?=
 =?utf-8?B?WHFHSUlRT1NRUm1EalRCbDM2YVFqSXlMckxkN2FKV2NmaWhvVHo0Slc4M3Fo?=
 =?utf-8?B?eFB3YmovbThLMTdhTHhQc240T2pVZ3NhVVlqd0JBcGNDVVNsTTZZTWZyWVA1?=
 =?utf-8?B?VFJERnFybWlwRms3WHFMWnpuQkFjOC9CbUlRRDV2L0UveGVoNHorMzY4Wng1?=
 =?utf-8?B?czgzM1dlZkRGL1F0b1B2UXBXWG01ZVBsTHFqME0yNnJMTVdmeHpWNWpsV0Ur?=
 =?utf-8?B?MWhybFhWa1NXVXJyajBmZTE1M1U4SUV4TURWTzdCYjI1VXNJZUw2RWlUbHdv?=
 =?utf-8?B?ZWlFaEV0Z0ozbzhpRnoyVnpRdVhTc1daSjgyYTdFa0pod2hDQmtPL1FRaGVK?=
 =?utf-8?B?U3BYVXIxbXh3SDZvSzV4dTVpNEJEZWR6TVRnUHdVNnJFY01Cd2twZDh5N2JX?=
 =?utf-8?B?eUhXUWYwNmhJc08wek9EbXJDYnhiR01KOHIvSndRem52RFBmbk82NW03VEFl?=
 =?utf-8?B?YXoxUEplY0c2Y2tvdHlwMnlBWW9mOUJLTmhZaFJ4U1Rlc3NmSHQ4OFFydmha?=
 =?utf-8?B?VGxGcUd0OHl4VTZxQk5wQ0E1QWpGOHJmcGRVams0KzYxYjg0ZUUwVXFqSG5L?=
 =?utf-8?B?N3BueXhiRGlWS3Q0UGZDK052SGlTb2djbzFhU1ZQRkIrR2VnTWcxb081YWpj?=
 =?utf-8?B?dDF0MHVoeFpWZDhHaW1XQ2oyU2svNmxUdmhieHdkcjVNZFBnSG4yeW9QZEVK?=
 =?utf-8?B?ZUJIKzlKeFo1TldvOUxja1BkUCtWbFJocWxuKzFtdUR4NHVheEs4WWo3RDg5?=
 =?utf-8?B?MmFEeVZhVXIwZHBiUkJyZHRsZ0xYZ2xzTEhwNlh3YnZvTnpvaVB5MFd5cnh6?=
 =?utf-8?B?aFNSZzg1VER1Q084eitxRnZKckVqVEFSMkFiOUxIK1BibDQrTHpOVDViRzVI?=
 =?utf-8?B?MmJOVDNhL3dGa3pML0FDTlFSdmhlYWh4K21uZkZaMHErU0NHMHhxUDdhdUo2?=
 =?utf-8?B?WGYzQzl3TGVpSDlyYXdzQk1tRTJQQ3VQdUlWYkt5NTlhQXdjM2hubVdvTFpY?=
 =?utf-8?B?eThEYkZObmp0OEFFNE9HS0FiZFl1NnhOeERNR2cyUHRZbGJtSk9zVW1Dc0xW?=
 =?utf-8?B?WDF4VTR1L2crUFdxbHpIRWJud0Q2UXFuVHpyR0kvZElwZlRZY2p0anNVdHpC?=
 =?utf-8?B?M2hwVVMzSC95eVp6QjRPMVpDaERveHp4R0xMMkdEekpmZWVBQld2OHJtZFdr?=
 =?utf-8?B?b2NEWGlnSXVEb3ZhUWZqZ2JvenNIUmtJQTJCaUVJeTJKZElXaEsvcDMzMkJK?=
 =?utf-8?B?MWY0eUd3RElNZlkxcnV2U0xiZzVuODgyWkhBWVF2YXUyV3RXYnFxYTF2cnpi?=
 =?utf-8?B?dDdwQ2xIdGlyR203d3JwQmtuMDgxaVM3VWgwZm4vcUt2dlk5b042ZXV5VlNI?=
 =?utf-8?B?SE80YmpWNnNmbkVpRjA2SENHQ0VBemxVOVdkbjVsWHErOEk2RWg2UlFMQ0hB?=
 =?utf-8?B?LzNEMzhhbXhSckNNMGluV2laMEpHTEdELzdJd2ZhNU9tb01wY2VNQ3FPcmtS?=
 =?utf-8?B?dGNjd0dwelNSTzZ6WlR2ck5sSmdibWNsbVhKZTAvS1ZpdXRsWXo1RW1EaFNz?=
 =?utf-8?B?Wk54b2tCNk9oSWRRWjhiUUwwTFZxOEJ1aGVKS081SDYvb1p6b08ya1l0NVZQ?=
 =?utf-8?B?RlpPRkF3L0Q3a0dFSFRXR09RN0c5YjhLZFpJdW9WeDVjZnBGZ1FBTGNwTTFE?=
 =?utf-8?B?K2pwNlBvMktNTWkxK05oYjdWWVA2bFNCRkQ3b2prYWN5S09Ic29nUjUrRWEx?=
 =?utf-8?B?NkUvTytpNUpLazV0QSs1SmdhRnZQeW9CYW1Bc01nZkhPY0ZFb2ZXTVhxWEt4?=
 =?utf-8?B?ckEyS09pSVZpNUVUd1pmbEkwVEI4QXJMRGN3YmJiMmZ6UDJsRzRndz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xMCjeD8xjlwNayD51SKmYMNnCWp8WvEbALBxxYZtXadwI3vKs8mQoSvme0RNLnOUnWyzhqaaBAFbtS+ROPmHxJZ65Xt270cal2ZZajtgd3fqRiIpMsoUbCLdz0bNL292US0TMstMwqI8SMIent/+5KjlrH1b2+vO2F7LJJcxKYgXqnAsQK8nJU/AN1+D9134ejGYDjaEfaznZTzJZZ9jRazYvsNG25oeKNvmUzu1tr6LB7FDbsGUuEmZwzPj8+YJl0zq7iW3ECpCTflfB+W4L1dUa1gxkRS0B+ZmPrsQYHN5MIKEOt3VNYhRhlxazOEDlm7zd2i0ut8gqEp4ZomRwWoFflQopt3IrNvdHtcvcTBWOIJPcfF7/mz5TB6yBPhKEvkYt73SE5KAFY6hB238g2x4KTB1mGy1AbrrZoF1m1Jdqp5XvysE8wjTRa3KvIY8l3jCZALPJHEAzP4jGHRY4U4v7tYgR3TWVq3hWB+boDbP9ZF8IVMQCdBEpaUCEUSNjpUGYN7Eop43UMgW+Rc4LqKnMl1IFW6djdgq3XbsKBDH0B+Tli8CVYLWrX6w+EHxyMBSMU7Zi49w1vZT2HWu+0IkeeE9LVfYQt/XGGC3oUw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7176d15-6a29-47c3-7905-08de54f3eacd
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 11:39:32.8373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gCTIQsmoIUsBuYr2s8haBrJ85F7pmRmHdDI8PscK+US0vj/q/5h14vs8sA86Xh+kQB7c+3Vj0TKblV/yWBC1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6096
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601160084
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA4MyBTYWx0ZWRfX30jaUYCWbZuc
 pF3yK9BLoF12wYMyYLOnwGwureNgZYP1niIgO3kWjVkvdN4uKK9Iy25hTpALbO+K1tjsp7eyVxX
 eF+4X6WfHSg8q7PKp4T2vVoeKJwBI1yAnEMSp2FwkkafCZcf7Ob8edshmHuQPI1WdP934mrLx1/
 WMQEH/Tb5ri6uAc3nJgQJBEWOMaw+SXW7Eti27waMsnkzaCq54eKvZ/AlRv+xztMmoMxZMNSGap
 z/Bjn4wlCwsWhvXLXb7ixYAxxultvK6xIzqvkYK/Re2jCGF9+SGhJOwh9CqpTQn23DVumdPgcfD
 axctCGDA0ayowlfNMtxQK655dPcRYuMTALAF6lX2eMfBgYdNek/RRl9MQQmIqQyi6ZfJcSrAqDN
 9rd8FGO33coMIgG/Ulw+tbMA1Nme/FymzIzkwVSI6Y5fH7/tkNNlCLZ72aVbyAkeoXc3i+6TjWj
 EqOjixqEV51peloOPSw==
X-Proofpoint-GUID: sLsAEGKK2IfQTJocVituLfn4X8e12nS4
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=696a237a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Q-fNiiVtAAAA:8 a=N54-gffFAAAA:8 a=msiBGzypvjf3ziAmsIIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: sLsAEGKK2IfQTJocVituLfn4X8e12nS4

On 15/01/2026 21:03, Bart Van Assche wrote:
> .queuecommand() implementations are expected to return a SCSI_MLQUEUE_*
> value. Return SCSI_MLQUEUE_HOST_BUSY from megaraid_queue_lck() instead of
> 1. This patch doesn't change any functionality since scsi_dispatch_cmd()
> converts all return values other than SCSI_MLQUEUE_* into
> SCSI_MLQUEUE_HOST_BUSY.
> 
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
> Cc: megaraidlinux.pdl@broadcom.com
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/megaraid.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index a00622c0c526..54ed0ba3f48a 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -640,7 +640,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
>   			}
>   
>   			if(!(scb = mega_allocate_scb(adapter, cmd))) {
> -				*busy = 1;
> +				*busy = SCSI_MLQUEUE_HOST_BUSY;
>   				return NULL;
>   			}
>   
> @@ -688,7 +688,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)

should @busy still be a pointer to an int?

>   
>   			/* Allocate a SCB and initialize passthru */
>   			if(!(scb = mega_allocate_scb(adapter, cmd))) {
> -				*busy = 1;
> +				*busy = SCSI_MLQUEUE_HOST_BUSY;
>   				return NULL;
>   			}
>   			pthru = scb->pthru;
> @@ -730,7 +730,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
>   
>   			/* Allocate a SCB and initialize mailbox */
>   			if(!(scb = mega_allocate_scb(adapter, cmd))) {
> -				*busy = 1;
> +				*busy = SCSI_MLQUEUE_HOST_BUSY;
>   				return NULL;
>   			}
>   			mbox = (mbox_t *)scb->raw_mbox;
> @@ -870,7 +870,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
>   
>   			/* Allocate a SCB and initialize mailbox */
>   			if(!(scb = mega_allocate_scb(adapter, cmd))) {
> -				*busy = 1;
> +				*busy = SCSI_MLQUEUE_HOST_BUSY;
>   				return NULL;
>   			}
>   
> @@ -898,7 +898,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
>   	else {
>   		/* Allocate a SCB and initialize passthru */
>   		if(!(scb = mega_allocate_scb(adapter, cmd))) {
> -			*busy = 1;
> +			*busy = SCSI_MLQUEUE_HOST_BUSY;
>   			return NULL;
>   		}
>   

