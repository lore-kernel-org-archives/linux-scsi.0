From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 08/13] dm: add target interfaces
Date: Fri, 15 Feb 2008 17:31:48 -0500 (EST)
Message-ID: <20080215.173148.63997298.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761111AbYBOWbn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:31:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch adds target interfaces for request-based dm.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 include/linux/device-mapper.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+)

Index: 2.6.25-rc1/include/linux/device-mapper.h
===================================================================
--- 2.6.25-rc1.orig/include/linux/device-mapper.h
+++ 2.6.25-rc1/include/linux/device-mapper.h
@@ -10,6 +10,8 @@
 
 #ifdef __KERNEL__
 
+struct request;
+struct request_queue;
 struct dm_target;
 struct dm_table;
 struct dm_dev;
@@ -45,6 +47,9 @@ typedef void (*dm_dtr_fn) (struct dm_tar
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
 			  union map_info *map_context);
 
+typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clone,
+				  union map_info *map_context);
+
 /*
  * Returns:
  * < 0 : error (currently ignored)
@@ -57,6 +62,18 @@ typedef int (*dm_endio_fn) (struct dm_ta
 			    struct bio *bio, int error,
 			    union map_info *map_context);
 
+typedef int (*dm_request_endio_first_fn) (struct dm_target *ti,
+					  struct request *clone, int error,
+					  union map_info *map_context);
+
+typedef int (*dm_request_endio_fn) (struct dm_target *ti,
+				    struct request *clone, int error,
+				    union map_info *map_context);
+
+typedef void (*dm_request_queue_in_tgt_fn) (struct dm_target *ti,
+					    struct request *clone,
+					    union map_info *map_context);
+
 typedef void (*dm_flush_fn) (struct dm_target *ti);
 typedef void (*dm_presuspend_fn) (struct dm_target *ti);
 typedef void (*dm_postsuspend_fn) (struct dm_target *ti);
@@ -71,6 +88,7 @@ typedef int (*dm_message_fn) (struct dm_
 typedef int (*dm_ioctl_fn) (struct dm_target *ti, struct inode *inode,
 			    struct file *filp, unsigned int cmd,
 			    unsigned long arg);
+typedef int (*dm_congested_fn) (struct dm_target *ti);
 
 void dm_error(const char *message);
 
@@ -98,7 +116,11 @@ struct target_type {
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
 	dm_map_fn map;
+	dm_map_request_fn map_rq;
 	dm_endio_fn end_io;
+	dm_request_endio_first_fn rq_end_io_first;
+	dm_request_endio_fn rq_end_io;
+	dm_request_queue_in_tgt_fn queue_in_tgt;
 	dm_flush_fn flush;
 	dm_presuspend_fn presuspend;
 	dm_postsuspend_fn postsuspend;
@@ -107,6 +129,7 @@ struct target_type {
 	dm_status_fn status;
 	dm_message_fn message;
 	dm_ioctl_fn ioctl;
+	dm_congested_fn congested;
 };
 
 struct io_restrictions {
