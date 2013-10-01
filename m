From: Anand <anandkumar_santhanam@pmc-sierra.com>
Subject: [PATCH V3 05/10] pm80xx: Queue rotation logic for inbound and outbound
 queues.
Date: Mon, 30 Sep 2013 23:39:03 -0700
Message-ID: <524A6E07.3050009@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:52387 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750871Ab3JAGgb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Oct 2013 02:36:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, Sangeetha.Gnanasekaran@pmcs.com, Nikith.Ganigarakoppal@pmcs.com, Viswas.G@pmcs.com

>From ca5f0407967ca6f927da267dc941c2247c5fe341 Mon Sep 17 00:00:00 2001
From: Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>
Date: Wed, 18 Sep 2013 11:12:59 +0530
Subject: [PATCH V3 05/10] pm80xx: Queue rotation logic for inbound and outbound queues.

Signed-off-by: Anandkumar.Santhanam@pmcs.com
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8bac5ae..fa06f24 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3612,8 +3612,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	int ret;
 	u64 phys_addr;
 	struct inbound_queue_table *circularQ;
-	static u32 inb;
-	static u32 outb;
+	u32 q_index;
 	u32 opc = OPC_INB_SSPINIIOSTART;
 	memset(&ssp_cmd, 0, sizeof(ssp_cmd));
 	memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8);
@@ -3632,7 +3631,8 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_attr & 7);
 	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
 		       task->ssp_task.cmd->cmd_len);
-	circularQ = &pm8001_ha->inbnd_q_tbl[0];
+	q_index = (u32) (pm8001_dev->id & 0x00ffffff) % PM8001_MAX_INB_NUM;
+	circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
 
 	/* Check if encryption is set */
 	if (pm8001_ha->chip->encrypt &&
@@ -3680,7 +3680,7 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	} else {
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
 			"Sending Normal SAS command 0x%x inb q %x\n",
-			task->ssp_task.cmd->cmnd[0], inb));
+			task->ssp_task.cmd->cmnd[0], q_index));
 		/* fill in PRD (scatter/gather) table, if any */
 		if (task->num_scatter > 1) {
 			pm8001_chip_make_sg(task->scatter, ccb->n_elem,
@@ -3706,11 +3706,9 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 			ssp_cmd.esgl = 0;
 		}
 	}
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &ssp_cmd, outb++);
-
-	/* rotate the outb queue */
-	outb = outb%PM8001_MAX_SPCV_OUTB_NUM;
-
+	q_index = (u32) (pm8001_dev->id & 0x00ffffff) % PM8001_MAX_OUTB_NUM;
+	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
+						&ssp_cmd, q_index);
 	return ret;
 }
 
@@ -3722,8 +3720,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	struct pm8001_device *pm8001_ha_dev = dev->lldd_dev;
 	u32 tag = ccb->ccb_tag;
 	int ret;
-	static u32 inb;
-	static u32 outb;
+	u32 q_index;
 	struct sata_start_req sata_cmd;
 	u32 hdr_tag, ncg_tag = 0;
 	u64 phys_addr;
@@ -3733,7 +3730,8 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	unsigned long flags;
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
-	circularQ = &pm8001_ha->inbnd_q_tbl[0];
+	q_index = (u32) (pm8001_ha_dev->id & 0x00ffffff) % PM8001_MAX_INB_NUM;
+	circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
 
 	if (task->data_dir == PCI_DMA_NONE) {
 		ATAP = 0x04; /* no data*/
@@ -3814,7 +3812,7 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	} else {
 		PM8001_IO_DBG(pm8001_ha, pm8001_printk(
 			"Sending Normal SATA command 0x%x inb %x\n",
-			sata_cmd.sata_fis.command, inb));
+			sata_cmd.sata_fis.command, q_index));
 		/* dad (bit 0-1) is 0 */
 		sata_cmd.ncqtag_atap_dir_m_dad =
 			cpu_to_le32(((ncg_tag & 0xff)<<16) |
@@ -3911,12 +3909,9 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 			}
 		}
 	}
-
+	q_index = (u32) (pm8001_ha_dev->id & 0x00ffffff) % PM8001_MAX_OUTB_NUM;
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc,
-						&sata_cmd, outb++);
-
-	/* rotate the outb queue */
-	outb = outb%PM8001_MAX_SPCV_OUTB_NUM;
+						&sata_cmd, q_index);
 	return ret;
 }
 
-- 
1.7.1

