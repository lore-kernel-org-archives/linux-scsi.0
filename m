From: Andrew Burgess <aab@cichlid.com>
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
Date: Fri, 6 Apr 2007 08:12:15 -0700
Message-ID: <200704061512.l36FCFjl031431@cichlid.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl-63-249-106-23.cruzio.com ([63.249.106.23]:59613 "EHLO
	cichlid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767719AbXDFPRW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Apr 2007 11:17:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cebbert@redhat.com, davem@davemloft.net, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley said:

> On Thu, 2007-04-05 at 19:21 -0700, Andrew Burgess wrote:
> > 2.6.20.4 with your patch dies in the memcpy (as does 21-gitN)
> > 
> > 2.6.20.4 without your patch dies in the subsequent __free_page
> > with a null pointer ref at 000...008
> > 
> > James should I try your posted patch? On which kernel?
> 
> Well, mine will work, but will also cover up the problem.  It looks like
> the scatterlist is getting corrupted by the HBA driver somehow ... we
> really need to root cause this, otherwise other things will go wrong in
> strange ways.
> 
> Just to confirm, the HBA with the problem is 3w-xxxx?

Yes. The 3w-xxxx.c driver changed between 2.6.18 and 2.6.20 but
nothing jumps out to my untrained eyes. Here's the diff:
Also, I should mention that the working kernel is a fedora
rpm (2.6.18-1.2798.fc6) so I don't know what patches are in it.
The vmlinuz is dated Oct 6 2006.

--------------------------------------------------------------------

root@athlon:kernel # diff -u linux-2.6.20-rt5/drivers/scsi/3w-xxxx.c linux-2.6.18.6/drivers/scsi/3w-xxxx.c
--- linux-2.6.20-rt5/drivers/scsi/3w-xxxx.c     2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.18.6/drivers/scsi/3w-xxxx.c       2006-12-16 16:21:00.000000000 -0800
@@ -6,7 +6,7 @@
                     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
 
-   Copyright (C) 1999-2007 3ware Inc.
+   Copyright (C) 1999-2005 3ware Inc.
 
    Kernel compatiblity By:     Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000      Andre Hedrick <andre@suse.com>
@@ -191,9 +191,6 @@
                  before shutting down card.
                  Change to new 'change_queue_depth' api.
                  Fix 'handled=1' ISR usage, remove bogus IRQ check.
-   1.26.02.002 - Free irq handler in __tw_shutdown().
-                 Turn on RCD bit for caching mode page.
-                 Serialize reset code.
 */
 
 #include <linux/module.h>
@@ -217,7 +214,7 @@
 #include "3w-xxxx.h"
 
 /* Globals */
-#define TW_DRIVER_VERSION "1.26.02.002"
+#define TW_DRIVER_VERSION "1.26.02.001"
 static TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
 static int tw_device_extension_count = 0;
 static int twe_major = -1;
@@ -229,7 +226,7 @@
 MODULE_VERSION(TW_DRIVER_VERSION);
 
 /* Function prototypes */
-static int tw_reset_device_extension(TW_Device_Extension *tw_dev);
+static int tw_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_reset);
 
 /* Functions */
 
@@ -987,12 +984,24 @@
                        /* Now wait for the command to complete */
                        timeout = wait_event_timeout(tw_dev->ioctl_wqueue,
tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);
 
+                       /* See if we reset while waiting for the ioctl to complete */
+                       if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
+                               clear_bit(TW_IN_RESET, &tw_dev->flags);
+                               retval = -ERESTARTSYS;
+                               goto out2;
+                       }
+
                        /* We timed out, and didn't get an interrupt */
                        if (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE) {
                                /* Now we need to reset the board */
                                printk(KERN_WARNING "3w-xxxx: scsi%d: Character ioctl (0x%x) timed
out, resetting card.\n", tw_dev->host->host_no, cmd);
                                retval = -EIO;
-                               if (tw_reset_device_extension(tw_dev)) {
+                               spin_lock_irqsave(tw_dev->host->host_lock, flags);
+                               tw_dev->state[request_id] = TW_S_COMPLETED;
+                               tw_state_request_finish(tw_dev, request_id);
+                               tw_dev->posted_request_count--;
+                               spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+                               if (tw_reset_device_extension(tw_dev, 1)) {
                                        printk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl(): Reset
failed for card %d.\n", tw_dev->host->host_no);
                                }
                                goto out2;
@@ -1327,7 +1336,7 @@
 } /* End tw_unmap_scsi_data() */
 
 /* This function will reset a device extension */
-static int tw_reset_device_extension(TW_Device_Extension *tw_dev)
+static int tw_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_reset) 
 {
        int i = 0;
        struct scsi_cmnd *srb;
@@ -1373,10 +1382,15 @@
                printk(KERN_WARNING "3w-xxxx: scsi%d: Reset sequence failed.\n",
tw_dev->host->host_no);
                return 1;
        }
-
        TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
-       clear_bit(TW_IN_RESET, &tw_dev->flags);
-       tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+
+       /* Wake up any ioctl that was pending before the reset */
+       if ((tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE) || (ioctl_reset)) {
+               clear_bit(TW_IN_RESET, &tw_dev->flags);
+       } else {
+               tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+               wake_up(&tw_dev->ioctl_wqueue);
+       }
 
        return 0;
 } /* End tw_reset_device_extension() */
