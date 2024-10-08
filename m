Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A4F140397;
	Tue,  8 Oct 2024 06:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728367473; cv=none; b=NMjo5LBgICI8cewaLDf2Ty6u7DwlmwVRc64VAMlvlCS9EGh4DBea6+5FlwP9pEEbYxrY7guKsx8QjtrIpeQOnN41yNk2txW/iQNhhA6DJOCwdcfExupqQhil0NxrWnMq6oBeRgEkxo6FK2HMBuY4hlIjJhAHONLDNG0B6VQoiSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728367473; c=relaxed/simple;
	bh=2VDGOU1UF9x1REP8K3aT23MKeCRS/5DYG8l+WSsNChY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jdf3wm4jCsNPjjbLLMvsxwLpNSmFqWqGOymrSGE1TdJgXz665FnH4s9aXq00QM2wgAn987NnjNpMi27Vn+ikEZXSHDEibVutrZRFukP8QgYgQjVntrtV+T+hJvlx+DBuAXoZ/Xav9qhj9NpZmUAs+xR3ZtKfk49WQOiD+CIBt8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=zqEmXC0h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="zqEmXC0h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=USmD65YsLOp+c45RKafd8RYVb5qCh+988Wrnx8Sr6eU=; b=zqEmXC0hJn7jlbXT+wpn3N05FT
	k40JcpZU7BUJdJZZUvpv9E8UsusUHkqYlDUtAdmBFK/9DeXKQuV6ae8ZoN3W32KsN4YUteUwZyG69
	wmEQFpxmhhCJsa1fIGKF0jxu5GCvj0htlpj7zJcht1f/e4+NMuvYeXqWpRRgjC63NPQVHm7WuJY5H
	/337dYlP6wkuAxgoQjUaUUDi4TyCTS79jgm40uQOm/HyX2YHwVFi+NnXjGXhC1H4c/C671RNlT0l2
	+T8/YcJcj5xF/Q7riM/wBVyYbVRFWBc4BDqW4+7nCjqNX3yfMXL6ZOLQ5amF2IGXxYeW3aIYvGS+S
	llGrTgLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1sy3Kg-00000004bwV-2oPK;
	Tue, 08 Oct 2024 06:04:30 +0000
Date: Mon, 7 Oct 2024 23:04:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: YangYang <yang.yang@vivo.com>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Subject: Re: block: del_gendisk() vs blk_queue_enter() race condition
Message-ID: <ZwTLbqLHvB9Q3f4b@infradead.org>
References: <20241003085610.GK11458@google.com>
 <b3690d1b-3c4f-4ec0-9d74-e09addc322ff@vivo.com>
 <20241008051948.GB10794@google.com>
 <20241008052617.GC10794@google.com>
 <ZwTJj5__g-4K8Hjz@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwTJj5__g-4K8Hjz@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Oct 07, 2024 at 10:56:31PM -0700, Christoph Hellwig wrote:
> CD layer code this can be relatively easily avoided while cleaning
> a lot of the code up.  Give me a little time to cook something up.

Actually..  It might be as simple as the patch below.  In addition
we should probably not do the door locking for a hot remove, but
the SCSI handling of hot removals could use some work in general.

---
From 74cf726f2f02d219778a90c7a99db7a57fb252ad Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 8 Oct 2024 08:01:17 +0200
Subject: sr: remove cd->lock

cd->lock is taken in sr_block_open, sr_block_release and sr_block_ioctl.
->open and ->release are synchronized by the block layer open_mutex,
and ->ioctl can only be called on live files and thus block devices.

So there is nothing that is actually protected by this lock, but on the
other hand it causes deadlocks when hot removing sr devices due to
the door locking called from cdrom_release.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sr.c | 14 +-------------
 drivers/scsi/sr.h |  1 -
 2 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 198bec87bb8e7c..cb89f7afc284e9 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -500,9 +500,7 @@ static int sr_block_open(struct gendisk *disk, blk_mode_t mode)
 			goto out;
 	}
 
-	mutex_lock(&cd->lock);
 	ret = cdrom_open(&cd->cdi, mode);
-	mutex_unlock(&cd->lock);
 out:
 	scsi_autopm_put_device(sdev);
 	if (ret)
@@ -514,10 +512,7 @@ static void sr_block_release(struct gendisk *disk)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
 
-	mutex_lock(&cd->lock);
 	cdrom_release(&cd->cdi);
-	mutex_unlock(&cd->lock);
-
 	scsi_device_put(cd->device);
 }
 
@@ -532,12 +527,10 @@ static int sr_block_ioctl(struct block_device *bdev, blk_mode_t mode,
 	if (bdev_is_partition(bdev) && !capable(CAP_SYS_RAWIO))
 		return -ENOIOCTLCMD;
 
-	mutex_lock(&cd->lock);
-
 	ret = scsi_ioctl_block_when_processing_errors(sdev, cmd,
 			(mode & BLK_OPEN_NDELAY));
 	if (ret)
-		goto out;
+		return ret;
 
 	scsi_autopm_get_device(sdev);
 
@@ -550,8 +543,6 @@ static int sr_block_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 put:
 	scsi_autopm_put_device(sdev);
-out:
-	mutex_unlock(&cd->lock);
 	return ret;
 }
 
@@ -574,7 +565,6 @@ static void sr_free_disk(struct gendisk *disk)
 	spin_unlock(&sr_index_lock);
 
 	unregister_cdrom(&cd->cdi);
-	mutex_destroy(&cd->lock);
 	kfree(cd);
 }
 
@@ -629,7 +619,6 @@ static int sr_probe(struct device *dev)
 					   &sr_bio_compl_lkclass);
 	if (!disk)
 		goto fail_free;
-	mutex_init(&cd->lock);
 
 	spin_lock(&sr_index_lock);
 	minor = find_first_zero_bit(sr_index_bits, SR_DISKS);
@@ -710,7 +699,6 @@ static int sr_probe(struct device *dev)
 	spin_unlock(&sr_index_lock);
 fail_put:
 	put_disk(disk);
-	mutex_destroy(&cd->lock);
 fail_free:
 	kfree(cd);
 fail:
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index dc899277b3a441..98e881775aa591 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -49,7 +49,6 @@ typedef struct scsi_cd {
 	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */
 
 	struct cdrom_device_info cdi;
-	struct mutex lock;
 	struct gendisk *disk;
 } Scsi_CD;
 
-- 
2.45.2

