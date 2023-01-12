Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79DA1C67871
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 14:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbjALOJe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 09:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbjALOId (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 09:08:33 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F011E51333;
        Thu, 12 Jan 2023 06:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673532295; x=1705068295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5t4qxzc/zrv3C8pNJB5KvGBTE/TWY/w17sZhvF/MQAs=;
  b=IEIqDOCwvSdFJ3ZkYpiAKEW/yXf0TUv32HdO8nKu8VkYy+X1dI80K0WD
   0YumjKZ2Iyu5zJrKhwmbXuuN4fm4q3r5VungbTpTsJFS7hGIrn1wpUWEh
   YJh9vaTK5Ws+jCMqso1oh0hR/7gCzKQRJ3OoYG6iZIPmwyZAYED/S99ds
   vqc4QZcE1wy2H+OpmicieE0mdU9+3vjANCpgqjI6MhdIwEb2K97+FXZ75
   LDOfj/D103zHnOgk9HUTxi6oVAqQLqFoc5fzQIlTeGsAHPfgGUilJZJqv
   8mrbukcCtlLP3e8TSfiSIBDxoT88iHI4qNoaNDAd7mnL3Y9a1qlqPOwF7
   A==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669046400"; 
   d="scan'208";a="332632708"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jan 2023 22:04:47 +0800
IronPort-SDR: 9hXgCHhF94OxeqjT3XlzQQeoJd4/nWOODRm16P6qyKDrfUnPe9dTVJrRAqSxwZ/fUUp9CvgzjR
 unOCBPz5aB6cS7c9JJ7gTeM/lcv5VqG164kVUCSH8kSMHTU3VTCJflmzgupeEMAFzgnvwKVzEv
 0rq7wUUd/4vYh2K9ydUwOQbXuG7mxVcGup+wRPZ7jmtjdk84YQPgqoySEiU90/w4KLlhJDwlcl
 LUA/OyMJ+mMQzMzHvqy26AQoI2J9fGOcYHKRez9n5Z6eXMXKh2nr8zfCS4hECsVrhtSbNiy3aP
 Lcg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jan 2023 05:16:50 -0800
IronPort-SDR: Sm3ze1XWmoOBEkEfw6oKuqyfwvaB59GArBW9ulz/LdirLH+I8L4ZZNLGWvKDejs6+wD1lDH3XG
 IPVvjeoeyJ1ogMiQElHyyn7XTm1PWhtqiYX2qKsxSMpsUglJoonFtyEofxW2XvwExKIpiZ3wNj
 4K+FWfD0cvsqUli4ku06duUpNCb8jSGGDcCL7m0dt3vcplvg8WXccJVZyfX6yLth8MMRsG4U6y
 II19dxRvkCNm8UDF3+d62DdsNbd6dWFUOX0sqXShKaMK8FTvGei0YWcHazxKn4wovHmL8Vuwd+
 zHk=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.12])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Jan 2023 06:04:46 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v2 10/18] ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
Date:   Thu, 12 Jan 2023 15:03:59 +0100
Message-Id: <20230112140412.667308-11-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112140412.667308-1-niklas.cassel@wdc.com>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
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
index c64bd3095ea6..b0a6778e852f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3238,7 +3238,7 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 {
 	struct ata_device *dev = args->dev;
 	u8 *cdb = args->cmd->cmnd;
-	u8 supported = 0;
+	u8 supported = 0, cdlp = 0, rwcdlp = 0;
 	unsigned int err = 0;
 
 	if (cdb[2] != 1 && cdb[2] != 3) {
@@ -3265,10 +3265,8 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
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
@@ -3278,6 +3276,28 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
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
@@ -3293,7 +3313,9 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
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
2.39.0

