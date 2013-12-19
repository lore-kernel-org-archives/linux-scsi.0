From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] target_core_spc: bounds check for spc_emulate_inquiry()
Date: Thu, 19 Dec 2013 14:36:12 +0100
Message-ID: <1387460172-27396-3-git-send-email-hare@suse.de>
References: <1387460172-27396-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab3LSNgP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Dec 2013 08:36:15 -0500
In-Reply-To: <1387460172-27396-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Instead of using a static buffer for inquiry data we should
rather use the command-provided buffer and implement proper
bounds checking when writing to it.
Inquiry is by no means time-critical ...

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_spc.c     | 391 +++++++++++++++++++++--------------
 include/target/target_core_backend.h |   2 +-
 2 files changed, 235 insertions(+), 158 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index f9889fd..942f72e 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -71,6 +71,10 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 {
 	struct se_lun *lun = cmd->se_lun;
 	struct se_device *dev = cmd->se_dev;
+	int len;
+
+	if (cmd->data_length < 6)
+		return TCM_INVALID_CDB_FIELD;
 
 	/* Set RMB (removable media) for tape devices */
 	if (dev->transport->get_device_type(dev) == TYPE_TAPE)
@@ -101,14 +105,27 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	if (dev->dev_attrib.emulate_3pc)
 		buf[5] |= 0x8;
 
-	buf[7] = 0x2; /* CmdQue=1 */
+	if (cmd->data_length > 7)
+		buf[7] = 0x2; /* CmdQue=1 */
+
+	if (cmd->data_length > 8) {
+		len = min_t(size_t, cmd->data_length - 8, 8);
+		memset(&buf[8], 0x20, len);
+		memcpy(&buf[8], "LIO-ORG", len);
+	}
+	if (cmd->data_length > 16) {
+		memset(&buf[16], 0x20,
+		       min_t(size_t, cmd->data_length - 16, 16));
+		len = min_t(size_t, strlen(dev->t10_wwn.model), 16);
+		memcpy(&buf[16], dev->t10_wwn.model,
+		       min_t(size_t, len, cmd->data_length - 16));
+	}
+	if (cmd->data_length > 32) {
+		len = min_t(size_t, strlen(dev->t10_wwn.revision), 4);
+		memcpy(&buf[32], dev->t10_wwn.revision,
+		       min_t(size_t, len, cmd->data_length - 32));
+	}
 
-	memcpy(&buf[8], "LIO-ORG ", 8);
-	memset(&buf[16], 0x20, 16);
-	memcpy(&buf[16], dev->t10_wwn.model,
-	       min_t(size_t, strlen(dev->t10_wwn.model), 16));
-	memcpy(&buf[32], dev->t10_wwn.revision,
-	       min_t(size_t, strlen(dev->t10_wwn.revision), 4));
 	buf[4] = 31; /* Set additional length to 31 */
 
 	return 0;
@@ -117,32 +134,53 @@ EXPORT_SYMBOL(spc_emulate_inquiry_std);
 
 /* unit serial number */
 static sense_reason_t
-spc_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf)
+spc_emulate_evpd_80(struct se_cmd *cmd, unsigned char *buf, int buf_len)
 {
 	struct se_device *dev = cmd->se_dev;
 	u16 len = 0;
 
+	if (buf_len < 4)
+		return TCM_INVALID_CDB_FIELD;
+
 	if (dev->dev_flags & DF_EMULATED_VPD_UNIT_SERIAL) {
 		u32 unit_serial_len;
 
 		unit_serial_len = strlen(dev->t10_wwn.unit_serial);
 		unit_serial_len++; /* For NULL Terminator */
 
-		len += sprintf(&buf[4], "%s", dev->t10_wwn.unit_serial);
+		if (buf_len > unit_serial_len + 5)
+			len += sprintf(&buf[4], "%s",
+				       dev->t10_wwn.unit_serial);
 		len++; /* Extra Byte for NULL Terminator */
 		buf[3] = len;
 	}
 	return 0;
 }
 
