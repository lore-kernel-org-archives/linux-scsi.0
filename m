From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 4/4] aacraid: Reset adapter in recovery timeout
Date: Thu, 03 Aug 2006 08:03:30 -0700
Message-ID: <1154617410.31319.23.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:2021 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932362AbWHCPDe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Aug 2006 11:03:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

If the adapter is in blinkled (Firmware Assert) when error recovery
timeout actions have been triggered, perform an adapter warm reset and
restart the initialization. 

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-07-31 14:33:51.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-07-31 14:39:09.000000000 -0700
@@ -175,7 +175,7 @@
  *
  *	Query config status, and commit the configuration if needed.
  */
-int aac_get_config_status(struct aac_dev *dev)
+int aac_get_config_status(struct aac_dev *dev, int commit_flag)
 {
 	int status = 0;
 	struct fib * fibptr;
@@ -219,7 +219,7 @@
 	aac_fib_complete(fibptr);
 	/* Send a CT_COMMIT_CONFIG to enable discovery of devices */
 	if (status >= 0) {
-		if (commit == 1) {
+		if ((commit == 1) || commit_flag) {
 			struct aac_commit_config * dinfo;
 			aac_fib_init(fibptr);
 			dinfo = (struct aac_commit_config *) fib_data(fibptr);
@@ -784,8 +784,9 @@
 		dev->maximum_num_channels = le32_to_cpu(bus_info->BusCount);
 	}
 
-	tmp = le32_to_cpu(dev->adapter_info.kernelrev);
-	printk(KERN_INFO "%s%d: kernel %d.%d-%d[%d] %.*s\n", 
+	if (!dev->in_reset) {
+		tmp = le32_to_cpu(dev->adapter_info.kernelrev);
+		printk(KERN_INFO "%s%d: kernel %d.%d-%d[%d] %.*s\n",
 			dev->name, 
 			dev->id,
 			tmp>>24,
@@ -794,20 +795,21 @@
 			le32_to_cpu(dev->adapter_info.kernelbuild),
 			(int)sizeof(dev->supplement_adapter_info.BuildDate),
 			dev->supplement_adapter_info.BuildDate);
-	tmp = le32_to_cpu(dev->adapter_info.monitorrev);
-	printk(KERN_INFO "%s%d: monitor %d.%d-%d[%d]\n", 
+		tmp = le32_to_cpu(dev->adapter_info.monitorrev);
+		printk(KERN_INFO "%s%d: monitor %d.%d-%d[%d]\n",
 			dev->name, dev->id,
 			tmp>>24,(tmp>>16)&0xff,tmp&0xff,
 			le32_to_cpu(dev->adapter_info.monitorbuild));
-	tmp = le32_to_cpu(dev->adapter_info.biosrev);
-	printk(KERN_INFO "%s%d: bios %d.%d-%d[%d]\n", 
+		tmp = le32_to_cpu(dev->adapter_info.biosrev);
+		printk(KERN_INFO "%s%d: bios %d.%d-%d[%d]\n",
 			dev->name, dev->id,
 			tmp>>24,(tmp>>16)&0xff,tmp&0xff,
 			le32_to_cpu(dev->adapter_info.biosbuild));
-	if (le32_to_cpu(dev->adapter_info.serial[0]) != 0xBAD0)
-		printk(KERN_INFO "%s%d: serial %x\n",
-			dev->name, dev->id,
-			le32_to_cpu(dev->adapter_info.serial[0]));
+		if (le32_to_cpu(dev->adapter_info.serial[0]) != 0xBAD0)
+			printk(KERN_INFO "%s%d: serial %x\n",
+				dev->name, dev->id,
+				le32_to_cpu(dev->adapter_info.serial[0]));
+	}
 
 	dev->nondasd_support = 0;
 	dev->raid_scsi_mode = 0;
@@ -1417,6 +1419,9 @@
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
 	aac = (struct aac_dev *)scsicmd->device->host->hostdata;
+	if (aac->in_reset)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
 	/*
 	 *	Allocate and initialize a Fib
 	 */
@@ -1504,6 +1509,8 @@
 				case INQUIRY:
 				case READ_CAPACITY:
 				case TEST_UNIT_READY:
+					if (dev->in_reset)
+						return -1;
 					spin_unlock_irq(host->host_lock);
 					aac_probe_container(dev, cid);
 					if ((fsa_dev_ptr[cid].valid & 1) == 0)
@@ -1529,6 +1536,8 @@
 			}
 		} else {  /* check for physical non-dasd devices */
 			if(dev->nondasd_support == 1){
+				if (dev->in_reset)
+					return -1;
 				return aac_send_srb_fib(scsicmd);
 			} else {
 				scsicmd->result = DID_NO_CONNECT << 16;
@@ -1584,6 +1593,8 @@
 			scsicmd->scsi_done(scsicmd);
 			return 0;
 		}
+		if (dev->in_reset)
+			return -1;
 		setinqstr(dev, (void *) (inq_data.inqd_vid), fsa_dev_ptr[cid].type);
 		inq_data.inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
 		aac_internal_transfer(scsicmd, &inq_data, 0, sizeof(inq_data));
@@ -1739,6 +1750,8 @@
 		case READ_10:
 		case READ_12:
 		case READ_16:
+			if (dev->in_reset)
+				return -1;
 			/*
 			 *	Hack to keep track of ordinal number of the device that
 			 *	corresponds to a container. Needed to convert
@@ -1757,6 +1770,8 @@
 		case WRITE_10:
 		case WRITE_12:
 		case WRITE_16:
+			if (dev->in_reset)
+				return -1;
 			return aac_write(scsicmd, cid);
 
 		case SYNCHRONIZE_CACHE:
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-07-31 14:33:47.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-07-31 14:37:38.000000000 -0700
@@ -1029,6 +1029,7 @@
 	  init->InitStructRevision==cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_4)
 	u8			raw_io_64;
 	u8			printf_enabled;
+	u8			in_reset;
 };
 
 #define aac_adapter_interrupt(dev) \
@@ -1789,7 +1790,7 @@
 int aac_fib_complete(struct fib * context);
 #define fib_data(fibctx) ((void *)(fibctx)->hw_fib->data)
 struct aac_dev *aac_init_adapter(struct aac_dev *dev);
-int aac_get_config_status(struct aac_dev *dev);
+int aac_get_config_status(struct aac_dev *dev, int commit_flag);
 int aac_get_containers(struct aac_dev *dev);
 int aac_scsi_cmd(struct scsi_cmnd *cmd);
 int aac_dev_ioctl(struct aac_dev *dev, int cmd, void __user *arg);
@@ -1800,6 +1801,7 @@
 unsigned int aac_response_normal(struct aac_queue * q);
 unsigned int aac_command_normal(struct aac_queue * q);
 unsigned int aac_intr_normal(struct aac_dev * dev, u32 Index);
+int aac_check_health(struct aac_dev * dev);
 int aac_command_thread(void *data);
 int aac_close_fib_context(struct aac_dev * dev, struct aac_fib_context *fibctx);
 int aac_fib_adapter_complete(struct fib * fibptr, unsigned short size);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commctrl.c	2006-07-31 14:33:19.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commctrl.c	2006-07-31 14:37:38.000000000 -0700
@@ -298,7 +298,7 @@
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
 		/* If someone killed the AIF aacraid thread, restart it */
 		status = !dev->aif_thread;
-		if (status && dev->queues && dev->fsa_dev) {
+		if (status && !dev->in_reset && dev->queues && dev->fsa_dev) {
 			/* Be paranoid, be very paranoid! */
 			kthread_stop(dev->thread);
 			ssleep(1);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2006-07-31 14:33:19.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2006-07-31 14:37:38.000000000 -0700
@@ -40,8 +40,10 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
 #include <asm/semaphore.h>
 
 #include "aacraid.h"
@@ -1054,6 +1056,262 @@
 
 }
 
+static int _aac_reset_adapter(struct aac_dev *aac)
+{
+	int index, quirks;
+	u32 ret;
+	int retval;
+	struct Scsi_Host *host;
+	struct scsi_device *dev;
+	struct scsi_cmnd *command;
+	struct scsi_cmnd *command_list;
+
+	/*
+	 * Assumptions:
+	 *	- host is locked.
+	 *	- in_reset is asserted, so no new i/o is getting to the
+	 *	  card.
+	 *	- The card is dead.
+	 */
+	host = aac->scsi_host_ptr;
+	scsi_block_requests(host);
+	aac_adapter_disable_int(aac);
+	spin_unlock_irq(host->host_lock);
+	kthread_stop(aac->thread);
+
+	/*
+	 *	If a positive health, means in a known DEAD PANIC
+	 * state and the adapter could be reset to `try again'.
+	 */
+	retval = aac_adapter_check_health(aac);
+	if (retval == 0)
+		retval = aac_adapter_sync_cmd(aac, IOP_RESET_ALWAYS,
+		  0, 0, 0, 0, 0, 0, &ret, NULL, NULL, NULL, NULL);
+	if (retval)
+		retval = aac_adapter_sync_cmd(aac, IOP_RESET,
+		  0, 0, 0, 0, 0, 0, &ret, NULL, NULL, NULL, NULL);
+
+	if (retval)
+		goto out;
+	if (ret != 0x00000001) {
+		retval = -ENODEV;
+		goto out;
+	}
+
+	index = aac->cardtype;
+
+	/*
+	 * Re-initialize the adapter, first free resources, then carefully
+	 * apply the initialization sequence to come back again. Only risk
+	 * is a change in Firmware dropping cache, it is assumed the caller
+	 * will ensure that i/o is queisced and the card is flushed in that
+	 * case.
+	 */
+	aac_fib_map_free(aac);
+	aac->hw_fib_va = NULL;
+	aac->hw_fib_pa = 0;
+	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
+	aac->comm_addr = NULL;
+	aac->comm_phys = 0;
+	kfree(aac->queues);
+	aac->queues = NULL;
+	free_irq(aac->pdev->irq, aac);
+	kfree(aac->fsa_dev);
+	aac->fsa_dev = NULL;
+	if (aac_get_driver_ident(index)->quirks & AAC_QUIRK_31BIT) {
+		if (((retval = pci_set_dma_mask(aac->pdev, DMA_32BIT_MASK))) ||
+		  ((retval = pci_set_consistent_dma_mask(aac->pdev, DMA_32BIT_MASK))))
+			goto out;
+	} else {
+		if (((retval = pci_set_dma_mask(aac->pdev, 0x7FFFFFFFULL))) ||
+		  ((retval = pci_set_consistent_dma_mask(aac->pdev, 0x7FFFFFFFULL))))
+			goto out;
+	}
+	if ((retval = (*(aac_get_driver_ident(index)->init))(aac)))
+		goto out;
+	if (aac_get_driver_ident(index)->quirks & AAC_QUIRK_31BIT)
+		if ((retval = pci_set_dma_mask(aac->pdev, DMA_32BIT_MASK)))
+			goto out;
+	aac->thread = kthread_run(aac_command_thread, aac, aac->name);
+	if (IS_ERR(aac->thread)) {
+		retval = PTR_ERR(aac->thread);
+		goto out;
+	}
+	(void)aac_get_adapter_info(aac);
+	quirks = aac_get_driver_ident(index)->quirks;
+	if ((quirks & AAC_QUIRK_34SG) && (host->sg_tablesize > 34)) {
+ 		host->sg_tablesize = 34;
+ 		host->max_sectors = (host->sg_tablesize * 8) + 112;
+ 	}
+ 	if ((quirks & AAC_QUIRK_17SG) && (host->sg_tablesize > 17)) {
+ 		host->sg_tablesize = 17;
+ 		host->max_sectors = (host->sg_tablesize * 8) + 112;
+ 	}
+	aac_get_config_status(aac, 1);
+	aac_get_containers(aac);
+	/*
+	 * This is where the assumption that the Adapter is quiesced
+	 * is important.
+	 */
+	command_list = NULL;
+	__shost_for_each_device(dev, host) {
+		unsigned long flags;
+		spin_lock_irqsave(&dev->list_lock, flags);
+		list_for_each_entry(command, &dev->cmd_list, list)
+			if (command->SCp.phase == AAC_OWNER_FIRMWARE) {
+				command->SCp.buffer = (struct scatterlist *)command_list;
+				command_list = command;
+			}
+		spin_unlock_irqrestore(&dev->list_lock, flags);
+	}
+	while ((command = command_list)) {
+		command_list = (struct scsi_cmnd *)command->SCp.buffer;
+		command->SCp.buffer = NULL;
+		command->result = DID_OK << 16
+		  | COMMAND_COMPLETE << 8
+		  | SAM_STAT_TASK_SET_FULL;
+		command->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+		command->scsi_done(command);
+	}
+	retval = 0;
+
+out:
+	aac->in_reset = 0;
+	scsi_unblock_requests(host);
+	spin_lock_irq(host->host_lock);
+	return retval;
+}
+
+int aac_check_health(struct aac_dev * aac)
+{
+	int BlinkLED;
+	unsigned long time_now, flagv = 0;
+	struct list_head * entry;
+	struct Scsi_Host * host;
+
+	/* Extending the scope of fib_lock slightly to protect aac->in_reset */
+	if (spin_trylock_irqsave(&aac->fib_lock, flagv) == 0)
+		return 0;
+
+	if (aac->in_reset || !(BlinkLED = aac_adapter_check_health(aac))) {
+		spin_unlock_irqrestore(&aac->fib_lock, flagv);
+		return 0; /* OK */
+	}
+
+	aac->in_reset = 1;
+
+	/* Fake up an AIF:
+	 *	aac_aifcmd.command = AifCmdEventNotify = 1
+	 *	aac_aifcmd.seqnum = 0xFFFFFFFF
+	 *	aac_aifcmd.data[0] = AifEnExpEvent = 23
+	 *	aac_aifcmd.data[1] = AifExeFirmwarePanic = 3
+	 *	aac.aifcmd.data[2] = AifHighPriority = 3
+	 *	aac.aifcmd.data[3] = BlinkLED
+	 */
+
+	time_now = jiffies/HZ;
+	entry = aac->fib_list.next;
+
+	/*
+	 * For each Context that is on the
+	 * fibctxList, make a copy of the
+	 * fib, and then set the event to wake up the
+	 * thread that is waiting for it.
+	 */
+	while (entry != &aac->fib_list) {
+		/*
+		 * Extract the fibctx
+		 */
+		struct aac_fib_context *fibctx = list_entry(entry, struct aac_fib_context, next);
+		struct hw_fib * hw_fib;
+		struct fib * fib;
+		/*
+		 * Check if the queue is getting
+		 * backlogged
+		 */
+		if (fibctx->count > 20) {
+			/*
+			 * It's *not* jiffies folks,
+			 * but jiffies / HZ, so do not
+			 * panic ...
+			 */
+			u32 time_last = fibctx->jiffies;
+			/*
+			 * Has it been > 2 minutes
+			 * since the last read off
+			 * the queue?
+			 */
+			if ((time_now - time_last) > aif_timeout) {
+				entry = entry->next;
+				aac_close_fib_context(aac, fibctx);
+				continue;
+			}
+		}
+		/*
+		 * Warning: no sleep allowed while
+		 * holding spinlock
+		 */
+		hw_fib = kmalloc(sizeof(struct hw_fib), GFP_ATOMIC);
+		fib = kmalloc(sizeof(struct fib), GFP_ATOMIC);
+		if (fib && hw_fib) {
+			struct aac_aifcmd * aif;
+
+			memset(hw_fib, 0, sizeof(struct hw_fib));
+			memset(fib, 0, sizeof(struct fib));
+			fib->hw_fib = hw_fib;
+			fib->dev = aac;
+			aac_fib_init(fib);
+			fib->type = FSAFS_NTC_FIB_CONTEXT;
+			fib->size = sizeof (struct fib);
+			fib->data = hw_fib->data;
+			aif = (struct aac_aifcmd *)hw_fib->data;
+			aif->command = cpu_to_le32(AifCmdEventNotify);
+		 	aif->seqnum = cpu_to_le32(0xFFFFFFFF);
+		 	aif->data[0] = cpu_to_le32(AifEnExpEvent);
+			aif->data[1] = cpu_to_le32(AifExeFirmwarePanic);
+		 	aif->data[2] = cpu_to_le32(AifHighPriority);
+			aif->data[3] = cpu_to_le32(BlinkLED);
+
+			/*
+			 * Put the FIB onto the
+			 * fibctx's fibs
+			 */
+			list_add_tail(&fib->fiblink, &fibctx->fib_list);
+			fibctx->count++;
+			/*
+			 * Set the event to wake up the
+			 * thread that will waiting.
+			 */
+			up(&fibctx->wait_sem);
+		} else {
+			printk(KERN_WARNING "aifd: didn't allocate NewFib.\n");
+			kfree(fib);
+			kfree(hw_fib);
+		}
+		entry = entry->next;
+	}
+
+	spin_unlock_irqrestore(&aac->fib_lock, flagv);
+
+	if (BlinkLED < 0) {
+		printk(KERN_ERR "%s: Host adapter dead %d\n", aac->name, BlinkLED);
+		goto out;
+	}
+
+	printk(KERN_ERR "%s: Host adapter BLINK LED 0x%x\n", aac->name, BlinkLED);
+
+	host = aac->scsi_host_ptr;
+	spin_lock_irqsave(host->host_lock, flagv);
+	BlinkLED = _aac_reset_adapter(aac);
+	spin_unlock_irqrestore(host->host_lock, flagv);
+	return BlinkLED;
+
+out:
+	aac->in_reset = 0;
+	return BlinkLED;
+}
+
+
 /**
  *	aac_command_thread	-	command processing thread
  *	@dev: Adapter to monitor
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-07-31 14:33:51.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-07-31 14:37:38.000000000 -0700
@@ -454,17 +454,17 @@
 	printk(KERN_ERR "%s: Host adapter reset request. SCSI hang ?\n", 
 					AAC_DRIVERNAME);
 	aac = (struct aac_dev *)host->hostdata;
-	if (aac_adapter_check_health(aac)) {
-		printk(KERN_ERR "%s: Host adapter appears dead\n", 
-				AAC_DRIVERNAME);
-		return -ENODEV;
-	}
+
+	if ((count = aac_check_health(aac)))
+		return count;
 	/*
 	 * Wait for all commands to complete to this specific
 	 * target (block maximum 60 seconds).
 	 */
 	for (count = 60; count; --count) {
-		int active = 0;
+		int active = aac->in_reset;
+
+		if (active == 0)
 		__shost_for_each_device(dev, host) {
 			spin_lock_irqsave(&dev->list_lock, flags);
 			list_for_each_entry(command, &dev->cmd_list, list) {
@@ -933,7 +933,7 @@
 	else
 		shost->max_channel = 0;
 
-	aac_get_config_status(aac);
+	aac_get_config_status(aac, 0);
 	aac_get_containers(aac);
 	list_add(&aac->entry, insert);
 

-- 
Mark Haverkamp <markh@osdl.org>

