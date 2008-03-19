From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [RFC PATCH 08/13] dm: add target interfaces
Date: Wed, 19 Mar 2008 18:10:37 -0500 (EST)
Message-ID: <20080319.181037.78496647.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, michaelc@cs.wisc.edu, hare@suse.de, agk@redhat.com, linux-kernel@vger.kernel.org
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds target interfaces for request-based dm.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 include/linux/device-mapper.h |   12 ++++++++++++
 1 files changed, 12 insertions(+)

Index: 2.6.25-rc5/include/linux/device-mapper.h
===================================================================
--- 2.6.25-rc5.orig/include/linux/device-mapper.h
+++ 2.6.25-rc5/include/linux/device-mapper.h
@@ -10,6 +10,7 @@
 
 #ifdef __KERNEL__
 
+struct request;
 struct dm_target;
 struct dm_table;
 struct dm_dev;
@@ -45,6 +46,9 @@ typedef void (*dm_dtr_fn) (struct dm_tar
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
 			  union map_info *map_context);
 
+typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clone,
+				  union map_info *map_context);
+
 /*
  * Returns:
  * < 0 : error (currently ignored)
@@ -57,6 +61,10 @@ typedef int (*dm_endio_fn) (struct dm_ta
 			    struct bio *bio, int error,
 			    union map_info *map_context);
 
+typedef int (*dm_request_endio_fn) (struct dm_target *ti,
+				    struct request *clone, int error,
+				    union map_info *map_context);
+
 typedef void (*dm_flush_fn) (struct dm_target *ti);
 typedef void (*dm_presuspend_fn) (struct dm_target *ti);
 typedef void (*dm_postsuspend_fn) (struct dm_target *ti);
@@ -71,6 +79,7 @@ typedef int (*dm_message_fn) (struct dm_
 typedef int (*dm_ioctl_fn) (struct dm_target *ti, struct inode *inode,
 			    struct file *filp, unsigned int cmd,
 			    unsigned long arg);
+typedef int (*dm_congested_fn) (struct dm_target *ti);
 
 void dm_error(const char *message);
 
@@ -98,7 +107,9 @@ struct target_type {
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
 	dm_map_fn map;
+	dm_map_request_fn map_rq;
 	dm_endio_fn end_io;
+	dm_request_endio_fn rq_end_io;
 	dm_flush_fn flush;
 	dm_presuspend_fn presuspend;
 	dm_postsuspend_fn postsuspend;
@@ -107,6 +118,7 @@ struct target_type {
 	dm_status_fn status;
 	dm_message_fn message;
 	dm_ioctl_fn ioctl;
+	dm_congested_fn congested;
 };
 
 struct io_restrictions {
