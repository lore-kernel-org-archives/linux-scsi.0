Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1709F329E52
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763136148; cv=none; b=Nuxm5zBG2y7ynPdtPVP0w8dmXqB/bXWncTUwYiRPZlFq4Z6qEPR8fkq/7JPtRWCC/1M9fPCCE6P6KSqKeB8WPy/cvkTmJbE2qbNJShDDmTQguyTh6sEfzVWRZDCxG3mpVv9dvHQaav/60Qswldl1Qhn4DV82BU6yzrOPEMu3Oz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763136148; c=relaxed/simple;
	bh=NAo6jg2LnsFzq79Yyy9Sepcpt8yVMapb5EN8+9qrPc0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bsNjzkHtk4+irJs30BzRRB7P2xMLk3RxEQuvB0TAZXA9PMZ0O7vi8zkpWNSIHDM8ChsiFF7T4dESX2pyWz+R/g5lPKSLJOedgc98NN7FdOTrW6VHyqUkzfYIwkdRQ8d07r3tA0ufmlhqYhSn7LqhGNkaLhMzFjSl7/z6ln6PcHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=UxYFOB9P; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="UxYFOB9P"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b472842981fso270395166b.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 08:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1763136143; x=1763740943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pmTZXOfWZX0Mr+/cRQf0u+WRlIkc3jt36hl8BSckz1s=;
        b=UxYFOB9PPXMZws9UnU9jm2zLB3aMmbn+y0bIrwUDZmUlEj2ftNDUKfsAi33h2Jc6wy
         JB/TCNRh1R6H8roiIl16KvGJHjyI3Okgg+D65pnjNm/D69hpnjXRUCXAKRDE8VH/iTeG
         v+2JRB47KjJRzY+JS63rohOre/Kw8IjVwY9Ir0pg+8axiX9i/YVO5VXDFrMZ5nUee7De
         AFGQz77PTr/iB7n5rF7Sbn1gEdcxoB3LIkHamwBDItQrK/mukRh+dmIat6wwXmhcRKoY
         LGXeBpAeQ0fAYie4yMVWY9CiY7PjiSvAUFSLFbDo+omLdF9XzX4KeyOVAnLPfBaHet0L
         ggSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763136143; x=1763740943;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pmTZXOfWZX0Mr+/cRQf0u+WRlIkc3jt36hl8BSckz1s=;
        b=bLDPWTe8zwmeadjvF5Y9BPgZI2WRqhZTN/bcDK7J3voDnW3dJGFNTn6AenT/CCQHWu
         HtrLzNzXW9RqnGdXbBAA5QHdcJ84bLjL+1H1lUh6lPdqrMdyZ6EzWhq0VYaKKS6h8J6V
         o/Vab1h9e0oFepInPx32jBJHWJ+PGCvhbMAen4ydTytKNhxXEhIpm5ZAc2GP8iCatOZq
         2+zgj90b33hYfMDsqZC/1sYWJK9ktP9vng7QQyyVrDq30ffXsCHUIWFSrrhm7512rZ/f
         Jg4Hg24oB0zx5DHSNxVFGViKpTL0YClO3QGELRuocZh4Jmn7hUrKjGrGEmRQA/uyTsU0
         s9dA==
X-Gm-Message-State: AOJu0YwhNjXRRIjco+Y9hLzGx8nlHOjyjWjG/yTd3kjbQC46hgmH6Dps
	rrxTO8COw9dfrAxV+caG1uaKGhA0T/tqqgHhKcj/p73koAsymZ4y4FLBMQ4jZwbJqGsWf8kZ0OK
	Kxz6KUFUvQ8sg2Rj6/gKeLlMHwtLjk9jpLj9fgmb2pWMIFTzoxaDNCkvlo7J4DYvZ96eW3xX5I8
	PId43uBZXBn4cAF50rPbM4G+aO0iNUbXRQVL2spm9Pt5LBX0cw3Q==
