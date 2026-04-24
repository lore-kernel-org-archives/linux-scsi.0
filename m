Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8D23469E7
	for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 21:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067629; cv=none; b=Ej0vjve2RyC5oqkwhuzD/TeW2tIuIw3EJgsW9oH7rfoeAt87ilH2/wpcVMRbYCEIdZVg5QfkQ+W3Pk0Fk3Bh7vvQw2dCQvIIC4tikR9Dw4qGeHRCYY1OM3HSEao2ZmwTKtsovMEci7MqXyrkUQFovuqi/B+w8E7aR1ZxzOVRJhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067629; c=relaxed/simple;
	bh=bp5Pz2euMwHfmcZyAyio2JMdIanZ8w7XbYntfObsJGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlOtUTD6vkpi88enU1lxopg5G+6OD8BPOtKGbixHcPcS5FkvmpebqnntMtgGobKjJiCqN9xnH66Av2Qg5500H7mpqBQGadelD7/P+63pK0Ug+hWx0miNauTV0DEo+7ABOMyC5Mt3FPz1PQImBMNBdoKG7Y2hI0CyBpdaj2e+VQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Fv+zfP4+; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Fv+zfP4+"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2c15849aa2cso11259388eec.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2026 14:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1777067627; x=1777672427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YTPVQKjCKxgFrvwlkkZhYwLII/Tfpv9gEc9L3knVAJs=;
        b=Fv+zfP4+U6DFUvj3auD/5qj5dXO+qAFtg7NEwXDjgd2Awg5rH+TrR+uHHgg5e629q0
         h4FpD9H7u5KMsPPEskLeykg0BUmyJ9OGWXxubj/sBczWOwRs3sAMm24pY0fUQGEbXWQ9
         nTXTJQMueqATSlPEqYOnOIq+6lWISOrL0BOVi9CqNTsDKq96F4VFzo7Qrv8Agfp30wLD
         rb18n1L7v/VyZ8nxsOIS7Mi83G62aD3V+5rpIK3ivsBXHkzmaVKReXrYSfcrJSykN4Ss
         xNMX6w4UHXxEshNOtWu/w2urz15FekVolopTbMZ59wKOCHMreSlttHGlllgUkbRF0IC1
         Qp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777067627; x=1777672427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YTPVQKjCKxgFrvwlkkZhYwLII/Tfpv9gEc9L3knVAJs=;
        b=sY/vvG/AZnDA4QxHLiFHxOCtqkNKogj04oHo8Gt4BQnv+0zQ+YQDlKpPGOUhs4LAsv
         WgNH0cLVPj7XLY0xu1R+x79yhGfxNlrch630wVafT09HOVkNi/Qd6x0PJ9SmHXDizhGe
         SsoMKRKZ4WXBYdCZcoKDsMHQpWuWhIUX6oy4o67QG4DU147vN8/FJYpRUPdOj/fr/fEr
         v4oiNYOod3rqNHvaLUEqMx6rAL1h35odAFZEMpGOzKr0cwwtCtkP0PZ7aJmG+QStz3hT
         944mAOesWsn1Z/j0nCO5z+3bfunJBh1q3S6b1BP4E17Qvnjed4XqUAjqtQ6oONV1jnwA
         Hmfg==
X-Forwarded-Encrypted: i=1; AFNElJ/92gY29L8fwBAB5ozCq10XT9jOG0znTUm4IbDeWXHt4RhSCHb6FdnleyrJQlh2rM/S9jdNkrRskAyn@vger.kernel.org
X-Gm-Message-State: AOJu0Yweyx8HmT+3je7cG/c8HRhEgBgpbdiui35r6utrAmZttxRnw1hw
	Qug3NbulBZyRJvfz/xidPWu4vChoE3a6vOwCcOyNnj2brKU9hi4nEgP6l6wVXmUVUig=
