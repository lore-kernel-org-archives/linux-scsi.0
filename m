From: Srihari Vijayaraghavan <harisri@internode.on.net>
Subject: Re: [linux-usb-devel] Fw: [BUG] USB Storage OOPS and a D state process in 2.6.10
Date: Mon, 10 Jan 2005 21:14:37 +1100
Message-ID: <200501102114.37744.harisri@internode.on.net>
References: <Pine.LNX.4.44L0.0501091225010.19950-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NWl4BJD4ced36B9"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.adl2.internode.on.net ([203.16.214.181]:53006 "EHLO
	smtp1.adl2.internode.on.net") by vger.kernel.org with ESMTP
	id S262191AbVAJKIY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 05:08:24 -0500
In-Reply-To: <Pine.LNX.4.44L0.0501091225010.19950-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

--Boundary-00=_NWl4BJD4ced36B9
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 10 January 2005 04:32, Alan Stern wrote:
> If you're unable to trigger the bug, you can try turning the debug
> configuration option back off and using that patch I sent earlier.  It
> wouldn't hurt to use that patch even with the debugging messages...

I have disabled the USB storage debug option. Your patch unfortunately did not 
apply cleanly, so I did it manually, and here is the correct patch:
--- test/drivers/usb/storage/scsiglue.c.orig 2005-01-10 18:31:36.453932344 
+1100
+++ test/drivers/usb/storage/scsiglue.c 2005-01-10 18:37:57.329030528 +1100
@@ -268,9 +268,15 @@
 /* This is always called with scsi_lock(srb->host) held */
 static int bus_reset(struct scsi_cmnd *srb)
 {
- struct us_data *us = (struct us_data *)srb->device->host->hostdata[0];
+ struct us_data *us;
  int result, rc;
 
+ printk(KERN_INFO "In bus_reset, srb: %p\n", srb);
+ printk("  device: %p\n", srb->device);
+ printk("  host: %p\n", srb->device->host);
+ printk("  hostdata: %p\n", (void *) srb->device->host->hostdata[0]);
+
+ us = (struct us_data *)srb->device->host->hostdata[0];
  US_DEBUGP("%s called\n", __FUNCTION__);
 
  scsi_unlock(srb->device->host);


I am unable to trigger the bug, despite my sincere efforts. But I have managed 
to push "hald" process in to D state.
Jan 10 21:06:41 desktop kernel: hald          D 000001003776d938     0  3367      
1          3429  3357 (NOTLB)
Jan 10 21:06:41 desktop kernel: 000001003776d898 0000000000000002 
000000732b17d078 000001003f771650
Jan 10 21:06:41 desktop kernel:        00000000000007fd 000001003fed2070 
0000010037d71640 0000010038e3d000
Jan 10 21:06:41 desktop kernel:        000001002b17d078 000001003776d938
Jan 10 21:06:41 desktop kernel: Call 
Trace:<ffffffff802c11eb>{wait_for_completion+139} 
<ffffffff8012dc20>{default_wake_function+0}
Jan 10 21:06:41 desktop kernel:        
<ffffffff8012dc20>{default_wake_function+0} 
<ffffffffa0004f7b>{:scsi_mod:scsi_wait_req+91}
Jan 10 21:06:41 desktop kernel:        
<ffffffffa0000038>{:scsi_mod:scsi_allocate_request+56}
Jan 10 21:06:41 desktop kernel:        
<ffffffffa023a33c>{:sr_mod:sr_do_ioctl+156} 
<ffffffffa023a654>{:sr_mod:sr_audio_ioctl+372}
Jan 10 21:06:41 desktop kernel:        
<ffffffffa0004fac>{:scsi_mod:scsi_wait_req+140} 
<ffffffff8023f71e>{cdrom_count_tracks+222}
Jan 10 21:06:41 desktop kernel:        <ffffffff8023f9a0>{cdrom_open+448} 
<ffffffffa00471f4>{:ext3:ext3_get_block_handle+228}
Jan 10 21:06:41 desktop kernel:        <ffffffff8014ef4e>{find_get_page+14} 
<ffffffff8016ce4c>{__find_get_block_slow+220}
Jan 10 21:06:41 desktop kernel:        
<ffffffff8016d519>{__find_get_block+377} <ffffffff8016f87f>{__getblk+31}
Jan 10 21:06:41 desktop kernel:        <ffffffff801af4ba>{avc_has_perm+90} 
<ffffffff801af4ba>{avc_has_perm+90}
Jan 10 21:06:41 desktop kernel:        <ffffffff801af4ba>{avc_has_perm+90} 
<ffffffff801b02b4>{task_has_capability+100}
Jan 10 21:06:41 desktop kernel:        <ffffffff801c2992>{kobject_get+18} 
<ffffffff801c2992>{kobject_get+18}
Jan 10 21:06:41 desktop kernel:        
<ffffffffa0239730>{:sr_mod:sr_block_open+176} <ffffffff8017286a>{do_open+170}
Jan 10 21:06:41 desktop kernel:        <ffffffff80172c5f>{blkdev_open+47} 
<ffffffff8016aa36>{dentry_open+230}
Jan 10 21:06:41 desktop kernel:        <ffffffff8016ab7e>{filp_open+62} 
<ffffffff8016abc7>{get_unused_fd+55}
Jan 10 21:06:41 desktop kernel:        <ffffffff8016ad4c>{sys_open+76} 
<ffffffff8010e1da>{system_call+126}
Jan 10 21:06:41 desktop kernel:


Please refer to the attachment for the complete kernel log.

I think I understand the problem (conceptually I guess):
1. Connect the USB DVD-RW drive
2. USB Storage says: "usb-storage: device found at nnn" and "usb-storage: 
waiting for device to settle before scanning"
3. And then it waits for 5+ seconds
4. Then it initialises the peripheral and then says: "Vendor: PIONEER   Model: 
DVD-RW  DVR-107D  Rev: 1.13 ..." and "usb-storage: device scan complete"

I think if I unplug the device precisely the same moment when it initialises 
(step 4), and by time that routine completes kernel is really unhappy (D 
state process,  Badness in scsi_device_set_state at 
drivers/scsi/scsi_lib.c:1717, and/or oops) to discover that the drive is not 
there anymore :-).

I do not know what else to do.

Thank you.
Hari

--Boundary-00=_NWl4BJD4ced36B9
Content-Type: application/x-bzip2;
  name="kernel.log.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="kernel.log.bz2"

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

--Boundary-00=_NWl4BJD4ced36B9--
