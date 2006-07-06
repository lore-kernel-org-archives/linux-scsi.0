From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/15] lpfc 8.1.7 : Use mod_timer instead of add_timer in
	lpfc_els_timeout_handler
Date: Thu, 06 Jul 2006 15:49:16 -0400
Message-ID: <1152215356.23158.18.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:15756 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750766AbWGFTtB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:49:01 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66Jmxkq006909
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:49:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Use mod_timer instead of add_timer in lpfc_els_timeout_handler

This patch was formerly posted by Mark Haverkamp.
http://marc.theaimsgroup.com/?l=linux-scsi&m=114246089015681&w=2

Signed-off-by: Mark Haverkamp <markh@osdl.org>
Signed-off-by: James Smart <James.Smart@emulex.com>

diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2006-07-05 14:49:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2006-07-06 12:14:54.000000000 -0400
@@ -3282,10 +3282,9 @@ lpfc_els_timeout_handler(struct lpfc_hba
 		} else
 			lpfc_sli_release_iocbq(phba, piocb);
 	}
-	if (phba->sli.ring[LPFC_ELS_RING].txcmplq_cnt) {
-		phba->els_tmofunc.expires = jiffies + HZ * timeout;
-		add_timer(&phba->els_tmofunc);
-	}
+	if (phba->sli.ring[LPFC_ELS_RING].txcmplq_cnt)
+		mod_timer(&phba->els_tmofunc, jiffies + HZ * timeout);
+
 	spin_unlock_irq(phba->host->host_lock);
 }
 


