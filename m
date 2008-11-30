From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 08/11] st: convert check_tape to use st_scsi_kern_execute
Date: Sun, 30 Nov 2008 17:08:02 +0900
Message-ID: <1228032485-10328-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:38618 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbYK3ISt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 03:18:49 -0500
In-Reply-To: <1228032485-10328-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in check_tape (READ_BLOCK_LIMITS and
MODE_SENSE) with st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 43651cd..cc085bc 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1045,16 +1045,24 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 		}
 	}
 
+	SRpnt = st_allocate_request(STp);
+	if (!SRpnt) {
+		retval = STp->buffer->syscall_result;
+		goto err_out;
+	}
+
 	if (STp->omit_blklims)
 		STp->min_block = STp->max_block = (-1);
 	else {
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] = READ_BLOCK_LIMITS;
 
-		SRpnt = st_do_scsi(SRpnt, STp, cmd, 6, DMA_FROM_DEVICE,
-				   STp->device->timeout, MAX_READY_RETRIES, 1);
-		if (!SRpnt) {
-			retval = (STp->buffer)->syscall_result;
+		retval = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
+					      STp->buffer->b_data, 6,
+					      STp->device->timeout,
+					      MAX_READY_RETRIES);
+		if (retval) {
+			st_release_request(SRpnt);
 			goto err_out;
 		}
 
@@ -1078,10 +1086,12 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
 	cmd[0] = MODE_SENSE;
 	cmd[4] = 12;
 
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, 12, DMA_FROM_DEVICE,
-			STp->device->timeout, MAX_READY_RETRIES, 1);
-	if (!SRpnt) {
-		retval = (STp->buffer)->syscall_result;
+	retval = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
+				      STp->buffer->b_data, 12,
+				      STp->device->timeout,
+				      MAX_READY_RETRIES);
+	if (retval) {
+		st_release_request(SRpnt);
 		goto err_out;
 	}
 
-- 
1.5.6.5

