From: David Zeuthen <david@fubar.dk>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 31 Mar 2010 11:20:01 -0400
Message-ID: <1270048801.16657.8.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.1003311054500.1739-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-hotplug-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1003311054500.1739-100000@iolanthe.rowland.org>
Sender: linux-hotplug-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jonas Schwertfeger <jschwertfeger@gmail.com>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, dgilbert@interlog.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-03-31 at 10:56 -0400, Alan Stern wrote:
> On Wed, 31 Mar 2010, Jonas Schwertfeger wrote:
> 
> > Since this seems to have become a udev issue I'm brining the
> > hotplug/udev list into the loop.
> > 
> > A brief recap for the hotplug list readers: I'm experiencing issues
> > with a USB 3.0 hard drive (Buffalo HD-HXU3) on kernel 2.6.32.9 with
> > udev 151. When connected the device seems to be recognized and
> > registered with xHCI and USB core correctly but then responds to a
> > bulk transfer with a stall. We narrowed the issue down to udev by
> > stopping the udev daemon, connecting the device and mounting it
> > manually. If done this way the drive works fine. However, if udevd is
> > running the device stalls. Below is an excerpt of the conversation
> > involving the USB core, the USB storage and the SCSI list.
> > 
> > Any idea what command (most likely coming from udev) could cause the
> > drive to stall and what could be done about it?
> 
> More specifically, what program issues ATA-passthrough commands?  And 
> what can be done to prevent it from doing so in cases where these 
> commands cause the device to crash?

Stock udev comes with ata_id which I think may be invoked for this
device (but I'm not sure). Try moving it out of the way?

On most distros, udisks (also known as DeviceKit-disks before the name
was changed) is installed which runs a small program that uses
libatasmart to determine if the device is SMART capable:

http://cgit.freedesktop.org/udisks/tree/src/probers/udisks-probe-ata-smart.c

and this definitely runs for this USB device assuming removable is 0 in
sysfs. Perhaps http://bugs.freedesktop.org/show_bug.cgi?id=25673 is
related? Maybe try with the latest libatasmart?

Thanks,
David


