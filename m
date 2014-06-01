From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 2/2] TARGET/sbc,loopback: Adjust command data length in case pi exists on the wire
Date: Sun,  1 Jun 2014 19:19:41 +0300
Message-ID: <1401639581-20111-3-git-send-email-sagig@mellanox.com>
References: <1401639581-20111-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:55696 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752532AbaFAQTu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Jun 2014 12:19:50 -0400
In-Reply-To: <1401639581-20111-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com

In various areas of the code, it is assumed that
se_cmd->data_length describes pure data. In case
that protection information exists over the wire
(protect bits is are on) the target core decrease
the protection length from the data length (instead
of each transport peeking in the cdb).

Modify loopback transport to include protection information
in the transferred data length (like other scsi transports).

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/target/loopback/tcm_loop.c |   35 +++++++++++++++++++++++++++++++----
 drivers/target/target_core_sbc.c   |   15 +++++++++++++--
 2 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index c886ad1..9adde8d 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -179,7 +179,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
 	struct scatterlist *sgl_bidi = NULL;
-	u32 sgl_bidi_count = 0;
+	u32 sgl_bidi_count = 0, data_len;
 	int rc;
 
 	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
@@ -213,12 +213,39 @@ static void tcm_loop_submission_work(struct work_struct *work)
 
 	}
 
-	if (!scsi_prot_sg_count(sc) && scsi_get_prot_op(sc) != SCSI_PROT_NORMAL)
-		se_cmd->prot_pto = true;
+	data_len = scsi_bufflen(sc);
+	if (scsi_get_prot_op(sc) != SCSI_PROT_NORMAL) {
+		if (!scsi_prot_sg_count(sc))
+			se_cmd->prot_pto = true;
+		else {
+			/**
+			 * Adjust data_length to include
+			 * protection information
+			 **/
+			switch (sc->device->sector_size) {
+			case 512:
+				data_len += (data_len >> 9) * 8;
+				break;
+			case 1024:
+				data_len += (data_len >> 10) * 8;
+				break;
+			case 2048:
+				data_len += (data_len >> 11) * 8;
+				break;
+			case 4096:
+				data_len += (data_len >> 12) * 8;
+				break;
+			default:
+				data_len +=
+				(data_len >> ilog2(sc->device->sector_size)) * 8;
+			}
+		}
+	}
+
 
 	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
 			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
-			scsi_bufflen(sc), tcm_loop_sam_attr(sc),
+			data_len, tcm_loop_sam_attr(sc),
 			sc->sc_data_direction, 0,
 			scsi_sglist(sc), scsi_sg_count(sc),
 			sgl_bidi, sgl_bidi_count,
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index e022959..06f8ecd 100644
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
+		cmd->data_length -= cmd->prot_length;
+
+	pr_debug("%s: prot_type=%d, data_length=%d, prot_length=%d "
+		 "prot_op=%d prot_checks=%d\n",
+		 __func__, cmd->prot_type, cmd->data_length, cmd->prot_length,
 		 cmd->prot_op, cmd->prot_checks);
 
 	return true;
-- 
1.7.1

