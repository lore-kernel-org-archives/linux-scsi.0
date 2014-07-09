From: Adam Radford <aradford@gmail.com>
Subject: [PATCH 3/5] megaraid_sas: Fix LD/VF affiliation parsing
Date: Wed,  9 Jul 2014 15:17:56 -0700
Message-ID: <1404944278-11535-4-git-send-email-aradford@gmail.com>
References: <1404944278-11535-1-git-send-email-aradford@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42054 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbaGIWTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 18:19:22 -0400
Received: by mail-pd0-f170.google.com with SMTP id z10so9754245pdj.29
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jul 2014 15:19:21 -0700 (PDT)
In-Reply-To: <1404944278-11535-1-git-send-email-aradford@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, uday.lingala@avagotech.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com
Cc: Adam Radford <aradford@gmail.com>

The following patch for megaraid_sas fixes the LD/VF affiliation policy parsing
code to account for LD targetId's and Hidden LD's (not yet affiliated with any
Virtual Functions).  This also breaks megasas_get_ld_vf_affiliation() into 2
separate functions:  megasas_get_ld_vf_affiliation_111() and
megasas_get_ld_Vf_affiliation_12() to reduce indentation levels.

Signed-off-by: Adam Radford <aradford@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |   1 +
 drivers/scsi/megaraid/megaraid_sas_base.c | 318 +++++++++++++++++++-----------
 2 files changed, 208 insertions(+), 111 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 7d722fb..2e2fcb2 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1659,6 +1659,7 @@ struct MR_LD_VF_AFFILIATION {
 /* Plasma 1.11 FW backward compatibility structures */
 #define IOV_111_OFFSET 0x7CE
 #define MAX_VIRTUAL_FUNCTIONS 8
+#define MR_LD_ACCESS_HIDDEN 15
 
 struct IOV_111 {
 	u8 maxVFsSupported;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 112799b..b4c032c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1825,16 +1825,12 @@ void megasas_do_ocr(struct megasas_instance *instance)
 	process_fw_state_change_wq(&instance->work_init);
 }
 
-/* This function will get the current SR-IOV LD/VF affiliation */
-static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
-	int initial)
+static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
+					    int initial)
 {
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
-	struct MR_LD_VF_AFFILIATION *new_affiliation = NULL;
 	struct MR_LD_VF_AFFILIATION_111 *new_affiliation_111 = NULL;
-	struct MR_LD_VF_MAP *newmap = NULL, *savedmap = NULL;
-	dma_addr_t new_affiliation_h;
 	dma_addr_t new_affiliation_111_h;
 	int ld, retval = 0;
 	u8 thisVf;
@@ -1842,15 +1838,15 @@ static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_"
-		       "affiliation: Failed to get cmd for scsi%d.\n",
+		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_affiliation_111:"
+		       "Failed to get cmd for scsi%d.\n",
 			instance->host->host_no);
 		return -ENOMEM;
 	}
 
 	dcmd = &cmd->frame->dcmd;
 
-	if (!instance->vf_affiliation && !instance->vf_affiliation_111) {
+	if (!instance->vf_affiliation_111) {
 		printk(KERN_WARNING "megasas: SR-IOV: Couldn't get LD/VF "
 		       "affiliation for scsi%d.\n", instance->host->host_no);
 		megasas_return_cmd(instance, cmd);
@@ -1858,38 +1854,22 @@ static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 	}
 
 	if (initial)
-		if (instance->PlasmaFW111)
 			memset(instance->vf_affiliation_111, 0,
 			       sizeof(struct MR_LD_VF_AFFILIATION_111));
-		else
-			memset(instance->vf_affiliation, 0,
-			       (MAX_LOGICAL_DRIVES + 1) *
-			       sizeof(struct MR_LD_VF_AFFILIATION));
 	else {
-		if (instance->PlasmaFW111)
-			new_affiliation_111 =
-				pci_alloc_consistent(instance->pdev,
-						     sizeof(struct MR_LD_VF_AFFILIATION_111),
-						     &new_affiliation_111_h);
-		else
-			new_affiliation =
-				pci_alloc_consistent(instance->pdev,
-						     (MAX_LOGICAL_DRIVES + 1) *
-						     sizeof(struct MR_LD_VF_AFFILIATION),
-						     &new_affiliation_h);
-		if (!new_affiliation && !new_affiliation_111) {
+		new_affiliation_111 =
+			pci_alloc_consistent(instance->pdev,
+					     sizeof(struct MR_LD_VF_AFFILIATION_111),
+					     &new_affiliation_111_h);
+		if (!new_affiliation_111) {
 			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate "
 			       "memory for new affiliation for scsi%d.\n",
-				instance->host->host_no);
+			       instance->host->host_no);
 			megasas_return_cmd(instance, cmd);
 			return -ENOMEM;
 		}
-		if (instance->PlasmaFW111)
-			memset(new_affiliation_111, 0,
-			       sizeof(struct MR_LD_VF_AFFILIATION_111));
-		else
-			memset(new_affiliation, 0, (MAX_LOGICAL_DRIVES + 1) *
-			       sizeof(struct MR_LD_VF_AFFILIATION));
+		memset(new_affiliation_111, 0,
+		       sizeof(struct MR_LD_VF_AFFILIATION_111));
 	}
 
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
@@ -1900,34 +1880,17 @@ static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 	dcmd->flags = MFI_FRAME_DIR_BOTH;
 	dcmd->timeout = 0;
 	dcmd->pad_0 = 0;
