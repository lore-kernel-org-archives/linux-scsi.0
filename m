From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 11/16] SCSI: in2000: remove Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:20:21 -0400
Message-ID: <1310710821.3184.62.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Change this for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/in2000.c |   68 ++++++++++++++++++++++++------------------------
 drivers/scsi/in2000.h |   12 ++++----
 2 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 112f1be..f11dd83 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -255,7 +255,7 @@ static unsigned long read_3393_count(struct IN2000_hostdata *hostdata)
  * will be a DATA_OUT phase with this command, false otherwise.
  * (Thanks to Joerg Dorchain for the research and suggestion.)
  */
-static int is_dir_out(Scsi_Cmnd * cmd)
+static int is_dir_out(struct scsi_cmnd * cmd)
 {
 	switch (cmd->cmnd[0]) {
 	case WRITE_6:
@@ -334,18 +334,18 @@ static uchar calc_sync_xfer(unsigned int period, unsigned int offset)
 
 static void in2000_execute(struct Scsi_Host *instance);
 
-static int in2000_queuecommand_lck(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
+static int in2000_queuecommand_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd *))
 {
 	struct Scsi_Host *instance;
 	struct IN2000_hostdata *hostdata;
-	Scsi_Cmnd *tmp;
+	struct scsi_cmnd *tmp;
 
 	instance = cmd->device->host;
 	hostdata = (struct IN2000_hostdata *) instance->hostdata;
 
 	DB(DB_QUEUE_COMMAND, scmd_printk(KERN_DEBUG, cmd, "Q-%02x(", cmd->cmnd[0]))
 
-/* Set up a few fields in the Scsi_Cmnd structure for our own use:
+/* Set up a few fields in the struct scsi_cmnd structure for our own use:
  *  - host_scribble is the pointer to the next cmd in the input queue
  *  - scsi_done points to the routine we call when a cmd is finished
  *  - result is what you'd expect
@@ -417,7 +417,7 @@ static int in2000_queuecommand_lck(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 		cmd->host_scribble = (uchar *) hostdata->input_Q;
 		hostdata->input_Q = cmd;
 	} else {		/* find the end of the queue */
-		for (tmp = (Scsi_Cmnd *) hostdata->input_Q; tmp->host_scribble; tmp = (Scsi_Cmnd *) tmp->host_scribble);
+		for (tmp = (struct scsi_cmnd *) hostdata->input_Q; tmp->host_scribble; tmp = (struct scsi_cmnd *) tmp->host_scribble);
 		tmp->host_scribble = (uchar *) cmd;
 	}
 
@@ -446,7 +446,7 @@ static DEF_SCSI_QCMD(in2000_queuecommand)
 static void in2000_execute(struct Scsi_Host *instance)
 {
 	struct IN2000_hostdata *hostdata;
-	Scsi_Cmnd *cmd, *prev;
+	struct scsi_cmnd *cmd, *prev;
 	int i;
 	unsigned short *sp;
 	unsigned short f;
@@ -469,13 +469,13 @@ static void in2000_execute(struct Scsi_Host *instance)
 	 * for an idle target/lun.
 	 */
 
-	cmd = (Scsi_Cmnd *) hostdata->input_Q;
+	cmd = (struct scsi_cmnd *) hostdata->input_Q;
 	prev = NULL;
 	while (cmd) {
 		if (!(hostdata->busy[cmd->device->id] & (1 << cmd->device->lun)))
 			break;
 		prev = cmd;
-		cmd = (Scsi_Cmnd *) cmd->host_scribble;
+		cmd = (struct scsi_cmnd *) cmd->host_scribble;
 	}
 
 	/* quit if queue empty or all possible targets are busy */
@@ -492,7 +492,7 @@ static void in2000_execute(struct Scsi_Host *instance)
 	if (prev)
 		prev->host_scribble = cmd->host_scribble;
 	else
-		hostdata->input_Q = (Scsi_Cmnd *) cmd->host_scribble;
+		hostdata->input_Q = (struct scsi_cmnd *) cmd->host_scribble;
 
 #ifdef PROC_STATISTICS
 	hostdata->cmd_cnt[cmd->device->id]++;
@@ -541,9 +541,9 @@ static void in2000_execute(struct Scsi_Host *instance)
 		goto yes;
 	if (!(hostdata->input_Q))	/* input_Q empty? */
 		goto no;
-	for (prev = (Scsi_Cmnd *) hostdata->input_Q; prev; prev = (Scsi_Cmnd *) prev->host_scribble) {
+	for (prev = (struct scsi_cmnd *) hostdata->input_Q; prev; prev = (struct scsi_cmnd *) prev->host_scribble) {
 		if ((prev->device->id != cmd->device->id) || (prev->device->lun != cmd->device->lun)) {
-			for (prev = (Scsi_Cmnd *) hostdata->input_Q; prev; prev = (Scsi_Cmnd *) prev->host_scribble)
+			for (prev = (struct scsi_cmnd *) hostdata->input_Q; prev; prev = (struct scsi_cmnd *) prev->host_scribble)
 				prev->SCp.phase = 1;
 			goto yes;
 		}
@@ -745,7 +745,7 @@ static void transfer_pio(uchar * buf, int cnt, int data_in_dir, struct IN2000_ho
 


-static void transfer_bytes(Scsi_Cmnd * cmd, int data_in_dir)
+static void transfer_bytes(struct scsi_cmnd * cmd, int data_in_dir)
 {
 	struct IN2000_hostdata *hostdata;
 	unsigned short *sp;
@@ -835,7 +835,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 {
 	struct Scsi_Host *instance = dev_id;
 	struct IN2000_hostdata *hostdata;
-	Scsi_Cmnd *patch, *cmd;
+	struct scsi_cmnd *patch, *cmd;
 	uchar asr, sr, phs, id, lun, *ucp, msg;
 	int i, j;
 	unsigned long length;
@@ -911,7 +911,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
  *    (Big thanks to Bill Earnest for getting me out of the mud in here.)
  */
 
-		cmd = (Scsi_Cmnd *) hostdata->connected;	/* assume we're connected */
+		cmd = (struct scsi_cmnd *) hostdata->connected;	/* assume we're connected */
 		CHECK_NULL(cmd, "fifo_int")
 
 		    if (hostdata->fifo == FI_FIFO_READING) {
@@ -993,7 +993,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
  * detailed info from FIFO_READING and FIFO_WRITING (see below).
  */
 
-	cmd = (Scsi_Cmnd *) hostdata->connected;	/* assume we're connected */
+	cmd = (struct scsi_cmnd *) hostdata->connected;	/* assume we're connected */
 	sr = read_3393(hostdata, WD_SCSI_STATUS);	/* clear the interrupt */
 	phs = read_3393(hostdata, WD_COMMAND_PHASE);
 
@@ -1070,7 +1070,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 		    if (hostdata->state == S_RUNNING_LEVEL2)
 			hostdata->connected = NULL;
 		else {
-			cmd = (Scsi_Cmnd *) hostdata->selecting;	/* get a valid cmd */
+			cmd = (struct scsi_cmnd *) hostdata->selecting;	/* get a valid cmd */
 			CHECK_NULL(cmd, "csr_timeout")
 			    hostdata->selecting = NULL;
 		}
@@ -1092,7 +1092,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 
 	case CSR_SELECT:
 		DB(DB_INTR, printk("SELECT"))
-		    hostdata->connected = cmd = (Scsi_Cmnd *) hostdata->selecting;
+		    hostdata->connected = cmd = (struct scsi_cmnd *) hostdata->selecting;
 		CHECK_NULL(cmd, "csr_select")
 		    hostdata->selecting = NULL;
 
@@ -1493,7 +1493,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 		    if (hostdata->level2 <= L2_NONE) {
 
 			if (hostdata->selecting) {
-				cmd = (Scsi_Cmnd *) hostdata->selecting;
+				cmd = (struct scsi_cmnd *) hostdata->selecting;
 				hostdata->selecting = NULL;
 				hostdata->busy[cmd->device->id] &= ~(1 << cmd->device->lun);
 				cmd->host_scribble = (uchar *) hostdata->input_Q;
@@ -1534,13 +1534,13 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 
 		/* Now we look for the command that's reconnecting. */
 
-		cmd = (Scsi_Cmnd *) hostdata->disconnected_Q;
+		cmd = (struct scsi_cmnd *) hostdata->disconnected_Q;
 		patch = NULL;
 		while (cmd) {
 			if (id == cmd->device->id && lun == cmd->device->lun)
 				break;
 			patch = cmd;
-			cmd = (Scsi_Cmnd *) cmd->host_scribble;
+			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
 
 		/* Hmm. Couldn't find a valid command.... What to do? */
@@ -1555,7 +1555,7 @@ static irqreturn_t in2000_intr(int irqnum, void *dev_id)
 		if (patch)
 			patch->host_scribble = cmd->host_scribble;
 		else
-			hostdata->disconnected_Q = (Scsi_Cmnd *) cmd->host_scribble;
+			hostdata->disconnected_Q = (struct scsi_cmnd *) cmd->host_scribble;
 		hostdata->connected = cmd;
 
 		/* We don't need to worry about 'initialize_SCp()' or 'hostdata->busy[]'
@@ -1640,7 +1640,7 @@ static int reset_hardware(struct Scsi_Host *instance, int type)
 


-static int in2000_bus_reset(Scsi_Cmnd * cmd)
+static int in2000_bus_reset(struct scsi_cmnd * cmd)
 {
 	struct Scsi_Host *instance;
 	struct IN2000_hostdata *hostdata;
@@ -1676,11 +1676,11 @@ static int in2000_bus_reset(Scsi_Cmnd * cmd)
 	return SUCCESS;
 }
 
-static int __in2000_abort(Scsi_Cmnd * cmd)
+static int __in2000_abort(struct scsi_cmnd * cmd)
 {
 	struct Scsi_Host *instance;
 	struct IN2000_hostdata *hostdata;
-	Scsi_Cmnd *tmp, *prev;
+	struct scsi_cmnd *tmp, *prev;
 	uchar sr, asr;
 	unsigned long timeout;
 
@@ -1695,7 +1695,7 @@ static int __in2000_abort(Scsi_Cmnd * cmd)
  *     from the inout_Q.
  */
 
-	tmp = (Scsi_Cmnd *) hostdata->input_Q;
+	tmp = (struct scsi_cmnd *) hostdata->input_Q;
 	prev = NULL;
 	while (tmp) {
 		if (tmp == cmd) {
@@ -1708,7 +1708,7 @@ static int __in2000_abort(Scsi_Cmnd * cmd)
 			return SUCCESS;
 		}
 		prev = tmp;
-		tmp = (Scsi_Cmnd *) tmp->host_scribble;
+		tmp = (struct scsi_cmnd *) tmp->host_scribble;
 	}
 
 /*
@@ -1775,7 +1775,7 @@ static int __in2000_abort(Scsi_Cmnd * cmd)
  * an ABORT_SNOOZE and hope for the best...
  */
 
-	for (tmp = (Scsi_Cmnd *) hostdata->disconnected_Q; tmp; tmp = (Scsi_Cmnd *) tmp->host_scribble)
+	for (tmp = (struct scsi_cmnd *) hostdata->disconnected_Q; tmp; tmp = (struct scsi_cmnd *) tmp->host_scribble)
 		if (cmd == tmp) {
 			printk(KERN_DEBUG "scsi%d: unable to abort disconnected command.\n", instance->host_no);
 			return FAILED;
@@ -1797,7 +1797,7 @@ static int __in2000_abort(Scsi_Cmnd * cmd)
 	return SUCCESS;
 }
 
-static int in2000_abort(Scsi_Cmnd * cmd)
+static int in2000_abort(struct scsi_cmnd * cmd)
 {
 	int rc;
 
@@ -2176,7 +2176,7 @@ static int in2000_proc_info(struct Scsi_Host *instance, char *buf, char **start,
 	char tbuf[128];
 	unsigned long flags;
 	struct IN2000_hostdata *hd;
-	Scsi_Cmnd *cmd;
+	struct scsi_cmnd *cmd;
 	int x, i;
 	static int stop = 0;
 
@@ -2268,27 +2268,27 @@ static int in2000_proc_info(struct Scsi_Host *instance, char *buf, char **start,
 	if (hd->proc & PR_CONNECTED) {
 		strcat(bp, "\nconnected:     ");
 		if (hd->connected) {
-			cmd = (Scsi_Cmnd *) hd->connected;
+			cmd = (struct scsi_cmnd *) hd->connected;
 			sprintf(tbuf, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
 		}
 	}
 	if (hd->proc & PR_INPUTQ) {
 		strcat(bp, "\ninput_Q:       ");
-		cmd = (Scsi_Cmnd *) hd->input_Q;
+		cmd = (struct scsi_cmnd *) hd->input_Q;
 		while (cmd) {
 			sprintf(tbuf, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
-			cmd = (Scsi_Cmnd *) cmd->host_scribble;
+			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
 	}
 	if (hd->proc & PR_DISCQ) {
 		strcat(bp, "\ndisconnected_Q:");
-		cmd = (Scsi_Cmnd *) hd->disconnected_Q;
+		cmd = (struct scsi_cmnd *) hd->disconnected_Q;
 		while (cmd) {
 			sprintf(tbuf, " %d:%d(%02x)", cmd->device->id, cmd->device->lun, cmd->cmnd[0]);
 			strcat(bp, tbuf);
-			cmd = (Scsi_Cmnd *) cmd->host_scribble;
+			cmd = (struct scsi_cmnd *) cmd->host_scribble;
 		}
 	}
 	if (hd->proc & PR_TEST) {
diff --git a/drivers/scsi/in2000.h b/drivers/scsi/in2000.h
index 5821e1f..9e8e40f 100644
--- a/drivers/scsi/in2000.h
+++ b/drivers/scsi/in2000.h
@@ -283,10 +283,10 @@ struct IN2000_hostdata {
     unsigned int     dip_switch;       /* dip switch settings */
     unsigned int     hrev;             /* hardware revision of card */
     volatile uchar   busy[8];          /* index = target, bit = lun */
-    volatile Scsi_Cmnd *input_Q;       /* commands waiting to be started */
-    volatile Scsi_Cmnd *selecting;     /* trying to select this command */
-    volatile Scsi_Cmnd *connected;     /* currently connected command */
-    volatile Scsi_Cmnd *disconnected_Q;/* commands waiting for reconnect */
+    volatile struct scsi_cmnd *input_Q;       /* commands waiting to be started */
+    volatile struct scsi_cmnd *selecting;     /* trying to select this command */
+    volatile struct scsi_cmnd *connected;     /* currently connected command */
+    volatile struct scsi_cmnd *disconnected_Q;/* commands waiting for reconnect */
     uchar            state;            /* what we are currently doing */
     uchar            fifo;             /* what the FIFO is up to */
     uchar            level2;           /* extent to which Level-2 commands are used */
@@ -397,11 +397,11 @@ struct IN2000_hostdata {
 
 static int in2000_detect(struct scsi_host_template *) in2000__INIT;
 static int in2000_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
-static int in2000_abort(Scsi_Cmnd *);
+static int in2000_abort(struct scsi_cmnd *);
 static void in2000_setup(char *, int *) in2000__INIT;
 static int in2000_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int *);
-static int in2000_bus_reset(Scsi_Cmnd *);
+static int in2000_bus_reset(struct scsi_cmnd *);
 

 #define IN2000_CAN_Q    16
-- 
1.7.4.1
