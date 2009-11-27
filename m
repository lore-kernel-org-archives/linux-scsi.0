From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: BUG at scsi_lib.c:1108 [Was: mmotm 2009-11-24-16-47 uploaded]
Date: Fri, 27 Nov 2009 11:20:32 +0100
Message-ID: <4B0FA7F0.4060700@gmail.com>
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>	<4B0D4949.4090109@gmail.com>	<1259162399.2535.8.camel@mulgrave.site>	<4B0D9221.2050103@gmail.com>	<20091126081359.414c8216@notabene.brown> <20091127151721.57c02c29@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010501000309020709080302"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:45578 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbZK0KU3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Nov 2009 05:20:29 -0500
In-Reply-To: <20091127151721.57c02c29@notabene.brown>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mm-commits@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>

This is a multi-part message in MIME format.
--------------010501000309020709080302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/27/2009 05:17 AM, Neil Brown wrote:
> If an empty barrier is received, step 2 sends an empty non-barrier,
> which caused the BUG.
> I have revised the code to special case empty barriers and only perform
> the first step.
> This should appear in the next -next.

Yup, it works (with the patch attached). Thanks.

-- 
js

--------------010501000309020709080302
Content-Type: text/x-patch;
 name="0001-raid-fixup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-raid-fixup.patch"

>From d2ab5e2d06602b79b4c06208fd1ee492a32c983f Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@novell.com>
Date: Fri, 27 Nov 2009 11:08:28 +0100
Subject: [PATCH] raid fixup

---
 drivers/md/md.c    |   56 ++++++++++++++++++++++++++++++++++++++++-----------
 drivers/md/raid5.c |    3 ++
 fs/compat_ioctl.c  |   22 --------------------
 3 files changed, 47 insertions(+), 34 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 89a1350..d6f7f6c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -44,6 +44,7 @@
 #include <linux/random.h>
 #include <linux/reboot.h>
 #include <linux/file.h>
+#include <linux/compat.h>
 #include <linux/delay.h>
 #include <linux/raid/md_p.h>
 #include <linux/raid/md_u.h>
@@ -287,9 +288,11 @@ static void md_end_barrier(struct bio *bio, int err)
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
 		if (mddev->barrier == (void*)1) {
+			/* This was a post-request barrier */
 			mddev->barrier = NULL;
 			wake_up(&mddev->sb_wait);
 		} else
+			/* The pre-request barrier has finished */
 			schedule_work(&mddev->barrier_work);
 	}
 	bio_put(bio);
@@ -302,10 +305,16 @@ static void md_submit_barrier(struct work_struct *ws)
 
 	atomic_set(&mddev->flush_pending, 1);
 
-	if (!test_bit(BIO_EOPNOTSUPP, &bio->bi_flags)) {
+	if (test_bit(BIO_EOPNOTSUPP, &bio->bi_flags))
+		bio_endio(bio, -EOPNOTSUPP);
+	else if (bio->bi_size == 0)
+		/* an empty barrier - all done */
+		bio_endio(bio, 0);
+	else {
 		mdk_rdev_t *rdev;
 
 		bio->bi_rw &= ~(1<<BIO_RW_BARRIER);
+		bio->bi_rw |= (1<<BIO_RW_SYNCIO);
 		if (mddev->pers->make_request(mddev->queue, bio))
 			generic_make_request(bio);
 		mddev->barrier = (void*)1;
@@ -331,8 +340,7 @@ static void md_submit_barrier(struct work_struct *ws)
 				rdev_dec_pending(rdev, mddev);
 			}
 		rcu_read_unlock();
-	} else
-		bio_endio(bio, -EOPNOTSUPP);
+	}
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
 		mddev->barrier = NULL;
 		wake_up(&mddev->sb_wait);
@@ -1512,12 +1520,10 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 
 	if (rdev->raid_disk >= 0 &&
 	    !test_bit(In_sync, &rdev->flags)) {
-		if (rdev->recovery_offset > 0) {
-			sb->feature_map |=
-				cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
-			sb->recovery_offset =
-				cpu_to_le64(rdev->recovery_offset);
-		}
+		sb->feature_map |=
+			cpu_to_le32(MD_FEATURE_RECOVERY_OFFSET);
+		sb->recovery_offset =
+			cpu_to_le64(rdev->recovery_offset);
 	}
 
 	if (mddev->reshape_position != MaxSector) {
@@ -1551,7 +1557,7 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
 			sb->dev_roles[i] = cpu_to_le16(0xfffe);
 		else if (test_bit(In_sync, &rdev2->flags))
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
-		else if (rdev2->raid_disk >= 0 && rdev2->recovery_offset > 0)
+		else if (rdev2->raid_disk >= 0)
 			sb->dev_roles[i] = cpu_to_le16(rdev2->raid_disk);
 		else
 			sb->dev_roles[i] = cpu_to_le16(0xffff);
@@ -5663,6 +5669,25 @@ done:
 abort:
 	return err;
 }
