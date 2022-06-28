Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BB9C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 02:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244844AbiF1CeB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jun 2022 22:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244998AbiF1CbP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2022 22:31:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187E3252A6;
        Mon, 27 Jun 2022 19:30:13 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25S25Y5Z031567;
        Tue, 28 Jun 2022 02:30:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ORleO6/yHEf9TjePbV6Aeb4wi3DTE/O980bg3jO9EiA=;
 b=iFncl9dbCIQsQZDUpZcslf2luEfGQ4h649cfTs3goA2FFnvNqkViWbLusw2fxCYSvEZG
 tn0Z/yw6jjx/ZDcZ01V6xJgT4wvbChxo4s6c9d2o9dM1zORDpEyVSJ41Gc9MAO399P72
 yDuFO4+rM0QI2jecCacdgBQFJ9ythPKJQ0iKtQ6hV2rf+d396Gp3tLhOj3rLJIflcAMl
 wiFIl8RqRbNC3UXUrZ76S0jp6/y2UYp6B4h6z6Ua8XoMrqSqYGE70Sgum7nw33SJShVp
 32Y9dWxG2jc7TiF8NTZ0RP9x5o6qYkpINT7gVLMzT4LnpQyFpb207hmtRGhH3AVOvYpe /Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gwrsccrkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25S2KJsE018705;
        Tue, 28 Jun 2022 02:30:03 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gwrt1t5vh-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 02:30:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWIQye9U8J8x4sNpNO//tmzbYYRCO3+AFunzmThqHHhlU5fFjleF+ez4meIJ4csDwjoR6rGwhiknPrEOn07dDJgWeLL1qm9Q1v28M43HdWnYFYJC1xaXORradD5/JOttP0fWUNvMmFMmga12cB7gMQI/HpJKpiWjywgBbbWM4HBJO3u6dXvcVb6wimQhHCe+TaxMxpS92d9SagMDBN37n5CKShvqUKBDbyk6SXa4uBbp8nEYmd6MidtOtIoE4pVrQVfaeCfyRlYwsa0Iu0PvANL6yp44spcYTJS56SXLi63MYHZsFHL6znKsPa27JXzsewG0gimamUW60qN8BYXO1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ORleO6/yHEf9TjePbV6Aeb4wi3DTE/O980bg3jO9EiA=;
 b=VvtxEL2yMDeI9c1+LgzpFS3k8ytG9QR3kh34l5fbDeA1qWplVPPDNB6ul3OneKsBb3d3/NWUgejeolvy9G4gXac5Tor3UbufkKqA0WP/lyTE6GuL6AZz/KrRBg13JqjiAk/8WIYgISscr0+MKH6kkAi5Hhab5mg11blItllR9eeVuWaez6fT1ZuHcRst325MsPmnZtOSzEYvT/vd1gx/g25JjNfElUqdaYo4ZqwWpQu+aWYtTKv/Y/DXCpQdKiPBJ6kzeRHFn83KztfcDCuT4X9hBiQuQ6/GtvTzSV74HuqnpDpf5Fv+RBUQZ26d5Ut6uGpUrcut0gwGkF+2eRjDEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ORleO6/yHEf9TjePbV6Aeb4wi3DTE/O980bg3jO9EiA=;
 b=ihypF0ua4Dy1GWL5c0lNDkoIrF8WbaRJobCMdU2KhkH/Imudx9lT+K/lYRd421JWzTqGu/I6p64ZC+zvchyZxmdSakElxHyOD0t9ACiQEXFF/BhdVATS/7hPUFOVH2ovrp81GQFUZkB1+a3X5Rzzf77kP6I5C1gBxFab/XfVJ4k=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB5140.namprd10.prod.outlook.com (2603:10b6:208:320::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Tue, 28 Jun
 2022 02:30:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 02:30:02 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 4/5] scsi: target: Add file configure_unmap callout
