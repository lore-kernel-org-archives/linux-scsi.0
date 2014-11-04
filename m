From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/10] scsi: Use real functions for logging
Date: Tue,  4 Nov 2014 09:06:40 +0100
Message-ID: <1415088409-46590-2-git-send-email-hare@suse.de>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682AbaKDIGy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 03:06:54 -0500
In-Reply-To: <1415088409-46590-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Implement a per-cpu buffer for formatting messages,
and add real functions for scmd_printk and sdev_prefix_printk
using that buffer and use dev_printk() to print out things.
And make sdev_printk() a wrapper for sdev_prefix_printk().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/Makefile       |   2 +-
 drivers/scsi/scsi_logging.c | 119 ++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h  |  21 +++-----
 3 files changed, 128 insertions(+), 14 deletions(-)
 create mode 100644 drivers/scsi/scsi_logging.c

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 59f1ce6..4991b62 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -166,7 +166,7 @@ scsi_mod-y			+= scsi_scan.o scsi_sysfs.o scsi_devinfo.o
 scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_netlink.o
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
-scsi_mod-y			+= scsi_trace.o
+scsi_mod-y			+= scsi_trace.o scsi_logging.o
 scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 
 hv_storvsc-y			:= storvsc_drv.o
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
new file mode 100644
index 0000000..4a76796
--- /dev/null
+++ b/drivers/scsi/scsi_logging.c
@@ -0,0 +1,119 @@
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
+#include <linux/atomic.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_dbg.h>
+
+#define SCSI_LOG_SPOOLSIZE 4096
+#define SCSI_LOG_BUFSIZE 128
+
+struct scsi_log_buf {
+	char buffer[SCSI_LOG_SPOOLSIZE];
+	unsigned long map;
+};
+
+static DEFINE_PER_CPU(struct scsi_log_buf, scsi_format_log);
+
+static char *scsi_log_reserve_buffer(size_t *len)
+{
+	struct scsi_log_buf *buf;
+	unsigned long map_bits = SCSI_LOG_SPOOLSIZE / SCSI_LOG_BUFSIZE;
+	unsigned long idx = 0;
+
+	WARN_ON(map_bits > BITS_PER_LONG);
+	preempt_disable();
+	buf = this_cpu_ptr(&scsi_format_log);
+	idx = find_first_zero_bit(&buf->map, map_bits);
+	while (test_and_set_bit(idx, &buf->map)) {
+		idx = find_next_zero_bit(&buf->map, map_bits, idx);
+		if (idx >= map_bits) {
+			break;
+		}
+	}
+	if (WARN_ON(idx >= map_bits)) {
+		preempt_enable();
+		return NULL;
+	}
+	*len = SCSI_LOG_BUFSIZE;
+	return buf->buffer + idx * SCSI_LOG_BUFSIZE;
+}
+
+static void scsi_log_release_buffer(char *bufptr)
+{
+	struct scsi_log_buf *buf;
+	unsigned long idx;
+	int ret;
+
+	buf = this_cpu_ptr(&scsi_format_log);
+	if (bufptr < buf->buffer + SCSI_LOG_SPOOLSIZE) {
+		idx = (bufptr - buf->buffer) / SCSI_LOG_BUFSIZE;
+		ret = test_and_clear_bit(idx, &buf->map);
+		WARN_ON(!ret);
+	}
+	preempt_enable();
+}
+
+int sdev_prefix_printk(const char *level, const struct scsi_device *sdev,
+		       const char *name, const char *fmt, ...)
+{
+	va_list args;
+	char *logbuf;
+	size_t off = 0, logbuf_len;
+	int ret;
+
+	if (!sdev)
+		return 0;
+
+	logbuf = scsi_log_reserve_buffer(&logbuf_len);
+	if (!logbuf)
+		return 0;
+
+	if (name)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "[%s] ", name);
+	va_start(args, fmt);
+	off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
+	va_end(args);
+	ret = dev_printk(level, &sdev->sdev_gendev, "%s", logbuf);
+	scsi_log_release_buffer(logbuf);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sdev_prefix_printk);
+
+int scmd_printk(const char *level, const struct scsi_cmnd *scmd,
+		const char *fmt, ...)
+{
+	struct gendisk *disk = scmd->request->rq_disk;
+	va_list args;
+	char *logbuf;
+	size_t off = 0, logbuf_len;
+	int ret;
+
+	if (!scmd || scmd->cmnd == NULL)
+		return 0;
+
+	logbuf = scsi_log_reserve_buffer(&logbuf_len);
+	if (!logbuf)
+		return 0;
+	if (disk)
+		off += scnprintf(logbuf + off, logbuf_len - off,
+				 "[%s] ", disk->disk_name);
+	va_start(args, fmt);
+	off += vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
+	va_end(args);
+	ret = dev_printk(level, &scmd->device->sdev_gendev, "%s", logbuf);
+	scsi_log_release_buffer(logbuf);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scmd_printk);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 0b18a09..daa62df 100644
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
 
@@ -248,16 +245,14 @@ struct scsi_dh_data {
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
+extern int sdev_prefix_printk(const char *, const struct scsi_device *,
+			      const char *, const char *, ...);
+
+#define sdev_printk(l, sdev, fmt, a...)				\
+	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
+
+extern int scmd_printk(const char *, const struct scsi_cmnd *,
+		       const char *, ...);
 
 #define scmd_dbg(scmd, fmt, a...)					   \
 	do {								   \
-- 
1.8.5.2

