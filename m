From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 09/14] libosd: Not implemented commands
Date: Thu, 24 Jul 2008 20:57:15 +0300
Message-ID: <4888C27B.9020105@panasas.com>
References: <48876009.8010701@panasas.com> <4888BC3B.1050406@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27501 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751716AbYGXR6C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 13:58:02 -0400
In-Reply-To: <4888BC3B.1050406@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-osd development <osd-dev@open-osd.org>
Cc: Benny Halevy <bhalevy@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>, Pete Wyckoff <pw@osc.edu>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>


Some commands declared in header are not yet implemented. Put them
as stubs in .c file, just so they take their place in the file

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Reviewed-by: Benny Halevy <bhalevy@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index d7f3688..e0216e0 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -316,6 +316,9 @@ static void _osd_req_encode_common(struct osd_request *or,
 /*
  * Device commands
  */
+/*TODO: void osd_req_set_master_seed_xchg(struct osd_request *, ...); */
+/*TODO: void osd_req_set_master_key(struct osd_request *, ...); */
+
 void osd_req_format(struct osd_request *or, u64 tot_capacity)
 {
 	_osd_req_encode_common(or, OSD_ACT_FORMAT_OSD, &osd_root_object, 0,
@@ -346,6 +349,10 @@ void osd_req_flush_obsd(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_flush_obsd);
 
+/*TODO: void osd_req_perform_scsi_command(struct osd_request *,
+	const u8 *cdb, ...); */
+/*TODO: void osd_req_task_management(struct osd_request *, ...); */
+
 /*
  * Partition commands
  */
@@ -372,6 +379,10 @@ void osd_req_remove_partition(struct osd_request *or, osd_id partition)
 }
 EXPORT_SYMBOL(osd_req_remove_partition);
 
+/*TODO: void osd_req_set_partition_key(struct osd_request *,
+	osd_id partition, u8 new_key_id[OSD_CRYPTO_KEYID_SIZE],
+	u8 seed[OSD_CRYPTO_SEED_SIZE]); */
+
 static int _osd_req_list_objects(struct osd_request *or,
 	__be16 action, const struct osd_obj_id *obj, osd_id initial_id,
 	struct osd_obj_id_list *list, unsigned nelem)
@@ -437,6 +448,11 @@ EXPORT_SYMBOL(osd_req_flush_partition);
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
@@ -446,6 +462,8 @@ int osd_req_list_collection_objects(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_list_collection_objects);
 
+/*TODO: void query(struct osd_request *, ...); V2 */
+
 void osd_req_flush_collection(struct osd_request *or,
 	const struct osd_obj_id *obj, enum osd_options_flush_scope_values op)
 {
@@ -454,6 +472,9 @@ void osd_req_flush_collection(struct osd_request *or,
 }
 EXPORT_SYMBOL(osd_req_flush_collection);
 
+/*TODO: void get_member_attrs(struct osd_request *, ...); V2 */
+/*TODO: void set_member_attrs(struct osd_request *, ...); V2 */
+
 /*
  * Object commands
  */
@@ -469,6 +490,11 @@ void osd_req_remove_object(struct osd_request *or, struct osd_obj_id *obj)
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
@@ -480,6 +506,15 @@ void osd_req_write(struct osd_request *or,
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
1.5.6.rc1.5.gadf6


