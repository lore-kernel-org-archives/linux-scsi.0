From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 6/22] lpfc 8.1.2: Explicitly initialize the skip_post argument to lpfc_sli_send_reset
Date: Tue, 28 Feb 2006 19:25:17 -0500
Message-ID: <20060301002517.GA15409@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:43430 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S932734AbWCAAZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:19 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PHQX015415
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:18 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PHOR015414
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:17 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Explicitly initialize the skip_post argument to lpfc_sli_send_reset
  on a ERATT interrupt.


Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2983,7 +2983,7 @@ lpfc_intr_handler(int irq, void *dev_id,
 			 * to shutdown interrupt when there is a
 			 * ERROR.
 			 */
-			lpfc_sli_send_reset(phba, phba->hba_state);
+			lpfc_sli_send_reset(phba, 1);
 		}
 
 		spin_lock(phba->host->host_lock);
