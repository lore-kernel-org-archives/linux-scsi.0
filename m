From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 04/20] lpfc: Fix oops when NVME Target is discovered in a nonNVME environment
Date: Wed, 23 Aug 2017 16:55:33 -0700
Message-ID: <20170823235549.2883-5-jsmart2021@gmail.com>
References: <20170823235549.2883-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38397 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdHWX4I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 19:56:08 -0400
Received: by mail-wr0-f193.google.com with SMTP id 94so577720wri.5
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 16:56:08 -0700 (PDT)
In-Reply-To: <20170823235549.2883-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

lpfc oops when it discovers a NVME target but is configured for SCSI
only operation. Oops is in lpfc_nvme_register_port+0x33/0x300.

The localport is not valid so it should not have been referenced.

Added validity check for localport

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index c18db8707fed..ce8d6bbf8148 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2296,6 +2296,9 @@ lpfc_nvme_register_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			 ndlp->nlp_DID, ndlp->nlp_type);
 
 	localport = vport->localport;
+	if (!localport)
+		return 0;
+
 	lport = (struct lpfc_nvme_lport *)localport->private;
 
 	/* NVME rports are not preserved across devloss.
-- 
2.13.1
