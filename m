Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE76CCA479
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 20:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiF1UNE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiF1ULz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 16:11:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719912C66A;
        Tue, 28 Jun 2022 13:03:12 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SJBWTK012398;
        Tue, 28 Jun 2022 20:03:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=TFmH33paTvH6YlZKdpHFk+ritk6F7f2maGo7L3AI/7Y=;
 b=IPc0JTo1vVo8ItA3+pfaXHNHD4eTL21QBCUfKaKCdOVdjWQ+1TYbqlhmBwlaV0vnAvnQ
 lr6fPBlPHl9l81zQvx6Cqx7wxIV9+Yln4cdsU1yZ0Bf47/mNOpbMdGPlmc2qPSuweOVA
 GveQROVszpDfPQ2bKlg9+Q+XAzNsinde3iiaGsSXUBkUY7PqswkixHu7CKZq6HpAYugD
 wETEWE3VgqwLEcOBQbvgLlLguRXy186u6gupVNSYJ84+jZTSEl0BjwyIBlCqhaBUt74y
 dDRgA7xO1jkakcBWDPrsNjosB/Rj0Vz783jGPQn+I1xerxl89dFkRvlw1SBJYXZrF7Dd Rg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwtwu76ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:03:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25SJswrC004573;
        Tue, 28 Jun 2022 20:03:04 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gwrt2v4yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 20:03:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fC2rmiyG3gHJDkacN/PFsJyTKZUbted2sy0QHv876nq9uG9PIaAbN14l5c3L9brAOlhtaSJczJRDF1lD+z7tGVjAQRPEQWKQ25FDYikAaLY62FBb7XuTGU1LxQjI/7hQhIq+5Rp8O7FX6sTN5paoZEkmLh9VMzzk6gy6ozvXH0I3lyowv0TIAbMo3k/dv/EgZvu6Soc+vg6yLmIf27yeBsaIElqJevYxmg9QB0XlYUJbjqqodmFzsbE07F0eScUlYpsD3wqKjZ/qPFZDqKsAqYBqrdWyZG+DlLnejGDOyntqpFuLvybrclfavbkFyYmbRw++xULtP51F34FqPWZwyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFmH33paTvH6YlZKdpHFk+ritk6F7f2maGo7L3AI/7Y=;
 b=cQneqqr+A80iNrEXFl5eP927rjJXRc52SrJfUIF3WnYXJVt6J+T2esIR02I+5onRChWCt3IHm3rAs2h7baV67VAH1c5PHsculI0jTNW99bCTiXadicDnEkp9Yz39Drhn8JuRC4Pla5s2k6HwBxxcWoolIvUaVgD6irSN+aZfj+uZRWphMWl+z1wcAtEbRiDLKQRFL6PE8MMTZmHzQONoIp6ya2daKofyolLVoePg69+cHO2VVhf6C2tfJE9YdTKYChjNDJwmTM3Zrm46Y8FIsj2CWfop8BcmZjBuL0UhW87uTIauoYJP6SWLbvzC4devMoFzr/EEeF/kE7LU26DCLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFmH33paTvH6YlZKdpHFk+ritk6F7f2maGo7L3AI/7Y=;
 b=U+7/Exr8UzI6tEK59dmSdSORnokHItObTkA6QgNTslW4dC9v7lX4Tv5x2R46q3sU0GiFb4SKJlmsfwhZtzXSWSTKP4YCjewSoQ6ExJub50kP/KRi5s4YkuZ6STKqgTXEphX1EfaS72pe8Goxt6T9o1yL9HltwgDVLzLqrB2i7k0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR1001MB2376.namprd10.prod.outlook.com (2603:10b6:910:48::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 20:02:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 20:02:57 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 4/5] scsi: target: Add file configure_unmap callout
