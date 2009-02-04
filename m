From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/ALUA]: Make EVPD 0x83 identifers return
	GOOD status during overflow
Date: Wed, 04 Feb 2009 03:41:56 -0800
Message-ID: <1233747716.12375.265.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:48837 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750782AbZBDLnF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Feb 2009 06:43:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ming Zhang <blackmagic02881@gmail.com>

Greetings all,

This patch makes transport_generic_emulate_inquiry() properly handle the case
where a received allocation length is smaller than the total outgoing EVPD 0x83
DataIN payload containing the full set of emulated identifiers.  This is what
scsi_dh_alua does; use an allocation length of 36 and then retry with a larger
allocation length based on what is returned in the EVPD payload during the initial
overflow case.

Instead of failing during the overflow case as before, this patch will calculate
the total size required to transmit the complete set of emulated EVPD 0x83
identifiers, and encode this value into the response payload with GOOD SAM status.
At this point the Initiator Port is expected to notice that the encoded EVPD length
is greater than the allocation length of the original CDB, and retry again with new
allocation length in order to retreive the complete set of EVPD 0x83 identifiers.

This patch is made against lio-core-2.6.git/master
and tested on v2.6.29-rc2 x86 32-bit HVM.  The lio-core-2.6.git tree can be
found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_transport.c |   66 +++++++++++++-----------------
 1 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index ae51b5f..3167486 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -4032,12 +4032,13 @@ extern int transport_generic_emulate_inquiry (
 	se_device_t *dev = SE_DEV(cmd);
 	se_lun_t *lun = SE_LUN(cmd);
 	se_port_t *port = NULL;
+	se_portal_group_t *tpg = NULL;
 	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
 	unsigned char *cdb = T_TASK(cmd)->t_task_cdb;
 	unsigned char *iqn_sn;
 	u32 vend_len, prod_len, iqn_sn_len, se_location_len;
-	u32 unit_serial_len;
-	u32 len = 0, off = 0;
+	u32 unit_serial_len, off = 0;
+	u16 len = 0;
 	
 	buf[0] = type;
 	
@@ -4067,7 +4068,7 @@ extern int transport_generic_emulate_inquiry (
 		snprintf((unsigned char *)&buf[32], 5, "%s", version);
 		len = 32;
 
-		goto check;
+		return(0);
 	}
 
 	switch (cdb[2]) {
@@ -4087,7 +4088,7 @@ extern int transport_generic_emulate_inquiry (
 
 			if (((len + 4) + unit_serial_len) > cmd->data_length) {
 				len += unit_serial_len; // Make check: below fail
-				goto check;
+				goto set_len;
 			}
 			len += sprintf((unsigned char *)&buf[4], "%s",
 				&DEV_T10_WWN(dev)->unit_serial[0]);
@@ -4101,7 +4102,7 @@ extern int transport_generic_emulate_inquiry (
 			if (((len + 4) + (iqn_sn_len + se_location_len)) >
 					cmd->data_length) {
 				len += (iqn_sn_len + se_location_len);
-				goto check;
+				goto set_len;
 			}
 			len += sprintf((unsigned char *)&buf[4], "%s:%s",
 				iqn_sn, se_location);
@@ -4118,15 +4119,9 @@ extern int transport_generic_emulate_inquiry (
 		/*
 		 * T10 Vendor Identifier Page, see spc4r17 section 7.7.3.4
 		 */
-		buf[4] = 0x2; /* ASCII */
-		buf[5] = 0x1; /* T10 Vendor ID */
-		buf[6] = 0x0;
-
-		vend_len = sprintf((unsigned char *)&buf[8], "%-8s", "LIO-ORG");		
-		len += vend_len;
-
+		len += 8; // For Vendor field
 		prod_len = 4; // For EVPD Header
-		prod_len += vend_len; // For LIO-ORG
+		prod_len += 8; // For Vendor field
 		prod_len += strlen(prod);
 		prod_len++; // For :
 
@@ -4138,7 +4133,7 @@ extern int transport_generic_emulate_inquiry (
 					cmd->data_length) {
 				// Make check: fail below
 				len += (prod_len + unit_serial_len); 
-				goto check;
+				goto check_rtpi;
 			}
 			len += sprintf((unsigned char *)&buf[16], "%s:%s", prod,
 					&DEV_T10_WWN(dev)->unit_serial[0]);
@@ -4153,11 +4148,16 @@ extern int transport_generic_emulate_inquiry (
 					cmd->data_length) {
 				// Make check: fail below
 				len += (prod_len + iqn_sn_len + se_location_len);
-				goto check; 
+				goto check_rtpi;
 			}
 			len += sprintf((unsigned char *)&buf[16], "%s:%s:%s",
 					prod, iqn_sn, se_location);
 		}
+		buf[4] = 0x2; /* ASCII */
+		buf[5] = 0x1; /* T10 Vendor ID */
+		buf[6] = 0x0;
+		memcpy((unsigned char *)&buf[8], "LIO-ORG", 8);
+
 		len++; // Extra Byte for NULL Terminator
 		buf[7] = len; // Identifier Length
 		len += 4; // Header size for Designation descriptor 
@@ -4166,20 +4166,22 @@ extern int transport_generic_emulate_inquiry (
 		 * se_port_t is only set for INQUIRY EVPD=1 through $FABRIC_MOD
 		 */
 		if ((port = lun->lun_sep)) {	
-			se_portal_group_t *tpg = port->sep_tpg;
 			u32 padding, scsi_name_len;
 			u16 lun_gp = 0;	// Set to zero for implict ALUA
 			u16 tg_pg_i = 0; // Set to zero for implict ALUA
 			u16 tpgt;
+
+			tpg = port->sep_tpg;
 			/*
 			 * Relative target port identifer, see spc4r17 section 7.7.3.7 
 			 *
 			 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
 			 * section 7.5.1 Table 362
 			 */
+check_rtpi:
 			if (((len + 4) + 8) > cmd->data_length) {
 				len += 8; // Make check: below fail
-				goto check;
+				goto check_tpgi;
 			}
 			buf[off] = (TPG_TFO(tpg)->get_fabric_proto_ident() << 4); 
 			buf[off++] |= 0x1; // CODE SET == Binary 
@@ -4198,9 +4200,10 @@ extern int transport_generic_emulate_inquiry (
 			 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
 			 * section 7.5.1 Table 362 
 			 */
+check_tpgi:
 			if (((len + 4) + 8) > cmd->data_length) {
 				len += 8; // Make check: below fail
-				goto check;
+				goto check_lu_gp;
 			}
 			buf[off] = (TPG_TFO(tpg)->get_fabric_proto_ident() << 4);
 			buf[off++] |= 0x1; // CODE SET == Binary
@@ -4216,9 +4219,10 @@ extern int transport_generic_emulate_inquiry (
 			/*
 			 * Logical Unit Group identifier, see spc4r17 section 7.7.3.8
 			 */	
+check_lu_gp:
 			if (((len + 4) + 8) > cmd->data_length) {
 				len += 8; // Make check: below fail
-				goto check;
+				goto check_scsi_name;
 			}
 			buf[off++] |= 0x1; // CODE SET == Binary
 			buf[off++] |= 0x6; // DESIGNATOR TYPE == Logical Unit Group identifier
@@ -4234,6 +4238,7 @@ extern int transport_generic_emulate_inquiry (
 			 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
 			 * section 7.5.1 Table 362	
 			 */
+check_scsi_name:
 			scsi_name_len = strlen(TPG_TFO(tpg)->tpg_get_wwn(tpg));
 			scsi_name_len += 10; // UTF-8 ",t,0x<16-bit TPGT>" + NULL Terminator
 			scsi_name_len += 4; // Header size + Designation descriptor
@@ -4242,7 +4247,7 @@ extern int transport_generic_emulate_inquiry (
 
 			if ((len + scsi_name_len) > cmd->data_length) {
 				len += scsi_name_len; // Make check: below fail
-				goto check;
+				goto set_len;
 			}
 			buf[off] = (TPG_TFO(tpg)->get_fabric_proto_ident() << 4);
 			buf[off++] |= 0x3; // CODE SET == UTF-8
@@ -4273,30 +4278,15 @@ extern int transport_generic_emulate_inquiry (
 			off += scsi_name_len;
 			len += (scsi_name_len + 4); // Header size + Designation descriptor 
 		}
-
-		buf[3] = len; /* Page Length for EVPD 0x83 */
+set_len:
+		buf[2] = ((len >> 8) & 0xff);
+		buf[3] = (len & 0xff); /* Page Length for EVPD 0x83 */
 		break;
 	default:
 		TRACE_ERROR("Unknown EVPD Code: 0x%02x\n", cdb[2]);
 		return(-1);
 	}
 
-check:
-	if ((len + 4) > cmd->data_length) {
-		/*
-		 * From spc4r17 Section 4.3.5.6
-		 * If the amount of information to be transferred exceeds the
-		 * maximum value that the ALLOCATION LENGTH field is capable
-		 * of specifying, the device server shall transfer no data and
-		 * terminate the command with CHECK CONDITION status, with the
-		 * sense key set to ILLEGAL REQUEST, and the additional sense
-		 * code set to INVALID FIELD IN CDB.
-		 */
-		TRACE_ERROR("Inquiry EVPD Length: %u larger than"
-			" cmd->data_length: %u\n", (len + 4), cmd->data_length);
-		return(PYX_TRANSPORT_INVALID_CDB_FIELD);
-	}
-
 	return(0);
 }
 
-- 
1.5.4.1



