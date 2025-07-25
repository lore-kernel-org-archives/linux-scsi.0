Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB2327472
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2025 01:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753406322; cv=fail; b=d62rIV7nQudHI4edQawzbKsTr+sXkUdrhhpT/XsBezLdV6kvEiNzg5uhvL76xt3lTm8dyX4SZ7t7fBuI79jrM6Wo9nstHRHzCH+2bWTPle+OOW3oVqJBN79JntDrGsEVe3E9gVm4DY9c0kAQer34sqUByTrK6gj3CWFkU5A3KEQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753406322; c=relaxed/simple;
	bh=e0BlADbtPanPmZq/83QviAvxxQ2kjEeNotcI8ZIXNIo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=X7ohb/LCboUS+KmcKbp/1wopSAaEGbtBYPPCLfNiJjixNH5Xm0ANBj0IPPznJ+1SH0flxvIdXFxPXP3pmipDy6ulKTYraZMiwrH944DeuOMyFePS4ylRfxXRadSyyxi2LhKdmDDy1nvJkOW5iUrH1ui2CwxJO9fLFkG1mGkLZZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=khvhKXZh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u7BnG3L7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="khvhKXZh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u7BnG3L7"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OLkECV025009;
	Fri, 25 Jul 2025 01:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wEx2PPIQCsXP3zkC29
	9smrocd1mGzq/oEBDzaBGMsiY=; b=khvhKXZhKsKlH33h8FFUnuHlWT3cTMgNLH
	QepoU3XK9utJccWT7gKDAQGxHgho7DGQHGD4jUfxWEwkQ3+2KkFO1AmaNDi+M8el
	JEdmeswK922Jw6yYif9s26JUn/2ru1yChypDYX+eg2/KHv9to59UyRbAg+9ARpeW
	A9ANHGKdrhO01D2TTnYgJCLhx6ufOhPSGQPkKMlUcqBqQJGYlADjZLWrESgymi/+
	6lT460t2SWoR6I5B/pmF2amdX3DTt7GGGv4VIBMXlipugTSwC812IVgPItYKr4O+
	E5i6j82OGpr5z7HyOjjfWRiP9dc47a6BE8/q6u19Pd75iLACcLSQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 483w1n05p1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:18:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56ONoTLh031477;
	Fri, 25 Jul 2025 01:18:34 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012030.outbound.protection.outlook.com [40.93.195.30])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801tjum8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Jul 2025 01:18:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ST5PZqk0vXzuHSRsHQu7nXThSYNe+PTB6eR2WIcekN4aTvjcMTPvk5Hp8eQEytdC7vdkHZR6jmrZLe3XBFP69E3qkeT4nBY5ytz7MDG/bMkxlA/zDqdsdaCUKGS6QTmuJVjTgsuDxGFiG7f9QkiOUtMBTXaRXUuheleBDJJAOrSI9VX+ZNOV2pJJ7NuZDX7ZUr1gRtD3PNatbuMHZld7ujajA0zljQmdoiigMOvf8QFCnDJP7/KFScqEpYPZwVFMT/BP4ieEiYifDvG7H0wOO6hroLr9uAUMZq9688G63sWgs6vRe7joQku8+aoTPQ7VB9xtCpasRxvAYSvs9t4wnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wEx2PPIQCsXP3zkC299smrocd1mGzq/oEBDzaBGMsiY=;
 b=bjoqWGEUdPwU2+RU4+wLfbLsH3k1pjU5v4U4AGQEjwO9UXltXWJChIriW27zFIppEiHzXt785U6iKc+yh5yboKjmgS1NF5YTIy6bcJ85t3UAiqyCYCjDpBW6mn9VzR1/pqXqTMTmQBbAcw5jBV7/aC8lYwGreqAFgBm4JcZYDL80KN9jTwxlctfyDjqL4YuTenhm822QrMYsRaU3US+F8X5qCM6jCKnbZD/BlGvqkpOcwTVOy2n7NzoLz0Y9HWoFHzY6OXiL5tIFTxrQwrkgshxhrhVV8ck2riHbJ0OFOBxBrDm/a5m3qVyPz9wu0ijr59WpOeddFhEuqFc7olmzhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEx2PPIQCsXP3zkC299smrocd1mGzq/oEBDzaBGMsiY=;
 b=u7BnG3L7TqCQbsMb1hb6iO6tRyJwSdv3Uztr+FAdnmyT9MCsoIdvEZdaYQT7K0DBOr4atCLGLnbLkj5rywmCmjWxOvAGEgvNDTq9ucRMvz8wF1vzaS5QZssDRIF7Eh9FvS000P6dvrKQ9LF4sjXVb130R6A3ao1jY/ywk2f7zzg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 01:18:32 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.021; Fri, 25 Jul 2025
 01:18:31 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        sagar.biradar@microchip.com, linux-scsi@vger.kernel.org,
        jmeneghi@redhat.com, hare@suse.com, ming.lei@redhat.com
