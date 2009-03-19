From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC C 3/5] libosd: No bio for you
Date: Thu, 19 Mar 2009 16:35:51 +0200
Message-ID: <49C25847.6000903@panasas.com>
References: <49C254FD.7020202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:8271 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754127AbZCSOhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Mar 2009 10:37:06 -0400
In-Reply-To: <49C254FD.7020202@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scs


Change osd_initiator API to not be bio based.
The new API will receive an array of pages to
write/read from. The pages info is held in a new
struct osd_page_array.

At osd_finalize_request the code uses the new
blk_rq_map_pages() API to build the request for
submission.

this patch is dependent on a block layer patch titled:
   [BLOCK] blk_rq_map_pages() new API

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |  109 +++++++++++++++++++++-----------------
 include/scsi/osd_initiator.h     |   31 +++++++++--
 2 files changed, 88 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 8885524..d18402c 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -52,10 +52,6 @@
 #    define __unused			__attribute__((unused))
 #endif
 
-/* FIXME: Temporarly until next patch */
-#define osd_req_write osd_req_write_old
-#define osd_req_read  osd_req_read_old
-
 enum { OSD_REQ_RETRIES = 1 };
 
 MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
@@ -585,25 +581,15 @@ static int _osd_req_list_objects(struct osd_request *or,
 	__be16 action, const struct osd_obj_id *obj, osd_id initial_id,
 	struct osd_obj_id_list *list, unsigned nelem)
 {
-	struct request_queue *q = or->osd_dev->scsi_device->request_queue;
 	u64 len = nelem * sizeof(osd_id) + sizeof(*list);
-	struct bio *bio;
 
 	_osd_req_encode_common(or, action, obj, (u64)initial_id, len);
 
 	if (list->list_identifier)
 		_osd_req_encode_olist(or, list);
 
-	WARN_ON(or->in.bio);
-	bio = bio_map_kern(q, list, len, or->alloc_flags);
-	if (!bio) {
-		OSD_ERR("!!! Failed to allocate list_objects BIO\n");
-		return -ENOMEM;
-	}
-
-	bio->bi_rw &= ~(1 << BIO_RW);
-	or->in.bio = bio;
-	or->in.total_bytes = bio->bi_size;
+	opa_map_kern(&or->in.opa, list, len);
+	or->in.total_bytes = len;
 	return 0;
 }
 
@@ -693,27 +679,35 @@ EXPORT_SYMBOL(osd_req_remove_object);
 	struct osd_obj_id *first, struct osd_obj_id_list *list, unsigned nelem);
 */
 
-void osd_req_write(struct osd_request *or,
+void osd_req_write_old(struct osd_request *or,
 	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
 {
-	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, bio->bi_size);
-	WARN_ON(or->out.bio || or->out.total_bytes);
-	bio->bi_rw |= (1 << BIO_RW);
-	or->out.bio = bio;
-	or->out.total_bytes = bio->bi_size;
+	BUG_ON(1);
+}
+EXPORT_SYMBOL(osd_req_write_old);
+
+void osd_req_write(struct osd_request *or,
+	const struct osd_obj_id *obj, const struct osd_pages_array *opa,
+	u64 offset)
+{
+	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, opa->length);
+
+	WARN_ON(or->out.total_bytes);
+	WARN_ON(or->out.opa.length);
+	or->out.opa = *opa;
+	or->out.total_bytes = opa->length;
 }
 EXPORT_SYMBOL(osd_req_write);
 
 int osd_req_write_kern(struct osd_request *or,
-	const struct osd_obj_id *obj, u64 offset, void* buff, u64 len)
+	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len)
 {
-	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
-	struct bio *bio = bio_map_kern(req_q, buff, len, GFP_KERNEL);
+	struct osd_pages_array opa;
 
-	if (!bio)
-		return -ENOMEM;
+	memset(&opa, 0, sizeof(opa));
+	opa_map_kern(&opa, buff, len);
 
-	osd_req_write(or, obj, bio, offset);
+	osd_req_write(or, obj, &opa, offset);
 	return 0;
 }
 EXPORT_SYMBOL(osd_req_write_kern);
@@ -742,27 +736,35 @@ void osd_req_flush_object(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_flush_object);
 
-void osd_req_read(struct osd_request *or,
+void osd_req_read_old(struct osd_request *or,
 	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
 {
-	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, bio->bi_size);
-	WARN_ON(or->in.bio || or->in.total_bytes);
-	bio->bi_rw &= ~(1 << BIO_RW);
-	or->in.bio = bio;
-	or->in.total_bytes = bio->bi_size;
+	BUG_ON(1);
+}
+EXPORT_SYMBOL(osd_req_read_old);
+
+void osd_req_read(struct osd_request *or,
+	const struct osd_obj_id *obj, const struct osd_pages_array *opa,
+	u64 offset)
+{
+	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, opa->length);
+
+	WARN_ON(or->in.total_bytes);
+	WARN_ON(or->in.opa.length);
+	or->in.opa = *opa;
+	or->in.total_bytes = opa->length;
 }
 EXPORT_SYMBOL(osd_req_read);
 
 int osd_req_read_kern(struct osd_request *or,
-	const struct osd_obj_id *obj, u64 offset, void* buff, u64 len)
+	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len)
 {
-	struct request_queue *req_q = or->osd_dev->scsi_device->request_queue;
-	struct bio *bio = bio_map_kern(req_q, buff, len, GFP_KERNEL);
+	struct osd_pages_array opa;
 
-	if (!bio)
-		return -ENOMEM;
+	memset(&opa, 0, sizeof(opa));
+	opa_map_kern(&opa, buff, len);
 
-	osd_req_read(or, obj, bio, offset);
+	osd_req_read(or, obj, &opa, offset);
 	return 0;
 }
 EXPORT_SYMBOL(osd_req_read_kern);
