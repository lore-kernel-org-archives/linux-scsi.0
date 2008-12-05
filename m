From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 02/12] st: add st_scsi_kern_execute helper function
Date: Fri,  5 Dec 2008 15:25:21 +0900
Message-ID: <1228458331-8500-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53436 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463AbYLEGZj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:39 -0500
In-Reply-To: <1228458331-8500-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

st_scsi_kern_execute is a helper function to perform SCSI commands
synchronously. It supports data transfer with a liner in-kernel buffer
(not scatter gather). st_scsi_kern_execute internally uses
scsi_execute().

The majority of st_do_scsi can be replaced with
st_scsi_kern_execute. This is a preparation for rewriting st_do_scsi
to remove obsolete scsi_execute_async().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/st.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 878493d..9379071 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -533,6 +533,28 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned char *cmd
 	return SRpnt;
 }
 
+static int st_scsi_kern_execute(struct st_request *streq,
+				const unsigned char *cmd, int data_direction,
+				void *buffer, unsigned bufflen, int timeout,
+				int retries)
+{
+	struct scsi_tape *stp = streq->stp;
+	int ret, resid;
+
+	stp->buffer->cmdstat.have_sense = 0;
+	memcpy(streq->cmd, cmd, sizeof(streq->cmd));
+
+	ret = scsi_execute(stp->device, cmd, data_direction, buffer, bufflen,
+			   streq->sense, timeout, retries, 0, &resid);
+	if (driver_byte(ret) & DRIVER_ERROR)
+		return -EBUSY;
+
+	stp->buffer->cmdstat.midlevel_result = streq->result = ret;
+	stp->buffer->cmdstat.residual = resid;
+	stp->buffer->syscall_result = st_chk_result(stp, streq);
+
+	return 0;
+}
 
 /* Handle the write-behind checking (waits for completion). Returns -ENOSPC if
    write has been correct but EOM early warning reached, -EIO if write ended in
-- 
1.5.5.GIT

