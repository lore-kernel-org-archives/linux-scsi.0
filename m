Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3C7357CED
	for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2026 15:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786376164; cv=fail; b=FBBnd092sBzWb51jF6kTYG3gS5S4d9B17vpBAZCvhaUh2c/KMN4k5D2UORsi6Ankf246nqUpBDMgCWRe7/6saQnsx7zJqQ5ZnOZ2JS2Pcucm/1/FF/D3nZ4Qk181syR8w0rCOhtP/PlSJv4aWE7UEwzGRCbS2IrFK+3azDpJeF0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786376164; c=relaxed/simple;
	bh=qSYwL8Aiq7CykWuUiwmAzLxS8N7XlRjUw7UE09+xQFc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=unr3+/jFB5hzRcZDoIciwpNS9nMKHJTkRF6tBusSlvI+UdSfU6uZXu84C33YhOCcSogCFV5VsZYm8DfW+34GVyqwSeyZssBqYtPuvH/lzquWt4T2+xH7/tn2MpHMrGQQK0FExhPIxmVHuPHfT0ceVbQMluTrxqtnci9eNh9x/fw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SGCCIKRT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lFkQ+lNh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SGCCIKRT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lFkQ+lNh"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67AEtxCZ323386;
	Mon, 10 Aug 2026 15:35:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=a5MKk/TtIz4ob9Qk9QXeM/q2kbV6U/eG5MxeJnVKMOM=; b=
	SGCCIKRTOv/1IeYPGasIaUYylPdxo00q9uKQ1dzflEfOv5MYRlcxIOJevyHJ/0hv
	hAYz+3UI4EhpKvEOYTVH95yyJ2uVZ5le24s+Okbp136HLdPmHOPB8i8PuHOHgk2R
	aUJLY2CBbR5HnvZIo2LA054n6YyDZOaj6uLT030mzinIwM1ha36hFjs7VXhNLahy
	T6HTYMXIeTcmjtrYhFt+HcpkegnHRAvCns3zaOOX2oFEabD/lzarsjQRtP1T/ksf
	y/awl4xmLF/YB6NSnjxGGEwcScBCtAuzA8vyjTHZLIhUb6D93848zcimqxW31epK
	gmna/ReSK+uQ+0vWLVb9rw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fwvkcjs2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Aug 2026 15:35:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67AFTjOi035811;
	Mon, 10 Aug 2026 15:35:55 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011065.outbound.protection.outlook.com [52.101.62.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fwtwqcun3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 10 Aug 2026 15:35:55 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c3EbcQdPysbxrsvuI6pASVISVp6kiUm0+0QJnrD+Um/kyTiUvWEAMRKPFFSfNCqB1cdazikMXSSHqRuOh/L60qHpcOygOxj+/4RCgDZ5zmri05ZrIUpeCwLL6Q5Js/+mmsHPa/wP6ORh+I5fp0KLhU1+gqWU1dtXYkLLa+Y/6TV+dqFlooTneWj921KF5XppRuRuUiNWfKaKGSuz7uhDmYdvVf09+YgAyN1kstach4VARBl0/AHW9O/BDVZkI3AjRqc5YuL09DppbZLySBcpNZZQXuShdjoORlXzNMtoyFg7E2i2pHP/OsOSJkaVK7I2HRNWwtU/LcceBiXVPRCZxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5MKk/TtIz4ob9Qk9QXeM/q2kbV6U/eG5MxeJnVKMOM=;
 b=W0vWrw/0KW+wfzyscWQ2mKpMb4bPSb/dkrQCbf1k/kCo6esbXGfpc9G9lB1OQ2j86dwDJsU6AVwtI06BbSm05xd+uy7ybUe8XZbbUolsX2dxTAu7TiVgMk00WW21Oq1W4R3aEy6WejnbAL/0WdTyhGBuuDFvHWOsxJQ4StRC2DRo59DoelGSuW0/yzUMCff4wYLPpPvZ4VZqQCmVwyNMTZzXYwmLWdsnMADsNP52zvVVNomGn79E1kxTvsDNZpFJ8sbs9NDZ2QlPPwK9jPTCVwCg+4OVQPFJHm6sITdBQhFOXDOLMNqUuLxqFj29F2QHGFN+5GQa69UiQj5QbQGcKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5MKk/TtIz4ob9Qk9QXeM/q2kbV6U/eG5MxeJnVKMOM=;
 b=lFkQ+lNhri+3quqP/jx9vGBy7wS0Acu0OkCAk7gzfxc1JMVl93hz4p1tao+WVnu6bhCR5SPf9PtBq+xlYcMJ5Dux+ClPT9kHPJ60GJ0nxnD6JJQFrzV2o4e6trKuPQUQNP/2kya/bfTiv5H6XYz8qg9r6T2NeDgBxQsNTWLEU9U=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.25; Mon, 10 Aug 2026 15:35:48 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 15:35:47 +0000
Message-ID: <f1e48836-49ab-40ec-a4ee-a21f6c01160d@oracle.com>
Date: Mon, 10 Aug 2026 16:35:40 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] scsi: core: Enable context analysis
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <cover.1786142946.git.bvanassche@acm.org>
 <2576d2f7e3530b721b5050ac6d25c413037d7e7e.1786142946.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <2576d2f7e3530b721b5050ac6d25c413037d7e7e.1786142946.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO2P289CA0006.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:6::13) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS7PR10MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: bc0e2bcd-a2c6-4580-a8e1-08def6f50c9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|18002099003|22082099003|56012099006|6133799003|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	UZB0/P09IKKN7mtI0Nvv2Xl9ZCiALhqgFuYXG8dXAZtY1kQfpLD3frrIavYcmkX1HnZjsRg0EMEYp3imJrFGkchyumnZR1v8VcECE3k4JOIJN9iYyEQxon/A8kTbzCxh1D8JsSFVYRvrDsCOB0BmOORrTx+cgOSkFK2sBXvLKZ+kIBFDQ9RYco9cBU/h9PQZDS0jRBRb//ciQI/gwSIhuOrCLWuol5YUGmdpmho9Khulpf3B3km9SWmF46VaD5/+xsJ+4uNNDzGHp6X+ulHaNvoh4v2S/PVE5smBz1zyrqyZlw3iHoeplXjYfnDIxE46TBrMaRPpoEe3Pu13rSid9GPhVP64oQ0n8BtSFw0jwvPSPCKgvZ2mYsnb5lvFg2OazwWlkLnFPCaLYumPVcCA7pQaVx5NqZIIOuRWwBaauylV+eFo8JZGXqtMU1YFilTQIUCkOo1QYhhrNE7EmzVWYmLe7BZwFqeq541n/77kpn2T7d2kXSt6ycuem1vCV9ZQ8hH1yXGRriPIjRX/B51XduMLWr5WxxnDf5/edBrFkm42DsAe64TaXSLbct8QG4V+L3eO6z5CqO/2/OSpOQ0tcqHcvcL+MUgRTJeSwohTzaP2zGQeiI8I+em+Rxt3lDYxSAwiyxRCK/wIJMiguFWyRWFi3tikFnvubvxQz0MHvrg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(18002099003)(22082099003)(56012099006)(6133799003)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWJTK3Y2WE13M3NEWGdHN3ozUEZNQmowN3Eza1NDTExMeGw4TFpUa0g2R0Nq?=
 =?utf-8?B?WnBvOSs1eld6QWYwMjFPY09HemdvWFBqaDVvcGRuRWUrbkN2SmhQK1V5V0Yx?=
 =?utf-8?B?d2xaV2JpaElpSVRuYlYzVFQ3SlNWWXpLbnR3b1ViZDRxYVplUUg4eThrQnNR?=
 =?utf-8?B?cXdrNjZaUnFDclk4SzlWOWNGYXJUalY5WVFlclhLYTB5WlVzRldJOXNIRU5v?=
 =?utf-8?B?a1VXTzNxeVBFOUpJbDFzS2NBaWhuYmZzblZrT1ZReDhoSFlheTZUUjg5NU9G?=
 =?utf-8?B?TDFmSitVVmFmL2NpZWpUSExaL0VyNjNiMjA4bjluZ0NUYTFtVEovU0tvRElX?=
 =?utf-8?B?c2Q2RTJhWTFJNnBNR1pDalV1REE1WXM3Zm50Ni9rMzRMUElndEVHWmtNTURG?=
 =?utf-8?B?WDliMWV6YXprejV6YUtpVU5wNDN6aU1pN2lCZUZudmYrU21nTm0zMFVqejBS?=
 =?utf-8?B?OW1ZSXgxQ0UzZ0tZN2R5RVJWOXFyKy9mM1g4SE90ZVhpcGpyUm9xdHdvcVY2?=
 =?utf-8?B?amY3M1E0T3NDOWVPT2ExL3M4Z3RmRG1KeGJ4TGNJS1ZlZmRpMDdzeExHZUls?=
 =?utf-8?B?cmZjdlFIYzhEQUhoMG9iTElTbnIwditPWndLTWVGdHhWbU5pRnhOOE10NlhN?=
 =?utf-8?B?NCtTSEoyclY0MDlpTXNhdlQ0ZVNzUml5cEplSVVhNkNmekcwd2loNFdIK0w5?=
 =?utf-8?B?aXo5RzNlVlJNOGtXMmU2R2tzcjdvbUZnckxCbzF2Skh4QXgyTFVxMFIzQ0hs?=
 =?utf-8?B?Y0xMWkJVUUFuTUcydWxINkdHUjlyeml2UjVuWXRpQlVzTVgvQkx2TmRucnZh?=
 =?utf-8?B?SGhoOVUwa2UveW5CM09mcmxlR3hXOW1acEh6SlRsQU9sV2gzQXVVWHJDSkpi?=
 =?utf-8?B?VVhjb0swNjloQkd4cGdmZ01mejlyTzFNR09LdG9ySlEyNHVQSkYyelhpWk5P?=
 =?utf-8?B?QlNDSUxYa1JJb0tGaTFWaXhqRnBRT1ljSUhWMXFVRzF4ekxOSHl5VHY5YnRy?=
 =?utf-8?B?b1hyeXNjVFVEVSs1RGMyZEpCbWpiMTd5WHBPMWU2d2xGVnBFVlRvS2R4bmtm?=
 =?utf-8?B?WUNNRVVrN3dwa0lFRGpZc09JU0ptUTBBQW1pYS9IWVNnWmRsUFIrVUNZS0s2?=
 =?utf-8?B?YmJpRThPYytNcWNIQ3VlajJLaThFdUhOQytyNWxURTJDVm5hbXVrdVZWelJa?=
 =?utf-8?B?cGd2OTZ1dEZXdDNZMytVc3huVnhGaDVKV0FFYzJJY1d4amorTXkzeHhCN1VM?=
 =?utf-8?B?enh0aVNsQllqdFZ6UDFOWFY4djZRS2d5YXVoTXVrOHNXZ24vZksyVlBsZUtF?=
 =?utf-8?B?cFY2NmNmRlJUQk1qeGY4eUFlcVJ5c0pUNkRRSmxGVEZySDdBWHdGNm5NRHhQ?=
 =?utf-8?B?SjcvV1c3aENkOXVQN1VaTXJ5OWNTYXlkQ3B2LzBsNzN3T2FvK1VjemtRSmJO?=
 =?utf-8?B?VkEzOEhBU24vNWtlZ2lqVlR0VVhkNjNnalFpd1NmS3JRd3ZLbzdObWE2clFm?=
 =?utf-8?B?VndwbjRNSXVkZEJJYmhPeElJM1Vxb01GNDVzMXM5elREbGthdTNwT2x3VHFE?=
 =?utf-8?B?YkhpNXA3UzhDVGx3UlkrYnJjcTN5aVo1TUFna0lJK2pmZWlYTWljdTcvcWVU?=
 =?utf-8?B?SGFsTnArclE4NFdrTHVjNTZLTnhwbFpJL0dLbmhEUDVPUnBKdExUQk01QU1n?=
 =?utf-8?B?S2ZBWVBqS3VzRE45QlhuNTlJWTZOU1dUR2RYeFp3MnlHT0Q1UTNXSU9KVWNx?=
 =?utf-8?B?M2JSNUswM0RmZi9qQkNsWHo5UlVodTBHZTRickNNTDVyUzBvemNjVis3Z2Vq?=
 =?utf-8?B?c1hSR25ENGdiK3d5VVNGRTNUYlFXdk9MV2JLd0xZRGhKbUdtNkVXQWVMOGpE?=
 =?utf-8?B?R09sdlhCVTFhYlZwN1RYaWpFbGl6TER5U3ZlQTFxS3JOWEtieHd0dXE0U2Fh?=
 =?utf-8?B?STJMdFowclVwNXJ4aVhTWnAwZUlLZ2NpNDQ4L1J4aklvTW40ZksvcVV0aXVV?=
 =?utf-8?B?TUFrcVBjR25nNE5MZDc2akFoUFhBOFdwTEpPWFdUWmtPSjFMS0hFL01wbVZl?=
 =?utf-8?B?UzNobXdnQ0VzUm1oa1Q4WENVVE9zTHUvNTVNTnV5eEZjeDdtanJUTjFUTlpi?=
 =?utf-8?B?OXRidE5hRUFkYW9EenFuM0NGWHJrNWVtcVowYlJUUDJlcjZ2bHQzV2ExWEgw?=
 =?utf-8?B?VW9TREtZYjczWDBlTitLbkRvMEcycnF5QTNOSFZpdmZlZk5teHUvNjBLNFh5?=
 =?utf-8?B?L29KTnJmZXorNTIvM25VN2VZbW5XbW1oQ3Z3UE1mREgzOGkzNHU5bExheTBP?=
 =?utf-8?B?NkpqTzhJK3kvazhwTVdKYmszRTY2K2tBOEw1dWxMMm1tRnk5bWtWSTFnRllh?=
 =?utf-8?Q?De660zpK6vJwzSGw=3D?=
