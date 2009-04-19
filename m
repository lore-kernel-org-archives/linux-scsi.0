From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 3/4] libosd: OSD2r05: OSD_CRYPTO_KEYID_SIZE will grow 20 =>
 32 bytes
Date: Sun, 19 Apr 2009 19:13:39 +0300
Message-ID: <49EB4DB3.7060404@panasas.com>
References: <49EB4A42.9030502@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:15057 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760965AbZDSQOF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Apr 2009 12:14:05 -0400
In-Reply-To: <49EB4A42.9030502@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: Dan Carpenter <error27@gmail.com>


In OSD2r04 draft, cryptographic key size changed to 32 bytes from
OSD1's 20 bytes. This causes a couple of on-the-wire structures
to change, including the CDB.

In this patch the OSD1/OSD2 handling is separated out in regard
to affected structures, but on-the-wire is still the same. All
on the wire changes will be submitted in one patch for bisect-ability.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |   30 ++++++++++++++++----
 include/scsi/osd_protocol.h      |   55 ++++++++++++++++++++++++++++++-------
 2 files changed, 68 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index e266f80..f61ab84 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -345,9 +345,9 @@ _osd_req_sec_params(struct osd_request *or)
 	struct osd_cdb *ocdb = &or->cdb;
 
 	if (osd_req_is_ver1(or))
-		return &ocdb->v1.sec_params;
+		return (struct osd_security_parameters *)&ocdb->v1.sec_params;
 	else
-		return &ocdb->v2.sec_params;
+		return (struct osd_security_parameters *)&ocdb->v2.sec_params;
 }
 
 void osd_dev_init(struct osd_dev *osdd, struct scsi_device *scsi_device)
@@ -1209,6 +1209,24 @@ static int _osd_req_finalize_attr_page(struct osd_request *or)
 	return ret;
 }
 
