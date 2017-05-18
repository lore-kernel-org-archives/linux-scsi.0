From: Song Liu <songliubraving@fb.com>
Subject: [RFC v2 1/2] scsi: generate uevent for SCSI sense code
Date: Thu, 18 May 2017 11:14:55 -0700
Message-ID: <20170518181456.1955523-2-songliubraving@fb.com>
References: <20170518181456.1955523-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38040 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754641AbdERSPR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 May 2017 14:15:17 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4IIFEwc026042
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 11:15:16 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ahfu207gc-3
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 11:15:16 -0700
Received: from facebook.com (2401:db00:2120:20f2:face:0:9:0)    by
 mx-out.facebook.com (10.223.100.97) with ESMTP id
 efc1df363bf511e789bc24be0593f280-61f368f0 for <linux-scsi@vger.kernel.org>;
        Thu, 18 May 2017 11:15:13 -0700
In-Reply-To: <20170518181456.1955523-1-songliubraving@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, James.Bottomley@HansenPartnership.com, axboe@fb.com, axboe@kernel.dk, bblock@linux.vnet.ibm.com, emilne@redhat.com, Song Liu <songliubraving@fb.com>

This patch adds capability for SCSI layer to generate uevent for SCSI
sense code. The feature is gated by CONFIG_SCSI_SENSE_UEVENT.

We can configure which sense keys generate uevent for each device
through sysfs entry sense_event_filter, which is a bitmap of
"sense keys to generate uevent" For example, the following enables
uevent for MEDIUM_ERROR (0x03) and HARDWARE_ERROR (0x04) on scsi
drive sdc:

    echo 0x000c > /sys/block/sdc/device/sense_event_filter

Here is an example output captured by udevadm:

KERNEL[587.353177] change   /devices/pci0000:00/XXXXXXXXXX
ACTION=change
CDB=\x88\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00
DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host6/XXXXXX
DEVTYPE=scsi_device
DRIVER=sd
MODALIAS=scsi:t-0x00
SDEV_SENSE=1
SENSE_BUFFER=\x72\x03\x11\x14\x00\x00\x00\x34\x00\x0a\x80 ....
SENSE_CODE=3/11/14
SEQNUM=4796
SUBSYSTEM=scsi

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 drivers/scsi/Kconfig       | 14 +++++++++++
 drivers/scsi/scsi_error.c  | 43 ++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c    | 58 +++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_sysfs.c  | 51 ++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_common.h |  6 +++++
 include/scsi/scsi_device.h | 27 ++++++++++++++++++++-
 6 files changed, 197 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3c52867..fd25e14 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -237,6 +237,20 @@ config SCSI_LOGGING
 	  there should be no noticeable performance impact as long as you have
 	  logging turned off.
 
+config SCSI_SENSE_UEVENT
+	bool "SCSI sense code logging"
+	depends on SCSI
+	default n
+	---help---
+	  This turns on uevent for SCSI sense code.
+
+	  You can configure which sense keys generate uevent for each device
+	  through sysfs entry sense_event_filter. For example, the following
+	  enables uevent for MEDIUM_ERROR (0x03) and HARDWARE_ERROR (0x04)
+	  on scsi drive sdc:
+
+	  echo 0x000c > /sys/block/sdc/device/sense_event_filter
+
 config SCSI_SCAN_ASYNC
 	bool "Asynchronous SCSI scanning"
 	depends on SCSI
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ecc07da..a49c63a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -426,6 +426,48 @@ static void scsi_report_sense(struct scsi_device *sdev,
 	}
 }
 
+/*
+ * generate uevent when receiving sense code from device
+ */
+static void scsi_send_sense_uevent(struct scsi_device *sdev,
+				   struct scsi_cmnd *scmd,
+				   struct scsi_sense_hdr *sshdr)
+{
+#ifdef CONFIG_SCSI_SENSE_UEVENT
+	struct scsi_event *evt;
+	unsigned char sb_len;
+
+	if (!test_bit(sshdr->sense_key & 0xf,
+		      &sdev->sense_event_filter))
+		return;
+	evt = sdev_evt_alloc(SDEV_EVT_SCSI_SENSE, GFP_ATOMIC);
+	if (!evt)
+		return;
+
+	evt->sense_evt_data.cmnd = kzalloc(scmd->cmd_len, GFP_ATOMIC);
+	if (!evt->sense_evt_data.cmnd)
+		goto alloc_cmd_fail;
+
+	sb_len = scsi_sense_data_length(scmd->sense_buffer);
+
+	evt->sense_evt_data.sense_buffer = kzalloc(sb_len, GFP_ATOMIC);
+	if (!evt->sense_evt_data.sense_buffer)
+		goto alloc_sense_fail;
+
+	evt->sense_evt_data.cmd_len = scmd->cmd_len;
+	evt->sense_evt_data.sb_len = sb_len;
+	memcpy(evt->sense_evt_data.cmnd, scmd->cmnd, scmd->cmd_len);
+	memcpy(evt->sense_evt_data.sense_buffer, scmd->sense_buffer, sb_len);
+
+	sdev_evt_send(sdev, evt);
+	return;
+alloc_sense_fail:
+	kfree(evt->sense_evt_data.cmnd);
+alloc_cmd_fail:
+	kfree(evt);
+#endif
+}
+
 /**
  * scsi_check_sense - Examine scsi cmd sense
  * @scmd:	Cmd to have sense checked.
@@ -446,6 +488,7 @@ int scsi_check_sense(struct scsi_cmnd *scmd)
 		return FAILED;	/* no valid sense data */
 
 	scsi_report_sense(sdev, &sshdr);