X-Gm-Gg: ASbGncvwHZ35c+iu0ji8UnNXTGdsRp3hM0GGAiZQjrTSwEH17TlW5O8YfqSidIy4R5S
	trBcMuT8u++fc0307JFDTPpljupMj2V+Q/hJ0RyMveL6YXHe9SrSMmh/wxzBbgIxqrenuPD7twE
	gS3I1SBFScqz/4Tn4i2K8z6pokg2XfhjIaP7vYwZdZsfm9ZWmyfRCebiroeSOYQzR0oyQ4LeJ+6
	Ow65gu+3QGLiMAyOnaM8ycvLRRw32pOSGvgTIBQbe4t/mI4Z1Xlde1ImSbr6k3IvvmjEFWTR6fk
	uCpmYXcjB4OtHz8oduvQEllySFEN7LjsyBiZE+bPgvKleuGucUQKSadkqu8o3fxktY4js62P4xc
	w3kIkhhTzzNNvlK/CYPT+a8Jo8OPv0k19dRtJwuCUBogZ1NNWBtdufiafyzNFTsj71BZ9KtBnkM
	4MlABdwl0K6on3gARvHHp8yYNJek348btUru5okXmRD7TIZ1aw+ZDrHyPOGyy1D8tr1HVU6Soql
	IpZzDpvgyiKE1HrQQSEFp+XTzpWgeQas7U2xf6ThnCp
X-Google-Smtp-Source: AGHT+IF/faCSIeHkXMWiqh5HqJyEC9NK2qzdU75cRoL+u9rOaESnRjFUedfCLOXe9vd4uwu5EpH5BQ==
X-Received: by 2002:a17:907:7f07:b0:b70:b5b9:1f82 with SMTP id a640c23a62f3a-b73678eac95mr397580866b.31.1763136141031;
        Fri, 14 Nov 2025 08:02:21 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([165.225.243.34])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fdaa15asm406279366b.57.2025.11.14.08.02.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 14 Nov 2025 08:02:20 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v2] scsi: core: add re-probe logic into SCSI rescan
Date: Fri, 14 Nov 2025 08:02:13 -0800
Message-ID: <20251114160213.21243-1-brian@purestorage.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SCSI rescanning will skip updating inquiry data if a device
has already been created. This means that if a target changes the
inquiry data of a device whether or not a unit attention is posted
that will not ever be changed on a device.

This is a particular problem for handling the ALUA unavailable state
which requires setting the peripheral qualifier on a LUN. This
toggling of that value makes it impossible without this functionality
to properly handle that state.

Additionally this fixes the updating of inquiry data when a unit
attention of inquiry data has changed is returned from the target.

Acked-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi.c        | 121 ++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 246 +++++++++++++++++++++++++------------
 include/scsi/scsi_device.h |   2 +
 3 files changed, 293 insertions(+), 76 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9a0f467264b3..1dda0ab6e071 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -61,6 +61,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
@@ -544,6 +545,126 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 	kfree(vpd_buf);
 }
 
