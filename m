From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] move all sgtable handling in one place
Date: Thu, 5 Dec 2002 17:58:42 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021205175842.A28219@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

We only need it in scsi_lib.c so the helper should be there aswell.


--- 1.77/drivers/scsi/scsi.c	Thu Nov 28 15:09:53 2002
+++ edited/drivers/scsi/scsi.c	Thu Dec  5 16:26:19 2002
@@ -55,7 +55,6 @@
 #include <linux/init.h>
 #include <linux/smp_lock.h>
 #include <linux/completion.h>
-#include <linux/mempool.h>
 
 #define __KERNEL_SYSCALLS__
 
@@ -74,24 +73,6 @@
 #include <linux/kmod.h>
 #endif
 
-#define SG_MEMPOOL_NR		5
-#define SG_MEMPOOL_SIZE		32
-
-struct scsi_host_sg_pool {
-	int size;
-	char *name; 
-	kmem_cache_t *slab;
-	mempool_t *pool;
-};
-
-#define SP(x) { x, "sgpool-" #x } 
-struct scsi_host_sg_pool scsi_sg_pools[SG_MEMPOOL_NR] = { 
-	SP(8), SP(16), SP(32), SP(64), SP(MAX_PHYS_SEGMENTS)
-}; 	
-#undef SP 	
-/*
-   static const char RCSid[] = "$Header: /vger/u4/cvs/linux/drivers/scsi/scsi.c,v 1.38 1997/01/19 23:07:18 davem Exp $";
- */
 
 /*
  * Definitions and constants.
@@ -668,10 +649,7 @@
  */
 void scsi_release_command(Scsi_Cmnd * SCpnt)
 {
-        request_queue_t *q;
-        Scsi_Device * SDpnt;
-
-        SDpnt = SCpnt->device;
+        request_queue_t *q = &SCpnt->device->request_queue;
 
         __scsi_release_command(SCpnt);
 
@@ -681,7 +659,6 @@
          * This won't block - if the device cannot take any more, life
          * will go on.  
          */
-        q = &SDpnt->request_queue;
         scsi_queue_next_request(q, NULL);                
 }
 
@@ -2084,81 +2061,12 @@
 __setup("scsi_default_dev_flags=", setup_scsi_default_dev_flags);
 
 #endif
-static void *scsi_pool_alloc(int gfp_mask, void *data)
-{
-	return kmem_cache_alloc(data, gfp_mask);
-}
-
-static void scsi_pool_free(void *ptr, void *data)
-{
-	kmem_cache_free(data, ptr);
-}
-
-struct scatterlist *scsi_alloc_sgtable(Scsi_Cmnd *SCpnt, int gfp_mask)
-{
-	struct scsi_host_sg_pool *sgp;
-	struct scatterlist *sgl;
-	int pf_flags;
-
-	BUG_ON(!SCpnt->use_sg);
-
-	switch (SCpnt->use_sg) {
-		case 1 ... 8			: SCpnt->sglist_len = 0; break;
-		case 9 ... 16			: SCpnt->sglist_len = 1; break;
-		case 17 ... 32			: SCpnt->sglist_len = 2; break;
-		case 33 ... 64			: SCpnt->sglist_len = 3; break;
-		case 65 ... MAX_PHYS_SEGMENTS	: SCpnt->sglist_len = 4; break;
-		default: return NULL;
-	}
-
-	sgp = scsi_sg_pools + SCpnt->sglist_len;
-
-	pf_flags = current->flags;
-	current->flags |= PF_NOWARN;
-	sgl = mempool_alloc(sgp->pool, gfp_mask);
-	current->flags = pf_flags;
-	if (sgl) {
-		memset(sgl, 0, sgp->size);
-		return sgl;
-	}
-
-	return sgl;
-}
-
-void scsi_free_sgtable(struct scatterlist *sgl, int index)
-{
-	struct scsi_host_sg_pool *sgp = scsi_sg_pools + index;
-
-	if (unlikely(index > SG_MEMPOOL_NR)) {
-		printk("scsi_free_sgtable: mempool %d\n", index);
-		BUG();
-	}
-
-	mempool_free(sgl, sgp->pool);
-}
 
 static int __init init_scsi(void)
 {
-	int i;
-
 	printk(KERN_INFO "SCSI subsystem driver " REVISION "\n");
 
-	/*
-	 * setup sg memory pools
-	 */
-	for (i = 0; i < SG_MEMPOOL_NR; i++) {
-		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
-		int size = sgp->size * sizeof(struct scatterlist);
-
-		sgp->slab = kmem_cache_create(sgp->name, size, 0, SLAB_HWCACHE_ALIGN, NULL, NULL);
-		if (!sgp->slab)
-			printk(KERN_ERR "SCSI: can't init sg slab %s\n", sgp->name);
-
-		sgp->pool = mempool_create(SG_MEMPOOL_SIZE, scsi_pool_alloc, scsi_pool_free, sgp->slab);
-		if (!sgp->pool)
-			printk(KERN_ERR "SCSI: can't init sg mempool %s\n", sgp->name);
-	}
-
+	scsi_init_queue();
 	scsi_init_procfs();
 	scsi_devfs_handle = devfs_mk_dir(NULL, "scsi", NULL);
 	scsi_host_init();
@@ -2170,20 +2078,11 @@
 
 static void __exit exit_scsi(void)
 {
-	int i;
-
 	scsi_sysfs_unregister();
 	scsi_dev_info_list_delete();
 	devfs_unregister(scsi_devfs_handle);
 	scsi_exit_procfs();
-
-	for (i = 0; i < SG_MEMPOOL_NR; i++) {
-		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
-		mempool_destroy(sgp->pool);
-		kmem_cache_destroy(sgp->slab);
-		sgp->pool = NULL;
-		sgp->slab = NULL;
-	}
+	scsi_exit_queue();
 }
 
 subsys_initcall(init_scsi);
--- 1.50/drivers/scsi/scsi.h	Thu Nov 28 15:09:53 2002
+++ edited/drivers/scsi/scsi.h	Thu Dec  5 16:20:29 2002
@@ -421,12 +421,6 @@
                     unsigned int *secs);
 
 /*
- * sg list allocations
- */
-struct scatterlist *scsi_alloc_sgtable(Scsi_Cmnd *SCpnt, int gfp_mask);
-void scsi_free_sgtable(struct scatterlist *sgl, int index);
-
-/*
  * Prototypes for functions in scsi_lib.c
  */
 extern int scsi_maybe_unblock_host(Scsi_Device * SDpnt);
