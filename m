From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 4/5] scsi host / scsi target state model update
Date: Thu, 16 Jun 2005 11:15:18 -0700
Message-ID: <20050616181518.GE20923@us.ibm.com>
References: <20050616181058.GA20923@us.ibm.com> <20050616181238.GB20923@us.ibm.com> <20050616181342.GC20923@us.ibm.com> <20050616181433.GD20923@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49350 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261788AbVFPSOx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2005 14:14:53 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j5GIEnY2000482
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:14:49 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j5GIEnCk212966
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:14:49 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j5GIEnY4013742
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:14:49 -0400
Received: from hmsbounty.us.ibm.com (sig-9-48-50-108.mts.ibm.com [9.48.50.108])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j5GIEmbq013669
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2005 14:14:48 -0400
Content-Disposition: inline
In-Reply-To: <20050616181433.GD20923@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add a SCSI target state model similar to the SCSI device state model.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_lib.c    |   57 ++++++++++++++++
 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_scan.c   |    1 
 linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_sysfs.c  |   23 ++++++
 linux-2.6.12-rc6-mm1-andmike/include/scsi/scsi_device.h |   13 +++
 4 files changed, 94 insertions(+)

diff -puN include/scsi/scsi_device.h~tgt_state include/scsi/scsi_device.h
--- linux-2.6.12-rc6-mm1/include/scsi/scsi_device.h~tgt_state	2005-06-16 10:47:35.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/include/scsi/scsi_device.h	2005-06-16 10:47:35.000000000 -0700
@@ -140,6 +140,16 @@ struct scsi_device {
 	to_scsi_device(class_dev->dev)
 
 /*
+ * stgt state:
+ * scsi_lib:scsi_device_set_state().
+ */
+enum scsi_target_state {
+	STGT_RUNNING = 1,	/* Target properly configured */
+	STGT_CANCEL,		/* Beginning to delete Target */
+	STGT_DEL,		/* Target deleted */
+};
+
+/*
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
  * starget_sdev_user is NULL, else it points to the active sdev.
@@ -155,6 +165,7 @@ struct scsi_target {
 				     * scsi_device.id eventually */
 	unsigned long		create:1; /* signal that it needs to be added */
 	void 			*hostdata; /* available to low-level driver */
+	enum scsi_target_state	stgt_state;
 	unsigned long		starget_data[0]; /* for the transport */
 	/* starget_data must be the last element!!!! */
 } __attribute__((aligned(sizeof(unsigned long))));
@@ -233,6 +244,8 @@ extern int scsi_test_unit_ready(struct s
 				int retries);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
+extern int scsi_target_set_state(struct scsi_target *,
+				 enum scsi_device_state);
 extern int scsi_device_quiesce(struct scsi_device *sdev);
 extern void scsi_device_resume(struct scsi_device *sdev);
 extern void scsi_target_quiesce(struct scsi_target *);
diff -puN drivers/scsi/scsi_lib.c~tgt_state drivers/scsi/scsi_lib.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi_lib.c~tgt_state	2005-06-16 10:47:35.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_lib.c	2005-06-16 10:47:35.000000000 -0700
@@ -1819,6 +1819,63 @@ scsi_device_set_state(struct scsi_device
 EXPORT_SYMBOL(scsi_device_set_state);
 
 /**
+ *	scsi_target_set_state - Take the given target through the target
+ *		state model.
+ *	@starget: scsi target to change the state of.
+ *	@state:	state to change to.
+ *
+ *	Returns zero if unsuccessful or an error if the requested
+ *	transition is illegal.
+ **/
+int
+scsi_target_set_state(struct scsi_target *starget, enum scsi_target_state state)
+{
+	enum scsi_target_state oldstate = starget->stgt_state;
+
+	if (state == oldstate)
+		return 0;
+
+	switch (state) {
+	case STGT_RUNNING:
+		/* There are no legal states that come back to
+		 * created.  This is the manually initialised start
+		 * state */
+		goto illegal;
+
+	case STGT_CANCEL:
+		switch (oldstate) {
+		case STGT_RUNNING:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
+	case STGT_DEL:
+		switch (oldstate) {
+		case STGT_CANCEL:
+			break;
+		default:
+			goto illegal;
+		}
+		break;
+
+	}
+	starget->stgt_state = state;
+	return 0;
+
+ illegal:
+	SCSI_LOG_ERROR_RECOVERY(1,
+				dev_printk(KERN_ERR, &starget->dev,
+					   "Illegal state transition %s->%s\n",
+					   scsi_target_state_name(oldstate),
+					   scsi_target_state_name(state))
+				);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(scsi_target_set_state);
+
+/**
  *	scsi_device_quiesce - Block user issued commands.
  *	@sdev:	scsi device to quiesce.
  *
diff -puN drivers/scsi/scsi_sysfs.c~tgt_state drivers/scsi/scsi_sysfs.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi_sysfs.c~tgt_state	2005-06-16 10:47:35.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_sysfs.c	2005-06-16 10:47:35.000000000 -0700
@@ -49,6 +49,29 @@ const char *scsi_device_state_name(enum 
 }
 
 static struct {
+	enum scsi_target_state	value;
+	char			*name;
+} stgt_states[] = {
+	{ STGT_RUNNING, "running" },
+	{ STGT_CANCEL, "cancel" },
+	{ STGT_DEL, "deleted" },
+};
+
+const char *scsi_target_state_name(enum scsi_target_state state)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < sizeof(stgt_states)/sizeof(stgt_states[0]); i++) {
+		if (stgt_states[i].value == state) {
+			name = stgt_states[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
+static struct {
 	enum scsi_host_state	value;
 	char			*name;
 } shost_states[] = {
diff -puN drivers/scsi/scsi_scan.c~tgt_state drivers/scsi/scsi_scan.c
--- linux-2.6.12-rc6-mm1/drivers/scsi/scsi_scan.c~tgt_state	2005-06-16 10:47:35.000000000 -0700
+++ linux-2.6.12-rc6-mm1-andmike/drivers/scsi/scsi_scan.c	2005-06-16 10:47:35.000000000 -0700
@@ -361,6 +361,7 @@ static struct scsi_target *scsi_alloc_ta
 	if (found_target)
 		goto found;
 
+	starget->stgt_state = STGT_RUNNING;
 	list_add_tail(&starget->siblings, &shost->__targets);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 	/* allocate and add */
_
