Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C966A23F412;
	Sun, 24 Aug 2025 18:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756058560; cv=none; b=hsCmFvvv9PMsl+2fIjdauZNfOgby83veDuGs6PAccnyHZlOFGNC/6otktUfhXX5hpQCKEvMgEXaSnHDq9nBQGv4dVVSCtk21lBSfcZLziOY8h/3WVd0wzZjkVEx2kPzbJ4yroznv/FA6mw0eAzwaW+ADsbHlHmXLv+1MQC5e2Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756058560; c=relaxed/simple;
	bh=2IHLR41Bt6H9SAFHN7GDkXxwITP8egVFkyAO4HkfZ3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TdlVD5QZAud/wsL//GGYEeAGNH0y+CQXolSLkBa9ijYYboiLOUP0r6Km2I2NWDf4qjw3KNmGa/su/Ao3eMAITkHCkY66YF0haCrkUUXARaJq0xDTflkfr6ceQ3O2R5szruVP3zPLnmp1kSbEB3R6h2tJ+idyIuw/16JwCmeG/qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A24nVgY7; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A24nVgY7"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7702fc617e9so1706467b3a.1;
        Sun, 24 Aug 2025 11:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756058556; x=1756663356; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wlTPogTEBPdVF/GFVmhohz6r+jz4VlpRXOmq7brhd0c=;
        b=A24nVgY7hj52iX1wVGUGcJ0ELp0JkjCRfOz73wHuEdnqD8LACmi6DuF+CL8gOIAthj
         bKjE9Fo5V0CCn1aQ6thLHh/2+aM/yaFUmZYh6gCy6STurMynNWX6uKD1VLZCGweDnVxl
         2Sz6NS1nAUEz59prc1npXXS6onl5MssU8JapOkpgxCvG9ac3W+zHMpOsp1H8U1gIxU8v
         T8O2W1EGuiEtZ2BzhKcXrdZeVqlN43heBt3KdoBpOw7dB6ygcnCV3m/PnM2iRjLUc9UO
         eMxQ70tp4g/z1IrZZdOo9HOLatlejwYDuVoD3jQrqVkQjgkgZa6TR/0XK/a7C0fj8LGB
         LjzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756058556; x=1756663356;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wlTPogTEBPdVF/GFVmhohz6r+jz4VlpRXOmq7brhd0c=;
        b=KY4YYI2UASSlN6aqDuY/ypz7HZwg7Mw0IpejTFgiximxlf01UbSddJbcvxSpo2UEjT
         Rla0gdVKz3vBAh1rB5R+TokolZRQFQR13cb/gH4pZ2xSrIPNXfan2TKKbztD7iMMrAo4
         O15wnzfiG5UR5HtKyVzNCsPm8JpIvULrZ6Mb+MhD8HLHXrD7VtUP16uXu9DK4RsvOjvb
         kp4smiyO+b9mF2QgTnFMM7IMltvm2wLmcQBAjb0fL4f3uwSz+Zc/ZtL2ZBiMk99uGoQu
         Dz6WFW0KBmS2PA1TnywnuPcy19Wzk7/t0rg7Wrf/xTi/5q1pWUKmj5s3wwX0bbG5qfKo
         i9sQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5b5+Sqk4tLC+PqsMzQwB7RKMFxOHaZ7tgKVCm4+IFBd+OCVfJU2ZQQwjyjQAkEUv5t6/gnPaeD4IAUQ==@vger.kernel.org, AJvYcCXoAyYhgfCxXt9aF5OzXTwbybe3wwV3wqW1Q7We6vk4Tri+tH18VcKf9YZbtkm82GfenUr2HBJVQWuPnS8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwQkOz1hXWA0IZoVGMVKecQiqWEjWdTuO2JocN6wxeUAd+8ZJx
	dAtkFHFAEKdL1P6GcRltgjA5dPTXOPCYQry5Jo9iAg9rx3LdlsOX2wtx
X-Gm-Gg: ASbGnctVfhXIl5AfXxPQMJqpmjZu9nllyrIbjes3z1VOA7PCI9liyMT7HbeXRp2z70h
	O2bSUltL0/blVTA/bNIpg7TdD/lvBWa+jqgQ+tY6MEK3uqzJitHQslJOo8n5skVDYKSSQNRAMOl
	9dXHYLLs1I/U0T29aF3fiv9pO3jy1J4KJnyc2nHIrBdV99QVxBeSEB7h5y94eHsvXwjWUxfgRYM
	Ac6gB+4dOMljCRx+fvkHmOPNK6jRcDQmX0O6pb3kK2cQyJ6/xvtAOrV29qoPkzHEUqiM31fIVxH
	Hrwq9d5bivXnoOYcJ+EiJk4/msbyv8X6rSswEXqlggIKoL59wslqAwkJki4nWwjL5UG//dhtBDa
	7xtHZcyMWNN4rgGAc3OCIiCDPSn4vEn5mUGNjDItfj8dAdA==
X-Google-Smtp-Source: AGHT+IFEdPx0UDQK7HEjPhfSNs39BNywmeKiKFXrMzcRmNXpNfUAM3h6Lm9V3DNQX9UM9qMPNjFoIw==
X-Received: by 2002:a05:6a20:6daf:b0:243:6d28:eac with SMTP id adf61e73a8af0-2436d280fd0mr2185643637.38.1756058555749;
        Sun, 24 Aug 2025 11:02:35 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cbb7b6fbsm4743532a12.30.2025.08.24.11.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 11:02:35 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v9 2/3] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Sun, 24 Aug 2025 23:32:17 +0530
Message-ID: <20250824180218.39498-3-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250824180218.39498-1-abinashsinghlalotra@gmail.com>
References: <20250824180218.39498-1-abinashsinghlalotra@gmail.com>
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
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 50 ++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index aa9d944e27c5..35856685d7fa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3696,10 +3696,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
 	sector_t old_capacity = sdkp->capacity;
-	struct queue_limits lim;
-	unsigned char *buffer;
+	struct queue_limits *lim = NULL;
+	unsigned char *buffer = NULL;
 	unsigned int dev_max;
-	int err;
+	int err = 0;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -3711,20 +3711,24 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (!scsi_device_online(sdp))
 		goto out;
 
+	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
+	if (!lim)
+		goto out;
+
 	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
 	if (!buffer)
 		goto out;
 
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
@@ -3738,17 +3742,17 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
 
@@ -3758,47 +3762,46 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
-		return err;
+		goto out;
 
 	/*
 	 * Query concurrent positioning ranges after
@@ -3817,7 +3820,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		set_capacity_and_notify(disk, 0);
 
  out:
-	return 0;
+	kfree(buffer);
+	kfree(lim);
+
+	return err;
 }
 
 /**
-- 
2.43.0

