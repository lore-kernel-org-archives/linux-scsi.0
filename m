From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 2/5] add supported_mode and active_mode attributes
Date: Sat, 01 Sep 2007 02:02:20 +0900
Message-ID: <200708311702.l7VH2Le7015822@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:46995 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965391AbXHaRCp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Aug 2007 13:02:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, James.Smart@Emulex.Com, andrew.vasquez@qlogic.com, hare@suse.de, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp

This adds supported_mode and active_mode attributes to
/sys/class/sys_host/hostX/ for specifying the mode that a lld supports
and the currently activated mode. The output format is similar to fc
rport roles:

luce:/sys/class/scsi_host/host0$ cat supported_mode
Initiator
luce:/sys/class/scsi_host/host0$ cat active_mode
Initiator

The mode values uses bitmap since we would support dual-mode llds in
the future like this:

luce:/sys/class/scsi_host/host0$ cat supported_mode
Initiator, Target

The supported_mode attribute looks at a scsi_host_template and the
active_mode attribute looks at a scsi_host. We would add a hook to a
scsi_host_template to change the active_mode attribute
dynamically. But now there is no hook since no lld supports that
feature.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/hosts.c      |    1 +
 drivers/scsi/scsi_sysfs.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_host.h  |    9 +++++++++
 3 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 96bc312..adc9559 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -342,6 +342,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
 	shost->ordered_tag = sht->ordered_tag;
+	shost->active_mode = sht->supported_mode;
 
 	if (sht->max_host_blocked)
 		shost->max_host_blocked = sht->max_host_blocked;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 34cdce6..a3d227f 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -190,6 +190,46 @@ show_shost_state(struct class_device *class_dev, char *buf)
 
 static CLASS_DEVICE_ATTR(state, S_IRUGO | S_IWUSR, show_shost_state, store_shost_state);
 
+static ssize_t
+show_shost_mode(unsigned int mode, char *buf)
+{
+	ssize_t len = 0;
+
+	if (mode & MODE_INITIATOR)
+		len = sprintf(buf, "%s", "Initiator");
+
+	if (mode & MODE_TARGET)
+		len += sprintf(buf + len, "%s%s", len ? ", " : "", "Target");
+
+	len += sprintf(buf + len, "\n");
+
+	return len;
+}
+
+static ssize_t show_shost_supported_mode(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+
+	if (shost->hostt->supported_mode == MODE_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+	else
+		return show_shost_mode(shost->hostt->supported_mode, buf);
+}
+
+static CLASS_DEVICE_ATTR(supported_mode, S_IRUGO | S_IWUSR, show_shost_supported_mode, NULL);
+
+static ssize_t show_shost_active_mode(struct class_device *class_dev, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(class_dev);
+
+	if (shost->active_mode == MODE_UNKNOWN)
+		return snprintf(buf, 20, "unknown\n");
+	else
+		return show_shost_mode(shost->active_mode, buf);
+}
+
+static CLASS_DEVICE_ATTR(active_mode, S_IRUGO | S_IWUSR, show_shost_active_mode, NULL);
+
 shost_rd_attr(unique_id, "%u\n");
 shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
@@ -208,6 +248,8 @@ static struct class_device_attribute *scsi_sysfs_shost_attrs[] = {
 	&class_device_attr_proc_name,
 	&class_device_attr_scan,
 	&class_device_attr_state,
+	&class_device_attr_supported_mode,
+	&class_device_attr_active_mode,
 	NULL
 };
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 88f6871..5b79697 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -32,6 +32,9 @@ struct blk_queue_tags;
 #define SG_NONE 0
 #define SG_ALL 0xff
 
+#define MODE_UNKNOWN 0x00
+#define MODE_INITIATOR 0x01
+#define MODE_TARGET 0x02
 
 #define DISABLE_CLUSTERING 0
 #define ENABLE_CLUSTERING 1
@@ -405,6 +408,11 @@ struct scsi_host_template {
 	unsigned char present;
 
 	/*
+	 * This specifies the mode that a LLD supports.
+	 */
+	unsigned supported_mode:2;
+
+	/*
 	 * true if this host adapter uses unchecked DMA onto an ISA bus.
 	 */
 	unsigned unchecked_isa_dma:1;
@@ -574,6 +582,7 @@ struct Scsi_Host {
 	 */
 	unsigned long cmd_serial_number, cmd_pid; 
 	
+	unsigned active_mode:2;
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
 	unsigned use_blk_tcq:1;
-- 
1.5.2.4

