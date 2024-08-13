Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8F333D8;
	Tue, 13 Aug 2024 02:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723515687; cv=fail; b=lEC5QgvHvJHQhJZoSwDAnqNwJDdOdFMNe526o1qA8VE8CBOnbaklm19z1MRXsXkYk8NhWdH1FkQFCCGfg5ktV0Le79U24Ief9mnH2qmr8ZZbJa+8PC0UixZYM3GPMCxD+SzO5D+qZzHHUC3SONfVlOC65R5t+OJOU8ztSfIb554=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723515687; c=relaxed/simple;
	bh=o1djBEaAU7+68PmLcbz1HGQkJN89B8ZgxqUTQltIwNA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=hyFdSFiUc4jrCgCPM/3KTLEqtn46r/gQj/Xrr7NmLz8SfHB6QvzunbEJd/LQ7guRC/CFnhwBzK6kwP9pkwRJdNXaPdbfzaS+casTaT2I3QihFhdgBuOVkdbGBdCRRJ8TGNVx4fJqQGCEvfCUDO1f1dG+ZKgkELwHmJkxTDeDdSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OzBAIt0y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ouwnZpAx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OzBAIt0y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ouwnZpAx"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7JTB017241;
	Tue, 13 Aug 2024 02:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=kRhhmbmzfvlX57
	GiQiECK4TTj1W84Na8N+DK430K+4s=; b=OzBAIt0yIwzmJitPyTbA8U2l5/WbzD
	cdlKLVxdprbUJplTmVJbZujpe+2zbwqUcdBwB7fZKwRn6sDqup2G1zi5Er43MYYp
	QiLnMtEUdQA1SLxtM9dlkdbZoNT6tpdMWkS3+kCuz06wxD8PrpL27d2L01wsb4k0
	FAV/NgKmNP0gebWYCI91oEs6/BCZ+saoT3I7Uu0f9tPWJoMb03kEuo3x86V7afzI
	aMyDMPol/2Zi9WH/CGnNbZVe6gOMcZ614eEEXphaYBzkgbBEzphPmziOSRRI1GnX
	K37oMal4XW2PFn4pKe2JYR89QJqdamLk+V265G4+eV/vb1N4HDHiW3Bw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy4bd04e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:21:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47D28rZv000659;
	Tue, 13 Aug 2024 02:21:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn7wa1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:21:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HT3gp6V2Gva5VAVdsFXGjvNF5NlxJPD0gp0B9Y4yBff74Mk6+OUrJ5BDUAG+v+WaQJnmFBKpp+DmzDF0B2f4/oaL3nVEklhpv1ajglPIJzTd9Ny+7E2a5PbyArydaYZeK1cGIgWEm6FxVklsmPNYxl1ANChwzdmLWff3JNYBekOBnwSlJexrpKkH8XIeLcwLrKom4pB6XoniVz4ptFwQZRVThob+os8HvEhdoLcruFbTrCKU3dibCEZol43DwG8QEer+zgL3BkNekLySGcyLE0yoOp+XsNLtxKZ4uE+29sKvQ3ZjvgiLIVi5wpoxKNsNHMpjjxrrkajqL8l8fW9MjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRhhmbmzfvlX57GiQiECK4TTj1W84Na8N+DK430K+4s=;
 b=Njta4/BPMWsUgRJ2GDLI7yBjjNO8QiQI/T7m7r8NECSuxiulY2gDgP+YYzh0JSmt64Vw8DErbOgR9lUgNmlQakKCtqnEn8BMKhY1oMqBS77R1HOBjYb/FtPqkhSvHOvseT/evjB61SNDGtE8EDmJp2PTK9s+ppM22LHPAqxYwTjult2i03WcnCq6VnjSI5fw8Zi4JaEcx9rc3a1NSzVv67GwwF/NWO2ujmQ2YT68dLB6h+D8SNur/Zg2sCFxtqdADy0lrrgrbx1/WOy8YI6It7wmwX92Cmkg0WLL/UNWzKPT/fPVqwR3UPUp3QFpiBcxdYaIbr5XWBqVPCSyUeLz1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRhhmbmzfvlX57GiQiECK4TTj1W84Na8N+DK430K+4s=;
 b=ouwnZpAxyRhLJdiY2Lp9TF3pdRMUTcqRWwaA1Qm7GMhyfYVOpcoWNkInKl4SBlEx6+MtlpLGIIjbbaedqNI8X7qCx4c1omKt4ELwf0iFmPGHCgEpZmiS2HH+hEBxeH31hKWAj+L6DDAHtyB1UFEAoFSmSX1CpEof/gIsgTtjIa8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ2PR10MB7735.namprd10.prod.outlook.com (2603:10b6:a03:578::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.13; Tue, 13 Aug
 2024 02:21:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 02:21:16 +0000
To: Chris Bainbridge <chris.bainbridge@gmail.com>
Cc: fengli@smartx.com, hch@lst.de, axboe@kernel.dk, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] critical target error, bisected
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <yq17cclw4xl.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
	message of "Mon, 12 Aug 2024 22:09:10 -0400")
