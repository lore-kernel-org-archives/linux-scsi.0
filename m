From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/4] bidi support: request_io_part
Date: Sun, 29 Apr 2007 18:49:13 +0300
Message-ID: <4634BE79.10507@panasas.com>
References: <46225E18.7070404@panasas.com> <462261C5.3050807@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <462261C5.3050807@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, Benny Halevy <bhalevy@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> - Extract all I/O members of struct request into a request_io_part member.
> - Define API to access the I/O part
> - Adjust block layer accordingly.
> - Change all users to new API.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
> 
> ---------------------------------------------------
> 
> Patch is attached compressed because of size
It looks like this patch is very big and is hard for review/maintenance.

I was thinking of a way it could be divided into small patches but still
make it compile and run at each stage/patch for bisects.

It could be done in three stages:
1. Make a dummy API that mimics the new API but still lets old drivers/code
   compile.
2. Stage 2 - convert driver by driver or group by group to new API. this can
   be done in an arbitrary number of patches.
3. Final stage. do the actual move of members and implement the new API.
   At this stage, if any drivers are not converted, (out-of-tree drivers),
   they will not compile.

Please tell me if you need this done? should I send the all patchset or just this one divided?
(Below is a demonstration of 1st and 3rd stages at blkdev.h)

<FIRST_STAGE>
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c1121d2..579ee2d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -235,23 +235,6 @@ struct request {
 	unsigned int cmd_flags;
 	enum rq_cmd_type_bits cmd_type;

-	/* Maintain bio traversal state for part by part I/O submission.
-	 * hard_* are block layer internals, no driver should touch them!
-	 */
-
-	sector_t sector;		/* next sector to submit */
-	sector_t hard_sector;		/* next sector to complete */
-	unsigned long nr_sectors;	/* no. of sectors left to submit */
-	unsigned long hard_nr_sectors;	/* no. of sectors left to complete */
-	/* no. of sectors left to submit in the current segment */
-	unsigned int current_nr_sectors;
-
-	/* no. of sectors left to complete in the current segment */
-	unsigned int hard_cur_sectors;
-
-	struct bio *bio;
-	struct bio *biotail;
-
 	struct hlist_node hash;	/* merge hash */
 	/*
 	 * The rb_node is only used inside the io scheduler, requests
@@ -273,22 +256,11 @@ struct request {
 	struct gendisk *rq_disk;
 	unsigned long start_time;

-	/* Number of scatter-gather DMA addr+len pairs after
-	 * physical address coalescing is performed.
-	 */
-	unsigned short nr_phys_segments;
-
-	/* Number of scatter-gather addr+len pairs after
-	 * physical and DMA remapping hardware coalescing is performed.
-	 * This is the number of scatter-gather entries the driver
-	 * will actually have to deal with after DMA mapping is done.
-	 */
-	unsigned short nr_hw_segments;
-
 	unsigned short ioprio;

 	void *special;
-	char *buffer;
+	char *buffer;			/* FIXME: should be Deprecated */
+	void *data;			/* FIXME: should be Deprecated */

 	int tag;
 	int errors;
@@ -301,9 +273,7 @@ struct request {
 	unsigned int cmd_len;
 	unsigned char cmd[BLK_MAX_CDB];

-	unsigned int data_len;
 	unsigned int sense_len;
-	void *data;
 	void *sense;

 	unsigned int timeout;
@@ -314,8 +284,49 @@ struct request {
 	 */
 	rq_end_io_fn *end_io;
 	void *end_io_data;
+
+/*
+ request io members. FIXME: will go later in the patchset into a sub-structure
+*/
+/*	struct request_io_part uni; */
+/* struct request_io_part { */
+	unsigned int data_len;
+
+	/* Maintain bio traversal state for part by part I/O submission.
+	 * hard_* are block layer internals, no driver should touch them!
+	 */
+	sector_t sector;		/* next sector to submit */
+	sector_t hard_sector;		/* next sector to complete */
+	unsigned long nr_sectors;	/* no. of sectors left to submit */
+	unsigned long hard_nr_sectors;	/* no. of sectors left to complete */
+	/* no. of sectors left to submit in the current segment */
+	unsigned int current_nr_sectors;
+
+	/* no. of sectors left to complete in the current segment */
+	unsigned int hard_cur_sectors;
+
+	struct bio *bio;
+	struct bio *biotail;
+
+	/* Number of scatter-gather DMA addr+len pairs after
+	 * physical address coalescing is performed.
+	 */
+	unsigned short nr_phys_segments;
+
+	/* Number of scatter-gather addr+len pairs after
+	 * physical and DMA remapping hardware coalescing is performed.
+	 * This is the number of scatter-gather entries the driver
+	 * will actually have to deal with after DMA mapping is done.
+	 */
+	unsigned short nr_hw_segments;
+/* }; */
 };

+/* FIXME: here only for the duration of the patchset.
+   will be removed in last patch
+*/
+#define request_io_part request
+
 /*
  * State information carried for REQ_TYPE_PM_SUSPEND and REQ_TYPE_PM_RESUME
  * requests. Some step values could eventually be made generic.
@@ -589,6 +600,15 @@ static inline const char* rq_dir_to_string(struct request* rq)
 }

 /*
+ * access for the apropreate bio and io members
+ */
+static inline struct request_io_part* rq_uni(struct request* req)
+{
+	/* FIXME: will be changed to real implementation in last patch */
+	return req;
+}
+
+/*
  * We regard a request as sync, if it's a READ or a SYNC write.
  */
 #define rq_is_sync(rq)		(rq_rw_dir((rq)) == READ || (rq)->cmd_flags & REQ_RW_SYNC)
</FIRST_STAGE>

<SECOND_STAGE>
- Convert all users file by file or group by group. For example:
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index b36f44d..eea101f 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2137,7 +2137,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		rq->cmd_len = 12;
 		rq->cmd_type = REQ_TYPE_BLOCK_PC;
 		rq->timeout = 60 * HZ;
-		bio = rq->bio;
+		bio = rq_uni(rq)->bio;

 		if (blk_execute_rq(q, cdi->disk, rq, 0)) {
 			struct request_sense *s = rq->sense;
</SECOND_STAGE>

<THIRD STAGE>
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 579ee2d..bcd2a2a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -137,6 +137,41 @@ struct request_list {
 };

 /*
+ * request io members. one for uni read/write and one for bidi_read
+ */
+struct request_io_part {
+	unsigned int data_len;
+
+	/* Maintain bio traversal state for part by part I/O submission.
+	 * hard_* are block layer internals, no driver should touch them!
+	 */
+	sector_t sector;		/* next sector to submit */
+	sector_t hard_sector;		/* next sector to complete */
+	unsigned long nr_sectors;	/* no. of sectors left to submit */
+	unsigned long hard_nr_sectors;	/* no. of sectors left to complete */
+	/* no. of sectors left to submit in the current segment */
+	unsigned int current_nr_sectors;
+
+	/* no. of sectors left to complete in the current segment */
+	unsigned int hard_cur_sectors;
+
+	struct bio *bio;
+	struct bio *biotail;
+
+	/* Number of scatter-gather DMA addr+len pairs after
+	 * physical address coalescing is performed.
+	 */
+	unsigned short nr_phys_segments;
+
+	/* Number of scatter-gather addr+len pairs after
+	 * physical and DMA remapping hardware coalescing is performed.
+	 * This is the number of scatter-gather entries the driver
+	 * will actually have to deal with after DMA mapping is done.
+	 */
+	unsigned short nr_hw_segments;
+};
+
+/*
  * request command types
  */
 enum rq_cmd_type_bits {
@@ -285,48 +320,9 @@ struct request {
 	rq_end_io_fn *end_io;
 	void *end_io_data;

-/*
- request io members. FIXME: will go later in the patchset into a sub-structure
-*/
-/*	struct request_io_part uni; */
-/* struct request_io_part { */
-	unsigned int data_len;
-
-	/* Maintain bio traversal state for part by part I/O submission.
-	 * hard_* are block layer internals, no driver should touch them!
-	 */
-	sector_t sector;		/* next sector to submit */
-	sector_t hard_sector;		/* next sector to complete */
-	unsigned long nr_sectors;	/* no. of sectors left to submit */
-	unsigned long hard_nr_sectors;	/* no. of sectors left to complete */
-	/* no. of sectors left to submit in the current segment */
-	unsigned int current_nr_sectors;
-
-	/* no. of sectors left to complete in the current segment */
-	unsigned int hard_cur_sectors;
-
-	struct bio *bio;
-	struct bio *biotail;
-
-	/* Number of scatter-gather DMA addr+len pairs after
-	 * physical address coalescing is performed.
-	 */
-	unsigned short nr_phys_segments;
-
-	/* Number of scatter-gather addr+len pairs after
-	 * physical and DMA remapping hardware coalescing is performed.
-	 * This is the number of scatter-gather entries the driver
-	 * will actually have to deal with after DMA mapping is done.
-	 */
-	unsigned short nr_hw_segments;
-/* }; */
+	struct request_io_part uni;
 };

-/* FIXME: here only for the duration of the patchset.
-   will be removed in last patch
-*/
-#define request_io_part request
-
 /*
  * State information carried for REQ_TYPE_PM_SUSPEND and REQ_TYPE_PM_RESUME
  * requests. Some step values could eventually be made generic.
@@ -584,17 +580,17 @@ static inline int rq_data_dir(struct request* rq)
 static inline enum dma_data_direction rq_dma_dir(struct request* rq)
 {
 	WARN_ON(rq_is_bidi(rq));
-	if (!rq->bio)
+	if (!rq->uni.bio)
 		return DMA_NONE;
 	else
-		return bio_data_dir(rq->bio) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+		return bio_data_dir(rq->uni.bio) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
 }
 static inline const char* rq_dir_to_string(struct request* rq)
 {
-	if (!rq->bio)
+	if (!rq->uni.bio)
 		return "no data command";
 	else
-		return bio_data_dir(rq->bio) ?
+		return bio_data_dir(rq->uni.bio) ?
 			"writing" :
 			"reading";
 }
@@ -604,8 +600,8 @@ static inline const char* rq_dir_to_string(struct request* rq)
  */
 static inline struct request_io_part* rq_uni(struct request* req)
 {
-	/* FIXME: will be changed to real implementation in last patch */
-	return req;
+	WARN_ON( rq_is_bidi(req) );
+	return &req->uni;
 }

 /*
@@ -681,8 +677,8 @@ static inline void blk_queue_bounce(request_queue_t *q, struct bio **bio)
 #endif /* CONFIG_MMU */

 #define rq_for_each_bio(_bio, rq)	\
-	if ((rq->bio))			\
-		for (_bio = (rq)->bio; _bio; _bio = _bio->bi_next)
+	if ((rq_uni(rq)->bio))			\
+		for (_bio = rq_uni(rq)->bio; _bio; _bio = _bio->bi_next)

 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);

</THIRD_STAGE>
