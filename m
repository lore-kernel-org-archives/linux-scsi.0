From: James.Smart@Emulex.Com
Subject: [PATCH 2 of 7] lpfc driver 8.0.30 : task mgmt bit clearing
Date: Wed, 10 Aug 2005 15:02:37 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F439E@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61581 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030196AbVHJTCk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 15:02:40 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j7AJ2cr7000735
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2005 12:02:39 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Clear task management bits when preparing SCSI commands

In lpfc_scsi_prep_cmnd, clear the task management bits (fcpCntl2 member
in the fcp_cmd structure) when preparing regular SCSI commands.

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -445,6 +445,8 @@ lpfc_scsi_prep_cmnd(struct lpfc_hba * ph
 	int datadir = scsi_cmnd->sc_data_direction;
 
 	lpfc_cmd->fcp_rsp->rspSnsLen = 0;
+	/* clear task management bits */
+	lpfc_cmd->fcp_cmnd->fcpCntl2 = 0;
 
 	lpfc_put_lun(lpfc_cmd->fcp_cmnd, lpfc_cmd->pCmd->device->lun);
 
