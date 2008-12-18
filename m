From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 07/16] st: convert non-dio path to use st_scsi_execute
Date: Thu, 18 Dec 2008 14:49:42 +0900
Message-ID: <1229579391-28753-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229579391-28753-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1229579391-28753-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46363 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYLRGIs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Dec 2008 01:08:48 -0500
In-Reply-To: <1229579391-28753-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.c, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This patch converts the non-dio path (fragment buffer path) to use
st_scsi_execute. IOW, it removes scsi_execute_async in the non-dio
path.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 084a967..390689d 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -537,6 +537,8 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 	   int bytes, int direction, int timeout, int retries, int do_wait)
 {
 	struct completion *waiting;
+	struct rq_map_data *mdata = &STp->buffer->map_data;
+	int ret;
 
 	/* if async, make sure there's no command outstanding */
 	if (!do_wait && ((STp->buffer)->last_SRpnt)) {
@@ -564,21 +566,34 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 	init_completion(waiting);
 	SRpnt->waiting = waiting;
 
-	if (!STp->buffer->do_dio)
+	if (!STp->buffer->do_dio) {
 		buf_to_sg(STp->buffer, bytes);
 
+		mdata->nr_entries =
+			DIV_ROUND_UP(bytes, PAGE_SIZE << mdata->page_order);
+		STp->buffer->map_data.pages = STp->buffer->reserved_pages;
+		STp->buffer->map_data.offset = 0;
+	}
+
 	memcpy(SRpnt->cmd, cmd, sizeof(SRpnt->cmd));
 	STp->buffer->cmdstat.have_sense = 0;
 	STp->buffer->syscall_result = 0;
 
-	if (scsi_execute_async(STp->device, cmd, COMMAND_SIZE(cmd[0]), direction,
-			&((STp->buffer)->sg[0]), bytes, (STp->buffer)->sg_segs,
-			       timeout, retries, SRpnt, st_sleep_done, GFP_KERNEL)) {
+	if (STp->buffer->do_dio)
+		ret = scsi_execute_async(STp->device, cmd, COMMAND_SIZE(cmd[0]),
+					 direction, &((STp->buffer)->sg[0]),
+					 bytes, (STp->buffer)->sg_segs, timeout,
+					 retries, SRpnt, st_sleep_done,
+					 GFP_KERNEL);
+	else
+		ret = st_scsi_execute(SRpnt, cmd, direction, NULL, bytes,
+				      timeout, retries);
+
+	if (ret) {
 		/* could not allocate the buffer or request was too large */
 		(STp->buffer)->syscall_result = (-EBUSY);
 		(STp->buffer)->last_SRpnt = NULL;
-	}
-	else if (do_wait) {
+	} else if (do_wait) {
 		wait_for_completion(waiting);
 		SRpnt->waiting = NULL;
 		(STp->buffer)->syscall_result = st_chk_result(STp, SRpnt);
-- 
1.5.6.5

