From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/3] bio: always copy back data for copied kernel requests
Date: Tue, 19 May 2009 18:33:06 +0900
Message-ID: <1242725586-13142-4-git-send-email-tj@kernel.org>
References: <1242725586-13142-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755649AbZESJd4@vger.kernel.org>
In-Reply-To: <1242725586-13142-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, zaitcev@
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

When a read bio_copy_kern() request fails, the content of the bounce
buffer is not copied back.  However, as request failure doesn't
necessarily mean complete failure, the buffer state can be useful.
This behavior is also inconsistent with the user map counterpart and
causes the subtle difference between bounced and unbounced IO causes
confusion.

This patch makes bio_copy_kern_endio() ignore @err and always copy
back data on request completion.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 fs/bio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 7bbc98f..ee3bc67 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1198,7 +1198,7 @@ static void bio_copy_kern_endio(struct bio *bio, int err)
 		char *addr = page_address(bvec->bv_page);
 		int len = bmd->iovecs[i].bv_len;
 
-		if (read && !err)
+		if (read)
 			memcpy(p, addr, len);
 
 		__free_page(bvec->bv_page);
-- 
1.6.0.2
