From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [RFC][PATCH 2.6.11-rc2] Linux SCSI hotplug infrastructure
Date: Tue, 8 Feb 2005 17:23:22 -0600
Message-ID: <20050208232322.GC30086@lists.us.dell.com>
References: <20050207182753.GA16526@lists.us.dell.com> <20050208231923.GA30086@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from linux.us.dell.com ([143.166.224.162]:19074 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261685AbVBHXXW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Feb 2005 18:23:22 -0500
Received: from lists.us.dell.com (localhost.localdomain [127.0.0.1])
	by lists.us.dell.com (8.12.11/8.12.11) with ESMTP id j18NNM2f031782
	for <linux-scsi@vger.kernel.org>; Tue, 8 Feb 2005 17:23:22 -0600
Received: (from mdomsch@localhost)
	by lists.us.dell.com (8.12.11/8.12.11/Submit) id j18NNMiM031780
	for linux-scsi@vger.kernel.org; Tue, 8 Feb 2005 17:23:22 -0600
Content-Disposition: inline
In-Reply-To: <20050208231923.GA30086@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Feb 08, 2005 at 05:19:23PM -0600, Matt Domsch wrote:
> On Mon, Feb 07, 2005 at 12:27:53PM -0600, Matt Domsch wrote:
> > Below is a patch to add some hotplug infrastructure to the Linux SCSI
> > subsystem.
> 
> I've added and reworked the megaraid_mbox driver to make use of this
> new infrastructure.  I'll send that patch next.  The rest is unchanged
> from yesterday.

And these are the changes megaid_mbox to use the new infrastructure.

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

You can import this changeset into BK by piping this whole message to
'| bk receive [path to repository]' or apply the patch as usual.

===================================================================


ChangeSet@1.2132.2.3, 2005-02-08 16:46:03-06:00, Matt_Domsch@dell.com
  Release Date	: Tue Feb 08 12:27:22 EST 2005 - Matt Domsch <Matt_Domsch@dell.com>
  Current Version	: 2.20.4.6 (scsi module), 2.20.2.5 (cmm module)
  Older Version	: 2.20.4.5 (scsi module), 2.20.2.5 (cmm module)
  
  1.	Added two new megaraid_shost_attrs
  	/sys/class/scsi_host
  	|-- host0
  	|   |-- logical_drive_created
  	|   |-- logical_drive_destroyed
  	
  	and helper functions for them.  Written to from userspace by
  	a management application, these invoke SCSI hotplug
  	infrastructure for informing the kernel that a logical drive
  	has been created, or will be destroyed quite soon.
  	    echo "2" > logical_drive_created
          after creating logical drive #2 in the management app
  	    echo "4" > logical_drive_destroyed
  	immediately before destroying logical drive #4 in the
  	management app.  Eventually these functions should be called
  	directly from the management app.
  
  2.	Made class_device_megaraid_mbox_app_hndl and
          dev_attr_megaraid_mbox_ld static.
  
  Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>


 Documentation/scsi/ChangeLog.megaraid |   26 +++++++++
 drivers/scsi/megaraid/megaraid_mbox.c |   97 ++++++++++++++++++++++++++++++----
 drivers/scsi/megaraid/megaraid_mbox.h |    4 -
 3 files changed, 116 insertions, 11 deletions


diff -Nru a/Documentation/scsi/ChangeLog.megaraid b/Documentation/scsi/ChangeLog.megaraid
--- a/Documentation/scsi/ChangeLog.megaraid	2005-02-08 17:16:27 -06:00
+++ b/Documentation/scsi/ChangeLog.megaraid	2005-02-08 17:16:27 -06:00
@@ -1,3 +1,29 @@
+Release Date	: Tue Feb 08 12:27:22 EST 2005 - Matt Domsch <Matt_Domsch@dell.com>
+Current Version	: 2.20.4.6 (scsi module), 2.20.2.5 (cmm module)
+Older Version	: 2.20.4.5 (scsi module), 2.20.2.5 (cmm module)
+
+1.	Added two new megaraid_shost_attrs
+	/sys/class/scsi_host
+	|-- host0
+	|   |-- logical_drive_created
+	|   |-- logical_drive_destroyed
+	
+	and helper functions for them.  Written to from userspace by
+	a management application, these invoke SCSI hotplug
+	infrastructure for informing the kernel that a logical drive
+	has been created, or will be destroyed quite soon.
+	    echo "2" > logical_drive_created
+        after creating logical drive #2 in the management app
+	    echo "4" > logical_drive_destroyed
+	immediately before destroying logical drive #4 in the
+	management app.  Eventually these functions should be called
+	directly from the management app.
+
+2.	Made class_device_megaraid_mbox_app_hndl and
+        dev_attr_megaraid_mbox_ld static.
+
+
+
 Release Date	: Thu Feb 03 12:27:22 EST 2005 - Seokmann Ju <sju@lsil.com>
 Current Version	: 2.20.4.5 (scsi module), 2.20.2.5 (cmm module)
 Older Version	: 2.20.4.4 (scsi module), 2.20.2.4 (cmm module)
diff -Nru a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c	2005-02-08 17:16:27 -06:00
+++ b/drivers/scsi/megaraid/megaraid_mbox.c	2005-02-08 17:16:27 -06:00
@@ -69,6 +69,7 @@
  * For history of changes, see Documentation/ChangeLog.megaraid
  */
 
+#include <scsi/scsi_hotplug.h>
 #include "megaraid_mbox.h"
 
 static int megaraid_init(void);
@@ -470,29 +471,107 @@
 	}
 };
 