+/**
+ * scsi_update_inquiry_data - Update standard INQUIRY data for a SCSI device
+ * @sdev: The device to update
+ * @inq_result: Buffer containing new INQUIRY data
+ * @inq_len: Length of inquiry data
+ *
+ * Updates the standard INQUIRY data (vendor, model, rev, peripheral qualifier,
+ * device type, removable media flag) and capability flags derived from INQUIRY
+ * data for an existing SCSI device. This is used when reprobing a device to get
+ * fresh INQUIRY information. The old inquiry buffer is freed and replaced with
+ * the new data under the protection of inquiry_mutex.
+ *
+ * Blacklist flags (BLIST_ISROM, BLIST_NOT_LOCKABLE, BLIST_NOTQ) are respected
+ * when updating device properties.
+ *
+ * Returns:
+ *   0 on success
+ *   1 if device type or peripheral qualifier changed (caller should call device_reprobe())
+ *  -ENOMEM on allocation failure
+ */
+int scsi_update_inquiry_data(struct scsi_device *sdev,
+			      unsigned char *inq_result, size_t inq_len)
+{
+	unsigned char *new_inquiry;
+	unsigned char old_type;
+	unsigned char old_periph_qual;
+
+	/* Allocate new inquiry buffer */
+	new_inquiry = kmemdup(inq_result, max_t(size_t, inq_len, 36),
+			      GFP_KERNEL);
+	if (!new_inquiry)
+		return -ENOMEM;
+
+	/* Update inquiry data under mutex protection */
+	mutex_lock(&sdev->inquiry_mutex);
+
+	/* Save old values to detect changes that require reprobe */
+	old_type = sdev->type;
+	old_periph_qual = sdev->inq_periph_qual;
+
+	kfree(sdev->inquiry);
+	sdev->inquiry = new_inquiry;
+	sdev->vendor = (char *)(sdev->inquiry + 8);
+	sdev->model = (char *)(sdev->inquiry + 16);
+	sdev->rev = (char *)(sdev->inquiry + 32);
+	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
+
+	/*
+	 * Update device type and removable media flag from INQUIRY bytes 0-1.
+	 * This is the single source of truth for setting these fields from
+	 * INQUIRY data, used by both initial probe (scsi_add_lun) and reprobe
+	 * (scsi_rescan_device, scsi_probe_and_add_lun).
+	 */
+	if (!(sdev->sdev_bflags & BLIST_ISROM)) {
+		sdev->type = inq_result[0] & 0x1f;
+		sdev->removable = (inq_result[1] & 0x80) >> 7;
+
+		/*
+		 * some devices may respond with wrong type for
+		 * well-known logical units. Force well-known type
+		 * to enumerate them correctly.
+		 */
+		if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
+			sdev_printk(KERN_WARNING, sdev,
+				    "%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16xhN\n",
+				    __func__, sdev->type, (unsigned int)sdev->lun);
+			sdev->type = TYPE_WLUN;
+		}
+
+		/* lockable defaults to removable, unless blacklist overrides */
+		sdev->lockable = sdev->removable;
+		if (sdev->sdev_bflags & BLIST_NOT_LOCKABLE)
+			sdev->lockable = 0;
+	}
+
+	/* Update capability flags from INQUIRY byte 7 */
+	sdev->soft_reset = ((inq_result[7] & 1) && ((inq_result[3] & 7) == 2)) ? 1 : 0;
+
+	/* Update protocol support flags */
+	sdev->ppr = (sdev->scsi_level >= SCSI_3 ||
+		     (inq_len > 56 && inq_result[56] & 0x04)) ? 1 : 0;
+	sdev->wdtr = (inq_result[7] & 0x60) ? 1 : 0;
+	sdev->sdtr = (inq_result[7] & 0x10) ? 1 : 0;
+
+	/* Update tagged queuing support */
+	sdev->tagged_supported = ((sdev->scsi_level >= SCSI_2) &&
+				  (inq_result[7] & 2) &&
+				  !(sdev->sdev_bflags & BLIST_NOTQ)) ? 1 : 0;
+	sdev->simple_tags = sdev->tagged_supported;
+
+	mutex_unlock(&sdev->inquiry_mutex);
+
+	/*
+	 * If device type or peripheral qualifier changed, return a special
+	 * code to indicate that caller should trigger device_reprobe() to
+	 * re-match with appropriate upper-layer driver.
+	 *
+	 * - Type changes require different drivers (sd vs sr vs st, etc.)
+	 * - PQ changes affect scsi_bus_match() which only matches PQ == 0
+	 *
+	 * Note: We check this AFTER updating all fields and releasing the
+	 * mutex, so all INQUIRY-derived data is current regardless of whether
+	 * reprobe is needed.
+	 */
+	if (old_type != sdev->type || old_periph_qual != sdev->inq_periph_qual) {
+		if (old_type != sdev->type)
+			sdev_printk(KERN_NOTICE, sdev,
+				    "device type changed from %d to %d\n",
+				    old_type, sdev->type);
+		if (old_periph_qual != sdev->inq_periph_qual)
+			sdev_printk(KERN_NOTICE, sdev,
+				    "peripheral qualifier changed from %d to %d\n",
+				    old_periph_qual, sdev->inq_periph_qual);
+		return 1; /* Type or PQ changed - caller should reprobe */
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_update_inquiry_data);
+
 /**
  * scsi_report_opcode - Find out if a given command is supported
  * @sdev:	scsi device to query
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3c6e089e80c3..7f79b96ec992 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -898,19 +898,27 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * these strings are invalid, but often they contain plausible data
 	 * nonetheless.  It doesn't matter if the device sent < 36 bytes
 	 * total, since scsi_probe_lun() initializes inq_result with 0s.
+	 *
+	 * Set sdev_bflags before calling scsi_update_inquiry_data() so it
+	 * can use the correct blacklist flags (especially BLIST_ISROM).
 	 */
