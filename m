Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA1E2E88A6
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 09:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756979381; cv=fail; b=a0wW3W2q9UlxHXhNmF/SimAbSZifjMSnjsNKvVvT9Lb4jWlwk//tE2DdsMBdTAr9xTaicQalrZCCQ5wGjHvdPg6H5Aoi5obMZ1p7k00WcVas1HyF6Z1eWSbF0hzIdPuwb9bvkb6iAV69GOARfpl8dUBCuvlf2Z/1FT0mzy4vRw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756979381; c=relaxed/simple;
	bh=AZzhoTFQyli/gIfBbXKWMq1lw18AehYfEKnYfBUBaK8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l2s/1fR8zJIoDXzvz2JTdkkfgtGFkNKpMLCxKm9p6jM7acZKo/vNNvlNbMtQhPZ6+5kjBm/vWvRkaaWqERqL4ziYH0j4Fzh1PVgBEiQCVzQGjZ5NZhwj7A8Mb/IGe+32YpMA6wLucWgMqI57SJONyRiKEdx008wPIcY6GOEmE74=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WvWMbI3L; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y/A54GJl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WvWMbI3L";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y/A54GJl"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5848dMVV007826;
	Thu, 4 Sep 2025 09:49:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zY39+CLXZbXMLZ3AoibNZ2YYbsO79sve/GEFw4SuJyo=; b=
	WvWMbI3LesnOWrsbyieV8XP+PlKdm/ghrENElKrQX4AKfOBTgJma7tvi0dC0Zn0y
	wYksRA6n7qmSK/LAvLOLda4tDsw9fRrIlKgwkYcP7E5mcESzlHcd57K27IOM9Yp1
	iPtWnK+JV/Ua0tcmL6Zw9qnEE9fI+ZYZ221sRQXQHQzkOBw7x44tZU3P0cTy9iGc
	3RWDbfryiHSX2eM41wdOSQ5mew4EGySTgKrNAxGuQlx20Ht+/Pw3WyX5dX7qUtrv
	k2I5RFG4ahYkUwkdIapKlmC4vopuf8LdGtIP7uUlZIjfao0Rwx1Kt0vPM5Sh4A4X
	RFiDrG7phVv+wQKcIcQShA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48y7ev04h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 09:49:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5849AArq040116;
	Thu, 4 Sep 2025 09:49:28 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2053.outbound.protection.outlook.com [40.107.96.53])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhf14s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 09:49:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HQKB07ZvpTY6fdydpYWNb+RcQHmr1EViJAnp2Q48/8Ikb6XA+bytHzCCZ5xhGZxF3t7ATkI+dQGZ/+gSBFc03Ltyp9m/V/1vpRb3UbpjzEEa6MEnbfd9mf3DxL78NdBU0YVvVhZ26OfuwIz4SJ9/nRNqlvImGldysZBOHZQf0sqlqcvX+oIotSdJT7qXMC5sy03pKfillEuoYBfQ57xfESAJtpOacRy/ssy0EGGDs/aAq94JIt04wZ/FYnDJXzbPS9lSAjh8Y+9I2D2hany3vDK7IIgwRmdxGnD/2hKMDHMg2if7lxUaTukuehe3JvXynjxnU/L/7oLxCJ8U8KRr5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zY39+CLXZbXMLZ3AoibNZ2YYbsO79sve/GEFw4SuJyo=;
 b=yUnH6Zt3Ricmb0o2d4RZsIxqIsktYn97B0QOpTBwjMIrpIcXBDbPDHk3mPu6n1TiGJsvu9JVh6frp2FKvR/UY9hgl6ZdoAxe38tiydxgsTiF9hLkkwaE+4mwx0qA6p5zoQXpPio3LTitFM3SQuhUC2qgKMPsvXy9IHZ6lky9+jmknS43MW/f+Q7/25yw3ivjIx1zrdjg/bNcDYWuIfhg+GNDlgVnzQLQbMGa4jG+aUkZF4xdDboEwkXjOnN2JC3DHoNVwj0Wsb/ZVNecqKvHYT7+JqYsv8//KG8lA65HLwV8RhxsDh9yIFxIYJH3wlpZjjUqomzLKg2tfwFKyW+dzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zY39+CLXZbXMLZ3AoibNZ2YYbsO79sve/GEFw4SuJyo=;
 b=y/A54GJl9ltLFYhm9iy48WxyQyHTJRKq8T4xSmdspVqT6ywePC9nLuFxpTtlzMK+Z1y6UTFq7GYbR5bGLPR3DH0TeFS68uh796XNSo+goLEXZAulQSBIlKbryrkcs63d6c9RyF55FIf6HMOgGt+pf5NnXQ2AD+ZMZq1h303BOtw=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by BL3PR10MB6115.namprd10.prod.outlook.com (2603:10b6:208:3ba::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 09:49:25 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%7]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 09:49:25 +0000
