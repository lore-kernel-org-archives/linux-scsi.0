From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/6] lpfc 8.3.11: FCF failover improvements
Date: Mon, 15 Mar 2010 11:24:56 -0400
Message-ID: <1268666696.31367.13.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:57384 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965070Ab0COPZI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2010 11:25:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

FCF failover improvements

- Add random FCF failover when there are multiple FCFs available.
- Prevent FCF log messages from being displayed for FC adapters.
- Separate the New FCF and Modified FCF log messages.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c     |   13 ++++++++-----
 lpfc_hbadisc.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 lpfc_init.c    |   19 ++++++++++++++-----
 lpfc_sli.c     |    4 +++-
 lpfc_sli4.h    |    1 +
 5 files changed, 77 insertions(+), 13 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-03-15 10:30:47.000000000 -0400
@@ -892,11 +892,14 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 
 		if (!rc) {
 			/* Mark the FCF discovery process done */
-			lpfc_printf_vlog(vport, KERN_INFO, LOG_FIP | LOG_ELS,
-					 "2769 FLOGI successful on FCF record: "
-					 "current_fcf_index:x%x, terminate FCF "
-					 "round robin failover process\n",
-					 phba->fcf.current_rec.fcf_indx);
+			if (phba->hba_flag & HBA_FIP_SUPPORT)
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_FIP |
+						LOG_ELS,
+						"2769 FLOGI successful on FCF "
+						"record: current_fcf_index:"
+						"x%x, terminate FCF round "
+						"robin failover process\n",
+						phba->fcf.current_rec.fcf_indx);
 			spin_lock_irq(&phba->hbalock);
 			phba->fcf.fcf_flag &= ~FCF_DISCOVERY;
 			spin_unlock_irq(&phba->hbalock);
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-03-15 10:30:47.000000000 -0400
@@ -1530,7 +1530,37 @@ lpfc_check_pending_fcoe_event(struct lpf
 }
 
 /**
- * lpfc_sli4_fcf_rec_mbox_parse - parse non-embedded fcf record mailbox command
+ * lpfc_sli4_new_fcf_random_select - Randomly select an eligible new fcf record
+ * @phba: pointer to lpfc hba data structure.
+ * @fcf_cnt: number of eligible fcf record seen so far.
+ *
+ * This function makes an running random selection decision on FCF record to
+ * use through a sequence of @fcf_cnt eligible FCF records with equal
+ * probability. To perform integer manunipulation of random numbers with
+ * size unit32_t, the lower 16 bits of the 32-bit random number returned
+ * from random32() are taken as the random random number generated.
+ *
+ * Returns true when outcome is for the newly read FCF record should be
+ * chosen; otherwise, return false when outcome is for keeping the previously
+ * chosen FCF record.
+ **/
+static bool
+lpfc_sli4_new_fcf_random_select(struct lpfc_hba *phba, uint32_t fcf_cnt)
+{
+	uint32_t rand_num;
+
+	/* Get 16-bit uniform random number */
+	rand_num = (0xFFFF & random32());
+
+	/* Decision with probability 1/fcf_cnt */
+	if ((fcf_cnt * rand_num) < 0xFFFF)
+		return true;
+	else
+		return false;
+}
+
+/**
+ * lpfc_mbx_cmpl_read_fcf_record - Completion handler for read_fcf mbox.
  * @phba: pointer to lpfc hba data structure.
  * @mboxq: pointer to mailbox object.
  * @next_fcf_index: pointer to holder of next fcf index.
@@ -1678,6 +1708,8 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 	uint16_t fcf_index, next_fcf_index;
 	struct lpfc_fcf_rec *fcf_rec = NULL;
 	uint16_t vlan_id;
+	uint32_t seed;
+	bool select_new_fcf;
 	int rc;
 
 	/* If there is pending FCoE event restart FCF table scan */
