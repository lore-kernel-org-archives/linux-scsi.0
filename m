From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fix 2.5 scsi queue depth setting
Date: Wed, 6 Nov 2002 11:50:19 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106115019.A13476@eng2.beaverton.ibm.com>
References: <patmans@us.ibm.com> <200211061850.gA6Io0003502@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200211061850.gA6Io0003502@localhost.localdomain>; from James.Bottomley@steeleye.com on Wed, Nov 06, 2002 at 01:50:00PM -0500
List-Id: linux-scsi@vger.kernel.org
To: "J.E.J. Bottomley" <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Wed, Nov 06, 2002 at 01:50:00PM -0500, J.E.J. Bottomley wrote:
> I'm OK with that, since the drivers can be audited as they're moved over to 
> slave attach.  It also works for drivers that use older hardware (like the 
> 53c700) which don't call adjust_queue_depth from slave attach, but slightly 
> later on when they've really verified the device will accept tags.  In this 
> case, I don't want the mid layer to call adjust_queue_depth for me even if I 
> leave slave_attach with only one command allocated.

OK, here it is again, as discussed, plus it calls scsi_release_commandblocks
on slave_attach failure.

 hosts.c              |    5 --
 hosts.h              |    6 --
 osst.c               |    9 ++-
 scsi.c               |  116 ++++++++++++++++++++++++++++++---------------------
 scsi.h               |    2 
 scsi_mid_low_api.txt |   24 ----------
 scsi_scan.c          |    9 ---
 scsi_syms.c          |    2 
 sd.c                 |   10 +++-
 sg.c                 |   10 ++--
 sr.c                 |    7 ++-
 st.c                 |   11 +++-
 12 files changed, 106 insertions(+), 105 deletions(-)

--- 1.23/drivers/scsi/hosts.c	Tue Nov  5 17:13:42 2002
+++ edited/drivers/scsi/hosts.c	Tue Nov  5 17:18:22 2002
@@ -249,10 +249,6 @@
 			       sdev->attached);
 			return 1;
 		}
-
-		if (shost->hostt->slave_detach)
-			(*shost->hostt->slave_detach) (sdev);
-
 		devfs_unregister(sdev->de);
 		device_unregister(&sdev->sdev_driverfs_dev);
 	}
@@ -261,7 +257,6 @@
 
 	for (sdev = shost->host_queue; sdev;
 	     sdev = shost->host_queue) {
-		scsi_release_commandblocks(sdev);
 		blk_cleanup_queue(&sdev->request_queue);
 		/* Next free up the Scsi_Device structures for this host */
 		shost->host_queue = sdev->next;
===== drivers/scsi/hosts.h 1.32 vs edited =====
--- 1.32/drivers/scsi/hosts.h	Tue Nov  5 17:13:42 2002
+++ edited/drivers/scsi/hosts.h	Tue Nov  5 19:40:42 2002
@@ -93,12 +93,6 @@
      */
     int (* detect)(struct SHT *);
 
-    /*
-     * This function is only used by one driver and will be going away
-     * once it switches over to using the slave_detach() function instead.
-     */
-    int (*revoke)(Scsi_Device *);
-
     /* Used with loadable modules to unload the host structures.  Note:
      * there is a default action built into the modules code which may
      * be sufficient for most host adapters.  Thus you may not have to supply
===== drivers/scsi/osst.c 1.24 vs edited =====
--- 1.24/drivers/scsi/osst.c	Mon Nov  4 20:00:30 2002
+++ edited/drivers/scsi/osst.c	Tue Nov  5 17:26:53 2002
@@ -5421,10 +5421,12 @@
 		return 1;
 
 	if (osst_nr_dev >= osst_dev_max) {
-		 SDp->attached--;
 		 put_disk(disk);
 		 return 1;
 	}
+
+	if (scsi_slave_attach(SDp))
+		return 1;
 	
 	/* find a free minor number */
 	for (i=0; os_scsi_tapes[i] && i<osst_dev_max; i++);
@@ -5433,9 +5435,10 @@
 	/* allocate a OS_Scsi_Tape for this device */
 	tpnt = (OS_Scsi_Tape *)kmalloc(sizeof(OS_Scsi_Tape), GFP_ATOMIC);
 	if (tpnt == NULL) {
-		 SDp->attached--;
 		 printk(KERN_WARNING "osst :W: Can't allocate device descriptor.\n");
 		 put_disk(disk);
+
+		 scsi_slave_detach(SDp);
 		 return 1;
 	}
 	memset(tpnt, 0, sizeof(OS_Scsi_Tape));
@@ -5648,7 +5651,7 @@
 		put_disk(tpnt->disk);
 		kfree(tpnt);
 		os_scsi_tapes[i] = NULL;
-		SDp->attached--;
+		scsi_slave_detach(SDp);
 		osst_nr_dev--;
 		osst_dev_noticed--;
 		return;
===== drivers/scsi/scsi.c 1.55 vs edited =====
--- 1.55/drivers/scsi/scsi.c	Tue Nov  5 17:13:42 2002
+++ edited/drivers/scsi/scsi.c	Wed Nov  6 11:28:38 2002
@@ -1664,10 +1664,6 @@
 			break;
 	}
 	spin_unlock_irqrestore(&device_request_lock, flags);
