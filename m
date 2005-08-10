From: James.Smart@Emulex.Com
Subject: [PATCH 4 of 7] lpfc driver 8.0.30 : fix lip/cablepull panic
Date: Wed, 10 Aug 2005 15:02:50 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F43A0@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:2958 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1030198AbVHJTCw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 15:02:52 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j7AJ2pr7000756
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2005 12:02:51 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix panic on lip and cable pull

Symptoms: Panic on lip or cable pull

Cause: Use after free of nlp in lpfc_nlp_remove()

Fix: Do not make FC transport calls after a node is removed. Transport
calls are disabled by ignoring the initial delete transition.

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1135,6 +1135,8 @@ lpfc_nlp_list(struct lpfc_hba * phba, st
 	switch(list) {
 	case NLP_NO_LIST: /* No list, just remove it */
 		lpfc_nlp_remove(phba, nlp);
+		/* as node removed - stop further transport calls */
+		rport_del = none;
 		break;
 	case NLP_UNUSED_LIST:
 		spin_lock_irq(phba->host->host_lock);
