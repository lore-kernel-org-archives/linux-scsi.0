From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 14/21] lpfc: Disable NPIV support if NVME is enabled
Date: Fri, 29 Sep 2017 17:34:40 -0700
Message-ID: <20170930003447.10747-15-jsmart2021@gmail.com>
References: <20170930003447.10747-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35960 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752601AbdI3AfJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 20:35:09 -0400
Received: by mail-qk0-f193.google.com with SMTP id z14so776434qkg.3
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2017 17:35:09 -0700 (PDT)
In-Reply-To: <20170930003447.10747-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

The initial implementation of NVME didn't merge with NPIV support.
As such, there are several issues if NPIV is used with NVME. For now,
ensure that if NVME is enabled then NPIV is not enabled.

Support for NPIV with NVME will be added in the near future.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_vport.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index c714482bf4c5..c9d33b1268cb 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -313,6 +313,15 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 		goto error_out;
 	}
 
+	/* NPIV is not supported if HBA has NVME enabled */
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
+				"3189 Create VPORT failed: "
+				"NPIV is not supported on NVME\n");
+		rc = VPORT_INVAL;
+		goto error_out;
+	}
+
 	vpi = lpfc_alloc_vpi(phba);
 	if (vpi == 0) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
-- 
2.13.1
