From: Ke Wei <kewei.mv@gmail.com>
Subject: Re: [PATCH] Marvell 6440 SAS/SATA driver
Date: Tue, 5 Feb 2008 21:19:20 +0800
Message-ID: <20080205131920.GA7901@ubuntu.domain>
References: <20080122151857.GA8680@ubuntu.domain> <6b2481670801220724o6c204216qc346020c296f2849@mail.gmail.com> <4796BB5A.9090003@garzik.org> <6b2481670801230254i46e65652vb9139e2c136e4ce4@mail.gmail.com> <479727D5.8060901@garzik.org> <6b2481670801250843g73ff3a6aydb465a654f53ad9d@mail.gmail.com> <1201300769.3119.78.camel@localhost.localdomain> <20080127152733.GC21302@ubuntu.domain> <1201457626.3746.21.camel@localhost.localdomain>
Reply-To: Ke Wei <kewei.mv@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:28131 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbYBENS7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 08:18:59 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1694268rvb.1
        for <linux-scsi@vger.kernel.org>; Tue, 05 Feb 2008 05:18:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1201457626.3746.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ke Wei <kewei.mv@gmail.com>, linux-scsi@vger.kernel.org, jeff@garzik.org, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, kewei@marvell.com


Added support for hotplug and wide port.


Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c |  445 ++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 339 insertions(+), 106 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 3bf009b..e5cf3ad 100755
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -26,6 +26,12 @@
 	  structures.  this permits elimination of all the le32_to_cpu()
 	  and cpu_to_le32() conversions.
 
+	Changelog:
+	2008-02-05	0.4	Added support for hotplug and wide port.
+	2008-01-22	0.3	Added support for SAS HD and SATA Devices.
+	2008-01-09	0.2	detect SAS disk.
+	2007-09-95	0.1	rough draft, Initial version.
+
  */
 
 #include <linux/kernel.h>
@@ -39,13 +45,13 @@
 #include <asm/io.h>
 
 #define DRV_NAME	"mvsas"
-#define DRV_VERSION	"0.3"
+#define DRV_VERSION	"0.4"
 #define _MV_DUMP 0
 #define MVS_DISABLE_NVRAM
 
 #define mr32(reg)	readl(regs + MVS_##reg)
 #define mw32(reg,val)	writel((val), regs + MVS_##reg)
