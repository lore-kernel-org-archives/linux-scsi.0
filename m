From: Otto Meta <otto.kernel.02e4af24@sister-shadow.de>
Subject: [PATCH] [SCSI] sr: Fix multi-drive performance by using per-device
 mutexes
Date: Tue, 01 Jan 2013 15:20:10 +0100
Message-ID: <50E2F09A.6030606@sister-shadow.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.planet-school.de ([194.116.187.5]:56956 "EHLO
	turboconrad.planet-school.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239Ab3AAOaH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jan 2013 09:30:07 -0500
Received: from turboconrad.planet-school.de (srv004.service.ps-server.net [194.116.186.79])
	by turboconrad.planet-school.de (Postfix) with ESMTP id D547EB6A01F
	for <linux-scsi@vger.kernel.org>; Tue,  1 Jan 2013 15:20:12 +0100 (CET)
Received: from [192.168.0.9] (i59F574B4.versanet.de [89.245.116.180])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: thisaccountwillneverbechecked@sister-shadow.de)
	by turboconrad.planet-school.de (Postfix) with ESMTPSA id A68E7B6A001
	for <linux-scsi@vger.kernel.org>; Tue,  1 Jan 2013 15:20:12 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The single mutex for the sr module, introduced as a BKL replacement,
globally serialises all sr ioctls, which hurts multi-drive performance.

This patch replaces sr_mutex with per-device mutexes in struct scsi_cd,
allowing concurrent ioctls on different sr devices.

Signed-off-by: Otto Meta <otto.kernel.02e4af24@sister-shadow.de>
---

This issue was discussed before, so here are some relevant archived messages:

sr_mutex was introduced as a BKL replacement:
"[PATCH 7/7] block: autoconvert trivial BKL users to private mutex"
https://lkml.org/lkml/2010/9/14/338

The resulting performance penalty was first mentioned here along with an
easy to reproduce demonstration, but apparently received no attention:
"scsi/sr - Impossible to write CDs/DVDs simultaneously (since BKL removal ?)"
https://lkml.org/lkml/2011/10/29/117

A while later, the problem was discussed in this thread:
"[PATCH] [SCSI] sr: fix multi-drive performance, remove BKL replacement"
https://lkml.org/lkml/2012/2/28/230

More discussion in this thread:
"Burning multiple DVDs at one time"
https://lkml.org/lkml/2012/3/15/558

A short summary of the discussion:
- The driver-global mutex serialises all sr ioctls because it's not released
  while the calling process sleeps, unlike the BKL.
- This hurts when using multiple drives, such as during burning or raw reads.
- Removing the mutex completely fixes the performance penalty but exposes
  some data to race conditions.
- Arnd Bergmann had an idea similar to mine, namely replacing sr_mutex
  with a per-device mutex inside of cdrom_device_info. James Bottomley and
  Stefan Richter agreed with that:
  https://lkml.org/lkml/2012/2/28/312

After running into the issue myself while using the CD recovery program
dvdisaster, I believe the following patch fixes the issue and should
provide the same safety as the previous sr_mutex.

Unlike Arnd's suggestion, this solution places the mutex in struct scsi_cd
and thus only affects the sr driver, not the cdrom driver.

sr.h and sr.c haven't seen any changes since at least 3.0.57 and I've
tested the patch with both 3.2.35 and 3.8-rc1.


diff -Naurp linux-3.8-rc1.orig/drivers/scsi/sr.c linux-3.8-rc1.fixed/drivers/scsi/sr.c
--- linux-3.8-rc1.orig/drivers/scsi/sr.c	2012-12-22 02:19:00.000000000 +0100
+++ linux-3.8-rc1.fixed/drivers/scsi/sr.c	2013-01-01 12:56:47.127203406 +0100
@@ -75,7 +75,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
 	 CDC_MRW|CDC_MRW_W|CDC_RAM)

-static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
@@ -511,24 +510,24 @@ static int sr_block_open(struct block_de
 	struct scsi_cd *cd;
 	int ret = -ENXIO;

-	mutex_lock(&sr_mutex);
 	cd = scsi_cd_get(bdev->bd_disk);
 	if (cd) {
+		mutex_lock(&cd->lock);
 		ret = cdrom_open(&cd->cdi, bdev, mode);
+		mutex_unlock(&cd->lock);
 		if (ret)
 			scsi_cd_put(cd);
 	}
-	mutex_unlock(&sr_mutex);
 	return ret;
 }

 static int sr_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);
 	cdrom_release(&cd->cdi, mode);
+	mutex_unlock(&cd->lock);
 	scsi_cd_put(cd);
-	mutex_unlock(&sr_mutex);
 	return 0;
 }

@@ -540,7 +539,7 @@ static int sr_block_ioctl(struct block_d
 	void __user *argp = (void __user *)arg;
 	int ret;

-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);

 	/*
 	 * Send SCSI addressing ioctls directly to mid level, send other
@@ -570,7 +569,7 @@ static int sr_block_ioctl(struct block_d
 	ret = scsi_ioctl(sdev, cmd, argp);

 out:
-	mutex_unlock(&sr_mutex);
+	mutex_unlock(&cd->lock);
 	return ret;
 }

@@ -660,6 +659,8 @@ static int sr_probe(struct device *dev)
 	if (!disk)
 		goto fail_free;

+	mutex_init(&cd->lock);
+
 	spin_lock(&sr_index_lock);
 	minor = find_first_zero_bit(sr_index_bits, SR_DISKS);
 	if (minor == SR_DISKS) {
@@ -722,6 +723,7 @@ static int sr_probe(struct device *dev)

 fail_put:
 	put_disk(disk);
+	mutex_destroy(&cd->lock);
 fail_free:
 	kfree(cd);
 fail:
@@ -958,6 +960,8 @@ static void sr_kref_release(struct kref

 	put_disk(disk);

+	mutex_destroy(&cd->lock);
+
 	kfree(cd);
 }

diff -Naurp linux-3.8-rc1.orig/drivers/scsi/sr.h linux-3.8-rc1.fixed/drivers/scsi/sr.h
--- linux-3.8-rc1.orig/drivers/scsi/sr.h	2012-12-22 02:19:00.000000000 +0100
+++ linux-3.8-rc1.fixed/drivers/scsi/sr.h	2013-01-01 12:56:47.127203406 +0100
@@ -19,6 +19,7 @@

 #include <linux/genhd.h>
 #include <linux/kref.h>
+#include <linux/mutex.h>

 #define MAX_RETRIES	3
 #define SR_TIMEOUT	(30 * HZ)
@@ -49,6 +50,7 @@ typedef struct scsi_cd {
 	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */

 	struct cdrom_device_info cdi;
+	struct mutex lock;
 	/* We hold gendisk and scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
 	struct kref kref;

-- 
Otto Meta
