From: mchristi@redhat.com
Subject: [PATCH 13/32] mm: prepare for bi_rw split
Date: Wed,  4 Nov 2015 16:08:10 -0600
Message-ID: <1446674909-5371-14-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This patch prepares mm's submit_bio use for the next
patches that split bi_rw into a operation and flags field.
Instead of passing in a bitmap with both the operation and
flags mixed in, the callers will now pass them in seperately.

This patch modifies the code related to the submit_bio calls
so the flags and operation are seperated. When this is done
for all code, one of the later patches in the series will
the actual submit_bio call, so the patches are bisectable.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 mm/page_io.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index b995a5b..ec7ad22 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -253,7 +253,8 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		bio_end_io_t end_write_func)
 {
 	struct bio *bio;
-	int ret, rw = WRITE;
+	int ret;
+	u32 op_flags = 0;
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	if (sis->flags & SWP_FILE) {
@@ -312,11 +313,11 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		goto out;
 	}
 	if (wbc->sync_mode == WB_SYNC_ALL)
-		rw |= REQ_SYNC;
+		op_flags |= REQ_SYNC;
 	count_vm_event(PSWPOUT);
 	set_page_writeback(page);
 	unlock_page(page);
-	submit_bio(rw, bio);
+	submit_bio(REQ_OP_WRITE | op_flags, bio);
 out:
 	return ret;
 }
-- 
1.8.3.1
