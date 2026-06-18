Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992DE1DDC1B
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 23:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781825740; cv=none; b=FYqmtCHpDaZ00cILv3eX9+SVa8XjegLKZDgJqNdknGG7jrO+hnGI//f7G6cdb0ajPE8hTXLRk+6bosPwFEgNCKC13frvOy0hzrDz4b+30MUeI8GmzOyRauBdOrJlHdoyTCiWacTTtL0BtNE7opEekhc820cNH7B973Of1s+8W/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781825740; c=relaxed/simple;
	bh=Bn45xdC/8tt7OH1KOY4h/LH+L9yq3mY0eHnTK41RMEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PuxJGz/iPe3GMDIECPHxQ/W0KGVeZAUdMdZSR11uOQC0XIfvflHjJAhFXoZWI+8bvCjJ2diXSkgrI0QrlobXsQ/NOla4FSLxTK+BEzgMsFWHpq+r7Juy13OHR1IoqVnipklQMOWNt7vUgJ3yibgGsVOtk6OJLZD7G+BaM0HrCP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KKM6pKt3; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KKM6pKt3"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-462342ac290so1730209f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 16:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781825737; x=1782430537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZtZkHdc0Md3AsdH1+uTMRtWr11Ixn9LuKmfES+JG1Qk=;
        b=KKM6pKt3IVhy62TsQs4n/Bps0kjZUcKBxyzO+JcStFFNK7VD5HHV0Wo2kdGv/G/WbV
         Ggi7dr8huGuFMd0y0oshfMBr9hrco+0FEVO1Be5Eq6f0x2b7UkBaBMjAAiLpM45y2Ccb
         flL8CdhK5LBaEut5EH0Y1RyIob/jM1jD6q9+gulaLXPdhcmfiRHVaBDp2EIVAQQX6gzb
         5mXbZAGWzbfxdlJ0Gx5sPCROV12d09kLzSFSiXC/9+u6Bb8iEmXOVRcHrsrGJSvxONUX
         bGnciO4NlvZkZuDy+JkPGDpvfLi7NhC0pDTGnupq2fuYOo05Dcmqpej04jUorNuQkEg9
         fHxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781825737; x=1782430537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZtZkHdc0Md3AsdH1+uTMRtWr11Ixn9LuKmfES+JG1Qk=;
        b=TK+/Ri0Y61EKfp+p1SexKN5HS1B0zSbT8kquxCicENYIETxFo2yiqr7NlTrukaB0lF
         cyPEBU3bdwjN4FhRku5AVN5xfsw2rkvWVWOFRaY2w/g75LHEaFxqypGq3bgwrCxYbvx6
         1VONeF5VPR1Fcqw1+FI2/fRC4f83f1zH1QG8ltKEsjlFip/UF0kCHmtN5l0yHkQE5zDM
         IEYcCKTwOs7La3tePZseeAb/sR9EBQ4QRSnaN+VY7KPH/LrOqwv8iVgZ8mP8Wb5hIy1K
         enosQL0z+o/RMVkpaiUPpCi5EWFpjEepnBrmON+H9z90/OOAuvKqhFd7BE5dowOQ9odY
         NYaw==
X-Gm-Message-State: AOJu0YzLYSuSayjrB5jRlbk/UDovPSWaL3jEmBb8b3a/sGFMh5vVKdCj
	ggzFQfzFEHDYjFupZA/vOYQozS6fb6diJpkhxjnO6cpFriimUXjjzCxAFkaH+hbz9rnhInMky92
	G0AX2oeeC4VyhKrVFWE6IGrVdP8+/a3LGXLDad0C+LJef7AjYiWJSILqO9PouuSRnwxY0CKCs5r
	ITsWsXqXCnj0T15MqdvH6y8BEqss3iPtFM2URRMeSBDtmoNmvdWQ==
X-Gm-Gg: AfdE7ckOZzDPt2XDu8/RKUfIoROC9HVEZOXL3fvTlYYfwG1Phkf0uKS1wSU4j1EONDJ
	Llnqlm6JqOSY+FC/3aS2pAm+dXEMsBGYDd6UEZ1iP8y+Y6fE+GizuwGX/XHfiXBD2sZ5N6Yrz2a
	E0it3zD4Y5XSLBF8jsOoGj1Op+HOjpLtE22t8rlQKk8VptVuEthJaVWRzMKZPLpdUCJdBZWYuRE
	kZqQSgJOgcCDcft3MbuxovBCZDUd39eqc4XSCWNfVu6QGLz+OJ5xwXEHnhDS9aQNPhoVZtUKQHf
	SVj0W1BHsz8d6DV5cmuDui22VSsItMxrHvxK7iQ2bXyzWGrNW8BAgkyQtE0mtMwuQBPpOfoqIy6
	TsbG1HbyLaUj5LWnXgKtNZVAC25yBHbYjwPkayS5mVqgDzKhURFJf9ssKtpZTOI2rlmi3+n65OH
	oP75afrRa2FidW47EcteTKy1m/+oORgD5WKsdmcytelkSeD8f2NNxJfzvhtrjI2hS7m4iFm390P
	TWvKCIYfAw5w6vgwixjMJSyLD1uTPHm0Zl86b6h+0xCpZbIY+zTZtMFjzFKmCsdAKXuHqpUvCHg
	Ks2NS3t4kpvG
