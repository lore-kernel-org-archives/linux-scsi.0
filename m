Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7313C49361
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF9A061356
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhFPLb0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 07:31:26 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4793 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232533AbhFPLbR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 07:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623842952; x=1655378952;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8W1qEu1Mr+hQwfZ6EHqBvEoeGG8HcxcW7lQTa5SQp5A=;
  b=lRKO2RlVP+YDvLUT3xe78XSvbThnnit9b3GBLxecjB8G/IrjuandlAn8
   dCnB35dZCLOkFJdnhXCxuV7M/P1lwj1x1/7ZZNFtttenqEVpepq1ymzDZ
   t+QRUXh0Xk9r1qa4YAiR2Ut6vXv/rCkVdgx0tlmtG7njqeH40caojKhRA
   E6/BXcGY/TsWy9n4QZYnMUaBWZPvt6QzdeuGlJ8n+S0CZNeBiXXNUOtbA
   oKldq1Dl2kp0+dNNISPv8MpHMcoxd9F4wYIriRrdGweacQ+ZcF+9KcUvL
   oV13ckWfZ8uRafrEAYtJvgeRmAmAXyHt/WrXlGfvaoXl/UUikxAERIoEf
   g==;
IronPort-SDR: bNI4iztcfvIza+6kONRFLmyRFH+jkjlD5oHKxFLRFse12arRwcX/sq+X5XXcjENaI7bRGLfUbB
 jGDaKPiC1CE8J+Y1f2CBkhLSx3PFRME+3w4orrgmYlYj8TuhZdZk3INj+LTDd8bk5NiqXjmzUc
 265PM+QZBCAwlZBiqvJ5ob1ObKj7SwsioiRrQRZu3cbJfh8n6xG9bdEGPSNEoqHwSSS2ZtvqvZ
 0tY3H9OMJNW5F3P5TzxEP/Il8wmeAg3GrmrmVLtva+Bk5MLH5qXjBby8XSV/Ts5vMVZJjhUo9l
 cew=
X-IronPort-AV: E=Sophos;i="5.83,277,1616428800"; 
   d="scan'208";a="172653706"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 19:29:11 +0800
IronPort-SDR: N/mAOqTnPY222VlaEsdNVtNxZlIyZIFoayV5vUKRUGShaDQ+CimDMkUzhvrz87gKQZQFEPHgrC
 5MnljuSAFihWlmMbIJzTEqdVb99kAROkW58xY5i0zVIqMQ5BREWuNk7jdgCPv79OethRiKkrkj
 6AgGijDcHSkEmXnRjVZ45Vxknf6Ai8UKpHqqse9fIl2dr+uFX0Ov5ZP29Ngqb77ERKGkDYyZER
 LnGlsPYdtt/E8O75IbNJZCNd6FHDRf1FY8QxxURPo8FMPGthz/4Kp3g1YNhgV3bWS2jZHmWyBD
 JCSadPcY9oT3jEhR2uEdQUws
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 04:06:39 -0700
IronPort-SDR: uvRqXFpJDJ9yWuxhYthjIzVCPxgY4ioVNykLkuvD1qi7gHlbAFHb6yVFdzvXafsTQPR3mR607H
 WE1ZdK4V5s+BBwRI4rQEPBR6jpZewC2JwzPzt5SgrmZil7Jot/baNGXzfTjg1s+jxZx+DML31U
 aaB/HacbLkegvVcBpLW4577gq0SCqfLnG7PY1JY7nPvHyHTws0bEUIgGgRjMfpZWBznoOlZfBv
 +MZKtp1ILj5qogguonse9VZmre6nGWnWJRuf5X6s1EAMuQ7bI5UzBk9J6WiOTaWbrbJcBL0DGi
 aAc=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2021 04:29:07 -0700
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
Subject: [PATCH v11 07/12] scsi: ufshpb: Add hpb dev reset response
Date:   Wed, 16 Jun 2021 14:27:55 +0300
Message-Id: <20210616112800.52963-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616112800.52963-1-avri.altman@wdc.com>
References: <20210616112800.52963-1-avri.altman@wdc.com>
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
index d6a4b816814c..39b86e8b2eee 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -196,7 +196,8 @@ static void ufshpb_iterate_rgn(struct ufshpb_lu *hpb, int rgn_idx, int srgn_idx,
 		}
 		spin_unlock(&rgn->rgn_lock);
 
-		if (activate) {
+		if (activate ||
+		    test_and_clear_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags)) {
 			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
 			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
 			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
@@ -1412,6 +1413,20 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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
@@ -1486,6 +1501,18 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
@@ -1811,6 +1838,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		} else {
 			rgn->rgn_state = HPB_RGN_INACTIVE;
 		}
+
+		rgn->rgn_flags = 0;
 	}
 
 	return 0;
@@ -2138,6 +2167,7 @@ static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
 	if (hpb->is_hcm)
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
+
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 0204e4fec6bc..43a95c670763 100644
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

