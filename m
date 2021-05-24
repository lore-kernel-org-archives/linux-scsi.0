Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EB4C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 652D761132
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhEXLZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 07:25:35 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:21975 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbhEXLZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 07:25:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621855426; x=1653391426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X+S+UWcVVZpcDsyp4d30JhOYB8agagAYzQEHi7XbKnA=;
  b=jv7m3Tt3BOCCuKF0DZv1xLFkQP9dpLLOGIZ3Ex+Hh3WlJWKcd22LlKte
   RttMBeG1f1DLBwa7xnVXcQ4Ucxx2CEcWZHZbH8ZHJnxa7vARH5URIf3hR
   fB6YuxJLKNXalY0iGHStDyYynHxNule5ouajuUMQvckrcq3TPQ/1NLz8k
   0veGNopYDSlZ+jPB4J9f1g4qMapL5A/wo/1ISGR5jxo13Lon8UA135AYr
   eAxIaJY+sJWWazPd3PXKLaBP4cVRTg6WK3K38ZSTfBVF+v1mAGBTL7s/D
   cIttE9AsE3WTlPCBOgiWkIEsPV0jxdwXOzHW13YFaZ0o8czv4qEpH4uwQ
   w==;
IronPort-SDR: UvWNP8rIyX+lOKUzsT4IIaM4FbiUweZZf7oUW0Ac4chveuBPG5lJckbCXJycV72TiR8Fj2wI2g
 9n/TAop2QH753rKGEpIsRJvrTANremkQ3jxo2wojqC0T32zhNdvSBjA+RiTuG7c70/LIsEl61l
 NV1vJm+AMt/CGfUAcaw+p6VV+7TtJBpwthaAfWqpjwUzPoZ0Jq3jJ8ULQ8DryuXdb2deTCIB3J
 vaK2uloRdzpkmCAC0ExifoViHBKXGL17HdpIwaaj1IzepGzLPCvkQEvkLaGAaJnmMQdpf9TeyB
 vrA=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; 
   d="scan'208";a="169230684"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 19:23:45 +0800
IronPort-SDR: MCfFA/JmiFv9MMkt7iSD1t3Os3qyAngDhmjePRJEImQhMCbX+eOptZhtm4fWMa32WLllFPpAa7
 vXPc6pJ8urRDjefPwHc5uJpjgLDNYTkI2kgjI3zAlB5NcV7O+evQIfZ1xp4pBBPW+WrkvpRbmI
 AY0TY9c2qU8M8Yp5yYgFEhcGcghuzbTKR5rc15MC8urcx2kg630RMkqgZCNaTlspU7RXZZni67
 Vxa5uITjxphwc9/CH7Vy0nmbFxG5rshpgtq2S83M4Tl7ns0Y/uFlOovDiAKKZJ1UODEMKcH7id
 I0/gbC9bKUNowZgeK777f1Qt
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 04:03:16 -0700
IronPort-SDR: BsdI67gYlbF8HUK+leXgK33vYvUajDHytICL0RIwPNuSGh8VHtFvFqOxJNcr5aSt6KbdcPner6
 523lDqSdL+kIPAh1SrhspX/R/2h+b0CLixn1CkwALfgpkYrsLQXVoTV0U5VJxukdTFNlymindk
 69xSIHPHt2v1BXZLtZfT0Ia6j9dhEn+jzO9yHO8z9Ge6a/MWKA0DmPHmrSyQFfezqe69wz6OMJ
 SieQPMqtKCYfS7edSlcpsdQn6uLSgAcvfjppZjcDgZmrDJrAZzQctwRnJnBs1OhERTebppD9Q3
 7mM=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 May 2021 04:23:41 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v9 09/12] scsi: ufshpb: Limit the number of inflight map requests
Date:   Mon, 24 May 2021 14:19:10 +0300
Message-Id: <20210524111913.61303-10-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524111913.61303-1-avri.altman@wdc.com>
References: <20210524111913.61303-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In host control mode the host is the originator of map requests. To not
flood the device with map requests, use a simple throttling mechanism
that limits the number of inflight map requests.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 11 +++++++++++
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index e1b77c9e6284..47f9021caa29 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -21,6 +21,7 @@
 #define READ_TO_MS 1000
 #define READ_TO_EXPIRIES 100
 #define POLLING_INTERVAL_MS 200
+#define THROTTLE_MAP_REQ_DEFAULT 1
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -739,6 +740,14 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 	struct ufshpb_req *map_req;
 	struct bio *bio;
 
+	if (hpb->is_hcm &&
+	    hpb->num_inflight_map_req >= THROTTLE_MAP_REQ_DEFAULT) {
+		dev_info(&hpb->sdev_ufs_lu->sdev_dev,
+			 "map_req throttle. inflight %d throttle %d",
+			 hpb->num_inflight_map_req, THROTTLE_MAP_REQ_DEFAULT);
+		return NULL;
+	}
+
 	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN, false);
 	if (!map_req)
 		return NULL;
@@ -753,6 +762,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 
 	map_req->rb.srgn_idx = srgn->srgn_idx;
 	map_req->rb.mctx = srgn->mctx;
+	hpb->num_inflight_map_req++;
 
 	return map_req;
 }
@@ -762,6 +772,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 {
 	bio_put(map_req->bio);
 	ufshpb_put_req(hpb, map_req);
+	hpb->num_inflight_map_req--;
 }
 
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 448062a94760..cfa0abac21db 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -217,6 +217,7 @@ struct ufshpb_lu {
 	struct ufshpb_req *pre_req;
 	int num_inflight_pre_req;
 	int throttle_pre_req;
+	int num_inflight_map_req;
 	struct list_head lh_pre_req_free;
 	int cur_read_id;
 	int pre_req_min_tr_len;
-- 
2.25.1

