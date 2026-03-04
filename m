Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33AB33BBD1
	for <linux-scsi@vger.kernel.org>; Wed,  4 Mar 2026 16:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772643254; cv=fail; b=TrdW56jQOg4sLu3sFtftqv9J1PhCeq4uSSaKaNOlnrOlk4CNGXuZ6XLNcvOiallxMkt6kFsDc7y7wpK+NXGutcXA8lsqsFR01Euk5RR0cf/Gj/kpSovkPTTVTN9pzXid8OXGNi2d5976G/SkQjj6aPWYY9mD7tItfwSxq5rZK7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772643254; c=relaxed/simple;
	bh=CDlX9DuHBEjpl/xCYgQ9nWpDf5fjD3piQMPty1Cfong=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=sX7qeEhXzqEvGxeNgo0KX0BYMlfGHZlyCIydB4I5Oxe56+EkKmYVtXXAxi6lplnvROWyw3NPsmAzqrnikqgKqUF/IViCqfxNfz5N8aJ/X4o9CICX0MMlhf4+hhcGSBkCjWO72QCP49p+i1PxqZD6WDawlrmtoi7n8PthR0VXxI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ex7gFlCS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ikqh8ePU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ex7gFlCS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ikqh8ePU"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624Gq3tQ3135453;
	Wed, 4 Mar 2026 16:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=z5xlQ1rB8INEuI4a
	mGY+pSzE6V6DTXJL5adIF30a3L8=; b=ex7gFlCSajitBy6a9hF2DqAz4+sHehH4
	axknAvVpYNCSKsmVGbCagxKFl6sftbT1g683R7oMU+Uda7PIgbWHmdcIrK97G04d
	6rk75FWY3/HkS6anE3jHN/eQVesJmwYQpv2BLKN2RaYXuT3Fzuh7kVnqQnHckkVK
	opQ1zxwlg76FskEYBmQtXjMPO7R0dk6StWchC9QJpZZhZtmdeMx9xHPewiGNAOFi
	xLAjm5Nf+xqWIZJBD9MSXL8lFeMpUvde+PKwpF0MUNzLEJJJnBy4CNTxGpOhGxx7
	8itbndspn+cXuRRbVkO8R1u6XIL4zV0ODEaqx5fkzfuuIQLVFzNYew==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cprmug033-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 16:54:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 624FaQFY012984;
	Wed, 4 Mar 2026 16:46:10 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptg2ghj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 16:46:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t/sKZllFFHELMo5cZpTcllmPSbAHoDkn5rCiHI9kFtfRTqSgnQgboTfs1mBvcpxawydf4HBM4CWB0XCSkroh1SeIUwhOwlTrUAWiTcFST1VunIxeym6CUiH+baJWIUe+AIW1sSiihqvvZVQIBbQ5hJ+cO+pK1n2ZMbOiyUT5iVYt8YcFWetMFjQxMCtU0RozRefxg+wbjo0vTUuG1SxG+K4G86zf3GliRxva0aMA6kL/r1A+OtpM1g6bEnX/2C5gyN0c4kpBUz8MNS2ZTZt5DxgegR7+n0xvjXWrZzF/21EGfmwZpCrflwWE8ctPCZTDoQ1SqHYQEU9UyPD5wu8O5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5xlQ1rB8INEuI4amGY+pSzE6V6DTXJL5adIF30a3L8=;
 b=v5H8O9emvxkb+M56G0x9OYz4BvivQpXXwjAyUqmMdolFfT1DjIcjdM8yQSOst9YDpaAEEQS8KSMYv5FM1dU28yvaWjROUSj7nlzhna2FKlRqF8BE+DeWzFnTCRkBofbqvPms/Yrcnwd4wpILUIrYWkXNweYk5Wh6HHUxbS4YgrWM29e5LpD496O1dWEtOXUZlGhY3IQbWs7EzGptt4Qcla4wah/86MUsdGzH8ZlEqG6k4f3YaWcj67p/1s3l/KHRHCkxDcq6MlTl2FcnECm43DV3yu8OoLTlwJmeOJtOiB2kFWhpmmVLKztBEpcpLeTKnwUow6esinpJikTZUwWSXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5xlQ1rB8INEuI4amGY+pSzE6V6DTXJL5adIF30a3L8=;
 b=Ikqh8ePUX4dVBTffJTDm3lRedaXyX9JN5lzYdLqbZOK3/y2M8m5jiC7xHER49F2Edulh+7Hw0rnOSc6ziUxMppHFsL+DO8E5jvLLUCWHpZr6cKRlxWvqvQysSXAf2XvcfI9JxZ4tyjH9EA8nkrmxUYKk6wX1SdItDL2RM/teTb4=
