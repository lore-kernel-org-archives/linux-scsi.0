Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8496C37F8A1
	for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 11:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776857666; cv=none; b=SnCvSVDsHNbyXh9vk/exEBctaMS/oS/7J9etNwqu1dwC9nQo1NahnGCeF+fO4jQIKth4U39pIFh6/G5/zQ5wrv8l6TAbY1XyBKKJM7QBIjQ8JweU8nRj5r/tma14Ubq01HxoX6l+GjzYao0B6bKW2gUJLBufONgV/QJemnbp2hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776857666; c=relaxed/simple;
	bh=cLfy64EuVOnwaGXZoYuyOvyOHLOMCKbuEPM3vcxEzP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLb4wwDsNrcsQdQ1IlJYF/83Ns0okFKsmNTqc8uPVddfw51iKbp6Ixrpv7M8r9vy6I1pcVaSQlgj7cK/PLR2P3bGlM/j7Om3EXT1RJBkyftQdfQ1nMvux7s/z7GUocARSjcW82sfev6Zf0qoIS668E/aPSRW6r2h1GuOECoEm4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J2J9Qo4L; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2J9Qo4L"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43d7badbd7dso2609545f8f.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2026 04:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776857662; x=1777462462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i6Btga714ZD4m11Og+xMBiLOEYrhnYNVJCJYEBm+MhQ=;
        b=J2J9Qo4LwXGtnnE0/JxBUq5qxq70msfQn7PXMZG+Y1zLeQ3HjCcE11uL2z84PlPGDm
         tSHP18XR5Y1u2YAXyqzkM6gEEyz2EBTa71/eaLishdAZPfTqyh+F0DJGKbVxVSHfX49j
         aZ9WyKLcBJaAb3m1jQxVClhpAwe6QQZCkG/TeLIFYOOBc8584nr+yeZ1nvaTz9lfwJn/
         hYJz3TWCFAwazIQrLI+Mv+zLTyxNR/1vbCAjajCVFMn+owziMkfVUzpkLvAAc4dHFMo8
         Y6Aw6/CaFDGeq/4GGJS2r7czW9MOqQuvyXlpLIth3gRVG3w8IaRxxmxsxIfamOUsxpAk
         cQZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776857662; x=1777462462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i6Btga714ZD4m11Og+xMBiLOEYrhnYNVJCJYEBm+MhQ=;
        b=os6JneO9O3B+m+Zcc3h5y+M8694Mj8igvBsrFHAxGlkq7i/QRAvdjtJeqofG2E3eRi
         X11YBvjJwU9tbQ8lB9VXAC2Fno/kJLdvYT/YnHRB2ZR04DBI7f0Qo40+n/D/PqKLw3IX
         Ts43nHP9J6oiEuTMkNxUDnNHLjP2w1zvVmQTgi5U/TaIDauZFZYY7zUQdEHyWiG42ln+
         +x8X4rdhL+ozUCWDHp79W/34kGB0ySL2boGX4agFK+Th7CBEyqZDFnMNs0OY9t5sP3mY
         E9pkv001xoq8s6s55z8qdsgSfe1fn0BJyeXyHpta5sZnRbBBH61Bb+zm86pYNuWXlATa
         Y5pQ==
X-Forwarded-Encrypted: i=1; AFNElJ8NahmcW0gPNpdjf0YSBGZVLukF/DZwWOlgfVXg8j+1bpWwyX5S7R8AASW66G9qdRBVIwxT0Pryvc0j@vger.kernel.org
X-Gm-Message-State: AOJu0YzhzrFx5MTpO6Pppi2EH4PXqVwZwcVAqV2/UBVkv8haKlMMp2LF
	tlPUkhiD0uid5ofwkg0na4a0RlvhVzscascGnRpzf2f5+4AzbjGibmxk
