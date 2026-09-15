Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D174236AB56
	for <linux-scsi@vger.kernel.org>; Tue, 15 Sep 2026 20:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789505450; cv=fail; b=hiRDxIf2FcKKHAmbTJrspwNyfwtBDMjJhZpfCU8FSef38aRIWRmVNugjoQfjOfTTlyr/JjFEKxO5REvQ4iuNpSLvO+ZGkoTrsZNKzzogZcawCZWMX2bbnkqU52ry9BcRo4KhhERNzdJbLXe74WNHhesxAX2cbFpBm5QEir3Lc14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789505450; c=relaxed/simple;
	bh=YaXDNGskR8+B/QgwLPGFbIg4OoNztT51paNMZHhOyjA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 MIME-Version:Content-Type; b=FzVuChZTX1dRdyNo+KCYhrUwJkJ53pNytJuzIV/CixZ0eY9Rr1lbRUwD/MqgEBsL3jlDzwf792CrWaPV4rFSD5zgzjo2eL+hEjmVkaLFShk0XPW+7tY1OWRnyWWDVqjVDX+ty+KhXyoUeMNCGulspBJNyG6HzeoE6RIlchkoSUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IwuAeeXO; dkim=fail (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=I0ys6RRp reason="signature verification failed"; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IwuAeeXO";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="I0ys6RRp"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FKVTJH512172;
	Tue, 15 Sep 2026 20:50:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VdEzL5J1AUap9ijFNFTUnWg3dtvk527+GC3ewon/ziU=; b=
	IwuAeeXON29RaOiyJ8sQ85dxw2j7X5XlSob6exDrhkrQYFWieNUambOdN7H5ULN/
	57mTir8E0AczfxkXfpmL0yqrTGIDdmknip177QcLNi4ZLsyalbVqfvS7eUm91mp3
	g3si3U+cCNErbxTlgA86IuYaI5TlLsK79sCyrRVpP2Jcn3V7z44zop0sRIXR5AZz
	/icOGfcB+kf1q6JbLHQ70Y392Ypshih0UC30xy/5n/aQCWnHNSr8ObS/fP+JFog2
	8b8fo9T1q7QkmtQaPyH49FF0zlVNNsuCKVhmHN9aQXYCHnXfR1973Jtdfu9+aGGE
	dJQo71a5iSpjJJL4yJrphw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gmway4h3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Sep 2026 20:50:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68FKoQlr009475;
	Tue, 15 Sep 2026 20:50:28 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010005.outbound.protection.outlook.com [40.93.198.5])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gmw6pm3xp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 15 Sep 2026 20:50:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qj66fIvHqGftaWGltGPV/8EpAZEMV71L7I4XsVHA3L/DL9q7fQRR5rTGbpO0oKv9SguaJqH66opz7nW/GDbjLW6K1FWAQxdfcXLK3inlgl3RwSPjXlQnNPGjtEPHQUWB5vmu5VfraM2/kGNa8iWcaIEZ2kr4lR4ob/HcdZXicYs+L7RbrNyCEzyGDbbl7GmjtkJaz6P0E+Xu/U0Elior9F0sZBHo4em29LbWSoA3zgDhdXIjEAUm+/GpUEoi3++ztD1u2Sq33xakdkMznUhHSR5zWTmqfoSCHawh/Z2ccAFUcP/jyRqFRIDSAExxbfG/XcuQpTpjf9TUdCSuo2Ramg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EhA8j0/E1b9jfTjiGkp7uJ/3nVvlThoMOo5fcdNwsms=;
 b=aSBexdT4OWJemZvjCxr2C/rX9kzisKdvDrvhCz/Yn1oMD2/sCFWokPkvr4OUy9ZiIYUgT401MrtX8j0vCBel4ahpdM6J/w0WGgcd/YL5FQOdb++peh5yxt53rBwA6YUMg3oufNI9cBotBcWF2IajtGvj7UyUM7aSIfwfgiKsOs7krNZGOj2eVW+VIDR+S0OgmAYbY0lzmjvihNfIj6Mv4IW0KiAfse5hZ9M7IFQFGKlnh/Uo4fjNVdzvkTC+cj4BQ6gFQkaTMhkGggvxARysC1OgC7SbPCrhUG6Utqkl1WkeC39UIRkyyCwpnEGh9lGQ0HZk5COio6/uVyywZOXu0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EhA8j0/E1b9jfTjiGkp7uJ/3nVvlThoMOo5fcdNwsms=;
 b=I0ys6RRpbKVyNCOhJHMz2Ojd1JsH8t3xuj14o7O7USMo6mJN5V0XwwB/5Ddh7zd2dIexjZVhw+t0F2GpybWMO6MM+eS0RuSUQ693WT4eMbpWzLbN5FS5+n8vBqe/idJIJjNG4BM5CiVemtRkUOOwb1I8tmWDAZqRL962Y6VofKc=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by CH3PR10MB7863.namprd10.prod.outlook.com
 (2603:10b6:610:1bd::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 20:49:37 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::c70e:bb7e:7d68:be8f]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::c70e:bb7e:7d68:be8f%6]) with mapi id 15.21.0428.004; Tue, 15 Sep 2026
 20:49:37 +0000
