Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3827A14F70
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 01:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739930166; cv=fail; b=WjaSJqPecWkOK52dV1eCiBUZ8+fIDKmiMyzUZao94YYx3nuC5lvynyoMFEX1wg8MfaS1X6h5cDBmPeC9NUNhcCLFAiwgnYS1a+/9bNS/qjhLlBuDP+oz3B5QVujTNsg6/avOgPM20bZgScwaQTkN6+ykT1MpjlQLaXu0FkWQ27c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739930166; c=relaxed/simple;
	bh=iSt1vsH9sCq1EWN35tHLjWn48gy8mjxdW0eEFhJ7xKI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=lYudDRwVi96deNq9yMIk3X3OXxsN1TAiqL29qJ8vAQSrGB7EqW8X3ZtYDFokxqFugzzay8zpKCpR0c4u/3YkkKFymzBiYZVpB2yKiZvrXMLlFrD3UeNTdylmj1Fsntbgb4JBd0XqvmnmTy/4T90OFzpfMZLoWNt26cbk779kdew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kvAbV87h; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZkXoxgi5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kvAbV87h";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZkXoxgi5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51J1tbEC016305;
	Wed, 19 Feb 2025 01:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=oxhcPe4H4qeRuZFKAI
	em0YpBFhw/SimiFZdFmWBZh4k=; b=kvAbV87hb4Wzoaeo/VdFWdVwmNhnYu0MUP
	UOx9ySPfo4RpKMyA/AF6+vEcloWzcsSUTXcXgreM/m05V7Kt7a+lxZC1yB5lgWTp
	YnVFjHhohOIjhMBQiWed0/zTcb6C/dlhR+nBbmqWqzJGxcDCJ/taSA2LjDz+WCBz
	j97bGgNNQQIzC9KW7bkKDoXt0tdSgDvr7bpVi7NQ6wBezdQaoBl47KUrIofonjg/
	jxZoLt4UDuQPQKbmRn2YdzApIzUFbsbStf2MLbQjSXSfINEaP7nzCSTr3byS+43+
	TaoNU0a7L2XrNFycEnv29XNgXqJv+70ipzPKlDzElc6TslnKGNKg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00prmqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:55:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51INXRbk012061;
	Wed, 19 Feb 2025 01:55:41 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2046.outbound.protection.outlook.com [104.47.56.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w0b1urtm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:55:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BBOFb2Zh/jXInnmzIjh8VM6UPMKCbn1NWtLMLmgkB6qaEFJ7YCAygIOn22Fk3hk/2SLH4IjGMBC0qCN40gV2rWz/FYuCTYAqxzvYU4bE5PKLojNC9GAj21UxY7oFX97ibgvWKEIzHdHt7o/8nHgczQG+67TE0KRTqy4dQCBY1eKslKwMsH5AWLB4029IOPNJBMNdkzjo8JjoxeU06LqNtFDbypxm1jlD31YCzO4m/XpaZb2GAFwwlpmPqlbT0wpNAPg9vCNfyKg5r8guAc+du9b6MTU9glYmbtyUDyr4v3XEwW44Tk293WbB0O0NyFURerO+CpYQlVBN22ByZPdndw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxhcPe4H4qeRuZFKAIem0YpBFhw/SimiFZdFmWBZh4k=;
 b=ZeDLw9JYHJalCi1NGD+pyrHHN5G9xgm2fRsUXz+gdoEN2c+SODcUwaYbl4kytWpQSl/n+DJyXHL7sjjVtUfU0Oy6ggLdCLVx8T2H5uBCXz7mctou44w8LdpZ23UsVcJ4bi8ez92RLv1mcFogpVnLfXuqgPyBguUmPH6nUtoUPysWhT03NPOv67WnstLZdilBtRD3xRQFinHR+BNNzrm3X29NQhtvClt3fuWDkeBl2hCkuW+sV7rf6cL9rWnSjFmBG842GfUfmbp1rPq/UygSccwcANf6p8FZsE+2LIEwLPpSMliK8R4WHOMmk/eZJeLGgExXKNqJAIx5M0klclY1NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxhcPe4H4qeRuZFKAIem0YpBFhw/SimiFZdFmWBZh4k=;
 b=ZkXoxgi50B4OHdQ+LXsmX7u3BHiJyCZI14OSU8ZEq4FbTd5QGyoYqMkANEP2rQgpq+fysRPPITBLOnzzC7efBj8PgBtP3hHnsolR+6gmXVqHSEUnd9rOz07ABU94uEnO0fcHJgauiefTsUpgGYj/LnVdxhxSqy5AAi8FjY7SS/I=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6481.namprd10.prod.outlook.com (2603:10b6:510:1ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 01:55:38 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8445.017; Wed, 19 Feb 2025
 01:55:38 +0000
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
Subject: Re: [PATCH v3] ufs: core: add hba parameter to trace events
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250214083026.1177880-1-peter.wang@mediatek.com> (peter wang's
	message of "Fri, 14 Feb 2025 16:29:36 +0800")
Organization: Oracle Corporation
Message-ID: <yq14j0qofzl.fsf@ca-mkp.ca.oracle.com>
References: <20250214083026.1177880-1-peter.wang@mediatek.com>
Date: Tue, 18 Feb 2025 20:55:35 -0500
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6481:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f4bad52-a900-4410-eec3-08dd508881e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tMoBYXV+IuwuiYLL/VQ8SFqbFPgmBjXUGam14v+99l+C0BDJ8YBdtjgTRDeX?=
 =?us-ascii?Q?J0DnS2ZLdbhK8zv8azIh6pUd2i290fL1wiOJKjY2TZDdEfcVDsxCP+FSBCao?=
 =?us-ascii?Q?vOdfHfhppLEza1Ooy/LC1YgK/yCu1s+QvYEq4D8/J9GFui+x+H7xAx46oSyX?=
 =?us-ascii?Q?b3/KBipRbVDtp/RCheE9ocHDF+BO1B5qb/ogakJrliSNdL2hl+l3dHTt3QQn?=
 =?us-ascii?Q?nUh1Rg7Uo3Xz7/++EhUkwFRSP+qn5XzSqbqTM0L3xjFqzOTdPgG2rLDRoQ+l?=
 =?us-ascii?Q?SeWvO4ujWRzv7SkpEso4TuR8CzYXcX/9Uhot5yB9gDhP+rfFzyZGQO1CVRwi?=
 =?us-ascii?Q?YVl2X8slBFEgX5Hu7Tf5vsecirdPXf+eEho7XrZrUKCokRDE+bkdUgSTLtVc?=
 =?us-ascii?Q?mVE7dpa8bmARFTsBhvSYlRdOzhVep4W16eROo/J63+P/Rn67i7uTKds/AV2H?=
 =?us-ascii?Q?arzFLcNEY3tic5q8W7zqzzo3NmPN4zzX8rWJh7CV78ck1eS5ersJaxg2/TXn?=
 =?us-ascii?Q?uN1OvYne3ZZlxg+9nubuWTd7vOx5J2/1xc3bKDRc5EbEQCgqeUd2MY+2wNbH?=
 =?us-ascii?Q?TI3GNC+FcnQoovAA2C+xsP4bwsf6QG80kEGztNZ9E5p/tHrrVlXUwBthzr5Z?=
 =?us-ascii?Q?aJg3d3Fw6FdguOO2JzZpwrXjMXyjEKOQe/CBFyyxg1bqQ4hIwI0JIdTftVQZ?=
 =?us-ascii?Q?Pdqgd9hrJqJIHAxEaGyqwPiWVo5LGZfgyOY5z4hd3GFhMvzz6jTheXnvzt84?=
 =?us-ascii?Q?/yDtNiaQ7fTkoU7FJFbUTHUz/KboZCWPlPB8p8+XNLcskc1quZQ4A4OT/WPo?=
 =?us-ascii?Q?PRmA4DnC/Q1d4uyKrQhCMrkKkChPg37eKG17xkMOb+rIoJnueX5MPvlL/aab?=
 =?us-ascii?Q?lSV2rftuFiXKVCMhMAnnXWKlkF7lkeUiPAnsGF4fpUli0s9Gns2jy1lAg9xB?=
 =?us-ascii?Q?M6LxBm9vZJVUwngS3ygdxff2FEaaREA3xzO2ntvjkuXfh1mQQl2Gl4fRBrMT?=
 =?us-ascii?Q?+3JvCI+6Xp3mNGOjkrftEqsE3m4YD6bqxzcKZM6LkXZLANIICVVo3PXshzv1?=
 =?us-ascii?Q?l54ULnUQoSlBdPFM+6mx0Es3LQkCwK9btrZHLnApc4v5nzvc+FdSJM5oAxfL?=
 =?us-ascii?Q?0aLUe37A31FUyuFPBNBhufVWr/KJHI6Cs5YD9Y9PLTQ6QHibcV5qamOpQ5KX?=
 =?us-ascii?Q?+frjCrKYUA4SJg3bs/lKxQKQa9AyOYWEM/cTjstbhCgai53EsVd0RAj5OqzN?=
 =?us-ascii?Q?hwno2O5a4c0Hq1nVvARtZGVmQ3YOZZ/yPxa7ZJ81y+J+UkU8xTV0RF+hViOu?=
 =?us-ascii?Q?7Uefyw0tqCoIw6oDsHOcyhbDSJ3dFuka21K73tWLb44L73wSti22EHpygPNl?=
 =?us-ascii?Q?dTRc/g+7Xx95euoULD7NeKWIeGN6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SBvFCldLOI63EC34AbzVTFl7sBbYHaskXeUjuxvX4Y4p4XgD2f+vhKzwXCUC?=
 =?us-ascii?Q?+O9fESg3hNToxQPNu8VMvPtEHBi5iE/awGJRxY8jfDCruyCRcmTpqCkiCt+Q?=
 =?us-ascii?Q?E0bm+vrz/yd1tDdj3iZr7IZ4mLO97aZv+/1EYgKwLmK5AIZeaxnA/nF5+W7Y?=
 =?us-ascii?Q?fniu7lJbWjoMaIrsNpfgbn0cRakvVbXBULr8M8nHUNdKobvHur6rUY4pkdBO?=
 =?us-ascii?Q?7WXH0qwIRohVl4Dh5zJlwkY9LZ8/aV2C/uaK+f/+SG+QU5Z69vQH33a5rVyK?=
 =?us-ascii?Q?zTvFYbNr2gF9NIp4ralGCq/5o6U5LL1GWmcnVXjEREPMrgUccMWwRrS8Wv0v?=
 =?us-ascii?Q?v7DyIeAI1pRgFMrv6kVYN5XRcD/Ca1ya6dnolNXluGzFuKLoS/q9+xtathiH?=
 =?us-ascii?Q?QSXAkjekJO40wf6OZ2GcwWJ5o9KJlu87981bnXr3L5Q9/U6hwSU7gcLxORSj?=
 =?us-ascii?Q?nvBtSO1qyOyysb4CpXGwOGj5hDzlf7rb8QvZnQ53aNASTexhBIyt+Raw7HEa?=
 =?us-ascii?Q?E1G/wXhiP8tBajhzgFRPL0yhSysg8jmyh/GKv4litNQa744HaoGTV+afPUEf?=
 =?us-ascii?Q?9hmbnYr7rGNAJnroTgMoC5Qo46df25jN384/y2gaUanTdOs295eJc2PF0YJ/?=
 =?us-ascii?Q?P6ZKdZ/WZdVo8NgaFDu3PSLA+JhwrOayMwnFQYU9zsJgyHBuMJrwF8V/8RRQ?=
 =?us-ascii?Q?utGibmGDTZ1nwvfMaD3eCHgjBBmMszXnRKXYOznIOzfBTjDn3/9tJBhkmGFG?=
 =?us-ascii?Q?p2aO7tsFhY7iwtzKCRlHyhRDqeFZjCiB99wKXNWHT2RalWDQ3HTlMtXBCCYU?=
 =?us-ascii?Q?1GkfRVepJsa/Z3bFF6uvlcMYgLU0CSpwnSrRMTY7eZht+WI920ud9E8ZqpRq?=
 =?us-ascii?Q?1r0jBf15zZE7Avz5Q9ZxCP+VhlwNDgSSPvoQwGUlBHFKCtPvfE9g98Bbya6h?=
 =?us-ascii?Q?io8MmlzVTsk6jGwHDrEiv0AB69+nQVots/is8lEuRAhQixmTDYSZLIRpgDsq?=
 =?us-ascii?Q?sWVfpxL1hyPD667hRWRN3b9cwaKRS+/RJwo3fViYS4O61PxigvWsbVImZvI8?=
 =?us-ascii?Q?6zrt7/2c85bw3kmla/uwz6NIYOtNY9ISh1PWkkuGDudxZfEXhnDSPD6ucIWs?=
 =?us-ascii?Q?DW2VGF7bDR6LGvh37Rp5dryOlVBK4QmeeBoDh/gaywvqHdzr+nIujw+xniWv?=
 =?us-ascii?Q?SvQCJoncCCrhwU/ahllclVyCQWF1aQSJxMxERC6OlwxmjHYeDS6d+uE1H5Ec?=
 =?us-ascii?Q?l2rQBrRgkIbm17TzDlkqfXtYwFlf8ZDYjVV2HY6TpwOG/o3KN6wVBQDSNcSf?=
 =?us-ascii?Q?++8413ui6PlkkhDeK+85TR5jUp35jdvT438NOqggUs5ex6PxU6jJaZVXER+m?=
 =?us-ascii?Q?eVsEpIJnUVwoZJ7F80SRafR7gfCWugYFqn26b3Bg03nCzVIPqKp5MYMoHhlU?=
 =?us-ascii?Q?WhuA2H+oh44BuxZ2qGCJybAQnZMfIwcaYeQLv3QbFzpLGvQ+x0I+RfBdvgm/?=
 =?us-ascii?Q?Fn3NiK5bTinGxPO7+6UIOElioh7J51MN3Duud+Z5fvBqff5NW+4pIE3r/aV5?=
 =?us-ascii?Q?0WinwfYWm0uGwrJb8y84JG5KOqY7bfSDfuDVJIc5hO5raQPiEnRVl8pHehUu?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dxvL6/wUzxzOkbxy8B6lqsMgXD3XfTfGpX59JKoxD65gZSYzoRxxrWIdvslCVwGXKIbnhb9fio+ZxyrgyJQKkAMc6jkbUYwI+5ZPG4mYGg8yU+6/i5BghNAwvNDLfAtKgXLkj+HkYOb89XLhqi6BooArLszfBwBJDKLmm7ENeZZOAKfl+MhZJejeAQxYpXcIovHi1aUNnsPBcDZm6lOIDfQnaUKL0AAwsBikT6utNdSqJLiBBFY1jajZIbMYGghxpmO+dYTxwnTPOCX2yDQDzHeasva+I9icl1DOZiJxDvgzfnTcYpvoPLxUDYI/6gZS8vCO4s7yD6p5mHTWolvyPw9D75Pb/Uy2NjGb45ukPkWG6gVwiNH+m4zxJbRFriFIA/LTSjE03xfurotipBwNVNCrcGDHGvI2ENW+Tnd01vsEKnjRe8kMP8Qk+ZzyRD0UFZxmaoPP/aD2aSNDx524/B6XtlSePV4haeQ+LReFN0ky0Y8m6q4JQ0FD+jWK3CDpq7ftfkcqZ9JJaKNANp9C2eUw/NSPy4+Hxh9s/PV7PDnY8Y0plbZRN19gHZstU4IxRtBz6okuEb2F4uxhQAnP52YfPHh1VmXIfRwFJVrOFhw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f4bad52-a900-4410-eec3-08dd508881e8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 01:55:38.2868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fins4OxnZNXmKX5cS7w3n2R0N7cRJBA9CC4lAMIdvv4fAUcg8ugHCbdPL4wEZQwTVRi9uZXrEvRDkj67GR47RS/Qqw1xXNc4bisjKDUr5G0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-19_01,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190013
X-Proofpoint-ORIG-GUID: O6fydRpe48a4QOAw1rvBu_twCGXmr_Mb
X-Proofpoint-GUID: O6fydRpe48a4QOAw1rvBu_twCGXmr_Mb


> Included the ufs_hba structure as a parameter in various trace events
> to provide more context and improve debugging capabilities.
> Also remove dev_name which can replace by dev_name(hba->dev).

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
