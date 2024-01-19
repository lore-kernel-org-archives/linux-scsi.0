Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9506D1E89A
	for <linux-scsi@vger.kernel.org>; Fri, 19 Jan 2024 09:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705654971; cv=fail; b=WueV9sj0w0uliJVbgpfyqvvUgfjfa1n1viTY87ggUSIgMT673lFd+K+pGHjRZyXcacQ7toU/+OWaYZv9T46koJqgQ186WzaZblSnkKOgj437lGKv38nx5qwbVzgV0RD80BfGHrWR5kLAISsumaaxiMo9eISpSPNVwkN1qjt7DNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705654971; c=relaxed/simple;
	bh=fezCKL2nqohkvyCNW3stX+VZOacr+hhLmoH7x0hT88o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eRc/IUVocUzlvM6kksLW/XLowNWyGqfenMcUsCh5VnjAc2zfMXpALYcOA87/Dcip+PUVdbfsmyvB2dwGulm2Wu9xshXUR7AqrR49LzCxGz7sLYe/nsI/PmULfX4d5+ZuBRclxe/Z1BNyfOhROd4nnRW3VFgJEa2yRFgZD6bx6wY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eMesQ3MM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cty1/PQ5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eMesQ3MM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cty1/PQ5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40J6vl6L024620;
	Fri, 19 Jan 2024 09:02:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=iStddy9QMfWkp6CY8T9ZAv9UVNB9LhYx9DnXbShYJkM=;
 b=eMesQ3MMhEPRnryM0pCnxmBdxI0lVxRhfrreWfOlBORUoRB7FCwPuhiju/kLoCVSiVIZ
 tLEi7AOJQ6POmieaQaS9F92Ii377Uv+MPxh6RgGmGqrHYjJ139n3VtkuPAdKvkuFS9/4
 889OkURaK8P4Fw0BWECMYYmLdbNivkNJUDNsZ35c4WN5Arw1XTTBulB5nLDpXt+L8uoU
 ANOUbsmcPGlgqJB/NPE5fYjE/WBXbqemP1SoqpZ3qzxuWi+FUKK/I/obiMZI1/GPilgF
 JYqfwONR4LeZbXIfslHA6Ef/aYo/LUABLqH+2VokuJMao2Rdt7Dy8ojd0pC7n1FGUBW9 sQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vkq3h4pdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Jan 2024 09:02:44 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40J8ZH1R035804;
	Fri, 19 Jan 2024 09:02:43 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3vkgyer5wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Jan 2024 09:02:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1LhEax7StkudntOVdj1E1A46wJxwV4YxWjWFquP76RNljyXPO5uq3MH7crgGoENuLJOnlL0Ujfz+iwXahliOY65Kghfciw4A8npE1HAnNNDp9fqZY7xZNzhH3DMCAVjhjDsHa3nN1ewV5akkpBSSAbqJd2jMj+DtvLK87Pds8YU6Iq4Ozw+1rOGcTCH8Pt0rELpywswKI+YPm4cBOXSaij4YgpwZTirOvI8SUWB3dM88ANcsoscq0cYPekbIzJ6mgR9uM426HK4jpoyvvnyq3W4iATvcA2HWUYB1dVeD+tDyD6XMqsicVMrQnCPd67aJC5h3OBNKW0PklnwfkP1CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iStddy9QMfWkp6CY8T9ZAv9UVNB9LhYx9DnXbShYJkM=;
 b=I3Y5iuf1E2ZSoqssJrdAc5K+h9LfXkRU+e8GAA6YcOdGbtK9ulKzpPXunCdLz3TpL+Pec4XqJ2GLKjg7XPNIMuiXn5qnGO7QEXuhv+ym/8V7ZLBzzsuIznhGZFah47X0hADacvdMSuBWGNEqPwQv4UutFS+Z5Z0Uay45cjV7GzmD/n1LfupGtq3i978XRznbdTHECmEjz0V7sH2/Q471JUdMQtwWm+/OBduz89ptJ0iMR6HBiUrrSXCAsr+AnY5oxHQBzwv35sCbFftnLgzJlN4talkq0wd0OgBym/kqmdJMSBwF5+owLelmmDyrtbPc3LUVUbgTNmdE/FWsTF5WgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iStddy9QMfWkp6CY8T9ZAv9UVNB9LhYx9DnXbShYJkM=;
 b=cty1/PQ5dDxjsDPRcAM1ZKQSPZEGgATB8pZcd/iCt8x3Rws/ZM2amlP+IhBJJHcuVF16aEJmCPmf1UOoJMSJPVdIV3EUOn1IUBmr/bLHHqwdP3GdFWJiYeVCwejQzeKIcVgDV3NaEDlRkA5fgqtcUreq/usGqeewCzAdChP8ecg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB5883.namprd10.prod.outlook.com (2603:10b6:303:18f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Fri, 19 Jan
 2024 09:02:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::f11:7303:66e7:286c]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::f11:7303:66e7:286c%4]) with mapi id 15.20.7202.024; Fri, 19 Jan 2024
 09:02:40 +0000
