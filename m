From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: [RESEND PATCH v1 2/2] trace: events: block: Add tag in block trace
 events
Date: Mon, 16 Apr 2018 14:33:29 +0000
Message-ID: <64d6073b28b140cda3e5870a54e0a7bc@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@redhad.com" <mingo@redhad.com>, "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Bean Huo (beanhuo)" <beanhuo@micron.com>, "rajatja@google.com" <rajatja@google.com>
List-Id: linux-scsi@vger.kernel.org

Print the request tag along with other information in block trace events
when tracing request , and unplug type (Sync / Async).

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 include/trace/events/block.h | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 81b43f5..f8c0b9e 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -81,6 +81,7 @@ TRACE_EVENT(block_rq_requeue,
 		__field(  dev_t,	dev			)
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
+		__field(  int,		tag			)
 		__array(  char,		rwbs,	RWBS_LEN	)
 		__dynamic_array( char,	cmd,	1		)
 	),
@@ -89,16 +90,17 @@ TRACE_EVENT(block_rq_requeue,
 		__entry->dev	   = rq->rq_disk ? disk_devt(rq->rq_disk) : 0;
 		__entry->sector    = blk_rq_trace_sector(rq);
 		__entry->nr_sector = blk_rq_trace_nr_sectors(rq);
+		__entry->tag	   = rq->tag;
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 		__get_str(cmd)[0] = '\0';
 	),
 
-	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
+	TP_printk("%d,%d %s (%s) %llu + %u tag=%d [%d]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __get_str(cmd),
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, 0)
+		  __entry->nr_sector, __entry->tag, 0)
 );
 
 /**
@@ -124,6 +126,7 @@ TRACE_EVENT(block_rq_complete,
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
 		__field(  int,		error			)
+		__field(  int,		tag			)
 		__array(  char,		rwbs,	RWBS_LEN	)
 		__dynamic_array( char,	cmd,	1		)
 	),
@@ -133,16 +136,17 @@ TRACE_EVENT(block_rq_complete,
 		__entry->sector    = blk_rq_pos(rq);
 		__entry->nr_sector = nr_bytes >> 9;
 		__entry->error     = error;
+		__entry->tag	   = rq->tag;
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, nr_bytes);
 		__get_str(cmd)[0] = '\0';
 	),
 
-	TP_printk("%d,%d %s (%s) %llu + %u [%d]",
+	TP_printk("%d,%d %s (%s) %llu + %u tag=%d [%d]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __get_str(cmd),
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->error)
+		  __entry->nr_sector, __entry->tag, __entry->error)
 );
 
 DECLARE_EVENT_CLASS(block_rq,
@@ -156,6 +160,7 @@ DECLARE_EVENT_CLASS(block_rq,
 		__field(  sector_t,	sector			)
 		__field(  unsigned int,	nr_sector		)
 		__field(  unsigned int,	bytes			)
+		__field(  int,		tag			)
 		__array(  char,		rwbs,	RWBS_LEN	)
 		__array(  char,         comm,   TASK_COMM_LEN   )
 		__dynamic_array( char,	cmd,	1		)
@@ -166,17 +171,18 @@ DECLARE_EVENT_CLASS(block_rq,
 		__entry->sector    = blk_rq_trace_sector(rq);
 		__entry->nr_sector = blk_rq_trace_nr_sectors(rq);
 		__entry->bytes     = blk_rq_bytes(rq);
+		__entry->tag	   = rq->tag;
 
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 		__get_str(cmd)[0] = '\0';
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %u (%s) %llu + %u [%s]",
+	TP_printk("%d,%d %s %u (%s) %llu + %u tag=%d [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->rwbs, __entry->bytes, __get_str(cmd),
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+		  __entry->nr_sector, __entry->tag, __entry->comm)
 );
 
 /**
@@ -297,6 +303,7 @@ DECLARE_EVENT_CLASS(block_bio_merge,
 		__field( dev_t,		dev			)
 		__field( sector_t,	sector			)
 		__field( unsigned int,	nr_sector		)
+		__field( int,		tag			)
 		__array( char,		rwbs,	RWBS_LEN	)
 		__array( char,		comm,	TASK_COMM_LEN	)
 	),
@@ -305,14 +312,15 @@ DECLARE_EVENT_CLASS(block_bio_merge,
 		__entry->dev		= bio_dev(bio);
 		__entry->sector		= bio->bi_iter.bi_sector;
 		__entry->nr_sector	= bio_sectors(bio);
+		__entry->tag		= rq->tag;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_opf, bio->bi_iter.bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("%d,%d %s %llu + %u [%s]",
+	TP_printk("%d,%d %s %llu + %u tag=%d [%s]",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
-		  __entry->nr_sector, __entry->comm)
+		  __entry->nr_sector, __entry->tag, __entry->comm)
 );
 
 /**
@@ -478,15 +486,18 @@ DECLARE_EVENT_CLASS(block_unplug,
 
 	TP_STRUCT__entry(
 		__field( int,		nr_rq			)
+		__field( bool,		explicit		)
 		__array( char,		comm,	TASK_COMM_LEN	)
 	),
 
 	TP_fast_assign(
 		__entry->nr_rq = depth;
+		__entry->explicit = explicit;
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
 
-	TP_printk("[%s] %d", __entry->comm, __entry->nr_rq)
+	TP_printk("[%s] %d %s", __entry->comm, __entry->nr_rq,
+		   __entry->explicit ? "Sync" : "Async")
 );
 
 /**
@@ -611,6 +622,7 @@ TRACE_EVENT(block_rq_remap,
 		__field( dev_t,		dev		)
 		__field( sector_t,	sector		)
 		__field( unsigned int,	nr_sector	)
+		__field( int,		tag		)
 		__field( dev_t,		old_dev		)
 		__field( sector_t,	old_sector	)
 		__field( unsigned int,	nr_bios		)
@@ -621,18 +633,20 @@ TRACE_EVENT(block_rq_remap,
 		__entry->dev		= disk_devt(rq->rq_disk);
 		__entry->sector		= blk_rq_pos(rq);
 		__entry->nr_sector	= blk_rq_sectors(rq);
+		__entry->tag		= rq->tag;
 		__entry->old_dev	= dev;
 		__entry->old_sector	= from;
 		__entry->nr_bios	= blk_rq_count_bios(rq);
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 	),
 
-	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu %u",
+	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu %u, tag=%d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector,
 		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
-		  (unsigned long long)__entry->old_sector, __entry->nr_bios)
+		  (unsigned long long)__entry->old_sector, __entry->nr_bios,
+		  __entry->tag)
 );
 
 #endif /* _TRACE_BLOCK_H */
-- 
2.7.4
