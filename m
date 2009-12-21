From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/6] lpfc 8.3.7: Fix FC protocol errors
Date: Mon, 21 Dec 2009 17:01:23 -0500
Message-ID: <1261432910.12238.12.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:37988 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750834AbZLUWHg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2009 17:07:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix FC protocol errors:
- Fix multi-frame unsolicited sequences not queued properly
- Fix frames for unsolicited sequences not being associated with sequence.
- Fix unsolicited frame buffer sizes are not set properly
- Fix Sequence count for unsolicited frame headers not byte swapped.
- Fix Multi-frame sequence response frames go to wrong DID.

Signed-off-by: James Smart <james.smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc_hw4.h |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c |   21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 1585148..09c8e36 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1013,7 +1013,7 @@ struct lpfc_mbx_wq_destroy {
 };
 
 #define LPFC_HDR_BUF_SIZE 128
-#define LPFC_DATA_BUF_SIZE 4096
+#define LPFC_DATA_BUF_SIZE 2048
 struct rq_context {
 	uint32_t word0;
 #define lpfc_rq_context_rq_size_SHIFT	16
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7935667..50f72bf 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5848,7 +5848,6 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 					iocbq->iocb.un.ulpWord[3]);
 		wqe->generic.word3 = 0;
 		bf_set(wqe_rcvoxid, &wqe->generic, iocbq->iocb.ulpContext);
-		bf_set(wqe_xc, &wqe->generic, 1);
 		/* The entire sequence is transmitted for this IOCB */
 		xmit_len = total_len;
 		cmnd = CMD_XMIT_SEQUENCE64_CR;
@@ -10944,7 +10943,8 @@ lpfc_fc_frame_add(struct lpfc_vport *vport, struct hbq_dmabuf *dmabuf)
 		return dmabuf;
 	}
 	temp_hdr = seq_dmabuf->hbuf.virt;
-	if (new_hdr->fh_seq_cnt < temp_hdr->fh_seq_cnt) {
+	if (be16_to_cpu(new_hdr->fh_seq_cnt) <
+		be16_to_cpu(temp_hdr->fh_seq_cnt)) {
 		list_del_init(&seq_dmabuf->hbuf.list);
 		list_add_tail(&dmabuf->hbuf.list, &vport->rcv_buffer_list);
 		list_add_tail(&dmabuf->dbuf.list, &seq_dmabuf->dbuf.list);
@@ -10955,6 +10955,11 @@ lpfc_fc_frame_add(struct lpfc_vport *vport, struct hbq_dmabuf *dmabuf)
 	list_move_tail(&seq_dmabuf->hbuf.list, &vport->rcv_buffer_list);
 	seq_dmabuf->time_stamp = jiffies;
 	lpfc_update_rcv_time_stamp(vport);
+	if (list_empty(&seq_dmabuf->dbuf.list)) {
+		temp_hdr = dmabuf->hbuf.virt;
+		list_add_tail(&dmabuf->dbuf.list, &seq_dmabuf->dbuf.list);
+		return seq_dmabuf;
+	}
 	/* find the correct place in the sequence to insert this frame */
 	list_for_each_entry_reverse(d_buf, &seq_dmabuf->dbuf.list, list) {
 		temp_dmabuf = container_of(d_buf, struct hbq_dmabuf, dbuf);
@@ -10963,7 +10968,8 @@ lpfc_fc_frame_add(struct lpfc_vport *vport, struct hbq_dmabuf *dmabuf)
 		 * If the frame's sequence count is greater than the frame on
 		 * the list then insert the frame right after this frame
 		 */
-		if (new_hdr->fh_seq_cnt > temp_hdr->fh_seq_cnt) {
+		if (be16_to_cpu(new_hdr->fh_seq_cnt) >
+			be16_to_cpu(temp_hdr->fh_seq_cnt)) {
 			list_add(&dmabuf->dbuf.list, &temp_dmabuf->dbuf.list);
 			return seq_dmabuf;
 		}
@@ -11210,7 +11216,7 @@ lpfc_seq_complete(struct hbq_dmabuf *dmabuf)
 		seq_dmabuf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 		hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
 		/* If there is a hole in the sequence count then fail. */
-		if (++seq_count != hdr->fh_seq_cnt)
+		if (++seq_count != be16_to_cpu(hdr->fh_seq_cnt))
 			return 0;
 		fctl = (hdr->fh_f_ctl[0] << 16 |
 			hdr->fh_f_ctl[1] << 8 |
@@ -11242,6 +11248,7 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 	struct lpfc_iocbq *first_iocbq, *iocbq;
 	struct fc_frame_header *fc_hdr;
 	uint32_t sid;
+	struct ulp_bde64 *pbde;
 
 	fc_hdr = (struct fc_frame_header *)seq_dmabuf->hbuf.virt;
 	/* remove from receive buffer list */
@@ -11283,8 +11290,9 @@ lpfc_prep_seq(struct lpfc_vport *vport, struct hbq_dmabuf *seq_dmabuf)
 		if (!iocbq->context3) {
 			iocbq->context3 = d_buf;
 			iocbq->iocb.ulpBdeCount++;
-			iocbq->iocb.unsli3.rcvsli3.bde2.tus.f.bdeSize =
-							LPFC_DATA_BUF_SIZE;
+			pbde = (struct ulp_bde64 *)
+					&iocbq->iocb.unsli3.sli3Words[4];
+			pbde->tus.f.bdeSize = LPFC_DATA_BUF_SIZE;
 			first_iocbq->iocb.unsli3.rcvsli3.acc_len +=
 				bf_get(lpfc_rcqe_length,
 				       &seq_dmabuf->cq_event.cqe.rcqe_cmpl);
@@ -11407,7 +11415,6 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 		 * frame to be freed when it is finished.
 		 **/
 		lpfc_sli_hbqbuf_fill_hbqs(phba, LPFC_ELS_HBQ, 1);
-		dmabuf->tag = -1;
 		return;
 	}
 	/* Send the complete sequence to the upper layer protocol */
-- 
1.6.5.2



