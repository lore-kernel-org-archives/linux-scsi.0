Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0AE221558;
	Sat,  9 Aug 2025 09:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754732078; cv=none; b=aN/sNJhWPj+j7mLhOkzS8MdNHQBEuUqAaoqjyY2QsOGleOz9wa9tyq4Hew7rO5BWRmksSruAGXUUCmx5+p3LS011NB5uhxMTcLh0x/a0iL0sGBi2cujOGntrnXCjNwkHog/KCISlg1/nDITvH6q9JC+neIpY9EJ9fSGljfVcWWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754732078; c=relaxed/simple;
	bh=tfipjdnQ1+4cvbl5wGppN0cCCtuUAjN/7hu+r4/lq24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zvstj8869dzonHdNPHi3KpiebYBoxz7TexuhMDdBAjZw2zgQD4ZTXj5ZsdLFqKQMlU0n703U6Ut6y2dRs9F6ZSDWDv/HF45ipc9U9/7PnJ0TRLlhsY+/g61Q93+2XNY89UYp+RniWZFmCavwOGm4kSEARbFMuIg0PayS2ledunk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I9bkhByD; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9bkhByD"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-31ece02ad92so2294364a91.2;
        Sat, 09 Aug 2025 02:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754732075; x=1755336875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3yWvLv2YVzCp5tdCUewjp61gJ7d3m6YACK+GSNmOq/s=;
        b=I9bkhByDo313ew6xx/jR+z1Czz28BRU6l5BSTrwdADmMAIYNJ+veOu9iT+sw8quw65
         uhuAlaoE/Y9OHDNh58Wv3vdicehFAestx/2/kTQVBRnULQm5DHtsTDzn0u9wbq8pM1YU
         zRhGbxguXkx7SGAUQd6Ka9nPnFTbysmNqF227ADps7kYHz+X5bq7Qr7vIZ4tMPsuWUSu
         VY9FDS1JWmIJHk2tMkSNDjDfy5Mgzv3tSuJxbBIWIPx8Agx40ZikBOVeN6lAk+qQ/uOH
         3HkmgwekFNmHPt4GrOxc+Vu2sgU2nbI6Ur0dXpEBJATY16wKt7O348/v8MF6ngcPPQoa
         cDIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754732075; x=1755336875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3yWvLv2YVzCp5tdCUewjp61gJ7d3m6YACK+GSNmOq/s=;
        b=MKKhZDqVtk/7R0SC8mAMxime2w3+Km66YoeDPyN8oWowM+TBnPaLRpNrZ24pGWXvaq
         dJLhoprP6/BiyCYBYcE+HNflIEn0zniqmmWRBIW+Ybk52uIpS3r5jRwFktrbenHXEadM
         fd+j6gs1T9wvnJYJz5EZNBJaTmTOV9FwqCAVJGwoia08SRBdLCpbDMsT31edEMKSODNx
         MrwKv5F9bxWngvbec7FiBJMVguhaacNVShnanWvy0bQ73bPuIVrAE/m3UAeXz5hzBE+R
         TC7hk0Y72IYnbigG7MPGk1hFnhMtqNRWjDAI3mgE8DyiKL/oR4buwmb5YYRYekH4QcT9
         DULw==
X-Forwarded-Encrypted: i=1; AJvYcCUySWlwUPbDNDjxORULZdFHgFTHT7KKNtt/7gs6rQpMOSgkTGI5OYnG7B/VmHGgaGHdyS6VUu2OwNwRJLo=@vger.kernel.org, AJvYcCWqEaSBCxloyduEmSeS6+PKbmV7IGLXgp8fuF3B7G26Fglh/4SFieR+opMr7ExR78OyHGcEbQVN8Oe8gA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1w+l2IgvGAMcKqR+3D5fvEj5U2pH2BIk+oX5WTRhKs68njj9h
	RBkEOC2huW7SqmcdDywjkkDuDyugmt1DGJR/kotYaQwPhkRYsvxIEunV
