From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] fewer pointer derefs in scsi_error
Date: Thu, 24 Apr 2008 00:18:48 +0200 (CEST)
Message-ID: <alpine.LNX.1.00.0804240006450.2438@dragon.funnycrock.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754693AbYDWWTH@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Eric Youngdale <eric@andante.org>, David Miller <davem@davemloft.net>, Mike Anderson <andmike@us.ibm.com>, Russell King <rmk@arm.linux.org.uk>, Jesper Juhl <jesper.juhl@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

This patch reduces the number of sequential pointer derefs in scsi_error 
( drivers/scsi/scsi_error.c ).

The bennefits of this are:
	- makes the code easier to read. Lots of sequential derefs of the 
	  same pointers are not easy on the eye.
	- makes the size of the source file 55 bytes smaller.
	- makes the size of the object file 48 bytes smaller.
	- theoretically at least, just dereferencing the pointers once can 
	  allow the compiler to generally slightly faster code, so in 
	  theory this could also be a micro speed optimization.

Please consider applying.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 scsi_error.c |   58 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 221f31e..94395a7 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -185,13 +185,14 @@ int scsi_delete_timer(struct scsi_cmnd *scmd)
 void scsi_times_out(struct scsi_cmnd *scmd)
 {
 	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
+	struct Scsi_Host *host = scmd->device->host; 
 
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
-	if (scmd->device->host->transportt->eh_timed_out)
-		eh_timed_out = scmd->device->host->transportt->eh_timed_out;
-	else if (scmd->device->host->hostt->eh_timed_out)
-		eh_timed_out = scmd->device->host->hostt->eh_timed_out;
+	if (host->transportt->eh_timed_out)
+		eh_timed_out = host->transportt->eh_timed_out;
+	else if (host->hostt->eh_timed_out)
+		eh_timed_out = host->hostt->eh_timed_out;
 	else
 		eh_timed_out = NULL;
 
@@ -474,22 +475,22 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *host = scmd->device->host;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
 					  __FUNCTION__));
 
-	if (!scmd->device->host->hostt->eh_host_reset_handler)
+	if (!host->hostt->eh_host_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_host_reset_handler(scmd);
+	rtn = host->hostt->eh_host_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!host->hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
-				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_lock_irqsave(host->host_lock, flags);
+		scsi_report_bus_reset(host, scmd_channel(scmd));
+		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
 	return rtn;
@@ -503,22 +504,22 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *host = scmd->device->host;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
 					  __FUNCTION__));
 
-	if (!scmd->device->host->hostt->eh_bus_reset_handler)
+	if (!host->hostt->eh_bus_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_bus_reset_handler(scmd);
+	rtn = host->hostt->eh_bus_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!host->hostt->skip_settle_delay)
 			ssleep(BUS_RESET_SETTLE_TIME);
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		scsi_report_bus_reset(scmd->device->host,
-				      scmd_channel(scmd));
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_lock_irqsave(host->host_lock, flags);
+		scsi_report_bus_reset(host, scmd_channel(scmd));
+		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
 	return rtn;
@@ -544,16 +545,17 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *host = scmd->device->host;
 
-	if (!scmd->device->host->hostt->eh_target_reset_handler)
+	if (!host->hostt->eh_target_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_target_reset_handler(scmd);
+	rtn = host->hostt->eh_target_reset_handler(scmd);
 	if (rtn == SUCCESS) {
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
+		spin_lock_irqsave(host->host_lock, flags);
 		__starget_for_each_device(scsi_target(scmd->device), NULL,
 					  __scsi_report_device_reset);
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
 	return rtn;
@@ -572,11 +574,12 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
 	int rtn;
+	struct Scsi_Host *host = scmd->device->host;
 
-	if (!scmd->device->host->hostt->eh_device_reset_handler)
+	if (!host->hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_device_reset_handler(scmd);
+	rtn = host->hostt->eh_device_reset_handler(scmd);
 	if (rtn == SUCCESS)
 		__scsi_report_device_reset(scmd->device, NULL);
 	return rtn;
@@ -584,10 +587,13 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 
 static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
-	if (!scmd->device->host->hostt->eh_abort_handler)
+	int (* eh_abort_handler)(struct scsi_cmnd *)
+		= scmd->device->host->hostt->eh_abort_handler;
+
+	if (!eh_abort_handler)
 		return FAILED;
 
-	return scmd->device->host->hostt->eh_abort_handler(scmd);
+	return eh_abort_handler(scmd);
 }
 
 /**
