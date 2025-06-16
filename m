Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143161E98F3
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 20:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750107074; cv=fail; b=aD/5TjyH1PA9VgS/dl91JXsQiduD1LCOuZR5Lkk64oorobCmyFPLGu37amX6j7+CievRb4olaoMTv3+0UhMngVtRh527eg04NAdrBA/ZNkfWJwdYYqrv8epM8R6mjWxuhi5R+T5K/gixAjsFRq/8Roerh9w7IDbrRUiwRQfvTUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750107074; c=relaxed/simple;
	bh=+TUo0vb7KVPx7ongmR2H84hbJtdi4a7DWU89YCCKf1I=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=n/cLKqe/8RJIik6xEP6nj0rfF/1eMhsYhOIx04GFwmM/eVQiYPUtNPAxZXcsg6pML9vnTNVRNskmSqZ/sAbQ/Fs6kuJvPQIgtfbQ3ps1FCDEZISt1R6kwOpFQ8Iknl7MOHo7yRYf+s92XSN9VX0dWDZs8hkIWgaI00+wqxZCaQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jJOoZ5Ca; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MHcTOnrX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jJOoZ5Ca";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MHcTOnrX"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHuU6H017934;
	Mon, 16 Jun 2025 20:51:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Gq91zyWxWsdI00L1WD
	q1WDbOfEd2DIcOU5e0pAD64Sk=; b=jJOoZ5CakNP7EzYpFCdBZOotBYqCLCLagF
	DmNYFOd9r8FFWnj5mdPwvBICQ3X0vTbHsAp8u3RbrZdZV4CCOnVOyk2nf2SI3DLB
	HbfidJPHbNX4Q8QbLm71CqtcNJTvKD+v9H2K2vKLiZ4mIckqCmP6J5G3Mr1hQLWJ
	2MJ6Z0Puh0AR/r/NCbHADcNADy1cqR5/kCGGab5LRidI6nwwrH9x/X8pYqPz+PjQ
	/JQ5CvY222VcLvS5aIyp1Ops0jx9+jpML/fTQO+ZBXmOO6f2H9nNj9N95rSK9AvA
	TjPwB5agc4u+j0JG04CwyVmWAPmBJMJ21S7Za4yFB0wIATjma4/A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 479hvn39t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 20:51:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GJ7gGa001493;
	Mon, 16 Jun 2025 20:51:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yh8e2h9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 20:51:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=msY9xtjn5TUTBKAf8uAyZS60c6LqUUVz03xoVb1Qkt0ZubXUqE6qV9aH5hNQxirHQFZZ7h9/tNFuewVKTWazPXzMA8DIwBjHdk+623qVsXrqlLyqlsJI+f7iz8qBozMH7WMJAWJeKgv/hVpxvznonEt+y4eJ8nJqfxJaW1LPD3flBuZBL9kGHlH43e5SIPbvtnyIxubjDW/vokCnmSZgPpTGD6UqwBrOpcxV3C+nyG9C5bdN+qPAyQpk3xFNXQFWiy9NDLzg4BWyyqObZu20s1utpnk1XkzJv9ZIZjwdOKvuKFwg5mPtspBXLfTmQE0Wt1ijH7pGKIuWUey3r0Hn5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gq91zyWxWsdI00L1WDq1WDbOfEd2DIcOU5e0pAD64Sk=;
 b=ZLv/0wpRdQIw0+gpGddnxuL6ToL5OLoCs+sohqcIh4CkErOv629XlVIDJDLU4Sb9KxI1I1Tg13hAKjNuqy80ix6dR6G5gmKi/jqfxk8pA896UbvTQhbq7rcm29MxHHu3/QGex3rQDuSRb2AokvEvUEuWJt9nQmVejMcNWacqhhm59UL3jVjeCXOVQ2mDOxs1k4aNIfagfxSzOgpv4Q4BtzCR+aZ42phdHmRjxX0mD5+JZhL6GC/JxULT/BeARMqu5Uo1Hw3gbhRFfamdj+WlY6pmHRfQc0bxKTIe1puQuWy2PPXs4EopTtuhjxN+6mUzSPd/DUyl7tMGdugp7fk9XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gq91zyWxWsdI00L1WDq1WDbOfEd2DIcOU5e0pAD64Sk=;
 b=MHcTOnrXwQP0/BadXwiJHQQyjn26WC6OIFPAADNwQlGdU2g4WjSkpO4GpfWM89rvKDha2BElHm7FD1jryRZhKZ3Hm3uVEPD2iatKDjcojFVSScrW+Jwvjy8u10XLH3gce9Dh7E/hj89EuuHzTTQ2yDZlMqKDsuXMTXNsv2Ccn9Q=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SJ5PPF842B33876.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7b1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 16 Jun
 2025 20:51:04 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%7]) with mapi id 15.20.8835.027; Mon, 16 Jun 2025
 20:51:04 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Ranjan Kumar
 <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
        Sathya Prakash
 <sathya.prakash@broadcom.com>,
        Kashyap Desai
 <kashyap.desai@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250606052747.742998-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Fri, 6 Jun 2025 14:27:45 +0900")
