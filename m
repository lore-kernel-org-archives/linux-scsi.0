From: vikas.chaudhary@qlogic.com
Subject: [PATCH 03/10] qla4xxx: Dump HW/FW reg to figure out what caused FW to be hung for ISP82XX
Date: Tue, 17 May 2011 23:17:05 -0700
Message-ID: <1305699432-13225-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:50917 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754459Ab1ERGXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 02:23:46 -0400
In-Reply-To: <1305699432-13225-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c22f2a7..b657ece 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -679,7 +679,27 @@ static void qla4_8xxx_check_fw_alive(struct scsi_qla_host *ha)
 		if (ha->seconds_since_last_heartbeat == 2) {
 			ha->seconds_since_last_heartbeat = 0;
 			halt_status = qla4_8xxx_rd_32(ha,
-			    QLA82XX_PEG_HALT_STATUS1);
+						      QLA82XX_PEG_HALT_STATUS1);
+
+			ql4_printk(KERN_INFO, ha,
+				   "scsi(%ld): %s, Dumping hw/fw registers:\n "
+				   " PEG_HALT_STATUS1: 0x%x, PEG_HALT_STATUS2:"
+				   " 0x%x,\n PEG_NET_0_PC: 0x%x, PEG_NET_1_PC:"
+				   " 0x%x,\n PEG_NET_2_PC: 0x%x, PEG_NET_3_PC:"
+				   " 0x%x,\n PEG_NET_4_PC: 0x%x\n",
+				   ha->host_no, __func__, halt_status,
+				   qla4_8xxx_rd_32(ha,
+						   QLA82XX_PEG_HALT_STATUS2),
+				   qla4_8xxx_rd_32(ha, QLA82XX_CRB_PEG_NET_0 +
+						   0x3c),
+				   qla4_8xxx_rd_32(ha, QLA82XX_CRB_PEG_NET_1 +
+						   0x3c),
+				   qla4_8xxx_rd_32(ha, QLA82XX_CRB_PEG_NET_2 +
+						   0x3c),
+				   qla4_8xxx_rd_32(ha, QLA82XX_CRB_PEG_NET_3 +
+						   0x3c),
+				   qla4_8xxx_rd_32(ha, QLA82XX_CRB_PEG_NET_4 +
+						   0x3c));
 
 			/* Since we cannot change dev_state in interrupt
 			 * context, set appropriate DPC flag then wakeup
-- 
1.7.3.2

