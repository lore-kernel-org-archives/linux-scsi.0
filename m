Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FF9533D6
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 11:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752578168; cv=fail; b=fCxP6AnXd+1w9qv5fo5HP7xOslOB3tQq9AHBwFxBXCt74bx9YrmWkOLA1uHXAGj6yN35TMhnQ9cTR7sII5Dy0oVJuV6KtZ+srxDZBfImq1gWPYo3o7BFd1Qho1b6/9tWO294oUZpEbnLc/+bL0M6j4y0lvvAaM8WDwVCaLgFQOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752578168; c=relaxed/simple;
	bh=8kWJUgpKqmRG9dODVXLrp3xw3nLWa4zA8P5MAO+dEbM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=oTDBiWS/+SiXnhkUT58/1Sob1FL4Tady7ioflxMvoSdsdVOAXoGoawroS5Ct9aDAyGpmzKP+l9twun0p6pweUf+WSMKq09lvkpc1JPGjlTAZd48T9p9OkD0Qo980r/DyajAfZ2+UCFcJ7DyqpYh7VmUmSNjQOZv1gWWZIaqxk/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CWzBQWds; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HJ3bL9BP; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CWzBQWds";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HJ3bL9BP"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56F9ZKTg022726;
	Tue, 15 Jul 2025 11:15:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=nXgUwB9kM5ULMqGi
	Rq78F7snITdGHICl4MizHmkyZrI=; b=CWzBQWdsOGswKLTN+pzBbjXVjaq4c4QY
	Ht7+Lfy+k010KqZVykNnIs97OblGrqjb4wvL15LM2Jj9g3RfVvj+HYS7zd/ySGS5
	kPljBU4JP4Mk+hVkXZyJ0bHj5YWhrvs2bawHdaTb7ccN/hQsUrx454zRBF570eyR
	ytCV05PbfkKX3Yj8l77YLjAIV7sBuLE8RBjcSaVEIf+A418KdnOh/1DTAkAQJHeB
	DQ2PSLhLdO0k67bi3Y9h9v1VzOKfSEBSHHZtFD9Pvx/1RScENPtm7LZkRFZVvCH/
	NNfbl1WrzrXDbo6LK6anT4TX/2l/JSsNY6/k18KHNOQ1JWmpb8kBqA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uk66x6f5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 11:15:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56FAxTcK030320;
	Tue, 15 Jul 2025 11:15:56 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2052.outbound.protection.outlook.com [40.107.100.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue59tf1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jul 2025 11:15:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AZIQJUgJWgWGviZeqLLzlsZaL89G+3/+aV+A3h66oUpOuCaf0cSnWyGEUK7X8bGX4BZWppCbhwzz4fRzOT8lrYMolbqDrZCQNj5cMQmpDDpBEJO29U5dfOXtjPUzxnlmvY/3GJNMxyS+LauAx/fACkh/0Ek+UF4Vxz9t+60gH3NpUAqwyAZqXMnctaoXvx3CrEccEaHkzgE7K+LI13Miswf3ug2QQDGcBYDCXQmd/wHFddmYNhA9gvBDoNyIkn1WdCrpG+VSbJ0U5okUcV+kf1FJXkyNeE7v5pFd79XP1Oi7qlj2Gx5srsHMdq2EcjIDLCu9W2qI65Oa9VjZRlLaeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXgUwB9kM5ULMqGiRq78F7snITdGHICl4MizHmkyZrI=;
 b=DMgI1Tjj7Gl8WSMx4S2TSbT6ErnCh9zWYcSNT7FczwW5+nZFn/eswu7PUHzV84WmGWhYUiu7gpYbEuUSw753CC9wphQp9xjYxf/52UX+oC2+sCalbtsr9LMSpk5Tp5EhmcG5s9xEZ/6PgnF4mbefumSoe1sI0+O6XfN53wqMvFJSDw8LK+EfWf3o84p3jlPblVK1q04PR+29FdrlKTNUARVComWIrtw2/Jl48yspR7zjTsdaaP+f9mfBcgppgPGauwHSZe3JHwZ1sLJ8trGUAtsayjP8kLacJX+aL/fjkyt99a/GQ9/V0uG7jgL/GVf+lOep2OSBYtWGy6hQt8W6GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXgUwB9kM5ULMqGiRq78F7snITdGHICl4MizHmkyZrI=;
 b=HJ3bL9BPMhT1WCPxRl0t8ANPUtBqlDuycKPYougEA1anOn2cGgcHw9bRBg/mrZXknwEUcufUHOaUEbaaeG/bMzagxf2NKCxfiSGha+DPTg4F8kgTR5wrfEfEGZ4gN1UbsyNxT6Q4s+gthaXw8RmD75y8TvLkDMo1Hq2ESz/NBww=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by IA3PR10MB8140.namprd10.prod.outlook.com (2603:10b6:208:502::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Tue, 15 Jul
 2025 11:15:53 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%3]) with mapi id 15.20.8922.028; Tue, 15 Jul 2025
 11:15:53 +0000
