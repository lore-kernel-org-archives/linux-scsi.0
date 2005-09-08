From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/8] aacraid: handle AIF hotplug events
Date: Thu, 08 Sep 2005 13:50:13 -0700
Message-ID: <1126212613.7479.20.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:44205 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751393AbVIHUx0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2005 16:53:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn from Adaptec.

Hotplug sniffs the AIFs (events) from the adapter and if a container
change resulting in the device going offline (container zero), online
(container zero completed) or changing capacity (morph) it will take
actions by calling the appropriate API.

Applies to the scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>


Index: scsi-misc-aac-2/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/aachba.c	2005-09-08 11:32:04.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/aachba.c	2005-09-08 11:32:23.000000000 -0700
@@ -479,7 +479,7 @@
  *	is updated in the struct fsa_dev_info structure rather than returned.
  */
  
-static int probe_container(struct aac_dev *dev, int cid)
+int probe_container(struct aac_dev *dev, int cid)
 {
 	struct fsa_dev_info *fsa_dev_ptr;
 	int status;
@@ -1455,6 +1455,8 @@
 				case TEST_UNIT_READY:
 					spin_unlock_irq(host->host_lock);
 					probe_container(dev, cid);
+					if ((fsa_dev_ptr[cid].valid & 1) == 0)
+						fsa_dev_ptr[cid].valid = 0;
 					spin_lock_irq(host->host_lock);
 					if (fsa_dev_ptr[cid].valid == 0) {
 						scsicmd->result = DID_NO_CONNECT << 16;
Index: scsi-misc-aac-2/drivers/scsi/aacraid/aacraid.h
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/aacraid.h	2005-09-08 11:32:04.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/aacraid.h	2005-09-08 11:32:23.000000000 -0700
@@ -780,7 +780,9 @@
 	u64		last;
 	u64		size;
 	u32		type;
+	u32		config_waiting_on;
 	u16		queue_depth;
+	u8		config_needed;
 	u8		valid;
 	u8		ro;
 	u8		locked;
@@ -1715,6 +1717,7 @@
 #define		AifCmdJobProgress	2	/* Progress report */
 #define			AifJobCtrZero	101	/* Array Zero progress */
 #define			AifJobStsSuccess 1	/* Job completes */
+#define			AifJobStsRunning 102	/* Job running */
 #define		AifCmdAPIReport		3	/* Report from other user of API */
 #define		AifCmdDriverNotify	4	/* Notify host driver of event */
 #define			AifDenMorphComplete 200	/* A morph operation completed */
@@ -1785,6 +1788,7 @@
 struct aac_driver_ident* aac_get_driver_ident(int devtype);
 int aac_get_adapter_info(struct aac_dev* dev);
 int aac_send_shutdown(struct aac_dev *dev);
+int probe_container(struct aac_dev *dev, int cid);
 extern int numacb;
 extern int acbsize;
 extern char aac_driver_version[];
Index: scsi-misc-aac-2/drivers/scsi/aacraid/commsup.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/commsup.c	2005-09-08 11:32:17.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/commsup.c	2005-09-08 11:32:23.000000000 -0700
@@ -39,6 +39,7 @@
 #include <linux/completion.h>
 #include <linux/blkdev.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
 #include <asm/semaphore.h>
 
 #include "aacraid.h"
@@ -791,6 +792,291 @@
 	memset(cp, 0,  256);
 }
 
+
+/**
+ *	aac_handle_aif		-	Handle a message from the firmware
+ *	@dev: Which adapter this fib is from
+ *	@fibptr: Pointer to fibptr from adapter
+ *
+ *	This routine handles a driver notify fib from the adapter and
+ *	dispatches it to the appropriate routine for handling.
+ */
+
+static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
+{
+	struct hw_fib * hw_fib = fibptr->hw_fib;
+	struct aac_aifcmd * aifcmd = (struct aac_aifcmd *)hw_fib->data;
+	int busy;
+	u32 container;
+	struct scsi_device *device;
+	enum {
+		NOTHING,
+		DELETE,
+		ADD,
+		CHANGE
+	} device_config_needed;
+
+	/* Sniff for container changes */
+
+	if (!dev)
+		return;
+	container = (u32)-1;
+
+	/*
+	 *	We have set this up to try and minimize the number of
+	 * re-configures that take place. As a result of this when
+	 * certain AIF's come in we will set a flag waiting for another
+	 * type of AIF before setting the re-config flag.
+	 */
+	switch (le32_to_cpu(aifcmd->command)) {
+	case AifCmdDriverNotify:
+		switch (le32_to_cpu(((u32 *)aifcmd->data)[0])) {
+		/*
+		 *	Morph or Expand complete
+		 */
+		case AifDenMorphComplete:
+		case AifDenVolumeExtendComplete:
+			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			if (container >= dev->maximum_num_containers)
+				break;
+
+			/*
+			 *	Find the Scsi_Device associated with the SCSI
+			 * address. Make sure we have the right array, and if
+			 * so set the flag to initiate a new re-config once we
+			 * see an AifEnConfigChange AIF come through.
+			 */
+
+			if ((dev != (struct aac_dev *)NULL)
+			 && (dev->scsi_host_ptr != (struct Scsi_Host *)NULL)) {
+				shost_for_each_device(device,
+					dev->scsi_host_ptr)
+				{
+					if ((device->channel ==
+						CONTAINER_TO_CHANNEL(container))
+					 && (device->id ==
+						CONTAINER_TO_ID(container))
+					 && (device->lun ==
+						CONTAINER_TO_LUN(container))) {
+
+						dev->fsa_dev[container].config_needed = CHANGE;
+						dev->fsa_dev[container].config_waiting_on = AifEnConfigChange;
+						break;
+					}
+				}
+			}
+		}
+
+		/*
+		 *	If we are waiting on something and this happens to be
+		 * that thing then set the re-configure flag.
+		 */
+		if (container != (u32)-1) {
+			if (container >= dev->maximum_num_containers)
+				break;
+			if (dev->fsa_dev[container].config_waiting_on ==
+			    le32_to_cpu(*(u32 *)aifcmd->data))
+				dev->fsa_dev[container].config_waiting_on = 0;
+		} else for (container = 0;
+		    container < dev->maximum_num_containers; ++container) {
+			if (dev->fsa_dev[container].config_waiting_on ==
+			    le32_to_cpu(*(u32 *)aifcmd->data))
+				dev->fsa_dev[container].config_waiting_on = 0;
+		}
+		break;
+
+	case AifCmdEventNotify:
+		switch (le32_to_cpu(((u32 *)aifcmd->data)[0])) {
+		/*
+		 *	Add an Array.
+		 */
+		case AifEnAddContainer:
+			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			if (container >= dev->maximum_num_containers)
+				break;
+			dev->fsa_dev[container].config_needed = ADD;
+			dev->fsa_dev[container].config_waiting_on =
+				AifEnConfigChange;
+			break;
+
+		/*
+		 *	Delete an Array.
+		 */
+		case AifEnDeleteContainer:
+			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			if (container >= dev->maximum_num_containers)
+				break;
+			dev->fsa_dev[container].config_needed = DELETE;
+			dev->fsa_dev[container].config_waiting_on =
+				AifEnConfigChange;
+			break;
+
+		/*
+		 *	Container change detected. If we currently are not
+		 * waiting on something else, setup to wait on a Config Change.
+		 */
+		case AifEnContainerChange:
+			container = le32_to_cpu(((u32 *)aifcmd->data)[1]);
+			if (container >= dev->maximum_num_containers)
+				break;
+			if (dev->fsa_dev[container].config_waiting_on)
+				break;
+			dev->fsa_dev[container].config_needed = CHANGE;
+			dev->fsa_dev[container].config_waiting_on =
+				AifEnConfigChange;
+			break;
+
+		case AifEnConfigChange:
+			break;
+
+		}
+
+		/*
+		 *	If we are waiting on something and this happens to be
+		 * that thing then set the re-configure flag.
+		 */
+		if (container != (u32)-1) {
+			if (container >= dev->maximum_num_containers)
+				break;
+			if (dev->fsa_dev[container].config_waiting_on ==
+			    le32_to_cpu(*(u32 *)aifcmd->data))
+				dev->fsa_dev[container].config_waiting_on = 0;
+		} else for (container = 0;
+		    container < dev->maximum_num_containers; ++container) {
+			if (dev->fsa_dev[container].config_waiting_on ==
+			    le32_to_cpu(*(u32 *)aifcmd->data))
+				dev->fsa_dev[container].config_waiting_on = 0;
+		}
+		break;
+
+	case AifCmdJobProgress:
+		/*
+		 *	These are job progress AIF's. When a Clear is being
+		 * done on a container it is initially created then hidden from
+		 * the OS. When the clear completes we don't get a config
+		 * change so we monitor the job status complete on a clear then
+		 * wait for a container change.
+		 */
+
+		if ((((u32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero))
+		 && ((((u32 *)aifcmd->data)[6] == ((u32 *)aifcmd->data)[5])
+		  || (((u32 *)aifcmd->data)[4] == cpu_to_le32(AifJobStsSuccess)))) {
+			for (container = 0;
+			    container < dev->maximum_num_containers;
+			    ++container) {
+				/*
+				 * Stomp on all config sequencing for all
+				 * containers?
+				 */
+				dev->fsa_dev[container].config_waiting_on =
+					AifEnContainerChange;
+				dev->fsa_dev[container].config_needed = ADD;
+			}
+		}
+		if ((((u32 *)aifcmd->data)[1] == cpu_to_le32(AifJobCtrZero))
+		 && (((u32 *)aifcmd->data)[6] == 0)
+		 && (((u32 *)aifcmd->data)[4] == cpu_to_le32(AifJobStsRunning))) {
+			for (container = 0;
+			    container < dev->maximum_num_containers;
+			    ++container) {
+				/*
+				 * Stomp on all config sequencing for all
+				 * containers?
+				 */
+				dev->fsa_dev[container].config_waiting_on =
+					AifEnContainerChange;
+				dev->fsa_dev[container].config_needed = DELETE;
+			}
+		}
+		break;
+	}
+
+	device_config_needed = NOTHING;
+	for (container = 0; container < dev->maximum_num_containers;
+	    ++container) {
+		if ((dev->fsa_dev[container].config_waiting_on == 0)
+		 && (dev->fsa_dev[container].config_needed != NOTHING)) {
+			device_config_needed =
+				dev->fsa_dev[container].config_needed;
+			dev->fsa_dev[container].config_needed = NOTHING;
+			break;
+		}
+	}
+	if (device_config_needed == NOTHING)
+		return;
+
+	/*
+	 *	If we decided that a re-configuration needs to be done,
+	 * schedule it here on the way out the door, please close the door
+	 * behind you.
+	 */
+
+	busy = 0;
+
+
+	/*
+	 *	Find the Scsi_Device associated with the SCSI address,
+	 * and mark it as changed, invalidating the cache. This deals
+	 * with changes to existing device IDs.
+	 */
+
+	if (!dev || !dev->scsi_host_ptr)
+		return;
+	/*
+	 * force reload of disk info via probe_container
+	 */
+	if ((device_config_needed == CHANGE)
+	 && (dev->fsa_dev[container].valid == 1))
+		dev->fsa_dev[container].valid = 2;
+	if ((device_config_needed == CHANGE) ||
+			(device_config_needed == ADD))
+		probe_container(dev, container);
+	shost_for_each_device(device, dev->scsi_host_ptr)
+	{
+		if ((device->channel == CONTAINER_TO_CHANNEL(container))
+		 && (device->id == CONTAINER_TO_ID(container))
+		 && (device->lun == CONTAINER_TO_LUN(container))) {
+			busy |= device->device_busy ||
+				test_bit(SHOST_RECOVERY,
+				(const unsigned long*)&dev->scsi_host_ptr->shost_state);
+			if (busy == 0) {
+				device->removable = 1;
+				switch (device_config_needed) {
+				case ADD:
+					/*
+					 *	No need to call
+					 * scsi_scan_single_target
+					 */
+					device_config_needed = CHANGE;
+					scsi_add_device(dev->scsi_host_ptr,
+					  device->channel, device->id,
+					  device->lun);
+					break;
+				case DELETE:
+					scsi_remove_device(device);
+					break;
+				case CHANGE:
+	 				if (!dev->fsa_dev[container].valid) {
+						scsi_remove_device(device);
+						break;
+					}
+					scsi_rescan_device(&device->sdev_gendev);
+
+				default:
+					break;
+				}
+			}
+		}
+	}
+	if (device_config_needed == ADD) {
+		scsi_add_device(dev->scsi_host_ptr,
+		  CONTAINER_TO_CHANNEL(container),
+		  CONTAINER_TO_ID(container),
+		  CONTAINER_TO_LUN(container));
+	}
+
+}
+
 /**
  *	aac_command_thread	-	command processing thread
  *	@dev: Adapter to monitor
@@ -860,6 +1146,7 @@
 			aifcmd = (struct aac_aifcmd *) hw_fib->data;
 			if (aifcmd->command == cpu_to_le32(AifCmdDriverNotify)) {
 				/* Handle Driver Notify Events */
+				aac_handle_aif(dev, fib);
 				*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
 				fib_adapter_complete(fib, (u16)sizeof(u32));
 			} else {
@@ -872,7 +1159,15 @@
 				unsigned num;
 				struct hw_fib ** hw_fib_pool, ** hw_fib_p;
 				struct fib ** fib_pool, ** fib_p;
-				
+			
+				/* Sniff events */
+				if ((aifcmd->command == 
+				     cpu_to_le32(AifCmdEventNotify)) ||
+				    (aifcmd->command == 
+				     cpu_to_le32(AifCmdJobProgress))) {
+					aac_handle_aif(dev, fib);
+				}
+ 				
 				time_now = jiffies/HZ;
 
 				/*

-- 
Mark Haverkamp <markh@osdl.org>

