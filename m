From: madhu.iyengar@qlogic.com
Subject: [PATCH 08/10] qla2xxx: Clear local references of rport on device loss timeout notification from FC transport.
Date: Fri,  3 Sep 2010 15:20:55 -0700
Message-ID: <1283552457-4497-9-git-send-email-madhu.iyengar@qlogic.com>
References: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39334 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753494Ab0ICW06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:26:58 -0400
In-Reply-To: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

The clearing of local references to rport was blocked when abort is active. This code clears the
local references unconditionaly upon device loss timeout callback from FC transport.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a8689bf..f9d8842 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1538,22 +1538,22 @@ qla2x00_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (!fcport)
 		return;
 
-	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
-		return;
-
-	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
-		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
-		return;
-	}
-
 	/*
 	 * Transport has effectively 'deleted' the rport, clear
 	 * all local references.
 	 */
 	spin_lock_irq(host->host_lock);
-	fcport->rport = NULL;
+	fcport->rport = fcport->drport = NULL;
 	*((fc_port_t **)rport->dd_data) = NULL;
 	spin_unlock_irq(host->host_lock);
+
+	if (test_bit(ABORT_ISP_ACTIVE, &fcport->vha->dpc_flags))
+		return;
+
+	if (unlikely(pci_channel_offline(fcport->vha->hw->pdev))) {
+		qla2x00_abort_all_cmds(fcport->vha, DID_NO_CONNECT << 16);
+		return;
+	}
 }
 
 static void
-- 
1.6.0.2

