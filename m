From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 15/16] st: integrate st_scsi_kern_execute and st_do_scsi
Date: Thu, 18 Dec 2008 14:49:50 +0900
Message-ID: <1229579391-28753-16-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-13-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-14-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-15-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46390 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbYLRGIx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 01:08:53 -0500
In-Reply-To: <1229579391-28753-15-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.c, linux-scsi@vger.kernel.org

From: Kai Makisara <Kai.Makisara@kolumbus.fi>

This integrates st_scsi_kern_execute and st_do_scsi. IOW, it removes
st_scsi_kern_execute. Then st has a single function, st_do_scsi, to
perform SCSI commands.

Signed-off-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c |  202 +++++++++++++++++-----------------------------------
 1 files changed, 66 insertions(+), 136 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index fe4c202..ddf2630 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static const char *verstr = "20080504";
+static const char *verstr = "20081215";
 
 #include <linux/module.h>
 
@@ -491,10 +491,13 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 
 	mdata->null_mapped = 1;
 
-	err = blk_rq_map_user(req->q, req, mdata, NULL, bufflen, GFP_KERNEL);
-	if (err) {
-		blk_put_request(req);
-		return DRIVER_ERROR << 24;
+	if (bufflen) {
+		err = blk_rq_map_user(req->q, req, mdata, NULL, bufflen,
+				      GFP_KERNEL);
+		if (err) {
+			blk_put_request(req);
+			return DRIVER_ERROR << 24;
+		}
 	}
 
 	SRpnt->bio = req->bio;
@@ -577,28 +580,6 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 	return SRpnt;
 }
 
-static int st_scsi_kern_execute(struct st_request *streq,
-				const unsigned char *cmd, int data_direction,
-				void *buffer, unsigned bufflen, int timeout,
-				int retries)
-{
-	struct scsi_tape *stp = streq->stp;
-	int ret, resid;
-
-	stp->buffer->cmdstat.have_sense = 0;
-	memcpy(streq->cmd, cmd, sizeof(streq->cmd));
-
-	ret = scsi_execute(stp->device, cmd, data_direction, buffer, bufflen,
-			   streq->sense, timeout, retries, 0, &resid);
-	if (driver_byte(ret) & DRIVER_ERROR)
-		return -EBUSY;
-
-	stp->buffer->cmdstat.midlevel_result = streq->result = ret;
-	stp->buffer->cmdstat.residual = resid;
-	stp->buffer->syscall_result = st_chk_result(stp, streq);
-
-	return 0;
-}
 
 /* Handle the write-behind checking (waits for completion). Returns -ENOSPC if
    write has been correct but EOM early warning reached, -EIO if write ended in
@@ -671,7 +652,6 @@ static int cross_eof(struct scsi_tape * STp, int forward)
 {
 	struct st_request *SRpnt;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	int ret;
 
 	cmd[0] = SPACE;
 	cmd[1] = 0x01;		/* Space FileMarks */
@@ -685,26 +665,20 @@ static int cross_eof(struct scsi_tape * STp, int forward)
         DEBC(printk(ST_DEB_MSG "%s: Stepping over filemark %s.\n",
 		   tape_name(STp), forward ? "forward" : "backward"));
 
-	SRpnt = st_allocate_request(STp);
+	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
+			   STp->device->request_queue->rq_timeout,
+			   MAX_RETRIES, 1);
 	if (!SRpnt)
-		return STp->buffer->syscall_result;
-
-	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0,
-				   STp->device->request_queue->rq_timeout,
-				   MAX_RETRIES);
-	if (ret)
-		goto out;
+		return (STp->buffer)->syscall_result;
 
-	ret = STp->buffer->syscall_result;
+	st_release_request(SRpnt);
+	SRpnt = NULL;
 
 	if ((STp->buffer)->cmdstat.midlevel_result != 0)
 		printk(KERN_ERR "%s: Stepping over filemark %s failed.\n",
 		   tape_name(STp), forward ? "forward" : "backward");
 
-out:
-	st_release_request(SRpnt);
-
-	return ret;
+	return (STp->buffer)->syscall_result;
 }
 
 
@@ -925,24 +899,21 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
 	int attentions, waits, max_wait, scode;
 	int retval = CHKRES_READY, new_session = 0;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt;
+	struct st_request *SRpnt = NULL;
 	struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
-	SRpnt = st_allocate_request(STp);
-	if (!SRpnt)
-		return STp->buffer->syscall_result;
-
 	max_wait = do_wait ? ST_BLOCK_SECONDS : 0;
 
 	for (attentions=waits=0; ; ) {
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] = TEST_UNIT_READY;
+		SRpnt = st_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
+				   STp->long_timeout, MAX_READY_RETRIES, 1);
 
