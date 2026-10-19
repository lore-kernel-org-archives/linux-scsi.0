Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792448064;
	b=UoHm1JpTBtsROhpqOd8WrAbi8ynQueDBcpPF8+loMJXJ27eioAbpH99CzWSTFi+5MkGt
	 84pY5D+ZdBKrXOQOe0vwmeP8IzF6Xfvxu/tNcTxYRntTkqThTnjU/L6JtltsDIrHyxY+v
	 Fj1pxoxGhdwkiMo2v3v6RhcXKWS5acTVpDncMHoIT4c0qTTfYaKPuK9yHfFpQKVPGNa5o
	 woOohCAXFRR9GTtorFJ1zTlJJrITpkTKNOjr85JW2TE+aCLMg74CoBTV+UKKrKNm/6xy1
	 d7znQUlE2oCJWuWR+AGarD/NaZZM2o+TqdmFWMOcUOzU8ooq7wyIu5TXAfR6Nafrefg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448064;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sv7c9NsoEPpc+ZILgTyR4tNCq18XKuIMkaA9FrsgiVY=;
	b=o7V9QINuym1ZHbTBbj9cOxXNCIemymbQp/JxtqVPoHdb4o/4cflcYTMgAHH3W33BJBbl
	 /rB9V1wytKsGbRm4dXpbD9IhFRhCtdr5TFTsUkI4rNLQUNBDdfcG0dv7bq8c9UG6ljDG/
	 9bACFyEtdQ1MkKi67BOICRUVQmyGMXTYrNnIXBJ2V76Usd6MYhSbJevx933YbQxXAcexF
	 Jb6b1L32NA0hYUN+GGU7GBHChwzUKd5iQREN7CMpqsR9OO5ICSgnTOWY1F0hNujeKZOnl
	 /zka5U46vB0n0+xFBqNoOujw5FLwv7ja21vZN7S860LMNaDnpwia0nmelHrXQ3Y/s9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b="H4L/hX2I";
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4766A606A31D
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:14:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4766A606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=H4L/hX2I
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1517bda04a0so2145794c88.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 15:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792448063; x=1793052863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sv7c9NsoEPpc+ZILgTyR4tNCq18XKuIMkaA9FrsgiVY=;
        b=H4L/hX2IyfFwG2bllxML23Z4oiY7z5kzF/1q6329stN1ujAKFadKX5w2f7sFIcNBBn
         K4ofU7B6rtd/AaDEr6bhj26RAveFIzaH3bzPHvT+3+PLf/xulD4XLxJD381UU9yp+It0
         SPdcwb3ej+MwbpL+qnVjdTSWvyCD7gm9rL5HCorV5mYRQA/JmCkujvuWgEShtgunqbBK
         4yQDGBJY0KeLh3hsNFPGaLO9mDIBXh4VKs3kE81lL9DJNMyOD1W215AA2gW6EyGEAkif
         LvFYONPByj24RfOO26LO2h1qSPZLbLzU4RgRLuHYFScXXTbke+vmBz238oUT5WJlC6aF
         RM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792448063; x=1793052863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sv7c9NsoEPpc+ZILgTyR4tNCq18XKuIMkaA9FrsgiVY=;
        b=GLr5DKAv1LEazzExPqu9U3+7XBYtc7n8WxhcbHHzCXULGC6osXAfonUwAX0g6jDD4N
         gObCDpQDryY5caCRpGQCFNOGr9lppCaAVEBRm8PSHQzU3AnoKVDaIUXGDh479tOy2tI4
         iZMELBRinrtPDqczEq5mLN6rzFOf3STou++B9HDvUL4mIIX50MmRoY7cnGYXNlr22fPk
         d7ipdAW1g/ML2l218iODH1g5KyhEMXfn2wFD6eVQMTBGj9Zohy5FMha7fpbkqNlBkUVG
         6x8C1f0c0SmGiILrOYtT3XCQKUe2yR/Dt255mTAANoQO7ujMEo5LVeqXp3Ff84cyXy08
         mPVw==