+	scsi_send_sense_uevent(sdev, scmd, &sshdr);
 
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e31f1cc..37b3b7e 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2660,7 +2660,15 @@ EXPORT_SYMBOL(scsi_device_set_state);
 static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 {
 	int idx = 0;
-	char *envp[3];
+	char *envp[5];	/* SDEV_EVT_SCSI_SENSE needs most entries (4) */
+#ifdef CONFIG_SCSI_SENSE_UEVENT
+	char *buf = NULL;
+	int i;
+	int buf_size;
+	int offset;
+	struct scsi_sense_hdr sshdr;
+#endif
+
 
 	switch (evt->evt_type) {
 	case SDEV_EVT_MEDIA_CHANGE:
@@ -2685,6 +2693,49 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
 		envp[idx++] = "SDEV_UA=ASYMMETRIC_ACCESS_STATE_CHANGED";
 		break;
+#ifdef CONFIG_SCSI_SENSE_UEVENT
+	case SDEV_EVT_SCSI_SENSE:
+		/*
+		 * buf is used to store 3 strings: SENSE_CODE, CDB and
+		 * SENSE_BUFFER. 4 bytes are needed for each byte in cdb
+		 * and sense buffer. So the total size required is:
+		 *
+		 *   19 (SENSE_CODE=X/XX/XX\0) + 5 (CDB=\0) +
+		 *       14 (SENSE_BUFFER=\0) + 4 * (cdb_len + sb_len);
+		 */
+		buf_size = (evt->sense_evt_data.cmd_len +
+			    evt->sense_evt_data.sb_len) * 4 + 38;
+		buf = kzalloc(buf_size, GFP_KERNEL);
+		if (!buf)
+			break;
+		offset = 0;
+
+		envp[idx++] = "SDEV_SENSE=1";
+		envp[idx++] = buf;
+		scsi_normalize_sense(evt->sense_evt_data.sense_buffer,
+				     evt->sense_evt_data.sb_len, &sshdr);
+		offset += snprintf(buf + offset, buf_size - offset,
+				   "SENSE_CODE=%1x/%02x/%02x",
+				   sshdr.sense_key, sshdr.asc, sshdr.ascq);
+		offset++;
+
+		envp[idx++] = buf + offset;
+		offset += snprintf(buf + offset, buf_size - offset, "CDB=");
+		for (i = 0; i < evt->sense_evt_data.cmd_len; i++)
+			offset += snprintf(
+				buf + offset, buf_size - offset,
+				"\\x%02x", evt->sense_evt_data.cmnd[i]);
+
+		offset++;
+		envp[idx++] = buf + offset;
+		offset += snprintf(buf + offset, buf_size - offset,
+				   "SENSE_BUFFER=");
+		for (i = 0; i < evt->sense_evt_data.sb_len; i++)
+			offset += snprintf(
+				buf + offset, buf_size - offset,
+				"\\x%02x", evt->sense_evt_data.sense_buffer[i]);
+		break;
+#endif
 	default:
 		/* do nothing */
 		break;
@@ -2693,6 +2744,10 @@ static void scsi_evt_emit(struct scsi_device *sdev, struct scsi_event *evt)
 	envp[idx++] = NULL;
 
 	kobject_uevent_env(&sdev->sdev_gendev.kobj, KOBJ_CHANGE, envp);
+
+#ifdef CONFIG_SCSI_SENSE_UEVENT
+	kfree(buf);
+#endif
 }
 
 /**
@@ -2789,6 +2844,7 @@ struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
 	case SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED:
 	case SDEV_EVT_LUN_CHANGE_REPORTED:
 	case SDEV_EVT_ALUA_STATE_CHANGE_REPORTED:
+	case SDEV_EVT_SCSI_SENSE:
 	default:
 		/* do nothing */
 		break;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 82dfe07..a4b53bb 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1072,6 +1072,54 @@ static DEVICE_ATTR(queue_ramp_up_period, S_IRUGO | S_IWUSR,
 		   sdev_show_queue_ramp_up_period,
 		   sdev_store_queue_ramp_up_period);
 
+#ifdef CONFIG_SCSI_SENSE_UEVENT
+
+/*
+ * SCSI sense key could be 0x00 - 0x0f,
+ */
+#define SCSI_SENSE_EVENT_FILTER_MASK	0xffff
+
+static ssize_t
+sdev_show_sense_event_filter(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	struct scsi_device *sdev;
+
+	sdev = to_scsi_device(dev);
+	return snprintf(buf, 20, "0x%04lx\n",
+			(sdev->sense_event_filter &
+			 SCSI_SENSE_EVENT_FILTER_MASK));
+}
+
+static ssize_t
+sdev_store_sense_event_filter(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	unsigned long filter;
+	int i;
+
+	if (kstrtoul(buf, 0, &filter))
+		return -EINVAL;
+
+	if ((filter & 0xffff) != filter)
+		return -EINVAL;
+
+	for (i = 0; i < 15; i++)
+		if (filter & SCSI_SENSE_EVENT_FILTER_MASK  & (1 << i))
+			set_bit(i, &sdev->sense_event_filter);
+		else
+			clear_bit(i, &sdev->sense_event_filter);
+	return count;
+}
+
+static DEVICE_ATTR(sense_event_filter, 0644,
+		   sdev_show_sense_event_filter,
+		   sdev_store_sense_event_filter);
+#endif
+
 static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
 					 struct attribute *attr, int i)
 {
@@ -1142,6 +1190,9 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_preferred_path.attr,
 #endif
 	&dev_attr_queue_ramp_up_period.attr,
+#ifdef CONFIG_SCSI_SENSE_UEVENT
+	&dev_attr_sense_event_filter.attr,
+#endif
 	REF_EVT(media_change),
 	REF_EVT(inquiry_change_reported),
 	REF_EVT(capacity_change_reported),
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 20bf7ea..832ff62 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -24,6 +24,12 @@ scsi_command_size(const unsigned char *cmnd)
 		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
 }
 