+static inline void osd_sec_parms_set_out_offset(bool is_v1,
+	struct osd_security_parameters *sec_parms, osd_cdb_offset offset)
+{
+	if (is_v1)
+		sec_parms->v1.data_out_integrity_check_offset = offset;
+	else
+		sec_parms->v2.data_out_integrity_check_offset = offset;
+}
+
+static inline void osd_sec_parms_set_in_offset(bool is_v1,
+	struct osd_security_parameters *sec_parms, osd_cdb_offset offset)
+{
+	if (is_v1)
+		sec_parms->v1.data_in_integrity_check_offset = offset;
+	else
+		sec_parms->v2.data_in_integrity_check_offset = offset;
+}
+
 static int _osd_req_finalize_data_integrity(struct osd_request *or,
 	bool has_in, bool has_out, const u8 *cap_key)
 {
@@ -1232,8 +1250,8 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 		or->out_data_integ.get_attributes_bytes = cpu_to_be64(
 			or->enc_get_attr.total_bytes);
 
-		sec_parms->data_out_integrity_check_offset =
-			osd_req_encode_offset(or, or->out.total_bytes, &pad);
+		osd_sec_parms_set_out_offset(osd_req_is_ver1(or), sec_parms,
+			osd_req_encode_offset(or, or->out.total_bytes, &pad));
 
 		ret = _req_append_segment(or, pad, &seg, or->out.last_seg,
 					  &or->out);
@@ -1253,8 +1271,8 @@ static int _osd_req_finalize_data_integrity(struct osd_request *or,
 		};
 		unsigned pad;
 
-		sec_parms->data_in_integrity_check_offset =
-			osd_req_encode_offset(or, or->in.total_bytes, &pad);
+		osd_sec_parms_set_in_offset(osd_req_is_ver1(or), sec_parms,
+			osd_req_encode_offset(or, or->in.total_bytes, &pad));
 
 		ret = _req_append_segment(or, pad, &seg, or->in.last_seg,
 					  &or->in);
diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
index fa8343c..bbeceeb 100644
--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -33,8 +33,10 @@ enum {
 	OSD_CAP_LEN = OSDv1_CAP_LEN,/* FIXME: Pete rev-001 sup */
 
 	OSD_SYSTEMID_LEN = 20,
-	OSD_CRYPTO_KEYID_SIZE = 20,
+	OSDv1_CRYPTO_KEYID_SIZE = 20,
 	/*FIXME: OSDv2_CRYPTO_KEYID_SIZE = 32,*/
+	OSDv2_CRYPTO_KEYID_SIZE = 20,
+	OSD_CRYPTO_KEYID_SIZE = OSDv2_CRYPTO_KEYID_SIZE,
 	OSD_CRYPTO_SEED_SIZE = 4,
 	OSD_CRYPTO_NONCE_SIZE = 12,
 	OSD_MAX_SENSE_LEN = 252, /* from SPC-3 */
@@ -204,29 +206,40 @@ struct osd_cdb_head {
 /*80*/
 
 /*160 v1*/
-/*184 v2*/
-struct osd_security_parameters {
-/*160*/u8	integrity_check_value[OSD_CRYPTO_KEYID_SIZE];
+struct osdv1_security_parameters {
+/*160*/u8	integrity_check_value[OSDv1_CRYPTO_KEYID_SIZE];
 /*180*/u8	request_nonce[OSD_CRYPTO_NONCE_SIZE];
 /*192*/osd_cdb_offset	data_in_integrity_check_offset;
 /*196*/osd_cdb_offset	data_out_integrity_check_offset;
 } __packed;
 /*200 v1*/
-/*224 v2*/
 
-/* FIXME: osdv2_security_parameters */
+/*184 v2*/
+struct osdv2_security_parameters {
+/*184*/u8	integrity_check_value[OSDv2_CRYPTO_KEYID_SIZE];
+/*216*/u8	request_nonce[OSD_CRYPTO_NONCE_SIZE];
+/*228*/osd_cdb_offset	data_in_integrity_check_offset;
+/*232*/osd_cdb_offset	data_out_integrity_check_offset;
+} __packed;
+/*236 v2*/
+
+struct osd_security_parameters {
+	union {
+		struct osdv1_security_parameters v1;
+		struct osdv2_security_parameters v2;
+	};
+};
 
 struct osdv1_cdb {
 	struct osd_cdb_head h;
 	u8 caps[OSDv1_CAP_LEN];
-	struct osd_security_parameters sec_params;
+	struct osdv1_security_parameters sec_params;
 } __packed;
 
 struct osdv2_cdb {
 	struct osd_cdb_head h;
 	u8 caps[OSD_CAP_LEN];
-	struct osd_security_parameters sec_params;
-	/* FIXME: osdv2_security_parameters */
+	struct osdv2_security_parameters sec_params;
 } __packed;
 
 struct osd_cdb {
@@ -429,15 +442,35 @@ struct osd_data_out_integrity_info {
 	__be64 data_bytes;
 	__be64 set_attributes_bytes;
 	__be64 get_attributes_bytes;
-	__be64 integrity_check_value;
+	__u8 integrity_check_value[OSD_CRYPTO_KEYID_SIZE];
 } __packed;
 
+/* Same osd_data_out_integrity_info is used for OSD2/OSD1. The only difference
+ * Is the sizeof the structure since in OSD1 the last array is smaller. Use
+ * below for version independent handling of this structure
+ */
+static inline int osd_data_out_integrity_info_sizeof(bool is_ver1)
+{
+	return sizeof(struct osd_data_out_integrity_info) -
+		(is_ver1 * (OSDv2_CRYPTO_KEYID_SIZE - OSDv1_CRYPTO_KEYID_SIZE));
+}
+
 struct osd_data_in_integrity_info {
 	__be64 data_bytes;
 	__be64 retrieved_attributes_bytes;
-	__be64 integrity_check_value;
+	__u8 integrity_check_value[OSD_CRYPTO_KEYID_SIZE];
 } __packed;
 
+/* Same osd_data_in_integrity_info is used for OSD2/OSD1. The only difference
+ * Is the sizeof the structure since in OSD1 the last array is smaller. Use
+ * below for version independent handling of this structure
+ */
+static inline int osd_data_in_integrity_info_sizeof(bool is_ver1)
+{
+	return sizeof(struct osd_data_in_integrity_info) -
+		(is_ver1 * (OSDv2_CRYPTO_KEYID_SIZE - OSDv1_CRYPTO_KEYID_SIZE));
+}
+
 struct osd_timestamp {
 	u8 time[6]; /* number of milliseconds since 1/1/1970 UT (big endian) */
 } __packed;
-- 
1.6.2.1