+#ifdef CONFIG_COMPAT
+static int md_compat_ioctl(struct block_device *bdev, fmode_t mode,
+		    unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case HOT_REMOVE_DISK:
+	case HOT_ADD_DISK:
+	case SET_DISK_FAULTY:
+	case SET_BITMAP_FILE:
+		/* These take in integer arg, do not convert */
+		break;
+	default:
+		arg = (unsigned long)compat_ptr(arg);
+		break;
+	}
+
+	return md_ioctl(bdev, mode, cmd, arg);
+}
+#endif /* CONFIG_COMPAT */
 
 static int md_open(struct block_device *bdev, fmode_t mode)
 {
@@ -5728,6 +5753,9 @@ static const struct block_device_operations md_fops =
 	.open		= md_open,
 	.release	= md_release,
 	.ioctl		= md_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= md_compat_ioctl,
+#endif
 	.getgeo		= md_getgeo,
 	.media_changed	= md_media_changed,
 	.revalidate_disk= md_revalidate,
@@ -6518,7 +6546,9 @@ void md_do_sync(mddev_t *mddev)
 		       "md: resuming %s of %s from checkpoint.\n",
 		       desc, mdname(mddev));
 		mddev->curr_resync = j;
-	}
+		mddev->curr_resync_completed = j;
+	} else
+		mddev->curr_resync_completed = 0;
 
 	while (j < max_sectors) {
 		sector_t sectors;
@@ -6670,7 +6700,8 @@ void md_do_sync(mddev_t *mddev)
 	} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 		mddev->resync_min = mddev->curr_resync_completed;
 	mddev->curr_resync = 0;
-	mddev->curr_resync_completed = 0;
+	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+		mddev->curr_resync_completed = 0;
 	sysfs_notify(&mddev->kobj, NULL, "sync_completed");
 	wake_up(&resync_wait);
 	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
@@ -6733,6 +6764,7 @@ static int remove_and_add_spares(mddev_t *mddev)
 						       nm, mdname(mddev));
 					spares++;
 					md_new_event(mddev);
+					set_bit(MD_CHANGE_DEVS, &mddev->flags);
 				} else
 					break;
 			}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a8cab1d..f6c93a5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3996,6 +3996,9 @@ static int make_request(struct request_queue *q, struct bio * bi)
 			finish_wait(&conf->wait_for_overlap, &w);
 			set_bit(STRIPE_HANDLE, &sh->state);
 			clear_bit(STRIPE_DELAYED, &sh->state);
+			if ((bi->bi_rw & (1<<BIO_RW_SYNCIO)) &&
+			    !test_and_set_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+				atomic_inc(&conf->preread_active_stripes);
 			release_stripe(sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 8bd37d8..05c9211 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1089,28 +1089,6 @@ COMPATIBLE_IOCTL(FIGETBSZ)
 /* 'X' - originally XFS but some now in the VFS */
 COMPATIBLE_IOCTL(FIFREEZE)
 COMPATIBLE_IOCTL(FITHAW)
-/* RAID */
-COMPATIBLE_IOCTL(RAID_VERSION)
-COMPATIBLE_IOCTL(GET_ARRAY_INFO)
-COMPATIBLE_IOCTL(GET_DISK_INFO)
-COMPATIBLE_IOCTL(PRINT_RAID_DEBUG)
-COMPATIBLE_IOCTL(RAID_AUTORUN)
-COMPATIBLE_IOCTL(CLEAR_ARRAY)
-COMPATIBLE_IOCTL(ADD_NEW_DISK)
-ULONG_IOCTL(HOT_REMOVE_DISK)
-COMPATIBLE_IOCTL(SET_ARRAY_INFO)
-COMPATIBLE_IOCTL(SET_DISK_INFO)
-COMPATIBLE_IOCTL(WRITE_RAID_INFO)
-COMPATIBLE_IOCTL(UNPROTECT_ARRAY)
-COMPATIBLE_IOCTL(PROTECT_ARRAY)
-ULONG_IOCTL(HOT_ADD_DISK)
-ULONG_IOCTL(SET_DISK_FAULTY)
-COMPATIBLE_IOCTL(RUN_ARRAY)
-COMPATIBLE_IOCTL(STOP_ARRAY)
-COMPATIBLE_IOCTL(STOP_ARRAY_RO)
-COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
-COMPATIBLE_IOCTL(GET_BITMAP_FILE)
-ULONG_IOCTL(SET_BITMAP_FILE)
 /* Keyboard -- can be removed once tty3270 uses ops->compat_ioctl */
 ULONG_IOCTL(KDSIGACCEPT)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
-- 
1.6.5.3


--------------010501000309020709080302--