X-Gm-Message-State: AFq9FYIZevX2/79TjsnwKrG5fSMcaHYHwlogqvnPwKHiN+2OS+Qm6N7z
	ROlxImQiaQ9gtfupOfA5VK9UThT0fERNtYb+q7D9EiOOQytkNIjJs98M6kYmoSiuWvMShMxDBE4
	x/ItTaq+0lIMMpM1ewfHiRdqvbUUppbR6owNLcmY+Lh5kEL/q+O825PDyZcnPUL8w0oV0a0dTPj
	+/MK6e7ExnQ36rMmQunoYBTrUGzY/Y6ZBVjZ9EUBzHDuQN9ELIYA==
X-Gm-Gg: AYBFou28UCZ7ejBQcwCeMV3qWwZflvEQYFG5HXfHN6aZXmH8fkrLHNsCpV4JhKzJvrJ
	Ejk42EqNQXnsKONTIj6kg+1FI4Xr/V611T5joZTId9PrKuKdzi6ZrJ9uXWPgyXoxgdw6nxkIx88
	3XRX+ugT5Duby5KSWKr5MxDj/V3RQIOoxKqy/sCZFAXIuYrl7alwh/5+7XIwTk1y1nhKPG7AtR7
	ysgLc68htZYBgcPvoUIDCAWXhYnPM86TmNfdajMWRNOtFZ4uGDyZFMJ2nGApvAI0s0RRLY33Nie
	DBqfVgBosqe8DHLd2MI+kTBomIyS9KDhxHGP/+rzUdOgzfzCkPlo1yCJ334cuYBSCqBIqVXZEd0
	dkgzMDAjo154Oat4U2BJGS8gbioYDoPRuT5Fd9bJNNsOyHGGRTzG7OWuAfU6GzczgpM3uNmSHLS
	GF/H5msdSTtWLcO7Tuxvzx7C7GavrOYhxP9Kbx73IwT7cMtSJyVeXK24RZHVDZpfn3aBp90FD3G
	NUnsqyeOn+EtwwPWBBVA3AU3OYx507lLWWomIbNVVM+9BexIpPTJ7pqASu/18LsasB6kjOVsA5e
	sCb9DbZNvUIKTZ1oepZk9A/V74SxaBST9BaCsghDeUcX2UYg26HBpTmG6dn4hKK4jVI8b7zT9+/
	BC8xfiw==
X-Received: by 2002:a05:7022:5f13:b0:159:2c6d:fcc3 with SMTP id a92af1059eb24-18512e254abmr9637415c88.33.1792448062881;
        Mon, 19 Oct 2026 15:14:22 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-18319d3b880sm29429839c88.10.2026.10.19.15.14.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Oct 2026 15:14:22 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v8 2/5] scsi: core: Add scsi_update_inquiry_data() for updating INQUIRY data
Date: Mon, 19 Oct 2026 15:14:01 -0700
Message-ID: <20261019221405.40614-3-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019221405.40614-1-brian@purestorage.com>
References: <20261019221405.40614-1-brian@purestorage.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new function scsi_update_inquiry_data() that stores standard
INQUIRY data for a SCSI device and updates the fields derived from it:

- Vendor, model, revision strings
- Peripheral qualifier, device type and SCSI level
- On the first call only: capability flags (removable, lockable,
  tagged queuing support, transfer modes, ATA detection, ...)

The function:
- Takes the inquiry_mutex to protect against concurrent sysfs reads
- Allocates sdev->inquiry once at its maximum size and copies later
  updates into it in place. Several helpers in <scsi/scsi_device.h>
  (scsi_device_tpgs(), scsi_device_protection(), ...) read
  sdev->inquiry without any lock, so the buffer must never be freed
  while the device is live.
- Computes scsi_level and type in local variables and stores each one
  once with WRITE_ONCE(). Both are also read without inquiry_mutex (by
  the I/O path, upper-level drivers and the uevent code), so a lockless
  reader must never see an intermediate value, such as the unincremented
  scsi_level or the uncorrected type of a well-known LUN.
- Leaves the capability flags alone when refreshing an existing device.
  LLDs and upper-level drivers adjust several of them after the initial
  probe (usb-storage and scsi_ioctl clear lockable, aacraid forces
  tagged_supported, ...), and they share a word with runtime state bits
  that are written without inquiry_mutex.