-void spc_parse_naa_6h_vendor_specific(struct se_device *dev,
-				      unsigned char *buf)
+int spc_parse_naa_6h_vendor_specific(struct se_device *dev,
+				      unsigned char *buf, int buf_len)
 {
 	unsigned char *p = &dev->t10_wwn.unit_serial[0];
-	int cnt;
+	int cnt = 0, end = buf_len;
 	bool next = true;
 
 	/*
+	 * NAA IEEE Registered Extended Identifier/Designator
+	 */
+	if (cnt < end)
+		buf[cnt++] = 0x6 << 4;
+
+	/*
+	 * Use OpenFabrics IEEE Company ID: 00 14 05
+	 */
+	if (cnt < end)
+		buf[cnt++] |= 0x01;
+	if (cnt < end)
+		buf[cnt++] = 0x40;
+	if (cnt < end)
+		buf[cnt] = 0x5 << 4;
+
+	/*
 	 * Generate up to 36 bits of VENDOR SPECIFIC IDENTIFIER starting on
 	 * byte 3 bit 3-0 for NAA IEEE Registered Extended DESIGNATOR field
 	 * format, followed by 64 bits of VENDOR SPECIFIC IDENTIFIER EXTENSION
@@ -150,7 +188,9 @@ void spc_parse_naa_6h_vendor_specific(struct se_device *dev,
 	 * NUMBER set via vpd_unit_serial in target_core_configfs.c to ensure
 	 * per device uniqeness.
 	 */
-	for (cnt = 0; *p && cnt < 13; p++) {
+	if (end > 16)
+		end = 16;
+	for (; *p && cnt < end; p++) {
 		int val = hex_to_bin(*p);
 
 		if (val < 0)
@@ -158,20 +198,24 @@ void spc_parse_naa_6h_vendor_specific(struct se_device *dev,
 
 		if (next) {
 			next = false;
-			buf[cnt++] |= val;
+			buf[cnt++] |= (val & 0xf);
 		} else {
 			next = true;
-			buf[cnt] = val << 4;
+			buf[cnt] = (val & 0xf) << 4;
 		}
 	}
+	return cnt;
 }
 
+#define SET_VPD_DATA(b,l,o,d)			\
+	if ((l) > (o)) b[o] = d; (o)++;
+
 /*
  * Device identification VPD, for a complete list of
  * DESIGNATOR TYPEs see spc4r17 Table 459.
  */
 sense_reason_t
-spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
+spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf, int buf_len)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_lun *lun = cmd->se_lun;
@@ -181,9 +225,12 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem;
 	unsigned char *prod = &dev->t10_wwn.model[0];
-	u32 prod_len;
-	u32 unit_serial_len, off = 0;
-	u16 len = 0, id_len;
+	u16 off, id_len;
+	size_t len;
+	int serial_off;
+
+	if (buf_len < 4)
+		return TCM_INVALID_CDB_FIELD;
 
 	off = 4;
 
@@ -199,68 +246,61 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 		goto check_t10_vend_desc;
 
 	/* CODE SET == Binary */
-	buf[off++] = 0x1;
+	SET_VPD_DATA(buf, buf_len, off, 0x1);
 
 	/* Set ASSOCIATION == addressed logical unit: 0)b */
-	buf[off] = 0x00;
-
 	/* Identifier/Designator type == NAA identifier */
-	buf[off++] |= 0x3;
+	SET_VPD_DATA(buf, buf_len, off, 0x3);
 	off++;
 
 	/* Identifier/Designator length */
-	buf[off++] = 0x10;
-
-	/*
-	 * Start NAA IEEE Registered Extended Identifier/Designator
-	 */
-	buf[off++] = (0x6 << 4);
-
-	/*
-	 * Use OpenFabrics IEEE Company ID: 00 14 05
-	 */
-	buf[off++] = 0x01;
-	buf[off++] = 0x40;
-	buf[off] = (0x5 << 4);
+	SET_VPD_DATA(buf, buf_len, off, 0x10);
 
 	/*
 	 * Return ConfigFS Unit Serial Number information for
 	 * VENDOR_SPECIFIC_IDENTIFIER and
 	 * VENDOR_SPECIFIC_IDENTIFIER_EXTENTION
 	 */
-	spc_parse_naa_6h_vendor_specific(dev, &buf[off]);
-
-	len = 20;
-	off = (len + 4);
+	off += spc_parse_naa_6h_vendor_specific(dev, &buf[off],
+						buf_len - off);
 
 check_t10_vend_desc:
 	/*
 	 * T10 Vendor Identifier Page, see spc4r17 section 7.7.3.4
 	 */
-	id_len = 8; /* For Vendor field */
-	prod_len = 4; /* For VPD Header */
-	prod_len += 8; /* For Vendor field */
-	prod_len += strlen(prod);
-	prod_len++; /* For : */
+	/* Vendor field: 8 characters */
+	id_len = buf_len - off - 4 > 8 ? 8 : buf_len - off - 4;
+
+	len = min_t(size_t, strlen(prod), buf_len - off - 12);
+	if (buf_len > off + 12)
+		memcpy(&buf[off + 12], prod, len);
+
+	id_len += len;
+	serial_off = off + 12 + len;
 
 	if (dev->dev_flags & DF_EMULATED_VPD_UNIT_SERIAL) {
-		unit_serial_len = strlen(&dev->t10_wwn.unit_serial[0]);
-		unit_serial_len++; /* For NULL Terminator */
+		buf[serial_off] = ':';
+		serial_off++;
+		len = min_t(size_t, buf_len - serial_off,
+			    strlen(&dev->t10_wwn.unit_serial[0]));
+		if (len > 0)
+			memcpy(&buf[serial_off],
+			       &dev->t10_wwn.unit_serial[0], len);
+		id_len += len;
+	}
 
-		id_len += sprintf(&buf[off+12], "%s:%s", prod,
-				&dev->t10_wwn.unit_serial[0]);
+	SET_VPD_DATA(buf, buf_len, off, 0x2); /* ASCII */
+	SET_VPD_DATA(buf, buf_len, off, 0x1); /* T10 Vendor ID */
+	SET_VPD_DATA(buf, buf_len, off, 0x0);
+	SET_VPD_DATA(buf, buf_len, off, id_len);/* Identifier Length */
+	if (buf_len > off) {
+		memset(&buf[off], 0x20, id_len > 8 ? 8 : id_len);
+		memcpy(&buf[off], "LIO-ORG", id_len > 8 ? 8 : id_len);
 	}
-	buf[off] = 0x2; /* ASCII */
-	buf[off+1] = 0x1; /* T10 Vendor ID */
-	buf[off+2] = 0x0;
-	memcpy(&buf[off+4], "LIO-ORG", 8);
-	/* Extra Byte for NULL Terminator */
-	id_len++;
-	/* Identifier Length */
-	buf[off+3] = id_len;
+
 	/* Header size for Designation descriptor */
-	len += (id_len + 4);
-	off += (id_len + 4);
+	off += id_len;
+
 	/*
 	 * struct se_port is only set for INQUIRY VPD=1 through $FABRIC_MOD
 	 */
@@ -271,6 +311,7 @@ check_t10_vend_desc:
 		u16 lu_gp_id = 0;
 		u16 tg_pt_gp_id = 0;
 		u16 tpgt;
+		u8 d;
 
 		tpg = port->sep_tpg;
 		/*
@@ -280,22 +321,22 @@ check_t10_vend_desc:
 		 * Get the PROTOCOL IDENTIFIER as defined by spc4r17
 		 * section 7.5.1 Table 362
 		 */
-		buf[off] =
-			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
-		buf[off++] |= 0x1; /* CODE SET == Binary */
-		buf[off] = 0x80; /* Set PIV=1 */
+		d = tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4;
+		d |= 0x1; /* CODE SET == Binary */;
+		SET_VPD_DATA(buf, buf_len, off, d);
+		d =  0x80; /* Set PIV=1 */
 		/* Set ASSOCIATION == target port: 01b */
-		buf[off] |= 0x10;
+		d |= 0x10;
 		/* DESIGNATOR TYPE == Relative target port identifer */
-		buf[off++] |= 0x4;
-		off++; /* Skip over Reserved */
-		buf[off++] = 4; /* DESIGNATOR LENGTH */
+		d |= 0x4;
+		SET_VPD_DATA(buf, buf_len, off, d);
+		off ++; /* Skip over Reserved */
+		SET_VPD_DATA(buf, buf_len, off, 4); /* DESIGNATOR LENGTH */
 		/* Skip over Obsolete field in RTPI payload
 		 * in Table 472 */
 		off += 2;
-		buf[off++] = ((port->sep_rtpi >> 8) & 0xff);
-		buf[off++] = (port->sep_rtpi & 0xff);
-		len += 8; /* Header size + Designation descriptor */
+		SET_VPD_DATA(buf, buf_len, off, (port->sep_rtpi >> 8) & 0xff);
+		SET_VPD_DATA(buf, buf_len, off, port->sep_rtpi & 0xff);
 		/*
 		 * Target port group identifier, see spc4r17
 		 * section 7.7.3.8
@@ -316,20 +357,20 @@ check_t10_vend_desc:
 		tg_pt_gp_id = tg_pt_gp->tg_pt_gp_id;
 		spin_unlock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
 
-		buf[off] =
-			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
-		buf[off++] |= 0x1; /* CODE SET == Binary */
-		buf[off] = 0x80; /* Set PIV=1 */
+		d = tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4;
+		d |= 0x1; /* CODE SET == Binary */
+		SET_VPD_DATA(buf, buf_len, off, d);
+		d = 0x80; /* Set PIV=1 */
 		/* Set ASSOCIATION == target port: 01b */
-		buf[off] |= 0x10;
+		d |= 0x10;
 		/* DESIGNATOR TYPE == Target port group identifier */
-		buf[off++] |= 0x5;
-		off++; /* Skip over Reserved */
-		buf[off++] = 4; /* DESIGNATOR LENGTH */
+		d |= 0x5;
+		SET_VPD_DATA(buf, buf_len, off, d);
+		off ++; /* Skip over Reserved */
+		SET_VPD_DATA(buf, buf_len, off, 4); /* DESIGNATOR LENGTH */
 		off += 2; /* Skip over Reserved Field */
-		buf[off++] = ((tg_pt_gp_id >> 8) & 0xff);
-		buf[off++] = (tg_pt_gp_id & 0xff);
-		len += 8; /* Header size + Designation descriptor */
+		SET_VPD_DATA(buf, buf_len, off, (tg_pt_gp_id >> 8) & 0xff);
+		SET_VPD_DATA(buf, buf_len, off, tg_pt_gp_id & 0xff);
 		/*
 		 * Logical Unit Group identifier, see spc4r17
 		 * section 7.7.3.8
@@ -348,15 +389,14 @@ check_lu_gp:
 		lu_gp_id = lu_gp->lu_gp_id;
 		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
-		buf[off++] |= 0x1; /* CODE SET == Binary */
+		SET_VPD_DATA(buf, buf_len, off, 0x1);/* CODE SET == Binary */
 		/* DESIGNATOR TYPE == Logical Unit Group identifier */
-		buf[off++] |= 0x6;
-		off++; /* Skip over Reserved */
-		buf[off++] = 4; /* DESIGNATOR LENGTH */
+		SET_VPD_DATA(buf, buf_len, off, 0x6);
+		off ++; /* Skip over Reserved */
+		SET_VPD_DATA(buf, buf_len, off, 4); /* DESIGNATOR LENGTH */
 		off += 2; /* Skip over Reserved Field */
-		buf[off++] = ((lu_gp_id >> 8) & 0xff);
-		buf[off++] = (lu_gp_id & 0xff);
-		len += 8; /* Header size + Designation descriptor */
+		SET_VPD_DATA(buf, buf_len, off,(lu_gp_id >> 8) & 0xff);
+		SET_VPD_DATA(buf, buf_len, off, lu_gp_id & 0xff);
 		/*
 		 * SCSI name string designator, see spc4r17
 		 * section 7.7.3.11
@@ -365,14 +405,15 @@ check_lu_gp:
 		 * section 7.5.1 Table 362
 		 */
 check_scsi_name:
-		buf[off] =
-			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
-		buf[off++] |= 0x3; /* CODE SET == UTF-8 */
-		buf[off] = 0x80; /* Set PIV=1 */
+		d = (tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
+		d |= 0x3; /* CODE SET == UTF-8 */
+		SET_VPD_DATA(buf, buf_len, off, d);
+		d = 0x80; /* Set PIV=1 */
 		/* Set ASSOCIATION == target port: 01b */
-		buf[off] |= 0x10;
+		d |= 0x10;
 		/* DESIGNATOR TYPE == SCSI name string */
-		buf[off++] |= 0x8;
+		d |= 0x8;
+		SET_VPD_DATA(buf, buf_len, off, d);
 		off += 2; /* Skip over Reserved and length */
 		/*
 		 * SCSI name string identifer containing, $FABRIC_MOD
@@ -381,8 +422,10 @@ check_scsi_name:
 		 * UTF-8 encoding.
 		 */
 		tpgt = tpg->se_tpg_tfo->tpg_get_tag(tpg);
-		scsi_name_len = sprintf(&buf[off], "%s,t,0x%04x",
-					tpg->se_tpg_tfo->tpg_get_wwn(tpg), tpgt);
+		scsi_name_len = snprintf(&buf[off], buf_len - off,
+					 "%s,t,0x%04x",
+					 tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+					 tpgt);
 		scsi_name_len += 1 /* Include  NULL terminator */;
 		/*
 		 * The null-terminated, null-padded (see 4.4.2) SCSI
@@ -397,23 +440,22 @@ check_scsi_name:
 			scsi_name_len += padding;
 		if (scsi_name_len > 256)
 			scsi_name_len = 256;
-
-		buf[off-1] = scsi_name_len;
+		if (buf_len > off -1 )
+			buf[off-1] = scsi_name_len;
 		off += scsi_name_len;
-		/* Header size + Designation descriptor */
-		len += (scsi_name_len + 4);
 
 		/*
 		 * Target device designator
 		 */
-		buf[off] =
-			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
-		buf[off++] |= 0x3; /* CODE SET == UTF-8 */
-		buf[off] = 0x80; /* Set PIV=1 */
+		d = (tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
+		d |= 0x3; /* CODE SET == UTF-8 */
+		SET_VPD_DATA(buf, buf_len, off, d);
+		d = 0x80; /* Set PIV=1 */
 		/* Set ASSOCIATION == target device: 10b */
-		buf[off] |= 0x20;
+		d |= 0x20;
 		/* DESIGNATOR TYPE == SCSI name string */
-		buf[off++] |= 0x8;
+		d |= 0x8;
+		SET_VPD_DATA(buf, buf_len, off, d);
 		off += 2; /* Skip over Reserved and length */
 		/*
 		 * SCSI name string identifer containing, $FABRIC_MOD
@@ -421,7 +463,7 @@ check_scsi_name:
 		 * Target Port, this means "<iSCSI name>" in
 		 * UTF-8 encoding.
 		 */
-		scsi_target_len = sprintf(&buf[off], "%s",
+		scsi_target_len = snprintf(&buf[off], buf_len - off, "%s",
 					  tpg->se_tpg_tfo->tpg_get_wwn(tpg));
 		scsi_target_len += 1 /* Include  NULL terminator */;
 		/*
@@ -438,14 +480,13 @@ check_scsi_name:
 		if (scsi_name_len > 256)
 			scsi_name_len = 256;
 
-		buf[off-1] = scsi_target_len;
+		if (buf_len > off -1 )
+			buf[off-1] = scsi_target_len;
 		off += scsi_target_len;
-
-		/* Header size + Designation descriptor */
-		len += (scsi_target_len + 4);
 	}
-	buf[2] = ((len >> 8) & 0xff);
-	buf[3] = (len & 0xff); /* Page Length for VPD 0x83 */
+	off -= 4;
+	buf[2] = ((off >> 8) & 0xff);
+	buf[3] = (off & 0xff); /* Page Length for VPD 0x83 */
 	return 0;
 }
 EXPORT_SYMBOL(spc_emulate_evpd_83);
@@ -465,34 +506,43 @@ spc_check_dev_wce(struct se_device *dev)
 
 /* Extended INQUIRY Data VPD Page */
 static sense_reason_t
-spc_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
+spc_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf, int buf_len)
 {
 	struct se_device *dev = cmd->se_dev;
 
+	if (buf_len < 4)
+		return TCM_INVALID_CDB_FIELD;
+
 	buf[3] = 0x3c;
 	/* Set HEADSUP, ORDSUP, SIMPSUP */
-	buf[5] = 0x07;
+	if (buf_len > 5)
+		buf[5] = 0x07;
 
 	/* If WriteCache emulation is enabled, set V_SUP */
-	if (spc_check_dev_wce(dev))
+	if (buf_len > 6 && spc_check_dev_wce(dev))
 		buf[6] = 0x01;
 	/* If an LBA map is present set R_SUP */
-	spin_lock(&cmd->se_dev->t10_alua.lba_map_lock);
-	if (!list_empty(&dev->t10_alua.lba_map_list))
-		buf[8] = 0x10;
-	spin_unlock(&cmd->se_dev->t10_alua.lba_map_lock);
+	if (buf_len > 8) {
+		spin_lock(&cmd->se_dev->t10_alua.lba_map_lock);
+		if (!list_empty(&dev->t10_alua.lba_map_list))
+			buf[8] = 0x10;
+		spin_unlock(&cmd->se_dev->t10_alua.lba_map_lock);
+	}
 	return 0;
 }
 
 /* Block Limits VPD page */
 static sense_reason_t
-spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
+spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf, int buf_len)
 {
 	struct se_device *dev = cmd->se_dev;
 	u32 max_sectors;
 	int have_tp = 0;
 	int opt, min;
 
+	if (buf_len < 4)
+		return TCM_INVALID_CDB_FIELD;
+
 	/*
 	 * Following spc3r22 section 6.5.3 Block Limits VPD page, when
 	 * emulate_tpu=1 or emulate_tpws=1 we will be expect a
@@ -505,35 +555,45 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	buf[3] = have_tp ? 0x3c : 0x10;
 
 	/* Set WSNZ to 1 */
-	buf[4] = 0x01;
+	if (buf_len > 4)
+		buf[4] = 0x01;
 	/*
 	 * Set MAXIMUM COMPARE AND WRITE LENGTH
 	 */
-	if (dev->dev_attrib.emulate_caw)
+	if (buf_len > 5 && dev->dev_attrib.emulate_caw)
 		buf[5] = 0x01;
 
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH GRANULARITY
 	 */
-	if (dev->transport->get_io_min && (min = dev->transport->get_io_min(dev)))
-		put_unaligned_be16(min / dev->dev_attrib.block_size, &buf[6]);
-	else
-		put_unaligned_be16(1, &buf[6]);
+	if (buf_len > 7) {
+		if (dev->transport->get_io_min &&
+		    (min = dev->transport->get_io_min(dev)))
+			min /= dev->dev_attrib.block_size;
+		else
+			min = 1;
+		put_unaligned_be16(min, &buf[6]);
+	}
 
 	/*
 	 * Set MAXIMUM TRANSFER LENGTH
 	 */
 	max_sectors = min(dev->dev_attrib.fabric_max_sectors,
 			  dev->dev_attrib.hw_max_sectors);
-	put_unaligned_be32(max_sectors, &buf[8]);
+	if (buf_len > 11)
+		put_unaligned_be32(max_sectors, &buf[8]);
 
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH
 	 */
-	if (dev->transport->get_io_opt && (opt = dev->transport->get_io_opt(dev)))
-		put_unaligned_be32(opt / dev->dev_attrib.block_size, &buf[12]);
-	else
-		put_unaligned_be32(dev->dev_attrib.optimal_sectors, &buf[12]);
+	if (buf_len > 15) {
+		if (dev->transport->get_io_opt &&
+		    (opt = dev->transport->get_io_opt(dev)))
+			opt /= dev->dev_attrib.block_size;
+		else
+			opt = dev->dev_attrib.optimal_sectors;
+		put_unaligned_be32(opt, &buf[12]);
+	}
 
 	/*
 	 * Exit now if we don't support TP.
@@ -544,55 +604,69 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	/*
 	 * Set MAXIMUM UNMAP LBA COUNT
 	 */
-	put_unaligned_be32(dev->dev_attrib.max_unmap_lba_count, &buf[20]);
+	if (buf_len > 23)
+		put_unaligned_be32(dev->dev_attrib.max_unmap_lba_count,
+				   &buf[20]);
 
 	/*
 	 * Set MAXIMUM UNMAP BLOCK DESCRIPTOR COUNT
 	 */
-	put_unaligned_be32(dev->dev_attrib.max_unmap_block_desc_count,
-			   &buf[24]);
+	if (buf_len > 27)
+		put_unaligned_be32(dev->dev_attrib.max_unmap_block_desc_count,
+				   &buf[24]);
 
 	/*
 	 * Set OPTIMAL UNMAP GRANULARITY
 	 */
-	put_unaligned_be32(dev->dev_attrib.unmap_granularity, &buf[28]);
+	if (buf_len > 31)
+		put_unaligned_be32(dev->dev_attrib.unmap_granularity, &buf[28]);
 
 	/*
 	 * UNMAP GRANULARITY ALIGNMENT
 	 */
-	put_unaligned_be32(dev->dev_attrib.unmap_granularity_alignment,
-			   &buf[32]);
-	if (dev->dev_attrib.unmap_granularity_alignment != 0)
+	if (buf_len > 35)
+		put_unaligned_be32(dev->dev_attrib.unmap_granularity_alignment,
+				   &buf[32]);
+	if (buf_len > 32 && dev->dev_attrib.unmap_granularity_alignment != 0)
 		buf[32] |= 0x80; /* Set the UGAVALID bit */
 
 	/*
 	 * MAXIMUM WRITE SAME LENGTH
 	 */
 max_write_same:
-	put_unaligned_be64(dev->dev_attrib.max_write_same_len, &buf[36]);
+	if (buf_len > 43)
+		put_unaligned_be64(dev->dev_attrib.max_write_same_len,
+				   &buf[36]);
 
 	return 0;
 }
 
 /* Block Device Characteristics VPD page */
 static sense_reason_t
