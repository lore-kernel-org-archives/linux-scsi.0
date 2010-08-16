From: Tejun Heo <tj@kernel.org>
Subject: [PATCH UPDATED 10/11] fs, block: propagate REQ_FLUSH/FUA interface
 to upper layers
Date: Mon, 16 Aug 2010 18:33:22 +0200
Message-ID: <4C696852.1080709@kernel.org>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-11-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1281616891-5691-11-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Propagate deprecation of REQ_HARDBARRIER and new REQ_FLUSH/FUA
interface to upper layers.

* WRITE_BARRIER is marked deprecated and WRITE_FLUSH, WRITE_FUA and
  WRITE_FLUSH_FUA are added.

* REQ_COMMON_MASK now includes REQ_FLUSH | REQ_FUA so that they are
  copied from bio to request.

* BH_Ordered and BH_Eopnotsupp are marked deprecated.  BH_Flush/FUA
  are _NOT_ added as they can and should be specified when calling
  submit_bh() as @rw parameter as suggested by Jan Kara.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>
---
Dropped BH_Flush/FUA as suggested.

Thanks.

 include/linux/blk_types.h   |    2 +-
 include/linux/buffer_head.h |    4 ++--
 include/linux/fs.h          |   20 +++++++++++++-------
 3 files changed, 16 insertions(+), 10 deletions(-)

Index: block/include/linux/fs.h
===================================================================
--- block.orig/include/linux/fs.h
+++ block/include/linux/fs.h
@@ -138,13 +138,13 @@ struct inodes_stat_t {
  * SWRITE_SYNC
  * SWRITE_SYNC_PLUG	Like WRITE_SYNC/WRITE_SYNC_PLUG, but locks the buffer.
  *			See SWRITE.
- * WRITE_BARRIER	Like WRITE_SYNC, but tells the block layer that all
- *			previously submitted writes must be safely on storage
- *			before this one is started. Also guarantees that when
- *			this write is complete, it itself is also safely on
- *			storage. Prevents reordering of writes on both sides
- *			of this IO.
- *
+ * WRITE_BARRIER	DEPRECATED. Always fails. Use FLUSH/FUA instead.
+ * WRITE_FLUSH		Like WRITE_SYNC but with preceding cache flush.
+ * WRITE_FUA		Like WRITE_SYNC but data is guaranteed to be on
+ *			non-volatile media on completion.
+ * WRITE_FLUSH_FUA	Combination of WRITE_FLUSH and FUA.  The IO is preceded
+ *			by a cache flush and data is guaranteed to be on
+ *			non-volatile media on completion.
  */
 #define RW_MASK			REQ_WRITE
 #define RWA_MASK		REQ_RAHEAD
@@ -162,6 +162,12 @@ struct inodes_stat_t {
 #define WRITE_META		(WRITE | REQ_META)
 #define WRITE_BARRIER		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
 				 REQ_HARDBARRIER)
+#define WRITE_FLUSH		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
+				 REQ_FLUSH)
+#define WRITE_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
+				 REQ_FUA)
+#define WRITE_FLUSH_FUA		(WRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG | \
+				 REQ_FLUSH | REQ_FUA)
 #define SWRITE_SYNC_PLUG	(SWRITE | REQ_SYNC | REQ_NOIDLE)
 #define SWRITE_SYNC		(SWRITE | REQ_SYNC | REQ_NOIDLE | REQ_UNPLUG)

Index: block/include/linux/blk_types.h
===================================================================
--- block.orig/include/linux/blk_types.h
+++ block/include/linux/blk_types.h
@@ -164,7 +164,7 @@ enum rq_flag_bits {
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_HARDBARRIER | REQ_SYNC | \
-	 REQ_META| REQ_DISCARD | REQ_NOIDLE)
+	 REQ_META | REQ_DISCARD | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)

 #define REQ_UNPLUG		(1 << __REQ_UNPLUG)
 #define REQ_RAHEAD		(1 << __REQ_RAHEAD)
Index: block/include/linux/buffer_head.h
===================================================================
--- block.orig/include/linux/buffer_head.h
+++ block/include/linux/buffer_head.h
@@ -32,8 +32,8 @@ enum bh_state_bits {
 	BH_Delay,	/* Buffer is not yet allocated on disk */
 	BH_Boundary,	/* Block is followed by a discontiguity */
 	BH_Write_EIO,	/* I/O error on write */
-	BH_Ordered,	/* ordered write */
-	BH_Eopnotsupp,	/* operation not supported (barrier) */
+	BH_Ordered,	/* DEPRECATED: ordered write */
+	BH_Eopnotsupp,	/* DEPRECATED: operation not supported (barrier) */
 	BH_Unwritten,	/* Buffer is allocated on disk but not written */
 	BH_Quiet,	/* Buffer Error Prinks to be quiet */

