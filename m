Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C3D285C80
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 23:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764803991; cv=none; b=doGu011lAcguNNtIkRCdAlpyG7IMjuppyrNh9xYBXULWsTznPPrdUPns099caAxj6+28NdLEUNQMgixNB9E+e6W0u+XhJ619x4066KsadSPs+I8NdjLYGqUJwIKdfZrH42bwYBFcjGxHBaBsyKBF1OOAyMouQBHwxMiqAjKp5dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764803991; c=relaxed/simple;
	bh=MiUFln1njU/KMJgQ8jJ9SHzqLV9+djeJyijZ/C+/GiE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gT3bK3QFLGhb8m8BKNyE2SzVVHkg6f9ewKbzG8vi7y36njdv5oUbfQfg4s6msh7ko02WzIPMvVo6SvjJSSV/L1Zb1pQV/+buENjRL4mzx15lpDqRojru/QEbLfs6SGdCwdbjEnmcf+5uj4tRduaDOghe/YAWh+Y1xGLsOI/Y8xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KkTu7Hcb; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KkTu7Hcb"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so228465b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2025 15:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764803988; x=1765408788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oZwPNbmMLIdSclvetPopPH6pQCDjwKEzJyQ5lCRoUr4=;
        b=KkTu7HcbNPk0sZoPLjB/5M2I0hpeZiS7ONbAbIftBVkRkZe8OxgJhh1XHQ5K8DlcgU
         6glfBT2qheXymmBN9GwM1wCN5omq+FQHX5vHQIUoOORhcJcmvGzLmNf7k2lS2Sla+n8u
         n3Oe9yb9R4Crf2jkdYsKjQJAfw9n7pS72b20D+1J1R2c/I5uIzXlBThWeqbnMaNXo8S4
         qN7g+XBdm8TEc9yK7kPaeCn9684MgDWAK8gdNo/GeQ8wc2FWNsLAesTkx7i0ykdK2mXK
         6qJ6woQcsonNLX+9fCiGQxKg/0Mnx802SlPVzq23REneVvXaMd4T5d+IdToT1BQKNLQn
         eKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764803988; x=1765408788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZwPNbmMLIdSclvetPopPH6pQCDjwKEzJyQ5lCRoUr4=;
        b=P9d3HzbM+PAFkeYOCOIGRP5owcSOhHjo4NroeM6brclPszfjEajd1pDxNU3em8a7+C
         nQXcpDd2MQCLERWTiqDEJni0o+9sGg7BsGrJI0BqNVQ4tcM6swaxpF1vwGo4OgdYfF7z
         T8MHVhL9zNAHeD6XHlqB3FRAcOtf3zFFGa03LSjS0fVGHfcTy7SVonHifG42E4VthzKH
         Re3ZgI8Aly0G8qvorOG3RBoBE5RHIEKZKMYpIDRFn/Taj3pb+4y27LNqWnuvlb5AqUCx
         +jY/WkeoGbdivTMF1nd7Xz9dLpSkokYZzM47E09YsU9acjQvOnLTt1FN6bkjWVYWjq6Y
         b6wA==
X-Gm-Message-State: AOJu0Yw7AaJPi703H4kAg/qGwwmtfcsZv/CpSeTpiRAGVHU+FCH3qKCR
	WP7Nq9V4VFQJ+uaOdli5v2c9AjJ0OZ+orAKZk1PnaLQdZcmNRBk756BqGXLInhsDm0LdO7fJUQn
	AI/1yPoJ824Lx1ccCySoP3eROndgGkzuCYj4p2mBTezJi5mNg3Zmr9JGfsKDM7PYYIPJxB5nhQc
	vV2KfzecgsdS+M0BuBApEchXWS9ClkVtxswjhlNookK3RRfeg3YA==
