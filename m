From: Christoph Hellwig <hch@lst.de>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
Date: Mon, 5 Jan 2015 20:32:13 +0100
Message-ID: <20150105193213.GA31955@lst.de>
References: <54A43CFB.2080705@oracle.com> <20150105091516.GA22226@lst.de> <54AADF6A.6090100@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54AADF6A.6090100@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Sasha Levin <sasha.levin@oracle.com>, bvanassche@acm.org, hare@suse.de, JBottomley@parallels.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 05, 2015 at 12:00:58PM -0700, Jens Axboe wrote:
> That's not quite true, the only guarantee is that it WILL execute on the
> CPU (or CPUs) that are set in the mask. So unless it ends up offloading
> the run to a specific workqueue, we'll disable preempt in the current
> path before ->queue_rq() is called.

Oops.  Indeed, with those recent changes ->queue_rq can't safely block
for memory allocatios anymore.

The patch below should fix it:

---
From: Christoph Hellwig <hch@lst.de>
Subject: scsi: ->queue_rq can't sleep

Since Linux 3.19 blk-mq may disable preemption before calling into
->queue_rq, so we can't actually sleep anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ea95dd..6d5c0b8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -591,7 +591,6 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb, bool mq)
 static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
 {
 	struct scatterlist *first_chunk = NULL;
-	gfp_t gfp_mask = mq ? GFP_NOIO : GFP_ATOMIC;
 	int ret;
 
 	BUG_ON(!nents);
@@ -606,7 +605,7 @@ static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
 	}
 
 	ret = __sg_alloc_table(&sdb->table, nents, SCSI_MAX_SG_SEGMENTS,
-			       first_chunk, gfp_mask, scsi_sg_alloc);
+			       first_chunk, GFP_ATOMIC, scsi_sg_alloc);
 	if (unlikely(ret))
 		scsi_free_sgtable(sdb, mq);
 	return ret;
-- 
1.9.1
