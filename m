From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 1/5] scsi host / scsi target state model update
Date: Thu, 16 Jun 2005 11:12:38 -0700
Message-ID: <20050616181238.GB20923@us.ibm.com>
References: <20050616181058.GA20923@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:18053 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S261785AbVFPSMM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2005 14:12:12 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j5GICAua208184
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:12:11 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5GIC9e9168998
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 12:12:09 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j5GIC94q032687
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 12:12:09 -0600
Received: from hmsbounty.us.ibm.com (sig-9-48-50-108.mts.ibm.com [9.48.50.108])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j5GIC8dd032585
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 12:12:08 -0600
Content-Disposition: inline
In-Reply-To: <20050616181058.GA20923@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Migrate the current SCSI host state model to a model like SCSI
device is using.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/hosts.c      |   88 +++++++++++++++--
 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi.c       |    2 
 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_error.c |    7 -
 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_ioctl.c |    3 
 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_lib.c   |    4 
 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_sysfs.c |   62 +++++++++++
 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/sg.c         |    3 
 linux-2.6.12-rc6-mm1-andmike/include/scsi/scsi_host.h  |   14 +-
 8 files changed, 162 insertions(+), 21 deletions(-)

diff -puN include/scsi/scsi_host.h~host_state include/scsi/scsi_host.h
--- linux-2.6.12-rc6-mm1/include/scsi/scsi_host.h~host_state	2005-06-10 15:32:17.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/include/scsi/scsi_host.h	2005-06-16 10:27:40.000000000 -0700
@@ -429,12 +429,15 @@ struct scsi_host_template {
 };
 
 /*
- * shost states
+ * shost state: If you alter this, you also need to alter scsi_sysfs.c
+ * (for the ascii descriptions) and the state model enforcer:
+ * scsi_host_set_state()
  */
