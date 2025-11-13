Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7115340DB1
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 13:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041041; cv=fail; b=hcmADQ+MfIa7nUhA0O2IEWpRHwZlhjsIIqo2jEhFCoSamyTEl5Cr9blH4yEyISM2m611x8cf7IMJsU6WGk+dmOX/xg/90sWKyodt2K12mvjVg24dKkq9rhEXTzzyxzLH3QDa39GB8TD1qjrjtFfxi7Gqw3Ld3TF5Iucosazn+Fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041041; c=relaxed/simple;
	bh=6xtNyLCFYO9dHg5NDCsZQqNb+83K7hCc+R4l4to/l7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i3W8utJtxsHTPuMiijV61H2kZOD2FkmYYlolsdEqbN+mzLLj6ih7PV6uNCCJhBKZyWVKzj1QqrKOgqrD9Hemz+I16Vbd7zomq8b2Xs3OVoPpP8zhgSuMXnHXiq68j7Ik3QOhf/nrjdzh5dRo5DXYkM6uzVsmY+SgiltjjREA8pY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aaeyFr7P; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tIFT5o0g; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aaeyFr7P";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tIFT5o0g"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADCUeiP020841;
	Thu, 13 Nov 2025 13:37:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CHahtQAD/6U7p9G8W8wjX+mGAwHqvn3r4vx8+5EGih0=; b=
	aaeyFr7PJ+9SmBRXu+uS1xI+ZAPA78XHaOnJeV9p4RbjXvrbWZQISft4SgVpvPMP
	iDLcKSBldhhGERUyVzMspp1Sib1vCJLxU49qXAG9/OJP1smzvQJowwfF5SPMssO+
	bu1fvjR0nQuVl+l6egyJqV5BrD/UEMgtbl6YQGeVffbmB4x6ENeyLN6O4gobqtRE
	PR2wwX+LJAIUNWhBN4bv9x+MAkkQGKUXkFMSQRysnd+F4AkAbaC6H5W0ZjJ32FZe
	tabSff/6IVry9uVNOIuP3cJQRsv188nBtBnYt/uE5JHVEkmgWx9voPFnjFMP3Zrr
	QgMOtuajC+I+QY4DgH/ftw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyjt9pec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:37:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADC0MxK003117;
	Thu, 13 Nov 2025 13:37:07 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012002.outbound.protection.outlook.com [52.101.43.2])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vacnece-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 13:37:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IawE2jFYVfCoSBOlzqcpkx4Ceun2z8kOvV2oNb3lfV8312rkluT85H2JdQM9eEObMmiuGcViH9kjHgffSRnYS2iEnfz7tP5FugTp3kxKOjMWs9ONZQa65YNlnt4XUtIDFN1bosThEsSbKS3Jg9ph5DVOVYoUR698BtS/lZxmNUkrpFvn7NlQC/WxM5S0wq+zBK80WM0G/m3b8fUEpc5N3GmrGU5yBTdIxve7Mp8jcWBJQEpLpniNpdHT/hAgfHtGT9eH0SIz+UXlCpUcsUA/XkqkD2Hn20985TAVRE/6GEXDazmUMSxkP4vQkWLpM3kaVimLj95+yauxLPQN0TqNnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CHahtQAD/6U7p9G8W8wjX+mGAwHqvn3r4vx8+5EGih0=;
 b=HjUWWDyAesyRm7mSjeiI6fe8IF3UcXmwR+l2pot4uTcQMlvOyV3agbKE57Y8wKyxFL8N6BSP/QFdjeopgSaI9bL4hkuf1cw0qmbJhZ4WP2lTmh78BMvsYIgJocVioh7AZXqnQGPYjQulb+yOLrydvW3u0UbWMZjCa+YMCnsKqYE6ZZTUSRyPlMKDeyjNn/ifFgZzVeQwxfOAE1pBrtJtry+w6CmVhcEZzREkGicHLLfnvpMPI3rBlZtHhHmTd4NNG84VuzpNZ2HcROwmgdernzdmN3PdbdJM7uwd4snmAp1vjskbheoS2xw+AzJIfcmov31hvzMwKPmWQaE3jYy9Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHahtQAD/6U7p9G8W8wjX+mGAwHqvn3r4vx8+5EGih0=;
 b=tIFT5o0gsRBmOMPPbagWF+jFxYXHbqtxhUA/8d9s+x8lYBnUxxBLjgnqTh70qs1IFaKeGORq+oQGu0Lhi+LHe8PmX9WVqFqMbgkUFPQHoTzHHeuLYiHbDVUyJoMxrv1FIQ9sntUem19BA/Vc+V/aSiElFPDfL2sCEAScdU8JW54=
