Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC6DC18E5B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52AC224681
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 09:47:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eBEJA2/r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgCJJr2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 05:47:28 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26539 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgCJJr1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 05:47:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1583833656; x=1615369656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cLV6+K2Lm6YoCZPJOQV3jBgYk32R+A7ByUqqPEc0XBc=;
  b=eBEJA2/rANbvdLwXfX1Lbn6jfLEfqFVzpbs7Zk5PuLnHzDH685ReFDba
   skPPDCgETIaHP5gsJGPZzWYCmCr2wxt4eKbuXcpjwdpFkKRMiCJrVrmQz
   1xvQPdflZGX7ckUaEzzwhftqxIXJNc56adhWBtDgickaK+/qOHq76e66K
   fCWW4JWY4qcq12oIX5MnJZPa8XhZC7bz7zomR4fYKqoTIr6i6wMZtAO1J
   3UvYml4Tu5XAJBdh1jsp/cB6GDv2P0WHSLeY4GLUOlh4x2OdyXSr86UHW
   sL+yhU05AVVE2AS5Q5dnvj+kwmZ8Dx/mtPdV39DxstnuFAMGwIejQ3MX6
   g==;
IronPort-SDR: Q8mW4vr6Pg5EBeisGanxfG3TyMHxMztrH6V9Cl1L8aUSuMsh9KJ79hFCF1AM2Cn73mJClx04DR
 79unEL/t9nhlg5La4xDV/TfixNvXyjSdSOkGmmUBKY0tr2FJV6QNTiZ4xubvSrcPlJPJyrHAV7
 C3nRwlFUED8d2hYyGdHgK3B8YVR8RprvcEwj5X5NW+DR6/6VjH+qlhGqYk+uNHIe40XBAoxFhJ
 CDrqq/FWUIy1kJiDSA73IcVgJuDb7WAY7zMFO+kBR/3DJPEuBP8s7tC/8eQxjcwp7Zh+SK8x3a
 rhs=
X-IronPort-AV: E=Sophos;i="5.70,536,1574092800"; 
   d="scan'208";a="234082810"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2020 17:47:36 +0800
IronPort-SDR: PDqSd1mx8rAc/6jsvVtOSVSZpoiQic87veo9RUg1gyUbnTledBFZAPVs33e/a3m+UhleXGYmFn
 CbIW26Uo3WXqrM5zKyxBHulhXxo+dfMDSfWJdy80sUEzXGpENp/0DXA8zd8rJFZhKSJHC/gs2O
 tZU3r2zXyhYa08+fC3483zLVPzQudmCcyDq7MI4JmsObUV1BU4Ezdnflqf4mVMQKbvDygO2krq
 R/qlBQEJw/QPhhkhYONvaKb//t0YOZqLFMkRuBcLP5beW6xpoOsEiDCXd7/RhiXU2mauxbDBF7
 KfMXXCy9Jw1NnXAMmAbFh9OZ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 02:39:07 -0700
IronPort-SDR: VgaJXqfpAwlXXEMQZ1/FQYlYIvlUcnjjfnqt+ftXigX2Gt9mAecTJ27MP9oZfUFm0/qcEfFl3a
 XjMG63fwXAkQPzFf80QjBJoElHc3m0Mnszith2uldbGHa+0Z2YIpA0Rblel6iEfmniM1f/EwIH
 F+oeWOjOQivoNmM1zZZ7f7hB32fV3f5na76AjsRfQlULPtTV/lMNC/UAhiqpOHD7yQbV4crOdW
 kPNUy62oY3LOyEfFps+uexN6sOzeohXWEAva0qIEKNnvVfsaR9kLRHe9A1TzQQMHuLB1ONLJML
 VoE=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Mar 2020 02:47:26 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 10/11] scsi: sd_zbc: factor out sanity checks for zoned commands
Date:   Tue, 10 Mar 2020 18:46:52 +0900
Message-Id: <20200310094653.33257-11-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
References: <20200310094653.33257-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Factor sanity checks for zoned commands from sd_zbc_setup_zone_mgmt_cmnd().

This will help with the introduction of an emulated ZONE_APPEND command.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/sd_zbc.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index e4282bce5834..5b925f52d1ce 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -204,6 +204,26 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
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
@@ -218,20 +238,14 @@ blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
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