@@ -1423,18 +1437,14 @@
                "WARNING: Command (0x%x) timed out, resetting card.\n",
                SCpnt->cmnd[0]);
 
-       /* Make sure we are not issuing an ioctl or resetting from ioctl */
-       mutex_lock(&tw_dev->ioctl_lock);
-
        /* Now reset the card and some of the device extension data */
-       if (tw_reset_device_extension(tw_dev)) {
+       if (tw_reset_device_extension(tw_dev, 0)) {
                printk(KERN_WARNING "3w-xxxx: scsi%d: Reset failed.\n", tw_dev->host->host_no);
                goto out;
        }
 
        retval = SUCCESS;
 out:
-       mutex_unlock(&tw_dev->ioctl_lock);
        return retval;
 } /* End tw_scsi_eh_reset() */
 
@@ -1650,9 +1660,9 @@
        request_buffer[4] = 0x8;        /* caching page */
        request_buffer[5] = 0xa;        /* page length */
        if (*flags & 0x1)
-               request_buffer[6] = 0x5;        /* WCE on, RCD on */
+               request_buffer[6] = 0x4;        /* WCE on */
        else
-               request_buffer[6] = 0x1;        /* WCE off, RCD on */
+               request_buffer[6] = 0x0;        /* WCE off */
        tw_transfer_internal(tw_dev, request_id, request_buffer,
                             sizeof(request_buffer));
 
@@ -2002,10 +2012,6 @@
        int retval = 1;
        TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
 
-       /* If we are resetting due to timed out ioctl, report as busy */
-       if (test_bit(TW_IN_RESET, &tw_dev->flags))
-               return SCSI_MLQUEUE_HOST_BUSY;
-
        /* Save done function into Scsi_Cmnd struct */
        SCpnt->scsi_done = done;
                 
@@ -2072,7 +2078,8 @@
 } /* End tw_scsi_queue() */
 
 /* This function is the interrupt service routine */
-static irqreturn_t tw_interrupt(int irq, void *dev_instance) 
+static irqreturn_t tw_interrupt(int irq, void *dev_instance,
+                    struct pt_regs *regs) 
 {
        int request_id;
        u32 status_reg_value;
@@ -2094,10 +2101,6 @@
 
        handled = 1;
 
-       /* If we are resetting, bail */
-       if (test_bit(TW_IN_RESET, &tw_dev->flags))
-               goto tw_interrupt_bail;
-
        /* Check controller for errors */
        if (tw_check_bits(status_reg_value)) {
                dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
@@ -2274,9 +2277,6 @@
        /* Disable interrupts */
        TW_DISABLE_INTERRUPTS(tw_dev);
 
-       /* Free up the IRQ */
-       free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
-
        printk(KERN_WARNING "3w-xxxx: Shutting down host %d.\n", tw_dev->host->host_no);
 
        /* Tell the card we are shutting down */
@@ -2445,6 +2445,9 @@
                twe_major = -1;
        }
 
+       /* Free up the IRQ */
+       free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
+
        /* Shutdown the card */
        __tw_shutdown(tw_dev);
 
@@ -2483,7 +2486,7 @@
 {
        printk(KERN_WARNING "3ware Storage Controller device driver for Linux v%s.\n",
TW_DRIVER_VERSION);
 
-       return pci_register_driver(&tw_driver);
+       return pci_module_init(&tw_driver);
 } /* End tw_init() */
 
 /* This function is called on driver exit */


