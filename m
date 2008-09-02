From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/8] sg: rename sg_cmd_done sg_rq_end_io
Date: Tue,  2 Sep 2008 22:50:01 +0900
Message-ID: <1220363408-7134-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:56057 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYIBNwq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 09:52:46 -0400
In-Reply-To: <1220363408-7134-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp

old sg_rq_end_io() was used to wrap sg_cmd_done during converting sg
to use the block layer (in order to cover the difference
scsi_execute_async and blk_execute_rq_nowait). Now we don't need it so
let's remove it.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 50c07bc..d18f90d 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -177,7 +177,7 @@ typedef struct sg_device { /* holds the state of each scsi generic device */
 
 static int sg_fasync(int fd, struct file *filp, int mode);
 /* tasklet or soft irq callback */
-static void sg_cmd_done(void *data, char *sense, int result, int resid);
+static void sg_rq_end_io(struct request *rq, int uptodate);
 static int sg_start_req(Sg_request *srp, unsigned char *cmd);
 static void sg_finish_rem_req(Sg_request * srp);
 static int sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size);
@@ -227,11 +227,6 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
 				  cmd, filp->f_mode & FMODE_WRITE);
 }
 
-static void sg_rq_end_io(struct request *rq, int uptodate)
-{
-	sg_cmd_done(rq->end_io_data, rq->sense, rq->errors, rq->data_len);
-}
-
 static int
 sg_open(struct inode *inode, struct file *filp)
 {
@@ -1257,16 +1252,19 @@ sg_mmap(struct file *filp, struct vm_area_struct *vma)
 	return 0;
 }
 
-/* This function is a "bottom half" handler that is called by the
- * mid level when a command is completed (or has failed). */
-static void
-sg_cmd_done(void *data, char *sense, int result, int resid)
+/*
+ * This function is a "bottom half" handler that is called by the mid
+ * level when a command is completed (or has failed).
+ */
+static void sg_rq_end_io(struct request *rq, int uptodate)
 {
-	Sg_request *srp = data;
+	struct sg_request *srp = rq->end_io_data;
 	Sg_device *sdp = NULL;
 	Sg_fd *sfp;
 	unsigned long iflags;
 	unsigned int ms;
+	char *sense;
+	int result, resid;
 
 	if (NULL == srp) {
 		printk(KERN_ERR "sg_cmd_done: NULL request\n");
@@ -1280,6 +1278,9 @@ sg_cmd_done(void *data, char *sense, int result, int resid)
 		return;
 	}
 
+	sense = rq->sense;
+	result = rq->errors;
+	resid = rq->data_len;
 
 	SCSI_LOG_TIMEOUT(4, printk("sg_cmd_done: %s, pack_id=%d, res=0x%x\n",
 		sdp->disk->disk_name, srp->header.pack_id, result));
-- 
1.5.4.2

