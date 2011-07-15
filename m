From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 06/16] SCSI: ibmmca: remove Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:20:00 -0400
Message-ID: <1310710800.3184.57.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Lang <langa2@kph.uni-mainz.de>
Cc: lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Change this for struct scsi_cmnd

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/ibmmca.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 67fc8ff..cb2e6d7 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -40,8 +40,8 @@
 
 /* Common forward declarations for all Linux-versions: */
 static int ibmmca_queuecommand (struct Scsi_Host *, struct scsi_cmnd *);
-static int ibmmca_abort (Scsi_Cmnd *);
-static int ibmmca_host_reset (Scsi_Cmnd *);
+static int ibmmca_abort (struct scsi_cmnd *);
+static int ibmmca_host_reset (struct scsi_cmnd *);
 static int ibmmca_biosparam (struct scsi_device *, struct block_device *, sector_t, int *);
 static int ibmmca_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start, off_t offset, int length, int inout);
 
@@ -315,7 +315,7 @@ struct logical_device {
 	struct im_tsb tsb;	/* SCSI command complete status block structure */
 	struct im_sge sge[16];	/* scatter gather list structure */
 	unsigned char buf[256];	/* SCSI command return data buffer */
-	Scsi_Cmnd *cmd;		/* SCSI-command that is currently in progress */
+	struct scsi_cmnd *cmd;	/* SCSI-command that is currently in progress */
 	int device_type;	/* type of the SCSI-device. See include/scsi/scsi.h
 				   for interpretation of the possible values */
 	int block_length;	/* blocksize of a particular logical SCSI-device */
@@ -476,7 +476,7 @@ static char ibm_ansi_order = 0;
 #endif
 
 static void issue_cmd(struct Scsi_Host *, unsigned long, unsigned char);
-static void internal_done(Scsi_Cmnd * cmd);
+static void internal_done(struct scsi_cmnd * cmd);
 static void check_devices(struct Scsi_Host *, int);
 static int immediate_assign(struct Scsi_Host *, unsigned int, unsigned int, unsigned int, unsigned int);
 static int immediate_feature(struct Scsi_Host *, unsigned int, unsigned int);
@@ -503,7 +503,7 @@ static irqreturn_t interrupt_handler(int irq, void *dev_id)
 	unsigned int cmd_result;
 	unsigned int ldn;
 	unsigned long flags;
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 	int lastSCSI;
 	struct device *dev = dev_id;
 	struct Scsi_Host *shpnt = dev_get_drvdata(dev);
@@ -726,7 +726,7 @@ static void issue_cmd(struct Scsi_Host *shpnt, unsigned long cmd_reg,
 	spin_unlock_irqrestore(shpnt->host_lock, flags);
 }
 
-static void internal_done(Scsi_Cmnd * cmd)
+static void internal_done(struct scsi_cmnd * cmd)
 {
 	cmd->SCp.Status++;
 	return;
@@ -1691,7 +1691,7 @@ static int __devexit ibmmca_remove(struct device *dev)
 }
 
 /* The following routine is the SCSI command queue for the midlevel driver */
-static int ibmmca_queuecommand_lck(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
+static int ibmmca_queuecommand_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 {
 	unsigned int ldn;
 	unsigned int scsi_cmd;
@@ -1998,7 +1998,7 @@ static int ibmmca_queuecommand_lck(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 
 static DEF_SCSI_QCMD(ibmmca_queuecommand)
 
-static int __ibmmca_abort(Scsi_Cmnd * cmd)
+static int __ibmmca_abort(struct scsi_cmnd * cmd)
 {
 	/* Abort does not work, as the adapter never generates an interrupt on
 	 * whatever situation is simulated, even when really pending commands
@@ -2006,7 +2006,7 @@ static int __ibmmca_abort(Scsi_Cmnd * cmd)
 
 	struct Scsi_Host *shpnt;
 	unsigned int ldn;
-	void (*saved_done) (Scsi_Cmnd *);
+	void (*saved_done) (struct scsi_cmnd *);
 	int target;
 	int max_pun;
 	unsigned long imm_command;
@@ -2092,7 +2092,7 @@ static int __ibmmca_abort(Scsi_Cmnd * cmd)
 	}
 }
 
-static int ibmmca_abort(Scsi_Cmnd * cmd)
+static int ibmmca_abort(struct scsi_cmnd * cmd)
 {
 	struct Scsi_Host *shpnt = cmd->device->host;
 	int rc;
@@ -2104,10 +2104,10 @@ static int ibmmca_abort(Scsi_Cmnd * cmd)
 	return rc;
 }
 
-static int __ibmmca_host_reset(Scsi_Cmnd * cmd)
+static int __ibmmca_host_reset(struct scsi_cmnd * cmd)
 {
 	struct Scsi_Host *shpnt;
-	Scsi_Cmnd *cmd_aid;
+	struct scsi_cmnd *cmd_aid;
 	int ticks, i;
 	unsigned long imm_command;
 
@@ -2184,7 +2184,7 @@ static int __ibmmca_host_reset(Scsi_Cmnd * cmd)
 	return SUCCESS;
 }
 
-static int ibmmca_host_reset(Scsi_Cmnd * cmd)
+static int ibmmca_host_reset(struct scsi_cmnd * cmd)
 {
 	struct Scsi_Host *shpnt = cmd->device->host;
 	int rc;
-- 
1.7.4.1
