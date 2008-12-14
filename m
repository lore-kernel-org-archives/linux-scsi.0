From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/PSCSI]: Remove usage of scsi_req_map_sg()
	for v2.6.28-FINAL
Date: Sat, 13 Dec 2008 20:17:37 -0800
Message-ID: <1229228257.4153.1114.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:42914 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751405AbYLNERl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 23:17:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Jens Axboe <jens.axboe@oracle.com>

Greetings all,

For those following along, this patch is made against lio-core-2.6.git/master
and tested on v2.6.28-rc7. The lio-core-2.6.git tree can be located at:
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git

Subject: [PATCH] [Target_Core_Mod/PSCSI]: Remove usage of scsi_req_map_sg() for v2.6.28-FINAL

This patch removes the usage of the soon to be defunct drivers/scsi/scsi_lib.c:scsi_req_map_sg().
It adds similar logic to pscsi_map_task_SG(), which just like the scsi_req_map_sg()
still depends upon BIOs when sending struct scatterlist memory into Linux/SCSI using
struct request into struct scsi_device->request_queue using block/blk-exec.c:blk_execute_rq_nowait()

This code will be changing against during v2.6.29, at which time pscsi_map_task_SG() will
be converted to get rid of BIO and use the yet-to-be-determined Linux/SCSI passthrough that accepts
struct scatterlist, struct scatterlist->page_link, or struct page.

Also, this patch removes pscsi_plugin_task_t->pscsi_buf, which was used as void * pointer
for se_task_->task_sg (for scatterlists) or T_TASK(se_cmd_t)->t_task_buf.  It also removes
the last remaining references to iSCSI.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_pscsi.c |  175 ++++++++++++++++++++++++----------
 drivers/lio-core/target_core_pscsi.h |    3 +-
 2 files changed, 125 insertions(+), 53 deletions(-)

diff --git a/drivers/lio-core/target_core_pscsi.c b/drivers/lio-core/target_core_pscsi.c
index e8a2c95..d417b1e 100644
--- a/drivers/lio-core/target_core_pscsi.c
+++ b/drivers/lio-core/target_core_pscsi.c
@@ -1,7 +1,7 @@
 /*********************************************************************************
  * Filename:  target_core_pscsi.c
  *
- * This file contains the iSCSI <-> Parallel SCSI transport specific functions.
+ * This file contains the generic target mode <-> Linux SCSI subsystem plugin.
  *
  * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
  * Copyright (c) 2005, 2006, 2007 SBE, Inc. 
@@ -69,9 +69,6 @@
 
 #define ISPRINT(a)  ((a >=' ')&&(a <= '~'))
 
-#warning FIXME: Obtain via IOCTL for Initiator Drivers
-#define INIT_CORE_NAME          "SBE, Inc. iSCSI Initiator Core"
-
 extern se_global_t *se_global;
 extern struct block_device *linux_blockdevice_claim(int, int, void *);
 extern int linux_blockdevice_release(int, int, struct block_device *);
@@ -592,7 +589,7 @@ extern void pscsi_free_device (void *p)
 
 		pdv->pdv_sd = NULL;
 	}
-	
+
 	kfree(pdv);
 	return;
 }
@@ -605,19 +602,18 @@ extern int pscsi_transport_complete (se_task_t *task)
 {
 	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
 	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
-	void *pscsi_buf;
 	int result;
 	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
 	unsigned char *cdb = &pt->pscsi_cdb[0];
 
 	result = pt->pscsi_result;
-	pscsi_buf = pt->pscsi_buf;
 
 # ifdef LINUX_EVPD_PAGE_CHECK
 	if ((cdb[0] == INQUIRY) && host_byte(result) == DID_OK) {
 		u32 len = 0;
-		unsigned char *dst = (unsigned char *)pscsi_buf, *iqn = NULL;
-		unsigned char buf[EVPD_BUF_LEN];
+		unsigned char *dst = (unsigned char *)
+				T_TASK(task->task_se_cmd)->t_task_buf;
+		unsigned char buf[EVPD_BUF_LEN], *iqn = NULL;
 		se_hba_t *hba = task->se_dev->se_hba;
 
 		/*
@@ -699,7 +695,8 @@ extern int pscsi_transport_complete (se_task_t *task)
 			goto after_mode_sense;
 
 		if (TASK_CMD(task)->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) {
-			unsigned char *buf = (unsigned char *)pscsi_buf;
+			unsigned char *buf = (unsigned char *)
+				T_TASK(task->task_se_cmd)->t_task_buf;
 
 			if (cdb[0] == MODE_SENSE_10) {
 				if (!(buf[3] & 0x80))
@@ -724,7 +721,7 @@ after_mode_sense:
 	if (((cdb[0] == MODE_SELECT) || (cdb[0] == MODE_SELECT_10)) &&
 	      (status_byte(result) << 1) == SAM_STAT_GOOD) {
 		unsigned char *buf;
-		struct scatterlist *sg = (struct scatterlist *)pscsi_buf;
+		struct scatterlist *sg = task->task_sg;
 		u16 bdl;
 		u32 blocksize;
 		
@@ -872,6 +869,10 @@ extern int pscsi_do_task (se_task_t *task)
 extern void pscsi_free_task (se_task_t *task)
 {
 	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
+	/*
+         * We do not release the bio(s) here associated with this task, as this is
+         * handled by bio_put() and pscsi_bi_endio().
+         */
 	kfree(pt);
 	return;
 }
