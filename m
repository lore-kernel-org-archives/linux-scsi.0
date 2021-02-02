Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AEEC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E20BE64EC3
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 08:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbhBBIcm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 03:32:42 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:10200 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbhBBIcd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 03:32:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612254752; x=1643790752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ry04P+tqVL/wure0v7X6+p7Jj+Skd5MdDAlnOEQ0C8Y=;
  b=RNkMTxfQZ+gnRmuugNDuGvlvz5ysZW7nt8lVZiWgdZ/XwXSfXTkH+1P+
   YRfcYQnLZEpPbFCnTlEsAHbYFCVDSDVsLn1s9k7v8rXF64nMonEBJXgls
   mE9sxSnJ6j/Od+YJJzoy/96L9GkeNzWnrc7AsB7oJeJ2jDmjsoGzlHYAW
   +eYHmySdm+s10UFegVQhjYDcCfYvatoZcePEypr+oL1Fmx3YvIwOfid7B
   2epd/iMrSTHUSd7PyhgmpjvXgwe+1lk0pO9EDJVT3zCe40bgLKPbNwtlg
   WRQAHXL1dcUBFkkjIpljBUoEZ6csnvsgJvUsSpLJK2FdZemqwnxnP6NLu
   w==;
IronPort-SDR: wOHIOQ0wdVzbIxkUbuEBs9IF+wI9uAzGDd5UvaBwjd5Ktm5zlb6SesRC9xOK7N47xMD6Y8B/Zi
 g/iooUgzNTzOFNs46tPcj2t+NBxkK0+X0UEMfAwVE3Bq68EdTk2EA8iqbtMjplWY2lUCcB8X8b
 IfrjGWthWtq9Dw7wXqMCx0mX3NjUWJ3LYU9Evq49AZPo0J4peV3vKwlouBoYbYcp6Pt/5oLm7s
 uIFhJYf7yuGWo/FGFgP18mM48uem2AQKEtgC/p9oS9fDtjF5oOOTwKMNO5NH64/8f8cl8SjZh5
 rDU=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="158900021"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 16:31:13 +0800
IronPort-SDR: 7R0YjQLV7jNRqSM9sLnfLhtx2m1aWlBtnW9dBhacyasJGWclMhNq3d+DBUjE01FdgfGSDXI+rj
 1xDCJZaBvRAY9N0h5dK6FsEPj/RlOGtPd28cDiZXTRuPF8BXyUrRVVhNYQwFpYgw4Hh8X7oILh
 gr48T4N8rinBhg3u8VL9srWx3VQFhRVE9bbTko6A44B78aJGeHZCS4UIA5RnkN3d9kURMhgnp0
 fxfdR5QHfNGvEkdyeIxfbSxWYHFNxVubUMkM41Ubvc+fVregVTb7Egj2fYFsp3/MiQ/Mmq9bz8
 INy3kNBHDsOgz5PFoeEvBIF0
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 00:13:22 -0800
IronPort-SDR: xkprG/iLEkUfluy30UCFNEonRnbZCZaBNqos5pWqoiEVOzaZAv7N4VE8EKcAayDuW0KEWuwRex
 1oGLalbxdOPAbwxJlhpmCPyc1RgP15lMCU918ml7Kn3zqxFSqd5O5uRMLNzzEkRrpsFq/5RWZH
 ppnKBr1Ijf121YI2CFKp6WMdpMIbvE0qT6h8nq1YamWCi93PZCJV82ui2Ovmjv9EPF8Rw4VKZo
 qjj+sGk82smWWzNLAfJN9h+kpVZ3eJll1ir50YibEzKBx0KbMSjmbDuSV8nmcaa1eBrIS+NtHF
 n+o=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Feb 2021 00:31:10 -0800
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
Subject: [PATCH v2 6/9] scsi: ufshpb: Add hpb dev reset response
Date:   Tue,  2 Feb 2021 10:30:04 +0200
Message-Id: <20210202083007.104050-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210202083007.104050-1-avri.altman@wdc.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
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
---
 drivers/scsi/ufs/ufshpb.c | 54 ++++++++++++++++++++++++++++++++++++---
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 52 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 49c74de539b7..28e0025507a1 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -17,6 +17,7 @@
 #include "../sd.h"
 
 #define WORK_PENDING 0
+#define RESET_PENDING 1
 #define ACTIVATION_THRSHLD 4 /* 4 IOs */
 #define EVICTION_THRSHLD (ACTIVATION_THRSHLD << 6) /* 256 IOs */
 
@@ -349,7 +350,8 @@ void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		if (rgn->reads == ACTIVATION_THRSHLD)
 			activate = true;
 		spin_unlock_irqrestore(&rgn->rgn_lock, flags);
-		if (activate) {
+		if (activate ||
+		    test_and_clear_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags)) {
 			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
 			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
 			hpb->stats.rb_active_cnt++;
@@ -1068,6 +1070,24 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	case HPB_RSP_DEV_RESET:
 		dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
 			 "UFS device lost HPB information during PM.\n");
+
+		if (hpb->is_hcm) {
+			struct ufshpb_lu *h;
+			struct scsi_device *sdev;
+
+			shost_for_each_device(sdev, hba->host) {
+				h = sdev->hostdata;
+				if (!h)
+					continue;
+
+				if (test_and_set_bit(RESET_PENDING,
+						     &h->work_data_bits))
+					continue;
+
+				schedule_work(&h->ufshpb_lun_reset_work);
+			}
+		}
+
 		break;
 	default:
 		dev_notice(&hpb->sdev_ufs_lu->sdev_dev,
@@ -1200,6 +1220,27 @@ static void ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
 	spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
 }
 
+static void ufshpb_reset_work_handler(struct work_struct *work)
+{
+	struct ufshpb_lu *hpb;
+	struct victim_select_info *lru_info;
+	struct ufshpb_region *rgn;
+	unsigned long flags;
+
+	hpb = container_of(work, struct ufshpb_lu, ufshpb_lun_reset_work);
+
+	lru_info = &hpb->lru_info;
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+
+	list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn)
+		set_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags);
+
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+
+	clear_bit(RESET_PENDING, &hpb->work_data_bits);
+}
+
 static void ufshpb_normalization_work_handler(struct work_struct *work)
 {
 	struct ufshpb_lu *hpb;
@@ -1392,6 +1433,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		} else {
 			rgn->rgn_state = HPB_RGN_INACTIVE;
 		}
+
+		rgn->rgn_flags = 0;
 	}
 
 	return 0;
@@ -1502,9 +1545,12 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	INIT_LIST_HEAD(&hpb->list_hpb_lu);
 
 	INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
-	if (hpb->is_hcm)
+	if (hpb->is_hcm) {
 		INIT_WORK(&hpb->ufshpb_normalization_work,
 			  ufshpb_normalization_work_handler);
+		INIT_WORK(&hpb->ufshpb_lun_reset_work,
+			  ufshpb_reset_work_handler);
+	}
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
 			  sizeof(struct ufshpb_req), 0, 0, NULL);
@@ -1591,8 +1637,10 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
-	if (hpb->is_hcm)
+	if (hpb->is_hcm) {
+		cancel_work_sync(&hpb->ufshpb_lun_reset_work);
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
+	}
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 71b082ee7876..e55892ceb3fc 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -184,6 +184,7 @@ struct ufshpb_lu {
 	/* for selecting victim */
 	struct victim_select_info lru_info;
 	struct work_struct ufshpb_normalization_work;
+	struct work_struct ufshpb_lun_reset_work;
 	unsigned long work_data_bits;
 
 	/* pinned region information */
-- 
2.25.1

