From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 09/12] st: convert read_mode_page to use st_scsi_kern_execute
Date: Fri,  5 Dec 2008 15:25:28 +0900
Message-ID: <1228458331-8500-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53443 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbYLEGZj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:39 -0500
In-Reply-To: <1228458331-8500-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in read_mode_page (MODE_SENSE) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index bbf431a..9d4ec54 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2366,7 +2366,8 @@ static int st_set_options(struct scsi_tape *STp, long options)
 static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 {
 	unsigned char cmd[MAX_COMMAND_SIZE];
-	struct st_request *SRpnt = NULL;
+	struct st_request *SRpnt;
+	int ret;
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = MODE_SENSE;
@@ -2375,14 +2376,16 @@ static int read_mode_page(struct scsi_tape *STp, int page, int omit_block_descs)
 	cmd[2] = page;
 	cmd[4] = 255;
 
-	SRpnt = st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE,
-			   STp->device->timeout, 0, 1);
-	if (SRpnt == NULL)
-		return (STp->buffer)->syscall_result;
+	SRpnt = st_allocate_request(STp);
+	if (!SRpnt)
+		return STp->buffer->syscall_result;
 
+	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_FROM_DEVICE,
+				   STp->buffer->b_data, cmd[4],
+				   STp->device->timeout, MAX_RETRIES);
 	st_release_request(SRpnt);
 
-	return (STp->buffer)->syscall_result;
+	return ret ? : STp->buffer->syscall_result;
 }
 
 
-- 
1.5.5.GIT

