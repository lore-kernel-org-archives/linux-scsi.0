Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33B0C6FA8E
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Mar 2023 01:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjCCBo2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 20:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCCBo1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 20:44:27 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E13168A7
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 17:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677807865; x=1709343865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HAefUkDuVgRdKkrPrb7HAOFuTUYftgnEWH6FMuC3SSI=;
  b=ftz+sIfSSd90/V3KxT6euYVOc0ytfV/lK8uVfXp5d08FO59bp2Onnmlt
   hr5TfaYwTx+nwJ/KV5QiP+QwTcp7QlcJpxOK4H0cEFYFUOUV7GAXmJhQ3
   0cCMrMZ32LDJ4QMEef+lHHjVeIfRXNPXrYQHfu/q8epVfXbQYmTmpKNKa
   /K6zDahqyi39T7bQFyQPb+ca9OK13GqST+0Rebd6B3kM+CqB/gHX0PkWp
   yPltwZ7ynzhk8Anz5usSjG//Tj7coRaR4BKPYrDt2HBgR54c95uBOT/w9
   Qz+aPVm4wBX6zXubkQKJZ96NkEn4kUsQBHITlyz/XENIjr0shidz6VvTt
   g==;
X-IronPort-AV: E=Sophos;i="5.98,229,1673884800"; 
   d="scan'208";a="229650327"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2023 09:44:25 +0800
IronPort-SDR: 6/g86smksvlmAS9oxem+wWZ8d0vjFJuAPieu8wdENWw1Ooxn552Y1McbEFpd1sak00vhDNck+q
 lQdb0LXZ7ZYwKmtBTBhMRP3zGv3h4QbrPb/YOh/HlWBH7QODpYllUKyH7pntGLeM0siVasvNP0
 VRT2ViPnf/tEocS2QfgOxz35PHdxMPt241I2XgbefjLHPy0TYiaQT3VbCWekRPcRXg8YN/kzUB
 yxZaa8uyW3haYuIfNZBEtKPZYTao2cfdp+10IlOdntD4tYKk3LsdA5IVzfsE5FkcR6AMZ2QHne
 FqY=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2023 17:01:13 -0800
IronPort-SDR: TzKT/v3x7uqbgybEKRFqnM/4URKkipB+G7R6VpmDFSmFjgdmqmybvO9gYyqEO8Pa63ZgAZo7bQ
 im7oPp4NuH7pKOxB+B2evy3NEcV7KCT3xV9smV1SbQPJEtOH4kGD18h7HYHX8rKwD3rs4Rcc3H
 j4OQTqJwdmeRavoO7orbM3X/QURL8XT2AM8AbCuqfFm6ugOiWyKz4Y2yxyn9K9aSbkaB9cxHms
 NgUV/MtXr8igiG2j9TMjkLmtDbZEp9knBpNr8l0cuwQkpv7ZxigXlO1CXbNSPxCN7vhZNd806h
 NG0=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2023 17:44:25 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/2] scsi: sd: Check physical sector alignment of sequential zone writes
Date:   Fri,  3 Mar 2023 10:44:21 +0900
Message-Id: <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
References: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When host-managed SMR disks have different physical sector size and
logical sector size, writes to conventional zones should be aligned to
the logical sector size. On the other hand, ZBC/ZAC requires that writes
to sequential write required zones shall be aligned to the physical
sector size. Otherwise, the disks return the unaligned write command
error. However, this error is common with other failure reasons. The
error is also reported when the write start sector is not at the write
pointer, or the write end sector is not in the same zone.

To clarify the write failure cause is the physical sector alignment,
confirm before issuing write commands that the writes to sequential
write required zones are aligned to the physical sector size. If not,
print a relevant error message. This makes failure analysis easier, and
also avoids error handling in low level drivers.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/sd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 47dafe6b8a66..6d115b2fa99a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1123,6 +1123,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	sector_t lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	sector_t threshold;
 	unsigned int nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
+	unsigned int pb_sectors = sdkp->physical_block_size >> SECTOR_SHIFT;
 	unsigned int mask = logical_to_sectors(sdp, 1) - 1;
 	bool write = rq_data_dir(rq) == WRITE;
 	unsigned char protect, fua;
@@ -1145,6 +1146,15 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 		goto fail;
 	}
 
+	if (sdkp->device->type == TYPE_ZBC && blk_rq_zone_is_seq(rq) &&
+	    (req_op(rq) == REQ_OP_WRITE || req_op(rq) == REQ_OP_ZONE_APPEND) &&
+	    (!IS_ALIGNED(blk_rq_pos(rq), pb_sectors) ||
+	     !IS_ALIGNED(blk_rq_sectors(rq), pb_sectors))) {
+		scmd_printk(KERN_ERR, cmd,
+			    "Sequential write request not aligned to the physical block size\n");
+		goto fail;
+	}
+
 	if ((blk_rq_pos(rq) & mask) || (blk_rq_sectors(rq) & mask)) {
 		scmd_printk(KERN_ERR, cmd, "request not aligned to the logical block size\n");
 		goto fail;
-- 
2.38.1

