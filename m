From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 2/3] osd_initiator: support bio chains
Date: Fri, 10 Apr 2009 07:49:08 -0400
Message-ID: <20090410114908.GB10602@havoc.gtf.org>
References: <20090402015455.GA14087@havoc.gtf.org> <20090407225302.GA14248@havoc.gtf.org> <20090410114821.GA10602@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S936236AbZDJLta@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090410114821.GA10602@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, osd-dev@open-osd.org
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/scsi/osd/osd_initiator.c |   83 +++++++++++++++++++++++++++++++--------
 1 file changed, 67 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 2a5f077..2d35d65 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -709,14 +709,36 @@ EXPORT_SYMBOL(osd_req_remove_object);
 	struct osd_obj_id *first, struct osd_obj_id_list *list, unsigned nelem);
 */
 
+static unsigned int bio_chain_size(struct bio *bio)
+{
+	unsigned int chain_size = 0;
+
+	while (bio) {
+		chain_size += bio->bi_size;
+		bio = bio->bi_next;
+	}
+
+	return chain_size;
+}
+
 void osd_req_write(struct osd_request *or,
 	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
 {
-	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, bio->bi_size);
+	unsigned int chain_size = 0;
+	struct bio *tmp_bio = bio;
+
+	while (tmp_bio) {
+		chain_size += tmp_bio->bi_size;
+		tmp_bio->bi_rw |= (1 << BIO_RW);
+
+		tmp_bio = tmp_bio->bi_next;
+	}
+
+	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, chain_size);
 	WARN_ON(or->out.bio || or->out.total_bytes);
-	bio->bi_rw |= (1 << BIO_RW);
+
 	or->out.bio = bio;
-	or->out.total_bytes = bio->bi_size;
+	or->out.total_bytes = chain_size;
 }
 EXPORT_SYMBOL(osd_req_write);
 
@@ -747,11 +769,21 @@ EXPORT_SYMBOL(osd_req_flush_object);
 void osd_req_read(struct osd_request *or,
 	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
 {
-	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, bio->bi_size);
+	unsigned int chain_size = 0;
+	struct bio *tmp_bio = bio;
+
+	while (tmp_bio) {
+		chain_size += tmp_bio->bi_size;
+		tmp_bio->bi_rw &= ~(1 << BIO_RW);
+
+		tmp_bio = tmp_bio->bi_next;
+	}
+
+	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, chain_size);
 	WARN_ON(or->in.bio || or->in.total_bytes);
-	bio->bi_rw &= ~(1 << BIO_RW);
+
 	or->in.bio = bio;
-	or->in.total_bytes = bio->bi_size;
+	or->in.total_bytes = chain_size;
 }
 EXPORT_SYMBOL(osd_req_read);
 
@@ -1176,7 +1208,7 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 		unsigned pad;
 
 		or->out_data_integ.data_bytes = cpu_to_be64(
-			or->out.bio ? or->out.bio->bi_size : 0);
+			or->out.bio ? bio_chain_size(or->out.bio) : 0);
 		or->out_data_integ.set_attributes_bytes = cpu_to_be64(
 			or->set_attr.total_bytes);
 		or->out_data_integ.get_attributes_bytes = cpu_to_be64(
@@ -1269,6 +1301,7 @@ int osd_finalize_request(struct osd_request *or,
 	struct osd_cdb_head *cdbh = osd_cdb_head(&or->cdb);
 	bool has_in, has_out;
 	int ret;
+	struct bio *bio, *tmp;
 
 	if (options & OSD_REQ_FUA)
 		cdbh->options |= OSD_CDB_FUA;
@@ -1292,23 +1325,40 @@ int osd_finalize_request(struct osd_request *or,
 	}
 
 	if (or->out.bio) {
-		ret = blk_rq_append_bio(or->request->q, or->out.req,
-					or->out.bio);
-		if (ret) {
-			OSD_DEBUG("blk_rq_append_bio out failed\n");
-			return ret;
+		bio = or->out.bio;
+		while (bio) {
+			tmp = bio;
+			bio = bio->bi_next;
+
+			ret = blk_rq_append_bio(or->request->q, or->out.req,
+						tmp);
+			if (ret) {
+				OSD_DEBUG("blk_rq_append_bio out failed\n");
+				return ret;
+			}
 		}
 		OSD_DEBUG("out bytes=%llu (bytes_req=%u)\n",
 			_LLU(or->out.total_bytes), or->out.req->data_len);
+
+		or->out.bio = NULL;
 	}
 	if (or->in.bio) {
-		ret = blk_rq_append_bio(or->request->q, or->in.req, or->in.bio);
-		if (ret) {
-			OSD_DEBUG("blk_rq_append_bio in failed\n");
-			return ret;
+		bio = or->in.bio;
+		while (bio) {
+			tmp = bio;
+			bio = bio->bi_next;
+
+			ret = blk_rq_append_bio(or->request->q, or->in.req,
+						tmp);
+			if (ret) {
+				OSD_DEBUG("blk_rq_append_bio in failed\n");
+				return ret;
+			}
 		}
 		OSD_DEBUG("in bytes=%llu (bytes_req=%u)\n",
 			_LLU(or->in.total_bytes), or->in.req->data_len);
+
+		or->in.bio = NULL;
 	}
 
 	or->out.pad_buff = sg_out_pad_buffer;
@@ -1618,6 +1668,7 @@ void osd_sec_sign_cdb(struct osd_cdb *ocdb __unused, const u8 *cap_key __unused)
 void osd_sec_sign_data(void *data_integ __unused,
 		       struct bio *bio __unused, const u8 *cap_key __unused)
 {
+	/* NOTE: bio is a linked list */
 }
 
 /*
