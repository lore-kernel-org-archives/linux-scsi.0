From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 10/12] st: convert write_mode_page to use st_scsi_kern_execute
Date: Fri,  5 Dec 2008 15:25:29 +0900
Message-ID: <1228458331-8500-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53446 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbYLEGZk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:40 -0500
In-Reply-To: <1228458331-8500-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in write_mode_page (MODE_SELECT) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9d4ec54..61f5b1e 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2393,9 +2393,9 @@ static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
    in the buffer is correctly formatted. The long timeout is used if slow is non-zero. */
 static int write_mode_page(struct scsi_tape *STp, int page, int slow)
 {
-	int pgo;
+	int pgo, timeout, ret = 0;
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt = NULL;
+	struct st_request *SRpnt;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SELECT;
@@ -2409,14 +2409,20 @@ static int write_mode_page(struct scsi_tape *STp, int page, int slow)
 	(STp->buffer)->b_data[MH_OFF_DEV_SPECIFIC] &= ~MH_BIT_WP;
 	(STp->buffer)->b_data[pgo + MP_OFF_PAGE_NBR] &= MP_MSK_PAGE_NBR;
 
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE,
-			   (slow ? STp->long_timeout : STp->device->timeout), 0, 1);
-	if (SRpnt == NULL)
-		return (STp->buffer)->syscall_result;
+	SRpnt = st_allocate_request(STp);
+	if (!SRpnt)
+		return ret;
+
+	timeout = slow ? STp->long_timeout : STp->device->timeout;
+
+	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_TO_DEVICE,
+				   STp->buffer->b_data, cmd[4], timeout, 0);
+	if (!ret)
+		ret = STp->buffer->syscall_result;
 
 	st_release_request(SRpnt);
 
-	return (STp->buffer)->syscall_result;
+	return ret;
 }
 
 
-- 
1.5.5.GIT