X-Gm-Gg: ASbGncs7L8YsoBBLZsIr/MGLO0luprmodHm4uQr78KtdfBxuvd/jJ9/ZRn9Ufn5Dm/k
	wWBywK9sGes1BMAXpdZt5G80oUJnndlKbzQCa+iM7DeW5u6gOCzFp3+cC3n3vctEgyOGBUa9J+6
	/Vv5hd/5FVsFUUX1Q+no1aWQOxU6zWGTYTT3pK9aF8SdrCC3reM69A7mGAhG2hqN190lUGYIqLg
	8nxXMueYQMUIBG1gPHDlvXVfl0BYQfImtIBrHvmP+chJPHZ5Lw0zUqrKVqInMg+FfhUGQlk2AR0
	vBtzQCMciAkr/HFxyoHmswlDlm25iG6kkZYyVDLzSL1zi/MS/E9o7OUwoHM3mvAY2pu+gZK5LH6
	jIZ19ii8lLJf1nD3xnp4+H7+n2d9yUxmE
X-Google-Smtp-Source: AGHT+IFDOaCQiEiRiMG4vI/HLSCT5UtoqwEW6a1NlyUZIB7cxF8B5yG9qsMxASG77tPtlfrw/QbJRw==
X-Received: by 2002:a17:90b:3e4b:b0:316:3972:b9d0 with SMTP id 98e67ed59e1d1-321838a7672mr10078959a91.0.1754732074991;
        Sat, 09 Aug 2025 02:34:34 -0700 (PDT)
