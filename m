From: Erik Andersen <andersen@codepoet.org>
Subject: Re: [PATCH] SCSI hotplug support
Date: Fri, 18 Oct 2002 05:28:14 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021018112814.GA32693@codepoet.org>
References: <20021014215416.GB25941@codepoet.org> <20021014222515.GD1274@redhat.com> <20021015052521.GA1967@codepoet.org> <20021015182247.GA4391@redhat.com> <20021015184535.GA16401@codepoet.org> <20021015191330.GC4391@redhat.com> <20021015193216.GE15778@codepoet.org> <20021015195516.GE4391@redhat.com> <20021015220659.GA19530@codepoet.org> <20021016024016.GB4690@redhat.com>
Reply-To: andersen@codepoet.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021016024016.GB4690@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Tue Oct 15, 2002 at 10:40:16PM -0400, Doug Ledford wrote:
> middle of an interrupt or not).  In this case though, it's pretty easy to 
> tell it isn't interrupt context.  That's fine.  However, you still haven't 
> tested the scenario I mentioned at the start of this particular part of 
> the debate.  If you plug in one drive, then plug in another, does the 
> second one get added?  Possible way to test this without having separate 
> drives: load the sbp2 module *before* hotplugging your disks and see what 
> happens.

I have several firewire drives so testing this is not a
problem...  The answer is yes it is added.  With my latest patch
applied to the kernel, I had 4 drives plugged into my 1394 card
(my 1394 RAID box) when I loaded the sbp2 module.  All 4
coldplugged drives showed up in /proc/scsi/scsi.  I then plugged
in another drive, at which point all 5 drives showed up under
/proc/scsi/scsi as expected.

I made an update of my patch.  I have not attempted to convert
the 1394 hotplug driver to echo stuff into /proc/scsi/scsi.
However, this patch attempts to close the longstanding race
conditions inherent in add-single-device and remove-single-device
by using the BKL, and adds some better function docs.  I didn't
see any other locks in the scsi code that looked sufficient to
handle the races, so please correct me if there is a better
way...  This also fixes a stupid bug in the sbp2 part of my
previous patch that would cause coldplugged sbp2 devices to be
also hotplugged, causing them to be double registered with the
SCSI subsystem.

 -Erik

--
Erik B. Andersen             http://codepoet-consulting.com/
--This message was written using 73% post-consumer electrons--


--- linux-2.4.19/drivers/scsi/scsi_syms.c	2002-08-02 19:39:44.000000000 -0500
+++ linux-2.4.20-pre10-erik/drivers/scsi/scsi_syms.c	2002-10-09 16:41:01.000000000 -0500
@@ -103,3 +103,9 @@
 extern int scsi_delete_timer(Scsi_Cmnd *);
 EXPORT_SYMBOL(scsi_add_timer);
 EXPORT_SYMBOL(scsi_delete_timer);
+
+/* Support for hot plugging and unplugging devices -- safe for 
+ * ieee1394 or USB devices, but probably not for normal SCSI... */
+EXPORT_SYMBOL(scsi_add_single_device);
+EXPORT_SYMBOL(scsi_remove_single_device);
+
--- linux-2.4.19/drivers/scsi/hosts.h	2002-10-18 05:16:17.000000000 -0500
+++ linux-2.4.20-pre10-erik/drivers/scsi/hosts.h	2002-10-09 17:00:13.000000000 -0500
@@ -532,6 +532,13 @@
 int scsi_register_device(struct Scsi_Device_Template * sdpnt);
 void scsi_deregister_device(struct Scsi_Device_Template * tpnt);
 
+/* Support for hot plugging and unplugging devices -- safe for 
+ * ieee1394 or USB devices, but probably not for normal SCSI... */
+extern int scsi_add_single_device(struct Scsi_Host *shpnt, 
+	int channel, int id, int lun);
+extern int scsi_remove_single_device(struct Scsi_Host *shpnt, 
+	int channel, int id, int lun);
+
 /* These are used by loadable modules */
 extern int scsi_register_module(int, void *);
 extern int scsi_unregister_module(int, void *);
--- linux-2.4.19/drivers/scsi/scsi.c	2002-10-18 05:16:17.000000000 -0500
+++ linux-2.4.20-pre10-erik/drivers/scsi/scsi.c	2002-10-17 21:12:48.000000000 -0500
@@ -1553,6 +1553,165 @@
     }
 }
 
