Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6B5EC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 07:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B322067C
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 07:01:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HUzISJGW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHZHBM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 03:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgHZHAG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2020 03:00:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA665C061756;
        Wed, 26 Aug 2020 00:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Fts/xdyAgLXiHkT6oH53N4wrgx9qxnqqG5ORQ9IwOoI=; b=HUzISJGWLAjwA82k9t12N5J1E9
        fdxb4+UqdrlHFftWtL4XmszinTr9KfdbSSYdbGtgE/oWp71RQZJKfgOScUGOP0Jg2DH+zGmsK46y/
        Yx8yQEFHQq/Z037t5ZTC7D0fO3I9vneCDN5vSQjQSZwzOktwz6/ajoqL64xfZ+yiKB7OJ9PvkcFmH
        VfOqFCSzbirpECt6/BsEDgduuKqbmLVrHV81YbImmBZdM9dwAV9cauV1mMM8dtUnMKMiZaQ4dEgTB
        KW6w8Ywr98IotI/L/pwK0+XO9XNO9i7GCe/AllfDafzjAJmTCHs0XGHifS3vg1TAsdlpVPtLdteF5
        UlMGjaVw==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kApPX-0003ke-5Q; Wed, 26 Aug 2020 06:59:56 +0000
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
Subject: [PATCH 16/19] ataflop: use a separate gendisk for each media format
Date:   Wed, 26 Aug 2020 08:24:43 +0200
Message-Id: <20200826062446.31860-17-hch@lst.de>
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

