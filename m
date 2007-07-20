From: "adam radford" <aradford@gmail.com>
Subject: [PATCH 1/1] 3ware 9000 add support for 9690SA
Date: Fri, 20 Jul 2007 15:28:28 -0700
Message-ID: <b1bc6a000707201528t555ec575u19a6ee6c18af74ac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_31797_14642545.1184970508810"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.225]:64781 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759567AbXGTW2a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jul 2007 18:28:30 -0400
Received: by nz-out-0506.google.com with SMTP id s18so905221nze
        for <linux-scsi@vger.kernel.org>; Fri, 20 Jul 2007 15:28:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

------=_Part_31797_14642545.1184970508810
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The attached patch for scsi-misc-2.6 updates the 3ware 9000 driver:

- Fix dma mask setting to fallback to 32-bit if 64-bit fails.
- Add support for 9690SA controllers.

Signed-off-by: Adam Radford <linuxraid@amcc.com>

James, Please apply

Thanks!

-Adam

Note: The patch is attached as an attachment, and also included
in-line below.   The below may have line-wrap issues since I'm pasting
into gmail.

diff -Naur scsi-misc-2.6/drivers/scsi/3w-9xxx.c
scsi-misc-2.6.new/drivers/scsi/3w-9xxx.c
--- scsi-misc-2.6/drivers/scsi/3w-9xxx.c	2007-07-20 12:50:30.000000000 -0700
+++ scsi-misc-2.6.new/drivers/scsi/3w-9xxx.c	2007-07-20 13:05:10.000000000 -0700
@@ -4,7 +4,7 @@
    Written By: Adam Radford <linuxraid@amcc.com>
    Modifications By: Tom Couch <linuxraid@amcc.com>

-   Copyright (C) 2004-2006 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2007 Applied Micro Circuits Corporation.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -69,6 +69,8 @@
    2.26.02.008 - Free irq handler in __twa_shutdown().
                  Serialize reset code.
                  Add support for 9650SE controllers.
+   2.26.02.009 - Fix dma mask setting to fallback to 32-bit if 64-bit fails.
+   2.26.02.010 - Add support for 9690SA controllers.
 */

 #include <linux/module.h>
@@ -92,7 +94,7 @@
 #include "3w-9xxx.h"

 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.008"
+#define TW_DRIVER_VERSION "2.26.02.010"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -124,11 +126,11 @@
 			      unsigned short *fw_on_ctlr_branch,
 			      unsigned short *fw_on_ctlr_build,
 			      u32 *init_connect_result);
-static void twa_load_sgl(TW_Command_Full *full_command_packet, int
request_id, dma_addr_t dma_handle, int length);
+static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full
*full_command_packet, int request_id, dma_addr_t dma_handle, int
length);
 static int twa_poll_response(TW_Device_Extension *tw_dev, int
request_id, int seconds);
 static int twa_poll_status_gone(TW_Device_Extension *tw_dev, u32
flag, int seconds);
 static int twa_post_command_packet(TW_Device_Extension *tw_dev, int
request_id, char internal);
-static int twa_reset_device_extension(TW_Device_Extension *tw_dev,
int ioctl_reset);
+static int twa_reset_device_extension(TW_Device_Extension *tw_dev);
 static int twa_reset_sequence(TW_Device_Extension *tw_dev, int soft_reset);
 static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int
request_id, char *cdb, int use_sg, TW_SG_Entry *sglistarg);
 static void twa_scsiop_execute_scsi_complete(TW_Device_Extension
*tw_dev, int request_id);
@@ -683,7 +685,7 @@
 		full_command_packet = &tw_ioctl->firmware_command;

 		/* Load request id and sglist for both command types */
-		twa_load_sgl(full_command_packet, request_id, dma_handle,
data_buffer_length_adjusted);
+		twa_load_sgl(tw_dev, full_command_packet, request_id, dma_handle,
data_buffer_length_adjusted);

 		memcpy(tw_dev->command_packet_virt[request_id],
&(tw_ioctl->firmware_command), sizeof(TW_Command_Full));

@@ -700,10 +702,10 @@
 		if (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE) {
 			/* Now we need to reset the board */
 			printk(KERN_WARNING "3w-9xxx: scsi%d: WARNING: (0x%02X:0x%04X):
Character ioctl (0x%x) timed out, resetting card.\n",
-			       tw_dev->host->host_no, TW_DRIVER, 0xc,
+			       tw_dev->host->host_no, TW_DRIVER, 0x37,
 			       cmd);
 			retval = TW_IOCTL_ERROR_OS_EIO;
-			twa_reset_device_extension(tw_dev, 1);
+			twa_reset_device_extension(tw_dev);
 			goto out3;
 		}

@@ -890,7 +892,9 @@
 	}

 	if (status_reg_value & TW_STATUS_QUEUE_ERROR) {
-		if ((tw_dev->tw_pci_dev->device != PCI_DEVICE_ID_3WARE_9650SE) ||
(!test_bit(TW_IN_RESET, &tw_dev->flags)))
+		if (((tw_dev->tw_pci_dev->device != PCI_DEVICE_ID_3WARE_9650SE) &&
+		     (tw_dev->tw_pci_dev->device != PCI_DEVICE_ID_3WARE_9690SA)) ||
+		    (!test_bit(TW_IN_RESET, &tw_dev->flags)))
 			TW_PRINTK(tw_dev->host, TW_DRIVER, 0xe, "Controller Queue Error: clearing");
 		writel(TW_CONTROL_CLEAR_QUEUE_ERROR, TW_CONTROL_REG_ADDR(tw_dev));
 	}
