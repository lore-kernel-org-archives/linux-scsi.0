From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/4] libosd: Support for scatter gather write/read commands
Date: Tue, 19 Oct 2010 14:22:21 +0200
Message-ID: <1287490941-23983-1-git-send-email-bharrosh@panasas.com>
References: <4CBD8CAB.2030207@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:49859 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754904Ab0JSMWY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2010 08:22:24 -0400
In-Reply-To: <4CBD8CAB.2030207@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, John Chandy <john.chandy@uconn.edu>, open-osd <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>

This patch adds the Scatter-Gather (sg) API to libosd.
Scatter-gather enables a write/read of multiple none-contiguous
areas of an object, in a single call. The extents may overlap
and/or be in any order.

The Scatter-Gather list is sent to the target in what is called
a "cdb continuation segment". This is yet another possible segment
in the osd-out-buffer. It is unlike all other segments in that it
sits before the actual "data" segment (which until now was always
first), and that it is signed by itself and not part of the data
buffer. This is because the cdb-continuation-segment is considered
a spill-over of the CDB data, and is therefor signed under
OSD_SEC_CAPKEY and higher.

TODO: A new osd_finalize_request_ex version should be supplied so
the @caps received on the network also contains a size parameter
and can be spilled over into the "cdb continuation segment".

Thanks to John Chandy <john.chandy@uconn.edu> for the original
code, and investigations. And the implementation of SG support
in the osd-target.

Original-coded-by: John Chandy <john.chandy@uconn.edu>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |  148 ++++++++++++++++++++++++++++++++++++--
 include/scsi/osd_initiator.h     |    9 ++-
 include/scsi/osd_protocol.h      |   42 +++++++++++
 include/scsi/osd_types.h         |    5 ++
 4 files changed, 198 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index acbdcb6..f5b5735 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -464,6 +464,7 @@ void osd_end_request(struct osd_request *or)
 	_osd_free_seg(or, &or->get_attr);
 	_osd_free_seg(or, &or->enc_get_attr);
 	_osd_free_seg(or, &or->set_attr);
+	_osd_free_seg(or, &or->cdb_cont);
 
 	_osd_request_free(or);
 }
@@ -548,6 +549,12 @@ static int _osd_realloc_seg(struct osd_request *or,
 	return 0;
 }
 
