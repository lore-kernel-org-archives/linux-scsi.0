From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 14/20] target: When using kunmap_first_data_page, use goto-style err handling
Date: Thu,  7 Jul 2011 15:33:25 -0700
Message-ID: <1310078011-15504-15-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab1GGWdr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2011 18:33:47 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

When there's an error and we've kmapped the first data page, don't put
kunmap in each error handler, but goto error handling at the end, and
kunmap there. Based on code review from hch.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_alua.c |   26 ++++++++++++++++----------
 drivers/target/target_core_cdb.c  |   28 +++++++++++++++-------------
 drivers/target/target_core_pr.c   |   11 +++++------
 3 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 99fac95..d7ed3fc 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -169,6 +169,9 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 
 	if (!(l_port))
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
+
+	buf = transport_kmap_first_data_page(cmd);
+
 	/*
 	 * Determine if explict ALUA via SET_TARGET_PORT_GROUPS is allowed
 	 * for the local tg_pt_gp.
@@ -176,14 +179,16 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 	l_tg_pt_gp_mem = l_port->sep_alua_tg_pt_gp_mem;
 	if (!(l_tg_pt_gp_mem)) {
 		pr_err("Unable to access l_port->sep_alua_tg_pt_gp_mem\n");
-		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+		rc = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+		goto out;
 	}
 	spin_lock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 	l_tg_pt_gp = l_tg_pt_gp_mem->tg_pt_gp;
 	if (!(l_tg_pt_gp)) {
 		spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
 		pr_err("Unable to access *l_tg_pt_gp_mem->tg_pt_gp\n");
-		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+		rc = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+		goto out;
 	}
 	rc = (l_tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_EXPLICT_ALUA);
 	spin_unlock(&l_tg_pt_gp_mem->tg_pt_gp_mem_lock);
@@ -191,10 +196,10 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 	if (!(rc)) {
 		pr_debug("Unable to process SET_TARGET_PORT_GROUPS"
 				" while TPGS_EXPLICT_ALUA is disabled\n");
-		return PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+		rc = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
+		goto out;
 	}
 
-	buf = transport_kmap_first_data_page(cmd);
 	ptr = &buf[4]; /* Skip over RESERVED area in header */
 
 	while (len < cmd->data_length) {
@@ -216,8 +221,8 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 * REQUEST, and the additional sense code set to INVALID
 			 * FIELD IN PARAMETER LIST.
 			 */
-			transport_kunmap_first_data_page(cmd);
-			return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			rc = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+			goto out;
 		}
 		rc = -1;
 		/*
@@ -269,8 +274,8 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 * throw an exception with ASCQ: INVALID_PARAMETER_LIST
 			 */
 			if (rc != 0) {
-				transport_kunmap_first_data_page(cmd);
-				return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+				rc = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+				goto out;
 			}
 		} else {
 			/*
@@ -306,8 +311,8 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 			 * INVALID_PARAMETER_LIST
 			 */
 			if (rc != 0) {
-				transport_kunmap_first_data_page(cmd);
-				return PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+				rc = PYX_TRANSPORT_INVALID_PARAMETER_LIST;
+				goto out;
 			}
 		}
 
@@ -315,6 +320,7 @@ int core_emulate_set_target_port_groups(struct se_cmd *cmd)
 		len += 4;
 	}
 
+out:
 	transport_kunmap_first_data_page(cmd);
 
 	return 0;
diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index f0779f1..6db1383 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -631,6 +631,7 @@ target_emulate_inquiry(struct se_cmd *cmd)
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *buf;
 	unsigned char *cdb = cmd->t_task_cdb;
+	int err = 0;
 
 	if (!(cdb[1] & 0x1))
 		return target_emulate_inquiry_std(cmd);
@@ -667,13 +668,12 @@ target_emulate_inquiry(struct se_cmd *cmd)
 		return target_emulate_evpd_b2(cmd, buf);
 	default:
 		pr_err("Unknown VPD Code: 0x%02x\n", cdb[2]);
