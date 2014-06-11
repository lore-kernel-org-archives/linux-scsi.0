From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v2 3/3] TARGET/sbc,loopback: Adjust command data length in case pi exists on the wire
Date: Wed, 11 Jun 2014 12:09:59 +0300
Message-ID: <1402477799-24610-4-git-send-email-sagig@mellanox.com>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: michaelc@cs.wisc.edu, martin.petersen@oracle.com, nab@linux-iscsi.org, roland@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In various areas of the code, it is assumed that
se_cmd->data_length describes pure data. In case
that protection information exists over the wire
(protect bits is are on) the target core re-calculates
the data length from the CDB and the backed device
block size (instead of each transport peeking in the cdb).

Modify loopback device to include protection information
in the transferred data length (like other scsi transports).

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/loopback/tcm_loop.c |   15 ++++++++++++---
 drivers/target/target_core_sbc.c   |   15 +++++++++++++--
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index c886ad1..1f4c015 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -179,7 +179,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
 	struct scatterlist *sgl_bidi = NULL;
-	u32 sgl_bidi_count = 0;
+	u32 sgl_bidi_count = 0, transfer_length;
 	int rc;
 
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
@@ -213,12 +213,21 @@ static void tcm_loop_submission_work(struct work_struct *work)
 
 	}
 
-	if (!scsi_prot_sg_count(sc) && scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
+	transfer_length = scsi_transfer_length(sc);
+	if (!scsi_prot_sg_count(sc) &&
+	    scsi_get_prot_op(sc) != SCSI_PROT_NORMAL) {
 		se_cmd->prot_pto = true;
+		/*
+		 * loopback transport doesn't support
+		 * WRITE_GENERATE, READ_STRIP protection
+		 * information operations, go ahead unprotected.
+		 */
+		transfer_length = scsi_bufflen(sc);
+	}
 
 	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
 			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
-			scsi_bufflen(sc), tcm_loop_sam_attr(sc),
+			transfer_length, tcm_loop_sam_attr(sc),
 			sc->sc_data_direction, 0,
 			scsi_sglist(sc), scsi_sg_count(sc),
 			sgl_bidi, sgl_bidi_count,
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index e022959..4b5716f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -665,8 +665,19 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 
 	cmd->prot_type = dev->dev_attrib.pi_prot_type;
 	cmd->prot_length = dev->prot_length * sectors;
-	pr_debug("%s: prot_type=%d, prot_length=%d prot_op=%d prot_checks=%d\n",
-		 __func__, cmd->prot_type, cmd->prot_length,
+
+	/**
+	 * In case protection information exists over the wire
+	 * we modify command data length to describe pure data.
+	 * The actual transfer length is data length + protection
+	 * length
+	 **/
+	if (protect)
+		cmd->data_length = sectors * dev->dev_attrib.block_size;
+
+	pr_debug("%s: prot_type=%d, data_length=%d, prot_length=%d "
+		 "prot_op=%d prot_checks=%d\n",
+		 __func__, cmd->prot_type, cmd->data_length, cmd->prot_length,
 		 cmd->prot_op, cmd->prot_checks);
 
 	return true;
-- 
1.7.1
