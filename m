Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8F513AF2
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 01:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762999068; cv=fail; b=Ux6OnQKHr6sn5LHllW5LmjzoiDCe+gTmVxZn/R2/BwFifSP9rdG3JY+xkalE57vfzDFdpZ0qqqW7V9IGmc4kHJMwjSufIXyMDRt9OqhzieZWWOS1uDBJfUyf0AGRVgh8H5kKQhJMuOGWpTUZkWOATR73bFPxNOZBr/V2HE81b48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762999068; c=relaxed/simple;
	bh=oSDnbBbp0A+onnyWXeEFhgFvoj91VFN0RM7Jvy+h6uo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=gxA8L2KDO3p51rW8jj+7RMh1RZPChKBTFEMg62rbK71gAc/vewPtrPC4+rlHp/1mWnl1nanYk0BfN214CBny+f9fZJJcN56d3AoBqJoeQFAOUiTste9dumeGd+/we9fDc+916LaCBTqXwgv5nt8FyDmvmSb4tAQXDdnQ/LIFrMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a2XxYgPO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jCWweQlW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a2XxYgPO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jCWweQlW"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1hvvc022199;
	Thu, 13 Nov 2025 01:57:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EUaJ+39L9wTuHJsuo/
	BZ8chBKfsTnu5w0NTnPt4dJZ0=; b=a2XxYgPOgXtEcpFErmbAmoMX0dp2GD1Xm6
	rYqJ+p4pd9RVjzwJx5Eh/0qOHBY9uZMqPGNvMTJkWFMp1X4NHzB2B++8SyG+k5Eh
	neGxfMjg2l2dKFcENxooOPKTI/jRZ7Z3o65jLJyP/3zWKK3WZS83QDTjxX7yBkSL
	saUgs7hznYFAequ+gD/oiI9rAMLGmRqAKUzVDltOQ229D2GEz8W7/pdSsqJxJg3o
	PHWJOPm6s/XoK21ihuomgDZV5cAMANKmh6RvxHpVuEjcBgMuArFdw3XJvP96fBfw
	P1e/H1JA60d4HP7GkTLwoCMFIahsmhgp4Dc+zKwL6u45WAftKKYQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyjt8pkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 01:57:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1237t011377;
	Thu, 13 Nov 2025 01:57:40 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012007.outbound.protection.outlook.com [52.101.48.7])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaf17m7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 01:57:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PsUAfpCbM9Repz0ze5y5q6F32Wdw/+7iZ7i847A5dwbBPqWyqQGIeBjCLkghXd2YenYPccO/+iY2yYS2qTr7ETfhvAWjANFBmGRLa5V9CTdnq7g1mmxMgo/3jmfv35fW2zAWZhZkRHpV+FvQaG48+DhD7Iu2eqF5gRBHXC/InoDMZGtAXeKlZxaqXD42jbzSKlK9HsaXibEKIs2cn2VN6ENp5xNzwfPxtyMawf+H0UgXtzeJ2csCr1Qt+7GadURkDPdYzG1hbOiQbTNQXc0H7pJ09OWtVwOJbA1tA9eZWduLTA75k2SXoGVZ1tPor1gyPMvNqs+GVlc0CQlx1bxz7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUaJ+39L9wTuHJsuo/BZ8chBKfsTnu5w0NTnPt4dJZ0=;
 b=gdumk1UjJGnIRK5Gvsy5UFxXcmxEvAWG2++rlBEbnW9GCRT6/PsQj/R7Z9a52wtpK53u0cZh+OZRFYszoa9MK5D8AvVOyUiJkNlNNH0Oa+Cy2yV5EiuMUM7weBeYLJz2MHJFg1qKQ8/bssuFLf7X7gXCY32NB/2y6yxs5TZk34J5eznnsM5Y6ysYokOvjwfrFJKEXN7OYboi7PVjCFqYCDkYbz06+h4VgsK+Z8gMnhJv35wOcLfTkyjyrBylK4gFChCM0ujuCRXTxx7BpSFMxSKg5y7IYbPcIBA+rCSI9tySaypDsOiZSNKBLckobHlXBXjm9woq0VUXtMKBvgIumg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUaJ+39L9wTuHJsuo/BZ8chBKfsTnu5w0NTnPt4dJZ0=;
 b=jCWweQlWVj6qb8B+rOYgZln855W26dDJAJ8qdPQNNSInX6B21y9jaTfCg12PDPcPHLL0Ima3rfCjGQOJaClanaKLZqYrWr+K07lvZYNEHkZKAjYBc05ZcBFh7nv49UF3EU84kYNKbqZ6KFJE1oG62iTdi4m1knvrUWHKkhUmy14=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH2PR10MB4277.namprd10.prod.outlook.com (2603:10b6:610:7b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 01:57:37 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 01:57:37 +0000
To: Nuno =?utf-8?Q?S=C3=A1?= via B4 Relay
 <devnull+nuno.sa.analog.com@kernel.org>
Cc: linux-scsi@vger.kernel.org, nuno.sa@analog.com,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND v2] scsi: pm: Drop unneeded call to
 pm_runtime_mark_last_busy()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251111-scsi-pm-improv-v2-1-626b8491f4b4@analog.com> ("Nuno
 =?utf-8?Q?S=C3=A1?=
	via B4 Relay"'s message of "Tue, 11 Nov 2025 17:50:17 +0000")
Organization: Oracle Corporation
Message-ID: <yq1ikfeeltv.fsf@ca-mkp.ca.oracle.com>
References: <20251111-scsi-pm-improv-v2-1-626b8491f4b4@analog.com>
Date: Wed, 12 Nov 2025 20:57:35 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0089.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH2PR10MB4277:EE_
X-MS-Office365-Filtering-Correlation-Id: a9f9297a-a647-44b6-3b2b-08de225804fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3hbH2nUTpG9MNl9dnXvu+k5OZzKL59uYq2UTD7e4dqzi0zNMT9t8pP2ifiJE?=
 =?us-ascii?Q?b1TP8XWUnho4cY1ALOFfbarHGbtGR8Fx81151ToRWO0ZzksgxwckZq511cYb?=
 =?us-ascii?Q?rIcWwt0mk9fHQuuXSozzsPHFcSJ4XQpy/4nWxTK/chJp/KqnVdt+dDaMbaAM?=
 =?us-ascii?Q?wNoyiaSv9hsLjMariiDtetHUeu54Qlzymp3cblq2y0chlVNJjFk3ZYZHPAAm?=
 =?us-ascii?Q?2ql01eQKijHpJQFd4uZJ/N3p6Zc4NQqSiuvovHoY+hjj49ckwDo+YPRYGVd6?=
 =?us-ascii?Q?Tym7Xny9FOJxjO36aaNpYsMX69TXLoo+5bs2GSv4O9Ng36PQk7/3KDmAWUDY?=
 =?us-ascii?Q?rmghUsZFI+4dQ/M3V3uGvdv8K5mfkgOOokeBDVZqd3q4aPefwH3Rk4gGIvEG?=
 =?us-ascii?Q?zGZdMbZqoPqHQNlefJSQmuyg6ioZI8dz+7mblVFPvWMAtcdYUhCe0b8ne68Q?=
 =?us-ascii?Q?G/n0lKyq3lHRzhQ6H5ju0s06W7tqzIxTPr95uxt8eljtlNbs3fLVjwZFPp4q?=
 =?us-ascii?Q?d68TCmYeXdet7Axez+pYTAVH2uleUNPLt4xYoq3S+Gq8IUSmbKoMrwwrdwfg?=
 =?us-ascii?Q?Thz0hm5SOk+p0lrUjO1bEe2nEmhCH5YqRWoQivWjsfLoHogd6TF5GrBZC7kJ?=
 =?us-ascii?Q?A4wDvaHPjKR6PkQzs324OAkktJFxmBLdEMGdBLbTWudyfc5As/rt0J3Sebur?=
 =?us-ascii?Q?lRs0Ck3r/lsbgXzo0WIZiW5duQcnE5lhOGvlqvYWwQhwr9tb+LHJSdG5tHiQ?=
 =?us-ascii?Q?X2VpjI6bFlsytS7AxWT84gC7SnUQ0GVinJA5Inyfi3n4OQYF2wfC45Oqu7Eo?=
 =?us-ascii?Q?JGttiLJWY6G4FXazKH8vvWcyzssrtKEIEblspJxL5RrhuTcgQC4FZMnSJA+O?=
 =?us-ascii?Q?tdVYC0/4b+EVo5JFvjs/ggQyFv1nGctBjljNkk6Vi9olxXFwb8F8ZjnMxjR+?=
 =?us-ascii?Q?gM4fuOaZ60Fa2G7iHNUMKnZvhS46yRh1MTZzYI832MncfZIW+u9rtRqmee6v?=
 =?us-ascii?Q?7viEeEP+H3fm0kgwqPk676INX7hLkXUGB9nN19qmf8bSWFuQ/Rz+olZPecBB?=
 =?us-ascii?Q?I3orEegEUKaI+UbQk/KV15PgG/CKCyzz61FsvxferGva+tnQ+7DALq0hU+d7?=
 =?us-ascii?Q?YMwYUA7mxZ2TviHeqkzrK2VEw8BUPdk+NHA7KeNDlMtghA/PywHV3x0bD7PG?=
 =?us-ascii?Q?EYyAhbzQsI38Xla2tyJVYYZK2xuz+Fa6rRRcoXeUE6oFV1eftVe4hi25+87m?=
 =?us-ascii?Q?YJhL7TE6ktSlpEwl8Mlpe3xVWYDtEOo8rHbCFp9gG/OtFOVt3YfLQswbnaPK?=
 =?us-ascii?Q?CzHRvCVOVdHzKgENU9tJes6nabsujyg9NxTdgU2y/2YxyYzm4gFmfVSyulJU?=
 =?us-ascii?Q?Gc7AE07HSlSmacrsFTIc2Ty3N+DdyoXUxggdDK2A7d6sUrlznrnX0rutUV6S?=
 =?us-ascii?Q?2/diA1XgRdBCawk8KR06gQOS9JLgu/1F?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZkYj1ilyfpfco2LzuXd+SMJKSMEhNC5bbYxsnWDQCQY5UPinSKdlT+UW8mZp?=
 =?us-ascii?Q?hNvOcDovK3XnRRer5teAnhWFGimMaMs3jbKdqFWd8o2TmBXt6xnFWTPtPRnz?=
 =?us-ascii?Q?efQPZIkOmf8tIQp+16nZ144JB+yb7+nWty4bEaa5ZmkdUVSSVRij7B9ezGcs?=
 =?us-ascii?Q?5vkuOg3iX5FiKzy7IGG81C7t6i9YNP8aKwUxB2rMzTlPbQB35tMEA5GCys9u?=
 =?us-ascii?Q?1t/j9rSL1GAgh3SV7u6/6AHBdTbItkEWdv0IkzQSE0PXAjcSrxbyGB47HE3d?=
 =?us-ascii?Q?1TJ/nfTlA3duz3RxEcHG6dCOUf8EQfd53FCkHgoJZDcDrb2+j9UEIPnk48Mw?=
 =?us-ascii?Q?1rFq5JfmLCCCAzYyLn0a0pR19IwFJa4IGEvhdtIZCVSuNbAhyQVRVIesG1hb?=
 =?us-ascii?Q?34y/M9exrimdJqfWwhYNoYbTbysEYbYdO8aNfRiEV8rBiBxqGYzVIvy+LhBQ?=
 =?us-ascii?Q?PctPiBz12jB1F/4+fzlqulz6uvKBhEQyJ+yJoPL7A3a2LIz/DUdpNzo2iXAv?=
 =?us-ascii?Q?XZLpl8vaxbNOXN6nNrIhtl7s5ar4mNU+jQGBZMv+QhXnQVIVnPatVHmD71d7?=
 =?us-ascii?Q?kaDBI3FL12nNgmkIoApfyWXGvs5IauJZo37GxwVkqryTIqFYi5ouKXcTj2CS?=
 =?us-ascii?Q?s7uaT+e2/jseVrRSjJ4D7vBieIjDlJqDDhjTsM9WPnMvIFTYe0zjhLT6VLBt?=
 =?us-ascii?Q?wwMgiFppF1lidxqLOpLUe72EK5/vPx/rorWbo4egnEDOgNxFdoZKE6ybxKho?=
 =?us-ascii?Q?YJOIx4VjstTMT/569QQO3CwBthitiw6SOohO2gmCQDBlB8c2QhpiPTpEkA6p?=
 =?us-ascii?Q?MeAMGwLvRilyqF7y5hcwi9Mdd1ahqhpGF26Kj79p3bu8r8X83uRbBJdkKIdv?=
 =?us-ascii?Q?B0etCUU/8MNlkD+GldtgWJL2Pa3xAKYX2kltItjJDdnO+3RrhRj8GknPMtQb?=
 =?us-ascii?Q?WSc1FKoGO982L6Tgz9vsOfFCV1giq7J+dOOoLLK03Uq6weOX8HV4TQtYa+sg?=
 =?us-ascii?Q?CAhEWBVW5207iblTlogvfpR7PFqtgzo+5LqxJJDsvGFltiF6c8chg6IaU+tc?=
 =?us-ascii?Q?/cXWv+5QsJmb8iNSZ+ToZooGpvKs5lgBouoP0Ug24O+nrM6C7+d93tBdBf6/?=
 =?us-ascii?Q?YadNC6wfk9StHLZGhTxII7uRlzPfkb9Yp2MvHcLjUilHVNZl8OsCeN/SjkuM?=
 =?us-ascii?Q?SOUZVWGcGUhdjKzYkWpfRzl/sbnKpJEJSgup5bC0cWdqOCVkKVok1vEQkTuW?=
 =?us-ascii?Q?gGm984x1IDWQbeHyRZMgYYAefpLMZfhK7Xan7cwmpUXMYtCfT4j7oqVAEB8W?=
 =?us-ascii?Q?Kf1q1B82uzzE/U1NpQFQTXExqtPrkeU8v2H2mlnORs+FHSgms16oo+F0HB6F?=
 =?us-ascii?Q?35SSzjObAbSYp0vxkQyYiMRRxgwXIoD6/s2GCmyJbjSdz8jV5sVaE35FEK87?=
 =?us-ascii?Q?ShZ+zDhxO60ck2kNiHgfs4cxjnRebLxKK8RgpYBFowo1ErbSUTifdsSEUt1T?=
 =?us-ascii?Q?eSl9SgH8DO6uwyte3/ccumKARlsZ/+eTvixuWsEj/dEvODWC1pZlOm8gpeoa?=
 =?us-ascii?Q?O1jG7krXgo5NkyRDhTpbwBHqq4JjtqCl41bQInfQtptRDn3Jn2H/4pYan7Pp?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dYNBjGnKGMpXt0z28jXsxnPMh1e4jMk8bNzDP2stvv/vK7XDW2XTYG6UhG6QYA/b3hNUA4cvLOGToUa43jO6PpCy3MMhlZka4VEow9eQxhf7F7fLRzF8OsDkldglS9WAtixlSOfuCJTgfmjV9gMpsU2weuwRMX8GpBeyfyFfU4WEVK19WxeBBNQjScHa19Qdg9hC8OMS8CcLiZ9mjQwyW5pGMo5+RvpoGF8+t7M7c+T1TL54c85QPyebDXb/jmQ323DPiAW4dPbwZQ0mWLOL2ZNQA9VRdC8Xplp9qo7hlkyoZvLe0MtxKpJQ8WI0zgWlWH1ee06IjWqO8zvXFnm1yQzwqMjz6tHAEpCGSRbzZNQTDaule1EMfS7vrhgt1Vna/c2zS4oeeaL6jtwZ5a5juq0YXEaGixh86Q7BJYxA7Yf/tp+co+aifsx3L+cKjdtIDPhtGmGMS2MiLN+jykzqRBSrszzH6NiyGQ7ZOsvKniHDj6DixMQyqgH/mDNqKf17bmAhngDFPPBU/KgIQYHqAioWq6N4tVv3/Au/w1HasucfmgwlEHe9fE1HGwwr+qIF50Elc/LXqp+jEX5IT7+aeCACg4CnOILuN1v77EcA7Is=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9f9297a-a647-44b6-3b2b-08de225804fb
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 01:57:37.0564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LdcqqaSMZpFsmAlD3rbnxwXJPnPGSXZZkHAhfv1zcGUsUM4gFpvOQVCZTGxT+PdymJRNftig+T/PTmfyjWCAGUiuWTJp5HcWI0LXrx5Dc0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4277
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=834 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130010
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0OSBTYWx0ZWRfX+uDCpUFVENQ0
 IDcYbJqKgwJvwwOxugk7IHyvA735bphreDjM8Mr4fzveBCRrC2Nkfu2GOxePMC0WE3HUwgCg0Za
 VhwMhxYLqoNQ9gja0SkN5YvItt7epiepSEhR4r7sFFPe7BRe3XuFiyKZbbR29dZok1/NIEyfJk9
 k21ETfiOY3DQRSJFEEaq55uyeuUxTaXq+iMoQbuHx9yr6dSYy3OLGshQqnqaKwxiT8qRHriAe/7
 8QTvIJf4fEyNq5m6Q2MIZoFAhtuwYXiVrVCDXAhYtbgTKhZyhhMhvFzUeB4YdRpCHM8ORnmK82b
 jqOonjxCR4/LmLLmrhfssUPWAD5mUF46oMuaxXnAYbbtZVW3C5+timvuVWff9Cwn5zsqQJx8j3t
 icvBvd1KlfJHI1aWT7GuOYw91LXo8Rx1ueYHnlct2SJb7jrRRE0=
X-Authority-Analysis: v=2.4 cv=S6/UAYsP c=1 sm=1 tr=0 ts=69153b15 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=wXHTl30T3_DLFOiwCWkA:9 cc=ntf
 awl=host:12099
X-Proofpoint-ORIG-GUID: P_06azABjlNxKGldJbZSVl7VUeURmaHZ
X-Proofpoint-GUID: P_06azABjlNxKGldJbZSVl7VUeURmaHZ


Nuno,

> There's no need to explicitly call pm_runtime_mark_last_busy() since
> pm_runtime_autosuspend() is now doing it since commit 08071e64cb64
> ("PM: runtime: Mark last busy stamp in pm_runtime_autosuspend()")

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
