Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B905C37D133
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 22:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792015248; cv=none; b=nksfHWLbPZOMkxWX58bFqmB6cP6+KXIGHjiPqdza4bxYoC1BYf+d+l6MUtorzFVuo1dyFwm7bwVzzYGMK6B5MX4QAuyll5h54oZXLFDSShEoxNUTtVRRHE/DvzSVxfzrIWU3v3hpzBt01mYJjNzsAlhhJ8VMAQcFSENWYQnCTfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792015248; c=relaxed/simple;
	bh=X7KB2RkZ62PT8WY9lPypfy1hxlsqaeDp4FhDleqKyhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ln4OUQAT79sWDBxq7v1ubZlVyp/xefiwMQkHVyDUYx6WcopUkgznsvMWdWUvBIYVhQp9hLLpr1zM1yTnoAfCovA482+WVBfBh4xWZQcUVPbRRLQPt2TlZ2GD8G2+OKiWIuI02MsPM7nhwNBmfpaNmAR3H80k72D/GiTg4tGali8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Xf8jutEk; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Xf8jutEk"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso2107044eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792015246; x=1792620046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1+GNS4Q3g87uoW34lZDUgbtZ4cMZdl+iPgXFfkVj/MI=;
        b=Xf8jutEkzl2OCulEC8SLtv6P163skglZwr/rQp0nhKU+vr8aWMS1JZfb4x4klGfNZ0
         KrLBPgR744+vNmJKfUijehZkNTrjRteMTqnzRahITnMplzRZmhFfTdB83aDiux0DtIo1
         fyfQczTT01dJyTbS3EUWNZkUxXVNaH0nNCg9Wk9edJvVwIy/gHnkYumv2JsjRToYwsAs
         Clox1+zGIW3/dUH0TLyiD4bZkVoc3nJiyr377zOJdzA7rHAl0BwoY6Bw7z+HPKdp8ZRd
         GIJcbe/tsItVQPA9pfbW53rT4Q2beX1aCSIRvr4ZW9lB8Xlhu2qLprhb7QK5dFDndM3h
         m5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792015246; x=1792620046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1+GNS4Q3g87uoW34lZDUgbtZ4cMZdl+iPgXFfkVj/MI=;
        b=MXv+t1+xJictgRC8Gu/lsBLWak7uT/bfd3HQpzsZGNDrZ+jwdVebjPCbz1rF2SV+CM
         eTpFitW4c2H0uGr+4mFmDmzawZ2TWEf3v1VvJClHX2Q5kdMVH/TPAHDuEwsGMugrOQbs
         YOfY1ikm9zdNSnGCgjlIfepnXcWEGRfUMuLe6cGXgMx1R6erFmsm8bG3D813mhDqZ1Dd
         f4ZmZmWQNQFj2Romhopdvmk+fMZdHYM4WmCKrM+Gi0PtFmgIG1Vyv+UFT6pspQosd3qD
         raI8szFUuGfxoNGHtlXsy+/Nr00grDWtO/LomC2iz4HEOvwZUmajBws3OnGMUaOxMJiZ
         bagQ==
X-Gm-Message-State: AFq9FYI3aojILRcsFGscWtVCx1Ut4cO0Mh9aaZI+F/lZqymkvyV5D8Oe
	aUH2tx92YX5Vq0RcfseEC4oyZmJZWo2MepqK+R5y/NKOHLefG3rUDbwnYP/kkTCpsE1CofjEtkT
	j6eYLYixpCcf3A9aK4VVZEUe2xN+BIj3jcGootSRHW9xNsINDb0F5k5e8kZHdMLMKoPEqQxHSx4
	1bMm/K7f0S5Q9yAb7GFTAPV/H3vvEyDKyQfIQ7/dw1obRaQ0eYUA==
X-Gm-Gg: AYBFou0zH4yOn24W2+iVqQwNDlZf1KuKGDxYimV6eMiBguglVR4F651Bs9O9JCODm7w
	iSdQsew9U0gj15Wwmk7WKnNP1eTyJYnKtuNKDquxok8MafnGiatHqW1vBtjj06WaKFXzQNZBMJt
	QY+kCLUAzzk0vMVrYb2QYEtedR678Em9B4ir2TIzmGWIXRQJqeswEdaFFYA1YYAkOn9mkWKHPCA
	9TRDJ6aHDjxZ4PlRA/I3XEtmw3dG5btQPajyl9OhNjbJ0MWNp4AInGLQwzBMh6eLXdJLTUYKa/3
	RacNVUZtwEYuOvl3J1p/zZF444KV7h6XSOu6Vzmdc7pciKYjAvgFycpCpPTMmP+aKzql+aGBT4Y
	3zptotw20NCA8MXBn+v+t2B4iMmkp+RsXFlmfOzCc/H8g9xGtvfA8g8/CGt5FW35S+TWBcKKxDl
	8Tt2ppPC8aQ4qCZYPZ7Sa0RiOjG1cqKOsSy/a4+WNAzIV1HQpDj1NPe39Sr0BtVassomIiaCD5o
	JJPfhxB6aTgv/TsNM8w0e4CDVZqa5iNXZ/x1dIffj8Nhv2oezOYSC2q8C9bP5Krkoa9HoDK4KTa
	y+4I8AtkFayalq0oVmheYKsP8KlLQUceW5W+LnjXONay6THSfbWdh977GLqh/LV8XFEiCEI=
