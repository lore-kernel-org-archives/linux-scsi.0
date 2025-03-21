Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5B379C2
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2025 00:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742518068; cv=fail; b=NkBkOW1G81PKsk+EoVdpto4NdO31uH0rgZvqZnwmkVpu2C5txQsgRgTnAwscAEEUGkiZzAErDr2Eo+akLGzM9auu+uRJ9No5HptAYv/4wkZa3GVewo5sKp+oYsNPuH9Q71D2gm0v6ZZX8fxTUdunR3j7xEuuyl56dwkHjOX6uKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742518068; c=relaxed/simple;
	bh=VsPpCpfm+XvjtsS7e2shU2j/R2Xet9dMk3uyoJu9LjI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lx9dCMsEN7yYPtKUuvdhLMnTVY4uvmpRL6NEJZo1/6gDTjUJndiPwZNtdkaQneyS5gHCrv7sapIBK1rweh0aBEdh1dY1K4nORKEnESxJKesFXqbyKjVK8h76spOwWM/nLJPQ2m7s9yV1ai4UdvwyXWekiQATzIC8IRkDOxI3Ba8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=obzH+Lz2; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jhY+VKtc; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="obzH+Lz2";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jhY+VKtc"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KLB4wg000571;
	Fri, 21 Mar 2025 00:47:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=R0148jkMSyaXr9zi2Y
	JA+tTbVlN90zrdTEV8XgIcTME=; b=obzH+Lz2rWNLXR2VIosv2omw0SwKt8icKe
	azDJ/c+3nr35ivXA2y/d+MyYRATkEVRYaMHbnhobD7HFqBZ5laGQO4YawU327XJj
	3ijk5mQhMdsd50x3b6WBhHD958pHUYpGDcgjl7YNK6OKNTSHCMoH+NICbOzh6091
	4RZ82PfNR+Yu+Elhr1sIDhaaTyVbOss+GQ90OBz0TMVpMPil7w2XIP/n9v53W4FW
	qavE7SUp0VJQOE7PTzUOHKi7qUxFb11EqrzlpDjlrB4TGK1Sy9npzn0uKsxz/87s
	uLOP1HpoiW5RXZV9ywUFIhdzQbnlyaE6a4cBRmHKJVIHQERQlJOQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1hg7gvs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:47:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52KMYbtV018556;
	Fri, 21 Mar 2025 00:47:11 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxdpucym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:47:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I0WXA/SRQ7sqLHKsnaSfgVAmFbuUIHW+6QyQiz4vzhnyFLNkD3XLLrnBBmGzHq1YwaA3VIeontjWGBcdup57UA2iG/AHA86xJ8EDsRpdMhZWdZlKrgsx5frLVWorOXlj/Bau0VbJzatpYMgVLNH8KJZXllp4zVxNDcc+7EMAAACmNM/ozDAgDITdkjJ1Zg350kA4DXgp5pJuMUs+kg0W/MRuu/Mg5tNVmGCdM0kLIZzkatbLnE17oEIExlPrq71r+eQS/V3hbZvYjx4IJPa0ZJOZ7DnOkPwuOAeMM/O9mqH5w2KT3PGZApdISdXYwX/z72aFmUOWUNbGZFI9jHo1Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R0148jkMSyaXr9zi2YJA+tTbVlN90zrdTEV8XgIcTME=;
 b=QP86n2Z+4I19rH69Jo5vLW9x+4nbjYvV4eLH5gldvvEhe48KbaMFj2/uDd3u2UUQS/6GbBqs06ht5/QxSVruIPiTGnEtnX+alP7tipCV4PaapADEyMB1mlNVTLYJ+dDRvE2KeX15C3SnOL7AtrmJHUtrtel/WTqT3mCUw5lc7248gSC0rA8DuR5FvQ073FlOrHq87Mgtopc/dAiZmb37+04Gp7Dy8Ivnj6poZa1VDO1I1nUvKUzgkDVNfjW7EvIdrHGRuHtG3BjqRAbfHC0TXcNvBs+2J1YyoKEaVeJUKuyKH5oRXUw2u7dYXVaCqlEjBagLJop4wIpxBfwHGd95Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R0148jkMSyaXr9zi2YJA+tTbVlN90zrdTEV8XgIcTME=;
 b=jhY+VKtcK0nIXFZoEffvLBUJQC5yrmtnrzXrc1haV1Hv7Eo2EFs+9xAvfK2mxt7/PP0+X1+A9Qn4FleUXClFGzw6BtVJK+jWbDab/CgYC3tanfQhkQXbXV8r0nZ3NTU/W6Mluv9gCx0JRLuStYef+PepjkCfQnAR2OsZNjaz+FM=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6675.namprd10.prod.outlook.com (2603:10b6:510:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Fri, 21 Mar
 2025 00:47:07 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8534.036; Fri, 21 Mar 2025
 00:47:07 +0000
To: Xingui Yang <yangxingui@huawei.com>
Cc: <john.g.garry@oracle.com>, <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
        <liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
        <liyangyang20@huawei.com>, <f.fangjian@huawei.com>,
        <xiabing14@h-partners.com>, <zhonghaoquan@hisilicon.com>
Subject: Re: [PATCH v4 0/2] scsi: hisi_sas: Fix IO errors caused by hardware
 port ID changes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250312095135.3048379-1-yangxingui@huawei.com> (Xingui Yang's
	message of "Wed, 12 Mar 2025 17:51:33 +0800")
Organization: Oracle Corporation
Message-ID: <yq1iko39pmp.fsf@ca-mkp.ca.oracle.com>
References: <20250312095135.3048379-1-yangxingui@huawei.com>
Date: Thu, 20 Mar 2025 20:47:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0032.prod.exchangelabs.com (2603:10b6:a02:80::45)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6675:EE_
X-MS-Office365-Filtering-Correlation-Id: a7c1a77f-b303-4dfc-641a-08dd6811e823
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1XyxkYtItDAK6w9EqMRpB01BSLxchKNyIDZ8W9kAJU4W8mm8RVBWM5itWHvs?=
 =?us-ascii?Q?mYZYAppy7M/EylCqLlPWPmRA1dzgQRJdMC2xEyTghdQ1ff0SDkPx5v5SLsIS?=
 =?us-ascii?Q?8a6wUQb061VObpPDQanfz0TqPzj30TcVirFN6jS0al76fExFIGqPAKjK0SFg?=
 =?us-ascii?Q?2N/hR26RAxfLuvtgqvCO/7seYQwp9hmfNQYIjG6tCAgaLzjm1BZBLhuw2oKk?=
 =?us-ascii?Q?tcJuS+2uAHdsPELqgbWaqVg957F7BiOGz41MWfGhMDj/FwHLtaLKUXV1CPwC?=
 =?us-ascii?Q?2hVhI0PP02XGPGv4sFIjgc3k5xLNUU22AMD3gbjumwJWG7e0NCdXxrCRkF6u?=
 =?us-ascii?Q?0groSckID8F8lbRu9qybJalat6EUNuFXMt9RhIkwSV2cF4adGVrN7v6P+eFC?=
 =?us-ascii?Q?ANFvzOmqDdnO5aGgLgR9JLyCP83q5gEI+R+RagCdDTcpGE3r8Cl0WQs9kJ1K?=
 =?us-ascii?Q?B/z9eTgXqPgHwJB7psLTZb5I6CsruZdu/f2w2655Y/58uKT2oQDjWunCbHc+?=
 =?us-ascii?Q?BGu679nIQLw+Ej8ZNeAAYlDFVH59eV9rXK73wYgX1vlxP1RhzYbVpI0M2zYX?=
 =?us-ascii?Q?g63ykz+0+y/pE9fHXb4djIXACF6i/U+0xNlYjFB8rtNjREgnSmRzcmx+g3ex?=
 =?us-ascii?Q?RVj2r8jxv49+GmQ/g6+JgCaVVYFw0arDXX1+79aPwpxdX42iXZW9TYGVq3uk?=
 =?us-ascii?Q?woUQDKZEX/ZGyNHfiydp1V2LPyj9xlUYL4ZYG8QQQ8xuBLAx5h8Jb0ARe4Po?=
 =?us-ascii?Q?DLREHEB4s9VJMk2rnbCm45BfCKJIRxxPTZ9f71fsB0ndAsWlbldRT03nOMRK?=
 =?us-ascii?Q?lKHZvyV9WEap1EbkPOUaEeG919xDOtiEj1/ljCFiWGtbP9Cyr3/QMMDnReK6?=
 =?us-ascii?Q?tQ0AFPV0reXoMH0ololFXqwr5kKCzlsiHYvNm9LGEQK6GfFlVnbcCF7ozGxU?=
 =?us-ascii?Q?6BP55koYx9uFSS0zGYwf+A8zneUUntvpxIUcDN1Alhh7fEE4KiA6CNuM3NJ1?=
 =?us-ascii?Q?8njO1VjL3jpwWW3APbMtyB+nE0fJewUDXrvVPBX5udloNk4idw5fqxH4z2mc?=
 =?us-ascii?Q?q08bBotL0vrZ7CPVctqBE2Jnr9iQNNjhrq9QuKLWQSMydgILCF1subGh+nQ1?=
 =?us-ascii?Q?EnLdKH6czHTjZO3aNh+F9+rB8u7IjQoOxER7LKhLT9o1L3CLyCCppRkMXSlb?=
 =?us-ascii?Q?GZZOScQh01CBNSeB58wTzUJMbA6aK36/JJ6s5s0UkPqUYvCVraKUDMM+ZcnM?=
 =?us-ascii?Q?MA3a48RdX1321VZO8wTqlUu4UePoA+uZHXA1Bm/KLKkN5065T0DW0y4dpTv4?=
 =?us-ascii?Q?OKRLVsTkguXe1eAnB2JO/OrK0jiZ8wjmVnUgovZK0LwpMC6iykZlmz8ubIfn?=
 =?us-ascii?Q?66zpfw7hVBAvdRdFfDG7dtCYMQmD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IC/84QefJXJ0BK6O0FsIihIMNkPmHEq0zo7pS4VYMaNoepRAl8nZ++/jX2LC?=
 =?us-ascii?Q?wxRsQKqD8Gnf63BnjOPzyeK9ODx2ENcPkZSJozhy2g3/c0sHdeA9TR5POcr6?=
 =?us-ascii?Q?VrRPcBFdG22utADwXZkEeifbzXVC2sbf0/3HvLGSZ2atpdHkXFJR9K+avAtR?=
 =?us-ascii?Q?tSOhCmXH6eIAFZrah3qbqWPlL9kGmdQAO2kcB/Jwy8GrnF+st5EgiecpDZzu?=
 =?us-ascii?Q?Qu3W5aM70ZqH9EuNg0OXqYVzM9y8tddqB5hb7CL4lUsZK9+IStVZ2iFRNaEp?=
 =?us-ascii?Q?B1iejoUR2FZkXoHTEa7bS22UvoeWWaKab6+B+cgGgtL1LG7FaqC+2MQEWyor?=
 =?us-ascii?Q?2fTKB0PYKGfeR8xSonwBcNp85yVjhsfY7jdLmtDtz9owr5t+724l2MA/ZLaq?=
 =?us-ascii?Q?tmquxFHyDeGOQ3AyxnDHVx34r9f9XQoxgbqKNd11U1oJkkokkXj7snI4dQpt?=
 =?us-ascii?Q?1CD7GG1WfPpzBrN+ugbUptPGyBfflENgKA8KBdCaYXNmTgcm65Z9p0jE3CX9?=
 =?us-ascii?Q?JzIXhRN0NjkHY+u4LJ52a14KWCa8OTUWBeSG7MVKVZ+etzykJk3o4a3w1+2E?=
 =?us-ascii?Q?wVrSFUKmmeIxucK60VbkpHu77HXwjEp6GjfByyYZfMkc/TbO56JXGwtraJhQ?=
 =?us-ascii?Q?pzenXGlbVv64g1ERRyFEe6sN6E7Ky0SWdcEs+CE8vt9N6SXRFbfZrYbTHSba?=
 =?us-ascii?Q?cq99pNpGsbDao7j19EYn7xs1pboFs+2q3KfeWIUKUEcDS2EOjwTsjUR4CGb1?=
 =?us-ascii?Q?FWzj8uAGmQ53uFIsh/6JLH2gx8QiDd4zxoJyw8ijN46C0YHJrZzMA0+8PXNy?=
 =?us-ascii?Q?tc7K6AQqnMy/3pB1rNNUQCnQG0Dc6e5a5C9CGhhlR2Kwf14fyKN4KTJhEoSa?=
 =?us-ascii?Q?6gk+9mQIdOCfyQTe34xVNvShKA/iOjXKMi7J8a73qEJpZVkB2C1WZExApD6v?=
 =?us-ascii?Q?41BvZLi3m9KXLkzXAxQ1CnsWS3MUJTqss1Oe2Qy/9DJCXRfWrCGBxAbhAlDS?=
 =?us-ascii?Q?0evAPVW7yUedshXUQHFKwcNdeQ+qa+tV9I2C+b9ySuSx2Mej5igcD5sC6jFm?=
 =?us-ascii?Q?yIal07tg34JzW94U+0EWm/Zg5RuttPSkBT4RqFYqPrAQPgsgKvYHs+eD7fFo?=
 =?us-ascii?Q?msZxwwB/38eh/agCNqchidh5/XrDsccmjYr2h66H0w6WmlnwjMWhwn6TEWuw?=
 =?us-ascii?Q?9s4Q38nAJA7a7VbUhln+AiSHVioMHoKLICDM/jnVvP7TecTyV5goroekO04p?=
 =?us-ascii?Q?upk4zZMXJdCYhkLFeyUhXH8nEMwPnMRjLT7US7bfY8dvv3RnYh0XMDOoUXsl?=
 =?us-ascii?Q?cOqqGQAYzipl8ve3BXMEzGrIWmc1uqU9vmt9GAsctG91kJzumdsQkmwyTJXH?=
 =?us-ascii?Q?zPG4CvmpC4PJl7PPF27TswwjPXQlBpvqEFYOJnewDqkRujDOkqwpR59b2KBO?=
 =?us-ascii?Q?2p0aJGSODTsP3bGUQ2lQvMP6ThypFcs7zWU8pvOi16FU4LCF5ky+YVqhz7Aj?=
 =?us-ascii?Q?Mf2aqfvgBJs/zPROnzDS0WRSq1xtM96DJLDyJUKxK9hwnBM4yc6OkFIBrp4Q?=
 =?us-ascii?Q?y+kc+PFcVBFTCi52IQi6cZBIolRoY9dXnvbFHc5ps84szklqZt4eSCh6zIhy?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qB3NJfOukOmEzEJZgJV8D4gWLU0bCpMBoFhZXU6tdbhHBPwzU5kReUjKcCt+0NrCWcw82dsThafnKic8mr5HsNEQ7MRSgtIvA29JZBQwPHay/zsmlQDm/6drJuHMRZfjr7cRsqlNaMdQjU7qpnXGmpwuOnz4lrMd4aAgrijTI8Sfy2seAVdnoRkkgxE0xxhvst7D+VqQqiHIctTdudH5Q73BW7oabdpHBfgV3KSmq1fWcemRZfyGl68rfUK8qMsnUP3QpSpHDwyJ1EIUudXxqa6PdiMkFXL1sUhgHMm7CuHsZtYx56t6+UkMzfv7N6/CCfkc8QlKWFVc/+Qpass8AfyzlappmYxYrGrFpzbBmmzrMo2RW/lZNsP65c1YYwkXitoGQajatP7I+f9UrdjtG24ImLPlde//HqxI4XM+Y7stsiSK89lDgPBzz71StINWpD17VncTkVdcpSmJ7P6cIgyw5IUobBejEoIGYlYE106jliSKpUmuTCp9aO8B2YYfVoo1wegmcs1fswiI40YejPOXWfMJmgkgLdbJF3Vm9JWE7N7FtMLtqKvpQztHMMYx5V1gZoqHkrFypUJbXKzTTSmCTppNjCUWQ9ncAyVAYQk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c1a77f-b303-4dfc-641a-08dd6811e823
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 00:47:07.7820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2a19I2vr52CD2XtXQRq7jjMiC0vzf7Te7jE+AQs2UppRuWrRLxQtQ3nQ1C33UpHDo7oJHnwRDRbHXQmS83+iPVHOXwzvj5DJE23QCIlGos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6675
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_09,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503210003
X-Proofpoint-GUID: nyrkDtmGrhFPS0bSg0afn1pSQSSiO8JU
X-Proofpoint-ORIG-GUID: nyrkDtmGrhFPS0bSg0afn1pSQSSiO8JU


Xingui,

> This series of patches is used to solve the problem that IO may be
> sent to the incorrect disk after the HW port ID of the directly
> connected device is changed.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
