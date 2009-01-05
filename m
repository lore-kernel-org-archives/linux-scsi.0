From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 7/8] qla2xxx: Add ISP81XX support.
Date: Mon,  5 Jan 2009 11:18:11 -0800
Message-ID: <1231183092-10471-8-git-send-email-andrew.vasquez@qlogic.com>
References: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22498 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbZAETS3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 14:18:29 -0500
In-Reply-To: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Codes to support new FCoE boards.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   26 +++-
 drivers/scsi/qla2xxx/qla_dbg.c  |  324 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_dbg.h  |   40 +++++
 drivers/scsi/qla2xxx/qla_def.h  |   21 +++-
 drivers/scsi/qla2xxx/qla_dfs.c  |    3 +-
 drivers/scsi/qla2xxx/qla_fw.h   |  294 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_gbl.h  |    5 +-
 drivers/scsi/qla2xxx/qla_gs.c   |    9 +-
 drivers/scsi/qla2xxx/qla_init.c |  280 +++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c  |   60 +++++++-
 drivers/scsi/qla2xxx/qla_mbx.c  |   25 +++-
 drivers/scsi/qla2xxx/qla_os.c   |  113 +++++++++++---
 drivers/scsi/qla2xxx/qla_sup.c  |  143 ++++++++++--------
 13 files changed, 1234 insertions(+), 109 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index cd53627..c7acef5 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -303,7 +303,7 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		else if (start == (ha->flt_region_boot * 4) ||
 		    start == (ha->flt_region_fw * 4))
 			valid = 1;
-		else if (IS_QLA25XX(ha) &&
+		else if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) &&
 		    start == (ha->flt_region_vpd_nvram * 4))
 		    valid = 1;
 		if (!valid) {
@@ -815,6 +815,21 @@ qla2x00_total_isp_aborts_show(struct device *dev,
 	    ha->qla_stats.total_isp_aborts);
 }
 
+static ssize_t
+qla2x00_mpi_version_show(struct device *dev, struct device_attribute *attr,
+    char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!IS_QLA81XX(ha))
+		return snprintf(buf, PAGE_SIZE, "\n");
+
+	return snprintf(buf, PAGE_SIZE, "%02x.%02x.%02x.%02x (%x)\n",
+	    ha->mpi_version[0], ha->mpi_version[1], ha->mpi_version[2],
+	    ha->mpi_version[3], ha->mpi_capabilities);
+}
+
 static DEVICE_ATTR(driver_version, S_IRUGO, qla2x00_drvr_version_show, NULL);
 static DEVICE_ATTR(fw_version, S_IRUGO, qla2x00_fw_version_show, NULL);
 static DEVICE_ATTR(serial_num, S_IRUGO, qla2x00_serial_num_show, NULL);
@@ -839,6 +854,7 @@ static DEVICE_ATTR(optrom_fw_version, S_IRUGO, qla2x00_optrom_fw_version_show,
 		   NULL);
 static DEVICE_ATTR(total_isp_aborts, S_IRUGO, qla2x00_total_isp_aborts_show,
 		   NULL);
+static DEVICE_ATTR(mpi_version, S_IRUGO, qla2x00_mpi_version_show, NULL);
 
 struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version,
@@ -858,6 +874,7 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	&dev_attr_optrom_fcode_version,
 	&dev_attr_optrom_fw_version,
 	&dev_attr_total_isp_aborts,
+	&dev_attr_mpi_version,
 	NULL,
 };
 
@@ -892,6 +909,9 @@ qla2x00_get_host_speed(struct Scsi_Host *shost)
 	case PORT_SPEED_8GB:
 		speed = FC_PORTSPEED_8GBIT;
 		break;
+	case PORT_SPEED_10GB:
+		speed = FC_PORTSPEED_10GBIT;
+		break;
 	}
 	fc_host_speed(shost) = speed;
 }
@@ -1382,7 +1402,9 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
 	fc_host_max_npiv_vports(vha->host) = ha->max_npiv_vports;
 	fc_host_npiv_vports_inuse(vha->host) = ha->cur_vport_count;
 
-	if (IS_QLA25XX(ha))
+	if (IS_QLA81XX(ha))
+		speed = FC_PORTSPEED_10GBIT;
+	else if (IS_QLA25XX(ha))
 		speed = FC_PORTSPEED_8GBIT | FC_PORTSPEED_4GBIT |
 		    FC_PORTSPEED_2GBIT | FC_PORTSPEED_1GBIT;
 	else if (IS_QLA24XX_TYPE(ha))
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 4f47836..34760f8 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1324,6 +1324,330 @@ qla25xx_fw_dump_failed:
 	if (!hardware_locked)
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
+
+void
+qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
+{
+	int		rval;
+	uint32_t	cnt;
+	uint32_t	risc_address;
+	struct qla_hw_data *ha = vha->hw;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	uint32_t __iomem *dmp_reg;
+	uint32_t	*iter_reg;
+	uint16_t __iomem *mbx_reg;
+	unsigned long	flags;
+	struct qla81xx_fw_dump *fw;
+	uint32_t	ext_mem_cnt;
+	void		*nxt, *nxt_chain;
+	uint32_t	*last_chain = NULL;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+
+	risc_address = ext_mem_cnt = 0;
+	flags = 0;
+
+	if (!hardware_locked)
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	if (!ha->fw_dump) {
+		qla_printk(KERN_WARNING, ha,
+		    "No buffer available for dump!!!\n");
+		goto qla81xx_fw_dump_failed;
+	}
+
+	if (ha->fw_dumped) {
+		qla_printk(KERN_WARNING, ha,
+		    "Firmware has been previously dumped (%p) -- ignoring "
+		    "request...\n", ha->fw_dump);
+		goto qla81xx_fw_dump_failed;
+	}
+	fw = &ha->fw_dump->isp.isp81;
+	qla2xxx_prep_dump(ha, ha->fw_dump);
+
+	fw->host_status = htonl(RD_REG_DWORD(&reg->host_status));
+
+	/* Pause RISC. */
+	rval = qla24xx_pause_risc(reg);
+	if (rval != QLA_SUCCESS)
+		goto qla81xx_fw_dump_failed_0;
+
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
+
+	WRT_REG_DWORD(&reg->iobase_window, 0x00);
+	RD_REG_DWORD(&reg->iobase_window);
+
+	/* Host interface registers. */
+	dmp_reg = &reg->flash_addr;
+	for (cnt = 0; cnt < sizeof(fw->host_reg) / 4; cnt++)
+		fw->host_reg[cnt] = htonl(RD_REG_DWORD(dmp_reg++));
+
+	/* Disable interrupts. */
+	WRT_REG_DWORD(&reg->ictrl, 0);
+	RD_REG_DWORD(&reg->ictrl);
+
+	/* Shadow registers. */
+	WRT_REG_DWORD(&reg->iobase_addr, 0x0F70);
+	RD_REG_DWORD(&reg->iobase_addr);
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0000000);
+	fw->shadow_reg[0] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0100000);
+	fw->shadow_reg[1] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0200000);
+	fw->shadow_reg[2] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0300000);
+	fw->shadow_reg[3] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0400000);
+	fw->shadow_reg[4] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0500000);
+	fw->shadow_reg[5] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0600000);
+	fw->shadow_reg[6] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0700000);
+	fw->shadow_reg[7] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0800000);
+	fw->shadow_reg[8] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0900000);
+	fw->shadow_reg[9] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	WRT_REG_DWORD(&reg->iobase_select, 0xB0A00000);
+	fw->shadow_reg[10] = htonl(RD_REG_DWORD(&reg->iobase_sdata));
+
+	/* RISC I/O register. */
+	WRT_REG_DWORD(&reg->iobase_addr, 0x0010);
+	fw->risc_io_reg = htonl(RD_REG_DWORD(&reg->iobase_window));
+
+	/* Mailbox registers. */
+	mbx_reg = &reg->mailbox0;
+	for (cnt = 0; cnt < sizeof(fw->mailbox_reg) / 2; cnt++)
+		fw->mailbox_reg[cnt] = htons(RD_REG_WORD(mbx_reg++));
+
+	/* Transfer sequence registers. */
+	iter_reg = fw->xseq_gp_reg;
+	iter_reg = qla24xx_read_window(reg, 0xBF00, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF10, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF20, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF30, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF40, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF50, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBF60, 16, iter_reg);
+	qla24xx_read_window(reg, 0xBF70, 16, iter_reg);
+
+	iter_reg = fw->xseq_0_reg;
+	iter_reg = qla24xx_read_window(reg, 0xBFC0, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xBFD0, 16, iter_reg);
+	qla24xx_read_window(reg, 0xBFE0, 16, iter_reg);
+
+	qla24xx_read_window(reg, 0xBFF0, 16, fw->xseq_1_reg);
+
+	/* Receive sequence registers. */
+	iter_reg = fw->rseq_gp_reg;
+	iter_reg = qla24xx_read_window(reg, 0xFF00, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF10, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF20, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF30, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF40, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF50, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xFF60, 16, iter_reg);
+	qla24xx_read_window(reg, 0xFF70, 16, iter_reg);
+
+	iter_reg = fw->rseq_0_reg;
+	iter_reg = qla24xx_read_window(reg, 0xFFC0, 16, iter_reg);
+	qla24xx_read_window(reg, 0xFFD0, 16, iter_reg);
+
+	qla24xx_read_window(reg, 0xFFE0, 16, fw->rseq_1_reg);
+	qla24xx_read_window(reg, 0xFFF0, 16, fw->rseq_2_reg);
+
+	/* Auxiliary sequence registers. */
+	iter_reg = fw->aseq_gp_reg;
+	iter_reg = qla24xx_read_window(reg, 0xB000, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB010, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB020, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB030, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB040, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB050, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0xB060, 16, iter_reg);
+	qla24xx_read_window(reg, 0xB070, 16, iter_reg);
+
+	iter_reg = fw->aseq_0_reg;
+	iter_reg = qla24xx_read_window(reg, 0xB0C0, 16, iter_reg);
+	qla24xx_read_window(reg, 0xB0D0, 16, iter_reg);
+
+	qla24xx_read_window(reg, 0xB0E0, 16, fw->aseq_1_reg);
+	qla24xx_read_window(reg, 0xB0F0, 16, fw->aseq_2_reg);
+
+	/* Command DMA registers. */
+	qla24xx_read_window(reg, 0x7100, 16, fw->cmd_dma_reg);
+
+	/* Queues. */
+	iter_reg = fw->req0_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7200, 8, iter_reg);
+	dmp_reg = &reg->iobase_q;
+	for (cnt = 0; cnt < 7; cnt++)
+		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+	iter_reg = fw->resp0_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7300, 8, iter_reg);
+	dmp_reg = &reg->iobase_q;
+	for (cnt = 0; cnt < 7; cnt++)
+		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+	iter_reg = fw->req1_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7400, 8, iter_reg);
+	dmp_reg = &reg->iobase_q;
+	for (cnt = 0; cnt < 7; cnt++)
+		*iter_reg++ = htonl(RD_REG_DWORD(dmp_reg++));
+
+	/* Transmit DMA registers. */
+	iter_reg = fw->xmt0_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7600, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7610, 16, iter_reg);
+
+	iter_reg = fw->xmt1_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7620, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7630, 16, iter_reg);
+
+	iter_reg = fw->xmt2_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7640, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7650, 16, iter_reg);
+
+	iter_reg = fw->xmt3_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7660, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7670, 16, iter_reg);
+
+	iter_reg = fw->xmt4_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7680, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7690, 16, iter_reg);
+
+	qla24xx_read_window(reg, 0x76A0, 16, fw->xmt_data_dma_reg);
+
+	/* Receive DMA registers. */
+	iter_reg = fw->rcvt0_data_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7700, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7710, 16, iter_reg);
+
+	iter_reg = fw->rcvt1_data_dma_reg;
+	iter_reg = qla24xx_read_window(reg, 0x7720, 16, iter_reg);
+	qla24xx_read_window(reg, 0x7730, 16, iter_reg);
+
+	/* RISC registers. */
+	iter_reg = fw->risc_gp_reg;
+	iter_reg = qla24xx_read_window(reg, 0x0F00, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F10, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F20, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F30, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F40, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F50, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x0F60, 16, iter_reg);
+	qla24xx_read_window(reg, 0x0F70, 16, iter_reg);
+
+	/* Local memory controller registers. */
+	iter_reg = fw->lmc_reg;
+	iter_reg = qla24xx_read_window(reg, 0x3000, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3010, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3020, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3030, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3040, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3050, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x3060, 16, iter_reg);
+	qla24xx_read_window(reg, 0x3070, 16, iter_reg);
+
+	/* Fibre Protocol Module registers. */
+	iter_reg = fw->fpm_hdw_reg;
+	iter_reg = qla24xx_read_window(reg, 0x4000, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4010, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4020, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4030, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4040, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4050, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4060, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4070, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4080, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x4090, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x40A0, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x40B0, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x40C0, 16, iter_reg);
+	qla24xx_read_window(reg, 0x40D0, 16, iter_reg);
+
+	/* Frame Buffer registers. */
+	iter_reg = fw->fb_hdw_reg;
+	iter_reg = qla24xx_read_window(reg, 0x6000, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6010, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6020, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6030, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6040, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6100, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6130, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6150, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6170, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x6190, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x61B0, 16, iter_reg);
+	iter_reg = qla24xx_read_window(reg, 0x61C0, 16, iter_reg);
+	qla24xx_read_window(reg, 0x6F00, 16, iter_reg);
+
+	/* Multi queue registers */
+	nxt_chain = qla25xx_copy_mq(ha, (void *)ha->fw_dump + ha->chain_offset,
+	    &last_chain);
+
+	rval = qla24xx_soft_reset(ha);
+	if (rval != QLA_SUCCESS)
+		goto qla81xx_fw_dump_failed_0;
+
+	rval = qla24xx_dump_memory(ha, fw->code_ram, sizeof(fw->code_ram),
+	    &nxt);
+	if (rval != QLA_SUCCESS)
+		goto qla81xx_fw_dump_failed_0;
+
+	nxt = qla2xxx_copy_queues(ha, nxt);
+
+	nxt = qla24xx_copy_eft(ha, nxt);
+
+	/* Chain entries -- started with MQ. */
+	qla25xx_copy_fce(ha, nxt_chain, &last_chain);
+	if (last_chain) {
+		ha->fw_dump->version |= __constant_htonl(DUMP_CHAIN_VARIANT);
+		*last_chain |= __constant_htonl(DUMP_CHAIN_LAST);
+	}
+
+qla81xx_fw_dump_failed_0:
+	if (rval != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "Failed to dump firmware (%x)!!!\n", rval);
+		ha->fw_dumped = 0;
+
+	} else {
+		qla_printk(KERN_INFO, ha,
+		    "Firmware dump saved to temp buffer (%ld/%p).\n",
+		    base_vha->host_no, ha->fw_dump);
+		ha->fw_dumped = 1;
+	}
+
+qla81xx_fw_dump_failed:
+	if (!hardware_locked)
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
 /****************************************************************************/
 /*                         Driver Debug Functions.                          */
 /****************************************************************************/
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index c1794a7..f660dd7 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -251,6 +251,45 @@ struct qla25xx_fw_dump {
 	uint32_t ext_mem[1];
 };
 
