Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833F02571A7
	for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2025 11:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740398173; cv=fail; b=Rv2pu/Kqfjr3t+tdTP70DXWOl21Yl4Fltutwly24M1KeD3as06U8KkX383bAcqgvBRg3pjkVSLI9AJ0RKuq1LA8wdrGij+E4VoeB8cz2Vyz3Y9KmCab9MFEnumIly9QiJyVZMpvFtGiOOtutEbd0oQ1UUp8L/srrGiHZzll7cdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740398173; c=relaxed/simple;
	bh=UDTBpv+VCIrDSRBkxE41ShPbIHMSLKWT3GM8EGedB7Y=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Ce4w7w3ArFAlrbRhyw7akHMdx/8YJKdKSjIGvRNmNWfuiDe2HvM1FOUps64JEp6zXoHTssy9zGgh/6xW+V3vusZz9gDAVHItl3lpDvzIFY1bxsLLG6xcdiQvjR7l7jDdNMLGF2A5JIY4FY5x9+PQIhAYXNVt8VcPoFmpQuzYgJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LH7CLm9E; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VHBTK86J; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LH7CLm9E";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VHBTK86J"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OBMbZ7007181;
	Mon, 24 Feb 2025 11:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=yLkC9a+IUNVxdLrV
	My/UWSek4nW5ad6bpPrUyDSYYiE=; b=LH7CLm9EhHM52SZpEC5N2cIOuWPz48Ym
	XHjKcXau81hsVi+6T7z2P6uqL9eoImUDLqzhYWXKcrtcApvCvboOwADRD17sYaaU
	RFjcokekx/HKxtgpZQudPXwlqG1dkIzFXdh1ZoBnk/8mOxw+hmYt6xQrhEsuVx8S
	pLHbOS5FnC1WIExKKbS50fDrhxx4bbVR+HUFbn1rdpPkpu27RSWIB5u3s1joMYHf
	etbznKuO/Nf8jlSWS5QrQfqnzxM/ntB+txgVRopQ5atrR97+w6grjJr+4IaG8rDt
	NTDsA3ATQMuhuegydkC/j3YlBXgTYrpxSr1FnaWVHnsUJ/cWeRRfcA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y5gajdaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 11:55:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51OAlrql008186;
	Mon, 24 Feb 2025 11:55:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51dj5p3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Feb 2025 11:55:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tFFVrt5bTMefVlX3UB3wHEdKUnsT8GDe2evMg7RSP8TXURR5PSGoKt/xsju3OS1ONooFpl2uWkd5Opi4UV15bsMgt7XiCRJ1hWIlfBt15oa8kRLX4h9/9NSliKonERRrihDGneO9b+bnf97iTZL9qztd5VrB5Q0J/h1n5kIvoN4yjpclr8FGHcoUy7eiM9fE4WK3tHWTh48m5mHG84xMjGRP2AExx5Ca3QGC7enuQHB8NCWI7kf4aNps5n2x8Xwh82S4wH2KzGbT7HpR4sHRKSghm70IGxcbmjf7sexIctsX9jptjZD/bUi8Q/isCiBAAsE0klchqgJP7YyIWDnkMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLkC9a+IUNVxdLrVMy/UWSek4nW5ad6bpPrUyDSYYiE=;
 b=fSehRyQX3zz0kKJjWxg6TsYRDQjcSB06FxPjrBg8twygUVDQs7oOu0ehEuwR+HYTFhZH2i9T3veZX2wR6MmpmWB/llp8C/FFvuYezfHnjoCWJaj+kTaqe1+a3+OVWQbqBBDm90In3D0gnw0sHHhSp6266zF2nhXK9nZounnCXzIdJ9EyCROrERLWVYj5Sjj3kNFTYc/vmKz16MzKN079SO8sASHf17uwIrDPokMP43GczlOGMOK0MpVk2MUaDxYNEQwU6OXFK5RH9MeuLbVGoz9DUPBDrpTFl5uO0ggHP76E3RGNiHxKOHzWaZEnTrGNi0btQQTkv8+RASx43mbeeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLkC9a+IUNVxdLrVMy/UWSek4nW5ad6bpPrUyDSYYiE=;
 b=VHBTK86J1w0xWFpH0NAXu3/Ea6iqCKV5LrvErcOtg3t9XMpJssddfdTnluebuR4bYy92NCwKEe0PquZoEwllJXJy8zqeZHdFyFh6xDwxdiP7VKTkLboUUIKGgg/xH19VUEMMUh5NF/7hMCT+EGaeT4vHVlBw9mS5N5VsyYNcAhk=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7218.namprd10.prod.outlook.com (2603:10b6:930:76::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 11:55:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 11:55:25 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH 0/4] scsi_debug improvements
