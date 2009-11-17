From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH V2] libata: add TRIM support
Date: Tue, 17 Nov 2009 10:00:47 -0500
Message-ID: <20091117150047.GB10748@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbZKQPAm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 10:00:42 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Mark Lord <liml@rtr.ca>

Add support for the ATA TRIM command in libata.  We translate a WRITE SAME 16
command with the unmap bit set into an ATA TRIM command and export enough
information in READ CAPACITY 16 and the block limits EVPD page so that the new
SCSI layer discard support will driver this for us.

Note that I hardcode the WRITE_SAME_16 opcode for now as the patch to introduce
the symbolic is not in 2.6.32 yet but only in the SCSI tree - as soon as it is
merged we can fix it up to properly use the symbolic name.

Signed-off-by: Christoph Hellwig <hch@lst.de>

-- 

Changelog since V1:

 - add ata_id_has_large_logical_sectors and ata_id_logical_per_physical_sectors
   helpers in ata.h
 - remove field initialization in ata_scsi_write_same_xlat that were already
   done for us in common code
 - remove the ATA_QCFLAG_RESULT_TF flags - we don't need the result TF and
   this actually speeds up the command dramatically
 - remove the ATA_QCFLAG_QUIET - we do not want failures of the TRIM command
   to be silent

Index: linux-2.6/drivers/ata/libata-scsi.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-scsi.c	2009-11-17 15:25:36.199003969 +0100
+++ linux-2.6/drivers/ata/libata-scsi.c	2009-11-17 15:40:19.901256012 +0100
@@ -47,6 +47,7 @@
 #include <linux/hdreg.h>
 #include <linux/uaccess.h>
 #include <linux/suspend.h>
+#include <asm/unaligned.h>
 
 #include "libata.h"
 
@@ -1964,6 +1965,7 @@ static unsigned int ata_scsiop_inq_00(st
 		0x80,	/* page 0x80, unit serial no page */
 		0x83,	/* page 0x83, device ident page */
 		0x89,	/* page 0x89, ata info page */
+		0xb0,	/* page 0xb0, block limits page */
 		0xb1,	/* page 0xb1, block device characteristics page */
 	};
 
@@ -2085,6 +2087,41 @@ static unsigned int ata_scsiop_inq_89(st
 	return 0;
 }
 