Message-ID: <e555a601-2b87-4139-ace7-0e6158cc93af@oracle.com>
Date: Thu, 4 Sep 2025 10:49:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/26] scsi: core: Bypass the queue limit checks for
 reserved commands
To: Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-5-bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20250827000816.2370150-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0085.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::18) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|BL3PR10MB6115:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ddd5677-a802-4b9c-8a6c-08ddeb985543
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZFl4R29Zb05FeDBCeUhmOXVKbXNFQjNJcWRqeTlZbmhpeUxmclVEbHdIaHRp?=
 =?utf-8?B?d1Vpd3p2TGFsUklnTUFlcnBrL1FzVlRqRzdJSXpyK0tkWndoMTlycUl3T3BH?=
 =?utf-8?B?NkxyZit6dnlOd0NYVFpHV21JZG5JTXR3NUhiZVVBN2NWWCtPcU9CRDhVK1gv?=
 =?utf-8?B?cDlNSHlja0c4ODNWNmc1VWs5Yjh6Rk00VHZrdUE3TE5aNytXZHdHWjNBQzlV?=
 =?utf-8?B?dVV6YWlESCt0TXNHT25kR2ZhVnJ3UXBpa0NCckpUZ2YxR3p0Q09vZzRVeWtE?=
 =?utf-8?B?RDB1eDhpVmJxTSt6cHZWRkFsdnBjUk4vN3ZoWURtNExkWkxIOVdVY2hBRlkr?=
 =?utf-8?B?WTA1R0p0WHB1eGdiaXZNaWg5UlVUdjZYNFJFY1p6NTdhZGUzT1JscXlCZ1M1?=
 =?utf-8?B?T2lENGZnVW9CUk50VU1zZUYwMFZTT3dFQjJqa1VXZW5oWFlSYjBmODAvbzJh?=
 =?utf-8?B?RVdyWGVLTFRmMW1RaTY2bnNWZkFjbGlhUTlWNEl0QjZaVWpFVXRpYTdmTnpP?=
 =?utf-8?B?cVFBZHcwYVM3ZHdXd0pWOUhNS1RLUkxzcjBPT0pXOFgzWDVhOXB2UW1ScmE0?=
 =?utf-8?B?dHpLYjJJQnN1aERTbFZ3M1ZKTWZCWnBNWU05OXdCU2JTRHZHN0l2R1hab1Y4?=
 =?utf-8?B?NEd6Q0s5b0JRY3RyVnoySjZ5TW9ZL2g1RDBYa3ZQSmVKZnJYREJDVW5JcmpI?=
 =?utf-8?B?MmVvK0dvb3RaMVB5SXpVWUVDaG4wU3djdG1nbFloZnMwVkN6YmwxM1JyNDh1?=
 =?utf-8?B?UXNOZXFTREIwNi9KSExUaDJ4d3hSZzJyMmdtRTFXUFRXMmQzNUp2VW1HSHFV?=
 =?utf-8?B?VEI4aDc1VndkSHdFaDZpUldvU0pHS2Jhb2x4anhYSEJlMG4rcWc3MDJsdXBD?=
 =?utf-8?B?bmNQM1RKNEM1eHErd1o0QUx2RHRyS2l5WGh3KzlFZUFaN2xoZWdybVFFWHBh?=
 =?utf-8?B?dVlIcDY5bmhkdUZvSytzS2lGam5wODdweWJqVXpSVkNHZzRJYnBsU0JVRTRC?=
 =?utf-8?B?TnJoMVdkOUZqY0xXalZVam1SS1A0bVE3c3RySU1ZalI3NDlwUXBtWDFQRjJ1?=
 =?utf-8?B?bVEzU1VKUTZmOTNQeGRhdUNKcWsvc2NKbnF5eU9icDF6T1JsUmUzQkFnNE5l?=
 =?utf-8?B?S1FaeXcvUkEzdDlOSytpSWVWcHo5ZVhiaXZYTThNR294Z3h3blQ5Z1hmVHA0?=
 =?utf-8?B?dTdvalEyYys2K3V4cEVwR1ROVTFmdlhwS29FUE9NL0FyU28rdVdVajVJV2FS?=
 =?utf-8?B?em11QThuaUtwM0l6c2duZUUyaHdKVE5WWXVCa0VJMm85VmRITG16RkF5Wjl2?=
 =?utf-8?B?cjV3QVpZL0YwcDk0UTdPNXo2MytRMitYSmFnNTV5dHhCd3A4cmJGMFN3NmdK?=
 =?utf-8?B?LzhWc0ZGREgyNHBCc2ZrQXc1MVd4V2tPUXc4UjY4REtXdzdOMHM3YVA0b0Nw?=
 =?utf-8?B?aGEwdEtPQ2thQmFDZFpGUFc3SFRwUU1qNW95WWpjdmpoOGVTN0FMZjk4YStv?=
 =?utf-8?B?T29SMllnK3VFaHJIS0Roa2o5Q0dsUm4rbW5GOGlieFRFOUx5VWJxOEd5STds?=
 =?utf-8?B?THZoY3puNEpSa09kdW85bzlrcEV5ZGhrbU5MOWlhTGQvWWFKSXFjWlpjWEU1?=
 =?utf-8?B?bmIyakNRd1ltOFUwZU91NUFGQmg1cFgwdkVRWk5hb3VsN0xlaXVBTEJ6UGJu?=
 =?utf-8?B?a1IrTXh6bjRzaUJuVFpIRjhkVS9QZitKTm1PYmxWWFYydG1lcUhXRU1hNFdn?=
 =?utf-8?B?UTNQcENiTTN5Z0F6MWMrNjJCL1ptemJGSTl3d1U5QjgySmNhSllPR3FNL2U4?=
 =?utf-8?Q?HfaQ6XNsTkdtSL1msI6NLvJNjLmAeUDZhGO5M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjZpQTkyWSsyc0xpTWJoWVB3WTl5Rlc3SFI5SXpsdFg3Tk50VU0xQU9XVVlm?=
 =?utf-8?B?K2J2Zmd2YzRUd2t2MThQQjNUNzM1MnliQ2R1NFlYVVpoeEVwSm8vNk9uM1ZY?=
 =?utf-8?B?SnhGUjR1TUd1OEhQWjRUQmpqMS8rZHBlekUrUlRIOFZkSklwdW5vNjRScjJS?=
 =?utf-8?B?VnMvTFJ1aDBQNTRlelE3azZ3dnlGQVl0QkVYMElRN0VWMndPTS9OeVJqM01J?=
 =?utf-8?B?OWdUc1JOa2FaYmdUZzc0TXdZRGF1WFY1UnlRQjlkZW54aW1pb0NyYUduQUVG?=
 =?utf-8?B?NlZKRFJ0VitOenlmZ2hsTStpc3NpdzNvMDN2RCtkd0hSQWRkdWxCUzY0Y29R?=
 =?utf-8?B?MmZCWTJnZzU3K01BSC9hUzg0RGNlajBnb21mR3FiM0pONXBVY1dtN2tZNzdK?=
 =?utf-8?B?R2M0TnRzOWJtOVNsb1BRd2MybkdHMnVEKzNuK0srK2tmY1VhZ3R6Nlp6Yzgx?=
 =?utf-8?B?dXVaNlQrKzdlMGR2Rkc1NVc0TFBRUUJaRlhBUE9mMG1ibUZyNVNxNmlicDQz?=
 =?utf-8?B?SUV3ekxOSE5CRzZnV3o4YU12SXJYWS9YeGROK2M3NncxWXJLNmRiQXVHOFZU?=
 =?utf-8?B?Q1NkclZHb1BMWDMyc1FIWFVKZGNSNCtuMEdsbzIvMUVQQjFmcnBrRnRnaUNr?=
 =?utf-8?B?TEVHaHlrUEp1Y1JqaFdFUld1WGprRGN5ZzcxdW45MGcreGw3b1NpYndGdGJn?=
 =?utf-8?B?L2NBMm0vSU9OY0Qvc01qaktEUEZDWWhGaFZHM2hZdFk2QlhzNUtGS05FQy9F?=
 =?utf-8?B?NHh1VzJXLzROVkdWbXFNY2ZvUG94d0dqZkVIeFdXM0NtUlVoMzdyMmZNc2hx?=
 =?utf-8?B?SjRpak1xeTlFVVlMTTFqWExkY3FVWU1Cb1FDNFM3S2ZmbUtuclNHdEtpRzl6?=
 =?utf-8?B?YkgwVlNXVWlqeFJmTVF3K21yYVFNZEhXK3RSNldrYmlPdTc2YklCeDZDTjM4?=
 =?utf-8?B?UWIwZlpPOGZrNW9NbjBSdzZCbk85eWx4OEhUcjFtQ2pLL0ZhWWVPaGhycTVS?=
 =?utf-8?B?eGxmSi9OVEFTU3RYTVhGMnpUMHNmMjRJSzV0QnlTcnlwREQ5SVpDWkdtUzRD?=
 =?utf-8?B?SVRZZTRWbFNZV2VDTjAvSHVkM0diVnhuWWJPUTVyVTkwUjI5ZjVWdkdJd3l6?=
 =?utf-8?B?RWlnc0FhUXNETGpZK2ZSQXdIeitGcXk5T3JDbGx0TDB6ekl4d2lDQXRNK29v?=
 =?utf-8?B?S1RwK2kwT2lnT2kvRU9HSnhCajdoL3FnOGk3SUhlMklEeXZJZ3VQTVdDNmRY?=
 =?utf-8?B?TEFueGVKdW1Ldk84VW8zYUVwNEVNUEMybXVxTnlBc2RaT3lpdlFsVXNDeXRs?=
 =?utf-8?B?YmliakNVOTVhQTdJTVZTS05IYU93TGprdHA2Nnpsb0JJaDVrRnplTzVseGJp?=
 =?utf-8?B?WGh4eGUvY2djYXo3MmdnRUhoU3ZZakVhNlNibTc3R0JrbWFhQ3hLY084d2Yz?=
 =?utf-8?B?K25aeGw5d0szOGNYR0FRNVhmMmpXbENqMXAvN0gvWWdCdFVsTndDL2wzczBC?=
 =?utf-8?B?Qm5CSXhBam1Cdm02cndkUkNPUiswWHpMbVVMa1FRTFRiZmU2bE9kdVZhdVJP?=
 =?utf-8?B?VnZIQ1FidjBBZzk0MENFbVN5YUJSa1p2a0x6VERoby90SDk4cEppTkp2dWZx?=
 =?utf-8?B?LzVZa2Z4SE14S2M1MjNCL0Z4NjNuNTF5TU9sK1Rpei9uQU84R1ZFU0VhZ05v?=
 =?utf-8?B?VzRmOTVFYktzaVA2Ui9MeFQxazQ5aGtBalVzcE8yZjJ1d3lSK0I3Si9sU0VQ?=
 =?utf-8?B?QUNaclBiSVQ3T1VXSjVreUp6UFdCaU84YVhFRjZQb01NdkF0bGRsVlR0U3No?=
 =?utf-8?B?a2hXK2pwc3J6S25Za3BEVkZNTVJZRVFDc0EyZHN4ZEpqcVlTc3V3OW1FNVdh?=
 =?utf-8?B?V3VrbUZsUkZHWU9jWjhDbTVzcmhvNjNZOGlPRXFqUkIvcHN2Z0N5NlNGUTRV?=
 =?utf-8?B?eGQ3dFFqNTNOb2JHWGt4a3Q0MWZBNEwrdnZZckFCMS95SUdkdXFEL2wvckMw?=
 =?utf-8?B?OEQrMjJWZUJjUmcyVU8vU2dQUEE5d3JGajZ0MUlJczBSYkpjZVB1cFBDcE5Y?=
 =?utf-8?B?Q0dsTjl2SHVSbkkyUTUwcHE1RWlhRk83Zm0ra0xmb2xVbm9PSDBxSGlYM281?=
 =?utf-8?B?TDhHVnAreDNoOTdGTGtweUdqbkcwVXZOOENwajZSK09qMFZ0cmNGWk5WdUNV?=
 =?utf-8?B?TEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7oTSR8zCUfcG4Ib/fHEZ/CVE5fXL1M6j8nhUqzLLW8d3CMOu3CRlyVxUcF9y/jbg11AUKrcC4ZdEvzAGh/CQRdjFDAK7EpY9djqRanHyXkzARMaxM68gmOkjD/DXPJesN3H3Bo0ypRTAO6XhfOAPN7hkAA19ZV+2eODFTzAp20nvLqEn3sCMeFZbmGLtNpMM/cTwHP1efyKyd2LWgNOCBuu+B/Nvbn/pfvhTlfRabecpDsgdk/qVeuAfMU51sDkTacmMpl4/Ljs9KmyMnhG/DwOAfxiEtiM8/bEc2TvuJt34kCLvTRDo/n516jpB27Z5ouYbQkvUn8g6tw0p4GIzp5DYFyArgtuCvTm92Dy2hxC63Q+EyEWc5cyhxnHsdYK2pzkYtAytippIz8AqCOSWuHn5gQsFXpEQZrrvx7Bg3OthuGNp6ywq8su4sw8tMmHGBNjuxtbvIMaFmG9nTpV9pbM94X160E+Qgy0IU86TwSvJhqFer183PHC1tGkaHiG7PMw4WzbxdljxyuY5eu+CmJjbv8ceVD++Shf9jZB6FYIqikaU2UoJjokQJgon5ZAze8C5ye2jlPjCQWHL2Wl9I25Z5OCj/Q2ZvRilABIMNbU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ddd5677-a802-4b9c-8a6c-08ddeb985543
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 09:49:25.6329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pw1Bs0dQ22NqbYSb5SJTUgrHTFEV5ShTGrhmfh9g2W30Aatky/0CK2tQUDOj6FSdlAP7VkYSLcDBYnjOPpvZsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6115
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_03,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040096
X-Authority-Analysis: v=2.4 cv=Vq8jA/2n c=1 sm=1 tr=0 ts=68b960a9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8
 a=N54-gffFAAAA:8 a=TFW5zXVkOagXNKN6uYkA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: 9AAgrAI1pSD9T9kvUAd5jrWU38_EIrHf
