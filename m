Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6CB19D081;
	Mon, 25 Aug 2025 18:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756147289; cv=none; b=HwSsvjlP3G5qrgzbc5cKup/XursiFBmystN7vye+1cEYThtp9Dun2mPRZ6ouka9WX8bZ9pvHKFRLgKURsB8Flq7GyyRcEZfVRljDkHy5SOPypxQWbPecj5RNFmIuDOP4UE5eddUokOZJ3lthg9lEX4ZsvWPdRY+wL8zQo3hCShk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756147289; c=relaxed/simple;
	bh=wnBx1m6t7DxX/qkxhgOcbfIgslGqyOfvvccgrgi1TMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uxq1SSzjF5Oi30NAYMm+DC33kKPqZP2yphp0aMLCpOLQZ3vvDTBcesNMe6Ex0W6PjuawWpmSEVURi5n1IxTJqfMXiNE1Hi5mTuBZ1LkdIO/QyH+VKbiwBV2JbF1UTyuOh3nuBFeJ0N1OCJ8FAj2GvJcdS5INjNMxSe2bcIzLMvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FexkvddI; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FexkvddI"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e2ea6ccb7so3647067b3a.2;
        Mon, 25 Aug 2025 11:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756147287; x=1756752087; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FWlT+WUrwobKV/mFWuvW1R2n0pbFPQZ79e1BmpM9k1c=;
        b=FexkvddIDuSwuyy5AJOGegq4cNyAoRejske7Ont2GCcgcxovOgC2WgGJH0YhnRpcHK
         V2OCnqB8rv5/UX5Nsv5zqKR65FkgQSJwq+2vjgKm65r1M3t4x1QzUsCnjYF+LouHHrvN
         jTS++cRXlPAfygr4GlbkK2eVt0ES6V+NE1DfVTDijgfppuC7uqxDg6q5HI8ibL/6ckVO
         WwLG/RkBIQgRNWJqkOk/ahAmjjoyu9e7dSK7mdbYdakiWjgMvpwOnEUNPe2QgscmJlSG
         ngr5jLAKfKPvgqQ5oDu0hjB7eHPe6NWK/PWANaCziofuOpgevy6thYTe6eeMT93tvZil
         xf0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756147287; x=1756752087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FWlT+WUrwobKV/mFWuvW1R2n0pbFPQZ79e1BmpM9k1c=;
        b=Ylo6U/8IVllFnOn0F4zZJ0Lr5X5CtXa474VVF4O7tzNJN+mEjr5NTbcNR9wvElzR9Q
         aQ0YQhycBajpCF2+qsSjlB6RNTKzGXUWbkH2+3sqHXqUo/kQDks760w0ngMMditNnT4B
         /zznf++akdiEHPRC2PEf2gKCUdr3/KnJGiXFGEFOmcTxxdW9+ogWsMg/PjC539/PgWnS
         v69MDVbyP8ztqdkdL1Xeq61oX/lH40VQpf/bSAAO4FCN5cYapSNODqJTuApzlGEJ/x7O
         o16xOKhAhLiJL5gdd8Qxc5/w6th1bXqGO7afi4u8reRw7ByxufcOuUslNv2/qYUSj8Cd
         UMAg==
X-Forwarded-Encrypted: i=1; AJvYcCUszEDgIPnX5iWfdWbTAbvigjQWIiFFn3rBwU6CVJLfqArpWkuuxcNPpAkV4II/W2KvxENPGLPO2sCb9Q==@vger.kernel.org, AJvYcCXdBixvijg3JG9PUsfKyYDWmHEZqe7qAnfk1SOJE19LLFkLEXMLMGgho60Wp5VNcwPvTfUc7FlwOiXE7Gs=@vger.kernel.org, AJvYcCXfqxJxeptLXNjLI6ZS63vTNAAK72CxPERoBRkOJv10Msae2z4m6w+upFo/LYzbmqSNmy0A7L4b@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ65IfjJ5tit8VyJPYPT1vTnGpvQ0cvt1PEnXHhqBf4SuXKhed
	EhL8nDV2asXrlXlWAUsPyXmFbaviJbYVL7lewSjPAFOC0/Qj6l/IyoFN
X-Gm-Gg: ASbGncvSnlszO/B6k+0JNjtMxpPOxMNT/JFQ50Hr9j84Fx5joQZu7tRlbwiBknU4PcJ
	YW7jIZ3oo8lrAI8b9ozyeHf/cqdyedjQLjWYqb5lB+AJoZogyssIcxWtc16oY+47TO6Pm6ES0zh
	y0iJPyXMh06eSQ1ZUswS7XpntZNcRHX+hDVm9Ik+t+5/wSPyr6aaHPay9fGSe28kVr7EibFlphm
	Wx/FlWKur+mTBAm2eV9JhoaD4JMwCoCFe+MiJ69yrr+decZNjOS/2Q40bEsLxlvW1+CvMxw1Trh
	MbHdurSX/GJAVk5dRxxqG+Jbkn6n4GxX0lX10n3XLJmwDOB5W3E3hekDJk13YX/hq6ZtgdKrL1j
	fga6KVzyLz4bIYU8IUSddnlYSFb4NgrmHOFJGLUXxP5O5AQ==
X-Google-Smtp-Source: AGHT+IExkFnPTAzEGPeXGOfNTRcREXfiOVv3L9yGaGgBypj79FXTZIOh2KKjDnvcGk6D+ioH35KIZA==
X-Received: by 2002:a05:6a00:21c1:b0:76b:c9b9:a11b with SMTP id d2e1a72fcca58-7702f9d8b5fmr16038637b3a.3.1756147286879;
        Mon, 25 Aug 2025 11:41:26 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77040249e37sm8155142b3a.105.2025.08.25.11.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 11:41:26 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	stable@vger.kernel.org
Subject: [PATCH v10 1/3] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Tue, 26 Aug 2025 00:09:38 +0530
Message-ID: <20250825183940.13211-2-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
References: <20250825183940.13211-1-abinashsinghlalotra@gmail.com>
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

Fixes: 804e498e0496 ("sd: convert to the atomic queue limits API")
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>

---
 drivers/scsi/sd.c | 50 ++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5b8668accf8e..bf12e23f1212 100644
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
@@ -3711,6 +3711,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (!scsi_device_online(sdp))
 		goto out;
 
+	lim = kmalloc(sizeof(*lim), GFP_KERNEL);
+	if (!lim)
+		goto out;
+
 	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
 	if (!buffer) {
 		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
@@ -3720,14 +3724,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
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
@@ -3741,17 +3745,17 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
 
@@ -3761,47 +3765,46 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
@@ -3820,7 +3823,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
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

