Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3A13D666A
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 10:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779272137; cv=fail; b=F/+/eCQ5l7w44/tOeO5dhQddf61Dv3M+Lmo3dTAs4WISaq8NO2HhpiW0y9P3almgy3bq2J4Qsz84bd6VzignU/lklTexLfRNd8rOaTSAStFrdR9mLJAgfPGHJAIPUlGFGJIw5qpWp8gd0cCroto9fIUp00l9NW6CR6KvAOLCygY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779272137; c=relaxed/simple;
	bh=Bo0rxBnq9dBKwsRhQeqD6rA9OTa1akhzFIftcW4BtQo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=L7ZPm/d4maZhA3tXzhK6lENzvaqZ1TTZiKq7EfJHu0lum8ZgZB+Fd7m8UuGL4hhyqxApIY8rt3LSmWW/4GNDpSYnyY8f6aDa8G3FAKeelV2cHNAtaTQOmFsjKg6ES7o4rpq0MVyB81Pd1fuKPCBXnS+rytYiPElI2ZOWQu8B3iI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BkMzp6uS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=l0K68owt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BkMzp6uS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l0K68owt"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64K8iuBm637952;
	Wed, 20 May 2026 10:15:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=DaCKoTb3Glk/FJ8UEd8xVK+rKuO/If21nk0RqPg8cpo=; b=
	BkMzp6uSW8p4BPclJY1ebTgSEbhs2zQA/5jgWEJ1ixNqMsKhom//oWrPj00IGWOW
	iKfSWHeCoKXf8vJiM9jBTPPuo2LgaC1g/BEc/HVs6lhFud6It+e9GIoKQgsn4FHd
	+ljXihbNbqYSF86m5J5ugTQmffXWhBtISDRpZbecZ0VjjVw3RAU+iLsCex21sBy4
	426eEh7JokOE68sGpiv4vklLe2ajaKbxTR1CCQz81oQzIrFeMtAVxfhZ0OPQO/In
	ewUey85Aom+wdivQe1PWGezOEyohRpv/qn6UjvsjuKXf8/sIo5x2f6bN0Y0Tg6VI
	zYLyRNxeIT8WAcrNYW256Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h2senhg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 10:15:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64KAErqc037506;
	Wed, 20 May 2026 10:15:26 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012044.outbound.protection.outlook.com [52.101.43.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4e6f1grwkd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 10:15:26 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YXajZPZoZd7QEI5ZqBRSYc/ZmDYo4B3h7a9LDEcih1amZMvDHzv51+jakdJ+3g++ho3hTe7+8FUSV8waWPStfrbLcUpErN7/rFJux1KGJo6GUuXuieS74B2N9p3Lep30MdaG7vbU/rE3VQ5suuASenvxIxvwEsZ3agb/1pq1DOECntR+hFufwM3lYQcBa7vrBmI42pMVchSB1yyqumBXIyk0rZhGqYeDK8z8uF6nzoWCeo9VgswHyVtbtcwUIzNeksW7NOFIvetZJ2bGEGZ25wRW7L36scnZH4e4xinrRVL5MQUWOInL+EX+1OusG6HiQXcszFA2u8spxCJYSKIC/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaCKoTb3Glk/FJ8UEd8xVK+rKuO/If21nk0RqPg8cpo=;
 b=gYjMU4smxuMPsFj6ul6dPndwJFRfYRx5nfdoBasbKU30g/I1H+sKMIX/UgudQniVhsY11h038IY2BUBa6WYX+cI4JigKoMAoGCh60WWZBT9dzf7zBth5/TgBI4kc47DB6i5aWRTVJg4XO0KZ5ZQ18yiKDp0BV2icr4HnZhjwmCwbFKhW/NiFvqDOFXgwXtGPyEy0iDot471HP70vqvOeDdqIoz4ZVqguh44nKQdO3E1Xuh40MhTWbxO5lXblg6sRtKwGBFfJU2CdfUYnXFkbjJxUXKrQLs6CJ+cgShkSVVOsW/yWjISzUd4/CANcCbfiuyG0G2vxJth+/V8B+2ckCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaCKoTb3Glk/FJ8UEd8xVK+rKuO/If21nk0RqPg8cpo=;
 b=l0K68owt3gwpPuktmBkGM1YTFGnoipq4jw8vVb80IvuVKbUlVoVM1X34nSKYhQdyPzUxc9s5zeqOMZYv+B1S00YWvpyh3DUG/RCaX8SD4q95+ZhKiVuiqgulId+2uyvRQCJ4p4yMYW1JOYtbX6N4LTBWeYXUAggMIroHJdutP5I=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by LV3PR10MB8036.namprd10.prod.outlook.com
 (2603:10b6:408:28c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Wed, 20 May
 2026 10:15:19 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::9da2:46fe:4d63:a74b%7]) with mapi id 15.21.0025.020; Wed, 20 May 2026
 10:15:18 +0000