Received: from DM4PR10MB6885.namprd10.prod.outlook.com (2603:10b6:8:103::19)
 by DM3PPF9E376D9DC.namprd10.prod.outlook.com (2603:10b6:f:fc00::c3a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 4 Mar
 2026 16:46:06 +0000
Received: from DM4PR10MB6885.namprd10.prod.outlook.com
 ([fe80::544a:41ae:543a:f8ba]) by DM4PR10MB6885.namprd10.prod.outlook.com
 ([fe80::544a:41ae:543a:f8ba%5]) with mapi id 15.20.9678.017; Wed, 4 Mar 2026
 16:46:06 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        michael.christie@oracle.com, bvanassche@acm.org,
        john.g.garry@oracle.com, junxiao.bi@oracle.com
Subject: [PATCH v2 7.0/scsi-fixes] scsi: core: fix error handling for scsi_alloc_sdev()
Date: Wed,  4 Mar 2026 08:46:03 -0800
Message-ID: <20260304164603.51528-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:610:4e::23) To DM4PR10MB6885.namprd10.prod.outlook.com
 (2603:10b6:8:103::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6885:EE_|DM3PPF9E376D9DC:EE_
X-MS-Office365-Filtering-Correlation-Id: 83ddad9b-1149-4b44-3c33-08de7a0d876a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	T8OSTyweZ64dhS5M0kZbK4gLmCS2CqmHVyX3qFyUT+q6sIeKrnNR5NV0itMBKQHrfDxcH24eC/Ozg4JkUlz0Do1KTMah9Rc4S6jm7zgFLvSR+Pee4h6R4UdUMAXOLQTdLciW7mxpbfcliXcMHVffsbN42gqmKIMDGHwMypKTU4R/f4WufrRnpe9RsL8dPeeEc7TrAbjd9pl5yX2ysD0OqPblg3S6JBwch6ZTgeW3dUa5aIjG93xx61jVX3df58rkFUeRza+0JKsm6nqm2JgQXP7URcOMAVfxZ7XKB2NwORVmmwcTos8gA/pd02yRf+KbfxrveMj6SKT+nqom/oLTFwX+DbqOd/DjgWRjZ76JAwFRv32IGlKGKasPF+hJeA/XQmN3x6c3Ibj0t6Zvp4k8I/0LQ1TiFZWXjZZFbXYHqk8ZExhj87wdXccnAiSHo2CHT+2DqEI5qj0px430GDfMI0KIeAI5SdDTvrxSm8O5Jj5bAFFVt24mFzvlQ1pfcR3IY7mD+lb3IaAz05qDZI2IPG4bteGVb+AUc9njcBK6GeJbSNojcALx9FsCU4uQyM5FAT8AnVdqPgFV0tQXPTQutHkWHGqj+RGLCP7gPHjRBFpDKDSMzZH2mZJSN3sRTSPO0FQsZTf/TnVoPfE+0ELgz3dSNJRk2FYbPSLBRK8CgC/TMHKXPy+hEGZFQLkryYcMC0JfCk6WuNDER45uFDvnkWFm3du1+c8Q9Zqev0n9CQ0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6885.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LInAVPZDitXfeAbmW5bZM3EsAMLHHWsoULkYi+LJuhlzm2URhyufqAeia5oU?=
 =?us-ascii?Q?Y76Ldibc72nR0W/Iio1MFZbVz33KzMRxuntaNkDeAwqFvTYPPCQ0C/aCoSJh?=
 =?us-ascii?Q?hG83O2DlhDSvpOGprmLCwPfyijQombel5dKR0ph+ITtxrvH4PKz1erR5Cf5b?=
 =?us-ascii?Q?CTWHjIsNuytifad4f8WKcymg0EM1SgV21uQCTdxvCgsq+uFOQnaZs2S4ob5a?=
 =?us-ascii?Q?fF1YkKshV/9AinkWM5WT/hOlkak6Np6l6hs1r0HLJWWYPftf8FCkUl9f5SnA?=
 =?us-ascii?Q?crMojx8MLO1jBHA4uytit7/3ilxQDBWML3NM/nyM52ZzgE/Bl6lusePIr/+5?=
 =?us-ascii?Q?5yqEVpoQf7f1xaIK+XOsOrz/jEjIp3rsbi47UABg0e+cVk4ukBMNRXNbs7nx?=
 =?us-ascii?Q?PMdhWZhJame24BGMmtFpY4T/SRh4vx4aMbF/67KSjBKajdSSsus6kcDAkKnL?=
 =?us-ascii?Q?OyBrkh37TKEwjloR7yTdsIEkXlPMLiDA19enVKIIi3EsCFklVD1J7FFXNKUq?=
 =?us-ascii?Q?A9P24RvGkba3SFllvcAyHXU/AXiibLV3EFjokmpmN2wJ3HLGRXYhUrYJEjPn?=
 =?us-ascii?Q?NT2PB4vRFgQGpUjKdbiS3csR6UA6BHA2KESCBclb5R0/NGgZGtuq8wbRoVNW?=
 =?us-ascii?Q?DXLcTFHl9cZWwh+rSxHwlPSfuRKakZxsgisnBB8DtQ8MBNHZO2zWezkZ03AB?=
 =?us-ascii?Q?kV6dYnodAxSuH/EK6NY038HOr2vROLgHFLm+jZQO/E8POUzOnz7Jo3y38c4k?=
 =?us-ascii?Q?DU3GsG9W1gom9Wa82w+xiLlX6DbTXh4a7+VCf4paFClISlKqGQb5YLfVX+7d?=
 =?us-ascii?Q?rbJ6JZ4+nv+A09mHWaMozCClTRcQWExVKm1rO+BeP441R5zYydzpGanebumy?=
 =?us-ascii?Q?gjC+dditdiYDuk6Ox9011MBQiJ1kKrGodes9mP09mfIO++Ip9YtIjT/Xn50w?=
 =?us-ascii?Q?XmIzUye+2eLQd/ApZMi3LfH2FoESPWCnuzrSFM8nQNpWhjmIE1mL65cScORH?=
 =?us-ascii?Q?+8Ilm6Juw55L/ntMmqfGwwWrw5kZGYkZwUasaTJpvPfMoqBAnz7sZJ+RgmxD?=
 =?us-ascii?Q?Rea7g4CGsv4KskKtwAwg0EQCJVQWTae/xUB3/A8OXtK/3eFQ1YCqcCgW1faR?=
 =?us-ascii?Q?AH9nAAu8lXsF2MF7EYnpDExu58Ny2oWZ31/DQR0wBBW3hIF4QAtZLlUPimKM?=
 =?us-ascii?Q?ivF7lXRrtO7I9ma9KhJnumdXqeN+2uzDeMB6gdlDDFrhlfa/3uRyjOVfPXLA?=
 =?us-ascii?Q?35V9UUpx7HOrBXt24hC/FUYbJQO7Rphi0IHmopv3CPkHUU4pdHHuFRKsfCtZ?=
 =?us-ascii?Q?t2IetSJqlrnyg0cF4UMR9g1u0vjEWk8PTscltygm37uEsQxuORiYgJw8pjjW?=
 =?us-ascii?Q?R7/aBd/pPZHAerJUCDbhRjzt0GD6n3cWZ2cNEBjwxQ5cXYwrSld4XFiqOq5q?=
 =?us-ascii?Q?kfhcQ4vnwHUBZVrHKA4XaHtVlfmIXtWYKAVtDNgnkKlVwT6mWIB1peknxZHU?=
 =?us-ascii?Q?RIaM+bc/A3hxH8MFnU8A+Bjd9/O1Rm1K28OpfWzZkvcUUaiAnKbaWDOx4d4H?=
 =?us-ascii?Q?aiHUe9fJrR4807TW1e25GlW6xblnMQRohBRGXtqUAOxSN6KexUHqssCMFe3V?=
 =?us-ascii?Q?qA88yCsCAEK38/YlHr0zC69+BzgVEJtNQ6PUuvY36CqZWSjDi6RFOo/3elt6?=
 =?us-ascii?Q?zWoUjJpqlQ3iKoWrJoPGVZWL44z+onJr0ZmDR3hbGZKN6Dy78DQZcUDUIeyx?=
 =?us-ascii?Q?85pmRXZloA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	R2NROkOJ3eDIhw4W8HOkE0CnDHAgSx2QTFW5IttmbAd0Z4RBg08z2XcAcjQl1feKpVSXs64yMeAg2rwUCaLr3kiqtmx44GZ8sfIOiiBq47YOycsBu6KJwfG36l2ZurX8prbQxhoJ84jAVMkzqOV8aQJK1ntGsuL61AVZFJX6PLwvV2wxbDdRbA7EKsGWK1Ii3D+Qix9/GW3LMrWlksfMXEorQoqTIJE4Py9M3BBhMV3y1hSOiVplSzP9HZPyI+tkw7ymFVC84OGOjgVLm78v22UfrmYuy8HoF74wIev75DF5Iu4yHuUFhU6EBVcV3N3j6xcH0I5ZvJN51I7eoAP7gKiz7JGdbvv0WIoRB4g0oqQHWJPOfG88G8Gh6+YAU+FdZWvhEXjQe9eo8yMUl/GlL0XLW1vmQAqcUBPDlcyuKUUNnLfIvCuK2Il01u/uaZMbPisCjAAC0XxQqEjv182qHCZZR8rmQIMChhiNEapC5EESweO7po39CsIA3OORVnTEPP29wajzY/kBiGDETFWrDtmnTYYsY0PrlJ7UrYYltSAFFRx2h5tbM9u76R/6Rkn2FkHfRpNitarqgoaC/hzUmXQb1kuA6tLsKV/gwttkRXU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83ddad9b-1149-4b44-3c33-08de7a0d876a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6885.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 16:46:06.1446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W7CQsFSFkLM4gvSOtq5Wrek2AHtehN7GUVwFGXHtGUYi9jPswnlj+8jERCCwLu4Jf733lgl1Y3F2w2HA4efT+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF9E376D9DC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_07,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603040136
X-Proofpoint-ORIG-GUID: 36bd4GqDOzIk4U5S7EUS2yvkxUyZHbXt
X-Authority-Analysis: v=2.4 cv=SsSdKfO0 c=1 sm=1 tr=0 ts=69a863af b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=XQymSECn9o_5sHi1UHYA:9 cc=ntf awl=host:12266
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDEzNyBTYWx0ZWRfX/K9kwCveUD2h
 qji44n3gIdPcnTjCnSSbh88WNY+u6kayrwGbw0z635v0wZT7D5voJPDpxgjuy6t9+VcOtootM2r
 OiejaMsfbMOdk0n5Fr+APiqKexvY81iQcXCLs6Nq6z4ZXn2vaTt+xVCY7N4EHAWXDZg460Wr3nO
 E63wrwBt0YrL3laW/CeMA4LB3VrBAU8cv7+ND70hEbz0nTk/3xqGe+FHSJagAT4mjJBZqsMFW2M
 +ANdp0T/2iH4/4+EvdTvwZzkwmtNVTXe0eMBYZMTKSHxi4bfc/NvEzkv0aYXTMQ7JmJHFu6tdr6
 26ItBGINln6cBTeyXpiF56H86dkaVDJAj+w5d7857rNc5mtU9UHKjOeVy8r6LCzbp2K0MAtvcJc
 y7HHhrlfJQX+sYnZxsod0ZQLyXBVVXe6EIotUWEP8v/YHIrIPMfKY80ZlpdQs9fceAs8bNGRtSu
 EXyUyksGSJFxtdxBIe7VJOiHfvHu8rsKTSVF4VXg=
X-Proofpoint-GUID: 36bd4GqDOzIk4U5S7EUS2yvkxUyZHbXt

After scsi_sysfs_device_initialize() was called, error paths
must call __scsi_remove_device().

Fixes: 1ac22c8eae81 ("scsi: core: Fix refcount leak for tagset_refcnt")
Cc: stable@vger.kernel.org
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
v2 <- v1:
 - fix patch log

 drivers/scsi/scsi_scan.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2cfcf1f5d6a4..7b11bc7de0e3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -360,12 +360,8 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 * default device queue depth to figure out sbitmap shift
 	 * since we use this queue depth most of times.
 	 */
-	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
-		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
-		put_device(&starget->dev);
-		kfree(sdev);
-		goto out;
-	}
+	if (scsi_realloc_sdev_budget_map(sdev, depth))
+		goto out_device_destroy;
 
 	scsi_change_queue_depth(sdev, depth);
 
-- 
2.50.1 (Apple Git-155)

