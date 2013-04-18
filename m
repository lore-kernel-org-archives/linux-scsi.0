From: James Smart <james.smart@emulex.com>
Subject: [PATCH 13/22] lpfc 8.3.39: Fixed deadlock between hbalock and
 nlp_lock use
Date: Wed, 17 Apr 2013 20:18:19 -0400
Message-ID: <1366244299.1513.14.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24324 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935849Ab3DRASW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:18:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed deadlock between hbalock and nlp_lock use.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hbadisc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-04-15 18:26:26.937040890 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2013-04-15 18:26:44.695041295 -0400
@@ -160,11 +160,12 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 	if (!list_empty(&evtp->evt_listp))
 		return;
 
+	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
+
 	spin_lock_irq(&phba->hbalock);
 	/* We need to hold the node by incrementing the reference
 	 * count until this queued work is done
 	 */
-	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
 	if (evtp->evt_arg1) {
 		evtp->evt = LPFC_EVT_DEV_LOSS;
 		list_add_tail(&evtp->evt_listp, &phba->work_list);



