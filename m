From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 12/17] lpfc: Null pointer dereference when log_verbose is set to 0xffffffff
Date: Thu,  1 Jun 2017 21:07:06 -0700
Message-ID: <20170602040711.21046-13-jsmart2021@gmail.com>
References: <20170602040711.21046-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35768 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdFBEIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 00:08:05 -0400
Received: by mail-qt0-f193.google.com with SMTP id r58so8205136qtb.2
        for <linux-scsi@vger.kernel.org>; Thu, 01 Jun 2017 21:08:04 -0700 (PDT)
In-Reply-To: <20170602040711.21046-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Kernel panic when log_verbose is set to 0xffffffff

phba->pport is dereferenced before it is initialized

Fix: Do not dereference phba->pport if it is NULL

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c4ceef69bd6b..fb4c708ae747 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7513,7 +7513,8 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 				"(%d):0308 Mbox cmd issue - BUSY Data: "
 				"x%x x%x x%x x%x\n",
 				pmbox->vport ? pmbox->vport->vpi : 0xffffff,
-				mbx->mbxCommand, phba->pport->port_state,
+				mbx->mbxCommand,
+				phba->pport ? phba->pport->port_state : 0xff,
 				psli->sli_flag, flag);
 
 		psli->slistat.mbox_busy++;
@@ -7565,7 +7566,8 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmbox,
 			"(%d):0309 Mailbox cmd x%x issue Data: x%x x%x "
 			"x%x\n",
 			pmbox->vport ? pmbox->vport->vpi : 0,
-			mbx->mbxCommand, phba->pport->port_state,
+			mbx->mbxCommand,
+			phba->pport ? phba->pport->port_state : 0xff,
 			psli->sli_flag, flag);
 
 	if (mbx->mbxCommand != MBX_HEARTBEAT) {
-- 
2.11.0
