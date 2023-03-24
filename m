Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8034C77B61
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 18:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbjCXSVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjCXSUy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 14:20:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C972206A5;
        Fri, 24 Mar 2023 11:20:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OI51QY002327;
        Fri, 24 Mar 2023 18:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=pH8V4wiflSOMKMLJnT/e1rHbAZGDLooDfNE3dG/x9Ps=;
 b=tHsU3b16qWyCUwftq3Qhm5YrccHs7g2Oae9gLTYRdY5WWnWXRQswFrUm18GnK4FhtKaZ
 Elcs6tzlIdZBtmmi5idvntE4NWeprUaFvQaLc0QHy1D1eSMZxssWalGlBOzd5fi8YmIY
 eyTNMgo99XSZ3NH2a0NTuE8JuqV06jMuqSVWCYlm9hvf/hPWd7AGXOBWaAd0OarA7LJf
 Po6hmvulhlyvNlLK9fFQIDFVVPkjefjtkPl4iOs877VPBrxP8tm1VqKtw9e7+jPYjkeC
 CMQJWzVtQFn3R9hlx4k90GtPlqrQU8ZfmFEZlWBlFZInTB4lbgvSVKtlOgitiSegm9gP pg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phgtr80yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:18:29 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OGQaJB001369;
        Fri, 24 Mar 2023 18:18:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4bxt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:18:28 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OIHiEt021017;
        Fri, 24 Mar 2023 18:18:27 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-153-54.vpn.oracle.com [10.154.153.54])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pgxk4bx19-19;
        Fri, 24 Mar 2023 18:18:27 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 18/18] scsi: target: Add block PR support to iblock
Date:   Fri, 24 Mar 2023 13:17:41 -0500
Message-Id: <20230324181741.13908-19-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324181741.13908-1-michael.christie@oracle.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240143
X-Proofpoint-ORIG-GUID: 0FIOv20ZYQnF3L41RNiUE1nXKFLB85GQ
X-Proofpoint-GUID: 0FIOv20ZYQnF3L41RNiUE1nXKFLB85GQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds support for the block PR callouts to target_core_iblock. This
patch doesn't attempt to implement the entire spec because there's no way
support it all like SPEC_I_PT and ALL_TG_PT. This only supports
exporting the iblock device from one path on the local target.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_iblock.c | 269 +++++++++++++++++++++++++++-
 1 file changed, 264 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d93f24f9687d..9d60259b03fd 100644
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
@@ -310,7 +313,7 @@ static sector_t iblock_get_blocks(struct se_device *dev)
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
+	if (blk_status == BLK_STS_RESV_CONFLICT)
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
@@ -829,6 +835,256 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
 
+static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
+					    u64 sa_key, u8 type, bool aptpl)
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
+	case PRO_REGISTER:
+	case PRO_REGISTER_AND_IGNORE_EXISTING_KEY:
+		if (!ops->pr_register) {
+			pr_err("block device does not support pr_register.\n");
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
+		ret = ops->pr_preempt(bdev, key, sa_key,
+				      scsi_pr_type_to_block(type),
+				      sa == PRO_PREEMPT ? false : true);
+		break;
+	case PRO_RELEASE:
+		if (!ops->pr_clear) {
+			pr_err("block_device does not support pr_pclear.\n");
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+		}
+
+		ret = ops->pr_release(bdev, key, scsi_pr_type_to_block(type));
+		break;
+	default:
+		pr_err("Unknown PERSISTENT_RESERVE_OUT SA: 0x%02x\n", sa);
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	if (!ret)
+		return TCM_NO_SENSE;
+	else if (ret == PR_STS_RESERVATION_CONFLICT)
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
+	keys->num_keys = paths;
+	ret = ops->pr_read_keys(bdev, keys);
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
+	struct pr_held_reservation rsv = { };
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
+	default:
+		pr_err("Unknown PERSISTENT_RESERVE_IN SA: 0x%02x\n", sa);
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	return ret;
+}
+
 static sector_t iblock_get_alignment_offset_lbas(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -874,6 +1130,8 @@ static struct exec_cmd_ops iblock_exec_cmd_ops = {
 	.execute_sync_cache	= iblock_execute_sync_cache,
 	.execute_write_same	= iblock_execute_write_same,
 	.execute_unmap		= iblock_execute_unmap,
+	.execute_pr_out		= iblock_execute_pr_out,
+	.execute_pr_in		= iblock_execute_pr_in,
 };
 
 static sense_reason_t
@@ -890,6 +1148,7 @@ static bool iblock_get_write_cache(struct se_device *dev)
 static const struct target_backend_ops iblock_ops = {
 	.name			= "iblock",
 	.inquiry_prod		= "IBLOCK",
+	.transport_flags_changeable = TRANSPORT_FLAG_PASSTHROUGH_PGR,
 	.inquiry_rev		= IBLOCK_VERSION,
 	.owner			= THIS_MODULE,
 	.attach_hba		= iblock_attach_hba,
-- 
2.25.1

