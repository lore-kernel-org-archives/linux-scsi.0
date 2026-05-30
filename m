Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09C92E7384
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 00:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780100446; cv=none; b=fXOlWqIPJ8h8z7NDRhVROiXkmU7qYiyRgIvGFKaRCuvufT4pMw2LbaJVUkrOD5mEegmKGSAXyWK9UyppZcBVtbFKx+SdA4Wt7qONnXzrWPCP099RvhUr7NWx6IAAxsrMPemqszYr6GZroVimbuCMRXZ8O4US97twMitjkr48ktE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780100446; c=relaxed/simple;
	bh=zIe1zDilvZik7Ps903Ujhj9Bg3+h/nuHfb03Mlq3TpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJNTdpNzf8HBne0RnhfwbYq5JrXRr5GXblDxSui2Sci9z8cexBiDL6HutUnKN26lW4xkWS7aB5kBtIWhydeBpdAFOeOdq1LbGDNddheXrgpclawWvJ2BfVppJR7r1ZLPKryzkzbOgxokMS70ClflNcsHv9c1a/61DNYTE+t/agg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PhWFk09S; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PhWFk09S"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-137335bc3caso6122881c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 17:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1780100444; x=1780705244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TzlRtgOJ8/yetKCmXCr0ce79KdAmttNP9hiejyV2qpE=;
        b=PhWFk09SuB/pNKYIbEHQzGf6RMTymd6XroR+fwFQjP+OCl3yvxKbIPceJVduGp5Oev
         yDvAJmUPzbgms2NsAb/MaKEayiLhHzrvlzMMSx2CpIzsA27QuFadJ04W0XwNgnJnAHTX
         2FzNGPf6P99a64MLbA+6tvTanCtV6fwJBhwfKukxHLfbfI8LSMp5k1UAq4euHcPNZnNG
         3eKZ9luxybha+SQKXg4YYdRZDk6kGJ0QIfGk2ioXtKiXCwLVEXJy+2xs5s3kxcit4eKi
         idWAMnMAKC3g+ugGsjp4ANC8FSOnMT+673Rn9bu388ZmwumcKO0A/WZ3oZY251E3vcNB
         qrpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780100444; x=1780705244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TzlRtgOJ8/yetKCmXCr0ce79KdAmttNP9hiejyV2qpE=;
        b=NLqw4et+3h5T5Zh8IxjCLo9/rHW3+BfWkw5AGaQzTtZPgHTS6mFufJbQeYa2JDqym9
         kfsb0yvjfX7M1qesOm8X/XX3DBfBNUUK2x/Sn/XI8TM/EXpVu/4ei7bc8vWpD67an9kp
         TK/FMmOWlitvpqVd5rbaoy37ibpkfzkn6qRP2d1zk5ZBARWa6rC95axA4LfULwVcAXW7
         fgsPIQ8ebiC3ooesLhc/soCDx+O/OhNcbB9+VDs7ywClXHg0R34ZVRBpsG/ef+ec4WmN
         EpJkbarRRd3XJgW3wZ7mY0G2nfRZY9z9SscQv+7ckVn8QhpvlSmwSGO+9BuNOge8sufq
         I9xg==
X-Gm-Message-State: AOJu0Yw116jGUoCh4whqKnKebitYGRFKHK32Twe1oxLTQoUfzWfAMlB2
	aukKOsazHoVPNfuDt6FODYHHdDuY0plcHhk/KqoV+jNf21aDY+59z0ihZmuBzAfEtPzVZxeNbAQ
	7y7WQN7T9jCHTg8nc13Tx5cTq/XXO1G1pA/+LFYnTkMnBYT37AxF5yuVAZOXJvY73E61Iz1Djsx
	FA2b0pgc6DjYPYzu7rXEkyJ0LIVStwUW8lAY62U2GZ7MuOcP8v6w==
X-Gm-Gg: Acq92OFIAilE5afctWindF34NxQiTQVaTQ3Ml6lNUvXMseWOdI5fR+jw/HFbPePxgMA
	vkKw9HKfqKVEW9MISUnOKS9ZdlkkDHb/bOpW7q/ynov1somGXhMZbWuAdMwkHBiOnlXzBJkrOHy
	8/uk/19ygGYmW6cwZwxdNOSzRxYMoJjhgC1gcwu44DiLlUSiNtXxX9NDcbiTl2mlF072KMmKYY1
	Onphoe2swzk7rpSAKPk8iN9QAcOT5O1UHSTKDTuz+iuDwZZLaPzZTPqZWBwQkrwtMZape/gzOwZ
	Wj9qjc1krJ4A9YNYIJYb23+PBlA88V6duPrZi6eoR69TJQRfrG5qBSA0Cvh+mjra3gSBuC5hheO
	bYelOCaIWvX+/csP9ILGftqbPQaTkSCxcWe/DJKajacVggwGVO0EBHGVnXo7doZrNcXKAmoEqdl
	eJo2QGJu8WEN5QuWnw99vfZjH1CdcxJn3z1YHV2/TG22lEf9aaj9QToLsxE14iTBQ93gbkV9xuW
	2LRtwedFI4/zO2+vs6EXXkan/xe/Tbhw6iqFH7ENoWSvl6q5Gx//veRYW2q9VSzC3Afk2yEv0gs
	LuVvteXmbRuaMtVwIwF5A5xbspiMKVe4kHM=
