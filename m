Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A1E15EB0
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2024 00:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969524; cv=fail; b=UreS3RN4Nlircqf1yNwVQqlS4C8RuZ8qXahWHvje4VsUd2Lz7u4PcMj9ORvAUN9DzClsFcnW/zyGFaoXMLajSskagAbPTpIm1hedBNyrGVWNVlUleicersbipBtgVYZgeQxvf1j/ii+p0MLX0o8PqTyEyK63t/kLG72ThG/CA8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969524; c=relaxed/simple;
	bh=onh4uTCJ+xNJ0FCMglv0ekowle7n+AIYDifJduGgoQs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tCAcA/nKf1NipjaqgE7PCCgm76Z12Y1TEXsKkbXr8Jnxl7SW5c6N4UzX+6IO4odiAZfH9l1Ill1/cLdOvE96JE72pV2jbFBBjdETUYoWIZQNY/2dx63FrkZm/8IG2tkE8Km4+3SwKVmTIWDR2pxmLBxy1ToC/Vg8bKu/IfOm65g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dHFp6kNm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=A0ydnrh0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dHFp6kNm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="A0ydnrh0"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40MMosN9019274;
	Tue, 23 Jan 2024 00:23:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=eItB51X0PkIyMe/AQTx03930LpxTXG5gk2eEpzRsCUE=;
 b=dHFp6kNmf/BAMs9KhkVxAGltvyh9Am6D4jT3XMW57mpupNPDZiTfBQcKn4AmbOrQEJMm
 LfQVJLN7s/yehCZIZ36k78jGdM5EykAwN/EvLajbcwmGcY/WWgdm2GjKV9+VT60oi41N
 64wN8YOwlfSh30IQ/FgaDtvdahPdyhqTTFQZKKF5I+tuwm0HBay/tmYSsmXjf+BGK+C8
 ZwQZwH92+fMiofXjWsTW4RLMoT0njPb3GGiY3lSW9KcBGi5CvU/eYYTNp0Zo5yGlwCjy
 S29Rv0vYfbsxYt1JBQ+adnBSKjdg2aXZ7Vftx+XRM2v1lWy1m8VRrt6v4k0fW746cU0U 6A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cun2kx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:23:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40N0DTm3025310;
	Tue, 23 Jan 2024 00:23:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs33s34s1-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jan 2024 00:23:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LT6nNCvIR9xjggWlj0c4s13CmD1OGc329TAGzESCrQ253+qKaqoV0hBGVh1Y1hYnoKketHR5Yy9evVL4AIZphq2jSp15/pA/BEC+dIaWDT1YbtMUTqJoIQ2HBD31vzPJzvBEJWlikLsE0bQtYpBTaw/7kQNitSGtQ7n3Aig/WTGi6Wu0DyYzTtyfMP6lP9fpzqFtCIfRLUFli1MLgCUDpGfMTzrgq35YiNaFqzU9N3L5dbXbVLMcbIS6kjSHUzGEC4wt1Eptg5pQc8DyA3ufT8Dc+CD00aLE9PbyoC7EIVEf0LJhipzYUTxdKiggkj7ku1eDKtfXVZ7MV+1KKPXRbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eItB51X0PkIyMe/AQTx03930LpxTXG5gk2eEpzRsCUE=;
 b=oK2rfYnlpOH80gWIxj5DZsYKDojbjqTcyPvfncjCT+QRyTVWUVcbUG45w2eqCRnN+E5xvvYW0JZhV0N/oVt8WWZTRHD811HhSDsEAk5Cy5WtMt9566y61Doisz81evVSBa4SI1Yk7oVUflh4yqFIeMiQs9oGzQe++8UnJ2OB2WA6bLmad/kj/FgQlsiarvl1cuShiPyGbuLB3OzJ72INtD978Gxi7s74KJLmcRIai/lKG1rJAQdOaI8VKWddDd2eZ+jkAEVBMyZsU6UFXXBe01OVUHxFwTsAeedUXimG72PzUXora5/vqanckNmwuNzVRa8n8UYt6gvLsjIjGo07hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eItB51X0PkIyMe/AQTx03930LpxTXG5gk2eEpzRsCUE=;
 b=A0ydnrh0uJePwXFK7ueq9UYdZ1ANwmI0LE+Phk6SknA4PGvMsePKCdUq6AkH7XMDZ/jplbBilY7e/LIMKFqsbjDQjAcmz2JwQJpRe6rvJ6IvsLB5wvIJkz09PW/eI2jqULveH6OCaHtcYPQcYp9FuK4Kx3mPvU+ULDsOLxtuhAY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB5340.namprd10.prod.outlook.com (2603:10b6:610:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Tue, 23 Jan
 2024 00:22:50 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::45f0:7588:e47c:a1ac%7]) with mapi id 15.20.7202.024; Tue, 23 Jan 2024
 00:22:50 +0000
