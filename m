From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] scsi_error size reduction and readability improvement
Date: Mon, 31 Aug 2009 00:51:34 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0908310044090.18745@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754231AbZH3Wve@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Mike Anderson <andmike@us.ibm.com>, "David S. Miller" <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Make scsi_error.c a bit easier to read by cutting down on the number of 
long lines of pointer derefs. Also decrease object size a bit;
  $ size drivers/scsi/scsi_error.o*
     text    data     bss     dec     hex filename
     6755       6       6    6767    1a6f drivers/scsi/scsi_error.o
     6767       6       6    6779    1a7b drivers/scsi/scsi_error.o.orig

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a168935..094fe8a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -124,14 +124,15 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 enum blk_eh_timer_return scsi_times_out(struct request *req)
 {
 	struct scsi_cmnd *scmd = req->special;
+	struct Scsi_Host *shost = scmd->device->host;
 	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
 
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
-	if (scmd->device->host->transportt->eh_timed_out)
-		rtn = scmd->device->host->transportt->eh_timed_out(scmd);
-	else if (scmd->device->host->hostt->eh_timed_out)
-		rtn = scmd->device->host->hostt->eh_timed_out(scmd);
+	if (shost->transportt->eh_timed_out)
+		rtn = shost->transportt->eh_timed_out(scmd);
+	else if (shost->hostt->eh_timed_out)
+		rtn = shost->hostt->eh_timed_out(scmd);
 
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
 		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
@@ -414,24 +415,24 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
  */
 static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
+	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
 	int rtn;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
 					  __func__));
 
-	if (!scmd->device->host->hostt->eh_host_reset_handler)
+	if (!shost->hostt->eh_host_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_host_reset_handler(scmd);
+	rtn = shost->hostt->eh_host_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!shost->hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
-				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_lock_irqsave(shost->host_lock, flags);
+		scsi_report_bus_reset(shost, scmd_channel(scmd));
+		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 
 	return rtn;
@@ -443,24 +444,24 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
  */
 static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 {
+	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
 	int rtn;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
 					  __func__));
 
-	if (!scmd->device->host->hostt->eh_bus_reset_handler)
+	if (!shost->hostt->eh_bus_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_bus_reset_handler(scmd);
+	rtn = shost->hostt->eh_bus_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!shost->hostt->skip_settle_delay)
 			ssleep(BUS_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
-				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_lock_irqsave(shost->host_lock, flags);
+		scsi_report_bus_reset(shost, scmd_channel(scmd));
+		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 
 	return rtn;
@@ -484,18 +485,19 @@ static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
  */
 static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 {
+	struct Scsi_Host *shost = scmd->device->host;
 	unsigned long flags;
 	int rtn;
 
-	if (!scmd->device->host->hostt->eh_target_reset_handler)
+	if (!shost->hostt->eh_target_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_target_reset_handler(scmd);
+	rtn = shost->hostt->eh_target_reset_handler(scmd);
 	if (rtn == SUCCESS) {
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
+		spin_lock_irqsave(shost->host_lock, flags);
 		__starget_for_each_device(scsi_target(scmd->device), NULL,
 					  __scsi_report_device_reset);
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_unlock_irqrestore(shost->host_lock, flags);
 	}
 
 	return rtn;
@@ -513,12 +515,13 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
  */
 static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
+	struct Scsi_Host *shost = scmd->device->host;
 	int rtn;
 
-	if (!scmd->device->host->hostt->eh_device_reset_handler)
+	if (!shost->hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_device_reset_handler(scmd);
+	rtn = shost->hostt->eh_device_reset_handler(scmd);
 	if (rtn == SUCCESS)
 		__scsi_report_device_reset(scmd->device, NULL);
 	return rtn;
@@ -526,10 +529,12 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 
 static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
-	if (!scmd->device->host->hostt->eh_abort_handler)
+	struct Scsi_Host *shost = scmd->device->host;
+
+	if (!shost->hostt->eh_abort_handler)
 		return FAILED;
 
-	return scmd->device->host->hostt->eh_abort_handler(scmd);
+	return shost->hostt->eh_abort_handler(scmd);
 }
 
 /**




-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
