Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5659C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B71D66101D
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Apr 2021 06:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbhDKG2m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 02:28:42 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:11067 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235173AbhDKG2l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 02:28:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618122506; x=1649658506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cn80eFxaOEOocvOvD/vJ/p5jRgT1O6ba7LzTf9VBSqg=;
  b=HdHzIRuVEjdVMPbMv3HcBinKuUOpVkHRsDYBwSAsXAgBLD4CmexqQ6y5
   7zrDVcL9RjaZ6UjYCfSGAaT/cx9+Xgz9FMmMoXyUMD3kFKhiMdC5z1V7g
   l1bmj4M5LzIiQDWCwuV3GKsuh1iYy84nuOsfA8G9gn1Psyk79oGY8uWD8
   PuiItOVPYhvLDjoZXQtSQRKW2YHdrBNT9aNhYNOODKPUYyyiscU9Ixhl3
   AeR0rkUUoNQo2d+3IG9LzzSDOBT/rNOrSNS94rLrRR4cDg+EgX4/q2GIK
   KlURgbdHfm63DxrIaKvMzJsxGj0srNzt8/8LqLqBTplcWHwPq+FGcMO8u
   w==;
IronPort-SDR: Fh01ICdvHn3+ff2M6OCJyXzugHxRZEXiJznNu7OXYqoaXxJok6zmmTLMhPJ/s3S73g6htGk1jm
 IhgwkUPw7B07bK1hkWtzg5GFCzxKwOJwX4CcYh9xSU9GlByyCjMRvMuUv++9s18Tt8EaUYx4Rj
 5ap/yMSAf1uHpdRPXu0AyYeqxJfdnY6fTGAKAItudUwkWB/kayYmPg14VE1qxcTi5zHaGJgASR
 lIjY3MXcq0frNt9CHJh/f19l+uzFvRP6phIeadFdMEP35xzPJe68FYSMXFj8wFshA7jkWJSAKb
 OEo=
X-IronPort-AV: E=Sophos;i="5.82,213,1613404800"; 
   d="scan'208";a="164405563"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2021 14:28:25 +0800
IronPort-SDR: oxC3BI1RzVJyFsMWgbl/UjDOHcRsgZk2j/1hS5FqhPxImKzFNrDBYpiFlQU4unqpv9Z+D7xIXv
 ITGALGeA03dZT4A+tf2Hj6+4l6p9gXCmOWXci2RM3idJtMuiQ9/dVHSELj5DyV4Nyv3bJx4aef
 UvlpV504Z8NB0o60cJyFVV5GD3XBUYLFTpirKDdB9tuq/QWSaFzldtmkez5hVxJvMEMpAzh8Fh
 ZtjbJiHRefjn6bbRrSIADGnbIYJzW2Rx7HVlQhFzlIX2vlHOPNyN9p/HtoNMLJsXUU8zTtDHCG
 iKy0pCy1lMpMEwCSWMol2w/O
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2021 23:07:58 -0700
IronPort-SDR: AGxaAL8z/2J1Dv57aOg9cF9eU9iMYCBddHIx6pKRRewFFC7QpnBfXruC5TIEDg+Hf0XeHzLrjV
 Kv1+duySmppkKF2OLdJ8eyv//3oVHwaMpZsmmOKphnAh8PC0IqSvTMxe7SonaRw1Ku4mt6jtcE
 JxSV346gFhYfURSYniPkeGRx9oQJpYzUiPOdw+afFlyLJ/fWXOmo4uNXuwlfkTgRcwAKtcaAaa
 S4xiviisADLe2gUVKNPbpr/2nCzFfpyVoy4t4ZxVRD0WzVjAPMOPEQRqFve04OdD8fxQM77L45
 tIU=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Apr 2021 23:28:21 -0700
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
Subject: [PATCH v8 07/11] scsi: ufshpb: Add hpb dev reset response
Date:   Sun, 11 Apr 2021 09:27:17 +0300
Message-Id: <20210411062721.10099-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210411062721.10099-1-avri.altman@wdc.com>
References: <20210411062721.10099-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The spec does not define what is the host's recommended response when
the device send hpb dev reset response (oper 0x2).

We will update all active hpb regions: mark them and do that on the next
read.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 32 +++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 28aef5acffa2..0352d269c1e9 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -195,7 +195,8 @@ static void ufshpb_iterate_rgn(struct ufshpb_lu *hpb, int rgn_idx, int srgn_idx,
 		}
 		spin_unlock(&rgn->rgn_lock);
 
-		if (activate) {
+		if (activate ||
+		    test_and_clear_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags)) {
 			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
 			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
 			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
@@ -1417,6 +1418,20 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
 		queue_work(ufshpb_wq, &hpb->map_work);
 }
 
+static void ufshpb_dev_reset_handler(struct ufshpb_lu *hpb)
+{
+	struct victim_select_info *lru_info = &hpb->lru_info;
+	struct ufshpb_region *rgn;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+
+	list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn)
+		set_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags);
+
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+}
+
 /*
  * This function will parse recommended active subregion information in sense
  * data field of response UPIU with SAM_STAT_GOOD state.
@@ -1491,6 +1506,18 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case HPB_RSP_DEV_RESET:
 		dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
 			 "UFS device lost HPB information during PM.\n");
+
+		if (hpb->is_hcm) {
+			struct scsi_device *sdev;
+
+			__shost_for_each_device(sdev, hba->host) {
+				struct ufshpb_lu *h = sdev->hostdata;
+
+				if (h)
+					ufshpb_dev_reset_handler(h);
+			}
+		}
+
 		break;
 	default:
 		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
@@ -1817,6 +1844,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		} else {
 			rgn->rgn_state = HPB_RGN_INACTIVE;
 		}
+
+		rgn->rgn_flags = 0;
 	}
 
 	return 0;
@@ -2144,6 +2173,7 @@ static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
 	if (hpb->is_hcm)
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
+
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 1ea58c17a4de..b863540e28d6 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -127,6 +127,7 @@ struct ufshpb_region {
 	struct list_head list_lru_rgn;
 	unsigned long rgn_flags;
 #define RGN_FLAG_DIRTY 0
+#define RGN_FLAG_UPDATE 1
 
 	/* region reads - for host mode */
 	spinlock_t rgn_lock;
-- 
2.25.1

