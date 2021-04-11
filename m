Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E1AC433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C8E611C2
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbhDKG2i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 02:28:38 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:62885 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbhDKG2g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 02:28:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618122500; x=1649658500;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EHOf5wvKwq4BI5bS85fMXpHxwsYDRytYEOM+K6W4Tnw=;
  b=Hg+C7ZwIP0WbIPT9se/yfhVGvJLbtk6Qax8VBvmG9/GTYCtogglpxPpd
   gOlc2WRhHOWDqTEvTYRyBemlFRg9hG2Mm2VguO6PzsjzRVVsv4xwR/78l
   SkNmGdJfZ6K42yu3eSoObZImFKpnR0Qt/F4DQUOqHSuQkhBgaAG7vDAhB
   4cBZdsCLC4lcUbGmztGk9Y2Qk8sqbbrYnTOj0q47MurOLK6hepoLAaLaB
   vcZWTZgQtLJP+wx07r3EyjwQouI/1V1hG1tj5Q7gZ5cc98j1KDOO4A3nd
   7FaENQBpu0uTMqeAxHIJBiPQx4KNNEPXUK30T2qIVzWZ0mKSuY121dkVW
   w==;
IronPort-SDR: EIBfb6nTLjZuinQKU3AIS9rtABjV3xlxalpR13U17ZW/f/40YCr320yU/WJDeBPtyQyZXEpOXI
 Yruj5qoTMdQfSRFSq2b1BgAZ9bngAnDcAdKfEhKpz2ZQgTJ2GiFmV0IfbfbYbi+Oa1+qMHpTck
 aW6Ijr7rux0oJ1p0TrjFIV0vX829YzKtMG6JT0uO9NIisEmsceNFG2xGW94DhgoBNEBcr+BqIw
 SmTT6JKiAeoKepUYo56eDQr8ppnGe4Lt6VsMnZ+X358LLDy3kt8cGOTzv9Y54/4YXPkKezqsF7
 9A0=
X-IronPort-AV: E=Sophos;i="5.82,213,1613404800"; 
   d="scan'208";a="168904970"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2021 14:28:19 +0800
IronPort-SDR: /Cp8zX2lowIz93gF2LmQ5qgbhpwnOv99ZYqZfeVm2PpWjukNkOwoGPQ+bmRkwp52RIruwyz0pG
 9sgpdDoo7mThDyfwsqLbT/hw3Sm5MQHn7yjokogLQQ6S0kf5hRyt1AEmkhf3BA9HHOZU4rAoao
 hkfLmI9x15qwKMGnpOZoBlSxLkiil4zrtEsKDySm/dpKKB5bSmphlMw1YmaJXJfW4HTa3i+Obb
 al7AVII5YZHez+tXYSIyHzT1hLtc9qJ0fZGbCh/Q9ogC++XG1rhePyXl3Zqp+rnafLErM5yJVb
 kijL9UCyl8BY3gD8277+nAnB
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2021 23:07:52 -0700
IronPort-SDR: tAw6ICkfj9Mn96aaC5defGPIQrCIRShmCPWw063U66eZlzqdJ82RhlK6IqJQcbiDr1A/cLeKVp
 VTdDMXNQ6oMzB3imjEhJzsU3pgMdLSeh+Sg79PlICGJfTUpKRkbstEtF7M8Vaxc4KLbn3ISffh
 3kIvCYcmJ8gm+33c9aNbLqDZC/kBFHmC3DChEA5EKlhbX0emGmHMrCwt4nw2knM48HvEs+jAjB
 nESRBAD4l/DhR21VHc7gmoq9uNBagiCYOA4JCPyeyadBul22l7flIn60ImSaUpSrZDBfnPnPRe
 vyw=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Apr 2021 23:28:15 -0700
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
Subject: [PATCH v8 06/11] scsi: ufshpb: Region inactivation in host mode
Date:   Sun, 11 Apr 2021 09:27:16 +0300
Message-Id: <20210411062721.10099-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411062721.10099-1-avri.altman@wdc.com>
References: <20210411062721.10099-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In host mode, the host is expected to send HPB-WRITE-BUFFER with
buffer-id = 0x1 when it inactivates a region.

Use the map-requests pool as there is no point in assigning a
designated cache for umap-requests.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 46 +++++++++++++++++++++++++++++++++------
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index aefb6dc160ee..28aef5acffa2 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -691,7 +691,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 }
 
 static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
