Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E645E1DDC1B
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 23:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781825735; cv=none; b=AuYnMDVpdYe9tDpq1pITcNpHvBC5ajH+yEY1gR3UBIhIId2YkSARiBb2e7UbiovtXWPBnFvDEd4EaRvGOWgxkQ4Ls4F7CgaYEzoaYXKpyvAOllEWeFftDqa5JsMwyc/yZdOX87NxUTe/BxBd6mm0/PsDvHs0Wlg+UtiHJWt9y/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781825735; c=relaxed/simple;
	bh=knJY7Zi7rEbU01BmzUbR5gVrNr2u7SosQfFZmEDVbys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3Dl3y8SHLP8X5eg3z37Y+dAvg99UVMykgCavkwQiu1KGnk4QXInuAVQIDt/eRFQkjRHnphXyvGwlWlzT2n9hklTJ/4gnDOu+W5RMvIfWcx+J/I/vpmgc9ER10UpRZB6BcJSvlN0X5GP2svfkZzghOfYSZUVh7uRYdEpBFzng9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Rr/3EU+q; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Rr/3EU+q"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-464192ab2e1so879297f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2026 16:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781825732; x=1782430532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XGNWNQwLpX5GgWlONCmIrkHieLnGKW5SRazH/8kTYEU=;
        b=Rr/3EU+qmU1AvLnDpg6KFArzk+0nja53psrq3f2iPpV25KjxdTCe9w753Tq7k40Ffy
         YuApuifMwywB2kPdDuW3sK7Pjh0Gg9g6e2mDbQb6h0zVltynwmG/GZURHy9yJwqKnLUL
         slBLkmfox6heRhEWRGJCVJJH3PNV+ZVC8BW0cQdZ/SRBfl0DplbUjNLI4c1ZfjQqsQFD
         gAFOGtlPXKTFuoceRSqIhyYraJMXlG6U9WT7k6CmpQAMUYr078iFSyDOqpNb9lh/R0gI
         UwEdvdtUF2sFv7zNUFni6s2JSUp9+KfakzFEJdCJ6Sv8N/ecvo+ri4Lg/2mLTLiRV2pB
         4yng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781825732; x=1782430532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XGNWNQwLpX5GgWlONCmIrkHieLnGKW5SRazH/8kTYEU=;
        b=Bcxt2mzNAWaYJsY1iqrLG8mLXjEFuMNtIV2bQhspFwvXwd4MIsq/OdVGY4GgKZA6nO
         XGyZrGgI7HTamB2kW3UY9+5w7OpKrk5KM+p3iW9P1aMsoIoOpZWtT04rxr9h7KT8+s6P
         +zrRLJv4/HqaVrnmE3SVNE6SDDz0MeE3aK+OLgUMSBYsecZ29cbdSwGeniE2fzLQwx4L
         SbiJvEsCJ8KfksrUuFigcNa5BLb6qpqts92hC7RFK6ppJjBflOZaCa1LfSmCnKmXRO0i
         5ulqMGMzhWMn/zQA7tepZsoRfRP+vwEHnxfhBM8cGIxwzpXglWkQkbNH77NCJ1GGPp9T
         wlOg==
X-Gm-Message-State: AOJu0Yx73PkAN3xyEfNAJViro+JZXLJCTuII4xLIkxZy1NqbYJxfCWux
	mdJ4tNJ05O0xjxV65BiRgC1EgcZt84zxhRqBCYDCWmEetrTpwJk1k1h8hHU5uXCU3gLdJ/K5u0q
	4JaK1ZrBU4JK7zvs9Ju+RqsjaSALwlDzBjwQ2ACIIML0qN4vRAp2pve92WQrpII0bVgYx40exfR
	9SSquNK+D5X8OaZU9DZXC5QsL0X97luMCnW3n9TQn8c5M1RC/Rqw==
X-Gm-Gg: AfdE7cntBx0t/o81hgp7e1WN0WZok8vwe1bDCdVJdTzP0QGdMEp3OAtHV204GacXWQa
	/qgIvSsvlWT2lUg8voktNaAcn+Pw5/5TSIJJA7+kzWExp88n05Xgqmndr8HqzvMCBN3YlubvDT8
	HnMZoIS+rEzKyC76xLol7x9tYbdbZWkK6TphBjp5iuNkUtZGSctp+ipdSxVpfnPzUtSwgw5JZD9
	8Nhe6hOV4UvogNXE8D3G6QPhmFqi0Lz6TAtzUdXA4JPHV0gux3AbWugb2SGs2Dcst3ZKDx8pLgi
	bK0A3OxbFeWysuvyGPW6jRnHB6OUrOZdwtiALrwDyEw+KUMT/tO8+vmDmGLdaxJXRWaXqsyId93
	vc+dUjiZYYHIayijD5u8GBSxMzNSYWkhlMDv3MbDzYJbCs/okQ+LQRe7Mjg3mQWIUxdS80no3xL
	wcnF+EBDItrapQ24e90+Dz2of+eVFAAwTD1qR2wRTfmYzarUMlRxIvJl+IZkRF381pC3aZ5Hlg9
	F7Sj+PNmwSLxZ/ARf9lIHcWTUJ6XsemBqMnFtltr3bUYaBRSTGASCTAoq7t99GckZFNKvy7cmYU
	GhFDAJtuPwDx
X-Received: by 2002:a5d:4d09:0:b0:463:2220:4ff0 with SMTP id ffacd0b85a97d-46501d44f47mr2120312f8f.27.1781825732189;
        Thu, 18 Jun 2026 16:35:32 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650b67a34asm3492468f8f.22.2026.06.18.16.35.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Jun 2026 16:35:31 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	hare@suse.de,
	bvanassche@acm.org,
	krishna.kant@purestorage.com
Subject: [PATCH v5 3/5] scsi: core: Refactor scsi_add_lun() to use scsi_update_inquiry_data()
Date: Thu, 18 Jun 2026 16:35:02 -0700
Message-ID: <20260618233508.97960-4-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260618233508.97960-1-brian@purestorage.com>
References: <20260618233508.97960-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
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
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 127 +++++++++------------------------------
 1 file changed, 29 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 7e60e3a4bca6..58c3818eefc2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -650,6 +650,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	int first_inquiry_len, try_inquiry_len, next_inquiry_len;
 	int response_len = 0;
 	int pass, count, result, resid;
+	char scsi_level;
 	struct scsi_failure failure_defs[] = {
 		/*
 		 * not-ready to ready transition [asc/ascq=0x28/0x0] or
@@ -839,23 +840,26 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
 
@@ -884,17 +888,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
@@ -903,54 +896,26 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
@@ -961,46 +926,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
2.54.0

