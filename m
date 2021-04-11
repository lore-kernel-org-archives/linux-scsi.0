Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D24FC433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EE5E611C2
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbhDKG2f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 02:28:35 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:46956 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbhDKG2e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 02:28:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618122521; x=1649658521;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c8dspGgbwbxAFjlh/X7gkBtjw1xkLXGeVV/u/PXbzIQ=;
  b=auGfpeyem+BPyJ2UOGjEk/2VwNGdSe1IrlyIspQp4SOewnNehswuMDIh
   s4JYTne0KDzqAJAn0AC1qyVpLtVZ/RlNleltb4l82wdlDVCs3C11hsBBr
   pY/ddKz/LMgto5xdVjbZ3AAAsldfwfBikKA91qvniWcfPa0C+T1zarSDF
   NrxJPlJ3TISon1hIySsejx7bpCXgSP4vfNCrQrOmXX8cFtJD6Phz7sP+M
   PAOYkVbw0Ghf+YmYMnxui7yEKi/W7i/7FW1Uy/QaSVRNO1WIqLiA8Ccn9
   tISTYwnNovz6UG0n0VQSHOx4aaP+uXubLusqOsYlHxBI+aNZurDpt73gz
   w==;
IronPort-SDR: WeiyXJjvWpDl9LrFDBLsZRZj4V18dJPJRncmzCy0uHuYgDkhHzyz/yjSaG0P4W+KKZfJdHbL9g
 FGnvoeVHJD4vfXjUjWasWNeaTOclHdD8xvUFayFsMMx824dnEqLHFel8knE/8hIVraSGBWYI/n
 55e9uHf4ZLPvx4Q5diQnGookSsQAtFpTiGL7yM0G/uA3golx4pexg90i0fXZN1wjezAHmQ+Hp2
 yQ3hMkE/zIl8ScYAF9HxeOOThL33qku7TK1OIv8cDAK+VMktriIhP7m5aVGcckwjvcbLrWFRxk
 bho=
X-IronPort-AV: E=Sophos;i="5.82,213,1613404800"; 
   d="scan'208";a="268668873"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2021 14:28:24 +0800
IronPort-SDR: nFOzTUX4TANwFnqfpAoYgB10myP8Oq10hjz8VVG+pcJX14eIVx5xam/v/cY9mf8ZkbOqx9ZdRp
 GbRuWU6cF2h0vYCQYDU1j3PfFhnfC2+wPs6ELEiFdCrQ6KxQKd4g13QQ+l8dn56WVV1/v5YZg2
 VyokpPC8Qgar0YOt0f3IQPK9T4EfXOpcx1S3wb1HQildxxoHDjVUVOnzYM7x27StcLaH69f9sz
 WMJrwUsy4hfWWgFh2AEWwLdn1pnjQcn9Q0Uu1O7Pr4/olqOl6VHwUmXNcVzDTXa797YMhGo7/7
 JAszCaCqvET3cSZkjGL+6CWV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2021 23:09:07 -0700
IronPort-SDR: SCNfS1RvX0BBmYfGMnTHehR55oVb8Jg5Wd6vH5objZpUIfNx+KizVP1HtrACX/T0xlvAafOUMx
 YmvozW9bp/hp/C6fakMV/oSAJLlMEzFfg1olHHT9d/teAfO2k68NviH7ftrHiUf5DDSJSyn7aG
 BykSXpfYxUUUdNV6vFmFd5eyxZA4lhUaTsbZYnNCRcmGYFUVLDN1uoKRZnd8tNSdwXd1Az5Q/Y
 2kA348VAxn2QpZuLXd/Ay4t42yUov2/TqkcgWpTPv0Odj9MnF6JqndI9mUYmmGb40TRUYdX7VR
 0jA=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Apr 2021 23:27:56 -0700
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
Subject: [PATCH v8 03/11] scsi: ufshpb: Transform set_dirty to iterate_rgn
Date:   Sun, 11 Apr 2021 09:27:13 +0300
Message-Id: <20210411062721.10099-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411062721.10099-1-avri.altman@wdc.com>
References: <20210411062721.10099-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Given a transfer length, set_dirty meticulously runs over all the
entries, across subregions and regions if needed. Currently its only use
is to mark dirty blocks, but soon HCM may profit from it as well, when
managing its read counters.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 6111019ca31a..252fcfb48862 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -144,13 +144,14 @@ static bool ufshpb_is_hpb_rsp_valid(struct ufs_hba *hba,
 	return true;
 }
 
-static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
-				 int srgn_idx, int srgn_offset, int cnt)
+static void ufshpb_iterate_rgn(struct ufshpb_lu *hpb, int rgn_idx, int srgn_idx,
+			       int srgn_offset, int cnt, bool set_dirty)
 {
 	struct ufshpb_region *rgn;
 	struct ufshpb_subregion *srgn;
 	int set_bit_len;
 	int bitmap_len;
+	unsigned long flags;
 
 next_srgn:
 	rgn = hpb->rgn_tbl + rgn_idx;
@@ -166,11 +167,14 @@ static void ufshpb_set_ppn_dirty(struct ufshpb_lu *hpb, int rgn_idx,
 	else
 		set_bit_len = cnt;
 
-	set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
+	if (set_dirty)
+		set_bit(RGN_FLAG_DIRTY, &rgn->rgn_flags);
 
-	if (rgn->rgn_state != HPB_RGN_INACTIVE &&
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+	if (set_dirty && rgn->rgn_state != HPB_RGN_INACTIVE &&
 	    srgn->srgn_state == HPB_SRGN_VALID)
 		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
 
 	srgn_offset = 0;
 	if (++srgn_idx == hpb->srgns_per_rgn) {
@@ -592,10 +596,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	/* If command type is WRITE or DISCARD, set bitmap as drity */
 	if (ufshpb_is_write_or_discard_cmd(cmd)) {
-		spin_lock_irqsave(&hpb->rgn_state_lock, flags);
-		ufshpb_set_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
-				 transfer_len);
-		spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+		ufshpb_iterate_rgn(hpb, rgn_idx, srgn_idx, srgn_offset,
+				   transfer_len, true);
 		return 0;
 	}
 
-- 
2.25.1