- Applies the BLIST_ISROM type override on every call. The BLIST_ISROM
  removable override and BLIST_NOTQ only affect the capability flags,
  so they are applied on the first call only
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
 drivers/scsi/scsi.c        | 215 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  13 +++
 2 files changed, 228 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3af9e77847f7..6a421961dbd0 100644
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
@@ -549,6 +550,220 @@ void scsi_attach_vpd(struct scsi_device *sdev)
 	kfree(vpd_buf);
 }
 
+/*
+ * Size of the buffer that holds sdev->inquiry. sdev->inquiry_len is an
+ * unsigned char, so at most 255 bytes of INQUIRY data are ever stored.
+ */
+#define SCSI_INQUIRY_BUF_LEN	256
+
+/*
+ * Set the capability flags derived from INQUIRY data. These are only set
+ * when the device is first probed: LLDs and upper-level drivers adjust
+ * several of them afterwards (lockable, tagged_supported, ppr, ...), and
+ * they share a word with runtime state bits that are updated without
+ * inquiry_mutex, so they must not be rewritten on a live device.
+ */
+static void scsi_set_inquiry_flags(struct scsi_device *sdev,
+				   unsigned char *inq_result, size_t inq_len)
+	__must_hold(&sdev->inquiry_mutex)
+{
+	/*
+	 * Check if this is an ATA device (SATA emulation layer).
+	 * ATA devices need allow_restart set to work around SATL power
+	 * management specifications.
+	 */
+	if (strncmp(sdev->vendor, "ATA     ", 8) == 0) {
+		sdev->is_ata = 1;
+		sdev->allow_restart = 1;
+	}
+
+	/*
+	 * BLIST_ISROM is a quirk for devices that report the wrong type but
+	 * should be treated as (removable) CD-ROM.
+	 */
+	if (sdev->sdev_bflags & BLIST_ISROM)
+		sdev->removable = 1;
+	else
+		sdev->removable = (inq_result[1] & 0x80) >> 7;
+
+	/*
+	 * Set lockable to match removable. Devices with removable media
+	 * can typically have their media locked/unlocked via the
+	 * ALLOW_MEDIUM_REMOVAL command.
+	 */
+	sdev->lockable = sdev->removable;
+
+	/* Capability flags from INQUIRY bytes 3, 7 and 56 */
+	sdev->soft_reset = (inq_result[7] & 1) && ((inq_result[3] & 7) == 2);
+	if (sdev->scsi_level >= SCSI_3 ||
+	    (inq_len > 56 && inq_result[56] & 0x04))
+		sdev->ppr = 1;
+	if (inq_result[7] & 0x60)
+		sdev->wdtr = 1;
+	if (inq_result[7] & 0x10)
+		sdev->sdtr = 1;
+
+	/* BLIST_NOTQ forces tagged queuing off */
+	if (sdev->scsi_level >= SCSI_2 && (inq_result[7] & 2) &&
+	    !(sdev->sdev_bflags & BLIST_NOTQ)) {
+		sdev->tagged_supported = 1;
+		sdev->simple_tags = 1;
+	}
+}
+
+/**
+ * scsi_update_inquiry_data - Update standard INQUIRY data for a SCSI device
+ * @sdev: The device to update
+ * @inq_result: Buffer containing new INQUIRY data
+ * @inq_len: Length of inquiry data
+ *
+ * Stores the standard INQUIRY data for @sdev and updates the fields derived
+ * from it: vendor, model, revision, peripheral qualifier, device type and
+ * SCSI level. This is used both during initial device setup and when an
+ * existing device is rescanned. On the first call the capability flags
+ * derived from INQUIRY data are set as well; see scsi_set_inquiry_flags().
+ *
+ * The INQUIRY buffer is allocated once, at its maximum size, and later
+ * updates copy the new data into it in place. Several helpers in
+ * <scsi/scsi_device.h> read sdev->inquiry without holding inquiry_mutex,
+ * so the buffer must not be freed or reallocated while the device is live.
+ *
+ * The BLIST_ISROM type override is applied on every call. Its removable
+ * override, like BLIST_NOTQ, only affects the capability flags and is
+ * therefore only applied on the first call.
+ *
+ * Returns:
+ *   SCSI_INQ_UNCHANGED on success
+ *   SCSI_INQ_REPROBE_NEEDED if peripheral qualifier or device type changed
+ *  -ENOMEM on allocation failure
+ *  -EINVAL if inquiry data is too short
+ */
+int scsi_update_inquiry_data(struct scsi_device *sdev,
+			     unsigned char *inq_result, size_t inq_len)
+{
+	unsigned char *new_inquiry = NULL;
+	unsigned char old_type;
+	unsigned char old_periph_qual;
+	unsigned char type;
+	char scsi_level;
+	bool refresh;
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
+	inq_len = min_t(size_t, inq_len, SCSI_INQUIRY_BUF_LEN - 1);
+
+	/*
+	 * The buffer is only allocated on the first call, from scsi_add_lun(),
+	 * before the device is visible to anyone else.
+	 */
+	if (!sdev->inquiry) {
+		new_inquiry = kzalloc(SCSI_INQUIRY_BUF_LEN, GFP_KERNEL);
+		if (!new_inquiry)
+			return -ENOMEM;
+	}
+
+	mutex_lock(&sdev->inquiry_mutex);
+
+	/*
+	 * Save peripheral qualifier and device type before updating. These
+	 * are the only two values that determine whether device_reprobe() is
+	 * needed: type controls which upper-layer driver (sd, st, sr, ...) is
+	 * bound, and PQ controls whether the LUN is accessible at all
+	 * (scsi_bus_match() only matches PQ == 0).
+	 */
+	refresh = !new_inquiry;
+	old_type = sdev->type;
+	old_periph_qual = sdev->inq_periph_qual;
+
+	if (new_inquiry)
+		sdev->inquiry = new_inquiry;
+	memcpy(sdev->inquiry, inq_result, inq_len);
+	memset(sdev->inquiry + inq_len, 0, SCSI_INQUIRY_BUF_LEN - inq_len);
+	sdev->inquiry_len = inq_len;
+
+	strscpy(sdev->vendor, sdev->inquiry + INQUIRY_VENDOR_OFFSET);
+	strscpy(sdev->model, sdev->inquiry + INQUIRY_MODEL_OFFSET);
+	/*
+	 * memcpy() instead of strscpy() because strscpy() would read past
+	 * the end of the INQUIRY data if its length is exactly 36 bytes.
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
+	 *
+	 * scsi_level and type are also read without inquiry_mutex, by the
+	 * I/O path, upper-level drivers and scsi_bus_uevent(). Compute them
+	 * in local variables and store each one once, so that a lockless
+	 * reader sees either the old or the new value, never an
+	 * intermediate one.
+	 */
+	scsi_level = inq_result[2] & 0x0f;
+	if (scsi_level >= 2 ||
+	    (scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
+		scsi_level++;
+	WRITE_ONCE(sdev->scsi_level, scsi_level);
+
+	/*
+	 * Update device type from INQUIRY byte 0. BLIST_ISROM overrides the
+	 * reported type with TYPE_ROM.
+	 */
+	if (sdev->sdev_bflags & BLIST_ISROM) {
+		type = TYPE_ROM;
+	} else {
+		type = inq_result[0] & 0x1f;
+
+		/*
+		 * Some devices may respond with wrong type for well-known
+		 * logical units. Force well-known type to enumerate them
+		 * correctly.
+		 */
+		if (scsi_is_wlun(sdev->lun) && type != TYPE_WLUN) {
+			sdev_printk(KERN_WARNING, sdev,
+				"%s: correcting incorrect peripheral device type 0x%x for W-LUN 0x%16xhN\n",
+				__func__, type,
+				(unsigned int)sdev->lun);
+			type = TYPE_WLUN;
+		}
+	}
+	WRITE_ONCE(sdev->type, type);
+
+	if (!refresh)
+		scsi_set_inquiry_flags(sdev, inq_result, inq_len);
+
+	mutex_unlock(&sdev->inquiry_mutex);
+
+	if (refresh) {
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
2.56.0