+struct qla81xx_fw_dump {
+	uint32_t host_status;
+	uint32_t host_risc_reg[32];
+	uint32_t pcie_regs[4];
+	uint32_t host_reg[32];
+	uint32_t shadow_reg[11];
+	uint32_t risc_io_reg;
+	uint16_t mailbox_reg[32];
+	uint32_t xseq_gp_reg[128];
+	uint32_t xseq_0_reg[48];
+	uint32_t xseq_1_reg[16];
+	uint32_t rseq_gp_reg[128];
+	uint32_t rseq_0_reg[32];
+	uint32_t rseq_1_reg[16];
+	uint32_t rseq_2_reg[16];
+	uint32_t aseq_gp_reg[128];
+	uint32_t aseq_0_reg[32];
+	uint32_t aseq_1_reg[16];
+	uint32_t aseq_2_reg[16];
+	uint32_t cmd_dma_reg[16];
+	uint32_t req0_dma_reg[15];
+	uint32_t resp0_dma_reg[15];
+	uint32_t req1_dma_reg[15];
+	uint32_t xmt0_dma_reg[32];
+	uint32_t xmt1_dma_reg[32];
+	uint32_t xmt2_dma_reg[32];
+	uint32_t xmt3_dma_reg[32];
+	uint32_t xmt4_dma_reg[32];
+	uint32_t xmt_data_dma_reg[16];
+	uint32_t rcvt0_data_dma_reg[32];
+	uint32_t rcvt1_data_dma_reg[32];
+	uint32_t risc_gp_reg[128];
+	uint32_t lmc_reg[128];
+	uint32_t fpm_hdw_reg[224];
+	uint32_t fb_hdw_reg[208];
+	uint32_t code_ram[0x2000];
+	uint32_t ext_mem[1];
+};
+
 #define EFT_NUM_BUFFERS		4
 #define EFT_BYTES_PER_BUFFER	0x4000
 #define EFT_SIZE		((EFT_BYTES_PER_BUFFER) * (EFT_NUM_BUFFERS))
@@ -313,5 +352,6 @@ struct qla2xxx_fw_dump {
 		struct qla2300_fw_dump isp23;
 		struct qla24xx_fw_dump isp24;
 		struct qla25xx_fw_dump isp25;
+		struct qla81xx_fw_dump isp81;
 	} isp;
 };
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6b37622..023ee77 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2303,6 +2303,7 @@ struct qla_hw_data {
 #define PORT_SPEED_2GB  0x01
 #define PORT_SPEED_4GB  0x03
 #define PORT_SPEED_8GB  0x04
+#define PORT_SPEED_10GB	0x13
 	uint16_t	link_data_rate;         /* F/W operating speed */
 
 	uint8_t		current_topology;
@@ -2322,6 +2323,7 @@ struct qla_hw_data {
 
 #define PCI_DEVICE_ID_QLOGIC_ISP2532    0x2532
 #define PCI_DEVICE_ID_QLOGIC_ISP8432    0x8432
+#define PCI_DEVICE_ID_QLOGIC_ISP8001	0x8001
 	uint32_t	device_type;
 #define DT_ISP2100                      BIT_0
 #define DT_ISP2200                      BIT_1
@@ -2336,7 +2338,8 @@ struct qla_hw_data {
 #define DT_ISP5432                      BIT_10
 #define DT_ISP2532                      BIT_11
 #define DT_ISP8432                      BIT_12
-#define DT_ISP_LAST                     (DT_ISP8432 << 1)
+#define DT_ISP8001			BIT_13
+#define DT_ISP_LAST			(DT_ISP8001 << 1)
 
 #define DT_IIDMA                        BIT_26
 #define DT_FWI2                         BIT_27
@@ -2358,6 +2361,7 @@ struct qla_hw_data {
 #define IS_QLA5432(ha)  (DT_MASK(ha) & DT_ISP5432)
 #define IS_QLA2532(ha)  (DT_MASK(ha) & DT_ISP2532)
 #define IS_QLA8432(ha)  (DT_MASK(ha) & DT_ISP8432)
+#define IS_QLA8001(ha)	(DT_MASK(ha) & DT_ISP8001)
 
 #define IS_QLA23XX(ha)  (IS_QLA2300(ha) || IS_QLA2312(ha) || IS_QLA2322(ha) || \
 			IS_QLA6312(ha) || IS_QLA6322(ha))
@@ -2367,9 +2371,10 @@ struct qla_hw_data {
 #define IS_QLA84XX(ha)  (IS_QLA8432(ha))
 #define IS_QLA24XX_TYPE(ha)     (IS_QLA24XX(ha) || IS_QLA54XX(ha) || \
 				IS_QLA84XX(ha))
+#define IS_QLA81XX(ha)		(IS_QLA8001(ha))
 #define IS_QLA2XXX_MIDTYPE(ha)	(IS_QLA24XX(ha) || IS_QLA84XX(ha) || \
-				IS_QLA25XX(ha))
-#define IS_NOPOLLING_TYPE(ha)	(IS_QLA25XX(ha) && \
+				IS_QLA25XX(ha) || IS_QLA81XX(ha))
+#define IS_NOPOLLING_TYPE(ha)	((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && \
 				(ha)->flags.msix_enabled)
 
 #define IS_IIDMA_CAPABLE(ha)    ((ha)->device_type & DT_IIDMA)
