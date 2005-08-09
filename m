From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Synchronizing scsi_remove_host and the error handler
Date: Tue, 09 Aug 2005 21:37:01 +0200
Message-ID: <42F905DD.3090504@s5r6.in-berlin.de>
References: <Pine.LNX.4.44L0.0508091014030.4643-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:23510 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932276AbVHIThI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Aug 2005 15:37:08 -0400
In-Reply-To: <Pine.LNX.4.44L0.0508091014030.4643-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>

Alan Stern wrote:
> On Tue, 9 Aug 2005, Stefan Richter wrote:
>>But as long as files are open etc., scsi high-level drivers are
>>'in use', cannot be detached, and scsi_remove_host does not return.
>>
>>Or that's what I assumed so far.
> 
> No, that's not right.  scsi_remove_host _can_ return while the high-level
> drivers are still in use -- just think about what happens when you unplug
> a USB storage device without unmounting it first.  I'm not sure what you 
> mean about "detach"ing high-level SCSI drivers.  The high-level drivers 
> are notified about the device removal; they drop their references and 
> return.  They can still submit commands if they want, but all such 
> submissions will fail in the SCSI core.

"detach" = shutdown, remove (from a device)

I don't know what happens if USB storage devices are unplugged with 
filesystems still mounted. But this is what happens with FireWire 
storage devices:
  - ieee1394 core triggers remove function of sbp2 via LKDM
    (Linux Kernel Device Model)
  - sbp2 enters scsi_remove_host (each SBP-2 device has its own host)
  - scsi_remove_host enters scsi_remove_target enters scsi_remove_device
    for each target and device
  - scsi_remove_device triggers all sorts of shutdown functions of scsi's
    highlevel drivers, via LKDM
  - highlevel runs all sorts of last traffic; in case of a mounted
    filesystem of a harddisk you see messages like 'rejecting I/O to
    device being removed', 'Buffer I/O error on device...', errors
    from the filesystem, and finally 'Synchronizing SCSI cache for...'
    which fails.
    Right after this, highlevel's (i.e. sd_mod's) shutdown callbacks
    exit.
  - scsi_remove_device does boring stuff, exits
  - scsi_remove_target does boring stuff, exits
  - scsi_remove_host does boring stuff, exits
  - sbp2 is back in control and removes its own stuff

Well, the parts in sbp2 itself changed a bit lately, but that is not 
relevant now. My point is, scsi_remove_device (and thereby scsi 
highlevel's shutdown callbacks) are executed and finished before 
scsi_remove_host is finished.

You are right though that there are still situations (and it seems 
detaching a device with mounted filesystem is among them) where all 
these remove functions are completed but the scsi_eh thread still stays 
behind, placidly sleeping.

And now we are right back on the subject. :-)
-- 
Stefan Richter
-=====-=-=-= =--- -=--=
http://arcgraph.de/sr/
