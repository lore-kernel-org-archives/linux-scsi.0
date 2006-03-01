From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 20/22] lpfc 8.1.2: Fix panic caused by HBA resets and target side cable pulls
Date: Tue, 28 Feb 2006 19:25:36 -0500
Message-ID: <20060301002536.GA15582@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:63424 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964865AbWCAAZi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:38 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PbFe015588
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:37 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PakP015587
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:36 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix panic caused by HBA resets and target side cable pulls

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2005 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2006 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -467,7 +467,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	sdev = cmd->device;
 	cmd->scsi_done(cmd);
 
-	if (!result &&
+	if (!result && pnode != NULL &&
 	   ((jiffies - pnode->last_ramp_up_time) >
 		LPFC_Q_RAMP_UP_INTERVAL * HZ) &&
 	   ((jiffies - pnode->last_q_full_time) >
@@ -495,7 +495,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	 * Check for queue full.  If the lun is reporting queue full, then
 	 * back off the lun queue depth to prevent target overloads.
 	 */
-	if (result == SAM_STAT_TASK_SET_FULL) {
+	if (result == SAM_STAT_TASK_SET_FULL && pnode != NULL) {
 		pnode->last_q_full_time = jiffies;
 
 		shost_for_each_device(tmp_sdev, sdev->host) {