X-Received: by 2002:a05:693c:8959:10b0:35b:da8b:f88c with SMTP id 5a478bee46e88-35bda8c2195mr10444298eec.41.1792015245096;
        Wed, 14 Oct 2026 15:00:45 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b19c6c7b4sm30236633eec.24.2026.10.14.15.00.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Oct 2026 15:00:43 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v7 4/5] scsi: core: Add device reprobe support to scsi_rescan_device()
Date: Wed, 14 Oct 2026 15:00:13 -0700
Message-ID: <20261014220014.94330-5-brian@purestorage.com>
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

Update INQUIRY data on rescan and call device_reprobe() if PQ or type
changed. Critical for ALUA unavailable state handling (SPC-4 5.15.2.4.4).

If the INQUIRY data cannot be refreshed (allocation failure, or the
device does not answer INQUIRY), the failure is logged and the rescan
continues as before with the existing data, so the VPD pages and the
device handler and upper-level driver rescan methods are still updated.

The device lock is dropped around device_reprobe(), which takes it
itself. sdev remains valid in that window because callers hold a
reference; scsi_evt_thread() is covered by the cancel_work_sync() in
scsi_device_dev_release(). Taking an extra reference here instead would
be wrong: dropping the last reference from the event work would run the
release function, and its cancel_work_sync(), from that same work.

scsi_probe_lun() is now called for live devices, so:
- Return the INQUIRY length instead of storing it in sdev->inquiry_len.
  scsi_update_inquiry_data() stores it under inquiry_mutex together
  with the data, so sysfs never pairs a new length with old data.
- Only write lun_in_cdb and the target's scsi_level when they change,
  instead of clearing lun_in_cdb and then setting it again.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 119 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 104 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 93a8719fcf26..2c848265c9b9 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -639,9 +639,12 @@ EXPORT_SYMBOL(scsi_sanitize_inquiry_string);
  * Description:
  *     Probe the lun associated with @req using a standard SCSI INQUIRY;
  *
- *     If the INQUIRY is successful, zero is returned and the
- *     INQUIRY data is in @inq_result; the scsi_level and INQUIRY length
- *     are copied to the scsi_device any flags value is stored in *@bflags.
+ *     If the INQUIRY is successful, the number of valid bytes of INQUIRY
+ *     data (at least 36) is returned, the INQUIRY data is in @inq_result
+ *     and any flags value is stored in *@bflags. The INQUIRY length is not
+ *     stored in @sdev: this function is also called for live devices, and
+ *     scsi_update_inquiry_data() updates it together with the data.
+ *     A negative errno is returned on failure.
  **/
 static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			  int result_len, blist_flags_t *bflags)
@@ -650,7 +653,9 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result, resid;
+	int inquiry_len;
 	char scsi_level;