X-Gm-Gg: AeBDietuT9Hu59hDNl3qgTc8LqRE5J4tkrqA+Iw98z36WRLNr3jmZ1LtAsxl2PIxoXw
	//V4F3MVwemwb11HYTXmsMoRA1+zh8QcxR68V/S1+zjiKfQv+V0ogcHjSN8OyMgVRh5d9JuvQ95
	5IUYqiGTHBtk6Deknl2RWqv0wedTvpHWpn8EI7wIY0bwvHj9XmoS/gc2TcpxsyLFVIfRphoex0X
	3niTSSzbKObMpgoF/iv+9KJLflxOhmq4S8rXRFaL025wuWAv8GQ2VM7FNWLq6H1kbHAy7W0ehDn
	XuaV72mYbxGOxfHXrN7MIQlP90zi9pU214qfzs4GuDVYuNs4EgZh3Y2cdQIB6PyxmGVJLidSqc/
	2OcU0yodA8vUM0DdzIIArQDG/eru8F9AsbiW4itspIV6cX1uGAg8HCfq3kSY2wR7UbIeSacn6dl
	JQVDD7srswP1uxVXMlynpm4w8tJACMDSGcXgXDcGzASSZUwd/QooZ2JLwJNBeNCefKD40RKL2eJ
	49jYTp9L4jLJYvz6f5y9+OGK1Iy5XzD8Bhde9fsOyqwBC7cP2SwcyHzvIn+UvnoOg6wVklvPgGS
	t8GpuMV/TKJY
X-Received: by 2002:a05:6000:184b:b0:43d:6787:993b with SMTP id ffacd0b85a97d-43fe3db3c50mr34278591f8f.6.1776857661510;
        Wed, 22 Apr 2026 04:34:21 -0700 (PDT)