From: John Garry <john.g.garry@oracle.com>
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        sagar.biradar@microchip.com
Cc: linux-scsi@vger.kernel.org, jmeneghi@redhat.com, hare@suse.com,
        ming.lei@redhat.com, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: aacraid: Stop using PCI_IRQ_AFFINITY
Date: Tue, 15 Jul 2025 11:15:35 +0000
Message-ID: <20250715111535.499853-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|IA3PR10MB8140:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cdf6464-404f-4648-bcc6-08ddc390f643
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XKbmpiuIQh5b7xHWtCVy7OQA9cFZYoP4aRG+FsCoVrPfP6YiDt5cC6J17nLH?=
 =?us-ascii?Q?izpDKyneUTUv6whOUNrQqSyorYrxu+GdsrxivsDQUgx0Vsx+0u2cgY5mCptM?=
 =?us-ascii?Q?deDJJNK4n5mxzEPeJaHVEor4maOHE1BQvr7CqXUsGPEf73369/XXxreN+u2Q?=
 =?us-ascii?Q?PhsD9vjgi0Te6Qy8juOUYNs5ge4oMvOW9X4hXO1JhnW5a6im6e+Du2+MfKX+?=
 =?us-ascii?Q?1mpcEROZhZWFC8vDSbv8Z267CSS/MiOSWGcCsi91W6Gd4W/Yk95knuWKJ8/c?=
 =?us-ascii?Q?5B2qTFp2x9UsA9jaTSZDS/p0shJA/3VrpTjFW7pxdkoXOe9BB/yfONLI7/BF?=
 =?us-ascii?Q?1VkEYEUgC25M4iqbIOV0QjUb/Z9iip9qSGNY/Y9FhQcDwB2QxLw2Hs4P5gYI?=
 =?us-ascii?Q?I20Om/M8ov4XSk1OMYI/fWf63uM5ih+Yt2SeVGbaXcj9gXc5j2B8zAs7kO6w?=
 =?us-ascii?Q?ZHirwCsuJk4cW92Rg26o+38BOqSSL0SMbmvUyGijI0LuGEAQa7kOPMVGTUQd?=
 =?us-ascii?Q?L15Cn2bbw9WUnc0hCZI/4T0Yv/700KONKx8HaXukw0f90g+5vvw9yrvTxA1D?=
 =?us-ascii?Q?NV82JIXv/JwgRvpU45wMpVlBRA05OWCMD7ARuhk+l+nTgt0hh7NCPcwhAGMH?=
 =?us-ascii?Q?GaSGm5fPVFfBsnGqW+Qg960mmHWJ4/TEXLncPihr6QLSWzKwS0plGEFJFhHg?=
 =?us-ascii?Q?H1cxLMkvaoyB5u6fMvfGa8B3W5opCkeM57m+lzgK7MKM5mFkxNxxEDmTVQla?=
 =?us-ascii?Q?vOLUK9isxgUWaZ0yWF1mgb8s0N+wie1rkvmkusXzUx6ViabdS4YVa6X+s2H/?=
 =?us-ascii?Q?86iadBvR4jsvkz1nySiFxto4r2a+jk2ACM5aI0DdlwWll3uSrs1yCaWoHuqO?=
 =?us-ascii?Q?5LWz/rGCCDurpfdGNtTu6qv5NbmrGUKOp/alQvOnOcFuaK0z0lGZUGDB47nE?=
 =?us-ascii?Q?d2aeteYZuHPPbV+yAPumqrS3toWT2lEKFbrWb4er5ZaBqnqFZkIRqbCrdMCF?=
 =?us-ascii?Q?l8qYD9AJGl7rZ2epF6ddlwxqtDyVkRT2uuK6tNb2xvMGnvCph3PCzlZIRXO5?=
 =?us-ascii?Q?JTxfBi48C/r8FrYErDrQMBiijLw2ZIXJSDlr6fYdPyZzuNE8O0iCiD50pAyU?=
 =?us-ascii?Q?6LUMEzYtZKgZOkOKx1hxOWMMsr6s2UJtDmkWlHyESnvsbaXrH7pTthN54Cng?=
 =?us-ascii?Q?bTu5rLUvuawfE97ECXqC3bxss60VihWeLvMlArTraUvqqFHmo+R71qu5iQAy?=
 =?us-ascii?Q?G1tk0ywEKC0Z2DG+O+VvV2Ralu1sQ9PqcdvaNcFjRsRCBxX+5JxHaK5KadJz?=
 =?us-ascii?Q?5BNSxOQJ+ORdP23+gZ/AjUIsqnXqVSZDIEJYEesLqmMyUpDXItnlGq+LoFCk?=
 =?us-ascii?Q?nghpgCVaYdqCNFJdzn6wJ/U/u31nqoiQMA7ZaQA5R+Z9uxpMbQqNKz49BId2?=
 =?us-ascii?Q?qfxDxeGZuf8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sKDgIt3WIyRrlcqXxnQgUXEAsBY4I7LpEXVX8VN3jcgzepQYOXpxxRowNRGH?=
 =?us-ascii?Q?qc7fjSM5U7LeqHACzVanYedEt+xZqf7RzRsNVf9oI1nHjHx8/fkFyYFOoMnG?=
 =?us-ascii?Q?qBVLFiUNAVgN7gNTHi3dh0NxSlkpp/F6G0ip/jtXLCyx+obaLcAZYh3pVwt6?=
 =?us-ascii?Q?cYV5tLtH8080UCZ3EluYLA3MAftqfy3aDlDCII/PQ5U8mqXXeT4zb0OpCsyG?=
 =?us-ascii?Q?WWvDfZoKB6ISUNjFA54+Vc1nR9gLz22c86ka/qE06NXO2eJVxz3We3NLeGen?=
 =?us-ascii?Q?rkuZTJ8VorrxQCeZ3+iN1moDB9Pr3cF9QoBggVc6ZO4pGTKCYDoG2kit7rSu?=
 =?us-ascii?Q?J0JNhKgxvWw0mjYV+Thlb0gOkjy1lyzbH4Octwwr994f8uRYv/6zziqMzoGx?=
 =?us-ascii?Q?XF+/wbStK9TjTRKWAXKaaJx3hEmKRRqbP981hbOe6FD2pr/M6AagOLoyifQ2?=
 =?us-ascii?Q?AUrGHCiLi2V8ydI0CEXS7xK3DOJe+S9paggWPlvdEuv1DOC5AqwHU13TH/Ei?=
 =?us-ascii?Q?9pu+HHwsFXLuoEefVpYnpG1/2jOO4S1SWX/gxTK/icOjOhr1AdfnXj0mlc1c?=
 =?us-ascii?Q?YmPHAvYl8DsZ2Sh4nAV97Wua9efFOxTe/I02jHa2RGIL272zOiA1HUA3QrTK?=
 =?us-ascii?Q?71n5ai0EVOAtTGPJjhgZyqvw3fZ9p7PzFj/GtCVUF5VXfBKoouRIfgOJUOUW?=
 =?us-ascii?Q?JOEoWv8XbqTPYwx66YoJgMINrWJUBZOpzR/OwKEhnLfkgZGR16gWncylU8gI?=
 =?us-ascii?Q?jfp4A3I1euWK2lgBs6Q9CIlakUrLqK4hffIE3MVXRThtKjKlb763pl2vCx27?=
 =?us-ascii?Q?YA5aQHiGwgwknXRNqHdxax8iVo/SpcePNeKY60+xQ179gSJa4/OOHy2JrZVY?=
 =?us-ascii?Q?BH6tPgE4ibRmyVrm64RwjT7gdikgEMii8Md5FISopp/Y3gzmwiHlh8Zkgpl2?=
 =?us-ascii?Q?/hFr3opgMfD77ry2NOYPw5FhbF4NQEgkrRq/zHYjVzg9yiQuplGaLCebgMa+?=
 =?us-ascii?Q?2f01FSxnkOdtdngUmPQTLI1C71TtZAY8Elk/ENypbhetYiRMXjmj3Q52TmH7?=
 =?us-ascii?Q?mKihr9jp6KdY9XHA9rRQiAEDpKsyi0p9MJ6dEU6oJvw+Mb/MSJd6VW9Qex5Z?=
 =?us-ascii?Q?FJHC02+kVjhAe3MfyJv+KmcK7ULs0fsS825sOWDzdqMe7ncmNlfvWzuI65TO?=
 =?us-ascii?Q?oSicROkPHVgyRK6dH0EaHFrBVTDY5Q9DBuP0R2FfSVO6+NPOVTy60RJ+ffkW?=
 =?us-ascii?Q?h0mm8uAmiCSYmRM0+ORQV/sO0W64DBh5KFopdH4SCR7uY6hKt+Gs0nOw8fzY?=
 =?us-ascii?Q?J/Jpw//QoqiPScMyt/GqO7IwjQ54h7kw9I2DElXrmKPv2dgMGWbvDPgd915U?=
 =?us-ascii?Q?LbLHm2tmGFWz0032U6pycXrIWViRMkPrVYgNlHUErPlD5688MJ3Uh3Mzpt6h?=
 =?us-ascii?Q?Zbk2Qwk7Lck7APiz0a79xJlntnhc/9EaDnFclZr/mRvNoSB4m4XWhVfaFt6X?=
 =?us-ascii?Q?1PehhhH6prG2DYwVGZ5RRCkMH/oQ3VPDKglEdql9Ek8Sl8VlJQ0LVEkw1B62?=
 =?us-ascii?Q?G7mf2nBBpqNP8w3quTT4Zny4d+HRstrYgtdavlgvQGdHLdvUU/KXQFvqssVK?=
 =?us-ascii?Q?Ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J3UyY/Y8un5fl9YxloLGxmtojV0BqTOfHrxSC7l/xcmbR7vjxgS1DOsmFhHP7OT5NR8FPi0IKXxewJTWyX3ODM3CPLkXJ6Hl2GPxP5WKQQvDJCFKZRC6XgtDIwdNtcrfjDRlCq2AiDjUgkj8B6W9efov/GGad0HX1F9kiWURF4RCqsFmdJLDUTrzS58+yZY2F8cR2N7hTe44y66Mi1hEPKcqSxlgwjxoiCaOaPzxBAlMFC/vWmnbCNeXrYDODQ++4H9thkEhbhZCo7rE66mO64bZ1usT3gpXYRzaG9dftx2eFFBrrxkWHzZk/JMe6alRtrj9dWZL3UdgqckRAlqlRE/4aBLP1CvpUTgqUHhsJsMl12Ws/x9NwNlQBskktg3k0YLe+sKfS8JiPMWt3Na1VXYrYrSzKMN/lfY8fwOAjRq/NhgWXX9x+hKHsn3ihCFtBB3jw1RJsqZFc8ButJXQuoC6Se6x2qJP2ChM5qZCh33iJEIG2D/ItIEAxtpbozndgCe0fcm1T1JCpjxjnBeErl67fa4fC+g0cs5gqqDeJm85DYeWmJDRZvzBWNMylxLzpFQnwLzIt2eb79rY2ZoCH74chWrlH5ZN5XFJbBB6pqA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cdf6464-404f-4648-bcc6-08ddc390f643
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 11:15:53.2790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IDVC+I66CrR3Jmpz395XtfJdyHX+BMXxSyrf/7iNwpQ1jGDFSsyTOnG4sHpMm5+cmq78eFdchdA5k1dZreNRjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8140
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-15_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507150102
X-Proofpoint-ORIG-GUID: LrOhKvbrLATTEr6GVBey8uvJdYJ7YnFt
X-Authority-Analysis: v=2.4 cv=AZGxH2XG c=1 sm=1 tr=0 ts=6876386d cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=Wzbzhs0ueIasYI_dElMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE1MDEwMiBTYWx0ZWRfX343IAZRjDgAV g1r5QKyUYPphwGMppK8N/5w7mUbhZeScH2Rm06YZu2fCIKW2xt7xS+RccwY3WR2cne9aDwFoLHd 4eJ9NxP2u7Liolq6LaoKZdYrutYAjH47pqB2tegHDAMRYMmixaGlJ4aTixSLR7VeCXwJHjrAXpm
 i4m//qwxuSCiX890Q4uqrDW+LhfgBNQTGJDVOL0T0ds7taP2hkpAfn/FiWroO8vW8gu7DOOG+5w x3glgxdp0c8VEXm3ZlpBOBmIDiMNaxYLF1X7kk0MYbq+zYFQBfpf5ZUMeaPixNtYPlri/meJYoj isu8cEBXNSeTe3hyoKGPoQaXGLcqryPFKJntOnq6C6+eWxaNTOK8c/5YjImWw4zx6kDOA9N/F7q
 kHeFLymZiShn2XIT/5XWWkU6L/salWUIVZI6f42BAiAUegNkpLkUG+vqXePQBi98u9Ci30Mq