-					 int rgn_idx, enum req_opf dir)
+					 int rgn_idx, enum req_opf dir,
+					 bool atomic)
 {
 	struct ufshpb_req *rq;
 	struct request *req;
@@ -705,7 +706,7 @@ static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
 	req = blk_get_request(hpb->sdev_ufs_lu->request_queue, dir,
 			      BLK_MQ_REQ_NOWAIT);
 
-	if ((PTR_ERR(req) == -EWOULDBLOCK) && (--retries > 0)) {
+	if (!atomic && (PTR_ERR(req) == -EWOULDBLOCK) && (--retries > 0)) {
 		usleep_range(3000, 3100);
 		goto retry;
 	}
@@ -736,7 +737,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 	struct ufshpb_req *map_req;
 	struct bio *bio;
 
-	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN);
+	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN, false);
 	if (!map_req)
 		return NULL;
 
@@ -914,6 +915,7 @@ static int ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
 
 	blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
 
+	hpb->stats.umap_req_cnt++;
 	return 0;
 }
 
@@ -1091,12 +1093,13 @@ static void ufshpb_purge_active_subregion(struct ufshpb_lu *hpb,
 }
 
 static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
-				 struct ufshpb_region *rgn)
+				 struct ufshpb_region *rgn,
+				 bool atomic)
 {
 	struct ufshpb_req *umap_req;
 	int rgn_idx = rgn ? rgn->rgn_idx : 0;
 
-	umap_req = ufshpb_get_req(hpb, rgn_idx, REQ_OP_SCSI_OUT);
+	umap_req = ufshpb_get_req(hpb, rgn_idx, REQ_OP_SCSI_OUT, atomic);
 	if (!umap_req)
 		return -ENOMEM;
 
@@ -1110,13 +1113,19 @@ static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
 	return -EAGAIN;
 }
 
+static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb,
+					struct ufshpb_region *rgn)
+{
+	return ufshpb_issue_umap_req(hpb, rgn, true);
+}
+
 static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
 {
-	return ufshpb_issue_umap_req(hpb, NULL);
+	return ufshpb_issue_umap_req(hpb, NULL, false);
 }
 
 static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
-				  struct ufshpb_region *rgn)
+				 struct ufshpb_region *rgn)
 {
 	struct victim_select_info *lru_info;
 	struct ufshpb_subregion *srgn;
@@ -1151,6 +1160,14 @@ static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			goto out;
 		}
 
+		if (hpb->is_hcm) {
+			spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+			ret = ufshpb_issue_umap_single_req(hpb, rgn);
+			spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+			if (ret)
+				goto out;
+		}
+
 		__ufshpb_evict_region(hpb, rgn);
 	}
 out:
@@ -1285,6 +1302,18 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 				"LRU full (%d), choose victim %d\n",
 				atomic_read(&lru_info->active_cnt),
 				victim_rgn->rgn_idx);
+
+			if (hpb->is_hcm) {
+				spin_unlock_irqrestore(&hpb->rgn_state_lock,
+						       flags);
+				ret = ufshpb_issue_umap_single_req(hpb,
+								victim_rgn);
+				spin_lock_irqsave(&hpb->rgn_state_lock,
+						  flags);
+				if (ret)
+					goto out;
+			}
+
 			__ufshpb_evict_region(hpb, victim_rgn);
 		}
 
@@ -1856,6 +1885,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
 ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
+ufshpb_sysfs_attr_show_func(umap_req_cnt);
 
 static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
@@ -1864,6 +1894,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_rb_active_cnt.attr,
 	&dev_attr_rb_inactive_cnt.attr,
 	&dev_attr_map_req_cnt.attr,
+	&dev_attr_umap_req_cnt.attr,
 	NULL,
 };
 
@@ -1988,6 +2019,7 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
 	hpb->stats.rb_active_cnt = 0;
 	hpb->stats.rb_inactive_cnt = 0;
 	hpb->stats.map_req_cnt = 0;
+	hpb->stats.umap_req_cnt = 0;
 }
 
 static void ufshpb_param_init(struct ufshpb_lu *hpb)
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 87495e59fcf1..1ea58c17a4de 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -191,6 +191,7 @@ struct ufshpb_stats {
 	u64 rb_inactive_cnt;
 	u64 map_req_cnt;
 	u64 pre_req_cnt;
+	u64 umap_req_cnt;
 };
 
 struct ufshpb_lu {
-- 
2.25.1

