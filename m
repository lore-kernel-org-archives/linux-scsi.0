From: Daniel Drake <dsd@gentoo.org>
Subject: [PATCH resend] Allow both megaraid drivers to be built
Date: Sat, 29 Oct 2005 14:24:08 +0100
Message-ID: <436377F8.3060505@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030109030309000201030805"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta07-winn.ispmail.ntl.com ([81.103.221.47]:40314 "EHLO
	mta07-winn.ispmail.ntl.com") by vger.kernel.org with ESMTP
	id S1750991AbVJ2NYN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Oct 2005 09:24:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------030109030309000201030805
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi James,

Here's a rediff of a patch I sent at the end of August.

Rename megaraid to megaraid_legacy, changing sysfs name, module
name, and the messages printed out via printk. I have left the procfs name as
"megaraid" as presumably userspace tools rely on this.

Remove hardware ID's from megaraid_legacy which overlap with the newgen
megaraid drivers.

Allow megaraid_legacy to be built alongside the newgen driver.

Instead of renaming the file locally and sending a huge unreviewable diff, 
I've left the original filenames (megaraid.c and megaraid.h) in place. Please 
use git-mv to rename these to megaraid_legacy.[ch] once you have applied this.

Signed-off-by: Daniel Drake <dsd@gentoo.org>

--------------030109030309000201030805
Content-Type: text/x-patch;
 name="megaraid-legacy.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="megaraid-legacy.patch"

--- linux-2.6.14/drivers/scsi/Makefile.orig	2005-10-29 13:49:19.000000000 +0100
+++ linux-2.6.14/drivers/scsi/Makefile	2005-10-29 13:51:43.000000000 +0100
@@ -97,7 +97,7 @@ obj-$(CONFIG_SCSI_IBMMCA)	+= ibmmca.o
 obj-$(CONFIG_SCSI_EATA)		+= eata.o
 obj-$(CONFIG_SCSI_DC395x)	+= dc395x.o
 obj-$(CONFIG_SCSI_DC390T)	+= tmscsim.o
-obj-$(CONFIG_MEGARAID_LEGACY)	+= megaraid.o
+obj-$(CONFIG_MEGARAID_LEGACY)	+= megaraid_legacy.o
 obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
 obj-$(CONFIG_MEGARAID_SAS)	+= megaraid/
 obj-$(CONFIG_SCSI_ACARD)	+= atp870u.o
--- linux-2.6.14/drivers/scsi/megaraid/Kconfig.megaraid.orig	2005-10-29 13:49:43.000000000 +0100
+++ linux-2.6.14/drivers/scsi/megaraid/Kconfig.megaraid	2005-10-29 13:51:23.000000000 +0100
@@ -64,18 +64,18 @@ config MEGARAID_MAILBOX
 	To compile this driver as a module, choose M here: the
 	module will be called megaraid_mbox
 
-if MEGARAID_NEWGEN=n
 config MEGARAID_LEGACY
 	tristate "LSI Logic Legacy MegaRAID Driver"
 	depends on PCI && SCSI
 	help
-	This driver supports the LSI MegaRAID 418, 428, 438, 466, 762, 490
-	and 467 SCSI host adapters. This driver also support the all U320
-	RAID controllers
+	This driver supports the LSI MegaRAID 418, 428, 438, 466, 467, 762, 490
+	and 467 SCSI host adapters.
+
+	Other MegaRAID controllers are supported by the MEGARAID_NEWGEN driver
+	series.
 
 	To compile this driver as a module, choose M here: the
-	module will be called megaraid
-endif
+	module will be called megaraid_legacy
 
 config MEGARAID_SAS
 	tristate "LSI Logic MegaRAID SAS RAID Module"
--- linux-2.6.14/drivers/scsi/megaraid.c.orig	2005-10-29 13:49:29.000000000 +0100
+++ linux-2.6.14/drivers/scsi/megaraid.c	2005-10-29 14:01:35.000000000 +0100
@@ -21,8 +21,7 @@
  *
  * Description: Linux device driver for LSI Logic MegaRAID controller
  *
