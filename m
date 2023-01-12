Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494F1C678D5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjALOKO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjALOJb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:09:31 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4E158310;
        Thu, 12 Jan 2023 06:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532306; x=1705068306;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DxPLUnFEiqHGirdA3rRfvoSUO8OEmt2q6ZMTmQXO9l8=;
  b=KzC0MkxOV1AJKrdyf5bqpwsFG/nQZ6RCwjUopfCAUe34Ujphz3JKQh7K
   cUnTZbomfCNWjqLBYJrPLNGKKwtJrkji13AKHgaEgIa/03xWth0EJ7MWj
   pIhuX1RDFANK+szKWjkhZdLj5AWKP8tv446ZSjhggLDg25vXU/HRPVNlA
   uvf19eEpmfEl7z9hlU6YlU2+EwhVQD8l7XzgLu2KosAHHWaBOJB75JiFo
   QUUzfp28CSuI5zIEpYB2csa/TWxI38KJrc09dHNoXTrl5QUcJHPOdmOv1
   WtejAIw0RknxFdXN1pVZEGRQA5/sj40/0dqBOxid4ieHFpE3RLqNeQa+1
   g==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632732"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:04:55 +0800
IronPort-SDR: kk5bTt8T+bvwxxuL+/R3Uqnvu9fSIfq0tWZ3hXCj/FWXnn2RT6qZl0eKAD4pGrEsFK+zpgW7Pt
 0UjBr9UXV10eSQpZkNd1rKzjSz5tsHbiIW4rLnYUU2uRZOhLNEW4EvpHanL3ca/8Vby3G9Rsw/
 uJ4SnZRx9FQgtNvwr1HyqSodUDL9Xc4BkBsWFnm8QgX3wBy7AVVrzcF/wpiSZBrrJ2Ie7Pwcg0
 0Uo3RiJaakkS+TN4mLRiDKaJh6ehCWcPRf5mzKri7rNDRjNk3sy5r1p0g/7cJTYclzACJuB5RY
 5iM=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:16:58 -0800
IronPort-SDR: 7e4NJz2fXykpSZnGf3ZJD6LZsVszcB21v2kcy8K3sKznj/6niHfD8CuHjKzAlUnLX5onCW2nbj
 1NfevQR4YazMGDs/Wd89WmPVmERxqyGcGvXoCOjWdxDgsbmLwjUBxkYkqxBvKqA6TOzU/Nj2bQ
 aP0NduMY9TauW2GieL9IM/DSr6yDf6TMnc+k71M5VKwDYsf3AmZ5KneC8zV6uaoLWIm1fFJvY7
 wnHsFe+MDzFy1OYScHNtRP78Fq96u38sbZ+Q2BpNhJDYiVO0ENrZ7PIN9R6M1GdaTYT9ban3Bq
 czI=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:04:55 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 13/18] ata: libata: set read/write commands CDL index
Date:   Thu, 12 Jan 2023 15:04:02 +0100
Message-Id: <20230112140412.667308-14-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112140412.667308-1-niklas.cassel@wdc.com>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

For devices supporting the command duration limits feature, when a read
or write operation has the IOPRIO_CLASS_DL priority class and the
command duration limits feature is enabled, set the command duration
limit index field of the command to the priority level.

For unqueued read and write operations, the command duration limit index
is set as the lower 2 bits of the feature field. For queued NCQ
read/write commands, the index is set as the lower 2 bits of the
auxiliary field.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-core.c | 43 ++++++++++++++++++++++++++++++++++-----
 drivers/ata/libata-scsi.c |  3 +--
 drivers/ata/libata.h      |  2 +-
 include/linux/libata.h    |  1 +
 4 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 9aa49eab2b95..2c1531ef169d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -665,13 +665,37 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
 	return block;
 }
 
