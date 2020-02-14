Return-Path: <SRS0=bR62=4C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1763CC3B19D
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 14:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5EC92187F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 14:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbgBNODX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Feb 2020 09:03:23 -0500
Received: from mail.archive.org ([207.241.224.6]:60020 "EHLO mail.archive.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgBNODX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Feb 2020 09:03:23 -0500
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Feb 2020 09:03:22 EST
Received: from mail.archive.org (localhost [127.0.0.1])
        by mail.archive.org (Postfix) with ESMTP id 579221F8CC;
        Fri, 14 Feb 2020 13:54:50 +0000 (UTC)
Received: from archivecd-merlijn-development-nuc-1.fritz.box (a82-161-36-93.adsl.xs4all.nl [82.161.36.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: merlijn@archive.org)
        by mail.archive.org (Postfix) with ESMTPSA id 4A4921F267;
        Fri, 14 Feb 2020 13:54:48 +0000 (UTC)
From:   Merlijn Wajer <merlijn@wizzup.org>
To:     linux-scsi@vger.kernel.org
Cc:     Merlijn Wajer <merlijn@archive.org>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Merlijn Wajer" <merlijn@wizzup.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: sr: get rid of sr global mutex
Date:   Fri, 14 Feb 2020 14:54:32 +0100
Message-Id: <20200214135433.29448-1-merlijn@wizzup.org>
X-Mailer: git-send-email 2.17.1
X-Envelope-From: <merlijn@wizzup.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Merlijn Wajer <merlijn@archive.org>

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
 drivers/scsi/sr.c | 16 +++++++++-------
 drivers/scsi/sr.h |  2 ++
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 38ddbbfe5..6809fdcfd 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -77,7 +77,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
 	 CDC_MRW|CDC_MRW_W|CDC_RAM)
 
-static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt);
@@ -535,9 +534,9 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
 	scsi_autopm_get_device(sdev);
 	check_disk_change(bdev);
 
-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);
 	ret = cdrom_open(&cd->cdi, bdev, mode);
-	mutex_unlock(&sr_mutex);
+	mutex_unlock(&cd->lock);
 
 	scsi_autopm_put_device(sdev);
 	if (ret)
@@ -550,10 +549,10 @@ static int sr_block_open(struct block_device *bdev, fmode_t mode)
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
@@ -564,7 +563,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	void __user *argp = (void __user *)arg;
 	int ret;
 
-	mutex_lock(&sr_mutex);
+	mutex_lock(&cd->lock);
 
 	ret = scsi_ioctl_block_when_processing_errors(sdev, cmd,
 			(mode & FMODE_NDELAY) != 0);
@@ -594,7 +593,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	scsi_autopm_put_device(sdev);
 
 out:
-	mutex_unlock(&sr_mutex);
+	mutex_unlock(&cd->lock);
 	return ret;
 }
 
@@ -700,6 +699,7 @@ static int sr_probe(struct device *dev)
 	disk = alloc_disk(1);
 	if (!disk)
 		goto fail_free;
+	mutex_init(&cd->lock);
 
 	spin_lock(&sr_index_lock);
 	minor = find_first_zero_bit(sr_index_bits, SR_DISKS);
@@ -1009,6 +1009,8 @@ static void sr_kref_release(struct kref *kref)
 
 	put_disk(disk);
 
+	mutex_destroy(&cd->lock);
+
 	kfree(cd);
 }
 
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index a2bb7b8ba..339c624e0 100644
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
2.17.1
