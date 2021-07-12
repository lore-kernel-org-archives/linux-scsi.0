Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9D2C07E9C
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB08F610D2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbhGLJzO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:55:14 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:33186 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbhGLJzM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 05:55:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626083545; x=1657619545;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jObncAsp+JMdQEIeZYaXSS1wRDtUP2PUPeJ34o4VIXc=;
  b=Og0hydJA+GYbrkIzn84agZ6wjWsemlZydLq7aO19TGy0C87wpNPN6Ivq
   zC1RLtt/y3QOMg3EPr5TVZGuQ31LQBwCoHRLs493YjlcbGmcZms1ngXS/
   H109u98xclD5ToPUIz6QN/r/yuxqzSWkQ8mOGbpBZKbwDC/pM8rk18CNg
   Qc3ASXT9q5pwN7yRIZp8k9jJ3RuN+j3bKg648gEspMFsD+TTi+OcovKBM
   apNXIpdBfTfssDoeMgjuuAJUQ4MXsGFX5IOrt4Zrmd+KYargOfANPYR9q
   9jkpoXbvnSaBiFAP747CLTkayj3MlvJTmt/qpJes3kVbgOnQBR3RxG6I8
   Q==;
IronPort-SDR: p7zr5Zd1XTwGvqH0hUKgYKtDidPC/fK2MazwRLDLSKemMGqe/VJIRwnLGemasRgQSiUWVUuT0O
 KvrNrt7wBvP/6Q29cT2Zw2rW6yTPHIGeJLkC74qjRoNqdM3rAtGgBI4ZMg21PrSLFkemaH6Jer
 o+cQQYpTr4Cdld1u1XR0FRv0PHvQMa+w7E1/oy9IJ1SnUK+ixlKL+q2dlViZ82eaIunlycRMCe
 gZcI8NBAz9gpyT9+ksf0hSDcA9GC90mQQnMSmzExnRdHjXo+Ixh1SZRGBXwRcy7bC7RI6Xv5qu
 50A=
X-IronPort-AV: E=Sophos;i="5.84,232,1620662400"; 
   d="scan'208";a="278155980"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2021 17:52:23 +0800
IronPort-SDR: PvGWsHkSrNFCzslH2B9CFpxQOFQvjLa2QbKsF5GP8GOu7Yx2nof5MCtUOVCitQDBbIh842k2b5
 CM2QADRgJVBvTO6Qwm3oMtNVwt7yoTu97MmNExKhZ55HYUO1AZRCf8MCJIbxGpivjtX1x+/iPH
 mjCO5CyBgy21N0k6DHqlnXmJJ6EM4112tAhv5qtlTOdtUPb8WJFcMW8vn1VY6pcFNPglvGvrMl
 yiVd1kc6AZW0gh0o/MPxiYKGEXG0a9LxY3YncmPT8tztttdhmiXKOsrzJUTwDCQ6vzo1buKXjv
 sZTMLFcgMb4kNW4xZDFqrUJK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:29:07 -0700
IronPort-SDR: HS/Szc3ouw9r3j2JN40ob0pHNQid2sPOnbLcf35TmP/vOrBMoVmkMy/FMsFelS6q6NbOmA71BP
 4E75Xv6W83xfV1yg8dwM2lAceQt6rKDW7xlNRN2zKH/f5SXaM4cvunrsRBDkW7YsZ7LtVy+NYE
 caygD7LbvmfmHoNt1P9d8EDAsnO/9XFMkphB+z31DNm4UhkuS3kDx+B/sdJujBSYhf2Vw7OS5a
 KVkzR1o4HiLmm2ksLTm7iz/rAN9JLzNYfE5uA5mrHC/ZJP5ncIrfeYTM4dDgWC1tdKtcZgzWqS
 cBY=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Jul 2021 02:52:18 -0700
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
Subject: [PATCH v12 09/12] scsi: ufshpb: Limit the number of inflight map requests
Date:   Mon, 12 Jul 2021 12:50:36 +0300
Message-Id: <20210712095039.8093-10-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712095039.8093-1-avri.altman@wdc.com>
References: <20210712095039.8093-1-avri.altman@wdc.com>
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
index 4138f081d1dc..472633052af1 100644
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

