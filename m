Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAC81DDC1B
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 23:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781825732; cv=none; b=ZbvZXlKl0LtYOIBz5EwMBhs9AoTfWHKSB5KzvJ1bNzkwaLsf8dL4g2UKvC3dv52FOeTnrmwD1Pf9fx8OxMnmD7bLnKt7nHtBRw9a76v17g/Mc6DoN/zyk9hPLa8yfuVTNtXWwejBgWXLO4FBpmeyr+JI6khDGM92UYZzVvCbQio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781825732; c=relaxed/simple;
	bh=lmadJc7Gny2fKLcq9F8ulNCLTFpHj5AY6U2u/rgfhGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F3lMbe1m9986apERwPsYnpDYRtOAYyfx6UVDp6X/egxn8gSc6wZ0H//g7yLXNI/50MmKrg34dlHgayFc+WcO0bg7GL2StWX1QDLQIJECbKJ3HXKXFY9Ulo9xYHZbv8VRp9Raht6Ne8Ibh3q0He6LtmyeFDBfkiHD3pIXNK0z+V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Cb6fh6aK; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Cb6fh6aK"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4633193af19so1142558f8f.2
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 16:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781825729; x=1782430529; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=efzrMbkKYFJOTCs5LFAW/0eEbWCmJWMJ55kU/YCw/Kw=;
        b=Cb6fh6aKvftzpNSDze4VwDOGYpqfbX/WBYWYaTh3b5rHeKISPkueOO81DlGCRqqG+U
         fcIZXprCgHqaU5siqdeOnFDX/6Lw7d+AZljhlLWJtQD42Pl6mpvZINrDPlZtFmY1slOM
         tVA34z9Bn7eQ1LI0Nawr+xWiPH8rYOH7dXPhvZpYf8+RlKB2Huvh9DX/Cxar+7byRZJO
         EaQftChyXGIwtszseiO8o0FjVOzVDHxOsEjaotXPRgSVRNjYJUOBiuZInJt4ijZUkQas
         smHpwt3XWDUyRMShtlIwqWHSubi4QAKOuhLo1UXFj2//g1iZ+VoxqQ6WVmt5pXFf8atG
         MhNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781825729; x=1782430529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=efzrMbkKYFJOTCs5LFAW/0eEbWCmJWMJ55kU/YCw/Kw=;
        b=OdlcMWf22TY4peEH3omaGwFvRTmyYQBegHONOT9gpSfTL8RquuvsWrQLg3AOOzd+r6
         +tGH+iue8/5W1AE6jLbXAaOTtqwZlFOdnoenaAXdYMcMU5k4WpRiwAW2e1RzhCE7pj4R
         6oSk9y4T9182RSJicTkdQnwzbH0fqsDx6o2i3JCaXAL0ZJhoo03WtB32jyNYG9dHoe+d
         vP1QqtKm+r5aYgmVCY/PPeEvoP7iANMUFBXg6LfUvccqYUNyrprjIzgm0oKgnp+F2e8l
         gmL786sGmmS1OdH8WGAxIcpagjeWOy7OQiL4yWD7Nuwex6vTuD7X7iinKxaat/xrmx/A
         D/CA==
X-Gm-Message-State: AOJu0Yx5Esecqqt4TVhA3++wql3nigxfwrSlYnaphd85ycYCdXILgIk2
	9mOIju8yF57/VJBUUg4YlQxRImW7y861/h4iQTJdg/eohpWP8+wnxepWtb88IMQ+MZkHg67bzz6
	pybSAnEoaVNJnFmUbu8t1/eRwkVe86VRCSHk7f0vLCbl1vDkYIDdbKYrnOVSfrjhiQfp6E2YAKZ
	724zlNlqdmhrQVxd9yZpE5B+WuUU58sRke6zcl8uO1A29swL3ILg==
