Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A04C74A5B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjCIV6O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjCIV5e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:57:34 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD301F603A;
        Thu,  9 Mar 2023 13:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398970; x=1709934970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1JaAwgGHLI4jFdeVVjtrT7wVpPnCMuROX+o5Q7kJxUg=;
  b=HlrPeUxPynR0yBXApa3zLNxfJ3NI+3bxATc1ue0/nF4B9IXIB7aRGt3A
   MkQJ+cBut3wg2YkUEm8PpJJvybpBe60tCxryf+9u5OWG/qm4lF8OkUTLj
   zYyFjpw1fWW6B0Q4PLz/ZkkrP/RmyHPhwlPhkN+SykisTkQAOtiR7XmDd
   rUk/QcVCIXfvEZf1C5vIlyKEgLZJDnIOpguA2kQ61DjndlQA3GfzfmStQ
   gxlEHWHEBcKJU+I+dSf6ppxTepSUEyDsDJxIgZRSDAsUrKhdp7MAPZF/U
   Ae+Ry2hZmwACWA63ZFwIsM7Rg4wvqCH5hjndWjuni4rDYoz7ySEc05I69
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225271044"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:56:10 +0800
IronPort-SDR: 2TV7/rJzXf/l7wckOIZs1ayX2kEm7UxMtt9r0TsXHzkUpsdSFGFs1oVyqqlFFCg3GV+qxWB8UX
 YgIxsU8rAOgvZ7hmoO5vYuuf1wz1N1BhRUDDMyIVHDyGwwmPjs4GBOXPpu+XYgxmIQms947ZE3
 S9ZMacnsvZE7KZ6Y2g34fJYEJ3kMnByS/G1ItPC57NGfkp9iDuhbBBmRgUOkklezQPkJR3LR3T
 rzXwMp3Piusm24qXjsL/IXfEU4m/104pRrGDMxe1skTYAQ7j2Dr720LT2nQEL9JhrhsyBYifVs
 SJ0=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:07:03 -0800
IronPort-SDR: 2oDoqb8Ww4HORQAlCzd3l/1Bl2x4R2YCHQ1LK6zyHCM/uYkXfvcu27epRViPJNuUdJ7zWPzUiU
 +zMkagppYgqJqhP0dDzb8ZSD47UcVbENrMeECrMTFc0a3+IdGH7UuN1hKDA31ERKS/mbBLk81c
 HFwnIy1pnhQGLILS7aJ03RGF/T6kMXS7gHqtFwVpb+D0rmqFqra1vF6b+T4c9jWB4sN2vOnfOv
 kGCqN4ii82LnRXIQFtWVh0rKQkG6pgUb1IimvywBhfS+pdWeNIP9gUgNSqnH5rXJNoPBlpNYMf
 C2Q=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:56:09 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 15/19] ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
Date:   Thu,  9 Mar 2023 22:55:07 +0100
Message-Id: <20230309215516.3800571-16-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

For a scsi MAINTENANCE_IN/MI_REPORT_SUPPORTED_OPERATION_CODES operation,
add the translation of the rwcdlp and cdlp bits for the READ16 and
WRITE16 commands. If the ATA device does not support command duration
limits, these bits are always 0. If the ATA device supports command
duration limits, the rwcdlp bit is set to 1 for READ16 and WRITE16 and
the cdlp bits are set to 0x1 for READ16 and 0x2 for WRITE16. These
correspond to the T2A mode page containing the read descriptors and
to the T2B mode page containing the write descriptors, as defined in
SAT-5.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 716c33af999c..2a0a04c9e658 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3235,7 +3235,7 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 {
 	struct ata_device *dev = args->dev;
 	u8 *cdb = args->cmd->cmnd;
-	u8 supported = 0;
+	u8 supported = 0, cdlp = 0, rwcdlp = 0;
 	unsigned int err = 0;
 
 	if (cdb[2] != 1 && cdb[2] != 3) {
@@ -3262,10 +3262,8 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 	case MAINTENANCE_IN:
 	case READ_6:
 	case READ_10:
-	case READ_16:
 	case WRITE_6:
 	case WRITE_10:
-	case WRITE_16:
 	case ATA_12:
 	case ATA_16:
 	case VERIFY:
@@ -3275,6 +3273,28 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 	case START_STOP:
 		supported = 3;
 		break;
+	case READ_16:
+		supported = 3;
+		if (dev->flags & ATA_DFLAG_CDL) {
+			/*
+			 * CDL read descriptors map to the T2A page, that is,
+			 * rwcdlp = 0x01 and cdlp = 0x01
+			 */
+			rwcdlp = 0x01;
+			cdlp = 0x01 << 3;
+		}
+		break;
+	case WRITE_16:
+		supported = 3;
+		if (dev->flags & ATA_DFLAG_CDL) {
+			/*
+			 * CDL write descriptors map to the T2B page, that is,
+			 * rwcdlp = 0x01 and cdlp = 0x02
+			 */
+			rwcdlp = 0x01;
+			cdlp = 0x02 << 3;
+		}
+		break;
 	case ZBC_IN:
 	case ZBC_OUT:
 		if (ata_id_zoned_cap(dev->id) ||
@@ -3290,7 +3310,9 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 		break;
 	}
 out:
-	rbuf[1] = supported; /* supported */
+	/* One command format */
+	rbuf[0] = rwcdlp;
+	rbuf[1] = cdlp | supported;
 	return err;
 }
 
-- 
2.39.2

