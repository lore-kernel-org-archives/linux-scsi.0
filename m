From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [RFC][PATCH 2.6.11-rc2] Linux SCSI hotplug infrastructure
Date: Mon, 7 Feb 2005 12:29:15 -0600
Message-ID: <20050207182915.GB16526@lists.us.dell.com>
References: <20050207182753.GA16526@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from linux.us.dell.com ([143.166.224.162]:5292 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261223AbVBGS3S
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 13:29:18 -0500
Content-Disposition: inline
In-Reply-To: <20050207182753.GA16526@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

On Mon, Feb 07, 2005 at 12:27:53PM -0600, Matt Domsch wrote:
> Modified files:
> drivers/scsi/megaraid/megaraid_mbox.c
>  (will follow in a separate patch)
>  is the user of this new function.

For example.  I will rework this to follow the patch submitted last
week by LSI to accomplish something similar in their driver.

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

===== drivers/scsi/megaraid/megaraid_mbox.c 1.12 vs edited =====
--- 1.12/drivers/scsi/megaraid/megaraid_mbox.c	2005-01-31 00:33:46 -06:00
+++ edited/drivers/scsi/megaraid/megaraid_mbox.c	2005-02-06 23:35:08 -06:00
@@ -70,6 +70,7 @@
  * For history of changes, see Documentation/ChangeLog.megaraid
  */
 
+#include <scsi/scsi_hotplug.h>
 #include "megaraid_mbox.h"
 
 static int megaraid_init(void);
@@ -455,6 +456,100 @@
 
 
 /*
+ * sysfs class device support
+ * creates three files:
+ * /sys/class/scsi_host
+ * |-- host0
+ * |   |-- logical_drive_created
+ * |   |-- logical_drive_destroyed
+ *
+ * These make the midlayer invoke /sbin/hotplug, which then calls back into sysfs
+ * /sys/class/scsi_host
+ * |-- host0
+ * |   |-- scan
+ *
+ * and
+ *
+ * /sys/devices/pci0000:0x/0000:0x:0x.0/host0
+ * |-- 0:0:0:0
+ * |   |-- delete
+ *
+ * respectively.  This allows userspace applications to work
+ * using their logical drive number, and lets the driver translate
+ * that into host, channel, id, and lun values which the other
+ * mechanisms require.  This is similar to how hot plug CPU works.
+ */
+
+/**
+ * lda_to_hcil()
+ * @adapter
+ * @lda - logical drive address
+ * @host_no
+ * @channel
+ * @id
+ * @lun
+ *
+ * converts a logical drive address into a host, channel id, lun tuple.
+ */
+
+static inline int megaraid_lda_to_hcil(struct Scsi_Host *shost, u32 lda,
+				       u32 *host_no, u32 *channel, u32 *id, u32 *lun)
+{
+	if (lda > MAX_LOGICAL_DRIVES_40LD)
+		return -EINVAL;
+	*host_no = shost->host_no;
+	*channel = shost->max_channel;
+	*id      = (lda < shost->this_id) ? lda : lda + 1;
+	*lun     = 0;
+	return 0;
+}
+
+static int megaraid_host_store(struct class_device *class_dev, const char *buf, size_t count,
+			       enum scsi_topology_action action)
+{
+        struct Scsi_Host *shost = class_to_shost(class_dev);
+	int fields=0, rc=-EINVAL;
+	u32 lda=0, host_no=0, channel=0, id=0, lun=0;
+	fields = sscanf(buf, "%u", &lda);
+	if (fields != 1)
+		return rc;
+	if (lda > MAX_LOGICAL_DRIVES_40LD)
+		return rc;
+	rc = megaraid_lda_to_hcil(shost, lda, &host_no, &channel, &id, &lun);
+	if (rc)
+		return rc;
+
+	rc = scsi_topology_hctl_action(shost, channel, id, lun, action);
+
+	if (rc)
+		return rc;
+	return count;
+}
+
+static ssize_t megaraid_host_store_ld_created(struct class_device *class_dev, const char *buf, size_t count)
+{
+	return megaraid_host_store(class_dev, buf, count, SCSI_TOPOLOGY_ADDED);
+}
+static ssize_t megaraid_host_store_ld_destroyed(struct class_device *class_dev, const char *buf, size_t count)
+{
+	return megaraid_host_store(class_dev, buf, count, SCSI_TOPOLOGY_REMOVED);
+}
+
+
+#define MEGARAID_HOST_WOATTR(_name,_store) \
+CLASS_DEVICE_ATTR(_name, S_IWUSR|S_IWGRP, NULL, _store)
+
+static MEGARAID_HOST_WOATTR(logical_drive_created, megaraid_host_store_ld_created);
+static MEGARAID_HOST_WOATTR(logical_drive_destroyed, megaraid_host_store_ld_destroyed);
+
+/* Host attributes initializer */
+static struct class_device_attribute *megaraid_host_attrs[] = {
+	&class_device_attr_logical_drive_created,
+	&class_device_attr_logical_drive_destroyed,
+	NULL,
+};
+
+/*
  * Scsi host template for megaraid unified driver
  */
 static struct scsi_host_template megaraid_template_g = {
@@ -467,6 +562,7 @@
 	.eh_bus_reset_handler		= megaraid_reset_handler,
 	.eh_host_reset_handler		= megaraid_reset_handler,
 	.use_clustering			= ENABLE_CLUSTERING,
+	.shost_attrs			= megaraid_host_attrs,
 };
 
 
