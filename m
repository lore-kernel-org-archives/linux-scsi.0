From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sg: return EFAULT for an invalid user address
Date: Sat, 4 Apr 2009 00:35:42 +0900
Message-ID: <20090404003430M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:50122 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759701AbZDCPfv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 11:35:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org

Hopefully, This is the last fix for the fallout of the block layer
conversion...

This should be go into 2.6.28.y and 2.6.29.y with the other sg fixes.

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] sg: return EFAULT for an invalid user address

blk_rq_unmap_user() returns EFAULT if a program passes an invalid
address to kernel (the kernel fails to copy data to user space). sg
needs to pass the returned value to user space instead of ignoring
it. Before the block layer conversion, sg returns EFAULT
properly. This restores the old behavior.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 1e40518..f80683a 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -179,7 +179,7 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 /* tasklet or soft irq callback */
 static void sg_rq_end_io(struct request *rq, int uptodate);
 static int sg_start_req(Sg_request *srp, unsigned char *cmd);
-static void sg_finish_rem_req(Sg_request * srp);
+static int sg_finish_rem_req(Sg_request * srp);
 static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
 static ssize_t sg_new_read(Sg_fd * sfp, char __user *buf, size_t count,
 			   Sg_request * srp);
@@ -518,7 +518,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 		goto err_out;
 	}
 err_out:
-	sg_finish_rem_req(srp);
+	err = sg_finish_rem_req(srp);
 	return (0 == err) ? count : err;
 }
 
@@ -1694,9 +1694,10 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 	return res;
 }
 
-static void
-sg_finish_rem_req(Sg_request * srp)
+static int sg_finish_rem_req(Sg_request * srp)
 {
+	int ret = 0;
+
 	Sg_fd *sfp = srp->parentfp;
 	Sg_scatter_hold *req_schp = &srp->data;
 
@@ -1708,12 +1709,14 @@ sg_finish_rem_req(Sg_request * srp)
 
 	if (srp->rq) {
 		if (srp->bio)
-			blk_rq_unmap_user(srp->bio);
+			ret = blk_rq_unmap_user(srp->bio);
 
 		blk_put_request(srp->rq);
 	}
 
 	sg_remove_request(sfp, srp);
+
+	return ret;
 }
 
 static int
-- 
1.6.0.6

