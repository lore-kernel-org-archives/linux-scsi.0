From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 02 Apr 2004 18:36:55 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1080949016.1804.161.camel@mulgrave>
References: <20040401131502.41136788.akpm@osdl.org>
	<1080862354.2118.78.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <1080862354.2118.78.camel@mulgrave>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2004-04-01 at 18:32, James Bottomley wrote:
> Now, the questions are, whose issue is this and how do we fix it?  I can
> see that a driver needs early notification of unplugs so it can deny all
> access to a gone device.  On the other hand, for a user land open where
> we still have to hold resources in the driver, we'd like the driver to
> have a notify when the device reference count drops to zero so we can
> clean up.

OK, I think this is easily fixable in sr.c by moving around the release
code to do the right thing (and not drop the reference to sdev_gendev
until we're completely finished).

Jens, does this look OK (or have I just opened up another race window
somewhere else)?

James

===== drivers/scsi/sr.c 1.103 vs edited =====
--- 1.103/drivers/scsi/sr.c	Fri Apr  2 11:30:44 2004
+++ edited/drivers/scsi/sr.c	Fri Apr  2 17:29:06 2004
@@ -424,8 +424,19 @@
 
 static int sr_block_release(struct inode *inode, struct file *file)
 {
+	int ret;
 	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
-	return cdrom_release(&cd->cdi, file);
+	struct scsi_device *sdev = cd->device;
+	ret = cdrom_release(&cd->cdi, file);
+	if(ret)
+		return ret;
+	
+	unregister_cdrom(&cd->cdi);
+	kfree(cd);
+
+	scsi_device_put(sdev);
+
+	return 0;
 }
 
 static int sr_block_ioctl(struct inode *inode, struct file *file, unsigned cmd,
@@ -500,7 +511,6 @@
 	if (cd->device->sector_size > 2048)
 		sr_set_blocklength(cd, 2048);
 
-	scsi_device_put(cd->device);
 }
 
 static int sr_probe(struct device *dev)
@@ -874,9 +884,6 @@
 	spin_unlock(&sr_index_lock);
 
 	put_disk(cd->disk);
-	unregister_cdrom(&cd->cdi);
-	kfree(cd);
-
 	return 0;
 }
 



-------------------------------------------------------
This SF.Net email is sponsored by: IBM Linux Tutorials
Free Linux tutorial presented by Daniel Robbins, President and CEO of
GenToo technologies. Learn everything from fundamentals to system
administration.http://ads.osdn.com/?ad_id=1470&alloc_id=3638&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
