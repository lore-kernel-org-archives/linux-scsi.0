Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089CBC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9E3061972
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhCVIMg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:12:36 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:64922 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhCVIMN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 04:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616400753; x=1647936753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lJqKV7T3nS4jjyi644WDaCfXuj7bj0owU6ZBt1f2xnI=;
  b=STBLLiEKraujSgjn7jydxXis+8D8wN79DTSU+ZChqe4lVLumMsil+mXq
   XbjHTC+7y61M2+DyAF14vfGPwB4plr4smneKZHY3b9KNatXpuBK+jZdaN
   WidGq0XdXikI5k2JfkNzH+HL30l+4nvpQAXYqAcl96wenjWVdRxUOOYWt
   xVLnGTgNHMJ7Jnx7nZ1Uf4Ye9zkr/XMi5/mv+NOLncFtO9oHg4jbWdjLg
   ruzijPHkxD6AY/Xokf1OZWg+sQgp6SlNnRoFvCv2aCbLZZVj9SMBJ0TGf
   r304JRqZ+kZzwFZxnO5mvthaQtatvbaY+sk8cMr+/xMpQKHOMDO8amDUt
   g==;
IronPort-SDR: +5LGUCiYanJvNATkRPiU0SWv0YZbLI2vz/9T5NK+SoEyhmyvxduxjvnHJJu0MtWFEdKj72ViUv
 s3T6vt3jL671y8Tu0CMpUdi/4wb3J8/MYx/yiYXTtnv9NjvyB9e9mr77cBxj1Aib01PhZI8cMX
 pkfhe3S1PckQTsf9xWjmEfsGsaJ+buyoJJQ8JbVjPpKywFz6fVg+aDlI4a06Usptyc//Am7XvF
 IjZE+I+fNJdf/uakrn6ArUkcIef9OpyJ6emniQVApuKLFKMRkq7UEAbjaSr4fYY2/YsGWMmzFY
 AU8=
X-IronPort-AV: E=Sophos;i="5.81,268,1610380800"; 
   d="scan'208";a="267101061"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2021 16:12:33 +0800
IronPort-SDR: 0mXobf63eiUJpdenwZUNb9JRZnBmklVmRW28IidQfZ4O7MDyjYZL2+QqOgUCFYRHQQF+g/LLHE
 jk8a7fcLCsIJ+NDE9eq6WduAbptexfRgmlwVo7HzbD+kjlghuvVoh+pmONgmfAGRwHChAP9PZR
 QNPs5WNFLyp49lE/ykwr8lWhQUVE3kpZ8a2GWD8nBC9yZDW8to57lwsIvW8tpDh7OvLiN7Xz1x
 iUQG7ZXrO0vsncaReMLiZcF0u98GE+4+DTAU4kG8u6zBg3d7tI4GMUow7Im8/0n3tC8OG4S6bR
 xv/4ITMnohbvAdNhjtbCjjhN
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 00:54:21 -0700
IronPort-SDR: yQh4PsxrU+2lpuOGjOkO94PSBc+5KoSHsmUGiALm1sh9BD8UKzAZa5WShTrddv87NzuyoiSAdt
 UPERYgFZmOHS6Ijus9Cq8Ld32CD1wRbjZfsPBmtxAhk3KqSTMnNudbf4QdJbcLdmjS2ve8zuuh
 c9+wVsJ+zFvmpAOj7P9on9A7/no8cbTOhqwKV/0CyBvca+EmEq02lw72a8eVC+1djjrel1Jh5f
 tg0aLuETdsj7Brp9vvLiqmn5NBX78YtEZhWPFkeHTFxfA18DBjSkZeXuHTHOXgSMg4TiFa8lr5
 VwE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Mar 2021 01:12:09 -0700
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
Subject: [PATCH v6 08/10] scsi: ufshpb: Limit the number of inflight map requests
Date:   Mon, 22 Mar 2021 10:10:42 +0200
Message-Id: <20210322081044.62003-9-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322081044.62003-1-avri.altman@wdc.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
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
index 4639d3b5ddc0..f755f5a7775c 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -21,6 +21,7 @@
 #define READ_TO_MS 1000
 #define READ_TO_EXPIRIES 100
 #define POLLING_INTERVAL_MS 200
+#define THROTTLE_MAP_REQ_DEFAULT 1
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -747,6 +748,14 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
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
@@ -761,6 +770,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 
 	map_req->rb.srgn_idx = srgn->srgn_idx;
 	map_req->rb.mctx = srgn->mctx;
+	hpb->num_inflight_map_req++;
 
 	return map_req;
 }
@@ -770,6 +780,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 {
 	bio_put(map_req->bio);
 	ufshpb_put_req(hpb, map_req);
+	hpb->num_inflight_map_req--;
 }
 
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index c2821504a2d8..c9b8ee540704 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -213,6 +213,7 @@ struct ufshpb_lu {
 	struct ufshpb_req *pre_req;
 	int num_inflight_pre_req;
 	int throttle_pre_req;
+	int num_inflight_map_req;
 	struct list_head lh_pre_req_free;
 	int cur_read_id;
 	int pre_req_min_tr_len;
-- 
2.25.1

