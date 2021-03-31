Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF810C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 980B8619B1
	for <linux-scsi@archiver.kernel.org>; Wed, 31 Mar 2021 07:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhCaHl0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:41:26 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:44593 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbhCaHk5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Mar 2021 03:40:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617176456; x=1648712456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v4kXE+IBwcAUfe4J96duoT79tUFebgBBmSbuu0lgB9k=;
  b=rrz2ucQQfAri5ObPrtV3cnedm1gJ4bQrpZzDKKn6OlJ07hl0aNGaAqtZ
   qzSuYaG214D/XuZXhB/l2pUCe4SKbYAJ573kgl/WrV4EowXwNaAXa74fz
   oV3t+UO67HBOdk4Q7slI5p2LYjm34Yitq/7VyQL8ekiAN8piYbqPzpxFW
   9H2txpK18k3zl4rO5mpNf6GrtZnDFkRYr/oR99P4BeK9GG8GvlrlMDti7
   GxcoCSFc5T7u6jP9Nv13SV9QZ+GLEvD6P1FXtJPbrjQc1f+oLevIw0isR
   tBzbHNQIyWU3oRz+TueaxYIsYOXknfWtU4nEIdE1KFVY3yxiaXUrTf98m
   g==;
IronPort-SDR: EeJBqXPiHnlpWdGXqX/rmv0sZwgh9zDEam4MM8Yt68NSVutRu5xxtEi53cRoGt4XVnowddrAd2
 Fvu3MBQJrvMvUxhgTZy/IvSu79PVtQoUtD0zNvdxxkapNkLlSvScSbdMqZuCs9U8XtA8b7FVRr
 G/BWwRGu65Oc2WqdU3bRqfRq2IFKQKPN5r1B9eNFCt0eCb7Wls0+YnEorwSuOh7l7TSGqpA6E9
 AWte+Q0K4PY2iIuBKBKkNW2oWiN2gAgHeT4vHQ4u2ChlSL99BfpCHVyqdCLwLBGEZHpHRYT3sV
 a1M=
X-IronPort-AV: E=Sophos;i="5.81,293,1610380800"; 
   d="scan'208";a="163422292"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2021 15:40:56 +0800
IronPort-SDR: q6Hu9IrvApW7z8M0GOE0Xiy3qtF3neFeRSpQtumXQhwInh/PDRcaHnNc6jgSz/WFp2hRSfPTgc
 vXVSHQY0Ww0cxSKEthSMhVZHsfW0R/5exLaSIyERfB4umoz6+YF4hEoS4i0AvKL4CyCdY13OB1
 XGBfCjEYjPcBef9K7cGDh8rp+5ndd3VQuAte32Prbrp/5jqtLffXMyzgRH4tGC90pDc8Nn+N4z
 2MILxDAGwRSZy29gahzErfAfEdLkzDDsoJLiWSVcFrjDcH9baVR/fxCEQlCGsFW/iDqOn58nqs
 akMIJGn35kg38ti1rZlu1Lu8
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 00:21:09 -0700
IronPort-SDR: S1aA5hlSxFeVcq/An5WsNLCMRBGqz3ftwvgC79R65H9sf06Zad7mKJr4RKHXuN8rBFajTDMVY0
 4XPIjIzDsP+AQjHFCI7c52sgo9Y4AC9173sKKlQWGwayF6ED/7rDHH3pR5GJqO2HBhFiMUgLRH
 YE0JAJ3hyuNd6gXDit41K8dh4HP0KvB+Rma8JRzg7SqlyeHL311T0HUNmbMJ8z9thUc3PTIP1f
 DgubZqRP1vH9EgskOjZHaDq6bdfsKv60+O9IciZoGXNry8NN+W6kUk/ZAk8kY5oK2vfQXoyEgM
 QD8=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 31 Mar 2021 00:40:53 -0700
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
Subject: [PATCH v7 07/11] scsi: ufshpb: Add hpb dev reset response
Date:   Wed, 31 Mar 2021 10:39:48 +0300
Message-Id: <20210331073952.102162-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331073952.102162-1-avri.altman@wdc.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The spec does not define what is the host's recommended response when
the device send hpb dev reset response (oper 0x2).

We will update all active hpb regions: mark them and do that on the next
read.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 32 +++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index fcc954f51bcf..1d99099ebd41 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -195,7 +195,8 @@ static void ufshpb_iterate_rgn(struct ufshpb_lu *hpb, int rgn_idx, int srgn_idx,
 		}
 		spin_unlock(&rgn->rgn_lock);
 
-		if (activate) {
+		if (activate ||
+		    test_and_clear_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags)) {
 			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
 			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
 			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
@@ -1412,6 +1413,20 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		queue_work(ufshpb_wq, &hpb->map_work);
 }
 
+static void ufshpb_dev_reset_handler(struct ufshpb_lu *hpb)
+{
+	struct victim_select_info *lru_info = &hpb->lru_info;
+	struct ufshpb_region *rgn;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+
+	list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn)
+		set_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags);
+
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+}
+
 /*
  * This function will parse recommended active subregion information in sense
  * data field of response UPIU with SAM_STAT_GOOD state.
@@ -1486,6 +1501,18 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case HPB_RSP_DEV_RESET:
 		dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
 			 "UFS device lost HPB information during PM.\n");
+
+		if (hpb->is_hcm) {
+			struct scsi_device *sdev;
+
+			__shost_for_each_device(sdev, hba->host) {
+				struct ufshpb_lu *h = sdev->hostdata;
+
+				if (h)
+					ufshpb_dev_reset_handler(h);
+			}
+		}
+
 		break;
 	default:
 		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
@@ -1812,6 +1839,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		} else {
 			rgn->rgn_state = HPB_RGN_INACTIVE;
 		}
+
+		rgn->rgn_flags = 0;
 	}
 
 	return 0;
@@ -2139,6 +2168,7 @@ static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
 	if (hpb->is_hcm)
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
+
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 1ea58c17a4de..b863540e28d6 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -127,6 +127,7 @@ struct ufshpb_region {
 	struct list_head list_lru_rgn;
 	unsigned long rgn_flags;
 #define RGN_FLAG_DIRTY 0
+#define RGN_FLAG_UPDATE 1
 
 	/* region reads - for host mode */
 	spinlock_t rgn_lock;
-- 
2.25.1