X-Proofpoint-GUID: LrOhKvbrLATTEr6GVBey8uvJdYJ7YnFt

When PCI_IRQ_AFFINITY is set for calling pci_alloc_irq_vectors(), it
means interrupts are spread around the available CPUs. It also means that
the interrupts become managed, which means that an interrupt is shutdown
when all the CPUs in the interrupt affinity mask go offline.

Using managed interrupts in this way means that we should ensure that
completions should not occur on HW queues where the associated interrupt
is shutdown. This is typically achieved by ensuring only CPUs which are
online can generate IO completion traffic to the HW queue which they are
mapped to (so that they can also serve completion interrupts for that
HW queue).

The problem in the driver is that a CPU can generate completions to
a HW queue whose interrupt may be shutdown, as the CPUs in the HW queue
interrupt affinity mask may be offline. This can cause IOs to never
complete and hang the system. The driver maintains its own CPU <-> HW
queue mapping for submissions, see aac_fib_vector_assign(), but this
does not reflect the CPU <-> HW queue interrupt affinity mapping.

Commit 9dc704dcc09e ("scsi: aacraid: Reply queue mapping to CPUs based on
IRQ affinity") tried to remedy this issue may mapping CPUs properly to
HW queue interrupts. However this was later reverted in commit c5becf57dd56
("Revert "scsi: aacraid: Reply queue mapping to CPUs based on IRQ
affinity") - it seems that there were other reports of hangs. I guess that
this was due to some implementation issue in the original commit or
maybe a HW issue.

Fix the very original hang by just not using managed interrupts by not
setting PCI_IRQ_AFFINITY.  In this way, all CPUs will be in each HW
queue affinity mask, so should not create completion problems if any
CPUs go offline.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
build tested only

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 28cf18955a08..726c8531b7d3 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -481,8 +481,7 @@ void aac_define_int_mode(struct aac_dev *dev)
 	    pci_find_capability(dev->pdev, PCI_CAP_ID_MSIX)) {
 		min_msix = 2;
 		i = pci_alloc_irq_vectors(dev->pdev,
-					  min_msix, msi_count,
-					  PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+					  min_msix, msi_count, PCI_IRQ_MSIX);
 		if (i > 0) {
 			dev->msi_enabled = 1;
 			msi_count = i;
-- 
2.43.5

