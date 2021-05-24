Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318C0C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16D99610FC
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbhEXLZG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 07:25:06 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:43308 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbhEXLZA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 07:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621855431; x=1653391431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=90KIGp0u2Y2Y3vVUouBxy6qJk4x1dGxUCOvkrKN2kss=;
  b=FOP19gndmDlayomVuiJBvSayufpHsQRb+X0fctBpK4zuySgfbXzu5wOe
   rlHO0NZtQp0jq8wSKeShWz7q6MnT6uLUHqW08PnLlX9F9RSA+ggt3uRoS
   hu5nLeHHI+97lebtp3unijhNCi9JqOMDpu9tlVPrmVQ80FFj7AUhwuijz
   tcw4Tg3DajqKJuAaepWcHzakZ8gnqvXTM2SdmUim69cD2BEEPfHY0t53v
   Gu1Mb1W2YCPd3KdY/iFNVWDb6IpAai9T7oB4CWyOzfIrBMQ0ThBLapNEn
   Ark7MhFr+lUO13w0e2mms3ZyPtIOCOsW2H7eNpwb6gPvupuypUFbXs0+x
   A==;
IronPort-SDR: s5ADGYxlVAPey0uxSahbjO0+eS793lnX7iHVWtpLbmKsSnfedvLZiJEOXJdcikYe9F6s8pCjRK
 X+Ziqw/G/KQuZZbev/OXxa8Gw6DGYJthR/yISlLFZOrFYSV/pQKKYu1D1l91X4Ejw+REzk+cJM
 yOhLAUee8FUdjJFSXMEX6KWZMN65vR0/5hZbu24HUsFrSfBmqYrZ9u8tG8YK5bh8c6LMQEjn+i
 r6CnUZL/r6iiSqcoH7peGmvhyo1r0ca0m0M+GTdJGfxscTO1n7LIAUfrKwz0zFcgNXcv5TShjZ
 dx0=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; 
   d="scan'208";a="273140565"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 19:23:50 +0800
IronPort-SDR: deIP+qd8pl9i6+8E/9dmSFG11MUCvQrGfZid+nNhzC+R/ZniZMKYRyGZ+vfMefQQ0YAgCSNKEu
 cd6AGKZ6fug76dbxgDYrMYQStc3/KtnDzgrg+E9FoyfMs9PZM8mTXN6myfQ9SxQ8KvCk/zy1ac
 mOMtXBEWMm0miLnunHu6oEButgmKUgghstAKIkl6SQt9K3p28ZY+TzojvZwmW0EB1gskl3h2U1
 nwP7mcAAjL+78lhmMLflyAgn/0Lqr0PE8y17NNm4biGtIpRa5Og+FH8sFoGV6oXdHQ2848MMIi
 p4RRjY6xy8I+lV6tIekiHq0H
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 04:03:01 -0700
IronPort-SDR: iLT3drKCL2pvSMIqikBWnEScoLKsFVLcGU8mpsBq0xipQJqG6arxzsGY8ZMxpkRXi888fzZRn8
 X9LdK/zT4AYlBQ9IsDdKtNp8AEnemQD63B3ltQgT/tGZ+Q1EP3QU/WOc9pRw7AymG63OnzwOr0
 7aHPbbqNz1M4/978xZxKScCbiUf5iUcFRU3dKMXHcAYgWaUDwks6LeY96DDG9LITrR5Up1/5RZ
 /xce6IBK+oQ3VeWKP4Wx3NCuD0TdbbmrY/0jzT5xD7u8vkABf+6SDLoqI+k4paUL1BW9Rq/Az6
 CjE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 May 2021 04:23:28 -0700
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
Subject: [PATCH v9 07/12] scsi: ufshpb: Add hpb dev reset response
Date:   Mon, 24 May 2021 14:19:08 +0300
Message-Id: <20210524111913.61303-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524111913.61303-1-avri.altman@wdc.com>
References: <20210524111913.61303-1-avri.altman@wdc.com>
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
index 0d010a343f34..73e3fe89b5cc 100644
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
@@ -1415,6 +1416,20 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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
@@ -1489,6 +1504,18 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
@@ -1814,6 +1841,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		} else {
 			rgn->rgn_state = HPB_RGN_INACTIVE;
 		}
+
+		rgn->rgn_flags = 0;
 	}
 
 	return 0;
@@ -2139,6 +2168,7 @@ static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
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

