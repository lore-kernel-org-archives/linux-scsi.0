From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] sg.c: fixes to sg_build_indirect()
Date: Sat, 4 Nov 2006 11:48:42 -0800 (PST)
Message-ID: <254019.55389.qm@web31801.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-443814737-1162669722=:55389"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:51025 "HELO
	web31801.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S965326AbWKDTsn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 14:48:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dougg@torque.net>

--0-443814737-1162669722=:55389
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

The sg driver corrupts memory when the data buffer
size is 5493376 (0x53d280) bytes.  The reason for this
is the computation of the left over size given the
size of scatter-gather array and the size of the
scatter-gather element.  This patch fixes this.

Other fixes:
1. Eliminate scatter_elem_sz_prev, and use memory
   barriers to get its current value.  Reset it to PAGE_SIZE
   if the user has set it to something smaller.
2. Use roundup() defined in linux/kernel.h
3. Figure out if the buff_size will fit in the maximum
   table size. If not, give up early and print an
   informative message.
4. Greatly simplified allocation loop.
5. Use min() defined in linux/kernel.h.
6. The remaining size (rem_sz) is decremented not by ret_sz, but
   by sg->length = min(num, ret_sz), i.e. by the effective memory
   we've allocated.
7. schp->bufflen is set to buff_size, not blk_size, since
   this is the effective xfer size we want to xfer.
8. blk_size must equal exactly 0 iff all allocation succeeded.
  (this is the proof of the loop)

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/scsi/sg.c |  108 +++++++++++++++++++++++++++-------------------------
 1 files changed, 56 insertions(+), 52 deletions(-)

Getting out of my hair some patches in my dev (gateway) tree.

    Luben

--0-443814737-1162669722=:55389
Content-Type: text/inline; name="sg.txt"
Content-Description: 795371012-sg.txt
Content-Disposition: name="sg.txt"; filename="sg.txt"

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 18fa739..f377295 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -95,11 +95,8 @@ static int def_reserved_size = -1;	/* pi
 static int sg_allow_dio = SG_ALLOW_DIO_DEF;
 
 static int scatter_elem_sz = SG_SCATTER_SZ;
-static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 
 #define SG_SECTOR_SZ 512
-#define SG_SECTOR_MSK (SG_SECTOR_SZ - 1)
-
 #define SG_DEV_ARR_LUMP 32	/* amount to over allocate sg_dev_arr by */
 
 static int sg_add(struct class_device *, struct class_interface *);
