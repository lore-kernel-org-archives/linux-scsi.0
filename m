Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C29C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB9AF61164
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhFGGQl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:16:41 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:24858 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhFGGQl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:16:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623046491; x=1654582491;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=um+wQRj2JYLUF5LWiN+y2eGDfcfnvZDTGj3nbheNpZs=;
  b=a1wTQT81/YVIt0ZYYceSMiefpxCYXlcu9hTIoIuY7CTR9K66HXf+6FGj
   lTDovg9dkh0876K6UQJccvqo0sIGKUe6NxpqjrildylnzYuIlghXuSKoW
   ao1J9VUn2sHeR9fqcJcXrWxJRiUFVwhSymbxkepNCG2wh5VIk0nKaihMf
   SwPXc2+IOEgPESAcy22RsSscbv1g8H3zynl7dpgFfCyCe1efnFAS1f2iJ
   3opG11UBY69O64Gq3Aq0wmUA9C326kOyINOfF9Z+8+/xv7D78WamPOS/Z
   zVUjpnk3CVUET2PdXFUQoVhv0TXjJ/jlJnE0f9gjEA2SKZBWBBYCM6reY
   w==;
IronPort-SDR: nh1xG4cHH8VII9sYr9FemQbv1bB/kvQT1KGFo3raqtQ1j/+QexURcG9QJkdngZTxN08U736Wo8
 wIeRYOvbT+MyNF/2P+rIOD9z49wFV0J5sD90KxRBuNLBUNStCstEdxaG7P2UEiw0JbHADhnRra
 u0/o4wMDEk00VWPViHFizbdIAnyMAJIXz/0x+lm//z8T5itpQ7VlA8odMHt26jxxWbtb107HQ+
 2/gPAria5tCEW6M3I1fdyTTPO/MpSeSFmdagUeFZ2s3s33xW48wIK9gH8nRYiN95wrOMQFzD4D
 V2I=
X-IronPort-AV: E=Sophos;i="5.83,254,1616428800"; 
   d="scan'208";a="171530264"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2021 14:14:51 +0800
IronPort-SDR: wtq1VG7qNrDlK3mmRxuCGg8cO4ly88jp7F4LMXQckZT28meIGJ3UQNK6InM9EA/D/h+qf1u2LQ
 3dOf34GZEMj/FrKaiYMW3cfcvA4dcb9CyxL+toUoO7y7J3DpNw/WpGowlskV21E5v8TwPe23t3
 iVc7lLOl5Mr/Nm0wpEvHdZuzcpMaqePpGkoRvUS/lJFokKKgtnAj58+M/0InWAufb3pvw+U9u2
 NYu4ZB7Sb1WvMWrdJFgjGQw640aMz2YC5AYaW2hWQduXpOwcW5S929eo7DWvShtE4LvjscecDc
 DSOzESuuKZ6qHiNV1iA//4nf
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:52:32 -0700
IronPort-SDR: r4f0BotFgqFvD6TPDDjycWzwmDZpe8r2VaGTPxT8xA1m4PVXlapLJcT8prsWScBUlzddVq+wml
 QPIa0Cb5nhXBJQYPhYTyjCzi66VBWfhDJ1QAzowsEqV+yRAijM8Afhy286MpBb/DXezna2LzQl
 5ngYFWGyUm5d7dCDEKeDh6EVpJEy1OK6BdLUdt3q2kNVvc/+r7F/fo+nqrlbcANC5XU/yQBzX2
 9shmSY+zRXwcQPCWSaR2zw+gFyHVgkW45c/PVb/yjClHdTH7lna03CN4inlZl3vJaeUboTRYl9
 TXE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Jun 2021 23:14:46 -0700
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
Subject: [PATCH v10 03/12] scsi: ufshpb: Transform set_dirty to iterate_rgn
Date:   Mon,  7 Jun 2021 09:13:52 +0300
Message-Id: <20210607061401.58884-4-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607061401.58884-1-avri.altman@wdc.com>
References: <20210607061401.58884-1-avri.altman@wdc.com>
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
index 6f2e3b3c9252..01a4efa37db8 100644
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
@@ -590,10 +594,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	/* If command type is WRITE or DISCARD, set bitmap as drity */
 	if (ufshpb_is_write_or_discard(cmd)) {
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

