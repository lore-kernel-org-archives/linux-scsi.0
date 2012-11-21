From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 3/5] qla2xxx: Change in setting UNLOADING flag and FC vports logout sequence while unloading qla2xxx driver.
Date: Wed, 21 Nov 2012 02:39:55 -0500
Message-ID: <1353483597-17206-4-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483597-17206-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:46175 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753316Ab2KUH6H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:07 -0500
In-Reply-To: <1353483597-17206-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    3 +--
 drivers/scsi/qla2xxx/qla_os.c   |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 1c28215..83d7984 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1615,8 +1615,7 @@ qla2x00_terminate_rport_io(struct fc_rport *rport)
 	 * At this point all fcport's software-states are cleared.  Perform any
 	 * final cleanup of firmware resources (PCBs and XCBs).
 	 */
-	if (fcport->loop_id != FC_NO_LOOP_ID &&
-	    !test_bit(UNLOADING, &fcport->vha->dpc_flags)) {
+	if (fcport->loop_id != FC_NO_LOOP_ID) {
 		if (IS_FWI2_CAPABLE(fcport->vha->hw))
 			fcport->vha->hw->isp_ops->fabric_logout(fcport->vha,
 			    fcport->loop_id, fcport->d_id.b.domain,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a603967..f4b1fc8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2755,6 +2755,7 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	ha->flags.host_shutting_down = 1;
 
+	set_bit(UNLOADING, &base_vha->dpc_flags);
 	mutex_lock(&ha->vport_lock);
 	while (ha->cur_vport_count) {
 		struct Scsi_Host *scsi_host;
@@ -2784,8 +2785,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 			    "Error while clearing DRV-Presence.\n");
 	}
 
-	set_bit(UNLOADING, &base_vha->dpc_flags);
-
 	qla2x00_abort_all_cmds(base_vha, DID_NO_CONNECT << 16);
 
 	qla2x00_dfs_remove(base_vha);
-- 
1.7.7