Date:   Mon, 27 Jun 2022 21:29:52 -0500
Message-Id: <20220628022953.20948-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628022953.20948-1-michael.christie@oracle.com>
References: <20220628022953.20948-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0P220CA0023.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:ef::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0df3b54a-3b97-416d-5deb-08da58ae1ad7
X-MS-TrafficTypeDiagnostic: BLAPR10MB5140:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UShEb2F8c+BcdhSjaZqdPi4d65fEVaL+53iqJuGbFgeHEzcMFooHEz8JWVnSn4GnX/NQuN4o+LJ7BTlBt9QIdfCWhXXvu+z6+941m3kNuLW3FFyKjEX+H7ZVRbWNGEPMHUigTlcs9Ln/KNjDKXOOZZxpM7P4u8KVFZbGLoYbxH5djwQMQmsfh2Xg9QXgLIL1OPKDU0xoLHG6IYy5/AQtAyR8+wZsZKag4x5jOgeBje7fFbtCcJ2RiwEiTyxPmdpO4XimSp3nF4GyvLGmGXytEN+e5w73yFHt7xSsqPU+ALSJbXXf+tvh9KmzdWpKY1jtvyHiy3Y++507HLtlM4rQg14q4P8QG04qclGCpfaM9nnFKs6T7IiIy7fZ/FXsDaNqvAQNeGKUURuIsRI+u41mAoQiE30GpvtKOy9CkzV1Sd9dUlotqUTQEV8l0vwXnXTGlA413ptoqLh/ddZ68D6L9HH+/g08WkyWhFJXcdYHmYm8YuwhnEy0rbrHrpU3m8pj10SE2zDQKXoUBIHO1+ILdvmvMwg//231s7nTvzxmMuxanI67inasOqUrwZ0mwi1GXizhfUAoG9gaSn1dbypPX1tYPb0Qgzq84jEg/vNSiqOX6N7tNciaC7N3zDWXsh9fTA8xECKqxN4q7DpLHFrAgng+a6U/HNsDLD883wAkTTDISXFi/s8FKQ39o6XRgTrgk40X8eBlAaYGty0WY1Gh20v4L5frehqWXK5UezBlbTVbZ78ExO36Co6zJlybdB+Y+TTBebl2IHrcdBiZycVGGaOUsVkANUKiGHp650POfxM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39860400002)(396003)(376002)(346002)(478600001)(26005)(83380400001)(2906002)(52116002)(107886003)(6512007)(6486002)(2616005)(4326008)(8676002)(5660300002)(186003)(66946007)(6666004)(66556008)(8936002)(1076003)(38100700002)(36756003)(41300700001)(6506007)(38350700002)(86362001)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MsYxzXU3vBC+MZA27aE2yxyxGXzMmb4TlrthP+zvFsM2QguV6OCmmhv7prHv?=
 =?us-ascii?Q?fSZOrfJEbHJ7AvW2Fgx0kGohG08s8dMWsRqyb6ezwVBwAW+GIHL+42ofHcu9?=
 =?us-ascii?Q?jeb+tyTycajr1aerwGjkJFKrpuw+fNWPH4pjqZXKfdWJqrSlafaeZwsMBz60?=
 =?us-ascii?Q?2SAv14eDlcUPC9cKqAl3jjit+7CICevBIDPWAB09Ra8OmHccaFUGTYfPH2HF?=
 =?us-ascii?Q?w1o9APuDSuUYOAST5VMMC3VaqSikFA9o8oqoZJcdHZ24d2z4FnJBs9bVpicm?=
 =?us-ascii?Q?F7LZr6MF8XmnAny6QXeWtkZA51KyV0RC6/yKw2pO6orwLO8VtMBiV5bGgdS6?=
 =?us-ascii?Q?W9DWlx8gYh7UP2NZOyCqodYl5wODLNe7+KxuXxDB2kYEdKTQyFLKoyssimLy?=
 =?us-ascii?Q?CFbjIYrLUROECaX87+MvY2b7htLWao2vDMU1wF9Z8eE7/BYImv0kclmSELzU?=
 =?us-ascii?Q?vcKafSki55r0+IIpxQAlAEXCLukg6gOPG4IT4GngeA1PP5ttnmsR6eTJ5rwz?=
 =?us-ascii?Q?goTKCj+Ur4sOdr87O9NmIsECCGMqMEGdklVT23tiLtLwU/kSSn2dOBOjGCJA?=
 =?us-ascii?Q?DJJGuZb3+W9JStrK894OmjFFFjdT4Z+HZGROpvb4JMEMrFyFGDz10+zQvMbo?=
 =?us-ascii?Q?fLZ0TReUc47OwLGXYwBQTfQrdmGbrvSUkXve0IU7gcEoU+YskAYKD4jb3/AH?=
 =?us-ascii?Q?JiLETHUzKl4Xj6QtJuc/zC9v2HxrKMSpzyLXhWa8qJFA/7ZTjBDOP2hFRqAX?=
 =?us-ascii?Q?cYWpHEZun8H+CMw/IkiSCpLBZFTJN0yNp53dFaJXfmt7Jsj90Ub04oWdIPJQ?=
 =?us-ascii?Q?vXUXOQ099JJV1mIU8XIu15OGRp1e7fZ837QJh5frRKO8ICohC3RJ1ggBhz54?=
 =?us-ascii?Q?qnhs8OgAefBC46gy8+DRdeojIzxykdajOMwWQOIBIwtw+pw+lmZEG6U4sbQA?=
 =?us-ascii?Q?BWrgTQhhOkza98ffw/hKrMwySD4+9LVb9jv3MCGeJL4nXjFOoxlJcXRwjGb/?=
 =?us-ascii?Q?l1tHlwKvlP2shDLXXazEd6vMHywKJRji67bfoK7WgxFbHLC5eTYOQPq6/mcn?=
 =?us-ascii?Q?izonV1I0T3Hz1fQ8Z6woPVTErEnQzQLoGdrqEUiHJBJch8XrZ1UYU0siLZuH?=
 =?us-ascii?Q?4v3RALuf824n50zae+pAbJD0EzLgNtss8xaUYRq+XLi/xF1D3LACeOImcpLK?=
 =?us-ascii?Q?NaYuf7ifI5XGcTGD6Fnldnx/bI3S6ADaaw0GNW4DQ96YndGff7uGbZLpn7T2?=
 =?us-ascii?Q?NUDZ+qwguaspD0BZyF0OWwLq4wlUxw9re/y6vK2dO/GwY+ci3pmRysOWEqBH?=
 =?us-ascii?Q?uwZQCqSJ6XZzLqtEd3b9OEhnBS8WuMXRPYffNWnS4n8zbrG6u8lymUxT72Zz?=
 =?us-ascii?Q?cIbdaUVyh310qXYD+rSvRyXoN5Z6puX5rPhqO42/wIb2hjoZzvuXYAQ3MfAg?=
 =?us-ascii?Q?8SND2Fxz42Xbz28Cr/oHNypn3UeWpW7qVqLR36sJQhlv48B1lw1dKH7WYC4d?=
 =?us-ascii?Q?OsTlwOkvNT946MyUnlpEghyCipiNPPBNxxBjdEj/dbu9g9gojhXLlBB6gnQm?=
 =?us-ascii?Q?HGut+Ws92Orgt8eyaJRhiaARxrWiJnuzH08qP7J1Nd5vXgucfMrcOU6Ltywb?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0df3b54a-3b97-416d-5deb-08da58ae1ad7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 02:30:02.5784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5pzVmlbvexybngO1lJWnMAhuDgisCpuV5hU6CAWkZEvDrq03MzXwx3SzJXzVqs+JsDjXXU2vVnrrgPGBfDw61inl6mtgSSfLSa8Nno15qDA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5140
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-27_06:2022-06-24,2022-06-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206280009
X-Proofpoint-ORIG-GUID: SFF8KC9ixZCt35kfJza7MK9HtX7t-AGK
X-Proofpoint-GUID: SFF8KC9ixZCt35kfJza7MK9HtX7t-AGK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move file's unmap setup code to a configure_unmap callout.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_file.c | 38 +++++++++++++++++++------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index e8440e5dd804..08212eadee28 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -86,6 +86,29 @@ static struct se_device *fd_alloc_device(struct se_hba *hba, const char *name)
 	return &fd_dev->dev;
 }
 
