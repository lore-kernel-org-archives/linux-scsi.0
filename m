From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 19/20] qla2xxx: Synchronize MPI settings after a PE Reset.
Date: Wed,  3 Jun 2009 09:55:30 -0700
Message-ID: <1244048131-56590-20-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756942AbZFCQzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:49 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Ensure MPS remains in synchronization across all NIC/FCoE
functions after a reset.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    6 ++++
 drivers/scsi/qla2xxx/qla_init.c |   52 ++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_mbx.c  |   63 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 121 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 1ef18cc..65b12d8 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -299,6 +299,12 @@ qla2x00_get_xgmac_stats(scsi_qla_host_t *, dma_addr_t, uint16_t, uint16_t *);
 extern int
 qla2x00_get_dcbx_params(scsi_qla_host_t *, dma_addr_t, uint16_t);
 
+extern int
+qla2x00_read_ram_word(scsi_qla_host_t *, uint32_t, uint32_t *);
+
+extern int
+qla2x00_write_ram_word(scsi_qla_host_t *, uint32_t, uint32_t);
+
 /*
  * Global Function Prototypes in qla_isr.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 36cea22..2620261 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -886,6 +886,56 @@ cont_alloc:
 	    htonl(offsetof(struct qla2xxx_fw_dump, isp));
 }
 
+static int
+qla81xx_mpi_sync(scsi_qla_host_t *vha)
+{
+#define MPS_MASK	0xe0
+	int rval;
+	uint16_t dc;
+	uint32_t dw;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_QLA81XX(vha->hw))
+		return QLA_SUCCESS;
+
+	rval = qla2x00_write_ram_word(vha, 0x7c00, 1);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "Sync-MPI: Unable to acquire semaphore.\n"));
+		goto done;
+	}
+
+	pci_read_config_word(vha->hw->pdev, 0x54, &dc);
+	rval = qla2x00_read_ram_word(vha, 0x7a15, &dw);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "Sync-MPI: Unable to read sync.\n"));
+		goto done_release;
+	}
+
+	dc &= MPS_MASK;
+	if (dc == (dw & MPS_MASK))
+		goto done_release;
+
+	dw &= ~MPS_MASK;
+	dw |= dc;
+	rval = qla2x00_write_ram_word(vha, 0x7a15, dw);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "Sync-MPI: Unable to gain sync.\n"));
+	}
+
+done_release:
+	rval = qla2x00_write_ram_word(vha, 0x7c00, 0);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "Sync-MPI: Unable to release semaphore.\n"));
+	}
+
+done:
+	return rval;
+}
+
 /**
  * qla2x00_setup_chip() - Load and start RISC firmware.
  * @ha: HA context
@@ -910,6 +960,8 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
 
+	qla81xx_mpi_sync(vha);
+
 	/* Load firmware sequences */
 	rval = ha->isp_ops->load_risc(vha, &srisc_address);
 	if (rval == QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index f215578..451ece0 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3545,3 +3545,66 @@ qla2x00_get_dcbx_params(scsi_qla_host_t *vha, dma_addr_t tlv_dma,
 
 	return rval;
 }
+
+int
+qla2x00_read_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t *data)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_FWI2_CAPABLE(vha->hw))
+		return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_READ_RAM_EXTENDED;
+	mcp->mb[1] = LSW(risc_addr);
+	mcp->mb[8] = MSW(risc_addr);
+	mcp->out_mb = MBX_8|MBX_1|MBX_0;
+	mcp->in_mb = MBX_3|MBX_2|MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
+		    vha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		*data = mcp->mb[3] << 16 | mcp->mb[2];
+	}
+
+	return rval;
+}
+
+int
+qla2x00_write_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t data)
+{
+	int rval;
+	mbx_cmd_t mc;
+	mbx_cmd_t *mcp = &mc;
+
+	if (!IS_FWI2_CAPABLE(vha->hw))
+                return QLA_FUNCTION_FAILED;
+
+	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+
+	mcp->mb[0] = MBC_WRITE_RAM_WORD_EXTENDED;
+	mcp->mb[1] = LSW(risc_addr);
+	mcp->mb[2] = LSW(data);
+	mcp->mb[3] = MSW(data);
+	mcp->mb[8] = MSW(risc_addr);
+	mcp->out_mb = MBX_8|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_0;
+	mcp->tov = 30;
+	mcp->flags = 0;
+	rval = qla2x00_mailbox_command(vha, mcp);
+	if (rval != QLA_SUCCESS) {
+		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
+		    vha->host_no, rval, mcp->mb[0]));
+	} else {
+		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+	}
+
+	return rval;
+}
-- 
1.6.3.1.244.gf9275

