From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 04/12] st: convert set_location to use st_scsi_kern_execute
Date: Fri,  5 Dec 2008 15:25:23 +0900
Message-ID: <1228458331-8500-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53425 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbYLEGZj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:39 -0500
In-Reply-To: <1228458331-8500-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in set_location (LOCATE 10) with
st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index a9247a6..e08b31b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3079,10 +3079,14 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
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
@@ -3107,7 +3111,7 @@ static int set_location(struct scsi_tape *STp, unsigned int block, int partition
 			STps->drv_block = STps->drv_file = 0;
 		result = 0;
 	}
-
+out:
 	st_release_request(SRpnt);
 	SRpnt = NULL;
 
-- 
1.5.5.GIT

