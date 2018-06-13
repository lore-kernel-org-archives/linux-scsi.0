From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v2 3/3] scsi: don't add scsi command result bytes
Date: Wed, 13 Jun 2018 09:53:49 +0200
Message-ID: <20180613075349.7509-4-jthumshirn@suse.de>
References: <20180613075349.7509-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613075349.7509-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Some drivers are ADDing the scsi command's result bytes instead of
ORing them.

While this can produce correct results it has unexpected side effects.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

---
Changes since v1:
- Fix kbuild robot warnings
---
 drivers/scsi/imm.c                  | 2 +-
 drivers/scsi/mesh.c                 | 4 ++--
 drivers/scsi/sym53c8xx_2/sym_glue.c | 2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.h | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 87c94191033b..c8b3de035630 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -892,7 +892,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 			/* Check for optional message byte */
 			if (imm_wait(dev) == (unsigned char) 0xb8)
 				imm_in(dev, &h, 1);
-			cmd->result = (DID_OK << 16) + (l & STATUS_MASK);
+			cmd->result = DID_OK << 16 | (l & STATUS_MASK);
 		}
 		if ((dev->mode == IMM_NIBBLE) || (dev->mode == IMM_PS2)) {
 			w_ctr(ppb, 0x4);
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 1753e42826dd..3473a860e690 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -594,9 +594,9 @@ static void mesh_done(struct mesh_state *ms, int start_next)
 	ms->current_req = NULL;
 	tp->current_req = NULL;
 	if (cmd) {
-		cmd->result = (ms->stat << 16) + cmd->SCp.Status;
+		cmd->result = ms->stat << 16 | cmd->SCp.Status;
 		if (ms->stat == DID_OK)
-			cmd->result += (cmd->SCp.Message << 8);
+			cmd->result |= cmd->SCp.Message << 8;
 		if (DEBUG_TARGET(cmd)) {
 			printk(KERN_DEBUG "mesh_done: result = %x, data_ptr=%d, buflen=%d\n",
 			       cmd->result, ms->data_ptr, scsi_bufflen(cmd));
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 7320d5fe4cbc..afdbd5a66083 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -252,7 +252,7 @@ void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid)
 		cam_status = sym_xerr_cam_status(DID_ERROR, cp->xerr_status);
 	}
 	scsi_set_resid(cmd, resid);
-	cmd->result = (drv_status << 24) + (cam_status << 16) + scsi_status;
+	cmd->result = drv_status << 24 | cam_status << 16 | scsi_status;
 }
 
 static int sym_scatter(struct sym_hcb *np, struct sym_ccb *cp, struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.h b/drivers/scsi/sym53c8xx_2/sym_glue.h
index 805369521df8..ec4af5e85142 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.h
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.h
@@ -256,7 +256,7 @@ sym_get_cam_status(struct scsi_cmnd *cmd)
 static inline void sym_set_cam_result_ok(struct sym_ccb *cp, struct scsi_cmnd *cmd, int resid)
 {
 	scsi_set_resid(cmd, resid);
-	cmd->result = (((DID_OK) << 16) + ((cp->ssss_status) & 0x7f));
+	cmd->result = DID_OK << 16 | (cp->ssss_status & 0x7f);
 }
 void sym_set_cam_result_error(struct sym_hcb *np, struct sym_ccb *cp, int resid);
 
-- 
2.16.4
