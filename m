From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sg: disable interrupts inside sg_copy_buffer
Date: Thu, 11 Sep 2008 23:52:29 +0900
Message-ID: <20080911235215U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:53640 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbYIKOwp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2008 10:52:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com

The callers of sg_copy_buffer must disable interrupts before calling
it (since it uses kmap_atomic). Some callers use it on
interrupt-disabled code but some need to take the trouble to disable
interrupts just for this. No wonder they forget about it and we hit a
bug like:

http://bugzilla.kernel.org/show_bug.cgi?id=11529

James said that it might be better to disable interrupts inside the
function rather than risk the callers getting it wrong.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/scatterlist.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index 876ba6d..dd52cd5 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -422,6 +422,9 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
 {
 	unsigned int offset = 0;
 	struct sg_mapping_iter miter;
+	unsigned long flags;
+
+	local_irq_save(flags);
 
 	sg_miter_start(&miter, sgl, nents, SG_MITER_ATOMIC);
 
@@ -442,6 +445,8 @@ static size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents,
 
 	sg_miter_stop(&miter);
 
+	local_irq_restore(flags);
+
 	return offset;
 }
 
-- 
1.5.4.2

