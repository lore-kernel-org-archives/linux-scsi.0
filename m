From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] libata: implement SECURITY PROTOCOL IN/OUT
Date: Sun,  4 Jun 2017 14:42:24 +0200
Message-ID: <20170604124225.27032-6-hch@lst.de>
References: <20170604124225.27032-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170604124225.27032-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Scott Bauer <scott.bauer@intel.com>, Jonathan Derrick <jonathan.derrick@intel.com>, Rafael Antognolli <rafael.antognolli@intel.com>, Robert Elliott <elliott@hpe.com>, linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This allows us to use the generic OPAL code with ATA devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/libata-core.c | 32 ++++++++++++++++++++
 drivers/ata/libata-scsi.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/ata.h       |  1 +
 include/linux/libata.h    |  1 +
 4 files changed, 110 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f57131115594..6eb08595a1b5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2405,6 +2405,37 @@ static void ata_dev_config_zac(struct ata_device *dev)
 	}
 }
 
+static void ata_dev_config_trusted(struct ata_device *dev)
+{
+	struct ata_port *ap = dev->link->ap;
+	u64 trusted_cap;
+	unsigned int err;
+
+	if (!ata_identify_page_supported(dev, ATA_LOG_SECURITY)) {
+		ata_dev_warn(dev,
+			     "Security Log not supported\n");
+		return;
+	}
+
+	err = ata_read_log_page(dev, ATA_LOG_IDENTIFY_DEVICE, ATA_LOG_SECURITY,
+			ap->sector_buf, 1);
+	if (err) {
+		ata_dev_dbg(dev,
+			    "failed to read Security Log, Emask 0x%x\n", err);
+		return;
+	}
+
+	trusted_cap = get_unaligned_le64(&ap->sector_buf[40]);
+	if (!(trusted_cap & (1ULL << 63))) {
+		ata_dev_dbg(dev,
+			    "Trusted Computing capability qword not valid!\n");
+		return;
+	}
+
+	if (trusted_cap & (1 << 0))
+		dev->flags |= ATA_DFLAG_TRUSTED;
+}
+
 /**
  *	ata_dev_configure - Configure the specified ATA/ATAPI device
  *	@dev: Target device to configure
@@ -2629,6 +2660,7 @@ int ata_dev_configure(struct ata_device *dev)
 		}
 		ata_dev_config_sense_reporting(dev);
 		ata_dev_config_zac(dev);
+		ata_dev_config_trusted(dev);
 		dev->cdb_len = 16;
 	}
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 49ba9834c715..3d28f2bd79af 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3563,6 +3563,11 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 		    dev->class == ATA_DEV_ZAC)
 			supported = 3;
 		break;
+	case SECURITY_PROTOCOL_IN:
+	case SECURITY_PROTOCOL_OUT:
+		if (dev->flags & ATA_DFLAG_TRUSTED)
+			supported = 3;
+		break;
 	default:
 		break;
 	}
@@ -4067,6 +4072,71 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
 	return 1;
 }
 
+static u8 ata_scsi_trusted_op(u32 len, bool send, bool dma)
+{
+	if (len == 0)
+		return ATA_CMD_TRUSTED_NONDATA;
+	else if (send)
+		return dma ? ATA_CMD_TRUSTED_SND_DMA : ATA_CMD_TRUSTED_SND;
+	else
+		return dma ? ATA_CMD_TRUSTED_RCV_DMA : ATA_CMD_TRUSTED_RCV;
+}
+
+static unsigned int ata_scsi_security_inout_xlat(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	const u8 *cdb = scmd->cmnd;
+	struct ata_taskfile *tf = &qc->tf;
+	u8 secp = cdb[1];
+	bool send = (cdb[0] == SECURITY_PROTOCOL_OUT);
+	u16 spsp = get_unaligned_be16(&cdb[2]);
+	u32 len = get_unaligned_be32(&cdb[6]);
+	bool dma = !(qc->dev->flags & ATA_DFLAG_PIO);
+
+	/*
+	 * We don't support the ATA "security" protocol.
+	 */
+	if (secp == 0xef) {
+		ata_scsi_set_invalid_field(qc->dev, scmd, 1, 0);
+		return 1;
+	}
+
+	if (cdb[4] & 7) { /* INC_512 */
+		if (len > 0xffff) {
+			ata_scsi_set_invalid_field(qc->dev, scmd, 6, 0);
+			return 1;
+		}
+	} else {
+		if (len > 0x01fffe00) {
+			ata_scsi_set_invalid_field(qc->dev, scmd, 6, 0);
+			return 1;
+		}
+
+		/* convert to the sector-based ATA addressing */
+		len = (len + 511) / 512;
+	}
+
+	tf->protocol = dma ? ATA_PROT_DMA : ATA_PROT_PIO;
+	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR | ATA_TFLAG_LBA;
+	if (send)
+		tf->flags |= ATA_TFLAG_WRITE;
+	tf->command = ata_scsi_trusted_op(len, send, dma);
+	tf->feature = secp;
+	tf->lbam = spsp & 0xff;
+	tf->lbah = spsp >> 8;
+
+	if (len) {
+		tf->nsect = len & 0xff;
+		tf->lbal = len >> 8;
+	} else {
+		if (!send)
+			tf->lbah = (1 << 7);
+	}
+
+	ata_qc_set_pc_nbytes(qc);
+	return 0;
+}
+
 /**
  *	ata_get_xlat_func - check if SCSI to ATA translation is possible
  *	@dev: ATA device
@@ -4118,6 +4188,12 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 	case ZBC_OUT:
 		return ata_scsi_zbc_out_xlat;
 
+	case SECURITY_PROTOCOL_IN:
+	case SECURITY_PROTOCOL_OUT:
+		if (!(dev->flags & ATA_DFLAG_TRUSTED))
+			break;
+		return ata_scsi_security_inout_xlat;
+
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
 	}
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 44de34c954d8..5781bf310560 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -341,6 +341,7 @@ enum {
 	ATA_LOG_IDENTIFY_DEVICE	= 0x30,
 
 	/* Identify device log pages: */
+	ATA_LOG_SECURITY	  = 0x06,
 	ATA_LOG_SATA_SETTINGS	  = 0x08,
 	ATA_LOG_ZONED_INFORMATION = 0x09,
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c9a69fc8821e..65711cb3a740 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -156,6 +156,7 @@ enum {
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_AN		= (1 << 7), /* AN configured */
+	ATA_DFLAG_TRUSTED	= (1 << 8), /* device supports trusted send/recv */
 	ATA_DFLAG_DMADIR	= (1 << 10), /* device requires DMADIR */
 	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
-- 
2.11.0