- * Supported controllers: MegaRAID 418, 428, 438, 466, 762, 467, 471, 490, 493
- *					518, 520, 531, 532
+ * Supported controllers: MegaRAID 418, 428, 438, 466, 762, 467, 490
  *
  * This driver is supported by LSI Logic, with assistance from Red Hat, Dell,
  * and others. Please send updates to the mailing list
@@ -49,7 +48,7 @@
 #include "scsi.h"
 #include <scsi/scsi_host.h>
 
-#include "megaraid.h"
+#include "megaraid_legacy.h"
 
 #define MEGARAID_MODULE_VERSION "2.00.3"
 
@@ -259,8 +258,8 @@ mega_query_adapter(adapter_t *adapter)
 
 		if ((retval = issue_scb_block(adapter, raw_mbox)))
 			printk(KERN_WARNING
-			"megaraid: Product_info cmd failed with error: %d\n",
-				retval);
+			"megaraid_legacy: Product_info cmd failed with "
+			"error: %d\n", retval);
 
 		pci_unmap_single(adapter->dev, prod_info_dma_handle,
 				sizeof(mega_product_info), PCI_DMA_FROMDEVICE);
@@ -322,7 +321,8 @@ mega_query_adapter(adapter_t *adapter)
 		adapter->bios_version[4] = 0;
 	}
 
