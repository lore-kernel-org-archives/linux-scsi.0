Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2C04C227A
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 21:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839523; cv=none; b=EACekAlJVe5NanY1i/PuvDdo8W4BdXciek499omX4uwBEte1MjnDM9WFj5u5ZmyUWm5a7BBwj3F0x5YH4lNGdVi1SluTzqy4XEhb2tKFw+AtJE1DbXGIFFmPCbAWM8HRIJ/Y4ByUkjM1W9U1SJchj7Zln3tQVukt38ZuHV8eOr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839523; c=relaxed/simple;
	bh=Mh/sfkqklmdpXVjVR9eiA/oF4hpqrHrQ7smlN2NUTN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MdRtxDhXu+3Tee0sH6c6uRXieaXS4fVVQQeTKWeFN+ehi12kFj3RsXIflawaBJGlfwV6RlUOceOdEGiab1SRkgMBMOYwu0RSiQOPIny5X9AWUQ7ERvjXU/WI4t/K4KSP8YaAmCdHDO++M/ElDOs1hZ8VxU4GierpPCkbg/t7ylM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Rc2SjQNW; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Rc2SjQNW"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-170135e43c7so1299934c88.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 14:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1791839520; x=1792444320; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gfdA91vTtHxG/P4S1kd90yVAw/BVBeAcIpv7oGJROzA=;
        b=Rc2SjQNWVDzVZs0bILch99j5hWO3ilSpgUuN1TfXji0PoI9d5Xz3pK3ccqN7nuzbkR
         BFrrzazw8kRhyvZup5qr1SD5hrmxF75kXyoa9Au6bjjWMjaMRNIOM+K23qwkmHZ58uHa
         BAcyY5sSxXD16mqHkTGqL2uq3IuhZYcYku+cHHw1r85Fh+mGzRNNLm+9yFNHK3X6dBnu
         bheEWK2xS2zUHEDrjcCKS1qENginEbfDks7XBA3lDTiYQ1Mt7+jbD1ruTlgdvDDaptSb
         kUD3I+3c3iVvXKdtWOxDgaE4s7/vIvykrzcR52Uy3hqwOpgmdAHFH4AOk6xDTOE1Vsdj
         Rmng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791839520; x=1792444320;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gfdA91vTtHxG/P4S1kd90yVAw/BVBeAcIpv7oGJROzA=;
        b=mdHuxiA6XwYs2SUq2fF7chIuJdJJ0QF2WWqL6zhwRX48aYjtmQDl2wzodjHrVY5hp7
         bLQjP/5JgdJW0n7EBM0s/hi/VDiVg/CerJlxfWnBSaJM3fPV2gOG9WnK8h+KktgTo+cZ
         gaQ+casxpzLAbEIpQ63RYGvDSH1qQf7Sl3keXrpijPQOF8xCU2PWrbmv9A/WLxKXWAR/
         Ge1kwqG89TCE+vr92lkKFb1xDzKuE8i0oGsyrxQI2+JJoYAlm54M3Yrm7l5zi4Vqtwqr
         nwT5N+GH5HkrqZVqpPviEmSDiTc9VMUfKo1E52a5nspvBv6hqtZ/r6VBLLMpa+WvUtJh
         FEpA==
X-Gm-Message-State: AFq9FYLfzPtPRwQ05gMNgXrE5sfPyboSIv6qyfvriNPM2WRtX4gK4wWT
	9/DIrH58ZWv4npkBD14EQ+t2m7jf8s70TVc3lgTrBKLNEtBtfV3q7vtggkjP/ikZiwrywoh5/Xl
	5NVIJA9x2l13x0bgPGehT89WpA+IP2ne0VeIXP+iTspiCinK4qSiehKuGvT4KXvvrYvst1LxQq4
	D22DjWo49KIqzjFoL++JuJFYANpzCZaUTdnE+2jaZNmOIvIoebug==
X-Gm-Gg: AYBFou3y8NkK2tlxtdIDr5OsBRuY4u/tnZMmftzrxjVFgS7kpZbC3ab/sewFaYeQnGa
	PnsBczgLFiAM2ILejZjFjDtMftSXa/5TfBbmQFi4O59hKMNpPgjKS2wyirCDo/OfdTAie834o7C
	JXxQRqDnTpgADGv/83ZsMwKJ1VRn6w8blmkfwRYTD2pxS99SMJLluMUBE+YaD0Iv6K7EvvU11Yw
	UgKItwwA/zCAs2g7tRoWwE3OlhBkojwlmlyzuaRoFwLVSK75B78SNO+fWqeEyvYOCaZLPTIOjwO
	cKQEzm53/Nhs9a4S+C/nGu/Ayv7I0o1n00HkmImRKzM/k294wY+yTISY3znYr3oj3QWqaLfeVme
	d0PheWA8dAIErX68QARJ+294wfbPF25jA1lfDjVGiMwsDhEVojsPZa9GekzNTioQDBfii0iWQbH
	Kh441HIuOdcrcs9KiRsCqWzX6+AFXq5h+Q+CTg56VZtu+Nr12QV71mx5SdyEbGLOsYipoQrvb19
	FJbZ/kr5xUkovQ/mLIx1Z+XzOKWq35QjqEcAy6SXkk5S/0dJzXljCrArBrtkLjXrhBD9C9/IsFe
	AyEjlLx7voxF+Dc/Q067J+5iuyHLonye7uHjYia7mKIHdhmhHcv61z3YlyT3IwztPd9e5A==
X-Received: by 2002:a05:7300:aca5:b0:358:1f59:48c9 with SMTP id 5a478bee46e88-3581f594a27mr16090145eec.24.1791839160752;
        Mon, 12 Oct 2026 14:06:00 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.201.68])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb2fd33sm35528777eec.28.2026.10.12.14.05.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 14:06:00 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v6 4/5] scsi: core: Add device reprobe support to scsi_rescan_device()
Date: Mon, 12 Oct 2026 14:05:05 -0700
Message-ID: <20261012210511.16061-5-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012210511.16061-1-brian@purestorage.com>
References: <20261012210511.16061-1-brian@purestorage.com>
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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 135 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 125 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 93a8719fcf26..ddb92282d49f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1097,6 +1097,83 @@ static unsigned char *scsi_inq_str(unsigned char *buf, unsigned char *inq,
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
  * @shost:      SCSI host pointer
@@ -1661,7 +1738,11 @@ EXPORT_SYMBOL(scsi_resume_device);
 int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	unsigned char *inq_result;
+	blist_flags_t bflags;
+	int result_len = 256;
 	int ret = 0;
+	bool need_reprobe = false;
 
 	device_lock(dev);
 
@@ -1677,18 +1758,52 @@ int scsi_rescan_device(struct scsi_device *sdev)
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
2.55.0