Message-ID: <b8299e31-b3f9-40af-82d6-d347c473600d@oracle.com>
Date: Fri, 19 Jan 2024 09:02:37 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Update max_hw_sectors on rescan
To: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: brking@pobox.com, jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20240117213620.132880-1-brking@linux.vnet.ibm.com>
 <5326306f-9515-4153-9ef2-e978e775a27f@oracle.com>
 <62618192-aa11-40e2-97a0-ecc819815d0d@linux.vnet.ibm.com>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <62618192-aa11-40e2-97a0-ecc819815d0d@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P195CA0043.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB5883:EE_
X-MS-Office365-Filtering-Correlation-Id: 246ed8bd-b645-43ff-369e-08dc18cd63fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	C03ovY3hzcl0DvGyjnfO1B9D/zMsvQr4oloygpuAOXj02An9P+eLlfjUlzk+Z4wZFV/snfbAiqYZ3XZOUXFETPbBIBpc7vjZFeFSk/b8zyVZKU9vwZP4UfK+C5qpQX4SgrDxDEdInbpB7AjL1W8X1ocqu6l3uXlEwQhoN6YMouEmA+49YJurNoiaPZWZRM2FHLmKFhGsvj8eaIiX/A0y5xal3PtlTKDpgoLfZnjCluHzbbLbq1favOvKuImTRTUdGdDIvZ0p3zZkvV77V9HfqSbAGbWzl3MX4cWQOWi7lxhZS9aUtyhKS7njsJuuUYGcBdrpirO6lt8Mb0BrZppo0JsmDdsvwt3P0e6NaOg7MTsB8OywKzz2DWNR72DzWsZGFiuocCwV2CZda9cwn/3e+9fRXvXD742vrpytaolbt9ld1EMrwdD0xuJ1sDcylaszEYYSc2I9SE18MKRnDgXO3aEp0ANW6M8nBUFtsptYtCV8U4D1fHLapolcCMKcVEVzQk6egzDSUXAm78QcnhssflFkhiccCF9G+UE/s3pf5vuciLgOB8fNPqMeB4wdPWAn1+uQjvAS8+Jfn2V2PCgLQupAYIjl8TY5pD2TOYMUXd4A50trDWJV38vB2Guq8uCB3qzGUQ/wX6P7MYh0juKxwg==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(39860400002)(346002)(366004)(136003)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(53546011)(478600001)(2616005)(26005)(36916002)(6486002)(6506007)(6666004)(6512007)(107886003)(83380400001)(2906002)(5660300002)(15650500001)(41300700001)(66556008)(66946007)(66476007)(316002)(8676002)(4326008)(8936002)(38100700002)(36756003)(86362001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MDBYb3Mwb3dKdUhwUHpMUDJyaGJYVjdHeDQ4V2dTR2dSckU0L3IrNDNsSUNV?=
 =?utf-8?B?eFdHMmdNODI0Qm5xRm8vVStjZGN0bmVQYTBlRlRTckhaTHc3R1lWWXNKb3Zp?=
 =?utf-8?B?RnZuaWZxTmJZa2l6cHZ1a2NINVBRNDBobVVQcWZYTkI0bkRuWVlJV3dPd1Zo?=
 =?utf-8?B?a0JnVDdCZWs4Z0pwQkhzSk9nbkIybHNtTnVlNDFlQjl5UGZQSkVTU0hNQVdj?=
 =?utf-8?B?WmpWRGYyMjZka2FNOWc0VFRIcFFWMG9wTzc1dkdxZ1JUOU9nZDViTVY4WFZx?=
 =?utf-8?B?ajBXRDlSMTUweGJtMERRanEyUUtUazVrdFp3bHdkQUZVMlg3TU5HK1p1UWk4?=
 =?utf-8?B?K3JCUEkydzJUZEtVS3VGTXBlRk1INXlPYy9TYWphZGtTejNPcEFDaGZ6YTVl?=
 =?utf-8?B?dElBN2I4ZXF1U2xsUDN3Z2o4VzdxWncxZGlQYzRtVElMNGp4UDcvTU05TGQ1?=
 =?utf-8?B?bEdzUTFqNjhWWXVwT0RRUjI4OGlkQ3RrUmhzT1A1ZDN4QjJHNVk3UzZNNWZI?=
 =?utf-8?B?UFBGdERLa21uR1J2WlAxOVN1L3JhQ1Q1VXZIZ3RnM05KYkI3TXRJNDcvZU1C?=
 =?utf-8?B?dkdrUThVbWI2eUkxdTlQOUYyYnJPbmVOei9nTjcrVVA5bXUxc3ZzMHZUNjBE?=
 =?utf-8?B?cGVuRDdzemJEc3o2aGVFTnpZL2hsNzFSUzdXNVBMSlFyME5jbjU2Mm5DZElI?=
 =?utf-8?B?YXh2SHVucVMwVnVIcXpFbDhwS3RDODZZL0h3Q3VMUUNybTc0dndvT0JnUlA2?=
 =?utf-8?B?WktCeTlBcEw0amNIYVZxUzJ3SEtPSzdDTUpyWnF1MTl2TmRsQUVYTnR3UHJB?=
 =?utf-8?B?Z0JrekFnZjVSTHphbE5yZDdKSTFJUStwaXVmdVFMa1E0TEVhclQxMHVkTGVI?=
 =?utf-8?B?aUZ4S0lJSzZRcVpNMTl4ckIremx2M09YdzZFbUlueXVMSVdOcTFodmN2NCtT?=
 =?utf-8?B?cS9VNVpla0lVaXVxQktoSnNjZ1dWQ3dNblVaWEYvRGFuRThSbE1XcHVnR2dh?=
 =?utf-8?B?YlhaKzhaUlo4VjEwNkdEN3MyK290cXJQalllTndpeUgxU3BVckFYRjZaR3Jy?=
 =?utf-8?B?dkp1Y2czSVdHL0JhS016NWlkMk8wTzhPcG5nT1NoOFZzenozQ2ZCVFkybkJP?=
 =?utf-8?B?dGJlSFp1SGUwb3o2dVR2dE9sRUhjZzFZSjJyNEpIb3UvNFVFREJoR2FFSC9y?=
 =?utf-8?B?cGlZUFJzUCt1VVQzaUVqS2JvWWJoRWJtc2JVM2hIRndhdEE5U2FuRjhIbUF3?=
 =?utf-8?B?UFFXenBhN2k1MDFKdDBFUzB0ditXbFgyU0h5UlgySWlPRTFURjY3cTN0MWxF?=
 =?utf-8?B?emNQUFIxWEZaT29IeDU3SEYxUGRONkN2TWxKeVR4Vlk1NjZibngzL1owMlNJ?=
 =?utf-8?B?aWt3SkU4K1FKZ3lGTURNL1VQOVMyU1VqUEZXaTcvVWtPOHE2b3lDMVEvd2w1?=
 =?utf-8?B?Y2J3SjVrWHpIbEwzWlBvM0FJVVBTZEM5dU9vMVhKaDM0blJ4KzJoaHFLaE5w?=
 =?utf-8?B?YUlrWGhxbjVzYXZjSFM1UGRmaE5aQ2pvMWg2dS9IZVk2c3JWSDBMUlNKZ25F?=
 =?utf-8?B?UDFWbWFzNlNrdG0xUWErRjIxTmozR0l4bm91Tmw2NEtMTTI3dVlDYU5rVEs2?=
 =?utf-8?B?blRoNWlqbEdCYmRtWjM2SzBvTHVhSWUrUGZIN0x3eDd3MlRRVkkvUVZwRUhz?=
 =?utf-8?B?bWVmeTJQK3lxTjNwZmExMXh0elhlUHpnRlhzZmgreEtuSElVVUpBL2xpR2Ri?=
 =?utf-8?B?WnAxOXZOYlZ0SkFIYzd4OWRTWk9uSFQrSGN2U0FUSndLcVpUVlNoODRycHNz?=
 =?utf-8?B?djliMmtnN1BMS2VoVi9tai9VTnJvKzVZdUVrd2d4US94Y0psUTJ4YzM0WU93?=
 =?utf-8?B?NGUxZXNLY284bEtNcDlwUmgyeXk0L0VTSm9QMFF5WnFiOXRYME1UTGlPeFo2?=
 =?utf-8?B?Rk0yN2JKYXlZaGY2dXIyWmNuYkF0cjZzUkg0OHA3elFCMmxCZVZlTFVHQUQ0?=
 =?utf-8?B?MHRpN0ZyYWhSUWprQUtpZ01ydnRxcFpHa24zRGppMFk5eG9oQTdzSkI4TEtL?=
 =?utf-8?B?ZkR3MURnbDdJaVVTMlkwUTcxRDdGZ294ejRIWVhzMytIRmpVd0syYWExcEVU?=
 =?utf-8?Q?g39BjwYHxfaFJRD0MbbnEtFu+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GgdlWwEU8VQ5iuAw9fFDfE4m1qjW/tVJ1D1XAO3Jk0GzSqCMUU6d6cnABa62nUcJn3INNlFBup6PtLUEvWcgo62t/YioYLRKM0+N2wDyfrcoaczBMq8rDHP5Nj3QEXom+LSv7I2qp1Zz/6OKza3ydnJLm+X03ZiGWgPY1GCjbIP085uc6gQVVdWQsSsfbcl1zyAHjve2uRbxfX6eDLAabvJr2h1O1pCvXIJnserobOvhAtwCsdrX6QckSlZ/ldB6qOqFv3N2oZV+NyrD3FmYe0wL2wVCXvAEJKAJp95CMqjBNGMR9h58+hieAUbWe9/5gyOLZhx3Y+ohZ3xZp31oh5aol/GpWguZs4Q5VpYAnWNr43dzAOILzKaLcQSoxhMMMUPHI9HQ9cM7tVDgVwskjVIvDmeQQroEW3lYsIoTI0HZ4GO6QkZwTeAOrm7cxiX6EQtI29R2AWH53/NH+tf59XkE/vJnvLb54og9I8pFCToT9gT9NsX5WoTHnIs0KOmfuXyEXkuTrbI5Pwwh4TxoGZYNVVHQoz8MlKR7QQUaZGb3UHnb/adIKHIU20XIALbTTJJgBXNUeSi2od1Eh36JMqRZdxfDtgD7FvxVkBQWbP8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 246ed8bd-b645-43ff-369e-08dc18cd63fc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2024 09:02:40.6922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vh1VuStmTK+TTWPYVv0g3TAYXyKFmDzoelQ9N+4+K60HVrBYLFqd3DLxEfpPwW1CFo4Sh65ItE3vSsj5nmGEBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-19_04,2024-01-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401190036
X-Proofpoint-GUID: 6FQb1n0DhF5u44aZuQZTIsn2cOXKScPx
X-Proofpoint-ORIG-GUID: 6FQb1n0DhF5u44aZuQZTIsn2cOXKScPx

On 18/01/2024 17:22, Brian King wrote:
> On 1/18/24 9:44 AM, John Garry wrote:
>> On 17/01/2024 21:36, Brian King wrote:
>>> This addresses an issue discovered on ibmvfc LUNs. For this driver,
>>> max_sectors is negotiated with the VIOS. This gets done at initialization
>>> time, then LUNs get scanned and things generally work fine. However,
>>> this attribute can be changed on the VIOS, either due to a sysadmin
>>> change or potentially a VIOS code level change. If this decreases
>>> to a smaller value, due to one of these reasons, the next time the
>>> ibmvfc driver performs an NPIV login, it will only be able to use
>>> the smaller value. In the case of a VIOS reboot, when the VIOS goes
>>> down, all paths through that VIOS will go to devloss state. When
>>> the VIOS comes back up, ibmvfc negotiates max_sectors and will only
>>> be able to get the smaller value and it will update shost->max_sectors.
>>
>> Are you saying that the driver will manually update shost->max_sectors after adding the scsi host? I didn't think that was permitted.
> 
> That is what happens. The characteristics of the underlying hardware can change across
> a virtual adapter reset.

That's unfortunate.

I don't think that it's a good idea to change shost->max_sectors after 
adding the scsi host or to add core code to condone doing it. Indeed, 
there is code there to limit shost->max_sectors from DMA mapping 
constraints in scsi_add_host() path, which should not be ignored.

Would it be possible to initially set shost->max_sectors for this 
adapter at the lowest anticipated value for that adapter and don't 
change thereafter?

Thanks,
John

> 
> Thanks,
> 
> Brian
> 
>>
>> Thanks,
>> John
>>
>>> However, when LUNs are scanned, the devloss paths will be found
>>> and brought back online, still using the old max_hw_sectors. This
>>> change ensures that max_hw_sectors gets updated.
>>>
>>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>>> ---
>>>    drivers/scsi/scsi_scan.c | 6 +++++-
>>>    1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>>> index 44680f65ea14..01f2b38daab3 100644
>>> --- a/drivers/scsi/scsi_scan.c
>>> +++ b/drivers/scsi/scsi_scan.c
>>> @@ -1162,6 +1162,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>>>        blist_flags_t bflags;
>>>        int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
>>>        struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
>>> +    struct request_queue *q;
>>>          /*
>>>         * The rescan flag is used as an optimization, the first scan of a
>>> @@ -1182,6 +1183,10 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>>>                    *bflagsp = scsi_get_device_flags(sdev,
>>>                                     sdev->vendor,
>>>                                     sdev->model);
>>> +            q = sdev->request_queue;
>>> +            if (queue_max_hw_sectors(q) > shost->max_sectors)
>>> +                blk_queue_max_hw_sectors(q, shost->max_sectors);
>>> +
>>>                return SCSI_SCAN_LUN_PRESENT;
>>>            }
>>>            scsi_device_put(sdev);
>>> @@ -2006,4 +2011,3 @@ void scsi_forget_host(struct Scsi_Host *shost)
>>>        }
>>>        spin_unlock_irqrestore(shost->host_lock, flags);
>>>    }
>>> -
>>
> 