@@ -2468,6 +2473,9 @@ struct qla_hw_data {
 	uint8_t		fw_seriallink_options[4];
 	uint16_t	fw_seriallink_options24[4];
 
+	uint8_t		mpi_version[4];
+	uint32_t	mpi_capabilities;
+
 	/* Firmware dump information. */
 	struct qla2xxx_fw_dump *fw_dump;
 	uint32_t	fw_dump_len;
@@ -2515,6 +2523,12 @@ struct qla_hw_data {
 	uint8_t 	fcode_revision[16];
 	uint32_t	fw_revision[4];
 
+	/* Offsets for flash/nvram access (set to ~0 if not used). */
+	uint32_t	flash_conf_off;
+	uint32_t	flash_data_off;
+	uint32_t	nvram_conf_off;
+	uint32_t	nvram_data_off;
+
 	uint32_t	fdt_wrt_disable;
 	uint32_t	fdt_erase_cmd;
 	uint32_t	fdt_block_size;
@@ -2729,6 +2743,7 @@ typedef struct scsi_qla_host {
 #define OPTROM_SIZE_2322	0x100000
 #define OPTROM_SIZE_24XX	0x100000
 #define OPTROM_SIZE_25XX	0x200000
+#define OPTROM_SIZE_81XX	0x400000
 
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 0e366a1..c66036d 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -113,7 +113,8 @@ int
 qla2x00_dfs_setup(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	if (!IS_QLA25XX(ha))
+
+	if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha))
 		goto out;
 	if (!ha->fce)
 		goto out;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index ee1f1e7..7abb045 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1215,9 +1215,10 @@ struct qla_fdt_layout {
 
 struct qla_flt_location {
 	uint8_t sig[4];
-	uint32_t start_lo;
-	uint32_t start_hi;
-	uint16_t unused;
+	uint16_t start_lo;
+	uint16_t start_hi;
+	uint8_t version;
+	uint8_t unused[5];
 	uint16_t checksum;
 };
 
@@ -1390,4 +1391,291 @@ struct access_chip_rsp_84xx {
 
 	uint32_t reserved[12];
 };
+
+/* 81XX Support **************************************************************/
+
+#define MBA_DCBX_START		0x8016
+#define MBA_DCBX_COMPLETE	0x8030
+#define MBA_FCF_CONF_ERR	0x8031
+#define MBA_DCBX_PARAM_UPDATE	0x8032
+#define MBA_IDC_COMPLETE	0x8100
+#define MBA_IDC_NOTIFY		0x8101
+#define MBA_IDC_TIME_EXT	0x8102
+
+struct nvram_81xx {
+	/* NVRAM header. */
+	uint8_t id[4];
+	uint16_t nvram_version;
+	uint16_t reserved_0;
+
+	/* Firmware Initialization Control Block. */
+	uint16_t version;
+	uint16_t reserved_1;
+	uint16_t frame_payload_size;
+	uint16_t execution_throttle;
+	uint16_t exchange_count;
+	uint16_t reserved_2;
+
+	uint8_t port_name[WWN_SIZE];
+	uint8_t node_name[WWN_SIZE];
+
+	uint16_t login_retry_count;
+	uint16_t reserved_3;
+	uint16_t interrupt_delay_timer;
+	uint16_t login_timeout;
+
+	uint32_t firmware_options_1;
+	uint32_t firmware_options_2;
+	uint32_t firmware_options_3;
+
+	uint16_t reserved_4[4];
+
+	/* Offset 64. */
+	uint8_t enode_mac[6];
+	uint16_t reserved_5[5];
+
+	/* Offset 80. */
+	uint16_t reserved_6[24];
+
+	/* Offset 128. */
+	uint16_t reserved_7[64];
+
+	/*
+	 * BIT 0  = Enable spinup delay
+	 * BIT 1  = Disable BIOS
+	 * BIT 2  = Enable Memory Map BIOS
+	 * BIT 3  = Enable Selectable Boot
+	 * BIT 4  = Disable RISC code load
+	 * BIT 5  = Disable Serdes
+	 * BIT 6  = Opt boot mode
+	 * BIT 7  = Interrupt enable
+	 *
+	 * BIT 8  = EV Control enable
+	 * BIT 9  = Enable lip reset
+	 * BIT 10 = Enable lip full login
+	 * BIT 11 = Enable target reset
+	 * BIT 12 = Stop firmware
+	 * BIT 13 = Enable nodename option
+	 * BIT 14 = Default WWPN valid
+	 * BIT 15 = Enable alternate WWN
+	 *
+	 * BIT 16 = CLP LUN string
+	 * BIT 17 = CLP Target string
+	 * BIT 18 = CLP BIOS enable string
+	 * BIT 19 = CLP Serdes string
+	 * BIT 20 = CLP WWPN string
+	 * BIT 21 = CLP WWNN string
+	 * BIT 22 =
+	 * BIT 23 =
+	 * BIT 24 = Keep WWPN
+	 * BIT 25 = Temp WWPN
+	 * BIT 26-31 =
+	 */
+	uint32_t host_p;
+
+	uint8_t alternate_port_name[WWN_SIZE];
+	uint8_t alternate_node_name[WWN_SIZE];
+
+	uint8_t boot_port_name[WWN_SIZE];
+	uint16_t boot_lun_number;
+	uint16_t reserved_8;
+
+	uint8_t alt1_boot_port_name[WWN_SIZE];
+	uint16_t alt1_boot_lun_number;
+	uint16_t reserved_9;
+
+	uint8_t alt2_boot_port_name[WWN_SIZE];
+	uint16_t alt2_boot_lun_number;
+	uint16_t reserved_10;
+
+	uint8_t alt3_boot_port_name[WWN_SIZE];
+	uint16_t alt3_boot_lun_number;
+	uint16_t reserved_11;
+
+	/*
+	 * BIT 0 = Selective Login
+	 * BIT 1 = Alt-Boot Enable
+	 * BIT 2 = Reserved
+	 * BIT 3 = Boot Order List
+	 * BIT 4 = Reserved
+	 * BIT 5 = Selective LUN
+	 * BIT 6 = Reserved
+	 * BIT 7-31 =
+	 */
+	uint32_t efi_parameters;
+
+	uint8_t reset_delay;
+	uint8_t reserved_12;
+	uint16_t reserved_13;
+
+	uint16_t boot_id_number;
+	uint16_t reserved_14;
+
+	uint16_t max_luns_per_target;
+	uint16_t reserved_15;
+
+	uint16_t port_down_retry_count;
+	uint16_t link_down_timeout;
+
+	/* FCode parameters. */
+	uint16_t fcode_parameter;
+
+	uint16_t reserved_16[3];
+
+	/* Offset 352. */
+	uint8_t reserved_17[4];
+	uint16_t reserved_18[5];
+	uint8_t reserved_19[2];
+	uint16_t reserved_20[8];
+
+	/* Offset 384. */
+	uint8_t reserved_21[16];
+	uint16_t reserved_22[8];
+
+	/* Offset 416. */
+	uint16_t reserved_23[32];
+
+	/* Offset 480. */
+	uint8_t model_name[16];
+
+	/* Offset 496. */
+	uint16_t feature_mask_l;
+	uint16_t feature_mask_h;
+	uint16_t reserved_24[2];
+
+	uint16_t subsystem_vendor_id;
+	uint16_t subsystem_device_id;
+
+	uint32_t checksum;
+};
+
+/*
+ * ISP Initialization Control Block.
+ * Little endian except where noted.
+ */
+#define	ICB_VERSION 1
+struct init_cb_81xx {
+	uint16_t version;
+	uint16_t reserved_1;
+
+	uint16_t frame_payload_size;
+	uint16_t execution_throttle;
+	uint16_t exchange_count;
+
+	uint16_t reserved_2;
+
+	uint8_t port_name[WWN_SIZE];		/* Big endian. */
+	uint8_t node_name[WWN_SIZE];		/* Big endian. */
+
+	uint16_t response_q_inpointer;
+	uint16_t request_q_outpointer;
+
+	uint16_t login_retry_count;
+
+	uint16_t prio_request_q_outpointer;
+
+	uint16_t response_q_length;
+	uint16_t request_q_length;
+
+	uint16_t reserved_3;
+
+	uint16_t prio_request_q_length;
+
+	uint32_t request_q_address[2];
+	uint32_t response_q_address[2];
+	uint32_t prio_request_q_address[2];
+
+	uint8_t reserved_4[8];
+
+	uint16_t atio_q_inpointer;
+	uint16_t atio_q_length;
+	uint32_t atio_q_address[2];
+
+	uint16_t interrupt_delay_timer;		/* 100us increments. */
+	uint16_t login_timeout;
+
+	/*
+	 * BIT 0-3 = Reserved
+	 * BIT 4  = Enable Target Mode
+	 * BIT 5  = Disable Initiator Mode
+	 * BIT 6  = Reserved
+	 * BIT 7  = Reserved
+	 *
+	 * BIT 8-13 = Reserved
+	 * BIT 14 = Node Name Option
+	 * BIT 15-31 = Reserved
+	 */
+	uint32_t firmware_options_1;
+
+	/*
+	 * BIT 0  = Operation Mode bit 0
+	 * BIT 1  = Operation Mode bit 1
+	 * BIT 2  = Operation Mode bit 2
+	 * BIT 3  = Operation Mode bit 3
+	 * BIT 4-7 = Reserved
+	 *
+	 * BIT 8  = Enable Class 2
+	 * BIT 9  = Enable ACK0
+	 * BIT 10 = Reserved
+	 * BIT 11 = Enable FC-SP Security
+	 * BIT 12 = FC Tape Enable
+	 * BIT 13 = Reserved
+	 * BIT 14 = Enable Target PRLI Control
+	 * BIT 15-31 = Reserved
+	 */
+	uint32_t firmware_options_2;
+
+	/*
+	 * BIT 0-3 = Reserved
+	 * BIT 4  = FCP RSP Payload bit 0
+	 * BIT 5  = FCP RSP Payload bit 1
+	 * BIT 6  = Enable Receive Out-of-Order data frame handling
+	 * BIT 7  = Reserved
+	 *
+	 * BIT 8  = Reserved
+	 * BIT 9  = Enable Out-of-Order FCP_XFER_RDY relative offset handling
+	 * BIT 10-16 = Reserved
+	 * BIT 17 = Enable multiple FCFs
+	 * BIT 18-20 = MAC addressing mode
+	 * BIT 21-25 = Ethernet data rate
+	 * BIT 26 = Enable ethernet header rx IOCB for ATIO q
+	 * BIT 27 = Enable ethernet header rx IOCB for response q
+	 * BIT 28 = SPMA selection bit 0
+	 * BIT 28 = SPMA selection bit 1
+	 * BIT 30-31 = Reserved
+	 */
+	uint32_t firmware_options_3;
+
+	uint8_t  reserved_5[8];
+
+	uint8_t enode_mac[6];
+
+	uint8_t reserved_6[10];
+};
+
+struct mid_init_cb_81xx {
+	struct init_cb_81xx init_cb;
+
+	uint16_t count;
+	uint16_t options;
+
+	struct mid_conf_entry_24xx entries[MAX_MULTI_ID_FABRIC];
+};
+
+#define FARX_ACCESS_FLASH_CONF_81XX	0x7FFD0000
+#define FARX_ACCESS_FLASH_DATA_81XX	0x7F800000
+
+/* 81XX Flash locations -- occupies second 2MB region. */
+#define FA_BOOT_CODE_ADDR_81	0x80000
+#define FA_RISC_CODE_ADDR_81	0xA0000
+#define FA_FW_AREA_ADDR_81	0xC0000
+#define FA_VPD_NVRAM_ADDR_81	0xD0000
+#define FA_FEATURE_ADDR_81	0xD4000
+#define FA_FLASH_DESCR_ADDR_81	0xD8000
+#define FA_FLASH_LAYOUT_ADDR_81	0xD8400
+#define FA_HW_EVENT0_ADDR_81	0xDC000
+#define FA_HW_EVENT1_ADDR_81	0xDC400
+#define FA_NPIV_CONF0_ADDR_81	0xD1000
+#define FA_NPIV_CONF1_ADDR_81	0xD2000
+
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 450a05c..ba49133 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -28,8 +28,10 @@ extern void qla2x00_reset_adapter(struct scsi_qla_host *);
 extern void qla24xx_reset_adapter(struct scsi_qla_host *);
 extern int qla2x00_nvram_config(struct scsi_qla_host *);
 extern int qla24xx_nvram_config(struct scsi_qla_host *);
+extern int qla81xx_nvram_config(struct scsi_qla_host *);
 extern void qla2x00_update_fw_options(struct scsi_qla_host *);
 extern void qla24xx_update_fw_options(scsi_qla_host_t *);
+extern void qla81xx_update_fw_options(scsi_qla_host_t *);
 extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
 extern int qla24xx_load_risc(scsi_qla_host_t *, uint32_t *);
 
@@ -141,7 +143,7 @@ qla2x00_execute_fw(scsi_qla_host_t *, uint32_t);
 
 extern void
 qla2x00_get_fw_version(scsi_qla_host_t *, uint16_t *,
-    uint16_t *, uint16_t *, uint16_t *, uint32_t *);
+    uint16_t *, uint16_t *, uint16_t *, uint32_t *, uint8_t *, uint32_t *);
 
 extern int
 qla2x00_get_fw_options(scsi_qla_host_t *, uint16_t *);
@@ -327,6 +329,7 @@ extern void qla2100_fw_dump(scsi_qla_host_t *, int);
 extern void qla2300_fw_dump(scsi_qla_host_t *, int);
 extern void qla24xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla25xx_fw_dump(scsi_qla_host_t *, int);
+extern void qla81xx_fw_dump(scsi_qla_host_t *, int);
 extern void qla2x00_dump_regs(scsi_qla_host_t *);
 extern void qla2x00_dump_buffer(uint8_t *, uint32_t);
 
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 0a6f729..557f58d 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1535,7 +1535,10 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_SUPPORT_SPEED);
 	eiter->len = __constant_cpu_to_be16(4 + 4);
-	if (IS_QLA25XX(ha))
+	if (IS_QLA81XX(ha))
+		eiter->a.sup_speed = __constant_cpu_to_be32(
+		    FDMI_PORT_SPEED_10GB);
+	else if (IS_QLA25XX(ha))
 		eiter->a.sup_speed = __constant_cpu_to_be32(
 		    FDMI_PORT_SPEED_1GB|FDMI_PORT_SPEED_2GB|
 		    FDMI_PORT_SPEED_4GB|FDMI_PORT_SPEED_8GB);
@@ -1575,6 +1578,10 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 		eiter->a.cur_speed =
 		    __constant_cpu_to_be32(FDMI_PORT_SPEED_8GB);
 		break;
+	case PORT_SPEED_10GB:
+		eiter->a.cur_speed =
+		    __constant_cpu_to_be32(FDMI_PORT_SPEED_10GB);
+		break;
 	default:
 		eiter->a.cur_speed =
 		    __constant_cpu_to_be32(FDMI_PORT_SPEED_UNKNOWN);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6038aed..2d4f32b 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -778,16 +778,19 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		mem_size = (ha->fw_memory_size - 0x11000 + 1) *
 		    sizeof(uint16_t);
 	} else if (IS_FWI2_CAPABLE(ha)) {
-		fixed_size = IS_QLA25XX(ha) ?
-			offsetof(struct qla25xx_fw_dump, ext_mem) :
-			offsetof(struct qla24xx_fw_dump, ext_mem);
+		if (IS_QLA81XX(ha))
+			fixed_size = offsetof(struct qla81xx_fw_dump, ext_mem);
+		else if (IS_QLA25XX(ha))
+			fixed_size = offsetof(struct qla25xx_fw_dump, ext_mem);
+		else
+			fixed_size = offsetof(struct qla24xx_fw_dump, ext_mem);
 		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
 		    sizeof(uint32_t);
 		if (ha->mqenable)
 			mq_size = sizeof(struct qla2xxx_mq_chain);
 
 		/* Allocate memory for Fibre Channel Event Buffer. */
-		if (!IS_QLA25XX(ha))
+		if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha))
 			goto try_eft;
 
 		tc = dma_alloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
