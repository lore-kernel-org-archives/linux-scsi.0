From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: [PATCH] 2.4.19 scsi_rescan patch (2nd pass)
Date: Wed, 2 Oct 2002 07:52:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D24F@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmsmsxv040-1.fm.intel.com (fmsmsxvs040.fm.intel.com [132.233.42.124])
	by petasus.ch.intel.com (8.11.6/8.11.6/d: solo.mc,v 1.46 2002/09/23 20:41:22 dmccart Exp $) with SMTP id g92Es3t18874
	for <linux-scsi@vger.kernel.org>; Wed, 2 Oct 2002 14:54:03 GMT
Received: from FMSMSX016.fm.intel.com ([132.233.42.195])
 by fmsmsxv040-1.fm.intel.com (NAVGW 2.5.2.11) with SMTP id M2002100207530113268
 for <linux-scsi@vger.kernel.org>; Wed, 02 Oct 2002 07:53:01 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Folks,

Here is a 2nd pass at a patch to do a scsi rescan so that hot-inserted scsi
disks can automatically be recognized.  It includes some recommended
changes/cleanup from Patrick and Mike.

Andy Cress

---------------
--- linux-2.4.19-orig/drivers/scsi/hosts.h	Mon Feb 25 14:38:04 2002
+++ linux-2.4.19/drivers/scsi/hosts.h	Wed Oct  2 09:33:02 2002
@@ -418,6 +418,8 @@
      */
     unsigned some_device_starved:1;
    
+    unsigned init_done:1;
+    unsigned char need_scan; 
     void (*select_queue_depths)(struct Scsi_Host *, Scsi_Device *);
 
     /*
--- linux-2.4.19-orig/drivers/scsi/scsi.c	Fri Aug  2 20:39:44 2002
+++ linux-2.4.19/drivers/scsi/scsi.c	Wed Oct  2 09:33:02 2002
@@ -1980,8 +1980,10 @@
 			for (SDpnt = shpnt->host_queue; SDpnt; SDpnt =
SDpnt->next)
 				if (SDpnt->host->hostt == tpnt) {
 					for (sdtpnt = scsi_devicelist;
sdtpnt; sdtpnt = sdtpnt->next)
-						if (sdtpnt->attach)
+						if (sdtpnt->attach) {
 							(*sdtpnt->attach)
(SDpnt);
+							SDpnt->need_attach =
FALSE;
+						}
 					if (SDpnt->attached) {
 
scsi_build_commandblocks(SDpnt);
 						if (0 ==
SDpnt->has_cmdblocks)
@@ -2003,6 +2005,9 @@
 				(*sdtpnt->finish) ();
 			}
 		}
+		for (shpnt = scsi_hostlist; shpnt; shpnt = shpnt->next) {
+			shpnt->init_done = 1;
+		}
 	}
 #if defined(USE_STATIC_SCSI_MEMORY)
 	printk("SCSI memory: total %ldKb, used %ldKb, free %ldKb.\n",
@@ -2296,8 +2301,10 @@
 		     SDpnt = SDpnt->next) {
 			SDpnt->attached += SDpnt->detected;
 			SDpnt->detected = 0;
-			if (tpnt->attach)
+			if (tpnt->attach) {
 				(*tpnt->attach) (SDpnt);
+				SDpnt->need_attach = FALSE;
+			}
 			/*
 			 * If this driver attached to the device, and don't
have any
 			 * command blocks for this device, allocate some.
--- linux-2.4.19-orig/drivers/scsi/scsi.h	Fri Aug  2 20:39:44 2002
+++ linux-2.4.19/drivers/scsi/scsi.h	Wed Oct  2 09:33:02 2002
@@ -617,6 +617,7 @@
 	unsigned remap:1;	/* support remapping  */
 	unsigned starved:1;	/* unable to process commands because
 				   host busy */
+	unsigned need_attach:1; /* newly rescanned, need to attach device */
 
 	// Flag to allow revalidate to succeed in sd_open
 	int allow_revalidate;
--- linux-2.4.19-orig/drivers/scsi/scsi_lib.c	Fri Aug  2 20:39:44 2002
+++ linux-2.4.19/drivers/scsi/scsi_lib.c	Wed Oct  2 09:40:15 2002
@@ -5,6 +5,8 @@
  *      Initial versions: Eric Youngdale (eric@andante.org).
  *                        Based upon conversations with large numbers
  *                        of people at Linux Expo.
