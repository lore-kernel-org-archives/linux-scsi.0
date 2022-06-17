Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6492CCA47E
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 03:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379945AbiFQDE4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 23:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379582AbiFQDEx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 23:04:53 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5396622B;
        Thu, 16 Jun 2022 20:04:52 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25H0SUL0009843;
        Fri, 17 Jun 2022 03:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fxx25PYFNYfWuO28+FXL8z1NVFkW5iNbO/3p0+OEXd0=;
 b=miycjlwlG05O/+1g4eq1Vgd+2p1XTcb0jir7zWTc/eG34X87BTccgl5tDFevKh1I+KO8
 sIMEdFAyXO/AKlpXKVA49CyqgdbGu6H+aF5HVgjwP2eubE3nLuY/u35PeIP/LqEYD/Fk
 gVs+ZKhtMDRP2PxK8jjjVHiOhysl8BHe8/l/QltAUdgj3zSBR5ARxq8fJ5ood53QIQ2e
 5CdNXQ5DNZe69FcpDG+GgDYKX4+D1VQUd7Q3FhjwlY8SgAyBppYEI3nGQLh+zVKOz7ct
 gypGxBJtVgyyIZMDx+JrRREki1GaZQ4avMHJj5YCZ5evtKKSsXcnnp84a0ep0SRbpTGh JA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmkktmt5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 03:04:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25H2tlKA019489;
        Fri, 17 Jun 2022 03:04:50 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gpqwcq8hg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jun 2022 03:04:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuzKc283dIeCvsjQlK/64ixZsGfnL8ymre0nW+lFoDsYeuWvgMq/jTuxGxOBpKwcDJstx7f3i73HVKpCAyQfbf+94SAzyxA1U7gTbXswvF9I9YgJZqK6TVDYdsAcgKIOUk30DPcTdMpFQgfc7X/rFdMBYg56xTxWoaXW8+ebU9OyWC3QlcbgMCsTeuWq/viMGqb1l+ZuUk2lUzGhXxdJpnj/qhi7fuIl5OS5a7p9k1qYi9kmT8rLTcwNALo5ad7SqpJpRwoPHkSbOetTmB9Te2NgC6NQmiVJ4DgnJTxhj362zf8z6MMszEowOiBtSY/hjV9wVBTRTO65nzys1Aoc2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxx25PYFNYfWuO28+FXL8z1NVFkW5iNbO/3p0+OEXd0=;
 b=iL9z7T+KthAiHnN6c16M5LNylVdfFguk5S9CvRKCDmMlugcxD9sfII9WTN7YVpbHKiChBMWwIKu4qavGRwEOQ/wFaKDjLZE/qi5p7+kbqntj9DEEI5vD5ah9snuG38ThpI8dVr9EXe8bGiwAEkZWRLflcg1GDCJsSxX8jdEDXzB4u0HZFD0Pp1Z/smpqUQ/hrp5ieOFiLESbq6BHVabzxkTCXmeylWi71g49TrYcW3UzJE4v4tG30siksRo39TZpOmx51DFfcUi1UWAFLWwZTHzLJ4A9QTdBbXQA+L1oUjqWhp1WHk0ntK9bAJuKxA+xqGv3buE+R9s1H+xdxhFgBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxx25PYFNYfWuO28+FXL8z1NVFkW5iNbO/3p0+OEXd0=;
 b=Yecr6NZce9ZovFhYWsT53MJoCbQ3EcI2jTUCzQ1bGqhLAoAMTOo5hY8XzjYBKRNLOUoZXCNced5wYjE52nuxYhmfvEUjTV3syHEtXtjxKgOVQPyRplU3vp3LZvLA3B8izu9CMH33KeuYs1R4VuKfKToK1iIjFuA6GOm6QPs2V4k=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MWHPR10MB1280.namprd10.prod.outlook.com (2603:10b6:301:8::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.17; Fri, 17 Jun 2022 03:04:48 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Fri, 17 Jun 2022
 03:04:48 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/4] scsi: target: Fix WRITE_SAME NDOB handling in file
