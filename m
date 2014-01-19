From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 7/7] scsi_debug: add ability to enable clustering
Date: Sun, 19 Jan 2014 22:51:43 +0900
Message-ID: <1390139503-11519-8-git-send-email-akinobu.mita@gmail.com>
References: <1390139503-11519-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:61792 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaASNwG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jan 2014 08:52:06 -0500
Received: by mail-pa0-f41.google.com with SMTP id fa1so3653469pad.28
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jan 2014 05:52:05 -0800 (PST)
In-Reply-To: <1390139503-11519-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

This adds a module parameter to enable clustering.

Without enabling clustering support, the transfer length for read and
write scsi commands is limited upto 8MB when page size is 4KB and
sg_tablesize is 2048 (= SCSI_MAX_SG_CHAIN_SEGMENTS).  I would like to
test commands with more than that transfer length.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
Change from previous version:
- make clustering module parameter writable

 drivers/scsi/scsi_debug.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0bb1d49c..f3e9cc0 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -196,6 +196,7 @@ static unsigned int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
 static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static unsigned int scsi_debug_write_same_length = DEF_WRITESAME_LENGTH;
 static bool scsi_debug_removable = DEF_REMOVABLE;
+static bool scsi_debug_clustering;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -2762,6 +2763,7 @@ static int schedule_resp(struct scsi_cmnd * cmnd,
  */
 module_param_named(add_host, scsi_debug_add_host, int, S_IRUGO | S_IWUSR);
 module_param_named(ato, scsi_debug_ato, int, S_IRUGO);
+module_param_named(clustering, scsi_debug_clustering, bool, S_IRUGO | S_IWUSR);
 module_param_named(delay, scsi_debug_delay, int, S_IRUGO | S_IWUSR);
 module_param_named(dev_size_mb, scsi_debug_dev_size_mb, int, S_IRUGO);
 module_param_named(dif, scsi_debug_dif, int, S_IRUGO);
@@ -2805,6 +2807,7 @@ MODULE_VERSION(SCSI_DEBUG_VERSION);
 
 MODULE_PARM_DESC(add_host, "0..127 hosts allowed(def=1)");
 MODULE_PARM_DESC(ato, "application tag ownership: 0=disk 1=host (def=1)");
+MODULE_PARM_DESC(clustering, "when set enables larger transfers (def=0)");
 MODULE_PARM_DESC(delay, "# of jiffies to delay response(def=1)");
 MODULE_PARM_DESC(dev_size_mb, "size in MB of ram shared by devs(def=8)");
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
@@ -3952,6 +3955,8 @@ static int sdebug_driver_probe(struct device * dev)
 	sdbg_host = to_sdebug_host(dev);
 
 	sdebug_driver_template.can_queue = scsi_debug_max_queue;
+	if (scsi_debug_clustering)
+		sdebug_driver_template.use_clustering = ENABLE_CLUSTERING;
 	hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
 	if (NULL == hpnt) {
 		printk(KERN_ERR "%s: scsi_register failed\n", __func__);
-- 
1.8.3.2