Message-ID: <0ea1d7f2-0ec1-4dad-9785-3c2a5e3568ae@oracle.com>
Date: Wed, 20 May 2026 11:15:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: Remove a set-but-not-used variable
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nathan Chancellor <nathan@kernel.org>
References: <20260519194106.2534147-1-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260519194106.2534147-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0397.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cf::13) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|LV3PR10MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df11482-6b3d-4d14-4c92-08deb658b186
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	EJ6Us85sOMKISl0pNF1fWT8JKEWD3RztmbmW0+rzOwWmoUPFyGE4Za+AwpbheSZ+COPmjGhWTAamMDkusv67wlEYJSPO7kt7d7NSZhK3UHGqYPOxiCtsdVkOl3xznBgvSeO64yraL2tud3v+NQe8cBZkHrEFbRwbJf5zepjBlW7FTMtnwP0/RlCT116OFlJY6G7CAXpAKjbZtOgr48iGQCDVWyxDVg8/GKZxtKFxtvb8sN3pmC63r3l2HtWvU8+1QLtaFOWQSROMWmNHWnkAs6nPvLSm5XaraGI5416kbOFs3PkgiJ+Fljp/uzHyNKbhNgbv5PbJzXGWsZxRaOMzbNrwmdQQK7iMXjd+NR9GJWpJEGoMf5DbYniBBu2NoZs5vQGsPHxGRFRjvRVyRFvOJIXpXpDsKj8ILBU7mMRyCW+RPHq5PQznROCFi2Lv8vB4XNf9DbjOweXsYKVBczcAtDkkv5Nnxp8hkmwjzkfzUKpk1EcO8Exe8XySgdYn+JTYYsBwEJCghr6+9gzamLgxQ5i8D7pus8D4fbGPzeMFSMkmKUBNSJ+abun8vachJmsZgT0UxaicUCRgDaCWVLYGbmWYVrwQgjHqKKe/27i9wHbnT5IyY/OQKjC1tX4am8NUStgnBvQmKu70k70Cc189m6rixRZE8ffcbHf3Ak6gbL514LZrOIRqA8XHs0puNvwp
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SU83UEJKTkdPdm9kZTRGL2grNTRCRVQxZ3U4ZTN4Sk82OTdMTWkxNHJqdjhs?=
 =?utf-8?B?SHJlQnNQVkJkQVViNGJxZW10VFNvQ3FvcklzU3lGR2h6Uk9zSkVYeTA2SXFD?=
 =?utf-8?B?dzBBMStOSnlzaTJwTmlSZWxPbDVKUjlWaUlGbTFsbUxUa3BJTmxwS0FORzVM?=
 =?utf-8?B?R1RIbk9XKzdyenpvdFBlclh2YmhrSmpBb202UDRzM3VyTEd6MHdXaCtiNC8z?=
 =?utf-8?B?amttZTJqMnlvK2pQNk9KZVNGWk5WK0k4bklOUTdtdkVCN3A0K2F1dURYVFNk?=
 =?utf-8?B?K2lYY29NL1h6YUh3NzBUMzBHbXZGcjBWNTNEak1aNTFkUFNNTWFJTklydHNm?=
 =?utf-8?B?T1ZYc1p3QjQyN3Nmam9vajN5aFRqbjI1SDJ2L0I3d1Bzc0hKQXNmMUNaNmV6?=
 =?utf-8?B?UitqbkZDdmRCa2NCKzZuSnFVdmx5Ui9UTHpuQXowQVlXc0JOOGZGR3J2ZFBk?=
 =?utf-8?B?ZWpLdnI1TlBnbWZhMFpFV0VLRnhaMDRMbFRYSEU2Q0xpakZFVTl4M1dzenBY?=
 =?utf-8?B?NDdMQ0xxaGFIZXRGbisrajZjaXVUclFkUnpNT0NhTkdmYnBZZGwxM3hRNjNX?=
 =?utf-8?B?VC96UXlTNUVhSkJqN01Ca25EME82dG9VYjE1ZUFaUXFaamh2Z09IazcxVmZ6?=
 =?utf-8?B?UEZUMjlRT0xmWHJEZVpzbnVqQ0xpYUNCdTdoTUxxeDVjR2VwbVp5N2ZtVWhy?=
 =?utf-8?B?UHJBNEY1dVFIWWp2eDE3aWNsQ1NmZzVMblpadk4wWGxHbWhoSWRaaFV4UUQ1?=
 =?utf-8?B?eHYyS3Q1QkY2aFYrdlZ2SmpaR2QyYTE1ai9Peis3ZGdKYmhCMmo0cXlCaVUr?=
 =?utf-8?B?Rk9CUXhlZ0pNeXVMOUtBMXU5SzNEbU1DMHpQSUV6Q1V1Z3phNDFHdVg1Mm1Y?=
 =?utf-8?B?SWo4S2s2UjZOdVJBVnZkVytqYTdOanpTd1YxV2lJU2w1aHFKWTQzeUVSUWVQ?=
 =?utf-8?B?QVNOeFNobGxETnd0ZWJJMjBlK25GK2daeFptNDlQQkpDa0RFeXlhdXUvNkly?=
 =?utf-8?B?c0JyYU5CMlJyYk5LODk3ZllmZW5jUzlIS2tsQUllaGpjelpYdXF5L1FUM2c1?=
 =?utf-8?B?NTJsQjhKdi9teDFuVWpxeVVEd21hM291OGJaYzU1Q2JtVUt3V2FFcHRlRnVZ?=
 =?utf-8?B?T0J3YlVtbXE2cmhYcFlYeHlicXNGQXFrYWlSbGVjRGR1N3d2OFhqbG15Wnp6?=
 =?utf-8?B?Q2tKZjZhSUVDTVVoRWhHVFNLdVVTRi8wcmNkcnE3cFFkdUhEZ2tCOUl3dTVR?=
 =?utf-8?B?b1U0QlY3R0FpMG1ia3lBSGhBdE41aklRUW1YNjJ4SkcxUStwa1l1Sjd5VWxx?=
 =?utf-8?B?QzBkc3d1cjVWVmhRVGI1K0g0aFpCK1J6S1hGb0xDd2d5ODYzZEV0Y0RnR3hV?=
 =?utf-8?B?TUVkNGdPdmtTZzZOSzBRR3dvbW9Xa29aODkwR1lEalpQWVBWZnE0UlV6YytO?=
 =?utf-8?B?SDJ1MGJhcy9XeDl0UHhNYWUwajFLbzZKMmNtUWxRUDFqSWtCTDJMNm5zelBR?=
 =?utf-8?B?ck00b2V6d2M5V1NyYjJRUUNYbGlRVDAwTkFzKzFvbjFER0QwNHBtV28yYU54?=
 =?utf-8?B?L1AvdWdKYVAxcFFvTHZ1M2hxUVBMMWFsMlJsbXlYYW5qYTVvOGdLVXhZdktE?=
 =?utf-8?B?VWlFL2ZGczh5WjZhbExLczFzVnhuNk4rRk05Q1QxaFFJc2FibWJ4NXRja0p2?=
 =?utf-8?B?bjZnN25PbE9hZENGM1duZVVFSldNSEdkaTdLbGFWWGNsMzNCbnp6WGMzcHJZ?=
 =?utf-8?B?MXRNSnFaUHlBek94QU41ekxNaElNN1VNMDczeXhzMkNObllzYVp1STFPRzNI?=
 =?utf-8?B?Ry8xUHNGNkljUkpWMTRDMFlvYjJ3M2dIcTI2YUJXem54WnZRTGlieEtjVkJz?=
 =?utf-8?B?ZDNmNjYvK2orRGhoUEczSkZnNnQraHhRZkgvZ1dXMUJZNk1WTm1RN2RJaVgw?=
 =?utf-8?B?MVBYbk1CRzZic3BpSFlvQnJRRTZsbUhsb1UvNGROVUhlMit1SFFMdENQa1VB?=
 =?utf-8?B?YjAvaTM5NGxUNFpEWHd3NmJmTGhMWXRIbmlkNlFYdkliUWpkOUdrRGthb2ww?=
 =?utf-8?B?bEF0bDdFWGV5N2hlbGpGRnRDNllqRFNsODJDVEd3bWM4dGhuSTc3M1FMTFhB?=
 =?utf-8?B?blZtcGYzckRhOGF4NjdRNTF5Mk83NFZKZyszZmpIWDR0Z2VSbGd6ZGZMMDdN?=
 =?utf-8?B?cWtQdWM4MUVGVnhMSm1iV1FQaTdNWHpvVzhXaXlVK2R3QUFqWFNRckVqU0Nl?=
 =?utf-8?B?QjFhTjB6MlFkeDFzMDFHQ1gzRmozdUg4K0lIRzBJeXB1MkFRdjhvVEdIMS9I?=
 =?utf-8?B?NzZOWVhJWW12d08rcmlvMmxNaEczOWRTUk5Xd2xucDUvM1REOSs5cnZQMDQw?=
 =?utf-8?Q?5omPYfHh8Ije4Oqg=3D?=
