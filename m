Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2B4C432BE
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 09:00:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 806A36101E
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 09:00:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhHHJBA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Aug 2021 05:01:00 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50640 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbhHHJA7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Aug 2021 05:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628413241; x=1659949241;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=6ckMymG5o1S46bRTSu4+L6KdLd2CCDjNoNaUAb7hSRk=;
  b=dcBnwgrBvL5t2pRKPtMUM7zBNMvNTRDphBg838nu43K3mxy9+2kZXeoV
   jy7blhym4nXiy1AE4vO0bzjQrGpZhRvlG0npTbbm4QwgshBAxQZFLi3ol
   N4ZlCeNM27hwF8u+qXwNAOvaWpb0H+eqhQb3Y92GEDv3gb/cQ8q7DSbda
   7DlytKEpMNeunJ/Go7O79kb94CwTyALNuskrc7MTVfJ2og0IQt1X2L8Wu
   J49mZjzXrMRvnSWD7qu5UYXPhCntBKc2ebatndV3JVe7b8G14NXWikVSW
   G2qqOq+RTRAzvbfHbsHq5jgcvuZhaTYq9yr2qxReeOOG9+AsV8+erNVWv
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,305,1620662400"; 
   d="scan'208";a="288167978"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2021 17:00:41 +0800
IronPort-SDR: 83u+PghaWSpWTABALpDE6br5GmCpYrJraOBLy/zpm2Ok/GSRVKw7j4VnE9UMitkIxCB2Rs1nLq
 DpN6mSfYjWSWKH7OO27qwMiR2bLhhnxtMLDousAHhSWnXLC4EEYGi6arTvSjgreIzRRo0kbW3E
 oBGopc2Fu/hMj2Q5erWhcyYUqvXIsWA050Zmw28W/SKSgJAKk4kQIfhIVt5VOAIg3H91jTr4rS
 keQYTA9CG2kOGVd7BpoQ0z3LcPweMrUsEHDnylZrcCf3Mb3E53Fb6osUYIAsBb3hcJK9CChYAe
 /Gf+wRUrRK8BaB2s6cGU5tri
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 01:38:06 -0700
IronPort-SDR: MvainrtFaVLAlaDkMytM+8LF9gvdmrlqkrT/wV6jpXD1nWsc4TeRvFukgzLfjVaUjHasKLvKFT
 WDHxA1H0hDLy3qEtoPpbmrrr5xyBuNNvC05RJ6dXbTF5vwn1iCcIUpiLTUHmen+b2vs7MLF+4D
 2iI5BqrPFAN36owde/x/BR8zltlpwLwxOuG81tb4Mmqz1ectgltpbyutRe5Uc6+x4h3rOGxZKM
 Q17o/i2EB3iTltrsoQlZ8/rstvW2joLaTq2fBImo2dIH7o7KH3oh7xjZUteboqKE1SGMq4O6eY
 EoY=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Aug 2021 02:00:39 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 1/4] scsi: ufshpb: re-wind the read timeout on every read
Date:   Sun,  8 Aug 2021 12:00:21 +0300
Message-Id: <20210808090024.21721-2-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210808090024.21721-1-avri.altman@wdc.com>
References: <20210808090024.21721-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The "cold"-timer purpose is not to hang-on to active regions with no
reads.  Therefore the read-timeout should be re-wind on every read, and
not just when the region is activated.

Fixes: 13c044e91678 (scsi: ufs: ufshpb: Add "cold" regions timer)
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index d0eb14be47a3..8e92c61ed9d4 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -178,9 +178,19 @@ static void ufshpb_iterate_rgn(struct ufshpb_lu *hpb, int rgn_idx, int srgn_idx,
 		set_bit_len = cnt;
 
 	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
-	if (set_dirty && rgn->rgn_state != HPB_RGN_INACTIVE &&
-	    srgn->srgn_state == HPB_SRGN_VALID)
-		bitmap_set(srgn->mctx->ppn_dirty, srgn_offset, set_bit_len);
+	if (rgn->rgn_state != HPB_RGN_INACTIVE) {
+		if (set_dirty) {
+			if (srgn->srgn_state == HPB_SRGN_VALID)
+				bitmap_set(srgn->mctx->ppn_dirty, srgn_offset,
+					   set_bit_len);
+		} else if (hpb->is_hcm) {
+			 /* rewind the read timer for lru regions */
+			rgn->read_timeout = ktime_add_ms(ktime_get(),
+					rgn->hpb->params.read_timeout_ms);
+			rgn->read_timeout_expiries =
+				rgn->hpb->params.read_timeout_expiries;
+		}
+	}
 	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
 
 	if (hpb->is_hcm && prev_srgn != srgn) {
-- 
2.17.1