-	sdev->inquiry = kmemdup(inq_result,
-				max_t(size_t, sdev->inquiry_len, 36),
-				GFP_KERNEL);
-	if (sdev->inquiry == NULL)
-		return SCSI_SCAN_NO_RESPONSE;
+	sdev->sdev_bflags = *bflags;
 
-	sdev->vendor = (char *) (sdev->inquiry + 8);
-	sdev->model = (char *) (sdev->inquiry + 16);
-	sdev->rev = (char *) (sdev->inquiry + 32);
+	if (!sdev->inquiry) {
+		int ret = scsi_update_inquiry_data(sdev, inq_result,
+						   sdev->inquiry_len);
+		if (ret < 0) {
+			return SCSI_SCAN_NO_RESPONSE;
+		}
+		/* Type or PQ change during initial setup is unexpected but not fatal */
+		if (ret > 0) {
+			sdev_printk(KERN_NOTICE, sdev,
+				"device type or PQ changed during initial setup\n");
+		}
+	}
 
-	sdev->is_ata = strncmp(sdev->vendor, "ATA     ", 8) == 0;
-	if (sdev->is_ata) {
+	if (strncmp(sdev->vendor, "ATA     ", 8) == 0) {
+		sdev->is_ata = 1;
 		/*
 		 * sata emulation layer device.  This is a hack to work around
 		 * the SATL power management specifications which state that
@@ -920,26 +928,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		sdev->allow_restart = 1;
 	}
 
-	if (*bflags & BLIST_ISROM) {
-		sdev->type = TYPE_ROM;
-		sdev->removable = 1;
-	} else {
-		sdev->type = (inq_result[0] & 0x1f);
-		sdev->removable = (inq_result[1] & 0x80) >> 7;
-
-		/*
-		 * some devices may respond with wrong type for
-		 * well-known logical units. Force well-known type
-		 * to enumerate them correctly.
-		 */
-		if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
-			sdev_printk(KERN_WARNING, sdev,
-				"%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16xhN\n",
-				__func__, sdev->type, (unsigned int)sdev->lun);
-			sdev->type = TYPE_WLUN;
-		}
-
-	}
+	/*
+	 * scsi_update_inquiry_data() has already set type, removable, lockable,
+	 * inq_periph_qual, soft_reset, ppr, wdtr, sdtr, tagged_supported, and
+	 * simple_tags from INQUIRY data. Handle special cases that need the
+	 * raw inq_result or additional logic.
+	 */
 
 	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
 		/* RBC and MMC devices can return SCSI-3 compliance and yet
@@ -950,46 +944,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			*bflags |= BLIST_NOREPORTLUN;
 	}
 
-	/*
-	 * For a peripheral qualifier (PQ) value of 1 (001b), the SCSI
-	 * spec says: The device server is capable of supporting the
-	 * specified peripheral device type on this logical unit. However,
-	 * the physical device is not currently connected to this logical
-	 * unit.
-	 *
-	 * The above is vague, as it implies that we could treat 001 and
-	 * 011 the same. Stay compatible with previous code, and create a
-	 * scsi_device for a PQ of 1
-	 *
-	 * Don't set the device offline here; rather let the upper
-	 * level drivers eval the PQ to decide whether they should
-	 * attach. So remove ((inq_result[0] >> 5) & 7) == 1 check.
-	 */ 
-
-	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
-	sdev->lockable = sdev->removable;
-	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
-
-	if (sdev->scsi_level >= SCSI_3 ||
-			(sdev->inquiry_len > 56 && inq_result[56] & 0x04))
-		sdev->ppr = 1;
-	if (inq_result[7] & 0x60)
-		sdev->wdtr = 1;
-	if (inq_result[7] & 0x10)
-		sdev->sdtr = 1;
-
 	sdev_printk(KERN_NOTICE, sdev, "%s %.8s %.16s %.4s PQ: %d "
 			"ANSI: %d%s\n", scsi_device_type(sdev->type),
 			sdev->vendor, sdev->model, sdev->rev,
 			sdev->inq_periph_qual, inq_result[2] & 0x07,
 			(inq_result[3] & 0x0f) == 1 ? " CCS" : "");
 
