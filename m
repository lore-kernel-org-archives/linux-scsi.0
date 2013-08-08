From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH v5] scsi: Generate uevents on certain unit attention codes
Date: Thu,  8 Aug 2013 15:07:48 -0400
Message-ID: <1375988868-24675-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab3HHTHu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Aug 2013 15:07:50 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r78J7oaQ003105
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 8 Aug 2013 15:07:50 -0400
Received: from emilne.csb ([10.18.25.104])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r78J7nf0021607
	for <linux-scsi@vger.kernel.org>; Thu, 8 Aug 2013 15:07:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Generate a uevent when the following Unit Attention ASC/ASCQ
codes are received:

    2A/01  MODE PARAMETERS CHANGED
    2A/09  CAPACITY DATA HAS CHANGED
    38/07  THIN PROVISIONING SOFT THRESHOLD REACHED
    3F/03  INQUIRY DATA HAS CHANGED
    3F/0E  REPORTED LUNS DATA HAS CHANGED

Log kernel messages when the following Unit Attention ASC/ASCQ
codes are received that are not as specific as those above:

    2A/xx  PARAMETERS CHANGED
    3F/xx  TARGET OPERATING CONDITIONS HAVE CHANGED

Added logic to set expecting_lun_change for other LUNs on the target
after REPORTED LUNS DATA HAS CHANGED is received, so that duplicate
uevents are not generated, and clear expecting_lun_change when a
REPORT LUNS command completes, in accordance with the SPC-3
specification regarding reporting of the 3F 0E ASC/ASCQ UA.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_error.c  | 106 ++++++++++++++++++++++++++++++++++++---------
 drivers/scsi/scsi_lib.c    |  26 ++++++++++-
 drivers/scsi/scsi_sysfs.c  |  10 +++++
 include/scsi/scsi_device.h |  13 +++++-
 4 files changed, 133 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index d0f71e5..598afd9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -222,6 +222,80 @@ static inline void scsi_eh_prt_fail_stats(struct Scsi_Host *shost,
 }
 #endif
 
