From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/11] lpfc 8.3.38: Fixed OXID reuse issue.
Date: Fri, 1 Mar 2013 16:37:14 -0500
Message-ID: <1362173834.8283.22.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:41671 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab3CAVil (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Mar 2013 16:38:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed OXID reuse issue.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    8 +++++++-
 lpfc_sli.c  |    6 ++++--
 2 files changed, 11 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-02-27 08:17:19.665047400 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-02-27 08:17:26.095047546 -0500
@@ -2306,7 +2306,13 @@ int lpfc_enable_rrq;
 module_param(lpfc_enable_rrq, int, S_IRUGO);
 MODULE_PARM_DESC(lpfc_enable_rrq, "Enable RRQ functionality");
 lpfc_param_show(enable_rrq);
-lpfc_param_init(enable_rrq, 0, 0, 1);
+/*
+# lpfc_enable_rrq: Track XRI/OXID reuse after IO failures
+#	0x0 = disabled, XRI/OXID use not tracked.
+#	0x1 = XRI/OXID reuse is timed with ratov, RRQ sent.
+#	0x2 = XRI/OXID reuse is timed with ratov, No RRQ sent.
+*/
+lpfc_param_init(enable_rrq, 2, 0, 2);
 static DEVICE_ATTR(lpfc_enable_rrq, S_IRUGO, lpfc_enable_rrq_show, NULL);
 
 /*
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-02-27 08:17:23.341047483 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-02-27 08:17:26.100047546 -0500
@@ -872,14 +872,16 @@ lpfc_set_rrq_active(struct lpfc_hba *phb
 				xritag, rxid, ndlp->nlp_DID, send_rrq);
 		return -EINVAL;
 	}
-	rrq->send_rrq = send_rrq;
+	if (phba->cfg_enable_rrq == 1)
+		rrq->send_rrq = send_rrq;
+	else
+		rrq->send_rrq = 0;
 	rrq->xritag = xritag;
 	rrq->rrq_stop_time = jiffies + HZ * (phba->fc_ratov + 1);
 	rrq->ndlp = ndlp;
 	rrq->nlp_DID = ndlp->nlp_DID;
 	rrq->vport = ndlp->vport;
 	rrq->rxid = rxid;
-	rrq->send_rrq = send_rrq;
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	empty = list_empty(&phba->active_rrq_list);
 	list_add_tail(&rrq->list, &phba->active_rrq_list);



