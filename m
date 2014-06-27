From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/7] scsi_error: do not use command list for host reset
Date: Fri, 27 Jun 2014 08:27:05 +0200
Message-ID: <1403850425-89297-8-git-send-email-hare@suse.de>
References: <1403850425-89297-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48834 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbaF0G1J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 02:27:09 -0400
In-Reply-To: <1403850425-89297-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

When host reset is called the host should be reset, and not
depend on any commands on the queue.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 40 ++++++++++++++--------------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ff069780..a32c46f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -752,11 +752,10 @@ static void scsi_eh_done(struct scsi_cmnd *scmd)
  * scsi_try_host_reset - ask host adapter to reset itself
  * @scmd:	SCSI cmd to send host reset.
  */
-static int scsi_try_host_reset(struct scsi_cmnd *scmd)
+static int scsi_try_host_reset(struct Scsi_Host *host)
 {
 	unsigned long flags;
 	int rtn;
-	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
 
 	SCSI_LOG_ERROR_RECOVERY(3,
@@ -771,7 +770,7 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 		if (!hostt->skip_settle_delay)
 			ssleep(HOST_RESET_SETTLE_TIME);
 		spin_lock_irqsave(host->host_lock, flags);
-		scsi_report_bus_reset(host, scmd_channel(scmd));
+		scsi_report_bus_reset(host, -1);
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
 
@@ -883,7 +882,7 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
 		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
 			if (scsi_try_target_reset(scmd) != SUCCESS)
 				if (scsi_try_bus_reset(scmd) != SUCCESS)
-					scsi_try_host_reset(scmd);
+					scsi_try_host_reset(scmd->device->host);
 }
 
 /**
@@ -1638,6 +1637,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 
 /**
  * scsi_eh_host_reset - send a host reset
+ * @shost:	&scsi host being recovered.
  * @work_q:	list_head for processed commands.
  * @done_q:	list_head for processed commands.
  */
@@ -1649,28 +1649,16 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
 	LIST_HEAD(check_list);
 	int rtn;
 
-	if (!list_empty(work_q)) {
-		scmd = list_entry(work_q->next,
-				  struct scsi_cmnd, eh_entry);
-
+	rtn = scsi_try_host_reset(shost);
+	if (rtn == SUCCESS) {
+		list_splice_init(work_q, &check_list);
+	} else if (rtn == FAST_IO_FAIL) {
+		list_for_each_entry_safe(scmd, next, work_q, eh_entry)
+			scsi_eh_finish_cmd(scmd, done_q);
+	} else {
 		SCSI_LOG_ERROR_RECOVERY(3,
-			shost_printk(KERN_INFO, shost,
-				     "%s: Sending HRST\n",
+			shost_printk("%s: HRST failed\n",
 				     current->comm));
-
-		rtn = scsi_try_host_reset(scmd);
-		if (rtn == SUCCESS) {
-			list_splice_init(work_q, &check_list);
-		} else if (rtn == FAST_IO_FAIL) {
-			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-					scsi_eh_finish_cmd(scmd, done_q);
-			}
-		} else {
-			SCSI_LOG_ERROR_RECOVERY(3,
-				shost_printk(KERN_INFO, shost,
-					     "%s: HRST failed\n",
-					     current->comm));
-		}
 	}
 	return scsi_eh_test_devices(&check_list, work_q, done_q, 1);
 }
@@ -2245,7 +2233,7 @@ void scsi_report_bus_reset(struct Scsi_Host *shost, int channel)
 	struct scsi_device *sdev;
 
 	__shost_for_each_device(sdev, shost) {
-		if (channel == sdev_channel(sdev))
+		if (channel == -1 || channel == sdev_channel(sdev))
 			__scsi_report_device_reset(sdev, NULL);
 	}
 }
@@ -2360,7 +2348,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
 			break;
 		/* FALLTHROUGH */
 	case SCSI_TRY_RESET_HOST:
-		rtn = scsi_try_host_reset(scmd);
+		rtn = scsi_try_host_reset(shost);
 		break;
 	default:
 		rtn = FAILED;
-- 
1.7.12.4

