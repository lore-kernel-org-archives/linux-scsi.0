From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] [UPDATE 4] ieee1394/sbp2: fix for hot-unplug
Date: Thu, 18 Aug 2005 02:01:10 +0200
Message-ID: <4303CFC6.5000904@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:26089 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751374AbVHRAER (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2005 20:04:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

I wrote to linux1394-devel@lists.sourceforge.net:
> 4th update: some more paranoia in sbp2scsi_queuecommand
(The rest of that posting is here: 
http://www.linux1394.org/pipermail/svn-commits/2005-August/000411.html )

I can't believe it. I connected a FireWire CD-ROM, it was detected as 
such by scsi's inquiry, sr_mod issued Test Unit Ready and Mode Sense 
which were failing and aborted for unknown reason. While the commands 
and aborts were repeated, I ran "modprobe -r sbp2" which hung in D state 
at scsi_wait_req.

I guess sr_mod can't shut down before it did not fully finish whatever 
it is trying to do when a CD-ROM was added.

> Aug 18 01:05:45 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 device
> Aug 18 01:05:45 shuttle kernel: ieee1394: Node 1-01:1023: Max speed [S400] - Max payload [2048]
> Aug 18 01:05:50 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Aug 18 01:05:50 shuttle kernel: scsi26 : destination target 0, lun 0
> Aug 18 01:05:50 shuttle kernel:         command: Inquiry: 12 00 00 00 24 00
> Aug 18 01:05:56 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Aug 18 01:05:56 shuttle kernel: scsi26 : destination target 0, lun 0
> Aug 18 01:05:56 shuttle kernel:         command: Inquiry: 12 00 00 00 60 00
> Aug 18 01:05:56 shuttle kernel:   Vendor: PLEXTOR   Model: DVDR   PX-716A    Rev: 1.08
> Aug 18 01:05:56 shuttle kernel:   Type:   CD-ROM                             ANSI SCSI revision: 02
> Aug 18 01:05:56 shuttle scsi.agent: cdrom at /devices/pci0000:00/0000:00:0c.0/fw-host1/0030e005003b00c8/0030e005003b00c8-0/host26/target26:0:0/26:0:0:0
> Aug 18 01:06:26 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Aug 18 01:06:26 shuttle kernel: scsi26 : destination target 0, lun 0
> Aug 18 01:06:26 shuttle kernel:         command: Test Unit Ready: 00 00 00 00 00 00
> Aug 18 01:06:56 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Aug 18 01:06:56 shuttle kernel: scsi26 : destination target 0, lun 0
> Aug 18 01:06:56 shuttle kernel:         command: Mode Sense (10): 5a 00 2a 00 00 00 00 00 80 00
> Aug 18 01:07:26 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Aug 18 01:07:26 shuttle kernel: scsi26 : destination target 0, lun 0
> Aug 18 01:07:26 shuttle kernel:         command: Mode Sense (10): 5a 00 2a 00 00 00 00 00 80 00
> Aug 18 01:07:36 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Aug 18 01:07:36 shuttle kernel: scsi26 : destination target 0, lun 0
> Aug 18 01:07:36 shuttle kernel:         command: Test Unit Ready: 00 00 00 00 00 00
> Aug 18 01:07:36 shuttle kernel: ieee1394: sbp2: reset requested
> Aug 18 01:07:36 shuttle kernel: ieee1394: sbp2: Generating sbp2 fetch agent reset
> Aug 18 01:07:46 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Aug 18 01:07:46 shuttle kernel: scsi26 : destination target 0, lun 0
> Aug 18 01:07:46 shuttle kernel:         command: Test Unit Ready: 00 00 00 00 00 00
> Aug 18 01:07:46 shuttle kernel: ieee1394: sbp2: reset requested
> Aug 18 01:07:46 shuttle kernel: ieee1394: sbp2: Generating sbp2 fetch agent reset

Roughly at this point I ran "modprobe -r sbp2", which hung at scsi_wait_req.

> Aug 18 01:08:06 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Aug 18 01:08:06 shuttle kernel: scsi26 : destination target 0, lun 0
> Aug 18 01:08:06 shuttle kernel:         command: Test Unit Ready: 00 00 00 00 00 00
> Aug 18 01:08:06 shuttle kernel: ieee1394: sbp2: reset requested
> Aug 18 01:08:06 shuttle kernel: ieee1394: sbp2: Generating sbp2 fetch agent reset
> Aug 18 01:08:26 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Aug 18 01:08:26 shuttle kernel: scsi26 : destination target 0, lun 0
> Aug 18 01:08:26 shuttle kernel:         command: Test Unit Ready: 00 00 00 00 00 00
> Aug 18 01:08:26 shuttle kernel: scsi: Device offlined - not ready after error recovery: host 26 channel 0 id 0 lun 0
> Aug 18 01:08:56 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Aug 18 01:08:56 shuttle kernel: scsi26 : destination target 0, lun 0
> Aug 18 01:08:56 shuttle kernel:         command: Mode Sense (10): 5a 00 2a 00 00 00 00 00 80 00
> Aug 18 01:08:59 shuttle kernel: ieee1394: Node changed: 1-02:1023 -> 1-01:1023
> Aug 18 01:08:59 shuttle kernel: ieee1394: Node suspended: ID:BUS[1-01:1023]  GUID[0030e005003b00c8]

Here I physically unplugged the CD-ROM.

> Aug 18 01:09:06 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Aug 18 01:09:06 shuttle kernel: scsi26 : destination target 0, lun 0
> Aug 18 01:09:06 shuttle kernel:         command: Test Unit Ready: 00 00 00 00 00 00
> Aug 18 01:09:06 shuttle kernel: ieee1394: sbp2: hpsb_node_write failed.
> Aug 18 01:09:06 shuttle kernel:
> Aug 18 01:09:06 shuttle kernel: ieee1394: sbp2: reset requested
> Aug 18 01:09:06 shuttle kernel: ieee1394: sbp2: Generating sbp2 fetch agent reset
> Aug 18 01:09:06 shuttle kernel: ieee1394: sbp2: hpsb_node_write failed.

Well, here is a flaw in sbp2's eh_device_reset_handler. It is not 
necessary to try to reset a node which isn't there anymore. But this is 
of course not related to the deadlock.

> Aug 18 01:09:06 shuttle kernel:
> Aug 18 01:09:16 shuttle kernel: ieee1394: sbp2: reset requested
> Aug 18 01:09:16 shuttle kernel: ieee1394: sbp2: Generating sbp2 fetch agent reset
> Aug 18 01:09:16 shuttle kernel: ieee1394: sbp2: hpsb_node_write failed.
> Aug 18 01:09:16 shuttle kernel:
> Aug 18 01:09:26 shuttle kernel: scsi: Device offlined - not ready after error recovery: host 26 channel 0 id 0 lun 0
> Aug 18 01:09:26 shuttle kernel: sr0: scsi3-mmc drive: 0x/0x caddy
> Aug 18 01:09:26 shuttle kernel: Attached scsi CD-ROM sr0 at scsi26, channel 0, id 0, lun 0

Device 26,0,0,0 offlined - Attached scsi CD-ROM at 26,0,0,0. WTF?

The "modprobe -r sbp2" from a minute ago still hangs at this point. In 
fact it will keep hanging until I will reboot.

Who knows how many more different kinds of deadlocks during LLD removal 
or device removal might be possible. It's frustrating.
-- 
Stefan Richter
-=====-=-=-= =--- =--=-
http://arcgraph.de/sr/
