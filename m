From: John Soni Jose <sony.john-n@emulex.com>
Subject: [PATCH v2 10/19] be2iscsi: Fix max EQ supported by the driver.
Date: Sat, 20 Oct 2012 04:43:32 +0530
Message-ID: <81880917-c2b1-4c0f-b06d-f0d33f539e1f@CMEXHTCAS1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:38762 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab2JSXOk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2012 19:14:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org
Cc: John Soni Jose <sony.john-n@emulex.com>, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Fix the max EQ created when driver is loaded. Max EQ for
 for new adapters will be 64.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_main.c |   15 +++++++++++++--
 drivers/scsi/be2iscsi/be_main.h |   13 ++++++++-----
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 3328eb8..8a142ce 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3325,8 +3325,19 @@ static void find_num_cpus(struct beiscsi_hba *phba)
 
 	num_cpus = num_online_cpus();
 
-	phba->num_cpus = (num_cpus >= BEISCSI_MAX_NUM_CPU) ?
-			 (BEISCSI_MAX_NUM_CPU - 1) : num_cpus;
+	switch (phba->generation) {
+	case BE_GEN2:
+	case BE_GEN3:
+		phba->num_cpus = (num_cpus > BEISCSI_MAX_NUM_CPUS) ?
+				  BEISCSI_MAX_NUM_CPUS : num_cpus;
+		break;
+	case BE_GEN4:
+		phba->num_cpus = (num_cpus > OC_SKH_MAX_NUM_CPUS) ?
+				  OC_SKH_MAX_NUM_CPUS : num_cpus;
+		break;
+	default:
+		phba->num_cpus = 1;
+	}
 }
 
 static int hwi_init_port(struct beiscsi_hba *phba)
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 5302d37..2e534f3 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -64,8 +64,11 @@
 #define BE2_DEFPDU_HDR_SZ	64
 #define BE2_DEFPDU_DATA_SZ	8192
 
-#define MAX_CPUS		31
-#define BEISCSI_MAX_NUM_CPU	8
+#define MAX_CPUS		64
+#define BEISCSI_MAX_NUM_CPUS	7
+#define OC_SKH_MAX_NUM_CPUS	63
+
+
 #define BEISCSI_SGLIST_ELEMENTS	30
 
 #define BEISCSI_CMD_PER_LUN	128	/* scsi_host->cmd_per_lun */
@@ -279,8 +282,8 @@ struct beiscsi_hba {
 	unsigned short asic_revision;
 	unsigned int num_cpus;
 	unsigned int nxt_cqid;
-	struct msix_entry msix_entries[MAX_CPUS + 1];
-	char *msi_name[MAX_CPUS + 1];
+	struct msix_entry msix_entries[MAX_CPUS];
+	char *msi_name[MAX_CPUS];
 	bool msix_enabled;
 	struct be_mem_descriptor *init_mem;
 
@@ -841,7 +844,7 @@ struct hwi_context_memory {
 	u16 max_eqd;		/* in usecs */
 	u16 cur_eqd;		/* in usecs */
 	struct be_eq_obj be_eq[MAX_CPUS];
-	struct be_queue_info be_cq[MAX_CPUS];
+	struct be_queue_info be_cq[MAX_CPUS - 1];
 
 	struct be_queue_info be_def_hdrq;
 	struct be_queue_info be_def_dataq;
-- 
1.7.2