-		transport_kunmap_first_data_page(cmd);
-		return -EINVAL;
+		err = -EINVAL;
 	}
 
 	transport_kunmap_first_data_page(cmd);
 
-	return 0;
+	return err;
 }
 
 static int
@@ -931,6 +931,7 @@ target_emulate_request_sense(struct se_cmd *cmd)
 	unsigned char *cdb = cmd->t_task_cdb;
 	unsigned char *buf;
 	u8 ua_asc = 0, ua_ascq = 0;
+	int err = 0;
 
 	if (cdb[1] & 0x01) {
 		pr_err("REQUEST_SENSE description emulation not"
@@ -952,8 +953,8 @@ target_emulate_request_sense(struct se_cmd *cmd)
 		 */
 		if (cmd->data_length <= 18) {
 			buf[7] = 0x00;
-			transport_kunmap_first_data_page(cmd);
-			return 0;
+			err = -EINVAL;
+			goto end;
 		}
 		/*
 		 * The Additional Sense Code (ASC) from the UNIT ATTENTION
@@ -973,8 +974,8 @@ target_emulate_request_sense(struct se_cmd *cmd)
 		 */
 		if (cmd->data_length <= 18) {
 			buf[7] = 0x00;
-			transport_kunmap_first_data_page(cmd);
-			return 0;
+			err = -EINVAL;
+			goto end;
 		}
 		/*
 		 * NO ADDITIONAL SENSE INFORMATION
@@ -983,6 +984,7 @@ target_emulate_request_sense(struct se_cmd *cmd)
 		buf[7] = 0x0A;
 	}
 
+end:
 	transport_kunmap_first_data_page(cmd);
 
 	return 0;
@@ -1001,7 +1003,7 @@ target_emulate_unmap(struct se_task *task)
 	unsigned char *cdb = &cmd->t_task_cdb[0];
 	sector_t lba;
 	unsigned int size = cmd->data_length, range;
-	int ret, offset;
+	int ret = 0, offset;
 	unsigned short dl, bd_dl;
 
 	/* First UNMAP block descriptor starts at 8 byte offset */
@@ -1026,19 +1028,19 @@ target_emulate_unmap(struct se_task *task)
 		if (ret < 0) {
 			pr_err("blkdev_issue_discard() failed: %d\n",
 					ret);
-			transport_kunmap_first_data_page(cmd);
-			return ret;
+			goto err;
 		}
 
 		ptr += 16;
 		size -= 16;
 	}
 
-	transport_kunmap_first_data_page(cmd);
-
 	task->task_scsi_status = GOOD;
 	transport_complete_task(task, 1);
-	return 0;
+err:
+	transport_kunmap_first_data_page(cmd);
+
+	return ret;
 }
 
 /*
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 42f26f8..b14851d 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -3939,11 +3939,9 @@ static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 		buf[6] = ((add_len >> 8) & 0xff);
 		buf[7] = (add_len & 0xff);
 
-		if (cmd->data_length < 22) {
-			spin_unlock(&se_dev->dev_reservation_lock);
-			transport_kunmap_first_data_page(cmd);
-			return 0;
-		}
+		if (cmd->data_length < 22)
+			goto err;
+
 		/*
 		 * Set the Reservation key.
 		 *
@@ -3980,8 +3978,9 @@ static int core_scsi3_pri_read_reservation(struct se_cmd *cmd)
 		buf[21] = (pr_reg->pr_res_scope & 0xf0) |
 			  (pr_reg->pr_res_type & 0x0f);
 	}
-	spin_unlock(&se_dev->dev_reservation_lock);
 
+err:
+	spin_unlock(&se_dev->dev_reservation_lock);
 	transport_kunmap_first_data_page(cmd);
 
 	return 0;
-- 
1.7.1

