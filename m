From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 8/22] lpfc 8.1.2: Fixed a double insertion of mail box object to the SLI mailbox list.
Date: Tue, 28 Feb 2006 19:25:20 -0500
Message-ID: <20060301002520.GA15433@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:44454 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964806AbWCAAZW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:22 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PK6t015439
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:20 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PKNG015438
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:20 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed a double insertion of mail box object to the SLI mailbox list.

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2867,11 +2867,10 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 		pmboxq->context1 = NULL;
 		/* if schedule_timeout returns 0, we timed out and were not
 		   woken up */
-		if (timeleft == 0) {
+		if ((timeleft == 0) || signal_pending(current))
 			retval = MBX_TIMEOUT;
-		} else {
+		else
 			retval = MBX_SUCCESS;
-		}
 	}
 
 
