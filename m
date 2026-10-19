Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792448068;
	b=wFAnvNlR4NJj3GB0g0ngCwgq9+YCJl5PoeqMJoJ7xTLN0QvXDCDWsOCda58CwCRcf7iE
	 QXDAh0E9a1hPA4DRE6h8BWmQH9j/wuU5y4xlK7OSeuPPlcZh99MOIq2bWWo4HJfH4y/jQ
	 Hxm99YJHKjDVu5BqhYbnxiUu2OEqwDdOoiFKqEMO36okt3w/3W2c8q/5nxNlCl++J3+3x
	 zru1BzoKRa0RqI/98ApdkDw7Ii4FRYrxIyLusKIrcaDDpzX2K5V+knSMBriapsHy95xmy
	 A7We4/kJRHdk94rOFYREdvbBwDatlBCCCZGBePOKrbsnCrHLgRPztzceqMYjXO86vJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448068;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=b80+7UVZmfmMyhXjJUXtwOXP0RRbcxOLFBVG/AHmKqI=;
	b=LpW24Oj8fZBTtQqXEx4mTv16UGYHYlZQjM3a9QgPt8BSQwPQt0ST5ibEMA3bqnNCsheI
	 t82XJcQsPgqPphR298e2rb6f6/ul4pj6lJxj5bO/dy3LxtXO2HDTVGKCa5zQtkweLgSZO
	 DFEUKsRvSIlc4VDG55QI9iefkKGXYM7CQZ6Heya7w54eNtvMwpZ7eZzWj1RQ9W/hMsG5i
	 NJnL6IXmipAs44VRSVhzlKWTkk/T+BgCg3/EADkYijB64goPLOyGV7PWMfbwUXNuwTjQL
	 CNO//C8KPuYWfW6ZQZvhlSf4C11F/uJrcXLOqHtHbS2kd2/mQFB28CZ+hq1sJS5FCjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=cqWpxMzl;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326E0606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:14:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 326E0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=cqWpxMzl
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-18cdcfc05ffso1192539c88.1
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 15:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792448067; x=1793052867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b80+7UVZmfmMyhXjJUXtwOXP0RRbcxOLFBVG/AHmKqI=;
        b=cqWpxMzl7DexoqL6I59Bk3Bazg0yq2uhMg5me8IjVlCIQqZrQMLM5Cbk07mIutrcUN
         LcrLkBbwUe6t2r7579UXWd+KtgfnCp2tMtWkMGMNXYBun3/g+D7x1VCfuKaLslo6ph+X
         2iKJPf3CNw0DMb3ASBqgbUC3Jl0XfRHy8z8ElCl3mMT+QkY/z+ON1+AYjeRhYRDwysq9
         6AvCy0KT3MptZ5aSJlyT8nixMuQjAK0N+BjjPQwVQjc+rp5WRx+lJCzNN3QxFh2E8fc9
         IJC/wdRCqzUSC6DnHH2YGRk3Ok3ghfqeR6Kx0S195TWWC/uE9qO4xmSQHREti6ortgKR
         vSuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792448067; x=1793052867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b80+7UVZmfmMyhXjJUXtwOXP0RRbcxOLFBVG/AHmKqI=;
        b=iAo8LsyR8jxm3mvO7aKzDVLCpZV9B3kJnLfX1Qk6ztHi6KdD9bautaa464TRLyH3K1
         03zVafCn++wMJs9hsXFBKE2fRfwcq53Dsagusyrx5tbOgdSMJp1YjYFYVj4WgdeI9eX5
         MBT+vEnUoAViowaupqA10PKOfjLsYYwDESANQJNPyw1vJZy1AeO/N2Iuo/z0d8aPrj8y
         zNB78UqkI4hlNyP+KHO7PHayMkFGCaZfYBk63mSo4Bwb/4RAJIFr/SHfmrS8aI8Db89Y
         hQJIfhujb/UZjUqizPZ4038ucKW8LH4gJXD3Ht2aA0j+dD7IJixNszF031LhbZRUEvI/
         JnxA==
