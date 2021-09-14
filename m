Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CB7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 20:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 131FF60FED
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 20:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhINU3b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 16:29:31 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:33103 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbhINU3a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 16:29:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631651294; x=1663187294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rrTT57VXaFXFCfJy0UFzkkjADsvPq9XzmBKbA1UyKXI=;
  b=NnJJ5x/G2lXCm+SC7E74dvdEU6jFt72zCyqCL908MV+M4gUWrVDS/XuI
   C51C+VHEp1uGV2LOE3yfngKVflwkxPpua/qrr3jBrZehhuFDHdxrM0XAi
   dF3f1wBlr7xu9//WbYE5c5TUBZa+eLjCG0g7bDpPuZg1CKD1l3vOeGa9/
   aaJHvBWOU+YqzBJIDvQECRKYXF248dCK6JzdycY+TXV9ZqpRKpjKVD+2W
   ZN5h/4F/C1GM28S+UaucxVzU8unAjjiadkRFAAtHCWgU0cKJygK6fWvUD
   Y3tdNsp10sdQaMzkOSRKRQhBxGXYdgSjvHB55Cqrc1y9VtVRi0v/TF1k4
   A==;
X-IronPort-AV: E=Sophos;i="5.85,292,1624291200"; 
   d="scan'208";a="180525225"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2021 04:28:13 +0800
IronPort-SDR: mYQ5cTMt+wTH45Wg1LAO8U2pYDu47b0ZYtIMOc0lKU89sswekUwx4fj0MKb7quRj/mIxEAB5EN
 xYz18RML2HJLlS+TPCxvvH7op6YD5wSkjVpgpluth1R4rR82wvtgYYi7nJ+yvnfLeAHuWUw/bS
 5O1Z/L4BpVLFmZlqG62PjGlTpsN9hIvsS1/5gEvneOKFIzE7fve0C31FJrtfKs4ReH9+fLGC26
 CTIKhxWzIBgxPXX4jWneLgYWc/yt+/dl5a6cdHgWnqprgASd0NabzVxj6lH0mdqjIHCyMOKhHu
 SjZFMv6r/rSE6SNPSzH/khPg
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 13:03:02 -0700
IronPort-SDR: dKuOtdZi5CjPSxExqqkFbPoHtfJjyK9koiGog+GCHyJudA86zSbKE+sgbZQazzl/McIalDk5sg
 BBR4iGXZyUdrq3y9rjdrBCauUVlcLxHjtSeXU810c9RllSwwhl8BOnGmwNU07Edr3DuD1ufIul
 iPX6as9JHrduy0pVn0qXtR1Qb/mnpcwceu/ZtXnDEdYfJZg8218D5n4Bd84GA5zoBoMsRcR+Kd
 QYrzpLsgIUDwe/anHy1tNQSls8WwsUXGXntbx3E8bNbWhxgLLe8R02ybp1EL9YaHrQzmBtb00x
 kXQ=
WDCIronportException: Internal
Received: from h72zxy2.ad.shared (HELO BXYGM33.ad.shared) ([10.225.32.116])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Sep 2021 13:28:10 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v6 2/2] scsi: ufs: Add temperature notification exception handling
Date:   Tue, 14 Sep 2021 23:27:31 +0300
Message-Id: <20210914202731.5242-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210914202731.5242-1-avri.altman@wdc.com>
References: <20210914202731.5242-1-avri.altman@wdc.com>
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
index fa8ac39f4444..8efc0bb1efed 100644
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

