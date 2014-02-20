From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/8] lpfc 8.3.45: Fix sysfs buffer overrun in read of
 lpfc_fcp_cpu_map for 128 CPUs.
Date: Thu, 20 Feb 2014 09:57:18 -0500
Message-ID: <1392908238.31081.16.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:8739 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaBTO5U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 09:57:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix sysfs buffer overrun in read of lpfc_fcp_cpu_map for 128 CPUs.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |   28 ++++++++++++++++++++++------
 lpfc_init.c |    2 ++
 lpfc_sli4.h |    1 +
 3 files changed, 25 insertions(+), 6 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2014-02-19 15:29:28.602023725 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2014-02-19 15:29:33.856023845 -0500
@@ -4288,7 +4288,7 @@ lpfc_fcp_cpu_map_show(struct device *dev
 	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_vector_map_info *cpup;
-	int  idx, len = 0;
+	int  len = 0;
 
 	if ((phba->sli_rev != LPFC_SLI_REV4) ||
 	    (phba->intr_type != MSIX))
@@ -4316,23 +4316,39 @@ lpfc_fcp_cpu_map_show(struct device *dev
 		break;
 	}
 
-	cpup = phba->sli4_hba.cpu_map;
-	for (idx = 0; idx < phba->sli4_hba.num_present_cpu; idx++) {
+	while (phba->sli4_hba.curr_disp_cpu < phba->sli4_hba.num_present_cpu) {
+		cpup = &phba->sli4_hba.cpu_map[phba->sli4_hba.curr_disp_cpu];
+
+		/* margin should fit in this and the truncated message */
 		if (cpup->irq == LPFC_VECTOR_MAP_EMPTY)
 			len += snprintf(buf + len, PAGE_SIZE-len,
 					"CPU %02d io_chan %02d "
 					"physid %d coreid %d\n",
-					idx, cpup->channel_id, cpup->phys_id,
+					phba->sli4_hba.curr_disp_cpu,
+					cpup->channel_id, cpup->phys_id,
 					cpup->core_id);
 		else
 			len += snprintf(buf + len, PAGE_SIZE-len,
 					"CPU %02d io_chan %02d "
 					"physid %d coreid %d IRQ %d\n",
-					idx, cpup->channel_id, cpup->phys_id,
+					phba->sli4_hba.curr_disp_cpu,
+					cpup->channel_id, cpup->phys_id,
 					cpup->core_id, cpup->irq);
 
-		cpup++;
+		phba->sli4_hba.curr_disp_cpu++;
+
+		/* display max number of CPUs keeping some margin */
+		if (phba->sli4_hba.curr_disp_cpu <
+				phba->sli4_hba.num_present_cpu &&
+				(len >= (PAGE_SIZE - 64))) {
+			len += snprintf(buf + len, PAGE_SIZE-len, "more...\n");
+			break;
+		}
 	}
+
+	if (phba->sli4_hba.curr_disp_cpu == phba->sli4_hba.num_present_cpu)
+		phba->sli4_hba.curr_disp_cpu = 0;
+
 	return len;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2014-02-19 15:29:28.636023725 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2014-02-19 15:29:33.869023845 -0500
@@ -5280,6 +5280,7 @@ lpfc_sli4_driver_resource_unset(struct l
 	kfree(phba->sli4_hba.cpu_map);
 	phba->sli4_hba.num_present_cpu = 0;
 	phba->sli4_hba.num_online_cpu = 0;
+	phba->sli4_hba.curr_disp_cpu = 0;
 
 	/* Free memory allocated for msi-x interrupt vector entries */
 	kfree(phba->sli4_hba.msix_entries);
@@ -6850,6 +6851,7 @@ lpfc_sli4_queue_verify(struct lpfc_hba *
 	}
 	phba->sli4_hba.num_online_cpu = i;
 	phba->sli4_hba.num_present_cpu = lpfc_present_cpu;
+	phba->sli4_hba.curr_disp_cpu = 0;
 
 	if (i < cfg_fcp_io_channel) {
 		lpfc_printf_log(phba,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2014-02-19 15:29:28.693023727 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2014-02-19 15:29:33.871023845 -0500
@@ -607,6 +607,7 @@ struct lpfc_sli4_hba {
 	struct lpfc_vector_map_info *cpu_map;
 	uint16_t num_online_cpu;
 	uint16_t num_present_cpu;
+	uint16_t curr_disp_cpu;
 };
 
 enum lpfc_sge_type {



