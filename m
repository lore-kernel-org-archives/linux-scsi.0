Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77663D9DB1;
	Fri,  3 Jul 2026 10:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783074762; cv=fail; b=a1kcf346l8u85/PZAQo15mc0hKIW8baBP0unZb7ZOZIXN/KI5EvShVFGzi2HINzV/FsX0mC8HP2g8pDr5coe4CrnuumQzqy5DK3Oyy078/NI4qskXrl+t1Eh5D3BYw9Q0VFqlmgAGTRoT9FXyOzh9dosjfrRWNNEBp0Iifk0CoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783074762; c=relaxed/simple;
	bh=9qWXGsY17qyT6/OCJ0MzWZV/oUit+E7ugjFX8FN+esw=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=utGd95nZfqlAK2Pxx9EsHHsBJ3jz+x32f5IBzkftZkCuWg+UQyZgDl1C7c9whQBQSO4ysCCNWCMFSNSMWsXISYf6nXyPEu7CcHwsIEDF4GICUA7mH5kX9PX7zIDiuLa64fb52Qo+1IpmXsEB7RrbsjAomcFQby8Ya99P9zmlfmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R2f7mXv8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pp+bGAiV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R2f7mXv8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pp+bGAiV"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6638tx7Q3113435;
	Fri, 3 Jul 2026 10:32:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=fEqkx1B6AiWgpfUh
	6sirHxj/KS4BWpDuGbZSTL9M0LI=; b=R2f7mXv8Ysq8oK03Gr77JgiYCOn1Ql4Y
	mUTrcbc4hJbA94N93cH2O6tdWRI5EHKOdfeuenuM4G1SLfdlw+oeb9VX7ermiEd0
	Ki4idNt2PxnJgnzHfovv+OgWOY4Yi2O6Ur77d+jpIlnWI57KpwiwM7HO9JhW//k7
	EkDw5ZLpFp25JXQCMUt0vjsDuXpeeCLVKShGT/CPEk4NGJTQIlB5bcCljztcdZcb
	5TgSYs9vsIZsRAq7GGbM6Oe08ifspCih78xAa+GKpOFzQUed/s9OfShpZjmvNmuz
	ohwGOajTOvJMPSSpETTS2ANqTsGIOumNZSh7vTg3zo1PGabtivB87w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4f26kfjema-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 663AS7SK013060;
	Fri, 3 Jul 2026 10:32:17 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013021.outbound.protection.outlook.com [40.107.201.21])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4f50yuvrr4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Jul 2026 10:32:17 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ePd1VglcZzMtbw6kzJJI+7hyS3Og7qdJyC5EjVcVHyGpNXBo67jLCPuGOXcFynbfVte1Sf0UlmxcnCOOio3zRHsZBcgRVZnGF9cm31ZFV4EOIn5gln0ZLLGpP7z3VMVSn9mSqK2iTXhuFLZFsN/VR3YvfthODZj3eu522MFk3KEVw+oBG0uPOpaFpQhVkWxkZxRpP3mfMZtLzL7gVpoOLVoujnMCzhBrDbtBZR/W8LXEliaKn+7pYWuDzE2edOVtx7i9O2HLmYXiUdGqdWl7bPxUA4aLPbyMbJXRFpgD0ytgEv4/RmM6uQET8tpUbf/KJQ1q53JzScHEelw8LfYplw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fEqkx1B6AiWgpfUh6sirHxj/KS4BWpDuGbZSTL9M0LI=;
 b=rhSDhI2YBSm4T7UguSD22fHOsmSnXVoaNtfY3ZDYdfcQzCeWeH083vMF8pg0tdXJWk26VdPjqCLnlAbbHKVBQpafBADw+qQ67U/ntdaWc0FSHsO5qJagnKYkQBVTMCpGp9+w+lNO4D2rmFMwMNekKex8nfDc8Gtv1+QANFx7fBiklnH/EpEBC0lOeNl3szz78a9q6mldO9vYzcA4cNN71lqjPHHlZR/FVhsO3yAY96rEwxqNblPbbPMgIRInyQV7N+wE4fFD7xLceyHH6/3wgvbuSmz3Hfl8sG6rd4mD7uUs34fIylGX41yhs/CMuTkssZxsbYUl/RHS2xJ3VvhZLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fEqkx1B6AiWgpfUh6sirHxj/KS4BWpDuGbZSTL9M0LI=;
 b=pp+bGAiVRN4bwWIyF3SzJTwE1SH/Tf++/9b97NMj2Ca/PYYFAfOukacJZG4ev78VSYiqvXDR+cCIwMlT+UsPIqG55n873RoS7B0iJNz/4OYcF7s2tGbWi4zj/pWAru0Nl43IhUcU/VTG7n1mz4o40RdPgOQvj9MXbyMsI5+xvJw=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 SJ5PPF1DE1C92F7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::792) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Fri, 3 Jul
 2026 10:32:13 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0181.008; Fri, 3 Jul 2026
 10:32:13 +0000
