Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97ABC47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA99E611AD
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhFGGRr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:17:47 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:4838 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhFGGRq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:17:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623046555; x=1654582555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Eg7FuxGEda1N/nS5nNBZ3iFh8zPGLfT1LdyYWIqHRXM=;
  b=DeN0TUpV57QjXGkdFv2mpimKMtAfZkqLZ87kBeFGVCHy6fUPH605JbrC
   RJx4xZzBS8HrRjfop/mPljXjr6laKqptajA5c5G6XWXVaG/EqW4wTbbFY
   0uRPly27dA3CUp6BqxFSC5YcKF283blrbvb3u7yL4PsPNheU4QPsJO8yr
   03Y90HY+vnaMw2J9Px/bgspvQF3BmlljN43rjLvmEoUT6D5dBdnpU0cMl
   wsiI1h4xl353iiVqArAqieVQLl7Zpjlfl7p0yxhIKHoql0/B2OtlSepDA
   vCCSqhBBUq/PeA1/KFu4KVR7n+1SW6SkjOwknuZqhQ9amCm3j7EpikRgd
   Q==;
IronPort-SDR: 2kwnSo+e1h+enGEWPZHFGsYQ2SJnChc3jQQyiPFRP17Xx7WXrpj1gdn4A97QZASA3/X4C/Fr3E
 CYo+0qTQDYP2xc8Y4w0TOOjeARck2Z6obk6nlsNOC9V4elZW+PAAWwD+p6xc4s3b/97m6v7r5O
 iedWtjrwW+gBD9tHz7MHAt8Rv60yjyRRrDepagOgUrjDUO1yNSWzLw8Ho860D5L7I25Xp9N5K5
 N6ihrQUyCGCqxoE7vgYG9TNbm46VMebuvtrnGvQmcVApYRx6QzGRFaFdGQYA49aZziNCIbXWZg
 wk0=
X-IronPort-AV: E=Sophos;i="5.83,254,1616428800"; 
   d="scan'208";a="170991635"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2021 14:15:55 +0800
IronPort-SDR: t1CIkNPH6bbCvbqXlZbWBmbr38ukQm3Qc6d/Uaw9TfJMkbX52mp32p63oQtdmuSv6kTrhBG5ZC
 8P09AzwIRz16pCbMBSEZJ3tiznhB78iWowGlh8sNrwL7ZI3tKIr5E28+Cq78iJj11SKdfcZ6wf
 1LzHGunUeyqUkz78OiH3sYZqKqfyC0uR8yQKilumAFKdNc9f3HoBL2eICovyhsE/ZkqJGOhp/N
 MZ3B0vIhe7KK8buYEDTqCLLX49RWrVyUAWHnayd+aZABuu+AIg3qJz0BYpdzUKagUnJ3C1IAUZ
 7TdXQ4cQ4KD51Fbdddzm7EwZ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:55:04 -0700
IronPort-SDR: iXTA1paGG1tWlPlQhUrMONaZWE0WhnTOAS9gY6q6F3ni8J/lCb5D8AockGbyiw/nYmCKWss9bu
 2XvgKGry4XdfS9q/egY03hLrjBmRNKOW+kUIWaNGbMGPmspjOrowUhyq5ewLsedSIFq+/VxN66
 91+oWIxXJw3Lu9Dad36qsy934DU9eD/X8B/UKJPWWCokFlqG66IudX97kGrKsOYDBk2gp/RI7o
 lfgIP3O21lH7u910eplFzzFjQbu/owC4csJ5jPVmzJEKvqML+1deMPjbxh/7PISE0PmQjRwA3E
 rWI=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Jun 2021 23:15:52 -0700
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
Subject: [PATCH v10 09/12] scsi: ufshpb: Limit the number of inflight map requests
Date:   Mon,  7 Jun 2021 09:13:58 +0300
Message-Id: <20210607061401.58884-10-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607061401.58884-1-avri.altman@wdc.com>
References: <20210607061401.58884-1-avri.altman@wdc.com>
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
index a31a9a6979de..bcfdf338244b 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -21,6 +21,7 @@
 #define READ_TO_MS 1000
 #define READ_TO_EXPIRIES 100
 #define POLLING_INTERVAL_MS 200
+#define THROTTLE_MAP_REQ_DEFAULT 1
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -741,6 +742,14 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
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
@@ -755,6 +764,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 
 	map_req->rb.srgn_idx = srgn->srgn_idx;
 	map_req->rb.mctx = srgn->mctx;
+	hpb->num_inflight_map_req++;
 
 	return map_req;
 }
@@ -764,6 +774,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
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