-	if ((sdev->scsi_level >= SCSI_2) && (inq_result[7] & 2) &&
-	    !(*bflags & BLIST_NOTQ)) {
-		sdev->tagged_supported = 1;
-		sdev->simple_tags = 1;
-	}
-
 	/*
 	 * Some devices (Texel CD ROM drives) have handshaking problems
 	 * when used with the Seagate controllers. borken is initialized
@@ -1184,6 +1144,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	blist_flags_t bflags;
 	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	bool is_reprobe = false;
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1191,7 +1152,19 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
-		if (rescan != SCSI_SCAN_INITIAL || !scsi_device_created(sdev)) {
+		if (rescan == SCSI_SCAN_INITIAL && !scsi_device_created(sdev)) {
+			/*
+			 * During initial scan, if device is already fully initialized
+			 * (not in CREATED state), skip reprobing. This is an optimization
+			 * to avoid redundant probing during boot when the same LUN is
+			 * discovered multiple times (e.g., via REPORT_LUNS and then
+			 * sequential scan).
+			 *
+			 * Note: We don't check PQ here because sdev->inq_periph_qual
+			 * is the cached value. If the target changed PQ, we won't detect
+			 * it without sending INQUIRY. However, during initial boot scan,
+			 * we assume devices don't change state, so this optimization is safe.
+			 */
 			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: device exists on %s\n",
 				dev_name(&sdev->sdev_gendev)));
@@ -1206,11 +1179,24 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 								 sdev->model);
 			return SCSI_SCAN_LUN_PRESENT;
 		}
-		scsi_device_put(sdev);
-	} else
+		/*
+		 * For rescan operations or devices still being created,
+		 * always reprobe to detect peripheral qualifier or device type
+		 * changes:
+		 * - PQ 0 -> non-zero: detach upper layer drivers (scsi_bus_match fails)
+		 * - PQ non-zero -> 0: attach upper layer drivers (scsi_bus_match succeeds)
+		 * - Type change: re-match with correct driver (sd vs sr vs st, etc.)
+		 */
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+			"scsi scan: device exists (type %d, PQ %d), reprobing\n",
+			sdev->type, sdev->inq_periph_qual));
+		is_reprobe = true;
+		/* Continue with existing device - keep the reference */
+	} else {
 		sdev = scsi_alloc_sdev(starget, lun, hostdata);
-	if (!sdev)
-		goto out;
+		if (!sdev)
+			goto out;
+	}
 
 	result = kmalloc(result_len, GFP_KERNEL);
 	if (!result)
@@ -1219,6 +1205,54 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	if (scsi_probe_lun(sdev, result, result_len, &bflags))
 		goto out_free_result;
 