-	if(SDpnt->current_queue_depth == 0)
-	{
-		scsi_build_commandblocks(SDpnt);
-	}
 }
 
 #ifdef CONFIG_PROC_FS
@@ -1932,16 +1928,7 @@
 		scsi_detach_device(scd);
 
 		if (scd->attached == 0) {
-			/*
-			 * Nobody is using this device any more.
-			 * Free all of the command structures.
-			 */
-                        if (HBA_ptr->hostt->revoke)
-                                HBA_ptr->hostt->revoke(scd);
-			if (HBA_ptr->hostt->slave_detach)
-				(*HBA_ptr->hostt->slave_detach) (scd);
 			devfs_unregister (scd->de);
-			scsi_release_commandblocks(scd);
 
 			/* Now we can remove the device structure */
 			if (scd->next != NULL)
@@ -1976,7 +1963,7 @@
 	down_read(&scsi_devicelist_mutex);
 	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
 		if (sdt->detect)
-			sdev->attached += (*sdt->detect)(sdev);
+			(*sdt->detect)(sdev);
 	up_read(&scsi_devicelist_mutex);
 }
 
@@ -1984,18 +1971,16 @@
 {
 	struct Scsi_Device_Template *sdt;
 
-	scsi_build_commandblocks(sdev);
-	if (sdev->current_queue_depth == 0)
-		goto fail;
-
 	down_read(&scsi_devicelist_mutex);
 	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
 		if (sdt->attach)
+			/*
+			 * XXX check result when the upper level attach
+			 * return values are fixed, and on failure goto
+			 * fail.
+			 */
 			(*sdt->attach) (sdev);
 	up_read(&scsi_devicelist_mutex);
-
-	if (!sdev->attached)
-		scsi_release_commandblocks(sdev);
 	return 0;
 
 fail:
@@ -2017,6 +2002,64 @@
 }
 
 /*
+ * Function:	scsi_slave_attach()
+ *
+ * Purpose:	Called from the upper level driver attach to handle common
+ * 		attach code.
+ *
+ * Arguments:	sdev - scsi_device to attach
+ *
+ * Returns:	1 on error, 0 on succes
+ *
+ * Lock Status:	Protected via scsi_devicelist_mutex.
+ */
+int scsi_slave_attach(struct scsi_device *sdev)
+{
+	if (sdev->attached++ == 0) {
+		/*
+		 * No one was attached.
+		 */
+		scsi_build_commandblocks(sdev);
+		if (sdev->current_queue_depth == 0) {
+			printk(KERN_ERR "scsi: Allocation failure during"
+			       " attach, some SCSI devices might not be"
+			       " configured\n");
+			return 1;
+		}
+		if (sdev->host->hostt->slave_attach != NULL) {
+			if (sdev->host->hostt->slave_attach(sdev) != 0) {
+				printk(KERN_INFO "scsi: failed low level driver"
+				       " attach, some SCSI device might not be"
+				       " configured\n");
+				scsi_release_commandblocks(sdev);
+				return 1;
+			}
+		} else if (sdev->host->cmd_per_lun != 0)
+			scsi_adjust_queue_depth(sdev, 0,
+						sdev->host->cmd_per_lun);
+	}
+	return 0;
+}
+
+/*
+ * Function:	scsi_slave_detach()
+ *
+ * Purpose:	Called from the upper level driver attach to handle common
+ * 		detach code.
+ *
+ * Arguments:	sdev - struct scsi_device to detach
+ *
+ * Lock Status:	Protected via scsi_devicelist_mutex.
+ */
+void scsi_slave_detach(struct scsi_device *sdev)
+{
+	if (--sdev->attached == 0) {
+		if (sdev->host->hostt->slave_detach != NULL)
+			sdev->host->hostt->slave_detach(sdev);
+		scsi_release_commandblocks(sdev);
+	}
+}
+/*
  * This entry point should be called by a loadable module if it is trying
  * add a high level scsi driver to the system.
  */
