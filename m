Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5C8C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36828229C7
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729462AbhAELWA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 06:22:00 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10110 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbhAELV7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 06:21:59 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D995d61h9z15nny;
        Tue,  5 Jan 2021 19:20:21 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.498.0; Tue, 5 Jan 2021 19:21:05 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <akshatzen@google.com>, <Viswas.G@microchip.com>,
        <Ruksar.devadi@microchip.com>, <radha@google.com>,
        <bjashnani@google.com>, <vishakhavc@google.com>,
        <jinpu.wang@cloud.ionos.com>, <Ashokkumar.N@microchip.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.de>, <kashyap.desai@broadcom.com>,
        <ming.lei@redhat.com>, "John Garry" <john.garry@huawei.com>
Subject: [RFC/RFT PATCH] scsi: pm8001: Expose HW queues for pm80xx hw
Date:   Tue, 5 Jan 2021 19:17:03 +0800
Message-ID: <1609845423-110410-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In commit 05c6c029a44d ("scsi: pm80xx: Increase number of supported
queues"), support for 80xx chip was improved by enabling multiple HW
queues.

In this, like other SCSI MQ HBA drivers, the HW queues were not exposed
to upper layer, and instead the driver managed the queues internally.

However, this management duplicates blk-mq code. In addition, the HW queue
management is sub-optimal for a system where the number of CPUs exceeds
the HW queues - this is because queues are selected in a round-robin
fashion, when it would be better to make adjacent CPUs submit on the same
queue. And finally, the affinity of the completion queue interrupts is not
set to mirror the cpu<->HQ queue mapping, which is suboptimal.

As such, for when MSIX is supported, expose HW queues to upper layer. Flag
PCI_IRQ_AFFINITY is set for allocating the MSIX vectors to automatically
assign affinity for the completion queue interrupts.

Signed-off-by: John Garry <john.garry@huawei.com>

---
I sent as an RFC/RFT as I have no HW to test. In addition, since HW queue
#0 is used always for internal commands (like in send_task_abort()), if
all CPUs associated with HW queue #0 are offlined, the interrupt for that
queue will be shutdown, and no CPUs would be available to service any
internal commands completion. To solve that, we need [0] merged first and
switch over to use the new API. But we can still test performance in the
meantime.

I assume someone else is making the change to use the request tag for IO
tag management.

[0] https://lore.kernel.org/linux-scsi/47ba045e-a490-198b-1744-529f97192d3b@suse.de/

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index ee2de177d0d0..73479803a23e 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -81,6 +81,15 @@ LIST_HEAD(hba_list);
 
 struct workqueue_struct *pm8001_wq;
 
+static int pm8001_map_queues(struct Scsi_Host *shost)
+{
+	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
+	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+
+	return blk_mq_pci_map_queues(qmap, pm8001_ha->pdev, 0);
+}
+
 /*
  * The main structure which LLDD must register for scsi core.
  */
@@ -106,6 +115,7 @@ static struct scsi_host_template pm8001_sht = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sas_ioctl,
 #endif
+	.map_queues			= pm8001_map_queues,
 	.shost_attrs		= pm8001_host_attrs,
 	.track_queue_depth	= 1,
 };
