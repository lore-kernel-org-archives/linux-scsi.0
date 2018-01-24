From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 11/19] lpfc: Fix issue_lip if link is disabled
Date: Wed, 24 Jan 2018 14:45:40 -0800
Message-ID: <20180124224548.9530-12-jsmart2021@gmail.com>
References: <20180124224548.9530-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:40589 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932800AbeAXWqN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2018 17:46:13 -0500
Received: by mail-qt0-f195.google.com with SMTP id s39so14655158qth.7
        for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2018 14:46:13 -0800 (PST)
In-Reply-To: <20180124224548.9530-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The driver ignored checks on whether the link should be
kept administratively down after a link bounce. Correct the
checks.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index d8064e3ea0ba..b79dad7b8278 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -911,7 +911,12 @@ lpfc_issue_lip(struct Scsi_Host *shost)
 	LPFC_MBOXQ_t *pmboxq;
 	int mbxstatus = MBXERR_ERROR;
 
+	/*
+	 * If the link is offline, disabled or BLOCK_MGMT_IO
+	 * it doesn't make any sense to allow issue_lip
+	 */
 	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
+	    (phba->hba_flag & LINK_DISABLED) ||
 	    (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO))
 		return -EPERM;
 
-- 
2.13.1
