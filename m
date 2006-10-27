From: "adam radford" <aradford@gmail.com>
Subject: [PATCH 1/1] 3ware 9000 add support for 9650SE
Date: Thu, 26 Oct 2006 18:01:06 -0700
Message-ID: <b1bc6a000610261801q29b7f2c3pcdc532f351126276@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_35345_18494621.1161910866059"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:56878 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S1946070AbWJ0BBI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Oct 2006 21:01:08 -0400
Received: by ug-out-1314.google.com with SMTP id 32so561531ugm
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2006 18:01:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

------=_Part_35345_18494621.1161910866059
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The attached patch for scsi-misc-2.6 updates the 3ware 9000 driver:

- Free irq handler in __twa_shutdown().
- Serialize reset code.
- Add support for 9650SE controllers.

Signed-off-by: Adam Radford <linuxraid@amcc.com>

James, Please apply

Thanks!

-Adam

Note: The patch is attached as an attachment, and also included
in-line below.   The below may have line-wrap issues since I'm pasting
into gmail.

diff -Naur scsi-misc-2.6/drivers/scsi/3w-9xxx.c
scsi-misc-2.6.new/drivers/scsi/3w-9xxx.c
--- scsi-misc-2.6/drivers/scsi/3w-9xxx.c	2006-10-26 16:45:50.000000000 -0700
+++ scsi-misc-2.6.new/drivers/scsi/3w-9xxx.c	2006-10-26 16:58:34.000000000 -0700
@@ -66,6 +66,9 @@
    2.26.02.006 - Fix 9550SX pchip reset timeout.
                  Add big endian support.
    2.26.02.007 - Disable local interrupts during kmap/unmap_atomic().
+   2.26.02.008 - Free irq handler in __twa_shutdown().
+                 Serialize reset code.
+                 Add support for 9650SE controllers.
 */

 #include <linux/module.h>
@@ -89,7 +92,7 @@
 #include "3w-9xxx.h"

 /* Globals */
-#define TW_DRIVER_VERSION "2.26.02.007"
+#define TW_DRIVER_VERSION "2.26.02.008"
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -566,9 +569,9 @@
 		goto out;
 	}

-	tw_dev->working_srl = fw_on_ctlr_srl;
-	tw_dev->working_branch = fw_on_ctlr_branch;
-	tw_dev->working_build = fw_on_ctlr_build;
+	tw_dev->tw_compat_info.working_srl = fw_on_ctlr_srl;
+	tw_dev->tw_compat_info.working_branch = fw_on_ctlr_branch;
+	tw_dev->tw_compat_info.working_build = fw_on_ctlr_build;

 	/* Try base mode compatibility */
 	if (!(init_connect_result & TW_CTLR_FW_COMPATIBLE)) {
@@ -590,10 +593,23 @@
 			}
 			goto out;
 		}
-		tw_dev->working_srl = TW_BASE_FW_SRL;
-		tw_dev->working_branch = TW_BASE_FW_BRANCH;
-		tw_dev->working_build = TW_BASE_FW_BUILD;
-	}
+		tw_dev->tw_compat_info.working_srl = TW_BASE_FW_SRL;
+		tw_dev->tw_compat_info.working_branch = TW_BASE_FW_BRANCH;
+		tw_dev->tw_compat_info.working_build = TW_BASE_FW_BUILD;
+	}
+
+	/* Load rest of compatibility struct */
+	strncpy(tw_dev->tw_compat_info.driver_version, TW_DRIVER_VERSION,
strlen(TW_DRIVER_VERSION));
+	tw_dev->tw_compat_info.driver_srl_high = TW_CURRENT_DRIVER_SRL;
+	tw_dev->tw_compat_info.driver_branch_high = TW_CURRENT_DRIVER_BRANCH;
+	tw_dev->tw_compat_info.driver_build_high = TW_CURRENT_DRIVER_BUILD;
+	tw_dev->tw_compat_info.driver_srl_low = TW_BASE_FW_SRL;
+	tw_dev->tw_compat_info.driver_branch_low = TW_BASE_FW_BRANCH;
+	tw_dev->tw_compat_info.driver_build_low = TW_BASE_FW_BUILD;
+	tw_dev->tw_compat_info.fw_on_ctlr_srl = fw_on_ctlr_srl;
+	tw_dev->tw_compat_info.fw_on_ctlr_branch = fw_on_ctlr_branch;
+	tw_dev->tw_compat_info.fw_on_ctlr_build = fw_on_ctlr_build;
+
 	retval = 0;
 out:
 	return retval;
@@ -631,7 +647,7 @@
 		goto out2;

 	/* Check data buffer size */
-	if (driver_command.buffer_length > TW_MAX_SECTORS * 512) {
+	if (driver_command.buffer_length > TW_MAX_SECTORS * 2048) {
 		retval = TW_IOCTL_ERROR_OS_EINVAL;
 		goto out2;
 	}
@@ -680,13 +696,6 @@
 		/* Now wait for command to complete */
 		timeout = wait_event_timeout(tw_dev->ioctl_wqueue,
tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE, timeout);

-		/* See if we reset while waiting for the ioctl to complete */
-		if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
-			clear_bit(TW_IN_RESET, &tw_dev->flags);
-			retval = TW_IOCTL_ERROR_OS_ERESTARTSYS;
-			goto out3;
-		}
-
 		/* We timed out, and didn't get an interrupt */
 		if (tw_dev->chrdev_request_id != TW_IOCTL_CHRDEV_FREE) {
 			/* Now we need to reset the board */
@@ -694,11 +703,6 @@
 			       tw_dev->host->host_no, TW_DRIVER, 0xc,
 			       cmd);
 			retval = TW_IOCTL_ERROR_OS_EIO;
-			spin_lock_irqsave(tw_dev->host->host_lock, flags);
-			tw_dev->state[request_id] = TW_S_COMPLETED;
-			twa_free_request_id(tw_dev, request_id);
-			tw_dev->posted_request_count--;
-			spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
 			twa_reset_device_extension(tw_dev, 1);
 			goto out3;
 		}
@@ -717,16 +721,7 @@
 		tw_ioctl->driver_command.status = 0;
 		/* Copy compatiblity struct into ioctl data buffer */
 		tw_compat_info = (TW_Compatibility_Info *)tw_ioctl->data_buffer;
-		strncpy(tw_compat_info->driver_version, TW_DRIVER_VERSION,
strlen(TW_DRIVER_VERSION));
-		tw_compat_info->working_srl = tw_dev->working_srl;
-		tw_compat_info->working_branch = tw_dev->working_branch;
-		tw_compat_info->working_build = tw_dev->working_build;
-		tw_compat_info->driver_srl_high = TW_CURRENT_DRIVER_SRL;
-		tw_compat_info->driver_branch_high = TW_CURRENT_DRIVER_BRANCH;
-		tw_compat_info->driver_build_high = TW_CURRENT_DRIVER_BUILD;
-		tw_compat_info->driver_srl_low = TW_BASE_FW_SRL;
-		tw_compat_info->driver_branch_low = TW_BASE_FW_BRANCH;
-		tw_compat_info->driver_build_low = TW_BASE_FW_BUILD;
+		memcpy(tw_compat_info, &tw_dev->tw_compat_info,
sizeof(TW_Compatibility_Info));
 		break;
 	case TW_IOCTL_GET_LAST_EVENT:
 		if (tw_dev->event_queue_wrapped) {
@@ -895,7 +890,8 @@
 	}

 	if (status_reg_value & TW_STATUS_QUEUE_ERROR) {
-		TW_PRINTK(tw_dev->host, TW_DRIVER, 0xe, "Controller Queue Error: clearing");
+		if ((tw_dev->tw_pci_dev->device != PCI_DEVICE_ID_3WARE_9650SE) ||
(!test_bit(TW_IN_RESET, &tw_dev->flags)))
+			TW_PRINTK(tw_dev->host, TW_DRIVER, 0xe, "Controller Queue Error: clearing");
 		writel(TW_CONTROL_CLEAR_QUEUE_ERROR, TW_CONTROL_REG_ADDR(tw_dev));
 	}