+ /**
+ * scsi_report_lun_change - Set flag on all *other* devices on the same target
+ *                          to indicate that a UNIT ATTENTION is expected.
+ * @sdev:	Device reporting the UNIT ATTENTION
+ */
+static void scsi_report_lun_change(struct scsi_device *sdev)
+{
+	/*
+	 * Prior to SPC-4, every device will report a 3F 0E unit attention once
+	 * until a REPORT LUNS command is received.  SPC-4 targets only report
+	 * the unit attention once on a single device.
+	 */
+	if (sdev->scsi_level <= SCSI_SPC_3)
+		sdev->sdev_target->expecting_lun_change = 1;
+}
+
+/**
+ * scsi_report_sense - Examine scsi sense information and log messages for
+ *		       certain conditions, also issue uevents for some of them.
+ * @sshdr:	sshdr to be examined
+ */
+static void scsi_report_sense(struct scsi_device *sdev,
+			      struct scsi_sense_hdr *sshdr)
+{
+	enum scsi_device_event evt_type = SDEV_EVT_MAXBITS;	/* i.e. none */
+	unsigned long flags;
+
+	if (sshdr->sense_key == UNIT_ATTENTION) {
+		if (sshdr->asc == 0x3f && sshdr->ascq == 0x03) {
+			evt_type = SDEV_EVT_INQUIRY_CHANGE_REPORTED;
+			sdev_printk(KERN_WARNING, sdev,
+				    "Inquiry data has changed");
+		} else if (sshdr->asc == 0x3f && sshdr->ascq == 0x0e) {
+			evt_type = SDEV_EVT_LUN_CHANGE_REPORTED;
+			scsi_report_lun_change(sdev);
+			sdev_printk(KERN_WARNING, sdev,
+				    "Warning! Received an indication that the "
+				    "LUN assignments on this target have "
+				    "changed. The Linux SCSI layer does not "
+				    "automatically remap LUN assignments.\n");
+		} else if (sshdr->asc == 0x3f)
+			sdev_printk(KERN_WARNING, sdev,
+				    "Warning! Received an indication that the "
+				    "operating parameters on this target have "
+				    "changed. The Linux SCSI layer does not "
+				    "automatically adjust these parameters.\n");
+
+		if (sshdr->asc == 0x38 && sshdr->ascq == 0x07) {
+			evt_type = SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED;
+			sdev_printk(KERN_WARNING, sdev,
+				    "Warning! Received an indication that the "
+				    "LUN reached a thin provisioning soft "
+				    "threshold.\n");
+		}
+
+		if (sshdr->asc == 0x2a && sshdr->ascq == 0x01) {
+			evt_type = SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED;
+			sdev_printk(KERN_WARNING, sdev,
+				    "Mode parameters changed");
+		} else if (sshdr->asc == 0x2a && sshdr->ascq == 0x09) {
+			evt_type = SDEV_EVT_CAPACITY_CHANGE_REPORTED;
+			sdev_printk(KERN_WARNING, sdev,
+				    "Capacity data has changed");
+		} else if (sshdr->asc == 0x2a)
+			sdev_printk(KERN_WARNING, sdev,
+				    "Parameters changed");
+	}
+
+	if (evt_type != SDEV_EVT_MAXBITS) {
+		set_bit(evt_type, sdev->pending_events);
+		schedule_work(&sdev->event_work);
+	}
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
@@ -241,6 +315,8 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
 		return FAILED;	/* no valid sense data */
 
+	scsi_report_sense(sdev, &sshdr);
+
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
@@ -306,6 +382,14 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
 			}
 		}
 		/*
+		 * we might also expect a cc/ua if another LUN on the target
+		 * reported a UA with an ASC/ASCQ of 3F 0E -
+		 * REPORTED LUNS DATA HAS CHANGED.
+		 */
+		if (scmd->device->sdev_target->expecting_lun_change &&
+		    sshdr.asc == 0x3f && sshdr.ascq == 0x0e)
+			return NEEDS_RETRY;
+		/*
 		 * if the device is in the process of becoming ready, we
 		 * should retry.
 		 */
@@ -318,26 +402,6 @@ static int scsi_check_sense(struct scsi_cmnd *scmd)
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
@@ -1540,6 +1604,8 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 */
 		return ADD_TO_MLQUEUE;
 	case GOOD:
+		if (scmd->cmnd[0] == REPORT_LUNS)
+			scmd->device->sdev_target->expecting_lun_change = 0;
 		scsi_handle_queue_ramp_up(scmd->device);
 	case COMMAND_TERMINATED:
 		return SUCCESS;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6dfb978..8aa44fa 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2186,7 +2186,21 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 	case SDEV_EVT_MEDIA_CHANGE:
 		envp[idx++] = "SDEV_MEDIA_CHANGE=1";
 		break;
-
+	case SDEV_EVT_INQUIRY_CHANGE_REPORTED:
+		envp[idx++] = "SDEV_UA=INQUIRY_DATA_HAS_CHANGED";
+		break;
+	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
+		envp[idx++] = "SDEV_UA=CAPACITY_DATA_HAS_CHANGED";
+		break;
+	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
+	       envp[idx++] = "SDEV_UA=THIN_PROVISIONING_SOFT_THRESHOLD_REACHED";
+		break;
+	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
+		envp[idx++] = "SDEV_UA=MODE_PARAMETERS_CHANGED";
+		break;
+	case SDEV_EVT_LUN_CHANGE_REPORTED:
+		envp[idx++] = "SDEV_UA=REPORTED_LUNS_DATA_HAS_CHANGED";
+		break;
 	default:
 		/* do nothing */
 		break;