@@ -437,13 +431,13 @@
 extern void scsi_queue_next_request(request_queue_t * q, Scsi_Cmnd * SCpnt);
 extern int scsi_prep_fn(struct request_queue *q, struct request *req);
 extern void scsi_request_fn(request_queue_t * q);
-extern int scsi_starvation_completion(Scsi_Device * SDpnt);
+extern int scsi_init_queue(void);
+extern void scsi_exit_queue(void);
 
 /*
  * Prototypes for functions in scsi.c
  */
 extern int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt);
-extern void scsi_bottom_half_handler(void);
 extern void scsi_release_commandblocks(Scsi_Device * SDpnt);
 extern void scsi_build_commandblocks(Scsi_Device * SDpnt);
 extern void scsi_adjust_queue_depth(Scsi_Device *, int, int);
@@ -462,7 +456,6 @@
 			void *buffer, unsigned bufflen,
 			void (*done) (struct scsi_cmnd *),
 			int timeout, int retries);
-extern int scsi_dev_init(void);
 extern int scsi_mlqueue_insert(struct scsi_cmnd *, int);
 extern int scsi_attach_device(struct scsi_device *);
 extern void scsi_detach_device(struct scsi_device *);
--- 1.55/drivers/scsi/scsi_lib.c	Sat Nov 23 03:45:56 2002
+++ edited/drivers/scsi/scsi_lib.c	Thu Dec  5 16:24:21 2002
@@ -11,12 +11,29 @@
 #include <linux/blk.h>
 #include <linux/completion.h>
 #include <linux/kernel.h>
+#include <linux/mempool.h>
 #include <linux/slab.h>
 
 #include "scsi.h"
 #include "hosts.h"
 
 
