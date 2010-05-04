From: giridhar.malavali@qlogic.com
Subject: [PATCH 14/16] qla2xxx: Updates to ISP82xx support.
Date: Tue,  4 May 2010 15:01:34 -0700
Message-ID: <1273010496-43045-15-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47179 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760239Ab0EDWBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:41 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

1) Allow transition to NEED RESET state only from READY state for ISP82xx.
2) Avoid infinite ISP aborts when chip reset fails.
3) Code cleanup to remove some of the unused debug code.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Santosh Vernekar <santosh.vernekar@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    2 -
 drivers/scsi/qla2xxx/qla_init.c |   33 ------
 drivers/scsi/qla2xxx/qla_nx.c   |  205 ++++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_nx.h   |   15 ++--
 4 files changed, 111 insertions(+), 144 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 4559f5c..8396109 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2764,8 +2764,6 @@ struct qla_hw_data {
 	unsigned long	nx_pcibase;		/* Base I/O address */
 	uint8_t		*nxdb_rd_ptr;		/* Doorbell read pointer */
 	unsigned long	nxdb_wr_ptr;		/* Door bell write pointer */
-	unsigned long	first_page_group_start;
-	unsigned long	first_page_group_end;
 
 	uint32_t	crb_win;
 	uint32_t	curr_window;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7fd1344..ab2cc71 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5296,39 +5296,6 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
 				    "(%d).\n", rval);
 			}
 		}
-	} else {	/* failed the ISP abort */
-		vha->flags.online = 1;
-		if (test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
-			if (ha->isp_abort_cnt == 0) {
-				qla_printk(KERN_WARNING, ha,
-				    "ISP error recovery failed - "
-				    "board disabled\n");
-				/*
-				 * The next call disables the board
-				 * completely.
-				 */
-				ha->isp_ops->reset_adapter(vha);
-				vha->flags.online = 0;
-				clear_bit(ISP_ABORT_RETRY,
-					&vha->dpc_flags);
-				status = 0;
-			} else { /* schedule another ISP abort */
-				ha->isp_abort_cnt--;
-				qla_printk(KERN_INFO, ha,
-					"qla%ld: ISP abort - "
-					"retry remaining %d\n",
-					vha->host_no, ha->isp_abort_cnt);
-				status = 1;
-			}
-		} else {
-			ha->isp_abort_cnt = MAX_RETRIES_OF_ISP_ABORT;
-			qla_printk(KERN_INFO, ha,
-				"(%ld): ISP error recovery "
-				"- retrying (%d) more times\n",
-				vha->host_no, ha->isp_abort_cnt);
-			set_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
-			status = 1;
-		}
 	}
 
 	if (!status) {
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 495ff1a..ff562de 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -30,16 +30,6 @@
 #define QLA82XX_PCI_CAMQM_2M_BASE	(0x000ff800UL)
 #define CRB_INDIRECT_2M	(0x1e0000UL)
 
-static inline void *qla82xx_pci_base_offsetfset(struct qla_hw_data *ha,
-    unsigned long off)
-{
-	if ((off < ha->first_page_group_end) &&
-	    (off >= ha->first_page_group_start))
-		return (void *)(ha->nx_pcibase + off);
-
-	return NULL;
-}
-
 #define MAX_CRB_XFORM 60
 static unsigned long crb_addr_xform[MAX_CRB_XFORM];
 int qla82xx_crb_table_initialized;
@@ -335,6 +325,18 @@ unsigned qla82xx_crb_hub_agt[64] = {
 	0,
 };
 
+/* Device states */
+char *qdev_state[] = {
+	 "Unknown",
+	"Cold",
+	"Initializing",
+	"Ready",
+	"Need Reset",
+	"Need Quiescent",
+	"Failed",
+	"Quiescent",
+};
+
 /*
  * In: 'off' is offset from CRB space in 128M pci map
  * Out: 'off' is 2M pci map addr
@@ -661,7 +663,7 @@ static int qla82xx_pci_mem_read_direct(struct qla_hw_data *ha,
 	u64 off, void *data, int size)
 {
 	unsigned long   flags;
-	void           *addr;
+	void           *addr = NULL;
 	int             ret = 0;
 	u64             start;
 	uint8_t         *mem_ptr = NULL;
@@ -684,26 +686,23 @@ static int qla82xx_pci_mem_read_direct(struct qla_hw_data *ha,
 		return -1;
 	}
 
-	addr = qla82xx_pci_base_offsetfset(ha, start);
-	if (!addr) {
-		write_unlock_irqrestore(&ha->hw_lock, flags);
-		mem_base = pci_resource_start(ha->pdev, 0);
-		mem_page = start & PAGE_MASK;
-		/* Map two pages whenever user tries to access addresses in two
-		* consecutive pages.
-		*/
-		if (mem_page != ((start + size - 1) & PAGE_MASK))
-			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE * 2);
-		else
-			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
-		if (mem_ptr == 0UL) {
-			*(u8  *)data = 0;
-			return -1;
-		}
-		addr = mem_ptr;
-		addr += start & (PAGE_SIZE - 1);
-		write_lock_irqsave(&ha->hw_lock, flags);
+	write_unlock_irqrestore(&ha->hw_lock, flags);
+	mem_base = pci_resource_start(ha->pdev, 0);
+	mem_page = start & PAGE_MASK;
+	/* Map two pages whenever user tries to access addresses in two
+	* consecutive pages.
+	*/
+	if (mem_page != ((start + size - 1) & PAGE_MASK))
+		mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE * 2);
+	else
+		mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
+	if (mem_ptr == 0UL) {
+		*(u8  *)data = 0;
+		return -1;
 	}
