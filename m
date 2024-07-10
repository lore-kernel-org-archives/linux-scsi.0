Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD16529D06
	for <linux-scsi@vger.kernel.org>; Wed, 10 Jul 2024 19:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720640054; cv=fail; b=PYQ2etJKZLgon5rF3C3Gy3CkYRkKyIU84ipS/E3CCgXm6imklku9v9Om6x8/54XE9I5BAgO/w2QGoEn4kCIh66YwZ6hiqNk6UaMsnLJ9K7TJK3pqLD83fhOFFtiQJfIzdEfB++KyUAiReAJZ4RHoQnuPwGLAgnpvVSK5FZra/Q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720640054; c=relaxed/simple;
	bh=d1Uue/7D6eGwT6pUTIFR5+i+JsLjwI2KD3XHZFiLcbA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nCTOkefS8vaoc68rHSSis/N+UIcH4LP07nO6ypw1vI6R5/YM+jknw0iRNQkKPjhDz7UL2LUOnlS9MKssBy13llX8gWZforJGVjzsDBNyI2ttJIKv4KfYh2epwtDhND7MW49Vr6cX7FJ4h3stCWtLa49DoGeXy9dDwH9veTo7lk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E/rIbh5+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ksT3SHKj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E/rIbh5+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ksT3SHKj"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46AFqOcY029616;
	Wed, 10 Jul 2024 19:34:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=3hEZIx58GzdS4h+WE4IZ9kjHaEcvobCuL1OXRlVM1yc=; b=
	E/rIbh5+D+7nQwqM5tVvZZLMkcWWbka1iDSDs28yE0qWVhJ8veg3SI+oICiHJhnk
	v9F3AouemD4rCJdgsWmCrXdDGiOAFFByZKeJ6bapSJaCU58jgW8lDUGis6WrwmLA
	ElMBgm+3eNVbNWCOcXcBjaJxhZlqrpODN3YERggOiRetAjsMfr5SwXOtJ7U6xGy5
	Xeb8/lAmE8B7TmCx6hX8uBYrLqEsWQmSSNk3LvB0w1Q5lgDsuX5ntAomFo65FcoL
	WqGLaOIVg21kYZBxY+PIo+hR6Q5je2ipkGQSt9N2svUxDEK+MPZ5dm9r5Wl0hTNi
	22Ud6a/Zf1yjg8xhedhUNg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wgq0316-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:34:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46AIr7HO010787;
	Wed, 10 Jul 2024 19:34:07 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 409vv4skvq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Jul 2024 19:34:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsX7Z+t21FLywR4REEVsoCo17bsWF6k22AtdYqIAIMYiM9QIJf456hbrdzwNF+hIxvRlCYaTJakmly4oytweEmds4dqUc2s1YYztG0qXeUMqCeBvYRfsCu5Vy25prX8LCvigm4O4rKK90Aa21YTcoNv6WVE0f1XD0oQ4XLzC0ZsEdXEQMsF2wdd8vhR0oUotKAZhLkvpTXjoJXsjOEPyZ3SMqY6dPCpIWN8+UaEt/AbkXOP9q1LGL8r7X0kQYr6VtVvrJhhDd81p/o+pJpB6PinwTspajMhgA/b4JpUObziASwMl0t2Rbrx4gnpChywKBlHBNgOWap/GnUwok2rCSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3hEZIx58GzdS4h+WE4IZ9kjHaEcvobCuL1OXRlVM1yc=;
 b=dKiiD4QQZxKnAIW/BmpreQf39/beBzB9QOnObNedh3zV5ZHQh75i4V9pAmgkA6olBgOHQJKgK6xHSzLP07GnD76XHErCT4CIFDhND6V7vRWPxVw/CGT7OJszAzeghbbiu/2Gxb+Sw9JMwVbHvq+poExqQuEOTTMuU+AMXom60YY+PaOUhbztZPVjgz9767ZNhGvLw8BwErG9tW7+muVbFGiMBjr+LL1mnAbzu50Q1aTf8hXivw6mw0DeGvs5lArcS3rXksX+ADPPh7gyxug1ZfeZ+ScvomlRq5RtL4383wWr35Rf7aozLGeEbfMXX+r2toRXQdEdf0yFyeVtSRHH7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hEZIx58GzdS4h+WE4IZ9kjHaEcvobCuL1OXRlVM1yc=;
 b=ksT3SHKjjswbbM85bgF6eEphpB7tl/H3G9lR3XylSNeea5SkH1Y7gCebiM6xfpuyUuHtPR+vXZn87veF3rCIpeedkJYHXD941lwOS5I5TS/KvWu1GTN8pL+tzxuVSfs3g2Oq53MlGSgAaYhh18rqOjzaPK0md1Nz7B5SVzc1BQE=
