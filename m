From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 02/10 resend] libosd: OSD2r05: Attribute definitions
Date: Sun, 24 May 2009 20:01:03 +0300
Message-ID: <1243184463-16921-1-git-send-email-bharrosh@panasas.com>
References: <4A197CB5.60709@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:30814 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754076AbZEXRBF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2009 13:01:05 -0400
In-Reply-To: <4A197CB5.60709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
Cc: Jeff Garzik <jeff@garzik.org>

Some New revision 5 Attribute definitions.
Some missing definitions of Attributes and pages

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 include/scsi/osd_attributes.h |   74 +++++++++++++++++++++++++++++++++++++++-
 1 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/include/scsi/osd_attributes.h b/include/scsi/osd_attributes.h
index f888a6f..56e920a 100644
--- a/include/scsi/osd_attributes.h
+++ b/include/scsi/osd_attributes.h
@@ -29,6 +29,7 @@ enum {
 	OSD_APAGE_PARTITION_INFORMATION = OSD_APAGE_PARTITION_FIRST + 1,
 	OSD_APAGE_PARTITION_QUOTAS	= OSD_APAGE_PARTITION_FIRST + 2,
 	OSD_APAGE_PARTITION_TIMESTAMP	= OSD_APAGE_PARTITION_FIRST + 3,
+	OSD_APAGE_PARTITION_ATTR_ACCESS = OSD_APAGE_PARTITION_FIRST + 4,
 	OSD_APAGE_PARTITION_SECURITY	= OSD_APAGE_PARTITION_FIRST + 5,
 	OSD_APAGE_PARTITION_LAST	= 0x5FFFFFFF,
 
@@ -51,7 +52,9 @@ enum {
 	OSD_APAGE_RESERVED_TYPE_LAST	= 0xEFFFFFFF,
 
 	OSD_APAGE_COMMON_FIRST		= 0xF0000000,
-	OSD_APAGE_COMMON_LAST		= 0xFFFFFFFE,
+	OSD_APAGE_COMMON_LAST		= 0xFFFFFFFD,
+
+	OSD_APAGE_CURRENT_COMMAND	= 0xFFFFFFFE,
 
 	OSD_APAGE_REQUEST_ALL		= 0xFFFFFFFF,
 };
@@ -106,10 +109,30 @@ enum {
 	OSD_ATTR_RI_PRODUCT_REVISION_LEVEL   = 0x7,   /* 4        */
 	OSD_ATTR_RI_PRODUCT_SERIAL_NUMBER    = 0x8,   /* variable */
 	OSD_ATTR_RI_OSD_NAME                 = 0x9,   /* variable */
+	OSD_ATTR_RI_MAX_CDB_CONTINUATION_LEN = 0xA,   /* 4        */
 	OSD_ATTR_RI_TOTAL_CAPACITY           = 0x80,  /* 8        */
 	OSD_ATTR_RI_USED_CAPACITY            = 0x81,  /* 8        */
 	OSD_ATTR_RI_NUMBER_OF_PARTITIONS     = 0xC0,  /* 8        */
 	OSD_ATTR_RI_CLOCK                    = 0x100, /* 6        */
+	OARI_DEFAULT_ISOLATION_METHOD        = 0X110, /* 1        */
+	OARI_SUPPORTED_ISOLATION_METHODS     = 0X111, /* 32       */
+
+	OARI_DATA_ATOMICITY_GUARANTEE                   = 0X120,   /* 8       */
+	OARI_DATA_ATOMICITY_ALIGNMENT                   = 0X121,   /* 8       */
+	OARI_ATTRIBUTES_ATOMICITY_GUARANTEE             = 0X122,   /* 8       */
+	OARI_DATA_ATTRIBUTES_ATOMICITY_MULTIPLIER       = 0X123,   /* 1       */
+
+	OARI_MAXIMUM_SNAPSHOTS_COUNT                    = 0X1C1,    /* 0 or 4 */
+	OARI_MAXIMUM_CLONES_COUNT                       = 0X1C2,    /* 0 or 4 */
+	OARI_MAXIMUM_BRANCH_DEPTH                       = 0X1CC,    /* 0 or 4 */
+	OARI_SUPPORTED_OBJECT_DUPLICATION_METHOD_FIRST  = 0X200,    /* 0 or 4 */
+	OARI_SUPPORTED_OBJECT_DUPLICATION_METHOD_LAST   = 0X2ff,    /* 0 or 4 */
+	OARI_SUPPORTED_TIME_OF_DUPLICATION_METHOD_FIRST = 0X300,    /* 0 or 4 */
+	OARI_SUPPORTED_TIME_OF_DUPLICATION_METHOD_LAST  = 0X30F,    /* 0 or 4 */
+	OARI_SUPPORT_FOR_DUPLICATED_OBJECT_FREEZING     = 0X310,    /* 0 or 4 */
+	OARI_SUPPORT_FOR_SNAPSHOT_REFRESHING            = 0X311,    /* 0 or 1 */
+	OARI_SUPPORTED_CDB_CONTINUATION_DESC_TYPE_FIRST = 0X7000001,/* 0 or 4 */
+	OARI_SUPPORTED_CDB_CONTINUATION_DESC_TYPE_LAST  = 0X700FFFF,/* 0 or 4 */
 };
 /* Root_Information_attributes_page does not have a get_page structure */
 
@@ -120,7 +143,15 @@ enum {
 	OSD_ATTR_PI_PARTITION_ID            = 0x1,     /* 8        */
 	OSD_ATTR_PI_USERNAME                = 0x9,     /* variable */
 	OSD_ATTR_PI_USED_CAPACITY           = 0x81,    /* 8        */
+	OSD_ATTR_PI_USED_CAPACITY_INCREMENT = 0x84,    /* 0 or 8   */
 	OSD_ATTR_PI_NUMBER_OF_OBJECTS       = 0xC1,    /* 8        */
+
+	OSD_ATTR_PI_ACTUAL_DATA_SPACE                      = 0xD1, /* 0 or 8 */
+	OSD_ATTR_PI_RESERVED_DATA_SPACE                    = 0xD2, /* 0 or 8 */
+	OSD_ATTR_PI_DEFAULT_SNAPSHOT_DUPLICATION_METHOD    = 0x200,/* 0 or 4 */
+	OSD_ATTR_PI_DEFAULT_CLONE_DUPLICATION_METHOD       = 0x201,/* 0 or 4 */
+	OSD_ATTR_PI_DEFAULT_SP_TIME_OF_DUPLICATION         = 0x300,/* 0 or 4 */
+	OSD_ATTR_PI_DEFAULT_CLONE_TIME_OF_DUPLICATION      = 0x301,/* 0 or 4 */
 };
 /* Partition Information attributes page does not have a get_page structure */
 
@@ -131,6 +162,7 @@ enum {
 	OSD_ATTR_CI_PARTITION_ID           = 0x1,       /* 8        */
 	OSD_ATTR_CI_COLLECTION_OBJECT_ID   = 0x2,       /* 8        */
 	OSD_ATTR_CI_USERNAME               = 0x9,       /* variable */
+	OSD_ATTR_CI_COLLECTION_TYPE        = 0xA,       /* 1        */
 	OSD_ATTR_CI_USED_CAPACITY          = 0x81,      /* 8        */
 };
 /* Collection Information attributes page does not have a get_page structure */
@@ -144,6 +176,8 @@ enum {
 	OSD_ATTR_OI_USERNAME             = 0x9,       /* variable */
 	OSD_ATTR_OI_USED_CAPACITY        = 0x81,      /* 8        */
 	OSD_ATTR_OI_LOGICAL_LENGTH       = 0x82,      /* 8        */
+	SD_ATTR_OI_ACTUAL_DATA_SPACE     = 0XD1,      /* 0 OR 8   */
+	SD_ATTR_OI_RESERVED_DATA_SPACE   = 0XD2,      /* 0 OR 8   */
 };
 /* Object Information attributes page does not have a get_page structure */
 
@@ -248,7 +282,18 @@ struct object_timestamps_attributes_page {
 	struct osd_timestamp data_modified_time;
 }  __packed;
 
-/* 7.1.2.19 Collections attributes page */
+/* OSD2r05: 7.1.3.19 Attributes Access attributes page
+ * (OSD_APAGE_PARTITION_ATTR_ACCESS)
+ *
+ * each attribute is of the form below. Total array length is deduced
+ * from the attribute's length
+ * (See allowed_attributes_access of the struct osd_cap_object_descriptor)
+ */
+struct attributes_access_attr {
+	struct osd_attributes_list_attrid attr_list[0];
+} __packed;
+
+/* OSD2r05: 7.1.2.21 Collections attributes page */
 /* TBD */
 
 /* 7.1.2.20 Root Policy/Security attributes page (OSD_APAGE_ROOT_SECURITY) */
@@ -324,4 +369,29 @@ struct object_security_attributes_page {
 	__be32 policy_access_tag;
 }  __packed;
 
+/* OSD2r05: 7.1.3.31 Current Command attributes page
+ * (OSD_APAGE_CURRENT_COMMAND)
+ */
+enum {
+	OSD_ATTR_CC_RESPONSE_INTEGRITY_CHECK_VALUE     = 0x1, /* 32  */
+	OSD_ATTR_CC_OBJECT_TYPE                        = 0x2, /* 1   */
+	OSD_ATTR_CC_PARTITION_ID                       = 0x3, /* 8   */
+	OSD_ATTR_CC_OBJECT_ID                          = 0x4, /* 8   */
+	OSD_ATTR_CC_STARTING_BYTE_ADDRESS_OF_APPEND    = 0x5, /* 8   */
+	OSD_ATTR_CC_CHANGE_IN_USED_CAPACITY            = 0x6, /* 8   */
+};
+
+/*TBD: osdv1_current_command_attributes_page */
+
+struct osdv2_current_command_attributes_page {
+	struct osd_attr_page_header hdr;  /* id=0xFFFFFFFE, size=0x44 */
+	u8 response_integrity_check_value[OSD_CRYPTO_KEYID_SIZE];
+	u8 object_type;
+	u8 reserved[3];
+	__be64 partition_id;
+	__be64 object_id;
+	__be64 starting_byte_address_of_append;
+	__be64 change_in_used_capacity;
+};
+
 #endif /*ndef __OSD_ATTRIBUTES_H__*/
-- 
1.6.2.1

