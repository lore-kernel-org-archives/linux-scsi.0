Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C73B13F44C
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 14:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715783278; cv=fail; b=iLEdv+WxlyTi/Ul57QoJQtQMBfSZXWFKomuDwE5yN8DAphRmg7emoNB+mf2vB0GY8cznV6PmJUhBIBqA6HsLcdzGmU0IJfC2rduifDc+zbl8ZDnDzhMf+INQ5mjwisnYpavZQT3S5C7FIhUErLiPoy1woiNJIUHVw7FvslmJVLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715783278; c=relaxed/simple;
	bh=i+NtGOOIGil92Q/HEuaW2Vv/iSYCFSm4Nj3F8IubmZ4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=okq+6Rc32mURTYqiA/M5f7Tl2LYs534S8FE8jf7IudizHYmUUniBfWGp24rH0MSKE0JGzIk0IsPdShiUKVw9xDhWgHwRLI8re6NL5gkylu4VrtW8ra3Or6gdtLlyhr1Lwq5Mr31/ngb3iVJ06kQCgBUXeoBizdiB37Xryxlro04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RjUZVM1l; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M0od1Dtc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RjUZVM1l";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M0od1Dtc"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44F7nFXe024773;
	Wed, 15 May 2024 14:27:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=txMFwIq3oxr6YhpivZRyCGwTZC6flv4yy/F5jCDWAhE=;
 b=RjUZVM1liD5Q4uAELsCwUSAg0Y53AvmWcVETytqUkpWAvvuPqP2rBHhwJmjRONo3XuKD
 WyvYwnBQk78P7jcs/2zKxbXAR+jBZZjDmz9xmMY9Q9Lj3WaHounHQ5oUKB+aZlwfaBsf
 jbEcGZVaP4x55WtSzJNMteBEaU7zV/6XzoMZhJ0wyoXTdVDvQ1xsmvXY1lnqPUn4lTPq
 tJM785brZhA+SZI4FDYL8Y7MzjtScsB3kPwM1KOUIw+l5D17f225L+s++I3YtLauuXQF
 tbxOK5mSS//aeeEzavtDXh4nbEzvmx2+oipnjiKst9ZkKDaO4XQs2m6uNbZWOnX+Bd0g Kg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3srruau4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 14:27:55 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44FDeMbu019344;
	Wed, 15 May 2024 14:27:54 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y3r86dm7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 May 2024 14:27:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=am4HYsSrOsrHEQfbKE7+GY4/Sxtnz+mTYlzFUTkeLJPE0xBQXQ3wriSnIn1tS2/QaS91Ak1qNn0VQeOqzebqbGC5vNKQzkd85rKWH/nZerQ5rxYN0OTHwj5Cck0u5JZxNy16iG9ykkvRI12J2OWnfa5JAVmCPAttpko0GRA4tcObdvbLiUxatFrL/ndZfr03koByI6GmkSCJ4ZqE3wbUJV5bLPvKIJ0bXh33cmnN/2fVhUv5OzEujEEAK9PkEH4cn5uVpbUFxNgFud70U9QXBcxiiLqFWgXq7EHfVYqal6YswbcuKuKAAB2GEpkJodw77EHucAMoWpmcH8YqzjOFiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txMFwIq3oxr6YhpivZRyCGwTZC6flv4yy/F5jCDWAhE=;
 b=SbdFttuHzGtaAlm6Xg/NwwMw1Bj9piBqEQkRYwwX/OpBfza1G3ypi/uoAJBgIbsuLLp+AqH7SibfLIVl0c+/BT8QCU4/ozwwXzz2B7NtQ9TCYQw6qiJlu7HGIrf9BWUqa8K8l3M3dvzOdn8fmcjI7JL2jCLNnXalTl6jXj3WeL/2d4vqhi7NKY9pWFBGOeV7KQVogoOAnCoNgNPs18TmfCLuBD7qUkyBYiofPIxib/HaKtMfjqx0EhTlR4LRAHv9cvWCuskZmCiyy/1VhJYB/LEkVn2jDXHLKBIGQK/HfQmudK7TFp6bslPAqjrzUIowemV1z2EcC8RGm+pIFVwxQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txMFwIq3oxr6YhpivZRyCGwTZC6flv4yy/F5jCDWAhE=;
 b=M0od1Dtc5oRSPGEmK0m1i0LHpzsTrDCSd7Tc1ezx0ZghmocW/zyaO2c7G6QSMRMZkxw5p48g/vzXMpnEZulJjohrtGLQrzxDD1t6CM4C8/e1Hg/YUms3pS3a5nBTZ3EtuvRQ3f9qMP/9L035KDjTGCO+++EjZxGluwyH2dS9vIE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4532.namprd10.prod.outlook.com (2603:10b6:303:6d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Wed, 15 May
 2024 14:27:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7587.026; Wed, 15 May 2024
 14:27:50 +0000
To: Saurav Kashyap <skashyap@marvell.com>
Cc: <martin.petersen@oracle.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] qedf misc bug fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240515091101.18754-1-skashyap@marvell.com> (Saurav Kashyap's
	message of "Wed, 15 May 2024 14:40:58 +0530")