@@ -1168,7 +1170,7 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 		unsigned pad;
 
 		or->out_data_integ.data_bytes = cpu_to_be64(
-			or->out.bio ? or->out.bio->bi_size : 0);
+			or->out.opa.length ?: 0);
 		or->out_data_integ.set_attributes_bytes = cpu_to_be64(
 			or->set_attr.total_bytes);
 		or->out_data_integ.get_attributes_bytes = cpu_to_be64(
@@ -1255,6 +1257,18 @@ out:
 	return ret;
 }
 
+static int _rq_map_opa(struct osd_request *or, struct _osd_io_info *io)
+{
+	if (io->opa.pages)
+		return blk_rq_map_pages(io->req->q, io->req, io->opa.pages,
+					io->opa.nr_pages, io->opa.offset,
+					io->opa.length, or->alloc_flags);
+	else
+		return blk_rq_map_kern(io->req->q, io->req,
+				       (void *)io->opa.offset, io->opa.length,
+				       or->alloc_flags);
+}
+
 int osd_finalize_request(struct osd_request *or,
 	u8 options, const void *cap, const u8 *cap_key)
 {
@@ -1273,8 +1287,8 @@ int osd_finalize_request(struct osd_request *or,
 
 	osd_set_caps(&or->cdb, cap);
 
-	has_in = or->in.bio || or->get_attr.total_bytes;
-	has_out = or->out.bio || or->set_attr.total_bytes ||
+	has_in = or->in.opa.length || or->get_attr.total_bytes;
+	has_out = or->out.opa.length || or->set_attr.total_bytes ||
 		or->enc_get_attr.total_bytes;
 
 	ret = _init_blk_request(or, has_in, has_out);
@@ -1283,9 +1297,8 @@ int osd_finalize_request(struct osd_request *or,
 		return ret;
 	}
 
-	if (or->out.bio) {
-		ret = blk_rq_append_bio(or->request->q, or->out.req,
-					or->out.bio);
+	if (or->out.opa.length) {
+		ret = _rq_map_opa(or, &or->out);
 		if (ret) {
 			OSD_DEBUG("blk_rq_append_bio out failed\n");
 			return ret;
@@ -1293,8 +1306,8 @@ int osd_finalize_request(struct osd_request *or,
 		OSD_DEBUG("out bytes=%llu (bytes_req=%u)\n",
 			_LLU(or->out.total_bytes), or->out.req->data_len);
 	}
-	if (or->in.bio) {
-		ret = blk_rq_append_bio(or->request->q, or->in.req, or->in.bio);
+	if (or->in.opa.length) {
+		ret = _rq_map_opa(or, &or->in);
 		if (ret) {
 			OSD_DEBUG("blk_rq_append_bio in failed\n");
 			return ret;
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index 7a317aa..fa32074 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -78,6 +78,21 @@ static inline void osd_dev_set_ver(struct osd_dev *od, enum osd_std_version v)
 #endif
 }
 
+struct osd_pages_array {
+	struct page **pages;
+	unsigned nr_pages;
+	unsigned long offset;
+	unsigned long length;
+};
+
+static inline void opa_map_kern(struct osd_pages_array *opa, void *buff,
+				unsigned long length)
+{
+	WARN_ON(opa->pages || opa->offset);
+	opa->offset = (unsigned long)buff;
+	opa->length = length;
+}
+
 struct osd_request;
 typedef void (osd_req_done_fn)(struct osd_request *or, void *private);
 
@@ -96,7 +111,7 @@ struct osd_request {
 	} set_attr, enc_get_attr, get_attr;
 
 	struct _osd_io_info {
-		struct bio *bio;
+		struct osd_pages_array opa;
 		u64 total_bytes;
 		struct request *req;
 		struct _osd_req_data_segment *last_seg;
@@ -364,12 +379,16 @@ void osd_req_remove_object(struct osd_request *or, struct osd_obj_id *);
 
 void __deprecated osd_req_write_old(struct osd_request *or,
 	const struct osd_obj_id *, struct bio *data_out, u64 offset);
+
+void osd_req_write(struct osd_request *or,
+	const struct osd_obj_id *, const struct osd_pages_array *opa,
+	u64 offset);
 int osd_req_write_kern(struct osd_request *or,
 	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
 void osd_req_append(struct osd_request *or,
-	const struct osd_obj_id *, struct bio *data_out);/* NI */
-void osd_req_create_write(struct osd_request *or,
-	const struct osd_obj_id *, struct bio *data_out, u64 offset);/* NI */
+	const struct osd_obj_id *, struct osd_pages_array *opa_out);/* NI */
+void osd_req_create_write(struct osd_request *or, /* NI */
+	const struct osd_obj_id *, struct osd_pages_array *opa_out, u64 offset);
 void osd_req_clear(struct osd_request *or,
 	const struct osd_obj_id *, u64 offset, u64 len);/* NI */
 void osd_req_punch(struct osd_request *or,
@@ -381,6 +400,10 @@ void osd_req_flush_object(struct osd_request *or,
 
 void __deprecated osd_req_read_old(struct osd_request *or,
 	const struct osd_obj_id *, struct bio *data_in, u64 offset);
+
+void osd_req_read(struct osd_request *or,
+	const struct osd_obj_id *, const struct osd_pages_array *opa_in,
+	u64 offset);
 int osd_req_read_kern(struct osd_request *or,
 	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
 
-- 
1.6.2.1


