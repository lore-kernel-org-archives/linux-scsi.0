From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 6/8] sg: remove sg_write_xfer
Date: Tue,  2 Sep 2008 22:50:06 +0900
Message-ID: <1220363408-7134-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220363408-7134-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50910 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYIBNwt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 09:52:49 -0400
In-Reply-To: <1220363408-7134-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

sg_write_xfer was used to copy data from user space for WRITE
commands. blk_rq_map_user_iov and blk_rq_map_user do the job so
sg_write_xfer does nothing useful.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   32 --------------------------------
 1 files changed, 0 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c0b6866..07bd683 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -188,7 +188,6 @@ static ssize_t sg_new_write(Sg_fd *sfp, struct file *file,
 			int read_only, Sg_request **o_srp);
 static int sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			   unsigned char *cmnd, int timeout, int blocking);
-static int sg_write_xfer(Sg_request * srp);
 static int sg_read_xfer(Sg_request * srp);
 static int sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer);
 static void sg_remove_scat(Sg_scatter_hold * schp);
@@ -736,11 +735,6 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 		sg_finish_rem_req(srp);
 		return k;	/* probably out of space --> ENOMEM */
 	}
-	if ((k = sg_write_xfer(srp))) {
-		SCSI_LOG_TIMEOUT(1, printk("sg_common_write: write_xfer, bad address\n"));
-		sg_finish_rem_req(srp);
-		return k;
-	}
 	if (sdp->detached) {
 		sg_finish_rem_req(srp);
 		return -ENODEV;
@@ -1816,32 +1810,6 @@ out:
 	return -ENOMEM;
 }
 
-static int
-sg_write_xfer(Sg_request * srp)
-{
-	sg_io_hdr_t *hp = &srp->header;
-	Sg_scatter_hold *schp = &srp->data;
-	int num_xfer = 0;
-	int dxfer_dir = hp->dxfer_direction;
-	int new_interface = ('\0' == hp->interface_id) ? 0 : 1;
-
-	if ((SG_DXFER_UNKNOWN == dxfer_dir) || (SG_DXFER_TO_DEV == dxfer_dir) ||
-	    (SG_DXFER_TO_FROM_DEV == dxfer_dir)) {
-		num_xfer = (int) (new_interface ? hp->dxfer_len : hp->flags);
-		if (schp->bufflen < num_xfer)
-			num_xfer = schp->bufflen;
-	}
-	if ((num_xfer <= 0) || (schp->dio_in_use) ||
-	    (new_interface
-	     && ((SG_FLAG_NO_DXFER | SG_FLAG_MMAP_IO) & hp->flags)))
-		return 0;
-
-	SCSI_LOG_TIMEOUT(4, printk("sg_write_xfer: num_xfer=%d, k_use_sg=%d\n",
-			  num_xfer, schp->k_use_sg));
-
-	return 0;
-}
-
 static void
 sg_remove_scat(Sg_scatter_hold * schp)
 {
-- 
1.5.4.2

