Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C08C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 06:57:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98CAC206FA
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 06:57:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fgsw5nsN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbgHZG56 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 02:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgHZG55 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2020 02:57:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8838CC061574;
        Tue, 25 Aug 2020 23:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=12Me2fnCJHLC/IITzDaJirH7w3xFqBD78HI1UZkOi5M=; b=Fgsw5nsNlS1i5OaZCwIfopqf4O
        EHLLgr2K/ZiDEPL5IrulPBLcrfHKXnwXXTazy+9fzDRNhr0/4bsjNH3JDpxKNrL0sjRoagBFaGLFC
        raJIMvTBgAw7ncUr90H33prmHnn98Jq+YNngVUE1kIDT9jFnf8H1MlmqMyOQK+3s61ivO8MmHPKZE
        O/gadQlL7HEFyQoi3hggRPHh0e6fD/b3bcAmF6r67xOa9RzkLqpysZ/1n2GdIoEAGljHD017ogKzE
        mjLQgHjsmO6NjULIQ6QRAgf2q0KZEUJz7+9rdplr7XITqdjESd8BUi2/VrQpbNoLSfWDpBHpCTAQw
        OD+HO5wA==;
Received: from 213-225-6-196.nat.highway.a1.net ([213.225.6.196] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kApNH-0003cq-PT; Wed, 26 Aug 2020 06:57:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: [PATCH 14/19] floppy: use a separate gendisk for each media format
Date:   Wed, 26 Aug 2020 08:24:41 +0200
Message-Id: <20200826062446.31860-15-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826062446.31860-1-hch@lst.de>
References: <20200826062446.31860-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The floppy driver usually autodetects the media when used with the
normal /dev/fd? devices, which also are the only nodes created by udev.
But it also supports various aliases that force a given media format.
That is currently supported using the blk_register_region framework
which finds the floppy gendisk even for a 'mismatched' dev_t.  The
problem with this (besides the code complexity) is that it creates
multiple struct block_device instances for the whole device of a
single gendisk, which can lead to interesting issues in code not
aware of that fact.

To fix this just create a separate gendisk for each of the aliases
if they are accessed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/floppy.c | 154 ++++++++++++++++++++++++++---------------
 1 file changed, 97 insertions(+), 57 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index a563b023458a8b..adf2b4dbd1ea09 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -402,7 +402,6 @@ static struct floppy_drive_params drive_params[N_DRIVE];
 static struct floppy_drive_struct drive_state[N_DRIVE];
 static struct floppy_write_errors write_errors[N_DRIVE];
 static struct timer_list motor_off_timer[N_DRIVE];
-static struct gendisk *disks[N_DRIVE];
 static struct blk_mq_tag_set tag_sets[N_DRIVE];
 static struct block_device *opened_bdev[N_DRIVE];
 static DEFINE_MUTEX(open_lock);
@@ -477,6 +476,8 @@ static struct floppy_struct floppy_type[32] = {
 	{ 3200,20,2,80,0,0x1C,0x00,0xCF,0x2C,"H1600" }, /* 31 1.6MB 3.5"    */
 };
 
+static struct gendisk *disks[N_DRIVE][ARRAY_SIZE(floppy_type)];
+
 #define SECTSIZE (_FD_SECTSIZE(*floppy))
 
 /* Auto-detection: Disk type used until the next media change occurs. */
@@ -4109,7 +4110,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 
 	new_dev = MINOR(bdev->bd_dev);
 	drive_state[drive].fd_device = new_dev;
-	set_capacity(disks[drive], floppy_sizes[new_dev]);
+	set_capacity(disks[drive][ITYPE(new_dev)], floppy_sizes[new_dev]);
 	if (old_dev != -1 && old_dev != new_dev) {
 		if (buffer_drive == drive)
 			buffer_track = -1;
@@ -4577,15 +4578,58 @@ static bool floppy_available(int drive)
 	return true;
 }
 
-static struct kobject *floppy_find(dev_t dev, int *part, void *data)
+static int floppy_alloc_disk(unsigned int drive, unsigned int type)
 {
-	int drive = (*part & 3) | ((*part & 0x80) >> 5);
-	if (drive >= N_DRIVE || !floppy_available(drive))
-		return NULL;
-	if (((*part >> 2) & 0x1f) >= ARRAY_SIZE(floppy_type))
-		return NULL;
-	*part = 0;
-	return get_disk_and_module(disks[drive]);
+	struct gendisk *disk;
+	int err;
+
+	disk = alloc_disk(1);
+	if (!disk)
+		return -ENOMEM;
+
+	disk->queue = blk_mq_init_queue(&tag_sets[drive]);
+	if (IS_ERR(disk->queue)) {
+		err = PTR_ERR(disk);
+		disk->queue = NULL;
+		put_disk(disk);
+		return err;
+	}
+
+	blk_queue_bounce_limit(disk->queue, BLK_BOUNCE_HIGH);
+	blk_queue_max_hw_sectors(disk->queue, 64);
+	disk->major = FLOPPY_MAJOR;
+	disk->first_minor = TOMINOR(drive) | (type << 2);
+	disk->fops = &floppy_fops;
+	disk->events = DISK_EVENT_MEDIA_CHANGE;
+	if (type)
+		sprintf(disk->disk_name, "fd%d_type%d", drive, type);
+	else
+		sprintf(disk->disk_name, "fd%d", drive);
+	/* to be cleaned up... */
+	disk->private_data = (void *)(long)drive;
+	disk->flags |= GENHD_FL_REMOVABLE;
+
+	disks[drive][type] = disk;
+	return 0;
+}
+
+static DEFINE_MUTEX(floppy_probe_lock);
+
+static void floppy_probe(dev_t dev)
+{
+	unsigned int drive = (MINOR(dev) & 3) | ((MINOR(dev) & 0x80) >> 5);
+	unsigned int type = (MINOR(dev) >> 2) & 0x1f;
+
+	if (drive >= N_DRIVE || !floppy_available(drive) ||
+	    type >= ARRAY_SIZE(floppy_type))
+		return;
+
+	mutex_lock(&floppy_probe_lock);
+	if (!disks[drive][type]) {
+		if (floppy_alloc_disk(drive, type) == 0)
+			add_disk(disks[drive][type]);
+	}
+	mutex_unlock(&floppy_probe_lock);
 }
 
 static int __init do_floppy_init(void)
@@ -4607,33 +4651,25 @@ static int __init do_floppy_init(void)
 		return -ENOMEM;
 
 	for (drive = 0; drive < N_DRIVE; drive++) {
-		disks[drive] = alloc_disk(1);
-		if (!disks[drive]) {
-			err = -ENOMEM;
+		memset(&tag_sets[drive], 0, sizeof(tag_sets[drive]));
+		tag_sets[drive].ops = &floppy_mq_ops;
+		tag_sets[drive].nr_hw_queues = 1;
+		tag_sets[drive].nr_maps = 1;
+		tag_sets[drive].queue_depth = 2;
+		tag_sets[drive].numa_node = NUMA_NO_NODE;
+		tag_sets[drive].flags = BLK_MQ_F_SHOULD_MERGE;
+		err = blk_mq_alloc_tag_set(&tag_sets[drive]);
+		if (err)
 			goto out_put_disk;
-		}
 
-		disks[drive]->queue = blk_mq_init_sq_queue(&tag_sets[drive],
-							   &floppy_mq_ops, 2,
-							   BLK_MQ_F_SHOULD_MERGE);
-		if (IS_ERR(disks[drive]->queue)) {
-			err = PTR_ERR(disks[drive]->queue);
-			disks[drive]->queue = NULL;
+		err = floppy_alloc_disk(drive, 0);
+		if (err)
 			goto out_put_disk;
-		}
-
-		blk_queue_bounce_limit(disks[drive]->queue, BLK_BOUNCE_HIGH);
-		blk_queue_max_hw_sectors(disks[drive]->queue, 64);
-		disks[drive]->major = FLOPPY_MAJOR;
-		disks[drive]->first_minor = TOMINOR(drive);
-		disks[drive]->fops = &floppy_fops;
-		disks[drive]->events = DISK_EVENT_MEDIA_CHANGE;
-		sprintf(disks[drive]->disk_name, "fd%d", drive);
 
 		timer_setup(&motor_off_timer[drive], motor_off_callback, 0);
 	}
 
-	err = register_blkdev(FLOPPY_MAJOR, "fd");
+	err = __register_blkdev(FLOPPY_MAJOR, "fd", floppy_probe);
 	if (err)
 		goto out_put_disk;
 
@@ -4641,9 +4677,6 @@ static int __init do_floppy_init(void)
 	if (err)
 		goto out_unreg_blkdev;
 
-	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
-			    floppy_find, NULL, NULL);
-
 	for (i = 0; i < 256; i++)
 		if (ITYPE(i))
 			floppy_sizes[i] = floppy_type[ITYPE(i)].size;
