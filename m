From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: 2.6.6 + Adaptec I2O
Date: Tue, 1 Jun 2004 12:09:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD511E@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:17357 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265043AbUFAQJ7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2004 12:09:59 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Leon Toh <tltoh@attglobal.net>

No crash (lucky me ;-/ ), but the other fix is in jeopardy in testing,
the host structure is not defined at all calls to adpt_i2o_post_wait :-(
as the call is made before some initializations have been performed.

Here is an updated post-patch in the interest of turnaround.

Sincerely -- Mark Salyzyn

diff -Nru dpt_i2o.1/dpt_i2o.c dpt_i2o/dpt_i2o.c
--- dpt_i2o.1/dpt_i2o.c Tue Jun  1 07:22:27 2004
+++ dpt_i2o/dpt_i2o.c   Tue Jun  1 09:02:48 2004
@@ -1293,8 +1234,7 @@
                 * held. We need to free the lock, if held, before going
                 * to sleep.
                 */
-               if ((pHba->host != NULL) /* Sad */
-                && (spin_is_locked(pHba->host->host_lock))) {
+               if (pHba->host != NULL) { /* Sad */
                        was_locked = pHba->host->host_lock;
                        spin_unlock_irq(was_locked);
                }
@@ -2067,10 +2007,6 @@

 #endif

-static int adpt_busy(struct device * dev, void * arg)
-{
-       return 0;
-}

 static int adpt_ioctl(struct inode *inode, struct file *file, uint cmd,
              ulong arg)
@@ -2160,14 +2096,7 @@
                        return -EFAULT;
                }

-               if (bd_claim(inode->i_bdev, pHba))
-                       busy.isBusy = 1;
-               else {
-                       extern struct bus_type scsi_bus_type;
-                       bd_release(inode->i_bdev);
-                       busy.isBusy = pHba->unit;
-                       busy.isBusy = bus_for_each_dev(&scsi_bus_type,
NULL, &busy, adpt_busy);
-               }
+               busy.isBusy = 0;
                if (copy_to_user ((char*)arg, &busy, sizeof(busy))) {
                        return -EFAULT;
                }

-----Original Message-----
From: Christoph Hellwig [mailto:hch@lst.de] 
Sent: Tuesday, June 01, 2004 11:54 AM
To: Salyzyn, Mark
Cc: Christoph Hellwig; Andrew Morton; linux-scsi@vger.kernel.org; Leon
Toh
Subject: Re: 2.6.6 + Adaptec I2O

On Tue, Jun 01, 2004 at 11:38:16AM -0400, Salyzyn, Mark wrote:
> *this* DPT_TARGET_BUSY did the bd_claim you indicated would be
> appropriate ... the bus_for_each_dev() call could be dropped though,
it
> was simply wishful thinking that we could expand on that idea to get
the
> busy check functionality back.

bd_claim/bd_release is paired for a reason.  So you must call bd_claim
before you start your exclusive operation and bd_release afterwards,
your combination just doesn't make sense.

In addition you're calling bd_claim on the inode of the managment
_character_ device.  I honestly can't see how you ever tested this as
it should immediately crash.