+static bool fd_configure_unmap(struct se_device *dev)
+{
+	struct file *file = FD_DEV(dev)->fd_file;
+	struct inode *inode = file->f_mapping->host;
+
+	if (S_ISBLK(inode->i_mode)) {
+		return target_configure_unmap_from_queue(&dev->dev_attrib,
+							 I_BDEV(inode));
+	} else {
+		/*
+		 * Limit UNMAP emulation to 8k Number of LBAs (NoLB)
+		 */
+		dev->dev_attrib.max_unmap_lba_count = 0x2000;
+		/*
+		 * Currently hardcoded to 1 in Linux/SCSI code..
+		 */
+		dev->dev_attrib.max_unmap_block_desc_count = 1;
+		dev->dev_attrib.unmap_granularity = 1;
+		dev->dev_attrib.unmap_granularity_alignment = 0;
+		return true;
+	}
+}
+
 static int fd_configure_device(struct se_device *dev)
 {
 	struct fd_dev *fd_dev = FD_DEV(dev);
@@ -149,10 +172,6 @@ static int fd_configure_device(struct se_device *dev)
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
@@ -170,16 +189,6 @@ static int fd_configure_device(struct se_device *dev)
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
@@ -923,6 +932,7 @@ static const struct target_backend_ops fileio_ops = {
 	.configure_device	= fd_configure_device,
 	.destroy_device		= fd_destroy_device,
 	.free_device		= fd_free_device,
+	.configure_unmap	= fd_configure_unmap,
 	.parse_cdb		= fd_parse_cdb,
 	.set_configfs_dev_params = fd_set_configfs_dev_params,
 	.show_configfs_dev_params = fd_show_configfs_dev_params,
-- 
2.25.1

