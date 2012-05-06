From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 18/18] scsi: cleanup setting task state in
 scsi_error_handler()
Date: Sun, 06 May 2012 11:19:29 -0700
Message-ID: <20120506181929.17912.71176.stgit@dwillia2-linux.jf.intel.com>
References: <20120506181611.17912.3798.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120506181611.17912.3798.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Reading scsi_error_handler() one could easily come away with the
impression that it does its wakeup event check while the task state is
TASK_RUNNING.  In fact it sets TASK_INTERRUPTIBLE at the bottom of the
loop, but that is ~50 lines down.

Just set TASK_INTERRUPTIBLE at the top of loop and be done.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_error.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index cc8dc8c..b409b6f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1818,15 +1818,14 @@ int scsi_error_handler(void *data)
 	 * We never actually get interrupted because kthread_run
 	 * disables signal delivery for the created thread.
 	 */
-	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
+		set_current_state(TASK_INTERRUPTIBLE);
 		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
 		    shost->host_failed != shost->host_busy) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				printk("Error handler scsi_eh_%d sleeping\n",
 					shost->host_no));
 			schedule();
-			set_current_state(TASK_INTERRUPTIBLE);
 			continue;
 		}
 
@@ -1863,9 +1862,7 @@ int scsi_error_handler(void *data)
 		scsi_restart_operations(shost);
 		if (!shost->eh_noresume)
 			scsi_autopm_put_host(shost);
-		set_current_state(TASK_INTERRUPTIBLE);
 	}
-	__set_current_state(TASK_RUNNING);
 
 	SCSI_LOG_ERROR_RECOVERY(1,
 		printk("Error handler scsi_eh_%d exiting\n", shost->host_no));

