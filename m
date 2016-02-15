From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv7 20/23] scsi: Add 'access_state' attribute
Date: Mon, 15 Feb 2016 09:24:47 +0100
Message-ID: <1455524690-121073-21-git-send-email-hare@suse.de>
References: <1455524690-121073-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46025 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbcBOIY5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Feb 2016 03:24:57 -0500
In-Reply-To: <1455524690-121073-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>

Add an 'access_state' attribute to struct scsi_device to
display the asymmetric LUN access state.

Reviewed-by: Ewan Milne <emilne@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c   |  1 +
 drivers/scsi/scsi_sysfs.c  | 49 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  1 +
 include/scsi/scsi_proto.h  | 12 ++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 97074c9..5bf3945 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -231,6 +231,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->lun = lun;
 	sdev->channel = starget->channel;
 	sdev->sdev_state = SDEV_CREATED;
+	sdev->access_state = SCSI_ACCESS_STATE_UNKNOWN;
 	INIT_LIST_HEAD(&sdev->siblings);
 	INIT_LIST_HEAD(&sdev->same_target_siblings);
 	INIT_LIST_HEAD(&sdev->cmd_list);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 4f18a85..e1541d5 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -81,6 +81,34 @@ const char *scsi_host_state_name(enum scsi_host_state state)
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
+	{ SCSI_ACCESS_STATE_UNKNOWN, "unknown" },
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
@@ -973,6 +1001,26 @@ sdev_store_dh_state(struct device *dev, struct device_attribute *attr,
 
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
+	bool pref = false;
+
+	if (sdev->access_state & SCSI_ACCESS_STATE_PREFERRED)
+		pref = true;
+
+	access_state = (sdev->access_state & SCSI_ACCESS_STATE_MASK);
+
+	return snprintf(buf, 32, "%s%s\n",
+			scsi_access_state_name(access_state),
+			pref ? " preferred" : "");
+}
+static DEVICE_ATTR(access_state, S_IRUGO, sdev_show_access_state, NULL);
 #endif
 
 static ssize_t
@@ -1047,6 +1095,7 @@ static struct attribute *scsi_sdev_attrs[] = {
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
index a9fbf1b..683bf29 100644
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
+#define SCSI_ACCESS_STATE_MASK        0x0f
+#define SCSI_ACCESS_STATE_PREFERRED   0x80
+#define SCSI_ACCESS_STATE_UNKNOWN     0x70
 
 #endif /* _SCSI_PROTO_H_ */
-- 
1.8.5.6