@@ -2207,10 +2221,15 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 void scsi_evt_thread(struct work_struct *work)
 {
 	struct scsi_device *sdev;
+	enum scsi_device_event evt_type;
 	LIST_HEAD(event_list);
 
 	sdev = container_of(work, struct scsi_device, event_work);
 
+	for (evt_type = SDEV_EVT_FIRST; evt_type <= SDEV_EVT_LAST; evt_type++)
+		if (test_and_clear_bit(evt_type, sdev->pending_events))
+			sdev_evt_send_simple(sdev, evt_type, GFP_KERNEL);
+
 	while (1) {
 		struct scsi_event *evt;
 		struct list_head *this, *tmp;
@@ -2280,6 +2299,11 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 	/* evt_type-specific initialization, if any */
 	switch (evt_type) {
 	case SDEV_EVT_MEDIA_CHANGE:
+	case SDEV_EVT_INQUIRY_CHANGE_REPORTED:
+	case SDEV_EVT_CAPACITY_CHANGE_REPORTED:
+	case SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED:
+	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
+	case SDEV_EVT_LUN_CHANGE_REPORTED:
 	default:
 		/* do nothing */
 		break;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..bad7fee 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -712,6 +712,11 @@ sdev_store_evt_##name(struct device *dev, struct device_attribute *attr,\
 #define REF_EVT(name) &dev_attr_evt_##name.attr
 
 DECLARE_EVT(media_change, MEDIA_CHANGE)
+DECLARE_EVT(inquiry_change_reported, INQUIRY_CHANGE_REPORTED)
+DECLARE_EVT(capacity_change_reported, CAPACITY_CHANGE_REPORTED)
+DECLARE_EVT(soft_threshold_reached, SOFT_THRESHOLD_REACHED_REPORTED)
+DECLARE_EVT(mode_parameter_change_reported, MODE_PARAMETER_CHANGE_REPORTED)
+DECLARE_EVT(lun_change_reported, LUN_CHANGE_REPORTED)
 
 /* Default template for device attributes.  May NOT be modified */
 static struct attribute *scsi_sdev_attrs[] = {
@@ -731,6 +736,11 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_ioerr_cnt.attr,
 	&dev_attr_modalias.attr,
 	REF_EVT(media_change),
+	REF_EVT(inquiry_change_reported),
+	REF_EVT(capacity_change_reported),
+	REF_EVT(soft_threshold_reached),
+	REF_EVT(mode_parameter_change_reported),
+	REF_EVT(lun_change_reported),
 	NULL
 };
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6efb2e1..a1a83ef 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -51,8 +51,15 @@ enum scsi_device_state {
 
 enum scsi_device_event {
 	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
+	SDEV_EVT_INQUIRY_CHANGE_REPORTED,		/* 3F 03  UA reported */
+	SDEV_EVT_CAPACITY_CHANGE_REPORTED,		/* 2A 09  UA reported */
+	SDEV_EVT_SOFT_THRESHOLD_REACHED_REPORTED,	/* 38 07  UA reported */
+	SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED,	/* 2A 01  UA reported */
+	SDEV_EVT_LUN_CHANGE_REPORTED,			/* 3F 0E  UA reported */
+
+	SDEV_EVT_FIRST		= SDEV_EVT_MEDIA_CHANGE,
+	SDEV_EVT_LAST		= SDEV_EVT_LUN_CHANGE_REPORTED,
 
-	SDEV_EVT_LAST		= SDEV_EVT_MEDIA_CHANGE,
 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
 };
 
@@ -154,6 +161,7 @@ struct scsi_device {
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
+	DECLARE_BITMAP(pending_events, SDEV_EVT_MAXBITS); /* pending events */
 	struct list_head event_list;	/* asserted events */
 	struct work_struct event_work;
 
@@ -251,6 +259,9 @@ struct scsi_target {
 						 * means no lun present. */
 	unsigned int		no_report_luns:1;	/* Don't use
 						 * REPORT LUNS for scanning. */
+	unsigned int		expecting_lun_change:1;	/* A device has reported
+						 * a 3F/0E UA, other devices on
+						 * the same target will also. */
 	/* commands actually active on LLD. protected by host lock. */
 	unsigned int		target_busy;
 	/*
-- 
1.7.11.7

