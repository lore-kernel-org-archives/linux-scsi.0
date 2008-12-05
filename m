From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 08/12] st: convert check_tape to use st_scsi_kern_execute
Date: Fri,  5 Dec 2008 15:25:27 +0900
Message-ID: <1228458331-8500-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53434 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbYLEGZj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:39 -0500
In-Reply-To: <1228458331-8500-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in check_tape (READ_BLOCK_LIMITS and
MODE_SENSE) with st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 49dc247..bbf431a 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1018,16 +1018,24 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
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
 
@@ -1051,10 +1059,12 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
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
1.5.5.GIT

