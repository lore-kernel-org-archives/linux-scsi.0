Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9A41DFD96;
	Fri,  8 Aug 2025 18:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754677653; cv=none; b=ipxibqy5lPud79F3KRqBJWSTiGmj22YIeZC8nlmPsER5jSTOIR4C+VPxrmJBtKzxpherTvnjyl0WbgCHehSfgbR4qvlXxxiA1Ss3nO+t2zUbTNzCNscVrh1fBw8bktBiiuUCqy81E7PQiCcdaXnX+q2FnhCxI4R5mTBo2daKeyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754677653; c=relaxed/simple;
	bh=ScxOUDXrEovI5oCnFNN7oEMJZZfHR8krOgWObKqcz+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YjAFtv7th8GQv3MTTPn1DDcIGq8OeSyPuDDubiU5azkQNowKkRkhrm4kj12fuU+vq1hByD3etwNIHuT/wqgnrHDk+QLObpgtvUoMPROZ6Pb9hPgnkd7J0+vwdB95NIw1E7r3Lhhr9yGk56OJvTo7GPkCbMQd2qm4sqgp8Ac4G2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XwSRrmiy; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XwSRrmiy"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76bfabdbef5so2346595b3a.1;
        Fri, 08 Aug 2025 11:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754677652; x=1755282452; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJ5eQ06/n4syZBNfnp4DOSNRXM67KVAvsvnyCFTkyPY=;
        b=XwSRrmiyqvZjsuLVygK9OIOHik/THm5sYHl7k4+Z6JcqQOhtnSglnizCpV2mJOZn4F
         qPHYf1BU4wWR4U568+Mol+3DjeTpzBBmSuNfcytqhnACEcFcCiNzEeZ3humsM/VxdSrO
         KwHpxsEA5aPFoFXPaXriYymSj/cWg6BjlejR9uVm6mn6HcDI6Jz9iCayHt7UlYg/g/Kt
         G8JiLeYceCMjIFJxLma2PE+kHy879Crs/NJ71AVxfndljk9KxSONTUcP2Ru8OU+LAhFa
         OPx0nnaKkEeISjfKeWZ6cfUc7keKe6qzZcxEgqjQRmVeYWtWC3egVMQ+SRRczG6rCZX5
         tgWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754677652; x=1755282452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AJ5eQ06/n4syZBNfnp4DOSNRXM67KVAvsvnyCFTkyPY=;
        b=A0C3KJPy2qfRrCNZ6/x51IGbS875psPTDA4fyD8c4TlDOp1Baa/PFKqfudA6fjLguC
         9to3hVoWc/htdbB0p45GqjAB3N/4vdEtBmS/40nlSjy8XCD3eivk2enzHSutREA1suhQ
         XkE2x4Iit4bSRIHGyvvAX7KtQUQjx7IZ8d0sVNg17qvFAMnoY0qoLwQ++SGkSd4VMdWL
         J8nO/z11i4uyxgLCHXOh3CAnQb87QrG9G/J2hChy1X8MqfRGJ0ntmj6J79S5l6bNTEWY
         PmxlsLld1AtuRIvt1mhfcykLp/LV6E/skP1NU2v4rpcUMLDi8DjLdgZMkN+ZCJkntbU0
         Jypw==
X-Forwarded-Encrypted: i=1; AJvYcCURL0mCWz4EdRsdfmJNjbUS3r7j7QmELuqqDMUon3eKxMMrT0m8SL7Q45ayYBtAiVgf/1M+Ses75S9Gnw==@vger.kernel.org, AJvYcCW2QwOnZCY2w9a2MND2eflVIXhnUGhH8EppvYzXM+yaRvtde+kdJLb4gVeZXNyZRrk8HEaopM6YdXorX6I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqlkFqTI35r+14QZCBpA619noF4ChaXGyltfTYNnafZWEoH0/3
	4eSKqUxrToa5E51y1a4rGKiwrHhWWvFNe11fwRYu/le4xoigddNqdI6L
X-Gm-Gg: ASbGncuwxnNY3uPZ8OI2Vj8qCV55plo2WSu1Jknss1QSQDo+NZuqwpI5l5GCf/LlOex
	fqnfMVfYf+XprWEqoNpIwNPto9dSF1DaQkXHLqXNdDXa/78YetO4FNXyElwp2rukd3rcGtpkG74
	oEHAqNhMmixZZb8bBZ86rPkFTmpq5zHPOjRtRZVffBHnTeQt9rh7RHaU8TCvy+29B+1EjCaJEpn
	OyVqJNt1iJHksUrVA8ImCRU9iEyQilx/b22m11KLCfw165IIUKeQOB4Zyzh24KH1G6n76llAGja
	m4HKMEFJVffN1e6C0YCBhu1KxwyFzLpAS4IW2E9Cgub9lU4EMmi4f1MeyHnsWX9k0jSdKZb9Dhh
	zAbI4laqSgcOmZdo/Odj37BPT6jIUT4/E
X-Google-Smtp-Source: AGHT+IHM4RZgJjZBncy1cG3iSnExLcVd1+lHH5c1Hr0kzqrxIZ4dMr8wuuZSZNhPKItPFs5BvGgHUw==
X-Received: by 2002:a17:902:d486:b0:240:a21c:89a6 with SMTP id d9443c01a7336-242c2003830mr65059295ad.12.1754677651477;
        Fri, 08 Aug 2025 11:27:31 -0700 (PDT)
Received: from avinash ([2406:8800:9014:d938:f647:9d6a:9509:bc41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e899b491sm215196445ad.131.2025.08.08.11.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 11:27:30 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: dlemoal@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v4] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Fri,  8 Aug 2025 23:58:07 +0530
Message-ID: <20250808182807.12625-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <4786fbb9-5d25-4d86-b902-61cc78a9b138@kernel.org>
References: <4786fbb9-5d25-4d86-b902-61cc78a9b138@kernel.org>
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


Changelog v2->v4:
	initialized `err` with 0
	removed extra label (`free_lim`) and merged it into `out`

Initialized `lim` and `buffer` with NULL, as  kfree()
can only handle `ZERO_OR_NULL_PTR` and a valid pointer.

>	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
>				      "sd_revalidate_disk\n"));
>@@ -3711,6 +3711,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
>	if (!scsi_device_online(sdp))
>		goto out;

Here it will jump to out and uninitalized pointers will be passed to kfree()
>+	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
>+	if (!lim) {
>

Similarly in 2nd goto,.. uninitalized `buffer` will be passed to kfree();

It may cause page fault or make kernel panic.


Thanks

regards
	Abinash



---
 drivers/scsi/sd.c | 53 +++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4a68b2ab2804..c7fbfb801b40 100644
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
@@ -3711,6 +3711,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
@@ -3720,14 +3727,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
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
@@ -3741,17 +3748,17 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
 
@@ -3761,47 +3768,46 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
@@ -3820,7 +3826,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		set_capacity_and_notify(disk, 0);
 
  out:
-	return 0;
+	kfree(lim);
+	kfree(buffer);
+
+	return err;
 }
 
 /**
-- 
2.50.1

