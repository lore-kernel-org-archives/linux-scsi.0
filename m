Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F897FA3748
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 23:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbiJZXZt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 19:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbiJZXYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 19:24:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B791B2673;
        Wed, 26 Oct 2022 16:22:39 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLHdMl020594;
        Wed, 26 Oct 2022 23:20:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=d5oQSur8BTrplxXSck4cG2lE6brWmJiDfbs3jfF9Wtw=;
 b=0EWlaaL5Jp/ofu15e80bpt7Va1is7h7+3+5JQAvMaL08CrJYMxl+5pd+dAc1qUOsS7Bx
 LpJiolCdqBvNPTCgRx4gqQ6To7N+vqlWaRFK6Z7abTRBNEuYNaFp8yxnN82NKNritPF8
 LlH+4b2g7O6119WqzQ3LcoMdX8XWVxQwHD0t6UoF1KwREHQYEkij/0HxmH+ApTyrv6Ir
 QSNAVFM2caNGCDoIWrgU6E35YTqxU4+c99s02251gC5qdlBpk49nMYCUjXXR4vgiEg//
 DfycRiGTrjkF6nknKEcteZiYx+xk+K3vpgcoXrETkuZ2nLSTRUYU2gHXp/JeFOFA+GhA HQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfahe8n90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLlN0D009406;
        Wed, 26 Oct 2022 23:20:19 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagedtmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:20:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8UjqX7jT2cRfu541s6eDGjPl0QeHMCqrRT48E8b8d/JuMkaW7pOOcOp0IsM8qbSaS60xs/rWw+K0GZjmwI6jE00p19MH0aU9ezzFCCLlK7Khex4ESYC4cOnc4mDFInK1deX0gVm8ZZxL3TeTX/uxfC1Uk1WmGaw43gfAVsVaU0zs350DcZVljyZ5WKNDmuittIwfDF9ThO8QuJDqbaIZ/sbzmeeUeyK0ooQgd7f6pels9LvDrEKT6viZQcA2xSZAcXB8xEosGimuxDpNQIgex5jxAeaLx8vNxJEBr7PhN8evkywNIP64e0hZDTtnIptCODcNfFAizVkNhwYaarohQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d5oQSur8BTrplxXSck4cG2lE6brWmJiDfbs3jfF9Wtw=;
 b=QhOZJGoqU7KOF2bZT0ZBn0EXaIhA3pJhEjHaardkta4wB51y5mf247d2p22BgTs6KLXWqMbmhgQ527kxKZb0PeI/gQtBBN7V97zkYwCxKe6MR69RKIY9ZTDeynxVdk3BWSQcUYAODou2oFRc9kefkMmx8Rgw4MxW/tF27f/XYyk7OUZa52fpSMBOcTLEG5PsthEfQ2Xlb42OnEFlX9CwBuYF2ay7nL/VQ/40bTxReOdNO3dJnIN8J0U7aNU4F/N8Yj8tjr0Scd+DnHZTlpWq5Joend3axk8V1Kaers4XlGHq1hr694fmN1gkk9tbpdU75r7OQ/VcJmEKZowg1ccmxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d5oQSur8BTrplxXSck4cG2lE6brWmJiDfbs3jfF9Wtw=;
 b=TVd/F4tEVuWaaXiG/exttnUpn9PY4VqSBFl6+hSjYv2G1jBw3731y1ruW0/YH6AnjlH0cyOKKJTMPlmZQ6c4bVZ2kBRJiI5FKCqS4bzg4rCZO64UXi9Mwvv5bA0nzUUdNj2MqJqjk4mudovmXnvMX50YBjkGuOwiv4bbhDCo3uo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MW5PR10MB5690.namprd10.prod.outlook.com (2603:10b6:303:19b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.27; Wed, 26 Oct 2022 23:20:17 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:20:16 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 19/19] scsi: target: Add block PR support to iblock
