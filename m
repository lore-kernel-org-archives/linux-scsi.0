From: adam radford <aradford@gmail.com>
Subject: 3ware driver update for 2.6.11-rc2-mm2
Date: Wed, 26 Jan 2005 16:54:38 -0800
Message-ID: <b1bc6a00050126165418afd6ee@mail.gmail.com>
Reply-To: adam radford <aradford@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.197]:63435 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S262465AbVA0Ayl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jan 2005 19:54:41 -0500
Received: by wproxy.gmail.com with SMTP id 55so223976wri
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jan 2005 16:54:39 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

James,

Here is a patch to update a few bugs in the 3ware driver for
5/6/7/8000 controllers.

-Adam

diff -Naur linux-2.6.11-rc2-mm1/drivers/scsi/3w-xxxx.c linux-2.6.11-rc2-mm2/driv
ers/scsi/3w-xxxx.c
--- linux-2.6.11-rc2-mm1/drivers/scsi/3w-xxxx.c 2004-12-24 13:35:28.000000000 -0
800
+++ linux-2.6.11-rc2-mm2/drivers/scsi/3w-xxxx.c 2005-01-26 16:46:02.000000000 -0
800
@@ -6,7 +6,7 @@
                     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
 
-   Copyright (C) 1999-2004 3ware Inc.
+   Copyright (C) 1999-2005 3ware Inc.
 
    Kernel compatiblity By:     Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000      Andre Hedrick <andre@suse.com>
@@ -185,6 +185,13 @@
                  Fix data_buffer_length usage in tw_chrdev_ioctl().
                  Update contact information.
    1.26.02.000 - Convert driver to pci_driver format.
+   1.26.02.001 - Increase max ioctl buffer size to 512 sectors.
+                 Make tw_scsi_queue() return 0 for 'Unknown scsi opcode'.
+                 Fix tw_interrupt() to ignore interrupts from other devices
+                 during reset.
+                 Fix tw_scsi_queue() to BUSY io's during a reset.
+                 Fix tw_remove() to free irq handler/unregister_chrdev()
+                 before shutting down card.
 */
 
 #include <linux/module.h>
@@ -207,7 +214,7 @@
 #include "3w-xxxx.h"
 
 /* Globals */
-#define TW_DRIVER_VERSION "1.26.02.000"
+#define TW_DRIVER_VERSION "1.26.02.001"
 static TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
 static int tw_device_extension_count = 0;
 static int twe_major = -1;
@@ -910,7 +917,7 @@
                goto out;
 
        /* Check size */
-       if (data_buffer_length > TW_MAX_SECTORS * 512) {
+       if (data_buffer_length > TW_MAX_IOCTL_SECTORS * 512) {
                retval = -EINVAL;
                goto out;
        }
@@ -1366,6 +1373,7 @@
        TW_DISABLE_INTERRUPTS(tw_dev);
        TW_MASK_COMMAND_INTERRUPT(tw_dev);
        spin_lock_irqsave(tw_dev->host->host_lock, flags);
+       tw_dev->online = 0;
 
        /* Abort all requests that are in progress */
        for (i=0;i<TW_Q_LENGTH;i++) {
@@ -1401,6 +1409,7 @@
                return 1;
        }
        TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
+       tw_dev->online = 1;
 
        /* Wake up any ioctl that was pending before the reset */
        if ((tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE) || (ioctl_reset)
) {
@@ -2007,6 +2016,12 @@
        int retval = 1;
        TW_Device_Extension *tw_dev = (TW_Device_Extension *)SCpnt->device->host
->hostdata;
 
+       /* If we are off-line doing a reset, report as busy */
+       if (!tw_dev->online) {
+               retval = SCSI_MLQUEUE_HOST_BUSY;
+               goto out;
+       }
+
        /* Save done function into Scsi_Cmnd struct */
        SCpnt->scsi_done = done;
                 
@@ -2060,7 +2075,7 @@
                        tw_state_request_finish(tw_dev, request_id);
                        SCpnt->result = (DID_BAD_TARGET << 16);
                        done(SCpnt);
-                       goto out;
+                       retval = 0;
        }
        if (retval) {
                tw_dev->state[request_id] = TW_S_COMPLETED;
@@ -2093,6 +2108,10 @@
 
                handled = 1;
 
+               /* If card is offline, bail */
+               if (!tw_dev->online)
+                       goto tw_interrupt_bail;
+
                /* Read the registers */
                status_reg_value = inl(TW_STATUS_REG_ADDR(tw_dev));
 
@@ -2407,6 +2426,7 @@
 
        /* Re-enable interrupts on the card */
        TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
+       tw_dev->online = 1;
 
        /* Finally, scan the host */
        scsi_scan_host(host);
@@ -2438,23 +2458,24 @@
 
        scsi_remove_host(tw_dev->host);
 
-       __tw_shutdown(tw_dev);
+       /* Unregister character device */
+       if (twe_major >= 0) {
+               unregister_chrdev(twe_major, "twe");
+               twe_major = -1;
+       }
 
        /* Free up the IRQ */
        free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
 
+       /* Shutdown the card */
+       __tw_shutdown(tw_dev);
+
        /* Free up the mem region */
        pci_release_regions(pdev);
 
        /* Free up device extension resources */
        tw_free_device_extension(tw_dev);
 
-       /* Unregister character device */
-       if (twe_major >= 0) {
-               unregister_chrdev(twe_major, "twe");
-               twe_major = -1;
-       }
-
        scsi_host_put(tw_dev->host);
        pci_disable_device(pdev);
        tw_device_extension_count--;
diff -Naur linux-2.6.11-rc2-mm1/drivers/scsi/3w-xxxx.h linux-2.6.11-rc2-mm2/driv
ers/scsi/3w-xxxx.h
--- linux-2.6.11-rc2-mm1/drivers/scsi/3w-xxxx.h 2005-01-26 16:41:52.000000000 -0
800
+++ linux-2.6.11-rc2-mm2/drivers/scsi/3w-xxxx.h 2005-01-26 16:46:04.000000000 -0
800
@@ -6,7 +6,7 @@
                     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>
 
-   Copyright (C) 1999-2004 3ware Inc.
+   Copyright (C) 1999-2005 3ware Inc.
 
    Kernel compatiblity By:     Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000      Andre Hedrick <andre@suse.com>
@@ -227,6 +227,7 @@
 #define TW_IN_RESET                           2
 #define TW_IN_CHRDEV_IOCTL                    3
 #define TW_MAX_SECTORS                        256
+#define TW_MAX_IOCTL_SECTORS                 512
 #define TW_AEN_WAIT_TIME                      1000
 #define TW_IOCTL_WAIT_TIME                    (1 * HZ) /* 1 second */
 #define TW_ISR_DONT_COMPLETE                  2
@@ -428,6 +429,7 @@
        int                     reset_print;
        volatile int            chrdev_request_id;
        wait_queue_head_t       ioctl_wqueue;
+       char                    online;
 } TW_Device_Extension;
 
 #pragma pack()
