Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBE1C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 00:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiHIAHo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Aug 2022 20:07:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244673AbiHIAHc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2022 20:07:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8561A39E;
        Mon,  8 Aug 2022 17:07:29 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278Nwhfm031116;
        Tue, 9 Aug 2022 00:04:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=m0kvZ3RVL4SOox3h7WiiZhFFZB/A329zcZM2Cla3ZAA=;
 b=23CznWdC24/qxtyek4aq2I0uskeHwBKkiLr+lraFpHj8n0o1VCDvTbuiOol44zoEXWcp
 srZh8AObLguLOw//+RKnokfi/C3uE6lPtt+liZeVnzJIh2o8gYq8slkUbQhfkPP3NMhp
 pPSbf8GqOHha/j8peNZbjHMrNiHCV/askZ82i80eSsy1qFZ/FW9k/zZ9FgXffLFPfn06
 7aJCi24wGT1EJtx24zOHgTCMQU6QR3r3x2I0qHRSF4GXeBVQN7if+eN55MjtMDQQDrR2
 OwT8iXACj1AGhorBIWT2Qn3XJe5gv8LyGS5kmithPBgMlVU3vjWX5KugMsTtQ4fWC4c1 xw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsew155ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:56 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 278M0huv013005;
        Tue, 9 Aug 2022 00:04:54 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hu0q2b9q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 00:04:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jme8aITXh3fOLYXVJivRX+KQ+3SxDRzNN0k4gfTabgeCsNg2QtZD7aZWC2XoX+s9/HErvOavzIz6MV/MH6LwP49Zi1m6LhW6KQ95XGPlvMv8XjI6a+N9ywkepburcnNpUee8ABdha3fGbbSIgzGkb5yZXw9Ps1jLkUQOXlN1nafAqX7sMnXLuUt60DvZmmpI+3RmNDaB72MUf3SD24jlHERFClhe7rBqqZ8Z4bUK4FADD8NhMl6eA1Zptu8LoVsTpkeqz7E1k+LKcyXSjuyNsNVzxPxI9pcvkA0iNfjUm/rU+YYEl4mTo/Rjg/JMYd4fOK4CRBbkeun0Yo2HbBG8tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0kvZ3RVL4SOox3h7WiiZhFFZB/A329zcZM2Cla3ZAA=;
 b=aW6ZVI9Mr5S1oYRlAy+p6oO0Nozu9j5d78qbhD6DxxF9TEuYYeW90jYEqNJWSobVPfmDJqUmRyVTyeh8rd1oYI8Qpc0vYMWr1yGlGmxiUfRiZVnfLOoBVKUBFXmlS6ffqgE6NbAsN6gkGxZoY99CTCZaD8hIB+vrDFztGn5WbSUALZ0s18r8lQ8aKPcTh2xdgG5ALDBR2cC02HCZIcE99n5wdN9z8CZXQVZHoWNtYUneNfitrkWC/dWVyaQuDvhNufD0gaZbWoam5cUhcij6OGX112yMjniOTSSKqMpJ57HDXf/jALdWzNk40Rjsgo4odMXG9DMW6KWOqZ7uFdJbcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0kvZ3RVL4SOox3h7WiiZhFFZB/A329zcZM2Cla3ZAA=;
 b=KOOBEdlxXv8/DPiHCbjHztcBX4qDj23WGh+czdvxvCrssjpLy8+KN4dXQJNYfO7dwrO6RKorwR9Zy0oP/1QoJ/DSNx1MIT5uvzJ69wlLCvbO+2GTZF+FstOA2H/X2rmZkNL/+JeBLVSwZaJuARG4ARoHxXSeWENyDQpeAX9McDY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB4907.namprd10.prod.outlook.com (2603:10b6:610:db::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 00:04:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 00:04:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        hch@lst.de, linux-nvme@lists.infradead.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 20/20] scsi: target: Add block PR support to iblock.