-	if (instance->PlasmaFW111) {
-		dcmd->data_xfer_len = sizeof(struct MR_LD_VF_AFFILIATION_111);
-		dcmd->opcode = MR_DCMD_LD_VF_MAP_GET_ALL_LDS_111;
-	} else {
-		dcmd->data_xfer_len = (MAX_LOGICAL_DRIVES + 1) *
-			sizeof(struct MR_LD_VF_AFFILIATION);
-		dcmd->opcode = MR_DCMD_LD_VF_MAP_GET_ALL_LDS;
-	}
+	dcmd->data_xfer_len = sizeof(struct MR_LD_VF_AFFILIATION_111);
+	dcmd->opcode = MR_DCMD_LD_VF_MAP_GET_ALL_LDS_111;
 
-	if (initial) {
-		if (instance->PlasmaFW111)
-			dcmd->sgl.sge32[0].phys_addr =
-			  instance->vf_affiliation_111_h;
-		else
-			dcmd->sgl.sge32[0].phys_addr =
-			  instance->vf_affiliation_h;
-	} else {
-		if (instance->PlasmaFW111)
-			dcmd->sgl.sge32[0].phys_addr = new_affiliation_111_h;
-		else
-			dcmd->sgl.sge32[0].phys_addr = new_affiliation_h;
-	}
-	if (instance->PlasmaFW111)
-		dcmd->sgl.sge32[0].length =
-		  sizeof(struct MR_LD_VF_AFFILIATION_111);
+	if (initial)
+		dcmd->sgl.sge32[0].phys_addr =
+			instance->vf_affiliation_111_h;
 	else
-		dcmd->sgl.sge32[0].length = (MAX_LOGICAL_DRIVES + 1) *
-			sizeof(struct MR_LD_VF_AFFILIATION);
+		dcmd->sgl.sge32[0].phys_addr = new_affiliation_111_h;
+
+	dcmd->sgl.sge32[0].length =
+		sizeof(struct MR_LD_VF_AFFILIATION_111);
 
 	printk(KERN_WARNING "megasas: SR-IOV: Getting LD/VF affiliation for "
 	       "scsi%d\n", instance->host->host_no);
