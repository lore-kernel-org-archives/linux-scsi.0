From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.2-rc1
Date: Fri, 24 May 2019 16:11:43 -0700
Message-ID: <1558739503.3235.58.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is the same set of patches sent in the merge window as the final
pull except that Martin's read only rework is replaced with a simple
revert of the original change that caused the regression.  Everything
else is an obvious fix or small cleanup.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Colin Ian King (1):
      scsi: bnx2fc: fix incorrect cast to u64 on shift operation

Erwan Velu (1):
      scsi: smartpqi: Reporting unhandled SCSI errors

James Smart (4):
      scsi: lpfc: Update lpfc version to 12.2.0.2
      scsi: lpfc: add check for loss of ndlp when sending RRQ
      scsi: lpfc: correct rcu unlock issue in lpfc_nvme_info_show
      scsi: lpfc: resolve lockdep warnings

Martin K. Petersen (1):
      Revert "scsi: sd: Keep disk read-only when re-reading partition"

Quinn Tran (1):
      scsi: qla2xxx: Add cleanup for PCI EEH recovery

YueHaibing (3):
      scsi: myrs: Fix uninitialized variable
      scsi: qedi: remove set but not used variables 'cdev' and 'udev'
      scsi: qedi: remove memset/memcpy to nfunc and use func instead

