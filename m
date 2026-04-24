Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF9F33FE0F
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 21:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067630; cv=none; b=BbRWEpHA/4A5y7ap/N2LP4ci5d2UDCXn8bfQlJA9QzPcTJo4a9y/E4T1th0y81UUnSdgVqtftgatqq7sWwKT+zK78MG/7vdqJ4W3AL1F7Tz1tPgJiHOq4M1XlgHji6AhPSyuyDrjb/HcAdF2vahby+KbhQdvn/lhg9iVyuliRf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067630; c=relaxed/simple;
	bh=PnWz1S0Zose+COl6fZw4lMNJcB2Dq89z5m0ql2PCFDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=favkxHzniR4TAKgXADLPNz7FNw0PvBW6wzAv2tJ9/qNcrO4xjintnydscuyKtJifHQ3ECRGe2deAVfgsrsEDiuTBbayadMVN0bKHdEDNFRl1t4QfsqoNepsrCl5mDW7PZXQiYIraY9XkA7lA5E/DxndmYD6EIuchSYI5JT7V4q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=RWlGNuPd; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="RWlGNuPd"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2d8fa0fadfeso4564884eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 14:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777067628; x=1777672428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d96sHlQz67CIjDGD+FdLfgvhcwIrHgYyB/9nNBhUY6Q=;
        b=RWlGNuPdmjvHjqKJ7ADzfLCbkkBG0NNWnDqxteO1+Wu4f0lDJM8Eu8m0TH25oNCx06
         DKqdwq4CWmoON3FXYwgYAfUFrHN6o9N0pISasYsFMU4TRKXAJP3kFT+qoMcB4tVZQfme
         iBcjBRZi1q89bCd6EqZ47/ciJw94GGvjpkxAU8SGYIJaDD9Gzgoy0wcpqlrkm14voRJk
         YWkXsKljpXnGNzjWXMJTuGYE4bXOjKnhDAgtjZJTQquFfymxYu/GmdUseNHLZVGZd7Yi
         aubKPuZW0hkwztMBBCfO50B9QqI1AyGF52eacw24vSvKDGho8WdVJdCTA8hSbytKY9/2
         rSUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777067628; x=1777672428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d96sHlQz67CIjDGD+FdLfgvhcwIrHgYyB/9nNBhUY6Q=;
        b=bBWe41pMBdkZGE1v4JmcOfp96/LTOzq5gpTK1nMdz6kzDUhDiQnrdZQsTtSxXmVbZF
         s8l2+3tMw9f7jYIJQ6U4luzK9oFWzWD6iLM20ZFr9J6aSkPscHjJkfam38JKS190oVYG
         unT9uRtOJRJxRcJicXF2visldsGESSSVwpbwA6OxYRtQTIr93NnXsUydJPJ+QUjXnNCq
         RifVxaCMJsQ+jxLXv0KjemdA5flBNcyHxxsu7AS4aToN6hO2rVVE0ENaeIeierwMI3ZA
         tT7t9lmx4ebxJ5RUX8fAaorBbtZf2c1bg8Lendg3cYaYqNQRR8/cI9RzC1nEWQu1Ib+C
         g6pQ==
X-Forwarded-Encrypted: i=1; AFNElJ+PiysVfN452mCBUs7q98Pi93TJW8hdF1Y9V1CMupsNF/ubo6NsPGD6Jn3Klo/JsPE7+2/3LoYAUQNL@vger.kernel.org
X-Gm-Message-State: AOJu0YyxtWNvZ3GB1TU93HcVj29Tj1aBdpmwsUv8LkflgPie2hVEI+Vu
	O7wyUzq3I8l+hn1vDf5gH49jq2z2ro90443cilLbqXzU6frkcKXrSPTymlZoXxdDxLQ=
X-Gm-Gg: AeBDiesNmwDTY1XTG33rZ+IjvMMQMpO1VV9EIBynRbPuliBx56YSr24+aKQNbEt/iVV
	LqEuHuNWjKIalkU2O8KIdFfGj4a/iL/zfNYOMUdhgzmJ5woixuwx2Ue5dywCU3SsGwZE1NhiOhn
	EvPsjzJxEv41/LHUV1ZdZ7LzDuOV86mqDpBZ3V5Ng/VGpRuTetbWoKBuSWC6nMaNb/8f00wVGln
	jc6RD1rep+wTgrPunCPmPy/Rtc5YwDYl7UQiHgkI1/AwrU1iUaAtFQWpyr1dphh1pyQoi6Nca/n
	wkjTRwpNMGV5pvUOqTYUVVHm0mHu8tNbAAajPDKQM9whrRcIMq4vdz5YzYs72Fw9JPmHi47qcLz
	7I0H8H4kd8ZCWDnSfcdiG6x3zYHQfaSiCelEiD1kj6MoTnxD3t8wRraw0LvpMcgqd1HWdwUZajQ
	IM81lMesjB8xyNYy5ninJXfdA4jmD80Z8XZ4BE3CAGGIWg76uiufbt040V/b5w99WXIUX7uQmrw
	zogsf9maNeGjj8P0/PHKryS21I/H1kwbyV1XbQh8J45lsiD/cFwD0Z/w1xZngNm/AMpMJl4J51t
	rwEIk9nneq12ZUFIuJJpC4V4I98lFa9AAkI=
X-Received: by 2002:a05:7300:7493:b0:2de:e194:5fb1 with SMTP id 5a478bee46e88-2e42ce4214bmr15468909eec.7.1777067627944;
        Fri, 24 Apr 2026 14:53:47 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e539fa5c38sm33172246eec.5.2026.04.24.14.53.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 24 Apr 2026 14:53:47 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: hare@suse.de,
	linux-scsi@vger.kernel.org
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 5/6] scsi: Add device reprobe support to scsi_rescan_device()
Date: Fri, 24 Apr 2026 14:53:23 -0700
Message-ID: <20260424215324.99045-6-brian@purestorage.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424215324.99045-1-brian@purestorage.com>
References: <20260424215324.99045-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update INQUIRY data on rescan and call device_reprobe() if PQ or type
changed. Critical for ALUA unavailable state handling (SPC-4 5.15.2.4.4).

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 131 +++++++++++++++++++++++++++++++++++----
 1 file changed, 120 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 554409300746f..d54f64ae80f61 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1091,6 +1091,12 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
 }
 #endif
 