@@ -939,10 +935,12 @@
 	unsigned long before;
 	int retval = 1;

-	if (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9550SX) {
+	if ((tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9550SX) ||
+	    (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9650SE)) {
 		before = jiffies;
 		while ((response_que_value & TW_9550SX_DRAIN_COMPLETED) !=
TW_9550SX_DRAIN_COMPLETED) {
 			response_que_value = readl(TW_RESPONSE_QUEUE_REG_ADDR_LARGE(tw_dev));
+			msleep(1);
 			if (time_after(jiffies, before + HZ * 30))
 				goto out;
 		}
@@ -1214,6 +1212,10 @@

 	handled = 1;

+	/* If we are resetting, bail */
+	if (test_bit(TW_IN_RESET, &tw_dev->flags))
+		goto twa_interrupt_bail;
+
 	/* Check controller for errors */
 	if (twa_check_bits(status_reg_value)) {
 		if (twa_decode_bits(tw_dev, status_reg_value)) {
@@ -1355,8 +1357,8 @@

 	if (TW_OP_OUT(full_command_packet->command.newcommand.opcode__reserved)
== TW_OP_EXECUTE_SCSI) {
 		newcommand = &full_command_packet->command.newcommand;
-		newcommand->request_id__lunl =
-			TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl), request_id);
+		newcommand->request_id__lunl =
+			cpu_to_le16(TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl),
request_id));
 		newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle +
sizeof(TW_Ioctl_Buf_Apache) - 1);
 		newcommand->sg_list[0].length = cpu_to_le32(length);
 		newcommand->sgl_entries__lunh =
@@ -1531,6 +1533,13 @@
 	int retval = 1;

 	command_que_value = tw_dev->command_packet_phys[request_id];
+
+	/* For 9650SE write low 4 bytes first */
+	if (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9650SE) {
+		command_que_value += TW_COMMAND_OFFSET;
+		writel((u32)command_que_value, TW_COMMAND_QUEUE_REG_ADDR_LARGE(tw_dev));
+	}
+
 	status_reg_value = readl(TW_STATUS_REG_ADDR(tw_dev));

 	if (twa_check_bits(status_reg_value))
@@ -1557,13 +1566,17 @@
 		TW_UNMASK_COMMAND_INTERRUPT(tw_dev);
 		goto out;
 	} else {
-		/* We successfully posted the command packet */
-		if (sizeof(dma_addr_t) > 4) {
-			command_que_value += TW_COMMAND_OFFSET;
-			writel((u32)command_que_value, TW_COMMAND_QUEUE_REG_ADDR(tw_dev));
-			writel((u32)((u64)command_que_value >> 32),
TW_COMMAND_QUEUE_REG_ADDR(tw_dev) + 0x4);
+		if (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9650SE) {
+			/* Now write upper 4 bytes */
+			writel((u32)((u64)command_que_value >> 32),
TW_COMMAND_QUEUE_REG_ADDR_LARGE(tw_dev) + 0x4);
 		} else {
-			writel(TW_COMMAND_OFFSET + command_que_value,
TW_COMMAND_QUEUE_REG_ADDR(tw_dev));
+			if (sizeof(dma_addr_t) > 4) {
+				command_que_value += TW_COMMAND_OFFSET;
+				writel((u32)command_que_value, TW_COMMAND_QUEUE_REG_ADDR(tw_dev));
+				writel((u32)((u64)command_que_value >> 32),
TW_COMMAND_QUEUE_REG_ADDR(tw_dev) + 0x4);
+			} else {
+				writel(TW_COMMAND_OFFSET + command_que_value,
TW_COMMAND_QUEUE_REG_ADDR(tw_dev));
+			}
 		}
 		tw_dev->state[request_id] = TW_S_POSTED;
 		tw_dev->posted_request_count++;
@@ -1620,14 +1633,9 @@
 		goto out;

 	TW_ENABLE_AND_CLEAR_INTERRUPTS(tw_dev);
+	clear_bit(TW_IN_RESET, &tw_dev->flags);
+	tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;

-	/* Wake up any ioctl that was pending before the reset */
-	if ((tw_dev->chrdev_request_id == TW_IOCTL_CHRDEV_FREE) || (ioctl_reset)) {
-		clear_bit(TW_IN_RESET, &tw_dev->flags);
-	} else {
-		tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
-		wake_up(&tw_dev->ioctl_wqueue);
-	}
 	retval = 0;
 out:
 	return retval;
@@ -1736,6 +1744,9 @@
 		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
 		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);

+	/* Make sure we are not issuing an ioctl or resetting from ioctl */
+	mutex_lock(&tw_dev->ioctl_lock);
+
 	/* Now reset the card and some of the device extension data */
 	if (twa_reset_device_extension(tw_dev, 0)) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x2b, "Controller reset failed
during scsi host reset");
@@ -1744,6 +1755,7 @@

 	retval = SUCCESS;
 out:
+	mutex_unlock(&tw_dev->ioctl_lock);
 	return retval;
 } /* End twa_scsi_eh_reset() */

@@ -1753,8 +1765,14 @@
 	int request_id, retval;
 	TW_Device_Extension *tw_dev = (TW_Device_Extension
*)SCpnt->device->host->hostdata;

+	/* If we are resetting due to timed out ioctl, report as busy */
+	if (test_bit(TW_IN_RESET, &tw_dev->flags)) {
+		retval = SCSI_MLQUEUE_HOST_BUSY;
+		goto out;
+	}
+
 	/* Check if this FW supports luns */
-	if ((SCpnt->device->lun != 0) && (tw_dev->working_srl <
TW_FW_SRL_LUNS_SUPPORTED)) {
+	if ((SCpnt->device->lun != 0) && (tw_dev->tw_compat_info.working_srl
< TW_FW_SRL_LUNS_SUPPORTED)) {
 		SCpnt->result = (DID_BAD_TARGET << 16);
 		done(SCpnt);
 		retval = 0;
@@ -1960,6 +1978,9 @@
 	/* Disable interrupts */
 	TW_DISABLE_INTERRUPTS(tw_dev);

+	/* Free up the IRQ */
+	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
+
 	printk(KERN_WARNING "3w-9xxx: Shutting down host %d.\n",
tw_dev->host->host_no);

 	/* Tell the card we are shutting down */
@@ -2091,21 +2112,25 @@

 	/* Initialize the card */
 	if (twa_reset_sequence(tw_dev, 0))
-		goto out_release_mem_region;
+		goto out_iounmap;

 	/* Set host specific parameters */
-	host->max_id = TW_MAX_UNITS;
+	if (pdev->device == PCI_DEVICE_ID_3WARE_9650SE)
+		host->max_id = TW_MAX_UNITS_9650SE;
+	else
+		host->max_id = TW_MAX_UNITS;
+
 	host->max_cmd_len = TW_MAX_CDB_LEN;

 	/* Channels aren't supported by adapter */
-	host->max_lun = TW_MAX_LUNS(tw_dev->working_srl);
+	host->max_lun = TW_MAX_LUNS(tw_dev->tw_compat_info.working_srl);
 	host->max_channel = 0;

 	/* Register the card with the kernel SCSI layer */
 	retval = scsi_add_host(host, &pdev->dev);
 	if (retval) {
 		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x27, "scsi add host failed");
-		goto out_release_mem_region;
+		goto out_iounmap;
 	}

 	pci_set_drvdata(pdev, host);
@@ -2145,6 +2170,8 @@

 out_remove_host:
 	scsi_remove_host(host);
+out_iounmap:
+	iounmap(tw_dev->base_addr);
 out_release_mem_region:
 	pci_release_regions(pdev);
 out_free_device_extension:
@@ -2170,12 +2197,12 @@
 		twa_major = -1;
 	}

-	/* Free up the IRQ */
-	free_irq(tw_dev->tw_pci_dev->irq, tw_dev);
-
 	/* Shutdown the card */
 	__twa_shutdown(tw_dev);

+	/* Free IO remapping */
+	iounmap(tw_dev->base_addr);
+
 	/* Free up the mem region */
 	pci_release_regions(pdev);

