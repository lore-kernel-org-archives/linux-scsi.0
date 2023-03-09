Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B354C74A5B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:58:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjCIV6p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjCIV5x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:57:53 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96028105542;
        Thu,  9 Mar 2023 13:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398984; x=1709934984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oat3fRaUHGz/GDaU521bbBVFkXEgU1y1LbC4eDih07o=;
  b=Vpo9hmt22bjA1lzGvPGCXTFoLwlooBU9EfiQurDke6oI/x0GIdCdcql+
   r2aerFyBO+YrY7F/fu2AaS9z1NjlJZYQV1ajbFMUv8UnMkKtTFBRqWkz2
   jStv1qrhlZa1f+lxG0HIqloBP3MGyGf9nVPoIlmA7eycGg03Cx56RaA1h
   1LiRjBmqzgwYCMqoFt9ij5vzCbTWQmIpmhtJgm79B5P+dsS7vwPCM/SbT
   U0epzxDBBmGT8LqvP5kxzqCM2G66kxs5qnpAS/1qfAAW08ygkO3wsvnvN
   SI7PdIYz6JNDTkDHSg9deZ+2YFdwtvHGhly0en8TNKgA7o7xdHjuZleQV
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225271066"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:56:19 +0800
IronPort-SDR: xRXFMMLSqNIhYqezIbWncWj6V/39E5eOyUfw+14S206nAEqRUac+XnyLaeDr+H6MwGmEbBnT1j
 tUbGBlvy2rWrDyTWn0PJplNp7QBJrQJd7bj4SVd0sZQ02aeEzVKjUEB7YZI0QmRJ0doqKEJbP8
 nz4fvsGlvIaxWYgQxxqqQdlGGlUo9sQPiqhO7owOthGhgd4LsopgPIKu09+z3HIhCtXM2NyVmu
 nvlolpEiK+h7+LJR6UCF+lVTE56jnUNWUUt6YxEAWXFwds5orQ3WnVy7mZYaP9DZDX8GyB9ugd
 3W0=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:07:12 -0800
IronPort-SDR: yGXsDYQtdN2mk7hw6PghvhNDWf+EXCgevAOV1nximzDxVVL/eTD35dXqFWv0gLrhH5Ebwby/SN
 IfR4CKnqlmp4yQa+9lHxX/Shi1PxhEsohP4Imrghoe8UW+jhGv1DtLPYmzhTudxSNyHHGX/NBw
 mXDB9RRFt3zxAhyqw4O8h4aPQqVDimfZ23oL+qkmhRFYO4Uerghf3lBAvvt6xUabU7wvYOREZR
 XmxodZU2QMh9RrGLfDtSlKAn0p2yr0JUksmlUaTP/rDSudCYTlVUFGuR1/FbQ/pE278h2o1bXM
 o7w=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:56:18 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 18/19] ata: libata: set read/write commands CDL index
Date:   Thu,  9 Mar 2023 22:55:10 +0100
Message-Id: <20230309215516.3800571-19-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

For devices supporting the command duration limits feature, when a read
or write operation has an IO priority specifying one of the
IOPRIO_HINT_DEV_DURATION_LIMIT_X hint and the command duration limits
feature is enabled, set the command duration limit index field of the
command using the hint value.

The function ata_set_tf_cdl() is introduced to do this. For unqueued
(non NCQ) read and write operations, this function sets the command
duration limit index set as the lower 2 bits of the feature field.
For queued NCQ read/write commands, the index is set as the lower
2 bits of the auxiliary field.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-core.c | 42 ++++++++++++++++++++++++++++++++++-----
 drivers/ata/libata-scsi.c |  3 +--
 drivers/ata/libata.h      |  2 +-
 include/linux/libata.h    |  1 +
 4 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 62e100fa90e2..90764aeb5446 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -665,13 +665,36 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
 	return block;
 }
 
+/*
+ * Set a taskfile CDL index.
+ */
+static inline void ata_set_tf_cdl(struct ata_queued_cmd *qc, int ioprio)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	unsigned int hint = IOPRIO_PRIO_HINT(ioprio);
+	int cdl;
+
+	if (hint < IOPRIO_HINT_DEV_DURATION_LIMIT_1 ||
+	    hint > IOPRIO_HINT_DEV_DURATION_LIMIT_7)
+		return;
+
+	cdl = (hint - IOPRIO_HINT_DEV_DURATION_LIMIT_1) + 1;
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
@@ -685,7 +708,7 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
  *	-EINVAL if the request is invalid.
  */
 int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
-		    unsigned int tf_flags, int class)
+		    unsigned int tf_flags, int ioprio)
 {
 	struct ata_taskfile *tf = &qc->tf;
 	struct ata_device *dev = qc->dev;
@@ -722,13 +745,22 @@ int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
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
index 8dde1cede5ca..ce5c6a49a098 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1546,7 +1546,6 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	const u8 *cdb = scmd->cmnd;
 	struct request *rq = scsi_cmd_to_rq(scmd);
-	int class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 	unsigned int tf_flags = 0;
 	u64 block;
 	u32 n_block;
@@ -1622,7 +1621,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 	qc->flags |= ATA_QCFLAG_IO;
 	qc->nbytes = n_block * scmd->device->sector_size;
 
-	rc = ata_build_rw_tf(qc, block, n_block, tf_flags, class);
+	rc = ata_build_rw_tf(qc, block, n_block, tf_flags, req_get_ioprio(rq));
 	if (likely(rc == 0))
 		return 0;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 2cd6124a01e8..26aa777a2ad0 100644
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
2.39.2

