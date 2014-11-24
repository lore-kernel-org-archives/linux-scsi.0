From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 2/3] wd719x: Introduce Western Digital WD7193/7197/7296 PCI SCSI card driver
Date: Mon, 24 Nov 2014 13:11:13 +0100
Message-ID: <1416831074-24282-3-git-send-email-linux@rainbow-software.org>
References: <1416831074-24282-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416831074-24282-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Introduce wd719x, a driver for Western Digital WD7193, WD7197 and WD7296 PCI
SCSI controllers based on WD33C296A chip.
Tested with WD7193 card.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/Kconfig  |    8 +
 drivers/scsi/Makefile |    1 +
 drivers/scsi/wd719x.c | 1008 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/wd719x.h |  249 ++++++++++++
 4 files changed, 1266 insertions(+)
 create mode 100644 drivers/scsi/wd719x.c
 create mode 100644 drivers/scsi/wd719x.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3a820f6..fd81d14 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1451,6 +1451,14 @@ config SCSI_NSP32
 	  To compile this driver as a module, choose M here: the
 	  module will be called nsp32.
 
+config SCSI_WD719X
+	tristate "Western Digital WD7193/7197/7296 support"
+	depends on PCI && SCSI
+	select EEPROM_93CX6
+	---help---
+	  This is a driver for Western Digital WD7193, WD7197 and WD7296 PCI
+	  SCSI controllers (based on WD33C296A chip).
+
 config SCSI_DEBUG
 	tristate "SCSI debugging host simulator"
 	depends on SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 59f1ce6..d8bfca5 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -143,6 +143,7 @@ obj-$(CONFIG_SCSI_VIRTIO)	+= virtio_scsi.o
 obj-$(CONFIG_VMWARE_PVSCSI)	+= vmw_pvscsi.o
 obj-$(CONFIG_XEN_SCSI_FRONTEND)	+= xen-scsifront.o
 obj-$(CONFIG_HYPERV_STORAGE)	+= hv_storvsc.o
