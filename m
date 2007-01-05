From: "adam radford" <aradford@gmail.com>
Subject: [PATCH 1/1] 3ware 8000 serialize reset code
Date: Thu, 4 Jan 2007 18:16:56 -0800
Message-ID: <b1bc6a000701041816m475c227fi1666467b53cb2365@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_18261_17361365.1167963416866"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:31438 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030276AbXAECQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jan 2007 21:16:58 -0500
Received: by ug-out-1314.google.com with SMTP id 44so5597360uga
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jan 2007 18:16:57 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

------=_Part_18261_17361365.1167963416866
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The attached patch for scsi-misc-2.6 updates the 3ware 8000 driver:

- Free irq handler in __tw_shutdown().
- Turn on RCD bit for caching mode page.
- Serialize reset code.

Signed-off-by: Adam Radford <linuxraid@amcc.com>

James, Please apply

Thanks!

-Adam

Note: The patch is attached as an attachment, and also included
in-line below.   The below may have line-wrap issues since I'm pasting
into gmail.

diff -Naur scsi-misc-2.6/drivers/scsi/3w-xxxx.c
scsi-misc-2.6.new/drivers/scsi/3w-xxxx.c
--- scsi-misc-2.6/drivers/scsi/3w-xxxx.c	2006-11-29 13:57:37.000000000 -0800
+++ scsi-misc-2.6.new/drivers/scsi/3w-xxxx.c	2007-01-04 17:06:40.000000000 -0800
@@ -6,7 +6,7 @@
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>

-   Copyright (C) 1999-2005 3ware Inc.
+   Copyright (C) 1999-2007 3ware Inc.

    Kernel compatiblity By: 	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>
@@ -191,6 +191,9 @@
                  before shutting down card.
                  Change to new 'change_queue_depth' api.
                  Fix 'handled=1' ISR usage, remove bogus IRQ check.
+   1.26.02.002 - Free irq handler in __tw_shutdown().
+                 Turn on RCD bit for caching mode page.
+                 Serialize reset code.
 */

 #include <linux/module.h>
@@ -214,7 +217,7 @@
 #include "3w-xxxx.h"

 /* Globals */
-#define TW_DRIVER_VERSION "1.26.02.001"
+#define TW_DRIVER_VERSION "1.26.02.002"
 static TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
 static int tw_device_extension_count = 0;
 static int twe_major = -1;
@@ -226,7 +229,7 @@
 MODULE_VERSION(TW_DRIVER_VERSION);

 /* Function prototypes */
-static int tw_reset_device_extension(TW_Device_Extension *tw_dev, int
ioctl_reset);
+static int tw_reset_device_extension(TW_Device_Extension *tw_dev);

 /* Functions */

@@ -984,24 +987,12 @@
 			/* Now wait for the command to complete */
 			timeout = wait_event_timeout(tw_dev->ioctl_wqueue,
tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);

-			/* See if we reset while waiting for the ioctl to complete */
-			if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
-				clear_bit(TW_IN_RESET, &tw_dev->flags);
-				retval = -ERESTARTSYS;
-				goto out2;
-			}
-
 			/* We timed out, and didn't get an interrupt */
 			if (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE) {
 				/* Now we need to reset the board */
 				printk(KERN_WARNING "3w-xxxx: scsi%d: Character ioctl (0x%x)
timed out, resetting card.\n", tw_dev->host->host_no, cmd);
 				retval = -EIO;
-				spin_lock_irqsave(tw_dev->host->host_lock, flags);
-				tw_dev->state[request_id] = TW_S_COMPLETED;
-				tw_state_request_finish(tw_dev, request_id);
-				tw_dev->posted_request_count--;
-				spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
-				if (tw_reset_device_extension(tw_dev, 1)) {
+				if (tw_reset_device_extension(tw_dev)) {
 					printk(KERN_WARNING "3w-xxxx: tw_chrdev_ioctl(): Reset failed
for card %d.\n", tw_dev->host->host_no);
 				}
 				goto out2;
@@ -1336,7 +1327,7 @@
 } /* End tw_unmap_scsi_data() */

 /* This function will reset a device extension */
-static int tw_reset_device_extension(TW_Device_Extension *tw_dev, int
ioctl_reset)
+static int tw_reset_device_extension(TW_Device_Extension *tw_dev)
 {
 	int i = 0;
 	struct scsi_cmnd *srb;
@@ -1382,15 +1373,10 @@
 		printk(KERN_WARNING "3w-xxxx: scsi%d: Reset sequence failed.\n",
tw_dev->host->host_no);
 		return 1;
 	}
-	TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);

-	/* Wake up any ioctl that was pending before the reset */
-	if ((tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE) || (ioctl_reset)) {
-		clear_bit(TW_IN_RESET, &tw_dev->flags);
-	} else {
-		tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
-		wake_up(&tw_dev->ioctl_wqueue);
-	}
+	TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
+	clear_bit(TW_IN_RESET, &tw_dev->flags);
+	tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;

 	return 0;
 } /* End tw_reset_device_extension() */
@@ -1437,14 +1423,18 @@
 		"WARNING: Command (0x%x) timed out, resetting card.\n",
 		SCpnt->cmnd[0]);

