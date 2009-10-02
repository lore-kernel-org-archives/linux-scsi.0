From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [2.6.31] Memory leak in SCSI initialization?
Date: Fri, 02 Oct 2009 13:30:08 -0500
Message-ID: <1254508208.3874.131.camel@mulgrave.site>
References: <200909221318.IFD17141.OQLtSFJVOOFFMH@I-love.SAKURA.ne.jp>
	 <1253625194.5923.10.camel@concordia>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758081AbZJBSaS@vger.kernel.org>
In-Reply-To: <1253625194.5923.10.camel@concordia>
Sender: linux-kernel-owner@vger.kernel.org
To: michael@ellerman.id.au
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-09-22 at 23:13 +1000, Michael Ellerman wrote:
> On Tue, 2009-09-22 at 13:18 +0900, Tetsuo Handa wrote:
> > Hello.
> > 
> > I can see below message appears for 15 times in
> > /sys/kernel/debug/kmemleak after processing /init inside initramfs.
> > 
> > unreferenced object 0xdeadb5c8 (size 32):
> >   comm "insmod", pid 543, jiffies 4294674766
> >   backtrace:
> >     [<c048a22c>] create_object+0x135/0x202
> >     [<c048a31e>] kmemleak_alloc+0x25/0x49
> >     [<c04865d9>] kmemleak_alloc_recursive+0x1c/0x22
> >     [<c0486d33>] __kmalloc+0x6c/0xb9
> >     [<c04f5675>] kvasprintf+0x2d/0x4a
> >     [<c04ef5af>] kobject_set_name_vargs+0x21/0x50
> >     [<c054bbd7>] dev_set_name+0x1a/0x1c
> >     [<e08dc1b7>] scsi_sysfs_device_initialize+0x8b/0xe4 [scsi_mod]
> >     [<e08d9bbf>] scsi_alloc_sdev+0x134/0x18f [scsi_mod]
> >     [<e08d9e7a>] scsi_probe_and_add_lun+0x107/0xa98 [scsi_mod]
> >     [<e08da946>] __scsi_scan_target+0x70/0x4b1 [scsi_mod]
> >     [<e08dadbe>] scsi_scan_channel+0x37/0x60 [scsi_mod]
> >     [<e08dae9f>] scsi_scan_host_selected+0xb8/0xf1 [scsi_mod]
> >     [<e08daf2c>] do_scsi_scan_host+0x54/0x5d [scsi_mod]
> >     [<e08db2ef>] scsi_scan_host+0x14d/0x165 [scsi_mod]
> >     [<e0959771>] mptspi_probe+0x2cd/0x2f8 [mptspi]
> 
> I think this will fix it:
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 9ce5c34..284bcbe 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -957,7 +957,7 @@ static inline void scsi_destroy_sdev(struct scsi_device *sdev)
>         if (sdev->host->hostt->slave_destroy)
>                 sdev->host->hostt->slave_destroy(sdev);
>         transport_destroy_device(&sdev->sdev_gendev);
> -       put_device(&sdev->sdev_gendev);
> +       put_device(&sdev->sdev_dev);
>  }
>  
>  #ifdef CONFIG_SCSI_LOGGING
> 
> 
> sdev_dev has class == sdev_class. The release function for sdev_class is
> scsi_device_cls_release(), and _that_ does a put on the sdev_gendev.
> 
> But someone who groks all that mess, er beauty ;D, should check that
> makes sense.

The fix is correct, but it's depending on nastily deep magic inside the
scsi sysfs layers.  We have to know at this point that we've allocated
the containing object, parented sdev_dev, named sdev_dev (thus
allocating memory) but won't take a reference on sdev_gendev for
sdev_dev until add time, so doing a final put of sdev_dev also does a
final put of sdev_gendev.

The root cause of the problem is the fact that dev_set_name() now
allocates storage instead of using the original array within the kobj.
That means that the SCSI assumption that if you haven't made the
containing object or any sub objects visible, you can just destroy it
(and its component devices) lock stock and barrel becomes false.

The two ways to fix this naturally seem either to do the get of sdev_dev
at parent time (this is usual) and thus do an extra put of it in
scsi_destroy_sdev() (and all other destruction without add paths) or to
make sure no allocations occur in scsi_sysfs_device_initialize() and
thus we can just garbage collect the entire object without worrying
about subobject allocations.

On the whole, I would favour the latter since it returns us to the
original assumptions, but that would also leave us with unnamed SCSI
devices up until add time, which might be confusing, so let's try the
former.

Can we verify this fixes the memory leak?

James

---
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c447838..0547a7f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -317,6 +317,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 out_device_destroy:
 	scsi_device_set_state(sdev, SDEV_DEL);
 	transport_destroy_device(&sdev->sdev_gendev);
+	put_device(&sdev->sdev_dev);
 	put_device(&sdev->sdev_gendev);
 out:
 	if (display_failure_msg)
@@ -957,6 +958,7 @@ static inline void scsi_destroy_sdev(struct scsi_device *sdev)
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(&sdev->sdev_gendev);
+	put_device(&sdev->sdev_dev);
 	put_device(&sdev->sdev_gendev);
 }
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fde5453..5c7eb63 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -864,10 +864,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 		goto clean_device;
 	}
 
-	/* take a reference for the sdev_dev; this is
-	 * released by the sdev_class .release */
-	get_device(&sdev->sdev_gendev);
-
 	/* create queue files, which may be writable, depending on the host */
 	if (sdev->host->hostt->change_queue_depth)
 		error = device_create_file(&sdev->sdev_gendev, &sdev_attr_queue_depth_rw);
@@ -917,6 +913,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 
 	device_del(&sdev->sdev_gendev);
 	transport_destroy_device(&sdev->sdev_gendev);
+	put_device(&sdev->sdev_dev);
 	put_device(&sdev->sdev_gendev);
 
 	return error;
@@ -1065,7 +1062,7 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
 
 	device_initialize(&sdev->sdev_dev);
-	sdev->sdev_dev.parent = &sdev->sdev_gendev;
+	sdev->sdev_dev.parent = get_device(&sdev->sdev_gendev);
 	sdev->sdev_dev.class = &sdev_class;
 	dev_set_name(&sdev->sdev_dev, "%d:%d:%d:%d",
 		     sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