X-Gm-Gg: ASbGncvegwH2Ydrb1F4UxhzOPp2xz20Lcz6lTa/KzuhrWq+OkRajwgkPNQN2x4C23Mm
	NC4rKgvlzGtXExY3AteyC2GXDMtJ9FJRpvG5hlYq7W91A1dIHpyVs/WmBqvlH/P+h71siT8tUpQ
	2k7jrhL24Bfa9On+Yp3EVbKAZyzyjhzpDpZMjLqOAkusDj/jJzUUdHAyUHOe0rJ9T04HVACLTze
	XWRQBkbfDUtCkFbg7nqKU+Z30OEslWOPE7dghLgODvd9VIMOaW9BmN+I2g/c/KH91224QVvUsvJ
	vb5XDQlm9lJNF6yR5eLq1hRTv2LmZC+ILf7s/TbswI6Ax02smcCUvnWSUMJhCXkwsLhk2WVWnWw
	JeC7aXhlCVEhWyg6inofpgW+FjTOlBH9GNDJTpaWngZceyTsYTwfhz9cHnqirlbdp5AZEshrAiw
	oJMNzCBHMDGW8kRAL6Rw46HGjEqK28n1XUydZr1R7UV5NCoy03rn+P+78IkD4MAvVGhpnjBYaTW
	dULi1LpD8I2eMY+6Epe0gtSnuG36uupuVgzJjszU2z6
X-Google-Smtp-Source: AGHT+IGABEniObf3XawdVQiI5BAFb5MNKLf7FI6TLd/8otqm+9KXNpC0EatsKuyteNxQUKX6IKk8HA==
X-Received: by 2002:a05:7022:2643:b0:11b:36f8:c9f1 with SMTP id a92af1059eb24-11df64a44a8mr475841c88.36.1764803987287;
        Wed, 03 Dec 2025 15:19:47 -0800 (PST)
