Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3298417BED2;
	Tue,  3 Sep 2024 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725376129; cv=fail; b=JfsHoDgU14O2SVDKdaSjN3qYskUTsf87ERplSyo9Nr5PEwFtwpolRf3qlPMiCxIRoVCNf70AWYw7Jqi+iLLA/mB5yWeJ5iNzWpP3dOdUDlREimHmelQdHYfF0FZQsFEEuXLI4+K53uFq4Kdnl+tW2ICgbm0wYxo2KNsScXrQ8fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725376129; c=relaxed/simple;
	bh=5d6UTCo/dvSVqS4AveHWhT5Y6r/yF3GCRdEl2EADCNo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=C0FTJV1EyozhKwmd4Vc5u3ExqeR28xlSM8/y8wpwbbzKYF7MxEr69pyrc8LpjfAPzangvn4VECR74oLHzMG6Hi/tQ5G4YcsDXEw760anOUwZGsCGJvQgeeL/qbLxsTABM+3StITG7Hk/FagKC0czfZxm6vGgdG7R5lhydX1/DZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jeVEOEpa; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t3EOAnxO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jeVEOEpa";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t3EOAnxO"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 483EpnXP019409;
	Tue, 3 Sep 2024 15:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=UthwDzQOFA6BxryT3tx6Ii3mvuOVPfZECAaSlktlY94=; b=
	jeVEOEpaNPD5vYnp5phJ1aOJenBTyWmlmIWZcvnMC1jSlBqHrOHDAF2HjDIaeu5P
	qnQQZ9nFV+Yi9yzH4oU1Nyu7m1srUK2LJJANLsbAfgWnv7OU7RgTExpIIbs5cMkA
	r8QC6VlcjWdAvJfgfM1nUgTdq+BnTdHX2/BPF1Zjv7f0uy1L8X4ixpschwsUSFbN
	IwqxmBXYKVsHYwCm3qT2Mdr3ApjzM9WqInR5UvFUokW2OqH3bt0vsUq/EM953r9R
	lZYIX3KqPZGS89bbYXOQh9tEtgEHcu7ogqKyyWXMVNxGCgg3TjK1xVZ7/mnpxung
	TzJATY4xyLC6YEE467M/Eg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41dvsa95wv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 15:08:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 483Esjlu032636;
	Tue, 3 Sep 2024 15:08:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41bsm9151j-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 15:08:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LY+mMCePdF/4EuxjEQvC5NmsjiG203UD8Tr5V+OsEc8HGxuD10Bre8MYR6CgMO3+rpbLuQSOKH1RIvTSo6ei3eXpSyjICTb9bUJzHTkImXd3iu4lmNVUZiCHe1EEpjjIhL7y7O/x4eY6rRVZ9e+3mHpycWmEb7tDaGLaCyTOoDCNx1He65lKEwU5wyV5NB90RVyFZVxBLtcI59sGiCZ7edagQBcGqjM3SG60IsLwerGA1ZOh3YPmHcNw/p0rDFhvPwMh+wz/hiwhTK4FHn2P7F06ypSa3oq7SFEOAPFTbDd6LfhcCJwXxMWSAMngUVn1OOdgXDMig3viM/y1CSlvkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UthwDzQOFA6BxryT3tx6Ii3mvuOVPfZECAaSlktlY94=;
 b=bakqoTKzXB8hdPlVS1tRq3uTieb7dSSSMwzfMyMVFZ67JQyWInSykpeRWDRVQE5maANp7B8pgaZZYiBy+dLHTUB1th/DJ43rht03EuUsnOWQR89/zKDSsy6fYyhoYUpth6450zL9Ximxbfz492Pju82IS4QD0uIwr520CYEN6tMQPM3+nAIUOiBaVwlHqF38XDbwy1hXGKNy3fG9ZnxGl/XzWYoSKaF4JJULZRNW/fLjdLaaIgBDt4Z+lf8vD3fi4tkoRO+qInznoMQ5P33XYLgV8AZUjLtlxRhN27jfYqDZiq5sfe4PQJvFfrd0+guFcLXrPECdogB8DJsD19opJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UthwDzQOFA6BxryT3tx6Ii3mvuOVPfZECAaSlktlY94=;
 b=t3EOAnxOXxY1wWvj0ZXmi42eBcw/wNKyJMJTeLPlOeGOHbG9jgB4sNaALXl7HMWi999SzpxlFSBFLOM/SDhVUU3AvG/WPJbxkjw3ij8BH9gkkVye4qzqGXQAMMrXaVaMpOSadaH/cQC13sOzR3P2eQpDKMFzbAEFPaGVGCoDXzg=
