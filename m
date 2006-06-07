From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/2] ipr: Add some hardware defined types for SATA
Date: Wed, 07 Jun 2006 11:28:30 -0500
Message-ID: <200606071628.k57GSUGW020519@d01av03.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:11735 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932307AbWFGQ25 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2006 12:28:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com, brking@us.ibm.com


Add some hardware defined types for SATA. This is required
by future patches to add SATA support to ipr.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/ipr.h |   78 ++++++++++++++++++++++++++++++++--
 1 files changed, 75 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_sata_types drivers/scsi/ipr.h
--- libata-dev/drivers/scsi/ipr.h~ipr_sata_types	2006-06-07 11:03:10.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/ipr.h	2006-06-07 11:03:10.000000000 -0500
@@ -45,6 +45,7 @@
  *	This can be adjusted at runtime through sysfs device attributes.
  */
 #define IPR_MAX_CMD_PER_LUN				6
+#define IPR_MAX_CMD_PER_ATA_LUN			1
 
 /*
  * IPR_NUM_BASE_CMD_BLKS: This defines the maximum number of
@@ -106,7 +107,7 @@
 #define IPR_IOA_BUS						0xff
 #define IPR_IOA_TARGET					0xff
 #define IPR_IOA_LUN						0xff
-#define IPR_MAX_NUM_BUSES				8
+#define IPR_MAX_NUM_BUSES				16
 #define IPR_MAX_BUS_TO_SCAN				IPR_MAX_NUM_BUSES
 
 #define IPR_NUM_RESET_RELOAD_RETRIES		3
@@ -145,6 +146,7 @@
 #define	IPR_LUN_RESET					0x40
 #define	IPR_TARGET_RESET					0x20
 #define	IPR_BUS_RESET					0x10
+#define	IPR_ATA_PHY_RESET					0x80
 #define IPR_ID_HOST_RR_Q				0xC4
 #define IPR_QUERY_IOA_CONFIG				0xC5
 #define IPR_CANCEL_ALL_REQUESTS			0xCE
@@ -295,7 +297,11 @@ struct ipr_std_inq_data {
 }__attribute__ ((packed));
 
 struct ipr_config_table_entry {
-	u8 service_level;
+	u8 proto;
+#define IPR_PROTO_SATA			0x02
+#define IPR_PROTO_SATA_ATAPI		0x03
+#define IPR_PROTO_SAS_STP		0x06
+#define IPR_PROTO_SAS_STP_ATAPI	0x07
 	u8 array_id;
 	u8 flags;
 #define IPR_IS_IOA_RESOURCE	0x80
@@ -307,6 +313,7 @@ struct ipr_config_table_entry {
 #define IPR_SUBTYPE_AF_DASD			0
 #define IPR_SUBTYPE_GENERIC_SCSI	1
 #define IPR_SUBTYPE_VOLUME_SET		2
+#define IPR_SUBTYPE_GENERIC_ATA	4
 
 #define IPR_QUEUEING_MODEL(res)	((((res)->cfgte.flags) & 0x70) >> 4)
 #define IPR_QUEUE_FROZEN_MODEL	0
@@ -350,6 +357,7 @@ struct ipr_cmd_pkt {
 #define IPR_RQTYPE_SCSICDB		0x00
 #define IPR_RQTYPE_IOACMD		0x01
 #define IPR_RQTYPE_HCAM			0x02
+#define IPR_RQTYPE_ATA_PASSTHRU	0x04
 
 	u8 luntar_luntrn;
 
@@ -373,6 +381,37 @@ struct ipr_cmd_pkt {
 	__be16 timeout;
 }__attribute__ ((packed, aligned(4)));
 
+struct ipr_ioarcb_ata_regs {
+	u8 flags;
+#define IPR_ATA_FLAG_PACKET_CMD			0x80
+#define IPR_ATA_FLAG_XFER_TYPE_DMA			0x40
+#define IPR_ATA_FLAG_STATUS_ON_GOOD_COMPLETION	0x20
+	u8 reserved[3];
+
+	__be16 data;
+	u8 feature;
+	u8 nsect;
+	u8 lbal;
+	u8 lbam;
+	u8 lbah;
+	u8 device;
+	u8 command;
+	u8 reserved2[3];
+	u8 hob_feature;
+	u8 hob_nsect;
+	u8 hob_lbal;
+	u8 hob_lbam;
+	u8 hob_lbah;
+	u8 ctl;
+}__attribute__ ((packed, aligned(4)));
+
+struct ipr_ioarcb_add_data {
+	union {
+		struct ipr_ioarcb_ata_regs regs;
+		__be32 add_cmd_parms[10];
+	}u;
+}__attribute__ ((packed, aligned(4)));
+
 /* IOA Request Control Block    128 bytes  */
 struct ipr_ioarcb {
 	__be32 ioarcb_host_pci_addr;
@@ -397,7 +436,7 @@ struct ipr_ioarcb {
 	struct ipr_cmd_pkt cmd_pkt;
 
 	__be32 add_cmd_parms_len;
-	__be32 add_cmd_parms[10];
+	struct ipr_ioarcb_add_data add_data;
 }__attribute__((packed, aligned (4)));
 
 struct ipr_ioadl_desc {
@@ -433,6 +472,21 @@ struct ipr_ioasa_gpdd {
 	__be32 ioa_data[2];
 }__attribute__((packed, aligned (4)));
 
+struct ipr_ioasa_gata {
+	u8 error;
+	u8 nsect;		/* Interrupt reason */
+	u8 lbal;
+	u8 lbam;
+	u8 lbah;
+	u8 device;
+	u8 status;
+	u8 alt_status;	/* ATA CTL */
+	u8 hob_nsect;
+	u8 hob_lbal;
+	u8 hob_lbam;
+	u8 hob_lbah;
+}__attribute__((packed, aligned (4)));
+
 struct ipr_auto_sense {
 	__be16 auto_sense_len;
 	__be16 ioa_data_len;
@@ -466,6 +520,7 @@ struct ipr_ioasa {
 	__be32 ioasc_specific;	/* status code specific field */
 #define IPR_ADDITIONAL_STATUS_FMT		0x80000000
 #define IPR_AUTOSENSE_VALID			0x40000000
+#define IPR_ATA_DEVICE_WAS_RESET		0x20000000
 #define IPR_IOASC_SPECIFIC_MASK		0x00ffffff
 #define IPR_FIELD_POINTER_VALID		(0x80000000 >> 8)
 #define IPR_FIELD_POINTER_MASK		0x0000ffff
@@ -474,6 +529,7 @@ struct ipr_ioasa {
 		struct ipr_ioasa_vset vset;
 		struct ipr_ioasa_af_dasd dasd;
 		struct ipr_ioasa_gpdd gpdd;
+		struct ipr_ioasa_gata gata;
 	} u;
 
 	struct ipr_auto_sense auto_sense;
@@ -1308,6 +1364,22 @@ static inline int ipr_is_scsi_disk(struc
 }
 
 /**
+ * ipr_is_gata - Determine if a resource is a generic ATA resource
+ * @res:	resource entry struct
+ *
+ * Return value:
+ * 	1 if GATA / 0 if not GATA
+ **/
+static inline int ipr_is_gata(struct ipr_resource_entry *res)
+{
+	if (!ipr_is_ioa_resource(res) &&
+	    IPR_RES_SUBTYPE(res) == IPR_SUBTYPE_GENERIC_ATA)
+		return 1;
+	else
+		return 0;
+}
+
+/**
  * ipr_is_naca_model - Determine if a resource is using NACA queueing model
  * @res:	resource entry struct
  *
_
