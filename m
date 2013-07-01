From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 7/7] scsi: Add 'eh_deadline' to limit SCSI EH runtime
Date: Mon,  1 Jul 2013 08:50:55 +0200
Message-ID: <1372661455-122384-8-git-send-email-hare@suse.de>
References: <1372661455-122384-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab3GAGvD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jul 2013 02:51:03 -0400
In-Reply-To: <1372661455-122384-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, Hannes Reinecke <hare@suse.de>

This patchs adds an 'eh_deadline' sysfs attribute to the scsi
host which limits the overall runtime of the SCSI EH.
The 'eh_deadline' value is stored in the now obsolete field
'resetting'.
When a command is failed the start time of the EH is stored
in 'last_reset'. If the overall runtime of the SCSI EH is longer
than last_reset + eh_deadline, the EH is short-circuited and
falls through to issue a host reset only.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hosts.c      |   7 +++
 drivers/scsi/scsi_error.c | 130 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/scsi_sysfs.c |  37 +++++++++++++
 include/scsi/scsi_host.h  |   4 +-
 4 files changed, 170 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index df0c3c7..f334859 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -316,6 +316,12 @@ static void scsi_host_dev_release(struct device *dev)
 	kfree(shost);
 }
 
+static unsigned int shost_eh_deadline;
+
+module_param_named(eh_deadline, shost_eh_deadline, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(eh_deadline,
+		 "SCSI EH timeout in seconds (should be between 1 and 2^32-1)");
+
 static struct device_type scsi_host_type = {
 	.name =		"scsi_host",
 	.release =	scsi_host_dev_release,
@@ -388,6 +394,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	shost->eh_deadline = shost_eh_deadline * HZ;
 
 	if (sht->supported_mode == MODE_UNKNOWN)
 		/* means we didn't set it ... default to INITIATOR */
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f43de1e..84369f2 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -89,6 +89,18 @@ void scsi_schedule_eh(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL_GPL(scsi_schedule_eh);
 
+static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
+{
+	if (!shost->last_reset || !shost->eh_deadline)
+		return 0;
+
+	if (time_before(jiffies,
+			shost->last_reset + shost->eh_deadline))
+		return 0;
+
+	return 1;
+}
+
 /**
  * scsi_eh_scmd_add - add scsi cmd to error handling.
  * @scmd:	scmd to run eh on.
@@ -111,6 +123,9 @@ int scsi_eh_scmd_add(struct scsi_cmnd *scmd, int eh_flag)
 		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY))
 			goto out_unlock;
 
+	if (shost->eh_deadline && !shost->last_reset)
+		shost->last_reset = jiffies;
+
 	ret = 1;
 	scmd->eh_eflags |= eh_flag;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
@@ -140,6 +155,9 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	trace_scsi_dispatch_cmd_timeout(scmd);
 	scsi_log_completion(scmd, TIMEOUT_ERROR);
 
+	if (host->eh_deadline && !host->last_reset)
+		host->last_reset = jiffies;
+
 	if (host->transportt->eh_timed_out)
 		rtn = host->transportt->eh_timed_out(scmd);
 	else if (host->hostt->eh_timed_out)
@@ -928,13 +946,26 @@ int scsi_eh_get_sense(struct list_head *work_q,
 		      struct list_head *done_q)
 {
 	struct scsi_cmnd *scmd, *next;
+	struct Scsi_Host *shost;
 	int rtn;
+	unsigned long flags;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
 		    SCSI_SENSE_VALID(scmd))
 			continue;
 
+		shost = scmd->device->host;
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (scsi_host_eh_past_deadline(shost)) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			SCSI_LOG_ERROR_RECOVERY(3,
+				shost_printk(KERN_INFO, shost,
+					    "skip %s, past eh deadline\n",
+					     __func__));
+			break;
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(2, scmd_printk(KERN_INFO, scmd,
 						  "%s: requesting sense\n",
 						  current->comm));
@@ -1019,11 +1050,28 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 	struct scsi_cmnd *scmd, *next;
 	struct scsi_device *sdev;
 	int finish_cmds;
+	unsigned long flags;
 
 	while (!list_empty(cmd_list)) {
 		scmd = list_entry(cmd_list->next, struct scsi_cmnd, eh_entry);
 		sdev = scmd->device;
 
+		if (!try_stu) {
+			spin_lock_irqsave(sdev->host->host_lock, flags);
+			if (scsi_host_eh_past_deadline(sdev->host)) {
+				/* Push items back onto work_q */
+				list_splice_init(cmd_list, work_q);
+				spin_unlock_irqrestore(sdev->host->host_lock,
+						       flags);
+				SCSI_LOG_ERROR_RECOVERY(3,
+					shost_printk(KERN_INFO, sdev->host,
+						     "skip %s, past eh deadline",
+						     __func__));
+				break;
+			}
+			spin_unlock_irqrestore(sdev->host->host_lock, flags);
+		}
+
 		finish_cmds = !scsi_device_online(scmd->device) ||
 			(try_stu && !scsi_eh_try_stu(scmd) &&
 			 !scsi_eh_tur(scmd)) ||
@@ -1059,14 +1107,28 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 	struct scsi_cmnd *scmd, *next;
 	LIST_HEAD(check_list);
 	int rtn;
+	struct Scsi_Host *shost;
+	unsigned long flags;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		if (!(scmd->eh_eflags & SCSI_EH_CANCEL_CMD))
 			continue;
+		shost = scmd->device->host;
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (scsi_host_eh_past_deadline(shost)) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			list_splice_init(&check_list, work_q);
+			SCSI_LOG_ERROR_RECOVERY(3,
+				shost_printk(KERN_INFO, shost,
+					    "skip %s, past eh deadline\n",
+					     __func__));
+			return list_empty(work_q);
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
 						  "0x%p\n", current->comm,
 						  scmd));