The Atari floppy driver usually autodetects the media when used with the
ormal /dev/fd? devices, which also are the only nodes created by udev.
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
 drivers/block/ataflop.c | 135 +++++++++++++++++++++++++---------------
 1 file changed, 86 insertions(+), 49 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index a50e13af030526..b5acc85328c329 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -297,7 +297,7 @@ static struct atari_floppy_struct {
 	unsigned int wpstat;	/* current state of WP signal (for
 				   disk change detection) */
 	int flags;		/* flags */
-	struct gendisk *disk;
+	struct gendisk *disk[NUM_DISK_MINORS];
 	int ref;
 	int type;
 	struct blk_mq_tag_set tag_set;
@@ -723,12 +723,16 @@ static void fd_error( void )
 
 static int do_format(int drive, int type, struct atari_format_descr *desc)
 {
-	struct request_queue *q = unit[drive].disk->queue;
+	struct request_queue *q;
 	unsigned char	*p;
 	int sect, nsect;
 	unsigned long	flags;
 	int ret;
 
+	if (type)
+		type--;
+
+	q = unit[drive].disk[type]->queue;
 	blk_mq_freeze_queue(q);
 	blk_mq_quiesce_queue(q);
 
@@ -738,7 +742,7 @@ static int do_format(int drive, int type, struct atari_format_descr *desc)
 	local_irq_restore(flags);
 
 	if (type) {
-		if (--type >= NUM_DISK_MINORS ||
+		if (type >= NUM_DISK_MINORS ||
 		    minor2disktype[type].drive_types > DriveType) {
 			ret = -EINVAL;
 			goto out;
@@ -1154,7 +1158,7 @@ static void fd_rwsec_done1(int status)
 			    if (SUDT[-1].blocks > ReqBlock) {
 				/* try another disk type */
 				SUDT--;
-				set_capacity(unit[SelectedDrive].disk,
+				set_capacity(unit[SelectedDrive].disk[0],
 							SUDT->blocks);
 			    } else
 				Probing = 0;
@@ -1169,7 +1173,7 @@ static void fd_rwsec_done1(int status)
 /* record not found, but not probing. Maybe stretch wrong ? Restart probing */
 			if (SUD.autoprobe) {
 				SUDT = atari_disk_type + StartDiskType[DriveType];
-				set_capacity(unit[SelectedDrive].disk,
+				set_capacity(unit[SelectedDrive].disk[0],
 							SUDT->blocks);
 				Probing = 1;
 			}
@@ -1515,7 +1519,7 @@ static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		if (!UDT) {
 			Probing = 1;
 			UDT = atari_disk_type + StartDiskType[DriveType];
-			set_capacity(floppy->disk, UDT->blocks);
+			set_capacity(bd->rq->rq_disk, UDT->blocks);
 			UD.autoprobe = 1;
 		}
 	} 
@@ -1533,7 +1537,7 @@ static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		}
 		type = minor2disktype[type].index;
 		UDT = &atari_disk_type[type];
-		set_capacity(floppy->disk, UDT->blocks);
+		set_capacity(bd->rq->rq_disk, UDT->blocks);
 		UD.autoprobe = 0;
 	}
 
@@ -1658,7 +1662,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 				    printk (KERN_INFO "floppy%d: setting %s %p!\n",
 				        drive, dtp->name, dtp);
 				UDT = dtp;
-				set_capacity(floppy->disk, UDT->blocks);
+				set_capacity(disk, UDT->blocks);
 
 				if (cmd == FDDEFPRM) {
 				  /* save settings as permanent default type */
@@ -1702,7 +1706,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 			return -EINVAL;
 
 		UDT = dtp;
-		set_capacity(floppy->disk, UDT->blocks);
+		set_capacity(disk, UDT->blocks);
 
 		return 0;
 	case FDMSGON:
@@ -1725,7 +1729,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode,
 		UDT = NULL;
 		/* MSch: invalidate default_params */
 		default_params[drive].blocks  = 0;
-		set_capacity(floppy->disk, MAX_DISK_SIZE * 2);
+		set_capacity(disk, MAX_DISK_SIZE * 2);
 		fallthrough;
 	case FDFMTEND:
 	case FDFLUSH:
@@ -1961,14 +1965,50 @@ static const struct blk_mq_ops ataflop_mq_ops = {
 	.commit_rqs = ataflop_commit_rqs,
 };
 
-static struct kobject *floppy_find(dev_t dev, int *part, void *data)
+static int ataflop_alloc_disk(unsigned int drive, unsigned int type)
 {
-	int drive = *part & 3;
-	int type  = *part >> 2;
+	struct gendisk *disk;
+	int ret;
+
+	disk = alloc_disk(1);
+	if (!disk)
+		return -ENOMEM;
+
+	disk->queue = blk_mq_init_queue(&unit[drive].tag_set);
+	if (IS_ERR(disk->queue)) {
+		ret = PTR_ERR(disk->queue);
+		disk->queue = NULL;
+		put_disk(disk);
+		return ret;
+	}
+
+	disk->major = FLOPPY_MAJOR;
+	disk->first_minor = drive + (type << 2);
+	sprintf(disk->disk_name, "fd%d", drive);
+	disk->fops = &floppy_fops;
+	disk->events = DISK_EVENT_MEDIA_CHANGE;
+	disk->private_data = &unit[drive];
+	set_capacity(disk, MAX_DISK_SIZE * 2);
+
+	unit[drive].disk[type] = disk;
+	return 0;
+}
+
+static DEFINE_MUTEX(ataflop_probe_lock);
+
+static void ataflop_probe(dev_t dev)
+{
+	int drive = MINOR(dev) & 3;
+	int type  = MINOR(dev) >> 2;
+
 	if (drive >= FD_MAX_UNITS || type > NUM_DISK_MINORS)
-		return NULL;
-	*part = 0;
-	return get_disk_and_module(unit[drive].disk);
+		return;
+	mutex_lock(&ataflop_probe_lock);
+	if (!unit[drive].disk[type]) {
+		if (ataflop_alloc_disk(drive, type) == 0)
+			add_disk(unit[drive].disk[type]);
+	}
+	mutex_unlock(&ataflop_probe_lock);
 }
 
 static int __init atari_floppy_init (void)
@@ -1980,23 +2020,26 @@ static int __init atari_floppy_init (void)
 		/* Amiga, Mac, ... don't have Atari-compatible floppy :-) */
 		return -ENODEV;
 
-	if (register_blkdev(FLOPPY_MAJOR,"fd"))
-		return -EBUSY;
+	mutex_lock(&ataflop_probe_lock);
+	ret = __register_blkdev(FLOPPY_MAJOR, "fd", ataflop_probe);
+	if (ret)
+		goto out_unlock;
 
 	for (i = 0; i < FD_MAX_UNITS; i++) {
-		unit[i].disk = alloc_disk(1);
-		if (!unit[i].disk) {
-			ret = -ENOMEM;
+		memset(&unit[i].tag_set, 0, sizeof(unit[i].tag_set));
+		unit[i].tag_set.ops = &ataflop_mq_ops;
+		unit[i].tag_set.nr_hw_queues = 1;
+		unit[i].tag_set.nr_maps = 1;
+		unit[i].tag_set.queue_depth = 2;
+		unit[i].tag_set.numa_node = NUMA_NO_NODE;
+		unit[i].tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+		ret = blk_mq_alloc_tag_set(&unit[i].tag_set);
+		if (ret)
 			goto err;
-		}
 
-		unit[i].disk->queue = blk_mq_init_sq_queue(&unit[i].tag_set,
-							   &ataflop_mq_ops, 2,
-							   BLK_MQ_F_SHOULD_MERGE);
-		if (IS_ERR(unit[i].disk->queue)) {
-			put_disk(unit[i].disk);
-			ret = PTR_ERR(unit[i].disk->queue);
-			unit[i].disk->queue = NULL;
+		ret = ataflop_alloc_disk(i, 0);
+		if (ret) {
+			blk_mq_free_tag_set(&unit[i].tag_set);
 			goto err;
 		}
 	}
@@ -2026,19 +2069,9 @@ static int __init atari_floppy_init (void)
 	for (i = 0; i < FD_MAX_UNITS; i++) {
 		unit[i].track = -1;
 		unit[i].flags = 0;
-		unit[i].disk->major = FLOPPY_MAJOR;
-		unit[i].disk->first_minor = i;
-		sprintf(unit[i].disk->disk_name, "fd%d", i);
-		unit[i].disk->fops = &floppy_fops;
-		unit[i].disk->events = DISK_EVENT_MEDIA_CHANGE;
-		unit[i].disk->private_data = &unit[i];
-		set_capacity(unit[i].disk, MAX_DISK_SIZE * 2);
-		add_disk(unit[i].disk);
+		add_disk(unit[i].disk[0]);
 	}
 
-	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
-				floppy_find, NULL, NULL);
-
 	printk(KERN_INFO "Atari floppy driver: max. %cD, %strack buffering\n",
 	       DriveType == 0 ? 'D' : DriveType == 1 ? 'H' : 'E',
 	       UseTrackbuffer ? "" : "no ");
@@ -2048,14 +2081,14 @@ static int __init atari_floppy_init (void)
 
 err:
 	while (--i >= 0) {
-		struct gendisk *disk = unit[i].disk;
-
-		blk_cleanup_queue(disk->queue);
+		blk_cleanup_queue(unit[i].disk[0]->queue);
+		put_disk(unit[i].disk[0]);
 		blk_mq_free_tag_set(&unit[i].tag_set);
-		put_disk(unit[i].disk);
 	}
 
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
+out_unlock:
+	mutex_unlock(&ataflop_probe_lock);
 	return ret;
 }
 
@@ -2100,13 +2133,17 @@ __setup("floppy=", atari_floppy_setup);
 
 static void __exit atari_floppy_exit(void)
 {
-	int i;
-	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
+	int i, type;
+
 	for (i = 0; i < FD_MAX_UNITS; i++) {
-		del_gendisk(unit[i].disk);
-		blk_cleanup_queue(unit[i].disk->queue);
+		for (type = 0; type < NUM_DISK_MINORS; type++) {
+			if (!unit[i].disk[type])
+				continue;
+			del_gendisk(unit[i].disk[type]);
+			blk_cleanup_queue(unit[i].disk[type]->queue);
+			put_disk(unit[i].disk[type]);
+		}
 		blk_mq_free_tag_set(&unit[i].tag_set);
-		put_disk(unit[i].disk);
 	}
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 
-- 
2.28.0

