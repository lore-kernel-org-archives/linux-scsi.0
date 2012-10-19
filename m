From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 04/19] be2iscsi: Fix max supported EQ count to 8.
Date: Sat, 20 Oct 2012 04:42:13 +0530
Message-ID: <8328486d-3b1b-4321-a12a-72e45fc755dd@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:4706 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab2JSXNU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2012 19:13:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 The maximum EQ that can be created for a function is 8. Check the
 CPU online count and create only 8 EQ if CPU_Count >= 8

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   23 ++++++++++++++---------
 drivers/scsi/be2iscsi/be_main.h |    1 +
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index db3ea14..2d1bbb8 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2890,7 +2890,7 @@ static int beiscsi_create_eqs(struct beiscsi_hba *phba,
 	}
 	return 0;
 create_eq_error:
-	for (i = 0; i < (phba->num_cpus + 1); i++) {
+	for (i = 0; i < (phba->num_cpus + eq_for_mcc); i++) {
 		eq = &phwi_context->be_eq[i].q;
 		mem = &eq->dma_mem;
 		if (mem->va)
@@ -3315,15 +3315,20 @@ err:
 	return -ENOMEM;
 }
 
-static int find_num_cpus(void)
+/**
+ * find_num_cpus()- Get the CPU online count
+ * @phba: ptr to priv structure
+ *
+ * CPU count is used for creating EQ.
+ **/
+static void find_num_cpus(struct beiscsi_hba *phba)
 {
 	int  num_cpus = 0;
 
 	num_cpus = num_online_cpus();
-	if (num_cpus >= MAX_CPUS)
-		num_cpus = MAX_CPUS - 1;
 
-	return num_cpus;
+	phba->num_cpus = (num_cpus >= BEISCSI_MAX_NUM_CPU) ?
+			 (BEISCSI_MAX_NUM_CPU - 1) : num_cpus;
 }
 
 static int hwi_init_port(struct beiscsi_hba *phba)
@@ -4542,7 +4547,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_context_memory *phwi_context;
 	struct be_eq_obj *pbe_eq;
-	int ret, num_cpus, i;
+	int ret, i;
 	u8 *real_offset = 0;
 	u32 value = 0;
 
@@ -4578,10 +4583,10 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
 	}
 
 	if (enable_msix)
-		num_cpus = find_num_cpus();
+		find_num_cpus(phba);
 	else
-		num_cpus = 1;
-	phba->num_cpus = num_cpus;
+		phba->num_cpus = 1;
+
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_INIT,
 		    "BM_%d : num_cpus = %d\n",
 		    phba->num_cpus);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index f4e8d19..e24d550 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -61,6 +61,7 @@
 #define BE2_DEFPDU_DATA_SZ	8192
 
 #define MAX_CPUS		31
+#define BEISCSI_MAX_NUM_CPU	8
 #define BEISCSI_SGLIST_ELEMENTS	30
 
 #define BEISCSI_CMD_PER_LUN	128	/* scsi_host->cmd_per_lun */
-- 
1.7.2

