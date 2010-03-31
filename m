From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 31 Mar 2010 12:12:04 -0400
Message-ID: <4BB37454.8070808@interlog.com>
References: <Pine.LNX.4.44L0.1003311054500.1739-100000@iolanthe.rowland.org> <1270048801.16657.8.camel@localhost.localdomain>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39307 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142Ab0CaQML (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2010 12:12:11 -0400
In-Reply-To: <1270048801.16657.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Zeuthen <david@fubar.dk>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jonas Schwertfeger <jschwertfeger@gmail.com>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

David Zeuthen wrote:
> On Wed, 2010-03-31 at 10:56 -0400, Alan Stern wrote:
>> On Wed, 31 Mar 2010, Jonas Schwertfeger wrote:
>>
>>> Since this seems to have become a udev issue I'm brining the
>>> hotplug/udev list into the loop.
>>>
>>> A brief recap for the hotplug list readers: I'm experiencing issues
>>> with a USB 3.0 hard drive (Buffalo HD-HXU3) on kernel 2.6.32.9 with
>>> udev 151. When connected the device seems to be recognized and
>>> registered with xHCI and USB core correctly but then responds to a
>>> bulk transfer with a stall. We narrowed the issue down to udev by
>>> stopping the udev daemon, connecting the device and mounting it
>>> manually. If done this way the drive works fine. However, if udevd is
>>> running the device stalls. Below is an excerpt of the conversation
>>> involving the USB core, the USB storage and the SCSI list.
>>>
>>> Any idea what command (most likely coming from udev) could cause the
>>> drive to stall and what could be done about it?
>> More specifically, what program issues ATA-passthrough commands?  And 
>> what can be done to prevent it from doing so in cases where these 
>> commands cause the device to crash?
> 
> Stock udev comes with ata_id which I think may be invoked for this
> device (but I'm not sure). Try moving it out of the way?
> 
> On most distros, udisks (also known as DeviceKit-disks before the name
> was changed) is installed which runs a small program that uses
> libatasmart to determine if the device is SMART capable:
> 
> http://cgit.freedesktop.org/udisks/tree/src/probers/udisks-probe-ata-smart.c
> 
> and this definitely runs for this USB device assuming removable is 0 in
> sysfs. Perhaps http://bugs.freedesktop.org/show_bug.cgi?id=25673 is
> related? Maybe try with the latest libatasmart?

Since the sequence of commands was IDENTIFY DEVICE,
SET FEATURES then IDENTIFY DEVICE again my guess is
that SET FEATURES caused the problem. Why would a
program called ata_id try to change the state of
the device?

The SCSI subsystem has been very careful to call
the minimum number of "safe" commands when setting
up storage devices. Bitter experience has taught us
that when one strays beyond what another OS from
Oregon does, nasty things could happen.


I also suspect udev (more likely one of its helpers)
is behind a bizarre sequence of commands sent to a
storage device when it is closed. These commands
make smartmontools and other tools that attempt
to spin down an ATA disk useless.
[As an extra note, if the device is opened O_RDONLY
the "extra" commands on close() don't arrive.]

Doug Gilbert
