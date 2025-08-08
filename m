Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9282253FE;
	Fri,  8 Aug 2025 20:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754686691; cv=none; b=efV68lXgl7oK3VXNHegBXE5+ZOPfX1KDcjBq5ES7fa15iM0+AxklqbesDHaOd4zg3WDtSiW/erhr5kdeF3gLN2pNkEcFHFuDfLKlVmIM91bAvN0eAA+034sWeo1sJ4xZbxM8q4j31ovSt7lF2ZrYEXO5iS9SK6+VHoOaS2FomVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754686691; c=relaxed/simple;
	bh=TyJQUH8dHZ46FhzJ+l2L31lXtQBdoSRQf/tGmeQC7CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KD9f68L5b2EAQ9u8ziJplfCP51o7d7BVhLjHMQCkr0LCeAwS+84h4klBMuHdWokiqjD3+1h3wq8pW272IwOkhfpD6AIo67LOLltIpysVpWBZOl3ZUeqSiUk4tt0iRVC4xsgfvXgZwU//qThqETnb5UZNr3Up95YN1TmH3gLXMY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yul6fmaD; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yul6fmaD"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24049d16515so22127665ad.1;
        Fri, 08 Aug 2025 13:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754686689; x=1755291489; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnHfT5Qo8qf2TJOAloAsKSB5a9DbpjCeLYVaNSXEctw=;
        b=Yul6fmaD36a/Fo4cgjk7JIV8AKmMfTv/BCN500dEsHfiCrs0x3t9mP1Nc6epeFlbwt
         T9t56ViIyT09/4UE+6/HDo7LOr7hEQQQYXaGW3N0QmqL2g4SDJDCsIRISQui0x41EAG4
         XXrtddElKAEI/1IQeO5rLTWmjA5I3Ci3N4Nr0ZDl1UcDjHMelT2iOhUJdWiXh5/uArx5
         NCRYxf37jG2+qUhzj2bjZds6ofy0mM1rhsOzuNz3Azqbhe46UG+ShoQrqVfS6Ic8DVjQ
         Fl9OfsOHryluL3E90FklZTEHtZQupfxWzHNQbEIJn36UrrepbE6X9+Ai5F45LHrLMerD
         lLLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754686689; x=1755291489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rnHfT5Qo8qf2TJOAloAsKSB5a9DbpjCeLYVaNSXEctw=;
        b=AK7CCWm+PfwKFosF5/URVIEMd3NvTWBPfYOrWT2ZDjVMOob0DRsNIQAL3/ufVOogpb
         SeO1+V7qokzKaHHUS8Kn1gb0kkf7exYymWU1TIYj27/YSIiBB7dxAl9LtLmfp+e74zKC
         yMv5X7dM8VuHJDo2dNVNtbU5lixx4M2mI1MYfpUG3V5hEEA9A4s7iK2mHT5CFhHw74E2
         gDVMGFop3BlaOlVHNphcRJp+jDDLwYCR3j8OnqwFJkU2qQcG1cdwkzxmwO2yb6RnqerU
         sQMfxmRT6anC0U62MR24jjhXeh0LjxptS2uY89smgc8sfObDiABLkmSnXXRiMEWg8M7m
         SQiA==
X-Forwarded-Encrypted: i=1; AJvYcCUSwitgryu3upbW9HbfAu0Eq1pUcs9hS9Y3ETJuPwYF5JPsEIDoQV0dk7nu/dEzPAnb6TxhoLSOpoSEJA==@vger.kernel.org, AJvYcCWtKzzeHCLYTay4VxTsD1IIlvg2W37ELd4O2oKcFw6poRS0qilwVY5OUDnYLiS0xaCRn8t6OtVNHmPyIHE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRSuEwEDdAj2I7iIok9eshHOkO3wyWsLci97ahUMCwbDqZdhWg
	/Ebp4QAuyEvIRKXcSWahGulAEvEYT13lBgTrDA+cvAzqL9ryZHHAUXrm
X-Gm-Gg: ASbGnctJ3fv++n2/hM+RZFhi/2bMASX2UZrmfUuxdDPwh0PPGiosqf6HUzb+HNLaOj3
	SyaM9q5d5lpMV/EYqe1pn897iS/gpc29hYcSXqm2EOpUInmkdvBbgbvLAJ9nQUX5RiymAMb4uhM
	tEOxt37OXriXI019jLpOE4QMYqxP6Trg6Q/QjgZaavNFlxAuZ+8xQdBXJ8mgLmTe4RTeaj0GAde
	NPKQIZd73yh4gQnRj9UjELGBO40nXj+9tWmV2NJ6hyYGuUKcFRkffEB/1TSkdfE9aFcUf71T22D
	lzwruuQferZDy9MRF+EYr/G8/E9NXr1OzCN4YaygQUsG68efqPTqr6U/obbC1hUqHjYoy3p3q4/
	UCcDVYbYUxTGBxPVYROJWKw/QRbJCPYpv
X-Google-Smtp-Source: AGHT+IFZbUctANYJ/CeWiY6FK0Ci9xEWrnhxRKGWGdndMkE6kbcoC1j4wEfK2UbCtcoDhNUSK88miA==
X-Received: by 2002:a17:902:c94a:b0:240:3913:7c84 with SMTP id d9443c01a7336-242c1ecc793mr60770215ad.4.1754686689380;
        Fri, 08 Aug 2025 13:58:09 -0700 (PDT)
Received: from avinash ([2406:8800:9014:d938:f647:9d6a:9509:bc41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e89768a7sm216840965ad.83.2025.08.08.13.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 13:58:09 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v5 2/2] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Sat,  9 Aug 2025 02:28:19 +0530
Message-ID: <20250808205819.29517-3-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250808205819.29517-1-abinashsinghlalotra@gmail.com>
References: <20250808205819.29517-1-abinashsinghlalotra@gmail.com>
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
index 2f9381dcbcce..7e9c8d08120a 100644
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
 
+	lim = kmalloc(size(*lim), GFP_KERNEL);
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