Received: from MN2PR10MB4320.namprd10.prod.outlook.com (2603:10b6:208:1d5::16)
 by PH7PR10MB6252.namprd10.prod.outlook.com (2603:10b6:510:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 13:37:04 +0000
Received: from MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c]) by MN2PR10MB4320.namprd10.prod.outlook.com
 ([fe80::42ec:1d58:8ba8:800c%5]) with mapi id 15.20.9298.015; Thu, 13 Nov 2025
 13:37:03 +0000
From: John Garry <john.g.garry@oracle.com>
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, jiangjianjun3@huawei.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFT 5/6] scsi: scsi_debug: Clear sd_dp->defer_t in sdebug_q_cmd_complete()
Date: Thu, 13 Nov 2025 13:36:44 +0000
Message-ID: <20251113133645.2898748-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20251113133645.2898748-1-john.g.garry@oracle.com>
References: <20251113133645.2898748-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8P221CA0017.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:510:2d8::13) To MN2PR10MB4320.namprd10.prod.outlook.com
 (2603:10b6:208:1d5::16)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR10MB4320:EE_|PH7PR10MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d77f710-37d0-4444-ce4b-08de22b9bb30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NOztFoQbTQoC0y3MNO9C4yIqKK3Ssit94Fy1j61wcj/oWyj15XoVe1UWoO9z?=
 =?us-ascii?Q?REzbYOuTDR3biBinRl4BkYvRDq1QXRFXcOyoD+k1vHnVsbpyTQyACKtROz5+?=
 =?us-ascii?Q?zrx+KEeV3SeloeIlAhi7z1zAZ+P5wMZam4/7jlgbReLD40mpOug2lPfJUgzy?=
 =?us-ascii?Q?G4jc4PEKdZzuYh/G8GJS5lO9lXCfgEAJkZqV1QeD+xoYLqOOCfVA3F+BcOZH?=
 =?us-ascii?Q?kwtiWCK/b3FLmdYY+WVx0I5nRZuyiOArgmu/lHIQpxUHLHW0oVPnMgzruk1c?=
 =?us-ascii?Q?hey/naDcB/u3+VpURvUMhxSxd90vjLthmF5j+j+F8O7VE6KXUhKXPSim1ejT?=
 =?us-ascii?Q?okcHRc2XjHL1CkBjlA33ysIvoD48tfbMI9vOQFDfj8sNLHeotRJGWdiZ3JCp?=
 =?us-ascii?Q?xUIASbb6zue/1Ai8Vym70rSKcof1z+tEwAQo1+b/jCq50kk2q/0Xh95OaGOA?=
 =?us-ascii?Q?9K/hBhN9sokka9Hzq+pGJAWA84N41drF102wphvcU9y70z7Qlog7asiAtHXo?=
 =?us-ascii?Q?8OYpttPOUx+aGsS5q3tbdr3kqWGexEHjjdIOIyxdWXrlmcy1N2ux/iq/+oy5?=
 =?us-ascii?Q?cDCAT/MVfi/WqKzH4Sm7jR3MyeJa0lyH28p+vGf47D9KgXd4N4jQQDPYpSUy?=
 =?us-ascii?Q?z9RdAy2nQftPCG1V89aqNCbfanKKBNxCT/dUtNLXX5jO4xk5s0q1T1ipWT8I?=
 =?us-ascii?Q?MsMZN0gY2s3+yckyMauGw6Tz6jKT177/Kgacp9LQHfAZ4hh5Nau4jTP4JDdD?=
 =?us-ascii?Q?lUC3n2310b98QAtDYTc//VaN2sfPBeOueo6xQtv5cI6tj70u/0ragWW7EAqO?=
 =?us-ascii?Q?DiU9FEQVwxvECj0pr/Zj4rPEaXHiqITWF3pOIF6Oqzmkpkuv9u2KXAgk0Hbm?=
 =?us-ascii?Q?POt1HuI7oTm3FBelNYpga0P3y3FRrgcQ77Ea1LdTqhfGC8yG04w/bHoEgeH+?=
 =?us-ascii?Q?Pi01VPhIifzFNqMSbWYqjyuN8Mo0XwOnPI2MlnjqgbQNTSpXs7Jj46fi2qsg?=
 =?us-ascii?Q?FX2UXmrOFGeX4qEO3+k5Wj+i2RXQ0hjVKgXKmKGGwzVoh5E6e/vXqyHHhvWM?=
 =?us-ascii?Q?CwSjQG+374TuuZAnAwyOJU+hadLtb86y4oEAmtimTJFIpOU5/Cg9xblyMV2K?=
 =?us-ascii?Q?PumcL7G/COC2s/nNGHvTYGWXlOakefbtm6DnGpdnC/o7HL0jMNr/m+Y7egkC?=
 =?us-ascii?Q?hchLEg9IGzHl4a9pVW0S7VI0v6vPyRGckfOUA2TIDg4tpzBi1EHyGxnzvoHO?=
 =?us-ascii?Q?9HjIHHXni3snMYPwSBQLxsfx4Ib0foi1iCgLRQeRvfTkGMs1mBYzc90BwI6T?=
 =?us-ascii?Q?9L1qlCDybCSgOhnOJIe66gQz1GQls4KI5Q5qR7w/9jPJLp38zfaklNp/HvDc?=
 =?us-ascii?Q?uasF9BYfWD3bwyT1jnHbExrsXB8hCtbMCWfIBI4eKqiWJgCwaoZuWDPaYxc6?=
 =?us-ascii?Q?QP8b6Y/eAoMF1RY7rjPgrHwg3B+XiSu3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4320.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?viz0o0m7ZpfxrEzQEyPfvZPctPGFOZ0WlGHywcoEmR+ee4W0MmxDZM/o9Rlx?=
 =?us-ascii?Q?Uiv4SiIZy5kd1M2ntBI4PDkru3ZrqaAvxmrwf+a4upxMnOjaJdqiLIQyqeem?=
 =?us-ascii?Q?QTT5JNQn/roIXuU03nz97t7oUV4Pn34pCT3kDQjP/X5T6tlcNsqtvPt24dmw?=
 =?us-ascii?Q?paTPCA9OPlkAAj5DweWEATnn0E3Gua+SRSJ7pm/uOa32dowePC6xVOxrXfg0?=
 =?us-ascii?Q?p8m5TKTGPT/fSrpJLHhRzQbNVx+i45+nyHveJ7tVThD0P8bgICW1/N+Xak4Z?=
 =?us-ascii?Q?+mrwR7eKjOhKvbchkDMx4uoJjalp+t7UqiIICR5dTAhGmSENITjSDzDxczuj?=
 =?us-ascii?Q?Jel8OhwT6+VpDnvy/3FM4rDi4PiaCrqjmyf67Qdq/U+mXXPr6Ztj20hOk7SM?=
 =?us-ascii?Q?Jpkczhmyy39UjLdMOUr8k1qnDz5U/XrRBVck7mx3VtS53BibSj9sxOUVamb1?=
 =?us-ascii?Q?FNxbdL4ee3hNW/jwfcYGD1gfjC2I5/7SUPgzwvW9ftP5YO4+3QE8QCrcweO2?=
 =?us-ascii?Q?CWGGxGiZPsa2EbQmoY6Z4F8GD9zvxfzbXybN9GgHuN1FqVpPeVy+8+wjnAdE?=
 =?us-ascii?Q?8tOAEFsOIkkbBdpD7DySq7Aj3xiCytXmu6eS9JwihoZ0ODeLsUjCagzqRu9C?=
 =?us-ascii?Q?JiBbAuUqVV+ab1UcOmEvXqJC125+wNhMQlci4yfZDDYkXtB2eJlE6oiZdrYq?=
 =?us-ascii?Q?k+c/rqav5oU//o9U1DAh6PtxaS0yOKOP9l5gocOoi0oUJ5klxWR06rbZahpy?=
 =?us-ascii?Q?OHSQP+a6QOAEtnuqb1HJWUj1/MYelgOZS9vfDL0DHBLPhKdVDmxaFzExeRFn?=
 =?us-ascii?Q?1y8lRs5lP+BnKh4l1pB+/8e2JRbqiufQoXp7W7EVgYoyCyLlLOnhz6tuEaXZ?=
 =?us-ascii?Q?WE/Xu7cFDMgCy/rw8PgPhn+njghFQyO4YJJYDqI9SRdG3ZKdF6B9FyT3cP1p?=
 =?us-ascii?Q?8IvkZhoiXLpyPh20z4is5QzoLd5Lp4vqtLJhllhGVdZENXK8jDYAc/6Lo4Wx?=
 =?us-ascii?Q?8tu+pypzbtfnVAiwoVDvIF8yxBmY7+J0D6jHouC/zmMLf9wDDoBR1JVmt6ZU?=
 =?us-ascii?Q?B4bOzhxjfEIYIeBiHS4NzknuSEYZGn0SV1Xx6QvEVCP6ZDD7FnCwgKw9EWDY?=
 =?us-ascii?Q?TAt4/7zWFhphGZIjnDes+1Gm9k2qDK9EEZxQytdnHziMZsC+I+gL3UPWFlxn?=
 =?us-ascii?Q?dO1eK0m71wL2Z/0XIr4HsjjysT9BCUCIizW75RPLJswCfSj5pnfK19rSEEty?=
 =?us-ascii?Q?NVHnlYgEU2RG3tjwNHiWo5x+gK1MWCeofYUrAWy2Z41PYG7IeG57xWGuLnxR?=
 =?us-ascii?Q?Li2ytPkXGpjnpxDpuBhhSdxGI8Pu4f2GjRTCr0/Ds+OHRTlcrGPtcap8ol/P?=
 =?us-ascii?Q?6OXM1k3poUN93YJ2y+nZwVfB3ofa142/la1jDnSEj6qnYTVE7laC6mZ1BvjU?=
 =?us-ascii?Q?6+6npgzgACWkDcFplFjTSSNGaRbPND3M7vWVZd9mJSO4fvIZOpnhCgeNN2of?=
 =?us-ascii?Q?t8ICWRPEzO/fjODrxi9U3oB7vMi4qjB11ItzL2Cvd+Gwv9Lw6LfMbOA3y7jy?=
 =?us-ascii?Q?XOLrsQhKQUm5g9vqnFDxZQWv9fmLUCAZUNqYZi70bxPwpKRT4GqyLdAKutpM?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RiihG2dUiwH1xO8uhcQEVe7+ezNr1QZImpUXfYnHY3R+wCxYWlVWDGZfYXBZgDyxCjr0gvv139UPA2KtuhNDnDKLCwA3/zcoVugT1CDmRSl4JfYiArG7x75XTHAUFgtMWvJ9ozBFJKOFhVd+O9ZBd4XKDzX6rKXtEQLXDVhiucZKv72AY7TXueuPPo6P8xdmKFaGcsb+0oDKndhSvWwTZHB+XWQynauF2l8BAMkZlw/nd/cWmXCfEOS2o2njg048BJ0yMsGymveEnXmeAzcuFPnCwDCDVqPoTKxaaiAp7Fvy7Dk9b6GJzc5vDp8GgPRfrjxDSoF7YTtHYlHU9KKfC+Xm2Rlzn5qN7SLOaoXsTYlXEAlcbgnp6WJ6b5obA5oAfKAM5nBnGEyi++00hQ6gikiRmWZ6/QJ44O5jGgdsHvHhvym96VBWcs7zMr1sPm9QNkeKZCDjbr1586ViEkx3RHb1p9oEO/PqurvCEZQRPujH3hOzzCXR4R7pOcW6QTnBUXsEHhV4hFOevz8bW6bZNf8JlmbphN1bUE7D9Xf+8wJZWZsQuysp8m01LWFTI+c79AgaxucV1TGQk8oOpGcWnrP+DfqaeAJ8kLfBeyqBgSI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d77f710-37d0-4444-ce4b-08de22b9bb30
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4320.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 13:37:03.9268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EOwNrjdB0sTLRd/6wXIhHrVD46MB3tiTWlUi1Kvt28GYeXJr+n+U04D26wPNf1oqkUvw5a6G/ldsm6+oHUjWzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6252
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0OSBTYWx0ZWRfX5NtLDnnrk4s4
 KjnwRgCZm+BOu7u6cS9Gsdcj9O1tC8BYEblSAMVyOZG9e54h3qOADPzwTQxNo63XRcUQja7jN7a
 ABx7NcdKjbi7b0jfJrytwSJRrpKrKFdKTiNhdR25CNB8B7J1MxbIJCAQlEhRY92MDI47SjH1n4l
 4cDyh306c9Hbv58rmyupLWYUxRaRlT6ujs5omW7nnZNULFeyaACE4LgxAkWjhQLQBWFCjLoiE7h
 rUPBfPYF0UFhTdqEaVDVwa3UhxH4hmgmszkg161DfFLBuy3hiKPlIx9SigeD0/Qpkzzd3fK5rpS
 /ZOvMlAQMhy08gXfatMBXGBlcn4SjYD+954wRzqUkzPovm/WS9uw8/EzMEFvzdByviALEcWjysV
 pATnY7mRrsdECsTgfYGi0hArN0OqJw==
X-Authority-Analysis: v=2.4 cv=S6/UAYsP c=1 sm=1 tr=0 ts=6915df04 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=sVyax2QX1GXj847SowEA:9
X-Proofpoint-ORIG-GUID: HF8tL-XYs1oHKPxVprHC8AUwV4pVSrCw
X-Proofpoint-GUID: HF8tL-XYs1oHKPxVprHC8AUwV4pVSrCw

When a scsi_cmnd is recycled, it may check the old value, so clear it.

Such a situation is when we issue a fake timeout, as sd_dp->defer_t is
not reset in the queue_rq() path.

It would be nicer to have such code in sdebug_init_cmd_priv(), but that
is only called once per request init (and not per cycle).

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 093124c38d28f..46883c1d99a48 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6390,6 +6390,7 @@ static void sdebug_q_cmd_complete(struct sdebug_defer *sd_dp)
 	aborted = sd_dp->aborted;
 	if (unlikely(aborted))
 		sd_dp->aborted = false;
+	sd_dp->defer_t = SDEB_DEFER_NONE;
 
 	spin_unlock_irqrestore(&sdsc->lock, flags);
 
-- 
2.43.5

