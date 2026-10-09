Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7EC4E73D0;
	Fri,  9 Oct 2026 16:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791563234; cv=none; b=G8r9kHl00HjF8D+PClTkTZCgT1ee4dm173Q1w1f6iJ5hG2JMdCXAb5UfFZAxWla6eh8D+CnrQOf1GBv2FUFHMo4dNhKhX9a6e00Yqy8znU2nqJWCqkR0ejIWZri0EqRgeju3hG6P9WUK8644+ym0trJ4x/l9yKORguWmtmM6OGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791563234; c=relaxed/simple;
	bh=vMiatPndlhkBqXmcAakZkSekw3fuO9QHkXCPrUi5SuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VORbVjeDpBpdTbubPvQEOU2KtzIWfRW3ZpLX9nUS3yFCgzSU+AJnPVn5lQcu2sDK/bJYKF3UBLdchsldSvDJov7Nsv9Iw8QuPFVr9F/ovu4kzB0xqHTuwFd9mwYkFNa19Y8tLgV8nWQ4bMw973BGQJ0Srw7DeUiQuf57q2umjlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=Wa/YyHLU; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="Wa/YyHLU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1791563215;
	bh=vMiatPndlhkBqXmcAakZkSekw3fuO9QHkXCPrUi5SuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wa/YyHLU2wWSTTl4Pf5LHoc8VjtFyKf7qZmpnPjn/LPGuk4pYC4mU8QP0HloIjCvz
	 iD6Y581RaXictlNBwZ60owwRDoL5k/uVoHw3unzQ9Xn5vdXifARTz64wFDMQxfHaWM
	 LJ3EsuFz28bhbx1KMbYfcFCtLU9pvjlzLVS31frI=
Received: from wolf.philpem.me.uk (unknown [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 85329BE777;
	Fri,  9 Oct 2026 16:26:55 +0000 (UTC)
Received: from cheetah.homenet.philpem.me.uk (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 4441F5FC4B;
	Fri,  9 Oct 2026 17:26:55 +0100 (BST)
From: Phil Pemberton <philpem@philpem.me.uk>
To: linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Phil Pemberton <philpem@philpem.me.uk>
Subject: [PATCH v10 09/15] scsi: sr: retry unfinished media revalidation on the next open
Date: Fri,  9 Oct 2026 16:55:16 +0100
Message-ID: <20261009155522.593045-10-philpem@philpem.me.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009155522.593045-1-philpem@philpem.me.uk>
References: <20261009155522.593045-1-philpem@philpem.me.uk>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A media-change event can arrive while a new disc is spinning up.
Revalidation then returns before updating capacity and queue limits. If
there is no further event, later opens keep the old disc's capacity.
This occurs on a COMPAQ PD-1 LF-1195C after a CD to PD to CD swap.

Keep revalidation pending until it completes, including the queue-limits
update, and retry on the next open. This also covers a CD LUN that is
unready at probe. Access the flag during probe and serialized block opens.

For blocking opens, return -ENOMEDIUM if revalidation reports NOT READY
with ASC/ASCQ 04/01 (becoming ready), leaving the flag set. The drive can
become ready before cdrom_open() checks it again; failing this open
prevents access with stale capacity. sr_drive_status() already maps this
sense code to -ENOMEDIUM for CD-ROM data opens. Probe, nonblocking opens
and other sense results retain their existing behavior.

Initialize the sense header and only classify sense after a positive
SCSI command result. Host-side failures can return without filling the
header; preserve their existing retry behavior instead of interpreting
undefined or stale sense bytes as a becoming-ready response.

READ CAPACITY errors still use the existing fallback for audio CDs and
older drives. That fallback can retain stale capacity and clear the flag.

Assisted-by: LLM
Signed-off-by: Phil Pemberton <philpem@philpem.me.uk>
---
 drivers/scsi/sr.c | 29 ++++++++++++++++++++---------
 drivers/scsi/sr.h |  2 ++
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 28523b0eb659..044f4c250d88 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -473,16 +473,24 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	return BLK_STS_IOERR;
 }
 
-static int sr_revalidate_disk(struct scsi_cd *cd)
+static int sr_revalidate_disk(struct scsi_cd *cd, bool fail_if_becoming_ready)
 {
 	struct request_queue *q = cd->device->request_queue;
-	struct scsi_sense_hdr sshdr;
+	struct scsi_sense_hdr sshdr = {};
 	struct queue_limits lim;
-	int sector_size;
+	int sector_size, ret;
 
-	/* if the unit is not ready, nothing more to do */
-	if (scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
+	/* Keep revalidation pending if the medium is not ready yet. */
+	cd->needs_revalidate = true;
+	ret = scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr);
+	if (ret) {
+		/* Do not let a later readiness check admit stale geometry. */
+		if (ret > 0 && fail_if_becoming_ready && scsi_sense_valid(&sshdr) &&
+		    sshdr.sense_key == NOT_READY &&
+		    sshdr.asc == 0x04 && sshdr.ascq == 0x01)
+			return -ENOMEDIUM;
 		return 0;
+	}
 	sr_cd_check(&cd->cdi);
 	sector_size = get_sectorsize(cd);
 
@@ -491,7 +499,10 @@ static int sr_revalidate_disk(struct scsi_cd *cd)
 	lim.physical_block_size = sector_size;
 	lim.io_min = sector_size;
 	lim.features |= BLK_FEAT_ROTATIONAL;
-	return queue_limits_commit_update_frozen(q, &lim);
+	ret = queue_limits_commit_update_frozen(q, &lim);
+	if (!ret)
+		cd->needs_revalidate = false;
+	return ret;
 }
 
 static int sr_block_open(struct gendisk *disk, blk_mode_t mode)
@@ -504,8 +515,8 @@ static int sr_block_open(struct gendisk *disk, blk_mode_t mode)
 		return -ENXIO;
 
 	scsi_autopm_get_device(sdev);
-	if (disk_check_media_change(disk)) {
-		ret = sr_revalidate_disk(cd);
+	if (disk_check_media_change(disk) || cd->needs_revalidate) {
+		ret = sr_revalidate_disk(cd, !(mode & BLK_OPEN_NDELAY));
 		if (ret)
 			goto out;
 	}
@@ -700,7 +711,7 @@ static int sr_probe(struct scsi_device *sdev)
 	blk_pm_runtime_init(sdev->request_queue, dev);
 
 	dev_set_drvdata(dev, cd);
-	error = sr_revalidate_disk(cd);
+	error = sr_revalidate_disk(cd, false);
 	if (error)
 		goto unregister_cdrom;
 
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 2d92f9cb6fec..b718ac87e82d 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -48,6 +48,8 @@ typedef struct scsi_cd {
 	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */
 
 	struct cdrom_device_info cdi;
+	/* Protected by disk->open_mutex after probe. */
+	bool needs_revalidate;
 	struct mutex lock;
 	struct gendisk *disk;
 } Scsi_CD;
-- 
2.43.0