X-Gm-Gg: AeBDieuSpnF56aT3TjT4gMcB6ciF6wCMJID4l2pGTvde8KZcG0YW6vsfIG25iBIQsVO
	+Lu8tCX+R3Po+06a1p6lT3Dp1kJjfluSNgz6LrGxzeycWwyFvUGR5z/OtRxENvJ399SQiuJ+at9
	JoKRRuwWe2lR06mHt0YHeR761kqeM0dyjur+3niuPJpXKkF4fcsQXNB3uwHtrhsxvfCxNnUj1if
	D+RBFFg/rPpc8APJwl3GIKbDzbkH8DOL2Mbz1U1UEKn2bGJvnC2y4tthHz7b1dkik0Xpgs3cNyY
	4G+OPPafUqSIRlxRR4ql2LVeQw34NtnRCDLNhuyphowyZ4oRIbt/jko6OdrSVyN8/MzdU/daTzF
	kQhCTP+933Z/xzfbLdlFTLODIbPpANGAVdgb1syU/U9Nr31T0f/pyOzuWvChdEeeFJT0Yk8qr/E
	kmvTFpnbxI2iIGLx5h69upbsV22bdRfNj52RW7Iaw7ndNZNyFG9OjkDdHrjPXbGRojgKOPv+iQ3
	JSYJZi+7Iwom0gVyrKCWJr/Apn2QcvM6W7nDZKgi8cTeWMHi45gLyhzWHJTDFvzLsySYod20am9
	tTgocxCfV8chGPjHp9abgbWYa+uEuHzBRAUvh6E8Vv1ijA==
X-Received: by 2002:a05:7300:d70d:b0:2d3:f3fc:bb6b with SMTP id 5a478bee46e88-2e4646cca96mr20117825eec.1.1777067626985;
        Fri, 24 Apr 2026 14:53:46 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([136.226.65.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e539fa5c38sm33172246eec.5.2026.04.24.14.53.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 24 Apr 2026 14:53:45 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: hare@suse.de,
	linux-scsi@vger.kernel.org
Cc: Brian Bunker <brian@purestorage.com>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 4/6] scsi: Refactor scsi_add_lun() to use scsi_update_inquiry_data()
Date: Fri, 24 Apr 2026 14:53:22 -0700
Message-ID: <20260424215324.99045-5-brian@purestorage.com>
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

This patch maintains identical behavior to the previous code.
scsi_add_lun() continues to handle the remaining BLIST flags and
device-specific setup that doesn't come directly from INQUIRY data.

Signed-off-by: Brian Bunker <brian@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 99 +++++++---------------------------------
 1 file changed, 17 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ef22a4228b855..554409300746f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -879,17 +879,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
@@ -898,48 +887,28 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
 
-	sdev->vendor = (char *) (sdev->inquiry + 8);
-	sdev->model = (char *) (sdev->inquiry + 16);
-	sdev->rev = (char *) (sdev->inquiry + 32);
+	if (!sdev->inquiry &&
+	    scsi_update_inquiry_data(sdev, inq_result, sdev->inquiry_len) < 0)
+		return SCSI_SCAN_NO_RESPONSE;
 
-	sdev->is_ata = strncmp(sdev->vendor, "ATA     ", 8) == 0;
-	if (sdev->is_ata) {
-		/*
-		 * sata emulation layer device.  This is a hack to work around
-		 * the SATL power management specifications which state that
-		 * when the SATL detects the device has gone into standby
-		 * mode, it shall respond with NOT READY.
-		 */
-		sdev->allow_restart = 1;
+	/* Sanity check that inquiry data was set up */
+	if (!sdev->inquiry) {
+		sdev_printk(KERN_ERR, sdev, "inquiry data not set\n");
+		return SCSI_SCAN_NO_RESPONSE;
 	}
 
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
+	/*
+	 * scsi_update_inquiry_data() has already set type, removable, lockable,
+	 * inq_periph_qual, soft_reset, ppr, wdtr, sdtr, tagged_supported,
+	 * simple_tags, is_ata, and allow_restart from INQUIRY data. Handle
+	 * special cases that need the raw inq_result or additional logic.
+	 */
 
 	if (sdev->type == TYPE_RBC || sdev->type == TYPE_ROM) {
 		/* RBC and MMC devices can return SCSI-3 compliance and yet
@@ -950,46 +919,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
2.50.1 (Apple Git-155)

