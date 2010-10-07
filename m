From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 10/15] qla4xxx: CRB Register for Request Queue in-pointer
Date: Wed, 6 Oct 2010 22:50:29 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8712940678D@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37590 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab0JGFub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:50:31 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Shyam Sundar <shyam.sundar@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Shyam Sundar <shyam.sundar@qlogic.com>

Switching from doorbell mechanism to CRB register based

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Shyam Sundar <shyam.sundar@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_fw.h   |    1 +
 drivers/scsi/qla4xxx/ql4_iocb.c |   10 +---------
 drivers/scsi/qla4xxx/ql4_mbx.c  |    9 +++++++++
 drivers/scsi/qla4xxx/ql4_nx.h   |    2 ++
 drivers/scsi/qla4xxx/ql4_os.c   |   24 +++---------------------
 5 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index d65dac4..5e757d7 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -448,6 +448,7 @@ struct addr_ctrl_blk {
 #define	 FWOPT_SESSION_MODE		  0x0040
 #define	 FWOPT_INITIATOR_MODE		  0x0020
 #define	 FWOPT_TARGET_MODE		  0x0010
+#define	 FWOPT_ENABLE_CRBDB		  0x8000
 
 	uint16_t exec_throttle;	/* 04-05 */
 	uint8_t zio_count;	/* 06 */
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index 4ef9ba1..5ae49fd 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -202,19 +202,11 @@ static void qla4xxx_build_scsi_iocbs(struct srb *srb,
 void qla4_8xxx_queue_iocb(struct scsi_qla_host *ha)
 {
 	uint32_t dbval = 0;
-	unsigned long wtime;
 
 	dbval = 0x14 | (ha->func_num << 5);
 	dbval = dbval | (0 << 8) | (ha->request_in << 16);
-	writel(dbval, (unsigned long __iomem *)ha->nx_db_wr_ptr);
-	wmb();
 
-	wtime = jiffies + (2 * HZ);
-	while (readl((void __iomem *)ha->nx_db_rd_ptr) != dbval &&
-	    !time_after_eq(jiffies, wtime)) {
-		writel(dbval, (unsigned long __iomem *)ha->nx_db_wr_ptr);
-		wmb();
-	}
+	qla4_8xxx_wr_32(ha, ha->nx_db_wr_ptr, ha->request_in);
 }
 
 /**
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 494a28f..2d2f9c8 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -299,6 +299,10 @@ qla4xxx_set_ifcb(struct scsi_qla_host *ha, uint32_t *mbox_cmd,
 {
 	memset(mbox_cmd, 0, sizeof(mbox_cmd[0]) * MBOX_REG_COUNT);
 	memset(mbox_sts, 0, sizeof(mbox_sts[0]) * MBOX_REG_COUNT);
+
+	if (is_qla8022(ha))
+		qla4_8xxx_wr_32(ha, ha->nx_db_wr_ptr, 0);
+
 	mbox_cmd[0] = MBOX_CMD_INITIALIZE_FIRMWARE;
 	mbox_cmd[1] = 0;
 	mbox_cmd[2] = LSDW(init_fw_cb_dma);
@@ -472,6 +476,11 @@ int qla4xxx_initialize_fw_cb(struct scsi_qla_host * ha)
 	init_fw_cb->fw_options |=
 		__constant_cpu_to_le16(FWOPT_SESSION_MODE |
 				       FWOPT_INITIATOR_MODE);
+
+	if (is_qla8022(ha))
+		init_fw_cb->fw_options |=
+		    __constant_cpu_to_le16(FWOPT_ENABLE_CRBDB);
+
 	init_fw_cb->fw_options &= __constant_cpu_to_le16(~FWOPT_TARGET_MODE);
 
 	if (qla4xxx_set_ifcb(ha, &mbox_cmd[0], &mbox_sts[0], init_fw_cb_dma)
diff --git a/drivers/scsi/qla4xxx/ql4_nx.h b/drivers/scsi/qla4xxx/ql4_nx.h
index 85fe6cf..429df5e 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.h
+++ b/drivers/scsi/qla4xxx/ql4_nx.h
@@ -535,6 +535,8 @@
 #define QLA82XX_PEG_HALT_STATUS1	(QLA82XX_CAM_RAM(0xa8))
 #define QLA82XX_PEG_HALT_STATUS2	(QLA82XX_CAM_RAM(0xac))
 #define QLA82XX_PEG_ALIVE_COUNTER	(QLA82XX_CAM_RAM(0xb0))
+#define QLA82XX_CAM_RAM_DB1		(QLA82XX_CAM_RAM(0x1b0))
+#define QLA82XX_CAM_RAM_DB2		(QLA82XX_CAM_RAM(0x1b4))
 
 #define HALT_STATUS_UNRECOVERABLE	0x80000000
 #define HALT_STATUS_RECOVERABLE		0x40000000
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 57890b6..779745f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -571,10 +571,6 @@ static void qla4xxx_mem_free(struct scsi_qla_host *ha)
 		if (ha->nx_pcibase)
 			iounmap(
 			    (struct device_reg_82xx __iomem *)ha->nx_pcibase);
-
-		if (ha->nx_db_wr_ptr)
-			iounmap(
-			    (struct device_reg_82xx __iomem *)ha->nx_db_wr_ptr);
 	} else if (ha->reg)
 		iounmap(ha->reg);
 	pci_release_regions(ha->pdev);
@@ -1476,24 +1472,10 @@ int qla4_8xxx_iospace_config(struct scsi_qla_host *ha)
 	db_base = pci_resource_start(pdev, 4);  /* doorbell is on bar 4 */
 	db_len = pci_resource_len(pdev, 4);
 
-	/* mapping of doorbell write pointer */
-	ha->nx_db_wr_ptr = (unsigned long)ioremap(db_base +
-	    (ha->pdev->devfn << 12), 4);
-	if (!ha->nx_db_wr_ptr) {
-		printk(KERN_ERR
-		    "cannot remap MMIO doorbell-write (%s), aborting\n",
-		    pci_name(pdev));
-		goto iospace_error_exit;
-	}
-	/* mapping of doorbell read pointer */
-	ha->nx_db_rd_ptr = (uint8_t *) ha->nx_pcibase + (512 * 1024) +
-	    (ha->pdev->devfn * 8);
-	if (!ha->nx_db_rd_ptr)
-		printk(KERN_ERR
-		    "cannot remap MMIO doorbell-read (%s), aborting\n",
-		    pci_name(pdev));
-	return 0;
+	ha->nx_db_wr_ptr = (ha->pdev->devfn == 4 ? QLA82XX_CAM_RAM_DB1 :
+	    QLA82XX_CAM_RAM_DB2);
 
+	return 0;
 iospace_error_exit:
 	return -ENOMEM;
 }
-- 
1.6.6