-		retval = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0,
-					      STp->long_timeout,
-					      MAX_READY_RETRIES);
-		if (retval)
+		if (!SRpnt) {
+			retval = (STp->buffer)->syscall_result;
 			break;
+		}
 
 		if (cmdstatp->have_sense) {
 
@@ -986,8 +957,8 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
 		break;
 	}
 
-	st_release_request(SRpnt);
-
+	if (SRpnt != NULL)
+		st_release_request(SRpnt);
 	return retval;
 }
 
@@ -1064,24 +1035,17 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 		}
 	}
 
-	SRpnt = st_allocate_request(STp);
-	if (!SRpnt) {
-		retval = STp->buffer->syscall_result;
-		goto err_out;
-	}
-
 	if (STp->omit_blklims)
 		STp->min_block = STp->max_block = (-1);
 	else {
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] = READ_BLOCK_LIMITS;
 
-		retval = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
-					      STp->buffer->b_data, 6,
-					      STp->device->request_queue->rq_timeout,
-					      MAX_READY_RETRIES);
-		if (retval) {
-			st_release_request(SRpnt);
+		SRpnt = st_do_scsi(SRpnt, STp, cmd, 6, DMA_FROM_DEVICE,
+				   STp->device->request_queue->rq_timeout,
+				   MAX_READY_RETRIES, 1);
+		if (!SRpnt) {
+			retval = (STp->buffer)->syscall_result;
 			goto err_out;
 		}
 
@@ -1105,12 +1069,11 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 	cmd[0] = MODE_SENSE;
 	cmd[4] = 12;
 
-	retval = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
-				      STp->buffer->b_data, 12,
-				      STp->device->request_queue->rq_timeout,
-				      MAX_READY_RETRIES);
-	if (retval) {
-		st_release_request(SRpnt);
+	SRpnt = st_do_scsi(SRpnt, STp, cmd, 12, DMA_FROM_DEVICE,
+			   STp->device->request_queue->rq_timeout,
+			   MAX_READY_RETRIES, 1);
+	if (!SRpnt) {
+		retval = (STp->buffer)->syscall_result;
 		goto err_out;
 	}
 
@@ -1340,17 +1303,11 @@ static int st_flush(struct file *filp, fl_owner_t id)
 		cmd[0] = WRITE_FILEMARKS;
 		cmd[4] = 1 + STp->two_fm;
 
-		SRpnt = st_allocate_request(STp);
+		SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
+				   STp->device->request_queue->rq_timeout,
+				   MAX_WRITE_RETRIES, 1);
 		if (!SRpnt) {
-			result = STp->buffer->syscall_result;
-			goto out;
-		}
-
-		result = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0,
-					      STp->device->request_queue->rq_timeout,
-					      MAX_WRITE_RETRIES);
-		if (result) {
-			st_release_request(SRpnt);
+			result = (STp->buffer)->syscall_result;
 			goto out;
 		}
 
@@ -2415,7 +2372,6 @@ static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 {
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct st_request *SRpnt;
-	int ret;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SENSE;
@@ -2424,17 +2380,14 @@ static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 	cmd[2] = page;
 	cmd[4] = 255;
 
-	SRpnt = st_allocate_request(STp);
-	if (!SRpnt)
-		return STp->buffer->syscall_result;
+	SRpnt = st_do_scsi(NULL, STp, cmd, cmd[4], DMA_FROM_DEVICE,
+			   STp->device->request_queue->rq_timeout, 0, 1);
+	if (SRpnt == NULL)
+		return (STp->buffer)->syscall_result;
 
-	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
-				   STp->buffer->b_data, cmd[4],
-				   STp->device->request_queue->rq_timeout,
-				   MAX_RETRIES);
 	st_release_request(SRpnt);
 
-	return ret ? : STp->buffer->syscall_result;
+	return STp->buffer->syscall_result;
 }
 
 
@@ -2442,9 +2395,10 @@ static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
    in the buffer is correctly formatted. The long timeout is used if slow is non-zero. */
 static int write_mode_page(struct scsi_tape *STp, int page, int slow)
 {
-	int pgo, timeout, ret = 0;
+	int pgo;
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct st_request *SRpnt;
+	int timeout;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SELECT;
@@ -2458,21 +2412,16 @@ static int write_mode_page(struct scsi_tape *STp, int page, int slow)
 	(STp->buffer)->b_data[MH_OFF_DEV_SPECIFIC] &= ~MH_BIT_WP;
 	(STp->buffer)->b_data[pgo + MP_OFF_PAGE_NBR] &= MP_MSK_PAGE_NBR;
 
-	SRpnt = st_allocate_request(STp);
-	if (!SRpnt)
-		return ret;
-
-	timeout = slow ? STp->long_timeout :
-		STp->device->request_queue->rq_timeout;
-
-	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_TO_DEVICE,
-				   STp->buffer->b_data, cmd[4], timeout, 0);
-	if (!ret)
-		ret = STp->buffer->syscall_result;
+	timeout = slow ?
+		STp->long_timeout : STp->device->request_queue->rq_timeout;
+	SRpnt = st_do_scsi(NULL, STp, cmd, cmd[4], DMA_TO_DEVICE,
+			   timeout, 0, 1);
+	if (SRpnt == NULL)
+		return (STp->buffer)->syscall_result;
 
 	st_release_request(SRpnt);
 
