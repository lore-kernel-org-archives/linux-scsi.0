Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792448066;
	b=Wcnqsj2LVIZ2Q1ZYF4FyI5dpQbUbB9M3TePIuGyZiTJHZ9JGx1T8hdgn32LhOTRKUZ7q
	 Ghkz0zyeQwQWeRtn18XCMzisvQ76TS+pr1wOBUD5xwvArWSkWldd6B+CK9gqsDBCwvr+a
	 nWB0K2FpVyN4dn1IKoIKw93OkrhI2g5C30TqG9uKR1wb2jXHQJI1QjEegJHctspOWR5kZ
	 AVzzMzpDDSAgM8DwrSzcWBmv84+Jp1lW0dKxnSjbkXnQGn1mdv1S1qkwRwoWJzHDgpDk/
	 BXvc/ZL2D4zgbUZfi11Pyj2XjDBUNGL0W1u7lRT5EuaY3bwbNL+sDIGKUxYqTsVSbpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448066;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=xn+xxisLM7m+etTGtO/GMeysQITTKpDcPtqyK+4T7J8=;
	b=Qwo37nb5VEvcbcK+F1ypdYZc08UgGVS6WugiyBx2kqUTn5i0mJw2UIdQs5DzYHn/lQMf
	 MdfCQ7+XoRda1AwxAxSZjuwlp5RHpSZRwH/dQgrIOBICwdjPD4uDov+7pfJCkycRyQ/GR
	 FHCnQRTOaCxAY7XWx5X34If6pGDVUrY/A1ej0MF8CRXRCzOBWND+y+HqOP2ggrozEBM5z
	 1Z7oXnIP755hfugptnUYpDR8xokBMoiYjvwLawOM8JMfv/lGl3I3GG203oc+W6FhCP5Mw
	 3wGgr38Q3h/gP4NIXWWw4WM4X/1dW1zn/9/rvyBuZX8Oz0TN/uUqYCKJOo/c0l2aJuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=Jkl3hrw8;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334D1606A319
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:14:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 334D1606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=Jkl3hrw8
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3282db206d3so4389666eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 15:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792448065; x=1793052865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xn+xxisLM7m+etTGtO/GMeysQITTKpDcPtqyK+4T7J8=;
        b=Jkl3hrw8DmmSSBq2yOdZKTe6ll8LtaCvTIGUOoXVez8AngDN6SS5nWysUR6SRBE47Q
         KuiO1twjXf/3PIfLgw0AaWp/2/1pX9fcEnyRCz9Zo6P2okWLJLP2tS0fY89yeIt/cC4C
         taMPXV6xEG3d9970Vekazm4xMjUFzYgTr5QJjeFihMTHuGZOW50blDHutAEomEV8eVKt
         OBFu0bw1JyWwYlmo5ZDiPYf1OBTsF95IPK6U+yNm1uXIMt0tULCzbpvXz6BOleVIEKlU
         9JOxiG8mJQPq9YV0+K4KOntC4baV44lgVOOY4cWuyWJGu76+YXa4NOKT0QQKdcgdqXzI
         IpvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792448065; x=1793052865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xn+xxisLM7m+etTGtO/GMeysQITTKpDcPtqyK+4T7J8=;
        b=1oqJeCXX2hlTCpNRATVcVcpzyjabyOzg1TeWFTwGPO9+4unM7Fi4vAbmjSky6ZJQyp
         gPMAAGZPozvG9fc82svn16HLJnaPWESE1xBXCg+UBWsmiTzXCiyPLjGg5/X/ELNH0x8e
         ESpmsiLrERyXkzGrh4K/Jb0YL5351ivIBhhcLUkTDnZWSjBuV7ZQef6fSgIHrkJ+Lk15
         bgoOXYt6gbj+L30uvYbS6UfEILvptp3BJPYqWZR+/vAHSQVLrSGL5Knb4lIvqVBzSail
         6qwLayl2xPIfBOf6KTlIUoq9jpVR6qOpnsUcp4Necu2o5E4UtYkyO+P3PTBFVIHyLjKZ
         1+TA==