Date:   Tue, 28 Jun 2022 15:02:29 -0500
Message-Id: <20220628200230.15052-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628200230.15052-1-michael.christie@oracle.com>
References: <20220628200230.15052-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:5:174::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71594733-7ae8-4c3e-dd1a-08da59412818
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2376:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qCNwSFBtL4sYap9+kH/CoUF/eA7gUNljSoLyOckpdWWtPShG6hhxS06CxJtaPi6ORtsft3HPn7Azy68iYdFbCulRCcrAdaanrMegeVhn6u6HAQXhiteXjVXFgiVVhVaUZ7gOdRekSseHAJIzUnxnRhsrUWT83br042WbqQI+8o2pHza8BN+2uvaVo0AEmg1xd2XRg5AdzD1/OVzyn5fph9ArTLr4oNe+M97gQEBhnKHXoN26zktoUwYXp3NJcwGG2kR3/AV3VO6v/6tteRWQNt0eszsFbmXr6vvFezkZoCcSSHNaEF9VAFmZ6ACUmHLQbGtQpiJZcLHI8AfXBbzJGvu1CuQlnOruu0it5dlvDgs4aCQOMZhjmgG8VYGoZgkHiN4w2BckKV6z5e7mOjuNzgEKq5ZB1AR20rYk+yGPfgJobMCx/RrtWvlF7igBljV+A0LBG1oOxMvaHxYeD8ykcU2V1fYD6TJ7cLgt94p8NR0GE+0rgE5gb1qyXRFm0/v6Cua6O5UGgJphHdUfYRyJX5T1W0sx/sj0UQ7PdQxJ4liO61k9+hu7EwKudigADi87KGduA5o/br7eWMeJ+UyKmn1ZOMw5whhUqhOqxS5DTtHjis6Klq27omb3DAa37rOXdgXK3ZkCCIKjf3ZWzFk+ucGPDF0ChCIXUwhrmrcjhx3+ESAmaLLV8rPRTmz+7oouT5nZXxnwW9YAG3yzR0v7R8G0rR+oznJ3quTJ8TQuwGjmZodgxpJu+gKVxKwu2iGGDp1O3VAJ1FjXkSHw2MYG4xQoU7ewUba9FXla1DEFJLY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(39860400002)(366004)(376002)(186003)(83380400001)(8676002)(6666004)(6506007)(2616005)(52116002)(1076003)(54906003)(26005)(41300700001)(6512007)(38350700002)(38100700002)(66946007)(36756003)(4326008)(2906002)(5660300002)(478600001)(86362001)(6486002)(8936002)(66476007)(66556008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rxAKMVUJcbZ5kdZaotK71OikRRFurjAKu+loJuCfxj10soszVO4Kbfwh1140?=
 =?us-ascii?Q?EqXWv72FUipNka60kfuJ4Alp3SVb9ulRVV++HEQpb1KQax80WKigOo/ldlaW?=
 =?us-ascii?Q?ihBh1VYmu4QHMbYUj2dOYViaXs80FLUOcpG5///YnX9wZw62vHtjLz2tji8k?=
 =?us-ascii?Q?/fbBDdeeOQ1WXYFJTXcxJtt5w9RpYOQku3B13b0MbHKgxQkctv2EMyTrYc+R?=
 =?us-ascii?Q?/5N+9hdvlZ1npP6mgtzEHQ0V/GNgVL+nmcopYL7IV8EMAfwHDihEpk/1OF8o?=
 =?us-ascii?Q?ba84x0FOhduyHRqqU7sZWYGsByG0l8X5RRge/tC56WGGbRtlNnuo4I6GfJA5?=
 =?us-ascii?Q?RVzVGEAp/VxKcxkwkNUv1zCp/C7zMBBDOAJqqQZoCNsqUR86wXI2kiDtyVhG?=
 =?us-ascii?Q?+Ltux330hXrIqm6g5NwOApsoTT+CFavo56DYiBDMrNQv0ofTnJQ6IcZCKlRp?=
 =?us-ascii?Q?eA+oEoCB0kcYBkqTcwJAKxZE5Np83JWPadXiu1ub36JEoBB6/myuHxKbVCCA?=
 =?us-ascii?Q?4NshzSmzy/x0bKR6I8AJPx0ygFLW7BqH4u49gym3Y6KlLrBGH8rWeKncJJNp?=
 =?us-ascii?Q?6d3tbxXIlhAz4kkJstJ/DEc+W20GJIVkRpdpoG0QL/Oy8j0hZOekWKrW7wMq?=
 =?us-ascii?Q?f/X8oiBjBsZgkkh4WGVpwT9dDpon1i1Q4XqOeS1KMggm0r9pgJWtBNKq0pBv?=
 =?us-ascii?Q?XS1ep0Qcu1Fvv4hnLXswZajdu23vXPHLD3Zc7kYGqxqHQYo4E65JCgXlZ74q?=
 =?us-ascii?Q?J8UxbpBBoAW8tb0n3Fv8o9JkKBVtlgOuyCwN8fphkeAjHa/yJkv0ONTy+sTy?=
 =?us-ascii?Q?90y8y8dQe+p+jhL8ASYsHzxAXDSrKV5GW8Xd+ZZ+FtQIbdlAIQz9+yEPCSTD?=
 =?us-ascii?Q?hbEAQhe7ZEC3nB6468aFeP0mqL4EII6rbxSKNdrIDdoWizXJJ9mAryXhf4S9?=
 =?us-ascii?Q?bwAf32hhfxOcnhzKV5kxzDFRR3I8i377ObeUu3Uh+liPCtyJb6ZZ/lsZOwYj?=
 =?us-ascii?Q?SoN6B8CbTrToQk5kn5Ml5PmzcveqNdgZxvQqqIpuCWt8301QSSTFucKmeToO?=
 =?us-ascii?Q?2RyMN4aqgyLcZj3Z5B0J7SBpnKc4CUVgEfSsNHkdW11zn29LI7cr+Azt26NJ?=
 =?us-ascii?Q?CQF7LOZxuiHbeFDJW6Hq5LtxwWDbypx4OxMb43L8542u+5i35aLEIeYAnC4U?=
 =?us-ascii?Q?TK9QL+tQuPDOeKLmDi/Uj+1/kl3BN4I471vQAYjZtOKWti0DWgGwf0/L8lKN?=
 =?us-ascii?Q?e7FD0zHfgrp20eN3ishe1LuDODmd1FBQcbBN087zfhS1hIUyByfGCeINEtof?=
 =?us-ascii?Q?64YoHrO/27GZ4Hn8U5iD05KkE2z+FhXjYNC+wI+/Qm8w5rXdVZdYkZlVS/5S?=
 =?us-ascii?Q?AVWlWtdu+qjHgFxBu6uZNH0u453k7cU0QYMMrxWpA3pGvQ2RJMajwyqftfxQ?=
 =?us-ascii?Q?I83PaxN2x9wXDIBU19YNAe/2lOZao5J7TH80pR56dCKk4itGFBVlD0ZDYsWT?=
 =?us-ascii?Q?wDJH3NHrFk46XGb6G/SRrtVw2BEFr2uPuJK1WPUs/FewWdCW0Kd6v+5/z1Hf?=
 =?us-ascii?Q?D+XCd7vWsQHWYjDwr4ZbEJEv6Q0xoETURj9w+MAPXK5S8glXjT4eqIyT3EUC?=
 =?us-ascii?Q?XQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71594733-7ae8-4c3e-dd1a-08da59412818
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 20:02:40.8373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xE2/+bKPSNKHLcQo/uMZhoVxjx96eIciXTz1Tw/KGW6nxieeCkQ7eSv6EE2gfrVaXHgY4Tdee1+OWAnGxtk01QrM/q39J2H2HPWTV/en0R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2376
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-28_11:2022-06-28,2022-06-28 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280079
X-Proofpoint-ORIG-GUID: hGGk0TnLxrkTDgC3ODwQpu9m5JElxwpX
X-Proofpoint-GUID: hGGk0TnLxrkTDgC3ODwQpu9m5JElxwpX
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move file's unmap setup code to a configure_unmap callout.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_file.c | 33 ++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index e8440e5dd804..28aa643be5d5 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -86,6 +86,24 @@ static struct se_device *fd_alloc_device(struct se_hba *hba, const char *name)
 	return &fd_dev->dev;
 }
 
