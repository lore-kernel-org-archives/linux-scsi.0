From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: [PATCH]: HotSwap SCSI in Soft RAID1 (scsi_rescan)
Date: Fri, 20 Sep 2002 10:17:03 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A66470580D1EC@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-raid@vger.kernel.org, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: 'Mads Peter Bach' <mpb@hum.auc.dk>, Jens Arnfelt <jens.arnfelt@ab-innovation.dk>


Since RAID1 is the target environment I've been working on, and it has come
up in the thread below, this seems like a good time to post a patch that
I've been working on to handle SCSI hot-insertion.  I've cross-posted this
to both -raid and -scsi lists because there are common interests in this
case.  

I've been working with kernel 2.4.18 mostly, but I'll post patches for
2.4.19 and 2.5.36 soon.  See http://scsirastools.sourceforge.net/ for more
details.

The premise I had was that this should take place automatically when a scsi
device is hot-inserted, rather than requiring intervention and knowledge
from the sys admin.  In short, it should work more like a hardware RAID
solution would.  The implementation leverages the scan_scsis() routine, just
like at start of day, but not messing with existing devices.  The hardest
part was finding the best place to call the new scsi_rescan function.  Right
now I'm calling it if a reset occurs, but some have said that a UA should
also trigger a rescan, since many disk cabinets do not generate a reset when
hot-insertion happens, and I'd like to do this if I could find the right
context to call it from.  Any suggestions are welcome.  

Note that this patch has references to an 'EPRINTK' macro, which is in a
separate patch, and it maps printk for POSIX event logging, if present.
Please just "sed -e 's/EPRINTK/printk/'" if you don't care about POSIX event
logging.  

My testing has been on ia32 systems with internal SAF-TE backplanes and
systems with external hotplug disk cabinets.  

Andy Cress

-----Original Message-----
From: Mads Peter Bach [mailto:mpb@hum.auc.dk] 
Sent: Friday, September 20, 2002 9:04 AM
Subject: Re: System halt when re-inserting a HotSwap SCSI in Soft RAID1

Jens Arnfelt wrote:
> Hi There!
>
> I have two scsi disk with idendical partitiontables (see below) 
> installed on a SCA HotSwap enable Fujitsu-Siemens server.
>
> As a test I've removed one of the disks and the /dev/md0 went in 
> degraded mode as expected. (se snip from /var/log/messages below)
[snip]

> The real problems start when I re-insert the /dev/sda.
> The systems stops all activity on HD after some errore in the 
> /var/log/messages and a hard reset is only option.

This isn't a soft raid problem, it's a SCSI layer issue:
(from the HOWTO)
[...]

Regards,
Mads Bach

******* PATCH (to lk 2.4.18) ***************
--- linux-2.4.18-orig/drivers/scsi/hosts.h	Mon Feb 25 14:38:04 2002
+++ linux-2.4.18/drivers/scsi/hosts.h	Thu Aug 29 09:23:59 2002
@@ -418,6 +418,8 @@
      */
     unsigned some_device_starved:1;
    
