From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 09/16] libosd: Add Flush and List-objects support
Date: Sun, 25 Jan 2009 17:05:07 +0200
Message-ID: <1232895907-19703-1-git-send-email-bharrosh@panasas.com>
References: <497C7B33.4080105@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:27918 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752085AbZAYPFL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jan 2009 10:05:11 -0500
In-Reply-To: <497C7B33.4080105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>

Add support for the various List-objects commands. List-partitions-in-device,
List-collections-in-partition, List-objects-in-partition,
List-objects-in-collection. All these support partial listing and continuation.

Add support for the different Flush commands and options.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |  124 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 6849f26..5d9457b 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -104,6 +104,16 @@ static bool _osd_req_is_alist_type(struct osd_request *or,
 	}
 }
 
+/* This is for List-objects not Attributes-Lists */
+static void _osd_req_encode_olist(struct osd_request *or,
+	struct osd_obj_id_list *list)
+{
+	struct osd_cdb_head *cdbh = osd_cdb_head(&or->cdb);
+
+	cdbh->v1.list_identifier = list->list_identifier;
+	cdbh->v1.start_address = list->continuation_id;
+}
+
 static osd_cdb_offset osd_req_encode_offset(struct osd_request *or,
 	u64 offset, unsigned *padding)
 {
@@ -340,6 +350,29 @@ void osd_req_format(struct osd_request *or, u64 tot_capacity)
 }
 EXPORT_SYMBOL(osd_req_format);
 
+int osd_req_list_dev_partitions(struct osd_request *or,
+	osd_id initial_id, struct osd_obj_id_list *list, unsigned nelem)
+{
+	return osd_req_list_partition_objects(or, 0, initial_id, list, nelem);
+}
+EXPORT_SYMBOL(osd_req_list_dev_partitions);
+
+static void _osd_req_encode_flush(struct osd_request *or,
+	enum osd_options_flush_scope_values op)
+{
+	struct osd_cdb_head *ocdb = osd_cdb_head(&or->cdb);
+
+	ocdb->command_specific_options = op;
+}
+
+void osd_req_flush_obsd(struct osd_request *or,
+	enum osd_options_flush_scope_values op)
+{
+	_osd_req_encode_common(or, OSD_ACT_FLUSH_OSD, &osd_root_object, 0, 0);
+	_osd_req_encode_flush(or, op);
+}
+EXPORT_SYMBOL(osd_req_flush_obsd);
+
 /*
  * Partition commands
  */
@@ -366,6 +399,88 @@ void osd_req_remove_partition(struct osd_request *or, osd_id partition)
 }
 EXPORT_SYMBOL(osd_req_remove_partition);
 
+static int _osd_req_list_objects(struct osd_request *or,
+	__be16 action, const struct osd_obj_id *obj, osd_id initial_id,
+	struct osd_obj_id_list *list, unsigned nelem)
+{
+	struct request_queue *q = or->osd_dev->scsi_device->request_queue;
+	u64 len = nelem * sizeof(osd_id) + sizeof(*list);
+	struct bio *bio;
+
+	_osd_req_encode_common(or, action, obj, (u64)initial_id, len);
+
+	if (list->list_identifier)
+		_osd_req_encode_olist(or, list);
+
+	WARN_ON(or->in.bio);
+	bio = bio_map_kern(q, list, len, or->alloc_flags);
+	if (!bio) {
+		OSD_ERR("!!! Failed to allocate list_objects BIO\n");
+		return -ENOMEM;
+	}
+
+	bio->bi_rw &= ~(1 << BIO_RW);
+	or->in.bio = bio;
+	or->in.total_bytes = bio->bi_size;
+	return 0;
+}
+
+int osd_req_list_partition_collections(struct osd_request *or,
+	osd_id partition, osd_id initial_id, struct osd_obj_id_list *list,
+	unsigned nelem)
+{
+	struct osd_obj_id par = {
+		.partition = partition,
+		.id = 0,
+	};
+
+	return osd_req_list_collection_objects(or, &par, initial_id, list,
+					       nelem);
+}
+EXPORT_SYMBOL(osd_req_list_partition_collections);
+
+int osd_req_list_partition_objects(struct osd_request *or,
+	osd_id partition, osd_id initial_id, struct osd_obj_id_list *list,
+	unsigned nelem)
+{
+	struct osd_obj_id par = {
+		.partition = partition,
+		.id = 0,
+	};
+
+	return _osd_req_list_objects(or, OSD_ACT_LIST, &par, initial_id, list,
+				     nelem);
+}
+EXPORT_SYMBOL(osd_req_list_partition_objects);
+
+void osd_req_flush_partition(struct osd_request *or,
+	osd_id partition, enum osd_options_flush_scope_values op)
+{
+	_osd_req_encode_partition(or, OSD_ACT_FLUSH_PARTITION, partition);
+	_osd_req_encode_flush(or, op);
+}
+EXPORT_SYMBOL(osd_req_flush_partition);
+
+/*
+ * Collection commands
+ */
+int osd_req_list_collection_objects(struct osd_request *or,
+	const struct osd_obj_id *obj, osd_id initial_id,
+	struct osd_obj_id_list *list, unsigned nelem)
+{
+	return _osd_req_list_objects(or, OSD_ACT_LIST_COLLECTION, obj,
+				     initial_id, list, nelem);
+}
+EXPORT_SYMBOL(osd_req_list_collection_objects);
+
+void osd_req_flush_collection(struct osd_request *or,
+	const struct osd_obj_id *obj, enum osd_options_flush_scope_values op)
+{
+	_osd_req_encode_common(or, OSD_ACT_FLUSH_PARTITION, obj, 0, 0);
+	_osd_req_encode_flush(or, op);
+}
+EXPORT_SYMBOL(osd_req_flush_collection);
+
 /*
  * Object commands
  */
@@ -392,6 +507,15 @@ void osd_req_write(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_write);
 
+void osd_req_flush_object(struct osd_request *or,
+	const struct osd_obj_id *obj, enum osd_options_flush_scope_values op,
+	/*V2*/ u64 offset, /*V2*/ u64 len)
+{
+	_osd_req_encode_common(or, OSD_ACT_FLUSH, obj, offset, len);
+	_osd_req_encode_flush(or, op);
+}
+EXPORT_SYMBOL(osd_req_flush_object);
+
 void osd_req_read(struct osd_request *or,
 	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
 {
-- 
1.6.0.1