+static int _alloc_cdb_cont(struct osd_request *or, unsigned total_bytes)
+{
+	OSD_DEBUG("total_bytes=%d\n", total_bytes);
+	return _osd_realloc_seg(or, &or->cdb_cont, total_bytes);
+}
+
 static int _alloc_set_attr_list(struct osd_request *or,
 	const struct osd_attr *oa, unsigned nelem, unsigned add_bytes)
 {
@@ -886,6 +893,128 @@ int osd_req_read_kern(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_read_kern);
 
+static int _add_sg_continuation_descriptor(struct osd_request *or,
+	const struct osd_sg_entry *sglist, unsigned numentries, u64 *len)
+{
+	struct osd_sg_continuation_descriptor *oscd;
+	u32 oscd_size;
+	unsigned i;
+	int ret;
+
+	oscd_size = sizeof(*oscd) + numentries * sizeof(oscd->entries[0]);
+
+	if (!or->cdb_cont.total_bytes) {
+		/* First time, jump over the header, we will write to:
+		 *	cdb_cont.buff + cdb_cont.total_bytes
+		 */
+		or->cdb_cont.total_bytes =
+				sizeof(struct osd_continuation_segment_header);
+	}
+
+	ret = _alloc_cdb_cont(or, or->cdb_cont.total_bytes + oscd_size);
+	if (unlikely(ret))
+		return ret;
+
+	oscd = or->cdb_cont.buff + or->cdb_cont.total_bytes;
+	oscd->hdr.type = cpu_to_be16(SCATTER_GATHER_LIST);
+	oscd->hdr.pad_length = 0;
+	oscd->hdr.length = cpu_to_be32(oscd_size - sizeof(*oscd));
+
+	*len = 0;
+	/* copy the sg entries and convert to network byte order */
+	for (i = 0; i < numentries; i++) {
+		oscd->entries[i].offset = cpu_to_be64(sglist[i].offset);
+		oscd->entries[i].len    = cpu_to_be64(sglist[i].len);
+		*len += sglist[i].len;
+	}
+
+	or->cdb_cont.total_bytes += oscd_size;
+	OSD_DEBUG("total_bytes=%d oscd_size=%d numentries=%d\n",
+		  or->cdb_cont.total_bytes, oscd_size, numentries);
+	return 0;
+}
+
+static int _osd_req_finalize_cdb_cont(struct osd_request *or, const u8 *cap_key)
+{
+	struct request_queue *req_q = osd_request_queue(or->osd_dev);
+	struct bio *bio;
+	struct osd_cdb_head *cdbh = osd_cdb_head(&or->cdb);
+	struct osd_continuation_segment_header *cont_seg_hdr;
+
+	if (!or->cdb_cont.total_bytes)
+		return 0;
+
+	cont_seg_hdr = or->cdb_cont.buff;
+	cont_seg_hdr->format = CDB_CONTINUATION_FORMAT_V2;
+	cont_seg_hdr->service_action = cdbh->varlen_cdb.service_action;
+
+	/* create a bio for continuation segment */
+	bio = bio_map_kern(req_q, or->cdb_cont.buff, or->cdb_cont.total_bytes,
+			   GFP_KERNEL);
+	if (unlikely(!bio))
+		return -ENOMEM;
+
+	bio->bi_rw |= REQ_WRITE;
+
+	/* integrity check the continuation before the bio is linked
+	 * with the other data segments since the continuation
+	 * integrity is separate from the other data segments.
+	 */
+	osd_sec_sign_data(cont_seg_hdr->integrity_check, bio, cap_key);
+
+	cdbh->v2.cdb_continuation_length = cpu_to_be32(or->cdb_cont.total_bytes);
+
+	/* we can't use _req_append_segment, because we need to link in the
+	 * continuation bio to the head of the bio list - the
+	 * continuation segment (if it exists) is always the first segment in
+	 * the out data buffer.
+	 */
+	bio->bi_next = or->out.bio;
+	or->out.bio = bio;
+	or->out.total_bytes += or->cdb_cont.total_bytes;
+
+	return 0;
+}
+
+/* osd_req_write_sg: Takes a @bio that points to the data out buffer and an
+ * @sglist that has the scatter gather entries. Scatter-gather enables a write
+ * of multiple none-contiguous areas of an object, in a single call. The extents
+ * may overlap and/or be in any order. The only constrain is that:
+ *	total_bytes(sglist) >= total_bytes(bio)
+ */
+int osd_req_write_sg(struct osd_request *or,
+	const struct osd_obj_id *obj, struct bio *bio,
+	const struct osd_sg_entry *sglist, unsigned numentries)
+{
+	u64 len;
+	int ret = _add_sg_continuation_descriptor(or, sglist, numentries, &len);
+
+	if (ret)
+		return ret;
+	osd_req_write(or, obj, 0, bio, len);
+
+	return 0;
+}
+EXPORT_SYMBOL(osd_req_write_sg);
+
+/* osd_req_read_sg: Read multiple extents of an object into @bio
+ * See osd_req_write_sg
+ */
+int osd_req_read_sg(struct osd_request *or,
+	const struct osd_obj_id *obj, struct bio *bio,
+	const struct osd_sg_entry *sglist, unsigned numentries)
+{
+	u64 len;
+	int ret = _add_sg_continuation_descriptor(or, sglist, numentries, &len);
+
+	if (ret)
+		return ret;
+	osd_req_read(or, obj, 0, bio, len);
+
+	return 0;
+}
+EXPORT_SYMBOL(osd_req_read_sg);
+
 void osd_req_get_attributes(struct osd_request *or,
 	const struct osd_obj_id *obj)
 {
@@ -1281,7 +1410,8 @@ static inline void osd_sec_parms_set_in_offset(bool is_v1,
 }
 
 static int _osd_req_finalize_data_integrity(struct osd_request *or,
-	bool has_in, bool has_out, u64 out_data_bytes, const u8 *cap_key)
+	bool has_in, bool has_out, struct bio *out_data_bio, u64 out_data_bytes,
+	const u8 *cap_key)
 {
 	struct osd_security_parameters *sec_parms = _osd_req_sec_params(or);
 	int ret;
@@ -1312,7 +1442,7 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 		or->out.last_seg = NULL;
 
 		/* they are now all chained to request sign them all together */
-		osd_sec_sign_data(&or->out_data_integ, or->out.req->bio,
+		osd_sec_sign_data(&or->out_data_integ, out_data_bio,
 				  cap_key);
 	}
 
@@ -1408,6 +1538,8 @@ int osd_finalize_request(struct osd_request *or,
 {
 	struct osd_cdb_head *cdbh = osd_cdb_head(&or->cdb);
 	bool has_in, has_out;
+	 /* Save for data_integrity without the cdb_continuation */
+	struct bio *out_data_bio = or->out.bio;
 	u64 out_data_bytes = or->out.total_bytes;
 	int ret;
 
@@ -1423,9 +1555,14 @@ int osd_finalize_request(struct osd_request *or,
 	osd_set_caps(&or->cdb, cap);
 
 	has_in = or->in.bio || or->get_attr.total_bytes;
-	has_out = or->out.bio || or->set_attr.total_bytes ||
-		or->enc_get_attr.total_bytes;
+	has_out = or->out.bio || or->cdb_cont.total_bytes ||
+		or->set_attr.total_bytes || or->enc_get_attr.total_bytes;
 
+	ret = _osd_req_finalize_cdb_cont(or, cap_key);
+	if (ret) {
+		OSD_DEBUG("_osd_req_finalize_cdb_cont failed\n");
+		return ret;
+	}
 	ret = _init_blk_request(or, has_in, has_out);
 	if (ret) {
 		OSD_DEBUG("_init_blk_request failed\n");
@@ -1463,7 +1600,8 @@ int osd_finalize_request(struct osd_request *or,
 	}
 
 	ret = _osd_req_finalize_data_integrity(or, has_in, has_out,
-					       out_data_bytes, cap_key);
+					       out_data_bio, out_data_bytes,
+					       cap_key);
 	if (ret)
 		return ret;
 
diff --git a/include/scsi/osd_initiator.h b/include/scsi/osd_initiator.h
index a8f3701..169a5dc 100644
--- a/include/scsi/osd_initiator.h
+++ b/include/scsi/osd_initiator.h
@@ -137,7 +137,7 @@ struct osd_request {
 		void *buff;
 		unsigned alloc_size; /* 0 here means: don't call kfree */
 		unsigned total_bytes;
-	} set_attr, enc_get_attr, get_attr;
+	} cdb_cont, set_attr, enc_get_attr, get_attr;
 
 	struct _osd_io_info {
 		struct bio *bio;
@@ -448,6 +448,13 @@ void osd_req_read(struct osd_request *or,
 int osd_req_read_kern(struct osd_request *or,
 	const struct osd_obj_id *obj, u64 offset, void *buff, u64 len);
 
+/* Scatter/Gather write/read commands */
+int osd_req_write_sg(struct osd_request *or,
+	const struct osd_obj_id *obj, struct bio *bio,
+	const struct osd_sg_entry *sglist, unsigned numentries);
+int osd_req_read_sg(struct osd_request *or,
+	const struct osd_obj_id *obj, struct bio *bio,
+	const struct osd_sg_entry *sglist, unsigned numentries);
 /*
  * Root/Partition/Collection/Object Attributes commands
  */
diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
index 6856612..a6026da 100644
--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -631,4 +631,46 @@ static inline void osd_sec_set_caps(struct osd_capability_head *cap,
 	put_unaligned_le16(bit_mask, &cap->permissions_bit_mask);
 }
 
+/* osd2r05a sec 5.3: CDB continuation segment formats */
+enum osd_continuation_segment_format {
+	CDB_CONTINUATION_FORMAT_V2 = 0x01,
+};
+
+struct osd_continuation_segment_header {
+	u8	format;
+	u8	reserved1;
+	__be16	service_action;
+	__be32	reserved2;
+	u8	integrity_check[OSDv2_CRYPTO_KEYID_SIZE];
+} __packed;
+
+/* osd2r05a sec 5.4.1: CDB continuation descriptors */
+enum osd_continuation_descriptor_type {
+	NO_MORE_DESCRIPTORS = 0x0000,
+	SCATTER_GATHER_LIST = 0x0001,
+	QUERY_LIST = 0x0002,
+	USER_OBJECT = 0x0003,
+	COPY_USER_OBJECT_SOURCE = 0x0101,
+	EXTENSION_CAPABILITIES = 0xFFEE
+};
+
+struct osd_continuation_descriptor_header {
+	__be16	type;
+	u8	reserved;
+	u8	pad_length;
+	__be32	length;
+} __packed;
+
+
+/* osd2r05a sec 5.4.2: Scatter/gather list */
+struct osd_sg_list_entry {
+	__be64 offset;
+	__be64 len;
+};
+
+struct osd_sg_continuation_descriptor {
+	struct osd_continuation_descriptor_header hdr;
+	struct osd_sg_list_entry entries[];
+};
+
 #endif /* ndef __OSD_PROTOCOL_H__ */
diff --git a/include/scsi/osd_types.h b/include/scsi/osd_types.h
index 3f5e88c..bd0be7e 100644
--- a/include/scsi/osd_types.h
+++ b/include/scsi/osd_types.h
@@ -37,4 +37,9 @@ struct osd_attr {
 	void *val_ptr;		/* in network order */
 };
 
+struct osd_sg_entry {
+	u64 offset;
+	u64 len;
+};
+
 #endif /* ndef __OSD_TYPES_H__ */
-- 
1.7.2.3

