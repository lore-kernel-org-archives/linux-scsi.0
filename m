From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 23/28] blk_end_request: changing cpqarray (take 3)
Date: Fri, 30 Nov 2007 18:33:38 -0500 (EST)
Message-ID: <20071130.183338.107679989.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts cpqarray to use blk_end_request().

cpqarray is a little bit different from "normal" drivers.
cpqarray directly calls bio_endio() and disk_stat_add()
when completing request.  But those can be replaced with
__end_that_request_first().
After the replacement, request completion procedures of
those drivers become like the following:
    o end_that_request_first()
    o add_disk_randomness()
    o end_that_request_last()
This can be converted to blk_end_request() by following
the rule (b) mentioned in the patch subject
"[PATCH 01/28] blk_end_request: add new request completion interface".

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/cpqarray.c |   27 ++-------------------------
 1 files changed, 2 insertions(+), 25 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/block/cpqarray.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/cpqarray.c
+++ 2.6.24-rc3-mm2/drivers/block/cpqarray.c
@@ -167,7 +167,6 @@ static void start_io(ctlr_info_t *h);
 
 static inline void addQ(cmdlist_t **Qptr, cmdlist_t *c);
 static inline cmdlist_t *removeQ(cmdlist_t **Qptr, cmdlist_t *c);
-static inline void complete_buffers(struct bio *bio, int ok);
 static inline void complete_command(cmdlist_t *cmd, int timeout);
 
 static irqreturn_t do_ida_intr(int irq, void *dev_id);
@@ -980,19 +979,6 @@ static void start_io(ctlr_info_t *h)
 	}
 }
 
-static inline void complete_buffers(struct bio *bio, int ok)
-{
-	struct bio *xbh;
-
-	while (bio) {
-		xbh = bio->bi_next;
-		bio->bi_next = NULL;
-		
-		bio_endio(bio, ok ? 0 : -EIO);
-
-		bio = xbh;
-	}
-}
 /*
  * Mark all buffers that cmd was responsible for
  */
@@ -1030,18 +1016,9 @@ static inline void complete_command(cmdl
                 pci_unmap_page(hba[cmd->ctlr]->pci_dev, cmd->req.sg[i].addr,
 				cmd->req.sg[i].size, ddir);
 
-	complete_buffers(rq->bio, ok);
-
-	if (blk_fs_request(rq)) {
-		const int rw = rq_data_dir(rq);
-
-		disk_stat_add(rq->rq_disk, sectors[rw], rq->nr_sectors);
-	}
-
-	add_disk_randomness(rq->rq_disk);
-
 	DBGPX(printk("Done with %p\n", rq););
-	end_that_request_last(rq, ok ? 1 : -EIO);
+	if (__blk_end_request(rq, ok, blk_rq_bytes(rq)))
+		BUG();
 }
 
 /*
