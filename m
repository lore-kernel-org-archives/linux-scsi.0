From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 22/30] blk_end_request: changing cpqarray (take 4)
Date: Tue, 11 Dec 2007 17:50:21 -0500 (EST)
Message-ID: <20071211.175021.39666150.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com
Cc: mike.miller@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts cpqarray to use blk_end_request interfaces.
Related 'ok' arguments are converted to 'error'.

cpqarray is a little bit different from "normal" drivers.
cpqarray directly calls bio_endio() and disk_stat_add()
when completing request.  But those can be replaced with
__end_that_request_first().
After the replacement, request completion procedures of
those drivers become like the following:
    o end_that_request_first()
    o add_disk_randomness()
    o end_that_request_last()
This can be converted to __blk_end_request() by following
the rule (b) mentioned in the patch subject
"[PATCH 01/30] blk_end_request: add new request completion interface".

Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/cpqarray.c |   36 +++++++-----------------------------
 1 files changed, 7 insertions(+), 29 deletions(-)

Index: 2.6.24-rc4/drivers/block/cpqarray.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/cpqarray.c
+++ 2.6.24-rc4/drivers/block/cpqarray.c
@@ -167,7 +167,6 @@ static void start_io(ctlr_info_t *h);
 
 static inline void addQ(cmdlist_t **Qptr, cmdlist_t *c);
 static inline cmdlist_t *removeQ(cmdlist_t **Qptr, cmdlist_t *c);
-static inline void complete_buffers(struct bio *bio, int ok);
 static inline void complete_command(cmdlist_t *cmd, int timeout);
 
 static irqreturn_t do_ida_intr(int irq, void *dev_id);
@@ -980,26 +979,13 @@ static void start_io(ctlr_info_t *h)
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
 static inline void complete_command(cmdlist_t *cmd, int timeout)
 {
 	struct request *rq = cmd->rq;
-	int ok=1;
+	int error = 0;
 	int i, ddir;
 
 	if (cmd->req.hdr.rcode & RCODE_NONFATAL &&
@@ -1011,16 +997,17 @@ static inline void complete_command(cmdl
 	if (cmd->req.hdr.rcode & RCODE_FATAL) {
 		printk(KERN_WARNING "Fatal error on ida/c%dd%d\n",
 				cmd->ctlr, cmd->hdr.unit);
-		ok = 0;
+		error = -EIO;
 	}
 	if (cmd->req.hdr.rcode & RCODE_INVREQ) {
 				printk(KERN_WARNING "Invalid request on ida/c%dd%d = (cmd=%x sect=%d cnt=%d sg=%d ret=%x)\n",
 				cmd->ctlr, cmd->hdr.unit, cmd->req.hdr.cmd,
 				cmd->req.hdr.blk, cmd->req.hdr.blk_cnt,
 				cmd->req.hdr.sg_cnt, cmd->req.hdr.rcode);
-		ok = 0;	
+		error = -EIO;
 	}
-	if (timeout) ok = 0;
+	if (timeout)
+		error = -EIO;
 	/* unmap the DMA mapping for all the scatter gather elements */
 	if (cmd->req.hdr.cmd == IDA_READ)
 		ddir = PCI_DMA_FROMDEVICE;
@@ -1030,18 +1017,9 @@ static inline void complete_command(cmdl
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
+	if (__blk_end_request(rq, error, blk_rq_bytes(rq)))
+		BUG();
 }
 
 /*
