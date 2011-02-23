From: madhu.iyengar@qlogic.com
Subject: [PATCH 08/13] qla2xxx: Clear any stale login-states during an adapter reset.
Date: Wed, 23 Feb 2011 15:27:13 -0800
Message-ID: <1298503638-22396-9-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52632 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755173Ab1BWXaa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:30 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

By not clearing the 'login needed' nor 'login outstanding' states
for an fcport after a big-hammer (adapter reset), the driver may
not properly perform a PLOGI/PRLI sequence (and lose visibility
to the rport) during a follow-on SNS scan.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1bc5d19..bbf4a15 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3945,6 +3945,7 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *vp;
 	unsigned long flags;
+	fc_port_t *fcport;
 
 	vha->flags.online = 0;
 	ha->flags.chip_reset_done = 0;
@@ -3980,6 +3981,22 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 			    LOOP_DOWN_TIME);
 	}
 
+	/* Clear all async request states across all VPs. */
+	list_for_each_entry(fcport, &vha->vp_fcports, list)
+		fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+	spin_lock_irqsave(&ha->vport_slock, flags);
+	list_for_each_entry(vp, &ha->vp_list, list) {
+		atomic_inc(&vp->vref_count);
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+		list_for_each_entry(fcport, &vp->vp_fcports, list)
+			fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		atomic_dec(&vp->vref_count);
+	}
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	if (!ha->flags.eeh_busy) {
 		/* Make sure for ISP 82XX IO DMA is complete */
 		if (IS_QLA82XX(ha))
-- 
1.6.0.2

