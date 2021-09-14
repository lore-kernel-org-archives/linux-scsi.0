Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF774C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9357F610E6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240489AbhINGzL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 02:55:11 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:38070 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbhINGzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 02:55:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631602425; x=1663138425;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lCRlcxXS66HOkamWwosFqgfjMmQZfRLMf3XCDPUYU1I=;
  b=Wj7VXyK5Xxqne4i3wBW3GnJDlakK5lMzr6RCN/RnNPfvN/M5LztgyFut
   N6FV81ipoHmY4l4aqt/m41lpJl+wHuk/KAo+8h2feqCKDUo9TurYTOm5l
   22h4o7hWq5XaqZIz65R6lsyooCYGrjj1Tfwbj68QtMnymL1+bszD8fzDA
   ojrptqXJ2sTAQ+uVW2VbC9FPw+5iUBG1WqbSF/HiRsBMpYMeJ5W2Jhvtp
   OwcOmNll7allBT5AFG8DQdtolFpfhkskYwPiBUWjIanMP5vCERcmV6lrD
   QKNPGBB8g3M68Wc4MFg6UsIVum3uuBgeIGYgysckb2s0P1PE+gWhtI0bb
   w==;
X-IronPort-AV: E=Sophos;i="5.85,292,1624291200"; 
   d="scan'208";a="283735411"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 14 Sep 2021 14:53:45 +0800
IronPort-SDR: KQAfBIXKabXA6U8tGy+nmhFcL19AxF8RiZ3MD4BgpvLDpgRrcgUxYbnNB+DFd5C5ztom/k94Fx
 Qcu9E1dwuPt/JNKo2DKS8ETXVa0wz00viZC+Er2EULlFvlrQY8KDGox41K847TTm5HAxY0esnQ
 9pniPwxKZOviWFdlfv86+e5dTVRO/pIW83Q2MScjjhoeI+FxHD9r1gC+eE76dfxxuMnIi970fz
 Xnw/FQJ1nO5NQ869z6Y5Su4lGi0UEM1Vykl0XMq9idCcGXqCOalLz0M8Iuaqgbh2XFNjdbE+Yx
 WepLpxerYg4rdTzIwaH6c4kJ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 23:28:35 -0700
IronPort-SDR: zXdpbihYFlKHioBhxSZSiXAjS7kYthrano9Q5CHJkRRma3wWGBAajP/eCMx/qxd35KmJySD2ZR
 5dlIKbz3XwGK8Hym+t73QvlTm0LhhhT6WRc2YynnpbRZ54jycCxShWl25lN/7NyheKDZco9AVr
 5+RN6y6he44CstY7i8yedELLBFxC2gbj8t57NDwokcZzZ2sRZ/rCeN08Rb/fKIO3k3y5ydbkIa
 PajhEOKYfhXFQ1ydIwTqAgOjdh1WYeGVt1UrhRr/RPK1d+GxHhRh9GrgRGU+PHv8ON5CZDRP9S
 puo=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Sep 2021 23:53:42 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v5 2/2] scsi: ufs: Add temperature notification exception handling
Date:   Tue, 14 Sep 2021 09:53:20 +0300
Message-Id: <20210914065320.8554-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210914065320.8554-1-avri.altman@wdc.com>
References: <20210914065320.8554-1-avri.altman@wdc.com>
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
 drivers/scsi/ufs/ufs-hwmon.c | 12 ++++++++++++
 drivers/scsi/ufs/ufshcd.c    | 21 +++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h    |  2 ++
 3 files changed, 35 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-hwmon.c b/drivers/scsi/ufs/ufs-hwmon.c
index be7e60fb1a98..032b9cc7e87a 100644
--- a/drivers/scsi/ufs/ufs-hwmon.c
+++ b/drivers/scsi/ufs/ufs-hwmon.c
@@ -199,3 +199,15 @@ void ufs_hwmon_remove(struct ufs_hba *hba)
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
+		hwmon_notify_event(hba->hwmon_device, hwmon_temp, hwmon_temp_max_alarm, 0);
+
+	if (ee_mask & MASK_EE_TOO_LOW_TEMP)
+		hwmon_notify_event(hba->hwmon_device, hwmon_temp, hwmon_temp_min_alarm, 0);
+}
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ce22340024ce..debef631c89a 100644
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
index 021c858955af..92d05329de68 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -1062,9 +1062,11 @@ static inline u8 ufshcd_wb_get_query_index(struct ufs_hba *hba)
 #ifdef CONFIG_SCSI_UFS_HWMON
 void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask);
 void ufs_hwmon_remove(struct ufs_hba *hba);
+void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask);
 #else
 static inline void ufs_hwmon_probe(struct ufs_hba *hba, u8 mask) {}
 static inline void ufs_hwmon_remove(struct ufs_hba *hba) {}
+static inline void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask) {}
 #endif
 
 #ifdef CONFIG_PM
-- 
2.17.1