From: John Garry <john.g.garry@oracle.com>
To: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com
Cc: jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, nilay@linux.ibm.com,
        john.garry@linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH v3 00/10] nvme: switch to libmultipath
Date: Fri,  3 Jul 2026 10:31:54 +0000
Message-ID: <20260703103204.3724406-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:223::16) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|SJ5PPF1DE1C92F7:EE_
X-MS-Office365-Filtering-Correlation-Id: a6eb1e00-8489-4825-2968-08ded8ee583f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	60qyMTMiHaatg+7BKWlZ3wwNRytyaseVWQNMNtKInt+YdTAas91+jrGqfhQ12PgMBFh5CUw3+VzRKve6bPOSzVSpMGzbic06MugBTcbVE59/yNV6NtEktONHYoQd/mzeY8AaOQYsc9XraihTlvnSU8vYANDhhAUYTz/uat0pEQlC5XTqdYHHO/D3gFQkJnaP0L/tltE8zEaS9/Cc7iYGxonGB5hvU/xwqjkaoXIQiz5iZY2bSap7qwUm6TJoiH+D+utKCYHJP5Y06wWToPWu4Zfs5RiMMh8zi6v0ojVlbm+wSEeXy7Re8rYICFBXYBURTk24GJTza6TeVuIEIHbq8NHu3wi5Ump4mdCLLhI/hxM06efSy495mhiAcMTiR+qQSFdzGvnbUopPq8T1CaEh+wJpNrtXn/X+Jq8C4Rp8N5EaIr/k8W06bUOqs+IB2/nhL3c0UcrQyqLRT5Oc9HCAXR7Adb+dl01NfdgCtfGdcgCULlb8dwC09dcaxCRjZ0n1eVDfNHwAi6JUBC0MvFx9TdeVNPW7zAnFNjsPuiQdyZ7fQJ/ra0Olj1aFvYCiy7eLXg756cID7RiSnabEWo4PEZ/jRPLKi/sQwQV6GXtaQKTCCy88Toe/Ez1AXZz6dKCsMGElNl4GH2VaTB1TxTE4Q0eYomKzRTENypksFlA2bFc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4x/9PDbDZmB1Pjs06wSthaiuTMMofMVxQynx63evEmnUp/C6iuHYYSQzChbx?=
 =?us-ascii?Q?3pz0fcpllNEj9CMFNMalgBo7os6TgZ8B1qW53b7oP9hgdPO2JWTMYEqDG2/8?=
 =?us-ascii?Q?bQCRkI/KkG455GJZIrirp0UlTL9FWQFwO1WnpFufzX9uiByw/BssDrP1w3z6?=
 =?us-ascii?Q?nJP2/SylGzU6O4YXlNDV9xbmBRPySv6U3MJAFAsWEUnn/Hu8BnQGPj0z4Ddq?=
 =?us-ascii?Q?/YV9aOmcDRvBq9h3uIV8CO54ME/yqlGdxYRiFk1ImTYX3AWqUcIlyUCdFaR7?=
 =?us-ascii?Q?EnwmbBjoGysZUpo48jxZ0kHF2xhiBioF3kQFsxn/HfZd0zclsUrUItnli8FT?=
 =?us-ascii?Q?P8F6KX4YH36SUteh6Rc5ESzAUhaC5ZnnirWloKAd4detVNg7gPcR84XTeC7G?=
 =?us-ascii?Q?UPWw5mcymMJz080BBXto4oiMX7LLm5aLszm0oErtXFH4Y5bxjG6u6sTLnXGg?=
 =?us-ascii?Q?/by3j0Apt2usZsa1/om6UIe4XaIP078URuo6WEPV3Fx82BMlZzuHPJqtb5KA?=
 =?us-ascii?Q?on+/grCACPYLS4a75uF9bLs7AjwgJk97v9reVpfvCyN0pGMdFYiDAtN3WIZa?=
 =?us-ascii?Q?8xcnbgCg0mxHad+sTKRP0c0yPcl0vI84aXfRgFEDrCAxMSD3yzfZCNWhSeL2?=
 =?us-ascii?Q?+3If7hljI29E8Cgtcsbb+pAWtm5+ppTg2efVTYxOSZnag1yismgPN6HudE3j?=
 =?us-ascii?Q?fLl05WypGwjPrLGkuXK0WDxJtJqDKj1sJ2t1dpavmJGRa+4ClmGuaDoqU9lw?=
 =?us-ascii?Q?6Z90VHz6ubxzFbLFa90hdony+F079ZB7NNGiLsGb6ToGypjwGNVSzDJpOMcK?=
 =?us-ascii?Q?ImqQoGf2SaqtlBhESqzSZHZ8YRv/oPMBEI1Ovg5BRoHeHQp61rIqc0Qicxjl?=
 =?us-ascii?Q?/E1KKpC0XwViTf3EjztQq7Fo9NlDm9VjIydbIbn1qI6zyawtqt6bbHeMmZZm?=
 =?us-ascii?Q?47qww/+GNswuGMmWec3vQnrjUgXyWnrxJzlLM8wXTdMLOt/U7IikDHWAzwJB?=
 =?us-ascii?Q?TvJLXV0YwWlWGqgeq9a09fEh/2oprVzpRShinQdxk9swOjVwcbvtKcSBxVjb?=
 =?us-ascii?Q?YuzkExEUZJlJzS/OFhhLFwXmicTP8rm4RvG/Kp2xbNhwhpcJgrkP5J3qI2SJ?=
 =?us-ascii?Q?pKb0PrQsKl/WXXtfPTN1SWgqH6ZxolqizFVsEBN7cLHDNQuM5DvRYiC0/vxB?=
 =?us-ascii?Q?+LunZ1Z76RJD0jW8DptFci4IGM4pfhtu7CiBG7EzsLHMGArlatQz8pSIbh/a?=
 =?us-ascii?Q?KeN0kUXD4F8AuAz4qfohum61W6FT5R0wjf9DYOwN01VHlSopwNTY9TgOLRql?=
 =?us-ascii?Q?5/nJqQLJph0tHnGpe4hit9WgTGe+z8sAX8qh2mjDqulsIKDwDrhUH+q8gHAe?=
 =?us-ascii?Q?iNYh9FsaQ+FvGs9dJmR0x6O4yFRzKME0JnR++Qx1HXMLC29CwFU+Lj2UANx1?=
 =?us-ascii?Q?c2LX9vIWT4eq4Ir/xzpWNdLTlF2fPS8TxFfv3UivqPHl7ABDnuak68oYVSIS?=
 =?us-ascii?Q?f0tNJ7ZMriAvnmNHNr90fJORE78TZLLaIecPZglwqA0AzBT26NivSd8btItu?=
 =?us-ascii?Q?mTXZQZX0aNwmiRKDneJgo2M+PuUWujeX+MLseqxAZtwxg2S08gyjsKFgS6bl?=
 =?us-ascii?Q?G+q5r4YsvUB5Q5RrH5eIUvCQcWf4afeguRSK+T/qmaBGziKiQ4vERXR2d/BF?=
 =?us-ascii?Q?lINJYoGKUqkCBwXtYTCCopGqqaQwo/rF0JliZd7rsCkUDdcB1wIYToRTc6K/?=
 =?us-ascii?Q?cWrNKz+x73qR6DdUBjO5qwNaGOJ3Lh0=3D?=
