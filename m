From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] scsi: megaraid: Use zeroing memory allocator than allocator/memset
Date: Sat, 30 Dec 2017 21:17:57 +0530
Message-ID: <1514648877-7234-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use pci_zalloc_consistent for allocating zeroed
memory and remove unnecessary memset function.

Done using Coccinelle.
Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
0-day tested with no failures.

Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 19 ++++++-------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  5 ++---
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2c8cfa2..62959d0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2222,10 +2222,9 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 			memset(instance->vf_affiliation_111, 0,
 			       sizeof(struct MR_LD_VF_AFFILIATION_111));
 	else {
-		new_affiliation_111 =
-			pci_alloc_consistent(instance->pdev,
-					     sizeof(struct MR_LD_VF_AFFILIATION_111),
-					     &new_affiliation_111_h);
+		new_affiliation_111 =
+			pci_zalloc_consistent(instance->pdev,
+					sizeof(struct MR_LD_VF_AFFILIATION_111),
+					&new_affiliation_111_h);
 		if (!new_affiliation_111) {
 			dev_printk(KERN_DEBUG, &instance->pdev->dev, "SR-IOV: Couldn't allocate "
 			       "memory for new affiliation for scsi%d\n",
@@ -2233,8 +2232,6 @@ static int megasas_get_ld_vf_affiliation_111(struct megasas_instance *instance,
 			megasas_return_cmd(instance, cmd);
 			return -ENOMEM;
 		}
-		memset(new_affiliation_111, 0,
-		       sizeof(struct MR_LD_VF_AFFILIATION_111));
 	}
 
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
@@ -2331,11 +2328,9 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 		memset(instance->vf_affiliation, 0, (MAX_LOGICAL_DRIVES + 1) *
 		       sizeof(struct MR_LD_VF_AFFILIATION));
 	else {
-		new_affiliation =
-			pci_alloc_consistent(instance->pdev,
-					     (MAX_LOGICAL_DRIVES + 1) *
-					     sizeof(struct MR_LD_VF_AFFILIATION),
-					     &new_affiliation_h);
+		new_affiliation =
+			pci_zalloc_consistent(instance->pdev,
+						(MAX_LOGICAL_DRIVES + 1) *
+						sizeof(struct MR_LD_VF_AFFILIATION),
+						&new_affiliation_h);
 		if (!new_affiliation) {
 			dev_printk(KERN_DEBUG, &instance->pdev->dev, "SR-IOV: Couldn't allocate "
 			       "memory for new affiliation for scsi%d\n",
@@ -2343,8 +2338,6 @@ static int megasas_get_ld_vf_affiliation_12(struct megasas_instance *instance,
 			megasas_return_cmd(instance, cmd);
 			return -ENOMEM;
 		}
-		memset(new_affiliation, 0, (MAX_LOGICAL_DRIVES + 1) *
-		       sizeof(struct MR_LD_VF_AFFILIATION));
 	}
 
 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 65dc4fe..5f61b93 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -690,15 +690,14 @@ megasas_alloc_rdpq_fusion(struct megasas_instance *instance)
 	array_size = sizeof(struct MPI2_IOC_INIT_RDPQ_ARRAY_ENTRY) *
 		     MAX_MSIX_QUEUES_FUSION;
 
-	fusion->rdpq_virt = pci_alloc_consistent(instance->pdev, array_size,
-						 &fusion->rdpq_phys);
+	fusion->rdpq_virt = pci_zalloc_consistent(instance->pdev, array_size,
+						  &fusion->rdpq_phys);
 	if (!fusion->rdpq_virt) {
 		dev_err(&instance->pdev->dev,
 			"Failed from %s %d\n",  __func__, __LINE__);
 		return -ENOMEM;
 	}
 
-	memset(fusion->rdpq_virt, 0, array_size);
 	msix_count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
 
 	fusion->reply_frames_desc_pool = dma_pool_create("mr_rdpq",
-- 
2.7.4
