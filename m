Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F97A33FE0F
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 21:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067627; cv=none; b=i4G6T0zPTSV5n7TM8iEfra+zY6gB9u4UWjQ/PsX7CIjj4ik7/l5mOy/M3lgXQsUT9fLf6c2JnYFabw7R7QUAjTFy0JXUVXjcPSYGGzMCu2xbcBZtnCytJ1y/P+vEI/KVZN8rrwX6JlIV9ymXm1HK735AOync9imLBoxKsUGqZ+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067627; c=relaxed/simple;
	bh=5sP3mTelMvRkShOP3YX1fxWcs6ZBb87+NIOST04Jfvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjryUsRHkncpznCVVYc/rpY6r6VmNy3ATtZz14vgjaEP3dxeTgdDNH0u/i5+JaurWU2nmGIcbi/yZ8GuQe+IZ5t/fDUtIJW8E45w0hs/T38ShKpdWDtJfxufO5iGjvL+PVIAYCmSGyUX0Dmfwn/sf1DCGg0Ot4aGSHEmq1PLGBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=FVPuCpv4; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="FVPuCpv4"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-12dbd0f8063so1898358c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 14:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777067626; x=1777672426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2am0HIHaP2aydq1fP6E3lz97XeIYawUpOKAu6RTDzLk=;
        b=FVPuCpv4zpS1VDexbMGH1XDA91FQA5mtmE2Gcjo+UGBs6CCV8hLGrGkahrH4UjNYu3
         q9EdNg0N8NpGBHXR5jdqfNJiaRjUxVW9Jr/6/fE3Z6FCzunVQiyuAJdKPtIYIXuT8Hxd
         XKmrSWZwv7xUn93a/OnoHCcGnd8KMz565na/v1ViX2GbaouIlZl8afPrTDFpDcwfOS5Y
         LRu7mdKTNcPA1aotvgpBrl+GyLGn4oAZAqOWBph+zCEzh2y4fKeHp2E+eOL7Yq73Iaef
         E+DQM1Gg/xUWnXTknGSW1hu2TgjvvChs8p1z8nFVf3Pwktz/vXd65slmKLD2pt5hZSNQ
         ba3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777067626; x=1777672426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2am0HIHaP2aydq1fP6E3lz97XeIYawUpOKAu6RTDzLk=;
        b=QOjf/ZXuQwKABLKEdJ3Xcg9WhfsuK8ctfliRnACXYmzYjDkUKiRN6/gJIwmX/wllbl
         2p/0Mbu+7smW6+54iYD99aNoJH0otTyiZQpWu4/ub8X4yNH7Q2a/JniD29L5GV7ZfXKh
         Kk/9wn0lM1v81wgibhtb5qBJZO2GWk1kJcNJPzJ0Y3rashySVtuDQXHCz2fo7f07IgjI
         nByQLETRl5j65KDuVquMOr4+cH79m2fg9SfGElUnJOfdHzFWH3Ew5jiynVn31gReret3
         6zlMPCf0VN9DTFvu5As/CjeNso3xHiufdzboYVxjtVTeQEZwJF0txIWO+IB0W+IRnUVe
         uyHw==
X-Forwarded-Encrypted: i=1; AFNElJ9K+LUy6ZQF44wRduZO/2Ud0CPIU7Z0xVOzsXry9BNJK7gqYQgbrcshgdMu7UkImpZlBAB2q/4TTCTc@vger.kernel.org
X-Gm-Message-State: AOJu0YyBP9iH5figGQ/Ww+CGEx1Eh33eJg5G0OoP04rqhE6RkCs0rpgg
	7FtSPIWSTQGHYxDcPmFv3d6+7Nf+dxCq6TQbmayg9RbdFWkby0py1Qh1cyvErQBDT04=
X-Gm-Gg: AeBDievruNmRh3y7albPTumzqZGjeE23gSXYGql15QNG7X3Du9yUT7oy8yp0mWuZY0F
	3l8oYEPPFnMuyeegPeb/+Df/6bxayG4SlYi0sC0VKD34P2+tWW1c44xflfz83x0U0SKLHbrMEU7
	udN7yCblJvoKnHwP/ECyxawtj00tiQlA6frmouaNHQgDxJjqqVkhhy0H8sFd5ZmqWy4yZ8QrG2p
	jTqag1MRWGQHPEtNchom7bJ2dqUqP2W17Wdw53nxraQKWrUiFWBbhD7ZmrzsWiLkAAUHJYsACnP
	A1SBFqziY/WzRDfDbm43Dhp+zk7hHuOUWFiB8bdBjr7r+TPvKepVSzJmjchOHrtO6awQcPL8n9l
	kdJN2hd6pYNzybqz9ppFyDbIhoInEdXAylIokuq1uSE6OT9iq97fHu1/GDqT8UPpz8KCzoIzNwC
	owbnqnj9cPCRM4EtJEFoKazn+SWfnD6EQhZk3rpykZUEkTeZ7ONkewSOtG+F6dLWLxQrT+ZTISp
	NV5ZsgRNq19TgrSxeo260iSb/tOWeh63+YF+p5+ycxjSqCij9ajCsvLCt9Xc/lDvZuQEKbtFuJp
	6ROcTGUAfUW30Iyh8HP8H+tu2aaeSi1mXXc=
X-Received: by 2002:a05:7300:324b:b0:2ea:ed3d:94f3 with SMTP id 5a478bee46e88-2eaed3d9892mr364950eec.1.1777067625343;
        Fri, 24 Apr 2026 14:53:45 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e539fa5c38sm33172246eec.5.2026.04.24.14.53.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 24 Apr 2026 14:53:44 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: hare@suse.de,
	linux-scsi@vger.kernel.org
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 3/6] scsi: Add scsi_update_inquiry_data() for updating INQUIRY data
Date: Fri, 24 Apr 2026 14:53:21 -0700
Message-ID: <20260424215324.99045-4-brian@purestorage.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424215324.99045-1-brian@purestorage.com>
References: <20260424215324.99045-1-brian@purestorage.com>
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

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
---
 drivers/scsi/scsi.c        | 164 +++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h |  13 +++
 2 files changed, 177 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 76cdad063f7bc..82231c6970587 100644
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
@@ -549,6 +550,169 @@ void scsi_attach_vpd(struct scsi_device *sdev)
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
+		sdev->tagged_supported = (sdev->scsi_level >= SCSI_2) &&
+					  scsi_inq_cmdque(inq_result[7]);
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
+	if (had_prior_inquiry &&
+	    (old_type != sdev->type || old_periph_qual != sdev->inq_periph_qual)) {
+		if (old_type != sdev->type)
+			sdev_printk(KERN_NOTICE, sdev,
+				    "device type changed from %d to %d\n",
+				    old_type, sdev->type);
+		if (old_periph_qual != sdev->inq_periph_qual)
+			sdev_printk(KERN_NOTICE, sdev,
+				    "peripheral qualifier changed from %d to %d\n",
+				    old_periph_qual, sdev->inq_periph_qual);
+		return SCSI_INQ_REPROBE_NEEDED;
+	}
+
+	return SCSI_INQ_UNCHANGED;
+}
+EXPORT_SYMBOL(scsi_update_inquiry_data);
+
 /**
  * scsi_report_opcode - Find out if a given command is supported
  * @sdev:	scsi device to query
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c2a7bbe5891e..356396b85869a 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -407,6 +407,19 @@ void scsi_attach_vpd(struct scsi_device *sdev);
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
2.50.1 (Apple Git-155)

