From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 07/12] st: convert st_flush to use st_scsi_kern_execute
Date: Fri,  5 Dec 2008 15:25:26 +0900
Message-ID: <1228458331-8500-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53435 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbYLEGZj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:39 -0500
In-Reply-To: <1228458331-8500-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in st_flush (WRITE FILEMARKS) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9acbe33..49dc247 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1284,10 +1284,17 @@ static int st_flush(struct file *filp, fl_owner_t id)
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
1.5.5.GIT

