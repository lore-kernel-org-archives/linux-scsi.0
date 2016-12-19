From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 06/11] lpfc: FCoE VPort enable-disable does not bring up
 the VPort
Date: Mon, 19 Dec 2016 14:35:28 -0800
Message-ID: <585860b0.XWFiEaXNtoNryhnl%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:49933 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933079AbcLSWfd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2016 17:35:33 -0500
Received: from flash (fx9xs32.lab.emulex.com [138.239.87.14])
        by relay.smtp.broadcom.com (Postfix) with SMTP id 90F012803ED
        for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2016 14:35:30 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


FCoE VPort enable-disable does not bring up the VPort.
VPI structure needed to be initialized before being re-registered.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_vport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index c27f4b7..e18bbc6 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -537,6 +537,12 @@ enable_vport(struct fc_vport *fc_vport)
 
 	spin_lock_irq(shost->host_lock);
 	vport->load_flag |= FC_LOADING;
+	if (vport->fc_flag & FC_VPORT_NEEDS_INIT_VPI) {
+		spin_unlock_irq(shost->host_lock);
+		lpfc_issue_init_vpi(vport);
+		goto out;
+	}
+
 	vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
 	spin_unlock_irq(shost->host_lock);
 
@@ -557,6 +563,8 @@ enable_vport(struct fc_vport *fc_vport)
 	} else {
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 	}
+
+out:
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
 			 "1827 Vport Enabled.\n");
 	return VPORT_OK;
-- 
2.5.0