From: Mike Christie <michael.christie@oracle.com>
To: john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v13 19/19] scsi: Add kunit tests for scsi_check_passthrough
Date: Mon, 22 Jan 2024 18:22:20 -0600
Message-Id: <20240123002220.129141-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240123002220.129141-1-michael.christie@oracle.com>
References: <20240123002220.129141-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0073.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::14) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: e160496a-8cfe-4120-7d6f-08dc1ba96ed0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	5mC7po5ftjGpZdv10ynjQ3ubUDdpYs0QfnaACwvD39+bOpSab3rTEhZGpwMKcj7bUm0h8RbRxjI5dd/0fgYyomxlYpj08qdu1X5iyzaMOVcXyjwkZfSIGTDOI1dbD/CHKNTAFOwOtLf1ossLYlmhRzYCdtQre2H8EKlboydqjKrSOPVWomeJ3SrtKAooOVbBu2lMYgXclfEOwZkdiK72fTlw7T5081Plpw29u+WsqEDXq9GwFPEpKCDlmxB4qX2Y+cLIBIbl+cT0s7Z8/Q9k2OuxotVheB78HfXb70r7igQ4AJF1fN/6zayEQtid2nWqhQzyWL+6bTwKlmoesANXBjF411j7eZ+L64x4JEs117rJ47ol+tMXblv+mKJX3CvPI9xUaAC6aNFpLO9PHztatWwbAotJGA2vhiVZUwU/Uc3BiUnfBNZZwrt9dLwjQw84brb2Gv95UV0htJDyeVAI6Yj7NIUaSzRGbzR0hYHqVHBH955dFgfP7FrHPWPCq4BEtWdKpS55RwUdmCsIvmCH1QDCujH1nSwN4W+Myuzt/jPIvOoXpQdCqF+gOZX3BYqL
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2616005)(38100700002)(6512007)(5660300002)(6506007)(6666004)(83380400001)(1076003)(107886003)(26005)(478600001)(6486002)(66476007)(316002)(66946007)(66556008)(86362001)(8936002)(8676002)(4326008)(36756003)(2906002)(30864003)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?zE585xtvQM2pun+avz7T0tjIn3Ij+7XB2kzSIH8iOrOtw7e54O9Dc3Yfrb9b?=
 =?us-ascii?Q?3Sa0mippizRzWzxRjzUL8S2Rav+Y+/aSz/L6DpuYEX3xoiUnDWgfW62vqUwQ?=
 =?us-ascii?Q?JoVHIVlSE+yGKjOGtmESbTaKXHCHJkBFqJYaugVWRR3H1d9P46VLY6LFjzGJ?=
 =?us-ascii?Q?aDOBZeQuTYMWo/0n7XsTLpHxevW9ouo01IsVk3lNSOGhU2nW6MXTfRMneODY?=
 =?us-ascii?Q?S45yiVG148pIDkJeFNbnsO7hfigmhG8KgIhdHrYrw7PPHCB2FF5A7M4fezOP?=
 =?us-ascii?Q?Roa+aSN4+qrru5387Gi6al2Bas2+hZ8va55WmlMs4frT3lfu3I5s5VBADfYG?=
 =?us-ascii?Q?hdiLobBIO/l3DIwnSWnMhxbNy41xwV6kSXAPss0SmCnRxYXhRZvzgkfwce3y?=
 =?us-ascii?Q?xEKMgRKHghZnyW4kTSTJRKp1R2RSVIGHy/Y0WRQ9mk8YbEG6NanYUh7qDi+q?=
 =?us-ascii?Q?O4CZ28MFuWrpSG7qs4Gd1/93C0tCirRD9YwzkFHgjxYmNzvqhBGAKoSXd3af?=
 =?us-ascii?Q?usaZcKxSdBaZAErLlbS6FHSUJlPVxoFGmhG/ugsm6+SvFKMhDWlkPhE9FdO0?=
 =?us-ascii?Q?ufAAxBOn4jeDcpR3C/zgJwjv6xEvhgoxPQEuOFt71P5P9OzUdQ92N/NahD7p?=
 =?us-ascii?Q?8AKBY/NYUFOPew/Kf3HN6u+sjm4nHOPMSgQX+XPZ3zavZiLif426M5Bwh7LM?=
 =?us-ascii?Q?Qmr5sJ5pg+e4HuzANAIcVpGmbCdDD77lIO8Ef6Lxf1PAIBN08mV23Tbj6PbQ?=
 =?us-ascii?Q?ZOUbI+i4Kz+cz2cGHFszfPC/ArAQ1D5JT5Z2EBgwU6VrPZfJGade3xnJWpoM?=
 =?us-ascii?Q?7le27jBwGYwG5vf0rR8aBJx/fEPZlftzk+WNGIjVrTZnwUayOW04Q7M1rKkZ?=
 =?us-ascii?Q?kVFzhkcFIUYRoYIYPUTlgp0jsPa4tFz2fejHPGY6rXiaRr597ZDn2BUIv1Ep?=
 =?us-ascii?Q?pxsXBALb6GiToslKM43vdxzELPk7AlZpVNgXbe3V3/1vaihvEkYimI4QMquX?=
 =?us-ascii?Q?6WNaex6L3RjY5SikHD93b2bfHRGRY5uRi3o/fEL8/GP7WTK1UCg1i0oDlEYK?=
 =?us-ascii?Q?MNHdlfuHJ2bun0H7vw+qT5S0NIfMSAU8r5IFF9QS5mUO4yV4vSfD/UhGlLeO?=
 =?us-ascii?Q?Xcx/weASt1Ot7ANhhPyP5fYe+iRaYtFIdfG1hVKQ+SwF6UTjszvBY+pFPhhG?=
 =?us-ascii?Q?EaJRYLZ9TQoeHFT0Zqj8syzeU2rqku8nIgR9i/53JJ7WIaSddhVFFwr85+HC?=
 =?us-ascii?Q?nAzyVzA8UgynK/uC/474vbtM0kA5r5s0/niBdBLMfyCFMBTuGYpZgZuw1nJ4?=
 =?us-ascii?Q?cP7pv3lw566ci2bdrmNDifFEEjvYhFThKw7ZGr+NxXk9s2biRWfDB5DN9Xuj?=
 =?us-ascii?Q?b9YrgcTBATsFM3GCRRTWwYbvKTJ1PRIXFWw3rvakqWh+T4fkK2ax49LwQDA4?=
 =?us-ascii?Q?vWXQPYxsWo4RilmawQTCvghmcAlBYSi2OuPPb6jFYxQBVpDK0nXi9pN8yBVk?=
 =?us-ascii?Q?65FsA1PCeeQfTWpZgOlw7zYUuVdnPI/D7tKB7F1QLV32IrKglsreubQp86p4?=
 =?us-ascii?Q?AZg17ax1YZTDI1FNNPth0IxTRSaBhMf/AFPtvbcVFA2jLVKrfYvL3NSdUds/?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	IA43sfsnqlOjSpBCBIEpSAaqsTIbfMbmHTKu48oVXQaGXbNB/b79Gv8GmtPRgOTfz6yx/shQ6MdOr4MFD0jncGwPPv2rPzaEb11e4XIc2tYMbczcckTh/6R5TUG3bcb46c84gHJC6usujgTL6ocuEjxqoPghrzwJDiCOJmW7/U3sJcD7/GOGVLYXJMM7Vkp1n9MAn7GaoMTx0bd97DxMDfFHui479mT17Zqg7Cytz7ADpwUSVX0TbKLOASYQinvmNXK5WeRehZ56cB3Q2fiFqg95oXYGHGqshvJwpRyGvq/zOhnL9iIGByKv8FoxgEbjrEhSoLvqtihAapzhKGnseM1VaWUjK2+XVq6BYNInbaG6EfI3xzey+BO/NmB5E9zXi8+4hf8hv7s3JE29FaKTnDoj1iNPFTPQUJQzWgDMSlKcXGR2TKKz1cpc8Wavm5ssPyzEA9sG6WKb7mw/yShz3RW4+OQdpCiuowoUjPkp3gBadnxrIH1xNz++SlcZVKSksdUKCZecDNTo5JvcQzWdUNK3qDz0CAf4GygQGmF0eK+V0WrzW03QgXKp+TwVid9+0mB0OGfE+Smq4SNyMfvkiqR4Z7ctC/z0otMMuoo1e+w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e160496a-8cfe-4120-7d6f-08dc1ba96ed0
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2024 00:22:50.3315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vxsPtuM3llwPIP1yFXNwDkcs50JgMK9vGj4O1n3tuu9ige9QEZnLe+noctA3Qx5WAd0ILCkOFp7YiDAOUofUdV1oucF08Irfsmi4OxLHPPY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-22_12,2024-01-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401230002
X-Proofpoint-ORIG-GUID: 9lF1ne4V9GlHp269XQoLJUsweEIYnLn_
X-Proofpoint-GUID: 9lF1ne4V9GlHp269XQoLJUsweEIYnLn_

