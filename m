From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: Handling erroneous READ CAPACITY response in
 sd.c
Date: Fri, 5 Nov 2004 16:38:07 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0411051632440.1015-100000@ida.rowland.org>
References: <20041105184402.GB10912@apps.cwi.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:24324 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261187AbUKEViI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2004 16:38:08 -0500
In-Reply-To: <20041105184402.GB10912@apps.cwi.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <Andries.Brouwer@cwi.nl>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

On Fri, 5 Nov 2004, Andries Brouwer wrote:

> I have not been following the discussion but happen to see this
> fragment. Probably the below is irrelevant.

As you may have surmised, this discussion concerns how we should handle 
devices that return the total number of sectors for READ CAPACITY rather 
than the highest sector number.

> We used to have entries in unusual_devices - the above sounds
> as if it is proposed to move such entries to a SCSI blist.
> I don't see why that is progress.

No.  I said that it _could_ be moved to a SCSI blist but would probably be
better off remaining in unusual_devices.  What should be changed is the
way we handle these devices.  Right now usb-storage alters the data sent
by the device, before anyone else can see it.  My proposal is that
usb-storage pass the data unchanged and sd_read_capacity() change the
value it gets if the device is known to be bad.

> Concerning the size of a disk: if one claims that the disk is one
> sector shorter than it really is, in most cases no great harm is done.
> However, certain partition tables and RAID configuration info
> lives on the last sector or the last cylinder of a disk.
> Even worse, sometimes this information is read or written by
> the hardware.
> Thus, there exist situations where it is really bad when
> the last sector of a disk disappears from sight.

That is precisely why we need to recognize which devices do this wrongly 
and handle them specially while leaving everything else unchanged.

Alan Stern