X-Proofpoint-ORIG-GUID: 9AAgrAI1pSD9T9kvUAd5jrWU38_EIrHf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDA4NSBTYWx0ZWRfX8KxYQCzm3ubS
 qEhLjPWKlq7T15ZhM2TfelUXCtzgZLyyuXcwsMhlD8+xhUqQ5Vxibzz7cYDzRwooNvSE3TT/lP9
 LyJDU3i+gjiGg4kZJAyKjiHqEX6vOwF2TTgPDkCcUhTuJyKWD2/PAy+o2YS8h7+IWRLimJtmDqQ
 sIadPbAjM5OKDhs7vuJAiNZlWL7WjkmnV5YNwwI+JW4unKPciQ3G91diqq90Q5TRLt10ThNrc7x
 APZXvAA/JY/5YPdREjQfJsxvQRKtL0loYVVnjY1w36aM5vXp7cp8M27h6rVTpUR1gWQof0VEt/V
 fXgh4Cgr/yHamBbWdlkInoJwRlZ39UQ2qOOg1SHDG/IVljdiVKvyTKoQGK8nwSCS10jkkdj6FoV
 fvq0HhAlHlS4YW3/Bid8WCOVi2/t/A==

On 27/08/2025 01:06, Bart Van Assche wrote:
> From: John Garry <john.garry@huawei.com>
> 
> Reserved commands will be used by SCSI LLDs for submitting internal
> commands. The SCSI host, target and device limits do not apply to these
> use cases. Additionally, do not activate the SCSI error handler if a
> reserved command fails such that reserved commands can be submitted from
> inside the SCSI error handler.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> [ bvanassche: modified patch title and patch description. 

it's an odd name now... I don't know which queue limits we are bypassing

> Renamed
>    .reserved_queuecommand() into .queue_reserved_command(). Changed
>    the second argument of __blk_mq_end_request() from 0 into error
>    code in the completion path if cmd->result != 0. Rewrote the
>    scsi_queue_rq() changes. See also
>    https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/1666693096-180008-5-git-send-email-john.garry@huawei.com/__;!!ACWV5N9M2RV99hQ!LlYERxyD9XQO4a934MwJG8q_NK4ySl31eOzkZOoyuPPNa1aEcS5n_T7NUuFFs0I8mBaBx0FgAZf7ghv6h06C5A$  ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/hosts.c     |  6 +++++
>   drivers/scsi/scsi_lib.c  | 54 ++++++++++++++++++++++++++++------------
>   include/scsi/scsi_host.h |  6 +++++
>   3 files changed, 50 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index e860ac93499d..75fe624366c3 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -231,6 +231,12 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   		goto fail;
>   	}
>   
> +	if (shost->nr_reserved_cmds && !sht->queue_reserved_command) {
> +		shost_printk(KERN_ERR, shost,
> +			     "nr_reserved_cmds set but no method to queue\n");
> +		goto fail;

looks ok

> +	}
> +
>   	/* Use min_t(int, ...) in case shost->can_queue exceeds SHRT_MAX */
>   	shost->cmd_per_lun = min_t(int, shost->cmd_per_lun,
>   				   shost->can_queue);
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 0112ad3859ff..2d81fd837d47 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1539,6 +1539,14 @@ static void scsi_complete(struct request *rq)
>   	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
>   	enum scsi_disposition disposition;
>   
> +	if (blk_mq_is_reserved_rq(rq)) {
> +		/* Only pass-through requests are supported in this code path. */
> +		WARN_ON_ONCE(!blk_rq_is_passthrough(scsi_cmd_to_rq(cmd)));

eh, do we really have passthough reserved command?


> +		scsi_mq_uninit_cmd(cmd);
> +		__blk_mq_end_request(rq, scsi_result_to_blk_status(cmd->result));
> +		return;
> +	}
> +
>   	INIT_LIST_HEAD(&cmd->eh_entry);
>   
>   	atomic_inc(&cmd->device->iodone_cnt);
> @@ -1828,25 +1836,31 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	WARN_ON_ONCE(cmd->budget_token < 0);
>   
>   	/*
> -	 * If the device is not in running state we will reject some or all
> -	 * commands.
> +	 * Bypass the SCSI device, SCSI target and SCSI host checks for
> +	 * reserved commands.
>   	 */
> -	if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {
> -		ret = scsi_device_state_check(sdev, req);
> -		if (ret != BLK_STS_OK)
> -			goto out_put_budget;
> -	}
> +	if (!blk_mq_is_reserved_rq(req)) {
> +		/*
> +		 * If the device is not in running state we will reject some or
> +		 * all commands.
> +		 */
> +		if (unlikely(sdev->sdev_state != SDEV_RUNNING)) {

I am curious about this. I mentioned previously if we only send reserved 
commands to the psuedo sdev (in this seris). If so, would the psuedo 
sdev not always be running state?

> +			ret = scsi_device_state_check(sdev, req);
> +			if (ret != BLK_STS_OK)
> +				goto out_put_budget;
> +		}
>   
> -	ret = BLK_STS_RESOURCE;
> -	if (!scsi_target_queue_ready(shost, sdev))
> -		goto out_put_budget;
> -	if (unlikely(scsi_host_in_recovery(shost))) {
> -		if (cmd->flags & SCMD_FAIL_IF_RECOVERING)
> -			ret = BLK_STS_OFFLINE;
> -		goto out_dec_target_busy;
> +		ret = BLK_STS_RESOURCE;
> +		if (!scsi_target_queue_ready(shost, sdev))
> +			goto out_put_budget;
> +		if (unlikely(scsi_host_in_recovery(shost))) {
> +			if (cmd->flags & SCMD_FAIL_IF_RECOVERING)
> +				ret = BLK_STS_OFFLINE;
> +			goto out_dec_target_busy;
> +		}
> +		if (!scsi_host_queue_ready(q, shost, sdev, cmd))
> +			goto out_dec_target_busy;
>   	}
> -	if (!scsi_host_queue_ready(q, shost, sdev, cmd))
> -		goto out_dec_target_busy;
>   
>   	/*
>   	 * Only clear the driver-private command data if the LLD does not supply
> @@ -1875,6 +1889,14 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	cmd->submitter = SUBMITTED_BY_BLOCK_LAYER;
>   
>   	blk_mq_start_request(req);
> +	if (blk_mq_is_reserved_rq(req)) {
> +		reason = shost->hostt->queue_reserved_command(shost, cmd);
> +		if (reason) {
> +			ret = BLK_STS_RESOURCE;
> +			goto out_put_budget;
> +		}
> +		return BLK_STS_OK;
> +	}
>   	reason = scsi_dispatch_cmd(cmd);
>   	if (reason) {
>   		scsi_set_blocked(cmd, reason);
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 3b5150759c44..0c7235410cc0 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -86,6 +86,12 @@ struct scsi_host_template {
>   	 */
>   	int (* queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
>   
> +	/*
> +	 * Queue a reserved command (BLK_MQ_REQ_RESERVED). The .queuecommand()
> +	 * documentation also applies to the .queue_reserved_command() callback.
> +	 */
> +	int (*queue_reserved_command)(struct Scsi_Host *, struct scsi_cmnd *);
> +
>   	/*
>   	 * The commit_rqs function is used to trigger a hardware
>   	 * doorbell after some requests have been queued with
> 

