From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [2/6] - cleanup devices
Date: Thu, 21 Aug 2003 20:15:25 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030821101525.GC7570@twibble.org>
References: <20030821101348.GA7570@twibble.org> <20030821101434.GB7570@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:29586 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S262552AbTHUKPi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 06:15:38 -0400
Content-Disposition: inline
In-Reply-To: <20030821101434.GB7570@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

This cleans up the device management. It makes the init and cleanup
seperate functions that basically do the opposite type things in
reverse order. Makes it clear which functions remove a device and
which ones free a device (or devices.)


diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-08-19 23:25:18.585554464 +1000
+++ b/drivers/scsi/dc395x.c	2003-08-19 23:25:23.582794768 +1000
@@ -496,10 +496,6 @@
 			  struct ScsiReqBlk *srb);
 static inline void set_xfer_rate(struct AdapterCtlBlk *acb,
 				 struct DeviceCtlBlk *dcb);
-static void init_dcb(struct AdapterCtlBlk *acb,
-		     struct DeviceCtlBlk **pdcb, u8 target, u8 lun);
-static void remove_dev(struct AdapterCtlBlk *acb,
-		       struct DeviceCtlBlk *dcb);
 static void waiting_timeout(unsigned long ptr);
 
 
@@ -1451,34 +1447,6 @@
 }
 
 
-/***********************************************************************
- * Function static int dc395x_slave_alloc()
- *
- * Purpose: Allocate DCB
- ***********************************************************************/
-static int dc395x_slave_alloc(struct scsi_device *sdp)
-{
-	struct AdapterCtlBlk *acb;
-	struct DeviceCtlBlk *dummy;
-
-	acb = (struct AdapterCtlBlk *) sdp->host->hostdata;
-
-	init_dcb(acb, &dummy, sdp->id, sdp->lun);
-
-	return dummy ? 0 : -ENOMEM;
-}
-
-
-static void dc395x_slave_destroy(struct scsi_device *sdp)
-{
-	struct AdapterCtlBlk *acb;
-	struct DeviceCtlBlk *dcb;
-
-	acb = (struct AdapterCtlBlk *) sdp->host->hostdata;
-	dcb = find_dcb(acb, sdp->id, sdp->lun);
-
-	remove_dev(acb, dcb);
-}
 
 
 /*
@@ -1637,7 +1605,6 @@
 		dcb->sync_offset = 0;
 
 		dcb->dev_mode = eeprom->target[dcb->target_id].cfg0;
-		/*dcb->AdpMode = eeprom->channel_cfg; */
 		period_index = eeprom->target[dcb->target_id].period & 0x07;
 		dcb->min_nego_period = clock_period[period_index];
 		if (!(dcb->dev_mode & NTC_DO_WIDE_NEGO)
@@ -4051,40 +4018,8 @@
 }
 
 
-/* Dynamic device handling */
 
-/* Remove dev (and DCB) */
-static
-void remove_dev(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
-{
-	struct DeviceCtlBlk *i;
-	struct DeviceCtlBlk *tmp;
 
-	dprintkdbg(DBG_0, "remove_dev\n");
-	if (list_size(&dcb->srb_going_list) > 1) {
-		dprintkdbg(DBG_DCB, "Driver won't free DCB (ID %i, LUN %i): 0x%08x because of SRBCnt %i\n",
-			  dcb->target_id, dcb->target_lun, (int) dcb,
-			  list_size(&dcb->srb_going_list));
-		return;
-	}
-	acb->dcb_map[dcb->target_id] &= ~(1 << dcb->target_lun);
-	acb->children[dcb->target_id][dcb->target_lun] = NULL;
-
-	list_for_each_entry_safe(i, tmp, &acb->dcb_list, list) {
-		if (dcb == i) {
-			list_del(&i->list);
-			break;
-		}
-	}			                        
-
-	dprintkdbg(DBG_DCB, "Driver about to free DCB (ID %i, LUN %i): %p\n",
-		  dcb->target_id, dcb->target_lun, dcb);
-	if (dcb == acb->active_dcb)
-		acb->active_dcb = NULL;
-	if (dcb == acb->dcb_run_robin)
-		acb->dcb_run_robin = dcb_get_next(&acb->dcb_list, dcb);
-	dc395x_kfree(dcb);
-}
 
 
 static inline u8 tagq_blacklist(char *name)
@@ -4683,58 +4618,55 @@
 }
 
 