@@ -2053,7 +2096,7 @@
 		for (SDpnt = shpnt->host_queue; SDpnt;
 		     SDpnt = SDpnt->next) {
 			if (tpnt->detect)
-				SDpnt->attached += (*tpnt->detect) (SDpnt);
+				(*tpnt->detect) (SDpnt);
 		}
 	}
 
@@ -2064,22 +2107,14 @@
 	     shpnt = scsi_host_get_next(shpnt)) {
 		for (SDpnt = shpnt->host_queue; SDpnt;
 		     SDpnt = SDpnt->next) {
-			scsi_build_commandblocks(SDpnt);
-			if (SDpnt->current_queue_depth == 0) {
-				out_of_space = 1;
-				continue;
-			}
 			if (tpnt->attach)
+				/*
+				 * XXX check result when the upper level
+				 * attach return values are fixed, and
+				 * stop attaching on failure.
+				 */
 				(*tpnt->attach) (SDpnt);
 
-			/*
-			 * If this driver attached to the device, and don't have any
-			 * command blocks for this device, allocate some.
-			 */
-			if (SDpnt->attached)
-				SDpnt->online = TRUE;
-			else
-				scsi_release_commandblocks(SDpnt);
 		}
 	}
 
@@ -2119,17 +2154,6 @@
 		     SDpnt = SDpnt->next) {
 			if (tpnt->detach)
 				(*tpnt->detach) (SDpnt);
-			if (SDpnt->attached == 0) {
-				SDpnt->online = FALSE;
-
-				/*
-				 * Nobody is using this device any more.  Free all of the
-				 * command structures.
-				 */
-				if (shpnt->hostt->slave_detach)
-					(*shpnt->hostt->slave_detach) (SDpnt);
-				scsi_release_commandblocks(SDpnt);
-			}
 		}
 	}
 	/*
===== drivers/scsi/scsi.h 1.33 vs edited =====
--- 1.33/drivers/scsi/scsi.h	Mon Nov  4 09:04:51 2002
+++ edited/drivers/scsi/scsi.h	Tue Nov  5 17:26:24 2002
@@ -466,6 +466,8 @@
 extern void scsi_release_commandblocks(Scsi_Device * SDpnt);
 extern void scsi_build_commandblocks(Scsi_Device * SDpnt);
 extern void scsi_adjust_queue_depth(Scsi_Device *, int, int);
+extern int scsi_slave_attach(struct scsi_device *sdev);
+extern void scsi_slave_detach(struct scsi_device *sdev);
 extern void scsi_done(Scsi_Cmnd * SCpnt);
 extern void scsi_finish_command(Scsi_Cmnd *);
 extern int scsi_retry_command(Scsi_Cmnd *);
===== drivers/scsi/scsi_mid_low_api.txt 1.4 vs edited =====
--- 1.4/drivers/scsi/scsi_mid_low_api.txt	Thu Oct 24 17:29:22 2002
+++ edited/drivers/scsi/scsi_mid_low_api.txt	Tue Nov  5 19:41:34 2002
@@ -352,33 +352,11 @@
  *      Locks: lock_kernel() active on entry and expected to be active
  *      on return.
  *
- *      Notes: Invoked from mid level's scsi_unregister_host(). When a
- *      host is being unregistered the mid level does not bother to
- *      call revoke() on the devices it controls.
+ *      Notes: Invoked from mid level's scsi_unregister_host().
  *      This function should call scsi_unregister(shp) [found in hosts.c]
  *      prior to returning.
  **/
     int release(struct Scsi_Host * shp);