Received: from CH3PR10MB7959.namprd10.prod.outlook.com (2603:10b6:610:1c1::12)
 by LV3PR10MB7937.namprd10.prod.outlook.com (2603:10b6:408:21c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.38; Wed, 10 Jul
 2024 19:34:04 +0000
Received: from CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2]) by CH3PR10MB7959.namprd10.prod.outlook.com
 ([fe80::2c43:cb5d:a02c:dbc2%3]) with mapi id 15.20.7741.033; Wed, 10 Jul 2024
 19:34:04 +0000
Message-ID: <7fda0b6b-319b-4a65-b8b9-74d2370f6528@oracle.com>
Date: Wed, 10 Jul 2024 12:33:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] qla2xxx: Return ENOBUFS if sg_cnt is more than
 one for ELS cmds
Content-Language: en-US
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com, emilne@redhat.com,
        jmeneghi@redhat.com
References: <20240710171057.35066-1-njavali@marvell.com>
 <20240710171057.35066-5-njavali@marvell.com>
From: Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20240710171057.35066-5-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:208:256::13) To CH3PR10MB7959.namprd10.prod.outlook.com
 (2603:10b6:610:1c1::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7959:EE_|LV3PR10MB7937:EE_
X-MS-Office365-Filtering-Correlation-Id: 978fad4e-82eb-4072-9347-08dca11741c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?TWhXTnNxT0xjY0VjbXY3SlFzRzZ0TEZZdWRxN0VSdG5zM2lkZXBPdWg3c01i?=
 =?utf-8?B?Z21jdDNocGhrMXhlWEl3Mlh4S3RIeE5MUVNCZlhieTNUa2FWVEdYaGJpSGh0?=
 =?utf-8?B?ekpVUzFBU3o0N0orRGc1UHlRWXFBQzJNYTNHWUMyOHF5alNKUXU2SjJsQnRT?=
 =?utf-8?B?SXM3NG9XcmxyYkNvMm4wVnF4NnNVejIrQ04yTnd6M2xqV3gySnpHdWtQN1VE?=
 =?utf-8?B?TDJPOGxPUjdYd0RvcEltWUlBQXFOOTNqN2ZSdEozNGpJZEZZRTk1ekhLVm40?=
 =?utf-8?B?RklTeUhnT3dtSHFRanIwRFNBNFM0QWRBZk1VZ000aHNjUkh6VklZejUyaDlq?=
 =?utf-8?B?NXlYYmcyQ21yNmFKeXJWNW1zMVZQOHIwd0kzc25FYm1YR0dVRUhPTmNJbkdh?=
 =?utf-8?B?YXVHM1kwMUtRTmVzaW5BZWo5a3RwbDV5RzdHNWRyOWljdEVGY0tBNmk4dEds?=
 =?utf-8?B?WkJmOCtkTU9KK3JhWm9OdWFzclMwaGhZWEVkSDZOSHU4V2dHenhHZU5Ebk4w?=
 =?utf-8?B?bnk5SC9sZnpiUVRzMlA1WDdML1BtVkdOWExZclQxOFpkVWRuWGRncWY1Mmk0?=
 =?utf-8?B?eEM5a3NVRUNOVmIrTW9TSTBlanhIUEQ3U0V1QzVmakwvWm1aQlN4Vnh3a2ZG?=
 =?utf-8?B?UURGSGR0QyswNzd4MjZRZG5jcDhBblc4QU83T09SMVBtRDVKQlhrZkxQQ0Fq?=
 =?utf-8?B?NVo0bDZnVHh5Wk1nV0ptTUJCbHUvZ3lyN0hiYnNUeWUxNVBTMmFOWFdjVUZH?=
 =?utf-8?B?cG45M1B0UG44R2poOW1rT2lSQ09zNlJzLzF0alJVdElWOUFCdWw3SzdTYS9B?=
 =?utf-8?B?U2hqcXZ5VDdDMFhYWjhKSlg0c1RzVk1WZTVORm5hWk1vVWpRNEY5cU8vTkRJ?=
 =?utf-8?B?Q0g3T25uUWRZdDV1TFM3QU5Fd1p5STlNZzlIVUJpT2xYMHpOL3o2ODB6dWcr?=
 =?utf-8?B?UmpVSDlyTE00VVd1YUJsc0dXaEdmdnplTXd5dGh0MHpVZ0UwcXRaOWR3QkVl?=
 =?utf-8?B?ZjNWV0RKUUxUcXJOdHBwOWxmcHAreFRrbGtySEZ4bWV4OStvUERrQVAyVVk3?=
 =?utf-8?B?ZUlFYk0yNHUzZHpTNUY1UzRHekEwZndNbW43MlMrd2R6NmlkamlIMmt5Zmtx?=
 =?utf-8?B?SUVFdzFoaEFrY1ExbHAyNzVxSkFEUFQyZW9wS0hocy85N2syZHZ2b203d0Nu?=
 =?utf-8?B?bWJzU2NzQ3FFQ0NKVGFDV04zWnFKYnRrSjVqL3g0NDFwYk01aFdScC84LzZz?=
 =?utf-8?B?M2FuNUFMcFFOL2N6SnJmK0ZLRkRnUjhiRmgwbWthdE0wWXh3VjdkSzhJdlJh?=
 =?utf-8?B?aFZuY2N2WWxWZEdUT3BIWDh4dm9kUERiSUd0QnNYTDZ2b0R0ZFRUV0JKVm94?=
 =?utf-8?B?bUhtbzBRZlZGUmU3bkJ3L29jZEgreERyY09WR2pBNWVwY1NNWkxmRFhTMGRN?=
 =?utf-8?B?VFZyTzF0V2tLRGxKZ0tNQlM5Z3pncUg5Mm5WS21sKzQ4OWxidUkxZDJLUnFF?=
 =?utf-8?B?anBvdHo5aThrS3M2K0U1bVFaQUNmdGcxYlQvYVhNeHdDTzVqSHh4Vkw0UHVp?=
 =?utf-8?B?VkRKSDhiTjZ2Q1Fkc3RDalVjQ05TL3M2Q2lEbGVxVDh6eHlCNGZUbjRwc014?=
 =?utf-8?B?VDdONFJuRk92RGtaeWxQTW0rYmNOWkdhcUM0QzczNnFvVWV3OU9CaThGSlVM?=
 =?utf-8?B?Vk1oUmU1Rkxsa25ZT1N1b2dCU0w5ZWZQQkd1eGFBT0xnOXlQRm5uMk5EVUc1?=
 =?utf-8?B?S1dETEJrcWpaOXl4VHBnT04xcXVyNFZGQzJTUG5JSVB3Qk5CSWM5NXdLV1Rx?=
 =?utf-8?B?RXA2VWJ5Uk9wSG9YWldTZz09?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7959.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VEJObmpIWEhHamJsRURpOUNIb3d0WFNTZjBOWEJUcUd0NHlTTHpTTlBlWmE2?=
 =?utf-8?B?enpjbFRPdWV3N1pnS1VnclJlQzhTdUNaUWEvTkd3eWRaRGNBM2cvdkdrTTBO?=
 =?utf-8?B?SUlBb0ZZRGFBQVYzMWZsZzF6SkY3NmVMMWpacU5SNEJZOXo5N3poZlVTUzhK?=
 =?utf-8?B?ak5NMkIvRjVOUEhlNjlKeFJIbWUxS0lKYlFWV1loaGg1MnExczFWY2hOajhP?=
 =?utf-8?B?TXVvbktIVjNoUU0zd3RJWDFqdGNtSU9GVitCZXVnVXh3ZnR3RFNIdEI0Vldn?=
 =?utf-8?B?d1VtbTcwYTNaS1lsb0x4eFBWZnFYNFZ1UFBnTXVRVHJpZkxQeVlCQWxvQU5X?=
 =?utf-8?B?WUhKY3BOcVFNaUtMNGZzVFhjSFF2VkU2NURWSElLMm9lS2FnSm1tUHFmVHd6?=
 =?utf-8?B?aDREZHE1cEoyWlFQbzBjajZUa3ZUbHhIY3Z3bysxVjRXeG1Sa0l0U2d1ZXVC?=
 =?utf-8?B?ZkdIZk1BeG1mQW13eXY2bDIwdERvRjdlNzl5QnpBejFhbDk3R1c1bjF4OUlw?=
 =?utf-8?B?U2gwck16U05JTnJWaUphNFJJeHl0ekhDSFVVWW0vUXlNRnJXNGQwc05lS3or?=
 =?utf-8?B?bGptcGN1RUJwZnpBQmFkbVB5Q3dLN3p4ZzBlbDF5cUc2T2Y5L1QwcEhrb1NC?=
 =?utf-8?B?aUg5Mk1Ea0Y5a3djUDIyUWU3bjNRaXVUU3FLS29hZ1dPK1hTSVBJcWEwRDlM?=
 =?utf-8?B?MUdnU3NmUEpGSEhUWVBpa1UxazFBejRDbW5SRmNwTXFNdG5YYkJ2UlM0Z2Nv?=
 =?utf-8?B?RVZqYVIyNTJrVHVPaXJZR21sVHB5YUo0QzIvN2lKc0lWL3BXS3R6ZEpVb2dz?=
 =?utf-8?B?c2JxY1EzQkhFcVZXZmYyblNEaWpnTmV4Wm8wMGxCb2syU1ZKVjJnMUw2eG9a?=
 =?utf-8?B?a3luOG5ZSjExVm9wU3pTMGJSeUZaVUlxM1R0NUdRZmVGRzV5VDhOTVdvR1hL?=
 =?utf-8?B?Yjhua0RkbTJZTzRXOEwwdVlRRVBLNjQrWndMNnVrb2ErZXNnVkZTZlZWU0Y3?=
 =?utf-8?B?NWRzWjIxWTVWbTN0d1ZlcEZlQTcrNlVCa0tRYnZMQ3JJWVZNd2NVYW14eUFB?=
 =?utf-8?B?ZnpKeGFHc29sVVVCMFc3Y0YxUHJrRjBOSzYzb1hJRVRWbjlCOFk0bVFjZTQz?=
 =?utf-8?B?eUtuSnpkcU9PbkRVbEh3VmROR01jZVFoTDhGcE96ajlSMXh0Vmh4Z05BcVFr?=
 =?utf-8?B?R3lXWWxpWUM0TXd3SmRMZmpRUUU0NEU1NHU1Z01wUGpXYVhZUll5SXNnd0th?=
 =?utf-8?B?dEJIVk1nc3dFYXhoOHh1RHI4dVBOTnJJYnJhakJwd0diK2xNb3c5QlNaQTRQ?=
 =?utf-8?B?RE03MHdvUzdzd25oQ3ZBMkwrV1ZZRFNwU1ZSUWpNNDluNVVTanZWVnVMOUNX?=
 =?utf-8?B?TTduSG8rNERFamd4SlhCWXdJMnkyaWRWUmtaTFNReEFuN3ZsRUdBVFhHa2Zk?=
 =?utf-8?B?a242M3BjeitrNnlyOVpoaWxUM1pQMHBzNjkwVUNOaVhlWFR0OURoYVNBWEZT?=
 =?utf-8?B?QTMrb1R4aUJ1SDZVMlprOWdHV3JRbkFXMTQ4dTJzaGY3aksrWmhUZTdkcDU3?=
 =?utf-8?B?SmtoVVZBTW5mRS85STFJUWViNTFDL3Z3WHpmeDVjdW9uK1RjYUVBRHRNb0xS?=
 =?utf-8?B?U205eGtnSy9jNitaaXpDYXpONUxEdFIzTWpCRmtPeCs2NVZwMFhPMzJJU1l4?=
 =?utf-8?B?c3lhc0xqSHZZQjhTdHFWMmxPYVh0NDFucjIxVVVPMzNLMEM2M0ZnWkVrYUpY?=
 =?utf-8?B?SUxuOWMwWjM5K21uT1VtdTdBOEZHNWVxWlBZeGUyWUF3b1d2S0xNUkJoSVRk?=
 =?utf-8?B?WEhzMERBZjR0bnEwaEZQT0V6TnkrVGdFN2hQL25SYUkxL3MvbFBYcUMxUkhN?=
 =?utf-8?B?V3BIQS90TjJZVldlQ204eWJvOTQ4Wi8yTTlqUjA5TndsUEg0R21XeW1JN3Bt?=
 =?utf-8?B?dXp3SUM5WUhodDkybzBUR0I2ejh6TUp6MFRKY1pQNVFZYlVwdEozd2YwMWl5?=
 =?utf-8?B?M1pESXFoZEtCRFlJNUlOZExNeElPZkRDajhiUGpkWHlmdWRxdXBmZ1R2NWw0?=
 =?utf-8?B?bVE4ai8wZWZhbm9yZVNLakVRSWpWWlIvZ2RqWHBJVS9nRU5sZ3hsR2VDRmZm?=
 =?utf-8?B?R0R5RTNiYU13b3dNcTg4M2tnNmovVUp6SlJyc0VyL25HV0txUlBGK0xXdVlP?=
 =?utf-8?Q?PpKOckEkfitMv6VA3LrrVvI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	1PM6YjbZIreCLyEutTdPjcuRdHozXSxz3htHQsRrXNJVVEUkvZz+PbunBCfW9onBYh/Dwtx3bGfS/Hb5ZiWsxM4JvNfGv1GvFzDZ2u5bhi+72Fa3OASqMfFKsg9MdXqB6WMjTNTkLou6D6xmh75gevmfrtSIXo8D8v8LC29tBVCtbz7K8rspm4bCEwbZZbEpIR66JwJ24pLyytXuo2KM13M/bZc5peevrzBlAe0XAObR1K2fulzh4DP8KFkHwqra/0DU7CeeVcPvCyWGsygEM34eMNK1mrQkgdVtq/F7px54LseRav7nozHbIzJtqQUrbuA06IH/1xDah+9GYztqNCA3GqGoIdleM6UMXu4hcdRvgMFtmdJxK4oYyVS+eNDl+uEe1b8lejzdxstkZwA8t/yCDUtWyNYedXHkEGD5eM81JPX5Fbdg2hoGmQyzz74jDDZ9zExquh6oLmzacegHZ9Dy2q2H6gwRgreUwh0It/PRczF+YazLS339xdxUhDQ5E7S+/LRKRZv2IlQMtGotD0M0OaXT16Oqh/T+UkpLycG/VHiR2T73/WZ05Re7ggkiX5CEjHuvnKM0e4azskW5fHyUFKf9GsMTYGz0EKJa7Sw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 978fad4e-82eb-4072-9347-08dca11741c8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7959.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 19:34:04.1335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ualycKE+1qRjKbBbNJ1LJ5TKMId4ppz0R6sUiH2j0T9U3WfYwi5NY4MPo7W3T9uztqg9o+Zidlvw/s5RNEXM06q2/9EQUnDAa5nz23+gzts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7937
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-10_14,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407100138
X-Proofpoint-ORIG-GUID: 5FywuMog_B5vhjKjGcVe33knp_4kRrt6
X-Proofpoint-GUID: 5FywuMog_B5vhjKjGcVe33knp_4kRrt6

On 7/10/24 10:10 AM, Nilesh Javali wrote:
> From: Saurav Kashyap <skashyap@marvell.com>
> 
> Firmware only supports single DSDs in ELS Pass-through IOCB
> (0x53h), sg cnt is decided by the SCSI ML. User is not aware of
> the cause of an acutal error.
> 
> Return the appropriate return code that will be decoded by
> API and application and proper error message will be displayed
> to user.
> 
> Fixes: 6e98016ca077 ("[SCSI] qla2xxx: Re-organized BSG interface specific code.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index 19bb64bdd88b..8d1e45b883cd 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -324,7 +324,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
>   		    "request_sg_cnt=%x reply_sg_cnt=%x.\n",
>   		    bsg_job->request_payload.sg_cnt,
>   		    bsg_job->reply_payload.sg_cnt);
> -		rval = -EPERM;
> +		rval = -ENOBUFS;
>   		goto done;
>   	}
>   

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

