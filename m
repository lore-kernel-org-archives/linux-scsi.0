From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 20/22] lpfc 8.1.2 : Fix panic caused by HBA resets and target
 side cable pulls
Date: Wed, 08 Feb 2006 10:43:23 -0500
Message-ID: <43EA119B.6080509@emulex.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:56205 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1160999AbWBHPn2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Feb 2006 10:43:28 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k18FhRrf011950
	for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2006 07:43:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


Fix panic caused by HBA resets and target side cable pulls


Signed-off-by: James Smart <James.Smart@emulex.com>

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

