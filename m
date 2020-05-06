Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42128C47257
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 16:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E18B20A8B
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 16:12:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TR7nFq45"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbgEFQME (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 12:12:04 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:61310 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbgEFQMB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2020 12:12:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588781521; x=1620317521;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=g5AG8nHQvcBfTW7D00G9a2jNlsRVALeJYYmeP1Th5QM=;
  b=TR7nFq45xBQgsjSyv34VcxJtZS63z01uckVpDYCVurL7a76CQPMs8XJx
   Q5lQv+CcPFCdg7vFQNjLrB9RMO57Jd3LUtFT2pYCvlTaeQ7nPnGcUPDFg
   zhWGbUlwjLikIL3OMRDGk8twXYO059VdiSzOyF8WLH/oIOcq3VEOkhqGZ
   b59AU/GtoyzXLixgjcgLBrjFp0SFJp+hKlXxFcNDzVQBICVKMtV5Q33oK
   6hY7lfk0C4N+xC2E+84JKpkMZYCMK/nsZ5bHCUdWa4eKw055mSF2eWEX7
   k+RFiOblvuXUW1L9zQVwWzi8eGXzQi8tme9m/+Rq9J8YVnbRnSMnDy0oT
   w==;
IronPort-SDR: lq60rJJWRiU8bnzqzJix9mhm+XzVQOL+2keEflKpklOTa4Aj44SZGLoiJD+w5XTp9SEV5C88ok
 BUl8FCRHi2rPdx/pHiIUluak866b7xU4CBb7U1LyJ8cpz3Z5R9xL5RwebA9XtgAaAVXMNhOMTH
 3JMuxIFTnLp6ZgYnOCb5jf35SmE+9ticlMdNvzYixqGC1+vc2mb3rb2m124d0MQGwUgM5AJC86
 siZq2frASAV5tssem1wn1MTwL5ei47WJ6n9S13HfPZCpcRFcUDqwyC7wOZAYExfyEJ+f9AWkCd
 bGQ=
X-IronPort-AV: E=Sophos;i="5.73,359,1583164800"; 
   d="scan'208";a="245917902"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 May 2020 00:12:01 +0800
IronPort-SDR: oQVO4A6OlQd/uPU2FLnYrtwV+VqZr2PpnUxTneMtzo0PkDJtaB8rf0EcCT2Jlc0HCct6wsQxxw
 EONBFQiff0pt74YrawlIJQ+zjza1JnNVI=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 09:02:27 -0700
IronPort-SDR: 6en/6xjZpfX713VhGVolyzXPDMAqeaEsCylyVDL+xDuir3SUS4gFDXWpohyrY81tIMq8CE9b05
 DYn03U8nXUoQ==
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 May 2020 09:11:59 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH v10 5/9] scsi: sd_zbc: factor out sanity checks for zoned commands
Date:   Thu,  7 May 2020 01:11:41 +0900
Message-Id: <20200506161145.9841-6-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200506161145.9841-1-johannes.thumshirn@wdc.com>
References: <20200506161145.9841-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Factor sanity checks for zoned commands from sd_zbc_setup_zone_mgmt_cmnd().

This will help with the introduction of an emulated ZONE_APPEND command.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd_zbc.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index f45c22b09726..ee156fbf3780 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -209,6 +209,26 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 	return ret;
 }
 
+static blk_status_t sd_zbc_cmnd_checks(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t sector = blk_rq_pos(rq);
+
+	if (!sd_is_zoned(sdkp))
+		/* Not a zoned device */
+		return BLK_STS_IOERR;
+
+	if (sdkp->device->changed)
+		return BLK_STS_IOERR;
+
+	if (sector & (sd_zbc_zone_sectors(sdkp) - 1))
+		/* Unaligned request */
+		return BLK_STS_IOERR;
+
+	return BLK_STS_OK;
+}
+
 /**
  * sd_zbc_setup_zone_mgmt_cmnd - Prepare a zone ZBC_OUT command. The operations
  *			can be RESET WRITE POINTER, OPEN, CLOSE or FINISH.
@@ -223,20 +243,14 @@ blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 					 unsigned char op, bool all)
 {
 	struct request *rq = cmd->request;
-	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t block = sectors_to_logical(sdkp->device, sector);
+	blk_status_t ret;
 
-	if (!sd_is_zoned(sdkp))
-		/* Not a zoned device */
-		return BLK_STS_IOERR;
-
-	if (sdkp->device->changed)
-		return BLK_STS_IOERR;
-
-	if (sector & (sd_zbc_zone_sectors(sdkp) - 1))
-		/* Unaligned request */
-		return BLK_STS_IOERR;
+	ret = sd_zbc_cmnd_checks(cmd);
+	if (ret != BLK_STS_OK)
+		return ret;
 
 	cmd->cmd_len = 16;
 	memset(cmd->cmnd, 0, cmd->cmd_len);
-- 
2.24.1