Date: Mon, 24 Feb 2025 11:55:13 +0000
Message-Id: <20250224115517.495899-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P223CA0015.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7218:EE_
X-MS-Office365-Filtering-Correlation-Id: bfb96e8c-12ab-4c85-ea66-08dd54ca2021
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HqUA7fLEwJwNGs4smkJyJghjXjWXc8+2hn2M369yVD74PHWLri939/DjyMI4?=
 =?us-ascii?Q?yvf8EUAQYBakYQx5X8qm8ckzgR6Uss2vZLA24iSVHGDFcBBDvHjvENsFU1jb?=
 =?us-ascii?Q?aIl6wmAwVxsCCDuFA0B0xv0kQ7QXlHVslYMwwIyFqqPsVK3k/tUHGomfHR98?=
 =?us-ascii?Q?W9FX97X9EQY76eVzwLbeG/9VrIbNm5mzEDsqjPy+PrRE+gSLS11AXne9rymz?=
 =?us-ascii?Q?Mhd/jrqK+ltmjVndHpqcFy3o3KeGgjsQCx6N0Iyl9GXb1JdWhgOtaZMDGBsq?=
 =?us-ascii?Q?1KqtMitCz3nUISAyYxCjUXQuRWiCsNh9Oa9fml0tSiUSXCvth3Qb3KXioHRy?=
 =?us-ascii?Q?Xl81mroDOVrUx4myW3/RL4UoWErWM5VxR91D+o/IBfUccK5U2RAoOWLu/2N+?=
 =?us-ascii?Q?b/xD3sOWDzOsY4ArIVvH5vlZmif80e/Jt2T5ZE6WW6QdgkHMlhJohwvNaROb?=
 =?us-ascii?Q?IgiA5QhlQGQD6WOyH7wO7dXFvY0Ka0Xsjoo/+IjDa6cKkw++WsEVF0o684Cb?=
 =?us-ascii?Q?1vT6OOD9jq11c0a9cxP44UfeY7SReLZZKg67u7rgMUz49c78D0pA7sdaLFzy?=
 =?us-ascii?Q?qy7KMa7qoP6sl4Ys7wL3xnvg1p1JyQPc0ugHQyA3i585UfvSH2F9vD7N5kja?=
 =?us-ascii?Q?jMumx7kYpVFF7RLEI6QioV93CFhbVnQqIHjZvY8qW0uoyjhBqC2rP10u8d1y?=
 =?us-ascii?Q?y8SBjUxWeY4tZ0Z1fbwi9R0eBhDo2Vboas36pGS4N0WHEQr7R/2WdbRkfEUF?=
 =?us-ascii?Q?tW7YK1n6v+Qg5Uekz4/uSiGydV2tGLl9QHFoFvZKhgvlTnua3C10KPI9FsMy?=
 =?us-ascii?Q?FbWdzZ0vWhdkJcwZY3COZT3Bqr0z11T5oQg1o6PzPIOKCvKedPz2/gpgib+7?=
 =?us-ascii?Q?cnyO3gCgB+nkJAWmg4JyLzrEYWo4bbYFthkI/SdU4fMmyJFdfy0E48nnMW4n?=
 =?us-ascii?Q?cglDX0cJC7kt4+8N0Atot4Edy6Q/Bm/eYEbrjf8bzXqwL15/+t8f5gKhe780?=
 =?us-ascii?Q?t2zbVoyk2sh4cJzVc0mBnQrho2xn7+iq94QGgQzprSani6V31TxEyipcjYOQ?=
 =?us-ascii?Q?eBB39CW2oWhj+4zxn/VGwvyG1QF9rITbMZhZ6wcv4Hc+PDoFnOCTEdltrpA+?=
 =?us-ascii?Q?NzAs4ec7zur+6NhGre+mcd40Tx5n8yUN8LW9+Z4VApb+HkT0Mj352pn2kKZo?=
 =?us-ascii?Q?sPxFka3pBeJp9FeBuqr1Pp1fZ/DiIsidyBNv24ka9sCHmonfrOR0S+yj+IMP?=
 =?us-ascii?Q?IS3XQcJPFMvAe5tTHisSt8OJ4Ai8drvm0UkoEO0hAx1ohnAYbvUzgAthpUcW?=
 =?us-ascii?Q?kYY/tYHnJCESDWxduI5WOnY4iakCJG6uhFYTXF8HM4Qxm3dfLbrukj1rHOp2?=
 =?us-ascii?Q?vXw7kA7JcEVlve4iITewjMp9nj+K?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G6qtkFj5PlKaovoPS83bvOQH1d9cH+nlVFEtvXTR5z10DleWPiTnhOhXeX6I?=
 =?us-ascii?Q?3PoL6m/zr6cTJck9YO4GgA9Vk1DCDiJ1KLrPdTSDmFpow+HpG7WE92GcwSjk?=
 =?us-ascii?Q?MdbNOdikAY4DJcRAHQd0ewpFLIBb0bfJxpZkKyxzWb8KBIekDH1w1SS/berC?=
 =?us-ascii?Q?2RuVOXayCiym/7eZYYf4Xqixsz8LesZJEYSpFlO1I3sk27rLxzo1J60UgqtX?=
 =?us-ascii?Q?8UXzVVmdztN2AvL3w/gJb8/7oqn4lDzpdQIa3Gl0i4kstwk1/wHjGDnc2bGS?=
 =?us-ascii?Q?JzlScAPnFIPPxO0TyuTR5ntLVgWK7pZ+b/6QEtp8zhvSMjSaQsn1riBfA2+q?=
 =?us-ascii?Q?/5XRw7NplO5Gi/nVk6n2P/hhXwI1xhQNRxMl5jmFcWXwaIu6zIsPeBhSrI/B?=
 =?us-ascii?Q?Dj7MVw/M6zoGmrml4cQQnGvDeAvQtJS9/ckqRSWKjsUo0KtG2Uqu2cAZP5iU?=
 =?us-ascii?Q?PVPUfL0KTbHGRwRemkX/Zi5WlHyLcqkAWc8uP7kCLtDBf8w9ljgXnpv6LRRZ?=
 =?us-ascii?Q?UWwqQOXEHyH45nFB7LVygbU/XVRs1USkV/MRfcHTe8VrEq14J77ulLe5hKeP?=
 =?us-ascii?Q?GBBa45xNne/FOLpbdVQ+EkW74h3ruBnSismeiUArNYIRqn91FLfbM2ddBn2i?=
 =?us-ascii?Q?TvfvALsuud5pAnlhaErF0vgxX5iea7rWPI3RX785d7T0G1+rK5L0G5sefI/1?=
 =?us-ascii?Q?jI4Lls3WVrfrkydXeNjBmbek6u1vU4ejSoYRaVNPTZbMdI8p3nkRAqql03AD?=
 =?us-ascii?Q?MUWQONC547fYjRzONxH4g7bvZ8sTjdMyUWGvRwB0/P/88g013ialfjWxD9l6?=
 =?us-ascii?Q?3WRC5edN+8T0CkFZdEuqVgwNpfYy5vH6xXjHgvRwXprNm22R5H8GrczBglug?=
 =?us-ascii?Q?6ubvHTT/nJXVTy2t37FrhDKaja8dyiN7/k2GPXHtH4sUuQq9zUtPvF5TmhgW?=
 =?us-ascii?Q?Zb8dbr7pYL2XWSwu6ig+rh+HxI69V+So4tXrD11tKUwRQ4bWv8vT854KbG6+?=
 =?us-ascii?Q?mQ9SzkgLjhqCCqC0NdvbC5jWEAVQ+VjknO9+AqUQdg07r0iWgi45GdfONMZv?=
 =?us-ascii?Q?naA291ByOsqt5s0BA6uQsK9ZRpN7sK5OdqM76INzbGzpbFxWJN9iZnToxDQ6?=
 =?us-ascii?Q?VSBPVDRghzpinRXfi1qkzn9/CIos36kCgtNraeAkOf4Tm9lKYNLYlYviY0Ci?=
 =?us-ascii?Q?7JduaIkY9S997xr5UYQm8kN+BbwZqCPVg7s3Uq30iSstvpqu6mFUsNceHpEX?=
 =?us-ascii?Q?fWlRZL1s/r6KpY42TwOl9VB7Ogr4//dRlRhN2J06hiap5KqEWVWmtvNmY6bx?=
 =?us-ascii?Q?Kl03rhXqsZwtgSlwKrMVPbOxVXPJFH2AKC7/pNmcohengVJkrig530HMYSba?=
 =?us-ascii?Q?XUq6AJsT7VAo7/UEyF7E495Icjg6ZaQIephAwVZTG5/WJoyN36SZIHVQeM+M?=
 =?us-ascii?Q?Dz+QCmVLN9O9pRz44v2LO5amXUDisdjrzK7dJDP5IZ4Gb7HyDz8PU2P/3CXf?=
 =?us-ascii?Q?UpRiMbvfgIMSUNb6UTBgrB4jt5kEiPwlr2kKfgGTfPF30XvY3P3aABpwav2e?=
 =?us-ascii?Q?DRUSlG9KetSB4od1vIFgt/Z1H+DVd9SgoBUMzoEwJx2rDSMM+ZdMw8BdTC1q?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GNwy4U1pgh6XO5zi+HobGmDhJYGdgx3/IzPJs8oyfLgsGhDi1C9pK8KdzKebm9dPVmLgWi1Upvtp1YJO/4E5zYrmKsGGRFSGZWmzX6WspU76vpLQbxtgD9nJ/pEM0W6qzUImci5w+NQ4r+JmsHvOqjqDGH+U2gZFbsD8LDOr+rc6jTJjc3zUAYcPSkFfbI7gAnJ5tHOyZZaZ+o9BQ4t8VlLXcqJwkoPRPG0SBpA+HaNHwmoLs5Gvx9Udipf2YaeX3WPnk/yJ2lS3VdMl+MheYagENUw381h9LemSxobrElMLRwxGZGygfeV1RwYnreKChr3SezC4shI59bU9Zze3Xt1KH5JO/fxnDuGKg5OSSFKzR/ZvHxy+R2+m2pOhRsdeOnoRsLnMF3VKfQRPneyrOgWrXRm5+OIS/hCpo+DZOy5rLGduYmEVEDnDm2waqwUsZiA21le1BpRugEFSXHPjbhs6kvTb4mjwUi8LyiTJnq0XloNCSTnq2AOXDry5LWBtKe3kxVKen2ixyjPcFuUru2E7Qz0jm2eXUoUH6Y9pAYBZyB8onfkHvRF/ASka4HtDRGdjKUODjChMcHvkAGOANyz0fLjbATafs89fM9our2Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb96e8c-12ab-4c85-ea66-08dd54ca2021
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 11:55:25.6720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: km1AqXhr3QirQ8dXPm5172ZTgVqOfuKd+b67l+9d2ZlZQcfIWnJXKPXvvhlR+UJlUxNa6OV3rz0M56SRWMpDMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7218
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_05,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=819
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502240087
X-Proofpoint-ORIG-GUID: nbW25LTklWdt-rzY0GABV-tIqlNSjXoR
X-Proofpoint-GUID: nbW25LTklWdt-rzY0GABV-tIqlNSjXoR

This is a re-post with modifications of Bart's series at
https://lore.kernel.org/linux-scsi/20240307203015.870254-1-bvanassche@acm.org/

I re-ordered the patches solving the atomic context sleeping and
simplifying command handling. This makes it easier to solve the atomic
context sleeping issue. However, it is harder to backport. Personally I
don't think that backporting is so important as the atomic context
sleeping is so difficult to recreate.

The main change in this series is to solve the atomic context sleeping
issue by now reporting errors back from scsi_debug_abort() to the SCSI
midlayer when we cannot guarantee if the command was aborted.

Based on 1d67c48947c6 (origin/staging, origin/for-next,
origin/6.15/scsi-staging) Merge patch series "scsi: scsi_debug: Add
more tape support"

Bart Van Assche (3):
  scsi: scsi_debug: Remove a reference to in_use_bm
  scsi: scsi_debug: Simplify command handling
  scsi: scsi_debug: Do not sleep in atomic sections

John Garry (1):
  scsi: scsi_debug: Remove sdebug_device_access_info

 drivers/scsi/scsi_debug.c | 153 ++++++++------------------------------
 1 file changed, 30 insertions(+), 123 deletions(-)

-- 
2.31.1