X-Exchange-RoutingPolicyChecked:
	EdIHc1OtijRvxdKECekcWJEfeOMC3/C4bYm3L3WLLMlknqaakfkDnN3fKtwbkAKkvbhBvS5+BPubTXk/rK+lupUBcxKM1Ljc8ruPfSJk2BI+BUSPn/UbvTOTFzNw3ufAsoqRYt5UUtlOjaXFwpk9vf69CtIYiPh6+9WHb6yDiehcbQzNbSP6R6rJ0N0C6NlEoaHSWnoZRl++Q+zL6tGJQ3LK58WJzK5Ovspjmr7bggJsvWStXvq8vAxPJw7PQo34Le3vgnGQ6tWBjOSqU0gZc6c9oe0XIZ9ptc3IUXMtF5rwcopxtZ5P1SvlNN5tDC3bc/OrhIrXdSRy3ZiHvvrXbg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	n9uNF6qmc8hXejSeX/M4gFoXiKruUFsooSpAtJX84qdfMO5r4BACX8EWRubGfLQVgabQlTifYJDCL3oIIDsILLznpF/g5De+6n+WMsSFsEUpiBs2FAprq8xQH40WYV4caa0uTvanGTrTBsykxuvRhYfxSIuT7GWSAGeFxpCVf+xAbYkvkUp2gFEnkkW2xOnK7phoC7DydDkI3Np6VdMM/wYY++dFuhM6kYqPPI9xBtWp72tgM7SEOADhKWLrdP1yAHXtsUyjtxf8VzJqHugxQL7mSPENtS08LY7W+kEgm7T2P80m0R7WTciCe/baDF87B4JNUjMVSqo57B7A4fPhnmgcSx2XiGqFkCp9ETvK9pVWpnlMEru1+6cBYIRKQ52LeSH6pzgfKS21TahEFsPymSjyfLlHdk1WGN/0dpk8fu4zefpsYKLXuBborR9YVhSRfTN9xhKQyqk2EbD89pz+ItE7vfuq5smqy2IS7GzkFnHMqDx8mXWdM3pIou39IEuH/5HI4UKsDhHMvBk/JxIMPwc77VZCmFu9h81bxXRjsqzfMK59C0tiRLzjZ36astdiPrtnjh29MFwcI+GkodmWxDaILd+78z3r97CEANPLJns=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0e2bcd-a2c6-4580-a8e1-08def6f50c9a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 15:35:47.6530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlC4WMiaZqxv3LB8/67sKhs955Y61qKjGqDvrOuv/V8cY2JjwNQdDpdhsZ1JSP57it5PnPCWWKjXz3zs2uELgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7129
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_03,2026-08-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608100133
X-Proofpoint-GUID: T4cA5b-eKxxChRj95JEQDzDG46XXX6yR
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEzNCBTYWx0ZWRfX23KDu5mjZh5H
 dStSTUoCsR+elZBhmAXmxdciMoOkgD62f1TBXJlkQZHxj13Lf/baiG61vqJkzszGu8nXIKN/qFm
 bJQKg8vXJApkyF+StLLFWKSWWz//hPDQ525EtKb7Gg9Xe8Rh5yIX
