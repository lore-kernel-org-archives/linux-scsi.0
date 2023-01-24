Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3CF8C54E94
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjAXTEu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbjAXTD7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:03:59 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ADD4F344;
        Tue, 24 Jan 2023 11:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674587037; x=1706123037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2sRoI7igCq6tyeL8Xu4jn4gnzdhs69h2QV+ki1N1wq4=;
  b=cmwmvaKN0OyGmKhMiqgwCe3nt0XadEGlTlhJBmMqNaeJciytPe+jnUmS
   fkxI+sqQyH/968FbsbGt85XMGo5FgnUBxstF2npfCTbIGElNhB/x3a1/F
   KhnXfZaik7Vx8lim9jplNDgyUCO3G6mMeR8pxSVfnXWDILk4iHorxZGIB
   LDEd6Y/krDLgdnKGKRISz3ggKsMaFFbwHZNg4V1ZA+3wqHipsb4P6BY2B
   9WdeK7KuOqUDHyxp8eFg4IDf78Us0BcXsbkutrQ7b5U5g5EoPQVYNTkQA
   jIVM4KFdicPHFDRPPqGJHuUPoSmziiUqxXg4gZ8HroIdXBEoeQ/iAq3rg
   g==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221472975"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 03:03:57 +0800
IronPort-SDR: UfcgIlt8rmdQeAb9EV+CIABQDahEz4/A6JyiLniaU5yp1J0q1oRsMlUW+CFRqikqiNpznUDEga
 sZUAK0SLLsgHJZcwT22AznSzU9i1Q5KuDtXT1I6OseGTwDoPM6OEkbCsvM5COz/mql79cZ58gq
 H2MQ68FnaNB82OpRIlP6U8+Wlh0lemGpON9WPmI3kpYPVj3zDIYS9Qv7sW1a3OQuswvrL4N8Qq
 N9yV7rchloHCXQnnyYLbzTP0765xJNv8vCuj5NgoRjZIBtwdaMLqvtkb5D7+BB+DTD+60JCWdh
 fmo=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 10:15:45 -0800
IronPort-SDR: HWKfTWct6OeRFRk1MbcavBXo5idrii9QPPxkEwImhN7gsRSUuWlkkEL2h1hmXl7+3MNSHzUm5s
 MBKsdK1yaGtX6fPBZXrHkZ9joKmv2+TMmOadzVKSroXcvpWZLgPi0jK5JMvQ8r53OQhCc4jPRX
 WRUqTXs8ZY97E6dOAwHkBUW2Vsp08bkC/UiTZZcQmFGQhyLhuh7N8HYM8vTZnuLETUUtUpTKYx
 62t27QHtRod/EkrBy8PFyyjHdX8Oh+z4Eg5odMfFNXWU8aF0rEgZg+WvGR6QttQW+DSe5GGPwa
 sSM=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jan 2023 11:03:55 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 13/18] ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
Date:   Tue, 24 Jan 2023 20:02:59 +0100
Message-Id: <20230124190308.127318-14-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124190308.127318-1-niklas.cassel@wdc.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
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
2.39.1

