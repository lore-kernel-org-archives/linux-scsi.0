Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F09FEC5DF9D
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D55FC20796
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 15:33:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gYvlcTi+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgJ2PdJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbgJ2Pco (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2020 11:32:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D41C0613CF;
        Thu, 29 Oct 2020 08:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=yS49rFVjKa2aLzbcYlCmU8pDGh23S07Hjpeo4KjNRhM=; b=gYvlcTi+q5Q1qjJg3baGpZHIn4
        fybfXcRLvVa3ol4rjl80k7VfyvvvfSpoHu72yqae788jI7jFf9LEZTmOrIzFXl3CpaZWN/vLG1Uy1
        ZmYuleLSBThJ4xfCHFx7Us06qBAZoX9TbJDMNZVlTYrjGeQUTn/UTjM6BiSzLV9s/gLxBYM3hS8NC
        NnFpC+SxM4eBDacIS3dWw7cD0P2tggyY5sbT6JqXEsHsaJC4xaMr+a+v3gfVGxmjU5PsPDGdEkM6N
        0cTcI+KdtvcWi/U3wMb/Tkh4jJRdciKX88w7AeYu/DTkW4aFSGw25Xj9rvyi3Fnm8u6Z6F+KJJgOn
        En2ZZVsA==;
Received: from 089144193201.atnat0002.highway.a1.net ([89.144.193.201] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kY9ue-0007a1-O7; Thu, 29 Oct 2020 15:32:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/18] amiflop: use separate gendisks for Amiga vs MS-DOS mode
Date:   Thu, 29 Oct 2020 15:58:37 +0100
Message-Id: <20201029145841.144173-15-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029145841.144173-1-hch@lst.de>
References: <20201029145841.144173-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use separate gendisks (which share a tag_set) for the native Amgiga vs
the MS-DOS mode instead of redirecting the gendisk lookup using a probe
callback.  This avoids potential problems with aliased block_device
instances and will eventually allow for removing the blk_register_region
framework.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/block/amiflop.c | 98 +++++++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 43 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 71c2b156455860..9e2d0c6a387721 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -201,7 +201,7 @@ struct amiga_floppy_struct {
 	int busy;			/* true when drive is active */
 	int dirty;			/* true when trackbuf is not on disk */
 	int status;			/* current error code for unit */
-	struct gendisk *gendisk;
+	struct gendisk *gendisk[2];
 	struct blk_mq_tag_set tag_set;
 };
 
@@ -1669,6 +1669,11 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 		return -EBUSY;
 	}
 
