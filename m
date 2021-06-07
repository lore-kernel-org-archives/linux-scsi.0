Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF79CC47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8E6461164
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhFGGQz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:16:55 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:24879 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFGGQy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623046504; x=1654582504;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7Xj0TsC+kDWP3MaOssYqB1aCtL21OM+5VdbGe0c9GsI=;
  b=JD+zJg1m0l2ED7U4bJdQPuNWineqVpm3jlCnfy6+9ZFC9Apz1F7Ac9nf
   XWB5SeVJJOQR208pJzz6E4vK8ss6uyaSXrk6/Tu0AG5d+EQmmuFKwya+/
   u0fTSYAEojV6rsfLnCMBzHcp4NKVzYGhPtN7W47q10jef+fP0EcT2ISPL
   mnROtzptIl6y40MT4QAodg9Uga3qiNenHbtRxhNK6xgVXgNb2A7gKpJJG
   hymoJLY5YC1nQC5JTfy+3w9BnVTczqV7HA0JVyvJU30CEsxqIlhhm1acZ
   v/RDxg8G4v3WkD/anpcvA1guz1q4v5HxATagJKqGQIDYsF4syH8r9UFOd
   w==;
IronPort-SDR: 7mq/T1lEonA3mUiuJxqkhGmGIADtpKonfCEHTx49FmSYe1L2qd0gs90Z9DxTwVMyZSlPMHF5uJ
 nlM2R34a0d6sGVhfcZ25osvTMI0nqflLJnxRwTekxyzTOUA1D1Uy2eFY9vFNM2AFmfOPGjL1o5
 a2Ef1SLxq/Xd1PtpvqJRIawECqhk8bZc574nX0wvHJD4TZEHr4MZF5+EWFU/l+kFkbY1028yHx
 jad3FCbjk4Vtngpklp5nQYxXh8aqCjZQVbjJdn8halDGoOivsKRdFxBPx155T6hhyw/oMIQh/w
 7fI=
X-IronPort-AV: E=Sophos;i="5.83,254,1616428800"; 
   d="scan'208";a="171530283"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2021 14:15:04 +0800
IronPort-SDR: lv0FYk8FgdfdFQwR31Zrr3bJ/2Da/O0pDCzRl7MLEY1/qCq/mS6ClpA6Xuro2UP0+X7Eg0yN4w
 ixKz1rcick9D6qFAortM0/qJP0LFqksuSEW8J/J3nQrwBvklLobYfnvNMzt6qAEoEJ6LhHxorl
 wqufmBWpa6Ej/IcqRECQdZEvG+0xGX0BOYmsNuxAPCj6ndB7nVq80nr5XVjVmqZ2iHE4oT9pX0
 cmb61OzUsbfqTEk4xprInL02Kaf68Z/S9QZIOhkiHkh+bAWNAqEDs2dk1Amb1o88RPFYFsMDw3
 rNgi1VIOBLXgLrEYuEmBfSx7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:54:12 -0700
IronPort-SDR: gd1OIIr7v/Bf7TTFhdlhaqTjcP5UBQ2veTwCMmqShR+WsxaJR6Pa7XpwslM57f0VUUXLM3557d
 IyQChCvlpnWu20mhfGa5wyCpEGN919XQFeJbgcF5pIKJOSit/dQpBCipthLQhBDhZG6IzKna6x
 QPk5tEb/O7L1nA0phwThANEsYDo0sAqm8/nXEADGtAliVtqzOoR9se08yu1Aq3akc0q6s5MZaH
 a8wKKdqO3t0Y9qv9ShKX4sdwZuWTFDzkuvvST5lPTu3gZP+3sOqqTRzZvtlArDlSClDonkLyfr
 OOc=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Jun 2021 23:15:00 -0700
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
Subject: [PATCH v10 05/12] scsi: ufshpb: Make eviction depends on region's reads
Date:   Mon,  7 Jun 2021 09:13:54 +0300
Message-Id: <20210607061401.58884-6-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607061401.58884-1-avri.altman@wdc.com>
References: <20210607061401.58884-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In host mode, eviction is considered an extreme measure.
verify that the entering region has enough reads, and the exiting
region has much less reads.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index b080bd9ca35a..f9efef35316e 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 
 #define ACTIVATION_THRESHOLD 8 /* 8 IOs */
+#define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 5) /* 256 IOs */
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -1057,6 +1058,13 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 		if (ufshpb_check_srgns_issue_state(hpb, rgn))
 			continue;
 
+		/*
+		 * in host control mode, verify that the exiting region
+		 * has less reads
+		 */
+		if (hpb->is_hcm && rgn->reads > (EVICTION_THRESHOLD >> 1))
+			continue;
+
 		victim_rgn = rgn;
 		break;
 	}
@@ -1229,7 +1237,7 @@ static int ufshpb_issue_map_req(struct ufshpb_lu *hpb,
 
 static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 {
-	struct ufshpb_region *victim_rgn;
+	struct ufshpb_region *victim_rgn = NULL;
 	struct victim_select_info *lru_info = &hpb->lru_info;
 	unsigned long flags;
 	int ret = 0;
@@ -1256,7 +1264,15 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			 * It is okay to evict the least recently used region,
 			 * because the device could detect this region
 			 * by not issuing HPB_READ
+			 *
+			 * in host control mode, verify that the entering
+			 * region has enough reads
 			 */
+			if (hpb->is_hcm && rgn->reads < EVICTION_THRESHOLD) {
+				ret = -EACCES;
+				goto out;
+			}
+
 			victim_rgn = ufshpb_victim_lru_info(hpb);
 			if (!victim_rgn) {
 				dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
-- 
2.25.1

