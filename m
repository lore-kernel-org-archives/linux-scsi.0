From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] target: add support for START_STOP_UNIT SCSI opcode
Date: Tue, 21 Jul 2015 15:07:53 -0700
Message-ID: <1437516477-30554-1-git-send-email-sbaugh@catern.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Brian Bunker <brian@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Brian Bunker <brian@purestorage.com>

AIX servers using VIOS servers that virtualize FC cards will have a
problem booting without support for START_STOP_UNIT.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/target/target_core_sbc.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index e318ddb..996e584 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -154,6 +154,35 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 	return 0;
 }
 
+static sense_reason_t
+sbc_emulate_startstop(struct se_cmd *cmd)
+{
+	unsigned char *cdb = cmd->t_task_cdb;
+
+	/* From SBC-3:
+	 * Immediate bit should be set since there is nothing to complete
+	 * POWER CONDITION MODIFIER 0h
+	 */
+	if (!(cdb[1] & 1) || (cdb[2] | cdb[3]))
+		return TCM_INVALID_CDB_FIELD;
+
+	/* From SBC-3:
+	 * POWER CONDITION 0h START_VALID - process START and LOEJ
+	 */
+	if (cdb[4] >> 4 & 0xf)
+		return TCM_INVALID_CDB_FIELD;
+
+	/* From SBC-3:
+	 * LOEJ 0h - nothing to load or unload
+	 * START 1h - we are ready
+	 */
+	if (!(cdb[4] & 1) || ((cdb[4] & 2) | (cdb[4] & 4)))
+		return TCM_INVALID_CDB_FIELD;
+
+	target_complete_cmd(cmd, SAM_STAT_GOOD);
+	return 0;
+}
+
 sector_t sbc_get_write_same_sectors(struct se_cmd *cmd)
 {
 	u32 num_blocks;
@@ -1069,6 +1098,10 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		size = 0;
 		cmd->execute_cmd = sbc_emulate_noop;
 		break;
+	case START_STOP:
+		size = 0;
+		cmd->execute_cmd = sbc_emulate_startstop;
+		break;
 	default:
 		ret = spc_parse_cdb(cmd, &size);
 		if (ret)
-- 
2.4.3
