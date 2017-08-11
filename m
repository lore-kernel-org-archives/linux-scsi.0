From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 2/5] scsi: Export blacklist flags to sysfs
Date: Fri, 11 Aug 2017 16:23:18 +0200
Message-ID: <1502461401-94630-3-git-send-email-hare@suse.de>
References: <1502461401-94630-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34105 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753201AbdHKOXZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Aug 2017 10:23:25 -0400
In-Reply-To: <1502461401-94630-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Each scsi device is scanned according to the found blacklist flags,
but this information is never presented to sysfs.
This makes it quite hard to figure out if blacklisting worked as
expected.
With this patch we're exporting an additional attribute 'blacklist'
containing the blacklist flags for this device.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_scan.c  |  1 +
 drivers/scsi/scsi_sysfs.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3832ba5..e4e4374 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -984,6 +984,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		scsi_attach_vpd(sdev);
 
 	sdev->max_queue_depth = sdev->queue_depth;
+	sdev->sdev_bflags = *bflags;
 
 	/*
 	 * Ok, the device is now all set up, we can
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5e8ace2..9adec62 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -20,6 +20,7 @@
 #include <scsi/scsi_dh.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_driver.h>
+#include <scsi/scsi_devinfo.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -110,6 +111,50 @@ static const char *scsi_access_state_name(unsigned char state)
 }
 #endif
 
+static const struct {
+	unsigned int	value;
+	char		*name;
+} sdev_bflags[] = {
+	{ BLIST_NOLUN, "NOLUN" },
+	{ BLIST_FORCELUN, "FORCELUN" },
+	{ BLIST_BORKEN, "BORKEN" },
+	{ BLIST_KEY, "KEY" },
+	{ BLIST_SINGLELUN, "SINGLELUN" },
+	{ BLIST_NOTQ, "NOTQ" },
+	{ BLIST_SPARSELUN, "SPARSELUN" },
+	{ BLIST_MAX5LUN, "MAX5LUN" },
+	{ BLIST_ISROM, "ISROM" },
+	{ BLIST_LARGELUN, "LARGELUN" },
+	{ BLIST_INQUIRY_36, "INQUIRY_36" },
+	{ BLIST_NOSTARTONADD, "NOSTARTONADD" },
+	{ BLIST_REPORTLUN2, "REPORTLUN2" },
+	{ BLIST_NOREPORTLUN, "NOREPORTLUN" },
+	{ BLIST_NOT_LOCKABLE, "NOT_LOCKABLE" },
+	{ BLIST_NO_ULD_ATTACH, "NO_ULD_ATTACH" },
+	{ BLIST_SELECT_NO_ATN, "SELECT_NO_ATN" },
+	{ BLIST_RETRY_HWERROR, "RETRY_HWERROR" },
+	{ BLIST_MAX_512, "MAX_512" },
+	{ BLIST_NO_DIF, "NO_DIF" },
+	{ BLIST_SKIP_VPD_PAGES, "SKIP_VPD_PAGES" },
+	{ BLIST_TRY_VPD_PAGES, "TRY_VPD_PAGES" },
+	{ BLIST_NO_RSOC, "NO_RSOC" },
+	{ BLIST_MAX_1024, "MAX_1024" },
+};
+
+static const char *sdev_bflags_name(unsigned int bflags)
+{
+	int i;
+	const char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(sdev_bflags); i++) {
+		if (sdev_bflags[i].value == bflags) {
+			name = sdev_bflags[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
 static int check_set(unsigned long long *val, char *src)
 {
 	char *last;
@@ -953,6 +998,43 @@ static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth,
 }
 static DEVICE_ATTR(wwid, S_IRUGO, sdev_show_wwid, NULL);
 
+static ssize_t
+sdev_show_blacklist(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int i;
+	char *ptr = buf;
+	ssize_t len = 0;
+
+	for (i = 0; i < sizeof(unsigned int) * 8; i++) {
+		unsigned int bflags = (unsigned int)1 << i;
+		ssize_t blen;
+		const char *name = NULL;
+
+		if (!(bflags & sdev->sdev_bflags))
+			continue;
+
+		if (ptr != buf) {
+			blen = snprintf(ptr, 2, " ");
+			ptr += blen;
+			len += blen;
+		}
+		name = sdev_bflags_name(bflags);
+		if (name)
+			blen = snprintf(ptr, strlen(name) + 1,
+					"%s", name);
+		else
+			blen = snprintf(ptr, 67, "0x%X", bflags);
+		ptr += blen;
+		len += blen;
+	}
+	if (len)
+		len += snprintf(ptr, 2, "\n");
+	return len;
+}
+static DEVICE_ATTR(blacklist, S_IRUGO, sdev_show_blacklist, NULL);
+
 #ifdef CONFIG_SCSI_DH
 static ssize_t
 sdev_show_dh_state(struct device *dev, struct device_attribute *attr,
@@ -1138,6 +1220,7 @@ static umode_t scsi_sdev_bin_attr_is_visible(struct kobject *kobj,
 	&dev_attr_queue_depth.attr,
 	&dev_attr_queue_type.attr,
 	&dev_attr_wwid.attr,
+	&dev_attr_blacklist.attr,
 #ifdef CONFIG_SCSI_DH
 	&dev_attr_dh_state.attr,
 	&dev_attr_access_state.attr,
-- 
1.8.5.6