Received: from avinash ([2406:8800:9014:d938:f647:9d6a:9509:bc41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32161259329sm9823438a91.17.2025.08.09.02.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Aug 2025 02:34:34 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: abinashsinghlalotra@gmail.com
Cc: James.Bottomley@HansenPartnership.com,
	bvanassche@acm.org,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v6 2/2] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Sat,  9 Aug 2025 15:05:07 +0530
Message-ID: <20250809093507.372430-3-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250809093507.372430-1-abinashsinghlalotra@gmail.com>
References: <20250809093507.372430-1-abinashsinghlalotra@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A build warning was triggered due to excessive stack usage in
sd_revalidate_disk():

drivers/scsi/sd.c: In function ‘sd_revalidate_disk.isra’:
drivers/scsi/sd.c:3824:1: warning: the frame size of 1160 bytes is larger than 1024 bytes [-Wframe-larger-than=]

This is caused by a large local struct queue_limits (~400B) allocated
on the stack. Replacing it with a heap allocation using kmalloc()
significantly reduces frame usage. Kernel stack is limited (~8 KB),
and allocating large structs on the stack is discouraged.
As the function already performs heap allocations (e.g. for buffer),
this change fits well.

Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
---
 drivers/scsi/sd.c | 48 +++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9d5963de8c82..bc54884e910a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3696,8 +3696,8 @@ static void sd_revalidate_disk(struct gendisk *disk)
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
 	sector_t old_capacity = sdkp->capacity;
-	struct queue_limits lim;
-	unsigned char *buffer;
+	struct queue_limits *lim = NULL;
+	unsigned char *buffer = NULL;
 	unsigned int dev_max;
 	int err;
 
@@ -3711,6 +3711,13 @@ static void sd_revalidate_disk(struct gendisk *disk)
 	if (!scsi_device_online(sdp))
 		goto out;
 
+	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
+	if (!lim) {
+		sd_printk(KERN_WARNING, sdkp,
+			"sd_revalidate_disk: Disk limit allocation failure.\n");
+		goto out;
+	}
+
 	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
 	if (!buffer) {
 		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
@@ -3720,14 +3727,14 @@ static void sd_revalidate_disk(struct gendisk *disk)
 
 	sd_spinup_disk(sdkp);
 
-	lim = queue_limits_start_update(sdkp->disk->queue);
+	*lim = queue_limits_start_update(sdkp->disk->queue);
 
 	/*
 	 * Without media there is no reason to ask; moreover, some devices
 	 * react badly if we do.
 	 */
 	if (sdkp->media_present) {
-		sd_read_capacity(sdkp, &lim, buffer);
+		sd_read_capacity(sdkp, lim, buffer);
 		/*
 		 * Some USB/UAS devices return generic values for mode pages
 		 * until the media has been accessed. Trigger a READ operation
@@ -3741,17 +3748,17 @@ static void sd_revalidate_disk(struct gendisk *disk)
 		 * cause this to be updated correctly and any device which
 		 * doesn't support it should be treated as rotational.
 		 */
-		lim.features |= (BLK_FEAT_ROTATIONAL | BLK_FEAT_ADD_RANDOM);
+		lim->features |= (BLK_FEAT_ROTATIONAL | BLK_FEAT_ADD_RANDOM);
 
 		if (scsi_device_supports_vpd(sdp)) {
 			sd_read_block_provisioning(sdkp);
-			sd_read_block_limits(sdkp, &lim);
+			sd_read_block_limits(sdkp, lim);
 			sd_read_block_limits_ext(sdkp);
-			sd_read_block_characteristics(sdkp, &lim);
-			sd_zbc_read_zones(sdkp, &lim, buffer);
+			sd_read_block_characteristics(sdkp, lim);
+			sd_zbc_read_zones(sdkp, lim, buffer);
 		}
 
-		sd_config_discard(sdkp, &lim, sd_discard_mode(sdkp));
+		sd_config_discard(sdkp, lim, sd_discard_mode(sdkp));
 
 		sd_print_capacity(sdkp, old_capacity);
 
@@ -3761,45 +3768,44 @@ static void sd_revalidate_disk(struct gendisk *disk)
 		sd_read_app_tag_own(sdkp, buffer);
 		sd_read_write_same(sdkp, buffer);
 		sd_read_security(sdkp, buffer);
-		sd_config_protection(sdkp, &lim);
+		sd_config_protection(sdkp, lim);
 	}
 
 	/*
 	 * We now have all cache related info, determine how we deal
 	 * with flush requests.
 	 */
-	sd_set_flush_flag(sdkp, &lim);
+	sd_set_flush_flag(sdkp, lim);
 
 	/* Initial block count limit based on CDB TRANSFER LENGTH field size. */
 	dev_max = sdp->use_16_for_rw ? SD_MAX_XFER_BLOCKS : SD_DEF_XFER_BLOCKS;
 
 	/* Some devices report a maximum block count for READ/WRITE requests. */
 	dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
-	lim.max_dev_sectors = logical_to_sectors(sdp, dev_max);
+	lim->max_dev_sectors = logical_to_sectors(sdp, dev_max);
 
 	if (sd_validate_min_xfer_size(sdkp))
-		lim.io_min = logical_to_bytes(sdp, sdkp->min_xfer_blocks);
+		lim->io_min = logical_to_bytes(sdp, sdkp->min_xfer_blocks);
 	else
-		lim.io_min = 0;
+		lim->io_min = 0;
 
 	/*
 	 * Limit default to SCSI host optimal sector limit if set. There may be
 	 * an impact on performance for when the size of a request exceeds this
 	 * host limit.
 	 */
-	lim.io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
+	lim->io_opt = sdp->host->opt_sectors << SECTOR_SHIFT;
 	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
-		lim.io_opt = min_not_zero(lim.io_opt,
+		lim->io_opt = min_not_zero(lim->io_opt,
 				logical_to_bytes(sdp, sdkp->opt_xfer_blocks));
 	}
 
 	sdkp->first_scan = 0;
 
 	set_capacity_and_notify(disk, logical_to_sectors(sdp, sdkp->capacity));
-	sd_config_write_same(sdkp, &lim);
-	kfree(buffer);
+	sd_config_write_same(sdkp, lim);
 
-	err = queue_limits_commit_update_frozen(sdkp->disk->queue, &lim);
+	err = queue_limits_commit_update_frozen(sdkp->disk->queue, lim);
 	if (err)
 		goto out;
 
@@ -3820,7 +3826,9 @@ static void sd_revalidate_disk(struct gendisk *disk)
 		set_capacity_and_notify(disk, 0);
 
  out:
-	/* Placeholder for future cleanup */
+	kfree(lim);
+	kfree(buffer);
+
 }
 
 /**
-- 
2.50.1