+static inline unsigned char
+scsi_sense_data_length(const unsigned char *sense_buffer)
+{
+	return sense_buffer[7] + 8;
+}
+
 /* Returns a human-readable name for the device */
 extern const char *scsi_device_type(unsigned type);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 05641ae..5b6f06d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -64,13 +64,24 @@ enum scsi_device_event {
 	SDEV_EVT_MODE_PARAMETER_CHANGE_REPORTED,	/* 2A 01  UA reported */
 	SDEV_EVT_LUN_CHANGE_REPORTED,			/* 3F 0E  UA reported */
 	SDEV_EVT_ALUA_STATE_CHANGE_REPORTED,		/* 2A 06  UA reported */
+	SDEV_EVT_SCSI_SENSE,
 
 	SDEV_EVT_FIRST		= SDEV_EVT_MEDIA_CHANGE,
-	SDEV_EVT_LAST		= SDEV_EVT_ALUA_STATE_CHANGE_REPORTED,
+	SDEV_EVT_LAST		= SDEV_EVT_SCSI_SENSE,
 
 	SDEV_EVT_MAXBITS	= SDEV_EVT_LAST + 1
 };
 
+#ifdef CONFIG_SCSI_SENSE_UEVENT
+/* data for for SDEV_EVT_SCSI_SENSE */
+struct scsi_sense_uevent_data {
+	unsigned char		cmd_len;
+	unsigned char		*cmnd;
+	unsigned char		sb_len;
+	unsigned char		*sense_buffer;
+};
+#endif
+
 struct scsi_event {
 	enum scsi_device_event	evt_type;
 	struct list_head	node;
@@ -78,6 +89,11 @@ struct scsi_event {
 	/* put union of data structures, for non-simple event types,
 	 * here
 	 */
+	union {
+#ifdef CONFIG_SCSI_SENSE_UEVENT
+		struct scsi_sense_uevent_data sense_evt_data;
+#endif
+	};
 };
 
 struct scsi_device {
@@ -197,6 +213,15 @@ struct scsi_device {
 	atomic_t iodone_cnt;
 	atomic_t ioerr_cnt;
 
+#ifdef CONFIG_SCSI_SENSE_UEVENT
+	/*
+	 * filter of sense code uevent
+	 * setting bit X (0x00 - 0x0e) of sense_event_filter enables
+	 * uevent for sense key X
+	 */
+	unsigned long		sense_event_filter;
+#endif
+
 	struct device		sdev_gendev,
 				sdev_dev;
 
-- 
2.9.3