+#define SG_MEMPOOL_NR		5
+#define SG_MEMPOOL_SIZE		32
+
+struct scsi_host_sg_pool {
+	size_t		size;
+	char		*name; 
+	kmem_cache_t	*slab;
+	mempool_t	*pool;
+};
+
+#define SP(x) { x, "sgpool-" #x } 
+struct scsi_host_sg_pool scsi_sg_pools[SG_MEMPOOL_NR] = { 
+	SP(8), SP(16), SP(32), SP(64), SP(MAX_PHYS_SEGMENTS)
+}; 	
+#undef SP 	
+
 /*
  * Function:    scsi_insert_special_cmd()
  *
@@ -348,6 +365,51 @@
 	return NULL;
 }
 
+static struct scatterlist *scsi_alloc_sgtable(Scsi_Cmnd *SCpnt, int gfp_mask)
+{
+	struct scsi_host_sg_pool *sgp;
+	struct scatterlist *sgl;
+
+	BUG_ON(!SCpnt->use_sg);
+
+	switch (SCpnt->use_sg) {
+	case 1 ... 8:
+		SCpnt->sglist_len = 0;
+		break;
+	case 9 ... 16:
+		SCpnt->sglist_len = 1;
+		break;
+	case 17 ... 32:
+		SCpnt->sglist_len = 2;
+		break;
+	case 33 ... 64:
+		SCpnt->sglist_len = 3;
+		break;
+	case 65 ... MAX_PHYS_SEGMENTS:
+		SCpnt->sglist_len = 4;
+		break;
+	default:
+		return NULL;
+	}
+
+	sgp = scsi_sg_pools + SCpnt->sglist_len;
+	sgl = mempool_alloc(sgp->pool, gfp_mask);
+	if (sgl)
+		memset(sgl, 0, sgp->size);
+	return sgl;
+}
+
+static void scsi_free_sgtable(struct scatterlist *sgl, int index)
+{
+	struct scsi_host_sg_pool *sgp;
+
+	BUG_ON(index > SG_MEMPOOL_NR);
+
+	sgp = scsi_sg_pools + index;
+	mempool_free(sgl, sgp->pool);
+}
+
+
 /*
  * Function:    scsi_release_buffers()
  *
@@ -374,15 +436,10 @@
 	/*
 	 * Free up any indirection buffers we allocated for DMA purposes. 
 	 */
-	if (SCpnt->use_sg) {
-		struct scatterlist *sgpnt;
-
-		sgpnt = (struct scatterlist *) SCpnt->request_buffer;
+	if (SCpnt->use_sg)
 		scsi_free_sgtable(SCpnt->request_buffer, SCpnt->sglist_len);
-	} else {
-		if (SCpnt->request_buffer != req->buffer)
-			kfree(SCpnt->request_buffer);
-	}
+	else if (SCpnt->request_buffer != req->buffer)
+		kfree(SCpnt->request_buffer);
 
 	/*
 	 * Zero these out.  They now point to freed memory, and it is
@@ -462,22 +519,16 @@
 	 * For the case of a READ, we need to copy the data out of the
 	 * bounce buffer and into the real buffer.
 	 */
-	if (SCpnt->use_sg) {
-		struct scatterlist *sgpnt;
-
-		sgpnt = (struct scatterlist *) SCpnt->buffer;
+	if (SCpnt->use_sg)
 		scsi_free_sgtable(SCpnt->buffer, SCpnt->sglist_len);
-	} else {
-		if (SCpnt->buffer != req->buffer) {
-			if (rq_data_dir(req) == READ) {
-				unsigned long flags;
-				char *to = bio_kmap_irq(req->bio, &flags);
-
-				memcpy(to, SCpnt->buffer, SCpnt->bufflen);
-				bio_kunmap_irq(to, &flags);
-			}
-			kfree(SCpnt->buffer);
+	else if (SCpnt->buffer != req->buffer) {
+		if (rq_data_dir(req) == READ) {
+			unsigned long flags;
+			char *to = bio_kmap_irq(req->bio, &flags);
+			memcpy(to, SCpnt->buffer, SCpnt->bufflen);
+			bio_kunmap_irq(to, &flags);
 		}
+		kfree(SCpnt->buffer);
 	}
 
 	if (blk_pc_request(req)) {
@@ -1092,4 +1143,42 @@
 
 void scsi_deregister_blocked_host(struct Scsi_Host * SHpnt)
 {
+}
+
+int __init scsi_init_queue(void)
+{
+	int i;
+
+	for (i = 0; i < SG_MEMPOOL_NR; i++) {
+		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
+		int size = sgp->size * sizeof(struct scatterlist);
+
+		sgp->slab = kmem_cache_create(sgp->name, size, 0,
+				SLAB_HWCACHE_ALIGN, NULL, NULL);
+		if (!sgp->slab) {
+			printk(KERN_ERR "SCSI: can't init sg slab %s\n",
+					sgp->name);
+		}
+
+		sgp->pool = mempool_create(SG_MEMPOOL_SIZE,
+				mempool_alloc_slab, mempool_free_slab,
+				sgp->slab);
+		if (!sgp->pool) {
+			printk(KERN_ERR "SCSI: can't init sg mempool %s\n",
+					sgp->name);
+		}
+	}
+
+	return 0;
+}
+
+void __exit scsi_exit_lib(void)
+{
+	int i;
+
+	for (i = 0; i < SG_MEMPOOL_NR; i++) {
+		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
+		mempool_destroy(sgp->pool);
+		kmem_cache_destroy(sgp->slab);
+	}
 }