Message-ID: <1f506f66-282e-4c5b-89fa-7bdba26b1fe3@oracle.com>
Date: Tue, 15 Sep 2026 15:49:36 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next 2/2] scsi: iscsi: Fix use-after-free in
 iscsi_conn_release() for cleanup_work
To: Ye Bin <yebin@huaweicloud.com>, lduncan@suse.com, cleech@redhat.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: yebin10@huawei.com
References: <20260821092435.1632931-1-yebin@huaweicloud.com>
 <20260821092435.1632931-3-yebin@huaweicloud.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20260821092435.1632931-3-yebin@huaweicloud.com>
X-ClientProxiedBy: CH2PR19CA0023.namprd19.prod.outlook.com
 (2603:10b6:610:4d::33) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|CH3PR10MB7863:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fed43df-af06-4ac9-517a-08df136adae8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|6133799003|10067099003|4143699003|5023799004|56012099006|4133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8tDq27aAdnQirEUV1GYwUVc6+Y8MXeuBRReq8HtSNcZMD2FuDe81+EnAX+Crbp2RRUKGJbvh91kXXp/6E1AX7KBLGs2QbKpQlahs9d6W39HxSX3dTidZcUt8rXpGTsBKvHSzyuqLVGx50hp0ZKgXoesSWqFrxoi7HdCEl+HlEbRFMmhzkrTvDaGDhqrbaf8Kq74JoGAifuiHdJinqEPOOduyshecYyNSodPUxYJPmDmTF7euFgxuRUsWfs3uXtsos5A+Q6G4r6W7WbHzZ1lbJwhtMHRt+tzdIKP++6Cczn/rUDhA3F7cmNOwERSTBVocta61j72o90T2r/xRDLJIn922kfLnGvlUK4OaaY07MtUkQ4G1bVKS1295tNLDHgchjp7IccnG/mKqUTogz2XzhBBsY5P8u+GA6dPUjIiAWjvYHKspSCh2fpeFctDjBAh/TrFc9ZzQqzlaYNu5P0O9HhrlJIlClYUC0pq1atD/OeAYseiAKvVug9AKlioSenkcqTCD7HVSyail5bML19V7CnDw2eyoupwpjrEneoUSCy6z0xhj9EjTjxWeASxKAH5v7qt9IgALj7fAiwOAcJ5mobP2y3zLRT6qPp+oQ2jy79zoTvAhJDXMgi4UKP00FDhbio6cFvyG+n4Mw4QhWwPgRo4pdLdF0ja+eBANcvvaGFo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(6133799003)(10067099003)(4143699003)(5023799004)(56012099006)(4133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZXpjcmFlT1g1bE5rWnFCWXpXTERDRHkvQW9oZFY4eW1PcjBSaTFQS3lCNjE1?=
 =?utf-8?B?eFdXaUtJbXk5SCs5ODkrSmxjYjZ3Q1NFZ0hVdjVhc1NlSlhNSXdxVlZLV0x6?=
 =?utf-8?B?WFFqVHZVVlBsYVJSbmpnV1R2cW0xM0tCcllTOGpUY2VLTXl0bFkvZENJNVhH?=
 =?utf-8?B?NDhOS2hzcmRRSnFhSzJTUDU4WHZXRm1kUGtEZWg2Q0M5dWdNZGRzN3VWbzBI?=
 =?utf-8?B?alE4bTNkVElwS2lad2tzcmZtb1dvaUhwcTJxRE1JUlFLK2FJOCtZVWRZbzcw?=
 =?utf-8?B?NUx1Y2hFY3NuTzFyR2xVZVlIYUlyeFJ5RnJ6TzRuQ3NxZXp4eTNLdmsyOGZ2?=
 =?utf-8?B?YkZ6T2dmamgyNDhVTW5Wa2FVVUZpUGlKOC84OUc5OEE1d1hic2sxL0QrbUdN?=
 =?utf-8?B?cExIMzR3M2NzUlVMZzM4U0VhMkhidEFzb0Uxc1JsOFNyT2VEdmg1VFB5cmp6?=
 =?utf-8?B?d1E2WUNmV25MTkZFVnpUWkJ0RVczRUVGSzVSWDhGYk5td1Y1dy9EVytiQjhy?=
 =?utf-8?B?NGVuNUdZYzRIOUx2WENxVTlSZERJTW03WFN6NEpadGtvUVpad3U1RWtnSW9Z?=
 =?utf-8?B?aFEwMlZ3d1M2U3NjMGh5S202T0U5NGFyS09iY29FNWVHcXJzY0pMelJBZHE5?=
 =?utf-8?B?VDNMRkZ4T2FkYndhYTdlNnpVNlAzWlZDN2VYNXdraWU0Y2VySzVIdHp1ZDl1?=
 =?utf-8?B?UzNTUTFXZFhLTngwTVZsWmo1T1dESWNRa1ZFRjNBa1RCWHMvbU1hVjVlYVVi?=
 =?utf-8?B?a2hSZDNXOVdQUFFDZHQyMW50UmFTSzBpYzkxcld5TmxiS213UzA5ek5udFBa?=
 =?utf-8?B?MklsOUFiZURCc01WMlpKTXVYSW9kSURmblRDazhnQUg3OCtpMmxFTDcxeE1i?=
 =?utf-8?B?Y1FjWTR1QlFsbFBFdHFEQkMxU2FBRE5Ganh5YVRrMGpVSThRQVkvZUtDTEJs?=
 =?utf-8?B?VVBNSG9IelFNSTU4bkhZWkc5UVpNTUMvd21YaW9CL0hvWDZxZHZIbEFnTk96?=
 =?utf-8?B?YkJqbGRVSXQ5aWovSjc2MGMzWWxnUWlZZXpTd21GcjhPYVlXYXZaVE0zaWpB?=
 =?utf-8?B?ajNkUmNjUlplc2Z4d04zRjNRcnh3KzBTQUEzRGtHSWo2WFEzUWxiWnhjN0RZ?=
 =?utf-8?B?N3pwQnFmY25veUZrSXBMWkxwUFUxWElsUTJ6K3VzNEt2TXVyWktmV0tMNTNy?=
 =?utf-8?B?MDhOWVBWQTQ1WmFSMEdFNW1TWUljTFRVTkNVMmZYemE5K2RuY2MzbzhkOWlQ?=
 =?utf-8?B?cmNvZjhWSGt2RFN5aWYrc2FKb0lBNnBpaHk3a1F1YnhHOG9HblQ0QmtoOHBj?=
 =?utf-8?B?T28weWJVaFJlVFhxTzBaN2ZiTWJ4OWN4STBYUW5OMSt6cVpGNzNTVWxjMU0r?=
 =?utf-8?B?WmJsRkg1SnF0YnFiSmxDZjdEWXh5RHY5M004ZHF1VTJMbEZ0Tlp1UjhyNWdS?=
 =?utf-8?B?dGFlR0VzNThkWC9aenV5Qld2OG1uTzlCVWtlK0ora1JBV3lYNkt2bmsvR0du?=
 =?utf-8?B?SXN6Rk1wZThEVUJMVDR1NFV5TWROeTdJZmo3OTJ6YnN0OGZMOG5ORThCcURB?=
 =?utf-8?B?QVlQQkN6NjFGNGU3MC9Jcko0WjJiNFdWZlZITHVLbWRsRTNqeGNKM014aGQ3?=
 =?utf-8?B?M3NMbXJOVGpsL0liaEhsR2JTMWk1aUtQbUYxZXNNejNyRkFJck9FTFBVdHFK?=
 =?utf-8?B?NHB4N3RuR0Y3dEJQMmgyNUhQSXEyenM2aWh6N1IyVlo1UEEwdHZuL2lyazd0?=
 =?utf-8?B?WlRSbzF5RUNNbmNqeU9MWlR5bHROQTc5QlBCMitwWkMxR3Roc3ZLV2Q1QmhH?=
 =?utf-8?B?NlZGTHFMZ1BxRW4zL3VOQlpzcy90d2xlVmR2eW5UZytHQzBBR0pSeUJOVkJR?=
 =?utf-8?B?Zk5KNVIxT1BFbVZPMVY0bXduQUZzakkvQ0F3K292RE45SXZuNm5ESWs0Uzdk?=
 =?utf-8?B?Z3ZZSDhsZDBIamFpdFV0UUJPU284VEhHZFFkRU83ZEtsd1BrUDFmVkxzdnVT?=
 =?utf-8?B?dGFFT3Vzdis1cEk3SS9lWmVTeHZjNnk4RDMzZ241TkNHdHJ6UXF2NjhhUWpS?=
 =?utf-8?B?ck1oS3k5R2hSYTRLL3hvbm1KYXFHdDIxZkNGMFlQNnBZeGJJdmFlcGtWMnZ5?=
 =?utf-8?B?cXJFeGFMdUVBNmplUUMrOWp5cDg3R0VMc3l6MlI3QnFhWThuRTFNMDNIRzcr?=
 =?utf-8?B?R3RaeGtiK0hwTVJ0ZTFiTU9mUE1uU2pIOGJETmdWcklHdzV4ZVJHcU5SdEpB?=
 =?utf-8?B?elVHZmMvY3FKL1R3RkhsZDlaS3MxM0dRWEllTG5MQXQrc1lFMk5ZMlZuZ21K?=
 =?utf-8?B?YVhSbmczWmJzTFloOElhbHZ2RGpBVGRDNURtMTBBSjQ0Z3hRbXRCSmZIeENi?=
 =?utf-8?Q?RReFY9E05Gmoh2Rw=3D?=
X-Exchange-RoutingPolicyChecked:
	CdymMcUBbdGKhk48t+GPNPXmbznUiW1AmVd2m9EF+oFm65JCCkSbsxQ2EIAfIfNcI5sw+e+cUp+m8vZVsp6I7hPfDjz0c+I3q6DaDb4xhkPqKvAtrjW1i2z/Kh+bxgi/5eRN0L0kDYGRH03F8OX0QyyBFmxewCTpDIHX5F8njyuYMehFbaqN1/Q33r7obXjGOK9SVoVGdmCyZ+SqCK7aeHbeJioXufcEvXOArodlj7LXghXnnCRPKJ6NRhxBEYmbWg+GbCEYJgenTvrG/kG7EshMDwX+5Zx2s7RpzYLTaSivCQlwX4XDYJm0o02LRieO7XwLvNLyQnqd5N5t0cfj6Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MuvRFJNaI68l7QaVsSLKGsBe0WpmeQjyoMnEdSCAi2rLbQF9ToWp+4qI/0ziot3KzGFge2xjNnSFvm5d9Km/H4pdRadi5Z0O0BWvEqe3sZQTyUMaghZDfwzIYhtFbePculN7WGOwGZDzpaA0Bf8TYX1SeffEhFsGnvzmMwT7h6Yl3b2EKtsQj3TM5RkSkSvK+3NsMNz+7GYS6/KlmDd8A2NLC84C6iJUMAI/WBMqwnw4OD9LvmVOTZUMd9506hnPCoYosyG+m5zOYujpx4pGFjDPgrLsj3pGiXnj3ji8fBnmEG3/zDMztxS52fqqapslXdNHBvvq2+1Sij/9JGlzAY4WMyRE8LWBscykEWzaxAfdDlhy0CvO4zUBuf9nL0xsUrkPRHHFvsv0LGf3oEuWO3VBz7ywPkOU/tMwBRZdjOCA477nt4KP+5D2FpIiOa6f+NlNNhSxQ6yshQc2vxC627BjII6Gh17LNI5Hshsr7x26w+Nw6nhj+xh+AGer+dZ16xhT5+Ba/1nHLIWcfgzEB3J5S6gCN8v7TsSw/0tl/aW4p/56ZR2g2PHGLx68858SEuojDBC2Jytb48eqzWxFdjFK7EbLP49tXhSmFTv70V4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fed43df-af06-4ac9-517a-08df136adae8
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 20:49:37.2356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BkxhNDhm08m8Dppc5RH5fInPITN3sIbR/m3CvdhFSKZeO9r6RrqpoHiOFzOb+NOmjWoeqyzkQ1uMxZMT1W6ZaQzarWDFbDt3TI6CGWPNFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=910 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2609040000
 definitions=main-2609150304
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDMwNCBTYWx0ZWRfX0L2ns1e+5re+
 rDYBad0BRbz5pTsBWhqkFLhxrEb7qbnHGj+wqB6vFpKRR+UkPvM+0zFZTLsmmgV/PdUyS8qjVay
 rj3N6v6rEEStlRa9eY0CRSfRKQoFiqo2fHgLiCycEfBpBdUIl49x
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDMwNCBTYWx0ZWRfX3krLPPV8aYsD
 6u3+pc/HsoQyxt+MWexqeAIFHRg/xjAWOZMmN9zfVnRm9zBxz4MtpB3bhXVe1ZB4JGzo8kr1Dul
 HsbNdppVBE3W+7WoF3ijJQZKaV2H8JZkXtwRsF4/jKXNTDXfPRmGlbngZm1WxUpeu25wmZ06ITb
 qj4D2gXkfH1zYYSogKxUvoY252dPJc8iT6XDYJ4p8t6//bQhhv+8vo7QsMvJo67Q7l1dAXSVkLM
 4zrvE+KF+EGYoKYeiiS5FGHvkmxS06UqvxnpStUaDUu3HMMr8KQaIbu+VmPF+pyyo00rmlCluQC
 iUtLmUFHrWQvFPVDmk8JbLqwkvgwCg2uIzzNp2b6o3DNZMReoYTkwhRJnzxoDD56KOWS/O/KnVV
 2mxXlcuIvjQ61zb2fRbx9Qbp742VZAJzIZv82XVv2bL1IlUX7jquhKxMYiBRbv62YyCGo2E4MnU
 cCN7vAaLKmYJhl2tAlXeQIrgeiqrQXR1S0TbY+SE=
X-Proofpoint-GUID: _frijOjrJNEdePyA6VJmUyW8L3vyI7T3
X-Authority-Analysis: v=2.4 cv=GIadgeNK c=1 sm=1 tr=0 ts=6aa9af96 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=RpNjiQI2AAAA:8
 a=i0EeH86SAAAA:8 a=CMHY_B2GFhfEp2JUpisA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12108
X-Proofpoint-ORIG-GUID: _frijOjrJNEdePyA6VJmUyW8L3vyI7T3

On 8/21/26 4:24 AM, Ye Bin wrote:
> From: Ye Bin <yebin10@=E2=80=8Ahuawei.=E2=80=8Acom> iscsi_conn_error_even=
t() queues conn-=20
>  >cleanup_work without taking a reference to the connection. If the conne=
ction's=20
> refcount drops to zero while the work is still pending or running,=20
> iscsi_conn_release()
>=20
>=20
> From: Ye Bin <yebin10@huawei.com>
>=20
> iscsi_conn_error_event() queues conn->cleanup_work without taking a
> reference to the connection. If the connection's refcount drops to zero
> while the work is still pending or running, iscsi_conn_release() frees
> the connection memory without canceling the work, leading to a
> use-after-free when iscsi_cleanup_conn_work_fn() later dereferences the
> freed conn struct.
>=20
> This can happen when a session is torn down via iscsi_remove_session(),
> which calls iscsi_iter_destroy_conn_fn() to remove and drop the final
> reference on each remaining connection. Unlike iscsi_if_destroy_conn()
> (which flushes the work) and iscsi_if_stop_conn() (which cancels or
> flushes the work), the iscsi_iter_destroy_conn_fn() path does not handle
> the pending cleanup_work before dropping the connection reference.
>=20
> Trigger flow:
>=20
>    CPU 0 (error path)               CPU 1 (session teardown)
>    -----------------------          --------------------------
>    iscsi_conn_error_event(conn)
>      queue_work(cleanup_work)
>      [no conn reference taken]      iscsi_remove_session()
>                                       iscsi_iter_destroy_conn_fn()
>                                         iscsi_remove_conn(conn)
>                                         iscsi_put_conn(conn)
>                                           refcount =3D=3D 0
>                                           iscsi_conn_release()
>                                             kfree(conn)
>=20

It's not supported to run iscsi_remove_session while there's running
connections. That code was just meant for a qla4xxx mode where it
doesn't expose connections so the conn was just used to export info
to userspace via sysfs. It's for when the driver uses
qla4xxx_sess_conn_setup to create sessions and conns in one call.

There's not real use for it so I think fix qla4xxx to remove it's conn
firs, then check for session->leadconn !=3D NULL in
libiscsi:iscsi_session_remove().
In scsi_transport_iscsi:iscsi_remove_session you could add a BUG then
since it should never be done.
