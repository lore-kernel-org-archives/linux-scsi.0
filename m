Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718DDC6371A
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiLHLDz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiLHLDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:03:14 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8928F88B62;
        Thu,  8 Dec 2022 03:01:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497290; x=1702033290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+niR1lfLubo3xlVgT4pgZA15mdDi1+PYFnKKG++F5eY=;
  b=aRGvAB/zL7Sx9LyPiK89Q2CxNQFObQpUd8Ud9gQg6xnk1iUPdJdYM/LF
   YbekHTQEx6NZVRIFWVO27oK0G0EUIrp2bRg4mPpviJ5ZGMSEUNQ0bLg93
   vCFldYr0XON+JDHDAb1RpeHpltZ3ANu1G+qJEgQcRL/ozi+1x317exW/x
   xzx/PgbZ2Lkuv5x2tBrXUHmwg34YnXWtCK2BMFTxPR+mnCs1Tx6Jjo2Z7
   AyQJJUlEExyex68fuGNLOdkcArobNXsP53cH40gVn3IPQhSn/turQwXsW
   DzKEYHGSHYwNPXk6iFv6byYbyNO053lM4V8xZCEoi2FvQ5BWCw209ca5Y
   A==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333419"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:30 +0800
IronPort-SDR: YQauxxZY7txmcFQe7Pwx3s9axK1gC4G3jnm0nXCPwlVfrohs5iaXblfAKKQpRwx2OsSyuIT2wZ
 bDmSU4gZMt6AYuVhhziPc8W7tIeNObqSodZHqJoTrk5b/Ysxi4AKm+eaY9cOpIHdrE0SCJTDNa
 mJo4RHJ6SdtVs4HDGsH9t1tn+pbMataRrOZlzo1Xdl8fH6w8Umyrb/pTP8p/TEM1jnczwjMp9G
 p9nJxvZ+5+4JWrS7eHtDfrrYKHh33gNjQZLjoXsdESTqiKMQd8v2ieMRpDZk0n9oBSmhwtbtPx
 3Lg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:14:15 -0800
IronPort-SDR: j4N1t+Kkv2DnU9PP2ymeo1HBAkQmm/kUIwHT8ZSj0D+gO/e9L9FFiBScrT/JDejEew3VKQrRFb
 3Pxfo9IQwaUiEShnjaoj6Ar4M+Fau7XCH7lWi9wMV+QbOmF9bwHsHNpSKJS4lrBHf22/Ylmxp6
 ujnapAB7+3Wwhz1jjVQpQEKXF3c/axlnWc6ipQHcrfXDOw17Juj1iTqT3omUvs5LbCHI2jEa2u
 ja9OuL5MV+sHCvnOwSO3/O9av2lp7TF9bTVd7GH5Adr1y2Qc1VOgkcnWW2vp0lRQrrdRaFOSHa
 zRY=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:29 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 20/25] ata: libata: set read/write commands CDL index
Date:   Thu,  8 Dec 2022 11:59:36 +0100
Message-Id: <20221208105947.2399894-21-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
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

Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/ata/libata-core.c | 41 +++++++++++++++++++++++++++++++++++----
 drivers/ata/libata-scsi.c |  3 +--
 drivers/ata/libata.h      |  2 +-
 include/linux/libata.h    |  1 +
 4 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 70bf82f804da..c79ee38dc594 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -663,13 +663,37 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
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
@@ -683,7 +707,7 @@ u64 ata_tf_read_block(const struct ata_taskfile *tf, struct ata_device *dev)
  *	-EINVAL if the request is invalid.
  */
 int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
-		    unsigned int tf_flags, int class)
+		    unsigned int tf_flags, int ioprio)
 {
 	struct ata_taskfile *tf = &qc->tf;
 	struct ata_device *dev = qc->dev;
@@ -720,12 +744,21 @@ int ata_build_rw_tf(struct ata_queued_cmd *qc, u64 block, u32 n_block,
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
 
-		if (lba_28_ok(block, n_block)) {
+		if (dev->flags & ATA_DFLAG_CDL_ENABLED)
+			ata_set_tf_cdl(qc, ioprio);
+
+		/* a CDL index cannot be supplied with the 28-bit commands */
+		if (!(qc->flags & ATA_QCFLAG_HAS_CDL) &&
+		    lba_28_ok(block, n_block)) {
 			/* use LBA28 */
 			tf->device |= (block >> 24) & 0xf;
 		} else if (lba_48_ok(block, n_block)) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c4c39a5db75e..105795e867c9 100644
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
index f41a96f89cd7..ecdabe5647d1 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -207,6 +207,7 @@ enum {
 	ATA_QCFLAG_CLEAR_EXCL	= (1 << 5), /* clear excl_link on completion */
 	ATA_QCFLAG_QUIET	= (1 << 6), /* don't report device error */
 	ATA_QCFLAG_RETRY	= (1 << 7), /* retry after failure */
+	ATA_QCFLAG_HAS_CDL	= (1 << 8), /* qc has CDL a descriptor set */
 
 	ATA_QCFLAG_EH		= (1 << 16), /* cmd aborted and owned by EH */
 	ATA_QCFLAG_SENSE_VALID	= (1 << 17), /* sense data valid */
-- 
2.38.1

