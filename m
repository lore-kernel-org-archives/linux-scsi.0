Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7883793D3;
	Wed,  8 Apr 2026 19:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775676657; cv=fail; b=IFjvv+W/6datICyUFnsCrb9VseOEGcvnQ4EZoJ6O+kZVOK3/L4dOrGQO/+kjUenAb3xemqZronZ4GzMNh5715NuxUUuM+o91OrKJnJox/oOqQg+0fOZCiNBmUhNMAYWQinXKwED3XA5f67x6LIBs6lTmzyC2KMynXv/DlCMNOfM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775676657; c=relaxed/simple;
	bh=tpEUNcOSbbcbXYhLt7VffyOh+CE23jOMiMnONF/uiSM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SES4Wdg6mEl5vZLw5gHXzUHjfpi45vXZpM2DXBbKWUfJzSoNbNp/MrGg2yqUJpNg7OgRJRkv5u6kwM0h6HfYdwo2N82ardzdJ43NrNDh+aPmpb1cbCmerWo9F11XqP0dUHUCLhlzATq+0Cozf5JWIQUNcsvuN8t7f8uDWLzCvjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VWqIlZXw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KreAXZss; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VWqIlZXw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KreAXZss"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638AovNd2719080;
	Wed, 8 Apr 2026 19:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9kjYRDTVo2NEo3CX7G7Xs/KJjguwkUo0qjomgr1qbX8=; b=
	VWqIlZXwVwC0VBqod4vyrDNbZsJ8QmpJ+/JAgWY1Bvk4jX0mMt7NJPKwQ69fFCmF
	TFOZ9lNWAVoGmqCfrMGv14cyyNy4lTUUKEIwt/cXYnnefKWQt2npJh2lPpCgrgK6
	xzDz+4a0mUkWIpjzbieU3npRDysN4WC3P9fBO98xCpizKp00P02CB0mdRoCM+uUC
	aG7UjSuHTI38pge9R8iFCsTsLCGx2/W51S7XdYaBWZc5BuTLFRnd/rYpL7TXkTeF
	xVp6HXQLpc+V+EgARhK76W0pIdRMLzcTS9PQaTc1EzBf9MjkbgGLU3Mci3fk4Eui
	IkVhVfnUseAxRIpS9HlhZQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqav5f8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 19:30:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 638HXQZL003555;
	Wed, 8 Apr 2026 19:30:48 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012014.outbound.protection.outlook.com [40.107.209.14])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcn5x5nj9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Apr 2026 19:30:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q2seQdJLj4T58vNkWOWXK8cjpjjlecvkHpKw/LykMKzuXGW7j61sFkIPXNQ30OXsI9VSURsHj8dXNV007og0H1HCEDMglBeTRVBe4LLaXvXxb0cixTX418/gCa1JyVAPNB4zDN85xyvT+epju8Tj195N7hMoFLbEaLjGTsJ9Cjq37AZb42xSXFF7WSPfSY+fVEWL5elDiQy6/bsHpihA6U4gNRSCudfzlweogc4buJtHvkGvqtPVSSfmyk4MN0sqfR5xHIwSFT42ShOnZrEqi3r7O8XUI8PWHxq6wI6XJNGEhuhcpgYYwMcvN6G+Y2gJSaPI/SbFi64nFYF66nLIZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kjYRDTVo2NEo3CX7G7Xs/KJjguwkUo0qjomgr1qbX8=;
 b=DqcKchlqLAhLg8r2P7FKuHImDZAKwALxleIyUquObebmCO6fYvcSw7myq+R08UOQK6glIslX3vWvT69QUI2DILofT4dKYQUiuhqstzQFmDOuv9f3jQNQRUqB7YovJTmZr2DLMtRVXzLASb3QIhrFOdZC3It27LgFpjA7Z7t3Q+RkNXNIwaosFiL+3QHGijoHc5oRMVySO7S4YWyK2pO0QHU00nQY7vEFe72UN6oHSbb1YkFJ3Y9youOu6kZWK9fC8Iu2s4mSVvXGQBEoboJJLg0UATfqGBID7+FZDr7GTQWy7Wt3/cTh6XT4o/ysosKlr611Dzmo3aTZQuAniFHy+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kjYRDTVo2NEo3CX7G7Xs/KJjguwkUo0qjomgr1qbX8=;
 b=KreAXZssk/oqJQD6k7FkQk5uRi1kNLNoNg7gwa50f5EgzV7YGYY2o0z19iNCvmcDOU+YNURQI6TAltMwjft6o8HVZnCGLJgOKoQ6dTQmf3T9Td3aCaDjgQvcs1Cpyvr57zd+J9J1zuGnyfgdDKe9SqDRP/9C/oM0wGzYXBiXwfU=
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54) by LV3PR10MB7962.namprd10.prod.outlook.com
 (2603:10b6:408:212::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 8 Apr
 2026 19:30:43 +0000
Received: from DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a]) by DS4PPFEAFA21C69.namprd10.prod.outlook.com
 ([fe80::5266:1601:5598:3f0a%5]) with mapi id 15.20.9769.018; Wed, 8 Apr 2026
 19:30:43 +0000
