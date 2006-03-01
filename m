From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 5/9] lpfc 8.1.3: Fix deadlock in lpfc_fdmi_tmo_handler
Date: Tue, 28 Feb 2006 22:33:09 -0500
Message-ID: <20060301033309.GA21575@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:45009 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S1750805AbWCADdL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 22:33:11 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k213X9MO021582
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 22:33:09 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k213X9Zs021580
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 22:33:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix deadlock in lpfc_fdmi_tmo_handler

lpfc_fdmi_tmo_handler was calling lpfc_fdmi_cmd with the host_lock
held.  lpfc_fdmi_cmd assumes the host_lock is released as it calls functions
that acquire the host_lock.  lpfc_fdmi_tmo_handler acquired the host_lock to
protect access to work_hba_events.  This was already checked in the worker
thread so we can remove that code completely and remove access to the
host_lock.

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

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
 
