From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 7/8] sg: remove sg_read_xfer
Date: Tue,  2 Sep 2008 22:50:07 +0900
Message-ID: <1220363408-7134-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:56131 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbYIBNxj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 09:53:39 -0400
In-Reply-To: <1220363408-7134-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

sg_read_xfer was used to copy data to user space for READ
commands. blk_rq_unmap_user does the job so sg_read_xfer does nothing
useful.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   33 +++++----------------------------
 1 files changed, 5 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 07bd683..df8bf67 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -188,7 +188,6 @@ static ssize_t sg_new_write(Sg_fd *sfp, struct file *file,
 			int read_only, Sg_request **o_srp);
 static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			   unsigned char *cmnd, int timeout, int blocking);
-static int sg_read_xfer(Sg_request * srp);
 static int sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer);
 static void sg_remove_scat(Sg_scatter_hold * schp);
 static void sg_build_reserve(Sg_fd * sfp, int req_size);
@@ -523,8 +522,11 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
 		err = -EFAULT;
 		goto err_out;
 	}
-	err = sg_read_xfer(srp);
-      err_out:
+	if (srp->bio) {
+		err = blk_rq_unmap_user(srp->bio);
+		srp->bio = NULL;
+	}
+err_out:
 	sg_finish_rem_req(srp);
 	return (0 == err) ? count : err;
 }
@@ -1832,31 +1834,6 @@ sg_remove_scat(Sg_scatter_hold * schp)
 }
 
 static int
-sg_read_xfer(Sg_request * srp)
-{
-	sg_io_hdr_t *hp = &srp->header;
-	Sg_scatter_hold *schp = &srp->data;
-	int num_xfer = 0;
-	int dxfer_dir = hp->dxfer_direction;
-	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
-
-	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_FROM_DEV == dxfer_dir)
-	    || (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
-		num_xfer = hp->dxfer_len;
-		if (schp->bufflen < num_xfer)
-			num_xfer = schp->bufflen;
-	}
-	if ((num_xfer <= 0) || (schp->dio_in_use) ||
-	    (new_interface
-	     && ((SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO) & hp->flags)))
-		return 0;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_read_xfer: num_xfer=%d, iovec_count=%d, k_use_sg=%d\n",
-			  num_xfer, (int)hp->iovec_count, schp->k_use_sg));
-	return 0;
-}
-
-static int
 sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 {
 	Sg_scatter_hold *schp = &srp->data;
-- 
1.5.4.2

