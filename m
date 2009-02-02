From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/4] [Target_Core_Mod]: Add support for EVPD 0x83 Relative
	target port identifer and SCSI Name string
Date: Sun, 01 Feb 2009 22:02:21 -0800
Message-ID: <1233554541.12375.45.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:46902 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752161AbZBBGD2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2009 01:03:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ming Zhang <blackmagic02881@gmail.com>, Arne Redlich <agr@powerkom-dd.de>, "Ross S. W. Walker" <rswwalker@gmail.com>, Rafiu Fakunle <rafiu@openfiler.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

>From 436a7d09dc1eeb907c3f4274d72e117679ee94ac Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sun, 1 Feb 2009 21:41:20 -0800
Subject: [PATCH 3/4] [Target_Core_Mod]: Add support for EVPD 0x83 Relative target port identifer and SCSI Name string

This patch adds support for Relative target port identifer and SCSI name string identifer
generically in Target_Core_Mod v3.0.  It adds

struct target_core_fabric_ops->get_fabric_proto_ident()

to extract the SPC-4 defined PROTOCOL IDENTIFER from $FABRIC_MOD.  For more information
see spc4r17 section 7.7.3.x.

Here is what it looks like in action using sg3_util's sg_inq program:

initiator:# sg_inq -e --page=0x83 -v /dev/sdh
VPD INQUIRY: Device Identification page
    inquiry cdb: 12 01 83 00 fc 00
  Designation descriptor number 1, descriptor length: 58
    id_type: T10 vendor identification,  code_set: ASCII
    associated with the addressed logical unit
      vendor id: LIO-ORG
      vendor specific: IBLOCK:eEaqKo-gYF8-vnDA-jJhf-Xqzy-pjGF-G6Y50v
  Designation descriptor number 2, descriptor length: 8
    transport: Internet SCSI (iSCSI)
    id_type: Relative target port,  code_set: Binary
    associated with the target port
      Relative target port: 0x1
  Designation descriptor number 3, descriptor length: 72
    transport: Internet SCSI (iSCSI)
    id_type: SCSI name string,  code_set: UTF-8
    associated with the target port
      SCSI name string:
      iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd,t,0x0001

This patch also converts transport_generic_emulate_inquiry() for
explict checks of overflow of DATAIN payload for each EVPD 0x83
attached identifier.  In the overflow case, we return REQUEST +
INVALID FIELD IN CDB following spc4r17 Section 4.3.5.6.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_fabric_ops.h |    1 +
 drivers/lio-core/target_core_transport.c  |  180 +++++++++++++++++++++++++----
 2 files changed, 160 insertions(+), 21 deletions(-)

