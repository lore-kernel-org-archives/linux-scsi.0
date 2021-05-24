Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43677C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24FF761132
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbhEXLYx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 07:24:53 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25872 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbhEXLYv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 07:24:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621855403; x=1653391403;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HZ1/03jdESdDt4jNUFCkSdJlnvse+EqIr/O1w7o8zds=;
  b=e2FbQlsDnVIKeV8Qxdglo2/3jHdpuXTgC95lqF2EizYJ9g4f+ew9CXA+
   IfuuoAOl3RXYo5XuXmf9D5SaXqGHWrjqaVACItrM77imJXU8mlaWYnk/F
   q7i3F0MgqDaSa5cz81U8zqtWgr9LdUcABdibP6GRxWIE+tXw6182J/kvp
   2TIOSdySgLLfi60A4+HvfcI400NP0MN2LMInzsCR6fPUZZjZyuipH3WQx
   wHU1BQ7g1AK4eCHaiTggl8v+DREswTsOxeGqCElGtZtyBYmEI2vFo4uQF
   9DCDBYahJYLWaVT53F7yqzWdZhDj5ZWybLqdfbvXx8ZtDDwluRU9BdUi3
   A==;
IronPort-SDR: rb4I2MvO8/e+HTIF6gBSW8/cwpH1cIEy5npmFJEzLdmY/0cAAu6eKN7MXCKY0fBIJh2HHptdUY
 +Yac1xyAAruzPR8JVjaue7mJg+EA36e7mbTz2bNDNpkYnpccHPGpW6g5N130GHVcbfzN5lypr6
 FiGTtfGAtmmNqrHhZXxGwH9n6rKF7HqicULTtILc9tgyPnFEv/ivKoe7zKnG95d+jqJbtIByxs
 zuLSzlP2EZ3pJVN5AqFQgIr7L9IjPTK4SYbuJANNTaPwI9L1eqQAR0oZZTc+7oPRLdLcdOKMhE
 ebU=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; 
   d="scan'208";a="280526031"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 19:23:23 +0800
IronPort-SDR: Yg1yOoaUQgJI2X+FRo7v0D5TXbB+Uz9zisnZpfD9Nx9XT75i8GvNJrkfAvh7HbEQqmkaXzJnJ7
 6XWL4GnqOMbJqXCIm4rcNUCRpqhN6r2X2oGWjLC8jYnCUBH2mWrYVTcVBA+QCu6r70vGzpSojX
 CbJ5CpQaeTxKlWMQJzA/kyGFoEU9cKWmFIfbb6YU2ZC7aESZnjdxI994bFfMqwzjIoiNVRMrz6
 sqe4Zs0AKQQjceu9DWRs5guAdDNCei2ije8FOdEJMVprmEdCD7kzw5fUtdut6mJX8tepyF+BUW
 VH4MWnNAZizc6fAZ5JB0CzYw
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 04:01:38 -0700
IronPort-SDR: hW/Hc25l3yHV9IV8VglwdC/coKgDR+AOVwBI49iebNzTaMzUz2yHXCIT6gJljjRnCiFZhpr8oJ
 4Cy9tnvX+cRcOpzSl9vYxRk3kyawEYIpEVyx6OnrIASIRLvIB1gWin5purKQlJgfY2gGk/U/Mf
 TOVenIkvYgNoIYTzNyl5TEM+aXS2BUtP1icL7T4rD+YBL4ABZa2KSgJaUiCo/m8x8FUPzIatxD
 +gSDlRECiU2oiJMk28OHYf3flynEhJT185fBQtIowAF7rNz1HIG3KTaCP83jqdsfZJYf/xYVAu
 FQU=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 May 2021 04:23:19 -0700
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
Subject: [PATCH v9 06/12] scsi: ufshpb: Region inactivation in host mode
Date:   Mon, 24 May 2021 14:19:07 +0300
Message-Id: <20210524111913.61303-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524111913.61303-1-avri.altman@wdc.com>
References: <20210524111913.61303-1-avri.altman@wdc.com>
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
index 180e74675912..0d010a343f34 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -689,7 +689,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 }
 
 static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
-					 int rgn_idx, enum req_opf dir)
+					 int rgn_idx, enum req_opf dir,
+					 bool atomic)
 {
 	struct ufshpb_req *rq;
 	struct request *req;
@@ -703,7 +704,7 @@ static struct ufshpb_req *ufshpb_get_req(struct ufshpb_lu *hpb,
 	req = blk_get_request(hpb->sdev_ufs_lu->request_queue, dir,
 			      BLK_MQ_REQ_NOWAIT);
 
-	if ((PTR_ERR(req) == -EWOULDBLOCK) && (--retries > 0)) {
+	if (!atomic && (PTR_ERR(req) == -EWOULDBLOCK) && (--retries > 0)) {
 		usleep_range(3000, 3100);
 		goto retry;
 	}
@@ -734,7 +735,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 	struct ufshpb_req *map_req;
 	struct bio *bio;
 
-	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN);
+	map_req = ufshpb_get_req(hpb, srgn->rgn_idx, REQ_OP_SCSI_IN, false);
 	if (!map_req)
 		return NULL;
 
@@ -912,6 +913,7 @@ static int ufshpb_execute_umap_req(struct ufshpb_lu *hpb,
 
 	blk_execute_rq_nowait(NULL, req, 1, ufshpb_umap_req_compl_fn);
 
+	hpb->stats.umap_req_cnt++;
 	return 0;
 }
 
@@ -1089,12 +1091,13 @@ static void ufshpb_purge_active_subregion(struct ufshpb_lu *hpb,
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
 
@@ -1108,13 +1111,19 @@ static int ufshpb_issue_umap_req(struct ufshpb_lu *hpb,
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
@@ -1149,6 +1158,14 @@ static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
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
@@ -1283,6 +1300,18 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
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
 
@@ -1851,6 +1880,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
 ufshpb_sysfs_attr_show_func(rb_active_cnt);
 ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
 ufshpb_sysfs_attr_show_func(map_req_cnt);
+ufshpb_sysfs_attr_show_func(umap_req_cnt);
 
 static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_hit_cnt.attr,
@@ -1859,6 +1889,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
 	&dev_attr_rb_active_cnt.attr,
 	&dev_attr_rb_inactive_cnt.attr,
 	&dev_attr_map_req_cnt.attr,
+	&dev_attr_umap_req_cnt.attr,
 	NULL,
 };
 
@@ -1983,6 +2014,7 @@ static void ufshpb_stat_init(struct ufshpb_lu *hpb)
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

