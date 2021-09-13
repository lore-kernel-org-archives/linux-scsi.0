Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2420C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 13:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C4761A02
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 13:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242416AbhIMNhA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 09:37:00 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:31738 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243118AbhIMNe6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 09:34:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631540021; x=1663076021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=I+mbTA+03+CBI4ATMHCqjrQ510CBb/AiF9vYJKHKDoQ=;
  b=ZIzO5mPiLkuG8PaOvjIwOh9edaWSwoRyWvNWMaOTHJl3JoA5EZeyxrkZ
   RPWG3E/9lO2fl7qZCwN9LOY8Mawxuc+UodO4INKLXJYmYIUj31r9Z0ht4
   UnJT/k2i0ZhurNvR2PakD63yP/g7BPrHMvmkxjdm73J82FAXkDTnOuq8n
   UW5ceCb5QNN3l6y/yQxKBt5WNiglbtLnm83qyNjnucSmwGMt+vRRCQRS+
   bGIhz/5nJRhoQf33VI55TVMC/mZldaMO1urCqdgpFidTZw7qX4IifmBpa
   UjAR9VJ3F0XpNnR0vEyCIGPkKPZ1OepPJfWCU/eaVP+kup6/4kiP9f1gD
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,288,1624291200"; 
   d="scan'208";a="179856628"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2021 21:33:41 +0800
IronPort-SDR: ygBL6sAAvZmOwfxINZIZ4p4q4tzSjki6WlObJgyfOdnYqXyhwYozlnFg5Px5qSCEpEm5RUnWE0
 NX02XFNHrfI5m2k2oReD57frQaebGAslEvOA35dpC2ZMk9vS6ukRKmBu+0Wp5TcqkbHcSob9Al
 BSBm94Q9wqFZFJ9JDRP8zUU6GWfAjSmtkd3PqQaxNVWUjRwwMSELhOMjk2IqRRglBYQA79BLfP
 /w8M8Fii3FSnDhMGNKphC6f18/qFjk0RqBUg1gB7nM8V616tdFUzmXcsPwkq6hUCA7Tg2SrvkV
 8yraaRtrIKSoW9/UyskW7Ias
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 06:10:07 -0700
IronPort-SDR: 8NsLXAoR9SUGC+xAWtOIOs+cflEltCQAn3ygfA3P9Z9UznjU47sGgqRHWznC7NOM9ncL3WTzKL
 HVD9BpnF2L6M0SEfEhvKjnIGyzsU0zK/l3Tvi5Q1tk5eoCSV/2Er7Ed43GCJUiwg4UtQkaFTCX
 qVgKRRXJCSxeYFeVKS7EM7f92VcEk6xAjRFVofev8xCsdM5pyfaX7R0UknuA6GaN/SONbL+uTA
 rDkAuTHHQ3cOJ0ryigMngF6C5+4O1nwcfw+hY1krJ+4p6qY3/kn04jK5U62VB9VlvAstNM2PUT
 VWc=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Sep 2021 06:33:39 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v4 2/2] scsi: ufs: Add temperature notification exception handling
Date:   Mon, 13 Sep 2021 16:33:03 +0300
Message-Id: <20210913133303.10154-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210913133303.10154-1-avri.altman@wdc.com>
References: <20210913133303.10154-1-avri.altman@wdc.com>
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
index 390748a9d547..2fd100e92f81 100644
--- a/drivers/scsi/ufs/ufs-hwmon.c
+++ b/drivers/scsi/ufs/ufs-hwmon.c
@@ -192,3 +192,15 @@ void ufs_hwmon_remove(struct ufs_hba *hba)
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
index cb20720c5deb..3f9b56800e5b 100644
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
index 798a408d71e5..d811fe079e04 100644
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
+static inline void ufs_hwmon_notify_event(struct ufs_hba *hba, u8 ee_mask) {}
 #endif
 
 #ifdef CONFIG_PM
-- 
2.17.1