+	bool lun_in_cdb;
 	struct scsi_failure failure_defs[] = {
 		/*
 		 * not-ready to ready transition or power-on, reset, continue.
@@ -798,7 +803,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		return -EIO;
 
 	/* Don't report any more data than the device says is valid */
-	sdev->inquiry_len = min(try_inquiry_len, response_len);
+	inquiry_len = min(try_inquiry_len, response_len);
 
 	/*
 	 * XXX Abort if the response length is less than 36? If less than
@@ -815,14 +820,14 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * and displaying garbage for the Vendor, Product, or Revision
 	 * strings.
 	 */
-	if (sdev->inquiry_len < 36) {
+	if (inquiry_len < 36) {
 		if (!sdev->host->short_inquiry) {
 			shost_printk(KERN_INFO, sdev->host,
 				    "scsi scan: INQUIRY result too short (%d),"
-				    " using 36\n", sdev->inquiry_len);
+				    " using 36\n", inquiry_len);
 			sdev->host->short_inquiry = 1;
 		}
-		sdev->inquiry_len = 36;
+		inquiry_len = 36;
 	}
 
 	/*
@@ -850,19 +855,25 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (scsi_level >= 2 ||
 	    (scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
 		scsi_level++;
-	sdev->sdev_target->scsi_level = scsi_level;
+	if (sdev->sdev_target->scsi_level != scsi_level)
+		sdev->sdev_target->scsi_level = scsi_level;
 
 	/*
 	 * If SCSI-2 or lower, and if the transport requires it,
 	 * store the LUN value in CDB[1].
 	 */
-	sdev->lun_in_cdb = 0;
-	if (scsi_level <= SCSI_2 &&
-	    scsi_level != SCSI_UNKNOWN &&
-	    !sdev->host->no_scsi2_lun_in_cdb)
-		sdev->lun_in_cdb = 1;
+	lun_in_cdb = scsi_level <= SCSI_2 &&
+		     scsi_level != SCSI_UNKNOWN &&
+		     !sdev->host->no_scsi2_lun_in_cdb;
+	/*
+	 * scsi_rescan_device() calls this function for a live device, so
+	 * only write lun_in_cdb if it changes. Clearing it first and then
+	 * setting it again could expose a wrong value to the I/O path.
+	 */
+	if (sdev->lun_in_cdb != lun_in_cdb)
+		sdev->lun_in_cdb = lun_in_cdb;
 
-	return 0;
+	return inquiry_len;
 }
 
 /**
@@ -1131,6 +1142,7 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
 	unsigned char *result;
 	blist_flags_t bflags;
 	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
+	int ret;
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1169,8 +1181,10 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
 	if (!result)
 		goto out_free_sdev;
 
-	if (scsi_probe_lun(sdev, result, result_len, &bflags))
+	ret = scsi_probe_lun(sdev, result, result_len, &bflags);
+	if (ret < 0)
 		goto out_free_result;
+	sdev->inquiry_len = ret;
 
 	if (bflagsp)
 		*bflagsp = bflags;
@@ -1658,9 +1672,54 @@ int scsi_resume_device(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(scsi_resume_device);
 
+/**
+ * scsi_refresh_inquiry - Fetch fresh standard INQUIRY data for a device
+ * @sdev: The SCSI device to refresh
+ *
+ * Failures are logged and otherwise ignored, so that the caller carries on
+ * with the rest of the rescan using the INQUIRY data it already has.
+ *
+ * Returns true if the peripheral qualifier or device type changed and the
+ * device needs to be reprobed.
+ */
+static bool scsi_refresh_inquiry(struct scsi_device *sdev)
+{
+	unsigned char *inq_result;
+	blist_flags_t bflags;
+	int ret = -ENOMEM;
+
+	inq_result = kmalloc(256, GFP_KERNEL);
+	if (inq_result) {
+		ret = scsi_probe_lun(sdev, inq_result, 256, &bflags);
+		if (ret >= 0)
+			ret = scsi_update_inquiry_data(sdev, inq_result, ret);
+		kfree(inq_result);
+	}
+
+	if (ret < 0) {
+		sdev_printk(KERN_WARNING, sdev,
+			    "failed to refresh INQUIRY data: %d\n", ret);
+		return false;
+	}
+
+	return ret == SCSI_INQ_REPROBE_NEEDED;
+}
+
+/**
+ * scsi_rescan_device - Rescan a SCSI device
+ * @sdev: The SCSI device to rescan
+ *
+ * Refreshes the INQUIRY data and VPD pages of @sdev and lets the device
+ * handler and the upper-level driver update their view of the device. If
+ * the peripheral qualifier or device type changed, the device is reprobed
+ * so that the right upper-level driver, if any, is bound to it.
+ *
+ * The caller must hold a reference to @sdev.
+ */
 int scsi_rescan_device(struct scsi_device *sdev)
 {
 	struct device *dev = &sdev->sdev_gendev;
+	bool need_reprobe;
 	int ret = 0;
 
 	device_lock(dev);
@@ -1677,12 +1736,42 @@ int scsi_rescan_device(struct scsi_device *sdev)
 		goto unlock;
 	}
 
+	need_reprobe = scsi_refresh_inquiry(sdev);
+
 	scsi_attach_vpd(sdev);
 	scsi_cdl_check(sdev);
 
 	if (sdev->handler && sdev->handler->rescan)
 		sdev->handler->rescan(sdev);
 
+	if (need_reprobe) {
+		/*
+		 * The peripheral qualifier or device type changed, so the
+		 * driver binding has to be re-evaluated. device_reprobe()
+		 * takes the device lock itself. sdev stays valid while the
+		 * lock is dropped because the caller holds a reference;
+		 * scsi_evt_thread() is covered by the cancel_work_sync() in
+		 * scsi_device_dev_release().
+		 */
+		device_unlock(dev);
+		ret = device_reprobe(dev);
+		device_lock(dev);
+
+		if (sdev->sdev_state == SDEV_CANCEL ||
+		    sdev->sdev_state == SDEV_DEL) {
+			ret = -ENODEV;
+		} else if (ret < 0) {
+			if (scsi_device_set_state(sdev, SDEV_OFFLINE) == 0)
+				sdev_printk(KERN_WARNING, sdev,
+					    "device reprobe failed (%d), marked offline\n",
+					    ret);
+			else
+				sdev_printk(KERN_WARNING, sdev,
+					    "device reprobe failed (%d)\n", ret);
+		}
+		goto unlock;
+	}
+
 	if (dev->driver && try_module_get(dev->driver->owner)) {
 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
 
-- 
2.56.0

