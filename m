From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 29/38] Introduce dev_printk_string() and dev_printk_header()
Date: Mon, 29 Sep 2014 13:58:58 +0200
Message-ID: <1411991947-130166-30-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Introducing dev_printk_string() and dev_printk_header() to allow
using an external buffer for printing via dev_printk().

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/base/core.c    | 24 ++++++++++++++++++++++++
 include/linux/device.h | 12 ++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 20da3ad..e8aecf0 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2041,6 +2041,19 @@ create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
 	return pos;
 }
 
+int dev_printk_string(int level, const struct device *dev,
+		      char *msg, size_t msg_len)
+{
+	char hdr[128];
+	size_t hdrlen;
+
+	hdrlen = create_syslog_header(dev, hdr, sizeof(hdr));
+
+	return printk_emit_string(0, level, hdrlen ? hdr : NULL, hdrlen,
+				  msg, msg_len);
+}
+EXPORT_SYMBOL(dev_printk_string);
+
 int dev_vprintk_emit(int level, const struct device *dev,
 		     const char *fmt, va_list args)
 {
@@ -2068,6 +2081,17 @@ int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...)
 }
 EXPORT_SYMBOL(dev_printk_emit);
 
+int dev_printk_header(char *buf, size_t buf_len, const struct device *dev)
+{
+	size_t off = 0;
+
+	if (dev)
+		off = scnprintf(buf, buf_len, "%s %s: ",
+				dev_driver_string(dev), dev_name(dev));
+	return off;
+}
+EXPORT_SYMBOL(dev_printk_header);
+
 static int __dev_printk(const char *level, const struct device *dev,
 			struct va_format *vaf)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index 43d183a..47f3b62 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1025,6 +1025,9 @@ extern const char *dev_driver_string(const struct device *dev);
 
 #ifdef CONFIG_PRINTK
 
+int dev_printk_string(int level, const struct device *dev,
+		      char *msg, size_t msg_len);
+int dev_printk_header(char *buf, size_t buf_len, const struct device *dev);
 extern __printf(3, 0)
 int dev_vprintk_emit(int level, const struct device *dev,
 		     const char *fmt, va_list args);
@@ -1051,6 +1054,15 @@ int _dev_info(const struct device *dev, const char *fmt, ...);
 
 #else
 
+static inline
+int dev_printk_string(int level, const struct device *dev,
+		      char *msg, size_t msg_len)
+{ return 0; }
+
+static inline
+int dev_printk_header(char *buf, size_t buf_len, const struct device *dev)
+{ return 0; }
+
 static inline __printf(3, 0)
 int dev_vprintk_emit(int level, const struct device *dev,
 		     const char *fmt, va_list args)
-- 
1.8.5.2
