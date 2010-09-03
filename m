From: madhu.iyengar@qlogic.com
Subject: [PATCH 4/7] qla2xxx: Correctly set fw hung and complete only waiting mbx.
Date: Fri,  3 Sep 2010 14:57:03 -0700
Message-ID: <1283551026-3886-5-git-send-email-madhu.iyengar@qlogic.com>
References: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42965 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1757601Ab0ICWDH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:03:07 -0400
In-Reply-To: <1283551026-3886-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: nkmi@yahoo.com

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

The fw_hung flag should be set ir-respective of if there is a
mbx command pending or not. Also the complete should be called
if there is a mbx waiting.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index e54d2fa..ad290dc 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3307,13 +3307,15 @@ qla82xx_check_fw_alive(scsi_qla_host_t *vha)
 				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			}
 			qla2xxx_wake_dpc(vha);
+			ha->flags.fw_hung = 1;
 			if (ha->flags.mbox_busy) {
-				ha->flags.fw_hung = 1;
 				ha->flags.mbox_int = 1;
 				DEBUG2(qla_printk(KERN_ERR, ha,
-				    "Due to fw hung, doing premature "
-				    "completion of mbx command\n"));
-				complete(&ha->mbx_intr_comp);
+					"Due to fw hung, doing premature "
+					"completion of mbx command\n"));
+				if (test_bit(MBX_INTR_WAIT,
+					&ha->mbx_cmd_flags))
+					complete(&ha->mbx_intr_comp);
 			}
 		}
 	} else
@@ -3419,13 +3421,15 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 				"%s(): Adapter reset needed!\n", __func__);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
+			ha->flags.fw_hung = 1;
 			if (ha->flags.mbox_busy) {
-				ha->flags.fw_hung = 1;
 				ha->flags.mbox_int = 1;
 				DEBUG2(qla_printk(KERN_ERR, ha,
-				    "Need reset, doing premature "
-				    "completion of mbx command\n"));
-				complete(&ha->mbx_intr_comp);
+					"Need reset, doing premature "
+					"completion of mbx command\n"));
+				if (test_bit(MBX_INTR_WAIT,
+					&ha->mbx_cmd_flags))
+					complete(&ha->mbx_intr_comp);
 			}
 		} else {
 			qla82xx_check_fw_alive(vha);
-- 
1.6.0.2

