From: James Smart <james.smart@emulex.com>
Subject: [REPOST v2] [PATCH 1/1] lpfc: Add iotag memory barrier
Date: Mon, 19 May 2014 10:04:29 -0400
Message-ID: <1400508269.10454.1.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:53753 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbaESOEc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2014 10:04:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Prior patch still had a whitespace error. This should be the good one.

---

Checkpatch wants comments prior to mb() insertions. A good idea. Added the comments.

---

Add a memory barrier to ensure the valid bit is read before
any of the cqe payload is read. This fixes an issue seen
on Power where the cqe payload was getting loaded before
the valid bit. When this occurred, we saw an iotag out of
range error when a command completed, but since the iotag
looked invalid the command didn't get completed to scsi core.
Later we hit the command timeout, attempted to abort the command,
then waited for the aborted command to get returned. Since the
adapter already returned the command, we timeout waiting,
and end up escalating EEH all the way to host reset. This
patch fixes this issue.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2014-03-31 16:21:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2014-05-07 17:15:05.057890521 -0400
@@ -265,6 +265,16 @@ lpfc_sli4_eq_get(struct lpfc_queue *q)
 		return NULL;
 
 	q->hba_index = idx;
+
+	/*
+	 * insert barrier for instruction interlock : data from the hardware
+	 * must have the valid bit checked before it can be copied and acted
+	 * upon. Given what was seen in lpfc_sli4_cq_get() of speculative
+	 * instructions allowing action on content before valid bit checked,
+	 * add barrier here as well. May not be needed as "content" is a
+	 * single 32-bit entity here (vs multi word structure for cq's).
+	 */
+	mb();
 	return eqe;
 }
 
@@ -370,6 +380,17 @@ lpfc_sli4_cq_get(struct lpfc_queue *q)
 
 	cqe = q->qe[q->hba_index].cqe;
 	q->hba_index = idx;
+
+	/*
+	 * insert barrier for instruction interlock : data from the hardware
+	 * must have the valid bit checked before it can be copied and acted
+	 * upon. Speculative instructions were allowing a bcopy at the start
+	 * of lpfc_sli4_fp_handle_wcqe(), which is called immediately
+	 * after our return, to copy data before the valid bit check above
+	 * was done. As such, some of the copied data was stale. The barrier
+	 * ensures the check is before any data is copied.
+	 */
+	mb();
 	return cqe;
 }
 