-enum {
-	SHOST_ADD,
-	SHOST_DEL,
+enum scsi_host_state {
+	SHOST_CREATED = 1,
+	SHOST_RUNNING,
 	SHOST_CANCEL,
+	SHOST_DEL,
 	SHOST_RECOVERY,
 };
 
@@ -575,7 +578,7 @@ struct Scsi_Host {
 	unsigned int  irq;
 	
 
-	unsigned long shost_state;
+	enum scsi_host_state shost_state;
 
 	/* ldm bits */
 	struct device		shost_gendev;
@@ -633,6 +636,7 @@ extern void scsi_remove_host(struct Scsi
 extern struct Scsi_Host *scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *t);
 extern struct Scsi_Host *scsi_host_lookup(unsigned short);
+extern const char *scsi_host_state_name(enum scsi_host_state);
 
 extern u64 scsi_calculate_bounce_limit(struct Scsi_Host *);
 
diff -puN drivers/scsi/scsi_sysfs.c~host_state drivers/scsi/scsi_sysfs.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi_sysfs.c~host_state	2005-06-10 15:32:17.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_sysfs.c	2005-06-16 10:27:38.000000000 -0700
@@ -48,6 +48,30 @@ const char *scsi_device_state_name(enum 
 	return name;
 }
 
+static struct {
+	enum scsi_host_state	value;
+	char			*name;
+} shost_states[] = {
+	{ SHOST_CREATED, "created" },
+	{ SHOST_RUNNING, "running" },
+	{ SHOST_CANCEL, "cancel" },
+	{ SHOST_DEL, "deleted" },
+	{ SHOST_RECOVERY, "recovery" },
+};
+const char *scsi_host_state_name(enum scsi_host_state state)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < sizeof(shost_states)/sizeof(shost_states[0]); i++) {
+		if (shost_states[i].value == state) {
+			name = shost_states[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
 static int check_set(unsigned int *val, char *src)
 {
 	char *last;
@@ -124,6 +148,43 @@ static ssize_t store_scan(struct class_d
 };
 static CLASS_DEVICE_ATTR(scan, S_IWUSR, NULL, store_scan);
 
+static ssize_t
+store_shost_state(struct class_device *class_dev, const char *buf, size_t count)
+{
+	int i;
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	enum scsi_host_state state = 0;
+
+	for (i = 0; i < sizeof(shost_states)/sizeof(shost_states[0]); i++) {
+		const int len = strlen(shost_states[i].name);
+		if (strncmp(shost_states[i].name, buf, len) == 0 &&
+		   buf[len] == '\n') {
+			state = shost_states[i].value;
+			break;
+		}
+	}
+	if (!state)
+		return -EINVAL;
+
+	if (scsi_host_set_state(shost, state))
+		return -EINVAL;
+	return count;
+}
+
+static ssize_t
+show_shost_state(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+	const char *name = scsi_host_state_name(shost->shost_state);
+
+	if (!name)
+		return -EINVAL;
+
+	return snprintf(buf, 20, "%s\n", name);
+}
+
+static CLASS_DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
@@ -139,6 +200,7 @@ static struct class_device_attribute *sc
 	&class_device_attr_unchecked_isa_dma,
 	&class_device_attr_proc_name,
 	&class_device_attr_scan,
+	&class_device_attr_state,
 	NULL
 };
 
diff -puN drivers/scsi/hosts.c~host_state drivers/scsi/hosts.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/hosts.c~host_state	2005-06-10 15:32:17.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/hosts.c	2005-06-16 10:34:22.000000000 -0700
@@ -52,6 +52,82 @@ static struct class shost_class = {
 };
 
 /**
+ *	scsi_host_set_state - Take the given host through the host
+ *		state model.
+ *	@shost:	scsi host to change the state of.
+ *	@state:	state to change to.
+ *
+ *	Returns zero if unsuccessful or an error if the requested
+ *	transition is illegal.
+ **/
+int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
+{
+	enum scsi_host_state oldstate = shost->shost_state;
+
+	if (state == oldstate)
+		return 0;
+
+	switch (state) {
+	case SHOST_CREATED:
+		/* There are no legal states that come back to
+		 * created.  This is the manually initialised start
+		 * state */
+		goto illegal;
+
+	case SHOST_RUNNING:
+		switch (oldstate) {
+		case SHOST_CREATED:
+		case SHOST_RECOVERY:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
+	case SHOST_RECOVERY:
+		switch (oldstate) {
+		case SHOST_RUNNING:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
+	case SHOST_CANCEL:
+		switch (oldstate) {
+		case SHOST_CREATED:
+		case SHOST_RUNNING:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
+	case SHOST_DEL:
+		switch (oldstate) {
+		case SHOST_CANCEL:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
+	}
+	shost->shost_state = state;
+	return 0;
+
+ illegal:
+	SCSI_LOG_ERROR_RECOVERY(1,
+				dev_printk(KERN_ERR, &shost->shost_gendev,
+					   "Illegal host state transition"
+					   "%s->%s\n",
+					   scsi_host_state_name(oldstate),
+					   scsi_host_state_name(state)));
+	return -EINVAL;
+}
+EXPORT_SYMBOL(scsi_host_set_state);
+
+/**
  * scsi_host_cancel - cancel outstanding IO to this host
  * @shost:	pointer to struct Scsi_Host
  * recovery:	recovery requested to run.
@@ -60,12 +136,11 @@ static void scsi_host_cancel(struct Scsi
 {
 	struct scsi_device *sdev;
 
-	set_bit(SHOST_CANCEL, &shost->shost_state);
+	scsi_host_set_state(shost, SHOST_CANCEL);
 	shost_for_each_device(sdev, shost) {
 		scsi_device_cancel(sdev, recovery);
 	}
-	wait_event(shost->host_wait, (!test_bit(SHOST_RECOVERY,
-						&shost->shost_state)));
+	wait_event(shost->host_wait, (shost->shost_state != SHOST_RECOVERY));
 }
 
 /**
@@ -78,7 +153,7 @@ void scsi_remove_host(struct Scsi_Host *
 	scsi_host_cancel(shost, 0);
 	scsi_proc_host_rm(shost);
 
-	set_bit(SHOST_DEL, &shost->shost_state);
+	scsi_host_set_state(shost, SHOST_DEL);
 
 	transport_unregister_device(&shost->shost_gendev);
 	class_device_unregister(&shost->shost_classdev);
@@ -115,7 +190,7 @@ int scsi_add_host(struct Scsi_Host *shos
 	if (error)
 		goto out;
 
-	set_bit(SHOST_ADD, &shost->shost_state);
+	scsi_host_set_state(shost, SHOST_RUNNING);
 	get_device(shost->shost_gendev.parent);
 
 	error = class_device_add(&shost->shost_classdev);
@@ -231,6 +306,7 @@ struct Scsi_Host *scsi_host_alloc(struct
 
 	spin_lock_init(&shost->default_lock);
 	scsi_assign_lock(shost, &shost->default_lock);
+	shost->shost_state = SHOST_CREATED;
 	INIT_LIST_HEAD(&shost->__devices);
 	INIT_LIST_HEAD(&shost->__targets);
 	INIT_LIST_HEAD(&shost->eh_cmd_q);
@@ -387,7 +463,7 @@ EXPORT_SYMBOL(scsi_host_lookup);
  **/
 struct Scsi_Host *scsi_host_get(struct Scsi_Host *shost)
 {
-	if (test_bit(SHOST_DEL, &shost->shost_state) ||
+	if ((shost->shost_state == SHOST_DEL) ||
 		!get_device(&shost->shost_gendev))
 		return NULL;
 	return shost;
diff -puN drivers/scsi/scsi.c~host_state drivers/scsi/scsi.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi.c~host_state	2005-06-10 15:32:17.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi.c	2005-06-16 10:27:42.000000000 -0700
@@ -632,7 +632,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	spin_lock_irqsave(host->host_lock, flags);
 	scsi_cmd_get_serial(host, cmd); 
 
-	if (unlikely(test_bit(SHOST_CANCEL, &host->shost_state))) {
+	if (unlikely(host->shost_state == SHOST_CANCEL)) {
 		cmd->result = (DID_NO_CONNECT << 16);
 		scsi_done(cmd);
 	} else {
diff -puN drivers/scsi/scsi_error.c~host_state drivers/scsi/scsi_error.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi_error.c~host_state	2005-06-16 10:34:33.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_error.c	2005-06-16 10:38:04.000000000 -0700
@@ -80,7 +80,7 @@ int scsi_eh_scmd_add(struct scsi_cmnd *s
 	scmd->owner = SCSI_OWNER_ERROR_HANDLER;
 	scmd->state = SCSI_STATE_FAILED;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
-	set_bit(SHOST_RECOVERY, &shost->shost_state);
+	scsi_host_set_state(shost, SHOST_RECOVERY);
 	shost->host_failed++;
 	scsi_eh_wakeup(shost);
 	spin_unlock_irqrestore(shost->host_lock, flags);
@@ -202,7 +202,8 @@ int scsi_block_when_processing_errors(st
 {
 	int online;
 
-	wait_event(sdev->host->host_wait, (!test_bit(SHOST_RECOVERY, &sdev->host->shost_state)));
+	wait_event(sdev->host->host_wait, (sdev->host->shost_state !=
+					   SHOST_RECOVERY));
 
 	online = scsi_device_online(sdev);
 
@@ -1513,7 +1514,7 @@ static void scsi_restart_operations(stru
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: waking up host to restart\n",
 					  __FUNCTION__));
 
-	clear_bit(SHOST_RECOVERY, &shost->shost_state);
+	scsi_host_set_state(shost, SHOST_RUNNING);
 
 	wake_up(&shost->host_wait);
 
diff -puN drivers/scsi/scsi_ioctl.c~host_state drivers/scsi/scsi_ioctl.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi_ioctl.c~host_state	2005-06-16 10:38:28.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_ioctl.c	2005-06-16 10:39:26.000000000 -0700
@@ -475,8 +475,7 @@ int scsi_nonblockable_ioctl(struct scsi_
 	 * error processing, as long as the device was opened
 	 * non-blocking */
 	if (filp && filp->f_flags & O_NONBLOCK) {
-		if (test_bit(SHOST_RECOVERY,
-			     &sdev->host->shost_state))
+		if (sdev->host->shost_state == SHOST_RECOVERY)
 			return -ENODEV;
 	} else if (!scsi_block_when_processing_errors(sdev))
 		return -ENODEV;
diff -puN drivers/scsi/scsi_lib.c~host_state drivers/scsi/scsi_lib.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi_lib.c~host_state	2005-06-16 10:39:38.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_lib.c	2005-06-16 10:41:22.000000000 -0700
@@ -357,7 +357,7 @@ void scsi_device_unbusy(struct scsi_devi
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_busy--;
-	if (unlikely(test_bit(SHOST_RECOVERY, &shost->shost_state) &&
+	if (unlikely((shost->shost_state == SHOST_RECOVERY) &&
 		     shost->host_failed))
 		scsi_eh_wakeup(shost);
 	spin_unlock(shost->host_lock);
@@ -1218,7 +1218,7 @@ static inline int scsi_host_queue_ready(
 				   struct Scsi_Host *shost,
 				   struct scsi_device *sdev)
 {
-	if (test_bit(SHOST_RECOVERY, &shost->shost_state))
+	if (shost->shost_state == SHOST_RECOVERY)
 		return 0;
 	if (shost->host_busy == 0 && shost->host_blocked) {
 		/*
diff -puN drivers/scsi/sg.c~host_state drivers/scsi/sg.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/sg.c~host_state	2005-06-16 10:41:42.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/sg.c	2005-06-16 10:42:17.000000000 -0700
@@ -1027,8 +1027,7 @@ sg_ioctl(struct inode *inode, struct fil
 		if (sdp->detached)
 			return -ENODEV;
 		if (filp->f_flags & O_NONBLOCK) {
-			if (test_bit(SHOST_RECOVERY,
-				     &sdp->device->host->shost_state))
+			if (sdp->device->host->shost_state == SHOST_RECOVERY)
 				return -EBUSY;
 		} else if (!scsi_block_when_processing_errors(sdp->device))
 			return -EBUSY;
_
