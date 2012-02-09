From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 09/29] qla2xxx: Increase speed of flash access in ISP82xx adapters to improve firmware load speed.
Date: Thu, 9 Feb 2012 11:15:41 -0800
Message-ID: <1328814961-21866-10-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:52335
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758424Ab2BITcK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:10 -0500
Received: from mail27-ch1 (localhost [127.0.0.1])	by mail27-ch1-R.bigfish.com
 (Postfix) with ESMTP id E84FF40020F	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:32:09 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   67 ++++++++++++++++------------------------
 1 files changed, 27 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 0a2f2d5..b0df7da 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -908,27 +908,37 @@ qla82xx_wait_rom_done(struct qla_hw_data *ha)
 	return 0;
 }
 
+int
+qla82xx_md_rw_32(struct qla_hw_data *ha, uint32_t off, u32 data, uint8_t flag)
+{
+	uint32_t  off_value, rval = 0;
+
+	WRT_REG_DWORD((void *)(CRB_WINDOW_2M + ha->nx_pcibase),
+	    (off & 0xFFFF0000));
+
+	/* Read back value to make sure write has gone through */
+	RD_REG_DWORD((void *)(CRB_WINDOW_2M + ha->nx_pcibase));
+	off_value  = (off & 0x0000FFFF);
+
+	if (flag)
+		WRT_REG_DWORD((void *)
+		    (off_value + CRB_INDIRECT_2M + ha->nx_pcibase),
+		    data);
+	else
+		rval = RD_REG_DWORD((void *)
+		    (off_value + CRB_INDIRECT_2M + ha->nx_pcibase));
+
+	return rval;
+}
+
 static int
 qla82xx_do_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 {
-	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+	/* Dword reads to flash. */
+	qla82xx_md_rw_32(ha, MD_DIRECT_ROM_WINDOW, (addr & 0xFFFF0000), 1);
+	*valp = qla82xx_md_rw_32(ha, MD_DIRECT_ROM_READ_BASE +
+	    (addr & 0x0000FFFF), 0, 0);
 
-	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ADDRESS, addr);
-	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_DUMMY_BYTE_CNT, 0);
-	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 3);
-	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_INSTR_OPCODE, 0xb);
-	qla82xx_wait_rom_busy(ha);
-	if (qla82xx_wait_rom_done(ha)) {
-		ql_log(ql_log_fatal, vha, 0x00ba,
-		    "Error waiting for rom done.\n");
-		return -1;
-	}
-	/* Reset abyte_cnt and dummy_byte_cnt */
-	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_DUMMY_BYTE_CNT, 0);
-	udelay(10);
-	cond_resched();
-	qla82xx_wr_32(ha, QLA82XX_ROMUSB_ROM_ABYTE_CNT, 0);
-	*valp = qla82xx_rd_32(ha, QLA82XX_ROMUSB_ROM_RDATA);
 	return 0;
 }
 
@@ -3639,29 +3649,6 @@ qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
 }
 
 /* Minidump related functions */
-int
-qla82xx_md_rw_32(struct qla_hw_data *ha, uint32_t off, u32 data, uint8_t flag)
-{
-	uint32_t  off_value, rval = 0;
-
-	WRT_REG_DWORD((void *)(CRB_WINDOW_2M + ha->nx_pcibase),
-	    (off & 0xFFFF0000));
-
-	/* Read back value to make sure write has gone through */
-	RD_REG_DWORD((void *)(CRB_WINDOW_2M + ha->nx_pcibase));
-	off_value  = (off & 0x0000FFFF);
-
-	if (flag)
-		WRT_REG_DWORD((void *)
-		    (off_value + CRB_INDIRECT_2M + ha->nx_pcibase),
-		    data);
-	else
-		rval = RD_REG_DWORD((void *)
-		    (off_value + CRB_INDIRECT_2M + ha->nx_pcibase));
-
-	return rval;
-}
-
 static int
 qla82xx_minidump_process_control(scsi_qla_host_t *vha,
 	qla82xx_md_entry_hdr_t *entry_hdr, uint32_t **d_ptr)
-- 
1.6.0.2


