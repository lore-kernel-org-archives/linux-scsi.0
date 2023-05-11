Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59707C77B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236865AbjEKBZ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236782AbjEKBZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:25:25 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295455FDF;
        Wed, 10 May 2023 18:25:23 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4f24cfb8539so5422025e87.3;
        Wed, 10 May 2023 18:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683768321; x=1686360321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5sPcvTXav7dL/vDxuI2pL9w3hy1XOWgUgc7aXKOIuYk=;
        b=cDtEhLbgNF0H4Hz3RMANS5UKA9UU9l3FPvn36HYAuSstEARHEbgAZfJFySdwVkpXRa
         34zTeV/ATKfZsHHqyOVgxgiOJt8H/xJMyI5+wNxfqungC/p/3Y6jA7b4J6bAeuFWkwQP
         FNbZ25EEnyaB7Ou8E8u5twv1SLHJMb/hZPpiTePBWki2lmzpSkMulZDdNazXZYMITzfd
         M0VngqM1S+loknFQVcxvH2dY24VYayfF2kRME+N3BY3lXs+VdjdnHhHvS6cGOnDHmxQ2
         cDRT/wX0KdZSWh3wXAkFFRrsKeEkz+cgDPFLaloLKTbWF8i4uVeRwnr43HnK8O+f7ORn
         oNpw==
X-Gm-Message-State: AC+VfDweXdd4rQWAVO2xxgItq+euoV1RPL5ESeW+2wyYyZqXGPvU2qXd
        JiBgPN6OFOkuC1SeEm9a3CTxdezXYZOseB63
X-Google-Smtp-Source: ACHHUZ7M9Gz2ovFPt1nrnfbbwNVz8WxxbMBUbgKK1H8fekYTEa+esEBGo8VGH6Pgtj6gPTGbdWQQ3g==
X-Received: by 2002:ac2:546d:0:b0:4dd:9ddc:4463 with SMTP id e13-20020ac2546d000000b004dd9ddc4463mr2015156lfn.5.1683768321384;
        Wed, 10 May 2023 18:25:21 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id f14-20020a19ae0e000000b004f2543be9dbsm911612lfc.5.2023.05.10.18.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:25:21 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 5131F3C7; Thu, 11 May 2023 03:25:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683768320; bh=pq3xzo00wAGq6yJqd/ekSDcxsUnFFlttFbXuo3rBWGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMVonWgPqDgAzGiI+FGEpwGEq6uAjVJyo81eO+dSCD4Mxa+BSJVp01ys2DPjJH0bE
         zbbVECquDL/7hEdM3k00XPNclGImbNv0WqmbW+/MR2J8Ve9Gtr1gQFi3C1mZ6f8fzK
         fw0fLsuuUnzkz+qndQJOCKFAfz5V8ZCK4WfVFNeM=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 6B70E8D2;
        Thu, 11 May 2023 03:15:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767748; bh=pq3xzo00wAGq6yJqd/ekSDcxsUnFFlttFbXuo3rBWGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d1SNMJaEPs+1ABD+3vaIcutOl9Q14uvCAUMZ+WEMm2rsGiAS4AV2FRZ3LzL4T5JuK
         HLVkcpVKGql3AiL2NmqJp+sfFz7Z8lQmcxzHkjRZYMrTNi0sfcFFoE8+fhw3Paljt4
         HtSdfeGid0HdNY2TN/TRj3M0rdrQDXonOWLec58U=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>,
        Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH v7 18/19] ata: libata: set read/write commands CDL index
Date:   Thu, 11 May 2023 03:13:51 +0200
Message-Id: <20230511011356.227789-19-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <dlemoal@kernel.org>

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

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-core.c | 32 +++++++++++++++++++++++++++++---
 drivers/ata/libata-scsi.c | 16 +++++++++++++++-
 drivers/ata/libata.h      |  2 +-
 include/linux/libata.h    |  1 +
 4 files changed, 46 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index cd7aaf202397..e63773740fc2 100644
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
index 91db4e7f4906..69fc0d2c2123 100644
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
index 926d0d33cd29..cf993885d2b2 100644
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
index 385ca23d5ad0..f679abd2e61f 100644
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
2.40.1

