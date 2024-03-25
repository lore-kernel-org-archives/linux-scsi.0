Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CE671742
	for <linux-scsi@vger.kernel.org>; Mon, 25 Mar 2024 22:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711405042; cv=fail; b=uFrncQEHogED+FGxpmT1x8q1folipnuprYYAxCLLlZUBXuLXH5RRIUQkDId430+Y97g+M96DheZTwJ3mCXGY3gHXgZSaWjxKtOAaq9+gfLUqX840phWm5Veiqv8b8yWuHOMxaxqeNNyfrHIsqdlpisdb19tkfZgSUWEyfk9Yuz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711405042; c=relaxed/simple;
	bh=+8QYKjDXD3OxbrdB1vdjmFHBRmhHay5EKbJZyUm0TI8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=YBRotNRtNhF8GlHc6SOiL+lpVSmIiaysdyufycoIwrVg+og5WEy0TXJB0xINadi/dtd9HyfE6x6cGd3A92CrpH5JVefVCYSp8PlJEm8GU5ArxdNM1wM/BoBtnnxHZ6ZYzE48nBIbXWxNpAyJUSWg0tpG5RUNDcXvOuHRXQ6vVTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B6zjNah4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hlNE/6Om; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B6zjNah4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hlNE/6Om"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PLFtox012366;
	Mon, 25 Mar 2024 22:17:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=OAjNVhWL1Ktvztwu8S0xz+Qe/Lg+Z6Q6RLZbIZRc4d4=;
 b=B6zjNah4inT30U5uRSDEoM9bjB7HnW4cEyYqTtv7PqPkd8DSOL9ajCWKS6K7vbPXoRAQ
 4lNyNADO3J+T/kkzmNpXk9j0zUWfgfSnx+TJXU/xIgqa9pIP0lCPsf2vNsEBEvTL/2Z7
 +DyDQm197pYZMKd4OsnDImepyVBSj26Xw7HkmfpDIfDyk8TOjPISkwecL09FmgGuoQ3F
 2TVKwB3cP/eN+EBOESwTwW0qSH6WI8JzElbsu4fNpqSkC2UX4wnG6dTAYka0ddxRas4N
 dhfYg+bPS0iRkVQvh2jVZetsDBMBPnKdemjSUB39H2xuFpd6HY3JBV6ACL166oeudQBN NA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gt7s6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 22:17:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PMGTTg024370;
	Mon, 25 Mar 2024 22:17:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhccyns-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 22:17:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwVEdTgqvq21mOela/6amMsV36yMQtTQcIy0f/KgKyzvev5YrPXRvvmuF6Bb8lcWrkkAr+mxh72HtKRrzGBYjrRAgwxbc04kfDE8Mm+x9FZNcdH7RknwTdaNkBCshvmLHFOOMPu8qsbWJ09VxgTGS1wfpDf3Vn0Q7TvqDt3pJnZx4ySzKR8RoYwOD8IHaifgkF7vzqJZvBRBTLEACFrwwwi2PJoXbqfeNMdYuJq8kdb+WTc/RYrGZw8ZP125vXvWp2VTqnEBy4olLK7AHLc9bD0flZaVtpLxcBadEfLAOeunUC8tp+02922rllSR/WAK6kJb01yfALXLCS/gHsZGcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OAjNVhWL1Ktvztwu8S0xz+Qe/Lg+Z6Q6RLZbIZRc4d4=;
 b=McL0yM2vhLAwXg5MD0v+Rp/bLpYG0e9B6IztBRvtP+friv2Je9SyE15hq7GnD2gkyqSYIKtP0mv9wU+s8s2V1C8esGADzl1vZjB7YUjIO8O/PkRx5SdDaL3jmK3zL5PakavPWAEufxFrJsWUCA/SodnQ2cE9YPRqUvpv6M3RCvC0zTpc+HX45ywlKXLOXBD5r5lm+e1Fnunnr5R34/TGZeMou9IgErzpNVbSZ+qRVHU2xeSmmGcNQkX/ijaH1wSqDOrchZh/KKnifNgpyqO1Qy0P/dROfnPJO9FgFLoOY2EEkbBuyjHFmmuQMODEgPeGxzFkkNKg9gbwsAU02w1tMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAjNVhWL1Ktvztwu8S0xz+Qe/Lg+Z6Q6RLZbIZRc4d4=;
 b=hlNE/6OmDrhgcpbOYfeJQSJCb7finZQNfXfG3GyTkRF1brh6/Wj3WfQLiLJ9Apa3o1KP1eAZTcY8gyzd4LsUPJLGoUlCYcYtk2ekr7ux6jeGRtXQW4R9VZC0nbcyFZOfvTVlpUN0odErLR3HsI2Y+ijWEf1crVB2Z2+5r8swqTw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB5035.namprd10.prod.outlook.com (2603:10b6:610:c2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Mon, 25 Mar
 2024 22:17:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::7856:8db7:c1f6:fc59%4]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 22:17:14 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v4 0/7] mpi3mr: Few Enhancements and minor fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240313100746.128951-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Wed, 13 Mar 2024 15:37:39 +0530")
