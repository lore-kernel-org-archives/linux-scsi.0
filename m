From: mchristi@redhat.com
Subject: [PATCH 22/45] pm: use bio op accessors
Date: Sun,  5 Jun 2016 14:32:02 -0500
Message-ID: <1465155145-10812-23-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

Separate the op from the rq_flag_bits and have the pm code
set/get the bio using bio_set_op_attrs/bio_op.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 kernel/power/swap.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index be227f5..c1aaac4 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -261,7 +261,7 @@ static void hib_end_io(struct bio *bio)
 	bio_put(bio);
 }
 
-static int hib_submit_io(int rw, pgoff_t page_off, void *addr,
+static int hib_submit_io(int op, int op_flags, pgoff_t page_off, void *addr,
 		struct hib_bio_batch *hb)
 {
 	struct page *page = virt_to_page(addr);
@@ -271,7 +271,7 @@ static int hib_submit_io(int rw, pgoff_t page_off, void *addr,
 	bio = bio_alloc(__GFP_RECLAIM | __GFP_HIGH, 1);
 	bio->bi_iter.bi_sector = page_off * (PAGE_SIZE >> 9);
 	bio->bi_bdev = hib_resume_bdev;
-	bio->bi_rw = rw;
+	bio_set_op_attrs(bio, op, op_flags);
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
 		printk(KERN_ERR "PM: Adding page to bio failed at %llu\n",
@@ -307,7 +307,8 @@ static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
 {
 	int error;
 
-	hib_submit_io(READ_SYNC, swsusp_resume_block, swsusp_header, NULL);
+	hib_submit_io(REQ_OP_READ, READ_SYNC, swsusp_resume_block,
+		      swsusp_header, NULL);
 	if (!memcmp("SWAP-SPACE",swsusp_header->sig, 10) ||
 	    !memcmp("SWAPSPACE2",swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->orig_sig,swsusp_header->sig, 10);
@@ -316,8 +317,8 @@ static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
 		swsusp_header->flags = flags;
 		if (flags & SF_CRC32_MODE)
 			swsusp_header->crc32 = handle->crc32;
-		error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
-					swsusp_header, NULL);
+		error = hib_submit_io(REQ_OP_WRITE, WRITE_SYNC,
+				      swsusp_resume_block, swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "PM: Swap header not found!\n");
 		error = -ENODEV;
@@ -390,7 +391,7 @@ static int write_page(void *buf, sector_t offset, struct hib_bio_batch *hb)
 	} else {
 		src = buf;
 	}
-	return hib_submit_io(WRITE_SYNC, offset, src, hb);
+	return hib_submit_io(REQ_OP_WRITE, WRITE_SYNC, offset, src, hb);
 }
 
 static void release_swap_writer(struct swap_map_handle *handle)
@@ -993,7 +994,8 @@ static int get_swap_reader(struct swap_map_handle *handle,
 			return -ENOMEM;
 		}
 
-		error = hib_submit_io(READ_SYNC, offset, tmp->map, NULL);
+		error = hib_submit_io(REQ_OP_READ, READ_SYNC, offset,
+				      tmp->map, NULL);
 		if (error) {
 			release_swap_reader(handle);
 			return error;
@@ -1017,7 +1019,7 @@ static int swap_read_page(struct swap_map_handle *handle, void *buf,
 	offset = handle->cur->entries[handle->k];
 	if (!offset)
 		return -EFAULT;
-	error = hib_submit_io(READ_SYNC, offset, buf, hb);
+	error = hib_submit_io(REQ_OP_READ, READ_SYNC, offset, buf, hb);
 	if (error)
 		return error;
 	if (++handle->k >= MAP_PAGE_ENTRIES) {
@@ -1526,7 +1528,8 @@ int swsusp_check(void)
 	if (!IS_ERR(hib_resume_bdev)) {
 		set_blocksize(hib_resume_bdev, PAGE_SIZE);
 		clear_page(swsusp_header);
-		error = hib_submit_io(READ_SYNC, swsusp_resume_block,
+		error = hib_submit_io(REQ_OP_READ, READ_SYNC,
+					swsusp_resume_block,
 					swsusp_header, NULL);
 		if (error)
 			goto put;
@@ -1534,7 +1537,8 @@ int swsusp_check(void)
 		if (!memcmp(HIBERNATE_SIG, swsusp_header->sig, 10)) {
 			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
 			/* Reset swap signature now */
-			error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
+			error = hib_submit_io(REQ_OP_WRITE, WRITE_SYNC,
+						swsusp_resume_block,
 						swsusp_header, NULL);
 		} else {
 			error = -EINVAL;
@@ -1578,10 +1582,12 @@ int swsusp_unmark(void)
 {
 	int error;
 
-	hib_submit_io(READ_SYNC, swsusp_resume_block, swsusp_header, NULL);
+	hib_submit_io(REQ_OP_READ, READ_SYNC, swsusp_resume_block,
+		      swsusp_header, NULL);
 	if (!memcmp(HIBERNATE_SIG,swsusp_header->sig, 10)) {
 		memcpy(swsusp_header->sig,swsusp_header->orig_sig, 10);
-		error = hib_submit_io(WRITE_SYNC, swsusp_resume_block,
+		error = hib_submit_io(REQ_OP_WRITE, WRITE_SYNC,
+					swsusp_resume_block,
 					swsusp_header, NULL);
 	} else {
 		printk(KERN_ERR "PM: Cannot find swsusp signature!\n");
-- 
2.7.2
