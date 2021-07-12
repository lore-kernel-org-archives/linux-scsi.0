Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43D0C07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE0BF610E6
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbhGLJy6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:54:58 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:38088 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbhGLJy4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 05:54:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626083527; x=1657619527;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ONFhG70nHN8i1/Ll5W+qGDPxvqrDNBO3fKKi64/sBIo=;
  b=JzpW0Bgmk1bjCJS3vTfMYIoYr5syGCzcg7WcgHhd/4jfyxtg7ktWhqIo
   dZv91OaZXyypuVxwegmN6BPTppk4UuQ6XmEVHtj+QPCaoERg2/vmm931Q
   KT15mMDnSjss5LStIkiQkHDsw/2IwywIyjxrddiknF/2D/mSv4HoAe80t
   9+aNVL836+AJO8Bxf0vVzx7PeiXZtutXOOW6FSSHGHkCRqrCdPjgjo42C
   u8RIs2XlJWENLDRSf89v9jk28qvQzDAe9bmNFznols4Slw81PEgRX4+IM
   gZH6epkGzcnpfrIoHtO1So7LcutMhZgSURwtR7AqKEb1Gl0eRJ5QitFrR
   A==;
IronPort-SDR: tILLnrbJimE5Q6h0KQ1UfpPhmA8bVwE3Sfr1mdIQllGewPEf0v+d9V+hq6rbxTVsHbzxvPIr0q
 Wv8v7JsFWjd0SMBe3VsZrVYj0TyJ97RAkJ8IrFe/z7Sw1v2KcYCkh5LmNE5zY3x7VGHDBzl4h6
 0hrKcUmoSexmrhvEtngYNtb+2S7GYzAhRzTBMsYsi+MzyjJT4id6SOwk4nbejWZ8/WFqf9QR0X
 zFhTvx3xzWQb3nhWWtgLArMOsqsySFcYEEjEc6Ide3JshxJqUWsi8OkM5y67RuKem7yTQogrJz
 mpk=
X-IronPort-AV: E=Sophos;i="5.84,232,1620662400"; 
   d="scan'208";a="179153737"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2021 17:52:06 +0800
IronPort-SDR: +mYSENp7hen1SPbNIrT/cCVvCglCURfvz2u7r2Uh5znaoCIHhaf1b/1hi9WiGYufyNKnt2l9Y4
 SXYtA7ki2tVxjRkhH9g9UzKXIzBkIwxp8gjY0GF7ctczIzzwy0ajeNa+PFJ+KY7hGfL/5SVJJY
 ESN/pqTs4Scsgjc8kfGg3YJkuVJvyspxUDRLu5msqi0vVDiJxDYVp4Z2mdQuE3nDbCoLMRtOHG
 hIUH6FNghB+T6ZN/QyDNU47e2XlAfhlw9RENws9jSJS7n73ciggZD7dVxIQE7On78KzTbAZGC2
 Jh4/ogV2iIwhEyubtJH+mJ9T
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:30:13 -0700
IronPort-SDR: wkZW2gjRVxDNjrYqJZqyrndvZMO2Dmxgy6kqSYMyHUXtUfTz3dzONCoUfusY1sPXeQ7Qjiwdlm
 S4hVf+WDXjQZSd5zHTUCPU22rIzfSstcqvO4uSDUbzQF8zrx2HnN3kfuKMVyMnDIST+76mn5Vg
 QF9/BKmbtWjPEjF/YzGzWvfPpSGeYIIBcwvGibpK2r39zqL7ZnsMugwiofZW9Q3fbkanyyijap
 WnVixTcxInRu/qnSPj4P3T1E56YyER9gn81XXbyyy7eiBwd51Dydwg0q4pbagUr3F8LTo7YY9I
 +QE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Jul 2021 02:52:02 -0700
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
Subject: [PATCH v12 07/12] scsi: ufshpb: Add hpb dev reset response
Date:   Mon, 12 Jul 2021 12:50:34 +0300
Message-Id: <20210712095039.8093-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712095039.8093-1-avri.altman@wdc.com>
References: <20210712095039.8093-1-avri.altman@wdc.com>
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
index 7b48a9ab1534..5b473f1800ca 100644
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

