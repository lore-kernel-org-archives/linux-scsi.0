From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] target: Add TARGET_SCF_MAP_CLEAR_MEM work-around for tcm_loop
Date: Tue,  2 Oct 2012 07:15:46 +0000
Message-ID: <1349162147-29098-4-git-send-email-nab@linux-iscsi.org>
References: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1349162147-29098-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch carries forward a work-around from tcm_loop to target
core code to explicitly clear control CDB READ paylods in order to
avoid bugs in scsi-generic user-space code for INQUIRY that do not
explicitly zero CDB payload memory.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c     |    2 +-
 drivers/target/target_core_transport.c |   21 +++++++++++++++++++++
 include/target/target_core_base.h      |    1 +
 3 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index e20b809..911381f 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -198,7 +198,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	rc = target_submit_cmd_map_mem(se_cmd, tl_nexus->se_sess, sc->cmnd,
 			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
 			scsi_bufflen(sc), tcm_loop_sam_attr(sc),
-			sc->sc_data_direction, 0,
+			sc->sc_data_direction, TARGET_SCF_MAP_CLEAR_MEM,
 			scsi_sglist(sc), scsi_sg_count(sc),
 			sgl_bidi, sgl_bidi_count);
 	if (rc < 0) {
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ad2097e..665ace5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1512,6 +1512,27 @@ static int __target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess
 	 * core perform an internal SGL allocation.
 	 */
 	if (flags & TARGET_SCF_MAP_MEM) {
+		/*
+		 * A work-around for tcm_loop as some userspace code via
+		 * scsi-generic do not memset their associated read buffers,
+		 * so go ahead and do that here for type non-data CDBs.  Also
+		 * note that this is currently guaranteed to be a single SGL
+		 * for this case by target core in target_setup_cmd_from_cdb()
+		 * -> transport_generic_cmd_sequencer().
+		 */
+		if (flags & TARGET_SCF_MAP_CLEAR_MEM &&
+		   !(se_cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
+		    se_cmd->data_direction == DMA_FROM_DEVICE) {
+			unsigned char *buf = NULL;
+
+			if (sgl)
+				buf = kmap(sg_page(sgl)) + sgl->offset;
+
+			if (buf) {
+				memset(buf, 0, sgl->length);
+				kunmap(sg_page(sgl));
+			}
+		}
 		rc = transport_generic_map_mem_to_cmd(se_cmd, sgl, sgl_count,
 				sgl_bidi, sgl_bidi_count);
 		if (rc != 0) {
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6309298..f660ad2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -221,6 +221,7 @@ enum target_sc_flags_table {
 	TARGET_SCF_ACK_KREF		= 0x02,
 	TARGET_SCF_UNKNOWN_SIZE		= 0x04,
 	TARGET_SCF_MAP_MEM		= 0x08,
+	TARGET_SCF_MAP_CLEAR_MEM	= 0x10,
 };
 
 /* fabric independent task management function values */
-- 
1.7.2.5
