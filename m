From: "Adam Radford" <aradford@amcc.com>
Subject: [PATCH] 3ware 5/6/7/8000 driver update
Date: Mon, 13 Sep 2004 17:39:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <I409UK00.E96@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hadar.amcc.com ([192.195.69.168]:28331 "EHLO hadar.amcc.com")
	by vger.kernel.org with ESMTP id S269075AbUINAjy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 20:39:54 -0400
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, James.Bottomley@SteelEye.com, hch@lst.de
Cc: linux-scsi@vger.kernel.org

Andrew/James/Christoph Hellwig,

This patch fixes up some issues found by Christoph in my last large patch for 
2.6.9-rcX.

Changes in this release are the following:

- Make tw_check_bits() static.
- Add MODULE_VERSION support.
- Fix ioctl path to use dma_alloc/free_coherent() instead of 
  pci_alloc/free_consistent().
- Remove error variable from ioctl code causing confusion.
  retval defaults to -EFAULT, any copy_to/from_user() that 
  returns non zero returns -EFAULT.

--
Adam Radford
Staff Software Engineer
AMCC

diff -Naur linux-2.6.9-rc1-bk15/drivers/scsi/3w-xxxx.c linux-2.6.9-rc1-bk16/drivers/scsi/3w-xxxx.c
--- linux-2.6.9-rc1-bk15/drivers/scsi/3w-xxxx.c	2004-09-13 17:23:27.000000000 -0700
+++ linux-2.6.9-rc1-bk16/drivers/scsi/3w-xxxx.c	2004-09-13 17:09:59.000000000 -0700
@@ -207,7 +207,7 @@
 #include "3w-xxxx.h"
 
 /* Globals */
-static const char *tw_driver_version="1.26.02.000";
+#define TW_DRIVER_VERSION "1.26.02.000"
 static TW_Device_Extension *tw_device_extension_list[TW_MAX_SLOT];
 static int tw_device_extension_count = 0;
 static int twe_major = -1;
@@ -216,6 +216,7 @@
 MODULE_AUTHOR("AMCC");
 MODULE_DESCRIPTION("3ware Storage Controller Linux Driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(TW_DRIVER_VERSION);
 
 /* Function prototypes */
 static int tw_reset_device_extension(TW_Device_Extension *tw_dev, int ioctl_reset);
@@ -223,7 +224,7 @@
 /* Functions */
 
 /* This function will check the status register for unexpected bits */
-int tw_check_bits(u32 status_reg_value)
+static int tw_check_bits(u32 status_reg_value)
 {
 	if ((status_reg_value & TW_STATUS_EXPECTED_BITS) != TW_STATUS_EXPECTED_BITS) {  
 		dprintk(KERN_WARNING "3w-xxxx: tw_check_bits(): No expected bits (0x%x).\n", status_reg_value);
@@ -492,7 +493,7 @@
 		       "Max sector count:          %4d\n"
 		       "SCSI Host Resets:          %4d\n"
 		       "AEN's:                     %4d\n", 
-		       tw_driver_version,
+		       TW_DRIVER_VERSION,
 		       tw_dev->posted_request_count,
 		       tw_dev->max_posted_request_count,
 		       tw_dev->pending_request_count,
@@ -884,7 +885,7 @@
 /* This function handles ioctl for the character device */
 static int tw_chrdev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
 {
-	int error, request_id;
+	int request_id;
 	dma_addr_t dma_handle;
 	unsigned short tw_aen_code;
 	unsigned long flags;
@@ -905,8 +906,7 @@
 		return -EINTR;
 
 	/* First copy down the buffer length */
-	error = copy_from_user(&data_buffer_length, argp, sizeof(unsigned int));
-	if (error)
+	if (copy_from_user(&data_buffer_length, argp, sizeof(unsigned int)))
 		goto out;
 
 	/* Check size */
@@ -919,7 +919,7 @@
 	data_buffer_length_adjusted = (data_buffer_length + 511) & ~511;
 	
 	/* Now allocate ioctl buf memory */
-	cpu_addr = pci_alloc_consistent(tw_dev->tw_pci_dev, data_buffer_length_adjusted+sizeof(TW_New_Ioctl) - 1, &dma_handle);
+	cpu_addr = dma_alloc_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_New_Ioctl) - 1, &dma_handle, GFP_KERNEL);
 	if (cpu_addr == NULL) {
 		retval = -ENOMEM;
 		goto out;
@@ -928,8 +928,7 @@
 	tw_ioctl = (TW_New_Ioctl *)cpu_addr;
 
 	/* Now copy down the entire ioctl */
-	error = copy_from_user(tw_ioctl, argp, data_buffer_length + sizeof(TW_New_Ioctl) - 1);
-	if (error)
+	if (copy_from_user(tw_ioctl, argp, data_buffer_length + sizeof(TW_New_Ioctl) - 1))
 		goto out2;
 
 	passthru = (TW_Passthru *)&tw_ioctl->firmware_command;
@@ -1042,12 +1041,12 @@
 	}
 
 	/* Now copy the response to userspace */
-	error = copy_to_user(argp, tw_ioctl, sizeof(TW_New_Ioctl) + data_buffer_length - 1);
-	if (error == 0)
-		retval = 0;
+	if (copy_to_user(argp, tw_ioctl, sizeof(TW_New_Ioctl) + data_buffer_length - 1))
+		goto out2;
+	retval = 0;
 out2:
 	/* Now free ioctl buf memory */
-	pci_free_consistent(tw_dev->tw_pci_dev, data_buffer_length_adjusted+sizeof(TW_New_Ioctl) - 1, cpu_addr, dma_handle);
+	dma_free_coherent(&tw_dev->tw_pci_dev->dev, data_buffer_length_adjusted+sizeof(TW_New_Ioctl) - 1, cpu_addr, dma_handle);
 out:
 	up(&tw_dev->ioctl_sem);
 	return retval;
@@ -1544,7 +1543,7 @@
 	request_buffer[4] = 31;	       /* Additional length */
 	memcpy(&request_buffer[8], "3ware   ", 8);	 /* Vendor ID */
 	sprintf(&request_buffer[16], "Logical Disk %-2d ", tw_dev->srb[request_id]->device->id);
-	memcpy(&request_buffer[32], tw_driver_version, 3);
+	memcpy(&request_buffer[32], TW_DRIVER_VERSION, 3);
 
 	param = (TW_Param *)tw_dev->alignment_virtual_address[request_id];
 	if (param == NULL) {
@@ -2484,7 +2483,7 @@
 /* This function is called on driver initialization */
 static int __init tw_init(void)
 {
-	printk(KERN_WARNING "3ware Storage Controller device driver for Linux v%s.\n", tw_driver_version);
+	printk(KERN_WARNING "3ware Storage Controller device driver for Linux v%s.\n", TW_DRIVER_VERSION);
 
 	return pci_module_init(&tw_driver);
 } /* End tw_init() */




