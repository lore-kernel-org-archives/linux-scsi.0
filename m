Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD387C43334
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 06:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbiFCG4R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 02:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238986AbiFCG4I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 02:56:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5201B366B8;
        Thu,  2 Jun 2022 23:56:05 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2535egi5004301;
        Fri, 3 Jun 2022 06:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=7X21fut053PC0p8/DRwQtbVQ1rmDs30+KaynjepwAh8=;
 b=yrdJw7ISkbF8apc90EQOG6Zk3Dw1Tv6ozjqZYQPR47aEl/YP2bLukY5MkqeXsW0/yhSI
 zTVlZlaIQWW470gdBEgzNfJaQ2fp9E/AlmlT6MCg+Cclmv1P6TDIoQ/m1O25M3DyFgXe
 LvyNPp0W+sFkquRSQgd3QxY+gE3YWmfGf+UmkDT7XGlMTWp2V2O/g1atClw+WqNIt5h1
 33IP5EjaZljTU/IpoON0ifhGHfKznpawksyvfJ/vK/A/SXwLtC1q3UYpyRYFmeO6nH7H
 eNykkKi9rYmPhJdVEe59GwKgEO+DpNGg/hjANLG1cl5oR6dLnEyvwANxgs56WUyoD6jW wQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gf08e198r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:55:55 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 2536oJOK001834;
        Fri, 3 Jun 2022 06:55:55 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8hyxp2g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 06:55:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FC2raP+jC6mgcAk9XX4oSJpf+f3naYj8oWLN8kx/oRsc+4ErScP0Wq8lE5j6u6Rts5X86ITagJmiC25rfDwZLnGuGbukDamDvDyaJdY2t00FW0dvNGzI/DPb+zYQwkWFBNIbriNQ0plwkjJZJcSHqM2S0sMq4yw7DlZnP3XuEr6LjsMP1zB153z3dyPvZ6deqpn5yl//quVy/X2AyT6dfchCXoSWFoILpbebAU1B7+xAKP94RH39MUJyASsy7nNOGRsCa3uiLHJXEDhIy67Oiajp/PaevpZrx5iJaVybrtN8ZK2lBZERY3e/P04xwAGgokcG12yAMo9Yuyn+EjIrCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7X21fut053PC0p8/DRwQtbVQ1rmDs30+KaynjepwAh8=;
 b=THcUbhcivcswMuhmQydi4R9fP5xicrjoqf2mNj91JZpPJfy0x4zbs6/zdHp9Ip9FOaRZR/lo8FmrN2wFa/lX3ZUq/K50KTDTio0iUqEaWjYotiIYjJtGp+UBwo2YTYObgyxTFe3LIZZX030tvYqa91xdOnNW3qd/lLn8eIagiTnqXGqNcZFsk4oS3191NSjNK2u3zRmD4QSoVteQGHoGAoVuE38x8tsx3Yikf0S29wy9opcFB+H0/b72VpAAT0B2SplPdUX6A3OU6lIu/rLCDBKHy3AIfrJM3ZNPxrCqQ0k1iRvzTjjWrb/sibPhELiCKP7dctohcY1vGURKN4M/3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7X21fut053PC0p8/DRwQtbVQ1rmDs30+KaynjepwAh8=;
 b=nhqlHjgxlYiXbpFL6zUc0JpxCuO+wEr/Ofg6FJyWjcaI5ol8Ladx8HpLw1sbfhvj8+pcOiNF8YuG6Lz/oYSfTp5bVkgTD873EUv3x0g/yGXdz0g7ImuGLLUHC4Ub+LUIQxLd+v33rZ5ZwtDBs6A07zSdW5IGKItuBgMhIeUXvCo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BYAPR10MB2789.namprd10.prod.outlook.com (2603:10b6:a03:82::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.19; Fri, 3 Jun 2022 06:55:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 06:55:52 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 08/11] scsi: target: Add block PR support to iblock.
