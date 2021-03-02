Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D710C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 342BA60232
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Mar 2021 19:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1581537AbhCBS6E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Mar 2021 13:58:04 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:10828 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351125AbhCBNb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2021 08:31:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614691916; x=1646227916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vTkMTBSxVX84qN8P5RGFFrI2LIZaQDhW62pfY0yBXbo=;
  b=hynwFS1MtEcD7byUBCCD6M0kiJIkXlPsRTNo9hlGqWulya+KPRvQZgtP
   hY7MwiSp7W8Pfr8/I1BdbFsojk17/HvAIOlrlImkBBHnMvVpCKvJMOFJN
   n+ceSYjLsbdnVstKqth0/YX+9fp6TRdt+/wY6mmv5oVhWq5GyWy1O+bTu
   OvTwE+hozaVkWr2XKlsgCpXmLkTyDeG7nabLeuYuPc5fjNc07tdmVrsNK
   i88oN4K2Q93LmC4whQcnoDC93+TD/CIfyPxd9dDH9BGvC/8fc5wLBFH9o
   tykCBbirbNlYcQ03t5mbdtlzkkpIp/BH3owg9kYLDN+txlUww5iYHZKdG
   g==;
IronPort-SDR: Wg33WTHoMGOdqSgJjoq7u1M8Sc6u9y/+wrIxIONO/vClbo1N6qwN12ExcP9xLeUT/fI3QZaAet
 7K81f6KLUblOGHt8sxO4aCBZHnqyoTKmlRwAUp3Pp591ZNBM5ijMhOBRKR/bbQttodX+2htz1X
 Tx6ruj3okfVqKfdEXzHQOGpvFKbisHzDBSYy26Mu9hIU1YnFDCycrnBOcJr4XuY1tC2Jxfj92b
 YzCm3eyAt9yFqtzjGr+aVJuGbxMHFX9As0bQ7ZyKc0Taayq9Md5jazATfxfq48e/tWSGGtX8/I
 mpg=
X-IronPort-AV: E=Sophos;i="5.81,216,1610380800"; 
   d="scan'208";a="271767239"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2021 21:26:46 +0800
IronPort-SDR: 49eXPYIj1hPS4EvQZ7ykSQk9BGiCU4jZXDdBxf67blhAv9uuUI3iHcgn2M6Cp036+TUJKA0Yiy
 qcmGPvqpkknUAlRpgCCRm2VWUJnmKrENCtRCWceKzWHoSWJuKltizcvXgAwVUlzj0dSr3jx4Ef
 R6HovgALEUsRXBGnoWnJWPp1BUWx+6U0Ix1YDErzlRkVI0s4JOHTCGU7z2pW4fEPG5qxH8EZso
 8iG7EC8aQ37UIXNvHjCiMVkJ+ASdIwf1AI0bAVUzU/EO535NrUZNfceJ4NL1bSUanpuoXvVPKQ
 QaxD2g7b/mASPkv6W547fNfZ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 05:09:52 -0800
IronPort-SDR: osj/rXrVS0EtFVEShwgDMW7qpWOufrKnpreZWiGlBE5jv4iyTVm/X2J67JBCKImO6PyO5RaElP
 XZX5glN3l7g8nKNXCzrQl5AauHESXI5vzrhzqdmotODlWamZrT6FpMy1Myrs5q3p6dgUsAJpi/
 WvjPGKOLmSm+lVnX3S7jFMQCtotrnUY0gHQa4fj1i4mr5BqZVzTKwEjJ90su3F9jsLvKDhjENp
 mQ6X0Ro3+JBwTbKapNElAnCRMTcoyM0lUQgBfeg7z+xlWPwSp0kg1JEmOH9XHZHgpP4tM11zWw
 sqQ=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Mar 2021 05:26:42 -0800
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
Subject: [PATCH v5 07/10] scsi: ufshpb: Add "Cold" regions timer
Date:   Tue,  2 Mar 2021 15:25:00 +0200
Message-Id: <20210302132503.224670-8-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302132503.224670-1-avri.altman@wdc.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In order not to hang on to “cold” regions, we shall inactivate a
region that has no READ access for a predefined amount of time -
READ_TO_MS. For that purpose we shall monitor the active regions list,
polling it on every POLLING_INTERVAL_MS. On timeout expiry we shall add
the region to the "to-be-inactivated" list, unless it is clean and did
not exhaust its READ_TO_EXPIRIES - another parameter.

All this does not apply to pinned regions.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 65 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  6 ++++
 2 files changed, 71 insertions(+)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 0034fa03fdc6..89a930e72cff 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -18,6 +18,9 @@
 
 #define ACTIVATION_THRESHOLD 4 /* 4 IOs */
 #define EVICTION_THRESHOLD (ACTIVATION_THRESHOLD << 6) /* 256 IOs */
+#define READ_TO_MS 1000
+#define READ_TO_EXPIRIES 100
+#define POLLING_INTERVAL_MS 200
 
 /* memory management */
 static struct kmem_cache *ufshpb_mctx_cache;
@@ -1024,12 +1027,61 @@ static int ufshpb_check_srgns_issue_state(struct ufshpb_lu *hpb,
 	return 0;
 }
 
