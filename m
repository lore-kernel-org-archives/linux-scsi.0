Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C01C6371D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiLHLD4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiLHLDC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:03:02 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0645860B7B;
        Thu,  8 Dec 2022 03:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497283; x=1702033283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CbISjLppXxJda0wbpgKO8tx1bXq4PqnF3kqkJG4azWc=;
  b=GLvW+VZd2RNNa0lzjyEYrqUF0ZV3Sp2SVquggcfs9plz7gIh5+AW7npy
   QWov9t86Gcy4Ubk5jhIWhxsbVAH5cqDIK/0hSf60PNlWNolXiSHtdlPkY
   3Yutzm8SLE3TJ+KzCdVhxFqre0L99y5Pn96LmqQ2UjHQ6QbgaXurseqbh
   2kELsDB4x4tWrUL3/xWPUpk/O72lfx/qNRTUn8QjL/FK5LQ1lJfjLdmHR
   LkTvdGoUQCJMKSfkbiMKoZOtICYDAZB8tQVz/QnCDMYqtVQ4E5TPXTb2d
   T8pcfKFWr7EZGz54EUf6zy/sOH0mfSeIaS5HwUPzBGwnhzaYyLPhCPk+u
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333408"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:23 +0800
IronPort-SDR: T97g4hz6isM4/FplK7XbgZfZ2If208TeqDLtqv4kSXG+efcHMqIZTu54cnZgdHshWyZwoPDqgH
 1SLUdJ72/kFI0/3T5Sr03pWvXoMvBKKNtv8jpI6lCHd8aqEeAACJ3XEXBCxP2h98YViVgtXHWq
 NPEVfNyzwchXEMR+czGRucvsQpHXVHsbtsEo81piFqFtm7vjgnL4nwgXvX78Pnj+6rKFopri+I
 jp6RSZVrRF5qUHfR6XBmkqMYYe2CMqh/xbFjmPcaHw3QMgKJcs1bFo4bj1cBZziOXd2HTJvgoq
 D5U=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:14:08 -0800
IronPort-SDR: rAMMAhhop+EpmbOCz0KVGWHPIBrbVRVs5S9wV3sxQnq4zHeXZXapNTqZAD1q5ZsEl5KN9oVntM
 zkClnKxNxptVXjGjZ6aYscQV0zh54zms7c035Js0sDgH7a9qjWcsj60bk5klFjDr4GLXrJ0sun
 CLiEO5WGB4C62ev8rr+N6UNvjv2fU/pYISgwo/AOVxEHiBnDj0kgkgX/lhp0qWROiCsXeOU6mQ
 wuRlktVUVA3asZlUe9iuTNCaWPLFG2ihOgpmjh1FFaslO/9gSN4EBLZeDrFTW6/E8Z2sXlop8a
 HNk=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:22 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [PATCH 17/25] ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
Date:   Thu,  8 Dec 2022 11:59:33 +0100
Message-Id: <20221208105947.2399894-18-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
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
---
 drivers/ata/libata-scsi.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 042c1748815a..2500f3ff24a5 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3264,7 +3264,7 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 {
 	struct ata_device *dev = args->dev;
 	u8 *cdb = args->cmd->cmnd;
-	u8 supported = 0;
+	u8 supported = 0, cdlp = 0, rwcdlp = 0;
 	unsigned int err = 0;
 
 	if (cdb[2] != 1 && cdb[2] != 3) {
@@ -3291,10 +3291,8 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
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
@@ -3304,6 +3302,28 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
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
@@ -3319,7 +3339,9 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
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
2.38.1

