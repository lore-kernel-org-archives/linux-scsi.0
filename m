From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] target: Fix zero-length MODE_SENSE regression
Date: Tue, 29 Jan 2013 22:26:14 +0000
Message-ID: <1359498375-8040-3-git-send-email-nab@linux-iscsi.org>
References: <1359498375-8040-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1359498375-8040-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Roland Dreier <roland@purestorage.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a regression introduced in v3.8-rc1 code where
a zero-length MODE_SENSE was no longer returning GOOD status, but
instead returning TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE to generate
a CHECK_CONDITION status.

This regression was introduced with the following commit:

  commit de103c93aff0bed0ae984274e5dc8b95899badab
  Author: Christoph Hellwig <hch@lst.de>
  Date:   Tue Nov 6 12:24:09 2012 -0800

      target: pass sense_reason as a return value

and this patch has been tested with the following zero-length CDB:

  sg_raw /dev/sdd 5a 00 0a 00 00 00 00 00 00 00
  SCSI Status: Good

  Sense Information:
  sense buffer empty

Cc: Christoph Hellwig <hch@lst.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_spc.c |   35 +++++++----------------------------
 1 files changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index f8857d4..2d88f08 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -850,7 +850,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	char *cdb = cmd->t_task_cdb;
-	unsigned char *buf, *map_buf;
+	unsigned char buf[SE_MODE_PAGE_BUF], *rbuf;
 	int type = dev->transport->get_device_type(dev);
 	int ten = (cmd->t_task_cdb[0] == MODE_SENSE_10);
 	bool dbd = !!(cdb[1] & 0x08);
@@ -862,26 +862,8 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	int ret;
 	int i;
 
-	map_buf = transport_kmap_data_sg(cmd);
-	if (!map_buf)
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-	/*
-	 * If SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is not set, then we
-	 * know we actually allocated a full page.  Otherwise, if the
-	 * data buffer is too small, allocate a temporary buffer so we
-	 * don't have to worry about overruns in all our INQUIRY
-	 * emulation handling.
-	 */
-	if (cmd->data_length < SE_MODE_PAGE_BUF &&
-	    (cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC)) {
-		buf = kzalloc(SE_MODE_PAGE_BUF, GFP_KERNEL);
-		if (!buf) {
-			transport_kunmap_data_sg(cmd);
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		}
-	} else {
-		buf = map_buf;
-	}
+	memset(buf, 0, SE_MODE_PAGE_BUF);
+
 	/*
 	 * Skip over MODE DATA LENGTH + MEDIUM TYPE fields to byte 3 for
 	 * MODE_SENSE_10 and byte 2 for MODE_SENSE (6).
@@ -933,8 +915,6 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	if (page == 0x3f) {
 		if (subpage != 0x00 && subpage != 0xff) {
 			pr_warn("MODE_SENSE: Invalid subpage code: 0x%02x\n", subpage);
-			kfree(buf);
-			transport_kunmap_data_sg(cmd);
 			return TCM_INVALID_CDB_FIELD;
 		}
 
@@ -971,7 +951,6 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 		pr_err("MODE SENSE: unimplemented page/subpage: 0x%02x/0x%02x\n",
 		       page, subpage);
 
-	transport_kunmap_data_sg(cmd);
 	return TCM_UNKNOWN_MODE_PAGE;
 
 set_length:
@@ -980,12 +959,12 @@ set_length:
 	else
 		buf[0] = length - 1;
 
-	if (buf != map_buf) {
-		memcpy(map_buf, buf, cmd->data_length);
-		kfree(buf);
+	rbuf = transport_kmap_data_sg(cmd);
+	if (rbuf) {
+		memcpy(rbuf, buf, min_t(u32, SE_MODE_PAGE_BUF, cmd->data_length));
+		transport_kunmap_data_sg(cmd);
 	}
 
-	transport_kunmap_data_sg(cmd);
 	target_complete_cmd(cmd, GOOD);
 	return 0;
 }
-- 
1.7.2.5