@@ -1943,80 +1906,213 @@ static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
 	}
 
 	if (!initial) {
-		if (instance->PlasmaFW111) {
-			if (!new_affiliation_111->vdCount) {
-				printk(KERN_WARNING "megasas: SR-IOV: Got new "
-				       "LD/VF affiliation for passive path "
+		thisVf = new_affiliation_111->thisVf;
+		for (ld = 0 ; ld < new_affiliation_111->vdCount; ld++)
+			if (instance->vf_affiliation_111->map[ld].policy[thisVf] !=
+			    new_affiliation_111->map[ld].policy[thisVf]) {
+				printk(KERN_WARNING "megasas: SR-IOV: "
+				       "Got new LD/VF affiliation "
 				       "for scsi%d.\n",
-					instance->host->host_no);
-				retval = 1;
-				goto out;
-			}
-			thisVf = new_affiliation_111->thisVf;
-			for (ld = 0 ; ld < new_affiliation_111->vdCount; ld++)
-				if (instance->vf_affiliation_111->map[ld].policy[thisVf] != new_affiliation_111->map[ld].policy[thisVf]) {
-					printk(KERN_WARNING "megasas: SR-IOV: "
-					       "Got new LD/VF affiliation "
-					       "for scsi%d.\n",
-						instance->host->host_no);
-					memcpy(instance->vf_affiliation_111,
-					       new_affiliation_111,
-					       sizeof(struct MR_LD_VF_AFFILIATION_111));
-					retval = 1;
-					goto out;
-				}
-		} else {
-			if (!new_affiliation->ldCount) {
-				printk(KERN_WARNING "megasas: SR-IOV: Got new "
-				       "LD/VF affiliation for passive "
-				       "path for scsi%d.\n",
 				       instance->host->host_no);
+				memcpy(instance->vf_affiliation_111,
+				       new_affiliation_111,
+				       sizeof(struct MR_LD_VF_AFFILIATION_111));
 				retval = 1;
 				goto out;
 			}
-			newmap = new_affiliation->map;
-			savedmap = instance->vf_affiliation->map;
-			thisVf = new_affiliation->thisVf;
-			for (ld = 0 ; ld < new_affiliation->ldCount; ld++) {
-				if (savedmap->policy[thisVf] !=
-				    newmap->policy[thisVf]) {
-					printk(KERN_WARNING "megasas: SR-IOV: "
-					       "Got new LD/VF affiliation "
-					       "for scsi%d.\n",
-						instance->host->host_no);
-					memcpy(instance->vf_affiliation,
-					       new_affiliation,
-					       new_affiliation->size);
-					retval = 1;
-					goto out;
+	}
+out:
+	if (new_affiliation_111) {
+		pci_free_consistent(instance->pdev,
+				    sizeof(struct MR_LD_VF_AFFILIATION_111),
+				    new_affiliation_111,
+				    new_affiliation_111_h);
+	}
+	megasas_return_cmd(instance, cmd);
+
+	return retval;
+}
+
+static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
+					    int initial)
+{
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	struct MR_LD_VF_AFFILIATION *new_affiliation = NULL;
+	struct MR_LD_VF_MAP *newmap = NULL, *savedmap = NULL;
+	dma_addr_t new_affiliation_h;
+	int i, j, retval = 0, found = 0, doscan = 0;
+	u8 thisVf;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		printk(KERN_DEBUG "megasas: megasas_get_ld_vf_affiliation12: "
+		       "Failed to get cmd for scsi%d.\n",
+		       instance->host->host_no);
+		return -ENOMEM;
+	}
+
+	dcmd = &cmd->frame->dcmd;
+
+	if (!instance->vf_affiliation) {
+		printk(KERN_WARNING "megasas: SR-IOV: Couldn't get LD/VF "
+		       "affiliation for scsi%d.\n", instance->host->host_no);
+		megasas_return_cmd(instance, cmd);
+		return -ENOMEM;
+	}
+
+	if (initial)
+		memset(instance->vf_affiliation, 0, (MAX_LOGICAL_DRIVES + 1) *
+		       sizeof(struct MR_LD_VF_AFFILIATION));
+	else {
+		new_affiliation =
+			pci_alloc_consistent(instance->pdev,
+					     (MAX_LOGICAL_DRIVES + 1) *
+					     sizeof(struct MR_LD_VF_AFFILIATION),
+					     &new_affiliation_h);
+		if (!new_affiliation) {
+			printk(KERN_DEBUG "megasas: SR-IOV: Couldn't allocate "
+			       "memory for new affiliation for scsi%d.\n",
+			       instance->host->host_no);
+			megasas_return_cmd(instance, cmd);
+			return -ENOMEM;
+		}
+		memset(new_affiliation, 0, (MAX_LOGICAL_DRIVES + 1) *
+		       sizeof(struct MR_LD_VF_AFFILIATION));
+	}
+
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->flags = MFI_FRAME_DIR_BOTH;
+	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
+	dcmd->data_xfer_len = (MAX_LOGICAL_DRIVES + 1) *
+		sizeof(struct MR_LD_VF_AFFILIATION);
+	dcmd->opcode = MR_DCMD_LD_VF_MAP_GET_ALL_LDS;
+
+	if (initial)
+		dcmd->sgl.sge32[0].phys_addr = instance->vf_affiliation_h;
+	else
+		dcmd->sgl.sge32[0].phys_addr = new_affiliation_h;
+
+	dcmd->sgl.sge32[0].length = (MAX_LOGICAL_DRIVES + 1) *
+		sizeof(struct MR_LD_VF_AFFILIATION);
+
+	printk(KERN_WARNING "megasas: SR-IOV: Getting LD/VF affiliation for "
+	       "scsi%d\n", instance->host->host_no);
+
+	megasas_issue_blocked_cmd(instance, cmd, 0);
+
+	if (dcmd->cmd_status) {
+		printk(KERN_WARNING "megasas: SR-IOV: LD/VF affiliation DCMD"
+		       " failed with status 0x%x for scsi%d.\n",
+		       dcmd->cmd_status, instance->host->host_no);
+		retval = 1; /* Do a scan if we couldn't get affiliation */
+		goto out;
+	}
+
+	if (!initial) {
+		if (!new_affiliation->ldCount) {
+			printk(KERN_WARNING "megasas: SR-IOV: Got new LD/VF "
+			       "affiliation for passive path for scsi%d.\n",
+			       instance->host->host_no);
+			retval = 1;
+			goto out;
+		}
+		newmap = new_affiliation->map;
+		savedmap = instance->vf_affiliation->map;
+		thisVf = new_affiliation->thisVf;
+		for (i = 0 ; i < new_affiliation->ldCount; i++) {
+			found = 0;
+			for (j = 0; j < instance->vf_affiliation->ldCount;
+			     j++) {
+				if (newmap->ref.targetId ==
+				    savedmap->ref.targetId) {
+					found = 1;
+					if (newmap->policy[thisVf] !=
+					    savedmap->policy[thisVf]) {
+						doscan = 1;
+						goto out;
+					}
 				}
 				savedmap = (struct MR_LD_VF_MAP *)
 					((unsigned char *)savedmap +
 					 savedmap->size);
+			}
+			if (!found && newmap->policy[thisVf] !=
+			    MR_LD_ACCESS_HIDDEN) {
+				doscan = 1;
+				goto out;
+			}
+			newmap = (struct MR_LD_VF_MAP *)
+				((unsigned char *)newmap + newmap->size);
+		}
+
+		newmap = new_affiliation->map;
+		savedmap = instance->vf_affiliation->map;
+
+		for (i = 0 ; i < instance->vf_affiliation->ldCount; i++) {
+			found = 0;
+			for (j = 0 ; j < new_affiliation->ldCount; j++) {
+				if (savedmap->ref.targetId ==
+				    newmap->ref.targetId) {
+					found = 1;
+					if (savedmap->policy[thisVf] !=
+					    newmap->policy[thisVf]) {
+						doscan = 1;
+						goto out;
+					}
+				}
 				newmap = (struct MR_LD_VF_MAP *)
 					((unsigned char *)newmap +
 					 newmap->size);
 			}
+			if (!found && savedmap->policy[thisVf] !=
+			    MR_LD_ACCESS_HIDDEN) {
+				doscan = 1;
+				goto out;
+			}
+			savedmap = (struct MR_LD_VF_MAP *)
+				((unsigned char *)savedmap +
+				 savedmap->size);
 		}
 	}
 out:
-	if (new_affiliation) {
-		if (instance->PlasmaFW111)
-			pci_free_consistent(instance->pdev,
-					    sizeof(struct MR_LD_VF_AFFILIATION_111),
-					    new_affiliation_111,
-					    new_affiliation_111_h);
-		else
-			pci_free_consistent(instance->pdev,
-					    (MAX_LOGICAL_DRIVES + 1) *
-					    sizeof(struct MR_LD_VF_AFFILIATION),
-					    new_affiliation, new_affiliation_h);
+	if (doscan) {
+		printk(KERN_WARNING "megasas: SR-IOV: Got new LD/VF "
+		       "affiliation for scsi%d.\n", instance->host->host_no);
+		memcpy(instance->vf_affiliation, new_affiliation,
+		       new_affiliation->size);
+		retval = 1;
 	}
+
+	if (new_affiliation)
+		pci_free_consistent(instance->pdev,
+				    (MAX_LOGICAL_DRIVES + 1) *
+				    sizeof(struct MR_LD_VF_AFFILIATION),
+				    new_affiliation, new_affiliation_h);
 	megasas_return_cmd(instance, cmd);
 
 	return retval;
 }
 
+/* This function will get the current SR-IOV LD/VF affiliation */
+static int megasas_get_ld_vf_affiliation(struct megasas_instance *instance,
+	int initial)
+{
+	int retval;
+
+	if (instance->PlasmaFW111)
+		retval = megasas_get_ld_vf_affiliation_111(instance, initial);
+	else
+		retval = megasas_get_ld_vf_affiliation_12(instance, initial);
+	return retval;
+}
+
 /* This function will tell FW to start the SR-IOV heartbeat */
 int megasas_sriov_start_heartbeat(struct megasas_instance *instance,
 					 int initial)
-- 
1.7.11.7

