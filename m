Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAA07C4338F
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 09:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D13960F9E
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 09:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhHHJB1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Aug 2021 05:01:27 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:13558 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbhHHJBZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Aug 2021 05:01:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628413266; x=1659949266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=L0NSUOIkoI+fROYlx4Yf7xoPnBxt8xZkGjTL7cMuIzM=;
  b=iF2zxYBbYVOduapr7Ohx9sz/IFrr+1WKfBpARuNxZ3w84mnBEoiHIqTG
   Zxi/eDMxom1UxesotRKYa39Wi3NrByWcXb1z12Cp/nAC5JzRlZtj8dq7Y
   qzxpeb4UzTmtvX4NynRyjv8/V5Fo3PtRLY2/xdxGk7xw6XMJnddTusD/8
   LWDeImcN9+RM8TTr2GR1pJYWXge/13aOAbx3xrq6KDp2hYWr65dCeyLu6
   GtREBr1wrHTBsB4b+ow8sZqNmrGR6IeJ8XbKnizhAL9rTTRQyXjuWZMXY
   LAOjBC6ecHipRz/xbrhwrY/+WnE3ZHogW1SYN1jxI1/vaDGL9R7JwIALM
   w==;
X-IronPort-AV: E=Sophos;i="5.84,305,1620662400"; 
   d="scan'208";a="176607213"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2021 17:01:05 +0800
IronPort-SDR: BrGufTHlmjocwAIDaVv6HcFG5cfkxUT5TbSdEvwu6BMaUMKjHd3EPmCQR/JJCzXQ2Kddv859Iz
 4Bsm/zpH6WWMFYGXT14JNg+3JUR7xFZ2+J9WXo/ALUJ9/PWTXJUecuV03Zz90+QtwmVTjC/IvS
 zCc4F0uDwBI651vdvrGyzxYT8GOpPS0Rhq4UZS5j6rMZjKW7sYoa6qbDjaZEKXIxp76LhBgyCQ
 z4A4/Q+WlbtkKRTk8K4swXdBG9y5p7bc+KpeB5J1g7K5hdLfqmFJSwNBfqKoUrmwQiRSzzcjCc
 LdzGaNXdl6lfTmjFdSszfCzD
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 01:36:41 -0700
IronPort-SDR: MU9xphad+5f6aLHiqnvIgymRq1tR6ei0x0ECwrUoZgqk8yYD5K+nLXOoqDSav+sIbjplo/bv7G
 EmQUwCEtup5EofqpMxs/uN976jOqWtIs6890ElDmOCH+QHvkbaEK3NamGw7X9CGXwF/33AOXAX
 z9BL5AYx3Nn5sXyjLyY3wVhtXS3f3j1IT7n/iosiKMCYJfRlafDqU1Kq4ugK5Z71/olJQ39O+T
 OS49yI+LeUadc1FwJu3HTaOAr0qnZRX7QDh7k2awittBGExJ92L13hBn40cZ1RUc9aW3K5vprr
 3AU=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Aug 2021 02:01:04 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 3/4] scsi: ufshpb: Verify that num_inflight_map_req is non-negative
Date:   Sun,  8 Aug 2021 12:00:23 +0300
Message-Id: <20210808090024.21721-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210808090024.21721-1-avri.altman@wdc.com>
References: <20210808090024.21721-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

num_inflight_map_req should not be negative.  It is incremented and
decremented without any protection, allowing it theoretically to be
negative, should some weird unbalanced count occur.

Verify that the those calls are properly serialized.

Fixes: 33845a2d844b (scsi: ufs: ufshpb: Limit the number of in-flight map requests)
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 10 ++++++++++
 drivers/scsi/ufs/ufshpb.h |  4 +++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 8e92c61ed9d4..cd48367f94cc 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -756,6 +756,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 {
 	struct ufshpb_req *map_req;
 	struct bio *bio;
+	unsigned long flags;
 
 	if (hpb->is_hcm &&
 	    hpb->num_inflight_map_req >= hpb->params.inflight_map_req) {
@@ -780,7 +781,10 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 
 	map_req->rb.srgn_idx = srgn->srgn_idx;
 	map_req->rb.mctx = srgn->mctx;
+
+	spin_lock_irqsave(&hpb->param_lock, flags);
 	hpb->num_inflight_map_req++;
+	spin_unlock_irqrestore(&hpb->param_lock, flags);
 
 	return map_req;
 }
@@ -788,9 +792,14 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 			       struct ufshpb_req *map_req)
 {
+	unsigned long flags;
+
 	bio_put(map_req->bio);
 	ufshpb_put_req(hpb, map_req);
+
+	spin_lock_irqsave(&hpb->param_lock, flags);
 	hpb->num_inflight_map_req--;
+	spin_unlock_irqrestore(&hpb->param_lock, flags);
 }
 
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
@@ -2387,6 +2396,7 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 
 	spin_lock_init(&hpb->rgn_state_lock);
 	spin_lock_init(&hpb->rsp_list_lock);
+	spin_lock_init(&hpb->param_lock);
 
 	INIT_LIST_HEAD(&hpb->lru_info.lh_lru_rgn);
 	INIT_LIST_HEAD(&hpb->lh_act_srgn);
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 6df317dfe034..a79e07398970 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -237,7 +237,9 @@ struct ufshpb_lu {
 	struct ufshpb_req *pre_req;
 	int num_inflight_pre_req;
 	int throttle_pre_req;
-	int num_inflight_map_req;
+	int num_inflight_map_req; /* hold param_lock */
+	spinlock_t param_lock;
+
 	struct list_head lh_pre_req_free;
 	int cur_read_id;
 	int pre_req_min_tr_len;
-- 
2.17.1

