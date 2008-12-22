From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 12/18] libosd: Not implemented commands
Date: Mon, 22 Dec 2008 15:04:42 +0200
Message-ID: <1229951082-16042-1-git-send-email-bharrosh@panasas.com>
References: <494F88C0.4070507@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:1502 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753697AbYLVNEr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Dec 2008 08:04:47 -0500
In-Reply-To: <494F88C0.4070507@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jeff Garzik <jeff@garzik.org>, linux-s
Cc: linux-kernel <linux-kernel@vger.kernel.org>

Some commands declared in header are not yet implemented. Put them
as stubs in .c file, just so they take their place in the file

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 91f58fd..d3cc7ed 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -339,6 +339,9 @@ static void _osd_req_encode_common(struct osd_request *or,
 /*
  * Device commands
  */
+/*TODO: void osd_req_set_master_seed_xchg(struct osd_request *, ...); */
+/*TODO: void osd_req_set_master_key(struct osd_request *, ...); */
+
 void osd_req_format(struct osd_request *or, u64 tot_capacity)
 {
 	_osd_req_encode_common(or, OSD_ACT_FORMAT_OSD, &osd_root_object, 0,
@@ -369,6 +372,10 @@ void osd_req_flush_obsd(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_flush_obsd);
 
+/*TODO: void osd_req_perform_scsi_command(struct osd_request *,
+	const u8 *cdb, ...); */
+/*TODO: void osd_req_task_management(struct osd_request *, ...); */
+
 /*
  * Partition commands
  */
@@ -395,6 +402,10 @@ void osd_req_remove_partition(struct osd_request *or, osd_id partition)
 }
 EXPORT_SYMBOL(osd_req_remove_partition);
 
+/*TODO: void osd_req_set_partition_key(struct osd_request *,
+	osd_id partition, u8 new_key_id[OSD_CRYPTO_KEYID_SIZE],
+	u8 seed[OSD_CRYPTO_SEED_SIZE]); */
+
 static int _osd_req_list_objects(struct osd_request *or,
 	__be16 action, const struct osd_obj_id *obj, osd_id initial_id,
 	struct osd_obj_id_list *list, unsigned nelem)
@@ -460,6 +471,11 @@ EXPORT_SYMBOL(osd_req_flush_partition);
 /*
  * Collection commands
  */
+/*TODO: void osd_req_create_collection(struct osd_request *,
+	const struct osd_obj_id *); */
+/*TODO: void osd_req_remove_collection(struct osd_request *,
+	const struct osd_obj_id *); */
+
 int osd_req_list_collection_objects(struct osd_request *or,
 	const struct osd_obj_id *obj, osd_id initial_id,
 	struct osd_obj_id_list *list, unsigned nelem)
@@ -469,6 +485,8 @@ int osd_req_list_collection_objects(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_list_collection_objects);
 
+/*TODO: void query(struct osd_request *, ...); V2 */
+
 void osd_req_flush_collection(struct osd_request *or,
 	const struct osd_obj_id *obj, enum osd_options_flush_scope_values op)
 {
@@ -477,6 +495,9 @@ void osd_req_flush_collection(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_flush_collection);
 
+/*TODO: void get_member_attrs(struct osd_request *, ...); V2 */
+/*TODO: void set_member_attrs(struct osd_request *, ...); V2 */
+
 /*
  * Object commands
  */
@@ -492,6 +513,11 @@ void osd_req_remove_object(struct osd_request *or, struct osd_obj_id *obj)
 }
 EXPORT_SYMBOL(osd_req_remove_object);
 
+
+/*TODO: void osd_req_create_multi(struct osd_request *or,
+	struct osd_obj_id *first, struct osd_obj_id_list *list, unsigned nelem);
+*/
+
 void osd_req_write(struct osd_request *or,
 	const struct osd_obj_id *obj, struct bio *bio, u64 offset)
 {
@@ -503,6 +529,15 @@ void osd_req_write(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_write);
 
+/*TODO: void osd_req_append(struct osd_request *,
+	const struct osd_obj_id *, struct bio *data_out); */
+/*TODO: void osd_req_create_write(struct osd_request *,
+	const struct osd_obj_id *, struct bio *data_out, u64 offset); */
+/*TODO: void osd_req_clear(struct osd_request *,
+	const struct osd_obj_id *, u64 offset, u64 len); */
+/*TODO: void osd_req_punch(struct osd_request *,
+	const struct osd_obj_id *, u64 offset, u64 len); V2 */
+
 void osd_req_flush_object(struct osd_request *or,
 	const struct osd_obj_id *obj, enum osd_options_flush_scope_values op,
 	/*V2*/ u64 offset, /*V2*/ u64 len)
-- 
1.6.0.1

