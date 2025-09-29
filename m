Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C52B1D6BB
	for <linux-scsi@vger.kernel.org>; Mon, 29 Sep 2025 20:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759179157; cv=fail; b=gSJl/PPbqNNPeMsqu3Ms6kLaKoiMD1t2BhtF5HU9cCqjHGg5q8FxuLsmkHJ1Nu7XvfmKM9gNoQhvz5ZSAy48HHzVnw6oJ8EHOdrtLXkDTJBMCT4sm8nH1tElp246C+r+7XEPNoy7/gxlqpTdLtoisTQWK3XrQeD3WrJ75rBsh8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759179157; c=relaxed/simple;
	bh=p8AyKzmEajn2FJpRZJbciB/maDTImeAK0s43orUPtxU=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=NyX5zHEcCGQVamSRHGyNeAFhCjijFNyaPpMuX8fHwRUt1yw2V1jpwpYNuePSZiDlQmV+KkptEOirxLlBsg/vnGVk0ce5sMqAVTy8icRYr5mvH1MAhZbXA6hLaV0MvwmON6ual1/KEZFBmDvkOkLNQdJNIsii2biZeXg+BIcGH88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Uma7QXq8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=u/4v7Se0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Uma7QXq8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="u/4v7Se0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58TJYgU7021495;
	Mon, 29 Sep 2025 20:52:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DJLUeFyLJBdl6E4jG5
	+6osdOiRTbWDFOjke6kn3rQ3U=; b=Uma7QXq82agJkKeT9SzO1T8XL4HV7SmG3o
	giz9MyHAXMrnJ46mQ4q/AB9oVRPWDnl4DZR3RD1tuyYNNccwJHaIeQqRRunvaQyo
	MDygHz8jqC960Kyqam9fh/SpDgKdsanDC7QR3W6NbY2YuP1JdwwGQXcMtSfD3AM9
	+QRPubeYxdp1FeZ3VUeOgYY5R4O3cnCMcZLfnMBDKcJHgjmfjM4iXPl517SAPSJQ
	BR7OJeIQzb+/GPs8MwXqUaJEdIURba4qtpMRC3x5F9rl8wpCPHgm/7TmOOZnvoV+
	ls3laA9mYu+4Pq3a/M18CAFji6Ym8DiyQf5T76+zEAieYuE0GjmA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49g0cug4y2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 20:52:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58TIMgWd027094;
	Mon, 29 Sep 2025 20:52:18 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011060.outbound.protection.outlook.com [40.107.208.60])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c6xx1h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Sep 2025 20:52:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qaFg0RYa8vkveG8ZNkimHOFDRwPwNUVfOyAYat1C69DgrDrQpZpz6x/XZ1mgJtJfi/H0u97/fGiIWyGsXlfbC8B9ALQFEb/zv36F25pk0uL1LanDeK3uvhkE19IF7EgAg2jqYxydWOEd/ofWD2sD4/sqTyVPYqQuhVsiOjRC1SZKWXggaGfZRRl1wouCBhVzsTn0pThvSdE4sOzwER+L2zIIesBkhpCWCYGiNaSYRm6mNiSBaLuMfLGCAb7KQp20sxNjs64pxF8QJ5NBQo+PqWR77wDDcp5hiRjGoG5dHPxN+sDY0qp/LvZ8OCtsZFlf3x/ohsf+HPBUw28V+LujLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJLUeFyLJBdl6E4jG5+6osdOiRTbWDFOjke6kn3rQ3U=;
 b=gbYp2+oeSkAOuuyM3u9yGsAh9OpNUajdORpQi9vMXu+tpRqRgn28aCCHoUmOWMcLFqLVlDXqiuC4CBP+8MLigAImmKVNXRVGCWZbanBbPRM/7GdR1D+MaRsZtOzLgr3wuzXqo3npAWuYUyySkHDkXOjvfZFSg3VU1gz6mVxd2bFdU9YYpHpLpCjiglvRj2RktgCbAbW+DOz7vTCgHIbO/spq/Vke/qDhnrsa0989YEIjFPoPeu3bgsjJzPYcW53WEzN+7yaxLUtQGZLdrKWLUNa0ZBRSHiFD9OyLFQGQ+MolggcySRL10knaII5EOFiLpfYNsbkk3Ni84q2f1tgVhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJLUeFyLJBdl6E4jG5+6osdOiRTbWDFOjke6kn3rQ3U=;
 b=u/4v7Se0MM3r9XcKed828BpKNAUs0naYNPwGUMXLNk9aG5ei72ki0vHXcH+Nlw5SUX0RcfitwJbIuw+4Ad5YPsBOq1nZxzZpel1XKhtE5SMTy02BDaqDLY/pVg7N6s7dKcHWOeWvZRqvhlQsQKe40bsuAIJYktTDTH6h6aGk8Go=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5592.namprd10.prod.outlook.com (2603:10b6:806:207::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.14; Mon, 29 Sep
 2025 20:52:12 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 20:52:12 +0000
To: <peter.wang@mediatek.com>
Cc: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <yi-fan.peng@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
        <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: Re: [PATCH v3] ufs: core: Fix runtime suspend error deadlock
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250926012940.3933367-1-peter.wang@mediatek.com> (peter wang's
	message of "Fri, 26 Sep 2025 09:29:26 +0800")
Organization: Oracle Corporation
Message-ID: <yq1ecrpnfrv.fsf@ca-mkp.ca.oracle.com>
References: <20250926012940.3933367-1-peter.wang@mediatek.com>
Date: Mon, 29 Sep 2025 16:52:10 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0094.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5592:EE_
X-MS-Office365-Filtering-Correlation-Id: 0199ea25-ed99-49d3-35fa-08ddff9a106b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qXsNqUv15Cy8O31+Zuiyq4siy7a1uj55zYwoAdG1g1Z7KbwZbZPA9QmYe4q8?=
 =?us-ascii?Q?u3rsBGS3NyeuE2NbUS8yiqOVBaLCWi6dg4Xxuol4dBnaryNO4JRJBFq0Jmzd?=
 =?us-ascii?Q?Ibp8SWXiOWs/lRcX/E0nP3GBJeiMNYLGfXRksysGsj44lWHKc2Z9TttX/Vdq?=
 =?us-ascii?Q?1rn80d/ZLurPGKxZ4qjqR6aSkw7qrN6teWxlNSlDx0NNc1q9xzuvcRXVOUlZ?=
 =?us-ascii?Q?+dz3EBfRRV1fQjw0LNmXgoBmAQoHbwYOd3k3yzrzyhh2Gtt87eb+NYIL9EEk?=
 =?us-ascii?Q?bDX4yL+FnMfSmRMgXQdKLhJ3KTh0Rps+3uet6LX7ddzjBySohxeqjc89sPM3?=
 =?us-ascii?Q?e6pMlYpH0sA8FTu+kQT7lpILia9Gj+8nYH0p1nl5JTQnC/ALzDFqqe0kS+aM?=
 =?us-ascii?Q?Wh8YtxKrtng3Am+w+imD9kZMqh3f+3VZbhLKlGgqDpgVtIO3+i3OQURqgyKW?=
 =?us-ascii?Q?GK809tQA0iWIYmGYtxLVn1McoYC0hV/Qaqj+oaQRyPXS2uXFK/7vTFTowLY/?=
 =?us-ascii?Q?MnSAkQyKgkkHyNfLv3BfBtntusieGDgdybLH8ZLS7Uw53r9ndto2Y7e8KiKG?=
 =?us-ascii?Q?3hSjVGjNPXKaJYTDg1G0si+7Pi33aRsVBscyJIwNneozJNyrH5YGfD242S+s?=
 =?us-ascii?Q?umA4c04u4yfLNyq3iFlAyavJ2CyfyBJkhWh5dOh6gK3xsky0z9NdKYS+Bh5N?=
 =?us-ascii?Q?IgoIGEgf2tWkLLNxDvOdJ1rvc5MfzyFHmk+jhTsrShjoEVNAaswr6rkCO7cj?=
 =?us-ascii?Q?ulVwjFuqESkRb9ENKgRqNHS7d7hRatQI7GNO4V/U6q6DG9maTHF97UDi99IL?=
 =?us-ascii?Q?Fc++oUdP1yUYdL7+B6VjQSf+e1+R7lppCZeV+aRJENqhQ5O02/muAW/7iHCS?=
 =?us-ascii?Q?rr/osMRML6dtjndM2pPRgieqmi5nEdE7cAANJCXsjLuDtvvQ4OpvA6OQk+wN?=
 =?us-ascii?Q?nW1gfBQlcaBYO9i8sNIsS3H5Ovaor7M/rNbggUoYlxhJ/91+UfiPmutJGA1Y?=
 =?us-ascii?Q?/Yog//y8aYz+KufnPFGUq7E+y/icz56Pp267wtlrAw53O4wvyU6wBcThywDg?=
 =?us-ascii?Q?1mDYtweOlM0dDQf9p0pSPXVlL4XqW9M7Xiy8FZmH4Fr+lY2aJ0H8TCtgSo6V?=
 =?us-ascii?Q?r8m+3ldk4VO/Pr8NjmZ4/QDXnk6Nn3X4wP748YnZGG9zdhaaqqTL3hfQWvcz?=
 =?us-ascii?Q?80djIiWjNMa0GVF7DrjHjEbMCYR+Zx15sxGz0hdQj5t/lWEoUqHp9qrBTkIG?=
 =?us-ascii?Q?YUVZA8UW9On9IMrQUb+PnBa67niBa7wjuiWI5U1uQGiLNRnwPqd09EoZtHRD?=
 =?us-ascii?Q?qIeF8ByFq2uWl8Kd03TGDX1b6O4y6ZJ7nm+oDzo4PuIzv0nGcgz8trw+s1Gn?=
 =?us-ascii?Q?6yDvhemtKvUqFanKFWlvww97jbVpHxcG8A+IuBASc1T1381JkbrnlNkq+uHQ?=
 =?us-ascii?Q?EZDWOivKSf4iwwY+xLw4GSHb6ciakdAS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zE0OCwOv7Po6pHEwHJsW2UO4fJZN9ATd2WJO0Xtc86YUsmKfsFNq9cUpYzjk?=
 =?us-ascii?Q?q3t3yLPqGKV4zUZM9x2jr+4MFppbDGYpzZrO3HPvY7D4GoqG1AiEHHQWunzZ?=
 =?us-ascii?Q?KIaMWv5ugN0NqUMbHJmgx/y69b+3C+78wQVBB++HvZyW49vVSaIdewgdbx3A?=
 =?us-ascii?Q?GyOfMG83cIeXP7mkp/+lE47DaygT97QepHP7CVYmN2OX/jmCoMl6zHRZepCq?=
 =?us-ascii?Q?K9PhEUZr44TCM/E3rwZqvE8N21dhpppsaoIu2o65lzb0VINpzvKIbzisrs0n?=
 =?us-ascii?Q?QFHdnOTXltFKsBa13wrlyjOiHRJ9HvvHlZqcLiVoH9XWTmkuXmkXjo0VUaVo?=
 =?us-ascii?Q?iqDPxxUniiXzDvbXJDbluSZcBXKJFQVseP+S4L5WjKj+095LyEfKgHdNvyTH?=
 =?us-ascii?Q?ZwhjzFzBAnsP65Q+8gzCfsqAAZRUHjZxs9HqYPKh71mKk1obUon4I1NGpCkm?=
 =?us-ascii?Q?ZxuCJW7+3SrEktdfpqzxOe9PRSCWO5GRVr4CqdcSfRvkQuCKv8huP7AJtb5A?=
 =?us-ascii?Q?SZ7e3H2Ez/vvpZdYe5nizx6hjP+794eubc1Qr7aeZ1GlpTIcJ37T2knl193b?=
 =?us-ascii?Q?xE+i5/jmIbRBNdZ3v6zjgHyZUdiOHtpb9OuHtSs8FniGa6Ieoaoi++MOcPnM?=
 =?us-ascii?Q?OvNfhO9YaKJRtUyMJcJe7/Y8RGQJF/rrHCkx4Zy5ob7ycEWfx3vE/0WthXso?=
 =?us-ascii?Q?9bq/TZw6fNzpjnSUlisnlhZsnCrAakbkWxxV7S7pA7pBJJB0fZ1fRPLk4PuU?=
 =?us-ascii?Q?Ba/0hT8XaP8aNu+I3IRmM395ag6e806grZ3SRk+Pm8rzbNodwwqTa3JKOMmd?=
 =?us-ascii?Q?9U28crBj5xSY6Yc6bpRa/zX4XvkTzbd9/ROzI2ZhOOUKcmwq4fCWb6ejaYrP?=
 =?us-ascii?Q?VN/Vc5uq2wIw/W9D7mX/79h/LJ8haJBE9AvFxrZYLglpof3BjvIlC5fO8pJm?=
 =?us-ascii?Q?Su78hbtU8bydzvfOj+8vEtMWfYwa0qNcP+vVfb7zDMBPXhh46ZX49NHmVWEi?=
 =?us-ascii?Q?B74AsPWaDB0g3ijXP+pPeWYRHNXJ6ozJzsiBJSIhqKErd0eIilQ85PF8uJDE?=
 =?us-ascii?Q?z0zTu/s38HZcP7HhexUWfF0qd5oLS78h3Rr3Bzq7xuZZpqbTyiNSkREp+Sb1?=
 =?us-ascii?Q?kXeMu12KKxryJchYtNS8v9fiX35bNT1OaeSvrSH30+0fzATRhlzutNa7IHFu?=
 =?us-ascii?Q?vO9vLPJej5iAshZ82X9S3dVMZfucFmExwqHZtG0A6bLxQve9pTIHPACdAq/M?=
 =?us-ascii?Q?dJCjibLrjSROC0ehnBdHHfUjAxEx96/xoIt+aWK3xECdBx/jBuuuO7jxwQlV?=
 =?us-ascii?Q?pKMREc901F0GyzuZGO70KKXCgCQRcmUYEA4wov1s/GbZmTAr1p5X7PKe1uqJ?=
 =?us-ascii?Q?em1K+7iSgdaPSVVk0jwUJ3adkvvA3MsBWUlJY8fXC9Cq/2cboOTV+HuqxHkU?=
 =?us-ascii?Q?n0N1v7J/0KF9m1wgQtVGvDOWqNchbyjppxmqRkswtxktfW7RDqttzrHQYPX9?=
 =?us-ascii?Q?zjt0iMRJ2YdV2r9hLlRlT/qe5FAuPhpWHIIkzxYEpHmjVUaoQcbvei9J9OkQ?=
 =?us-ascii?Q?sFHJONFvb+eMLrN2db7tkxSDAKnhpF5DeC9xpct2vTNZEJe8fs86k0i4GzHv?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tRPsy+wekj9XCo9YBp4FiOU9vJWkgVEJ75CFCAHvnfGRYllqIiLMO/dCFbQfIiESDXoy62xfDl6DLaCzd8OkVwYVS1KyCWqJX2SEkTasNvnvNvM3iY3XgwDCbHx/hnzdLozLTn71pf5Ai61NbXKA3hAZ8VOO+ppiLa2jPOGRHsH7PWlw/+4D3cGWyIIvagQE3sA3wNuGKBQLhURQxOe7AfIghWeNzkaaBOETW6dc81asYVtClYFhn7AgXmxYiEVD4YJp4UEseWg9mxD+qyFIWQcaoP2jcdr6UWT4Ps2nnymnx+rKGcBRucx0gwXQGMgrStxlbSaPfFDVAUmQFaW5WqgSPJ+klNxrjHL3YU28CDD3xD/xBvuXBjcIXLZXYy77gQ63BMFw2e154wZNmdwqoAQvDFuaxrciVJUAW8SD43cNmsGoEidzUwpK4sXyVli/ZuYQlL3c+PDfWQAOzTHcPvjz3XO4qTAatHqwtAjnHaJV44H1Xeh8AP4XFT4qNz3xyD/zSe1umtS6V+8qCGRKwOH+PDwvrNQezy/ec48HpN+OoN7O9TW5sDUYXbYjAzeIpehG0AD8EXHK4Y2zrHdbBp4IiOWr6QvlxZbw/pYVvLI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0199ea25-ed99-49d3-35fa-08ddff9a106b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 20:52:12.3321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4xgTmd9ekN0vhv0nbA72t4qAmSi/Wv1baFjvlfqG0mtwvmZp7L3uRmW+x6gOatgsuWk89ll22NGwrCPdeiI6CPS6qja5R8SyQKSJ8w+z4+o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5592
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_06,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509290193
X-Proofpoint-ORIG-GUID: b2AW3nTKR1HM0Li7eelHoefHsKKXm0p0
X-Proofpoint-GUID: b2AW3nTKR1HM0Li7eelHoefHsKKXm0p0
X-Authority-Analysis: v=2.4 cv=c6emgB9l c=1 sm=1 tr=0 ts=68daf183 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9 a=zgiPjhLxNE0A:10
 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDE4MiBTYWx0ZWRfXzQ3jRnU1SQ9Z
 S0N6stF7CFUNECY9ntu24XZpCZeUqWUCeEvaHTp82qypkOmJGNHd7C5VAaov4Hvs1nXsj4pK0Ls
 2EdbdneyG+3bek1apFE4iDP6aeQhQbyWJVnsyJp2ZWoZhAtbucVJAalAdHssai56UyerwS0tdkp
 sIUZwZ1tfV5rxZItH7N0LXna3hN57FVOJe82MR6rJCF1HJEXVoXKvBFqpl0Ws5aQ34qW9C2sGzn
 LKl4zwndVXoLGOWnsHhwE490ljyNIA33ozfTM4qb5m+BoPKuoUjlRI8KNgSxBD9qouPlR6NTjv0
 SmAqn4H83stxEukxMM746kTX/UaGIy9iHfkFA1ivOXXkWmWX7+f5xBHf4ySvdz4uuRlUB+JyHl7
 TnHsJWirA/A6KMMQ8qLvCTnPvP2Qkg==


Peter,

> Resolve the deadlock issue during runtime suspend when an error
> triggers the error handler. Prevent the deadlock by checking
> pm_op_in_progress and performing a quick recovery. This approach
> ensures that the error handler does not wait indefinitely for runtime
> PM to resume, allowing runtime suspend to proceed smoothly.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