And the diffstat:

 drivers/scsi/bnx2fc/bnx2fc_hwi.c      |   2 +-
 drivers/scsi/lpfc/lpfc_attr.c         |  37 +++---
 drivers/scsi/lpfc/lpfc_els.c          |   5 +-
 drivers/scsi/lpfc/lpfc_sli.c          |  84 ++++++++-----
 drivers/scsi/lpfc/lpfc_version.h      |   2 +-
 drivers/scsi/myrs.c                   |   2 +-
 drivers/scsi/qedi/qedi_dbg.c          |  32 ++---
 drivers/scsi/qedi/qedi_iscsi.c        |   4 -
 drivers/scsi/qla2xxx/qla_os.c         | 221 +++++++++++++---------------------
 drivers/scsi/sd.c                     |   3 +-
 drivers/scsi/smartpqi/smartpqi_init.c |  23 ++--
 11 files changed, 189 insertions(+), 226 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 039328d9ef13..30e6d78e82f0 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -830,7 +830,7 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 			((u64)err_entry->data.err_warn_bitmap_hi << 32) |
 			(u64)err_entry->data.err_warn_bitmap_lo;
 		for (i = 0; i < BNX2FC_NUM_ERR_BITS; i++) {
-			if (err_warn_bit_map & (u64) (1 << i)) {
+			if (err_warn_bit_map & ((u64)1 << i)) {
 				err_warn = i;
 				break;
 			}
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e9adb3f1961d..d4c65e2109e2 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -176,6 +176,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 	int i;
 	int len = 0;
 	char tmp[LPFC_MAX_NVME_INFO_TMP_LEN] = {0};
+	unsigned long iflags = 0;
 
 	if (!(vport->cfg_enable_fc4_type & LPFC_ENABLE_NVME)) {
 		len = scnprintf(buf, PAGE_SIZE, "NVME Disabled\n");
@@ -354,7 +355,7 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  phba->sli4_hba.io_xri_max,
 		  lpfc_sli4_get_els_iocb_cnt(phba));
 	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+		goto rcu_unlock_buf_done;
 
 	/* Port state is only one of two values for now. */
 	if (localport->port_id)
@@ -370,15 +371,15 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  wwn_to_u64(vport->fc_nodename.u.wwn),
 		  localport->port_id, statep);
 	if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-		goto buffer_done;
+		goto rcu_unlock_buf_done;
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		nrport = NULL;
-		spin_lock(&vport->phba->hbalock);
+		spin_lock_irqsave(&vport->phba->hbalock, iflags);
 		rport = lpfc_ndlp_get_nrport(ndlp);
 		if (rport)
 			nrport = rport->remoteport;
-		spin_unlock(&vport->phba->hbalock);
+		spin_unlock_irqrestore(&vport->phba->hbalock, iflags);
 		if (!nrport)
 			continue;
 
@@ -397,39 +398,39 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 
 		/* Tab in to show lport ownership. */
 		if (strlcat(buf, "NVME RPORT       ", PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+			goto rcu_unlock_buf_done;
 		if (phba->brd_no >= 10) {
 			if (strlcat(buf, " ", PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+				goto rcu_unlock_buf_done;
 		}
 
 		scnprintf(tmp, sizeof(tmp), "WWPN x%llx ",
 			  nrport->port_name);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+			goto rcu_unlock_buf_done;
 
 		scnprintf(tmp, sizeof(tmp), "WWNN x%llx ",
 			  nrport->node_name);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+			goto rcu_unlock_buf_done;
 
 		scnprintf(tmp, sizeof(tmp), "DID x%06x ",
 			  nrport->port_id);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+			goto rcu_unlock_buf_done;
 
 		/* An NVME rport can have multiple roles. */
 		if (nrport->port_role & FC_PORT_ROLE_NVME_INITIATOR) {
 			if (strlcat(buf, "INITIATOR ", PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+				goto rcu_unlock_buf_done;
 		}
 		if (nrport->port_role & FC_PORT_ROLE_NVME_TARGET) {
 			if (strlcat(buf, "TARGET ", PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+				goto rcu_unlock_buf_done;
 		}
 		if (nrport->port_role & FC_PORT_ROLE_NVME_DISCOVERY) {
 			if (strlcat(buf, "DISCSRVC ", PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+				goto rcu_unlock_buf_done;
 		}
 		if (nrport->port_role & ~(FC_PORT_ROLE_NVME_INITIATOR |
 					  FC_PORT_ROLE_NVME_TARGET |
@@ -437,12 +438,12 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 			scnprintf(tmp, sizeof(tmp), "UNKNOWN ROLE x%x",
 				  nrport->port_role);
 			if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-				goto buffer_done;
+				goto rcu_unlock_buf_done;
 		}
 
 		scnprintf(tmp, sizeof(tmp), "%s\n", statep);
 		if (strlcat(buf, tmp, PAGE_SIZE) >= PAGE_SIZE)
-			goto buffer_done;
+			goto rcu_unlock_buf_done;
 	}
 	rcu_read_unlock();
 
@@ -504,7 +505,13 @@ lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
 		  atomic_read(&lport->cmpl_fcp_err));
 	strlcat(buf, tmp, PAGE_SIZE);
 
-buffer_done:
+	/* RCU is already unlocked. */
+	goto buffer_done;
+
+ rcu_unlock_buf_done:
+	rcu_read_unlock();
+
+ buffer_done:
 	len = strnlen(buf, PAGE_SIZE);
 
 	if (unlikely(len >= (PAGE_SIZE - 1))) {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index c8fb0b455f2a..5ac4f8d76b91 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7334,7 +7334,10 @@ int
 lpfc_send_rrq(struct lpfc_hba *phba, struct lpfc_node_rrq *rrq)
 {
 	struct lpfc_nodelist *ndlp = lpfc_findnode_did(rrq->vport,
-							rrq->nlp_DID);
+						       rrq->nlp_DID);
+	if (!ndlp)
+		return 1;
+
 	if (lpfc_test_rrq_active(phba, ndlp, rrq->xritag))
 		return lpfc_issue_els_rrq(rrq->vport, ndlp,
 					 rrq->nlp_DID, rrq);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2acda188b0dc..d1512e4f9791 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -991,15 +991,14 @@ lpfc_cleanup_vports_rrqs(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
  * @ndlp: Targets nodelist pointer for this exchange.
  * @xritag the xri in the bitmap to test.
  *
- * This function is called with hbalock held. This function
- * returns 0 = rrq not active for this xri
- *         1 = rrq is valid for this xri.
+ * This function returns:
+ * 0 = rrq not active for this xri
+ * 1 = rrq is valid for this xri.
  **/
 int
 lpfc_test_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 			uint16_t  xritag)
 {
-	lockdep_assert_held(&phba->hbalock);
 	if (!ndlp)
 		return 0;
 	if (!ndlp->active_rrqs_xri_bitmap)
@@ -1102,10 +1101,11 @@ lpfc_set_rrq_active(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
  * @phba: Pointer to HBA context object.
  * @piocb: Pointer to the iocbq.
  *
- * This function is called with the ring lock held. This function
- * gets a new driver sglq object from the sglq list. If the
- * list is not empty then it is successful, it returns pointer to the newly
- * allocated sglq object else it returns NULL.
+ * The driver calls this function with either the nvme ls ring lock
+ * or the fc els ring lock held depending on the iocb usage.  This function
+ * gets a new driver sglq object from the sglq list. If the list is not empty
+ * then it is successful, it returns pointer to the newly allocated sglq
+ * object else it returns NULL.
  **/
 static struct lpfc_sglq *
 __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
@@ -1115,9 +1115,15 @@ __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 	struct lpfc_sglq *start_sglq = NULL;
 	struct lpfc_io_buf *lpfc_cmd;
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_sli_ring *pring = NULL;
 	int found = 0;
 
-	lockdep_assert_held(&phba->hbalock);
+	if (piocbq->iocb_flag & LPFC_IO_NVME_LS)
+		pring =  phba->sli4_hba.nvmels_wq->pring;
+	else
+		pring = lpfc_phba_elsring(phba);
+
+	lockdep_assert_held(&pring->ring_lock);
 
 	if (piocbq->iocb_flag &  LPFC_IO_FCP) {
 		lpfc_cmd = (struct lpfc_io_buf *) piocbq->context1;
@@ -1560,7 +1566,8 @@ lpfc_sli_ring_map(struct lpfc_hba *phba)
  * @pring: Pointer to driver SLI ring object.
  * @piocb: Pointer to the driver iocb object.
  *
- * This function is called with hbalock held. The function adds the
+ * The driver calls this function with the hbalock held for SLI3 ports or
+ * the ring lock held for SLI4 ports. The function adds the
  * new iocb to txcmplq of the given ring. This function always returns
  * 0. If this function is called for ELS ring, this function checks if
  * there is a vport associated with the ELS command. This function also
@@ -1570,7 +1577,10 @@ static int
 lpfc_sli_ringtxcmpl_put(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			struct lpfc_iocbq *piocb)
 {
-	lockdep_assert_held(&phba->hbalock);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		lockdep_assert_held(&pring->ring_lock);
+	else
+		lockdep_assert_held(&phba->hbalock);
 
 	BUG_ON(!piocb);
 
@@ -2967,8 +2977,8 @@ lpfc_sli_process_unsol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
  *
  * This function looks up the iocb_lookup table to get the command iocb
  * corresponding to the given response iocb using the iotag of the
- * response iocb. This function is called with the hbalock held
- * for sli3 devices or the ring_lock for sli4 devices.
+ * response iocb. The driver calls this function with the hbalock held
+ * for SLI3 ports or the ring lock held for SLI4 ports.
  * This function returns the command iocb object if it finds the command
  * iocb else returns NULL.
  **/
@@ -2979,8 +2989,15 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
 {
 	struct lpfc_iocbq *cmd_iocb = NULL;
 	uint16_t iotag;
-	lockdep_assert_held(&phba->hbalock);
+	spinlock_t *temp_lock = NULL;
+	unsigned long iflag = 0;
 
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		temp_lock = &pring->ring_lock;
+	else
+		temp_lock = &phba->hbalock;
+
+	spin_lock_irqsave(temp_lock, iflag);
 	iotag = prspiocb->iocb.ulpIoTag;
 
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
@@ -2990,10 +3007,12 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
 			list_del_init(&cmd_iocb->list);
 			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			pring->txcmplq_cnt--;
+			spin_unlock_irqrestore(temp_lock, iflag);
 			return cmd_iocb;
 		}
 	}
 
+	spin_unlock_irqrestore(temp_lock, iflag);
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0317 iotag x%x is out of "
 			"range: max iotag x%x wd0 x%x\n",
@@ -3009,8 +3028,8 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *phba,
  * @iotag: IOCB tag.
  *
  * This function looks up the iocb_lookup table to get the command iocb
- * corresponding to the given iotag. This function is called with the
- * hbalock held.
+ * corresponding to the given iotag. The driver calls this function with
+ * the ring lock held because this function is an SLI4 port only helper.
  * This function returns the command iocb object if it finds the command
  * iocb else returns NULL.
  **/
@@ -3019,8 +3038,15 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 			     struct lpfc_sli_ring *pring, uint16_t iotag)
 {
 	struct lpfc_iocbq *cmd_iocb = NULL;
+	spinlock_t *temp_lock = NULL;
+	unsigned long iflag = 0;
 
-	lockdep_assert_held(&phba->hbalock);
+	if (phba->sli_rev == LPFC_SLI_REV4)
+		temp_lock = &pring->ring_lock;
+	else
+		temp_lock = &phba->hbalock;
+
+	spin_lock_irqsave(temp_lock, iflag);
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
 		if (cmd_iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ) {
@@ -3028,10 +3054,12 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc_hba *phba,
 			list_del_init(&cmd_iocb->list);
 			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			pring->txcmplq_cnt--;
+			spin_unlock_irqrestore(temp_lock, iflag);
 			return cmd_iocb;
 		}
 	}
 
+	spin_unlock_irqrestore(temp_lock, iflag);
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0372 iotag x%x lookup error: max iotag (x%x) "
 			"iocb_flag x%x\n",
@@ -3065,17 +3093,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	int rc = 1;
 	unsigned long iflag;
 
-	/* Based on the iotag field, get the cmd IOCB from the txcmplq */
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		spin_lock_irqsave(&pring->ring_lock, iflag);
-	else
-		spin_lock_irqsave(&phba->hbalock, iflag);
 	cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring, saveq);
-	if (phba->sli_rev == LPFC_SLI_REV4)
-		spin_unlock_irqrestore(&pring->ring_lock, iflag);
-	else
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-
 	if (cmdiocbp) {
 		if (cmdiocbp->iocb_cmpl) {
 			/*
@@ -3406,8 +3424,10 @@ lpfc_sli_handle_fast_ring_event(struct lpfc_hba *phba,
 				break;
 			}
 
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
 			cmdiocbq = lpfc_sli_iocbq_lookup(phba, pring,
 							 &rspiocbq);
+			spin_lock_irqsave(&phba->hbalock, iflag);
 			if (unlikely(!cmdiocbq))
 				break;
 			if (cmdiocbq->iocb_flag & LPFC_DRIVER_ABORTED)
@@ -3601,9 +3621,12 @@ lpfc_sli_sp_handle_rspiocb(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 		case LPFC_ABORT_IOCB:
 			cmdiocbp = NULL;
-			if (irsp->ulpCommand != CMD_XRI_ABORTED_CX)
+			if (irsp->ulpCommand != CMD_XRI_ABORTED_CX) {
+				spin_unlock_irqrestore(&phba->hbalock, iflag);
 				cmdiocbp = lpfc_sli_iocbq_lookup(phba, pring,
 								 saveq);
+				spin_lock_irqsave(&phba->hbalock, iflag);
+			}
 			if (cmdiocbp) {
 				/* Call the specified completion routine */
 				if (cmdiocbp->iocb_cmpl) {
@@ -12976,13 +12999,11 @@ lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
 		return NULL;
 
 	wcqe = &irspiocbq->cq_event.cqe.wcqe_cmpl;
-	spin_lock_irqsave(&pring->ring_lock, iflags);
 	pring->stats.iocb_event++;
 	/* Look up the ELS command IOCB and create pseudo response IOCB */
 	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
 	if (unlikely(!cmdiocbq)) {
-		spin_unlock_irqrestore(&pring->ring_lock, iflags);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0386 ELS complete with no corresponding "
 				"cmdiocb: 0x%x 0x%x 0x%x 0x%x\n",
@@ -12992,6 +13013,7 @@ lpfc_sli4_els_wcqe_to_rspiocbq(struct lpfc_hba *phba,
 		return NULL;
 	}
 
+	spin_lock_irqsave(&pring->ring_lock, iflags);
 	/* Put the iocb back on the txcmplq */
 	lpfc_sli_ringtxcmpl_put(phba, pring, cmdiocbq);
 	spin_unlock_irqrestore(&pring->ring_lock, iflags);
@@ -13762,9 +13784,9 @@ lpfc_sli4_fp_handle_fcp_wcqe(struct lpfc_hba *phba, struct lpfc_queue *cq,
 	/* Look up the FCP command IOCB and create pseudo response IOCB */
 	spin_lock_irqsave(&pring->ring_lock, iflags);
 	pring->stats.iocb_event++;
+	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	cmdiocbq = lpfc_sli_iocbq_lookup_by_tag(phba, pring,
 				bf_get(lpfc_wcqe_c_request_tag, wcqe));
-	spin_unlock_irqrestore(&pring->ring_lock, iflags);
 	if (unlikely(!cmdiocbq)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 				"0374 FCP complete with no corresponding "
diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index f7d9ef428417..220a932fe943 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "12.2.0.1"
+#define LPFC_DRIVER_VERSION "12.2.0.2"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index b8d54ef8cf6d..eb0dd566330a 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -818,7 +818,7 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
 	unsigned char ev_type, *ev_msg;
 	struct Scsi_Host *shost = cs->host;
 	struct scsi_device *sdev;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_sense_hdr sshdr = {0};
 	unsigned char sense_info[4];
 	unsigned char cmd_specific[4];
 
diff --git a/drivers/scsi/qedi/qedi_dbg.c b/drivers/scsi/qedi/qedi_dbg.c
index 8fd28b056f73..3383314a3882 100644
--- a/drivers/scsi/qedi/qedi_dbg.c
+++ b/drivers/scsi/qedi/qedi_dbg.c
@@ -16,10 +16,6 @@ qedi_dbg_err(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 {
 	va_list va;
 	struct va_format vaf;
-	char nfunc[32];
-
-	memset(nfunc, 0, sizeof(nfunc));
-	memcpy(nfunc, func, sizeof(nfunc) - 1);
 
 	va_start(va, fmt);
 
@@ -28,9 +24,9 @@ qedi_dbg_err(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 
 	if (likely(qedi) && likely(qedi->pdev))
 		pr_err("[%s]:[%s:%d]:%d: %pV", dev_name(&qedi->pdev->dev),
-		       nfunc, line, qedi->host_no, &vaf);
+		       func, line, qedi->host_no, &vaf);
 	else
-		pr_err("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
+		pr_err("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
 
 	va_end(va);
 }
@@ -41,10 +37,6 @@ qedi_dbg_warn(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 {
 	va_list va;
 	struct va_format vaf;
-	char nfunc[32];
-
-	memset(nfunc, 0, sizeof(nfunc));
-	memcpy(nfunc, func, sizeof(nfunc) - 1);
 
 	va_start(va, fmt);
 
@@ -56,9 +48,9 @@ qedi_dbg_warn(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 
 	if (likely(qedi) && likely(qedi->pdev))
 		pr_warn("[%s]:[%s:%d]:%d: %pV", dev_name(&qedi->pdev->dev),
-			nfunc, line, qedi->host_no, &vaf);
+			func, line, qedi->host_no, &vaf);
 	else
-		pr_warn("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
+		pr_warn("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
 
 ret:
 	va_end(va);
@@ -70,10 +62,6 @@ qedi_dbg_notice(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 {
 	va_list va;
 	struct va_format vaf;
-	char nfunc[32];
-
-	memset(nfunc, 0, sizeof(nfunc));
-	memcpy(nfunc, func, sizeof(nfunc) - 1);
 
 	va_start(va, fmt);
 
@@ -85,10 +73,10 @@ qedi_dbg_notice(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 
 	if (likely(qedi) && likely(qedi->pdev))
 		pr_notice("[%s]:[%s:%d]:%d: %pV",
-			  dev_name(&qedi->pdev->dev), nfunc, line,
+			  dev_name(&qedi->pdev->dev), func, line,
 			  qedi->host_no, &vaf);
 	else
-		pr_notice("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
+		pr_notice("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
 
 ret:
 	va_end(va);
@@ -100,10 +88,6 @@ qedi_dbg_info(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 {
 	va_list va;
 	struct va_format vaf;
-	char nfunc[32];
-
-	memset(nfunc, 0, sizeof(nfunc));
-	memcpy(nfunc, func, sizeof(nfunc) - 1);
 
 	va_start(va, fmt);
 
@@ -115,9 +99,9 @@ qedi_dbg_info(struct qedi_dbg_ctx *qedi, const char *func, u32 line,
 
 	if (likely(qedi) && likely(qedi->pdev))
 		pr_info("[%s]:[%s:%d]:%d: %pV", dev_name(&qedi->pdev->dev),
-			nfunc, line, qedi->host_no, &vaf);
+			func, line, qedi->host_no, &vaf);
 	else
-		pr_info("[0000:00:00.0]:[%s:%d]: %pV", nfunc, line, &vaf);
+		pr_info("[0000:00:00.0]:[%s:%d]: %pV", func, line, &vaf);
 
 ret:
 	va_end(va);
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 615cea4fad56..82153c808b40 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -809,8 +809,6 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	struct qedi_endpoint *qedi_ep;
 	struct sockaddr_in *addr;
 	struct sockaddr_in6 *addr6;
-	struct qed_dev *cdev  =  NULL;
-	struct qedi_uio_dev *udev = NULL;
 	struct iscsi_path path_req;
 	u32 msg_type = ISCSI_KEVENT_IF_DOWN;
 	u32 iscsi_cid = QEDI_CID_RESERVED;
@@ -830,8 +828,6 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	}
 
 	qedi = iscsi_host_priv(shost);
-	cdev = qedi->cdev;
-	udev = qedi->udev;
 
 	if (test_bit(QEDI_IN_OFFLINE, &qedi->flags) ||
 	    test_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e1c82a0a9745..172ef21827dd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6826,6 +6826,78 @@ qla2x00_release_firmware(void)
 	mutex_unlock(&qla_fw_lock);
 }
 
+static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
+	struct qla_qpair *qpair = NULL;
+	struct scsi_qla_host *vp;
+	fc_port_t *fcport;
+	int i;
+	unsigned long flags;
+
+	ha->chip_reset++;
+
+	ha->base_qpair->chip_reset = ha->chip_reset;
+	for (i = 0; i < ha->max_qpairs; i++) {
+		if (ha->queue_pair_map[i])
+			ha->queue_pair_map[i]->chip_reset =
+			    ha->base_qpair->chip_reset;
+	}
+
+	/* purge MBox commands */
+	if (atomic_read(&ha->num_pend_mbx_stage3)) {
+		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+		complete(&ha->mbx_intr_comp);
+	}
+
+	i = 0;
+
+	while (atomic_read(&ha->num_pend_mbx_stage3) ||
+	    atomic_read(&ha->num_pend_mbx_stage2) ||
+	    atomic_read(&ha->num_pend_mbx_stage1)) {
+		msleep(20);
+		i++;
+		if (i > 50)
+			break;
+	}
+
+	ha->flags.purge_mbox = 0;
+
+	mutex_lock(&ha->mq_lock);
+	list_for_each_entry(qpair, &base_vha->qp_list, qp_list_elem)
+		qpair->online = 0;
+	mutex_unlock(&ha->mq_lock);
+
+	qla2x00_mark_all_devices_lost(vha, 0);
+
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vp, &ha->vp_list, list) {
+		atomic_inc(&vp->vref_count);
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+		qla2x00_mark_all_devices_lost(vp, 0);
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		atomic_dec(&vp->vref_count);
+	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+	/* Clear all async request states across all VPs. */
+	list_for_each_entry(fcport, &vha->vp_fcports, list)
+		fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vp, &ha->vp_list, list) {
+		atomic_inc(&vp->vref_count);
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+		list_for_each_entry(fcport, &vp->vp_fcports, list)
+			fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		atomic_dec(&vp->vref_count);
+	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+}
+
+
 static pci_ers_result_t
 qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 {
@@ -6851,20 +6923,7 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		return PCI_ERS_RESULT_CAN_RECOVER;
 	case pci_channel_io_frozen:
 		ha->flags.eeh_busy = 1;
-		/* For ISP82XX complete any pending mailbox cmd */
-		if (IS_QLA82XX(ha)) {
-			ha->flags.isp82xx_fw_hung = 1;
-			ql_dbg(ql_dbg_aer, vha, 0x9001, "Pci channel io frozen\n");
-			qla82xx_clear_pending_mbx(vha);
-		}
-		qla2x00_free_irqs(vha);
-		pci_disable_device(pdev);
-		/* Return back all IOs */
-		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
-		if (ql2xmqsupport || ql2xnvmeenable) {
-			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
-			qla2xxx_wake_dpc(vha);
-		}
+		qla_pci_error_cleanup(vha);
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		ha->flags.pci_channel_io_perm_failure = 1;
@@ -6918,122 +6977,14 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 		return PCI_ERS_RESULT_RECOVERED;
 }
 
-static uint32_t
-qla82xx_error_recovery(scsi_qla_host_t *base_vha)
-{
-	uint32_t rval = QLA_FUNCTION_FAILED;
-	uint32_t drv_active = 0;
-	struct qla_hw_data *ha = base_vha->hw;
-	int fn;
-	struct pci_dev *other_pdev = NULL;
-
-	ql_dbg(ql_dbg_aer, base_vha, 0x9006,
-	    "Entered %s.\n", __func__);
-
-	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
-
-	if (base_vha->flags.online) {
-		/* Abort all outstanding commands,
-		 * so as to be requeued later */
-		qla2x00_abort_isp_cleanup(base_vha);
-	}
-
-
-	fn = PCI_FUNC(ha->pdev->devfn);
-	while (fn > 0) {
-		fn--;
-		ql_dbg(ql_dbg_aer, base_vha, 0x9007,
-		    "Finding pci device at function = 0x%x.\n", fn);
-		other_pdev =
-		    pci_get_domain_bus_and_slot(pci_domain_nr(ha->pdev->bus),
-		    ha->pdev->bus->number, PCI_DEVFN(PCI_SLOT(ha->pdev->devfn),
-		    fn));
-
-		if (!other_pdev)
-			continue;
-		if (atomic_read(&other_pdev->enable_cnt)) {
-			ql_dbg(ql_dbg_aer, base_vha, 0x9008,
-			    "Found PCI func available and enable at 0x%x.\n",
-			    fn);
-			pci_dev_put(other_pdev);
-			break;
-		}
-		pci_dev_put(other_pdev);
-	}
-
-	if (!fn) {
-		/* Reset owner */
-		ql_dbg(ql_dbg_aer, base_vha, 0x9009,
-		    "This devfn is reset owner = 0x%x.\n",
-		    ha->pdev->devfn);
-		qla82xx_idc_lock(ha);
-
-		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
-		    QLA8XXX_DEV_INITIALIZING);
-
-		qla82xx_wr_32(ha, QLA82XX_CRB_DRV_IDC_VERSION,
-		    QLA82XX_IDC_VERSION);
-
-		drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
-		ql_dbg(ql_dbg_aer, base_vha, 0x900a,
-		    "drv_active = 0x%x.\n", drv_active);
-
-		qla82xx_idc_unlock(ha);
-		/* Reset if device is not already reset
-		 * drv_active would be 0 if a reset has already been done
-		 */
-		if (drv_active)
-			rval = qla82xx_start_firmware(base_vha);
-		else
-			rval = QLA_SUCCESS;
-		qla82xx_idc_lock(ha);
-
-		if (rval != QLA_SUCCESS) {
-			ql_log(ql_log_info, base_vha, 0x900b,
-			    "HW State: FAILED.\n");
-			qla82xx_clear_drv_active(ha);
-			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
-			    QLA8XXX_DEV_FAILED);
-		} else {
-			ql_log(ql_log_info, base_vha, 0x900c,
-			    "HW State: READY.\n");
-			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
-			    QLA8XXX_DEV_READY);
-			qla82xx_idc_unlock(ha);
-			ha->flags.isp82xx_fw_hung = 0;
-			rval = qla82xx_restart_isp(base_vha);
-			qla82xx_idc_lock(ha);
-			/* Clear driver state register */
-			qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, 0);
-			qla82xx_set_drv_active(base_vha);
-		}
-		qla82xx_idc_unlock(ha);
-	} else {
-		ql_dbg(ql_dbg_aer, base_vha, 0x900d,
-		    "This devfn is not reset owner = 0x%x.\n",
-		    ha->pdev->devfn);
-		if ((qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE) ==
-		    QLA8XXX_DEV_READY)) {
-			ha->flags.isp82xx_fw_hung = 0;
-			rval = qla82xx_restart_isp(base_vha);
-			qla82xx_idc_lock(ha);
-			qla82xx_set_drv_active(base_vha);
-			qla82xx_idc_unlock(ha);
-		}
-	}
-	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
-
-	return rval;
-}
-
 static pci_ers_result_t
 qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 {
 	pci_ers_result_t ret = PCI_ERS_RESULT_DISCONNECT;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(pdev);
 	struct qla_hw_data *ha = base_vha->hw;
-	struct rsp_que *rsp;
-	int rc, retries = 10;
+	int rc;
+	struct qla_qpair *qpair = NULL;
 
 	ql_dbg(ql_dbg_aer, base_vha, 0x9004,
 	    "Slot Reset.\n");
@@ -7062,24 +7013,16 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 		goto exit_slot_reset;
 	}
 
-	rsp = ha->rsp_q_map[0];
-	if (qla2x00_request_irqs(ha, rsp))
-		goto exit_slot_reset;
 
 	if (ha->isp_ops->pci_config(base_vha))
 		goto exit_slot_reset;
 
-	if (IS_QLA82XX(ha)) {
-		if (qla82xx_error_recovery(base_vha) == QLA_SUCCESS) {
-			ret = PCI_ERS_RESULT_RECOVERED;
-			goto exit_slot_reset;
-		} else
-			goto exit_slot_reset;
-	}
-
-	while (ha->flags.mbox_busy && retries--)
-		msleep(1000);
+	mutex_lock(&ha->mq_lock);
+	list_for_each_entry(qpair, &base_vha->qp_list, qp_list_elem)
+		qpair->online = 1;
+	mutex_unlock(&ha->mq_lock);
 
+	base_vha->flags.online = 1;
 	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 	if (ha->isp_ops->abort_isp(base_vha) == QLA_SUCCESS)
 		ret =  PCI_ERS_RESULT_RECOVERED;
@@ -7103,13 +7046,13 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
 	ql_dbg(ql_dbg_aer, base_vha, 0x900f,
 	    "pci_resume.\n");
 
+	ha->flags.eeh_busy = 0;
+
 	ret = qla2x00_wait_for_hba_online(base_vha);
 	if (ret != QLA_SUCCESS) {
 		ql_log(ql_log_fatal, base_vha, 0x9002,
 		    "The device failed to resume I/O from slot/link_reset.\n");
 	}
-
-	ha->flags.eeh_busy = 0;
 }
 
 static void
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2b2bc4b49d78..b894786df6c2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2603,7 +2603,6 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
-	int disk_ro = get_disk_ro(sdkp->disk);
 	int old_wp = sdkp->write_prot;
 
 	set_disk_ro(sdkp->disk, 0);
@@ -2644,7 +2643,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 			  "Test WP failed, assume Write Enabled\n");
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
-		set_disk_ro(sdkp->disk, sdkp->write_prot || disk_ro);
+		set_disk_ro(sdkp->disk, sdkp->write_prot);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
 			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
 				  sdkp->write_prot ? "on" : "off");
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c26cac819f9e..b17761eafca9 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2755,16 +2755,25 @@ static void pqi_process_raid_io_error(struct pqi_io_request *io_request)
 			scsi_normalize_sense(error_info->data,
 				sense_data_length, &sshdr) &&
 				sshdr.sense_key == HARDWARE_ERROR &&
-				sshdr.asc == 0x3e &&
-				sshdr.ascq == 0x1) {
+				sshdr.asc == 0x3e) {
 			struct pqi_ctrl_info *ctrl_info = shost_to_hba(scmd->device->host);
 			struct pqi_scsi_dev *device = scmd->device->hostdata;
 
-			if (printk_ratelimit())
-				scmd_printk(KERN_ERR, scmd, "received 'logical unit failure' from controller for scsi %d:%d:%d:%d\n",
-					ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun);
-			pqi_take_device_offline(scmd->device, "RAID");
-			host_byte = DID_NO_CONNECT;
+			switch (sshdr.ascq) {
+			case 0x1: /* LOGICAL UNIT FAILURE */
+				if (printk_ratelimit())
+					scmd_printk(KERN_ERR, scmd, "received 'logical unit failure' from controller for scsi %d:%d:%d:%d\n",
+						ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun);
+				pqi_take_device_offline(scmd->device, "RAID");
+				host_byte = DID_NO_CONNECT;
+				break;
+
+			default: /* See http://www.t10.org/lists/asc-num.htm#ASC_3E */
+				if (printk_ratelimit())
+					scmd_printk(KERN_ERR, scmd, "received unhandled error %d from controller for scsi %d:%d:%d:%d\n",
+						sshdr.ascq, ctrl_info->scsi_host->host_no, device->bus, device->target, device->lun);
+				break;
+			}
 		}
 
 		if (sense_data_length > SCSI_SENSE_BUFFERSIZE)
