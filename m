From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 4/6] esp_scsi: Eliminate ESP_FLAG_DOING_SLOWCMD
Date: Sat, 13 Oct 2018 11:51:16 +1100
Message-ID: <857b8aea38e0594969c873130f997ae0bb5e174a.1539391876.git.fthain@telegraphics.com.au>
References: <cover.1539391876.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1539391876.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The concept of a 'slow command' as it appears in esp_scsi is confusing
because it could refer to an ESP command or a SCSI command. It turns out
that it refers to a particular ESP select command which the driver also
tracks as 'ESP_SELECT_MSGOUT'. For readability, it is better to use the
terminology from the datasheets.

The global ESP_FLAG_DOING_SLOWCMD flag is redundant anyway, as it can be
inferred from esp->select_state. Remove the ESP_FLAG_DOING_SLOWCMD cruft
and just use a boolean local variable.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/esp_scsi.c | 57 ++++++++++++++++++++-----------------------------
 drivers/scsi/esp_scsi.h |  3 +--
 2 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index b7c41aa9927c..6ccaf818357e 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -478,17 +478,6 @@ static void esp_restore_pointers(struct esp *esp, struct esp_cmd_entry *ent)
 	spriv->tot_residue = ent->saved_tot_residue;
 }
 
-static void esp_check_command_len(struct esp *esp, struct scsi_cmnd *cmd)
-{
-	if (cmd->cmd_len == 6 ||
-	    cmd->cmd_len == 10 ||
-	    cmd->cmd_len == 12) {
-		esp->flags &= ~ESP_FLAG_DOING_SLOWCMD;
-	} else {
-		esp->flags |= ESP_FLAG_DOING_SLOWCMD;
-	}
-}
-
 static void esp_write_tgt_config3(struct esp *esp, int tgt)
 {
 	if (esp->rev > ESP100A) {
@@ -721,6 +710,7 @@ static void esp_maybe_execute_command(struct esp *esp)
 	struct scsi_device *dev;
 	struct scsi_cmnd *cmd;
 	struct esp_cmd_entry *ent;
+	bool select_and_stop = false;
 	int tgt, lun, i;
 	u32 val, start_cmd;
 	u8 *p;
@@ -752,7 +742,8 @@ static void esp_maybe_execute_command(struct esp *esp)
 	esp_map_dma(esp, cmd);
 	esp_save_pointers(esp, ent);
 
-	esp_check_command_len(esp, cmd);
+	if (!(cmd->cmd_len == 6 || cmd->cmd_len == 10 || cmd->cmd_len == 12))
+		select_and_stop = true;
 
 	p = esp->command_block;
 
@@ -793,9 +784,9 @@ static void esp_maybe_execute_command(struct esp *esp)
 			tp->flags &= ~ESP_TGT_CHECK_NEGO;
 		}
 
-		/* Process it like a slow command.  */
-		if (tp->flags & (ESP_TGT_NEGO_WIDE | ESP_TGT_NEGO_SYNC))
-			esp->flags |= ESP_FLAG_DOING_SLOWCMD;
+		/* If there are multiple message bytes, use Select and Stop */
+		if (esp->msg_out_len)
+			select_and_stop = true;
 	}
 
 build_identify:
@@ -808,23 +799,10 @@ static void esp_maybe_execute_command(struct esp *esp)
 		/* ESP100 lacks select w/atn3 command, use select
 		 * and stop instead.
 		 */
-		esp->flags |= ESP_FLAG_DOING_SLOWCMD;
+		select_and_stop = true;
 	}
 
-	if (!(esp->flags & ESP_FLAG_DOING_SLOWCMD)) {
-		start_cmd = ESP_CMD_SELA;
-		if (ent->tag[0]) {
-			*p++ = ent->tag[0];
-			*p++ = ent->tag[1];
-
-			start_cmd = ESP_CMD_SA3;
-		}
-
-		for (i = 0; i < cmd->cmd_len; i++)
-			*p++ = cmd->cmnd[i];
-
-		esp->select_state = ESP_SELECT_BASIC;
-	} else {
+	if (select_and_stop) {
 		esp->cmd_bytes_left = cmd->cmd_len;
 		esp->cmd_bytes_ptr = &cmd->cmnd[0];
 
@@ -839,6 +817,19 @@ static void esp_maybe_execute_command(struct esp *esp)
 
 		start_cmd = ESP_CMD_SELAS;
 		esp->select_state = ESP_SELECT_MSGOUT;
+	} else {
+		start_cmd = ESP_CMD_SELA;
+		if (ent->tag[0]) {
+			*p++ = ent->tag[0];
+			*p++ = ent->tag[1];
+
+			start_cmd = ESP_CMD_SA3;
+		}
+
+		for (i = 0; i < cmd->cmd_len; i++)
+			*p++ = cmd->cmnd[i];
+
+		esp->select_state = ESP_SELECT_BASIC;
 	}
 	val = tgt;
 	if (esp->rev == FASHME)
@@ -1248,7 +1239,6 @@ static int esp_finish_select(struct esp *esp)
 			esp_unmap_dma(esp, cmd);
 			esp_free_lun_tag(ent, cmd->device->hostdata);
 			tp->flags &= ~(ESP_TGT_NEGO_SYNC | ESP_TGT_NEGO_WIDE);
-			esp->flags &= ~ESP_FLAG_DOING_SLOWCMD;
 			esp->cmd_bytes_ptr = NULL;
 			esp->cmd_bytes_left = 0;
 		} else {
@@ -1299,9 +1289,8 @@ static int esp_finish_select(struct esp *esp)
 				esp_flush_fifo(esp);
 		}
 
-		/* If we are doing a slow command, negotiation, etc.
-		 * we'll do the right thing as we transition to the
-		 * next phase.
+		/* If we are doing a Select And Stop command, negotiation, etc.
+		 * we'll do the right thing as we transition to the next phase.
 		 */
 		esp_event(esp, ESP_EVENT_CHECK_PHASE);
 		return 0;
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index db4b6ea94caa..d0c032803749 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -490,7 +490,6 @@ struct esp {
 	u32			flags;
 #define ESP_FLAG_DIFFERENTIAL	0x00000001
 #define ESP_FLAG_RESETTING	0x00000002
-#define ESP_FLAG_DOING_SLOWCMD	0x00000004
 #define ESP_FLAG_WIDE_CAPABLE	0x00000008
 #define ESP_FLAG_QUICKIRQ_CHECK	0x00000010
 #define ESP_FLAG_DISABLE_SYNC	0x00000020
@@ -532,7 +531,7 @@ struct esp {
 	u32			min_period;
 	u32			radelay;
 
-	/* Slow command state.  */
+	/* ESP_CMD_SELAS command state */
 	u8			*cmd_bytes_ptr;
 	int			cmd_bytes_left;
 
-- 
2.16.4
