Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD7B4E06E8
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 21:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839157; cv=none; b=TnKWK3GURSCnk8olOA2r1wkG4zvJIOompYLNmBi/krfQumoEkxN6RkDKK7DfvadZ8OMRCFBj1AUWNp8dUOXUKJkgthk1Kg461Ftati4cTc684u/GRREJKwgnGZlUPKUSzFZQ7gz9OXtmzAhPItzEbt+qm7NC/gu0tuS4+qCEzoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839157; c=relaxed/simple;
	bh=3menAf83Xy9yB4634/VwNKDm8l1Mra2v4pTn8L9SGng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J9jdF3JzZ3QwGskDxsz9bbkheVjTA4ohkoOZSYhDRr9zjOuSN6hBpezVN0MJHjxMm9XACXheIfdajRIGeabcjB4+sk1vSS4xmeapDgY9xiwxh8c5StrVvEr/IJ0Y555/WMnI0rD1/FgjJAIN7ElXlEBGq/+ikIvTyCY9epHXWvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fIhs7lRZ; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fIhs7lRZ"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-35a31bb9fb6so535859eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 14:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1791839155; x=1792443955; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PR2QPbqoWyEeC9UJ6BFlLpXQ08m6Clq4+rHFKHQ1Lqs=;
        b=fIhs7lRZOyVrxWuUoHTJQ6VLh6kKDAeToF/v+HeJ2KyEoQ5gU+yADud5bmti7PP0Dh
         GZEHti77t7wM35Oui9MBEMItSqamrFICo6uCzSMlHNr/q251P6xM7TvTAaEYRwd0DsIj
         IWynM7lllKkiGixZkHmsgpouoUSMsEdxkeFaCBDEyv3gKs1dOxtZE0ANkvfGx1pR8G0a
         ZK+HPgZuOECIJ+gA+WiTbsYL6IcdTu/PHJQCM2sK/SzUQreMVNR8K5KrD53N3AbRookJ
         a5JMAO+6L7nqYyTG5l1gy1A4pbcVvy/w8ETV2wBnFb0jOdA4mIsVXmr4Nr8BI0zhwonN
         vIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791839155; x=1792443955;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PR2QPbqoWyEeC9UJ6BFlLpXQ08m6Clq4+rHFKHQ1Lqs=;
        b=p29eVPUYJs4LdW6+wSBKTib744eAC6ZegFI0yZlE+kxA9Pv11sh2ZiURC7mcughou8
         HlA8LPDE/sy2adBXQaGFmxPJ2ees5ZwCb0kwoSgWCwAbmfkUaM2MYUvFweQbOYJt2D7C
         UoOQ5bhGcryBlHNftfDbrMr8l/7CAo2gIMxAYK2QSuzOeWhoMkQf3VZO6hydRga9J/cl
         H2x59YaqZV60TFP/EpD7nnmVIDTHhRK2sla8VYU9yqu1i49al+QoL/25ztJhLISjzRZu
         +WFFyX3fbghIWFQu3I+WcG6AO0b+dkPKJQqoskx0eWS9ncb+NOG+LNOX6T2E2T57k1Cx
         az6Q==
X-Gm-Message-State: AFq9FYKZI1T/xntIP3VCF9mh6GGJS5pG9KzOOvgZA3s4nEBl1loi9ora
	Y0GGkqRWTYwOEVD11iZXoqtps9dl787ntD3VEFf0j5DCNnbOtIsWKojX6ZvckpGtKfa//E/w846
	Xf2o0QxAaFi6GHBUxZJY1UjS93SnzLZJHw+hpi/YA6QIpIiP2SQFvRl7UifcHYf5u0fObxCe9h5
	M1ApnKRidijSiI0Xj//gHIPsmSC3bg/UQZCdzosZjIz6nLdq5UqQ==
X-Gm-Gg: AYBFou0zrz7KiXNVpqw+U/mZ7R5gs3mZyD0bmYC3NIvXrIwkk6ca5TY2oZC3u+GdBxR
	Sa159r2n0DaDoCbxkuZW/aws/uZ6nxe3aNMeeiyMWiZgzf3laG8AL126m2R+lq1OmYl8zFxMknd
	lkFERWVwIVrqz+EbekmNyOdwG8nHjrEkYvxuEKqX0Nz7zEfG/p4nTaTOAtTh0ESaTx46afsed8a
	2K48jfIUhf587SbJo0J80gK+NbqJ9ROvutfVcDPF8cN6j2oIQv1FvJPOyQqnWj21Lq+dUZKu62R
	+UMbARss25Jjpqnp2tuELxH752PoTNdWtLPT+9Mjd7eCKhDD5/ypAiSvBuQL8NWYFEdL0NGIhiB
	eSZHXTQ2z65S8RDARzWIpfMmnERnPqCqzyZQRenuedxiXw28JG5YuDXCiXVRVpTp7fpSNFvvs4j
	UZXqgHOlcLbEWjECUuV4+8RtKfieMyLgYf2O6OB8yUhNzyAisD8QTs5bZb94HiP4TonIwFY42+x
	3JuIX6bxKP//cWgxJEIEHUUJsQx5D7xCR1thkqzmEGW3K5fdFcPmkv5T4Lg9+zgf4lLAeYyF5LI
	y9beJMfzLx1AOZW1vK632BctdbKBhsjmvUGg6ji/xPVZ0+7ukrc/0zVhC6sCCbt3/2RTwho=
X-Received: by 2002:a05:7300:ce94:b0:351:6b27:d67d with SMTP id 5a478bee46e88-3537e04925fmr15124912eec.30.1791839154418;
        Mon, 12 Oct 2026 14:05:54 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.201.68])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb2fd33sm35528777eec.28.2026.10.12.14.05.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 14:05:54 -0700 (PDT)
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
Subject: [PATCH v6 2/5] scsi: core: Add scsi_update_inquiry_data() for updating INQUIRY data
Date: Mon, 12 Oct 2026 14:05:03 -0700
Message-ID: <20261012210511.16061-3-brian@purestorage.com>
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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi.c        | 178 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  13 +++
 2 files changed, 191 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3af9e77847f7..b80378ecf485 100644
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
index e6fd6bc30644..743babf1602c 100644
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
 extern int __must_check scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
-- 
2.55.0

