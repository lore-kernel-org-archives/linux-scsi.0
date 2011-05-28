From: Joe Perches <joe@perches.com>
Subject: [TRIVIAL PATCH next 10/15] scsi: Convert vmalloc/memset to vzalloc
Date: Sat, 28 May 2011 10:36:30 -0700
Message-ID: <70385dc309ccf2d44eebc2cb41ce31bc430da7da.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1306603968.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jing Huang <huangj@brocade.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, "James E.J. Bottomley" <James.Bottomley@suse.de>, Jiri Kosina <trivial@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bfa/bfad.c         |    3 +--
 drivers/scsi/bfa/bfad_debugfs.c |    8 ++------
 drivers/scsi/cxgbi/libcxgbi.h   |    6 ++----
 drivers/scsi/qla2xxx/qla_attr.c |    6 ++----
 drivers/scsi/qla2xxx/qla_bsg.c  |    3 +--
 drivers/scsi/scsi_debug.c       |    7 ++-----
 6 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 59b5e9b..fc6bb02 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -612,13 +612,12 @@ retry:
 		meminfo_elem = &hal_meminfo->meminfo[i];
 		switch (meminfo_elem->mem_type) {
 		case BFA_MEM_TYPE_KVA:
-			kva = vmalloc(meminfo_elem->mem_len);
+			kva = vzalloc(meminfo_elem->mem_len);
 			if (kva == NULL) {
 				bfad_hal_mem_release(bfad);
 				rc = BFA_STATUS_ENOMEM;
 				goto ext;
 			}
-			memset(kva, 0, meminfo_elem->mem_len);
 			meminfo_elem->kva = kva;
 			break;
 		case BFA_MEM_TYPE_DMA:
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 48be0c5..469b0fc 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -79,7 +79,7 @@ bfad_debugfs_open_fwtrc(struct inode *inode, struct file *file)
 
 	fw_debug->buffer_len = sizeof(struct bfa_trc_mod_s);
 
-	fw_debug->debug_buffer = vmalloc(fw_debug->buffer_len);
+	fw_debug->debug_buffer = vzalloc(fw_debug->buffer_len);
 	if (!fw_debug->debug_buffer) {
 		kfree(fw_debug);
 		printk(KERN_INFO "bfad[%d]: Failed to allocate fwtrc buffer\n",
@@ -87,8 +87,6 @@ bfad_debugfs_open_fwtrc(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	}
 
-	memset(fw_debug->debug_buffer, 0, fw_debug->buffer_len);
-
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	rc = bfa_ioc_debug_fwtrc(&bfad->bfa.ioc,
 			fw_debug->debug_buffer,
@@ -123,7 +121,7 @@ bfad_debugfs_open_fwsave(struct inode *inode, struct file *file)
 
 	fw_debug->buffer_len = sizeof(struct bfa_trc_mod_s);
 
-	fw_debug->debug_buffer = vmalloc(fw_debug->buffer_len);
+	fw_debug->debug_buffer = vzalloc(fw_debug->buffer_len);
 	if (!fw_debug->debug_buffer) {
 		kfree(fw_debug);
 		printk(KERN_INFO "bfad[%d]: Failed to allocate fwsave buffer\n",
@@ -131,8 +129,6 @@ bfad_debugfs_open_fwsave(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	}
 
-	memset(fw_debug->debug_buffer, 0, fw_debug->buffer_len);
-
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	rc = bfa_ioc_debug_fwsave(&bfad->bfa.ioc,
 			fw_debug->debug_buffer,
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 9267844..e4c3d63 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -658,11 +658,9 @@ static inline u32 cxgbi_tag_nonrsvd_bits(struct cxgbi_tag_format *tformat,
 static inline void *cxgbi_alloc_big_mem(unsigned int size,
 					gfp_t gfp)
 {
-	void *p = kmalloc(size, gfp);
+	void *p = kzalloc(size, gfp);
 	if (!p)
-		p = vmalloc(size);
-	if (p)
-		memset(p, 0, size);
+		p = vzalloc(size);
 	return p;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 532313e..31634dc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -271,7 +271,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		    ha->optrom_size - start : size;
 
 		ha->optrom_state = QLA_SREADING;
-		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
+		ha->optrom_buffer = vzalloc(ha->optrom_region_size);
 		if (ha->optrom_buffer == NULL) {
 			qla_printk(KERN_WARNING, ha,
 			    "Unable to allocate memory for optrom retrieval "
@@ -291,7 +291,6 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		    "Reading flash region -- 0x%x/0x%x.\n",
 		    ha->optrom_region_start, ha->optrom_region_size));
 
-		memset(ha->optrom_buffer, 0, ha->optrom_region_size);
 		ha->isp_ops->read_optrom(vha, ha->optrom_buffer,
 		    ha->optrom_region_start, ha->optrom_region_size);
 		break;
@@ -338,7 +337,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		    ha->optrom_size - start : size;
 
 		ha->optrom_state = QLA_SWRITING;
-		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
+		ha->optrom_buffer = vzalloc(ha->optrom_region_size);
 		if (ha->optrom_buffer == NULL) {
 			qla_printk(KERN_WARNING, ha,
 			    "Unable to allocate memory for optrom update "
@@ -352,7 +351,6 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		    "Staging flash region write -- 0x%x/0x%x.\n",
 		    ha->optrom_region_start, ha->optrom_region_size));
 
-		memset(ha->optrom_buffer, 0, ha->optrom_region_size);
 		break;
 	case 3:
 		if (ha->optrom_state != QLA_SWRITING)
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 8c10e2c..5f4e574 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1356,7 +1356,7 @@ qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, struct qla_hw_data *ha,
 		ha->optrom_state = QLA_SREADING;
 	}
 
-	ha->optrom_buffer = vmalloc(ha->optrom_region_size);
+	ha->optrom_buffer = vzalloc(ha->optrom_region_size);
 	if (!ha->optrom_buffer) {
 		qla_printk(KERN_WARNING, ha,
 		    "Read: Unable to allocate memory for optrom retrieval "
@@ -1366,7 +1366,6 @@ qla2x00_optrom_setup(struct fc_bsg_job *bsg_job, struct qla_hw_data *ha,
 		return -ENOMEM;
 	}
 
-	memset(ha->optrom_buffer, 0, ha->optrom_region_size);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6888b2c..185d465 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3334,12 +3334,11 @@ static int __init scsi_debug_init(void)
 			       (sdebug_sectors_per * sdebug_heads);
 	}
 
-	fake_storep = vmalloc(sz);
+	fake_storep = vzalloc(sz);
 	if (NULL == fake_storep) {
 		printk(KERN_ERR "scsi_debug_init: out of memory, 1\n");
 		return -ENOMEM;
 	}
-	memset(fake_storep, 0, sz);
 	if (scsi_debug_num_parts > 0)
 		sdebug_build_parts(fake_storep, sz);
 
@@ -3384,7 +3383,7 @@ static int __init scsi_debug_init(void)
 
 		map_size = (sdebug_store_sectors / scsi_debug_unmap_granularity);
 		map_bytes = map_size >> 3;
-		map_storep = vmalloc(map_bytes);
+		map_storep = vzalloc(map_bytes);
 
 		printk(KERN_INFO "scsi_debug_init: %lu provisioning blocks\n",
 		       map_size);
@@ -3395,8 +3394,6 @@ static int __init scsi_debug_init(void)
 			goto free_vm;
 		}
 
-		memset(map_storep, 0x0, map_bytes);
-
 		/* Map first 1KB for partition table */
 		if (scsi_debug_num_parts)
 			map_region(0, 2);
-- 
1.7.5.rc3.dirty
