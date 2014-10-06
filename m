From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 22/26] scsi: fixup logging messages in scsi_error.c
Date: Mon,  6 Oct 2014 11:01:22 +0200
Message-ID: <1412586086-129821-23-git-send-email-hare@suse.de>
References: <1412586086-129821-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44095 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbaJFJBg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2014 05:01:36 -0400
In-Reply-To: <1412586086-129821-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Use the matching scope for logging messages to allow for
better command tracing.

Suggested-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c      |  4 +--
 drivers/scsi/scsi_error.c | 77 +++++++++++++++++++++++------------------------
 2 files changed, 39 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 6de80e3..06030e1 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -485,8 +485,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 					    WQ_UNBOUND | WQ_MEM_RECLAIM,
 					   1, shost->host_no);
 	if (!shost->tmf_work_q) {
-		printk(KERN_WARNING "scsi%d: failed to create tmf workq\n",
-		       shost->host_no);
+		shost_printk(KERN_WARNING, shost,
+			     "failed to create tmf workq\n");
 		goto fail_kthread;
 	}
 	scsi_proc_hostdir_add(shost->hostt);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a113e99..087ca02 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1156,9 +1156,9 @@ int scsi_eh_get_sense(struct list_head *work_q,
 		shost = scmd->device->host;
 		if (scsi_host_eh_past_deadline(shost)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				shost_printk(KERN_INFO, shost,
-					    "skip %s, past eh deadline\n",
-					     __func__));
+				scmd_printk(KERN_INFO, scmd,
+					    "%s: skip request sense, past eh deadline\n",
+					     current->comm));
 			break;
 		}
 		if (status_byte(scmd->result) != CHECK_CONDITION)
@@ -1265,9 +1265,9 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 				/* Push items back onto work_q */
 				list_splice_init(cmd_list, work_q);
 				SCSI_LOG_ERROR_RECOVERY(3,
-					shost_printk(KERN_INFO, sdev->host,
-						     "skip %s, past eh deadline",
-						     __func__));
+					sdev_printk(KERN_INFO, sdev,
+						    "%s: skip test device, past eh deadline",
+						    current->comm));
 				break;
 			}
 		}
@@ -1318,21 +1318,20 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 		if (scsi_host_eh_past_deadline(shost)) {
 			list_splice_init(&check_list, work_q);
 			SCSI_LOG_ERROR_RECOVERY(3,
-				shost_printk(KERN_INFO, shost,
-					    "skip %s, past eh deadline\n",
-					     __func__));
+				scmd_printk(KERN_INFO, scmd,
+					    "%s: skip aborting cmd, past eh deadline\n",
+					    current->comm));
 			return list_empty(work_q);
 		}
 		SCSI_LOG_ERROR_RECOVERY(3,
-			shost_printk(KERN_INFO, shost,
-				     "%s: aborting cmd: 0x%p\n",
-				     current->comm, scmd));
+			scmd_printk(KERN_INFO, scmd,
+				     "%s: aborting cmd\n", current->comm));
 		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
 		if (rtn == FAILED) {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				shost_printk(KERN_INFO, shost,
-					     "%s: aborting cmd failed: 0x%p\n",
-					     current->comm, scmd));
+				scmd_printk(KERN_INFO, scmd,
+					    "%s: aborting cmd failed\n",
+					     current->comm));
 			list_splice_init(&check_list, work_q);
 			return list_empty(work_q);
 		}
@@ -1390,9 +1389,9 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 	shost_for_each_device(sdev, shost) {
 		if (scsi_host_eh_past_deadline(shost)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				shost_printk(KERN_INFO, shost,
-					    "skip %s, past eh deadline\n",
-					     __func__));
+				sdev_printk(KERN_INFO, sdev,
+					    "%s: skip START_UNIT, past eh deadline\n",
+					    current->comm));
 			break;
 		}
 		stu_scmd = NULL;
@@ -1407,9 +1406,9 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			continue;
 
 		SCSI_LOG_ERROR_RECOVERY(3,
-			shost_printk(KERN_INFO, shost,
-				     "%s: Sending START_UNIT to sdev: 0x%p\n",
-				     current->comm, sdev));
+			sdev_printk(KERN_INFO, sdev,
+				     "%s: Sending START_UNIT\n",
+				    current->comm));
 
 		if (!scsi_eh_try_stu(stu_scmd)) {
 			if (!scsi_device_online(sdev) ||
@@ -1423,9 +1422,9 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 			}
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				shost_printk(KERN_INFO, shost,
-					     "%s: START_UNIT failed to sdev:"
-					     " 0x%p\n", current->comm, sdev));
+				sdev_printk(KERN_INFO, sdev,
+					    "%s: START_UNIT failed\n",
+					    current->comm));
 		}
 	}
 
@@ -1456,9 +1455,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 	shost_for_each_device(sdev, shost) {
 		if (scsi_host_eh_past_deadline(shost)) {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				shost_printk(KERN_INFO, shost,
-					    "skip %s, past eh deadline\n",
-					     __func__));
+				sdev_printk(KERN_INFO, sdev,
+					    "%s: skip BDR, past eh deadline\n",
+					     current->comm));
 			break;
 		}
 		bdr_scmd = NULL;
@@ -1472,9 +1471,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 			continue;
 
 		SCSI_LOG_ERROR_RECOVERY(3,
-			shost_printk(KERN_INFO, shost,
-				     "%s: Sending BDR sdev: 0x%p\n",
-				     current->comm, sdev));
+			sdev_printk(KERN_INFO, sdev,
+				     "%s: Sending BDR\n", current->comm));
 		rtn = scsi_try_bus_device_reset(bdr_scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			if (!scsi_device_online(sdev) ||
@@ -1490,9 +1488,8 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 			}
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
-				shost_printk(KERN_INFO, shost,
-					     "%s: BDR failed sdev: 0x%p\n",
-					     current->comm, sdev));
+				sdev_printk(KERN_INFO, sdev,
+					    "%s: BDR failed\n", current->comm));
 		}
 	}
 
@@ -1528,8 +1525,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 			list_splice_init(&tmp_list, work_q);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
-					    "skip %s, past eh deadline\n",
-					     __func__));
+					    "%s: Skip target reset, past eh deadline\n",
+					     current->comm));
 			return list_empty(work_q);
 		}
 
@@ -1591,8 +1588,8 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			list_splice_init(&check_list, work_q);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
-					    "skip %s, past eh deadline\n",
-					     __func__));
+					    "%s: skip BRST, past eh deadline\n",
+					     current->comm));
 			return list_empty(work_q);
 		}
 
@@ -2189,9 +2186,9 @@ int scsi_error_handler(void *data)
 		 */
 		if (!shost->eh_noresume && scsi_autopm_get_host(shost) != 0) {
 			SCSI_LOG_ERROR_RECOVERY(1,
-				printk(KERN_ERR "Error handler scsi_eh_%d "
-						"unable to autoresume\n",
-						shost->host_no));
+				shost_printk(KERN_ERR, shost,
+					     "scsi_eh_%d: unable to autoresume\n",
+					     shost->host_no));
 			continue;
 		}
 
-- 
1.8.5.2