Received: from CH2PR10MB4312.namprd10.prod.outlook.com (2603:10b6:610:7b::9)
 by LV3PR10MB8105.namprd10.prod.outlook.com (2603:10b6:408:28d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 15:08:22 +0000
Received: from CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2]) by CH2PR10MB4312.namprd10.prod.outlook.com
 ([fe80::fd5e:682a:f1ac:d0a2%3]) with mapi id 15.20.7918.012; Tue, 3 Sep 2024
 15:08:22 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org,
        hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC 4/4] md/raid0: Atomic write support
Date: Tue,  3 Sep 2024 15:07:48 +0000
Message-Id: <20240903150748.2179966-5-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240903150748.2179966-1-john.g.garry@oracle.com>
References: <20240903150748.2179966-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0071.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::48) To CH2PR10MB4312.namprd10.prod.outlook.com
 (2603:10b6:610:7b::9)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR10MB4312:EE_|LV3PR10MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: 25b12fa5-5c30-4bb0-87b1-08dccc2a4051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T7XG+GTQdtv3aLUXKCotubq0FHpKjftdir2myHwraHua0aw6YY9lb5EYeFt9?=
 =?us-ascii?Q?wCBueuf9MPlCXKTnxIA4g2Gk6tSSHMsPW3ajm1m46E0atsEdy8Tb6gDwnFv7?=
 =?us-ascii?Q?zw0gCzTjVwihEH48vg1bxjofej27EUVhS5GOEqftYWymzUJaRJCPiEbKBDBV?=
 =?us-ascii?Q?ITmBf8LDto4CYLzYWOC//koMga/Qu9hRorZCOcsws4Zb8dLKgB2qLYar2va2?=
 =?us-ascii?Q?di17xcxSwN7nTGTmGXipLVgrlkPqh6ZGap8yF4V3XRpxe4afTh6kaZi2ZjOG?=
 =?us-ascii?Q?pIway0HD6Kn+zOoTEtkzP2ourd962O72az2ky533gK9cj6ye+uUUObJjOaR0?=
 =?us-ascii?Q?EFNkdHhac18s6YkSCh4BSILyJqOqjEWnX/xJfs727f+ZVi0zuKoDflaCXF3D?=
 =?us-ascii?Q?NTP6j7aR2LA/NiSdy/MyZpThwZLaAkLSxkkdvpDZgXG5k2kApbfgyv5L/1un?=
 =?us-ascii?Q?ZHOjBAK8NZr8yuq8vUoh41SkLzXTARHBjzL3GVG1WYQa6U+QBex6ivnxU835?=
 =?us-ascii?Q?BZXbkbKlbOqGUh1Yr9VYGSeCKdQCIg3ZC2sso9dUeUSwh+JaeTAAHpw9lo9l?=
 =?us-ascii?Q?jBpmes9qn7RQDfLcv/euLwWZwGm5szWset8zSOpChUZGZvKYRXlTd8eqXBFy?=
 =?us-ascii?Q?BZo3/DZ5JFMyh/p/711+LXB4Sck6ZF2WPdbpom1x1DqfH6a2cYVBkfRAlXkK?=
 =?us-ascii?Q?0aon/Qt3PELLfHXKZFnrRfaI9mUhIsKGfh2cQPU6E6tkYWF8EL4vazNH1WCp?=
 =?us-ascii?Q?JgQx8AuvDC6D8NH3DeBkyj6c2mlb/GDPjRjp23qjl0ashTL5EdnHDZylHW3W?=
 =?us-ascii?Q?rsaLNLGtiaRWk8vVtGktMWk2iJwD61DK2wQVyqKp5IykJAZYSdEkYcXVCmvq?=
 =?us-ascii?Q?kW1UMIEHLkkwucs2U5WAU5zJLHS2yh96gg+bPNbP26HhmYdrZ8w6H35tGLQE?=
 =?us-ascii?Q?opQEY9zSQyYk4xrZz8qPRCNoLkFPJV+5MuwfvGEWOjSP7F/0Y/M850aEHC/6?=
 =?us-ascii?Q?3sejAKu08fmWDbWy0/dHCEgrrfpxZKRI/m7ynxx4ORIuVFbbcJQIC6Tdnaa6?=
 =?us-ascii?Q?Z83fMbEP13PPqzV7rfxghbrSwDcl2gk+Vt7TRZPiRFzQUdG9mdbCB/zqch+p?=
 =?us-ascii?Q?NpDiBkJaBiYi9s0GHDmDIc3gXET5pIAVXmow1oYpj6WJUGwil+yp+eteCgI7?=
 =?us-ascii?Q?1P3hmS3H/YOByWSERoBPmrK+TAoxCzGyJFnilkH+43b0+3SntoNeNlplUNI0?=
 =?us-ascii?Q?jwTP1MkuznhDmb56PoMiUSPvXof2JQ/X5r7TDztEVgcQchgCqDCCczRoBxv6?=
 =?us-ascii?Q?/2lSLYtBByMPZ4zK8w/GCPxb2iQBG2dzvMEWY811ZcTC7A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4312.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TgvlS3KeerPbTUCidZNG6jI837+7rPBXhGfbBmvp4LP+SzD8DHCmBvTe8SJt?=
 =?us-ascii?Q?ISAnvftJbmPrzkqmku+nvd4JS5Sew7rFU6UZHd6DDxJKpe+3K9M6LMMbBU3U?=
 =?us-ascii?Q?CG4zQNpFS6PaW+dafW1wgXApY6EBRJdGesgerTun4hc6I9Gt/olk+bOAt4CE?=
 =?us-ascii?Q?PYZU8uemOQBgLYZCpFu1p/i1mgQj+lSz3RSC3tPQqfsuDmRBqAm+ISgp4OiC?=
 =?us-ascii?Q?8OtFvtfxjPNQVoPNNmVzv6l/kEU1CMxCFzF+mxfwYFhfrTeq4wVzUW/UhLy5?=
 =?us-ascii?Q?zqoItUnGfreuwGm4TXelcee53f/5Mgm5pu6Y2r1mrypkHRMjKupXvq+QedQK?=
 =?us-ascii?Q?Zv9FH0Ka2yMCaABkuBHozgZXnwL2HyUkhLjXjM7m/C9hivYx62O6jHAie/n4?=
 =?us-ascii?Q?QZ1eExelfZJ87qg1Bzc/3Ae63UNBKXwMLW7lC8LPS2OZrBD1yK+0RrrcqE1F?=
 =?us-ascii?Q?LXJNb8EOAoirA2yF18XVvgTD47Aimir0vJ94LuMdxAnYVRrWE1ohv/na26a6?=
 =?us-ascii?Q?HH0/VBIdBBs+ztYpGi5Uk/j9FzIumg7I9J3QsVmi1QtM5ktSAwPVdwuomYcn?=
 =?us-ascii?Q?WiaY100g0251ehf+JQSUsqSvd9oyo81sWQ/qU/ZFGZsTyR29BTKQQolo3pmL?=
 =?us-ascii?Q?J5cspo6VnHBxHWFwNkDwI9UF0xsIdQw2II1/3nqqcKOvUb6zygkIBdb5LChI?=
 =?us-ascii?Q?Zgo9jhAoSRXf0zyLuUUNcYtLrDMROM67KP0gmPfmpWvUuWUSXWRm9OWvAgtI?=
 =?us-ascii?Q?2spdz0X00/yan8ci253oeTOhE5N1rgLtXVJm1lCOKwwaOXVb07XNelTzJQWY?=
 =?us-ascii?Q?j5lvQq65t9GfF/7xnlWQzjl3Edchcgj5DpSe6HvtBEP0ScGBlh63QpktycFo?=
 =?us-ascii?Q?fxmp8IksXu4nbbsU1in5Bu/fZvXOe0eS1UQA8BCXV7nOL3JCGGqEV8byR+rf?=
 =?us-ascii?Q?UtqSGHa7gQjW8ya4qKDLQnGd7FH0+EzGIwrg8KF4h8QpMqWqFSM97FzbZtSy?=
 =?us-ascii?Q?Ax/iWHi8+aY7Rcufx492/qMIzPeLXEFa8x5Cd1p17+KPDkTdwykFd3a0TzT5?=
 =?us-ascii?Q?fgcGHXTVHakToz+eK3Xx4kPwMvdhNeJn1O/eoc5OTyGkdxIDeDmqg+oPSDrJ?=
 =?us-ascii?Q?0yM+Z2cfu9+qA7FLXRG50XLlUTgsCmZ1b9X9j4WozxB9VSs9wrOVyhLsN8SQ?=
 =?us-ascii?Q?kY8RPnTwwCS2057r0/hHZGek0Ni7FBcoZLx/yEveXbIUBbh5RW82UO0K1sZ0?=
 =?us-ascii?Q?wPIJW0jJrdQsEaI1B10IkJQmhGZk7TS5HK8LexoqhnQMWL/Q/DdqkDxI3GKT?=
 =?us-ascii?Q?0v3YLVhVFPuYOtrykebXQibr3B9N7zj2BwN8VgnyydskRkfcb3doumoOUEQx?=
 =?us-ascii?Q?XHqojmjLySEzo1STIZmcdBvpS4M64KYIMgfMFFjpan7f1Bqv92BF0/eA1Lo1?=
 =?us-ascii?Q?v8zDLHuUPs6fIK8SNhvtk7wgh1upvuGmFtsvSdrC3eXWXa3x1f5gxChGWHca?=
 =?us-ascii?Q?eMDcmkJcU+jeGSSaHkMTnu1CtBC6SvzVWIK3uL7FP85RiwrBwzl4N2cybwFw?=
 =?us-ascii?Q?9f5D3k4IvGusJmYXf9Zs8JHU/FhD7xYho9yFLZJoN3BjILXb/DB3kiMiw91v?=
 =?us-ascii?Q?zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	16HfY/HWwfVpXgTm1f4VVrnuYrit6Uw8QX5iIvF8IDewPw98zjQIS6nMlyslIJ51PO9BZpnxRt5D19KIB499+9Z0gqfxVAGMYVd7ijT4m41xfcYPq6jQ5ElqPWNfpafZkqDIH78uEt+U44ogbs4nWuuNzQhlZo348OTUS1euputLRJu+os7PmMcXr0SvrXFJUeItr7nFqohPsn652J/lOlQZN0tQi0n3drDMYpOJJVMXCOgSnuT4tCdaWAaiJpYc1bBtjO577OlJ5V29aBnKY0J6abecV2K8oZYHta4F+Ne1tUW9GaYByp2MKclTrJ72Xo39apgWkqa0FYyvm6Xg0AhN642kY1/yg3BIiiTQXBJGnAXaweW7ijaRQWEGSzYns88+NIjx+L0HiXWAwDaUzqB8QDKTMGDnfm5FmqdbhkGaK0K/Y0s6Uvh3vUxxwzngtuRAmFK/D6rSUpjvE19yO3ebyha2mV3L+caSqwrPLxoyX6MOYWVZ1bgeuFJiPIkIiEfGRy7Jp+KYYhOqjbNKk/t33w/LFjASQWmmJYaf1kIIEx3uxhqSK+Z+Uun6umXTa2g2Jp9SYKkJAOmClrcdU5oaNxNsj5QSWCpsIQjoYbY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b12fa5-5c30-4bb0-87b1-08dccc2a4051
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4312.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 15:08:22.0988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1UfzozSGpOiygNytKphox7MIAbFXH/3NZEkteN8RzR76/88m4bQyIcoXZ/Hxu4aAYY9UA5Qszu2JHpucrVmc4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-03_02,2024-09-03_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2409030123
X-Proofpoint-ORIG-GUID: WHvyJUqQe7xwEPyJl5VpSJFxvOdLg2Hm
X-Proofpoint-GUID: WHvyJUqQe7xwEPyJl5VpSJFxvOdLg2Hm

Set BLK_FEAT_ATOMIC_WRITES to enable atomic writes. All other stacked
device request queue limits should automatically be set properly. With
regards to atomic write max bytes limit, this will be set at
hw_max_sectors and this is limited by the stripe width, which we want.

Atomic requests may not be split, so error an attempt to do so.

It is noted that returning false from .make_request CB results in
bio_io_error() being called for the bio, which results in BLK_STS_IOERR.
This is not suitable for atomic writes, as BLK_STS_INVAL should be
returned.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/raid0.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 32d587524778..caf1ecb55d11 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
+	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err) {
 		queue_limits_cancel_update(mddev->gendisk->queue);
@@ -606,7 +607,12 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
 		 : sector_div(sector, chunk_sects));
 
 	if (sectors < bio_sectors(bio)) {
-		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
+		struct bio *split;
+
+		if (bio->bi_opf & REQ_ATOMIC)
+			return false;
+
+		split = bio_split(bio, sectors, GFP_NOIO,
 					      &mddev->bio_set);
 		bio_chain(split, bio);
 		raid0_map_submit_bio(mddev, bio);
-- 
2.31.1