X-Received: by 2002:a05:7022:6ba7:b0:133:3bb1:8d40 with SMTP id a92af1059eb24-137d4027a42mr918693c88.15.1780100443567;
        Fri, 29 May 2026 17:20:43 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.115])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b3d8f839sm2027163c88.15.2026.05.29.17.20.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 17:20:43 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	hare@suse.de,
	Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v4 2/5] scsi: core: Add scsi_update_inquiry_data() for updating INQUIRY data
Date: Fri, 29 May 2026 17:20:16 -0700
Message-ID: <20260530002019.47109-3-brian@purestorage.com>
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

Add a new function scsi_update_inquiry_data() that can safely update all
INQUIRY-derived fields for an existing SCSI device:

- Vendor, model, revision strings
- Peripheral qualifier and device type
- Capability flags (removable, lockable, tagged queuing support, etc.)
- ATA device detection and allow_restart setting

The function:
- Takes the inquiry_mutex to protect against concurrent sysfs reads
- Respects BLIST_ISROM and BLIST_NOTQ blacklist flags
- Returns 1 if device type or peripheral qualifier changed, indicating
  the caller should call device_reprobe() to re-match drivers
- Returns 0 on success with no changes requiring reprobe
- Returns negative errno on failure

This is the core infrastructure needed for updating INQUIRY data during
device rescan operations, which is required for proper ALUA unavailable
state handling.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi.c        | 191 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  13 +++
 2 files changed, 204 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7b..94b07225b56e 100644
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
@@ -549,6 +550,196 @@ void scsi_attach_vpd(struct scsi_device *sdev)
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
+ * data for a SCSI device. This is used during both initial device setup and
+ * when reprobing a device to get fresh INQUIRY information. The old inquiry
+ * buffer is freed and replaced with the new data under the protection of
+ * inquiry_mutex.
+ *
+ * Blacklist flags (BLIST_ISROM, BLIST_NOTQ) are respected when updating
+ * device properties.
+ *
+ * Returns:
+ *   SCSI_INQ_UNCHANGED on success
+ *   SCSI_INQ_REPROBE_NEEDED if type or PQ changed (caller should reprobe)
+ *  -ENOMEM on allocation failure
+ *  -EINVAL if inquiry data is too short
+ */
+int scsi_update_inquiry_data(struct scsi_device *sdev,
+			     unsigned char *inq_result, size_t inq_len)
+{
+	unsigned char *new_inquiry;
+	unsigned char old_type;
+	unsigned char old_periph_qual;
+	bool had_prior_inquiry;
+	bool reprobe;
+
+	/*
+	 * Ensure we have at least the minimum standard INQUIRY data (36 bytes)
+	 * to safely access device type, vendor, model, rev, and capability flags.
+	 */
+	if (inq_len < 36) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "INQUIRY data too short (%zu bytes), need at least 36\n",
+			    inq_len);
+		return -EINVAL;
+	}
+
+	/* Allocate new inquiry buffer */
+	new_inquiry = kmemdup(inq_result, inq_len, GFP_KERNEL);
+	if (!new_inquiry)
+		return -ENOMEM;
+
+	/* Update inquiry data under mutex protection */
+	mutex_lock(&sdev->inquiry_mutex);
+
+	/*
+	 * Save old values to detect changes that require reprobe.
+	 * Only meaningful if we had prior inquiry data; during initial
+	 * setup sdev->inquiry is NULL and the old values are just
+	 * zero-initialized defaults.
+	 */
+	had_prior_inquiry = (sdev->inquiry != NULL);
+	old_type = sdev->type;
+	old_periph_qual = sdev->inq_periph_qual;
+
+	kfree(sdev->inquiry);
+	sdev->inquiry = new_inquiry;
+	sdev->inquiry_len = inq_len;
+	strscpy(sdev->vendor, sdev->inquiry + INQUIRY_VENDOR_OFFSET);
+	strscpy(sdev->model, sdev->inquiry + INQUIRY_MODEL_OFFSET);
+	/*
+	 * memcpy() instead of strscpy() because strscpy() would read past
+	 * the end of sdev->inquiry if its length is exactly 36 bytes.
+	 */
+	memcpy(sdev->rev, sdev->inquiry + INQUIRY_REVISION_OFFSET,
+	       INQUIRY_REVISION_LEN);
+	sdev->rev[INQUIRY_REVISION_LEN] = '\0';
+	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
+
+	/*
+	 * Compute scsi_level from INQUIRY bytes 2 and 3. This must be
+	 * updated under inquiry_mutex alongside the other INQUIRY-derived
+	 * fields so sysfs readers always see a consistent snapshot.
+	 */
+	sdev->scsi_level = inq_result[2] & 0x0f;
+	if (sdev->scsi_level >= 2 ||
+	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
+		sdev->scsi_level++;
+
+	/*
+	 * Check if this is an ATA device (SATA emulation layer).
+	 * ATA devices need allow_restart set to work around SATL power
+	 * management specifications.
+	 */
+	if (strncmp(sdev->vendor, "ATA     ", 8) == 0) {
+		sdev->is_ata = 1;
+		sdev->allow_restart = 1;
+	} else
+		sdev->is_ata = 0;
+
+	/*
+	 * Update device type from INQUIRY byte 0.
+	 * BLIST_ISROM is a quirk for devices that report wrong type but should
+	 * be treated as (removable) CD-ROM. Override to TYPE_ROM as exception.
+	 */
+	if (sdev->sdev_bflags & BLIST_ISROM) {
+		sdev->type = TYPE_ROM;
+		sdev->removable = 1;
+	} else {
+		sdev->type = inq_result[0] & 0x1f;
+		sdev->removable = (inq_result[1] & 0x80) >> 7;
+
+		/*
+		 * Some devices may respond with wrong type for well-known
+		 * logical units. Force well-known type to enumerate them
+		 * correctly.
+		 */
+		if (scsi_is_wlun(sdev->lun) && sdev->type != TYPE_WLUN) {
+			sdev_printk(KERN_WARNING, sdev,
+				"%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16xhN\n",
+				__func__, sdev->type,
+				(unsigned int)sdev->lun);
+			sdev->type = TYPE_WLUN;
+		}
+	}
+
+	/*
+	 * Set lockable to match removable. Devices with removable media
+	 * can typically have their media locked/unlocked via the
+	 * ALLOW_MEDIUM_REMOVAL command.
+	 */
+	sdev->lockable = sdev->removable;
+
+	/* Update capability flags from INQUIRY byte 7 */
+	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
+
+	/*
+	 * Update protocol support flags.
+	 * Only update ppr if we have enough INQUIRY data (>56 bytes) to check
+	 * byte 56, or if scsi_level indicates SCSI-3+ support. If we don't have
+	 * enough data, leave ppr unchanged to avoid incorrectly clearing it
+	 * during rescan with short INQUIRY.
+	 */
+	if (sdev->scsi_level >= SCSI_3 || inq_len > 56)
+		sdev->ppr = (sdev->scsi_level >= SCSI_3 ||
+			     (inq_len > 56 && inq_result[56] & 0x04)) ? 1 : 0;
+	sdev->wdtr = !!(inq_result[7] & 0x60);
+	sdev->sdtr = !!(inq_result[7] & 0x10);
+
+	/*
+	 * Update tagged queuing support from INQUIRY byte 7.
+	 * BLIST_NOTQ is an exception to force tagged queuing off.
+	 */
+	if (sdev->sdev_bflags & BLIST_NOTQ)
+		sdev->tagged_supported = 0;
+	else
+		sdev->tagged_supported = (sdev->scsi_level >= SCSI_2) &&
+					  (inq_result[7] & 2);
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
+	reprobe = false;
+	if (had_prior_inquiry) {
+		if (old_type != sdev->type) {
+			sdev_printk(KERN_NOTICE, sdev,
+				    "device type changed from %d to %d\n",
+				    old_type, sdev->type);
+			reprobe = true;
+		}
+		if (old_periph_qual != sdev->inq_periph_qual) {
+			sdev_printk(KERN_NOTICE, sdev,
+				    "peripheral qualifier changed from %d to %d\n",
+				    old_periph_qual, sdev->inq_periph_qual);
+			reprobe = true;
+		}
+		if (reprobe)
+			return SCSI_INQ_REPROBE_NEEDED;
+	}
+
+	return SCSI_INQ_UNCHANGED;
+}
+
 /**
  * scsi_report_opcode - Find out if a given command is supported
  * @sdev:	scsi device to query
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 029f5115b2ea..3ef44eb4479b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -408,6 +408,19 @@ void scsi_attach_vpd(struct scsi_device *sdev);
 void scsi_cdl_check(struct scsi_device *sdev);
 int scsi_cdl_enable(struct scsi_device *sdev, bool enable);
 
+/**
+ * enum scsi_inq_update_result - Return values for scsi_update_inquiry_data()
+ * @SCSI_INQ_UNCHANGED: INQUIRY data updated, no reprobe needed
+ * @SCSI_INQ_REPROBE_NEEDED: INQUIRY data updated, device type or PQ changed
+ */
+enum scsi_inq_update_result {
+	SCSI_INQ_UNCHANGED = 0,
+	SCSI_INQ_REPROBE_NEEDED = 1,
+};
+
+int scsi_update_inquiry_data(struct scsi_device *sdev,
+			     unsigned char *inq_result, size_t inq_len);
+
 extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
 extern int __must_check scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
-- 
2.54.0