X-Gm-Message-State: AFq9FYKZvVVUEEDoOhM9qwrWb0hjDkgyVzyCvz6qp16h5a7UQw1T92sf
	vWD78LsLaT8Shx4Gq9MgMUlMYB+mljzTKFn8YPi0lDeAsMWUoLl6+apLfyZmUD1jv6X/u5VHdHW
	+26GVXVbTj9tAjKNn7IQC53DVzxSpoDU0uIv1TXgMWqJ4Nl555lG6PWmDk+/COJ+cfKrDnhuoTr
	VkWGhNtOfurvW5mSWOhk8CC7CwX9Ye8ebQXQxMvlUTkYPy64II2Q==
X-Gm-Gg: AYBFou2eU43FXkxZxzGPejERkKnnFSN3ffp+MqO+c40MoP0CHom29tJE0fTanM0TMWA
	W8uVTTM7ZfxZkHXphtornCNTQNy8UC1Gxy49eKyBfZ83RipuPk0opVX+442bcOR44ZLTmPxf9W+
	w0XQ/ExiQBvlUacW9Rs8P7lWPThtdDIHzqTX+3Mh05OGkXKq9vkkyeBO1MfdkDWX9Ygcl71c1VS
	L/8EAfy/llcJdBsuNTfwPN4zMuyexKA80XZymRnDmN74gRE86vXeVgJVqhjzAwSJbcgGQJZNy99
	TYReweuXR9ci69ecBqCbUOMkbLXkJj9UUWqUr1Gz3UGzNQSr9Yzx8j1DPrcreB8nR87MyTxjHn2
	vv456w6Yf9n7rbr+Fui2E0soW0rerAelP+fF7hvEuS8R901s+lVzqAS0f4hKPupP1rGg1HTrh1j
	tQu/upj7cvrGiWld7Cyksh1mBOjA7pJa68H1/frtoGJJxvYoo31+8Vw2dNjEzU64/qQM0RiGUmg
	RgV9iC7GPx2VmiFLMPqTaPl3ygY9kKZqyyHVPWIfb752NSz8iZyAbyokkyyZNKbGyLNoIoAUPs7
	BLbf8gSe7bFHtMiDiB87638NyHnvBcInk2gzxHJSFmVCJGUZdbdbbcxVAN+0MWgPcZkkbFI=
X-Received: by 2002:a05:701b:4194:10b0:18c:7492:5b4c with SMTP id a92af1059eb24-18c74925b80mr2581435c88.17.1792448066675;
        Mon, 19 Oct 2026 15:14:26 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-18319d3b880sm29429839c88.10.2026.10.19.15.14.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Oct 2026 15:14:26 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v8 4/5] scsi: core: Add device reprobe support to scsi_rescan_device()
Date: Mon, 19 Oct 2026 15:14:03 -0700
Message-ID: <20261019221405.40614-5-brian@purestorage.com>
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

If device_reprobe() fails, the device is set offline under state_mutex,
like every other SCSI core state change, so a concurrent
__scsi_remove_device() cannot have its SDEV_CANCEL or SDEV_DEL state
overwritten with SDEV_OFFLINE.

scsi_probe_lun() is now called for live devices, so:
- Return the INQUIRY length instead of storing it in sdev->inquiry_len.
  scsi_update_inquiry_data() stores it under inquiry_mutex together
  with the data, so sysfs never pairs a new length with old data.
- Add a rescan argument. On a rescan, leave the host's short_inquiry
  flag, the target's scsi_level and lun_in_cdb alone. short_inquiry
  shares a word with runtime host state such as tmf_in_progress, and
  lun_in_cdb shares one with cdl_enable, which sysfs writes without
  the device lock, so these are only written when a device is first
  probed.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 140 +++++++++++++++++++++++++++++++++------
 1 file changed, 119 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 93a8719fcf26..87fd3ba5c3cc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -635,21 +635,31 @@ EXPORT_SYMBOL(scsi_sanitize_inquiry_string);
  * @inq_result:	area to store the INQUIRY result
  * @result_len: len of inq_result
  * @bflags:	store any bflags found here