+static void ufshpb_read_to_handler(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct ufshpb_lu *hpb;
+	struct victim_select_info *lru_info;
+	struct ufshpb_region *rgn;
+	unsigned long flags;
+	LIST_HEAD(expired_list);
+
+	hpb = container_of(dwork, struct ufshpb_lu, ufshpb_read_to_work);
+
+	spin_lock_irqsave(&hpb->rgn_state_lock, flags);
+
+	lru_info = &hpb->lru_info;
+
+	list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn) {
+		bool timedout = ktime_after(ktime_get(), rgn->read_timeout);
+
+		if (timedout) {
+			rgn->read_timeout_expiries--;
+			if (is_rgn_dirty(rgn) ||
+			    rgn->read_timeout_expiries == 0)
+				list_add(&rgn->list_expired_rgn, &expired_list);
+			else
+				rgn->read_timeout = ktime_add_ms(ktime_get(),
+							 READ_TO_MS);
+		}
+	}
+
+	spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
+
+	list_for_each_entry(rgn, &expired_list, list_expired_rgn) {
+		list_del_init(&rgn->list_expired_rgn);
+		spin_lock_irqsave(&hpb->rsp_list_lock, flags);
+		ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
+		hpb->stats.rb_inactive_cnt++;
+		spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
+	}
+
+	ufshpb_kick_map_work(hpb);
+
+	schedule_delayed_work(&hpb->ufshpb_read_to_work,
+			      msecs_to_jiffies(POLLING_INTERVAL_MS));
+}
+
 static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
 				struct ufshpb_region *rgn)
 {
 	rgn->rgn_state = HPB_RGN_ACTIVE;
 	list_add_tail(&rgn->list_lru_rgn, &lru_info->lh_lru_rgn);
 	atomic_inc(&lru_info->active_cnt);
+	if (rgn->hpb->is_hcm) {
+		rgn->read_timeout = ktime_add_ms(ktime_get(), READ_TO_MS);
+		rgn->read_timeout_expiries = READ_TO_EXPIRIES;
+	}
 }
 
 static void ufshpb_hit_lru_info(struct victim_select_info *lru_info,
@@ -1813,6 +1865,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 
 		INIT_LIST_HEAD(&rgn->list_inact_rgn);
 		INIT_LIST_HEAD(&rgn->list_lru_rgn);
+		INIT_LIST_HEAD(&rgn->list_expired_rgn);
 
 		if (rgn_idx == hpb->rgns_per_lu - 1) {
 			srgn_cnt = ((hpb->srgns_per_lu - 1) %
@@ -1834,6 +1887,7 @@ static int ufshpb_alloc_region_tbl(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 		}
 
 		rgn->rgn_flags = 0;
+		rgn->hpb = hpb;
 	}
 
 	return 0;
@@ -2053,6 +2107,8 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 			  ufshpb_normalization_work_handler);
 		INIT_WORK(&hpb->ufshpb_lun_reset_work,
 			  ufshpb_reset_work_handler);
+		INIT_DELAYED_WORK(&hpb->ufshpb_read_to_work,
+				  ufshpb_read_to_handler);
 	}
 
 	hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
@@ -2087,6 +2143,10 @@ static int ufshpb_lu_hpb_init(struct ufs_hba *hba, struct ufshpb_lu *hpb)
 	ufshpb_stat_init(hpb);
 	ufshpb_param_init(hpb);
 
+	if (hpb->is_hcm)
+		schedule_delayed_work(&hpb->ufshpb_read_to_work,
+				      msecs_to_jiffies(POLLING_INTERVAL_MS));
+
 	return 0;
 
 release_pre_req_mempool:
@@ -2154,6 +2214,7 @@ static void ufshpb_discard_rsp_lists(struct ufshpb_lu *hpb)
 static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
 {
 	if (hpb->is_hcm) {
+		cancel_delayed_work_sync(&hpb->ufshpb_read_to_work);
 		cancel_work_sync(&hpb->ufshpb_lun_reset_work);
 		cancel_work_sync(&hpb->ufshpb_normalization_work);
 	}
@@ -2264,6 +2325,10 @@ void ufshpb_resume(struct ufs_hba *hba)
 			continue;
 		ufshpb_set_state(hpb, HPB_PRESENT);
 		ufshpb_kick_map_work(hpb);
+		if (hpb->is_hcm)
+			schedule_delayed_work(&hpb->ufshpb_read_to_work,
+				msecs_to_jiffies(POLLING_INTERVAL_MS));
+
 	}
 }
 
diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
index 37c1b0ea0c0a..b49e9a34267f 100644
--- a/drivers/scsi/ufs/ufshpb.h
+++ b/drivers/scsi/ufs/ufshpb.h
@@ -109,6 +109,7 @@ struct ufshpb_subregion {
 };
 
 struct ufshpb_region {
+	struct ufshpb_lu *hpb;
 	struct ufshpb_subregion *srgn_tbl;
 	enum HPB_RGN_STATE rgn_state;
 	int rgn_idx;
@@ -126,6 +127,10 @@ struct ufshpb_region {
 	/* region reads - for host mode */
 	spinlock_t rgn_lock;
 	unsigned int reads;
+	/* region "cold" timer - for host mode */
+	ktime_t read_timeout;
+	unsigned int read_timeout_expiries;
+	struct list_head list_expired_rgn;
 };
 
 #define for_each_sub_region(rgn, i, srgn)				\
@@ -219,6 +224,7 @@ struct ufshpb_lu {
 	struct victim_select_info lru_info;
 	struct work_struct ufshpb_normalization_work;
 	struct work_struct ufshpb_lun_reset_work;
+	struct delayed_work ufshpb_read_to_work;
 
 	/* pinned region information */
 	u32 lu_pinned_start;
-- 
2.25.1

