Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6502779EA
	for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2025 02:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753756418; cv=fail; b=gBpDfTx0sZcpsww+s4UV0EDzkYuO8sSRR8iOuzFcRRToxJwTleGVnGHl1eb0GPrB2XzUEUmjTTP+4BvK2B6P/JqnxCajYfxZIc8PTnWBcj8w5E6XeoKH/DhCZm+N2UUqGNM9+OZTx7pZYkOUgMHszjj6V9DuAh7NmjGLuUlD+iw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753756418; c=relaxed/simple;
	bh=r5nXFalYtLweNnzFj4XlH+GEffseuN2q+dt2z3u7Fc4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=cmm3PrPpqSaauz3pL5dibWn6NAvie6G2WBJ9M2okaApgcC4w+zTHZWR6XS/lJYRaMr105jkAZoSoWl1s0U6Of/jDJZRwlUtWler74y1/N9p/4Stawg1WUtCpbqd2MVr2kX0aTjDrRos2DREnU2iOLpPPCuJ+EytX9g/fRvAFYuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gxvs3Sqw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hjFjTJgP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gxvs3Sqw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hjFjTJgP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SLfpPO002446;
	Tue, 29 Jul 2025 02:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wTQ9uHCqIAotFV6i9o
	psghPilcPv82p0ugF1mItdJ3A=; b=gxvs3SqwlUWilu90TPCJKYVW+8y8Sk17X5
	l5LcXYQnH/ZhXR1jHIz3oiUtBX7Sj/Hb9J9XJR+xIGIsyr0nDOcamu3sVZzDMEHv
	PJWfoxlB2skhRE5MrWvAFKq/nqitWB8Uksi/5TK7TKrbVSkc4I1NgWmVN2nLqems
	GdAIuEwMyyZi/LT1TbPWxcL6TkxeuJMC330YKSatWACRS5TvestjdgrTo5LjwfIm
	s8wUjHEJRn8hhN8E8HHDu+U8vYl6C948b7JbbXJgTVSdQrIG15Pi+OfSXiK430vM
	XJXUSFQr+8jTeBeb7Gk5fPTe9xUThGVZgauL8TaGVjCf0KJPXg+A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q72xrkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 02:33:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56T2AEus038709;
	Tue, 29 Jul 2025 02:33:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nf93n5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 02:33:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xGv24ZYxz2jB/t8wSSj91hbvVY9xoJDUsxJLcHxLdxdjpwcyw+v/JazmcXRbojE0+0SSJ3Yp+rVXV6GMdf2wyG81man+a6VZ27DOqOkZV3Gxicx6OY0/m3qG2KaOclXav6CMQ8jf0c6U+5t09NH1LKKqSpcO2nCGbCW2DFlSBv2DdAPe9MITiYDIdMWLEjcEhvId20yTiX3d+sNNVgRwPBImrAPHZw55jUtZdrpl1WbKOuywIMtWpxGpNfhcPhSmJiUkHv0CjAnlLxq3Ycjsfugp3SicXpw1wX96XIP7iBSpoq3nlRCBjhXChyCqTtZI4K8R8lNmltdlIy8RWQ8a2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTQ9uHCqIAotFV6i9opsghPilcPv82p0ugF1mItdJ3A=;
 b=cB030HuQ/W65JWuVDsRlzfueyBwCi38tb9onLuVGAN0WhvzwB7WeBhiMjhXhzlir8E/r9WyWVkesxN8klul+ntrC1d8kFkc8QvJWdIYfsAGSMflvp3O0jHD9GagmAvlsdXLm1ttXudfMuG5Fdnglz39Id3LkS4wA6f3iL7pW4defRzPOu2+IqKn4VootyBsMpMsY1P1G9rILty3wAGw3EqBlRJY7YvD9GXNjuaxfb/j+ORGiheAqo7q4FFrKvr+SSXo159s0aIVSemXvV0TkeavVWYEDG4CmQuGR1pnTRCG1i7mvxVzAc8F1p0F86hfZr//2n8t1cjUNG3UxR1ENag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTQ9uHCqIAotFV6i9opsghPilcPv82p0ugF1mItdJ3A=;
 b=hjFjTJgPH5fLNfAZVxOZ4nL1VEtosQxAdSg4PdNBNJ0JWUfyJfN9vwLSqFmFwoe/fjsoCk6ZvkZgrPHNcXrAGwEw0ochx1vWcTIJfWvnv73TcWpc/3drnzkAn6nh01gwueBvz+8hfKqRTPNCHEZgf8DjMb+GV8sV5kT8LVGrssg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB6036.namprd10.prod.outlook.com (2603:10b6:510:1fc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Tue, 29 Jul
 2025 02:33:21 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 02:33:20 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Correct sysfs attributes access rights
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250728041700.76660-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Mon, 28 Jul 2025 13:17:00 +0900")
Organization: Oracle Corporation
Message-ID: <yq1seifn2u8.fsf@ca-mkp.ca.oracle.com>
References: <20250728041700.76660-1-dlemoal@kernel.org>
Date: Mon, 28 Jul 2025 22:33:18 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8P223CA0027.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::22) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB6036:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ccfb790-03c5-42c9-b262-08ddce484864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xwuWZ24fqMLoReQMaFM8Hf3NXEPwBXu72rMZRO302BV2M106kDdTXzUeFqhE?=
 =?us-ascii?Q?2D4uR5gzQ18BE2IxLtvFW3eWoXVvxuvlvCbkKhmswlClgSUi7oqU37Cz0RZm?=
 =?us-ascii?Q?GRdLr+hCN4FfXFDqwTVYZJOlitz6fFZ/rqLM2qMPwn6+n8+wLkM8IEwWVP1t?=
 =?us-ascii?Q?I3bDlyDbIxcRwnBIUjbF1okjX0n2gbsA0bn7NUTx5UJ9Or9mNQbjxG9I2CHg?=
 =?us-ascii?Q?bvnhV3Ao1MPIYrskjvbnS994ORBMiGXqJkh9QTmWm/lhBXzaWKh+WWEXYrMF?=
 =?us-ascii?Q?gAlJPEpxMEmWaSH1LeLyM2fPSBRmoJPDBwSrwMJ5w9tHqHDvIyVpG6z0j8QB?=
 =?us-ascii?Q?4BLHbEwSPjtB0uyko5VDXk0Z9ReaCvm3JtT6rUKL1rzMzmcK/ncTJ0Mva3Y7?=
 =?us-ascii?Q?aGHGXIhc1UXe+SsjQeJq82hhM27vd4F8S0j3Qh4Y6tvdCSnc/CErmbcHiPWt?=
 =?us-ascii?Q?EqCgW8zP8L7Q4YE6Hnoiwts8FNtvp27K97yMkcKPg/ZS5+cHuvvbhJN6aIgq?=
 =?us-ascii?Q?+pPQzshb7CxSRQ+VWlFxPcUhQTUcchaFkZzbZMmghNvUNvqolVV6HfeXSEzE?=
 =?us-ascii?Q?P8xcvNm8tG/krhmprOh5tPOPfzsrb66D+c2aEpYKw1vU4CNLpNK6ppEB8fzE?=
 =?us-ascii?Q?3km91GCGN7IgdM4yyF7nXXENvrRYc/3fKA9sz9eJ3hLr8yQnb2w1GdtJb6/k?=
 =?us-ascii?Q?rqIG0D5YBQkYWTj5V6m694QX+PwqBoF/aKzLruH46y4r7r0UompIOIhHhXMi?=
 =?us-ascii?Q?0kla3zvnNo/APIiF5jzDalwQv7/+TlRAorrlRRE192AM7XzEVMC8zznFnw2o?=
 =?us-ascii?Q?EJ9da0T0ztJzBOQZytV/Zg23i1NzoJVrfYLvSv7zaUpolQg+LwEIaSdird8x?=
 =?us-ascii?Q?LD/6jN1ahTU8w6TvwmKVwk9snsr9pGp7GLgldSIF+0fEFyUfXuqLYIIYq5xZ?=
 =?us-ascii?Q?jfTPOVvd++3BFhAZPIRRZBsFKfGFLXqCiJwJCkoYl9Sj6n1WJ6r/uLspfw0b?=
 =?us-ascii?Q?BQyvXCf4mnNVdZLsFyOSsR+gD9F/IBWTZwgRMOhI3msJ/JlEt8CKVmqVrV7s?=
 =?us-ascii?Q?MDohNUG4axDtRLSIjdWpE8OJwhZ3nLGVNszY8LxbRWyrQTpylgAhwPE7I8NQ?=
 =?us-ascii?Q?krYVjkYMUKSUEZHnOtNL1VoWq6RCDV0LDqE2945S7dfeskGEZ0y/OYCzQow/?=
 =?us-ascii?Q?IsRxx8g9tnzRUYSD2ipcsGaPefUzrTgltjoWpfVpKsZOREre4+RB2H8wWyIP?=
 =?us-ascii?Q?Q9Wp8klGQS6d7XFsAvcj3X+cI7+l+d/+CAes90iHysUfWft2EfcafL1IXEAO?=
 =?us-ascii?Q?7j7Y2+3BvGP56F4ALAv7xAIVn1MuZo+dV7vybRYMK0707846LqvBrKOVRoX/?=
 =?us-ascii?Q?KA0RYdQsITN+45SfBcIoBEd+sKdpkClN6c4A7x96p/PUBTXeggWLyoza9Udp?=
 =?us-ascii?Q?bfs6kjTRKqc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+Udc4KP4Yi701A9cJIiWTQtZ7yxB/fZQ3I/JKeHSY+KjKdcqDOa4AI8FtP0a?=
 =?us-ascii?Q?nalXHROZcbSvJOItsy+QZGdwSOJMy8bQ4jBIqqIGCQgnp0reyNImcfmNYuux?=
 =?us-ascii?Q?Pfah8+Gy5Q/4DE+amo0IrA8YDF8hoCmZu1VdYLCw2ihAlDpdcxp7MM4fAOIs?=
 =?us-ascii?Q?NnsV9fOaQR+r4u5FPOHjbtgnFERV5HehYkpHlSHaBSBxYMERwj1w3BR8qfPx?=
 =?us-ascii?Q?BTLnMHPwbDZmJ8X6w1mAW5sJv7KLBQqM/YCA5dymI4n0NG8FtisOK9JeDNFt?=
 =?us-ascii?Q?aTPNbjNhu7zdG2aP/FazEmJpwyOyVORAYXwvIcOP9caATrytYw9qbOYgF3p5?=
 =?us-ascii?Q?xxk7Nyf7vJN5zoQlL08EzJdSHNnPPvTDMyA9yQ36R1hUGI2SjJZ6U22otMUn?=
 =?us-ascii?Q?XCvkSBRFq6BSzADaApTi1c1Lb8nGOYFFtMC5fLAYjNPaAgyfqWxLZWZ4mYsw?=
 =?us-ascii?Q?2FJ6MhYnc4HmP6KRhFNswfgToPUO6ERoF3noFj5oLZiOGTDdNDJWguP1L5Ov?=
 =?us-ascii?Q?sOTtzLov4elFmc9Bk/JhjaRJlWTj1WCHukY9FMm+UkN5i7NgVi2etdWD3SC4?=
 =?us-ascii?Q?ibWUIH/W3OwEzD2aMbVZFsybM1EvLhjf0uFBXXeCZ4qOpdrywhoerpHTQbH6?=
 =?us-ascii?Q?M2h1fr/f7220Wv+nExI4uzZScG89pdBM1GVNalNC/s/IGiOtmVkURCVD8n00?=
 =?us-ascii?Q?NRzAWBN2FW6EjXecp6ecSau7qxkeBt9CEHD36HuiRJwOIj/nTv7SLnDXsksk?=
 =?us-ascii?Q?/ybFXJcT1i1DVVZO+29D6C/SGj3DLUOTwUXKV2HX18msfBRh5uEIiIID2cKM?=
 =?us-ascii?Q?YoPYEhfiCZ1Xi+HSfd0+i29oqDBd142nOKYkTD3B8t36USN8aw6YWj7cOVPs?=
 =?us-ascii?Q?XvkbN9d3oQMqEvzWvj9QmQSilPbpa8b0meh2vJw2Pa+aUoXiNfQrRcRCCsoR?=
 =?us-ascii?Q?XsbEfPQ+567420ZbKHziH/oZdreIf750gsVu2LFNptQeC3zosMQJ/E2/wSiT?=
 =?us-ascii?Q?QDyLu79XJonyvblj+zEGiNLMEwB6EhZTH0EB6xgqR/N2V0G990pGozfWo7mf?=
 =?us-ascii?Q?jAYa9CNWstPBOvigqgCXvBuD4rtB85nHZwjJyRvXpDnzCoxK/EKjDzpfMMLi?=
 =?us-ascii?Q?tBh+uqVV8q88MxVasMe/59DkprwR5NnW2BT/KurLhK0vI2PD98LcI0zn81Md?=
 =?us-ascii?Q?pB19kvCK1tqGSDLA4NvkEykuLJ3zBa3F2EyGhKay4p0T0G11ZXQIDlA1LTvr?=
 =?us-ascii?Q?tsYEC1yQbkr14+ZChGl4dJLLYYayO0Xudj1nltMh8E3IgO2wkvl2xCF3ctjo?=
 =?us-ascii?Q?jaTGHqv3o9JepN12OCNMJuzT7rbgrUMIPdBlaoKN3AYWY06PPzu8IYH/ZBdT?=
 =?us-ascii?Q?PqlvANCHMcZnkur1AGSllK5MOvVNMoXZ0cUpam7RORvNC+pM4AIWKsFl/Tx2?=
 =?us-ascii?Q?37ioZI/aBO3TsG72hfx/iZZDFbca2v/CmBSSYWQjzqQ5s06WkXTR9J+Kxgou?=
 =?us-ascii?Q?2eCKoKGYBu0ATXS3pH3gJ3e1jIbSBDP7kshjNEoVYPZEf/lTdM/zaWABTg0a?=
 =?us-ascii?Q?H/OyjaRJxcZYn8Pt5XGYg179wfIiGUbypotNUyNR3HiSZCdZGAP8Pn+QYjwQ?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	51qzm5MklKn1L1KRDdDypfuAQOTKZqB5ZTMZaQeUJUKnKo33ehYqnjEvq2L7pWqqg33AmLXAodnrGWbEDZNcszOqTuPBTeY2jfWOXGlGZ7DnrvLQFhU5K5FRYXfaJGD1Hc9NjuGfctq2MuQIicHldkjiU2pfWTJtFEQFYboH4TVXTLwbBDBBpm7hCHlbItYqNnlcZIsnRA5q6JtO93vbtPfrJ1NHXCq74CLtBBBQL6lWv/tRQUVZlAfH/ToGB6iNwtGEyL5WcBoznrdjKUhyvY4nWVpVFEKVQ0oaRj6Kf7VKPJ1+N+KYx+xQ4VF6hsaTp3M1pE7vcEl4M0xgixBdiXNXd+V2f04jzdlj0WBRFGymFYd1N57pk/SqMvRoVU6Q7qgdqkEAtsRSBef0DHhV5oVqmz2qT55k23BGHf+NzJgqYGSVltxIWwcQuXoZamNz6aRTjfCrFdj0lwHZwQdVoOXyUMuov2MzaMuuA+F9WWwDfgsHLTW5lwdu3kwEANyscUOClWdj0Ky+kDAoEISarMrkMAmWNXDFxqZlqD3cNxKWhPGph3xJ+/kk7xOgjRb4KkZu877zYp2zmYG3UaDhPm2+6L1HL6Qe0UNd+xogvd0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ccfb790-03c5-42c9-b262-08ddce484864
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 02:33:20.6080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pdN57W1SpyDs90d5z3hbn+1JisUtj/dw5xo8NbAun8Rju3TUZb1o/XM99Jqm/nos7nolnjyVVXew6trjMvNCDUacrg7J9IEuQNsM4JIN6E8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6036
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-28_05,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=925 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507290018
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAxOCBTYWx0ZWRfX414w+8bZTSRX
 4QsCEUD21bbS9bIeJWQHrxP1kCxzTJen4LniCk/V5ZnVW7E2y8qHWatntK3D9JThsbNrDpEB5eK
 d3tG+4yExD5A/4eHlXr20+MSE506y1AKbBaEJqBOGF5mjunVs62JZnNQbukeQwT5zD3VyaCztg0
 FOGqnhwT96EHIQCKmx0K4IsHOew9QdOqu8fOWLuIlySGi1L7VzQSgK8p0V1r9n2fDGXrydSMTc4
 vK88zME4SvX+9JGgF/Ji9mh2euFpyd4Sz9l2CzQGuszStDYF3WkHmoqeC71RJ1Qc5AV3BcdueKO
 /AjOJXjBkes2svcs/rLXpaQH5X9vEe2jUkP9vAz0an2Tvq9chlE8tiGnITZIX56FSSX3uNQgpRk
 /0ehSvSOIazJy47xJ6fx59tKR/mw7qxxjJdSzedxJBX1XY5941eX2tBsTifte54zPKTNK1Zr
X-Authority-Analysis: v=2.4 cv=ZO3XmW7b c=1 sm=1 tr=0 ts=688832fd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=0ukT8vsd8pv8HR2t59AA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: 3WT7PKvxlTydvwRRj4v_LFTewD3od3m5
X-Proofpoint-ORIG-GUID: 3WT7PKvxlTydvwRRj4v_LFTewD3od3m5


Damien,

> The scsi sysfs attributes "supported_mode" and "active_mode" do not
> define a store method and thus cannot be modified. Correct the
> DEVICE_ATTR() call for these two attributes to not include S_IWUSR to
> allow write access as they are read-only.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
