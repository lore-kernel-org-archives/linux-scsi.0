From: madhu.iyengar@qlogic.com
Subject: [PATCH 07/11] qla2xxx: Add host number in reset and quiescent message logs.
Date: Tue, 10 May 2011 11:30:12 -0700
Message-ID: <1305052216-17347-8-git-send-email-madhu.iyengar@qlogic.com>
References: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39933 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751687Ab1EJSge (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 May 2011 14:36:34 -0400
In-Reply-To: <1305052216-17347-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 5d5b603..e1138bc 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3657,7 +3657,8 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 		if (dev_state == QLA82XX_DEV_NEED_RESET &&
 		    !test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags)) {
 			qla_printk(KERN_WARNING, ha,
-			    "%s(): Adapter reset needed!\n", __func__);
+			    "scsi(%ld) %s: Adapter reset needed!\n",
+				vha->host_no, __func__);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		} else if (dev_state == QLA82XX_DEV_NEED_QUIESCENT &&
@@ -3704,8 +3705,9 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 				if (ha->flags.mbox_busy) {
 					ha->flags.mbox_int = 1;
 					DEBUG2(qla_printk(KERN_ERR, ha,
-					    "Due to fw hung, doing premature "
-					    "completion of mbx command\n"));
+					    "scsi(%ld) Due to fw hung, doing "
+					    "premature completion of mbx "
+					    "command\n", vha->host_no));
 					if (test_bit(MBX_INTR_WAIT,
 					    &ha->mbx_cmd_flags))
 						complete(&ha->mbx_intr_comp);
-- 
1.6.0.2

