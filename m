From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 05/11] st: convert do_load_unload to use st_scsi_kern_execute
Date: Sun, 30 Nov 2008 17:07:59 +0900
Message-ID: <1228032485-10328-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:38582 "EHLO
	mfo10.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYK3IU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 03:20:29 -0500
In-Reply-To: <1228032485-10328-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in do_load_unload (START STOP) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index cce4358..61ed6c1 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2534,13 +2534,16 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 		printk(ST_DEB_MSG "%s: Loading tape.\n", name);
 		);
 
-	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-			   timeout, MAX_RETRIES, 1);
+	SRpnt = st_allocate_request(STp);
 	if (!SRpnt)
-		return (STp->buffer)->syscall_result;
+		return STp->buffer->syscall_result;
+
+	retval = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0, timeout,
+				      MAX_RETRIES);
+	if (retval)
+		goto out;
 
 	retval = (STp->buffer)->syscall_result;
-	st_release_request(SRpnt);
 
 	if (!retval) {	/* SCSI command successful */
 
@@ -2559,6 +2562,8 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 		STps = &(STp->ps[STp->partition]);
 		STps->drv_file = STps->drv_block = (-1);
 	}
+out:
+	st_release_request(SRpnt);
 
 	return retval;
 }
-- 
1.5.6.5

