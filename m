Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486F91C32;
	Sat, 17 Aug 2024 01:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723856882; cv=fail; b=UB+5sXG7+BhrKLOknfnoKb8223hTv+2PBRMbBRnwVGhMHEwV992aQQJhl73N4xoXkWlcadcZSAqKLEMwFBIFbbFHMwdeP79lrnr8Ex3Nia0Sqw/0kqAuqe3yB0z0OO/YgmIqRDOwI+Wsdiyg5aYEEcj8kxguYqhThyRrodguWwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723856882; c=relaxed/simple;
	bh=2vasomAcjflgrSqwzIfWfmGCAwHio/KvsE99knCoyus=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=kpDy8vg2sqnX+342FrOaxVngRBBHgdkXcjVvklxtkeoUYIUCVSR+z5ebimVtCtFdAnukkCcC9vLakxB/QDYCihDNCtMN6sUGiq23jxpe8oDLSl7lClyY7jdDE047bGD0WrksOBkJ0jveesqvmZgshDbJrK7qdUyX/Yt2nDNzQac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PRQfctLC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZA5gGboz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PRQfctLC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZA5gGboz"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLBv61031724;
	Sat, 17 Aug 2024 01:07:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=z1NyRogKVHR1UI
	OeMRsNsAJ9l31pqLn/OCwuu8dh6WY=; b=PRQfctLCuPzhVAVqZg6nMsA3INitdD
	LJJJDH6+dZF0+DBvldY418rTjKP65YzIXAN/ibcfhsAx63EDtJvK+XUqRlm0Fwms
	xIqyXhk/D0zBYrOYcMTYYrVakyRb5yevKn6THCHcSUvAsj12pcnaaArtLUmGBXla
	LYdTJcpKfpJu8ww7OHcAfItVSKLpuYg/jnKv7ctCQNxKs74IIkab3IQfdXPhi/jG
	F8m5K28LZpxj0lwWQB+8g8tCVekWmXwZctVWaeRIE+CSeMrXoIg6czI7RX/uuibX
	mFQuvshwdQ8HxArbH3f/KgXmid71Tj/uuHIpzjKcvQEU80OqA9wDXR2Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy035xfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:07:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47H107J7000747;
	Sat, 17 Aug 2024 01:07:47 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxncvtmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:07:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GJQ28rMyQdqshr7tMYLVdma/2BVmZQaLNjLf+qXKIF8fAkYqNU1LqY5+8suigzSF/4a3QaklbJEnR98VUvD1CZTyqIP5kP2qV9uTW2gHFkPeD2aHLwN32/9+2PRC/QXxx8IiKb9vib9KmHFo4u33gQYTqYRkUYHS34hDAHYPvjPnQ40eGPGGBpDWUny0ROrc50DJZ058x6KZ7GvhdLc42oP/q6kfyBrO4trz82dUxAXalVDxwKyttE1D57PwXJo6AAUAdRVumEftJ4M6zLQKn1Ovnr/DVyEMscASMM0j0SIqRQX6FH/UC21LfznuuiXx10mdzwRmmYFTvre8zGcyRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z1NyRogKVHR1UIOeMRsNsAJ9l31pqLn/OCwuu8dh6WY=;
 b=m6FsJCT5FpI+OxN5IMkaVmqEOyombR+NQk3hwnHg9RD0WBq6NisRGptNKAeihiF2/+rM11dbDX3vDEVFEkcTfx71tnEXjjMCFE79beykzTlhRBkHQyBnPFf+F+FIgED8YH0eQoybOdRtFVENPNssnfnUz2WQOI9qkG9TQ1ySLDC00Pb09ZEXCWnanpu4f4Ofq798RiHbtQEgxw7ZuleLKxLc6gfuwSli3+JQaIJF95+C9akphBY/BEOSlKWthaEsW1zHBHdoAQ00Rmcg0gxyb4qdfsHNm58kSwhNBS6zCOORLX7S9307+1VNNF8hT8buHA8c5cHZJ172rljUqz86dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z1NyRogKVHR1UIOeMRsNsAJ9l31pqLn/OCwuu8dh6WY=;
 b=ZA5gGbozoEwdAsA0v9f1UZTgj0Sy1E1pRGxGJ+EnmYbDSvI30cISGQZMFuI0Ycti7uWnq1F0Md/+sXg3y5X65lN586jfTdJdNShM8+rxU4K8XZ+QFboKOAdYsf57emoUsfEA1mpHCYQhk2xFllsbryq85avhLa9CHZ/5hd+oWLw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB6843.namprd10.prod.outlook.com (2603:10b6:208:435::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.9; Sat, 17 Aug
 2024 01:07:45 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7897.009; Sat, 17 Aug 2024
 01:07:45 +0000
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
        "James E.J. Bottomley"
 <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Manivannan Sadhasivam
 <manivannan.sadhasivam@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Brian Masney
 <bmasney@redhat.com>,
        Nitin Rawat <quic_nitirawa@quicinc.com>,
        Can Guo
 <quic_cang@quicinc.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufshcd-pltfrm: Signedness bug in
 ufshcd_parse_clock_info()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <404a4727-89c6-410b-9ece-301fa399d4db@stanley.mountain> (Dan
	Carpenter's message of "Thu, 15 Aug 2024 14:24:36 +0300")
Organization: Oracle Corporation
Message-ID: <yq1jzggot2f.fsf@ca-mkp.ca.oracle.com>
References: <404a4727-89c6-410b-9ece-301fa399d4db@stanley.mountain>
Date: Fri, 16 Aug 2024 21:07:42 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB6843:EE_
X-MS-Office365-Filtering-Correlation-Id: 26027a46-a05a-4d13-cf92-08dcbe590084
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7Jt8ISfCdYQrLGrh1UmPXyZoSTZvPStFeXVcAW4wYN+HQmyQInj4bNjeHb9/?=
 =?us-ascii?Q?lKpzOnfuDMHRkE8L+wj2abSQQmir+bfXeNz0l1DZIdJLIAICNZM4XYQCEltW?=
 =?us-ascii?Q?k+g7T8Zvq41b1ObvYUbGxh1lHl5HCPHEyEM4kMdpR+Iv3hhMrddl+HcS0dT6?=
 =?us-ascii?Q?5VQncz4H4N4ZxFWrMc2Qa0KG7tHL2J65jK1VVjvjNur5RN5MyHgxqiwQVddY?=
 =?us-ascii?Q?9+ik/CpI7sZTOStnz1DzGt3d4jY0suSexENPAIzn4Jor2hy4MUoGHo6WSaE4?=
 =?us-ascii?Q?sIWqaGeCK2ANURkbfiZod0zvHG9Uel2MaZ4gtm+mDc7dsYorXpdOynjfrAQp?=
 =?us-ascii?Q?XsWrRGaGwq2Wf3XR0XcB10Xx7Jg5gYwS7nGO2DWz/4I/4ZPYrNq98yueOYRQ?=
 =?us-ascii?Q?QaWolI3xn8wJR7IXgTyRDsoMC5uuO5cS03l5qTkN7QWfA6XvIlRZFmkgtzUb?=
 =?us-ascii?Q?oZ5rnWwOMLHXBW+yfewcNVDgL65Nm7U+GVqqoEO9wNbqSZEAZvf4lJU99Q17?=
 =?us-ascii?Q?hOYZOdIjgcSFQomMoINPVRRDfy/DkoRUfj9JfJ1ZJGaY4WaJWLdVbrfUqYJQ?=
 =?us-ascii?Q?Jdee85ghOK/AZNUJ9cDXKzE1G7hRTzOabVDfJRkyWef1xl7Bdtg8dEUK0Bil?=
 =?us-ascii?Q?tZog7M9dMw5u7LolXn4/DRuupfZFW5CvpSfc7AxIm6R+6bkC0NizdbDG+AAg?=
 =?us-ascii?Q?EypVW61a1WfzzC7kQ6AEXUdZc6iMNR8SKenfoQusieyP0meoIRGj64qkKNO5?=
 =?us-ascii?Q?jc01ifhT4PRZ6ycM2dOdFrb0mX3AuCuDTNLge4o3ioGBC7MwuarEZSQ/FTN4?=
 =?us-ascii?Q?YYvC3xG2K5Sh5hGNtC30n+8Yl3geA9MiKHN+ouBn2gvrv9nglRn7X1e9mFeS?=
 =?us-ascii?Q?Uq+IsLFKBeB/dND12VifkDVnpNQXfcOZ2XSi++jABHGwtyU5+QbiWMVotkJU?=
 =?us-ascii?Q?NOPBoNbsW4s5TKxujOebJsVVHcctrmjNHAEAHw3dHSHwXrUcQtWQwe1xCp6Z?=
 =?us-ascii?Q?2QPI8Nt+SbeDF59LQn5dJ0cCt+hD5g+4xS9yCoYLt/JMGyBZBTREWbIESwxT?=
 =?us-ascii?Q?a9WZMbLU5ZvmZzrihq36ImLUmuxO2Vt4Xi263n0hNABaljmYDaTdBlNx0g5L?=
 =?us-ascii?Q?YOTwzdSvg2ecSZIdJHJm/JyUWiCuRmlVhaPHv0qPd2zDFLVMyE64FyvoPDN+?=
 =?us-ascii?Q?r3teTHUzS91eiVtQMB+1cPHKy6L2F4s1qjA/PZTltUO6uiSDGQ8DI7PStQoG?=
 =?us-ascii?Q?Ar6R9+98aYYVvHlsdHDXtIRucJ2BJcTzvy68VbEzm9sBjNZmnoXPr7b7KsM2?=
 =?us-ascii?Q?W1KM0kjekeAD4FvGM/n1PRUOTEF2abH+u5dn11PrqOJkXw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k3gPF+H5G8Bw6F29keTgn6BCweR1zsIFqHTXpyQftBWSOY8Bsm+pJ00Tgh7c?=
 =?us-ascii?Q?0gvlqhmn1+l8sEIlqe7vQaGd4UzSNQZznEv8SZDu0XaCBSmRadwAeck3FDo3?=
 =?us-ascii?Q?aOHMNU9ynEST0IJmqgqK3XS8rFPmsTNTm5pmifBJAMT+sLZeKfOgXaxJYIpq?=
 =?us-ascii?Q?xAV4pQ0VsW5LL2hZt+N1f+coCpJHS948nNdE4E/5NorlKCTCJ7mtDHUCvLlV?=
 =?us-ascii?Q?LeNQeqCJvGa5o3+93jawrv0RyaeGVdtFrP8O/JkmUu1VqkKfJq7603Gvlk/h?=
 =?us-ascii?Q?+4fKh1R14xDB/+TDBvYn7uUzvxe55LT9CQ4JP/mNYhOmSzOt9T/mj169QA6O?=
 =?us-ascii?Q?XdgC+hT52jt1IEoBcWRzaGNKdZa4znrh8cw8TvNzZxM4iUBuTC1gmrjlOeRp?=
 =?us-ascii?Q?xy/73m7tLGSxHQ6+oTODUYHSfdkY2yOYxPmFFmLbUVOzwJ/YTE/fWETwI8Z0?=
 =?us-ascii?Q?8lovVLMRnPtCbfVdg5ErZGsxce4SGOvjqRsQgiyo8JsHxgUxJJm4v7a5x3dr?=
 =?us-ascii?Q?r0ZnkVtyoE62xjNvWUujuDVU3rbAZSK2grz6BWVwPwQGArRNp4LofqIDpcA5?=
 =?us-ascii?Q?+6AsI97lWHQOCseDGXJPK1eSnssGs2Wo0NyC3YJRWq1TKhg3RAf8ex2Wk3WC?=
 =?us-ascii?Q?PNjO34wWlsWKoNKX75zbphdXIB27dDFBW11U9DIcrxF/3LK8hGURcYhUgRc5?=
 =?us-ascii?Q?3/DFRg7dfuaSShbwLjt9ZVgk/NZUHOAk5fogtJ7+ZBp38mpWC2HuMAr9elwM?=
 =?us-ascii?Q?n637o6xGiAfeoZOrQkvmfYcwoUFHc3biKLreyysXqjNM7XTGZbQgyjF0Tcs8?=
 =?us-ascii?Q?T/8PJwzJpOMyw7mNd2bmu83BIznYTtpmwVYH+AHAsuXSI9hAlprrR2D8ZyPS?=
 =?us-ascii?Q?9VEHnBW7pF13CtOsiro8DYHuPt6j3I1KMUWEEZy/bDY6USQEzLVa5DVHBlO2?=
 =?us-ascii?Q?Ttrc/xHI34g/RAmQlbidsxJl2Q/5m+56/LOAbIzOI7XzmqRWQ6GZxlOF2Bfw?=
 =?us-ascii?Q?vGTq3ISF3VNghxXp8wd7qxpUlbV/HUY4gOoD0CGx6MCLxNHfcF8EVdqAyH8V?=
 =?us-ascii?Q?3vMZyDBethIAu2gpPK2jq+A1iNbCHiL4rl4/YJTRS4lkydlk6PCagQ4R5/oi?=
 =?us-ascii?Q?qKBGY9gnNMnnZ6K0VXa3q2nxC9uNvOVAErrsNTTN/Ql5VtrZe4kaOhtwrG+I?=
 =?us-ascii?Q?oa924lPTrMXbuJi7MLjLNIJxlgPnrL4/B4Xb8Lfg6xujp/QuXUi20bj6Ogmt?=
 =?us-ascii?Q?6yoUhndPrPAeOuFmj3C+bkOhqZwL7XXOzmsPqzSEow3SCgS83LiX+NfPoNmo?=
 =?us-ascii?Q?QHFuQ5V70SW+5ZQDNYZzpDHKHGNgUBCR5hrwMRaoaOzkd0PhSf3WmhCHM1Eo?=
 =?us-ascii?Q?duoz/HUxA8gRt+WOvqOgMwnYGRwyGc8NrUazx9muFn7AX7cGKfU/Aq+9fhEk?=
 =?us-ascii?Q?A/HoZPOi3OqYhs0kjZB3gkkkhn6whR50oC3Bk8Rx9v0qUMLYUENSh/LeQ/Cc?=
 =?us-ascii?Q?7cGMTepjFRiKpgqNmvD9FfU9sdUNuYfiw6Il8lP/pX8ibp3OX2esg55LiZmj?=
 =?us-ascii?Q?kYBhRyRa84+UkKKrgu4MSkIwDrFw8NNZNaa45kG3OZWRAfuf26EU60pcdBZe?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yaIAen2NfjzuCRE/8RiH4rKU2XKO/KjMq7iN6viWWhoKAjt59y0V3NFkqc2e8MGpJf4nsB8TFr/FE8p4nviDVAVkn7tLkq+9yFI2/rQUk6jB62b4tELqQXdzWL/FdJvjTBnZ54lmlRiOfDROaufVO9t/5SyLxFs4OInwN1fqrsMhB+A5SRT9rApjup12OjEeGShy44XOPHhXtv7e+WfQdDU/xz04DLAUuI2+4lpZRPpMC+KnNPYI1A6duRFCALcCvuq3ppLlBRq4YGJp7hZ/Q+w1/3luc6j2UpLDIz6zS+XjdNA7hGs9Yw6gWQXIhWkS4ooT9SQBIDStRv5HCoBkKTbOzuT2wKJ2jQXzcw2cLm0KmlmBSSA1ZlH2t4YXEy0pbRRFMg8FljRXCArdxW+NDN4X+6wqyZnpKNEXmt45xlqHdM8gPl4Sxpz/6BNz/qicInH+3oYCVFMwb5t5qTbQFm9XjdnpwtPXGMe1YuwqvvoD6ATnd+YEkulZI9jZ4BCu2juAuG2oxTaPIwGoPCChz2jJXr8F3aAL+zCBswI+BCIxPtelCh2DrvLCrp5HWeTVL+KnEdUFUspNfTuOJvR3EFQbHZv+dlI2HPxeb8lBJU4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26027a46-a05a-4d13-cf92-08dcbe590084
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2024 01:07:45.0722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jROlJG6aJYiUms1ittYz6Z4YcIy435D2nvAgqz81xFGJVaTE2CdClB3iJyOAu2+KR3bzTuQiUtKmRxhM8faP6ZyjB3UJN366K5zXQHUZsro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-16_18,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=990 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408170006
X-Proofpoint-GUID: Yp8BFlFWUxTzfOrnqohkaRf7IcHALiEu
X-Proofpoint-ORIG-GUID: Yp8BFlFWUxTzfOrnqohkaRf7IcHALiEu


Dan,

> The "sz" variable needs to be a signed type for the error handling to
> work as intended. Fortunately, there is some sanity checking on "sz"
> on the next line, so negative values would be caught and it doesn't
> really affect runtime.

Applied to 6.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
