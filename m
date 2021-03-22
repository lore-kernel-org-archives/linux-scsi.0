Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCA1C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AD2F61967
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 08:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhCVIMd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 04:12:33 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10134 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhCVIL7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 04:11:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616400719; x=1647936719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ygfkOOBrcqaJYN0aHmeuUO/ORv/xjIrQ7VgSDjKwqLk=;
  b=i+q5lXDNI0fm3hC/c2NKmBP8ccRmWA0riB794bgZXskMAhtDZIDBlQz8
   jTVOmZhV0oOio4ZB8ZCNm9mB9nJT3lxicLZEgGLjKktkHgCMNDLztke4f
   /05Tf3EDHo8HChnHjpcl9Sn/xIvH9/gNRLyQtOjYOb/+aNk76y0wMwMxa
   /b3WhuqdaWBFVzHrfKVkK8DpaxKEkGrvFpn40euL+2fgTn0KPh7QhhjfB
   fGbjLsPUhXcnpIfInvH3nBQc0UXSF1Ux9vSxjFVQY5obml0oZUFy5Fm7E
   ELczIxaXa80TZlRdr7kq4wHB+ifJd8uYIWgZtzh7Ik51K9vwsWUXjoMHy
   Q==;
IronPort-SDR: e6o2aNIp7uhft1rkwpfF0KkYXOZ7pLqiwMIKMR8Bi7wpTOezzfOM9sG0hlDFvz0ElvNJMLjzc2
 9xhix4CqLsrrgv3JRcnVNCnSO+HuHNlJkUM9lCIFNP9P7CIj6JqUwpAueHDL11/OcKskzuJb32
 pQSI4a1GNAgEjBjEHYsStvlax8nl5yl8DdnrZETcExBTB8k0PsHzLnjngmmGSWKSHGMrwfk2mG
 T6rcPTzCfJA1fsy8uSLCN0vHT3b2TsUi2NFHzwKKHFf1ilKgFw6oy3TSPfy2wC1AnRrho2b2ue
 +nA=
X-IronPort-AV: E=Sophos;i="5.81,268,1610380800"; 
   d="scan'208";a="162644089"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2021 16:11:58 +0800
IronPort-SDR: fqwsfw+1X2fShcWkdZ1hrHbUHgUlKflAgIeth0Agk4xmCxLkfMblpFfep8SzKOhaV4s1VcWUm/
 qld5Pwpok/MNv+RT6xsqz77irTo1hxxO/fK1jIStQ+9wppcQ7KMNjiPhncAhod4jqmjqxkJXXF
 qMZeIroRzpciYYQPLsy+eksqsFumUy0r60p09a+Ttym9pqV8bLq4IUbmWvPE7WD5+7nUQJ7KFY
 ZJiqHHcd3UuWqKCfl7rfWCZWwcpsHrBrCn6050yFNqqnsUqsRAFou/YgAin91sP5684cjCJrHO
 wKUOJ6+XkBTP7PMp/y6TpahM
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 00:52:28 -0700
IronPort-SDR: YSey8P6EJElcXmUHyw8IY2xpSp4OBFolBJQZpesK5TDdAZ2IxrlkWiVNejNFF9QusK1+Phbi6h
 FBp4FOMlEBq559WRuMvBS6w2QS6ULw7TxXJckn3RjlvTEyXdfuFfzrOgYUOJN2MiDvJew19PC0
 Vvl0G2QGw+w8Yh8yDeEIoLREfjCXxior+wCyqRLFCXE32jA9cVy7UHu7HI/zITpy54pdaDX8U9
 QHpEnUGlefo24yN6xVw4ntEKwYaGu2nzsc/UUGZrLh/vK9J/nIdpVB2mDHVFaOp3GuE+LHbbmU
 pAE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Mar 2021 01:11:55 -0700
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
Subject: [PATCH v6 06/10] scsi: ufshpb: Add hpb dev reset response
Date:   Mon, 22 Mar 2021 10:10:40 +0200
Message-Id: <20210322081044.62003-7-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322081044.62003-1-avri.altman@wdc.com>
References: <20210322081044.62003-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufshpb.c | 32 +++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshpb.h |  1 +
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 1f0344eaa546..6e580111293f 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -640,7 +640,8 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		if (rgn->reads == ACTIVATION_THRESHOLD)
 			activate = true;
 		spin_unlock(&rgn->rgn_lock);
-		if (activate) {
+		if (activate ||
+		    test_and_clear_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags)) {
 			spin_lock_irqsave(&hpb->rsp_list_lock, flags);
 			ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
 			spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
@@ -1402,6 +1403,20 @@ static void ufshpb_rsp_req_region_update(struct ufshpb_lu *hpb,
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
@@ -1476,6 +1491,18 @@ void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
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
@@ -1795,6 +1822,8 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		} else {
 			rgn->rgn_state = HPB_RGN_INACTIVE;
 		}
+
+		rgn->rgn_flags = 0;
 	}
 
 	return 0;
@@ -2122,6 +2151,7 @@ static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
 	if (hpb->is_hcm)
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
+
 	cancel_work_sync(&hpb->map_work);
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 7afc98e61c0a..24aa116c42c6 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -123,6 +123,7 @@ struct ufshpb_region {
 	struct list_head list_lru_rgn;
 	unsigned long rgn_flags;
 #define RGN_FLAG_DIRTY 0
+#define RGN_FLAG_UPDATE 1
 
 	/* region reads - for host mode */
 	spinlock_t rgn_lock;
-- 
2.25.1

