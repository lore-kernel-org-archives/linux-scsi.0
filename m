From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 04/10 resend] libosd: osd_req_{read,write}_kern new API
Date: Sun, 24 May 2009 20:02:22 +0300
Message-ID: <1243184542-16993-1-git-send-email-bharrosh@panasas.com>
References: <4A197CB5.60709@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:1717 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754207AbZEXRDk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2009 13:03:40 -0400
In-Reply-To: <4A197CB5.60709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
Cc: Jeff Garzik <jeff@garzik.org>

By popular demand, define usefull wrappers for osd_req_read/write
that recieve kernel pointers. All users had their own.

Also remove these from exofs

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   28 ++++++++++++++++++++++++++++
 fs/exofs/common.h                |    6 ------
 fs/exofs/osd.c                   |   26 --------------------------
 include/scsi/osd_initiator.h     |    4 ++++
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 15f0bbc..c98153b 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -789,6 +789,20 @@ void osd_req_write(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_write);
 
+int osd_req_write_kern(struct osd_request *or,
+	const struct osd_obj_id *obj, u64 offset, void* buff, u64 len)
+{
+	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
+	struct bio *bio = bio_map_kern(req_q, buff, len, GFP_KERNEL);
+
+	if (IS_ERR(bio))
+		return PTR_ERR(bio);
+
+	osd_req_write(or, obj, bio, offset);
+	return 0;
+}
+EXPORT_SYMBOL(osd_req_write_kern);
+
 /*TODO: void osd_req_append(struct osd_request *,
 	const struct osd_obj_id *, struct bio *data_out); */
 /*TODO: void osd_req_create_write(struct osd_request *,
@@ -824,6 +838,20 @@ void osd_req_read(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_read);
 
+int osd_req_read_kern(struct osd_request *or,
+	const struct osd_obj_id *obj, u64 offset, void* buff, u64 len)
+{
+	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
+	struct bio *bio = bio_map_kern(req_q, buff, len, GFP_KERNEL);
+
+	if (IS_ERR(bio))
+		return PTR_ERR(bio);
+
+	osd_req_read(or, obj, bio, offset);
+	return 0;
+}
+EXPORT_SYMBOL(osd_req_read_kern);
+
 void osd_req_get_attributes(struct osd_request *or,
 	const struct osd_obj_id *obj)
 {
diff --git a/fs/exofs/common.h b/fs/exofs/common.h
index b1512c4..24667ee 100644
--- a/fs/exofs/common.h
+++ b/fs/exofs/common.h
@@ -175,10 +175,4 @@ int exofs_async_op(struct osd_request *or,
 
 int extract_attr_from_req(struct osd_request *or, struct osd_attr *attr);
 
-int osd_req_read_kern(struct osd_request *or,
-	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
-
-int osd_req_write_kern(struct osd_request *or,
-	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
-
 #endif /*ifndef __EXOFS_COM_H__*/
diff --git a/fs/exofs/osd.c b/fs/exofs/osd.c
index b249ae9..48cc4d1 100644
--- a/fs/exofs/osd.c
+++ b/fs/exofs/osd.c
@@ -125,29 +125,3 @@ int extract_attr_from_req(struct osd_request *or, struct osd_attr *attr)
 
 	return -EIO;
 }
-
-int osd_req_read_kern(struct osd_request *or,
-	const struct osd_obj_id *obj, u64 offset, void* buff, u64 len)
-{
-	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
-	struct bio *bio = bio_map_kern(req_q, buff, len, GFP_KERNEL);
-
-	if (!bio)
-		return -ENOMEM;
-
-	osd_req_read(or, obj, bio, offset);
-	return 0;
-}
-
-int osd_req_write_kern(struct osd_request *or,
-	const struct osd_obj_id *obj, u64 offset, void* buff, u64 len)
-{
-	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
-	struct bio *bio = bio_map_kern(req_q, buff, len, GFP_KERNEL);
-
-	if (!bio)
-		return -ENOMEM;
-
-	osd_req_write(or, obj, bio, offset);
-	return 0;
-}
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index b24d961..6132790 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -364,6 +364,8 @@ void osd_req_remove_object(struct osd_request *or, struct osd_obj_id *);
 
 void osd_req_write(struct osd_request *or,
 	const struct osd_obj_id *, struct bio *data_out, u64 offset);
+int osd_req_write_kern(struct osd_request *or,
+	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
 void osd_req_append(struct osd_request *or,
 	const struct osd_obj_id *, struct bio *data_out);/* NI */
 void osd_req_create_write(struct osd_request *or,
@@ -379,6 +381,8 @@ void osd_req_flush_object(struct osd_request *or,
 
 void osd_req_read(struct osd_request *or,
 	const struct osd_obj_id *, struct bio *data_in, u64 offset);
+int osd_req_read_kern(struct osd_request *or,
+	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
 
 /*
  * Root/Partition/Collection/Object Attributes commands
-- 
1.6.2.1

