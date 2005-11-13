From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/4] scsi: make proc_name sysfs attribute conditional
Date: Sun, 13 Nov 2005 17:18:23 +0100 (CET)
Message-ID: <200511131620.jADGKgwQ032157@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56791 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S964927AbVKMQUx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 11:20:53 -0500
Received: from s5r6.in-berlin.de ([83.221.230.151])
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id jADGKgwQ032157
	for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2005 17:20:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

scsi_sysfs: provide attribute proc_name in a host's class device only if
CONFIG_SCSI_PROC_FS is set

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/scsi/scsi_sysfs.c |    4 ++++
 1 files changed, 4 insertions(+)

--- linux-2.6.14-git3/drivers/scsi/scsi_sysfs.c.orig	2005-10-28 02:02:08.000000000 +0200
+++ linux-2.6.14-git3/drivers/scsi/scsi_sysfs.c	2005-11-13 16:45:51.000000000 +0100
@@ -192,7 +192,9 @@ shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
+#ifdef CONFIG_SCSI_PROC_FS
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
+#endif
 
 static struct class_device_attribute *scsi_sysfs_shost_attrs[] = {
 	&class_device_attr_unique_id,
@@ -200,7 +202,9 @@ static struct class_device_attribute *sc
 	&class_device_attr_cmd_per_lun,
 	&class_device_attr_sg_tablesize,
 	&class_device_attr_unchecked_isa_dma,
+#ifdef CONFIG_SCSI_PROC_FS
 	&class_device_attr_proc_name,
+#endif
 	&class_device_attr_scan,
 	&class_device_attr_state,
 	NULL