+	addr = mem_ptr;
+	addr += start & (PAGE_SIZE - 1);
+	write_lock_irqsave(&ha->hw_lock, flags);
 
 	switch (size) {
 	case 1:
@@ -734,7 +733,7 @@ qla82xx_pci_mem_write_direct(struct qla_hw_data *ha,
 	u64 off, void *data, int size)
 {
 	unsigned long   flags;
-	void           *addr;
+	void           *addr = NULL;
 	int             ret = 0;
 	u64             start;
 	uint8_t         *mem_ptr = NULL;
@@ -757,25 +756,22 @@ qla82xx_pci_mem_write_direct(struct qla_hw_data *ha,
 		return -1;
 	}
 
-	addr = qla82xx_pci_base_offsetfset(ha, start);
-	if (!addr) {
-		write_unlock_irqrestore(&ha->hw_lock, flags);
-		mem_base = pci_resource_start(ha->pdev, 0);
-		mem_page = start & PAGE_MASK;
-		/* Map two pages whenever user tries to access addresses in two
-		 * consecutive pages.
-		 */
-		if (mem_page != ((start + size - 1) & PAGE_MASK))
-			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE*2);
-		else
-			mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
-		if (mem_ptr == 0UL)
-			return -1;
+	write_unlock_irqrestore(&ha->hw_lock, flags);
+	mem_base = pci_resource_start(ha->pdev, 0);
+	mem_page = start & PAGE_MASK;
+	/* Map two pages whenever user tries to access addresses in two
+	 * consecutive pages.
+	 */
+	if (mem_page != ((start + size - 1) & PAGE_MASK))
+		mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE*2);
+	else
+		mem_ptr = ioremap(mem_base + mem_page, PAGE_SIZE);
+	if (mem_ptr == 0UL)
+		return -1;
 
-		addr = mem_ptr;
-		addr += start & (PAGE_SIZE - 1);
-		write_lock_irqsave(&ha->hw_lock, flags);
-	}
+	addr = mem_ptr;
+	addr += start & (PAGE_SIZE - 1);
+	write_lock_irqsave(&ha->hw_lock, flags);
 
 	switch (size) {
 	case 1:
@@ -1866,6 +1862,14 @@ void qla82xx_config_rings(struct scsi_qla_host *vha)
 	WRT_REG_DWORD((unsigned long  __iomem *)&reg->rsp_q_out[0], 0);
 }
 