-#define mw32_f(reg,val)	do {		\
+#define mw32_f(reg,val)	do {			\
 	writel((val), regs + MVS_##reg);	\
 	readl(regs + MVS_##reg);		\
 	} while (0)
@@ -54,13 +60,19 @@
 #define MVS_CHIP_SLOT_SZ	(1U << mvi->chip->slot_width)
 
 /* offset for D2H FIS in the Received FIS List Structure */
-#define SATA_RECEIVED_D2H_FIS(reg_set) \
+#define SATA_RECEIVED_D2H_FIS(reg_set)	\
 	((void *) mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x40)
-#define SATA_RECEIVED_PIO_FIS(reg_set) \
+#define SATA_RECEIVED_PIO_FIS(reg_set)	\
 	((void *) mvi->rx_fis + 0x400 + 0x100 * reg_set + 0x20)
-#define UNASSOC_D2H_FIS(id) \
+#define UNASSOC_D2H_FIS(id)		\
 	((void *) mvi->rx_fis + 0x100 * id)
 
+#define for_each_phy(__lseq_mask, __mc, __lseq, __rest)			\
+	for ((__mc) = (__lseq_mask), (__lseq) = 0;			\
+					(__mc) != 0 && __rest;		\
+					(++__lseq), (__mc) >>= 1)	\
+		if (((__mc) & 1))
+
 /* driver compile-time configuration */
 enum driver_configuration {
 	MVS_TX_RING_SZ		= 1024,	/* TX ring size (12-bit) */
@@ -130,6 +142,7 @@ enum hw_registers {
 	MVS_INT_STAT		= 0x150, /* Central int status */
 	MVS_INT_MASK		= 0x154, /* Central int enable */
 	MVS_INT_STAT_SRS	= 0x158, /* SATA register set status */
+	MVS_INT_MASK_SRS	= 0x15C,
 
 					 /* ports 1-3 follow after this */
 	MVS_P0_INT_STAT		= 0x160, /* port0 interrupt status */
@@ -223,7 +236,7 @@ enum hw_register_bits {
 
 						/* shl for ports 1-3 */
 	CINT_PORT_STOPPED	= (1U << 16),	/* port0 stopped */
-	CINT_PORT			= (1U << 8),	/* port0 event */
+	CINT_PORT		= (1U << 8),	/* port0 event */
 	CINT_PORT_MASK_OFFSET	= 8,
 	CINT_PORT_MASK		= (0xFF << CINT_PORT_MASK_OFFSET),
 
@@ -300,6 +313,7 @@ enum hw_register_bits {
 	PHY_READY_MASK		= (1U << 20),
 
 	/* MVS_Px_INT_STAT, MVS_Px_INT_MASK (per-phy events) */
+	PHYEV_DEC_ERR		= (1U << 24),	/* Phy Decoding Error */
 	PHYEV_UNASSOC_FIS	= (1U << 19),	/* unassociated FIS rx'd */
 	PHYEV_AN		= (1U << 18),	/* SATA async notification */
 	PHYEV_BIST_ACT		= (1U << 17),	/* BIST activate FIS */
@@ -501,6 +515,9 @@ enum status_buffer {
 	SB_RFB_MAX	=  0x400,	/* RFB size*/
 };
 
+enum error_info_rec {
+	CMD_ISS_STPD	=  (1U << 31),	/* Cmd Issue Stopped */
+};
 
 struct mvs_chip_info {
 	u32		n_phy;
@@ -534,6 +551,7 @@ struct mvs_cmd_hdr {
 struct mvs_slot_info {
 	struct sas_task		*task;
 	u32			n_elem;
+	u32			tx;
 
 	/* DMA buffer for storing cmd tbl, open addr frame, status buffer,
 	 * and PRD table
@@ -546,23 +564,28 @@ struct mvs_slot_info {
 
 struct mvs_port {
 	struct asd_sas_port	sas_port;
-	u8			taskfileset;
+	u8			port_attached;
+	union {
+		u8		taskfileset;
+		u8		wide_port_phymap;
+	};
 };
 
 struct mvs_phy {
 	struct mvs_port		*port;
 	struct asd_sas_phy	sas_phy;
-	struct sas_identify identify;
+	struct sas_identify	identify;
+	struct scsi_device	*sdev;
 	u64		dev_sas_addr;
 	u64		att_dev_sas_addr;
 	u32		att_dev_info;
 	u32		dev_info;
-	u32		type;
+	u32		phy_type;
 	u32		phy_status;
 	u32		irq_status;
 	u32		frame_rcvd_size;
 	u8		frame_rcvd[32];
-	u8		wide_port_phymap;
+	u8		phy_attached;
 };
 
 struct mvs_info {
@@ -610,6 +633,8 @@ struct mvs_queue_task {
 	void   *uldd_task;
 };
 
+static int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
+			   void *funcdata);
 static u32 mvs_read_phy_ctl(struct mvs_info *mvi, u32 port);
 static void mvs_write_phy_ctl(struct mvs_info *mvi, u32 port, u32 val);
 static u32 mvs_read_port(struct mvs_info *mvi, u32 off, u32 off2, u32 port);
@@ -624,9 +649,18 @@ static void mvs_write_port_vsr_addr(struct mvs_info *mvi, u32 port, u32 addr);
 static u32 mvs_read_port_irq_stat(struct mvs_info *mvi, u32 port);
 static void mvs_write_port_irq_stat(struct mvs_info *mvi, u32 port, u32 val);
 static void mvs_write_port_irq_mask(struct mvs_info *mvi, u32 port, u32 val);
+static u32 mvs_read_port_irq_mask(struct mvs_info *mvi, u32 port);
+
+static u32 mvs_is_phy_ready(struct mvs_info *mvi, int i);
+static void mvs_detect_porttype(struct mvs_info *mvi, int i);
+static void mvs_update_phyinfo(struct mvs_info *mvi, int i, int get_st);
+static void mvs_free_reg_set(struct mvs_info *mvi, struct mvs_port *port);
+static u8 mvs_assign_reg_set(struct mvs_info *mvi, struct mvs_port *port);
+static u32 mvs_is_sig_fis_received(u32 irq_status);
 
 static int mvs_scan_finished(struct Scsi_Host *, unsigned long);
 static void mvs_scan_start(struct Scsi_Host *);
+static int mvs_sas_slave_alloc(struct scsi_device *scsi_dev);
 
 static struct scsi_transport_template *mvs_stt;
 
@@ -656,7 +690,7 @@ static struct scsi_host_template mvs_sht = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler	= sas_eh_device_reset_handler,
 	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
-	.slave_alloc		= sas_slave_alloc,
+	.slave_alloc		= mvs_sas_slave_alloc,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 };
@@ -705,7 +739,8 @@ static void mvs_hba_sb_dump(struct mvs_info *mvi, u32 tag,
 
 	offset = len_ct + MVS_OAF_SZ +
 	    sizeof(struct mvs_prd) * mvi->slot_info[tag].n_elem;
-	dev_printk(KERN_DEBUG, &pdev->dev, "+---->Status buffer :\n");
+	dev_printk(KERN_DEBUG, &pdev->dev, "+---->Status buffer[%d] :\n",
+			tag);
 	mvs_hexdump(32, (u8 *) mvi->slot_info[tag].response,
 		    (u32) mvi->slot_info[tag].buf_dma + offset);
 }
@@ -789,7 +824,6 @@ static void mvs_hba_cq_dump(struct mvs_info *mvi)
 #endif
 }
 
-#if 0
 static void mvs_hba_interrupt_enable(struct mvs_info *mvi)
 {
 	void __iomem *regs = mvi->regs;
@@ -809,7 +843,6 @@ static void mvs_hba_interrupt_disable(struct mvs_info *mvi)
 
 	mw32(GBL_CTL, tmp & ~INT_EN);
 }
-#endif
 
 static int mvs_int_rx(struct mvs_info *mvi, bool self_clear);
 
@@ -1002,6 +1035,28 @@ err_out:
 #endif
 }
 
+static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
+{
+	struct mvs_phy *phy = &mvi->phy[i];
+
+	if (!phy->phy_attached)
+		return;
+
+	if (phy->phy_type & PORT_TYPE_SAS) {
+		struct sas_identify_frame *id;
+
+		id = (struct sas_identify_frame *)phy->frame_rcvd;
+		id->dev_type = phy->identify.device_type;
+		id->initiator_bits = SAS_PROTOCOL_ALL;
+		id->target_bits = phy->identify.target_port_protocols;
+	} else if (phy->phy_type & PORT_TYPE_SATA) {
+		/* TODO */
+	}
+	mvi->sas.sas_phy[i]->frame_rcvd_size = phy->frame_rcvd_size;
+	mvi->sas.notify_port_event(mvi->sas.sas_phy[i],
+				   PORTE_BYTES_DMAED);
+}
+
 static int mvs_scan_finished(struct Scsi_Host *shost, unsigned long time)
 {
 	/* give the phy enabling interrupt event time to come in (1s
@@ -1016,34 +1071,79 @@ static int mvs_scan_finished(struct Scsi_Host *shost, unsigned long time)
 static void mvs_scan_start(struct Scsi_Host *shost)
 {
 	int i;
-	struct sas_identify_frame *id;
 	struct mvs_info *mvi = SHOST_TO_SAS_HA(shost)->lldd_ha;
 
 	for (i = 0; i < mvi->chip->n_phy; ++i) {
-		struct mvs_phy *phy = &mvi->phy[i];
-		id = (struct sas_identify_frame *)phy->frame_rcvd;
-		if (phy->type & PORT_TYPE_SAS) {
-			id->dev_type = phy->identify.device_type;
-			id->initiator_bits = SAS_PROTOCOL_ALL;
-			id->target_bits = phy->identify.target_port_protocols;
-		} else if (phy->type & PORT_TYPE_SATA) {
-		}
-		mvi->sas.sas_phy[i]->frame_rcvd_size = phy->frame_rcvd_size;
-		mvi->sas.notify_port_event(mvi->sas.sas_phy[i],
-					   PORTE_BYTES_DMAED);
+		mvs_bytes_dmaed(mvi, i);
 	}
+}
+
+static int mvs_sas_slave_alloc(struct scsi_device *scsi_dev)
+{
+	int rc;
+
+	rc = sas_slave_alloc(scsi_dev);
 
+	return rc;
 }
 
 static void mvs_int_port(struct mvs_info *mvi, int port_no, u32 events)
 {
 	struct pci_dev *pdev = mvi->pdev;
+	struct sas_ha_struct *sas_ha = &mvi->sas;
+	struct mvs_phy *phy = &mvi->phy[port_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+
+	phy->irq_status = mvs_read_port_irq_stat(mvi, port_no);
 	/*
 	* events is port event now ,
 	* we need check the interrupt status which belongs to per port.
 	*/
 	dev_printk(KERN_DEBUG, &pdev->dev,
-		"Port0 = %d", mvs_read_port_irq_stat(mvi, 0));
+		"Port %d Event = %X\n",
+		port_no, phy->irq_status);
+
+	if ((phy->irq_status & PHYEV_POOF) ||
+			(phy->irq_status & PHYEV_DEC_ERR)) {
+		if (!mvs_is_phy_ready(mvi, port_no)) {
+			sas_phy_disconnected(sas_phy);
+			sas_ha->notify_phy_event(sas_phy, PHYE_LOSS_OF_SIGNAL);
+		} else
+			mvs_phy_control(sas_phy, PHY_FUNC_LINK_RESET, NULL);
+	}
+	if (!(phy->irq_status & PHYEV_DEC_ERR)) {
+		if (phy->irq_status & PHYEV_COMWAKE) {
+			u32 tmp = mvs_read_port_irq_mask(mvi, port_no);
+			mvs_write_port_irq_mask(mvi, port_no,
+						tmp | PHYEV_SIG_FIS);
+		}
+		if ((phy->irq_status & PHYEV_SIG_FIS) ||
+				(phy->irq_status & PHYEV_ID_DONE)) {
+			phy->phy_status = mvs_is_phy_ready(mvi, port_no);
+			if (phy->phy_status) {
+				mvs_detect_porttype(mvi, port_no);
+
+				if (phy->phy_type & PORT_TYPE_SATA) {
+					u32 tmp = mvs_read_port_irq_mask(mvi,
+								port_no);
+					tmp &= ~PHYEV_SIG_FIS;
+					mvs_write_port_irq_mask(mvi,
+								port_no, tmp);
+				}
+
+				mvs_update_phyinfo(mvi, port_no, 0);
+				sas_ha->notify_phy_event(sas_phy,
+							PHYE_OOB_DONE);
+				mvs_bytes_dmaed(mvi, port_no);
+			} else {
+				dev_printk(KERN_DEBUG, &pdev->dev,
+					"plugin interrupt but phy is gone\n");
+				mvs_phy_control(sas_phy, PHY_FUNC_LINK_RESET,
+							NULL);
+			}
+		}
+	}
+	mvs_write_port_irq_stat(mvi, port_no, phy->irq_status);
 }
 
 static void mvs_int_sata(struct mvs_info *mvi)
@@ -1075,13 +1175,24 @@ static void mvs_slot_free(struct mvs_info *mvi, struct sas_task *task,
 		break;
 	}
 
+	slot->task = NULL;
 	mvs_tag_clear(mvi, slot_idx);
 }
 
 static void mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
 			 u32 slot_idx)
 {
-	/* FIXME */
+	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
+	u64 err_dw0 = *(u32 *) slot->response;
+	void __iomem *regs = mvi->regs;
+	u32 tmp;
+
+	if (err_dw0 & CMD_ISS_STPD)
+		if (sas_protocol_ata(task->task_proto)) {
+			tmp = mr32(INT_STAT_SRS);
+			mw32(INT_STAT_SRS, tmp & 0xFFFF);
+		}
+
 	mvs_hba_sb_dump(mvi, slot_idx, task->task_proto);
 }
 
@@ -1091,6 +1202,7 @@ static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
 	struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
 	struct sas_task *task = slot->task;
 	struct task_status_struct *tstat = &task->task_status;
+	struct mvs_port *port = &mvi->port[task->dev->port->id];
 	bool aborted;
 
 	spin_lock(&task->task_state_lock);
@@ -1108,6 +1220,12 @@ static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
 	memset(tstat, 0, sizeof(*tstat));
 	tstat->resp = SAS_TASK_COMPLETE;
 
+
+	if (unlikely(!port->port_attached)) {
+		tstat->stat = SAS_PHY_DOWN;
+		goto out;
+	}
+
 	/* error info record present */
 	if ((rx_desc & RXQ_ERR) && (*(u64 *) slot->response)) {
 		tstat->stat = SAM_CHECK_COND;
@@ -1142,9 +1260,6 @@ static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
 	case SAS_PROTOCOL_STP: {
 			struct ata_task_resp *resp =
 			    (struct ata_task_resp *)tstat->buf;
-			struct domain_device *dev = task->dev;
-			struct mvs_port *port =
-			    (struct mvs_port *)dev->port->lldd_port;
 
 			if ((rx_desc & (RXQ_DONE | RXQ_ERR | RXQ_ATTN)) ==
 			    RXQ_DONE)
@@ -1156,7 +1271,8 @@ static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
 			memcpy(&resp->ending_fis[0],
 			       SATA_RECEIVED_D2H_FIS(port->taskfileset),
 			       sizeof(struct dev_to_host_fis));
-			/*mvs_hexdump(16,resp->ending_fis,0);*/
+			if (resp->ending_fis[2] & ATA_ERR)
+				mvs_hexdump(16, resp->ending_fis, 0);
 			break;
 		}
 
@@ -1232,11 +1348,13 @@ static int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
 
 		if (unlikely(rx_desc & RXQ_DONE))
 			mvs_slot_complete(mvi, rx_desc);
-		else if (rx_desc & RXQ_ATTN) {
+		if (rx_desc & RXQ_ATTN) {
 			attn = true;
-			dev_printk(KERN_DEBUG, &pdev->dev, "ATTN\n");
+			dev_printk(KERN_DEBUG, &pdev->dev, "ATTN %X\n",
+				rx_desc);
 		} else if (rx_desc & RXQ_ERR) {
-			dev_printk(KERN_DEBUG, &pdev->dev, "RXQ_ERR\n");
+			dev_printk(KERN_DEBUG, &pdev->dev, "RXQ_ERR %X\n",
+				rx_desc);
 		}
 	}
 
@@ -1269,6 +1387,7 @@ static irqreturn_t mvs_interrupt(int irq, void *opaque)
 	return IRQ_HANDLED;
 }
 
+#ifdef MVS_DISABLE_MSI
 static irqreturn_t mvs_msi_interrupt(int irq, void *opaque)
 {
 	struct mvs_info *mvi = opaque;
@@ -1281,10 +1400,12 @@ static irqreturn_t mvs_msi_interrupt(int irq, void *opaque)
 
 	return IRQ_HANDLED;
 }
+#endif
 
 struct mvs_task_exec_info {
 	struct sas_task *task;
 	struct mvs_cmd_hdr *hdr;
+	struct mvs_port *port;
 	u32 tag;
 	int n_elem;
 };
@@ -1348,27 +1469,30 @@ err_out:
 	return rc;
 }
 
-#if 0
 static void mvs_free_reg_set(struct mvs_info *mvi, struct mvs_port *port)
 {
 	void __iomem *regs = mvi->regs;
 	u32 tmp, offs;
+	u8 *tfs = &port->taskfileset;
 
-	if (port->taskfileset == MVS_ID_NOT_MAPPED)
+	if (*tfs == MVS_ID_NOT_MAPPED)
 		return;
 
-	offs = 1U << ((port->taskfileset & 0x0f) + PCS_EN_SATA_REG_SHIFT);
-	if (port->taskfileset < 16) {
+	offs = 1U << ((*tfs & 0x0f) + PCS_EN_SATA_REG_SHIFT);
+	if (*tfs < 16) {
 		tmp = mr32(PCS);
-		mw32(PCS, tmp | ~offs);
+		mw32(PCS, tmp & ~offs);
 	} else {
 		tmp = mr32(CTL);
-		mw32(CTL, tmp | ~offs);
+		mw32(CTL, tmp & ~offs);
 	}
 
-	port->taskfileset = MVS_ID_NOT_MAPPED;
+	tmp = mr32(INT_STAT_SRS) & (1U << *tfs);
+	if (tmp)
+		mw32(INT_STAT_SRS, tmp);
+
+	*tfs = MVS_ID_NOT_MAPPED;
 }
-#endif
 
 static u8 mvs_assign_reg_set(struct mvs_info *mvi, struct mvs_port *port)
 {
@@ -1392,6 +1516,9 @@ static u8 mvs_assign_reg_set(struct mvs_info *mvi, struct mvs_port *port)
 				mw32(PCS, tmp | offs);
 			else
 				mw32(CTL, tmp | offs);
+			tmp = mr32(INT_STAT_SRS) & (1U << i);
+			if (tmp)
+				mw32(INT_STAT_SRS, tmp);
 			return 0;
 		}
 	}
@@ -1419,7 +1546,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	struct mvs_slot_info *slot;
 	struct scatterlist *sg;
 	struct mvs_prd *buf_prd;
-	struct mvs_port *port = (struct mvs_port *)sas_port->lldd_port;
+	struct mvs_port *port = tei->port;
 	u32 tag = tei->tag;
 	u32 flags = (tei->n_elem << MCH_PRD_LEN_SHIFT);
 	void *buf_tmp;
@@ -1432,7 +1559,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 		return -EBUSY;
 
 	slot = &mvi->slot_info[tag];
-
+	slot->tx = mvi->tx_prod;
 	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
 					(TXQ_CMD_STP << TXQ_CMD_SHIFT) |
 					(sas_port->phy_mask << TXQ_PHY_SHIFT) |
@@ -1530,8 +1657,8 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 			     struct mvs_task_exec_info *tei)
 {
 	struct sas_task *task = tei->task;
-	struct asd_sas_port *sas_port = task->dev->port;
 	struct mvs_cmd_hdr *hdr = tei->hdr;
+	struct mvs_port *port = tei->port;
 	struct mvs_slot_info *slot;
 	struct scatterlist *sg;
 	struct mvs_prd *buf_prd;
@@ -1545,9 +1672,11 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 
 	slot = &mvi->slot_info[tag];
 
+	slot->tx = mvi->tx_prod;
 	mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | tag |
-					(TXQ_CMD_SSP << TXQ_CMD_SHIFT) |
-					(sas_port->phy_mask << TXQ_PHY_SHIFT));
+				(TXQ_CMD_SSP << TXQ_CMD_SHIFT) |
+				(port->wide_port_phymap << TXQ_PHY_SHIFT));
+
 	flags = MCH_RETRY;
 	if (task->ssp_task.enable_first_burst) {
 		flags |= MCH_FBURST;
@@ -1642,11 +1771,12 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 
 static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
 {
-	struct mvs_info *mvi = task->dev->port->ha->lldd_ha;
+	struct domain_device *dev = task->dev;
+	struct mvs_info *mvi = dev->port->ha->lldd_ha;
 	struct pci_dev *pdev = mvi->pdev;
+	void __iomem *regs = mvi->regs;
 	struct mvs_task_exec_info tei;
 	struct sas_task *t = task;
-	void __iomem *regs = mvi->regs;
 	u32 tag = 0xdeadbeef, rc, n_elem = 0;
 	unsigned long flags;
 	u32 n = num, pass = 0;
@@ -1654,6 +1784,15 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
 	spin_lock_irqsave(&mvi->lock, flags);
 
 	do {
+		tei.port = &mvi->port[dev->port->id];
+
+		if (!tei.port->port_attached) {
+			struct task_status_struct *ts = &t->task_status;
+			ts->stat = SAS_PHY_DOWN;
+			t->task_done(t);
+			rc = 0;
+			goto exec_exit;
+		}
 		if (!sas_protocol_ata(t->task_proto)) {
 			if (t->num_scatter) {
 				n_elem = pci_map_sg(mvi->pdev, t->scatter,
@@ -1724,11 +1863,12 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags)
 err_out_tag:
 	mvs_tag_free(mvi, tag);
 err_out:
-	dev_printk(KERN_ERR, &pdev->dev, "mvsas exec failed[%d]!\n", pass);
+	dev_printk(KERN_ERR, &pdev->dev, "mvsas exec failed[%d]!\n", rc);
 	if (!sas_protocol_ata(t->task_proto))
 		if (n_elem)
 			pci_unmap_sg(mvi->pdev, t->scatter, n_elem,
 				     t->data_dir);
+exec_exit:
 	if (pass)
 		mw32(TX_PROD_IDX, (mvi->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
 	spin_unlock_irqrestore(&mvi->lock, flags);
@@ -1751,6 +1891,7 @@ static int mvs_task_abort(struct sas_task *task)
 
 	/*FIXME*/
 	rc = TMF_RESP_FUNC_COMPLETE;
+
 	switch (task->task_proto) {
 	case SAS_PROTOCOL_SMP:
 		dev_printk(KERN_DEBUG, &pdev->dev, "SMP Abort! ");
@@ -1823,11 +1964,10 @@ static int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			   void *funcdata)
 {
 	struct mvs_info *mvi = sas_phy->ha->lldd_ha;
-	void __iomem *reg;
 	int rc = 0, phy_id = sas_phy->id;
 	u32 tmp;
 
-	reg = mvi->regs + MVS_P0_SER_CTLSTAT + (phy_id * 4);
+	tmp = mvs_read_phy_ctl(mvi, phy_id);
 
 	switch (func) {
 	case PHY_FUNC_SET_LINK_RATE:{
@@ -1837,7 +1977,6 @@ static int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			lrmin = (rates->minimum_linkrate << 8);
 			lrmax = (rates->maximum_linkrate << 12);
 
-			tmp = readl(reg);
 			if (lrmin) {
 				tmp &= ~(0xf << 8);
 				tmp |= lrmin;
@@ -1846,19 +1985,18 @@ static int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 				tmp &= ~(0xf << 12);
 				tmp |= lrmax;
 			}
-			writel(tmp, reg);
+			mvs_write_phy_ctl(mvi, phy_id, tmp);
 			break;
 		}
 
 	case PHY_FUNC_HARD_RESET:
-		tmp = readl(reg);
 		if (tmp & PHY_RST_HARD)
 			break;
-		writel(tmp | PHY_RST_HARD, reg);
+		mvs_write_phy_ctl(mvi, phy_id, tmp | PHY_RST_HARD);
 		break;
 
 	case PHY_FUNC_LINK_RESET:
-		writel(readl(reg) | PHY_RST, reg);
+		mvs_write_phy_ctl(mvi, phy_id, tmp | PHY_RST);
 		break;
 
 	case PHY_FUNC_DISABLE:
@@ -2127,12 +2265,10 @@ static void mvs_write_port_irq_stat(struct mvs_info *mvi, u32 port, u32 val)
 	mvs_write_port(mvi, MVS_P0_INT_STAT, MVS_P4_INT_STAT, port, val);
 }
 
-#if 0
 static u32 mvs_read_port_irq_mask(struct mvs_info *mvi, u32 port)
 {
 	return mvs_read_port(mvi, MVS_P0_INT_MASK, MVS_P4_INT_MASK, port);
 }
-#endif
 
 static void mvs_write_port_irq_mask(struct mvs_info *mvi, u32 port, u32 val)
 {
@@ -2211,18 +2347,14 @@ static void mvs_detect_porttype(struct mvs_info *mvi, int i)
 	u32 reg;
 	struct mvs_phy *phy = &mvi->phy[i];
 
-	/* enable auto port detection */
-	mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
-	msleep(100);
-
 	/* TODO check & save device type */
 	reg = mr32(GBL_PORT_TYPE);
 
 	if (reg & MODE_SAS_SATA & (1 << i)) {
-		phy->type = PORT_TYPE_SAS;
+		phy->phy_type |= PORT_TYPE_SAS;
 		phy->identify.target_port_protocols = SAS_PROTOCOL_SSP;
 	} else {
-		phy->type = PORT_TYPE_SATA;
+		phy->phy_type |= PORT_TYPE_SATA;
 		phy->identify.target_port_protocols = SAS_PROTOCOL_STP;
 	}
 
@@ -2250,23 +2382,65 @@ static void *mvs_get_d2h_reg(struct mvs_info *mvi, int i, void *buf)
 	return (void *)s;
 }
 
-static u32 mvs_is_sig_fis_received(struct mvs_info *mvi, int i)
+static u32 mvs_is_sig_fis_received(u32 irq_status)
+{
+	return irq_status & PHYEV_SIG_FIS;
+}
+
+static void mvs_update_wideport(struct mvs_info *mvi, int i)
+{
+	struct mvs_phy *phy = &mvi->phy[i];
+	struct mvs_port *port = phy->port;
+	int j, no;
+
+	for_each_phy(port->wide_port_phymap, no, j, mvi->chip->n_phy) {
+		mvs_write_port_cfg_addr(mvi, no, PHYR_WIDE_PORT);
+		mvs_write_port_cfg_data(mvi, no , port->wide_port_phymap);
+	} else {
+		mvs_write_port_cfg_addr(mvi, no, PHYR_WIDE_PORT);
+		mvs_write_port_cfg_data(mvi, no , 0);
+	}
+}
+
+static u32 mvs_is_phy_ready(struct mvs_info *mvi, int i)
 {
 	u32 tmp;
+	struct mvs_phy *phy = &mvi->phy[i];
+	struct mvs_port *port;
 
-	tmp = mvs_read_port_irq_stat(mvi, i) & PHYEV_SIG_FIS;
-	if (tmp)
-		mvs_write_port_irq_stat(mvi, i, PHYEV_SIG_FIS);
+	tmp = mvs_read_phy_ctl(mvi, i);
 
-	return tmp;
+	if ((tmp & PHY_READY_MASK) && !(phy->irq_status & PHYEV_POOF)) {
+		if (!phy->port)
+			phy->phy_attached = 1;
+		return tmp;
+	}
+
+	port = phy->port;
+	if (port) {
+		if (phy->phy_type & PORT_TYPE_SAS) {
+			port->wide_port_phymap &= ~(1U << i);
+			if (!port->wide_port_phymap)
+				port->port_attached = 0;
+			mvs_update_wideport(mvi, i);
+		} else if (phy->phy_type & PORT_TYPE_SATA) {
+			mvs_free_reg_set(mvi, phy->port);
+			port->port_attached = 0;
+		}
+		phy->port = NULL;
+		phy->phy_attached = 0;
+		phy->phy_type &= ~(PORT_TYPE_SAS | PORT_TYPE_SATA);
+	}
+	return 0;
 }
 
-static void __devinit mvs_update_phyinfo(struct mvs_info *mvi, int i)
+static void mvs_update_phyinfo(struct mvs_info *mvi, int i,
+					int get_st)
 {
 	struct mvs_phy *phy = &mvi->phy[i];
-	u32 tmp;
-	u64 tmp64;
 	struct pci_dev *pdev = mvi->pdev;
+	u32 tmp, j;
+	u64 tmp64;
 
 	mvs_write_port_cfg_addr(mvi, i, PHYR_IDENTIFY);
 	phy->dev_info = mvs_read_port_cfg_data(mvi, i);
@@ -2277,20 +2451,23 @@ static void __devinit mvs_update_phyinfo(struct mvs_info *mvi, int i)
 	mvs_write_port_cfg_addr(mvi, i, PHYR_ADDR_LO);
 	phy->dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
 
-	phy->phy_status = mvs_read_phy_ctl(mvi, i);
-
-	/* FIXME Update Wide Port info */
-	phy->port = &mvi->port[i];
-	phy->port->sas_port.lldd_port = phy->port;
-	phy->port->taskfileset = MVS_ID_NOT_MAPPED;
+	if (get_st) {
+		phy->irq_status = mvs_read_port_irq_stat(mvi, i);
+		phy->phy_status = mvs_is_phy_ready(mvi, i);
+	}
 
-	if (phy->phy_status & PHY_READY_MASK) {
+	if (phy->phy_status) {
 		u32 phy_st;
 		struct asd_sas_phy *sas_phy = mvi->sas.sas_phy[i];
 
 		mvs_write_port_cfg_addr(mvi, i, PHYR_PHY_STAT);
 		phy_st = mvs_read_port_cfg_data(mvi, i);
 
+		sas_phy->linkrate =
+			(phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
+				PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET;
+
+		/* Updated attached_sas_addr */
 		mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_HI);
 		phy->att_dev_sas_addr =
 				(u64) mvs_read_port_cfg_data(mvi, i) << 32;
@@ -2298,36 +2475,57 @@ static void __devinit mvs_update_phyinfo(struct mvs_info *mvi, int i)
 		mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_LO);
 		phy->att_dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
 
-		/*Updated attached_sas_addr */
-		tmp64 = phy->att_dev_sas_addr;
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			"phy[%d] Get Attached Address 0x%llX ,"
 			" SAS Address 0x%llX\n",
-			i, tmp64, phy->dev_sas_addr);
-		tmp64 = cpu_to_be64(tmp64);
+			i, phy->att_dev_sas_addr, phy->dev_sas_addr);
+		dev_printk(KERN_DEBUG, &pdev->dev,
+			"Rate = %x , type = %d\n",
+			sas_phy->linkrate, phy->phy_type);
+
+#if 1
+		/*
+		* If the device is capable of supporting a wide port
+		* on its phys, it may configure the phys as a wide port.
+		*/
+		if (phy->phy_type & PORT_TYPE_SAS)
+			for (j = 0; j < mvi->chip->n_phy && j != i; ++j) {
+				if ((mvi->phy[j].phy_attached) &&
+					(mvi->phy[j].phy_type & PORT_TYPE_SAS))
+					if (phy->att_dev_sas_addr ==
+					mvi->phy[j].att_dev_sas_addr - 1) {
+						phy->att_dev_sas_addr =
+						mvi->phy[j].att_dev_sas_addr;
+						break;
+					}
+			}
+
+#endif
+
+		tmp64 = cpu_to_be64(phy->att_dev_sas_addr);
 		memcpy(sas_phy->attached_sas_addr, &tmp64, SAS_ADDR_SIZE);
 
-		if (phy->type & PORT_TYPE_SAS) {
+		if (phy->phy_type & PORT_TYPE_SAS) {
 			mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_DEV_INFO);
 			phy->att_dev_info = mvs_read_port_cfg_data(mvi, i);
 			phy->identify.device_type =
 			    phy->att_dev_info & PORT_DEV_TYPE_MASK;
 
-			sas_phy->linkrate =
-			(phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
-				PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET;
 			if (phy_st & PHY_OOB_DTCTD)
 				sas_phy->oob_mode = SAS_OOB_MODE;
 			phy->frame_rcvd_size =
 			    sizeof(struct sas_identify_frame);
-		} else if (phy->type & PORT_TYPE_SATA) {
-			if (mvs_is_sig_fis_received(mvi, i)) {
+		} else if (phy->phy_type & PORT_TYPE_SATA) {
+			if (mvs_is_sig_fis_received(phy->irq_status)) {
 				if (phy_st & PHY_OOB_DTCTD)
 					sas_phy->oob_mode = SATA_OOB_MODE;
 				phy->frame_rcvd_size =
 				    sizeof(struct dev_to_host_fis);
 				mvs_get_d2h_reg(mvi, i,
 						(void *)sas_phy->frame_rcvd);
+			} else {
+				dev_printk(KERN_DEBUG, &pdev->dev,
+					"No sig fis\n");
 			}
 		}
 		/* workaround for HW phy decoding error on 1.5g disk drive */
@@ -2342,7 +2540,28 @@ static void __devinit mvs_update_phyinfo(struct mvs_info *mvi, int i)
 		mvs_write_port_vsr_data(mvi, i, tmp);
 
 	}
-	phy->irq_status = mvs_read_port_irq_stat(mvi, i);
+	if (get_st)
+		mvs_write_port_irq_stat(mvi, i, phy->irq_status);
+}
+
+static void mvs_port_formed(struct asd_sas_phy *sas_phy)
+{
+	struct sas_ha_struct *sas_ha = sas_phy->ha;
+	struct mvs_info *mvi = sas_ha->lldd_ha;
+	struct asd_sas_port *sas_port = sas_phy->port;
+	struct mvs_phy *phy = sas_phy->lldd_phy;
+	struct mvs_port *port = &mvi->port[sas_port->id];
+	unsigned long flags;
+
+	spin_lock_irqsave(&mvi->lock, flags);
+	port->port_attached = 1;
+	phy->port = port;
+	if (phy->phy_type & PORT_TYPE_SAS) {
+		port->wide_port_phymap = sas_port->phy_mask;
+		mvs_update_wideport(mvi, sas_phy->id);
+	} else if (phy->phy_type & PORT_TYPE_SATA)
+		port->taskfileset = MVS_ID_NOT_MAPPED;
+	spin_unlock_irqrestore(&mvi->lock, flags);
 }
 
 static int __devinit mvs_hw_init(struct mvs_info *mvi)
@@ -2431,6 +2650,9 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
 	mw32(RX_LO, mvi->rx_dma);
 	mw32(RX_HI, (mvi->rx_dma >> 16) >> 16);
 
+	/* enable auto port detection */
+	mw32(GBL_PORT_TYPE, MODE_AUTO_DET_EN);
+	msleep(100);
 	/* init and reset phys */
 	for (i = 0; i < mvi->chip->n_phy; i++) {
 		/* FIXME: is this the correct dword order? */
@@ -2460,10 +2682,12 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
 		mvs_write_port_irq_stat(mvi, i, tmp);
 
 		/* set phy int mask */
-		tmp = PHYEV_RDY_CH | PHYEV_BROAD_CH | PHYEV_UNASSOC_FIS;
+		tmp = PHYEV_RDY_CH | PHYEV_BROAD_CH | PHYEV_UNASSOC_FIS |
+			PHYEV_ID_DONE | PHYEV_DEC_ERR;
 		mvs_write_port_irq_mask(mvi, i, tmp);
 
-		mvs_update_phyinfo(mvi, i);
+		msleep(100);
+		mvs_update_phyinfo(mvi, i, 1);
 		mvs_enable_xmt(mvi, i);
 	}
 
@@ -2500,11 +2724,10 @@ static int __devinit mvs_hw_init(struct mvs_info *mvi)
 	mw32(TX_CFG, MVS_CHIP_SLOT_SZ | TX_EN);
 	mw32(RX_CFG, MVS_RX_RING_SZ | RX_EN);
 	/* enable CMD/CMPL_Q/RESP mode */
-	mw32(PCS, PCS_SATA_RETRY | PCS_FIS_RX_EN | PCS_CMD_EN |
-	     ((mvi->flags & MVF_MSI) ? PCS_SELF_CLEAR : 0));
+	mw32(PCS, PCS_SATA_RETRY | PCS_FIS_RX_EN | PCS_CMD_EN);
 
 	/* re-enable interrupts globally */
-	mw32(GBL_CTL, INT_EN);
+	mvs_hba_interrupt_enable(mvi);
 
 	/* enable completion queue interrupt */
 	tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM);
@@ -2556,10 +2779,16 @@ static int __devinit mvs_pci_init(struct pci_dev *pdev,
 	if (rc)
 		goto err_out_mvi;
 
+#ifdef MVS_DISABLE_MSI
 	if (!pci_enable_msi(pdev)) {
+		u32 tmp;
+		void __iomem *regs = mvi->regs;
 		mvi->flags |= MVF_MSI;
 		irq_handler = mvs_msi_interrupt;
+		tmp = mr32(PCS);
+		mw32(PCS, tmp | PCS_SELF_CLEAR);
 	}
+#endif
 
 	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED, DRV_NAME, mvi);
 	if (rc)
@@ -2603,15 +2832,18 @@ static void __devexit mvs_pci_remove(struct pci_dev *pdev)
 
 	pci_set_drvdata(pdev, NULL);
 
-	sas_unregister_ha(&mvi->sas);
-	sas_remove_host(mvi->shost);
-	scsi_remove_host(mvi->shost);
-
-	free_irq(pdev->irq, mvi);
-	if (mvi->flags & MVF_MSI)
-		pci_disable_msi(pdev);
-	mvs_free(mvi);
-	pci_release_regions(pdev);
+	if (mvi) {
+		sas_unregister_ha(&mvi->sas);
+		mvs_hba_interrupt_disable(mvi);
+		sas_remove_host(mvi->shost);
+		scsi_remove_host(mvi->shost);
+
+		free_irq(pdev->irq, mvi);
+		if (mvi->flags & MVF_MSI)
+			pci_disable_msi(pdev);
+		mvs_free(mvi);
+		pci_release_regions(pdev);
+	}
 	pci_disable_device(pdev);
 }
 
@@ -2619,6 +2851,7 @@ static struct sas_domain_function_template mvs_transport_ops = {
 	.lldd_execute_task	= mvs_task_exec,
 	.lldd_control_phy	= mvs_phy_control,
 	.lldd_abort_task	= mvs_task_abort,
+	.lldd_port_formed	= mvs_port_formed
 };
 
 static struct pci_device_id __devinitdata mvs_pci_table[] = {
-- 
1.5.4.rc4