+ *      10/02/2002 - Andrew.R.Cress@intel.com, added scsi_rescan to
+ *                     automatically recognize hot-inserted disks
  */
 
 /*
@@ -819,6 +821,68 @@
 	return NULL;
 }
 
+void scsi_rescan(struct Scsi_Host *SHpnt, unsigned int channel)
+{
+	Scsi_Device *SDpnt;
+	struct Scsi_Device_Template *sdtpnt;
+	int out_of_space = 0;
+	int new_dev = 0;
+	int fdidattach;
+
+	/* 
+	 * Do scan_scsis here.  This generates the Scsi_Devices entries.
+	 * Since SHpnt->init_done, if devices already exist, skip them. 
+	 */
+	scan_scsis(SHpnt, 0, channel, 0, 0);
+
+	for (sdtpnt = scsi_devicelist; sdtpnt; sdtpnt = sdtpnt->next) {
+		if (sdtpnt->init && sdtpnt->dev_noticed)
+			(*sdtpnt->init) ();
+	}
+
+	/* Next we create the Scsi_Cmnd structures for new devices */
+	for (SDpnt = SHpnt->host_queue; SDpnt; SDpnt = SDpnt->next) {
+		fdidattach = 0;
+		if (SDpnt->host->host_no == SHpnt->host_no) {
+			for (sdtpnt = scsi_devicelist; sdtpnt; sdtpnt =
sdtpnt->next) {
+				/* 
+				 * attached can be set here for the new one,
+				 * so also check if queue_depth has been 
+				 * set to a normal value yet (> 2).
+				 */
+				if (SDpnt->need_attach && sdtpnt->attach) {
+					/*Note /dev/sd* maj=8, /dev/sg*
maj=21*/
+					(*sdtpnt->attach) (SDpnt);
+					fdidattach = 1;
+			  	} /*endif need_attach*/
+			} /*end sdtpnt loop*/
+			if (fdidattach) {
+			    fdidattach = 0;
+			    new_dev++;
+                	    if (SHpnt->select_queue_depths != NULL) {
+				(SHpnt->select_queue_depths) (SHpnt,
SHpnt->host_queue);
+			    }
+			    if (SDpnt->need_attach && SDpnt->attached) {
+				SDpnt->need_attach = FALSE;
+				scsi_build_commandblocks(SDpnt);
+				if (0 == SDpnt->has_cmdblocks)
+					out_of_space = 1;
+			    }
+			}
+		} /*endif match host_no */
+	}  /*end SDpnt loop*/
+
+	/* May have added some devices, so resize the DMA pool. */
+	if (new_dev > 0 && !out_of_space) scsi_resize_dma_pool();
+
+	for (sdtpnt = scsi_devicelist; sdtpnt; sdtpnt = sdtpnt->next) {
+		if (sdtpnt->finish && sdtpnt->nr_dev) 
+			(*sdtpnt->finish) (); 
+	}
+	printk("scsi_rescan: %d new devices added\n",new_dev);
+
+} /*end scsi_rescan*/
+
 /*
  * Function:    scsi_request_fn()
  *
@@ -919,6 +983,17 @@
 				spin_lock_irq(&io_request_lock);
 				continue;
 			}
+
+			if (!in_interrupt()) {
+			   /* Check if we need to rescan after a reset.
ARC*/
+			   if (SDpnt->host->need_scan == 1) {
+				SDpnt->host->need_scan = 2;
+				spin_unlock_irq(&io_request_lock);
+				scsi_rescan(SDpnt->host,SDpnt->channel);
+				spin_lock_irq(&io_request_lock);
+				SDpnt->host->need_scan = 0;
+			   }
+			}
 		}
 
 		/*
@@ -1176,6 +1251,11 @@
 			SDloop->was_reset = 1;
 			SDloop->expecting_cc_ua = 1;
 		}
+	}
+	if (SHpnt->init_done == 1 && SHpnt->need_scan == 0) {
+		SHpnt->need_scan = 1; 
+		printk("scsi_report_bus_reset: scsi%d, channel %d
need_scan\n",
+			SHpnt->host_no,channel);
 	}
 }
 
--- linux-2.4.19-orig/drivers/scsi/scsi_scan.c	Fri Aug  2 20:39:44 2002
+++ linux-2.4.19/drivers/scsi/scsi_scan.c	Wed Oct  2 09:33:02 2002
@@ -287,6 +287,28 @@
 }
 
 /*
+ * scsi_dev_skip
+ * Returns 1 if there was already a device on this host at the same
+ * channel/dev/lun, indicating that the caller should skip this one.
+ * Make sure to not match the new/temp device created for the scan 
+ * (sdnew).  sdpnt->attached is often already set here on the new 
+ * device(s), so we can't use that. 
+ */
+static int
+scsi_dev_skip(struct Scsi_Host *shpnt, uint channel, uint dev, uint lun,
+              Scsi_Device *sdnew)
+{
+	Scsi_Device *sdpnt;
+	for (sdpnt = shpnt->host_queue; sdpnt; sdpnt = sdpnt->next)
+		if (sdpnt != sdnew && (sdpnt->host == shpnt) &&  
+		    (sdpnt->id == dev) && (sdpnt->lun == lun) &&
+		    (sdpnt->channel == channel)) {
+			return 1;
+		}
+	return 0;
+}  /*end scsi_dev_skip*/
+
+/*
  *  Detecting SCSI devices :
  *  We scan all present host adapter's busses,  from ID 0 to ID (max_id).
  *  We use the INQUIRY command, determine device type, and pass the ID /
@@ -380,6 +402,8 @@
 		lun = hlun;
 		if (lun >= shpnt->max_lun)
 			goto leave;
+		if (shpnt->init_done && 
+		    scsi_dev_skip(shpnt,hchannel,hid,hlun,SDpnt)) goto
leave;
 		if ((0 == lun) || (lun > 7))
 			lun0_sl = SCSI_3; /* actually don't care for 0 ==
lun */
 		else