Organization: Oracle Corporation
Message-ID: <yq1bjqnza0t.fsf@ca-mkp.ca.oracle.com>
References: <20250606052747.742998-1-dlemoal@kernel.org>
Date: Mon, 16 Jun 2025 16:51:02 -0400
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0219.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SJ5PPF842B33876:EE_
X-MS-Office365-Filtering-Correlation-Id: de1ad991-10b8-4813-0355-08ddad178282
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J6+fOt2ofnYI0MRmEnS3iZ62TRr982yCemPp8SImlsp13k0f+m03ynhPwLvc?=
 =?us-ascii?Q?yB2UZzwb/mBUmbmr/htsNHdH99JkKO73BsW0jtMr8v20fX2HDqiicqsviUPc?=
 =?us-ascii?Q?NZW0RVU5O09Fn6pykjdjiDerK3SceKhtZaUrxQ6mgCl5jv8zDnhrwPR1tOcQ?=
 =?us-ascii?Q?xe92w55yBAM2ktNVpyUtj8NK9ejiS8y835iegqiM13RHtaBRSHOxpLX3UqNE?=
 =?us-ascii?Q?nBXYcAK80AnRzvxifdtvtcRVnXojgw+Fd2CbgOlk//EfVfqaobwljojwV6/C?=
 =?us-ascii?Q?zkpqUO5xx1++X2rvax5l2YPSqbh1ObK9xa3RTbj3WZy6ddoIm8VaTQFmSvMj?=
 =?us-ascii?Q?lm3p6o0+wy1MaaadFnloibqNhiek10lxkdA2yeHKhmi791CSXaapk20LFKka?=
 =?us-ascii?Q?9fpVkH1b1tn7svWZvAFrj+oE0oNm8Yl7JcZW+Q+K9nyNqxTiTqLOyJSAigkm?=
 =?us-ascii?Q?RbJyfq3tdw0gMNvv/ae5Hw41rGOWyRBsJylGwYKHxIBDYwfIDKsJ58dnU+jo?=
 =?us-ascii?Q?7GZ2/ANFWbwwi71SBntZDAYg3Xc9I1Hd+/wcogB9fhtapmy22/4DCG/V7O6J?=
 =?us-ascii?Q?Vme2jc4B2VPpAZb8S259RkH1FVMv3vxiaP/fPK3cPXG+i0C2EKA0KsUfplTL?=
 =?us-ascii?Q?l/Rd/AzQsCw233YC51pCsMBXpk5dKgVlFzHh4A0LYrahBm+qiZ4IJ4LsRbaH?=
 =?us-ascii?Q?Sa2HCidKnQYDS/Ltp1BlUFJSFDJsY29TMny/9Is1Ov7J9PRBgosmKyXy9TAL?=
 =?us-ascii?Q?S8JyH04QkOR/z9rBDLxcZMMfh+OEUQYjW49+H48DA9kD5yECzk0Bk6ReqX91?=
 =?us-ascii?Q?kPWPhXEbEsMq9WZppV7kzViLCWndqxo2zKnBQCBOyyMFIaMWteCK8l4kVfpk?=
 =?us-ascii?Q?m/0tzcqQXLsTcvhhOTCeXZCZ6IawYMKeNtOCj4Vh+z0U217hL9y8lgZe3KtD?=
 =?us-ascii?Q?GnRJRDNGjA8u+XaJUC1Xh+n87Ss6AX4JH5M3m/stge5KODEua6tVkxSeGKSM?=
 =?us-ascii?Q?kQFWIvs2qBG9kiCo1lyvSH5ezrk8fqa/yABb4jconLBopbeFrOM1o8VGPfu2?=
 =?us-ascii?Q?vGtCg/C7FnktAjdSsU62mFXJ2G8RBobqEXNjvuMqUa1X8Di8sNpJoYx3zj5t?=
 =?us-ascii?Q?Gxdw8iMR1qHufLNp2Balx2qmt6dKjY/UReCjzb6CgnOu9gXjeGv0zIUg72D6?=
 =?us-ascii?Q?E9fbYgvD1jyrw+XPglZ1kQRv3Ge4D9wH0eYM+flexonKRf8bVGNpZWQVzcK3?=
 =?us-ascii?Q?0KKdcalhhOz226ZZD36nFCf4fh0wgyQX1CO1bD+fuqNImZe4dJTGHJQ8Rswl?=
 =?us-ascii?Q?D5YF+gvBmKMdokmFhPfM9zXzv2D0BLXZZIbGGtPl/UilOn1jl1uqAgPRrScc?=
 =?us-ascii?Q?6ApcLzb4xgjJip/7hltHSxE0HkZjAvqC01P+jgiaOiYXk2wid7RqWeM0IbtP?=
 =?us-ascii?Q?Yfz/4rlixZ0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c+qsgxN1fEf2B6B/pHBXtprf0k0Zg7ezN1BKfn2cL+GkEkxIdpNzBjezx7gG?=
 =?us-ascii?Q?AgGM+SF+HoMPQAhzWNKpiwYCIJwQ7Sb4hbi7kPLb0z4fFWtaNpvv20eMwGHe?=
 =?us-ascii?Q?qPJYScTIF9Ou3KyIg9jKoDFfqBkF6er9d1sWUaqvJkfNaJmb2aM9I1a+OXv/?=
 =?us-ascii?Q?900y/HxV8xEvU97wCEBSgAzaIHiumFvtOasKzyGXO1CFQtOgxieTkhzR7nv1?=
 =?us-ascii?Q?m9lupRup+x3dxX0UrZiZH2y328LF67I5G0elnotRrVKTYG6YQZDHk0MK+5bh?=
 =?us-ascii?Q?Dj7JoWzPcdBA3U7Palgc9nK2qyd5J0q8hBZOKjudGfh1U6SBitma3b2TygqJ?=
 =?us-ascii?Q?Bi2FyfDhJl5dUcXDH7l3g4acHMtNLFUQOuH1oCeb6+BBK770Om1OyiW9sxXQ?=
 =?us-ascii?Q?S0JKQYGDXkIMguKcTlr6uG3lmBc7ReP4aRIdB9u+CvCqYT7uj3uGD3Sd6L3H?=
 =?us-ascii?Q?NYsz0EPtwL4iEDOmX8A0lEafdb3G14ilFfNoobaq3o/jPZ7uX4YTF8kbR1Vx?=
 =?us-ascii?Q?gSk5/W+TAuWQ9by9DTAWgkmydVAfMGJ8YcvHZ6cI+gc+8c9S6dWxFvmalCOX?=
 =?us-ascii?Q?fu3pdHczWw13/Rt/EPH5oxAUTiVgm5+EXYTixbV2BVfKiEzXTCxn7a04PyWA?=
 =?us-ascii?Q?s8YLMi4mwLTyXSj77XvIRWWP8lSHsC9TBswBpZPjScRL9dRslDhGtWYsG/KH?=
 =?us-ascii?Q?uSG6pd53mrygR64s0GwI6BPdlCRxEE8WY+u7pkw7uYUqlXkbOHaRRK6EdMoo?=
 =?us-ascii?Q?EuuGhk00m+CiBOP8u2R85X5meelLld0RDbpxVPYCgbrZGnDDyCCIa1Ds7mQ4?=
 =?us-ascii?Q?YmUTlwDftyGCbVpQWfC7ycAsXInCMZs+hPDAsMFvRFEifxO2uW4a1f+CuLgJ?=
 =?us-ascii?Q?WF949Ia+l0pwILlp7VtX5nqiHZwMOFHxIAJo2zQCXSwAUIOZg8VuPhBeuzDi?=
 =?us-ascii?Q?3XgLpxhrKl7h3pWVUgjUads9ixnXfVdE+XtqgsiUK34d3UxzSQNZnyw7m4PO?=
 =?us-ascii?Q?KIuA/rh8+PLHC5WrY1TfztJitaooyf9N/f0aLIntdSG+P02Zsb9abHmuJT9X?=
 =?us-ascii?Q?14tr2QllmWf2Wuw8gUxI7yqXQDZ6wae/U776tO907ZNJFORCuVjGoNZQf4kf?=
 =?us-ascii?Q?hEp8K5AWn+JvL2BlEw6oFJcGbkxeoG7UN2psdJUPvIPiB9MNxo3EKk170wvx?=
 =?us-ascii?Q?8wjjXAk7m3bxpe5LeLVq2zKMMkB8/6CRY7YGzFDWEPWCPt3OyvWrOzqFnmwZ?=
 =?us-ascii?Q?ihK4Tnfw8liQX7VvLKdjXLFYsE7BoKx5WG7QjqVjoaH3YsEsMEKovDeQUnZH?=
 =?us-ascii?Q?o/G0otgy3ZgSzbLklMxoGn1n855+CxXPAs4k5ZdxFWT7ZaFK/8qsaCfGksOM?=
 =?us-ascii?Q?n3h4+bP2v1a+HY0631Lnu0oHk7MkCBZKpLhdRhe9FV/PMwPrsHpDD6vpbZK/?=
 =?us-ascii?Q?1nnvxbidi1wQG3xx68HHO/vReoVL1DYg11ZeH5msEN00A5A9a/mA8RDgp0lf?=
 =?us-ascii?Q?IiWQof2063aULE3zf4RGh0LLlDbHhz92DePzY0SS8c7TBrfB76Q3RRvH3PSY?=
 =?us-ascii?Q?U1lI+YKWNhyZb+wXTnPaSF64ilR9I1IO4WIZY3019O6KzlJeBMlE0eYSpjjR?=
 =?us-ascii?Q?0w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jUOf9yNA8Pq/ZMLCtO0x7QcRCOhTbBrroMMrlMwMi4qsfSdiyDertFk3j8IxisXvlnTCAcJbu0ZHxgNx3TIGXoZMm++1V9bplQwawcysnHcYk1a7k+m3syJPh09qLandwXGln4aSBBXpFCL9bQgl4gGnP7PHwjqcF7d7nVlI9W+4MJaqziqAvaE+gNycsisqfbRwEr7elRdIbcCt75fwI2Iru7/qG7i8QmafcZ2OGAdD752zxf03mt0xbPm4GZeRpuPgtKFsM9L2E49XbBtXbnSxncCLuXUdD1PFcKpZwc1/4SGJ63CtuqJRLTOyCLg56/bcIY4lQeXaFDIQkjNp+sIzCq0saxEbM3E4QYB2Mz+knhJ8/vsG3szr+1AIexUCgtZ0NCwI/j5I2LWy2aZWMTwLL35t5GsthzEUaRBx1cFO5l0bBZou7S2/xapsVpp+HUA6WuyOpoWGT5BJAOD7u96e0RL9LUsDu24oJO84Ob21/PX86t7zvn6daCiBF42NqE5zSH806oOcclZDMuqkVgdtO+m8T2V/EB7rRUd7PvEuYOX77YwXtN0yD6eZ0mSInu/GoWAlh0lxSWMjNcgyJh4ERzhHHwXH9kKsd/JIfNE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de1ad991-10b8-4813-0355-08ddad178282
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 20:51:04.5531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u/0GOMnkrbqDA16uHlPj8jBiW2XI3v+o5zA6nDn+Ov7OrlJrDbahTFPg2j8oh4bho/eTwm0ScR2mbWyQQU3G1TEB5bUsJYMtB93BsZAxflc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF842B33876
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_10,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=682 mlxscore=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506160145
X-Authority-Analysis: v=2.4 cv=XeSJzJ55 c=1 sm=1 tr=0 ts=685083bb b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=QEB9klMSocAp1bbJnhcA:9 cc=ntf awl=host:13206
X-Proofpoint-ORIG-GUID: AL21-RKZNMDrAl3peZv95sklC892A88T
X-Proofpoint-GUID: AL21-RKZNMDrAl3peZv95sklC892A88T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDE0NCBTYWx0ZWRfX0aC3t6Zl8ZH7 SCv0KMoLGwPXF3kTdoIVazipjXnQqwp713Y802IE6HrADU408RCeelktaHdTNGe+pVLAk+YMB74 /7i/cv+4O6ON8jzwYSJTqICInNb9xoMFMuEDmFGFpXJZ6p2clPC9Lm+lfLYMOoCrCMtAhaELep3
 GcgcPDnJVvEFNExs/cjGMch1AfbsTwkqAXhGzHa3Dxt73Ru9DEA6JDT/0eYAeMUSic4qgiD8y5o vY65KPy576i09Alw+HVVU3SZEyG9LGQ8QkEQZjanmLG9VYzN+nSHEocLP2L2qAQhHbNuYHZthfb 4nX2a3ojUU8S4pagGx50T7ZVmpBQrwR/QpKExvsPH9J5fv1ERSV0x7VpOx7YyqreklC667i6j2Q
 aNRkcuUyqHjF+QR5qiAYsy6kqmGrItPkzho35am5UtpVZlClw1ab5CynxKOahy/1FYVuMcm2


Damien,

> I am working in the dark here, with zero information on how your HBA
> handle ATA NCQ collateral aborts. I am patching against what I am
> seeing, which may be only a partial picture of the problem. So please
> check this !

Broadcom: Please review!

-- 
Martin K. Petersen
