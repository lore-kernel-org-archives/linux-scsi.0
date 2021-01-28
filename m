Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74915C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3702364DDA
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhA1Etu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:49:50 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22074 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhA1Etr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:49:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611809386; x=1643345386;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SWCTJmRNv2T9JpmyPX37nbAkKPtO6xgSUCxz+iuTR/w=;
  b=cpFV+sXoR/xZsMmRj0y57S4v1eNDAODe+Ws4TiRBPW+/moBLYmPSF7e4
   iZh67hdaNLXToZqxUlhU+VXD36devnkSjQtwC7bIyrPUwoXuhyrI5a5KP
   9VepGgvG6Qet+EgFoWT+jP8XKgh7ty+be2VXW4W0sWkUxBqsPuYv/i+s2
   zXLD18QCUzEi+I8Rrp9eWSc0p3sUEOBjn+64DZ4yqybFpdlsfB+cfzC/F
   dEYATSdu6Ct2SVznVx+5X/Lq96XNIt2nSm0fzhyIV/FQli8n404ILLSe8
   Ku4NDt7u/ncJSDAjP8gxk4M0Ci1En2Muy3SXNuN1v21yX+48O+4YwUvTO
   g==;
IronPort-SDR: PC3YyB4lebHhlOWeDomrMqGD+e9IerrVSReJE8AlRwSpPOHYcnBXMEXaDIl5P0EKzautL78XSC
 oKHYb9Z+bLliaw7EMWr9qvDv9uGjSV7dobj0/S6dK8QrP5i8AQTJFe5OgEhj2l3AY5ZtIFEs55
 s7qOw9bdgMqW3y+qZWvNN93Mfrhsp/wA+UBZqAyQC31Eoo1Ay1434eeFQHyoqeWeJvzCEXlsK7
 I1txpglZWRpdCjvHro+Ok32McvLsHpBiCnlrmtC7P97+MYOr+N6eJb5eBcl1x0CQ6se94P3zLD
 65E=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="158509129"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 12:47:39 +0800
IronPort-SDR: o7ob7SaI97tiVu2bvpAZSixXYeeTBv7HLDTN5w1p2hBMJhV1NC6tD/l4dzS7lwyxkM1VHNnX5p
 h2kVp229QUHG7RhRibc99ez5hvSO1gUzTJWS1ifh+ZgZ4bNn+32srKCANu15spiicxE2B9ES0S
 iZa8Iaal7gMTfjbOid05ZZa35//gFhKoaHYnFsoZULXre+Y+Zp68R198+0iiKxEat9RQljhW4n
 /zHjNQPit5kddN0wxR5SQquOgmp/TY7nsU0mjq++ZOHnp3PlvN19LR5yA8RsRS1a1INK+THRxO
 ASmrrWiYzqxvI/3IQJv8/8wH
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 20:29:57 -0800
IronPort-SDR: jBNmDaXDVx8v8RZcXtnMGGqEm3shQx0PxDNLaX1rzbyNbnPEVu1t9X34NLlWClP6rF9ErVcQ0I
 RtgqajKMuXA2X2Pvk5cZESe2jSoGcHmD/P53lB4UCwpXkvhmkjIgH3V+EBlA8foqgNHTY1c7E7
 FjTIk5Nr0HKNOH4jBBO/nGekm86UgUAA1YfHnSarLNb9pZNvOBa+HDVR/zbOCxY6NY1ZP9K4yt
 pUJPoH4sN6bH+F2icZDg6pkQQGirtTTIvKgI0min0s/BwDOfZJ+pk3H8XxlirLkj8jsnmft2Ni
 3UE=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 20:47:37 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v4 2/8] nvme: cleanup zone information initialization
Date:   Thu, 28 Jan 2021 13:47:27 +0900
Message-Id: <20210128044733.503606-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128044733.503606-1-damien.lemoal@wdc.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For a zoned namespace, in nvme_update_ns_info(), call
nvme_update_zone_info() after executing nvme_update_disk_info() so that
the namespace queue logical and physical block size limits are set.
This allows setting the namespace queue max_zone_append_sectors limit
in nvme_update_zone_info() instead of nvme_revalidate_zones(),
simplifying this function. Also use blk_queue_set_zoned() to set the
namespace zoned model.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/nvme/host/core.c | 11 ++++++-----
 drivers/nvme/host/zns.c  | 11 +++--------
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1a3cdc6b1036..81a1c7f6223f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2176,17 +2176,18 @@ static int nvme_update_ns_info(struct nvme_ns *ns, struct nvme_id_ns *id)
 	ns->lba_shift = id->lbaf[lbaf].ds;
 	nvme_set_queue_limits(ns->ctrl, ns->queue);
 
+	ret = nvme_configure_metadata(ns, id);
+	if (ret)
+		goto out_unfreeze;
+	nvme_set_chunk_sectors(ns, id);
+	nvme_update_disk_info(ns->disk, ns, id);
+
 	if (ns->head->ids.csi == NVME_CSI_ZNS) {
 		ret = nvme_update_zone_info(ns, lbaf);
 		if (ret)
 			goto out_unfreeze;
 	}
 
-	ret = nvme_configure_metadata(ns, id);
-	if (ret)
-		goto out_unfreeze;
-	nvme_set_chunk_sectors(ns, id);
-	nvme_update_disk_info(ns->disk, ns, id);
 	blk_mq_unfreeze_queue(ns->disk->queue);
 
 	if (blk_queue_is_zoned(ns->queue)) {
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 1dfe9a3500e3..c7e3ec561ba0 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -9,13 +9,7 @@
 
 int nvme_revalidate_zones(struct nvme_ns *ns)
 {
-	struct request_queue *q = ns->queue;
-	int ret;
-
-	ret = blk_revalidate_disk_zones(ns->disk, NULL);
-	if (!ret)
-		blk_queue_max_zone_append_sectors(q, ns->ctrl->max_zone_append);
-	return ret;
+	return blk_revalidate_disk_zones(ns->disk, NULL);
 }
 
 static int nvme_set_max_append(struct nvme_ctrl *ctrl)
@@ -109,10 +103,11 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
 		goto free_data;
 	}
 
-	q->limits.zoned = BLK_ZONED_HM;
+	blk_queue_set_zoned(ns->disk, BLK_ZONED_HM);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
 	blk_queue_max_active_zones(q, le32_to_cpu(id->mar) + 1);
+	blk_queue_max_zone_append_sectors(q, ns->ctrl->max_zone_append);
 free_data:
 	kfree(id);
 	return status;
-- 
2.29.2