@@ -1560,10 +1557,8 @@ init_sg(void)
 {
 	int rc;
 
-	if (scatter_elem_sz < PAGE_SIZE) {
+	if (scatter_elem_sz < PAGE_SIZE)
 		scatter_elem_sz = PAGE_SIZE;
-		scatter_elem_sz_prev = scatter_elem_sz;
-	}
 	if (def_reserved_size >= 0)
 		sg_big_buff = def_reserved_size;
 	else
@@ -1831,62 +1826,71 @@ static int
 sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 {
 	struct scatterlist *sg;
-	int ret_sz = 0, k, rem_sz, num, mx_sc_elems;
-	int sg_tablesize = sfp->parentdp->sg_tablesize;
-	int blk_size = buff_size;
-	struct page *p = NULL;
-
-	if ((blk_size < 0) || (!sfp))
+	int max_tablesize = sfp->parentdp->sg_tablesize;
+	int sg_tablesize, blk_size, k;
+	int sc_elem_sz;
+	
+	if ((buff_size < 0) || (!sfp))
 		return -EFAULT;
-	if (0 == blk_size)
-		++blk_size;	/* don't know why */
-/* round request up to next highest SG_SECTOR_SZ byte boundary */
-	blk_size = (blk_size + SG_SECTOR_MSK) & (~SG_SECTOR_MSK);
-	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d, blk_size=%d\n",
-				   buff_size, blk_size));
-
-	/* N.B. ret_sz carried into this block ... */
-	mx_sc_elems = sg_build_sgat(schp, sfp, sg_tablesize);
-	if (mx_sc_elems < 0)
-		return mx_sc_elems;	/* most likely -ENOMEM */
-
-	num = scatter_elem_sz;
-	if (unlikely(num != scatter_elem_sz_prev)) {
-		if (num < PAGE_SIZE) {
-			scatter_elem_sz = PAGE_SIZE;
-			scatter_elem_sz_prev = PAGE_SIZE;
-		} else
-			scatter_elem_sz_prev = num;
+	if (0 == buff_size)
+		buff_size = 1;
+
+	if (scatter_elem_sz < PAGE_SIZE)
+		scatter_elem_sz = PAGE_SIZE;
+	sc_elem_sz = scatter_elem_sz;
+	mb();
+
+	blk_size = roundup(buff_size, SG_SECTOR_SZ);
+	SCSI_LOG_TIMEOUT(4, printk("sg_build_indirect: buff_size=%d, "
+				   "blk_size=%d\n", buff_size, blk_size));
+
+	sg_tablesize = (blk_size + sc_elem_sz - 1)/sc_elem_sz;
+	if (sg_tablesize > max_tablesize) {
+		printk(KERN_NOTICE "%s: sg_table too big (%d > %d) for "
+		       "round-up transfer size of %d bytes with %d bytes an "
+		       "sg element\n",
+		       __FUNCTION__, sg_tablesize, max_tablesize,
+		       blk_size, sc_elem_sz);
+		return -ENOMEM;
 	}
-	for (k = 0, sg = schp->buffer, rem_sz = blk_size;
-	     (rem_sz > 0) && (k < mx_sc_elems);
-	     ++k, rem_sz -= ret_sz, ++sg) {
+
+	/* Allocate the maximum table size, in case external memory
+	 * fragmentation stretches us over the nominal sg size for the
+	 * given blk_size and sc_elem_sz.
+	 */
+	sg_tablesize = sg_build_sgat(schp, sfp, max_tablesize);
+	if (sg_tablesize <= 0)
+		return -ENOMEM;
+
+	for (k = 0, sg = schp->buffer;
+	     0 < blk_size && k < sg_tablesize;
+	     ++k, ++sg) {
 		
-		num = (rem_sz > scatter_elem_sz_prev) ?
-		      scatter_elem_sz_prev : rem_sz;
-		p = sg_page_malloc(num, sfp->low_dma, &ret_sz);
-		if (!p)
+		int ret_sz;
+		int num = min(blk_size, sc_elem_sz);
+
+		sg->page = sg_page_malloc(num, sfp->low_dma, &ret_sz);
+		if (!sg->page)
 			return -ENOMEM;
 
-		if (num == scatter_elem_sz_prev) {
-			if (unlikely(ret_sz > scatter_elem_sz_prev)) {
-				scatter_elem_sz = ret_sz;
-				scatter_elem_sz_prev = ret_sz;
-			}
-		}
-		sg->page = p;
-		sg->length = ret_sz;
+		sg->length = min(num, ret_sz);
 
-		SCSI_LOG_TIMEOUT(5, printk("sg_build_build: k=%d, a=0x%p, len=%d\n",
-				  k, p, ret_sz));
-	}		/* end of for loop */
+		blk_size -= sg->length;
+
+		SCSI_LOG_TIMEOUT(5, printk("sg_build_build: k=%d, a=0x%p, "
+					   "len=%d\n",
+					   k, sg->page, sg->length));
+	}
 
 	schp->k_use_sg = k;
-	SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, rem_sz=%d\n", k, rem_sz));
+	SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k_use_sg=%d, "
+				   "remained=%d\n", k, blk_size));
 
-	schp->bufflen = blk_size;
-	if (rem_sz > 0)	/* must have failed */
+	schp->bufflen = buff_size;
+	if (blk_size != 0) {
+		/* must have failed */
 		return -ENOMEM;
+	}
 
 	return 0;
 }
-- 
1.4.3.3.g8478


--0-443814737-1162669722=:55389--
