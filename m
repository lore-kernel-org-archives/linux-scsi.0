Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD17170826
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2025 16:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750867598; cv=fail; b=C4vPu5SS99kAZ4xlK0Yet/eyeHadg5IOe54HXVUAN2KbQn62ev9eaLlwwEgWGSYLRz1KKIpHkVR2w8JyttT4QvMDbCY/E5+XfKUbh5LO5PW4gTDtqJV4ZPjmAniDJ1OxGBpmJWEJS5pmD5hLNE6uDVo2QztpVXSH6J1PIwp2Dz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750867598; c=relaxed/simple;
	bh=yj5LlnHasNcmwMzlmpHIrTxCcyS+I4AOqe6lTfEfMl8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hQIvHzyCpkT/PqOt7DbnSSDeir+YfQxNwApXe7iVJclmOKgHHoR9qvf089JaZ5dUYjtIM4XvuU3Dh97hA5VKx2XlJsesWuPqAgX8L7Cec6zQaULyr8vqoGvWHIspOewHH0Pb0xc8cJWnomxvl9gNcK2bVXkeMWTY0kWPiArFe1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lxPgnhJ8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ofkTXAOn; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lxPgnhJ8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ofkTXAOn"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55PFtkki013751;
	Wed, 25 Jun 2025 16:06:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CVC5tsBU3Vxdf8krokRYJaVkoWs4nNE3mtMLKJmafDs=; b=
	lxPgnhJ8lrk2r3CFbnm7tcQqxHdIN9Wj/i1/TDtPVX9DxblAhI661+YkAkBExKFL
	dHMkFzZv4+JjgzlSLs3wm0Zx2TPjqpr0TziykPHihAVYc9sFr5BGjV2cIXVOgx7g
	ozoM5U6jQ2USX7MRlf3cfCR9gcnb6h4YB7GoYebpdkMPM+92GVpNPp0/3MQATXgE
	bJInN9h3Z0UP2C0TjgWj8cJbWRvXAJ9Zisbpo6pceRSf5Vsmqo/CsoXGncPgPoTb
	qlMEf6HmuAFuMLATyuRMHueV/AGI8Sa6S5+GhUM3sU6fkG/EDDS8U1xxP2Jn6LG0
	nccKiG5vR4+f/AE5JdSFzg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds7uyyce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 16:06:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55PEXi0D037956;
	Wed, 25 Jun 2025 16:06:19 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehpesb3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 16:06:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AE52AnWZQYMV79BqO4pKpbaG7VB7Gh76N/IkY8hezwkZ4VtuN6DJcpnjwbVvHUVv9f97AIxH/7wOGpG9xXNGMltmQUPOIqz4Yh3QSsdoqSvH05sPlg6EzvTkE8qxFP+p9OAJxeLQXSWLrLPJshV1WgBzjq2N2z/uv0SoFfudNaHS+nP5pCFkoCwGfyZmZ6SAgWJIWiUaBAhNjw3IFsCHO7pioPmd2kQ6S9X0MTPenO9V5vPW4DYqsiw6NW75VuY7QRvyRcOf1K+Cr0/2aht84n6pJwQ0X6Zi6bVjcx2bcq0aUdsjk/dXa5eWHTEVOvU7STwCu6b9t/XnuGxZ2V1tJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CVC5tsBU3Vxdf8krokRYJaVkoWs4nNE3mtMLKJmafDs=;
 b=KFKP7aSjd4mdE1XLdaSKbAaFcVnMm2ZCGfZFBwdfcHt/SJ9vx/OoroAX40jknsCSsq6rylq06twA1OyYSfuGveEdzQFA8gW5uKneStASO6i0XbYncQu0wxMhAiZfQUhG98zjg8JpvaUKt2O+hNaw2j1Va4AMPomG4RgGn0YZCjST4thUmU3F3WkbcRYxtqf/U4pkA1/aqbB+P8frmu2qekHNJqbCm8mH813cqKe2s7jtxhgARUNDKQfGwq4oA4BAZPsoXZBl1ELuZ5fHvW+uB6853f833A60Jky2O6J0E697nFl5LJ6KmzYzBxWKaTEsVq4s7/FQOTj5m/dxeXOD0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVC5tsBU3Vxdf8krokRYJaVkoWs4nNE3mtMLKJmafDs=;
 b=ofkTXAOn0MgQolPqRmup8AFL6xXx5QMJG+c0SZ15bDFTEf+MBSqmnBSmQIHm/kjB7epMxoMbOnrvVfvBwNT+r+infK1aGAHChdyCfLX8+WAO3S3b9BwKjNBf6vjD7W5ZXUDsulVN0Pl7BBQlLlNlfZfK0NqR7WbdOMXXwNsIDGQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7621.namprd10.prod.outlook.com (2603:10b6:208:484::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Wed, 25 Jun
 2025 16:06:15 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%7]) with mapi id 15.20.8857.022; Wed, 25 Jun 2025
 16:06:15 +0000
