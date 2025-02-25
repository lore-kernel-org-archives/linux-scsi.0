Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B9F4C80
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 01:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740445432; cv=fail; b=A4KCQ61PWu8Ut3nAyMyDKCanhHQFhgB5Akcqp0XugICR2oSzXaxOy0Uk1ClYv4qOdhGeI60zmMGhLVBjgfJZYiVePm1R/ktpccaSG6CTlpgjQ5Fy3kU4m0NMC4dFgxjlM8XSV6xbPuY4XXcopHeZKZCZ0wlCqcjQXt28nd1143E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740445432; c=relaxed/simple;
	bh=E8iG6dtAUo4NGDBLEF2+Tv50ic9hGTXPrvoKaBoOceA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=RCpCJ20c98wOk85mgJBqhlVffz/YquUhs7jgePb4dKltKF3zW86u1x4Y9bxQLCFt/08y1Qy39nhS8+A4MwtWFnAcDgqUiba8L4umUB55HI+wXh5zgXFXQZ7HBSF5nmPa+C8zA0X+duTfs8yQG0cP69ipIfXcYPINxnYeBTZ1IEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Hh3Uq3Lw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ACidvhPd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hh3Uq3Lw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ACidvhPd"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OMK1uU031064;
	Tue, 25 Feb 2025 01:03:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=p2GXtpP3M1sbJt/tlA
	9c00hLc8dOc/s9Etq2oUaEA/w=; b=Hh3Uq3LwZ6Y5EXtowZXYc6EJkSMpoNuQyJ
	UMNr6DXScooxW2CXVn7ZPDbfnM3g7+wI/q2uVrScB4RIPLI8eHmagiB2h45oJWL9
	bwEOErnAKnMdo1nMKdY9d/I3WNyg7d1FXNBZ3j0oxYzhzTdEp/fp5M2+LUMPFgTd
	9K02VRAvfJ7qqA3gos9lkqXniOLdg72J1PN1xFdaQAi9gS5jX1+XNkY+mXUv7AXW
	i7PRJwYjB9TmejzZc3mqRtC6UCmCBtlBmRa2iMmd89FbdN4Qgmqp2nSrpbuOvgDb
	Op3xKUX9omKJ3GeTiE3TmTi/qSqhSieQ+4aS+Dz5KPgRCDv0gXVg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y74t3x1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 01:03:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51ONpKQA008160;
	Tue, 25 Feb 2025 01:03:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51eh1cn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 01:03:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cqpPsM0OHqhxMIqeGnnDRS6pyldv6Gmhvs5ay6U11ogvRNFs2gv4mUvNQgB+4vZOqGmaBkXRh/hjhZB8odpeCf1QMuS5qzuTmZ/JWigX8Xj0Asagjd7JItypDsMG/9xNXnsf6FBDXanKf6n9cBOyjEVDwqhQtIZ31qYNIUOEzcLZs6S5nOYpg2ST3nMvg2KgknJDrCi2j9+oyAw6q7m86GBgsQlirCrHCsNAo1eurTZApQ9IbEZtwB3HLUA/A7J+bYsJtolKnBOGGvEC60DT8XA6CuwBFYVSqadXoCE8YrVW/lxZ3meKhdt9Z74dR/0GxtjfjHC4rk995i4Xxsdg4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2GXtpP3M1sbJt/tlA9c00hLc8dOc/s9Etq2oUaEA/w=;
 b=d5qqerwtFJlult6MoG3uW7uorxRr8LYwbD255HaoLpXVtpoidqZ6UxpeNur/lzTbz4s+F0JTHcmSNJBOgaTtkp5E1PheESFmRKnEQpCIXngpb91a3r1YsPcVxYeDY5keyQMYiBj8AmzXsu9LSnV9EaYZV5Lz6+Ifg9LnUxTKqEYmxE/7Eyk/RR4mPN/dWct20yvGdp6NfxRjjx9BFfVrMmxYJgnGVQw2mRK6bv7SkfEmVsy9cyO69c8dzyE+8DFMvFKxgCatG+RvmmPL8cbQ5YlqsZ9cJ7a9iA9tzBxHBjM9gMjlHQd6QVzSIxgNKEKJegoPJK1ch9M+Y3/ulXBXkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2GXtpP3M1sbJt/tlA9c00hLc8dOc/s9Etq2oUaEA/w=;
 b=ACidvhPdVHJZiM/sFxnSi9OQVKmKU07D9pCCuCvwTMI0Zh93HqHwQa8ASXYkGqyb1k5LLKgJckQ6jkiJBbu8Cc1690KhdVm7hxUFGuaIFMgs0i37+IFP7yWVPJtK8/s4yV1abyErQIUhlkqqzyBbCeqSxHJxoKvej9SmPAMM7Vo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BLAPR10MB4817.namprd10.prod.outlook.com (2603:10b6:208:321::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 01:03:41 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 01:03:41 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1 0/4] mpi3mr: Few Enhancements and minor fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250220142528.20837-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Thu, 20 Feb 2025 19:55:24 +0530")
