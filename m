From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 01/20] [SCSI] mpt3sas: Added Combined Reply Queue feature to extend up-to 96 MSIX vector support
Date: Mon, 22 Jun 2015 18:10:58 +0530
Message-ID: <1434976858-1086-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35470 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291AbbFVMlQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2015 08:41:16 -0400
Received: by pdbci14 with SMTP id ci14so79551611pdb.2
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2015 05:41:15 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

In this patch, increased the number of MSIX vector support for SAS3 C0 HBAs to up-to 96.

Following are changes that are done in this patch
1. This feature is enabled only for SAS3 C0 and higher revision cards and also only when reply post free queue count is greater than 8.
2. To support this feature 12 SupplementalReplyPostHostIndex system interfaces are used. MSI-X index numbered from 0 to 7 use the first SupplementalReplyPostHostIndex system interface to update its corresponding ReplyPostHostIndex values, MSI-X index numbered from 8 to 15 will use the second SupplementalReplyPostHostIndex system interface and so on. These 12 SuppementalReplyPostHostIndex system interfaces address are saved in the array replyPostRegisterIndex[].
3. As each SupplementalReplyPostHostIndex register supports 8 MSI-X vectors. So MSIxIndex field in these register must contain a value between 0 and 7.
4. After processing the reply descriptors from a reply post free queues then update the new reply post host index value in ReplyPostHostIndex field and (msix_index mod 8) value in MSIxIndex field of SupplementalReplyPostHostIndex register. The Address of this SupplementalReplyPostHostIndex register is retrived from (msix_index/8)th entry of replyPostRegisterIndex[] array.

Changes in v1:
 Updated the description of module parameter max_msix_vectors

Changes in v2:
 * Defined some Combined Reply Queue's feature magic values,
 * Removed unnecessory brackets,
 * Added comments where ever required.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 93 +++++++++++++++++++++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_base.h | 14 +++++-
 2 files changed, 98 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f26a328..a767a8a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -83,10 +83,10 @@ static int msix_disable = -1;
 module_param(msix_disable, int, 0);
 MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
 
-static int max_msix_vectors = 8;
+static int max_msix_vectors = -1;
 module_param(max_msix_vectors, int, 0);
 MODULE_PARM_DESC(max_msix_vectors,
-	" max msix vectors - (default=8)");
+	" max msix vectors");
 
 static int mpt3sas_fwfault_debug;
 MODULE_PARM_DESC(mpt3sas_fwfault_debug,
@@ -1009,8 +1009,30 @@ _base_interrupt(int irq, void *bus_id)
 	}
 
 	wmb();
-	writel(reply_q->reply_post_host_index | (msix_index <<
-	    MPI2_RPHI_MSIX_INDEX_SHIFT), &ioc->chip->ReplyPostHostIndex);
+
+	/* Update Reply Post Host Index.
+	 * For those HBA's which support combined reply queue feature
+	 * 1. Get the correct Supplemental Reply Post Host Index Register.
+	 *    i.e. (msix_index / 8)th entry from Supplemental Reply Post Host
+	 *    Index Register address bank i.e replyPostRegisterIndex[],
+	 * 2. Then update this register with new reply host index value
+	 *    in ReplyPostIndex field and the MSIxIndex field with
+	 *    msix_index value reduced to a value between 0 and 7,
+	 *    using a modulo 8 operation. Since each Supplemental Reply Post
+	 *    Host Index Register supports 8 MSI-X vectors.
+	 *
+	 * For other HBA's just update the Reply Post Host Index register with
+	 * new reply host index value in ReplyPostIndex Field and msix_index
+	 * value in MSIxIndex field.
+	 */
+	if (ioc->msix96_vector)
+		writel(reply_q->reply_post_host_index | ((msix_index  & 7) <<
+			MPI2_RPHI_MSIX_INDEX_SHIFT),
+			ioc->replyPostRegisterIndex[msix_index/8]);
+	else
+		writel(reply_q->reply_post_host_index | (msix_index <<
+			MPI2_RPHI_MSIX_INDEX_SHIFT),
+			&ioc->chip->ReplyPostHostIndex);
 	atomic_dec(&reply_q->busy);
 	return IRQ_HANDLED;
 }
@@ -1560,8 +1582,6 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 
 	pci_read_config_word(ioc->pdev, base + 2, &message_control);
 	ioc->msix_vector_count = (message_control & 0x3FF) + 1;
-	if (ioc->msix_vector_count > 8)
-		ioc->msix_vector_count = 8;
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT
 		"msix is supported, vector_count(%d)\n",
 		ioc->name, ioc->msix_vector_count));
@@ -1880,6 +1900,36 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 	if (r)
 		goto out_fail;
 
