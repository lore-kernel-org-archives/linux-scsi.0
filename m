Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2C0C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 973A7611C9
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbhDKG3W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 02:29:22 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:37489 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235229AbhDKG3V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 02:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618122547; x=1649658547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0UZeo9TQDrA2E3f2IoxL7Zq6OFWwZ5enXMf0r9iUqKU=;
  b=XY4zmnfdB32t5IN7C6DGGj7IDmheNrtbW5LTyOvb6pmXpxg4we6WYJew
   EfNCT7VQZDsoRlIRAiuxnC+324kL93RYbAVoeE2uNUkP7BtjfWU8U6O7U
   K4ruWSK9jIQmeRaoRun/k+au7Ts2YM99mv7BbwCFNGOp2ghLo7J7KMRV0
   x11nqD/s5VamwmbLWRZxXZMVLQm3dAzSh3a2W/qBDcLxlQhuiwHcv/nKS
   t1whqxSUNjTkrG8wWGH29Q8Q3qjDr/XBJP0DZEk7iSndez6kbKW9F66bl
   gqLjaMoenyXAwwaf4pUVMnA7IT7yC53uZLHKFsobVGyITSOueQf91Mh9L
   A==;
IronPort-SDR: yo6bRKRoh4Emw2794dO0LwmoPU7vJeabWFCZ0NeyBR44j3rxkFm4+Ul+2+mNOH3Vko45B2W6Nh
 2G4oeU51SamZxGqhGnwPQJIqzMIgiA43MeYjBCUrdlPKLaPCfX2IxhcuEd5ylUzGzpJywa0dZr
 I8hnkA3AJlxbhOS4q1qtMid6MjubQ6NYJjB77P6pMqdmSFs7d2kRdvY66ZHV7rDTOiP2WPs0wO
 olKIx2kL7GbWUeTtDY+rrGsX/VnlsJWIb2Ww4SvRHMXdxDC6RQ+lvx4nyoWCvFpzH1Eo3fiRLH
 3mA=
X-IronPort-AV: E=Sophos;i="5.82,213,1613404800"; 
   d="scan'208";a="165243171"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2021 14:28:47 +0800
IronPort-SDR: zFv/BTLGgbekTnYs7OTD6NfpjO1d63yv2FwUSEiCFphZoKlU/TRmkZZSLf4p4YYXXluOhO2lj2
 aoJzjJYRufvHO4ZdiRdeaEosxcHsQ0HYlMBAWfMImOsAjMMO8aERQidTQpmW6GNI6zduiOBKD6
 kSUkwtVNcNq+kclIq4Uu1dKW0a1KFrfPkU8x8j24WzzMHLx1CAWYNNQwOWIv9ihKIq5dBDbt4Y
 +yMqLgxHDVNVmsCBqA/l1zXciBVifpg7l2WhYXMqIVJBhjXi+8CutK1sMjkkGh989g6R11iqq0
 tU6CW8v0cBKPH6+0fVkgHjq3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2021 23:08:10 -0700
IronPort-SDR: C8yhFzzFapXYqTAGcifNdWCaiEZeCJ7fNJdmU+t43i3zNUYT8iPGTkj4uhxjKpHJNYgVr0Cd2/
 ul85c6p1TcL4Io+DNSHXEXRmD8UrSJYXPS0WRVoxdLEpm0RHcAcQH8Nd9dEIqk6SOHsdwVQ2yv
 xxaJjoHTNaGkhC6BHBSgGBL2oKW3q9VYOwR7pTMjgmlLhoq7VNLmNF3X1RZWa2ZqtewduMKlE6
 CXm++bH12Mn/z3yIJCZSisx79Lzt4CvLw1Qjdbo19LJSOJJup24OeEC2PIN5eLrbjWBajBXHqd
 2ZE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Apr 2021 23:28:33 -0700
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
Subject: [PATCH v8 09/11] scsi: ufshpb: Limit the number of inflight map requests
Date:   Sun, 11 Apr 2021 09:27:19 +0300
Message-Id: <20210411062721.10099-10-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411062721.10099-1-avri.altman@wdc.com>
References: <20210411062721.10099-1-avri.altman@wdc.com>
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
index 8d067cf72ae2..0f72ea3f5d71 100644
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

