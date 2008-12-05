From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 05/12] st: convert do_load_unload to use st_scsi_kern_execute
Date: Fri,  5 Dec 2008 15:25:24 +0900
Message-ID: <1228458331-8500-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53444 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbYLEGZj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:39 -0500
In-Reply-To: <1228458331-8500-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in do_load_unload (START STOP) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e08b31b..2b5524f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2507,13 +2507,16 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
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
 
@@ -2532,6 +2535,8 @@ static int do_load_unload(struct scsi_tape *STp, struct file *filp, int load_cod
 		STps = &(STp->ps[STp->partition]);
 		STps->drv_file = STps->drv_block = (-1);
 	}
+out:
+	st_release_request(SRpnt);
 
 	return retval;
 }
-- 
1.5.5.GIT

