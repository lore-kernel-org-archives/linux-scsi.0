From: madhu.iyengar@qlogic.com
Subject: [PATCH 13/18] qla2xxx: Display hardware/firmware registers to get more information about the error for ISP82xx.
Date: Wed, 30 Mar 2011 11:46:28 -0700
Message-ID: <1301510793-2492-14-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45798 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755734Ab1C3SvQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:16 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 6e4b429..9eadb7c 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3650,6 +3650,24 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 			if (qla82xx_check_fw_alive(vha)) {
 				halt_status = qla82xx_rd_32(ha,
 				    QLA82XX_PEG_HALT_STATUS1);
+				qla_printk(KERN_INFO, ha,
+				    "scsi(%ld): %s, Dumping hw/fw registers:\n "
+				    " PEG_HALT_STATUS1: 0x%x, PEG_HALT_STATUS2: 0x%x,\n "
+				    " PEG_NET_0_PC: 0x%x, PEG_NET_1_PC: 0x%x,\n "
+				    " PEG_NET_2_PC: 0x%x, PEG_NET_3_PC: 0x%x,\n "
+				    " PEG_NET_4_PC: 0x%x\n",
+				    vha->host_no, __func__, halt_status,
+				    qla82xx_rd_32(ha, QLA82XX_PEG_HALT_STATUS2),
+				    qla82xx_rd_32(ha,
+					    QLA82XX_CRB_PEG_NET_0 + 0x3c),
+				    qla82xx_rd_32(ha,
+					    QLA82XX_CRB_PEG_NET_1 + 0x3c),
+				    qla82xx_rd_32(ha,
+					    QLA82XX_CRB_PEG_NET_2 + 0x3c),
+				    qla82xx_rd_32(ha,
+					    QLA82XX_CRB_PEG_NET_3 + 0x3c),
+				    qla82xx_rd_32(ha,
+					    QLA82XX_CRB_PEG_NET_4 + 0x3c));
 				if (halt_status & HALT_STATUS_UNRECOVERABLE) {
 					set_bit(ISP_UNRECOVERABLE,
 					    &vha->dpc_flags);
-- 
1.6.0.2