X-Exchange-RoutingPolicyChecked:
	ixQc1u7bzT9H2i+4ryXLBNC2Y5Xw1Mfhv8vZNaFhuP8uMsHbODxyLkRIFEj7k44cuwOb9fqbkC4/Ghf/kCAEXNcj8/QJGy1o42Spd6yLFeluXIXHZiTma+EnSXWbwZed3q0sAsUiPvxqpDkLsVC6xW2lRv9m0l7Axrj1eJ3wPDkaqW57k6hLY9w3KBRf/acWYKn6QDIWoFFujP0306UVOT7e2UAYFwtTjyLoCPHalS50KgbMLVRPqnhYGD6RbYihnDcmeP2nScxM3rqDRY2RlnJw0wpObC4QwgypzIHPE13G7XNxvjGS4jvh5LsvcJfZR2yyVByJ5vg5Fk7njxdzGA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UEa0zrTWMg9Ccnw9lNdAQD8eF5LKnbHJViqK6Escq/QhYTcns/YTsZHZRJ5pVGkwYeVhnO6Vw/rXRcUhoO1lGzin4fXCeWBDK7upQCCjVIy2NJnJu+SY9tPAjhGYSfnTA2G3cmKCFeDox5zF7Ec3eqCE5vriiHX+6G4yy05HjPK480uJ7Ni8VqeXQdhmXYWgcLL4UHBbX8bq72czglKDdQiz+Q/0bAaJVt8AuJAbj/ZB/R5ag2uR6pDpS9Zg2ajKZDkw7d9GrEIfBwcJw37S1CV1KSoncnsIaojWmt4nAjxWgzSwQPhGA6sT7o2HFWhmGlWh+mx0kDBsqW97W8vboqe5eVv/GkPpX15B/f1L66SzrTxFZxxnFfyf++0nPDwIqxZhXxR4ncv8YrNXuiefV9nrnNo1enostFGDJ2MIb5ymWiAxYqcd/YRloMtlIkhdjPU20QjsGEu1CYLdpcf11CLgfJke34fP2IZItX7mGLzOOaEgUYij/id3viLS+gGDmWgoutuZga5Jl6WKI2Y73C2HvYtsGAFWCODMJIXOMvOToZQCOJAKIViRePVIUXSJfBEm/JKms+LMFv2MLi7VnnVLEObP5ZYR642x8Iw3d7Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df11482-6b3d-4d14-4c92-08deb658b186
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2026 10:15:18.6570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gy48C8BQ2qK2dwtaWExHMKY+oKwpgRtTFW++qtsQ0qNhLbbCAjHASRmmvR3fredYy8AoIf/q2yLEAPawPfFPcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8036
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2605200098
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDA5OCBTYWx0ZWRfX4CmGgNPQg/pJ
 tMm8mYmipkTEUtmaFJdNicyA+U/Ay2pCXw2Mj12azB18FP+gsetYM2Ov/SYTUxA1UUogWtIN2V4
 BKcbEJ1RDYKMgpECOdKxB78Ecm11cZE4gHLYAJU/MP+DdEL55U4QkV6sisGYN39nty2TGVVF6rE
 sFAAzGhAgfqWhPiZzAJxMxy3juRxgrwhz7NX1zRqlnLiRWrv4/psVjGkpv4dnf2Wfae38Iu7SSx
 yo/bHve3wr8wEmtL14Hc0fzHQ2GcWaYsosUl/LSuP6tpBWwPuz4U9AnCDnMJ3oVOa81qnUrfyvV
 327FVlH9pOJF3AB9FvgG4pcgqZ2cVVlIrc1ZWxWedcO1HOGbnLdgjOGfmXzXIFx5rvoWLQPt4rv
 2QSkxdwPfJkyrXR30UuyyG2LUWpVxHKwD0rzR7pLCX1Bv32z87LrbNdHzPARIHeqgmmnOb3I+Zn
 N5oIVKKhilBMO8yW/wW/V0L9x37r5YMWdlUsVkqk=
