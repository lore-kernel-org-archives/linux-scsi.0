From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 6/6] scsi_debug: add ability to enable clustering
Date: Mon,  6 Jan 2014 08:33:12 +0900
Message-ID: <1388964792-3546-7-git-send-email-akinobu.mita@gmail.com>
References: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33886 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaAEXdg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2014 18:33:36 -0500
Received: by mail-pd0-f174.google.com with SMTP id x10so17528390pdj.33
        for <linux-scsi@vger.kernel.org>; Sun, 05 Jan 2014 15:33:36 -0800 (PST)
In-Reply-To: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
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
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index aca70c1..9297688d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -196,6 +196,7 @@ static unsigned int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
 static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static unsigned int scsi_debug_write_same_length = DEF_WRITESAME_LENGTH;
 static bool scsi_debug_removable = DEF_REMOVABLE;
+static bool scsi_debug_clustering;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -2787,6 +2788,7 @@ module_param_named(opts, scsi_debug_opts, int, S_IRUGO | S_IWUSR);
 module_param_named(physblk_exp, scsi_debug_physblk_exp, int, S_IRUGO);
 module_param_named(ptype, scsi_debug_ptype, int, S_IRUGO | S_IWUSR);
 module_param_named(removable, scsi_debug_removable, bool, S_IRUGO | S_IWUSR);
+module_param_named(clustering, scsi_debug_clustering, bool, S_IRUGO);
 module_param_named(scsi_level, scsi_debug_scsi_level, int, S_IRUGO);
 module_param_named(sector_size, scsi_debug_sector_size, int, S_IRUGO);
 module_param_named(unmap_alignment, scsi_debug_unmap_alignment, int, S_IRUGO);
@@ -3953,6 +3955,8 @@ static int sdebug_driver_probe(struct device * dev)
 	sdbg_host = to_sdebug_host(dev);
 
 	sdebug_driver_template.can_queue = scsi_debug_max_queue;
+	if (scsi_debug_clustering)
+		sdebug_driver_template.use_clustering = ENABLE_CLUSTERING;
 	hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
 	if (NULL == hpnt) {
 		printk(KERN_ERR "%s: scsi_register failed\n", __func__);
-- 
1.8.3.2

