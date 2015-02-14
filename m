From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/8] target: Add missing WRITE_SAME end-of-device sanity check
Date: Sat, 14 Feb 2015 03:27:36 +0000
Message-ID: <1423884463-16797-2-git-send-email-nab@daterainc.com>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a check to sbc_setup_write_same() to verify
the incoming WRITE_SAME LBA + number of blocks does not exceed
past the end-of-device.

Also check for potential LBA wrap-around as well.

Reported-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 11bea19..b26b52f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -251,6 +251,8 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
 static sense_reason_t
 sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *ops)
 {
+	struct se_device *dev = cmd->se_dev;
+	sector_t end_lba = dev->transport->get_blocks(dev) + 1;
 	unsigned int sectors = sbc_get_write_same_sectors(cmd);
 
 	if ((flags[0] & 0x04) || (flags[0] & 0x02)) {
@@ -264,6 +266,16 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 			sectors, cmd->se_dev->dev_attrib.max_write_same_len);
 		return TCM_INVALID_CDB_FIELD;
 	}
+	/*
+	 * Sanity check for LBA wrap and request past end of device.
+	 */
+	if (((cmd->t_task_lba + sectors) < cmd->t_task_lba) ||
+	    ((cmd->t_task_lba + sectors) > end_lba)) {
+		pr_err("WRITE_SAME exceeds last lba %llu (lba %llu, sectors %u)\n",
+		       (unsigned long long)end_lba, cmd->t_task_lba, sectors);
+		return TCM_ADDRESS_OUT_OF_RANGE;
+	}
+
 	/* We always have ANC_SUP == 0 so setting ANCHOR is always an error */
 	if (flags[0] & 0x10) {
 		pr_warn("WRITE SAME with ANCHOR not supported\n");
-- 
1.9.1