+
+/*
+ * Function:    scsi_add_single_device()
+ *
+ * Purpose:     Support for hotplugging SCSI devices.  This function
+ *              implements the actual functionality for
+ *                  echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
+ *
+ * Arguments:   shpnt   - pointer to the SCSI host structure
+ *              channel - channel of the device to add
+ *              id      - id of the device to add
+ *              lun     - lun of the device to add
+ *
+ * Returns:     0 on success or an error code
+ *
+ * Lock status: None needed.  However we do grab the BKL to avoid racing with
+ *              scsi_register*(), scsi_unregister*(), scsi_remove_single_device()
+ *              and anything else that might be messing with with the Scsi_Host or
+ *              other fundamental data structures.
+ *
+ * Notes:       This feature is probably unsafe for standard SCSI devices, 
+ *              but is perfectly normal for things like ieee1394 or USB 
+ *              drives since these busses are designed for hotplugging.  
+ *              Use at your own risk....
+ */
+int scsi_add_single_device(struct Scsi_Host *shpnt, int channel, 
+	int id, int lun)
+{
+	Scsi_Device *scd;
+
+	/* Do a bit of sanity checking */
+	if (shpnt==NULL) {
+		return  -ENXIO;
+	}
+
+	/* get the big kernel lock to avoid racing with
+	 * scsi_register*(), scsi_unregister*(), scsi_remove_single_device() 
+	 * or anything else that might be messing with with the Scsi_Host or
+	 * other fundamental data structures.  */
+	lock_kernel();
+
+	/* Check if they asked us to add an already existing device.
+	 * If so, ignore their misguided efforts. */
+	for (scd = shpnt->host_queue; scd; scd = scd->next) {
+		if ((scd->channel == channel && scd->id == id && scd->lun == lun)) {
+			break;
+		}
+	}
+	if (scd) {
+		unlock_kernel();
+		return -ENOSYS;
+	}
+
+	/* We have the BKL, so we should be safe while we muck 
+	 * about with Scsi_Device internals. */
+	scan_scsis(shpnt, 1, channel, id, lun);
+	unlock_kernel();
+	return 0;
+}
+
+/* Support for plugging/unplugging SCSI devices.  This feature is
+ * probably unsafe for standard SCSI devices, but is perfectly
+ * normal for things like ieee1394 or USB drives since these
+ * busses are designed for hotplugging.  Use at your own risk.... */
+/*
+ * Function:    scsi_remove_single_device()
+ *
+ * Purpose:     Support for hot-unplugging SCSI devices.  This function
+ *              implements the actual functionality for
+ *                  echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
+ *
+ * Arguments:   shpnt   - pointer to the SCSI host structure
+ *              channel - channel of the device to add
+ *              id      - id of the device to add
+ *              lun     - lun of the device to add
+ *
+ * Returns:     0 on success or an error code
+ *
+ * Lock status: None needed.  However we do grab the BKL to avoid racing with
+ *              scsi_register*(), scsi_unregister*(), scsi_add_single_device()
+ *              and anything else that might be messing with with the Scsi_Host or
+ *              other fundamental data structures.
+ *
+ * Notes:       This feature is probably unsafe for standard SCSI devices, 
+ *              but is perfectly normal for things like ieee1394 or USB 
+ *              drives since these busses are designed for hotplugging.  
+ *              Use at your own risk....
+ */
+int scsi_remove_single_device(struct Scsi_Host *shpnt, int channel, 
+	int id, int lun)
+{
+	Scsi_Device *scd;
+	struct Scsi_Device_Template *SDTpnt;
+
+	/* Do a bit of sanity checking */
+	if (shpnt==NULL) {
+		return  -ENODEV;
+	}
+
+	/* get the big kernel lock to avoid racing with
+	 * scsi_register*(), scsi_unregister*(), scsi_add_single_device() 
+	 * or anything else that might be messing with with the Scsi_Host or
+	 * other fundamental data structures.  */
+	lock_kernel();
+
+	/* Make sure the specified device is in fact present */
+	for (scd = shpnt->host_queue; scd; scd = scd->next) {
+		if ((scd->channel == channel && scd->id == id && scd->lun == lun)) {
+			break;
+		}
+	}
+	if (scd==NULL) {
+		unlock_kernel();
+		return -ENODEV;
+	}
+
+	/* See if the specified device is busy.  We have the BKL, so we
+	 * should not race with sd_open(), sd_release() and similar that 
+	 * increment access_count */
+	if (scd->access_count) {
+		unlock_kernel();
+		return -EBUSY;
+	}
+
+	SDTpnt = scsi_devicelist;
+	while (SDTpnt != NULL) {
+		if (SDTpnt->detach)
+			(*SDTpnt->detach) (scd);
+		SDTpnt = SDTpnt->next;
+	}
+
+	/* We have the BKL, so we should be safe while we muck 
+	 * about with Scsi_Device internals. */
+	if (scd->attached == 0) {
+		/* Nobody is using this device, so we
+		 * can now free all command structures.  */
+		if (shpnt->hostt->revoke)
+			shpnt->hostt->revoke(scd);
+		devfs_unregister (scd->de);
+		scsi_release_commandblocks(scd);
+
+		/* Now we can remove the device structure */
+		if (scd->next != NULL)
+			scd->next->prev = scd->prev;
+
+		if (scd->prev != NULL)
+			scd->prev->next = scd->next;
+
+		if (shpnt->host_queue == scd) {
+			shpnt->host_queue = scd->next;
+		}
+		blk_cleanup_queue(&scd->request_queue);
+		kfree((char *) scd);
+	}
+
+	unlock_kernel();
+	return 0;
+}
+
 #ifdef CONFIG_PROC_FS
 static int scsi_proc_info(char *buffer, char **start, off_t offset, int length)
 {
@@ -1605,8 +1764,6 @@
 static int proc_scsi_gen_write(struct file * file, const char * buf,
                               unsigned long length, void *data)
 {
-	struct Scsi_Device_Template *SDTpnt;
-	Scsi_Device *scd;
 	struct Scsi_Host *HBA_ptr;
 	char *p;
 	int host, channel, id, lun;
@@ -1721,13 +1878,12 @@
 	/*
 	 * Usage: echo "scsi add-single-device 0 1 2 3" >/proc/scsi/scsi
 	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
-	 * Consider this feature BETA.
+	 *
+	 * Consider this feature pre-BETA.
+	 *
 	 *     CAUTION: This is not for hotplugging your peripherals. As
 	 *     SCSI was not designed for this you could damage your
-	 *     hardware !
-	 * However perhaps it is legal to switch on an
-	 * already connected device. It is perhaps not
-	 * guaranteed this device doesn't corrupt an ongoing data transfer.
+	 *     hardware and thoroughly confuse the SCSI subsystem.
 	 */
 	if (!strncmp("add-single-device", buffer + 5, 17)) {
 		p = buffer + 23;
@@ -1745,33 +1901,11 @@
 				break;
 			}
 		}
-		err = -ENXIO;
-		if (!HBA_ptr)
-			goto out;
-
-		for (scd = HBA_ptr->host_queue; scd; scd = scd->next) {
-			if ((scd->channel == channel
-			     && scd->id == id
-			     && scd->lun == lun)) {
-				break;
-			}
-		}
-
-		err = -ENOSYS;
-		if (scd)
-			goto out;	/* We do not yet support unplugging */
-
-		scan_scsis(HBA_ptr, 1, channel, id, lun);
-
-		/* FIXME (DB) This assumes that the queue_depth routines can be used
-		   in this context as well, while they were all designed to be
-		   called only once after the detect routine. (DB) */
-		/* queue_depth routine moved to inside scan_scsis(,1,,,) so
-		   it is called before build_commandblocks() */
-
-		err = length;
+		if ((err=scsi_add_single_device(HBA_ptr, channel, id, lun))==0)
+		    err = length;
 		goto out;
 	}
