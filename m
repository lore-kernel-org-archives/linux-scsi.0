Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCC7C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 06:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C9786113E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 06:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbhIOGFu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 02:05:50 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:28442 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbhIOGFt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 02:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631685870; x=1663221870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3ryheFD8WMYGXqB3SQZsHh9i8atB7PV0ql6LV51neAI=;
  b=cZGh3kvq9trh1aJzX3mRGvTdwsi9RyIQTPEykNzokKCy/MOkcUHnaz0d
   mcEPcCcRsSQRKtVr6tB0OO9B7zmEWPwnNxMZSAukANolFLdxeNKPKKKqL
   Ht/oxO2Qlor7kHueti56GYqlDGy+/n42gJGitYjZa7HSGD6CWD8ThQMaH
   x7HeFdbsZHHn+ALv2eGsQf3OpHJBjW++gEZGiAmdIk+IB4J5K+E7HOhEC
   SkSvFTrVUVwgdNoEndk483aMBXDeihCc+SPgxRaTRZQ/VKKhjbkmJ7U/h
   6kn8ZCvm1wX8HfDQqZAHvO04N7A9a60n/cdKXce7ogaDJb2WL6iUX5euB
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,294,1624291200"; 
   d="scan'208";a="184828931"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2021 14:04:30 +0800
IronPort-SDR: ICUVpuiofCjTTjRPY4804mexlyWAGWDB7rK61tNHdG1Ygj0nmKwW14mRjr/SWNlmcYqZkl6FJQ
 1cmj00LVQNMkSIkzWiX4k1U0ZtCHZJW080aa9hvoer07ZlG1P1CSg/XLOvi0v0+uYKEua84bW/
 +1k1HpYdu616SHpMPtQjt5sxM9exoLcuQoeKp60HoIKGrW2HFt6UJFuHOXAXppwPpi2y+I0ULa
 97PdniAI9RZq/zAbqFVItJE6MfiqvHmK1VTGIwJ5KbcOGlz6JOKlsF1ZMmGBahByjTZEFDtnyS
 YjItlbQ4NYPk+OyE7Tfa0dJK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2021 22:40:54 -0700
IronPort-SDR: CL+LRpxFApAQWu19BKH/sXv8rUNXHaK2SLUWRqrvpa1unfASF/U24ZGWL8HJAHBW6ssP3QvSxF
 56qi+eWsmVZuJCOjvK1OMD0tfL+fEDwZM2dlGFfcotmwM+aKSxTEJM49THbCZHZ0G/bGmkKFTi
 kjZ46XYYMAEVvKrJ+R5776K1cz4YKgNjm8Q1U7y7tUH5hnOjZWyWHcCeh/KheIy90gFqsTzCRd
 cfbWvsyJJg0Dcad0cVyS7aRI/tbyFX+KoJqsvXt0d6AIlT5WxGPvr0BB9j52ocMxrlMfxg9hQl
 nlU=
WDCIronportException: Internal
Received: from bxygm33.ad.shared ([10.225.32.116])
  by uls-op-cesaip02.wdc.com with ESMTP; 14 Sep 2021 23:04:28 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v7 2/2] scsi: ufs: Add temperature notification exception handling
Date:   Wed, 15 Sep 2021 09:04:07 +0300
Message-Id: <20210915060407.40-3-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210915060407.40-1-avri.altman@wdc.com>
References: <20210915060407.40-1-avri.altman@wdc.com>
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
index 33b66736aaa4..74855491dc8f 100644
--- a/drivers/scsi/ufs/ufs-hwmon.c
+++ b/drivers/scsi/ufs/ufs-hwmon.c
@@ -196,3 +196,15 @@ void ufs_hwmon_remove(struct ufs_hba *hba)
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

