From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH 05/15] pm80xx: Multiple inbound/outbound queue
Date: Tue, 12 Feb 2013 04:31:19 -0800
Message-ID: <511A3617.6020100@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:54032 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932927Ab3BLMah (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 07:30:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

>From ea8e9d56a8f94fbf1963d9b56783a3f1cb743c1f Mon Sep 17 00:00:00 2001
From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
Date: Mon, 4 Feb 2013 16:31:43 +0530
Subject: [PATCH 05/15] pm80xx: Multiple inbound/outbound queue configuration

Memory allocation and configuration of multiple inbound and
outbound queues.

Signed-off-by: Sakthivel K <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_defs.h |   14 +++--
 drivers/scsi/pm8001/pm8001_hwi.c  |   43 ++++++++--------
 drivers/scsi/pm8001/pm8001_init.c |  101
+++++++++++++++++++++++++------------
 3 files changed, 98 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h
b/drivers/scsi/pm8001/pm8001_defs.h
index b25f87c..26a2ee6 100755
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -48,8 +48,7 @@ enum chip_flavors {
 	chip_8018,
 	chip_8019
 };
-#define USI_MAX_MEMCNT			9
-#define PM8001_MAX_DMA_SG		SG_ALL
+
 enum phy_speed {
 	PHY_SPEED_15 = 0x01,
 	PHY_SPEED_30 = 0x02,
@@ -87,13 +86,16 @@ enum port_type {
 #define	PM8001_MAX_DEVICES	 2048	/* max supported device */
 #define	PM8001_MAX_MSIX_VEC	 64	/* max msi-x int for spcv/ve */

+#define USI_MAX_MEMCNT_BASE	4
+#define IB			(USI_MAX_MEMCNT_BASE + 1)
+#define CI			(IB + PM8001_MAX_SPCV_INB_NUM)
+#define OB			(CI + PM8001_MAX_SPCV_INB_NUM)
+#define PI			(OB + PM8001_MAX_SPCV_OUTB_NUM)
+#define USI_MAX_MEMCNT		(PI + PM8001_MAX_SPCV_OUTB_NUM)
+#define PM8001_MAX_DMA_SG	SG_ALL
 enum memory_region_num {
 	AAP1 = 0x0, /* application acceleration processor */
 	IOP,	    /* IO processor */
-	CI,	    /* consumer index */
-	PI,	    /* producer index */
-	IB,	    /* inbound queue */
-	OB,	    /* outbound queue */
 	NVMD,	    /* NVM device */
 	DEV_MEM,    /* memory for devices */
 	CCB_MEM,    /* memory for command control block */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
index d04a613..651834c 100755
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -151,10 +151,9 @@ static void read_general_status_table(struct
pm8001_hba_info *pm8001_ha)
  */
 static void read_inbnd_queue_table(struct pm8001_hba_info *pm8001_ha)
 {
-	int inbQ_num = 1;
 	int i;
 	void __iomem *address = pm8001_ha->inbnd_q_tbl_addr;
-	for (i = 0; i < inbQ_num; i++) {
+	for (i = 0; i < PM8001_MAX_INB_NUM; i++) {
 		u32 offset = i * 0x20;
 		pm8001_ha->inbnd_q_tbl[i].pi_pci_bar =
 		      get_pci_bar_index(pm8001_mr32(address, (offset + 0x14)));
@@ -169,10 +168,9 @@ static void read_inbnd_queue_table(struct
pm8001_hba_info *pm8001_ha)
  */
 static void read_outbnd_queue_table(struct pm8001_hba_info *pm8001_ha)
 {
-	int outbQ_num = 1;
 	int i;
 	void __iomem *address = pm8001_ha->outbnd_q_tbl_addr;
-	for (i = 0; i < outbQ_num; i++) {
+	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++) {
 		u32 offset = i * 0x24;
 		pm8001_ha->outbnd_q_tbl[i].ci_pci_bar =
 		      get_pci_bar_index(pm8001_mr32(address, (offset + 0x14)));
@@ -225,19 +223,19 @@ static void init_default_table_values(struct
pm8001_hba_info *pm8001_ha)
 		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
 			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
 		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
-			pm8001_ha->memoryMap.region[IB].phys_addr_hi;
+			pm8001_ha->memoryMap.region[IB + i].phys_addr_hi;
 		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=
-		pm8001_ha->memoryMap.region[IB].phys_addr_lo;
+		pm8001_ha->memoryMap.region[IB + i].phys_addr_lo;
 		pm8001_ha->inbnd_q_tbl[i].base_virt		=
-			(u8 *)pm8001_ha->memoryMap.region[IB].virt_ptr;
+			(u8 *)pm8001_ha->memoryMap.region[IB + i].virt_ptr;
 		pm8001_ha->inbnd_q_tbl[i].total_length		=
-			pm8001_ha->memoryMap.region[IB].total_len;
+			pm8001_ha->memoryMap.region[IB + i].total_len;
 		pm8001_ha->inbnd_q_tbl[i].ci_upper_base_addr	=
-			pm8001_ha->memoryMap.region[CI].phys_addr_hi;
+			pm8001_ha->memoryMap.region[CI + i].phys_addr_hi;
 		pm8001_ha->inbnd_q_tbl[i].ci_lower_base_addr	=
-			pm8001_ha->memoryMap.region[CI].phys_addr_lo;
+			pm8001_ha->memoryMap.region[CI + i].phys_addr_lo;
 		pm8001_ha->inbnd_q_tbl[i].ci_virt		=
-			pm8001_ha->memoryMap.region[CI].virt_ptr;
+			pm8001_ha->memoryMap.region[CI + i].virt_ptr;
 		offsetib = i * 0x20;
 		pm8001_ha->inbnd_q_tbl[i].pi_pci_bar		=
 			get_pci_bar_index(pm8001_mr32(addressib,
@@ -251,21 +249,21 @@ static void init_default_table_values(struct
pm8001_hba_info *pm8001_ha)
 		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
 			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
 		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
-			pm8001_ha->memoryMap.region[OB].phys_addr_hi;
+			pm8001_ha->memoryMap.region[OB + i].phys_addr_hi;
 		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=
-			pm8001_ha->memoryMap.region[OB].phys_addr_lo;
+			pm8001_ha->memoryMap.region[OB + i].phys_addr_lo;
 		pm8001_ha->outbnd_q_tbl[i].base_virt		=
-			(u8 *)pm8001_ha->memoryMap.region[OB].virt_ptr;
+			(u8 *)pm8001_ha->memoryMap.region[OB + i].virt_ptr;
 		pm8001_ha->outbnd_q_tbl[i].total_length		=
-			pm8001_ha->memoryMap.region[OB].total_len;
+			pm8001_ha->memoryMap.region[OB + i].total_len;
 		pm8001_ha->outbnd_q_tbl[i].pi_upper_base_addr	=
-			pm8001_ha->memoryMap.region[PI].phys_addr_hi;
+			pm8001_ha->memoryMap.region[PI + i].phys_addr_hi;
 		pm8001_ha->outbnd_q_tbl[i].pi_lower_base_addr	=
-			pm8001_ha->memoryMap.region[PI].phys_addr_lo;
+			pm8001_ha->memoryMap.region[PI + i].phys_addr_lo;
 		pm8001_ha->outbnd_q_tbl[i].interrup_vec_cnt_delay	=
-			0 | (10 << 16) | (0 << 24);
+			0 | (10 << 16) | (i << 24);
 		pm8001_ha->outbnd_q_tbl[i].pi_virt		=
-			pm8001_ha->memoryMap.region[PI].virt_ptr;
+			pm8001_ha->memoryMap.region[PI + i].virt_ptr;
 		offsetob = i * 0x24;
 		pm8001_ha->outbnd_q_tbl[i].ci_pci_bar		=
 			get_pci_bar_index(pm8001_mr32(addressob,
@@ -641,6 +639,7 @@ static void init_pci_device_addresses(struct
pm8001_hba_info *pm8001_ha)
  */
 static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 {
+	u8 i = 0;
 	/* check the firmware status */
 	if (-1 == check_fw_ready(pm8001_ha)) {
 		PM8001_FAIL_DBG(pm8001_ha,
@@ -657,8 +656,10 @@ static int pm8001_chip_init(struct pm8001_hba_info
*pm8001_ha)
 	read_outbnd_queue_table(pm8001_ha);
 	/* update main config table ,inbound table and outbound table */
 	update_main_config_table(pm8001_ha);
-	update_inbnd_queue_table(pm8001_ha, 0);
-	update_outbnd_queue_table(pm8001_ha, 0);
+	for (i = 0; i < PM8001_MAX_INB_NUM; i++)
+		update_inbnd_queue_table(pm8001_ha, i);
+	for (i = 0; i < PM8001_MAX_OUTB_NUM; i++)
+		update_outbnd_queue_table(pm8001_ha, i);
 	mpi_set_phys_g3_with_ssc(pm8001_ha, 0);
 	/* 7->130ms, 34->500ms, 119->1.5s */
 	mpi_set_open_retry_interval_reg(pm8001_ha, 119);
diff --git a/drivers/scsi/pm8001/pm8001_init.c
b/drivers/scsi/pm8001/pm8001_init.c
index 5ce8330..9ca1029 100755
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -203,10 +203,14 @@ static irqreturn_t pm8001_interrupt(int irq, void
*opaque)
  * @pm8001_ha:our hba structure.
  *
  */
-static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha)
+static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
+			const struct pci_device_id *ent)
 {
 	int i;
 	spin_lock_init(&pm8001_ha->lock);
+	PM8001_INIT_DBG(pm8001_ha,
+		pm8001_printk("pm8001_alloc: PHY:%x\n",
+				pm8001_ha->chip->n_phy));
 	for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
 		pm8001_phy_init(pm8001_ha, i);
 		pm8001_ha->port[i].wide_port_phymap = 0;
@@ -230,30 +234,57 @@ static int pm8001_alloc(struct pm8001_hba_info
*pm8001_ha)
 	pm8001_ha->memoryMap.region[IOP].total_len = PM8001_EVENT_LOG_SIZE;
 	pm8001_ha->memoryMap.region[IOP].alignment = 32;

-	/* MPI Memory region 3 for consumer Index of inbound queues */
-	pm8001_ha->memoryMap.region[CI].num_elements = 1;
-	pm8001_ha->memoryMap.region[CI].element_size = 4;
-	pm8001_ha->memoryMap.region[CI].total_len = 4;
-	pm8001_ha->memoryMap.region[CI].alignment = 4;
-
-	/* MPI Memory region 4 for producer Index of outbound queues */
-	pm8001_ha->memoryMap.region[PI].num_elements = 1;
-	pm8001_ha->memoryMap.region[PI].element_size = 4;
-	pm8001_ha->memoryMap.region[PI].total_len = 4;
-	pm8001_ha->memoryMap.region[PI].alignment = 4;
-
-	/* MPI Memory region 5 inbound queues */
-	pm8001_ha->memoryMap.region[IB].num_elements = PM8001_MPI_QUEUE;
-	pm8001_ha->memoryMap.region[IB].element_size = 64;
-	pm8001_ha->memoryMap.region[IB].total_len = PM8001_MPI_QUEUE * 64;
-	pm8001_ha->memoryMap.region[IB].alignment = 64;
-
-	/* MPI Memory region 6 outbound queues */
-	pm8001_ha->memoryMap.region[OB].num_elements = PM8001_MPI_QUEUE;
-	pm8001_ha->memoryMap.region[OB].element_size = 64;
-	pm8001_ha->memoryMap.region[OB].total_len = PM8001_MPI_QUEUE * 64;
-	pm8001_ha->memoryMap.region[OB].alignment = 64;
+	for (i = 0; i < PM8001_MAX_SPCV_INB_NUM; i++) {
+		/* MPI Memory region 3 for consumer Index of inbound queues */
+		pm8001_ha->memoryMap.region[CI+i].num_elements = 1;
+		pm8001_ha->memoryMap.region[CI+i].element_size = 4;
+		pm8001_ha->memoryMap.region[CI+i].total_len = 4;
+		pm8001_ha->memoryMap.region[CI+i].alignment = 4;
+
+		if ((ent->driver_data) != chip_8001) {
+			/* MPI Memory region 5 inbound queues */
+			pm8001_ha->memoryMap.region[IB+i].num_elements =
+						PM8001_MPI_QUEUE;
+			pm8001_ha->memoryMap.region[IB+i].element_size = 128;
+			pm8001_ha->memoryMap.region[IB+i].total_len =
+						PM8001_MPI_QUEUE * 128;
+			pm8001_ha->memoryMap.region[IB+i].alignment = 128;
+		} else {
+			pm8001_ha->memoryMap.region[IB+i].num_elements =
+						PM8001_MPI_QUEUE;
+			pm8001_ha->memoryMap.region[IB+i].element_size = 64;
+			pm8001_ha->memoryMap.region[IB+i].total_len =
+						PM8001_MPI_QUEUE * 64;
+			pm8001_ha->memoryMap.region[IB+i].alignment = 64;
+		}
+	}
+
+	for (i = 0; i < PM8001_MAX_SPCV_OUTB_NUM; i++) {
+		/* MPI Memory region 4 for producer Index of outbound queues */
+		pm8001_ha->memoryMap.region[PI+i].num_elements = 1;
+		pm8001_ha->memoryMap.region[PI+i].element_size = 4;
+		pm8001_ha->memoryMap.region[PI+i].total_len = 4;
+		pm8001_ha->memoryMap.region[PI+i].alignment = 4;
+
+		if (ent->driver_data != chip_8001) {
+			/* MPI Memory region 6 Outbound queues */
+			pm8001_ha->memoryMap.region[OB+i].num_elements =
+						PM8001_MPI_QUEUE;
+			pm8001_ha->memoryMap.region[OB+i].element_size = 128;
+			pm8001_ha->memoryMap.region[OB+i].total_len =
+						PM8001_MPI_QUEUE * 128;
+			pm8001_ha->memoryMap.region[OB+i].alignment = 128;
+		} else {
+			/* MPI Memory region 6 Outbound queues */
+			pm8001_ha->memoryMap.region[OB+i].num_elements =
+						PM8001_MPI_QUEUE;
+			pm8001_ha->memoryMap.region[OB+i].element_size = 64;
+			pm8001_ha->memoryMap.region[OB+i].total_len =
+						PM8001_MPI_QUEUE * 64;
+			pm8001_ha->memoryMap.region[OB+i].alignment = 64;
+		}

+	}
 	/* Memory region write DMA*/
 	pm8001_ha->memoryMap.region[NVMD].num_elements = 1;
 	pm8001_ha->memoryMap.region[NVMD].element_size = 4096;
@@ -347,10 +378,12 @@ static int pm8001_ioremap(struct pm8001_hba_info
*pm8001_ha)
 				ioremap(pm8001_ha->io_mem[logicalBar].membase,
 				pm8001_ha->io_mem[logicalBar].memsize);
 			PM8001_INIT_DBG(pm8001_ha,
-				pm8001_printk("PCI: bar %d, logicalBar %d "
-				"virt_addr=%lx,len=%d\n", bar, logicalBar,
-				(unsigned long)
-				pm8001_ha->io_mem[logicalBar].memvirtaddr,
+				pm8001_printk("PCI: bar %d, logicalBar %d ",
+				bar, logicalBar));
+			PM8001_INIT_DBG(pm8001_ha, pm8001_printk(
+				"base addr %llx virt_addr=%llx len=%d\n",
+				(u64)pm8001_ha->io_mem[logicalBar].membase,
+				(u64)pm8001_ha->io_mem[logicalBar].memvirtaddr,
 				pm8001_ha->io_mem[logicalBar].memsize));
 		} else {
 			pm8001_ha->io_mem[logicalBar].membase	= 0;
@@ -369,8 +402,9 @@ static int pm8001_ioremap(struct pm8001_hba_info
*pm8001_ha)
  * @shost: scsi host struct which has been initialized before.
  */
 static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
-						u32 chip_id,
-						struct Scsi_Host *shost)
+				 const struct pci_device_id *ent,
+				struct Scsi_Host *shost)
+
 {
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
@@ -382,7 +416,7 @@ static struct pm8001_hba_info
*pm8001_pci_alloc(struct pci_dev *pdev,

 	pm8001_ha->pdev = pdev;
 	pm8001_ha->dev = &pdev->dev;
-	pm8001_ha->chip_id = chip_id;
+	pm8001_ha->chip_id = ent->driver_data;
 	pm8001_ha->chip = &pm8001_chips[pm8001_ha->chip_id];
 	pm8001_ha->irq = pdev->irq;
 	pm8001_ha->sas = sha;
@@ -395,7 +429,7 @@ static struct pm8001_hba_info
*pm8001_pci_alloc(struct pci_dev *pdev,
 		(unsigned long)pm8001_ha);
 #endif
 	pm8001_ioremap(pm8001_ha);
-	if (!pm8001_alloc(pm8001_ha))
+	if (!pm8001_alloc(pm8001_ha, ent))
 		return pm8001_ha;
 	pm8001_free(pm8001_ha);
 	return NULL;
@@ -673,7 +707,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		goto err_out_free;
 	}
 	pci_set_drvdata(pdev, SHOST_TO_SAS_HA(shost));
-	pm8001_ha = pm8001_pci_alloc(pdev, chip_8001, shost);
+	/* ent->driver variable is used to differentiate between controllers */
+	pm8001_ha = pm8001_pci_alloc(pdev, ent, shost);
 	if (!pm8001_ha) {
 		rc = -ENOMEM;
 		goto err_out_free;
-- 
1.7.1