+obj-$(CONFIG_SCSI_WD719X)	+= wd719x.o
 
 obj-$(CONFIG_ARM)		+= arm/
 
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
new file mode 100644
index 0000000..ce6dafd
--- /dev/null
+++ b/drivers/scsi/wd719x.c
@@ -0,0 +1,1008 @@
+/*
+ * Driver for Western Digital WD7193, WD7197 and WD7296 SCSI cards
+ * Copyright 2013 Ondrej Zary
+ *
+ * Original driver by
+ * Aaron Dewell <dewell@woods.net>
+ * Gaerti <Juergen.Gaertner@mbox.si.uni-hannover.de>
+ *
+ * HW documentation available in book:
+ *
+ * SPIDER Command Protocol
+ * by Chandru M. Sippy
+ * SCSI Storage Products (MCP)
+ * Western Digital Corporation
+ * 09-15-95
+ *
+ * http://web.archive.org/web/20070717175254/http://sun1.rrzn.uni-hannover.de/gaertner.juergen/wd719x/Linux/Docu/Spider/
+ */
+
+/*
+ * Driver workflow:
+ * 1. SCSI command is transformed to SCB (Spider Control Block) by the
+ *    queuecommand function.
+ * 2. The address of the SCB is stored in a list to be able to access it, if
+ *    something goes wrong.
+ * 3. The address of the SCB is written to the Controller, which loads the SCB
+ *    via BM-DMA and processes it.
+ * 4. After it has finished, it generates an interrupt, and sets registers.
+ *
+ * flaws:
+ *  - abort/reset functions
+ *
+ * ToDo:
+ *  - tagged queueing
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/pci.h>
+#include <linux/firmware.h>
+#include <linux/eeprom_93cx6.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include "wd719x.h"
+
+/* low-level register access */
+static inline u8 wd719x_readb(struct wd719x *wd, u8 reg)
+{
+	return ioread8(wd->base + reg);
+}
+
+static inline u32 wd719x_readl(struct wd719x *wd, u8 reg)
+{
+	return ioread32(wd->base + reg);
+}
+
+static inline void wd719x_writeb(struct wd719x *wd, u8 reg, u8 val)
+{
+	iowrite8(val, wd->base + reg);
+}
+
+static inline void wd719x_writew(struct wd719x *wd, u8 reg, u16 val)
+{
+	iowrite16(val, wd->base + reg);
+}
+
+static inline void wd719x_writel(struct wd719x *wd, u8 reg, u32 val)
+{
+	iowrite32(val, wd->base + reg);
+}
+
+/* wait until the command register is ready */
+static inline int wd719x_wait_ready(struct wd719x *wd)
+{
+	int i = 0;
+
+	do {
+		if (wd719x_readb(wd, WD719X_AMR_COMMAND) == WD719X_CMD_READY)
+			return 0;
+		udelay(1);
+	} while (i++ < WD719X_WAIT_FOR_CMD_READY);
+
+	dev_err(&wd->pdev->dev, "command register is not ready: 0x%02x\n",
+		wd719x_readb(wd, WD719X_AMR_COMMAND));
+
+	return -ETIMEDOUT;
+}
+
+/* poll interrupt status register until command finishes */
+static inline int wd719x_wait_done(struct wd719x *wd, int timeout)
+{
+	u8 status;
+
+	while (timeout > 0) {
+		status = wd719x_readb(wd, WD719X_AMR_INT_STATUS);
+		if (status)
+			break;
+		timeout--;
+		udelay(1);
+	}
+
+	if (timeout <= 0) {
+		dev_err(&wd->pdev->dev, "direct command timed out\n");
+		return -ETIMEDOUT;
+	}
+
+	if (status != WD719X_INT_NOERRORS) {
+		dev_err(&wd->pdev->dev, "direct command failed, status 0x%02x, SUE 0x%02x\n",
+			status, wd719x_readb(wd, WD719X_AMR_SCB_ERROR));
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int wd719x_direct_cmd(struct wd719x *wd, u8 opcode, u8 dev, u8 lun,
+			     u8 tag, dma_addr_t data, int timeout)
+{
+	int ret = 0;
+
+	/* clear interrupt status register (allow command register to clear) */
+	wd719x_writeb(wd, WD719X_AMR_INT_STATUS, WD719X_INT_NONE);
+
+	/* Wait for the Command register to become free */
+	if (wd719x_wait_ready(wd))
+		return -ETIMEDOUT;
+
+	/* make sure we get NO interrupts */
+	dev |= WD719X_DISABLE_INT;
+	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM, dev);
+	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM_2, lun);
+	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM_3, tag);
+	if (data)
+		wd719x_writel(wd, WD719X_AMR_SCB_IN, data);
+
+	/* clear interrupt status register again */
+	wd719x_writeb(wd, WD719X_AMR_INT_STATUS, WD719X_INT_NONE);
+
+	/* Now, write the command */
+	wd719x_writeb(wd, WD719X_AMR_COMMAND, opcode);
+
+	if (timeout)	/* wait for the command to complete */
+		ret = wd719x_wait_done(wd, timeout);
+
+	/* clear interrupt status register (clean up) */
+	if (opcode != WD719X_CMD_READ_FIRMVER)
+		wd719x_writeb(wd, WD719X_AMR_INT_STATUS, WD719X_INT_NONE);
+
+	return ret;
+}
+
+static void wd719x_destroy(struct wd719x *wd)
+{
+	struct wd719x_scb *scb;
+
+	/* stop the RISC */
+	if (wd719x_direct_cmd(wd, WD719X_CMD_SLEEP, 0, 0, 0, 0,
+			      WD719X_WAIT_FOR_RISC))
+		dev_warn(&wd->pdev->dev, "RISC sleep command failed\n");
+	/* disable RISC */
+	wd719x_writeb(wd, WD719X_PCI_MODE_SELECT, 0);
+
+	/* free all SCBs */
+	list_for_each_entry(scb, &wd->active_scbs, list)
+		pci_free_consistent(wd->pdev, sizeof(struct wd719x_scb), scb,
+				    scb->phys);
+	list_for_each_entry(scb, &wd->free_scbs, list)
+		pci_free_consistent(wd->pdev, sizeof(struct wd719x_scb), scb,
+				    scb->phys);
+	/* free internal buffers */
+	pci_free_consistent(wd->pdev, wd->fw_size, wd->fw_virt, wd->fw_phys);
+	wd->fw_virt = NULL;
+	pci_free_consistent(wd->pdev, WD719X_HASH_TABLE_SIZE, wd->hash_virt,
+			    wd->hash_phys);
+	wd->hash_virt = NULL;
+	pci_free_consistent(wd->pdev, sizeof(struct wd719x_host_param),
+			    wd->params, wd->params_phys);
+	wd->params = NULL;
+	free_irq(wd->pdev->irq, wd);
+}
+
+/* finish a SCSI command, mark SCB (if any) as free, unmap buffers */
+static void wd719x_finish_cmd(struct scsi_cmnd *cmd, int result)
+{
+	struct wd719x *wd = shost_priv(cmd->device->host);
+	struct wd719x_scb *scb = (struct wd719x_scb *) cmd->host_scribble;
+
+	if (scb) {
+		list_move(&scb->list, &wd->free_scbs);
+		dma_unmap_single(&wd->pdev->dev, cmd->SCp.dma_handle,
+				 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+		scsi_dma_unmap(cmd);
+	}
+	cmd->result = result << 16;
+	cmd->scsi_done(cmd);
+}
+
+static int wd719x_send_scb(struct wd719x_scb *scb)
+{
+	struct wd719x *wd = shost_priv(scb->cmd->device->host);
+
+	/* wait for the Command register to become free */
+	if (wd719x_wait_ready(wd))
+		return DID_TIME_OUT;
+
+	/* first write pointer to the AMR */
+	wd719x_writel(wd, WD719X_AMR_SCB_IN, scb->phys);
+	/* send SCB opcode */
+	wd719x_writeb(wd, WD719X_AMR_COMMAND, WD719X_CMD_PROCESS_SCB);
+
+	return DID_OK;
+}
+
+/* Build a SCB and send it to the card using send_scb */
+static int wd719x_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *cmd)
+{
+	int i, result, count_sg;
+	unsigned long flags;
+	struct wd719x_scb *scb;
+	struct wd719x *wd = shost_priv(sh);
+	dma_addr_t phys;
+
+	cmd->host_scribble = NULL;
+
+	/* get a free SCB - either from existing ones or allocate a new one */
+	spin_lock_irqsave(wd->sh->host_lock, flags);
+	scb = list_first_entry_or_null(&wd->free_scbs, struct wd719x_scb, list);
+	if (scb) {
+		list_del(&scb->list);
+		phys = scb->phys;
+	} else {
+		spin_unlock_irqrestore(wd->sh->host_lock, flags);
+		scb = pci_alloc_consistent(wd->pdev, sizeof(struct wd719x_scb),
+					   &phys);
+		spin_lock_irqsave(wd->sh->host_lock, flags);
+		if (!scb) {
+			dev_err(&wd->pdev->dev, "unable to allocate SCB\n");
+			wd719x_finish_cmd(cmd, DID_ERROR);
+			spin_unlock_irqrestore(wd->sh->host_lock, flags);
+			return 0;
+		}
+	}
+	memset(scb, 0, sizeof(struct wd719x_scb));
+	list_add(&scb->list, &wd->active_scbs);
+
+	scb->phys = phys;
+	scb->cmd = cmd;
+	cmd->host_scribble = (char *) scb;
+
+	scb->CDB_tag = 0;	/* Tagged queueing not supported yet */
+	scb->devid = cmd->device->id;
+	scb->lun = cmd->device->lun;
+
+	/* copy the command */
+	memcpy(scb->CDB, cmd->cmnd, cmd->cmd_len);
+
+	/* map sense buffer */
+	scb->sense_buf_length = SCSI_SENSE_BUFFERSIZE;
+	cmd->SCp.dma_handle = dma_map_single(&wd->pdev->dev, cmd->sense_buffer,
+			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+	dma_cache_sync(&wd->pdev->dev, cmd->sense_buffer,
+			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
+	scb->sense_buf = cpu_to_le32(cmd->SCp.dma_handle);
+
+	/* request autosense */
+	scb->SCB_options |= WD719X_SCB_FLAGS_AUTO_REQUEST_SENSE;
+
+	/* check direction */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		scb->SCB_options |= WD719X_SCB_FLAGS_CHECK_DIRECTION
+				 |  WD719X_SCB_FLAGS_PCI_TO_SCSI;
+	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+		scb->SCB_options |= WD719X_SCB_FLAGS_CHECK_DIRECTION;
+
+	/* Scather/gather */
+	count_sg = scsi_dma_map(cmd);
+	if (count_sg < 0) {
+		wd719x_finish_cmd(cmd, DID_ERROR);
+		spin_unlock_irqrestore(wd->sh->host_lock, flags);
+		return 0;
+	}
+	BUG_ON(count_sg > WD719X_SG);
+
+	if (count_sg) {
+		struct scatterlist *sg;
+
+		scb->data_length = cpu_to_le32(count_sg *
+					       sizeof(struct wd719x_sglist));
+		scb->data_p = cpu_to_le32(scb->phys +
+					  offsetof(struct wd719x_scb, sg_list));
+
+		scsi_for_each_sg(cmd, sg, count_sg, i) {
+			scb->sg_list[i].ptr = cpu_to_le32(sg_dma_address(sg));
+			scb->sg_list[i].length = cpu_to_le32(sg_dma_len(sg));
+		}
+		scb->SCB_options |= WD719X_SCB_FLAGS_DO_SCATTER_GATHER;
+	} else { /* zero length */
+		scb->data_length = 0;
+		scb->data_p = 0;
+	}
+
+	result = wd719x_send_scb(scb);
+	if (result != DID_OK) {
+		dev_warn(&wd->pdev->dev, "can't queue SCB\n");
+		wd719x_finish_cmd(cmd, result);
+	}
+
+	spin_unlock_irqrestore(wd->sh->host_lock, flags);
+
+	return 0;
+}
+
+static int wd719x_chip_init(struct wd719x *wd)
+{
+	int i, ret;
+	u32 risc_init[3];
+	const struct firmware *fw_wcs, *fw_risc;
+	const char fwname_wcs[] = "wd719x-wcs.bin";
+	const char fwname_risc[] = "wd719x-risc.bin";
+
+	memset(wd->hash_virt, 0, WD719X_HASH_TABLE_SIZE);
+
+	/* WCS (sequencer) firmware */
+	ret = request_firmware(&fw_wcs, fwname_wcs, &wd->pdev->dev);
+	if (ret) {
+		dev_err(&wd->pdev->dev, "Unable to load firmware %s: %d\n",
+			fwname_wcs, ret);
+		return ret;
+	}
+	/* RISC firmware */
+	ret = request_firmware(&fw_risc, fwname_risc, &wd->pdev->dev);
+	if (ret) {
+		dev_err(&wd->pdev->dev, "Unable to load firmware %s: %d\n",
+			fwname_risc, ret);
+		release_firmware(fw_wcs);
+		return ret;
+	}
+	wd->fw_size = ALIGN(fw_wcs->size, 4) + fw_risc->size;
+
+	if (!wd->fw_virt)
+		wd->fw_virt = pci_alloc_consistent(wd->pdev, wd->fw_size,
+						   &wd->fw_phys);
+	if (!wd->fw_virt) {
+		ret = -ENOMEM;
+		goto wd719x_init_end;
+	}
+
+	/* make a fresh copy of WCS and RISC code */
+	memcpy(wd->fw_virt, fw_wcs->data, fw_wcs->size);
+	memcpy(wd->fw_virt + ALIGN(fw_wcs->size, 4), fw_risc->data,
+		fw_risc->size);
+
+	/* Reset the Spider Chip and adapter itself */
+	wd719x_writeb(wd, WD719X_PCI_PORT_RESET, WD719X_PCI_RESET);
+	udelay(WD719X_WAIT_FOR_RISC);
+	/* Clear PIO mode bits set by BIOS */
+	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM, 0);
+	/* ensure RISC is not running */
+	wd719x_writeb(wd, WD719X_PCI_MODE_SELECT, 0);
+	/* ensure command port is ready */
+	wd719x_writeb(wd, WD719X_AMR_COMMAND, 0);
+	if (wd719x_wait_ready(wd)) {
+		ret = -ETIMEDOUT;
+		goto wd719x_init_end;
+	}
+
+	/* Transfer the first 2K words of RISC code to kick start the uP */
+	risc_init[0] = wd->fw_phys;				/* WCS FW */
+	risc_init[1] = wd->fw_phys + ALIGN(fw_wcs->size, 4);	/* RISC FW */
+	risc_init[2] = wd->hash_phys;				/* hash table */
+
+	/* clear DMA status */
+	wd719x_writeb(wd, WD719X_PCI_CHANNEL2_3STATUS, 0);
+
+	/* address to read firmware from */
+	wd719x_writel(wd, WD719X_PCI_EXTERNAL_ADDR, risc_init[1]);
+	/* base address to write firmware to (on card) */
+	wd719x_writew(wd, WD719X_PCI_INTERNAL_ADDR, WD719X_PRAM_BASE_ADDR);
+	/* size: first 2K words */
+	wd719x_writew(wd, WD719X_PCI_DMA_TRANSFER_SIZE, 2048 * 2);
+	/* start DMA */
+	wd719x_writeb(wd, WD719X_PCI_CHANNEL2_3CMD, WD719X_START_CHANNEL2_3DMA);
+
+	/* wait for DMA to complete */
+	i = WD719X_WAIT_FOR_RISC;
+	while (i-- > 0) {
+		u8 status = wd719x_readb(wd, WD719X_PCI_CHANNEL2_3STATUS);
+		if (status == WD719X_START_CHANNEL2_3DONE)
+			break;
+		if (status == WD719X_START_CHANNEL2_3ABORT) {
+			dev_warn(&wd->pdev->dev, "RISC bootstrap failed: DMA aborted\n");
+			ret = -EIO;
+			goto wd719x_init_end;
+		}
+		udelay(1);
+	}
+	if (i < 1) {
+		dev_warn(&wd->pdev->dev, "RISC bootstrap failed: DMA timeout\n");
+		ret = -ETIMEDOUT;
+		goto wd719x_init_end;
+	}
+
+	/* firmware is loaded, now initialize and wake up the RISC */
+	/* write RISC initialization long words to Spider */
+	wd719x_writel(wd, WD719X_AMR_SCB_IN, risc_init[0]);
+	wd719x_writel(wd, WD719X_AMR_SCB_IN + 4, risc_init[1]);
+	wd719x_writel(wd, WD719X_AMR_SCB_IN + 8, risc_init[2]);
+
+	/* disable interrupts during initialization of RISC */
+	wd719x_writeb(wd, WD719X_AMR_CMD_PARAM, WD719X_DISABLE_INT);
+
+	/* issue INITIALIZE RISC comand */
+	wd719x_writeb(wd, WD719X_AMR_COMMAND, WD719X_CMD_INIT_RISC);
+	/* enable advanced mode (wake up RISC) */
+	wd719x_writeb(wd, WD719X_PCI_MODE_SELECT, WD719X_ENABLE_ADVANCE_MODE);
+	udelay(WD719X_WAIT_FOR_RISC);
+
+	ret = wd719x_wait_done(wd, WD719X_WAIT_FOR_RISC);
+	/* clear interrupt status register */
+	wd719x_writeb(wd, WD719X_AMR_INT_STATUS, WD719X_INT_NONE);
+	if (ret) {
+		dev_warn(&wd->pdev->dev, "Unable to initialize RISC\n");
+		goto wd719x_init_end;
+	}
+	/* RISC is up and running */
+
+	/* Read FW version from RISC */
+	ret = wd719x_direct_cmd(wd, WD719X_CMD_READ_FIRMVER, 0, 0, 0, 0,
+				WD719X_WAIT_FOR_RISC);
+	if (ret) {
+		dev_warn(&wd->pdev->dev, "Unable to read firmware version\n");
+		goto wd719x_init_end;
+	}
+	dev_info(&wd->pdev->dev, "RISC initialized with firmware version %.2x.%.2x\n",
+			wd719x_readb(wd, WD719X_AMR_SCB_OUT + 1),
+			wd719x_readb(wd, WD719X_AMR_SCB_OUT));
+
+	/* RESET SCSI bus */
+	ret = wd719x_direct_cmd(wd, WD719X_CMD_BUSRESET, 0, 0, 0, 0,
+				WD719X_WAIT_FOR_SCSI_RESET);
+	if (ret) {
+		dev_warn(&wd->pdev->dev, "SCSI bus reset failed\n");
+		goto wd719x_init_end;
+	}
+
+	/* use HostParameter structure to set Spider's Host Parameter Block */
+	ret = wd719x_direct_cmd(wd, WD719X_CMD_SET_PARAM, 0,
+				sizeof(struct wd719x_host_param), 0,
+				wd->params_phys, WD719X_WAIT_FOR_RISC);
+	if (ret) {
+		dev_warn(&wd->pdev->dev, "Failed to set HOST PARAMETERS\n");
+		goto wd719x_init_end;
+	}
+
+	/* initiate SCAM (does nothing if disabled in BIOS) */
+	/* bug?: we should pass a mask of static IDs which we don't have */
+	ret = wd719x_direct_cmd(wd, WD719X_CMD_INIT_SCAM, 0, 0, 0, 0,
+				WD719X_WAIT_FOR_SCSI_RESET);
+	if (ret) {
+		dev_warn(&wd->pdev->dev, "SCAM initialization failed\n");
+		goto wd719x_init_end;
+	}
+
+	/* clear AMR_BIOS_SHARE_INT register */
+	wd719x_writeb(wd, WD719X_AMR_BIOS_SHARE_INT, 0);
+
+wd719x_init_end:
+	release_firmware(fw_wcs);
+	release_firmware(fw_risc);
+
+	return ret;
+}
+
+static int wd719x_abort(struct scsi_cmnd *cmd)
+{
+	int action, result;
+	unsigned long flags;
+	struct wd719x_scb *scb = (struct wd719x_scb *)cmd->host_scribble;
+	struct wd719x *wd = shost_priv(cmd->device->host);
+
+	dev_info(&wd->pdev->dev, "abort command, tag: %x\n", cmd->tag);
+
+	action = /*cmd->tag ? WD719X_CMD_ABORT_TAG : */WD719X_CMD_ABORT;
+
+	spin_lock_irqsave(wd->sh->host_lock, flags);
+	result = wd719x_direct_cmd(wd, action, cmd->device->id,
+				   cmd->device->lun, cmd->tag, scb->phys, 0);
+	spin_unlock_irqrestore(wd->sh->host_lock, flags);
+	if (result)
+		return FAILED;
+
+	return SUCCESS;
+}
+
+static int wd719x_reset(struct scsi_cmnd *cmd, u8 opcode, u8 device)
+{
+	int result;
+	unsigned long flags;
+	struct wd719x *wd = shost_priv(cmd->device->host);
+
+	dev_info(&wd->pdev->dev, "%s reset requested\n",
+		 (opcode == WD719X_CMD_BUSRESET) ? "bus" : "device");
+
+	spin_lock_irqsave(wd->sh->host_lock, flags);
+	result = wd719x_direct_cmd(wd, opcode, device, 0, 0, 0,
+				   WD719X_WAIT_FOR_SCSI_RESET);
+	spin_unlock_irqrestore(wd->sh->host_lock, flags);
+	if (result)
+		return FAILED;
+
+	return SUCCESS;
+}
+
+static int wd719x_dev_reset(struct scsi_cmnd *cmd)
+{
+	return wd719x_reset(cmd, WD719X_CMD_RESET, cmd->device->id);
+}
+
+static int wd719x_bus_reset(struct scsi_cmnd *cmd)
+{
+	return wd719x_reset(cmd, WD719X_CMD_BUSRESET, 0);
+}
+
+static int wd719x_host_reset(struct scsi_cmnd *cmd)
+{
+	struct wd719x *wd = shost_priv(cmd->device->host);
+	struct wd719x_scb *scb, *tmp;
+	unsigned long flags;
+	int result;
+
+	dev_info(&wd->pdev->dev, "host reset requested\n");
+	spin_lock_irqsave(wd->sh->host_lock, flags);
+	/* Try to reinit the RISC */
+	if (wd719x_chip_init(wd) == 0)
+		result = SUCCESS;
+	else
+		result = FAILED;
+
+	/* flush all SCBs */
+	list_for_each_entry_safe(scb, tmp, &wd->active_scbs, list) {
+		struct scsi_cmnd *tmp_cmd = scb->cmd;
+		wd719x_finish_cmd(tmp_cmd, result);
+	}
+	spin_unlock_irqrestore(wd->sh->host_lock, flags);
+
+	return result;
+}
+
+static int wd719x_biosparam(struct scsi_device *sdev, struct block_device *bdev,
+			    sector_t capacity, int geom[])
+{
+	if (capacity >= 0x200000) {
+		geom[0] = 255;	/* heads */
+		geom[1] = 63;	/* sectors */
+	} else {
+		geom[0] = 64;	/* heads */
+		geom[1] = 32;	/* sectors */
+	}
+	geom[2] = sector_div(capacity, geom[0] * geom[1]);	/* cylinders */
+
+	return 0;
+}
+
+/* process a SCB-completion interrupt */
+static inline void wd719x_interrupt_SCB(struct wd719x *wd,
+					union wd719x_regs regs,
+					struct wd719x_scb *scb)
+{
+	struct scsi_cmnd *cmd;
+	int result;
+
+	/* now have to find result from card */
+	switch (regs.bytes.SUE) {
+	case WD719X_SUE_NOERRORS:
+		result = DID_OK;
+		break;
+	case WD719X_SUE_REJECTED:
+		dev_err(&wd->pdev->dev, "command rejected\n");
+		result = DID_ERROR;
+		break;
+	case WD719X_SUE_SCBQFULL:
+		dev_err(&wd->pdev->dev, "SCB queue is full\n");
+		result = DID_ERROR;
+		break;
+	case WD719X_SUE_TERM:
+		dev_dbg(&wd->pdev->dev, "SCB terminated by direct command\n");
+		result = DID_ABORT;	/* or DID_RESET? */
+		break;
+	case WD719X_SUE_CHAN1ABORT:
+	case WD719X_SUE_CHAN23ABORT:
+		result = DID_ABORT;
+		dev_err(&wd->pdev->dev, "DMA abort\n");
+		break;
+	case WD719X_SUE_CHAN1PAR:
+	case WD719X_SUE_CHAN23PAR:
+		result = DID_PARITY;
+		dev_err(&wd->pdev->dev, "DMA parity error\n");
+		break;
+	case WD719X_SUE_TIMEOUT:
+		result = DID_TIME_OUT;
+		dev_dbg(&wd->pdev->dev, "selection timeout\n");
+		break;
+	case WD719X_SUE_RESET:
+		dev_dbg(&wd->pdev->dev, "bus reset occured\n");
+		result = DID_RESET;
+		break;
+	case WD719X_SUE_BUSERROR:
+		dev_dbg(&wd->pdev->dev, "SCSI bus error\n");
+		result = DID_ERROR;
+		break;
+	case WD719X_SUE_WRONGWAY:
+		dev_err(&wd->pdev->dev, "wrong data transfer direction\n");
+		result = DID_ERROR;
+		break;
+	case WD719X_SUE_BADPHASE:
+		dev_err(&wd->pdev->dev, "invalid SCSI phase\n");
+		result = DID_ERROR;
+		break;
+	case WD719X_SUE_TOOLONG:
+		dev_err(&wd->pdev->dev, "record too long\n");
+		result = DID_ERROR;
+		break;
+	case WD719X_SUE_BUSFREE:
+		dev_err(&wd->pdev->dev, "unexpected bus free\n");
+		result = DID_NO_CONNECT; /* or DID_ERROR ???*/
+		break;
+	case WD719X_SUE_ARSDONE:
+		dev_dbg(&wd->pdev->dev, "auto request sense\n");
+		if (regs.bytes.SCSI == 0)
+			result = DID_OK;
+		else
+			result = DID_PARITY;
+		break;
+	case WD719X_SUE_IGNORED:
+		dev_err(&wd->pdev->dev, "target id %d ignored command\n",
+			scb->cmd->device->id);
+		result = DID_NO_CONNECT;
+		break;
+	case WD719X_SUE_WRONGTAGS:
+		dev_err(&wd->pdev->dev, "reversed tags\n");
+		result = DID_ERROR;
+		break;
+	case WD719X_SUE_BADTAGS:
+		dev_err(&wd->pdev->dev, "tag type not supported by target\n");
+		result = DID_ERROR;
+		break;
+	case WD719X_SUE_NOSCAMID:
+		dev_err(&wd->pdev->dev, "no SCAM soft ID available\n");
+		result = DID_ERROR;
+		break;
+	default:
+		dev_warn(&wd->pdev->dev, "unknown SUE error code: 0x%x\n",
+			 regs.bytes.SUE);
+		result = DID_ERROR;
+		break;
+	}
+	cmd = scb->cmd;
+
+	wd719x_finish_cmd(cmd, result);
+}
+
+static irqreturn_t wd719x_interrupt(int irq, void *dev_id)
+{
+	struct wd719x *wd = dev_id;
+	union wd719x_regs regs;
+	unsigned long flags;
+	u32 SCB_out;
+
+	spin_lock_irqsave(wd->sh->host_lock, flags);
+	/* read SCB pointer back from card */
+	SCB_out = wd719x_readl(wd, WD719X_AMR_SCB_OUT);
+	/* read all status info at once */
+	regs.all = cpu_to_le32(wd719x_readl(wd, WD719X_AMR_OP_CODE));
+
+	switch (regs.bytes.INT) {
+	case WD719X_INT_NONE:
+		spin_unlock_irqrestore(wd->sh->host_lock, flags);
+		return IRQ_NONE;
+	case WD719X_INT_LINKNOSTATUS:
+		dev_err(&wd->pdev->dev, "linked command completed with no status\n");
+		break;
+	case WD719X_INT_BADINT:
+		dev_err(&wd->pdev->dev, "unsolicited interrupt\n");
+		break;
+	case WD719X_INT_NOERRORS:
+	case WD719X_INT_LINKNOERRORS:
+	case WD719X_INT_ERRORSLOGGED:
+	case WD719X_INT_SPIDERFAILED:
+		/* was the cmd completed a direct or SCB command? */
+		if (regs.bytes.OPC == WD719X_CMD_PROCESS_SCB) {
+			struct wd719x_scb *scb;
+			list_for_each_entry(scb, &wd->active_scbs, list)
+				if (SCB_out == scb->phys)
+					break;
+			if (SCB_out == scb->phys)
+				wd719x_interrupt_SCB(wd, regs, scb);
+			else
+				dev_err(&wd->pdev->dev, "card returned invalid SCB pointer\n");
+		} else
+			dev_warn(&wd->pdev->dev, "direct command 0x%x completed\n",
+				 regs.bytes.OPC);
+		break;
+	case WD719X_INT_PIOREADY:
+		dev_err(&wd->pdev->dev, "card indicates PIO data ready but we never use PIO\n");
+		/* interrupt will not be cleared until all data is read */
+		break;
+	default:
+		dev_err(&wd->pdev->dev, "unknown interrupt reason: %d\n",
+			regs.bytes.INT);
+
+	}
+	/* clear interrupt so another can happen */
+	wd719x_writeb(wd, WD719X_AMR_INT_STATUS, WD719X_INT_NONE);
+	spin_unlock_irqrestore(wd->sh->host_lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static void wd719x_eeprom_reg_read(struct eeprom_93cx6 *eeprom)
+{
+	struct wd719x *wd = eeprom->data;
+	u8 reg = wd719x_readb(wd, WD719X_PCI_GPIO_DATA);
+
+	eeprom->reg_data_out = reg & WD719X_EE_DO;
+}
+
+static void wd719x_eeprom_reg_write(struct eeprom_93cx6 *eeprom)
+{
+	struct wd719x *wd = eeprom->data;
+	u8 reg = 0;
+
+	if (eeprom->reg_data_in)
+		reg |= WD719X_EE_DI;
+	if (eeprom->reg_data_clock)
+		reg |= WD719X_EE_CLK;
+	if (eeprom->reg_chip_select)
+		reg |= WD719X_EE_CS;
+
+	wd719x_writeb(wd, WD719X_PCI_GPIO_DATA, reg);
+}
+
+/* read config from EEPROM so it can be downloaded by the RISC on (re-)init */
+static void wd719x_read_eeprom(struct wd719x *wd)
+{
+	struct eeprom_93cx6 eeprom;
+	u8 gpio;
+	struct wd719x_eeprom_header header;
+
+	eeprom.data = wd;
+	eeprom.register_read = wd719x_eeprom_reg_read;
+	eeprom.register_write = wd719x_eeprom_reg_write;
+	eeprom.width = PCI_EEPROM_WIDTH_93C46;
+
+	/* set all outputs to low */
+	wd719x_writeb(wd, WD719X_PCI_GPIO_DATA, 0);
+	/* configure GPIO pins */
+	gpio = wd719x_readb(wd, WD719X_PCI_GPIO_CONTROL);
+	/* GPIO outputs */
+	gpio &= (~(WD719X_EE_CLK | WD719X_EE_DI | WD719X_EE_CS));
+	/* GPIO input */
+	gpio |= WD719X_EE_DO;
+	wd719x_writeb(wd, WD719X_PCI_GPIO_CONTROL, gpio);
+
+	/* read EEPROM header */
+	eeprom_93cx6_multireadb(&eeprom, 0, (u8 *)&header, sizeof(header));
+
+	if (header.sig1 == 'W' && header.sig2 == 'D')
+		eeprom_93cx6_multireadb(&eeprom, header.cfg_offset,
+					(u8 *)wd->params,
+					sizeof(struct wd719x_host_param));
+	else { /* default EEPROM values */
+		dev_warn(&wd->pdev->dev, "EEPROM signature is invalid (0x%02x 0x%02x), using default values\n",
+			 header.sig1, header.sig2);
+		wd->params->ch_1_th	= 0x10;	/* 16 DWs = 64 B */
+		wd->params->scsi_conf	= 0x4c;	/* 48ma, spue, parity check */
+		wd->params->own_scsi_id	= 0x07;	/* ID 7, SCAM disabled */
+		wd->params->sel_timeout = 0x4d;	/* 250 ms */
+		wd->params->sleep_timer	= 0x01;
+		wd->params->cdb_size	= cpu_to_le16(0x5555);	/* all 6 B */
+		wd->params->scsi_pad	= 0x1b;
+		if (wd->type == WD719X_TYPE_7193) /* narrow card - disable */
+			wd->params->wide = cpu_to_le32(0x00000000);
+		else	/* initiate & respond to WIDE messages */
+			wd->params->wide = cpu_to_le32(0xffffffff);
+		wd->params->sync	= cpu_to_le32(0xffffffff);
+		wd->params->soft_mask	= 0x00;	/* all disabled */
+		wd->params->unsol_mask	= 0x00;	/* all disabled */
+	}
+	/* disable TAGGED messages */
+	wd->params->tag_en = cpu_to_le16(0x0000);
+}
+
+/* Read card type from GPIO bits 1 and 3 */
+static enum wd719x_card_type wd719x_detect_type(struct wd719x *wd)
+{
+	u8 card = wd719x_readb(wd, WD719X_PCI_GPIO_CONTROL);
+
+	card |= WD719X_GPIO_ID_BITS;
+	wd719x_writeb(wd, WD719X_PCI_GPIO_CONTROL, card);
+	card = wd719x_readb(wd, WD719X_PCI_GPIO_DATA) & WD719X_GPIO_ID_BITS;
+	switch (card) {
+	case 0x08:
+		return WD719X_TYPE_7193;
+	case 0x02:
+		return WD719X_TYPE_7197;
+	case 0x00:
+		return WD719X_TYPE_7296;
+	default:
+		dev_warn(&wd->pdev->dev, "unknown card type 0x%x\n", card);
+		return WD719X_TYPE_UNKNOWN;
+	}
+}
+
+static int wd719x_board_found(struct Scsi_Host *sh)
+{
+	struct wd719x *wd = shost_priv(sh);
+	char *card_types[] = { "Unknown card", "WD7193", "WD7197", "WD7296" };
+	int ret;
+
+	INIT_LIST_HEAD(&wd->active_scbs);
+	INIT_LIST_HEAD(&wd->free_scbs);
+
+	sh->base = pci_resource_start(wd->pdev, 0);
+
+	wd->type = wd719x_detect_type(wd);
+
+	wd->sh = sh;
+	sh->irq = wd->pdev->irq;
+	wd->fw_virt = NULL;
+
+	/* memory area for host (EEPROM) parameters */
+	wd->params = pci_alloc_consistent(wd->pdev,
+					  sizeof(struct wd719x_host_param),
+					  &wd->params_phys);
+	if (!wd->params) {
+		dev_warn(&wd->pdev->dev, "unable to allocate parameter buffer\n");
+		return -ENOMEM;
+	}
+
+	/* memory area for the RISC for hash table of outstanding requests */
+	wd->hash_virt = pci_alloc_consistent(wd->pdev, WD719X_HASH_TABLE_SIZE,
+					     &wd->hash_phys);
+	if (!wd->hash_virt) {
+		dev_warn(&wd->pdev->dev, "unable to allocate hash buffer\n");
+		ret = -ENOMEM;
+		goto fail_free_params;
+	}
+
+	ret = request_irq(wd->pdev->irq, wd719x_interrupt, IRQF_SHARED,
+			  "wd719x", wd);
+	if (ret) {
+		dev_warn(&wd->pdev->dev, "unable to assign IRQ %d\n",
+			 wd->pdev->irq);
+		goto fail_free_hash;
+	}
+
+	/* read parameters from EEPROM */
+	wd719x_read_eeprom(wd);
+
+	ret = wd719x_chip_init(wd);
+	if (ret)
+		goto fail_free_irq;
+
+	sh->this_id = wd->params->own_scsi_id & WD719X_EE_SCSI_ID_MASK;
+
+	dev_info(&wd->pdev->dev, "%s at I/O 0x%lx, IRQ %u, SCSI ID %d\n",
+		 card_types[wd->type], sh->base, sh->irq, sh->this_id);
+
+	return 0;
+
+fail_free_irq:
+	free_irq(wd->pdev->irq, wd);
+fail_free_hash:
+	pci_free_consistent(wd->pdev, WD719X_HASH_TABLE_SIZE, wd->hash_virt,
+			    wd->hash_phys);
+fail_free_params:
+	pci_free_consistent(wd->pdev, sizeof(struct wd719x_host_param),
+			    wd->params, wd->params_phys);
+
+	return ret;
+}
+
+static struct scsi_host_template wd719x_template = {
+	.name				= "Western Digital 719x",
+	.queuecommand			= wd719x_queuecommand,
+	.eh_abort_handler		= wd719x_abort,
+	.eh_device_reset_handler	= wd719x_dev_reset,
+	.eh_bus_reset_handler		= wd719x_bus_reset,
+	.eh_host_reset_handler		= wd719x_host_reset,
+	.bios_param			= wd719x_biosparam,
+	.proc_name			= "wd719x",
+	.can_queue			= 255,
+	.this_id			= 7,
+	.sg_tablesize			= WD719X_SG,
+	.cmd_per_lun			= WD719X_CMD_PER_LUN,
+	.use_clustering			= ENABLE_CLUSTERING,
+};
+
+static int wd719x_pci_probe(struct pci_dev *pdev, const struct pci_device_id *d)
+{
+	int err;
+	struct Scsi_Host *sh;
+	struct wd719x *wd;
+
+	err = pci_enable_device(pdev);
+	if (err)
+		goto fail;
+
+	if (pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) {
+		dev_warn(&pdev->dev, "Unable to set 32-bit DMA mask\n");
+		goto disable_device;
+	}
+
+	err = pci_request_regions(pdev, "wd719x");
+	if (err)
+		goto disable_device;
+	pci_set_master(pdev);
+
+	err = -ENODEV;
+	if (pci_resource_len(pdev, 0) == 0)
+		goto release_region;
+
+	err = -ENOMEM;
+	sh = scsi_host_alloc(&wd719x_template, sizeof(struct wd719x));
+	if (!sh)
+		goto release_region;
+
+	wd = shost_priv(sh);
+	wd->base = pci_iomap(pdev, 0, 0);
+	if (!wd->base)
+		goto free_host;
+	wd->pdev = pdev;
+
+	err = wd719x_board_found(sh);
+	if (err)
+		goto unmap;
+
+	err = scsi_add_host(sh, &wd->pdev->dev);
+	if (err)
+		goto destroy;
+
+	scsi_scan_host(sh);
+
+	pci_set_drvdata(pdev, sh);
+	return 0;
+
+destroy:
+	wd719x_destroy(wd);
+unmap:
+	pci_iounmap(pdev, wd->base);
+free_host:
+	scsi_host_put(sh);
+release_region:
+	pci_release_regions(pdev);
+disable_device:
+	pci_disable_device(pdev);
+fail:
+	return err;
+}
+
+
+static void wd719x_pci_remove(struct pci_dev *pdev)
+{
+	struct Scsi_Host *sh = pci_get_drvdata(pdev);
+	struct wd719x *wd = shost_priv(sh);
+
+	scsi_remove_host(sh);
+	wd719x_destroy(wd);
+	pci_iounmap(pdev, wd->base);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+
+	scsi_host_put(sh);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(wd719x_pci_table) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_WD, 0x3296) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, wd719x_pci_table);
+
+static struct pci_driver wd719x_pci_driver = {
+	.name =		"wd719x",
+	.id_table =	wd719x_pci_table,
+	.probe =	wd719x_pci_probe,
+	.remove =	wd719x_pci_remove,
+};
+
+static int __init wd719x_init(void)
+{
+	return pci_register_driver(&wd719x_pci_driver);
+}
+
+static void __exit wd719x_exit(void)
+{
+	pci_unregister_driver(&wd719x_pci_driver);
+}
+
+module_init(wd719x_init);
+module_exit(wd719x_exit);
+
+MODULE_DESCRIPTION("Western Digital WD7193/7197/7296 SCSI driver");
+MODULE_AUTHOR("Ondrej Zary, Aaron Dewell, Juergen Gaertner");
+MODULE_LICENSE("GPL");
+MODULE_FIRMWARE("wd719x-wcs.bin");
+MODULE_FIRMWARE("wd719x-risc.bin");
diff --git a/drivers/scsi/wd719x.h b/drivers/scsi/wd719x.h
new file mode 100644
index 0000000..185e30e
--- /dev/null
+++ b/drivers/scsi/wd719x.h
@@ -0,0 +1,249 @@
+#ifndef _WD719X_H_
+#define _WD719X_H_
+
+#define WD719X_SG 255		/* Scatter/gather size */
+#define WD719X_CMD_PER_LUN 1	/* We should be able to do linked commands, but
+				 * this is 1 for now to be safe. */
+
+struct wd719x_sglist {
+	__le32 ptr;
+	__le32 length;
+} __packed;
+
+enum wd719x_card_type {
+	WD719X_TYPE_UNKNOWN = 0,
+	WD719X_TYPE_7193,
+	WD719X_TYPE_7197,
+	WD719X_TYPE_7296,
+};
+
+union wd719x_regs {
+	__le32 all;	/* All Status at once */
+	struct {
+		u8 OPC;		/* Opcode register */
+		u8 SCSI;	/* SCSI Errors */
+		u8 SUE;		/* Spider unique Errors */
+		u8 INT;		/* Interrupt Status */
+	} bytes;
+};
+
+/* Spider Command Block (SCB) */
+struct wd719x_scb {
+	__le32 Int_SCB;	/* 00-03 Internal SCB link pointer (must be cleared) */
+	u8 SCB_opcode;	/* 04 SCB Command opcode */
+	u8 CDB_tag;	/* 05 SCSI Tag byte for CDB queues (0 if untagged) */
+	u8 lun;		/* 06 SCSI LUN */
+	u8 devid;	/* 07 SCSI Device ID */
+	u8 CDB[16];	/* 08-23 SCSI CDB (16 bytes as defined by ANSI spec. */
+	__le32 data_p;	/* 24-27 Data transfer address (or SG list address) */
+	__le32 data_length; /* 28-31 Data transfer Length (or SG list length) */
+	__le32 CDB_link;    /* 32-35 SCSI CDB Link Ptr */
+	__le32 sense_buf;   /* 36-39 Auto request sense buffer address */
+	u8 sense_buf_length;/* 40 Auto request sense transfer length */
+	u8 reserved;	/* 41 reserved */
+	u8 SCB_options;	/* 42 SCB-options */
+	u8 SCB_tag_msg;	/* 43 Tagged messages options */
+	/* Not filled in by host */
+	__le32 req_ptr;	/* 44-47 Ptr to Host Request returned on interrupt */
+	u8 host_opcode;	/* 48 Host Command Opcode (same as AMR_00) */
+	u8 scsi_stat;	/* 49 SCSI Status returned */
+	u8 ret_error;	/* 50 SPIDER Unique Error Code returned (SUE) */
+	u8 int_stat;	/* 51 Message u8 / Interrupt Status byte returned */
+	__le32 transferred; /* 52-55 Bytes Transferred */
+	u8 last_trans[3];  /* 56-58 Bytes Transferred in last session */
+	u8 length;	/* 59 SCSI Messages Length (1-8) */
+	u8 sync_offset;	/* 60 Synchronous offset */
+	u8 sync_rate;	/* 61 Synchronous rate */
+	u8 flags[2];	/* 62-63 SCB specific flags (local to each thread) */
+	/* everything below is for driver use (not used by card) */
+	dma_addr_t phys;	/* bus address of the SCB */
+	struct scsi_cmnd *cmd;	/* a copy of the pointer we were passed */
+	struct list_head list;
+	struct wd719x_sglist sg_list[WD719X_SG] __aligned(8); /* SG list */
+} __packed;
+
+struct wd719x {
+	struct Scsi_Host *sh;	/* pointer to host structure */
+	struct pci_dev *pdev;
+	void __iomem *base;
+	enum wd719x_card_type type; /* type of card */
+	void *fw_virt;		/* firmware buffer CPU address */
+	dma_addr_t fw_phys;	/* firmware buffer bus address */
+	size_t fw_size;		/* firmware buffer size */
+	struct wd719x_host_param *params; /* host parameters (EEPROM) */
+	dma_addr_t params_phys; /* host parameters bus address */
+	void *hash_virt;	/* hash table CPU address */
+	dma_addr_t hash_phys;	/* hash table bus address */
+	struct list_head active_scbs;
+	struct list_head free_scbs;
+};
+
+/* timeout delays in microsecs */
+#define WD719X_WAIT_FOR_CMD_READY	500
+#define WD719X_WAIT_FOR_RISC		2000
+#define WD719X_WAIT_FOR_SCSI_RESET	3000000
+
+/* All commands except 0x00 generate an interrupt */
+#define WD719X_CMD_READY	0x00 /* Command register ready (or noop) */
+#define WD719X_CMD_INIT_RISC	0x01 /* Initialize RISC */
+/* 0x02 is reserved */
+#define WD719X_CMD_BUSRESET	0x03 /* Assert SCSI bus reset */
+#define WD719X_CMD_READ_FIRMVER	0x04 /* Read the Firmware Revision */
+#define WD719X_CMD_ECHO_BYTES	0x05 /* Echo command bytes (DW) */
+/* 0x06 is reserved */
+/* 0x07 is reserved */
+#define WD719X_CMD_GET_PARAM	0x08 /* Get programmable parameters */
+#define WD719X_CMD_SET_PARAM	0x09 /* Set programmable parameters */
+#define WD719X_CMD_SLEEP	0x0a /* Put SPIDER to sleep */
+#define WD719X_CMD_READ_INIT	0x0b /* Read initialization parameters */
+#define WD719X_CMD_RESTORE_INIT	0x0c /* Restore initialization parameters */
+/* 0x0d is reserved */
+/* 0x0e is reserved */
+/* 0x0f is reserved */
+#define WD719X_CMD_ABORT_TAG	0x10 /* Send Abort tag message to target */
+#define WD719X_CMD_ABORT	0x11 /* Send Abort message to target */
+#define WD719X_CMD_RESET	0x12 /* Send Reset message to target */
+#define WD719X_CMD_INIT_SCAM	0x13 /* Initiate SCAM */
+#define WD719X_CMD_GET_SYNC	0x14 /* Get synchronous rates */
+#define WD719X_CMD_SET_SYNC	0x15 /* Set synchronous rates */
+#define WD719X_CMD_GET_WIDTH	0x16 /* Get SCSI bus width */
+#define WD719X_CMD_SET_WIDTH	0x17 /* Set SCSI bus width */
+#define WD719X_CMD_GET_TAGS	0x18 /* Get tag flags */
+#define WD719X_CMD_SET_TAGS	0x19 /* Set tag flags */
+#define WD719X_CMD_GET_PARAM2	0x1a /* Get programmable params (format 2) */
+#define WD719X_CMD_SET_PARAM2	0x1b /* Set programmable params (format 2) */
+/* Commands with request pointers (mailbox) */
+#define WD719X_CMD_PROCESS_SCB	0x80 /* Process SCSI Control Block (SCB) */
+/* No interrupt generated on acceptance of SCB pointer */
+
+/* interrupt status defines */
+#define WD719X_INT_NONE		0x00 /* No interrupt pending */
+#define WD719X_INT_NOERRORS	0x01 /* Command completed with no errors */
+#define WD719X_INT_LINKNOERRORS	0x02 /* link cmd completed with no errors */
+#define WD719X_INT_LINKNOSTATUS	0x03 /* link cmd completed with no flag set */
+#define WD719X_INT_ERRORSLOGGED	0x04 /* cmd completed with errors logged */
+#define WD719X_INT_SPIDERFAILED	0x05 /* cmd failed without valid SCSI status */
+#define WD719X_INT_BADINT	0x80 /* unsolicited interrupt */
+#define WD719X_INT_PIOREADY	0xf0 /* data ready for PIO output */
+
+/* Spider Unique Error Codes (SUE) */
+#define WD719X_SUE_NOERRORS	0x00 /* No errors detected by SPIDER */
+#define WD719X_SUE_REJECTED	0x01 /* Command Rejected (bad opcode/param) */
+#define WD719X_SUE_SCBQFULL	0x02 /* SCB queue full */
+/* 0x03 is reserved */
+#define WD719X_SUE_TERM		0x04 /* Host terminated SCB via primative cmd */
+#define WD719X_SUE_CHAN1PAR	0x05 /* PCI Channel 1 parity error occurred */
+#define WD719X_SUE_CHAN1ABORT	0x06 /* PCI Channel 1 system abort occurred */
+#define WD719X_SUE_CHAN23PAR	0x07 /* PCI Channel 2/3 parity error occurred */
+#define WD719X_SUE_CHAN23ABORT	0x08 /* PCI Channel 2/3 system abort occurred */
+#define WD719X_SUE_TIMEOUT	0x10 /* Selection/reselection timeout */
+#define WD719X_SUE_RESET	0x11 /* SCSI bus reset occurred */
+#define WD719X_SUE_BUSERROR	0x12 /* SCSI bus error */
+#define WD719X_SUE_WRONGWAY	0x13 /* Wrong data transfer dir set by target */
+#define WD719X_SUE_BADPHASE	0x14 /* SCSI phase illegal or unexpected */
+#define WD719X_SUE_TOOLONG	0x15 /* target requested too much data */
+#define WD719X_SUE_BUSFREE	0x16 /* Unexpected SCSI bus free */
+#define WD719X_SUE_ARSDONE	0x17 /* Auto request sense executed */
+#define WD719X_SUE_IGNORED	0x18 /* SCSI message was ignored by target */
+#define WD719X_SUE_WRONGTAGS	0x19 /* Tagged SCB & tags off (or vice versa) */
+#define WD719X_SUE_BADTAGS	0x1a /* Wrong tag message type for target */
+#define WD719X_SUE_NOSCAMID	0x1b /* No SCAM soft ID available */
+
+/* code sizes */
+#define	WD719X_HASH_TABLE_SIZE	4096
+
+/* Advanced Mode Registers */
+/* Regs 0x00..0x1f are for Advanced Mode of the card (RISC is running). */
+#define WD719X_AMR_COMMAND		0x00
+#define WD719X_AMR_CMD_PARAM		0x01
+#define WD719X_AMR_CMD_PARAM_2		0x02
+#define WD719X_AMR_CMD_PARAM_3		0x03
+#define WD719X_AMR_SCB_IN		0x04
+
+#define WD719X_AMR_BIOS_SHARE_INT	0x0f
+
+#define WD719X_AMR_SCB_OUT		0x18
+#define WD719X_AMR_OP_CODE		0x1c
+#define WD719X_AMR_SCSI_STATUS		0x1d
+#define WD719X_AMR_SCB_ERROR		0x1e
+#define WD719X_AMR_INT_STATUS		0x1f
+
+#define WD719X_DISABLE_INT	0x80
+
+/* SCB flags */
+#define WD719X_SCB_FLAGS_CHECK_DIRECTION	0x01
+#define WD719X_SCB_FLAGS_PCI_TO_SCSI		0x02
+#define WD719X_SCB_FLAGS_AUTO_REQUEST_SENSE	0x10
+#define WD719X_SCB_FLAGS_DO_SCATTER_GATHER	0x20
+#define WD719X_SCB_FLAGS_NO_DISCONNECT		0x40
+
+/* PCI Registers used for reset, initial code download */
+/* Regs 0x20..0x3f are for Normal (DOS) mode (RISC is asleep). */
+#define WD719X_PCI_GPIO_CONTROL		0x3C
+#define WD719X_PCI_GPIO_DATA		0x3D
+#define WD719X_PCI_PORT_RESET		0x3E
+#define WD719X_PCI_MODE_SELECT		0x3F
+
+#define WD719X_PCI_EXTERNAL_ADDR	0x60
+#define WD719X_PCI_INTERNAL_ADDR	0x64
+#define WD719X_PCI_DMA_TRANSFER_SIZE	0x66
+#define WD719X_PCI_CHANNEL2_3CMD	0x68
+#define WD719X_PCI_CHANNEL2_3STATUS	0x69
+
+#define WD719X_GPIO_ID_BITS		0x0a
+#define WD719X_PRAM_BASE_ADDR		0x00
+
+/* codes written to or read from the card */
+#define WD719X_PCI_RESET		 0x01
+#define WD719X_ENABLE_ADVANCE_MODE	 0x01
+
+#define WD719X_START_CHANNEL2_3DMA	 0x17
+#define WD719X_START_CHANNEL2_3DONE	 0x01
+#define WD719X_START_CHANNEL2_3ABORT	 0x20
+
+/* 33C296 GPIO bits for EEPROM pins */
+#define WD719X_EE_DI	(1 << 1)
+#define WD719X_EE_CS	(1 << 2)
+#define WD719X_EE_CLK	(1 << 3)
+#define WD719X_EE_DO	(1 << 4)
+
+/* EEPROM contents */
+struct wd719x_eeprom_header {
+	u8 sig1;
+	u8 sig2;
+	u8 version;
+	u8 checksum;
+	u8 cfg_offset;
+	u8 cfg_size;
+	u8 setup_offset;
+	u8 setup_size;
+} __packed;
+
+#define WD719X_EE_SIG1		0
+#define WD719X_EE_SIG2		1
+#define WD719X_EE_VERSION	2
+#define WD719X_EE_CHECKSUM	3
+#define WD719X_EE_CFG_OFFSET	4
+#define WD719X_EE_CFG_SIZE	5
+#define WD719X_EE_SETUP_OFFSET	6
+#define WD719X_EE_SETUP_SIZE	7
+
+#define WD719X_EE_SCSI_ID_MASK	0xf
+
+/* SPIDER Host Parameters Block (=EEPROM configuration block) */
+struct wd719x_host_param {
+	u8 ch_1_th;	/* FIFO threshold */
+	u8 scsi_conf;	/* SCSI configuration */
+	u8 own_scsi_id;	/* controller SCSI ID */
+	u8 sel_timeout;	/* selection timeout*/
+	u8 sleep_timer;	/* seep timer */
+	__le16 cdb_size;/* CDB size groups */
+	__le16 tag_en;	/* Tag msg enables (ID 0-15) */
+	u8 scsi_pad;	/* SCSI pad control */
+	__le32 wide;	/* WIDE msg options (ID 0-15) */
+	__le32 sync;	/* SYNC msg options (ID 0-15) */
+	u8 soft_mask;	/* soft error mask */
+	u8 unsol_mask;	/* unsolicited error mask */
+} __packed;
+
+#endif /* _WD719X_H_ */
-- 
Ondrej Zary
