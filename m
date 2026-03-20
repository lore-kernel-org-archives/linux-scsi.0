Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9B11C2AA
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 02:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773973588; cv=fail; b=pqT5G2GM9HTTfXTPhQSw5avBG5OngSC2wT/qOYA6MjWGu8wRZ9LnPgBV2CqrZSFAOZ/ia7gGVTooQqhimXKUD5TpiRtoUGt0ZIVl0OgkpClJu48/WcV1MHFR4vSJnAyoyiIzFgX0alxHoS6yX8OI6Zx0Ejm/y11pGxxknI5k+8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773973588; c=relaxed/simple;
	bh=+xhVd2vatHmb2Cy4HjA8sQdehVg4EavQCfy40mB0AqY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=IJIyIKY6r/HR1PcWUDEbl2iBJZXZ6xHFV12hcKTsTOsnfdFlXZR31jGGbT1yjkUYWGG07IBHj11kQgzWF3M14lu+1jbU1tFOnznUzAPVw4jmUqjX0vfC4k8wlR0FQYvsk4kLbVOXp0MqCaKd/IzJtObeEnUCQJJ5CTa+MmKRKvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U9J4KfMT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X2k1h5v2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U9J4KfMT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X2k1h5v2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JGqLiF2096857;
	Fri, 20 Mar 2026 02:26:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=O63624xWmsMfUlULpA
	KWyJwxHeMfo/VICKFz5KfSc8k=; b=U9J4KfMT/rvHsELxVQ/SbP/hQPbfBZjNYX
	LRPQFcEA6B9fJcDkLhL3a7++JUH3Ela69Edbkpo4LSZWD+S2xBqnQoZQ0Hk4sz2L
	onCvblqJBBiIZiCT2+WpVNmkE4RI7+O2gtKibwGaz6AHL8mH+iv5KSJew7M+Vzzy
	1fhC2PINEQ9K+0aecBOtagn/W0gkbBTJXmvyEM0PMcW0lz+7Ug7OWPQ+kvlfy+4f
	U7pqiQc3YXIk8msEBFSwaO5i3N0vHjwVYcbmLFsctKTLS4D54xwCa8FjcRW8Uqeq
	uaIvcO/d4CoW2FJWthkINUhuDx7GM5ZNirR8LE7c8uAI5cQ1XHqw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqc0uxd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:26:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62K0eb6i003406;
	Fri, 20 Mar 2026 02:26:21 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010056.outbound.protection.outlook.com [52.101.85.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4dp0m2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:26:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AhzkjyVFHUjaApNzW8WaeiPkF4/iLSoJCfOBYH4OzxIwxbVuTmNw7pPkNC3WoqDEnRxDf4wTt7Sn8kAgyx8imJIx8iu2A1Nre7wmCN4bk7i/fCDD/zyJeDr2pfaU/g4sVL1WxKya4t85GFo5pYSpdIvW5OSbqRMyCSOcfhIAF2WZeEOzap+pRMGefHgqlUFL4HicrPAlPo8ftFj9ub4mWHaH8soiBHv9emH31CVDT+RwLiZZBcXAPjHLq9XexSSsMfub1yIjj8BLJ1Yp8VWKWRgqM9yAA6nZiKFeIMWEI+DUm7Mp+x3c1TN3tT5DDH+V5VdZlLHryg+cR2iRQJlCRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O63624xWmsMfUlULpAKWyJwxHeMfo/VICKFz5KfSc8k=;
 b=ZmG/VtOGQ2Yo8y0fZUutGq6RgIOoTkzPQIEUdpiutmh9uUOL0WQiQT4BijYYxR4pS2Lk5VgE1PRX+HWKhVunAuHA5r3dcA9uPwNd55P2BB1i2/Ed3Y/DVSD8zmG22A2WRB+PlHf61Sb2woHPG8h9YnQnDzdTV5fPhgzr6v2e3ryvCCgXBeNfR369JaERXqnzvTOWt+tG1xecD7ZE+GBLD8YzPrMqvbWVpK7m1njhmalIE+rA2I7eKN9oQgEa88KESlCOj4lQA7ONnbt6sDv1FNu8AA9NXm8w35nlFfOFRfY+Ftn2us34M3IdzEssgpWZBhF3sfzxjc8WaLXnLDYX9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O63624xWmsMfUlULpAKWyJwxHeMfo/VICKFz5KfSc8k=;
 b=X2k1h5v2R2o0pd3Va21GSBlZ7Bp1hSspFuQQHQGXdE+ZRA8dKpO4ny9AGYhWEFgTvCOghBfBCs9q/VLxcI19D69t5qj088dbf7yNnAr9CayjCHOVAl9kPgH4+urSjpQ9CBiPKRL56iIk12bHE0zh01vpsHWwi+SytDardmkRuwc=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by LV3PR10MB7747.namprd10.prod.outlook.com (2603:10b6:408:1b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.23; Fri, 20 Mar
 2026 02:26:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9723.019; Fri, 20 Mar 2026
 02:26:18 +0000
To: hare@suse.de
Cc: linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH] scsi: scsh_dh_alua use the device timeout rather than a
 constant
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260224010754.37001-1-brian@purestorage.com> (Brian Bunker's
	message of "Mon, 23 Feb 2026 17:07:54 -0800")
Organization: Oracle Corporation
Message-ID: <yq1se9vjl0l.fsf@ca-mkp.ca.oracle.com>
References: <20260224010754.37001-1-brian@purestorage.com>
Date: Thu, 19 Mar 2026 22:26:16 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0010.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::18)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|LV3PR10MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: 64959683-66cd-4299-9029-08de862811ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	B7MQ0yrPjSP4XKkxWLS9rNpu/yuz28FHyFami0MXRuqNidpVGSB7IFfPWsTGFk8Be2QH1PrJxhKKVf4LO8jdrmSw5cAWwIqKNGUPRr4/HgwusIVS74MDzsPypfH2L1bT/TtfEUGtKYepMMxbkPrg9w1RqtFTiw72a00CyITLKmrS9IJNv9+kEjNB7Zx7AK4toihre8pKx5RrIMKrG07gAViCRNBk9FSstmiOKvg6OAUvhc5fMl0pvZ+RU73Wmfiw7nnDRnLWyfhkcr2Rq4sJclxg39Jl+EsKw9a9Pk/QCH3OE2UQ2/TR66sLu1P/mg50j4nAmGEvv5oMIGZ9EnsycpOG2AxqqzDFk9KWF5VUGLVhYszMg3wlcal0ckbGw78HRwHSfD2oq7c0QP8bdXZlhnLketSFKHvEy8XeL7WoGF0H6p75FK+kzDG8AIlXdwhFnXcSv67FXvlYR2OKyjNVPfXbuE7tLg37rHUyacWoNlwGKUlydL6OfH016Y4bKnC7c/7UV2FvvcGiBYRITwF4yw0P+heKHpCbtID8HQyUwJH4etAQwZtp1oV0vAWLveAUfcOlvXfRFJZ3XQrPEYWIAwdsZ0VI12W46/P6t5NG/hmYUgoJ/BLlwaZ32t0d/25IPU01BS7eGWXXiVjixGofLCvJ6oLzTAPTUCO3XIdjt/pz77hl4iiksbKjNYc79iKiTQkRydaXnBKlFAgIgBIEarMbP81NcuFIOegdOkPPIWo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?01ZDM/lRXec7flfRMngg9UsuAFI/pQho1hRaCCOBnbNQbHYGHx/DEEqGMDw8?=
 =?us-ascii?Q?ee6XVe1gZNrW5ZfFG13P2BnDw6NKzEr3KXEaGanmPLHFsHNuxzF3+uEkatqh?=
 =?us-ascii?Q?oRk4oB8FnX4aVjjdbJgRgKm8ug7RvecGIGlkMfp4wGuSYrwF5Yn4+zWHuVXA?=
 =?us-ascii?Q?3Kff6h7kmWTC0Y8p//FKyRmab41EXH2hMaZRwOFTJhZVkOkEQOuDD88ZfhgS?=
 =?us-ascii?Q?9FU4k2GCmtNID/I81Q6oV0oUBGEaUzSZE2a0yE73gWaj4Wzxa/mBGS9Vc/ZN?=
 =?us-ascii?Q?tPDam0qkTvjw+/oNkjsix5Rubt+qphbbJphyGRhuB4+Qr9PjJ5X5DWcIhkXb?=
 =?us-ascii?Q?vUomAr7r7tfc9AKdqg88aRkz4vmhh39Yz4eQGPBDiSxA4J1UCSCnMmMeSJ7u?=
 =?us-ascii?Q?vcoGlsNXCMpsYhJMzVufoZj/dcA0x+O+lYI4xrg7bueyEzDHOg/8HLAi/CV8?=
 =?us-ascii?Q?yVsogbRWwlmstzovDR95jzJVizPZBkFF9we7Y8CCaYwcQUC3ewMadTvMBOGB?=
 =?us-ascii?Q?f9DxWAaMuI9YFksYYxBTV3Wz6j0fpw4fB4obfcNy1W1y5wJRKSK+cydf42rs?=
 =?us-ascii?Q?737OEDslzdY4MHcl/GYpi6v7zfxcS9l011G/ajIBepi0Av6lq99r8yDOjcAj?=
 =?us-ascii?Q?2O0hc8FNVSDlRDFvuSQx74V0lw2/KigM13fBcmHNLVcNz+ce4Zm6n4zUyR8d?=
 =?us-ascii?Q?TC7SIjUac5NattTf1WqYQoS7cloWnrfkXr7wnG3mjrV+jxPwOYvGWtRuxSyg?=
 =?us-ascii?Q?fZ3xah0n0qU0NS8fsK8Pk+B3ZVUIc58Qw7lAJdf2cIODnQ3fwB971lcd09Zx?=
 =?us-ascii?Q?ZFNXueyRiiOH20w5YF5u5jZBR3UNYaItWRwOd9MF7ly/YKF23f/+uBWahUGO?=
 =?us-ascii?Q?PcabFMWA69lUsLznvHECNzs3XqCJp8dwkH2T1sQrayWFXSY8FMsumNR30TfM?=
 =?us-ascii?Q?JBhYTgTu3RUyAUuNIZf7bE1mJ2KeeohSe9dBfeLKOiCzCDkoF7FuenXrfRjB?=
 =?us-ascii?Q?hSU0VZ57rsVyvEhmVLGTcN2Sbj66lEJ1aqiq31e7moGd7DRhBP5nC5mCv0NQ?=
 =?us-ascii?Q?AwUPHJcv3DntAQqWVHZJ93x6Kia6cGikNa4HoErAhCCtJnIGlIF7CW/5ZVjz?=
 =?us-ascii?Q?37iHE62Zk8AVLqRGctSXXvlsx4sDYNwn/JMYaBWuj6zdsy/VNv4YQR+6sP1w?=
 =?us-ascii?Q?ZrOdzsW2VppJexXILDAyM2eyyr04Z49QxeAnWcu77Ng+R+9fNL1OaPFLA4Wo?=
 =?us-ascii?Q?YK9OQViVQPfcuISRpkQ1xqms17MOjasrRsMaNOetpUgMP90cJtydNkjYYwE/?=
 =?us-ascii?Q?nHQqNmJqm3Qz7IYDVA9Vgg7EZo2Wo3UXsuvUsP6gtCd4nL9GxVYwEYIEPpb2?=
 =?us-ascii?Q?AenQoMH5m+P0ZpDZt4IARincd7mdmZD6ONtmHx2IwKlSErHAxtV6+hOOgnaS?=
 =?us-ascii?Q?Cnh/jyBlInmQzZ5jMraw5mBE7HmE09Xm8bRc8LSM/053IeHywhK2lMghUmtu?=
 =?us-ascii?Q?i/794Zr3fEK/C+JaM9jJkABN2h82m9gyG6VwSj+gI2Nx+n5ya0nX7zPrt3xh?=
 =?us-ascii?Q?6CDxVmKZw51cIQH1BbeeJNiwK3PqJCRLMhJUiNbctjWih9CQINWxg4EEgcb4?=
 =?us-ascii?Q?sqIRJfdeb+uQBRwT/AQDw7kLh6eqdMG8sU9oH4Q/1v8Q0ncsBOtboz6pZ59X?=
 =?us-ascii?Q?sa8LpYv+Qv15l1MNUxJV5K55+gN5iuLPteUb29kuk844noV8hXGwrrm/EJnr?=
 =?us-ascii?Q?K/DPSvG4M3yLhifs6nEqnbLd7avdY+0=3D?=
