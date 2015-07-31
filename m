From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/6] libata: Implement ZBC OUT translation
Date: Fri, 31 Jul 2015 15:02:06 +0200
Message-ID: <1438347728-106434-5-git-send-email-hare@suse.de>
References: <1438347728-106434-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbbGaNCV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 09:02:21 -0400
In-Reply-To: <1438347728-106434-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>

ZAC drives implement a 'zac management out' command template,
which maps onto the ZBC OUT command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-eh.c       |  1 +
 drivers/ata/libata-scsi.c     | 65 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/ata.h           |  7 +++++
 include/scsi/scsi_proto.h     |  6 ++++
 include/trace/events/libata.h |  1 +
 5 files changed, 80 insertions(+)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 55a0abf..e596436 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2493,6 +2493,7 @@ const char *ata_get_cmd_descript(u8 command)
 		{ ATA_CMD_REQ_SENSE_DATA,	"REQUEST SENSE DATA EXT" },
 		{ ATA_CMD_SANITIZE_DEVICE,	"SANITIZE DEVICE" },
 		{ ATA_CMD_ZAC_MGMT_IN,		"ZAC MANAGEMENT IN" },
+		{ ATA_CMD_ZAC_MGMT_OUT,		"ZAC MANAGEMENT OUT" },
 		{ ATA_CMD_READ_LONG,		"READ LONG (with retries)" },
 		{ ATA_CMD_READ_LONG_ONCE,	"READ LONG (without retries)" },
 		{ ATA_CMD_WRITE_LONG,		"WRITE LONG (with retries)" },
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 90f8d9e..e0dede3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3316,6 +3316,68 @@ static unsigned int ata_scsi_zbc_in_xlat(struct ata_queued_cmd *qc)
 	return 1;
 }
 
+static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	struct ata_device *dev = qc->dev;
+	const u8 *cdb = scmd->cmnd;
+	u8 reset_all, sa;
+	u64 block;
+	u32 n_block;
+
+	if (unlikely(scmd->cmd_len < 16))
+		goto invalid_fld;
+
+	/*
+	 * The service action definition got moved from
+	 * 0x00 to 0x04 with zbc-r02, so accept both.
+	 */
+	sa = cdb[1] & 0x1f;
+	/* Compatibility with ZBC r01 */
+	if (!sa)
+		sa = ZO_RESET_WRITE_POINTER;
+	if (sa != ZO_RESET_WRITE_POINTER)
+		goto invalid_fld;
+
+	scsi_16_lba_len(cdb, &block, &n_block);
+	if (n_block) {
+		/*
+		 * ZAC MANAGEMENT OUT doesn't define any length
+		 */
+		goto invalid_fld;
+	}
+	if (block > dev->n_sectors)
+		goto out_of_range;
+
+	reset_all = cdb[14] & 0x1;
+
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_ZAC_MGMT_OUT;
+	tf->feature = sa;
+	tf->hob_feature = reset_all & 0x1;
+
+	tf->lbah = (block >> 16) & 0xff;
+	tf->lbam = (block >> 8) & 0xff;
+	tf->lbal = block & 0xff;
+	tf->hob_lbah = (block >> 40) & 0xff;
+	tf->hob_lbam = (block >> 32) & 0xff;
+	tf->hob_lbal = (block >> 24) & 0xff;
+	tf->device |= ATA_LBA;
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48;
+
+	return 0;
+
+ invalid_fld:
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x00);
+	/* "Invalid field in cdb" */
+	return 1;
+ out_of_range:
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x21, 0x00);
+	/* "Logical Block Address out of range" */
+	return 1;
+}
+
 /**
  *	ata_mselect_caching - Simulate MODE SELECT for caching info page
  *	@qc: Storage for translated ATA taskfile
@@ -3546,6 +3608,9 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 	case ZBC_IN:
 		return ata_scsi_zbc_in_xlat;
 
+	case ZBC_OUT:
+		return ata_scsi_zbc_out_xlat;
+
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
 	}
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 3521afc..ef7b14a 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -302,6 +302,7 @@ enum {
 	ATA_CMD_REQ_SENSE_DATA  = 0x0B,
 	ATA_CMD_SANITIZE_DEVICE = 0xB4,
 	ATA_CMD_ZAC_MGMT_IN	= 0x4A,
+	ATA_CMD_ZAC_MGMT_OUT	= 0x9F,
 
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
@@ -313,6 +314,12 @@ enum {
 	/* Subcmds for ATA_CMD_ZAC_MGMT_IN */
 	ATA_SUBCMD_ZAC_MGMT_IN_REPORT_ZONES = 0x00,
 
+	/* Subcmds for ATA_CMD_ZAC_MGMT_OUT */
+	ATA_SUBCMD_ZAC_MGMT_OUT_CLOSE_ZONE = 0x01,
+	ATA_SUBCMD_ZAC_MGMT_OUT_FINISH_ZONE = 0x02,
+	ATA_SUBCMD_ZAC_MGMT_OUT_OPEN_ZONE = 0x03,
+	ATA_SUBCMD_ZAC_MGMT_OUT_RESET_WRITE_POINTER = 0x04,
+
 	/* READ_LOG_EXT pages */
 	ATA_LOG_SATA_NCQ	= 0x10,
 	ATA_LOG_NCQ_SEND_RECV	  = 0x13,
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index de14d19..dd9d973 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -115,6 +115,7 @@
 #define VERIFY_16	      0x8f
 #define SYNCHRONIZE_CACHE_16  0x91
 #define WRITE_SAME_16	      0x93
+#define ZBC_OUT		      0x94
 #define ZBC_IN		      0x95
 #define SERVICE_ACTION_BIDIRECTIONAL 0x9d
 #define SERVICE_ACTION_IN_16  0x9e
@@ -146,6 +147,11 @@
 #define MO_MANAGEMENT_PROTOCOL_OUT 0x10
 /* values for ZBC_IN */
 #define ZI_REPORT_ZONES	      0x00
+/* values for ZBC_OUT */
+#define ZO_CLOSE_ZONE	      0x01
+#define ZO_OPEN_ZONE	      0x02
+#define ZO_FINISH_ZONE	      0x03
+#define ZO_RESET_WRITE_POINTER 0x04
 /* values for variable length command */
 #define XDREAD_32	      0x03
 #define XDWRITE_32	      0x04
diff --git a/include/trace/events/libata.h b/include/trace/events/libata.h
index 02ec4e5..24dcd43 100644
--- a/include/trace/events/libata.h
+++ b/include/trace/events/libata.h
@@ -98,6 +98,7 @@
 		 ata_opcode_name(ATA_CMD_REQ_SENSE_DATA),	\
 		 ata_opcode_name(ATA_CMD_SANITIZE_DEVICE),	\
 		 ata_opcode_name(ATA_CMD_ZAC_MGMT_IN),		\
+		 ata_opcode_name(ATA_CMD_ZAC_MGMT_OUT),		\
 		 ata_opcode_name(ATA_CMD_RESTORE),		\
 		 ata_opcode_name(ATA_CMD_READ_LONG),		\
 		 ata_opcode_name(ATA_CMD_READ_LONG_ONCE),	\
-- 
1.8.5.2

