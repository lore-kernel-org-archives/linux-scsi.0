From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3] lpfc: Tie in to new dev_loss_tmo interface in nvme transport
Date: Fri,  3 Nov 2017 09:33:30 -0700
Message-ID: <20171103163330.28659-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:46921 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751385AbdKCQdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 12:33:39 -0400
Received: by mail-qk0-f196.google.com with SMTP id k123so3909936qke.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 09:33:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, James Smart <james.smart@broadcom.com>

This patch calls the new nvme transport routine for dev_loss_tmo
whenever the SCSI fc transport calls the lldd to make a dynamic
change to a remote ports dev_loss_tmo.

Signed-off-by: James Smart <james.smart@broadcom.com>

---
This lpfc patch, as dependent upon the new nvme transport
nvme_fc_set_remoteport_devloss() call, should enter via nvme-4.15

v2/v3:
  Ensure nvme_fc is enabled for compilation
---
 drivers/scsi/lpfc/lpfc_attr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index c17677f494af..3e02bc3a7c3f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3246,6 +3246,11 @@ lpfc_update_rport_devloss_tmo(struct lpfc_vport *vport)
 			continue;
 		if (ndlp->rport)
 			ndlp->rport->dev_loss_tmo = vport->cfg_devloss_tmo;
+#if (IS_ENABLED(CONFIG_NVME_FC))
+		if (ndlp->nrport)
+			nvme_fc_set_remoteport_devloss(ndlp->nrport->remoteport,
+						       vport->cfg_devloss_tmo);
+#endif
 	}
 	spin_unlock_irq(shost->host_lock);
 }
-- 
2.13.1