Organization: Oracle Corporation
Message-ID: <yq1frwe9ctg.fsf@ca-mkp.ca.oracle.com>
References: <20240313100746.128951-1-ranjan.kumar@broadcom.com>
Date: Mon, 25 Mar 2024 18:17:12 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0024.prod.exchangelabs.com (2603:10b6:208:71::37)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH0PR10MB5035:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	utRSyKgx0g2rJilqwkVGbzRx3qT+qfIUx1yD/+fokBDzcr5jOsDEFE/svNcWDu5ObCj1Ouc7Af5wMF6L1ZOgW9CjhoMFo/NM0ZsxM7m9KozZYZg+CSbJF+4uZnMRQnaTr9f+mNbyXk28jNgudavP8UlvRqhlLEuBH78JER6g9heBoVTa6N4Kao87Q4/FtdOgyvKmtPn5qC2F7jxDOS038dh7oGcxafuACIb1dn2U2FSZiQh44cx3lJxKIYNCA5nx8iXRZwJNQBaJrw4495y9iyDLibJK4v87NRp5T9DNpkj+hSIcT5Iih9je7lit9jFyTt/CGpsyZAEGUUHYoZkBQ+iWdd1e1IhXE4xVKtEoC+H2s6S3wzd1IXVQjv8sUCBs0Vu/f1NAZIeqv4VHDN0Py+Kan+mk9jUpYb8FRtiddyFONoabYbXPKvYJ2Weut29sRhEHZPLjyz5RdAnJG5+KxHpyz7BsKYZD1BqkOxwUfve77CHwUkDCs0Kco2yO/Gl6B7qrztE4pQ2rHtmthoWQLhC9yIiMwJsshnaotLVz/0F3zG4ngq+B5FGDub3IqWsS95XLf46CglW7ypsUJZFhrL9eCvzZSN7EqcddufhaML9CQEYQcb99Fi22UW4APH6O5vBqqiM/sHil5IaKEzPpsQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?kRlKBMcOeJdW1Bpva3QA6OkjkJMQ+QWyhU5s3pwYSmrHFw4vTqd+Swwn3Rey?=
 =?us-ascii?Q?p2fpKCs1FxP9qNySvfzsDfLdwhoByuTAkx2sSka/FlSAkfSjlLTKf8l20zRJ?=
 =?us-ascii?Q?F670q1EkkXBj2CNUMaieMn9oBhu3P32cZBtAYT97vESB/GgLq6ZSuLJ0SfFe?=
 =?us-ascii?Q?TT54ZXgHpBDLdSJfT3OdYTiNxRg2fhUpKDtbCwaMf8+H2jVnZga+wGXdqKCN?=
 =?us-ascii?Q?1JQqO6yM//DSYuQs9jGnML9IOWiu41IKtOFs9/6wmMDE2maczhFjUom71ecl?=
 =?us-ascii?Q?XbS820C7m61Y+lyrgWL3qiN1vvzIN+EWN/otADly0zHH3cupyjW/CfWAhGx/?=
 =?us-ascii?Q?VbGSTkH44g2Bx3wpbj+3SwhRLJU/PHkD17dgNSQszWvrayGVRITbelTCORjk?=
 =?us-ascii?Q?nHY21qYapvJ1zmwVGC3nVGnAO1e+w3QnBfmyGDf4wnRO4wG2Ks2wu/aq4fI0?=
 =?us-ascii?Q?5RGM8rsfTc+HBLHmbtzipVUhk0qCKBXK32lEPPzbJKU1GTJHK3Excf9He7mP?=
 =?us-ascii?Q?zxNQEdiw/eElBxj4aaqDwaxEfnBUoTjc1iyWplyfpVqxb79mGVFsk0Kuuwd4?=
 =?us-ascii?Q?BmG6NYgwY/sxjFovcNKrsUVyG4LCdGOFA0gA4lPzUf4IQKraX/YUhE8QfYMw?=
 =?us-ascii?Q?pXa+R9w6H+6nFEMihJndXKdQ1OrkMeg5PxJ6CKTvV/QGHyL3/Yi4n2Xi5ieZ?=
 =?us-ascii?Q?sm2NUyOw0GlmcQXRjK2fF/g7MIl5eaaJXQlCcn2XP6AbRcWqtn/PnHyDPG+S?=
 =?us-ascii?Q?tXPFe98J6VuAchfTf7K8nFkh6pFFKzmJS/B+MZMLv4fr4Zz83L2LVCokrXOb?=
 =?us-ascii?Q?k5lQdePPaVfZDAn/mth7IGcjOA6/JulBt5vWTgk/OTusdAelTXGD7Kvd48De?=
 =?us-ascii?Q?M8UBVX0kCXt1YZAXp0Z5b84GJmxfoKc6TimA3oxuf9I86kt+aqGwPadWgR0F?=
 =?us-ascii?Q?Ag17lR+C4YkGeNX8C3tP8c9p+8IGEYE44gGu+bFiMh4qYo/AkBWnItLV7koQ?=
 =?us-ascii?Q?44dcEjgJj7d47R/R043Wgwm6TPApBTLRf5NhgZtEyaE72XPj+lntwnxz/yyN?=
 =?us-ascii?Q?iJjbx6Y8HbqOh8Igk2pfEfMijU0gGezAH5rfZ7xemgDGqZ+vgOZFkxqAbr+F?=
 =?us-ascii?Q?CKGUuQvChJg5tuHRqJQUSIaxNxCTT+Qf7NJYebM08xRMYddeZ8whncmV/72o?=
 =?us-ascii?Q?3210IJt/9WfRZa1xNqszNR8XnEjo+a2FbOwmRIHeasWYEH7F2ZBiKum0HEg+?=
 =?us-ascii?Q?OX1N73ufr1l/aqXQAK+NrnA9k5LAu1vaFuNS1/WhaZkXgdwv7we6uZOIZ0IC?=
 =?us-ascii?Q?glUmNzQWVa9/S2S6PRbKj0Nx5wqcN8b5BCPuaKetk2i1GWiXVCNbG9rrnaMo?=
 =?us-ascii?Q?1/vpDS+voF9ZgSwxwYShhl9BYKREigs3j+lFIDMk1yJTdk/o9aE8BR+cMQx1?=
 =?us-ascii?Q?aO1RxXaORWHezoFLoHwbk9+5KwOqAHvPVqkcQBW+ou5J8JxhjpKm0QO0Vwet?=
 =?us-ascii?Q?hkgb0SSkg6S09Y4TFo4sknKvXJBvsmOct1ZpKoWwrkHcm15mt/EUFNxRDP+1?=
 =?us-ascii?Q?e/mYXW03XiIEHeq4s9Ybo0n18Bys6oMMrQ6Wp8yWstfvgpV8oetDyZERKLKG?=
 =?us-ascii?Q?mQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	1fahLCfs+xOSh3oxuDDeu7xvWoBfdKnxtrWubaJEu8OQrRdTKglQcnIAzYm0qFL+i3eoUygoZy6P4gV4jV8K9bw+FjPuae7VkHF1WGARzex5GBPQspFFuLFdPdpV5dj4BB32VKl5I+FjNsXW0TWZ5aOYOrUuXEA2jNMvjZSTsrtxoHfloXup9LeJdFnXfHhr5uK2mLYeUzoOwsTT5vEEFo0aMojQt8mQ6EaZdMmOagVo9e1qNxS5tHlYIuras/BWgZDVja/fK7cwNfMUhPY94RXieazaVli43lqCpARa6gunUgDuzoGY4XBc8qDN6qDH7I/OnGcdOmj9dv2plrVKA0+r5bTpa0ETdGKbFVW3m/hgvRf7l9KSyaEJPB3EZOaiY8Pa9s1mPaPpcv+8EhuiNLFCI9+D0ofQJBw9nuZpTF/LgxRQes3khnwDZ6RBnzZ9zVVZrkjO6QOO14BQukanDl+05JMCRejghymQxrNaTtWfnO5Bkrsc5ivjTUGBKO0iEloJK5rb3HXsZqpgsp2nnWmrYIN+sQnGq3banbX4Tl3ouDCyR4T0ASz49LfambjUtpNHHJv4U09sW8jpJHMmjEyXhM8BX6Vxzs692gww7RM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b543fb13-1e4f-4404-c0df-08dc4d195316
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:17:14.4669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxT7DXKF0eDYvYXbtrUlT4o3dH0FQYDWTmB483qpd4Wf9eS0DyEO4c1Qc1KRsdc18KQOmtcRI/LH2xDXKuk0V9RuIUZB++EsWhSluo15rNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5035
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_22,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=932 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403250139
X-Proofpoint-GUID: Rm_7dWSLnkm322I5dCrPZ_aW6ObKgN1b
X-Proofpoint-ORIG-GUID: Rm_7dWSLnkm322I5dCrPZ_aW6ObKgN1b


Ranjan,

> Few Enhancements and minor fixes of mpi3mr driver.

Applied to 6.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
