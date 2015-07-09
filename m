From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 10/10] qla2xxx: Avoid that sparse complains about context
 imbalances
Date: Thu, 9 Jul 2015 07:25:46 -0700
Message-ID: <559E846A.20605@sandisk.com>
References: <559E8382.6030803@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0089.outbound.protection.outlook.com ([157.56.111.89]:29452
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750967AbbGIOZx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2015 10:25:53 -0400
In-Reply-To: <559E8382.6030803@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@odin.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Surround conditional locking statements with "#ifndef __CHECKER__" /
"#endif" to hide these for the sparse static source code analysis
tool.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    | 36 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_nx.c     |  8 ++++++++
 drivers/scsi/qla2xxx/qla_target.c |  4 ++++
 drivers/scsi/qla2xxx/qla_tmpl.c   |  4 ++++
 4 files changed, 52 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 1a1a221..583d52a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -695,8 +695,10 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 	flags = 0;
 
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
+#endif
 
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd002,
@@ -832,8 +834,12 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	qla2xxx_dump_post_process(base_vha, rval);
 
 qla2300_fw_dump_failed:
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+#else
+	;
+#endif
 }
 
 /**
@@ -859,8 +865,10 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	mb0 = mb2 = 0;
 	flags = 0;
 
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
+#endif
 
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd004,
@@ -1030,8 +1038,12 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	qla2xxx_dump_post_process(base_vha, rval);
 
 qla2100_fw_dump_failed:
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+#else
+	;
+#endif
 }
 
 void
@@ -1057,8 +1069,10 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	flags = 0;
 	ha->fw_dump_cap_flags = 0;
 
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
+#endif
 
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd006,
@@ -1282,8 +1296,12 @@ qla24xx_fw_dump_failed_0:
 	qla2xxx_dump_post_process(base_vha, rval);
 
 qla24xx_fw_dump_failed:
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+#else
+	;
+#endif
 }
 
 void
@@ -1305,8 +1323,10 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	flags = 0;
 	ha->fw_dump_cap_flags = 0;
 
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
+#endif
 
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd008,
@@ -1598,8 +1618,12 @@ qla25xx_fw_dump_failed_0:
 	qla2xxx_dump_post_process(base_vha, rval);
 
 qla25xx_fw_dump_failed:
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+#else
+	;
+#endif
 }
 
 void
@@ -1621,8 +1645,10 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	flags = 0;
 	ha->fw_dump_cap_flags = 0;
 
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
+#endif
 
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd00a,
@@ -1916,8 +1942,12 @@ qla81xx_fw_dump_failed_0:
 	qla2xxx_dump_post_process(base_vha, rval);
 
 qla81xx_fw_dump_failed:
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+#else
+	;
+#endif
 }
 
 void
@@ -1939,8 +1969,10 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 	flags = 0;
 	ha->fw_dump_cap_flags = 0;
 
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
+#endif
 
 	if (!ha->fw_dump) {
 		ql_log(ql_log_warn, vha, 0xd00c,
@@ -2419,8 +2451,12 @@ qla83xx_fw_dump_failed_0:
 	qla2xxx_dump_post_process(base_vha, rval);
 
 qla83xx_fw_dump_failed:
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+#else
+	;
+#endif
 }
 
 /****************************************************************************/
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index bb0ee7c..eb0cc54 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -476,7 +476,9 @@ qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u32 data)
 	BUG_ON(rv == -1);
 
 	if (rv == 1) {
+#ifndef __CHECKER__
 		write_lock_irqsave(&ha->hw_lock, flags);
+#endif
 		qla82xx_crb_win_lock(ha);
 		qla82xx_pci_set_crbwindow_2M(ha, off_in, &off);
 	}
@@ -485,7 +487,9 @@ qla82xx_wr_32(struct qla_hw_data *ha, ulong off_in, u32 data)
 
 	if (rv == 1) {
 		qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_UNLOCK));
+#ifndef __CHECKER__
 		write_unlock_irqrestore(&ha->hw_lock, flags);
+#endif
 	}
 	return 0;
 }
@@ -503,7 +507,9 @@ qla82xx_rd_32(struct qla_hw_data *ha, ulong off_in)
 	BUG_ON(rv == -1);
 
 	if (rv == 1) {
+#ifndef __CHECKER__
 		write_lock_irqsave(&ha->hw_lock, flags);
+#endif
 		qla82xx_crb_win_lock(ha);
 		qla82xx_pci_set_crbwindow_2M(ha, off_in, &off);
 	}
@@ -511,7 +517,9 @@ qla82xx_rd_32(struct qla_hw_data *ha, ulong off_in)
 
 	if (rv == 1) {
 		qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM7_UNLOCK));
+#ifndef __CHECKER__
 		write_unlock_irqrestore(&ha->hw_lock, flags);
+#endif
 	}
 	return data;
 }
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 445af44..6b7736d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3955,16 +3955,20 @@ static void qlt_reject_free_srr_imm(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags = 0;
 
+#ifndef __CHECKER__
 	if (!ha_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
+#endif
 
 	qlt_send_notify_ack(vha, (void *)&imm->imm_ntfy, 0, 0, 0,
 	    NOTIFY_ACK_SRR_FLAGS_REJECT,
 	    NOTIFY_ACK_SRR_REJECT_REASON_UNABLE_TO_PERFORM,
 	    NOTIFY_ACK_SRR_FLAGS_REJECT_EXPL_NO_EXPL);
 
+#ifndef __CHECKER__
 	if (!ha_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+#endif
 
 	kfree(imm);
 }
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index f4eb655..ddbe2e7 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -939,8 +939,10 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 {
 	ulong flags = 0;
 
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+#endif
 
 	if (!vha->hw->fw_dump)
 		ql_log(ql_log_warn, vha, 0xd01e, "fwdump buffer missing.\n");
@@ -953,6 +955,8 @@ qla27xx_fwdump(scsi_qla_host_t *vha, int hardware_locked)
 	else
 		qla27xx_execute_fwdt_template(vha);
 
+#ifndef __CHECKER__
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+#endif
 }
-- 
2.1.4