Message-ID: <85af5ebb-64c0-44f6-b9a1-6767ed327e70@oracle.com>
Date: Wed, 8 Apr 2026 20:30:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Delete unused to_dom_device() and
 to_dev_attr()
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260408-libsas-cleanup-v1-1-826325bbc0ba@weissschuh.net>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20260408-libsas-cleanup-v1-1-826325bbc0ba@weissschuh.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0078.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::11) To DS4PPFEAFA21C69.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::d54)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPFEAFA21C69:EE_|LV3PR10MB7962:EE_
X-MS-Office365-Filtering-Correlation-Id: ca8e51e1-57e3-4a4a-76b8-08de95a55300
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	9dFXJRmGBcyWzQMV5N0Z+FGuVAtZ++dWPEfkx34q4/iyRSyV/pScpj0NMYYbZMwLzE5bfsIcTiWh02pG8rKhpOB0QihUoo4iKIgD8/D9aATMjhIMa6MuJ2V59qfSKwv+OzioQo2Cg1sMRb71t3MsiciaaY2XhbyQmlGX6UUSEFRbeq0hPQKM2zV4gzNgK6bf+zsSXzbGSAL6PzVz+pYSF9OYpN9idzFRJSwhWpoLCXUKNnliaEXK7LXLXwOtjKcw3hkrF5/GDPdNwDCAQqo6/Rz6kb9O7JnZk0t3ECDPtfKckJn8Z1xcgTP0Mo8xhYgZM9vFdBNzYEhzmaj4GXTvwUZ+UVJnB/5v4Df6SMPXdOSnWVGduAjNDNqfdFhBFIkjcPCov69jldpUN3CJqFhZhHRdZReY1AHZ8jXrY5bqGA8L7TRajsha5OcXTYFpwNGkk6l82xVYVGzvTiG73+z29lb3alnWWFIBKG4rhso7m0Qa8HPLSZmIaTJ4/OqrdL27d1Nfv47Wz4ZVomXVLXUFQXRIdCv6/HlWMenFf4IuFmhDFvX14+RkGWPVS2a7prjla67lgxK8CdxKfbFCaHdg4telyiyXNXL5roLgNJJiIxqo6f3MgdQ4CyZ0+cvPVz7ZqZuheHD0CmiCeflOfExg2ZBZqfYB0YFu0CLwmx1LwRDFHYGQv/PT0dkNkTP5b8duX+W2z2VdndBybN2k7csKYo0Gh6HRWHpRKEQFnENeFd8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFEAFA21C69.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzUyZWJtdUVGL3BFVXU4SUNvcDUwYm5uK3NuYUpmd1Q0SzA1OURkYmk0MlY1?=
 =?utf-8?B?MXIrQTZZaFRkMVNEVm55dzN6SjBzaEhkOG1kTVZYQmxRQi9yUCtWS01sUXhx?=
 =?utf-8?B?Z1NrYU1BYUUyL2Q1R3VmSUVKMEJJdGlkUFlHWkd4eVJtU01NVUdvM3ZtS2ZF?=
 =?utf-8?B?N3Y4WklmeEFTUzFZK3VQSXNsTHVvVnB4L3ViRllhbWYxRGJoUXcyK0lnSTJV?=
 =?utf-8?B?ZzNGTXNjUVJLOUh4VjUrNnFWR3I3QzlWazF6ZlBMeS9uSzRHc3JPR3FRL1Nk?=
 =?utf-8?B?OUFNMG13K0VseC9NSEZGYngremhlcy9qckhsWGE5QitISk1FZGNnZG9jd2lJ?=
 =?utf-8?B?RGZKRzlNaDVsNUtzTTV1Wm5mNWlrd1ZpL3grZkM2NjJVY1NQekY3bXNrdjhY?=
 =?utf-8?B?NGt2NStIRFpDdWs0TVBCd1kwZmFFc1hTRnlEVEk5NWZkVC8vSUdxZDJFWGRO?=
 =?utf-8?B?bm0zUTQrS2crZTFGMnZNU0p6eDRjLzE3bUVPNC8zSXpQR2U5OEx3TE5mUnht?=
 =?utf-8?B?dzV1MERnaFdXOEdTYWUyQ2doeTM4YlRUWmx4V29MNnFKZTJua3JLU2g2dG9W?=
 =?utf-8?B?aDliV2E3aEJtOGJiMFY2eDFhK0YybkZvRUNOMWdRL0dGcXBKL04rMWVtaGZk?=
 =?utf-8?B?Y3V4aXBOMnB0d3pQdjV5dThvK3V0K3g1TUVhc3R4a2xtVXR4N0ZJVW91c0cy?=
 =?utf-8?B?ZE5Ca3ZlWWZ6TjM5cGdpQ3Zsb05QWVZwTkdubnpJWTNYRkRCSGhjemxxTkFw?=
 =?utf-8?B?NjJrT0xtOUh6MHEwOE1ORkNaRXk5YzBxczJuamM0b28zcnVSTDUzSGlSd1My?=
 =?utf-8?B?ZE5DT1l1VHFwRVBURmhzYjFEOXVHYlFDdWJmK3NOV1VSd05ubnFFZmQxOElK?=
 =?utf-8?B?aGRNRStuTnJJSFpzRk1HdUpZRkc2UUltM0FaZndIWHkzYzV5L1RBVnZQek1L?=
 =?utf-8?B?RVhFUUcyOWdXNUdIczcwcThvWnRyTUszZ3QvRFh5Vm1melY2UmVpa3pDNGVM?=
 =?utf-8?B?V29aU0lLUGo1R0VRbExhV2VsN2JQb1lMQ3pLL0VqbnpzaFBzZitLNEJVZm5v?=
 =?utf-8?B?NERNdTFvNDRZeURtZEhaTk9KUEYyNk14OFN4aXgwNkhGZXJiRjdscTNDcHM5?=
 =?utf-8?B?SHFxbTIyL1ZHb2hVb1d1VnRhenRSclBFcUZDU2FSZS83M1RQNExCZktodHYy?=
 =?utf-8?B?OTBWcjZsVzFnSDYyZ05KZ2VCemMrc2g1UndBalZpdXhhbkUrVE56WFl3bmFp?=
 =?utf-8?B?Vk1HMnFWUFV2WlhwMkxUaFJpdXBHb1dBdzlJbkZJVE5DRzd4NDluVjJkVzBQ?=
 =?utf-8?B?VlNyQ25wTmwyRTZMV3ZuREgxL0U4bmY1U3BKbTQ4VG5keCtacHp4cGZDbGtk?=
 =?utf-8?B?a1grWlM1UHloMFVHSUdIZkpYRm9obUY5M0JNZ3granhjNnh2L1VwQnFhRVcx?=
 =?utf-8?B?MGF5VEVGMVBDTENoOU5tQUU1R2FsaUpJOWkrb0lmU3JuQzFha1ZnRWFtUlFF?=
 =?utf-8?B?RGEzMUtzeTZ1LzZWbkc5THF4Tnh5ajlqU1luUWprUnFGSkpCLzVseGZZSVp2?=
 =?utf-8?B?YlFMQ21WSytJZmlYZkFPYS9JSUJqeGQ3cDh0cFBkTnF0U3pnQ2o5WE91bXNj?=
 =?utf-8?B?cTV3Tndvck1rZUZsc2Z6RklLdlZMaDVySnh5SHl6ck4xaTE3c3h2c3RiUURk?=
 =?utf-8?B?MDBuTHF2NVB4YUdyc1piUEprSDc2eXl1a0h5anRCM3NESHNVYmwydWxzMmZo?=
 =?utf-8?B?ZmpWQXdRdU1OdnJOaDMrTlluN1Nlb25EaWNYUnVWazRuRWVEdElGVUpYOHg3?=
 =?utf-8?B?TzJyUm9CR1E3QnVEcDVEc1crRjFUNGk0NGRIZlZMQnJ0T0tHRDkwY3E2dE5s?=
 =?utf-8?B?Unc1UWUyemViYzNMWEJnK1dLaDVGYmp0VWZ6Qktyc0orTFRqUTVzL2FsUkg3?=
 =?utf-8?B?S01HSU1BSkhCeGtZTHNCVmxGODZnNHdraGlZUElULzhGM1ltUDlQcVJMWXZI?=
 =?utf-8?B?MGhyanorais5djY3VCtEdWxSOWpSc2hRS0Jjbml4aHc0aFVwbXBkUG1zRzI3?=
 =?utf-8?B?eFVmKzZYQTZ3Z0FMUnlTeGRHVk5ucjZGZFM0MXhqN0F0NEkxUmZEVHVBaEt0?=
 =?utf-8?B?ZGJYdHVKbkpjcHd6bVkwMk14dEpsaU9oelBWaWxrZ1VTT0xRQmRoYkcvSjhy?=
 =?utf-8?B?Q21SczR3Q2dLUWd1bDU2WmV1UmJuRHkwRnFSTGdlcGM4TUVQbFBYYVJxTjlB?=
 =?utf-8?B?S0prU3BHTE9SQ2RwVDNqU0RLQmhrVnZ3c1gvdWFkbnpDU0tvemVsMHhsL1Zy?=
 =?utf-8?B?VGNsWVMvdWQ2Y3pvSjQyQU1NbnI0clFFbWJGbnVmdkhtSStVU1hQQT09?=
