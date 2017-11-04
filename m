From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: [PATCH] scsi: Use vzalloc instead of vmalloc/memset
Date: Sun,  5 Nov 2017 03:26:26 +0530
Message-ID: <1509832586-1429-1-git-send-email-himanshujha199640@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: anil.gurumurthy@qlogic.com
Cc: sudarsana.kalluru@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, qla2xxx-upstream@qlogic.com, kartilak@cisco.com, sebaddel@cisco.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org, Himanshu Jha <himanshujha199640@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Use vzalloc instead of vmalloc/memset to allocate memory filled with 0
value.

Done using Coccinelle.
Semantic patch used :

@@
expression x,a;
statement S;
@@

- x = vmalloc(a);
+ x = vzalloc(a);
  if (x == NULL || ...) S
- memset(x, 0, a);

Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
---
 drivers/scsi/bfa/bfad.c            | 3 +--
 drivers/scsi/bfa/bfad_debugfs.c    | 8 ++------
 drivers/scsi/qla2xxx/qla_bsg.c     | 3 +--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 5 +----
 drivers/scsi/scsi_debug.c          | 6 ++----
 drivers/scsi/snic/snic_trc.c       | 3 +--
 6 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 5caf5f3..ab91c59 100644
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
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index e3ac707..fdd9059 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1435,7 +1435,7 @@ qla2x00_optrom_setup(struct bsg_job *bsg_job, scsi_qla_host_t *vha,
 		ha->optrom_state = QLA_SREADING;
 	}
 
-	ha->optrom_buffer = vmalloc(ha->optrom_region_size);
+	ha->optrom_buffer = vzalloc(ha->optrom_region_size);
 	if (!ha->optrom_buffer) {
 		ql_log(ql_log_warn, vha, 0x7059,
 		    "Read: Unable to allocate memory for optrom retrieval "
@@ -1445,7 +1445,6 @@ qla2x00_optrom_setup(struct bsg_job *bsg_job, scsi_qla_host_t *vha,
 		return -ENOMEM;
 	}
 
-	memset(ha->optrom_buffer, 0, ha->optrom_region_size);
 	return 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 3f82ea1..aadfeaa 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1635,16 +1635,13 @@ static int tcm_qla2xxx_init_lport(struct tcm_qla2xxx_lport *lport)
 		return rc;
 	}
 
-	lport->lport_loopid_map = vmalloc(sizeof(struct tcm_qla2xxx_fc_loopid) *
-				65536);
+	lport->lport_loopid_map = vzalloc(sizeof(struct tcm_qla2xxx_fc_loopid) * 65536);
 	if (!lport->lport_loopid_map) {
 		pr_err("Unable to allocate lport->lport_loopid_map of %zu bytes\n",
 		    sizeof(struct tcm_qla2xxx_fc_loopid) * 65536);
 		btree_destroy32(&lport->lport_fcport_map);
 		return -ENOMEM;
 	}
-	memset(lport->lport_loopid_map, 0, sizeof(struct tcm_qla2xxx_fc_loopid)
-	       * 65536);
 	pr_debug("qla2xxx: Allocated lport_loopid_map of %zu bytes\n",
 	       sizeof(struct tcm_qla2xxx_fc_loopid) * 65536);
 	return 0;
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index e4f037f..d0e7233 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4500,12 +4500,11 @@ static ssize_t fake_rw_store(struct device_driver *ddp, const char *buf,
 					(unsigned long)sdebug_dev_size_mb *
 					1048576;
 
-				fake_storep = vmalloc(sz);
+				fake_storep = vzalloc(sz);
 				if (NULL == fake_storep) {
 					pr_err("out of memory, 9\n");
 					return -ENOMEM;
 				}
-				memset(fake_storep, 0, sz);
 			}
 			sdebug_fake_rw = n;
 		}
@@ -5028,13 +5027,12 @@ static int __init scsi_debug_init(void)
 	}
 
 	if (sdebug_fake_rw == 0) {
-		fake_storep = vmalloc(sz);
+		fake_storep = vzalloc(sz);
 		if (NULL == fake_storep) {
 			pr_err("out of memory, 1\n");
 			ret = -ENOMEM;
 			goto free_q_arr;
 		}
-		memset(fake_storep, 0, sz);
 		if (sdebug_num_parts > 0)
 			sdebug_build_parts(fake_storep, sz);
 	}
diff --git a/drivers/scsi/snic/snic_trc.c b/drivers/scsi/snic/snic_trc.c
index f00ebf4..dd47f50 100644
--- a/drivers/scsi/snic/snic_trc.c
+++ b/drivers/scsi/snic/snic_trc.c
@@ -126,7 +126,7 @@ snic_trc_init(void)
 	int tbuf_sz = 0, ret;
 
 	tbuf_sz = (snic_trace_max_pages * PAGE_SIZE);
-	tbuf = vmalloc(tbuf_sz);
+	tbuf = vzalloc(tbuf_sz);
 	if (!tbuf) {
 		SNIC_ERR("Failed to Allocate Trace Buffer Size. %d\n", tbuf_sz);
 		SNIC_ERR("Trace Facility not enabled.\n");
@@ -135,7 +135,6 @@ snic_trc_init(void)
 		return ret;
 	}
 
-	memset(tbuf, 0, tbuf_sz);
 	trc->buf = (struct snic_trc_data *) tbuf;
 	spin_lock_init(&trc->lock);
 
-- 
2.7.4