+static bool fd_configure_unmap(struct se_device *dev)
+{
+	struct file *file = FD_DEV(dev)->fd_file;
+	struct inode *inode = file->f_mapping->host;
+
+	if (S_ISBLK(inode->i_mode))
+		return target_configure_unmap_from_queue(&dev->dev_attrib,
+							 I_BDEV(inode));
+
+	/* Limit UNMAP emulation to 8k Number of LBAs (NoLB) */
+	dev->dev_attrib.max_unmap_lba_count = 0x2000;
+	/* Currently hardcoded to 1 in Linux/SCSI code. */
+	dev->dev_attrib.max_unmap_block_desc_count = 1;
+	dev->dev_attrib.unmap_granularity = 1;
+	dev->dev_attrib.unmap_granularity_alignment = 0;
+	return true;
+}
+
 static int fd_configure_device(struct se_device *dev)
 {
 	struct fd_dev *fd_dev = FD_DEV(dev);
@@ -149,10 +167,6 @@ static int fd_configure_device(struct se_device *dev)
 			" block_device blocks: %llu logical_block_size: %d\n",
 			dev_size, div_u64(dev_size, fd_dev->fd_block_size),
 			fd_dev->fd_block_size);
-
-		if (target_configure_unmap_from_queue(&dev->dev_attrib, bdev))
-			pr_debug("IFILE: BLOCK Discard support available,"
-				 " disabled by default\n");
 		/*
 		 * Enable write same emulation for IBLOCK and use 0xFFFF as
 		 * the smaller WRITE_SAME(10) only has a two-byte block count.
@@ -170,16 +184,6 @@ static int fd_configure_device(struct se_device *dev)
 		}
 
 		fd_dev->fd_block_size = FD_BLOCKSIZE;
-		/*
-		 * Limit UNMAP emulation to 8k Number of LBAs (NoLB)
-		 */
-		dev->dev_attrib.max_unmap_lba_count = 0x2000;
-		/*
-		 * Currently hardcoded to 1 in Linux/SCSI code..
-		 */
-		dev->dev_attrib.max_unmap_block_desc_count = 1;
-		dev->dev_attrib.unmap_granularity = 1;
-		dev->dev_attrib.unmap_granularity_alignment = 0;
 
 		/*
 		 * Limit WRITE_SAME w/ UNMAP=0 emulation to 8k Number of LBAs (NoLB)
@@ -923,6 +927,7 @@ static const struct target_backend_ops fileio_ops = {
 	.configure_device	= fd_configure_device,
 	.destroy_device		= fd_destroy_device,
 	.free_device		= fd_free_device,
+	.configure_unmap	= fd_configure_unmap,
 	.parse_cdb		= fd_parse_cdb,
 	.set_configfs_dev_params = fd_set_configfs_dev_params,
 	.show_configfs_dev_params = fd_show_configfs_dev_params,
-- 
2.25.1

