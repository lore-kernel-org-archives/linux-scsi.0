From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: [PATCH] qla2xxx: Improve qla2x00_req_pkt()
Date: Thu, 15 Dec 2011 19:51:29 +0100
Message-ID: <20111215185129.GA18429@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [85.183.114.52] ([85.183.114.52]:43146 "EHLO Dublin.logfs.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751552Ab1LOSuT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2011 13:50:19 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-driver@qlogic.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

- Remove useless comments.  Hint: if the comment does not add more
  information than the next line of code does without the comment,
  just leave it out.
- Replace HZ with 100 - see the comment for an explanation.  Arguably
  one could use 250, 300 or 1000 as well.  Or 42, for that matter.
- Replace hand-rolled memset with memset and avoid the macro to make the
  code more obvious to a reader.
- Replace "(req_cnt + 2)" with 3 and add a comment.

The function still strikes me as horribly wrong.  Releasing and
re-acquiring a lock held by the caller is never a good sign.  An
arbitrary wait-loop using busy spinning is just Plain Wrong(tm).  The
device has interrupts, so why do we implement polling in a function
called from the interrupt handler?  Bonkers!

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c |   36 +++++++++++++++++-------------------
 1 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index c822967..941d413 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -569,13 +569,21 @@ qla2x00_req_pkt(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
 	device_reg_t __iomem *reg = ha->iobase;
-	request_t *pkt = NULL;
-	uint32_t *dword_ptr, timer;
-	uint16_t req_cnt = 1, cnt;
+	request_t *pkt;
+	uint32_t timer;
+	uint16_t cnt;
 
-	/* Wait 1 second for slot. */
-	for (timer = HZ; timer; timer--) {
-		if ((req_cnt + 2) >= vha->req->cnt) {
+	/*
+	 * Wait 200-900us for a slot.  200us for 100 udelay(2), another 700us seem
+	 * to be used up elsewhere in this loop - or in the calling code around.
+	 * An older comment and the former usage of HZ indicates that the intention
+	 * was to wait for 1s, but the code never did that.  Given that the actual
+	 * code, rather than the original intention has see a lot of testing, keep
+	 * it at 200us.
+	 */
+	for (timer = 100; timer; timer--) {
+		/* XXX Where does the magical value of 3 come from? */
+		if (3 >= vha->req->cnt) {
 			/* Calculate number of free request entries. */
 			if (IS_FWI2_CAPABLE(ha))
 				cnt = (uint16_t)RD_REG_DWORD(&reg->isp24.req_q_out);
@@ -591,28 +599,19 @@ qla2x00_req_pkt(scsi_qla_host_t *vha)
 		}
 
 		/* If room for request in request ring. */
-		if ((req_cnt + 2) < vha->req->cnt) {
+		/* XXX Where does the magical value of 3 come from? */
+		if (3 < vha->req->cnt) {
 			vha->req->cnt--;
 			pkt = vha->req->ring_ptr;
 
-			/* Zero out packet. */
-			dword_ptr = (uint32_t *)pkt;
-			for (cnt = 0; cnt < REQUEST_ENTRY_SIZE / 4; cnt++)
-				*dword_ptr++ = 0;
-
-			/* Set system defined field. */
+			memset(pkt, 0, sizeof(*pkt));
 			pkt->sys_define = (uint8_t)vha->req->ring_index;
-
-			/* Set entry count. */
 			pkt->entry_count = 1;
-
 			return pkt;
 		}
 
-		/* Release ring specific lock */
 		spin_unlock_irq(&ha->hardware_lock);
 
-		/* 2 us */
 		udelay(2);
 		/*
 		 * Check for pending interrupts, during init we issue marker directly
@@ -620,7 +619,6 @@ qla2x00_req_pkt(scsi_qla_host_t *vha)
 		if (!vha->marker_needed && !vha->flags.init_done)
 			qla2x00_poll(vha->req->rsp);
 
-		/* Reaquire ring specific lock */
 		spin_lock_irq(&ha->hardware_lock);
 	}
 
-- 
1.7.7.3

