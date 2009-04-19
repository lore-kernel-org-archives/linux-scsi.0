From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 4/4] libosd: OSD2r05: on-the-wire changes for latest OSD2
 revision 5.
Date: Sun, 19 Apr 2009 19:17:54 +0300
Message-ID: <49EB4EB2.5040400@panasas.com>
References: <49EB4A42.9030502@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:26329 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758821AbZDSQSK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Apr 2009 12:18:10 -0400
In-Reply-To: <49EB4A42.9030502@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: Dan Carpenter <error27@gmail.com>


>From this point on we support only post CDB_VER_OSD2r01 tag from
OSC's OSD2 target: [git clone git://git.open-osd.org/osc-osd/ master]
(Initiator code prior to this patch must use: "git checkout CDB_VER_OSD2r01"
 in the target tree above)

This is a summery of the wire changes:

 * OSDv2_ADDITIONAL_CDB_LENGTH == 192 => 228 (Total CDB is now 236 bytes)
 * Attributes List Element Header grew, so attribute values are 8 bytes
   aligned.
 * Cryptographic keys and signatures are 20 => 32
 * Few new definitions.

(Still missing new standard definitions attribute values, these do not change
 wire format and will be added later when needed)

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/osd/osd_initiator.c |    7 ++++++-
 include/scsi/osd_protocol.h      |   23 +++++++++++++----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index f61ab84..1ce6b24 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -263,7 +263,12 @@ static int _osd_req_alist_elem_decode(struct osd_request *or,
 		oa->attr_page = be32_to_cpu(attr->attr_page);
 		oa->attr_id = be32_to_cpu(attr->attr_id);
 
-		oa->val_ptr = attr->attr_val;
+		/* OSD2: For convenience, on empty attributes, we return 8 bytes
+		 * of zeros here. This keeps the same behaviour with OSD2r04,
+		 * and is nice with null terminating ASCII fields.
+		 * oa->val_ptr == NULL marks the end-of-list, or error.
+		 */
+		oa->val_ptr = likely(oa->len) ? attr->attr_val : attr->reserved;
 	}
 	return inc;
 }
diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
index bbeceeb..62b2ab8 100644
--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -24,18 +24,17 @@ enum {
 	OSDv1_ADDITIONAL_CDB_LENGTH = 192,
 	OSDv1_TOTAL_CDB_LEN = OSDv1_ADDITIONAL_CDB_LENGTH + 8,
 	OSDv1_CAP_LEN = 80,
+
 	/* Latest supported version */
-/* 	OSD_ADDITIONAL_CDB_LENGTH = 216,*/
+	OSDv2_ADDITIONAL_CDB_LENGTH = 228,
 	OSD_ADDITIONAL_CDB_LENGTH =
-		OSDv1_ADDITIONAL_CDB_LENGTH, /* FIXME: Pete rev-001 sup */
+		OSDv2_ADDITIONAL_CDB_LENGTH,
 	OSD_TOTAL_CDB_LEN = OSD_ADDITIONAL_CDB_LENGTH + 8,
-/* 	OSD_CAP_LEN = 104,*/
-	OSD_CAP_LEN = OSDv1_CAP_LEN,/* FIXME: Pete rev-001 sup */
+	OSD_CAP_LEN = 104,
 
 	OSD_SYSTEMID_LEN = 20,
 	OSDv1_CRYPTO_KEYID_SIZE = 20,
-	/*FIXME: OSDv2_CRYPTO_KEYID_SIZE = 32,*/
-	OSDv2_CRYPTO_KEYID_SIZE = 20,
+	OSDv2_CRYPTO_KEYID_SIZE = 32,
 	OSD_CRYPTO_KEYID_SIZE = OSDv2_CRYPTO_KEYID_SIZE,
 	OSD_CRYPTO_SEED_SIZE = 4,
 	OSD_CRYPTO_NONCE_SIZE = 12,
@@ -166,7 +165,11 @@ struct osd_cdb_head {
 			/* called allocation_length in some commands */
 /*32*/			__be64	length;
 /*40*/			__be64	start_address;
-/*48*/			__be32 list_identifier;/* Rarely used */
+			union {
+/*48*/				__be32 list_identifier;/* Rarely used */
+				/* OSD2r05 5.2.5 CDB continuation length */
+/*48*/				__be32 cdb_continuation_length;
+			};
 		} __packed v2;
 	};
 /*52*/	union { /* selected attributes mode Page/List/Single */
@@ -331,6 +334,7 @@ struct osdv1_attributes_list_element {
 struct osdv2_attributes_list_element {
 	__be32 attr_page;
 	__be32 attr_id;
+	u8 reserved[6];
 	__be16 attr_bytes; /* valid bytes at attr_val without padding */
 	u8 attr_val[0];
 } __packed;
@@ -520,7 +524,7 @@ enum osd_capability_bit_masks {
 
 	OSD_SEC_CAP_NONE1	= BIT(8),
 	OSD_SEC_CAP_NONE2	= BIT(9),
-	OSD_SEC_CAP_NONE3	= BIT(10),
+	OSD_SEC_GBL_REM 	= BIT(10), /*v2 only*/
 	OSD_SEC_CAP_QUERY	= BIT(11), /*v2 only*/
 	OSD_SEC_CAP_M_OBJECT	= BIT(12), /*v2 only*/
 	OSD_SEC_CAP_POL_SEC	= BIT(13),
@@ -595,8 +599,7 @@ struct osdv1_capability {
 
 struct osd_capability {
 	struct osd_capability_head h;
-/* 	struct osd_cap_object_descriptor od;*/
-	struct osdv1_cap_object_descriptor od; /* FIXME: Pete rev-001 sup */
+	struct osd_cap_object_descriptor od;
 } __packed;
 
 /**
-- 
1.6.2.1


