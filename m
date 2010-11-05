From: Joe Perches <joe@perches.com>
Subject: [PATCH 34/49] drivers/scsi: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:58 -0700
Message-ID: <a5b5595719fe07b0d6b1c0bced4c70179c5b30df.1288925425.git.joe@perches.com>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4152 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab0KEDJB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:01 -0400
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: Jing Huang <huangj@brocade.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Willem Riede <osst@riede.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, osst-users@lists.sourceforge.net

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/bfa/bfad.c         |    3 +--
 drivers/scsi/bfa/bfad_debugfs.c |    8 ++------
 drivers/scsi/cxgbi/libcxgbi.h   |    9 +++------
 drivers/scsi/osst.c             |    3 +--
 drivers/scsi/qla2xxx/qla_attr.c |    3 +--
 drivers/scsi/qla2xxx/qla_bsg.c  |    3 +--
 drivers/scsi/scsi_debug.c       |    7 ++-----
 7 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 1f93897..10dc5d2 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -600,13 +600,12 @@ retry:
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
index 1fedeeb..0f7af51 100644
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
 	rc = bfa_debug_fwtrc(&bfad->bfa,
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
 	rc = bfa_debug_fwsave(&bfad->bfa,
 			fw_debug->debug_buffer,
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index c57d59d..7627e37 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -658,14 +658,11 @@ static inline u32 cxgbi_tag_nonrsvd_bits(struct cxgbi_tag_format *tformat,
 	return v1 | v2;
 }
 
-static inline void *cxgbi_alloc_big_mem(unsigned int size,
-					gfp_t gfp)
+static inline void *cxgbi_alloc_big_mem(unsigned int size, gfp_t gfp)
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
 
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 54de1d1..02bc1cc 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -2296,11 +2296,10 @@ static int osst_write_header(struct osst_tape * STp, struct osst_request ** aSRp
 	if (STp->raw) return 0;
 
 	if (STp->header_cache == NULL) {
-		if ((STp->header_cache = (os_header_t *)vmalloc(sizeof(os_header_t))) == NULL) {
+		if ((STp->header_cache = vzalloc(sizeof(os_header_t))) == NULL) {
 			printk(KERN_ERR "%s:E: Failed to allocate header cache\n", name);
 			return (-ENOMEM);
 		}
-		memset(STp->header_cache, 0, sizeof(os_header_t));
 #if DEBUG
 		printk(OSST_DEB_MSG "%s:D: Allocated and cleared memory for header cache\n", name);
 #endif
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index bc8194f..7151b04 100644
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
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 31a4121..27f7f79 100644
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
index 2c36bae..e6aaad4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3305,12 +3305,11 @@ static int __init scsi_debug_init(void)
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
 
@@ -3355,7 +3354,7 @@ static int __init scsi_debug_init(void)
 
 		map_size = (sdebug_store_sectors / scsi_debug_unmap_granularity);
 		map_bytes = map_size >> 3;
-		map_storep = vmalloc(map_bytes);
+		map_storep = vzalloc(map_bytes);
 
 		printk(KERN_INFO "scsi_debug_init: %lu provisioning blocks\n",
 		       map_size);
@@ -3366,8 +3365,6 @@ static int __init scsi_debug_init(void)
 			goto free_vm;
 		}
 
-		memset(map_storep, 0x0, map_bytes);
-
 		/* Map first 1KB for partition table */
 		if (scsi_debug_num_parts)
 			map_region(0, 2);
-- 
1.7.3.1.g432b3.dirty