Subject: Re: [PATCH] scsi: aacraid: Stop using PCI_IRQ_AFFINITY
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250715111535.499853-1-john.g.garry@oracle.com> (John Garry's
	message of "Tue, 15 Jul 2025 11:15:35 +0000")
Organization: Oracle Corporation
Message-ID: <yq1y0sdrru4.fsf@ca-mkp.ca.oracle.com>
References: <20250715111535.499853-1-john.g.garry@oracle.com>
Date: Thu, 24 Jul 2025 21:18:29 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0061.namprd17.prod.outlook.com
 (2603:10b6:510:325::11) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB5711:EE_
X-MS-Office365-Filtering-Correlation-Id: 02a93771-735c-4d1a-c092-08ddcb192b3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vQUE1gbxM6EPfubu57JFlmz3LCwMXesQJdAO0M8ieZv9CXmc+AAqEuafwO9p?=
 =?us-ascii?Q?DKwtS6OLaU82vTjyTllS/DdaePucBg27EGRfHk8sRwR1JUHSk1iycei5AgAP?=
 =?us-ascii?Q?VujrCR4eSILQme/VtVHwMUR69Z0rMKuWm/q9MhvmbMGvnYoz1HHoL6XAiw+w?=
 =?us-ascii?Q?lOgTkGZqztYCSLV2LzgdnHJIPNfyzg23eGHFUzZHf8eKCgndYlnkOnbDJkH7?=
 =?us-ascii?Q?R6/THQgDKe1KFDTZFzBDNFlVbzhFQX9YyByVziUHy+fX95/ZEdcq57cDN+8b?=
 =?us-ascii?Q?HkPKq0555Vl5QN1cgc0RzYfxGA9AQ+6E3ssFFK9KT9KYLkW1XpENTC9wZiZ9?=
 =?us-ascii?Q?939dbGBOVKj5eaxhVI4iwJAEQeJvso3ZyMl23bJcyPK4P9pY1HLgQs8VqfuB?=
 =?us-ascii?Q?p2i/zOISC2yj2ncpXatyseXlz22/ih/3eNZP7iaXFlt2HPhoEO+y2isEBDt8?=
 =?us-ascii?Q?+C/5qO8ioGOJ/tfB1uENh/R5ssWf+5k5cLVU91THkLqBD2hB8ZE0WeOZDq+g?=
 =?us-ascii?Q?8sePTctw8gaGKlhar/I3p1rvnd/wX/HCml+6WI5x98CV3BWVhqmia0HieFRa?=
 =?us-ascii?Q?iXmFHUTvg1CNTztJxx6ZhcBKa04c+o3VP96e+IT6tT/hsub769fBdhfm14SX?=
 =?us-ascii?Q?9lEMgwuVVQInudXqTvNgvn96ApkSxmkLwZe5YVX0yDpAG4LVGIhKp0kOSGX4?=
 =?us-ascii?Q?k5+R1x4Yf0JYtRtO4VRFaGLUGj7hginVd8b5gUs8mnc5In2SfR+ssx/svz+Z?=
 =?us-ascii?Q?a4wqZ1BM22rSzFyKI/c8txIUPV+f3gwW5PdhSgJPXSz3M0z2bN0Xkpwd1ATD?=
 =?us-ascii?Q?hwCHGJ73ydCbaeKO5WnJgzOrxk6f/234BtlYmwtM/lNFoqaa4slYfsHdMGJU?=
 =?us-ascii?Q?8dqqGwy7ymHTKjpOhBlWSifarKkXagdv/9i5kpP2wHa3RAy1ysGnBOWk2DFd?=
 =?us-ascii?Q?1799wb95aZiXrJJo3P7WeDu5c31hCaz26RtVpKK1ucc506V96Oioauhtz4Se?=
 =?us-ascii?Q?GhXIdN/kQ0UBbn7UkqzBvdtiKcD5ecU7vey2NpbcuaVONdv/OwGQGldIHF0T?=
 =?us-ascii?Q?HvpsqX8sIBVqHb4HUzrPXav29tJ8TUynKPmLVo/BaQ/bGrgKErxJYE69Btzq?=
 =?us-ascii?Q?JuWw4eLbFWHoJVwZItVrU6hg/L3r3J5pd9FHVmXGcIRI/KkfuFmc6jaktJ2h?=
 =?us-ascii?Q?0RGwycgtJr+tebLM9U1Hdmtqf/st5AwzmtJH5D7tsRuQ21X45BeURI3T8in/?=
 =?us-ascii?Q?5A8LRhvHqddsBOZ2wtkufvJs+B9uC8Y5dAl24oMuFUER24HlPMpKWXRLqpaA?=
 =?us-ascii?Q?CWu+y7r3y3ICbzBVcsAni45meTPgf33RY8UpsBF5qamdLH4IZkuQWWOnI+Yx?=
 =?us-ascii?Q?HHo+QRtvn7IJM+AjmHaS1CiEnCUDyMp425o9v884qp8di754N0qdCKi/fY6j?=
 =?us-ascii?Q?egGF71cvyqI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9lOsHbUyUTjTZojAMdgiiHrCE3xct1zJ1WjS8BjKSQg44ETfNcQW+2cvew2p?=
 =?us-ascii?Q?y20GNxYLXn2yIlkO/FQerWbkpwNKOcUu3Ad/tg7zNjz48U9i+U9s5PXmXuG4?=
 =?us-ascii?Q?9NkBVnyI3wUdQe8t/70Z6qPHe+93oYQKIyYFYREG0MM9yZKtptwasI+uEbqh?=
 =?us-ascii?Q?K7+86dzqD5XvsKBmha9gNzIHmlMDsobcWaM7U6kgvUbZEsPewQpkHs81g0La?=
 =?us-ascii?Q?FsBoPh/8d2yfNrIyOkfVQ+8u7ISrE7sb0Zmv3VRlGyfLczYvncxlsojofKvy?=
 =?us-ascii?Q?IKUFqI5CjaOr1zh46/yQTIhYv5cpUc8TzLON73FtLF8j4nWkJUYsIREzgyR5?=
 =?us-ascii?Q?zQYfE6egDuK0qxUwOTVKtcSHpLi2/RuC9a4mTMgwsdJkw107IsXRaw4D3C/s?=
 =?us-ascii?Q?JBEfNaLRNNZuinwAGqBOs6NzT1eDgdvt5+gqwVmiRm0SSI/MyPPPbO3eRQH4?=
 =?us-ascii?Q?OKXKz5zyd1BRxO5DmhBCWdAaxAfJSQ7oY4NxU8ctV14tz+WA+xQhEqySFn6r?=
 =?us-ascii?Q?w140h/Dd+pRzEO4/PPhE91k/ELYN1yXBz9Idv7sKc+6bev1A27sk5nr6m690?=
 =?us-ascii?Q?KM/1MDGIBL6KA7CmYmTjhN6/eS+Ihr/pRxc0pRgGGl51VgBN3zMyPWStSQkd?=
 =?us-ascii?Q?cH0273eqmMNA2kMrxZUn8B6nlvAyqUuCN9e1HIz/ubCpzsksiDLuC+bAr15E?=
 =?us-ascii?Q?9zOdrSk55hTW06wye40Pv3sVo1ksAoGwFb0Spry3Zo4KJNeTJNThjb6MhmWL?=
 =?us-ascii?Q?JoIt3JEOy9nHyQFOg51tnP5X7gxpkokQzpD+WhAPInQzZ8UUtpkC3ZITeebw?=
 =?us-ascii?Q?89kv+MGtdoqZzj6t1IPwWfxqS7+9cMII0kKNbC3mnt4lwQwqzfN/ZT2n5g/2?=
 =?us-ascii?Q?PB2qkc6zDlfI7/2YoSWQ+gmmTqbXhpYBk+7rxojUdtCmnVtrVl85EIkvi6Cj?=
 =?us-ascii?Q?3M9c1+MPa++3/AGOURp3gsG6nMYE39/kAPiVTmSvIjpk1/FMqdg1q3TnfmeL?=
 =?us-ascii?Q?XdE1yFLoddDhLQDhBbSaycbKAKt0+76sRie4RDOehdKEsIocZsk5Z/omkhph?=
 =?us-ascii?Q?xE7kocE/GMsOwPGEQzq6RH7kq3hXSN+6pMsPtQNIYriYL8ksoEDtoBAJLrPO?=
 =?us-ascii?Q?AuRwooi/PEZ4LD7LxEroL1hNXXctx6E3I97mY4bOp+JUTxwjJ0SjJnS5mS+o?=
 =?us-ascii?Q?u3GWvmSAogCcFLetAKZDdq2uG2YMvrhf2s1U7/GgsGziGDaUM7ELoVj8L4SZ?=
 =?us-ascii?Q?4KVG403Gh370hL4VswGUJLMVJv6KvZ7JU3jvT4DEhqT+P28NXDctbD3hVCSn?=
 =?us-ascii?Q?qSAxGXooatY7WFcJGxRKLpurAYzuz8Kdp9JAnF7u/W3bj6S28+yXrA0SO7Gf?=
 =?us-ascii?Q?WkcXyfeEXrjphGvrJuAI4djn7LmwOYV3FSTzclp0BbmZEg4RW0nPZOkkkzLT?=
 =?us-ascii?Q?A3vN5YGwfu6tyb5ZFCV9mjcvhdIQ8+hja4xe3es7ebcG0zKaaLcr2izBQeoE?=
 =?us-ascii?Q?2h1hP2howzuzld7e/wG4SJs3vIHYCOzWfc2M8OuUpu1vn4cBV+ryjKalBEBI?=
 =?us-ascii?Q?ra1Wu+QDWER5rFn6ZXFygWe8h8dew63bI8aeyBgYCxrSw2dxJyxMWqTYwo2h?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Bf8hB0XE0G1YcSo5aN61euD/kR82Sta0qw6gfb8pCW2pgSVBCYG06AA4AjOj+8HFbl9RHytuVWDwrtAVqYOV8nomRrQsV0dJPOMOx6EqNEomeZkgLEyjicsGP6xagcdU+U+1xGqjDfeV5uoDCOc02lGAs21tgVhXYRPyZQPilJccUrCvG/pwreAP0ccRhcO6cADLqzO8KCcwFkVdkMfmYTjyIdVyimGZ+HlDJYQA1N89f5+utswte/g+1rJuptoxq6kn5thiOy5xs81h4IC7IDf2zQIunqT193ov4PkJTNyEnNkOM4W/LgeasPKvJ/2JkzZDbqnwYk3RjG8mEk/8ytvVhZXsGC+wmzg0TWZlwomwcHopTf9vVCAWA6wbv7l5mV0aNIEI1JqHKveeuN3iXt08wmALUBYUD8IpukdCfnu3O1Qa7Pl9bSWWqnOIYgmtmf+Yy3u6JP0R0Lx250XuK9MCy3zbJDt9rY42tP/LjGrM5Z/wZLSykKt5b7UV96QlPhjs1Yh+BtT7dxcEXbYmI6UYb/KFkcyTdD8MOvBxYNlaSBo35FBZSAzuu6WfPOmjXWMPepbcTiFT3APs0n6J2XlRC92fM796+B483q2+eo8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a93771-735c-4d1a-c092-08ddcb192b3b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 01:18:31.8181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fGu+7kWbphd+tU0kwm09oQOESTSL4HzWhuqt5+umA3qO2setOhbtni9VT9e/hE+u2TPqYkyGiZycRCnUzfy6lYZMo7sgaIaszT+/z34hsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_06,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507250009