@@ -988,7 +991,8 @@ qla2x00_setup_chip(scsi_qla_host_t *vha)
 				    &ha->fw_major_version,
 				    &ha->fw_minor_version,
 				    &ha->fw_subminor_version,
-				    &ha->fw_attributes, &ha->fw_memory_size);
+				    &ha->fw_attributes, &ha->fw_memory_size,
+				    ha->mpi_version, &ha->mpi_capabilities);
 				ha->flags.npiv_supported = 0;
 				if (IS_QLA2XXX_MIDTYPE(ha) &&
 					 (ha->fw_attributes & BIT_2)) {
@@ -4252,3 +4256,269 @@ qla84xx_init_chip(scsi_qla_host_t *vha)
 	return rval != QLA_SUCCESS || status[0] ? QLA_FUNCTION_FAILED:
 	    QLA_SUCCESS;
 }
+
+/* 81XX Support **************************************************************/
+
+int
+qla81xx_nvram_config(scsi_qla_host_t *vha)
+{
+	int   rval;
+	struct init_cb_81xx *icb;
+	struct nvram_81xx *nv;
+	uint32_t *dptr;
+	uint8_t  *dptr1, *dptr2;
+	uint32_t chksum;
+	uint16_t cnt;
+	struct qla_hw_data *ha = vha->hw;
+
+	rval = QLA_SUCCESS;
+	icb = (struct init_cb_81xx *)ha->init_cb;
+	nv = ha->nvram;
+
+	/* Determine NVRAM starting address. */
+	ha->nvram_size = sizeof(struct nvram_81xx);
+	ha->nvram_base = FA_NVRAM_FUNC0_ADDR;
+	ha->vpd_size = FA_NVRAM_VPD_SIZE;
+	ha->vpd_base = FA_NVRAM_VPD0_ADDR;
+	if (PCI_FUNC(ha->pdev->devfn) & 1) {
+		ha->nvram_base = FA_NVRAM_FUNC1_ADDR;
+		ha->vpd_base = FA_NVRAM_VPD1_ADDR;
+	}
+
+	/* Get VPD data into cache */
+	ha->vpd = ha->nvram + VPD_OFFSET;
+	ha->isp_ops->read_nvram(vha, (uint8_t *)ha->vpd,
+	    ha->nvram_base - FA_NVRAM_FUNC0_ADDR, FA_NVRAM_VPD_SIZE * 4);
+
+	/* Get NVRAM data into cache and calculate checksum. */
+	dptr = (uint32_t *)nv;
+	ha->isp_ops->read_nvram(vha, (uint8_t *)dptr, ha->nvram_base,
+	    ha->nvram_size);
+	for (cnt = 0, chksum = 0; cnt < ha->nvram_size >> 2; cnt++)
+		chksum += le32_to_cpu(*dptr++);
+
+	DEBUG5(printk("scsi(%ld): Contents of NVRAM\n", ha->host_no));
+	DEBUG5(qla2x00_dump_buffer((uint8_t *)nv, ha->nvram_size));
+
+	/* Bad NVRAM data, set defaults parameters. */
+	if (chksum || nv->id[0] != 'I' || nv->id[1] != 'S' || nv->id[2] != 'P'
+	    || nv->id[3] != ' ' ||
+	    nv->nvram_version < __constant_cpu_to_le16(ICB_VERSION)) {
+		/* Reset NVRAM data. */
+		qla_printk(KERN_WARNING, ha, "Inconsistent NVRAM detected: "
+		    "checksum=0x%x id=%c version=0x%x.\n", chksum, nv->id[0],
+		    le16_to_cpu(nv->nvram_version));
+		qla_printk(KERN_WARNING, ha, "Falling back to functioning (yet "
+		    "invalid -- WWPN) defaults.\n");
+
+		/*
+		 * Set default initialization control block.
+		 */
+		memset(nv, 0, ha->nvram_size);
+		nv->nvram_version = __constant_cpu_to_le16(ICB_VERSION);
+		nv->version = __constant_cpu_to_le16(ICB_VERSION);
+		nv->frame_payload_size = __constant_cpu_to_le16(2048);
+		nv->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+		nv->exchange_count = __constant_cpu_to_le16(0);
+		nv->port_name[0] = 0x21;
+		nv->port_name[1] = 0x00 + PCI_FUNC(ha->pdev->devfn);
+		nv->port_name[2] = 0x00;
+		nv->port_name[3] = 0xe0;
+		nv->port_name[4] = 0x8b;
+		nv->port_name[5] = 0x1c;
+		nv->port_name[6] = 0x55;
+		nv->port_name[7] = 0x86;
+		nv->node_name[0] = 0x20;
+		nv->node_name[1] = 0x00;
+		nv->node_name[2] = 0x00;
+		nv->node_name[3] = 0xe0;
+		nv->node_name[4] = 0x8b;
+		nv->node_name[5] = 0x1c;
+		nv->node_name[6] = 0x55;
+		nv->node_name[7] = 0x86;
+		nv->login_retry_count = __constant_cpu_to_le16(8);
+		nv->interrupt_delay_timer = __constant_cpu_to_le16(0);
+		nv->login_timeout = __constant_cpu_to_le16(0);
+		nv->firmware_options_1 =
+		    __constant_cpu_to_le32(BIT_14|BIT_13|BIT_2|BIT_1);
+		nv->firmware_options_2 = __constant_cpu_to_le32(2 << 4);
+		nv->firmware_options_2 |= __constant_cpu_to_le32(BIT_12);
+		nv->firmware_options_3 = __constant_cpu_to_le32(2 << 13);
+		nv->host_p = __constant_cpu_to_le32(BIT_11|BIT_10);
+		nv->efi_parameters = __constant_cpu_to_le32(0);
+		nv->reset_delay = 5;
+		nv->max_luns_per_target = __constant_cpu_to_le16(128);
+		nv->port_down_retry_count = __constant_cpu_to_le16(30);
+		nv->link_down_timeout = __constant_cpu_to_le16(30);
+		nv->enode_mac[0] = 0x01;
+		nv->enode_mac[1] = 0x02;
+		nv->enode_mac[2] = 0x03;
+		nv->enode_mac[3] = 0x04;
+		nv->enode_mac[4] = 0x05;
+		nv->enode_mac[5] = 0x06 + PCI_FUNC(ha->pdev->devfn);
+
+		rval = 1;
+	}
+
+	/* Reset Initialization control block */
+	memset(icb, 0, sizeof(struct init_cb_81xx));
+
+	/* Copy 1st segment. */
+	dptr1 = (uint8_t *)icb;
+	dptr2 = (uint8_t *)&nv->version;
+	cnt = (uint8_t *)&icb->response_q_inpointer - (uint8_t *)&icb->version;
+	while (cnt--)
+		*dptr1++ = *dptr2++;
+
+	icb->login_retry_count = nv->login_retry_count;
+
+	/* Copy 2nd segment. */
+	dptr1 = (uint8_t *)&icb->interrupt_delay_timer;
+	dptr2 = (uint8_t *)&nv->interrupt_delay_timer;
+	cnt = (uint8_t *)&icb->reserved_5 -
+	    (uint8_t *)&icb->interrupt_delay_timer;
+	while (cnt--)
+		*dptr1++ = *dptr2++;
+
+	memcpy(icb->enode_mac, nv->enode_mac, sizeof(icb->enode_mac));
+	/* Some boards (with valid NVRAMs) still have NULL enode_mac!! */
+	if (!memcmp(icb->enode_mac, "\0\0\0\0\0\0", sizeof(icb->enode_mac))) {
+		icb->enode_mac[0] = 0x01;
+		icb->enode_mac[1] = 0x02;
+		icb->enode_mac[2] = 0x03;
+		icb->enode_mac[3] = 0x04;
+		icb->enode_mac[4] = 0x05;
+		icb->enode_mac[5] = 0x06 + PCI_FUNC(ha->pdev->devfn);
+	}
+
+	/*
+	 * Setup driver NVRAM options.
+	 */
+	qla2x00_set_model_info(vha, nv->model_name, sizeof(nv->model_name),
+	    "QLE81XX");
+
+	/* Use alternate WWN? */
+	if (nv->host_p & __constant_cpu_to_le32(BIT_15)) {
+		memcpy(icb->node_name, nv->alternate_node_name, WWN_SIZE);
+		memcpy(icb->port_name, nv->alternate_port_name, WWN_SIZE);
+	}
+
+	/* Prepare nodename */
+	if ((icb->firmware_options_1 & __constant_cpu_to_le32(BIT_14)) == 0) {
+		/*
+		 * Firmware will apply the following mask if the nodename was
+		 * not provided.
+		 */
+		memcpy(icb->node_name, icb->port_name, WWN_SIZE);
+		icb->node_name[0] &= 0xF0;
+	}
+
+	/* Set host adapter parameters. */
+	ha->flags.disable_risc_code_load = 0;
+	ha->flags.enable_lip_reset = 0;
+	ha->flags.enable_lip_full_login =
+	    le32_to_cpu(nv->host_p) & BIT_10 ? 1: 0;
+	ha->flags.enable_target_reset =
+	    le32_to_cpu(nv->host_p) & BIT_11 ? 1: 0;
+	ha->flags.enable_led_scheme = 0;
+	ha->flags.disable_serdes = le32_to_cpu(nv->host_p) & BIT_5 ? 1: 0;
+
+	ha->operating_mode = (le32_to_cpu(icb->firmware_options_2) &
+	    (BIT_6 | BIT_5 | BIT_4)) >> 4;
+
+	/* save HBA serial number */
+	ha->serial0 = icb->port_name[5];
+	ha->serial1 = icb->port_name[6];
+	ha->serial2 = icb->port_name[7];
+	memcpy(vha->node_name, icb->node_name, WWN_SIZE);
+	memcpy(vha->port_name, icb->port_name, WWN_SIZE);
+
+	icb->execution_throttle = __constant_cpu_to_le16(0xFFFF);
+
+	ha->retry_count = le16_to_cpu(nv->login_retry_count);
+
+	/* Set minimum login_timeout to 4 seconds. */
+	if (le16_to_cpu(nv->login_timeout) < ql2xlogintimeout)
+		nv->login_timeout = cpu_to_le16(ql2xlogintimeout);
+	if (le16_to_cpu(nv->login_timeout) < 4)
+		nv->login_timeout = __constant_cpu_to_le16(4);
+	ha->login_timeout = le16_to_cpu(nv->login_timeout);
+	icb->login_timeout = nv->login_timeout;
+
+	/* Set minimum RATOV to 100 tenths of a second. */
+	ha->r_a_tov = 100;
+
+	ha->loop_reset_delay = nv->reset_delay;
+
+	/* Link Down Timeout = 0:
+	 *
+	 * 	When Port Down timer expires we will start returning
+	 *	I/O's to OS with "DID_NO_CONNECT".
+	 *
+	 * Link Down Timeout != 0:
+	 *
+	 *	 The driver waits for the link to come up after link down
+	 *	 before returning I/Os to OS with "DID_NO_CONNECT".
+	 */
+	if (le16_to_cpu(nv->link_down_timeout) == 0) {
+		ha->loop_down_abort_time =
+		    (LOOP_DOWN_TIME - LOOP_DOWN_TIMEOUT);
+	} else {
+		ha->link_down_timeout =	le16_to_cpu(nv->link_down_timeout);
+		ha->loop_down_abort_time =
+		    (LOOP_DOWN_TIME - ha->link_down_timeout);
+	}
+
+	/* Need enough time to try and get the port back. */
+	ha->port_down_retry_count = le16_to_cpu(nv->port_down_retry_count);
+	if (qlport_down_retry)
+		ha->port_down_retry_count = qlport_down_retry;
+
+	/* Set login_retry_count */
+	ha->login_retry_count  = le16_to_cpu(nv->login_retry_count);
+	if (ha->port_down_retry_count ==
+	    le16_to_cpu(nv->port_down_retry_count) &&
+	    ha->port_down_retry_count > 3)
+		ha->login_retry_count = ha->port_down_retry_count;
+	else if (ha->port_down_retry_count > (int)ha->login_retry_count)
+		ha->login_retry_count = ha->port_down_retry_count;
+	if (ql2xloginretrycount)
+		ha->login_retry_count = ql2xloginretrycount;
+
+	/* Enable ZIO. */
+	if (!vha->flags.init_done) {
+		ha->zio_mode = le32_to_cpu(icb->firmware_options_2) &
+		    (BIT_3 | BIT_2 | BIT_1 | BIT_0);
+		ha->zio_timer = le16_to_cpu(icb->interrupt_delay_timer) ?
+		    le16_to_cpu(icb->interrupt_delay_timer): 2;
+	}
+	icb->firmware_options_2 &= __constant_cpu_to_le32(
+	    ~(BIT_3 | BIT_2 | BIT_1 | BIT_0));
+	vha->flags.process_response_queue = 0;
+	if (ha->zio_mode != QLA_ZIO_DISABLED) {
+		ha->zio_mode = QLA_ZIO_MODE_6;
+
+		DEBUG2(printk("scsi(%ld): ZIO mode %d enabled; timer delay "
+		    "(%d us).\n", vha->host_no, ha->zio_mode,
+		    ha->zio_timer * 100));
+		qla_printk(KERN_INFO, ha,
+		    "ZIO mode %d enabled; timer delay (%d us).\n",
+		    ha->zio_mode, ha->zio_timer * 100);
+
+		icb->firmware_options_2 |= cpu_to_le32(
+		    (uint32_t)ha->zio_mode);
+		icb->interrupt_delay_timer = cpu_to_le16(ha->zio_timer);
+		vha->flags.process_response_queue = 1;
+	}
+
+	if (rval) {
+		DEBUG2_3(printk(KERN_WARNING
+		    "scsi(%ld): NVRAM configuration failed!\n", vha->host_no));
+	}
+	return (rval);
+}
+
+void
+qla81xx_update_fw_options(scsi_qla_host_t *ha)
+{
+}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index dcfec74..789fc57 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -275,7 +275,7 @@ void
 qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 {
 #define LS_UNKNOWN	2
-	static char	*link_speeds[5] = { "1", "2", "?", "4", "8" };
+	static char	*link_speeds[] = { "1", "2", "?", "4", "8", "10" };
 	char		*link_speed;
 	uint16_t	handle_cnt;
 	uint16_t	cnt;
@@ -288,6 +288,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 
 	/* Setup to process RIO completion. */
 	handle_cnt = 0;
+	if (IS_QLA81XX(ha))
+		goto skip_rio;
 	switch (mb[0]) {
 	case MBA_SCSI_COMPLETION:
 		handles[0] = le32_to_cpu((uint32_t)((mb[2] << 16) | mb[1]));
@@ -339,7 +341,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 	default:
 		break;
 	}
-
+skip_rio:
 	switch (mb[0]) {
 	case MBA_SCSI_COMPLETION:	/* Fast Post */
 		if (!vha->flags.online)
@@ -433,6 +435,8 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			link_speed = link_speeds[LS_UNKNOWN];
 			if (mb[1] < 5)
 				link_speed = link_speeds[mb[1]];
+			else if (mb[1] == 0x13)
+				link_speed = link_speeds[5];
 			ha->link_data_rate = mb[1];
 		}
 
@@ -492,12 +496,17 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		qla2x00_post_aen_work(vha, FCH_EVT_LIPRESET, mb[1]);
 		break;
 
+	/* case MBA_DCBX_COMPLETE: */
 	case MBA_POINT_TO_POINT:	/* Point-to-Point */
 		if (IS_QLA2100(ha))
 			break;
 
-		DEBUG2(printk("scsi(%ld): Asynchronous P2P MODE received.\n",
-		    vha->host_no));
+		if (IS_QLA81XX(ha))
+			DEBUG2(printk("scsi(%ld): DCBX Completed -- %04x %04x "
+			    "%04x\n", vha->host_no, mb[1], mb[2], mb[3]));
+		else
+			DEBUG2(printk("scsi(%ld): Asynchronous P2P MODE "
+			    "received.\n", vha->host_no));
 
 		/*
 		 * Until there's a transition from loop down to loop up, treat
@@ -692,6 +701,35 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		}
 		spin_unlock_irqrestore(&ha->cs84xx->access_lock, flags);
 		break;
+	case MBA_DCBX_START:
+		DEBUG2(printk("scsi(%ld): DCBX Started -- %04x %04x %04x\n",
+		    vha->host_no, mb[1], mb[2], mb[3]));
+		break;
+	case MBA_DCBX_PARAM_UPDATE:
+		DEBUG2(printk("scsi(%ld): DCBX Parameters Updated -- "
+		    "%04x %04x %04x\n", vha->host_no, mb[1], mb[2], mb[3]));
+		break;
+	case MBA_FCF_CONF_ERR:
+		DEBUG2(printk("scsi(%ld): FCF Configuration Error -- "
+		    "%04x %04x %04x\n", vha->host_no, mb[1], mb[2], mb[3]));
+		break;
+	case MBA_IDC_COMPLETE:
+		DEBUG2(printk("scsi(%ld): Inter-Driver Commucation "
+		    "Complete -- %04x %04x %04x\n", vha->host_no, mb[1], mb[2],
+		    mb[3]));
+		break;
+	case MBA_IDC_NOTIFY:
+		DEBUG2(printk("scsi(%ld): Inter-Driver Commucation "
+		    "Request Notification -- %04x %04x %04x\n", vha->host_no,
+		    mb[1], mb[2], mb[3]));
+		/**** Mailbox registers 4 - 7 valid!!! */
+		break;
+	case MBA_IDC_TIME_EXT:
+		DEBUG2(printk("scsi(%ld): Inter-Driver Commucation "
+		    "Time Extension -- %04x %04x %04x\n", vha->host_no, mb[1],
+		    mb[2], mb[3]));
+		/**** Mailbox registers 4 - 7 valid!!! */
+		break;
 	}
 
 	if (!vha->vp_idx && ha->num_vhosts)