Message-ID: <ee6cc070-fb9c-43d4-9c43-827424e6adce@oracle.com>
Date: Wed, 25 Jun 2025 17:06:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Improve const and reserved command handling
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250624210541.512910-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250624210541.512910-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P251CA0003.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7621:EE_
X-MS-Office365-Filtering-Correlation-Id: 86aa5f0c-28a8-44e6-6820-08ddb4023627
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WjVrcC9Vc29jNHNoaURoN0hpTHZwZHM2SXVrZjg5aDRxMGcrVVhta1NQbDJL?=
 =?utf-8?B?OUV3ZnlrYnhPRWpOemV4SWN3a2l1enRTbVIzbHFWMnZ4VksvTFZpSUEyMFRv?=
 =?utf-8?B?ZXl3Q0VXWkNIaktVT0lMY1A2Tis0ZUNYUkg5ZHVBSVZ2dDlKank0eUprcGFG?=
 =?utf-8?B?WW1KRlZYSnFudmQ1TlI3QVlJQW5seHpIeU1CTVRGMVdPQzlZaHRzbDJibEJP?=
 =?utf-8?B?TkFHajkyTzBSeHV5NnRmWXlPTGZvK0drRS9LM0ZwajlxVzJ6U3dwSDRJeXA3?=
 =?utf-8?B?R0hYSnp0S05Nd3paTWs1dTdFOVE5a0V2Q2sxQjZ1OVpKeHpDR0c0dDNEU25V?=
 =?utf-8?B?dTE1N2dtNjJ1N0tuYjFUckM0KytXM2pvaDM0ZnVad2s4YXVCYjdLOHRxNUp5?=
 =?utf-8?B?NkRoc1d2bHZETURpWnVUWlV0eEtJTkhsazk2RXJnblBJaVE4YnVZT1d4b0Y2?=
 =?utf-8?B?aW05bk83OUlVN0J2a2ZWaitOYXI5ZVBqSUpiL0VnTFRDci9kZktLOVV6RStR?=
 =?utf-8?B?ZSswdFJSM0t2NlplSWJNNWFIQzFlOHRkRnV4YXhpeElTZzd0QjJoZVIwZ1ky?=
 =?utf-8?B?QlkwcTc5Qk1Xd0t6RTN2ZTQ5TEk3SGN2azFoRjFjMGZKczNkYTh3cHkxWCtp?=
 =?utf-8?B?TjhyNzdIV1pjTEhvbW8vSE9nQXAwUUozVXhZd1VtZDRDQjliY0RHT2lTdzZM?=
 =?utf-8?B?eitQVUdWclBiUHdBS3RiMktGRTUyVFZrQU5kbitKTVNlM3dBelBoUXl6RUJa?=
 =?utf-8?B?QTRvV0F2cEtSc2F2Z1ZUSGFTKzdTOFgyMzBqeTBFMnNCYnQ0VmF4a3R3T3ZY?=
 =?utf-8?B?Y25EemtrZXRCUDUzcktXcjQzZ1FnZmZUUkdwbGdzaGdMNzM0cVFOMlV6UmRu?=
 =?utf-8?B?dEJIRHA0VjZaWUhDSHlPSCtkU0JGV21kRjdKOXdSVi9oOEdydzhzc3FxajJm?=
 =?utf-8?B?RCtxK2pEMXA3SE5IME1TQlowWkRHc0ZsOC9sS3lMVm1rRkJWaURVZmNVU05R?=
 =?utf-8?B?SWtvRTFSU1RtOUdCSnR3NU9CLytVK21TZWJ6a3lDUXB1bWNia3lEUXY1TWha?=
 =?utf-8?B?NUxTeFpnVURHMDhCcG9DTzRsajhTZVhaNTBVM3ZDTXZVRTU5YWZyUnRZUkFt?=
 =?utf-8?B?QTNyRDczR2ZnWUNpTnBtUldGbFRwaHRlajJGME5EaVdha2dvUHV2UVVTODVa?=
 =?utf-8?B?QWtjMDFWMXdJTi84Q2hkZFlTY0hERnRPSjRKSWxtVkNlSXp3TUI1bkx6VzRK?=
 =?utf-8?B?RWcydS9FTnhoVjJKOUp5R1hLUzc1TXlxZnVzVzNxNXlRU1BrMURKMnJtYkF6?=
 =?utf-8?B?ZTl5NFJWL2JTN0M3YlB0bU1ZQzYwQ1Nscjh1RER4OStNYUZ0ZlVLRDdZVXh5?=
 =?utf-8?B?Ti85czI2eW5UZ1FGY29oa1lranlNN0ZOcWQ5TGZQM0ljY2Vxd2xyMUtwTEtv?=
 =?utf-8?B?VUpVVkJuQXNUSEtLMi9BWW4xYmpKRGJzeHRPVGF0L1RPUVNNL2FyaHc2dXR4?=
 =?utf-8?B?NzB1ZG9peFE4aHFMWTJ4VWpSRkFXaTJGSi9UWXpTMDR6OVB6UDZoTlhFMG9Q?=
 =?utf-8?B?ejQyS0s2dnlNV1k3VC9xdGpRMy9mcEhyaXVya3o5YUZWYk1CZ3RNVHF2TFRv?=
 =?utf-8?B?SW42MnYwbllzVlcrUkVJcG43Z1JkNVUvYTZaWWUyYkh4b3I5L3dhbHQwM1h0?=
 =?utf-8?B?ZWdtR2k5dU9XVnNLVXZBSUhaUVlIZ1dtZUtVNGowMnZpSVVmOFR4UVRKRXR6?=
 =?utf-8?B?UllyMGEvQlJpQWIvUmlkRUZOcUs1eFdmazM0bzFmdEZmZFJjRndRSnVqSXda?=
 =?utf-8?B?UTFMTWZvbEVSNEFLNjNxYnJzbzJqWVhZdzEzRXdqTHZabURoL0lEZW9pWDl6?=
 =?utf-8?B?WUpGRkdxY3VrM3RrUnVlNTFPREU1OFA3Q1JNVTFWMWdYeUc5T0NIUzArVXBu?=
 =?utf-8?Q?yR0gPAf2P7U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emt3UHBJN05tdjNqWlE5bXdQT0JadkJ5SXZGbUtmSHBHTHNUWWM5Y0xSZXUv?=
 =?utf-8?B?UzdaTmZmYWtHc1BVWFJzQmMxeWM3SVZvOEk0ekU3UHd2Wi9oNUh2dnpjcWJw?=
 =?utf-8?B?dHNvSmtudzd6aTV0MFFnOXBmMG8yT08vZENnZlkvRWdnY0l1YkhZdEhzVFdl?=
 =?utf-8?B?a25PYUkwQURRdDUwdm5Rc29uVEFLVHU4OFd4ZEo3alhRZGo2MWc0czJpNGJp?=
 =?utf-8?B?YlhIZWV1OXRQcFNxVUxDdERHNG91cCtmaDJqYUpSMjFGQjBoVVBiTStLaW1G?=
 =?utf-8?B?R24xNG05SFFmdkVFTXdvRU9ucHhkR0dEbUx2c204dk1UUy96eEE2UjJxSlV3?=
 =?utf-8?B?MThLRFAveEJaWjZJRTlTcW5hdlFUNUk0eHlnQTF5NWZiY3NTZFZZcm94dS9x?=
 =?utf-8?B?d2lHYXVqWmVDYUJSSmtKMUpSUERCVDlQdktHMHFiT0RCMXJtZEZBUjg4bnAy?=
 =?utf-8?B?cVNuTUZuZUEzUlM0QWhZRVk2R1hIMmw5bHUyRk9ja2ptWUUwSnRqQXV5dmtw?=
 =?utf-8?B?d0lRZWRsais2eVBVUkE3K1g0QUJ4UmxYSGRTQmZXMG4zQTgxNzl0aUlTUm1H?=
 =?utf-8?B?WnZYcmgwSG5ENHgwNDVwcTNpTG5aWjU5ZE5wNEJZWk5HbGY2Q1I3T3NpaDMw?=
 =?utf-8?B?M2g3YnVsbXJTRkFwbmxCRG9iU1I0S3A3Z3NtNXF1ejVDMnZxQllsV016WS91?=
 =?utf-8?B?UmNhOGtrc0k0SUMreElyOFZRdnhHUmVxMWxnZ0xOZ21yamVDTjk1UmkwaG04?=
 =?utf-8?B?M2tuVHNmcCs4V3JFcWU5YTlxd3dnb01vbXUydVdqSVpVWXczTkxTVnJFOU5R?=
 =?utf-8?B?dkl1RHg0T1A4b0gzbGZGd2xGVHRZRFZxc0F2eWJ4dnU1S2pYUzRDalRzakwz?=
 =?utf-8?B?N3VEV0U3cFpHWmpRQUp6RnFoU2JjalZvU3ArbVhCMVl3eFdheHRpVHRESi8y?=
 =?utf-8?B?VmRMem9ySHNzMG01c0dYaE9GZzI3Mmt6eTBtSEttejhHbmlhYk9XSjdQVG9O?=
 =?utf-8?B?NHNRYTV4MExHNEFocWlZWkZhRGFIWnJtQUw1OGtDOXlhcWc4ZDRFVitFVWln?=
 =?utf-8?B?ZGdUU2JPRm9aRmJOaEw4Z0dodktVOFhLMnV2TnlzUktCdUhPUTkrS0lESUh5?=
 =?utf-8?B?S2pyNnhSSUxFQUdHTEdkN1lmc1NUV2hpWU1MTjhvK1BZS1hWblRUMnlncU56?=
 =?utf-8?B?TlErRG05MHprTFc0VXpwcm1OdlJrUkQ0NFNpSFI2U2gvcm9HbE1ZMDFSSmN5?=
 =?utf-8?B?eUh4TFl6R25RTU5pNXhrTHJiMHMyZGZ4V3dwVFFXcWxIeDFNck56R0pvS1BO?=
 =?utf-8?B?WVRZdXRuTTk5SHpjTzFSdlJuOGRFVnVXTkVQSnp5dUc3LzYrdnFCWXlEQ2Mr?=
 =?utf-8?B?RFkyeFpXWlVBMGZxRXJ5L3Zpb3VYQmRrQzYxZW4yNS95aXEyY3J1YnRuSW9Q?=
 =?utf-8?B?WkFIaWxqelNtSHBPT0I4S0RFYjBmbG14SDFNdFpPNW1BVnY2SXVvME96RVBZ?=
 =?utf-8?B?S0Y1QkFhd3BKc1EyTzVOR2IzblFIZ1R6VUw5T0R0NzlZdm9wU2VLYnFVbW5Q?=
 =?utf-8?B?TkhhSjJPSitCVEdWOWYzTXZidVZmejRFVldXajRKYWhtU2xqckhjZUdGWjBF?=
 =?utf-8?B?R1ZQMVNXQzU3eVlKc1NmNnRwNmNkSnBYV1lRa1Jya1R2cGVySCtNV1JYZnJU?=
 =?utf-8?B?aUNaRWRQc1ROMkJvNVltaW9SUnI5QStLYU5sckJWOStRVVEzWE1qaFN3SW1x?=
 =?utf-8?B?NFd5RkhwOFl0MUZmWGgzKytNODZjanQrajJwd1ZKVitobjh0bnRqVXJlS0Ev?=
 =?utf-8?B?Wk5XUk9qQWZhOWV3Vld3TGg5dno5QXN4OU1Ub2tCeUVocEdjWVdhU0FuWE9I?=
 =?utf-8?B?VlJ3K3pPSy8za0MrZHNzYWNqUEZtQktmM3QwSGNyOGJvTXpBYWN4WGU2TVEy?=
 =?utf-8?B?UkFlaVBqaE16Q3o1U3diSkMvcWZSRFNZWWlKZ2pYNW10UHFsdEVyUEdVeWMx?=
 =?utf-8?B?ZlpydDViYi9OeHJNYWR3TjJTU0ZoTWdTRUkxRlB3Y2NzRGgzRGRvQzVCVklk?=
 =?utf-8?B?azl0Um5IaDc1NEhYSTZrQzEwSUEwMUdnV1owaXVwSmxSQjFhNTgxb1VSVGl0?=
 =?utf-8?Q?56NSNbENPVQrU+CMpXxVq1r+D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XlvLhH9ngvGu7zCQ9sY+8xXdmySPQp0pDKg/C1shRiYyHpCRtEKeavDl1j7DnkpD9+sOB2MK8ziMx1dwVD1T0rKwI6crj/qgb8Iqqipx6SIng/RdVkMnL8WgM6nhOLj0o7fRu5Gi+MkRAW7v30YtM+Krax0Y8XsL6v52djAhBIJb5/U2IqiPGixp/slu8C5FK6OHyxkeqPZeYF7LZyYF9lH/p+95Rw+/PSctlyq5a0ug7rU1N17iTK6UZr6M8iHCSSCu2adP4J13HCAlvvxHjSDfIhgSWBLlUFDnY+Y6/LCvEmRrwkOdsyep1UQBGzNhkRYLPq+4Epe1dk9DRQFy0DzoJwTlBgSwCZ/RGCanHnlTifTL5fxepxreSiQmunIXMcLkMTBOR1HRw0gmHGIDMJV5r0BJ/OmFcK3vSDHKnFBTlmcW1qjHM38/7YNVh6feJ6DTu84igG3MSTXOKtn4nJj6GMv+Zk2xfl4Cl+S3ltSkcO+tWQDyumVTowGsENnn4hUjD1rkHTXMq0PK8zfKIZWHDc84XOHBtZ3J5PisnnEWKb8Brn3FBRPIzsKnsKij6yR+tf8B2JuNuUYfvU94Tjy1hJXruljxAwvzcxKCUAI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86aa5f0c-28a8-44e6-6820-08ddb4023627
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 16:06:15.1187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4cyBbj07RekRD/DQv2NXSNZMKp5ZHsWxyYIctvOIKAH/JiC9t6/BbDHMbwcPACSPV6QUj7pYph+HrezaoLk/vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7621
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_05,2025-06-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxlogscore=911 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506250119
X-Proofpoint-GUID: yuU0Oz6MvCZNRPXnvPifG8bY6yHXNaTj
X-Authority-Analysis: v=2.4 cv=CeII5Krl c=1 sm=1 tr=0 ts=685c1e7b b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=fq025ouwe9HRRNBustoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: yuU0Oz6MvCZNRPXnvPifG8bY6yHXNaTj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDExOSBTYWx0ZWRfXzeUCPpU/0rDe vreXPZ6LWVFp9W5GTMrXEr8hdhvtczbXEFQOuNlTt6tx4863NZq4ABygu1RVj/zOgNlb3SBu4yT jC3n32Mk9GVLsFfU2BhkUpqBED3udoywJYaJSkxPtA+iVMl8mMLUFyse04kjEL3kfAPPsNEjKTG
 f3a/q+Ws9YBAB2ZtuhEhbhwaL9X3fSxS0VRfzSCBSUqMrf8uuypnqmLQrse0g1F4/muY8ruRhK/ s0V6o9b2NPBGUXO1DtUtD+5uWH3ncmMnd2P75u78nK/DS9leHNY97mRFKyXJohwM0kgmVQc0RU8 Eksz50H5FmVYcfagn0Tgx4dNXnOWLari76Pg8MDnPS/BBy7PBEPEIwbgU1ZK20D9N8xu8XQL+bB
 CqK9egWNFMVwdWXzG2qqsEQbNId3pcShVGx1YtvhEk6Hlbh2xvhq3LwAHZTuuskRbKOPGEGJ

On 24/06/2025 22:05, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series includes three cleanup patches for the SCSI core that do not
> modify any functionality. Please consider these patches for the next merge
> window.
> 

Hi Bart,

I seem to remember seeing some of these patches before. Am I right?

If so, what's the history? Has anything changed (in this series)? Were 
RB tags dropped or not picked up?

Thanks,
John

> Thanks,
> 
> Bart.
> 
> Bart Van Assche (3):
>    scsi: core: Make scsi_cmd_to_rq() accept const arguments
>    scsi: core: Make scsi_cmd_priv() accept const arguments
>    scsi: core: Use scsi_cmd_priv() instead of open-coding it
> 
>   drivers/scsi/scsi_lib.c     |  2 +-
>   drivers/scsi/scsi_logging.c | 10 +++++-----
>   include/scsi/scsi_cmnd.h    | 17 +++++++++--------
>   3 files changed, 15 insertions(+), 14 deletions(-)
> 
> 

