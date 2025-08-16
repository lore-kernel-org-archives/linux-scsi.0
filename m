Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADEE1FF1C4;
	Sat, 16 Aug 2025 20:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755377637; cv=none; b=nBACvLub4Up4rjOGQWSgJICWhuK4L69i3VfqXhrJtAynxwBX48HDpcvaZSi7T2BKrtxom7eOdHafKsieaTjS7Cc7h+RZKdqh1/KuWBU+Jd/kS6EXaUHUJ81yaDJ9pPH6i30sBeMhbepQdbijYVSxKBpIpGQYxRtFbkiUNCyKc4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755377637; c=relaxed/simple;
	bh=51yJuvg4tt0YfZoRoi9WJpVeg/RqJeSiDAoYbNoon/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JK/b+7kg/jI0+EIPLIbnRmtM1WMVC6FCDOJH2ENMc7Nuc8FK/jv/dfZ3RcTgSH6w17ZKeuGPrpRatyM+oZfb+MsqRdnpIGu5LREkBfNxf4fn1Ke/V9qGtHEWT7nNypSzXfgVubjQqgXpgNxqylYKInKN3VjspvvqlomcNbygoLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KgO68b4T; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KgO68b4T"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76e2e88c6a6so2753607b3a.1;
        Sat, 16 Aug 2025 13:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755377635; x=1755982435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLUIJbTvpwEqxducYC/6Q7Jn1T1YxvwmbFd7zTq2su8=;
        b=KgO68b4TIKLcwHyXmpZD6x5ACsTOeAEimq/JO7ltrP19BJRx97pxWdX5c/wBmuLfcq
         QIZacgwysCn784DyfoVdzrNGYRQFx1GTs84hr8KNRpt69QQGiPz65eloyCq0sQmTk5mT
         h9zruA7F02tYzJVzJXsh2XLwFvwdSyKFIRI0sAFcgvnpgAmlumpfwIVkiWTfC1ga6ufe
         TqotBctXNFBcd6aDnfJ+kqE6qZxGYVYumW7IvseelWck1La5w5BDQPWskBzSZvQYl7wP
         O1AbzLukySk1wJwctDFltkvN5mD44fHSN21iE10S2TqONsBxJStoVxiGSsePda6GwDdS
         dDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755377635; x=1755982435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OLUIJbTvpwEqxducYC/6Q7Jn1T1YxvwmbFd7zTq2su8=;
        b=rF40l0PSvpJPCbc2IrSu+BmrkW0CXC2RIMeEgi0BVomSjKUo8NEiOjd5rb4E5QywPX
         vRwdGxfmZqK6HQdN1IgFLLJPfJiDGWuIPliv0N7+fpXMRWoHf02V1BfdINga/x7j35l2
         /RF16uk5ME5v6gQMKiNUetDkiR81qx7SN5/SwfasetztkE6BMNfxxVMTkViqvWafekHp
         8i9GtWBHt1ZH37oxTeAKslddu/bwwYRnJeCUges1hgTGi+QYqJSsmsAE/ualsVHJttn2
         vQ2enbXZ7HHcgImt/2iol+LtykerOLNDWg0NIU4yDM2vsq8yEF3eiXiFbb0EMaxAvrHy
         5ByQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIe00e5RqvrmNYkOTQmmpXTQW7qzcJhf8UJQdhfw0m3j0NSN0MQKhzon++UkjME7+Zb/MxwYpTNkeo5qU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpjM/c2i7USd7s8aIfHnAG2M9gDH6zvHMrWyMf5QVJ5XQfVOHg
	iYYW/PANphkOf8tIM3PHdXcLgP7YLkscdCZpQBmOQsBfNnLdMr3Qq+z2
X-Gm-Gg: ASbGncvkO4dj6gQGP+rmS38PXD6w/lqjjtWfsQq68A+Gzp/j2jQsNCRVJkXu7iWJM7N
	zsyDoXbKC7Mq0DeB2C4gj6OA6irp6dpFW9c6tmD904xpL73RssIj54ASJ1n/rWYynF/EtaeZrZ8
	wUzxaUcckwMLwOnTqxo+fLvsxsRJC8cEw0tdKm9fumCYt0LVASjRgVPq/xDXXb9LC8cPj2eaPOf
	T+fPLaB8B7XjSYqZKs8WB9FCR4plj1SgsvYzduNHgwJgV9MzaBcQR73EzEB9rtb/rrL41MOpinp
	4dpMqhcRafCaopdFgkcwjlafc5BOsMgioZ0AEsSahQ3zJ2Npm5xebPZhspn1Q57a4FbE6U8mB6t
	sIstXCUswhZBlqM0VE7mKtpwtarBM2oLd1Q1hLwukJ+0LYA==
X-Google-Smtp-Source: AGHT+IHn5diiuw76ZkKVA6luCDR+iBNt3RMUkJr4TQRSYTDUMSm68Kyx3eWaGzYSERRyFbaV2Vte1A==
X-Received: by 2002:a05:6a00:944f:b0:76e:3a11:d23a with SMTP id d2e1a72fcca58-76e516e9368mr4965042b3a.4.1755377634513;
        Sat, 16 Aug 2025 13:53:54 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e4528c812sm3833154b3a.45.2025.08.16.13.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Aug 2025 13:53:53 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abinash Singh <abinashsinghlalotra@gmail.com>
Subject: [PATCH v7 1/2] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Sun, 17 Aug 2025 02:23:28 +0530
Message-ID: <20250816205329.404116-2-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250816205329.404116-1-abinashsinghlalotra@gmail.com>
References: <20250816205329.404116-1-abinashsinghlalotra@gmail.com>
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
 drivers/scsi/sd.c | 53 +++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5b8668accf8e..c3791746806d 100644
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
2.43.0