X-Exchange-RoutingPolicyChecked:
	ANMLoa4I2LEpI2VKrkl9NxgngBns0GX086TulSi0tjXl3pA6ECSWtTIJFkYG8GKSYOeE/WxxV+vEXFHwUyY+5TZILifPWkYMzaIiqSgfRV/tVi46h7TDWRi3EqTXrJOeidHCdJLBhN6n8Bwoq9MzWfwOvoSQpKV9Mt09bE5sn952H7cNwDULhXDSuvSHvDJkE6M4pYfrBLT74D+XQLq96s8GRUS628fOEeBg36VBYjSEBm8/lz5ErpCoMBLQxiQhIDiqTqCE8X4GDBxwcCpbxzXgbK6MHwyh5vl5YAtiBLRGCIWyTuAw42PQDWCRnM1L2aH8KaIbteOCYk4oSZgY5g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xyrUXlknMtDYkTHc72EPnOeL1mos8qbDM53S7X5bCYedePk5jk/nbrMM7ZFDH5KEclvDPnZZDj+Y5ZZ4ws7YHAwmwDjZ2ejap2lR21DO4lv8Oi9GbX4pf41yvfuQ7eJYrTkRaIvGIAJp68eSO1s6QeFWCZSj4m38bz51BMop64d+23fn1eypjTQ5w+YG01Owvq6KKyRoQPWZuHqTKO3kbSR5Ovs8AnFH2FhTC5Ei/WhSB0O9D2GiOpdqRqyxkd35KJQ/phljLO3G4+gmnIKec/WkBxNOihMVJPPN2sXNaRCyby/fHZRp3tTzMkX0Tf9z+tK5B2Jb4oPBF7iFX6etO8H9QPmiKJEK6wlfVwUQaBS2oD0ewA2dmj9RvbzF4eJZr1c2r4hEcd35Pspkbe8IyvUaYNXvM98EMKB1XuqnqAb0mdH9+v5eAAWMaHUeBZ49wQJPpX9VVHNLZxj2q9yxf+kjoAwvCOPvdKVssmY1hh669FKgjbBxEemVuswNhKJjHi1uWG7z4FWpIxJqtslJsAq4w02fyxgus6WPvwGJiMfF98cxe+QNaGPY0+f6gw7QqIEU/4Yba7/CmZiX2DxVy7yqLglN1Rxtr1cV2vym81Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca8e51e1-57e3-4a4a-76b8-08de95a55300
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFEAFA21C69.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 19:30:43.1966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7q743DK/wLjYB7IuQ3krsLAK+iQwfcewm4eYFoyLXa+vzvQOZvbKPRvk9rpiReWmx/TeO+lPKXJcyU3YmCvXJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_05,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604080182
X-Proofpoint-ORIG-GUID: 9uR127GI06_FaphPIYSh0_v2DVMO9uxk
X-Proofpoint-GUID: 9uR127GI06_FaphPIYSh0_v2DVMO9uxk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE4MiBTYWx0ZWRfX1SwLx2Qxj9oT
 kZHmim5SsxAUfpUTWQdFfXQybNEYYbn7VuL1XfWakZ7wZ5OPhFsHWSzDJ4zBf3sNRrxHLAtAFAH
 /XH0B8QNMQQLtujm1WHf7uiR25jX2g7WuGveap1rY0Es6cnS2mX3fcUBltpBqIIlvrmKYCwjdEo
 kIo+Q1BV/eewx1tzMV5FwyMphSQ2vpWZLE8v1DUt+ZCR3EpJLhUgV0OYkRPIEOesJaDlSSSYmri
 Vh4Kev+Fd4JtLH9ND6J6X40kQ0kc9SpurGRkCulmM6/zwUQ9tZ0ITJRq0Z7bUsjjZFhHfyy8zEj
 z3LNU24oUlTK9UqleRYo7bhxSqlveO6903ycOiAJSo6Mm/3s8OhRIJPSRvB8eLYYV68vgiB9zED
 prCPqSOt2KcygKQ4Ndesmf1pncKmU5j/lLzxhcIYPJ4YjmAu9U8/vgb7UX7npddYsAXrX7Zu3M0
 dBV6BOl0RYFUNwO+3Qq50xr0EccD1R5LGEWOSKjs=
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d6acea b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VTue-mJiAAAA:8
 a=yPCof4ZbAAAA:8 a=rnqhmTZGhccT-vtqXCwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=R6trLQSf4H0A:10 a=S9YjYK_EKPFYWS37g-LV:22 cc=ntf awl=host:12291

On 08/04/2026 19:28, Thomas Weißschuh wrote:
> These macros are unused and to_dev_attr() will conflict with an upcoming
> centralization of general attribute macros.
> 
> Signed-off-by: Thomas Weißschuh<linux@weissschuh.net>

Reviewed-by: John Garry <john.g.garry@oracle.com>