X-Proofpoint-ORIG-GUID: cGS1ew5HTOvJlXAM5F1Ktd075jjzdzsY
X-Authority-Analysis: v=2.4 cv=dc6wG3Xe c=1 sm=1 tr=0 ts=6a0d89bf b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=N54-gffFAAAA:8
 a=hBGD9kZ7lom4wZwXM4oA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12298
X-Proofpoint-GUID: cGS1ew5HTOvJlXAM5F1Ktd075jjzdzsY

On 19/05/2026 20:41, Bart Van Assche wrote:

how about a more precise subject, like "scsi_debug: Remove 
sdebug_any_injecting_opt"?

> The static variable sdebug_any_injecting_opt is no longer read. Commit
> 3a90a63d02b8 ("scsi: scsi_debug: every_nth triggered error injection")
> removed all code that reads this variable. Hence, also remove this
> variable itself. This has been detected by building the scsi_debug
> driver with the git HEAD version of Clang and with W=1.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_debug.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 1515495fd9ea..5ae7e4b83408 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -955,7 +955,6 @@ static bool sdebug_removable = DEF_REMOVABLE;
>   static bool sdebug_clustering;
>   static bool sdebug_host_lock = DEF_HOST_LOCK;
>   static bool sdebug_strict = DEF_STRICT;
> -static bool sdebug_any_injecting_opt;
>   static bool sdebug_no_rwlock;
>   static bool sdebug_verbose;
>   static bool have_dif_prot;
> @@ -7528,7 +7527,6 @@ static int scsi_debug_write_info(struct Scsi_Host *host, char *buffer,
>   		return -EINVAL;
>   	sdebug_opts = opts;
>   	sdebug_verbose = !!(SDEBUG_OPT_NOISE & opts);
> -	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & opts);

I think that SDEBUG_OPT_ALL_INJECTING can also be deleted as it would no 
longer be referenced

>   	if (sdebug_every_nth != 0)
>   		tweak_cmnd_count();
>   	return length;
> @@ -7748,7 +7746,6 @@ static ssize_t opts_store(struct device_driver *ddp, const char *buf,
>   opts_done:
>   	sdebug_opts = opts;
>   	sdebug_verbose = !!(SDEBUG_OPT_NOISE & opts);
> -	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & opts);
>   	tweak_cmnd_count();
>   	return count;
>   }
> @@ -9659,7 +9656,6 @@ static int sdebug_driver_probe(struct device *dev)
>   		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_CRC);
>   
>   	sdebug_verbose = !!(SDEBUG_OPT_NOISE & sdebug_opts);
> -	sdebug_any_injecting_opt = !!(SDEBUG_OPT_ALL_INJECTING & sdebug_opts);
>   	if (sdebug_every_nth)	/* need stats counters for every_nth */
>   		sdebug_statistics = true;
>   	error = scsi_add_host(hpnt, &sdbg_host->dev);
> 