@@ -2193,6 +2220,8 @@
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9550SX,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9650SE,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, twa_pci_tbl);
diff -Naur scsi-misc-2.6/drivers/scsi/3w-9xxx.h
scsi-misc-2.6.new/drivers/scsi/3w-9xxx.h
--- scsi-misc-2.6/drivers/scsi/3w-9xxx.h	2006-09-19 20:42:06.000000000 -0700
+++ scsi-misc-2.6.new/drivers/scsi/3w-9xxx.h	2006-10-26 16:58:36.000000000 -0700
@@ -289,7 +289,6 @@
 #define TW_STATUS_VALID_INTERRUPT              0x00DF0000

 /* PCI related defines */
-#define TW_NUMDEVICES 1
 #define TW_PCI_CLEAR_PARITY_ERRORS 0xc100
 #define TW_PCI_CLEAR_PCI_ABORT     0x2000

@@ -335,6 +334,7 @@
 #define TW_ALIGNMENT_9000                     4  /* 4 bytes */
 #define TW_ALIGNMENT_9000_SGL                 0x3
 #define TW_MAX_UNITS			      16
+#define TW_MAX_UNITS_9650SE		      32
 #define TW_INIT_MESSAGE_CREDITS		      0x100
 #define TW_INIT_COMMAND_PACKET_SIZE	      0x3
 #define TW_INIT_COMMAND_PACKET_SIZE_EXTENDED  0x6
@@ -354,7 +354,6 @@
 #define TW_MAX_RESPONSE_DRAIN		      256
 #define TW_MAX_AEN_DRAIN		      40
 #define TW_IN_RESET                           2
-#define TW_IN_CHRDEV_IOCTL                    3
 #define TW_IN_ATTENTION_LOOP		      4
 #define TW_MAX_SECTORS                        256
 #define TW_AEN_WAIT_TIME                      1000
@@ -417,6 +416,9 @@
 #ifndef PCI_DEVICE_ID_3WARE_9550SX
 #define PCI_DEVICE_ID_3WARE_9550SX 0x1003
 #endif
+#ifndef PCI_DEVICE_ID_3WARE_9650SE
+#define PCI_DEVICE_ID_3WARE_9650SE 0x1004
+#endif

 /* Bitmask macros to eliminate bitfields */

@@ -442,6 +444,7 @@
 #define TW_CONTROL_REG_ADDR(x) (x->base_addr)
 #define TW_STATUS_REG_ADDR(x) ((unsigned char __iomem *)x->base_addr + 0x4)
 #define TW_COMMAND_QUEUE_REG_ADDR(x) (sizeof(dma_addr_t) > 4 ?
((unsigned char __iomem *)x->base_addr + 0x20) : ((unsigned char
__iomem *)x->base_addr + 0x8))
+#define TW_COMMAND_QUEUE_REG_ADDR_LARGE(x) ((unsigned char __iomem
*)x->base_addr + 0x20)
 #define TW_RESPONSE_QUEUE_REG_ADDR(x) ((unsigned char __iomem
*)x->base_addr + 0xC)
 #define TW_RESPONSE_QUEUE_REG_ADDR_LARGE(x) ((unsigned char __iomem
*)x->base_addr + 0x30)
 #define TW_CLEAR_ALL_INTERRUPTS(x) (writel(TW_STATUS_VALID_INTERRUPT,
TW_CONTROL_REG_ADDR(x)))
@@ -626,6 +629,9 @@
 	unsigned short driver_srl_low;
 	unsigned short driver_branch_low;
 	unsigned short driver_build_low;
+	unsigned short fw_on_ctlr_srl;
+	unsigned short fw_on_ctlr_branch;
+	unsigned short fw_on_ctlr_build;
 } TW_Compatibility_Info;

 #pragma pack()
@@ -668,9 +674,7 @@
 	wait_queue_head_t	ioctl_wqueue;
 	struct mutex		ioctl_lock;
 	char			aen_clobber;
-	unsigned short		working_srl;
-	unsigned short		working_branch;
-	unsigned short		working_build;
+	TW_Compatibility_Info	tw_compat_info;
 } TW_Device_Extension;

 #endif /* _3W_9XXX_H */