@@ -1504,7 +1542,7 @@ qla2xxx_check_risc_status(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
 
-	if (!IS_QLA25XX(ha))
+	if (!IS_QLA25XX(ha) && !IS_QLA81XX(ha))
 		return;
 
 	rval = QLA_SUCCESS;
@@ -1926,7 +1964,8 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 	device_reg_t __iomem *reg = ha->iobase;
 
 	/* If possible, enable MSI-X. */
-	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha))
+	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) &&
+	    !IS_QLA8432(ha) && !IS_QLA8001(ha))
 		goto skip_msix;
 
 	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX ||
@@ -1961,7 +2000,8 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 	    "MSI-X: Falling back-to INTa mode -- %d.\n", ret);
 skip_msix:
 
-	if (!IS_QLA24XX(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha))
+	if (!IS_QLA24XX(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha) &&
+	    !IS_QLA8001(ha))
 		goto skip_msi;
 
 	ret = pci_enable_msi(ha->pdev);
@@ -1982,6 +2022,12 @@ skip_msi:
 	ha->flags.inta_enabled = 1;
 clear_risc_ints:
 
+	/*
+	 * FIXME: Noted that 8014s were being dropped during NK testing.
+	 * Timing deltas during MSI-X/INTa transitions?
+	 */
+	if (IS_QLA81XX(ha))
+		goto fail;
 	spin_lock_irq(&ha->hardware_lock);
 	if (IS_FWI2_CAPABLE(ha)) {
 		WRT_REG_DWORD(&reg->isp24.hccr, HCCRX_CLR_HOST_INT);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 4cb6791..db4df45 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -411,7 +411,8 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
  */
 void
 qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
-    uint16_t *subminor, uint16_t *attributes, uint32_t *memory)
+    uint16_t *subminor, uint16_t *attributes, uint32_t *memory, uint8_t *mpi,
+    uint32_t *mpi_caps)
 {
 	int		rval;
 	mbx_cmd_t	mc;
@@ -422,6 +423,8 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
 	mcp->mb[0] = MBC_GET_FIRMWARE_VERSION;
 	mcp->out_mb = MBX_0;
 	mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
+	if (IS_QLA81XX(vha->hw))
+		mcp->in_mb |= MBX_13|MBX_12|MBX_11|MBX_10;
 	mcp->flags = 0;
 	mcp->tov = MBX_TOV_SECONDS;
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -435,6 +438,13 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
 		*memory = 0x1FFFF;			/* Defaults to 128KB. */
 	else
 		*memory = (mcp->mb[5] << 16) | mcp->mb[4];
+	if (IS_QLA81XX(vha->hw)) {
+		mpi[0] = mcp->mb[10] >> 8;
+		mpi[1] = mcp->mb[10] & 0xff;
+		mpi[2] = mcp->mb[11] >> 8;
+		mpi[3] = mcp->mb[11] & 0xff;
+		*mpi_caps = (mcp->mb[12] << 16) | mcp->mb[13];
+	}
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
@@ -1353,7 +1363,13 @@ qla2x00_lip_reset(scsi_qla_host_t *vha)
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
-	if (IS_FWI2_CAPABLE(vha->hw)) {
+	if (IS_QLA81XX(vha->hw)) {
+		/* Logout across all FCFs. */
+		mcp->mb[0] = MBC_LIP_FULL_LOGIN;
+		mcp->mb[1] = BIT_1;
+		mcp->mb[2] = 0;
+		mcp->out_mb = MBX_2|MBX_1|MBX_0;
+	} else if (IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[0] = MBC_LIP_FULL_LOGIN;
 		mcp->mb[1] = BIT_6;
 		mcp->mb[2] = 0;
@@ -1843,6 +1859,9 @@ qla2x00_full_login_lip(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	if (IS_QLA81XX(vha->hw))
+	    return QLA_SUCCESS;
+
 	DEBUG11(printk("qla2x00_full_login_lip(%ld): entered.\n",
 	    vha->host_no));
 
@@ -2502,7 +2521,7 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *vha, dma_addr_t fce_dma,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_QLA25XX(vha->hw))
+	if (!IS_QLA25XX(vha->hw) && !IS_QLA81XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1b475c5..4a71f52 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -404,26 +404,9 @@ static char *
 qla24xx_fw_version_str(struct scsi_qla_host *vha, char *str)
 {
 	struct qla_hw_data *ha = vha->hw;
-	sprintf(str, "%d.%02d.%02d ", ha->fw_major_version,
-	    ha->fw_minor_version,
-	    ha->fw_subminor_version);
 
-	if (ha->fw_attributes & BIT_0)
-		strcat(str, "[Class 2] ");
-	if (ha->fw_attributes & BIT_1)
-		strcat(str, "[IP] ");
-	if (ha->fw_attributes & BIT_2)
-		strcat(str, "[Multi-ID] ");
-	if (ha->fw_attributes & BIT_3)
-		strcat(str, "[SB-2] ");
-	if (ha->fw_attributes & BIT_4)
-		strcat(str, "[T10 CRC] ");
-	if (ha->fw_attributes & BIT_5)
-		strcat(str, "[VI] ");
-	if (ha->fw_attributes & BIT_10)
-		strcat(str, "[84XX] ");
-	if (ha->fw_attributes & BIT_13)
-		strcat(str, "[Experimental]");
+	sprintf(str, "%d.%02d.%02d (%x)", ha->fw_major_version,
+	    ha->fw_minor_version, ha->fw_subminor_version, ha->fw_attributes);
 	return str;
 }
 
@@ -1489,6 +1472,44 @@ static struct isp_operations qla25xx_isp_ops = {
 	.rd_req_reg		= qla24xx_rd_req_reg,
 };
 
+static struct isp_operations qla81xx_isp_ops = {
+	.pci_config		= qla25xx_pci_config,
+	.reset_chip		= qla24xx_reset_chip,
+	.chip_diag		= qla24xx_chip_diag,
+	.config_rings		= qla24xx_config_rings,
+	.reset_adapter		= qla24xx_reset_adapter,
+	.nvram_config		= qla81xx_nvram_config,
+	.update_fw_options	= qla81xx_update_fw_options,
+	.load_risc		= qla24xx_load_risc,
+	.pci_info_str		= qla24xx_pci_info_str,
+	.fw_version_str		= qla24xx_fw_version_str,
+	.intr_handler		= qla24xx_intr_handler,
+	.enable_intrs		= qla24xx_enable_intrs,
+	.disable_intrs		= qla24xx_disable_intrs,
+	.abort_command		= qla24xx_abort_command,
+	.target_reset		= qla24xx_abort_target,
+	.lun_reset		= qla24xx_lun_reset,
+	.fabric_login		= qla24xx_login_fabric,
+	.fabric_logout		= qla24xx_fabric_logout,
+	.calc_req_entries	= NULL,
+	.build_iocbs		= NULL,
+	.prep_ms_iocb		= qla24xx_prep_ms_iocb,
+	.prep_ms_fdmi_iocb	= qla24xx_prep_ms_fdmi_iocb,
+	.read_nvram		= qla25xx_read_nvram_data,
+	.write_nvram		= qla25xx_write_nvram_data,
+	.fw_dump		= qla81xx_fw_dump,
+	.beacon_on		= qla24xx_beacon_on,
+	.beacon_off		= qla24xx_beacon_off,
+	.beacon_blink		= qla24xx_beacon_blink,
+	.read_optrom		= qla25xx_read_optrom_data,
+	.write_optrom		= qla24xx_write_optrom_data,
+	.get_flash_version	= qla24xx_get_flash_version,
+	.start_scsi		= qla24xx_start_scsi,
+	.wrt_req_reg		= qla24xx_wrt_req_reg,
+	.wrt_rsp_reg		= qla24xx_wrt_rsp_reg,
+	.rd_req_reg		= qla24xx_rd_req_reg,
+};
+
 static inline void
 qla2x00_set_isp_flags(struct qla_hw_data *ha)
 {
@@ -1568,6 +1589,13 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
 		ha->device_type |= DT_IIDMA;
 		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
 		break;
+	case PCI_DEVICE_ID_QLOGIC_ISP8001:
+		ha->device_type |= DT_ISP8001;
+		ha->device_type |= DT_ZIO_SUPPORTED;
+		ha->device_type |= DT_FWI2;
+		ha->device_type |= DT_IIDMA;
+		ha->fw_srisc_address = RISC_START_ADDRESS_2400;
+		break;
 	}
 }
 
@@ -1630,7 +1658,7 @@ skip_pio:
 
 	/* Determine queue resources */
 	ha->max_queues = 1;
-	if (ql2xmaxqueues <= 1 || !IS_QLA25XX(ha))
+	if (ql2xmaxqueues <= 1 || (!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
 		goto mqiobase_exit;
 	ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 3),
 			pci_resource_len(ha->pdev, 3));
@@ -1707,7 +1735,8 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8432 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5422 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5432 ||
-	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2532) {
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2532 ||
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8001) {
 		bars = pci_select_bars(pdev, IORESOURCE_MEM);
 		sht = &qla24xx_driver_template;
 		mem_only = 1;
@@ -1761,6 +1790,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		rsp_length = RESPONSE_ENTRY_CNT_2100;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2100;
 		ha->gid_list_info_size = 4;
+		ha->flash_conf_off = ~0;
+		ha->flash_data_off = ~0;
+		ha->nvram_conf_off = ~0;
+		ha->nvram_data_off = ~0;
 		ha->isp_ops = &qla2100_isp_ops;
 	} else if (IS_QLA2200(ha)) {
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
@@ -1768,6 +1801,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		rsp_length = RESPONSE_ENTRY_CNT_2100;
 		ha->max_loop_id = SNS_LAST_LOOP_ID_2100;
 		ha->gid_list_info_size = 4;
+		ha->flash_conf_off = ~0;
+		ha->flash_data_off = ~0;
+		ha->nvram_conf_off = ~0;
+		ha->nvram_data_off = ~0;
 		ha->isp_ops = &qla2100_isp_ops;
 	} else if (IS_QLA23XX(ha)) {
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
@@ -1777,6 +1814,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->gid_list_info_size = 6;
 		if (IS_QLA2322(ha) || IS_QLA6322(ha))
 			ha->optrom_size = OPTROM_SIZE_2322;
+		ha->flash_conf_off = ~0;
+		ha->flash_data_off = ~0;
+		ha->nvram_conf_off = ~0;
+		ha->nvram_data_off = ~0;
 		ha->isp_ops = &qla2300_isp_ops;
 	} else if (IS_QLA24XX_TYPE(ha)) {
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
@@ -1788,6 +1829,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->optrom_size = OPTROM_SIZE_24XX;
 		ha->nvram_npiv_size = QLA_MAX_VPORTS_QLA24XX;
 		ha->isp_ops = &qla24xx_isp_ops;
+		ha->flash_conf_off = FARX_ACCESS_FLASH_CONF;
+		ha->flash_data_off = FARX_ACCESS_FLASH_DATA;
+		ha->nvram_conf_off = FARX_ACCESS_NVRAM_CONF;
+		ha->nvram_data_off = FARX_ACCESS_NVRAM_DATA;
 	} else if (IS_QLA25XX(ha)) {
 		ha->mbx_count = MAILBOX_REGISTER_COUNT;
 		req_length = REQUEST_ENTRY_CNT_24XX;
@@ -1798,6 +1843,23 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->optrom_size = OPTROM_SIZE_25XX;
 		ha->nvram_npiv_size = QLA_MAX_VPORTS_QLA25XX;
 		ha->isp_ops = &qla25xx_isp_ops;
+		ha->flash_conf_off = FARX_ACCESS_FLASH_CONF;
+		ha->flash_data_off = FARX_ACCESS_FLASH_DATA;
+		ha->nvram_conf_off = FARX_ACCESS_NVRAM_CONF;
+		ha->nvram_data_off = FARX_ACCESS_NVRAM_DATA;
+	} else if (IS_QLA81XX(ha)) {
+		ha->mbx_count = MAILBOX_REGISTER_COUNT;
+		req_length = REQUEST_ENTRY_CNT_24XX;
+		rsp_length = RESPONSE_ENTRY_CNT_2300;
+		ha->max_loop_id = SNS_LAST_LOOP_ID_2300;
+		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
+		ha->gid_list_info_size = 8;
+		ha->optrom_size = OPTROM_SIZE_81XX;
+		ha->isp_ops = &qla81xx_isp_ops;
+		ha->flash_conf_off = FARX_ACCESS_FLASH_CONF_81XX;
+		ha->flash_data_off = FARX_ACCESS_FLASH_DATA_81XX;
+		ha->nvram_conf_off = ~0;
+		ha->nvram_data_off = ~0;
 	}
 
 	mutex_init(&ha->vport_lock);
@@ -2894,13 +2956,14 @@ qla2x00_timer(scsi_qla_host_t *vha)
 
 /* Firmware interface routines. */
 
-#define FW_BLOBS	6
+#define FW_BLOBS	7
 #define FW_ISP21XX	0
 #define FW_ISP22XX	1
 #define FW_ISP2300	2
 #define FW_ISP2322	3
 #define FW_ISP24XX	4
 #define FW_ISP25XX	5
+#define FW_ISP81XX	6
 
 #define FW_FILE_ISP21XX	"ql2100_fw.bin"
 #define FW_FILE_ISP22XX	"ql2200_fw.bin"
@@ -2908,6 +2971,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 #define FW_FILE_ISP2322	"ql2322_fw.bin"
 #define FW_FILE_ISP24XX	"ql2400_fw.bin"
 #define FW_FILE_ISP25XX	"ql2500_fw.bin"
+#define FW_FILE_ISP81XX	"ql8100_fw.bin"
 
 static DEFINE_MUTEX(qla_fw_lock);
 
@@ -2918,6 +2982,7 @@ static struct fw_blob qla_fw_blobs[FW_BLOBS] = {
 	{ .name = FW_FILE_ISP2322, .segs = { 0x800, 0x1c000, 0x1e000, 0 }, },
 	{ .name = FW_FILE_ISP24XX, },
 	{ .name = FW_FILE_ISP25XX, },
+	{ .name = FW_FILE_ISP81XX, },
 };
 
 struct fw_blob *
@@ -2939,6 +3004,8 @@ qla2x00_request_firmware(scsi_qla_host_t *vha)
 		blob = &qla_fw_blobs[FW_ISP24XX];
 	} else if (IS_QLA25XX(ha)) {
 		blob = &qla_fw_blobs[FW_ISP25XX];
+	} else if (IS_QLA81XX(ha)) {
+		blob = &qla_fw_blobs[FW_ISP81XX];
 	}
 
 	mutex_lock(&qla_fw_lock);
@@ -3092,6 +3159,7 @@ static struct pci_device_id qla2xxx_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP5422) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP5432) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2532) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP8001) },
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, qla2xxx_pci_tbl);
@@ -3180,3 +3248,4 @@ MODULE_FIRMWARE(FW_FILE_ISP2300);
 MODULE_FIRMWARE(FW_FILE_ISP2322);
 MODULE_FIRMWARE(FW_FILE_ISP24XX);
 MODULE_FIRMWARE(FW_FILE_ISP25XX);
