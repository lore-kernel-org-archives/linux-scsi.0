From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] scsi: Add 'access_state' attribute
Date: Wed,  8 Jul 2015 13:09:46 +0200
Message-ID: <1436353788-104911-4-git-send-email-hare@suse.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933397AbbGHLJz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 07:09:55 -0400
In-Reply-To: <1436353788-104911-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>

Add an 'access_state' attribute to display the LUN access state.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c  | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h | 13 ++++++++++++
 include/scsi/scsi_dh.h     |  1 +
 3 files changed, 67 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b4de776..5f1a981 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -81,6 +81,34 @@ const char *scsi_host_state_name(enum scsi_host_state state)
 	return name;
 }
 
+static const struct {
+	enum scsi_access_state	value;
+	char			*name;
+} sdev_access_states[] = {
+	{ SCSI_ACCESS_STATE_UNKNOWN, "unknown" },
+	{ SCSI_ACCESS_STATE_OPTIMAL, "optimal" },
+	{ SCSI_ACCESS_STATE_ACTIVE, "active" },
+	{ SCSI_ACCESS_STATE_PASSIVE, "passive" },
+	{ SCSI_ACCESS_STATE_UNAVAILABLE, "unavailable" },
+	{ SCSI_ACCESS_STATE_LBA, "lba-dependent" },
+	{ SCSI_ACCESS_STATE_OFFLINE, "offline" },
+	{ SCSI_ACCESS_STATE_TRANSITIONING, "transitioning" },
+	{ SCSI_ACCESS_STATE_PREFERRED, "preferred" },
+};
+const char *scsi_access_state_name(enum scsi_access_state state)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(sdev_access_states); i++) {
+		if (sdev_access_states[i].value == state) {
+			name = sdev_access_states[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
 static int check_set(unsigned long long *val, char *src)
 {
 	char *last;
@@ -934,6 +962,30 @@ sdev_store_dh_state(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(dh_state, S_IRUGO | S_IWUSR, sdev_show_dh_state,
 		   sdev_store_dh_state);
+
+static ssize_t
+sdev_show_access_state(struct device *dev,
+		       struct device_attribute *attr,
+		       char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	enum scsi_access_state access_state = SCSI_ACCESS_STATE_UNKNOWN;
+	bool pref = false;
+
+	if (sdev->handler && sdev->handler->state) {
+		int state = sdev->handler->state(sdev);
+
+		if (state & SCSI_ACCESS_STATE_PREFERRED)
+			pref = true;
+
+		access_state = (state & SCSI_ACCESS_STATE_MASK);
+	}
+
+	return snprintf(buf, 32, "%s%s\n",
+			scsi_access_state_name(access_state),
+			pref ? " preferred" :"");
+}
+static DEVICE_ATTR(access_state, S_IRUGO, sdev_show_access_state, NULL);
 #endif
 
 static ssize_t
@@ -1007,6 +1059,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_queue_type.attr,
 #ifdef CONFIG_SCSI_DH
 	&dev_attr_dh_state.attr,
+	&dev_attr_access_state.attr,
 #endif
 	&dev_attr_queue_ramp_up_period.attr,
 	REF_EVT(media_change),
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index d2f8b7a..4a10737 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -50,6 +50,19 @@ enum scsi_device_state {
 	SDEV_CREATED_BLOCK,	/* same as above but for created devices */
 };
 
+enum scsi_access_state {
+	SCSI_ACCESS_STATE_UNKNOWN = 0,
+	SCSI_ACCESS_STATE_OPTIMAL,
+	SCSI_ACCESS_STATE_ACTIVE,
+	SCSI_ACCESS_STATE_PASSIVE,
+	SCSI_ACCESS_STATE_UNAVAILABLE,
+	SCSI_ACCESS_STATE_LBA,
+	SCSI_ACCESS_STATE_OFFLINE,
+	SCSI_ACCESS_STATE_TRANSITIONING,
+	SCSI_ACCESS_STATE_PREFERRED = 0x80
+};
+#define SCSI_ACCESS_STATE_MASK 0x7f
+
 enum scsi_device_event {
 	SDEV_EVT_MEDIA_CHANGE	= 1,	/* media has changed */
 	SDEV_EVT_INQUIRY_CHANGE_REPORTED,		/* 3F 03  UA reported */
diff --git a/include/scsi/scsi_dh.h b/include/scsi/scsi_dh.h
index 5c73062..bc1b9f0 100644
--- a/include/scsi/scsi_dh.h
+++ b/include/scsi/scsi_dh.h
@@ -71,6 +71,7 @@ struct scsi_device_handler {
 	int (*prep_fn)(struct scsi_device *, struct request *);
 	int (*set_params)(struct scsi_device *, const char *);
 	void (*rescan)(struct scsi_device *);
+	int (*state)(struct scsi_device *);
 };
 
 #ifdef CONFIG_SCSI_DH
-- 
1.8.5.2