Date:   Mon,  8 Aug 2022 19:04:19 -0500
Message-Id: <20220809000419.10674-21-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220809000419.10674-1-michael.christie@oracle.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:610:52::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e802cc7-5061-4d76-948c-08da799ac8cd
X-MS-TrafficTypeDiagnostic: CH0PR10MB4907:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c41la7kRcYMM3TqH+mIfwx977NIhQ7pKLjMZyIZb8f1lCrxd8O9lbC4l4IZQdeqCJt1ABj9wWNo2DO4F8r1fc7jeo9hh1ZPouQs4xrXVl6lSqjZkOCklRIcHfrye1SDXLi2JGddo1vKKBpK79VMVemP2MCuj100Fex53fUEdgZPpwkCEMfNsEnuuj+B4AUIfalA7rgwv/MW6LgwpjHFluZdkV2Ibo7pFKrpBhREPtxgZZC0B2lp/pjRlQ922ms82//UlYVEtuOvTDneqY1T2Ncgas+5RCamdzuAAxkahGhJe5DcY+q2Aa1tA7KnycOLhsm3ktdE+27lFr1B8w3Np0rO2enWz2Nl+86ta6WgrvbJPKQ0JByCoEyn7ii5qM+Tqt2924J6fAYnXgWKVMDXMbSSVVhlM+ZvUFRolP/ZxMf7SpCePvqMURH86fOTwT6tS3A/eyR0OxEJFaN8YurMwuA/WRw8tPbIvw9CdCKjL59NlyGn/2zuKVnpjE8A653t7fHNjzJ6Bq0MkjXWt+N3RRvR9iQj6vJhHe3tWCwqmN5Mx7xWgf7KhhEgR9iQ4htjaNa6sdlX9z/JrbT+xon2jgwNrz7A1hUO9PVpF5sS2s70cPJzFl278/l/HDEiNMLVRgQHBMdehHUXnZJEj9LR31eKqrqKn/8mklvuRXGufxW1SOT+4BgzMyKNjVtKbqgn+e5b8rZfM61UrKHw268bNhcEOp8kNiLO40lecu6Ag/XAvNWGRbr7AXsf9pmorFBjm7fr8jAUB00j16AjQu6yS12Y2Zg9e/42kHKDkEzwG9Jg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(136003)(346002)(376002)(39860400002)(921005)(30864003)(6666004)(41300700001)(6512007)(26005)(2906002)(6506007)(83380400001)(2616005)(107886003)(38100700002)(86362001)(186003)(6486002)(1076003)(316002)(66476007)(66556008)(36756003)(8676002)(66946007)(4326008)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIZQel2f27JgYUzVC1vhZNL6/Gj2JOi9gb0uFjoGFShJMgw0wO+066LZqnvb?=
 =?us-ascii?Q?0DdDI/HffchghryNF3vHPsHJcjA6S1CFta/Bv/FJfweAzklKJHYAHm6YSTD7?=
 =?us-ascii?Q?rR8m+To1xWwaReDxHaNMNsGxfsqetqXpcN1jPZo58mgoJZVJry6oCS9k6CZ0?=
 =?us-ascii?Q?+dw509WwQQ37OlGlbtKQmapGC6iWYubn6Jzxn3s0Eu4sOIjOb8R6CfntUISw?=
 =?us-ascii?Q?WeFzZWctrc7RbrqvQld4M1u3T3NqIVW7RUUEyF9qZgs4qY8G9KsCGBVG7+v9?=
 =?us-ascii?Q?qkgfukOBCuICZTJf8j6BrGcUcdDb6kAP8/7AF6yn1YZh5zOCPIAk2H5sVq7A?=
 =?us-ascii?Q?KJ4p4/cf5e8eGYFERsJqxyVHGIrbd7AnfC6/DwLMfnxcmwjJ45nO5Je1XSXK?=
 =?us-ascii?Q?71iNzzLVMR3ptJ3EBxPWU+dkXdqAQkMnyE4pnjm6Qf7Aox+e2GCgI9vfUawF?=
 =?us-ascii?Q?h2jlb4ML0M5YFsgZd8SdRjOJ/m5+mpuxysjhPg/0tiNAqYmyKNMqU5YFmWin?=
 =?us-ascii?Q?ftKwAGNfAX6kmWrd4I7Dxb7JxqZXXg8voiMkdkImkwlrQFFoaVsDoj0byW98?=
 =?us-ascii?Q?k0Su8EFUElgbTYHwjxaqApvELVUrOjjidQn0A0+GS0Jj8G1Ht1RFlexvMGcq?=
 =?us-ascii?Q?5ZQ9bZPfZZeoeAY141bq1+TX7pI9ixY4JkLftLGGXlefDtNiNVAgzL0Oh9NK?=
 =?us-ascii?Q?TU64p8QXzPEaWty7RVTsWrtTSDaUgGMfblncAx0tEcuuQ2Dh3qwEjo/td/mG?=
 =?us-ascii?Q?BeoEhsgrp6IKMS9Lp04CSjiQLJsGbD2pXZjXnlqkHL61EuoWUbyU1HSkVogd?=
 =?us-ascii?Q?lZLOOzVkQgRO0C8DGBZOJvSbUyc1vEigFC9tjxuY4TRGxqDpYPmB/ps2A2MG?=
 =?us-ascii?Q?cFgpkJXBahvfEU+txdUn7wNV+oIlNVUerf85fJf16Kew3nWTo5MJBqco9cVV?=
 =?us-ascii?Q?v51OdL99sHicPj+k8lmeRFG1h9KjKDN9QTpJu44NsSUki7h25CgDkmWF46Wm?=
 =?us-ascii?Q?Kh6ookluSij4neLxQCdFNPAqq3LeRm6eCduYgrRmIlJzq1GYiCRK9cY/fl4K?=
 =?us-ascii?Q?7V5hJ/hOjtmJh24C77bRAy+cyVW4QT2UGUQHJoU9ljujyx0QUZ2HYA6dh1dp?=
 =?us-ascii?Q?hrJcvD9tbuSowUNtid7X7QMAmClVVpDL9TDZj0/kMPgOHQGszsZrScxUMam2?=
 =?us-ascii?Q?PYemxlWwcBIVonANPwXd3IdKgjCnx++O7GU/0sGPa5LjjcFhUI7cwUyxRdEC?=
 =?us-ascii?Q?v4tkfqgE9yRCv4Z7jezlAaHgnNkRSZDIMQglGMYoiSrFBH3xV8hnOrgAVThd?=
 =?us-ascii?Q?zxq+Dwgt3jD25EDdk4ssZAsqaOnLR2oxS9PYM3M7AgGnqtughzFC1h65sC5T?=
 =?us-ascii?Q?X9+MeEObLTVMhY5xDHIlEpxNKdzi72Xcm5jDRNFnnTwFGw/6Xy39ES/puuwJ?=
 =?us-ascii?Q?cYfqSAw6MITUC6M237OTV4TVDtvC7jHYX5FbkWD1narJhKOiGuKwjTsITmQ0?=
 =?us-ascii?Q?NCMTiZZo9OLCWU4EKXLLazi0C78FxFarKuFEiBWEKhf8QMBZT3m1Wx4hEd7X?=
 =?us-ascii?Q?pB4ncuWW9CrW2JTR0o16yuANecRtdDzubm+VXEsfDczLqbv4QuG3P4Z8gp8R?=
 =?us-ascii?Q?fQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e802cc7-5061-4d76-948c-08da799ac8cd
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 00:04:52.8593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8M6GK8lGA2a4E+6TZinQKbpLazolIMymBK2ccPd9RXfEYET4upu2pzkk097IY4Y6lVcQI5Kfl8DqqIXMSqwctQ01Rw5YxuHMo3vL7jexryI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4907
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_14,2022-08-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080105
X-Proofpoint-ORIG-GUID: eONwk7P5Gt-kvBU0S-4RHwbJbT4n7Weh
X-Proofpoint-GUID: eONwk7P5Gt-kvBU0S-4RHwbJbT4n7Weh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds support for the block PR callouts to target_core_iblock. This
patch doesn't attempt to implement the entire spec because there's no way
support it all like SPEC_I_PT and ALL_TG_PT. This only supports
exporting the iblock device from one path on the local target.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 292 +++++++++++++++++++++++++++-
 1 file changed, 287 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 5db7318b4822..caf6958dd75d 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -23,13 +23,16 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
