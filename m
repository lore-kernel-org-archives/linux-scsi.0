From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Spin down disk at suspend/shotdown
Date: Thu, 03 Apr 2008 17:10:22 +0200
Message-ID: <47F4F35E.50309@s5r6.in-berlin.de>
References: <20080403064910.GB7716@dose.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:43499 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758229AbYDCPK4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 11:10:56 -0400
In-Reply-To: <20080403064910.GB7716@dose.home.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tino Keitel <tino.keitel+firewire@tikei.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org

(Added Cc: LSML)

Tino Keitel wrote at linux1394-user:
> with my SATA and USB drives, I used to use the manage_start_stop setting
> to make the disks spin down at suspend and shutdown. Here is an example
> for my USB disk:
> 
> $ echo 1 > /sys/class/scsi_disk/4\:0\:0\:0/manage_start_stop
> 
> This doesn't work with my firewire drive. The disk doesn't spin down.
> Of cause, I use the correct entry in /sys/class/scsi_disk/.

Which kernel?
Which disk?
Are there messages in dmesg which relate to this?

The sd driver uses the START STOP UNIT command if manage_start_stop is set.

> The hardware enclosure that I use for firewire also has a USB
> interface. If I use it over USB, then the disk spins down.
> 
> Is this expected to work in general with firewire, so it would be a
> hardware issue? Or is this not yet supported?

This is not a matter of USB vs. FireWire attachment.  It is a matter of
which command set the firmware of the device supposedly supports.  By
far most FireWire HDDs implement the RBC command set, and this one
includes mandatory START STOP UNIT support.  However, many firmwares
don't actually comply with SCSI, they are just weak attempts on doing so.

Command set conformance is claimed via the INQUIRY data which are logged
in dmesg right after the FireWire driver logged in into the disk.

Furthermore, USB + FireWire dual interface devices almost always have
entirely separate firmwares for each interface, even if both interfaces
are implemented by a single chip.  Therefore it is possible that these
firmwares in the very same device fundamentally differ WRT their bugs.

> To test this without suspending or shutting down the computer, I think
> it's possible to use the eject command. When I use USB, eject spins
> down the drive, too. When I use firewire, it doesn't.

I think the "eject" utility emits different commands, depending on the
version of the utility and how it was compiled (I heard it can happen
that there is Gnome stuff compiled in...) and what type of device it
thinks it is run for.

In any case, it is at least somewhat likely that "eject" sends the same
commands to the disk whether it is USB attached or FireWire attached.
You could check which commands are sent by switching on SCSI command
logging.  (Alas I don't have my notes with me to tell you how to switch
on SCSI command logging.)

But more controlled than "eject" is "sg_start", typically found in a
package called sg3utils.  This does exactly what the sd driver does:  It
sends the START STOP UNIT command.
-- 
Stefan Richter
-=====-==--- -=-- ---==
http://arcgraph.de/sr/