+MODULE_FIRMWARE(FW_FILE_ISP81XX);
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 628d79c..303f8ee 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -425,27 +425,27 @@ qla2x00_set_nvram_protection(struct qla_hw_data *ha, int stat)
 #define OPTROM_BURST_DWORDS	(OPTROM_BURST_SIZE / 4)
 
 static inline uint32_t
-flash_conf_to_access_addr(uint32_t faddr)
+flash_conf_addr(struct qla_hw_data *ha, uint32_t faddr)
 {
-	return FARX_ACCESS_FLASH_CONF | faddr;
+	return ha->flash_conf_off | faddr;
 }
 
 static inline uint32_t
-flash_data_to_access_addr(uint32_t faddr)
+flash_data_addr(struct qla_hw_data *ha, uint32_t faddr)
 {
-	return FARX_ACCESS_FLASH_DATA | faddr;
+	return ha->flash_data_off | faddr;
 }
 
 static inline uint32_t
-nvram_conf_to_access_addr(uint32_t naddr)
+nvram_conf_addr(struct qla_hw_data *ha, uint32_t naddr)
 {
-	return FARX_ACCESS_NVRAM_CONF | naddr;
+	return ha->nvram_conf_off | naddr;
 }
 
 static inline uint32_t
-nvram_data_to_access_addr(uint32_t naddr)
+nvram_data_addr(struct qla_hw_data *ha, uint32_t naddr)
 {
-	return FARX_ACCESS_NVRAM_DATA | naddr;
+	return ha->nvram_data_off | naddr;
 }
 
 static uint32_t
