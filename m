From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [2.6.1-bk2] Might sleep while loading st.ko
Date: Tue, 20 Jan 2004 21:30:57 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0401202121070.1073@kai.makisara.local>
References: <20040120000725.GY1748@srv-lnx2600.matchmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20040120000725.GY1748@srv-lnx2600.matchmail.com>
To: Mike Fedyk <mfedyk@matchmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Added linux-scsi which may be better list for this problem.

On Mon, 19 Jan 2004, Mike Fedyk wrote:

> I saw this in my kernel log while working with a scsi tape drive.
> 
> Is this a known sleeping function, or should I take more action to notify
> the scsi or adaptec driver teams?
> 
> st: Version 20031228, fixed bufsize 32768, s/g segs 256
> Debug: sleeping function called from invalid context at mm/slab.c:1856
> in_atomic():1, irqs_disabled():0
> Call Trace:
>  [__might_sleep+157/224] __might_sleep+0x9d/0xe0
>  [kmem_cache_alloc+92/96] kmem_cache_alloc+0x5c/0x60
>  [cdev_alloc+23/80] cdev_alloc+0x17/0x50
>  [_end+542090623/1069194756] st_probe+0x3fb/0x790 [st]

I thought I used enough debugging options to catch this but I did not...

The patch below fixes this problem (introduced in 2.6.1) by moving cdev 
code outside the lock protecting st internal data. The patched driver 
compiles and seems to work in my tests.

The sysfs link to /sys/cdev/major/st?m0 is not made any more because I have
understood that it is a bad idea.

Thanks for reporting the bug.

-- 
Kai

-------------------------------8<-----------------------------------------
--- linux-2.6.1-bk6/drivers/scsi/st.c	2004-01-20 20:16:20.000000000 +0200
+++ linux-2.6.1-bk6-k1/drivers/scsi/st.c	2004-01-20 21:18:10.000000000 +0200
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static char *verstr = "20031228";
+static char *verstr = "20040120";
 
 #include <linux/module.h>
 
@@ -3846,7 +3846,30 @@
 		STm->default_compression = ST_DONT_TOUCH;
 		STm->default_blksize = (-1);	/* No forced size */
 		STm->default_density = (-1);	/* No forced density */
+	}
+
+	for (i = 0; i < ST_NBR_PARTITIONS; i++) {
+		STps = &(tpnt->ps[i]);
+		STps->rw = ST_IDLE;
+		STps->eof = ST_NOEOF;
+		STps->at_sm = 0;
+		STps->last_block_valid = FALSE;
+		STps->drv_block = (-1);
+		STps->drv_file = (-1);
+	}
 
+	tpnt->current_mode = 0;
+	tpnt->modes[0].defined = TRUE;
+
+	tpnt->density_changed = tpnt->compression_changed =
+	    tpnt->blksize_changed = FALSE;
+	init_MUTEX(&tpnt->lock);
+
+	st_nr_dev++;
+	write_unlock(&st_dev_arr_lock);
+
+	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
+		STm = &(tpnt->modes[mode]);
 		for (j=0; j < 2; j++) {
 			cdev = cdev_alloc();
 			if (!cdev) {
@@ -3855,17 +3878,17 @@
 				goto out_put_disk;
 			}
 			snprintf(cdev->kobj.name, KOBJ_NAME_LEN, "%sm%d%s", disk->disk_name,
-				 i, j ? "n" : "");
+				 mode, j ? "n" : "");
 			cdev->owner = THIS_MODULE;
 			cdev->ops = &st_fops;
 			STm->cdevs[j] = cdev;
 
 			error = cdev_add(STm->cdevs[j],
-					 MKDEV(SCSI_TAPE_MAJOR, TAPE_MINOR(dev_num, i, j)),
+					 MKDEV(SCSI_TAPE_MAJOR, TAPE_MINOR(dev_num, mode, j)),
 					 1);
 			if (error) {
 				printk(KERN_ERR "st%d: Can't add %s-rewind mode %d\n",
-				       dev_num, j ? "non" : "auto", i);
+				       dev_num, j ? "non" : "auto", mode);
 			}
 
 			error = sysfs_create_link(&STm->cdevs[j]->kobj, &SDp->sdev_gendev.kobj,
@@ -3876,43 +3899,15 @@
 				       dev_num);
 			}
 		}
-	}
-	error = sysfs_create_link(&SDp->sdev_gendev.kobj, &tpnt->modes[0].cdevs[0]->kobj,
-				  "tape");
-	if (error) {
-		printk(KERN_ERR "st%d: Can't create sysfs link from SCSI device.\n",
-		       dev_num);
-	}
-
-	for (i = 0; i < ST_NBR_PARTITIONS; i++) {
-		STps = &(tpnt->ps[i]);
-		STps->rw = ST_IDLE;
-		STps->eof = ST_NOEOF;
-		STps->at_sm = 0;
-		STps->last_block_valid = FALSE;
-		STps->drv_block = (-1);
-		STps->drv_file = (-1);
-	}
 
-	tpnt->current_mode = 0;
-	tpnt->modes[0].defined = TRUE;
-
-	tpnt->density_changed = tpnt->compression_changed =
-	    tpnt->blksize_changed = FALSE;
-	init_MUTEX(&tpnt->lock);
-
-	st_nr_dev++;
-	write_unlock(&st_dev_arr_lock);
-
-	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-	    /*  Rewind entry  */
-	    devfs_mk_cdev(MKDEV(SCSI_TAPE_MAJOR, dev_num + (mode << 5)),
-				S_IFCHR | S_IRUGO | S_IWUGO,
-				"%s/mt%s", SDp->devfs_name, st_formats[mode]);
-	    /*  No-rewind entry  */
-	    devfs_mk_cdev(MKDEV(SCSI_TAPE_MAJOR, dev_num + (mode << 5) + 128),
-				S_IFCHR | S_IRUGO | S_IWUGO,
-				"%s/mt%sn", SDp->devfs_name, st_formats[mode]);
+		/*  Rewind entry  */
+		devfs_mk_cdev(MKDEV(SCSI_TAPE_MAJOR, dev_num + (mode << 5)),
+			      S_IFCHR | S_IRUGO | S_IWUGO,
+			      "%s/mt%s", SDp->devfs_name, st_formats[mode]);
+		/*  No-rewind entry  */
+		devfs_mk_cdev(MKDEV(SCSI_TAPE_MAJOR, dev_num + (mode << 5) + 128),
+			      S_IFCHR | S_IRUGO | S_IWUGO,
+			      "%s/mt%sn", SDp->devfs_name, st_formats[mode]);
 	}
 	disk->number = devfs_register_tape(SDp->devfs_name);
 
