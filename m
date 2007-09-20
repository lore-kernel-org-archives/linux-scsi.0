From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 08/19] qla2xxx: Query additional RISC registers during ISP25XX firmware dump.
Date: Thu, 20 Sep 2007 14:07:39 -0700
Message-ID: <1190322470-15543-8-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbXITVHv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:51 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |   18 ++++++++++++++++++
 drivers/scsi/qla2xxx/qla_dbg.h |    2 ++
 drivers/scsi/qla2xxx/qla_fw.h  |    2 +-
 3 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2defe0c..ca7f70d 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1072,6 +1072,7 @@ qla25xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	}
 	fw = &ha->fw_dump->isp.isp25;
 	qla2xxx_prep_dump(ha, ha->fw_dump);
+	ha->fw_dump->version = __constant_htonl(2);
 
 	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
 
@@ -1080,6 +1081,23 @@ qla25xx_fw_dump(scsi_qla_host_t *ha, int hardware_locked)
 	if (rval != QLA_SUCCESS)
 		goto qla25xx_fw_dump_failed_0;
 
+	/* Host/Risc registers. */
+	iter_reg = fw->host_risc_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7000, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7010, 16, iter_reg);
+
+	/* PCIe registers. */
+	WRT_REG_DWORD(&reg->iobase_addr, 0x7C00);
+	RD_REG_DWORD(&reg->iobase_addr);
+	WRT_REG_DWORD(&reg->iobase_window, 0x01);
+	dmp_reg = &reg->iobase_c4;
+	fw->pcie_regs[0] = htonl(RD_REG_DWORD(dmp_reg++));
+	fw->pcie_regs[1] = htonl(RD_REG_DWORD(dmp_reg++));
+	fw->pcie_regs[2] = htonl(RD_REG_DWORD(dmp_reg));
+	fw->pcie_regs[3] = htonl(RD_REG_DWORD(&reg->iobase_window));
+	WRT_REG_DWORD(&reg->iobase_window, 0x00);
+	RD_REG_DWORD(&reg->iobase_window);
+
 	/* Host interface registers. */
 	dmp_reg = &reg->flash_addr;
 	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index cca4b0d..a50ecf0 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -215,6 +215,8 @@ struct qla24xx_fw_dump {
 
 struct qla25xx_fw_dump {
 	uint32_t host_status;
+	uint32_t host_risc_reg[32];
+	uint32_t pcie_regs[4];
 	uint32_t host_reg[32];
 	uint32_t shadow_reg[11];
 	uint32_t risc_io_reg;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index db63386..25364b1 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -942,7 +942,7 @@ struct device_reg_24xx {
 	uint16_t mailbox31;
 
 	uint32_t iobase_window;
-	uint32_t unused_4;		/* Gap. */
+	uint32_t iobase_c4;
 	uint32_t iobase_c8;
 	uint32_t unused_4_1[6];		/* Gap. */
 	uint32_t iobase_q;
-- 
1.5.3.2.80.g077d6f

