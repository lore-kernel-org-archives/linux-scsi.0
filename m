From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] [SCSI] sr: fix multi-drive performance, remove BKL
 replacement
Date: Tue, 28 Feb 2012 15:32:44 +0100
Message-ID: <20120228153244.70413d34@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

Commit 2a48fc0ab242 "block: autoconvert trivial BKL users to private
mutex" and other commits at the time mechanically swapped BKL for
per-driver global mutexes.  If the sr driver is any indication, these
replacements have still not been checked by anybody for their
necessessity, removed where possible, or the sections they serialize
reduced to a necessary minimum.

The sr_mutex in particular very noticably degraded performance of
CD-DA ripping with multiple drives in parallel.  When several
instances of "grip" are used with two or more drives, their GUIs
became laggier, as did the KDE file manager GUI, and drive utilization
was reduced.  (During ripping, drive lights flicker instead of staying
on most of the time.)  IOW time to rip a stack of CDs was increased.
I didn't measure this but it is highly noticeable.

On the other hand, I don't see what state sr_mutex would protect.
So I removed it entirely and that works fine for me.

Tested with up to six CD-ROM drives connected at the same time (1x
IDE, 5x FireWire), 12 grip instances running (2 per drive, one for
ripping and the other just polling the TOC as a test), and of course
udisks-daemon sitting in the background and polling the CD-ROM drives
as usual.  GUI lags are reduced and ripping throughput increased to
a level how I remember it from BKL era.

Also tested:  Erasing and writing a CD-RW with K3B/cdrecord while grip
and udisks-daemon poll the CD-RW drive and other grip instances rip
CD-DA from three other CD-ROM drives.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/scsi/sr.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -75,7 +75,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
 	 CDC_MRW|CDC_MRW_W|CDC_RAM)
 
-static DEFINE_MUTEX(sr_mutex);
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
 static int sr_done(struct scsi_cmnd *);
@@ -508,27 +507,23 @@ static int sr_prep_fn(struct request_que
 
 static int sr_block_open(struct block_device *bdev, fmode_t mode)
 {
-	struct scsi_cd *cd;
+	struct scsi_cd *cd = scsi_cd_get(bdev->bd_disk);
 	int ret = -ENXIO;
 
-	mutex_lock(&sr_mutex);
-	cd = scsi_cd_get(bdev->bd_disk);
 	if (cd) {
 		ret = cdrom_open(&cd->cdi, bdev, mode);
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
+
 	cdrom_release(&cd->cdi, mode);
 	scsi_cd_put(cd);
-	mutex_unlock(&sr_mutex);
 	return 0;
 }
 
@@ -540,8 +535,6 @@ static int sr_block_ioctl(struct block_d
 	void __user *argp = (void __user *)arg;
 	int ret;
 
-	mutex_lock(&sr_mutex);
-
 	/*
 	 * Send SCSI addressing ioctls directly to mid level, send other
 	 * ioctls to cdrom/block level.
@@ -549,13 +542,12 @@ static int sr_block_ioctl(struct block_d
 	switch (cmd) {
 	case SCSI_IOCTL_GET_IDLUN:
 	case SCSI_IOCTL_GET_BUS_NUMBER:
-		ret = scsi_ioctl(sdev, cmd, argp);
-		goto out;
+		return scsi_ioctl(sdev, cmd, argp);
 	}
 
 	ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
 	if (ret != -ENOSYS)
-		goto out;
+		return ret;
 
 	/*
 	 * ENODEV means that we didn't recognise the ioctl, or that we
@@ -566,12 +558,9 @@ static int sr_block_ioctl(struct block_d
 	ret = scsi_nonblockable_ioctl(sdev, cmd, argp,
 					(mode & FMODE_NDELAY) != 0);
 	if (ret != -ENODEV)
-		goto out;
-	ret = scsi_ioctl(sdev, cmd, argp);
+		return ret;
 
-out:
-	mutex_unlock(&sr_mutex);
-	return ret;
+	return scsi_ioctl(sdev, cmd, argp);
 }
 
 static unsigned int sr_block_check_events(struct gendisk *disk,


-- 
Stefan Richter
-=====-===-- --=- ===--
http://arcgraph.de/sr/