@@ -1089,7 +1090,7 @@ extern void pscsi_get_hba_info (se_hba_t *hba, char *b, int *bl)
 {
 	struct Scsi_Host *sh = (struct Scsi_Host *) hba->hba_ptr;
 
-	*bl += sprintf(b+*bl, "iSCSI Host ID: %u  SCSI Host ID: %u\n",
+	*bl += sprintf(b+*bl, "Core Host ID: %u  SCSI Host ID: %u\n",
 			 hba->hba_id, sh->host_no);
 	*bl += sprintf(b+*bl, "        Parallel SCSI HBA: %s  <local>\n",
 		(sh->hostt->name) ? (sh->hostt->name) : "Unknown");
@@ -1154,7 +1155,29 @@ extern void __pscsi_get_dev_info (pscsi_dev_virt_t *pdv, char *b, int *bl)
 	return;
 }
 
-extern int scsi_req_map_sg(struct request *, struct scatterlist *, int,  unsigned , gfp_t );
+static void pscsi_bi_endio (struct bio *bio, int error)
+{
+	bio_put(bio);
+}
+
+static inline struct bio *pscsi_get_bio (int sg_num)
+{
+	struct bio *bio;
+
+	if (!(bio = bio_alloc(GFP_KERNEL, sg_num))) {
+		printk(KERN_ERR "PSCSI: bio_alloc() failed\n");
+		return(NULL);
+	}
+	bio->bi_end_io = pscsi_bi_endio;
+	
+	return(bio);
+}
+
+#if 1
+#define DEBUG_PSCSI(x...) printk(x)
+#else
+#define DEBUG_PSCSI(x...)
+#endif
 
 /*      pscsi_map_task_SG(): 
  *
@@ -1163,26 +1186,98 @@ extern int scsi_req_map_sg(struct request *, struct scatterlist *, int,  unsigne
 extern int pscsi_map_task_SG (se_task_t *task)
 {
         pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
-	int ret = 0;
-
-	pt->pscsi_buf = (void *)task->task_sg;
+	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
+	struct page *page;
+	struct request *rq = pt->pscsi_req;
+	struct scatterlist *sg;
+	u32 data_len = task->task_size, i, len, bytes, off;
+	int nr_pages = (task->task_size + task->task_sg[0].offset +
+			PAGE_SIZE - 1) >> PAGE_SHIFT;
+	int nr_vecs = 0, ret = 0;
 
 	if (!task->task_size)
 		return(0);
-#if 0
-	if ((ret = blk_rq_map_sg(pdv->pdv_sd->request_queue,
-			pt->pscsi_req, task->task_sg)) < 0) {
-		printk(KERN_ERR "PSCSI: blk_rq_map_sg() returned %d\n", ret);
-		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+	/*
+	 * For SCF_SCSI_DATA_SG_IO_CDB, Use fs/bio.c:bio_add_page() to setup
+	 * the bio_vec maplist from LIO-SE se_mem_t -> task->task_sg ->
+	 * struct scatterlist memory.  The se_task_t->task_sg[] currently needs
+	 * to be attached to struct bios for submission to Linux/SCSI using 
+	 * struct request to struct scsi_device->request_queue.
+	 *
+	 * Note that this will be changing post v2.6.28 as Target_Core_Mod/pSCSI
+	 * is ported to upstream SCSI passthrough functionality that accepts
+	 * struct scatterlist->page_link or struct page as a paraemeter.
+	 */
+	DEBUG_PSCSI("PSCSI: nr_pages: %d\n", nr_pages);
+
+	for_each_sg(task->task_sg, sg, task->task_sg_num, i) {
+		page = sg_page(sg);
+		off = sg->offset;
+		len = sg->length;
+
+		DEBUG_PSCSI("PSCSI: i: %d page: %p len: %d off: %d\n", i,
+			page, len, off);
+
+		while (len > 0 && data_len > 0) {
+			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
+			bytes = min(bytes, data_len);
+
+			if (!(bio)) {
+				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
+				nr_pages -= nr_vecs;
+
+				if (!(bio = pscsi_get_bio(nr_vecs)))
+					goto fail;	
+
+				DEBUG_PSCSI("PSCSI: Allocated bio: %p, nr_vecs: %d\n",
+					bio, nr_vecs);
+				tbio = tbio->bi_next = bio;
+			}
+
+			DEBUG_PSCSI("PSCSI: Calling bio_add_page() i: %d bio: %p"
+				" page: %p len: %d off: %d\n", i, bio, page,
+				len, off);
+					
+			if ((ret = bio_add_page(bio, page, bytes, off)) != bytes)
+				goto fail;
+
+			DEBUG_PSCSI("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
+				bio->bi_vcnt, nr_vecs);
+
+			if (bio->bi_vcnt >= nr_vecs) {
+				bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+				if (rq_data_dir(rq) == WRITE)
+					bio->bi_rw |= (1 << BIO_RW);
+				blk_queue_bounce(rq->q, &bio);
+
+				DEBUG_PSCSI("PSCSI: Calling blk_rq_append_bio(): i: %d"
+						" bio: %p\n", i, bio);
+				if ((ret = blk_rq_append_bio(rq->q, rq, bio)) < 0)
+					goto fail;
+
+				bio = NULL;
+			}
+
+			page++;
+			len -= bytes;
+			data_len -= bytes;
+			off = 0;
+				
+		}
 	}
-#else
-	if ((ret = scsi_req_map_sg(pt->pscsi_req, task->task_sg,
-			task->task_sg_num, task->task_size, GFP_KERNEL)) < 0) {
-		printk(KERN_ERR "PSCSI: scsi_req_map_sg() failed: %d\n", ret);
-		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
+
+	rq->buffer = rq->data = NULL;
+	rq->data_len = task->task_size;
+
+	return(task->task_sg_num);
+fail:
+	while (hbio) {
+		bio = hbio;
+		hbio = hbio->bi_next;
+		bio->bi_next = NULL;
+		bio_endio(bio, 0);
 	}
-#endif
-	return(0);
+	return(ret);
 }
 
 /*	pscsi_map_task_non_SG():
@@ -1193,17 +1288,14 @@ extern int pscsi_map_task_non_SG (se_task_t *task)
 {
 	se_cmd_t *cmd = TASK_CMD(task);
 	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
-	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
 	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
 	int ret = 0;
 
-	pt->pscsi_buf = (void *)buf;
-
 	if (!task->task_size)
 		return(0);
 
 	if ((ret = blk_rq_map_kern(pdv->pdv_sd->request_queue,
-			pt->pscsi_req, pt->pscsi_buf,
+			pt->pscsi_req, T_TASK(cmd)->t_task_buf,
 			task->task_size, GFP_KERNEL)) < 0) {
 		printk(KERN_ERR "PSCSI: blk_rq_map_kern() failed: %d\n", ret);
 		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
@@ -1416,25 +1508,6 @@ extern u32 pscsi_get_queue_depth (se_device_t *dev)
 
 extern void pscsi_shutdown_hba (se_hba_t *hba)
 {
-	struct Scsi_Host *sh = (struct Scsi_Host *)hba->hba_ptr;
-
-	if (strcmp(sh->hostt->name, INIT_CORE_NAME)) {
-		/*
-		 * Perhaps we could force a host-reset here if outstanding tasks
-		 * have not come back..
-		 */
-		return;
-	}
-#warning FIXME: iscsi_global breakage in iscsi_target_pscsi.c
-#if 0	
-	if (!iscsi_global->ti_forcechanoffline)
-		return;
-	
-	/*
-	 * Notify the iSCSI Initiator to perform pause/forcechanoffline operations
-	 */
-	iscsi_global->ti_forcechanoffline(hba->hba_ptr);
-#endif
 	return;
 }
 
diff --git a/drivers/lio-core/target_core_pscsi.h b/drivers/lio-core/target_core_pscsi.h
index c70bb65..929fbb9 100644
--- a/drivers/lio-core/target_core_pscsi.h
+++ b/drivers/lio-core/target_core_pscsi.h
@@ -1,7 +1,7 @@
 /*********************************************************************************
  * Filename:  target_core_pscsi.h
  *
- * This file contains the iSCSI <-> Parallel SCSI transport
+ * This file contains the generic target mode <-> Linux SCSI subsystem plugin.
  * specific definitions and prototypes.
  *
  * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
@@ -101,7 +101,6 @@ typedef struct pscsi_plugin_task_s {
 	int	pscsi_direction;
 	int	pscsi_result;
 	u32	pscsi_resid;
-	void	*pscsi_buf;
 	struct request *pscsi_req;
 } pscsi_plugin_task_t;
 
-- 
1.5.4.1



