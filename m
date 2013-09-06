From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/18] lpfc 8.3.42: Fixed using unsafe linked list macro for
 walking and deleting linked list
Date: Fri, 6 Sep 2013 12:17:56 -0400
Message-ID: <1378484276.14051.20.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22762 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3IFQSd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:18:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed using unsafe linked list macro for walking and deleting linked list


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |    4 ++--
 lpfc_sli.c |    5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2013-09-04 13:18:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2013-09-06 10:03:53.472058065 -0400
@@ -1249,7 +1249,7 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job
 	struct lpfc_hba *phba = vport->phba;
 	struct get_ct_event *event_req;
 	struct get_ct_event_reply *event_reply;
-	struct lpfc_bsg_event *evt;
+	struct lpfc_bsg_event *evt, *evt_next;
 	struct event_data *evt_dat = NULL;
 	unsigned long flags;
 	uint32_t rc = 0;
@@ -1269,7 +1269,7 @@ lpfc_bsg_hba_get_event(struct fc_bsg_job
 	event_reply = (struct get_ct_event_reply *)
 		job->reply->reply_data.vendor_reply.vendor_rsp;
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
-	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
+	list_for_each_entry_safe(evt, evt_next, &phba->ct_ev_waiters, node) {
 		if (evt->reg_id == event_req->ev_reg_id) {
 			if (list_empty(&evt->events_to_get))
 				break;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-09-04 13:18:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-09-06 10:03:53.500058066 -0400
@@ -15808,7 +15808,7 @@ lpfc_sli4_fcf_rr_index_set(struct lpfc_h
 void
 lpfc_sli4_fcf_rr_index_clear(struct lpfc_hba *phba, uint16_t fcf_index)
 {
-	struct lpfc_fcf_pri *fcf_pri;
+	struct lpfc_fcf_pri *fcf_pri, *fcf_pri_next;
 	if (fcf_index >= LPFC_SLI4_FCF_TBL_INDX_MAX) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_FIP,
 				"2762 FCF (x%x) reached driver's book "
@@ -15818,7 +15818,8 @@ lpfc_sli4_fcf_rr_index_clear(struct lpfc
 	}
 	/* Clear the eligible FCF record index bmask */
 	spin_lock_irq(&phba->hbalock);
-	list_for_each_entry(fcf_pri, &phba->fcf.fcf_pri_list, list) {
+	list_for_each_entry_safe(fcf_pri, fcf_pri_next, &phba->fcf.fcf_pri_list,
+				 list) {
 		if (fcf_pri->fcf_rec.fcf_index == fcf_index) {
 			list_del_init(&fcf_pri->list);
 			break;