+	/* Make sure we are not issuing an ioctl or resetting from ioctl */
+	mutex_lock(&tw_dev->ioctl_lock);
+
 	/* Now reset the card and some of the device extension data */
-	if (tw_reset_device_extension(tw_dev, 0)) {
+	if (tw_reset_device_extension(tw_dev)) {
 		printk(KERN_WARNING "3w-xxxx: scsi%d: Reset failed.\n",
tw_dev->host->host_no);
 		goto out;
 	}

 	retval = SUCCESS;
 out:
+	mutex_unlock(&tw_dev->ioctl_lock);
 	return retval;
 } /* End tw_scsi_eh_reset() */

@@ -1660,9 +1650,9 @@
 	request_buffer[4] = 0x8;        /* caching page */
 	request_buffer[5] = 0xa;        /* page length */
 	if (*flags & 0x1)
-		request_buffer[6] = 0x4;        /* WCE on */
+		request_buffer[6] = 0x5;        /* WCE on, RCD on */
 	else
-		request_buffer[6] = 0x0;        /* WCE off */
+		request_buffer[6] = 0x1;        /* WCE off, RCD on */
 	tw_transfer_internal(tw_dev, request_id, request_buffer,
 			     sizeof(request_buffer));

@@ -2012,6 +2002,10 @@
 	int retval = 1;
 	TW_Device_Extension *tw_dev = (TW_Device_Extension
*)SCpnt->device->host->hostdata;

+	/* If we are resetting due to timed out ioctl, report as busy */
+	if (test_bit(TW_IN_RESET, &tw_dev->flags))
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	/* Save done function into Scsi_Cmnd struct */
 	SCpnt->scsi_done = done;
 		
@@ -2100,6 +2094,10 @@

 	handled = 1;

+	/* If we are resetting, bail */
+	if (test_bit(TW_IN_RESET, &tw_dev->flags))
+		goto tw_interrupt_bail;
+
 	/* Check controller for errors */
 	if (tw_check_bits(status_reg_value)) {
 		dprintk(KERN_WARNING "3w-xxxx: tw_interrupt(): Unexpected bits.\n");
@@ -2276,6 +2274,9 @@
 	/* Disable interrupts */
 	TW_DISABLE_INTERRUPTS(tw_dev);

+	/* Free up the IRQ */
+	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
+
 	printk(KERN_WARNING "3w-xxxx: Shutting down host %d.\n",
tw_dev->host->host_no);

 	/* Tell the card we are shutting down */
@@ -2444,9 +2445,6 @@
 		twe_major = -1;
 	}

-	/* Free up the IRQ */
-	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
-
 	/* Shutdown the card */
 	__tw_shutdown(tw_dev);

