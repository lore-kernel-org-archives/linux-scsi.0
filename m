From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: 2.6.6 + Adaptec I2O
Date: Tue, 1 Jun 2004 11:38:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5115@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:8123 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263041AbUFAPiS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2004 11:38:18 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Leon Toh <tltoh@attglobal.net>

As noted by you before, the spin_is_locked could probably be dropped
entirely. This was a bug noted in the 2.4 tree that migrated into the
code for the 2.6 tree. I believe this lock is held at this point in the
code.

*this* DPT_TARGET_BUSY did the bd_claim you indicated would be
appropriate ... the bus_for_each_dev() call could be dropped though, it
was simply wishful thinking that we could expand on that idea to get the
busy check functionality back.

Sincerely -- Mark Salyzyn

How about this post-patch (untested):

diff -Nru dpt_i2o.1/dpt_i2o.c dpt_i2o/dpt_i2o.c
--- dpt_i2o.1/dpt_i2o.c Tue Jun  1 07:22:27 2004
+++ dpt_i2o/dpt_i2o.c   Tue Jun  1 08:31:19 2004
@@ -1285,7 +1226,6 @@
        msg[2] |= 0x80000000 | ((u32)wait_data->id);
        timeout *= HZ;
        if((status = adpt_i2o_post_this(pHba, msg, len)) == 0){
-               spinlock_t * was_locked = (spinlock_t *)NULL;
                set_current_state(TASK_INTERRUPTIBLE);
                /*
                 *      We are called before the host & host lock has
been
@@ -1293,11 +1233,6 @@
                 * held. We need to free the lock, if held, before going
                 * to sleep.
                 */
-               if ((pHba->host != NULL) /* Sad */
-                && (spin_is_locked(pHba->host->host_lock))) {
-                       was_locked = pHba->host->host_lock;
-                       spin_unlock_irq(was_locked);
+               spin_unlock_irq(pHba->host->host_lock);
-               }
                if(!timeout){
                        schedule();
                } else {
@@ -1309,8 +1244,6 @@
                                status = -ETIME;
                        }
                }
-               if (was_locked)
-                       spin_lock_irq(was_locked);
+               spin_lock_irq(pHba->host->host_lock);
                if (signal_pending(current)) {
                        printk("adpt_i2o_post_wait: interrupted\n");
                        status = -EINTR;
@@ -2067,10 +2000,6 @@

 #endif

-static int adpt_busy(struct device * dev, void * arg)
-{
-       return 0;
-}

 static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
              ulong arg)
@@ -2162,12 +2091,6 @@
                if (bd_claim(inode->i_bdev, pHba))
                        busy.isBusy = 1;
-               else {
-                       extern struct bus_type scsi_bus_type;
-                       bd_release(inode->i_bdev);
-                       busy.isBusy = pHba->unit;
-                       busy.isBusy = bus_for_each_dev(&scsi_bus_type,
NULL, &bu
sy, adpt_busy);
-               }
                if (copy_to_user ((char*)arg, &busy, sizeof(busy))) {
                        return -EFAULT;
                }

-----Original Message-----
From: Christoph Hellwig [mailto:hch@lst.de] 
Sent: Tuesday, June 01, 2004 11:20 AM
To: Salyzyn, Mark
Cc: Andrew Morton; linux-scsi@vger.kernel.org; Leon Toh; Christoph
Hellwig
Subject: Re: 2.6.6 + Adaptec I2O

On Tue, Jun 01, 2004 at 11:11:22AM -0400, Salyzyn, Mark wrote:
> Please read CHANGELOG.dpt_i2o for change documentation.
> 
> Two changes recently posted by Christoph Hellwig have been
incorporated
> in this patch.
> 
> This patch has aimed towards 2.6 purity, and although the sources
> maintained at Adaptec are unified (2.4 & 2.6), scripts were used to
> remove the ifdef KERNEL_VERSION from this release. This source is in
> synchronized with the patch on May 19th submitted for dpt_i2o in the
2.4
> tree.
> 
> I look forward to comments regarding this patch.

Patch is mostly okay although it still won't win a beaty contest.

Two showstoppers though:

 - the spin_is_locked magic is really, really bogus.  Easiest way to
   avoid this is to have your own spinlock in adpt_hba and use
   scsi_assign_lock to make it the host_lock, too.  With a little
   magic you'll also get per-host locks in the various 2.4 vendor
   trees with that..
 - you're still trying to sneak DPT_TARGET_BUSY back in.

Please fix those two issues and the patch can go in.

