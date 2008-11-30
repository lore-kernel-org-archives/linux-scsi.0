From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 06/11] st: convert cross_eof to use st_scsi_kern_execute
Date: Sun, 30 Nov 2008 17:08:00 +0900
Message-ID: <1228032485-10328-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:38564 "EHLO
	mfo10.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYK3IRY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 03:17:24 -0500
In-Reply-To: <1228032485-10328-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in cross_eof (SPACE) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 61ed6c1..4bfdc96 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -654,6 +654,7 @@ static int cross_eof(struct scsi_tape * STp, int forward)
 {
 	struct st_request *SRpnt;
 	unsigned char cmd[MAX_COMMAND_SIZE];
+	int ret;
 
 	cmd[0] = SPACE;
 	cmd[1] = 0x01;		/* Space FileMarks */
@@ -667,19 +668,25 @@ static int cross_eof(struct scsi_tape * STp, int forward)
         DEBC(printk(ST_DEB_MSG "%s: Stepping over filemark %s.\n",
 		   tape_name(STp), forward ? "forward" : "backward"));
 
-	SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-			   STp->device->timeout, MAX_RETRIES, 1);
+	SRpnt = st_allocate_request(STp);
 	if (!SRpnt)
-		return (STp->buffer)->syscall_result;
+		return STp->buffer->syscall_result;
 
-	st_release_request(SRpnt);
-	SRpnt = NULL;
+	ret = st_scsi_kern_execute(SRpnt, cmd, DMA_NONE, NULL, 0,
+				   STp->device->timeout, MAX_RETRIES);
+	if (ret)
+		goto out;
+
+	ret = STp->buffer->syscall_result;
 
 	if ((STp->buffer)->cmdstat.midlevel_result != 0)
 		printk(KERN_ERR "%s: Stepping over filemark %s failed.\n",
 		   tape_name(STp), forward ? "forward" : "backward");
 
-	return (STp->buffer)->syscall_result;
+out:
+	st_release_request(SRpnt);
+
+	return ret;
 }
 
 
-- 
1.5.6.5