@@ -481,10 +481,12 @@ qla24xx_read_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
     uint32_t dwords)
 {
 	uint32_t i;
+	struct qla_hw_data *ha = vha->hw;
+
 	/* Dword reads to flash. */
 	for (i = 0; i < dwords; i++, faddr++)
-		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(vha->hw,
-		    flash_data_to_access_addr(faddr)));
+		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
+		    flash_data_addr(ha, faddr)));
 
 	return dwptr;
 }
@@ -518,7 +520,7 @@ qla24xx_get_flash_manufacturer(struct qla_hw_data *ha, uint8_t *man_id,
 {
 	uint32_t ids;
 
-	ids = qla24xx_read_flash_dword(ha, flash_data_to_access_addr(0xd03ab));
+	ids = qla24xx_read_flash_dword(ha, flash_conf_addr(ha, 0x03ab));
 	*man_id = LSB(ids);
 	*flash_id = MSB(ids);
 
@@ -530,8 +532,7 @@ qla24xx_get_flash_manufacturer(struct qla_hw_data *ha, uint8_t *man_id,
 		 * Example: ATMEL 0x00 01 45 1F
 		 * Extract MFG and Dev ID from last two bytes.
 		 */
-		ids = qla24xx_read_flash_dword(ha,
-		    flash_data_to_access_addr(0xd009f));
+		ids = qla24xx_read_flash_dword(ha, flash_conf_addr(ha, 0x009f));
 		*man_id = LSB(ids);
 		*flash_id = MSB(ids);
 	}
@@ -555,9 +556,13 @@ qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 
 	/* Begin with sane defaults. */
 	loc = locations[0];
-	*start = IS_QLA24XX_TYPE(ha) ? FA_FLASH_LAYOUT_ADDR_24:
-	    FA_FLASH_LAYOUT_ADDR;
-
+	*start = 0;
+	if (IS_QLA24XX_TYPE(ha))
+		*start = FA_FLASH_LAYOUT_ADDR_24;
+	else if (IS_QLA25XX(ha))
+		*start = FA_FLASH_LAYOUT_ADDR;
+	else if (IS_QLA81XX(ha))
+		*start = FA_FLASH_LAYOUT_ADDR_81;
 	/* Begin with first PCI expansion ROM header. */
 	buf = (uint8_t *)req->ring;
 	dcode = (uint32_t *)req->ring;
@@ -618,6 +623,22 @@ static void
 qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 {
 	const char *loc, *locations[] = { "DEF", "FLT" };
+	const uint32_t def_fw[] =
+		{ FA_RISC_CODE_ADDR, FA_RISC_CODE_ADDR, FA_RISC_CODE_ADDR_81 };
+	const uint32_t def_boot[] =
+		{ FA_BOOT_CODE_ADDR, FA_BOOT_CODE_ADDR, FA_BOOT_CODE_ADDR_81 };
+	const uint32_t def_vpd_nvram[] =
+		{ FA_VPD_NVRAM_ADDR, FA_VPD_NVRAM_ADDR, FA_VPD_NVRAM_ADDR_81 };
+	const uint32_t def_fdt[] =
+		{ FA_FLASH_DESCR_ADDR_24, FA_FLASH_DESCR_ADDR,
+			FA_FLASH_DESCR_ADDR_81 };
+	const uint32_t def_npiv_conf0[] =
+		{ FA_NPIV_CONF0_ADDR_24, FA_NPIV_CONF0_ADDR,
+			FA_NPIV_CONF0_ADDR_81 };
+	const uint32_t def_npiv_conf1[] =
+		{ FA_NPIV_CONF1_ADDR_24, FA_NPIV_CONF1_ADDR,
+			FA_NPIV_CONF1_ADDR_81 };
+	uint32_t def;
 	uint16_t *wptr;
 	uint16_t cnt, chksum;
 	uint32_t start;
@@ -677,11 +698,11 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 			ha->flt_region_fdt = start;
 			break;
 		case FLT_REG_NPIV_CONF_0:
-			if (!PCI_FUNC(ha->pdev->devfn))
+			if (!(PCI_FUNC(ha->pdev->devfn) & 1))
 				ha->flt_region_npiv_conf = start;
 			break;
 		case FLT_REG_NPIV_CONF_1:
-			if (PCI_FUNC(ha->pdev->devfn))
+			if (PCI_FUNC(ha->pdev->devfn) & 1)
 				ha->flt_region_npiv_conf = start;
 			break;
 		}
@@ -691,14 +712,19 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 no_flash_data:
 	/* Use hardcoded defaults. */
 	loc = locations[0];
-	ha->flt_region_fw = FA_RISC_CODE_ADDR;
-	ha->flt_region_boot = FA_BOOT_CODE_ADDR;
-	ha->flt_region_vpd_nvram = FA_VPD_NVRAM_ADDR;
-	ha->flt_region_fdt = IS_QLA24XX_TYPE(ha) ? FA_FLASH_DESCR_ADDR_24:
-	    FA_FLASH_DESCR_ADDR;
-	ha->flt_region_npiv_conf = !PCI_FUNC(ha->pdev->devfn) ?
-	    (IS_QLA24XX_TYPE(ha) ? FA_NPIV_CONF0_ADDR_24: FA_NPIV_CONF0_ADDR):
-	    (IS_QLA24XX_TYPE(ha) ? FA_NPIV_CONF1_ADDR_24: FA_NPIV_CONF1_ADDR);
+	def = 0;
+	if (IS_QLA24XX_TYPE(ha))
+		def = 0;
+	else if (IS_QLA25XX(ha))
+		def = 1;
+	else if (IS_QLA81XX(ha))
+		def = 2;
+	ha->flt_region_fw = def_fw[def];
+	ha->flt_region_boot = def_boot[def];
+	ha->flt_region_vpd_nvram = def_vpd_nvram[def];
+	ha->flt_region_fdt = def_fdt[def];
+	ha->flt_region_npiv_conf = !(PCI_FUNC(ha->pdev->devfn) & 1) ?
+	    def_npiv_conf0[def]: def_npiv_conf1[def];
 done:
 	DEBUG2(qla_printk(KERN_DEBUG, ha, "FLT[%s]: boot=0x%x fw=0x%x "
 	    "vpd_nvram=0x%x fdt=0x%x flt=0x%x npiv=0x%x.\n", loc,
@@ -746,14 +772,14 @@ qla2xxx_get_fdt_info(scsi_qla_host_t *vha)
 	mid = le16_to_cpu(fdt->man_id);
 	fid = le16_to_cpu(fdt->id);
 	ha->fdt_wrt_disable = fdt->wrt_disable_bits;
-	ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0300 | fdt->erase_cmd);
+	ha->fdt_erase_cmd = flash_conf_addr(ha, 0x0300 | fdt->erase_cmd);
 	ha->fdt_block_size = le32_to_cpu(fdt->block_size);
 	if (fdt->unprotect_sec_cmd) {
-		ha->fdt_unprotect_sec_cmd = flash_conf_to_access_addr(0x0300 |
+		ha->fdt_unprotect_sec_cmd = flash_conf_addr(ha, 0x0300 |
 		    fdt->unprotect_sec_cmd);
 		ha->fdt_protect_sec_cmd = fdt->protect_sec_cmd ?
-		    flash_conf_to_access_addr(0x0300 | fdt->protect_sec_cmd):
-		    flash_conf_to_access_addr(0x0336);
+		    flash_conf_addr(ha, 0x0300 | fdt->protect_sec_cmd):
+		    flash_conf_addr(ha, 0x0336);
 	}
 	goto done;
 no_flash_data:
@@ -762,7 +788,7 @@ no_flash_data:
 	mid = man_id;
 	fid = flash_id;
 	ha->fdt_wrt_disable = 0x9c;
-	ha->fdt_erase_cmd = flash_conf_to_access_addr(0x03d8);
+	ha->fdt_erase_cmd = flash_conf_addr(ha, 0x03d8);
 	switch (man_id) {
 	case 0xbf: /* STT flash. */
 		if (flash_id == 0x8e)
@@ -771,16 +797,16 @@ no_flash_data:
 			ha->fdt_block_size = FLASH_BLK_SIZE_32K;
 
 		if (flash_id == 0x80)
-			ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0352);
+			ha->fdt_erase_cmd = flash_conf_addr(ha, 0x0352);
 		break;
 	case 0x13: /* ST M25P80. */
 		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
 		break;
 	case 0x1f: /* Atmel 26DF081A. */
 		ha->fdt_block_size = FLASH_BLK_SIZE_4K;
-		ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0320);
-		ha->fdt_unprotect_sec_cmd = flash_conf_to_access_addr(0x0339);
-		ha->fdt_protect_sec_cmd = flash_conf_to_access_addr(0x0336);
+		ha->fdt_erase_cmd = flash_conf_addr(ha, 0x0320);
+		ha->fdt_unprotect_sec_cmd = flash_conf_addr(ha, 0x0339);
+		ha->fdt_protect_sec_cmd = flash_conf_addr(ha, 0x0336);
 		break;
 	default:
 		/* Default to 64 kb sector size. */
@@ -802,7 +828,7 @@ qla2xxx_get_flash_info(scsi_qla_host_t *vha)
 	uint32_t flt_addr;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha))
+	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha) && !IS_QLA81XX(ha))
 		return QLA_SUCCESS;
 
 	ret = qla2xxx_find_flt_start(vha, &flt_addr);