diff --git a/drivers/lio-core/target_core_fabric_ops.h b/drivers/lio-core/target_core_fabric_ops.h
index a54aa94..5924cbd 100644
--- a/drivers/lio-core/target_core_fabric_ops.h
+++ b/drivers/lio-core/target_core_fabric_ops.h
@@ -1,5 +1,6 @@
 struct target_core_fabric_ops {
 	char *(*get_fabric_name)(void);
+	u8 (*get_fabric_proto_ident)(void);
 	char *(*tpg_get_wwn)(struct se_portal_group_s *);
 	u16 (*tpg_get_tag)(struct se_portal_group_s *);
 	u32 (*tpg_get_default_depth)(struct se_portal_group_s *);
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index a151584..5bb13b2 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -4025,13 +4025,17 @@ extern int transport_generic_emulate_inquiry (
 	unsigned char *se_location)
 {
 	se_device_t *dev = SE_DEV(cmd);
+	se_lun_t *lun = SE_LUN(cmd);
+	se_port_t *port = NULL;
 	unsigned char *dst = (unsigned char *) T_TASK(cmd)->t_task_buf;
 	unsigned char *cdb = T_TASK(cmd)->t_task_cdb;
-	unsigned char *iqn_sn, buf[EVPD_BUF_LEN];
-	u32 len = 0;
+	unsigned char *iqn_sn, *buf;
+	u32 vend_len, prod_len, iqn_sn_len, se_location_len;
+	u32 unit_serial_len;
+	u32 len = 0, off = 0;
 	
 	memset(dst, 0, cmd->data_length);
-	memset(buf, 0, EVPD_BUF_LEN);
+	buf = dst;
 
 	buf[0] = type;
 	
@@ -4048,7 +4052,7 @@ extern int transport_generic_emulate_inquiry (
 		snprintf((unsigned char *)&buf[32], 5, "%s", version);
 		len = 32;
 
-		goto copy;
+		goto check;
 	}
 
 	switch (cdb[2]) {
@@ -4062,49 +4066,183 @@ extern int transport_generic_emulate_inquiry (
 		break;
 	case 0x80: /* unit serial number */
 		buf[1] = 0x80;
-		if (dev->se_sub_dev->su_dev_flags & SDF_EMULATED_EVPD_UNIT_SERIAL)
+		if (dev->se_sub_dev->su_dev_flags & SDF_EMULATED_EVPD_UNIT_SERIAL) {
+			unit_serial_len = strlen(&DEV_T10_WWN(dev)->unit_serial[0]);
+			unit_serial_len++; // For NULL Terminator
+
+			if (((len + 4) + unit_serial_len) > cmd->data_length) {
+				len += unit_serial_len; // Make check: below fail
+				goto check;
+			}
 			len += sprintf((unsigned char *)&buf[4], "%s",
 				&DEV_T10_WWN(dev)->unit_serial[0]);
-		else {
+		 } else {
 			iqn_sn = transport_get_iqn_sn();
+			iqn_sn_len = strlen(iqn_sn);
+			iqn_sn_len++; // For ":"
+			se_location_len = strlen(se_location);
+			se_location_len++; // For NULL Terminator
+
+			if (((len + 4) + (iqn_sn_len + se_location_len)) >
+					cmd->data_length) {
+				len += (iqn_sn_len + se_location_len);
+				goto check;
+			}
 			len += sprintf((unsigned char *)&buf[4], "%s:%s",
 				iqn_sn, se_location);
 		}
+		len++; // Extra Byte for NULL Terminator
 		buf[3] = len;
 		break;
-	case 0x83: /* device identification */
+	case 0x83:
+		/*
+	 	 * Device identification EVPD, for a complete list of
+		 * DESIGNATOR TYPEs see spc4r17 Table 459.
+		 */
 		buf[1] = 0x83;
-		/* Start Identifier Page */
+		/*
+		 * T10 Vendor Identifier Page, see spc4r17 section 7.7.3.4
+		 */
 		buf[4] = 0x2; /* ASCII */
-		buf[5] = 0x1;
+		buf[5] = 0x1; /* T10 Vendor ID */
 		buf[6] = 0x0;
-		
-		len += sprintf((unsigned char *)&buf[8], "%-8s", "LIO-ORG");
-		
-		if (dev->se_sub_dev->su_dev_flags & SDF_EMULATED_EVPD_UNIT_SERIAL)
+
+		vend_len = sprintf((unsigned char *)&buf[8], "%-8s", "LIO-ORG");		
+		len += vend_len;
+
+		prod_len = 4; // For EVPD Header
+		prod_len += vend_len; // For LIO-ORG
+		prod_len += strlen(prod);
+		prod_len++; // For :
+
+		if (dev->se_sub_dev->su_dev_flags & SDF_EMULATED_EVPD_UNIT_SERIAL) {
+			unit_serial_len = strlen(&DEV_T10_WWN(dev)->unit_serial[0]);
+			unit_serial_len++; // For NULL Terminator
+
+			if (((len + 4) + (prod_len + unit_serial_len)) >
+					cmd->data_length) {
+				// Make check: fail below
+				len += (prod_len + unit_serial_len); 
+				goto check;
+			}
 			len += sprintf((unsigned char *)&buf[16], "%s:%s", prod,
 					&DEV_T10_WWN(dev)->unit_serial[0]);
-		else {
+		} else {
 			iqn_sn = transport_get_iqn_sn();
+			iqn_sn_len = strlen(iqn_sn);
+			iqn_sn_len++; // For ":"
+			se_location_len = strlen(se_location);
+			se_location_len++; // For NULL Terminator
+
+			if (((len + 4) + (prod_len + iqn_sn_len + se_location_len)) >
+					cmd->data_length) {
+				// Make check: fail below
+				len += (prod_len + iqn_sn_len + se_location_len);
+				goto check; 
+			}
 			len += sprintf((unsigned char *)&buf[16], "%s:%s:%s",
 					prod, iqn_sn, se_location);
 		}
-		buf[7] = len; /* Identifier Length */
-		len += 4;
-		buf[3] = len; /* Page Length */
+		len++; // Extra Byte for NULL Terminator
+		buf[7] = len; // Identifier Length
+		len += 4; // Header size for Designation descriptor 
+		off = (len + 4);
+		/*
+		 * se_port_t is only set for INQUIRY EVPD=1 through $FABRIC_MOD
+		 */
+		if ((port = lun->lun_sep)) {	
+			se_portal_group_t *tpg = port->sep_tpg;
+			u32 padding, scsi_name_len;
+			u16 tpgt;
+			/*
+			 * Relative target port identifer, see spc4r17 section 7.7.3.7 
+			 *
+			 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
+			 * section 7.5.1 Table 362
+			 */
+			if (((len + 4) + 8) > cmd->data_length) {
+				len += 8; // Make check: below fail
+				goto check;
+			}
+			buf[off] = (TPG_TFO(tpg)->get_fabric_proto_ident() << 4); 
+			buf[off++] |= 0x1; // CODE SET == Binary 
+			buf[off] = 0x80; // Set PIV=1 
+			buf[off] |= 0x10; // Set ASSOICATION == target port: 01b 
+			buf[off++] |= 0x4; // DESIGNATOR TYPE == Relative target port identifer
+			off++; // Skip over Reserved
+			buf[off++] = 4; /* DESIGNATOR LENGTH */
+			off += 2; // Skip over Obsolete field in RTPI payload in Table 472
+			buf[off++] = ((port->sep_rtpi >> 8) & 0xff);
+			buf[off++] = (port->sep_rtpi & 0xff);
+			len += 8; // Header size + Designation descriptor 
+			/*
+			 * SCSI name string designator, see spc4r17 section 7.7.3.11
+			 *
+			 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
+			 * section 7.5.1 Table 362	
+			 */
+			scsi_name_len = strlen(TPG_TFO(tpg)->tpg_get_wwn(tpg));
+			scsi_name_len += 10; // UTF-8 ",t,0x<16-bit TPGT>" + NULL Terminator
+			scsi_name_len += 4; // Header size + Designation descriptor
+			if ((padding = ((-scsi_name_len) & 3)) != 0)
+                                scsi_name_len += padding;
+
+			if ((len + scsi_name_len) > cmd->data_length) {
+				len += scsi_name_len; // Make check: below fail
+				goto check;
+			}
+			buf[off] = (TPG_TFO(tpg)->get_fabric_proto_ident() << 4);
+			buf[off++] |= 0x3; // CODE SET == UTF-8
+			buf[off] = 0x80; // Set PIV=1
+			buf[off] |= 0x10; // Set ASSOICATION == target port: 01b
+			buf[off++] |= 0x8; // DESIGNATOR TYPE == SCSI name string
+			off += 2; // Skip over Reserved and length
+			/*
+			 * SCSI name string identifer containing, $FABRIC_MOD
+			 * dependent information.  For LIO-Target and iSCSI
+			 * Target Port, this means "<iSCSI name>,t,0x<TPGT> in
+			 * UTF-8 encoding.
+			 */			
+			tpgt = TPG_TFO(tpg)->tpg_get_tag(tpg);
+			scsi_name_len = sprintf(&buf[off], "%s,t,0x%04x",
+					TPG_TFO(tpg)->tpg_get_wwn(tpg), tpgt); 
+			scsi_name_len += 1 /* Include  NULL terminator */;
+			/*
+			 * The null-terminated, null-padded (see 4.4.2) SCSI NAME STRING field
+			 * contains a UTF-8 format string. The number of bytes in the SCSI NAME
+			 * STRING field (i.e., the value in the DESIGNATOR LENGTH field) shall
+			 * be no larger than 256 and shall be a multiple of four.
+			 */
+			if (padding)
+				scsi_name_len += padding;
+
+			buf[off-1] = scsi_name_len;
+			off += scsi_name_len;
+			len += (scsi_name_len + 4); // Header size + Designation descriptor 
+		}
+
+		buf[3] = len; /* Page Length for EVPD 0x83 */
 		break;
 	default:
 		TRACE_ERROR("Unknown EVPD Code: 0x%02x\n", cdb[2]);
 		return(-1);
 	}
 
-copy:
+check:
 	if ((len + 4) > cmd->data_length) {
+		/*
+		 * From spc4r17 Section 4.3.5.6
+		 * If the amount of information to be transferred exceeds the
+		 * maximum value that the ALLOCATION LENGTH field is capable
+		 * of specifying, the device server shall transfer no data and
+		 * terminate the command with CHECK CONDITION status, with the
+		 * sense key set to ILLEGAL REQUEST, and the additional sense
+		 * code set to INVALID FIELD IN CDB.
+		 */
 		TRACE_ERROR("Inquiry EVPD Length: %u larger than"
 			" cmd->data_length: %u\n", (len + 4), cmd->data_length);
-		memcpy(dst, buf, cmd->data_length);
-	} else
-		memcpy(dst, buf, (len + 4));
+		return(PYX_TRANSPORT_INVALID_CDB_FIELD);
+	}
 
 	return(0);
 }
-- 
1.5.4.1