Organization: Oracle Corporation
Message-ID: <yq1ldtudee3.fsf@ca-mkp.ca.oracle.com>
References: <20250220142528.20837-1-ranjan.kumar@broadcom.com>
Date: Mon, 24 Feb 2025 20:03:39 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0316.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BLAPR10MB4817:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b8f2275-02d2-4d17-63dc-08dd55383e6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TopSOB+VTFs15OWvAJAzPS854lhE/iYsMdeLSOmP9l1zJmFfBkt7trF1k8P1?=
 =?us-ascii?Q?Y6424ZhyZ9f9+CNXJdHdr6kcomvBqZp65WSexpKdNQxIW1dS4SKNlch9Z/Cy?=
 =?us-ascii?Q?dSB6UAeJWMdxjgjImlGVjHyNkI4ovgqiv8oM64pnRLMafiaMmMjdgxZScTep?=
 =?us-ascii?Q?8ILsAGE4rXyb6SenNwKtmIengSOZuvUy1UYApiCQmdjpmJKg+6qZhSCqwKPo?=
 =?us-ascii?Q?RR+qPVKu99Mow5TTGHwEx1esA+3aHeQwPjk7xQfxhA70FyZLe0dLNSDbmSuQ?=
 =?us-ascii?Q?GOYZMnZjT1Ji8a07vjbtfrtV3Rf12HwLuEL2aqdiTIFc0B4MreAVN2ov5KWf?=
 =?us-ascii?Q?+FCFIWx1yOe7gHNQTcO2wymRREB5FYNHOF4lXYjjbFvqwupJ37j9+m8O3hhq?=
 =?us-ascii?Q?hBk6vNw4E2A7dqQ6xqodOwfDK22+4FQOVGsDjZB1yda/hZzfBkCvHVJsZpzl?=
 =?us-ascii?Q?jgNxliy3oCSM/gcoEFcpYRn4HbbbirZo490Y4MpxJykAjY8p/KDRO9Y9D9g2?=
 =?us-ascii?Q?XZJdRbk5r9ANmXDBCzybl4ICpz2cuBj8XJ1UrQo5AetmPKKKfqNsmkyECD61?=
 =?us-ascii?Q?hIp+kZdtzoh+1G51RQ/I7Ae57CkzJ5rJJAHfpvEGBDMDpjvXo6FzALSog7IG?=
 =?us-ascii?Q?Ktl+vrHHT5muZ8xuPIrX3aySBxtd4e9yBGUe5xyouOXaDOenbJhdSE9Co87u?=
 =?us-ascii?Q?Og4IODEiUWeshmSHZhcc1fIhomUgu9MCwx0ArlxKdTi8WnEFQLsGxgcNDZBg?=
 =?us-ascii?Q?7AowFin49wkqUSiOH080ynTLfh7RnS9l2mPcy0nFQ1FcccJEshxMrfiEKutQ?=
 =?us-ascii?Q?iwFJhmLMzsJef1KqmYUsll59q9BqYN9hFlCTr/O6ChbwThSmeX0NnHVZbRyJ?=
 =?us-ascii?Q?vgO1oQi7yVF0fguRMKErPe4fXMYUH2h+dpcHZO2ayA6FBKyaZjLOaEfvqtmW?=
 =?us-ascii?Q?Ymhp01ik0chUsHx6BXsGQAQf8QYyelNbcIenNOo8/j2tgJI/iPeFCzVir6nO?=
 =?us-ascii?Q?kfXp8ZHwvcseRNQd6Tc3GyQ58NUhjkgm8TnIpxX18ElNKo2qG0siilrY1pMg?=
 =?us-ascii?Q?t4GoRTxckYF5lvtbL+dFB2iRBNnXtCsJWE9+QRPjZPEk/L/7N+qKETKKpssv?=
 =?us-ascii?Q?WDPWKUBrKHPbsIqsDHVk4B0P24KXGRm5XCtFEMlCMjc+YZKFtzdxxIg/vfGA?=
 =?us-ascii?Q?vLgcmJQjhMGT6HJ3UeKY57aeMxLqO8Fe1BmDq4mcKgzPhZubCr2L/J5+pOpE?=
 =?us-ascii?Q?uVEWBFmqOk1iZTbZAxCRPlwLxakdTY1djIkoTeS5HNB9NExlb2FRf/akuSxh?=
 =?us-ascii?Q?ar/GYl1nbkBF82wR89w3IXB/Rc8Y1jbGPq7hb8dFxeY64H6qoOcQvVuoemI6?=
 =?us-ascii?Q?V0kFloUIe1Z/IaU83UUaSLNNBuJG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YVgrCeJWU3QoQdWjScambs2uEIpGhjS8YOnnpsQdIeIB4sesCR6Ooo2ipP4Y?=
 =?us-ascii?Q?np21QRNeiTf9zuolYw7R2Kb1DBnaFrgncdOOME4pWBk+BmoRvCHr0TLotDNY?=
 =?us-ascii?Q?aMUXE3gM+Omobothz124z+Z9i2AOAxtiezpdP6ah6kAFFvM55AAvSG/1z3YS?=
 =?us-ascii?Q?IUI4+zZMds3dZGWvYRP+aOUBWhSSb099BaMfpxTWLH9ky7Yrz2dqlKPM8f5E?=
 =?us-ascii?Q?FfDODgV1Qa5EUvV8B2GIbze+iqBXDPccr0b2AYkNNE25ZvJfc1wyUpTdkDoV?=
 =?us-ascii?Q?Kp7GhZgaK87to1s0zChqIxrmjLoCK0VdMBYBWKfpjn0834RvYnx2BeaYuzkh?=
 =?us-ascii?Q?aQt5IvdSqYw/XEkL5ovBidjPxQu0MABMDub2m8VQ6AiElDyoIxmSpGF0k+Tx?=
 =?us-ascii?Q?JmEBdKK42FHsObYbpl1UGKyQyfuF+Q/E2uaSqnFdePBgoIJmrzPHauHlSina?=
 =?us-ascii?Q?5BqGzDWskw7vMij68NgqIJKcXiqcgHw15i+IK/1kyj8mTxxSwaIBudFcD04e?=
 =?us-ascii?Q?rjGQ1JyEq+FgAiF9XnK61ttKIwmpIYqAxKx+yg4rPmQs2VxZtjX9HQH1Z0R2?=
 =?us-ascii?Q?HmIm8NolHchyO0kpfyKn+GLWym8xo0QdSFQjizSe9XuaIfe/6xaDbTa/mpFI?=
 =?us-ascii?Q?BoqpRBVSRIs9PzAv1ayYMsx+e6+Nmc+12BmZa1zrZ+EHNVj3UgLzNqZgwh7f?=
 =?us-ascii?Q?BauI9gM+Ub4ofNOTPp0M5LW3Zi5IAT6VN0/d/wIbff96dAptRdWBGww7e6MB?=
 =?us-ascii?Q?8Oj57kczbSCoCb4CY/Z6xsH44h7lQlopJ65muhGyx6MONwJGrRsWlEjt49a7?=
 =?us-ascii?Q?Yjs7Mdr7ScQWyKg4Un9+nfgGNfoRoRs4SoZenIMfCJhrLvTzLMnKvaTl3UfN?=
 =?us-ascii?Q?JRBU0XredwMpZ1+pFDib7r8nnjoIAIDsIfhcuDC7IiOVSXyO19Mt/m/9pF93?=
 =?us-ascii?Q?hVZPmXg/DVyEG60QipT3ZTTrZc7XiTZgOOGck95pjL0pxEWGyqjO22ptFMDE?=
 =?us-ascii?Q?UQuNvur8NbHfTHCoUOJnK4DSoevuQyzLM1weSuR3cn2yujYqpuYqoqYr5XGf?=
 =?us-ascii?Q?akRaZF+FrVydPWEpus+8WTvU7uYHLq8g1Wt4snWHjG2PG7ui0VGgJfNDAXUc?=
 =?us-ascii?Q?7DcQYo4rPNVxEZhCCkJURruTmmJYElBDuZfLy2KcHN9PpyoxhuDvFiBqa1F8?=
 =?us-ascii?Q?chU2gRT+iSXW+dQHjkR8VUnbaHr0l8CRH+wfVnqOAmO0k49Bi7sJxrdX66TG?=
 =?us-ascii?Q?PKHHMMOWnChgT5hmkosC8XKb7bxCPyf9cOoDx3fa25tApUwHGmSG8kA3muli?=
 =?us-ascii?Q?Qd5cCGaSBjg3TcTE1aAHUBVUbShchBj6p1v1LdxSfE4RouFaZlYV2CKQTHJD?=
 =?us-ascii?Q?P1EMQWchWR+XXaa+SbFn5sfd91FASXgE2Z0fYjk2h/RoToApM1KFHpRo2nB0?=
 =?us-ascii?Q?Zyrex187e3rSVpUPTAqqmKvGeuVbSQl8j1irjgn8cs95hoMfhIWpcJ6d8uy/?=
 =?us-ascii?Q?ekJu9lVQp+EsMbDxmZAc8DxQUjX0UId1bDBq+NRBxrWpg1C00z6NxQ5pkyNn?=
 =?us-ascii?Q?f+Xy4NtYKKxobBHDFTTF6Y8e6+A8jvxIni9GfikQA9Pez+GdEM+i6LgfbiT6?=
 =?us-ascii?Q?lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8abrfdoqZB7JSUyyKZTzzGCX65BpP0fpQUOMN+zMn37ej84CRSxhLpr0n7adGxs9w9VuwAiDUOapbuJbrFESjQJ3SzkFwTDJwtfUD7+AUAVEIdsV5zkqb/NmVUHhvNZUC4bFzaAl1Z600F8R7R24eFENHtxLVuoOYM80+H5yFj85TbB061OP9HHp6QZzldmalpQdGQVObdco7CBVcM068imdmuNytLRIcDcZfF+FqH+145I8N0JaISu8RvxlmlW42cvfpKFaBqYF02ndX6OJuRQWmnpGUm/9uiTgdYojrvV35lnbWUb8ulqLMKGwixWwYKGVQBI3O+QtDfUZTamHNT5py8aGJM9/x5wYy/UGH+EvttvHBvDeq9kKwPYm93I0eCg/DQzq4dn4fU2nPgN4bxJ/OeHjsaMtrAAxFTu5YRovhOrHsdg54cLiEVqBRD2/ZVdwgIm9jgcRAsiXrO86fXsuJlSWcaqfVuGNN55afu/ObtbIJ0t6mjVhqGdiiQjxfLdWR0/fuqg4nzNPQIaCp8ZeNVDv/+kJO1XFh3VFFJfQWGxVVNzxI5491PHU4ayitO0lPMaIptfso59ipUoxCojbBvW8MfNq3r/2DD6rAIA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b8f2275-02d2-4d17-63dc-08dd55383e6c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 01:03:41.1582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7zZoXmD/JkjijUMdfhfSdw7dbHUMqV3RnPecZ7gexaMlse0raEe0S8GlYlN/Cm7LE+YcGR76fh2tsATDr7ysE0+KwJe9VS8ireMIiqKpFk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4817
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_12,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=807
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502250005
X-Proofpoint-GUID: TQIVNScsG00ckXEQj2WJ4cKTF97kcL9m
X-Proofpoint-ORIG-GUID: TQIVNScsG00ckXEQj2WJ4cKTF97kcL9m


Ranjan,

> Few Enhancements and minor fixes of mpi3mr driver.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