X-Exchange-RoutingPolicyChecked:
	lJ42xaTwOlBcWAHvKwanuM5mXDz7QyVIwKiivYZT5TQnngCQuF5ASNnqtaBp+al1EUKjOEjhZeinVLaG+Tq68GvXWBYtR5Uh5uyvk4MP3vp8Q1E9iVN4Xq8oiqSXydpzwIJkrsG3PKCEfwmWZjtMtqHPDGc9zpoK1LfmMy8dYVt+SRQPwEo8IrWc6GnC9Yj+73J/AbuOdHsxBIqYWJYgfG15sQIV7/tMC27A7JFC6Rj6NqPwJqPqQKEN1KHXBl0M91UJD3ubrSdANeMtI4LqDPUqpLpF77xSPLWgEvHoPXm43ABlAomQeRYhawzVFi14dF14Sg+7wYMHT/TdSW1zog==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Zury4L5kW7n+5hLWv+b+XJU7AvLhSqlFt0IxMFCeFjRNxGIn223tcxXQzU9Bz3w8Jb/r22Ne1DamszxuXQ15oCPt7zhk6ABSvCIqD0vAXgq0BdToW4QXpksad8V1AiDzXfdl4T9fJB3gNmROZN91zuXbxapaT43kuZfCLWfBNZkhI1t8tpOPtvNxWakZXCom1v//S6CIiO0e9sdI0KzeCPa1lQOCzZuVEm39ngGI7TqcvX8Wm2gm0MjPfcu9epfv/3i8mGZ1g77GJ82N/do7OkoNWOPyuHrSwiHyrvA9MXJUc19fdCkN5NLcZDShZTk3giD9PErmPdylZu83SzSoTIVeZhjYCMkeZ771xgx3MPXcYYlKDAr1/2JQ8zN8SADzZsgbfzASNx6DXgSS5YfplH6V4VV6Gf9ZSfai0OB351PkovGM8yHuZvF1k+YD5utRjPxT2zg9el7GTYRvTDx/ziug1E0BfB0RbJPvfs5kljHV1QXfqBzLGiY6y2m2KmU7ohhfN3ZjMVJck9jVZM3ql1G2bAxosuEt/5rbWZKf9ioOHTWIPwzzASb451U9o7MRkppBl/hb09OjxN0B+3dwld8snT2Lk2TpGpkDVkkfuTM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6eb1e00-8489-4825-2968-08ded8ee583f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 10:32:13.0961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zEqds6buzTI+bFwqRbDpuGPQIztD3DNchLz7PX7UNykcoHRU/E5NZx13UxcsGQLX/NWs2Qvep1oDhRfQB24WSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1DE1C92F7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607030101
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX4ODIAeai797y
 Jj/xfYeDX3k1GQsBYB/fSeytvlEGwQNRarzVf8ArOqvNY7prhsUmVW9cccg2cCLSPVkQzNWnUYt
 hhZDZVvu9uOapeMvvTKDhi5AzeYD0zqxYl4FUHskJR+eJv+becmV
