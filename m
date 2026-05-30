Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EFF4503B
	for <linux-scsi@vger.kernel.org>; Sat, 30 May 2026 00:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780100448; cv=none; b=iQFdUbj043dITj0J9Q1Z/0h/4CYSwM0O85mUysf2w3AdiIy3VNBXq0iq5fMBXH5ZP9ZznPiixBoOoqQRFsbQ61SodkQcnY6zJykgnzURSCndpOZNwUDXOlXridP5oSdS6OhEqwGqmVIMHd3H0Moy9eIvESXvsUh6PszbeK2PNP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780100448; c=relaxed/simple;
	bh=Q8NCRL3nJiYBSSN0/K7tygMNrM9VW1PDU24J2mcJTVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sN2ESWKV/dqFMqtscOTm7AnXUduAx+LLCz+pAQX07idARgYnBf3xv5IHy1C0Z1cktm7k1wStsW7VW5jlaijyqQyQLgN6g6Ta8BTpvgkM0+rVsPM+FRYUYnJSEU0lLzPR/4JEN1oVrimH7s3kO36LQbKL1wNxu6gk+YijMmaUzus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=L84JANEw; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="L84JANEw"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-135e7f4a295so6645595c88.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 May 2026 17:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1780100446; x=1780705246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yhM3LxdL5IBDQcnkvT6O49qQCv4i/evTwldDuFb5w7c=;
        b=L84JANEwLBHNRJUJKm1NW+LsNWkn6qRuoaZE0HYJM3apRNSEiG0oLpIh9j5Gn0XwkJ
         1dvvttaJvmZ/CtPKeggvJhcaQLX3xSN8HYH4MSPoofBlL2/Eb4iY8FwDPGDEEedEU/fq
         v9vAKZ6M5ZLphzCZ+Y+4m+elOXV7Ue+pteV/oF5lpPEViGw+3iJX8k02yk5gcrjc6AKZ
         0DzvvChFTnywvnok0wCbyAAoHIbMB9+N2AXFVu1apvFYCxegZ71xxVOTaEB/8wdDCXmq
         u22Jn+qk+nTp8mqTcILr79Eefk3AwEPd8Al9t4dsBCwyYpYLCQZFx+5ACf2ZsDnuNuqR
         AFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780100446; x=1780705246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yhM3LxdL5IBDQcnkvT6O49qQCv4i/evTwldDuFb5w7c=;
        b=e3obrmpbksUicU0jb6HeDL3h/4VcHBAW+TSmOl7MZV8uayWxIUzkDNexUhlaz/eicN
         xzgJ5SHiQ9yTlUQEMcpN6P/9SLBsSiiSV9W34cnXv2GFi9YdaOueyx70ik/MfTCGdlBc
         7jpiTa6m1UKCIDZ5fblezSZo4Hy7C5+cRn2e2k44dViyoJPxBPv4A2fkgBvKY5UALh1w
         UO7cegHEjV9+7iGDOT3+4rcBdTEF3fXKxGrgZsK08il3g28A4zwWoZMLxE5Szuz3Kk29
         snYZmmkcbxLBgld8HHSeLh1qLrIPuOt9+cM9Y1uetrthFmkBSDkYSLFSd0LX6RDwHVj2
         jjKw==
X-Gm-Message-State: AOJu0YxkJ8CeRurk3XEUrdVn0t1dEYqzWrGHLyNcsJ6mRO1JycswztSe
	Vc8cbTzTffQDJooZuQQhVr93iG1zjCteOPYL0BnCxoSGMhHNBaPeFJJbXL8Yl0IUID6iEi9SuwO
	yYI9mZ8L4vETh7WGbkusoNxbmZ6175vi3evr6+l/guhNcH6QnSLb/3lLmDYAT5CzwSc/575NxYy
	kYbZfcA+5si9ef7bgAvrlIAT1s6BJLH9cZj5Ghiy/2ggJaWw1E/A==
X-Gm-Gg: Acq92OFx9Bki7Jsn+hLyoft2qfCwxoHuCdCPoQMQ9vB2A9tHwfw7V6TsZvavmmjYjj6
	dejWRRTsR9sfd7xWtZtv35bHj4U3AAZ2UhSPqTWjCxFa2WnICmfFrf9/HfcSESxk5L/C2fraVsv
	LhPzYZgjZVoTIFvyjqNnDf9VVorY+2aa4ffgwNaSOczdCUwEKDqJn0SXeYYC5LCWu/ChQz6GnFU
	2NIDVzawyb/8UnFPneM4o+9+zC/Q+AaMiSkq2bVhAWh/twb77EzcwIeGNQTpjyTrfxEuDV0qcFw
	O7PGgOziUbY9VbqvvX8AfP9n60+giv6Y7kumNM2KztK6VSpV2vOlPn0dxgw3jsdeZBUxyt+S0l0
	Os2J3xpN2EK+4jZ3zsxvXzAPoLbJstVF+I4afP61x+7L7BuDY5Mt3dbvfzhu6iJkkvg9U+ZzE96
	Tepj76FaxZF9hZxLWlW3alxmJNjaRdMaa8utcTHpe+r9wB4O5PN4e6saBEDFAuIToEs4gKhFIMk
	Tt+epNd6EzG/ih7A+03ckfxJPcq31cZHArhefq2P9dL5VCRX/CtoVFj9AkT4gwDjHYn41gN49Hs
	4+UoWhzHacVf+cX1TLLwL/YUOsnoU29zPY8=
X-Received: by 2002:a05:7022:4384:b0:12c:aae:7b43 with SMTP id a92af1059eb24-137aeb9d821mr2201810c88.24.1780100445435;
        Fri, 29 May 2026 17:20:45 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.115])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-137b3d8f839sm2027163c88.15.2026.05.29.17.20.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 17:20:44 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	bvanassche@acm.org,
	hare@suse.de,
	Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v4 3/5] scsi: core: Refactor scsi_add_lun() to use scsi_update_inquiry_data()
Date: Fri, 29 May 2026 17:20:17 -0700
Message-ID: <20260530002019.47109-4-brian@purestorage.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260530002019.47109-1-brian@purestorage.com>
References: <20260429224939.77082-1-brian@purestorage.com>
 <20260530002019.47109-1-brian@purestorage.com>
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
 drivers/scsi/scsi_scan.c | 123 ++++++++-------------------------------
 1 file changed, 25 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 7e60e3a4bca6..62409217ff23 100644
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
@@ -903,54 +896,22 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
+	sdev->sdev_bflags = *bflags;
+
+	if (scsi_update_inquiry_data(sdev, inq_result, sdev->inquiry_len) < 0)
 		return SCSI_SCAN_NO_RESPONSE;
 
-	strscpy(sdev->vendor, sdev->inquiry + INQUIRY_VENDOR_OFFSET);
-	strscpy(sdev->model, sdev->inquiry + INQUIRY_MODEL_OFFSET);
 	/*
-	 * memcpy() instead of strscpy() because strscpy() would read past
-	 * the end of sdev->inquiry if its length is exactly 36 bytes.
+	 * scsi_update_inquiry_data() has already set type, removable, lockable,
+	 * inq_periph_qual, scsi_level, inquiry_len, soft_reset, ppr, wdtr, sdtr,
+	 * tagged_supported, simple_tags, is_ata, and allow_restart from INQUIRY
+	 * data. Handle special cases that need the raw inq_result or additional
+	 * logic.
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
-
-	}
 
 	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
 		/* RBC and MMC devices can return SCSI-3 compliance and yet
@@ -961,46 +922,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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

