Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E612BC6FD1D
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbjDDSiD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjDDShd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:37:33 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227447AB7;
        Tue,  4 Apr 2023 11:36:15 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id h25so43531172lfv.6;
        Tue, 04 Apr 2023 11:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680633373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W/SwkKdRoNxVb2d2rk1vwXdhi8clxcOTg7uTJ+39OtY=;
        b=MAiJJmjGzfBrSrtxXE3OBkR5HEXE2XC3zyFaRNOgrl4IYaLwiaUuc6kjlEe1xYRln5
         XIw11cBVPE08D4xtIEmxqjeQ58JakLhVrLCIa10bde82A4ILbLQ6XZKT+Qwm771sQWsz
         J0MsIRynQhGdqdvL15gWGGg6/waGqODBXPnS643wzRaBkY6JnqopOwnQl2PYTVwoltIl
         ETGccPhNHLy06mq3fvWlZhkAr46DqE1E7tw0/AdkwlIvGcP4vyvo1uMCv8PxB0h3VPI8
         EK5qNUUjG5ZMdAtr3Ax1SlBAE9lbGG1Sk3/k52f3mPc0vsju8Tz7rarJpjVRJp6BlgJz
         js2A==
X-Gm-Message-State: AAQBX9dM2tlPObKPpHDTjkUGYO+iKQFxJ1J1PH+8k7LXs0mQAziv1eXo
        i2COI0Q1i1TOGbJHOQpcQ3e7hbhvEdliAA==
X-Google-Smtp-Source: AKy350aPXMW3TfRYyAnxIwpMDqHjHzPUfdPPztvAVMXx0VrkXQRltHF7iWWUnLQtHmCGHZJxxJw0Qw==
X-Received: by 2002:ac2:4838:0:b0:4e8:47cd:b4ba with SMTP id 24-20020ac24838000000b004e847cdb4bamr966088lft.13.1680633373249;
        Tue, 04 Apr 2023 11:36:13 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id e3-20020ac25463000000b004eb2f35045bsm2349200lfn.269.2023.04.04.11.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:36:12 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 0862C865; Tue,  4 Apr 2023 20:36:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680633372; bh=EUU/zT1qGCY9K02epCW90BO/+ShxykgjORaxgXb+Zxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmTjJTnFq1BBWKSkKfSBZ+RoGaRz8B6oVq7TZDJJosXezZ+gJPPAgXG9NLSoQ5fE6
         PyyRezEHooAmpWEi/ElZwhPXiR3TvPhQe30MTeK3qlXseuq1jbMf/jA7TDnNdweKJk
         zVpUTg4v8cwZTDdjQiM8XR5t/QQVPol4y7eFJdUw=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id DB03611C2;
        Tue,  4 Apr 2023 20:25:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632757; bh=EUU/zT1qGCY9K02epCW90BO/+ShxykgjORaxgXb+Zxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrnAfyxro0GxJbKBbtEJzXvJ9ATtfmLVxSTnW9tgvt2DVrKssN/RThASC0wxKSCyi
         MC0lbFj9IQCku9RttsjUb3pne8WadzecfWO1B1up4ml5azF7FeZnYqQ4l2TqnYEQ5I
         4NOblZ7E5qk3hbKUPSkEJVxCnN7+dO9NNbTw7Brc=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v5 18/19] ata: libata: set read/write commands CDL index
Date:   Tue,  4 Apr 2023 20:24:23 +0200
Message-Id: <20230404182428.715140-19-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404182428.715140-1-nks@flawful.org>
References: <20230404182428.715140-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

For devices supporting the command duration limits feature, translate
the dld field of read and write operation to set the command duration
limit index field of the command task file when the duration limit
feature is enabled.

The function ata_set_tf_cdl() is introduced to do this. For unqueued
(non NCQ) read and write operations, this function sets the command
duration limit index set as the lower 2 bits of the feature field.
For queued NCQ read/write commands, the index is set as the lower
2 bits of the auxiliary field.

The flag ATA_QCFLAG_HAS_CDL is introduced to indicate that a command
taskfile has a non zero cdl field.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-core.c | 32 +++++++++++++++++++++++++++++---
 drivers/ata/libata-scsi.c | 16 +++++++++++++++-
 drivers/ata/libata.h      |  2 +-
 include/linux/libata.h    |  1 +
 4 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 62e100fa90e2..c68e7b684a87 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -665,12 +665,29 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
 	return block;
 }
 