-
-
-/**
- *      revoke - indicate disinterest in a scsi device
- *      @sdp: host template for this driver.
- *
- *      Return value ignored.
- *
- *      Required: no
- *
- *      Locks: none held
- *
- *      Notes: Called when "scsi remove-single-device <h> <b> <t> <l>"
- *      is written to /proc/scsi/scsi to indicate the device is no longer 
- *      required. It is called after the upper level drivers have detached 
- *      this device and before the device name  (e.g. /dev/sdc) is 
- *      unregistered and the resources associated with it are freed.
- **/
-    int revoke(Scsi_device * sdp);
-
 
 /**
  *      select_queue_depths - calculate allowable number of scsi commands
===== drivers/scsi/scsi_scan.c 1.32 vs edited =====
--- 1.32/drivers/scsi/scsi_scan.c	Sun Nov  3 10:48:33 2002
+++ edited/drivers/scsi/scsi_scan.c	Tue Nov  5 17:27:24 2002
@@ -1480,15 +1480,6 @@
 
 	scsi_detect_device(sdev);
 
-	if (sdev->host->hostt->slave_attach != NULL) {
-		if (sdev->host->hostt->slave_attach(sdev) != 0) {
-			printk(KERN_INFO "%s: scsi_add_lun: failed low level driver attach, setting device offline", devname);
-			sdev->online = FALSE;
-		}
-	} else if(sdev->host->cmd_per_lun) {
-		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
-	}
-
 	if (sdevnew != NULL)
 		*sdevnew = sdev;
 
===== drivers/scsi/scsi_syms.c 1.17 vs edited =====
--- 1.17/drivers/scsi/scsi_syms.c	Mon Nov  4 13:55:09 2002
+++ edited/drivers/scsi/scsi_syms.c	Wed Nov  6 11:25:04 2002
@@ -82,6 +82,8 @@
 
 EXPORT_SYMBOL(scsi_register_blocked_host);
 EXPORT_SYMBOL(scsi_deregister_blocked_host);
+EXPORT_SYMBOL(scsi_slave_attach);
+EXPORT_SYMBOL(scsi_slave_detach);
 
 /*
  * This symbol is for the highlevel drivers (e.g. sg) only.
===== drivers/scsi/sd.c 1.88 vs edited =====
--- 1.88/drivers/scsi/sd.c	Mon Nov  4 20:08:01 2002
+++ edited/drivers/scsi/sd.c	Tue Nov  5 17:29:12 2002
@@ -1212,9 +1212,12 @@
 	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
 			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
 
+	if (scsi_slave_attach(sdp))
+		goto out;
+
 	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);
 	if (!sdkp)
-		goto out;
+		goto out_detach;
 
 	gd = alloc_disk(16);
 	if (!gd)
@@ -1263,8 +1266,9 @@
 
 out_free:
 	kfree(sdkp);
+out_detach:
+	scsi_slave_detach(sdp);
 out:
-	sdp->attached--;
 	return 1;
 }
 
@@ -1312,7 +1316,7 @@
 
 	sd_devlist_remove(sdkp);
 	del_gendisk(sdkp->disk);
-	sdp->attached--;
+	scsi_slave_detach(sdp);
 	sd_nr_dev--;
 	put_disk(sdkp->disk);
 	kfree(sdkp);
===== drivers/scsi/sg.c 1.37 vs edited =====
--- 1.37/drivers/scsi/sg.c	Tue Nov  5 13:22:20 2002
+++ edited/drivers/scsi/sg.c	Tue Nov  5 17:30:41 2002
@@ -1396,6 +1396,8 @@
 
 	if (!disk)
 		return 1;
+	if (scsi_slave_attach(scsidp))
+		return 1;
 	write_lock_irqsave(&sg_dev_arr_lock, iflags);
 	if (sg_nr_dev >= sg_dev_max) {	/* try to resize */
 		Sg_device **tmp_da;
@@ -1405,10 +1407,10 @@
 		tmp_da = (Sg_device **)vmalloc(
 				tmp_dev_max * sizeof(Sg_device *));
 		if (NULL == tmp_da) {
-			scsidp->attached--;
 			printk(KERN_ERR
 			       "sg_attach: device array cannot be resized\n");
 			put_disk(disk);
+			scsi_slave_detach(scsidp);
 			return 1;
 		}
 		write_lock_irqsave(&sg_dev_arr_lock, iflags);
