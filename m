From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH block#for-2.6.31 3/3] bio: always copy back data for copied
 kernel requests
Date: Sat, 16 May 2009 00:19:19 +0900
Message-ID: <4A0D87F7.8090401__42344.3728396252$1242400827$gmane$org@gmail.com>
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:34251 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbZEOPTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2009 11:19:22 -0400
In-Reply-To: <4A0D87D2.7090806@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Boaz Harrosh <bharrosh@panasas.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-s

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
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: block/fs/bio.c
===================================================================
--- block.orig/fs/bio.c
+++ block/fs/bio.c
@@ -1198,7 +1198,7 @@ static void bio_copy_kern_endio(struct b
 		char *addr = page_address(bvec->bv_page);
 		int len = bmd->iovecs[i].bv_len;
 
-		if (read && !err)
+		if (read)
 			memcpy(p, addr, len);
 
 		__free_page(bvec->bv_page);