+    unsigned init_done:1;
+    unsigned char need_scan; 
     void (*select_queue_depths)(struct Scsi_Host *, Scsi_Device *);
 
     /*
--- linux-2.4.18-orig/drivers/scsi/scsi.c	Wed Aug 28 20:38:13 2002
+++ linux-2.4.18/drivers/scsi/scsi.c	Thu Aug 29 08:08:57 2002
@@ -1999,6 +1999,9 @@
 				(*sdtpnt->finish) ();
 			}
 		}
+		for (shpnt = scsi_hostlist; shpnt; shpnt = shpnt->next) {
+			shpnt->init_done = 1;
+		}
 	}
 #if defined(USE_STATIC_SCSI_MEMORY)
 	EPRINTK("SCSI memory: total %ldKb, used %ldKb, free %ldKb.\n",
--- linux-2.4.18-orig/drivers/scsi/scsi_lib.c	Wed Aug 28 20:38:13 2002
+++ linux-2.4.18/drivers/scsi/scsi_lib.c	Thu Aug 29 09:55:45 2002
@@ -822,6 +822,73 @@
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
+				if (SDpnt->attached && SDpnt->queue_depth >
2) {
+				  ;  /* already attached, do nothing */
+				} else {
+				  if (sdtpnt->attach) {
+				     /* Note /dev/sd* maj=8, /dev/sg* maj=21
*/
+				     EPRINTK("Attaching scsi%d:%d:%d:%d to
maj %d\n",
+					SDpnt->host->host_no,SDpnt->channel,
+					SDpnt->id,
SDpnt->lun,sdtpnt->major);
+					(*sdtpnt->attach) (SDpnt);
+					fdidattach = 1;
+				  }
+				  if (SDpnt->attached) {
+					scsi_build_commandblocks(SDpnt);
+					if (0 == SDpnt->has_cmdblocks)
+						out_of_space = 1;
+				  }
+			  	} /*end-else*/
+			} /*end-for*/
+		}
+		if (fdidattach) {
+		   new_dev++;
+                   if (SHpnt->select_queue_depths != NULL) {
+                             (SHpnt->select_queue_depths) (SHpnt,
SHpnt->host_queue);
+                             }
+		}
+	}
+
+	/* May have added some devices, so resize the DMA pool. */
+	if (new_dev > 0 && !out_of_space) scsi_resize_dma_pool();
+
+	for (sdtpnt = scsi_devicelist; sdtpnt; sdtpnt = sdtpnt->next) {
+		if (sdtpnt->finish && sdtpnt->nr_dev) 
+			(*sdtpnt->finish) (); 
+	}
+	EPRINTK("scsi_rescan: %d new devices added\n",new_dev);
+
+} /*end scsi_rescan*/
+
 /*
  * Function:    scsi_request_fn()
  *
@@ -922,6 +989,17 @@
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
@@ -1174,14 +1252,27 @@
 void scsi_report_bus_reset(struct Scsi_Host * SHpnt, int channel)
 {
 	Scsi_Device *SDloop;
+
 	for (SDloop = SHpnt->host_queue; SDloop; SDloop = SDloop->next) {
 		if (channel == SDloop->channel) {
+			/*
+			 * Sometimes we get here repeatedly, so only
+			 * increment the tally if this is the start
+			 * of a reset.
+			 */
+			if (SDloop->was_reset == 0) SDloop->sdev_resets++;
 			SDloop->was_reset = 1;
 			SDloop->expecting_cc_ua = 1;
-			SDloop->sdev_resets++;
 		}
 	}