------=_Part_35345_18494621.1161910866059
Content-Type: text/x-patch; name=3ware_linux_2.6.20.patch;
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_etru7egr
Content-Disposition: attachment; filename="3ware_linux_2.6.20.patch"

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS8zdy05eHh4LmMgc2NzaS1taXNj
LTIuNi5uZXcvZHJpdmVycy9zY3NpLzN3LTl4eHguYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJz
L3Njc2kvM3ctOXh4eC5jCTIwMDYtMTAtMjYgMTY6NDU6NTAuMDAwMDAwMDAwIC0wNzAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvM3ctOXh4eC5jCTIwMDYtMTAtMjYgMTY6NTg6
MzQuMDAwMDAwMDAwIC0wNzAwCkBAIC02Niw2ICs2Niw5IEBACiAgICAyLjI2LjAyLjAwNiAtIEZp
eCA5NTUwU1ggcGNoaXAgcmVzZXQgdGltZW91dC4KICAgICAgICAgICAgICAgICAgQWRkIGJpZyBl
bmRpYW4gc3VwcG9ydC4KICAgIDIuMjYuMDIuMDA3IC0gRGlzYWJsZSBsb2NhbCBpbnRlcnJ1cHRz
IGR1cmluZyBrbWFwL3VubWFwX2F0b21pYygpLgorICAgMi4yNi4wMi4wMDggLSBGcmVlIGlycSBo
YW5kbGVyIGluIF9fdHdhX3NodXRkb3duKCkuCisgICAgICAgICAgICAgICAgIFNlcmlhbGl6ZSBy
ZXNldCBjb2RlLgorICAgICAgICAgICAgICAgICBBZGQgc3VwcG9ydCBmb3IgOTY1MFNFIGNvbnRy
b2xsZXJzLgogKi8KIAogI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgpAQCAtODksNyArOTIsNyBA
QAogI2luY2x1ZGUgIjN3LTl4eHguaCIKIAogLyogR2xvYmFscyAqLwotI2RlZmluZSBUV19EUklW
RVJfVkVSU0lPTiAiMi4yNi4wMi4wMDciCisjZGVmaW5lIFRXX0RSSVZFUl9WRVJTSU9OICIyLjI2
LjAyLjAwOCIKIHN0YXRpYyBUV19EZXZpY2VfRXh0ZW5zaW9uICp0d2FfZGV2aWNlX2V4dGVuc2lv
bl9saXN0W1RXX01BWF9TTE9UXTsKIHN0YXRpYyB1bnNpZ25lZCBpbnQgdHdhX2RldmljZV9leHRl
bnNpb25fY291bnQ7CiBzdGF0aWMgaW50IHR3YV9tYWpvciA9IC0xOwpAQCAtNTY2LDkgKzU2OSw5
IEBACiAJCWdvdG8gb3V0OwogCX0KIAotCXR3X2Rldi0+d29ya2luZ19zcmwgPSBmd19vbl9jdGxy
X3NybDsKLQl0d19kZXYtPndvcmtpbmdfYnJhbmNoID0gZndfb25fY3Rscl9icmFuY2g7Ci0JdHdf
ZGV2LT53b3JraW5nX2J1aWxkID0gZndfb25fY3Rscl9idWlsZDsKKwl0d19kZXYtPnR3X2NvbXBh
dF9pbmZvLndvcmtpbmdfc3JsID0gZndfb25fY3Rscl9zcmw7CisJdHdfZGV2LT50d19jb21wYXRf
aW5mby53b3JraW5nX2JyYW5jaCA9IGZ3X29uX2N0bHJfYnJhbmNoOworCXR3X2Rldi0+dHdfY29t
cGF0X2luZm8ud29ya2luZ19idWlsZCA9IGZ3X29uX2N0bHJfYnVpbGQ7CiAKIAkvKiBUcnkgYmFz
ZSBtb2RlIGNvbXBhdGliaWxpdHkgKi8KIAlpZiAoIShpbml0X2Nvbm5lY3RfcmVzdWx0ICYgVFdf
Q1RMUl9GV19DT01QQVRJQkxFKSkgewpAQCAtNTkwLDEwICs1OTMsMjMgQEAKIAkJCX0KIAkJCWdv
dG8gb3V0OwogCQl9Ci0JCXR3X2Rldi0+d29ya2luZ19zcmwgPSBUV19CQVNFX0ZXX1NSTDsKLQkJ
dHdfZGV2LT53b3JraW5nX2JyYW5jaCA9IFRXX0JBU0VfRldfQlJBTkNIOwotCQl0d19kZXYtPndv
cmtpbmdfYnVpbGQgPSBUV19CQVNFX0ZXX0JVSUxEOwotCX0KKwkJdHdfZGV2LT50d19jb21wYXRf
aW5mby53b3JraW5nX3NybCA9IFRXX0JBU0VfRldfU1JMOworCQl0d19kZXYtPnR3X2NvbXBhdF9p
bmZvLndvcmtpbmdfYnJhbmNoID0gVFdfQkFTRV9GV19CUkFOQ0g7CisJCXR3X2Rldi0+dHdfY29t
cGF0X2luZm8ud29ya2luZ19idWlsZCA9IFRXX0JBU0VfRldfQlVJTEQ7CisJfQorCisJLyogTG9h
ZCByZXN0IG9mIGNvbXBhdGliaWxpdHkgc3RydWN0ICovCisJc3RybmNweSh0d19kZXYtPnR3X2Nv
bXBhdF9pbmZvLmRyaXZlcl92ZXJzaW9uLCBUV19EUklWRVJfVkVSU0lPTiwgc3RybGVuKFRXX0RS
SVZFUl9WRVJTSU9OKSk7CisJdHdfZGV2LT50d19jb21wYXRfaW5mby5kcml2ZXJfc3JsX2hpZ2gg
PSBUV19DVVJSRU5UX0RSSVZFUl9TUkw7CisJdHdfZGV2LT50d19jb21wYXRfaW5mby5kcml2ZXJf
YnJhbmNoX2hpZ2ggPSBUV19DVVJSRU5UX0RSSVZFUl9CUkFOQ0g7CisJdHdfZGV2LT50d19jb21w
YXRfaW5mby5kcml2ZXJfYnVpbGRfaGlnaCA9IFRXX0NVUlJFTlRfRFJJVkVSX0JVSUxEOworCXR3
X2Rldi0+dHdfY29tcGF0X2luZm8uZHJpdmVyX3NybF9sb3cgPSBUV19CQVNFX0ZXX1NSTDsKKwl0
d19kZXYtPnR3X2NvbXBhdF9pbmZvLmRyaXZlcl9icmFuY2hfbG93ID0gVFdfQkFTRV9GV19CUkFO
Q0g7CisJdHdfZGV2LT50d19jb21wYXRfaW5mby5kcml2ZXJfYnVpbGRfbG93ID0gVFdfQkFTRV9G
V19CVUlMRDsKKwl0d19kZXYtPnR3X2NvbXBhdF9pbmZvLmZ3X29uX2N0bHJfc3JsID0gZndfb25f
Y3Rscl9zcmw7CisJdHdfZGV2LT50d19jb21wYXRfaW5mby5md19vbl9jdGxyX2JyYW5jaCA9IGZ3
X29uX2N0bHJfYnJhbmNoOworCXR3X2Rldi0+dHdfY29tcGF0X2luZm8uZndfb25fY3Rscl9idWls
ZCA9IGZ3X29uX2N0bHJfYnVpbGQ7CisKIAlyZXR2YWwgPSAwOwogb3V0OgogCXJldHVybiByZXR2
YWw7CkBAIC02MzEsNyArNjQ3LDcgQEAKIAkJZ290byBvdXQyOwogCiAJLyogQ2hlY2sgZGF0YSBi
dWZmZXIgc2l6ZSAqLwotCWlmIChkcml2ZXJfY29tbWFuZC5idWZmZXJfbGVuZ3RoID4gVFdfTUFY
X1NFQ1RPUlMgKiA1MTIpIHsKKwlpZiAoZHJpdmVyX2NvbW1hbmQuYnVmZmVyX2xlbmd0aCA+IFRX
X01BWF9TRUNUT1JTICogMjA0OCkgewogCQlyZXR2YWwgPSBUV19JT0NUTF9FUlJPUl9PU19FSU5W
QUw7CiAJCWdvdG8gb3V0MjsKIAl9CkBAIC02ODAsMTMgKzY5Niw2IEBACiAJCS8qIE5vdyB3YWl0
IGZvciBjb21tYW5kIHRvIGNvbXBsZXRlICovCiAJCXRpbWVvdXQgPSB3YWl0X2V2ZW50X3RpbWVv
dXQodHdfZGV2LT5pb2N0bF93cXVldWUsIHR3X2Rldi0+Y2hyZGV2X3JlcXVlc3RfaWQgPT0gVFdf
SU9DVExfQ0hSREVWX0ZSRUUsIHRpbWVvdXQpOwogCi0JCS8qIFNlZSBpZiB3ZSByZXNldCB3aGls
ZSB3YWl0aW5nIGZvciB0aGUgaW9jdGwgdG8gY29tcGxldGUgKi8KLQkJaWYgKHRlc3RfYml0KFRX
X0lOX1JFU0VULCAmdHdfZGV2LT5mbGFncykpIHsKLQkJCWNsZWFyX2JpdChUV19JTl9SRVNFVCwg
JnR3X2Rldi0+ZmxhZ3MpOwotCQkJcmV0dmFsID0gVFdfSU9DVExfRVJST1JfT1NfRVJFU1RBUlRT
WVM7Ci0JCQlnb3RvIG91dDM7Ci0JCX0KLQogCQkvKiBXZSB0aW1lZCBvdXQsIGFuZCBkaWRuJ3Qg
Z2V0IGFuIGludGVycnVwdCAqLwogCQlpZiAodHdfZGV2LT5jaHJkZXZfcmVxdWVzdF9pZCAhPSBU
V19JT0NUTF9DSFJERVZfRlJFRSkgewogCQkJLyogTm93IHdlIG5lZWQgdG8gcmVzZXQgdGhlIGJv
YXJkICovCkBAIC02OTQsMTEgKzcwMyw2IEBACiAJCQkgICAgICAgdHdfZGV2LT5ob3N0LT5ob3N0
X25vLCBUV19EUklWRVIsIDB4YywKIAkJCSAgICAgICBjbWQpOwogCQkJcmV0dmFsID0gVFdfSU9D
VExfRVJST1JfT1NfRUlPOwotCQkJc3Bpbl9sb2NrX2lycXNhdmUodHdfZGV2LT5ob3N0LT5ob3N0
X2xvY2ssIGZsYWdzKTsKLQkJCXR3X2Rldi0+c3RhdGVbcmVxdWVzdF9pZF0gPSBUV19TX0NPTVBM
RVRFRDsKLQkJCXR3YV9mcmVlX3JlcXVlc3RfaWQodHdfZGV2LCByZXF1ZXN0X2lkKTsKLQkJCXR3
X2Rldi0+cG9zdGVkX3JlcXVlc3RfY291bnQtLTsKLQkJCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
dHdfZGV2LT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKIAkJCXR3YV9yZXNldF9kZXZpY2VfZXh0
ZW5zaW9uKHR3X2RldiwgMSk7CiAJCQlnb3RvIG91dDM7CiAJCX0KQEAgLTcxNywxNiArNzIxLDcg
QEAKIAkJdHdfaW9jdGwtPmRyaXZlcl9jb21tYW5kLnN0YXR1cyA9IDA7CiAJCS8qIENvcHkgY29t
cGF0aWJsaXR5IHN0cnVjdCBpbnRvIGlvY3RsIGRhdGEgYnVmZmVyICovCiAJCXR3X2NvbXBhdF9p
bmZvID0gKFRXX0NvbXBhdGliaWxpdHlfSW5mbyAqKXR3X2lvY3RsLT5kYXRhX2J1ZmZlcjsKLQkJ
c3RybmNweSh0d19jb21wYXRfaW5mby0+ZHJpdmVyX3ZlcnNpb24sIFRXX0RSSVZFUl9WRVJTSU9O
LCBzdHJsZW4oVFdfRFJJVkVSX1ZFUlNJT04pKTsKLQkJdHdfY29tcGF0X2luZm8tPndvcmtpbmdf
c3JsID0gdHdfZGV2LT53b3JraW5nX3NybDsKLQkJdHdfY29tcGF0X2luZm8tPndvcmtpbmdfYnJh
bmNoID0gdHdfZGV2LT53b3JraW5nX2JyYW5jaDsKLQkJdHdfY29tcGF0X2luZm8tPndvcmtpbmdf
YnVpbGQgPSB0d19kZXYtPndvcmtpbmdfYnVpbGQ7Ci0JCXR3X2NvbXBhdF9pbmZvLT5kcml2ZXJf
c3JsX2hpZ2ggPSBUV19DVVJSRU5UX0RSSVZFUl9TUkw7Ci0JCXR3X2NvbXBhdF9pbmZvLT5kcml2
ZXJfYnJhbmNoX2hpZ2ggPSBUV19DVVJSRU5UX0RSSVZFUl9CUkFOQ0g7Ci0JCXR3X2NvbXBhdF9p
bmZvLT5kcml2ZXJfYnVpbGRfaGlnaCA9IFRXX0NVUlJFTlRfRFJJVkVSX0JVSUxEOwotCQl0d19j
b21wYXRfaW5mby0+ZHJpdmVyX3NybF9sb3cgPSBUV19CQVNFX0ZXX1NSTDsKLQkJdHdfY29tcGF0
X2luZm8tPmRyaXZlcl9icmFuY2hfbG93ID0gVFdfQkFTRV9GV19CUkFOQ0g7Ci0JCXR3X2NvbXBh
dF9pbmZvLT5kcml2ZXJfYnVpbGRfbG93ID0gVFdfQkFTRV9GV19CVUlMRDsKKwkJbWVtY3B5KHR3
X2NvbXBhdF9pbmZvLCAmdHdfZGV2LT50d19jb21wYXRfaW5mbywgc2l6ZW9mKFRXX0NvbXBhdGli
aWxpdHlfSW5mbykpOwogCQlicmVhazsKIAljYXNlIFRXX0lPQ1RMX0dFVF9MQVNUX0VWRU5UOgog
CQlpZiAodHdfZGV2LT5ldmVudF9xdWV1ZV93cmFwcGVkKSB7CkBAIC04OTUsNyArODkwLDggQEAK
IAl9CiAKIAlpZiAoc3RhdHVzX3JlZ192YWx1ZSAmIFRXX1NUQVRVU19RVUVVRV9FUlJPUikgewot
CQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIsIDB4ZSwgIkNvbnRyb2xsZXIgUXVl
dWUgRXJyb3I6IGNsZWFyaW5nIik7CisJCWlmICgodHdfZGV2LT50d19wY2lfZGV2LT5kZXZpY2Ug
IT0gUENJX0RFVklDRV9JRF8zV0FSRV85NjUwU0UpIHx8ICghdGVzdF9iaXQoVFdfSU5fUkVTRVQs
ICZ0d19kZXYtPmZsYWdzKSkpCisJCQlUV19QUklOVEsodHdfZGV2LT5ob3N0LCBUV19EUklWRVIs
IDB4ZSwgIkNvbnRyb2xsZXIgUXVldWUgRXJyb3I6IGNsZWFyaW5nIik7CiAJCXdyaXRlbChUV19D
T05UUk9MX0NMRUFSX1FVRVVFX0VSUk9SLCBUV19DT05UUk9MX1JFR19BRERSKHR3X2RldikpOwog
CX0KIApAQCAtOTM5LDEwICs5MzUsMTIgQEAKIAl1bnNpZ25lZCBsb25nIGJlZm9yZTsKIAlpbnQg
cmV0dmFsID0gMTsKIAotCWlmICh0d19kZXYtPnR3X3BjaV9kZXYtPmRldmljZSA9PSBQQ0lfREVW
SUNFX0lEXzNXQVJFXzk1NTBTWCkgeworCWlmICgodHdfZGV2LT50d19wY2lfZGV2LT5kZXZpY2Ug
PT0gUENJX0RFVklDRV9JRF8zV0FSRV85NTUwU1gpIHx8CisJICAgICh0d19kZXYtPnR3X3BjaV9k
ZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEXzNXQVJFXzk2NTBTRSkpIHsKIAkJYmVmb3JlID0g
amlmZmllczsKIAkJd2hpbGUgKChyZXNwb25zZV9xdWVfdmFsdWUgJiBUV185NTUwU1hfRFJBSU5f
Q09NUExFVEVEKSAhPSBUV185NTUwU1hfRFJBSU5fQ09NUExFVEVEKSB7CiAJCQlyZXNwb25zZV9x
dWVfdmFsdWUgPSByZWFkbChUV19SRVNQT05TRV9RVUVVRV9SRUdfQUREUl9MQVJHRSh0d19kZXYp
KTsKKwkJCW1zbGVlcCgxKTsKIAkJCWlmICh0aW1lX2FmdGVyKGppZmZpZXMsIGJlZm9yZSArIEha
ICogMzApKQogCQkJCWdvdG8gb3V0OwogCQl9CkBAIC0xMjE0LDYgKzEyMTIsMTAgQEAKIAogCWhh
bmRsZWQgPSAxOwogCisJLyogSWYgd2UgYXJlIHJlc2V0dGluZywgYmFpbCAqLworCWlmICh0ZXN0
X2JpdChUV19JTl9SRVNFVCwgJnR3X2Rldi0+ZmxhZ3MpKQorCQlnb3RvIHR3YV9pbnRlcnJ1cHRf
YmFpbDsKKwogCS8qIENoZWNrIGNvbnRyb2xsZXIgZm9yIGVycm9ycyAqLwogCWlmICh0d2FfY2hl
Y2tfYml0cyhzdGF0dXNfcmVnX3ZhbHVlKSkgewogCQlpZiAodHdhX2RlY29kZV9iaXRzKHR3X2Rl
diwgc3RhdHVzX3JlZ192YWx1ZSkpIHsKQEAgLTEzNTUsOCArMTM1Nyw4IEBACiAKIAlpZiAoVFdf
T1BfT1VUKGZ1bGxfY29tbWFuZF9wYWNrZXQtPmNvbW1hbmQubmV3Y29tbWFuZC5vcGNvZGVfX3Jl
c2VydmVkKSA9PSBUV19PUF9FWEVDVVRFX1NDU0kpIHsKIAkJbmV3Y29tbWFuZCA9ICZmdWxsX2Nv
bW1hbmRfcGFja2V0LT5jb21tYW5kLm5ld2NvbW1hbmQ7Ci0JCW5ld2NvbW1hbmQtPnJlcXVlc3Rf
aWRfX2x1bmwgPSAKLQkJCVRXX1JFUV9MVU5fSU4oVFdfTFVOX09VVChuZXdjb21tYW5kLT5yZXF1
ZXN0X2lkX19sdW5sKSwgcmVxdWVzdF9pZCk7CisJCW5ld2NvbW1hbmQtPnJlcXVlc3RfaWRfX2x1
bmwgPQorCQkJY3B1X3RvX2xlMTYoVFdfUkVRX0xVTl9JTihUV19MVU5fT1VUKG5ld2NvbW1hbmQt
PnJlcXVlc3RfaWRfX2x1bmwpLCByZXF1ZXN0X2lkKSk7CiAJCW5ld2NvbW1hbmQtPnNnX2xpc3Rb
MF0uYWRkcmVzcyA9IFRXX0NQVV9UT19TR0woZG1hX2hhbmRsZSArIHNpemVvZihUV19Jb2N0bF9C
dWZfQXBhY2hlKSAtIDEpOwogCQluZXdjb21tYW5kLT5zZ19saXN0WzBdLmxlbmd0aCA9IGNwdV90
b19sZTMyKGxlbmd0aCk7CiAJCW5ld2NvbW1hbmQtPnNnbF9lbnRyaWVzX19sdW5oID0KQEAgLTE1
MzEsNiArMTUzMywxMyBAQAogCWludCByZXR2YWwgPSAxOwogCiAJY29tbWFuZF9xdWVfdmFsdWUg
PSB0d19kZXYtPmNvbW1hbmRfcGFja2V0X3BoeXNbcmVxdWVzdF9pZF07CisKKwkvKiBGb3IgOTY1
MFNFIHdyaXRlIGxvdyA0IGJ5dGVzIGZpcnN0ICovCisJaWYgKHR3X2Rldi0+dHdfcGNpX2Rldi0+
ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfM1dBUkVfOTY1MFNFKSB7CisJCWNvbW1hbmRfcXVlX3Zh
bHVlICs9IFRXX0NPTU1BTkRfT0ZGU0VUOworCQl3cml0ZWwoKHUzMiljb21tYW5kX3F1ZV92YWx1
ZSwgVFdfQ09NTUFORF9RVUVVRV9SRUdfQUREUl9MQVJHRSh0d19kZXYpKTsKKwl9CisKIAlzdGF0
dXNfcmVnX3ZhbHVlID0gcmVhZGwoVFdfU1RBVFVTX1JFR19BRERSKHR3X2RldikpOwogCiAJaWYg
KHR3YV9jaGVja19iaXRzKHN0YXR1c19yZWdfdmFsdWUpKQpAQCAtMTU1NywxMyArMTU2NiwxNyBA
QAogCQlUV19VTk1BU0tfQ09NTUFORF9JTlRFUlJVUFQodHdfZGV2KTsKIAkJZ290byBvdXQ7CiAJ
fSBlbHNlIHsKLQkJLyogV2Ugc3VjY2Vzc2Z1bGx5IHBvc3RlZCB0aGUgY29tbWFuZCBwYWNrZXQg
Ki8KLQkJaWYgKHNpemVvZihkbWFfYWRkcl90KSA+IDQpIHsKLQkJCWNvbW1hbmRfcXVlX3ZhbHVl
ICs9IFRXX0NPTU1BTkRfT0ZGU0VUOwotCQkJd3JpdGVsKCh1MzIpY29tbWFuZF9xdWVfdmFsdWUs
IFRXX0NPTU1BTkRfUVVFVUVfUkVHX0FERFIodHdfZGV2KSk7Ci0JCQl3cml0ZWwoKHUzMikoKHU2
NCljb21tYW5kX3F1ZV92YWx1ZSA+PiAzMiksIFRXX0NPTU1BTkRfUVVFVUVfUkVHX0FERFIodHdf
ZGV2KSArIDB4NCk7CisJCWlmICh0d19kZXYtPnR3X3BjaV9kZXYtPmRldmljZSA9PSBQQ0lfREVW
SUNFX0lEXzNXQVJFXzk2NTBTRSkgeworCQkJLyogTm93IHdyaXRlIHVwcGVyIDQgYnl0ZXMgKi8K
KwkJCXdyaXRlbCgodTMyKSgodTY0KWNvbW1hbmRfcXVlX3ZhbHVlID4+IDMyKSwgVFdfQ09NTUFO
RF9RVUVVRV9SRUdfQUREUl9MQVJHRSh0d19kZXYpICsgMHg0KTsKIAkJfSBlbHNlIHsKLQkJCXdy
aXRlbChUV19DT01NQU5EX09GRlNFVCArIGNvbW1hbmRfcXVlX3ZhbHVlLCBUV19DT01NQU5EX1FV
RVVFX1JFR19BRERSKHR3X2RldikpOworCQkJaWYgKHNpemVvZihkbWFfYWRkcl90KSA+IDQpIHsK
KwkJCQljb21tYW5kX3F1ZV92YWx1ZSArPSBUV19DT01NQU5EX09GRlNFVDsKKwkJCQl3cml0ZWwo
KHUzMiljb21tYW5kX3F1ZV92YWx1ZSwgVFdfQ09NTUFORF9RVUVVRV9SRUdfQUREUih0d19kZXYp
KTsKKwkJCQl3cml0ZWwoKHUzMikoKHU2NCljb21tYW5kX3F1ZV92YWx1ZSA+PiAzMiksIFRXX0NP
TU1BTkRfUVVFVUVfUkVHX0FERFIodHdfZGV2KSArIDB4NCk7CisJCQl9IGVsc2UgeworCQkJCXdy
aXRlbChUV19DT01NQU5EX09GRlNFVCArIGNvbW1hbmRfcXVlX3ZhbHVlLCBUV19DT01NQU5EX1FV
RVVFX1JFR19BRERSKHR3X2RldikpOworCQkJfQogCQl9CiAJCXR3X2Rldi0+c3RhdGVbcmVxdWVz
dF9pZF0gPSBUV19TX1BPU1RFRDsKIAkJdHdfZGV2LT5wb3N0ZWRfcmVxdWVzdF9jb3VudCsrOwpA
QCAtMTYyMCwxNCArMTYzMyw5IEBACiAJCWdvdG8gb3V0OwogCiAJVFdfRU5BQkxFX0FORF9DTEVB
Ul9JTlRFUlJVUFRTKHR3X2Rldik7CisJY2xlYXJfYml0KFRXX0lOX1JFU0VULCAmdHdfZGV2LT5m
bGFncyk7CisJdHdfZGV2LT5jaHJkZXZfcmVxdWVzdF9pZCA9IFRXX0lPQ1RMX0NIUkRFVl9GUkVF
OwogCi0JLyogV2FrZSB1cCBhbnkgaW9jdGwgdGhhdCB3YXMgcGVuZGluZyBiZWZvcmUgdGhlIHJl
c2V0ICovCi0JaWYgKCh0d19kZXYtPmNocmRldl9yZXF1ZXN0X2lkID09IFRXX0lPQ1RMX0NIUkRF
Vl9GUkVFKSB8fCAoaW9jdGxfcmVzZXQpKSB7Ci0JCWNsZWFyX2JpdChUV19JTl9SRVNFVCwgJnR3
X2Rldi0+ZmxhZ3MpOwotCX0gZWxzZSB7Ci0JCXR3X2Rldi0+Y2hyZGV2X3JlcXVlc3RfaWQgPSBU
V19JT0NUTF9DSFJERVZfRlJFRTsKLQkJd2FrZV91cCgmdHdfZGV2LT5pb2N0bF93cXVldWUpOwot
CX0KIAlyZXR2YWwgPSAwOwogb3V0OgogCXJldHVybiByZXR2YWw7CkBAIC0xNzM2LDYgKzE3NDQs
OSBAQAogCQkiV0FSTklORzogKDB4JTAyWDoweCUwNFgpOiBDb21tYW5kICgweCV4KSB0aW1lZCBv
dXQsIHJlc2V0dGluZyBjYXJkLlxuIiwKIAkJVFdfRFJJVkVSLCAweDJjLCBTQ3BudC0+Y21uZFsw
XSk7CiAKKwkvKiBNYWtlIHN1cmUgd2UgYXJlIG5vdCBpc3N1aW5nIGFuIGlvY3RsIG9yIHJlc2V0
dGluZyBmcm9tIGlvY3RsICovCisJbXV0ZXhfbG9jaygmdHdfZGV2LT5pb2N0bF9sb2NrKTsKKwog
CS8qIE5vdyByZXNldCB0aGUgY2FyZCBhbmQgc29tZSBvZiB0aGUgZGV2aWNlIGV4dGVuc2lvbiBk
YXRhICovCiAJaWYgKHR3YV9yZXNldF9kZXZpY2VfZXh0ZW5zaW9uKHR3X2RldiwgMCkpIHsKIAkJ
VFdfUFJJTlRLKHR3X2Rldi0+aG9zdCwgVFdfRFJJVkVSLCAweDJiLCAiQ29udHJvbGxlciByZXNl
dCBmYWlsZWQgZHVyaW5nIHNjc2kgaG9zdCByZXNldCIpOwpAQCAtMTc0NCw2ICsxNzU1LDcgQEAK
IAogCXJldHZhbCA9IFNVQ0NFU1M7CiBvdXQ6CisJbXV0ZXhfdW5sb2NrKCZ0d19kZXYtPmlvY3Rs
X2xvY2spOwogCXJldHVybiByZXR2YWw7CiB9IC8qIEVuZCB0d2Ffc2NzaV9laF9yZXNldCgpICov
CiAKQEAgLTE3NTMsOCArMTc2NSwxNCBAQAogCWludCByZXF1ZXN0X2lkLCByZXR2YWw7CiAJVFdf
RGV2aWNlX0V4dGVuc2lvbiAqdHdfZGV2ID0gKFRXX0RldmljZV9FeHRlbnNpb24gKilTQ3BudC0+
ZGV2aWNlLT5ob3N0LT5ob3N0ZGF0YTsKIAorCS8qIElmIHdlIGFyZSByZXNldHRpbmcgZHVlIHRv
IHRpbWVkIG91dCBpb2N0bCwgcmVwb3J0IGFzIGJ1c3kgKi8KKwlpZiAodGVzdF9iaXQoVFdfSU5f
UkVTRVQsICZ0d19kZXYtPmZsYWdzKSkgeworCQlyZXR2YWwgPSBTQ1NJX01MUVVFVUVfSE9TVF9C
VVNZOworCQlnb3RvIG91dDsKKwl9CisKIAkvKiBDaGVjayBpZiB0aGlzIEZXIHN1cHBvcnRzIGx1
bnMgKi8KLQlpZiAoKFNDcG50LT5kZXZpY2UtPmx1biAhPSAwKSAmJiAodHdfZGV2LT53b3JraW5n
X3NybCA8IFRXX0ZXX1NSTF9MVU5TX1NVUFBPUlRFRCkpIHsKKwlpZiAoKFNDcG50LT5kZXZpY2Ut
Pmx1biAhPSAwKSAmJiAodHdfZGV2LT50d19jb21wYXRfaW5mby53b3JraW5nX3NybCA8IFRXX0ZX
X1NSTF9MVU5TX1NVUFBPUlRFRCkpIHsKIAkJU0NwbnQtPnJlc3VsdCA9IChESURfQkFEX1RBUkdF
VCA8PCAxNik7CiAJCWRvbmUoU0NwbnQpOwogCQlyZXR2YWwgPSAwOwpAQCAtMTk2MCw2ICsxOTc4
LDkgQEAKIAkvKiBEaXNhYmxlIGludGVycnVwdHMgKi8KIAlUV19ESVNBQkxFX0lOVEVSUlVQVFMo
dHdfZGV2KTsKIAorCS8qIEZyZWUgdXAgdGhlIElSUSAqLworCWZyZWVfaXJxKHR3X2Rldi0+dHdf
cGNpX2Rldi0+aXJxLCB0d19kZXYpOworCiAJcHJpbnRrKEtFUk5fV0FSTklORyAiM3ctOXh4eDog
U2h1dHRpbmcgZG93biBob3N0ICVkLlxuIiwgdHdfZGV2LT5ob3N0LT5ob3N0X25vKTsKIAogCS8q
IFRlbGwgdGhlIGNhcmQgd2UgYXJlIHNodXR0aW5nIGRvd24gKi8KQEAgLTIwOTEsMjEgKzIxMTIs
MjUgQEAKIAogCS8qIEluaXRpYWxpemUgdGhlIGNhcmQgKi8KIAlpZiAodHdhX3Jlc2V0X3NlcXVl
bmNlKHR3X2RldiwgMCkpCi0JCWdvdG8gb3V0X3JlbGVhc2VfbWVtX3JlZ2lvbjsKKwkJZ290byBv
dXRfaW91bm1hcDsKIAogCS8qIFNldCBob3N0IHNwZWNpZmljIHBhcmFtZXRlcnMgKi8KLQlob3N0
LT5tYXhfaWQgPSBUV19NQVhfVU5JVFM7CisJaWYgKHBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNF
X0lEXzNXQVJFXzk2NTBTRSkKKwkJaG9zdC0+bWF4X2lkID0gVFdfTUFYX1VOSVRTXzk2NTBTRTsK
KwllbHNlCisJCWhvc3QtPm1heF9pZCA9IFRXX01BWF9VTklUUzsKKwogCWhvc3QtPm1heF9jbWRf
bGVuID0gVFdfTUFYX0NEQl9MRU47CiAKIAkvKiBDaGFubmVscyBhcmVuJ3Qgc3VwcG9ydGVkIGJ5
IGFkYXB0ZXIgKi8KLQlob3N0LT5tYXhfbHVuID0gVFdfTUFYX0xVTlModHdfZGV2LT53b3JraW5n
X3NybCk7CisJaG9zdC0+bWF4X2x1biA9IFRXX01BWF9MVU5TKHR3X2Rldi0+dHdfY29tcGF0X2lu
Zm8ud29ya2luZ19zcmwpOwogCWhvc3QtPm1heF9jaGFubmVsID0gMDsKIAogCS8qIFJlZ2lzdGVy
IHRoZSBjYXJkIHdpdGggdGhlIGtlcm5lbCBTQ1NJIGxheWVyICovCiAJcmV0dmFsID0gc2NzaV9h
ZGRfaG9zdChob3N0LCAmcGRldi0+ZGV2KTsKIAlpZiAocmV0dmFsKSB7CiAJCVRXX1BSSU5USyh0
d19kZXYtPmhvc3QsIFRXX0RSSVZFUiwgMHgyNywgInNjc2kgYWRkIGhvc3QgZmFpbGVkIik7Ci0J
CWdvdG8gb3V0X3JlbGVhc2VfbWVtX3JlZ2lvbjsKKwkJZ290byBvdXRfaW91bm1hcDsKIAl9CiAK
IAlwY2lfc2V0X2RydmRhdGEocGRldiwgaG9zdCk7CkBAIC0yMTQ1LDYgKzIxNzAsOCBAQAogCiBv
dXRfcmVtb3ZlX2hvc3Q6CiAJc2NzaV9yZW1vdmVfaG9zdChob3N0KTsKK291dF9pb3VubWFwOgor
CWlvdW5tYXAodHdfZGV2LT5iYXNlX2FkZHIpOwogb3V0X3JlbGVhc2VfbWVtX3JlZ2lvbjoKIAlw
Y2lfcmVsZWFzZV9yZWdpb25zKHBkZXYpOwogb3V0X2ZyZWVfZGV2aWNlX2V4dGVuc2lvbjoKQEAg
LTIxNzAsMTIgKzIxOTcsMTIgQEAKIAkJdHdhX21ham9yID0gLTE7CiAJfQogCi0JLyogRnJlZSB1
cCB0aGUgSVJRICovCi0JZnJlZV9pcnEodHdfZGV2LT50d19wY2lfZGV2LT5pcnEsIHR3X2Rldik7
Ci0KIAkvKiBTaHV0ZG93biB0aGUgY2FyZCAqLwogCV9fdHdhX3NodXRkb3duKHR3X2Rldik7CiAK
KwkvKiBGcmVlIElPIHJlbWFwcGluZyAqLworCWlvdW5tYXAodHdfZGV2LT5iYXNlX2FkZHIpOwor
CiAJLyogRnJlZSB1cCB0aGUgbWVtIHJlZ2lvbiAqLwogCXBjaV9yZWxlYXNlX3JlZ2lvbnMocGRl
dik7CiAKQEAgLTIxOTMsNiArMjIyMCw4IEBACiAJICBQQ0lfQU5ZX0lELCBQQ0lfQU5ZX0lELCAw
LCAwLCAwfSwKIAl7IFBDSV9WRU5ET1JfSURfM1dBUkUsIFBDSV9ERVZJQ0VfSURfM1dBUkVfOTU1
MFNYLAogCSAgUENJX0FOWV9JRCwgUENJX0FOWV9JRCwgMCwgMCwgMH0sCisJeyBQQ0lfVkVORE9S
X0lEXzNXQVJFLCBQQ0lfREVWSUNFX0lEXzNXQVJFXzk2NTBTRSwKKwkgIFBDSV9BTllfSUQsIFBD
SV9BTllfSUQsIDAsIDAsIDB9LAogCXsgfQogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUocGNpLCB0
d2FfcGNpX3RibCk7CmRpZmYgLU5hdXIgc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvM3ctOXh4
eC5oIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS8zdy05eHh4LmgKLS0tIHNjc2ktbWlz
Yy0yLjYvZHJpdmVycy9zY3NpLzN3LTl4eHguaAkyMDA2LTA5LTE5IDIwOjQyOjA2LjAwMDAwMDAw
MCAtMDcwMAorKysgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpLzN3LTl4eHguaAkyMDA2
LTEwLTI2IDE2OjU4OjM2LjAwMDAwMDAwMCAtMDcwMApAQCAtMjg5LDcgKzI4OSw2IEBACiAjZGVm
aW5lIFRXX1NUQVRVU19WQUxJRF9JTlRFUlJVUFQgICAgICAgICAgICAgIDB4MDBERjAwMDAKIAog
LyogUENJIHJlbGF0ZWQgZGVmaW5lcyAqLwotI2RlZmluZSBUV19OVU1ERVZJQ0VTIDEKICNkZWZp
bmUgVFdfUENJX0NMRUFSX1BBUklUWV9FUlJPUlMgMHhjMTAwCiAjZGVmaW5lIFRXX1BDSV9DTEVB
Ul9QQ0lfQUJPUlQgICAgIDB4MjAwMAogCkBAIC0zMzUsNiArMzM0LDcgQEAKICNkZWZpbmUgVFdf
QUxJR05NRU5UXzkwMDAgICAgICAgICAgICAgICAgICAgICA0ICAvKiA0IGJ5dGVzICovCiAjZGVm
aW5lIFRXX0FMSUdOTUVOVF85MDAwX1NHTCAgICAgICAgICAgICAgICAgMHgzCiAjZGVmaW5lIFRX
X01BWF9VTklUUwkJCSAgICAgIDE2CisjZGVmaW5lIFRXX01BWF9VTklUU185NjUwU0UJCSAgICAg
IDMyCiAjZGVmaW5lIFRXX0lOSVRfTUVTU0FHRV9DUkVESVRTCQkgICAgICAweDEwMAogI2RlZmlu
ZSBUV19JTklUX0NPTU1BTkRfUEFDS0VUX1NJWkUJICAgICAgMHgzCiAjZGVmaW5lIFRXX0lOSVRf
Q09NTUFORF9QQUNLRVRfU0laRV9FWFRFTkRFRCAgMHg2CkBAIC0zNTQsNyArMzU0LDYgQEAKICNk
ZWZpbmUgVFdfTUFYX1JFU1BPTlNFX0RSQUlOCQkgICAgICAyNTYKICNkZWZpbmUgVFdfTUFYX0FF
Tl9EUkFJTgkJICAgICAgNDAKICNkZWZpbmUgVFdfSU5fUkVTRVQgICAgICAgICAgICAgICAgICAg
ICAgICAgICAyCi0jZGVmaW5lIFRXX0lOX0NIUkRFVl9JT0NUTCAgICAgICAgICAgICAgICAgICAg
MwogI2RlZmluZSBUV19JTl9BVFRFTlRJT05fTE9PUAkJICAgICAgNAogI2RlZmluZSBUV19NQVhf
U0VDVE9SUyAgICAgICAgICAgICAgICAgICAgICAgIDI1NgogI2RlZmluZSBUV19BRU5fV0FJVF9U
SU1FICAgICAgICAgICAgICAgICAgICAgIDEwMDAKQEAgLTQxNyw2ICs0MTYsOSBAQAogI2lmbmRl
ZiBQQ0lfREVWSUNFX0lEXzNXQVJFXzk1NTBTWAogI2RlZmluZSBQQ0lfREVWSUNFX0lEXzNXQVJF
Xzk1NTBTWCAweDEwMDMKICNlbmRpZgorI2lmbmRlZiBQQ0lfREVWSUNFX0lEXzNXQVJFXzk2NTBT
RQorI2RlZmluZSBQQ0lfREVWSUNFX0lEXzNXQVJFXzk2NTBTRSAweDEwMDQKKyNlbmRpZgogCiAv
KiBCaXRtYXNrIG1hY3JvcyB0byBlbGltaW5hdGUgYml0ZmllbGRzICovCiAKQEAgLTQ0Miw2ICs0
NDQsNyBAQAogI2RlZmluZSBUV19DT05UUk9MX1JFR19BRERSKHgpICh4LT5iYXNlX2FkZHIpCiAj
ZGVmaW5lIFRXX1NUQVRVU19SRUdfQUREUih4KSAoKHVuc2lnbmVkIGNoYXIgX19pb21lbSAqKXgt
PmJhc2VfYWRkciArIDB4NCkKICNkZWZpbmUgVFdfQ09NTUFORF9RVUVVRV9SRUdfQUREUih4KSAo
c2l6ZW9mKGRtYV9hZGRyX3QpID4gNCA/ICgodW5zaWduZWQgY2hhciBfX2lvbWVtICopeC0+YmFz
ZV9hZGRyICsgMHgyMCkgOiAoKHVuc2lnbmVkIGNoYXIgX19pb21lbSAqKXgtPmJhc2VfYWRkciAr
IDB4OCkpCisjZGVmaW5lIFRXX0NPTU1BTkRfUVVFVUVfUkVHX0FERFJfTEFSR0UoeCkgKCh1bnNp
Z25lZCBjaGFyIF9faW9tZW0gKil4LT5iYXNlX2FkZHIgKyAweDIwKQogI2RlZmluZSBUV19SRVNQ
T05TRV9RVUVVRV9SRUdfQUREUih4KSAoKHVuc2lnbmVkIGNoYXIgX19pb21lbSAqKXgtPmJhc2Vf
YWRkciArIDB4QykKICNkZWZpbmUgVFdfUkVTUE9OU0VfUVVFVUVfUkVHX0FERFJfTEFSR0UoeCkg
KCh1bnNpZ25lZCBjaGFyIF9faW9tZW0gKil4LT5iYXNlX2FkZHIgKyAweDMwKQogI2RlZmluZSBU
V19DTEVBUl9BTExfSU5URVJSVVBUUyh4KSAod3JpdGVsKFRXX1NUQVRVU19WQUxJRF9JTlRFUlJV
UFQsIFRXX0NPTlRST0xfUkVHX0FERFIoeCkpKQpAQCAtNjI2LDYgKzYyOSw5IEBACiAJdW5zaWdu
ZWQgc2hvcnQgZHJpdmVyX3NybF9sb3c7CiAJdW5zaWduZWQgc2hvcnQgZHJpdmVyX2JyYW5jaF9s
b3c7CiAJdW5zaWduZWQgc2hvcnQgZHJpdmVyX2J1aWxkX2xvdzsKKwl1bnNpZ25lZCBzaG9ydCBm
d19vbl9jdGxyX3NybDsKKwl1bnNpZ25lZCBzaG9ydCBmd19vbl9jdGxyX2JyYW5jaDsKKwl1bnNp
Z25lZCBzaG9ydCBmd19vbl9jdGxyX2J1aWxkOwogfSBUV19Db21wYXRpYmlsaXR5X0luZm87CiAK
ICNwcmFnbWEgcGFjaygpCkBAIC02NjgsOSArNjc0LDcgQEAKIAl3YWl0X3F1ZXVlX2hlYWRfdAlp
b2N0bF93cXVldWU7CiAJc3RydWN0IG11dGV4CQlpb2N0bF9sb2NrOwogCWNoYXIJCQlhZW5fY2xv
YmJlcjsKLQl1bnNpZ25lZCBzaG9ydAkJd29ya2luZ19zcmw7Ci0JdW5zaWduZWQgc2hvcnQJCXdv
cmtpbmdfYnJhbmNoOwotCXVuc2lnbmVkIHNob3J0CQl3b3JraW5nX2J1aWxkOworCVRXX0NvbXBh
dGliaWxpdHlfSW5mbwl0d19jb21wYXRfaW5mbzsKIH0gVFdfRGV2aWNlX0V4dGVuc2lvbjsKIAog
I2VuZGlmIC8qIF8zV185WFhYX0ggKi8K
------=_Part_35345_18494621.1161910866059--