@@ -827,7 +853,7 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 	struct qla_npiv_entry *entry;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha))
+	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha) && !IS_QLA81XX(ha))
 		return;
 
 	ha->isp_ops->read_optrom(vha, (uint8_t *)&hdr,
@@ -919,9 +945,9 @@ qla24xx_unprotect_flash(struct qla_hw_data *ha)
 		return;
 
 	/* Disable flash write-protection. */
-	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0);
+	qla24xx_write_flash_dword(ha, flash_conf_addr(ha, 0x101), 0);
 	/* Some flash parts need an additional zero-write to clear bits.*/
-	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101), 0);
+	qla24xx_write_flash_dword(ha, flash_conf_addr(ha, 0x101), 0);
 }
 
 static void
@@ -934,11 +960,10 @@ qla24xx_protect_flash(struct qla_hw_data *ha)
 		goto skip_wrt_protect;
 
 	/* Enable flash write-protection and wait for completion. */
-	qla24xx_write_flash_dword(ha, flash_conf_to_access_addr(0x101),
+	qla24xx_write_flash_dword(ha, flash_conf_addr(ha, 0x101),
 	    ha->fdt_wrt_disable);
 	for (cnt = 300; cnt &&
-	    qla24xx_read_flash_dword(ha,
-		    flash_conf_to_access_addr(0x005)) & BIT_0;
+	    qla24xx_read_flash_dword(ha, flash_conf_addr(ha, 0x005)) & BIT_0;
 	    cnt--) {
 		udelay(10);
 	}
@@ -966,7 +991,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	ret = QLA_SUCCESS;
 
 	/* Prepare burst-capable write on supported ISPs. */
-	if (IS_QLA25XX(ha) && !(faddr & 0xfff) &&
+	if ((IS_QLA25XX(ha) || IS_QLA81XX(ha)) && !(faddr & 0xfff) &&
 	    dwords > OPTROM_BURST_DWORDS) {
 		optrom = dma_alloc_coherent(&ha->pdev->dev, OPTROM_BURST_SIZE,
 		    &optrom_dma, GFP_KERNEL);
@@ -978,7 +1003,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 	}
 
 	rest_addr = (ha->fdt_block_size >> 2) - 1;
-	sec_mask = 0x80000 - (ha->fdt_block_size >> 2);
+	sec_mask = (ha->optrom_size >> 2) - (ha->fdt_block_size >> 2);
 
 	qla24xx_unprotect_flash(ha);
 
@@ -1013,13 +1038,13 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 				*s = cpu_to_le32(*d);
 
 			ret = qla2x00_load_ram(vha, optrom_dma,
-			    flash_data_to_access_addr(faddr),
+			    flash_data_addr(ha, faddr),
 			    OPTROM_BURST_DWORDS);
 			if (ret != QLA_SUCCESS) {
 				qla_printk(KERN_WARNING, ha,
 				    "Unable to burst-write optrom segment "
 				    "(%x/%x/%llx).\n", ret,
-				    flash_data_to_access_addr(faddr),
+				    flash_data_addr(ha, faddr),
 				    (unsigned long long)optrom_dma);
 				qla_printk(KERN_WARNING, ha,
 				    "Reverting to slow-write.\n");
@@ -1036,7 +1061,7 @@ qla24xx_write_flash_data(scsi_qla_host_t *vha, uint32_t *dwptr, uint32_t faddr,
 		}
 
 		ret = qla24xx_write_flash_dword(ha,
-		    flash_data_to_access_addr(faddr), cpu_to_le32(*dwptr));
+		    flash_data_addr(ha, faddr), cpu_to_le32(*dwptr));
 		if (ret != QLA_SUCCESS) {
 			DEBUG9(printk("%s(%ld) Unable to program flash "
 			    "address=%x data=%x.\n", __func__,
@@ -1087,12 +1112,13 @@ qla24xx_read_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
 {
 	uint32_t i;
 	uint32_t *dwptr;
+	struct qla_hw_data *ha = vha->hw;
 
 	/* Dword reads to flash. */
 	dwptr = (uint32_t *)buf;
 	for (i = 0; i < bytes >> 2; i++, naddr++)
-		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(vha->hw,
-		    nvram_data_to_access_addr(naddr)));
+		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
+		    nvram_data_addr(ha, naddr)));
 
 	return buf;
 }
@@ -1149,17 +1175,14 @@ qla24xx_write_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
 	RD_REG_DWORD(&reg->ctrl_status);	/* PCI Posting. */
 
 	/* Disable NVRAM write-protection. */
-	qla24xx_write_flash_dword(ha, nvram_conf_to_access_addr(0x101),
-	    0);
-	qla24xx_write_flash_dword(ha, nvram_conf_to_access_addr(0x101),
-	    0);
+	qla24xx_write_flash_dword(ha, nvram_conf_addr(ha, 0x101), 0);
+	qla24xx_write_flash_dword(ha, nvram_conf_addr(ha, 0x101), 0);
 
 	/* Dword writes to flash. */
 	dwptr = (uint32_t *)buf;
 	for (i = 0; i < bytes >> 2; i++, naddr++, dwptr++) {
 		ret = qla24xx_write_flash_dword(ha,
-		    nvram_data_to_access_addr(naddr),
-		    cpu_to_le32(*dwptr));
+		    nvram_data_addr(ha, naddr), cpu_to_le32(*dwptr));
 		if (ret != QLA_SUCCESS) {
 			DEBUG9(qla_printk("Unable to program nvram address=%x "
 			    "data=%x.\n", naddr, *dwptr));
@@ -1168,8 +1191,7 @@ qla24xx_write_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
 	}
 
 	/* Enable NVRAM write-protection. */
-	qla24xx_write_flash_dword(ha, nvram_conf_to_access_addr(0x101),
-	    0x8c);
+	qla24xx_write_flash_dword(ha, nvram_conf_addr(ha, 0x101), 0x8c);
 
 	/* Disable flash write. */
 	WRT_REG_DWORD(&reg->ctrl_status,
@@ -1191,8 +1213,7 @@ qla25xx_read_nvram_data(scsi_qla_host_t *vha, uint8_t *buf, uint32_t naddr,
 	dwptr = (uint32_t *)buf;
 	for (i = 0; i < bytes >> 2; i++, naddr++)
 		dwptr[i] = cpu_to_le32(qla24xx_read_flash_dword(ha,
-		    flash_data_to_access_addr(ha->flt_region_vpd_nvram |
-		    naddr)));
+		    flash_data_addr(ha, ha->flt_region_vpd_nvram | naddr)));
 
 	return buf;
 }
@@ -2235,12 +2256,12 @@ qla25xx_read_optrom_data(struct scsi_qla_host *vha, uint8_t *buf,
 			burst = left;
 
 		rval = qla2x00_dump_ram(vha, optrom_dma,
-		    flash_data_to_access_addr(faddr), burst);
+		    flash_data_addr(ha, faddr), burst);
 		if (rval) {
 			qla_printk(KERN_WARNING, ha,
 			    "Unable to burst-read optrom segment "
 			    "(%x/%x/%llx).\n", rval,
-			    flash_data_to_access_addr(faddr),
+			    flash_data_addr(ha, faddr),
 			    (unsigned long long)optrom_dma);
 			qla_printk(KERN_WARNING, ha,
 			    "Reverting to slow-read.\n");
-- 
1.6.1.28.gc32f76

