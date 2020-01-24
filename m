Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 636D9C2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31EB520709
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:16:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CJQa3vaX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbgAXPQM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 10:16:12 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:2542 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgAXPQM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 10:16:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1579878972; x=1611414972;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Cf7qCvpFggOywJ3tT5c78Zm4Qwc+7wyVNFhOAxzznPU=;
  b=CJQa3vaXyY0YzD/oNOjXIqZ6x147OS4aGoiof7+ip4qwTeUs9N18W6Gt
   vOUBOmCCVk+mJOGanK9l/B+g0W+iUxyl5TYPeGS628UY6kIV+IDHjMA2n
   ci4VkaqQoeeeussK82V/o9T5paThBZnDhIEEFQNMczSBpXKLhXJ0lWgPH
   EkDUP9pWHaVL6DkhlkMUO7XOvAtweKSIRLrmVt96EfdHZmewqgqnNUMCr
   +xC0c0dlko+UWboGm8dI6zvAC3xmtlW49bY+2f9FHjBkOxGvxGG1fjS/4
   D6GPCqBrC1rmaOnW0EkYwG/UskHA0Yhr9RdwNcaZb19tlAFA26adbAFv+
   A==;
IronPort-SDR: 3oGqlQpfN28raoBadJJbPuY1EV+6VkFl5iWuFG98kOmZl2bH0hjJfYxh0Cgoi4lmGm8KVZVm8Y
 SzZ1gSOrRJkYUqE1D16PU0hj2jm94VC4t+U1/KwW0ge7afYpg3yDgCbxFEaukSnX6mdikSfUrk
 bXtHtVrUILHtWLpF3H/89eKzd6K8MNu2Xc+p3b8MZ/dkSbcTNq2ldwh5HxcmSPRe4LUi+aLrEF
 TrzzB5lUbdjmj7dy2+sRXnI5MDLqeD1I2o5HOtOCPRrd6NjlHTWGzklwniCPV9QNpWyX0nIuTV
 wM4=
X-IronPort-AV: E=Sophos;i="5.70,358,1574092800"; 
   d="scan'208";a="236229444"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jan 2020 23:16:11 +0800
IronPort-SDR: pgNZTP8Vci99xrISkkJenombazT6DfsWj4Bx3b3EoOr/+goDk825z0D2SQ8M//x5lLyf4axubl
 2WvBnAHsAJ8rA+qIGeehzo8uz2JMjEu++4lbIAY5LE7HuoYZRpbfs9fdGp6o73PyWUvJXPleqT
 SuSaD6ENXtNKUoqVrFyaVh2uxfrhCI3M1syMWh8m+FquK2r1KIIj/yIX/S2r1EnBfFVbkOAgs7
 5q/jVqhLkKoqOhNRz9w2xaHJ0F9jO7sjbHE5RCX/Du63n+NlIGvdOvQ9RKJuvpN829rQI5wFPb
 2ONGjlQHrjyW9+mdnvUSpLUY
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 07:09:32 -0800
IronPort-SDR: MCucNBY9TYfs+bzSNU6W81IaZO4T3dTP6ZCkQSNx0bzsBRTHCbA7x+LE2rULBtvHAOvZ+CBfGt
 Nqu+gEmERUMkwl/I9WEHMHfy286YXcnKsOFO3n7omugbEy7gdyBfLKmQtsbysQudPUqBMg7cw9
 rFIFPAINYBLiTswY/jMF2BDiIPxiVuokAdq2BqMZ9l4NGIkGtftOXzvialFSoSpfPRyuB+LtaN
 zHUh00Ke+bMQCEIjX0L0l5NXHk/3APmV4cYp9JALWykwc5D9CF0LwApORt/NZDFpwmI9qhmfiR
 bFs=
WDCIronportException: Internal
Received: from unknown (HELO redsun60.ssa.fujisawa.hgst.com) ([10.149.66.36])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 Jan 2020 07:16:11 -0800
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] scsi: don't panic host on invalid sgtable count
Date:   Sat, 25 Jan 2020 00:16:07 +0900
Message-Id: <20200124151607.31375-1-johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If we have an invalid number of entries mapped an sg table, there's no
need to panic the host, instead we can spit out a warning in dmesg and
gracefully return an I/O error.

While we're at it fix a trailing whitespace in the comment above.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/scsi_lib.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 3e7a45d0daca..9bddf54e3def 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -992,12 +992,15 @@ static blk_status_t scsi_init_sgtable(struct request *req,
 			SCSI_INLINE_SG_CNT)))
 		return BLK_STS_RESOURCE;
 
-	/* 
+	/*
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
 	count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
-	BUG_ON(count > sdb->table.nents);
+	if (WARN_ON_ONCE(count > sdb->table.nents)) {
+		sg_free_table_chained(&sdb->table, SCSI_INLINE_SG_CNT);
+		return BLK_STS_IOERR;
+	}
 	sdb->table.nents = count;
 	sdb->length = blk_rq_payload_bytes(req);
 	return BLK_STS_OK;
-- 
2.24.1