@@ -402,6 +426,7 @@
 			for (sdtpnt = scsi_devicelist; sdtpnt; sdtpnt =
sdtpnt->next) {
 				if (sdtpnt->attach) {
 					(*sdtpnt->attach) (oldSDpnt);
+					oldSDpnt->need_attach = FALSE;
 					if (oldSDpnt->attached) {
 
scsi_build_commandblocks(oldSDpnt);
 						if (0 ==
oldSDpnt->has_cmdblocks) {
@@ -445,6 +470,9 @@
 						/* don't probe further for
luns > 7 for targets <= SCSI_2 */
 						if ((lun0_sl < SCSI_3) &&
(lun > 7))
 							break;
+						if (shpnt->init_done &&
+
scsi_dev_skip(shpnt,channel,dev,lun, SDpnt)) 
+                                                	continue; /* ARC*/
 
 						if
(!scan_scsis_single(channel, order_dev, lun, lun0_sl,
 
&max_dev_lun, &sparse_lun, &SDpnt, shpnt,
@@ -528,6 +556,10 @@
 	extern devfs_handle_t scsi_devfs_handle;
 	int scsi_level;
 
+	if (SDpnt == NULL) {
+		printk("scan_scsis_single: SDpnt = NULL\n");
+		return 0;
+	}
 	SDpnt->host = shpnt;
 	SDpnt->id = dev;
 	SDpnt->lun = lun;
@@ -559,7 +591,8 @@
 	 * devices (and TEST_UNIT_READY to poll for media change). - Paul G.
 	 */
 
-	SCSI_LOG_SCAN_BUS(3, printk("scsi: performing INQUIRY\n"));
+	SCSI_LOG_SCAN_BUS(3, printk("scsi_scan: [%d:%d:%d:%d] performing
INQUIRY\n",
+				shpnt->host_no, channel, dev, lun));
 	/*
 	 * Build an INQUIRY command block.
 	 */
@@ -587,12 +620,19 @@
 	 * for media change conditions here, so cannot require zero result.
 	 */
 	if (SRpnt->sr_result) {
+		int attn_ok = 0;
 		if ((driver_byte(SRpnt->sr_result) & DRIVER_SENSE) != 0 &&
-		    (SRpnt->sr_sense_buffer[2] & 0xf) == UNIT_ATTENTION &&
-		    SRpnt->sr_sense_buffer[12] == 0x28 &&
+		    (SRpnt->sr_sense_buffer[2] & 0xf) == UNIT_ATTENTION) {
+		  if (SRpnt->sr_sense_buffer[12] == 0x28 &&
 		    SRpnt->sr_sense_buffer[13] == 0) {
 			/* not-ready to ready transition - good */
-		} else {
+			attn_ok = 1;
+		  } else if (SRpnt->sr_sense_buffer[12] == 0x29) {
+			/* 06/29/xx = reset occurred, but ok now - ARC */
+			attn_ok = 1;
+		  } 
+		}
+		if (!attn_ok) {
 			/* assume no peripheral if any other sort of error
*/
 			scsi_release_request(SRpnt);
 			return 0;
@@ -691,9 +731,12 @@
 
 	for (sdtpnt = scsi_devicelist; sdtpnt;
 	     sdtpnt = sdtpnt->next)
-		if (sdtpnt->detect)
+		if (sdtpnt->detect) {
 			SDpnt->attached +=
 			    (*sdtpnt->detect) (SDpnt);
+			/* did detect, but still need attach */
+			SDpnt->need_attach = TRUE;  
+		}
 
 	SDpnt->scsi_level = scsi_result[2] & 0x07;
 	if (SDpnt->scsi_level >= 2 ||
