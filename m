From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH][resend][SCSI] Reduce sequential pointer derefs in scsi_error.c
 and reduce size as well
Date: Sun, 14 Nov 2010 23:41:10 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1011142323230.1253@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:27491 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab0KNWxW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Nov 2010 17:53:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org

This is a resend of a (slightly updated) patch that was originally 
submitted on
  24 April 2008
  27 April 2008


This patch reduces the number of sequential pointer derefs in drivers/scsi/scsi_error.c

The bennefits are:

 - makes the code easier to read. Lots of sequential derefs of the same 
   pointers is not easy on the eye.

 - theoretically at least, just dereferencing the pointers once can allow 
   the compiler to generally slightly faster code, so in theory this could 
   also be a micro speed optimization.

 - reduces size

   before:
      text    data     bss     dec     hex filename
     18829     128    4728   23685    5c85 drivers/scsi/scsi_error.o
 
   after:
      text    data     bss     dec     hex filename
     18775     128    4728   23631    5c4f drivers/scsi/scsi_error.o

Please consider applying.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 scsi_error.c |   61 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f3cf924..75a68a0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -129,14 +129,15 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 {
 	struct scsi_cmnd *scmd = req->special;
 	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
+	struct Scsi_Host *host = scmd->device->host;
 
 	trace_scsi_dispatch_cmd_timeout(scmd);
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
-	if (scmd->device->host->transportt->eh_timed_out)
-		rtn = scmd->device->host->transportt->eh_timed_out(scmd);
-	else if (scmd->device->host->hostt->eh_timed_out)
-		rtn = scmd->device->host->hostt->eh_timed_out(scmd);
+	if (host->transportt->eh_timed_out)
+		rtn = host->transportt->eh_timed_out(scmd);
+	else if (host->hostt->eh_timed_out)
+		rtn = host->hostt->eh_timed_out(scmd);
 
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
 		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
@@ -507,22 +508,23 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_host_template *hostt = host->hostt;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
 					  __func__));
 
-	if (!scmd->device->host->hostt->eh_host_reset_handler)
+	if (!hostt->eh_host_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_host_reset_handler(scmd);
+	rtn = hostt->eh_host_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!hostt->skip_settle_delay)
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
@@ -536,22 +538,23 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_host_template *hostt = host->hostt;
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
 					  __func__));
 
-	if (!scmd->device->host->hostt->eh_bus_reset_handler)
+	if (!hostt->eh_bus_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_bus_reset_handler(scmd);
+	rtn = hostt->eh_bus_reset_handler(scmd);
 
 	if (rtn == SUCCESS) {
-		if (!scmd->device->host->hostt->skip_settle_delay)
+		if (!hostt->skip_settle_delay)
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
@@ -577,16 +580,18 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 {
 	unsigned long flags;
 	int rtn;
+	struct Scsi_Host *host = scmd->device->host;
+	struct scsi_host_template *hostt = host->hostt;
 
-	if (!scmd->device->host->hostt->eh_target_reset_handler)
+	if (!hostt->eh_target_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_target_reset_handler(scmd);
+	rtn = hostt->eh_target_reset_handler(scmd);
 	if (rtn == SUCCESS) {
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
+		spin_lock_irqsave(host->host_lock, flags);
 		__starget_for_each_device(scsi_target(scmd->device), NULL,
 					  __scsi_report_device_reset);
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
 	return rtn;
@@ -605,11 +610,12 @@ static int scsi_try_target_reset(struct scsi_cmnd *scmd)
 static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
 	int rtn;
+	struct scsi_host_template *hostt = scmd->device->host->hostt;
 
-	if (!scmd->device->host->hostt->eh_device_reset_handler)
+	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = scmd->device->host->hostt->eh_device_reset_handler(scmd);
+	rtn = hostt->eh_device_reset_handler(scmd);
 	if (rtn == SUCCESS)
 		__scsi_report_device_reset(scmd->device, NULL);
 	return rtn;
@@ -617,10 +623,13 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 
 static int __scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
-	if (!scmd->device->host->hostt->eh_abort_handler)
+	int (*eh_abort_handler)(struct scsi_cmnd *) =
+		scmd->device->host->hostt->eh_abort_handler;
+
+	if (!eh_abort_handler)
 		return FAILED;
 
-	return scmd->device->host->hostt->eh_abort_handler(scmd);
+	return eh_abort_handler(scmd);
 }
 
 /**



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

