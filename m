Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF20DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 01:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243622AbiDABCX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 21:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiDABCW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 21:02:22 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D421C60D1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 18:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1648774833; x=1680310833;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=9FIoi26RXwErvEU/wauSRvD7JVHGVUCaTelRCujrnAM=;
  b=DaUbpZII5JSxG5/SFmVmmAGJoUPfyQwPZhVbjZfv+eUGm4UhF1IUtyth
   /28j6NjoOgHFrn80q05pCWVOkFJWCk/AYaiJ1J5It2z3FYO5BtSGRf9H7
   RK2HvTA8lTxrfIw4QKcv8Oyno5F6xFSekh+iU8SQMPSwlUWKRjt+z9bw3
   o=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 31 Mar 2022 18:00:32 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 18:00:32 -0700
Received: from jianguos-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 31 Mar 2022 18:00:31 -0700
From:   Jianguo Sun <quic_jianguos@quicinc.com>
To:     <linux-scsi@vger.kernel.org>
CC:     Jianguo Sun <quic_jianguos@quicinc.com>
Subject: [PATCH] drivers: scsi: alloc scsi disk ida index before adding scsi device
Date:   Fri, 1 Apr 2022 08:59:28 +0800
Message-ID: <20220401005928.24140-1-quic_jianguos@quicinc.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Originally, we alloc ida index in scsi driver(sd_probe) asynchronously,
which may cause disk name out of order and in turn cause rootfs mount
issue if we set specific disk mount as the root filesystem by parameters
"root=/dev/sda6", for example.
Since the scsi device gets added in sequence, so we change to alloc ida
index for scsi disk before adding scsi device.

Signed-off-by: Jianguo Sun <quic_jianguos@quicinc.com>
---
 drivers/scsi/scsi_sysfs.c  | 14 ++++++++++++++
 drivers/scsi/sd.c          | 36 ++++++++++++++++++++++++------------
 include/scsi/scsi_device.h |  1 +
 3 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 226a50944c00..7682e31ecd58 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
+#include <linux/idr.h>
 #include <linux/blkdev.h>
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
@@ -28,6 +29,8 @@
 #include "scsi_logging.h"
 
 static struct device_type scsi_dev_type;
+extern struct ida sd_index_ida;
+extern bool is_sd_type_supported(struct scsi_device *sdp);
 
 static const struct {
 	enum scsi_device_state	value;
@@ -1363,6 +1366,17 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 
 	scsi_dh_add_device(sdev);
 
+	/**
+	 * Originally, we alloc ida index in scsi driver(sd_probe) asynchronously,
+	 * which may cause disk name out of order and in turn cause rootfs mount
+	 * issue if we set specific disk mount as the root filesystem by parameters
+	 * "root=/dev/sda6", for example.
+	 * Since the scsi device gets added in sequence, so we change to alloc ida
+	 * index for scsi disk before adding scsi device.
+	 **/
+	if (is_sd_type_supported(sdev))
+		sdev->sd_index = ida_alloc(&sd_index_ida, GFP_KERNEL);
+
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
 		sdev_printk(KERN_INFO, sdev,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a390679cf458..8c39280f0eeb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -119,7 +119,7 @@ static int sd_eh_action(struct scsi_cmnd *, int);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct device *cdev);
 
-static DEFINE_IDA(sd_index_ida);
+DEFINE_IDA(sd_index_ida);
 
 static struct kmem_cache *sd_cdb_cache;
 static mempool_t *sd_page_pool;
@@ -3346,6 +3346,26 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 	return 0;
 }
 
+inline bool is_sd_type_supported(struct scsi_device *sdp)
+{
+	bool ret = false;
+
+	sdev_printk(KERN_DEBUG, sdp,
+			"sdp->type: 0x%x\n", sdp->type);
+
+#ifndef CONFIG_BLK_DEV_ZONED
+	if (sdp->type == TYPE_ZBC)
+		ret = false;
+#endif
+	if (sdp->type == TYPE_DISK ||
+	    sdp->type == TYPE_ZBC ||
+	    sdp->type == TYPE_MOD ||
+	    sdp->type == TYPE_RBC)
+		ret = true;
+
+	return ret;
+}
+
 /**
  *	sd_probe - called during driver initialization and whenever a
  *	new scsi device is attached to the system. It is called once
@@ -3374,18 +3394,9 @@ static int sd_probe(struct device *dev)
 
 	scsi_autopm_get_device(sdp);
 	error = -ENODEV;
-	if (sdp->type != TYPE_DISK &&
-	    sdp->type != TYPE_ZBC &&
-	    sdp->type != TYPE_MOD &&
-	    sdp->type != TYPE_RBC)
+	if (!is_sd_type_supported(sdp))
 		goto out;
 
-	if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) && sdp->type == TYPE_ZBC) {
-		sdev_printk(KERN_WARNING, sdp,
-			    "Unsupported ZBC host-managed device.\n");
-		goto out;
-	}
-
 	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp,
 					"sd_probe\n"));
 
@@ -3399,7 +3410,7 @@ static int sd_probe(struct device *dev)
 	if (!gd)
 		goto out_free;
 
-	index = ida_alloc(&sd_index_ida, GFP_KERNEL);
+	index = sdp->sd_index;
 	if (index < 0) {
 		sdev_printk(KERN_WARNING, sdp, "sd_probe: memory exhausted.\n");
 		goto out_put;
@@ -3410,6 +3421,7 @@ static int sd_probe(struct device *dev)
 		sdev_printk(KERN_WARNING, sdp, "SCSI disk (sd) name length exceeded.\n");
 		goto out_free_index;
 	}
+	sdev_printk(KERN_INFO, sdp, "sd_probe: index %d, [%s]\n", index, gd->disk_name);
 
 	sdkp->device = sdp;
 	sdkp->disk = gd;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 57e3e239a1fc..23b52481b84c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -246,6 +246,7 @@ struct scsi_device {
 	enum scsi_device_state sdev_state;
 	struct task_struct	*quiesced_by;
 	unsigned long		sdev_data[];
+	long			sd_index; /* scsi disk index */
 } __attribute__((aligned(sizeof(unsigned long))));
 
 #define	to_scsi_device(d)	\
-- 
2.17.1

