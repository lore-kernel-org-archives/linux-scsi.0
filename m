From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/8] block: kill length alignment test in bio_map_user
Date: Thu, 16 Nov 2006 19:24:00 +0900
Message-ID: <20061116192400S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:18050 "EHLO
	tama55.ecl.ntt.co.jp") by vger.kernel.org with ESMTP
	id S1423592AbWKPKYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Nov 2006 05:24:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com

The target mode support is mapping in bios using bio_map_user. The
current targets do not need their len to be aligned with a queue limit
so this check is causing some problems. Note: pointers passed into the
kernel are properly aligned by usersapace tgt code so the uaddr check
in bio_map_user is ok.

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
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
---
 fs/bio.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index f95c874..d91cfbf 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -622,10 +622,9 @@ static struct bio *__bio_map_user_iov(re
 
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
1.4.3.2