Organization: Oracle Corporation
Message-ID: <yq1v805uptn.fsf@ca-mkp.ca.oracle.com>
References: <Zrog4DYXrirhJE7P@debian.local>
	<yq17cclw4xl.fsf@ca-mkp.ca.oracle.com>
Date: Mon, 12 Aug 2024 22:21:14 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0039.prod.exchangelabs.com (2603:10b6:208:23f::8)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ2PR10MB7735:EE_
X-MS-Office365-Filtering-Correlation-Id: 6edbf4c0-fc08-4ff2-2bcb-08dcbb3e9c26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nMlWJrbXs8+eJeUUm3cxQjPjG3Fy5mKjN0i0dERQ5OqeVCn994KQ3gPPemhu?=
 =?us-ascii?Q?TawVTOKqO7+RB83yqSV9d0JkQji8YAdUKnfbyA/QDFp1yhXA546WlBO7N+3A?=
 =?us-ascii?Q?xJrRJfTDt4JiOhKaHT/2PfYPM6onwyvZbX5iG0Jx0Xd4PyNfR2QszEMqofs8?=
 =?us-ascii?Q?CFcSERhoX6mhhHe5xySMhKmLB+pkFMtFtrFxTL3fM4bcte+U8VuKxPNmCpAP?=
 =?us-ascii?Q?LAUohsUVQbW/TMnQ35cvQNYeoyh96e/fALvO3Vzt8oerBNGNO0bXMxhIOCB8?=
 =?us-ascii?Q?eSK+cfOOtelqvLthGt5j42VF9DLQhnxeGLfDKrnAHuoAvUL97FO/x3aGp3n3?=
 =?us-ascii?Q?131kYzgnCF9g3Y9lW6dE4KWs+x9QeZaUDANVRenuE3XFNHBNWPBlTGOFFM2m?=
 =?us-ascii?Q?ib9kmmZbOyPsMB2sTjTZPV6mMA+/fAD5kV3jHAnKiTObdVrObI2A10gZ3A5B?=
 =?us-ascii?Q?3GBAxUTtXkMhe/hcR5QLW5tBQ4C+h6OlwWKZ5YMNq/0uXLKayMR4DlF+mhY+?=
 =?us-ascii?Q?o+eswAyxvBkeQupca8o0KqzgXyQBKG25RaviKjKu7M/NEp/iiFih+dmiD9w2?=
 =?us-ascii?Q?x962DY5neZXKFW6La4PCDiijWsGTjtgEYZc6RyjNuUUH+B8xBg12sDDqKaLU?=
 =?us-ascii?Q?iJGbes9mc49tRQ3BLqp9zGBts1dOwOjyJWn1FAbipIlwUwpn+mvU7FJcsO/Y?=
 =?us-ascii?Q?ilk4OkRvkBjLG2v/O/whN/sO0vvUah0gJP9zKjq5mN2GuNUNEFnuvDk7KDLi?=
 =?us-ascii?Q?Sk8O0JMSHtHoDV9ub8fZmzuJV8Bs7wTmebebEI3l/KIWi0BgieBvkEwEFo15?=
 =?us-ascii?Q?pudYNiJGOWa9S/imwMD//bzjoNChMw44eZNe6ZeYlXuxW1NyDr1IDRc2JliR?=
 =?us-ascii?Q?hiKNS2Cawjm7rEmxp4ku6+LmbORHPS9OkAMx7wdIhIZ777p5u0e3mSfxay+t?=
 =?us-ascii?Q?yiKWSPqUJrlav66v0G2N0TRJPzCK6bo4A4zSIU+FZCspdztGjEAE6t4ISFMP?=
 =?us-ascii?Q?vnTAO7LbywLfwfBNVKn+Rg//LoF853bxY6zzrolqOqxAVyH0BHxKEHeqdNAK?=
 =?us-ascii?Q?PVnbsyDK6TpdCSnTi7tfPRc9NxAz1vAH4Kmhv6oCnBs/C43HA6j+J80sR+3p?=
 =?us-ascii?Q?sL3ijohyOgROQfx8NYhn0/43LjlWyJTbtKBls1MXd+MBJaRldQUH3dVp+YtB?=
 =?us-ascii?Q?nmsY4scb2+q10WClJTIWSYqnKDVo7X/nWgDM+bfpFydsc3WrhP9FTXuV6x+T?=
 =?us-ascii?Q?rE8268IEf5NMCZbwYl8J2+Qxn4jZ/Yd3VIGFylyE/sOWwNzhCmTcSomK1V47?=
 =?us-ascii?Q?ceoRgUuVVnGTS2LI1N3NvMendNDzpBUzrhCPivd0rSk68w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rGcV6eZwk2GgI/uEZSmmfJC8Ep3oVqqlo/ADPE0AnQYdZCI2NzDHYQUImluq?=
 =?us-ascii?Q?F8/zMqEaD/3XGfebYs6WD/OCFHlB5oZ3TYocq96oRqH5q9GRwSahKauYfj+6?=
 =?us-ascii?Q?6aTp0rdVauyfi+McIYITScibjF8/LmyfA3zEBG5mk8WegiVm2tbc4fWTih2O?=
 =?us-ascii?Q?pEWVo3LxpONX0aMdQZVLcDUXJ3+z95PQgtNplH/LGXvJ2tBd9dGM9NcC2Inw?=
 =?us-ascii?Q?SD7bjksXMS2a/Ao/jfgy38DD/5B3GOL1wkBvIS9E8Q7yBfDEqkuvf3FM91dj?=
 =?us-ascii?Q?2puc9/5zCrpV/Xt6D3QC/8GW1B3BX2WXFdST7EiUJu8j3Y88HPizNtMVw5Ll?=
 =?us-ascii?Q?b/wpnjsTD4kxQ/wDN05j5roJhI6nC+Ly5WHHHu9203om4uzYTLnX5fywpxQ6?=
 =?us-ascii?Q?4tB9nxqGg7xKlVU8l5XYGnXNRqs5qgHS6NzUqbswLcpJwPyPipBr96q6jtGW?=
 =?us-ascii?Q?P5oTp3Y0u3ypEICbOTK/ouH0hmso/snbsfU5GtiP7Y6mXhwtPgEHt5BkpWh9?=
 =?us-ascii?Q?T9MVaauJX3pyQ9G/cKWXia8m1bRqwSqAFeVXw5Qq7pThISire6apCgCKQ9BU?=
 =?us-ascii?Q?QFlIEvKNp8iYrym+aNZ7Pcliv9uq6WaE5DiHztUCYNO527f4ZykV63umn3E3?=
 =?us-ascii?Q?4PVWVWTJpPcS1LnARScB9YCkomog8OqPVdvd3qc/snbTqlIdzGPrkriLdVYU?=
 =?us-ascii?Q?oj9jjtIaznkEhgWF4VU4kyFAMTHE3EMDICdHUrfd71LqAcI0NbO2ibtWf5qu?=
 =?us-ascii?Q?zpnLj6D7SEGmcoWHfOw0nRQqzWzEmG3iUB2pDB0Y5l8Wvzi9uyDgNdx/N2cz?=
 =?us-ascii?Q?ExvUgqdTVTnJjG3BHrJ72m8aoRgJHZL7C0Q7yU4SV1UsojsBZvS3LEXkDmyS?=
 =?us-ascii?Q?xKR/8DbDPguCrDKBDXQZl8zj+fmy4OT0xJT4Hl0e0XHjCz6glmJcNne7CNYc?=
 =?us-ascii?Q?HURQRPkYVe9fckBljLIaGf/KQ5A3IW3W38eN6488K+Iw9SbsQGzZwbBPfR2i?=
 =?us-ascii?Q?CP/QLNNYgb+WJAi5yqg0+D0vW6iE2o5WAGXEubXmakUD5tIX2nrwbg5VcjHp?=
 =?us-ascii?Q?4GbYea2egtn+pCNZ64rGJ9vuEpiIKOuiBoO0T2VYEYBT1qMJPt3IHd6+jYsw?=
 =?us-ascii?Q?aoF2CMOH9fBESVou8HudOSQ6RDb86dbru+gTqSB3CR35sMaAimwSNwXUtj1d?=
 =?us-ascii?Q?7Rmb+SDBqEd/yrRqOpvtG9ktGF5LCZ+hpPxzIRrpXjzSNl0hH9lTIVrjbULi?=
 =?us-ascii?Q?VTEShZl/CUuefi7goGHD9pMd+er5/ggkrNw3sPFNlVzBhkuIMcLDQIxQUK6a?=
 =?us-ascii?Q?Vr2XWVULfOxHAKOnnVvDcwANWPDBYUzRmbqPFo39TxdeYFZdJ5/iZvgsNjgc?=
 =?us-ascii?Q?xUavgMKiMxeKNulJbgIR5OGea3jX997ZJt3ThjP69uiljjbQtxmXRsfk5Te/?=
 =?us-ascii?Q?b2AV7x+8RlT+EoMjjQ7iCvaeqKesD1RkyJtRBavCx5+EWDEn9UC5DbFey8FV?=
 =?us-ascii?Q?p1AqTvYV+PY0z2A+XJSdOqDMDPKMSNggV1cty0PlHUDu+IVLSDqD1ICUlfFv?=
 =?us-ascii?Q?oXCvX4fPy8uX++IvvSPKxu0yBGvQi+mlWyiFuVOP+OgHfZYLndMfS5YOwP+s?=
 =?us-ascii?Q?Gg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wdGAlhKGAHrjvqgjCrWh2Z+qp/acyl8gm2XyHaTdC94A1wqfXSK8O9ePvv3R5YAQKwlGG7N49Ko5DONdnT0P9k626vaHdNIF8TRGR4I8L295u4vdMpsQagUnQsKp5Yhk0jUNvaNDeza5OkmJ7Bm48+xaucj4lx8q6D6QJdnYQ0Xyn5VNsAurc9Xjth/9/FlvduzelMWx2A0ZBm0hAYvgr5U7cMPxW++cUXPQp4U/CbnGzLGTNHBLp9EtHZbeuOeMYI/7fUU7r4NBD/0EO8Ny1JshBlbyvFY8icRVrb2VaYCWxzQUqrqRo1oH6DF/K4/IYmd0OTq0rrd1BXtnws/VJQWFniIK3cDgouMTf5TuNTL79E1WVIbS6de101qlNNl+kVOwMsX4rCTSM2DTA/ki/xVAfBScKkJQf9UM2Pp+whs38a2ZnYxMmkJyuXBjDX2dygHkLdlyzvxs8BB9j67AwPgR7DsIQZiwc5FJb0B7VXJUDrk6ygIPw1LklcwiO6oW8FD3UNQI9en4m1xG8oqE+aYc1mwIfCI8fWdbJXJNvKMTOlZQx/k8PCZJ23pV6maC+9MvjzurPnvtZPaH1/ZLAKiJ+VTdbXj8tdeuw6H8QEo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6edbf4c0-fc08-4ff2-2bcb-08dcbb3e9c26
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 02:21:16.2678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eb5JcR68zholwC5WQvAvtRSXdxNyuIqzQ3wosAd5v5HW/Ob1g1Wq2rf0IBhparc98OOSMBPGkPSZYlGUA6ZB6fTVW8h0DxdeHZnTmxkd+mc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7735
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=608 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408130014
X-Proofpoint-GUID: 2YQ2_hqbUNmkCybo5y7t8QktyK1DvRUt
X-Proofpoint-ORIG-GUID: 2YQ2_hqbUNmkCybo5y7t8QktyK1DvRUt


Chris,

>> [  195.647099] sd 0:0:0:0: [sda] tag#0 CDB: Write same(16) 93 08 00 00 00 00 04 dd 42 f8 00 00 2d 48 00 00
>> [ 195.647101] critical target error, dev sda, sector 81609464 op
>> 0x3:(DISCARD) flags 0x800 phys_seg 1 prio class 0
>>
>> This error appears on two different laptops with different USB drives.
>
> Are these drives usb_storage or uas?

Never mind, I see what's going on. Will fix...

-- 
Martin K. Petersen	Oracle Linux Engineering
