Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BBF8263F5B;
	Fri,  8 Aug 2025 11:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754652625; cv=none; b=QFshhEa4twSxktbmJIACrXVccPJ3xtXfXYnwa6gE8vn1HVh7zgXU6Qz0rCSN1lLWJGR6ERPUVDnbxhm65ddIhVs/Os/7f+y6UZYfTqAulQkfEvv3N6HB8CtWJ/xd3m5QuguIlHFI4lusk9N3zNb1QIpw4vHXByC4V7vPlPM1+EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754652625; c=relaxed/simple;
	bh=SsMvM30SYj6cX+c/wWvwUItwk2LdyiCMmxxYQTSWjng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WDU0DawO3HxRMYimJWdmsvDBUaFkOm0aGj+/Ty6P1TZWYO0nkBR6zcvQG8wDul9OloXBqGxwXxZHGOi1bKYRw2z3+X/n2hO+V4GeTOrbble5wBUZb/eNKLLoCNNysplMgqfM8rmmb/HIOvBe484FiJPiHwouqnx5F/pD8RpbIwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nPVAgae3; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nPVAgae3"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-23ffdea3575so13774165ad.2;
        Fri, 08 Aug 2025 04:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754652624; x=1755257424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tvjhEm/QJPiIZeCMqUAljSaKOUIt1RqnsZe65A29XyE=;
        b=nPVAgae3rwU0ICChedau8RbbFQYGEnex26/jctuYRO+mHcfWWi1TqlRZ0E5GVrpZqz
         UuyxVrvdrX96nO5e9i6nsknAd1+KrKr0nAcD0i1P730aGweRytrtDCIupBjEFMI3E4CB
         sTp8s2/sHzSuvmlU+fAU/bvL3SAyIgT/6NXX7vLND8UyEX5f3MXotgz1yMpJOBjVIdA+
         jAHkTLWX6VCBANiStSWs6v//DZzHW0ymyJfwrdvWWpQuQnXJVmkUQYU8O2a/Oxxp/j0L
         D3nLtiMbtaPNHWBsXzRektCPN/kqkn60RQ/qFQhctcdZ22aCZQIEAiETc7b2qstQO7Hk
         PMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754652624; x=1755257424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tvjhEm/QJPiIZeCMqUAljSaKOUIt1RqnsZe65A29XyE=;
        b=bUyu48c+JzuvbPgMjXxGjXnfbYDhkel+3wuuwx9rC3/dnlmHDa+DbKojXTS5F3i9fW
         o8g5Vx1LQaxelyIf+r2NbDGGivAp/IIUJfDgUCcRHMQXiuHbedy4lKRlJK7PBDHrSqms
         X/TBqaEVcwTZ7iPir6UAinCy/Z/U2eec6wgbgq830t2vNHqA5+3ZFbT1seApWH6GgFpr
         CaMTNOBQ63oQ4tZtUNuwpcakhfCJhs9uioUBM7bcEH/yhqaz4eO/s6oU+v2MBtQuROED
         BtXXf5O5kO8CDj6gKoB7Kp2O9uFLJ8Y4d9wbH7glmdRne7lkjRSbIQoiL0a/CYMigc1S
         c6kA==
X-Forwarded-Encrypted: i=1; AJvYcCUQeroGPERF4H82MpJFoROC2Hm8kfBBmkNBGMT6dJZqPMlox7XDUmuL/7XEWkCIlx59MGHdntudi8lUDA==@vger.kernel.org, AJvYcCVFbupcjVMkD5Akk2Ac/NbZDUOd+NV8GxkIloCJM4wcaePbq0IDPW174q40g1pv8PMftKS/40verEHKwh0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf00RtOKC8tqCehQLFTRi0rEuSPOwUpbWKCNdoHiTStNoTE49v
	B47a0FKB5rue4lUTUqZ1c3v6W4zqoy46TUDKuohMHG8f+m0MvY3iEIlc
X-Gm-Gg: ASbGncuCz8XhcLyq+A+vKE8LXrZbPzO9dMduEayuek1/aQCYvh/7fBOI3ZNuXBdRM/W
	26caOjWZ0X+5QwJQeSUrvqM2D76rnd4U3v2W19vtmdZangW56xCtIGyAI+gv+vuYfrzKBNOzkZM
	JrQ+Im4md8s2SlUyMPSrnKSqScKdkeOWFLG4HGE5NJ0a/JTRRmbcJ9C4bLn+oprKeq23rj62pu7
	o41roTlxpCxww6Xn6UwMU2gRkCTZ31znsnHtBrn8RiMmlw2rR+U91mb9sae3HS1bxVAO2KL9VvJ
	P6pmjiz5om1hODhKjC4nlufutcxasbtdYmNLK1+AwUaRWeh9mG8QVbhJriCWIztzQ++tJwHch9d
	JldIGyZLfOO4hAuFecD6u1uS+GVmajYGD
X-Google-Smtp-Source: AGHT+IFwwv0xHCgeTYDcts5UmvkrTaBXq7KWdrxrZnWdk6kUpgDqFfgecg9n1avUChSn/p0Z0tAhnA==
X-Received: by 2002:a17:903:1b4c:b0:242:9be2:102b with SMTP id d9443c01a7336-242c19a5030mr42100345ad.0.1754652623381;
        Fri, 08 Aug 2025 04:30:23 -0700 (PDT)
Received: from avinash ([2406:8800:9014:d938:f647:9d6a:9509:bc41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e8aaa829sm207024455ad.149.2025.08.08.04.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:30:22 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: dlemoal@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v3] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Fri,  8 Aug 2025 17:00:19 +0530
Message-ID: <20250808113019.20177-2-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250808113019.20177-1-abinashsinghlalotra@gmail.com>
References: <5cfefec0-b64b-4f96-a943-4de3205d3c50@kernel.org>
 <20250808113019.20177-1-abinashsinghlalotra@gmail.com>
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

Hi ,

As I mentioned in v2,.. this is the corresponding
v3 of that. Only difference is in using __free() attribute
Please infor  me which one is better.

changelog v2->v3:
	used __free(kfree) attribute.
	no extra goto statements (i.e `free_lim`)

lim was initialized to NULL because there is a return path
before its allocation. Early exit will pass uninitlized pointer to
`kfree`.
We could move the allocation earlier, before this check:

			if (!scsi_device_online(sdp))
    			goto out;
However, doing so would result in unnecessary allocation
if the device is not online, leading to wasted resources.

Thanks,
---
 drivers/scsi/sd.c | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4a68b2ab2804..50abbab7e27a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -34,6 +34,7 @@
  */
 
 #include <linux/bio-integrity.h>
+#include <linux/cleanup.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
@@ -3696,7 +3697,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
 	sector_t old_capacity = sdkp->capacity;
-	struct queue_limits lim;
+	struct queue_limits *lim __free(kfree) = NULL;
 	unsigned char *buffer;
 	unsigned int dev_max;
 	int err;
@@ -3711,6 +3712,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
@@ -3720,14 +3728,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
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
@@ -3741,17 +3749,17 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
 
@@ -3761,45 +3769,45 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
+	err = queue_limits_commit_update_frozen(sdkp->disk->queue, lim);
 	if (err)
 		return err;
 
-- 
2.50.1