Received: from particle-0df3-d360 (d54C349CA.access.telenet.be. [84.195.73.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1249sm41959778f8f.5.2026.04.22.04.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 04:34:21 -0700 (PDT)
From: Daan De Meyer <daan.j.demeyer@gmail.com>
X-Google-Original-From: Daan De Meyer <daan@amutable.com>
To: phil@philpotter.co.uk,
	martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	axboe@kernel.dk,
	linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daan De Meyer <daan@amutable.com>
Subject: [PATCH v2] cdrom, scsi: sr: propagate read-only status to block layer via set_disk_ro()
Date: Wed, 22 Apr 2026 11:32:06 +0000
Message-ID: <20260422113206.246267-1-daan@amutable.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330133403.796330-1-daan@amutable.com>
References: <20260330133403.796330-1-daan@amutable.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The cdrom core never calls set_disk_ro() for a registered device, so
BLKROGET on a CD-ROM device always returns 0 (writable), even when the
drive has no write capabilities and writes will inevitably fail. This
causes problems for userspace that relies on BLKROGET to determine
whether a block device is read-only. For example, systemd's loop device
setup uses BLKROGET to decide whether to create a loop device with
LO_FLAGS_READ_ONLY. Without the read-only flag, writes pass through the
loop device to the CD-ROM and fail with I/O errors. systemd-fsck
similarly checks BLKROGET to decide whether to run fsck in no-repair
mode (-n).

The write-capability bits in cdi->mask come from two different sources:
CDC_DVD_RAM and CDC_CD_RW are populated by the driver from the MODE
SENSE capabilities page (page 0x2A) before register_cdrom() is called,
while CDC_MRW_W and CDC_RAM require the MMC GET CONFIGURATION command
and were only probed by cdrom_open_write() at device open time. This
meant that any attempt to compute the writable state from the full
mask at probe time was incorrect, because the GET CONFIGURATION bits
were still unset (and cdi->mask is initialized such that capabilities
are assumed present).

Fix this by factoring the GET CONFIGURATION probing out of
cdrom_open_write() into a new exported helper,
cdrom_probe_write_features(), and having sr call it from sr_probe()
right after get_capabilities() has populated the MODE SENSE bits.
register_cdrom() then calls set_disk_ro() based on the full
write-capability mask (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)
so the block layer reflects the drive's actual write support. The
feature queries used (CDF_MRW and CDF_RWRT via GET CONFIGURATION with
RT=00) report drive-level capabilities that are persistent across
media, so a single probe before register_cdrom() is sufficient and the
redundant probe at open time is dropped.

With set_disk_ro() now accurate, the long-vestigial cd->writeable flag
in sr can go: get_capabilities() used to set cd->writeable based on
the same four mask bits, but because CDC_MRW_W and CDC_RAM default to
"capability present" in cdi->mask and aren't touched by MODE SENSE,
the condition that gated cd->writeable was always true, making it
unconditionally 1. Replace the corresponding gate in sr_init_command()
with get_disk_ro(cd->disk), which turns a previously no-op check into
a real one and also catches kernel-internal bio writers that bypass
blkdev_write_iter()'s bdev_read_only() check.

The sd driver (SCSI disks) does not have this problem because it
checks the MODE SENSE Write Protect bit and calls set_disk_ro()
accordingly. The sr driver cannot use the same approach because the
MMC specification does not define the WP bit in the MODE SENSE
device-specific parameter byte for CD-ROM devices.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daan De Meyer <daan@amutable.com>
---
v1 was two separate patches:
  1. scsi: sr: propagate read-only status to block layer via set_disk_ro()
     https://lore.kernel.org/linux-scsi/20260330122124.755083-1-daan@amutable.com/
  2. scsi: sr: exclude CDC_MRW_W and CDC_RAM from writeable check
     https://lore.kernel.org/linux-scsi/20260330133403.796330-1-daan@amutable.com/

Changes since v1:
  - Addressed review feedback that the writable-state decision was split
    between sr.c and cdrom.c. Moved the MMC GET CONFIGURATION probing out
    of cdrom_open_write() into a new exported helper,
    cdrom_probe_write_features(), which sr_probe() calls right after
    get_capabilities(). register_cdrom() now computes the read-only state
    from the complete mask, so the whole decision lives in cdrom.c.
  - Since CDF_MRW and CDF_RWRT (GET CONFIGURATION with RT=00) report
    drive-level capabilities that are persistent across media, a single
    probe before register_cdrom() is sufficient; the redundant probe at
    open time is dropped rather than duplicated.
  - Squashed the two v1 patches into one commit to avoid a bisection
    window where sr's narrowed mask check disagreed with the yet-to-be-
    added cdrom.c logic.
  - Dropped sr's cd->writeable flag entirely. It was always set to 1 in
    practice (because CDC_MRW_W and CDC_RAM aren't populated by MODE
    SENSE and default to "present"), so the gate in sr_init_command()
    never rejected anything. Replaced with get_disk_ro(cd->disk), which
    is now accurate and also covers kernel-internal bio writers that
    bypass blkdev_write_iter()'s bdev_read_only() check.

 drivers/cdrom/cdrom.c | 73 ++++++++++++++++++++++++++++---------------
 drivers/scsi/sr.c     | 11 ++-----
 drivers/scsi/sr.h     |  1 -
 include/linux/cdrom.h |  1 +
 4 files changed, 51 insertions(+), 35 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index fc049612d6dc..62934cf4b10d 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -631,6 +631,16 @@ int register_cdrom(struct gendisk *disk, struct cdrom_device_info *cdi)
 
 	WARN_ON(!cdo->generic_packet);
 
+	/*
+	 * Propagate the drive's write support to the block layer so BLKROGET
+	 * reflects actual write capability. Drivers that use GET CONFIGURATION
+	 * features (CDC_MRW_W, CDC_RAM) must have called
+	 * cdrom_probe_write_features() before register_cdrom() so the mask is
+	 * complete here.
+	 */
+	set_disk_ro(disk, !CDROM_CAN(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM |
+				     CDC_CD_RW));
+
 	cd_dbg(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
 	mutex_lock(&cdrom_mutex);
 	list_add(&cdi->list, &cdrom_list);
@@ -742,6 +752,44 @@ static int cdrom_is_random_writable(struct cdrom_device_info *cdi, int *write)
 	return 0;
 }
 
+/*
+ * Probe write-related MMC features via GET CONFIGURATION and update
+ * cdi->mask accordingly. Drivers that populate cdi->mask from the MODE SENSE
+ * capabilities page (e.g. sr) should call this after those MODE SENSE bits
+ * have been set but before register_cdrom(), so that the full set of
+ * write-capability bits is known by the time register_cdrom() decides on the
+ * initial read-only state of the disk.
+ */
+void cdrom_probe_write_features(struct cdrom_device_info *cdi)
+{
+	int mrw, mrw_write, ram_write;
+
+	mrw = 0;
+	if (!cdrom_is_mrw(cdi, &mrw_write))
+		mrw = 1;
+
+	if (CDROM_CAN(CDC_MO_DRIVE))
+		ram_write = 1;
+	else
+		(void) cdrom_is_random_writable(cdi, &ram_write);
+
+	if (mrw)
+		cdi->mask &= ~CDC_MRW;
+	else
+		cdi->mask |= CDC_MRW;
+
+	if (mrw_write)
+		cdi->mask &= ~CDC_MRW_W;
+	else
+		cdi->mask |= CDC_MRW_W;
+
+	if (ram_write)
+		cdi->mask &= ~CDC_RAM;
+	else
+		cdi->mask |= CDC_RAM;
+}
+EXPORT_SYMBOL(cdrom_probe_write_features);
+
 static int cdrom_media_erasable(struct cdrom_device_info *cdi)
 {
 	disc_information di;
@@ -894,33 +942,8 @@ static int cdrom_is_dvd_rw(struct cdrom_device_info *cdi)
  */
 static int cdrom_open_write(struct cdrom_device_info *cdi)
 {
-	int mrw, mrw_write, ram_write;
 	int ret = 1;
 
-	mrw = 0;
-	if (!cdrom_is_mrw(cdi, &mrw_write))
-		mrw = 1;
-
-	if (CDROM_CAN(CDC_MO_DRIVE))
-		ram_write = 1;
-	else
-		(void) cdrom_is_random_writable(cdi, &ram_write);
-	
-	if (mrw)
-		cdi->mask &= ~CDC_MRW;
-	else
-		cdi->mask |= CDC_MRW;
-
-	if (mrw_write)
-		cdi->mask &= ~CDC_MRW_W;
-	else
-		cdi->mask |= CDC_MRW_W;
-
-	if (ram_write)
-		cdi->mask &= ~CDC_RAM;
-	else
-		cdi->mask |= CDC_RAM;
-
 	if (CDROM_CAN(CDC_MRW_W))
 		ret = cdrom_mrw_open_write(cdi);
 	else if (CDROM_CAN(CDC_DVD_RAM))
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7adb2573f50d..c36c54ecd354 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -395,7 +395,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 
 	switch (req_op(rq)) {
 	case REQ_OP_WRITE:
-		if (!cd->writeable)
+		if (get_disk_ro(cd->disk))
 			goto out;
 		SCpnt->cmnd[0] = WRITE_10;
 		cd->cdi.media_written = 1;
@@ -681,6 +681,7 @@ static int sr_probe(struct scsi_device *sdev)
 	error = -ENOMEM;
 	if (get_capabilities(cd))
 		goto fail_minor;
+	cdrom_probe_write_features(&cd->cdi);
 	sr_vendor_init(cd);
 
 	set_capacity(disk, cd->capacity);
@@ -899,14 +900,6 @@ static int get_capabilities(struct scsi_cd *cd)
 	/*else    I don't think it can close its tray
 		cd->cdi.mask |= CDC_CLOSE_TRAY; */
 
-	/*
-	 * if DVD-RAM, MRW-W or CD-RW, we are randomly writable
-	 */
-	if ((cd->cdi.mask & (CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) !=
-			(CDC_DVD_RAM | CDC_MRW_W | CDC_RAM | CDC_CD_RW)) {
-		cd->writeable = 1;
-	}
-
 	kfree(buffer);
 	return 0;
 }
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index dc899277b3a4..2d92f9cb6fec 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -35,7 +35,6 @@ typedef struct scsi_cd {
 	struct scsi_device *device;
 	unsigned int vendor;	/* vendor code, see sr_vendor.c         */
 	unsigned long ms_offset;	/* for reading multisession-CD's        */
-	unsigned writeable : 1;
 	unsigned use:1;		/* is this device still supportable     */
 	unsigned xa_flag:1;	/* CD has XA sectors ? */
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index b907e6c2307d..260d7968cf72 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -108,6 +108,7 @@ int cdrom_ioctl(struct cdrom_device_info *cdi, struct block_device *bdev,
 extern unsigned int cdrom_check_events(struct cdrom_device_info *cdi,
 				       unsigned int clearing);
 
+extern void cdrom_probe_write_features(struct cdrom_device_info *cdi);
 extern int register_cdrom(struct gendisk *disk, struct cdrom_device_info *cdi);
 extern void unregister_cdrom(struct cdrom_device_info *cdi);
 
-- 
2.53.0