Date:   Wed, 26 Oct 2022 18:19:45 -0500
Message-Id: <20221026231945.6609-20-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026231945.6609-1-michael.christie@oracle.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR15CA0009.namprd15.prod.outlook.com
 (2603:10b6:610:51::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MW5PR10MB5690:EE_
X-MS-Office365-Filtering-Correlation-Id: e34ea19a-8fca-49d0-1712-08dab7a8a469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qkGJcZtDE4JBNNY1FkrQtYNQjwLNW2CRK5Z9fDhARYM9poQAha9Q0VijNKhInN7dfzTUxrdS5nWceS7VnU8HzS0wzKgX6soyru6qnfWHMu5oSl68efE6/Je7UoC3SYkCjjWlQ6u2dh3FQz26WySWeATetCEBRHecYgJfXMdilqIrm1lCeorSToIKgIBLboftAst1kRmqFsBf8qyaGxukpWnRswgb8ZeUH9C5KDUToIofHKtmAS5a6Ey/h7Zdbiwh98FTxWlnJ4PCxncybv3dCqyZbZwjDNZ1DiyifK2yJasusNFcHdkedsC3k5+ZdPDSrK34mRVr8j2Xg+hUT1bpt5Bw4Ril6+rtXAHPJCjYjTeoguX+4hkmClUPoQAIZeMxZHRMgNoocL5gunp6it4lePTp+4vLr1Zc1DABIJG13wSGDDG+u871C0/IaCFnk3zXSCn9FyB7weo8hwzXwm9CDKDzHRzG02xiYa9xOGR/fGj4tl4m0JBxt4HGCabU22GrJ/ED//xr/yVuNzIgphPzp+C+H26UoLgpF/kolR4OgurqTNoqNkt2zztG5fzgsyuP35dtPfdI9/gdIwVlA+VmQ017LMf0pdfVRTkcRwbH+FxGE79Y1KJuk5UEqcjQF6l06LD+qFIBTxLDsjkeyLevXnjdqzxqhqaGfOOasxShhxtOk3yTFaSXzat19cds8PzVha7QufITl/mi5pce+v8sBPnXIxB4QI38psPmT6Qd8NdDSUcy+oGlRwp9c4+vLsd9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(376002)(39860400002)(366004)(451199015)(316002)(186003)(8676002)(66946007)(2906002)(4326008)(66556008)(66476007)(86362001)(5660300002)(30864003)(38100700002)(41300700001)(8936002)(83380400001)(478600001)(1076003)(6666004)(6486002)(107886003)(2616005)(921005)(26005)(6512007)(6506007)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vo/exjY6+OGqIYjinZYO0uqTyXyHOTLFU+9EEJJQLCgGnAJPtuqjFgXTF/Bs?=
 =?us-ascii?Q?/3zKnaFjZQ0e+PYxJxj5QKuOzHHvvCud9g3uSgvFFAf9JpteULZhX1xRp/OR?=
 =?us-ascii?Q?uJ5jovfFUWjswImRMFNYu0maCBCziwPPk8xZShbmonmsXZYe0l6nML/6UlU5?=
 =?us-ascii?Q?Ag4w0oyNOyV6i76wiRaVI9YcakBSoP8w+wVXFFi1BTkn3INKjvypGBjf3llm?=
 =?us-ascii?Q?GnovHE915j6HX/1UcDcbAxmXMYiau2RRn4TdYrOjjC1uPU6YzFvtQQQB8RRJ?=
 =?us-ascii?Q?8yfQ+LLJ0xaSBnzSg5yYKcg/T/KnFJIXsXe2EfgYu1Rl8mJfSeM9SGlGexVm?=
 =?us-ascii?Q?zhsfdiMcVX81mzyAUx/9R+iRwtDVAPzU/P+433StNMUd3mvOPtXEz7Pb8P+0?=
 =?us-ascii?Q?ZfTX9glNNsvAzQRnecDpAiS83xCGwxLNJdYwFXMvNN89fg3RfgrLrF3adeTz?=
 =?us-ascii?Q?FktqC4c0dOHltKwrOxOR/BNBJA16YaSLAF9ZHx8y+NIcPRHihcEelKq70+JI?=
 =?us-ascii?Q?ItPQ6rmB49Ht6xW7+gDVsauLpKxn5SeSnKOYyUA4Rv5QeR3nDFF58zR9zdOJ?=
 =?us-ascii?Q?DS2BcmEbfbDr2WE6wPNYNtAs9wA5uwQmIPy803m/twQhuYCAhnJ+GpXmd8Tg?=
 =?us-ascii?Q?zjPJHJG8obshDEikQ35FwhYXOMVIOB+fCSO9HqkgEatEsuSx3luESlyqIloS?=
 =?us-ascii?Q?+8pOLE3fNDbKFB1x6RLP5Zoq+whpbb0OW180Fuyk7VVz+U8buRnK1An82f7O?=
 =?us-ascii?Q?AgmXVSFxxdQnGtT3Z8w3XoKiZNI2bZF/5NiM25FoAmgmFGod/GBIufrPjWD4?=
 =?us-ascii?Q?+a58TP8PKICGXQYbjWQQYTwP0UdTyPy8eXMT0T26AZGCg78rHsrI6B5c+N6O?=
 =?us-ascii?Q?4WU2iv9UOv2v0Om+6KySNPqscSwXsQWqJJ9OWFOi1RrZNd0H95dkVdCyc5x1?=
 =?us-ascii?Q?mnW0uav5G49iCbXDo2jAaiFckyZlyH/GBISXbUT6IMM9hPR7b593fRAQaWNR?=
 =?us-ascii?Q?RCSJOWrivBFk6rQpXR1TS8K1dz1tjtTzztcGLk77BBYlraYJGLum1vvjcwil?=
 =?us-ascii?Q?QCk3iGMJiq4fwxI844ZFHl8qBYm8WPolByX2gLU1lvWBVsIoNZlyBNCT2K4R?=
 =?us-ascii?Q?r847I2u2MP4+Yq+VjaIqLoTJynA8QOP3/WuM1zb+q4bR3r7CvME7tKIQEJl/?=
 =?us-ascii?Q?ER4t4X7TcieQyHQuq683xR+BKZtr0Ut91ZBj1LuYE59w5xteUzRRwk57nCat?=
 =?us-ascii?Q?E4N+6AWo4hRNlYHLu0kza4c3aX+7S0nuSNHlDejp2myeeqzEml/QnU+nyslI?=
 =?us-ascii?Q?/wZhOfhiFUc9e3PsVyEPuWwmI3dq95hD9/XnupQpjDi+bL3HP6HcSaM1jgAS?=
 =?us-ascii?Q?3H7wJ4lolw62/LSmlTL1xkmt8oQ0Cnv73fWICGNATyEfC7rwNgu5ptzLbgIG?=
 =?us-ascii?Q?MgFQe1KwOfTdvNV4h3e86QEIPGu4r3TRTMeZh36jpjqvCs/PJc+ftqWMDVNM?=
 =?us-ascii?Q?MzYsnyzG35BY0Nxtq7LItacdDzBGo33Ke/i7/d3L0I0KdCq8IeO2/K6Imuu5?=
 =?us-ascii?Q?lgKEWbg3IgQ8rVUjPiuFbM2ajaT0qZu/oUaY+sSZPLCTivUywtfiIbNtIxCm?=
 =?us-ascii?Q?rA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e34ea19a-8fca-49d0-1712-08dab7a8a469
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:20:16.8491
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YTx1TWKrtkQQ7+VcO9tDJl3b7jTjhW5uFiiJGPRzEiP7gAzP6vaWnuKAmJR1nwNW167hlbCuYCeo5Qck5vQS6ef8OXNpYsjaYMHSWy8wPd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5690
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210260128
X-Proofpoint-GUID: f_CcNQ__ZGYEq-zVXQlfD8VYhPQ3S5YX
X-Proofpoint-ORIG-GUID: f_CcNQ__ZGYEq-zVXQlfD8VYhPQ3S5YX
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
2.25.1

