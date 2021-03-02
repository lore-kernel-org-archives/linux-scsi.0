Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C539C4332B
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4274764F1E
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381111AbhCBS4P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:56:15 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:19087 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446197AbhCBN2y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:28:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614691734; x=1646227734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=waigJLGe+aCgbuib6LdVYw7L5S248c/bP/DF2YgcfCA=;
  b=gbKhXDdn3Gnq7FZbdpzUUV9wQLaCdnJp4Pv/U0Jtzljj2KoAsOmWFpjd
   st3hHLfhOJPm5e9srevHLIOY7S70KP2QzYYZYe+rvsp5XsxDODkdxci3v
   QpQYJpcLru8h7pTOjij3QaXGCwA15RAEIxVLgfdjL6h5hB0DMtoDUyKLp
   y63lP4lfAwHs/9x2tYvYnSYtS0HR8/NNTAAWVdwy2gLbjD5vwXrAqIDIH
   uOoSDnQb575jLzfOSN4D5SoBRWwLTp2CwBVZYClaLY4bJHQv4xDZT2Wfa
   zFn1dNLkRUfKnKMBj6JkoImT1xPPqNmaRSK8n9bDuN6GoAc1KwsiqtQsy
   g==;
IronPort-SDR: uOw+JiB99itxMPbjTZw9hMgKtZ8CqIPTAbcYI0862+dDGM8E+wt+U8/SMoC20cV0x+dDG959MY
 9HtMz4oCGvpJvj7zsdZubGLS6oMWlQJaeYDhwXu11WJUR0xsuIiVAUAI0prWLNzlbzlsvJ/sVU
 gzY7zRET2Bf/nLL3XBYNmwwJggBUQpBIsYcKm7L0lrDmBjbqVnBLRXhKLIk1SRvVJmiAAcm6pN
 JwDk4u+qncGRUoPNZx/hz2awB0lwWILAp1j4xjtGYfoBVvoXuXUEpkYQ8DPgEy5mfUWOMHZP9P
 kEg=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="165637146"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 21:26:54 +0800
IronPort-SDR: 8bzjK3gCNuEzLSRYJMDrEUNHh9qjx8gUnrHwsHBqyGSpjhjseMf5PujWZhquv6+cgCZ6koyhLx
 LhqXkmF8csSAwB6LxIEHmo2aLsxg4FVxk+vhkPSw1E3LnIQLB25LNwxVVMUmV8fh8Gzw88TK/q
 8V0otNYJVlDyUiBTVW+yVLIJxoC/dLmGLeb4UB+OH8lZTeBoO88TqA0oiLPzLdsmoU+qakkHDT
 Ej8jpZ0BMT3BSucmpKfAEdWY2BmGFEVnfZrrpkFqzk3a5JRFgfWseK71qNoCgerKlT/eGWNaDT
 ORh2gfaEVI9QkSVMsyMqJDZ4
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 05:10:00 -0800
IronPort-SDR: NPhnFLu4BlcUed2FRu5b3AdXAnZK+fPfIkxA7l1f3AJWlhwWcgrWEEEsXj75NUfmEsrGYE6ugr
 QdW72hyIXAmJVfZJhge4TvRP8t6OgsGVYgKuXwNj3mugoGwb2sVblA5B48xdZXZLFD1Nc7W5K/
 R72zG0vnDNkt7Py0KRCMqp60c2THm5Gg63IiYIF+DKOd7mo2C4fVF/UnmcZwrAMwKtnh5nmQCN
 gJr01SgaBaER6bNR3VRtlkPetXrZ2r24fcn/GvKzikZeBqjtDP36oXWbcVNdEw9MHs0tYXrxoE
 S1U=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2021 05:26:51 -0800
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
Subject: [PATCH v5 08/10] scsi: ufshpb: Limit the number of inflight map requests
Date:   Tue,  2 Mar 2021 15:25:01 +0200
Message-Id: <20210302132503.224670-9-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302132503.224670-1-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

in host control mode the host is the originator of map requests. To not
flood the device with map requests, use a simple throttling mechanism
that limits the number of inflight map requests.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 11 +++++++++++
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 89a930e72cff..74da69727340 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -21,6 +21,7 @@
 #define READ_TO_MS 1000
 #define READ_TO_EXPIRIES 100
 #define POLLING_INTERVAL_MS 200
+#define THROTTLE_MAP_REQ_DEFAULT 1
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -750,6 +751,14 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
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
@@ -764,6 +773,7 @@ static struct ufshpb_req *ufshpb_get_map_req(struct ufshpb_lu *hpb,
 
 	map_req->rb.srgn_idx = srgn->srgn_idx;
 	map_req->rb.mctx = srgn->mctx;
+	hpb->num_inflight_map_req++;
 
 	return map_req;
 }
@@ -773,6 +783,7 @@ static void ufshpb_put_map_req(struct ufshpb_lu *hpb,
 {
 	bio_put(map_req->bio);
 	ufshpb_put_req(hpb, map_req);
+	hpb->num_inflight_map_req--;
 }
 
 static int ufshpb_clear_dirty_bitmap(struct ufshpb_lu *hpb,
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index b49e9a34267f..d83ab488688a 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -212,6 +212,7 @@ struct ufshpb_lu {
 	struct ufshpb_req *pre_req;
 	int num_inflight_pre_req;
 	int throttle_pre_req;
+	int num_inflight_map_req;
 	struct list_head lh_pre_req_free;
 	int cur_read_id;
 	int pre_req_min_tr_len;
-- 
2.25.1