+#include <linux/pr.h>
 #include <scsi/scsi_proto.h>
+#include <scsi/scsi_block_pr.h>
 #include <asm/unaligned.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
 
 #include "target_core_iblock.h"
+#include "target_core_pr.h"
 
 #define IBLOCK_MAX_BIO_PER_TASK	 32	/* max # of bios to submit at a time */
 #define IBLOCK_BIO_POOL_SIZE	128
@@ -310,7 +313,7 @@ static unsigned long long iblock_emulate_read_cap_with_block_size(
 	return blocks_long;
 }
 
-static void iblock_complete_cmd(struct se_cmd *cmd)
+static void iblock_complete_cmd(struct se_cmd *cmd, blk_status_t blk_status)
 {
 	struct iblock_req *ibr = cmd->priv;
 	u8 status;
@@ -318,7 +321,9 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 	if (!refcount_dec_and_test(&ibr->pending))
 		return;
 
-	if (atomic_read(&ibr->ib_bio_err_cnt))
+	if (blk_status == BLK_STS_NEXUS)
+		status = SAM_STAT_RESERVATION_CONFLICT;
+	else if (atomic_read(&ibr->ib_bio_err_cnt))
 		status = SAM_STAT_CHECK_CONDITION;
 	else
 		status = SAM_STAT_GOOD;
@@ -331,6 +336,7 @@ static void iblock_bio_done(struct bio *bio)
 {
 	struct se_cmd *cmd = bio->bi_private;
 	struct iblock_req *ibr = cmd->priv;
+	blk_status_t blk_status = bio->bi_status;
 
 	if (bio->bi_status) {
 		pr_err("bio error: %p,  err: %d\n", bio, bio->bi_status);
@@ -343,7 +349,7 @@ static void iblock_bio_done(struct bio *bio)
 
 	bio_put(bio);
 
-	iblock_complete_cmd(cmd);
+	iblock_complete_cmd(cmd, blk_status);
 }
 
 static struct bio *iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num,
@@ -759,7 +765,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 
 	if (!sgl_nents) {
 		refcount_set(&ibr->pending, 1);
-		iblock_complete_cmd(cmd);
+		iblock_complete_cmd(cmd, BLK_STS_OK);
 		return 0;
 	}
 
@@ -817,7 +823,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	}
 
 	iblock_submit_bios(&list);
-	iblock_complete_cmd(cmd);
+	iblock_complete_cmd(cmd, BLK_STS_OK);
 	return 0;
 
 fail_put_bios:
@@ -829,6 +835,279 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
 
+static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
+					    u64 sa_key, u8 type, bool aptpl,
+					    bool all_tg_pt, bool spec_i_pt)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct block_device *bdev = ib_dev->ibd_bd;
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	blk_status_t blk_stat = 0;
+	int ret;
+
+	if (!ops) {
+		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	switch (sa) {
+	case PRO_REGISTER_AND_MOVE:
+		pr_err("PRO_REGISTER_AND_MOVE is not supported by iblock PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	case PRO_REPLACE_LOST_RESERVATION:
+		pr_err("PRO_REPLACE_LOST_RESERVATION is not supported by iblock PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	case PRO_REGISTER:
+	case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
+		if (!ops->pr_register) {
+			pr_err("block device does not support pr_register.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		/*
+		 * We only support one target port. We don't know the target
+		 * port config at this level and the block layer has a
+		 * different view.
+		 */
+		if (spec_i_pt || all_tg_pt) {
+			pr_err("SPC-3 PR: SPEC_I_PT and ALL_TG_PT are not supported by PR passthrough.\n");
+
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		/* The block layer pr ops always enables aptpl */
+		if (!aptpl)
+			pr_info("APTPL not set by initiator, but will be used.\n");
+
+		ret = ops->pr_register(bdev, key, sa_key,
+				sa == PRO_REGISTER ? 0 : PR_FL_IGNORE_KEY,
+				&blk_stat);
+		break;
+	case PRO_RESERVE:
+		if (!ops->pr_reserve) {
+			pr_err("block_device does not support pr_reserve.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_reserve(bdev, key, scsi_pr_type_to_block(type), 0,
+				      &blk_stat);
+		break;
+	case PRO_CLEAR:
+		if (!ops->pr_clear) {
+			pr_err("block_device does not support pr_clear.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_clear(bdev, key, &blk_stat);
+		break;
+	case PRO_PREEMPT:
+	case PRO_PREEMPT_AND_ABORT:
+		if (!ops->pr_clear) {
+			pr_err("block_device does not support pr_preempt.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_preempt(bdev, key, sa_key,
+				      scsi_pr_type_to_block(type),
+				      sa == PRO_PREEMPT ? false : true,
+				      &blk_stat);
+		break;
+	case PRO_RELEASE:
+		if (!ops->pr_clear) {
+			pr_err("block_device does not support pr_pclear.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_release(bdev, key, scsi_pr_type_to_block(type),
+				      &blk_stat);
+		break;
+	default:
+		pr_err("Unknown PERSISTENT_RESERVE_OUT SA: 0x%02x\n", sa);
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (!ret)
+		return TCM_NO_SENSE;
+	else if (blk_stat == BLK_STS_NEXUS)
+		return TCM_RESERVATION_CONFLICT;
+	else
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+}
+
+static void iblock_pr_report_caps(unsigned char *param_data)
+{
+	u16 len = 8;
+
+	put_unaligned_be16(len, &param_data[0]);
+	/*
+	 * When using the pr_ops passthrough method we only support exporting
+	 * the device through one target port because from the backend module
+	 * level we can't see the target port config. As a result we only
+	 * support registration directly from the I_T nexus the cmd is sent
+	 * through and do not set ATP_C here.
+	 *
+	 * The block layer pr_ops do not support passing in initiators so
+	 * we don't set SIP_C here.
+	 */
+	/* PTPL_C: Persistence across Target Power Loss bit */
+	param_data[2] |= 0x01;
+	/*
+	 * We are filling in the PERSISTENT RESERVATION TYPE MASK below, so
+	 * set the TMV: Task Mask Valid bit.
+	 */
+	param_data[3] |= 0x80;
+	/*
+	 * Change ALLOW COMMANDs to 0x20 or 0x40 later from Table 166
+	 */
+	param_data[3] |= 0x10; /* ALLOW COMMANDs field 001b */
+	/*
+	 * PTPL_A: Persistence across Target Power Loss Active bit. The block
+	 * layer pr ops always enables this so report it active.
+	 */
+	param_data[3] |= 0x01;
+	/*
+	 * Setup the PERSISTENT RESERVATION TYPE MASK from Table 212 spc4r37.
+	 */
+	param_data[4] |= 0x80; /* PR_TYPE_EXCLUSIVE_ACCESS_ALLREG */
+	param_data[4] |= 0x40; /* PR_TYPE_EXCLUSIVE_ACCESS_REGONLY */
+	param_data[4] |= 0x20; /* PR_TYPE_WRITE_EXCLUSIVE_REGONLY */
+	param_data[4] |= 0x08; /* PR_TYPE_EXCLUSIVE_ACCESS */
+	param_data[4] |= 0x02; /* PR_TYPE_WRITE_EXCLUSIVE */
+	param_data[5] |= 0x01; /* PR_TYPE_EXCLUSIVE_ACCESS_ALLREG */
+}
+
+static int iblock_pr_read_keys(struct se_cmd *cmd, unsigned char *param_data)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct block_device *bdev = ib_dev->ibd_bd;
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	int i, ret, len, paths, data_offset;
+	struct pr_keys *keys;
+
+	if (!ops) {
+		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (!ops->pr_read_keys) {
+		pr_err("Block device does not support read_keys.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	/*
+	 * We don't know what's under us, but dm-multipath will register every
+	 * path with the same key, so start off with enough space for 16 paths.
+	 */
+	paths = 16;
+retry:
+	len = 8 * paths;
+	keys = kzalloc(sizeof(*keys) + len, GFP_KERNEL);
+	if (!keys)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	ret = ops->pr_read_keys(bdev, keys, len, NULL);
+	if (!ret) {
+		if (keys->num_keys > paths) {
+			kfree(keys);
+			paths *= 2;
+			goto retry;
+		}
+	} else if (ret) {
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto free_keys;
+	}
+
+	ret = TCM_NO_SENSE;
+
+	put_unaligned_be32(keys->generation, &param_data[0]);
+	if (!keys->num_keys) {
+		put_unaligned_be32(0, &param_data[4]);
+		goto free_keys;
+	}
+
+	put_unaligned_be32(8 * keys->num_keys, &param_data[4]);
+
+	data_offset = 8;
+	for (i = 0; i < keys->num_keys; i++) {
+		if (data_offset + 8 > cmd->data_length)
+			break;
+
+		put_unaligned_be64(keys->keys[i], &param_data[data_offset]);
+		data_offset += 8;
+	}
+
+free_keys:
+	kfree(keys);
+	return ret;
+}
+
+static int iblock_pr_read_reservation(struct se_cmd *cmd,
+				      unsigned char *param_data)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
+	struct block_device *bdev = ib_dev->ibd_bd;
+	const struct pr_ops *ops = bdev->bd_disk->fops->pr_ops;
+	struct pr_held_reservation rsv;
+
+	if (!ops) {
+		pr_err("Block device does not support pr_ops but iblock device has been configured for PR passthrough.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (!ops->pr_read_reservation) {
+		pr_err("Block device does not support read_keys.\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (ops->pr_read_reservation(bdev, &rsv, NULL))
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	put_unaligned_be32(rsv.generation, &param_data[0]);
+	if (!block_pr_type_to_scsi(rsv.type)) {
+		put_unaligned_be32(0, &param_data[4]);
+		return TCM_NO_SENSE;
+	}
+
+	put_unaligned_be32(16, &param_data[4]);
+
+	if (cmd->data_length < 16)
+		return TCM_NO_SENSE;
+	put_unaligned_be64(rsv.key, &param_data[8]);
+
+	if (cmd->data_length < 22)
+		return TCM_NO_SENSE;
+	param_data[21] = block_pr_type_to_scsi(rsv.type);
+
+	return TCM_NO_SENSE;
+}
+
+static sense_reason_t iblock_execute_pr_in(struct se_cmd *cmd, u8 sa,
+					   unsigned char *param_data)
+{
+	sense_reason_t ret = TCM_NO_SENSE;
+
+	switch (sa) {
+	case PRI_REPORT_CAPABILITIES:
+		iblock_pr_report_caps(param_data);
+		break;
+	case PRI_READ_KEYS:
+		ret = iblock_pr_read_keys(cmd, param_data);
+		break;
+	case PRI_READ_RESERVATION:
+		ret = iblock_pr_read_reservation(cmd, param_data);
+		break;
+	case PRI_READ_FULL_STATUS:
+	default:
+		pr_err("Unknown PERSISTENT_RESERVE_IN SA: 0x%02x\n", sa);
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	return ret;
+}
+
 static sector_t iblock_get_blocks(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -883,6 +1162,8 @@ static struct exec_cmd_ops iblock_exec_cmd_ops = {
 	.execute_sync_cache	= iblock_execute_sync_cache,
 	.execute_write_same	= iblock_execute_write_same,
 	.execute_unmap		= iblock_execute_unmap,
+	.execute_pr_out		= iblock_execute_pr_out,
+	.execute_pr_in		= iblock_execute_pr_in,
 };
 
 static sense_reason_t
@@ -899,6 +1180,7 @@ static bool iblock_get_write_cache(struct se_device *dev)
 static const struct target_backend_ops iblock_ops = {
 	.name			= "iblock",
 	.inquiry_prod		= "IBLOCK",
+	.transport_flags_changeable = TRANSPORT_FLAG_PASSTHROUGH_PGR,
 	.inquiry_rev		= IBLOCK_VERSION,
 	.owner			= THIS_MODULE,
 	.attach_hba		= iblock_attach_hba,
-- 
2.18.2

