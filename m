From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 07/11] st: convert st_flush to use st_scsi_kern_execute
Date: Sun, 30 Nov 2008 17:08:01 +0900
Message-ID: <1228032485-10328-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:38621 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYK3ISt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 03:18:49 -0500
In-Reply-To: <1228032485-10328-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in st_flush (WRITE FILEMARKS) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 4bfdc96..43651cd 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1311,10 +1311,17 @@ static int st_flush(struct file *filp, fl_owner_t id)
 		cmd[0] = WRITE_FILEMARKS;
 		cmd[4] = 1 + STp->two_fm;
 
-		SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, 1);
+		SRpnt = st_allocate_request(STp);
 		if (!SRpnt) {
-			result = (STp->buffer)->syscall_result;
+			result = STp->buffer->syscall_result;
+			goto out;
+		}
+
+		result = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0,
+					      STp->device->timeout,
+					      MAX_WRITE_RETRIES);
+		if (result) {
+			st_release_request(SRpnt);
 			goto out;
 		}
 
-- 
1.5.6.5