Date:   Thu, 16 Jun 2022 22:04:37 -0500
Message-Id: <20220617030440.116427-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220617030440.116427-1-michael.christie@oracle.com>
References: <20220617030440.116427-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR20CA0034.namprd20.prod.outlook.com
 (2603:10b6:3:13d::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 520d5d92-fdb2-4285-cd54-08da500e23c6
X-MS-TrafficTypeDiagnostic: MWHPR10MB1280:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1280F82249D606993EED50E5F1AF9@MWHPR10MB1280.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J31xQr7WYC3wP5K6ZAHpavvPPt4BDH6p6/Qi6Dqy8luYzqAf2gPfX5vRem5P1zU4ZFGbGhEe2qp98BDkQ1cjp7FyoevOBkmWQoluVCg1Tlz3Ucq/7nBBzElY6FpCNH29a1jWUTgXGg5JJINIt6G1QCtR6kBCJI3rZyH9SlN0E7Vyew3G/P8yyUTn15iDDIY6lGsbbTVBYRq1cKYqIMPwcwqsdCBt2DZ+KiExel03Ymm7Lora6LbTBbkPo6hjKE7sYEELgZi0ayiUQ2uXSwYznqqMBw/NkI9viOQD40RWYAMiksioazVAAk7TRYxo7ssb8lrftmqHUQuctuS3fHCHP7NfuB4O7E5smrfRbZtuVzE8hGI571s019Krl5gjtF9+Weq1doYtWi6bDmSjMGc5tRhljIMOyiZmmP7h1nOrGR2AEmSgKLEtYeCSvGOeLgbhzeMLDfRyOIDsl1uSjO4U7AkhR495C2OVY1Q5ihAhSlROdcHXzRJ8B5CPAr0vt8OD8GGc1VbYgSlXqwjQcnyKIKOf2D8+iE9ecocdN+hE5BOG3ffoMPv+7ZzCQPmG5FnqEVpKdvPuzfa2jVnSpoCIwSFzS8pygdhpbv9WIjfEnZoCxNp748Yg3gmmN9G2IcWzwkWKrC6b3tVbwTA8v54hThRhfSdu9J44H5NuYWGLtYxf08Q/duNd+oPx4NDlIzTbCP5J9gDj7Q91SKci6mseMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(8936002)(6666004)(6506007)(6486002)(6512007)(508600001)(186003)(26005)(66946007)(52116002)(38100700002)(2906002)(38350700002)(1076003)(86362001)(66556008)(36756003)(107886003)(8676002)(2616005)(4326008)(316002)(83380400001)(66476007)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YOKL/V7p72wAgFQdlg+wxeFfSLkUl/WQMC2dp8AhQZobrNiQ8/s56su3k91k?=
 =?us-ascii?Q?MZGCGugTbmO3E309N6z4skRNJGXh89IFCJXNHNM/LAD2inIJulDnjHv+aUWC?=
 =?us-ascii?Q?xlc6mWXw8er74ZBOBfqXA0Prb4f0r9geMmYB/CyG+CypLwWq41uKcCWOrgEg?=
 =?us-ascii?Q?2fb6hkX+op8uwR+vkxx1+uhT+FZZesl95gotL8cs1XLlwPm2jtmLEE3aWSDq?=
 =?us-ascii?Q?UojiTzgMv0DzBbSR7G4mAqV3GKAsDap0WJ5zcQnjwHYN04xLkmQq5tDuZN1r?=
 =?us-ascii?Q?4ez3Mzqtg8+dqmCDUBjulMjYPCZJ36mg2T2f7SzGUnebmTqIZPb0o9aLTRNB?=
 =?us-ascii?Q?igc6xcmfsghXTjg/5t7avhP2xhBKKrH3ylMiWJbyP3e9bjrsUVzLXqJx4dj6?=
 =?us-ascii?Q?ve1pjT4sqSO6CPJi43dfqW/D3xIOC/5twoL3L8arnaickqLKTBPEYHnyce40?=
 =?us-ascii?Q?9/dCx5cXrDzcoBGfJ0dAXiwyLV+BIeDmA8HFC14b7cByJstH9u7PTWSO5qO4?=
 =?us-ascii?Q?ZWqXgtBPbFTdTsxz8+tEgOl5ZLHuHYVHzByU9gQzLQA4Ad6JHLySgD298VpB?=
 =?us-ascii?Q?+JV4NWx8iPwrg7d0qI7Hz5pppi1ZnAq9jEo/KBLSXxD2nCsvytkGSpzgJJ9X?=
 =?us-ascii?Q?3gD5ZLvEUa/eWvCtphmZVCuExKgl1vGfu6Rq3yPI344zmJ3qAdzcjytAop7r?=
 =?us-ascii?Q?V31l+vOz123Ogx42x5HZ6R5rOEL+e2vuGq004U9+fDhj80VD5iw4CFzu9rZa?=
 =?us-ascii?Q?3kf0aQKAEfTaTNWTvExQnm3vmwdpoEfh3FSWTmvgE3aZP+hX7f6dO8BJTgXU?=
 =?us-ascii?Q?sDqkTVxnus9w5d+9zC8WKjsSIX7fJkILq0Tgv7Dw0T9dEnMqw9pgR8/e9Vt5?=
 =?us-ascii?Q?D+Qy5Q0h6DtQZSsjFbVmWYZykKUxW+XXbVl8q09CJr0+7XdvOAcS0t9eju/4?=
 =?us-ascii?Q?UdRXbbvEsIL4zLbIMBcyaJisrQSC4uN78XODvgzpPMyK+GVJ2mZyHVTVRr2w?=
 =?us-ascii?Q?2znqemjY/MKVmmiR2Sv3lA3BS3EgNXo02xORumNMZ+43ENgA1pg9kcvZMtJR?=
 =?us-ascii?Q?YM11xAJfoVsUjiz4zaLkd4WPWG8huiIDzIxWmWIQS1xiCK8zoG3cCG0R8EDu?=
 =?us-ascii?Q?DsZr8z8o/fqJFFeosIA5nsJBCsDnnUewFzo0mF0fV880IT1mYj19Ni5Qguc7?=
 =?us-ascii?Q?13heZXxxjFy/leDgOcyLHBEFJmGJiwTlaWwwmUN8EM7yE+o4YtkfKhX3uXEu?=
 =?us-ascii?Q?9ItzAK2JB3bpAmKRgIXpm6RJ4E9dQJOhcWycdKH++9ArWhWjr5U0fO50quK0?=
 =?us-ascii?Q?qRn40T56fzjQ7Rurr7vh4Av6NLdMHgPp0gDsBaNJHoYZtM6ddA9/G3AY0kE0?=
 =?us-ascii?Q?z+fCMCK3W888Sw9nqoWFSoKpntoL1iS466aIs58m0RLJsh+QYQujSEg135K6?=
 =?us-ascii?Q?B3bRUWRWDCPUIsp0v8IOSTSLQx1NzHwNHJzrSCgwqHfk/MwL7F3ZupJTbZ37?=
 =?us-ascii?Q?eBEC2+2pJlGho/aUPA4UlYY+bsuJIk12X7w03mlXGcjI5wgIP5a2kjD4yND+?=
 =?us-ascii?Q?rUEo4hr0GpIye7N4cz6ViUzys4uIXQe9QyHZvmrxtlq5Uv43o69iMiKkh2p8?=
 =?us-ascii?Q?9UjBsRGJK6MuafTGLeO1kXUbn8byejZ/qoBxPIe0YmE2yyp5VL7bt0ejz7Ko?=
 =?us-ascii?Q?J44FmXKfdfEJ6EVgIAwQERco6+7DOH+02DtdnTRmnAd2aJJIPQC2PoipHgqg?=
 =?us-ascii?Q?jecfIXL5/1XEHO5lEPzgskBSvNE1cgc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 520d5d92-fdb2-4285-cd54-08da500e23c6
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 03:04:48.7904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rNEC3u0o4SeAeiCZje3/VLGEsxR0pQq2ooU6CvDdJEXmTknxGJ1Odbno9Bzzl1p1Oou9KGEq6s8bsUTFdYxoxOU/fgKETcw/G4el9eMVJD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1280
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-17_02:2022-06-16,2022-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206170012
X-Proofpoint-GUID: M3moiWgjY6B5osBu-hWbNcDyCWn-p1Hy
X-Proofpoint-ORIG-GUID: M3moiWgjY6B5osBu-hWbNcDyCWn-p1Hy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If NDOB is set we don't have a buffer. We will then crash when trying to
access the t_data_sg. This has us allocate a page to use for the data
buffer that gets passed to vfs_iter_write.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_file.c | 32 +++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index e68f1cc8ef98..2011836ab7f4 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -433,6 +433,9 @@ fd_execute_write_same(struct se_cmd *cmd)
 	struct fd_dev *fd_dev = FD_DEV(se_dev);
 	loff_t pos = cmd->t_task_lba * se_dev->dev_attrib.block_size;
 	sector_t nolb = sbc_get_write_same_sectors(cmd);
+	bool ndob = cmd->t_task_cdb[1] & 0x01;
+	struct scatterlist *sg, ndob_sg;
+	struct page *pg = NULL;
 	struct iov_iter iter;
 	struct bio_vec *bvec;
 	unsigned int len = 0, i;
@@ -447,13 +450,13 @@ fd_execute_write_same(struct se_cmd *cmd)
 		       " backends not supported\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
+	sg = &cmd->t_data_sg[0];
 
 	if (cmd->t_data_nents > 1 ||
-	    cmd->t_data_sg[0].length != cmd->se_dev->dev_attrib.block_size) {
+	    (sg && sg->length != cmd->se_dev->dev_attrib.block_size)) {
 		pr_err("WRITE_SAME: Illegal SGL t_data_nents: %u length: %u"
 			" block_size: %u\n",
-			cmd->t_data_nents,
-			cmd->t_data_sg[0].length,
+			cmd->t_data_nents, sg->length,
 			cmd->se_dev->dev_attrib.block_size);
 		return TCM_INVALID_CDB_FIELD;
 	}
@@ -462,10 +465,23 @@ fd_execute_write_same(struct se_cmd *cmd)
 	if (!bvec)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
+	if (ndob) {
+		pg = alloc_page(GFP_KERNEL | __GFP_ZERO);
+		if (!pg) {
+			kfree(bvec);
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		}
+
+		sg_init_table(&ndob_sg, 1);
+		sg_set_page(&ndob_sg, pg, cmd->se_dev->dev_attrib.block_size,
+			    0);
+		sg = &ndob_sg;
+	}
+
 	for (i = 0; i < nolb; i++) {
-		bvec[i].bv_page = sg_page(&cmd->t_data_sg[0]);
-		bvec[i].bv_len = cmd->t_data_sg[0].length;
-		bvec[i].bv_offset = cmd->t_data_sg[0].offset;
+		bvec[i].bv_page = sg_page(sg);
+		bvec[i].bv_len = sg->length;
+		bvec[i].bv_offset = sg->offset;
 
 		len += se_dev->dev_attrib.block_size;
 	}
@@ -474,6 +490,10 @@ fd_execute_write_same(struct se_cmd *cmd)
 	ret = vfs_iter_write(fd_dev->fd_file, &iter, &pos, 0);
 
 	kfree(bvec);
+
+	if (pg)
+		__free_page(pg);
+
 	if (ret < 0 || ret != len) {
 		pr_err("vfs_iter_write() returned %zd for write same\n", ret);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-- 
2.25.1