Organization: Oracle Corporation
Message-ID: <yq1h6ezrvzb.fsf@ca-mkp.ca.oracle.com>
References: <20240515091101.18754-1-skashyap@marvell.com>
Date: Wed, 15 May 2024 10:27:47 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0022.namprd08.prod.outlook.com
 (2603:10b6:208:239::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO1PR10MB4532:EE_
X-MS-Office365-Filtering-Correlation-Id: b35e46c0-ebbf-4dbd-5d39-08dc74eb333c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?6ZQkl5+VEjCRloYapFrNHc34F2Pyu/cvV8L4U1SabuLBjisSBFolbbHf+4L+?=
 =?us-ascii?Q?kZ6NaXhEbZARnnmz2Mvg1Jwm6LIxxs/JW3BC12F0nbF4uBgLU5O2/8veORw4?=
 =?us-ascii?Q?0h4h/MAVPyuvU9bh0icHUUQuSVZ6zuEqcGnWSfQXHlUDltQiv67/52PA1jub?=
 =?us-ascii?Q?4kJ6lFlS6o7o2BVG8FktPVes4uoscZvcQtCKmfcq2zBlW0EheBQneE3Pm0zH?=
 =?us-ascii?Q?GUkHBXOHrMzO+FZAMEBcjHkobESj4z2J3PFsDBv+cCMZEPhY3RN5fJcx7eod?=
 =?us-ascii?Q?LXDxNpAdEU3HP4H/cdRY6ZxkQH+55gkGCOOGSCMqmOk92NlxC7N32igFh1PU?=
 =?us-ascii?Q?/UaHieK4mShxsKDkM/dmSK5XWqjiqPF8YnOle8oyYGL964EyVFR50lxpyIvY?=
 =?us-ascii?Q?FPWT+LzxKJTW3zEo4jNHs8zTIURfgnAV13b9pDUmjppWDboM0LIyF9PXL4KP?=
 =?us-ascii?Q?xDG62Rm86Pcbu9jPLf+i/mc79UQZwE7xsZ5CRMnCI7FiSLvtbO13A/kstwVr?=
 =?us-ascii?Q?PfWVX/Zl7temStue2YmABLfdhBsY8L8GAiNS4WZ70G6qdsL8KS9PRiIdAfIO?=
 =?us-ascii?Q?dw5kKuYRmSCTIPr8nwEMw6RNF4r6qnWUg4b8ByJp7DnJbZGwKnhbJmsyn43W?=
 =?us-ascii?Q?HNkRjQ+a9mhpg98dWFqIM7Q3ZGv/kMKg16ZHeh4Y2pbTGuacUl55+TqMkAJq?=
 =?us-ascii?Q?+fxFiwaPooukXQcGVviamx/2BYnpLZDZRhCnR4InjosGvqjszlUHinm2uCug?=
 =?us-ascii?Q?P5lsQeg4Q3GLmLafLqohp9bk1rnJ5BqAxtgrrXqM0IvPWOxFcLo8jZMk0VoL?=
 =?us-ascii?Q?cbE0uc6BzWbo5CqAI4crR34LkWp+F+rmPdo150zUB6ORCXX5uMA374fsN58Y?=
 =?us-ascii?Q?EBAIFOV7f8Ni1lCN2nszrdD2z1Y8DikuMbhVE4f4rWl9H1FwTyfY1kDJ8GzI?=
 =?us-ascii?Q?O2Z8S/yiZu/DEM68TBCDo5Dxv+neBXlv6ngW9irlI870p+X784ljib/nHrvs?=
 =?us-ascii?Q?LEHr0Ss9AqEdpD3RRS14aCSXceTp5sygUwjCSUWEvAsdd1/JSxUpGEzal8SL?=
 =?us-ascii?Q?erjFpsFuBKpBhOpyPEeRWWdHTGRAcB5BkNe5BxIRMPGFqO1Z9NwsUgUoDzkD?=
 =?us-ascii?Q?Q8Ef3EvEUR1jP5dSpJ8hjJPYHH7dhFnDzZDZMGFvHw2TZgUuYIPnrFuH9I6O?=
 =?us-ascii?Q?yZJXIJG3RwoxsP6+2o4AMWInwx7jXHA3Ta5xWSixeXuzKizoEcBnQz9fp0G3?=
 =?us-ascii?Q?DvBEiXZV0d3XMmksL6YDSOlULbnyK7HClLU+jbp4/Q=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?VdnBGIwr91ysEbGGC881fmaM+qYNvUfEHSTYh3L4TlWho070sfTWSVfSyj+m?=
 =?us-ascii?Q?GCSlAJJTMMT0A1yYP5kCx1SazMUEvPWV0CZCR+QEWc/NCwBVa+Z7M1aSw3iO?=
 =?us-ascii?Q?/MR2krdjEKfswKKN8KKXJqe95f4xlIaNA6p2tsmadLhPvrxzGbVSmYRgNW3M?=
 =?us-ascii?Q?UxwJPxizmDT+B5jk6XCt9PS4dNVlBVGwkr3ujEo4mZU45u5PZ5eSzmuTbmZ5?=
 =?us-ascii?Q?QJjyXhRQKwaf0pE4iTTDwU7XO9/Pd24kWcGy4JE8JSePZq3sttdoWFsbFzvI?=
 =?us-ascii?Q?Cp4Vq2Jm1xdLrU8yWXGS00f5p+pNiyPB4exLzYoLnkXYfDaVAu8WLpALhc8m?=
 =?us-ascii?Q?CfZ5JOHxMAHDroAKp1cbRLTJcVplbqjEgRXK1oRdWrMZkLY+k/JI+Wtntee1?=
 =?us-ascii?Q?uCixU1LcDHKN3TosyBOHCAHB6mO6b4ifGuB/+myQunMMchKrh4eWAZlr2Ljk?=
 =?us-ascii?Q?DrHTyzz7dCa7RRGlBZufVXrziqSb7MNsKFwztmvTWqvlH0CJCVsDrykE9lqy?=
 =?us-ascii?Q?heIQc9H26/PjiUgKEsxp8RNfHJpmIQNnFS+/vSiXK7kddridlfSsMbtX4uFM?=
 =?us-ascii?Q?d26zhPY80iMUDtPoJMAZQvseQD3T04ZJDrZz9NGFISsEQW5iV6rmuXnePuWr?=
 =?us-ascii?Q?2N2P0qV4RxkjEHw7F11QVjdUEDqw5bkcwR8ulEDHSlPH81sR70x4f0U8L+FA?=
 =?us-ascii?Q?9Iq//4kDHllAjZkmMuR1VkedRbQgCkz2uTHf+/H2++ditt2ygnSTvsOl4pJK?=
 =?us-ascii?Q?6SVN17IMpVWI+ZOSSp4O2xzp6J8SEQGnze/461iIQsWSjnGmfanyThcbTzlJ?=
 =?us-ascii?Q?gtB2AREavsWwq7JYFdM+x63gj4moI7hUzYdFaiZu5ZXR4qgelMB0YO/xAtya?=
 =?us-ascii?Q?dDz+n+ZA7erZEV2zI9XxTuHtTvVGgNK9p/fDb4P+qHRb/PAeG/oLcuU5YG7T?=
 =?us-ascii?Q?CbBRDz1FUcjAKomUaxmSlC/KOa+In9S4DS/svPKFWCH7ffi5dQ3d+UTJjNb/?=
 =?us-ascii?Q?xmjFeHUdZfq2dS4T3JUo1TVjPiKvtecgre8AXw46YkMQLt41nujeCXC285cT?=
 =?us-ascii?Q?Ojg5cYWI8TEoqD40enmwSednucP2MR4aV1q5V38bp5I5tWIn1cIdFSpcWhi3?=
 =?us-ascii?Q?m2K2rwmoR7LqUM/T1qSRH0URuLVEdUbEtXs+IUKQeng6QsexYhz7SebM0oCZ?=
 =?us-ascii?Q?DhsHXBrKAMNsrPBMwzO8YyccOOXCACDvBTQY92FXFFTzgxa9rD7rbjvDgRsP?=
 =?us-ascii?Q?3UPwS58bvcFgfl7RAr9D+Xn248BV55EHUpMmHjp+I5t5miTcH7hRVjSiSvir?=
 =?us-ascii?Q?/pjVxUuAGPskmzzgy96KPFdTlROv3nFNVxtQDl01ltgXudDLiu7GF6fbXDZo?=
 =?us-ascii?Q?PdLW/mT/ZejRagnRlHJN7soe5mhzsSHfCNDBVPoNZSjegBE9jSUEKp4qotYt?=
 =?us-ascii?Q?lfNoZtRHvgEkhnv2WGPiRrh2PXlrkKsTyn84QFdjs0E2ZkThBIwkbx64HJRc?=
 =?us-ascii?Q?bGaz963Z7kMRMsifkidQxa+Rl0/iJqng6dhOUTPqstds5MogMiL36laVPdUP?=
 =?us-ascii?Q?OW7p7wKtB8GKkyqCTTPEw8ciMOneHQ8AStFZcjyZcEwT0iRUPHjxIcSnz9K7?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	eljh9snM8MZh+0T17XhP9QZvKS6FIST1jTR8V3/NteG3jYFbHmf7Jgnn0ryuy2qiSJPoy0dnuSz8wv5cubkW9Hi72J7ecpajrnjX1wsZWEcBV7N1nCxalfNml6L0zEyRpRzZ7cGCsr4EKwPg4ThHLHsn+rtTC1dv1vehHJbMaMBpq6PruyIupBd2+VAOy0arTepSaGIEZ2dE6dgNf+2PySzD8cJyxyeuUQ8rA/6qiCOwMQJxALOhZBTQDynsOPaMZuwNjvdKtumTOmCOU8aFngC1FTO/cviAFgkRCFEhOWQEjrIKcASdyGDZvASLkE4BG9BcFWg6o+wQwBUA1D+YIpoxSl8db1IAky+MdUHJCjZXhF1ULsIEMpi/StwGIt0Y+fKO26hIZLUcrelWUkREFHkGUoak+YgzqWMws19gn1Uu9FW2yKcDCOJQjOqJSR4tPRNxbvV2MdesHqi1C7cPozylNNxINwJMAJPQ07YL4aTY5KtwfEa2qTkf7sKJQAt2YnhIMAxU9WiUyb0oVJVWorMVEyOar4Usu3z7xQbfXk5puxHnJk7X4h/cOhOawVrOvXkV8WUAUJU8+H6ExWKbXfQ1YZIIwMK4gTKox4XvOBQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b35e46c0-ebbf-4dbd-5d39-08dc74eb333c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 14:27:50.6396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mrsa7xy1FZeD3w7SbhpGG0PapOJlowa1WQkj41IUMNzEzNTtkcrE+e/4rs1MPAZn3eFD0Tugnrykk4ou0owmgd9+Sl9Rjnwq1DHKRdAmmMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4532
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-15_07,2024-05-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=753 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405150100
X-Proofpoint-ORIG-GUID: fgojEI75iRLiXhzKiR1EDGY9nZW_SPxd
X-Proofpoint-GUID: fgojEI75iRLiXhzKiR1EDGY9nZW_SPxd


Saurav,

> Please apply the qedf driver fixes to the scsi tree at your earliest
> convenience.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
