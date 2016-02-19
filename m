From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv8 20/23] scsi: Add 'access_state' attribute
Date: Fri, 19 Feb 2016 09:17:17 +0100
Message-ID: <1455869840-122786-21-git-send-email-hare@suse.de>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1427028AbcBSIRx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2016 03:17:53 -0500
In-Reply-To: <1455869840-122786-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Add an 'access_state' attribute to struct scsi_device to
display the asymmetric LUN access state.

Reviewed-by: Ewan Milne <emilne@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_sysfs.c  | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 include/scsi/scsi_proto.h  | 12 +++++++++++
 3 files changed, 66 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 4f18a85..33ef68d 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -81,6 +81,33 @@ const char *scsi_host_state_name(enum scsi_host_state state)
 	return name;
 }
 
+static const struct {
+	unsigned char	value;
+	char		*name;
+} sdev_access_states[] = {
+	{ SCSI_ACCESS_STATE_OPTIMAL, "active/optimized" },
+	{ SCSI_ACCESS_STATE_ACTIVE, "active/non-optimized" },
+	{ SCSI_ACCESS_STATE_STANDBY, "standby" },
+	{ SCSI_ACCESS_STATE_UNAVAILABLE, "unavailable" },
+	{ SCSI_ACCESS_STATE_LBA, "lba-dependent" },
+	{ SCSI_ACCESS_STATE_OFFLINE, "offline" },
+	{ SCSI_ACCESS_STATE_TRANSITIONING, "transitioning" },
+};
+
+const char *scsi_access_state_name(unsigned char state)
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
@@ -973,6 +1000,31 @@ sdev_store_dh_state(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(dh_state, S_IRUGO | S_IWUSR, sdev_show_dh_state,
 		   sdev_store_dh_state);
+
+static ssize_t
+sdev_show_access_state(struct device *dev,
+		       struct device_attribute *attr,
+		       char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	unsigned char access_state;
+	const char *access_state_name;
+	bool pref = false;
+
+	if (!sdev->handler)
+		return -EINVAL;
+
+	if (sdev->access_state & SCSI_ACCESS_STATE_PREFERRED)
+		pref = true;
+
+	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
+	access_state_name = scsi_access_state_name(access_state);
+
+	return snprintf(buf, 32, "%s%s\n",
+			access_state_name ? access_state_name : "unknown",
+			pref ? " preferred" : "");
+}
+static DEVICE_ATTR(access_state, S_IRUGO, sdev_show_access_state, NULL);
 #endif
 
 static ssize_t
@@ -1047,6 +1099,7 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_wwid.attr,
 #ifdef CONFIG_SCSI_DH
 	&dev_attr_dh_state.attr,
+	&dev_attr_access_state.attr,
 #endif
 	&dev_attr_queue_ramp_up_period.attr,
 	REF_EVT(media_change),
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 4af2b24..c067019 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -201,6 +201,7 @@ struct scsi_device {
 	struct scsi_device_handler *handler;
 	void			*handler_data;
 
+	unsigned char		access_state;
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index a9fbf1b..c2ae21c 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -277,5 +277,17 @@ struct scsi_lun {
 	__u8 scsi_lun[8];
 };
 
+/* SPC asymmetric access states */
+#define SCSI_ACCESS_STATE_OPTIMAL     0x00
+#define SCSI_ACCESS_STATE_ACTIVE      0x01
+#define SCSI_ACCESS_STATE_STANDBY     0x02
+#define SCSI_ACCESS_STATE_UNAVAILABLE 0x03
+#define SCSI_ACCESS_STATE_LBA         0x04
+#define SCSI_ACCESS_STATE_OFFLINE     0x0e
+#define SCSI_ACCESS_STATE_TRANSITIONING 0x0f
+
+/* Values for REPORT TARGET GROUP STATES */
+#define SCSI_ACCESS_STATE_MASK        0x0f
+#define SCSI_ACCESS_STATE_PREFERRED   0x80
 
 #endif /* _SCSI_PROTO_H_ */
-- 
1.8.5.6