-spc_emulate_evpd_b1(struct se_cmd *cmd, unsigned char *buf)
+spc_emulate_evpd_b1(struct se_cmd *cmd, unsigned char *buf, int buf_len)
 {
 	struct se_device *dev = cmd->se_dev;
 
+	if (buf_len < 4)
+		return TCM_INVALID_CDB_FIELD;
+
 	buf[0] = dev->transport->get_device_type(dev);
 	buf[3] = 0x3c;
-	buf[5] = dev->dev_attrib.is_nonrot ? 1 : 0;
+	if (buf_len > 5)
+		buf[5] = dev->dev_attrib.is_nonrot ? 1 : 0;
 
 	return 0;
 }
 
 /* Thin Provisioning VPD */
 static sense_reason_t
-spc_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
+spc_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf, int buf_len)
 {
 	struct se_device *dev = cmd->se_dev;
 
+	if (buf_len < 8)
+		return TCM_INVALID_CDB_FIELD;
+
 	/*
 	 * From spc3r22 section 6.5.4 Thin Provisioning VPD page:
 	 *
@@ -641,10 +715,13 @@ spc_emulate_evpd_b2(struct se_cmd *cmd, unsigned char *buf)
 
 /* Referrals VPD page */
 static sense_reason_t
-spc_emulate_evpd_b3(struct se_cmd *cmd, unsigned char *buf)
+spc_emulate_evpd_b3(struct se_cmd *cmd, unsigned char *buf, int buf_len)
 {
 	struct se_device *dev = cmd->se_dev;
 
+	if (buf_len < 16)
+		return TCM_INVALID_CDB_FIELD;
+
 	buf[0] = dev->transport->get_device_type(dev);
 	buf[3] = 0x0c;
 	put_unaligned_be32(dev->t10_alua.lba_map_segment_size, &buf[8]);
@@ -654,11 +731,11 @@ spc_emulate_evpd_b3(struct se_cmd *cmd, unsigned char *buf)
 }
 
 static sense_reason_t
-spc_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf);
+spc_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf, int buf_len);
 
 static struct {
 	uint8_t		page;
-	sense_reason_t	(*emulate)(struct se_cmd *, unsigned char *);
+	sense_reason_t	(*emulate)(struct se_cmd *, unsigned char *, int);
 } evpd_handlers[] = {
 	{ .page = 0x00, .emulate = spc_emulate_evpd_00 },
 	{ .page = 0x80, .emulate = spc_emulate_evpd_80 },
@@ -672,10 +749,13 @@ static struct {
 
 /* supported vital product data pages */
 static sense_reason_t
-spc_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf)
+spc_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf, int buf_len)
 {
 	int p;
 
+	if (buf_len < 4)
+		return TCM_INVALID_CDB_FIELD;
+
 	/*
 	 * Only report the INQUIRY EVPD=1 pages after a valid NAA
 	 * Registered Extended LUN WWN has been set via ConfigFS
@@ -684,7 +764,8 @@ spc_emulate_evpd_00(struct se_cmd *cmd, unsigned char *buf)
 	if (cmd->se_dev->dev_flags & DF_EMULATED_VPD_UNIT_SERIAL) {
 		buf[3] = ARRAY_SIZE(evpd_handlers);
 		for (p = 0; p < ARRAY_SIZE(evpd_handlers); ++p)
-			buf[p + 4] = evpd_handlers[p].page;
+			if (buf_len > p + 4)
+				buf[p + 4] = evpd_handlers[p].page;
 	}
 
 	return 0;
@@ -695,13 +776,12 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_portal_group *tpg = cmd->se_lun->lun_sep->sep_tpg;
-	unsigned char *rbuf;
 	unsigned char *cdb = cmd->t_task_cdb;
-	unsigned char buf[SE_INQUIRY_BUF];
+	unsigned char *buf;
 	sense_reason_t ret;
 	int p;
 
-	memset(buf, 0, SE_INQUIRY_BUF);
+	buf = transport_kmap_data_sg(cmd);
 
 	if (dev == tpg->tpg_virt_lun0.lun_se_dev)
 		buf[0] = 0x3f; /* Not connected */
@@ -723,7 +803,8 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 	for (p = 0; p < ARRAY_SIZE(evpd_handlers); ++p) {
 		if (cdb[2] == evpd_handlers[p].page) {
 			buf[1] = cdb[2];
-			ret = evpd_handlers[p].emulate(cmd, buf);
+			ret = evpd_handlers[p].emulate(cmd, buf,
+						       cmd->data_length);
 			goto out;
 		}
 	}
@@ -732,11 +813,7 @@ spc_emulate_inquiry(struct se_cmd *cmd)
 	ret = TCM_INVALID_CDB_FIELD;
 
 out:
-	rbuf = transport_kmap_data_sg(cmd);
-	if (rbuf) {
-		memcpy(rbuf, buf, min_t(u32, sizeof(buf), cmd->data_length));
-		transport_kunmap_data_sg(cmd);
-	}
+	transport_kunmap_data_sg(cmd);
 
 	if (!ret)
 		target_complete_cmd(cmd, GOOD);
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 39e0114..98d5a0d 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -60,7 +60,7 @@ void	target_complete_cmd(struct se_cmd *, u8);
 sense_reason_t	spc_parse_cdb(struct se_cmd *cmd, unsigned int *size);
 sense_reason_t	spc_emulate_report_luns(struct se_cmd *cmd);
 sense_reason_t	spc_emulate_inquiry_std(struct se_cmd *, unsigned char *);
-sense_reason_t	spc_emulate_evpd_83(struct se_cmd *, unsigned char *);
+sense_reason_t	spc_emulate_evpd_83(struct se_cmd *, unsigned char *, int);
 
 sense_reason_t	sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops);
 u32	sbc_get_device_rev(struct se_device *dev);
-- 
1.7.12.4

