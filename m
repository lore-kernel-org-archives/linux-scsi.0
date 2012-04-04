From: michaelc@cs.wisc.edu
Subject: [PATCH 03/17] be2iscsi: WRB Initialization and Failure code path change
Date: Tue,  3 Apr 2012 23:41:38 -0500
Message-ID: <1333514512-21799-4-git-send-email-michaelc@cs.wisc.edu>
References: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab2DDElu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2012 00:41:50 -0400
In-Reply-To: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Removing code duplication during the WRB_Handle and WRB
 initialization.
 Added memory allocation failure handling code during WRB
 initialization.

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |   98 +++++++++++++++++++--------------------
 drivers/scsi/be2iscsi/be_mgmt.h |    4 +-
 2 files changed, 49 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fef6f07..23344c8 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2211,7 +2211,7 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
 	struct mem_array *mem_arr, *mem_arr_orig;
 	unsigned int i, j, alloc_size, curr_alloc_size;
 
-	phba->phwi_ctrlr = kmalloc(phba->params.hwi_ws_sz, GFP_KERNEL);
+	phba->phwi_ctrlr = kzalloc(phba->params.hwi_ws_sz, GFP_KERNEL);
 	if (!phba->phwi_ctrlr)
 		return -ENOMEM;
 
@@ -2331,27 +2331,21 @@ static void iscsi_init_global_templates(struct beiscsi_hba *phba)
 	AMAP_SET_BITS(struct amap_pdu_nop_out, i_bit, pnop_out, 0);
 }
 
-static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
+static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 {
 	struct be_mem_descriptor *mem_descr_wrbh, *mem_descr_wrb;
-	struct wrb_handle *pwrb_handle;
+	struct wrb_handle *pwrb_handle = NULL;
 	struct hwi_controller *phwi_ctrlr;
 	struct hwi_wrb_context *pwrb_context;
-	struct iscsi_wrb *pwrb;
-	unsigned int num_cxn_wrbh;
-	unsigned int num_cxn_wrb, j, idx, index;
+	struct iscsi_wrb *pwrb = NULL;
+	unsigned int num_cxn_wrbh = 0;
+	unsigned int num_cxn_wrb = 0, j, idx = 0, index;
 
 	mem_descr_wrbh = phba->init_mem;
 	mem_descr_wrbh += HWI_MEM_WRBH;
 
 	mem_descr_wrb = phba->init_mem;
 	mem_descr_wrb += HWI_MEM_WRB;
-
-	idx = 0;
-	pwrb_handle = mem_descr_wrbh->mem_array[idx].virtual_address;
-	num_cxn_wrbh = ((mem_descr_wrbh->mem_array[idx].size) /
-			((sizeof(struct wrb_handle)) *
-			 phba->params.wrbs_per_cxn));
 	phwi_ctrlr = phba->phwi_ctrlr;
 
 	for (index = 0; index < phba->params.cxns_per_ctrl * 2; index += 2) {
@@ -2359,12 +2353,32 @@ static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 		pwrb_context->pwrb_handle_base =
 				kzalloc(sizeof(struct wrb_handle *) *
 					phba->params.wrbs_per_cxn, GFP_KERNEL);
+		if (!pwrb_context->pwrb_handle_base) {
+			shost_printk(KERN_ERR, phba->shost,
+					"Mem Alloc Failed. Failing to load\n");
+			goto init_wrb_hndl_failed;
+		}
 		pwrb_context->pwrb_handle_basestd =
 				kzalloc(sizeof(struct wrb_handle *) *
 					phba->params.wrbs_per_cxn, GFP_KERNEL);
+		if (!pwrb_context->pwrb_handle_basestd) {
+			shost_printk(KERN_ERR, phba->shost,
+					"Mem Alloc Failed. Failing to load\n");
+			goto init_wrb_hndl_failed;
+		}
+		if (!num_cxn_wrbh) {
+			pwrb_handle =
+				mem_descr_wrbh->mem_array[idx].virtual_address;
+			num_cxn_wrbh = ((mem_descr_wrbh->mem_array[idx].size) /
+					((sizeof(struct wrb_handle)) *
+					 phba->params.wrbs_per_cxn));
+			idx++;
+		}
+		pwrb_context->alloc_index = 0;
+		pwrb_context->wrb_handles_available = 0;
+		pwrb_context->free_index = 0;
+
 		if (num_cxn_wrbh) {
-			pwrb_context->alloc_index = 0;
-			pwrb_context->wrb_handles_available = 0;
 			for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
 				pwrb_context->pwrb_handle_base[j] = pwrb_handle;
 				pwrb_context->pwrb_handle_basestd[j] =
@@ -2373,49 +2387,21 @@ static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 				pwrb_handle->wrb_index = j;
 				pwrb_handle++;
 			}
-			pwrb_context->free_index = 0;
-			num_cxn_wrbh--;
-		} else {
-			idx++;
-			pwrb_handle =
-			    mem_descr_wrbh->mem_array[idx].virtual_address;
-			num_cxn_wrbh =
-			    ((mem_descr_wrbh->mem_array[idx].size) /
-			     ((sizeof(struct wrb_handle)) *
-			      phba->params.wrbs_per_cxn));
-			pwrb_context->alloc_index = 0;
-			for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
-				pwrb_context->pwrb_handle_base[j] = pwrb_handle;
-				pwrb_context->pwrb_handle_basestd[j] =
-				    pwrb_handle;
-				pwrb_context->wrb_handles_available++;
-				pwrb_handle->wrb_index = j;
-				pwrb_handle++;
-			}
-			pwrb_context->free_index = 0;
 			num_cxn_wrbh--;
 		}
 	}
 	idx = 0;