X-Received: by 2002:a5d:64e1:0:b0:460:3233:bee8 with SMTP id ffacd0b85a97d-4656eb9d757mr107196f8f.40.1781825736975;
        Thu, 18 Jun 2026 16:35:36 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650b67a34asm3492468f8f.22.2026.06.18.16.35.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 16:35:35 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	hare@suse.de,
	bvanassche@acm.org,
	krishna.kant@purestorage.com
Subject: [PATCH v5 4/5] scsi: core: Add device reprobe support to scsi_rescan_device()
Date: Thu, 18 Jun 2026 16:35:03 -0700
Message-ID: <20260618233508.97960-5-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618233508.97960-1-brian@purestorage.com>
References: <20260618233508.97960-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Update INQUIRY data on rescan and call device_reprobe() if PQ or type
changed. Critical for ALUA unavailable state handling (SPC-4 5.15.2.4.4).

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 135 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 125 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 58c3818eefc2..e03a209b7bc2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1098,6 +1098,83 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
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
+ * and determines if the device needs to be reprobed due to any change in
+ * the standard INQUIRY data. If no reprobe is needed, calls driver rescan
+ * functions.
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
+	 * If standard INQUIRY data changed, caller should reprobe to update
+	 * driver attachment. Any change in the first 36 bytes may affect
+	 * driver matching — PQ changes affect scsi_bus_match() which only
+	 * matches PQ == 0, and type changes require a different upper-layer
+	 * driver (e.g., sd for TYPE_DISK, sr for TYPE_ROM).
+	 */
+	if (ret == SCSI_INQ_REPROBE_NEEDED) {
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+			"INQUIRY data changed, reprobe needed\n"));
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
@@ -1657,7 +1734,11 @@ EXPORT_SYMBOL(scsi_resume_device);
 int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	unsigned char *inq_result;
+	blist_flags_t bflags;
+	int result_len = 256;
 	int ret = 0;
+	bool need_reprobe = false;
 
 	device_lock(dev);
 
@@ -1673,18 +1754,52 @@ int scsi_rescan_device(struct scsi_device *sdev)
 		goto unlock;
 	}
 
-	scsi_attach_vpd(sdev);
-	scsi_cdl_check(sdev);
-
-	if (sdev->handler && sdev->handler->rescan)
-		sdev->handler->rescan(sdev);
+	/*
+	 * Rescan standard INQUIRY data to detect changes in device
+	 * properties (vendor, model, rev, peripheral qualifier, device type, etc.)
+	 */
+	inq_result = kmalloc(result_len, GFP_KERNEL);
+	if (inq_result) {
+		if (scsi_probe_lun(sdev, inq_result, result_len,
+				   &bflags) == 0) {
+			ret = __scsi_reprobe_inquiry(sdev, inq_result,
+						     max_t(size_t, sdev->inquiry_len, 36),
+						     &need_reprobe);
+			if (ret < 0) {
+				kfree(inq_result);
+				goto unlock;
+			}
+		}
+		kfree(inq_result);
+	}
 
-	if (dev->driver && try_module_get(dev->driver->owner)) {
-		struct scsi_driver *drv = to_scsi_driver(dev->driver);
+	/*
+	 * If INQUIRY data changed, reprobe to update driver attachment.
+	 * Must unlock device before calling device_reprobe() to avoid
+	 * deadlock. Hold a device reference across the unlock so sdev
+	 * cannot be freed while the lock is dropped. If another thread
+	 * changes INQUIRY data in this window, that thread's execution
+	 * will trigger the follow-on reprobe.
+	 */
+	if (need_reprobe) {
+		get_device(dev);
+		device_unlock(dev);
+		ret = device_reprobe(dev);
+		device_lock(dev);
+
+		if (sdev->sdev_state == SDEV_CANCEL ||
+		    sdev->sdev_state == SDEV_DEL) {
+			put_device(dev);
+			ret = -ENODEV;
+			goto unlock;
+		}
 
-		if (drv->rescan)
-			drv->rescan(dev);
-		module_put(dev->driver->owner);
+		if (ret < 0) {
+			sdev_printk(KERN_WARNING, sdev,
+				    "device reprobe failed, marking offline\n");
+			scsi_device_set_state(sdev, SDEV_OFFLINE);
+		}
+		put_device(dev);
 	}
 
 unlock:
-- 
2.54.0

