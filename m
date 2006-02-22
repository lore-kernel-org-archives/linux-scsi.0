From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 5/9] lpfc 8.1.3 : Fix deadlock in lpfc_fdmi_tmo_handler
Date: Wed, 22 Feb 2006 12:33:41 -0500
Message-ID: <43FCA075.7080002@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:58329 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030324AbWBVRdo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 12:33:44 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k1MHXhrf029913
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 09:33:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Fix deadlock in lpfc_fdmi_tmo_handler

lpfc_fdmi_tmo_handler was calling lpfc_fdmi_cmd with the host_lock
held.  lpfc_fdmi_cmd assumes the host_lock is released as it calls functions
that acquire the host_lock.  lpfc_fdmi_tmo_handler acquired the host_lock to
protect access to work_hba_events.  This was already checked in the worker
thread so we can remove that code completely and remove access to the host_lock.


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1166,11 +1166,6 @@ lpfc_fdmi_tmo_handler(struct lpfc_hba *p
  {
  	struct lpfc_nodelist *ndlp;

-	spin_lock_irq(phba->host->host_lock);
-	if (!(phba->work_hba_events & WORKER_FDMI_TMO)) {
-		spin_unlock_irq(phba->host->host_lock);
-		return;
-	}
  	ndlp = lpfc_findnode_did(phba, NLP_SEARCH_ALL, FDMI_DID);
  	if (ndlp) {
  		if (system_utsname.nodename[0] != '\0') {
@@ -1179,7 +1174,6 @@ lpfc_fdmi_tmo_handler(struct lpfc_hba *p
  			mod_timer(&phba->fc_fdmitmo, jiffies + HZ * 60);
  		}
  	}
-	spin_unlock_irq(phba->host->host_lock);
  	return;
  }