-		rtn = scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd);
+		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
 		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
 			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
 			if (rtn == FAST_IO_FAIL)
@@ -1124,8 +1186,19 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 {
 	struct scsi_cmnd *scmd, *stu_scmd, *next;
 	struct scsi_device *sdev;
+	unsigned long flags;
 
 	shost_for_each_device(sdev, shost) {
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (scsi_host_eh_past_deadline(shost)) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			SCSI_LOG_ERROR_RECOVERY(3,
+				shost_printk(KERN_INFO, shost,
+					    "skip %s, past eh deadline\n",
+					     __func__));
+			break;
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
 		stu_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
@@ -1178,9 +1251,20 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 {
 	struct scsi_cmnd *scmd, *bdr_scmd, *next;
 	struct scsi_device *sdev;
+	unsigned long flags;
 	int rtn;
 
 	shost_for_each_device(sdev, shost) {
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (scsi_host_eh_past_deadline(shost)) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			SCSI_LOG_ERROR_RECOVERY(3,
+				shost_printk(KERN_INFO, shost,
+					    "skip %s, past eh deadline\n",
+					     __func__));
+			break;
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
 		bdr_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev) {
@@ -1240,6 +1324,21 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 		struct scsi_cmnd *next, *scmd;
 		int rtn;
 		unsigned int id;
+		unsigned long flags;
+
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (scsi_host_eh_past_deadline(shost)) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			/* push back on work queue for further processing */
+			list_splice_init(&check_list, work_q);
+			list_splice_init(&tmp_list, work_q);
+			SCSI_LOG_ERROR_RECOVERY(3,
+				shost_printk(KERN_INFO, shost,
+					    "skip %s, past eh deadline\n",
+					     __func__));
+			return list_empty(work_q);
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		scmd = list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
 		id = scmd_id(scmd);
@@ -1284,6 +1383,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 	LIST_HEAD(check_list);
 	unsigned int channel;
 	int rtn;
+	unsigned long flags;
 
 	/*
 	 * we really want to loop over the various channels, and do this on
@@ -1293,6 +1393,18 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 	 */
 
 	for (channel = 0; channel <= shost->max_channel; channel++) {
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (scsi_host_eh_past_deadline(shost)) {
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			list_splice_init(&check_list, work_q);
+			SCSI_LOG_ERROR_RECOVERY(3,
+				shost_printk(KERN_INFO, shost,
+					    "skip %s, past eh deadline\n",
+					     __func__));
+			return list_empty(work_q);
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
 		chan_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry) {
 			if (channel == scmd_channel(scmd)) {
@@ -1698,8 +1810,9 @@ static void scsi_restart_operations(struct Scsi_Host *shost)
 	 * will be requests for character device operations, and also for
 	 * ioctls to queued block devices.
 	 */
-	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n",
-					  __func__));
+	SCSI_LOG_ERROR_RECOVERY(3,
+		printk("scsi_eh_%d waking up host to restart\n",
+		       shost->host_no));
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_RUNNING))
@@ -1826,6 +1939,10 @@ static void scsi_unjam_host(struct Scsi_Host *shost)
 		if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
 			scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
 
+	spin_lock_irqsave(shost->host_lock, flags);
+	if (shost->eh_deadline)
+		shost->last_reset = 0;
+	spin_unlock_irqrestore(shost->host_lock, flags);
 	scsi_eh_flush_done_q(&eh_done_q);
 }
 
@@ -1852,7 +1969,7 @@ int scsi_error_handler(void *data)
 		if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
 		    shost->host_failed != shost->host_busy) {
 			SCSI_LOG_ERROR_RECOVERY(1,
-				printk("Error handler scsi_eh_%d sleeping\n",
+				printk("scsi_eh_%d: sleeping\n",
 					shost->host_no));
 			schedule();
 			continue;
@@ -1860,8 +1977,9 @@ int scsi_error_handler(void *data)
 
 		__set_current_state(TASK_RUNNING);
 		SCSI_LOG_ERROR_RECOVERY(1,
-			printk("Error handler scsi_eh_%d waking up\n",
-				shost->host_no));
+			printk("scsi_eh_%d: waking up %d/%d/%d\n",
+			       shost->host_no, shost->host_eh_scheduled,
+			       shost->host_failed, shost->host_busy));
 
 		/*
 		 * We have a host that is failing for some reason.  Figure out
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 931a7d9..1c597ab 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -281,6 +281,42 @@ exit_store_host_reset:
 
 static DEVICE_ATTR(host_reset, S_IWUSR, NULL, store_host_reset);
 
+static ssize_t
+show_shost_eh_deadline(struct device *dev,
+		      struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+
+	return sprintf(buf, "%d\n", shost->eh_deadline / HZ);
+}
+
+static ssize_t
+store_shost_eh_deadline(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	int ret = -EINVAL;
+	int deadline;
+	unsigned long flags;
+
+	if (shost->transportt && shost->transportt->eh_strategy_handler)
+		return ret;
+
+	if (sscanf(buf, "%d\n", &deadline) == 1) {
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (scsi_host_in_recovery(shost))
+			ret = -EBUSY;
+		else {
+			shost->eh_deadline = deadline * HZ;
+			ret = count;
+		}
+		spin_unlock_irqrestore(shost->host_lock, flags);
+	}
+	return ret;
+}
+
+static DEVICE_ATTR(eh_deadline, S_IRUGO | S_IWUSR, show_shost_eh_deadline, store_shost_eh_deadline);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
@@ -308,6 +344,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_prot_capabilities.attr,
 	&dev_attr_prot_guard_type.attr,
 	&dev_attr_host_reset.attr,
+	&dev_attr_eh_deadline.attr,
 	NULL
 };
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7552435..896bb05 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -596,9 +596,9 @@ struct Scsi_Host {
 	unsigned int host_busy;		   /* commands actually active on low-level */
 	unsigned int host_failed;	   /* commands that failed. */
 	unsigned int host_eh_scheduled;    /* EH scheduled without command */
-    
+
 	unsigned int host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
-	int resetting; /* if set, it means that last_reset is a valid value */
+	int eh_deadline;
 	unsigned long last_reset;
 
 	/*
-- 
1.7.12.4

