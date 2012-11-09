From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v9 08/10] scsi: sr: support (un)block events
Date: Fri,  9 Nov 2012 14:52:00 +0800
Message-ID: <1352443922-13734-9-git-send-email-aaron.lu@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
List-Id: linux-scsi@vger.kernel.org

2 interfaces are added to block/unblock events for the disk sr manages.
This is used by SATA ZPODD, when ODD is runtime powered off, the events
poll is no longer needed so better be blocked. And once powered on,
events poll will be unblocked.

These 2 interfaces are needed here because SATA layer does not have
access to the gendisk structure sr manages.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/scsi/Makefile   |  1 +
 drivers/scsi/sr_zpodd.c | 21 +++++++++++++++++++++
 drivers/scsi/sr_zpodd.h |  9 +++++++++
 3 files changed, 31 insertions(+)
 create mode 100644 drivers/scsi/sr_zpodd.c
 create mode 100644 drivers/scsi/sr_zpodd.h

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 888f73a..474efe2 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -177,6 +177,7 @@ sd_mod-objs	:= sd.o
 sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
 
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
+sr_mod-$(CONFIG_SATA_ZPODD) += sr_zpodd.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
 		:= -DCONFIG_NCR53C8XX_PREFETCH -DSCSI_NCR_BIG_ENDIAN \
 			-DCONFIG_SCSI_NCR53C8XX_NO_WORD_TRANSFERS
diff --git a/drivers/scsi/sr_zpodd.c b/drivers/scsi/sr_zpodd.c
new file mode 100644
index 0000000..0686e8c
--- /dev/null
+++ b/drivers/scsi/sr_zpodd.c
@@ -0,0 +1,21 @@
+#include <linux/module.h>
+#include <linux/genhd.h>
+#include <linux/cdrom.h>
+#include "sr.h"
+
+bool sr_block_events(struct device *dev)
+{
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+	if (cd)
+		return disk_try_block_events(cd->disk);
+	return false;
+}
+EXPORT_SYMBOL(sr_block_events);
+
+void sr_unblock_events(struct device *dev)
+{
+	struct scsi_cd *cd = dev_get_drvdata(dev);
+	if (cd)
+		disk_unblock_events(cd->disk);
+}
+EXPORT_SYMBOL(sr_unblock_events);
diff --git a/drivers/scsi/sr_zpodd.h b/drivers/scsi/sr_zpodd.h
new file mode 100644
index 0000000..49c6a55
--- /dev/null
+++ b/drivers/scsi/sr_zpodd.h
@@ -0,0 +1,9 @@
+#ifndef __SR_ZPODD_H__
+#define __SR_ZPODD_H__
+
+#include <linux/device.h>
+
+extern bool sr_block_events(struct device *dev);
+extern void sr_unblock_events(struct device *dev);
+
+#endif
-- 
1.7.12.4

