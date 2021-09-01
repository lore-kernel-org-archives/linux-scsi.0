Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B92EC43214
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 12:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0514F610A8
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 12:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245708AbhIAMks (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 08:40:48 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:3623 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344469AbhIAMjc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 08:39:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630499915; x=1662035915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z4f0KBppamc7YzQ6iFCvHVormwCOOsz5gA+FUtoxpDM=;
  b=DtCItnp6NZg0G+WeGnKyarBiLebbFeZt+7oZYcTMcE3/UioDKpWGlKf7
   BQGK0ihGecc16NU1rPfo2d9gGOMPiRZvj0OSU2Y2nhmILgj1Wflk1jV2j
   l68hn7haVOr8O5oS756IECHM4gVuOgUz4cazV9jAeU8zgWZZxYtQTXDQm
   nPI9J6pWGqX6G++Tl7SZV1qLB7I83pktbDUEnsLY8IVI0R06NEWU4COWb
   Ffnsyd5oPldFrgyyiZV/bnjxk+CO9Xp/aooKfe6B++wVDTaQbUz6+6zyF
   p+NtYAiDYDApHS0MUs4aI6qGTh7FVoH4z6f8ASCrIR+obDKpuOl57zt4Z
   A==;
X-IronPort-AV: E=Sophos;i="5.84,369,1620662400"; 
   d="scan'208";a="178051534"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 01 Sep 2021 20:38:35 +0800
IronPort-SDR: IZDtnJvywupG5w5BNUZS+uqR0u6uLwwpWcZMWj/WS294Z/11/0EJ0xEpmo1ujt4b+Kc9H9vxSM
 ciWa9Rrlo0aEJX0jsS6Q2JzifhXPFlBUbYv0e+3mYF3KLK1y05Lg6e4bjbjAjA+hsH4AiFeMDr
 sh7BJBDNEKB+R0c0RXNrOVq+vjmjYPuo/lfUgAv9OMtEhdOd7trbWMk4diw3xh8dtztVHDGvRw
 dFdQOPRzviH5MOUlZGvNQt1h1JjW4Pj+EBKhc7nP+0WJARDPOqHyjuTpmNN+464WqOB6BVKz+y
 lv/ylARScUiGK7TLM3YVfUpJ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 05:15:22 -0700
IronPort-SDR: Sgv82zTy2RwjoCfH5xIwkCOS+9u/H8w/rgah4zqh1NTay4yZJjl31l2U0RWzsjAwwchdwcpWuP
 DuSUqsQedCt9JS+/gXdJlB+sYZ4oynDHwkaLoCKZJf4xwltvxEN0PneOAOxU6X+fqj8z+lVGNI
 pCG/VfO0KSdcplphbGjae/uIzzSbnlUzJsF6kVYTRjNOC9tfm/nhd3tvKtKhfjq7zkKYnt4IhH
 78l+lkj6Of6CSqXUxhKfQY7Fa5Jqmep6YgMWJZK4M4Pgz0F1s0fxwkBIpimIAdNTTAHVyfaBMA
 aX4=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 01 Sep 2021 05:38:33 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 2/3] scsi: ufs: Add temperature notification exception handling
Date:   Wed,  1 Sep 2021 15:37:06 +0300
Message-Id: <20210901123707.5014-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210901123707.5014-1-avri.altman@wdc.com>
References: <20210901123707.5014-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The device may notify the host of an extreme temperature by using the
exception event mechanism. The exception can be raised when the device’s
Tcase temperature is either too high or too low.

It is essentially up to the platform to decide what further actions need
to be taken. So add a designated vop for that.  Each chipset vendor can
decide if it wants to use the thermal subsystem, hw monitor, or some
Privet implementation.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufs.h    |  2 ++
 drivers/scsi/ufs/ufshcd.c | 18 ++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h |  7 +++++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index dee897ef9631..4f2a2fe0c84a 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -374,6 +374,8 @@ enum {
 	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
 };
 
+#define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
+
 /* Background operation status */
 enum bkops_status {
 	BKOPS_STATUS_NO_OP               = 0x0,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6ad51ae764c5..5f1fce21b655 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5642,6 +5642,11 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
+static void ufshcd_temp_exception_event_handler(struct ufs_hba *hba, u16 status)
+{
+	ufshcd_vops_temp_notify(hba, status);
+}
+
 static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
 {
 	u8 index;
@@ -5821,6 +5826,9 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	if (status & hba->ee_drv_mask & MASK_EE_URGENT_BKOPS)
 		ufshcd_bkops_exception_event_handler(hba);
 
+	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
+		ufshcd_temp_exception_event_handler(hba, status);
+
 	ufs_debugfs_exception_event(hba, status);
 out:
 	ufshcd_scsi_unblock_requests(hba);
@@ -7473,6 +7481,7 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
 {
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u32 ext_ufs_feature;
+	u16 mask = 0;
 
 	if (!(hba->caps & UFSHCD_CAP_TEMP_NOTIF) ||
 	    dev_info->wspecversion < 0x300)
@@ -7483,6 +7492,15 @@ static void ufshcd_temp_notif_probe(struct ufs_hba *hba, u8 *desc_buf)
 
 	dev_info->low_temp_notif = ext_ufs_feature & UFS_DEV_LOW_TEMP_NOTIF;
 	dev_info->high_temp_notif = ext_ufs_feature & UFS_DEV_HIGH_TEMP_NOTIF;
+
+	if (dev_info->low_temp_notif)
+		mask |= MASK_EE_TOO_LOW_TEMP;
+
+	if (dev_info->high_temp_notif)
+		mask |= MASK_EE_TOO_HIGH_TEMP;
+
+	if (mask)
+		ufshcd_enable_ee(hba, mask);
 }
 
 void ufshcd_fixup_dev_quirks(struct ufs_hba *hba, struct ufs_dev_fix *fixups)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 467affbaec80..98ac7e7c8ec3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -356,6 +356,7 @@ struct ufs_hba_variant_ops {
 			       const union ufs_crypto_cfg_entry *cfg, int slot);
 	void	(*event_notify)(struct ufs_hba *hba,
 				enum ufs_event_type evt, void *data);
+	void	(*temp_notify)(struct ufs_hba *hba, u16 status);
 };
 
 /* clock gating state  */
@@ -1355,6 +1356,12 @@ static inline void ufshcd_vops_config_scaling_param(struct ufs_hba *hba,
 		hba->vops->config_scaling_param(hba, profile, data);
 }
 
+static inline void ufshcd_vops_temp_notify(struct ufs_hba *hba, u16 status)
+{
+	if (hba->vops && hba->vops->temp_notify)
+		hba->vops->temp_notify(hba, status);
+}
+
 extern struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /*
-- 
2.17.1

