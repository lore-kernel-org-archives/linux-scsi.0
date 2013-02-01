From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v2 5/8] [SCSI] Generate uevents for certain Unit Attention codes
Date: Fri,  1 Feb 2013 12:53:12 -0500
Message-ID: <1359741195-2641-6-git-send-email-emilne@redhat.com>
References: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283Ab3BARxT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Feb 2013 12:53:19 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r11HrJ22007440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:19 -0500
Received: from emilne.csb (dhcp-186-175.bos.redhat.com [10.16.186.175])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r11HrGRi011917
	for <linux-scsi@vger.kernel.org>; Fri, 1 Feb 2013 12:53:19 -0500
In-Reply-To: <1359741195-2641-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Generate a uevent on the scsi_target object when the following
Unit Attention ASC/ASCQ code is received:

    3F/0E  REPORTED LUNS DATA HAS CHANGED

Generate a uevent on the scsi_device object when the following
Unit Attention ASC/ASCQ codes are received:

    2A/01  MODE PARAMETERS CHANGED
    2A/09  CAPACITY DATA HAS CHANGED
    38/07  THIN PROVISIONING SOFT THRESHOLD REACHED

All uevent generation is aggregated and rate-limited so that any
individual event is delivered no more than once every 2 seconds.

Log kernel messages when the following Unit Attention ASC/ASCQ
codes are received:

    2A/xx  PARAMETERS CHANGED
    3F/03  INQUIRY DATA HAS CHANGED
    3F/xx  TARGET OPERATING CONDITIONS HAVE CHANGED

Also changed the kernel log messages on existing Unit Attention
codes, to remove text that indicates that the conditions were not
handled in any way (since they are now handled in some way) and
reflect the wording used in SPC-4.

Also log a kernel message when the a scsi device reports a Unit
Attention queue overflow, indicating that status has been lost.

These changes are only enabled when the kernel config option
CONFIG_SCSI_ENHANCED_UA is set.  Otherwise, the behavior is the
same as before, including the existing kernel log messages.
However, the detection of these conditions was moved to be earlier
in scsi_check_sense(), because the code was not always reached.

