From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 37/39] ide: remove ide_driver_proc_write
Date: Thu, 19 Apr 2018 14:41:38 +0200
Message-ID: <20180419124140.9309-38-hch@lst.de>
References: <20180419124140.9309-1-hch@lst.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180419124140.9309-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.com>, Corey Minyard <minyard@acm.org>, Alessandro Zummo <a.zummo@towertech.it>, Alexandre Belloni <alexandre.belloni@bootlin.com>, linux-acpi@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, netdev@vger.kernel.org, linux-rtc@vger.kernel.org, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org, linux-afs@lists.infradead.org, linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The driver proc file hasn't been writeable for a long time, so this is
just dead code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ide/ide-proc.c | 46 ------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/drivers/ide/ide-proc.c b/drivers/ide/ide-proc.c
index 863db44c7916..b3b8b8822d6a 100644
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -528,58 +528,12 @@ static int ide_driver_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, ide_driver_proc_show, PDE_DATA(inode));
 }
 
-static int ide_replace_subdriver(ide_drive_t *drive, const char *driver)
-{
-	struct device *dev = &drive->gendev;
-	int ret = 1;
-	int err;
-
-	device_release_driver(dev);
-	/* FIXME: device can still be in use by previous driver */
-	strlcpy(drive->driver_req, driver, sizeof(drive->driver_req));
-	err = device_attach(dev);
-	if (err < 0)
-		printk(KERN_WARNING "IDE: %s: device_attach error: %d\n",
-			__func__, err);
-	drive->driver_req[0] = 0;
-	if (dev->driver == NULL) {
-		err = device_attach(dev);
-		if (err < 0)
-			printk(KERN_WARNING
-				"IDE: %s: device_attach(2) error: %d\n",
-				__func__, err);
-	}
-	if (dev->driver && !strcmp(dev->driver->name, driver))
-		ret = 0;
-
-	return ret;
-}
-
-static ssize_t ide_driver_proc_write(struct file *file, const char __user *buffer,
-				     size_t count, loff_t *pos)
-{
-	ide_drive_t	*drive = PDE_DATA(file_inode(file));
-	char name[32];
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EACCES;
-	if (count > 31)
-		count = 31;
-	if (copy_from_user(name, buffer, count))
-		return -EFAULT;
-	name[count] = '\0';
-	if (ide_replace_subdriver(drive, name))
-		return -EINVAL;
-	return count;
-}
-
 static const struct file_operations ide_driver_proc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= ide_driver_proc_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= single_release,
-	.write		= ide_driver_proc_write,
 };
 
 static int ide_media_proc_show(struct seq_file *m, void *v)
-- 
2.17.0