diff -Naur scsi-misc-2.6/drivers/scsi/3w-xxxx.h
scsi-misc-2.6.new/drivers/scsi/3w-xxxx.h
--- scsi-misc-2.6/drivers/scsi/3w-xxxx.h	2006-11-29 13:57:37.000000000 -0800
+++ scsi-misc-2.6.new/drivers/scsi/3w-xxxx.h	2007-01-04 17:06:42.000000000 -0800
@@ -6,7 +6,7 @@
    		     Arnaldo Carvalho de Melo <acme@conectiva.com.br>
                      Brad Strand <linux@3ware.com>

-   Copyright (C) 1999-2005 3ware Inc.
+   Copyright (C) 1999-2007 3ware Inc.

    Kernel compatiblity By:	Andre Hedrick <andre@suse.com>
    Non-Copyright (C) 2000	Andre Hedrick <andre@suse.com>

------=_Part_18261_17361365.1167963416866
Content-Type: text/x-patch; name=3ware_linux_2.6.20-rc3.patch;
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ewjz7qdk
Content-Disposition: attachment; filename="3ware_linux_2.6.20-rc3.patch"

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS8zdy14eHh4LmMgc2NzaS1taXNj
LTIuNi5uZXcvZHJpdmVycy9zY3NpLzN3LXh4eHguYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJz
L3Njc2kvM3cteHh4eC5jCTIwMDYtMTEtMjkgMTM6NTc6MzcuMDAwMDAwMDAwIC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvM3cteHh4eC5jCTIwMDctMDEtMDQgMTc6MDY6
NDAuMDAwMDAwMDAwIC0wODAwCkBAIC02LDcgKzYsNyBAQAogICAgCQkgICAgIEFybmFsZG8gQ2Fy
dmFsaG8gZGUgTWVsbyA8YWNtZUBjb25lY3RpdmEuY29tLmJyPgogICAgICAgICAgICAgICAgICAg
ICAgQnJhZCBTdHJhbmQgPGxpbnV4QDN3YXJlLmNvbT4KIAotICAgQ29weXJpZ2h0IChDKSAxOTk5
LTIwMDUgM3dhcmUgSW5jLgorICAgQ29weXJpZ2h0IChDKSAxOTk5LTIwMDcgM3dhcmUgSW5jLgog
CiAgICBLZXJuZWwgY29tcGF0aWJsaXR5IEJ5OiAJQW5kcmUgSGVkcmljayA8YW5kcmVAc3VzZS5j
b20+CiAgICBOb24tQ29weXJpZ2h0IChDKSAyMDAwCUFuZHJlIEhlZHJpY2sgPGFuZHJlQHN1c2Uu
Y29tPgpAQCAtMTkxLDYgKzE5MSw5IEBACiAgICAgICAgICAgICAgICAgIGJlZm9yZSBzaHV0dGlu
ZyBkb3duIGNhcmQuCiAgICAgICAgICAgICAgICAgIENoYW5nZSB0byBuZXcgJ2NoYW5nZV9xdWV1
ZV9kZXB0aCcgYXBpLgogICAgICAgICAgICAgICAgICBGaXggJ2hhbmRsZWQ9MScgSVNSIHVzYWdl
LCByZW1vdmUgYm9ndXMgSVJRIGNoZWNrLgorICAgMS4yNi4wMi4wMDIgLSBGcmVlIGlycSBoYW5k
bGVyIGluIF9fdHdfc2h1dGRvd24oKS4KKyAgICAgICAgICAgICAgICAgVHVybiBvbiBSQ0QgYml0
IGZvciBjYWNoaW5nIG1vZGUgcGFnZS4KKyAgICAgICAgICAgICAgICAgU2VyaWFsaXplIHJlc2V0
IGNvZGUuCiAqLwogCiAjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CkBAIC0yMTQsNyArMjE3LDcg
QEAKICNpbmNsdWRlICIzdy14eHh4LmgiCiAKIC8qIEdsb2JhbHMgKi8KLSNkZWZpbmUgVFdfRFJJ
VkVSX1ZFUlNJT04gIjEuMjYuMDIuMDAxIgorI2RlZmluZSBUV19EUklWRVJfVkVSU0lPTiAiMS4y
Ni4wMi4wMDIiCiBzdGF0aWMgVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2aWNlX2V4dGVuc2lv
bl9saXN0W1RXX01BWF9TTE9UXTsKIHN0YXRpYyBpbnQgdHdfZGV2aWNlX2V4dGVuc2lvbl9jb3Vu
dCA9IDA7CiBzdGF0aWMgaW50IHR3ZV9tYWpvciA9IC0xOwpAQCAtMjI2LDcgKzIyOSw3IEBACiBN
T0RVTEVfVkVSU0lPTihUV19EUklWRVJfVkVSU0lPTik7CiAKIC8qIEZ1bmN0aW9uIHByb3RvdHlw
ZXMgKi8KLXN0YXRpYyBpbnQgdHdfcmVzZXRfZGV2aWNlX2V4dGVuc2lvbihUV19EZXZpY2VfRXh0
ZW5zaW9uICp0d19kZXYsIGludCBpb2N0bF9yZXNldCk7CitzdGF0aWMgaW50IHR3X3Jlc2V0X2Rl
dmljZV9leHRlbnNpb24oVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2KTsKIAogLyogRnVuY3Rp
b25zICovCiAKQEAgLTk4NCwyNCArOTg3LDEyIEBACiAJCQkvKiBOb3cgd2FpdCBmb3IgdGhlIGNv
bW1hbmQgdG8gY29tcGxldGUgKi8KIAkJCXRpbWVvdXQgPSB3YWl0X2V2ZW50X3RpbWVvdXQodHdf
ZGV2LT5pb2N0bF93cXVldWUsIHR3X2Rldi0+Y2hyZGV2X3JlcXVlc3RfaWQgPT0gVFdfSU9DVExf
Q0hSREVWX0ZSRUUsIHRpbWVvdXQpOwogCi0JCQkvKiBTZWUgaWYgd2UgcmVzZXQgd2hpbGUgd2Fp
dGluZyBmb3IgdGhlIGlvY3RsIHRvIGNvbXBsZXRlICovCi0JCQlpZiAodGVzdF9iaXQoVFdfSU5f
UkVTRVQsICZ0d19kZXYtPmZsYWdzKSkgewotCQkJCWNsZWFyX2JpdChUV19JTl9SRVNFVCwgJnR3
X2Rldi0+ZmxhZ3MpOwotCQkJCXJldHZhbCA9IC1FUkVTVEFSVFNZUzsKLQkJCQlnb3RvIG91dDI7
Ci0JCQl9Ci0KIAkJCS8qIFdlIHRpbWVkIG91dCwgYW5kIGRpZG4ndCBnZXQgYW4gaW50ZXJydXB0
ICovCiAJCQlpZiAodHdfZGV2LT5jaHJkZXZfcmVxdWVzdF9pZCAhPSBUV19JT0NUTF9DSFJERVZf
RlJFRSkgewogCQkJCS8qIE5vdyB3ZSBuZWVkIHRvIHJlc2V0IHRoZSBib2FyZCAqLwogCQkJCXBy
aW50ayhLRVJOX1dBUk5JTkcgIjN3LXh4eHg6IHNjc2klZDogQ2hhcmFjdGVyIGlvY3RsICgweCV4
KSB0aW1lZCBvdXQsIHJlc2V0dGluZyBjYXJkLlxuIiwgdHdfZGV2LT5ob3N0LT5ob3N0X25vLCBj
bWQpOwogCQkJCXJldHZhbCA9IC1FSU87Ci0JCQkJc3Bpbl9sb2NrX2lycXNhdmUodHdfZGV2LT5o
b3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKLQkJCQl0d19kZXYtPnN0YXRlW3JlcXVlc3RfaWRdID0g
VFdfU19DT01QTEVURUQ7Ci0JCQkJdHdfc3RhdGVfcmVxdWVzdF9maW5pc2godHdfZGV2LCByZXF1
ZXN0X2lkKTsKLQkJCQl0d19kZXYtPnBvc3RlZF9yZXF1ZXN0X2NvdW50LS07Ci0JCQkJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSh0d19kZXYtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOwotCQkJCWlm
ICh0d19yZXNldF9kZXZpY2VfZXh0ZW5zaW9uKHR3X2RldiwgMSkpIHsKKwkJCQlpZiAodHdfcmVz
ZXRfZGV2aWNlX2V4dGVuc2lvbih0d19kZXYpKSB7CiAJCQkJCXByaW50ayhLRVJOX1dBUk5JTkcg
IjN3LXh4eHg6IHR3X2NocmRldl9pb2N0bCgpOiBSZXNldCBmYWlsZWQgZm9yIGNhcmQgJWQuXG4i
LCB0d19kZXYtPmhvc3QtPmhvc3Rfbm8pOwogCQkJCX0KIAkJCQlnb3RvIG91dDI7CkBAIC0xMzM2
LDcgKzEzMjcsNyBAQAogfSAvKiBFbmQgdHdfdW5tYXBfc2NzaV9kYXRhKCkgKi8KIAogLyogVGhp
cyBmdW5jdGlvbiB3aWxsIHJlc2V0IGEgZGV2aWNlIGV4dGVuc2lvbiAqLwotc3RhdGljIGludCB0
d19yZXNldF9kZXZpY2VfZXh0ZW5zaW9uKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiwgaW50
IGlvY3RsX3Jlc2V0KSAKK3N0YXRpYyBpbnQgdHdfcmVzZXRfZGV2aWNlX2V4dGVuc2lvbihUV19E
ZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYpCiB7CiAJaW50IGkgPSAwOwogCXN0cnVjdCBzY3NpX2Nt
bmQgKnNyYjsKQEAgLTEzODIsMTUgKzEzNzMsMTAgQEAKIAkJcHJpbnRrKEtFUk5fV0FSTklORyAi
M3cteHh4eDogc2NzaSVkOiBSZXNldCBzZXF1ZW5jZSBmYWlsZWQuXG4iLCB0d19kZXYtPmhvc3Qt
Pmhvc3Rfbm8pOwogCQlyZXR1cm4gMTsKIAl9Ci0JVFdfRU5BQkxFX0FORF9DTEVBUl9JTlRFUlJV
UFRTKHR3X2Rldik7CiAKLQkvKiBXYWtlIHVwIGFueSBpb2N0bCB0aGF0IHdhcyBwZW5kaW5nIGJl
Zm9yZSB0aGUgcmVzZXQgKi8KLQlpZiAoKHR3X2Rldi0+Y2hyZGV2X3JlcXVlc3RfaWQgPT0gVFdf
SU9DVExfQ0hSREVWX0ZSRUUpIHx8IChpb2N0bF9yZXNldCkpIHsKLQkJY2xlYXJfYml0KFRXX0lO
X1JFU0VULCAmdHdfZGV2LT5mbGFncyk7Ci0JfSBlbHNlIHsKLQkJdHdfZGV2LT5jaHJkZXZfcmVx
dWVzdF9pZCA9IFRXX0lPQ1RMX0NIUkRFVl9GUkVFOwotCQl3YWtlX3VwKCZ0d19kZXYtPmlvY3Rs
X3dxdWV1ZSk7Ci0JfQorCVRXX0VOQUJMRV9BTkRfQ0xFQVJfSU5URVJSVVBUUyh0d19kZXYpOwor
CWNsZWFyX2JpdChUV19JTl9SRVNFVCwgJnR3X2Rldi0+ZmxhZ3MpOworCXR3X2Rldi0+Y2hyZGV2
X3JlcXVlc3RfaWQgPSBUV19JT0NUTF9DSFJERVZfRlJFRTsKIAogCXJldHVybiAwOwogfSAvKiBF
bmQgdHdfcmVzZXRfZGV2aWNlX2V4dGVuc2lvbigpICovCkBAIC0xNDM3LDE0ICsxNDIzLDE4IEBA
CiAJCSJXQVJOSU5HOiBDb21tYW5kICgweCV4KSB0aW1lZCBvdXQsIHJlc2V0dGluZyBjYXJkLlxu
IiwKIAkJU0NwbnQtPmNtbmRbMF0pOwogCisJLyogTWFrZSBzdXJlIHdlIGFyZSBub3QgaXNzdWlu
ZyBhbiBpb2N0bCBvciByZXNldHRpbmcgZnJvbSBpb2N0bCAqLworCW11dGV4X2xvY2soJnR3X2Rl
di0+aW9jdGxfbG9jayk7CisKIAkvKiBOb3cgcmVzZXQgdGhlIGNhcmQgYW5kIHNvbWUgb2YgdGhl
IGRldmljZSBleHRlbnNpb24gZGF0YSAqLwotCWlmICh0d19yZXNldF9kZXZpY2VfZXh0ZW5zaW9u
KHR3X2RldiwgMCkpIHsKKwlpZiAodHdfcmVzZXRfZGV2aWNlX2V4dGVuc2lvbih0d19kZXYpKSB7
CiAJCXByaW50ayhLRVJOX1dBUk5JTkcgIjN3LXh4eHg6IHNjc2klZDogUmVzZXQgZmFpbGVkLlxu
IiwgdHdfZGV2LT5ob3N0LT5ob3N0X25vKTsKIAkJZ290byBvdXQ7CiAJfQogCiAJcmV0dmFsID0g
U1VDQ0VTUzsKIG91dDoKKwltdXRleF91bmxvY2soJnR3X2Rldi0+aW9jdGxfbG9jayk7CiAJcmV0
dXJuIHJldHZhbDsKIH0gLyogRW5kIHR3X3Njc2lfZWhfcmVzZXQoKSAqLwogCkBAIC0xNjYwLDkg
KzE2NTAsOSBAQAogCXJlcXVlc3RfYnVmZmVyWzRdID0gMHg4OyAgICAgICAgLyogY2FjaGluZyBw
YWdlICovCiAJcmVxdWVzdF9idWZmZXJbNV0gPSAweGE7ICAgICAgICAvKiBwYWdlIGxlbmd0aCAq
LwogCWlmICgqZmxhZ3MgJiAweDEpCi0JCXJlcXVlc3RfYnVmZmVyWzZdID0gMHg0OyAgICAgICAg
LyogV0NFIG9uICovCisJCXJlcXVlc3RfYnVmZmVyWzZdID0gMHg1OyAgICAgICAgLyogV0NFIG9u
LCBSQ0Qgb24gKi8KIAllbHNlCi0JCXJlcXVlc3RfYnVmZmVyWzZdID0gMHgwOyAgICAgICAgLyog
V0NFIG9mZiAqLworCQlyZXF1ZXN0X2J1ZmZlcls2XSA9IDB4MTsgICAgICAgIC8qIFdDRSBvZmYs
IFJDRCBvbiAqLwogCXR3X3RyYW5zZmVyX2ludGVybmFsKHR3X2RldiwgcmVxdWVzdF9pZCwgcmVx
dWVzdF9idWZmZXIsCiAJCQkgICAgIHNpemVvZihyZXF1ZXN0X2J1ZmZlcikpOwogCkBAIC0yMDEy
LDYgKzIwMDIsMTAgQEAKIAlpbnQgcmV0dmFsID0gMTsKIAlUV19EZXZpY2VfRXh0ZW5zaW9uICp0
d19kZXYgPSAoVFdfRGV2aWNlX0V4dGVuc2lvbiAqKVNDcG50LT5kZXZpY2UtPmhvc3QtPmhvc3Rk
YXRhOwogCisJLyogSWYgd2UgYXJlIHJlc2V0dGluZyBkdWUgdG8gdGltZWQgb3V0IGlvY3RsLCBy
ZXBvcnQgYXMgYnVzeSAqLworCWlmICh0ZXN0X2JpdChUV19JTl9SRVNFVCwgJnR3X2Rldi0+Zmxh
Z3MpKQorCQlyZXR1cm4gU0NTSV9NTFFVRVVFX0hPU1RfQlVTWTsKKwogCS8qIFNhdmUgZG9uZSBm
dW5jdGlvbiBpbnRvIFNjc2lfQ21uZCBzdHJ1Y3QgKi8KIAlTQ3BudC0+c2NzaV9kb25lID0gZG9u
ZTsKIAkJIApAQCAtMjEwMCw2ICsyMDk0LDEwIEBACiAKIAloYW5kbGVkID0gMTsKIAorCS8qIElm
IHdlIGFyZSByZXNldHRpbmcsIGJhaWwgKi8KKwlpZiAodGVzdF9iaXQoVFdfSU5fUkVTRVQsICZ0
d19kZXYtPmZsYWdzKSkKKwkJZ290byB0d19pbnRlcnJ1cHRfYmFpbDsKKwogCS8qIENoZWNrIGNv
bnRyb2xsZXIgZm9yIGVycm9ycyAqLwogCWlmICh0d19jaGVja19iaXRzKHN0YXR1c19yZWdfdmFs
dWUpKSB7CiAJCWRwcmludGsoS0VSTl9XQVJOSU5HICIzdy14eHh4OiB0d19pbnRlcnJ1cHQoKTog
VW5leHBlY3RlZCBiaXRzLlxuIik7CkBAIC0yMjc2LDYgKzIyNzQsOSBAQAogCS8qIERpc2FibGUg
aW50ZXJydXB0cyAqLwogCVRXX0RJU0FCTEVfSU5URVJSVVBUUyh0d19kZXYpOwogCisJLyogRnJl
ZSB1cCB0aGUgSVJRICovCisJZnJlZV9pcnEodHdfZGV2LT50d19wY2lfZGV2LT5pcnEsIHR3X2Rl
dik7CisKIAlwcmludGsoS0VSTl9XQVJOSU5HICIzdy14eHh4OiBTaHV0dGluZyBkb3duIGhvc3Qg
JWQuXG4iLCB0d19kZXYtPmhvc3QtPmhvc3Rfbm8pOwogCiAJLyogVGVsbCB0aGUgY2FyZCB3ZSBh
cmUgc2h1dHRpbmcgZG93biAqLwpAQCAtMjQ0NCw5ICsyNDQ1LDYgQEAKIAkJdHdlX21ham9yID0g
LTE7CiAJfQogCi0JLyogRnJlZSB1cCB0aGUgSVJRICovCi0JZnJlZV9pcnEodHdfZGV2LT50d19w
Y2lfZGV2LT5pcnEsIHR3X2Rldik7Ci0KIAkvKiBTaHV0ZG93biB0aGUgY2FyZCAqLwogCV9fdHdf
c2h1dGRvd24odHdfZGV2KTsKIApkaWZmIC1OYXVyIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3Np
LzN3LXh4eHguaCBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvM3cteHh4eC5oCi0tLSBz
Y3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS8zdy14eHh4LmgJMjAwNi0xMS0yOSAxMzo1NzozNy4w
MDAwMDAwMDAgLTA4MDAKKysrIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS8zdy14eHh4
LmgJMjAwNy0wMS0wNCAxNzowNjo0Mi4wMDAwMDAwMDAgLTA4MDAKQEAgLTYsNyArNiw3IEBACiAg
ICAJCSAgICAgQXJuYWxkbyBDYXJ2YWxobyBkZSBNZWxvIDxhY21lQGNvbmVjdGl2YS5jb20uYnI+
CiAgICAgICAgICAgICAgICAgICAgICBCcmFkIFN0cmFuZCA8bGludXhAM3dhcmUuY29tPgogCi0g
ICBDb3B5cmlnaHQgKEMpIDE5OTktMjAwNSAzd2FyZSBJbmMuCisgICBDb3B5cmlnaHQgKEMpIDE5
OTktMjAwNyAzd2FyZSBJbmMuCiAKICAgIEtlcm5lbCBjb21wYXRpYmxpdHkgQnk6CUFuZHJlIEhl
ZHJpY2sgPGFuZHJlQHN1c2UuY29tPgogICAgTm9uLUNvcHlyaWdodCAoQykgMjAwMAlBbmRyZSBI
ZWRyaWNrIDxhbmRyZUBzdXNlLmNvbT4K
------=_Part_18261_17361365.1167963416866--
