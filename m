From: michaelc@cs.wisc.edu
Subject: [PATCH 1/7] scsi-hw-handler: add REQ_LB_OP_TRANSITION
	and errors
Date: Sat, 09 Jun 2007 14:07:58 -0500
Message-ID: <11814160853812-git-send-email-michaelc@cs.wisc.edu>
References: <11814160842916-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu,
	device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <11814160842916-git-send-email-michaelc@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-scsi@vger.kernel.org, dm-devel@redhat.com
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds REQ_LB_OP_TRANSITION which is a REQ_TYPE_LINUX_BLOCK
type of command. It also adds the error codes which are used by
REQ_LB_OP_TRANSITION to blkdev.h.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/ll_rw_blk.c      |    2 +-
 include/linux/blkdev.h |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 6b5173a..c063792 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3396,7 +3396,7 @@ static int __end_that_request_first(stru
 	 * for a REQ_BLOCK_PC request, we want to carry any eventual
 	 * sense key with us all the way through
 	 */
-	if (!blk_pc_request(req))
+	if (!blk_pc_request(req) && !blk_linux_request(req))
 		req->errors = 0;
 
 	if (!uptodate) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index db5b00a..e02e208 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -175,8 +175,48 @@ enum {
 	 */
 	REQ_LB_OP_EJECT	= 0x40,		/* eject request */
 	REQ_LB_OP_FLUSH = 0x41,		/* flush device */
+	REQ_LB_OP_TRANSITION = 0x42,	/* failover/failback a device */
 };
 
+enum {
+	BLKERR_OK = 0,
+	/*
+	 * device errors
+	 */
+	BLKERR_DEV_FAILED,	/* generic device error */
+	BLKERR_DEV_TEMP_BUSY,
+	BLKERR_DEVICE_MAX,	/* max device blkerr definition */
+
+	/*
+	 * transport errors
+	 */
+	BLKERR_NOTCONN = BLKERR_DEVICE_MAX + 1,
+	BLKERR_CONN_FAILURE,
+	BLKERR_TRANSPORT_MAX,	/* max transport blkerr definition */
+
+	/*
+	 * driver and generic errors
+	 */
+	BLKERR_IO = BLKERR_TRANSPORT_MAX + 1,	/* generic error */
+	BLKERR_INVALID_IO,
+	BLKERR_RETRY,		/* retry the req, but not immediately */
+	BLKERR_IMM_RETRY,	/* immediately retry the req */
+	BLKERR_TIMED_OUT,
+	BLKERR_RES_TEMP_UNAVAIL,
+	BLKERR_DEV_OFFLINED,
+	BLKERR_NOSYS,
+	BLKERR_DRIVER_MAX,
+};
+
+#define blk_dev_err(_err) \
+	(_err > BLKERR_OK  && _err < BLKERR_DEVICE_MAX)
+
+ #define blkerr_transport_err(_err) \
+	(_err > BLKERR_DEVICE_MAX && _err < BLKERR_TRANSPORT_MAX)
+
+#define blkerr_driver_err(_err) \
+	(_err > BLKERR_TRANSPORT_MAX)
+
 /*
  * request type modified bits. first three bits match BIO_RW* bits, important
  */
@@ -529,6 +569,7 @@ #define blk_fs_request(rq)	((rq)->cmd_ty
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
 #define blk_special_request(rq)	((rq)->cmd_type == REQ_TYPE_SPECIAL)
 #define blk_sense_request(rq)	((rq)->cmd_type == REQ_TYPE_SENSE)
+#define blk_linux_request(rq)	((rq)->cmd_type == REQ_TYPE_LINUX_BLOCK)
 
 #define blk_noretry_request(rq)	((rq)->cmd_flags & REQ_FAILFAST)
 #define blk_rq_started(rq)	((rq)->cmd_flags & REQ_STARTED)
-- 
1.4.1.1