Added a new exported function scsi_report_sense() to allow drivers
to report sense data that is not associated with a SCSI command.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_error.c  | 187 ++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_lib.c    |  16 ++++
 drivers/scsi/scsi_priv.h   |   2 +
 drivers/scsi/scsi_scan.c   |   5 ++
 drivers/scsi/scsi_sysfs.c  |   3 +
 include/scsi/scsi_cmnd.h   |   4 +
 include/scsi/scsi_device.h |  21 +++++
 include/scsi/scsi_eh.h     |   5 ++
 8 files changed, 222 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d0f71e5..d0b5a26 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -223,6 +223,86 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 #endif
 
 /**
+ * scsi_report_sense - Examine scsi sense information and log messages for
+ *		       certain conditions, also issue uevents if so configured.
+ * @sshdr:	sshdr to be examined
+ */
+void scsi_report_sense(struct scsi_device *sdev, struct scsi_sense_hdr *sshdr)
+{
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	if (sshdr->ua_queue_overflow)
+		sdev_printk(KERN_WARNING, sdev,
+			    "Unit Attention queue overflow");
+#endif
+
+	if (sshdr->sense_key == UNIT_ATTENTION) {
+		if (sshdr->asc == 0x3f && sshdr->ascq == 0x03)
+			sdev_printk(KERN_WARNING, sdev,
+				    "Inquiry data has changed");
+		else if (sshdr->asc == 0x3f && sshdr->ascq == 0x0e) {
+#ifdef CONFIG_SCSI_ENHANCED_UA
+			struct scsi_target *starget = scsi_target(sdev);
+			if (atomic_xchg(&starget->lun_change_reported, 1) == 0)
+				schedule_delayed_work(&starget->ua_dwork, 2*HZ);
+			sdev_printk(KERN_WARNING, sdev,
+				    "Reported LUNs data has changed");
+#else
+			sdev_printk(KERN_WARNING, sdev,
+				    "Warning! Received an indication that the "
+				    "LUN assignments on this target have "
+				    "changed. The Linux SCSI layer does not "
+				    "automatically remap LUN assignments.\n");
+#endif
+		} else if (sshdr->asc == 0x3f)
+#ifdef CONFIG_SCSI_ENHANCED_UA
+			sdev_printk(KERN_WARNING, sdev,
+				    "Target operating conditions have changed");
+#else
+			sdev_printk(KERN_WARNING, sdev,
+				    "Warning! Received an indication that the "
+				    "operating parameters on this target have "
+				    "changed. The Linux SCSI layer does not "
+				    "automatically adjust these parameters.\n");
+#endif
+
+		if (sshdr->asc == 0x38 && sshdr->ascq == 0x07) {
+#ifdef CONFIG_SCSI_ENHANCED_UA
+			if (atomic_xchg(&sdev->soft_threshold_reached, 1) == 0)
+				schedule_delayed_work(&sdev->ua_dwork, 2 * HZ);
+			sdev_printk(KERN_WARNING, sdev,
+				    "Thin provisioning soft threshold reached");
+#else
+			sdev_printk(KERN_WARNING, sdev,
+				    "Warning! Received an indication that the "
+				    "LUN reached a thin provisioning soft "
+				    "threshold.\n");
+#endif
+		}
+
+		if (sshdr->asc == 0x2a && sshdr->ascq == 0x01) {
+#ifdef CONFIG_SCSI_ENHANCED_UA
+			if (atomic_xchg(&sdev->mode_parameter_change_reported,
+					1) == 0)
+				schedule_delayed_work(&sdev->ua_dwork, 2 * HZ);
+#endif
+			sdev_printk(KERN_WARNING, sdev,
+				    "Mode parameters changed");
+		} else if (sshdr->asc == 0x2a && sshdr->ascq == 0x09) {
+#ifdef CONFIG_SCSI_ENHANCED_UA
+			if (atomic_xchg(&sdev->capacity_change_reported,
+					1) == 0)
+				schedule_delayed_work(&sdev->ua_dwork, 2 * HZ);
+#endif
+			sdev_printk(KERN_WARNING, sdev,
+				    "Capacity data has changed");
+		} else if (sshdr->asc == 0x2a)
+			sdev_printk(KERN_WARNING, sdev,
+				    "Parameters changed");
+	}
+}
+EXPORT_SYMBOL(scsi_report_sense);
+
+/**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
  *
@@ -241,6 +321,8 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
+	scsi_report_sense(sdev, &sshdr);
+
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
@@ -318,26 +400,6 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 		if (scmd->device->allow_restart &&
 		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
 			return FAILED;
-
-		if (sshdr.asc == 0x3f && sshdr.ascq == 0x0e)
-			scmd_printk(KERN_WARNING, scmd,
-				    "Warning! Received an indication that the "
-				    "LUN assignments on this target have "
-				    "changed. The Linux SCSI layer does not "
-				    "automatically remap LUN assignments.\n");
-		else if (sshdr.asc == 0x3f)
-			scmd_printk(KERN_WARNING, scmd,
-				    "Warning! Received an indication that the "
-				    "operating parameters on this target have "
-				    "changed. The Linux SCSI layer does not "
-				    "automatically adjust these parameters.\n");
-
-		if (sshdr.asc == 0x38 && sshdr.ascq == 0x07)
-			scmd_printk(KERN_WARNING, scmd,
-				    "Warning! Received an indication that the "
-				    "LUN reached a thin provisioning soft "
-				    "threshold.\n");
-
 		/*
 		 * Pass the UA upwards for a determination in the completion
 		 * functions.
@@ -380,6 +442,52 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	}
 }
 
+#ifdef CONFIG_SCSI_ENHANCED_UA
+/**
+ *	sdev_ua_events - send a uevent for received unit attention events
+ *	@work: work struct for scsi_device
+ *
+ *	Dispatch aggregated events to their associated scsi_device kobjects
+ *	as uevents.
+ */
+void sdev_ua_events(struct work_struct *work)
+{
+	struct scsi_device *sdev;
+
+	sdev = container_of(work, struct scsi_device, ua_dwork.work);
+
+	if (atomic_xchg(&sdev->capacity_change_reported, 0) != 0)
+		sdev_evt_send_simple(sdev, SDEV_EVT_CAPACITY_CHANGE_REPORTED,
+				     GFP_KERNEL);
+	if (atomic_xchg(&sdev->soft_threshold_reached, 0) != 0)
+		sdev_evt_send_simple(sdev, SDEV_EVT_SOFT_THRESHOLD_REACHED,
+				     GFP_KERNEL);
+	if (atomic_xchg(&sdev->mode_parameter_change_reported, 0) != 0)
+		sdev_evt_send_simple(sdev,
+				     SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED,
+				     GFP_KERNEL);
+}
+
+/**
+ *	starget_ua_events - send a uevent for received unit attention events
+ *	@work: work struct for scsi_target
+ *
+ *	Dispatch aggregated events to their associated scsi_target kobjects
+ *	as uevents.
+ */
+void starget_ua_events(struct work_struct *work)
+{
+	struct scsi_target *starget;
+
+	starget = container_of(work, struct scsi_target, ua_dwork.work);
+
+	if (atomic_xchg(&starget->lun_change_reported, 0) != 0)
+		starget_evt_send_simple(starget,
+					STARGET_EVT_LUN_CHANGE_REPORTED,
+					GFP_KERNEL);
+}
+#endif
+
 static void scsi_handle_queue_ramp_up(struct scsi_device *sdev)
 {
 	struct scsi_host_template *sht = sdev->host->hostt;
@@ -2039,6 +2147,10 @@ EXPORT_SYMBOL(scsi_reset_provider);
 int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
                          struct scsi_sense_hdr *sshdr)
 {
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	int desc_pos, desc_len, desc_type, addl_len;
+#endif
+
 	if (!sense_buffer || !sb_len)
 		return 0;
 
@@ -2059,8 +2171,41 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 			sshdr->asc = sense_buffer[2];
 		if (sb_len > 3)
 			sshdr->ascq = sense_buffer[3];
-		if (sb_len > 7)
+		if (sb_len > 7) {
 			sshdr->additional_length = sense_buffer[7];
+
+#ifdef CONFIG_SCSI_ENHANCED_UA
+			desc_pos = 8;
+			desc_len = sshdr->additional_length;
+
+			if (desc_len > (sb_len - 8))
+				desc_len = sb_len - 8;
+/*
+ * desc_len should be either 0 or >= 2 here but it might not be, in which case
+ * we can't continue because we can't extract addl_len (and there is no data)
+ */
+			while (desc_len >= 2) {
+				desc_type = sense_buffer[desc_pos];
+				addl_len = sense_buffer[desc_pos + 1];
+
+				if ((sshdr->sense_key == UNIT_ATTENTION) &&
+				    (desc_type == 0x02) && (desc_len >= 5) &&
+				    (addl_len >= 3) &&
+/*
+ * addl_len is supposed to be 0x6 per the spec but we don't actually need that
+ * here, we just need it to be long enough so we can examine [desc_pos + 4]
+ */
+				    ((sense_buffer[desc_pos + 4] & 0x01) != 0))
+					sshdr->ua_queue_overflow = 1;
+
+				if (addl_len > (desc_len - 2))
+					addl_len = desc_len - 2;
+
+				desc_pos += (2 + addl_len);
+				desc_len -= (2 + addl_len);
+			}
+#endif
+		}
 	} else {
 		/*
 		 * fixed format
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b815666..f5a669c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2189,6 +2189,17 @@ static void sdev_evt_emit(struct scsi_device *sdev, struct sdev_event *evt)
 	case SDEV_EVT_CAPACITY_CHANGE:
 		envp[idx++] = "SDEV_CAPACITY_CHANGE=1";
 		break;
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
+		envp[idx++] = "SDEV_CAPACITY_CHANGE_REPORTED=1";
+		break;
+	case SDEV_EVT_SOFT_THRESHOLD_REACHED:
+		envp[idx++] = "SDEV_SOFT_THRESHOLD_REACHED=1";
+		break;
+	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
+		envp[idx++] = "SDEV_MODE_PARAMETER_CHANGE_REPORTED=1";
+		break;
+#endif
 	default:
 		/* do nothing */
 		break;
@@ -2283,6 +2294,11 @@ struct sdev_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 	switch (evt_type) {
 	case SDEV_EVT_MEDIA_CHANGE:
 	case SDEV_EVT_CAPACITY_CHANGE:
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
+	case SDEV_EVT_SOFT_THRESHOLD_REACHED:
+	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
+#endif
 	default:
 		/* do nothing */
 		break;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 5da5466..b237c8e 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -92,7 +92,9 @@ struct request;
 extern struct kmem_cache *scsi_sdb_cache;
 extern void sdev_evt_work(struct work_struct *work);
 #ifdef CONFIG_SCSI_ENHANCED_UA
+extern void sdev_ua_events(struct work_struct *work);
 extern void starget_evt_work(struct work_struct *work);
+extern void starget_ua_events(struct work_struct *work);
 #endif
 
 /* scsi_proc.c */
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2d21597..1ad4287 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -268,6 +268,9 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	spin_lock_init(&sdev->list_lock);
 	INIT_WORK(&sdev->event_work, sdev_evt_work);
 	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	INIT_DELAYED_WORK(&sdev->ua_dwork, sdev_ua_events);
+#endif
 
 	sdev->sdev_gendev.parent = get_device(&starget->dev);
 	sdev->sdev_target = starget;
@@ -429,6 +432,7 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	INIT_LIST_HEAD(&starget->event_list);
 	spin_lock_init(&starget->list_lock);
 	INIT_WORK(&starget->event_work, starget_evt_work);
+	INIT_DELAYED_WORK(&starget->ua_dwork, starget_ua_events);
 #endif
 	starget->state = STARGET_CREATED;
 	starget->scsi_level = SCSI_2;
@@ -481,6 +485,7 @@ static void scsi_target_reap_usercontext(struct work_struct *work)
 	struct list_head *this, *tmp;
 
 	cancel_work_sync(&starget->event_work);
+	cancel_delayed_work_sync(&starget->ua_dwork);
 
 	list_for_each_safe(this, tmp, &starget->event_list) {
 		struct starget_event *evt;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b22210d..aff1e29 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -351,6 +351,9 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 
 	cancel_work_sync(&sdev->event_work);
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	cancel_delayed_work_sync(&sdev->ua_dwork);
+#endif
 
 	list_for_each_safe(this, tmp, &sdev->event_list) {
 		struct sdev_event *evt;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 1e11985..4cb7a5e 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -103,7 +103,11 @@ struct scsi_cmnd {
 	struct request *request;	/* The command we are
 				   	   working on */
 
+#ifdef CONFIG_SCSI_ENHANCED_UA
+#define SCSI_SENSE_BUFFERSIZE	252
+#else
 #define SCSI_SENSE_BUFFERSIZE 	96
+#endif
 	unsigned char *sense_buffer;
 				/* obtained by REQUEST SENSE when
 				 * CHECK CONDITION is received on original
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 240aa6d..2935e61 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -52,8 +52,15 @@ enum scsi_device_state {
 enum scsi_device_event {
 	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
 	SDEV_EVT_CAPACITY_CHANGE	= 2,	/* capacity has changed */
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	SDEV_EVT_CAPACITY_CHANGE_REPORTED	= 3,	/* UA reported */
+	SDEV_EVT_SOFT_THRESHOLD_REACHED	= 4,	/* UA soft threshold reached */
+	SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED	= 5,	/* UA reported */
 
+	SDEV_EVT_LAST		= SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED,
+#else
 	SDEV_EVT_LAST		= SDEV_EVT_CAPACITY_CHANGE,
+#endif
 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
 };
 
@@ -153,6 +160,16 @@ struct scsi_device {
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	atomic_t capacity_change_reported;	/* Device has reported that
+						   capacity has changed */
+	atomic_t soft_threshold_reached;	/* Device has reported that
+						   the thin provisioning soft
+						   threshold has been reached */
+	atomic_t mode_parameter_change_reported;/* Device has reported that
+						   mode parameter has changed */
+	struct delayed_work ua_dwork;
+#endif
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
@@ -271,6 +288,10 @@ struct scsi_target {
 	unsigned int		no_report_luns:1;	/* Don't use
 						 * REPORT LUNS for scanning. */
 #ifdef CONFIG_SCSI_ENHANCED_UA
+	atomic_t	lun_change_reported;	/* Target has reported that
+						   LUNs have changed */
+	struct delayed_work ua_dwork;
+
 	DECLARE_BITMAP(supported_events, STARGET_EVT_MAXBITS);
 	struct list_head	event_list;	/* asserted events */
 	struct work_struct	event_work;
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 06a8790..b6c4d3d 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -25,6 +25,9 @@ struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
 	u8 byte5;
 	u8 byte6;
 	u8 additional_length;	/* always 0 for fixed sense format */
+#ifdef CONFIG_SCSI_ENHANCED_UA
+	unsigned int ua_queue_overflow:1;	/* UA info lost by device */
+#endif
 };
 
 static inline int scsi_sense_valid(struct scsi_sense_hdr *sshdr)
@@ -42,6 +45,8 @@ extern void scsi_eh_flush_done_q(struct list_head *done_q);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
+extern void scsi_report_sense(struct scsi_device *sdev,
+			      struct scsi_sense_hdr *sshdr);
 extern int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		struct scsi_sense_hdr *sshdr);
 extern int scsi_command_normalize_sense(struct scsi_cmnd *cmd,
-- 
1.7.11.7

