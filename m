From: "Jeroen T. Vermeulen" <jtv@xs4all.nl>
Subject: Firewire CD burner not recognized as scsi
Date: Thu, 11 Mar 2004 01:16:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040311001657.GB30941@xs4all.nl>
References: <20040224012000.GA77197@xs4all.nl> <20040226212840.GA3224@tpkurt.garloff.de> <20040226231728.GO43550@xs4all.nl> <20040227082116.GA3218@tpkurt.garloff.de> <20040227145847.GQ43550@xs4all.nl> <20040227154454.GM3156@tpkurt.garloff.de> <20040227165847.GX43550@xs4all.nl> <20040227191956.GW3156@tpkurt.garloff.de> <20040310233412.GA30941@xs4all.nl> <20040310233855.GA5469@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out1.xs4all.nl ([194.109.24.11]:5894 "EHLO
	smtp-out1.xs4all.nl") by vger.kernel.org with ESMTP id S262902AbUCKARB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 19:17:01 -0500
Content-Disposition: inline
In-Reply-To: <20040310233855.GA5469@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kurt Garloff <kurt@garloff.de>

(Note: I'm not on this list, but I was asked to post the problem here.)

I'm running a 2.6-benh kernel on a first-generation PowerBook G4, using
Debian unstable.  My FireWire CD burner, which works just fine on a 2.4
kernel with devfs, is no longer recognized as a SCSI device.  As an ieee1394
device it seems to be recognized just fine--so it does show up as expected
in /sys/bus/ieee1394/devices but not in /sys/bus/scsi/devices for instance.
And gwscanbus identifies it correctly and promptly.

scsi-bus.sh does find the sbp2 "host adapter," but neither devfs nor
udev sees it (or anything scsi-related unless I plug in my USB memory
stick).

Here's what I tried, in all combinations I could think of:

 - load modules ieee1394, ohci1394, raw1394, sbp2, scsi_mod, sg, and 
   everything else but the kitchen sink by hand
 - cdrecord -scanbus
 - rescan-scsi-bus.sh
 - restart devfs
 - reboot with or without device plugged in
 - upgrade rescan-scsi-bus.sh
 - recompile kernel with patch by rescan-scsi-bus.sh author
 - install udev on /udev
 - install udev on /dev and disable devfs

...But there may of course be something obvious that I've missed.  I've been
running 2.6 kernels for a while, but haven't seen the burner work on it so
far.

I'm getting error messages when loading ohci1394 and sbp2, though:

bus ieee1394: add device fw-host0
bound device 'fw-host0' to driver 'ieee1394_host'
ohci1394: fw-host0: Unexpected PCI resource length of 1000!
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[40]  MMIO=[f5000000-f50007ff]  Max Packet=[2048]
bound device '0002:06:0e.0' to driver 'ohci1394'
bus ieee1394: add device 0001db0250003667
bound device '0001db0250003667' to driver 'ieee1394_node'
ieee1394: Node added: ID:BUS[0-00:1023]  GUID[0001db0250003667]
bus ieee1394: add device 000393fffe10d614
bound device '000393fffe10d614' to driver 'ieee1394_node'
ieee1394: Host added: ID:BUS[0-01:1023]  GUID[000393fffe10d614]
ieee1394: got invalid ack 252 from node 65535 (tcode 0)
bus ieee1394: add device 0001db0250003667-1
bus ieee1394: add device 0001db0250003667-0
bus type 'scsi' registered
SCSI subsystem initialized
sbp2: $Rev: 1096 $ Ben Collins <bcollins@debian.org>
bus ieee1394: add driver sbp2
scsi0 : SCSI emulation for IEEE-1394 SBP-2 Devices
ieee1394: sbp2: Error logging into SBP-2 device - login timed-out

Normally I'd say that "unexpected PCI resource length" was probably at the
root of the problem, but it seems strange to me that the devices gets
recognized properly if things go wrong at such a low level.  OTOH I'm way
out of my depth as it is...


Jeroen

