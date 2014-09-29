From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 30/38] scsi: Use real functions for logging
Date: Mon, 29 Sep 2014 13:58:59 +0200
Message-ID: <1411991947-130166-31-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbaI2L7R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:17 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Add functions for scmd_printk and sdev_prefix_printk
using dev_printk_string() instead of using macro magic.
And make sdev_printk() a wrapper for sdev_prefix_printk().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/Makefile       |  2 +-
 drivers/scsi/scsi_logging.c | 78 +++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h  | 20 ++++--------
 3 files changed, 86 insertions(+), 14 deletions(-)
 create mode 100644 drivers/scsi/scsi_logging.c

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 5f0d299..04aa1c4 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -165,7 +165,7 @@ scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
-scsi_mod-y			+= scsi_trace.o
+scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 
 hv_storvsc-y			:= storvsc_drv.o
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
new file mode 100644
index 0000000..8cdaddc
--- /dev/null
+++ b/drivers/scsi/scsi_logging.c
@@ -0,0 +1,78 @@
+/*
+ * scsi_logging.c
+ *
+ * Copyright (C) 2014 SUSE Linux Products GmbH
+ * Copyright (C) 2014 Hannes Reinecke <hare@suse.de>
+ *
+ * This file is released under the GPLv2
+ */
+
+#include <linux/kernel.h>
+#include <linux/seq_buf.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_dbg.h>
+
+#define SCSI_LOG_BUFSIZE 512
+
+static void sdev_format_header(struct seq_buf *s, struct scsi_device *sdev,
+			       const char *disk_name)
+{
+	struct device *dev = &sdev->sdev_gendev;
+
+	s->len = dev_printk_header(s->buffer, s->size, dev);
+	if (disk_name)
+		seq_buf_printf(s, "[%s] ", disk_name);
+}
+
+static int sdev_seq_printk(const char *level, struct scsi_device *sdev,
+			   struct seq_buf *s)
+{
+	int r;
+
+	r = dev_printk_string(level[1] - '0', &sdev->sdev_gendev,
+			      s->buffer, s->len);
+	s->len = 0;
+	return r;
+}
+
+int sdev_prefix_printk(const char *level, struct scsi_device *sdev,
+		       const char *name, const char *fmt, ...)
+{
+	va_list args;
+	char logbuf[SCSI_LOG_BUFSIZE];
+	struct seq_buf s;
+
+	if (!sdev)
+		return 0;
+
+	seq_buf_init(&s, logbuf, SCSI_LOG_BUFSIZE);
+	sdev_format_header(&s, sdev, name);
+	va_start(args, fmt);
+	seq_buf_vprintf(&s, fmt, args);
+	va_end(args);
+	return sdev_seq_printk(level, sdev, &s);
+}
+EXPORT_SYMBOL_GPL(sdev_prefix_printk);
+
+int scmd_printk(const char *level, struct scsi_cmnd *scmd,
+		const char *fmt, ...)
+{
+	struct gendisk *disk = scmd->request->rq_disk;
+	va_list args;
+	char logbuf[SCSI_LOG_BUFSIZE];
+	struct seq_buf s;
+
+	if (!scmd || scmd->cmnd == NULL)
+		return 0;
+
+	seq_buf_init(&s, logbuf, SCSI_LOG_BUFSIZE);
+	sdev_format_header(&s, scmd->device, disk ? disk->disk_name : NULL);
+	va_start(args, fmt);
+	seq_buf_vprintf(&s, fmt, args);
+	va_end(args);
+	return sdev_seq_printk(level, scmd->device, &s);
+}
+EXPORT_SYMBOL_GPL(scmd_printk);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 0b18a09..056700b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -238,9 +238,6 @@ struct scsi_dh_data {
 #define transport_class_to_sdev(class_dev) \
 	to_scsi_device(class_dev->parent)
 
-#define sdev_printk(prefix, sdev, fmt, a...)	\
-	dev_printk(prefix, &(sdev)->sdev_gendev, fmt, ##a)
-
 #define sdev_dbg(sdev, fmt, a...) \
 	dev_dbg(&(sdev)->sdev_gendev, fmt, ##a)
 
@@ -248,16 +245,13 @@ struct scsi_dh_data {
  * like scmd_printk, but the device name is passed in
  * as a string pointer
  */
-#define sdev_prefix_printk(l, sdev, p, fmt, a...)			\
-	(p) ?								\
-	sdev_printk(l, sdev, "[%s] " fmt, p, ##a) :			\
-	sdev_printk(l, sdev, fmt, ##a)
-
-#define scmd_printk(prefix, scmd, fmt, a...)				\
-        (scmd)->request->rq_disk ?					\
-	sdev_printk(prefix, (scmd)->device, "[%s] " fmt,		\
-		    (scmd)->request->rq_disk->disk_name, ##a) :		\
-	sdev_printk(prefix, (scmd)->device, fmt, ##a)
+extern int sdev_prefix_printk(const char *, struct scsi_device *,
+			      const char *, const char *, ...);
+
+#define sdev_printk(l, sdev, fmt, a...)				\
+	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
+
+extern int scmd_printk(const char *, struct scsi_cmnd *, const char *, ...);
 
 #define scmd_dbg(scmd, fmt, a...)					   \
 	do {								   \
-- 
1.8.5.2

