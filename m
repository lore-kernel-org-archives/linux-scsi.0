From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH 8/9] scsi: bfa: Use zeroing allocator rather than allocator/memset
Date: Sat, 30 Dec 2017 20:58:31 +0530
Message-ID: <1514647712-6332-9-git-send-email-himanshujha199640@gmail.com>
References: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1514647712-6332-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@adaptec.com
Cc: anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, QLogic-Storage-Upstream@qlogic.com, satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com, QLogic-Storage-Upstream@cavium.com, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use vzalloc instead of vmalloc followed by memset 0.

Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci

Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/bfa/bfad.c         | 3 +--
 drivers/scsi/bfa/bfad_debugfs.c | 8 ++------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index bac18f6..bd7e6a6f 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -610,13 +610,12 @@ bfad_hal_mem_alloc(struct bfad_s *bfad)
 	/* Iterate through the KVA meminfo queue */
 	list_for_each(km_qe, &kva_info->qe) {
 		kva_elem = (struct bfa_mem_kva_s *) km_qe;
-		kva_elem->kva = vmalloc(kva_elem->mem_len);
+		kva_elem->kva = vzalloc(kva_elem->mem_len);
 		if (kva_elem->kva == NULL) {
 			bfad_hal_mem_release(bfad);
 			rc = BFA_STATUS_ENOMEM;
 			goto ext;
 		}
-		memset(kva_elem->kva, 0, kva_elem->mem_len);
 	}
 
 	/* Iterate through the DMA meminfo queue */
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 05f5239..349cfe7 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -81,7 +81,7 @@ bfad_debugfs_open_fwtrc(struct inode *inode, struct file *file)
 
 	fw_debug->buffer_len = sizeof(struct bfa_trc_mod_s);
 
-	fw_debug->debug_buffer = vmalloc(fw_debug->buffer_len);
+	fw_debug->debug_buffer = vzalloc(fw_debug->buffer_len);
 	if (!fw_debug->debug_buffer) {
 		kfree(fw_debug);
 		printk(KERN_INFO "bfad[%d]: Failed to allocate fwtrc buffer\n",
@@ -89,8 +89,6 @@ bfad_debugfs_open_fwtrc(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	}
 
-	memset(fw_debug->debug_buffer, 0, fw_debug->buffer_len);
-
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	rc = bfa_ioc_debug_fwtrc(&bfad->bfa.ioc,
 			fw_debug->debug_buffer,
@@ -125,7 +123,7 @@ bfad_debugfs_open_fwsave(struct inode *inode, struct file *file)
 
 	fw_debug->buffer_len = sizeof(struct bfa_trc_mod_s);
 
-	fw_debug->debug_buffer = vmalloc(fw_debug->buffer_len);
+	fw_debug->debug_buffer = vzalloc(fw_debug->buffer_len);
 	if (!fw_debug->debug_buffer) {
 		kfree(fw_debug);
 		printk(KERN_INFO "bfad[%d]: Failed to allocate fwsave buffer\n",
@@ -133,8 +131,6 @@ bfad_debugfs_open_fwsave(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	}
 
-	memset(fw_debug->debug_buffer, 0, fw_debug->buffer_len);
-
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	rc = bfa_ioc_debug_fwsave(&bfad->bfa.ioc,
 			fw_debug->debug_buffer,
-- 
2.7.4