X-Gm-Message-State: AFq9FYIFQRZhtqlH/ZCZLGzjyePEJCzPvYkBStiG1V4WKQZGhwe4/qCK
	UIL/xGgp7TUTxd7ZTq6PDthlfWS4DI6RHeZTh+2krqN2e8n2vG9zVq9ac2FN5MSgCXKFgltPUGq
	Mrtygnu4BfmVEVWkC50/n9SFwqePRp7a+czrlswdxTZjFAS11A0xjEfjpVL59BxkKuJ3+/ZMK3Z
	0l5IxUG5zT9eMwTtZbWEiOhLOIM/1gxSw+uW7R3xL7UYHUKYKiLQ==
X-Gm-Gg: AYBFou1yi58PZlpzdUgm60Pi5tcWkGgL9UDu8Z5gNnYV1F+PJ3AXzZWnszvCMI67zTB
	zW9qS09mTdv+kTzPjM2AcOg5DaMPiFOYu3gDoiYfhqmxLTvNVlAEHZ3O0tzdEfL5bY5kufli41z
	zwRuwdn+Ie7Otii0DyFcFKAsfvg61DUYduKks/k3vgi+vTe6/jXM9KY5cesOYaACRkDKkVgFriU
	/P62bUaP3hCxEQItVt6MWHicw4ezn9OUMLsIAKqOmaFSdw2HqLa6OH2hWwqu7/ccbjzLPe74WUi
	lGuye5mAdlzTtergetLu4j7hC56QMDoE2pVz+GsC0JJhzTetwIMbuOdgQ11i+7Z79YNo693CIqv
	EDTdCRmcdtZud26dfXHcQxMXFGSc+roDmpXSU2RGz7asRyEhDr5Bqjf0VywzioAZ1Dy2uECd3OA
	NKiOOGl0trO8BfLC0RQwfqN8NtRtWYtIFLTWT9r7QH98t5hUVBGM6anHG21IMqtByw+PVqMu/nu
	wL71woGFOuMY/zM4G+1rsUpf5mj2P33FbOs9LBFXkGWNnm97xZK+S7J2NOdy/KTGUyABBDyXJrh
	gJQDgHeQaTGKE2kUzJKKyUWwJHdi8jFHZuqwiC/gV2/3AGT1b+svK/a6oK2WokLb+HvT8Zs=
X-Received: by 2002:a05:701b:4549:10b0:166:b307:5855 with SMTP id a92af1059eb24-185075288e1mr12643664c88.0.1792448064795;
        Mon, 19 Oct 2026 15:14:24 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-18319d3b880sm29429839c88.10.2026.10.19.15.14.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Oct 2026 15:14:24 -0700 (PDT)
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
Subject: [PATCH v8 3/5] scsi: core: Refactor scsi_add_lun() to use scsi_update_inquiry_data()
Date: Mon, 19 Oct 2026 15:14:02 -0700
Message-ID: <20261019221405.40614-4-brian@purestorage.com>
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

Refactor scsi_add_lun() to use the new scsi_update_inquiry_data()
function instead of inline INQUIRY parsing code. This consolidates
INQUIRY data handling in one place and ensures consistent behavior
between initial device setup and device rescan operations.

The following fields are now set by scsi_update_inquiry_data():
- inquiry buffer, vendor, model, rev pointers
- type, removable, lockable
- inq_periph_qual
- soft_reset, ppr, wdtr, sdtr
- tagged_supported, simple_tags
- is_ata, allow_restart

Also update scsi_probe_lun() to compute scsi_level into a local
variable rather than writing directly to sdev->scsi_level.
scsi_update_inquiry_data() is now the authoritative setter of
sdev->scsi_level under inquiry_mutex; scsi_probe_lun() needs the
level early for lun_in_cdb and sdev_target->scsi_level before
scsi_update_inquiry_data() is called.

scsi_add_lun() is only ever called for freshly allocated sdev instances
where sdev->inquiry is NULL, so the redundant !sdev->inquiry guard is
dropped along with the now-unreachable sanity check that followed it.

This patch maintains identical behavior to the previous code.
scsi_add_lun() continues to handle the remaining BLIST flags and
device-specific setup that doesn't come directly from INQUIRY data.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 127 +++++++++------------------------------
 1 file changed, 29 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 8aae12fd38f3..93a8719fcf26 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -650,6 +650,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result, resid;