@@ -1808,9 +1840,21 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 		 * than the driver FCF record, use the new record.
 		 */
 		if (new_fcf_record->fip_priority < fcf_rec->priority) {
-			/* Choose this FCF record */
+			/* Choose the new FCF record with lower priority */
 			__lpfc_update_fcf_record(phba, fcf_rec, new_fcf_record,
 					addr_mode, vlan_id, 0);
+			/* Reset running random FCF selection count */
+			phba->fcf.eligible_fcf_cnt = 1;
+		} else if (new_fcf_record->fip_priority == fcf_rec->priority) {
+			/* Update running random FCF selection count */
+			phba->fcf.eligible_fcf_cnt++;
+			select_new_fcf = lpfc_sli4_new_fcf_random_select(phba,
+						phba->fcf.eligible_fcf_cnt);
+			if (select_new_fcf)
+				/* Choose the new FCF by random selection */
+				__lpfc_update_fcf_record(phba, fcf_rec,
+							 new_fcf_record,
+							 addr_mode, vlan_id, 0);
 		}
 		spin_unlock_irq(&phba->hbalock);
 		goto read_next_fcf;
@@ -1824,6 +1868,11 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(stru
 					 addr_mode, vlan_id, (boot_flag ?
 					 BOOT_ENABLE : 0));
 		phba->fcf.fcf_flag |= FCF_AVAILABLE;
+		/* Setup initial running random FCF selection count */
+		phba->fcf.eligible_fcf_cnt = 1;
+		/* Seeding the random number generator for random selection */
+		seed = (uint32_t)(0xFFFFFFFF & jiffies);
+		srandom32(seed);
 	}
 	spin_unlock_irq(&phba->hbalock);
 	goto read_next_fcf;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-03-15 10:30:47.000000000 -0400
@@ -3303,11 +3303,20 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba
 	switch (event_type) {
 	case LPFC_FCOE_EVENT_TYPE_NEW_FCF:
 	case LPFC_FCOE_EVENT_TYPE_FCF_PARAM_MOD:
-		lpfc_printf_log(phba, KERN_ERR, LOG_FIP | LOG_DISCOVERY,
-			"2546 New FCF found/FCF parameter modified event: "
-			"evt_tag:x%x, fcf_index:x%x\n",
-			acqe_fcoe->event_tag, acqe_fcoe->index);
-
+		if (event_type == LPFC_FCOE_EVENT_TYPE_NEW_FCF)
+			lpfc_printf_log(phba, KERN_ERR, LOG_FIP |
+					LOG_DISCOVERY,
+					"2546 New FCF found event: "
+					"evt_tag:x%x, fcf_index:x%x\n",
+					acqe_fcoe->event_tag,
+					acqe_fcoe->index);
+		else
+			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP |
+					LOG_DISCOVERY,
+					"2788 FCF parameter modified event: "
+					"evt_tag:x%x, fcf_index:x%x\n",
+					acqe_fcoe->event_tag,
+					acqe_fcoe->index);
 		spin_lock_irq(&phba->hbalock);
 		if ((phba->fcf.fcf_flag & FCF_SCAN_DONE) ||
 		    (phba->hba_flag & FCF_DISC_INPROGRESS)) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-03-15 10:30:47.000000000 -0400
@@ -162,6 +162,7 @@ struct lpfc_fcf {
 #define FCF_REDISC_FOV	0x200 /* Post FCF rediscovery fast failover */
 	uint32_t addr_mode;
 	uint16_t fcf_rr_init_indx;
+	uint32_t eligible_fcf_cnt;
 	struct lpfc_fcf_rec current_rec;
 	struct lpfc_fcf_rec failover_rec;
 	struct timer_list redisc_wait;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-03-15 10:30:47.000000000 -0400
@@ -12039,9 +12039,11 @@ lpfc_sli4_fcf_scan_read_fcf_rec(struct l
 		phba->hba_flag |= FCF_DISC_INPROGRESS;
 		spin_unlock_irq(&phba->hbalock);
 		/* Reset FCF round robin index bmask for new scan */
-		if (fcf_index == LPFC_FCOE_FCF_GET_FIRST)
+		if (fcf_index == LPFC_FCOE_FCF_GET_FIRST) {
 			memset(phba->fcf.fcf_rr_bmask, 0,
 			       sizeof(*phba->fcf.fcf_rr_bmask));
+			phba->fcf.eligible_fcf_cnt = 0;
+		}
 		error = 0;
 	}
 fail_fcf_scan:


