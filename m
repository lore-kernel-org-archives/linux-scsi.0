Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F4A17B43F
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 00:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780100449; cv=none; b=jpDs2a4VgjRtXTo+oljB+8Tkpnr4smq48/rANmVYZrbS+iwiRSMWmNgZKiBnaA/6K8MHvCqtO2Gauflf980ekDVEWGuhjJzr8kffl9vGJAGsJg5U7X6uiTgUwF4ZOxyTx/Dj/uoNDXifRpnoJHI50Jp22eLOpgDFcX9rfK7dgwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780100449; c=relaxed/simple;
	bh=zbrjbwjyVpef9LnCkOLWX6dtGqUrgwAhdLHYkF4e43I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJqM+TVq0roOdCA1fuhhSGzyC2xHSU3bs9YeImADWcxBsDD2yZ5+U6dgsuJkgHeL+upbz3fFwZQbZ428XpHqH2c/mOeKh2oPYkSsyUY6H/XniuuVpDZ5Ul9+A3eCaKBlF1kBYuPxQtdEr9b5xfsjBz+OGlvDUA8RdIJcxcuyA8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Yg9JUwTa; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Yg9JUwTa"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-13721dfd471so6833792c88.1
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 17:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1780100447; x=1780705247; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VkTEnYvvug8fAC+K+JcMlGUmjqYa9wMPYq/L/RnB76M=;
        b=Yg9JUwTaIbMYcHDbAhnkUo6VCDrHwy0TFH7+Xy0mZpmR74w2USFFMpE0FGUt/8ZgME
         qCBCL+xS34vy9H11OjPfA4FzHd2WSxiEBGGK4cgrLOHs0QWhvcCVYeMxIZaBqOo8CqMe
         91lUYfWCCjdbnWD75k6H0QS0u5VXzffT0C65ZDeM/1vbDxUGOdaFxpokwkQ/1TiljGVO
         UV8ucKchqi1US8sgphmjs8mfQMDddC5CRHT0c+m1xtBUdZqELQ40m6PFbNDR+/u61WMv
         BbYcGIY7OuQ9RRjtlkA8XX1DHv3JozHVFzLzqxF7e5kPcdWkAGyUm/Rsut/IaDWPnNBQ
         1SpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780100447; x=1780705247;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VkTEnYvvug8fAC+K+JcMlGUmjqYa9wMPYq/L/RnB76M=;
        b=NOVto0UnM2npiUyHjmJ57DvvIRix7ytuFzc1sJRHG1AdPXe1GzWpsVAKtoUO7fs+cU
         a1dox8xRORitIG5wS7VfR6DERb4y+ai6XijwMcg5BeWudzyj4eC+Tl5VDpvwPe4N3wKy
         nzDz/Xv4emVg7QJwZ54MrmkIqSqUhR7latwqV7IV6OToT72BBmmO/JR1bLhtu2e1Xevs
         dw2+DpyEyts+0OcqGk/pBk3m4R4S8Gr0muQqzrSBLNWCjJHEYocJHDx1hmKrjcgmRvmv
         Js84nO1pS5d9QakQMuFVetKnn2jJC8eYfA9/Vn2+pJJjMIw84azfU7YNObeWVZNa8Qmj
         /wkA==
X-Gm-Message-State: AOJu0YxIigPwVpN42lCYTni5ohQbbaRJwx75YJwiNLiRghoKyFvnn1E9
	XzRimdlGwNcztpwbRG7GI7M8s1mmJeucCOXUfE3SaxHhkiXNvbtgAzcjS459zspG3XErbVXx2jD
	NrCvqtT6eGz8VwuvegTYoz5IcywXxjP63P1IEQSQ2mMd6MJssJgscXfW1dvPQm3STRmaN+D0/K3
	nVWBz+jGhr8eiSMqLH6V2EeyrTd+6sNUuPNfHdIR+G713BxbruoA==
X-Gm-Gg: Acq92OH2ZSYi8SkEyEDprUAZxH42fTI3VCrR1+xLnHUblAnIrUpT9o0Yfy90WkKODgM
	5qKFhBP1TG7PZrtFhENYErHdPf9cwgr7Mm8H9cjmo7sK89flsIH1sCtVvfeO1J/b06xrHx4rC1r
	v3+ktm6BZaJet3XBBcw/xSELUcPvIUSqx7t+TmGqenHT2RmVLUsIG6R+VIg/95UFCG5uf7aFyPf
	dlZy4YlUTglHucn3+q9FsxtjC5B3I8GLlfAD9IskFllQptuIM5xZ+Nm+lB//CUk3HbOvt0U8x6G
	BcAuA2OS6fcTYIJFd65c9ssVXJ7fS4YyvuVrwyCPMlfJRdvbT7aDka7ISzN9PK7q5fnx5f0LoSN
	UWb7sGqxV5TTHXIJF5zGB2UpDGfEWtji1Hd2MmefCHZsPwHLnoSwFKne+d/5idSWyy8JnQ7458A
	Gn1DgYTHduaE3SYBUDfR7gvgum/kqf3TQR2fmyffKik0msIe8lg/4udZBvgFYH/hsnF6AIUveLH
	2/O0ZekiYhhZeBMU2YCFVgXpsCLHsX2v3c26dv0i+PQLDBwTPIoWGqq5voEiXtTIIHC2XVY+3k/
	PkquSI2yusdldDxY7t8Hl96OSCpxF5Su4OI=
X-Received: by 2002:a05:7022:4581:b0:12d:ea6a:1d33 with SMTP id a92af1059eb24-137d4259495mr687834c88.33.1780100447120;
        Fri, 29 May 2026 17:20:47 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.115])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b3d8f839sm2027163c88.15.2026.05.29.17.20.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 17:20:46 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	hare@suse.de,
	Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v4 4/5] scsi: core: Add device reprobe support to scsi_rescan_device()
Date: Fri, 29 May 2026 17:20:18 -0700
Message-ID: <20260530002019.47109-5-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260530002019.47109-1-brian@purestorage.com>
References: <20260429224939.77082-1-brian@purestorage.com>
 <20260530002019.47109-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update INQUIRY data on rescan and call device_reprobe() if PQ or type
changed. Critical for ALUA unavailable state handling (SPC-4 5.15.2.4.4).

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 125 +++++++++++++++++++++++++++++++++++----
 1 file changed, 114 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 62409217ff23..89513f341d84 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1094,6 +1094,86 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
 }
 #endif
 
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
 /**
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @starget:	pointer to target device structure
@@ -1653,7 +1733,11 @@ EXPORT_SYMBOL(scsi_resume_device);
 int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	unsigned char *inq_result;
+	blist_flags_t bflags;
+	int result_len = 256;
 	int ret = 0;
+	bool need_reprobe = false;
 
 	device_lock(dev);
 
@@ -1669,18 +1753,37 @@ int scsi_rescan_device(struct scsi_device *sdev)
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
2.54.0