-/*
- *********************************************************************
- *		dc395x_queue_command
+
+
+
+/**
+ * device_alloc - Allocate a new device instance. This create the
+ * devices instance and sets up all the data items. The adapter
+ * instance is required to obtain confiuration information for this
+ * device. This does *not* add this device to the adapters device
+ * list.
  *
- * Function : void init_dcb
- *  Purpose : initialize the internal structures for a given DCB
- *   Inputs : cmd - pointer to this scsi cmd request block structure
- *********************************************************************
- */
+ * @acb: The adapter to obtain configuration information from.
+ * @target: The target for the new device.
+ * @lun: The lun for the new device.
+ *
+ * Return the new device if succesfull or NULL on failure.
+ **/
 static
-void init_dcb(struct AdapterCtlBlk *acb, struct DeviceCtlBlk **pdcb,
-	      u8 target, u8 lun)
+struct DeviceCtlBlk *device_alloc(struct AdapterCtlBlk *acb, u8 target, u8 lun)
 {
 	struct NvRamType *eeprom = &acb->eeprom;
-	u8 period_index;
+	u8 period_index = eeprom->target[target].period & 0x07;
 	struct DeviceCtlBlk *dcb;
-	struct DeviceCtlBlk *dcb2;
 
-	dprintkdbg(DBG_0, "init_dcb..............\n");
 	dcb = dc395x_kmalloc(sizeof(struct DeviceCtlBlk), GFP_ATOMIC);
-	/*dcb = find_dcb (acb, target, lun); */
-	*pdcb = dcb;
-	dcb2 = NULL;
-	if (!dcb)
-		return;
-
-	INIT_LIST_HEAD(&dcb->srb_waiting_list);
+	dprintkdbg(DBG_0, "device_alloc: device %p\n", dcb);
+	if (!dcb) {
+		return NULL;
+	}
+	dcb->acb = NULL;
 	INIT_LIST_HEAD(&dcb->srb_going_list);
-	if (list_empty(&acb->dcb_list))
-		acb->dcb_run_robin = dcb;
-	list_add_tail(&dcb->list, &acb->dcb_list);
-
-	/* $$$$$$$ */
-	dcb->acb = acb;
-	dcb->target_id = target;
-	dcb->target_lun = lun;
-	/* $$$$$$$ */
+	INIT_LIST_HEAD(&dcb->srb_waiting_list);
 	dcb->active_srb = NULL;
-	/* $$$$$$$ */
 	dcb->tag_mask = 0;
-	dcb->flag = 0;
 	dcb->max_command = 1;
-	/* $$$$$$$ */
+	dcb->target_id = target;
+	dcb->target_lun = lun;
+#ifndef DC395x_NO_DISCONNECT
+	dcb->identify_msg =
+	    IDENTIFY(dcb->dev_mode & NTC_DO_DISCONNECT, lun);
+#else
+	dcb->identify_msg = IDENTIFY(0, lun);
+#endif
 	dcb->dev_mode = eeprom->target[target].cfg0;
-	/*dcb->AdpMode = eeprom->channel_cfg; */
 	dcb->inquiry7 = 0;
 	dcb->sync_mode = 0;
-	/* $$$$$$$ */
+	dcb->min_nego_period = clock_period[period_index];
 	dcb->sync_period = 0;
 	dcb->sync_offset = 0;
-	period_index = eeprom->target[target].period & 0x07;
-	dcb->min_nego_period = clock_period[period_index];
+	dcb->flag = 0;
 
 #ifndef DC395x_NO_WIDE
 	if ((dcb->dev_mode & NTC_DO_WIDE_NEGO)
@@ -4746,36 +4678,170 @@
 		if (!(lun) || current_sync_offset)
 			dcb->sync_mode |= SYNC_NEGO_ENABLE;
 #endif
-	/* $$$$$$$ */
-#ifndef DC395x_NO_DISCONNECT
-	dcb->identify_msg =
-	    IDENTIFY(dcb->dev_mode & NTC_DO_DISCONNECT, lun);
-#else
-	dcb->identify_msg = IDENTIFY(0, lun);
-#endif
-	/* $$$$$$$ */
 	if (dcb->target_lun != 0) {
 		/* Copy settings */
-		struct DeviceCtlBlk *prevDCB;
-		list_for_each_entry(prevDCB, &acb->dcb_list, list)
-			if (prevDCB->target_id == dcb->target_id)
+		struct DeviceCtlBlk *p;
+		list_for_each_entry(p, &acb->dcb_list, list)
+			if (p->target_id == dcb->target_id)
 				break;
-		dprintkdbg(DBG_KG,
+		dprintkdbg(DBG_KG, 
 		       "Copy settings from %02i-%02i to %02i-%02i\n",
-		       prevDCB->target_id, prevDCB->target_lun,
+		       p->target_id, p->target_lun,
 		       dcb->target_id, dcb->target_lun);
-		dcb->sync_mode = prevDCB->sync_mode;
-		dcb->sync_period = prevDCB->sync_period;
-		dcb->min_nego_period = prevDCB->min_nego_period;
-		dcb->sync_offset = prevDCB->sync_offset;
-		dcb->inquiry7 = prevDCB->inquiry7;
-	};
+		dcb->sync_mode = p->sync_mode;
+		dcb->sync_period = p->sync_period;
+		dcb->min_nego_period = p->min_nego_period;
+		dcb->sync_offset = p->sync_offset;
+		dcb->inquiry7 = p->inquiry7;
+	}
+	return dcb;
+}
 
-	acb->dcb_map[target] |= (1 << lun);
-	acb->children[target][lun] = dcb;
+
+/**
+ * adapter_add_device - Adds the device instance to the adaptor instance.
+ *
+ * @acb: The adapter device to be updated
+ * @dcb: A newly created and intialised device instance to add.
+ **/
+static
+void adapter_add_device(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
+{
+	/* backpointer to adapter */
+	dcb->acb = acb;
+	
+	/* set run_robin to this device if it is currently empty */
+	if (list_empty(&acb->dcb_list))
+		acb->dcb_run_robin = dcb;
+
+	/* add device to list */
+	list_add_tail(&dcb->list, &acb->dcb_list);
+
+	/* update device maps */
+	acb->dcb_map[dcb->target_id] |= (1 << dcb->target_lun);
+	acb->children[dcb->target_id][dcb->target_lun] = dcb;
+}
+
+
+/**
+ * adapter_remove_device - Removes the device instance from the adaptor
+ * instance. The device instance is not check in any way or freed by this. 
+ * The caller is expected to take care of that. This will simply remove the
+ * device from the adapters data strcutures.
+ *
+ * @acb: The adapter device to be updated
+ * @dcb: A device that has previously been added to the adapter.
+ **/
+static
+void adapter_remove_device(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
+{
+	struct DeviceCtlBlk *i;
+	struct DeviceCtlBlk *tmp;
+	dprintkdbg(DBG_0, "adapter_remove_device: Remove device (ID %i, LUN %i): %p\n",
+		   dcb->target_id, dcb->target_lun, dcb);
+
+	/* fix up any pointers to this device that we have in the adapter */
+	if (acb->active_dcb == dcb)
+		acb->active_dcb = NULL;
+	if (acb->dcb_run_robin == dcb)
+		acb->dcb_run_robin = dcb_get_next(&acb->dcb_list, dcb);
+
+	/* unlink from list */
+	list_for_each_entry_safe(i, tmp, &acb->dcb_list, list)
+		if (dcb == i) {
+			list_del(&i->list);
+			break;
+		}
+
+	/* clear map and children */	
+	acb->dcb_map[dcb->target_id] &= ~(1 << dcb->target_lun);
+	acb->children[dcb->target_id][dcb->target_lun] = NULL;
+	dcb->acb = NULL;
+}
+
+
+/**
+ * adapter_remove_and_free_device - Removes a single device from the adapter
+ * and then frees the device information.
+ *
+ * @acb: The adapter device to be updated
+ * @dcb: A device that has previously been added to the adapter.
+ */
+static
+void adapter_remove_and_free_device(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb)
+{
+	if (list_size(&dcb->srb_going_list) > 1) {
+		dprintkdbg(DBG_DCB, "adapter_remove_and_free_device: "
+		           "Won't remove because of %i active requests\n",
+			   list_size(&dcb->srb_going_list));
+		return;
+	}
+	adapter_remove_device(acb, dcb);
+	dc395x_kfree(dcb);
 }
 
 
+/**
+ * adapter_remove_and_free_all_devices - Removes and frees all of the
+ * devices associated with the specified adapter.
+ *
+ * @acb: The adapter from which all devices should be removed.
+ **/
+static
+void adapter_remove_and_free_all_devices(struct AdapterCtlBlk* acb)
+{
+	struct DeviceCtlBlk *dcb;
+	struct DeviceCtlBlk *tmp;
+	dprintkdbg(DBG_DCB, "adapter_remove_and_free_all_devices: Free all devices (%i devices)\n",
+		   list_size(&acb->dcb_list));
+
+	list_for_each_entry_safe(dcb, tmp, &acb->dcb_list, list)
+		adapter_remove_and_free_device(acb, dcb);
+}
+
+
+/**
+ * dc395x_slave_alloc - Called by the scsi mid layer to tell us about a new
+ * scsi device that we need to deal with. We allocate a new device and then
+ * insert that device into the adapters device list.
+ *
+ * @scsi_device: The new scsi device that we need to handle.
+ **/
+static
+int dc395x_slave_alloc(struct scsi_device *scsi_device)
+{
+	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
+	struct DeviceCtlBlk *dcb;
+
+	dcb = device_alloc(acb, scsi_device->id, scsi_device->lun);
+	if (!dcb)
+		return -ENOMEM;
+	adapter_add_device(acb, dcb);
+
+	return 0;
+}
+
+
+/**
+ * dc395x_slave_destroy - Called by the scsi mid layer to tell us about a
+ * device that is going away.
+ *
+ * @scsi_device: The new scsi device that we need to handle.
+ **/
+static
+void dc395x_slave_destroy(struct scsi_device *scsi_device)
+{
+	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)scsi_device->host->hostdata;
+	struct DeviceCtlBlk *dcb = find_dcb(acb, scsi_device->id, scsi_device->lun);
+	adapter_remove_and_free_device(acb, dcb);
+}
+
+
+
+
+
+
+
 #if debug_enabled(DBG_TRACE|DBG_TRACEALL)
 /*
  * Memory for trace buffers
@@ -5670,25 +5736,6 @@
 }
 
 
-/**
- * free_dcbs - Free all of the DCBs.
- *
- * @acb: Adapter to remove the DCBs for.
- **/
-static
-void free_dcbs(struct AdapterCtlBlk* acb)
-{
-	struct DeviceCtlBlk *dcb;
-	struct DeviceCtlBlk *tmp;
-
-	dprintkdbg(DBG_DCB, "Free %i DCBs\n", list_size(&acb->dcb_list));
-
-	list_for_each_entry_safe(dcb, tmp, &acb->dcb_list, list) {
-		dprintkdbg(DBG_DCB, "Free DCB (ID %i, LUN %i): %p\n",
-			             dcb->target_id, dcb->target_lun, dcb);
-		remove_dev(acb, dcb);
-	}
-}
 
 /**
  * host_release - shutdown device and release resources that were
@@ -5706,7 +5753,7 @@
 
 	DC395x_LOCK_IO(acb->scsi_host, flags);
 	chip_shutdown(acb);
-	free_dcbs(acb);
+	adapter_remove_and_free_all_devices(acb);
 
 	free_irq(host->irq, acb);
 	release_region(host->io_port, host->n_io_port);

-- 
 Jamie Lenehan <lenehan@twibble.org>