X-Proofpoint-ORIG-GUID: H9-uLxXsV0Q2wdE4sQ0FaHjrOF0ktQws
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDEwMiBTYWx0ZWRfX4JOVTeo8h2GX
 HJl5xkd7oYFkJ7sLTwrFnqNUnoIk4K1Joc3CeVFYaj1kRDcLbx2wMZEPmEwqqodbPtCPMw5bfO9
 3gJU8wSUDsRN5wnLX5xR9MHNZXuai0VIckiSnwgUcw7tJh5Ibj1LCBL6mphxc6uOus4wOCYQWPb
 kuAoWU2jPBwbqXzaKPYW52Y6BMWBXgf+kEKbhw0Q52a9FNdqCYL9BgQx28+hgYH4EZuLQk+SjyU
 BzdhgwYstiQgAxQZMNzE0Ql/JwOkgl7YZ86r7pvaIuVg5DO/YAyeSE7wiqdU01ts2UjUP4DvjJB
 xaRcZIIUu7wU7Bi1fIod+zH+ZWmfUyrg4e2+65b2k1i/HaiuTuzb5T/W+R4rUORS6ujcMWTPTcX
 vbuCaAJexDLME8mOcaxSThWaB3VXZTNcR81LGD/atep47rh8DVkykYXiK1YK71/jIefCLLjzdgY
 D991GneOgoOIF9KMpzg==