X-Authority-Analysis: v=2.4 cv=ObmYDgTY c=1 sm=1 tr=0 ts=6882db6b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=E7b9cIvAWiZGiBe_2_0A:9 cc=ntf awl=host:13600
X-Proofpoint-GUID: qla92gS7yu3w01wbwtmuMQ7KdKGxMHpF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI1MDAwOCBTYWx0ZWRfX7L00TwgImDt5
 x/8RibXwGY80KzklkJBXdfpu6yuf8awctWYs/YMYGlVPxO+J0t2ZakX4WGv4XFfvGwp136fnV5s
 qjnlGoPqL3vtMBxPbSD80mMO6n+53JKjFSnnyDHuF9nye9lERn6AqKJIcKU7fK4CoMeM7vRocBW
 62tsqOPvyljJfaULrLs299IcWWl4iHxfd9LHNPxsxVen2GLipGumwHoBLn68v0f4pA8Pfo3eftU
 perNtHAOupeKE2oMjw3NYDNpGmrpkWY8xXnRoovgcU+SabeMp9kToe+5IHkkR0ZFJIjWZOnEijP
 YwipjBqy1TQ3/9ghLHMvGgI7PM5WppCkvLN/Z0luIt4yFLz7Xz81zBiOQbga/xsEBLpdykCMVz6
 Aj7uQdToGVnBWSJ0UlWMQ6XqVFMICmVX7g0G8+blDiIX9ipPmkRd3O2rnkcCwM9Cpqaz/0zc
X-Proofpoint-ORIG-GUID: qla92gS7yu3w01wbwtmuMQ7KdKGxMHpF


John,

> Fix the very original hang by just not using managed interrupts by not
> setting PCI_IRQ_AFFINITY.  In this way, all CPUs will be in each HW
> queue affinity mask, so should not create completion problems if any
> CPUs go offline.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
