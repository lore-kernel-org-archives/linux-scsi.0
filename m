From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 8/8] sg: remove unnecessary blk_rq_unmap_user
Date: Tue,  2 Sep 2008 22:50:08 +0900
Message-ID: <1220363408-7134-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50960 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbYIBNx1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 09:53:27 -0400
In-Reply-To: <1220363408-7134-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

blk_rq_unmap_user in sg_finish_rem_req can take care of all the cases.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index df8bf67..ba9b9bb 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -522,10 +522,6 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 		err = -EFAULT;
 		goto err_out;
 	}
-	if (srp->bio) {
-		err = blk_rq_unmap_user(srp->bio);
-		srp->bio = NULL;
-	}
 err_out:
 	sg_finish_rem_req(srp);
 	return (0 == err) ? count : err;
@@ -1844,9 +1840,6 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 	if ((!outp) || (num_read_xfer <= 0))
 		return 0;
 
-	blk_rq_unmap_user(srp->bio);
-	srp->bio = NULL;
-
 	num = 1 << (PAGE_SHIFT + schp->page_order);
 	for (k = 0; k < schp->k_use_sg && schp->pages[k]; k++) {
 		if (num > num_read_xfer) {
-- 
1.5.4.2