Add some kunit tests for scsi_check_passthrough so we can easily make sure
we are hitting the cases for which it's difficult to replicate in hardware
or even scsi_debug.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/Kconfig         |   9 +
 drivers/scsi/scsi_lib.c      |   4 +
 drivers/scsi/scsi_lib_test.c | 330 +++++++++++++++++++++++++++++++++++
 3 files changed, 343 insertions(+)
 create mode 100644 drivers/scsi/scsi_lib_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index addac7fbe37b..e20af95a912b 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -67,6 +67,15 @@ config SCSI_PROC_FS
 
 	  If unsure say Y.
 
+config SCSI_LIB_KUNIT_TEST
+	tristate "KUnit tests for SCSI Mid Layer's scsi_lib" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Run SCSI Mid Layer's KUnit tests for scsi_lib.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9b109192c51e..3590275f712e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3434,3 +3434,7 @@ void scsi_build_sense(struct scsi_cmnd *scmd, int desc, u8 key, u8 asc, u8 ascq)
 	scmd->result = SAM_STAT_CHECK_CONDITION;
 }
 EXPORT_SYMBOL_GPL(scsi_build_sense);
+
+#ifdef CONFIG_SCSI_KUNIT_TEST
+#include "scsi_lib_test.c"
+#endif
diff --git a/drivers/scsi/scsi_lib_test.c b/drivers/scsi/scsi_lib_test.c
new file mode 100644
index 000000000000..99834426a100
--- /dev/null
+++ b/drivers/scsi/scsi_lib_test.c
@@ -0,0 +1,330 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for scsi_lib.c.
+ *
+ * Copyright (C) 2023, Oracle Corporation
+ */
+#include <kunit/test.h>
+
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+
+#define SCSI_LIB_TEST_MAX_ALLOWED 3
+#define SCSI_LIB_TEST_TOTAL_MAX_ALLOWED 5
+
+static void scsi_lib_test_multiple_sense(struct kunit *test)
+{
+	struct scsi_failure multiple_sense_failure_defs[] = {
+		{
+			.sense = DATA_PROTECT,
+			.asc = 0x1,
+			.ascq = 0x1,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x11,
+			.ascq = 0x0,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = NOT_READY,
+			.asc = 0x11,
+			.ascq = 0x22,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ABORTED_COMMAND,
+			.asc = 0x11,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = HARDWARE_ERROR,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = ILLEGAL_REQUEST,
+			.asc = 0x91,
+			.ascq = 0x36,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = multiple_sense_failure_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+	int i;
+
+	/* Match end of array */
+	scsi_build_sense(&sc, 0, ILLEGAL_REQUEST, 0x91, 0x36);
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+	/* Basic match in array */
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x11, 0x0);
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+	/* No matching sense entry */
+	scsi_build_sense(&sc, 0, MISCOMPARE, 0x11, 0x11);
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+	/* Match using SCMD_FAILURE_ASCQ_ANY */
+	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+	/* Fail to match */
+	scsi_build_sense(&sc, 0, ABORTED_COMMAND, 0x22, 0x22);
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+	/* Match using SCMD_FAILURE_ASC_ANY */
+	scsi_build_sense(&sc, 0, HARDWARE_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+	/* No matching status entry */
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+
+	/* Test hitting allowed limit */
+	scsi_build_sense(&sc, 0, NOT_READY, 0x11, 0x22);
+	for (i = 0; i < SCSI_LIB_TEST_MAX_ALLOWED; i++)
+		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
+				&failures));
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+
+	/* reset retries so we can retest */
+	failures.failure_definitions = multiple_sense_failure_defs;
+	scsi_failures_reset_retries(&failures);
+
+	/* Test no retries allowed */
+	scsi_build_sense(&sc, 0, DATA_PROTECT, 0x1, 0x1);
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_any_sense(struct kunit *test)
+{
+	struct scsi_failure any_sense_failure_defs[] = {
+		{
+			.result = SCMD_FAILURE_SENSE_ANY,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = any_sense_failure_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+
+	/* Match using SCMD_FAILURE_SENSE_ANY */
+	failures.failure_definitions = any_sense_failure_defs;
+	scsi_build_sense(&sc, 0, MEDIUM_ERROR, 0x11, 0x22);
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_host(struct kunit *test)
+{
+	struct scsi_failure retryable_host_failure_defs[] = {
+		{
+			.result = DID_TRANSPORT_DISRUPTED << 16,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+		},
+		{
+			.result = DID_TIME_OUT << 16,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = retryable_host_failure_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+
+	/* No matching host byte entry */
+	failures.failure_definitions = retryable_host_failure_defs;
+	sc.result = DID_NO_CONNECT << 16;
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+	/* Matching host byte entry */
+	sc.result = DID_TIME_OUT << 16;
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_any_failure(struct kunit *test)
+{
+	struct scsi_failure any_failure_defs[] = {
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = any_failure_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+
+	/* Match SCMD_FAILURE_RESULT_ANY */
+	failures.failure_definitions = any_failure_defs;
+	sc.result = DID_TRANSPORT_FAILFAST << 16;
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_any_status(struct kunit *test)
+{
+	struct scsi_failure any_status_failure_defs[] = {
+		{
+			.result = SCMD_FAILURE_STAT_ANY,
+			.allowed = SCSI_LIB_TEST_MAX_ALLOWED,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = any_status_failure_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+
+	/* Test any status handling */
+	failures.failure_definitions = any_status_failure_defs;
+	sc.result = SAM_STAT_RESERVATION_CONFLICT;
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_total_allowed(struct kunit *test)
+{
+	struct scsi_failure total_allowed_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Fail all CCs except the UA above */
+		{
+			.sense = SCMD_FAILURE_SENSE_ANY,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		/* Retry any other errors not listed above */
+		{
+			.result = SCMD_FAILURE_RESULT_ANY,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = total_allowed_defs,
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+	int i;
+
+	/* Test total_allowed */
+	failures.failure_definitions = total_allowed_defs;
+	scsi_failures_reset_retries(&failures);
+	failures.total_allowed = SCSI_LIB_TEST_TOTAL_MAX_ALLOWED;
+
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x28, 0x0);
+	for (i = 0; i < SCSI_LIB_TEST_TOTAL_MAX_ALLOWED; i++)
+		/* Retry since we under the total_allowed limit */
+		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
+				&failures));
+	sc.result = DID_TIME_OUT << 16;
+	/* We have now hit the total_allowed limit so no more retries */
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_mixed_total(struct kunit *test)
+{
+	struct scsi_failure mixed_total_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x28,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			.allowed = 1,
+			.result = DID_TIME_OUT << 16,
+		},
+		{}
+	};
+	u8 sense[SCSI_SENSE_BUFFERSIZE] = {};
+	struct scsi_failures failures = {
+		.failure_definitions = mixed_total_defs,
+	};
+	struct scsi_cmnd sc = {
+		.sense_buffer = sense,
+	};
+	int i;
+
+	/*
+	 * Test total_allowed when there is a mix of per failure allowed
+	 * and total_allowed limits.
+	 */
+	failures.failure_definitions = mixed_total_defs;
+	scsi_failures_reset_retries(&failures);
+	failures.total_allowed = SCSI_LIB_TEST_TOTAL_MAX_ALLOWED;
+
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x28, 0x0);
+	for (i = 0; i < SCSI_LIB_TEST_TOTAL_MAX_ALLOWED; i++)
+		/* Retry since we under the total_allowed limit */
+		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
+				&failures));
+	/* Do not retry since we are now over total_allowed limit */
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+
+	scsi_failures_reset_retries(&failures);
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x28, 0x0);
+	for (i = 0; i < SCSI_LIB_TEST_TOTAL_MAX_ALLOWED; i++)
+		/* Retry since we under the total_allowed limit */
+		KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc,
+				&failures));
+	sc.result = DID_TIME_OUT << 16;
+	/* Retry because this failure has a per failure limit */
+	KUNIT_EXPECT_EQ(test, -EAGAIN, scsi_check_passthrough(&sc, &failures));
+	scsi_build_sense(&sc, 0, UNIT_ATTENTION, 0x29, 0x0);
+	/* total_allowed is now hit so no more retries */
+	KUNIT_EXPECT_EQ(test, 0, scsi_check_passthrough(&sc, &failures));
+}
+
+static void scsi_lib_test_check_passthough(struct kunit *test)
+{
+	scsi_lib_test_multiple_sense(test);
+	scsi_lib_test_any_sense(test);
+	scsi_lib_test_host(test);
+	scsi_lib_test_any_failure(test);
+	scsi_lib_test_any_status(test);
+	scsi_lib_test_total_allowed(test);
+	scsi_lib_test_mixed_total(test);
+}
+
+static struct kunit_case scsi_lib_test_cases[] = {
+	KUNIT_CASE(scsi_lib_test_check_passthough),
+	{}
+};
+
+static struct kunit_suite scsi_lib_test_suite = {
+	.name = "scsi_lib",
+	.test_cases = scsi_lib_test_cases,
+};
+
+kunit_test_suite(scsi_lib_test_suite);
-- 
2.34.1

