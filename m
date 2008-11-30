From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 03/11] st: convert test_ready to use st_scsi_kern_execute
Date: Sun, 30 Nov 2008 17:07:57 +0900
Message-ID: <1228032485-10328-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:38641 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbYK3IWF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 03:22:05 -0500
In-Reply-To: <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in test_ready (TEST_UNIT_READY) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 6179940..72b4b44 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -899,21 +899,24 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
 	int attentions, waits, max_wait, scode;
 	int retval = CHKRES_READY, new_session = 0;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt = NULL;
+	struct st_request *SRpnt;
 	struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
 
+	SRpnt = st_allocate_request(STp);
+	if (!SRpnt)
+		return STp->buffer->syscall_result;
+
 	max_wait = do_wait ? ST_BLOCK_SECONDS : 0;
 
 	for (attentions=waits=0; ; ) {
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] = TEST_UNIT_READY;
-		SRpnt = st_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-				   STp->long_timeout, MAX_READY_RETRIES, 1);
 
-		if (!SRpnt) {
-			retval = (STp->buffer)->syscall_result;
+		retval = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0,
+					      STp->long_timeout,
+					      MAX_READY_RETRIES);
+		if (retval)
 			break;
-		}
 
 		if (cmdstatp->have_sense) {
 
@@ -957,8 +960,8 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
 		break;
 	}
 
-	if (SRpnt != NULL)
-		st_release_request(SRpnt);
+	st_release_request(SRpnt);
+
 	return retval;
 }
 
-- 
1.5.6.5