-	printk(KERN_NOTICE "megaraid: [%s:%s] detected %d logical drives.\n",
+	printk(KERN_NOTICE "megaraid_legacy: [%s:%s] detected %d logical "
+		"drives.\n",
 		adapter->fw_version, adapter->bios_version, adapter->numldrv);
 
 	/*
@@ -330,7 +330,7 @@ mega_query_adapter(adapter_t *adapter)
 	 */
 	adapter->support_ext_cdb = mega_support_ext_cdb(adapter);
 	if (adapter->support_ext_cdb)
-		printk(KERN_NOTICE "megaraid: supports extended CDBs.\n");
+		printk(KERN_NOTICE "megaraid_legacy: supports extended CDBs.\n");
 
 
 	return 0;
@@ -1241,7 +1241,7 @@ issue_scb_block(adapter_t *adapter, u_ch
 	return mbox->m_in.status;
 
 bug_blocked_mailbox:
-	printk(KERN_WARNING "megaraid: Blocked mailbox......!!\n");
+	printk(KERN_WARNING "megaraid_legacy: Blocked mailbox......!!\n");
 	udelay (1000);
 	return -1;
 }
@@ -1453,7 +1453,7 @@ mega_cmd_done(adapter_t *adapter, u8 com
 			 */
 			if( !(scb->state & SCB_ISSUED) || scb->cmd == NULL ) {
 				printk(KERN_CRIT
-					"megaraid: invalid command ");
+					"megaraid_legacy: invalid command ");
 				printk("Id %d, scb->state:%x, scsi cmd:%p\n",
 					cmdid, scb->state, scb->cmd);
 
@@ -1466,8 +1466,9 @@ mega_cmd_done(adapter_t *adapter, u8 com
 			if( scb->state & SCB_ABORT ) {
 
 				printk(KERN_WARNING
-				"megaraid: aborted cmd %lx[%x] complete.\n",
-					scb->cmd->serial_number, scb->idx);
+				"megaraid_legacy: aborted cmd %lx[%x] "
+				" complete.\n",
+				scb->cmd->serial_number, scb->idx);
 
 				scb->cmd->result = (DID_ABORT << 16);
 
@@ -1485,7 +1486,8 @@ mega_cmd_done(adapter_t *adapter, u8 com
 			if( scb->state & SCB_RESET ) {
 
 				printk(KERN_WARNING
-				"megaraid: reset cmd %lx[%x] complete.\n",
+				"megaraid_legacy: reset cmd %lx[%x] "
+				" complete.\n",
 					scb->cmd->serial_number, scb->idx);
 
 				scb->cmd->result = (DID_RESET << 16);
@@ -1558,7 +1560,8 @@ mega_cmd_done(adapter_t *adapter, u8 com
 				}
 				else {
 					printk(KERN_WARNING
-						"megaraid: invalid sg.\n");
+						"megaraid_legacy: "
+						"invalid sg.\n");
 					c = 0;
 				}
 			}
@@ -1983,10 +1986,10 @@ megaraid_reset(struct scsi_cmnd *cmd)
 
 	if( mega_internal_command(adapter, LOCK_INT, &mc, NULL) != 0 ) {
 		printk(KERN_WARNING
-				"megaraid: reservation reset failed.\n");
+				"megaraid_legacy: reservation reset failed.\n");
 	}
 	else {
-		printk(KERN_INFO "megaraid: reservation reset.\n");
+		printk(KERN_INFO "megaraid_legacy: reservation reset.\n");
 	}
 #endif
 
@@ -2019,7 +2022,7 @@ megaraid_abort_and_reset(adapter_t *adap
 	struct list_head	*pos, *next;
 	scb_t			*scb;
 
-	printk(KERN_WARNING "megaraid: %s-%lx cmd=%x <c=%d t=%d l=%d>\n",
+	printk(KERN_WARNING "megaraid_legacy: %s-%lx cmd=%x <c=%d t=%d l=%d>\n",
 	     (aor == SCB_ABORT)? "ABORTING":"RESET", cmd->serial_number,
 	     cmd->cmnd[0], cmd->device->channel, 
 	     cmd->device->id, cmd->device->lun);
@@ -2044,7 +2047,8 @@ megaraid_abort_and_reset(adapter_t *adap
 			if( scb->state & SCB_ISSUED ) {
 
 				printk(KERN_WARNING
-					"megaraid: %s-%lx[%x], fw owner.\n",
+					"megaraid_legacy: "
+					"%s-%lx[%x], fw owner.\n",
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
 					cmd->serial_number, scb->idx);
 
@@ -2057,7 +2061,8 @@ megaraid_abort_and_reset(adapter_t *adap
 				 * list
 				 */
 				printk(KERN_WARNING
-					"megaraid: %s-%lx[%x], driver owner.\n",
+					"megaraid_legacy: "
+					"%s-%lx[%x], driver owner.\n",
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
 					cmd->serial_number, scb->idx);
 
@@ -2153,7 +2158,7 @@ mega_create_proc_entry(int index, struct
 		adapter->controller_proc_dir_entry = proc_mkdir(string, parent);
 
 	if(!controller_proc_dir_entry) {
-		printk(KERN_WARNING "\nmegaraid: proc_mkdir failed\n");
+		printk(KERN_WARNING "\nmegaraid_legacy: proc_mkdir failed\n");
 		return;
 	}
 	adapter->proc_read = CREATE_READ_PROC("config", proc_read_config);
@@ -2428,7 +2433,7 @@ proc_rebuild_rate(char *page, char **sta
 
 		len = sprintf(page, "Adapter inquiry failed.\n");
 
-		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+		printk(KERN_WARNING "megaraid_legacy: inquiry failed.\n");
 
 		mega_free_inquiry(inquiry, dma_handle, pdev);
 
@@ -2498,7 +2503,7 @@ proc_battery(char *page, char **start, o
 
 		len = sprintf(page, "Adapter inquiry failed.\n");
 
-		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+		printk(KERN_WARNING "megaraid_legacy: inquiry failed.\n");
 
 		mega_free_inquiry(inquiry, dma_handle, pdev);
 
@@ -2685,7 +2690,7 @@ proc_pdrv(adapter_t *adapter, char *page
 	if( mega_adapinq(adapter, dma_handle) != 0 ) {
 		len = sprintf(page, "Adapter inquiry failed.\n");
 
-		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+		printk(KERN_WARNING "megaraid_legacy: inquiry failed.\n");
 
 		goto free_inquiry;
 	}
@@ -2964,7 +2969,7 @@ proc_rdrv(adapter_t *adapter, char *page
 
 		len = sprintf(page, "Adapter inquiry failed.\n");
 
-		printk(KERN_WARNING "megaraid: inquiry failed.\n");
+		printk(KERN_WARNING "megaraid_legacy: inquiry failed.\n");
 
 		mega_free_inquiry(inquiry, dma_handle, pdev);
 
@@ -3231,7 +3236,8 @@ megaraid_biosparam(struct scsi_device *s
 		}
 
 		printk(KERN_INFO
-		"megaraid: invalid partition on this disk on channel %d\n",
+		"megaraid_legacy: invalid partition on this disk on "
+				"channel %d\n",
 				sdev->channel);
 
 		/* Default heads (64) & sectors (32) */
@@ -3512,7 +3518,7 @@ megadev_ioctl(struct inode *inode, struc
 			 * Do we support this feature
 			 */
 			if( !adapter->support_random_del ) {
-				printk(KERN_WARNING "megaraid: logdrv ");
+				printk(KERN_WARNING "megaraid_legacy: logdrv ");
 				printk("delete on non-supporting F/W.\n");
 
 				return (-EINVAL);
@@ -3537,7 +3543,8 @@ megadev_ioctl(struct inode *inode, struc
 		if( uioc.uioc_rmbox[0] == MEGA_MBOXCMD_PASSTHRU64 ||
 			uioc.uioc_rmbox[0] == MEGA_MBOXCMD_EXTPTHRU ) {
 
-			printk(KERN_WARNING "megaraid: rejected passthru.\n");
+			printk(KERN_WARNING "megaraid_legacy: "
+					"rejected passthru.\n");
 
 			return (-EINVAL);
 		}
@@ -4028,12 +4035,12 @@ mega_enum_raid_scsi(adapter_t *adapter)
 
 	for( i = 0; i < adapter->product_info.nchannels; i++ ) { 
 		if( (adapter->mega_ch_class >> i) & 0x01 ) {
-			printk(KERN_INFO "megaraid: channel[%d] is raid.\n",
-					i);
+			printk(KERN_INFO "megaraid_legacy: channel[%d] is "
+					"raid.\n", i);
 		}
 		else {
-			printk(KERN_INFO "megaraid: channel[%d] is scsi.\n",
-					i);
+			printk(KERN_INFO "megaraid_legacy: channel[%d] is "
+					" scsi.\n", i);
 		}
 	}
 
@@ -4238,7 +4245,8 @@ mega_do_del_logdrv(adapter_t *adapter, i
 
 	/* log this event */
 	if(rval) {
-		printk(KERN_WARNING "megaraid: Delete LD-%d failed.", logdrv);
+		printk(KERN_WARNING "megaraid_legacy: Delete LD-%d failed.",
+			logdrv);
 		return rval;
 	}
 
@@ -4528,7 +4536,7 @@ mega_internal_command(adapter_t *adapter
 	 * this information.
 	 */
 	if( scmd->result && trace_level ) {
-		printk("megaraid: cmd [%x, %x, %x] status:[%x]\n",
+		printk("megaraid_legacy: cmd [%x, %x, %x] status:[%x]\n",
 			mc->cmd, mc->opcode, mc->subopcode, scmd->result);
 	}
 
@@ -4630,7 +4638,7 @@ megaraid_probe_one(struct pci_dev *pdev,
 	subsysvid = pdev->subsystem_vendor;
 	subsysid = pdev->subsystem_device;
 
-	printk(KERN_NOTICE "megaraid: found 0x%4.04x:0x%4.04x:bus %d:",
+	printk(KERN_NOTICE "megaraid_legacy: found 0x%4.04x:0x%4.04x:bus %d:",
 		id->vendor, id->device, pci_bus);
 
 	printk("slot %d:func %d\n",
@@ -4645,14 +4653,15 @@ megaraid_probe_one(struct pci_dev *pdev,
 		flag |= BOARD_MEMMAP;
 
 		if (!request_mem_region(mega_baseport, 128, "megaraid")) {
-			printk(KERN_WARNING "megaraid: mem region busy!\n");
+			printk(KERN_WARNING "megaraid_legacy: "
+				"mem region busy!\n");
 			goto out_disable_device;
 		}
 
 		mega_baseport = (unsigned long)ioremap(mega_baseport, 128);
 		if (!mega_baseport) {
 			printk(KERN_WARNING
-			       "megaraid: could not map hba memory\n");
+			       "megaraid_legacy: could not map hba memory\n");
 			goto out_release_region;
 		}
 	} else {
@@ -4672,7 +4681,7 @@ megaraid_probe_one(struct pci_dev *pdev,
 	memset(adapter, 0, sizeof(adapter_t));
 
 	printk(KERN_NOTICE
-		"scsi%d:Found MegaRAID controller at 0x%lx, IRQ:%d\n",
+		"scsi%d:Found MegaRAID Legacy controller at 0x%lx, IRQ:%d\n",
 		host->host_no, mega_baseport, irq);
 
 	adapter->base = mega_baseport;
@@ -4708,13 +4717,13 @@ megaraid_probe_one(struct pci_dev *pdev,
 	adapter->mega_buffer = pci_alloc_consistent(adapter->dev,
 		MEGA_BUFFER_SIZE, &adapter->buf_dma_handle);
 	if (!adapter->mega_buffer) {
-		printk(KERN_WARNING "megaraid: out of RAM.\n");
+		printk(KERN_WARNING "megaraid_legacy: out of RAM.\n");
 		goto out_host_put;
 	}
 
 	adapter->scb_list = kmalloc(sizeof(scb_t) * MAX_COMMANDS, GFP_KERNEL);
 	if (!adapter->scb_list) {
-		printk(KERN_WARNING "megaraid: out of RAM.\n");
+		printk(KERN_WARNING "megaraid_legacy: out of RAM.\n");
 		goto out_free_cmd_buffer;
 	}
 
@@ -4722,7 +4731,7 @@ megaraid_probe_one(struct pci_dev *pdev,
 				megaraid_isr_memmapped : megaraid_isr_iomapped,
 					SA_SHIRQ, "megaraid", adapter)) {
 		printk(KERN_WARNING
-			"megaraid: Couldn't register IRQ %d!\n", irq);
+			"megaraid_legacy: Couldn't register IRQ %d!\n", irq);
 		goto out_free_scb_list;
 	}
 
@@ -4743,18 +4752,18 @@ megaraid_probe_one(struct pci_dev *pdev,
 				!strcmp(adapter->fw_version, "3.01")) {
 
 			printk( KERN_WARNING
-				"megaraid: Your  card is a Dell PERC "
+				"megaraid_legacy: Your  card is a Dell PERC "
 				"2/SC RAID controller with  "
-				"firmware\nmegaraid: 3.00 or 3.01.  "
+				"firmware\nmegaraid_legacy: 3.00 or 3.01.  "
 				"This driver is known to have "
-				"corruption issues\nmegaraid: with "
+				"corruption issues\nmegaraid_legacy: with "
 				"those firmware versions on this "
-				"specific card.  In order\nmegaraid: "
+				"specific card.  In order\nmegaraid_legacy: "
 				"to protect your data, please upgrade "
-				"your firmware to version\nmegaraid: "
+				"your firmware to version\nmegaraid_legacy: "
 				"3.10 or later, available from the "
 				"Dell Technical Support web\n"
-				"megaraid: site at\nhttp://support."
+				"megaraid_legacy: site at\nhttp://support."
 				"dell.com/us/en/filelib/download/"
 				"index.asp?fileid=2940\n"
 			);
@@ -4776,11 +4785,11 @@ megaraid_probe_one(struct pci_dev *pdev,
 		    !strcmp(adapter->fw_version, "H01.08") ||
 		    !strcmp(adapter->fw_version, "H01.09") ) {
 			printk(KERN_WARNING
-				"megaraid: Firmware H.01.07, "
+				"megaraid_legacy: Firmware H.01.07, "
 				"H.01.08, and H.01.09 on 1M/2M "
 				"controllers\n"
-				"megaraid: do not support 64 bit "
-				"addressing.\nmegaraid: DISABLING "
+				"megaraid_legacy: do not support 64 bit "
+				"addressing.\nmegaraid_legacy: DISABLING "
 				"64 bit support.\n");
 			adapter->flag &= ~BOARD_64BIT;
 		}
@@ -4889,7 +4898,7 @@ megaraid_probe_one(struct pci_dev *pdev,
 	adapter->has_cluster = mega_support_cluster(adapter);
 	if (adapter->has_cluster) {
 		printk(KERN_NOTICE
-			"megaraid: Cluster driver, initiator id:%d\n",
+			"megaraid_legacy: Cluster driver, initiator id:%d\n",
 			adapter->this_id);
 	}
 #endif
@@ -4956,7 +4965,7 @@ __megaraid_shutdown(adapter_t *adapter)
 	issue_scb_block(adapter, raw_mbox);
 	
 	if (atomic_read(&adapter->pend_cmds) > 0)
-		printk(KERN_WARNING "megaraid: pending commands!!\n");
+		printk(KERN_WARNING "megaraid_legacy: pending commands!!\n");
 
 	/*
 	 * Have a delibrate delay to make sure all the caches are
@@ -5044,28 +5053,18 @@ megaraid_shutdown(struct pci_dev *pdev)
 }
 
 static struct pci_device_id megaraid_pci_tbl[] = {
-	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DISCOVERY,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_PERC4_DI,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
-	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_PERC4_QC_VERDE,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, BOARD_64BIT},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_AMI_MEGARAID3,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_AMI_MEGARAID3,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, megaraid_pci_tbl);
 
 static struct pci_driver megaraid_pci_driver = {
-	.name		= "megaraid",
+	.name		= "megaraid_legacy",
 	.id_table	= megaraid_pci_tbl,
 	.probe		= megaraid_probe_one,
 	.remove		= __devexit_p(megaraid_remove_one),
@@ -5084,8 +5083,8 @@ static int __init megaraid_init(void)
 #ifdef CONFIG_PROC_FS
 	mega_proc_dir_entry = proc_mkdir("megaraid", &proc_root);
 	if (!mega_proc_dir_entry) {
-		printk(KERN_WARNING
-				"megaraid: failed to create megaraid root\n");
+		printk(KERN_WARNING "megaraid_legacy: "
+				"failed to create megaraid root\n");
 	}
 #endif
 	error = pci_module_init(&megaraid_pci_driver);
@@ -5104,8 +5103,8 @@ static int __init megaraid_init(void)
 	 */
 	major = register_chrdev(0, "megadev", &megadev_fops);
 	if (!major) {
-		printk(KERN_WARNING
-				"megaraid: failed to register char device\n");
+		printk(KERN_WARNING "megaraid_legacy: "
+				"failed to register char device\n");
 	}
 
 	return 0;
--- linux-2.6.14/drivers/scsi/megaraid.h.orig	2005-10-29 13:49:32.000000000 +0100
+++ linux-2.6.14/drivers/scsi/megaraid.h	2005-10-29 14:03:18.000000000 +0100
@@ -1,5 +1,5 @@
-#ifndef __MEGARAID_H__
-#define __MEGARAID_H__
+#ifndef __MEGARAID_LEGACY_H__
+#define __MEGARAID_LEGACY_H__
 
 #include <linux/spinlock.h>
 
@@ -45,18 +45,10 @@
 
 #define MAX_DEV_TYPE	32
 
-#ifndef PCI_VENDOR_ID_LSI_LOGIC
-#define PCI_VENDOR_ID_LSI_LOGIC		0x1000
-#endif
-
 #ifndef PCI_VENDOR_ID_AMI
 #define PCI_VENDOR_ID_AMI		0x101E
 #endif
 
-#ifndef PCI_VENDOR_ID_DELL
-#define PCI_VENDOR_ID_DELL		0x1028
-#endif
-
 #ifndef PCI_VENDOR_ID_INTEL
 #define PCI_VENDOR_ID_INTEL		0x8086
 #endif

--------------030109030309000201030805--
