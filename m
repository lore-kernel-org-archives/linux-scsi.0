Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D030C34040
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 14:43:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F1D824656
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 14:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgBROnX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 09:43:23 -0500
Received: from mail.archive.org ([207.241.224.6]:60886 "EHLO mail.archive.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbgBROnW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Feb 2020 09:43:22 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Feb 2020 09:43:22 EST
Received: from mail.archive.org (localhost [127.0.0.1])
        by mail.archive.org (Postfix) with ESMTP id 64DB71FAF0;
        Tue, 18 Feb 2020 14:37:08 +0000 (UTC)
Received: from kgpe-d16.fritz.box (a82-161-36-93.adsl.xs4all.nl [82.161.36.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: merlijn@archive.org)
        by mail.archive.org (Postfix) with ESMTPSA id DD9731FAEF;
        Tue, 18 Feb 2020 14:37:06 +0000 (UTC)
From:   Merlijn Wajer <merlijn@archive.org>
To:     merlijn@wizzup.org, linux-scsi@vger.kernel.org
Cc:     Merlijn Wajer <merlijn@archive.org>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: sr: get rid of sr global mutex
Date:   Tue, 18 Feb 2020 15:39:17 +0100
Message-Id: <20200218143918.30267-1-merlijn@archive.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: <merlijn@archive.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When replacing the Big Kernel Lock in commit
2a48fc0ab24241755dc93bfd4f01d68efab47f5a ("block: autoconvert trivial
BKL users to private mutex"), the lock was replaced with a sr-wide lock.

This causes very poor performance when using multiple sr devices, as the
sr driver was not able to execute more than one command to one drive at
any given time, even when there were many CD drives available.

Replace the global mutex with per-sr-device mutex.

Someone tried this patch at the time, but it never made it
upstream, due to possible concerns with race conditions, but it's not
clear the patch actually caused those:

https://www.spinics.net/lists/linux-scsi/msg63706.html
https://www.spinics.net/lists/linux-scsi/msg63750.html

Also see

http://lists.xiph.org/pipermail/paranoia/2019-December/001647.html

Signed-off-by: Merlijn Wajer <merlijn@archive.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/sr.c | 20 +++++++++++---------
 drivers/scsi/sr.h |  2 ++
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0fbb8fe6e521..fe0e1c721a99 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -79,7 +79,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
 	 CDC_MRW|CDC_MRW_W|CDC_RAM)
 
-static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt);
@@ -536,9 +535,9 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 	scsi_autopm_get_device(sdev);
 	check_disk_change(bdev);
 
-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);
 	ret = cdrom_open(&cd->cdi, bdev, mode);
-	mutex_unlock(&sr_mutex);
+	mutex_unlock(&cd->lock);
 
 	scsi_autopm_put_device(sdev);
 	if (ret)
@@ -551,10 +550,10 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 static void sr_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);
 	cdrom_release(&cd->cdi, mode);
 	scsi_cd_put(cd);
-	mutex_unlock(&sr_mutex);
+	mutex_unlock(&cd->lock);
 }
 
 static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
@@ -565,7 +564,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);
 
 	ret = scsi_ioctl_block_when_processing_errors(sdev, cmd,
 			(mode & FMODE_NDELAY) != 0);
@@ -595,7 +594,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	scsi_autopm_put_device(sdev);
 
 out:
-	mutex_unlock(&sr_mutex);
+	mutex_unlock(&cd->lock);
 	return ret;
 }
 
@@ -608,7 +607,7 @@ static int sr_block_compat_ioctl(struct block_device *bdev, fmode_t mode, unsign
 	void __user *argp = compat_ptr(arg);
 	int ret;
 
-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);
 
 	ret = scsi_ioctl_block_when_processing_errors(sdev, cmd,
 			(mode & FMODE_NDELAY) != 0);
@@ -638,7 +637,7 @@ static int sr_block_compat_ioctl(struct block_device *bdev, fmode_t mode, unsign
 	scsi_autopm_put_device(sdev);
 
 out:
-	mutex_unlock(&sr_mutex);
+	mutex_unlock(&cd->lock);
 	return ret;
 
 }
@@ -745,6 +744,7 @@ static int sr_probe(struct device *dev)
 	disk = alloc_disk(1);
 	if (!disk)
 		goto fail_free;
+	mutex_init(&cd->lock);
 
 	spin_lock(&sr_index_lock);
 	minor = find_first_zero_bit(sr_index_bits, SR_DISKS);
@@ -1055,6 +1055,8 @@ static void sr_kref_release(struct kref *kref)
 
 	put_disk(disk);
 
+	mutex_destroy(&cd->lock);
+
 	kfree(cd);
 }
 
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index a2bb7b8bace5..339c624e04d8 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -20,6 +20,7 @@
 
 #include <linux/genhd.h>
 #include <linux/kref.h>
+#include <linux/mutex.h>
 
 #define MAX_RETRIES	3
 #define SR_TIMEOUT	(30 * HZ)
@@ -51,6 +52,7 @@ typedef struct scsi_cd {
 	bool ignore_get_event:1;	/* GET_EVENT is unreliable, use TUR */
 
 	struct cdrom_device_info cdi;
+	struct mutex lock;
 	/* We hold gendisk and scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
 	struct kref kref;
-- 
2.23.0
