Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27260186A;
	Thu,  7 Aug 2025 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754591365; cv=none; b=JjMaVwFqpR01IVrnvl/UsGwfV66KUay20QNAh0iFrRIO6Td0V9LP1LunTj1ohTUZePXEBqgTt/QlsQn/mc+KtJJ4WSv2mXc/w7DQikRTLLqYT/hZk4T4ql/puTUAKUcOEzIzmpZwNLELooub+FfK2vhLl9pkyQdriIHQpj5Uu7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754591365; c=relaxed/simple;
	bh=0MjuKQe8s182P5fSAkQSVzVV7ppG+0BIhgH4H7HpCyU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bOfA1J6I29I3cDBH0qjOfDh+kGkO7rnfoeZOGgIMTP9RxL305kBOJi8NHiIPqfaFGSUcV67RXDWqNnJP6vl7s+MbijDchT8rL5wirZ8giSoCR72rNPslvNAjZ8oaXHwM6uMoZMP2e/fYSOsBWT1VYjIw3vsvbd/u2BLlzvatSnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RF1kC5Ba; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RF1kC5Ba"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-23dc5bcf49eso14925945ad.2;
        Thu, 07 Aug 2025 11:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754591363; x=1755196163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PXpLzh9f2OcRoQYEADq7bQNjN64p9yrTziTkYXi0ngg=;
        b=RF1kC5Ba0Da5wapBT1FxQhE4rFsJi5Jov9SMq+IKq4lUj5w7m67EiMAHqGjcOEEuDE
         NrlhzcUeV0p/E1OByDuvN/NnBojd9P0qHskYMgbLNnWHnZjtXNSyVPGA5FV5yzi0Hlij
         b27fRBJnx1P5Xmm6zeW45XA73XMUKsqUVyxFqAQHuPaF4bQBXqSjDIPmH4xYEoDzeQtR
         u1qKFBUsF+EsLJqvQ5ND4L6srlmsxj/JcmKm+GdtbDlh5zT9W7bcMprrs83IgNUliSb7
         VzccyWc+5eEofIswjrRQftUvzxa25pcBgGQZEVWP57KecoEN1uf5WDOI0+x4JY7oupsH
         Y+lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754591363; x=1755196163;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PXpLzh9f2OcRoQYEADq7bQNjN64p9yrTziTkYXi0ngg=;
        b=hSVU0ipZ64jcLnQ7R7gcFVsfmPur4VlRzINruVhHe1M0YcpJ23N7Fh/wdkGI5zNJVJ
         DxwWQvRb+tNYOy9lGU+J83CsHEm3t2oSY+h12EN4n8U304527qUemkFeAuzNZAkSfqmz
         y5+foSx1QMjrq/RHe+6Ni4+I/Xxp1DVJvbAhUUGf2Bk6BPWyPo1ybwNFMDO7STLZcaOL
         FtQ/CJYhluuXkIZuad2LmBaQqChnqXz6pNjeAnp7x5cg2q7HAqRauDCrQtpCeS4kvo7g
         K8/RVYOBXTtQ8aTXWno5q7sUt+Mg1UDAC2YjN82dWh4ZwVKctBfJoQlj8toy6dwUXN0Q
         h7PA==
X-Forwarded-Encrypted: i=1; AJvYcCWV5iOn9z0RihBRK/IW7dEzToiQAjzH8D1SJbzL0wPfiJ5G+clzHNbP0RcKnunmyAxKlYkuXvlh8/QGQg==@vger.kernel.org, AJvYcCXV6wEB9xlVdXOEMCQW+MMLcYMGqPoZ5xrymL56JfkB8gNRs14l55esUv+aaM26bVtXe2E2gaZxcFcK53s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBPMht29fTK2pckJzRlNxXfev4MEMwgjeai618L3EW0HutbglU
	zc39cwdhYUcu5V4ocsar7M9G7biNvIaoXy/5LeTCP28CiP90RE/wCJdL
X-Gm-Gg: ASbGncuMaqggJ6afHghClbYLjXi4WmL6hxrA+czKPHr/JkLiwiOqxKsM3SpAo3OIoJz
	4byaA1CAN57N+XNPUbd50T3B6DeuOHmiOztJrrT3cx5l/gYod4Z4GD0KTBKDVhtJ9a20UPWqwzx
	eLKSKN9ilwiO+jXP55PC055JAMVj5W52fzSVCRp3GJ5Z/OgnHBRm2spnVrc7M97Bssp365jl3A4
	Av975QpZ2RJLj3jOfwSQ+qXlFnEs+UHjSMeZQARTQTshqiplji17B3qPaNNu3evuZxlQtN4sb8o
	z7WWX3FJahbdj06jQxL0T3v2ZMWTw4rmaC29YFL73LUu83IggEO1IFvQsFAMQTtZLXNK6qpVqai
	kM7OIBJGaBQ16wm5552ArJIJkpC0vi5L/
X-Google-Smtp-Source: AGHT+IEy6szDYvTpU5CXrnpu3V8cht2UYWOWNUxx22SUkuhwuo/Zno/RTiNiAgDk+fvXMjq2JtYryQ==
X-Received: by 2002:a17:902:c992:b0:220:c164:6ee1 with SMTP id d9443c01a7336-242c21dd9c0mr219435ad.32.1754591363281;
        Thu, 07 Aug 2025 11:29:23 -0700 (PDT)
Received: from avinash ([2406:8800:9014:d938:f647:9d6a:9509:bc41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f0f603sm191567695ad.48.2025.08.07.11.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 11:29:22 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abinash Singh <abinashsinghlalotra@gmail.com>
Subject: [PATCH RFC] scsi: sd: Fix build warning in sd_revalidate_disk()
Date: Fri,  8 Aug 2025 00:00:00 +0530
Message-ID: <20250807183000.31465-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.50.1
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
This was further confirmed by compiling sd.c with -fstack-usage flag

Before: drivers/scsi/sd.c:3694:12:sd_revalidate_disk.isra 1248 dynamic,bounded
After:  drivers/scsi/sd.c:3695:12:sd_revalidate_disk.isra  840 dynamic,bounded

Already we had a heap allocation in this function so I think  we can do this
without any issues.
I have followed the same pattern on allocation failure as done for
`buffer`.

This function appears stable; if it's not under active development,
we may consider cleaning up unused goto statements in a follow-up patch.

Thanks For your valuable Time

Best regards
Abinash
---
 drivers/scsi/sd.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4a68b2ab2804..a03844400e51 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -34,6 +34,7 @@
  */
 
 #include <linux/bio-integrity.h>
+#include <linux/cleanup.h>
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/kernel.h>
@@ -3696,11 +3696,16 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
 	sector_t old_capacity = sdkp->capacity;
-	struct queue_limits lim;
 	unsigned char *buffer;
 	unsigned int dev_max;
 	int err;
 
+	struct queue_limits *lim __free(kfree) = kmalloc(sizeof(*lim), GFP_KERNEL);
+	if (!lim) {
+		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory allocation failure.\n");
+		goto out;
+	}
+
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
 
@@ -3720,14 +3726,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 
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
@@ -3741,17 +3747,17 @@ static int sd_revalidate_disk(struct gendisk *disk)
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
 
@@ -3761,45 +3767,45 @@ static int sd_revalidate_disk(struct gendisk *disk)
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

