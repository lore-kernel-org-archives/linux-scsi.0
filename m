Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F6C2749D6;
	Fri,  8 Aug 2025 11:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652612; cv=none; b=EvktDgnzVONeWHobni9i/frmkMtDhtiBLwKyokdVTBkLatBhiyKvblLBGCqlY5xtM/90WXrjgmhdop1S6rZ/Py9I6eZrWi1alD1kepOyQmXj9IpQF+JUOm+mMQ/JMaF8AFUK+Q6WP7ms/CMMdjMduGR2g++m/DDFA98UIOxOdmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652612; c=relaxed/simple;
	bh=iLjpoxLf0qOX77ifa4m8bxEY9uwoNlccTc4Gack3f+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H0HFfcpTRGIyU3/Unm8NHWBgMFfjh+MDrNNzI8d5PhWAZAAZ42a3hDrGxQHN7I6zGvnYFC4c6Y4H3rJt1I3ConDMqlf4HJLsDyrPFqGy+PBKzYHvaiNnjwBfYzcwQrqwd6ZfBwD0J6SvNWkLfY1QWWIj32DaFPyDCw6VqlPOQ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nnoDSKCM; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nnoDSKCM"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-23ffa7b3b30so18377575ad.1;
        Fri, 08 Aug 2025 04:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754652610; x=1755257410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xnq6/UX07eReMzK5ZN8hAJv9987nwdnK/ysZjlqefRM=;
        b=nnoDSKCMc7r4bMqBlb50BMhS2LBCZT+QKKXAAb3eBboPCciBllL1zh/wVRS5m2m3yQ
         RxyrjLuLQ/kK1U9cKYNyG8DDq7eBjzVKfxfqynBk7mWUjRIRfkPaz2EefdImUHDkXsxh
         b5Yd46yXM/XnUl7MPNOav+HxPAr7vka7SxSI0sq8oclQjzaOIBgeq19ufYeN1NK3G6G5
         SBCl0CVYfZnSMLZwoz5nVjVrIPEdhfh4R7/lCzrT4/OoymNsljpC23fgrNNORFx36IZd
         TAE7YxM0dMrwm+leVvQm2EMsK66MlS9E2UUEkUbOvcl9/s0bceDxZ4Okf336p7Fa/+ID
         tNeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652610; x=1755257410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xnq6/UX07eReMzK5ZN8hAJv9987nwdnK/ysZjlqefRM=;
        b=su9Lr5uoA6AHoG0nD8+OV9KZgM/fGwRPZYmY3vYfgJS+AX66n5bft4pzGG1SIKSUi+
         R7xKdtPs54wjJsW1+eI0kY6Q0pFnIQYHjGj87U45vVt+4iMdR90InRNb8RWNG1SN7RYe
         u1LkY6qDrKvmgjVBYgATLz0kZYNSSc0S9aBJGNBdrCa1tMJyL34NtE3K4XgsI8TTsJ1b
         aFbbjxu63RKOT26ZYXRTm3G+AR4HTzJR9NvsdDItel/nxqDFWGMSBL45XRGVbcGTfzsX
         H6nRswEKCuj1bU7Qmv4KPc07PC9TSySlPZQ4CJHn0YYlbB7jSVhMChxqC3K9nu/LoGi/
         E02g==
X-Forwarded-Encrypted: i=1; AJvYcCVmb4VHhcxof4CgUS4Fow+G7GlY7HNSskGzjKJiht18Pq6Vu9yK2c79VgCtSkpQlKUJ0fBjlP1I0cTrRk4=@vger.kernel.org, AJvYcCWoOznqsu4Wy6MMUSJBJ1H+cvNENeIXEmOrTTaDRBdluIqvKTXRGLeCE203IcpfJ1MTWVf/lLA4M5sQIw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0i/D+QMcHUF4Pn3s/J8/xyNiSt3ig4xHhh3IwS8fapTkdiiEc
	nR+GhtK3sFKQDkHIMp56XnwKCzktZ9ZchJRmFJ3hfJ690tnWIdZ2dEneT41+u3/H
