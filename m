Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680B0311C12;
	Wed, 20 Aug 2025 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755701146; cv=none; b=Mv4Z1moy0HXQeKF0EIn9stEeNYHL4ODsQzZGU+4OsMFDn/hvzUqU8Q4o0Paqjsewpql5ODoEKYItThXA0krow0jSMOcy0nW/x3D3FXF1Q8yl26rq7YBdXODhx3YUFN3smVnQoDURbA75pSiU+I8MTpOmeRtag9g4Udfa7aXKCGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755701146; c=relaxed/simple;
	bh=fe41lB32Oh10wWCbqkDJs0Pq9X+qAGVlj6goLgwSWqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQyuuW8TfOe/O5/CiWAKZJnutlpOLoHeztZ6xY3uXsUNh0tGGVptzYcR2TGOr2qvqOfxpsBkyIFmMDwAQIoYJjzwJiqDlUoPWPD0/urwxhtS8z9JgpwTmgOULDHcvIzxIKo3yDjWkZLDTHdmQJBC/Np1hFDwLt0Gf2S6O3A14+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XYkTQNl5; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XYkTQNl5"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b4756244423so1375954a12.1;
        Wed, 20 Aug 2025 07:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755701144; x=1756305944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sxpCwxIELvNjCAaTMoBGgOHIELorPI5FNCVijFT18PU=;
        b=XYkTQNl5RkqVdu5cyY8QEA30rLEsztSzuf2oEDCgyxBTSn9QA7QEMFC4Ki5mtdMl6C
         CvvBJNuCDouFDdlMUbf1gJE8VO3DwDKE7Lzu8vMZPmGPv8K+RiAUwMR+0HJkBf/ZShCM
         jnki80HsbRzjXuz2Rnx3wG0dK1O+Crk8U1kNbtpNthVAfvuEluv5o2FKH9ZzWF0Ud8pR
         ysZc7iCoE2menUM+UoVuiY4wp1zCgi1WbHhqvkfs0st49OqEiaMFG6w177b0VmkFom7q
         KhHRqEp9Fy1eo2tynfjwM0jb/j0qyh5zkP15jp6/y2Yav1lDLTm1XOqyqJBwbrk5MiW8
         ty4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755701144; x=1756305944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sxpCwxIELvNjCAaTMoBGgOHIELorPI5FNCVijFT18PU=;
        b=vX3tVPoIlPY2MUZz23Vo6Ga337ZIoWkEPfclQGVjA/Cp8Wq2QNzDteCI3k1tqyaktU
         XUaaB5Hw5zmopdfDb3LC/N/R25gsBLmWZDqlZiUdRHGsDm6LWD5Xbnkhf86AGcHW42FO
         +G2Zzl+Ty04XElTzkrzLN4kEBcbn28W2c4Mbkx4LNl6tUBKivA7WqyzXrUZhhsElckez
         2h0POjNxnet34mlZAK73s8kpMrgcnJNPgzT/OBnVs1Vqx33jSJTFbq0wahFErAiTd/KH
         89zVyy5lAXIJqbkL+NLkHtS7pPtyVqkZDhCnWEKB4r6inqViazhoUv2ov+jOZ8rrV6MI
         /DBg==
X-Forwarded-Encrypted: i=1; AJvYcCUPgtL87rUoGHADNMfMfLOBMq100VaPgO/WUyUtHNuL6pGNWJbWqWtwI8cjG0dwZ+ZPWP6UAxdcLfIT+7k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDjqc8FQv3NiwPmWheJjfDFezsrJG3eA6esprDQjED1j50PnL/
	6JsP3SQEKZIdC8kJJEcJjt5fjgKyE6n66eHLi1+zrSuAnJ1oL8SY+KMd
X-Gm-Gg: ASbGncsqf/HblRblmlVW/6wXZfxFaBOR3tSZ/Y90d63gij6lYpyNcpKYUR8CmGLwuRS
	9ceYlkfi09ZRwo/KH9r3JLf6xUeXd958H3z7DLNZaztr/LHZRzPAUg67Nx3DSuzFqZ/seYRPJNJ
	sRfvr2EwM+mAiH2c1WHZO5cBLjVD+nghy8FPCa33awy3QYx3yGKy9HK3O3xW1IqC0RkVE0fGPkM
	ssQx50XTBJDtq88sloi0zan9x8SE/giL4UdmCy2MnJEJl5usR0JUg3FtT0lPopm7z3VoTZnPdy1
	ysMqKn6IBlP2BW0t1Ua6KBJmZKV2QyMoDrfbNkNS6hFk2O8jHUrF9S+VW+XOW17DaYIhZ0u+Hun
	s7ji5asJxkntyeHVQR/04mwUC2v1jC5Df+bpouRq04e6n/w==
X-Google-Smtp-Source: AGHT+IGx1boqfXxTBim0JmAGOzEBs4HTIroOl6OqmfHTN+3jPF5r+xAqjVBWI2VWY9uN+cvk1LRMtg==
X-Received: by 2002:a17:903:41ca:b0:234:1163:ff99 with SMTP id d9443c01a7336-245ef2588ebmr51484835ad.43.1755701143516;
        Wed, 20 Aug 2025 07:45:43 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-245ed379e92sm29197515ad.65.2025.08.20.07.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 07:45:43 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bvanassche@acm.org,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org
Subject: [PATCH v8 1/2] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Wed, 20 Aug 2025 20:15:09 +0530
Message-ID: <20250820144511.15329-2-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820144511.15329-1-abinashsinghlalotra@gmail.com>
References: <20250820144511.15329-1-abinashsinghlalotra@gmail.com>
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
 drivers/scsi/sd.c | 53 +++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 5b8668accf8e..453a27322517 100644
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
+	kfree(buffer);
+	kfree(lim);
+
+	return err;
 }
 
 /**
-- 
2.43.0