+
 	/*
 	 * Usage: echo "scsi remove-single-device 0 1 2 3" >/proc/scsi/scsi
 	 * with  "0 1 2 3" replaced by your "Host Channel Id Lun".
@@ -1781,7 +1915,6 @@
 	 *     CAUTION: This is not for hotplugging your peripherals. As
 	 *     SCSI was not designed for this you could damage your
 	 *     hardware and thoroughly confuse the SCSI subsystem.
-	 *
 	 */
 	else if (!strncmp("remove-single-device", buffer + 5, 20)) {
 		p = buffer + 26;
@@ -1797,58 +1930,8 @@
 				break;
 			}
 		}
-		err = -ENODEV;
-		if (!HBA_ptr)
-			goto out;
-
-		for (scd = HBA_ptr->host_queue; scd; scd = scd->next) {
-			if ((scd->channel == channel
-			     && scd->id == id
-			     && scd->lun == lun)) {
-				break;
-			}
-		}
-
-		if (scd == NULL)
-			goto out;	/* there is no such device attached */
-
-		err = -EBUSY;
-		if (scd->access_count)
-			goto out;
-
-		SDTpnt = scsi_devicelist;
-		while (SDTpnt != NULL) {
-			if (SDTpnt->detach)
-				(*SDTpnt->detach) (scd);
-			SDTpnt = SDTpnt->next;
-		}
-
-		if (scd->attached == 0) {
-			/*
-			 * Nobody is using this device any more.
-			 * Free all of the command structures.
-			 */
-                        if (HBA_ptr->hostt->revoke)
-                                HBA_ptr->hostt->revoke(scd);
-			devfs_unregister (scd->de);
-			scsi_release_commandblocks(scd);
-
-			/* Now we can remove the device structure */
-			if (scd->next != NULL)
-				scd->next->prev = scd->prev;
-
-			if (scd->prev != NULL)
-				scd->prev->next = scd->next;
-
-			if (HBA_ptr->host_queue == scd) {
-				HBA_ptr->host_queue = scd->next;
-			}
-			blk_cleanup_queue(&scd->request_queue);
-			kfree((char *) scd);
-		} else {
-			goto out;
-		}
-		err = 0;
+		err=scsi_remove_single_device(HBA_ptr, channel, id, lun);
+		goto out;
 	}
 out:
 	