@@ -935,8 +939,7 @@
 	unsigned long before;
 	int retval = 1;

-	if ((tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9550SX) ||
-	    (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9650SE)) {
+	if (tw_dev->tw_pci_dev->device != PCI_DEVICE_ID_3WARE_9000) {
 		before = jiffies;
 		while ((response_que_value & TW_9550SX_DRAIN_COMPLETED) !=
TW_9550SX_DRAIN_COMPLETED) {
 			response_que_value = readl(TW_RESPONSE_QUEUE_REG_ADDR_LARGE(tw_dev));
@@ -1195,7 +1198,6 @@
 	u32 status_reg_value;
 	TW_Response_Queue response_que;
 	TW_Command_Full *full_command_packet;
-	TW_Command *command_packet;
 	TW_Device_Extension *tw_dev = (TW_Device_Extension *)dev_instance;
 	int handled = 0;

@@ -1273,7 +1275,6 @@
 			request_id = TW_RESID_OUT(response_que.response_id);
 			full_command_packet = tw_dev->command_packet_virt[request_id];
 			error = 0;
-			command_packet = &full_command_packet->command.oldcommand;
 			/* Check for command packet errors */
 			if (full_command_packet->command.newcommand.status != 0) {
 				if (tw_dev->srb[request_id] != 0) {
@@ -1352,11 +1353,15 @@
 } /* End twa_interrupt() */

 /* This function will load the request id and various sgls for ioctls */
-static void twa_load_sgl(TW_Command_Full *full_command_packet, int
request_id, dma_addr_t dma_handle, int length)
+static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full
*full_command_packet, int request_id, dma_addr_t dma_handle, int
length)
 {
 	TW_Command *oldcommand;
 	TW_Command_Apache *newcommand;
 	TW_SG_Entry *sgl;
+	unsigned int pae = 0;
+
+	if ((sizeof(long) < 8) && (sizeof(dma_addr_t) > 4))
+		pae = 1;

 	if (TW_OP_OUT(full_command_packet->command.newcommand.opcode__reserved)
== TW_OP_EXECUTE_SCSI) {
 		newcommand = &full_command_packet->command.newcommand;
@@ -1372,12 +1377,14 @@

 		if (TW_SGL_OUT(oldcommand->opcode__sgloffset)) {
 			/* Load the sg list */
-			sgl = (TW_SG_Entry *)((u32
*)oldcommand+TW_SGL_OUT(oldcommand->opcode__sgloffset));
+			if (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9690SA)
+				sgl = (TW_SG_Entry *)((u32 *)oldcommand+oldcommand->size -
(sizeof(TW_SG_Entry)/4) + pae);
+			else
+				sgl = (TW_SG_Entry *)((u32
*)oldcommand+TW_SGL_OUT(oldcommand->opcode__sgloffset));
 			sgl->address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache) - 1);
 			sgl->length = cpu_to_le32(length);

-			if ((sizeof(long) < 8) && (sizeof(dma_addr_t) > 4))
-				oldcommand->size += 1;
+			oldcommand->size += pae;
 		}
 	}
 } /* End twa_load_sgl() */
@@ -1506,7 +1513,8 @@
 	command_que_value = tw_dev->command_packet_phys[request_id];

 	/* For 9650SE write low 4 bytes first */
-	if (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9650SE) {
+	if ((tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9650SE) ||
+	    (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9690SA)) {
 		command_que_value += TW_COMMAND_OFFSET;
 		writel((u32)command_que_value, TW_COMMAND_QUEUE_REG_ADDR_LARGE(tw_dev));
 	}
@@ -1537,7 +1545,8 @@
 		TW_UNMASK_COMMAND_INTERRUPT(tw_dev);
 		goto out;
 	} else {
-		if (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9650SE) {
+		if ((tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9650SE) ||
+		    (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9690SA)) {
 			/* Now write upper 4 bytes */
 			writel((u32)((u64)command_que_value >> 32),
TW_COMMAND_QUEUE_REG_ADDR_LARGE(tw_dev) + 0x4);
 		} else {
@@ -1561,7 +1570,7 @@
 } /* End twa_post_command_packet() */

 /* This function will reset a device extension */
-static int twa_reset_device_extension(TW_Device_Extension *tw_dev,
int ioctl_reset)
+static int twa_reset_device_extension(TW_Device_Extension *tw_dev)
 {
 	int i = 0;
 	int retval = 1;
@@ -1719,7 +1728,7 @@
 	mutex_lock(&tw_dev->ioctl_lock);

 	/* Now reset the card and some of the device extension data */
-	if (twa_reset_device_extension(tw_dev, 0)) {
+	if (twa_reset_device_extension(tw_dev)) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2b, "Controller reset failed
during scsi host reset");
 		goto out;
 	}
@@ -2001,11 +2010,14 @@

 	pci_set_master(pdev);

-	retval = pci_set_dma_mask(pdev, sizeof(dma_addr_t) > 4 ?
DMA_64BIT_MASK : DMA_32BIT_MASK);
-	if (retval) {
-		TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
-		goto out_disable_device;
-	}
+	if (pci_set_dma_mask(pdev, DMA_64BIT_MASK)
+	    || pci_set_consistent_dma_mask(pdev, DMA_64BIT_MASK))
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)
+		    || pci_set_consistent_dma_mask(pdev, DMA_32BIT_MASK)) {
+			TW_PRINTK(host, TW_DRIVER, 0x23, "Failed to set dma mask");
+			retval = -ENODEV;
+			goto out_disable_device;
+		}

 	host = scsi_host_alloc(&driver_template, sizeof(TW_Device_Extension));
 	if (!host) {
@@ -2053,7 +2065,8 @@
 		goto out_iounmap;

 	/* Set host specific parameters */
-	if (pdev->device == PCI_DEVICE_ID_3WARE_9650SE)
+	if ((pdev->device == PCI_DEVICE_ID_3WARE_9650SE) ||
+	    (pdev->device == PCI_DEVICE_ID_3WARE_9690SA))
 		host->max_id = TW_MAX_UNITS_9650SE;
 	else
 		host->max_id = TW_MAX_UNITS;
@@ -2160,6 +2173,8 @@
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9650SE,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9690SA,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, twa_pci_tbl);
diff -Naur scsi-misc-2.6/drivers/scsi/3w-9xxx.h
scsi-misc-2.6.new/drivers/scsi/3w-9xxx.h
--- scsi-misc-2.6/drivers/scsi/3w-9xxx.h	2007-07-08 16:32:17.000000000 -0700
+++ scsi-misc-2.6.new/drivers/scsi/3w-9xxx.h	2007-07-20 13:05:12.000000000 -0700
@@ -4,7 +4,7 @@
    Written By: Adam Radford <linuxraid@amcc.com>
    Modifications By: Tom Couch <linuxraid@amcc.com>

-   Copyright (C) 2004-2006 Applied Micro Circuits Corporation.
+   Copyright (C) 2004-2007 Applied Micro Circuits Corporation.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
@@ -419,6 +419,9 @@
 #ifndef PCI_DEVICE_ID_3WARE_9650SE
 #define PCI_DEVICE_ID_3WARE_9650SE 0x1004
 #endif
+#ifndef PCI_DEVICE_ID_3WARE_9690SA
+#define PCI_DEVICE_ID_3WARE_9690SA 0x1005
+#endif

 /* Bitmask macros to eliminate bitfields */

------=_Part_31797_14642545.1184970508810
Content-Type: text/x-patch; name=3ware_linux_2.6.23.patch;
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4d8ps4d
Content-Disposition: attachment; filename="3ware_linux_2.6.23.patch"

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS8zdy05eHh4LmMgc2NzaS1taXNj
LTIuNi5uZXcvZHJpdmVycy9zY3NpLzN3LTl4eHguYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJz
L3Njc2kvM3ctOXh4eC5jCTIwMDctMDctMjAgMTI6NTA6MzAuMDAwMDAwMDAwIC0wNzAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvM3ctOXh4eC5jCTIwMDctMDctMjAgMTM6MDU6
MTAuMDAwMDAwMDAwIC0wNzAwCkBAIC00LDcgKzQsNyBAQAogICAgV3JpdHRlbiBCeTogQWRhbSBS
YWRmb3JkIDxsaW51eHJhaWRAYW1jYy5jb20+CiAgICBNb2RpZmljYXRpb25zIEJ5OiBUb20gQ291
Y2ggPGxpbnV4cmFpZEBhbWNjLmNvbT4KIAotICAgQ29weXJpZ2h0IChDKSAyMDA0LTIwMDYgQXBw
bGllZCBNaWNybyBDaXJjdWl0cyBDb3Jwb3JhdGlvbi4KKyAgIENvcHlyaWdodCAoQykgMjAwNC0y
MDA3IEFwcGxpZWQgTWljcm8gQ2lyY3VpdHMgQ29ycG9yYXRpb24uCiAKICAgIFRoaXMgcHJvZ3Jh
bSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5
CiAgICBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
IGFzIHB1Ymxpc2hlZCBieQpAQCAtNjksNiArNjksOCBAQAogICAgMi4yNi4wMi4wMDggLSBGcmVl
IGlycSBoYW5kbGVyIGluIF9fdHdhX3NodXRkb3duKCkuCiAgICAgICAgICAgICAgICAgIFNlcmlh
bGl6ZSByZXNldCBjb2RlLgogICAgICAgICAgICAgICAgICBBZGQgc3VwcG9ydCBmb3IgOTY1MFNF
IGNvbnRyb2xsZXJzLgorICAgMi4yNi4wMi4wMDkgLSBGaXggZG1hIG1hc2sgc2V0dGluZyB0byBm
YWxsYmFjayB0byAzMi1iaXQgaWYgNjQtYml0IGZhaWxzLgorICAgMi4yNi4wMi4wMTAgLSBBZGQg
c3VwcG9ydCBmb3IgOTY5MFNBIGNvbnRyb2xsZXJzLgogKi8KIAogI2luY2x1ZGUgPGxpbnV4L21v
ZHVsZS5oPgpAQCAtOTIsNyArOTQsNyBAQAogI2luY2x1ZGUgIjN3LTl4eHguaCIKIAogLyogR2xv
YmFscyAqLwotI2RlZmluZSBUV19EUklWRVJfVkVSU0lPTiAiMi4yNi4wMi4wMDgiCisjZGVmaW5l
IFRXX0RSSVZFUl9WRVJTSU9OICIyLjI2LjAyLjAxMCIKIHN0YXRpYyBUV19EZXZpY2VfRXh0ZW5z
aW9uICp0d2FfZGV2aWNlX2V4dGVuc2lvbl9saXN0W1RXX01BWF9TTE9UXTsKIHN0YXRpYyB1bnNp
Z25lZCBpbnQgdHdhX2RldmljZV9leHRlbnNpb25fY291bnQ7CiBzdGF0aWMgaW50IHR3YV9tYWpv
ciA9IC0xOwpAQCAtMTI0LDExICsxMjYsMTEgQEAKIAkJCSAgICAgIHVuc2lnbmVkIHNob3J0ICpm
d19vbl9jdGxyX2JyYW5jaCwgCiAJCQkgICAgICB1bnNpZ25lZCBzaG9ydCAqZndfb25fY3Rscl9i
dWlsZCwgCiAJCQkgICAgICB1MzIgKmluaXRfY29ubmVjdF9yZXN1bHQpOwotc3RhdGljIHZvaWQg
dHdhX2xvYWRfc2dsKFRXX0NvbW1hbmRfRnVsbCAqZnVsbF9jb21tYW5kX3BhY2tldCwgaW50IHJl
cXVlc3RfaWQsIGRtYV9hZGRyX3QgZG1hX2hhbmRsZSwgaW50IGxlbmd0aCk7CitzdGF0aWMgdm9p
ZCB0d2FfbG9hZF9zZ2woVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBUV19Db21tYW5kX0Z1
bGwgKmZ1bGxfY29tbWFuZF9wYWNrZXQsIGludCByZXF1ZXN0X2lkLCBkbWFfYWRkcl90IGRtYV9o
YW5kbGUsIGludCBsZW5ndGgpOwogc3RhdGljIGludCB0d2FfcG9sbF9yZXNwb25zZShUV19EZXZp
Y2VfRXh0ZW5zaW9uICp0d19kZXYsIGludCByZXF1ZXN0X2lkLCBpbnQgc2Vjb25kcyk7CiBzdGF0
aWMgaW50IHR3YV9wb2xsX3N0YXR1c19nb25lKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2Rldiwg
dTMyIGZsYWcsIGludCBzZWNvbmRzKTsKIHN0YXRpYyBpbnQgdHdhX3Bvc3RfY29tbWFuZF9wYWNr
ZXQoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQgcmVxdWVzdF9pZCwgY2hhciBpbnRl
cm5hbCk7Ci1zdGF0aWMgaW50IHR3YV9yZXNldF9kZXZpY2VfZXh0ZW5zaW9uKFRXX0RldmljZV9F
eHRlbnNpb24gKnR3X2RldiwgaW50IGlvY3RsX3Jlc2V0KTsKK3N0YXRpYyBpbnQgdHdhX3Jlc2V0
X2RldmljZV9leHRlbnNpb24oVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2KTsKIHN0YXRpYyBp
bnQgdHdhX3Jlc2V0X3NlcXVlbmNlKFRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiwgaW50IHNv
ZnRfcmVzZXQpOwogc3RhdGljIGludCB0d2Ffc2NzaW9wX2V4ZWN1dGVfc2NzaShUV19EZXZpY2Vf
RXh0ZW5zaW9uICp0d19kZXYsIGludCByZXF1ZXN0X2lkLCBjaGFyICpjZGIsIGludCB1c2Vfc2cs
IFRXX1NHX0VudHJ5ICpzZ2xpc3RhcmcpOwogc3RhdGljIHZvaWQgdHdhX3Njc2lvcF9leGVjdXRl
X3Njc2lfY29tcGxldGUoVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBpbnQgcmVxdWVzdF9p
ZCk7CkBAIC02ODMsNyArNjg1LDcgQEAKIAkJZnVsbF9jb21tYW5kX3BhY2tldCA9ICZ0d19pb2N0
bC0+ZmlybXdhcmVfY29tbWFuZDsKIAogCQkvKiBMb2FkIHJlcXVlc3QgaWQgYW5kIHNnbGlzdCBm
b3IgYm90aCBjb21tYW5kIHR5cGVzICovCi0JCXR3YV9sb2FkX3NnbChmdWxsX2NvbW1hbmRfcGFj
a2V0LCByZXF1ZXN0X2lkLCBkbWFfaGFuZGxlLCBkYXRhX2J1ZmZlcl9sZW5ndGhfYWRqdXN0ZWQp
OworCQl0d2FfbG9hZF9zZ2wodHdfZGV2LCBmdWxsX2NvbW1hbmRfcGFja2V0LCByZXF1ZXN0X2lk
LCBkbWFfaGFuZGxlLCBkYXRhX2J1ZmZlcl9sZW5ndGhfYWRqdXN0ZWQpOwogCiAJCW1lbWNweSh0
d19kZXYtPmNvbW1hbmRfcGFja2V0X3ZpcnRbcmVxdWVzdF9pZF0sICYodHdfaW9jdGwtPmZpcm13
YXJlX2NvbW1hbmQpLCBzaXplb2YoVFdfQ29tbWFuZF9GdWxsKSk7CiAKQEAgLTcwMCwxMCArNzAy
LDEwIEBACiAJCWlmICh0d19kZXYtPmNocmRldl9yZXF1ZXN0X2lkICE9IFRXX0lPQ1RMX0NIUkRF
Vl9GUkVFKSB7CiAJCQkvKiBOb3cgd2UgbmVlZCB0byByZXNldCB0aGUgYm9hcmQgKi8KIAkJCXBy
aW50ayhLRVJOX1dBUk5JTkcgIjN3LTl4eHg6IHNjc2klZDogV0FSTklORzogKDB4JTAyWDoweCUw
NFgpOiBDaGFyYWN0ZXIgaW9jdGwgKDB4JXgpIHRpbWVkIG91dCwgcmVzZXR0aW5nIGNhcmQuXG4i
LAotCQkJICAgICAgIHR3X2Rldi0+aG9zdC0+aG9zdF9ubywgVFdfRFJJVkVSLCAweGMsCisJCQkg
ICAgICAgdHdfZGV2LT5ob3N0LT5ob3N0X25vLCBUV19EUklWRVIsIDB4MzcsCiAJCQkgICAgICAg
Y21kKTsKIAkJCXJldHZhbCA9IFRXX0lPQ1RMX0VSUk9SX09TX0VJTzsKLQkJCXR3YV9yZXNldF9k
ZXZpY2VfZXh0ZW5zaW9uKHR3X2RldiwgMSk7CisJCQl0d2FfcmVzZXRfZGV2aWNlX2V4dGVuc2lv
bih0d19kZXYpOwogCQkJZ290byBvdXQzOwogCQl9CiAKQEAgLTg5MCw3ICs4OTIsOSBAQAogCX0K
IAogCWlmIChzdGF0dXNfcmVnX3ZhbHVlICYgVFdfU1RBVFVTX1FVRVVFX0VSUk9SKSB7Ci0JCWlm
ICgodHdfZGV2LT50d19wY2lfZGV2LT5kZXZpY2UgIT0gUENJX0RFVklDRV9JRF8zV0FSRV85NjUw
U0UpIHx8ICghdGVzdF9iaXQoVFdfSU5fUkVTRVQsICZ0d19kZXYtPmZsYWdzKSkpCisJCWlmICgo
KHR3X2Rldi0+dHdfcGNpX2Rldi0+ZGV2aWNlICE9IFBDSV9ERVZJQ0VfSURfM1dBUkVfOTY1MFNF
KSAmJgorCQkgICAgICh0d19kZXYtPnR3X3BjaV9kZXYtPmRldmljZSAhPSBQQ0lfREVWSUNFX0lE
XzNXQVJFXzk2OTBTQSkpIHx8IAorCQkgICAgKCF0ZXN0X2JpdChUV19JTl9SRVNFVCwgJnR3X2Rl
di0+ZmxhZ3MpKSkKIAkJCVRXX1BSSU5USyh0d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHhlLCAi
Q29udHJvbGxlciBRdWV1ZSBFcnJvcjogY2xlYXJpbmciKTsKIAkJd3JpdGVsKFRXX0NPTlRST0xf
Q0xFQVJfUVVFVUVfRVJST1IsIFRXX0NPTlRST0xfUkVHX0FERFIodHdfZGV2KSk7CiAJfQpAQCAt
OTM1LDggKzkzOSw3IEBACiAJdW5zaWduZWQgbG9uZyBiZWZvcmU7CiAJaW50IHJldHZhbCA9IDE7
CiAKLQlpZiAoKHR3X2Rldi0+dHdfcGNpX2Rldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfM1dB
UkVfOTU1MFNYKSB8fAotCSAgICAodHdfZGV2LT50d19wY2lfZGV2LT5kZXZpY2UgPT0gUENJX0RF
VklDRV9JRF8zV0FSRV85NjUwU0UpKSB7CisJaWYgKHR3X2Rldi0+dHdfcGNpX2Rldi0+ZGV2aWNl
ICE9IFBDSV9ERVZJQ0VfSURfM1dBUkVfOTAwMCkgewogCQliZWZvcmUgPSBqaWZmaWVzOwogCQl3
aGlsZSAoKHJlc3BvbnNlX3F1ZV92YWx1ZSAmIFRXXzk1NTBTWF9EUkFJTl9DT01QTEVURUQpICE9
IFRXXzk1NTBTWF9EUkFJTl9DT01QTEVURUQpIHsKIAkJCXJlc3BvbnNlX3F1ZV92YWx1ZSA9IHJl
YWRsKFRXX1JFU1BPTlNFX1FVRVVFX1JFR19BRERSX0xBUkdFKHR3X2RldikpOwpAQCAtMTE5NSw3
ICsxMTk4LDYgQEAKIAl1MzIgc3RhdHVzX3JlZ192YWx1ZTsKIAlUV19SZXNwb25zZV9RdWV1ZSBy
ZXNwb25zZV9xdWU7CiAJVFdfQ29tbWFuZF9GdWxsICpmdWxsX2NvbW1hbmRfcGFja2V0OwotCVRX
X0NvbW1hbmQgKmNvbW1hbmRfcGFja2V0OwogCVRXX0RldmljZV9FeHRlbnNpb24gKnR3X2RldiA9
IChUV19EZXZpY2VfRXh0ZW5zaW9uICopZGV2X2luc3RhbmNlOwogCWludCBoYW5kbGVkID0gMDsK
IApAQCAtMTI3Myw3ICsxMjc1LDYgQEAKIAkJCXJlcXVlc3RfaWQgPSBUV19SRVNJRF9PVVQocmVz
cG9uc2VfcXVlLnJlc3BvbnNlX2lkKTsKIAkJCWZ1bGxfY29tbWFuZF9wYWNrZXQgPSB0d19kZXYt
PmNvbW1hbmRfcGFja2V0X3ZpcnRbcmVxdWVzdF9pZF07CiAJCQllcnJvciA9IDA7Ci0JCQljb21t
YW5kX3BhY2tldCA9ICZmdWxsX2NvbW1hbmRfcGFja2V0LT5jb21tYW5kLm9sZGNvbW1hbmQ7CiAJ
CQkvKiBDaGVjayBmb3IgY29tbWFuZCBwYWNrZXQgZXJyb3JzICovCiAJCQlpZiAoZnVsbF9jb21t
YW5kX3BhY2tldC0+Y29tbWFuZC5uZXdjb21tYW5kLnN0YXR1cyAhPSAwKSB7CiAJCQkJaWYgKHR3
X2Rldi0+c3JiW3JlcXVlc3RfaWRdICE9IDApIHsKQEAgLTEzNTIsMTEgKzEzNTMsMTUgQEAKIH0g
LyogRW5kIHR3YV9pbnRlcnJ1cHQoKSAqLwogCiAvKiBUaGlzIGZ1bmN0aW9uIHdpbGwgbG9hZCB0
aGUgcmVxdWVzdCBpZCBhbmQgdmFyaW91cyBzZ2xzIGZvciBpb2N0bHMgKi8KLXN0YXRpYyB2b2lk
IHR3YV9sb2FkX3NnbChUV19Db21tYW5kX0Z1bGwgKmZ1bGxfY29tbWFuZF9wYWNrZXQsIGludCBy
ZXF1ZXN0X2lkLCBkbWFfYWRkcl90IGRtYV9oYW5kbGUsIGludCBsZW5ndGgpCitzdGF0aWMgdm9p
ZCB0d2FfbG9hZF9zZ2woVFdfRGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2LCBUV19Db21tYW5kX0Z1
bGwgKmZ1bGxfY29tbWFuZF9wYWNrZXQsIGludCByZXF1ZXN0X2lkLCBkbWFfYWRkcl90IGRtYV9o
YW5kbGUsIGludCBsZW5ndGgpCiB7CiAJVFdfQ29tbWFuZCAqb2xkY29tbWFuZDsKIAlUV19Db21t
YW5kX0FwYWNoZSAqbmV3Y29tbWFuZDsKIAlUV19TR19FbnRyeSAqc2dsOworCXVuc2lnbmVkIGlu
dCBwYWUgPSAwOworCisJaWYgKChzaXplb2YobG9uZykgPCA4KSAmJiAoc2l6ZW9mKGRtYV9hZGRy
X3QpID4gNCkpCisJCXBhZSA9IDE7CiAKIAlpZiAoVFdfT1BfT1VUKGZ1bGxfY29tbWFuZF9wYWNr
ZXQtPmNvbW1hbmQubmV3Y29tbWFuZC5vcGNvZGVfX3Jlc2VydmVkKSA9PSBUV19PUF9FWEVDVVRF
X1NDU0kpIHsKIAkJbmV3Y29tbWFuZCA9ICZmdWxsX2NvbW1hbmRfcGFja2V0LT5jb21tYW5kLm5l
d2NvbW1hbmQ7CkBAIC0xMzcyLDEyICsxMzc3LDE0IEBACiAKIAkJaWYgKFRXX1NHTF9PVVQob2xk
Y29tbWFuZC0+b3Bjb2RlX19zZ2xvZmZzZXQpKSB7CiAJCQkvKiBMb2FkIHRoZSBzZyBsaXN0ICov
Ci0JCQlzZ2wgPSAoVFdfU0dfRW50cnkgKikoKHUzMiAqKW9sZGNvbW1hbmQrVFdfU0dMX09VVChv
bGRjb21tYW5kLT5vcGNvZGVfX3NnbG9mZnNldCkpOworCQkJaWYgKHR3X2Rldi0+dHdfcGNpX2Rl
di0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfM1dBUkVfOTY5MFNBKQorCQkJCXNnbCA9IChUV19T
R19FbnRyeSAqKSgodTMyICopb2xkY29tbWFuZCtvbGRjb21tYW5kLT5zaXplIC0gKHNpemVvZihU
V19TR19FbnRyeSkvNCkgKyBwYWUpOworCQkJZWxzZQorCQkJCXNnbCA9IChUV19TR19FbnRyeSAq
KSgodTMyICopb2xkY29tbWFuZCtUV19TR0xfT1VUKG9sZGNvbW1hbmQtPm9wY29kZV9fc2dsb2Zm
c2V0KSk7CiAJCQlzZ2wtPmFkZHJlc3MgPSBUV19DUFVfVE9fU0dMKGRtYV9oYW5kbGUgKyBzaXpl
b2YoVFdfSW9jdGxfQnVmX0FwYWNoZSkgLSAxKTsKIAkJCXNnbC0+bGVuZ3RoID0gY3B1X3RvX2xl
MzIobGVuZ3RoKTsKIAotCQkJaWYgKChzaXplb2YobG9uZykgPCA4KSAmJiAoc2l6ZW9mKGRtYV9h
ZGRyX3QpID4gNCkpCi0JCQkJb2xkY29tbWFuZC0+c2l6ZSArPSAxOworCQkJb2xkY29tbWFuZC0+
c2l6ZSArPSBwYWU7CiAJCX0KIAl9CiB9IC8qIEVuZCB0d2FfbG9hZF9zZ2woKSAqLwpAQCAtMTUw
Niw3ICsxNTEzLDggQEAKIAljb21tYW5kX3F1ZV92YWx1ZSA9IHR3X2Rldi0+Y29tbWFuZF9wYWNr
ZXRfcGh5c1tyZXF1ZXN0X2lkXTsKIAogCS8qIEZvciA5NjUwU0Ugd3JpdGUgbG93IDQgYnl0ZXMg
Zmlyc3QgKi8KLQlpZiAodHdfZGV2LT50d19wY2lfZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9J
RF8zV0FSRV85NjUwU0UpIHsKKwlpZiAoKHR3X2Rldi0+dHdfcGNpX2Rldi0+ZGV2aWNlID09IFBD
SV9ERVZJQ0VfSURfM1dBUkVfOTY1MFNFKSB8fAorCSAgICAodHdfZGV2LT50d19wY2lfZGV2LT5k
ZXZpY2UgPT0gUENJX0RFVklDRV9JRF8zV0FSRV85NjkwU0EpKSB7CiAJCWNvbW1hbmRfcXVlX3Zh
bHVlICs9IFRXX0NPTU1BTkRfT0ZGU0VUOwogCQl3cml0ZWwoKHUzMiljb21tYW5kX3F1ZV92YWx1
ZSwgVFdfQ09NTUFORF9RVUVVRV9SRUdfQUREUl9MQVJHRSh0d19kZXYpKTsKIAl9CkBAIC0xNTM3
LDcgKzE1NDUsOCBAQAogCQlUV19VTk1BU0tfQ09NTUFORF9JTlRFUlJVUFQodHdfZGV2KTsKIAkJ
Z290byBvdXQ7CiAJfSBlbHNlIHsKLQkJaWYgKHR3X2Rldi0+dHdfcGNpX2Rldi0+ZGV2aWNlID09
IFBDSV9ERVZJQ0VfSURfM1dBUkVfOTY1MFNFKSB7CisJCWlmICgodHdfZGV2LT50d19wY2lfZGV2
LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF8zV0FSRV85NjUwU0UpIHx8CisJCSAgICAodHdfZGV2
LT50d19wY2lfZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF8zV0FSRV85NjkwU0EpKSB7CiAJ
CQkvKiBOb3cgd3JpdGUgdXBwZXIgNCBieXRlcyAqLwogCQkJd3JpdGVsKCh1MzIpKCh1NjQpY29t
bWFuZF9xdWVfdmFsdWUgPj4gMzIpLCBUV19DT01NQU5EX1FVRVVFX1JFR19BRERSX0xBUkdFKHR3
X2RldikgKyAweDQpOwogCQl9IGVsc2UgewpAQCAtMTU2MSw3ICsxNTcwLDcgQEAKIH0gLyogRW5k
IHR3YV9wb3N0X2NvbW1hbmRfcGFja2V0KCkgKi8KIAogLyogVGhpcyBmdW5jdGlvbiB3aWxsIHJl
c2V0IGEgZGV2aWNlIGV4dGVuc2lvbiAqLwotc3RhdGljIGludCB0d2FfcmVzZXRfZGV2aWNlX2V4
dGVuc2lvbihUV19EZXZpY2VfRXh0ZW5zaW9uICp0d19kZXYsIGludCBpb2N0bF9yZXNldCkKK3N0
YXRpYyBpbnQgdHdhX3Jlc2V0X2RldmljZV9leHRlbnNpb24oVFdfRGV2aWNlX0V4dGVuc2lvbiAq
dHdfZGV2KQogewogCWludCBpID0gMDsKIAlpbnQgcmV0dmFsID0gMTsKQEAgLTE3MTksNyArMTcy
OCw3IEBACiAJbXV0ZXhfbG9jaygmdHdfZGV2LT5pb2N0bF9sb2NrKTsKIAogCS8qIE5vdyByZXNl
dCB0aGUgY2FyZCBhbmQgc29tZSBvZiB0aGUgZGV2aWNlIGV4dGVuc2lvbiBkYXRhICovCi0JaWYg
KHR3YV9yZXNldF9kZXZpY2VfZXh0ZW5zaW9uKHR3X2RldiwgMCkpIHsKKwlpZiAodHdhX3Jlc2V0
X2RldmljZV9leHRlbnNpb24odHdfZGV2KSkgewogCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBU
V19EUklWRVIsIDB4MmIsICJDb250cm9sbGVyIHJlc2V0IGZhaWxlZCBkdXJpbmcgc2NzaSBob3N0
IHJlc2V0Iik7CiAJCWdvdG8gb3V0OwogCX0KQEAgLTIwMDEsMTEgKzIwMTAsMTQgQEAKIAogCXBj
aV9zZXRfbWFzdGVyKHBkZXYpOwogCi0JcmV0dmFsID0gcGNpX3NldF9kbWFfbWFzayhwZGV2LCBz
aXplb2YoZG1hX2FkZHJfdCkgPiA0ID8gRE1BXzY0QklUX01BU0sgOiBETUFfMzJCSVRfTUFTSyk7
Ci0JaWYgKHJldHZhbCkgewotCQlUV19QUklOVEsoaG9zdCwgVFdfRFJJVkVSLCAweDIzLCAiRmFp
bGVkIHRvIHNldCBkbWEgbWFzayIpOwotCQlnb3RvIG91dF9kaXNhYmxlX2RldmljZTsKLQl9CisJ
aWYgKHBjaV9zZXRfZG1hX21hc2socGRldiwgRE1BXzY0QklUX01BU0spCisJICAgIHx8IHBjaV9z
ZXRfY29uc2lzdGVudF9kbWFfbWFzayhwZGV2LCBETUFfNjRCSVRfTUFTSykpCisJCWlmIChwY2lf
c2V0X2RtYV9tYXNrKHBkZXYsIERNQV8zMkJJVF9NQVNLKQorCQkgICAgfHwgcGNpX3NldF9jb25z
aXN0ZW50X2RtYV9tYXNrKHBkZXYsIERNQV8zMkJJVF9NQVNLKSkgeworCQkJVFdfUFJJTlRLKGhv
c3QsIFRXX0RSSVZFUiwgMHgyMywgIkZhaWxlZCB0byBzZXQgZG1hIG1hc2siKTsKKwkJCXJldHZh
bCA9IC1FTk9ERVY7CisJCQlnb3RvIG91dF9kaXNhYmxlX2RldmljZTsKKwkJfQogCiAJaG9zdCA9
IHNjc2lfaG9zdF9hbGxvYygmZHJpdmVyX3RlbXBsYXRlLCBzaXplb2YoVFdfRGV2aWNlX0V4dGVu
c2lvbikpOwogCWlmICghaG9zdCkgewpAQCAtMjA1Myw3ICsyMDY1LDggQEAKIAkJZ290byBvdXRf
aW91bm1hcDsKIAogCS8qIFNldCBob3N0IHNwZWNpZmljIHBhcmFtZXRlcnMgKi8KLQlpZiAocGRl
di0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfM1dBUkVfOTY1MFNFKQorCWlmICgocGRldi0+ZGV2
aWNlID09IFBDSV9ERVZJQ0VfSURfM1dBUkVfOTY1MFNFKSB8fAorCSAgICAocGRldi0+ZGV2aWNl
ID09IFBDSV9ERVZJQ0VfSURfM1dBUkVfOTY5MFNBKSkKIAkJaG9zdC0+bWF4X2lkID0gVFdfTUFY
X1VOSVRTXzk2NTBTRTsKIAllbHNlCiAJCWhvc3QtPm1heF9pZCA9IFRXX01BWF9VTklUUzsKQEAg
LTIxNjAsNiArMjE3Myw4IEBACiAJICBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCAwLCAwLCAwfSwK
IAl7IFBDSV9WRU5ET1JfSURfM1dBUkUsIFBDSV9ERVZJQ0VfSURfM1dBUkVfOTY1MFNFLAogCSAg
UENJX0FOWV9JRCwgUENJX0FOWV9JRCwgMCwgMCwgMH0sCisJeyBQQ0lfVkVORE9SX0lEXzNXQVJF
LCBQQ0lfREVWSUNFX0lEXzNXQVJFXzk2OTBTQSwKKwkgIFBDSV9BTllfSUQsIFBDSV9BTllfSUQs
IDAsIDAsIDB9LAogCXsgfQogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUocGNpLCB0d2FfcGNpX3Ri
bCk7CmRpZmYgLU5hdXIgc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvM3ctOXh4eC5oIHNjc2kt
bWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS8zdy05eHh4LmgKLS0tIHNjc2ktbWlzYy0yLjYvZHJp
dmVycy9zY3NpLzN3LTl4eHguaAkyMDA3LTA3LTA4IDE2OjMyOjE3LjAwMDAwMDAwMCAtMDcwMAor
Kysgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpLzN3LTl4eHguaAkyMDA3LTA3LTIwIDEz
OjA1OjEyLjAwMDAwMDAwMCAtMDcwMApAQCAtNCw3ICs0LDcgQEAKICAgIFdyaXR0ZW4gQnk6IEFk
YW0gUmFkZm9yZCA8bGludXhyYWlkQGFtY2MuY29tPgogICAgTW9kaWZpY2F0aW9ucyBCeTogVG9t
IENvdWNoIDxsaW51eHJhaWRAYW1jYy5jb20+CiAKLSAgIENvcHlyaWdodCAoQykgMjAwNC0yMDA2
IEFwcGxpZWQgTWljcm8gQ2lyY3VpdHMgQ29ycG9yYXRpb24uCisgICBDb3B5cmlnaHQgKEMpIDIw
MDQtMjAwNyBBcHBsaWVkIE1pY3JvIENpcmN1aXRzIENvcnBvcmF0aW9uLgogCiAgICBUaGlzIHBy
b2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1v
ZGlmeQogICAgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGlj
ZW5zZSBhcyBwdWJsaXNoZWQgYnkKQEAgLTQxOSw2ICs0MTksOSBAQAogI2lmbmRlZiBQQ0lfREVW
SUNFX0lEXzNXQVJFXzk2NTBTRQogI2RlZmluZSBQQ0lfREVWSUNFX0lEXzNXQVJFXzk2NTBTRSAw
eDEwMDQKICNlbmRpZgorI2lmbmRlZiBQQ0lfREVWSUNFX0lEXzNXQVJFXzk2OTBTQQorI2RlZmlu
ZSBQQ0lfREVWSUNFX0lEXzNXQVJFXzk2OTBTQSAweDEwMDUKKyNlbmRpZgogCiAvKiBCaXRtYXNr
IG1hY3JvcyB0byBlbGltaW5hdGUgYml0ZmllbGRzICovCiAK
------=_Part_31797_14642545.1184970508810--