+/* Forward declaration for use in scsi_probe_and_add_lun */
+static int __scsi_reprobe_inquiry(struct scsi_device *sdev,
+				  unsigned char *inq_result,
+				  size_t inq_len,
+				  bool *need_reprobe);
+
 /**
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @starget:	pointer to target device structure
@@ -1647,10 +1653,94 @@ int scsi_resume_device(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(scsi_resume_device);
 
+/**
+ * __scsi_reprobe_inquiry - Update INQUIRY data and reprobe device if needed
+ * @sdev: The SCSI device to reprobe
+ * @inq_result: Buffer containing fresh INQUIRY data
+ * @inq_len: Length of INQUIRY data
+ * @need_reprobe: Pointer to store whether device_reprobe() is needed
+ *
+ * Updates the device's INQUIRY data, attaches VPD pages, checks CDL support,
+ * and determines if the device needs to be reprobed due to type or peripheral
+ * qualifier changes. If no reprobe is needed, calls driver rescan functions.
+ *
+ * This function does NOT take device_lock - caller must hold it.
+ *
+ * Returns:
+ *   SCSI_INQ_UNCHANGED on success (no reprobe needed)
+ *   SCSI_INQ_REPROBE_NEEDED if type or PQ changed (reprobe needed)
+ *  -ENOMEM on allocation failure
+ *  -EINVAL if INQUIRY data is too short
+ */
+static int __scsi_reprobe_inquiry(struct scsi_device *sdev,
+				  unsigned char *inq_result,
+				  size_t inq_len,
+				  bool *need_reprobe)
+{
+	struct device *dev = &sdev->sdev_gendev;
+	int ret;
+
+	/* Update INQUIRY data */
+	ret = scsi_update_inquiry_data(sdev, inq_result, inq_len);
+	if (ret < 0) {
+		sdev_printk(KERN_ERR, sdev,
+			    "failed to update inquiry data: %d\n", ret);
+		return ret;
+	}
+
+	SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+		"updated inquiry data (type %d, PQ %d)\n",
+		sdev->type, sdev->inq_periph_qual));
+
+	/* Update VPD pages and CDL support */
+	scsi_attach_vpd(sdev);
+	scsi_cdl_check(sdev);
+
+	/*
+	 * If peripheral qualifier or device type changed, caller should
+	 * reprobe to update driver attachment. scsi_update_inquiry_data()
+	 * returns 1 when either changes.
+	 *
+	 * The scsi_bus_match() function only matches devices with PQ == 0,
+	 * so PQ changes cause driver attach/detach.
+	 *
+	 * Device type changes require reprobe to match the correct upper-layer
+	 * driver (e.g., sd for TYPE_DISK, sr for TYPE_ROM).
+	 */
+	if (ret == SCSI_INQ_REPROBE_NEEDED) {
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+			"type or PQ changed, reprobe needed\n"));
+		*need_reprobe = true;
+		return ret;
+	}
+
+	/*
+	 * PQ and type unchanged, call driver's rescan functions to update
+	 * device properties (capacity, etc.)
+	 */
+	if (sdev->handler && sdev->handler->rescan)
+		sdev->handler->rescan(sdev);
+
+	if (dev->driver && try_module_get(dev->driver->owner)) {
+		struct scsi_driver *drv = to_scsi_driver(dev->driver);
+
+		if (drv->rescan)
+			drv->rescan(dev);
+		module_put(dev->driver->owner);
+	}
+
+	*need_reprobe = false;
+	return ret;
+}
+
 int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	unsigned char *inq_result;
+	blist_flags_t bflags;
+	int result_len = 256;
 	int ret = 0;
+	bool need_reprobe = false;
 
 	device_lock(dev);
 
@@ -1666,18 +1756,37 @@ int scsi_rescan_device(struct scsi_device *sdev)
 		goto unlock;
 	}
 
-	scsi_attach_vpd(sdev);
-	scsi_cdl_check(sdev);
-
-	if (sdev->handler && sdev->handler->rescan)
-		sdev->handler->rescan(sdev);
-
-	if (dev->driver && try_module_get(dev->driver->owner)) {
-		struct scsi_driver *drv = to_scsi_driver(dev->driver);
+	/*
+	 * Rescan standard INQUIRY data to detect changes in device
+	 * properties (vendor, model, rev, peripheral qualifier, device type, etc.)
+	 */
+	inq_result = kmalloc(result_len, GFP_KERNEL);
+	if (inq_result) {
+		if (scsi_probe_lun(sdev, inq_result, result_len,
+				   &bflags) == 0) {
+			/* Successfully got fresh INQUIRY data, reprobe if needed */
+			ret = __scsi_reprobe_inquiry(sdev, inq_result,
+						     sdev->inquiry_len,
+						     &need_reprobe);
+			if (ret < 0) {
+				/* Critical failure, bail out */
+				kfree(inq_result);
+				goto unlock;
+			}
+		}
+		kfree(inq_result);
+	}
 
-		if (drv->rescan)
-			drv->rescan(dev);
-		module_put(dev->driver->owner);
+	/*
+	 * If type or PQ changed, reprobe to update driver attachment.
+	 * Must unlock device before calling device_reprobe() to avoid deadlock.
+	 */
+	if (need_reprobe) {
+		device_unlock(dev);
+		if (device_reprobe(dev) < 0)
+			sdev_printk(KERN_WARNING, sdev,
+				    "device reprobe failed\n");
+		device_lock(dev);
 	}
 
 unlock:
-- 
2.50.1 (Apple Git-155)

