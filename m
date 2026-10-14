Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ADA2D6E5A
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 22:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792015240; cv=none; b=IUBRFa2k6D4N8s/2Ce4SnGOSqD2IxoIIqptRzRY1KX6za5SQLnR0So1aR+Iiwx0MyWSUPzZbv5PvbUvu4Kc5eSZqsCYJachGybgOCyZ2gqmVLNfarBTW8in7pcvVX417rtgTa8uYrAFMrqRizzO4zteI+VvHw6r/tKU1HiUSHQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792015240; c=relaxed/simple;
	bh=bw4Gh90TzCAuCMGklTfw5eqarZhbO4IssNblSpdz73w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZI3TBeZEHaZHtiaLqRE37myh7F3izBn5/j6kfkqjvaVOdmGbhb1KdfLp+q4YeVtHa+06tLoI1XWRbiI8SIdPkkeNbtUPHdvTj2gA2wwSwMuAN1xf3cbrnN67XjQapATWs6Zrd4ze25XfN8JzpeRBD+mLdVrVVl/zcZAXn7lXPqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=LvXjf7h+; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="LvXjf7h+"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso4698879eec.1
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792015237; x=1792620037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tXlF75CVi+vsrNmavSAc/rsauow5slCdmRegBHCFWhk=;
        b=LvXjf7h+H5H9FzrEPwk5ehH0VO0Rof04md7nvJdhgvIEefju8fP0IfJImEyznfqfqj
         6M5h1R3kgOMEJAyl9NC8uPjHhPVAAwhrr6U97JThgu6MF9ZLBUtlUWD/Tg2HDwdYz0xM
         5NRIdZeeWngj56FrywlRWILGmBW8EHXXgo9d4sym1ZCMmmbgPDOxocLIom2GsvlfHnDZ
         ipRfWOyxr2gPc5VcF7BJpgKKV7OAAEO7f+Zo9KwPA8PT27vek6N/0V54Qf2obM7q5mr8
         jeYLXHJ93LeYg/dHNbS2zl/nS5K/TM8J8cnNLfnFAtNcbYZE89TB/JcHvgQOTT3EaJvW
         aiVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792015238; x=1792620038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tXlF75CVi+vsrNmavSAc/rsauow5slCdmRegBHCFWhk=;
        b=tp+UgRvspKioWC4QM+HWzj8ezn1CMKilI2eS6glLGzyMhg5B3V+0bETTN6Y2KhqOr3
         3Y60PMmSG++INL09VYzGiEGDeapPFJ2InooHKhKLK8iClCi/f9yjw57KT4trzBwnOZwb
         VP1iz5c6VZYolMGRQ1yhaCNUBD87SS90Hv7+qLAzr99vxmmfFP1CYBPFniFzMnno/vJW
         CXkiMqytgBan9QscTcR72DH8hrNagxqbJ3gxcrOwQ+NgtW8U9XQCa9VsBBm3pG9JtnG8
         4JQ3tQBHF6YaBkK3b3VL+CY8BlmLH4whF54jSkYcDE3061tiGNhNR88eDuQLCNBC8qZx
         EIBQ==
X-Gm-Message-State: AFq9FYLHeoj/MXh8vsFl6EdkEzoS3Y4AuIOLKFGWzqHdpJS/5M8MruJ4
	/PzmE+IzCrpj8fqm33Vtzmx9GLBwRXa0QDgsS5EJOkj+QEWCGM+RPV1tuBenz/omq/Q0KFaRBc+
	TZc35lDl8Lk1ZoC/QuJfa3QgzlAfbKUU8KJOjn55kouhVGg0EBAm7UVJO/0eNl6fMbiiyINNbrp
	6THG4CKa57kiQkYjy2MRhPJEG4MLHNeZ9I+IxQ+4x4A7HGd7CYAQ==
X-Gm-Gg: AYBFou3Jbf6vwLpkidXLhNO7JiIXHxFuiVHmOi+aara4XL7hkiNrSJzap1Yk11JTuhE
	v8ILNYzFWZyhv3lpnDLopyZEG8CFFez8kL/wjT+6PNADhmE2IzS5D1MBhmiqvzew43p6RL/V5w6
	rWCv7fZLsE9NaFwCkpRvhnU8pm0kD9qiyR3Tf4MvdkaNZlmIUj4flwzSPMD8Mk4ueBCfebFhAA3
	9C0Sz1MWdHEyVKd5RLE+fGB+hzdSv142Zyxhw2DzK7r7YKl5NuYWjGPyX1TRLjpNGFiw9mwXi3V
	56cFfxubHoxGsRKoNeKyT5+jQRIvi7UtqzZgIWZqK3ZkKgZPpfM2mQgAenmKE1HOKnGQYDZzlf6
	VXZE6LlIU7aP6EkphvK5fxEE8qESvnQ0GKVwczAlR6yaaHaixQ45KnTO5wEoupjw1SGoi11EFc2
	zdDEZnyQ7A+iY7OxSN1aC3ywC9r8W0obme12Vxiw9klOxgMYof5OG7cswF/e0zJu9WOeGnzkwi0
	6lqM+Hkwu/tEXAfc3niQ3Rn77mX0X+nEF1IXdfRGj1dP8t5eC10bXcGiKpmKFNexFrXxrzsGAn/
	bP4NIbwtObVCR/Ccm5MjBdyPpOBqRdhPqOlthgry12UzwZypOcBcAzymaBXExsDxK9Vs4Q0=
X-Received: by 2002:a05:7300:f582:b0:34c:5831:8a19 with SMTP id 5a478bee46e88-3537e0493a0mr22476087eec.40.1792015236647;
        Wed, 14 Oct 2026 15:00:36 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b19c6c7b4sm30236633eec.24.2026.10.14.15.00.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 15:00:36 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v7 2/5] scsi: core: Add scsi_update_inquiry_data() for updating INQUIRY data
Date: Wed, 14 Oct 2026 15:00:11 -0700
Message-ID: <20261014220014.94330-3-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014220014.94330-1-brian@purestorage.com>
References: <20261014220014.94330-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
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
 drivers/scsi/scsi.c        | 205 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  13 +++
 2 files changed, 218 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3af9e77847f7..cfb0f53b2b1a 100644
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
@@ -549,6 +550,210 @@ void scsi_attach_vpd(struct scsi_device *sdev)
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
+	 */
+	sdev->scsi_level = inq_result[2] & 0x0f;
+	if (sdev->scsi_level >= 2 ||
+	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
+		sdev->scsi_level++;
+
+	/*
+	 * Update device type from INQUIRY byte 0. BLIST_ISROM overrides the
+	 * reported type with TYPE_ROM.
+	 */
+	if (sdev->sdev_bflags & BLIST_ISROM) {
+		sdev->type = TYPE_ROM;
+	} else {
+		sdev->type = inq_result[0] & 0x1f;
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