-}
+
+	if (SHpnt->init_done == 1 &&
+	    SHpnt->need_scan == 0) {
+		SHpnt->need_scan = 1; /* ARC*/
+		EPRINTK("scsi_report_bus_reset: scsi%d, channel %d
need_scan\n",
+			SHpnt->host_no,channel); /* ARC*/
+	}
+} /*end scsi_report_bus_reset*/
 
 /*
  * FIXME(eric) - these are empty stubs for the moment.  I need to
re-implement
--- linux-2.4.18-orig/drivers/scsi/scsi_scan.c	Wed Aug 28 20:38:13 2002
+++ linux-2.4.18/drivers/scsi/scsi_scan.c	Thu Aug 29 12:43:24 2002
@@ -216,7 +216,7 @@
 		if (data[i] >= 0x20 && i < data[4] + 5)
 			pbuf[n++] = data[i];
 		else
-			pbuf[n++] = " ";
+			pbuf[n++] = ' ';
 	}
 	pbuf[n] = 0;
 
@@ -226,7 +226,7 @@
 		if (data[i] >= 0x20 && i < data[4] + 5)
 			pbuf[n++] = data[i];
 		else
-			pbuf[n++] = " ";
+			pbuf[n++] = ' ';
 	}
 	pbuf[n] = 0;
 
@@ -236,7 +236,7 @@
 		if (data[i] >= 0x20 && i < data[4] + 5)
 			pbuf[n++] = data[i];
 		else
-			pbuf[n++] = " ";
+			pbuf[n++] = ' ';
 	}
 	pbuf[n] = 0;
 
@@ -247,7 +247,7 @@
                 if (data[i] >= 0x20 && i < data[4] + 5)
 			pbuf[n++] = data[i];
 		else
-			pbuf[n++] = " ";
+			pbuf[n++] = ' ';
            }
 	   pbuf[n] = 0;
         }
@@ -290,6 +290,43 @@
 }
 
 /*
+ * scsi_dev_skip
+ * Returns 1 if there was already a device on this host at the same
+ * channel/dev/lun, indicating that the caller should skip this one.
+ */
+static int
+scsi_dev_skip(struct Scsi_Host *shpnt, uint channel, uint dev, uint lun, 
+	      Scsi_Device *sdnew) 
+{
+	Scsi_Device *sdpnt; 
+	int fmatch = 0;
+	int ret = 0;
+	for (sdpnt = shpnt->host_queue; sdpnt; sdpnt = sdpnt->next)
+	{
+		fmatch = 0;
+		if (sdpnt->host == shpnt && 
+		    sdpnt->channel == channel &&
+		    sdpnt->id == dev) {
+			/* 
+			 * Skip if it was already in the host_queue, as 
+			 * long as this one isn't the sdnew temporary 
+			 * device.
+			 * sdpnt->attached is often already set here.
+			 * We might check sdpnt->single_lun, but the
+			 * scan loop will continue anyway.
+			 */
+			if ((sdpnt != sdnew) && (sdpnt->lun == lun)) {
+			   fmatch = 1;
+			   ret = 1;
+			   /* already exists, skip it */
+			   break;
+			   }
+		} 
+	}  /*end for*/
+	return(ret);
+}  /*end scsi_dev_skip*/
+
+/*
  *  Detecting SCSI devices :
  *  We scan all present host adapter's busses,  from ID 0 to ID (max_id).
  *  We use the INQUIRY command, determine device type, and pass the ID /
@@ -383,6 +420,8 @@
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
@@ -448,6 +487,9 @@
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
@@ -526,6 +568,10 @@
 	extern devfs_handle_t scsi_devfs_handle;
 	int scsi_level;
 
+	if (SDpnt == NULL) {
+		EPRINTK("scan_scsis_single: SDpnt = NULL\n");
+		return 0;
+	}
 	SDpnt->host = shpnt;
 	SDpnt->id = dev;
 	SDpnt->lun = lun;
@@ -557,7 +603,8 @@
 	 * devices (and TEST_UNIT_READY to poll for media change). - Paul G.
 	 */
 
-	SCSI_LOG_SCAN_BUS(3, EPRINTK("scsi: performing INQUIRY\n"));
+	SCSI_LOG_SCAN_BUS(3, EPRINTK("scsi_scan: [%d:%d:%d:%d] performing
INQUIRY\n",
+				shpnt->host_no,channel,dev,lun));
 	/*
 	 * Build an INQUIRY command block.
 	 */
@@ -577,7 +624,7 @@
 	          (void *) scsi_result,
 	          256, SCSI_TIMEOUT+4*HZ, 3);
 
-	SCSI_LOG_SCAN_BUS(3, EPRINTK("scsi: INQUIRY %s with code 0x%x\n",
+	SCSI_LOG_SCAN_BUS(3, EPRINTK("scsi_scan: INQUIRY %s with code
0x%x\n",
 		SRpnt->sr_result ? "failed" : "successful",
SRpnt->sr_result));
 
 	/*
@@ -585,12 +632,19 @@
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
