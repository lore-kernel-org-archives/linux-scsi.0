From: jsmart2021@gmail.com
Subject: [PATCH 09/20] lpfc: Fix nvme allocation bug on failed nvme_fc_register_localport
Date: Sat,  4 Mar 2017 09:30:29 -0800
Message-ID: <1488648640-5170-10-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:36516 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752261AbdCDRbA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:31:00 -0500
Received: by mail-qk0-f195.google.com with SMTP id n141so10940488qke.3
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:30:59 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

nvme bufs get allocated even when the registration fails.
Move allocation into the rsgistration success path.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index e1bf31e..26cde7c 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2164,10 +2164,10 @@ lpfc_nvme_create_localport(struct lpfc_vport *vport)
 		lport->vport = vport;
 		INIT_LIST_HEAD(&lport->rport_list);
 		vport->nvmei_support = 1;
+		len  = lpfc_new_nvme_buf(vport, phba->sli4_hba.nvme_xri_max);
+		vport->phba->total_nvme_bufs += len;
 	}
 
-	len  = lpfc_new_nvme_buf(vport, phba->sli4_hba.nvme_xri_max);
-	vport->phba->total_nvme_bufs += len;
 	return ret;
 }
 
-- 
2.5.0
