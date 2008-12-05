From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 06/12] st: convert cross_eof to use st_scsi_kern_execute
Date: Fri,  5 Dec 2008 15:25:25 +0900
Message-ID: <1228458331-8500-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53441 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbYLEGZj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:39 -0500
In-Reply-To: <1228458331-8500-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in cross_eof (SPACE) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 2b5524f..9acbe33 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -627,6 +627,7 @@ static int cross_eof(struct scsi_tape * STp, int forward)
 {
 	struct st_request *SRpnt;
 	unsigned char cmd[MAX_COMMAND_SIZE];
+	int ret;
 
 	cmd[0] = SPACE;
 	cmd[1] = 0x01;		/* Space FileMarks */
@@ -640,19 +641,25 @@ static int cross_eof(struct scsi_tape * STp, int forward)
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
1.5.5.GIT

