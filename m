Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDC0C47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70F68611AD
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhFGGR1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:17:27 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:2821 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhFGGR0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:17:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623046534; x=1654582534;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AXJBFjm/7TYzVmtA72gTqs/XcMuZbx07I+y7xGfmgC4=;
  b=b4bP9RA5yy1DacYD32KbDFIJx3TRn45VEwuCBmLMZb/NLgWqGhxxVvFG
   xBSgAOn88p7szKpmLMA/Gvb8SMIsEXHoBdxQkzZXzeSK0ra+zbiycECm6
   ykXmRRFuzYc/Ezk2u04EHRUBTXphOp6L4x6UkbTFib4U3KU+AfYf/fGbs
   a2Q1Rhh0CeTPqlztZvrq+wEcMYT9d4GsxOUhZaFgha6T3StTXV1yzEhwK
   OKaY9rhStb0kUm1h911r4onUcA1Ua7wJGG/3VTi67Bojl/DWzcybfPewi
   kAY+gkANS2YmYTdACUDiVyMcQ+y9VBqKKaAoMXxmCpJEsAYS4HY5Bpvvm
   w==;
IronPort-SDR: urVnFkjvf/R1oE970TvZaPHftm/chj9b/EhXGbLE5aanhfrk8E6eBj3SUicETeY8GepU86H1eP
 H5Wka6DZ03V7eztF6P7PITh9sonGF6YWHtGk2/d4wZvBMKM6Ow6hy1I16M3++edWOcr1Bajkck
 yRSChsZTqzJmX/wkeh3KFGf9l9llTD9wyqpbJE7sKIYMN3NalSjw2xCcvj2Ss1U16+BPSVYQJq
 GVwzahhUkfB9Q4jPRcqfnQsZyItv9s/ANeTyYbahkVnSxf0va749IsXC1iSboPHP9ZduB9m7f5
 oO4=
X-IronPort-AV: E=Sophos;i="5.83,254,1616428800"; 
   d="scan'208";a="175741178"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2021 14:15:34 +0800
IronPort-SDR: okqM6UCQRpMccJuneo+TJ5roxGQ2zyPDxUqKVRkrMGXXitNUi5khfdG90aMhfSmPQuZQdyBnfN
 LGhgYoOxLSciS+T3gRIfAiswkHLXv4S74XCtRBl31VKTCzCYiwqrZ1kkMSqVTTYoSc8RANGhe+
 rdpELsF56tnHNvMGKWcXeo+Hl75RqinOh0iKYj8XHyu3zLrgGYe8+K/lY/N1aCd7M7yVA0GiIL
 fe9DO/x5lBwz1ym8QWICSwd+viuyc2BotxM0bX70F2w5pSVYESUVM34fJOIJTKqolApI3Jd/HA
 M2R31nCs/GV0md6myiEtKLTf
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:53:17 -0700
IronPort-SDR: t3NsnUIGc+k2cKIG+n/RK88LiXHHrq8v9nnHxut+geflD6AlbEOIIRFzNH3Dni5h0JEfhXFkYS
 oWnLG196bvt5hHVB1DaIFwUjnUzuyl8hi8b4rtxrqumhG6oF869XmMCT+7vPRozMDu6ChMh7/a
 JVTubvtwYyZ/Ex2shQWPf2kHMI6kZ7uYKUhAxTZxM6IcTGYfLHXEpzP70MQUP5wA4hM59Jp9La
 Ho5UtZAH6kil8u574K3zsoYN39iuUiyQBed+IE+xETG7juHHQ3voECPqPMsuT+t5dm0bb/GvFw
 tc8=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Jun 2021 23:15:31 -0700
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
Subject: [PATCH v10 07/12] scsi: ufshpb: Add hpb dev reset response
Date:   Mon,  7 Jun 2021 09:13:56 +0300
Message-Id: <20210607061401.58884-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607061401.58884-1-avri.altman@wdc.com>
References: <20210607061401.58884-1-avri.altman@wdc.com>
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
index 0ef46aa71045..1a29fe491c62 100644
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
@@ -1816,6 +1843,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		} else {
 			rgn->rgn_state = HPB_RGN_INACTIVE;
 		}
+
+		rgn->rgn_flags = 0;
 	}
 
 	return 0;
@@ -2141,6 +2170,7 @@ static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
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