@@ -4671,7 +4704,7 @@ static int __init do_floppy_init(void)
 	if (fdc_state[0].address == -1) {
 		cancel_delayed_work(&fd_timeout);
 		err = -ENODEV;
-		goto out_unreg_region;
+		goto out_unreg_driver;
 	}
 #if N_FDC > 1
 	fdc_state[1].address = FDC2;
@@ -4682,7 +4715,7 @@ static int __init do_floppy_init(void)
 	if (err) {
 		cancel_delayed_work(&fd_timeout);
 		err = -EBUSY;
-		goto out_unreg_region;
+		goto out_unreg_driver;
 	}
 
 	/* initialise drive state */
@@ -4759,10 +4792,8 @@ static int __init do_floppy_init(void)
 		if (err)
 			goto out_remove_drives;
 
-		/* to be cleaned up... */
-		disks[drive]->private_data = (void *)(long)drive;
-		disks[drive]->flags |= GENHD_FL_REMOVABLE;
-		device_add_disk(&floppy_device[drive].dev, disks[drive], NULL);
+		device_add_disk(&floppy_device[drive].dev, disks[drive][0],
+				NULL);
 	}
 
 	return 0;
@@ -4770,30 +4801,27 @@ static int __init do_floppy_init(void)
 out_remove_drives:
 	while (drive--) {
 		if (floppy_available(drive)) {
-			del_gendisk(disks[drive]);
+			del_gendisk(disks[drive][0]);
 			platform_device_unregister(&floppy_device[drive]);
 		}
 	}
 out_release_dma:
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
-out_unreg_region:
-	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
+out_unreg_driver:
 	platform_driver_unregister(&floppy_driver);
 out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_put_disk:
 	destroy_workqueue(floppy_wq);
 	for (drive = 0; drive < N_DRIVE; drive++) {
-		if (!disks[drive])
+		if (!disks[drive][0])
 			break;
-		if (disks[drive]->queue) {
-			del_timer_sync(&motor_off_timer[drive]);
-			blk_cleanup_queue(disks[drive]->queue);
-			disks[drive]->queue = NULL;
-			blk_mq_free_tag_set(&tag_sets[drive]);
-		}
-		put_disk(disks[drive]);
+		del_timer_sync(&motor_off_timer[drive]);
+		blk_cleanup_queue(disks[drive][0]->queue);
+		disks[drive][0]->queue = NULL;
+		blk_mq_free_tag_set(&tag_sets[drive]);
+		put_disk(disks[drive][0]);
 	}
 	return err;
 }
