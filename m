From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 2/2] be2iscsi: Moving to pci_pools
Date: Fri, 18 Sep 2009 21:48:37 +0530
Message-ID: <20090918161822.GA8468@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:38220 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752270AbZIRQSb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 12:18:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

 This patch contains changes to use pci_pools for iscsi hdr
instead of pci_alloc_consistent. Here we alloc and free to pool
for every IO

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   52 +++++++++++++++++++------------------
 drivers/scsi/be2iscsi/be_main.c  |   28 +++++++++++++++++++-
 drivers/scsi/be2iscsi/be_main.h  |    1 -
 3 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index f18e643..62b94a7 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -45,14 +45,9 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 	struct beiscsi_endpoint *beiscsi_ep;
 	struct iscsi_cls_session *cls_session;
 	struct beiscsi_hba *phba;
-	struct iscsi_task *task;
 	struct iscsi_session *sess;
 	struct beiscsi_session *beiscsi_sess;
 	struct beiscsi_io_task *io_task;
-	unsigned int max_size, num_cmd;
-	dma_addr_t bus_add;
-	u64 pa_addr;
-	void *vaddr;
 
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_session_create\n");
 
@@ -80,20 +75,18 @@ struct iscsi_cls_session *beiscsi_session_create(struct iscsi_endpoint *ep,
 	if (!cls_session)
 		return NULL;
 	sess = cls_session->dd_data;
-	max_size = ALIGN(sizeof(struct be_cmd_bhs), 64) * sess->cmds_max;
-	vaddr = pci_alloc_consistent(phba->pcidev, max_size, &bus_add);
-	pa_addr = (__u64) bus_add;
+	beiscsi_sess = sess->dd_data;
+	beiscsi_sess->bhs_pool =  pci_pool_create("beiscsi_bhs_pool",
+						   phba->pcidev,
+						   sizeof(struct be_cmd_bhs),
+						   64, 0);
+	if (!beiscsi_sess->bhs_pool)
+		goto destroy_sess;
 
-	for (num_cmd = 0; num_cmd < sess->cmds_max; num_cmd++) {
-		task = sess->cmds[num_cmd];
-		io_task = task->dd_data;
-		io_task->cmd_bhs = vaddr;
-		io_task->bhs_pa.u.a64.address = pa_addr;
-		io_task->alloc_size = max_size;
-		vaddr += ALIGN(sizeof(struct be_cmd_bhs), 64);
-		pa_addr += ALIGN(sizeof(struct be_cmd_bhs), 64);
-	}
 	return cls_session;
+destroy_sess:
+	iscsi_session_teardown(cls_session);
+	return NULL;
 }
 
 /**
@@ -107,16 +100,20 @@ void beiscsi_session_destroy(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_task *task;
 	struct beiscsi_io_task *io_task;
+	unsigned int num_cmd;
 	struct iscsi_session *sess = cls_session->dd_data;
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+	struct beiscsi_session *beiscsi_sess = sess->dd_data;
 
-	task = sess->cmds[0];
-	io_task = task->dd_data;
-	pci_free_consistent(phba->pcidev,
-			    io_task->alloc_size,
-			    io_task->cmd_bhs,
-			    io_task->bhs_pa.u.a64.address);
+	for (num_cmd = 0; num_cmd < sess->cmds_max; num_cmd++) {
+		task = sess->cmds[num_cmd];
+		io_task = task->dd_data;
+		if (io_task->cmd_bhs) {
+			pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
+				      io_task->bhs_pa.u.a64.address);
+			io_task->cmd_bhs = NULL;
+		}
+	}
+	pci_pool_destroy(beiscsi_sess->bhs_pool);
 	iscsi_session_teardown(cls_session);
 }
 
@@ -133,6 +130,8 @@ beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)
 	struct iscsi_cls_conn *cls_conn;
 	struct beiscsi_conn *beiscsi_conn;
 	struct iscsi_conn *conn;
+	struct iscsi_session *sess;
+	struct beiscsi_session *beiscsi_sess;
 
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_create ,cid"
 		 "from iscsi layer=%d\n", cid);
@@ -148,6 +147,9 @@ beiscsi_conn_create(struct iscsi_cls_session *cls_session, u32 cid)
 	beiscsi_conn->ep = NULL;
 	beiscsi_conn->phba = phba;
 	beiscsi_conn->conn = conn;
+	sess = cls_session->dd_data;
+	beiscsi_sess = sess->dd_data;
+	beiscsi_conn->beiscsi_sess = beiscsi_sess;
 	return cls_conn;
 }
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d520fe8..c3aeba0 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2880,6 +2880,13 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
 	itt_t itt;
+	struct beiscsi_session *beiscsi_sess = beiscsi_conn->beiscsi_sess;
+
+	io_task->cmd_bhs = pci_pool_alloc(beiscsi_sess->bhs_pool,
+					  GFP_KERNEL,
+					  &io_task->bhs_pa.u.a64.address);
+	if (!io_task->cmd_bhs)
+		return -ENOMEM;
 
 	io_task->pwrb_handle = alloc_wrb_handle(phba,
 						beiscsi_conn->beiscsi_conn_cid,
@@ -2901,6 +2908,9 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			free_wrb_handle(phba, pwrb_context,
 						io_task->pwrb_handle);
 			io_task->pwrb_handle = NULL;
+			pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
+				      io_task->bhs_pa.u.a64.address);
+			io_task->cmd_bhs = NULL;
 			SE_DEBUG(DBG_LVL_1,
 				 "Alloc of SGL_ICD Failed \n");
 			return -ENOMEM;
@@ -2921,6 +2931,11 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 					free_wrb_handle(phba, pwrb_context,
 							io_task->pwrb_handle);
 					io_task->pwrb_handle = NULL;
+					pci_pool_free(beiscsi_sess->bhs_pool,
+						      io_task->cmd_bhs,
+						      io_task->
+						      bhs_pa.u.a64.address);
+					io_task->cmd_bhs = NULL;
 					SE_DEBUG(DBG_LVL_1, "Alloc of "
 						"MGMT_SGL_ICD Failed \n");
 					return -ENOMEM;
@@ -2943,6 +2958,10 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				free_wrb_handle(phba, pwrb_context,
 							io_task->pwrb_handle);
 				io_task->pwrb_handle = NULL;
+				pci_pool_free(beiscsi_sess->bhs_pool,
+					      io_task->cmd_bhs,
+					      io_task->bhs_pa.u.a64.address);
+				io_task->cmd_bhs = NULL;
 				SE_DEBUG(DBG_LVL_1, "Alloc of "
 					 "MGMT_SGL_ICD Failed \n");
 				return -ENOMEM;
@@ -2961,6 +2980,7 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 	struct iscsi_conn *conn = task->conn;
 	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct beiscsi_session *beiscsi_sess = beiscsi_conn->beiscsi_sess;
 	struct hwi_wrb_context *pwrb_context;
 	struct hwi_controller *phwi_ctrlr;
 
@@ -2971,6 +2991,12 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 		io_task->pwrb_handle = NULL;
 	}
 
+	if (io_task->cmd_bhs) {
+		pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
+			      io_task->bhs_pa.u.a64.address);
+		io_task->cmd_bhs = NULL;
+	}
+
 	if (task->sc) {
 		if (io_task->psgl_handle) {
 			spin_lock(&phba->io_sgl_lock);
@@ -3003,7 +3029,6 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 	unsigned int doorbell = 0;
 
 	pwrb = io_task->pwrb_handle->pwrb;
-
 	io_task->cmd_bhs->iscsi_hdr.exp_statsn = 0;
 	io_task->bhs_len = sizeof(struct be_cmd_bhs);
 
@@ -3020,7 +3045,6 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 			      &io_task->cmd_bhs->iscsi_data_pdu, 1);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_WR_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dsp, pwrb, 1);
-
 	} else {
 		SE_DEBUG(DBG_LVL_4, "READ Command \t");
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb, INI_RD_CMD);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 387e363..53c9b70 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -391,7 +391,6 @@ struct beiscsi_io_task {
 	unsigned short cid;
 	unsigned short header_len;
 
-	unsigned int alloc_size;
 	struct be_cmd_bhs *cmd_bhs;
 	struct be_bus_address bhs_pa;
 	unsigned short bhs_len;
-- 
1.6.4

