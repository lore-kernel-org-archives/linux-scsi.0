From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [15/18] qla2xxx: SRB handling cleanup and fixes
Date: Mon, 21 Jun 2004 22:59:33 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055933.GA8492@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:59527 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266608AbUFVFzt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:55:49 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1851 04/06/18 10:01:28 andrew.vasquez@apc.qlogic.com +2 -0
  Cleanup qla2x00_eh_wait_on_command() srb_t handling.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_def.h |    3 +-
 drivers/scsi/qla2xxx/qla_os.c  |   52 ++++++++++++++++++-----------------------
 2 files changed, 25 insertions(+), 30 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2004-06-21 15:40:03 -07:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2004-06-21 15:40:03 -07:00
@@ -2267,7 +2267,8 @@
 	mbx_cmd_t	*mcp;
 	unsigned long	mbx_cmd_flags;
 #define MBX_INTERRUPT	1
-#define MBX_INTR_WAIT   2
+#define MBX_INTR_WAIT	2
+#define MBX_UPDATE_FLASH_ACTIVE	3
 
 	spinlock_t	mbx_reg_lock;   /* Mbx Cmd Register Lock */
 
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:40:03 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:40:03 -07:00
@@ -882,38 +882,38 @@
 static int
 qla2x00_eh_wait_on_command(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
 {
-#define ABORT_WAIT_TIME	10 /* seconds */
+#define ABORT_POLLING_PERIOD	HZ
+#define ABORT_WAIT_TIME		((10 * HZ) / (ABORT_POLLING_PERIOD))
 
 	int		found = 0;
 	int		done = 0;
-	srb_t		*rp;
+	srb_t		*rp = NULL;
 	struct list_head *list, *temp;
 	u_long		max_wait_time = ABORT_WAIT_TIME;
 
 	do {
 		/* Check on done queue */
-		if (!found) {
-			spin_lock(&ha->list_lock);
-			list_for_each_safe(list, temp, &ha->done_queue) {
-				rp = list_entry(list, srb_t, list);
-
-				/*
-				* Found command.  Just exit and wait for the
-				* cmd sent to OS.
-			 	*/
-				if (cmd == rp->cmd) {
-					found++;
-					DEBUG3(printk("%s: found in done "
-							"queue.\n", __func__);)
-					break;
-				}
+		spin_lock(&ha->list_lock);
+		list_for_each_safe(list, temp, &ha->done_queue) {
+			rp = list_entry(list, srb_t, list);
+
+			/*
+			 * Found command. Just exit and wait for the cmd sent
+			 * to OS.
+			*/
+			if (cmd == rp->cmd) {
+				found++;
+				DEBUG3(printk("%s: found in done queue.\n",
+				    __func__);)
+				break;
 			}
-			spin_unlock(&ha->list_lock);
 		}
+		spin_unlock(&ha->list_lock);
 
-		/* Checking to see if its returned to OS */
-		rp = (srb_t *) CMD_SP(cmd);
-		if (rp == NULL ) {
+		/* Complete the cmd right away. */
+		if (found) { 
+			qla2x00_delete_from_done_queue(ha, rp);
+			sp_put(ha, rp);
 			done++;
 			break;
 		}
@@ -921,20 +921,14 @@
 		spin_unlock_irq(ha->host->host_lock);
 
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(2*HZ);
+		schedule_timeout(ABORT_POLLING_PERIOD);
 
 		spin_lock_irq(ha->host->host_lock);
 
 	} while ((max_wait_time--));
 
-	if (done) {
+	if (done)
 		DEBUG2(printk(KERN_INFO "%s: found cmd=%p.\n", __func__, cmd));
-	} else if (found) {
-		/* Immediately return command to the mid-layer */
-		qla2x00_delete_from_done_queue(ha, rp);
-		sp_put(ha, rp);
-		done++;
-	}
 
 	return (done);
 }