@@ -5004,9 +5032,8 @@ module_init(floppy_module_init);
 
 static void __exit floppy_module_exit(void)
 {
-	int drive;
+	int drive, i;
 
-	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 	platform_driver_unregister(&floppy_driver);
 
@@ -5016,10 +5043,16 @@ static void __exit floppy_module_exit(void)
 		del_timer_sync(&motor_off_timer[drive]);
 
 		if (floppy_available(drive)) {
-			del_gendisk(disks[drive]);
+			for (i = 0; i < ARRAY_SIZE(floppy_type); i++) {
+				if (disks[drive][i])
+					del_gendisk(disks[drive][i]);
+			}
 			platform_device_unregister(&floppy_device[drive]);
 		}
-		blk_cleanup_queue(disks[drive]->queue);
+		for (i = 0; i < ARRAY_SIZE(floppy_type); i++) {
+			if (disks[drive][i])
+				blk_cleanup_queue(disks[drive][i]->queue);
+		}
 		blk_mq_free_tag_set(&tag_sets[drive]);
 
 		/*
@@ -5027,10 +5060,17 @@ static void __exit floppy_module_exit(void)
 		 * queue reference in put_disk().
 		 */
 		if (!(allowed_drive_mask & (1 << drive)) ||
-		    fdc_state[FDC(drive)].version == FDC_NONE)
-			disks[drive]->queue = NULL;
+		    fdc_state[FDC(drive)].version == FDC_NONE) {
+			for (i = 0; i < ARRAY_SIZE(floppy_type); i++) {
+				if (disks[drive][i])
+					disks[drive][i]->queue = NULL;
+			}
+		}
 
-		put_disk(disks[drive]);
+		for (i = 0; i < ARRAY_SIZE(floppy_type); i++) {
+			if (disks[drive][i])
+				put_disk(disks[drive][i]);
+		}
 	}
 
 	cancel_delayed_work_sync(&fd_timeout);
-- 
2.28.0

