From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 2/6] Adjust block device size after an online resize of
	a disk.
Date: Fri, 05 Sep 2008 14:34:26 -0600
Message-ID: <1220646866.7790.67.camel@grinch>
References: <20080904202714.10456.88061.stgit@bob.kio>
	 <20080904202725.10456.62289.stgit@bob.kio>
	 <20080905131244.GC3795@skl-net.de> <1220628997.7790.30.camel@grinch>
	 <20080905175536.GD3795@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:4674 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYIEUec (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2008 16:34:32 -0400
In-Reply-To: <20080905175536.GD3795@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com, jmoyer@redhat.com

On Fri, 2008-09-05 at 19:55 +0200, Andre Noll wrote:
> On 09:36, Andrew Patterson wrote:
> > On Fri, 2008-09-05 at 15:12 +0200, Andre Noll wrote:
> > > On 14:27, Andrew Patterson wrote:
> > > >  int revalidate_disk(struct gendisk *disk)
> > > >  {
> > > > +	struct block_device *bdev;
> > > >  	int ret = 0;
> > > >  
> > > >  	if (disk->fops->revalidate_disk)
> > > >  		ret = disk->fops->revalidate_disk(disk);
> > > 
> > > Maybe we should return early at this point if revalidate_disk()
> > > failed or fops->revalidate_disk is NULL.
> > 
> > We won't run check_disk_size_change() if we return early here. So the
> > question is would anyone ever make this call if they didn't have a
> > revalidate_disk routine?
> 
> I'd say no. In case someone ever does, it seems natural to do nothing
> and return early.

OK.  Jens, Do you want me to send you a new patch? Resend the entire
series, or send a patch to the patch? I have appended the new patch.


Andrew
--

Adjust block device size after an online resize of a disk.

From: Andrew Patterson <andrew.patterson@hp.com>

The revalidate_disk routine now checks if a disk has been resized by
comparing the gendisk capacity to the bdev inode size.  If they are
different (usually because the disk has been resized underneath the
kernel)
the bdev inode size is adjusted to match the capacity.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

 fs/block_dev.c     |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |    2 ++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 4eeb69a..d7feb5f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -853,6 +853,34 @@ struct block_device *open_by_devnum(dev_t dev,
unsigned mode)
 EXPORT_SYMBOL(open_by_devnum);
 
 /**
+ * check_disk_size_change - checks for disk size change and adjusts
+ *                          bdev size.
+ *
+ * @disk: struct gendisk to check
+ * @bdev: struct bdev to adjust.
+ *
+ * This routine checks to see if the bdev size does not match the disk
size
+ * and adjusts it if it differs.
+ */
+void check_disk_size_change(struct gendisk *disk, struct block_device
*bdev)
+{
+	loff_t disk_size, bdev_size;
+
+	disk_size = (loff_t)get_capacity(disk) << 9;
+	bdev_size = i_size_read(bdev->bd_inode);
+	if (disk_size != bdev_size) {
+		char name[BDEVNAME_SIZE];
+
+		disk_name(disk, 0, name);
+		printk(KERN_INFO
+		       "%s: detected capacity change from %lld to %lld\n",
+		       name, bdev_size, disk_size);
+		i_size_write(bdev->bd_inode, disk_size);
+	}
+}
+EXPORT_SYMBOL(check_disk_size_change);
+
+/**
  * revalidate_disk - wrapper for lower-level driver's revalidate_disk
  *                   call-back
  *
@@ -864,11 +892,22 @@ EXPORT_SYMBOL(open_by_devnum);
  */
 int revalidate_disk(struct gendisk *disk)
 {
+	struct block_device *bdev;
 	int ret = 0;
 
 	if (disk->fops->revalidate_disk)
 		ret = disk->fops->revalidate_disk(disk);
+	else
+		return ret;
+
+	bdev = bdget_disk(disk, 0);
+	if (!bdev)
+		return ret;
 
+	mutex_lock(&bdev->bd_mutex);
+	check_disk_size_change(disk, bdev);
+	mutex_unlock(&bdev->bd_mutex);
+	bdput(bdev);
 	return ret;
 }
 EXPORT_SYMBOL(revalidate_disk);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d63461f..32477e8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1722,6 +1722,8 @@ extern int fs_may_remount_ro(struct super_block
*);
  */
 #define bio_data_dir(bio)	((bio)->bi_rw & 1)
 
+extern void check_disk_size_change(struct gendisk *disk,
+				   struct block_device *bdev);
 extern int revalidate_disk(struct gendisk *);
 extern int check_disk_change(struct block_device *);
 extern int __invalidate_device(struct block_device *);