Date:   Fri,  3 Jun 2022 01:55:33 -0500
Message-Id: <20220603065536.5641-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
References: <20220603065536.5641-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR16CA0012.namprd16.prod.outlook.com
 (2603:10b6:3:c0::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 562c0e60-29d6-4949-b5d8-08da452e199f
X-MS-TrafficTypeDiagnostic: BYAPR10MB2789:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB27890E5A99C430B54125564EF1A19@BYAPR10MB2789.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wL3ybMrxn6e4NN776nsKhMa9Ll+GJWlMO49BjoJfkXqOZDuUjujg6rmXosjqWlIKuXt3fdOKYjZ9xigquW4Avm2OLB7yWGXyMsI8Iz0Mzxi8UR9wdZjzXSkx7bVGajPLNFOxp9W9rJoZFjy7Ahsi9CEkM02KvUV45S0Wl5MuNrbgC2ChMt0W0pdw+tVK3BPhkLMbONi8DtlJ2VHVrLCXHIDgNaYctkD7DFsc54tzmfAusK04x0IyrTMFnnr7iVgY6VDzkGkRNGUs7PduzWx/qC70BVPz0/JaHST1AMXOdPARSxFH17yPxkhifwdQvRlFOI1gsv7LfgSdYUXgRswVg9BnovJigecyBHk0tvEPYBaWT0r99Z6rIwXoR1Bt+isRVtzbPuCwtsG5tVlPSjTolVzVIDjMAkm00uAtP7FohnKI1PfpxnwWmMQGVHa7b5wJhGkeV/hbqmTegkOQJohlXLDudui8sdMUn3T+DJdlzf5gaiEa0bX2uYJxFMZSwS76LvFwYozEJeZEx628PKv+aEJ0UE7RBaCXPQfSycYPelbSQnI2PuRjArzlxZHBjRe7DjbCyr6ztLd3zh2B5Ju7pYDt5yINIXYt1xna7I3U5Nw1FvXVDa5nT8qCrNTYdfneVmQYv2Jq9v4NxBYiopBVlCabAaiLcRsZRLcP/wfa4XQZtwq2URWkHeSQkrHOEIvrr9x6CRhdvs92PJ0CEH3bzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(8676002)(38350700002)(38100700002)(66476007)(4326008)(66556008)(86362001)(83380400001)(36756003)(8936002)(107886003)(6486002)(2616005)(316002)(5660300002)(1076003)(6512007)(26005)(2906002)(6506007)(52116002)(186003)(30864003)(6666004)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PhEbCTZIBl/sNqsOEH7fG1RIsrKnP0/n80gQxhNcatalRrU69ikAE9Zc01fz?=
 =?us-ascii?Q?quiALZ/9kQs5wGclxcVgfRIFQytmSbuyeqwnfN/x25PVJpr9g1f60Gr/WYYH?=
 =?us-ascii?Q?SfHjlQ8bfqkQiA7RUiF822IEEsDVTkMgEpQ/oN1ixBbt78i2R/qJWJT+SyQd?=
 =?us-ascii?Q?fMXRd6z9PYSuzXSiv0j7L5iuZNtEGoAG82oOynVHd3xDaJLQYeVYNlaVNYdU?=
 =?us-ascii?Q?wZCNAH3NV5wlYleO9sveD9VfsHYwsLSBDbdCJTcOc7u7BrsEGv4ZoiuevOmb?=
 =?us-ascii?Q?Q6cykXqYz2n74Z+Ppqm0ZeNAQLno6U7alblPeyjO+MxpxnYl3g3RboxTRYgf?=
 =?us-ascii?Q?Z2nRy8PPjk8142uzSvrohWyloOUrm0ea7ZSN4w2w+zXDn/D38LJL4+DfcZ6g?=
 =?us-ascii?Q?v3ucYf7XYNK+8LIg+1sVoUhOZkIi0gwkpdIpBg/EPk1IORXqGZ+X9pcVUmu8?=
 =?us-ascii?Q?BXLaW9eSiOo2ov6WDWzrRZGd8fPUklRSuQmYCVsNTBdg0+0+vQLbMbT4HulG?=
 =?us-ascii?Q?WuPlXa9oiWr4Jn3wlvdJWnVYa/faIZQBtGsoDnk6LoeRzEZI5nvPclUKyjxa?=
 =?us-ascii?Q?qhBM5/oNj9C0sXSeXXUmyVpXCyPa1dF7Axd6DmyQOL9yuFaZBNlt1HFPjZRF?=
 =?us-ascii?Q?W+gdoWlZX6bpyXEw2FzcH0PY4VKDjk7okXWTwsi/fQ06JIcPbONLJjLris4c?=
 =?us-ascii?Q?GK/+kJLcygJfy7JewsKdFErgJJg2RUXmz5bEuVIPv/jCk3zLFMb84DKjkdp8?=
 =?us-ascii?Q?PLTIbG3bcBrZKiWNpQQs/E3XqxFgHrH1K3ZNAm4lK1nm66KTzZ6VNu+zthnZ?=
 =?us-ascii?Q?1st0fkn9psQjQTK1yrcg7uzpdumMuytN07T/dsc2i6r3rJLCmSHqRjh3rb0i?=
 =?us-ascii?Q?WklKbbklTuWP2euIObm/MmjBxJB+wQSC2CBTq1irgI7nUgwFWK+4BoM62mn9?=
 =?us-ascii?Q?H/EH6zke71JLo97olAtOzcLFPfqleHXRhz154xWcSQydK674sqhQr+H7kkei?=
 =?us-ascii?Q?uS77hSAr8BYUszq39jBMIJl9XcekoDtfs1G6U5DQ20YTnNqzNaCTj9yZg9Ev?=
 =?us-ascii?Q?RExL78szz45cq5R2SfH4SacJ/7fLC1IHifgrav/jzZuHtGL1s84l2WMebfKJ?=
 =?us-ascii?Q?MPdjRsNmVQ96yrXeNh1owIq/kcbJEYOSp7wZgWnSOB798g25mbAl/ofZV4aj?=
 =?us-ascii?Q?0f78PWajX++hp3kyXC6rZU7E4jWJMXwGUtEp6ASe+tsuWJWsBQtLO1Wj8KPL?=
 =?us-ascii?Q?4ENQgtz5JLYeAcbNG74n49puNE9PYFN+EagtbY1zN+DxNn9YGULsb2eUSbEC?=
 =?us-ascii?Q?71H2OGYots417EIdhSHIw6BLQpI3O6Wr9kg8CqH4fZwPQ+O5+t3Eu9hOvjmS?=
 =?us-ascii?Q?F71SnG3dO1YnCZqBIcbXVijkPfFv2N1jTt2q5xrGJJUm5HnWXXGdZ2yv+rJp?=
 =?us-ascii?Q?Yq5UfFcVGoj6JNMJUKDCtSdgdcvTJqC6bVruX90/p+Lic/mlahas6Yldto+P?=
 =?us-ascii?Q?nWAjXjZScboyWq1zrTrJYp0qPMRQmP9Ma9/6XqSHq30FY4F8p9MtC+o62Le/?=
 =?us-ascii?Q?BupgyF15QLyRUvBra1kqnnDWpGVCXF9mWkPU/Xvns2n39+PQcuAix6nkE3Cb?=
 =?us-ascii?Q?57rVXevhL+rItefnZA5BGFQuWUdecimpdBrsO5DO1Yjt1u6MJZAMiW4q9dxR?=
 =?us-ascii?Q?XkyywGa3Ll4kH9jUmlpAzhU8SMLEOzZbMPtFd+A6aiC/jMF5kdvktQJdUac3?=
 =?us-ascii?Q?oCSv6z3U3ZtU1vKmHFNutgq0sGMqask=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 562c0e60-29d6-4949-b5d8-08da452e199f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 06:55:52.9243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pTr4fCgLboqe5H3hj5NuJfVrIfjziOOEL8QdvIUFN7YN0U0EvQMD7lRI2phUm4A3+2C8IGPRGO7KLVcdJuoZ02tDv9HbFEXB8XkSewmAGpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2789
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-03_02:2022-06-02,2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206030029
X-Proofpoint-GUID: AFyugBDX9QtpPaGUSZV9DeJ0-Le7wSSU
X-Proofpoint-ORIG-GUID: AFyugBDX9QtpPaGUSZV9DeJ0-Le7wSSU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds support for the block PR callouts to target_core_iblock. This
patch doesn't attempt to implement the entire spec because there's no way
to test it all. It only supports what's required for windows clustering
right now.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 312 ++++++++++++++++++++++++++++
 1 file changed, 312 insertions(+)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 9b0d788f6744..e8cf201e59ca 100644
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
@@ -822,6 +825,295 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
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
+				sa == PRO_REGISTER ? 0 : PR_FL_IGNORE_KEY);
+		break;
+	case PRO_RESERVE:
+		if (!ops->pr_reserve) {
+			pr_err("block_device does not support pr_reserve.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		switch (type) {
+		case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
+		case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY:
+			break;
+		default:
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_reserve(bdev, key, scsi_pr_type_to_block(type), 0);
+		break;
+	case PRO_CLEAR:
+		if (!ops->pr_clear) {
+			pr_err("block_device does not support pr_clear.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_clear(bdev, key);
+		break;
+	case PRO_PREEMPT:
+	case PRO_PREEMPT_AND_ABORT:
+		if (!ops->pr_clear) {
+			pr_err("block_device does not support pr_preempt.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		switch (type) {
+		case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
+		case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY:
+			break;
+		default:
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_preempt(bdev, key, sa_key,
+				      scsi_pr_type_to_block(type),
+				      sa == PRO_PREEMPT ? false : true);
+		break;
+	default:
+		pr_err("Unknown PERSISTENT_RESERVE_OUT SA: 0x%02x\n", sa);
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (ret)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	return TCM_NO_SENSE;
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
+	 *
+	 * We are only supporting the following to simplify conversions we
+	 * may need to do between what the initiator sends us and what is
+	 * below us if there is a multipath device.
+	 */
+	param_data[4] |= 0x40; /* PR_TYPE_EXCLUSIVE_ACCESS_REGONLY */
+	param_data[4] |= 0x20; /* PR_TYPE_WRITE_EXCLUSIVE_REGONLY */
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
+	len = sizeof(*keys) + (8 * paths);
+
+	keys = kzalloc(len, GFP_KERNEL);
+	if (!keys)
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	ret = ops->pr_read_keys(bdev, keys, len);
+	if (ret == -EOVERFLOW) {
+		kfree(keys);
+		paths *= 2;
+		goto retry;
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
+	/*
+	 * We only support a single I_T Nexus so there should only be one
+	 * key. There might be a multipath device under us but the initiator
+	 * does not know this. So, here we make sure the registered keys are
+	 * the same and that we only return the one key to match what the
+	 * initiator had sent us.
+	 */
+	put_unaligned_be32(8, &param_data[4]);
+
+	data_offset = 8;
+	for (i = 0; i < keys->num_keys; i++) {
+		if (data_offset + 8 > cmd->data_length)
+			break;
+
+		if (i == 0) {
+			put_unaligned_be64(keys->keys[i],
+					   &param_data[data_offset]);
+		} else if (keys->keys[i] != keys->keys[i - 1]) {
+			pr_err("Detected mismatched keys 0x%016llx and 0x%016llx\n",
+			       keys->keys[i], keys->keys[i - 1]);
+			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			goto free_keys;
+		}
+
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
+	if (ops->pr_read_reservation(bdev, &rsv))
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+
+	put_unaligned_be32(rsv.generation, &param_data[0]);
+	if (!rsv.key) {
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
+	sense_reason_t ret;
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
@@ -876,11 +1168,30 @@ static struct exec_cmd_ops iblock_exec_cmd_ops = {
 	.execute_sync_cache	= iblock_execute_sync_cache,
 	.execute_write_same	= iblock_execute_write_same,
 	.execute_unmap		= iblock_execute_unmap,
+	.execute_pr_out		= iblock_execute_pr_out,
+	.execute_pr_in		= iblock_execute_pr_in,
 };
 
 static sense_reason_t
 iblock_parse_cdb(struct se_cmd *cmd)
 {
+	unsigned char *cdb = cmd->t_task_cdb;
+	struct se_device *dev = cmd->se_dev;
+
+	switch (cdb[0]) {
+	case RESERVE:
+	case RESERVE_10:
+	case RELEASE:
+	case RELEASE_10:
+		/*
+		 * The block layer pr_ops don't support the old RESERVE/RELEASE
+		 * commands.
+		 */
+		if (dev->dev_attrib.emulate_pr &&
+		    (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	return sbc_parse_cdb(cmd, &iblock_exec_cmd_ops);
 }
 
@@ -896,6 +1207,7 @@ static bool iblock_get_write_cache(struct se_device *dev)
 static const struct target_backend_ops iblock_ops = {
 	.name			= "iblock",
 	.inquiry_prod		= "IBLOCK",
+	.transport_flags_changeable = TRANSPORT_FLAG_PASSTHROUGH_PGR,
 	.inquiry_rev		= IBLOCK_VERSION,
 	.owner			= THIS_MODULE,
 	.attach_hba		= iblock_attach_hba,
-- 
2.25.1

