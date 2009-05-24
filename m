From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 07/10] libosd: Define an osd_dev wrapper to retrieve the request_queue
Date: Sun, 24 May 2009 20:04:43 +0300
Message-ID: <1243184683-17087-1-git-send-email-bharrosh@panasas.com>
References: <4A197CB5.60709@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:2132 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754207AbZEXREp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2009 13:04:45 -0400
In-Reply-To: <4A197CB5.60709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
Cc: Jeff Garzik <jeff@garzik.org>

libosd users that need to work with bios, must sometime use
the request_queue associated with the osd_dev. Make a wrapper for
that, and convert all in-tree users.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    6 +++---
 fs/exofs/inode.c                 |    3 +--
 include/scsi/osd_initiator.h     |    5 +++++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 3f5ec57..3959797 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -670,7 +670,7 @@ static int _osd_req_list_objects(struct osd_request *or,
 	__be16 action, const struct osd_obj_id *obj, osd_id initial_id,
 	struct osd_obj_id_list *list, unsigned nelem)
 {
-	struct request_queue *q = or->osd_dev->scsi_device->request_queue;
+	struct request_queue *q = osd_request_queue(or->osd_dev);
 	u64 len = nelem * sizeof(osd_id) + sizeof(*list);
 	struct bio *bio;
 
@@ -793,7 +793,7 @@ EXPORT_SYMBOL(osd_req_write);
 int osd_req_write_kern(struct osd_request *or,
 	const struct osd_obj_id *obj, u64 offset, void* buff, u64 len)
 {
-	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
+	struct request_queue *req_q = osd_request_queue(or->osd_dev);
 	struct bio *bio = bio_map_kern(req_q, buff, len, GFP_KERNEL);
 
 	if (IS_ERR(bio))
@@ -844,7 +844,7 @@ EXPORT_SYMBOL(osd_req_read);
 int osd_req_read_kern(struct osd_request *or,
 	const struct osd_obj_id *obj, u64 offset, void* buff, u64 len)
 {
-	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
+	struct request_queue *req_q = osd_request_queue(or->osd_dev);
 	struct bio *bio = bio_map_kern(req_q, buff, len, GFP_KERNEL);
 
 	if (IS_ERR(bio))
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index f79e8e5..77d0a29 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -59,10 +59,9 @@ static void _pcol_init(struct page_collect *pcol, unsigned expected_pages,
 		struct inode *inode)
 {
 	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
-	struct request_queue *req_q = sbi->s_dev->scsi_device->request_queue;
 
 	pcol->sbi = sbi;
-	pcol->req_q = req_q;
+	pcol->req_q = osd_request_queue(sbi->s_dev);
 	pcol->inode = inode;
 	pcol->expected_pages = expected_pages;
 
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 8c1e3b8..b44dc53 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -18,6 +18,7 @@
 #include "osd_types.h"
 
 #include <linux/blkdev.h>
+#include <scsi/scsi_device.h>
 
 /* Note: "NI" in comments below means "Not Implemented yet" */
 
@@ -69,6 +70,10 @@ void osd_dev_fini(struct osd_dev *od);
 
 /* some hi level device operations */
 int osd_auto_detect_ver(struct osd_dev *od, void *caps);    /* GFP_KERNEL */
+static inline struct request_queue *osd_request_queue(struct osd_dev *od)
+{
+	return od->scsi_device->request_queue;
+}
 
 /* we might want to use function vector in the future */
 static inline void osd_dev_set_ver(struct osd_dev *od, enum osd_std_version v)
-- 
1.6.2.1

