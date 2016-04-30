From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 02/12] scsi_debug: ignore host lock option
Date: Fri, 29 Apr 2016 21:39:09 -0400
Message-ID: <1461980359-4320-3-git-send-email-dgilbert@interlog.com>
References: <1461980359-4320-1-git-send-email-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46704 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbcD3Bje (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2016 21:39:34 -0400
In-Reply-To: <1461980359-4320-1-git-send-email-dgilbert@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com, bart.vanassche@sandisk.com

Remove logic to optionally hold host_lock while each command is
queued. Keep module and sysfs host_lock parameters for backward
compatibility. Note in module parameter description that host_lock
is ignored.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 44 +++++++-------------------------------------
 1 file changed, 7 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9172b1a..40aaaed 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4042,7 +4042,7 @@ MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
 MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
 MODULE_PARM_DESC(guard, "protection checksum: 0=crc, 1=ip (def=0)");
-MODULE_PARM_DESC(host_lock, "use host_lock around all commands (def=0)");
+MODULE_PARM_DESC(host_lock, "host_lock is ignored (def=0)");
 MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP command (def=0)");
 MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
@@ -4595,30 +4595,15 @@ static ssize_t host_lock_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", !!sdebug_host_lock);
 }
-/* Returns -EBUSY if host_lock is being changed and commands are queued */
+/* N.B. sdebug_host_lock does nothing, kept for backward compatibility */
 static ssize_t host_lock_store(struct device_driver *ddp, const char *buf,
 			       size_t count)
 {
-	int n, res;
+	int n;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
-		bool new_host_lock = (n > 0);
-
-		res = count;
-		if (new_host_lock != sdebug_host_lock) {
-			unsigned long iflags;
-			int k;
-
-			spin_lock_irqsave(&queued_arr_lock, iflags);
-			k = find_first_bit(queued_in_use_bm,
-					   sdebug_max_queue);
-			if (k != sdebug_max_queue)
-				res = -EBUSY;	/* have queued commands */
-			else
-				sdebug_host_lock = new_host_lock;
-			spin_unlock_irqrestore(&queued_arr_lock, iflags);
-		}
-		return res;
+		sdebug_host_lock = (n > 0);
+		return count;
 	}
 	return -EINVAL;
 }
@@ -5038,7 +5023,7 @@ check_inject(struct scsi_cmnd *scp)
 }
 
 static int
-scsi_debug_queuecommand(struct scsi_cmnd *scp)
+scsi_debug_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scp)
 {
 	u8 sdeb_i;
 	struct scsi_device *sdp = scp->device;
@@ -5173,21 +5158,6 @@ check_cond:
 	return schedule_resp(scp, devip, check_condition_result, 0);
 }
 
-static int
-sdebug_queuecommand_lock_or_not(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
-{
-	if (sdebug_host_lock) {
-		unsigned long iflags;
-		int rc;
-
-		spin_lock_irqsave(shost->host_lock, iflags);
-		rc = scsi_debug_queuecommand(cmd);
-		spin_unlock_irqrestore(shost->host_lock, iflags);
-		return rc;
-	} else
-		return scsi_debug_queuecommand(cmd);
-}
-
 static struct scsi_host_template sdebug_driver_template = {
 	.show_info =		scsi_debug_show_info,
 	.write_info =		scsi_debug_write_info,
@@ -5198,7 +5168,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.slave_configure =	scsi_debug_slave_configure,
 	.slave_destroy =	scsi_debug_slave_destroy,
 	.ioctl =		scsi_debug_ioctl,
-	.queuecommand =		sdebug_queuecommand_lock_or_not,
+	.queuecommand =		scsi_debug_queuecommand,
 	.change_queue_depth =	sdebug_change_qdepth,
 	.eh_abort_handler =	scsi_debug_abort,
 	.eh_device_reset_handler = scsi_debug_device_reset,
-- 
2.7.4

