Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3E94DA9C3
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 21:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791839159; cv=none; b=i6vlyG/vlLeRz9s5eI4EtxmwbYucgLnhm3UyzFq69d9FznVtzxxoOsnla9qq88duwo95O4854ZuPY0j0oCAvp0P8pf1SOITxGtrmHTOL437oIQ5zNHGENMWQv8zJQc7n8jKvSfU39EFZqrR2FSQ4uxZPFlXCvHXQPcS0b8JW07Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791839159; c=relaxed/simple;
	bh=WDfd1k0mjTY4b+uxHtNIew2i9I8yJ1xCzT07DkO/tDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yvoq/10xLdyBYR2vt/yT29jPNpPpjsnaaVm/BDm8CiqQ3P4ZJS3OKt9Ji6KeijcyuZPWyQdul5isQrjZmc8owwr/GjGiMf+CV/o0avuFNZLTRpyj1Vv1X83ePCsAa/j9sMXb0KihmSTUytyDgCAzx+qvxDskp3JIzjkvpDSjphA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ThTkKvGN; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ThTkKvGN"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-35a31bb9fb6so535940eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 14:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1791839157; x=1792443957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dGJ1gotdaXvisOkMofI2iowgY7bztBWESe4SZ6bgRkQ=;
        b=ThTkKvGNe/wsKWP5mndHVGD0eqUgjWhWs4cU9m4IliGDbb6194GJQ6BTzJXtI4plNl
         DDxOiqC6qDKKFu7znHVkPiCiXLn/2vkJxldCKFHjkseiz++DNKuCgX9+XFfAG6TDme/S
         TxhW0nXwk/eprn1MgYI3x6aWUg0h1mL96w7/fPhWgSP0xcZFLIBgt735DChFmaBlWQeG
         RH4RymmV06uw7Rnk1jlqn+gLBVE+UFxVzUTZl+ZkVYKE3JSPSM7mPLpLTEvFdLIXebJy
         DiooG1N7cf0Tz17QqXcI/UlLryKJHJGJjOkikc7GWVUuraOztOMdORZsEokSiLTJlTZS
         iYiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791839157; x=1792443957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dGJ1gotdaXvisOkMofI2iowgY7bztBWESe4SZ6bgRkQ=;
        b=lZButs7jb6WrDB1lvHN8nP/UfJDWP874G6DOtHgn5T92VNcbtf0pRUgpdh2HyfWjbK
         H9Z49+2BIq5ImbPShTWyJ/3qKQf1J7NsU/39fG79XYXgtBvTg+sWlt1b78IUrDtRT8zT
         0ToRhzgE6g1mLsNd4M+oMnKMIK67eJMVSgQ9bQzoSHg0ZQd3LlVS9eAda6bzN5rrMWUz
         QAKF5C1Zh4kfAK0JJXGXZOpdtnbfuLx4ToALBziK9SgZ1cEZf2cBpxe3Sl8NxZSVlmnT
         AFHnwGfOM6B572L7+V5sDfXKlDAcSBwSN3fWhlMqDI7eRxc4foWuCUXN80pE2epFvmOg
         HlYg==
X-Gm-Message-State: AFq9FYKeqqtWsvKVz1CDl6Rxe3FzbJvsQfB8Om8T2nimFdv3oZTZc411
	4N0XmfmLkIZywok/57wgmyFQVonq8b1E+4Vz4ArAwVgmndv5sfWKo24eiG/Xa8Dvu9F31bMQwmy
	WSs032RP8SnhxX/poEBo1U4FMbAHjTYnvMwPMh/E5pdBhwSsQMPO7L1fGf11BB/n2viTMAqq4F2
	uciMgA+MVM0iUFsu7I9o2QUTJyHsj3qQAkWgyavl6zuXE9wUSh5g==
X-Gm-Gg: AYBFou1oaWsvIZe4jSVeHpVFJHKbUpuoRITefkY5hZ2ZDnRr6Q+xKI+IwmlUvCmvMg6
	zllS+aVgMaKLutkn1UdwasBiX6TsK+XS7wIdC/5VmNBhAHqchccJdQ8wZfZQkivi0xqj9ygHX6w
	Y7W1Nbzst/1G/16TX37MDZCv2R5OlQi/sd1TiJmI38J5KKSRphdSxtFc8163dJ90rKnRZ1ck7bu
	3Tyna63kWuILnBzIItKRwYSpG7rvXVHQIoQlV8g7DfgjLQNTqILFAP01VLomGdODisLrbzji0Om
	H55lcur89hUsDHfwJueBzQX8rKVox+j23siwiVFb/ttRo17zYP9SZcP1MSibRjRRj7bBgCLPd4O
	hOWSOJUroGAh30kuMnskc1hH+8N8UkqLti2FyodILTcZSD3OD2jcsVzXrZJBk4OpWwoIc5FOdow
	E7vxAl3LGkaatEL0zWPKpmlgKPMMHfzfZNzcH/pii7TXbigjOeeHh/EPT+4OYQMqVRXIbry0FVL
	UzAjAbYIoGFeOFMWKvUK3LWPdHADJ7xBRpuKhq30HfrBsjvvimvMMf/GIVkxaA+uWsIDYxwxg5v
	YUFs9cToZQc0zH0KJuklYVcn6qLQi/idDD6NhrUkaKCHHjRFea/+9JC6Aoj01ZFG5TDRrQ==
X-Received: by 2002:a05:7300:fa15:b0:35b:9851:a896 with SMTP id 5a478bee46e88-35b9851ab64mr2541200eec.10.1791839156683;
        Mon, 12 Oct 2026 14:05:56 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.201.68])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537cb2fd33sm35528777eec.28.2026.10.12.14.05.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 14:05:56 -0700 (PDT)
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
Subject: [PATCH v6 3/5] scsi: core: Refactor scsi_add_lun() to use scsi_update_inquiry_data()
Date: Mon, 12 Oct 2026 14:05:04 -0700
Message-ID: <20261012210511.16061-4-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012210511.16061-1-brian@purestorage.com>
References: <20261012210511.16061-1-brian@purestorage.com>
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
2.55.0

