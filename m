Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC20C7618D
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbjDFLuo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238705AbjDFLub (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:50:31 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0748CB449;
        Thu,  6 Apr 2023 04:46:25 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id b6so20364832ljr.1;
        Thu, 06 Apr 2023 04:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680781497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TZHvC9U7GPgXUF8X1nvvu4BiQ81SBtW9ZAUi9gxQQdA=;
        b=Mmb/bM09eO6+QEf+Xcx2Vk7nicFqyiN3qMXBPdSvhQQa0Mn+33uaIRzBqEhzQdJ6GK
         CQa6rTSdaMY6Q3ZGeUorOQCnF+JxCVYxOxjvSHh+2pU6xdRZG5x1eHRRn7/WY02qmcOB
         dSNxkCPzf6t4jVTPQscIHS9Ghl4vPjm9XkH8nxWalQHfPsQ9a2RYa5BiceBPi2DDu4N7
         qPE5FVE+evy1VeCXI8ZeSI7+Qfem39/+MtDJcEIN71Nn7VSlF+kSVEXRPzWiujPEM7mE
         FkWUBJR5mVXEMmsoBh/DWORDs+Vq7645gu+x4DCB903ayo8LhxpT1qjm9jZ56bXvOM1y
         +B1A==
X-Gm-Message-State: AAQBX9fW8w5juyOKrJBiTG4A89jKFe+NK70IvrWATlgeSy1B5T11egYa
        /iJJjusOeorZF8zSv4Kb47cTGKkhc3lWaQ==
X-Google-Smtp-Source: AKy350Ym9pfCMuXzbFkeLqRV5u9SjPO8ys0XxTMwWg4O52KcdBxIYQM8qsSyVjJl6GKYzAjxhEJn9w==
X-Received: by 2002:a2e:7308:0:b0:28e:a8aa:6f95 with SMTP id o8-20020a2e7308000000b0028ea8aa6f95mr2764185ljc.8.1680781497417;
        Thu, 06 Apr 2023 04:44:57 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id z6-20020a05651c022600b002a5f6de7b09sm258484ljn.0.2023.04.06.04.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:44:57 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id E0F63666; Thu,  6 Apr 2023 13:44:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781496; bh=l05dCftNysZTSd6g6+yvdlZ9L767/o2AuMTn3MxEWQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaGYX1jMvu4G5/O1iq9BHoP2zUCz9yGJnP5D1h/OpmJ/VmcZPIyjc9pnp+6klx4dA
         yaM1gyX+xDOXSaLH/tYg4bjVr1r0QS6VQd0q1PV2YLmxDPu1HVr6ZRx9lwHpcVDKuw
         7yv9ccxTZTyAfcfm+DiakzyiXzbhItLTPMz3reu0=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 4448511C2;
        Thu,  6 Apr 2023 13:33:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780803; bh=l05dCftNysZTSd6g6+yvdlZ9L767/o2AuMTn3MxEWQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YfMfHAt3PlbzwLSFFpgzPddBYpLmytEjCNA2jCh+omlnto09Lo6/Yy4LLtxqt5JPk
         Wk/QNXnIu2ag9RuLhFOFcYzsKdVSVpqjwhmORpe6qHwHB+Dc/N30jFKroC1Rf8Goct
         QNNoarxpFd4tQg/QTv3NaRbDhIOSeMGqKT2kZOCI=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH v6 18/19] ata: libata: set read/write commands CDL index
Date:   Thu,  6 Apr 2023 13:32:47 +0200
Message-Id: <20230406113252.41211-19-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
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
duration limit index set as the lower 3 bits of the feature field.
For queued NCQ read/write commands, the index is set as the lower
3 bits of the auxiliary field.

The flag ATA_QCFLAG_HAS_CDL is introduced to indicate that a command
taskfile has a non zero cdl field.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
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