@@ -1425,7 +1427,6 @@
 		if (!sg_dev_arr[k])
 			break;
 	if (k > SG_MAX_DEVS_MASK) {
-		scsidp->attached--;
 		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 		printk(KERN_WARNING
 		       "Unable to attach sg device <%d, %d, %d, %d>"
@@ -1435,6 +1436,7 @@
 		if (NULL != sdp)
 			vfree((char *) sdp);
 		put_disk(disk);
+		scsi_slave_detach(scsidp);
 		return 1;
 	}
 	if (k < sg_dev_max) {
@@ -1448,10 +1450,10 @@
 	} else
 		sdp = NULL;
 	if (NULL == sdp) {
-		scsidp->attached--;
 		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 		printk(KERN_ERR "sg_attach: Sg_device cannot be allocated\n");
 		put_disk(disk);
+		scsi_slave_detach(scsidp);
 		return 1;
 	}
 
@@ -1559,7 +1561,7 @@
 			SCSI_LOG_TIMEOUT(3, printk("sg_detach: dev=%d\n", k));
 			sg_dev_arr[k] = NULL;
 		}
-		scsidp->attached--;
+		scsi_slave_detach(scsidp);
 		sg_nr_dev--;
 		sg_dev_noticed--;	/* from <dan@lectra.fr> */
 		break;
===== drivers/scsi/sr.c 1.63 vs edited =====
--- 1.63/drivers/scsi/sr.c	Mon Nov  4 20:08:08 2002
+++ edited/drivers/scsi/sr.c	Tue Nov  5 17:37:40 2002
@@ -506,6 +506,9 @@
 	if (sdev->type != TYPE_ROM && sdev->type != TYPE_WORM)
 		return 1;
 
+	if (scsi_slave_attach(sdev))
+		return 1;
+
 	cd = kmalloc(sizeof(*cd), GFP_KERNEL);
 	if (!cd)
 		goto fail;
@@ -574,7 +577,7 @@
 fail_free:
 	kfree(cd);
 fail:
-	sdev->attached--;
+	scsi_slave_detach(sdev);
 	return 1;
 }
 
@@ -807,7 +810,7 @@
 	put_disk(cd->disk);
 	unregister_cdrom(&cd->cdi);
 
-	SDp->attached--;
+	scsi_slave_detach(SDp);
 	sr_nr_dev--;
 
 	kfree(cd);
===== drivers/scsi/st.c 1.39 vs edited =====
--- 1.39/drivers/scsi/st.c	Mon Nov  4 20:04:52 2002
+++ edited/drivers/scsi/st.c	Tue Nov  5 17:36:00 2002
@@ -3667,6 +3667,9 @@
 		return 1;
 	}
 
+	if (scsi_slave_attach(SDp))
+		return 1;
+
 	i = SDp->host->sg_tablesize;
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
@@ -3692,11 +3695,11 @@
 		if (tmp_dev_max > ST_MAX_TAPES)
 			tmp_dev_max = ST_MAX_TAPES;
 		if (tmp_dev_max <= st_nr_dev) {
-			SDp->attached--;
 			write_unlock(&st_dev_arr_lock);
 			printk(KERN_ERR "st: Too many tape devices (max. %d).\n",
 			       ST_MAX_TAPES);
 			put_disk(disk);
+			scsi_slave_detach(SDp);
 			return 1;
 		}
 
@@ -3707,10 +3710,10 @@
 				kfree(tmp_da);
 			if (tmp_ba != NULL)
 				kfree(tmp_ba);
-			SDp->attached--;
 			write_unlock(&st_dev_arr_lock);
 			printk(KERN_ERR "st: Can't extend device array.\n");
 			put_disk(disk);
+			scsi_slave_detach(SDp);
 			return 1;
 		}
 
@@ -3733,10 +3736,10 @@
 
 	tpnt = kmalloc(sizeof(Scsi_Tape), GFP_ATOMIC);
 	if (tpnt == NULL) {
-		SDp->attached--;
 		write_unlock(&st_dev_arr_lock);
 		printk(KERN_ERR "st: Can't allocate device descriptor.\n");
 		put_disk(disk);
+		scsi_slave_detach(SDp);
 		return 1;
 	}
 	memset(tpnt, 0, sizeof(Scsi_Tape));
@@ -3906,7 +3909,7 @@
 				tpnt->de_n[mode] = NULL;
 			}
 			scsi_tapes[i] = 0;
-			SDp->attached--;
+			scsi_slave_detach(SDp);
 			st_nr_dev--;
 			write_unlock(&st_dev_arr_lock);
 
