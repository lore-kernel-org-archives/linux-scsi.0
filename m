From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large
 IO sg-chaining
Date: Wed, 25 Jul 2007 22:50:47 +0300
Message-ID: <46A7A997.4000709@panasas.com>
References: <46A60633.2020904@panasas.com>	<1185293406.3488.5.camel@localhost.localdomain>	<46A70944.6030005@panasas.com> <20070725174258T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:16984 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752570AbXGYTv3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2007 15:51:29 -0400
In-Reply-To: <20070725174258T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bhalevy@panasas.com, James.Bottomley@SteelEye.com
Cc: tomof@acm.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> From: Benny Halevy <bhalevy@panasas.com>
> Subject: Re: [PATCHSET 0/5] Peaceful co-existence of scsi_sgtable and Large IO sg-chaining
> Date: Wed, 25 Jul 2007 11:26:44 +0300
> 
>>> However, I'm perfectly happy to go with whatever the empirical evidence
>>> says is best .. and hopefully, now we don't have to pick this once and
>>> for all time ... we can alter it if whatever is chosen proves to be
>>> suboptimal.
>> I agree.  This isn't a catholic marriage :)
>> We'll run some performance experiments comparing the sgtable chaining
>> implementation vs. a scsi_data_buff implementation pointing
>> at a possibly chained sglist and let's see if we can measure
>> any difference.  We'll send results as soon as we have them.
> 
> I did some tests with your sgtable patchset and the approach to use
> separate buffer for sglists. As expected, there was no performance
> difference with small I/Os. I've not tried very large I/Os, which
> might give some difference.
> 
> The patchset to use separate buffer for sglists is available:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git simple-sgtable
> 
> 
> Can you clean up your patchset and upload somewhere?

Sorry sure. Here is scsi_sgtable complete work over linux-block:
http://www.bhalevy.com/open-osd/download/scsi_sgtable/linux-block
 
Here is just scsi_sgtable, no chaining, over scsi-misc + more
drivers:
http://www.bhalevy.com/open-osd/download/scsi_sgtable/scsi-misc

Next week I will try to mount lots of scsi_debug devices and
use large parallel IO to try and find a difference. I will
test Jens's sglist-arch tree against above sglist-arch+scsi_sgtable

I have lots of reservations about Tomo's last patches. For me
they are a regression. They use 3 allocations per command instead
of 2. They use an extra pointer and an extra global slab_pool. And
for what, for grouping some scsi_cmnd members in a substructure.
If we want to go the "pointing" way, keeping our extra scatterlist
and our base_2 count on most ARCHs. Than we can just use the 
scsi_data_buff embedded inside scsi_cmnd. 

The second scsi_data_buff for bidi can come either from an extra 
slab_pool like in Tomo's patch - bidi can pay - or in scsi.c at 
scsi_setup_command_freelist() the code can inspect Tomo's flag 
to the request_queue QUEUE_FLAG_BIDI and will than allocate a 
bigger scsi_cmnd in the free list.

I have coded that approach and it is very simple:
http://www.bhalevy.com/open-osd/download/scsi_data_buff

They are over Jens's sglist-arch branch
I have revised all scsi-ml places and it all compiles
But is totally untested.

I will add this branch to the above tests, but I suspect that
they are identical in every way to current code.

For review here is the main scsi_data_buff patch:
------
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Wed, 25 Jul 2007 20:19:14 +0300
Subject: [PATCH] SCSI: scsi_data_buff

  In preparation for bidi we abstract all IO members of scsi_cmnd
  that will need to duplicate into a substructure.
  - Group all IO members of scsi_cmnd into a scsi_data_buff
    structure.
  - Adjust accessors to new members.
  - scsi_{alloc,free}_sgtable receive a scsi_data_buff instead of
    scsi_cmnd. And work on it. (Supporting chaining like before)
  - Adjust scsi_init_io() and  scsi_release_buffers() for above
    change.
  - Fix other parts of scsi_lib to members migration. Use accessors
    where appropriate.

 Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_lib.c  |   68 +++++++++++++++++++--------------------------
 include/scsi/scsi_cmnd.h |   34 +++++++++++-----------
 2 files changed, 46 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d62b184..2b8a865 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -714,16 +714,14 @@ static unsigned scsi_sgtable_index(unsigned nents)
 	return -1;
 }
 
-struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
+struct scatterlist *scsi_alloc_sgtable(struct scsi_data_buff *sdb, gfp_t gfp_mask)
 {
 	struct scsi_host_sg_pool *sgp;
 	struct scatterlist *sgl, *prev, *ret;
 	unsigned int index;
 	int this, left;
 
-	BUG_ON(!cmd->use_sg);
-
-	left = cmd->use_sg;
+	left = sdb->sg_count;
 	ret = prev = NULL;
 	do {
 		this = left;
@@ -747,7 +745,7 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		 * first loop through, set initial index and return value
 		 */
 		if (!ret) {
-			cmd->sg_pool = index;
+			sdb->sg_pool = index;
 			ret = sgl;
 		}
 
@@ -769,10 +767,10 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 	} while (left);
 
 	/*
-	 * ->use_sg may get modified after dma mapping has potentially
+	 * sdb->sg_count may get modified after blk_rq_map_sg() potentially
 	 * shrunk the number of segments, so keep a copy of it for free.
 	 */
-	cmd->__use_sg = cmd->use_sg;
+	sdb->sgs_allocated = sdb->sg_count;
 	return ret;
 enomem:
 	if (ret) {
@@ -797,21 +795,21 @@ enomem:
 
 EXPORT_SYMBOL(scsi_alloc_sgtable);
 
-void scsi_free_sgtable(struct scsi_cmnd *cmd)
+void scsi_free_sgtable(struct scsi_data_buff *sdb)
 {
-	struct scatterlist *sgl = cmd->request_buffer;
+	struct scatterlist *sgl = sdb->sglist;
 	struct scsi_host_sg_pool *sgp;
 
 	/*
 	 * if this is the biggest size sglist, check if we have
 	 * chained parts we need to free
 	 */
-	if (cmd->__use_sg > SCSI_MAX_SG_SEGMENTS) {
+	if (sdb->sgs_allocated > SCSI_MAX_SG_SEGMENTS) {
 		unsigned short this, left;
 		struct scatterlist *next;
 		unsigned int index;
 
-		left = cmd->__use_sg - (SCSI_MAX_SG_SEGMENTS - 1);
+		left = sdb->sgs_allocated - (SCSI_MAX_SG_SEGMENTS - 1);
 		next = sg_chain_ptr(&sgl[SCSI_MAX_SG_SEGMENTS - 1]);
 		while (left && next) {
 			sgl = next;
@@ -833,7 +831,7 @@ void scsi_free_sgtable(struct scsi_cmnd *cmd)
 		}
 	}
 
-	mempool_free(cmd->request_buffer, scsi_sg_pools[cmd->sg_pool].pool);
+	mempool_free(sdb->sglist, scsi_sg_pools[sdb->sg_pool].pool);
 }
 
 EXPORT_SYMBOL(scsi_free_sgtable);
@@ -857,16 +855,10 @@ EXPORT_SYMBOL(scsi_free_sgtable);
  */
 static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	if (cmd->use_sg)
-		scsi_free_sgtable(cmd);
+	if (cmd->sdb.sglist)
+		scsi_free_sgtable(&cmd->sdb);
 
-	/*
-	 * Zero these out.  They now point to freed memory, and it is
-	 * dangerous to hang onto the pointers.
-	 */
-	cmd->request_buffer = NULL;
-	cmd->request_bufflen = 0;
-	cmd->use_sg = 0;
+	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 }
 
 /*
@@ -900,7 +892,7 @@ static void scsi_release_buffers(struct scsi_cmnd *cmd)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = cmd->request_bufflen;
+	int this_count = scsi_bufflen(cmd);
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int clear_errors = 1;
@@ -908,8 +900,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
-	scsi_release_buffers(cmd);
-
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
 		if (sense_valid)
@@ -932,9 +922,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				req->sense_len = len;
 			}
 		}
-		req->data_len = cmd->resid;
+		req->data_len = scsi_get_resid(cmd);
 	}
 
+	scsi_release_buffers(cmd);
+
 	/*
 	 * Next deal with any sectors which we were able to correctly
 	 * handle.
@@ -942,7 +934,6 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-	SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n", cmd->use_sg));
 
 	if (clear_errors)
 		req->errors = 0;
@@ -1075,41 +1066,42 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 {
 	struct request     *req = cmd->request;
 	int		   count;
+	struct scsi_data_buff* sdb = &cmd->sdb;
 
 	/*
 	 * We used to not use scatter-gather for single segment request,
 	 * but now we do (it makes highmem I/O easier to support without
 	 * kmapping pages)
 	 */
-	cmd->use_sg = req->nr_phys_segments;
+	sdb->sg_count = req->nr_phys_segments;
 
 	/*
 	 * If sg table allocation fails, requeue request later.
 	 */
-	cmd->request_buffer = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
-	if (unlikely(!cmd->request_buffer)) {
+	sdb->sglist = scsi_alloc_sgtable(sdb, GFP_ATOMIC);
+	if (unlikely(!sdb->sglist)) {
 		scsi_unprep_request(req);
 		return BLKPREP_DEFER;
 	}
 
 	req->buffer = NULL;
 	if (blk_pc_request(req))
-		cmd->request_bufflen = req->data_len;
+		sdb->length = req->data_len;
 	else
-		cmd->request_bufflen = req->nr_sectors << 9;
+		sdb->length = req->nr_sectors << 9;
 
 	/* 
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
-	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
-	if (likely(count <= cmd->use_sg)) {
-		cmd->use_sg = count;
+	count = blk_rq_map_sg(req->q, req, sdb->sglist);
+	if (likely(count <= sdb->sg_count)) {
+		sdb->sg_count = count;
 		return BLKPREP_OK;
 	}
 
 	printk(KERN_ERR "Incorrect number of segments after building list\n");
-	printk(KERN_ERR "counted %d, received %d\n", count, cmd->use_sg);
+	printk(KERN_ERR "counted %d, received %d\n", count, sdb->sg_count);
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
 
@@ -1165,7 +1157,7 @@ static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 	 * successfully. Since this is a REQ_BLOCK_PC command the
 	 * caller should check the request's errors value
 	 */
-	scsi_io_completion(cmd, cmd->request_bufflen);
+	scsi_io_completion(cmd, scsi_bufflen(cmd));
 }
 
 static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
@@ -1194,9 +1186,7 @@ static int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 		BUG_ON(req->data_len);
 		BUG_ON(req->data);
 
-		cmd->request_bufflen = 0;
-		cmd->request_buffer = NULL;
-		cmd->use_sg = 0;
+		memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 		req->buffer = NULL;
 	}
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index c7bfc60..89187dc 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -11,6 +11,14 @@ struct scatterlist;
 struct Scsi_Host;
 struct scsi_device;
 
+struct scsi_data_buff {
+	unsigned length;
+	int resid;
+	short sg_count;
+	short sgs_allocated;
+	short sg_pool;
+	struct scatterlist* sglist;
+};
 
 /* embedded in scsi_cmnd */
 struct scsi_pointer {
@@ -64,16 +72,10 @@ struct scsi_cmnd {
 	/* These elements define the operation we are about to perform */
 #define MAX_COMMAND_SIZE	16
 	unsigned char cmnd[MAX_COMMAND_SIZE];
-	unsigned request_bufflen;	/* Actual request size */
 
 	struct timer_list eh_timeout;	/* Used to time out the command. */
-	void *request_buffer;		/* Actual requested buffer */
 
 	/* These elements define the operation we ultimately want to perform */
-	unsigned short use_sg;	/* Number of pieces of scatter-gather */
-	unsigned short sg_pool;	/* pool index of allocated sg array */
-	unsigned short __use_sg;
-
 	unsigned underflow;	/* Return error if less than
 				   this amount is transferred */
 
@@ -83,10 +85,6 @@ struct scsi_cmnd {
 				   reconnects.   Probably == sector
 				   size */
 
-	int resid;		/* Number of bytes requested to be
-				   transferred less actual number
-				   transferred (0 if not supported) */
-
 	struct request *request;	/* The command we are
 				   	   working on */
 
@@ -118,6 +116,8 @@ struct scsi_cmnd {
 
 	unsigned char tag;	/* SCSI-II queued command tag */
 	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
+
+	struct scsi_data_buff sdb;
 };
 
 extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
@@ -133,35 +133,35 @@ extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
 
-extern struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *, gfp_t);
-extern void scsi_free_sgtable(struct scsi_cmnd *);
+extern struct scatterlist *scsi_alloc_sgtable(struct scsi_data_buff *, gfp_t);
+extern void scsi_free_sgtable(struct scsi_data_buff *);
 
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
 static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
 {
-	return cmd->use_sg;
+	return cmd->sdb.sg_count;
 }
 
 static inline struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd)
 {
-	return ((struct scatterlist *)cmd->request_buffer);
+	return cmd->sdb.sglist;
 }
 
 static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)
 {
-	return cmd->request_bufflen;
+	return cmd->sdb.length;
 }
 
 static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
 {
-	cmd->resid = resid;
+	cmd->sdb.resid = resid;
 }
 
 static inline int scsi_get_resid(struct scsi_cmnd *cmd)
 {
-	return cmd->resid;
+	return cmd->sdb.resid;
 }
 
 #define scsi_for_each_sg(cmd, sg, nseg, __i)			\
-- 
1.5.2.2.249.g45fd

