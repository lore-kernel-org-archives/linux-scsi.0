From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 2/4] scsi: Protect against buffer possible overflow in scsi_set_sense_information
Date: Wed, 15 Jul 2015 10:55:37 +0300
Message-ID: <1436946939-19415-3-git-send-email-sagig@mellanox.com>
References: <1436946939-19415-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436946939-19415-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Make sure that the input sense buffer has sufficient length
to fit the information descriptor (12 additional bytes).
Modify scsi_set_sense_information to receive the sense buffer
length and adjust its callers scsi target and libata.

Reported-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-scsi.c              |  4 +++-
 drivers/scsi/scsi_common.c             | 13 ++++++++++++-
 drivers/target/target_core_transport.c | 14 +++++++++++---
 include/scsi/scsi_common.h             |  2 +-
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3131adc..2fb7c79 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -289,7 +289,9 @@ void ata_scsi_set_sense_information(struct scsi_cmnd *cmd,
 		return;
 
 	information = ata_tf_read_block(tf, NULL);
-	scsi_set_sense_information(cmd->sense_buffer, information);
+	scsi_set_sense_information(cmd->sense_buffer,
+				   SCSI_SENSE_BUFFERSIZE,
+				   information);
 }
 
 static ssize_t
diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index fbf137b..2b27e64 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -5,6 +5,7 @@
 #include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/errno.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi_common.h>
 
@@ -249,10 +250,13 @@ EXPORT_SYMBOL(scsi_build_sense_buffer);
  * scsi_set_sense_information - set the information field in a
  *		formatted sense data buffer
  * @buf:	Where to build sense data
+ * @buf_len:    buffer length
  * @info:	64-bit information value to be set
  *
+ * Return value:
+ *	0 on success or EINVAL for invalid sense buffer length
  **/
-void scsi_set_sense_information(u8 *buf, u64 info)
+int scsi_set_sense_information(u8 *buf, int buf_len, u64 info)
 {
 	if ((buf[0] & 0x7f) == 0x72) {
 		u8 *ucp, len;
@@ -263,6 +267,11 @@ void scsi_set_sense_information(u8 *buf, u64 info)
 			buf[7] = len + 0xc;
 			ucp = buf + 8 + len;
 		}
+
+		if (buf_len < len + 0xc)
+			/* Not enough room for info */
+			return -EINVAL;
+
 		ucp[0] = 0;
 		ucp[1] = 0xa;
 		ucp[2] = 0x80; /* Valid bit */
@@ -272,5 +281,7 @@ void scsi_set_sense_information(u8 *buf, u64 info)
 		buf[0] |= 0x80;
 		put_unaligned_be32(info, &buf[3]);
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL(scsi_set_sense_information);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2bece60..7fb031b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2729,7 +2729,7 @@ static const struct sense_info sense_info_table[] = {
 	},
 };
 
-static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
+static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 {
 	const struct sense_info *si;
 	u8 *buffer = cmd->sense_buffer;
@@ -2756,7 +2756,11 @@ static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 
 	scsi_build_sense_buffer(0, buffer, si->key, asc, ascq);
 	if (si->add_sector_info)
-		scsi_set_sense_information(buffer, cmd->bad_sector);
+		return scsi_set_sense_information(buffer,
+						  cmd->scsi_sense_length,
+						  cmd->bad_sector);
+
+	return 0;
 }
 
 int
@@ -2774,10 +2778,14 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	if (!from_transport) {
+		int rc;
+
 		cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
-		translate_sense_reason(cmd, reason);
 		cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
 		cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
+		rc = translate_sense_reason(cmd, reason);
+		if (rc)
+			return rc;
 	}
 
 	trace_target_cmd_complete(cmd);
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 156d673..11571b2 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -62,7 +62,7 @@ extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 				 struct scsi_sense_hdr *sshdr);
 
 extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
-extern void scsi_set_sense_information(u8 *buf, u64 info);
+int scsi_set_sense_information(u8 *buf, int buf_len, u64 info);
 extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
 				       int desc_type);
 
-- 
1.8.4.3
