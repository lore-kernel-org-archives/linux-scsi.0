From: madhu.iyengar@qlogic.com
Subject: [PATCH 2/4] qla2xxx: Fix hang during driver unload when vport is active.
Date: Fri,  6 May 2011 17:30:11 -0700
Message-ID: <1304728223-30817-6-git-send-email-madhu.iyengar@qlogic.com>
References: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:32830 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753970Ab1EGAnN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 20:43:13 -0400
In-Reply-To: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Arun Easi <arun.easi@qlogic.com>

From: Arun Easi <arun.easi@qlogic.com>

Bumping ref count during fc_vport_terminate() was the cause. vport
delete would wait for ref count to drop to zero and that would never
happen.

Cc: stable@kernel.org
Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0ca6664..e1efbc7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2368,21 +2368,26 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	base_vha = pci_get_drvdata(pdev);
 	ha = base_vha->hw;
 
-	spin_lock_irqsave(&ha->vport_slock, flags);
-	list_for_each_entry(vha, &ha->vp_list, list) {
-		atomic_inc(&vha->vref_count);
+	mutex_lock(&ha->vport_lock);
+	while (ha->cur_vport_count) {
+		struct Scsi_Host *scsi_host;
 
-		if (vha->fc_vport) {
-			spin_unlock_irqrestore(&ha->vport_slock, flags);
+		spin_lock_irqsave(&ha->vport_slock, flags);
 
-			fc_vport_terminate(vha->fc_vport);
+		BUG_ON(base_vha->list.next == &ha->vp_list);
+		/* This assumes first entry in ha->vp_list is always base vha */
+		vha = list_first_entry(&base_vha->list, scsi_qla_host_t, list);
+		scsi_host = scsi_host_get(vha->host);
 
-			spin_lock_irqsave(&ha->vport_slock, flags);
-		}
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+		mutex_unlock(&ha->vport_lock);
+
+		fc_vport_terminate(vha->fc_vport);
+		scsi_host_put(vha->host);
 
-		atomic_dec(&vha->vref_count);
+		mutex_lock(&ha->vport_lock);
 	}
-	spin_unlock_irqrestore(&ha->vport_slock, flags);
+	mutex_unlock(&ha->vport_lock);
 
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 
-- 
1.6.0.2

