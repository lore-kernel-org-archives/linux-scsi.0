Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D07C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 031AE619B1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhCaHla (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:41:30 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:64389 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbhCaHlO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 03:41:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617176474; x=1648712474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZZ0gmRBKCk+915yC+OTsRwaUxNIsnWdddXjW/YlqA48=;
  b=kNeUtWtt2aezI4f1xSsRU5cECGEjsfgcd9WjlTZd6Q7aYR3UJLgQdU+a
   LWewWWSJts3cVX3AyNuWM5X2vhlc0VouwOdZM17tdspe4u0HUY/UFX4j4
   diVSa36VQaA9LOC921nVoGflM5DCxE7jwYIDIjvp7NJayUmKIqIUj4DZQ
   UpinaBwFZqFiaOuFNa2m00IwuYiwIY4rUsK+TlAm1eWSqDaqUEiS7Xk/h
   L8/5yZuvQYDEfKt8nrVM+YRg4l5oDx0KxLBWW3hA5HCYRw8LoXmIsnAAc
   4Mw4zf600m35paez2zhF/ZRPf5tMJfpaVdyTusan/m2XV0EZfnnkzdG6A
   g==;
IronPort-SDR: xUinNZUZ7Lb7gN1FCJJI2uBrwYpQPafpYkYPVLw4Ltmrrllw4oyn4fbOJ17djmdfVu98qsmyVt
 hYHR9kEah9WL5ECfK3/DVqmQ+pZhOXdtUb+uemQrGZOeW7F2X1bblcRUKnD9upO+V7qM7in1U0
 GuTmpo8aY+rDiww6l/UnuJgrJe2IbnOWjtmrgbQ9BsLh4NGiQAB80IAiUOvOx1dTz3ZEOhfxnb
 D4caCKw+YPqR8cSfdyLURsSwKE5EuejW5Fw4Evm9QjL/BAL1Xede7y6mP81CS2BRn1U3Exohdn
 udw=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="167902128"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 15:41:13 +0800
IronPort-SDR: qMHdxrIdx9v3/ua8qxJLxfTG6TPvh4cptu7xzMXJydOvRw2Sp7Q9cW1x6I/KzKZT2cYztQHQKL
 vwEAxcJPXZmyHuDOHg23N8zpZvOfx3ffFhUi+sSRQzzRZCvKsqluaMpxvD1UScHt1aocwMp606
 UY/dmOVs8yvThYbBh1XHR55sLj47r5pvVYBHMhaDH0L0+MKvpvd+swK22u/D4UDMNGl9RrLB9Y
 qzK3fMQxaVlp65Nei/HM+wcsykb6B7cjjxMekIhOz0TGbNc1KbzmqMLP3h/RYVci3m3Z1IgdAw
 6rWRI3wP5jGSVxl+a5YUAlJc
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 00:21:26 -0700
IronPort-SDR: zHZS082WZFoanmfroRZ/zNylL4aA4Zauz4RJ7v7d1VnqbLLZIlljwnXH/zgLOSU4zdkHvAKzhT
 aoHGzsN57nR/cakGM6baD7zh5ki/GZPY5h1715DSMKhXut7wKdJPi9xDH1rPoAG8Fbo8CeRVYf
 REGLijSRnoYkbRUNOHQD4z+4PKH58+S9TE7Ig3SmqD0y4I5uiSy5Tkku62HGNTSjJ+l3HALp6F
 Ottcy+3KUDCg+iM01pgJ+rGPFUNgHbt81T2+g0UMbY9jn0dShAtvVAMjonRj99qGCDSCH7N+Oo
 i5c=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 31 Mar 2021 00:41:09 -0700
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
Subject: [PATCH v7 09/11] scsi: ufshpb: Limit the number of inflight map requests
Date:   Wed, 31 Mar 2021 10:39:50 +0300
Message-Id: <20210331073952.102162-10-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331073952.102162-1-avri.altman@wdc.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In host control mode the host is the originator of map requests. To not
flood the device with map requests, use a simple throttling mechanism
that limits the number of inflight map requests.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 11 +++++++++++
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 8dbeaf948afa..c07da481ff4e 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -21,6 +21,7 @@
 #define READ_TO_MS 1000
 #define READ_TO_EXPIRIES 100
 #define POLLING_INTERVAL_MS 200
+#define THROTTLE_MAP_REQ_DEFAULT 1
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -740,6 +741,14 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
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
 	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN);
 	if (!map_req)
 		return NULL;
@@ -754,6 +763,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 
 	map_req->rb.srgn_idx = srgn->srgn_idx;
 	map_req->rb.mctx = srgn->mctx;
+	hpb->num_inflight_map_req++;
 
 	return map_req;
 }
@@ -763,6 +773,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
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

