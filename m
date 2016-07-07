From: tom.ty89@gmail.com
Subject: [RFC] libata-scsi: introducing SANITIZE translation
Date: Fri,  8 Jul 2016 00:32:54 +0800
Message-ID: <577e843e.0a86620a.59167.ffffb899@mx.google.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36657 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbcGGQdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2016 12:33:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, dgilbert@interlog.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

With this patch, users can make use of the SANITIZE DEVICE feature
set through utility like sg_sanitize.

Support for BLOCK ERASE, CRYPTOGRAPHIC ERASE and EXIT FAILURE MODE
has been implemented. Support for OVERWRITE that involves a
parameter list has been left out for now.

Further support for command with IMMED bit set to zero, REQUEST
SENSE translation for user-space status polling, and support
checking in IDENTIFY DEVICE data log (return proper sense data
when designated method is not supported) should be implemented
in the future as well.

`sg_sanitize -e -B|-C|-F /dev/sdX` should work fine with this.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index bfec66f..a64991b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3346,6 +3346,63 @@ invalid_opcode:
 	return 1;
 }
 
+static unsigned int ata_scsi_sanitize_xlat(struct ata_queued_cmd *qc) {
+	struct ata_taskfile *tf = &qc->tf;
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	struct ata_device *dev = qc->dev;
+	const u8 *cdb = scmd->cmnd;
+	u16 fp;
+	u8 bp = 0xff;
+
+	/* for now we only support SANITIZE with IMMED bit set */
+	if (unlikely(!(cdb[1] & 0x80))) {
+		fp = 1;
+		bp = 7;
+		goto invalid_fld;
+	}
+
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_SANITIZE_DEVICE;
+	tf->hob_nsect |= (cdb[1] & 0x40) << 1;
+	tf->nsect |= (cdb[1] & 0x20) >> 1;
+	tf->flags |= ATA_TFLAG_LBA48 | ATA_TFLAG_ISADDR;
+
+	switch (cdb[1] & 0x1f) {
+	/* TODO: add support for OVERWRITE */
+	case 0x2: /* BLOCK ERASE */
+		tf->hob_feature = 0x0;
+		tf->feature = 0x12;
+		tf->hob_lbal = 0x42;
+		tf->lbah = 0x6b;
+		tf->lbam = 0x45;
+		tf->lbal = 0x72;
+		break;
+	case 0x3: /* CRYPTOGRAPHIC ERASE */
+		tf->hob_feature = 0x0;
+		tf->feature = 0x11;
+		tf->hob_lbal = 0x43;
+		tf->lbah = 0x72;
+		tf->lbam = 0x79;
+		tf->lbal = 0x70;
+		break;
+	case 0x1f: /* EXIT FAILURE MODE */
+		tf->hob_feature = 0x0;
+		tf->feature = 0x0;
+		tf->nsect |= 0x1;
+		break;
+	default:
+		fp = 1;
+		bp = 4;
+		goto invalid_fld;
+	}
+
+	return 0;
+
+invalid_fld:
+	ata_scsi_set_invalid_field(dev, scmd, fp, bp);
+	return 1;
+}
+
 /**
  *	ata_scsi_report_zones_complete - convert ATA output
  *	@qc: command structure returning the data
@@ -3869,6 +3926,9 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 	case WRITE_SAME_16:
 		return ata_scsi_write_same_xlat;
 
+	case SANITIZE:
+		return ata_scsi_sanitize_xlat;
+
 	case SYNCHRONIZE_CACHE:
 		if (ata_try_flush_cache(dev))
 			return ata_scsi_flush_xlat;
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index d1defd1..20d6085 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -72,6 +72,7 @@
 #define UNMAP		      0x42
 #define READ_TOC              0x43
 #define READ_HEADER           0x44
+#define SANITIZE              0x48
 #define GET_EVENT_STATUS_NOTIFICATION 0x4a
 #define LOG_SELECT            0x4c
 #define LOG_SENSE             0x4d
-- 
2.9.0

