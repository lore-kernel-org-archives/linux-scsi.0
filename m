Return-Path: <SRS0=OYiK=YU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36A7FCA9EAF
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 080DE20679
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:06:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Bx0Sr2iO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfJ0OGV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:06:21 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31361 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfJ0OGV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Oct 2019 10:06:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572185266; x=1603721266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zw9z2raQuJBiKBUSRP4kpCIHnthdBqRSj5UzBl54Qzo=;
  b=Bx0Sr2iOJmk7RrCi+JOd7bosI+7IgGQGA4P91chd1NBT+4z7TFDVkKVo
   Pmtyo8GefKI57QC9J7imBwTcs9CGJsIsEdvTr0+gdoRrsOIWlDJ7zAOnN
   aiwhhedJ0MDcQjA9BNLuZLCaSc9xcQ9lqqksRkUAsaRU4XnX88QtraRrj
   z+rFVLz5znrsxjJa1SORDtC+h+h/BMXDahW5i6vg8fm4EH8APFhMGUyQ/
   GteU/BhK8SGfqpCtDfRBnECl3/oMTkBioaSw1JcS0cooqiOSs8nTs19Gv
   4TsP4Ilu22AzXqRBsz1iP8+KHIRobnVQ/2AYzmxBNm5ZE3LOUWZGwbS1S
   w==;
IronPort-SDR: Um91AUHhOhbBJ0EAP0xnFyy115b29tqYqMdM8DWPeCV85TUdgFU8TeBJW1rBDOAxOapusQv2N8
 WxWzWlwmsaP1qeFae+uzLUdLQfNODF0S4HQ+860vEhC1MH3SYJlfXswMhp+bL23x8mypXU/rdx
 v2YBpZy/MObuVVOrl0FNXfR1T5Jy8yW+77iagruSjf53Eaf2v8lYZy32xcCd7LuFIs/n04885z
 I0ma89geAkOdfvVC02atTxndQPh1O0nVY5bkWaqcDjbgGZY2bkpyS0gjFGNjuV++UZ22aCVIC/
 xFY=
X-IronPort-AV: E=Sophos;i="5.68,236,1569254400"; 
   d="scan'208";a="222578557"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2019 22:07:25 +0800
IronPort-SDR: 71DSbeXtrpxxrFb8Kn/5rCwOAvxQpKgJ4yjHsJ0UFtvFBggBmDoFhZThNjFL+tXkXo4Knku4xb
 SOGpS2RU32Jh8g8SQXkrUqbIuv3G8BagLK9sL7x9peVMJhJbfG4aupDuu28K4FVJrvy1ljikJm
 okVhsLgmCSyFio8/YpBWWaZDOvt+vgXS+pZM1S+WvOda6aW6PAEffuhpjgJaM5kBqhzihiZ6fE
 CkrRh3vUVTpK1RgOCtkyRJVQKL6znJVSMhVH8DE6cMw29H/uMFMmIP21C16tVeyp+YevzS/9jy
 shboSCco6PPVwEc/3BJL9Eqk
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 07:01:30 -0700
IronPort-SDR: zsGaibo1ct/ZMz0zQXZesnRk7H+7gE+bmgCZApkHVlYevcV1Tj2tEfX4GZWHh4cHMc+lsEGY15
 1JeVUeUxd6loyv6BRrQCQeD7KfeJPKYfOa51yRBlnM0AjUg/I/XmlXWdtglPlwwiE5G+8MeCv/
 i4Nq0R2+bmrCWrtZP1jHkuLL7HYDrJeabtnPfmel/ZHXPWsOPowTQnyTUeOcJfrlocDneS2fcP
 niK5oQ6QT5CvPknM1cPDuGGq5pl4msjHPlYBX1D4TUTwmPr5pO0+ertG6KTqbhDP/IQis9GTNA
 mMU=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Oct 2019 07:06:05 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ajay Joshi <ajay.joshi@wdc.com>,
        Matias Bjorling <matias.bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH 8/8] null_blk: add zone open, close, and finish support
Date:   Sun, 27 Oct 2019 23:05:49 +0900
Message-Id: <20191027140549.26272-9-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191027140549.26272-1-damien.lemoal@wdc.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ajay Joshi <ajay.joshi@wdc.com>

Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH
support to allow explicit control of zone states.

Contains contributions from Matias Bjorling, Hans Holmberg,
Keith Busch and Damien Le Moal.

Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
Signed-off-by: Matias Bjorling <matias.bjorling@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/block/null_blk_zoned.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 4e56b17ed3ef..02f41a3bc4cb 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -136,13 +136,14 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 	return BLK_STS_OK;
 }
 
-static blk_status_t null_zone_reset(struct nullb_cmd *cmd, sector_t sector)
+static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
+				   sector_t sector)
 {
 	struct nullb_device *dev = cmd->nq->dev;
 	struct blk_zone *zone = &dev->zones[null_zone_no(dev, sector)];
 	size_t i;
 
-	switch (req_op(cmd->rq)) {
+	switch (op) {
 	case REQ_OP_ZONE_RESET_ALL:
 		for (i = 0; i < dev->nr_zones; i++) {
 			if (zone[i].type == BLK_ZONE_TYPE_CONVENTIONAL)
@@ -158,6 +159,29 @@ static blk_status_t null_zone_reset(struct nullb_cmd *cmd, sector_t sector)
 		zone->cond = BLK_ZONE_COND_EMPTY;
 		zone->wp = zone->start;
 		break;
+	case REQ_OP_ZONE_OPEN:
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+			return BLK_STS_IOERR;
+		if (zone->cond == BLK_ZONE_COND_FULL)
+			return BLK_STS_IOERR;
+
+		zone->cond = BLK_ZONE_COND_EXP_OPEN;
+		break;
+	case REQ_OP_ZONE_CLOSE:
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+			return BLK_STS_IOERR;
+		if (zone->cond == BLK_ZONE_COND_FULL)
+			return BLK_STS_IOERR;
+
+		zone->cond = BLK_ZONE_COND_CLOSED;
+		break;
+	case REQ_OP_ZONE_FINISH:
+		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+			return BLK_STS_IOERR;
+
+		zone->cond = BLK_ZONE_COND_FULL;
+		zone->wp = zone->start + zone->len;
+		break;
 	default:
 		return BLK_STS_NOTSUPP;
 	}
@@ -172,7 +196,10 @@ blk_status_t null_handle_zoned(struct nullb_cmd *cmd, enum req_opf op,
 		return null_zone_write(cmd, sector, nr_sectors);
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_RESET_ALL:
-		return null_zone_reset(cmd, sector);
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
+		return null_zone_mgmt(cmd, op, sector);
 	default:
 		return BLK_STS_OK;
 	}
-- 
2.21.0

