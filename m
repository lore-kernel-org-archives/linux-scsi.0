Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CC45258
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 01:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741656644; cv=fail; b=IAmYqqW9YhL2PImWXrckkGGJ8qIYzF5SeKDLGKR5xGcG4DcWabuPov+fX6tGwuuBi4YlSz5xRtXblVW787uvcxP99PYICvXyQEDM6uAsBuSZQzIw4RvtFlnZXoygVrg464+eUm9y/bl/QbQniOXXbbL8mjQWTZ6AvK8YhM7RiP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741656644; c=relaxed/simple;
	bh=5bNyql6121KQGJUgJXF0t3JsswRi2BdQrTj2WLa+W08=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Y6rS0+pC1gGhFoHYF6uDQg7DEjCpl1poZorBIUTyWCqr4FYIjm4vEFTBvoI6/HhHetq46O1YfnYoh+mOjfNhC88VYsz95XmC/w8EZk6MAv1x1pg0Y8S5CC15qo0HQD2ASI1gZKSGrptP1mmExE9aImEYIQxgdqbNfyk3XSne8wM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UCTwONpw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ta2QGq2R; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UCTwONpw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ta2QGq2R"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALfnFw019755;
	Tue, 11 Mar 2025 01:30:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=XRhQ3sGr+VftvY3sRr
	0BjXQIipmDyNhs7IjQXk1/+5I=; b=UCTwONpwiO1cPUd/tcD6yUOAfr6l9hjYic
	PU9db9sFD7Ar8j08VIrgJuKcggDq/KFRXg3YUwEc9WB7LxefDeLeVeSJvx2MY4n6
	7rJls2jaugPVfOS1oygnrItPkn4BGgYx5TjW6UHtgwO8o3yoBmJ4jXQDLJ8iSlv3
	xoQ1Wujdm6wL0IXbYvo0r8B7XnlegyAOpS4Bk/Igboe2zRcwYAMamKiaLgUYaIN8
	uW8c2oKKTCOwGhWTcQ4yspQBPrTUvN+qzVA+oC/wGt84iE9mTK5sd7iND9Z/9WUG
	eIXrMI9E6mJLxReiKmfWsSunLmN2luAR2VXwCf8mRFptaLMb0Hxw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458eeu3vd5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:30:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B0AuT1021906;
	Tue, 11 Mar 2025 01:30:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458wmnv6jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:30:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pU1zg6TIGFuSNsYRf6VaT5clfWnD2vzQHBerb6zTvpypYN3J4BIIs9cLfEU5oAoXq55os78ges7YSkw7/DiuOZndkaGunUg8RvHYFMj0FLvkulqA6uB1RMzfhe1e0Cj5uA9XAdoWEjd1G24IOoGLytFxV/jWZxshm++x4hZnEr8P8JUl/cEn0rmGXx5NEDTEbDichV9rYxRQRPPHFHMgS32H/PmE+5XZjKHfiNMqUPoXIBPJ1oSG6wGfVOMKnbTPZblTWClDOGGleRhopV1w4kLlkEhGmYzpx+YqnwtfNzeKezeyJe5r0CtdFCs5xfwGArDPzB84L9q8sV2DYla3Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XRhQ3sGr+VftvY3sRr0BjXQIipmDyNhs7IjQXk1/+5I=;
 b=klOj/5iuykYeNbkjXoUu1dHi0k55TbaFBVvROE4sqL94dwQZhxdcDi5D20Gu/+iDlfrTTjoAwxer06X8MTe9+tatCzsoQx23M0qTTbvhdAVfFbjm2Xzrss0676ZCbwtddwUXvV9T91h728fu96KyUlDecSAzuT+BYos5n+vjW4l7AM5Fe1ej82GhRH8SwY4Ei6rSLiBsHKD8lvsyRk4pylgT9NMC9hlD0bRNhTa8tsM5nVddlnS6/Es1lox9jgjIMHz53W9x6RetokBADDcF5R+N+7OnKsGjHonGKdMAtu8qdtIF2U0std8aqq+O1FnqGiJy/w4M4f1h0lV3Lddtvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XRhQ3sGr+VftvY3sRr0BjXQIipmDyNhs7IjQXk1/+5I=;
 b=ta2QGq2RuC22Z63LciHTzGrnjBaZ+KMklruaO73/hK3/Silb9T1tTYzMI0BH2Afd6Onr7WokkPlIujMcXXRuq4lGLcOmsGX3htbpJu/GTRR+A/zwUnxFEDpg1cWeXREjLdnqFwCCumOS93Sr0juVwSTS7K5ml+Jm8v4hTJYaAbs=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7248.namprd10.prod.outlook.com (2603:10b6:8:fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Tue, 11 Mar
 2025 01:30:33 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8511.026; Tue, 11 Mar 2025
 01:30:32 +0000
To: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
        prayas.patel@broadcom.com, rajsekhar.chundru@broadcom.com,
        Himanshu
 Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH V2] mpi3mr: Task Abort EH Support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250304191453.12994-1-chandrakanth.patil@broadcom.com>
	(Chandrakanth Patil's message of "Wed, 5 Mar 2025 00:44:53 +0530")
Organization: Oracle Corporation
Message-ID: <yq1r034icbo.fsf@ca-mkp.ca.oracle.com>
References: <20250304191453.12994-1-chandrakanth.patil@broadcom.com>
Date: Mon, 10 Mar 2025 21:30:30 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0253.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::18) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7248:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a27a3f4-c757-486f-9ae5-08dd603c50b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wg6w6g2El2FfGxX20/cy5+jwn/HgPje2/MmLeTqapbt3i8ylNUNCdVlkPM/j?=
 =?us-ascii?Q?/dXWH17zFvuPebmnLetU9T0W4psFuvfHNQX2FvjTwRIZVrukn/9p9xHdwJrP?=
 =?us-ascii?Q?HaH6EEtGIizDIwe0+4mzM50PbFed6aFgwjNk6eiDct3X27bc1IrChRkSsioE?=
 =?us-ascii?Q?XNR8i1DXUxvx7ywTUh84+I3YBl+xu0h2mM3M3XRvM239mHXCCKWjiBA9uct4?=
 =?us-ascii?Q?UBUbR0BN4XDvjcvUKSJsznPBicJstCbxexyyCEpyiKbvfTKnFfNw5840bDiV?=
 =?us-ascii?Q?Q6e7H21E+RIs0tRk8DuD9Bt2W4aP/OsAWvtHcOdeHruqY0JAc5Mp6NW/Pgmz?=
 =?us-ascii?Q?dBkn0xrOQUhvXXo8gO5nprYrJ55rtDEiQ+3Rac/7tww0UxNNwhW3iuG6qAns?=
 =?us-ascii?Q?NP859gqtTovd6pgJ6M+SttI0nMDEU+XLZkMbUhivaAbuA2cjaj7qV8VjyZaR?=
 =?us-ascii?Q?5gNPbtqjZQzkuUz0tTjJkf6rKbpjehq0T2oegct2P0hc0Mk6zTrBlHKeSdHY?=
 =?us-ascii?Q?vWG402I8y9mGdF7xeste23DJ6QvYqLm0FWUT99BqSKT+TNdks+g2oPYDvXL6?=
 =?us-ascii?Q?VrMoApH9ZWUqrroU9N/EEfpvuGFzC6DwprkrWXreYXWaAMUrNwACfPTHC4xg?=
 =?us-ascii?Q?LedaaXWvt849gX7qGVhLDOW6kK8EAU7BKwaa+IgCuAVh2My91P1v1U6+T4Qt?=
 =?us-ascii?Q?S/lcEW84zPgPJfsT0o2yrmyFlrtAGk9VViffV9l5bICaEQ0bdF7nAHmgxBRf?=
 =?us-ascii?Q?4w1AoQWgmEsEByNaSxyn3KAFtG8rMU4ALikwUF9qgImg8FpLpdO9zi9+UiYR?=
 =?us-ascii?Q?asJKyx0OzNU/lT6soOMbo6Cp2egWQRz4tJ+EHgaqEuTMa2dIvO2N5c9gUyqo?=
 =?us-ascii?Q?ta5F42LIo0VKVQ05J5xBagZO1Vm/v1+kFL8GWKm2wCSic58UEb47285BPO5g?=
 =?us-ascii?Q?uh6637OUHlVbmOMgdDayzgFuqM0Mw03eH4gaxgDNvm7xd65+lIuvWoU56xjX?=
 =?us-ascii?Q?xsR0d89H+8Q9+a5799QdHx0xlzik/vAuILWq6okGfA0zuB+E+RCr6zeuCblF?=
 =?us-ascii?Q?ZZdv4lxL4CX1lBxy47GHIAl89SuiWPeihPy85QmCRncUAEJTUNBUkqJkrzOf?=
 =?us-ascii?Q?gTLg1ovOkNO233mpNAaqqwBemN35+Lofj20m7pzFN1Xnvby8Uh9UC4tLtD0v?=
 =?us-ascii?Q?6UQG0TdVqSHclylpYPmgfb9NGVWp//0vwTtynf3wlWq2r0Nhr40KJXT75Uvj?=
 =?us-ascii?Q?JhSbQ0AtmoOIRhpw/nLGtCwWOxkeuIUscy2v8sRpASBEcqBd0Xq5xgCKKf3X?=
 =?us-ascii?Q?m4Ewm17EgNfztTQE25oiRbKXUAhNSNPJJtTMawv2A6a0D2N5T3qYMUc6B7vx?=
 =?us-ascii?Q?qMZGjiWoel/zH6QwdaHts3v3XHJ9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?h7IFu0KW0E3mW/No7T7npIolN3AHiK9aYSUg2OOksJD1fVBBmzNlZlVhK5TG?=
 =?us-ascii?Q?tc75iC346dzsr/ZEvklGCeX1I/GNJjMfHy50vBCH2TFJx4Fd/pOh9bNiZ3gA?=
 =?us-ascii?Q?OYHL+YpQH/l9iouzSWcizstn0jGfLg5jC3/Hrgs8XOFC2sc2Ayi6Uht7LBBp?=
 =?us-ascii?Q?J2hiBFqg9Z19a8Nfxt2b3Pxe36sIbOI9FenoD3LIKkXgyrnW8IYs9EKcL/oo?=
 =?us-ascii?Q?Sz0CFhAkvxN1WdWzAjHC29xwtFJztlwKTElhBxWlmK1XsXu0b9rGhOG/cGuO?=
 =?us-ascii?Q?O+mrpFg/04nmOt137WxSzPyVs/s9NIYywtxXGJ1qpLTGT4bnW6Px9ufqv9Ee?=
 =?us-ascii?Q?+VyZz1L/RXje4R8iNGaUIgtWUvGGOk6tR+z33jT4B1yGk9jst8OKbQIIXgV+?=
 =?us-ascii?Q?85G43NOCjN0EMLcvN1UGebIeFr3iyShvbE5i7p74UjT/2ayj5+SPf1Knojmc?=
 =?us-ascii?Q?8GgN6PSRTH6rwpUbD740l5iP/HdpWo3j2wBNCSh6qRwELOHH1o08l+XZYBRA?=
 =?us-ascii?Q?AkO9d1GP9W5H+/l30CPC9L5J99wEntr2MQIi+GD4TfcOR6fuy4TkQ5RKMm/7?=
 =?us-ascii?Q?stUqjT0o1VwXkeGcl9Ny/KZKYnTN6FHhkuV2InZDHkvv3s63XGKpI3o0O94f?=
 =?us-ascii?Q?FXSYsp2t1jb54BF3SCGweHK/9A8j7Y5LoIk8cOhYOZXLMK3zIv3F8qPfTgy7?=
 =?us-ascii?Q?qFONoRkrlcsWE3StrIR0ts+pzBQn/KfKon5JgA5PXRlYmaDHiNxViAVTgvEj?=
 =?us-ascii?Q?5HLq36cnqhs9SVdriFxS1FDqXSjuUo74fWgkuaJ20Bzb6wLCZnxtuMOthNG5?=
 =?us-ascii?Q?scVAKleE+8gzy9WVd+PaFY1wDmKgE7rE6m5+9wuDZZc6Toy3o/R1z0lYRJRj?=
 =?us-ascii?Q?qG6p9Kj8cwRM6RFbVzQXJV6/PugX3PifhxxBaZy9aA/jUxtgvdinkc0jE01D?=
 =?us-ascii?Q?DfORsrrzIDK7a85Zq2o2JX4SBYKdyjd9WJXditnwMRYMBNEhph/9B2ZhowGZ?=
 =?us-ascii?Q?z8nm4duDJF30TlbjCHxXn0KmdGfNZD+psSPt2411tmmtlH7zUFpv9A0rG21e?=
 =?us-ascii?Q?E9iNxHO1b614IXohitSzcjru8oRCzG13NEClL3634L439aH6xjXHLgSJLWgN?=
 =?us-ascii?Q?H3F9CLn9WCVOEsWq1qoOJ3+akaHXNTPZG2BAXOOSF+c8GZ+X81/NY4ssdUk/?=
 =?us-ascii?Q?pB2I6kQnM51IYwoaDjcc8rIYyChDvsQv1SFFbvbbx4IemM6Z5eshIhZqZxZy?=
 =?us-ascii?Q?QcwjmxRlqBTF3khNg6olOFVH2sSXLhJDZ8cnqG4mV8XXMv9aL604cx/YBFjn?=
 =?us-ascii?Q?Z6b35kPQfzEui+zTzn5gsHxuap4kUg6jVb1+HI61zzjXpaoFkXKAmhQ19LPf?=
 =?us-ascii?Q?pwCxYH1UW84F7zB6R1S9eCqAJUmJYYycUXvolQRNQ+lNK7W5BFAVPgjpyJNa?=
 =?us-ascii?Q?Lkk7M6OMkYktMXjDQmm1UYLnIwL3J7Gcxbj7nJZOQEudteRdnsdMm4Lzl3Nt?=
 =?us-ascii?Q?f6obqmIsF0XdF29clrke3iVAKKXS5RBTa/tml9JEgrRWkSjY5dONypmv+Lk+?=
 =?us-ascii?Q?UphkNa+66G6QpspAvjcWPNiHy4cV2/11w33kqq6RDAfbaIxVI3Floe6BqbDW?=
 =?us-ascii?Q?zA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C9fxwPLukrlMJwkl7qQCkx/2vXB+KDatpIx+zzfoCAE4AJd9jyH1tfCaeKJooYIxWXTdtjtWemxPeo9apyd7tJu9YJVi+dqJSBF/5K+N1vDcA1uPfbV6jfK4Xks/allvLh1Au/U2jffIkF/yGHoSWVKxdeqnFZ7xjvvNKsiSko5v4v7i0trr5PgjfWmwSTw1yqbKHDmfucrCT48YRMDM5MM/7DzvN7a4OEpBGhK48d9mtsRUS5BbGvibto8XrzpFPsAISoV/3gyCFlQQQE9/8WFcuv0BW0vy2NOQst5NuWQP7Kmm2rykWVAbwwN8ZM9KH+dWxnMu8lPObUze4oaTnQtU0I6qVsCEhV3IAomxvTU/fc3gLyTEy23sqF0xqxswK3jMSZxgT+RCaO6Si7m6odEDk01IVg8IJWhX0PfoGMz8TOkJLmIRPvOs65Wid26km+3sYzazw0p4/jpCipY9mtPLocB+dkfTQPfNVeDrYcERUeLVT/ybPkawDiX3dHE6JUFPTfibWD1cjmnz6ELtZN0WrMcbzbqTD47ies8lCER9a7+fGDbn38qDpOrBYJPjGVC9MoZoqjHssLcTa9RGAd5vM+DTBkG81PUR+unpa2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a27a3f4-c757-486f-9ae5-08dd603c50b8
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 01:30:32.7082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FVGzj1x3m3g4rkgvjGfZvZ1tD07yenertDURtLoTG3hcKq+O4CXTjM5ArK2vYxwXllFb2Iv1x6FGGJbbKwnPvCSz7Gvd2d/Vcp6SnvMSK+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7248
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 mlxlogscore=850 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110009
X-Proofpoint-ORIG-GUID: m_v6n04FDl4b-Bn5Pl1PpTxIDaDj2Ck4
X-Proofpoint-GUID: m_v6n04FDl4b-Bn5Pl1PpTxIDaDj2Ck4


Chandrakanth,

> Task Abort support is added to handle SCSI command timeouts, ensuring
> recovery and cleanup of timed-out commands. This completes the error
> handling framework for mpi3mr driver, which already includes device
> reset, target reset, bus reset, and host reset.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
