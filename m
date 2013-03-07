From: vikas.chaudhary@qlogic.com
Subject: [PATCH 5/8] qla4xxx: Pass correct LUN address to firmware in case of lun_reset
Date: Thu,  7 Mar 2013 05:43:11 -0500
Message-ID: <1362652994-7593-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:15729 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756001Ab3CGLFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Mar 2013 06:05:22 -0500
In-Reply-To: <1362652994-7593-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Use function int_to_scsilun() in qla4xxx_reset_lun() to convert
integer value comming from scsi_transport to scsi LUN address format.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 160d336..446511d 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -1129,6 +1129,7 @@ int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
 {
 	uint32_t mbox_cmd[MBOX_REG_COUNT];
 	uint32_t mbox_sts[MBOX_REG_COUNT];
+	uint32_t scsi_lun[2];
 	int status = QLA_SUCCESS;
 
 	DEBUG2(printk("scsi%ld:%d:%d: lun reset issued\n", ha->host_no,
@@ -1140,10 +1141,16 @@ int qla4xxx_reset_lun(struct scsi_qla_host * ha, struct ddb_entry * ddb_entry,
 	 */
 	memset(&mbox_cmd, 0, sizeof(mbox_cmd));
 	memset(&mbox_sts, 0, sizeof(mbox_sts));
+	int_to_scsilun(lun, (struct scsi_lun *) scsi_lun);
 
 	mbox_cmd[0] = MBOX_CMD_LUN_RESET;
 	mbox_cmd[1] = ddb_entry->fw_ddb_index;
-	mbox_cmd[2] = lun << 8;
+	/* FW expects LUN bytes 0-3 in Incoming Mailbox 2
+	 * (LUN byte 0 is LSByte, byte 3 is MSByte) */
+	mbox_cmd[2] = cpu_to_le32(scsi_lun[0]);
+	/* FW expects LUN bytes 4-7 in Incoming Mailbox 3
+	 * (LUN byte 4 is LSByte, byte 7 is MSByte) */
+	mbox_cmd[3] = cpu_to_le32(scsi_lun[1]);
 	mbox_cmd[5] = 0x01;	/* Immediate Command Enable */
 
 	qla4xxx_mailbox_command(ha, MBOX_REG_COUNT, 1, &mbox_cmd[0], &mbox_sts[0]);
-- 
1.8.0