-	return ret;
+	return STp->buffer->syscall_result;
 }
 
 
@@ -2590,16 +2539,13 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 		printk(ST_DEB_MSG "%s: Loading tape.\n", name);
 		);
 
-	SRpnt = st_allocate_request(STp);
+	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
+			   timeout, MAX_RETRIES, 1);
 	if (!SRpnt)
-		return STp->buffer->syscall_result;
-
-	retval = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0, timeout,
-				      MAX_RETRIES);
-	if (retval)
-		goto out;
+		return (STp->buffer)->syscall_result;
 
 	retval = (STp->buffer)->syscall_result;
+	st_release_request(SRpnt);
 
 	if (!retval) {	/* SCSI command successful */
 
@@ -2618,8 +2564,6 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 		STps = &(STp->ps[STp->partition]);
 		STps->drv_file = STps->drv_block = (-1);
 	}
-out:
-	st_release_request(SRpnt);
 
 	return retval;
 }
@@ -2895,15 +2839,12 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		return (-ENOSYS);
 	}
 
-	SRpnt = st_allocate_request(STp);
+	SRpnt = st_do_scsi(NULL, STp, cmd, datalen, direction,
+			   timeout, MAX_RETRIES, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
-	ioctl_result = st_scsi_kern_execute(SRpnt, cmd, direction,
-					    STp->buffer->b_data, datalen,
-					    timeout, MAX_RETRIES);
-	if (!ioctl_result)
-		ioctl_result = (STp->buffer)->syscall_result;
+	ioctl_result = (STp->buffer)->syscall_result;
 
 	if (!ioctl_result) {	/* SCSI command successful */
 		st_release_request(SRpnt);
@@ -3065,17 +3006,11 @@ static int get_location(struct scsi_tape *STp, unsigned int *block, int *partiti
 		if (!logical && !STp->scsi2_logical)
 			scmd[1] = 1;
 	}
-
-	SRpnt = st_allocate_request(STp);
+	SRpnt = st_do_scsi(NULL, STp, scmd, 20, DMA_FROM_DEVICE,
+			   STp->device->request_queue->rq_timeout,
+			   MAX_READY_RETRIES, 1);
 	if (!SRpnt)
-		return STp->buffer->syscall_result;
-
-	result = st_scsi_kern_execute(SRpnt, scmd, DMA_FROM_DEVICE,
-				      STp->buffer->b_data, 20,
-				      STp->device->request_queue->rq_timeout,
-				      MAX_READY_RETRIES);
-	if (result)
-		goto out;
+		return (STp->buffer)->syscall_result;
 
 	if ((STp->buffer)->syscall_result != 0 ||
 	    (STp->device->scsi_level >= SCSI_2 &&
@@ -3103,7 +3038,6 @@ static int get_location(struct scsi_tape *STp, unsigned int *block, int *partiti
                 DEBC(printk(ST_DEB_MSG "%s: Got tape pos. blk %d part %d.\n", name,
                             *block, *partition));
 	}
-out:
 	st_release_request(SRpnt);
 	SRpnt = NULL;
 
@@ -3178,14 +3112,10 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 		timeout = STp->device->request_queue->rq_timeout;
 	}
 
-	SRpnt = st_allocate_request(STp);
+	SRpnt = st_do_scsi(NULL, STp, scmd, 0, DMA_NONE,
+			   timeout, MAX_READY_RETRIES, 1);
 	if (!SRpnt)
-		return STp->buffer->syscall_result;
-
-	result = st_scsi_kern_execute(SRpnt, scmd, DMA_NONE, NULL, 0,
-				      timeout, MAX_READY_RETRIES);
-	if (result)
-		goto out;
+		return (STp->buffer)->syscall_result;
 
 	STps->drv_block = STps->drv_file = (-1);
 	STps->eof = ST_NOEOF;
@@ -3210,7 +3140,7 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 			STps->drv_block = STps->drv_file = 0;
 		result = 0;
 	}
-out:
+
 	st_release_request(SRpnt);
 	SRpnt = NULL;
 
-- 
1.5.6.5

