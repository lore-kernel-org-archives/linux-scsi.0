From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 04/11] st: convert set_location to use st_scsi_kern_execute
Date: Sun, 30 Nov 2008 17:07:58 +0900
Message-ID: <1228032485-10328-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228032485-10328-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228032485-10328-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:38561 "EHLO
	mfo10.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYK3IRV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Nov 2008 03:17:21 -0500
In-Reply-To: <1228032485-10328-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in set_location (LOCATE 10) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 72b4b44..cce4358 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3106,10 +3106,14 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 		timeout = STp->device->timeout;
 	}
 
-	SRpnt = st_do_scsi(NULL, STp, scmd, 0, DMA_NONE,
-			   timeout, MAX_READY_RETRIES, 1);
+	SRpnt = st_allocate_request(STp);
 	if (!SRpnt)
-		return (STp->buffer)->syscall_result;
+		return STp->buffer->syscall_result;
+
+	result = st_scsi_kern_execute(SRpnt, scmd, DMA_NONE, NULL, 0,
+				      timeout, MAX_READY_RETRIES);
+	if (result)
+		goto out;
 
 	STps->drv_block = STps->drv_file = (-1);
 	STps->eof = ST_NOEOF;
@@ -3134,7 +3138,7 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 			STps->drv_block = STps->drv_file = 0;
 		result = 0;
 	}
-
+out:
 	st_release_request(SRpnt);
 	SRpnt = NULL;
 
-- 
1.5.6.5