X-Gm-Gg: ASbGncvCP/tcJqZKj9mlHcrug6TNqtOIN1xnLplrfs4z6EJuPNBVAknKs+FoqcrsCtE
	6hV7zO1A2XBQuMo7YbtndoF/hfUVnMWr5X/pkHL933pCCHri6a1wrvx89Jr50+5G6SiB736WVfu
	ULP4rAv/DqhDwerM3g/zPAGf96xYmS4CwQRtlvqA5b90QJnvHnVAivr1KZTg9H7MWQSWUMp5r9O
	JEs/6bMEGLomiMDZgYCCzDUzax/Ha+UTC8h8dBiZ4ez5rrdjG+w484qUfgJQh5WwcLCzyxaSKhw
	9YDFVelTvVE4XchoPH4ZN8/Y+VDJn7OzKxKmU/AsljSqaOzTuMEpasGStWR/ITKL2Xbqw5elsOM
	JZ08NmPd/kJky8SGju+z7EXsMEcKxwzhM
X-Google-Smtp-Source: AGHT+IFM6JtYCt41E1Kw64sQYV7xpp/Seh4jkDVJEc8ccJ0k1FBKGDFTpNKkKtkDGvfZhpUE/lI+gQ==
X-Received: by 2002:a17:903:41c7:b0:240:38ee:9434 with SMTP id d9443c01a7336-242c225adbbmr47664635ad.47.1754652609579;
        Fri, 08 Aug 2025 04:30:09 -0700 (PDT)
Received: from avinash ([2406:8800:9014:d938:f647:9d6a:9509:bc41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8aaa829sm207024455ad.149.2025.08.08.04.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:30:09 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: dlemoal@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v2] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Fri,  8 Aug 2025 17:00:18 +0530
Message-ID: <20250808113019.20177-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <5cfefec0-b64b-4f96-a943-4de3205d3c50@kernel.org>
References: <5cfefec0-b64b-4f96-a943-4de3205d3c50@kernel.org>
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

Hi,

Thank you very much for your comments.
I have addressed all your suggestions from v1.

As you mentioned concerns regarding the readability of
the __free(kfree) attribute, I have used the classic
approach in v2. Additionally, I will also send v3
where the __free() attribute is used instead.

We can proceed with patch version you
find more suitable, and do let me know if you have
any further feedback.

changelog v1->v2:
	moved declarations together
	avoided "unreadable" cleanup attribute
	splited long line
	changed the log message to diiferentiate with buffer allocation

Thanks,

---
 drivers/scsi/sd.c | 49 +++++++++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4a68b2ab2804..f5ab2a422df6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3696,7 +3696,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
 	sector_t old_capacity = sdkp->capacity;
-	struct queue_limits lim;
+	struct queue_limits *lim;
 	unsigned char *buffer;
 	unsigned int dev_max;
 	int err;
@@ -3711,23 +3711,30 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
 			  "allocation failure.\n");
-		goto out;
+		goto free_lim;
 	}
 
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
 
@@ -3761,47 +3768,49 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
+	sd_config_write_same(sdkp, lim);
 	kfree(buffer);
 
-	err = queue_limits_commit_update_frozen(sdkp->disk->queue, &lim);
-	if (err)
+	err = queue_limits_commit_update_frozen(sdkp->disk->queue, lim);
+	if (err) {
+		kfree(lim);
 		return err;
+	}
 
 	/*
 	 * Query concurrent positioning ranges after
@@ -3819,6 +3828,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	if (sd_zbc_revalidate_zones(sdkp))
 		set_capacity_and_notify(disk, 0);
 
+ free_lim:
+	kfree(lim);
  out:
 	return 0;
 }
-- 
2.50.1