--- linux-2.4.19/drivers/ieee1394/sbp2.c	2002-10-18 05:16:14.000000000 -0500
+++ linux-2.4.20-pre10-erik/drivers/ieee1394/sbp2.c	2002-10-18 05:29:20.000000000 -0500
@@ -562,6 +562,8 @@
 	.update = 	sbp2_update
 };
 
+static int sbp2_init_has_finished_initializing;
+
 /* List of device firmware's that require a forced 36 byte inquiry.  */
 static u32 sbp2_broken_inquiry_list[] = {
 	0x00002800,	/* Stefan Richter <richtest@bauwesen.tu-cottbus.de> */
@@ -1082,6 +1084,8 @@
 
 	hpsb_register_protocol(&sbp2_driver);
 
+	sbp2_init_has_finished_initializing++;
+
 	return 0;
 }
 
@@ -1681,6 +1685,23 @@
 
 	SBP2_INFO("Logged into SBP-2 device");
 
+	/* Try to hook ourselves into the SCSI subsystem, but only if
+	 * sbp2_init has finished doing its thing.  If we register
+	 * anything while sbp2_init is handling coldplugged devices, we
+	 * will will end up double registering things (a bad idea). */
+	if (sbp2_init_has_finished_initializing) {
+	    struct Scsi_Host *HBA_ptr;
+	    HBA_ptr=hi->scsi_host;
+	    if (HBA_ptr==NULL) {
+		return 0;
+	    }
+	    if (scsi_add_single_device(HBA_ptr, 0, scsi_id->id, 0)==0) {
+		SBP2_DEBUG("connecting SBP-2 device into the SCSI subsystem");
+	    } else {
+		SBP2_INFO("Unable to connect SBP-2 device into the SCSI subsystem");
+	    }
+	}
+
 	return(0);
 
 }
@@ -1739,8 +1760,23 @@
 
 	SBP2_INFO("Logged out of SBP-2 device");
 
-	return(0);
+	/* Now that we are logged out of the SBP-2 device, lets
+	 * try to un-hook ourselves from the SCSI subsystem */
+	{
+	    struct Scsi_Host *HBA_ptr;
+
+	    HBA_ptr=hi->scsi_host;
+	    if (HBA_ptr==NULL) {
+		return 0;
+	    }
+	    if (scsi_remove_single_device(HBA_ptr, 0, scsi_id->id, 0)==0) {
+		SBP2_DEBUG("disconnecting SBP-2 device from the SCSI subsystem");
+	    } else {
+		SBP2_INFO("Unable to disconnect SBP-2 device from the SCSI subsystem");
+	    }
+	}
 
+	return(0);
 }
 
 /*
