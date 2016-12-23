From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V6 02/11] megaraid_sas: 128 MSIX Support
Date: Thu, 22 Dec 2016 20:19:45 -0500
Message-ID: <1482455994-8047-3-git-send-email-sasikumar.pc@broadcom.com>
References: <1482455994-8047-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1482455994-8047-1-git-send-email-sasikumar.pc@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com
List-Id: linux-scsi@vger.kernel.org

SAS3.5 Generic Megaraid based Controllers will have the support for 128 MSI-X vectors,
resulting in the need to support 128 reply queues

This patch is depending on patch 1 and same as V5

Signed-off-by: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  1 +
 drivers/scsi/megaraid/megaraid_sas_base.c   | 25 ++++++++++++++++++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  4 ++--
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index cb82195..36aac88 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2148,6 +2148,7 @@ struct megasas_instance {
 	bool dev_handle;
 	bool fw_sync_cache_support;
 	bool is_ventura;
+	bool msix_combined;
 };
 struct MR_LD_VF_MAP {
 	u32 size;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index ea04fce..5a1a53b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5072,13 +5072,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			goto fail_ready_state;
 	}
 
-	/*
-	 * MSI-X host index 0 is common for all adapter.
-	 * It is used for all MPT based Adapters.
-	 */
-	instance->reply_post_host_index_addr[0] =
-		(u32 __iomem *)((u8 __iomem *)instance->reg_set +
-		MPI2_REPLY_POST_HOST_INDEX_OFFSET);
+
 
 	/* Check if MSI-X is supported while in ready state */
 	msix_enable = (instance->instancet->read_fw_status_reg(reg_set) &
@@ -5098,6 +5092,9 @@ static int megasas_init_fw(struct megasas_instance *instance)
 				instance->msix_vectors = ((scratch_pad_2
 					& MR_MAX_REPLY_QUEUES_EXT_OFFSET)
 					>> MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT) + 1;
+				if (instance->msix_vectors > 16)
+					instance->msix_combined = true;
+
 				if (rdpq_enable)
 					instance->is_rdpq = (scratch_pad_2 & MR_RDPQ_MODE_OFFSET) ?
 								1 : 0;
@@ -5131,6 +5128,20 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		else
 			instance->msix_vectors = 0;
 	}
+	/*
+	 * MSI-X host index 0 is common for all adapter.
+	 * It is used for all MPT based Adapters.
+	 */
+	if (instance->msix_combined) {
+		instance->reply_post_host_index_addr[0] =
+				(u32 *)((u8 *)instance->reg_set +
+				MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET);
+	} else {
+		instance->reply_post_host_index_addr[0] =
+			(u32 *)((u8 *)instance->reg_set +
+			MPI2_REPLY_POST_HOST_INDEX_OFFSET);
+	}
+
 	i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
 	if (i < 0)
 		goto fail_setup_irqs;
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 8d7a397..413e2030 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2391,7 +2391,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 		 * pending to be completed
 		 */
 		if (threshold_reply_count >= THRESHOLD_REPLY_COUNT) {
-			if (fusion->adapter_type == INVADER_SERIES)
+			if (instance->msix_combined)
 				writel(((MSIxIndex & 0x7) << 24) |
 					fusion->last_reply_idx[MSIxIndex],
 					instance->reply_post_host_index_addr[MSIxIndex/8]);
@@ -2407,7 +2407,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
 		return IRQ_NONE;
 
 	wmb();
-	if (fusion->adapter_type == INVADER_SERIES)
+	if (instance->msix_combined)
 		writel(((MSIxIndex & 0x7) << 24) |
 			fusion->last_reply_idx[MSIxIndex],
 			instance->reply_post_host_index_addr[MSIxIndex/8]);
-- 
1.8.3.1
