Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7A6DC77B7A
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 12:31:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbjFMMby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 08:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240145AbjFMMbw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 08:31:52 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F661720
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jun 2023 05:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686659508; x=1718195508;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=eBOPhrJm/lPZlbTVDzJu2audeIBSeETfQs33qVkZa4k=;
  b=H3LFtrpe/43R3vBDJYPCwgy5lV6IJB/a4XBUfodwgfN1Ump5/dnqHcuA
   Xe4awVQ8fTZVVhSbw/G2n/YLVs8N2775GnM0ev4ZmKg3yeELSaudad1Kx
   Z+zRtkIRSQTJoALC3R0gaQGxIqf/QjoXQ23ryN47Q4EcQVwrKMz2FmCnz
   6jL6xT2wUVhhbpMs4Y5BU/tAAuHcivFRfEyYdD9oZ3lvwwueMoSp+ljBy
   a7tNo9dNhXwCAjvCdAGM1vnxts1/tMHuS3/SFz8+l9oJKIdJS/KQIeqla
   q6xEX3yh7oX55FmrJ6rIDaeCn/rVSyMwPI94c3FSP+AkAXwAWhrGX4OnR
   g==;
X-IronPort-AV: E=Sophos;i="6.00,239,1681142400"; 
   d="scan'208";a="239954588"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2023 20:31:47 +0800
IronPort-SDR: uS3jA6iT96deKPYqob70TyLojQkH9d+37r2d7qB/8/6SViLnAc1N97XWwR8Vihx2nLAopYLLcg
 APGbrO2CbzpPh+vxaMynsIwD6dZL1Pr0YN0i1Qf94E5+s5YOhI4AFA/+yw4ck8qMizjcnCJ67X
 pUyx0cdm7XlpUQ8VPx/tOePrsll5ITX4leN3mS+DHuIMAB0epheo4CZLYtm9RXn/hpAIF3fVD/
 rVL7FySfO8lBoSOuB+1Eq88+f5LAK28GCX+96SxzauS7tJXVG0e3afRFSh1kzW44RNDMeUHnEe
 sPw=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jun 2023 04:46:23 -0700
IronPort-SDR: dAXi/fbVCAbB+KwaW9k4hLjR48e1QwuhOXpceblTEYW/aGGICBLIAJIQFG3x9eIdw0ZBMXlQGt
 OtYzxBGkm4JE2lLXmggYvZN0z6V4CI1CQdmvys17gqOB339W5kcFRCrncBE9QBLHoSlfP6SuEc
 RxiKNH/Onq/oDraN0nLNxnUNKe4DKbveLBABRZATTA3UT83Qg0jH0exNp2B+rSiqZ9gbxGW5qv
 AE85RFIXgIMnozU3QpU8N9pa4Iv4hKo3LGpJWLnsM42VCxul1TRxRjaSFcAHKrGIJa1cBop4DG
 lFQ=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Jun 2023 05:31:47 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
Date:   Tue, 13 Jun 2023 05:31:45 -0700
Subject: [PATCH] scsi: sd_zbc: use PAGE_SECTORS_SHIFT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230613-sd_zbc-page_sectors-v1-1-363460a4413d@wdc.com>
X-B4-Tracking: v=1; b=H4sIALBhiGQC/x2N0QqDMAwAf0XyvEBbnYP9yhiS1lTzsCqJjDHx3
 1f3eBzH7WCswgb3Zgflt5gspYK/NJBmKhOjjJUhuNC63rdo4/CNCVeaeDBO26KGuevD1fl8o9h
 BLSMZY1QqaT7bF9nGeopVOcvnv3s8j+MHzF1fUn4AAAA=
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
X-Mailer: b4 0.12.2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use PAGE_SECTORS_SHIFT instead of open-coding it.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/sd_zbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 22801c24ea19..abbd08933ac7 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -889,7 +889,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	}
 
 	max_append = min_t(u32, logical_to_sectors(sdkp->device, zone_blocks),
-			   q->limits.max_segments << (PAGE_SHIFT - 9));
+			   q->limits.max_segments << PAGE_SECTORS_SHIFT);
 	max_append = min_t(u32, max_append, queue_max_hw_sectors(q));
 
 	blk_queue_max_zone_append_sectors(q, max_append);

---
base-commit: 467e6cc73ef290f0099b1b86cec4f14060984916
change-id: 20230613-sd_zbc-page_sectors-f462501f7ab4

Best regards,
-- 
Johannes Thumshirn <johannes.thumshirn@wdc.com>