+	/* Use the Combined reply queue feature only for SAS3 C0 & higher
+	 * revision HBAs and also only when reply queue count is greater than 8
+	 */
+	if (ioc->msix96_vector && ioc->reply_queue_count > 8) {
+		/* Determine the Supplemental Reply Post Host Index Registers
+		 * Addresse. Supplemental Reply Post Host Index Registers
+		 * starts at offset MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET and
+		 * each register is at offset bytes of
+		 * MPT3_SUP_REPLY_POST_HOST_INDEX_REG_OFFSET from previous one.
+		 */
+		ioc->replyPostRegisterIndex = kcalloc(
+		     MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT,
+		     sizeof(resource_size_t *), GFP_KERNEL);
+		if (!ioc->replyPostRegisterIndex) {
+			dfailprintk(ioc, printk(MPT3SAS_FMT
+			"allocation for reply Post Register Index failed!!!\n",
+								   ioc->name));
+			r = -ENOMEM;
+			goto out_fail;
+		}
+
+		for (i = 0; i < MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT; i++) {
+			ioc->replyPostRegisterIndex[i] = (resource_size_t *)
+			     ((u8 *)&ioc->chip->Doorbell +
+			     MPI25_SUP_REPLY_POST_HOST_INDEX_OFFSET +
+			     (i * MPT3_SUP_REPLY_POST_HOST_INDEX_REG_OFFSET));
+		}
+	} else
+		ioc->msix96_vector = 0;
+
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list)
 		pr_info(MPT3SAS_FMT "%s: IRQ %d\n",
 		    reply_q->name,  ((ioc->msix_enable) ? "PCI-MSI-X enabled" :
@@ -1901,6 +1951,8 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
 	pci_release_selected_regions(ioc->pdev, ioc->bars);
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
+	if (ioc->msix96_vector)
+		kfree(ioc->replyPostRegisterIndex);
 	return r;
 }
 
@@ -4685,8 +4737,15 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 
 	/* initialize reply post host index */
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
-		writel(reply_q->msix_index << MPI2_RPHI_MSIX_INDEX_SHIFT,
-		    &ioc->chip->ReplyPostHostIndex);
+		if (ioc->msix96_vector)
+			writel((reply_q->msix_index & 7)<<
+			   MPI2_RPHI_MSIX_INDEX_SHIFT,
+			   ioc->replyPostRegisterIndex[reply_q->msix_index/8]);
+		else
+			writel(reply_q->msix_index <<
+				MPI2_RPHI_MSIX_INDEX_SHIFT,
+				&ioc->chip->ReplyPostHostIndex);
+
 		if (!_base_is_controller_msix_enabled(ioc))
 			goto skip_init_reply_post_host_index;
 	}
@@ -4740,6 +4799,9 @@ mpt3sas_base_free_resources(struct MPT3SAS_ADAPTER *ioc)
 	_base_free_irq(ioc);
 	_base_disable_msix(ioc);
 
+	if (ioc->msix96_vector)
+		kfree(ioc->replyPostRegisterIndex);
+
 	if (ioc->chip_phys && ioc->chip)
 		iounmap(ioc->chip);
 	ioc->chip_phys = 0;
@@ -4763,6 +4825,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 {
 	int r, i;
 	int cpu_id, last_cpu_id = 0;
+	u8 revision;
 
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
@@ -4782,6 +4845,20 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		goto out_free_resources;
 	}
 
+	/* Check whether the controller revision is C0 or above.
+	 * only C0 and above revision controllers support 96 MSI-X vectors.
+	 */
+	revision = ioc->pdev->revision;
+
+	if ((ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3004 ||
+	     ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3008 ||
+	     ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3108_1 ||
+	     ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3108_2 ||
+	     ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3108_5 ||
+	     ioc->pdev->device == MPI25_MFGPAGE_DEVID_SAS3108_6) &&
+	     (revision >= 0x02))
+		ioc->msix96_vector = 1;
+
 	ioc->rdpq_array_enable_assigned = 0;
 	ioc->dma_mask = 0;
 	r = mpt3sas_base_map_resources(ioc);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 86b6306..e20e73c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -190,6 +190,13 @@
 #define MPT3_DIAG_BUFFER_IS_RELEASED	(0x02)
 #define MPT3_DIAG_BUFFER_IS_DIAG_RESET	(0x04)
 
+/*
+ * Combined Reply Queue constants,
+ * There are twelve Supplemental Reply Post Host Index Registers
+ * and each register is at offset 0x10 bytes from the previous one.
+ */
+#define MPT3_SUP_REPLY_POST_HOST_INDEX_REG_COUNT 12
+#define MPT3_SUP_REPLY_POST_HOST_INDEX_REG_OFFSET (0x10)
 
 /* OEM Identifiers */
 #define MFG10_OEM_ID_INVALID                   (0x00000000)
@@ -766,7 +773,8 @@ typedef void (*MPT3SAS_FLUSH_RUNNING_CMDS)(struct MPT3SAS_ADAPTER *ioc);
  *				is assigned only ones
  * @reply_queue_count: number of reply queue's
  * @reply_queue_list: link list contaning the reply queue info
- * @reply_post_host_index: head index in the pool where FW completes IO
+ * @msix96_vector: 96 MSI-X vector support
+ * @replyPostRegisterIndex: index of next position in Reply Desc Post Queue
  * @delayed_tr_list: target reset link list
  * @delayed_tr_volume_list: volume target reset link list
  * @@temp_sensors_count: flag to carry the number of temperature sensors
@@ -974,6 +982,10 @@ struct MPT3SAS_ADAPTER {
 	u8		reply_queue_count;
 	struct list_head reply_queue_list;
 
+	u8		msix96_vector;
+	/* reply post register index */
+	resource_size_t	**replyPostRegisterIndex;
+
 	struct list_head delayed_tr_list;
 	struct list_head delayed_tr_volume_list;
 	u8		temp_sensors_count;
-- 
2.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
