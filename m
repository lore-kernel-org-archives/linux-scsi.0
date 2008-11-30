From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 11/11] st: convert get_location to use st_scsi_kern_execute
Date: Sun, 30 Nov 2008 17:08:05 +0900
Message-ID: <1228032485-10328-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo11.iij4u.or.jp ([210.138.174.81]:38640 "EHLO
	mfo11.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYK3IWF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 03:22:05 -0500
In-Reply-To: <1228032485-10328-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in get_location (READ_POSITION) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 6fbfe33..f026398 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3042,10 +3042,16 @@ static int get_location(struct scsi_tape *STp, unsigned int *block, int *partiti
 		if (!logical && !STp->scsi2_logical)
 			scmd[1] = 1;
 	}
-	SRpnt = st_do_scsi(NULL, STp, scmd, 20, DMA_FROM_DEVICE,
-			STp->device->timeout, MAX_READY_RETRIES, 1);
+
+	SRpnt = st_allocate_request(STp);
 	if (!SRpnt)
-		return (STp->buffer)->syscall_result;
+		return STp->buffer->syscall_result;
+
+	result = st_scsi_kern_execute(SRpnt, scmd, DMA_FROM_DEVICE,
+				      STp->buffer->b_data, 20,
+				      STp->device->timeout, MAX_READY_RETRIES);
+	if (result)
+		goto out;
 
 	if ((STp->buffer)->syscall_result != 0 ||
 	    (STp->device->scsi_level >= SCSI_2 &&
@@ -3073,6 +3079,7 @@ static int get_location(struct scsi_tape *STp, unsigned int *block, int *partiti
                 DEBC(printk(ST_DEB_MSG "%s: Got tape pos. blk %d part %d.\n", name,
                             *block, *partition));
 	}
+out:
 	st_release_request(SRpnt);
 	SRpnt = NULL;
 
-- 
1.5.6.5

