From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 12/12] st: convert st_int_ioctl to use st_scsi_kern_execute
Date: Fri,  5 Dec 2008 15:25:31 +0900
Message-ID: <1228458331-8500-13-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1228458331-8500-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1228458331-8500-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:53451 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbYLEGZn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2008 01:25:43 -0500
In-Reply-To: <1228458331-8500-12-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: James.Bottomley@HansenPartnership.com, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org

This replaces st_do_scsi in st_int_ioctl with st_scsi_kern_execute.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index b13841a..3dfcbff 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2845,12 +2845,15 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		return (-ENOSYS);
 	}
 
-	SRpnt = st_do_scsi(NULL, STp, cmd, datalen, direction,
-			   timeout, MAX_RETRIES, 1);
+	SRpnt = st_allocate_request(STp);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
 
-	ioctl_result = (STp->buffer)->syscall_result;
+	ioctl_result = st_scsi_kern_execute(SRpnt, cmd, direction,
+					    STp->buffer->b_data, datalen,
+					    timeout, MAX_RETRIES);
+	if (!ioctl_result)
+		ioctl_result = (STp->buffer)->syscall_result;
 
 	if (!ioctl_result) {	/* SCSI command successful */
 		st_release_request(SRpnt);
-- 
1.5.5.GIT