+/*
+ * Set a taskfile command duration limit index.
+ */
+static inline void ata_set_tf_cdl(struct ata_queued_cmd *qc, int cdl)
+{
+	struct ata_taskfile *tf = &qc->tf;
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
+ *	@cdl: Command duration limit index
  *	@class: IO priority class
  *
  *	LOCKING:
@@ -685,7 +702,7 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
  *	-EINVAL if the request is invalid.
  */
 int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
-		    unsigned int tf_flags, int class)
+		    unsigned int tf_flags, int cdl, int class)
 {
 	struct ata_taskfile *tf = &qc->tf;
 	struct ata_device *dev = qc->dev;
@@ -724,11 +741,20 @@ int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
 		if (dev->flags & ATA_DFLAG_NCQ_PRIO_ENABLED &&
 		    class == IOPRIO_CLASS_RT)
 			tf->hob_nsect |= ATA_PRIO_HIGH << ATA_SHIFT_PRIO;
+
+		if ((dev->flags & ATA_DFLAG_CDL_ENABLED) && cdl)
+			ata_set_tf_cdl(qc, cdl);
+
 	} else if (dev->flags & ATA_DFLAG_LBA) {
 		tf->flags |= ATA_TFLAG_LBA;
 
-		/* We need LBA48 for FUA writes */
-		if (!(tf->flags & ATA_TFLAG_FUA) && lba_28_ok(block, n_block)) {
+		if ((dev->flags & ATA_DFLAG_CDL_ENABLED) && cdl)
+			ata_set_tf_cdl(qc, cdl);
+
+		/* Both FUA writes and a CDL index require 48-bit commands */
+		if (!(tf->flags & ATA_TFLAG_FUA) &&
+		    !(qc->flags & ATA_QCFLAG_HAS_CDL) &&
+		    lba_28_ok(block, n_block)) {
 			/* use LBA28 */
 			tf->device |= (block >> 24) & 0xf;
 		} else if (lba_48_ok(block, n_block)) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8dde1cede5ca..05bde27947a2 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1380,6 +1380,18 @@ static inline void scsi_16_lba_len(const u8 *cdb, u64 *plba, u32 *plen)
 	*plen = get_unaligned_be32(&cdb[10]);
 }
 
+/**
+ *	scsi_dld - Get duration limit descriptor index
+ *	@cdb: SCSI command to translate
+ *
+ *	Returns the dld bits indicating the index of a command duration limit
+ *	descriptor.
+ */
+static inline int scsi_dld(const u8 *cdb)
+{
+	return ((cdb[1] & 0x01) << 2) | ((cdb[14] >> 6) & 0x03);
+}
+
 /**
  *	ata_scsi_verify_xlat - Translate SCSI VERIFY command into an ATA one
  *	@qc: Storage for translated ATA taskfile
@@ -1548,6 +1560,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 	struct request *rq = scsi_cmd_to_rq(scmd);
 	int class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 	unsigned int tf_flags = 0;
+	int dld = 0;
 	u64 block;
 	u32 n_block;
 	int rc;
@@ -1598,6 +1611,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 			goto invalid_fld;
 		}
 		scsi_16_lba_len(cdb, &block, &n_block);
+		dld = scsi_dld(cdb);
 		if (cdb[1] & (1 << 3))
 			tf_flags |= ATA_TFLAG_FUA;
 		if (!ata_check_nblocks(scmd, n_block))
@@ -1622,7 +1636,7 @@ static unsigned int ata_scsi_rw_xlat(struct ata_queued_cmd *qc)
 	qc->flags |= ATA_QCFLAG_IO;
 	qc->nbytes = n_block * scmd->device->sector_size;
 
-	rc = ata_build_rw_tf(qc, block, n_block, tf_flags, class);
+	rc = ata_build_rw_tf(qc, block, n_block, tf_flags, dld, class);
 	if (likely(rc == 0))
 		return 0;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 2cd6124a01e8..73dd2ebc277c 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -45,7 +45,7 @@ static inline void ata_force_cbl(struct ata_port *ap) { }
 extern u64 ata_tf_to_lba(const struct ata_taskfile *tf);
 extern u64 ata_tf_to_lba48(const struct ata_taskfile *tf);
 extern int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
-			   unsigned int tf_flags, int class);
+			   unsigned int tf_flags, int dld, int class);
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