+static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
+{
+	u32 min_io_sectors;
+
+	rbuf[1] = 0xb0;
+	rbuf[3] = 0x3c;		/* required VPD size with unmap support */
+
+	/*
+	 * Optimal transfer length granularity.
+	 *
+	 * This is always one physical block, but for disks with a smaller
+	 * logical than physical sector size we need to figure out what the
+	 * latter is.
+	 */
+	if (ata_id_has_large_logical_sectors(args->id))
+		min_io_sectors = ata_id_logical_per_physical_sectors(args->id);
+	else
+		min_io_sectors = 1;
+	put_unaligned_be16(min_io_sectors, &rbuf[6]);
+
+	/*
+	 * Optimal unmap granularity.
+	 *
+	 * The ATA spec doesn't even know about a granularity or alignment
+	 * for the TRIM command.  We can leave away most of the unmap related
+	 * VPD page entries, but we have specifify a granularity to signal
+	 * that we support some form of unmap - in thise case via WRITE SAME
+	 * with the unmap bit set.
+	 */
+	if (ata_id_has_trim(args->id))
+		put_unaligned_be32(1, &rbuf[28]);
+
+	return 0;
+}
+
 static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
 {
 	int form_factor = ata_id_form_factor(args->id);
@@ -2374,6 +2411,9 @@ static unsigned int ata_scsiop_read_cap(
 		rbuf[13] = log_per_phys;
 		rbuf[14] = (lowest_aligned >> 8) & 0x3f;
 		rbuf[15] = lowest_aligned;
+
+		if (ata_id_has_trim(args->id))
+			rbuf[14] |= 0x80;
 	}
 
 	return 0;
@@ -2896,6 +2936,58 @@ static unsigned int ata_scsi_pass_thru(s
 	return 1;
 }
 
+static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	struct ata_device *dev = qc->dev;
+	const u8 *cdb = scmd->cmnd;
+	u64 block;
+	u32 n_block;
+	u32 size;
+	void *buf;
+
+	/* we may not issue DMA commands if no DMA mode is set */
+	if (unlikely(!dev->dma_mode))
+		goto invalid_fld;
+
+	if (unlikely(scmd->cmd_len < 16))
+		goto invalid_fld;
+	scsi_16_lba_len(cdb, &block, &n_block);
+
+	/* for now we only support WRITE SAME with the unmap bit set */
+	if (unlikely(!(cdb[1] & 0x8)))
+		goto invalid_fld;
+
+	/*
+	 * WRITE SAME always has a sector sized buffer as payload, this
+	 * should never be a multiple entry S/G list.
+	 */
+	if (!scsi_sg_count(scmd))
+		goto invalid_fld;
+
+	buf = page_address(sg_page(scsi_sglist(scmd)));
+	size = ata_set_lba_range_entries(buf, 512 / 8, block, n_block);
+
+	tf->protocol = ATA_PROT_DMA;
+	tf->hob_feature = 0;
+	tf->feature = ATA_DSM_TRIM;
+	tf->hob_nsect = (size / 512) >> 8;
+	tf->nsect = size / 512;
+	tf->command = ATA_CMD_DSM;
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48 |
+		     ATA_TFLAG_WRITE;
+
+	ata_qc_set_pc_nbytes(qc);
+
+	return 0;
+
+ invalid_fld:
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x00);
+	/* "Invalid field in cdb" */
+	return 1;
+}
+
 /**
  *	ata_get_xlat_func - check if SCSI to ATA translation is possible
  *	@dev: ATA device
@@ -2920,6 +3012,9 @@ static inline ata_xlat_func_t ata_get_xl
 	case WRITE_16:
 		return ata_scsi_rw_xlat;
 
+	case 0x93 /*WRITE_SAME_16*/:
+		return ata_scsi_write_same_xlat;
+
 	case SYNCHRONIZE_CACHE:
 		if (ata_try_flush_cache(dev))
 			return ata_scsi_flush_xlat;
@@ -3109,6 +3204,9 @@ void ata_scsi_simulate(struct ata_device
 		case 0x89:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_89);
 			break;
+		case 0xb0:
+			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b0);
+			break;
 		case 0xb1:
 			ata_scsi_rbuf_fill(&args, ata_scsiop_inq_b1);
 			break;
Index: linux-2.6/include/linux/ata.h
===================================================================
--- linux-2.6.orig/include/linux/ata.h	2009-11-17 15:25:53.989003924 +0100
+++ linux-2.6/include/linux/ata.h	2009-11-17 15:29:14.874033900 +0100
@@ -87,6 +87,7 @@ enum {
 	ATA_ID_HW_CONFIG	= 93,
 	ATA_ID_SPG		= 98,
 	ATA_ID_LBA_CAPACITY_2	= 100,
+	ATA_ID_SECTOR_SIZE	= 106,
 	ATA_ID_LAST_LUN		= 126,
 	ATA_ID_DLF		= 128,
 	ATA_ID_CSFO		= 129,
@@ -638,6 +639,18 @@ static inline int ata_id_flush_ext_enabl
 	return (id[ATA_ID_CFS_ENABLE_2] & 0x2400) == 0x2400;
 }
 
+static inline int ata_id_has_large_logical_sectors(const u16 *id)
+{
+	if ((id[ATA_ID_SECTOR_SIZE] & 0xc000) != 0x4000)
+		return 0;
+	return id[ATA_ID_SECTOR_SIZE] & (1 << 13);
+}
+
+static inline u8 ata_id_logical_per_physical_sectors(const u16 *id)
+{
+	return id[ATA_ID_SECTOR_SIZE] & 0xf;
+}
+
 static inline int ata_id_has_lba48(const u16 *id)
 {
 	if ((id[ATA_ID_COMMAND_SET_2] & 0xC000) != 0x4000)