X-Authority-Analysis: v=2.4 cv=aepRWxot c=1 sm=1 tr=0 ts=6a79efdc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=N54-gffFAAAA:8
 a=yPCof4ZbAAAA:8 a=idAuSsGtpWwOOgcs1UAA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510
X-Proofpoint-ORIG-GUID: T4cA5b-eKxxChRj95JEQDzDG46XXX6yR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEzNCBTYWx0ZWRfX+J0l2xYkxMAM
 WM62UUUXUDACrwuskek6MEirDgavW1rq93hFZc0Eg44YPg3LjjSMNOWlxl1/XXPpF+i2bwU+rpC
 vbP6h7/o3OwJXlTkAnPEAMMY+fIqElCNER2L8CIe7ICPvUJlNMkndxFyDBkrFV6yZO5JPkxPXbq
 wFr8Fin93VwlemVM8txhNt2AstUZ+3op7A7OuU2meCF2lMenK1aHqbLlEpAAZbWiXGdnnXdppE9
 kGBALUgv3GwvoFcpEPY3eh73BzugxJEgB4vquC7ZPz60r7Ts/QUkNoAbuPlShrDkz16326i8r0h
 0oWUwvyIqWgpQGkBXvbhHZUibBeLUEmP/Jp8tLLUIGv31pTonYL1MAoj0LI0pJWvUP814jf6UEV
 PCzyd5vL7kOW2Qn7DrIDTWcDhhnHUkXeQ2EaWAn356A5uDgw21/O8VkYnlnAlrZm4xQ7UZrMSVr
 y2rqcyDMF7TLH8g9KG7Bjf7XrbtfY6MT4ky1vUMI=

On 07/08/2026 23:49, Bart Van Assche wrote:
> Enable context analysis for those SCSI core files that build without
> triggering any context analysis warnings.
> 

It would nice to provide a reference to the patchset thread where you 
are fixing warnings up.

> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