+/*
+ * Set a taskfile CDL index.
+ */
+static inline void ata_set_tf_cdl(struct ata_queued_cmd *qc, int ioprio)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	int cdl;
+
+	if (IOPRIO_PRIO_CLASS(ioprio) != IOPRIO_CLASS_DL)
+		return;
+
+	cdl = IOPRIO_PRIO_DATA(ioprio) & 0x07;
+	if (!cdl)
+		return;
+
+	if (tf->protocol == ATA_PROT_NCQ)
+		tf->auxiliary |= cdl;
+	else
+		tf->feature |= cdl;
+
+	/* Mark this command as having a CDL */
+	qc->flags |= ATA_QCFLAG_HAS_CDL;
+}
+
 /**
  *	ata_build_rw_tf - Build ATA taskfile for given read/write request
  *	@qc: Metadata associated with the taskfile to build
  *	@block: Block address
  *	@n_block: Number of blocks
  *	@tf_flags: RW/FUA etc...
- *	@class: IO priority class
+ *	@ioprio: IO priority class and level
  *
  *	LOCKING:
  *	None.
@@ -685,7 +709,7 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
  *	-EINVAL if the request is invalid.
  */
 int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
-		    unsigned int tf_flags, int class)
+		    unsigned int tf_flags, int ioprio)
 {
 	struct ata_taskfile *tf = &qc->tf;
 	struct ata_device *dev = qc->dev;
@@ -722,13 +746,22 @@ int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
 			tf->device |= 1 << 7;
 
 		if (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED &&
-		    class == IOPRIO_CLASS_RT)
+		    IOPRIO_PRIO_CLASS(ioprio) == IOPRIO_CLASS_RT)
 			tf->hob_nsect |= ATA_PRIO_HIGH << ATA_SHIFT_PRIO;
+
+		if (dev->flags & ATA_DFLAG_CDL_ENABLED)
+			ata_set_tf_cdl(qc, ioprio);
+
 	} else if (dev->flags & ATA_DFLAG_LBA) {
 		tf->flags |= ATA_TFLAG_LBA;
 
-		/* We need LBA48 for FUA writes */
-		if (!(tf->flags & ATA_TFLAG_FUA) && lba_28_ok(block, n_block)) {
+		if (dev->flags & ATA_DFLAG_CDL_ENABLED)
+			ata_set_tf_cdl(qc, ioprio);
+
+		/* Both FUA writes and a CDL index require 48-bit commands */
+		if (!(tf->flags & ATA_TFLAG_FUA) &&
+		    !(qc->flags & ATA_QCFLAG_HAS_CDL) &&
+		    lba_28_ok(block, n_block)) {
 			/* use LBA28 */
 			tf->device |= (block >> 24) & 0xf;
 		} else if (lba_48_ok(block, n_block)) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0f843512fe04..b8caecd875cd 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1549,7 +1549,6 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	const u8 *cdb = scmd->cmnd;
 	struct request *rq = scsi_cmd_to_rq(scmd);
-	int class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 	unsigned int tf_flags = 0;
 	u64 block;
 	u32 n_block;
@@ -1625,7 +1624,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 	qc->flags |= ATA_QCFLAG_IO;
 	qc->nbytes = n_block * scmd->device->sector_size;
 
-	rc = ata_build_rw_tf(qc, block, n_block, tf_flags, class);
+	rc = ata_build_rw_tf(qc, block, n_block, tf_flags, req_get_ioprio(rq));
 	if (likely(rc == 0))
 		return 0;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 5481d29bb273..339b19c0bbcf 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -45,7 +45,7 @@ static inline void ata_force_cbl(struct ata_port *ap) { }
 extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
 extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
 extern int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
-			   unsigned int tf_flags, int class);
+			   unsigned int tf_flags, int ioprio);
 extern u64 ata_tf_read_block(const struct ata_taskfile *tf,
 			     struct ata_device *dev);
 extern unsigned ata_exec_internal(struct ata_device *dev,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d7fe735e6322..ab8b62036c12 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -209,6 +209,7 @@ enum {
 	ATA_QCFLAG_CLEAR_EXCL	= (1 << 5), /* clear excl_link on completion */
 	ATA_QCFLAG_QUIET	= (1 << 6), /* don't report device error */
 	ATA_QCFLAG_RETRY	= (1 << 7), /* retry after failure */
+	ATA_QCFLAG_HAS_CDL	= (1 << 8), /* qc has CDL a descriptor set */
 
 	ATA_QCFLAG_EH		= (1 << 16), /* cmd aborted and owned by EH */
 	ATA_QCFLAG_SENSE_VALID	= (1 << 17), /* sense data valid */
-- 
2.39.0

