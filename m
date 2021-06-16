Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51749C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F13161351
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhFPLbn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 07:31:43 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25358 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhFPLbe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 07:31:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623842968; x=1655378968;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FGBSV7gU77EqLJ6pQZAhOqU+1xzQhklp97zFvxCr8IQ=;
  b=fE8Jw2hv1YfH1gVQwzOcv7NHf1jNXFYbnVWBhDu/xWywK09hrcns9SHL
   h6vDCLRixdqgmAzP6movwyvf2PExzJ6WbcMRz+OLQqcczhgd5Uf/fCl8L
   k5PXoEimoy/cgV2R46cCC4n7Sa8d+T+12Pd5pRtGFiYS50UOL/vUUmtgL
   xMZJyTJYvqreOdpD81dYDSLxbnA5XOFwASUy0WGSfohDnyyubEWYVKp3z
   17b6bRthbaqSwMH0daiqtQdL1bpcnMBhwi2iL2K9gdfTjfr+qHok0jvIr
   rUeB8rVGQ7MFrB2R+eZKHmI4TQ7qTECiH0+iPDvKJu+nwi/tgIsL3Ztk2
   w==;
IronPort-SDR: e9s0PyH4B2TK6lpOFrtB+Bt2j6tQTkg4UhtYvlqj/70Vtdfaf5FZ22uCZ0x44422104EbJS/fn
 rdx3ZzSPHSlkipdb+FWM2e9OyzrGqYu00dlZ8hC+EhYc6F6Ig8rPxOGq3LKRE04Rvcf5F9YhMA
 CL6Jt42J/tMio6jHuim0vsOEERzB6oHFgIdsJLmtGmtRZ7rewGjRX1WY9g3mF9F/P+pq2jFMFn
 +P2O13j2YDIZMTSVOyw/XLavcJyKW2FricNQvnp6It9FLcl8IOo6Q1eJvl2FglxVEEGdU9gm9g
 4Ms=
X-IronPort-AV: E=Sophos;i="5.83,277,1616428800"; 
   d="scan'208";a="171352792"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 19:29:27 +0800
IronPort-SDR: K3soBkqP7ON/1xB8AvgaxKpUkrpOzAwA2EH1mEwvJQkr8A5d8IVcYY+k+ZtAw9RT0Yb2hzAzXQ
 oB+83apzxsOlITmuugN35vDRhBbXaUn+nuaETzmRsLY4F7hYNZfKF8d4vzgN6lt4oQenNae1AW
 YnGaHNEebJgBgMqAhorcc5Dkp08hafPvJx7zXsM8VNt4S8N6q8Mz0KcMYnhAzHf/YQFBE9u9Rd
 p7m+bmpJK/ohgrcqiQXlNSH3TprjQM/gMj1mpnbHEjACagQRMfLe/xqs1TW2BPMVXUAUOx22M4
 b8+RjRDQLhR2PnFR+R1eGoC6
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 04:06:55 -0700
IronPort-SDR: mQ1zRgyaK28LfKzfqMCFPq1zETWSAMshVjhgsyIm5vOUF0wrEopEt3lXoL2dWkU5Wtr1oNHmul
 CAOFsWWAgFpaPZAQC03woRYqxwJhTCOwunhKpfVYT3Vj34Wmz7kDIL+k9D69rJjc+CGLwyOdGA
 qY/dLLIZhMl+t4SAHFpgGNywrh6z4UJ7YNGYGoKvW/vNVUBvoCYe/Gq3KKz5Dqyb6u8Di2B4sH
 9hJK4Id9/9n1aiIbyNch5wWK60OjmtjbSSo8dS8kHxdr+yQtv3uYpEX6jwIrmHzGyTNpLpttbi
 aJM=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2021 04:29:23 -0700
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
Subject: [PATCH v11 09/12] scsi: ufshpb: Limit the number of inflight map requests
Date:   Wed, 16 Jun 2021 14:27:57 +0300
Message-Id: <20210616112800.52963-10-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616112800.52963-1-avri.altman@wdc.com>
References: <20210616112800.52963-1-avri.altman@wdc.com>
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
index cf719831adb3..c9c1c39cb269 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -21,6 +21,7 @@
 #define READ_TO_MS 1000
 #define READ_TO_EXPIRIES 100
 #define POLLING_INTERVAL_MS 200
+#define THROTTLE_MAP_REQ_DEFAULT 1
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -742,6 +743,14 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
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
@@ -756,6 +765,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 
 	map_req->rb.srgn_idx = srgn->srgn_idx;
 	map_req->rb.mctx = srgn->mctx;
+	hpb->num_inflight_map_req++;
 
 	return map_req;
 }
@@ -765,6 +775,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 {
 	bio_put(map_req->bio);
 	ufshpb_put_req(hpb, map_req);
+	hpb->num_inflight_map_req--;
 }
 
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 8309b59c7819..edf565e9036f 100644
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

