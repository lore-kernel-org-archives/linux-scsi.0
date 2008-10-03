From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 4/8] dm core: add target interfaces for
	request-based dm
Date: Fri, 03 Oct 2008 11:18:18 -0400 (EDT)
Message-ID: <20081003.111818.78704870.k-ueda@ct.jp.nec.com>
References: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: k-ueda@ct.jp.nec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, mbroz@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch adds the following target interfaces for request-based dm.

  map_rq    : for mapping a request

  rq_end_io : for finishing a request

  busy      : for avoiding performance regression from bio-based dm.
              Target can tell dm core not to map requests now, and
              that may help requests in the block layer queue to be
              bigger by I/O merging.
              In bio-based dm, this behavior is done by device
              drivers which managing the block layer queue.
              But in request-based dm, dm core has to do that
              since dm core manages the block layer queue, and
              target drivers help is needed for it.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 include/linux/device-mapper.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+)

Index: 2.6.27-rc8/include/linux/device-mapper.h
===================================================================
--- 2.6.27-rc8.orig/include/linux/device-mapper.h
+++ 2.6.27-rc8/include/linux/device-mapper.h
@@ -45,6 +45,8 @@ typedef void (*dm_dtr_fn) (struct dm_tar
  */
 typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
 			  union map_info *map_context);
+typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clone,
+				  union map_info *map_context);
 
 /*
  * Returns:
@@ -57,6 +59,9 @@ typedef int (*dm_map_fn) (struct dm_targ
 typedef int (*dm_endio_fn) (struct dm_target *ti,
 			    struct bio *bio, int error,
 			    union map_info *map_context);
+typedef int (*dm_request_endio_fn) (struct dm_target *ti,
+				    struct request *clone, int error,
+				    union map_info *map_context);
 
 typedef void (*dm_flush_fn) (struct dm_target *ti);
 typedef void (*dm_presuspend_fn) (struct dm_target *ti);
@@ -76,6 +81,13 @@ typedef int (*dm_ioctl_fn) (struct dm_ta
 typedef int (*dm_merge_fn) (struct dm_target *ti, struct bvec_merge_data *bvm,
 			    struct bio_vec *biovec, int max_size);
 
+/*
+ * Returns:
+ *    0: The target can handle the next I/O immediately.
+ *    1: The target can't handle the next I/O immediately.
+ */
+typedef int (*dm_busy_fn) (struct dm_target *ti);
+
 void dm_error(const char *message);
 
 /*
@@ -108,7 +120,9 @@ struct target_type {
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
 	dm_map_fn map;
+	dm_map_request_fn map_rq;
 	dm_endio_fn end_io;
+	dm_request_endio_fn rq_end_io;
 	dm_flush_fn flush;
 	dm_presuspend_fn presuspend;
 	dm_postsuspend_fn postsuspend;
@@ -118,6 +132,7 @@ struct target_type {
 	dm_message_fn message;
 	dm_ioctl_fn ioctl;
 	dm_merge_fn merge;
+	dm_busy_fn busy;
 };
 
 struct io_restrictions {
