From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 2/6] [SCSI] add flag to skip the runtime PM calls on the host
Date: Mon, 28 Nov 2011 09:15:46 +0800
Message-ID: <1322442950-16268-3-git-send-email-ming.m.lin@intel.com>
References: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1322442950-16268-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
List-Id: linux-scsi@vger.kernel.org

With previous change, now the ata port runtime suspend will happen as:

disk suspend --> scsi target suspend --> scsi host suspend --> ata port
suspend

ata port(parent device) suspend need to schedule scsi EH which will resume
scsi host(child device). Then the child device resume will in turn make
parent device resume first. This is kind of recursive.

This patch adds a new flag Scsi_Host::eh_noresume.
ata port will set this flag to skip the runtime PM calls on scsi host.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/scsi/scsi_error.c |    5 +++--
 include/scsi/scsi_host.h  |    3 +++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index dc6131e..5f84a14 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1812,7 +1812,7 @@ int scsi_error_handler(void *data)
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (scsi_autopm_get_host(shost) != 0) {
+		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
 			SCSI_LOG_ERROR_RECOVERY(1,
 				printk(KERN_ERR "Error handler scsi_eh_%d "
 						"unable to autoresume\n",
@@ -1833,7 +1833,8 @@ int scsi_error_handler(void *data)
 		 * which are still online.
 		 */
 		scsi_restart_operations(shost);
-		scsi_autopm_put_host(shost);
+		if (!shost->eh_noresume)
+			scsi_autopm_put_host(shost);
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
 	__set_current_state(TASK_RUNNING);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 50266c9..5f7d5b3 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -669,6 +669,9 @@ struct Scsi_Host {
 	/* Asynchronous scan in progress */
 	unsigned async_scan:1;
 
+	/* Don't resume host in EH */
+	unsigned eh_noresume:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-- 
1.7.2.5