@@ -923,9 +933,8 @@ static int pm8001_configure_phy_settings(struct pm8001_hba_info *pm8001_ha)
 static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 {
 	u32 number_of_intr;
-	int rc, cpu_online_count;
+	int rc;
 	unsigned int allocated_irq_vectors;
-
 	/* SPCv controllers supports 64 msi-x */
 	if (pm8001_ha->chip_id == chip_8001) {
 		number_of_intr = 1;
@@ -933,16 +942,15 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 		number_of_intr = PM8001_MAX_MSIX_VEC;
 	}
 
-	cpu_online_count = num_online_cpus();
-	number_of_intr = min_t(int, cpu_online_count, number_of_intr);
-	rc = pci_alloc_irq_vectors(pm8001_ha->pdev, number_of_intr,
-			number_of_intr, PCI_IRQ_MSIX);
+	/* Use default affinity descriptor, which spreads *all* vectors */
+	rc = pci_alloc_irq_vectors(pm8001_ha->pdev, 1,
+			number_of_intr, PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
 	allocated_irq_vectors = rc;
 	if (rc < 0)
 		return rc;
 
 	/* Assigns the number of interrupts */
-	number_of_intr = min_t(int, allocated_irq_vectors, number_of_intr);
+	number_of_intr = allocated_irq_vectors;
 	pm8001_ha->number_of_intr = number_of_intr;
 
 	/* Maximum queue number updating in HBA structure */
@@ -1113,6 +1121,16 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	if (rc)
 		goto err_out_enable;
 
+	if (pm8001_ha->number_of_intr > 1) {
+		shost->nr_hw_queues = pm8001_ha->number_of_intr;
+		/*
+		 * For now, ensure we're not sent too many commands by setting
+		 * host_tagset. This is also required if we start using request
+		 * tag.
+		 */
+		shost->host_tagset = 1;
+	}
+
 	rc = scsi_add_host(shost, &pdev->dev);
 	if (rc)
 		goto err_out_ha_free;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index f2c8cbad3853..74bc6fed693e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -55,6 +55,8 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/sas_ata.h>
 #include <linux/atomic.h>
+#include <linux/blk-mq.h>
+#include <linux/blk-mq-pci.h>
 #include "pm8001_defs.h"
 
 #define DRV_NAME		"pm80xx"
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 6772b0924dac..31d65ce91e7d 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4299,12 +4299,13 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	struct domain_device *dev = task->dev;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 	struct ssp_ini_io_start_req ssp_cmd;
+	struct scsi_cmnd *scmd = task->uldd_task;
 	u32 tag = ccb->ccb_tag;
 	int ret;
 	u64 phys_addr, start_addr, end_addr;
 	u32 end_addr_high, end_addr_low;
 	struct inbound_queue_table *circularQ;
-	u32 q_index, cpu_id;
+	u32 blk_tag, q_index;
 	u32 opc = OPC_INB_SSPINIIOSTART;
 	memset(&ssp_cmd, 0, sizeof(ssp_cmd));
 	memcpy(ssp_cmd.ssp_iu.lun, task->ssp_task.LUN, 8);
@@ -4323,8 +4324,8 @@ static int pm80xx_chip_ssp_io_req(struct pm8001_hba_info *pm8001_ha,
 	ssp_cmd.ssp_iu.efb_prio_attr |= (task->ssp_task.task_attr & 7);
 	memcpy(ssp_cmd.ssp_iu.cdb, task->ssp_task.cmd->cmnd,
 		       task->ssp_task.cmd->cmd_len);
-	cpu_id = smp_processor_id();
-	q_index = (u32) (cpu_id) % (pm8001_ha->max_q_num);
+	blk_tag = blk_mq_unique_tag(scmd->request);
+	q_index = blk_mq_unique_tag_to_hwq(blk_tag);
 	circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
 
 	/* Check if encryption is set */
@@ -4446,9 +4447,11 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	struct sas_task *task = ccb->task;
 	struct domain_device *dev = task->dev;
 	struct pm8001_device *pm8001_ha_dev = dev->lldd_dev;
+	struct ata_queued_cmd *qc = task->uldd_task;
+	struct scsi_cmnd *scmd = qc->scsicmd;
 	u32 tag = ccb->ccb_tag;
 	int ret;
-	u32 q_index, cpu_id;
+	u32 q_index, blk_tag;
 	struct sata_start_req sata_cmd;
 	u32 hdr_tag, ncg_tag = 0;
 	u64 phys_addr, start_addr, end_addr;
@@ -4459,8 +4462,9 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 	unsigned long flags;
 	u32 opc = OPC_INB_SATA_HOST_OPSTART;
 	memset(&sata_cmd, 0, sizeof(sata_cmd));
-	cpu_id = smp_processor_id();
-	q_index = (u32) (cpu_id) % (pm8001_ha->max_q_num);
+
+	blk_tag = blk_mq_unique_tag(scmd->request);
+	q_index = blk_mq_unique_tag_to_hwq(blk_tag);
 	circularQ = &pm8001_ha->inbnd_q_tbl[q_index];
 
 	if (task->data_dir == DMA_NONE) {
-- 
2.26.2

