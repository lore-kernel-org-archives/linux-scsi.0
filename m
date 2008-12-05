From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 01/12] st: move st_request initialization to st_allocate_request form st_do_scsi
Date: Fri,  5 Dec 2008 15:25:20 +0900
Message-ID: <1228458331-8500-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53439 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbYLEGZj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:39 -0500
In-Reply-To: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This moves st_request initialization code to st_allocate_request()
form st_do_scsi(). This is a preparation for making
st_allocate_request() usable for everyone, not only st_do_scsi().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c959bdc..878493d 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -451,9 +451,23 @@ static void st_sleep_done(void *data, char *sense, int result, int resid)
 		complete(SRpnt->waiting);
 }
 
-static struct st_request *st_allocate_request(void)
+static struct st_request *st_allocate_request(struct scsi_tape *stp)
 {
-	return kzalloc(sizeof(struct st_request), GFP_KERNEL);
+	struct st_request *streq;
+
+	streq = kzalloc(sizeof(*streq), GFP_KERNEL);
+	if (streq)
+		streq->stp = stp;
+	else {
+		DEBC(printk(KERN_ERR "%s: Can't get SCSI request.\n",
+			    tape_name(stp)););
+		if (signal_pending(current))
+			stp->buffer->syscall_result = -EINTR;
+		else
+			stp->buffer->syscall_result = -EBUSY;
+	}
+
+	return streq;
 }
 
 static void st_release_request(struct st_request *streq)
@@ -481,18 +495,10 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 		return NULL;
 	}
 
-	if (SRpnt == NULL) {
-		SRpnt = st_allocate_request();
-		if (SRpnt == NULL) {
-			DEBC( printk(KERN_ERR "%s: Can't get SCSI request.\n",
-				     tape_name(STp)); );
-			if (signal_pending(current))
-				(STp->buffer)->syscall_result = (-EINTR);
-			else
-				(STp->buffer)->syscall_result = (-EBUSY);
+	if (!SRpnt) {
+		SRpnt = st_allocate_request(STp);
+		if (!SRpnt)
 			return NULL;
-		}
-		SRpnt->stp = STp;
 	}
 
 	/* If async IO, set last_SRpnt. This ptr tells write_behind_check
-- 
1.5.5.GIT