X-Exchange-RoutingPolicyChecked:
	FPMNs5gFY5e7LpTOBf/Y0REvNVfnwtyoE9y+zSw4peMQXzmPOCLVPBRYzAyHqskqcYyrpfB1r5tXLv0KdWOBnc4tHA3fxptR7kO74+mG/P9qW8nNhNOLjy9HfStrqhoK0u2P4yHTtsq+BfYhJM/ThnD7AE/oBUpL6vi6Pz+fqejxxJw5qFswrTHVUi3t70Oazy6BwOt5AjXm0NmzWV0q/RPz/nex2ebmaPWkJFKIkSNsEqFZSpk2mJDrBFH8AomdpuQjHdchGPgtJJ6vXp+ZxV82niNkQIeD7Ti7sQFjBWgK81fSFbiVVeSd4Xzp0TL6OH/RtwDj9K0xZp6Oxtr4ew==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1i7e09TES1k9aA4fmg4EpU2Uyc9EPoSiPVu9ztr7qIe32/jOtUApIHOY0F13/QO/Fvxp9zyrVAxri48joS/0lJEdGMKgExIjnNw5KYFyQqJFL0HmSqHVe7HEDsek3rVncfRDUWjHBF1qcnFpd7I3OXVOvgPoHQ9zbHIj43vWo9bhAyar4b2TJHdKuz8+zi2aXnXtBa7bi2yz2v/Kvvvosd7nlEyWw1NK5KqBRun+SyfZQOZuGE3ZCmDpE8Y8gP8ir0tbctPflSeFDsuL/yoZvJa/oEk29U9A9tvf25nSx6X9hjuVcwtw59p6Uq+LXzvce3j1aqxQ1ctnBwumLxg0g+QLZmP9L76dIodaWAav73brFsdo8ZwLLUCMQ1lFjynyibDApct9naMLFzAWu0J3FRZUq/ILsmnme0pbgpFQDRJRs2KHGJVUbI+ZLk+0dU+QEMBOBwkiHqMUfGSJaOUKUFfS8moUPSCKdwrn7n1noNoqedkBXapipGzkyrQPE3GZLMJp/UyGpBOpUQTcBXV6nBmPbkAMPgaXZrGw8d6cluepIK0qtLNGVF8+s8+7b9YiMTBwqJ43pJ2izhxdtqrGMshfA1TgRjPuMDc8Mc4ki5s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64959683-66cd-4299-9029-08de862811ab
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 02:26:18.8503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b/yNl8gq4GMe2INMgQ5P8fjoUXDy9JqaJ8t5YktJRpSllFfpl+L+uVC0onrT/U2d3wm/B7BUoHAtn9aoFaoNa2vWGIRMgabgGR1hNDUgJEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=596
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603200017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAxNyBTYWx0ZWRfX3p9p6ixRIeLd
 etGqJQ+p6Vqbh9vuOcJtMPw2urrL8u6sUx0qH/6fIlOkx0epiWofHlYWkIfPuOyzPON/OriLtET
 7+le/kwpI8Mt2fkLmdUj3BKs+6PSsR6+hcUq8RZ+iMVe0Edjttugc016VtSsRaxnBa6dgi9jdlV
 zx7D9NKszBqlok1H0/dhZpqOx0U3ZVhwauwDkWnnFhfeLc+v3CrbEsyFG6oJKbfDDEjZLI8kujz
 C1morBE86mqm6ZpF3Pqtn6nkEkGgB0ZRB2eXcjcOK9yXInk5Lg6ixlo27qDmDg4b0bAaf53xkqb
 c01vMKfqVRmU6WhAE4FfM9lOlnus2KpXSKAP1iLwPxrrXfVeqQ42bJJT+w7KW+RKiHjamoceuHa
 i6NDeGbzGPZ2K9LOEjVji+k7HUY1OA22vk/Ucbe2LKCobW989apaC4ghklE04DF6VsIFX2mYEgU
 uxzbF/Tog5enKlW8b9g==
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69bcb04e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Yq5XynenixoA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=DMN3E52pVBKjuxKHRx0A:9
X-Proofpoint-GUID: 38zj-kZIKb6EC1MDYeJUUV6t4Hzce5Ek
X-Proofpoint-ORIG-GUID: 38zj-kZIKb6EC1MDYeJUUV6t4Hzce5Ek


> Instead of using a constant for timeouts, use the timeout of the SCSI
> device itself. There are reaasons why someone might want to extend the
> SCSI timeout and having the constant out of sync can lead to early
> timeouts.

Hannes: Please opine...

-- 
Martin K. Petersen