X-Proofpoint-GUID: H9-uLxXsV0Q2wdE4sQ0FaHjrOF0ktQws
X-Authority-Analysis: v=2.4 cv=YOavDxGx c=1 sm=1 tr=0 ts=6a478fb1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=NEAV23lmAAAA:8 a=4sinxeGifeqcQ_2ykc0A:9
 a=WmVTiCyuxqgg3mnwYu6p:22

This switches the NVMe host driver to use libmultipath. That library
is very heavily based on the NVMe multipath code, so the change over
should hopefully be straightforward. There is often a direct replacement
for functions.

The multipath functionality in nvme_ns_head and nvme_ns structures are
replaced with the mpath_head and mpath_device structures.

It's hard to switch to libmulipath in a step-by-step fashion without
breaking builds or functionality. To make the series reviewable, I took
the approach of adding libmultipath-based code, which would initially be
unused, and then finally making the full switch.

I think that more testing is required here and any help on that would be
appreciated.

The series is based on v7.2-rc1 and libmultipath v3.

Full series also available at
https://github.com/johnpgarry/linux/tree/scsi-multipath-v7.2-v3

Differences to v2 (apart from porting changes for v3 libmultipath):
- rebase

Differences to v1 (apart from porting changes for v2 libmultipath):
- always depend on LIBMULTIAPTH and drop nvme_ns_head.ns_count
- add nvme_add_ns() and nvme_delete_ns()
- init .drv_module (Nilay)
- condense code

John Garry (10):
  nvme-multipath: add initial support for using libmultipath
  nvme-multipath: add nvme_mpath_available_path()
  nvme-multipath: add nvme_mpath_{add, remove}_cdev()
  nvme-multipath: add nvme_mpath_is_{disabled, optimised}
  nvme-multipath: add nvme_mpath_cdev_ioctl()
  nvme-multipath: add uring_cmd support
  nvme-multipath: add nvme_mpath_synchronize()
  nvme-multipath: add nvme_{add,delete}_ns()
  nvme-multipath: add nvme_mpath_head_queue_if_no_path()
  nvme-multipath: switch to use libmultipath

 drivers/nvme/host/Kconfig     |   1 +
 drivers/nvme/host/core.c      |  89 ++--
 drivers/nvme/host/ioctl.c     | 110 ++--
 drivers/nvme/host/multipath.c | 928 +++++++---------------------------
 drivers/nvme/host/nvme.h      | 135 +++--
 drivers/nvme/host/pr.c        |  18 -
 drivers/nvme/host/sysfs.c     |  89 +---
 7 files changed, 339 insertions(+), 1031 deletions(-)

-- 
2.43.7