-	pwrb = mem_descr_wrb->mem_array[idx].virtual_address;
-	num_cxn_wrb = (mem_descr_wrb->mem_array[idx].size) /
-		      ((sizeof(struct iscsi_wrb) *
-			phba->params.wrbs_per_cxn));
 	for (index = 0; index < phba->params.cxns_per_ctrl * 2; index += 2) {
 		pwrb_context = &phwi_ctrlr->wrb_context[index];
-		if (num_cxn_wrb) {
-			for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
-				pwrb_handle = pwrb_context->pwrb_handle_base[j];
-				pwrb_handle->pwrb = pwrb;
-				pwrb++;
-			}
-			num_cxn_wrb--;
-		} else {
-			idx++;
+		if (!num_cxn_wrb) {
 			pwrb = mem_descr_wrb->mem_array[idx].virtual_address;
 			num_cxn_wrb = (mem_descr_wrb->mem_array[idx].size) /
-				      ((sizeof(struct iscsi_wrb) *
-					phba->params.wrbs_per_cxn));
+				((sizeof(struct iscsi_wrb) *
+				  phba->params.wrbs_per_cxn));
+			idx++;
+		}
+
+		if (num_cxn_wrb) {
 			for (j = 0; j < phba->params.wrbs_per_cxn; j++) {
 				pwrb_handle = pwrb_context->pwrb_handle_base[j];
 				pwrb_handle->pwrb = pwrb;
@@ -2424,6 +2410,14 @@ static void beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 			num_cxn_wrb--;
 		}
 	}
+	return 0;
+init_wrb_hndl_failed:
+	for (j = index; j > 0; j--) {
+		pwrb_context = &phwi_ctrlr->wrb_context[j];
+		kfree(pwrb_context->pwrb_handle_base);
+		kfree(pwrb_context->pwrb_handle_basestd);
+	}
+	return -ENOMEM;
 }
 
 static void hwi_init_async_pdu_ctx(struct beiscsi_hba *phba)
@@ -3237,7 +3231,9 @@ static int hwi_init_controller(struct beiscsi_hba *phba)
 	}
 
 	iscsi_init_global_templates(phba);
-	beiscsi_init_wrb_handle(phba);
+	if (beiscsi_init_wrb_handle(phba))
+		return -ENOMEM;
+
 	hwi_init_async_pdu_ctx(phba);
 	if (hwi_init_port(phba) != 0) {
 		shost_printk(KERN_ERR, phba->shost,
@@ -3824,7 +3820,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	task->hdr = (struct iscsi_hdr *)&io_task->cmd_bhs->iscsi_hdr;
 	task->hdr_max = sizeof(struct be_cmd_bhs);
 	io_task->psgl_handle = NULL;
-	io_task->psgl_handle = NULL;
+	io_task->pwrb_handle = NULL;
 
 	if (task->sc) {
 		spin_lock(&phba->io_sgl_lock);
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 0842882..d7fdfce 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -219,9 +219,9 @@ struct be_mgmt_controller_attributes_resp {
 				/* the CMD_RESPONSE_HEADER  */
 
 #define ISCSI_GET_PDU_TEMPLATE_ADDRESS(pc, pa) {\
-    pa->lo = phba->init_mem[ISCSI_MEM_GLOBAL_HEADER].mem_array[0].\
+	pa->lo = phba->init_mem[ISCSI_MEM_GLOBAL_HEADER].mem_array[0].\
 					bus_address.u.a32.address_lo;  \
-    pa->hi = phba->init_mem[ISCSI_MEM_GLOBAL_HEADER].mem_array[0].\
+	pa->hi = phba->init_mem[ISCSI_MEM_GLOBAL_HEADER].mem_array[0].\
 					bus_address.u.a32.address_hi;  \
 }
 
-- 
1.7.7.6