+	if (unit[drive].type->code == FD_NODRIVE) {
+		mutex_unlock(&amiflop_mutex);
+		return -ENXIO;
+	}
+
 	if (mode & (FMODE_READ|FMODE_WRITE)) {
 		bdev_check_media_change(bdev);
 		if (mode & FMODE_WRITE) {
@@ -1695,7 +1700,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	unit[drive].dtype=&data_types[system];
 	unit[drive].blocks=unit[drive].type->heads*unit[drive].type->tracks*
 		data_types[system].sects*unit[drive].type->sect_mult;
-	set_capacity(unit[drive].gendisk, unit[drive].blocks);
+	set_capacity(unit[drive].gendisk[system], unit[drive].blocks);
 
 	printk(KERN_INFO "fd%d: accessing %s-disk with %s-layout\n",drive,
 	       unit[drive].type->name, data_types[system].name);
@@ -1772,36 +1777,68 @@ static const struct blk_mq_ops amiflop_mq_ops = {
 	.queue_rq = amiflop_queue_rq,
 };
 
-static struct gendisk *fd_alloc_disk(int drive)
+static int fd_alloc_disk(int drive, int system)
 {
 	struct gendisk *disk;
 
 	disk = alloc_disk(1);
 	if (!disk)
 		goto out;
-
-	disk->queue = blk_mq_init_sq_queue(&unit[drive].tag_set, &amiflop_mq_ops,
-						2, BLK_MQ_F_SHOULD_MERGE);
-	if (IS_ERR(disk->queue)) {
-		disk->queue = NULL;
+	disk->queue = blk_mq_init_queue(&unit[drive].tag_set);
+	if (IS_ERR(disk->queue))
 		goto out_put_disk;
-	}
 
+	disk->major = FLOPPY_MAJOR;
+	disk->first_minor = drive + system;
+	disk->fops = &floppy_fops;
+	disk->events = DISK_EVENT_MEDIA_CHANGE;
+	if (system)
+		sprintf(disk->disk_name, "fd%d_msdos", drive);
+	else
+		sprintf(disk->disk_name, "fd%d", drive);
+	disk->private_data = &unit[drive];
+	set_capacity(disk, 880 * 2);
+
+	unit[drive].gendisk[system] = disk;
+	add_disk(disk);
+	return 0;
+
+out_put_disk:
+	disk->queue = NULL;
+	put_disk(disk);
+out:
+	return -ENOMEM;
+}
+
+static int fd_alloc_drive(int drive)
+{
 	unit[drive].trackbuf = kmalloc(FLOPPY_MAX_SECTORS * 512, GFP_KERNEL);
 	if (!unit[drive].trackbuf)
-		goto out_cleanup_queue;
+		goto out;
 
-	return disk;
+	memset(&unit[drive].tag_set, 0, sizeof(unit[drive].tag_set));
+	unit[drive].tag_set.ops = &amiflop_mq_ops;
+	unit[drive].tag_set.nr_hw_queues = 1;
+	unit[drive].tag_set.nr_maps = 1;
+	unit[drive].tag_set.queue_depth = 2;
+	unit[drive].tag_set.numa_node = NUMA_NO_NODE;
+	unit[drive].tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+	if (blk_mq_alloc_tag_set(&unit[drive].tag_set))
+		goto out_cleanup_trackbuf;
 
-out_cleanup_queue:
-	blk_cleanup_queue(disk->queue);
-	disk->queue = NULL;
+	pr_cont(" fd%d", drive);
+
+	if (fd_alloc_disk(drive, 0) || fd_alloc_disk(drive, 1))
+		goto out_cleanup_tagset;
+	return 0;
+
+out_cleanup_tagset:
 	blk_mq_free_tag_set(&unit[drive].tag_set);
-out_put_disk:
-	put_disk(disk);
+out_cleanup_trackbuf:
+	kfree(unit[drive].trackbuf);
 out:
 	unit[drive].type->code = FD_NODRIVE;
-	return NULL;
+	return -ENOMEM;
 }
 
 static int __init fd_probe_drives(void)
@@ -1812,29 +1849,16 @@ static int __init fd_probe_drives(void)
 	drives=0;
 	nomem=0;
 	for(drive=0;drive<FD_MAX_UNITS;drive++) {
-		struct gendisk *disk;
 		fd_probe(drive);
 		if (unit[drive].type->code == FD_NODRIVE)
 			continue;
 
-		disk = fd_alloc_disk(drive);
-		if (!disk) {
+		if (fd_alloc_drive(drive) < 0) {
 			pr_cont(" no mem for fd%d", drive);
 			nomem = 1;
 			continue;
 		}
-		unit[drive].gendisk = disk;
 		drives++;
-
-		pr_cont(" fd%d",drive);
-		disk->major = FLOPPY_MAJOR;
-		disk->first_minor = drive;
-		disk->fops = &floppy_fops;
-		disk->events = DISK_EVENT_MEDIA_CHANGE;
-		sprintf(disk->disk_name, "fd%d", drive);
-		disk->private_data = &unit[drive];
-		set_capacity(disk, 880*2);
-		add_disk(disk);
 	}
 	if ((drives > 0) || (nomem == 0)) {
 		if (drives == 0)
@@ -1846,15 +1870,6 @@ static int __init fd_probe_drives(void)
 	return -ENOMEM;
 }
  
-static struct kobject *floppy_find(dev_t dev, int *part, void *data)
-{
-	int drive = *part & 3;
-	if (unit[drive].type->code == FD_NODRIVE)
-		return NULL;
-	*part = 0;
-	return get_disk_and_module(unit[drive].gendisk);
-}
-
 static int __init amiga_floppy_probe(struct platform_device *pdev)
 {
 	int i, ret;
@@ -1884,9 +1899,6 @@ static int __init amiga_floppy_probe(struct platform_device *pdev)
 	if (fd_probe_drives() < 1) /* No usable drives */
 		goto out_probe;
 
-	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
-				floppy_find, NULL, NULL);
-
 	/* initialize variables */
 	timer_setup(&motor_on_timer, motor_on_callback, 0);
 	motor_on_timer.expires = 0;
-- 
2.28.0

