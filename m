From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 09/11] st: convert read_mode_page to use st_scsi_kern_execute
Date: Sun, 30 Nov 2008 17:08:03 +0900
Message-ID: <1228032485-10328-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:38632 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYK3IWA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 03:22:00 -0500
In-Reply-To: <1228032485-10328-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in read_mode_page (MODE_SENSE) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index cc085bc..91d1249 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2393,7 +2393,8 @@ static int st_set_options(struct scsi_tape *STp, long options)
 static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 {
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt = NULL;
+	struct st_request *SRpnt;
+	int ret;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SENSE;
@@ -2402,10 +2403,15 @@ static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 	cmd[2] = page;
 	cmd[4] = 255;
 
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE,
-			   STp->device->timeout, 0, 1);
-	if (SRpnt == NULL)
-		return (STp->buffer)->syscall_result;
+	SRpnt = st_allocate_request(STp);
+	if (!SRpnt)
+		return STp->buffer->syscall_result;
+
+	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
+				   STp->buffer->b_data, cmd[4],
+				   STp->device->timeout, MAX_RETRIES);
+	if (ret)
+		return ret;
 
 	st_release_request(SRpnt);
 
-- 
1.5.6.5

