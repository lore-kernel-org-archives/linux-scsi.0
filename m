From: Chuck Ebbert <76306.1226@compuserve.com>
Subject: [Patch 2.6] sd.c spinup messages
Date: Wed, 9 Jun 2004 19:48:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200406091950_MC3-1-8463-F129@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain;
	 charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from siaag2ac.compuserve.com ([149.174.40.133]:54217 "EHLO
	siaag2ac.compuserve.com") by vger.kernel.org with ESMTP
	id S266195AbUFIXvb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2004 19:51:31 -0400
Received: (from mailgate@localhost)
	by siaag2ac.compuserve.com (8.12.11/8.12.7/SUN-2.15) id i59NpVPv012215
	for linux-scsi@vger.kernel.org; Wed, 9 Jun 2004 19:51:31 -0400 (EDT)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

With an empty Iomega USB Powered Zip 250 drive and kernel 2.6.6,
I get this in the syslog on bootup:

Jun  9 14:38:42 d2 kernel: usb 1-1: new full speed USB device using address 2
Jun  9 14:38:42 d2 kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Jun  9 14:38:42 d2 kernel:   Vendor: IOMEGA    Model: ZIP 250           Rev: 61.T
Jun  9 14:38:42 d2 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Jun  9 14:38:42 d2 kernel: sda: Spinning up disk....<6>EXT3 FS on hde3, internal journal
Jun  9 14:38:42 d2 kernel: Adding 524152k swap on /dev/hdg2.  Priority:-1 extents:1
Jun  9 14:38:42 d2 kernel: Adding 524152k swap on /dev/hde2.  Priority:-2 extents:1
Jun  9 14:38:42 d2 kernel: .<5>Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Jun  9 14:38:42 d2 kernel: Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
Jun  9 14:38:42 d2 kernel: kjournald starting.  Commit interval 5 seconds

Code in sd.c:sd_spinup_disk is looping and calling printk(".") while
waiting for the disk to spin up.  Then it detects media not present
and the function just exits, leaving an incomplete line in the buffer.
Meanwhile other messages get mixed in.

I fixed it so it prints only whole-line messages and emits a
media-not-present message if it printed a spinup message earlier:

Jun  9 16:42:06 d2 kernel: usb 1-1: new full speed USB device using address 2
Jun  9 16:42:06 d2 kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Jun  9 16:42:06 d2 kernel:   Vendor: IOMEGA    Model: ZIP 250           Rev: 61.T
Jun  9 16:42:06 d2 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Jun  9 16:42:06 d2 kernel: sda: Spinning up disk...
Jun  9 16:42:06 d2 kernel: EXT3 FS on hde3, internal journal
Jun  9 16:42:06 d2 kernel: Adding 524152k swap on /dev/hdg2.  Priority:-1 extents:1
Jun  9 16:42:06 d2 kernel: Adding 524152k swap on /dev/hde2.  Priority:-2 extents:1
Jun  9 16:42:06 d2 kernel: sda: No media present
Jun  9 16:42:06 d2 kernel: Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Jun  9 16:42:06 d2 kernel: Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0
Jun  9 16:42:06 d2 kernel: kjournald starting.  Commit interval 5 seconds

And with media present:

Jun  9 17:52:46 d2 kernel: usb 1-1: new full speed USB device using address 2
Jun  9 17:52:46 d2 kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Jun  9 17:52:46 d2 kernel:   Vendor: IOMEGA    Model: ZIP 250           Rev: 61.T
Jun  9 17:52:46 d2 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Jun  9 17:52:46 d2 kernel: sda: Spinning up disk...
Jun  9 17:52:46 d2 kernel: EXT3 FS on hde3, internal journal
Jun  9 17:52:46 d2 kernel: Adding 524152k swap on /dev/hdg2.  Priority:-1 extents:1
Jun  9 17:52:46 d2 kernel: Adding 524152k swap on /dev/hde2.  Priority:-2 extents:1
Jun  9 17:52:46 d2 kernel: kjournald starting.  Commit interval 5 seconds
((( Snip 15 lines of ext3 mount messages )))
Jun  9 17:52:46 d2 kernel: sda: Drive ready
Jun  9 17:52:46 d2 kernel: SCSI device sda: 196608 512-byte hdwr sectors (101 MB)
Jun  9 17:52:46 d2 kernel: sda: assuming Write Enabled
Jun  9 17:52:46 d2 kernel: sda: assuming drive cache: write through
Jun  9 17:52:46 d2 kernel:  sda: sda4
Jun  9 17:52:46 d2 kernel: Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Jun  9 17:52:46 d2 kernel: Attached scsi generic sg1 at scsi1, channel 0, id 0, lun 0,  type 0

Patch:

--- 266.0/drivers/scsi/sd.c     2004-06-09 15:26:49.000000000 -0400
+++ 266.1/drivers/scsi/sd.c     2004-06-09 16:37:21.000000000 -0400
@@ -847,8 +847,11 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
                 * any media in it, don't bother with any of the rest of
                 * this crap.
                 */
-               if (media_not_present(sdkp, SRpnt))
+               if (media_not_present(sdkp, SRpnt)) {
+                       if (spintime)
+                               printk(KERN_NOTICE "%s: No media present\n", diskname);
                        return;
+               }
 
                if ((driver_byte(the_result) & DRIVER_SENSE) == 0) {
                        /* no sense, TUR either succeeded or failed
@@ -880,7 +883,7 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
                } else if (SRpnt->sr_sense_buffer[2] == NOT_READY) {
                        unsigned long time1;
                        if (!spintime) {
-                               printk(KERN_NOTICE "%s: Spinning up disk...",
+                               printk(KERN_NOTICE "%s: Spinning up disk...\n",
                                       diskname);
                                cmd[0] = START_STOP;
                                cmd[1] = 1;     /* Return immediately */
@@ -903,7 +906,6 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
                                current->state = TASK_UNINTERRUPTIBLE;
                                time1 = schedule_timeout(time1);
                        } while(time1);
-                       printk(".");
                } else {
                        /* we don't understand the sense code, so it's
                         * probably pointless to loop */
@@ -917,12 +919,10 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
        } while (spintime &&
                 time_after(spintime_value + 100 * HZ, jiffies));
 
-       if (spintime) {
-               if (scsi_status_is_good(the_result))
-                       printk("ready\n");
-               else
-                       printk("not responding...\n");
-       }
+       if (spintime)
+               printk(KERN_NOTICE "%s: Drive %s\n", diskname,
+                      scsi_status_is_good(the_result) ? "ready" : "not responding!");
+
 }
 
 /*