+void qla82xx_reset_adapter(struct scsi_qla_host *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	vha->flags.online = 0;
+	qla2x00_try_to_stop_firmware(vha);
+	ha->isp_ops->disable_intrs(ha);
+}
+
 int qla82xx_fw_load_from_blob(struct qla_hw_data *ha)
 {
 	u64 *ptr64;
@@ -2093,15 +2097,7 @@ qla82xx_intr_handler(int irq, void *dev_id)
 
 		if (RD_REG_DWORD(&reg->host_int)) {
 			stat = RD_REG_DWORD(&reg->host_status);
-			if (stat & HSRX_RISC_PAUSED) {
-				if (pci_channel_offline(ha->pdev))
-					break;
-
-				qla_printk(KERN_INFO, ha, "RISC paused\n");
-				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-				qla2xxx_wake_dpc(vha);
-				break;
-			} else if ((stat & HSRX_RISC_INT) == 0)
+			if ((stat & HSRX_RISC_INT) == 0)
 				break;
 
 			switch (stat & 0xff) {
@@ -2177,15 +2173,7 @@ qla82xx_msix_default(int irq, void *dev_id)
 	do {
 		if (RD_REG_DWORD(&reg->host_int)) {
 			stat = RD_REG_DWORD(&reg->host_status);
-			if (stat & HSRX_RISC_PAUSED) {
-				if (pci_channel_offline(ha->pdev))
-					break;
-
-				qla_printk(KERN_INFO, ha, "RISC paused\n");
-				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-				qla2xxx_wake_dpc(vha);
-				break;
-			} else if ((stat & HSRX_RISC_INT) == 0)
+			if ((stat & HSRX_RISC_INT) == 0)
 				break;
 
 			switch (stat & 0xff) {
@@ -3348,6 +3336,9 @@ qla82xx_need_reset_handler(scsi_qla_host_t *vha)
 	}
 
 	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+	qla_printk(KERN_INFO, ha, "3:Device state is 0x%x = %s\n", dev_state,
+		dev_state < MAX_STATES ? qdev_state[dev_state] : "Unknown");
+
 	/* Force to DEV_COLD unless someone else is starting a reset */
 	if (dev_state != QLA82XX_DEV_INITIALIZING) {
 		qla_printk(KERN_INFO, ha, "HW State: COLD/RE-INIT\n");
@@ -3398,7 +3389,6 @@ int
 qla82xx_device_state_handler(scsi_qla_host_t *vha)
 {
 	uint32_t dev_state;
-	uint32_t drv_active;
 	int rval = QLA_SUCCESS;
 	unsigned long dev_init_timeout;
 	struct qla_hw_data *ha = vha->hw;
@@ -3407,38 +3397,9 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 	if (!vha->flags.init_done)
 		qla82xx_set_drv_active(vha);
 
-	/* Set cold state*/
-	if (!PCI_FUNC(ha->pdev->devfn & 1)) {
-
-		/* Check if other functions alive, else set dev state
-		 * to cold
-		 */
-		drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
-		drv_active &= ~(1 << (ha->portnum * 4));
-		drv_active &= ~(1 << ((ha->portnum + 1) * 4));
-
-		dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
-		if (!drv_active) {
-
-			switch (dev_state) {
-			case QLA82XX_DEV_COLD:
-			case QLA82XX_DEV_READY:
-			case QLA82XX_DEV_INITIALIZING:
-			case QLA82XX_DEV_NEED_RESET:
-			case QLA82XX_DEV_NEED_QUIESCENT:
-			case QLA82XX_DEV_QUIESCENT:
-			case QLA82XX_DEV_FAILED:
-				break;
-			default:
-				qla_printk(KERN_INFO, ha,
-					"No other function exist,"
-					" resetting dev state to COLD\n");
-				qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
-					QLA82XX_DEV_COLD);
-				break;
-			}
-		}
-	}
+	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+	qla_printk(KERN_INFO, ha, "1:Device state is 0x%x = %s\n", dev_state,
+		dev_state < MAX_STATES ? qdev_state[dev_state] : "Unknown");
 
 	/* wait for 30 seconds for device to go ready */
 	dev_init_timeout = jiffies + (ha->nx_dev_init_timeout * HZ);
@@ -3453,6 +3414,11 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 			break;
 		}
 		dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+		qla_printk(KERN_INFO, ha,
+			"2:Device state is 0x%x = %s\n", dev_state,
+			dev_state < MAX_STATES ?
+			qdev_state[dev_state] : "Unknown");
+
 		switch (dev_state) {
 		case QLA82XX_DEV_READY:
 			goto exit;
@@ -3545,12 +3511,14 @@ qla82xx_abort_isp(scsi_qla_host_t *vha)
 
 	qla82xx_idc_lock(ha);
 	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
-	if (dev_state != QLA82XX_DEV_INITIALIZING) {
+	if (dev_state == QLA82XX_DEV_READY) {
 		qla_printk(KERN_INFO, ha, "HW State: NEED RESET\n");
 		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
 			QLA82XX_DEV_NEED_RESET);
 	} else
-		qla_printk(KERN_INFO, ha, "HW State: DEVICE INITIALIZING\n");
+		qla_printk(KERN_INFO, ha, "HW State: %s\n",
+			dev_state < MAX_STATES ?
+			qdev_state[dev_state] : "Unknown");
 	qla82xx_idc_unlock(ha);
 
 	rval = qla82xx_device_state_handler(vha);
@@ -3561,6 +3529,39 @@ qla82xx_abort_isp(scsi_qla_host_t *vha)
 
 	if (rval == QLA_SUCCESS)
 		qla82xx_restart_isp(vha);
+
+	if (rval) {
+		vha->flags.online = 1;
+		if (test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
+			if (ha->isp_abort_cnt == 0) {
+				qla_printk(KERN_WARNING, ha,
+				    "ISP error recovery failed - "
+				    "board disabled\n");
+				/*
+				 * The next call disables the board
+				 * completely.
+				 */
+				ha->isp_ops->reset_adapter(vha);
+				vha->flags.online = 0;
+				clear_bit(ISP_ABORT_RETRY,
+				    &vha->dpc_flags);
+				rval = QLA_SUCCESS;
+			} else { /* schedule another ISP abort */
+				ha->isp_abort_cnt--;
+				DEBUG(qla_printk(KERN_INFO, ha,
+				    "qla%ld: ISP abort - retry remaining %d\n",
+				    vha->host_no, ha->isp_abort_cnt));
+				rval = QLA_FUNCTION_FAILED;
+			}
+		} else {
+			ha->isp_abort_cnt = MAX_RETRIES_OF_ISP_ABORT;
+			DEBUG(qla_printk(KERN_INFO, ha,
+			    "(%ld): ISP error recovery - retrying (%d) "
+			    "more times\n", vha->host_no, ha->isp_abort_cnt));
+			set_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
+			rval = QLA_FUNCTION_FAILED;
+		}
+	}
 	return rval;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index 7804bbb..f8f99a5 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -545,13 +545,14 @@
 #define QLA82XX_CRB_DEV_PART_INFO    (QLA82XX_CAM_RAM(0x14c))
 
 /* Every driver should use these Device State */
-#define QLA82XX_DEV_COLD	    1
-#define QLA82XX_DEV_INITIALIZING    2
-#define QLA82XX_DEV_READY	    3
-#define QLA82XX_DEV_NEED_RESET	    4
-#define QLA82XX_DEV_NEED_QUIESCENT  5
-#define QLA82XX_DEV_FAILED	    6
-#define QLA82XX_DEV_QUIESCENT	    7
+#define QLA82XX_DEV_COLD		1
+#define QLA82XX_DEV_INITIALIZING	2
+#define QLA82XX_DEV_READY		3
+#define QLA82XX_DEV_NEED_RESET		4
+#define QLA82XX_DEV_NEED_QUIESCENT	5
+#define QLA82XX_DEV_FAILED		6
+#define QLA82XX_DEV_QUIESCENT		7
+#define	MAX_STATES			8 /* Increment if new state added */
 
 #define QLA82XX_IDC_VERSION			1
 #define QLA82XX_ROM_DEV_INIT_TIMEOUT		30
-- 
1.6.2.rc1.30.gd43c