+	/*
+	 * For reprobe scenarios, update the inquiry data with fresh
+	 * INQUIRY results. The device already exists in sysfs, so we
+	 * don't call scsi_add_lun() which would try to add it again.
+	 */
+	if (is_reprobe) {
+		int update_ret = scsi_update_inquiry_data(sdev, result, result_len);
+		if (update_ret < 0) {
+			sdev_printk(KERN_WARNING, sdev,
+				"scsi scan: failed to update inquiry data\n");
+			res = SCSI_SCAN_NO_RESPONSE;
+			goto out_free_result;
+		}
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+			"scsi scan: updated inquiry data (type %d, PQ %d)\n",
+			sdev->type, sdev->inq_periph_qual));
+
+		/* Update VPD pages with fresh data */
+		if (sdev->scsi_level >= SCSI_3)
+			scsi_attach_vpd(sdev);
+
+		if (bflagsp)
+			*bflagsp = bflags;
+
+		/*
+		 * Trigger device reprobe if type or PQ changed.
+		 * scsi_update_inquiry_data() returns 1 when either changes.
+		 *
+		 * The scsi_bus_match() function only matches devices with
+		 * PQ == 0, so PQ changes cause driver attach/detach.
+		 *
+		 * Device type changes require reprobe to match the correct
+		 * upper-layer driver (e.g., sd for TYPE_DISK, sr for TYPE_ROM).
+		 */
+		if (update_ret > 0) {
+			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				"scsi scan: type or PQ changed, reprobing for drivers\n"));
+			res = device_reprobe(&sdev->sdev_gendev);
+			if (res < 0)
+				sdev_printk(KERN_WARNING, sdev,
+					"scsi scan: device reprobe failed: %d\n", res);
+		}
+
+		/* Device already exists, just return success */
+		res = SCSI_SCAN_LUN_PRESENT;
+		goto out_free_result;
+	}
+
 	if (bflagsp)
 		*bflagsp = bflags;
 	/*
@@ -1705,6 +1739,10 @@ EXPORT_SYMBOL(scsi_resume_device);
 int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	unsigned char *inq_result;
+	blist_flags_t bflags;
+	int result_len = 256;
+	int inquiry_ret = 0;
 	int ret = 0;
 
 	device_lock(dev);
@@ -1721,19 +1759,75 @@ int scsi_rescan_device(struct scsi_device *sdev)
 		goto unlock;
 	}
 
+	/*
+	 * Rescan standard INQUIRY data to detect changes in device
+	 * properties (vendor, model, rev, peripheral qualifier, device type, etc.)
+	 */
+	inq_result = kmalloc(result_len, GFP_KERNEL);
+	if (inq_result) {
+		if (scsi_probe_lun(sdev, inq_result, result_len,
+				   &bflags) == 0) {
+			/* Successfully got fresh INQUIRY data */
+			inquiry_ret = scsi_update_inquiry_data(sdev, inq_result,
+							       sdev->inquiry_len);
+			if (inquiry_ret < 0) {
+				sdev_printk(KERN_WARNING, sdev,
+					"scsi rescan: failed to update inquiry data\n");
+			} else {
+				SCSI_LOG_SCAN_BUS(3,
+					sdev_printk(KERN_INFO, sdev,
+					"scsi rescan: updated inquiry data, PQ %d\n",
+					sdev->inq_periph_qual));
+			}
+		}
+		kfree(inq_result);
+	}
+
 	scsi_attach_vpd(sdev);
 	scsi_cdl_check(sdev);
 
-	if (sdev->handler && sdev->handler->rescan)
-		sdev->handler->rescan(sdev);
+	/*
+	 * If peripheral qualifier or device type changed, reprobe to update
+	 * driver attachment. scsi_update_inquiry_data() returns 1 when either
+	 * changes.
+	 *
+	 * The scsi_bus_match() function only matches devices with PQ == 0,
+	 * so PQ changes cause driver attach/detach.
+	 *
+	 * Device type changes require reprobe to match the correct upper-layer
+	 * driver (e.g., sd for TYPE_DISK, sr for TYPE_ROM).
+	 */
+	if (inquiry_ret > 0) {
+		int reprobe_ret;
 
-	if (dev->driver && try_module_get(dev->driver->owner)) {
-		struct scsi_driver *drv = to_scsi_driver(dev->driver);
+		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+			"scsi rescan: type or PQ changed, reprobing\n"));
 
-		if (drv->rescan)
-			drv->rescan(dev);
-		module_put(dev->driver->owner);
+		device_unlock(dev);
+		reprobe_ret = device_reprobe(dev);
+		device_lock(dev);
+
+		if (reprobe_ret < 0) {
+			sdev_printk(KERN_WARNING, sdev,
+				"scsi rescan: device reprobe failed: %d\n", reprobe_ret);
+		}
+	} else if (inquiry_ret == 0) {
+		/*
+		 * PQ and type unchanged, just call driver's rescan
+		 * function to update device properties (capacity, etc.)
+		 */
+		if (sdev->handler && sdev->handler->rescan)
+			sdev->handler->rescan(sdev);
+
+		if (dev->driver && try_module_get(dev->driver->owner)) {
+			struct scsi_driver *drv = to_scsi_driver(dev->driver);
+
+			if (drv->rescan)
+				drv->rescan(dev);
+			module_put(dev->driver->owner);
+		}
 	}
+	/* If inquiry_ret < 0, INQUIRY failed - skip both reprobe and rescan */
 
 unlock:
 	device_unlock(dev);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 993008cdea65..831b16422f5c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -400,6 +400,8 @@ extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd(struct scsi_device *sdev);
 void scsi_cdl_check(struct scsi_device *sdev);
 int scsi_cdl_enable(struct scsi_device *sdev, bool enable);
+int scsi_update_inquiry_data(struct scsi_device *sdev,
+			      unsigned char *inq_result, size_t inq_len);
 
 extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern int __must_check scsi_device_get(struct scsi_device *);
-- 
2.51.0

