From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 2/4] tcm_loop: Convert I/O path to use target_submit_cmd_map_sgls
Date: Tue,  2 Oct 2012 21:16:56 +0000
Message-ID: <1349212618-348-3-git-send-email-nab@linux-iscsi.org>
References: <1349212618-348-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38189 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab2JBVWU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2012 17:22:20 -0400
In-Reply-To: <1349212618-348-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts tcm_loop to use target_submit_cmd_map_sgls() for
I/O submission and mapping of pre-allocated SGL memory from incoming
scsi_cmnd -> se_cmd descriptors.

This includes removing the original open-coded fabric uses of target
core callers to support transport_generic_map_mem_to_cmd() between
target_setup_cmd_from_cdb() and transport_handle_cdb_direct() logic.

(v2: Use renamed target_submit_cmd_map_sgls)

Reported-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c |   62 +++++-------------------------------
 include/target/target_core_base.h  |    1 -
 2 files changed, 8 insertions(+), 55 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 7a0da1a..2d444b1 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -166,7 +166,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	struct tcm_loop_tpg *tl_tpg;
 	struct scatterlist *sgl_bidi = NULL;
 	u32 sgl_bidi_count = 0;
-	int ret;
+	int rc;
 
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
@@ -187,12 +187,6 @@ static void tcm_loop_submission_work(struct work_struct *work)
 		set_host_byte(sc, DID_ERROR);
 		goto out_done;
 	}
-
-	transport_init_se_cmd(se_cmd, tl_tpg->tl_se_tpg.se_tpg_tfo,
-			tl_nexus->se_sess,
-			scsi_bufflen(sc), sc->sc_data_direction,
-			tcm_loop_sam_attr(sc), &tl_cmd->tl_sense_buf[0]);
-
 	if (scsi_bidi_cmnd(sc)) {
 		struct scsi_data_buffer *sdb = scsi_in(sc);
 
@@ -201,56 +195,16 @@ static void tcm_loop_submission_work(struct work_struct *work)
 		se_cmd->se_cmd_flags |= SCF_BIDI;
 
 	}
-
-	if (transport_lookup_cmd_lun(se_cmd, tl_cmd->sc->device->lun) < 0) {
-		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
+			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
+			scsi_bufflen(sc), tcm_loop_sam_attr(sc),
+			sc->sc_data_direction, 0,
+			scsi_sglist(sc), scsi_sg_count(sc),
+			sgl_bidi, sgl_bidi_count);
+	if (rc < 0) {
 		set_host_byte(sc, DID_NO_CONNECT);
 		goto out_done;
 	}
-
-	/*
-	 * Because some userspace code via scsi-generic do not memset their
-	 * associated read buffers, go ahead and do that here for type
-	 * non-data CDBs.  Also note that this is currently guaranteed to be a
-	 * single SGL for this case by target core in
-	 * target_setup_cmd_from_cdb() -> transport_generic_cmd_sequencer().
-	 */
-	if (!(se_cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
-	    se_cmd->data_direction == DMA_FROM_DEVICE) {
-		struct scatterlist *sg = scsi_sglist(sc);
-		unsigned char *buf = kmap(sg_page(sg)) + sg->offset;
-
-		if (buf != NULL) {
-			memset(buf, 0, sg->length);
-			kunmap(sg_page(sg));
-		}
-	}
-
-	ret = target_setup_cmd_from_cdb(se_cmd, sc->cmnd);
-	if (ret == -ENOMEM) {
-		transport_send_check_condition_and_sense(se_cmd,
-				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
-		transport_generic_free_cmd(se_cmd, 0);
-		return;
-	} else if (ret < 0) {
-		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
-			tcm_loop_queue_status(se_cmd);
-		else
-			transport_send_check_condition_and_sense(se_cmd,
-					se_cmd->scsi_sense_reason, 0);
-		transport_generic_free_cmd(se_cmd, 0);
-		return;
-	}
-
-	ret = transport_generic_map_mem_to_cmd(se_cmd, scsi_sglist(sc),
-			scsi_sg_count(sc), sgl_bidi, sgl_bidi_count);
-	if (ret) {
-		transport_send_check_condition_and_sense(se_cmd,
-					se_cmd->scsi_sense_reason, 0);
-		transport_generic_free_cmd(se_cmd, 0);
-		return;
-	}
-	transport_handle_cdb_direct(se_cmd);
 	return;
 
 out_done:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6309298..5be8937 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -220,7 +220,6 @@ enum target_sc_flags_table {
 	TARGET_SCF_BIDI_OP		= 0x01,
 	TARGET_SCF_ACK_KREF		= 0x02,
 	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
-	TARGET_SCF_MAP_MEM		= 0x08,
 };
 
 /* fabric independent task management function values */
-- 
1.7.2.5

