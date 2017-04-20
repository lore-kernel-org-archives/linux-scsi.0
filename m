From: jsmart2021@gmail.com
Subject: ["PATCH-v2" 08/22] Remove NULL ptr check before kfree.
Date: Thu, 20 Apr 2017 15:04:34 -0700
Message-ID: <20170420220448.27095-9-jsmart2021@gmail.com>
References: <20170420220448.27095-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36380 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938903AbdDTWFK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 18:05:10 -0400
Received: by mail-oi0-f68.google.com with SMTP id a3so8781666oii.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2017 15:05:10 -0700 (PDT)
In-Reply-To: <20170420220448.27095-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

The check for NULL ptr is not necessary, kfree will check it.

Removing NULL ptr check.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 913eed82..76857e2 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -5700,10 +5700,8 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	struct lpfc_hba   *phba = vport->phba;
 
-	if (vport->disc_trc) {
-		kfree(vport->disc_trc);
-		vport->disc_trc = NULL;
-	}
+	kfree(vport->disc_trc);
+	vport->disc_trc = NULL;
 
 	debugfs_remove(vport->debug_disc_trc); /* discovery_trace */
 	vport->debug_disc_trc = NULL;
@@ -5770,10 +5768,8 @@ lpfc_debugfs_terminate(struct lpfc_vport *vport)
 		debugfs_remove(phba->debug_readRef); /* readRef */
 		phba->debug_readRef = NULL;
 
-		if (phba->slow_ring_trc) {
-			kfree(phba->slow_ring_trc);
-			phba->slow_ring_trc = NULL;
-		}
+		kfree(phba->slow_ring_trc);
+		phba->slow_ring_trc = NULL;
 
 		/* slow_ring_trace */
 		debugfs_remove(phba->debug_slow_ring_trc);
-- 
2.9.3