X-Gm-Gg: AfdE7clrG53LyaojSleFjf2xZsRZENm62jXJxksW7+pd0cBZ9sKqC4NiEip4FA0MiMR
	phyTZqaHn7KxwN9bgsDOc0sKCJXD9LcFEuT7NwSCzgBkt0UskQa3jonQ9lEqozSe/ElhluZdnkj
	b8MRGIn0twmVy9gb7vvwkQb5puYGt+cBUOeWw+wGr14IF8MsxwBEJPCVVWxOzSx6dWZGMMt2u5p
	aDPkc26wEbtNGVSLEitFfnJ4NJMG/RhZ6rKwU1PsBT+C5uTdT05ttZnNOVDazUA7KJlTRbogOmz
	fwop797p8AH1UUI2jxduohxHMF4NP3/bFIPVMVYInDLfPmYXl2dOfC5MtOkNNDM8GXwSAClEBM/
	mJnYZL0IjE9HqQuTA/tZQbQ1tYlPAG+XpYGFWxjBAJpMuucvKA7ERxXbnbuwJekycVybUfPWK8L
	idKPGpfLXa4Yn2+DuYxSfTcqlTK9uQvp4xfHy4nZh51lrnUfFWNtCFphYOBFevnSZ466uqIrVoZ
	b7dD7fPSPDEse9UHTTAkTho1azYNjSmm8sBn8HgwWfXsjIc53DTmX+YyZxKh22bJPBzJqk0Ecd+
	ijgW8OIL9043
X-Received: by 2002:a05:6000:1ace:b0:460:71e6:e3b with SMTP id ffacd0b85a97d-46501686057mr2724988f8f.27.1781825728622;
        Thu, 18 Jun 2026 16:35:28 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650b67a34asm3492468f8f.22.2026.06.18.16.35.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 16:35:27 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	hare@suse.de,
	bvanassche@acm.org,
	krishna.kant@purestorage.com
Subject: [PATCH v5 2/5] scsi: core: Add scsi_update_inquiry_data() for updating INQUIRY data
Date: Thu, 18 Jun 2026 16:35:01 -0700
Message-ID: <20260618233508.97960-3-brian@purestorage.com>
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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/scsi.c        | 178 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  13 +++
 2 files changed, 191 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7b..ce1901ea7afc 100644
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
@@ -549,6 +550,183 @@ void scsi_attach_vpd(struct scsi_device *sdev)
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
+ *   SCSI_INQ_REPROBE_NEEDED if standard INQUIRY data changed (caller should reprobe)
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
+	 * Save peripheral qualifier and device type before updating all
+	 * INQUIRY-derived fields. These are the only two values that
+	 * determine whether device_reprobe() is needed: type controls which
+	 * upper-layer driver (sd, st, sr, ...) is bound, and PQ controls
+	 * whether the LUN is accessible at all (scsi_bus_match() only matches
+	 * PQ == 0). Every other field — vendor, model, revision, capability
+	 * flags — is refreshed in place without any driver re-matching.
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
+	if (had_prior_inquiry) {
+		if (old_type != sdev->type) {
+			sdev_printk(KERN_NOTICE, sdev,
+				    "device type changed from %d to %d\n",
+				    old_type, sdev->type);
+			return SCSI_INQ_REPROBE_NEEDED;
+		}
+		if (old_periph_qual != sdev->inq_periph_qual) {
+			sdev_printk(KERN_NOTICE, sdev,
+				    "peripheral qualifier changed from %d to %d\n",
+				    old_periph_qual, sdev->inq_periph_qual);
+			return SCSI_INQ_REPROBE_NEEDED;
+		}
+	}
+
+	return SCSI_INQ_UNCHANGED;
+}
+
 /**
  * scsi_report_opcode - Find out if a given command is supported
  * @sdev:	scsi device to query
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 029f5115b2ea..7c8c06e60a91 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -408,6 +408,19 @@ void scsi_attach_vpd(struct scsi_device *sdev);
 void scsi_cdl_check(struct scsi_device *sdev);
 int scsi_cdl_enable(struct scsi_device *sdev, bool enable);
 
+/**
+ * enum scsi_inq_update_result - Return values for scsi_update_inquiry_data()
+ * @SCSI_INQ_UNCHANGED: INQUIRY data updated, no reprobe needed
+ * @SCSI_INQ_REPROBE_NEEDED: INQUIRY data updated, standard INQUIRY data changed
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

