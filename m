From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/6] scsi tgt: kill length alignment test in bin_map_user
Date: Thu, 16 Feb 2006 13:53:37 -0600
Message-ID: <1140119617.20193.49.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47776 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030474AbWBPTyF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2006 14:54:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

Subject: [PATCH] block layer: kill length alignment test in bin_map_user

The tgt project is mapping in bios using bio_map_user. The current targets
do not need their len to be aligned with a queue limit so this check is
causing some problems. Note: pointers passed into the kernel are properly
aligned by usersapace tgt code so the uaddr check in bio_map_user is ok.


The major user, blk_bio_map_user checks for the len before mapping
so it is not affected by this patch.

And the semi-newly added user blk_rq_map_user_iov has been failing
out when the len is not aligned properly so maybe people have been
good and not sending misaligned lens or that path is not used very
often and this change will not be very dangerous. st and sg do not
check the length and we have not seen any problem reports from those
wider used paths so this patch should be fairly safe - for mm 
and wider testing at least.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

---

 fs/bio.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

8e515bd33c31c8dc5e9727792d2c3cbe08bc28e1
diff --git a/fs/bio.c b/fs/bio.c
index 1f3bb50..d8259d9 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -620,10 +620,9 @@ static struct bio *__bio_map_user_iov(re
 
 		nr_pages += end - start;
 		/*
-		 * transfer and buffer must be aligned to at least hardsector
-		 * size for now, in the future we can relax this restriction
+		 * buffer must be aligned to at least hardsector size for now
 		 */
-		if ((uaddr & queue_dma_alignment(q)) || (len & queue_dma_alignment(q)))
+		if (uaddr & queue_dma_alignment(q))
 			return ERR_PTR(-EINVAL);
 	}
 
-- 
1.1.3


