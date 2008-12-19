From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/PSCSI 6/6]: Grab temporary pointer to
	struct block_device for BIO for v2.6.28
Date: Fri, 19 Dec 2008 15:28:18 -0800
Message-ID: <1229729298.4560.95.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:43761 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752598AbYLSX2s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:28:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

>From 77873e8378d6ef8fdb1c6edb9cb8be478680f5d0 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 13:35:23 -0800
Subject: [PATCH] [Target_Core_Mod/PSCSI]: Grab temporary pointer to struct block_device for BIO for v2.6.28

Inside of pscsi_create_virtdevice_from_fd(), we set pscsi_dev_virt_t->pdv_bd from
struct block_device in pscsi_create_virtdevice_from_fd().  This is required because
we need to set struct bio->bi_bdev for usage with fs/bio.c:bio_add_page().

This logic for sending struct scatterlist with struct request into
struct scsi_device->request_queue will be changing post v2.6.28, but this is
currently required to get TYPE_DISK working w/o scsi_execute_async() or bio_add_pc_page().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_pscsi.c |   37 ++++++++++++++++++++++++++++++---
 drivers/lio-core/target_core_pscsi.h |    1 +
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/drivers/lio-core/target_core_pscsi.c b/drivers/lio-core/target_core_pscsi.c
index d417b1e..bcc0f72 100644
--- a/drivers/lio-core/target_core_pscsi.c
+++ b/drivers/lio-core/target_core_pscsi.c
@@ -583,6 +583,9 @@ extern void pscsi_free_device (void *p)
 	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) p;
 	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
 
+	if (pdv->pdv_bd)
+		pdv->pdv_bd = NULL;
+
 	if (sd) {
 		if ((sd->type == TYPE_DISK) || (sd->type == TYPE_ROM)) 
 			scsi_device_put(sd);
@@ -1041,6 +1044,11 @@ extern se_device_t *pscsi_create_virtdevice_from_fd (
 			return(ERR_PTR(-EINVAL));
 		}
 		/*
+		 * Keep track of the struct block_device for now, as we need it for
+		 * 
+		 */
+		pdv->pdv_bd = bd;
+		/*
 		 * pscsi_create_type_[disk,rom]() will release host_lock..
 		 */
 		spin_lock_irq(sh->host_lock);
@@ -1074,6 +1082,12 @@ extern se_device_t *pscsi_create_virtdevice_from_fd (
 		return(ERR_PTR(-ENODEV));
 	}
 
+	/*
+	 * Clear pdv->pdv_bd on exception.
+	 */
+	if (!(dev))
+		pdv->pdv_bd = NULL;
+
 	iput(inode);
 	fput(filp);
 	return(dev);
@@ -1160,7 +1174,7 @@ static void pscsi_bi_endio (struct bio *bio, int error)
 	bio_put(bio);
 }
 
-static inline struct bio *pscsi_get_bio (int sg_num)
+static inline struct bio *pscsi_get_bio (pscsi_dev_virt_t *pdv, int sg_num)
 {
 	struct bio *bio;
 
@@ -1169,11 +1183,22 @@ static inline struct bio *pscsi_get_bio (int sg_num)
 		return(NULL);
 	}
 	bio->bi_end_io = pscsi_bi_endio;
+
+	/*
+	 * While using fs/bio.c:bio_add_page() in pscsi_map_task_SG(), each
+	 * struct bio->bi_bdev needs to be set in order for bdev_get_queue()
+	 * to locate struct request_queue in bio_add_page().
+	 */
+	if (!(bio->bi_bdev = pdv->pdv_bd)) {
+		printk(KERN_ERR "PSCSI: Unable to locate struct block_device for BIO\n");
+		bio_put(bio);
+		return(NULL);
+	}
 	
 	return(bio);
 }
 
-#if 1
+#if 0
 #define DEBUG_PSCSI(x...) printk(x)
 #else
 #define DEBUG_PSCSI(x...)
@@ -1186,6 +1211,7 @@ static inline struct bio *pscsi_get_bio (int sg_num)
 extern int pscsi_map_task_SG (se_task_t *task)
 {
         pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
+	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
 	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
 	struct page *page;
 	struct request *rq = pt->pscsi_req;
@@ -1226,12 +1252,15 @@ extern int pscsi_map_task_SG (se_task_t *task)
 				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
 				nr_pages -= nr_vecs;
 
-				if (!(bio = pscsi_get_bio(nr_vecs)))
+				if (!(bio = pscsi_get_bio(pdv, nr_vecs)))
 					goto fail;	
 
 				DEBUG_PSCSI("PSCSI: Allocated bio: %p, nr_vecs: %d\n",
 					bio, nr_vecs);
-				tbio = tbio->bi_next = bio;
+				if (!tbio)
+					tbio = bio;
+				else
+					tbio = tbio->bi_next = bio;
 			}
 
 			DEBUG_PSCSI("PSCSI: Calling bio_add_page() i: %d bio: %p"
diff --git a/drivers/lio-core/target_core_pscsi.h b/drivers/lio-core/target_core_pscsi.h
index 929fbb9..8883bf6 100644
--- a/drivers/lio-core/target_core_pscsi.h
+++ b/drivers/lio-core/target_core_pscsi.h
@@ -115,6 +115,7 @@ typedef struct pscsi_dev_virt_s {
 	int	pdv_channel_id;
 	int	pdv_target_id;
 	int	pdv_lun_id;
+	struct block_device *pdv_bd; /* Temporary for v2.6.28 */
 	struct scsi_device *pdv_sd;
 	struct se_hba_s *pdv_se_hba;
 } pscsi_dev_virt_t;
-- 
1.5.4.1



