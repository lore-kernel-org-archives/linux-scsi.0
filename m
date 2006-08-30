From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [SCSI] add shared tag map helpers
Date: Wed, 30 Aug 2006 09:45:51 -0400
Message-ID: <1156945551.3735.17.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:60861 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751051AbWH3Npv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Aug 2006 09:45:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Ed Lin <ed.lin@promise.com>, Jens Axboe <axboe@suse.de>

This patch adds support for sharing tag maps at the host level
(i.e. either every queue [LUN] has its own tag map or there's a single
one for the entire host).  This formulation is primarily intended to
help single issue queue hardware, like the aic7xxx


Index: BUILD-2.6/include/scsi/scsi_host.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_host.h	2006-08-08 15:58:43.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi_host.h	2006-08-08 16:02:05.000000000 -0500
@@ -16,6 +16,7 @@
 struct Scsi_Host;
 struct scsi_host_cmd_pool;
 struct scsi_transport_template;
+struct blk_queue_tags;
 
 
 /*
@@ -466,6 +467,12 @@
 	struct scsi_transport_template *transportt;
 
 	/*
+	 * area to keep a shared tag map (if needed, will be
+	 * NULL if not)
+	 */
+	struct blk_queue_tag	*bqt;
+
+	/*
 	 * The following two fields are protected with host_lock;
 	 * however, eh routines can safely access during eh processing
 	 * without acquiring the lock.
Index: BUILD-2.6/include/scsi/scsi_tcq.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi_tcq.h	2006-08-08 15:58:48.000000000 -0500
+++ BUILD-2.6/include/scsi/scsi_tcq.h	2006-08-08 16:03:37.000000000 -0500
@@ -4,6 +4,7 @@
 #include <linux/blkdev.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
 
 
 #define MSG_SIMPLE_TAG	0x20
@@ -66,7 +67,8 @@
 		return;
 
 	if (!blk_queue_tagged(sdev->request_queue))
-		blk_queue_init_tags(sdev->request_queue, depth, NULL);
+		blk_queue_init_tags(sdev->request_queue, depth,
+				    sdev->host->bqt);
 
 	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
 }
@@ -131,4 +133,14 @@
 	return sdev->current_cmnd;
 }
 
+/**
+ * scsi_init_shared_tag_map - create a shared tag map
+ * @shost:	the host to share the tag map among all devices
+ * @depth:	the total depth of the map
+ */
+static inline void scsi_init_shared_tag_map(struct Scsi_Host *shost, int depth)
+{
+	shost->bqt = blk_init_tags(depth);
+}
+
 #endif /* _SCSI_SCSI_TCQ_H */
Index: BUILD-2.6/drivers/scsi/hosts.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/hosts.c	2006-08-08 15:59:47.000000000 -0500
+++ BUILD-2.6/drivers/scsi/hosts.c	2006-08-08 16:00:33.000000000 -0500
@@ -265,6 +265,9 @@
 		destroy_workqueue(shost->work_q);
 
 	scsi_destroy_command_freelist(shost);
+	if (shost->bqt)
+		blk_free_tags(shost->bqt);
+
 	kfree(shost->shost_data);
 
 	if (parent)