+	char scsi_level;
 	struct scsi_failure failure_defs[] = {
 		/*
 		 * not-ready to ready transition or power-on, reset, continue.
@@ -838,23 +839,26 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 */
 
 	/*
-	 * The scanning code needs to know the scsi_level, even if no
-	 * device is attached at LUN 0 (SCSI_SCAN_TARGET_PRESENT) so
-	 * non-zero LUNs can be scanned.
+	 * The scanning code needs to know the scsi_level before
+	 * scsi_update_inquiry_data() is called, both to set the target
+	 * scsi_level and to determine lun_in_cdb. Use a local variable
+	 * here; sdev->scsi_level is set later under inquiry_mutex in
+	 * scsi_update_inquiry_data() to avoid races with concurrent sysfs
+	 * readers.
 	 */
-	sdev->scsi_level = inq_result[2] & 0x0f;
-	if (sdev->scsi_level >= 2 ||
-	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
-		sdev->scsi_level++;
-	sdev->sdev_target->scsi_level = sdev->scsi_level;
+	scsi_level = inq_result[2] & 0x0f;
+	if (scsi_level >= 2 ||
+	    (scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
+		scsi_level++;
+	sdev->sdev_target->scsi_level = scsi_level;
 
 	/*
 	 * If SCSI-2 or lower, and if the transport requires it,
 	 * store the LUN value in CDB[1].
 	 */
 	sdev->lun_in_cdb = 0;
-	if (sdev->scsi_level <= SCSI_2 &&
-	    sdev->scsi_level != SCSI_UNKNOWN &&
+	if (scsi_level <= SCSI_2 &&
+	    scsi_level != SCSI_UNKNOWN &&
 	    !sdev->host->no_scsi2_lun_in_cdb)
 		sdev->lun_in_cdb = 1;
 
@@ -883,17 +887,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	struct queue_limits lim;
 	int ret;
 
-	/*
-	 * XXX do not save the inquiry, since it can change underneath us,
-	 * save just vendor/model/rev.
-	 *
-	 * Rather than save it and have an ioctl that retrieves the saved
-	 * value, have an ioctl that executes the same INQUIRY code used
-	 * in scsi_probe_lun, let user level programs doing INQUIRY
-	 * scanning run at their own risk, or supply a user level program
-	 * that can correctly scan.
-	 */
-
 	/*
 	 * Copy at least 36 bytes of INQUIRY data, so that we don't
 	 * dereference unallocated memory when accessing the Vendor,
@@ -902,54 +895,26 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
 
-	strscpy(sdev->vendor, sdev->inquiry + INQUIRY_VENDOR_OFFSET);
-	strscpy(sdev->model, sdev->inquiry + INQUIRY_MODEL_OFFSET);
 	/*
-	 * memcpy() instead of strscpy() because strscpy() would read past
-	 * the end of sdev->inquiry if its length is exactly 36 bytes.
+	 * scsi_probe_lun() already enforces a minimum of 36 bytes, so
+	 * sdev->inquiry_len is guaranteed >= 36 here.
 	 */
-	memcpy(sdev->rev, sdev->inquiry + INQUIRY_REVISION_OFFSET,
-	       INQUIRY_REVISION_LEN);
-	sdev->rev[INQUIRY_REVISION_LEN] = '\0';
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
-
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
+	if (scsi_update_inquiry_data(sdev, inq_result, sdev->inquiry_len) < 0)
+		return SCSI_SCAN_NO_RESPONSE;
 
-	}
+	/*
+	 * scsi_update_inquiry_data() has already set type, removable, lockable,
+	 * inq_periph_qual, scsi_level, inquiry_len, soft_reset, ppr, wdtr, sdtr,
+	 * tagged_supported, simple_tags, is_ata, and allow_restart from INQUIRY
+	 * data. Handle special cases that need the raw inq_result or additional
+	 * logic.
+	 */
 
 	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
 		/* RBC and MMC devices can return SCSI-3 compliance and yet
@@ -960,46 +925,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
-- 
2.56.0

