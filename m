Return-Path: <SRS0=OYiK=YU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF500CA9EBC
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8582B21726
	for <linux-scsi@archiver.kernel.org>; Sun, 27 Oct 2019 14:06:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TDp+0f7e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfJ0OGF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Oct 2019 10:06:05 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:11568 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfJ0OGF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Oct 2019 10:06:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572185242; x=1603721242;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TLqEky6w+vX+YkKEOL1ISQHtwn9kaFjzjWIu8MoRAiA=;
  b=TDp+0f7eOphiyplFTxbWO1tC6zUAEL83MWaAuDeOaeGdsVNiBQMsMMsv
   TsuZdWMeFY96Dq5CUQWXvElVloybGicmFPdkK3AGM16IDv7ILguJpsDgP
   tGHPwtJeqJZ359AGzehpHZE53gAzXTGNWRox3ygjivtIqn3KUCYqvatZZ
   cWtNrdUTDzWlZ2X4UcmuiUpgjJ59l0An96IrNkWcOLhHN89sfrMABgLfz
   rDXZae1rWIbUaXyK1XR5HGSuSuG5u/jqHB3LNFJDoI3ySyC7MWXnJwgFk
   UGmH2A9j116perxnzJboR0NYTDIVtWu9Y2IKYRaf5fBb6acCiZbOkR+xm
   g==;
IronPort-SDR: W/qMN9bXO3UbfMdTHeTdUH1ckiy2myLZBGO+Ge/jzkeBLna/WCLrzISK8fn+OvxUD+2EXDgS13
 YlKOj3xzbVIxrADjjrHl/v4iqrnfjz/olDa50ZQQO84banPhxHxiZIWVtxYAVWiG3jS4Ui3Ae2
 +NIO2WdxhiDpmg0u1TKqjb1S0+P6FpJZawRzEdAOvsZ+Ku5HMRntDd3a+zcFDAD0Aw+s2UZNn2
 y5Jl0JjfIsFy4AO3YjMQjhvNia/YIro8ieHyqC21KPV1PBhaTPKiyAVnaAcG4emlX9rqN/nCXI
 l1M=
X-IronPort-AV: E=Sophos;i="5.68,236,1569254400"; 
   d="scan'208";a="222578555"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2019 22:07:22 +0800
IronPort-SDR: ztWVZ1VRTI/fqUpKhau3uvQMr4ToZya76VH9b/QmhTUsnWfa0wL93SGJNZa+J20Kp/+IPL3Doq
 ODScm9nDLdqPqUp+Za4zC6dd8U9zPAuRu2e/COBgOpj8Hb3v5Uitr0LOVGsKIk6pEahSsvaMm7
 yJ88cLr2Q+0wfS+a/WHoGronBOUOcQD52NwbR4bgAcEdOF/f2es2YMJo9klwRS9uPv/ktW90q+
 rB1cXM02Lziwm6IMbErDb9e7+twIShGE2k1HVH6sygCxPGlKsx4xQ8JQV8hUe5Bq4bFyC5g0C4
 cWNQAEcB1cWsRhii1XrwfkI7
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 07:01:29 -0700
IronPort-SDR: YCvuQJ0KJZaaS7VQV7JrO6VOOK0XqmnAIZPpCjeCB1f3SBrHammem3xiraVvye+soPyS3Vjrf7
 XN2wVgcC8yqf7tcL0QK4A/otP4oX8f2Z4zgkj6bSrOMrECzAuRmL2oyKxm0OqTi5qIsfQ1kh/J
 LlzV1e1saprX7eW6oaPjzGzu7b1XWQ8cl6UXUHPl+O9D2d+2FDJHkRyboTg+nNbV9z8IgNA+j3
 A/AhfbyfHkwZGJrpmtd8vpMOJenchm46j4hGLs6bS+cowRC3jbWmXrBTTStumGKnDKKt/WFjvM
 Vjs=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Oct 2019 07:06:03 -0700
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
Subject: [PATCH 7/8] dm: add zone open, close and finish support
Date:   Sun, 27 Oct 2019 23:05:48 +0900
Message-Id: <20191027140549.26272-8-damien.lemoal@wdc.com>
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

Contains contributions from Matias Bjorling, Hans Holmberg and
Damien Le Moal.

Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
Signed-off-by: Matias Bjorling <matias.bjorling@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-flakey.c | 7 +++----
 drivers/md/dm-linear.c | 2 +-
 drivers/md/dm.c        | 5 +++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 2900fbde89b3..76587e9af0ef 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -280,7 +280,7 @@ static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
 	struct flakey_c *fc = ti->private;
 
 	bio_set_dev(bio, fc->dev->bdev);
-	if (bio_sectors(bio) || bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio)))
 		bio->bi_iter.bi_sector =
 			flakey_map_sector(ti, bio->bi_iter.bi_sector);
 }
@@ -322,8 +322,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 	pb->bio_submitted = false;
 
-	/* Do not fail reset zone */
-	if (bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (op_is_zone_mgmt(bio_op(bio)))
 		goto map_bio;
 
 	/* Are we alive ? */
@@ -384,7 +383,7 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 	struct flakey_c *fc = ti->private;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 
-	if (bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (op_is_zone_mgmt(bio_op(bio)))
 		return DM_ENDIO_DONE;
 
 	if (!*error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index ecefe6703736..97acafd48c85 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -90,7 +90,7 @@ static void linear_map_bio(struct dm_target *ti, struct bio *bio)
 	struct linear_c *lc = ti->private;
 
 	bio_set_dev(bio, lc->dev->bdev);
-	if (bio_sectors(bio) || bio_op(bio) == REQ_OP_ZONE_RESET)
+	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio)))
 		bio->bi_iter.bi_sector =
 			linear_map_sector(ti, bio->bi_iter.bi_sector);
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1a5e328c443a..bc143c1b2333 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1174,7 +1174,8 @@ static size_t dm_dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff,
 
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
- * allowed for all bio types except REQ_PREFLUSH and REQ_OP_ZONE_RESET.
+ * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_RESET,
+ * REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH.
  *
  * dm_accept_partial_bio informs the dm that the target only wants to process
  * additional n_sectors sectors of the bio and the rest of the data should be
@@ -1627,7 +1628,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 		ci.sector_count = 0;
 		error = __send_empty_flush(&ci);
 		/* dec_pending submits any data associated with flush */
-	} else if (bio_op(bio) == REQ_OP_ZONE_RESET) {
+	} else if (op_is_zone_mgmt(bio_op(bio))) {
 		ci.bio = bio;
 		ci.sector_count = 0;
 		error = __split_and_process_non_flush(&ci);
-- 
2.21.0