+ * @rescan:	@sdev is a live device whose INQUIRY data is being refreshed
  *
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
+ *
+ *     When @rescan is true, the host's short_inquiry flag, the target's
+ *     scsi_level and lun_in_cdb are left alone. They are bitfields or
+ *     share a word with bitfields that are written at runtime without a
+ *     common lock, so they are only set when a device is first probed.
  **/
 static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
-			  int result_len, blist_flags_t *bflags)
+			  int result_len, blist_flags_t *bflags, bool rescan)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result, resid;
+	int inquiry_len;
 	char scsi_level;
 	struct scsi_failure failure_defs[] = {
 		/*
@@ -798,7 +808,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		return -EIO;
 
 	/* Don't report any more data than the device says is valid */
-	sdev->inquiry_len = min(try_inquiry_len, response_len);
+	inquiry_len = min(try_inquiry_len, response_len);
 
 	/*
 	 * XXX Abort if the response length is less than 36? If less than
@@ -815,14 +825,14 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * and displaying garbage for the Vendor, Product, or Revision
 	 * strings.
 	 */
-	if (sdev->inquiry_len < 36) {
-		if (!sdev->host->short_inquiry) {
+	if (inquiry_len < 36) {
+		if (!rescan && !sdev->host->short_inquiry) {
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
@@ -850,19 +860,22 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (scsi_level >= 2 ||
 	    (scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
 		scsi_level++;
-	sdev->sdev_target->scsi_level = scsi_level;
 
-	/*
-	 * If SCSI-2 or lower, and if the transport requires it,
-	 * store the LUN value in CDB[1].
-	 */
-	sdev->lun_in_cdb = 0;
-	if (scsi_level <= SCSI_2 &&
-	    scsi_level != SCSI_UNKNOWN &&
-	    !sdev->host->no_scsi2_lun_in_cdb)
-		sdev->lun_in_cdb = 1;
+	if (!rescan) {
+		sdev->sdev_target->scsi_level = scsi_level;
 
-	return 0;
+		/*
+		 * If SCSI-2 or lower, and if the transport requires it,
+		 * store the LUN value in CDB[1].
+		 */
+		sdev->lun_in_cdb = 0;
+		if (scsi_level <= SCSI_2 &&
+		    scsi_level != SCSI_UNKNOWN &&
+		    !sdev->host->no_scsi2_lun_in_cdb)
+			sdev->lun_in_cdb = 1;
+	}
+
+	return inquiry_len;
 }
 
 /**
@@ -1131,6 +1144,7 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
 	unsigned char *result;
 	blist_flags_t bflags;
 	int res = SCSI_SCAN_NO_RESPONSE, result_len = 256;
+	int ret;
 
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1169,8 +1183,10 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
 	if (!result)
 		goto out_free_sdev;
 
-	if (scsi_probe_lun(sdev, result, result_len, &bflags))
+	ret = scsi_probe_lun(sdev, result, result_len, &bflags, false);
+	if (ret < 0)
 		goto out_free_result;
+	sdev->inquiry_len = ret;
 
 	if (bflagsp)
 		*bflagsp = bflags;
@@ -1658,9 +1674,54 @@ int scsi_resume_device(struct scsi_device *sdev)
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
+		ret = scsi_probe_lun(sdev, inq_result, 256, &bflags, true);
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
@@ -1677,12 +1738,49 @@ int scsi_rescan_device(struct scsi_device *sdev)
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
+		/*
+		 * state_mutex serializes against __scsi_remove_device(), so
+		 * a device that is being removed cannot be moved from
+		 * SDEV_CANCEL or SDEV_DEL to SDEV_OFFLINE.
+		 */
+		mutex_lock(&sdev->state_mutex);
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
+		mutex_unlock(&sdev->state_mutex);
+		goto unlock;
+	}
+
 	if (dev->driver && try_module_get(dev->driver->owner)) {
 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
 
-- 
2.56.0

