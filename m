Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 404B4C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 13:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 241EA61209
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 13:19:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235472AbhILNVC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 09:21:02 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:2175 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbhILNVC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2021 09:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631452787; x=1662988787;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hn5p6iAq2/R0gZg37R3x7fOlLxX9Tu08vrhiAicnY28=;
  b=gH8aBUh3vic4RcAVoQzdfpiVIW+utcc/1XZgA8o8hrNHD8jJC/fFpXhL
   FzBeVjeUdmNfuwY4NuRDi2NT4PrOIl2zNAUSW/DKPV/ZGiLp3iy/ZBUK0
   T8znSH9XgVqWnZSYa+wm/CU5bfVkz2Q5RyaHgBFmjzTpJ3WlGrB/Y6+sm
   7bJ4oMT08MVkDbRBpxVSI4BajPzhgpeFGs3k9HHBOZqxezhGxVlqaui+Q
   9/QZiFn3L42YXy24J2tJ8HoZJvyIn/0F1zfd5hudQkawZOwg10gKyVMho
   Jsigqdz75oUTmMc5dyCCuQ7lLJ7C1NkvdrnVmeuYbo1fcekwp3PK6A3g6
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,287,1624291200"; 
   d="scan'208";a="291403068"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Sep 2021 21:19:46 +0800
IronPort-SDR: rtrFTfecjN4ht4QKWIMdp0TJrmDhW41LuMJ0hzAKpltcB3HFnCysKA2sa6jiJUwvDucKZvPBy/
 7fqpTpiN2I1vZ/HUqUeu670OzGu8yu7ZyGBwTd1HE4bczrVilk9172YuVH2lDcK2UCUiWy/B41
 r53Y+T5dDE5K0vIAnuRlLSNwGo1IH0HKjT+s8YImjRJx4p6jsVJ41zvCA48kKh5PrqlJaxqDgn
 ovIXoEwBsNQdMlEmy1WnGfRhbFOMAtvSXZt9iJfuJ56YEB8R/IN5wORTuw/bhWehm/cpr20p2F
 7Br0DP9+354Qa9X9rivIRbfq
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2021 05:54:39 -0700
IronPort-SDR: 2tdTDrCROeZ1/u+2fKcIUL7IzJ6Taw4wStN1Hm7Srh/Niu4c4ZgKl/AFpiJWpAuZ8ObQgmUtmn
 fLbZwFK8vwjdxg3TulWsMFBnsrk+jBc9/YGRW0K9qDht2GusWzPfgdwEKxRTBTXNGpP71YFf36
 8yABCRl6R3rdCaqRCD8fawql7wIDPpfYDpQRGbIomQFNQeVLLS67z54Xuval7LRjp2MkCsrpLz
 7pcNFyqu1N9+dX5NwtDl3vxfrqwQEgj8xMC2S7rVzWVUt2csIJsmhu3Wajc+REma3uzXnHRC5S
 2Z0=
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.225.32.116])
  by uls-op-cesaip01.wdc.com with ESMTP; 12 Sep 2021 06:19:45 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 2/2] scsi: ufs: Add temperature notification exception handling
Date:   Sun, 12 Sep 2021 16:19:19 +0300
Message-Id: <20210912131919.12962-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210912131919.12962-1-avri.altman@wdc.com>
References: <20210912131919.12962-1-avri.altman@wdc.com>
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
to be taken. leave a placeholder for a designated vop for that.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufs-hwmon.c | 14 ++++++++++++++
 drivers/scsi/ufs/ufs.h       |  2 ++
 drivers/scsi/ufs/ufshcd.c    | 21 +++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h    |  2 ++
 4 files changed, 39 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-hwmon.c b/drivers/scsi/ufs/ufs-hwmon.c
index a50e83f645f4..b466b4649c21 100644
--- a/drivers/scsi/ufs/ufs-hwmon.c
+++ b/drivers/scsi/ufs/ufs-hwmon.c
@@ -177,3 +177,17 @@ void ufs_hwmon_remove(struct ufs_hba *hba)
 	hba->hwmon_device = NULL;
 	kfree(data);
 }
+
+void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask)
+{
+	if (!hba->hwmon_device)
+		return;
+
+	if (ee_mask & MASK_EE_TOO_HIGH_TEMP)
+		hwmon_notify_event(hba->hwmon_device, hwmon_temp,
+				   hwmon_temp_max_alarm, 0);
+
+	if (ee_mask & MASK_EE_TOO_LOW_TEMP)
+		hwmon_notify_event(hba->hwmon_device, hwmon_temp,
+				   hwmon_temp_min_alarm, 0);
+}
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 171b27be7b1d..d9bc048c2a71 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -377,6 +377,8 @@ enum {
 	MASK_EE_PERFORMANCE_THROTTLING	= BIT(6),
 };
 
+#define MASK_EE_URGENT_TEMP (MASK_EE_TOO_HIGH_TEMP | MASK_EE_TOO_LOW_TEMP)
+
 /* Background operation status */
 enum bkops_status {
 	BKOPS_STATUS_NO_OP               = 0x0,
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 90c2e9677435..3f4c7124b74b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5642,6 +5642,24 @@ static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
 				__func__, err);
 }
 
+static void ufshcd_temp_exception_event_handler(struct ufs_hba *hba, u16 status)
+{
+	u32 value;
+
+	if (ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+				QUERY_ATTR_IDN_CASE_ROUGH_TEMP, 0, 0, &value))
+		return;
+
+	dev_info(hba->dev, "exception Tcase %d\n", value - 80);
+
+	ufs_hwmon_notify_event(hba, status & MASK_EE_URGENT_TEMP);
+
+	/*
+	 * A placeholder for the platform vendors to add whatever additional
+	 * steps required
+	 */
+}
+
 static int __ufshcd_wb_toggle(struct ufs_hba *hba, bool set, enum flag_idn idn)
 {
 	u8 index;
@@ -5821,6 +5839,9 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	if (status & hba->ee_drv_mask & MASK_EE_URGENT_BKOPS)
 		ufshcd_bkops_exception_event_handler(hba);
 
+	if (status & hba->ee_drv_mask & MASK_EE_URGENT_TEMP)
+		ufshcd_temp_exception_event_handler(hba, status);
+
 	ufs_debugfs_exception_event(hba, status);
 out:
 	ufshcd_scsi_unblock_requests(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 798a408d71e5..e6abce9a8b00 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1063,9 +1063,11 @@ static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
 #ifdef CONFIG_SCSI_UFS_HWMON
 void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
 void ufs_hwmon_remove(struct ufs_hba *hba);
+void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask);
 #else
 static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
 static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
+void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask) {}
 #endif
 
 #ifdef CONFIG_PM
-- 
2.17.1

