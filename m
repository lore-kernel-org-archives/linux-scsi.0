Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3302C184
	for <linux-scsi@vger.kernel.org>; Thu,  9 May 2024 01:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715218902; cv=fail; b=LAR6SPyw31jgroZY0p8EhugNSE1rmWLayj+sHicRTENFYf2FvWfj6n8xY6NcwfrX9myZ/siljdZDqGgVDVq6LYHn2Sdoc4fukuQeNydt1g1C2+g3hmLFB06T2RyL2hANW8eLxHryC/SRHT4xncGr4+ch//SQuqb8ZPSzeTpkBck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715218902; c=relaxed/simple;
	bh=tMQF5ROuDEBkKBpj0dqizuLG9o8C264DHi8XGfz8ggY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=saIkqPC5jHS+VWYBMKtY+zeqzm/IsgNsC4g4wQh/XFH6reYfTXGRrOHrZpwRMr1zuNqJqfhu+MIBE3krf4nvMCloi3DWElSrOO9VZAHS7fq2l52Amy6YwxK7bleXzYiqLkYxJRc9sI/JS9ZqfbkXinlQ1ua27uuNDc//TcFyCl0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UP9OwVHK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XwEadmD1; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UP9OwVHK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XwEadmD1"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4491V7Fa022982;
	Thu, 9 May 2024 01:41:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=I9CR/e1TeYzLNhH9fhJbKlOGMuBFAe+PKXOezsUwufU=;
 b=UP9OwVHKvt54/L6saVWCH0zPJm3Z6+n6d6IE272zZpWVVk9cmdACMhm4ltaUPeivY99Z
 qv8GrjcPgvFs0WR7Og6sdP2++/o3PVFOpn7b26mgVk6loJ4hIq3XX41FFYRWW9PkE31m
 elGbOeZeh/GjJHjNU5eJRsqR0rQI6J1nGMc/E24dsiA2rHQXnnUYMkrSCPkBtnnWNasW
 gVy0iaYD44JbJ0NCILFv/VAaL+AiApXKMLZtcN5M+Yv7IOq2QzXXHEY23rcxTBATSHgo
 dg1nG+nZ0UaoFW4cmTac2n7pQjqE+c5y3i8Q8Z+RD2oqhfDenNfvIS/WfH9YP3c3QmdC ZA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y0mw500bk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 01:41:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4490HII3030914;
	Thu, 9 May 2024 01:41:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfmt90s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 May 2024 01:41:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dzu8XyVEO2G0GUYYJsnpiHlFiu+N/4LigR8GQUeB1ZM+MRlfto9jwLHuR+Ppk7GNLk4GeoTw+9+oqZtvPY7gLMcGFoXO8d2oL4hN1aJMQkYKl6nY8yP6gYchTbhPTjX7QQFnmVDlZKDUO02DYfwVu/1ArVv35OVZTyt5zirHKmnmyLSZZU0TvKeTBvxPnyJrLSkU1J2JkcY6L7h5bGcY/Htal1rRSp1iNPXZR1aUcjnwweAycjw6FhR8t+laZkuA90/9irOCToQD0O+Nv2NvRvblJzfdRGAKYn4Lyj/uT9pO9LBvXlnvjn6sKDvMGxQ8xsx8IenUWwQcvj/tAlkBew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9CR/e1TeYzLNhH9fhJbKlOGMuBFAe+PKXOezsUwufU=;
 b=RJGQTGYI/mfC1vEhtptnZxszUUCgzQfxoRX4fyhJl2n7WfSSTdPhV99xLY3XqbaycTVopMk119PILTlRfG2bd31ud+mSA0HTgi3n/62ZhFi5DV1xW1XBBEZDZq3YI6+gf7ucz8pDe5DgL3wTEV5s2eUZvIt7zowrt55JQ7Q/BV/cClsjSXdzSdrKujxszmsbgMbD3OxPpgiADGJSXpguGJ1J+wRXIAzm3qFB0um6AOgX28Ep2lS1F3CZ5o5McBADbRLVBGuhg6XQQTbgyElze+CFyakp8oGJq3s+OlBKK6qv8ejStkOray/hUi0A98rzkhXHImDzTNbWJgKYmkdcJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9CR/e1TeYzLNhH9fhJbKlOGMuBFAe+PKXOezsUwufU=;
 b=XwEadmD1wXPouvmpn1odSz4MXr4XRwzP9ohbjMZCYWPByiWpcJ50ukqrQ6aKUk1+DCNX359RJEMH6VIzbSly5kc7NzqqD5Kos0sCbwBLQnXtEVhiyAPcWRFQL2/QV4XCGcV32+Ntf0pi6RwtNhVAooDXlCtLR4oIDNDXjnhbRRI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4983.namprd10.prod.outlook.com (2603:10b6:408:121::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Thu, 9 May
 2024 01:41:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7544.045; Thu, 9 May 2024
 01:41:28 +0000
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org,
        chandrakanth.patil@broadcom.com
Subject: Re: [PATCH] mpi3mr: sanitise num_phys
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CAFdVvOwuAc3TdtA=Z-z=NHWYken4n9zcUJbh177NxREX4NaHcw@mail.gmail.com>
	(Sathya Prakash Veerichetty's message of "Tue, 7 May 2024 08:48:43
	-0600")
Organization: Oracle Corporation
Message-ID: <yq17cg3wymd.fsf@ca-mkp.ca.oracle.com>
References: <20240226151013.8653-1-thenzl@redhat.com>
	<CAFdVvOwuAc3TdtA=Z-z=NHWYken4n9zcUJbh177NxREX4NaHcw@mail.gmail.com>
Date: Wed, 08 May 2024 21:41:25 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:208:256::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4983:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e58491d-4278-4ac6-a1a4-08dc6fc92505
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?uzFfh35JcohVzVvD/nf/PtA9DTkvk5wAgACprvwr8SZjcVwUdejGutiqQqRa?=
 =?us-ascii?Q?8pzpXaa0SjDpaYcngNL7MCEppkBmllQx9YzmifZP7bMQ/YSXgc5QEQxZPiMC?=
 =?us-ascii?Q?I8txKza6oKjABYUSDFLVZ7Ufow3oA8edvKVQiKzRXvY74lwGMoUq9QTp5krN?=
 =?us-ascii?Q?QvLTs2pmrN7qbjjNs0Gs81ovtr7cTXqfqYuHXf/c5ztNEWIX/Ad0cprGb+I4?=
 =?us-ascii?Q?3QbKCp+/UAN6BB6oINGnF+rzaWMwBg7xBWSQoCkldGTcClrvYuEjjbefno9t?=
 =?us-ascii?Q?m9sIsTlVHanTcgnoGGeZJH61XvG3wzgIBiQyk0mrTMXalPfjD+z5zV7tmPFw?=
 =?us-ascii?Q?yN8JWpfJlVmeXF1fh0UGmCvPoI2BrQKzijOyyVHGd9M7EDUJ/CPRbp3+5PH1?=
 =?us-ascii?Q?eVCsXa4JhgEXjyKnfRp7ka5dipqMXpSZPXKsrDHFJtcisPfdnmM2Oweuc3eZ?=
 =?us-ascii?Q?svCtrDg0p+xwqFHpue81zO1Z82TysFGpbZfwwwBTyZ8qIpuYGn0G/UGBL10L?=
 =?us-ascii?Q?GrFsn8YytQEYWSAokueoX0YQw9JBWcVDZH0dV2+Jp5vzjWQQP5ga4pffea5W?=
 =?us-ascii?Q?nx64EkcffF+30IGzzu6xZltfU55fBPUPunyAQdOgX8jGu1pEk1XvR2ihZBYm?=
 =?us-ascii?Q?y3lNIE/oBHTDDu4rdH2qggsBPBQcRf1CUtnd3p/aVly5v3rn+vuy6jfruLsw?=
 =?us-ascii?Q?5g3DR25zNnuL6DWzQ3Lnhouxr/4efv9ECzWR7aW6sLgt4PZprc66KSjE6WkN?=
 =?us-ascii?Q?KnFJjf+meCKSyVTd8ULWtlosb4ouoWnwXK3n+Ul56HySPkBZGDPa4Tbqc2Gd?=
 =?us-ascii?Q?7v9TH3PAu1QHp622DoCPZTNcltk3vya3AVQtZMzA6q0Oj/K9YDpufmmb4zq+?=
 =?us-ascii?Q?DafiGcLcvAJxBT0iUeCmnscC2xAij4whChMOWekuxP0esbbN8H44a2AE1eu2?=
 =?us-ascii?Q?BxYqaGQF/NaOarXQtrDL0lXZIaow3LSUZox4e1AppfLMYhqLIGmA1hWkfs+J?=
 =?us-ascii?Q?gbQNdYPnq8VlYB+To6vDatR0Qlf6VLleqjHkxSw+Ol/W9mKwb7u9oGQp2TtV?=
 =?us-ascii?Q?ouxnp6xWTDoofx7N4qG77RC03ETFZi/rPGG9sSy/FVpKfz5AHKJ2MN9AQdUQ?=
 =?us-ascii?Q?6Crq0KVvqQy4nHT5rxQ3uPYqtJrsUEvMISb/8nVQUPCPv6a/o+q+gwCuomNS?=
 =?us-ascii?Q?2vkBjZcpFzu6trIyLh0xLxLPKqk8lDUHc+1mJqbVg8Sh8fBaRJ4pkk+OOfcC?=
 =?us-ascii?Q?HR99NN4RzJBBchhBpx+d4SvbT66o9NOwnO62XaAoDw=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?3zfXQN6nWgQUtwaYw5fzbIFBUCtnQ5mIhYOpyBZH1inV6SuH55ec3U7tMPhY?=
 =?us-ascii?Q?YFKpk83pUNlcHqGoX8cUgqk4iIfPd/VhDgxB/6DhK7V8OKdLKUFiN4lUWaZq?=
 =?us-ascii?Q?GQ7abMkHvNQ4ulnRF1Og4UXMRjG5l+Wxd6SbTdndxg4he1KkDtOi6yE4HpWW?=
 =?us-ascii?Q?PtDNH5c6a0yD2unToDEjyl+0W8nifJWzjAw9f8WWTPIuL4j06Uwg1MTND44m?=
 =?us-ascii?Q?OP/yEVGTw6nyPIG9UzfK9UfqYg8G4GTCe/6ULrQld1C2ERPubUFRpW3sPg0O?=
 =?us-ascii?Q?2ZgKIAMZMwy75/A/eDu9ja5sTV4jojIyJM097F4NPfTKxYDuQpiMFSvZ5YcA?=
 =?us-ascii?Q?IxpTBb+W7zgvQbd30TnH3QOBvuptntnq21SuCQ1036nySakXEm8Wg44KjNqi?=
 =?us-ascii?Q?6FvpK/Kkjsd0IuAPeq9nLWiGZB4DgxHjoWgDe7v126DmuZLIzPMzvyTRJr7G?=
 =?us-ascii?Q?zxUUzqZHOeaWKyVMKRdBwRaIMdfa9XuK8KS6xjRi6A7vYhvy6ReRo9XBjc3I?=
 =?us-ascii?Q?+4YSJGYj3Jmo2RkT1KjQs5ubu0T9Bhg6R9X5ztwy9CfTztvhjFmkdbTa5WaF?=
 =?us-ascii?Q?zLVDN/bKAe9VH6hZdAM9ZjzUEihdqLBhX8xnBya77kY/0m2nkPlyHiPYTpMI?=
 =?us-ascii?Q?9VFWtihTOwVRqHyU3tTYMpnYheDoQQm/5GOcIVEgqF7lBX3aPIcEmSGyBrzl?=
 =?us-ascii?Q?9GRgWjvByLp4FXsfR0I/BJl+m3IRN/DL/lW2fOqB+pm8AFIng/OjVRgAgw8K?=
 =?us-ascii?Q?xlAmjDpDy6P9UWGJEC71ASZqJpogEjn1tOCioOerjX3ChtDurFGRHJ70nk4+?=
 =?us-ascii?Q?TeiHNovJV3/KfN474W0dSj/jsAR4cZyB19OfcUNsOiW/yYdziph9BHs1MzHx?=
 =?us-ascii?Q?EfISNSD1mvO2ckxSikCNNu59hi3fcoMOpstc7qudeN+jgvkLxZG8FeQgXc/n?=
 =?us-ascii?Q?dCc70yttvjztiF6mG+IhXPRiG4JR/wcY+PKz2UxsZtU4AeZAduaw78AYqvMO?=
 =?us-ascii?Q?7qbD0H+T4dDXsLhZNCoMpb211WoU3E8SLrKnXs15EkjTDJ1zxXMhFUu53fTB?=
 =?us-ascii?Q?KfYobZYABE5FSfm6euCgEsHbsBC/w5XsshC5zqeOuj+rer3nddSX/ysD/Viz?=
 =?us-ascii?Q?tqa3OaxxfWhUkIRIiIHsN3B+c+s/ajnBeyO+17bDr+YyMszabxD6quw4hLE4?=
 =?us-ascii?Q?Tp0VOC/AxvdSUm2zUIfyAnPDfqz70EI2pydrXdS09jLMjgDY0XVl9zVO5D+T?=
 =?us-ascii?Q?E6fYgrS316NmQ5/vC1gQhdy+BkiAK6KhaNpoN4ESSWFq2qVgnx8JETYDmhGE?=
 =?us-ascii?Q?TQkEL1JwoYK4FFwI+Y+R4rdF2KZxh1+7JUm4yLJg16Paf+1C4QGQywoiYM4I?=
 =?us-ascii?Q?cBPGFnKyaAghWqOYs9FURljVLDvZ+hM2vK5x5zr7qSYc9EP+nHbBOW/5UTlf?=
 =?us-ascii?Q?QH4pKn0/M4NS+aM3dVvfrbIvo/hoHu2Se8RHwdQXE1t952xjHLQBJrDkdY6M?=
 =?us-ascii?Q?TsWhW5p6Z/tmDjnGKV98uzJRuZluOinIK63ovDvnmFPEioLc1KF+ZRSI1J0F?=
 =?us-ascii?Q?qA4oTr40Zaje8t8KN9ZOu15O/DNWAJNLBMjNyVIWcq/zWNoJSBsN3c2WuQ1s?=
 =?us-ascii?Q?Uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	OlIwPrT5qnimLfHiuYUbb6FUeRWHgOzrdrk/9PpQ2+1jUKHpIu4ilp9T9zvM8KFgDFKNTvspDK/Ffw2GYm0686ce8dBZOHW3A225Mhl+Tnk8wwmi/la7W5KG8WeUiJm9s3maqFSwm3WVghWqyDLI6NeFR8D4jR14cfFFxjaQlp/gfPYyio4Ar2bh/KhL7nbbXwkC/uTzK4YDMxPnrEcfC06tQV6MOWUSWw26La5M4CZ6MT7lurefFvvbPwtD+NWqxicra27hV9uA9/XkVLgij9Usy/8L9gKTDVLKf62WdI5rEGwhPfTmuW0Yw6bHBVnyWY6FCHQjAx0NLfcIzHmPQym+QJAyucTk6WfZk1TOFGTTEcfz/w4KkEAVVlh1q4UL3n5pZURRPmFXsZXF/at+vE6JYiIzK1b5IT/7DgscMjBza5b24bQJ6BG0m4EN/kMMAgjvMJ+546VOvENg3QvNwO6M00LDUe9Rc0Qd1plszo02MKICccaRTx4gVu77xkCJfhYMTzVeuXJIWif3YDErad00rmK8Mh4jYQrUKBQ8XKodU4fgWZO+ExCfc5WRHEWm8s4WLJqfeYd1iPITjzWiw/1PDsSF238K35l/f0szfgM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e58491d-4278-4ac6-a1a4-08dc6fc92505
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 01:41:28.0860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SQ/Dc/BNHQdJpiR3Qrf75WsMmet4JcMqHG3BsqSeqnP94MS4WZS9JwyEN9IzAyoXYFXvLXft/AMl8ZkRQw2AKVHxojKsXXtKqm2iQl0W2lk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4983
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-08_10,2024-05-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=621 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405090010
X-Proofpoint-GUID: aVvF11yrUE1Pa6ioNTdBgBjhlD48Zp7i
X-Proofpoint-ORIG-GUID: aVvF11yrUE1Pa6ioNTdBgBjhlD48Zp7i


Sathya,

>> Information is stored in mr_sas_port->phy_mask, values larger then
>> size of this field shouldn't be allowed.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