+/*
+ * sysfs class device support
+ * creates two files:
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
 
-// definitions for the device attributes for exporting logical drive number
-// for a scsi address (Host, Channel, Id, Lun)
-
-CLASS_DEVICE_ATTR(megaraid_mbox_app_hndl, S_IRUSR, megaraid_sysfs_show_app_hndl,
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
+#define MEGARAID_HOST_WOATTR(_name,_store) \
+CLASS_DEVICE_ATTR(_name, S_IWUSR|S_IWGRP, NULL, _store)
+
+static MEGARAID_HOST_WOATTR(logical_drive_created, megaraid_host_store_ld_created);
+static MEGARAID_HOST_WOATTR(logical_drive_destroyed, megaraid_host_store_ld_destroyed);
+static CLASS_DEVICE_ATTR(megaraid_mbox_app_hndl, S_IRUSR, megaraid_sysfs_show_app_hndl,
 		NULL);
 
-// Host template initializer for megaraid mbox sysfs device attributes
 static struct class_device_attribute *megaraid_shost_attrs[] = {
 	&class_device_attr_megaraid_mbox_app_hndl,
+	&class_device_attr_logical_drive_created,
+	&class_device_attr_logical_drive_destroyed,
 	NULL,
 };
 
+static DEVICE_ATTR(megaraid_mbox_ld, S_IRUSR, megaraid_sysfs_show_ldnum, NULL);
 
-DEVICE_ATTR(megaraid_mbox_ld, S_IRUSR, megaraid_sysfs_show_ldnum, NULL);
-
-// Host template initializer for megaraid mbox sysfs device attributes
 static struct device_attribute *megaraid_sdev_attrs[] = {
 	&dev_attr_megaraid_mbox_ld,
 	NULL,
 };
-
 
 /*
  * Scsi host template for megaraid unified driver
diff -Nru a/drivers/scsi/megaraid/megaraid_mbox.h b/drivers/scsi/megaraid/megaraid_mbox.h
--- a/drivers/scsi/megaraid/megaraid_mbox.h	2005-02-08 17:16:27 -06:00
+++ b/drivers/scsi/megaraid/megaraid_mbox.h	2005-02-08 17:16:27 -06:00
@@ -21,8 +21,8 @@
 #include "megaraid_ioctl.h"
 
 
-#define MEGARAID_VERSION	"2.20.4.5"
-#define MEGARAID_EXT_VERSION	"(Release Date: Thu Feb 03 12:27:22 EST 2005)"
+#define MEGARAID_VERSION	"2.20.4.6"
+#define MEGARAID_EXT_VERSION	"(Release Date: Tue Feb 08 12:27:22 EST 2005)"
 
 
 /*

===================================================================


This BitKeeper patch contains the following changesets:
1.2132.2.3
## Wrapped with gzip_uu ##


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
 