Received: from brian--MacBookPro18.purestorage.com ([165.225.243.25])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df7552defsm131905c88.2.2025.12.03.15.19.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 03 Dec 2025 15:19:46 -0800 (PST)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org,
	hare@suse.de
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v3] scsi: core: add re-probe logic into SCSI rescan
Date: Wed,  3 Dec 2025 15:19:42 -0800
Message-ID: <20251203231943.18359-1-brian@purestorage.com>
X-Mailer: git-send-email 2.51.2
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
 drivers/scsi/scsi.c        | 159 +++++++++++++++++++++++
 drivers/scsi/scsi_scan.c   | 253 +++++++++++++++++++++++++------------
 drivers/scsi/scsi_sysfs.c  |  70 +++++++++-
 include/scsi/scsi.h        | 171 +++++++++++++++++++++++++
 include/scsi/scsi_device.h |   2 +
 5 files changed, 566 insertions(+), 89 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9a0f467264b3..60ffe26039eb 100644
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
@@ -544,6 +545,164 @@ void scsi_attach_vpd(struct scsi_device *sdev)
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
+ *   0 on success
+ *   1 if device type or peripheral qualifier changed (caller should call device_reprobe())
+ *  -ENOMEM on allocation failure
+ *  -EINVAL if inquiry data is too short
+ */
+int scsi_update_inquiry_data(struct scsi_device *sdev,
+			      unsigned char *inq_result, size_t inq_len)
+{
+	unsigned char *new_inquiry;
+	unsigned char old_type;
+	unsigned char old_periph_qual;
+
+	/*
+	 * Ensure we have at least the minimum standard INQUIRY data (36 bytes)
+	 * to safely access device type, vendor, model, rev, and capability flags.
+	 */
+	if (inq_len < SCSI_INQ_STD_LEN) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "INQUIRY data too short (%zu bytes), need at least %d\n",
+			    inq_len, SCSI_INQ_STD_LEN);
+		return -EINVAL;
+	}
+
+	/* Allocate new inquiry buffer */
+	new_inquiry = kmemdup(inq_result, max_t(size_t, inq_len, SCSI_INQ_STD_LEN),
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
+	sdev->vendor = scsi_inq_vendor(sdev->inquiry);
+	sdev->model = scsi_inq_product(sdev->inquiry);
+	sdev->rev = scsi_inq_revision(sdev->inquiry);
+	sdev->inq_periph_qual = scsi_inq_periph_qual(inq_result[0]);
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
+	if (sdev->sdev_bflags & BLIST_ISROM)
+		sdev->type = TYPE_ROM;
+	else
+		sdev->type = scsi_inq_device_type(inq_result[0], sdev->lun);
+
+	/*
+	 * Update removable flag from INQUIRY byte 1.
+	 * BLIST_ISROM devices are always removable (exception/quirk).
+	 */
+	if (sdev->sdev_bflags & BLIST_ISROM)
+		sdev->removable = 1;
+	else
+		sdev->removable = scsi_inq_removable(inq_result[1]);
+
+	/*
+	 * Set lockable to match removable. Devices with removable media
+	 * can typically have their media locked/unlocked via the
+	 * ALLOW_MEDIUM_REMOVAL command.
+	 */
+	sdev->lockable = sdev->removable;
+
+	/* Update capability flags from INQUIRY byte 7 */
+	sdev->soft_reset = (scsi_inq_sftre(inq_result[7]) &&
+			    (scsi_inq_resp_data_fmt(inq_result[3]) == 2)) ? 1 : 0;
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
+	sdev->wdtr = scsi_inq_wbus16(inq_result[7]);
+	sdev->sdtr = scsi_inq_sync(inq_result[7]);
+
+	/*
+	 * Update tagged queuing support from INQUIRY byte 7.
+	 * BLIST_NOTQ is an exception to force tagged queuing off.
+	 */
+	if (sdev->sdev_bflags & BLIST_NOTQ)
+		sdev->tagged_supported = 0;
+	else
+		sdev->tagged_supported = ((sdev->scsi_level >= SCSI_2) &&
+					  scsi_inq_cmdque(inq_result[7])) ? 1 : 0;
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
+	 *
+	 * During initial setup, old values may not be meaningful (type is -1,
+	 * periph_qual is 0), but callers handle this appropriately.
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
index 3c6e089e80c3..102394910ab1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -898,49 +898,38 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
-
-	sdev->vendor = (char *) (sdev->inquiry + 8);
-	sdev->model = (char *) (sdev->inquiry + 16);
-	sdev->rev = (char *) (sdev->inquiry + 32);
-
-	sdev->is_ata = strncmp(sdev->vendor, "ATA     ", 8) == 0;
-	if (sdev->is_ata) {
-		/*
-		 * sata emulation layer device.  This is a hack to work around
-		 * the SATL power management specifications which state that
-		 * when the SATL detects the device has gone into standby
-		 * mode, it shall respond with NOT READY.
-		 */
-		sdev->allow_restart = 1;
-	}
+	sdev->sdev_bflags = *bflags;
 
-	if (*bflags & BLIST_ISROM) {
-		sdev->type = TYPE_ROM;
-		sdev->removable = 1;
-	} else {
-		sdev->type = (inq_result[0] & 0x1f);
-		sdev->removable = (inq_result[1] & 0x80) >> 7;
+	if (!sdev->inquiry) {
+		int ret = scsi_update_inquiry_data(sdev, inq_result,
+						   sdev->inquiry_len);
+		if (ret < 0)
+			return SCSI_SCAN_NO_RESPONSE;
 
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
+		/* Type or PQ change during initial setup is unexpected but not fatal */
+		if (ret > 0) {
+			sdev_printk(KERN_NOTICE, sdev,
+				"device type or PQ changed during initial setup\n");
 		}
+	}
 
+	/* Sanity check that inquiry data was set up */
+	if (!sdev->inquiry) {
+		sdev_printk(KERN_ERR, sdev, "inquiry data not set\n");
+		return SCSI_SCAN_NO_RESPONSE;
 	}
 
+	/*
+	 * scsi_update_inquiry_data() has already set type, removable, lockable,
+	 * inq_periph_qual, soft_reset, ppr, wdtr, sdtr, tagged_supported,
+	 * simple_tags, is_ata, and allow_restart from INQUIRY data. Handle
+	 * special cases that need the raw inq_result or additional logic.
+	 */
+
 	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
 		/* RBC and MMC devices can return SCSI-3 compliance and yet
 		 * still not support REPORT LUNS, so make them act as
@@ -950,46 +939,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
@@ -1184,6 +1139,7 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 	blist_flags_t bflags;
 	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
+	bool is_reprobe = false;
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1191,7 +1147,19 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
@@ -1206,11 +1174,24 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
@@ -1219,6 +1200,54 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
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
@@ -1705,6 +1734,10 @@ EXPORT_SYMBOL(scsi_resume_device);
 int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	unsigned char *inq_result;
+	blist_flags_t bflags;
+	int result_len = 256;
+	int inquiry_ret = 0;
 	int ret = 0;
 
 	device_lock(dev);
@@ -1721,19 +1754,75 @@ int scsi_rescan_device(struct scsi_device *sdev)
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
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 15ba493d2138..4fb1799634d0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -672,9 +672,59 @@ static int scsi_sdev_check_buf_bit(const char *buf)
  */
 sdev_rd_attr (type, "%d\n");
 sdev_rd_attr (scsi_level, "%d\n");
-sdev_rd_attr (vendor, "%.8s\n");
-sdev_rd_attr (model, "%.16s\n");
-sdev_rd_attr (rev, "%.4s\n");
+
+/* Custom show functions for inquiry strings that take the inquiry_mutex */
+static ssize_t
+sdev_show_vendor(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t ret;
+
+	mutex_lock(&sdev->inquiry_mutex);
+	if (sdev->inquiry)
+		ret = snprintf(buf, 20, "%.*s\n", SCSI_INQ_VENDOR_LEN,
+			       scsi_inq_vendor(sdev->inquiry));
+	else
+		ret = snprintf(buf, 20, "\n");
+	mutex_unlock(&sdev->inquiry_mutex);
+	return ret;
+}
+static DEVICE_ATTR(vendor, S_IRUGO, sdev_show_vendor, NULL);
+
+static ssize_t
+sdev_show_model(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t ret;
+
+	mutex_lock(&sdev->inquiry_mutex);
+	if (sdev->inquiry)
+		ret = snprintf(buf, 20, "%.*s\n", SCSI_INQ_PRODUCT_LEN,
+			       scsi_inq_product(sdev->inquiry));
+	else
+		ret = snprintf(buf, 20, "\n");
+	mutex_unlock(&sdev->inquiry_mutex);
+	return ret;
+}
+static DEVICE_ATTR(model, S_IRUGO, sdev_show_model, NULL);
+
+static ssize_t
+sdev_show_rev(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t ret;
+
+	mutex_lock(&sdev->inquiry_mutex);
+	if (sdev->inquiry)
+		ret = snprintf(buf, 20, "%.*s\n", SCSI_INQ_REVISION_LEN,
+			       scsi_inq_revision(sdev->inquiry));
+	else
+		ret = snprintf(buf, 20, "\n");
+	mutex_unlock(&sdev->inquiry_mutex);
+	return ret;
+}
+static DEVICE_ATTR(rev, S_IRUGO, sdev_show_rev, NULL);
+
 sdev_rd_attr (cdl_supported, "%d\n");
 
 static ssize_t
@@ -935,12 +985,18 @@ static ssize_t show_inquiry(struct file *filep, struct kobject *kobj,
 {
 	struct device *dev = kobj_to_dev(kobj);
 	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t ret;
 
-	if (!sdev->inquiry)
-		return -EINVAL;
+	mutex_lock(&sdev->inquiry_mutex);
+	if (!sdev->inquiry) {
+		ret = -EINVAL;
+	} else {
+		ret = memory_read_from_buffer(buf, count, &off, sdev->inquiry,
+					       sdev->inquiry_len);
+	}
+	mutex_unlock(&sdev->inquiry_mutex);
 
-	return memory_read_from_buffer(buf, count, &off, sdev->inquiry,
-				       sdev->inquiry_len);
+	return ret;
 }
 
 static const struct bin_attribute dev_attr_inquiry = {
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 96b350366670..64740f0d0824 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -169,6 +169,177 @@ enum scsi_disposition {
 #define SCSI_INQ_PQ_NOT_CON     0x01
 #define SCSI_INQ_PQ_NOT_CAP     0x03
 
+/*
+ * INQUIRY data field offsets and lengths (SPC-6 section 6.7.2)
+ */
+#define SCSI_INQ_STD_LEN		36	/* Minimum standard INQUIRY response */
+#define SCSI_INQ_VENDOR_OFFSET		8	/* Vendor Identification (8 bytes) */
+#define SCSI_INQ_VENDOR_LEN		8
+#define SCSI_INQ_PRODUCT_OFFSET		16	/* Product Identification (16 bytes) */
+#define SCSI_INQ_PRODUCT_LEN		16
+#define SCSI_INQ_REVISION_OFFSET	32	/* Product Revision Level (4 bytes) */
+#define SCSI_INQ_REVISION_LEN		4
+
+/*
+ * INQUIRY data byte 0 bit masks
+ */
+#define SCSI_INQ_PERIPH_QUAL_MASK	0xe0	/* Peripheral Qualifier (bits 5-7) */
+#define SCSI_INQ_PERIPH_QUAL_SHIFT	5
+#define SCSI_INQ_DEVICE_TYPE_MASK	0x1f	/* Peripheral Device Type (bits 0-4) */
+
+/*
+ * INQUIRY data byte 1 bit masks
+ */
+#define SCSI_INQ_RMB_MASK		0x80	/* Removable Media Bit (bit 7) */
+
+/*
+ * INQUIRY data byte 3 bit masks
+ */
+#define SCSI_INQ_RESP_DATA_FMT_MASK	0x07	/* Response Data Format (bits 0-2) */
+
+/*
+ * INQUIRY data byte 7 bit masks
+ */
+#define SCSI_INQ_WBUS16			0x20	/* Wide Bus 16 (bit 5) */
+#define SCSI_INQ_SYNC			0x10	/* Synchronous (bit 4) */
+#define SCSI_INQ_CMDQUE			0x02	/* Command Queuing (bit 1) */
+#define SCSI_INQ_SFTRE			0x01	/* Soft Reset (bit 0) */
+
+/**
+ * scsi_inq_periph_qual - Extract peripheral qualifier from INQUIRY byte 0
+ * @inq_byte0: INQUIRY data byte 0
+ *
+ * Returns: Peripheral Qualifier (0-7)
+ */
+static inline unsigned char scsi_inq_periph_qual(unsigned char inq_byte0)
+{
+	return (inq_byte0 & SCSI_INQ_PERIPH_QUAL_MASK) >> SCSI_INQ_PERIPH_QUAL_SHIFT;
+}
+
+/**
+ * scsi_inq_device_type - Extract device type from INQUIRY byte 0
+ * @inq_byte0: INQUIRY data byte 0
+ * @lun: Logical Unit Number
+ *
+ * Extracts the peripheral device type from INQUIRY byte 0. For well-known
+ * logical units (W-LUNs), automatically corrects the type to TYPE_WLUN if
+ * the device reports an incorrect type, as some devices respond with wrong
+ * type for W-LUNs.
+ *
+ * Returns: Peripheral Device Type (0-31), corrected to TYPE_WLUN for W-LUNs
+ */
+static inline unsigned char scsi_inq_device_type(unsigned char inq_byte0, u64 lun)
+{
+	unsigned char type = inq_byte0 & SCSI_INQ_DEVICE_TYPE_MASK;
+
+	/*
+	 * Some devices may respond with wrong type for well-known logical
+	 * units. Force well-known type to enumerate them correctly.
+	 */
+	if (scsi_is_wlun(lun) && type != TYPE_WLUN)
+		type = TYPE_WLUN;
+
+	return type;
+}
+
+/**
+ * scsi_inq_removable - Extract removable media bit from INQUIRY byte 1
+ * @inq_byte1: INQUIRY data byte 1
+ *
+ * Returns: 1 if removable, 0 if not
+ */
+static inline unsigned char scsi_inq_removable(unsigned char inq_byte1)
+{
+	return (inq_byte1 & SCSI_INQ_RMB_MASK) ? 1 : 0;
+}
+
+/**
+ * scsi_inq_resp_data_fmt - Extract response data format from INQUIRY byte 3
+ * @inq_byte3: INQUIRY data byte 3
+ *
+ * Returns: Response Data Format (0-7)
+ */
+static inline unsigned char scsi_inq_resp_data_fmt(unsigned char inq_byte3)
+{
+	return inq_byte3 & SCSI_INQ_RESP_DATA_FMT_MASK;
+}
+
+/**
+ * scsi_inq_wbus16 - Check if device supports 16-bit wide bus from INQUIRY byte 7
+ * @inq_byte7: INQUIRY data byte 7
+ *
+ * Returns: 1 if 16-bit wide bus supported, 0 if not
+ */
+static inline unsigned char scsi_inq_wbus16(unsigned char inq_byte7)
+{
+	return (inq_byte7 & SCSI_INQ_WBUS16) ? 1 : 0;
+}
+
+/**
+ * scsi_inq_sync - Check if device supports synchronous transfers from INQUIRY byte 7
+ * @inq_byte7: INQUIRY data byte 7
+ *
+ * Returns: 1 if synchronous transfers supported, 0 if not
+ */
+static inline unsigned char scsi_inq_sync(unsigned char inq_byte7)
+{
+	return (inq_byte7 & SCSI_INQ_SYNC) ? 1 : 0;
+}
+
+/**
+ * scsi_inq_cmdque - Check if device supports command queuing from INQUIRY byte 7
+ * @inq_byte7: INQUIRY data byte 7
+ *
+ * Returns: 1 if command queuing supported, 0 if not
+ */
+static inline unsigned char scsi_inq_cmdque(unsigned char inq_byte7)
+{
+	return (inq_byte7 & SCSI_INQ_CMDQUE) ? 1 : 0;
+}
+
+/**
+ * scsi_inq_sftre - Check if device supports soft reset from INQUIRY byte 7
+ * @inq_byte7: INQUIRY data byte 7
+ *
+ * Returns: 1 if soft reset supported, 0 if not
+ */
+static inline unsigned char scsi_inq_sftre(unsigned char inq_byte7)
+{
+	return (inq_byte7 & SCSI_INQ_SFTRE) ? 1 : 0;
+}
+
+/**
+ * scsi_inq_vendor - Get pointer to vendor string in INQUIRY data
+ * @inq_data: Pointer to INQUIRY data buffer
+ *
+ * Returns: Pointer to 8-byte vendor identification string (not null-terminated)
+ */
+static inline const char *scsi_inq_vendor(const unsigned char *inq_data)
+{
+	return (const char *)(inq_data + SCSI_INQ_VENDOR_OFFSET);
+}
+
+/**
+ * scsi_inq_product - Get pointer to product string in INQUIRY data
+ * @inq_data: Pointer to INQUIRY data buffer
+ *
+ * Returns: Pointer to 16-byte product identification string (not null-terminated)
+ */
+static inline const char *scsi_inq_product(const unsigned char *inq_data)
+{
+	return (const char *)(inq_data + SCSI_INQ_PRODUCT_OFFSET);
+}
+
+/**
+ * scsi_inq_revision - Get pointer to revision string in INQUIRY data
+ * @inq_data: Pointer to INQUIRY data buffer
+ *
+ * Returns: Pointer to 4-byte product revision level string (not null-terminated)
+ */
+static inline const char *scsi_inq_revision(const unsigned char *inq_data)
+{
+	return (const char *)(inq_data + SCSI_INQ_REVISION_OFFSET);
+}
 
 /*
  * Here are some scsi specific ioctl commands which are sometimes useful.
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
2.51.2

